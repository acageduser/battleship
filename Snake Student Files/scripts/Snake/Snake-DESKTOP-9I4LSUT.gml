
//Name: Snake
//Desc: Creates a Snake at the specified x,y coordinate on the Board.
//Params: int _x - The x coordinate to place the Snake on the Board.
//        int _y - The y coordinate to place the Snake on the Board
//Return: Snake - new instance of the Snake object
function Snake(_x, _y) constructor {
	enum DIR {UP, DOWN, LEFT, RIGHT}; //Enum for directions the Snake can move
	direct = DIR.RIGHT;            //Stores the current direction of the Snake
	movements = [ [0, -1], [0, 1], [-1, 0], [1, 0] ]; //Parallel 2D array for storing the coordinate changes for movements
	xPos = _x;                     //The x position of the head of the Snake
	yPos = _y;                     //The y position of the head of the Snake
	length = 1;                    //The length of the snake
	locations = ds_queue_create(); //Queue for storing the Cells of all of the parts of the snake (Tail of snake is at head of queue)
	lastTail = new Cell(xPos, yPos);       //Stores the Cell that was the previous tail after it is dequeued (For setting Cell back to empty) (This could be useful for growing)
	
	//Place head of Snake in Queue and set it's status to snake
	ds_queue_enqueue(locations, lastTail);
	ds_queue_head(locations).setStatus(STATE.SNAKE);
	
	//Name: getSnakeHead
	//Desc: Returns the Cell representing the Snake's head from the locations queue.
	//Params: n/a
	//Return: Cell - The Cell representing the Snake's head
	function getSnakeHead() {
		return ds_queue_tail(locations);
	}//end getHead
	
	//Name: getLastTail
	//Desc: Returns the Cell that represents the Snake's previous tail after it was dequeued from the locations queue
	//Params: n/a
	//Return: Cell - The Cell representing the Snake's previous tail
	function getLastTail() {
		return lastTail;
	}//end getLastTail
	
	//Name: grow
	//Desc: Grows the Snake by one cell after consuming food and increases the Snake's length. 
	//      (Hint: You will want to grow the tail of the Snake, as growing the Head could cause it to grow out of bounds)
	//Params: n/a
	//Return: n/a
	function grow() {
		var newTail = 
		//Adds back the previous tail Cell to the locations queue to grow the Snake
		ds_queue_enqueue(locations, new Cell(lastTail.getX(), lastTail.getY() ) );
		ds_queue_tail(locations).setStatus(STATE.SNAKE);
		
		//Since we inserted the tail at the back of the queue, we need to shift it to the front
		//So, we will remove and re-add all the Cells in the locations queue, aside from the newly added tail
		for(var i = 0; i < length; i++) {
			var temp = ds_queue_dequeue(locations);
			ds_queue_enqueue(locations, temp);
		}//end for
		
		lastTail = newTail;
		
		
		length++; //Increment length
	}//end grow
	
	//Name: checkCollisions
	//Desc: Returns whether or not the Snake has collided with the boundaries of the grid or with itself.
	//Params: int width - The overall width of the grid (in Cells, not pixels)
	//        int height - The overall height of the gird (in Cells, not pixels)
	//Return: boolean - True if collision with wall or itself occurred, otherwise false.
	function checkCollisions(width, height) {
		
		//Check if snake has stayed within the bound of the screen
		if (xPos < 0 || xPos >= width || yPos < 0 || yPos >= height) {
			return true;	
		}//end if
		
		//Check if snake's head has collided with any pieces of its body (except itself)
		for(var i = 0; i < length - 1; i++) {
			var temp = ds_queue_dequeue(locations); //Remove next Cell from locations queue
			
			//Check if snake head collided with this piece
			if (temp.getX() == xPos && temp.getY() == yPos) {
				return true;	
			}//end if
			
			ds_queue_enqueue(locations, temp); //Re-add Cell to locations queue
		}//end for
		
		//Remove and re-add snake head to locations queue to maintain proper order
		var temp = ds_queue_dequeue(locations);
		ds_queue_enqueue(locations, temp);
		
		return false;
	}//end checkCollisions
	
	//Name: update
	//Desc: Moves the snake in its currently traveling direction by updating the position of the Snake's head,
	//      removing the Snake's tail, and adding the new Snake head.
	//Params: n/a
	//Return: n/a
	function update() {
		xPos += movements[direct][0]; //Update x and y positions of the head of the snake
		yPos += movements[direct][1];
		lastTail = ds_queue_dequeue(locations);  //Remove Snake tail from the queue and store as lastTail
		ds_queue_enqueue(locations, new Cell(xPos, yPos) ); //Insert new Snake head into the queue
		ds_queue_tail(locations).setStatus(STATE.SNAKE);    //Update new Snake head to Snake status
	}//end move
	
	//Name: moveUp
	//Desc: Sets the current direction of the Snake to up. (HINT: You should not be able to move 180 degrees)
	//Params: n/a
	//Return: n/a
	function moveUp() {
		
		//Can only move up if moving left or right
		if (direct != DIR.DOWN) {
			direct = DIR.UP;  //Change direction	
		}//end if
		
	}//end moveUp
	
	//Name: moveDown
	//Desc: Sets the current direction of the Snake to down. (HINT: You should not be able to move 180 degrees)
	//Params: n/a
	//Return: n/a
	function moveDown() {
		
		//Can only move down if moving left or right
		if (direct != DIR.UP) {
			direct = DIR.DOWN;  //Change direction
		}//end if
			
	}//end moveDown
	
	//Name: moveRight
	//Desc: Sets the current direction of the Snake to right. (HINT: You should not be able to move 180 degrees)
	//Params: n/a
	//Return: n/a
	function moveRight() {
		
		//Can only move right if moving up or down
		if (direct != DIR.LEFT) {
			direct = DIR.RIGHT;  //Change direction
		}//end if
		
	}//end moveRight
	
	//Name: moveLeft
	//Desc: Sets the current direction of the Snake to left. (HINT: You should not be able to move 180 degrees)
	//Params: n/a
	//Return: n/a
	function moveLeft() {
		
		//Can only move left if moving up or down
		if (direct != DIR.RIGHT) {
			direct = DIR.LEFT;  //Change direction
		}//end if

	}//end moveLeft
	
	//Name: toArray
	//Desc: Returns an array containing the Cells from the locations queue for easier traversal outside of the Snake struct.
	//      (Cells are to be inserted into the array in the same order they are stored in the queue)
	//      (The Cells and the order should remain in tact after this function terminates (not necessarily during) )
	//Params: n/a
	//Return: Cell[] - An array containing the Cells from the locations queue
	function toArray() {
		var pieceList = array_create(length);
		
		//Loop through all elements of the array, filling them with Cells from the locations queue
		for (var i = 0; i < length; i++) {
			pieceList[i] = ds_queue_dequeue(locations); //Pop the next Cell off of the locations queue and store in the array
			ds_queue_enqueue(locations, pieceList[i]);  //Place the Cell back into the back of the queue
		}//end for
		
		return pieceList;
	}//end toArray
	
	
	//Name: toString
	//Desc: Returns a string representation of the Snake via its location queue
	//Params: n/a
	//Return: String - A string representation of the Snake
	function toString() {
		str = "";
		
		for(var i = 0; i < ds_queue_size(locations); i++) {
			var currPiece = ds_queue_dequeue(locations); //Pop the next Cell off of the locations queue
			var strPiece = string(currPiece.getX() ) + " " + string(currPiece.getY() ); //Create string representation of the coordinates of currPiece
			str = strPiece + " " + str; //Add string representation to front of final string
			ds_queue_enqueue(locations, currPiece); //Place the current Cell back into locations queue
		}//end for
		
		str = string_trim(str);
		
		return str;
	}//end toString
	

}//end Snake
