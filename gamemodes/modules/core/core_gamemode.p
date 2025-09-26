stock g_AutoSave = INVALID_TIMER;

public OnGameModeInit()
{
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
	
	CallLocalFunction("discordOnGameModeInit");
	delay(1000);
	CallLocalFunction("serverLogInit");
    CallLocalFunction("databaseOnGameModeInit");
    CallLocalFunction("Models_OnGameModeInit");
	CallLocalFunction("vehiclesOnGameModeInit");

	if(IsCrashDetectPresent()) serverLogRegister("CrashDetect encontrado en la lista de plugins.");
	g_AutoSave = SetTimer("globalAutoSave", 60*60000, true);
    return 1;
}

public OnGameModeExit()
{
	CallLocalFunction("accountOnGameModeExit");
	CallLocalFunction("vehiclesOnGameModeExit");

    CallLocalFunction("databaseOnGameModeExit");
	CallLocalFunction("serverLogExit");
	delay(2000);
	CallLocalFunction("discordOnGameModeExit");
	return 1;
}
//player
public OnPlayerConnect(playerid){
	animationsPreload(playerid);
	CallLocalFunction("accountOnPlayerConnect", "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	CallLocalFunction("accountOnPlayerDisconnect", "dd", playerid, reason);
	CallLocalFunction("playerOnPlayerDisconnect", "dd", playerid, reason);
	return 1;
}
public OnPlayerRequestClass(playerid, classid){
	CallLocalFunction("accountOnPlayerRequestClass", "dd", playerid, classid);
	if(!IsPlayerUsingOmp(playerid)){
		SendClientMessage(playerid, COLOR_BRIGHTRED, "Necesitas tener el launcher de Open Multiplayer para ingresar a este servidor.");
		playerDelayedKick(playerid, 2000);
	}
	return 0;
}

public OnPlayerEnterCheckpoint(playerid){
	CallLocalFunction("vehiclesOnPlayerEnterCheckpoint", "d", playerid);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid){
	CallLocalFunction("vehiclesOnPlayerLeaveCheckpoint", "d", playerid);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	CallLocalFunction("vehiclesOnPlayerEnterVehicle", "ddd", playerid, vehicleid, ispassenger);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid){
	CallLocalFunction("vehiclesOnPlayerExitVehicle", "dd", playerid, vehicleid);
	return 1;
}



//vehicle
public OnVehicleSpawn(vehicleid){
	CallLocalFunction("vehiclesOnVehicleSpawn", "d", vehicleid);
	return 1;
}
enum (<<= 1)
{
	CMD_OWNER = 1,
	CMD_ADMIN,
	CMD_OPERATOR,
	CMD_JR_OPERATOR,
	CMD_MOD,
	CMD_JR_MOD,

	CMD_STAFF_MANAGER,
	CMD_FACTION_MANAGER,
	CMD_PROPERTY_MANAGER
};
new a_perms[MAX_PLAYERS];

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	return 1;
}