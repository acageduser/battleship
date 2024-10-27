/// @file Defines Cell Struct for handling individual Cells and their states in a grid for the game of Battleship.
/// @author Griffin Nye
/// Date Created: 5/16/24
/// Date Modified: 10/19/24
/// Dependencies: n/a

/// @func Cell(_x, _y)
/// @desc Constructor for the Cell struct. Creates a Cell in the Battleship grid at the specified location.
/// @param {real} _x The x coordinate of the cell in the grid.
/// @param {real} _y The y coordinate of the cell in the grid.
/// @return {Struct.Cell} New instance of the Cell struct.
function Cell(_x, _y) constructor {
	
	enum STATE {EMPTY, MISS, HIT, SHIP}; //Enum for state of the cell
	xPos = _x;                           //X position of cell in the grid
	yPos = _y;                           //Y position of cell in the grid
	status = STATE.EMPTY;                //Cell status (based on STATE enum)
	
	/// @func getStatus()
	/// @desc Returns the cell's status as an enumerated type. Enumerated type is called STATE and has 4 states: EMPTY, MISS, HIT, & SHIP.
	/// @return {STATE} Enumerated type for the Cell's status.
	function getStatus() {
		return status;
	}//end getStatus
	
	/// @func setMiss()
	/// @desc Sets the cell's status to a miss.
	/// @return {undefined}
	function setMiss() {
		status = STATE.MISS;
	}//end setMiss
	
	/// @func setHit()
	/// @desc Sets the cell's status to a hit.
	/// @return {undefined} 
	function setHit() {
		status = STATE.HIT;
	}//end setHit
	
	/// @func setShip()
	/// @desc Sets the cell's status to currently occupied by a ship (unhit).
	/// @return {undefined}
	function setShip() {
		status = STATE.SHIP;
	}//end setShip
	
	/// @func toString()
	/// @desc Returns a string representation of the current Cell. Great for debugging and testing ;)
	///       _ = empty;
	///       X = missed shot;
	///       O = hit shot;
	///       # = occupying ship (unhit);
	/// @return {string} A string representation of the current Cell.
	function toString() {
		
		switch(status) {
		case STATE.EMPTY:
			return "_";
		case STATE.MISS:
			return "X";
		case STATE.HIT:
			return "O";
		case STATE.SHIP:
			return "#";
		}//end switch
		
	}//end toString
	
}//end Cell