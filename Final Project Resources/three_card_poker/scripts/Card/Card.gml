/// @file Structure for representing a card in a standard deck of playing cards.
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: n/a

/// @func Card(r,s)
/// @desc Constructs an instance of a Card given the rank and suit as enumerated types. Enumerated types are called RANK and SUIT.
///       RANK has the following values: TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, & ACE.
///       SUIT has the following values: CLUBS, DIAMONDS, HEARTS, & SPADES.
/// @param {enum.RANK} r The rank of the card
/// @param {enum.SUIT} s The suit of the card
/// @return {struct.Card} New instance of the Card struct.
function Card(r, s) constructor {
	//An enumerated representation of the suit of a playing card
	//LENGTH is added to make ENUM iteration more intuitive
	enum SUIT {CLUBS, DIAMONDS, HEARTS, SPADES, LENGTH};
	
	//An enumerated representation of the rank of a playing card
	//LENGTH is added to make ENUM iteration more intuitive
	enum RANK {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE, LENGTH};
	
	suit = s; //Represents the suit of the card
	rank = r; //Represents the rank of the card
	
	/// @func setSuit(s)
	/// @desc Sets the suit of the playing card to the specified enumerated type. 
	///       Enumerated type is called SUIT and contains values: CLUBS, DIAMONDS, HEARTS, & SPADES.
	///       (Use should be avoided, but is sometimes necessary, for example, when setting the suit in Crazy 8's)
	/// @param {enum.SUIT} s The new suit of the card.
	//Return: n/a
	function setSuit(s) {
		suit = s;
	}//end setSuit
	
	/// @func getRank()
	/// @desc Returns the rank of the playing card as an enumerated type. Enumerated type is called RANK and contains the following values:
	///       TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, & ACE.
	/// @return {enum.RANK} The rank of the playing card
	function getRank() {
		return rank;
	}//end getRank
	
	/// @func getSuit()
	/// @desc Returns the suit of the playing card as an enumerated type. Enumerated type is called SUIT and contains the following values:
	///       CLUBS, DIAMONDS, HEARTS, & SPADES.
	/// @return {enum.SUIT} The suit of the playing card
	function getSuit() {
		return suit;
	}//end getSuit
	
	/// @func toString()
	/// @desc Returns a string representation of the playing card.
	/// @return {string} String representation of the playing card
	function toString() {
		var ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"];
		var suits = ["C","D","H","S"];
		
	    //Enum types are essentially placeholders for integers in GML
	    //meaning they are substituted with their integer indexes during compile time
	    //Allowing us to just use the rank and suit attributes as the indices for the array.
		return ranks[rank] + suits[suit];
	}//end toString
	
}//end Card