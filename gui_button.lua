Button = GuiElement.new_type()

function Button:on_create()
  self.foreground_color = {255, 255, 255}
  self.background_color = {120, 120, 120}
  self.border_color = {255, 255, 255}
  self.text = ""
end

function Button:draw_self()
  local ps_x, ps_y, ps_w, ps_h = love.graphics.getScissor()
  love.graphics.setScissor(self.x, self.y, self.w, self.h)

  love.graphics.setColor(self.background_color)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(self.foreground_color)
  love.graphics.printf(self.text, self.x, self.y, self.w, "center")
  love.graphics.setColor(self.border_color)
  love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

  love.graphics.setScissor(ps_x, ps_y, ps_w, ps_h)
end