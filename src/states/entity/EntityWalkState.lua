EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, player)
    self.entity = entity
    self.entity:changeAnimation('walk-left')

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityWalkState:update(dt)
    
    -- assume we didn't hit a wall
    self.bumped = false

    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.entity.mapDirection == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        
        if self.entity.x <= 0 then
            self.entity.x = 0
            self.bumped = true
        end
    elseif self.entity.mapDirection == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt

        if self.entity.x + self.entity.width >= MAPSIZE - TILE_SIZE then
            self.entity.x = MAPSIZE - TILE_SIZE
            self.bumped = true
        end
    elseif self.entity.mapDirection == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt

        if self.entity.y <= 0 then
            self.entity.y = 0
            self.bumped = true
        end
    elseif self.entity.mapDirection == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt


        if self.entity.y >= MAPSIZE - TILE_SIZE then
            self.entity.y = MAPSIZE - TILE_SIZE
            self.bumped = true
        end
    end
end

function EntityWalkState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'right'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.mapDirection = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x , self.entity.y)
    
    -- debug code
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end