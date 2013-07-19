#define CLEANUP_INTERVAL 1200

private ["_i","_clearTypes","_count", "_delay"];
_clearTypes = ["weaponholder", "WeaponHolderSimulated", "GroundWeaponHolder", "Wreck_Base", "Wreck_Base_F", "crater", "craterlong"];
_count = count _clearTypes;

_delay = CLEANUP_INTERVAL / _count;

while{true} do { 
	for "_i" from 0 to _count do {
		{
			sleep _delay;	
			deleteVehicle _x;
			sleep 0.5;
		} foreach allMissionObjects (_clearTypes select _i);
	};
};	
