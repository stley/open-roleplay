//gamemode
public OnGameModeInit()
{
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
    CallLocalFunction("SQL_OnGameModeInit");
    CallLocalFunction("Models_OnGameModeInit");
	CallLocalFunction("Vehicles_OnGameModeInit");
    return 1;
}
public OnGameModeExit()
{
    CallLocalFunction("SQL_OnGameModeExit");
	CallLocalFunction("Users_OnGameModeExit");
	CallLocalFunction("Vehicles_OnGameModeExit");
	return 1;
}
//player
public OnPlayerConnect(playerid){
	CallLocalFunction("Acc_OnPlayerConnect", "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	CallLocalFunction("Acc_OnPlayerDisconnect", "dd", playerid, reason);
	CallLocalFunction("Ply_OnPlayerDisconnect", "dd", playerid, reason);
	return 1;
}
public OnPlayerRequestClass(playerid, classid){
	CallLocalFunction("Acc_OnPlayerRequestClass", "dd", playerid, classid);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid){
	CallLocalFunction("Vehicles_OnPlayerEnterCheckpoint", "d", playerid);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid){
	CallLocalFunction("Vehicles_OnPlayerLeaveCheckpoint", "d", playerid);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	CallLocalFunction("Vehicles_OnPlayerEnterVehicle", "ddd", playerid, vehicleid, ispassenger);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid){
	CallLocalFunction("Vehicles_OnPlayerExitVehicle", "dd", playerid, vehicleid);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, WEAPON:weaponid, bodypart){
	Wound_HandleDamage(playerid, issuerid, weaponid, bodypart);
	return 1;
}


//vehicle
public OnVehicleSpawn(vehicleid){
	CallLocalFunction("Vehicles_OnVehicleSpawn", "d", vehicleid);
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