/// @file Structure for representing, storing, and handling operations on a standard 52 card Deck of Playing Cards
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: Struct.Card

/// @file Deck()
/// @desc Constructs a standard deck of playing cards.
/// @return {Struct.Deck} New instance of Deck struct.
function Deck() constructor {
	deck = ds_stack_create(); //Stack containing the Card objects

	//Populate the deck
	for (var s = SUIT.LENGTH - 1; s >= SUIT.CLUBS; s--) {
		for (var r = RANK.LENGTH - 1; r >= RANK.TWO; r--) {
			ds_stack_push(deck, new Card(r,s) ); //Construct new Card and place it on top of the deck
		}//end for
	}//end for
	
	/// @func shuffle()
	/// @desc Return all used cards to the deck (if any) and shuffle the deck.
	/// @return {undefined}
	//Created by Ewan, Ryan, and Jimmy
	function shuffle() {
		temp = array_create(52); //Create temporary array for 52 cards
		//Temp counter for index
		var idx = 0;
		
		//Create all 52 cards in the temp array
		for (var s = SUIT.LENGTH - 1; s >= SUIT.CLUBS; s--) {
			for (var r = RANK.LENGTH - 1; r >= RANK.TWO; r--) {
				temp[idx] = new Card(r, s);
				idx++;
			}//end for
		}//end for
		
		//Fill array with all 52 Cards by iterating through enums
				//Create new card using rank and suit and store in array
				//Increment index

		randomize();                //Generate random seed for array_shuffle() (Without it, "random" generation would be the same every time)
		temp = array_shuffle(temp); //Shuffle the temp array of Cards
		ds_stack_clear(deck);		//Clear the deck entirely
		
		//Push the shuffled cards into the deck
		for (var i = 0; i < array_length(temp); i++) {
			ds_stack_push(deck, temp[i]);
		}//end for
		
		//Move all Cards from the temp array into the deck
		
	}//end shuffle
	
	/// @func reshuffle()
	/// @desc Reshuffles the current Cards in the deck. (Does not re-populate the deck, for that, use shuffle() )
	/// @return {undefined}
	//Created by Jimmy and Ryan
	function reshuffle() {
		//Create temp array size of the deck
        var temp = array_create(ds_stack_size(deck));
        
        //Move contents of deck into temp array
        var idx = 0;
        while (!ds_stack_empty(deck)) {
            temp[idx] = ds_stack_pop(deck);
            idx++;
        }//end while

        //Shuffle the array (DON'T FORGET RANDOMIZE)
        randomize();
        temp = array_shuffle(temp);

        //Add contents of temp array back into deck
        for (var i = 0; i < array_length(temp); i++) {
            ds_stack_push(deck, temp[i]);
        }//end for
	}//end reshuffle
	
	/// @func cardsLeft()
	/// @desc Returns the number of Cards remaining in the deck.
	/// @return {int} The number of Cards remaining in the deck.
	//Created by Ewan
	function cardsLeft() {
		//Returns the size of the deck
		return ds_stack_size(deck);
	}//end cardsLeft
	
	/// @func deal()
	/// @desc Removes and returns the top Card from the deck.
	/// @return {Struct.Card} The top Card from the deck.
	//Created by Ewan
	function deal() {
		//Pops the top card from the deck and returns the card
		return ds_stack_pop(deck);
	}//end deal
	
	/// @func isEmpty()
	/// @desc Returns if the deck is currently empty.
	/// @return {boolean} True if empty, false otherwise
	//Created by Ryan
	function isEmpty() {
		//Return whether or not the size of the deck is 0
		return ds_stack_empty(deck);
	}//end isEmpty

	/// @func toString()
	/// @desc Returns a string representation of the deck (mainly for debug purposes as Card.toString() exists)
	/// @return {string} String representation of the deck.
	//Created by Ewan, modified by Ryan
	function toString() {
		var size = ds_stack_size(deck);
		var temp = array_create(size);
		var str = "";
		
		//Loop through the deck and pop the top card onto the temp array
		for (var i = 0; i < size; i++) {
			temp[i] = ds_stack_pop(deck);
		}//end for
		
		//Reverse the temp array
		temp = array_reverse(temp);
		
		//Loop through the temp array and add the cards to the string and deck
		for (var i = 0; i < size; i++) {
			str += temp[i].toString() + " ";
			ds_stack_push(deck, temp[i]);
		}//end for
		
		//Return the string
		return string_trim(str);
	}//end toString

}//end Deck