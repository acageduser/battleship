/// @description Declare and initializes attributes for objGrid. Prompts Game logic to begin after 3 seconds.

//Create a new instance of the Game
global.game = new Game();

//Set alarm 0 to run after 3 seconds in game 
//game_get_speed(gamespeed_fps) returns the number of frames per second the game is rendering.
//By doing so, we give the player a chance to prepare themselves before the snake starts moving.
alarm[0] = 3 * game_get_speed(gamespeed_fps);