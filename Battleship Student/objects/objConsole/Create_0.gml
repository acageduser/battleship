/// @description Declares and initializes attributes and defines methods for objConsole. 

messageList = array_create(24,"");  //Array for storing messages displayed
currIdx = 0;                        //Current index of next open slot in messageList


/// @func print(msg)
/// @desc Prints a message to the console, by adding it to the messageList. 
///       If the messageList is not full, message is placed in the next open slot. 
///       If the messageList is currently full, removes oldest message, slides all 
///       messages one index towards the front and inserts the specified message in the last slot.
/// @param {string} msg The message to be printed
/// @return {undefined}
function print(msg) {
	
	//If messageList is not yet full, place in next open slot in array
	if (currIdx < array_length(messageList) ) {
		
		messageList[currIdx] = msg; //Place message in array
		currIdx++;                  //Increment index of next open slot
		
	} else {
		
		//Shift all messages towards the front of the array, removing the oldest message
		array_shift(messageList);
		//for(var i = 0; i < array_length(messageList) - 1; i++) {
		//	messageList[i] = messageList[i+1];
		//}//end for
		
		//Shove new message in the last slot of the array.
		array_push(messageList, msg);
		//messageList[array_length(messageList) - 1] = msg;
		
	}//end if
	
}//end displayMessage

/// @func clear()
/// @desc Clears and resets the console.
/// @return {undefined} 
function clear() {
	currIdx = 0;
}//end clear