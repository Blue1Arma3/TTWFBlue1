#define CLEANUP_INTERVAL 1200
private ["_i","_Type","_clearTypes","_count", "_delay", "_Objects"];

_clearTypes = ["Weaponholder", "WeaponHolderSimulated", "GroundWeaponHolder", "Wreck_Base", "Wreck_Base_F", "crater", "craterlong"];
_count = count _clearTypes;
_delay = CLEANUP_INTERVAL / _count;

while{true} do { 
	for "_i" from 0 to _count - 1 do {
		sleep _delay;
		_type = (_clearTypes select _i);
		{
			if (_x isKindOf _Type) then {
				deleteVehicle _x;
				diag_log format ["deleted: %1", typeOf _x];
			};
		} foreach allMissionObjects "All";
	};
};
