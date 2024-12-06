/// @desc Draws the player balance on screen
/// AUTHOR Ewan Hurley

draw_set_font(buttonFont);
draw_set_valign(fa_middle);
draw_set_halign(fa_center);

text = string(objGameManager.playerBalance);

draw_text(x, y, "Balance: " + text);