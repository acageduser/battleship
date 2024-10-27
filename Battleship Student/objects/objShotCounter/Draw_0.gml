/// @description Handles drawing the objShotCounter object, populating its value from global.game

draw_self();

draw_set_font(CoordFont);
draw_set_color( make_color_rgb(240, 85, 7) );
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(x - sprite_width/2, y, "Shots remaining: " + string(global.game.getShotsRemaining() ) );
