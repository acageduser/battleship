/// @desc Initialize game variables
/// AUTHOR: Ryan Livinghouse & Ewan Hurley
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

playerHand = new Hand();
dealerHand = new Hand();

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
	
	//Reveals the card backs
	objPlayerCard1.image_alpha = 1;
	objPlayerCard2.image_alpha = 1;
	objPlayerCard3.image_alpha = 1;
	objDealerCard1.image_alpha = 1;
	objDealerCard2.image_alpha = 1;
	objDealerCard3.image_alpha = 1;
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

function flipPlayerHand() {
	var playerCard1 = playerHand.getCard(0);
	var playerCard2 = playerHand.getCard(1);
	var playerCard3 = playerHand.getCard(2);
	
	//Set the card images
	objPlayerCard1.image_index = playerCard1.getRank() * 4 + playerCard1.getSuit() + 1;
	objPlayerCard2.image_index = playerCard2.getRank() * 4 + playerCard2.getSuit() + 1;
	objPlayerCard3.image_index = playerCard3.getRank() * 4 + playerCard3.getSuit() + 1;
}

function flipDealerHand() {
	var dealerCard1 = dealerHand.getCard(0);
	var dealerCard2 = dealerHand.getCard(1);
	var dealerCard3 = dealerHand.getCard(2);
	
	//Set the card images
	objDealerCard1.image_index = dealerCard1.getRank() * 4 + dealerCard1.getSuit() + 1;
	objDealerCard2.image_index = dealerCard2.getRank() * 4 + dealerCard2.getSuit() + 1;
	objDealerCard3.image_index = dealerCard3.getRank() * 4 + dealerCard3.getSuit() + 1;
}

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