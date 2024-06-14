PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
        self.entity.mapDirection = 'left'
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
        self.entity.mapDirection = 'right'
    elseif love.keyboard.isDown('up') then
        self.entity:changeAnimation('walk-' .. self.entity.direction)
        self.entity.mapDirection = 'up'
    elseif love.keyboard.isDown('down') then
        self.entity:changeAnimation('walk-' .. self.entity.direction)
        self.entity.mapDirection = 'down'
    else
        self.entity:changeState('idle')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
end