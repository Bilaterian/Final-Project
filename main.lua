require 'src/Dependencies'

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

    math.randomseed(os.time())

    gStateStack = StateStack()
    gStateStack:push(StartState())
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'w' then
        love.keyboard.keysPressed['up'] = true
    elseif key == 'a' then
        love.keyboard.keysPressed['left'] = true
    elseif key == 's' then
        love.keyboard.keysPressed['down'] = true
    elseif key == 'd' then
        love.keyboard.keysPressed['right'] = true
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button, istouch)
    love.mouse.x, love.mouse.y = push:toGame(x,y)
    love.mouse.press = true
end

function love.update(dt)
    local x,y = love.mouse.getPosition()
    love.mouse.x, love.mouse.y = push:toGame(x,y)

    Timer.update(dt)
    gStateStack:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.press = false
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end