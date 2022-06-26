# MiniQuest

The goal of MiniQuest is to create a simple turn-based RPG as final project for the CS50 course.

In this document I will try to describe the development process and design choices.

# Actions

In the Zelda and Mario lessons a state machine was used to control actions for actors. However, when I tried implementing the state machine for this project, it didn't seem to make much sense. Perhaps because actors don't freely transition between states. 

Actors take turns one by one and on each turn, an actor can provide an action. The hero would get actions through keyboard input while monsters would get actions through some sort of simple 'AI' (rather some decision algorithm, perhaps based on some parameters - a goblin might flee on low health, whereas a mindless skeleton might now).

I would like to note my turn based implementation is based on some code from the following post: http://journal.stuffwithstuff.com/2014/07/15/a-turn-based-game-loop/

# Strategies

In order to decide on an action, an actor will make use of a strategy object. For the hero the strategy will just be based on keyboard input. For enemy creatures the strategy will be based on various variables. For example a melee enemy that stands next to the hero will usually attack the hero. If a melee enemy is not standing next to the hero, the enemy should move towards the hero.

