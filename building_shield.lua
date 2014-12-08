require('shield_plate')
ShieldBuilding = Building.new_type()
ShieldBuilding.name = "Shield Gen"

-- This function is called after creation to set some additional 
-- parameters.
function ShieldBuilding:on_create()
  self.is_death = false
  self.shield_gen_timeout = 0
  self.shields_fired = 0
  self.energy = 10
  self.max_energy = 100
  self.shield_spread = SpreadConfiguration.building_shields
  self.time_alive = 0
end

function ShieldBuilding:get_shield_drain()
  return 2
end

function ShieldBuilding:get_shield_recovery()
  return 0.2 -- per second
end

function ShieldBuilding:update(dt, sector, bullet_list, targets, shield_list)

  if self.health < 0 then
    self.is_death = true
  end

  if self.health < self.max_health then
    return
  end

  self.time_alive = self.time_alive + dt

  local recovery_speed = self:get_shield_recovery() * dt
  self.shield_gen_timeout = self.shield_gen_timeout - recovery_speed
  if self.shield_gen_timeout < 0 and self.energy > self:get_shield_drain() then
    -- Generate a shield
    generate_shield(self, shield_list)
  end

end

function ShieldBuilding:draw()
  local fill_color = {120, 120, 120}
  local line_color = {255, 0, 0}  
  local current_frame = Sprites.shield:get_frame(self.time_alive)

  love.graphics.push()
  love.graphics.setColor({255,255,255})
  love.graphics.translate(self.x, self.y)
  love.graphics.draw(current_frame.image)
  love.graphics.pop()


  if self.health < self.max_health then
    love.graphics.setColor({0,255,255})
    love.graphics.printf(self:health_str(), self.x, self.y, self.w, "center")
  end
end