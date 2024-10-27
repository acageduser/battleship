/// @description Handles user left-clicks on an objGridCell, processing the shot, updating objGridCell's visual state,
///              and handling game over's accordingly.

if (clickable) {
	
	global.game.processShot(self.id); //Process the shot at this objGridCell and set its state accordingly

	clickable = false;                //Make objGridCell unclickable
	
	show_debug_message(global.game.board.toString() ); //Cheats for testing
	
}//end if
