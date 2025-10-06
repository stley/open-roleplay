forward serverShutdown();
forward globalAutoSave();

public serverShutdown(){
	foreach(new playerid: Player){
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "El servidor está apagándose, por lo que guardaremos tus datos.");
		playerDelayedKick(playerid, 1000);
	}
	CallLocalFunction("vehicleGlobalAutoSave");
    return 1;
}

public globalAutoSave(){
	serverLogRegister("Ejecutando el autoguardado global...");
	yield 1;
	CallLocalFunction("accountGlobalAutoSave");
	CallLocalFunction("vehicleGlobalAutoSave");
	return 1;
}