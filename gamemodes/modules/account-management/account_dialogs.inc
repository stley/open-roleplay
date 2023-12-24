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
		mysql_tquery(SQLDB, query, "Acc_OnCharFirstLoad", "d", playerid);
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
				case 1337: a_perms[playerid] = CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
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