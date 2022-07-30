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
            ['mov_speed'] = 1.0,
            ['att_speed'] = 1.0,
            ['hd'] = '1d8+6',
        },
        ['equipment'] = {
            ['scimitar+1'] = {
                ['dmg_melee'] = '1d6',
                ['att_melee'] = '1',
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
        ['stats'] = {
            ['sight'] = 3,
            ['mov_speed'] = 0.8,
            ['att_speed'] = 1.0,
            ['morale'] = 5,
            ['hd'] = '1d8+1',
            ['ac'] = 14,
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
        ['stats'] = {
            ['sight'] = 5,
            ['mov_speed'] = 1.6,
            ['att_speed'] = 1.0,
            ['morale'] = 4,
            ['hd'] = '1d8+2',
            ['ac'] = 16,
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
        ['stats'] = {
            ['sight'] = 5,
            ['mov_speed'] = 1.0,
            ['att_speed'] = 1.0,
            ['morale'] = 5,
            ['hd'] = '1d12',
            ['ac'] = 15,
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
        ['stats'] = {
            ['sight'] = 6,
            ['mov_speed'] = 1.2,
            ['att_speed'] = 1.0,
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
        ['stats'] = {
            ['sight'] = 5,
            ['mov_speed'] = 0.6,
            ['att_speed'] = 0.8,
            ['morale'] = 5,
            ['hd'] = '2d12+3',
            ['ac'] = 11,
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
        ['stats'] = {
            ['sight'] = 6,
            ['mov_speed'] = 1.8,
            ['att_speed'] = 1.5,
            ['morale'] = 5,
            ['hd'] = '4d12+3',
            ['ac'] = 15,
        },        
    },
}