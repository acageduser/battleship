/// @file Structure for representing a Timer within GameMaker games
/// @author Griffin Nye
/// Date Created: 5/29/24
/// Date Modified: 11/2/24
/// Dependencies: n/a

/// @file Timer(sec)
/// @desc Constructs a Timer with the specified delay in seconds (Does not set the Timer).
/// @param {real} sec The number of seconds delay in which the Timer should go off once it is started.
/// @return {Struct.Timer} New Instance of Timer
function Timer(sec) constructor{
	delay = sec * game_get_speed(gamespeed_fps); //Delay is stored as number of frames processed in the specified time
	timeLeft = 0;                                //Time left on the timer
		
	/// @func start()
	/// @desc Starts the timer
	/// @return {undefined}
	function start() {
		timeLeft = delay;
	}//end start
	
	/// @func tick()
	/// @desc Ticks the timer down. (NOTE: This MUST be called every frame in order to work correctly)
	/// @return {undefined}
	function tick() {
		timeLeft--;	
	}//end tick
	
	/// @func isFinished()
	/// @desc Returns whether or not the Timer has gone off.
	/// @return {boolean} True if Timer is finished, false otherwise
	function isFinished() {
		return timeLeft == 0;
	}//end isTimerUp
	
	/// @func setDelay(newSec)
	/// @desc Sets the Timer's delay to the specified number of seconds (NOTE: this will NOT affect an already ongoing Timer)
	/// @param {real} newSec The number of seconds delay in which the Timer should go off once it is started.
	/// @return {undefined}
	function setDelay(newSec) {
		delay = newSec * game_get_speed(gamespeed_fps);
	}//end setDelay
	
	/// @func getTimeLeft()
	/// @desc Returns the number of seconds remaining on the Timer.
	/// @return {real} The number of seconds remaining on the Timer.
	function getTimeLeft() {
		return timeLeft / game_get_speed(gamespeed_fps)
	}//end getTimeLeft
}//end Timer