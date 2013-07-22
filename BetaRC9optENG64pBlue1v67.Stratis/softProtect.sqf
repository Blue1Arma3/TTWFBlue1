// soft protect by fred41, based on grenadeStop from 


#define SAFETY_INFANTRY_ZONES [["ProtectOpfor", east, 100, 500, 1000], ["ProtectBluefor", west, 100, 500, 1000]] // Syntax: [["marker1", friendlyside, radius1friendly, radius1enemy, radius1warning], ["marker2", friendlyside, radius2friendly, radius2enemy, radius2warning]]

#define MESSAGE "Firing at / to bases is STRICTLY PROHIBITED!"
#define MESSAGE_WARNING "You are near the enemy base, leave this area or risc to be killed!"
#define MESSAGE_MORTAR	"No point you putting that up, soldier!"

if (isDedicated) exitWith {};
waitUntil {!isNull player};

player addEventHandler ["Fired", {
	if ({(side (_this select 0))==(_x select 1)&&(_this select 0) distance getMarkerPos (_x select 0) < _x select 2 } count SAFETY_INFANTRY_ZONES > 0) then {
		deleteVehicle (_this select 6);
		titleText [MESSAGE, "PLAIN", 3];
	} else { if ({(side (_this select 0))!=(_x select 1)&&(_this select 0) distance getMarkerPos (_x select 0) < _x select 3 } count SAFETY_INFANTRY_ZONES > 0) then {
				deleteVehicle (_this select 6);
				titleText [MESSAGE, "PLAIN", 3];
			};
	};	
}];

player addEventHandler ["WeaponAssembled", {
	deleteVehicle _this select 1;
	titleText [MESSAGE_MORTAR, "PLAIN", 3];
}];


while {true} do {
	if ({playerSide!=(_x select 1)&& player distance getMarkerPos (_x select 0) < _x select 4 } count SAFETY_INFANTRY_ZONES > 0) then {
		// warning and slowkill for vehicle
		if (vehicle player != player) then { 
			titleText [MESSAGE_WARNING, "PLAIN", 3];
			vehicle player setDammage (getDammage vehicle player + 0.02); 
		};
		// warning, noshot and slowkill for infantry, kill for vehicle
		if ({playerSide!=(_x select 1)&& player distance getMarkerPos (_x select 0) < _x select 3 } count SAFETY_INFANTRY_ZONES > 0) then {
			if (vehicle player != player) then { 
				vehicle player setDammage 1; 
			} else {
				titleText [MESSAGE_WARNING, "PLAIN", 3];
				player setDammage (getDammage player + 0.02);
			};
		};
	};	
	sleep 2;
};