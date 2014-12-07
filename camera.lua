Camera = {}
Camera.__index = Camera

function Camera.new()
  local default_table = { nil
    , x = 0
    , y = PLAYER_Y_POS
    , w = 483
    , h = 330
    , left_bound = 0
    , right_bound = 0
    , focus_speed = 0.8
  }
  return setmetatable(default_table, Camera)
end

function Camera:focus(target_x, target_y, dt)
  local focus_speed = self.focus_speed * dt
  local neg_focus = 1 - focus_speed
  self.x = self.x * neg_focus + target_x * focus_speed
  self.y = self.y * neg_focus + target_y * focus_speed
  local hw = self.w / 2

  -- Limit to the width of the world
  local over_left_bound = (self.x - hw) < self.left_bound
  local over_right_bound = (self.x + hw) > self.right_bound

  if over_left_bound and over_right_bound then
    local center_bound = (self.left_bound + self.right_bound) / 2
    self.x = center_bound
  elseif over_left_bound then
    self.x = self.left_bound + hw
  elseif over_right_bound then
    self.x = self.right_bound - hw
  end
end

function Camera:getViewArea()
  local view_area = {
    x = self.x,
    y = self.y,
    w = self.w,
    h = self.h
  }

  return view_area;
end