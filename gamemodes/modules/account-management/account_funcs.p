forward accountPassHash(playerid, const password[], is_register);
forward accountPassCheck(playerid, bool:success);
forward accountOnCharFirstLoad(playerid);
forward accountOnPlayerDisconnect(playerid, reason);
forward accountAutoSave(playerid);
forward accountOnUserDataSaved(playerid);
forward accountOnCharDataSaved(playerid, type);
forward accountLoadToys(playerid);
forward accountOnPlayerConnect(playerid);
forward accountOnGameModeExit();
forward ClearPlayerVars(playerid);
forward characterRespawn(playerid);
forward onCharacterInventorySave(playerid);
forward accountGlobalAutoSave();
forward accountOnUserFirstLoad(playerid);
forward accountOnPlayerRequestClass(playerid, classid);
forward accountOnUserCharacterList(playerid);
forward accountOnCharToyInsert(playerid);
forward accountOnCharInserted(playerid);
forward onUserRegister(playerid);

forward updateToys(playerid);



public accountOnPlayerConnect(playerid)
{
	new login[32];
    serverLogRegister(sprintf("%s ingresó al servidor (IP: %s | playerid %d)", GetName(playerid), GetPIP(playerid), playerid));
	ClearPlayerVars(playerid);
	clear_wounds(playerid);
	GetPlayerName(playerid, initialname[playerid], MAX_PLAYER_NAME);
	formatt(login, "Conectando_%d", playerid);
	SetPlayerName(playerid, login);
	return 1;
}

public accountPassHash(playerid, const password[], is_register){
	if(is_register){
		bcrypt_get_hash(Datos[playerid][jClave]);
		return dialog_email(playerid);
	}
	else bcrypt_verify(playerid, "accountPassCheck", password, Datos[playerid][jClave]);
	return 1;
}
public accountPassCheck(playerid, bool:success){
	new query_str[128];
	if(success){
		Datos[playerid][LoggedIn] = true;
		alm(Datos[playerid][jIP], GetPIP(playerid));
		mysql_format(SQLDB, query_str, sizeof(query_str), "UPDATE `accounts` SET `online` = 1 WHERE `SQLID` = %d", Datos[playerid][jSQLID]);
		mysql_tquery(SQLDB, query_str);
		serverLogRegister(sprintf("%s (IP: %s | playerid %d) ingresó al usuario %s (SQLID: %d)", initialname[playerid], Datos[playerid][jIP], playerid, username[playerid], Datos[playerid][jSQLID]));
		return dialog_personajes(playerid);
	}
	else
	{
		if(IntentosLogin[playerid] < 3)
		{
			serverLogRegister(sprintf("%s falló en su intento numero %d de ingresar a la cuenta %s", GetPIP(playerid), IntentosLogin[playerid], username[playerid]));
			IntentosLogin[playerid]++;
			SendClientMessage(playerid, COLOR_DARKRED, "Ingresaste una contraseña incorrecta, intenta de nuevo.");
			return dialog_ingreso(playerid);
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Has sido expulsado luego de muchos intentos fallidos de ingresar.");
			serverLogRegister(sprintf("%s falló en su último intento de ingresar a la cuenta %s", GetPIP(playerid), username[playerid]));
			playerDelayedKick(playerid, 2000);
		}
	}
	return 1;
}



public accountOnCharInserted(playerid){
	if(orm_errno(Datos[playerid][ORMPJ]) != ERROR_OK){
		SendClientMessage(playerid, COLOR_DARKRED, "Ocurrió un error al crear tu personaje. Intenta de nuevo más tarde o contacta con administración.");
		serverLogRegister(sprintf("ERROR AL CREAR EL PERSONAJE %s A %s (%d), (orm_errno no devolvio ERROR_OK!)", Datos[playerid][jNombrePJ], username[playerid], playerid));
		playerDelayedKick(playerid, 1000);
		return 1;
	}
	serverLogRegister(sprintf("La cuenta %s (SQLID %d) creó el personaje %s.", username[playerid], Datos[playerid][jSQLID], Datos[playerid][jNombrePJ]));
	new dslog[128];
	mysql_format(SQLDB, dslog, sizeof(dslog), "INSERT INTO `char_toys` (`character_id`) VALUES (%d)", Datos[playerid][jSQLIDP]);
	mysql_tquery(SQLDB, dslog);
	characterSave(playerid);
	return 1;
}

public accountOnCharToyInsert(playerid){
	if(orm_errno(CharToys[playerid][ORM_toy]) != ERROR_OK){
		SendClientMessage(playerid, COLOR_DARKRED, "No se pudo crear la tabla de accesorios del personaje.");
		playerDelayedKick(playerid, 1000);
		serverLogRegister(sprintf("ERROR AL CREAR ACCESORIOS DEL PERSONAJE %s (%d), (orm_errno no devolvio ERROR_OK!)", Datos[playerid][jNombrePJ], playerid));
		return 1;
	}
	serverLogRegister(sprintf("Insertada la tabla de objetos para el personaje %s (SQLID PJ: %d)", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]));
	orm_setkey(CharToys[playerid][ORM_toy], "character_id");
	return 1;
}



characterTextDraws(playerid){
	Gun_Hud[playerid][0] = CreatePlayerTextDraw(playerid, 586.000, 113.000, "Vacío");
	PlayerTextDrawLetterSize(playerid, Gun_Hud[playerid][0], 0.260, 1.500);
    PlayerTextDrawAlignment(playerid, Gun_Hud[playerid][0], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, Gun_Hud[playerid][0], -1);
    PlayerTextDrawSetShadow(playerid, Gun_Hud[playerid][0], 1);
    PlayerTextDrawSetOutline(playerid, Gun_Hud[playerid][0], 1);
    PlayerTextDrawBackgroundColour(playerid, Gun_Hud[playerid][0], 150);
    PlayerTextDrawFont(playerid, Gun_Hud[playerid][0], TEXT_DRAW_FONT_2);
    PlayerTextDrawSetProportional(playerid, Gun_Hud[playerid][0], true);
	Gun_Hud[playerid][1] = CreatePlayerTextDraw(playerid, 611.000, 131.000, "0/0");
	PlayerTextDrawLetterSize(playerid, Gun_Hud[playerid][1], 0.280, 1.600);
    PlayerTextDrawAlignment(playerid, Gun_Hud[playerid][1], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColour(playerid, Gun_Hud[playerid][1], -1);
    PlayerTextDrawSetShadow(playerid, Gun_Hud[playerid][1], 1);
    PlayerTextDrawSetOutline(playerid, Gun_Hud[playerid][1], 1);
    PlayerTextDrawBackgroundColour(playerid, Gun_Hud[playerid][1], 150);
    PlayerTextDrawFont(playerid, Gun_Hud[playerid][1], TEXT_DRAW_FONT_3);
    PlayerTextDrawSetProportional(playerid, Gun_Hud[playerid][1], true);
}

loadCharacter(playerid)
{
	Datos[playerid][EnChar] = true;
	
	SetPlayerTeam(playerid, 1);
	SetPlayerHealth(playerid, Datos[playerid][jVida]);
	SetPlayerArmour(playerid, Datos[playerid][jChaleco]);
	SetPlayerSkin(playerid, Datos[playerid][jRopa]);
	SetPlayerPos(playerid, Datos[playerid][jPosX], Datos[playerid][jPosY], Datos[playerid][jPosZ]);
	SetPlayerInterior(playerid, Datos[playerid][jInt]);
	SetPlayerVirtualWorld(playerid, Datos[playerid][jVW]);
	SetPlayerFacingAngle(playerid, Datos[playerid][jPosR]);
	GivePlayerMoney(playerid, Datos[playerid][jDinero]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1000);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 400);
	characterTextDraws(playerid);
	SetTimerEx("update_manos", 1000, false, "d", playerid);
	SetTimerEx("update_torso", 1500, false, "d", playerid);
	SetTimerEx("accountLoadToys", 1000, false, "d", playerid);
	SendClientMessage(playerid, COLOR_SYSTEM, "Bienvenido, %s (%s). Tu última conexión fue el %s.", GetRPName(playerid), username[playerid], Datos[playerid][UltimaConexion]);
	alm(Datos[playerid][UltimaConexion], FechaActual());
	SetTimerEx("CharVeh_Load", 1500, false, "d", Datos[playerid][jSQLIDP]);
	if(muerto[playerid] == 1){
		muerto[playerid] = 0;
		woundHandleDamage(playerid, playerid, 0, 3, 100);
	}
	else if(muerto[playerid] == 2){
		muerto[playerid] = 0;
		woundHandleDamage(playerid, playerid, 0, 3, 100);
		woundHandleDamage(playerid, playerid, 0, 3, 100);
	}
	if(IsValidTimer(autosaveTimer[playerid])){
		KillTimer(autosaveTimer[playerid]);
		autosaveTimer[playerid] = SetTimerEx("accountAutoSave", 600000, true, "d", playerid);
	}
	return 1;
}

public characterRespawn(playerid){
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1000);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1000);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 800);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 400);
	characterTextDraws(playerid);
	SetTimerEx("update_manos", 1000, false, "d", playerid);
	SetTimerEx("update_torso", 1500, false, "d", playerid);
	SetTimerEx("updateToys", 1500, false, "d", playerid);
	//SetTimerEx("accountLoadToys", 1000, false, "d", playerid);
}
public updateToys(playerid){
	new modelid;
	if(CharToys[playerid][jToy_Gorro]){
		modelid = ObjetoInfo[CharToys[playerid][jToy_Gorro]][ModeloObjeto];
		SetPlayerAttachedObject(playerid, 4, modelid, 2, CharToys[playerid][GorroPos][0], CharToys[playerid][GorroPos][1], CharToys[playerid][GorroPos][2], CharToys[playerid][GorroRot][0], CharToys[playerid][GorroRot][1], CharToys[playerid][GorroRot][2], CharToys[playerid][GorroScale][0], CharToys[playerid][GorroScale][1], CharToys[playerid][GorroScale][2]);
	}
	if(CharToys[playerid][jToy_Gafas]){
		modelid = ObjetoInfo[CharToys[playerid][jToy_Gafas]][ModeloObjeto];
		SetPlayerAttachedObject(playerid, 5, modelid, 2, CharToys[playerid][GafasPos][0], CharToys[playerid][GafasPos][1], CharToys[playerid][GafasPos][2], CharToys[playerid][GafasRot][0], CharToys[playerid][GafasRot][1], CharToys[playerid][GafasRot][2], CharToys[playerid][GafasScale][0], CharToys[playerid][GafasScale][1], CharToys[playerid][GafasScale][2]);
	}
	if(CharToys[playerid][jToy_Boca]){
		modelid = ObjetoInfo[CharToys[playerid][jToy_Boca]][ModeloObjeto];
		SetPlayerAttachedObject(playerid, 6, modelid, 2, CharToys[playerid][BocaPos][0], CharToys[playerid][BocaPos][1], CharToys[playerid][BocaPos][2], CharToys[playerid][BocaRot][0], CharToys[playerid][BocaRot][1], CharToys[playerid][BocaRot][2], CharToys[playerid][BocaScale][0], CharToys[playerid][BocaScale][1], CharToys[playerid][BocaScale][2]);
	}
	if(CharToys[playerid][jToy_Pecho]){
		modelid = ObjetoInfo[CharToys[playerid][jToy_Pecho]][ModeloObjeto];
		SetPlayerAttachedObject(playerid, 7, modelid, 1, CharToys[playerid][PechoPos][0], CharToys[playerid][PechoPos][1], CharToys[playerid][PechoPos][2], CharToys[playerid][PechoRot][0], CharToys[playerid][PechoRot][1], CharToys[playerid][PechoRot][2], CharToys[playerid][PechoScale][0], CharToys[playerid][PechoScale][1], CharToys[playerid][PechoScale][2]);	
	}
	return 1;
}

forward accountOnCharLoadToys(playerid);
public accountOnCharLoadToys(playerid){
	if(cache_num_rows()){
		orm_apply_cache(CharToys[playerid][ORM_toy], 0);
	
		new modelid;
		if(CharToys[playerid][jToy_Gorro]){
			modelid = ObjetoInfo[CharToys[playerid][jToy_Gorro]][ModeloObjeto];
			SetPlayerAttachedObject(playerid, 4, modelid, 2, CharToys[playerid][GorroPos][0], CharToys[playerid][GorroPos][1], CharToys[playerid][GorroPos][2], CharToys[playerid][GorroRot][0], CharToys[playerid][GorroRot][1], CharToys[playerid][GorroRot][2], CharToys[playerid][GorroScale][0], CharToys[playerid][GorroScale][1], CharToys[playerid][GorroScale][2]);
		}
		if(CharToys[playerid][jToy_Gafas]){
			modelid = ObjetoInfo[CharToys[playerid][jToy_Gafas]][ModeloObjeto];
			SetPlayerAttachedObject(playerid, 5, modelid, 2, CharToys[playerid][GafasPos][0], CharToys[playerid][GafasPos][1], CharToys[playerid][GafasPos][2], CharToys[playerid][GafasRot][0], CharToys[playerid][GafasRot][1], CharToys[playerid][GafasRot][2], CharToys[playerid][GafasScale][0], CharToys[playerid][GafasScale][1], CharToys[playerid][GafasScale][2]);
		}
		if(CharToys[playerid][jToy_Boca]){
			modelid = ObjetoInfo[CharToys[playerid][jToy_Boca]][ModeloObjeto];
			SetPlayerAttachedObject(playerid, 6, modelid, 2, CharToys[playerid][BocaPos][0], CharToys[playerid][BocaPos][1], CharToys[playerid][BocaPos][2], CharToys[playerid][BocaRot][0], CharToys[playerid][BocaRot][1], CharToys[playerid][BocaRot][2], CharToys[playerid][BocaScale][0], CharToys[playerid][BocaScale][1], CharToys[playerid][BocaScale][2]);
		}
		if(CharToys[playerid][jToy_Pecho]){
			modelid = ObjetoInfo[CharToys[playerid][jToy_Pecho]][ModeloObjeto];
			SetPlayerAttachedObject(playerid, 7, modelid, 1, CharToys[playerid][PechoPos][0], CharToys[playerid][PechoPos][1], CharToys[playerid][PechoPos][2], CharToys[playerid][PechoRot][0], CharToys[playerid][PechoRot][1], CharToys[playerid][PechoRot][2], CharToys[playerid][PechoScale][0], CharToys[playerid][PechoScale][1], CharToys[playerid][PechoScale][2]);	
		}
	}
	else{
		new query[128];
		mysql_format(SQLDB, query, sizeof(query), "INSERT INTO `char_toys` (`character_id`) VALUES (%d);", Datos[playerid][jSQLIDP]);
		mysql_query(SQLDB, query, false);
		mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `char_toys` WHERE `character_id` = '%d'", Datos[playerid][jSQLIDP]);
		mysql_tquery(SQLDB, query, "accountOnCharLoadToys", "d", playerid);
	}
	return 1;
}
public accountLoadToys(playerid){
	new query[128];
	mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `char_toys` WHERE `character_id` = '%d'", Datos[playerid][jSQLIDP]);
	mysql_tquery(SQLDB, query, "accountOnCharLoadToys", "d", playerid);
	return 1;
}

public accountOnUserDataSaved(playerid){
	if(orm_errno(Datos[playerid][ORMID]) != ERROR_OK){
		serverLogRegister(sprintf("Error al guardar los datos del usuario %s (SQLID %d)", username[playerid], Datos[playerid][jSQLID]));
	}
	else{
		serverLogRegister(sprintf("Guardado el usuario %s, SQLID %d.", username[playerid], Datos[playerid][jSQLID]));
	}
	if(!IsPlayerConnected(playerid)) clear_account_data(playerid);
	return 1;
}
public accountOnCharDataSaved(playerid, type){
	switch(type){
		case 1:{
			if(orm_errno(Datos[playerid][ORMPJ]) != ERROR_OK)
				serverLogRegister(sprintf("Error al guardar los datos del personaje %s (SQLID %d).", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]));
			else
				serverLogRegister(sprintf("Guardado el personaje %s, SQLID %d.", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]));
		}
		case 2:{
			if(orm_errno(CharToys[playerid][ORM_toy]) != ERROR_OK)
				serverLogRegister(sprintf("Error al guardar los accesorios del personaje %s (SQLID %d).", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]));
			if(!IsPlayerConnected(playerid)) clear_chardata(playerid);
			return 1;
		}
	}
	return 1;
}

clear_chardata(playerid){
	
	Datos[playerid][EnChar] = false;
	alm(Datos[playerid][jNombrePJ], "-");
	Datos[playerid][jUsuario] = 0;
	alm(Datos[playerid][jFechaCreacion], "-");
	Datos[playerid][jMano][0] = 0;
	Datos[playerid][jManoCant][0] = 0;
    Datos[playerid][jMano][1] = 0;
	Datos[playerid][jManoCant][1] = 0;
	Datos[playerid][jPecho] = 0;
	Datos[playerid][jPechoCant] = 0;
	Datos[playerid][jEspalda] = 0;
	Datos[playerid][jEspaldaCant] = 0;
	Datos[playerid][jEspaldaData] = 0;
	Datos[playerid][jPechoData] = 0;
    for(new bol; bol < 5; bol++)
	{
        Datos[playerid][jBolsillo][bol] = 0;
	    Datos[playerid][jBolsilloCant][bol] = 0;
	    Datos[playerid][jBolsilloData][bol] = 0;
    }
	Datos[playerid][jLicencias][0] = 0;
    Datos[playerid][jLicencias][1] = 0;
	Datos[playerid][jCasa][0] = 0;
    Datos[playerid][jCasa][1] = 0;
    Datos[playerid][jCasaLlaves] = 0;
	Datos[playerid][jCocheLlaves][0] = 0;
	Datos[playerid][jCocheLlaves][1] = 0;
	Datos[playerid][jNivel] = 0;
	Datos[playerid][jExp] = 0;
	Datos[playerid][jHoras] = 0;
	Datos[playerid][jPuntosRol] = 0;
	Datos[playerid][jPuntosRolNeg] = 0;
	Datos[playerid][jEdad] = 0;
	Datos[playerid][jSexo] = 0;
	Datos[playerid][jDinero] = 0;
	Datos[playerid][jRopa] = 0;
	muerto[playerid] = 0;
	Datos[playerid][jVida] = 0;
	Datos[playerid][jChaleco] = 0;
	Datos[playerid][jPosX] = 0.0;
	Datos[playerid][jPosY] = 0.0;
	Datos[playerid][jPosZ] = 0.0;
	Datos[playerid][jPosR] = 0.0;
	Datos[playerid][jVW] = 0;
	Datos[playerid][jInt] = 0;
	Datos[playerid][jFaccion] = 0;
	Datos[playerid][jRango] = 0;
	Datos[playerid][jDiv] = 0;
	Datos[playerid][jFaccion2] = 0;
	Datos[playerid][jRangoFac2] = 0;
	Datos[playerid][jDiv2] = 0;
	Datos[playerid][jDocumento] = 0;

	//no guardables
	DentroCasa[playerid] = 0;
	DentroNegocio[playerid] = 0;
	EditType[playerid] = 0;
	solicitante[playerid] = -1;
	solicitud_tipo[playerid] = 0;
	solicitud_timer[playerid] = 0;
	esposado[playerid] = 0;
	asesino[playerid] = "-";
	checkpoints[playerid] = 0;
	CinturonV[playerid] = 0;
	CanRespawn[playerid] = false;
	if(Datos[playerid][ORMPJ] != MYSQL_INVALID_ORM){
		orm_destroy(Datos[playerid][ORMPJ]);
		Datos[playerid][ORMPJ] = MYSQL_INVALID_ORM;
	}
	if(cache_is_valid(characterCache[playerid])){
		cache_delete(characterCache[playerid]);
		characterCache[playerid] = MYSQL_INVALID_CACHE;
	}
	if(CharToys[playerid][ORM_toy] != MYSQL_INVALID_ORM){
		orm_clear_vars(CharToys[playerid][ORM_toy]);
		orm_destroy(CharToys[playerid][ORM_toy]);
		CharToys[playerid][ORM_toy] = MYSQL_INVALID_ORM;
	}
	if(Datos[playerid][inventoryORM] != MYSQL_INVALID_ORM){
		orm_clear_vars(Datos[playerid][inventoryORM]);
		orm_destroy(Datos[playerid][inventoryORM]);
		Datos[playerid][inventoryORM] = MYSQL_INVALID_ORM;
	}
	Datos[playerid][jSQLIDP] = 0;
	KillTimer(RespawnTimer[playerid]);
}
clear_account_data(playerid)
{
	if(Datos[playerid][ORMID] != MYSQL_INVALID_ORM){
		orm_destroy(Datos[playerid][ORMID]);
		Datos[playerid][ORMID] = MYSQL_INVALID_ORM;
	}
	a_perms[playerid] = 0;
	Datos[playerid][jNombre][0] = EOS;
	Datos[playerid][jEmail][0] = EOS;
	Datos[playerid][FechaReg][0] = EOS;
	Datos[playerid][UltimaConexion][0] = EOS;
	Datos[playerid][jClave][0] = EOS;
	Datos[playerid][jIP][0] = EOS;
	Datos[playerid][jSQLID] = 0;
	Datos[playerid][jAdmin] = 0;
	Datos[playerid][jCreditos] = 0;
	Datos[playerid][CharacterLimit] = DEFAULT_MAX_CHARACTERS;
	Datos[playerid][LoggedIn] = false;
	if(characterCache[playerid]){
		cache_delete(characterCache[playerid]);
		characterCache[playerid] = MYSQL_INVALID_CACHE;
	}
}
public ClearPlayerVars(playerid)
{
	clear_account_data(playerid);
	clear_chardata(playerid);
	return 1;	
}
accountSave(playerid){
	if(Datos[playerid][ORMID] == MYSQL_INVALID_ORM){
		serverLogRegister(sprintf("ORMID playerid %d invalida", playerid));
		return 1;
	}
	serverLogRegister(sprintf("Guardando la cuenta %s (SQLID: %d) | (playerid: %d)", username[playerid], Datos[playerid][jSQLID], playerid));
	orm_update(Datos[playerid][ORMID], "accountOnUserDataSaved", "d", playerid);
	return 1;
}
characterSave(playerid)
{
	serverLogRegister(sprintf("Guardando el personaje %s (SQLID: %d) de la cuenta %s (SQLID: %d) | (playerid: %d)", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP], username[playerid], Datos[playerid][jSQLID], playerid));
	if(Datos[playerid][ORMPJ] == MYSQL_INVALID_ORM){
		serverLogRegister(sprintf("[characterSave] ORMPJ playerid %d invalida", playerid));
		return 1;
	}
	GetPlayerPos(playerid, Datos[playerid][jPosX], Datos[playerid][jPosY], Datos[playerid][jPosZ]);
	GetPlayerFacingAngle(playerid, Datos[playerid][jPosR]);
	Datos[playerid][jInt] = GetPlayerInterior(playerid);
	Datos[playerid][jVW] = GetPlayerVirtualWorld(playerid);
	
	orm_update(Datos[playerid][ORMPJ], "accountOnCharDataSaved", "dd", playerid, 1);
	orm_update(CharToys[playerid][ORM_toy], "accountOnCharDataSaved", "dd", playerid, 2);
	return 1;
}

saveCharacterInventory(playerid){
	if(Datos[playerid][inventoryORM] == MYSQL_INVALID_ORM){
		serverLogRegister(sprintf("inventoryORM playerid %d invalida", playerid));
		return 1;
	}
	orm_update(Datos[playerid][inventoryORM], "onCharacterInventorySave", "d", playerid);
	return 1;
}

public onCharacterInventorySave(playerid){
	if(orm_errno(Datos[playerid][inventoryORM]) != ERROR_OK)
		return serverLogRegister(sprintf("Error al guardar el inventario de %s (SQLID %d)!", GetName(playerid), Datos[playerid][jSQLIDP]));
	else
		return serverLogRegister(sprintf("Se guardó el inventario de %s (SQLID %d).", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]));
}

bool:hasDriverOnline(veh_idex, exclude){
	foreach(new playerid: Player){
		if(playerid == exclude) continue;
		if(vehData[veh_idex][veh_OwnerID] == Datos[playerid][jSQLIDP]) return true;
		for(new i; i < 2; i++){
			if(vehData[veh_idex][veh_SQLID] == Datos[playerid][jCocheLlaves][i]) return true;
		}
	}
	return false;
}

public accountOnPlayerDisconnect(playerid, reason)
{
	if(Datos[playerid][LoggedIn] == true)
	{
		new query[96];
		accountSave(playerid);
		if(Datos[playerid][EnChar] == true) characterSave(playerid);
		mysql_format(SQLDB, query, sizeof(query), "UPDATE `accounts` SET `online` = 0 WHERE `Nombre` = '%e'", username[playerid]);
		mysql_tquery(SQLDB, query);
	}
	for(new i; i < MAX_VEHICULOS; i++){
		if(vehData[i][veh_SQLID]){

			if(vehData[i][veh_OwnerID] == Datos[playerid][jSQLIDP]){
				if(IsValidTimer(savehTimer[i])) KillTimer(savehTimer[i]);
				if(!hasDriverOnline(i, playerid)){
					vehTimer[i] = SetTimerEx("CharVeh_Free", 720000, false, "d", i);
				}
			}
			for(new v; v < 2; v++){
				if(vehData[i][veh_SQLID] == Datos[playerid][jCocheLlaves][v]){
					if(!hasDriverOnline(i, playerid)){
						vehTimer[i] = SetTimerEx("CharVeh_Free", 720000, false, "d", i);
					}
				}
			}
		}
	}
	if(IsValidTimer(solicitud_timer[playerid])) KillTimer(solicitud_timer[playerid]);
	if(IsValidTimer(autosaveTimer[playerid])) KillTimer(autosaveTimer[playerid]);
	return 1;
}




public accountOnGameModeExit(){
	return 1;
}

public accountOnPlayerRequestClass(playerid, classid)
{
	if(!Datos[playerid][LoggedIn])
		return dialog_username(playerid);	
	return 0;
}

public accountOnUserFirstLoad(playerid)
{
	
	return 1;
}

public onUserRegister(playerid){
	if(orm_errno(Datos[playerid][ORMID]) != ERROR_OK){
		yield 1;
		SendClientMessage(playerid, COLOR_DARKRED, "Ocurrió un error al crear tu cuenta. Intenta de nuevo más tarde o contacta a adminstración.");
		serverLogRegister(sprintf("ERROR AL CREAR LA CUENTA %s (%d), (orm_errno no devolvio ERROR_OK!)", username[playerid], playerid));
		playerDelayedKick(playerid, 1000);
	}
	new response[DIALOG_RESPONSE];
	await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "¡Enhorabuena!", "Tu cuenta ha sido creada correctamente.", "Continuar", "");
	if(!response[DIALOG_RESPONSE_RESPONSE]){
		Datos[playerid][LoggedIn] = true;
		return dialog_personajes(playerid);
	}
	else{
		Datos[playerid][LoggedIn] = true;
		return dialog_personajes(playerid);
	}
}

public accountGlobalAutoSave(){
	yield 1;
	foreach(new playerid: Player){
		if(Datos[playerid][jSQLID]){
			accountAutoSave(playerid);
		}
		else continue;
		wait_ticks(1);
	}
	return 1;
}

public accountAutoSave(playerid){
	if(Datos[playerid][LoggedIn] == true)
	{
		
		serverLogRegister(sprintf("Ejecutando el autoguardado del usuario %s (SQLID %d)...", username[playerid], Datos[playerid][jSQLID]));
		if(Datos[playerid][EnChar] == true){
			serverLogRegister(sprintf("Ejecutando el autoguardado del personaje %s (SQLID %d)...", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]));
			characterSave(playerid);
		}
		accountSave(playerid);
	}
	return 1;
}