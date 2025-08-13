CMD:heridas(playerid, params[]){
    new target;
    if(sscanf(params, "u[25]", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /heridas [Nombre/ID]");
    new dialog[5000];
    new dialog_buff[256];
    new total_wounds;
    for(new i; i < MAX_WOUNDS; i++){
        if(wound_data[target][i][wnd_ammoType]){
            total_wounds++;
            formatt(dialog_buff, "Una herida de ");
            strcat(dialog, dialog_buff);
            switch(wound_data[target][i][wnd_ammoType]){
                case 1: formatt(dialog_buff, "moretón en");
                case 2: formatt(dialog_buff, "arma cortante en");
                case 3: formatt(dialog_buff, "hematoma en");
                case 4: formatt(dialog_buff, "bala 9x19mm en");
                case 5: formatt(dialog_buff, "bala .38 Special en");
                case 6: formatt(dialog_buff, "bala .45 ACP en");
                case 7: formatt(dialog_buff, "perdigones del 12 en");
                case 8: formatt(dialog_buff, "bala 7.62x51 en");
                case 9: formatt(dialog_buff, "bala 5.56x45 en");
                case 10: formatt(dialog_buff, "bala 7.62x39 en");
            }
            strcat(dialog, dialog_buff);
            switch(wound_data[target][i][wnd_bodypart]){
                case 3: formatt(dialog_buff, " el torso");
                case 4: formatt(dialog_buff, " la entrepierna");
                case 5: formatt(dialog_buff, " el brazo izquierdo");
                case 6: formatt(dialog_buff, " el brazo derecho");
                case 7: formatt(dialog_buff, " la pierna izquierda");
                case 8: formatt(dialog_buff, " la pierna derecha");
                case 9: formatt(dialog_buff, " la cabeza");
            }
            strcat(dialog, dialog_buff);
            formatt(dialog_buff, " (dmg: %f)", wound_data[target][i][wnd_dmgTaken]);
            strcat(dialog, dialog_buff);
            if(wound_data[target][i][wnd_bodypart] == 3){
                formatt(dialog_buff, " (kevlar: %s)", (wound_data[target][i][wnd_kevlarHit]) ? "Sí" : "No");
                strcat(dialog, dialog_buff);
            }
            strcat(dialog, "\n");
        }
    }
    if(!total_wounds) return SendClientMessage(playerid, COLOR_DARKRED, "¡Este personaje no esta herido!");
    formatt(dialog_buff, "Heridas de %s", Name_sin(GetRPName(target)));
    Dialog_Show(playerid, DIALOG_HERIDAS, DIALOG_STYLE_LIST, dialog_buff, dialog, "Cerrar", "");
    return 1;
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
            continue;
        }
    }
    return 1;
}