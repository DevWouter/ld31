Laserbeam = Bullet.new_type()
Laserbeam.name = "Laser"
function Laserbeam.reload_time(level)
  return 0.2
end

function Laserbeam.energy_drain(level)
  return 1
end

function Laserbeam:update(dt)
  self.y = self.y + dt * self.vel_y
  self.x = self.x + dt * self.vel_x
  self.life_time = self.life_time - dt
end

function Laserbeam:apply_damage(target)
  target.health = target.health - self.damage
  self.damage_created = self.damage_created + self.damage
end

function Laserbeam:should_remove()
  return self.damage_created > 0
end

function Laserbeam:on_create()
end