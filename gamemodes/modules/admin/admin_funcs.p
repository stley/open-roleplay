forward adminRefresh(playerid);

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