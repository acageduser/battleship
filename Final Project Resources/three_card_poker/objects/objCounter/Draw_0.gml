/// @desc Draws the player's current hand rank
/// AUTHOR: RYAN

var ranks = ["High Card", "Pair", "Flush", "Straight", "Three of a Kind", "Straight Flush"];
var rankIndex = objGameManager.playerHandRank;




//In order to help our new players out, I have calculated the ~% each in game event will win:

//Hand				Probability (%)		Odds to Occur
//Straight Flush	0.22%				1 in 460
//Three of a Kind	0.24%				1 in 424
//Straight			3.26%				1 in 31
//Flush				4.96%				1 in 20
//Pair				16.94%				1 in 6
//High Card			74.39%				3 in 4

var rankProbabilities = [74.39, 16.94, 4.96, 3.26, 0.24, 0.22];






//red text if you get High Card and blue if you get Pair and to Straight. Golden if its 
//three of a kind or straight flush
if (rankIndex == 0) {
    draw_set_color(c_red);
} else if (rankIndex >= 1 && rankIndex <= 3) {
    draw_set_color(c_blue);
} else if (rankIndex >= 4) {
    draw_set_color(c_yellow);
}

//also tell them if their hand is good compared to other hands
var position = 6 - rankIndex; // Since 0 is the worst hand and 5 is the best hand

var rankIndex = objGameManager.playerHandRank;

if (objGameManager.currentPhase == "Player Decision") {
    draw_text(1300, 600, "Current Hand: " + ranks[rankIndex]);
    draw_text(1300, 700, "Rank: " + string(position) + "th best hand");
    draw_text(1300, 800, "Probability: " + string_format(rankProbabilities[rankIndex], 0, 2) + "%");

}

draw_set_color(c_white);
