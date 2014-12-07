RepairBuilding = Building.new_type()
RepairBuilding.name = "Repair"

-- This function is called after creation to set some additional 
-- parameters.
function RepairBuilding:on_create()
  self.is_death = false
end


function RepairBuilding:get_repair_speed()
  return 1 -- per second
end

function RepairBuilding:update(dt, sector, bullet_list, targets)
  local repair_speed = self:get_repair_speed()
  sector.health = sector.health + repair_speed * sector.humans * dt
  if sector.health > sector.max_health then
    sector.health = sector.max_health
  end

  if self.health < 0 then
    self.is_death = true
  end
end

function RepairBuilding:draw()
  local fill_color = {120, 120, 120}
  local line_color = {255, 0, 0}  
  draw_quad( self.x, self.y, self.w, self.h, line_color, fill_color)
  if self.health < self.max_health then
    love.graphics.setColor({0,255,255})
    love.graphics.printf(self:health_str(), self.x, self.y, self.w, "center")
  end
end