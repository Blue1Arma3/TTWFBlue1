_objcleaner2 = _this select 0;    // object center point for radius.
_rad = _this select 1;  //  radius outwards from center point to clear items.

sleep 600;     // or whatever time you want..

_clear = nearestObjects [_objcleaner2,["vehicle", "wreck", "crater", "craterlong"],_rad + 4000];
	for "_i" from 0 to count _clear - 1 do
			{
						{
						if ((count(crew _x) == 0) and ((damage _x > 0.5) or !(canMove _x))) then 
							{
								deleteVehicle vehicle _x;
								deleteVehicle _x;
							};
						} forEach vehicles;
				
				
				{if !(_x isKindOf "Man") then {deleteVehicle _x};} forEach allDEAD;
					{deleteVehicle _x} forEach (allMissionObjects "wreck")+(allMissionObjects "crater")+(allMissionObjects "craterlong");
				
					sleep 20;
			};

[trigclean2,4000] execVM "veh_cleanup.sqf";


