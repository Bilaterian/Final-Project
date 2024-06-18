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

    self.enemies = {}
    self:generateEnemies()
end

function Room:generateEnemies()
    local types = {'flybot'}

    for i = 1, 10 do
        local type = types[math.random(#types)]

        table.insert(self.enemies, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkspeed,

            x = math.random(16, LEVEL_SIZE * 16),
            y = math.random(16, LEVEL_SIZE * 16),
            offsetX = 1,
            offsetY = 1,

            width = 14,
            height = 14,
            type = type,
            health = 10,
            attack = 2,
        })

        self.enemies[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.enemies[i]) end,
            ['idle'] = function() return EntityIdleState(self.enemies[i]) end
        }

        self.enemies[i]:changeState('walk')
    end
end

function Room:update(dt)

    self.player:update(dt)

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

    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]

        if enemy.health <= 0 and enemy.dead == false then
            enemy.dead = true
        elseif not enemy.dead then
            enemy:processAI({room = self}, dt)
            enemy:update(dt)
        end

        if not enemy.dead and self.player:collides(enemy) and not self.player.invulnerable then
            --gSounds['hit-player']:play()
            self.player:damage(enemy.attack)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                gStateStack:push(GameOverState())
            end
        end
    end
end

function Room:render()
    love.graphics.push()

    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    self.level:render()
    self.player:render()

    for key, enemy in pairs(self.enemies) do
        enemy:render()
    end

    love.graphics.pop()

    -- for checking keybinds working
    --[[love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    for key, press in pairs(love.keyboard.keysPressed) do
        love.graphics.print(key .. " " .. tostring(press))
    end
    love.graphics.print(self.text)]]

    --for checking if camera is on the right position
    --[[love.graphics.setFont(gFonts['medium'])
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
    end]]
end
