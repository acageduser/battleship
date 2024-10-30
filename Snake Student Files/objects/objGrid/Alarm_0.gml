/// @description Insert description here
// You can write your code in this editor

//Handle user key presses
global.game.handleKeyPress(keyboard_lastkey);

//If game is over, prompt user to play again. Otherwise, continue the game as normal.
if (global.game.processTurn() == -1) {
	
	//If user selects yes, start a new Game.
	if (show_question("GAME OVER\n Final Score: " + string( global.game.getScore() ) + "\n Play again?") ) {
		global.game.reset();
	} else {
		game_end();
	}//end if
	
} else {
	global.game.updateUI();
}//end if

//Retrigger alarm in 0.15 seconds.
//This slows down the snake's movement, giving the player a window to time directional changes
alarm[0] = 0.15 * game_get_speed(gamespeed_fps);