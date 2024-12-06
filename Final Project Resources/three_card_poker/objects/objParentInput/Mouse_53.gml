/// @desc Changes the state of the input box when the player interacts with is
/// AUTHOR Ewan Hurley


if (enabled && point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) { //Checks if the mouse is hovering over it
	focused = true;
	image_index = 2;
	text = "";
	validBet = false;
} else { //Checks if the mouse isn't hovering over the box
	focused = false;
	image_index = 0;
	
	if (text == "") text = "0"; //Prevents error when reading text
	
	if (int64(text) != real(text)) text = string_format(real(text), 1, 2); //Removes extra decimals
	
	validBet = true;
}//end if