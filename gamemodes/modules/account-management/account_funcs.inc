
forward accountOnCharFirstLoad(playerid);
forward accountOnPlayerDisconnect(playerid, reason);
forward accountOnUserDataSaved(playerid);
forward accountOnCharDataSaved(playerid);
forward accountLoadToys(playerid);
forward accountOnPlayerConnect(playerid);
forward accountOnGameModeExit();
forward characterRespawn(playerid);
forward accountOnUserFirstLoad(playerid);
forward accountOnPlayerRequestClass(playerid, classid);
forward accountOnUserCharacterList(playerid);
forward accountOnCharToyInsert(playerid);
forward accountOnCharInserted(playerid);
forward updateToys(playerid);

public OnDialogPerformed(playerid, const dialog[], response, success) {
    return 1;
}

public accountOnPlayerConnect(playerid)
{
	new str[129];
	ClearPlayerVars(playerid);
	clear_wounds(playerid);
	GetPlayerName(playerid, initialname[playerid], MAX_PLAYER_NAME);
	formatt(str, "Conectando_%d", playerid);
	SetPlayerName(playerid, str);
	return 1;
}

public accountOnUserCharacterList(playerid){
	new dlg[2000], dlg_buff[96];
	new charname[MAX_PLAYER_NAME];
	if(cache_num_rows()){
		for(new i; i < cache_num_rows(); i++){
			cache_get_value_name_int(i, "Usuario", cachePersonajes[playerid][userID][i]);
			cache_get_value_name_int(i, "SQLIDPJ", cachePersonajes[playerid][charID][i]);
			cache_get_value_name(i, "NombrePJ", charname);
			if(i == 0) formatt(dlg_buff, "%s [%d]\n", charname, cachePersonajes[playerid][charID][i]);
			else if(i == cache_num_rows()-1) formatt(dlg_buff, "%s [%d]", charname, cachePersonajes[playerid][charID][i]);
			else formatt(dlg_buff, "%s [%d]\n", charname, cachePersonajes[playerid][charID][i]);
			strcat(dlg, dlg_buff);
		}
	}	
	if(cache_num_rows() && cache_num_rows() < Datos[playerid][CharacterLimit]){
		strcat(dlg, "\n{C0C0C0}Crear otro personaje");
	}
	else{
		strcat(dlg, "\n{C0C0C0}Crear un personaje");
	}
	return Dialog_Show(playerid, D_PERSONAJES, DIALOG_STYLE_LIST, "Personajes disponibles", dlg, "Ingresar", "Salir");
}

public accountOnCharFirstLoad(playerid)
{
	if(cache_num_rows()){
		orm_apply_cache(Datos[playerid][ORMPJ], 0);
		return Dialog_Show(playerid, D_INGPJ, DIALOG_STYLE_LIST, Datos[playerid][jNombrePJ], "Ingresar\nSolicitar eliminación (No aún)", "Seleccionar", "Salir");
	}
	else
	{
		clear_chardata(playerid);
		save_account(playerid);
		return dialog_personajes(playerid);
	}
}
public accountOnCharInserted(playerid){
	new dslog[512];
	new slot;
	for(new i; i < Datos[playerid][CharacterLimit]; i++){
		if(cachePersonajes[playerid][charID][i] == Datos[playerid][jSQLIDP]){
			slot = i;
			break;
		}
		else continue;
	}
	format(dslog, sizeof(dslog), "La cuenta %s (SQLID %d) creó el personaje %s en su slot %d/%d", username[playerid], Datos[playerid][jSQLID], Datos[playerid][jNombrePJ], slot+1, Datos[playerid][CharacterLimit]);
	serverLogRegister(dslog);
	mysql_format(SQLDB, dslog, sizeof(dslog), "INSERT INTO `char_toys` (`character_id`) VALUES (%d)", Datos[playerid][jSQLIDP]);
	mysql_tquery(SQLDB, dslog);
	save_char(playerid);
	return 1;
}
public accountOnCharToyInsert(playerid){
	new dslog[512];
	format(dslog, sizeof(dslog), "Insertando tabla de objetos para el personaje %s (SQLID PJ: %d)", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP]);
	serverLogRegister(dslog);
	orm_setkey(CharToys[playerid][ORM_toy], "character_id");
	return 1;
}
/*bool:accountCheck(account_name[]){
	new query[128], sqlid;
	if(isnull(account_name)) return 0;
	mysql_format(SQLDB, "SELECT `SQLID` FROM `accounts` WHERE `Nombre` = `%e` LIMIT 1", account_name);
	new Cache:accountQuery;
	accountQuery = mysql_query(SQLDB, query);
	cache_set_active(accountQuery);
	cache_get_value_name_int(0, "SQLID", sqlid);
	cache_delete(accountQuery);
	return sqlid;
}*/


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

load_character(playerid)
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
		Wound_HandleDamage(playerid, playerid, 0, 3, 100);
	}
	else if(muerto[playerid] == 2){
		muerto[playerid] = 0;
		Wound_HandleDamage(playerid, playerid, 0, 3, 100);
		Wound_HandleDamage(playerid, playerid, 0, 3, 100);
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

public  accountOnUserDataSaved(playerid) return 1;
public  accountOnCharDataSaved(playerid) return 1;

clear_chardata(playerid)
{
	if(Datos[playerid][ORMPJ] != MYSQL_INVALID_ORM){
		orm_destroy(Datos[playerid][ORMPJ]);
		Datos[playerid][ORMPJ] = MYSQL_INVALID_ORM;
	}
	Datos[playerid][jSQLIDP] = 0;
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
	Datos[playerid][jCoche][0] = 0;
	Datos[playerid][jCocheLlaves][0] = 0;
    Datos[playerid][jCoche][1] = 0;
	Datos[playerid][jCocheLlaves][1] = 0;
	Datos[playerid][jCasa][0] = 0;
    Datos[playerid][jCasa][1] = 0;
    Datos[playerid][jCasaLlaves] = 0;
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

	if(CharToys[playerid][ORM_toy] != MYSQL_INVALID_ORM){
		orm_destroy(CharToys[playerid][ORM_toy]);
		CharToys[playerid][ORM_toy] = MYSQL_INVALID_ORM;
	}
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
	/*CanRespawn[playerid] = false;
	KillTimer(RespawnTime[playerid]);
	KillTimer(SuccumbTime[playerid]);*/


}
clear_account_data(playerid)
{
	if(Datos[playerid][ORMID] != MYSQL_INVALID_ORM){
		orm_destroy(Datos[playerid][ORMID]);
		Datos[playerid][ORMID] = MYSQL_INVALID_ORM;
	}
	a_perms[playerid] = 0;
	alm(Datos[playerid][jNombre], "-");
	alm(Datos[playerid][jEmail], "-");
	alm(Datos[playerid][FechaReg], "-");
	alm(Datos[playerid][UltimaConexion], "-");
	alm(Datos[playerid][jClave], "-");
	alm(Datos[playerid][jIP], "-");
	Datos[playerid][jSQLID] = 0;
	Datos[playerid][jAdmin] = 0;
	Datos[playerid][jCreditos] = 0;
	Datos[playerid][CharacterLimit] = DEFAULT_MAX_CHARACTERS;
	Datos[playerid][LoggedIn] = false;
	for(new i; i < MAX_CHARACTERS; i++){
		cachePersonajes[playerid][charID][i] = 0;
		cachePersonajes[playerid][userID][i] = 0;
		//cachePersonajes[playerid][slotOrder][i] = 0;
	}
}
ClearPlayerVars(playerid)
{
	clear_account_data(playerid);
	clear_chardata(playerid);
	return 1;	
}
save_account(playerid){
	if(Datos[playerid][ORMID] == MYSQL_INVALID_ORM) serverLogRegister(sprintf("ORMID playerid %d invalida", playerid));
	new dslog[512];
	format(dslog, sizeof(dslog), "Guardando la cuenta %s (SQLID: %d) | (playerid: %d)", username[playerid], Datos[playerid][jSQLID], playerid);
	serverLogRegister(dslog);
	return orm_update(Datos[playerid][ORMID]);
}
save_char(playerid)
{
	new dslog[512];
	format(dslog, sizeof(dslog), "Guardando el personaje %s (SQLID: %d) de la cuenta %s (SQLID: %d) | (playerid: %d)", Datos[playerid][jNombrePJ], Datos[playerid][jSQLIDP], username[playerid], Datos[playerid][jSQLID], playerid);
	serverLogRegister(dslog);
	GetPlayerPos(playerid, Datos[playerid][jPosX], Datos[playerid][jPosY], Datos[playerid][jPosZ]);
	GetPlayerFacingAngle(playerid, Datos[playerid][jPosR]);
	Datos[playerid][jInt] = GetPlayerInterior(playerid);
	Datos[playerid][jVW] = GetPlayerVirtualWorld(playerid);
	if(Datos[playerid][ORMPJ] == MYSQL_INVALID_ORM){
		format(dslog, sizeof(dslog), "ORMPJ playerid %d invalida", playerid);
		serverLogRegister(dslog);
	}
	orm_update(CharToys[playerid][ORM_toy]);
	return orm_update(Datos[playerid][ORMPJ]);
}

public accountOnPlayerDisconnect(playerid, reason)
{
	if(Datos[playerid][LoggedIn] == true)
	{
		new query[96];
		save_account(playerid);
		if(Datos[playerid][EnChar] == true) save_char(playerid);
		mysql_format(SQLDB, query, sizeof(query), "UPDATE `accounts` SET `online` = 0 WHERE `Nombre` = '%e'", username[playerid]);
		mysql_tquery(SQLDB, query);
	}
	for(new i; i < MAX_VEHICULOS; i++){
		if(vehData[i][veh_SQLID] == Datos[playerid][jCoche][0] || vehData[i][veh_SQLID] == Datos[playerid][jCoche][1]){
			if(IsValidTimer(savehTimer[i])) KillTimer(savehTimer[i]);
			vehTimer[i] = SetTimerEx("CharVeh_Free", 720000, false, "d", i);
		}
	}
	if(IsValidTimer(solicitud_timer[playerid])) KillTimer(solicitud_timer[playerid]);
	ClearPlayerVars(playerid);
	return 1;
}

public accountOnGameModeExit(){
	for(new i; i < MAX_PLAYERS; i++){
		if(IsPlayerConnected(i)){
			if(Datos[i][EnChar] == true) save_char(i);
			else if(Datos[i][LoggedIn] == true) save_account(i);
			ClearPlayerVars(i);
			//SetPlayerName(i, username[i]);
			SetTimerEx("Kick", 2000, false, "d", i);
			continue;
		}
		else continue;
	}
	return 1;
}

public accountOnPlayerRequestClass(playerid, classid)
{
	Dialog_Show(playerid, D_USERNAME, DIALOG_STYLE_INPUT, "¡Bienvenido!", "Ingresa tu nombre de usuario para continuar:", "Ingresar", "Salir");
	return 1;
}

public accountOnUserFirstLoad(playerid)
{
	new str[150];
	if(cache_num_rows())
	{
		orm_apply_cache(Datos[playerid][ORMID], 0);
		formatt(str, "Bienvenido %s.\nIngresa tu contraseña para continuar.", username[playerid]);
		Dialog_Show(playerid, D_INGRESO, DIALOG_STYLE_PASSWORD, "Ingreso", str, "Ingresar", "Salir");
	}
	else
	{
		formatt(str, "Bienvenido %s.\nIngrese una contraseña para continuar.", username[playerid]);
		Dialog_Show(playerid, D_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", str, "Continuar", "Salir");
	}
	return 1;
}