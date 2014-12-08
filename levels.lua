-- data/levels
require('level')
require('enemy_saucer')
require('enemy_football')

TOTAL_LEVEL_COUNT = 0

function load_level(game, level_id)
  local levels = 
    { load_level_1
    , load_level_2
    , load_level_3
    , load_level_4
    , load_level_5
  }

  TOTAL_LEVEL_COUNT = #levels

  assert(game)
  if level_id == 0 then
    return load_level_0(game)
  end

  if levels[level_id] == nil then
    return nil
  end

  return levels[level_id](game)
end

function align_sectors(sectors)
  local cur_x = 0
  for _,v in pairs(sectors) do
    v.x = cur_x
    cur_x = cur_x + SECTOR_WIDTH
  end
end

function add_saucer_enemies(amount, wave)
  for i=1,amount do
    local enemy = EnemySaucer.new()
    enemy:on_create()
    enemy.is_firing = true
    table.insert(wave.enemies, enemy)
  end
end

function add_football_enemies(amount, wave)
  for i=1,amount do
    local enemy = EnemyFootball.new()
    enemy:on_create()
    enemy.is_firing = true
    table.insert(wave.enemies, enemy)
  end
end

function load_level_0(game) -- Test level
  local waves = {}
  local wave_1, wave_2 = Wave.new(), Wave.new()
  table.insert(waves, wave_1)

  local sector = Sector.new(game)
  local level = Level.new(game, {sector}, waves, "Debug level")
  return level
end

function load_level_1(game)
  local sectors = generate_level(1, game)

  local wave_setup = 
    { { l1 = 1, l2= 0 }
    , { l1 = 0, l2= 3 }
    , { l1 = 0, l2= 5 }}
  local waves = {}

  for _,v in pairs(wave_setup) do
    local wave = Wave.new()
    add_football_enemies(v.l1, wave)
    add_saucer_enemies(v.l2, wave)
    table.insert(waves, wave)
  end  

  local level = Level.new(game, sectors, waves, "Again the pain")
  return level
end

function generate_level(amount, game)
  local sectors = {}
  lvl_amount = amount
  for i=1, lvl_amount do 
    local sector = Sector.new(game)
    table.insert(sectors, sector)
  end
  align_sectors(sectors)
  return sectors
end

function load_level_2(game)
  local sectors = generate_level(2, game)

  local wave_setup = 
    { { l1 = 1, l2= 1 }
    , { l1 = 2, l2= 2 }
    , { l1 = 3, l2= 3 }}
  local waves = {}

  for _,v in pairs(wave_setup) do
    local wave = Wave.new()
    add_football_enemies(v.l1, wave)
    add_saucer_enemies(v.l2, wave)
    table.insert(waves, wave)
  end  

  local level = Level.new(game, sectors, waves, "Again the pain")
  return level
end

function load_level_3(game)
  local sectors = generate_level(3, game)

  local wave_setup = 
    { { l1 = 1, l2= 1 }
    , { l1 = 3, l2= 2 }
    , { l1 = 5, l2= 2 }
    , { l1 = 3, l2= 12 }
    , { l1 = 12, l2= 12 }}
  local waves = {}

  for _,v in pairs(wave_setup) do
    local wave = Wave.new()
    add_football_enemies(v.l1, wave)
    add_saucer_enemies(v.l2, wave)
    table.insert(waves, wave)
  end  

  local level = Level.new(game, sectors, waves, "Again the pain")
  return level
end

function load_level_4(game)
  local sectors = generate_level(4, game)

  local wave_setup = 
    { { l1 = 1, l2= 1 }
    , { l1 = 3, l2= 2 }
    , { l1 = 5, l2= 2 }
    , { l1 = 5, l2= 2 }
    , { l1 = 7, l2= 7 }
    , { l1 = 12, l2= 12 }
    , { l1 = 15, l2= 15 }
    , { l1 = 20, l2= 30 }}
  local waves = {}

  for _,v in pairs(wave_setup) do
    local wave = Wave.new()
    add_football_enemies(v.l1, wave)
    add_saucer_enemies(v.l2, wave)
    table.insert(waves, wave)
  end  

  local level = Level.new(game, sectors, waves, "Again the pain")
  return level
end

function load_level_5(game)
  local sectors = generate_level(5, game)

  local wave_setup = 
    { { l1 = 1, l2= 1 }
    , { l1 = 3, l2= 2 }
    , { l1 = 5, l2= 2 }
    , { l1 = 5, l2= 2 }
    , { l1 = 7, l2= 7 }
    , { l1 = 12, l2= 12 }
    , { l1 = 15, l2= 15 }
    , { l1 = 20, l2= 20 }
    , { l1 = 20, l2= 25 }
    , { l1 = 12, l2= 40 }
    , { l1 = 10, l2= 60 }
    , { l1 = 50, l2= 50 }}
  local waves = {}

  for _,v in pairs(wave_setup) do
    local wave = Wave.new()
    add_football_enemies(v.l1, wave)
    add_saucer_enemies(v.l2, wave)
    table.insert(waves, wave)
  end  

  local level = Level.new(game, sectors, waves, "Again the pain")
  return level
end