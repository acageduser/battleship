/// @desc Changes the phase to payout
/// AUTHOR Ewan Hurley


event_inherited();

if (!enabled) exit;

with (objGameManager) {
    //player loses the Ante bet when they fold according to the rules
    currentPhase = "Payout";
    fold = true;
}