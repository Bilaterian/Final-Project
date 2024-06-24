Projectile = Class{}

function Projectile:init(x, y, width, height, xVelocity, yVelocity)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.solid = true
    self.velocity = 120
    self.xVelocity = xVelocity * self.velocity
    self.yVelocity = yVelocity * self.velocity
    self.duration = 10
    self.timer = 0

    self.splash = false
    self.critCheck = false
end

function Projectile:update(dt)
    self.timer = self.timer + dt
    self.x = self.x + self.xVelocity * dt
    self.y = self.y + self.yVelocity * dt

    if self.timer >= self.duration then
        self:destroy()
    end

end

function Projectile:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Projectile:destroy()
    self.solid = false
end

function Projectile:render()
    if self.solid then
        if self.splash then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(gTextures['projectile'], gFrames['projectile'][1], self.x, self.y)
    end
end