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
//	shipLengths = [4, 2];      //List of ship lengths that will be placed on board
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
		return grid[# _x, _y];
	}//end getCell
	
	/// @func getLastSunk
	/// @desc Returns the locations of the ship that was last sunk.
	/// @return {array<String>} String array containing space-separated coordinates of the ship's location.
	function getLastSunk() {
	    if (lastSunk != -1) {
	        var sunkShip = shipList[lastSunk]; //sunk ship is in shiplist
        
	        
	        return sunkShip.getLocations(); //return all locations for sunk ships
	    }
    
	    return []; //if no ship has been sunk, return an empty array

	}//end getLastSunk
	
	/// @func getNumShips()
	/// @desc Returns the number of ships remaining on the board.
	/// @return {real} Number of ships remaining on the board
	function getNumShips() {
		return numShips;
	}//end getNumShips
	
	/// @func isClear()
	/// @desc Returns whether or not all ships have been sunk.
	/// @return {bool} True if all ships sunk. Otherwise, false.
	function isClear() {                                    //Test
	    for (var i = 0; i < array_length(shipList); i++) {	//loop through all my ships
	        var ship = shipList[i];
        
	        
	        if (ship != pointer_null && !ship.isSunk()) {
	            return false;	//if any ship is not sunk, return false
	        }
	    }
    
	    return true;			//if all ships are sunk, return true
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
	    if (lastSunk != -1) {
	        shipList[lastSunk] = pointer_null;    
	    }//end if
    
	    if (grid[# _x, _y].getStatus() == STATE.HIT || grid[# _x, _y].getStatus() == STATE.MISS) {
	        return RESULT.MISS;  //already shot here
	    }

	    //Check all ships
	    for (var i = 0; i < array_length(shipList); i++) {
	        var ship = shipList[i];
        
	        if (ship != pointer_null && ship.isHit(_x, _y)) {
	            ship.takeHit(_x, _y);                            //Hit the ship
	            grid[# _x, _y].setHit();                         //Mark the cell in the grid as a hit
            
	            if (ship.isSunk()) {
	                numShips--;                                  //Decrement number of ships in play
	                lastSunk = i;                                //Store index of ship just sunk
                
	                //Return SUNK result
	                return RESULT.SUNK;
	            }
            
	            // If the ship was hit but not sunk, return HIT result
	            return RESULT.HIT;
	        }
	    }
	    // If no ships hit, mark it as a miss
	    grid[# _x, _y].setMiss();                                //If no ships hit, then mark cell in the grid as a miss and return the result.
	    return RESULT.MISS;
	}//end processShot
	
	
	/// @func generateShips()
	/// @desc Randomly generates ship placement on the board
	/// @return {undefined}
	function generateShips() {
		randomise(); //Generate random seed for ship generation
		
		//Generate positions for as many ship lengths as specified
		for (var i = 0; i < numShips; i++) {
	        var len = shipLengths[i];									//Use corresponding ship length from shipLengths array (moved)
	        var shipPlaced = false;										//and track if ship has been placed
			var attemptCounter = 0;										//debug my infinite loop :(

			//Continue randomly generating positions until the current generation is viable
	        while (!shipPlaced) {
				
	            if (attemptCounter > 50) {										//give up after 50 tries. I do have an infinite loop in my while loop...
	                show_debug_message("Failed to place ship of length " + string(len));
	                break;
	            }


				var xStart = irandom(ds_grid_width(grid) - 1);			//Generate random x coordinate in grid
	            var yStart = irandom(ds_grid_height(grid) - 1);			//Generate random y coordinate in grid 
																		//Use corresponding ship length from shipLengths array (above)
	            var vert = irandom(1) == 1;								//Randomly decide if ship will be vert or horiz
			
            
	            if (canPlaceShip(xStart, yStart, len, vert)) {			//can the ship even go here?

		            var newShip = new Ship(xStart, yStart, len, vert);	//Create new ship
		            shipList[i] = newShip;								//and add it to shipList.

	                placeShip(newShip);									//Place the ship onto the grid.
	                shipPlaced = true;									//successfully placed on grid
				}//end if
				
				attemptCounter++;
				
			}//end while
		}//end for
	}//end generateShips
	
	
	/// @func placeShip(ship)
	/// @desc Helper function to generateShips(). Places the ship onto the Battleship grid, by setting the Cells in the grid accordingly
	/// @param {Struct.Ship} ship The ship being placed on the grid.
	/// @return {undefined}
	function placeShip(ship) {
		
		//set some ship properties
		var p = ship.xPos;						//ship x (x is a reserved word apparently so now it's p)
		var q = ship.yPos;						//ship y (y is a reserved word apparently so now it's q)
		var len = ship.getSize();				//ship length
		var vert = ship.isVertical();			//is ship vertical?
		
		//If ship orientation is vertical, then set Cells in grid based on vertical orientation.
	    if (vert) {
	        for (var i = 0; i < len; i++) {
	            grid[# p, q + i].setShip();		//contains a ship, so mark it
	        }
	    } 

		//Otherwise, set Cells in grid based on horizontal orientation.
	    else {
	        for (var i = 0; i < len; i++) {
	            grid[# p + i, q].setShip();		//contains a ship, so mark it
	        }
	    }
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
	    if (vert) {
			//If ship would be placed out of bounds, return false
	        if (yStart + len > ds_grid_height(grid)) return false;
			
			//Check if placing ship here would overlap other ships.
	        for (var i = 0; i < len; i++) {
	            if (grid[# xStart, yStart + i].getStatus() != STATE.EMPTY) return false;
	        }

	    //Otherwise, check based on horizontal orientation
		} else {
			//If ship would be placed out of bounds, return false
	        if (xStart + len > ds_grid_width(grid)) return false;
			
			//Check if placing ship here would overlap other ships.
	        for (var i = 0; i < len; i++) {
	            if (grid[# xStart + i, yStart].getStatus() != STATE.EMPTY) return false;
	        }
		}
		
		//If no issues found, return true
		return true;
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