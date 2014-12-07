-- Support files
require('math')

-- Game files
require('player')
require('camera')
require('level')
require('levels')
require('enemy')

-- The game states
require('state_main_menu')
require('state_main_game')
require('state_game_over')
require('state_game_complete')

Game = {}
Game.__index = Game

function Game.new()
  local callbacks = {
    on_player_death = {}
  }
  local default_table = {nil
    , debug = false
    , player_bullets = {}
    , enemy_bullets = {}
    , enemies = {}
    , callbacks = callbacks
    , next_state = nil
    , active_state = nil
  }

  return setmetatable(default_table, Game)
end

function Game:change_state(state_name)
  if state_name == 'game_state' then
    self.next_state = MainGameState.new()
  elseif state_name == 'main_menu' then
    self.next_state = MainMenuState.new()
  elseif state_name == 'game_over' then
    self.next_state = GameOverState.new()
  elseif state_name == 'game_complete' then
    self.next_state = GameCompleteState.new()
  end

  self:activate_next_state()
end



function Game:update(dt)
  if love.keyboard.isDown("lshift") then
    dt = dt * 10 
  end
  self.active_state:update(dt)
end

function Game:draw()
  self.active_state:draw()
end


function Game:activate_next_state()
  self.active_state, self.next_state = self.next_state, nil
  self.active_state:on_start(self)
end

function Game:keypressed(key, isrepeat)
  if key == 'y' then -- Toggle debug
    self.debug = not self.debug
  end

  self.active_state:keypressed(key, isrepeat)
end

function Game:keyreleased(key)
  self.active_state:keyreleased(key)
end

function Game:mousereleased(x, y, button)
  self.active_state:mousereleased(x, y, button)
end