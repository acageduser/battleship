/// @desc Initialize game variables
/// AUTHOR: Ryan Livinghouse, edited by Ewan and Jimmy
playerBalance = 1000; //we rich.
anteBet = 0;
pairPlusBet = 0;
showGhostText = true; //this is for the ante and pair plus max text
betTooHigh = false;
currentPhase = "Betting";	//i think the game starts on betting according to the rules.
							//gonna use case switch to control which state the game is in
							//the possible states are
								//- Betting ('default state')
								//- Dealing
								//- Player Decision
								//- Dealer Reveal
								//- Payout (ca-ching)

deck = new Deck();
deck.shuffle(); //after each hand, the deck is fresh.

playerHand = new Hand();
dealerHand = new Hand();

playerHandRank = 0;
dealerHandRank = 0;

dealerQualifies = false;
fold = false;

/// @func deakCards()
/// @desc Resets the player and dealer hands and deals three cards to each. Also resets card sprites.
/// @return {undefined}
/// AUTHOR: Ryan Livinghouse, edited by Ewan
function dealCards() {
    //clear previous hands.
    playerHand.clear();
    dealerHand.clear();

    //check if the deck has enough cards.
	//reshuffle if necessary.
    if (deck.cardsLeft() < 6) {
        deck.shuffle();
    }

    //deal cards to the player
    playerHand.addCard(deck.deal());
    playerHand.addCard(deck.deal());
    playerHand.addCard(deck.deal());
	

	//TESTING ONLY: Straight Flush
	//playerHand.addCard(new Card(RANK.JACK, SUIT.HEARTS));
	//playerHand.addCard(new Card(RANK.QUEEN, SUIT.HEARTS));
	//playerHand.addCard(new Card(RANK.KING, SUIT.HEARTS));


    //deal cards to dealer
    dealerHand.addCard(deck.deal());
    dealerHand.addCard(deck.deal());
    dealerHand.addCard(deck.deal());
	
	//check it here because in evaluate hands its too late to display in the rank system
    playerHandRank = playerHand.evaluateHandRank();
	
	//Reveals the card backs
	objPlayerCard1.image_alpha = 1;
	objPlayerCard2.image_alpha = 1;
	objPlayerCard3.image_alpha = 1;
	objDealerCard1.image_alpha = 1;
	objDealerCard2.image_alpha = 1;
	objDealerCard3.image_alpha = 1;
	
	fold = false;
}

/// @func evaluateHands()
/// @desc Evaluates the hand ranks of the player and dealer, and checks if the dealer is qualified to play.
/// @return {undefined}
/// AUTHOR: Ryan Livinghouse, edited by Ewan
function evaluateHands() {
    //evaluate player's hand
    playerHandRank = playerHand.evaluateHandRank();

    //and evaluate dealer's hand
    dealerHandRank = dealerHand.evaluateHandRank();

    //determine if dealer even qualifies
    dealerQualifies = dealerHand.hasQueenHighOrBetter() || dealerHandRank > 0;
}

/// @func updateBalance()
/// @desc Calculates the total payout, updates the balance, and displays the result.
/// @return {undefined}
/// AUTHOR: Ryan Livinghouse
function updateBalance() {
    //calculate total payout
    var totalPayout = calculatePayouts();

    //update player's *beans* (money balance)
    playerBalance += totalPayout;

    //display winnings/losses to the player console
    showPayoutMessage(totalPayout);
}

/// @func flipPlayerHand()
/// @desc Updates the sprites for the player's hand to display the cards.
/// @return {undefined}
/// AUTHOR: Ewan Hurley
function flipPlayerHand() {
	var playerCard1 = playerHand.getCard(0);
	var playerCard2 = playerHand.getCard(1);
	var playerCard3 = playerHand.getCard(2);
	
	//Set the card images
	objPlayerCard1.image_index = playerCard1.getRank() * 4 + playerCard1.getSuit() + 1;
	objPlayerCard2.image_index = playerCard2.getRank() * 4 + playerCard2.getSuit() + 1;
	objPlayerCard3.image_index = playerCard3.getRank() * 4 + playerCard3.getSuit() + 1;
}

/// @func flipDealerHand()
/// @desc Updates the sprites for the dealer's hand to display the cards.
/// @return {undefined}
/// AUTHOR: Ewan Hurley
function flipDealerHand() {
	var dealerCard1 = dealerHand.getCard(0);
	var dealerCard2 = dealerHand.getCard(1);
	var dealerCard3 = dealerHand.getCard(2);
	
	//Set the card images
	objDealerCard1.image_index = dealerCard1.getRank() * 4 + dealerCard1.getSuit() + 1;
	objDealerCard2.image_index = dealerCard2.getRank() * 4 + dealerCard2.getSuit() + 1;
	objDealerCard3.image_index = dealerCard3.getRank() * 4 + dealerCard3.getSuit() + 1;
}

/// @func hideCards()
/// @desc Updates the sprites for the player and dealer's hands to hide the cards and flip them back over.
/// @return {undefined}
/// AUTHOR: Ewan Hurley
function hideCards() {
	//Hides the cards
	objPlayerCard1.image_alpha = 0;
	objPlayerCard2.image_alpha = 0;
	objPlayerCard3.image_alpha = 0;
	objDealerCard1.image_alpha = 0;
	objDealerCard2.image_alpha = 0;
	objDealerCard3.image_alpha = 0;
	
	//Flips the cards back over
	objPlayerCard1.image_index = 0;
	objPlayerCard2.image_index = 0;
	objPlayerCard3.image_index = 0;
	objDealerCard1.image_index = 0;
	objDealerCard2.image_index = 0;
	objDealerCard3.image_index = 0;
}

/// @func calculatePayouts()
/// @desc Calculates the payout for each wager and bonus. If the player folds or the dealer doesn't qualify, the total is just calculated using the ante bet.
/// @return {real} The total payout after comparing hands.
/// AUTHOR: Jimmy Tryhall, edited by Ewan
function calculatePayouts() {
    var totalPayout = 0;

    if (fold) { //checks if the player folds (for payout display)
		totalPayout = -anteBet;
	} else if (dealerQualifies) { //calculates payout if the dealer can play
		totalPayout = calculatePlayWager() + calculateAnteBonus() + calculatePairPlus();
	} else { //checks if the dealer can play
		totalPayout = anteBet
	}

    return totalPayout;
}

/// @func calculatePlayWager()
/// @desc Calculates the payout of the ante and play wagers under any circumstance.
/// @return {real} The payout of the ante and play wagers.
/// AUTHOR: Ewan Hurley
function calculatePlayWager() {
	if (fold) return -anteBet; //player loses their ante bet if they fold
	
	if (!dealerQualifies) return anteBet; //player wins their ante back if the dealer can't play
	
	if (playerHandRank > dealerHandRank) { //player earns their ante and play bets if they have a higher rank
		return anteBet * 2;
	} else if (playerHandRank < dealerHandRank) { //player loses their ante and blay bets if they have a lower rank
		return -anteBet * 2;
	} else { //checks if the player and dealer have the same rank
		if (playerHand.getHighestCard() > dealerHand.getHighestCard()) { //if the player has the high card, they win
			return anteBet * 2;
		} else if (playerHand.getHighestCard() < dealerHand.getHighestCard()) { //if the dealer has the high card, the player loses
			return -anteBet * 2;
		} else { //if they have the same rank and high card, the player and dealer tie and no money is lost
			return 0;
		}
	}
}

/// @func calculateAnteBonus()
/// @desc Calculates the payout of the ante bonus depending on the player's hand rank and dealer qualification.
/// @return {real} The payout of the ante bonus.
/// AUTHOR: Ewan Hurley
function calculateAnteBonus() {
	if (!dealerQualifies) return 0; //ante bonus is ignored if the dealer can't play
	
	if (playerHandRank == 3) { //if the player has a straight, they get their ante back as a bonus
		return anteBet;
	} else if (playerHandRank == 4) { //if the player has a three of a kind, they get their ante back 4 to 1 as a bonus
		return anteBet * 4;
	} else if (playerHandRank == 5) { //if the player has a straight flush, they get their ante back 5 to 1 as a bonus
		return anteBet * 5;
	} else { //if the player doesn't have any of the previous ranks, they get no bonus
		return 0;
	}
}

/// @func calculatePairPlus()
/// @desc Calculates the payout of the pair plus bet depending on the player's hand rank. Ignored if the dealer can't play.
/// @return {real} The payout of the pair plus wager.
/// AUTHOR: Ewan Hurley
function calculatePairPlus() {
	if (playerHandRank == 1) { //if the player has a pair, they get their pair plus back
		return pairPlusBet;
	} else if (playerHandRank == 2) { //if the player has a flush, they get their pair plus back 4 to 1
		return pairPlusBet * 4;
	} else if (playerHandRank == 3) { //if the player has a straight, they get their pair plus back 6 to 1
		return pairPlusBet * 6;
	} else if (playerHandRank == 4) { //if the player has a three of a kind, they get their pair plus back 30 to 1
		return pairPlusBet * 30;
	} else if (playerHandRank == 5) { //if the player has a straight flush, they get their pair plus back 40 to 1
		return pairPlusBet * 40;
	} else if (!dealerQualifies || fold) { //if the dealer can't play or the player folds, the pair plus is ignored
		return 0;
	} else { //if the player only has a high card, they lose their pair plus bet
		return -pairPlusBet;
	}
}

/// @func showPayoutMessage(payout)
/// @desc Displays the results of the game for the player to understand.
/// @return {undefined}
/// AUTHOR: Jimmy Tryhall, edited by Ewan
function showPayoutMessage(payout) {
	var ranks = ["High Card", "Pair", "Flush", "Straight", "Three of a Kind", "Straight Flush"];
	var compareString = "";
	
	//saves a string for comparing player and dealer ranks
	if (fold) {
		compareString = "Fold";
	} else if (dealerQualifies) {
		compareString = ranks[playerHandRank] + " vs " + ranks[dealerHandRank];
	} else {
		compareString = "Dealer Doesn't Qualify";
	}
	
	//saves a string for the payout message
	var payoutString = "Ante/Play Wagers: " + string(calculatePlayWager()) + " (" + compareString +
	")\nAnte Bonus: " + string(calculateAnteBonus()) +
	"\nPair Plus Wager: " + string(calculatePairPlus()) + "\n";
	
	//saves a string for total payout
    if (payout > 0) {
        payoutString += "You won $" + string(payout);
    } else if (payout < 0) {
        payoutString += "You lost $" + string(-payout);
    } else {
        payoutString += "It's a tie!";
    }
	
	show_message(payoutString);
}
