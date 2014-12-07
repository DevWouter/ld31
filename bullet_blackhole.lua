Blackhole = Bullet.new_type()
Blackhole.name = "Nuke"
function Blackhole.reload_time(level)
  return 0.2
end

function Blackhole.energy_drain(level)
  return 1
end

function Blackhole:update(dt)
  self.y = self.y + dt * self.vel_y
  self.x = self.x + dt * self.vel_x
  self.life_time = self.life_time - dt
end

function Blackhole:apply_damage(target)
  target.health = target.health - self.damage
  self.damage_created = self.damage_created + self.damage
end

function Blackhole:should_remove()
  return self.damage_created > 0
end

function Blackhole:on_create()
end