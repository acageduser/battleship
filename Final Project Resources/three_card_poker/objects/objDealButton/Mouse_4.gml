/// @desc Changes the phase to dealing if the bet is valid
/// AUTHOR Ewan Hurley, edited by RYAN

event_inherited();

with (objGameManager) {
    //calculate what the max bet is
    //https://manual.gamemaker.io/beta/en/GameMaker_Language/GML_Reference/Maths_And_Numbers/Number_Functions/floor.htm
    //it seems like we're getting an off by 1 error here. Upon starting the game with 1000 dollars,
    //my max bet is 500 for pair plus + ante.
    //If I put 499 in pair plus and 1 dollar in ante, it says my bet is too high
    //but I should be able to bet this amount. When I change pair plus to 498, it lets me play
    
    //update 1: I figured out that the ante isn't being counted (or maybe it's 0? not sure) the
    //first time the player attempts to bet and the bet is too high. So I can bet 501 in pair
    //plus and 500 in ante and it will say my current bet is 501 the first time. I don't change anything
    //and simply click the deal button again, and only then does it say current bet is 1001
    
    //update 2: the ante bet is undefined...
    //To fix this, always read anteBet and pairPlusBet from their input boxes
    //before doing any checks, and don’t rely solely on validBet because its pretty trash and slow
    
    anteBet = real(objAnte.text);
    pairPlusBet = real(objPairPlus.text);

    var maxBet = (playerBalance / 2);
	
    //fix the bug where if the user has 0.01 dollars, the game gets stuck because they can't 
	//lose because losing happens at 0 dollars and they can't bet either since the bet has to
	//be half their balance

	//now, you lose if you have only 0.01 dollars in your balance. when you lose, the game state
	//will reset with the user having a 1000 dollar balance
    if (maxBet <= 0.005) {
        show_message("You don't have enough money to continue. Restarting the game...");
        playerBalance = 1000; //reset balance
        anteBet = 0;
        pairPlusBet = 0;
        showGhostText = true;
        betTooHigh = false;
        exit; //end this event to prevent further checks

    }

	
    var anteLimit = maxBet;
    var pairPlusLimit = maxBet;

    if ((anteBet + pairPlusBet <= maxBet) && (anteBet != 0 || pairPlusBet != 0)) { 
        //checks for valid bet
        currentPhase = "Dealing";
		showGhostText = false;
		betTooHigh = false;
    } else if (anteBet == 0 && pairPlusBet == 0) { 
        //checks if bet is 0
        show_message("Bet cannot be 0. Your maximum allowable bet is $" + string(maxBet));
		betTooHigh = false;
    } else { 
        //checks if bet is too high
        show_message("Your current bet is " + string(anteBet + pairPlusBet) + 
                     ". Bet too high! Your maximum allowable bet is $" + string(maxBet) + 
                     ". \nCurrent Ante limit: $" + string_format(anteLimit, 0, 2) + 
                     ", \nCurrent Pair Plus limit: $" + string_format(pairPlusLimit, 0, 2) + 
                     ", \nCurrent Ante bet: $" + string(anteBet) +
                     ", \nCurrent Pair Plus bet: $" + string(pairPlusBet) +
                     ". \nCurrent balance: $" + string(playerBalance));
		betTooHigh = true;
    }//end if
}
