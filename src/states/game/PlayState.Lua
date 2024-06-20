PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        x = ((LEVEL_SIZE * 16) / 2) - 8,
        y = ((LEVEL_SIZE * 16) / 2) - 8,
        width = 12,
        height = 12,

    -- drawing offsets for padded sprites
        offsetX = 0,
        offsetY = 0,

        walkSpeed = ENTITY_DEFS['player'].walkspeed,
        animations = ENTITY_DEFS['player'].animations,

        attack = 5,
        health = 10,
    }
    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
    }

    self.player:changeState('idle')

    self.room = Room(self.player)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    self.room:update(dt)
end

function PlayState:render()
    love.graphics.push()
    self.room:render()
    love.graphics.pop()

    --UI is drawn here 
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 12, 12, self.player.maxHealth * 2, 4)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, self.player.maxHealth * 2, 4)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 10, 10, self.player.health * 2, 4)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print(tostring(self.player.maxHealth), 14 + (self.player.maxHealth * 2), 10)
end