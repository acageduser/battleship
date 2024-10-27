/// @file Defines Game Struct for the Game of Battleship. Game Struct acts as the Game Controller, linking backend Game logic (Model)
///       to the UI (View) (Model-View-Controller paradigm)
/// @author Griffin Nye
/// Date Created: 5/16/24
/// Date Modified: 10/19/24
/// Dependencies: objGridCell, Board Struct

/// @func Game()
/// @desc Constructor for the Game struct. Creates a new Battleship Game and handles game logic and UI components.
/// @return The new instance of the Game struct.
function Game() constructor {
	
	board = new Board();      //The virtual game board object 
	board.generateShips();    //Randomly generate ships onto the board
	shotsRemaining = 50;      //Number of shots remaining (Can change this to adjust difficulty)
	
	uiGrid = ds_grid_create(10,10); //UI Grid of objGridCells for User Interaction
 
	//Fill the UI Grid with objGridCells and draw them on-screen
	for(var i = 0; i < 10; i++) {
		for(var j = 0; j < 10; j++) {		
			uiGrid[#i, j] = instance_create_layer(room_width/2 + 64 * (i+1), 256 + 64 * j, "Instances", objGridCell);
		}//end for
	}//end for
	
	/// @func reset
	/// @desc Resets the Game and generates a new board with random ship positions.
	/// @return {undefined}
	function reset() {
		board = new Board();
		board.generateShips();
		shotsRemaining = 50;
		objConsole.clear(); //Clear objConsole
		
		//Reset cells on UI grid back to default and reset to clickable
		for(var i = 0; i < 10; i++) {
			
			for(var j = 0; j < 10; j++) {
				uiGrid[#i,j].image_index = 0;
				uiGrid[#i,j].clickable = true;
			}//end for
			
		}//end for
		
	}//end reset
	
	/// @func halt()
	/// @desc Halts all user interaction with the UI Grid
	/// @return {undefined} n/a
	function halt() {
		
		//Set all objGridCells' clickable attribute to false.
		for(var i = 0; i < 10; i++) {
			for(var j = 0; j < 10; j++) {
				uiGrid[#i,j].clickable = false;
			}//end for
		}//end for
		
	}//end halt
	
	/// @func getShipsRemaining()
	/// @desc Returns the number of ships left for the player to sink.
	/// @return {real} The number of ships left for the player to sink
	function getShipsRemaining() {
		return board.getNumShips();
	}//end getShipsRemaining
	
	/// @func getShotsRemaining()
	/// @desc Returns the number of shots the player has left.
	/// @return {real} The numbe of shots the player has left.
	function getShotsRemaining() {
		return shotsRemaining;
	}//end getShotsRemaining
	
	/// @func hasBeenWon()
	/// @desc Returns whether or not the Game has been won by the player.
	/// @return {bool} True if the game has been won, false otherwise
	function hasBeenWon() {
		return board.isClear();
	}//end hasBeenWon
	
	/// @func hasBeenLost()
	/// @desc Returns whether or not the Game has been lost by the player.
	/// @return {bool} True if the game has been lost, false otherwise
	function hasBeenLost() {
		return shotsRemaining == 0;
	}//end hasBeenLost
	
	/// @func isOver()
	/// @desc Returns whether or not the Game is over, regardless of win status.
	/// @return {bool} True if the game is over, false if Game still in progress.
	function isOver() {
		return hasBeenWon() || hasBeenLost();
	}//end isGameOver
	
	/// @func takeShot(_x, _y)
	/// @desc Takes a shot at the specified x and y coordinates of the board and returns the result.
	///       Result is returned as an enumerated type called RESULT with 3 States: MISS, HIT, or SUNK.
	/// @param {real} _x The x index of the Cell wishing to be shot at
	/// @param {real} _y The y index of the Cell wishing to be shot at
	/// @return {RESULT} RESULT enumerated type representing the result of the shot (MISS, HIT, SUNK)
	function takeShot(_x,_y) {
		shotsRemaining--;
		return board.processShot(_x,_y);
	}//end takeShot
	
	/// @func processShot(currGridCell)
	/// @desc Handles game logic and updates UI when player takes a shot by clicking on an objGridCell.
	/// @param {Instance.ID} currGridCell Instance ID of the objGridCell clicked on by the player.
	/// @return {undefined}
	function processShot(currGridCell) {
		//Get max indices of x and y in the UI Grid
		var maxXIdx = ds_grid_width(uiGrid) - 1;
		var maxYIdx = ds_grid_height(uiGrid) - 1;

		//Get the corresponding indices in the UI Grid that contains this current GridCell
		var xIdx = ds_grid_value_x(uiGrid, 0, 0, maxXIdx, maxYIdx, currGridCell);
		var yIdx = ds_grid_value_y(uiGrid, 0, 0, maxXIdx, maxYIdx, currGridCell);

		//Convert y coordinate to letter coords for display
		var letterCoord = chr(ord("A") + yIdx);

		//Display appropriate message in console and update UI accordingly
		switch( takeShot(xIdx, yIdx) ) {
			case RESULT.MISS:
				objConsole.print("Shot at cell " + string(letterCoord) + string(xIdx + 1) + " missed.");
				processMiss(currGridCell);			
				break;
			case RESULT.HIT:
				objConsole.print("Shot at cell " + string(letterCoord) + string(xIdx + 1) + " hit!");
				processHit(currGridCell);			
				break;
			case RESULT.SUNK:
				objConsole.print("Shot at cell " + string(letterCoord) + string(xIdx + 1) + " sunk a ship!");
				processSink(currGridCell);
				break;
		}//end switch
		
	}//end processShot
	
	/// @func processMiss(currGridCell)
	/// @desc Updates the UI in the case of a missed shot and checks for player loss.
	/// @param {Instance.ID} currGridCell Instance ID of the objGridCell clicked on by the player.
	/// @return {undefined}
	function processMiss(currGridCell) {
		currGridCell.image_index = 1; //Set current objGridCell to Miss
			
		//Check for loss
		if ( hasBeenLost() ) {
			processLoss();
		}//end if
		
	}//end processMiss
	
	/// @func processHit(currGridCell)
	/// @desc Updates the UI in the case of a hit shot and checks for player loss.
	/// @param {Instance.ID} currGridCell Instance ID of the objGridCell clicked on by the player.
	/// @return {undefined}
	function processHit(currGridCell) {
		currGridCell.image_index = 2; //Set current objGridCell to Hit
			
		//Check for loss
		if ( hasBeenLost() ) {
			processLoss();
		}//end if
		
	}//end processHit
	
	/// @func processSink(currGridCell)
	/// @desc Updates the UI in the case of a sinking shot, reverting all former hits on the sunk Ship to Sunk status. 
	///       Checks for Player Win and Loss. 
	/// @param {Instance.ID} currGridCell Instance ID of the objGridCell clicked on by the player.
	/// @return {undefined}
	function processSink(currGridCell) {
		currGridCell.image_index = 3; //Set current objGridCell to Sunk.
			
		//Get array of ship coords for the ship that was just sunk
		var sunkShipCoords = board.getLastSunk();
			
	    show_debug_message("Coordinates of sunk ship: " + string(sunkShipCoords));

		//For each set of coords in the sunken ship, set the objGridCell to the Sunk sprite
		for( var i = 0; i < array_length(sunkShipCoords); i++) {
			var coords = string_split(sunkShipCoords[i]," "); //Splits the string on the space, creating an array of size two
			var _x = real(coords[0]);                         //Extract x coordinate
			var _y = real(coords[1]);                         //Extract y coordinate
			uiGrid[#_x,_y].image_index = 3;                   //Set sprite for said coordinate
		}//end for
			
		if ( hasBeenLost() ) {
			processLoss();
		} else if ( hasBeenWon() ) {
			processWin();
		}//end if
		
	}//end processSink
	
	/// @func processLoss()
	/// @desc Handles informing player of loss and prompting player to play again.
	/// @return {undefined}
	function processLoss() {
		objConsole.print("Sorry. You ran out of shots.");
				
		if show_question("Sorry. You ran out of shots.\nPlay again?") {
			reset();
		} else {
			game_end();
		}//end if
		
	}//end processLoss
	
	/// @func processWin()
	/// @desc Handles informing player of win and prompting player to play again.
	/// @return {undefined}
	function processWin() {
		objConsole.print("Congratulations! You've won!");
				
		//Prompt user to play again
		if show_question("Congratulations! You've won!\nPlay again?") {
			global.game.reset();
		} else {
			game_end();
		}//end if
		
	}//end processWin

}//end Game