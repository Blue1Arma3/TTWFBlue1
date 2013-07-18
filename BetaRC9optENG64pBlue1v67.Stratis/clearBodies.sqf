_objcleaner2 = _this select 0;    // object center point for radius.
_rad = _this select 1;  //  radius outwards from center point to clear items.

sleep 1200;     // or whatever time you want..

    
_clear = nearestObjects [_objcleaner2,["Wreck_Base", "Wreck_Base_F", "crater", "craterlong"],_rad + 4000];
	for "_i" from 0 to count _clear - 1 do {
	deleteVehicle (_clear select _i);
	sleep 1;
	};

[trigclean2,4000] execVM "clearBodies.sqf";