// softProtect client, by fred41
// Protect player and basic vehicles local on client, shoting enabled/disabled and damage allowed/disallowed
#include "softProtectDefines.hpp"

if (isDedicated) exitWith {};

waitUntil {player == player};

if (playerSide==west) then {
	MarkerPosFriendly 	= getMarkerPos MARKER_WEST;
	MarkerPosEnemy 		= getMarkerPos MARKER_EAST;
};	

if (playerSide==east) then {
	MarkerPosFriendly 	= getMarkerPos MARKER_EAST;
	MarkerPosEnemy 		= getMarkerPos MARKER_WEST;
};


softProtectVehicleFired = {
	if (((_this select 0) distance MarkerPosFriendly < SAFETY_VEHICLE_ZONE)||((_this select 0) distance MarkerPosEnemy < ENEMY_VEHICLE_NOSHOT_ZONE)) then {
		deleteVehicle (_this select 6); 
		titleText [MESSAGE, "PLAIN", 1];
	};
};	

softProtectPlayerFired = {
	if (((_this select 0) distance MarkerPosFriendly < SAFETY_PLAYER_ZONE)||((_this select 0) distance MarkerPosEnemy < ENEMY_PLAYER_NOSHOT_ZONE)) then {
		deleteVehicle (_this select 6); 
		titleText [MESSAGE, "PLAIN", 1];
	};
};	

player removeAllEventHandlers "Fired";

player addEventHandler ["Fired", {_this call softProtectPlayerFired;}];


// safety & noshot zones
private["_friendlydistance","_enemydistance"];

while {true} do {
	
	_friendlydistance 	= player distance MarkerPosFriendly;
	_enemydistance 		= player distance MarkerPosEnemy;
	
	if (vehicle player == player) then {
		if (_friendlydistance < SAFETY_PLAYER_ZONE) then {	
			player allowDamage false;
		} else {
			player allowDamage true;
			if (_enemydistance < ENEMY_PLAYER_NOSHOT_ZONE) then {
				titleText [MESSAGE_WARNING, "PLAIN", 1];
			};
		};
	} else {
		if (_friendlydistance < SAFETY_VEHICLE_ZONE) then {	
			vehicle player allowDamage false;
			player allowDamage false;
		} else {
			vehicle player allowDamage true;
			player allowDamage true;
			if (_enemydistance < ENEMY_VEHICLE_NOSHOT_ZONE) then {
				titleText [MESSAGE_WARNING, "PLAIN", 1];
			};
		};
	};
	sleep 2;
};
