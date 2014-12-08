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
require('sprite_animation')
require('images')

fnt_gui = nil
fnt_default = nil
fnt_debug = nil

Sounds = {}

function love.load()
  Sounds.fire = love.audio.newSource("audio/laser_fire.wav", "static")
  
  Sounds.music = love.audio.newSource("audio/bu-demoscene-of-cannons.it", "static")
  Sounds.music:setLooping(true)
  Sounds.music:play()
  love.graphics.setDefaultFilter("nearest","nearest", 0)
  load_sprite_animations()
  load_all_images()
  -- math.randomseed(os.time() % 1000)
  -- love.math.setRandomSeed(os.time() % 1000)
  fnt_debug = love.graphics.newFont("Anonymous Pro.ttf", 10)
  fnt_gui = love.graphics.newFont("Anonymous Pro.ttf", 10)
  fnt_default = love.graphics.getFont()
  game_singelton = Game.new()
  game_singelton:change_state('main_menu')
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