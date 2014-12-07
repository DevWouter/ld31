-- main.lua
-- require 'player'
Player = {}
Player.__index = Player

function Player.new()
  return setmetatable({name = ""}, Player)
end

function Player:draw(x, y)
  -- love.graphics.print(self.name, x, y)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.scale(4,4)
  love.graphics.draw(Player.image, 0, 0)

  love.graphics.pop()
end
-- END OF PLAYER

-- require 'enemy'
Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
  return setmetatable({
    name = "Enemy"
    }, 
    Enemy)
end

function Enemy:draw(x, y)
  love.graphics.print(self.name, x, y)
end
-- END OF ENEMY

player = Player.new()
player.name = "Wouter"

enemy = Enemy.new()
characters = {player, enemy}
playery = 300
sf = nil
m = nil

function love.load()
  -- body
  love.graphics.setDefaultFilter("nearest","nearest", 0)
  Player.image = love.graphics.newImage("player.png")
  sf = love.audio.newSource("powerup.wav", "static")
  m = love.audio.newSource("bu-journeys-of-retorts.it", "static")
  m:play()
end

function love.draw()
  for i,v in ipairs(characters) do
    v:draw(400, playery + ((i-1) * 20))
  end
  -- player:draw(400, 300)  
end

function love.keypressed(key, isrepeat)
  sf:play()
end