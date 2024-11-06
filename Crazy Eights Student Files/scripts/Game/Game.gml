/// @file Structure for representing and handling front-end and back-end operations & game logic for a game of CrazyEights
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: Struct.Card, Struct.Hand, Struct.Deck, Struct.CrazyEightsPile, Struct.uiHand, Struct.uiPlayPile, Struct.uiDrawPile, Struct.Timer

/// @func Game()
/// @desc Constructs everything needed for a Game of Crazy Eights
/// @return {Struct.Game} New instance of Game Struct.
function Game() constructor {
	//This is how we represent constants in GML
	#macro cpuDelay 1                        //Delay in seconds between CPU moves
	#macro scoreCap 100                      //Score limit for the game
	
	enum CPUSTATE {IDLE, DECIDING, MOVING};  //Enum type for representing the state of the CPU
	cpuTimer = new Timer(cpuDelay);          //Timer object for spacing out CPU moves for UI updates
	cpuState = CPUSTATE.IDLE;                //Current CPU STATE
	
	isCPUTurn = false;                       //Stores whether it is the CPU's turn or not (also can be used as array index to determine current player)
	playerList = array_create(2);            //List of Players in the Game
	playerList[0] = new Player("Player");    //Populate Player list
	playerList[1] = new CPUPlayer("CPU");

	playPile = new CrazyEightsPile();        //The Play Pile
	drawPile = new Deck();                   //The Draw Pile

	uiHandList = array_create(2);            //List of the UI representations of the Hands for each Player
	uiHandList[0] = new uiHand(room_width/2, room_height - 150, room_width - 175, false);  //Populate the uiHandsList
	uiHandList[1] = new uiHand(room_width/2, 150, room_width - 175, true);
	
	uiHandList[1].setClickable(false);       //Set CPU Hand to always unclickable

	uiplayPile = new uiPlayPile(room_width/2 + 150, room_height/2); //UI representation of the playPile
	uidrawPile = new uiDrawPile(room_width/2 - 150, room_height/2); //UI representation of the drawPile
	passCtr = 0;                             //Counter of consecutive passes
	
	drawPile.shuffle();                      //Shuffle the drawPile
	
	/// @func deal()
	/// @desc Deals the cards to the Players and the play pile
	/// @return {undefined}
	function deal() {
		
		//Populate player hands
		for(var i = 0; i < array_length(playerList); i++) {
			for(var j = 0; j < 5; j++) {
				var topCard = drawPile.deal();
				playerList[i].drawCard(topCard);
			}//end for
		}//end for
		
		var dealtCard = drawPile.deal(); //Card to be dealt to the play pile
		
		//Continue to re-deal while card dealt is an 8.
		while ( playPile.deal(dealtCard) ) {
			ds_stack_push(drawPile.deck, dealtCard); //Place the dealtCard back into the deck
			drawPile.reshuffle();                    //Reshuffle the drawPile
			dealtCard = drawPile.deal();             //Get a new dealtCard
		}//end while 
		
		//Update the UI to reflect Game state
		updateUI();
		
	}//end deal
	
	/// @func handleDraw()
	/// @desc Handles the Draw action for a Player: removing Card from Deck, placing it in Player Hand, 
	///       updating the UI, playing freshly drawn Card if playable, and passing if draw pile is empty.
	/// @return {boolean} Returns True if freshly drawn Card was played (for CPU Actions), otherwise false
	function handleDraw() {
		
		//If no cards are left in the drawPile, then pass the Player's turn 
		if (drawPile.cardsLeft() == 0) {
			passCtr++;       //Increment passCtr by 1
			
			//If both player's have passed, end the round
			if (passCtr == 2) {
				show_message("Round has ended in a tie. Both player's score.");
				endRound(true); //End the round
			} else {		
				changeTurns();	
			}//end if
			
			return;
		}//end if
		
		//Since isCPUTurn is a boolean, with False = 0 and True = 1, we can use isCPUTurn as the index to determine which Player to access
		var currPlayer = playerList[isCPUTurn];        //Gets Player struct of currently playing player
		var currPlayerHand = currPlayer.getHand();     //Gets Hand struct of currently playing player
		var currPlayerUIHand = uiHandList[isCPUTurn];  //Gets uiHand struct of currently playing player
		
		var drawnCard = drawPile.deal();  //Draw Card from top of draw pile
		currPlayer.drawCard( drawnCard ); //Move top card from draw pile into Current Player hand
		
		//Update UI to reflect changes in game state
		updateUI();
		
		//Check if new card can be played, if so, play it automatically for the player
		if (playPile.canPlayCard(drawnCard) != PLAYTYPE.INVALID ) {
			show_message(drawnCard.toString() + " was drawn. Playing to Play Pile"); //Inform Player of what Card was drawn and is being played
			var cardIdx = currPlayerHand.getCardPos(drawnCard);          //Find position of drawn card in hand
			var uiCardInstance = currPlayerUIHand.getInstance(cardIdx);  //Get instance of drawn card in hand
			handlePlayCard(uiCardInstance);                              //Play the card as if clicked by the player
			return true;												 //Indicate Card was played
		}//end if
		
		return false;
	}//end handleDraw
	
	
	/// @func handlePlayCard(uiCard)
	/// @desc Handles the PlayCard action for a Player, taking the appropriate steps based on the PLAYTYPE.
	///       INVALID Play - Informs user Card cannot be played
	///       VALID Play - Plays the Card from the Hand onto the Play pile and ends the turn
	///       WILD Play - Prompts the user to select new suit, plays the Card from the Hand onto the Play pile and ends the turn
	/// @param {ID.Instance} uiCard Instance ID of the Card clicked on the UI (or played by the CPU)
	/// @return {undefined}
	function handlePlayCard(uiCard) {
		
		//Since isCPUTurn is a boolean, with False = 0 and True = 1, we can use isCPUTurn as the index to determine which Player to access
		var currPlayer = playerList[isCPUTurn];        //Gets Player struct of currently playing player
		var currPlayerHand = currPlayer.getHand();     //Gets Hand struct of currently playing player
		var currPlayerUIHand = uiHandList[isCPUTurn];  //Gets uiHand struct of currently playing player
		
		var cardIdx = currPlayerUIHand.findIdx(uiCard);   //Retrieve index of Card clicked on by Player (or selected by CPU)
		var playedCard = currPlayerHand.getCard(cardIdx); //Retrieve Card from Hand struct using cardIdx
	
		//Attempt to play the Card on the Play Pile and perform the appropriate actions based on the PLAYTYPE
		switch( playPile.canPlayCard(playedCard) ) {
		case PLAYTYPE.WILD:
			handleWilds(playedCard);                   //Prompt user for new suit and set 8 being played to said suit
		case PLAYTYPE.VALID:
			currPlayer.playCard(playedCard, playPile); //Play the Card from Player's hand onto Playpile
			passCtr = 0;							   //Reset passCtr to 0
			changeTurns();                             //End Turn
			break;
		case PLAYTYPE.INVALID:
			show_message("CANNOT PLAY THIS CARD");     //Input validation
			break;
		}//end switch
		
	}//end playCard
	
	/// @func handleWilds(playedCard)
	/// @desc Prompts the Player for the Suit they would like to choose after playing an 8.
	/// @param {Struct.Card} playedCard The Card just played to the Play pile
	/// @return {undefined}
	function handleWilds(playedCard) {
		var choice = "";		
		
		//Handle CPU Player's choice
		if (isCPUTurn) {
			choice = playerList[isCPUTurn].getDesiredSuit();  //Prompt CPU Player to select a Suit
			
			//Set string appropriately based on CPU decision
			if (choice == "C") str = "CLUBS";
			else if (choice == "D") str = "DIAMONDS";
			else if (choice == "H") str = "HEARTS";
			else if (choice == "S") str = "SPADES";
			
			//Inform the user of the CPU's selection
			show_message("CPU CHOSE " + str);
		
		} else {
			
			//Reprompt until valid suit is chosen
			do {
				//Prompt the user to enter the suit they would like to set the play pile to
				//Use first character only, to handle typos
				choice = string_char_at( string_upper( get_string("ENTER NEW SUIT: ", "") ), 1);
	
			} until (choice == "C" || choice == "D" || choice == "H" || choice == "S" );
		}//end if
		
		//Set the suit of the 8 being played to the corresponding suit selected
		switch(choice) {
		case "C":
			playedCard.setSuit(SUIT.CLUBS);
			break;
		case "D":
			playedCard.setSuit(SUIT.DIAMONDS);
			break;
		case "H":
			playedCard.setSuit(SUIT.HEARTS);
			break;
		case "S":
			playedCard.setSuit(SUIT.SPADES);
			break;
		}//end switch

	}//end handleWilds

	/// @func update()
	/// @desc Keeps the Game flowing, by checking if the CPU still has additional moves to make in its turn.
	/// @return {undefined}
	function update() {
		
		//If it is still the CPU's turn, handle their turn.
		if (isCPUTurn) {
			handleCPUTurn();	
		}//end if

	}//end update
	
	/// @func updateUI
	/// @desc Updates the UI elements for the Game to reflect the Game state
	/// @return {undefined}
	function updateUI() {
		var player = playerList[0];   
		var cpu = playerList[1];           
		var playerHand = player.getHand();
		var cpuHand = cpu.getHand();      
		var uiPlayerHand = uiHandList[0];
		var uiCPUHand = uiHandList[1];
		
		//Set whether UI elements are clickable or not based on Current Turn
		uiPlayerHand.setClickable(!isCPUTurn);
		uidrawPile.setClickable(!isCPUTurn);
		
		//Redraw all UI elements 
		uiPlayerHand.drawHand(playerHand);
		uiCPUHand.drawHand(cpuHand);
		uidrawPile.drawPile( drawPile.cardsLeft() );
		uiplayPile.drawPile(playPile);
		
	}//end updateUI
	
	/// @func changeTurns()
	/// @desc Checks if the Current Player has won and ends the Player's turn, prompting the CPU to take their turn, if necessary.
	/// @return {undefined}
	function changeTurns() {
		
		//Check if Player has won and display win message if so
		if (playerList[isCPUTurn].hasWonRound() ) {
			show_message(playerList[isCPUTurn].getName() + " has won the round!" );
			endRound(false); //end the round
			return;
		}//end if
		
		//Change turns
		isCPUTurn = !isCPUTurn;
		
		//Update UI to reflect Game state
		updateUI();

		//If it is now the CPU's Turn, begin their turn
		if (isCPUTurn) {
			cpuState = CPUSTATE.DECIDING;  //Set CPU State to Deciding
			cpuTimer.start();              //Start the CPU Timer to space out CPU moves
			handleCPUTurn();               //Handle the CPU's turn
		}//end if
		
	}//end changeTurns
	
	/// @func endRound(tie)
	/// @desc Ends the round by tallying the score, checking for winner of game, and loading new round.
	/// @param {boolean} tie True if round ended in a tie, false otherwise
	/// @return {undefined}
	function endRound(tie) {
		
		if (!tie) {
			//Temp variables for easier access
			var loser = playerList[!isCPUTurn];
			var winner = playerList[isCPUTurn];
		
			//Add value of loser's hand to winner's score
			winner.addScore( loser.getHandValue() );
			
		} else {
			//Temp variables for easier access
			var player = playerList[0];
			var CPU = playerList[1];
			
			//Add value of both player's hands to opponents score
			player.addScore( CPU.getHandValue() );
			CPU.addScore( player.getHandValue() );
		}//end if
		
		//Temp variables for easy access
		var player = playerList[0];
		var cpu = playerList[1];
		var playerScore = player.getScore();
		var cpuScore = cpu.getScore();
		var str = "";  //Message to be displayed
		
		//Check if a player has won
		if (playerScore > scoreCap || cpuScore > scoreCap) {
			
			//Determine who has won and update victory message accordingly
			if (playerScore > cpuScore) {
				str = player.getName() + " HAS WON THE GAME!!!\n";
			} else {
				str = cpu.getName() + " HAS WON THE GAME!!!\n";	
			}//end if
			
			//Append Points display to the message
			str += "POINTS:\n" + playerList[0].getName() + ": " + string(playerList[0].getScore() ) + "\n" +
                     playerList[1].getName() + ": " + string(playerList[1].getScore() ) + "\n";	
			
			//Display message to user
			show_message(str);
			
			//Prompt user for new game
			if ( show_question("New game?") ) {
				newRound(true); //Load new game
			} else {
				game_end();     //end game
			}//end if
			
		} else {
			show_message("POINTS:\n" + playerList[0].getName() + ": " + string(playerList[0].getScore() ) + "\n" +
                         playerList[1].getName() + ": " + string(playerList[1].getScore() ) + "\n" );  //Display point tally
			newRound(false);    //Load new round
		}//end if

	}//end endRound

	/// @func newRound(newGame)
	/// @desc Loads a new round of the game
	/// @param {boolean} newGame True if new Game should be loaded (clear player points), False if only new round should be loaded (retain player points)
	/// @return {undefined}
	function newRound(newGame) {
		
		//Construct new cpuTimer
		cpuTimer = new Timer(cpuDelay);
		
		//Set isCPUTurn to false
		isCPUTurn = false;
		
		//If new Game to be loaded, construct new Player objects with previous player's names
		if (newGame) {
			playerList[0] = new Player( playerList[0].getName() );
			playerList[1] = new CPUPlayer( playerList[1].getName() );
		} else { //Retain Player points
			//Clear Player Hands
			playerList[0].getHand().clear();
			playerList[1].getHand().clear();
		}//end if
		
		//Construct new piles
		playPile = new CrazyEightsPile();
		drawPile = new Deck();
		
		//Shuffle the drawPile
		drawPile.shuffle();
		
		//Destroy all instances created by last round
		uiHandList[0].destroyInstances();
		uiHandList[1].destroyInstances();
		uiplayPile.destroyInstance();
		uidrawPile.destroyInstance();
		
		//Reset passCtr
		passCtr = 0;
		
		//Deal the cards
		deal();
		
	}//end newRound
	
	/// @func handleCPUTurn()
	/// @desc Handles the CPU's turn by taking appropriate action based on the CPU's state
	/// @return {undefined}
	function handleCPUTurn() {
	
		//If cpuTimer is not completed yet, do not take CPU's turn yet
		if (!cpuTimer.isFinished() ) {
			cpuTimer.tick();  //Tick the timer
			return;           //exit prematurely
		}//end if
		
		//Temp variable for easier access of CPU
		var cpu = playerList[isCPUTurn];
		
		//Take appropriate action based on cpuState
		switch(cpuState) {
		case CPUSTATE.DECIDING:
			cpu.startTurn( playPile.getTop() );  //Start the CPUs turn
			cpuState = CPUSTATE.MOVING;          //Set CPU State to Moving
			cpuTimer.start();                    //Start CPU Timer to space out CPU moves
			break;
		case CPUSTATE.MOVING:
			handleCPUMove();                     //Apply the move that the CPU has decided upon
			
			//If CPU does not have any more moves (ie does not need to keep drawing), set state to Idle
			if (!cpu.hasMoreMoves() ) {
				cpuState = CPUSTATE.IDLE;
			}//end if

			break;
		}//end switch
		
	}//end handleCPUTurn
	
	/// @func handleCPUMove()
	/// @desc Applies the move that the CPU has decided upon
	/// @return {undefined}
	function handleCPUMove() {
		//Temp variables for easier access of CPU model and UI elements
		var cpu = playerList[isCPUTurn];
		var cpuHand = cpu.getHand();
		var uiCPUHand = uiHandList[isCPUTurn];
		var moveType = cpu.getNextMove();      //Get the move CPU decided upon
		
		//Take appropriate action based on the Move the CPU decided to make
		switch(moveType) {
		case MOVE.PLAYSTANDARD:
		case MOVE.PLAYWILD:
			var cardIdx = cpu.getCardToPlay();           //Get Card CPU decided to play
			var uiCard = uiCPUHand.getInstance(cardIdx); //Get UI element corresponding to Card CPU decided to play
			show_message("CPU PLAYS " + cpuHand.getCard(cardIdx).toString() );  //Inform the user of the CPU's move
			handlePlayCard(uiCard);                      //Play the Card
			break;
		case MOVE.DRAW:
			
			//If no cards left in draw pile, inform user CPU passes, otherwise inform user CPU will draw a card
			if (drawPile.cardsLeft() == 0) {
				show_message("CPU PASSES THEIR TURN");
			} else {
				show_message("CPU DRAWS A CARD");
			}//end if
			
			//Draw a card for the CPU. If the drawn card was not playable, let the CPU decide its next move (ie draw again)
			if ( !handleDraw() ) {
				cpu.decideMove( playPile.getTop() );		
			}//end if
			
			break;
		}//end switch
			
	}//end handleCPUTurn

	/// @func toString()
	/// @desc Returns a String representation of the Game state
	/// @return {string} A String representation of the Game state
	function toString() {
		var res = "";
		
		res += "CPU TURN?: " + string(isCPUTurn) + "\n";
		res += "CPU HAND: " + playerList[1].getHand().toString() + "\n";
		res += "DRAW PILE: " + drawPile.toString() + "\n";
		res += "PLAY PILE: " + playPile.toString() + "\n";
		res += "PLAYER HAND: " + playerList[0].getHand().toString() + "\n";
		
		return res;
	}//end toString

}//end Game