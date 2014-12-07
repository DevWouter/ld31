
function update_weapon_progress_bar(sender, dt)
  sender.seconds = sender.seconds + dt
  local weapon = sender.get_weapon();
  sender.text = sender.get_weapon().bullet_type.name
  sender.background_color = {60, 90, 60}
  sender.foreground_color = {120, 180, 120}
  if not weapon.is_active then
    sender.background_color = {30, 45, 30}
    sender.foreground_color = {90, 60, 60}
  end

  -- if weapon.is_active then
    -- sender.text = "building" .. string.rep(".", ((sender.seconds * 3) % 3) + 1)
    local health_ratio = weapon.health / weapon.max_health
    if health_ratio < 0 then
      health_ratio = 0
    elseif health_ratio > 1 then
      health_ratio = 1
    end
    sender.text = sender.get_weapon().bullet_type.name.. ": " .. string.format("%2.0f%%", health_ratio * 100)
  -- end

  local weapon_delay = weapon.delay_fire
  if weapon_delay < 0 then
    weapon_delay = 0
  end
  local fire_delay = (1 - (weapon_delay / weapon.bullet_type.reload_time(weapon.level)))
  sender.value = fire_delay
end

function create_weapon_stat(func, y)
  local bar = Progressbar.new()
  bar.text = func().bullet_type.name
  bar.x, bar.y = 590, y
  bar.w, bar.h = 86, 14
  bar.get_weapon = func
  bar.on_update = update_weapon_progress_bar 
  bar.seconds = 0
  return bar
end

function MainGameState:draw_game_screen()
  local draw_area = { x = 100, y = 53, w = 483, h = 330 }
  local fill_color = {0, 0, 120}
  local line_color = {255, 0, 0}  

  -- Setup the draw bounds.
  love.graphics.push()
  begin_draw_area(draw_area)
  if self.debug then
    draw_quad(draw_area.x, draw_area.y, draw_area.w, draw_area.h, line_color, fill_color)
    -- print_center_of_area("game_screen", draw_area)
  end

  -- Initial translate.
  love.graphics.translate(draw_area.x - self.camera.x, 0)
  love.graphics.translate(draw_area.w / 2, 0)

  -- Draw levels
  for _,v in pairs(self.current_level.sectors) do
    v:draw()
  end

  -- Draw the buildings
  for _,v in pairs(self.buildings) do
    v:draw()
  end

  -- Draw the shields
  for _,v in pairs(self.player_shields) do
    v:draw()
  end

  -- DRAW BULLETS
  for _,v in pairs(self.player_bullets) do
    draw_quad(v.x - v.w/2, v.y - v.h/2, v.w, v.h, {0, 120, 255}, {0, 120, 255})
  end

  for _,v in pairs(self.enemy_bullets) do
    draw_quad(v.x - v.w/2, v.y - v.h/2, v.w, v.h, {0, 120, 255}, {0, 120, 255})
  end

  -- Draw enemies
  for _,v in pairs(self.enemies) do
    v:draw()
  end

  -- TODO: Draw particles

  -- DRAW PLAYER
  self.player:draw()

  -- Draw the wave count down
  
  end_draw_area()
  love.graphics.pop()
end

function MainGameState:draw_left_stats()
  -- TODO: Draw background
  local draw_area = { x = 0, y = 53, w = 100, h = 330 }
  draw_quad(draw_area.x, draw_area.y, draw_area.w, draw_area.h, {255, 0, 0}, {50, 50, 50})

  if self.debug then
    print_center_of_area("left_stats", draw_area)
  end

  -- Draw player information
  -- Draw HP bar
  local health_bar_length = 86 * (self.player.health / self.player.max_health)
  local hp_string = tostring(self.player.health) .. '/'..tostring(self.player.max_health)
  draw_quad(7, 70, 86, 14, nil, {60, 90, 60}) -- BACKGROUND OF THE BAR
  draw_quad(7, 70, health_bar_length, 14, nil, {120, 180, 120})
  print_center_of_area(hp_string, {x = 7, y = 70, w = 86, h = 14}, {80, 40, 180})
  -- Draw border of HP
  draw_quad(7, 70, 86, 14, {120, 120, 120})
  
  -- Draw player energy
  local energy_ratio  =(self.player.energy / self.player.max_energy)
  local energy_bar_length = 86 * energy_ratio
  draw_quad(7, 90, 86, 14, nil, {90, 90, 60}) -- BACKGROUND OF THE BAR
  draw_quad(7, 90, energy_bar_length, 14, nil, {180, 180, 120})
  print_center_of_area(string.format('%.0f%%', energy_ratio * 100), {x = 7, y = 90, w = 86, h = 14}, {80, 40, 180})
  -- Draw border of HP
  draw_quad(7, 90, 86, 14, {120, 120, 120})

  local human_bar_length = 86 * (self.player.humans / self.player.max_humans)
  local human_string = tostring(self.player.humans) .. '/'..tostring(self.player.max_humans)
  draw_quad(7, 110, 86, 14, nil, {60, 90, 60}) -- BACKGROUND OF THE BAR
  draw_quad(7, 110, human_bar_length, 14, nil, {120, 180, 120})
  print_center_of_area(human_string, {x = 7, y = 110, w = 86, h = 14}, {80, 40, 180})
  -- Draw border of HP
  draw_quad(7, 110, 86, 14, {120, 120, 120})

  -- Draw the level name
  -- local level_string = string.format("Level:", )
  love.graphics.print("Level:", 7, 200)
  love.graphics.print(self.current_level.name, 7, 212)
  -- Draw the wave 
  love.graphics.print("Wave:", 7, 224)
  love.graphics.print(self.current_level:wave_str(), 7, 236)
end


function MainGameState:draw_right_controls()
  local draw_area = { x = 583, y = 53, w = 100, h = 330 }
  draw_quad(draw_area.x, draw_area.y, draw_area.w, draw_area.h, {255, 0, 0}, {0, 120, 0})

  for _,v in pairs(self.right_gui) do
    v:draw()
  end
end

function MainGameState:draw_top_radar()
  local draw_area = { x = 0, y = 0, w = 683, h = 53 }
  love.graphics.setFont(fnt_default)
  if self.debug then
    draw_quad(draw_area.x, draw_area.y, draw_area.w, draw_area.h, {255, 0, 0}, {0, 120, 120})
    print_center_of_area("radar", draw_area)
  end
  
  -- The radar will always scale to the width of all the sectors.
  local sector_width = draw_area.w / #self.current_level.sectors
  -- Draw the sectors
  for i,v in ipairs(self.current_level.sectors) do
    local sector_index = i - 1

    -- TODO: Draw danger levels

    -- Draw health
    local health_stat = v.health / v.max_health
    local health_bar_height = health_stat * 25
    draw_quad(sector_index * sector_width, 53-health_bar_height, sector_width, health_bar_height,{255, 0, 0}, {0, 120, 120})
  end

  local radar_width_scale = (SECTOR_WIDTH / sector_width)
  local radar_height_scale = (330 / 53)
  -- Draw the player on the radar
  local player_blip = self.player:getArea()

  -- player_blip
  player_blip.w = 2
  player_blip.h = 2
  player_blip.y = 50
  player_blip.x = player_blip.x
  player_blip.x = player_blip.x / radar_width_scale

  draw_quad(player_blip.x, player_blip.y, player_blip.w, player_blip.h, {255, 255, 255},{255, 255, 255})

  -- Draw which segement we are watching.
  -- Get the area that the camera is viewing.
  local view_area = self.camera:getViewArea()

  -- Divide 
  view_area.x = view_area.x - view_area.w / 2
  view_area.x = view_area.x / radar_width_scale
  view_area.w = view_area.w / radar_width_scale
  view_area.y = 0
  view_area.h = view_area.h /radar_height_scale

  draw_quad(view_area.x, view_area.y, view_area.w, view_area.h, {255, 255, 255}, nil)

  -- Draw countdown
  if self.wave_countdown >= 0 then
    love.graphics.setFont(self.fnt_countdown)
    love.graphics.printf(string.format("Next wave in %.2f", self.wave_countdown), 0, 0, 683, "center")
  end
  love.graphics.setFont(fnt_default)
end

-- DEBUG FUNCTIONALITY
function MainGameState:draw_debug()
  if not self.debug then
    return 
  end

  love.graphics.setFont(fnt_debug)
  love.graphics.print("FPS:    " .. tostring(love.timer.getFPS()), 2, 0)
  love.graphics.print("DT:     " .. tostring(love.timer.getDelta()), 2, 10)
  love.graphics.print("DT.AVG: " .. tostring(love.timer.getAverageDelta()), 2, 20)
  love.graphics.print("Bullets: " .. tostring(#self.player_bullets + #self.enemy_bullets + #self.player_shields), 2, 30)
  love.graphics.setFont(fnt_default)
end