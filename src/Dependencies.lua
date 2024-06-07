--[[Libraries]]
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/game/PlayState'

require 'src/states/entity/EntityIdleState'

require 'src/states/entity/player/PlayerIdleState'

require 'src/world/Room'

require 'src/Util'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/spritesheet.png'),
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
}
