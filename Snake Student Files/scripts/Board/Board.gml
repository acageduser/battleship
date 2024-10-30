/// @file Defines Board Struct for populating the grid of Cells and handling their states in the game of Snake.
/// @author Griffin Nye
/// Date Created: 5/23/24
/// Date Modified: 10/24/24
/// Dependencies: Struct.Cell, Struct.Snake

/// @func Board(width, height)
/// @desc Constructs an instance of the game board for Snake with the specified width and height (in cells, not pixels)
/// @param {real} width Number of columns in the game board
/// @param {real} height Number of rows in the game board
/// @return {Struct.Board} New instance of the Board struct
function Board(width, height) constructor {
	
	grid = ds_grid_create(width, height); //2D grid of Cells
	
	//Populate the grid with empty cells
	for(var i = 0; i < ds_grid_width(grid); i++) {
		for(var j = 0; j < ds_grid_height(grid); j++) {
			grid[#i,j] = new Cell(i, j);
		}//end for
	}//end for

	
	/// @func getCell
	/// @desc Returns the Cell in the board at the specified x,y coordinates (indices, not pixels)
	/// @param {real}_x X index of the Cell in the board
	/// @param {real} _y Y index of the Cell in the board
	/// @return {Struct.Cell} Instance of the Cell found at the specified coordinates
	function getCell(_x,_y) {
		return grid[#_x,_y];
	}//end getCell
	
	/// @func spawnFood(snake)
	/// @desc Spawns the food in a random position on the board.
	/// @param {Struct.Snake} The instance of the Snake struct used for the game.
	/// @return {undefined}
	function spawnFood(snake) {
		randomize(); //Generate random seed for irandom
		
		//Generate random food position until valid placement is achieved
		do {
			var xPos = irandom( ds_grid_width(grid) - 1);
			var yPos = irandom( ds_grid_height(grid) - 1);
		} until ( canPlaceFood(xPos, yPos, snake) );
		
		//Set the specified Cell to the Food State
		grid[#xPos,yPos].setStatus(STATE.FOOD);
	}//end spawnFood
	
	/// @func canPlaceFood(_x, _y, snake)
	/// @desc Returns whether or not the food can be spawned at the specified x,y coordinates based on the
	///       Cells currently occupied by the Snake
	/// @param {real} _x The attempted x coordinate of the food to be spawned
	/// @param {real} _y The attempted y coordinate of the food to be spawned
	/// @param {Snake} snake The instance of the Snake struct used for the game
	/// @return {bool} True if the food can be spawned at the specified coordinates, otherwise false.
	function canPlaceFood(_x, _y, snake) {
		var snakeLoc = snake.toArray(); //Get array representation of Snake
		
		//Check if the food is attempting to be spawned at any of the Snake's positions
		for(var i = 0; i < array_length(snakeLoc); i++) {
			var snakeX = snakeLoc[i].getX();  //Get the corresponding x and y coordinates of the Snake Cell in the grid
			var snakeY = snakeLoc[i].getY();
			
			//Check if attempted food spawn position is in the same spot as the current Snake Cell
			if (snakeX == _x && snakeY == _y) {
				return false;	
			}//end if
			
		}//end for
		
		return true;
	}//end canPlaceFood
	
	/// @func update(snake)
	/// @desc Updates the Cells in the Grid to reflect proper states after the Snake moves.
	/// @param {Struct.Snake} snake The instance of the Snake struct used for the game
	/// @return {undefined}
	function update(snake) {
		var snakeLoc = snake.toArray();     //Get array representation of Snake
		var lastTail = snake.getLastTail(); //Get previous tail position of Snake
		
		//For all elements of the snake, get its coordinates and set the corresponding Cell in the grid to SNAKE State
		for(var i = 0; i < array_length(snakeLoc); i++) {
			
			//Get x and y coordinates in grid of current Snake Cell
			var xIdx = snakeLoc[i].getX(); 
			var yIdx = snakeLoc[i].getY();
			
			//Mark corresponding cell in grid as Snake
			grid[#xIdx,yIdx].setStatus(STATE.SNAKE);
		}//end for
	
		//Get corresponding coordinates in grid for the previous tail position of the Snake
		var xIdx = lastTail.getX();
		var yIdx = lastTail.getY();
		
		//Mark corresponding cell in grid as Empty
		grid[#xIdx, yIdx].setStatus(STATE.EMPTY);
		
	}//end update
	
	/// @func toString()
	/// @desc Returns a String representation of the Board
	/// @return {string} String representation of the Board
	function toString() {
		
		for(var j = 0; j < ds_grid_height(grid); j++) {
			var str = "";
			
			for(var i = 0; i < ds_grid_width(grid); i++) {
				str += grid[#i,j].toString();
			}//end for
			
			str += "\n";
		}//end for
		
		return str;
	}//end toString
	
}//end Board