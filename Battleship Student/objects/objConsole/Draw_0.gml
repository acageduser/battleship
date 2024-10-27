/// @description Draws the objConsole object, including all of the messages in the messageList

draw_self();

//Draw all the messages from messageList onto the console
for(var i = 0; i < currIdx; i++) {	
	draw_set_font(ConsoleFont);
	draw_set_color( make_color_rgb(240, 85, 7) );
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	draw_text(x - sprite_width/2 + 16, y - sprite_height/2 + string_height("A") * i + 24, messageList[i]);
}//end for
