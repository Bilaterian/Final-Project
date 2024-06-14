Room = Class{}

function Room:init(player)
    self.width = LEVEL_SIZE
    self.height = LEVEL_SIZE

    self.level = LevelMaker.generate()
    self.tileMap = self.level.tileMap

    self.enemies = {}

    self.cameraX = 0
    self.cameraY = 0
    self.text = ""
    self.player = player
end

function Room:update(dt)
    if self.player:isAtCenterX() then
        
    end

    if self.player:isAtCenterY() then
        
    end
    self.cameraX = self.player.x - (VIRTUAL_WIDTH / 2) + 8
    self.cameraY = self.player.y - (VIRTUAL_HEIGHT / 2) + 8

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

    self.player:update(dt)
end

function Room:render()
    love.graphics.push()

    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    self.level:render()
    self.player:render()
    
    love.graphics.pop()

    --[[love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    for key, press in pairs(love.keyboard.keysPressed) do
        love.graphics.print(key .. " " .. tostring(press))
    end
    love.graphics.print(self.text)]]
end
