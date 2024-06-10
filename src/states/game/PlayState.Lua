PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.room = Room()
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    self.room:update()
end

function PlayState:render()
    self.room:render()
end