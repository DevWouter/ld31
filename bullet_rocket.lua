HomingRocket = Bullet.new_type()
HomingRocket.name = "Rocket"

function HomingRocket.reload_time(level)
  return 0.5
end

function HomingRocket.energy_drain(level)
  return 5
end

function HomingRocket:on_create()
  self.adjust_factor = 1
  self.smokes = {}
end

function HomingRocket:update(dt, targets)
  -- Remove old smoke
  local remove_smokes = {}
  for i,v in pairs(self.smokes) do
    v.time = v.time + dt
    if v.time > 0.5 then
      table.insert(remove_smokes, i)
    end
  end

  for i,v in pairs(remove_smokes) do
      table.remove(self.smokes, remove_smokes[#remove_smokes-(i-1)])
  end

  if self.damage_created ~= 0 then
    return
  end

  self.x = self.x + dt * self.vel_x
  self.y = self.y + dt * self.vel_y

  -- Add smoke particle
  table.insert(self.smokes, {x = self.x + self.w / 2, y = self.y + self.h / 2, time = 0})

  local own_center = math.get_center(self)

  local closest_target = nil
  local distance_target = nil
  for _,target in pairs(targets) do
    local target_center = math.get_center(target)
    local current_distance = math.get_distance(own_center, target_center)
    if distance_target == nil or distance_target > current_distance then
      closest_target = target
      distance_target = current_distance
    end
  end

  if closest_target ~= nil then
    -- Modify the velocity based on the target
    local target_center = math.get_center(closest_target)
    local home_vector = { 
      x = target_center.x - self.x,
      y = target_center.y - self.y
    }

    local vel = math.sqrt(self.vel_x * self.vel_x + self.vel_y * self.vel_y) / 100
    home_vector.x = home_vector.x / vel
    home_vector.y = home_vector.y / vel
    local focus_speed = self.adjust_factor * dt
    local neg_focus = 1 - focus_speed
    self.vel_x = self.vel_x * neg_focus + home_vector.x * focus_speed
    self.vel_y = self.vel_y * neg_focus + home_vector.y * focus_speed

  end

  self.life_time = self.life_time - dt
end

function HomingRocket:apply_damage(target)
  if self.damage_created > 0 then
    return
  end
  target.health = target.health - self.damage
  self.damage_created = self.damage_created + self.damage
end

function HomingRocket:should_remove()
  return (self.life_time <= 0 and self.damage_created == 0) or (self.damage_created > 0 and #self.smokes == 0)
end

function HomingRocket:draw()
  for _,v in pairs(self.smokes) do
    if v.time >= 0 then
      love.graphics.push()
      local original_blendmode = love.graphics.getBlendMode()
      love.graphics.setBlendMode("alpha")
      love.graphics.setColor({128,128,128, 120 - 120 * (v.time / 0.5)})
      local frame = Sprites.rocket_smoke:get_frame(v.time + math.random(0,2))

      love.graphics.translate(v.x - frame.width / 2, v.y - frame.height/2)
      love.graphics.draw(frame.image)

      love.graphics.setBlendMode(original_blendmode)
      love.graphics.pop()
    end
  end
  draw_quad(self.x - self.w/2, self.y - self.h/2, self.w, self.h, {0, 120, 255}, {0, 120, 255})
end
