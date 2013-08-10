// softProtect client PVEH & functions, by fred41
// Protect player and basic vehicles local on client, shoting enabled/disabled and damage allowed/disallowed
#include "softProtectDefines.hpp"

if (isDedicated) exitWith {};

"LockVehicleFire" addPublicVariableEventHandler {
	private ["_unit"];
	_unit = objectFromNetId ((_this select 1) select 0);
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
	_unit removeAllEventHandlers "Fired";
	_unit addEventHandler ["GetIn",	{if (local (_this select 2)) then {(_this select 0) addEventHandler ["Fired",{_this call softProtectVehicleFired;}];};}];
	_unit addEventHandler ["GetOut",{if (local (_this select 2)) then {(_this select 0) removeAllEventHandlers "Fired";};}];
};

"UnLockVehicleFire" addPublicVariableEventHandler {
	private ["_unit"];
	_unit = objectFromNetId ((_this select 1) select 0);
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
	_unit removeAllEventHandlers "Fired";
};

softProtectVehicleFired = compileFinal format ["
	if (((_this select 0) distance MarkerPosFriendly < %1)||((_this select 0) distance MarkerPosEnemy < %2)) then {
		deleteVehicle (_this select 6); 
		titleText [""%3"", ""PLAIN"", 1];
	};
", SAFETY_VEHICLE_ZONE, ENEMY_VEHICLE_NOSHOT_ZONE, MESSAGE];	

softProtectPlayerFired = compileFinal format ["
	if (((_this select 0) distance MarkerPosFriendly < %1)||((_this select 0) distance MarkerPosEnemy < %2)) then {
		deleteVehicle (_this select 6); 
		titleText [""%3"", ""PLAIN"", 1];
	};
", SAFETY_PLAYER_ZONE, ENEMY_PLAYER_NOSHOT_ZONE, MESSAGE];	

// client loop of softProtect, by fred41
execVM "softProtect\softProtectClientLoop.sqf"; 

SP_InitDone = true;
