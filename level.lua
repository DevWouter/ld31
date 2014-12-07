require('./wave')

SECTOR_WIDTH = 300
SECTOR_Y = 362

Level = {}
Level.__index = Level

function Level.new(game, sectors, waves, name)
  assert(name, "Each level requires a name")
  local default_table = { nil
    , sectors = sectors
    , game = game
    , waves = waves or {}
    , current_wave = 0
    , name = name
  }

  return setmetatable(default_table, Level)
end

function Level:get_total_width()
  return #self.sectors * SECTOR_WIDTH
end

function Level:get_sector_by_x(x)
  for _,v in pairs(self.sectors) do
    if(v.x <= x and (v.x + v.w) > x) then
      return v
    end
  end
  return nil
end

function Level:wave_str()
  return string.format("%i / %i", self.current_wave, #self.waves)
end

require('sector')