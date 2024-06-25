StartState = Class{__includes = BaseState}

function StartState:init()
    gSounds['music']:setLooping(true)
    gSounds['music']:play()
end


function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateStack:push(UpgradeState())
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTextures['background'], 0, 0)

    love.graphics.setColor(230/255, 150/255, 0/255)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('Destroy All Robot Bees', 0, 0, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press enter to start', 0, 125, VIRTUAL_WIDTH, 'center')
end