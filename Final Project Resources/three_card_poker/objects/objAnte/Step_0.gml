/// @desc Updates the input text
/// AUTHOR Ewan Hurley


if (enabled && focused) {
	var input = keyboard_lastchar;
	
	if (keyboard_check(vk_anykey) && !keyboard_check(vk_backspace) && string_length(text) < 10) { //Checks for valid input (not including backspace)
		if (string_length(string_digits(input)) || (input == "." && string_count(".", text) == 0)) { //Checks for valid number or decimal
			text += input;
		}//end if
	}//end if
	
	if (keyboard_check_pressed(vk_backspace) && deleteTimer == 0) { //Checks if backspace is pressed
		text = string_delete(text, string_length(text), 1); //Deletes the last character in the string
		deleteTimer = 6;
	}//end if
	
	if (keyboard_check(vk_backspace) && !keyboard_check_pressed(vk_backspace) && deleteTimer == 0) { //Checks if backspace is held
		text = string_delete(text, string_length(text), 1); //Delete the last character in the string
		deleteTimer = 4;
	}//end if
	
	keyboard_lastchar = "";
	
	if (deleteTimer != 0) deleteTimer--;
}//end if