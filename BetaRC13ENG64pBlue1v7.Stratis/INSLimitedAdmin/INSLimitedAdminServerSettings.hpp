//MAIN SETTINGS INSLimitedAdmin

_pboclassesdetect = true; //Scan player PBO files ("true" is on, "false" is off, set to true by default)
_pboclasses = ["stra_debug2","DevCon","mf_sdc","tao_a3_debugger","KRON_SupportCall","mpg_a3"]; //Classnames from addons you don't wan't on your server


_bannedvarsdetect = true; //Detect player using Banned variable names ("true" is on, "false" is off, set to flase by default)
_bannedvars = ['DEV_PlayerInvincible','DEV_HidePlayer','pathtoscrdir','keybinds','Firstrun','Faze_hax_dbclick', 'infiSTAR_hax_dbclick', 'sendtxxt', 'zeus_star', 'Wookie_Scroll_m', 'Wookie_Keybinds', 'Wookies_Willy', 'unitList', 'VL', 'MV','mk2', 'scode', 'igodokxtt', 'omgwtfbbq', 'namePlayer', 'thingtoattachto', 'HaxSmokeOn', 'v', 'antiloop', 'ARGT_JUMP', 'musekeys', 'dontAddToTheArray', 'morphtoanimals', 'MY_KEYDOWN_FNC', 'TAG_onKeyDown', 'activeITEMlist', 'activeITEMlistanzahl', 'xyzaa', 'iBeFlying', 'rem', 'Monky_funcs_inited', 'boost', 'Ug8YtyGyvguGF', 'invall', 'initarr', 'reinit', 'letmeknow', 'Listw', 'mahcaq', 'weapFun', 'take1', 'dwarden', 'monky', 'god', 'toggle_keyEH', 'drawic', 'mk2', 'testIndex', 'g0d', 'g0dmode', 'zeus', 'zeusmode', 'cargod', 'qopfkqpofqk', 'monkytp', 'pbx', 'playershield', 'zombieDistanceScreen', 'plrshldblckls', 'zombieshield', 'godall', 'initarr3', 'initarr2', 'DEV_ConsoleOpen', 'LOKI_GUI_Key_Color', 'WookieBeta_hax_dbclick', 'WookieBeta_hax_toggled', 'WookieBeta_funcs_inited', 'asdhaociuygbaidsuycb', 'antiantiantiantih4x', 'wrsbtsrtbartgb', 'usecepi', 'st0rmmy', 'spamb0t', 'paratroop2', 'harlemmshake', 'gggggggggggg4444444444444444', 'stealthMarkerToggle']; //Banned variable names (e.g. an array called: playerteleport)


_speedhackdetect = true; //Detect player speed hacking ("true" is on, "false" is off, set to true by default)
_maxspeed = 900; //Non-unit vehicle max speed on your server (Variable for detecting speed-hacking, set to 400 by default)


_bannedwepsdetect = false; //Detect player using Banned weapon ("true" is on, "false" is off, set to flase by default)
_bannedweps = ["Binocular"]; //Weapons you can't obtain legitimately in your mission


_bannedvclsdetect = false; //Detect player using Banned vehicle ("true" is on, "false" is off, set to flase by default)
_bannedvcls = ["B_Hunter_F"]; //Vehicles you can't obtain legitimately in your mission


_teleportdetect = false; //Detect player teleporting ("true" is on, "false" is off, set to false by default, MAY CAUSE LAGG)


_banmessage = "You have been banned due to Hacking. You are not welcome anymore. Contact Blue1 at BIS Forums if you want to be unbanned"; //Message Displayed To Hacker When Detected

//Do NOT edit below this point

INSLimitedAdminServerVariables = [_pboclassesdetect,_pboclasses,_bannedvarsdetect,_bannedvars,_speedhackdetect,_maxspeed,_bannedwepsdetect,_bannedweps,_bannedvclsdetect,_bannedvcls,_teleportdetect,_banmessage];