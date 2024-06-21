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
        self.entity.xDirection = 'left'
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
        self.entity.xDirection = 'right'
    else
        self.entity.xDirection = 'none'
    end
    if love.keyboard.isDown('up') then
        self.entity:changeAnimation('walk-' .. self.entity.direction)
        self.entity.yDirection = 'up'
    elseif love.keyboard.isDown('down') then
        self.entity:changeAnimation('walk-' .. self.entity.direction)
        self.entity.yDirection = 'down'
    else
        self.entity.yDirection = 'none'
    end

    if self.entity.xDirection == 'none' and self.entity.yDirection == 'none' then
        self.entity:changeState('idle')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
end