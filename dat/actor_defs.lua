ACTOR_DEFS = {
    ['hero'] = {
        ['hitpoints'] = 10,
        ['move_speed'] = 1.0,
        ['attack_speed'] = 1.0,
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
        ['stats'] = {},
    },
    ['spider'] = {
        ['hitpoints'] = 1,
        ['sight'] = 3,
        ['move_speed'] = 0.8,
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
            ['hd'] = '2d8+2',
            ['ac'] = 14,
        },
    },
    ['bat'] = {
        ['hitpoints'] = 3,
        ['morale'] = 2,
        ['move_speed'] = 1.6,
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
            ['hd'] = '1/2d8',
            ['ac'] = 16,
        },     
    },
    ['skeleton'] = {
        ['hitpoints'] = 4,
        ['move_speed'] = 1.0,
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
            ['hd'] = '1d12',
            ['ac'] = 15,
        },
    },
    ['skel_mage'] = {
        ['hitpoints'] = 2,
        ['sight'] = 6,
        ['move_speed'] = 1.2,
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
            ['hd'] = '3d8+3',
            ['ac'] = 12,
        },
    },
    ['zombie'] = {
        ['hitpoints'] = 4,
        ['move_speed'] = 0.5,
        ['attack_speed'] = 0.8,
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
            ['hd'] = '2d12+3',
            ['ac'] = 11,
        },
    },
    ['vampire'] = {
        ['hitpoints'] = 6,
        ['sight'] = 6,
        ['move_speed'] = 1.8,
        ['attack_speed'] = 1.6,
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
            ['hd'] = '4d12+3',
            ['ac'] = 15,
        },        
    },
}