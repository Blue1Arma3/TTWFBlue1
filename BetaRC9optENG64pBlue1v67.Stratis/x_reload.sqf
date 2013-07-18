
/*/TW_Repair_Cost = 350;
//TW_Repair_Time = 30;

//TW_Sup_Fuel_Cost = 200;
//TW_Sup_Fuel_Time = 5;		//Time to fill up 10% of the tank

//TW_Sup_Reammo_Cost = 600;
//TW_Sup_Reammo_Time = 60;
*/





_object = _this;

_type = typeOf _object;

x_reload_time_factor = 10.00;

_object setVehicleAmmo 1;

_object vehicleChat format ["On Service %1... Wait 30 seconds...", _type];

_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

if (count _magazines > 0) then {
	_removed = [];
	{
		if (!(_x in _removed)) then {
			_object removeMagazines _x;
			_removed = _removed + [_x];
		};
	} forEach _magazines;
	{
		_object vehicleChat format ["Recharge, 10 seconds %1", _x];
		sleep x_reload_time_factor;
		_object addMagazine _x;
	} forEach _magazines;
};

_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");

if (_count > 0) then {
	for "_i" from 0 to (_count - 1) do {
		scopeName "xx_reload2_xx";
		_config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
		_magazines = getArray(_config >> "magazines");
		_removed = [];
		{
			if (!(_x in _removed)) then {
				_object removeMagazines _x;
				_removed = _removed + [_x];
			};
		} forEach _magazines;
		{
			_object vehicleChat format ["Recharge %1", _x];
			sleep x_reload_time_factor;
			_object addMagazine _x;
			sleep x_reload_time_factor;
		} forEach _magazines;
		_count_other = count (_config >> "Turrets");
		if (_count_other > 0) then {
			for "_i" from 0 to (_count_other - 1) do {
				_config2 = (_config >> "Turrets") select _i;
				_magazines = getArray(_config2 >> "magazines");
				_removed = [];
				{
					if (!(_x in _removed)) then {
						_object removeMagazines _x;
						_removed = _removed + [_x];
					};
				} forEach _magazines;
				{
					_object vehicleChat format ["Recharge %1", _x]; 
					sleep x_reload_time_factor;
					_object addMagazine _x;
					sleep x_reload_time_factor;
				} forEach _magazines;
			};
		};
	};
};
_object setVehicleAmmo 1;	// Reload turrets / drivers magazine

sleep x_reload_time_factor;
_object vehicleChat "Repairing...";
_object setDamage 0;
sleep x_reload_time_factor;
_object vehicleChat "Fueling...";
while {fuel _object < 0.99} do {
	//_object setFuel ((fuel _vehicle + 0.1) min 1);
	_object setFuel 1;
	sleep 0.01;
};
sleep x_reload_time_factor;
_object vehicleChat format ["%1 Done ...", _type];

if (true) exitWith {};
