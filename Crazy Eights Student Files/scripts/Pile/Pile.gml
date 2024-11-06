/// @file Structure for representing, storing, and handling operations for a Play Pile in the game of Crazy Eights.
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: Struct.Card

//Constructor
/// @file CrazyEightsPile()
/// @desc Constructs a new Play Pile for the game of Crazy Eights
/// @return {Struct.CrazyEightsPile} New instance of CrazyEightsPile struct.
function CrazyEightsPile() constructor {

	pile = ds_stack_create();  //Stack for representing the Play Pile
	
	/// @func deal(c)
	/// @desc Deals the first Card of the round onto the play pile. Returns whether redeal is necessary.
	///       Redeals are necessary if the first card played to the Pile is a Crazy 8. In this case, the card is not added to the pile and true is returned.
	///       Any other cards are acceptable. In this case, the card is added to the pile and false is returned.
	/// @param {Struct.Card} c The first Card to be dealt onto the play pile.
	/// @return {boolean} True if redeal necessary, false otherwise.
	function deal(c) {
		if (c.getRank() == RANK.EIGHT) {
			return true; //Return true for redeal
		} else {
			ds_stack_push(pile, c); //Push card to the top of the pile
			return false; //Return false to not redeal
		}//end if
	}//end deal
	
	/// @func canPlayCard(c)
	/// @desc Determines whether the specified Card can be played to the play pile according to the rules of Crazy 8's.
	///       Returns the type of play as an enumerated type called PLAYTYPE. PLAYTYPE has 3 values: WILD, VALID, & INVALID.
	///       WILD indicates Crazy Eight was played.
	///       VALID indicates standard valid play.
	///       INVALID indicates card cannot be played to the pile.
	/// @param {Struct.Card} c The card attempting to be played to the play pile.
	/// @return {enum.PLAYTYPE} WILD if Crazy Eight Played, VALID if standard valid play, or INVALID
	function canPlayCard(c) {
		enum PLAYTYPE {WILD, VALID, INVALID};
		
		if (c.getRank() == RANK.EIGHT) {
			//If an 8 is played, return WILD
			return PLAYTYPE.WILD;
		} else if (c.getRank() == getTop().getRank() || c.getSuit() == getTop().getSuit()) {
			//If a valid card is played, return VALID
			return PLAYTYPE.VALID;
		} else {
			//If the card isn't valid or an eight, return INVALID
			return PLAYTYPE.INVALID;
		}//end if
	}//end canPlayCard
	
	/// @func addCard(c)
	/// @desc Adds the specified Card to the play pile.
	/// @param {Struct.Card} The card to be added
	/// @return {undefined}
	function addCard(c) {
		//pushes the card onto the top of the pile
		ds_stack_push(pile, c);
	}//end addCard
	
	/// @func getTop()
	/// @desc Returns the Card found on top of the pile (does not remove it).
	/// @return {Struct.Card} The Card on top of the pile
	function getTop() {
		//Return the top card without removing it
		return ds_stack_top(pile);
	}//end getTop
	
	/// @func toString()
	/// @desc Returns a String representation of the Pile
	/// @return {string} A String representation of the Pile
	function toString() {
		var size = ds_stack_size(pile);
		var temp = array_create(size);
		var str = "";
		
		//Loop through the pile and pop the top card onto the temp array
		for (var i = 0; i < size; i++) {
			temp[i] = ds_stack_pop(pile);
		}//end for
		
		//Reverse the temp array
		temp = array_reverse(temp);
		
		//Loop through the temp array (except for the last value) and add the cards to the string and pile
		for (var i = 0; i < size - 1; i++) {
			str += string(temp[i]) + " ";
			ds_stack_push(pile, temp[i]);
		}//end for
		
		//Add the last card to the string and pile
		str += string(temp[size-1]);
		ds_stack_push(pile, temp[size-1]);
		
		//Return the string
		return str;
	}//end toString
	
}//end CrazyEightsPile