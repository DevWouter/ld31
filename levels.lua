-- data/levels
require('level')
require('enemy_saucer')
require('enemy_football')

function load_level(game, level_id)
  local levels = 
    { load_level_1
    , load_level_2
  }

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
  local waves = {}
  local wave_1, wave_2 = Wave.new(), Wave.new()
  add_football_enemies(1, wave_1)
  add_saucer_enemies(5, wave_2)
  table.insert(waves, wave_1)
  -- table.insert(waves, wave_2)


  local sector = Sector.new(game)
  local level = Level.new(game, {sector}, waves, "hello world")
  return level
end

function load_level_2(game)
  local sectors = {}
  lvl_amount = 3
  for i=1, lvl_amount do 
    local sector = Sector.new(game)
    table.insert(sectors, sector)
  end
  align_sectors(sectors)

  local waves = {}
  local wave_1 = Wave.new()
  local enemy = EnemySaucer.new()
  enemy.is_firing = true
  table.insert(wave_1.enemies, enemy)
  table.insert(waves, wave_1)

  local level = Level.new(game, sectors, waves, "Again the pain")
  return level
end