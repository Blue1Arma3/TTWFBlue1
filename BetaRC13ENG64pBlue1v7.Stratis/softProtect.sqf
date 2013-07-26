// softProtect by fred41
// Protect player and basic vehicles local on client, shoting and damage handled
#define MARKER_WEST "ProtectWest"
#define MARKER_EAST "ProtectEast"
#define SAFETY_VEHICLE_ZONE 150
#define SAFETY_PLAYER_ZONE 150
#define ENEMY_PLAYER_WARNING_ZONE 300
#define ENEMY_VEHICLE_KILLING_ZONE 300
#define ENEMY_VEHICLE_WARNING_ZONE 500

#define MESSAGE "Firing at / to Mainbases is STRICTLY PROHIBITED!"
#define MESSAGE_WARNING "You are near the enemy base, leave this area or risk to get killed!"
#define MESSAGE_MORTAR	"No point you putting that up, soldier!"

ProtectVehicle = [];
"ProtectVehicle" addPublicVariableEventHandler {
	private ["_unit","_side"];
	_unit = objectFromNetId ((_this select 1) select 0);
	_side = (_this select 1) select 1;
	_unit removeAllEventHandlers "Fired";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "Killed";
	if ( _side == "west") then { 	
		_unit addEventHandler ["Fired", {if ((_this select 0) distance getMarkerPos MARKER_WEST < SAFETY_VEHICLE_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
		_unit addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos MARKER_WEST < SAFETY_VEHICLE_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
		_unit addEventHandler ["Killed",{_unit = _this select 0; if (_unit distance getMarkerPos MARKER_WEST < SAFETY_VEHICLE_ZONE) then {_unit setDamage 0;};}];
	};	
	if ( _side == "east") then { 
		_unit addEventHandler ["Fired", {if ((_this select 0) distance getMarkerPos MARKER_EAST < SAFETY_VEHICLE_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
		_unit addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos MARKER_EAST < SAFETY_VEHICLE_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
		_unit addEventHandler ["Killed",{_unit = _this select 0; if (_unit distance getMarkerPos MARKER_EAST < SAFETY_VEHICLE_ZONE) then {_unit setDamage 0;};}];
	};
};

DeProtectVehicle = [];
"DeProtectVehicle" addPublicVariableEventHandler {
	private ["_unit"];
	_unit = objectFromNetId ((_this select 1) select 0);
	_unit removeAllEventHandlers "Fired";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "Killed";
};

if (isDedicated) exitWith {};
waitUntil {!isNull player};

player removeAllEventHandlers "Fired";
player removeAllEventHandlers "HandleDamage";
player removeAllEventHandlers "WeaponAssembled";

if (playerSide==west) then {
	player addEventHandler ["Fired", {_unit = _this select 0; if (_unit distance getMarkerPos MARKER_WEST < SAFETY_PLAYER_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
	player addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos MARKER_WEST < SAFETY_PLAYER_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];

};
if (playerSide==east) then {
	player addEventHandler ["Fired", {_unit = _this select 0; if (_unit distance getMarkerPos MARKER_EAST < SAFETY_PLAYER_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
	player addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos MARKER_EAST < SAFETY_PLAYER_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
};

player addEventHandler ["WeaponAssembled", {
	deleteVehicle _this select 1;
	titleText [MESSAGE_MORTAR, "PLAIN", 3];
}];

// safety, warning-softkill and kill zones
private["_enemymarker","_distance"];
if (playerSide == west) then { _enemymarker = MARKER_EAST };
if (playerSide == east) then { _enemymarker = MARKER_WEST };
while {true} do {
	_distance = player distance getMarkerPos _enemymarker;
	if (vehicle player == player) then {
		if (_distance < ENEMY_PLAYER_WARNING_ZONE) then {	
			player setDammage (getDammage player + 0.02);
			titleText [MESSAGE_WARNING, "PLAIN", 1];
		};
	} else {
		if (_distance < ENEMY_VEHICLE_WARNING_ZONE) then {	
			if (_distance < ENEMY_VEHICLE_KILLING_ZONE) then {
				vehicle player setDammage 1;
			} else {
				vehicle player setDammage (getDammage vehicle player + 0.02);
				titleText [MESSAGE_WARNING, "PLAIN", 1];
			};
		};
	};
	sleep 2;
};
