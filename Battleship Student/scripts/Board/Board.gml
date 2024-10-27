/// @file Defines Board Struct for creating random board configurations and managing ships in a game of Battleship.
/// @author Griffin Nye
/// Date Created: 5/16/24
/// Date Modified: 10/19/24
/// Dependencies: Struct.Cell, Struct.Ship

/// @func Board()
/// @desc Constructor for the Board struct. Creates a randomly-generated Board for the game of Battleship.
/// @return {Struct.Board} New instance of the Board Struct
function Board() constructor {
	
	grid = ds_grid_create(10, 10);      //Grid of Cells for the board itself
	numShips = 5;                       //Number of ships remaining on the board (Also how many to populate board with)
	shipList = array_create(numShips);  //Array of Ships (Struct) that are on the board
	shipLengths = [5, 4, 3, 3, 2];      //List of ship lengths that will be placed on board
	lastSunk = -1;						//Index of the last sunk ship in the shipList.
	
	//Fill grid with empty Cells
	for( var i = 0; i < ds_grid_width(grid); i++) {
		for( var j = 0; j < ds_grid_height(grid); j++) {
			grid[#i,j] = new Cell(i, j);
		}//end for
	}//end for
	
	/// @func getCell(_x,_y)
	/// @desc Returns Cell instance at the specified x, y coordinates in the grid.
	/// @param {real} _x the x coordinate
	/// @param {real} _y the y coordinate
	/// @return {Struct.Cell} The Cell instance found at the specified coordinates in the grid.
	function getCell(_x, _y) {
		
	}//end getCell
	
	/// @func getLastSunk
	/// @desc Returns the locations of the ship that was last sunk.
	/// @return {array<String>} String array containing space-separated coordinates of the ship's location.
	function getLastSunk() {
		
	}//end getLastSunk
	
	/// @func getNumShips()
	/// @desc Returns the number of ships remaining on the board.
	/// @return {real} Number of ships remaining on the board
	function getNumShips() {
		
	}//end getNumShips
	
	/// @func isClear()
	/// @desc Returns whether or not all ships have been sunk.
	/// @return {bool} True if all ships sunk. Otherwise, false.
	function isClear() {
		
	}//end isClear
	
	/// @func processShot(_x, _y)
	/// @desc Takes a shot at the specified x, y coordinates, performs appropriate action if hit, sunk, or missed and returns the result of the shot (as an enumerated type).
	///       The enumerated type returned is called RESULT and has 3 states: MISS, HIT, and SUNK.
	///       If shot would hit a ship, updates both the appropriate Ship object from the shipList and the cells in the grid. 
	/// @param {real} _x The x coordinate of the shot to be taken
	/// @param {real} _y The y coordinate of the shot to be taken
	/// @return {RESULT} Enumerated type indicating the result of the shot.
	function processShot(_x, _y) {
		enum RESULT {MISS, HIT, SUNK};
		
		//If a ship was sunk from the last shot, set Ship to null
		//(Done here so that we can return ship locations array after it is sunk to properly adjust UI)
		if (lastSunk!= -1) {
			shipList[lastSunk] = pointer_null;	
		}//end if
		
		//Check all ships
		
		
			//If the current ship is hit, process the hit
			
				//Hit the ship
				//Mark the cell in the grid as a hit
				
				//Check if the hit sunk the ship
				
					//Decrement number of ships in play
					//Store index of ship just sunk
					//Return SUNK Result
			    //Otherwise, just return a HIT Result.
			
		//If no ships hit, then mark cell in the grid as a miss and return the result.
	}//end processShot
	
	
	/// @func generateShips()
	/// @desc Randomly generates ship placement on the board
	/// @return {undefined}
	function generateShips() {
		randomise(); //Generate random seed for ship generation
		
		//Generate positions for as many ship lengths as specified
			
			//Continue randomly generating positions until the current generation is viable
			
				//Generate random x coordinate in grid
				//Generate random y coordinate in grid 
				//Use corresponding ship length from shipLengths array
				//Randomly decide if ship will be vert or horiz
			
			//Create new ship and add it to shipList.
			
			//Place the ship onto the grid.
		
	}//end generateShips
	
	
	/// @func placeShip(ship)
	/// @desc Helper function to generateShips(). Places the ship onto the Battleship grid, by setting the Cells in the grid accordingly
	/// @param {Struct.Ship} ship The ship being placed on the grid.
	/// @return {undefined}
	function placeShip(ship) {
		
		//If ship orientation is vertical, then set Cells in grid based on vertical orientation.
		
		//Otherwise, set Cells in grid based on horizontal orientation.
		
	}//end placeShip


	/// @func canPlaceShip(xStart, yStart, len, vert)
	/// @desc Helper function to generateShips(). 
	///       Determines whether or not a Ship with the specified length can be placed at the specifed x,y coordinate in the specified orientation.
	/// @param {real} xStart Starting x position in the grid
	/// @param {real} yStart Starting y position in the grid
	/// @param {real} len Length of the ship
	/// @param {bool} vert Orientation of the ship. True if vert, false if horiz.
	/// @return {bool} True if ship placement is viable, false otherwise.
	function canPlaceShip(xStart, yStart, len, vert) {
		
		//If ship in vertical orientation, then check accordingly
			
			//If ship would be placed out of bounds, return false
				
			//Check if placing ship here would overlap other ships.
			
			
	    //Otherwise, check based on horizontal orientation
			
			//If ship would be placed out of bounds, return false
				
			//Check if placing ship here would overlap other ships.
			
		
		//If no issues found, return true
	}//end canPlaceShip()
	
	/// @func toString()
	/// @desc Returns a string representation of the board. Great for debugging and testing ;)
	///       _ = empty;
	///       X = missed shot;
	///       O = hit shot;
	///       # = occupying ship (unhit);
	/// @return {string} A string representation of the board.
	function toString() {
		str = "  1  2  3  4  5 6  7  8  9 10\n";
		
		for( var j = 0; j < ds_grid_height(grid); j++) {
			
			str += chr(ord("a") + j); //Add row label to grid
		
			for( var i = 0; i < ds_grid_width(grid); i++) {
				
				str += "  " + grid[# i,j].toString();
			
			}//end for
			
			str += "\n";
		}//end for
	
		return str;
	}//end toString
	
}//end Board