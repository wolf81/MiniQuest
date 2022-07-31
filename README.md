# MiniQuest

The goal of MiniQuest is to create a simple turn-based RPG as final project for the CS50 course.

In this document I will try to describe the development process and design choices.

# Gameplay

The idea is to have a turn-based Diablo clone based using mechanics loosely based on Microlite20.

At the start of the game the player will find himself in a village. Inside the village there will the the occasional quest. The village is in need of help, as lately weird activity has been noticed around the nearby cathedral. The player is tasked to investigate the cathedral.

Soon the player discovers the Cathedral is infested by undead and worse. The player will then be able to go down the catacombs to find the source of the problems.

As the player descends lower and lower, the scenery changes. At some point the player will find himself in hell, having to defeat a major demon. Once the demon is slain, the player has won.

At the start of the game the player will be able to select a class. I'll probably add the following classes to start with:

- Fighter: excels at physical combat
- Rogue: stealthy, but average at physical combat
- Mage: bad at physical combat, but can cast powerful spells

# Entities

The entity structure is quite basic.

There is a Entity base class. This class contains only the very basics that are useful for most entities, such as x and y grid coordinates and a draw function. All other entities will inherit from the Entity base class.

For tiles there is a Tile entity. This entity should eventually be able to choose a texture based on an environment. The texture set that I use provides crypt, dungeon, cavern and labyrinth tiles. Basically it should be possible to changes the look of a map just by changing the environment. 

For the player and non-player characters there is the Actor class. This class uses a direction to draw sprites. This class also adds various functions and properties useful for actors, such as hit points and functions to retrieve an action like move or attack.

Effects are entities that will be mostly used for small animations that are destroyed upon completion. This class can be useful to show spell effects or effects related to various attacks. 

# Actions

In the Zelda and Mario lessons a state machine was used to control actions for actors. However, when I tried implementing the state machine for this project, it didn't seem to make much sense. Perhaps because actors don't freely transition between states. 

Actors take turns one by one and on each turn, an actor can provide an action. The hero would get actions through keyboard input while monsters would get actions through some sort of simple 'AI' (rather some decision algorithm, perhaps based on some parameters - a goblin might flee on low health, whereas a mindless skeleton might now).

I would like to note my turn based implementation is based on some code from the following post: http://journal.stuffwithstuff.com/2014/07/15/a-turn-based-game-loop/

# Strategies

In order to decide on an action, an actor will make use of a strategy object. For the hero the strategy will just be based on keyboard input. For enemy creatures the strategy will be based on various variables. For example a melee enemy that stands next to the hero will usually attack the hero. If a melee enemy is not standing next to the hero, the enemy should move towards the hero.

# Turn-based State Machine

I wanted MiniQuest to be a turn-based roguelike game, but at the same time I wanted the game to feel very smooth. Many roguelike games don't use animation, so all actions, both by the player and the advisaries are instant. When many of the same advisaries are near the player, it can be difficult to decern what action each advisary is performing.

So I wanted to add animations. Animations can make it very clear which advisary is moving to what location. But at the same time the animations should feel almost instant, if possible.

Through trial and error I decided upon the following approach:
a) the player is always the first to perform an action
b) each action has a energy cost and energy cost can be influenced by the actor's stats
c) based on the energy cost of the player's action, provide each actor the same energy
d) then the actor can choose an action to perform based on energy available, e.g. move, attack, idle, sleep, ...
e) if an actor is able to perform multiple actions based on energy available, combine multiple actions into a single action
f) now divide the actions into 2 categories: move actions and combat actions, combat actions include an attack action
g) first perform all move actions simultaneously
h) afterward perform all combat actions sequentially

Using the above approach most movement will feel very smooth if no combat actions are performed in a turn. If combat actions are performed during a turn, the player can quite clearly see which unit is performing what attack.