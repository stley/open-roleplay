forward TimeOutRequest(playerid);

public TimeOutRequest(playerid){
    solicitud_tipo[playerid] = 0;
    solicitante[playerid] = 0;
    if(IsValidTimer(solicitud_timer[playerid])) KillTimer(solicitud_timer[playerid]);
    SendClientMessage(playerid, COLOR_BLUE, "Rechazaste automáticamente la solicitud.");
    return 1;
}

tp_player(playerid, Float:pos_x, Float:pos_y, Float:pos_z, interior, virtualworld){
    SetPlayerPos(playerid, pos_x, pos_y, pos_z);
    SetPlayerInterior(playerid, interior);
    SetPlayerVirtualWorld(playerid, virtualworld);
    return 1;
}