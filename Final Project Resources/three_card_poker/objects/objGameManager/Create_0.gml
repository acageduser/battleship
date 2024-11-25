/// @desc Initialize game variables
/// AUTHOR: Ryan Livinghouse
playerBalance = 1000; //we rich.
anteBet = 0;
pairPlusBet = 0;
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

    //deal cards to dealer
    dealerHand.addCard(deck.deal());
    dealerHand.addCard(deck.deal());
    dealerHand.addCard(deck.deal());
}

function evaluateHands() {
    //evaluate player's hand
    playerHandRank = playerHand.evaluateHandRank();

    //and evaluate dealer's hand
    dealerHandRank = dealerHand.evaluateHandRank();

    //determine if dealer even qualifies
    dealerQualifies = dealerHand.hasQueenHighOrBetter(); //[!!NOTE!!] implement this method in Hand struct!!!
}

function updateBalance() {
    //calculate total payout
    var totalPayout = calculatePayouts(); //need to make this yet.

    //update player's *beans* (money balance)
    playerBalance += totalPayout;

    //display winnings/losses to the player console
    showPayoutMessage(totalPayout);
}