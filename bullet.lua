-- require('bullet')

Bullet = {}
Bullet.__index = Bullet

function Bullet.new_type()
   -- Create the table and metatable representing the class.
  local new_class = {}
  local class_mt = { __index = new_class }

  -- Note that this function uses class_mt as an upvalue, so every instance
  -- of the class will share the same metatable.
  --
  function new_class:new()
    local newinst = { nil
      , x = 0
      , y = 0
      , w = 4
      , h = 4
      , vel_y = -100 -- Fire up
      , vel_x = 0 -- Fire straight
      , life_time = 5
      , damage = 5
      , damage_created = 0
    }
    setmetatable( newinst, class_mt )
    newinst:on_create()
    return newinst
  end

  return setmetatable(new_class, {__index = Bullet})
end

function Bullet:on_create()
end

function Bullet:update(dt, targets)
end

function Bullet:apply_damage(target)
end

function Bullet:test_hit(target, dt)
  if math.test_box_intersection(self, target) then
    self:apply_damage(target, dt)
  end
end

function Bullet:should_remove()
  return self.life_time <= 0 
end

function Bullet:draw()
  draw_quad(self.x - self.w/2, self.y - self.h/2, self.w, self.h, {0, 120, 255}, {0, 120, 255})
end

require('bullet_cannon')
require('bullet_rocket')
require('bullet_laser')
require('bullet_blackhole')

