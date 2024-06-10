Room = Class{}
local mapSize = LEVEL_SIZE * TILE_SIZE

function Room:init(player)
    self.width = LEVEL_SIZE
    self.height = LEVEL_SIZE

    self.floor = {}
    self:generateFloors()

    self.enemies = {}

    self.cameraX = 0
    self.cameraY = 0
    self.text = ""
    self.player = player
end

function Room:generateFloors()
    for y = 1, self.height do
        table.insert(self.floor, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            elseif x == 1 then
                id = TILE_LEFT_EDGE
            elseif x == self.width then
                id = TILE_RIGHT_EDGE
            elseif y == 1 then
                id = TILE_TOP_EDGE
            elseif y == self.height then
                id = TILE_BOTTOM_EDGE
            else
                id = TILE_CENTER
            end

            table.insert(self.floor[y], {
                id = id
            })
        end
    end
end

function Room:update()
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.cameraX = self.cameraX - PLAYER_WALK_SPEED
        self.text = 'left'
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.cameraX = self.cameraX + PLAYER_WALK_SPEED
        self.text = 'right'
    elseif love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.cameraY = self.cameraY - PLAYER_WALK_SPEED
        self.text = 'up'
    elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.cameraY = self.cameraY + PLAYER_WALK_SPEED
        self.text = 'down'
    else
        self.text = ''
    end

    if self.cameraX < 0 then
        self.cameraX = 0
    elseif self.cameraX > mapSize - VIRTUAL_WIDTH then
        self.cameraX = mapSize - VIRTUAL_WIDTH
    elseif self.cameraY < 0 then
        self.cameraY = 0
    elseif self.cameraY > mapSize - VIRTUAL_HEIGHT then
        self.cameraY = mapSize - VIRTUAL_HEIGHT
    end


end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.floor[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE - self.cameraX, (y - 1) * TILE_SIZE - self.cameraY)
        end
    end

    
    --[[love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    for key, press in pairs(love.keyboard.keysPressed) do
        love.graphics.print(key .. " " .. tostring(press))
    end
    love.graphics.print(self.text)]]
end
