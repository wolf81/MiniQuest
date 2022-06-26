# MiniQuest

The goal of MiniQuest is to create a simple turn-based RPG as final project for the CS50 course.

In this document I will try to describe the development process and design choices.

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

