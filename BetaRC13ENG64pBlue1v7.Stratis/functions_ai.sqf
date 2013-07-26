/*
	Script written by TeeTime dont remove this comment
	///modif siskojay team kkz//
	All Functions linked to AI leading etc
*/


Tee_AI_Killed = {
	private ["_victim","_killer","_side","_pos"];
	
	_victim = _this select 0;
	_killer = _this select 1;
	
	_side	= side (group _victim);
	_pos	= getPos _victim;
	
	if(isPlayer _killer) then {
		TW_AI_Killed = [_victim,_killer,_side,_pos];
		publicVariable "TW_AI_Killed";
	};
	
	//For selfhosted Missions
	if(isServer && isPlayer _killer) then {
		TW_AI_Killed call Tee_AI_Killed_Pub;
	};
};



Tee_AI_Killed_Pub = {
	private ["_victim","_killer","_side","_text"];
	
	_victim = _this select 0;
	_killer = _this select 1;
	_side	= _this select 2;
	
	//Bonus
	if(player == _killer && playerside != _side) then {
		Tee_Konto = Tee_Konto + Tee_Money_AI_Kill_Bonus;
		player groupchat format ["You got %1$ for killing an AI.",Tee_Money_AI_Kill_Bonus]; 	//Msg
	};
	
	//Punish auch für AI Kills?
	if(player == _killer && playerside == _side) then {
		//Punish
		(Tee_Money_TK_Punish / 4) call Tee_Money_Substract;
		_text = format ["You killed a Teammember and lost %1$",(Tee_Money_TK_Punish / 4)];
		titleText[_text, "PLAIN DOWN"];	//Msg
		
	};
};




//TeeTimes Warfare AICityDef WPGenerator
//Autor: Cthulhu
//Version: 0.1
//Beschreibung: Erstellt eine durch eine Variable definierte Anzahl an Wegpunkten für eine Gruppe und lässt die Gruppe diese abgehen.
//
//Parameter:	Variable	Format
//				_guard		Gruppe		
//				_pos		Position
//
//Bsp:			[group player,position player] call fnc_AIDef_CreateWaypoints;
//
//
//x steht für beliebigen präfix
//Benötigte Variablen
//	name					Format		Funktion
//	x_AIDef_WP_Radius		Zahl		Radius, der Verteidigt werden soll
//	x_AIDef_WP_Count        Zahl		Anzahl der WP basiert auf 1 (wenn x_AIDef_WP_Count=5, werden 5 Wegpunkte erstellt)
//	x_AIDef_WP_Behaviour	String		http://community.bistudio.com/wiki/setWaypointBehaviour		
//	x_AIDef_WP_CombatMode	String		http://community.bistudio.com/wiki/setWaypointCombatMode	
//	x_AIDef_WP_Formation	String		http://community.bistudio.com/wiki/setWaypointFormation		
//	x_AIDef_WP_Speed		String		http://community.bistudio.com/wiki/setWaypointSpeed			
//	x_AIDef_WP_Type			String		http://community.bistudio.com/wiki/setWaypointType
//
//<-------------------------------------------------------------------------------------------------->

x_AIDef_WP_Radius		=	235;			//	Radius, der Verteidigt werden soll
x_AIDef_WP_Count    	=   5;			//	Anzahl der WP basiert auf 1 (wenn x_AIDef_WP_Count=5, werden 5 Wegpunkte erstellt)
x_AIDef_WP_Behaviour	=	"SAFE"; 	//	http://community.bistudio.com/wiki/setWaypointBehaviour		
x_AIDef_WP_CombatMode	=	"RED";		//	http://community.bistudio.com/wiki/setWaypointCombatMode	
x_AIDef_WP_Formation	=	"LINE";		//	http://community.bistudio.com/wiki/setWaypointFormation		
x_AIDef_WP_Speed		=	"NORMAL";	//	http://community.bistudio.com/wiki/setWaypointSpeed			
x_AIDef_WP_Type			=	"MOVE";		//	http://community.bistudio.com/wiki/setWaypointType

CT_AI_CreateWaypoints = {
	//Funktion erstellt wegpunkt, returns: Array format [Gruppe,WegpunktID]
	//_guard		Gruppe
	//_pos			Position		
	//
	private ["_guard","_pos","_waypoint","_wp","_wp1","_wp1_pos","_pos"];
	
	_guard=			_this select 0;
	_pos= 			_this select 1;
	_wp=			[];
	
	if(count (waypoints _guard) == x_AIDef_WP_Count && x_AIDef_WP_Count > 1 ) then  {
		//_wp1		=	(waypoints _guard) select 1;		//Erster Wegpunkt der Gruppe
		_wp1_pos	=	 _pos;
		if(isserver) then {diag_log format["Report: wp1 %1 ", _wp1_pos];};
		_waypoint	= 	_guard addwaypoint [_wp1_pos,0];	//Erstellen des Letzten wegpunktes == position des ersten (wegen cycle)
		_wp			=	[_guard,x_AIDef_WP_Count];

	} else {
		_waypoint= 		_guard addwaypoint [_pos,x_AIDef_WP_Radius];
		_wp=			[_guard,(count waypoints _guard)-1];
		if(isserver) then {diag_log format["Report: wp %1 - waypoint: %2 ",getWPPos _wp,(count waypoints _guard)-1 ];};
	};
	
	if((_wp select 1)== x_AIDef_WP_Count) then {
		_wp setwaypointtype "CYCLE";

	} else {
		_wp setwaypointtype x_AIDef_WP_Type;
	};
		
	_wp setWaypointBehaviour x_AIDef_WP_Behaviour;	
	_wp setWaypointCombatMode x_AIDef_WP_CombatMode;
	_wp setWaypointFormation x_AIDef_WP_Formation;
	_wp setWaypointSpeed x_AIDef_WP_Speed;
};



CT_AI_Addwaypoints = {
	private ["_x","_guard","_pos"];

	_guard=	_this select 0;
	_pos= _this select 1;
	
	for [{_x=1},{_x<=x_AIDef_WP_Count},{_x=_x+1}] do
	{
		[_guard,_pos] call CT_AI_CreateWaypoints;
	};
};