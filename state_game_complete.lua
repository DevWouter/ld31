-- main_menu_state
require("game_state")

GameCompleteState = GameState.new_type()

function GameCompleteState:on_start(game)
  self.game = game
  -- Load background
  self.img_background = love.graphics.newImage("images/main_menu_background.png")
  self.fnt_title = love.graphics.newFont("X-SCALE_.TTF", 50)
  self.fnt_button = love.graphics.newFont("X-SCALE_.TTF", 25)
  self.button_y_begin = 240
  self.button_h = 30
  self.button_w = 300
  self.main_menu_y = self.button_y_begin
end

function GameCompleteState:draw_button(text, x, y, w, h)
  local hsw = 683/2;
  love.graphics.setFont(self.fnt_button)
  love.graphics.rectangle("line", hsw - w/2, y, w, h)
  love.graphics.printf(text, hsw - w/2, y, w, "center")
end

function GameCompleteState:draw()
  -- Draw background
  love.graphics.setColor(128, 255, 128)
  love.graphics.draw(self.img_background, 0, 0)
  love.graphics.setColor(255,255,255)
  love.graphics.setFont(self.fnt_title)
  love.graphics.print("You killed everything!")

  -- Draw buttons
  self:draw_button("Back to the main menu", 0, self.main_menu_y, self.button_w, self.button_h)
end

function GameCompleteState:mousereleased(x, y, button)
  if button ~= 'l' then
    return
  end 
  
  local hsw = 683/2;
  local button_x = hsw - self.button_w/2
  if x > button_x and x < (button_x + self.button_w) then
    if y > self.main_menu_y and y < (self.main_menu_y + self.button_h) then
      self.game:change_state('main_menu')
    end
  end
end