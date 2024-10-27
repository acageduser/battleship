/// @file Defines Ship Struct for handling Ship location and state in the game of Battleship
/// @author Griffin Nye
/// Date Created: 5/16/24
/// Date Modified: 10/19/24
/// Dependencies: n/a

/// @func Ship(_x, _y, _size, _vert)
/// @desc Constructor for the Ship struct. Creates a Ship with the specified size at the specified
///       coordinates with the specified orientation for the game of Battleship.
/// @param {real} _x X coordinate of ships first notch on grid
/// @param {real} _y Y coordinate of ships first notch on grid
/// @param {real} _size The length of the ship
/// @param {bool} vert True if ship vertical. False if ship horizontal
/// @return {Struct.Ship} The new instance of the Ship struct
function Ship(_x, _y, _size, _vert) constructor {
	xPos = _x;    //Starting x coordinate
	yPos = _y;    //Starting y coordinate
	size = _size; //Ship length
	vert = _vert; //Ship orientation
	
	numHits = 0;  //Number of hits currently on the ship 
	
	locations = array_create(size); //String array containing x and y coordinates of the ship
	
	//Populate locations array with Ship coordinates
	for(var i = 0; i < size; i++) {
		
		//Create a space_separated string of x and y coordinates
		locations[i] = string(_x) + " " + string(_y);
			
		if (vert == true) {
			_y++;	
		} else {
			_x++;
		}//end if
		
	}//end for

	/// @func isSunk()
	/// @desc Returns if ship has been sunk or not yet.
	/// @return {bool} True if ship has been sunk. False otherwise.
	function isSunk() {
		return numHits == size;
	}//end isSunk
	
	/// @func getLocations()
	/// @desc Returns the locations array. (For setting UI cells when ship is sunk).
	/// @return {Array<String>} String array containing space-separated ship locations.
	function getLocations() {
		return locations;
	}//end getLocations
	
	/// @func getSize()
	/// @desc Returns the length of the Ship.
	/// @return {real} The length of the Ship.
	function getSize() {
		return size;
	}//end getSize
	
	/// @func isVertical()
	/// @desc Returns whether or not the Ship is of vertical orientation based on the value of the vert attribute.
	/// @return {bool} True if vertical, false if horizontal.
	function isVertical() {
		return vert;
	}//end getVert
	
	/// @func isHit(shotX, shotY)
	/// @desc Returns if a shot at the specified coordinates would hit the ship
	/// @param {real} shotX X coordinate of shot on the grid
	/// @param {real} shotY Y coordinate of shot on the grid
	/// @return {bool} True if hit, false otherwise.
	function isHit(shotX, shotY) {
		var shot = string(shotX) + " " + string(shotY); //Build space-separated string
		var loc = array_get_index(locations, shot);     //Search for string in locations array
		
		return loc != -1; //If loc == -1, then string was not found.
	}//end isSunk
	
	/// @func takeHit(shotX, shotY)
	/// @desc Processes a hit at the specified coordinates. 
	///       NOTE: coordinates must be a valid hit. First check if hit would be valid using isHit() before calling this function.
	/// @param {real} shotX X coordinate of shot on the grid
	/// @param {real} shotY Y coordinate of shot on the grid
	/// @return {undefined}
	function takeHit(shotX, shotY) {
		var shot = string(shotX) + " " + string(shotY); //Build space-separated string
		var loc = array_get_index(locations, shot);     //Search for string in locations array
		
		if (loc != -1) {
			numHits++;
		} else { //Error message
			show_message("InvalidCoordinatesException: Coordinates passed to this function must be a valid hit. Please use isHit() first to verify.");
		}//end if
	}//end takeHit


	/// @func toString()
	/// @desc Returns a string representation of the Ship as a list of its coordinates using Battleship notation. Great for testing and debugging ;)
	/// @return {string} A string representation of the Ship using Battleship notation (Letter and Number, ex. A5)
	function toString() {
		str = "";
		
		for(var i = 0; i <  array_length(locations); i++) {
			var loc = string_split(locations[i], " "); //Split string on space
			var _x = loc[0];                           //Store x and y locations
			var _y = loc[1];
			
			str += chr( ord("A") + _y) + _x + " ";     //Convert y coordinate to letter equivalent and add both to string
		}//end for
		
		return string_trim(str); //Trim excess whitespace from string
		
	}//end toString
	
}//end Ship