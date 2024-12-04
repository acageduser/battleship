/// @desc Manage game phases
/// AUTHOR: Ryan Livinghouse & Ewan Hurley
switch (currentPhase) {
    case "Betting":
        //wait for player to place bets and press a "Deal" button.
        break;
    case "Dealing":
        //deal cards to player and dealer.
        dealCards();
		flipPlayerHand();
        currentPhase = "Player Decision";
        break;
    case "Player Decision":
        //enable "Fold" and "Play" buttons.
        //wait for player's decision too.
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