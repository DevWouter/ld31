-- Support files
require('./math') -- Additional math functionality

-- Main.lua
require('game_conf') -- Additional config of the game
require('hd_support')
require('draw_helpers')
require('game') -- The game object

require('audio')
require('game_events')
require('gui_element')

fnt_gui = nil
fnt_default = nil
fnt_debug = nil

function love.load()
  -- math.randomseed(os.time() % 1000)
  -- love.math.setRandomSeed(os.time() % 1000)
  fnt_debug = love.graphics.newFont("Anonymous Pro.ttf", 10)
  fnt_gui = love.graphics.newFont("Anonymous Pro.ttf", 10)
fnt_default = love.graphics.getFont()
  game_singelton = Game.new()
  game_singelton:change_state('game_state')
  game_singelton.debug = false
end

function love.update(dt)
  game_singelton:update(dt)
end

function love.draw()
  hd_begin()
  love.graphics.setColor(255,255,255)
  game_singelton:draw()
  hd_end()
end

function love.keypressed(key, isrepeat)
  game_singelton:keypressed(key, isrepeat)
end

function love.keyreleased(key, isrepeat)
  game_singelton:keyreleased(key, isrepeat)
end

function love.mousereleased(x, y, button)
  game_singelton:mousereleased(x, y, button)
end