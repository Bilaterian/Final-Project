Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.DebugText = ""
    self.offsetX = 2
    self.offsetY = 2

    self.maxHealth = self.health
    self.regenAmount = 2
    self.regenRate = 5
    self.timer = 0

    self.attackRate = 2
    self.attackTimer = 0
    self.attackDamage = 2

    self.level = 1
    self.exp = 0
    self.expGoal = self.level * 1.25 * 80
    
    self.score = 0
end

function Player:update(dt)
    Entity.update(self, dt)
    --passive regeneration
    if self.health < self.maxHealth then
        self.timer = self.timer + dt
        if self.health ~= self.maxHealth and self.timer >= math.max(self.regenRate, 0.1) then
            self.health = math.min(self.health + self.regenAmount, self.maxHealth)
            self.timer = self.timer % self.regenRate
        end
    else
        self.timer = 0
    end

end

function Player:levelUp()
    if self.exp >= self.expGoal then
        self.level = self.level + 1
        self.exp = self.exp - self.expGoal
        self.expGoal = self.level * 1.25 * 80
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