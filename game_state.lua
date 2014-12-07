GameState = {}
GameState.__index = GameState

function GameState.new_type()
    -- Create the table and metatable representing the class.
    local new_class = {}
    local class_mt = { __index = new_class }

    -- Note that this function uses class_mt as an upvalue, so every instance
    -- of the class will share the same metatable.
    --
    function new_class:new()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    -- The following is the key to implementing inheritance:

    -- The __index member of the new class's metatable references the
    -- base class.  This implies that all methods of the base class will
    -- be exposed to the sub-class, and that the sub-class can override
    -- any of these methods.
    --
    setmetatable( new_class, { __index = GameState } )

    return new_class
end

function GameState:on_start(game)
    self.game = game
end

function GameState:draw()
end

function GameState:update(dt)
end

function GameState:mousereleased(x, y, button)
end
function GameState:keyreleased(key)
end
function GameState:keypressed(key, isrepeat)
end