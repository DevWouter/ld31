Cannonball = Bullet.new_type()
Cannonball.name = "Cannon"
function Cannonball.reload_time(level)
  return 0.2
end

function Cannonball.energy_drain(level)
  return 0
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

function Cannonball:should_remove( )
    return self.damage_created > 0
end

function Cannonball:on_create()
  self.life_time = 3
  self.animation_frame = math.random(1, #Sprites.cannon.frames)
end

function Cannonball:draw()
  love.graphics.push()
  local original_blendmode = love.graphics.getBlendMode()
  love.graphics.setBlendMode("premultiplied")
  love.graphics.setColor({128,128,128, 100})
  local frame = Sprites.cannon:get_frame_by_index(self.animation_frame)

  love.graphics.translate(self.x - frame.width / 2, self.y - frame.height/2)
  love.graphics.draw(frame.image)

  love.graphics.setBlendMode(original_blendmode)
  love.graphics.pop()
  -- draw_quad(self.x - self.w/2, self.y - self.h/2, self.w, self.h, {0, 120, 255}, {0, 120, 255})
end