/*
	Script written by TeeTime and garisat dont remove this comment
*/
///modif siskojay team kkz//
//Ideen
// ServicePoint Building : Military Cargo House V1 	(Cargo_House_V1_F)
// Baracks		 : Military Cargo HQ V1 	(Cargo_HQ_V1_F)
// ComandPost		 : Military Cargo OP V1 	(Cargo_Patrol_V1_F)!?! nicht sicher

//***********************************************************************
//Basic
//***********************************************************************

AddActionCode 	= compile preprocessFileLineNumbers "test.sqf";
if(isNil "HQ_placed") 			then {HQ_placed = false;};
TW_HQ_Placed_Client = false;
if(isNil "TW_ServerStarted") 	then {TW_ServerStarted = false;};
TW_Mission_End 		= false;
TW_TK_Counter		= 0;
TW_Player_Killed 	= "";
TW_Player_Kick 		= "";
TW_AI_Killed 		= "";

//TW_westplayer_array = [wp_1,wp_2,wp_3,wp_4,wp_5,wp_6,wp_7,wp_8,wp_9,wp_10,wp_11,wp_12,wp_13,wp_14];	//Not used
//TW_eastplayer_array = [ep_1,ep_2,ep_3,ep_4,ep_5,ep_6,ep_7,ep_8,ep_9,ep_10,ep_11,ep_12,ep_13,ep_14];	//Not used

TW_Vehicle_Client 	= [];	//List with player vehicle

TW_welcome_message =  composeText [
localize "STRS_welcome_1",
linebreak,
localize "STRS_welcome_2",
linebreak,
localize "STRS_welcome_3",
linebreak,
localize "STRS_welcome_4",
linebreak,
localize "STRS_welcome_5",
linebreak,
localize "STRS_welcome_6",
linebreak,
localize "STRS_welcome_7",
linebreak,
localize "STRS_welcome_8",
linebreak,
localize "STRS_welcome_9",
linebreak,
localize "STRS_welcome_end"
];

//***********************************************************************
//Server
//***********************************************************************

if(isServer) then {
	TW_Server_Restart 	= false;
	TW_Server_HQPos		= [];
};



//***********************************************************************
//Save System
//***********************************************************************

Tee_Save_GearArray = [];



//***********************************************************************
//Vote System
//***********************************************************************

TW_Voting		= false;	//Status only 1 vote can be active
TW_Vote_Time	= 45;		//Time to vote in seconds
TW_Vote_Start 	= [];		//["side","kind","Name"]
TW_Vote_Votes 	= [0,0];	//[Yes,No]
TW_Vote_Actions	= [];		//All Actions linked to a vote
TW_Vote_Result	= false;	//Result of the last Vote init by teh player the cariable is local to
	
	
//***********************************************************************
//Money System
//***********************************************************************

Tee_Money_Min		= 50 	* TW_Income;	//Income per Minute
Tee_Money_Town		= 75 	* TW_Income;	//Income per Town
Tee_Money_TownScout	= 300 	* TW_Income;	//Bonus for scouting a town as first
Tee_Money_TownCap	= 1500	* TW_Income;	//Bonus for taking a town
Tee_Konto 			= 2000 	* TW_Income;	//Startmoney

Tee_Money_Kill_Bonus	= 1000 	* TW_Income;	//Money for Playerkill
Tee_Money_AI_Kill_Bonus	= 200 	* TW_Income;	//Money for AI Kill
Tee_Money_TK_Punish		= 2000 	* TW_Income;	//TK Punishment


//************************************
//Base
//************************************

TW_Base_TownProtection	= 300;	//Distance in m in which you are not allowed to build a hq

TW_West_BaseMarker 		= "west_base";
TW_West_ShopMarker_V 	= "west_m_veh";	//Vehicle
TW_West_ShopMarker_G 	= "west_m_wp";
TW_West_ShopMarker_AI 	= "west_m_ai";

TW_East_BaseMarker 		= "east_base";
TW_East_ShopMarker_V 	= "east_m_veh";	//Vehicle
TW_East_ShopMarker_G 	= "east_m_wp";	//Weapon
TW_East_ShopMarker_AI 	= "east_m_ai";	//AI

TW_West_Respawn = "tw_west_respawn";
TW_East_Respawn = "tw_east_respawn";


TW_BasePosArray = [
["respawn_east",		"respawn_west"]///////////as enlever si jamais erreur siskojay

];


//******************************************
//Towns
//******************************************

TW_TownArray = [
//	Object			Marker			Name
	[base,			"town",			"Xiros Island"				],
	[base_1,		"town_1",		"Agia Marina Harbour"			],
	[base_2,		"town_2",		"Agia Military Camp"		],
	[base_3,		"town_3",		"Abandonned Village"		],
	[base_4,		"town_4",		"Antenna West"		],
	[base_5,		"town_5",		"Camp Rogain"					],
	[base_6,		"town_6",		"Kill Farm"						],
	[base_7,		"town_7",		"Antenna East"		],
	[base_8,		"town_8",		"Old Outpost"		 		],
	[base_9,		"town_9",		"Village South"			],
	[base_10,		"town_10",		"Air Station Mike-26"			],
	[base_11,		"town_11",		"Camp Tempest"					],
	[base_12,		"town_12",		"Camp Connor"					],
	[base_13,		"town_13",		"Mortar Camp"						],
	[base_14,		"town_14",		"Girna"							],
	[base_15,		"town_15",		"The Ruins"					],
	[base_16,		"town_16",		"Tsoukalia"					]
	];
	


TW_Town_CapDis 			= 35;	//Distance for taking a town
TW_Town_DecDis 			= 150;	//Distance for decteting who is owning the town
TW_Town_Taken			= [];
TW_Town_Taken_Server	= [];



TW_Town_StreetArray = [
//	Object			Roads to
	[base,			[base_6]	   							],
	[base_1,		[base_2,base_3,base_5,base_6]			],
	[base_2,		[base_1,base_3,base_4,base_5,base_6]	],
	[base_3,		[base_1,base_2,base_4]					],
	[base_4,		[base_2,base_3,base_8]					],
	[base_5,		[base_2,base_6,base_7]					],
	[base_6,		[base,base_1,base_2,base_5]				],
	[base_7,		[base_5,base_8,base_13]					],
	[base_8,		[base_4,base_7,base_13,base_10]			],
	[base_9,		[base_16,base_12,base_14,base_10]		],
	[base_10,		[base_8,base_15,base_9]					],
	[base_11,		[base_9,base_10,base_14,base_15]						],
	[base_12,		[base_14,base_9,base_16]				],
	[base_13,		[base_7,base_8]							],
	[base_14,		[base_9,base_11]						],
	[base_15,		[base_11,base_10]						],
	[base_16,		[base_9,base_14]		            	]
	];
	


//***********************************************************************
//Support and Supply
//***********************************************************************

TW_Repair_Cost = 350;
TW_Repair_Time = 30;

TW_Sup_Fuel_Cost = 200;
TW_Sup_Fuel_Time = 5;		//Time to fill up 10% of the tank

TW_Sup_Reammo_Cost = 600;
TW_Sup_Reammo_Time = 60;

TWB1_Reinforce_Cost = 15000;	// Town AI reinforcement price at flagpoles

//***********************************************************************

//Team Member
//***********************************************************************
// put PLAYERUID of team members in array
// will give same rights as the admin
// uncomment line below
TW_Teammembers = [
		"76561197979724311"	//Blue1
		];

//***********************************************
//Shop List Basic
//***********************************************

TW_Vehicle_Shop_West = [

303,
301,
302,
308,
309
];



TW_Vehicle_Shop_East = [
//Boxes
//61,62,63,64,66,//
//62,
//Bikes
//101,


307,
//304,

305,
306,
310,
311
];


TW_Vehicle_Shop_Town = [
//Box
50,60,52,62,

//Bikes
101,

//Boats

//Cars
304
];
//Trucks

//Tanks

//Air




TW_Weapon_Shop_West = [
//Boxes
//Rifle
//2302,
//2305,
//2561,
//carryall 2562,
//2607,
//2002,
//2308,
//2005,

//Pistol




//Sniper


//Rocket


//Explsoiv
//2601,
//2603,
//2605,
//2606,
//2607,
//2608,

//East Weapons
//2602,
//2604,

//Equipment
//2001,
//2002,
//2003,
//2004,
//2555,
//2556,
//2557,
//2558,
//2559,
//2560
];


TW_Weapon_Shop_East = [
//Boxes

//Equipment
//2001,

//2002,
//2003,
//2306,
//2307,
//2561,
//carryall2562,
//2607,
//2004,
//2002,
//2309,
//Explsoiv

//2601,
//2603,
//2602,
//2604,
//2605,

//2556,
//2554,
//2557,
//2558,
//2559,
//2560
//2005,

//Pistol


//Rifle
//2301,
//2306,

//Sniper


//Rocket



//2606,
//2607,
//2608
];


TW_AI_Shop_West = [
7001,
7002,
7003,
7004,
7005,
7006,
7007,
7008,
7009
];


TW_AI_Shop_East = [
6001,
6002,
6003,
6004,
6005,
6006,
6007,
6008,
6009
];



//***********************************************
//Shop List Addons
//***********************************************

if(TW_Addons_Active) then {
	TW_Vehicle_Shop_West = TW_Vehicle_Shop_West + [
	//Here you can add Addon Stuff
	
	];
	
	TW_Vehicle_Shop_East = TW_Vehicle_Shop_East + [
	//Here you can add Addon Stuff
	
	];

	TW_Vehicle_Shop_Town = TW_Vehicle_Shop_Town + [
	//Here you can add Addon Stuff
	
	];
	
	TW_Weapon_Shop_West = TW_Weapon_Shop_West + [
	//Here you can add Addon Stuff
	
	];

	TW_Weapon_Shop_East = TW_Weapon_Shop_East + [
	//Here you can add Addon Stuff
	];
	
	TW_AI_Shop_West = TW_AI_Shop_West + [
	//Here you can add Addon Stuff
	
	];
	
	TW_AI_Shop_East = TW_AI_Shop_East + [
	//Here you can add Addon Stuff
	
	];
};



//***********************************************
//Vehicle Weapons AI Item Arrays
//***********************************************


//Vehicle Array ID: 0 - 999 
Tee_Veh_Array = 
[
//	ID		Name 					Class 						Price							Needed Towns	"Typ"
//Weapon Boxes		
	[50,		"Nato Ammo Basic",		"Box_NATO_Ammo_F",		150 * vehicle_price,			0,			"Box"],
	[51,		"Nato Weapon Basic",		"Box_NATO_Wps_F",		400 * vehicle_price,			0,			"Box"],
	[52,		"Nato Grenades",		"Box_NATO_Grenades_F",		200 * vehicle_price,			0,			"Box"],
	[53,		"Nato Ordnance",		"Box_NATO_AmmoOrd_F",		150 * vehicle_price,			0,			"Box"],
	[54,		"Nato Specialweapons",		"Box_NATO_WpsSpecial_F",	800 * vehicle_price,			0,			"Box"],
	[55,		"Nato Supply Crate",		"B_supplyCrate_F",		250 * vehicle_price,			0,			"Box"],	
	[56,		"Nato Support",			"Box_NATO_Support_F",		150 * vehicle_price,			0,			"Box"],
	[60,		"East Ammo Basic",		"Box_East_Ammo_F",		150 * vehicle_price,			0,			"Box"],
	[61,		"East Weapon Basic",		"Box_East_Wps_F",		400 * vehicle_price,			0,			"Box"],
	[62,		"East Grenades",		"Box_East_Grenades_F",		200 * vehicle_price,			0,			"Box"],
	[63,		"East Ordnance",		"Box_East_AmmoOrd_F",		150 * vehicle_price,			0,			"Box"],
	[64,		"East Specialweapons",		"Box_East_WpsSpecial_F",	800 * vehicle_price,			0,			"Box"],
	[65,		"East Supply Crate",		"B_supplyCrate_F",		150 * vehicle_price,			0,			"Box"],	
	[66,		"East Support",			"Box_East_Support_F",		150 * vehicle_price,			0,			"Box"],
	
	//Bike
	[101,		"Quad",				"O_Quadbike_01_F",			200 * vehicle_price,			0,			"Bike"],

	
	//Boat
	//[201,		"Quad",				"B_Quadbike_F",				250 * vehicle_price,			0,			"Boat"],
	
	//Car
	[301,		"Hunter",			"B_MRAP_01_F",					2000 * vehicle_price,			0,			"Car"],
	[302,		"Hunter GMG",			"B_MRAP_01_gmg_F",			17000 * vehicle_price,			0,			"Car"],
	[303,		"Hunter HMG",			"B_MRAP_01_hmg_F",			8000 * vehicle_price,			0,			"Car"],
	[304,		"Pick Up Jeep",			"C_Offroad_01_F",				500 * vehicle_price,			0,			"Car"],
	[305,		"Ifrit",			"O_MRAP_02_F",					2000 * vehicle_price,			0,			"Car"],
	[306,		"Ifrit GMG",			"O_MRAP_02_gmg_F",			17000 * vehicle_price,			0,			"Car"],
	[307,		"Ifrit MG",			"O_MRAP_02_hmg_F",				8000 * vehicle_price,			0,			"Car"],
	[308,		"HEMTT Transport",			"B_Truck_01_covered_F",			3500 * vehicle_price,			0,			"Car"],
	[309,		"AMV-7 Marshall",	"B_APC_Wheeled_01_cannon_F",	16000 * vehicle_price,			0,			"Car"],
	[310,		"MSE-3 Marid",	"O_APC_Wheeled_02_rcws_F",			16000 * vehicle_price,			0,			"Car"],
	[311,		"Zamak Tansport",	"O_Truck_02_covered_F",				3500 * vehicle_price,			0,			"Car"],

	
	//Truck
	//[401,		"Hunter",			"MRAP_01_base_F",				1000 * vehicle_price,			0,			"Truck"],
	
	//Tank
	//[501,		"Hunter",			"MRAP_01_base_F",				1000 * vehicle_price,			0,			"Tank"],
	
	//Air
	[601,		"AH 9 Armed",			"B_Heli_Light_01_armed_F",			40000 * airvehicle_price,		0,			"Air"],
	[602,		"MH 9 Transport",		"B_Heli_Light_01_F",				14000 * airvehicle_price,		0,			"Air"],
	[603,		"KA 60 Transport",		"O_Heli_Light_02_unarmed_F",			14000 * airvehicle_price,		0,			"Air"],
	[604,		"KA 60 Armed",		  	"O_Heli_Light_02_F",				40000 * airvehicle_price,		0,			"Air"]
	
];


//Addon Vehicles ID: 1000 - 1999
if(TW_Addons_Active) then {
	Tee_Veh_Array = Tee_Veh_Array + [
	//	ID		Name 					Class 						Price							Needed Towns	Typ
	
	//Bike
	//[1101,		"Quad",				"B_Quadbike_F",				250 * vehicle_price,			0,			"Bike"],

	
	//Boat
	//[1201,		"Quad",				"B_Quadbike_F",				250 * vehicle_price,			0,			"Boat"],

	
	//Car
	//[1301,		"Hunter",			"B_Hunter_F",				1000 * vehicle_price,			0,			"Car"],
	
	//Truck
	//[1401,		"Hunter",			"B_Hunter_F",				1000 * vehicle_price,			0,			"Truck"],
	
	//Tank
	//[1501,		"Hunter",			"B_Hunter_F",				1000 * vehicle_price,			0,			"Tank"],
	
	//Air
	//[1601,		"AH 9",				"B_AH9_F",				15000 * airvehicle_price,		0,			"air"],
	
	
	//End
	[1999,			"EndDummy",			"B_AH9_F",				0 * airvehicle_price,			999,		"Dummy"]
	];
};



//Weapon and Mag Array ID: 2000 - 3999
Tee_Weapon_Array = [
//	ID			Name 								Class 									Price							Needed Towns	Kind
	//Equipment
	[2001,		"GPS",							"ItemGPS",							350 * weapon_price,				0,				"wep"		],
	[2002,		"Medikit",					"Medikit",							500 * weapon_price,				0,				"wep"		],
	[2003,		"Medikit 2",				"MedikitItem",					450 * weapon_price,				0,				"wep"		],
	
	[2004,		"Smoke Shell",							"SmokeShell",								50 * weapon_price,				0,				"mag"		],
	[2005,		"MineDetector",							"MineDetector",							500 * weapon_price,				0,				"wep"		],
	[2555,		"Chemlight Blue",						"Chemlight_blue",						25 * weapon_price,				0,				"mag"		],
	[2556,		"Chemlight Yellow",					"Chemlight_yellow",					25 * weapon_price,				0,				"mag"		],
	[2554,		"Chemlight Red",						"Chemlight_red",						25 * weapon_price,				0,				"mag"		],
	[2557,		"Flare 40mm Red",						"UGL_FlareRed_F",						125 * weapon_price,				0,				"mag"		],
	[2558,		"Flare 40mm Green",					"UGL_FlareGreen_F",					125 * weapon_price,				0,				"mag"		],
	[2559,		"Flare 40mm Yellow",				"UGL_FlareYellow_F",				125 * weapon_price,				0,				"mag"		],
	[2560,		"Flare 40mm White",					"UGL_FlareWhite_F",					125 * weapon_price,				0,				"mag"		],
	[2561,		"40mm HE Grenade Round",		"1Rnd_HE_Grenade_shell",		125 * weapon_price,				0,				"mag"		],
	[2562,		"Carryall Backpack",				"B_Carryall_ocamo",					2500 * weapon_price,			0,				"wep"		],
	//Pistol
	
	//Rifle
	
	//Sniper
	[2301,		"Khaybar ACO F",		"arifle_Khaybar_ACO_point_F",	1250 * weapon_price,			0,				"wep"		],
	[2302,		"MX F",					"arifle_MX_F",					1250 * weapon_price,			0,				"wep"		],

	[2303,		"30Rnd 556x45 Stanag",	"30Rnd_556x45_Stanag",			25 * weapon_price,				0,				"mag"		],
	[2304,		"30Rnd 65x39 Case",	"30Rnd_65x39_case_mag",			25 * weapon_price,				0,				"mag"		],
	[2305,		"30Rnd 65x39 Stanag",	"30Rnd_65x39_caseless_mag",		25 * weapon_price,				0,				"mag"		],
	[2306,		"30Rnd 65x39 caseless",	"30Rnd_65x39_caseless_green",		25 * weapon_price,				0,				"mag"		],
	[2307,		"7.62mm 20Rnd Mag",	"20Rnd_762x51_Mag",			100 * weapon_price,				0,				"mag"		],
	[2308,		"LRR 7Rnd .408 Mag",	"7Rnd_408_Mag",			100 * weapon_price,				0,				"mag"		],
	[2309,		"GM6 5Rnd 127x108 Mag",	"5Rnd_127x108_Mag",			100 * weapon_price,				0,				"mag"		], 
	//MG
	
	//Rocket
	
	//Explosivs
	[2601,		"NLAW (Launcher)",			"launch_NLAW_F",					4500 * weapon_price,			0,				"wep"		],
	[2602,		"RPG32 (Launcher)",			"launch_RPG32_F",					4500 * weapon_price,			0,				"wep"		],	
	
	[2603,		"NLAW Rocket",		"NLAW_F",							700 * weapon_price,				0,				"mag"		],
    	[2604,		"RPG32 AA Rocket",	"RPG32_AA_F",							1000 * weapon_price,				0,				"mag"		],
	[2605,		"RPG32 Rocket",		"RPG32_F",							700 * weapon_price,				0,				"mag"		],
	[2606,		"AT Mine",		"ATMine_Range_Mag",					250 * weapon_price,				0,				"mag"		],
	[2607,		"HandGrenade",		"HandGrenade",						75 * weapon_price,				0,				"mag"		],
	[2608,		"Claymore Mine",	"ClaymoreDirectionalMine_Remote_Mag",			200 * weapon_price,			0,				"mag"		],
	
	
	//End
	[3999,		"HandGrenade",		"HandGrenade",						125 * weapon_price,				999,			"mag"		]
];



//Addon Weapon and Mag Array ID: 4000 - 5999
if(TW_Addons_Active) then {
	Tee_Weapon_Array = Tee_Weapon_Array + [
	//	ID			Name 					Class 							Price							Needed Towns	Kind
	//Equipment
	 [4001,		"GPS",					"ItemGPS",						50 * weapon_price,				0,				"wep"		],
	
	//Pistol
	
	//Rifle
	
	//Sniper
	[4301,		"Khaybar ACO F",		"arifle_Khaybar_ACO_point_F",	1250 * weapon_price,			0,				"wep"		],

	//MG
	
	//Rocket
	
	//Explosivs
	[4601,		"NLAW F",			"launch_NLAW_F",					2500 * weapon_price,			0,				"wep"		],

	
	//End
	[5999,		"HandGrenade",		"HandGrenade",						125 * weapon_price,				0,				"mag"		]
	];
};



//AI Array
Tee_AI_Array = [
//	ID			Name 							Class 						Price						Needed Towns		Side
	//East
	[6001,		"Assaulter (east)",				"O_Soldier_F",				500 * ai_price,				0,			"east"		],
	[6002,		"Medic (east)",					"O_medic_F",				1000 * ai_price,				0,			"east"		],
	[6003,		"Assaulter AT (east)",				"O_Soldier_LAT_F",			1200 * ai_price,				0,			"east"		],
	[6004,		"Sniper (east)",				"O_soldier_M_F",			2000 * ai_price,				0,			"east"		],
	[6005,		"Assaulter MG (east)",				"O_Soldier_AR_F",			1500 * ai_price,				0,			"east"		],
	[6006,		"Grenadier (east)",				"O_Soldier_GL_F",			400 * ai_price,				0,			"east"		],
	[6007,		"Repair Specialist (east)",			"O_soldier_repair_F",			1000 * ai_price,			0,			"east"		],
	[6008,		"Explosives Specialist (east)",			"O_soldier_exp_F",			600 * ai_price,				0,			"east"		],
	[6009,		"Anti Air Specialist (east)",			"O_Soldier_AA_F",			1000 * ai_price,				0,			"east"		],

	
	
	//West
	[7001,		"Assaulter (west)",				"B_Soldier_F",				500 * ai_price,				0,			"west"		],
	[7002,		"Assaulter MG (west)",				"B_soldier_AR_F",			1500 * ai_price,				0,			"west"		],
	[7003,		"Medic (west)",					"B_medic_F",				1000 * ai_price,				0,			"west"		],
	[7004,		"Assaulter AT (west)",				"B_soldier_LAT_F",			2000 * ai_price,				0,			"west"		],
	[7005,		"Repair Specialist (west)",			"B_soldier_repair_F",			1000 * ai_price,			0,			"west"		],
	[7006,		"Grenadier (west)",				"B_Soldier_GL_F",			400 * ai_price,				0,			"west"		],
	[7007,		"Sniper (west)",				"B_soldier_M_F",			2000 * ai_price,				0,			"west"		],
	[7008,		"Explosives Specialist (west)",			"B_soldier_exp_F",			600 * ai_price,				0,			"west"		],
	[7009,		"Anti Air Specialist (west)",			"B_Soldier_AA_F",			1000 * ai_price,				0,			"west"		],
	
	//Resistance
	
	//Civilian
	[9001,		"Civ",							"C_man_1",					150 * ai_price,				0,			"civ"		],
	[9002,		"Civ 1",						"C_man_polo_1_F",			150 * ai_price,				0,			"civ"		],
	[9003,		"Civ 2",						"C_man_polo_2_F",			150 * ai_price,				0,			"civ"		],
	[9004,		"Civ 3",						"C_man_polo_3_F",			150 * ai_price,				0,			"civ"		],
	
	//Independent
	[9005,		"Ind AT",							"i_soldier_at_f",					150 * ai_price,				0,			"civ"		],
	[9006,		"Ind SL",							"i_soldier_sl_f",					150 * ai_price,				0,			"civ"		],
	[9007,		"Ind RM",							"i_soldier_f",					150 * ai_price,				0,			"civ"		],
	[9008,		"Ind RML",							"i_soldier_lite_f",					150 * ai_price,				0,			"civ"		],
	
	
	//End
	[9999,		"Rifleman (west)",				"B_soldier_LAT_F",			250 * ai_price,				999,			"west"		]
];



//Addon Weapon and Mag Array ID: 10000 - ?
if(TW_Addons_Active) then {
	Tee_AI_Array = Tee_AI_Array + [
	//	ID			Name 					Class 							Price							Needed Towns	Kind

	//End
	[11999,		"Rifleman (west)",				"B_soldier_LAT_F",			250 * ai_price,				999,			"west"		]
	];
};