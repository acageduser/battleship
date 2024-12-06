/// @desc Draws the buttons with text if enabled
/// AUTHOR Ewan Hurley


if (enabled) {
	draw_self();
	
	draw_set_font(buttonFont);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_text(x, y, text);
}//end if