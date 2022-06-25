# MiniQuest

The goal of MiniQuest is to create a simple turn-based RPG as final project for the CS50 course.

In this document I will try to describe the development process and design choices.

# Controlling actor actions

In the Zelda and Mario lessons a state machine was used to control actions for actors. However, when I tried implementing the state machine for this project, it didn't seem to make much sense. Perhaps because actors don't freely transition between states. 

Actors take turns one by one and on each turn, an actor can provide an action. The hero would get actions through keyboard input while monsters would get actions through some sort of simple 'AI' (rather some decision algorithm, perhaps based on some parameters - a goblin might flee on low health, whereas a mindless skeleton might now).

I think the strategy pattern might be useful in the future. Every monster might have some strategy associated with it, and the strategy will make choices that fit the monster type. Even the hero might have a strategy, but based on keyboard input.

I would like to note my turn based implementation is based on some code from the following post: http://journal.stuffwithstuff.com/2014/07/15/a-turn-based-game-loop/