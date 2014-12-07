BUILDING_Y_POS = 324

Building = {}
Building.__index = Building

function Building.new_type()
   -- Create the table and metatable representing the class.
  local new_class = {}
  local class_mt = { __index = new_class }

  -- Note that this function uses class_mt as an upvalue, so every instance
  -- of the class will share the same metatable.
  --
  function new_class:new()
    local newinst = { nil
      , x = 0
      , y = BUILDING_Y_POS
      , w = 36
      , h = 36
      , health = 5
      , max_health = 10
    }
    setmetatable( newinst, class_mt )
    newinst:on_create()
    return newinst
  end

  return setmetatable(new_class, {__index = Building})
end

-- This function is called after creation to set some additional 
-- parameters.
function Building:on_create()
end

function Building:getArea() 
  return {x = self.x, y = self.y, w = self.w, h = self.h}
end

function Building:health_str()
  local health_ratio = self.health / self.max_health
  if health_ratio < 0 then
    health_ratio = 0
  elseif health_ratio > 1 then
    health_ratio = 1
  end

  return string.format("%2.0f%%", health_ratio * 100)
end

-- A building has a sector for repair and/or energy
-- A building has a bullet list for firing
-- A building has targets for aiming
function Building:update(dt, sector, bullet_list, targets)
end

function Building:draw()
end

require('building_repair')
require('building_shield')
require('building_weapon_platform')