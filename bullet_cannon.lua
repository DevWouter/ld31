Cannonball = Bullet.new_type()
Cannonball.name = "Cannon"
function Cannonball.reload_time(level)
  return 0.2
end

function Cannonball.energy_drain(level)
  return 1
end

function Cannonball:update(dt)
  self.y = self.y + dt * self.vel_y
  self.x = self.x + dt * self.vel_x
  self.life_time = self.life_time - dt
end

function Cannonball:apply_damage(target)
  target.health = target.health - self.damage
  self.damage_created = self.damage_created + self.damage
end

function Cannonball:should_remove()
  return self.damage_created > 0
end

function Cannonball:on_create()
  end