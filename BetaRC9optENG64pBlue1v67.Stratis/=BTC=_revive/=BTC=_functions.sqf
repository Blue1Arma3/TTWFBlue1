/*
Created by =BTC= Giallustio
version 0.8.1
Visit us at: 
http://www.blacktemplars.altervista.org/
06/03/2012
*/
//Functions
BTC_assign_actions =
{
	if ([player] call BTC_is_class_can_revive) then {player addAction [("<t color=""#ED2744"">") + ("First Aid") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_first_aid], 8, true, true, "", "[] call BTC_check_action_first_aid"];};
	player addAction [("<t color=""#ED2744"">") + ("Drag Body") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_drag], 8, true, true, "", "[] call BTC_check_action_drag"];
	player addAction [("<t color=""#ED2744"">") + ("Pull Out injured") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_pull_out], 8, true, true, "", "[] call BTC_pull_out_check"];
};
/*

*/
BTC_fnc_handledamage =
{
	_player = _this select 0;
	_enemy  = _this select 3;
	_damage = _this select 2;
	_part   = _this select 1;
	if (Alive _player) then
	{
		//BTC_gear = [] call BTC_get_gear;
		loadout = [player] call getLoadout;
	};
	_damage
	//if (format ["%1", _player getVariable "BTC_need_revive"] == "1") then {} else {_damage};
};
BTC_fnc_PVEH =
{
	//0 - first aid - create // [0,east,pos]
	//1 - first aid - delete
	_array = _this select 1;
	_type  = _array select 0;
	switch (true) do
	{
		case (_type == 0) : 
		{
			_side = _array select 1;
			_unit = _array select 3;
			if (_side == BTC_side) then 
			{
				_pos = _array select 2;
				_marker = createmarkerLocal [format ["FA_%1", _pos], _pos];
				format ["FA_%1", _pos] setmarkertypelocal "mil_box";
				format ["FA_%1", _pos] setMarkerTextLocal format ["F.A. %1", name _unit];
				format ["FA_%1", _pos] setmarkerColorlocal "ColorGreen";
				format ["FA_%1", _pos] setMarkerSizeLocal [0.3, 0.3];
				[_pos,_unit] spawn
				{
					_pos  = _this select 0;
					_unit = _this select 1;
					while {(!(isNull _unit) && (format ["%1", _unit getVariable "BTC_need_revive"] == "1"))} do
					{
						format ["FA_%1", _pos] setMarkerPosLocal getpos _unit;
						sleep 1;
					};
					deleteMarker format ["FA_%1", _pos];
				};
			};
		};
		case (_type == 1) : {(_array select 1) setDir 180;(_array select 1) playMoveNow "AinjPpneMstpSnonWrflDb_grab";};
		case (_type == 2) : 
		{
			private ["_injured"];
			_injured = (_array select 1);
			[_injured] spawn
			{
				_injured = _this select 0;
				_injured allowDamage false;
				WaitUntil {sleep 1; (isNull _injured) || (format ["%1", _injured getVariable "BTC_need_revive"] == "0")};
				_injured allowDamage true;
			};
		};
		case (_type == 3) : 
		{
			private ["_injured","_veh"];
			_injured = (_array select 1);
			_veh     = (_array select 2);
			if (name _injured == name player) then {_injured moveInCargo _veh};
		};
		case (_type == 4) : 
		{
			private ["_array_injured"];
			_array_injured = (_array select 1);
			{
				if (name player == name _x) then {unAssignVehicle player;player action ["eject", vehicle player];};
			} foreach _array_injured;
		};
	};
};
BTC_first_aid =
{
	private ["_injured","_array_item_injured","_array_item","_cond"];
	_men = nearestObjects [player, ["Man"], 2];
	if (count _men > 1) then {_injured = _men select 1;};
	if (format ["%1",_injured getVariable "BTC_need_revive"] != "1") exitWith {};
	_array_item = items player;
	_array_item_injured = items _injured;
	_cond = false;
	if (BTC_need_first_aid == 0) then {_cond = true;};
	if ((_array_item_injured find "FirstAidKit" == -1) && (BTC_need_first_aid == 1)) then {_cond = false;} else {_cond = true;};
	if (!_cond && BTC_need_first_aid == 1) then {if ((_array_item find "FirstAidKit" == -1)) then {_cond = false;} else {_cond = true;};};
	if (!_cond) exitWith {hint "Can't revive him";};
	if (BTC_need_first_aid == 1) then {if (_array_item_injured find "FirstAidKit" == -1) then {player removeItem "FirstAidKit";};};
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 5;
	waitUntil {!Alive player || (animationState player != "AinvPknlMstpSlayWrflDnon_medic" && animationState player != "amovpercmstpsraswrfldnon_amovpknlmstpsraswrfldnon" && animationState player != "amovpknlmstpsraswrfldnon_ainvpknlmstpslaywrfldnon" && animationState player != "ainvpknlmstpslaywrfldnon_amovpknlmstpsraswrfldnon")};
	if (Alive player && Alive _injured) then
	{
		_injured setVariable ["BTC_need_revive",0,true];
		_injured playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";
	};
};
BTC_drag =
{
	private ["_injured"];
	_men = nearestObjects [player, ["Man"], 2];
	if (count _men > 1) then {_injured = _men select 1;};
	if (format ["%1",_injured getVariable "BTC_need_revive"] != "1") exitWith {};
	BTC_dragging = true;
	_injured attachTo [player, [0, 1.1, 0.092]];
	player playMoveNow "AcinPknlMstpSrasWrflDnon";
	_id = player addAction [("<t color=""#ED2744"">") + ("Release") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_release], 9, true, true, "", "true"];
	_injured playMoveNow "AinjPpneMstpSnonWrflDb_grab";
	BTC_drag_pveh = [1,_injured];publicVariable "BTC_drag_pveh";
	WaitUntil {!Alive player || ((animationstate player == "acinpknlmstpsraswrfldnon") || (animationstate player == "acinpknlmwlksraswrfldb"))};
	private ["_act","_veh_selected","_array","_array_veh","_name_veh","_text_action","_action_id"];
	_act = 0;_veh_selected = objNull;_array_veh = [];
	while {!isNull player && alive player && !isNull _injured && alive _injured && format ["%1", _injured getVariable "BTC_need_revive"] == "1" && BTC_dragging} do
	{
		_array = nearestObjects [player, ["Air","LandVehicle"], 5];
		_array_veh = [];
		{if (_x emptyPositions "cargo" != 0) then {_array_veh = _array_veh + [_x];};} foreach _array;
		if (count _array_veh == 0) then {_veh_selected = objNull;};
		if (count _array_veh > 0 && _veh_selected != _array_veh select 0) then 
		{
			_veh_selected    = _array_veh select 0;
			_name_veh        = getText (configFile >> "cfgVehicles" >> typeof _veh_selected >> "displayName");
			_text_action     = ("<t color=""#ED2744"">" + "Load wounded in " + (_name_veh) + "</t>");
			_action_id = player addAction [_text_action,"=BTC=_revive\=BTC=_addAction.sqf",[[_injured,_veh_selected],BTC_load_in], 7, true, true];
			_act  = 1;
		};
		if (count _array_veh == 0 && _act == 1) then {player removeAction _action_id;_act = 0;};
		sleep 0.1;
	};
	if (_act == 1) then {player removeAction _action_id;};
	player playMoveNow "AmovPknlMstpSrasWrflDnon";
	detach _injured;
	if (format ["%1",_injured getVariable "BTC_need_revive"] == "1") then {_injured playMoveNow "AinjPpneMstpSnonWrflDb_release";};
	player removeAction _id;
	BTC_dragging = false;
};
BTC_release =
{
	BTC_dragging = false;
};
BTC_load_in =
{
	_injured = _this select 0;
	_veh     = _this select 1;
	BTC_dragging = false;
	BTC_load_pveh = [3,_injured,_veh];publicVariable "BTC_load_pveh";
};
BTC_pull_out =
{
	_array = nearestObjects [player, ["Air","LandVehicle"], 5];
	_array_injured = [];
	if (count _array != 0) then
	{
		{
			if (format ["%1",_x getVariable "BTC_need_revive"] == "1") then {_array_injured = _array_injured + [_x];};
		} foreach crew (_array select 0);
	};
	BTC_pullout_pveh = [4,_array_injured];publicVariable "BTC_pullout_pveh";
};
BTC_pull_out_check =
{
	_cond = false;
	_array = nearestObjects [player, ["Air","LandVehicle"], 5];
	if (count _array != 0) then
	{
		{
			if (format ["%1",_x getVariable "BTC_need_revive"] == "1") then {_cond = true;};
		} foreach crew (_array select 0);
	};
	_cond
};
BTC_player_killed =
{
	private ["_type_backpack","_weapons","_magazines","_weapon_backpack","_ammo_backpack","_score","_score_array","_name","_body_marker"];
	titleText ["", "BLACK OUT"];
	_body = _this select 0;
	[_body] spawn
	{
		_body = _this select 0;
		_dir = getDir _body;
		_pos = getPosATL vehicle _body;
		if (BTC_active_lifes == 1) then {BTC_lifes = BTC_lifes - 1;};
		if (BTC_active_lifes == 1 && BTC_lifes == 0) exitWith BTC_out_of_lifes;
		if (BTC_lifes != 0 || BTC_active_lifes == 0) then
		{
			WaitUntil {Alive player};
			_body_marker = player;
			if (BTC_pvp == 0) then {player setcaptive true;};
			//player setvehicleInit "this allowDamage false;";ProcessInitCommands;
			BTC_killed_pveh = [2,_body_marker];publicVariable "BTC_killed_pveh";player allowDamage false;
			player setVariable ["BTC_need_revive",1,true];
			player switchMove "AinjPpneMstpSnonWrflDnon";
			_actions = [] spawn BTC_assign_actions;
			if (BTC_respawn_gear == 1) then 
			{
				//_gear = [player,BTC_gear] spawn BTC_set_gear;
				[player,loadout] spawn setLoadout;
			};
			WaitUntil {animationstate player == "ainjppnemstpsnonwrfldnon"};
			sleep 2;
			player setDir _dir;
			player setPosATL _pos;
			deletevehicle _body;
			_side = side player;
			_injured = player;
			if (BTC_injured_marker == 1) then {BTC_marker_pveh = [0,BTC_side,_pos,_body_marker];publicVariable "BTC_marker_pveh";};
			disableUserInput true;
			for [{_n = BTC_revive_time_min}, {_n != 0 && damage player > 0.2}, {_n = _n - 0.5}] do
			{
				if (BTC_active_lifes == 1) then {titleText [format ["Lifes remaining: %1",BTC_lifes], "BLACK FADED"];} else {titleText ["", "BLACK FADED"];};
				sleep 0.5;
			};
			if (BTC_black_screen == 0) then {titleText ["", "BLACK IN"];};
			disableUserInput false;
			_time = time;
			_timeout = _time + BTC_revive_time_max;
			private ["_id","_lifes"];
			if (BTC_disable_respawn == 1) then {player enableSimulation false;};
			if (BTC_black_screen == 0 && BTC_disable_respawn == 0) then {if (BTC_action_respawn == 0) then {_dlg = createDialog "BTC_respawn_button_dialog";} else {_id = player addAction [("<t color=""#ED2744"">") + ("Respawn") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_player_respawn], 9, true, true, "", "true"];};};
			if (BTC_black_screen == 1 && BTC_disable_respawn == 0) then {_dlg = createDialog "BTC_respawn_button_dialog";};
			while {format ["%1", player getVariable "BTC_need_revive"] == "1" && time < _timeout} do
			{
				if (BTC_black_screen == 0) then {if (animationstate player != "ainjppnemstpsnonwrfldnon" && animationstate player != "AinjPpneMstpSnonWrflDb_grab" && vehicle player == player) then {player switchMove "AinjPpneMstpSnonWrflDnon";};};
				if (BTC_disable_respawn == 0) then {if (BTC_black_screen == 1 || (BTC_black_screen == 0 && BTC_action_respawn == 0)) then {if (!Dialog) then {_dlg = createDialog "BTC_respawn_button_dialog";};};};
				_healer = call BTC_check_healer;
				_lifes = "";
				if (BTC_active_lifes == 1) then {_lifes = format ["Lifes remaining: %1",BTC_lifes];};
				if (BTC_black_screen == 1) then {titleText [format ["%1\n%2\n%3", round (_timeout - time),_healer,_lifes], "BLACK FADED"]} else {hintSilent format ["%1\n%2\n%3", round (_timeout - time),_healer,_lifes];};
				sleep 0.5;
			};
			closedialog 0;
			if (time > _timeout && format ["%1", player getVariable "BTC_need_revive"] == "1") then 
			{
				_respawn = [] spawn BTC_player_respawn;
			};
			if (format ["%1", player getVariable "BTC_need_revive"] == "0" && !BTC_respawn_cond) then 
			{
				if (BTC_black_screen == 1) then {titleText ["", "BLACK IN"];} else {hintSilent "";};
				if (BTC_need_first_aid == 1 && ((items player) find "FirstAidKit" != -1)) then {player removeItem "FirstAidKit";};
				player playMove "amovppnemstpsraswrfldnon";
				player playMove "";
			};
			if (BTC_black_screen == 0 && BTC_action_respawn == 1 && BTC_disable_respawn == 0) then {player removeAction _id;};
			if (BTC_pvp == 0) then {player setcaptive false;};
			if (BTC_disable_respawn == 1) then {player enableSimulation true;};
			//player setvehicleInit "this allowDamage true;";ProcessInitCommands;
			player allowDamage true;
			hintSilent "";
		};
	};
};
BTC_check_healer =
{
	_pos = getpos player;
	_men = [];_dist = 501;_healer = objNull;_healers = [];
	_msg = "No healer in 500 m";
	_men = nearestObjects [_pos, BTC_who_can_revive, 500];
	if (count _men > 0) then
	{
		{if (Alive _x && format ["%1",_x getVariable "BTC_need_revive"] != "1" && ([_x,player] call BTC_can_revive) && isPlayer _x && side _x == BTC_side) then {_healers = _healers + [_x];};} foreach _men;
		if (count _healers > 0) then
		{
			{
				if (_x distance _pos < _dist) then {_healer = _x;_dist = _x distance _pos;};
			} foreach _healers;
			if !(isNull _healer) then {_msg = format ["%1 could heal you! He is %2 m away!", name _healer,round(_healer distance _pos)];};
		};
	};
	_msg
};
BTC_player_respawn =
{
	BTC_respawn_cond = true;
	player setVariable ["BTC_need_revive",0,true];
	if (BTC_black_screen == 0) then {titleText ["", "BLACK OUT"];};
	sleep 0.2;
	if (BTC_black_screen == 0) then {titleText ["", "BLACK FADED"];};
	if (vehicle player != player) then {unAssignVehicle player;player action ["eject", vehicle player];};
	player setPos getMarkerPos BTC_respawn_marker;
	sleep 1;
	player setDamage 0;
	player switchMove "amovpercmstpslowwrfldnon";
	player switchMove "";
	if (BTC_respawn_time > 0) then
	{
		player enableSimulation false;
		player setpos [0,0,6000];
		player setVelocity [0,0,0];
		sleep 1;
		private ["_n"];
		for [{_n = BTC_respawn_time}, {_n != 0}, {_n = _n - 1}] do
		{
			private ["_msg"];
			player enableSimulation false;
			player setpos [0,0,6000];
			player setVelocity [0,0,0];
			titleText [format ["Respawn in %1",_n], "BLACK FADED"];
			sleep 1;
		};
		player enableSimulation true;
		deTach player;
		player setVelocity [0,0,0];
		player setPos getMarkerPos BTC_respawn_marker;
//		deleteVehicle _obj;
	};
	if (BTC_black_screen == 0 || BTC_respawn_time > 0) then 
	{	
		titleText ["", "BLACK IN"];
		//sleep 2;
		//titleText ["", "PLAIN"];
	};
	player setVariable ["BTC_need_revive",0,true];
	BTC_respawn_cond = false;
	[] call Tee_Player_Respawn;
	if (BTC_black_screen == 1 && BTC_respawn_time == 0) then {titleText ["", "BLACK IN"];sleep 2;titleText ["", "PLAIN"];};
};
BTC_check_action_first_aid =
{
	private ["_injured","_array_item_injured"];
	_cond = false;
	_array_item = items player;
	_men = nearestObjects [vehicle player, ["Man"], 2];
	if (count _men > 1 && format ["%1", player getVariable "BTC_need_revive"] == "0") then
	{
		if (format ["%1", (_men select 1) getVariable "BTC_need_revive"] == "1" && !BTC_dragging) then {_cond = true;};
		_injured = _men select 1;
	};
	if (_cond && BTC_pvp == 1) then 
	{
		if (side (_men select 1) == BTC_side) then {_cond = true;} else {_cond = false;};
	};
	if (_cond && BTC_need_first_aid == 1) then
	{
		
		if (_array_item find "FirstAidKit" == -1) then {_cond = false;};
		_array_item_injured = items _injured;
		if (!_cond && _array_item_injured find "FirstAidKit" != -1) then {_cond = true;};
	};
	_cond
};
BTC_check_action_drag =
{
	_cond = false;
	_men = nearestObjects [vehicle player, ["Man"], 2];
	if (count _men > 1) then
	{
		if (format ["%1", (_men select 1) getVariable "BTC_need_revive"] == "1" && !BTC_dragging) then {_cond = true;};
	};
	_cond
};
BTC_is_class_can_revive =
{
	_unit    = _this select 0;
	_cond = false;
	{if (_unit isKindOf _x) then {_cond = true};} foreach BTC_who_can_revive;
	_cond
};
BTC_can_revive =
{
	_unit    = _this select 0;
	_injured = _this select 1;
	_array_item_unit    = items _unit;
	_array_item_injured = items _injured;
	_cond = false;
	{if (_unit isKindOf _x) then {_cond = true};} foreach BTC_who_can_revive;
	if (_cond && BTC_need_first_aid == 1) then
	{
		if (_array_item_unit find "FirstAidKit" == -1) then {_cond = false;};
		if (!_cond && _array_item_injured find "FirstAidKit" != -1) then {_cond = true;};
	};
	_cond
};
//Mobile
BTC_move_to_mobile =
{
	_var = _this select 0;
	_side = "";
	switch (true) do
	{
		case (BTC_side == west) : {_side = "BTC_mobile_west";};
		case (BTC_side == east) : {_side = "BTC_mobile_east";};
		case (BTC_side == guer) : {_side = "BTC_mobile_guer";};
	};
	_mobile = objNull;
	{
		if ((typeName (_x getvariable _side)) == "STRING") then
		{
			if ((_x getvariable _side) == _var) then {_mobile = _x;};
		};
	} foreach vehicles;
	if (isNull _mobile) exitWith {};
	if (speed _mobile > 2) exitWith {hint "Mobile respawn is moving! Can't move there!";};
	_pos = getPos _mobile;
	titleText ["Get Ready", "BLACK OUT"];
	sleep 3;
	titleText ["Get Ready", "BLACK FADED"];
	sleep 2;
	titleText ["", "BLACK IN"];
	player setPos [(_pos select 0) + ((random 50) - (random 50)), (_pos select 1) + ((random 50) - (random 50)), 0];
};
BTC_mobile_marker =
{
	_var = _this select 0;
	_side = "";
	switch (true) do
	{
		case (BTC_side == west) : {_side = "BTC_mobile_west";};
		case (BTC_side == east) : {_side = "BTC_mobile_east";};
		case (BTC_side == guer) : {_side = "BTC_mobile_guer";};
	};
	while {true} do
	{
		_obj = objNull;
		while {isNull _obj} do 
		{
			{
				if (format ["%1",_x getVariable _side] == _var && Alive _x) then {_obj = _x;};
			} foreach vehicles;
			sleep 1;
		};
		deleteMarkerLocal format ["%1", _var];
		_marker = createmarkerLocal [format ["%1", _var], getPos _obj];
		format ["%1", _var] setmarkertypelocal "mil_dot";
		format ["%1", _var] setMarkerTextLocal format ["%1", _var];
		format ["%1", _var] setmarkerColorlocal "ColorGreen";
		format ["%1", _var] setMarkerSizeLocal [0.5, 0.5];
		hint format ["%1 is available!", _var];
		while {Alive _obj} do
		{
			format ["%1", _var] setMarkerPosLocal (getPos _obj);
			if (speed _obj < 2) then {format ["%1", _var] setMarkerTextLocal format ["%1 deployed", _var];format ["%1", _var] setmarkerColorlocal "ColorGreen";} else {format ["%1", _var] setMarkerTextLocal format ["%1 is moving", _var];format ["%1", _var] setmarkerColorlocal "ColorBlack";};
			sleep 1;
		};
		hint format ["%1 has been destroyed!", _var];
		format ["%1", _var] setMarkerTextLocal format ["%1 destroyed!", _var];
		format ["%1", _var] setmarkerColorlocal "ColorRed";
		if (BTC_mobile_respawn == 0) exitWith {};
	};
};
BTC_mobile_check =
{
	_var = str (_this select 0);
	_side = "";
	switch (true) do
	{
		case (BTC_side == west) : {_side = "BTC_mobile_west";};
		case (BTC_side == east) : {_side = "BTC_mobile_east";};
		case (BTC_side == guer) : {_side = "BTC_mobile_guer";};
	};
	_cond = false;
	{
		if ((typeName (_x getvariable _side)) == "STRING") then
		{
			if ((_x getvariable _side) == _var) then {_cond = true;};
		};
	} foreach vehicles;
	_cond
};
BTC_vehicle_mobile_respawn =
{
	_veh  = _this select 0;
	_var  = _this select 1;
	_set  = _this select 2;
	_type = typeOf _veh;
	_pos  = getPos _veh;
	_dir  = getDir _veh;
	waitUntil {sleep 1; !Alive _veh};
	_veh setVariable [_set,0,true];
	sleep BTC_mobile_respawn_time;
	_veh  = _type createVehicle _pos;
	_veh setDir _dir;
	_veh setVelocity [0, 0, -1];
	_veh setVariable [_set,_var,true];
	_resp = [_veh,_var,_set] spawn BTC_vehicle_mobile_respawn;
	_veh setpos _pos;
};
BTC_out_of_lifes =
{
	removeAllWeapons player;
	player enableSimulation false;
	titleText ["You have no more lifes", "BLACK FADED"];//BLACK FADED
	sleep 1;
	while {true} do
	{
		player enableSimulation false;
		player setpos [0,0,6000];
		player setVelocity [0,0,0];
		titleText ["You have no more lifes", "BLACK FADED"];
		sleep 1;
	};
};
