CMD:aceptar(playerid){
    if(!solicitud_tipo[playerid]) return 1;
    KillTimer(solicitud_timer[playerid]);
    new solid = solicitante[playerid];
    solicitante[playerid] = -1;
    if(solid == -1 || !IsPlayerConnected(solid) || Datos[solid][EnChar] != true){
        SendClientMessage(playerid, COLOR_DARKRED, "No encontramos al jugador que hizo la solicitud.");
        solicitud_tipo[playerid] = 0;
        return 1;
    }
    switch(solicitud_tipo[playerid]){
        case 1:{ //cacheo /revisar
            if(GetDistanceBetweenPlayers(playerid, solid) > 5.0) return SendClientMessage(solid, COLOR_DARKRED, "¡Estás muy lejos del jugador!");
            SendClientMessage(solid, COLOR_DARKGREEN, "Encuentras en los bolsillos de %s:", GetRPName(playerid));
            for(new i; i < 5; i++){
                if(Datos[playerid][jBolsillo][i]){
                    SendClientMessage(solid, COLOR_SEAGREEN, "%s (%d) [%d]", ObjetoInfo[Datos[playerid][jBolsillo][i]][NombreObjeto], Datos[playerid][jBolsilloCant][i], Datos[playerid][jBolsilloData][i]);
                    continue;
                }
                else continue;
            }
            if(Datos[playerid][jEspalda]) SendClientMessage(solid, COLOR_DARKGREEN, "Notas que tiene un %s (%d) [%d] en su espalda.", ObjetoInfo[Datos[playerid][jEspalda]][NombreObjeto], Datos[playerid][jEspaldaCant], Datos[playerid][jEspaldaData]);
            if(Datos[playerid][jPecho]) SendClientMessage(solid, COLOR_DARKGREEN, "Notas que tiene un %s (%d) [%d] en su pecho.", ObjetoInfo[Datos[playerid][jPecho]][NombreObjeto], Datos[playerid][jPechoCant], Datos[playerid][jPechoData]);
            if(Datos[playerid][jMano][0]) SendClientMessage(solid, COLOR_DARKGREEN, "Notas tambien que tiene un %s (%d) [%d] en su mano derecha.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto], Datos[playerid][jManoCant][0], Datos[playerid][jManoData][0]);
            if(Datos[playerid][jMano][1]) SendClientMessage(solid, COLOR_DARKGREEN, "Notas tambien que tiene un %s (%d) [%d] en su mano izquierda.", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto], Datos[playerid][jManoCant][1], Datos[playerid][jManoData][1]);
        }
        case 2:{ //prestar vehiculo personal
            if(GetDistanceBetweenPlayers(playerid, solid) > 5.0) return SendClientMessage(solid, COLOR_DARKRED, "¡Estás muy lejos del jugador!");
            new veh_idex = GetPVarInt(solid, "prestar_veh_idex");
            for(new i; i < 2; i++){
                if(!Datos[playerid][jCocheLlaves][i]){
                    Datos[playerid][jCocheLlaves][i] = vehData[veh_idex][veh_SQLID];
                    SendClientMessage(playerid, COLOR_GREEN, "Aceptaste las llaves de %s.", GetRPName(solid));
                    SendClientMessage(solid, COLOR_GREEN, "%s aceptó las llaves de tu %s.", GetRPName(playerid), modelGetName(vehData[veh_idex][veh_Modelo]));
                    DeletePVar(solid, "prestar_veh_idex");
                    return 1;
                }
            }
            DeletePVar(solid, "prestar_veh_idex");
            return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: Ya tienes tus slots de vehiculos prestados ocupados.");
        }
    }
    solicitud_tipo[playerid] = 0;
    return 1;
}
CMD:rechazar(playerid){
    if(!solicitud_tipo[playerid]) return 1;
    KillTimer(solicitud_timer[playerid]);
    new solid = solicitante[playerid];
    solicitante[playerid] = -1;
    if(solid == -1 || !IsPlayerConnected(solid)){
        SendClientMessage(playerid, COLOR_DARKRED, "No encontramos al jugador que hizo la solicitud.");
        solicitud_tipo[playerid] = 0;
        return 1;
    }
    SendClientMessage(solid, COLOR_DARKRED, "%s rechazó tu solicitud.", GetRPName(playerid));
    SendClientMessage(playerid, COLOR_DARKRED, "Rechazaste la solicitud de %s.", GetRPName(playerid));
    switch(solicitud_tipo[playerid]){
        case 2:{
            DeletePVar(solid, "prestar_veh_idex");
            return 1;
        }
    }
    return 1;
}