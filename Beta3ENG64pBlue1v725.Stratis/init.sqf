/*
	Script written by TeeTime dont remove this comment
	///modif siskojay team kkz//
	To Do
	
		AI Level mit parameter anpassen
		Code:
			{_x setSkill ["aimingaccuracy", 0.3];} forEach units groupname;

		Parameter für Town Rebuilt
		Parameter Clean Up
		
		Fahrzeug Spawn
		Lock/Unlock Elite Fixen

		AI spawn überarbeiten
		Shop System
		
		HC
			Slot Protection einfügen
		
		Squad System
			-Was tun mit KI die man vor Wechsel gekauft hat? Töten oder in Reserve halten?
			-Namen von Squad Mitgliedern anziegen
			-Sondermarker für Teamleader
			-Auf Karte eigene Farbe für Squadmitglieder
			-Leader Möglichkeit geben Leute abzulehnen

		High Command
			-West/Ost Fahrer aus feindlichem HQ schmeißen
			-Var angelegt
	
		MobileHQ bis 650
		Respawn bis 700
	
	Added:

	
		
	Fixed:
		possibily to join enemy groups
	
	Changed:

	
	Prüfen:
		-Fahrzeug lock
		- Kick Player nach TK testen
		Wird AI nach Disc gekillt?
		Werden Repairstation Actiosn bagebroche nwenn man sich bewegt
		-Wenn man die Mission mit Veteran Schwierigkeit startet, können weder blufor noch opfor ihre Fahrzeuge aufsperren.
		
		
	Idee:
		-UPSON?
		- Zweitbase (FOB) kann mit einem Speziellen Fahrzeug (hoher Preis) gebaut werden. Mainbase dafür weiter auseinander und wie gesagt, der feindlichen Base auf der Map gegenüber liegend.
	
	Bugs:
		-KI Soldaten und Resistance (Civis) bekämpfen sich nicht.	KeinFix
		-Ab und zu verliert man ohne etwas zu tun, die Kontrolle über seine KI Kollegen.
		-Ab und zu kann man den Basemarker der feindlichen Fraktion auf der Map sehen, dafür aber nicht seinen eigenen.
		
	Parameter:
		-Wetter

		-Kaufen von KI an "Towncenter"
		-Kaufen von Munition an "Towncenter"
		-Respawn an "Towncenter": enabled, disabled
		-3D Sicht blockieren
		-Respawnzeit

		-Armed Cars: enabled, disabled
		-AI Spieler statt Spieler
		-Startresourcen (500, 1000, 2000, 5000, 10000, 20000, 50000)
*/
finishMissionInit;
enableSaving [false,false];

if(isServer) then { X_Server = true;} else { X_Server = false;};
if(!isDedicated) then { X_Client = true;} else { X_Client = false;};

west setFriend [resistance, 0];
west setFriend [civilian, 0];

east setFriend [resistance, 0];
east setFriend [civilian, 0];

resistance setFriend [WEST, 0];
resistance setFriend [EAST, 0];

civilian setFriend [WEST, 0];
civilian setFriend [EAST, 0];

skipTime ((paramsArray select 0) - daytime + 24 ) % 24;
setViewDistance (paramsArray select 1);
setTerrainGrid (paramsArray select 2);

waitUntil { (( (time > 1) && (alive player)) || X_Server ) };


//Mission Variables
debug 				= if(X_Server && X_Client && name player == "TWHC") then {true} else {false};
TW_restart			= if((paramsArray select 3) == 1) then {true} else {false};	//Restarts Mission without a Restart
TW_roundtime		= (paramsArray select 9);									//Time Limit for each round
TW_Addons_Active	= false;

TW_Para_Towns		= (paramsArray select 10);	//How many Towns can be caped
TW_Para_MobilBase	= false;	//if((paramsArray select 11) == 1) then {true} else {false};Static or Mobil Bases true = mobil false = static
TW_Para_satintel	= if((paramsArray select 12) == 1) then {true} else {false};	//Satelite intelligence on/Off with "On" towns must not be scouted


TW_BoxShop			= false;	//Shop menu will be replaced with the ability to create weapon Boxes
TW_vehicles			= if((paramsArray select 17) == 1) then {true} else {false};		//Can Vehicles be bought
TW_air				= if((paramsArray select 6) == 1) then {true} else {false};		//Can Air be bought
TW_ai				= if((paramsArray select 7) == 1) then {true} else {false};		//Can AI be bought

TW_Income			= (paramsArray select 8) / 100;		//0.5= 50% 1 = 100% 2= 200%		Effect Startmoney and all Income
weapon_price		= 1;		//
vehicle_price		= 1;		//
airvehicle_price	= 1;		//
ai_price			= 1;		//

TW_AI_Def_lvl		= (paramsArray select 4);	//AI Guards level normal is 1 -> 6 men
TW_AI_max			= (paramsArray select 5);	//Max AI ammount per player
TW_AI_Patrols		= if((paramsArray select 16) == 1) then {true} else {false};	//Will the AI Def stay static or will they randome patrol?

TW_Strategic_Street	= if((paramsArray select 18) == 1) then {true} else {false};


//Headless Client Variables HC Functions are defined in the Serverfunctions	
//HC must be on the Server at mission Start!!
TW_HC_Array		= ["Off","TWHC","BierAIG_HC","HC01"];
TW_HC_Activ		= if((paramsArray select 13) != 0) then {true} else {false};		//Set to true if you want to use HC
TW_HC_ID		= TW_HC_Array select (paramsArray select 13);	//PlayerID OR Playername of the Headless Client
TW_HC_Client	= if((((getPlayerUID player) == TW_HC_ID) || (name player == TW_HC_ID)) && TW_HC_Activ) then {true} else {false};	//Will be set to true if the Client is the HC
TW_HC_ClientSlot = objNull;	//Will be the playerobject who is the HC


//try it out
TW_HC_Def_AI = true; // switch HC on/off



TW_Skill_AICiv		= (paramsArray select 19) /100; 	//Skill Civil
TW_Skill_AIDef		= (paramsArray select 20) /100;		//Skill Army Defense
TW_Skill_AIOff		= (paramsArray select 21) /100;		//Skill Army offense

//Functions and Variables
[] call compile preprocessFileLineNumbers "variablen.sqf";
[] call compile preprocessFileLineNumbers "functions.sqf";
[] call compile preprocessFileLineNumbers "functions_action.sqf";
[] call compile preprocessFileLineNumbers "functions_ai.sqf";
[] call compile preprocessFileLineNumbers "functions_group.sqf";
[] call compile preprocessFileLineNumbers "weaponArrays.sqf"; //Gunstore Weapon List - Gun Store Base List

// init for softProtect, by fred41
[] call compile preprocessFileLineNumbers "softProtect\softProtectInit.sqf";

if(X_Server || (TW_HC_Client && TW_HC_Activ)) then {	
	[] call compile preprocessFileLineNumbers "functions_server.sqf";
	[] call compile preprocessFileLineNumbers "functions_HC.sqf";
};

// init revive
if((paramsArray select 22) == 1) then {call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";}; // uninitialized variable _obj ???

if(X_Server) then {[] execVM "server\init.sqf";};// 

if(X_Client) then {
	//mission message
	[TW_welcome_message,"Blue1s Teetime Warfare",nil,true] spawn BIS_fnc_guiMessage;

	//init loadout
	getLoadout = compile preprocessFileLineNumbers 'loadout\fnc_get_loadout.sqf';
	setLoadout = compile preprocessFileLineNumbers 'loadout\fnc_set_loadout.sqf';

	//Wipe Group.
	if(count units group player > 1) then
	{  
		diag_log "Player Group Wiped";
		[player] join grpNull;    
	};

	execVM "briefing.sqf";
};


//Server
if(X_Server) then {

	if(isDedicated || debug) then {diag_log "Report: ServerInit Started";};

	//Basic
	[] call Tee_Server_Init;
	[] call Tee_Server_Init_Values;
	if(!TW_HC_Activ) then {
		[] spawn Tee_Server_CleanUp;
	};
	
	[] execVM "cleanUp.sqf"; // cleanUp, fred41

	//Towns
	[] call Tee_Server_CreateTownMarker;

	//Base
	//[] call Tee_Server_Base_Set_Base;
	[] call Tee_Server_Base_Build_West;
	[] call Tee_Server_Base_Build_East;
	
	HQ_placed = true;
	publicVariable "HQ_placed";
	
	// nur debug um object-stau zu erforschen, schnelle log-partition !!!!
/*	[] spawn {
		while{true} do { 
			sleep 1200; // 20 min
			{
				diag_log format ["obj: %1", typeOf _x];
			} foreach allMissionObjects "";
		};
	};
*/
	
	if(isDedicated || debug) then {diag_log "Report: ServerInit Done";};
};


//HC
if(TW_HC_Client) then {
	//Basic
	[] call Tee_HC_Init;
	[] call Tee_HC_Init_Values;
	[] spawn Tee_Server_CleanUp;
	
	//Towns
	[] spawn Tee_HC_CreateTownDefense;
};


//Clients
if(X_Client) then {
	[] call Tee_Init_Client;
	[] call Tee_Player_Init_Values;

	//Base
	[] call Tee_Base_Create_Marker;
	
	//Town
	[] call Tee_Client_CreateTownMarker;
	
	//Loops
	[] spawn Tee_MoneyLoop;
	[] spawn Tee_AttackTown;
	[] spawn Tee_ActionLoop;
	[] spawn Tee_PlayerMarker_Loop;

	//Player specific
	[] spawn Tee_SetPlayer;

	
	//Initial save gear
	loadout = [player] call getLoadout;		
};

if(isDedicated || debug) then {diag_log "Report: Init Done";};
[] execVM "client\init.sqf";