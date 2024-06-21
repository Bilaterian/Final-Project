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
    --health
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 12, 12, 50, 4)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, 50, 4)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 10, 10, self.player.health / (self.player.maxHealth / 50), 4)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print(tostring(self.player.health) .. '/' .. tostring(self.player.maxHealth), 64, 10)

    --exp
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 12, 22, 50, 4)
    love.graphics.setColor(100/255, 100/255, 50,255)
    love.graphics.rectangle("fill", 10, 20, 50, 4)
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 10, 20, self.player.exp / (self.player.expGoal / 50), 4)
    love.graphics.print(tostring(self.player.exp) .. '/' .. tostring(self.player.expGoal), 64, 20)

    --stage#
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(gFonts['medium'])
    local stageText = love.graphics.newText( gFonts['medium'], tostring(self.room.stage))
    love.graphics.print(tostring(self.room.stage), VIRTUAL_WIDTH - stageText:getWidth() - 8,
                        VIRTUAL_HEIGHT - stageText:getHeight() - 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(tostring(self.room.stage), VIRTUAL_WIDTH - stageText:getWidth() - 10,
                        VIRTUAL_HEIGHT - stageText:getHeight() - 10)

    --score
    if self.player.score > 0 then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(tostring(self.player.score), 2, 12, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(tostring(self.player.score), 0, 10, VIRTUAL_WIDTH, 'center')
    end
    
end