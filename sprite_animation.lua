-- SpriteAnimation

SpriteFrame = {}
SpriteFrame.__index = SpriteFrame

function SpriteFrame.new(image_data, x, y, width, height)
  local default_table = 
    { width = width
    , height = height
    , image = nil
    , frame_begin = 0
    , frame_end = 0
    }
  local result = setmetatable(default_table, SpriteFrame)
  frame_data = love.image.newImageData(width, height)
  frame_data:paste( image_data, 0, 0, x, y, width, height )
  result.image = love.graphics.newImage(frame_data)
  return result
end

SpriteAnimation = {}
SpriteAnimation.__index = SpriteAnimation

function SpriteAnimation.new(file, width, height, fps)
  -- Prepare the frames
  local raw_image = love.image.newImageData(file)
  local image_w, image_h = raw_image:getDimensions()
  local frames_in_width = image_w / width
  local frames_in_height = image_h / height
  local frames = {}
  local frame_time = 0
  local frame_time_increase = 1.0 / fps
  for iy = 0,(frames_in_height - 1) do
    for ix = 0,(frames_in_width - 1) do
      local frame = SpriteFrame.new(raw_image, ix * width, iy * width, width, height)
      frame.frame_begin = frame_time
      frame.frame_end = (frame_time + frame_time_increase)
      frame_time = frame_time + frame_time_increase
      table.insert(frames, frame)
    end
  end

  local default_table = 
    { filename = file
    , frames = frames
    , total_time = frame_time
    , frame_width = width
    , frame_height = height
    }

  local result = setmetatable(default_table, SpriteAnimation)
  return result
end

function SpriteAnimation:get_frame(time)
  time = time % self.total_time
  for _,v in pairs(self.frames) do
    if time >= v.frame_begin and time < v.frame_end then
      return v
    end
  end
  return nil
end

function SpriteAnimation:get_frame_by_index(index)
  return self.frames[index]
end

-- GLOBAL STORAGE UNIT FOR SPRITES
Sprites = {} 

function load_sprite_animations()
  Sprites.blackhole = SpriteAnimation.new("images/blackhole.png", 44, 24, 12)
  Sprites.cannon = SpriteAnimation.new("images/cannon.png", 16, 16, 12)
  Sprites.rocket = SpriteAnimation.new("images/rocket.png", 16, 16, 1) -- Doens't matter is used for rotation
  Sprites.rocket_smoke = SpriteAnimation.new("images/rocket_smoke.png", 16, 16, 12)
  Sprites.player = SpriteAnimation.new("images/player.png", 32, 32, 9)
  Sprites.shield = SpriteAnimation.new("images/shield.png", 32, 32, 12)
  Sprites.repair = SpriteAnimation.new("images/repair.png", 32, 32, 0.1)
  Sprites.powerup_repair = SpriteAnimation.new("images/repair_pickup.png", 16, 16, 10)
  Sprites.powerup_shield = SpriteAnimation.new("images/shield_pickup.png", 16, 16, 10)
  Sprites.powerup_energy = SpriteAnimation.new("images/weapon_pickup.png", 16, 16, 10)
end