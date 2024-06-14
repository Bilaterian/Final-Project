LevelMaker = Class{}

function LevelMaker.generate()
    local tiles = {}
    local objects = {}

    --generate floors
    for y = 1, LEVEL_SIZE do
        table.insert(tiles, {})

        for x = 1, LEVEL_SIZE do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == LEVEL_SIZE then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == LEVEL_SIZE and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == LEVEL_SIZE and y == LEVEL_SIZE then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            elseif x == 1 then
                id = TILE_LEFT_EDGE
            elseif x == LEVEL_SIZE then
                id = TILE_RIGHT_EDGE
            elseif y == 1 then
                id = TILE_TOP_EDGE
            elseif y == LEVEL_SIZE then
                id = TILE_BOTTOM_EDGE
            else
                id = TILE_CENTER
            end

            table.insert(tiles[y], {
                id = id
            })
        end
    end

    --generate obstacles
   
    --tilemap
    local map = TileMap(LEVEL_SIZE, LEVEL_SIZE)
    map.tiles = tiles

    return GameLevel(objects, map)
end