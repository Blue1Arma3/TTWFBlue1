//	@file Version: 2
//	@file Name: config.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap

                                                                                                
//Gunstore Weapon List - Gun Store Base List
// Text name, classname, buy cost, sell amount
weaponsArray = [
		//Handgun
	["P07","hgun_P07_F",40,40],
    ["Rook-40","hgun_Rook40_F",40,40], 
	["ACP-C2","hgun_acpc2_f",40,40],
    	//Underwater Gun
	["SDAR (underwater)","arifle_SDAR_F",50,20],
    	//Assault Rifle
	["TRG-21","arifle_TRG21_F",3000,50],
    ["TRG-20","arifle_TRG20_F",3000,50],
	["MX","arifle_MX_F",3000,50],
    ["MXC","arifle_MXC_F",3000,50],
	["MXM","arifle_MXM_F",3000,100], 
	
	["Mk20","arifle_mk20_f",3000,100],
	["Mk20C","arifle_mk20c_f",3000,100],
	["Mk20 EGLM","arifle_mk20_gl_f",3000,100],
    ["Katiba","arifle_Katiba_F",3000,50],
    ["Katiba Carabine","arifle_Katiba_C_F",3000,50],
    ["MX 3GL","arifle_MX_GL_F",3000,100],
    ["Katiba GL","arifle_Katiba_GL_F",3000,100],
	["TRG-21 EGLM","arifle_TRG21_GL_F",3000,100],
    	//Light Machine Gun
    ["MX SW","arifle_MX_SW_F",3000,100],
    ["Mk200","LMG_Mk200_F",3000,100],
	["Zafir","LMG_Zafir_F",3000,100],
	["Vermin SBR 9mm","SMG_01_F",3000,100],
	["Scorpion EVO-4 9mm","SMG_02_F",3000,100],
    	//Rocket
    ["NLAWr","launch_NLAW_F",4500,200],
	["Titan MPRL AA Launcher","launch_I_Titan_F",5000,200],
	["Titan MPRL Compact","launch_I_Titan_short_F",5000,200],
    ["RPG-42 Alamut","launch_RPG32_F",4500,200],
    	//Sniper
    ["EBR","srifle_EBR_F",7000,100],
	["Mk18 ABR","srifle_ebr_f",7000,100],
    ["Lynx 12.7c GM6","srifle_GM6_SOS_F",7000,450],
    ["M320 LRR Rifle","srifle_LRR_SOS_F",7000,450]
];

//Gun Store Ammo List
//Text name, classname, buy cost
ammoArray = [
	["9mm 16Rnd Mag","16Rnd_9x21_Mag",100],
	["5.56mm 20Rnd(Underwater) Mag","20Rnd_556x45_UW_mag",150],
	["5.56mm 30Rnd STANAG Mag","30Rnd_556x45_Stanag",150],
	["6.5mm 30Rnd Caseless GreenMag","30Rnd_65x39_caseless_green",150],
    ["6.5mm 30Rnd Caseless Mag","30Rnd_65x39_caseless_mag",150],
    ["6.5mm 30Rnd Case Mag","30Rnd_65x39_case_mag",150],
	["6.5mm 100Rnd Belt","100Rnd_65x39_caseless_mag_Tracer",150],
	["6.5mm 200Rnd Belt","200Rnd_65x39_cased_Box",200],
	["7.62mm 20Rnd Mag","20Rnd_762x51_Mag",150],
	["12.7mm 5Rnd Mag","5Rnd_127x108_Mag",200],
	["408 7Rnds LRR","7Rnd_408_Mag",250],
	["45ACP 30Rnds SMG","30Rnd_45ACP_Mag_SMG_01",250],
	["9mm 30Rnds SMG","30Rnd_9x21_Mag",250],
	["7.62mm 150Rnds Box Tracer (Zafir)","150Rnd_762x51_Box_Tracer",250],
	["HandGrenade","HandGrenade",200],
	["GL Flare 40mm (white)","UGL_FlareWhite_F",45],
	["GL Flare 40mm (green)","UGL_FlareGreen_F",45],
	["GL Flare 40mm (Red)","UGL_FlareRed_F",45],
	["GL Flare 40mm (Yellow)","UGL_FlareYellow_F",45],
	["GL Flare 40mm (Cir)","UGL_FlareCIR_F",45],
	["40mm HE Grenade Round","1Rnd_HE_Grenade_shell",250],
	["Chemlight Blue","Chemlight_blue",25],
	["Chemlight Yellow","Chemlight_yellow",25],
	["Chemlight Red","Chemlight_red",25],
	["NLAW Missile","NLAW_F",700],
    ["RPG32 Missile","RPG32_F",700],
    ["RPG32 AA Missile","RPG32_AA_F",5000],
	["Titan AA Missile","Titan_AA",8000],
	["Titan AT Missile","Titan_AT",1000],
	["Explosive Charge","DemoCharge_Remote_Mag",550],
    ["Explosive Satchel","SatchelCharge_Remote_Mag",550],
    ["AT Mine","ATMine_Range_Mag",550],
    ["M6 SLAM Mine","SLAMDirectionalMine_Wire_Mag",550],
    ["Claymore Charge","ClaymoreDirectionalMine_Remote_Mag",550],
    ["APERS Mine","APERSMine_Range_Mag",550],
    ["APERS Bounding Mine","APERSBoundingMine_Range_Mag",550],
    ["APERS Tripwire Mine","APERSTripMine_Wire_Mag",550]
];

//Gun Store Equipment List
//Text name, classname, buy cost
accessoriesArray = [
	["GPS","ItemGPS", 500,"item"],
	["Binoculars","Binocular", 500,"binoc"],
	["NV Goggles","NVGoggles", 1000,"item"],
	["Range Finder","Rangefinder", 2000,"binoc"],
    ["First Aid","FirstAidKit", 500,"item"],
    ["Medkit","Medikit", 1500,"item"],
    ["Toolkit","ToolKit", 1500,"item"],
  	["Suppressor 9mm","muzzle_snds_L", 700,"item"],
    ["Suppressor 6.5mm","muzzle_snds_H", 1000,"item"],
    ["Suppressor 6.5mm(LMG)","muzzle_snds_H_MG", 1000,"item"],
	["Suppressor 7.62mm","muzzle_snds_B", 1000,"item"],
	["Suppressor 5.56mm","muzzle_snds_M", 1000,"item"],
    ["Flash Light","acc_flashlight", 50,"item"],
    ["Holosight","optic_Holosight", 500,"item"],
	["ACO Sight","optic_Aco", 700,"item"],
    ["ACO Sight(Green)","optic_ACO_grn", 700,"item"], 
	["RCO Sight","optic_Hamr", 1000,"item"],
    ["ARCO Sight","optic_Arco", 1000,"item"],
    ["SOS Sight(LR)","optic_SOS", 1000,"item"],
	["MCRO Optic","optic_mrco", 1000,"item"],
    ["Backpack (Large)","B_Bergen_Base", 1500,"backpack"],
	["Parachute Steerable","B_Parachute", 150,"backpack"],
    ["Backpack (Extra Large)","B_Carryall_Base", 2500,"backpack"], 
    ["Carrier GL Rig (Green)","V_PlateCarrierGL_rgr", 70,"vest"],
    ["Carrier Lite (Coyote)","V_PlateCarrier1_cbr", 70,"vest"],
    ["Carrier Lite (Green)","V_PlateCarrier1_rgr", 70,"vest"],
    ["Carrier Rig (Green)","V_PlateCarrier2_rgr", 70,"vest"],
    ["Chest Rig (Khaki)","V_Chestrig_khk", 70,"vest"],
    ["Chest Rig (Green)","V_ChestrigB_rgr", 70,"vest"],
//  ["Slash Bandolier (Coyote)","V_BandollierB_cbr", 100,"vest"],
//  ["Slash Bandolier (Khaki)","V_BandollierB_khk", 100,"vest"],
    ["Tactical Vest (Brown)","V_TacVest_brn", 70,"vest"],
    ["Tactical Vest (Khaki)","V_TacVest_khk", 70,"vest"],
    ["Tactical Vest (Olive)","V_TacVest_oli", 70,"vest"],
//	["Combat Fatigues (MTP)","U_B_CombatUniform_mcam", 100,"uni"],
//  ["Combat Fatigues (Tee)","U_B_CombatUniform_mcam_tshirt", 100,"uni"],
	//diving gear
	["Dive Goggles","G_Diving", 50,"gogg"],
    ["Dive Rebreather(bluefor)","V_RebreatherB", 50,"vest"],
	["Dive Rebreather(others)","V_RebreatherIR", 50,"vest"],
    ["Dive Wetsuit(bluefor)","U_B_Wetsuit", 50,"uni"],
	["Dive Wetsuit(others)","U_O_Wetsuit", 50, "uni"],
    ["Ghillysuit(bluefor)","U_B_Ghilliesuit", 10000,"uni"],
	["Ghillysuit(others)","U_O_Ghilliesuit", 10000, "uni"],
    ["ECH","H_HelmetB", 100,"hat"],
    ["ECH (Light)","H_HelmetB_light", 100,"hat"],
    ["ECH (Custom)","H_HelmetB_paint", 100,"hat"],
    ["Booniehat (Hex)","H_Booniehat_ocamo", 100,"hat"],
    ["Booniehat (Khaki)","H_Booniehat_khk", 100,"hat"],
    ["Booniehat (MTP)","H_Booniehat_mcamo", 100,"hat"],
    ["Cap (Blue)","H_Cap_blu", 100,"hat"],
    ["Cap (Red)","H_Cap_red", 100,"hat"],
    ["Cap (SERO)","H_Cap_brn_SERO", 100,"hat"],
    ["Cap Rangemaster","H_Cap_headphones", 100,"hat"],
    ["Cap Military (Hex)","H_MilCap_ocamo", 100,"hat"],
    ["Cap Military (MTP)","H_MilCap_mcamo", 100,"hat"],
    ["Pilot Helmet(bluefor)","H_PilotHelmetHeli_B", 100,"hat"],
    ["Pilot Helmet(others)","H_PilotHelmetHeli_O", 100,"hat"]
];




