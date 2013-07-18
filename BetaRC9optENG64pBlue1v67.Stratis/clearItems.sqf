_objcleaner1 = _this select 0;    // object center point for radius.
_rad = _this select 1;  //  radius outwards from center point to clear items.

sleep 1200;     // or whatever time you want..

    
_clear = nearestObjects [_objcleaner1,["weaponholder", "WeaponHolderSimulated", "GroundWeaponHolder"],_rad + 4000];
	for "_i" from 0 to count _clear - 1 do {
	deleteVehicle (_clear select _i);
	sleep 10;
	};

[trigclean1,4000] execVM "clearItems.sqf";