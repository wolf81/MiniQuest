--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

push = require 'lib.push.push'
Object = require 'lib.classic.classic'

require 'dat.entity_defs'

require 'src.Entity'
require 'src.Hero'

require 'src.StateMachine'
require 'src.states.BaseState'

require 'src.states.entity.EntityIdleState'
require 'src.states.entity.EntityWalkState'

require 'src.states.game.PlayState'

require 'src.Constants'
require 'src.Util'
require 'src.Animation'

require 'src.world.Dungeon'

gTextures = {
    ['world'] = love.graphics.newImage('gfx/tiny_dungeon_world.png'),
    ['monsters'] = love.graphics.newImage('gfx/tiny_dungeon_monsters.png'),
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['world'], 16, 16),
}

gStateMachine = StateMachine {
    ['play'] = function() return PlayState() end,
}

local TINY_DUNGEON_FONT_GLYPS = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-+=:;,"<>.?/\\[]_|'

gFonts = {    
    ['tiny-dungeon-shadow'] = love.graphics.newImageFont('fnt/tiny_dungeon_font_shadow.png', TINY_DUNGEON_FONT_GLYPS),
}
