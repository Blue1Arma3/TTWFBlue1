/*
	Script written by TeeTime dont remove this comment
*/
///modif siskojay team kkz//
//Functions
Tee_HC_Init = {
	diag_log "Report: HC Init Started";
	
	//Swicht HC Into HC Object
	selectPlayer Teetime;
	
	//Variablen
	TW_HC_ClientSlot = player;
	publicVariable "TW_HC_ClientSlot";
	
	//Stellt den HC kalt
	player setVehicleInit "this allowDamage false;";
	["{this allowDamage false;}","BIS_fnc_spawn",player,true] spawn BIS_fnc_MP;
	player attachTo [base,[0,0,-10]];

	//Eventhandler
	"TW_Town_Taken_Server" addPublicVariableEventHandler {
		TW_Town_Taken_Server spawn Tee_Server_Town_CreateAIDef;
		TW_Town_Taken_Server spawn Tee_Server_Town_Repair;
	};

	"TW_Mission_End" addPublicVariableEventHandler {
		if(TW_restart) then {
			[] call Tee_HC_Restart;
		} else {
			endMission "END1";
		};
	};
	
	diag_log "Report: HC Init Finished";
};


/*
	Init Variables and Values for choosen gamemode
*/
Tee_HC_Init_Values = {
	private ["_i","_value","_array"];
	
	//Towns
	_array = [];
	TW_Para_Towns = TW_Para_Towns min (count TW_TownArray);	//Catch wrong input
   //for "_i" from 0 to TW_Para_Towns step 1 do {
	for [{_i=0},{_i<TW_Para_Towns},{_i=_i+1}] do {
		_array = _array + [TW_TownArray select _i];
	};
	TW_TownArray = _array;
	
	//Mehr
	_array = [];
	
	
	
	//End
	diag_log "Report: HC Values updated";
};



//********************************************
//Towns
//********************************************

Tee_HC_CreateTownDefense = {
	private ["_object","_markername","_text","_marker"];
	{
		_object 	= _x select 0;
		_text		= _x select 2;
		
		//Init Def
		[_object] spawn Tee_Server_Town_InitAIDef;
		
		if(debug) then {player groupChat "AI Def HC Spawn";};
		diag_log format ["Report: HC Defense created for %1",_text];
		sleep 1;
	} forEach TW_TownArray;
};



//**********************************************
//Server Functions and Loops
//**********************************************


/*
	For a Restart without a Restart
*/
Tee_HC_Restart = {

	//Towns
	[] spawn Tee_HC_CreateTownDefense;

	//End
	diag_log "Report: HC Restart finished";
};
