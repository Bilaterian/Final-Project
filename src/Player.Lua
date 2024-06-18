Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.DebugText = ""
    self.maxHealth = self.health
    self.regenAmount = 2
    self.regenTimer = 5
    self.timer = 0
    self.offsetX = 2
    self.offsetY = 2
end

function Player:update(dt)
    Entity.update(self, dt)
    --passive regeneration
    self.timer = self.timer + dt
    if self.health ~= self.maxHealth and self.timer >= self.regenTimer then
        self.health = math.min(self.health + self.regenAmount, self.maxHealth)
        self.timer = self.timer % self.regenTimer
    end
end

function Player:collides(target)
    return not (self.x + self.width + self.offsetX < target.x or self.x > target.x + target.width + target.offsetX or
                self.y + self.height + self.offsetY < target.y or self.y > target.y + target.height + target.offsetY)
end

function Player:getXY()
    return self.x, self.y
end

function Player:render()
    Entity.render(self)

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end