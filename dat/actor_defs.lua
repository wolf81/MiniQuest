--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

ACTOR_DEFS = {
    ['hero'] = {
        ['animations'] = {
            ['right'] = {
                frames = { 1, 17 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['down'] = {
                frames = { 2, 18 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['up'] = {
                frames = { 3, 19 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['left'] = {
                frames = { 4, 20 },
                interval = 0.5,
                texture = 'monsters',
            },
        },
        ['stats'] = {
            ['sight'] = 5,
            ['spd'] = 30,
            ['hd'] = '1d8+6',
        },
        ['equip'] = {
            ['Leather Armor'] = {
                ['ac'] = 2,
            },
            ['scimitar+1'] = {
                ['dmg_melee'] = '1d6',
                ['att_melee'] = 1,
            },
        },
    },
    ['spider'] = {
        ['animations'] = {
            ['right'] = {
                frames = { 257, 273 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['down'] = {
                frames = { 258, 274 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['up'] = {
                frames = { 259, 275 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['left'] = {
                frames = { 260, 276 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['sleep'] = {
                frames = { 258, 274 },
                interval = 1.5,
                texture = 'monsters',
            },
        }, 
        ['equip'] = {
            ['Bite +4'] = {
                ['att_melee'] = 4,
                ['dmg_melee'] = '1d1', -- +1d4 poison
            },
        },
        ['stats'] = {
            ['sight'] = 3,
            ['spd'] = 20,
            ['morale'] = 5,
            ['hd'] = '1d4-1',
            ['ac'] = 12,
        },
    },
    ['bat'] = {
        ['animations'] = {
            ['right'] = {
                frames = { 233, 249 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['down'] = {
                frames = { 234, 250 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['up'] = {
                frames = { 235, 251 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['left'] = {
                frames = { 236, 252 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['sleep'] = {
                frames = { 234, 250 },
                interval = 1.5,
                texture = 'monsters',
            },
        },
        ['equip'] = {
            ['Bite'] = {
                ['dmg_melee'] = '1d1',
            },
        },
        ['stats'] = {
            ['sight'] = 5,
            ['spd'] = 30,
            ['morale'] = 4,
            ['hd'] = '1d4-1',
            ['ac'] = 12,
        },     
    },
    ['skeleton'] = {
        ['flags'] = { 'undead' },
        ['animations'] = {
            ['right'] = {
                frames = { 129, 145 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['down'] = {
                frames = { 130, 146 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['up'] = {
                frames = { 131, 147 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['left'] = {
                frames = { 132, 148 },
                interval = 0.5,
                texture = 'monsters',
            },
        },
        ['equip'] = {
            ['Short Sword +4'] = {
                ['att_melee'] = 4,
                ['dmg_melee'] = '1d6+2',
            },
            -- ['Shortbow + 4'] = {
            --     ['att_ranged'] = 4,
            --     ['dmg_ranged'] = '1d6+2',
            -- },
        },
        ['stats'] = {
            ['sight'] = 5,
            ['spd'] = 30,
            ['morale'] = 5,
            ['hd'] = '2d8+4',
            ['ac'] = 13,
        },
    },
    ['skel_mage'] = {
        ['flags'] = { 'undead' },
        ['animations'] = {
            ['right'] = {
                frames = { 137, 153 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['down'] = {
                frames = { 138, 154 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['up'] = {
                frames = { 139, 155 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['left'] = {
                frames = { 140, 156 },
                interval = 0.5,
                texture = 'monsters',
            },
        },
        ['equip'] = {
            ['Crooked Staff +2'] = {
                ['att_melee'] = 2,
                ['dmg_melee'] = '1d8',
            },
        },
        ['stats'] = {
            ['sight'] = 6,
            ['spd'] = 30,
            ['morale'] = 5,
            ['hd'] = '1d8+3',
            ['ac'] = 12,
        },
    },
    ['zombie'] = {
        ['flags'] = { 'undead' },
        ['animations'] = {
            ['right'] = {
                frames = { 165, 181 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['down'] = {
                frames = { 166, 182 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['up'] = {
                frames = { 167, 183 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['left'] = {
                frames = { 168, 184 },
                interval = 0.5,
                texture = 'monsters',
            },
        },
        ['equip'] = {
            ['Slam +3'] = {
                ['att_melee'] = 3,
                ['dmg_melee'] = '1d6+1',
            },
        },
        ['stats'] = {
            ['sight'] = 5,
            ['spd'] = 20,
            ['morale'] = 5,
            ['hd'] = '3d8+9',
            ['ac'] = 8,
        },
    },
    ['vampire'] = {
        ['flags'] = { 'undead' },
        ['animations'] = {
            ['right'] = {
                frames = { 161, 177 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['down'] = {
                frames = { 162, 178 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['up'] = {
                frames = { 163, 179 },
                interval = 0.5,
                texture = 'monsters',
            },
            ['left'] = {
                frames = { 164, 180 },
                interval = 0.5,
                texture = 'monsters',
            },
        },
        ['equip'] = {
            ['Unarmed Strike +9'] = {
                ['att_melee'] = 9,
                ['dmg_melee'] = '1d8+4',
            },
        },
        ['stats'] = {
            ['sight'] = 6,
            ['spd'] = 30,
            ['morale'] = 5,
            ['hd'] = '17d8+68',
            ['ac'] = 16,
        },        
    },
}