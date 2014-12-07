-- Enemy saucer
require('enemy')
EnemySaucer = Enemy.new_type()

function EnemySaucer:on_create()
  self.is_firing = false
  self.delay_fire = 0
  self.reload_time = 1.8
  self.vel_x = 20
  self.left_bound = 0
  self.right_bound = SECTOR_WIDTH
end

function EnemySaucer:update(dt, bullet_list, level)
  self.right_bound = level:get_total_width()
  if self.is_death then
    return
  end
  
  local hw = self.w / 2
  self.x = self.x + self.vel_x * dt
  if self.x < self.left_bound then
    self.x = self.left_bound
    self.vel_x = math.abs(self.vel_x)
  elseif self.x > (self.right_bound - hw) then
    self.x = self.right_bound - hw
    self.vel_x = -math.abs(self.vel_x)
  end

  self.delay_fire = self.delay_fire - dt
  if self.is_firing and self.delay_fire < 0 then
    local bullet = Cannonball.new()
    bullet.x, bullet.y = self.x + (self.w / 2), self.y + bullet.h
    bullet.vel_y = 100 -- Fire down
    table.insert(bullet_list, bullet)
    self.delay_fire = self.reload_time
  end

  if not self.is_death and self.health < 0 then
    self.is_death = true
    Audio.play(Audio.sounds.enemy_death)
  end 
end

function EnemySaucer:draw()
  local fill_color = {150, 150, 150}
  local line_color = {140, 140, 140}  
  draw_quad( self.x, self.y, self.w, self.h,line_color , fill_color)
end