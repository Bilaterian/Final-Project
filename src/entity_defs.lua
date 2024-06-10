ENTITY_DEFS = {
    ['player'] = {
        walkspeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk-left'] = {
                frames = {9, 10, 11, 12},
                interval = 0.15,
                texture = 'player'
            },
            ['walk-right'] = {
                frames = {13, 14, 15, 16},
                interval = 0.15,
                texture = 'player'
            },
            ['walk-down'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'player'
            },
            ['walk-up'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                texture = 'player'
            },
            ['idle-left'] = {
                frames = {12},
                texture = 'player'
            },
            ['idle-right'] = {
                frames = {13},
                texture = 'player'
            },
            ['idle-down'] = {
                frames = {5},
                texture = 'player'
            },
            ['idle-up'] = {
                frames = {1},
                texture = 'player'
            },
        }
    }
}