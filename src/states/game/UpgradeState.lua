UpgradeState = Class{__includes = BaseState}

function UpgradeState:enter()
    self.player = Player {
        x = ((LEVEL_SIZE * 16) / 2) - 8,
        y = ((LEVEL_SIZE * 16) / 2) - 8,
        width = 12,
        height = 12,

    -- drawing offsets for padded sprites
        offsetX = 0,
        offsetY = 0,

        walkSpeed = ENTITY_DEFS['player'].walkspeed,
        animations = ENTITY_DEFS['player'].animations,

        attack = 2,
        health = 10,
    }
    self.upgradePoints = 5

    self.healthUpgrade = 0
    self.attackUpgrade = 0
    self.speedUpgrade = 0

    self.ySelector = 0
end

function UpgradeState:update()

    if love.keyboard.wasPressed('up') then
        self.ySelector = math.max(self.ySelector - 1, 0)
    elseif love.keyboard.wasPressed('down') then
        self.ySelector = math.min(self.ySelector + 1, 2)
    end

    if love.keyboard.wasPressed('left') then
        if self.ySelector == 0 then
            self.healthUpgrade = math.max(self.healthUpgrade - 1, 0)
            if self.upgradePoints < 5 then
                self.upgradePoints = self.upgradePoints + 1
            end
        elseif self.ySelector == 1 then
            self.attackUpgrade = math.max(self.attackUpgrade - 1, 0)
            if self.upgradePoints < 5 then
                self.upgradePoints = self.upgradePoints + 1
            end
        elseif self.ySelector == 2 then
            self.speedUpgrade = math.max(self.speedUpgrade - 1, 0)
            if self.upgradePoints < 5 then
                self.upgradePoints = self.upgradePoints + 1
            end
        end
    elseif love.keyboard.wasPressed('right') then
        if self.ySelector == 0 then
            if self.upgradePoints > 0 then
                self.upgradePoints = self.upgradePoints - 1
                self.healthUpgrade = math.min(self.healthUpgrade + 1, 5)
            end
        elseif self.ySelector == 1 then
            if self.upgradePoints > 0 then
                self.upgradePoints = self.upgradePoints - 1
                self.attackUpgrade = math.min(self.attackUpgrade + 1, 5)
            end
        elseif self.ySelector == 2 then
            if self.upgradePoints > 0 then
                self.upgradePoints = self.upgradePoints - 1
                self.speedUpgrade = math.min(self.speedUpgrade + 1, 5)
            end
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.player.maxHealth = self.player.maxHealth + (self.healthUpgrade * 2)
        self.player.health = self.player.maxHealth
        self.player.attack = self.player.attack + self.attackUpgrade
        self.player.walkSpeed = self.player.walkSpeed + (self.speedUpgrade * 2)
        gStateStack:push(PlayState(self.player))
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function UpgradeState:render()
    --background
    love.graphics.setColor(89/255, 157/255, 220/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    --bar shadow
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 101, 16, 135, 14)
    love.graphics.rectangle('fill', 101, 46, 135, 14)
    love.graphics.rectangle('fill', 101, 76, 135, 14)

    --bar level
    love.graphics.setColor(230/255, 150/255, 0/255)
    love.graphics.rectangle('fill', 101, 16, 27 * self.healthUpgrade, 14)
    love.graphics.rectangle('fill', 101, 46, 27 * self.attackUpgrade, 14)
    love.graphics.rectangle('fill', 101, 76, 27 * self.speedUpgrade, 14)

    --bar overlay
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTextures['upgradebar'], gFrames['upgradebar'][1], 100, 15)
    love.graphics.draw(gTextures['upgradebar'], gFrames['upgradebar'][1], 100, 45)
    love.graphics.draw(gTextures['upgradebar'], gFrames['upgradebar'][1], 100, 75)

    --short description
    local text = ""
    if self.ySelector == 0 then
        text = "Health: " .. tostring(self.player.health + (self.healthUpgrade * 2))
        if self.healthUpgrade < 5 then
            text = text .. "->" .. tostring(self.player.health + (self.healthUpgrade * 2) + 2)
        end
    elseif self.ySelector == 1 then
        text = "Attack: " .. tostring(self.player.attack + self.attackUpgrade)
        if self.attackUpgrade < 5 then
            text = text .. "->" .. tostring(self.player.attack + self.attackUpgrade + 1)
        end
    elseif self.ySelector == 2 then
        text = "Speed: " .. tostring(self.player.walkSpeed + (self.speedUpgrade * 2))
        if self.speedUpgrade < 5 then
            text = text .. "->" .. tostring(self.player.walkSpeed + (self.speedUpgrade* 2) + 2)
        end
    end
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(text, 0, 100, VIRTUAL_WIDTH, 'center')
end