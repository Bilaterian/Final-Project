--[[Libraries]]
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
--gameobject
--gameombjects
--hitbox
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Room'

require 'src/states/BaseState'
require 'src/states/StateStack'



require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/game/PlayState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/spritesheet.png'),
    ['player'] = love.graphics.newImage('graphics/Hero.png'),
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['player'] = GenerateQuads(gTextures['player'], 16, 16),
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
}