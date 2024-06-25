Final Project: Destroy All Robot Bees

This game is based on Vampire Survivors and other 2D shmups. Instead of builds acquiring tools that makes runs unique, the player gets stat upgrades at each level up, and the starting build can differ depending on the upgrades the player chooses. I used plenty of the lessons in this course in order to build this game. I took the scrolling level from mario, animation states from Zelda, and the state stack from Pokemon. The
primary gameplay loop is rather simple: destroy robot bees, level up, get stronger, rinse and repeat until death. The ultimate goal is to destoy as many robot bees as possible and this is reflected in a high score. 

All sprites are made by me using paint.net, bar the tileset used for the floor. The background art is also derived from the tileset. Tileset is made by Toosday on itch.io. 

https://itch.io/profile/toosday

All sound Effects are made by me using Bfxr. The music is taken from DST on opengameart.org. 

link to song: https://opengameart.org/content/tower-defense-theme

Game States:
- StartState: base state of the game, greets the player with a title screen
- UpgradeState: state where a player can adjust the character's starting stats
- PlayState: the meat of the game, the state where they player can destoy robot bees
- LevelUpState: when the player levels up, the player can choose to upgrade a single stat out of a random selection
- GameOverState: Game enters this state when the player dies. Shows score. Pressing enter send player back to start state.

The game states are stored in a stack due to the level ups.

Player/Entity states: used to facilitate different animations
idle: really only used by the player. Usable by enemies but immediately goes to walk state
walk: state for walk animations and handles movement for both player and AI

State machines are used for animations as previous states arent required to be remembered.

File explanations:
Room.lua, used to contain the level, the players, and enemies that spawn. The level isn't made in this file as there were plans to make multiple levels.

DamageNumber.lua, used to display a damage number on screen. I made this to give the player feedback on how much health an enemy roughly has.

Entity.lua, used as a parent class for player and also sued for enemies. handles the stats of a given entity, their states, input and basic ai.

GameLevel.lua, holdover as it only produces a tileset currently. It would have also contained a list of objects at a later date that would obstruct the player's movement.

Player.lua, contains the player and his upgradeable stats. Aside from the functions in Entity, the player also has passive regeneration, a level up function and a getXY function. the getXY function is used to feed the AI the player's location.

Porjectile.lua, contains the projectile's stats. Initial x and y velocity is fed as a normal using the player's position and the mouse's position. X and y velocity is then multiplied by a number in order to speed up the pojectile. A splash flag is used to determine the color, and in Room allows the projectile to hit multiple enemies at once.

Cut Content:
I had features planned that didn't make the cut due to time constraints. Some areas in the codebase contain fill ins that had plans for further complexity.
- AI that doesn't clup up
- Dynamic level generation
- Random Obstacle Generation