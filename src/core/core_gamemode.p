stock g_AutoSave = INVALID_TIMER;

forward OnVehicleUpdate(vehicleid);

public OnGameModeInit(){
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();

	if(IsCrashDetectPresent()) serverLogRegister("CrashDetect encontrado en la lista de plugins.", CURRENT_MODULE);
	g_AutoSave = SetTimer("globalAutoSave", 60*60000, true);
    return 1;
}

public OnGameModeExit(){
	return 1;
}
//player
public OnPlayerConnect(playerid){
	animationsPreload(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	return 1;
}
public OnPlayerRequestClass(playerid, classid){
	if(!IsPlayerUsingOmp(playerid)){
		SendClientMessage(playerid, COLOR_BRIGHTRED, "Necesitas tener el launcher de Open Multiplayer para ingresar a este servidor.");
		playerDelayedKick(playerid, 2000);
	}
	return 0;
}

public OnPlayerEnterCheckpoint(playerid){
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid){
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid){
	return 1;
}

public OnVehicleUpdate(vehicleid)
{
	CallLocalFunction("vehiclesOnVehicleUpdate", "d", vehicleid);
    
    return 1;
}

//vehicle
public OnVehicleSpawn(vehicleid){
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	return 1;
}