forward TimeOutRequest(playerid);
forward Ply_OnPlayerDisconnect(playerid, reason);

public TimeOutRequest(playerid){
    solicitud_tipo[playerid] = 0;
    solicitante[playerid] = 0;
    if(IsValidTimer(solicitud_timer[playerid])) KillTimer(solicitud_timer[playerid]);
    SendClientMessage(playerid, COLOR_BLUE, "Rechazaste automáticamente la solicitud.");
    return 1;
}

public Ply_OnPlayerDisconnect(playerid, reason){
    new idex = GetPVarInt(playerid, "veh_mal");
    if(idex){
        vehData[idex-1][veh_Trunk] = false;
        Vehicles_Trunk(idex-1);
    }
    return 1;
}

tp_player(playerid, Float:pos_x, Float:pos_y, Float:pos_z, interior, virtualworld){
    SetPlayerPos(playerid, pos_x, pos_y, pos_z);
    SetPlayerInterior(playerid, interior);
    SetPlayerVirtualWorld(playerid, virtualworld);
    return 1;
}

spend_money(playerid, quantity){
    if(!IsPlayerConnected(playerid)) return 1;
    if(quantity > Datos[playerid][jDinero]){
        if(ObjetoInfo[Datos[playerid][jMano][0]][ModeloObjeto] != 19792) return SendClientMessage(playerid, COLOR_DARKRED, "¡No tienes suficiente dinero, ni una tarjeta de débito en tu mano derecha!");
        //WIP - Se incluirá con el sistema bancario
    }
    ResetPlayerMoney(playerid);
    Datos[playerid][jDinero]=-quantity;
    GivePlayerMoney(playerid, Datos[playerid][jDinero]);
    SendClientMessage(playerid, COLOR_GREEN, "Gastas %s de tus bolsillos.", quantity);
    GameTextForPlayer(playerid, "~r~$%s", 3000, 2, quantity);

    return 1;
}

add_money(playerid, quantity){
    if(!IsPlayerConnected(playerid)) return 1;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, (Datos[playerid][jDinero]+=quantity));
    GameTextForPlayer(playerid, "~g~$%s", 3000, 2, quantity);
    return 1;
}