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

  local recovery_speed = self:get_shield_recovery() * dt
  self.shield_gen_timeout = self.shield_gen_timeout - recovery_speed
  if self.shield_gen_timeout < 0 and self.energy > self:get_shield_drain() then
    -- Generate a shield
    local shield_plate = ShieldPlate.new()
    shield_plate.x = (self.x + self.w / 2)
    shield_plate.y = (self.y)
    shield_plate.vel_x = math.sin(self.shields_fired) * 20
    shield_plate.vel_y = shield_plate.vel_y  - math.cos(self.shields_fired) 
    table.insert(shield_list, shield_plate)
    self.shield_gen_timeout = 0.05
    self.shields_fired = self.shields_fired + 1
    self.energy = self.energy - self:get_shield_drain()
  end

end

function ShieldBuilding:draw()
  local fill_color = {120, 120, 120}
  local line_color = {255, 0, 0}  
  draw_quad( self.x, self.y, self.w, self.h, line_color, fill_color)
  if self.health < self.max_health then
    love.graphics.setColor({0,255,255})
    love.graphics.printf(self:health_str(), self.x, self.y, self.w, "center")
  end
end