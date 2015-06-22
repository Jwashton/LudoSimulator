# LudoSimulator

A study project to get more familiar with Coffeescript, HTML5 Canvas, and some
Ludo strategy to boot!

A current version can be found hosted at
http://william.ashtonfam.org/ludo-simulator/

This is just for my personal study, so code reviews are very welcome!

## Ruleset

The board consists of a cyclical track of length `l` around which players race
their pieces once to their own safe zone. By default, `l = 52`. Each
player has a staging zone from which he may stage his pieces into the track.
Each staging zone is optimally equadistant around the track. *This is different
than standard ludo, where a three-player game is set up like a four player game
minus one person.* After a certain distance `d` where `d < l`, the player has an
entrance to his safe zone. By default, `d = 51`. Each save zone is `m` spaces
deep, where `m` is usually `5`. At the end of each save zone is that player's
home space. This is the desired destination for all of the player's pieces.

Each game has `p` players, where `p >= 2 && p < l`, defaulting to `p = 4`. Each
player has `t` tokens to race, with a default of `t = 4`.

There are `n` `o`-sided dice, defaulting to 1 6-sided die. Specific rolls may
have special purposes. For instance, by default a `6` lets the player make an
additional move, and allows a player to optionally stage a piece instead of
advancing an already staged piece.

A player's turn consists of
1. Roll the dice
1. If he rolls a number that allows him to stage a piece, the player may
   choose to do so instead of advancing a token.
1. If the player either does not roll a staging number or chooses not to stage
   a token, he advances an available token of his choice by the number of his
   roll. All movements must be exact, and the player's house may not be
   overshot.
1. If the player moves a token into a space already occupied by another
   player's token, the latter is captured and is sent back to the staging
   ground. A player may not capture his own piece, and any move that would do
   so is not allowed.
1. Play continues to the next sequential player around the table.

A player wins when all of his tokens reach home.
