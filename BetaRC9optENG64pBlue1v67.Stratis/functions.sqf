/*
	Script written by TeeTime dont remove this comment
*/
///modif siskojay team kkz//
//Functions

//Debug
Tee_Debug_Spawn = {

	//[] spawn Tee_Player_TK_Punish;

/*
	_mags = magazines player;
	player groupchat str _mags;
	diag_log str _mags;
*/
	//call Tee_Base_Set_Base;
	//call Tee_AttackTown;
	//_marker = createMarker ["Test", getPos player];

	//[] call Tee_CreateTownMarker;
	// ServicePoint Building : Military Cargo House V1     (Land_Cargo_House_V1_F)
	// Baracks         : Military Cargo HQ V1     (Land_Cargo_HQ_V1_F)
	// ComandPost         : Military Cargo OP V1     (Land_Cargo_Patrol_V1_F)!?! nicht sicher
	//_veh = createVehicle ["Land_Cargo_HQ_V1_F",getPos player,[],0,""];
	
	Tee_Konto 			= 100000;

};



Tee_Debug_Spawn_Weapon = {

	player globalChat str TW_HC_ID;

	//[base_1,base_2] call Tee_Marker_ConnectMarker;
	//[base_2,base_4] call Tee_Marker_ConnectMarker;



	//[player] call Tee_Town_CreateAIDef;
	
	//_mags = weapons player;
	//player groupchat str _mags;
	//diag_log str _mags;
	
	//player addMagazine "30Rnd_65x39_caseless_green";
	//player addWeapon "arifle_Khaybar_ACO_point_F";
};



Tee_Debug_Teleport = {
	onMapSingleClick "(vehicle player) setPos _pos;";
};


//****************************************
//Basic
//****************************************


Tee_Init_Client = {

	//Variables
	if(playerside == west) 	then { 
		TW_playerside = "west"; TW_playerside_colour = "ColorBlue";
	};
	if(playerside == east) 	then { 
		TW_playerside = "east"; TW_playerside_colour = "ColorRed";
	};

	//if(player in TW_westplayer_array) then { TW_playerside = "west"; TW_playerside_colour = "ColorBlue";};		//For Later
	//if(player in TW_eastplayer_array) then { TW_playerside = "east"; TW_playerside_colour = "ColorRed";};			//For Later

	
	//Eventhandler
	player addEventHandler ["killed", "_this call Tee_Player_Killed;"];
	
	"TW_Vote_Start" addPublicVariableEventHandler {TW_Vote_Start spawn Tee_Vote_Started;};
	
	"TW_Player_Killed" addPublicVariableEventHandler {TW_Player_Killed call Tee_Player_Killed_Pub;};
	
	"TW_AI_Killed" addPublicVariableEventHandler {TW_AI_Killed call Tee_AI_Killed_Pub;};
	
	"TW_Town_Taken" addPublicVariableEventHandler {TW_Town_Taken call Tee_Town_Caputred_2;};
	
	"TW_Mission_End" addPublicVariableEventHandler {
		if(TW_restart) then {
			[] spawn Tee_Client_Restart;
		} else {
			endMission "END1";
		};
	};
	
	
	//Functions
	[] call Tee_Grp_Init;
};



/*
	Init Variables and Values for choosen gamemode
*/
Tee_Player_Init_Values = {
	private ["_i","_value","_array"];


	//reset team_member
	Team_Member = true;	
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



Tee_Client_Restart = {
	titleText[localize "STRS_restart", "PLAIN DOWN"];	//Msg
	
	sleep 15;
	Tee_Konto = 1000;
	[] spawn Tee_Client_Base_Build_West;	//TeeTimeTest
	[] spawn Tee_Client_Base_Build_East;	//TeeTimeTest
	
	titleText[localize "STRS_restart2", "PLAIN DOWN"];	//Msg
	
	TW_Mission_End = false;
};



//*******************************
//Savesystem	SS
//*******************************

Tee_SS_Gear_Save = {
	private ["_array","_item","_geararray"];
	
	_item		= "";
	_array 		= [];
	_geararray	= [];
	
	//Clothes
		//Save Uniform
		_item 	= uniform player;
		_geararray 	= _geararray + [_item];
	
		_array 	= uniformItems player;
		_geararray 	= _geararray + [_array];
	
	
		//Save Vest
		_item 		= vest player;
		_geararray 	= _geararray + [_item];
	
		_array 		= vestItems player;
		_geararray 	= _geararray + [_array];

		
		//Save Headgear
		_item 		= headgear player;
		_geararray 	= _geararray + [_item];	
		
		
		//Save Goggles
		_item 		= goggles player;
		_geararray 	= _geararray + [_item];
		
		
		//Save Backpack
		_item 		= backpack player;
		_geararray 	= _geararray + [_item];
		
		_array 		= backpackItems player;
		_geararray 	= _geararray + [_array];
	
	
	//Weapon Modifications
		//Weapon Modi Prim
		_array = primaryWeaponItems player;
		_geararray 	= _geararray + [_array];
		
		//Weapon Modi Sec
		_array = secondaryWeaponItems player;
		_geararray 	= _geararray + [_array];
		
		//Weapon Modi Hand
		_array = handgunItems player;
		_geararray 	= _geararray + [_array];
	
	
	//Save Ammunition
	_array		= magazines player;
	_geararray 	= _geararray + [_array];
	
	//Save Weapons
	_array = weapons player;
	_geararray = _geararray + [_array];
	
	Tee_Save_GearArray = _geararray;
	
	titleText[localize "STRS_SS_Save_Geardone", "PLAIN DOWN"];	//Msg
	
	if(debug) then {
		player groupchat str _geararray;	//Msg
	};
	
	
	/*
	geararray = [
		uniform,uniformitems,vest,vestitems,headgear,goggles,backpack,backpackitems
		pWItems,sWItems,hGItem
		weapon,ammo
	];
	*/
	
};



Tee_SS_Gear_Load = {
	private ["_uniform","_uniformitems","_vest","_vestitems","_headgear","_goggles","_backpack","_backpackitems","_wepmodprim","_wepmodsec","_wepmodhand","_magarray","_weaparray"];
	
	//Check
	if(count Tee_Save_GearArray == 0) exitWith {};
	
	_uniform		= Tee_Save_GearArray select 0;
	_uniformitems	= Tee_Save_GearArray select 1;
	_vest			= Tee_Save_GearArray select 2;
	_vestitems		= Tee_Save_GearArray select 3;
	_headgear		= Tee_Save_GearArray select 4;
	_goggles		= Tee_Save_GearArray select 5;
	_backpack		= Tee_Save_GearArray select 6;
	_backpackitems	= Tee_Save_GearArray select 7;
	
	_wepmodprim		= Tee_Save_GearArray select 8;
	_wepmodsec		= Tee_Save_GearArray select 9;
	_wepmodhand		= Tee_Save_GearArray select 10;
	
	_magarray 		= Tee_Save_GearArray select 11;
	_weaparray		= Tee_Save_GearArray select 12;
	
	//Clean Player
	removeAllWeapons player;
	{
		player removeMagazines _x;
	} forEach magazines player;
	
	//Uniform
	removeUniform player;

	//Vest
	removeVest player;
	
	//Headgear
	removeHeadgear player;
	
	//Goggles
	removeGoggles player;
	
	//Backpack
	removeBackpack player;
	
	
	
	
	//Load Clothes
	if(_uniform != "") then {
		player addUniform _uniform;
	};
	if(_vest != "") then {
		player addVest _vest;
	};
	if(_headgear != "") then {
		player addHeadgear _headgear;
	};
	if(_goggles != "") then {
		player addGoggles _goggles;
	};
	if(_backpack != "") then {
		player addBackpack _backpack;
		clearAllItemsFromBackpack player;
	};
	
	
	//Load Items Uniform
	{
		if(_x != "") then {
			player addItem _x;
		};
	} forEach _uniformitems;
	
	//Load Items Vest
	{
		if(_x != "") then {
			player addItem _x;
		};
	} forEach _vestitems;
	
	//Load Items BackPack
	{
		if(_x != "") then {
			player addItem _x;
		};
	} forEach _backpackitems;
	
	//Load Ammunition
	{
		if(_x != "") then {
			player addMagazine _x;
		};
	} forEach _magarray;
	
	//Load Weapons
	{
		if(_x != "") then {
			player addWeapon _x;
		};
	} forEach _weaparray;
	
	//Load Weapon Modi Prim
	{
		player removePrimaryWeaponItem _x;
	} forEach (primaryWeaponItems player);
	{
		if(_x != "") then {
			player addPrimaryWeaponItem _x;
		};
	} forEach _wepmodprim;
	
	//Load Weapon Modi Sec
	{
		if(_x != "") then {
			player addSecondaryWeaponItem _x;
		};
	} forEach _wepmodsec;
	
	//Load Weapon Modi Hand
	{
		if(_x != "") then {
			player addHandgunItem _x;
		};
	} forEach _wepmodhand;
	
	
	if(debug) then {
		player groupchat "Gear loaded";	//Msg
	};
};



//*******************************
//Voting
//*******************************

/*
	Called by player who init the Vote
*/
Tee_Vote_Start = {
	private ["_kind","_text","_result","_return"];

	_kind 	= _this select 0;	//What kind of Vote is it	can be "HQ",
	
	//Check and activate Vote
	if(TW_Voting) exitWith {titleText [ localize "STRS_Vote_Running", "PLAIN DOWN"];};	//Msg
	TW_Voting		= true;
	
	//Reset
	_return			= false;
	TW_Vote_Result 	= _return;
	
	//Own Vote
	TW_Vote_Votes = [1,0];
	publicVariable "TW_Vote_Votes";
	TW_Vote_Start = [TW_playerside,_kind,name player];
	publicVariable "TW_Vote_Start";
	
	_text = format [localize "STRS_Vote_Started",TW_Vote_Time];
	titleText [_text, "PLAIN DOWN"];	//Msg
	
	if(debug) then {TW_Vote_Start spawn Tee_Vote_Started;};
	
	sleep TW_Vote_Time;
	
	_text = format [localize "STRS_Vote_Result",TW_Vote_Votes select 0,TW_Vote_Votes select 1];
	titleText[_text, "PLAIN DOWN"];	//Msg
	
	
	_return = if((TW_Vote_Votes select 0) > (TW_Vote_Votes select 1)) then {true} else {false};
	
	TW_Vote_Result 	= _return;
	TW_Voting		= false;
};



/*
	Called on all players
*/
Tee_Vote_Started = {
	private ["_side","_kind","_name","_text","_actioncode","_action","_actionarray"];

	_side	= _this select 0;	//Side who is allowed to vote
	_kind 	= _this select 1;	//What kind of Vote is it
	_name	= _this select 2;
	
	if(_side != TW_playerside) exitWith {};
	if(TW_Voting) exitWith {};
	
	TW_Voting = true;
	
	if(_kind == "HQ") then {
		_text = format [localize "STRS_Vote_StartInformation",_name];
	};
	
	hintSilent _text; //Msg
	
	
	_text			= localize "STRS_Vote_Yes";
	_actioncode		= format ["[%1] call Tee_Vote_Vote;",true];
	_action 		= player addAction [_text, AddActionCode,_actioncode];
	TW_Vote_Actions = TW_Vote_Actions + [_action];
	
	_text			= localize "STRS_Vote_No";
	_actioncode		= format ["[%1] call Tee_Vote_Vote;",false];
	_action 		= player addAction [_text, AddActionCode,_actioncode];
	TW_Vote_Actions = TW_Vote_Actions + [_action];
	
};



/*
	Vote
*/
Tee_Vote_Vote = {
	if(_this select 0) then {
		TW_Vote_Votes = [(TW_Vote_Votes select 0) + 1,(TW_Vote_Votes select 1)];
	} else {
		TW_Vote_Votes = [(TW_Vote_Votes select 0),(TW_Vote_Votes select 1) + 1];	
	};
	publicVariable "TW_Vote_Votes";
	
	{
		player removeAction _x;
	} forEach TW_Vote_Actions;
	
	TW_Voting		= false;
	TW_Vote_Actions = [];
};



//*******************************
//Player
//*******************************


Tee_SetPlayer = {
	waitUntil {HQ_placed};
	waitUntil {TW_HQ_Placed_Client};
	waitUntil {alive player};
	if(TW_playerside == "west") then {player setPos (getMarkerPos TW_West_Respawn);};
	if(TW_playerside == "east") then {player setPos (getMarkerPos TW_East_Respawn);};
	
	//check
	sleep 2;
	if(TW_playerside == "west" && player distance hq_west > 10) then {player setPos (getMarkerPos TW_West_Respawn);};
	if(TW_playerside == "east" && player distance hq_east > 10) then {player setPos (getMarkerPos TW_East_Respawn);};
	
	//Make sure that leader is a player		muss für player squads angepasst werden	TeeTimeTest
	if(! isPlayer(leader (group (vehicle player)))) then {
		group player selectLeader player;
	};
	
	player addRating 40000;
	
	//Welcome Msg
	sleep 20;
	titleText[localize "STRS_welcome_1", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_2", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_3", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_4", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_5", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_6", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_7", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_8", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_9", "PLAIN DOWN"];	//Msg
	sleep 5;
	titleText[localize "STRS_welcome_end", "PLAIN DOWN"];	//Msg
};



//Called on killed Client
Tee_Player_Killed = {
	private ["_victim","_killer","_side","_pos"];
	
	_victim = _this select 0;
	_killer = _this select 1;
	
	_side	= playerSide;		//TeeTimeTest kann im Moment nur auf Clients ausgeführt werden!
	_pos	= getPos _victim;
	
	if(isPlayer _killer) then {
		TW_Player_Killed = [_victim,_killer,_side,_pos];
		publicVariable "TW_Player_Killed";
	};
	
	//For selfhosted Missions
	if(isServer && isPlayer _killer) then {
		TW_Player_Killed call Tee_Player_Killed_Pub;
	};
};



//Called on all Clients
Tee_Player_Killed_Pub = {
	private ["_victim","_killer","_side","_text"];
	
	_victim = _this select 0;
	_killer = _this select 1;
	_side	= _this select 2;
	
	//Bonus
	if(player == _killer && playerside != _side) then {
		Tee_Konto = Tee_Konto + Tee_Money_Kill_Bonus;
		player groupchat format [localize "STRS_kill_bonus",Tee_Money_Kill_Bonus,(name _victim)]; 	//Msg
	};
	
	//Punish
	if(player == _killer && playerside == _side && _killer != _victim) then {
		//Punish
		Tee_Money_TK_Punish call Tee_Money_Substract;
		_text = format [localize "STRS_kill_TK_punish",Tee_Money_TK_Punish];
		titleText[_text, "PLAIN DOWN"];	//Msg
		
		//HQ
		if((player distance hq_west < 50 && TW_playerside == "west") or (player distance hq_east < 50 && TW_playerside == "east")) then {
			TW_TK_Counter = TW_TK_Counter + 1;	//Double Punish for Base TK
			player setDamage 1;
			titleText[localize "STRS_kill_TK_punishbase", "PLAIN DOWN"];	//Msg
		};
		
		//Kick
		TW_TK_Counter = TW_TK_Counter + 1;
		if((TW_TK_Counter >= 3) && !Team_Member)then {
			[] spawn Tee_Player_TK_Punish;
			TW_TK_Counter = 0;
			TW_Player_Kick = getPlayerUID player;
			publicVariable "TW_Player_Kick";		
		};
	};
};



//Punish Player for TK
Tee_Player_TK_Punish = {
	private ["_i","_pos"];
	
	_pos = getPos player;
	
	titleText[localize "STRS_kill_TK_punish_ultiamte", "PLAIN DOWN"];	//Msg
	
	for [{_i=0},{_i<300},{_i=_i+30}] do {
		player setPos [0,0,5];
		titleText[localize "STRS_kill_TK_punish_ultiamte2", "PLAIN DOWN"];	//Msg
		sleep 30;
	};
	
	player setPos _pos;
};



/*
	Respawn
*/
Tee_Player_Respawn = {
	private ["_i"];
	
	openMap [true, true];
	onMapSingleClick "_pos call Tee_Player_Respawn_Choose;";
	
	player groupchat localize "STRS_spawn_choosemsg";	//Msg
	player groupchat localize "STRS_spawn_choosemsg2";	//Msg
	
	//Group
	if(! isPlayer(leader (group (vehicle player)))) then {
		group player selectLeader player;
	};
	
	//Add Rank
	player addRating 40000;
	
	//Space for Weapon Loadign etc

	[player,loadout] spawn setLoadout;
};



/*
	Respawn Choose
*/
Tee_Player_Respawn_Choose = {
	private ["_pos","_found","_base","_basefixe","_object","_text"];
	
	_pos 	= _this;
	_found	= false;	//Will be set to true if a valid respawn has been choosed
	
	 if(TW_playerside == "west") then {_base = (getMarkerPos TW_West_Respawn);};
	if(TW_playerside == "east") then {_base = (getMarkerPos TW_East_Respawn);};
	/////test siskojay respawn base fixe////////////////////
	//if(TW_playerside == "west") then {_base = (getMarkerPos TW_West_Respawn_2);};
	//if(TW_playerside == "east") then {_base = (getMarkerPos TW_East_Respawn_2);};
	
	//Base
	if(_pos distance _base <= 250) exitWith {
			onMapSingleClick "";
			player setPos _base;
			openMap [false, false];
			_found	= true;
	};
	
	//Towns
	{
		_object 	= _x select 0;
		//_markername = _x select 1;
		_text		= _x select 2;
		
		if(_pos distance _object <= 250 && ((_object getVariable "TownSide") == TW_playerside) && ((_object getVariable "TownPoints") >= 100)) exitWith {
			onMapSingleClick "";
			player setPos (getPos _object);
			openMap [false, false];
			_found	= true;
		};		
	} forEach TW_TownArray;
	
	//Message
	if(!_found) then {
		player groupchat localize "STRS_spawn_choosemsg2";	//Msg
	};
};


//*******************************************
//Money
//*******************************************

Tee_ShowMoney = {
	hintSilent format [localize "STRS_Konto",Tee_Konto];	//Msg
};


Tee_Money_Substract = {
	if(Tee_Konto > _this) then {
		Tee_Konto = Tee_Konto - _this;
	} else {
		Tee_Konto = 0;
	};
};



Tee_MoneyLoop = {
	private ["_i","_count","_enemycount"];
	while{true} do {
		sleep 60;
		_i			= 0;
		_count 		= 0;
		_enemycount	= 0;
		
		//Basic
		Tee_Konto = Tee_Konto + Tee_Money_Min;
		//Towns
		{
			_object = _x select 0;
			if(TW_playerside == _object getVariable "TownSide") then {
				Tee_Konto = Tee_Konto + Tee_Money_Town;
				_count = _count + 1;
			} else {
				if("civ" != _object getVariable "TownSide") then {
					_enemycount = _enemycount + 1;
				};
			};	
		} forEach TW_TownArray;
		
		//TK Counter Reduce
		if(_i >= 10) then {
			TW_TK_Counter = TW_TK_Counter - 1;
			_i = 0;
		};
		
		//End Mission Loser
		if(_enemycount == count TW_TownArray && !TW_Mission_End) exitWith {
			TW_Mission_End = true;
			publicVariable "TW_Mission_End";
		};
		
		//End Mission Winner
		if(_count == count TW_TownArray && !TW_Mission_End) exitWith {
			TW_Mission_End = true;
			publicVariable "TW_Mission_End";
		};
		
		_i = _i + 1;
	};
};



//******************************************
//Base
//******************************************


Tee_Base_Create_Marker = {
	private ["_marker","_name"];
	
	waitUntil {HQ_placed};
	//West
	if(TW_playerside == "west") then {
		//Create Respawn
		_marker = CreateMarkerLocal [TW_West_Respawn, [((getPos west_shop_veh) select 0) + 20,((getPos west_shop_veh) select 1) -10,(getPos west_shop_veh) select 2]];		//TeeTimeTest	Marker ist Lokal
	
		//HQ
		_marker = CreateMarkerLocal [TW_West_BaseMarker, position hq_west];
		_marker setMarkerTypeLocal "flag_NATO";
		
		//Shops
		//Vehicle
		//_name = format ["sh_m_%1_%2",floor(time),floor(random(1000))];
		_marker = CreateMarkerLocal [TW_West_ShopMarker_V, getPos west_shop_veh];
		_marker setMarkerShapeLocal "Icon";
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerTextLocal "Vehicle";
		
		
		//Weapon
		//_name = format ["sh_m_%1_%2",floor(time),floor(random(1000))];
		_marker = CreateMarkerLocal [TW_West_ShopMarker_G, getPos west_shop_weapons];
		_marker setMarkerShapeLocal "Icon";
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerTextLocal "Armory";
		
		//AI
		//_name = format ["sh_m_%1_%2",floor(time),floor(random(1000))];
		_marker = CreateMarkerLocal [TW_West_ShopMarker_AI, getPos west_shop_ai];
		_marker setMarkerShapeLocal "Icon";
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerTextLocal "Barracks";
			
	};
	
	//East
	if(TW_playerside == "east") then {
		//Create Respawn
		_marker = CreateMarkerLocal [TW_East_Respawn, [((getPos east_shop_veh) select 0) + 5,((getPos east_shop_veh) select 1) -10,(getPos east_shop_veh) select 2]];		//TeeTimeTest	Marker ist Lokal
	
		_marker = CreateMarkerLocal [TW_East_BaseMarker, position hq_east];
		
		
		//Shops
		//Vehicle
		//_name = format ["sh_m_%1_%2",floor(time),floor(random(1000))];
		_marker = CreateMarkerLocal [TW_East_ShopMarker_V, getPos east_shop_veh];
		_marker setMarkerShapeLocal "Icon";
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerTextLocal "Vehicle";
		
		
		//Weapon
		//_name = format ["sh_m_%1_%2",floor(time),floor(random(1000))];
		_marker = CreateMarkerLocal [TW_East_ShopMarker_G, getPos east_shop_weapons];
		_marker setMarkerShapeLocal "Icon";
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerTextLocal "Armory";
		
		//AI
		//_name = format ["sh_m_%1_%2",floor(time),floor(random(1000))];
		_marker = CreateMarkerLocal [TW_East_ShopMarker_AI, getPos east_shop_ai];
		_marker setMarkerShapeLocal "Icon";
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerTextLocal "Barracks";
	};
	
	TW_HQ_Placed_Client = true;
};



Tee_Client_Base_Build_West = {
	private ["_hq","_marker"];

	_hq = hq_west;
	
	//Set Respawn
	TW_West_Respawn setMarkerPosLocal [((getPos west_shop_veh) select 0) + 5,((getPos west_shop_veh) select 1) - 10,(getPos west_shop_veh) select 2];	//TeeTimeTest	Marker ist Lokal
		
	//Set Veh Spawn
	west_shop_veh setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 20,(getPos _hq) select 2];
	"west_vehspawn" setMarkerPos [((getPos _hq) select 0) - 10,((getPos _hq) select 1),(getPos _hq) select 2];	//Nicht genutzt	
	
	//Set Weapon Shop
	west_shop_weapons setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 5,(getPos _hq) select 2];
	
	//Set AI Shop
	west_shop_ai setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) - 10,(getPos _hq) select 2];
};




Tee_Client_Base_Build_East = {
	private ["_hq","_marker"];
	
	_hq = hq_east;

	//Set Respawn
	TW_East_Respawn setMarkerPosLocal [((getPos east_shop_veh) select 0) + 5,((getPos east_shop_veh) select 1) - 10,(getPos east_shop_veh) select 2];	//TeeTimeTest	Marker ist Lokal
	
	//Set Veh Spawn
	east_shop_veh setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 10,(getPos _hq) select 2];
	"east_vehspawn" setMarkerPos [((getPos _hq) select 0) - 10,((getPos _hq) select 1),(getPos _hq) select 2];	//Nicht genutzt
	
	//Set Weapon Shop
	east_shop_weapons setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) + 5,(getPos _hq) select 2];
		
	//Set AI Shop
	east_shop_ai setPosATL [(getPos _hq) select 0,((getPos _hq) select 1) - 5,(getPos _hq) select 2];
};



//Mobilze HQ
Tee_Client_Base_DeMobHQ = {
	private ["_hq"];
	
	if(TW_playerside == "west") then {
		_hq = hq_west;
	};
	if(TW_playerside == "east") then {
		_hq = hq_east;
		
	};
	
	//Start Voting
	["HQ"] spawn Tee_Vote_Start;
	sleep (TW_Vote_Time + 2);
	
	if(!TW_Vote_Result) exitWith {};	//Exit if Voting failed
	
	//Mob HQ
	player moveInDriver _hq;
	_hq setFuel 1;
	_hq lock false;
	
	
	if(TW_playerside == "west") then {
		//[] spawn Tee_Client_Base_Build_West;
	};
	if(TW_playerside == "east") then {
		//[] spawn Tee_Client_Base_Build_East;
	};	
};



//Build HQ
Tee_Client_Base_HQ_setUp = {
	private ["_hq","_exit","_text"];
	
	if(TW_playerside == "west") then {
		_hq = hq_west;
	};
	if(TW_playerside == "east") then {
		_hq = hq_east;
		
	};
	
	if(player != (driver _hq)) exitWith {};

	//Check Towns
	_exit = false;
	{
			if(_hq distance (_x select 0) < TW_Base_TownProtection) exitWith {
				_exit = true;
			};

	} forEach TW_TownArray;
	
	if(_exit) exitWith {
		_text = format [localize "STRS_hq_towntoclose",TW_Base_TownProtection];
		titleText[_text, "PLAIN DOWN"];	//Msg
	};
	
	//Set HQ
	_hq setDir 90;
	moveOut player;
	_hq setFuel 0;
	_hq lock true;

	
	if(TW_playerside == "west") then {
		[] spawn Tee_Client_Base_Build_West;
	};
	if(TW_playerside == "east") then {
		[] spawn Tee_Client_Base_Build_East;
	};	
};



//*************************************************
//Towns
//*************************************************


Tee_Client_CreateTownMarker = {
	private ["_object","_markername","_text","_marker"];	
	{
		_object 	= _x select 0;
		_markername = _x select 1;
		_text		= _x select 2;
		
		//Create Marker
		_marker = CreateMarkerLocal [_markername, position _object];
		_marker setMarkerShapeLocal "Icon"; 
		_marker setMarkerTypeLocal "mil_circle";
		_marker setMarkerTextLocal format["%1 100/100",_text];
		_marker setMarkerColorLocal "ColorBlack";
		
	} forEach TW_TownArray;
};



/*
	Called on all Client who took the last points
*/
Tee_Town_Caputred = {
	private ["_object","_side"];	

	_object = _this select 0;
	
	_side	= TW_playerside;

	TW_Town_Taken = [_object,_side];
	publicVariable "TW_Town_Taken";
	TW_Town_Taken_Server = [_object,_side];
	publicVariable "TW_Town_Taken_Server";
	
	if(isServer && !isDedicated) then {
		TW_Town_Taken_Server spawn Tee_Server_Town_CreateAIDef;
		TW_Town_Taken_Server spawn Tee_Server_Town_Repair;
	};
};



/*
	Called on all Clients when a Town got captured
*/
Tee_Town_Caputred_2 = {
	private ["_object","_side"];	

	_object = _this select 0;
	_side	= _this select 1;
	
	if(player distance _object <= TW_Town_CapDis && _side == TW_playerside) then {
		Tee_Konto = Tee_Konto + Tee_Money_TownCap;
						
		_text = format [localize "STRS_town_takenbonus",Tee_Money_TownCap];
		titleText[_text, "PLAIN DOWN"];	//Msg
	};
};



Tee_AttackTown = {
	private ["_object","_unitcount","_name","_points","_marker","_text","_detected"];
	while{true} do {
	
		waitUntil{alive player};
		
		{
			_object = _x select 0;
			_marker = _x select 1;
			_name 	= _x select 2;
			
			if(player distance _object <= TW_Town_CapDis) then {
				_points = _object getVariable "TownPoints";
			
				if(TW_playerside != _object getVariable "TownSide") then {
					
					//Check if town can be capted in strategic mode
					if(!([_object,TW_playerside] call Tee_Stra_TowncanCap_Basic) && TW_Strategic_Street) exitWith {
						_text = format [localize "STRS_town_cantcapstrat"];
						titleText[_text, "PLAIN DOWN"];	//Msg
					};
					
					//Count near AI units
					_unitcount = 0;
					{
						if(_x distance _object <= TW_Town_CapDis) then {
							_unitcount = _unitcount + 1;
						};
					} forEach (units (group player));
					
					_points = _points - (10 * _unitcount);
					
					if(debug) then {
						_points = _points - 20;
					};
					
					if(_points <= 0) then {
						_object setVariable ["TownSide",TW_playerside , true];
						_object setVariable ["TownPoints", 100, true];
						//_marker = _object getVariable "TownMarker";
						
						//TeeTimeTest	gedoppelt
						_marker setMarkerColorLocal TW_playerside_colour;
						_marker setMarkerTextLocal format["%1 100/100",_name];
					
						Tee_Konto = Tee_Konto + Tee_Money_TownCap;
						
						_text = format [localize "STRS_town_takenbonus",Tee_Money_TownCap];
						titleText[_text, "PLAIN DOWN"];	//Msg

						//Create AI Def
						[_object] call Tee_Town_Caputred;
					} else {
						_object setVariable ["TownPoints", _points, true];
						_marker setMarkerTextLocal format["%1 %2/100",_name,_points];
					
						_text = format [localize "STRS_town_points",_points];
						titleText[_text, "PLAIN DOWN"];	//Msg
					};
				} else {
					if(_points < 100) then {
						_points = _points + 10;
						_object setVariable ["TownPoints", _points, true];
					};
				};
			} else {
				//Scout Town
				_detected = _object getVariable "TownDetected";
				if( !(TW_playerside in _detected) && (player distance _object <= TW_Town_DecDis) && !TW_Para_satintel) then {
					
					Tee_Konto = Tee_Konto + Tee_Money_TownScout;
					_text = format [localize "STRS_town_scoutbonus",Tee_Money_TownScout];
					titleText[_text, "PLAIN DOWN"];	//Msg
	
					_detected = _detected + [TW_playerside];
					_object setVariable ["TownDetected", _detected , true];
				};
			};	
		} forEach TW_TownArray;
		
		sleep 30;
	};
};



//**********************************************************
//Strategic
//**********************************************************



/*
	Can the given Town be captured?
*/
Tee_Stra_TowncanCap = {
	private ["_object","_side","_array"];	

	_object = _this select 0;	//Town
	_side	= _this select 1;	//TW_playerside

	_array	= [];
	_return	= false;
	
	//Get Street Array
	{
		if(_x select 0 == _object) exitWith {_array = _x select 1;};
	} forEach TW_Town_StreetArray;
	
	//Check
	{
		if(_x getVariable "TownSide" == _side) exitWith { _return = true };
	} forEach _array;
	
	_return
};



/*
	Can the given Town be captured contains basic checks too
*/
Tee_Stra_TowncanCap_Basic = {
	private ["_object","_side","_town","_return"];
	
	_object = _this select 0;	//Town
	_side	= _this select 1;	//TW_playerside

	_return	= false;
	
	
	//Check if First Town
	_return	= true;
	{
		_town = _x select 0;
		if(_side == _town getVariable "TownSide") then {
			_return	= false;
		};
	} forEach TW_TownArray;
	
	
	//Normal Check
	if(!_return) then {
		{
			_return = [_object,_side] call Tee_Stra_TowncanCap;
		} forEach TW_TownArray;
	};
	
	
	//Place for more Checks
	
	_return
};



//**********************************************************
//Support and Supply Functions
//**********************************************************


/*
	Repair Function
	Must be spawned
*/
Tee_Sup_Repair = {
	private ["_i","_vehicle","_pos","_damage","_text"];	

	_vehicle = vehicle player;
	_pos	= getPos _vehicle;
	_damage = getDammage _vehicle;
	
	if(_damage == 0) exitWith {
		titleText[localize "STRS_repair_cant", "PLAIN DOWN"];	//Msg
	};
	
	if(Tee_Konto < TW_Repair_Cost) exitWith {
		titleText[localize "STRS_repair_nomoney", "PLAIN DOWN"];	//Msg
	};
	
	Tee_Konto = Tee_Konto - TW_Repair_Cost;
	_vehicle engineOn false;
	
	_text = format [localize "STRS_repair_started", TW_Repair_Time];
	titleText[_text, "PLAIN DOWN"];	//Msg
	
	for [{_i=0},{_i< TW_Repair_Time},{_i=_i+5}] do {
		sleep 5;

		if(getPos _vehicle distance _pos > 1) exitWith {
			titleText[localize "STRS_repair_aborted", "PLAIN DOWN"];	//Msg
		};
		
		_vehicle setDammage (getDammage _vehicle - (_damage / (TW_Repair_Time / 5))); 
		titleText[localize "STRS_repair_msg", "PLAIN DOWN"];	//Msg
	};
	
	_vehicle setDammage 0;
	titleText[localize "STRS_repair_end", "PLAIN DOWN"];	//Msg
};



/*
	Refuel Function
	Must be spawned
*/
Tee_Sup_Refuel = {
	private ["_i","_vehicle","_pos"];	

	_vehicle = vehicle player;
	_pos	= getPos _vehicle;
	
	if(fuel _vehicle == 1) exitWith {
		titleText[localize "STRS_refuel_full", "PLAIN DOWN"];	//Msg
	};
	
	if(Tee_Konto < TW_Sup_Fuel_Cost) exitWith {
		titleText[localize "STRS_refuel_nomoney", "PLAIN DOWN"];	//Msg
	};
	
	Tee_Konto = Tee_Konto - TW_Sup_Fuel_Cost;
	_vehicle engineOn false;
	
	titleText[localize "STRS_refuel_started", "PLAIN DOWN"];	//Msg
	
	while {fuel _vehicle < 1} do {
		sleep TW_Sup_Fuel_Time;

		if(getPos _vehicle distance _pos > 1) exitWith {
			titleText[localize "STRS_refuel_aborted", "PLAIN DOWN"];	//Msg
		};
		
		_vehicle setFuel ((fuel _vehicle + 0.1) min 1);
		titleText[localize "STRS_refuel_status", "PLAIN DOWN"];	//Msg
	};

	titleText[localize "STRS_refuel_end", "PLAIN DOWN"];	//Msg	
};



/*
	Reammo Function
	Must be spawned
	
	
*/
Tee_Sup_Reammo = {
	private ["_i","_vehicle","_pos","_text"];	

	_vehicle = vehicle player;
	_pos	= getPos _vehicle;
	
	if(Tee_Konto < TW_Sup_Reammo_Cost) exitWith {
		titleText[localize "STRS_ammo_nomoney", "PLAIN DOWN"];	//Msg
	};
	
	Tee_Konto = Tee_Konto - TW_Sup_Reammo_Cost;
	_vehicle engineOn false;
	
	_text = format [localize "STRS_ammo_started", TW_Sup_Reammo_Time];
	titleText[_text, "PLAIN DOWN"];	//Msg
	
	sleep TW_Sup_Reammo_Time;

	if(getPos _vehicle distance _pos > 1) exitWith {
		titleText[localize "STRS_ammo_aborted", "PLAIN DOWN"];	//Msg
	};
		
	_vehicle setVehicleAmmo 1;
	titleText[localize "STRS_ammo_end", "PLAIN DOWN"];	//Msg
};



//**********************************************************
//Marker
//**********************************************************


//Player Marker and Marker Uodate
Tee_PlayerMarker_Loop = {
	private ["_i","_markerarray","_name","_type","_marker","_object","_text","_detected","_points","_side","_colour","_text","_actioncode","_action"];
	
	waitUntil {HQ_placed};
	
	_markerarray = [];
	
	while {true} do {
		_i = 0;
		
		//Delete PlayerMarker
		{
			deleteMarkerLocal _x;
		} forEach _markerarray;
		
		_markerarray = []; // dringend notwendig, sonst platzt das array irgendwann :)
		
		//Create PlayerMarker
		{
			_i = _i + 1;
			_name = format ["PlMa_%1",_i];
			if(alive _x && isPlayer _x && playerSide == side _x) then {
			
				if(vehicle _x == _x) then {
					_type = "n_inf";
				} else {
					_type = "b_motor_inf";
				};
			
				_marker = CreateMarkerLocal [_name, position _x];
				_marker setMarkerShapeLocal "Icon";
				_marker setMarkerTypeLocal _type;
				_marker setMarkerTextLocal name _x;
				
				_markerarray set [count _markerarray, _marker];
			};
		} forEach playableUnits;
		
		
		//Update HQ
		if(TW_playerside == "west") then {
			TW_West_BaseMarker setMarkerPosLocal (getPos hq_west);
			TW_West_ShopMarker_V setMarkerPosLocal (getPos west_shop_veh);
			TW_West_ShopMarker_G  setMarkerPosLocal (getPos west_shop_weapons);
			TW_West_ShopMarker_AI setMarkerPosLocal (getPos west_shop_ai);
		};
		if(TW_playerside == "east") then {
			TW_East_BaseMarker setMarkerPosLocal (getPos hq_east);
			TW_East_ShopMarker_V setMarkerPosLocal (getPos east_shop_veh);
			TW_East_ShopMarker_G  setMarkerPosLocal (getPos east_shop_weapons);
			TW_East_ShopMarker_AI setMarkerPosLocal (getPos east_shop_ai);
		};
		
		
		//Update Town
		{
			_object 	= _x select 0;
			_name 		= _x select 1;
			_text		= _x select 2;
			
			_detected 	= _object getVariable "TownDetected";
			_points 	= _object getVariable "TownPoints";
			_side 		= _object getVariable "TownSide";
			
			

			//Mark Captureable Towns
			if([_object,TW_playerside] call Tee_Stra_TowncanCap && TW_Strategic_Street) then {
				_colour = "ColorOrange";
				_name setMarkerColorLocal _colour;	//TeeTimeTest unschön weil gedoppelt siehe Unten
			};
			
			//Set Town Colors
			if(TW_playerside in _detected || TW_Para_satintel) then {
				_name setMarkerTextLocal format["%1 %2/100",_text,_points];
			
				if(_side == "civ") then {_colour = "ColorBlack";};
					//Mark Captureable Towns
					if([_object,TW_playerside] call Tee_Stra_TowncanCap && TW_Strategic_Street) then {
						_colour = "ColorOrange";
					};
				if(_side == "west") then {_colour = "ColorBlue";};
				if(_side == "east") then {_colour = "ColorRed";};
				_name setMarkerColorLocal _colour;
			};
		} forEach TW_TownArray;
		
		
		//Update Respawn
		TW_West_Respawn setMarkerPosLocal [((getPos west_shop_veh) select 0) + 5,((getPos west_shop_veh) select 1) - 10,(getPos west_shop_veh) select 2];	//TeeTimeTest	Marker ist Lokal
		TW_East_Respawn setMarkerPosLocal [((getPos east_shop_veh) select 0) + 5,((getPos east_shop_veh) select 1) - 10,(getPos east_shop_veh) select 2];	//TeeTimeTest	Marker ist Lokal
	
		//Basic Values
		if(playerside == west) 	then { 
			TW_playerside = "west"; 
			TW_playerside_colour = "ColorBlue";
			if (player distance getMarkerPos "BlueforHello" < 25) then {
				hint parseText (format["<t color='#ff0000'>Welcome to the Server %1<br/> Please see Map-Menu for Briefing and FAQs</t>", name player]);
			};	
		};
		if(playerside == east) 	then { 
			TW_playerside = "east"; 
			TW_playerside_colour = "ColorRed";
			if (player distance getMarkerPos "OpforHello" < 25) then {
				hint parseText (format["<t color='#ff0000'>Welcome to the Server %1<br/> Please see Map-Menu for Briefing and FAQs</t>", name player]);
			};	
		};
		
		
		sleep 8;
	};
};



Tee_Marker_ConnectMarker = {
	private ["_base1","_base2","_xdif","_ydif","_xpos","_ypos","_pos","_marker"];
	
	_base1 = getPos (_this select 0);
	_base2 = getPos (_this select 1);
	
	_xdif = (_base1 select 0) - (_base2 select 0);
	_ydif = (_base1 select 1) - (_base2 select 1);
	
	_xpos = (_base1 select 0) - _xdif / 2;
	_ypos = (_base1 select 1) - _ydif / 2;
	
	_pos	= [_xpos,_ypos,0];
	_dir	= atan ( _xdif / _ydif );
	
	player globalChat str _pos;
	
	_name 	= format ["CM_%1_%2",floor(time),floor(random(1000))];
	_type	= "RECTANGLE";
	
	_marker = CreateMarkerLocal [_name, _pos];
	_marker setMarkerShapeLocal "RECTANGLE";
	_marker setMarkerBrushLocal "Solid";
	_marker setMarkerDirLocal _dir;
	_marker setMarkerSizeLocal [10, ((_base1 distance _base2) / 2) * 0.95];	//Auf 95% runter wegen Optik
	_marker setMarkerColorLocal "ColorBlack";
};


//*******************************************************
//Vehicles
//*******************************************************


Tee_GetVeh_Name = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 1;};
	} forEach Tee_Veh_Array;
	_return
};



Tee_GetVeh_Class = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 2;};
	} forEach Tee_Veh_Array;
	_return
};



Tee_GetVeh_Price = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 3;};
	} forEach Tee_Veh_Array;
	_return
};



Tee_GetVeh_Typ = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 5;};
	} forEach Tee_Veh_Array;
	_return
};



Tee_CreateVehicle = {
	private ["_id","_class","_price","_typ","_text","_veh"];
	
	_id		= 	_this select 0;
	_class	=	_id call Tee_GetVeh_Class;
	_price	= 	_id call Tee_GetVeh_Price;
	_typ	= 	_id call Tee_GetVeh_Typ;
	
	if(!TW_vehicles && _typ != "Box") exitWith {
		titleText[localize "STRS_buy_vehicle_noserver", "PLAIN DOWN"];	//Msg
	};
	
	if(!TW_air && _typ == "Air") exitWith {
		titleText[localize "STRS_buy_vehicle_noserver", "PLAIN DOWN"];	//Msg
	};
	
	if(Tee_Konto < _price) exitWith {
		titleText[localize "STRS_buy_nomoney", "PLAIN DOWN"];	//Msg
	};
	
	Tee_Konto = Tee_Konto - _price;
	
	_text = format [localize "STRS_Konto2", Tee_Konto];
	titleText[_text, "PLAIN DOWN"];	//Msg

	[] call Tee_ShowMoney;
	//Create
	_veh = _class createVehicle (position player);
	_veh setVehicleVarName format["veh_%1_%2",floor(time),floor(random(50))];
	
	//Lock/Unlock Action
	if(_typ != "Box") then {
		_veh lock true;
		TW_Vehicle_Client = TW_Vehicle_Client + [_veh];
	
		//Action
		_text		= "Lock/Unlock";
		_actioncode	= format ["[objectFromNetId ""%1""] call Tee_Vehicle_Lock;",netid _veh];
		//_action 	= _veh addAction [_text, AddActionCode,_actioncode];
	} else {
		//Action
		//_text		= "Open Box";
		//_actioncode	= format ['createGearDialog [player, "RscDisplayGear"];',_veh];
		//_action 	= _veh addAction [_text, AddActionCode,_actioncode];
	
		//player groupchat str weaponCargo _veh;	//Debug
	};
};



/*
	Lock Unlock given Vehicle
*/
Tee_Vehicle_Lock = {
	private ["_veh","_locked"];
	
	_veh 	= _this select 0;

	_locked	= locked _veh;

	if(_locked == 2) then {
		_veh lock false;
		titleText[localize "STRS_lock_open", "PLAIN DOWN"];	//Msg
	} else {
		_veh lock true;
		titleText[localize "STRS_lock_closed", "PLAIN DOWN"];	//Msg
	};	
};
	
		

//*************************			
//Weapons
//*************************
Tee_GetWeap_Name = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 1;};
	} forEach Tee_Weapon_Array;
	_return
};



Tee_GetWeap_Class = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 2;};
	} forEach Tee_Weapon_Array;
	_return
};



Tee_GetWeap_Price = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 3;};
	} forEach Tee_Weapon_Array;
	_return
};



Tee_GetWeap_Typ = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 5;};
	} forEach Tee_Weapon_Array;
	_return
};



Tee_AddWeapon = {
	private ["_id","_class","_price","_text"];
	
	_id		= 	_this select 0;
	_class	=	_id call Tee_GetWeap_Class;
	_price	= 	_id call Tee_GetWeap_Price;
	
	if(debug) then {
		player groupChat "Wep";
		player groupChat _class; 
	};
	
	if(Tee_Konto < _price) exitWith {
		titleText[localize "STRS_buy_nomoney", "PLAIN DOWN"];	//Msg
	};
	Tee_Konto = Tee_Konto - _price;
	
	player addWeapon _class;
	
	_text = format [localize "STRS_Konto2", Tee_Konto];
	titleText[_text, "PLAIN DOWN"];	//Msg
	
	[] call Tee_ShowMoney;
	
	//Save Gear
	//[] call Tee_SS_Gear_Save;
	loadout = [player] call getLoadout;
};



Tee_AddMag  = {
	private ["_id","_class","_price"];
	
	_id		= 	_this select 0;
	_class	=	_id call Tee_GetWeap_Class;
	_price	= 	_id call Tee_GetWeap_Price;
	
	if(debug) then {
		player groupChat "Mag";
		player groupChat _class;
	};
	
	if(Tee_Konto < _price) exitWith {
		titleText[localize "STRS_buy_nomoney", "PLAIN DOWN"];	//Msg
	};
	Tee_Konto = Tee_Konto - _price;
	
	player addMagazine _class;
	
	_text = format [localize "STRS_Konto2", Tee_Konto];
	titleText[_text, "PLAIN DOWN"];	//Msg
	[] call Tee_ShowMoney;
	
	//Save Gear
	//[] call Tee_SS_Gear_Save;
	loadout = [player] call getLoadout;
};



//AI
Tee_GetUnit_Name = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 1;};
	} forEach Tee_AI_Array;
	_return
};



Tee_GetUnit_Class = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 2;};
	} forEach Tee_AI_Array;
	_return
};



Tee_GetUnit_Price = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 3;};
	} forEach Tee_AI_Array;
	_return
};



Tee_GetUnit_Side = {
	private ["_return"];
	_return = 0;
	{
		if(_this == _x select 0) exitWith {_return = _x select 5;};
	} forEach Tee_AI_Array;
	_return
};



Tee_CreateUnit = {
	private ["_group","_class","_pos","_unit"];
	
	_group		= 	_this select 0;
	_class		=	_this select 1;
	_pos		=	_this select 2;

	_unit = _group createUnit [_class, _pos, [], 0, "FORM"];
	

		//skills units
		_unit setskill ["general",TW_Skill_AIOff];
		_unit setskill ["endurance",1];
		_unit setskill ["spotDistance",1];
		//_unit setskill ["aimingShake",TW_Skill_AIOff];
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
			_level = (TW_Skill_AIOff + random 0.05);
			_unit setskill [_x, _level];
			sleep 0.05;
			}foreach _skill;			
		sleep 0.25;		
	_unit addEventHandler ["killed", "_this call Tee_AI_Killed;"];
	
	_unit
};



Tee_BuyUnit = {
	private ["_id","_class","_price","_group","_unit","_text"];
	
	_id		= 	_this select 0;
	_class	=	_id call Tee_GetUnit_Class;
	_price	= 	_id call Tee_GetUnit_Price;
	
	_group = group player;
	
	if(debug) then {
		player groupChat "AI";
		player groupChat _class; 
	};
	
	if(!TW_ai) exitWith {
		titleText[localize "STRS_buy_ai_noserver", "PLAIN DOWN"];	//Msg
	};
	
	if(player != leader group player) exitWith {
		titleText[localize "STRS_buy_ai_notleader", "PLAIN DOWN"];	//Msg
	};
	
	if(Tee_Konto < _price) exitWith {
		titleText[localize "STRS_buy_nomoney", "PLAIN DOWN"];	//Msg
	};
	if(count (units _group) >= (TW_AI_max + 1)) exitWith {
		titleText[localize "STRS_buy_ai_limit", "PLAIN DOWN"];	//Msg
	};
	
	Tee_Konto = Tee_Konto - _price;
	
	_unit = [_group,_class,position player] call Tee_CreateUnit;

	_text = format [localize "STRS_Konto2", Tee_Konto];
	titleText[_text, "PLAIN DOWN"];	//Msg
	[] call Tee_ShowMoney;
};



