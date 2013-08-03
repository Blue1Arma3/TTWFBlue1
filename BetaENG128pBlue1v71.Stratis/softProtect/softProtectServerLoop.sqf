// softProtect server loop, by fred41
// Protect saves and restores base objects position, dir and damage
#include "softProtectDefines.hpp"

if (!isServer) exitWith {};

private["_BaseObjectsWest","_BaseObjectsEast","_BaseObjects","_FpsHist","_FpsInd","_FpsSum"];
_BaseObjectsWest = getMarkerPos "ProtectWest" nearObjects SAFETY_BASE_ZONE;
_BaseObjectsEast = getMarkerPos "ProtectEast" nearObjects SAFETY_BASE_ZONE;
_BaseObjects = [];
_FpsHist = [50,50,50,50,50,50,50,50];
_FpsInd = 0;
_FpsSum = 0;

{
	if (!(_x isKindOf "AllVehicles")&&!(_x isKindOf "man")) then {
		_BaseObjects set [count _BaseObjects, [_x, getPosATL _x, getDir _x]];
		_x allowDamage false;
	};	
} foreach _BaseObjectsWest;

{
	if (!(_x isKindOf "AllVehicles")&&!(_x isKindOf "man")) then {
		_BaseObjects set [count _BaseObjects, [_x, getPosATL _x, getDir _x]];
		_x allowDamage false;
	};	
} foreach _BaseObjectsEast;

_BaseObjectsWest = []; _BaseObjectsEast = [];
_BaseObjectsWest = nil; _BaseObjectsEast = nil;

_BaseObjects set [count _BaseObjects, [hq_west, getPosATL hq_west, getDir hq_west]];
_BaseObjects set [count _BaseObjects, [hq_east, getPosATL hq_east, getDir hq_east]];

while {(true)} do {
	// serverside fps control
	_FpsHist set [_FpsInd, diag_fps];
	_FpsInd = (_FpsInd + 1) mod 8;

	
	_FpsSum = 0;

	for "_i" from 0 to 7 do {
		_FpsSum = _FpsSum + (_FpsHist select _i);
	};

	FpsAvg = _FpsSum / 8;

	if (FpsAvg > AIDEV_FPS_HIGH) then {TW_AI_Def_lvl = AIDEV_LVL_HIGH; TW_ai = true;} else {if (FpsAvg > AIDEV_FPS_LOW) then {TW_AI_Def_lvl = AIDEV_LVL_LOW; TW_ai = false;} else {TW_AI_Def_lvl = 0; TW_ai = false;};};
	diag_log format["FpsAvg: %1 AIDefLev: %2", FpsAvg, TW_AI_Def_lvl];


	{
		if ((((_x select 1) distance getposATL(_x select 0)) > 0.5) || (0 < getDammage (_x select 0))) then {
			(_x select 0) setPosATL (_x select 1);
			(_x select 0) setDir (_x select 2); 
			(_x select 0) setDamage 0; 
			sleep 0.01;
		};	
	} foreach _BaseObjects;

	sleep 16;
	
};
