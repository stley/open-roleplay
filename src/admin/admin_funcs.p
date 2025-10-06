forward adminRefresh(playerid);
forward adminUpdate(playerid, const account[], rank);

#define HIER_TOP           CMD_JR_MOD
#define ALL_FROM(%0)      ((HIER_TOP << 1) - (%0))

public adminRefresh(playerid){
	new mask;
    switch(Datos[playerid][jAdmin]){
        case 1338, 1337: mask = ALL_FROM(CMD_OWNER);
        case 7, 6, 5:    mask = ALL_FROM(CMD_ADMIN);
        case 4:          mask = ALL_FROM(CMD_OPERATOR);
        case 3:          mask = ALL_FROM(CMD_JR_OPERATOR);
        case 2:          mask = ALL_FROM(CMD_MOD);
        case 1:          mask = ALL_FROM(CMD_JR_MOD);
        default:         mask = 0;
	}
	if(Datos[playerid][jFacMan]) mask |= CMD_FACTION_MANAGER;
	if(Datos[playerid][jStaffMan]) mask |= CMD_STAFF_MANAGER;
	if(Datos[playerid][jPropMan]) mask |= CMD_PROPERTY_MANAGER;
	a_perms[playerid] = mask;
    return 1;
}

public adminUpdate(playerid, const account[], rank){
    if(cache_num_rows()){
        new curr_rank, sqlid, retrieved_acc[35];
        cache_get_value_name_int(0, "SQLID", sqlid);
        cache_get_value_name(0, "Nombre", retrieved_acc, sizeof(retrieved_acc));
        cache_get_value_name_int(0, "Administrador", curr_rank);
        if(curr_rank == rank) return SendClientMessage(playerid, COLOR_DARKRED, "El usuario ya tiene ese rango administrativo.");
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "Le cediste el rango administrativo nivel %d a %s. (%d > %d)", rank, retrieved_acc, curr_rank, rank);
        serverLogRegister(sprintf("%s (%s) le cedió rango administrativo nivel %d a %s. (%d > %d)", username[playerid], Name_sin(GetName(playerid)), rank, retrieved_acc, curr_rank, rank), CURRENT_MODULE);
        new query[96];
        mysql_format(SQLDB, query, sizeof(query), "UPDATE `accounts` SET `Administrador` = %d WHERE `SQLID` = %d", rank, sqlid);
        mysql_tquery(SQLDB, query);
        return 1;
    }
    else SendClientMessage(playerid, COLOR_DARKRED, "¡La cuenta %s no existe!", account);
    return 1;
}