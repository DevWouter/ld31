Blackhole = Bullet.new_type()
Blackhole.name = "Nuke"
BLACKHOLE_SCALE = 2
function Blackhole.reload_time(level)
  return 10
end

function Blackhole.energy_drain(level)
  return 33
end

function Blackhole:update(dt)
  self.y = self.y + dt * self.vel_y
  self.x = self.x + dt * self.vel_x
  self.life_time = self.life_time - dt

  if not self.is_exploding then
    -- Reduce the speed
    local target_reduction = 0.37
    local focus_speed = target_reduction * dt
    local neg_focus = 1 - focus_speed
    -- self.vel_x = self.vel_x * neg_focus + home_vector.x * focus_speed
    self.vel_y = self.vel_y * neg_focus + 0 * focus_speed
    if math.abs(self.vel_y) < 8 then -- When slow enough also detonate
      self:start_exploding()
    end
  end

  if self.is_exploding then
    local remove_explosions = {}
    local explosion_length = Sprites.blackhole.total_time
    for i,v in pairs(self.explosions) do
      v.frame_time = v.frame_time + dt
      if v.frame_time > explosion_length then
        table.insert(remove_explosions, i)
      end
    end

    for i,v in pairs(remove_explosions) do
      table.remove(self.explosions, remove_explosions[#remove_explosions-(i-1)])
    end
  end
end

function Blackhole:start_exploding()
  self.is_exploding = true
  self.vel_y = 0 
  self.vel_x = 0
  for i=1,5 do
    for j=1,2 do
      local explosion = {x = self.x + self.w/2, y = self.y + self.h / 2, frame_time = math.random() - ((i - 1) * 0.33)}
      explosion.x = explosion.x + math.random(-60, 60)
      explosion.y = explosion.y + math.random(-10, 10)
      table.insert(self.explosions, explosion)
    end
  end
end

function Blackhole:test_hit(target, dt)
  if self.is_exploding then
    -- Let the explosions perform damage
    local frame_collection = Sprites.blackhole
    local is_hitting = false
    local shortest_distance = 99999999
    for _,v in pairs(self.explosions) do
      if v.frame_time > 0 then
        local bb = {}
        local distance = 99999999
        local lishit = false
        bb.x = v.x - (frame_collection.frame_width*BLACKHOLE_SCALE) / 2
        bb.y = v.y - (frame_collection.frame_height*BLACKHOLE_SCALE) / 2
        bb.w = frame_collection.frame_width * BLACKHOLE_SCALE
        bb.h = frame_collection.frame_height * BLACKHOLE_SCALE
        lishit, distance = math.test_box_intersection(bb, target)
        if lishit and distance < shortest_distance then
          shortest_distance = distance
          is_hitting = true
        end
      end
    end
    if is_hitting then
        local max_damage_dist_x = frame_collection.frame_width * BLACKHOLE_SCALE
        local max_damage_dist_y = frame_collection.frame_height * BLACKHOLE_SCALE
        local max_damage_range = math.sqrt(max_damage_dist_x * max_damage_dist_x + max_damage_dist_y * max_damage_dist_y)
        local effect_ratio =  (shortest_distance / max_damage_range)
        if effect_ratio > 1 then effect_ratio = 1 elseif effect_ratio < 0 then effect_ratio = 0 end
        local apply_damage = self.damage * (1-effect_ratio)
        target.health = target.health - apply_damage * dt
      end
  end

  if not self.is_exploding then
    if math.test_box_intersection(self, target) then
      self:start_exploding()
    end
  end
end

function Blackhole:should_remove()
  return self.is_exploding and #self.explosions == 0 
end

function Blackhole:on_create()
  self.is_exploding = false
  self.explosions = {}
end

function Blackhole:draw()
   draw_quad(self.x - self.w/2, self.y - self.h/2, self.w, self.h, {0, 120, 255}, {0, 120, 255})

  -- Draw explosion
  if self.is_exploding then
    for _,explosion in pairs(self.explosions) do
      if explosion.frame_time > 0 then
        
        love.graphics.push()
        local original_blendmode = love.graphics.getBlendMode()
        love.graphics.setBlendMode("premultiplied")
        love.graphics.setColor({128,128,128, 100})

        local frame = Sprites.blackhole:get_frame(explosion.frame_time)
        love.graphics.translate(explosion.x - frame.width / 2, explosion.y - frame.height/2)
        love.graphics.scale(BLACKHOLE_SCALE, BLACKHOLE_SCALE) 
        love.graphics.draw(frame.image)

        love.graphics.setBlendMode(original_blendmode)
        love.graphics.pop()
      end
    end
  end
end