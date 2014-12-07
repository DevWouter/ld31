Progressbar = GuiElement.new_type()

function Progressbar:on_create()
  self.foreground_color = {180, 180, 180}
  self.background_color = {120, 120, 120}
  self.text_color = {255, 255, 255}
  self.border_color = {255, 255, 255}
  self.text = nil
  self.value = 0.66
end

function Progressbar:draw_self()
  local ratio = self.value
  if ratio > 1 then
    ratio = 1
  elseif ratio < 0 then
    ratio = 0
  end

  local ps_x, ps_y, ps_w, ps_h = love.graphics.getScissor()
  love.graphics.setScissor(self.x, self.y, self.w, self.h)

  love.graphics.setColor(self.background_color)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

  love.graphics.setColor(self.foreground_color)
  love.graphics.rectangle("fill", self.x, self.y, self.w * ratio, self.h)

  if self.text then
    local font = love.graphics.getFont()
    love.graphics.setColor(self.text_color)
    love.graphics.printf(self.text, self.x, (self.y + (self.h / 2)) - (font:getHeight() / 2), self.w, "center")
  end
  love.graphics.setColor(self.border_color)
  love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

  love.graphics.setScissor(ps_x, ps_y, ps_w, ps_h)
end