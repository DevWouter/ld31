-- Wave
Wave = {}
Wave.__index = Wave

function Wave.new()
  local default_table = {nil
    , enemies = {}
  }

  return setmetatable(default_table, Wave)
end

function Wave:fire(player, enemies, level)
  -- enemy.x = self.player.x
  for i,v in pairs(self.enemies) do
    v.x = love.math.random(level:get_total_width())
    table.insert(enemies, v)
  end

  -- Clean our own list to prevent additional firing
  self.enemies = {}
end