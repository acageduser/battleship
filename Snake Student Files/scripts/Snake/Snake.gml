/// @file Defines Snake Struct for handling Snake location, movement, and collisions in the game of Snake.
/// @author Griffin Nye
/// Date Created: 5/23/24
/// Date Modified: 10/24/24
/// Dependencies: Struct.Cell

/// @func Snake(_x, _y)
/// @desc: Creates a Snake at the specified x,y coordinate on the Board.
/// @param {real} _x The x coordinate to place the Snake on the Board.
/// @param {real} _y The y coordinate to place the Snake on the Board.
/// @return {Struct.Snake} New instance of the Snake struct
function Snake(_x, _y) constructor {
	enum DIR {UP, DOWN, LEFT, RIGHT}; //Enum for directions the Snake can move
	direct = DIR.RIGHT;               //Stores the current direction of the Snake
	movements = [ [0, -1], [0, 1], [-1, 0], [1, 0] ]; //Parallel 2D array for storing the coordinate changes for movements
	xPos = _x;                        //The x position of the head of the Snake
	yPos = _y;                        //The y position of the head of the Snake
	length = 1;                       //The length of the snake
	locations = ds_queue_create();    //Queue for storing the Cells of all of the parts of the snake (Tail of snake is at head of queue)
	lastTail = new Cell(xPos, yPos);  //Stores the Cell that was the previous tail after it is dequeued (For setting Cell back to empty) (This could be useful for growing)
	
	
	//Place head of Snake in Queue and set its status to snake
	ds_queue_enqueue(locations, lastTail);
	
	/// @func getSnakeHead()
	/// @desc Returns the Cell representing the Snake's head from the locations queue.
	/// @return {Struct.Cell} The Cell representing the Snake's head
	function getSnakeHead() {
		return ds_queue_tail(locations); //Return the cell at the tail of the locations queue (the snake's head)
	}//end getHead
	
	/// @func getLastTail()
	/// @desc Returns the Cell that represents the Snake's previous tail after it was dequeued from the locations queue.
	/// @return {Struct.Cell} The Cell representing the Snake's previous tail
	function getLastTail() {
		return lastTail; //Return the previous head of the queue (the snake's old tail)
	}//end getLastTail
	
	/// @func grow()
	/// @desc Grows the Snake by one cell after consuming food and increases the Snake's length. 
	///      (Hint: You will want to grow the tail of the Snake, as growing the Head could cause it to grow out of bounds)
	/// @return {undefined}
	function grow() {
		ds_queue_enqueue(locations, lastTail); //Enqueue the previous tail into locations
		
		for (var i = 0; i < length; i++) { //Loop through all values except for lastTail
			ds_queue_enqueue(locations, ds_queue_dequeue(locations)); //Dequeue locations and enqueue the dequeued cell
		}//end for
		
		length++; //Increment length
	}//end grow
	
	/// @func checkCollisions(width, height)
	/// @desc Returns whether or not the Snake has collided with the boundaries of the grid or with itself.
	/// @param {real} width The overall width of the grid (in Cells, not pixels)
	/// @param {real} height The overall height of the gird (in Cells, not pixels)
	/// @return {bool} True if collision with wall or itself occurred, otherwise false.
	function checkCollisions(width, height) {
		if (xPos < 0 || yPos < 0 || xPos >= width || yPos >= height) return true; //Returns true if the snake collides with the wall
		
		var loc = toArray(); //Saves the locations as an array
		
		for (var i = 0; i < length-1; i++) { //Increments through all locations except for the head
			if (xPos == loc[i].getX() && yPos == loc[i].getY()) return true; //Returns true if the snake collides with itself
		}//end for
		
		return false; //Returns false if there is no collision
	}//end checkCollisions
	
	/// @func update()
	/// @desc Moves the snake in its currently traveling direction by updating the position of the Snake's head,
	///       removing the Snake's tail, and adding the new Snake head.
	/// @return {undefined}
	function update() {
		xPos += movements[direct][0]; //Change the x position based on the direction's x speed
		yPos += movements[direct][1]; //Change the y position based on the direction's y speed
		
		lastTail = ds_queue_dequeue(locations); //Save last tail
		ds_queue_enqueue(locations, new Cell(xPos, yPos)); //Make a new cell for the head and add it to the queue
	}//end update
	
	/// @func moveUp()
	/// @desc Sets the current direction of the Snake to up. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveUp() {
		if (direct != DIR.DOWN) direct = DIR.UP; //Set direction to UP (except if already DOWN)
	}//end moveUp
	
	/// @func moveDown()
	/// @desc Sets the current direction of the Snake to down. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveDown() {
		if (direct != DIR.UP) direct = DIR.DOWN; //Set direction to DOWN (except if already UP)
	}//end moveDown
	
	/// @func moveRight()
	/// @desc Sets the current direction of the Snake to right. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveRight() {
		if (direct != DIR.LEFT) direct = DIR.RIGHT; //Set direction to RIGHT (except if already LEFT)
	}//end moveRight
	
	/// @func moveLeft()
	/// @desc Sets the current direction of the Snake to left. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveLeft() {
		if (direct != DIR.RIGHT) direct = DIR.LEFT; //Set direction to LEFT (exept if already RIGHT)
	}//end moveLeft
	
	/// @func toArray()
	/// @desc Returns an array containing the Cells from the locations queue for easier traversal outside of the Snake struct.
	///       (Cells are to be inserted into the array in the same order they are stored in the queue)
	///       (The order of the cells in the locations queue should be in tact after this function terminates (not necessarily during) )
	/// @return {Array<Struct.Cell>} An array containing the Cells from the locations queue
	function toArray() {
		var loc = array_create(length); //Create an array of locations
		
		for (var i = 0; i < length; i++) { //Loop through the whole locations queue
			var tail = ds_queue_dequeue(locations); //save dequeued snake location
			loc[i] = tail; //Add cell to the array
			ds_queue_enqueue(locations, tail); //Enqueue the cell back into the locations queue
		}//end for
		
		return loc; //Return the array of cells
	}//end toArray
		
	/// @func toString
	/// @desc Returns a string representation of the Snake via its location queue
	/// @return {String} A string representation of the Snake
	function toString() {
		str = "";
		
		for(var i = 0; i < ds_queue_size(locations); i++) {
			var currPiece = ds_queue_dequeue(locations); //Pop the next Cell off of the locations queue
			var strPiece = string(currPiece.getX() ) + " " + string(currPiece.getY() ); //Create string representation of the coordinates of currPiece
			str = strPiece + " " + str; //Add string representation to front of final string
			ds_queue_enqueue(locations, currPiece); //Place the current Cell back into locations queue
		}//end for
		
		return string_trim(str);
	}//end toString
	
}//end Snake