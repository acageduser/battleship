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
		
	}//end getHead
	
	/// @func getLastTail()
	/// @desc Returns the Cell that represents the Snake's previous tail after it was dequeued from the locations queue.
	/// @return {Struct.Cell} The Cell representing the Snake's previous tail
	function getLastTail() {
		
	}//end getLastTail
	
	/// @func grow()
	/// @desc Grows the Snake by one cell after consuming food and increases the Snake's length. 
	///      (Hint: You will want to grow the tail of the Snake, as growing the Head could cause it to grow out of bounds)
	/// @return {undefined}
	function grow() {
		
		//Adds back the previous tail Cell to the locations queue to grow the Snake
		
		
		//Since we inserted the tail at the back of the queue, we need to shift it to the front
		//So, we will remove and re-add all the Cells in the locations queue, aside from the newly added tail
		
		
		//Increment length
	}//end grow
	
	/// @func checkCollisions(width, height)
	/// @desc Returns whether or not the Snake has collided with the boundaries of the grid or with itself.
	/// @param {real} width The overall width of the grid (in Cells, not pixels)
	/// @param {real} height The overall height of the gird (in Cells, not pixels)
	/// @return {bool} True if collision with wall or itself occurred, otherwise false.
	function checkCollisions(width, height) {
		
		//Check if snake has left the bounds of the screen
		
		
		//Check if snake's head has collided with any pieces of its body (except the head itself)
		
			//Remove next Cell from locations queue
			
			//Check if snake head collided with this piece
			
			//Re-add Cell to locations queue
		
		//Remove and re-add snake head to locations queue to maintain proper order
		
	}//end checkCollisions
	
	/// @func update()
	/// @desc Moves the snake in its currently traveling direction by updating the position of the Snake's head,
	///       removing the Snake's tail, and adding the new Snake head.
	/// @return {undefined}
	function update() {
		//Update x and y positions of the head of the snake

		//Remove Snake tail from the queue and store as lastTail
		//Insert new Snake head into the queue
	}//end update
	
	/// @func moveUp()
	/// @desc Sets the current direction of the Snake to up. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveUp() {
		
	}//end moveUp
	
	/// @func moveDown()
	/// @desc Sets the current direction of the Snake to down. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveDown() {
			
	}//end moveDown
	
	/// @func moveRight()
	/// @desc Sets the current direction of the Snake to right. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveRight() {
		
	}//end moveRight
	
	/// @func moveLeft()
	/// @desc Sets the current direction of the Snake to left. (HINT: You should not be able to move 180 degrees)
	/// @return {undefined}
	function moveLeft() {

	}//end moveLeft
	
	/// @func toArray()
	/// @desc Returns an array containing the Cells from the locations queue for easier traversal outside of the Snake struct.
	///       (Cells are to be inserted into the array in the same order they are stored in the queue)
	///       (The order of the cells in the locations queue should be in tact after this function terminates (not necessarily during) )
	/// @return {Array<Struct.Cell>} An array containing the Cells from the locations queue
	function toArray() {
		//Create an empty array the same length as the snake for holding Cells.
		
		//Loop through all elements of the array, filling each with Cells from the locations queue
		
			//Pop the next Cell off of the locations queue and store in the array
			//Place the Cell back into the back of the queue
		
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