ENTITY_DEFS = {
    ['player'] = {
        walkspeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk-left'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                texture = 'player'
            },
            ['walk-right'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'player'
            },
            ['idle-left'] = {
                frames = {1},
                texture = 'player'
            },
            ['idle-right'] = {
                frames = {8},
                texture = 'player'
            },
        }
    }
}