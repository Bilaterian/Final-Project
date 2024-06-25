Room = Class{}

function Room:init(player)
    self.width = LEVEL_SIZE
    self.height = LEVEL_SIZE

    self.level = LevelMaker.generate()
    self.tileMap = self.level.tileMap

    self.text = ""
    self.player = player
    self.cameraX = self.player.x - (VIRTUAL_WIDTH / 2 - 8)
    self.cameraY = self.player.y - (VIRTUAL_HEIGHT / 2 - 8)

    self.mouseX = 0
    self.mouseY = 0

    self.stage = 1
    self.stageTimer = 0

    self.enemies = {}
    self.spawnedEnemies = false

    self.projectiles = {}

    self.damageNumbers = {}
end

function Room:generateEnemies()
    local types = {'flybot'}

    for i = 1, math.max(10, math.floor(10 * self.stage * 0.75)) do
        local type = types[math.random(#types)]

        --try to spawn outside of camera
        local x = math.random(16, LEVEL_SIZE * 16)
        local y = math.random(16, LEVEL_SIZE * 16)
        if x > self.cameraX - 16 and x < self.cameraX + VIRTUAL_WIDTH then
            if y > self.cameraY - 16 and y < self.cameraY + VIRTUAL_HEIGHT then
                local directions = {'up', 'down', 'left', 'right'}
                local direction = directions[math.random(1, 4)]

                local distance = 0
                if direction == 'up' then
                    distance = y - (self.cameraY - 16)
                    y = y - distance
                elseif direction == 'down' then
                    distance = self.cameraY + VIRTUAL_HEIGHT - y
                    y = y + distance
                elseif direction == 'left' then
                    distance = x - (self.cameraX - 16)
                    x = x - distance
                else
                    distance = self.cameraX + VIRTUAL_WIDTH - x
                    x = x + distance
                end
            end
        end

        table.insert(self.enemies, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = math.max(ENTITY_DEFS[type].walkspeed,
                        math.floor(ENTITY_DEFS[type].walkspeed * self.stage * 0.25)),

            x = x,
            y = y,
            offsetX = 1,
            offsetY = 1,

            width = 14,
            height = 14,
            type = type,
            health = math.max(10, math.floor(10 * self.stage * 0.25)),
            attack = math.max(1, math.floor(1 * self.stage * 0.25)),
            expGive = 15 * (self.stage or 1),
        })

        self.enemies[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.enemies[i]) end,
            ['idle'] = function() return EntityIdleState(self.enemies[i]) end
        }

        self.enemies[i]:changeState('walk')
    end
end

function Room:update(dt)
    self.mouseX = self.cameraX + love.mouse.x
    self.mouseY = self.cameraY + love.mouse.y

    self.player:update(dt)

    --short break between rounds
    if self.stageTimer < 1 then
        self.stageTimer = self.stageTimer + dt
    elseif self.spawnedEnemies == false then
        self.spawnedEnemies = true
        self:generateEnemies()
    end

    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        if enemy.health <= 0 and enemy.dead == false then
            enemy.dead = true
            self.player.exp = self.player.exp + enemy.expGive
            self.player.score = self.player.score + math.floor(math.floor(enemy.expGive * math.pi) *
                                (math.random(100, 130) / 100))
            table.remove(self.enemies, i)
            break
        elseif not enemy.dead then
            enemy:processAI({room = self}, dt)
            enemy:update(dt)
        end

        if not enemy.dead and self.player:collides(enemy) and not self.player.invulnerable then
            gSounds['hurt']:play()
            self.player:damage(enemy.attack)
            self.player:goInvulnerable(1.5)

            if self.player.health <= 0 then
                score = self.player.score
                gStateStack:push(GameOverState())
            end
        end
    end
    --projectile here
    self.player.attackTimer = self.player.attackTimer + dt
    if self.player.attackTimer >= math.max(self.player.attackRate, 0.1) then
        self.player.attackTimer = self.player.attackTimer % self.player.attackRate
        --instantiate projectile
        local xLength = math.abs(self.mouseX - (self.player.x + (self.player.width + self.player.offsetX) / 2))
        local yLength = math.abs(self.mouseY - (self.player.y + (self.player.height + self.player.offsetY) / 2))
        local max = xLength + yLength
        local xNormal = xLength / max
        local yNormal = yLength / max

        local xVelocity = 0
        if self.mouseX >= (self.player.x + (self.player.width + self.player.offsetX) / 2) then
            --x should be positive
            xVelocity = xNormal
        else
            xVelocity = xNormal * (-1)
        end
        local yVelocity = 0
        if self.mouseY >= (self.player.y + (self.player.height + self.player.offsetY) / 2) then
            yVelocity = yNormal
        else
            yVelocity = yNormal * (-1)
        end
        
        table.insert(self.projectiles,
        Projectile(self.player.x, self.player.y,
                   8, 8,
                   xVelocity, yVelocity))
        gSounds['fire']:stop()
        gSounds['fire']:play()
    end

    --update projectiles here
    for i = #self.projectiles, 1, -1 do
        local projectile = self.projectiles[i]

        if projectile ~= nil and projectile.solid == true then
            projectile:update(dt)
            --chance for crit 
            if projectile.critCheck == false and math.random(1, self.player.critRange) == 1 then
                projectile.splash = true
                projectile.width = projectile.width + 2
                projectile.height = projectile.height + 2
                projectile.x = projectile.x - 1
                projectile.y = projectile.y - 1
                projectile.velocity = projectile.velocity * 2
            end
            projectile.critCheck = true
            
            local splashDamage = 0
            for key, enemy in pairs(self.enemies) do
                if enemy.dead == false and projectile:collides(enemy) then
                    
                    if projectile.splash then
                        enemy:damage(self.player.attack * 2)
                        splashDamage = splashDamage + self.player.attack * 2
                    else
                        enemy:damage(self.player.attack)
                        table.insert(self.damageNumbers,
                        DamageNumber(self.player.attack, projectile.x, projectile.y))
                        gSounds['enemy_hurt']:stop()
                        gSounds['enemy_hurt']:play()
                    end
                    projectile:destroy()
                    if projectile.splash == false then
                        break
                    end
                end
            end
            if projectile.splash and splashDamage ~= 0 then
                local crit = DamageNumber(splashDamage, projectile.x, projectile.y)
                crit.crit = true
                table.insert(self.damageNumbers, crit)
                gSounds['crit']:play()
            end
        else
            table.remove(self.projectiles, i)
            break
        end
    end

    for i = #self.damageNumbers, 1, -1 do
        local damage = self.damageNumbers[i]
        damage:update(dt)
        if damage.solid == false then
            table.remove(self.damageNumbers, i)
            break
        end
    end

    --camera update, this must always be at the end
    self.cameraX = self.player.x - (VIRTUAL_WIDTH / 2 - 8)
    self.cameraY =  self.player.y - (VIRTUAL_HEIGHT / 2 - 8)

    if self.cameraX < 0 then
        self.cameraX = 0
    elseif self.cameraX > MAPSIZE - VIRTUAL_WIDTH then
        self.cameraX = MAPSIZE - VIRTUAL_WIDTH
    end
    if self.cameraY < 0 then
        self.cameraY = 0
    elseif self.cameraY > MAPSIZE - VIRTUAL_HEIGHT then
        self.cameraY = MAPSIZE - VIRTUAL_HEIGHT
    end

    --check if level up is available
    if self.player.exp >= self.player.expGoal then
        self.player:levelUp()
        --make a call here to change state and upgrade a stat 
        gStateStack:push(LevelUpState(self.player))
    end

    --spawn new round
    if #self.enemies < 1 and self.spawnedEnemies then
        self.stage = self.stage + 1
        self.stageTimer = 0
        self.spawnedEnemies = false
    end
end

function Room:render()
    love.graphics.push()

    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    self.level:render()
    self.player:render()

    for key, enemy in pairs(self.enemies) do
        if enemy.dead == false then
            enemy:render()
        end
    end

    for key, projectile in pairs(self.projectiles) do
        if projectile.solid == true then
            projectile:render()
        end
    end

    for key, damage in pairs(self.damageNumbers) do
        if damage.solid == true then
            damage:render()
        end
    end

    --draw ray from player to mouse
    --[[
    love.graphics.setColor(1,0,1)
    love.graphics.line( self.player.x + (self.player.width + self.player.offsetX) / 2,
                        self.player.y + (self.player.height + self.player.offsetY) / 2,
                        self.cameraX + love.mouse.x, self.cameraY + love.mouse.y)
    ]]
    -- for checking keybinds working
    --[[
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    for key, press in pairs(love.keyboard.keysPressed) do
        love.graphics.print(key .. " " .. tostring(press))
    end
    love.graphics.print(self.text)
    ]]

    --for checking if camera is on the right position
    --[[
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print(math.floor(self.player.x) .. " " .. math.floor(self.player.y), 0, 0)
    love.graphics.print(math.floor(self.cameraX + (VIRTUAL_WIDTH / 2 - 8)) .. " " ..
                        math.floor(self.cameraY + (VIRTUAL_HEIGHT / 2 - 8)), 0, 20)

    if math.floor(self.player.x) ~= math.floor(self.cameraX + (VIRTUAL_WIDTH / 2 - 8)) or
    math.floor(self.player.y) ~= math.floor(self.cameraY + (VIRTUAL_HEIGHT / 2 - 8)) then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", 0, 40, 10, 10)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", 0, 40, 10, 10)
    end
    ]]

    love.graphics.pop()
    --for checking table lengths
    --[[
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print(#self.enemies .. " " .. #self.projectiles)
    ]]
end
