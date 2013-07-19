/*
	Script written by TeeTime dont remove this comment
*/
///modif siskojay team kkz//de 50 a 80 enlever//
//Functions
Tee_Server_Init = {
	"TW_Town_Taken_Server" addPublicVariableEventHandler {
		TW_Town_Taken_Server spawn Tee_Server_Town_CreateAIDef;
		TW_Town_Taken_Server spawn Tee_Server_Town_Repair;
	};
	"TW_Player_Kick" addPublicVariableEventHandler {TW_Player_Kick call Tee_Server_KickPlayer;};
	"TW_Mission_End" addPublicVariableEventHandler {
		if(TW_restart) then {
			[] spawn Tee_Server_Restart;
		} else {
			endMission "END1";
		};
	};
};



/*
	Init Variables and Values for choosen gamemode
*/
Tee_Server_Init_Values = {
	private ["_i","_value","_array"];
	
	//Towns
	_array = [];
	TW_Para_Towns = TW_Para_Towns min (count TW_TownArray);	//Catch wrong input
	for [{_i=0},{_i<TW_Para_Towns},{_i=_i+1}] do {
		_array = _array + [TW_TownArray select _i];
	};
	TW_TownArray = _array;
	
	//Mehr
	_array = [];
};



//Kick Player
Tee_Server_KickPlayer = {
	serverCommand format["#kick %1",call compile _this];
};



//Base
/*Tee_Server_Base_Set_Base = {
	private ["_pos","_sel_1","_sel_2"];
	
	//_pos = TW_BasePos_Array select (round(random (count TW_BasePos_Array - 1)));
TW_West_Respawn = "tw_west_respawn";
TW_East_Respawn = "tw_east_respawn";*/
	
	/*if((random 2) < 1) then {
		_sel_1 = 0;
		_sel_2 = 1;
	} else {
		_sel_1 = 1;
		_sel_2 = 0;
	};*/
	/*
	hq_west setPos (getMarkerPos (_pos select _sel_1));
	hq_west setDir 90;
	hq_west lock true;
	hq_west lockCargo true;
	if(isDedicated) then {diag_log format["Report: WestMarker %1 - WestHQPos %2",(getMarkerPos (_pos select _sel_1)),(getPos hq_west)];};
	
	hq_east setPos (getMarkerPos (_pos select _sel_2));
	hq_east setDir 90;
	hq_east lock true;
	hq_east lockCargo true;
	if(isDedicated) then {diag_log format["Report: EastMarker %1 - EastHQPos %2",(getMarkerPos (_pos select _sel_2)),(getPos hq_east)];};
	
	if(isDedicated) then {diag_log "Report: HQ Placed";};
};
*/


Tee_Server_Base_Build_West = {
	private ["_hq","_marker","_text","_actioncode"];

	_hq = hq_west;
	
	//Create Respawn
	_marker = CreateMarkerLocal [TW_West_Respawn, [((getPos west_shop_veh) select 0) + 5,((getPos west_shop_veh) select 1) -10,(getPos west_shop_veh) select 2]];		//TeeTimeTest	Marker ist Lokal
	//"respawn_west" setMarkerPos [((getPos _hq) select 0) + 5,(getPos _hq) select 1,(getPos _hq) select 2];
	
	if(isDedicated) then {diag_log format["Report: Respawn West Placed %1",getMarkerPos TW_West_Respawn];};
	
	//Set Veh Spawn
	west_shop_veh setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 10,(getPos _hq) select 2];
	"west_vehspawn" setMarkerPos [((getPos _hq) select 0) - 10,((getPos _hq) select 1),(getPos _hq) select 2];	//Nicht genutzt	
	
	//Set Weapon Shop
	west_shop_weapons setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 5,(getPos _hq) select 2];
	
	//Set AI Shop
	west_shop_ai setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) - 5,(getPos _hq) select 2];
	
	if(isDedicated) then {diag_log "Report: Westbase Build";};
};



Tee_Server_Base_Build_East = {
	private ["_hq","_marker","_text","_actioncode"];
	
	_hq = hq_east;
	
	//Create Respawn
	_marker = CreateMarkerLocal [TW_East_Respawn, [((getPos east_shop_veh) select 0) + 5,((getPos east_shop_veh) select 1) -10,(getPos east_shop_veh) select 2]];		//TeeTimeTest	Marker ist Lokal
	//"respawn_east" setMarkerPos [((getPos _hq) select 0) + 5,(getPos _hq) select 1,(getPos _hq) select 2];
	
	if(isDedicated) then {diag_log format["Report: Respawn East Placed %1",getMarkerPos TW_East_Respawn];};
		
	//Set Veh Spawn
	east_shop_veh setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 10,(getPos _hq) select 2];
	"east_vehspawn" setMarkerPos [((getPos _hq) select 0) - 10,((getPos _hq) select 1),(getPos _hq) select 2];	//Nicht genutzt
	
	//Set Weapon Shop
	east_shop_weapons setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 5,(getPos _hq) select 2];
		
	//Set AI Shop
	east_shop_ai setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) - 5,(getPos _hq) select 2];
	
	if(isDedicated) then {diag_log "Report: Eastbase Build";};
};


//********************************************
//Towns
//********************************************

Tee_Server_CreateTownMarker = {
	private ["_h","_object","_markername","_text","_marker"];
	{
		_object 	= _x select 0;
		
		//Make Object undestroyable
		["{this allowDamage false;}","BIS_fnc_spawn",_object,true] spawn BIS_fnc_MP;///////changement dernier maj
		//_object setVehicleInit "this allowDamage false;";
		//processInitCommands;
		
		//SetVariable
		_object setVariable ["TownSide", "civ", true];	//Owning side
		_object setVariable ["TownPoints", 100, true];	//Town Points
		_object setVariable ["TownDetected", [], true];	//Side who deteced the town
		//_object setVariable ["TownMarker", _marker, true];
		
	} forEach TW_TownArray;

	[] spawn {
		//Init Def
		{
			_object 	= _x select 0;
			_text		= _x select 2;
			if(!TW_HC_Activ) then {
				_h = [_object] spawn Tee_Server_Town_InitAIDef;
				waitUntil{scriptDone _h};
				diag_log format ["Report: HC Defense created for %1",_text];
				if(debug) then {player groupChat "AI Def Server Spawn";};
			};
		} forEach TW_TownArray;
	};
};



Tee_Server_Town_InitAIDef = {
	private ["_i","_object","_group","_unitarray","_unit","_numUnit"];	

	_object = _this select 0;
	_pos 	= getPos _object;
	
	//All Units in this array will be in the same group!
	_unitarray	= [ 9005, 9006, 9007 ];
	
	//Create Unit
	for [{_i=0},{_i<TW_AI_Def_lvl},{_i=_i+1}] do {

	//create civilian group
		_group	= createGroup civilian;

		_numUnit = 0 ;
		
		{
			_unit = [_group,_x call Tee_GetUnit_Class,_pos] call Tee_CreateUnit;
			//_unit addMagazines ["30Rnd_65x39_caseless_green", 10];
			//_unit addWeapon "arifle_Katiba_C_F";
			//skills unit
			
			//_unit setskill ["general",TW_Skill_AICiv];
			_unit setskill ["endurance",1];
			_unit setskill ["spotDistance",0.95];
			_unit setskill ["aimingAccuracy",0.15];
			_unit setskill ["spotTime",0.85];
			_unit setskill ["courage",0.80];
			_unit setskill ["commanding",1];
			_unit setskill ["aimingShake",0.15];
			_unit setskill ["aimingSpeed",0.65];
			//_unit setskill ["aimingShake",TW_Skill_AIOff];

			sleep 0.1;

			if (_numUnit == 0) then {_unit setskill ["commanding",1];};
		
			_numUnit = _numUnit + 1 ;

		} forEach _unitarray;

		//Patrols
		if(TW_AI_Patrols && _i != 0) then {
			[_group,_pos] call CT_AI_Addwaypoints;
		};

	};
};



/*
	Creates AI Defense for the owning side west/east
*/
Tee_Server_Town_CreateAIDef = {
	private ["_object","_side","_groupside","_group","_unitarray","_unit","_numUnit"];	

	//Messages
	if(TW_HC_Activ && isDedicated) exitWith {};
	if(isServer && isDedicated) then {diag_log "Report: Server Defense created for Captured Town";};
	if(TW_HC_Client) then {diag_log "Report: HC Defense created for Captured Town";};
	
	_object = _this select 0;
	_side 	= _this select 1;
	
	_pos 	= getPos _object;
	_numUnit = 0 ;
	
	if(_side == "west") then {
		_groupside	= west;
		//All Units in this array will be in the same group!
		_unitarray	= [
			7001,7002,7004
		];
	};
	
	if(_side == "east") then {
		_groupside	= east;
		//All Units in this array will be in the same group!
		_unitarray	= [
			6001,6005,6003
		];
	};
	
	//Create Unit
	for [{_i=0},{_i<TW_AI_Def_lvl},{_i=_i+1}] do {
		
		//Create new Group
		_group	= createGroup _groupside;
		
		//Create Units
		{
			_unit = [_group,_x call Tee_GetUnit_Class,_pos] call Tee_CreateUnit;
			
			//skills units
			_unit setskill ["general",TW_Skill_AIDef];
			_unit setskill ["endurance",1];
			_unit setskill ["spotDistance",1];
			//_unit setskill ["aimingShake",TW_Skill_AIDef];
			_skill = [
			"aimingAccuracy",
			"aimingShake",
			"aimingSpeed",
			//"endurance",
			//"spotDistance",
			"spotTime",
			"courage",
			"reloadSpeed",
			"commanding"
			//"general"
			];
				{
				_level = (TW_Skill_AIDef + random 0.1);
				_unit setskill [_x, _level];
				sleep 0.05;
				}foreach _skill;
			sleep 0.25;
			if (_numUnit == 0) then {_unit setskill ["commanding",1];};
			_numUnit = _numUnit + 1 ;
		} forEach _unitarray;
		_numUnit = 0 ;
		//Patrols
		if(TW_AI_Patrols && _i != 0) then {
			[_group,_pos] call CT_AI_Addwaypoints;
		};
		sleep 4;
	};	
};



/*
	Repairs a town after it has been taken by a side to reduce Lag
	Must be spawned
*/
Tee_Server_Town_Repair = {
	private ["_town","_objects"];	

	if(TW_HC_Activ && isDedicated) exitWith {};
	if(isDedicated) then {diag_log "Report: Server Town Repairing started";};
	if(TW_HC_Client) then {diag_log "Report: Town Repairing started";};
	
	_town = _this select 0;
	
	sleep 120;	//Wait 2 Minutes to let player leave the area
	
	_objects = (getPos _town) nearObjects ["Building",150];
	
	//Repair Towns
	{
		if(damage _x > 0) then {
			_x setDamage 0;
			sleep 5;
		};
	} forEach _objects;
};


//**********************************************
//Server Functions and Loops
//**********************************************


/*
	For a Restart without a Restart
*/
Tee_Server_Restart = {

	if(TW_Server_Restart) exitWith {};
	TW_Server_Restart = true;

	//Repair Everything
	{
		_x setDamage 0;
	} forEach ((getPos hq_west) nearObjects 5000);
	
	sleep 2;
	
	//Kill all Units
	{
		_x setDamage 1;
	} forEach allUnits;
	
	//Kill all Player
	{
		_x setDamage 1;
	} forEach playableUnits;

	//Vehicles
	{
		if(!(_x in _basicvehicles)) then {deleteVehicle _x;};
	} forEach vehicles;
	
	//Bodies
	{
		deleteVehicle _x;
	} forEach allDead;
	
	//Towns
	[] spawn Tee_Server_CreateTownMarker;

	//Base
	[] call Tee_Server_Base_Set_Base;
	[] call Tee_Server_Base_Build_West;
	[] call Tee_Server_Base_Build_East;
	
	TW_Server_Restart 	= false;
	TW_Mission_End 		= false;
	publicVariable "TW_Mission_End";
};



//Server Loops
Tee_Server_CleanUp = {
	private ["_i","_w","_basicvehicles","_shops","_shoploc","_wspawn_loc","_espawn_loc","_vehiclearray","_vehiclearraynew","_found"];
	if(isDedicated) then {diag_log "Report: CleanUp Started";};
	if(TW_HC_Client) then {diag_log "Report: HC Server Loop Started";};
	
	_i = 0;
	_basicvehicles 		= vehicles;	//List of all Vehicles at Missionstart
	_shops 				= [hq_west,west_shop_veh,west_shop_heli1,west_shop_weapons,west_shop_ai,hq_east,east_shop_veh,east_shop_weapons,east_shop_ai];
	_shoploc 			= [];
	_vehiclearray		= [];
	_vehiclearraynew 	= [];
	TW_Server_HQPos		= [getPos hq_west,getPos hq_east];	//Save HQ Pos for Noob Protection
	
	waitUntil {HQ_placed};
	//Save Shop Locations
	{
		_shoploc = _shoploc + [[_x,getPos _x]];
	} forEach _shops;

	//Clean
		if(_i >= 10) then {
			_i = 0;
			
			//Bodies
			{
				deleteVehicle _x;
			} forEach allDead;
	
			//Groups
			{
				if(count units _x == 0) then {
					deleteGroup _x;
				};
			} forEach allGroups;
	
			//Vehicles
			{
				if(! alive _x && !(_x in _basicvehicles)) then {deleteVehicle _x;};
			} forEach vehicles;
			
			//Inaktiv Vehicles
			_vehiclearray 		= _vehiclearraynew;
			_vehiclearraynew 	= [];
			{
				if(alive _x && count (crew _x) == 0 && !(_x in _basicvehicles)) then {
					_found = false;
					for [{_w=0},{_w<= count _vehiclearray},{_w=_w+1}] do {
						if(_x == ((_vehiclearray select _w) select 0)) then {
							if((getPos _x) distance ((_vehiclearray select _w) select 1) < 1) then {
								deleteVehicle _x;
							} else {
									_vehiclearraynew = _vehiclearraynew + [[_x,getPos _x]];
							};
							_found = true;	
						};
					};
					if(!_found) then {
						_vehiclearraynew = _vehiclearraynew + [[_x,getPos _x]];
					};
				};
			} forEach vehicles;
		};
		
	while {true} do {
	
			//Check Shops
		//	{
		//		if((_x select 0) distance (_x select 1) > 2) then {
		//			(_x select 0) setPos (_x select 1);
		//		};
		//	} forEach _shoploc;	
	
	
		//Check for Missionend
		if(time > (3600 * TW_roundtime)) then {
			TW_Mission_End = true;
			publicVariable "TW_Mission_End";
			if(TW_restart) then {
				TW_roundtime = TW_roundtime + TW_roundtime;
				[] spawn Tee_Server_Restart;
			} else {
				endMission "END1";
			};
		};
	

		//Check for HC
		if(time > 120) then {
			if(isPlayer TW_HC_ClientSlot) then {
				//TW_HC_Activ	= true;		//TeeTimeTest	mal deaktiviert
			} else {
				//TW_HC_Activ	= false;	//TeeTimeTest	mal deaktiviert
			};
		};
		
		
		//Check HQ Pos Anti Water Protection
		if(surfaceIsWater (getPos hq_west)) then {
			hq_west setPos (TW_Server_HQPos select 0);
			hq_west setDir 90;
			hq_west setFuel 0;
			hq_west lock true;
			
			if(alive (driver hq_west)) then {
				(driver hq_west) setDamage 1;
			};
		};
		if(surfaceIsWater (getPos hq_east)) then {
			hq_east setPos (TW_Server_HQPos select 1);
			hq_east setDir 90;
			hq_east setFuel 0;
			hq_east lock true;
			if(alive (driver hq_east)) then {
				(driver hq_east) setDamage 1;
			};
		};
	
	
		//Clean
		if(_i >= 10) then {
			_i = 0;
			
			//Bodies
			{
				deleteVehicle _x;
			} forEach allDead;
	
			//Groups
			{
				if(count units _x == 0) then {
					deleteGroup _x;
				};
			} forEach allGroups;
	
			//Vehicles
			{
				if(! alive _x && !(_x in _basicvehicles)) then {deleteVehicle _x;};
			} forEach vehicles;
			
			//Inaktiv Vehicles
			_vehiclearray 		= _vehiclearraynew;
			_vehiclearraynew 	= [];
			{
				if(alive _x && count (crew _x) == 0 && !(_x in _basicvehicles)) then {
					_found = false;
					for [{_w=0},{_w<= count _vehiclearray},{_w=_w+1}] do {
						if(_x == ((_vehiclearray select _w) select 0)) then {
							if((getPos _x) distance ((_vehiclearray select _w) select 1) < 1) then {
								deleteVehicle _x;
							} else {
									_vehiclearraynew = _vehiclearraynew + [[_x,getPos _x]];
							};
							_found = true;	
						};
					};
					if(!_found) then {
						_vehiclearraynew = _vehiclearraynew + [[_x,getPos _x]];
					};
				};
			} forEach vehicles;
		};
		
		
		//Report
		if(isDedicated) then {diag_log format ["Report: Server FPS %1",diag_fps];};
		if(TW_HC_Client) then {diag_log format ["Report: HC FPS %1",diag_fps];};
		
		
		//End
		_i = _i + 1;
		sleep 10;
	};
};
