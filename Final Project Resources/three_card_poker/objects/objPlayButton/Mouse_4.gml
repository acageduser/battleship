/// @desc Changes the phase to dealer reveal
/// AUTHOR Ewan Hurley


event_inherited();

if (!enabled) exit;

with (objGameManager) {
    currentPhase = "Dealer Reveal";
}