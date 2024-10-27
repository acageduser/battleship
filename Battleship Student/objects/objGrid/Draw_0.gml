/// @description Handles drawing the objGrid object's row and column labels.

var letters = "ABCDEFGHIJ";

draw_set_font(CoordFont);
draw_set_color( make_color_rgb(240, 85, 7) );
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

//Draw number labels for the grid
for(var i = 0; i < 10; i++) {
	draw_text(room_width/2 + 64 * (i+1), 192, i+1);
}//end for

//Draw letter labels for the grid
for(var i = 1; i < 11; i++) {
	draw_text(room_width/2, 256 + 64 * (i-1), string_char_at(letters, i) );
}//end for
