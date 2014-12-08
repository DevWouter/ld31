Laserbeam = Bullet.new_type()
Laserbeam.name = "Laser"
function Laserbeam.reload_time(level)
  return 0.1
end

function Laserbeam.energy_drain(level)
  return 2
end

function Laserbeam:update(dt)
  -- Thinking about giving each laser_location an age.
  local remove_locations = {}
  for i,v in pairs(self.laser_locations) do
    v.age = v.age - (dt)
    if v.age < 0 then
      table.insert(remove_locations, i)
    end
  end

  for i,v in pairs(remove_locations) do
    table.remove(self.laser_locations, remove_locations[#remove_locations-(i-1)])
  end

  if self.life_time > 0 then
    for step=1, self.laser_steps do
      self.y = self.y + dt * self.vel_y
      self.x = self.x + dt * self.vel_x
      self.life_time = self.life_time - dt
      table.insert(self.laser_locations,  {x = self.x, y = self.y, w = self.w, h = self.h, age = 0.1, max_age = self.life_time})
    end
  end
end

function Laserbeam:test_hit(target)
  for _,subloc in pairs(self.laser_locations) do
    if math.test_box_intersection(subloc, target) then
      self:apply_damage(target)
      return -- Only damage once.
    end
  end
end

function Laserbeam:apply_damage(target)
  target.health = target.health - self.damage
  self.damage_created = self.damage_created + self.damage
end

function Laserbeam:should_remove()
  return self.life_time <= 0 and #self.laser_locations == 0
end

function Laserbeam:on_create()
  self.laser_steps = 20
  self.damage = 1
  self.life_time = 3
  self.vel_x = math.sin((love.math.random(-100, 100)/ 200.0)* 2 * math.pi) * 10
  self.laser_locations = {}
end

function Laserbeam:draw()
  local original_blendmode = love.graphics.getBlendMode()
  love.graphics.setBlendMode("premultiplied")
  for _,v in pairs(self.laser_locations) do
    local r = (v.age / v.max_age) * 255 
    draw_quad(v.x - v.w/2, v.y - v.h/2, v.w, v.h, nil, {r, 0, 100, 255})
  end
  love.graphics.setBlendMode(original_blendmode)
end