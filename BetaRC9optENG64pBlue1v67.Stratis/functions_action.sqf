/*
	Script written by TeeTime dont remove this comment
	
	All Functions linked to player actions
*/

///modif siskojay team kkz//
Tee_ActionLoop = {
	private ["_cursertarget","_veh","_invehicle","_action","_money_action","_lock_action","_lock_action2","_lock_action3","_lock_actionarray","_savegear_action","_sagegear_actionarray","_townaction","_money_action2","_town_actionarray","_neartown","_hq_action","_hq_actionarray","_veh_s_action","_veh_s_actionarray","_weap_action","_weap_actionarray","_ai_action","_ai_actionarray","_repairaction","_repairactionarray","_count","_object","_weap_typ","_text","_actioncode"];
	
	_money_action 		= false;
	_lock_action 		= false;
	_lock_action3 		= false;
	_townaction			= false;
	_neartown			= false;
	
	_hq_action			= false;
	_veh_s_action		= false;
	_weap_action 		= false;
	_ai_action 			= false;
	_repairaction		= false;
	_savegear_action	= false;
	
	_town_actionarray 	= [];
	_hq_actionarray		= [];
	_veh_s_actionarray	= [];
	_weap_actionarray 	= [];
	_ai_actionarray 	= [];
	_repairactionarray	= [];
	_savegear_actionarray = [];
	
	//Group
	_grp_leaveaction	= false;
	_grp_joinaction		= false;
		
	_grp_actionarray1 	= [];
	_grp_actionarray2 	= [];
	
	
	//Loop
	while{true} do {
		
		//check if is a teammember
		if((getplayeruid player) in TW_Teammembers) then {Team_Member = true;} else {Team_Member = false;};		
		
		//Reset after Death and place Player
		if(! alive player) then {
		
			titleText[localize "STRS_died", "PLAIN DOWN"];	//Msg
			
			//_money_action 	= false;
			TW_Voting		= false;
			//player removeAction _money_action2;

			waitUntil{alive player};
			if((paramsArray select 22) == 0) then {[] call Tee_Player_Respawn;};
		};
		
		
		//Check Vehicle
		if(player == vehicle player) then {
			_invehicle 		= false;
			_cursertarget 	= cursorTarget;
		} else {
			_veh		= vehicle player;
			_invehicle 	= true;
		};
		
		
			
			//Debug
			if(debug) then {
				player addAction ["Spawn Veh", AddActionCode,'[] call Tee_Debug_Spawn;'];
				player addAction ["Add Weapon", AddActionCode,'[] call Tee_Debug_Spawn_Weapon;'];
				player addAction ["Teleport", AddActionCode,'[] call Tee_Debug_Teleport;'];
			};

		
		
		
		//Money//////////////modifier 10 par 5000 siskojay, marche niquel afficher tjr en haut a droite///
		if ((((player distance hq_west) < 5000 && TW_playerside == "west") || ((player distance hq_east) < 5000 && TW_playerside == "east"))) then {[] call Tee_ShowMoney;};
		
		
		///////////////test siskojay test plus rien afficher au milieu//////////////////////
				//Lock Unlock Vehicle
		if(!_invehicle && (_cursertarget in TW_Vehicle_Client) && (player distance _cursertarget < 5) && !_lock_action3) then {
			_text		= localize "STRS_action_lock";
			_actioncode	= format ["[%1] call Tee_Vehicle_Lock;",_cursertarget];
			_action 	= player addAction [_text, AddActionCode,_actioncode];
			_lock_actionarray = _lock_actionarray + [_action];
			
			_lock_action3 = true;
		};
		if(!_lock_action && ((player distance _cursertarget > 5) || !(_cursertarget in TW_Vehicle_Client) || _invehicle)) then {
				{
					player removeAction _x;
				} forEach _lock_actionarray;
				
				_lock_actionarray 	= [];
				_lock_action3 		= false;
		};
		
		
		//Unlock Action for Player in Vehicles
		if(_invehicle && !_lock_action) then {
			 //Action
			_text			= localize "STRS_action_lock";
			_actioncode		= format ["[%1] call Tee_Vehicle_Lock;",_veh];
			_lock_action2 	= player addAction [_text, AddActionCode,_actioncode];
			_lock_action = true;
		};
		if(!_invehicle && _lock_action) then {
			 player removeAction _lock_action2;
			_lock_action = false;
		};
		
		
		//Save Gear
		if((((player distance hq_west) < 4 && TW_playerside == "west") || ((player distance hq_east) < 4 && TW_playerside == "east")) && !_invehicle && !_savegear_action) then {
			//Actions
			_text 			= format [localize "STRS_action_savegear"];
			_actioncode		= format ["loadout = [player] call getLoadout;"];
			_action = player addAction [_text, AddActionCode,_actioncode];
			_savegear_actionarray = _savegear_actionarray + [_action];
				
			_savegear_action	= true;
		} else {
				{
					player removeAction _x;
				} forEach _savegear_actionarray;
				
				_savegear_actionarray 	= [];
				_savegear_action 		= false;
		};
		
		
		
		
		//Townshops
		if(!_townaction) then {
			{
				_object = _x select 0;
				
				if(player distance _object < 5 && TW_playerside == _object getVariable "TownSide") then {
					[] call Tee_ShowMoney;
					if(!_invehicle) then {
						{
							_text 			= format [localize "STRS_action_buy",_x call Tee_GetVeh_Name,_x call Tee_GetVeh_Price];
							_actioncode		= format ["[%1] call Tee_CreateVehicle;",_x];
							_action = player addAction [_text, AddActionCode,_actioncode];
							_town_actionarray = _town_actionarray + [_action];
						} forEach TW_Vehicle_Shop_Town;
					} else {
						//Repair
						_text 			= format [localize "STRS_action_repair",TW_Repair_Cost];
						_actioncode		= format ["[] spawn Tee_Sup_Repair;"];
						_action 		= player addAction [_text, AddActionCode,_actioncode];
						_town_actionarray = _town_actionarray + [_action];
				
						//Refuel
						_text 			= format [localize "STRS_action_refuel",TW_Sup_Fuel_Cost];
						_actioncode		= format ["[] spawn Tee_Sup_Refuel;"];
						_action 		= player addAction [_text, AddActionCode,_actioncode];
						_town_actionarray = _town_actionarray + [_action];
					};
					
					_townaction = true;
				};		
			} forEach TW_TownArray;
		} else {
			{
				_object = _x select 0;
				if(player distance _object < 5) then {
					_neartown = true;
				} else {
					_neartown = false;
				};
			} forEach TW_TownArray;
			
			if(!_neartown && _townaction) then {
				{
					player removeAction _x;
				} forEach _town_actionarray;
				
				_town_actionarray 	= [];
				_townaction 		= false;
			};
		};
		
		



		//*******************
		//GROUPS
		//*******************
		
		
		//Leave Group
		if(((player distance hq_west) < 20 || (player distance hq_east) < 20) && (player != leader (group player))) then {
		//if((player distance hq_west) < 4 || (player distance hq_east) < 4 ) then {	//TeeTimeTest
			if(!_grp_leaveaction) then {
				_text 			= format [localize "STRS_action_grp_leave"];
				_actioncode		= format ["[player] call Tee_Grp_Leave;"];
				_action			= player addAction [_text, AddActionCode,_actioncode];
				_grp_actionarray1 	= _grp_actionarray1 + [_action];
				
				_grp_leaveaction	= true;
			};
		} else {
			if(_grp_leaveaction) then {
				{
					player removeAction _x;
				} forEach _grp_actionarray1;
				
				_grp_actionarray1 = [];
				_grp_leaveaction = false;
			};
		};
		
		
		//Join Player Group
		if(isPlayer _cursertarget && !_invehicle && player == (leader group player) && playerSide == side _cursertarget) then {
			if(!_grp_joinaction) then {
				_text 			= format [localize "STRS_action_grp_join"];
				_actioncode		= format ["[cursorTarget] call Tee_Grp_Join;"];
				_action			= player addAction [_text, AddActionCode,_actioncode];
				_grp_actionarray2 	= _grp_actionarray2 + [_action];
				
				_grp_joinaction	= true;
			};
		} else {
			if(_grp_joinaction) then {
				{
					player removeAction _x;
				} forEach _grp_actionarray2;
				
				_grp_actionarray2 = [];
				_grp_joinaction = false;
			};
		};

		
		//*******************
		//WEST
		//*******************
		
		
		//West HQ
		if((player distance hq_west) < 10 && !_invehicle && !(alive driver hq_west) && TW_Para_MobilBase) then {
			if(TW_playerside == "west" && !_hq_action) then {
			
				//Actions
				_text 			= format [localize "STRS_action_mobilzehq"];
				_actioncode		= format ["[%1] spawn Tee_Client_Base_DeMobHQ;"];
				_action = player addAction [_text, AddActionCode,_actioncode];
				_hq_actionarray = _hq_actionarray + [_action];
				
				_hq_action		= true;
			};
		} else {
			if(_hq_action && TW_playerside == "west") then {
				{
					player removeAction _x;
				} forEach _hq_actionarray;
				
				_hq_actionarray = [];
				_hq_action = false;
			};
		};
		
		
		//WestHQ SetUp
		if(player == (driver hq_west)) then {
				//Check Side
				if(TW_playerside != "west") then {
					moveOut player;
				};
				
				//Actions
				_text 			= format [localize "STRS_action_buildhq"];
				_actioncode		= format ["[%1] call Tee_Client_Base_HQ_setUp;"];
				_action = player addAction [_text, AddActionCode,_actioncode];
				_hq_actionarray = _hq_actionarray + [_action];
				
				_hq_action		= true;
		};


		//West Vehicle
		if((player distance west_shop_veh) < 3 && !_invehicle) then {
			if(TW_playerside == "west" && !_veh_s_action) then {
			
				titleText[localize "STRS_action_vehicelshop", "PLAIN DOWN"];	//Msg
			
				//Actions
				{
					_text 			= format [localize "STRS_action_buy",_x call Tee_GetVeh_Name,_x call Tee_GetVeh_Price];
					_actioncode		= format ["[%1] call Tee_CreateVehicle;",_x];
					_action = player addAction [_text, AddActionCode,_actioncode];
					_veh_s_actionarray = _veh_s_actionarray + [_action];
				} forEach TW_Vehicle_Shop_West;
				
				_veh_s_action		= true;
			};
		} else {
			if(_veh_s_action && TW_playerside == "west") then {
				{
					player removeAction _x;
				} forEach _veh_s_actionarray;
				
				_veh_s_actionarray = [];
				_veh_s_action = false;
			};
		};


		
		//West Weapon
		if((player distance west_shop_weapons) < 3 && !_invehicle) then {
			if(TW_playerside == "west" && !_weap_action) then {
			
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
					_weap_actionarray = _weap_actionarray + [_action];
				} forEach TW_Weapon_Shop_West;
				
				_weap_action = true;
			};
		} else {
			if(_weap_action && TW_playerside == "west") then {
				{
					player removeAction _x;
				} forEach _weap_actionarray;
				
				_weap_actionarray 	= [];
				_weap_action 		= false;
			};
		};

		

		
		//West AI Shop
		if((player distance west_shop_ai) < 4 && !_invehicle) then {
			if(TW_playerside == "west" && !_ai_action) then {
			
				titleText[localize "STRS_action_aishop", "PLAIN DOWN"];	//Msg
			
				//Actions
				{
					_text 		= format [localize "STRS_action_buy",_x call Tee_GetUnit_Name,_x call Tee_GetUnit_Price];
					_actioncode	= format ["[%1] call Tee_BuyUnit;",_x];
					_action 	= player addAction [_text, AddActionCode,_actioncode];
					_ai_actionarray = _ai_actionarray + [_action];
				} forEach TW_AI_Shop_West;
				
				_ai_action = true;
			};
		} else {
			if(_ai_action && TW_playerside == "west") then {
				{
					player removeAction _x;
				} forEach _ai_actionarray;
				
				_ai_actionarray 	= [];
				_ai_action 		= false;
			};
		};
	
		
		
		//West Repair Station
		if((player distance hq_west) < 40 && _invehicle) then {//modif siskojay pour reparer
			if(TW_playerside == "west" && !_repairaction) then {
			
				//titleText["Repair Station", "PLAIN DOWN"];	//Msg
			
				//Repair
				_text 			= format [localize "STRS_action_repair",TW_Repair_Cost];
				_actioncode		= format ["[] spawn Tee_Sup_Repair;"];
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_repairactionarray = _repairactionarray + [_action];
				
				//Refuel
				_text 			= format [localize "STRS_action_refuel",TW_Sup_Fuel_Cost];
				_actioncode		= format ["[] spawn Tee_Sup_Refuel;"];
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_repairactionarray = _repairactionarray + [_action];
				
				//Reammo
				_text 			= format [localize "STRS_action_reammo",TW_Sup_Reammo_Cost];
				_actioncode		= format ["[] spawn Tee_Sup_Reammo;"];
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_repairactionarray = _repairactionarray + [_action];
				
				
				_repairaction		= true;
			};
		} else {
			if(_repairaction && TW_playerside == "west") then {
				{
					player removeAction _x;
				} forEach _repairactionarray;
				
				_repairactionarray 	= [];
				_repairaction 		= false;
			};
		};

		//*******************
		//East
		//*******************

		//East HQ
		if(player distance hq_east < 4 && !_invehicle && !(alive driver hq_east) && TW_Para_MobilBase) then {
			if(TW_playerside == "east" && !_hq_action) then {
			
				//Actions
				_text 			= format [localize "STRS_action_mobilzehq"];
				_actioncode		= format ["[%1] spawn Tee_Client_Base_DeMobHQ;"];
				_action = player addAction [_text, AddActionCode,_actioncode];
				_hq_actionarray = _hq_actionarray + [_action];
				
				_hq_action		= true;
			};
		} else {
			if(_hq_action && TW_playerside == "east") then {
				{
					player removeAction _x;
				} forEach _hq_actionarray;
				
				_hq_actionarray = [];
				_hq_action = false;
			};
		};
		
		
		//EastHQ SetUp
		if(player == driver hq_east) then {
				//Check Side
				if(TW_playerside != "east") then {
					moveOut player;
				};
				
				//Actions
				_text 			= format [localize "STRS_action_buildhq"];
				_actioncode		= format ["[%1] call Tee_Client_Base_HQ_setUp;"];
				_action = player addAction [_text, AddActionCode,_actioncode];
				_hq_actionarray = _hq_actionarray + [_action];
				
				_hq_action		= true;
		};
		
		
		//East Vehicle Shop
		if(player distance east_shop_veh < 3 && !_invehicle) then {
			if(TW_playerside == "east" && !_veh_s_action) then {
			
				titleText[localize "STRS_action_vehicelshop", "PLAIN DOWN"];	//Msg
			
				//Actions
				{
					_text 			= format [localize "STRS_action_buy",_x call Tee_GetVeh_Name,_x call Tee_GetVeh_Price];
					_actioncode		= format ["[%1] call Tee_CreateVehicle;",_x];
					_action = player addAction [_text, AddActionCode,_actioncode];
				
					_veh_s_actionarray = _veh_s_actionarray + [_action];
				} forEach TW_Vehicle_Shop_East;
				
				_veh_s_action		= true;
				
			};
		} else {
			if(_veh_s_action && TW_playerside == "east") then {
				{
					player removeAction _x;
				} forEach _veh_s_actionarray;
				_veh_s_action = false;
				_veh_s_actionarray = [];
			};
		};
		

		//East Weapon
		if((player distance east_shop_weapons) < 3 && !_invehicle) then {
			if(TW_playerside == "east" && !_weap_action) then {
			
				titleText[localize "STRS_action_weaponshop", "PLAIN DOWN"];	//Msg
			
				//Actions
				{
					_text 		= format [localize "STRS_action_buy",_x call Tee_GetWeap_Name,_x call Tee_GetWeap_Price];
					_weap_typ 	= _x call Tee_GetWeap_Typ;
										
					if(_weap_typ == "wep") then {
						_actioncode	= format ["[%1] call Tee_AddWeapon;",_x];
					};
					if(_weap_typ == "mag") then {
						_actioncode	= format ["[%1] call Tee_AddMag;",_x];	
					};
					
					_action 	= player addAction [_text, AddActionCode,_actioncode];
					_weap_actionarray = _weap_actionarray + [_action];
				} forEach TW_Weapon_Shop_East;
				
				_weap_action = true;
			};
		} else {
			if(_weap_action && TW_playerside == "east") then {
				{
					player removeAction _x;
				} forEach _weap_actionarray;
				
				_weap_actionarray 	= [];
				_weap_action 		= false;
			};
		};

		
		
		//East AI Shop
		if((player distance east_shop_ai) < 3 && !_invehicle) then {
			if(TW_playerside == "east" && !_ai_action) then {
			
				titleText[localize "STRS_action_aishop", "PLAIN DOWN"];	//Msg
			
				//Actions
				{
					_text 		= format [localize "STRS_action_buy",_x call Tee_GetUnit_Name,_x call Tee_GetUnit_Price];
					_actioncode	= format ["[%1] call Tee_BuyUnit;",_x];
					_action 	= player addAction [_text, AddActionCode,_actioncode];
					_ai_actionarray = _ai_actionarray + [_action];
				} forEach TW_AI_Shop_East;
				
				_ai_action = true;
			};
		} else {
			if(_ai_action && TW_playerside == "east") then {
				{
					player removeAction _x;
				} forEach _ai_actionarray;
				
				_ai_actionarray 	= [];
				_ai_action 		= false;
			};
		};
		
		
		
		//East Repair Station
		if((player distance hq_east) < 40 && _invehicle) then {
			if(TW_playerside == "east" && !_repairaction) then {
			
				//titleText["Repair Station", "PLAIN DOWN"];	//Msg
			
				//Repair
				_text 			= format [localize "STRS_action_repair",TW_Repair_Cost];
				_actioncode		= format ["[] spawn Tee_Sup_Repair;"];
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_repairactionarray = _repairactionarray + [_action];
				
				//Refuel
				_text 			= format [localize "STRS_action_refuel",TW_Sup_Fuel_Cost];
				_actioncode		= format ["[] spawn Tee_Sup_Refuel;"];
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_repairactionarray = _repairactionarray + [_action];
				
				//Reammo
				_text 			= format [localize "STRS_action_reammo",TW_Sup_Reammo_Cost];
				_actioncode		= format ["[] spawn Tee_Sup_Reammo;"];
				_action 		= player addAction [_text, AddActionCode,_actioncode];
				_repairactionarray = _repairactionarray + [_action];
				
				
				_repairaction		= true;
			};
		} else {
			if(_repairaction && TW_playerside == "east") then {
				{
					player removeAction _x;
				} forEach _repairactionarray;
				
				_repairactionarray 	= [];
				_repairaction 		= false;
			};
		};
		
		
	
		//End
		sleep 5;
	};
};
