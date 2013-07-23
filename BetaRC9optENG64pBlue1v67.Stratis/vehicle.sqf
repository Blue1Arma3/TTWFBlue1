/*  
==================================================================================================================
  Simple Vehicle Respawn Script v1.81 for Arma 3///new version////
  by Tophe of �stg�ta Ops [OOPS]
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

  By default the number of respawns is infinite. To set a limit first set preceding values then the number of respawns you want (0 = infinite).
  Like this:
  veh = [this, 15, 10, 5] execVM "vehicle.sqf"

  Set this value to TRUE to add a special explosion effect to the wreck when respawning.
  Default value is FALSE, which will simply have the wreck disappear.
  Like this:
  veh = [this, 15, 10, 5, TRUE] execVM "vehicle.sqf"
  
  By default the vehicle will respawn to the point where it first was when the mission started (static). 
  This can be changed to dynamic. Then the vehicle will respawn to the position where it was destroyed. 
  First set all preceding values then set TRUE for dynamic or FALSE for static.
  Like this:
  veh = [this, 15, 10, 5, TRUE, TRUE] execVM "vehicle.sqf"
  
  If you you want to set the INIT field of the respawned vehicle, first set all other values, then set init commands. 
  Those must be inside quotations.
  Like this:
  veh = [this, 15, 10, 5, TRUE, FALSE, "this setDammage 0.5"] execVM "vehicle.sqf"
  
  Default values of all settings are:
  veh = [this, 30, 120, 0, FALSE, FALSE] execVM "vehicle.sqf"
  
	
Contact & Bugreport: cwadensten@gmail.com
Ported for new update "call compile" by SPJESTER: mhowell34@gmail.com
================================================================================================================== */

// optimized and softProtect added by fred41
#define SAFETY_VEHICLE_ZONE 150
ProtectVehicleGlobal = {
	private["_unit","_side"];
	_unit = _this select 0;
	_side = _this select 1;
	if ( _side == "Bluefor") then {	
		_unit addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos "ProtectBluefor" < SAFETY_VEHICLE_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
		_unit addEventHandler ["Killed",{_unit = _this select 0; if (_unit distance getMarkerPos "ProtectBluefor" < SAFETY_VEHICLE_ZONE) then {_unit setDamage 0;};}];
	};
	if ( _side == "Opfor") then { 
		_unit addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos "ProtectOpfor" < SAFETY_VEHICLE_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
		_unit addEventHandler ["Killed",{_unit = _this select 0; if (_unit distance getMarkerPos "ProtectOpfor" < SAFETY_VEHICLE_ZONE) then {_unit setDamage 0;};}];
	};
	ProtectVehicle = [netId _unit, _side];
	publicVariable "ProtectVehicle";
	true
};

DeProtectVehicleGlobal = {
	private["_unit"];
	_unit = _this select 0;
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "Killed";
	DeProtectVehicle = [netId _unit];
	publicVariable "DeProtectVehicle";
	false
};


if (!isServer) exitWith {};
waitUntil {!isNil {TW_BasicVehicles}};
diag_log "vehicle.sqf running ...";
private["_unitIndex","_unit","_unitprotected","_delay","_deserted","_respawns","_explode","_dynamic","_unitinit","_haveinit","_hasname","_unitname","_noend","_run","_rounds","_dir","_position","_type","_dead","_nodelay","_side","_timeout"];

// Define variables
_unit = _this select 0;
_unitIndex = TW_BasicVehicles find _unit;
_delay = if (count _this > 1) then {_this select 1} else {2};
_deserted = if (count _this > 2) then {_this select 2} else {120};
_respawns = if (count _this > 3) then {_this select 3} else {0};
_explode = if (count _this > 4) then {_this select 4} else {false};
_dynamic = if (count _this > 5) then {_this select 5} else {false};
_unitinit = if (count _this > 6) then {_this select 6} else {};
_haveinit = if (count _this > 6) then {true} else {false};

_hasname = false;
_unitname = vehicleVarName _unit;
// if (isNil _unitname) then {_hasname = false;} else {_hasname = true;};
_noend = true;
_run = true;
_rounds = 0;

if (_delay < 0) then {_delay = 0};
if (_deserted < 0) then {_deserted = 0};
if (_respawns <= 0) then {_respawns = 0; _noend = true;};
if (_respawns > 0) then {_noend = false};

_dir = getDir _unit;
_position = getPosASL _unit;
_type = typeOf _unit;
_dead = false;
_nodelay = true;
_timeout = 0;

_side = "neutral";
if ((_position distance getMarkerPos "ProtectBluefor") < SAFETY_VEHICLE_ZONE) then {_side = "Bluefor";};
if ((_position distance getMarkerPos "ProtectOpfor") < SAFETY_VEHICLE_ZONE) then {_side = "Opfor";};
_unit removeAllEventHandlers "HandleDamage";
_unit removeAllEventHandlers "Killed";
_unitprotected = false;


// Start monitoring the vehicle
while {_run} do 
{	
	sleep (_delay + random 10);
	// Check if deleted
	if (!isNull _unit) then {
		if(!_unitprotected) then {
			_unitprotected = [_unit, _side] call ProtectVehicleGlobal;
		};
		
	
		if ((getDammage _unit > 0.8) and ({alive _x} count crew _unit == 0)) then {
			_dead = true
		} else {
			// Check if the vehicle is deserted.
			if (_deserted > 0) then	{
				if ((getPosASL _unit distance _position > 10) and ({alive _x} count crew _unit == 0) and (getDammage _unit <= 0.8)) then {
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
	
	// Respawn vehicle
	if (_dead) then 
	{	
		sleep _delay + random 10;
		if (!isNull _unit) then {
			_unitprotected = [_unit] call DeProtectVehicleGlobal;
			deleteVehicle _unit;
		};
		_unit = _type createVehicle _position;
		TW_BasicVehicles set [_unitIndex, _unit];
		_unit setPosASL _position;
		_unit setDir _dir;
		_unitprotected = [_unit, _side] call ProtectVehicleGlobal;

		_dead = false;
	};
};