/// @description Defines and initalizes attributes for the objDealer object
/// objDealder creates the Game, deals the cards, and checks for when it is the CPU's turn, calling
/// the proper function to begin the CPU's turn when it becomes available

global.game = new Game(); //Create New Game
global.game.deal();       //Deal the cards to the Players and Play Pile

show_debug_message(global.game); //Cheats for debugging purposes