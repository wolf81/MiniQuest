--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16

ENVIRONMENTS = { 'dungeon', 'crypt', 'cavern', 'labyrinth' }

FLOOR_TILES = { 65, 66, 67, 68, 69 }
WALL_TILES_V = { 1, 2, 3, 4, 5, 6 }
WALL_TILES_H = { 7, 8, 9, 10, 11, 12 }

-- the camera offsets are used to center the camera on a target
CAMERA_X_OFFSET = (VIRTUAL_WIDTH - TILE_SIZE) / 2
CAMERA_Y_OFFSET = (VIRTUAL_HEIGHT - TILE_SIZE) / 2
