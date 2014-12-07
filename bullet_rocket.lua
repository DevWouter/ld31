HomingRocket = Bullet.new_type()
HomingRocket.name = "Rocket"

function HomingRocket.reload_time(level)
  return 0.5
end

function HomingRocket.energy_drain(level)
  return 5
end

function HomingRocket:on_create()
  self.adjust_factor = 1.5
end

function HomingRocket:update(dt, targets)
  self.x = self.x + dt * self.vel_x
  self.y = self.y + dt * self.vel_y

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
  target.health = target.health - self.damage
  self.damage_created = self.damage_created + self.damage
end

function HomingRocket:should_remove()
  return self.damage_created > 0
end
