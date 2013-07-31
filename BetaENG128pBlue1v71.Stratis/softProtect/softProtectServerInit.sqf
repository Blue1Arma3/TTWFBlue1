// softProtect server functions and PVEH, by fred41
#include "softProtectDefines.hpp"

if (!isServer) exitWith {};

"MonitorVehicleServer" addPublicVariableEventHandler {
	diag_log format["PVEH MonitorVehicleServer called: %1",_this];
	private ["_unit"];
	_unit = objectFromNetId ((_this select 1) select 0);
	[_unit, 2, 600, true] execVM "vehicle.sqf";
};


SP_ProtectVehicleGlobal = {
	diag_log format["SP_ProtectVehicleGlobal called: %1",_this];
	private["_unit"];
	_unit = _this select 0;
	_unit removeAllEventHandlers "GetOut";
	_unit allowDamage false;
	_unit addEventHandler ["GetOut",{_unit = _this select 0; if ((_unit distance getMarkerPos MARKER_WEST < SAFETY_VEHICLE_ZONE)||(_unit distance getMarkerPos MARKER_EAST < SAFETY_VEHICLE_ZONE)) then {_unit allowDamage false} else {_unit allowDamage true};}];
	LockVehicleFire = [netId _unit];
	publicVariable "LockVehicleFire";
	true
};

SP_UnProtectVehicleGlobal = {
	diag_log format["SP_UnProtectVehicleGlobal called: %1",_this];
	private["_unit"];
	_unit = _this select 0;
	_unit removeAllEventHandlers "GetOut";
	_unit allowDamage true;
	UnLockVehicleFire = [netId _unit];
	publicVariable "UnLockVehicleFire";
	false
};

// server side loop of softProtect, by fred41
execVM "softProtect\softProtectServerLoop.sqf"; 

SP_InitDone = true;
