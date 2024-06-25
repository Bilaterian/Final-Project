--[[Libraries]]
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--player score would not pass between states
--terrible bandaid fix
score = 0

require 'src/Animation'
require 'src/constants'
require 'src/StateMachine'
require 'src/Entity'
require 'src/entity_defs'
--gameobject
--gameobjects
require 'src/GameLevel'
require 'src/LevelMaker'
require 'src/Player'
require 'src/TileMap'
require 'src/Util'
require 'src/Projectile'
require 'src/DamageNumber'

require 'src/world/Room'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states.game/StartState'
require 'src/states/game/UpgradeState'
require 'src/states/game/PlayState'
require 'src/states/game/LevelUpState'
require 'src/states/game/GameOverState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/spritesheet.png'),
    ['player'] = love.graphics.newImage('graphics/Hero.png'),
    ['enemies'] = love.graphics.newImage('graphics/enemies.png'),
    ['projectile'] = love.graphics.newImage('graphics/projectile.png'),
    ['upgradebar'] = love.graphics.newImage('graphics/upgradebar.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['barshadow'] = love.graphics.newImage('graphics/barshadow.png'),
    ['aim'] = love.graphics.newImage('graphics/aim.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['player'] = GenerateQuads(gTextures['player'], 16, 16),
    ['enemies'] = GenerateQuads(gTextures['enemies'], 16, 16),
    ['projectile'] = GenerateQuads(gTextures['projectile'], 8, 8),
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/pixel-bit-advanced.ttf', 24),
}

gSounds = {
    ['fire'] = love.audio.newSource('sounds/shoot.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['crit'] = love.audio.newSource('sounds/crit.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select2.wav', 'static'),
    ['confirm'] = love.audio.newSource('sounds/select1.wav', 'static'),
    ['enemy_hurt'] = love.audio.newSource('sounds/enemy_hurt.wav', 'static'),
    ['level_up'] = love.audio.newSource('sounds/level_up.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/DST-TowerDefenseTheme.mp3', 'static')
}