//gamemode
public OnGameModeInit()
{
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
    CallLocalFunction("databaseOnGameModeInit");
    CallLocalFunction("Models_OnGameModeInit");
	CallLocalFunction("vehiclesOnGameModeInit");
	CallLocalFunction("discordOnGameModeInit");
    return 1;
}
public OnGameModeExit()
{
    CallLocalFunction("databaseOnGameModeExit");
	CallLocalFunction("accountOnGameModeExit");
	CallLocalFunction("vehiclesOnGameModeExit");
	CallLocalFunction("discordOnGameModeExit");
	return 1;
}
//player
public OnPlayerConnect(playerid){
	CallLocalFunction("discordOnPlayerConnect", "d", playerid);
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
	CMD_JR_MOD
};
new a_perms[MAX_PLAYERS];
