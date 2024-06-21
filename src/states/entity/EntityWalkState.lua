EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('walk-left')

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityWalkState:update(dt)
    
    -- assume we didn't hit a wall
    self.bumped = false

    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.entity.xDirection == 'left' then
        if self.entity.yDirection == 'none' then
            self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        else
            self.entity.x = self.entity.x - self.entity.walkSpeed * dt * 0.8
        end
        
        if self.entity.x <= 0 then
            self.entity.x = 0
            self.bumped = true
        end
    elseif self.entity.xDirection == 'right' then
        if self.entity.yDirection == 'none' then
            self.entity.x = self.entity.x + self.entity.walkSpeed * dt
        else
            self.entity.x = self.entity.x + self.entity.walkSpeed * dt * 0.8
        end

        if self.entity.x >= MAPSIZE - TILE_SIZE then
            self.entity.x = MAPSIZE - TILE_SIZE
            self.bumped = true
        end
    end
    if self.entity.yDirection == 'up' then
        if self.entity.xDirection == 'none' then
            self.entity.y = self.entity.y - self.entity.walkSpeed * dt
        else
            self.entity.y = self.entity.y - self.entity.walkSpeed * dt / 2
        end
        
        if self.entity.y <= 0 then
            self.entity.y = 0
            self.bumped = true
        end
    elseif self.entity.yDirection == 'down' then
        if self.entity.xDirection == 'none' then
            self.entity.y = self.entity.y + self.entity.walkSpeed * dt
        else
            self.entity.y = self.entity.y + self.entity.walkSpeed * dt / 2
        end

        if self.entity.y >= MAPSIZE - TILE_SIZE then
            self.entity.y = MAPSIZE - TILE_SIZE
            self.bumped = true
        end
    end
end

function EntityWalkState:processAI(params, dt)
    local room = params.room
    local player = room.player
    local targetX, targetY = player:getXY()

    self.entity.direction = 'left'
    if targetX > self.entity.x then
        self.entity.direction = 'right'
        self.entity.xDirection = 'right'
    elseif targetX < self.entity.x then
        self.entity.direction = 'left'
        self.entity.xDirection = 'left'
    else
        self.entity.direction = 'left'
        self.entity.x = targetX
    end
    if targetY > self.entity.y then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt
    elseif targetY < self.entity.y then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt
    else
        self.entity.y = targetY
    end
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x) , math.floor(self.entity.y))

    -- debug code
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end