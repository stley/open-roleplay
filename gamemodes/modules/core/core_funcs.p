forward serverShutdown();
forward globalAutoSave();


public serverShutdown(){
    return 1;
}


public globalAutoSave(){
	serverLogRegister("Ejecutando el autoguardado autom�tico global...");
    yield 1;
	foreach(new playerid: Player){
        save_account(playerid);
        save_char(playerid);
	}
	for(new v; v < MAX_VEHICULOS; v++){
        vehicleAutoSave(v);
	}
	return 1;
}

