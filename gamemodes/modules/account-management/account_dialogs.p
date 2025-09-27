dialog_username(playerid){
	yield 1;
	await_str(username[playerid]) ShowAsyncStringInputDialog(playerid, "¡Bienvenido!", "Ingresa tu nombre de usuario para continuar:", "Ingresar", "Salir");
	if(isnull(username[playerid]))
		Kick(playerid);
	new str[150];
	mysql_format(SQLDB, str, sizeof(str), "SELECT * FROM `accounts` WHERE `Nombre` = '%e' LIMIT 1", username[playerid]);
	await mysql_aquery(SQLDB, str);
	orm_user(playerid);
	if(cache_num_rows()){
		orm_apply_cache(Datos[playerid][ORMID], 0);
		return dialog_ingreso(playerid);
	}
	else return dialog_registro(playerid);
}

dialog_registro(playerid){
	yield 1;
	new str[64];
	formatt(str, "Bienvenido %s.\nIngrese una contraseña para continuar.", username[playerid]);
	new inputtext[32];
	await_str(inputtext) ShowAsyncStringInputDialog(playerid, "Registro", str, "Continuar", "Salir");
	if(isnull(inputtext))
		Kick(playerid);
	bcrypt_hash(playerid, "accountPassHash", inputtext, BCRYPT_COST, "sd", inputtext, 1);
	return 1;
}

dialog_ingreso(playerid){
	yield 1;
	new str[64];
	formatt(str, "Bienvenido %s.\nIngresa tu contraseña para continuar.", username[playerid]);
	new inputtext[32];
	await_str(inputtext) ShowAsyncPasswordDialog(playerid, "Ingreso", str, "Ingresar", "Salir");
	if(isnull(inputtext))
		Kick(playerid);
	bcrypt_hash(playerid, "accountPassHash", inputtext, BCRYPT_COST, "sd", inputtext, 0);
	return 1;
}


dialog_email(playerid){
	yield 1;
	new inputtext[102];
	await_str(inputtext) ShowAsyncStringInputDialog(playerid, "Correo Electrónico", "¡Perfecto! Ingresa tu correo electrónico.", "Continuar", "Salir");
	if(isnull(inputtext))
		Kick(playerid);
	if(strlen(inputtext) < 10) dialog_email(playerid);
	if(!IsValidEmail(inputtext)) dialog_email(playerid);
	alm(Datos[playerid][jEmail], inputtext);
	strmid(Datos[playerid][jNombre], username[playerid], 0, strlen(username[playerid]));
	alm(Datos[playerid][FechaReg], FechaActual());
	orm_insert(Datos[playerid][ORMID], "onUserRegister", "d", playerid);
	return 1;
}

dialog_REGPJ(playerid){
	yield 1;
	new inputtext[32];
	await_str(inputtext) ShowAsyncStringInputDialog(playerid, "Crear Personaje", "Ingresa un nombre para tu personaje. (Ejemplo: Pedro_Perez)", "Continuar", "Cancelar");
	if(isnull(inputtext))
		return dialog_personajes(playerid);
	if(strlen(inputtext) < 6 || strlen(inputtext) > 24){
		SendClientMessage(playerid, COLOR_DARKRED, "El nombre tiene que estar entre los 6 a 24 carácteres. Intentalo de nuevo.");
		return dialog_REGPJ(playerid);
	}
	if(!IsValidNickName(inputtext)){
		SendClientMessage(playerid, COLOR_DARKRED, "No ingresaste un nombre válido. Intentalo de nuevo.");
		return dialog_REGPJ(playerid);
	}
	if(strfind(inputtext, "_") == -1){
		SendClientMessage(playerid, COLOR_DARKRED, "Ingresa un nombre para tu personaje, incluyendo el '_'. (Ejemplo: Pedro_Perez)");
		return dialog_REGPJ(playerid);
	}
	alm(Datos[playerid][jNombrePJ], inputtext);
	dialog_edad_personaje(playerid);
	return 1;
}

dialog_edad_personaje(playerid){
	yield 1;
	new edad = await ShowAsyncNumberInputDialog(playerid, "Edad del Personaje", "¿Cuantos años tendrá tu personaje?\nLa edad de tu personaje tiene que estar entre los 15 a 85 años.", "Continuar", "Salir");
	if(edad > 85 || edad < 15) return dialog_edad_personaje(playerid);
	Datos[playerid][jEdad] = edad;
	
	dialog_sexo_personaje(playerid);
	return 1;
}

dialog_sexo_personaje(playerid){
	yield 1;
	new response[DIALOG_RESPONSE];
	await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "Sexo del Personaje", "¿Tu personaje es un hombre o una mujer?", "Hombre", "Mujer");
	if(!response[DIALOG_RESPONSE_RESPONSE]) Datos[playerid][jSexo] = 0;
	else Datos[playerid][jSexo] = 1;
	new strreg[256];
	formatt(strreg, "Nombre: %s\nEdad: %d\nSexo: %s\nComprueba que los datos estan correctos.", Datos[playerid][jNombrePJ], Datos[playerid][jEdad], (Datos[playerid][jSexo] == 1) ? "Hombre" : "Mujer");
	await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "Comprobación", strreg, "Continuar", "Reiniciar");
	if(!response[DIALOG_RESPONSE_RESPONSE])
		dialog_REGPJ(playerid);
	Datos[playerid][jRopa] = (Datos[playerid][jSexo] == 1) ? 299 : 93;
	accountSave(playerid);
	//ChosenPJ[playerid] = 0;
	SpawnPlayer(playerid);
	orm_char(playerid);
	SetPlayerName(playerid, Datos[playerid][jNombrePJ]);
	SetPlayerPos(playerid, 1480.9701, -1770.9177, 18.7958);
	SetPlayerFacingAngle(playerid, 0.3047);
	
	Datos[playerid][jDinero] = 1500;
	GivePlayerMoney(playerid, Datos[playerid][jDinero]);
	SetPlayerSkin(playerid, Datos[playerid][jRopa]);
	Datos[playerid][EnChar] = true;
	Datos[playerid][jUsuario] = Datos[playerid][jSQLID];
	alm(Datos[playerid][jFechaCreacion], FechaActual());
	Datos[playerid][jVida] = 100.0;
	characterTextDraws(playerid);
	serverLogRegister(sprintf("%s (IP %s | SQLID %d) está creando el personaje %s.", username[playerid], GetPIP(playerid), Datos[playerid][jSQLID], Datos[playerid][jNombrePJ]));
	orm_insert(Datos[playerid][ORMPJ], "accountOnCharInserted", "d", playerid);
	CallLocalFunction("adminRefresh", "d", playerid);
}

dialog_personajes(playerid){
	list_clear(DialogData[playerid]);
	yield 1;
	new query[128];
	mysql_format(SQLDB, query, sizeof(query), "SELECT `Usuario`, `SQLIDPJ`, `NombrePJ` FROM `characters` WHERE `Usuario` = %d LIMIT %d", Datos[playerid][jSQLID], Datos[playerid][CharacterLimit]);
	await mysql_aquery(SQLDB, query);
	new dlg_buff[96];
	new charname[MAX_PLAYER_NAME];
	new charid;
	if(cache_num_rows()){
		for(new i; i < cache_num_rows(); i++){
			cache_get_value_name_int(i, "SQLIDPJ", charid);
			cache_get_value_name(i, "NombrePJ", charname);
			formatt(dlg_buff, "%s\t%d", charname, charid);
			AddPaginatedDialogRow(DialogData[playerid], dlg_buff, charid);
		}
	}
	if(cache_num_rows() && cache_num_rows() < Datos[playerid][CharacterLimit]){
		AddPaginatedDialogRow(DialogData[playerid], "{C0C0C0}Crear otro personaje\t", -1);
	}
	else if (!cache_num_rows()){
		AddPaginatedDialogRow(DialogData[playerid], "{C0C0C0}Crear un personaje\t", -1);
	}

	new response[DIALOG_RESPONSE];
	await_arr(response) ShowAsyncPaginatedDialog(playerid, DIALOG_STYLE_TABLIST_HEADERS, 12, "Personajes disponibles", DialogData[playerid], "Ingresar", "Salir", "Nombre\tID");
	
	if(!response[DIALOG_RESPONSE_RESPONSE]){
		Kick(playerid);
		return false;
	}
	if(response[DIALOG_RESPONSE_EXTRAID] == -1) return dialog_REGPJ(playerid);
	else{
		orm_char(playerid);
		mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `characters` WHERE `SQLIDPJ` = %d LIMIT 1", response[DIALOG_RESPONSE_EXTRAID]);
		mysql_tquery(SQLDB, query, "accountOnCharFirstLoad", "d", playerid);
		return 1;
	}
}


dialogIngresar_Personaje(playerid){
	yield 1;
	new listitem = await ShowAsyncListitemIndexDialog(playerid, DIALOG_STYLE_LIST, Datos[playerid][jNombrePJ], "Ingresar\nSolicitar eliminación (No aún)", "Seleccionar", "Salir");
	if(listitem == -1){
		clear_chardata(playerid);
		dialog_personajes(playerid);
	}
	switch(listitem)
	{
		case 0:
		{
			SetPlayerName(playerid, Datos[playerid][jNombrePJ]);
			SpawnPlayer(playerid);
			load_character(playerid);
			serverLogRegister(sprintf("%s (SQLID %d | IP %s | playerid %d) ingresó al personaje %s (SQLID: %d).", username[playerid], Datos[playerid][jSQLID], GetPIP(playerid), playerid, Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]));
			CallLocalFunction("adminRefresh", "d", playerid);
		}
		case 1:
		{
			clear_chardata(playerid);
			dialog_personajes(playerid);
		}
	}
	return 1;
}

