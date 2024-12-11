/// @desc Changes the phase to dealer reveal
/// AUTHOR Ewan Hurley, edited by Ryan


event_inherited();

if (!enabled) exit;

with (objGameManager) {
    currentPhase = "Dealer Reveal";
}