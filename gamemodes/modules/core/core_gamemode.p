new g_AutoSave;
forward globalAutoSave();

public OnGameModeInit()
{
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
    CallLocalFunction("databaseOnGameModeInit");
    CallLocalFunction("Models_OnGameModeInit");
	CallLocalFunction("vehiclesOnGameModeInit");
	CallLocalFunction("discordOnGameModeInit");
	if(IsCrashDetectPresent()){
		printf("CrashDetect encontrado en la lista de plugins.");
		EnableCrashDetectLongCall();
		SetCrashDetectLongCallTime(10000);
	}
	g_AutoSave = SetTimer("globalAutoSave", 60*60000, true);
    return 1;
}
#pragma unused g_AutoSave

public OnGameModeExit()
{
	CallLocalFunction("accountOnGameModeExit");
	CallLocalFunction("vehiclesOnGameModeExit");


    CallLocalFunction("databaseOnGameModeExit"); //keep it last, so it saves everything, smh with my past myself
	return 1;
}
//player
public OnPlayerConnect(playerid){
	animationsPreload(playerid);
	CallLocalFunction("discordOnPlayerConnect", "d", playerid);
	CallLocalFunction("accountOnPlayerConnect", "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	accountOnPlayerDisconnect(playerid, reason);
	playerOnPlayerDisconnect(playerid, reason);
	return 1;
}
public OnPlayerRequestClass(playerid, classid){
	CallLocalFunction("accountOnPlayerRequestClass", "dd", playerid, classid);
	if(!IsPlayerUsingOmp(playerid)){
		SendClientMessage(playerid, COLOR_BRIGHTRED, "Necesitas tener el launcher de Open Multiplayer para ingresar a este servidor.");
		SetTimerEx("Kick", 2000, false, "d", playerid);
	}
	return 1;
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

public globalAutoSave(){
	foreach(new playerid: Player){
		CallLocalFunction("accountAutoSave", "d", playerid);
	}
	for(new v; v < MAX_VEHICULOS; v++){
		CallLocalFunction("vehicleAutoSave", "d", v);
		continue;
	}
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

