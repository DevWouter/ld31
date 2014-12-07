-- Game math

function math.test_box_intersection(b1, b2)
  for x = b1.x, b1.x + (b1.w - 1) do
    if x >= b2.x and x < (b2.x + b2.w) then
      for y = b1.y, b1.y + (b1.h - 1) do
        if y >= b2.y and y < (b2.y + b2.h)then
          return true
        end
      end
    end
  end

  return false
end

function math.test_inside_box(box, x, y)
  local is_inside = true
  is_inside = is_inside and x >= box.x
  is_inside = is_inside and y >= box.y
  is_inside = is_inside and x < (box.x + box.w)
  is_inside = is_inside and y < (box.y + box.h)
  return is_inside
end

function math.get_center(box)
  return { x = box.x + box.w / 2
         , y = box.y + box.h / 2}
end

function math.get_distance(point1, point2)
  local x = point1.x - point2.x;
  local y = point1.y - point2.y;
  return math.sqrt(x*x + y*y)
end



