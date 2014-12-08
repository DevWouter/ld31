require('bullet')
require('spread_configuration')



PLAYER_Y_POS = 340

Player = {}
Player.__index = Player

function create_weapon(bullet_type)
  return 
    { is_active = false
    , health = 0
    , max_health = 10
    , level = 1
    , delay_fire = 0
    , fire_type = "single"
    , bullet_type = bullet_type
    }
end

function Player.new()
  local default_table = { nil
    , speed = 100
    , x = 0
    , y = PLAYER_Y_POS
    , w = 32
    , h = 32
    , x_velocity = 0
    , is_firing = false
    , health = 100
    , prev_health = 100
    , is_death = false
    , humans = 1
    , max_humans = 1
    , max_health = 100
    , energy = 50 -- we start at half the energy
    , max_energy = 100
    , energy_generation = 1 -- per second
    , shield_gen_timeout = 0
    , enable_shields = false
    , shields_fired = 0
    , shield_spread = SpreadConfiguration.player_shields
    , time_alive = 0
    , flash_duration = 1
    , weapons = 
      { cannons = create_weapon(Cannonball)
      , rockets = create_weapon(HomingRocket)
      , laser = create_weapon(Laserbeam)
      , blackhole = create_weapon(Blackhole)}
  }

  default_table.weapons.cannons.health = default_table.weapons.cannons.max_health
  default_table.weapons.rockets.health = default_table.weapons.rockets.max_health
  default_table.weapons.laser.health = default_table.weapons.laser.max_health
  default_table.weapons.blackhole.health = default_table.weapons.blackhole.max_health
  default_table.weapons.cannons.is_active = true
  default_table.weapons.cannons.fire_type = "spread"
  default_table.weapons.laser.fire_type = "blanket"
  default_table.weapons.blackhole.fire_type = "overkill"
  return setmetatable(default_table, Player)
end

function Player:get_shield_drain()
  return 20
end

function Player:get_shield_recovery()
  return 1.2 -- per second
end

function Player:set_move(move_dir)
  self.x_velocity = move_dir
end

function Player:set_shooting(value)
  self.is_firing = value
end

function Player:getArea() 
  return {x = self.x, y = self.y, w = self.w, h = self.h}
end

function Player:update_weapons(weapon, dt, bullets)
  if weapon.is_active and weapon.health >= weapon.max_health and weapon.delay_fire < 0 then
    local energy_drain = weapon.bullet_type.energy_drain(weapon.level)
    if self.energy >= energy_drain then
      for _,spread in pairs(SpreadConfiguration[weapon.fire_type]) do
        local bullet = weapon.bullet_type.new()
        -- Set the basic position correct
        bullet.x, bullet.y = self.x + (self.w / 2), self.y - bullet.h
        bullet.vel_x, bullet.vel_y = bullet.vel_x + spread.vx, bullet.vel_y + spread.vy
        bullet.x, bullet.y = bullet.x + spread.x, bullet.y + spread.y
        table.insert(bullets, bullet)
        Sounds.fire:play()
      end

      weapon.delay_fire = weapon.bullet_type.reload_time(weapon.level)
      self.energy = self.energy - energy_drain -- Remove the energy
    end
  end
end

function Player:update(dt, bullets, shield_list)
  self.time_alive = self.time_alive + dt
  self.flash_duration = self.flash_duration - dt
  self.x = self.x + self.x_velocity * self.speed
  -- Add energy
  self.energy = self.energy + self.energy_generation * dt
  if self.energy > self.max_energy then
    self.energy = self.max_energy
  end

  if self.health ~= self.prev_health then
    if self.health < self.prev_health then self.flash_duration = 1 end
    self.prev_health = self.health
  end

  local to_repair = {}
  for i,v in pairs(self.weapons) do
    v.health = v.max_health
    v.delay_fire = v.delay_fire - dt
    if (i == "cannons" and self.is_firing) or (i ~= "cannons" and love.keyboard.isDown('lshift') ) then
      self:update_weapons(v, dt, bullets)
      if v.is_active and v.max_health > v.health then
        -- Build or repair the weapon.
        table.insert(to_repair, v)
      end
    end
  end

  if self.humans > 0 then
    local repair_speed = (self.humans / #to_repair) * dt
    for _,v in pairs(to_repair) do
      v.health = v.health + repair_speed
      if v.health > v.max_health then v.health = v.max_health end
    end
  end

  local recovery_speed = self:get_shield_recovery() * dt
  self.shield_gen_timeout = self.shield_gen_timeout - recovery_speed
  if self.enable_shields and self.shield_gen_timeout < 0 and self.energy > self:get_shield_drain() then
    generate_shield(self, shield_list)
  end

  if not self.is_death and self.health < 0 then
    self.is_death = true
    Audio.play(Audio.sounds.player_death)
  end 

  self.enable_shields = false
end

function Player:draw()
  local fill_color = {0, 0, 120}
  local line_color = {255, 0, 0}
  local current_frame = Sprites.player:get_frame(self.time_alive)
  love.graphics.push()
  love.graphics.setColor({255,255,255})
  if self.flash_duration > 0 and math.floor(self.flash_duration * 6) % 2 == 1 then
    love.graphics.setColor({255,100,100})
  end
  
  love.graphics.translate(self.x, self.y)
  love.graphics.draw(current_frame.image)
  love.graphics.pop()
  -- draw_quad( self.x, self.y, 10, 10, fill_color, line_color)
end