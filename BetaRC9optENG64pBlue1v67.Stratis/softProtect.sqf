// softProtect by fred41
// Protect player and basic vehicles local on client, shoting and damage handled
#define SAFETY_VEHICLE_ZONE 150
#define SAFETY_PLAYER_ZONE 150
#define ENEMY_PLAYER_WARNING_ZONE 400
#define ENEMY_VEHICLE_KILLING_ZONE 400
#define ENEMY_VEHICLE_WARNING_ZONE 800

#define MESSAGE "Firing at / to bases is STRICTLY PROHIBITED!"
#define MESSAGE_WARNING "You are near the enemy base, leave this area or risc to be killed!"
#define MESSAGE_MORTAR	"No point you putting that up, soldier!"

ProtectVehicle = [];
"ProtectVehicle" addPublicVariableEventHandler {
	private ["_unit","_side"];
	_unit = objectFromNetId ((_this select 1) select 0);
	_side = (_this select 1) select 1;
	_unit removeAllEventHandlers "Fired";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "Killed";
	if ( _side == "Bluefor") then {	
		_unit addEventHandler ["Fired", {if ((_this select 0) distance getMarkerPos "ProtectBluefor" < SAFETY_VEHICLE_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
		_unit addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos "ProtectBluefor" < SAFETY_VEHICLE_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
		_unit addEventHandler ["Killed",{_unit = _this select 0; if (_unit distance getMarkerPos "ProtectBluefor" < SAFETY_VEHICLE_ZONE) then {_unit setDamage 0;};}];
	};	
	if ( _side == "Opfor") then { 
		_unit addEventHandler ["Fired", {if ((_this select 0) distance getMarkerPos "ProtectOpfor" < SAFETY_VEHICLE_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
		_unit addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos "ProtectOpfor" < SAFETY_VEHICLE_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
		_unit addEventHandler ["Killed",{_unit = _this select 0; if (_unit distance getMarkerPos "ProtectOpfor" < SAFETY_VEHICLE_ZONE) then {_unit setDamage 0;};}];
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
	player addEventHandler ["Fired", {_unit = _this select 0; if (_unit distance getMarkerPos "ProtectBluefor" < SAFETY_PLAYER_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
	player addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos "ProtectBluefor" < SAFETY_PLAYER_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];

};
if (playerSide==east) then {
	player addEventHandler ["Fired", {_unit = _this select 0; if (_unit distance getMarkerPos "ProtectOpfor" < SAFETY_PLAYER_ZONE) then {deleteVehicle (_this select 6); titleText [MESSAGE, "PLAIN", 1];};}];
	player addEventHandler ["HandleDamage",{_unit = _this select 0; _damage = _this select 2; if (_unit distance getMarkerPos "ProtectOpfor" < SAFETY_PLAYER_ZONE) exitWith {_unit setDamage 0; 0}; _damage}];
};

player addEventHandler ["WeaponAssembled", {
	deleteVehicle _this select 1;
	titleText [MESSAGE_MORTAR, "PLAIN", 3];
}];

// safety, warning-softkill and kill zones
private["_enemyside"];
if (playerSide == west) then { _enemyside = "ProtectOpfor" };
if (playerSide == east) then { _enemyside = "ProtectBluefor" };
while {true} do {
	if (vehicle player == player) then {
		if (player distance getMarkerPos _enemyside < ENEMY_PLAYER_WARNING_ZONE) then {	
			titleText [MESSAGE_WARNING, "PLAIN", 1];
			player setDammage (getDammage player + 0.02);
		};
	} else {
		if (player distance getMarkerPos _enemyside < ENEMY_VEHICLE_WARNING_ZONE) then {	
			if (player distance getMarkerPos _enemyside < ENEMY_VEHICLE_KILLING_ZONE) then {
				vehicle player setDammage 1;
			} else {
				titleText [MESSAGE_WARNING, "PLAIN", 1];
				player setDammage (getDammage player + 0.02);
			};
		};
	};
	sleep 2;
};
