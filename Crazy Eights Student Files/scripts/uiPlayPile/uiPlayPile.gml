/// @file Structure for storing and displaying a Play Pile on the UI
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: Struct.Card, Struct.CrazyEightsPile, objPile

//Constructor
/// @func uiPlayPile(_x,_y)
/// @desc Constructs the playPile for the UI at the specified coordinates.
///       (NOTE: Does not draw the Play Pile, for that, use uiPlayPile.drawPile() )
/// @param {real} _x The center X position for the playPile on the UI
/// @param {real} _y The center Y position for the playPile on the UI
/// @return {Struct.uiPlayPile} New Instance of the uiPlayPile struct.
function uiPlayPile(_x, _y) constructor {
	
	xPos = _x;               //Center x position of UI element
	yPos = _y;				 //Center y position of UI element
	instance = undefined;    //Instance ID of the UI element
	rank = undefined;        //Rank of the Card displayed by UI element
	suit = undefined;        //Suit of the Card displayed by UI element

	/// @func drawPile(playPile)
	/// @desc Draws a visual representation of the state of the given Pile struct on the UI
	/// @param {Struct.CrazyEightsPile} playPile The playPile to be drawn on the UI
	/// @return {undefined}
	function drawPile(playPile) {
		
		//Set rank and suit properties
		self.rank = playPile.getTop().getRank();
		self.suit = playPile.getTop().getSuit();
		
		//Destroy previous instance before creating next instance
		if (instance_exists(instance) ) {
			instance_destroy(instance);
		}//end if
		
		//Create and store instance of objPile at specified position
		instance = instance_create_layer(xPos, yPos, "Instances", objPile);
		
		//Set scale for displayed instance
		instance.image_xscale = 0.25;
		instance.image_yscale = 0.25;
		
		//Set Suit and Rank for displayed instance
		instance.rank = self.rank;
		instance.suit = self.suit;
		
		//Set appropriate image index to display represented Card
		instance.image_index = rank * 4 + suit + 1;

	}//end drawPile
	
	/// @func destroyInstance()
	/// @desc Destroys the instance of objPile produced by this uiPlayPile
	/// @return {undefined}
	function destroyInstance() {
		instance_destroy(instance);
	}//end destroyInstance

}//end uiPlayPile