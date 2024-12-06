/// @desc Manage game phases
/// AUTHOR: Ryan Livinghouse & Ewan Hurley
switch (currentPhase) {
    case "Betting":
        //wait for player to place bets and press a "Deal" button.
		hideCards();
		if (objPairPlus.validBet) { //If there is an inputted bet, save it
			pairPlusBet = real(objPairPlus.text);
		}//end if
		
		if (objAnte.validBet) { //If there is an inputted bet, save it
			anteBet = real(objAnte.text);
		}//end if
		
		objPlayButton.enabled = false;
		objFoldButton.enabled = false;
		objAnte.enabled = true;
		objPairPlus.enabled = true;
		objDealButton.enabled = true;
        break;
    case "Dealing":
        //deal cards to player and dealer.
		playerBalance -= (pairPlusBet + anteBet);
        dealCards();
        currentPhase = "Player Decision";
        break;
    case "Player Decision":
        //enable "Fold" and "Play" buttons.
        //wait for player's decision too.
		objPlayButton.enabled = true;
		objFoldButton.enabled = true;
		objAnte.enabled = false;
		objPairPlus.enabled = false;
		objDealButton.enabled = false;
		flipPlayerHand();
        break;
    case "Dealer Reveal":
        //reveal dealer's hand and evaluate table.
        evaluateHands();
		flipDealerHand();
        currentPhase = "Payout";
        break;
    case "Payout":
        //calcluate payouts and update balance $$$$$$.
        updateBalance();
        currentPhase = "Betting";
        break;
}