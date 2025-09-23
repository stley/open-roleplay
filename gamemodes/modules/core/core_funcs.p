forward serverShutdown();
forward globalAutoSave();


public serverShutdown(){
    return 1;
}


public globalAutoSave(){
	serverLogRegister("Ejecutando el autoguardado automático global...");
    yield 1;
	foreach(new playerid: Player) CallLocalFunction("accountAutoSave", "d", playerid);
	for(new v; v < MAX_VEHICULOS; v++) CallLocalFunction("vehicleAutoSave", "d", v);
	return 1;
}

