/// @file Defines Cell Struct for handling individual Cells and their states in a grid for the game of Snake.
/// @author Griffin Nye
/// Date Created: 5/23/24
/// Date Modified: 10/24/24
/// Dependencies: n/a

/// @func Cell(_x,_y)
/// @desc Creates an instance of a Cell on the game board with the specified x,y coordinate (in grid, not pixels)
/// @param {real} _x X index of the Cell on the board
/// @param {real} _y Y index of the Cell on the board
/// @return {Struct.Cell} New instance of Cell object
function Cell(_x, _y) constructor {

	enum STATE {EMPTY, FOOD, SNAKE}; //Enum for state of the cell
	xPos = _x;                       //X position of cell in the grid
	yPos = _y;                       //Y position of cell in the grid
	status = STATE.EMPTY;            //Cell status (based on STATE enum)
	
	/// @func getX()
	/// @desc Returns the x coordinate of the Cell on the board
	/// @return {real} The x coordinate of the Cell on the board.
	function getX() {
		return xPos;
	}//end getX
	
	/// @func getY()
	/// @desc Returns the y coordinate of the Cell on the board
	/// @return {real} The y coordinate of the Cell on the board.
	function getY() {
		return yPos;
	}//end getY
	
	/// @func getStatus()
	/// @desc Returns the status of the Cell on the board as an enumerated type. 
	///       Enumerated type is called STATE and has 3 states: EMPTY, FOOD, & SNAKE.
	/// @return {STATE} The status of the Cell on the board (EMPTY, FOOD, SNAKE)
	function getStatus() {
		return status;
	}//end getStatus
	
	/// @func setStatus(newState)
	/// @desc Sets the status of the Cell on the board to the specified enum state.
	///       Enumerated type is called STATE and has 3 states: EMPTY, FOOD, & SNAKE
	/// @param {STATE} - The new status of the Cell
	/// @return {undefined}
	function setStatus(newState) {
		status = newState;
	}//end setStatus
	
	/// @func toString()
	/// @desc Returns a string represetnation of the current Cell. Great for debugging and testing ;)
	///       . = empty;
	///       o = food;
	///       ~ = snake;
	/// @return {string} String representation of the current Cell
	function toString() {
		
		switch(status) {
			case STATE.EMPTY:
				return ".";
			case STATE.FOOD:
				return "o";
			case STATE.SNAKE:
				return "~";
		}//end switch
		
	}//end toString

}//end Cell