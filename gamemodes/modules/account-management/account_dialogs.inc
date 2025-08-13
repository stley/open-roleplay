Dialog:D_REGISTRO(playerid, response, listitem, inputtext[])
{
	if(!response) return Kick(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "\tIngresaste una contraseña nula.\n\tIntenta de nuevo.", "Continuar", "Salir");
	if(strlen(inputtext) < 4 || strlen(inputtext) > 32) return Dialog_Show(playerid, D_REGISTRO, DIALOG_STYLE_INPUT, "Registro", "\tIngresaste una contraseña muy corta/larga.\n\tIntenta que la contraseña tenga entre 4 - 32 carácteres.\n\tIntenta de nuevo.", "Continuar", "Salir");
	Dialog_Show(playerid, D_EMAIL, DIALOG_STYLE_INPUT, "Correo Electrónico", "¡Perfecto! Ingresa tu correo electrónico.", "Continuar", "Salir");
	WP_Hash(Datos[playerid][jClave], 129, inputtext);
	return 1;
}

Dialog:D_INGRESO(playerid, response, listitem, inputtext[])
{
	if(!response) return Kick(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_INGRESO, DIALOG_STYLE_PASSWORD, "Ingreso", "Ingresaste una contraseña nula. Intenta de nuevo.", "Ingresar", "Salir");
	new hashed[129];
	WP_Hash(hashed, 129, inputtext);
	if(!strcmp(hashed, Datos[playerid][jClave]))
	{
		Datos[playerid][LoggedIn] = true;
		dialog_personajes(playerid);
		mysql_format(SQLDB, hashed, sizeof(hashed), "UPDATE `accounts` SET `online` = 1 WHERE `Nombre` = '%e'", username[playerid]);
		alm(Datos[playerid][jIP], GetPIP(playerid));
		mysql_tquery(SQLDB, hashed);
	}
	else
	{
		if(IntentosLogin[playerid] < 3)
		{
			IntentosLogin[playerid]++;
			return Dialog_Show(playerid, D_INGRESO, DIALOG_STYLE_PASSWORD, "Ingreso", "\tIngresaste una contraseña incorrecta.\n\tIntenta de nuevo.", "Ingresar", "Salir");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Has sido expulsado luego de muchos intentos fallidos de ingresar.");
			SetTimerEx("Kick", 2000, false, "d", playerid);
		}
	}
	return 1;
}

Dialog:D_EMAIL(playerid, response, listitem, inputtext[])
{
	if(!response) return Kick(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_EMAIL, DIALOG_STYLE_INPUT, "Correo Electrónico", "No ingresaste nada.\n Inténta de nuevo.", "Continuar", "Salir");
	if(strlen(inputtext) < 10) return Dialog_Show(playerid, D_EMAIL, DIALOG_STYLE_INPUT, "Correo Electrónico", "No ingresaste un correo válido.\nInténta de nuevo.", "Continuar", "Salir");
	if(IsValidEmail(inputtext)) return Dialog_Show(playerid, D_EMAIL, DIALOG_STYLE_INPUT, "Correo Electrónico", "No ingresaste un correo válido.\nInténta de nuevo.", "Continuar", "Salir");
	
	strmid(Datos[playerid][jEmail], inputtext, 0, 101);
	strmid(Datos[playerid][jNombre], username[playerid], 0, MAX_PLAYER_NAME);
	alm(Datos[playerid][FechaReg], FechaActual());
	Dialog_Show(playerid, D_FINREG, DIALOG_STYLE_MSGBOX, "¡Enhorabuena!", "Tu cuenta ha sido creada correctamente.", "Continuar", "");
	orm_insert(Datos[playerid][ORMID]);
	return 1;
}
Dialog:D_FINREG(playerid, response, listitem, inputtext[])
{
	return dialog_personajes(playerid);
}

Dialog:D_REGPJ(playerid, response, listitem, inputtext[])
{
	if(!response) return dialog_personajes(playerid);
	if(isnull(inputtext)) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "No ingresaste un nombre válido. Intentalo de nuevo.", "Continuar", "Cancelar");
	if(strlen(inputtext) < 12 || strlen(inputtext) > 24) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "El nombre de tu personaje tiene que estar entre los 18 - 24 carácteres.\n Intentalo de nuevo.", "Continuar", "Cancelar");
	if(!strcmp(inputtext, "user_none", true)) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "No ingresaste un nombre válido. Intentalo de nuevo.", "Continuar", "Cancelar"); 
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
	switch(ChosenPJ[playerid])
	{
		case 1: alm(jPJE[playerid][0], Datos[playerid][jNombrePJ]); 
		case 2: alm(jPJE[playerid][1], Datos[playerid][jNombrePJ]); 
		case 3: alm(jPJE[playerid][2], Datos[playerid][jNombrePJ]); 
	}
	orm_update(Datos[playerid][ORMID]);
	ChosenPJ[playerid] = 0;
	SpawnPlayer(playerid);
	orm_char(playerid);
	SetPlayerName(playerid, Datos[playerid][jNombrePJ]);
	SetPlayerPos(playerid, 1480.9701, -1770.9177, 18.7958);
	SetPlayerFacingAngle(playerid, 0.3047);
	
	Datos[playerid][jDinero] = 1500;
	GivePlayerMoney(playerid, Datos[playerid][jDinero]);
	SetPlayerSkin(playerid, Datos[playerid][jRopa]);
	Datos[playerid][EnChar] = true;
	alm(Datos[playerid][jUsuario], username[playerid]);
	alm(Datos[playerid][jFechaCreacion], FechaActual());
	Datos[playerid][jVida] = 100.0;
	orm_insert(Datos[playerid][ORMPJ], " accountOnCharInserted", "d", playerid);
	return 1;
}

dialog_personajes(playerid)
{
	new dialogstr[150];
	if(!strcmp(jPJE[playerid][0], "user_none")) strcat(dialogstr, "{C0C0C0}Ranura disponible");
	else strcat(dialogstr, jPJE[playerid][0]);
	strcat(dialogstr, "\n");
	if(!strcmp(jPJE[playerid][1], "user_none")) strcat(dialogstr, "{C0C0C0}Ranura disponible");
	else strcat(dialogstr, jPJE[playerid][1]);
	strcat(dialogstr, "\n");
	if(!strcmp(jPJE[playerid][2], "user_none")) strcat(dialogstr, "{C0C0C0}Ranura disponible");
	else strcat(dialogstr, jPJE[playerid][2]);
	return Dialog_Show(playerid, D_PERSONAJES, DIALOG_STYLE_LIST, "Personajes disponibles", dialogstr, "Ingresar", "Salir");
}

Dialog:D_PERSONAJES(playerid, response, listitem, inputtext[])
{
	if(!response) return Kick(playerid);
	ChosenPJ[playerid] = listitem+1;
	if(!strcmp(jPJE[playerid][listitem], "user_none")) return Dialog_Show(playerid, D_REGPJ, DIALOG_STYLE_INPUT, "Crear Personaje", "Ingresa un nombre para tu personaje. (Ejemplo: Pedro_Perez)", "Continuar", "Cancelar");
	else
	{
		orm_char(playerid);
		new query[128];
		mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `characters` WHERE `NombrePJ` = '%e'", jPJE[playerid][listitem]);
		mysql_tquery(SQLDB, query, "accountOnCharFirstLoad", "d", playerid);
	}
	return 1;
}
Dialog:D_INGPJ(playerid, response, listitem, inputtext[])
{
	switch(listitem)
	{
		case 0:
		{
			switch(ChosenPJ[playerid])
			{
				case 1: SetPlayerName(playerid, jPJE[playerid][0]);
				case 2: SetPlayerName(playerid, jPJE[playerid][1]);
				case 3: SetPlayerName(playerid, jPJE[playerid][2]);
			}
			SpawnPlayer(playerid);
			load_character(playerid);
			switch(Datos[playerid][jAdmin]){
				case 1337: a_perms[playerid] = CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD ;
				case 5: a_perms[playerid] = CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
				case 4: a_perms[playerid] = CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
				case 3: a_perms[playerid] = CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
				case 2: a_perms[playerid] = CMD_MOD | CMD_JR_MOD;
				case 1: a_perms[playerid] = CMD_JR_MOD;
			}
		}
		case 1:
		{
			clear_chardata(playerid);
			return dialog_personajes(playerid);
		}
	}
	return 1;
}

