/// @file Structure for storing and displaying a DrawPile on the UI
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: objDrawPile

/// @func uiDrawPile()
/// @desc Constructs the drawPile for the UI at the specified coordinates. 
///       (NOTE: Does not draw the Pile to the screen, for that, use uiDrawPile.drawPile() )
/// @param {real} _x The center X position for the drawPile on the UI
/// @param {real} _y The center Y position for the drawPile on the UI
/// @return {Struct.uiDrawPile} New Instance of the uiDrawPile
function uiDrawPile(_x, _y) constructor{
	
	xPos = _x;            //Center x position for the drawPile on the UI
	yPos = _y;            //Center y position for the drawPile on the UI
	instance = undefined; //Instance ID of the UI element
	clickable = true;     //Whether drawPile is clickable or not
	
	/// @func drawPile(cardsLeft)
	/// @desc Draws a visual representation of the state of the drawPile on the UI,
	///       using the number of cards left on the pile as a reference.
	/// @param {real} cardsLeft The number of cards left in the drawPile.
	/// @return {undefined}
	function drawPile(cardsLeft) {
		
		//Destroy previous instance before creating next instance
		if (instance_exists(instance) ) {
			instance_destroy(instance);
		}//end if
		
		//Create and store instance of objDrawPile at the specified position.
		instance = instance_create_layer(xPos, yPos, "Instances", objDrawPile);
		
		//Set the scale of the cards
		instance.image_xscale = 0.25;
		instance.image_yscale = 0.25;
		
		//Set clickable property for objDrawPile
		instance.clickable = clickable;
		
		//Set Image index to display "PASS" option if no cards left in drawPile
		if (cardsLeft == 0) {
			instance.image_index = 53;
		}//end if
		
	}//end function
	
	/// @func setClickable(canClick)
	/// @desc Sets whether or not the UI element should be clickable based on the specified value.
	/// @param {boolean} canClick True if the UI element should be clickable, false otherwise.
	/// @return {undefined}
	function setClickable(canClick) {
		clickable = canClick;
	}//end setClickable
	
	/// @func destroyInstance
	/// @desc Destroys the instnace of objDrawPile produced by this uiDrawPile
	/// @return {undefined}
	function destroyInstance() {
		instance_destroy(instance);
	}//end destroyInstance
	
}//end uiDrawPile
