Dialog:D_USERNAME(playerid, response, listitem, inputtext[]){
	if(!response) Kick(playerid);
	orm_user(playerid);
	strmid(username[playerid], inputtext, 0, strlen(inputtext));
	new str[128];
	mysql_format(SQLDB, str, sizeof(str), "SELECT * FROM `accounts` WHERE `Nombre` = '%e' LIMIT 1", username[playerid]);
	mysql_tquery(SQLDB, str, "accountOnUserFirstLoad", "d", playerid);
}
Dialog:D_REGISTRO(playerid, response, listitem, inputtext[])
{
	if(!response) return Kick(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "\tIngresaste una contraseña nula.\n\tIntenta de nuevo.", "Continuar", "Salir");
	if(strlen(inputtext) < 4 || strlen(inputtext) > 32) return Dialog_Show(playerid, D_REGISTRO, DIALOG_STYLE_INPUT, "Registro", "\tIngresaste una contraseña muy corta/larga.\n\tIntenta que la contraseña tenga entre 4 - 32 carácteres.\n\tIntenta de nuevo.", "Continuar", "Salir");
	
	bcrypt_hash(playerid, "accountPassHash", inputtext, BCRYPT_COST, "sd", inputtext, 1);
	return 1;
}


Dialog:D_INGRESO(playerid, response, listitem, inputtext[])
{
	if(!response) return Kick(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_INGRESO, DIALOG_STYLE_PASSWORD, "Ingreso", "Ingresaste una contraseña nula. Intenta de nuevo.", "Ingresar", "Salir");
	bcrypt_hash(playerid, "accountPassHash", inputtext, BCRYPT_COST, "sd", inputtext, 0);
	return 1;
}


Dialog:D_EMAIL(playerid, response, listitem, inputtext[])
{
	if(!response) return Kick(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_EMAIL, DIALOG_STYLE_INPUT, "Correo Electrónico", "No ingresaste nada.\n Inténta de nuevo.", "Continuar", "Salir");
	if(strlen(inputtext) < 10) return Dialog_Show(playerid, D_EMAIL, DIALOG_STYLE_INPUT, "Correo Electrónico", "No ingresaste un correo válido.\nInténta de nuevo.", "Continuar", "Salir");
	if(!IsValidEmail(inputtext)) return Dialog_Show(playerid, D_EMAIL, DIALOG_STYLE_INPUT, "Correo Electrónico", "No ingresaste un correo válido.\nInténta de nuevo.", "Continuar", "Salir");
	
	strmid(Datos[playerid][jEmail], inputtext, 0, 101);
	strmid(Datos[playerid][jNombre], username[playerid], 0, strlen(username[playerid]));
	alm(Datos[playerid][FechaReg], FechaActual());
	
	orm_insert(Datos[playerid][ORMID], "onUserRegister", "d", playerid);
	return 1;
}

Dialog:D_FINREG(playerid, response, listitem, inputtext[]){
	Datos[playerid][LoggedIn] = true;
	return dialog_personajes(playerid);
}

Dialog:D_REGPJ(playerid, response, listitem, inputtext[])
{
	if(!response) return dialog_personajes(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "No ingresaste un nombre válido. Intentalo de nuevo.", "Continuar", "Cancelar");

	if(strlen(inputtext) < 6 || strlen(inputtext) > 24) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "El nombre de tu personaje tiene que estar entre los 6 - 24 carácteres.\n Intentalo de nuevo.", "Continuar", "Cancelar");
	if(!IsValidNickName(inputtext)) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "No ingresaste un nombre válido. Intentalo de nuevo.", "Continuar", "Cancelar"); 
	if(strfind(inputtext, "_") == -1) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "Ingresa un nombre para tu personaje, incluyendo el '_'. (Ejemplo: Pedro_Perez)", "Continuar", "Cancelar");

	alm(Datos[playerid][jNombrePJ], inputtext);
	Dialog_Show(playerid, D_EDAD, DIALOG_STYLE_INPUT, "Edad del Personaje", "¿Cuantos años tendrá tu personaje?", "Continuar", "Salir");
	return 1;
}
Dialog:D_EDAD(playerid, response, listitem, inputtext[])
{
	if(!response) return Dialog_Show(playerid, D_EDAD, DIALOG_STYLE_INPUT, "Edad del Personaje", "¿Cuantos años tendrá tu personaje?", "Continuar", "Salir");
	if(!IsNumeric(inputtext)) return Dialog_Show(playerid, D_EDAD, DIALOG_STYLE_INPUT, "Edad del Personaje", "Ingresaste carácteres.\n Intentalo de nuevo.", "Continuar", "Salir");
	if(strval(inputtext) > 85 || strval(inputtext) < 15) return Dialog_Show(playerid, D_EDAD, DIALOG_STYLE_INPUT, "Edad del Personaje", "La edad del personaje tiene que estar entre 15 - 85.\nIntentalo de nuevo.", "Continuar", "Salir");
	Datos[playerid][jEdad] = strval(inputtext);
	Dialog_Show(playerid, D_GENERO, DIALOG_STYLE_MSGBOX, "Sexo del Personaje", "¿Tu personaje es un hombre o una mujer?", "Hombre", "Mujer");
	return 1;
}
Dialog:D_GENERO(playerid, response, listitem, inputtext[])
{
	if(!response) Datos[playerid][jSexo] = 0;
	else Datos[playerid][jSexo] = 1;
	new strreg[256];
	formatt(strreg, "Nombre: %s\nEdad: %d\nSexo: %s\nComprueba que los datos estan correctos.", Datos[playerid][jNombrePJ], Datos[playerid][jEdad], (Datos[playerid][jSexo] == 1) ? "Hombre" : "Mujer");
	Dialog_Show(playerid, D_FINREGPJ, DIALOG_STYLE_MSGBOX, "Comprobación", strreg, "Continuar", "Reiniciar");
	return 1;
}
Dialog:D_FINREGPJ(playerid, response, listitem, inputtext[])
{
	if(!response) return Dialog_Show(playerid, D_EDAD, DIALOG_STYLE_INPUT, "Edad del Personaje", "¿Cuantos años tendrá tu personaje?", "Continuar", "Salir");
	Datos[playerid][jRopa] = (Datos[playerid][jSexo] == 1) ? 299 : 93;
	save_account(playerid);
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
	new dslog[512];
	format(dslog, sizeof(dslog), "%s (IP %s | SQLID %d) está creando el personaje %s.", username[playerid], GetPIP(playerid), Datos[playerid][jSQLID], Datos[playerid][jNombrePJ]);
	serverLogRegister(dslog);
	orm_insert(Datos[playerid][ORMPJ], "accountOnCharInserted", "d", playerid);
	CallLocalFunction("adminRefresh", "d", playerid);
	return 1;
}

dialog_personajes(playerid)
{
	new query[256];
	mysql_format(SQLDB, query, sizeof(query), "SELECT `Usuario`, `SQLIDPJ`, `NombrePJ` FROM `characters` WHERE `Usuario` = %d LIMIT %d", Datos[playerid][jSQLID], Datos[playerid][CharacterLimit]);
	mysql_tquery(SQLDB, query, "accountOnUserCharacterList", "d", playerid);
	return 1;
}

DialogPages:character_dialog(playerid, response, listitem, inputtext[]){
	if(!response) Kick(playerid);
	cache_set_active(characterCache[playerid]);
	if(listitem+1 > cache_num_rows()){
		cache_unset_active();
		cache_delete(characterCache[playerid]);
		characterCache[playerid] = MYSQL_INVALID_CACHE;
		return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "Ingresa un nombre para tu personaje. (Ejemplo: Pedro_Perez)", "Continuar", "Cancelar");
	}
	else{
		new charid;
		cache_get_value_name_int(listitem, "SQLIDPJ", charid);
		cache_delete(characterCache[playerid]);
		characterCache[playerid] = MYSQL_INVALID_CACHE;
		orm_char(playerid);
		new query[128];
		mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `characters` WHERE `SQLIDPJ` = %d LIMIT 1", charid);
		mysql_tquery(SQLDB, query, "accountOnCharFirstLoad", "d", playerid);
		return 1;
	}
}

Dialog:D_INGPJ(playerid, response, listitem, inputtext[])
{
	if(!response){
		clear_chardata(playerid);
		return dialog_personajes(playerid);
	}
	switch(listitem)
	{
		case 0:
		{
			SetPlayerName(playerid, Datos[playerid][jNombrePJ]);
			SpawnPlayer(playerid);
			load_character(playerid);
			new dslog[512];
			format(dslog, sizeof(dslog), "%s (SQLID %d | IP %s | playerid %d) ingresó al personaje %s (SQLID: %d).", username[playerid], Datos[playerid][jSQLID], GetPIP(playerid), playerid, Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]);
			serverLogRegister(dslog);
			CallLocalFunction("adminRefresh", "d", playerid);
		}
		case 1:
		{
			clear_chardata(playerid);
			return dialog_personajes(playerid);
		}
	}
	return 1;
}

