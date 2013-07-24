/*
	Script written by TeeTime dont remove this comment
	
	All Functions linked to player actions
*/

#define SLOW_INTERVAL 10
#define FAST_INTERVAL 2


//modif siskojay team kkz, optimized by fred41
Tee_ActionLoop = {
	private ["_actdistance","_nextslowrefresh","_side","_hq_side","_side_shop_veh","_side_shop_weapons","_side_shop_ai","_Vehicle_Shop_side","_Weapon_Shop_side","_AI_Shop_side","_invehicle","_action","_lock_action","_is_lock_action","_savegear_action","_is_savegear_action","_grp_leaveaction","_is_grp_leaveaction","_grp_joinaction","_is_grp_joinaction","_townaction","_town_actionarray","_neartown","_nearowntown","_hq_action","_hq_actionarray","_veh_s_action","_veh_s_actionarray","_weap_action","_weap_actionarray","_ai_action","_ai_actionarray","_repairaction","_repairactionarray","_count","_object","_weap_typ","_text","_actioncode"];
	
	_is_lock_action 	= false;
	_townaction			= false;
	_neartown			= false;
	_nearowntown		= false;
	
	_hq_action			= false;
	_veh_s_action		= false;
	_weap_action 		= false;
	_ai_action 			= false;
	_repairaction		= false;
	_is_savegear_action	= false;
	
	_town_actionarray 	= [];
	_hq_actionarray		= [];
	_veh_s_actionarray	= [];
	_weap_actionarray 	= [];
	_ai_actionarray 	= [];
	_repairactionarray	= [];
	
	//Group
	_is_grp_leaveaction	= false;
	_is_grp_joinaction	= false;
	

	if (playerSide == west) then { _hq_side = hq_west; _side_shop_veh = west_shop_veh; _side_shop_weapons = west_shop_weapons; _side_shop_ai = west_shop_ai; _Vehicle_Shop_side = TW_Vehicle_Shop_West; _Weapon_Shop_side = TW_Weapon_Shop_West; _AI_Shop_side = TW_AI_Shop_West}; 
	if (playerSide == east) then { _hq_side = hq_east; _side_shop_veh = east_shop_veh; _side_shop_weapons = east_shop_weapons; _side_shop_ai = east_shop_ai; _Vehicle_Shop_side = TW_Vehicle_Shop_East; _Weapon_Shop_side = TW_Weapon_Shop_East; _AI_Shop_side = TW_AI_Shop_East};
	_side = str(playerSide);
	_nextslowrefresh = time + SLOW_INTERVAL;
	//Loop
	while{true} do {

		//Money
		if (time > _nextslowrefresh) then {
			[] call Tee_ShowMoney;
			if(alive player) then {	loadout = [player] call getLoadout;	};  // checken
			_nextslowrefresh = time + SLOW_INTERVAL;
		};
	
		//check if is a teammember
		if((getplayeruid player) in TW_Teammembers) then {Team_Member = true;} else {Team_Member = false;};		
		
		//Reset after Death and place Player
		if(! alive player) then {
		
			titleText[localize "STRS_died", "PLAIN DOWN"];	//Msg
			
			TW_Voting		= false;

			waitUntil{alive player};
			if((paramsArray select 22) == 0) then {[] call Tee_Player_Respawn;};
		};

		// check if side has changed and if yes adjust side related stuff	
		if (_side != str(playerSide)) then {
			if (playerSide == west) then { _hq_side = hq_west; _side_shop_veh = west_shop_veh; _side_shop_weapons = west_shop_weapons; _side_shop_ai = west_shop_ai; _Vehicle_Shop_side = TW_Vehicle_Shop_West; _Weapon_Shop_side = TW_Weapon_Shop_West; _AI_Shop_side = TW_AI_Shop_West}; 
			if (playerSide == east) then { _hq_side = hq_east; _side_shop_veh = east_shop_veh; _side_shop_weapons = east_shop_weapons; _side_shop_ai = east_shop_ai; _Vehicle_Shop_side = TW_Vehicle_Shop_East; _Weapon_Shop_side = TW_Weapon_Shop_East; _AI_Shop_side = TW_AI_Shop_East};
			_side = str(playerSide);
		};
		
		//Check Vehicle
		if(player == vehicle player) then {
			_invehicle 	= false;
			_actdistance = 5;
		} else {
			_invehicle 	= true;
			_actdistance = 15;
		};
		
			
			//Debug
			if(debug) then {
				player addAction ["Spawn Veh", AddActionCode,'[] call Tee_Debug_Spawn;'];
				player addAction ["Add Weapon", AddActionCode,'[] call Tee_Debug_Spawn_Weapon;'];
				player addAction ["Teleport", AddActionCode,'[] call Tee_Debug_Teleport;'];
			};

			
		//Lock Unlock Vehicle
		if (!_invehicle) then {
			if (!_is_lock_action) then {
				if ((cursorTarget in TW_Vehicle_Client)&&(player distance cursorTarget < 5)) then {
					_text			= localize "STRS_action_lock";
					_actioncode		= "[cursorTarget] call Tee_Vehicle_Lock;";
					_lock_action 	= player addAction [_text, AddActionCode,_actioncode];
					_is_lock_action = true;
				};
			} else {
				if (!(cursorTarget in TW_Vehicle_Client)||(player distance cursorTarget > 5)) then {
					player removeAction _lock_action;
					_is_lock_action = false;
				};
			};
		} else {
			if (!_is_lock_action) then {
				_text			= localize "STRS_action_lock";
				_actioncode		= format ["[objectFromNetId ""%1""] call Tee_Vehicle_Lock;", netid vehicle player];
				_lock_action 	= player addAction [_text, AddActionCode,_actioncode];
				_is_lock_action = true;
			};
		};
/*		
		//Save Gear
		if(((player distance _hq_side) < _actdistance) && !_invehicle ) then {
			if (!_is_savegear_action) then {
				//Actions
				_text 			= format [localize "STRS_action_savegear"];
				_actioncode		= "loadout = [player] call getLoadout;";
				_savegear_action = player addAction [_text, AddActionCode,_actioncode];
				_is_savegear_action	= true;
			};
		} else {
			if (_is_savegear_action) then {
				player removeAction _savegear_action;
				_is_savegear_action = false;
			};	
		};
*/		
		//Townshops
		_neartown = false;
		_nearowntown = false;
		{
			scopeName "loop";
			if(player distance (_x select 0) < _actdistance) then {_neartown = true; if (_side == (_x select 0) getVariable "TownSide") then {_nearowntown = true; breakOut "loop"}; };
		} forEach TW_TownArray;

		if((_nearowntown)&&(!_townaction)) then {
			[] call Tee_ShowMoney;
			if(!_invehicle) then {
				{
					_text 			= format [localize "STRS_action_buy",_x call Tee_GetVeh_Name,_x call Tee_GetVeh_Price];
					_actioncode		= format ["[%1] call Tee_CreateVehicle;",_x];
					_action = player addAction [_text, AddActionCode,_actioncode];
					_town_actionarray set [count _town_actionarray, _action];
				} forEach TW_Vehicle_Shop_Town;

			} else {
				//Repair
				_text 			= format [localize "STRS_action_repair",TW_Repair_Cost];
				_actioncode		= "[] spawn Tee_Sup_Repair;";
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_town_actionarray = _town_actionarray + [_action];
				
				//Refuel
				_text 			= format [localize "STRS_action_refuel",TW_Sup_Fuel_Cost];
				_actioncode		= "[] spawn Tee_Sup_Refuel;";
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_town_actionarray set [count _town_actionarray, _action];
			};
			_townaction = true;
		};
		
		if((!_nearowntown)&&(_townaction)) then {
			{
				player removeAction _x;
			} forEach _town_actionarray;
			
			_town_actionarray 	= [];
			_townaction 		= false;
		};
		

		//*******************
		//GROUPS
		//*******************
		
		
		//Leave Group
		if((player distance _hq_side) < _actdistance ) then { 
			if (player != leader (group player)) then {
				if(!_is_grp_leaveaction) then {
					_text 			= format [localize "STRS_action_grp_leave"];
					_actioncode		= "[player] call Tee_Grp_Leave;";
					_grp_leaveaction= player addAction [_text, AddActionCode,_actioncode];
				
					_is_grp_leaveaction	= true;
				};
			};
		} else {
			if(_is_grp_leaveaction) then {
				player removeAction _grp_leaveaction;
				
				_is_grp_leaveaction = false;
			};
		};
		
		
		//Join Player Group
		if(isPlayer cursortarget) then {
			if (!_invehicle && player == (leader group player) && playerSide == side cursorTarget) then {
				if(!_is_grp_joinaction) then {
					_text 			= format [localize "STRS_action_grp_join"];
					_actioncode		= "[cursorTarget] call Tee_Grp_Join;";
					_grp_joinaction	= player addAction [_text, AddActionCode,_actioncode];
				
					_is_grp_joinaction	= true;
				};
			};
		} else {
			if(_is_grp_joinaction) then {
				player removeAction _grp_joinaction;
				_is_grp_joinaction = false;
			};
		};

		
		//*******************
		//WEST & EAST
		//*******************
		
		
		//HQ
		if (TW_Para_MobilBase) then {
			
			if((player distance _hq_side) < _actdistance) then {
				if (!_invehicle && !(alive driver _hq_side) && TW_Para_MobilBase) then {
					if(!_hq_action) then {
			
						//Actions
						_text 			= format [localize "STRS_action_mobilzehq"];
						_actioncode		= "[] spawn Tee_Client_Base_DeMobHQ;";
						_action = player addAction [_text, AddActionCode,_actioncode];
						_hq_actionarray set [count _hq_actionarray, _action];
				
						_hq_action		= true;
					};
				};
			} else {
				if(_hq_action ) then {
					{
						player removeAction _x;
					} forEach _hq_actionarray;
				
					_hq_actionarray = [];
					_hq_action = false;
				};
			};
		
		
			//HQ SetUp
			if(player == (driver _hq_side)) then {
				
				//Actions
				_text 			= format [localize "STRS_action_buildhq"];
				_actioncode		= "[] call Tee_Client_Base_HQ_setUp;";
				_action = player addAction [_text, AddActionCode,_actioncode];
				_hq_actionarray set [count _hq_actionarray, _action];
				
				_hq_action		= true;
			};
		};

		
		
		//Shop Vehicle
		if((player distance _side_shop_veh)	< _actdistance) then {
			if (!_invehicle) then {
				if(!_veh_s_action) then {
			
					titleText[localize "STRS_action_vehicelshop", "PLAIN DOWN"];	//Msg
			
					//Actions
					{
						_text 			= format [localize "STRS_action_buy",_x call Tee_GetVeh_Name,_x call Tee_GetVeh_Price];
						_actioncode		= format ["[%1] call Tee_CreateVehicle;",_x];
						_action = player addAction [_text, AddActionCode,_actioncode];
						_veh_s_actionarray set [count _veh_s_actionarray, _action];
					} forEach _Vehicle_Shop_side;

					_veh_s_action		= true;
				};	
			};
		} else {
			if(_veh_s_action) then {
				{
					player removeAction _x;
				} forEach _veh_s_actionarray;
				
				_veh_s_actionarray = [];
				_veh_s_action = false;
			};
		};


		
		// Weapon
		if((player distance _side_shop_weapons) < 3) then {
			if (!_invehicle) then {
				if(!_weap_action) then {
			
					titleText[localize "STRS_action_weaponshop", "PLAIN DOWN"];	//Msg
			
					//Actions
					{
						if(TW_BoxShop) then {
							_text 			= format [localize "STRS_action_buy",_x call Tee_GetVeh_Name,_x call Tee_GetVeh_Price];
							_actioncode		= format ["[%1] call Tee_CreateVehicle;",_x];
						} else {
		
							_text 		= format [localize "STRS_action_buy",_x call Tee_GetWeap_Name,_x call Tee_GetWeap_Price];	
							_weap_typ 	= _x call Tee_GetWeap_Typ;
					
							if(_weap_typ == "wep") then {
								_actioncode	= format ["[%1] call Tee_AddWeapon;",_x];
							};
							if(_weap_typ == "mag") then {
								_actioncode	= format ["[%1] call Tee_AddMag;",_x];	
							};
						};
					
						_action 	= player addAction [_text, AddActionCode,_actioncode];
						_weap_actionarray set [count _weap_actionarray, _action];
					} forEach _Weapon_Shop_side;
					_weap_action = true;
				};
			};
		} else {
			if(_weap_action) then {
				{
					player removeAction _x;
				} forEach _weap_actionarray;
				
				_weap_actionarray 	= [];
				_weap_action 		= false;
			};
		};


		
		//AI Shop
		if((player distance _side_shop_ai) < 4) then { 
			if (!_invehicle) then {
				if(!_ai_action) then {

					titleText[localize "STRS_action_aishop", "PLAIN DOWN"];	//Msg

					//Actions
					{
						_text 		= format [localize "STRS_action_buy",_x call Tee_GetUnit_Name,_x call Tee_GetUnit_Price];
						_actioncode	= format ["[%1] call Tee_BuyUnit;",_x];
						_action 	= player addAction [_text, AddActionCode,_actioncode];
						_ai_actionarray set [count _ai_actionarray, _action];
					} forEach _AI_Shop_side;
					_ai_action = true;
				};
			};
		} else {
			if(_ai_action) then {
				{
					player removeAction _x;
				} forEach _ai_actionarray;
				
				_ai_actionarray 	= [];
				_ai_action 		= false;
			};
		};
	
		
		
		// Repair Station
		if((player distance _hq_side) < 40) then {
			if (_invehicle) then {//modif siskojay pour reparer
				if(!_repairaction) then {
			
					//titleText["Repair Station", "PLAIN DOWN"];	//Msg
			
					//Repair
					_text 			= format [localize "STRS_action_repair",TW_Repair_Cost];
					_actioncode		= "[] spawn Tee_Sup_Repair;";
					_action 		= player addAction [_text, AddActionCode,_actioncode];
					_repairactionarray set [count _repairactionarray, _action];
				
					//Refuel
					_text 			= format [localize "STRS_action_refuel",TW_Sup_Fuel_Cost];
					_actioncode		= "[] spawn Tee_Sup_Refuel;";
					_action 		= player addAction [_text, AddActionCode,_actioncode];
					_repairactionarray set [count _repairactionarray, _action];
				
					//Reammo
					_text 			= format [localize "STRS_action_reammo",TW_Sup_Reammo_Cost];
					_actioncode		= "[] spawn Tee_Sup_Reammo;";
					_action 		= player addAction [_text, AddActionCode,_actioncode];
					_repairactionarray set [count _repairactionarray, _action];
				
					_repairaction		= true;
				};
			};
		} else {
			if(_repairaction) then {
				{
					player removeAction _x;
				} forEach _repairactionarray;
				
				_repairactionarray 	= [];
				_repairaction 		= false;
			};
		};

		//End
		sleep FAST_INTERVAL;
	};
};
