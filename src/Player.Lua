Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.DebugText = ""
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2

    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

--repurpose this to collide with bojects in playstate
function Player:checkObjects()
    local direction = self.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    hitboxWidth = 4
    hitboxHeight = 8

    if direction == 'left' then
        hitboxX = self.x - hitboxWidth
        hitboxY = self.y + 2
    elseif direction == 'right' then
        hitboxX = self.x + self.width
        hitboxY = self.y + 2
    elseif direction == 'up' then
        hitboxX = self.x
        hitboxY = self.y - hitboxHeight
    else
        hitboxX = self.x
        hitboxY = self.y + self.height
    end

    return false
end

function Player:render()
    Entity.render(self)

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end