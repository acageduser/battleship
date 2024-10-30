/// @file Defines Game Struct for the Game of Snake. Game Struct acts as the Game Controller, linking backend Game logic (Model)
//        to the UI (View) (Model-View-Controller Paradigm)
/// @author Griffin Nye
/// Date Created: 5/23/24
/// Date Modified: 10/24/24
/// Dependencies: Struct.Cell, Struct.Board,  Struct.Snake, objGridCell

/// @func Game()
/// @desc Constructs a new instance of the Game Struct, creating all necessary elements for the Snake Game
/// @return {Struct.Game} New instance of the Game struct.
function Game() constructor{
	
	var spriteIndex = object_get_sprite(objGridCell);              //Gets the sprite index of objGridCell
	var gridWidth = room_width / sprite_get_width(spriteIndex);    //Calculates the number of colums in the grid based on room and sprite width
	var gridHeight = room_height / sprite_get_height(spriteIndex); //Calculates the number of rows in the grid based on room and sprite height
	
	playerScore = 0;							  //Keeps track of the Player's score
	snake = new Snake(gridWidth/2, gridHeight/2); //Snake object created at center of board
	board = new Board(gridWidth, gridHeight);     //Creates the Board object for storing Grid state
	board.spawnFood(snake);                       //Spawn a randomly generated piece of food on the board
	
	uiGrid = ds_grid_create(gridWidth, gridHeight); //Grid for storing objGridCells for the User Interface
	
	//Fill the UI Grid with blank objGridCells
	for(var i = 0; i < ds_grid_width(uiGrid); i++) {
		for(var j = 0; j < ds_grid_height(uiGrid); j++) {
			uiGrid[#i,j] = instance_create_layer(32 * i + 16, 32 * j + 16, "Instances", objGridCell);
		}//end for
	}//end for
	
	/// @func reset()
	/// @desc Resets the game for the Player to play again
	/// @return {undefined}
	function reset() {
		var spriteIndex = object_get_sprite(objGridCell);              //Gets the sprite index of objGridCell
		var gridWidth = room_width / sprite_get_width(spriteIndex);    //Calculates the number of colums in the grid based on room and sprite width
		var gridHeight = room_height / sprite_get_height(spriteIndex); //Calculates the number of rows in the grid based on room and sprite height
	
		playerScore = 0;							  //Keeps track of the Player's score
		snake = new Snake(gridWidth/2, gridHeight/2); //Snake object created at center of board
		board = new Board(gridWidth, gridHeight);     //Creates the Board object for storing Grid state
		board.spawnFood(snake);                       //Spawn a randomly generated piece of food on the board
	
		//Reset all objGridCells back to their default state
		for(var i = 0; i < ds_grid_width(uiGrid); i++) {
			for(var j = 0; j < ds_grid_height(uiGrid); j++) {
				uiGrid[#i,j].image_index = 0;
			}//end for
		}//end for
	}//end reset
	
	/// @func updateUI()
	/// @desc Updates the objGridCells in the uiGrid to display the game's state as stored by board.
	/// @return {undefined}
	function updateUI() {
		
		for(var i = 0; i < ds_grid_width(uiGrid); i++) {
			for(var j = 0; j < ds_grid_height(uiGrid); j++) {

				//Update image index of objGridCell in uiGrid based on the Cell status in the Game board
				switch( board.getCell(i,j).getStatus() ) {
				case STATE.EMPTY:
					uiGrid[#i,j].image_index = 0;
					break;
				case STATE.FOOD:
					uiGrid[#i,j].image_index = 1;
					break;
				case STATE.SNAKE:
					uiGrid[#i,j].image_index = 2;
					break;
				}//end switch
				
			}//end inner for
		}//end outer for
		
	}//end updateUI
	
	/// @func processTurn()
	/// @desc Processes a single frame in the Snake Game. Returns -1 if game is terminated.
	/// @return {real} 0 for game continuation, -1 for game termination
	function processTurn() {
			
			//Update the snake based on its movement
			snake.update();
			
			//Check for game over
			if (snake.checkCollisions(ds_grid_width(uiGrid), ds_grid_height(uiGrid) ) ) {
				return -1;
			} else if ( checkFoodCollision() ) { //Check for collision with food
				snake.grow();            //Grow the Snake
				board.spawnFood(snake);  //Spawn another piece of food
				playerScore++;           //Increment the Player's score
			}//end if
			
			//Update the board to reflect the new game state
			board.update(snake);
			
			return 0;
	}//end processTurn
	
	/// @func checkFoodCollision()
	/// @desc Returns whether or not the Snake has collided with a piece of food.
	/// @return {bool} Returns true if the Snake has collided with a piece of food, otherwise false.
	function checkFoodCollision() {
		var headCell = snake.getSnakeHead(); //Get Cell containing the snake's head
		
		//Return whether the Cell containing the snake's head contains food
		return board.getCell(headCell.getX(), headCell.getY()).getStatus() == STATE.FOOD;
	}//end checkFoodCollision
	
	/// @func handleKeyPress()
	/// @desc Sets the Snakes direction based on user input.
	/// @param {vk_key} key Key code for the button pressed
	/// @return {undefined}
	function handleKeyPress(key) {
		
		switch(key) {
		case vk_up:
			snake.moveUp();
			break;
		case vk_down:
			snake.moveDown();
			break;
		case vk_right:
			snake.moveRight();
			break;
		case vk_left:
			snake.moveLeft();
			break;
		default:
			break;
		}//end switch
		
	}//end handleKeyPresses
	
	/// @func getScore()
	/// @desc Returns the Player's score
	/// @return {real} The Player's score
	function getScore() {
		return playerScore;
	}//end getScore
	
}//end Game