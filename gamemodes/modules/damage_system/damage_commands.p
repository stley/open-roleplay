CMD:heridas(playerid, params[]){
    new target;
    if(sscanf(params, "r", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /heridas [Nombre/ID]");
    return dialog_heridas(playerid, target);
}

CMD:reaparecer(playerid){
    if(!muerto[playerid]) return SendClientMessage(playerid, COLOR_DARKRED, "¡No estás en estado de muerto!");
    if(!CanRespawn[playerid]) return SendClientMessage(playerid, COLOR_DARKRED, "Aún no puedes reaparecer, tienes que esperar %d segundos más.", floatround(GetTimerRemaining(RespawnTimer[playerid]) / 1000));
    switch(random(3)){
        case 1: teleportPlayer(playerid, 1178.1060, -1327.6073,14.1037, 0, 0);
        case 2: teleportPlayer(playerid, 1178.0291,-1319.9688,14.1037, 0, 0);
        default: teleportPlayer(playerid, 1178.1060,-1323.7689,14.1037, 0, 0);
    }
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Apareces en un hospital cercano.");
    SetPlayerFacingAngle(playerid, 271.5);
    ClearAnimations(playerid, SYNC_ALL);
    TogglePlayerControllable(playerid, true);
    clear_wounds(playerid);
    muerto[playerid] = 0;
    Datos[playerid][jChaleco] = 0.0;
    Datos[playerid][jVida] = 100.0;
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    for(new i; i < 5; i++){
        if(ObjetoInfo[Datos[playerid][jBolsillo][i]][Tipo] == 4 || ObjetoInfo[Datos[playerid][jBolsillo][i]][Tipo] == 10 || ObjetoInfo[Datos[playerid][jBolsillo][i]][Tipo] == 9){
            SendClientMessage(playerid, COLOR_DARKRED, "La seguridad del hospital confiscó tu(s) %s.", ObjetoInfo[Datos[playerid][jBolsillo][i]][NombreObjeto]);
            Datos[playerid][jBolsillo][i] = 0;
            Datos[playerid][jBolsilloCant][i] = 0;
            Datos[playerid][jBolsilloData][i] = 0;
            saveCharacterInventory(playerid);
            continue;
        }
    }
    for(new x; x < 2; x++){
        if(ObjetoInfo[Datos[playerid][jMano][x]][Tipo] == 4 || ObjetoInfo[Datos[playerid][jMano][x]][Tipo] == 10 || ObjetoInfo[Datos[playerid][jMano][x]][Tipo] == 9){
            SendClientMessage(playerid, COLOR_DARKRED, "La seguridad del hospital confiscó tu(s) %s.", ObjetoInfo[Datos[playerid][jMano][x]][NombreObjeto]);
            Datos[playerid][jMano][x] = 0;
            Datos[playerid][jManoCant][x] = 0;
            Datos[playerid][jManoData][x] = 0;
            update_manos(playerid);
            saveCharacterInventory(playerid);
            continue;
        }
    }
    return 1;
}