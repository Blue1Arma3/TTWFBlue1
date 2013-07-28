/*  
==================================================================================================================
  Simple Vehicle Respawn Script v1.81 for Arma 3///new version////
  by Tophe of Östgöta Ops [OOPS]
  Updated by SPJESTER
  
  vehicle.sqf is an example of the name of the file, name it whatever you would like
  
  Put this in the vehicles init line:
  veh = [this] execVM "vehicle.sqf"

  //// veh = [this, 15, 120] execVM "vehicle.sqf"///120 seconde respawn
  Options:
  There are some optional settings. The format for these are:
  veh = [object, Delay, Deserted timer, Respawns, Effect, Dynamic] execVM "vehicle.sqf"
  
  Default respawn delay is 30 seconds, to set a custom respawn delay time, put that in the init as well. 
  Like this:
  veh = [this, 15] execVM "vehicle.sqf"

  Default respawn time when vehicle is deserted, but not destroyed is 120 seconds. To set a custom timer for this 
  first set respawn delay, then the deserted vehicle timer. (0 = disabled) 
  Like this:  
  veh = [this, 15, 10] execVM "vehicle.sqf"

  Private vehicles (non basic) are protected and monitored too  
  Like this:  
  veh = [this, 15, 0, true, "side"] execVM "vehicle.sqf"

  
Contact & Bugreport: cwadensten@gmail.com
Ported for new update "call compile" by SPJESTER: mhowell34@gmail.com
================================================================================================================== */
// optimized and softProtect added by fred41
#include "softProtectDefines.hpp"
if (!isServer) exitWith {};
waitUntil {!isNil{TW_BasicVehicles}&&!isNil{SP_InitDone}};
private["_unitIndex","_unit","_unitprotected","_delay","_deserted","_private","_run","_dir","_position","_type","_dead","_side","_timeout"];

// Define variables
_unit 		= _this select 0;
_delay 		= if (count _this > 1) then {_this select 1} else {2};
_deserted 	= if (count _this > 2) then {_this select 2} else {120};
_private 	= if (count _this > 3) then {_this select 3} else {false};

diag_log format["vehicle monitoring: %1|%2|%3|%4 ", typeOf _unit, _delay, _deserted, _private];

if (_delay < 0) 	then {_delay = 0};
if (_deserted < 0) 	then {_deserted = 0};

_dir = getDir _unit;
_position = getPosASL _unit;
_type = typeOf _unit;
_timeout = 0;
_unitprotected = false;

if (!_private) then {
	_unitIndex = TW_BasicVehicles find _unit;
};

_dead = false;


// Start monitoring the vehicle
_run = true;
while {_run} do 
{
	sleep (_delay + random 10);
	// Check if deleted
	if (!isNull _unit) then {
		
		if (!_unitprotected) then {_unitprotected = [_unit] call SP_ProtectVehicleGlobal;};

		if ((getDammage _unit > 0.8) and ({alive _x} count crew _unit == 0)) then {
			_dead = true
		} else {
			// Check if the vehicle is deserted.
			if (_deserted > 0) then	{
				if ((getPosASL _unit distance _position > 3) and ({alive _x} count crew _unit == 0) and (getDammage _unit <= 0.8)) then {
					if (_timeout > 0) then {
						if (time >= _timeout) then {_dead = true; _timeout = 0;};
					} else {
						_timeout = time + _deserted;
					};
				} else {_timeout = 0;};
			};
		};	
	} else {
		_dead = true;
	};
	// Respawn basic vehicle or terminate loop for private vehicles
	if (_dead) then 
	{	
		if (!isNull _unit) then {
			_unitprotected = [_unit] call SP_UnProtectVehicleGlobal;
			sleep _delay + random 10;
			_unit allowDamage true;
			deleteVehicle _unit;
		};
		if (!_private) then {
			_unit = _type createVehicle _position;
			TW_BasicVehicles set [_unitIndex, _unit];
			_unit setPosASL _position;
			_unit setDir _dir;
			_unitprotected = [_unit] call SP_ProtectVehicleGlobal;
			_dead = false;
		} else {_run = false};
	};
};
