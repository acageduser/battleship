/// @desc Draws the input box with text
/// AUTHOR Ewan Hurley


if (enabled) {
	draw_self();
	
	draw_set_font(buttonFont);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_right);
	draw_text(bbox_right-20, y, text);
	
	draw_set_halign(fa_center);
	draw_text_transformed(x, bbox_top - 40, name, 2, 2, 0);
}//end if