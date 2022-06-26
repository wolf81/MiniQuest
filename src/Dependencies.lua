--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

push = require 'lib.push.push'
Object = require 'lib.classic.classic'
Timer = require 'lib.knife.knife.timer'

-- data files
require 'dat.actor_defs'

-- entities
require 'src.entities.Entity'
require 'src.entities.Actor'
require 'src.entities.Tile'
require 'src.entities.Effect'

-- actions
require 'src.actions.BaseAction'
require 'src.actions.IdleAction'
require 'src.actions.MoveAction'
require 'src.actions.AttackAction'

-- strategies
require 'src.strategies.BaseStrategy'
require 'src.strategies.HeroStrategy'
require 'src.strategies.ActorStrategy'

-- state machine
require 'src.StateMachine'
require 'src.states.BaseState'

-- game states
require 'src.states.game.PlayState'

-- constants, utility functions & classes
require 'src.Constants'
require 'src.Util'
require 'src.Animation'

-- game world
require 'src.world.Dungeon'
Map = require 'dat.map'

gTextures = {
    ['world'] = love.graphics.newImage('gfx/tiny_dungeon_world.png'),
    ['monsters'] = love.graphics.newImage('gfx/tiny_dungeon_monsters.png'),
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['world'], 16, 16),
    ['monsters'] = GenerateQuads(gTextures['monsters'], 16, 16),
}

gStateMachine = StateMachine {
    ['play'] = function() return PlayState() end,
}

local TINY_DUNGEON_FONT_GLYPS = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-+=:;,"<>.?/\\[]_|'

gFonts = {    
    ['tiny-dungeon-shadow'] = love.graphics.newImageFont('fnt/tiny_dungeon_font_shadow.png', TINY_DUNGEON_FONT_GLYPS),
}
