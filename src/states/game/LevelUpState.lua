LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(player)
    self.player = player
    self.level = player.level

    self.maxHealth = player.maxHealth
    self.regenAmount = player.regenAmount
    self.regenRate = player.regenRate
    self.attackRate = player.attackRate
    self.attackDamage = player.attackDamage
    self.walkSpeed = player.walkSpeed

    self.options = {'Max Health', 'Regen Amount', 'Regen Speed', 'Attack Speed', 'Damage', 'Speed'}
    self.optionsText = {
        'Increase Max Health by ' .. tostring(math.floor(self.maxHealth/5)),
        'Increase Regeneration by ' .. tostring(math.max(math.floor(self.regenAmount/2), 1)),
        'Increase Regen Speed by ' .. tostring(self.regenRate * 0.1) .. '.s',
        'Increase Attack Speed by ' .. tostring(self.attackRate * 0.1) .. '.s',
        'Increase Damage by ' .. tostring(math.max(math.floor(self.attackDamage/10), 1)),
        'Increase Speed by ' .. tostring(math.max(math.floor(self.walkSpeed/8, 1))),
    }

    self.option1 = math.random(#self.options)
    self.option2 = math.random(#self.options)
    self.option3 = math.random(#self.options)
    self.select = 1
end

function LevelUpState:enter()
    self.option1 = math.random(#self.options)
    self.option2 = math.random(#self.options)
    self.option3 = math.random(#self.options)
end

function LevelUpState:update(dt)
    --this is not scalable, consider adding a table to store player stats 

    --mouse pos check here
    if love.mouse.y >= 17 and love.mouse.y <= 127 then
        if love.mouse.x >= 4 and love.mouse.x <= 84 then
            self.select = 1
        elseif love.mouse.x >= 88 and love.mouse.x <= 168 then
            self.select = 2
        elseif love.mouse.x >= 172 and love.mouse.x <= 252 then
            self.select = 3
        end
    end

    if love.keyboard.wasPressed('left') then
        self.select = math.max(1, self.select - 1)
    elseif love.keyboard.wasPressed('right') then
        self.select = math.min(3, self.select + 1)
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.press == true then
        local selected = 0
        if self.select == 1 then
            selected = self.option1
        elseif self.select == 2 then
            selected = self.option2
        else
            selected = self.option3
        end

        if selected == 1 then
            self.player.maxHealth = self.player.maxHealth + math.floor(self.maxHealth/5)
        elseif selected == 2 then
            self.player.regenAmount = self.player.regenAmount + math.max(math.floor(self.regenAmount/2), 1)
        elseif selected == 3 then
            self.player.regenRate = self.player.regenRate + (self.regenRate * 0.1)
        elseif selected == 4 then
            self.player.attackRate = self.player.attackRate + (self.attackRate * 0.1)
        elseif selected == 5 then
            self.player.attackDamage = self.player.attackDamage + math.max(math.floor(self.attackDamage/10), 1)
        else
            self.player.walkSpeed = self.player.walkSpeed + math.max(math.floor(self.walkSpeed/8, 1))
        end

        gStateStack:pop()
    end
end

function LevelUpState:render()
    --draw boxes here
    --add icons and text
    --boxes will be 80 x 110
    --vertical padding = 17 top and bottom
    --horizontal padding = 4
    
    --background
    love.graphics.setColor(0, 0, 0, 128/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    --select highlight
    love.graphics.setColor(1, 1, 1)
    if self.select == 1 then
        love.graphics.rectangle('fill', 2, 15, 84, 114)
    elseif self.select == 2 then
        love.graphics.rectangle('fill', 86, 15, 84, 114)
    else
        love.graphics.rectangle('fill', 170, 15, 84, 114)
    end
    --boxes
    love.graphics.setColor(39/255, 64/255, 81/255, 1)
    love.graphics.rectangle('fill', 4, 17, 80, 110)
    love.graphics.rectangle('fill', 88, 17, 80, 110)
    love.graphics.rectangle('fill', 172, 17, 80, 110)

    --text
    local text1Title = self.options[self.option1]
    local text2Title = self.options[self.option2]
    local text3Title = self.options[self.option3]
    local text1 = self.optionsText[self.option1]
    local text2 = self.optionsText[self.option2]
    local text3 = self.optionsText[self.option3]
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(text1Title, 4, 30, 80, 'center')
    love.graphics.printf(text2Title, 88, 30, 80, 'center')
    love.graphics.printf(text3Title, 172, 30, 80, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(text1, 4, 80, 80, 'center')
    love.graphics.printf(text2, 88, 80, 80, 'center')
    love.graphics.printf(text3, 172, 80, 80, 'center')
end