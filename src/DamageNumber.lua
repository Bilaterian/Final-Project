DamageNumber = Class{}

function DamageNumber:init(value, x, y)
    self.value = value
    self.x = x
    self.y = y

    self.timer = 0
    self.solid = true
    self.crit = false
end

function DamageNumber:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 then
        self.solid = false
    end
end

function DamageNumber:render()
    if self.solid then
        if self.crit then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end

        love.graphics.setFont(gFonts['small'])
        love.graphics.print(tostring(self.value), math.floor(self.x), math.floor(self.y))
    end
end