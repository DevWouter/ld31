-- main_menu_state
require("game_state")

MainMenuState = GameState.new_type()

function MainMenuState:on_start(game)
  self.game = game
  -- Load background
  self.img_background = love.graphics.newImage("images/main_menu_background.png")
  self.fnt_title = love.graphics.newFont("X-SCALE_.TTF", 50)
  self.fnt_button = love.graphics.newFont("X-SCALE_.TTF", 25)
  self.button_y_begin = 240
  self.button_h = 30
  self.start_button_y = self.button_y_begin
  self.quit_button_y = self.button_y_begin + 45
end

function MainMenuState:draw_button(text, x, y, w, h)
  local hsw = 683/2;
  love.graphics.setFont(self.fnt_button)
  love.graphics.rectangle("line", hsw - w/2, y, w, h)
  love.graphics.printf(text, hsw - w/2, y, w, "center")
end

function MainMenuState:draw()
  -- Draw background
  love.graphics.draw(self.img_background, 0, 0)
  love.graphics.setFont(self.fnt_title)
  love.graphics.print("Ludum Dare 31:\nGame on a single screen")

  -- Draw buttons
  
  self:draw_button("New game", 0, self.button_y_begin, 150, self.button_h)
  self:draw_button("Quit game", 0, self.button_y_begin + 45, 150, self.button_h)
end

function MainMenuState:mousereleased(x, y, button)
  if button ~= 'l' then
    return
  end 
  
  local hsw = 683/2;
  local button_w = 150
  local button_x = hsw - button_w/2
  if x > button_x and x < (button_x + button_w) then
    if y > self.start_button_y and y < (self.start_button_y + self.button_h) then
      self.game:change_state('game_state')
    end

    if y > self.quit_button_y and y < (self.quit_button_y + self.button_h) then
      love.event.quit()
    end
  end
end