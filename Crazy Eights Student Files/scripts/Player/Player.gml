/// @file Player
/// @desc Structure for representing, storing, and handling actions for a Player in the game of Crazy Eights.
///       Typically used for Human players, but also acts as Parent Class for CPUPlayer Struct.
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: Struct.Card, Struct.Hand, Struct.CrazyEightsPile
/// Children: Struct.CPUPlayer

/// @file Player(_name)
/// @desc Constructs a new Player with the specified name for the game of Crazy Eights
/// @param {string} _name Name for the Player
/// @return {Struct.Player} New Instance of Player Struct.
function Player(_name) constructor {
	
	name = _name;      //Player's name
	hand = new Hand(); //Represents Player's hand
	points = 0;        //Player score
	
	/// @func drawCard(c)
	/// @desc Adds the specified Card from the draw pile to the Player's Hand.
	/// @param {Struct.Card} c The Card that was drawn from the draw pile.
	/// @return {undefined}
	function drawCard(c) {
		hand.addCard(c);
	}//end drawCard
	
	/// @func getHand()
	/// @desc Returns the Player's Hand struct (mainly for updating UI elements)
	/// @return {Struct.Hand} The Player's Hand
	function getHand() {
		return hand;		
	}//end getHand
	
	/// @func getName()
	/// @desc Returns the Player's name
	/// @return {string} The Player's name
	function getName() {
		return name;
	}//end getName
	
	/// @func getScore()
	/// @desc Returns the Player's score
	/// @return {real} The Player's score
	function getScore() {
		return points;
	}//end getScore
	
	/// @func addScore(roundPoints)
	/// @desc Adds the specified number of points to the Player's score
	/// @param {real} roundPoints The number of points to add to the Player's score
	/// @return {undefined}
	function addScore(roundPoints) {
		points += roundPoints;
	}//end addScore
	
	/// @func setScore(newScore)
	/// @desc Sets the Player's score to the specified value
	/// @param {real} newScore The new score to be set
	/// @return {undefined}
	function setScore(newScore) {
		points = newScore;
	}//end setScore
	
	/// @func getHandValue
	/// @desc Returns the point value of the Player's Hand (used for evaluating end of round)
	/// @return {real} Point value of the Player's Hand
	function getHandValue() {
		var pointTotal = 0;
		
		for( var i = 0; i < hand.getCardCount(); i++) {
			var cardRank = hand.getCard(i).getRank();
			
			//Increment point total based on Card rank
			if (cardRank == RANK.EIGHT) {
				pointTotal += 50;
			} else if (cardRank == RANK.JACK || cardRank = RANK.QUEEN || cardRank == RANK.KING) {
				pointTotal += 10;	
			} else if (cardRank == RANK.ACE) {
				pointTotal++;
			} else {
				//Uses index in CARD.RANK enum to determine face value
				//Since TWO is at index 0, index must be incremented by 2 to obtain face value 
				pointTotal += cardRank + 2;	
			}//end if
		
		}//end for
		
		return pointTotal;
	}//end getHandValue
	
	/// @func playCard(c, playPile)
	/// @desc Plays the specified Card from the Player's Hand onto the specified play pile
	/// @param {Struct.Card} c The Card from the Player's Hand to be played.
	/// @param {Struct.CrazyEightsPile} playPile The Play Pile to play the Card onto.
	/// @return {undefined}
	function playCard(c, playPile) {
		playPile.addCard(c); //Place the played card on the play pile
		hand.removeCard(c); //Remove the played card from the hand
	}//end playCard
	
	/// @func hasWonRound()
	/// @desc Returns whether the Player has won the round or not.
	/// @return {boolean} True if won, false otherwise.
	function hasWonRound() {
		return hand.getCardCount() == 0;
	}//end hasWon
	
	/// @func hasWonGame()
	/// @desc Returns whether the Player has won the game by reaching the score limit.
	/// @param {real} pointCap The score limit set for the game
	/// @return {boolean} True if Player has won, false otherwise.
	function hasWonGame(pointCap) {
		return points == pointCap;	
	}//end hasWonGame
	
}//end Player

/// @file Structure for storing, representing, and handling actions for a basic AI Player in the Game of Crazy Eights.
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: Struct.Card, Struct.Hand, Struct.CrazyEightsPile

/// @func CPUPlayer(_name)
/// @desc Constructs a new CPUPlayer with the specified name for the game of Crazy Eights.
/// @param {string} _name The name of the CPUPlayer
/// @return {Struct.CPUPlayer} New instance of CPUPlayer
function CPUPlayer(_name) : Player(_name) constructor {
	
	cardToPlay = -1;               //Index of the Card from the CPU's Hand to be played next
	moveQueue = ds_queue_create(); //Queue for storing the CPU's next planned move (mainly for if needing to draw again)
	
	/// @func startTurn()
	/// @desc Starts the CPU's turn by clearing the move queue and deciding next move based on the top card from the play pile.
	/// @param {Struct.Card} The top card from the play pile
	/// @return {undefined}
	function startTurn(topCard) {
		clearMoves();
		decideMove(topCard);
	}//end startTurn
	
	/// @func clearMoves()
	/// @desc Clears the move queue
	/// @return {undefined}
	function clearMoves() {
		ds_queue_clear(moveQueue);	
	}//end clearMoves
	
	/// @func queueMove(move)
	/// @desc Adds the specified move to the move queue. Helper function to decideMove().
	///       The move is represented as an enumerated type called MOVE, with the values:
	///       PLAYSTANDARD - Indicates a normal valid play (Match by rank or suit)
	///       PLAYWILD - Indicates a Crazy Eight is played
	///       DRAW - No valid moves can be made, so card is drawn
	/// @param {enum.MOVE} The next planned move by the CPU to be added to the queue
	/// @return {undefined}
	function queueMove(move) {
		ds_queue_enqueue(moveQueue, move);
	}//end queueMove()
	
	/// @func getNextMove()
	/// @desc Dequeues and returns the next specified move from the move queue as an enumerated type. Enumerated type is called MOVE
	///       and contains the values: PLAYSTANDARD, PLAYWILD, & DRAW.
	/// @return {enum.MOVE} The next planned move by the CPU
	function getNextMove() {
		return ds_queue_dequeue(moveQueue);
	}//end getNextAciton
	
	/// @func hasMoreMoves()
	/// @desc Returns whether or not the CPU has more moves planned for this turn.
	/// @return {boolean} True if more moves are planned, false otherwise
	function hasMoreMoves() {
		return ds_queue_empty(moveQueue) == false;
	}//end hasMoreMoves
	
	/// @func decideMove(topCard)
	/// @desc Decides the CPU Player's next move and inserts the desired move into the move queue.
	///       CPU will decide moves based on the following priority: 
	///       cards of the same suit as play pile -> cards of the same rank as play pile -> eights in the hand -> draw from draw pile
	/// @param {Struct.Card} topCard The Card currently on top of the play pile
	/// @return {undefined}
	function decideMove(topCard) {
		enum MOVE {PLAYSTANDARD, PLAYWILD, DRAW}; //enum for representing move types
		var cardIdx = hasSameSuit(topCard);       //Stores index of Card to play of same suit as topCard (-1 if none)    
		
		//Check for card of same suit
		if ( cardIdx != -1) {
			cardToPlay = cardIdx;                 //Set index of Card to be played
			queueMove(MOVE.PLAYSTANDARD);         //Add desired move to move queue
			return;
		}//end if
		
		cardIdx = hasSameRank(topCard);           //Stores index of Card to play of same rank as topCard (-1 if none)
		
		if (cardIdx != -1) {
			cardToPlay = cardIdx;                 //Set index of Card to be played
			queueMove(MOVE.PLAYSTANDARD);         //Add desired move to move queue
			return;
		}//end if
		
		//Check for eights
		cardIdx = hasEight();                     //Stores index of 8 in Hand to play (-1 if none)
		
		if (cardIdx != -1) {
			cardToPlay = cardIdx;                 //Set index of Card to be played
			queueMove(MOVE.PLAYWILD);             //Add desired move to move queue
			return;
		}//end if
		
		//Draw
		queueMove(MOVE.DRAW);                     //If no cards can be played from hand, simply draw

	}//end decideMove
	
	/// @func getCardToPlay
	/// @desc Returns the index of the Card being played in the next move in the move queue. (For updating UI)
	/// @return {real} Index of the Card in the Hand to be played
	function getCardToPlay() {
		return cardToPlay;
	}//end getCardToPlay
	
	/// @func hasSameSuit()
	/// @desc Searches the CPU's Hand for a Card of the same suit (8's excluded) to play on the play pile, returning its index, if found.
	///       If no cards found, returns -1. Helper function for decideMove()
	/// @param {Struct.Card} topCard The top Card of the play pile
	/// @return {real} Index of the Card to be played (-1 if no Cards of same suit exist within Hand)
	function hasSameSuit(topCard) {
		
		//Iterate backwards so CPU plays highest ranking card first
		for(var i = hand.getCardCount() - 1; i > 0; i--) {
			var currCard = hand.getCard(i); //Get current Card found at index in hand
			
			//If current Card's suit is the same as the top Card and the current Card's rank is not an eight
			if ( currCard.getSuit() == topCard.getSuit() && currCard.getRank() != RANK.EIGHT ) {
				return i;	
			}//end if
			
		}//end for
		
		return -1;
		
	}//end hasSameSuit
	
	/// @func hasSameRank()
	/// @desc Searches the CPU's Hand for a Card of the same rank (8's excluded) to play on the play pile , returning its index, if found.
	///       If no cards found, returns -1. Helper function for decideMove()
	/// @param {Struct.Card} topCard The top Card of the play pile.
	/// @return {real} Index of the Card to be played (-1 if no Cards of the same rank exist within Hand)
	function hasSameRank(topCard) {
		
		//If topCard is an Eight, then return -1, as this would be considered a WILD PLAYTYPE
		//And should be handled by hasEight()
		if (topCard.getRank() == RANK.EIGHT) {
			return -1;
		}//end if
		
		//Iterate through Cards in the hand
		for( var i = 0; i < hand.getCardCount(); i++) {
			var currCard = hand.getCard(i); //Get current Card found at index in hand
			
			//If current Card's rank is the same as the topCard's rank
			if ( currCard.getRank() == topCard.getRank() ) {
				return i;	
			}//end if
		
		}//end for
		
		return -1;
	}//end hasSameRank
	
	/// @func hasEight()
	/// @desc Searches the CPU's Hand for an 8 to play on the play pile, returning its index, if found.
	///       If no cards found, returns -1. Helper function for decideMove()
	/// @return {real} Index of the Card to be played (-1 if no 8's exist within Hand)
	function hasEight() {
		
		for(var i = 0; i < hand.getCardCount(); i++) {
			
			if (hand.getCard(i).getRank() == RANK.EIGHT) {
				return i;
			}//end if
			
		}//end for
		
		return -1;
	}//end hasEight
	
	/// @func getDesiredSuit()
	/// @desc Returns a char (really a one letter String) representation of the Suit the CPU would like to select after playing an 8. 
	///       (For use with Game.handleWilds(). CPU selects a suit based on the highest frequency within its Hand.
	/// @return {string} Uppercase first letter of the Suit the CPU would like to select after playing an 8.
	function getDesiredSuit() {
		
		//Create array for storing suit counts (0 = CLUBS, 1 = DIAMONDS, 2 = HEARTS, 3 = SPADES)
		//Indexes of Suit Counts are as specified in Card.SUIT enum
		suitList = array_create(4,0);
		
		//Iterate through hand, incrementing suit count in array
		for( var i = 0; i < hand.getCardCount(); i++) {
			var currCardSuit = hand.getCard(i).getSuit(); //Get suit of current card in hand
			suitList[ currCardSuit ]++;                   //Since currCardSuit is an enumerated type, we can use it as index for array, and increment that suit's count by 1
		}//end for
		
		//Find index containing maximum element
		var maxIdx = 0;
		for( var i = 1; i < array_length(suitList); i++) {
			if (suitList[i] > suitList[maxIdx]) {
				maxIdx = i;	
			}//end if
		}//end for
		
		//Return appropriate char based on highest suit count
		switch(maxIdx) {
		case 0:
			return "C";
		case 1:
			return "D";
		case 2:
			return "H";
		case 3:
			return "S";
		}//end switch
		
	}//end getDesiredSuit
	
}//end CPUPlayer