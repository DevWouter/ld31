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
      , vel_x = 0 -- Fire up
      , life_time = 5
      , damage = 5
      , damage_created = 0
    }
    setmetatable( newinst, class_mt )
    newinst:on_create()
    return newinst
  end

  return setmetatable(new_class, {__index = Enemy})
end

function Bullet:on_create()
end

function Bullet:update(dt, targets)
end

function Bullet:apply_damage(target)
end

function Bullet:should_remove()
end

require('bullet_cannon')
require('bullet_rocket')
require('bullet_laser')
require('bullet_blackhole')

