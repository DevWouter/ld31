-- MainGameState
require("game_state")
require('building')
require('shield_plate')

MainGameState = GameState.new_type()
-- Set the default properties

function MainGameState:on_start(game)
  self.game = game
  self.fnt_countdown = love.graphics.newFont("X-SCALE_.TTF", 25)
  self.level_index = 1
  self.current_level = load_level(game, self.level_index)
  self.enemies = {}
  self.right_gui = {}
  self.buildings = {}
  self.death_enemies = {} -- In here we store the death enemies
  self.enemy_bullets = {}
  self.player_bullets = {}
  self.player_shields = {}
  self.player = Player.new(self.player_bullets)
  self.camera = Camera.new()
  self.wave_countdown = -1

  local center_x = #self.current_level.sectors * SECTOR_WIDTH / 2
  self.player.x = center_x
  self.camera.x = center_x

  -- Start the first wave now
  self:updateCameraConstraint()
  self:start_next_wave_countdown()
  
  -- Create the gui elements
  self.gui_cannons = create_weapon_stat(function() return self.player.weapons.cannons end, 70)
  self.gui_rockets = create_weapon_stat(function() return self.player.weapons.rockets end, 90)
  self.gui_laser = create_weapon_stat(function() return self.player.weapons.laser end, 110)
  self.gui_blackhole = create_weapon_stat(function() return self.player.weapons.blackhole end, 130)
  
  self.gui_buildings = Label.new() -- Does nothing
  self.gui_buildings.x = 590
  self.gui_buildings.y = 160
  self.gui_buildings.w = 86
  self.gui_buildings.text = "Buildings"

  self.gui_build_repair = create_build_button(180, RepairBuilding, self)
  self.gui_build_shield = create_build_button(200, ShieldBuilding, self)

  
  table.insert(self.right_gui, self.gui_cannons)
  table.insert(self.right_gui, self.gui_rockets)
  table.insert(self.right_gui, self.gui_laser)
  table.insert(self.right_gui, self.gui_blackhole)
  table.insert(self.right_gui, self.gui_buildings)
  table.insert(self.right_gui, self.gui_build_repair)
  table.insert(self.right_gui, self.gui_build_shield)
end

function create_build_button(y, building_type, game_state)
  local button = Button.new() -- Does nothing
  button.x = 590
  button.y = y
  button.w = 86
  button.text = building_type.name
  return button
end

function MainGameState:get_all_gui_elements()
  local all_elements = {}
  
  for _,v in pairs(self.right_gui) do
    table.insert(all_elements, v)
  end

  return all_elements
end

function MainGameState:load_next_level()
  self.enemy_bullets = {}
  self.player_bullets = {}
  self.buildings = {}
  self.level_index = self.level_index + 1
  local next_level = load_level(self.game, self.level_index)
  if next_level == nil then
    self.game:change_state('game_complete')
  else
    self.current_level = next_level
    self:updateCameraConstraint()
  end
end

function MainGameState:start_next_wave_countdown()
  self.wave_countdown = 2
end

function MainGameState:launch_next_wave()
  self.current_level.current_wave = self.current_level.current_wave + 1
  local current_wave = self.current_level.waves[self.current_level.current_wave]
  current_wave:fire(self.player, self.enemies, self.current_level)
end

function MainGameState:constrainPlayerPosition()
  if self.player.x < 0 then
    self.player.x = 0
  end

  local sectors = self.current_level.sectors
  local last_sector = sectors[#sectors]
  local player_right = self.player.x + self.player.w
  if player_right > (last_sector.x + last_sector.w) then
    self.player.x = (last_sector.x + last_sector.w) - self.player.w
  end
end

function MainGameState:updateCameraConstraint()
  -- Determine the camera bounds.
  local sectors = self.current_level.sectors
  local last_sector = sectors[#sectors]
  self.camera.left_bound = 0
  self.camera.right_bound = last_sector.x + last_sector.w
end


function MainGameState:update_bullets_(dt, bullets, targets, sectors, buildings, shields)
  local remove_bullet_table = {}
  for i,v in pairs(bullets) do
    v:update(dt, targets)

    -- Check if the bullets overlap with one of the targets
    local remove = false
    for _,target in pairs(targets) do
      if math.test_box_intersection(v, target) then
        v:apply_damage(target)
        remove = v:should_remove()
      end
    end

    for _,target in pairs(sectors) do
      if math.test_box_intersection(v, target) then
        v:apply_damage(target)
        remove = v:should_remove()
      end
    end

    for _,target in pairs(shields) do
      if math.test_box_intersection(v, target) then
        v:apply_damage(target)
        remove = v:should_remove()
      end
    end

    -- Damage buildings
    for _,target in pairs(buildings) do
      if math.test_box_intersection(v, target) then
        v:apply_damage(target)
        remove = v:should_remove()
      end
    end

    if(v.life_time < 0) then
      remove = true
    end

    if remove then
      table.insert(remove_bullet_table, i)
    end
  end

  for i,v in pairs(remove_bullet_table) do
    table.remove(bullets, remove_bullet_table[#remove_bullet_table-(i-1)])
  end
end

function MainGameState:updateCamera(dt)
  self.camera:focus(self.player.x, self.player.y, dt)
end

function MainGameState:update_bullets(dt)
  self:update_bullets_(dt, self.player_bullets, self.enemies, {}, {}, {})
  self:update_bullets_(dt
    , self.enemy_bullets
    , {self.player}
    , self.current_level.sectors
    , self.buildings
    , self.player_shields)
end

function MainGameState:update_player(dt)
  local move_left = love.keyboard.isDown("a")
  local move_right = love.keyboard.isDown("d")
  local is_firing = love.keyboard.isDown(" ")

  if move_left then
    self.player:set_move(-dt)
  elseif move_right then
    self.player:set_move(dt)
  else
    self.player:set_move(0)
  end

  self.player:set_shooting(is_firing)

  self.player:update(dt, self.player_bullets)

  -- Ensure that the player doesn't leave the bounds.
  self:constrainPlayerPosition()
end

function MainGameState:update_shields(dt)
  local remove_shields = {}
  for i,v in pairs(self.player_shields) do
    v:update(dt, self.player_shields)
    local remove = v.is_death

    if remove then
      table.insert(remove_shields, i)
    end
  end

  for i,v in pairs(remove_shields) do
    table.remove(self.player_shields, remove_shields[#remove_shields-(i-1)])
  end
end

function MainGameState:update_enemies(dt)
  local remove_enemy_table = {}
  for i,v in pairs(self.enemies) do
    v:update(dt, self.enemy_bullets, self.current_level)
    local remove = v.is_death

    if remove then
      table.insert(remove_enemy_table, i)
    end
  end

  for i,v in pairs(remove_enemy_table) do
    table.remove(self.enemies, remove_enemy_table[#remove_enemy_table-(i-1)])
  end
end

function MainGameState:update_sectors(dt)
  for _,v in pairs(self.current_level.sectors) do
    local local_buildings = {}
    for _,b in pairs(self.buildings) do
      if v == self.current_level:get_sector_by_x(b.x + b.w / 2) then
        table.insert(local_buildings, b)
      end
    end
    v:update(dt, local_buildings)
  end
end

function MainGameState:update_buildings(dt)
  local remove_building_table = {}
  for i,v in pairs(self.buildings) do
    local local_sector = self.current_level:get_sector_by_x(math.get_center(v).x)
    v:update(dt, local_sector, self.player_bullets, self.enemies, self.player_shields)
    local remove = v.is_death
    if remove then
      table.insert(remove_building_table, i)
    end
  end

  for i,v in pairs(remove_building_table) do
    table.remove(self.buildings, remove_building_table[#remove_building_table-(i-1)])
  end
end

function MainGameState:update(dt)
  self.debug = self.game.debug -- Sync the debug state

  if self.player.is_death then
    self.game:change_state('game_over')
  end

  local all_sectors_have_armor = true
  for _,v in pairs(self.current_level.sectors) do
    all_sectors_have_armor = all_sectors_have_armor and v.health > 0
  end

  -- Remove buildings without health

  if not all_sectors_have_armor then
    self.game:change_state('game_over')
  end

  self:update_bullets(dt)
  self:update_player(dt)
  self:update_enemies(dt)
  self:update_buildings(dt)
  self:update_sectors(dt)
  self:update_shields(dt)
  -- Update enemies

  self:updateCamera(dt)

  -- Update GUI
  for _,v in pairs(self:get_all_gui_elements()) do
    v:update(dt)
  end

  -- Countdown the wave there is a wave active
  if self.wave_countdown >= 0 then
    self.wave_countdown = self.wave_countdown - dt
    if self.wave_countdown < 0 then
      self:launch_next_wave()
      self.wave_countdown = -1
    end
  end

  if self.wave_countdown < 0 and #self.enemies == 0 then
    if #self.current_level.waves == self.current_level.current_wave then
      -- Load the next level
      self:load_next_level()
    else
      self:start_next_wave_countdown()
    end
  end
end

-- Override functions
function MainGameState:draw()
  love.graphics.setFont(fnt_default)
  self:draw_top_radar()
  self:draw_game_screen()
  self:draw_left_stats()
  self:draw_right_controls()
  self:draw_debug()
end

-- HERE WE HAVE ALL THE DRAW FUNCTIONALITY
require('state_main_game_draw')

function MainGameState:pull_human()
  local sector = self.current_level:get_sector_by_x(self.player.x)
  if sector.humans <= 0 then
      -- TODO: If the sector cannot provide humans then show a message
  elseif self.player.humans >= self.player.max_humans then
    -- TODO: Show message
  else
    -- Draw a human from the sector
    sector.humans = sector.humans - 1
    self.player.humans = self.player.humans + 1
  end
end

function MainGameState:place_humans()
  local sector = self.current_level:get_sector_by_x(self.player.x)
  if self.player.humans <= 0 then
      -- TODO: If the sector cannot provide humans then show a message
  elseif sector.humans >= sector.max_humans then
    -- TODO: Show message
  else
    -- Draw a human from the sector
    self.player.humans = self.player.humans - 1
    sector.humans = sector.humans + 1
  end
end

function MainGameState:mousereleased(x, y, button)
  for _,v in pairs(self:get_all_gui_elements()) do
    if math.test_inside_box(v, x, y) then
      v:fire_click(x, y, button)
    end
  end
end

function MainGameState:build_station(building_type)
  local building = building_type.new()
  building.x = self.player.x
  table.insert(self.buildings, building)
end

function MainGameState:build_weapon()
  -- Only drop weapon that are build and are inactive
  local to_drop = {}
  for _,weapon in pairs(self.player.weapons) do
    if not weapon.is_active and weapon.health >= weapon.max_health then
      table.insert(to_drop, weapon)
    end
  end

  for _,v in pairs(to_drop) do
    local new_weapon = create_weapon(v.bullet_type)
    new_weapon.health = new_weapon.max_health
    local building = WeaponPlatform.new()
    building.weapon = new_weapon
    building.x = self.player.x + self.player.w / 2 - building.w / 2
    table.insert(self.buildings, building)
    v.health = 0 -- Reset our own weapon health
  end
end

function MainGameState:keyreleased(key)
  if key == '1' then
    self.player.weapons.cannons.is_active = not self.player.weapons.cannons.is_active
  elseif key == '2' then
    self.player.weapons.rockets.is_active = not self.player.weapons.rockets.is_active
  elseif key == '3' then
    self.player.weapons.laser.is_active = not self.player.weapons.laser.is_active
  elseif key == '4' then
    self.player.weapons.blackhole.is_active = not self.player.weapons.blackhole.is_active
  end

  if key == '5' then
    self:build_station(RepairBuilding)
  elseif key == '6' then
    self:build_station(ShieldBuilding)
  elseif key == 'w' then
    self:build_weapon()
  end

  if key == 'q' then 
    self:pull_human()
  elseif key == 'e' then
    self:place_humans()
  end

  if self.debug then
    if key == 't' then
      self:start_next_wave_countdown()
    end
    if key == 'n' then
      self:load_next_level()
    end
    if key == 'm' then
      -- Nuke the level
      for i=0, self.current_level:get_total_width(), 5 do
        local bullet = Cannonball.new()
        bullet.x, bullet.y = i, self.player.y - bullet.h
        table.insert(self.player_bullets, bullet)
      end
    end
  end
end