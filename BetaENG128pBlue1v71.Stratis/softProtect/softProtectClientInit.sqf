// softProtect client PVEH, by fred41
// Protect player and basic vehicles local on client, shoting enabled/disabled and damage allowed/disallowed
#include "softProtectDefines.hpp"

if (isDedicated) exitWith {};

"LockVehicleFire" addPublicVariableEventHandler {
	diag_log format["PVEH LockVehicleFire called: %1",_this];
	private ["_unit"];
	_unit = objectFromNetId ((_this select 1) select 0);
	_unit removeAllEventHandlers "Fired";
	_unit addEventHandler ["Fired", {_this call softProtectVehicleFired;}];
};

"UnLockVehicleFire" addPublicVariableEventHandler {
	diag_log format["PVEH UnLockVehicleFire called: %1",_this];
	private ["_unit"];
	_unit = objectFromNetId ((_this select 1) select 0);
	_unit removeAllEventHandlers "Fired";
};

softProtectVehicleFired = compileFinal "
	if (((_this select 0) distance MarkerPosFriendly < 150)||((_this select 0) distance MarkerPosEnemy < 800)) then {
		deleteVehicle (_this select 6); 
		titleText [""Firing here, is STRICTLY PROHIBITED!"", ""PLAIN"", 1];
	};
";	

softProtectPlayerFired = compileFinal "
	if (((_this select 0) distance MarkerPosFriendly < 150)||((_this select 0) distance MarkerPosEnemy < 800)) then {
		deleteVehicle (_this select 6); 
		titleText [""Firing here, is STRICTLY PROHIBITED!"", ""PLAIN"", 1];
	};
";	

// client loop of softProtect, by fred41
execVM "softProtect\softProtectClientLoop.sqf"; 

SP_InitDone = true;
