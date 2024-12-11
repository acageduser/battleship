/// @desc Draws the player balance on screen
/// AUTHOR Ewan Hurley, edited by RYAN

draw_set_font(buttonFont);
draw_set_valign(fa_middle);
draw_set_halign(fa_center);

text = string(objGameManager.playerBalance);

_x = 110
_y = 20

text = string_format(objGameManager.playerBalance, 0, 2);	//text is weird. should have stored as a string? 
															//but it's okay. there's a fix
															//https://manual.gamemaker.io/beta/en/index.htm#t=GameMaker_Language%2FGML_Reference%2FStrings%2Fstring_format.htm&rhsearch=string_format&rhhlterm=string_format
draw_text(_x, _y, "Balance: $" + text);




if (objGameManager.showGhostText) {
    var maxBet = (objGameManager.playerBalance / 2);
    var anteGhost = maxBet - objGameManager.pairPlusBet;
    var pairPlusGhost = maxBet - objGameManager.anteBet;

    //check if the current bet is too big
    if (objGameManager.anteBet + objGameManager.pairPlusBet > maxBet) {
        draw_set_color(c_red); //turn text red
        draw_text(_x + 980, _y + 230, "Bet too high!");
        draw_text(_x + 980, _y + 490, "Bet too high!");
    } else {
        draw_set_color(c_white); //turn text back to white
        draw_text(_x + 980, _y + 230, "Max Pair Plus: $" + string_format(pairPlusGhost, 0, 2));
        draw_text(_x + 980, _y + 490, "Max Ante: $" + string_format(anteGhost, 0, 2));
    }

    // don't forget to switch back to white
    draw_set_color(c_white);
}
