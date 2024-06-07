Room = Class{}

function Room:init()
    self.width = LEVEL_SIZE
    self.height = LEVEL_SIZE

    self.floor = {}
    self:generateFloors()

    self.enemies = {}
    

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

end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.floor[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
        end
    end
end
