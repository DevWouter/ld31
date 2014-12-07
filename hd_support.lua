
function hd_begin()
  if game_conf.double_size then
    love.graphics.push()
    love.graphics.scale(2,2)
  end
end

function hd_end()
  if game_conf.double_size then
    love.graphics.pop()
  end
end