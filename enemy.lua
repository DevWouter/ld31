require('bullet')

ENEMY_Y_POS = 150 -- Default fly height

Enemy = {}
Enemy.__index = Enemy

function Enemy.new_type()
   -- Create the table and metatable representing the class.
  local new_class = {}
  local class_mt = { __index = new_class }

  -- Note that this function uses class_mt as an upvalue, so every instance
  -- of the class will share the same metatable.
  --
  function new_class:new()
    local newinst = { nil
      , x = 0
      , y = math.random(70, 250)
      , w = 10
      , h = 10
      , health = 99.999
      , is_death = false
    }
    setmetatable( newinst, class_mt )
    newinst:on_create()
    return newinst
  end

  return setmetatable(new_class, {__index = Enemy})
end

-- This function is called after creation to set some additional 
-- parameters.
function Enemy:on_create()
end

function Enemy:getArea() 
  return {x = self.x, y = self.y, w = self.w, h = self.h}
end

function Enemy:health_str()
  return string.format("%.0f", self.health)
end

function Enemy:update(dt, bullet_list)
end

function Enemy:draw()
end