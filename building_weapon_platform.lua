-- WeaponPlatform
WeaponPlatform = Building.new_type()
WeaponPlatform.name = "WeaponPlatform"

-- This function is called after creation to set some additional 
-- parameters.
function WeaponPlatform:on_create()
  self.is_death = false
  self.weapon = nil -- here we store the weapon
  self.is_firing = true
  self.energy = 0
  self.max_energy = 100
  self.health = self.max_health
end

function WeaponPlatform:update(dt, sector, bullet_list, targets)
  -- Fire weapon
  local weapon = self.weapon
  weapon.delay_fire = weapon.delay_fire - dt
  if weapon.health >= weapon.max_health and self.is_firing and weapon.delay_fire < 0 then
    local energy_drain = weapon.bullet_type.energy_drain(weapon.level)
    if self.energy >= energy_drain then
      local bullet = weapon.bullet_type.new()
      bullet.x, bullet.y = self.x + (self.w / 2), self.y - bullet.h
      table.insert(bullet_list, bullet)
      weapon.delay_fire = weapon.bullet_type.reload_time(weapon.level)
      self.energy = self.energy - energy_drain -- Remove the energy
    end
  end
end

function WeaponPlatform:draw()
  local fill_color = {120, 120, 120}
  local line_color = {255, 0, 0}  
  draw_quad( self.x, self.y, self.w, self.h, line_color, fill_color)
  if self.health < self.max_health then
    love.graphics.setColor({0,255,255})
    love.graphics.printf(self:health_str(), self.x, self.y, self.w, "center")
  end
end