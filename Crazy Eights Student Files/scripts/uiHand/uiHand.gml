/// @file Structure for storing and displaying a Hand of Cards on the UI
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: Struct.Card, Struct.Hand, objCard

/// @func uiHand(_x, _y, _w, _cpu)
/// @desc Creates a visual depiction of a Hand at the specified coordinates with the specified maximum width.
///       (NOTE: Does not draw the hand, for that, use uiHand.drawHand() )
/// @param {real} _x The center x position for the Hand on the UI
/// @param {real} _y The center y position for the Hand on the UI
/// @param {real} maxWidth The maximum width of the Hand on the UI
/// @param {boolean} _cpu Indicates if uiHand is CPU player Hand (hide cards)
/// @return {Struct.uiHand} New instance of the uiHand Struct
function uiHand(_x, _y, _w, _cpu) constructor{
	
	cards = array_create(0); //Array for storing objCard instances
	xPos = _x;               //The center x position for the Hand on the UI
	yPos = _y;               //The center y position for the Hand on the UI
	maxWidth = _w;           //The maximum width of the Hand on the UI
	isCPU = _cpu;            //Whether or not the uiHand is a CPU Hand
	clickable = true;        //Whether or not objCard elements are clickable
	
	/// @func drawHand(hand)
	/// @desc Draws a visual representation of the state of the given Hand struct on the UI
	/// @param {Struct.hand} The Hand to be drawn on the UI
	/// @return {undefined}
	function drawHand(hand) {
		
		//Sort the Hand Struct by Suit and then Rank
		hand.sortBySuitThenRank(); 
		
		//Destroy all instances of objCard drawn by this uiHand previously
		destroyInstances();
		
		//Resize the cards array to match size of Hand struct
		array_resize(cards, hand.getCardCount() );
		
		var spriteIndex = object_get_sprite(objCard);             //Get spriteIndex for measuring its width and height (needed when no objCard objects exist in the Room)
		var spriteWidth = sprite_get_width(spriteIndex) * 0.25;   //Get spriteWidth (with 1/4 scale)
		var spriteHeight = sprite_get_height(spriteIndex) * 0.25; //Get spriteHeight (with 1/4 scale)
		var totalWidth = hand.getCardCount() * spriteWidth;       //Total width it would take to draw each Card non-overlapping
		
		//Use non-overlapping placement if it fits within max width, otherwise space Cards equally within maxWidth
		var horizSpacing = totalWidth <= maxWidth ? spriteWidth : (maxWidth - spriteWidth) / (hand.getCardCount() - 1);
		//Determine starting x position based on non-overlapping or overlapping placement
		var startX = totalWidth <= maxWidth ? xPos - totalWidth / 2 + spriteWidth / 2 : xPos - maxWidth/2 + spriteWidth/2;
		
		//Iterate backwards so that rightmost objCards appear above leftmost objCards (depth decreases for each object instance placed on the layer)
		for(var i = hand.getCardCount() - 1; i >= 0; i--) {
			var uiCard = instance_create_layer(startX + (i * horizSpacing), yPos, "Instances", objCard);  //Create objCard at specified coordinates
			uiCard.rank = hand.getCard(i).getRank();                  //Set rank of objCard
			uiCard.suit = hand.getCard(i).getSuit();                  //Set suit of objCard
			uiCard.clickable = clickable;                             //Set whether objCard should be clickable
			uiCard.image_xscale = 0.25;                               //Set image scale to 1/4
			uiCard.image_yscale = 0.25;
			
			//If CPU hide cards
			if (isCPU) {
				image_index = 0;
			} else { //If player, show cards
				uiCard.image_index = uiCard.rank * 4 + uiCard.suit + 1;   //Set appropriate image index to represent Card
			}//end if
			
			cards[i] = uiCard; //Add created objCard instance to cards array
		}//end for
		
	}//end drawHand
	
	/// @func findIdx(card)
	/// @desc Returns the index of the specified objCard instance within the uiHand.
	/// @param {ID.Instance} card The instance ID of the objCard object to be searched for (Used for handling user click input)
	/// @return {real} The index of the specified objCard instance within the uiHand (-1 if not found)
	function findIdx(card) {
		return array_get_index(cards, card);
	}//end findIdx
	
	/// @func getInstance(idx)
	/// @desc Returns the objCard instance at the specified index within the uiHand
	/// @param {real} idx The index of the objCard instance being requested
	/// @return {ID.Instance} The objCard instance found at the specified index
	function getInstance(idx) {
		return cards[idx];
	}//end getInstance
	
	/// @func destroyInstances()
	/// @desc Destroys all instances of objCard produced by this uiHand.
	///       Helper function to drawHand().
	/// @return {undefined}
	function destroyInstances() {
		
		for(var i = 0; i < array_length(cards); i++) {
			instance_destroy( cards[i] );
		}//end for
		
	}//end destroyInstances
	
	/// @func setClickable(canClick)
	/// @desc Sets whether or not the UI element should be clickable based on the argument provided.
	/// @param {boolean} canClick True if the UI element should be clickable, false otherwise.
	/// @return {undefined}
	function setClickable(canClick) {
		clickable = canClick;
	}//end setClickable

}//end uiHand