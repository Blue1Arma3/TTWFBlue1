//	@file Version: 1.0
//	@file Name: broadcaster.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

if(!X_Server) exitWith {};

private ["_startTime","_dateStamp"];

_dateStamp = Date;
currentDate = _dateStamp;
publicVariable "currentDate";
_startTime = time;

currentInvites = [];

while{true} do
{	
	if(time - _startTime > 900) then  {
	    	_dateStamp = Date;
      	_dateStamp set [4, _dateStamp select 4];
      	setDate _dateStamp;
		currentDate = _dateStamp;
		publicVariable "currentDate";
		_startTime = time;    
 	};

	publicVariable "currentInvites";	// kein eventhandler vorhanden

	sleep 10;
};