require('spread_configuration')
-- HELPER FUNCTION FOR SHIELD GENERATION
function generate_shield(self, shield_list)
  spreads = self.shield_spread
  for _,spread in pairs(spreads) do
    if spread ~=nil then
      local shield_plate = ShieldPlate.new()
      shield_plate.x = (self.x + self.w / 2) - shield_plate.w / 2
      shield_plate.y = (self.y)

      shield_plate.vel_x, shield_plate.vel_y = shield_plate.vel_x + spread.vx, shield_plate.vel_y + spread.vy
      shield_plate.x, shield_plate.y = shield_plate.x + spread.x, shield_plate.y + spread.y

      table.insert(shield_list, shield_plate)
    end
  end
  
  self.shield_gen_timeout = 0.50
  self.shields_fired = self.shields_fired + 1
  self.energy = self.energy - self:get_shield_drain()
end


SHIELD_Y_POS = 300

ShieldPlate = {}
ShieldPlate.__index = ShieldPlate

function ShieldPlate.new()
  local default_table = { nil
    , x = 0
    , y = SHIELD_Y_POS
    , w = 50
    , h = 4
    , vel_x = 0
    , vel_y = -20
    , travel_x = 0
    , max_travel_x = 150
    , last_health = 10
    , health = 10
    , max_health = 100
    , is_death = false
  }

  return setmetatable(default_table, ShieldPlate)
end

function ShieldPlate:getArea() 
  return {x = self.x, y = self.y, w = self.w, h = self.h}
end

function ShieldPlate:update(dt, other_plates)
  local change_x = self.vel_x * dt
  self.x = self.x + change_x
  self.travel_x = self.travel_x + math.abs(change_x)
  self.vel_y = self.vel_y + math.sqrt(dt)
  if self.vel_y > 0 then
    self.vel_y = 0
  end
  self.y = self.y + self.vel_y * dt

  -- Check if the health was modified before we abuse it as countdown.
  if self.last_health > self.health then
    self.is_death = true
  end

  self.health = self.health - dt
  self.last_health = self.health

  if self.health < 0  or self.travel_x > self.max_travel_x then
    self.is_death = true
  end
end

function ShieldPlate:draw()
  draw_quad( self.x, self.y, self.w, self.h, {40, 40, 240, 250}, {0, 0, 120, 250})
end

