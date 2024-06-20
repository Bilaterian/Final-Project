require 'src/Dependencies'

local framerate = 1 / FPSCAP
local tick = 0
local framePush = false
function love.load()
    love.window.setTitle('Final Project')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
    love.mouse.x = 0
    love.mouse.y = 0

    love.keyboard.keysPressed = {}

    gStateStack = StateStack()
    gStateStack:push(PlayState())
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button, istouch)
    love.mouse.x, love.mouse.y = push:toGame(x,y)
    love.mouse.press = true
end

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    local x,y = love.mouse.getPosition()
    love.mouse.x, love.mouse.y = push:toGame(x,y)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end