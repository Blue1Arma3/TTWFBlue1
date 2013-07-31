/*
	Script written by TeeTime dont remove this comment
	///modif siskojay team kkz//
	All Functions linked to Groups
	
	STRS_action_grp_leave, "Leave Group", "Gruppe verlassen"
STRS_action_grp_join, "Join Player Group", "Gruppe des Spielers beitreten"
STRS_buy_ai_notleader, "Only the group leader can buy AI!", "Nur der Gruppenleiter kann KI Einheiten kaufen!"
	
*/


/*
	Called in player Init
*/
Tee_Grp_Init = {
	private ["_group"];
	
	//Reset Group after Connecting
	if(leader (group player) != player) then {
		[] call Tee_Grp_Leave;
	};
};



/*
	Let the Player join to the group a another player
	
	[playerobject] call Tee_Grp_Join;
*/
Tee_Grp_Join = {
	private ["_target"];
	
	_target = _this select 0;
	
	if(! isPlayer _target) exitWith {};
	[player] join (group _target);
	
};



/*
	Let the Player leave his current group and put him in a own group
	
	[playerobject] call Tee_Grp_Leave;
*/
Tee_Grp_Leave = {
	private ["_player","_group"];
	
	_player = _this select 0;
	_group 	= createGroup side _player;
	[_player] joinSilent _group;	
};