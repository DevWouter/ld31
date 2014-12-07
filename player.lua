require('bullet')

PLAYER_Y_POS = 350

Player = {}
Player.__index = Player

function create_weapon(bullet_type)
  return 
    { is_active = false
    , health = 0
    , max_health = 10
    , level = 1
    , delay_fire = 0
    , bullet_type = bullet_type
    }
end

function Player.new()
  local default_table = { nil
    , speed = 100
    , x = 0
    , y = PLAYER_Y_POS
    , w = 10
    , h = 10
    , x_velocity = 0
    , is_firing = false
    , health = 100
    , is_death = false
    , humans = 1
    , max_humans = 1
    , max_health = 100
    , energy = 50 -- we start at half the energy
    , max_energy = 100
    , energy_generation = 10 -- per second
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
  return setmetatable(default_table, Player)
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
  weapon.delay_fire = weapon.delay_fire - dt
  if weapon.is_active and weapon.health >= weapon.max_health and self.is_firing and weapon.delay_fire < 0 then
    local energy_drain = weapon.bullet_type.energy_drain(weapon.level)
    if self.energy >= energy_drain then
      local bullet = weapon.bullet_type.new()
      bullet.x, bullet.y = self.x + (self.w / 2), self.y - bullet.h
      table.insert(bullets, bullet)
      weapon.delay_fire = weapon.bullet_type.reload_time(weapon.level)
      self.energy = self.energy - energy_drain -- Remove the energy
    end
  end
end

function Player:update(dt, bullets)
  self.x = self.x + self.x_velocity * self.speed
  -- Add energy
  self.energy = self.energy + self.energy_generation * dt
  if self.energy > self.max_energy then
    self.energy = self.max_energy
  end

  local to_repair = {}
  for _,v in pairs(self.weapons) do
    self:update_weapons(v, dt, bullets)
    if v.is_active and v.max_health > v.health then
      -- Build or repair the weapon.
      table.insert(to_repair, v)
    end
  end

  if self.humans > 0 then
    local repair_speed = (self.humans / #to_repair) * dt
    for _,v in pairs(to_repair) do
      v.health = v.health + repair_speed
      if v.health > v.max_health then v.health = v.max_health end
    end
  end

  if not self.is_death and self.health < 0 then
    self.is_death = true
    Audio.play(Audio.sounds.player_death)
  end 
end

function Player:draw()
  local fill_color = {0, 0, 120}
  local line_color = {255, 0, 0}  
  draw_quad( self.x, self.y, 10, 10, fill_color, line_color)
end