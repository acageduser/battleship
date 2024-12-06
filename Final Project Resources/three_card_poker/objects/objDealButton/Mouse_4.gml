/// @desc Changes the phase to dealing if the bet is valid
/// AUTHOR Ewan Hurley


event_inherited();

with (objGameManager) {
	if (anteBet + pairPlusBet <= playerBalance/2 && (anteBet != 0 || pairPlusBet != 0)) { //checks for valid bet
		currentPhase = "Dealing";
	} else if (anteBet == 0 && pairPlusBet == 0) { //checks if bet is 0
		show_message("Bet cannot be 0");
	} else { //checks if bet is too high
		show_message("Bet too high");
	}//end if
}