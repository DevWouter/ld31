-- GuiElement
GuiElement = {}
GuiElement.__index = GuiElement


function GuiElement.new_type()
   -- Create the table and metatable representing the class.
  local new_class = {}
  local class_mt = { __index = new_class }

  -- Note that this function uses class_mt as an upvalue, so every instance
  -- of the class will share the same metatable.
  --
  function new_class:new()
    local nil_function = function() end
    local defaults = { x = 0
      , y = 0
      , w = 100
      , h = 14
      , visible = true
      , debug = false
      , on_click = nil_function
      , on_update = nil_function
    }
    setmetatable( defaults, class_mt )
    defaults:on_create()
    return defaults
  end

  return setmetatable(new_class, {__index = GuiElement})
end

function GuiElement:on_create()
end

function GuiElement:is_visible()
  return self.is_visible
end

function GuiElement:fire_click(x, y, button)
  local event = { sx = x
    , sy = y
    , button = button
    , sender = self
  }
  self.on_click(event)
end

function GuiElement:update( dt )
  self.on_update(self, dt)
end

-- Do not override this function
function GuiElement:draw()
  if not self:is_visible() then
    return
  end

  self:draw_self()
  if self.debug then
    self:draw_debug()
  end
end

function GuiElement:draw_self()
end

function GuiElement:draw_debug()
  love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

require('gui_label')
require('gui_button')
require('gui_progressbar')