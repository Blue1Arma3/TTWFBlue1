// softProtect server functions and PVEH, by fred41
#include "softProtectDefines.hpp"

if (!isServer) exitWith {};

"MonitorVehicleServer" addPublicVariableEventHandler {
	diag_log format["PVEH MonitorVehicleServer called: %1",_this];
	private ["_unit"];
	_unit = objectFromNetId ((_this select 1) select 0);
	[_unit, 2, 600, true] execVM "vehicle.sqf";
};

SP_ProtectVehicleGlobal = compileFinal format ["
	private[""_unit"",""_type"",""_armed""];
	_unit = _this select 0;
	_unit removeAllEventHandlers ""GetOut"";
	_unit allowDamage false;
	_unit addEventHandler [""GetOut"",{_unit = _this select 0; if ((_unit distance getMarkerPos ""%2"" < %1)||(_unit distance getMarkerPos ""%3"" < %1)) then {_unit allowDamage false} else {_unit allowDamage true};}];
	_type = typeOf _unit; 
	_armed = if (((count (configFile >> ""CfgVehicles"" >> _type >> ""Turrets"")) > 0) || (count (configFile >> ""CfgVehicles"" >> _type >> ""magazines"")) > 0) then {true} else {false};
	if (_armed) then {
		LockVehicleFire = [netId _unit];
		publicVariable ""LockVehicleFire"";
	};	
	true
", SAFETY_VEHICLE_ZONE, MARKER_WEST, MARKER_EAST];

SP_UnProtectVehicleGlobal = compileFinal "
	private[""_unit""];
	_unit = _this select 0;
	_unit removeAllEventHandlers ""GetOut"";
	_unit allowDamage true;
	UnLockVehicleFire = [netId _unit];
	publicVariable ""UnLockVehicleFire"";
	false
";

// server side loop of softProtect, by fred41
execVM "softProtect\softProtectServerLoop.sqf"; 

FpsAvg = 50; // average FPS

SP_InitDone = true;
