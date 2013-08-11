if(isServer) then {
	[] call compile preprocessFileLineNumbers "softProtect\softProtectServerInit.sqf";
};

if(!isDedicated) then {
	[] call compile preprocessFileLineNumbers "softProtect\softProtectClientInit.sqf";
};