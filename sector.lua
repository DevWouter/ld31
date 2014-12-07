
-- Sector
Sector = {}
Sector.__index = Sector

function Sector.new(game)
  assert(game, "sector requires a game variable")
  local default_table = { nil
    , health = 100, max_health = 100
    , x = 0
    , y = SECTOR_Y
    , w = SECTOR_WIDTH
    , h = 10
    , humans = 0
    , max_humans = 1
    , game = game
  }

  return setmetatable(default_table, Sector)
end

function Sector:draw()
  draw_quad(self.x, self.y, self.w, self.h, {120,120,120}, {240, 240, 240})
  if self.game.debug then
    local area = {x = self.x, y = self.y, w = self.w, h = self.h}
    local health_text = 
      ' A: ' .. string.format("%.1f", self.health) .. '/' .. tostring(self.max_health)
    print_center_of_area(health_text, area)
  end
end

function Sector:get_power_output()
  return 3
end

function Sector:update(dt, buildings)
  local to_build = {}
  local to_power = {}
  local current_power_output = self:get_power_output() * dt
  for _,v in pairs(buildings) do
    if v.health < v.max_health then
      table.insert(to_build, v)
    end
    if (v.energy) then
      table.insert(to_power, v)
    end
    if v.generate_power or false then
      current_power_output = current_power_output + v:generate_power() * dt
    end
  end

  -- 
  if #to_power > 0 then 
    local power_add_per_building = current_power_output / #to_power
    for _,v in pairs(to_power) do
      v.energy = v.energy + power_add_per_building
      if v.energy > v.max_energy then v.energy = v.max_energy end
    end
  end

  if self.humans > 0 then
    local health_increase = (self.humans / #to_build) * dt
    for _,v in pairs(to_build) do
      v.health = v.health + health_increase
      if v.health > v.max_health then
        v.health = v.max_health
      end
    end
  end

end