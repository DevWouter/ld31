
SHIELD_Y_POS = 300

ShieldPlate = {}
ShieldPlate.__index = ShieldPlate

function ShieldPlate.new()
  local default_table = { nil
    , x = 0
    , y = SHIELD_Y_POS
    , w = 10
    , h = 4
    , vel_x = 0
    , vel_y = -30
    , health = 10
    , max_health = 100
    , is_death = false
  }

  return setmetatable(default_table, ShieldPlate)
end

function ShieldPlate:getArea() 
  return {x = self.x, y = self.y, w = self.w, h = self.h}
end

function ShieldPlate:update(dt, other_plates)
  self.x = self.x + self.vel_x * dt
  self.vel_y = self.vel_y + math.sqrt(dt)
  if self.vel_y > 0 then
    self.vel_y = 0
  end
  self.y = self.y + self.vel_y * dt
  self.health = self.health - dt
  if self.health < 0 then
    self.is_death = true
  end
end

function ShieldPlate:draw()
  draw_quad( self.x, self.y, 10, self.h,nil, {0, 0, 120, 120})
end