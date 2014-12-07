
function draw_quad(x, y, w, h, line_color, fill_color)
  love.graphics.push()
  if fill_color then
    love.graphics.setColor(fill_color)
    love.graphics.rectangle("fill", x, y, w, h)
  end
  if line_color then
    love.graphics.setColor(line_color)
    love.graphics.rectangle("line", x, y, w, h)
  end

  love.graphics.pop()
end

function print_center_of_area(text, area, color)
  love.graphics.push()
  if color then
    love.graphics.setColor(color)
  end
  local font = love.graphics.getFont()
  love.graphics.printf(text, area.x, (area.y + (area.h / 2)) - (font:getHeight() / 2), area.w, "center")
  love.graphics.pop()
end

function begin_draw_area(area)
  if game_conf.double_size then 
    love.graphics.setScissor(area.x * 2, area.y * 2, area.w * 2, area.h * 2)
  else
    love.graphics.setScissor(area.x, area.y, area.w, area.h)
  end
end

function end_draw_area()
  love.graphics.setScissor()
end