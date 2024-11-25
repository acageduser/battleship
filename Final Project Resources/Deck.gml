/// @file Structure for representing, storing, and handling operations on a standard 52 card Deck of Playing Cards, handled via ds_lists
/// @author Griffin Nye
/// Date Created: 11/9/24
/// Date Modified: 11/9/24
/// Dependencies: Struct.Card

/// @file Deck()
/// @desc Constructs a standard deck of playing cards.
/// @return {Struct.Deck} New instance of Deck struct.
function Deck() constructor {
	deck = ds_list_create(); //List containing the Card objects

	//Populate the deck
	for (var s = SUIT.CLUBS; s < SUIT.LENGTH; s++) {
		for (var r = RANK.TWO; r < RANK.LENGTH; r++) {
			ds_list_add(deck, new Card(r,s) ); //Construct new Card and place it on top of the deck
		}//end for
	}//end for
	
	/// @func shuffle()
	/// @desc Return all used cards to the deck (if any) and shuffle the deck.
	/// @return {undefined}
	function shuffle() {
		var idx = 0; //Temp counter for index
		
		//Fill array with all 52 Cards by iterating through enums
		for( var s = SUIT.CLUBS; s < SUIT.LENGTH; s++) {
			for( var r = RANK.TWO; r < RANK.LENGTH; r++) {
				deck[|idx] = new Card(r,s); //Create new card using rank and suit and store in list
				idx++;                      //Increment index
			}//end for
		}//end for

		randomize();                //Generate random seed for ds_list_shuffle() (Without it, "random" generation would be the same every time)
		ds_list_shuffle(deck);      //Shuffle the deck
		
	}//end shuffle
	
	/// @func reshuffle()
	/// @desc Reshuffles the current Cards in the deck. (Does not re-populate the deck, for that, use shuffle() )
	/// @return {undefined}
	function reshuffle() {
		randomize();
		ds_list_shuffle(deck);
	}//end reshuffle
	
	/// @func cardsLeft()
	/// @desc Returns the number of Cards remaining in the deck.
	/// @return {real} The number of Cards remaining in the deck.
	function cardsLeft() {
		return ds_list_size(deck);
	}//end cardsLeft
	
	/// @func deal()
	/// @desc Removes and returns the top Card from the deck.
	/// @return {Struct.Card} The top Card from the deck.
	function deal() {
		var card = deck[|0];
		ds_list_delete(deck, 0);
		return card;
	}//end deal
	
	/// @func isEmpty()
	/// @desc Returns if the deck is currently empty.
	/// @return {boolean} True if empty, false otherwise
	function isEmpty() {
		return cardsLeft() == 0;
	}//end isEmpty

	/// @func toString()
	/// @desc Returns a string representation of the deck (mainly for debug purposes as Card.toString() exists)
	/// @return {string} String representation of the deck.
	function toString() {
		str = "";
		
		for (var i = 0; i < ds_list_size(deck); i++) {
			str += deck[|i].toString() + " ";
		}//end for
		
		return string_trim(str);
	}//end toString

}//end Deck