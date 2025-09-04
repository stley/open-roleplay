forward adminRefresh(playerid);

public adminRefresh(playerid){
    switch(Datos[playerid][jAdmin]){
        case 1338: a_perms[playerid] = CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD ;
		case 1337: a_perms[playerid] = CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD ;
		case 7: a_perms[playerid] = CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
        case 6: a_perms[playerid] = CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
        case 5: a_perms[playerid] = CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
		case 4: a_perms[playerid] = CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
		case 3: a_perms[playerid] = CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD;
		case 2: a_perms[playerid] = CMD_MOD | CMD_JR_MOD;
		case 1: a_perms[playerid] = CMD_JR_MOD;
        default: a_perms[playerid] = 0;
	}
    return 1;
}