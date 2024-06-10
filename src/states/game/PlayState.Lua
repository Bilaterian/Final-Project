PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 8,
        width = 16,
        height = 16,

    -- drawing offsets for padded sprites
        offsetX = 0,
        offsetY = 0,

        walkSpeed = ENTITY_DEFS['player'].walkspeed,
        animations = ENTITY_DEFS['player'].animations,

        health = 10,
    }
    self.room = Room(self.player)
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