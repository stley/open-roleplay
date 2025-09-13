CMD:miscoches(playerid){
    if(!IsPlayerConnected(playerid)) return 1;
    if(Datos[playerid][EnChar]) return dialog_vehiculos(playerid);
}

dialog_vehiculos(playerid){
    new cantidad;
    
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_OwnerID] == Datos[playerid][jSQLIDP]){
            new buffer[128];
            formatt(buffer, "[%d] %s", vehData[i][veh_SQLID], modelGetName(vehData[i][veh_Modelo]));
            new key[18];
            format(key, sizeof key, "veh_list_%d", cantidad);
            SetPVarInt(playerid, key, i); // mapear posición -> índice en vehData
            AddDialogListitem(playerid, buffer);
            cantidad++;
            continue;
        }
    }
    if(!cantidad) return SendClientMessage(playerid, COLOR_DARKRED, "¡No tienes ningun vehículo!");
    SetPVarInt(playerid, "vehicle_listsize", cantidad);
    ShowPlayerDialogPages(playerid, "vehPanelDialog", DIALOG_STYLE_LIST, "Tus vehículos", "Seleccionar", "Cancelar", 12);
    return 1;
}

DialogPages:vehPanelDialog(playerid, response, listitem, inputtext[]){
    new cantidad = GetPVarInt(playerid, "vehicle_listsize");
    if(cantidad) DeletePVar(playerid, "vehicle_listsize");
    if(listitem < 0 || listitem >= cantidad) return 1;
    new key[18];
    formatt(key, "veh_list_%d", listitem);
    new v = GetPVarInt(playerid, key);
    for (new p = 0; p < 256; p++) {
        new k[18];
        format(k, sizeof k, "veh_list_%d", p);
        if (GetPVarType(playerid, k)) DeletePVar(playerid, k);
    }
    new title[64],
    opts[120];
    formatt(title, "%s [%d] - LS%s", modelGetName(vehData[v][veh_Modelo]), vehData[v][veh_SQLID], vehData[v][veh_Matricula]);
    if(vehData[v][veh_vID] == INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Sacar vehículo");
    else if(!IsValidTimer(savehTimer[v])) formatt(opts, "{FF0000}Guardar vehículo\n{FFFFFF}Ubicación");
    else if(IsValidTimer(savehTimer[v]) && vehData[v][veh_vID] != INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Cancelar guardado\n{FFFFFF}Ubicación");
    Dialog_Show(playerid, CharVeh_Op, DIALOG_STYLE_LIST, title, opts, "Seleccionar", "");
    SetPVarInt(playerid, "op_veh", v);
    return 1;
}

CMD:motor(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en un vehículo.");
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] != INVALID_VEHICLE_ID && IsPlayerInVehicle(playerid, vehData[i][veh_vID])){
            if(GetPlayerVehicleSeat(playerid) != 0) return SendClientMessage(playerid, COLOR_DARKRED, "No eres el conductor del vehículo.");
            new has_keys = 0;
            if(vehData[i][veh_Tipo] == 1){
                if(Datos[playerid][jCoche][0] == vehData[i][veh_SQLID]) has_keys = 1;
                else if(Datos[playerid][jCoche][1] == vehData[i][veh_SQLID] && has_keys != 1) has_keys = 1;
                else if(Datos[playerid][jCocheLlaves][0] == vehData[i][veh_SQLID] && has_keys != 1) has_keys = 1;
                else if(Datos[playerid][jCocheLlaves][1] == vehData[i][veh_SQLID] && has_keys != 1) has_keys = 1;  
            }
            if(!has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes llaves para este vehículo.");
            if(vehData[i][veh_Gasolina] < 1) return SendClientMessage(playerid, COLOR_DARKRED, "Intentas encender el vehículo, pero te percatas de que no tiene gasolina.");
            if(vehData[i][veh_Vida] < 260.1) return SendClientMessage(playerid, COLOR_DARKRED, "Intentas encender el vehículo, pero este está muy dañado como para funcionar.");
            new action[96];
            new model = GetVehicleModel(vehData[i][veh_vID]);
            if(!vehData[i][veh_Engine]){
                formatt(action, "enciende el motor de su %s", modelGetName(model));
                vehData[i][veh_Engine] = true;
                SetTimerEx("vehiclesEngine", 1500, false, "d", i);
            }
            else{
                formatt(action, "apaga el motor de su %s", modelGetName(model));
                vehData[i][veh_Engine] = false;
                vehiclesEngine(i);
            }
            accion_player(playerid, 0, action);
            return 1;
        }
    }
    if(GetPlayerVehicleSeat(playerid) != 0) return SendClientMessage(playerid, COLOR_DARKRED, "No eres el conductor del vehículo.");
    Veh_Engine(GetPlayerVehicleID(playerid));
    return 1;
}

CMD:cinturon(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en ningun vehículo.");
    new playerveh = GetPlayerVehicleID(playerid);
    if(Vehicle_IsBoat(playerveh) || Vehicle_IsBike(playerveh) || Vehicle_IsFlowerpot(playerveh)) return SendClientMessage(playerid, COLOR_DARKRED, "Este vehículo no tiene cinturón de seguridad.");
    
    if(!CinturonV[playerid]){
        accion_player(playerid, 1, "se coloca el cinturón de seguridad.");
        CinturonV[playerid] = 1;
    }
    else{
        CinturonV[playerid] = 0;
        accion_player(playerid, 1, "se quita el cinturón de seguridad.");
    }
    return 1;
}

CMD:luces(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en ningun vehículo.");
    new playerveh = GetPlayerVehicleID(playerid);
    vehiclesLights(playerveh);
    return 1;
}

CMD:lock(playerid){
    new 
        Float:veh_pos[3],
        idex = -1,
        Float:currdist = 30.0,
        has_keys
    ;
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] != INVALID_VEHICLE_ID){
            if(IsPlayerInVehicle(playerid, vehData[i][veh_vID])){
                if(vehData[i][veh_Tipo] == 1){
                    
                    if(Datos[playerid][jCoche][0] == vehData[i][veh_SQLID]) idex = i;
                    else if(Datos[playerid][jCoche][1] == vehData[i][veh_SQLID] && idex == -1) idex = i;
                    else if(Datos[playerid][jCocheLlaves][0] == vehData[i][veh_SQLID] && idex == -1) idex = i;
                    else if(Datos[playerid][jCocheLlaves][1] == vehData[i][veh_SQLID] && idex == -1) idex = i;
                    if(idex != -1) has_keys = 1;
                    else return SendClientMessage(playerid, COLOR_DARKRED, "No tienes las llaves de este vehículo.");
                    break;
                }
            }
            if(GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehData[i][veh_vID])){
                if(GetPlayerInterior(playerid) == GetVehicleInterior(vehData[i][veh_vID])){
                    GetVehiclePos(vehData[i][veh_vID], veh_pos[0], veh_pos[1], veh_pos[2]);
                    if(GetPlayerDistanceFromPoint(playerid, veh_pos[0], veh_pos[1], veh_pos[2]) < currdist){
                        idex = i;
                        currdist = GetPlayerDistanceFromPoint(playerid, veh_pos[0], veh_pos[1], veh_pos[2]);
                        continue;
                    }
                }
            }
        }
    }
    if(idex == -1) return SendClientMessage(playerid, COLOR_DARKRED, "No hay ningun vehiculo para bloquear/desbloquear.");
    else{
        if(vehData[idex][veh_Tipo] == 1){
            if(currdist > 5.0 && !has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes un vehiculo lo suficientemente cerca.");
            if(!has_keys){
                if(Datos[playerid][jCoche][0] == vehData[idex][veh_SQLID]) has_keys = 1;
                else if(Datos[playerid][jCoche][1] == vehData[idex][veh_SQLID] && has_keys != 1) has_keys = 1;
                else if(Datos[playerid][jCocheLlaves][0] == vehData[idex][veh_SQLID] && has_keys != 1) has_keys = 1;
                else if(Datos[playerid][jCocheLlaves][1] == vehData[idex][veh_SQLID] && has_keys != 1) has_keys = 1;
                if(!has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes las llaves de este vehículo.");
            }
            if(vehData[idex][veh_Bloqueo]){
                GameTextForPlayer(playerid, "~g~Desbloqueado", 1200, 7);
                vehData[idex][veh_Bloqueo] = 0;
            }
            else{
                GameTextForPlayer(playerid, "~r~Bloqueado", 1500, 7);
                vehData[idex][veh_Bloqueo] = 1;
            }
            vehiclesLock(idex);
            return 1;
        }
    }
    return 1;
}

CMD:guantera(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en ningun vehiculo.");
    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 1;
    if(Model_IsBike(veh)) return SendClientMessage(playerid, COLOR_DARKRED, "Este vehículo no tiene una guantera.");
    if(GetPlayerVehicleSeat(playerid) > 1) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes acceder a la guantera desde allí.");
    new idex = FindVehIndxFromVehID(veh);
    new mano = -1;
    if(vehData[idex][veh_Guantera]){ //Si la guantera tiene algun objeto
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas. Guarda o tira alguno de los objetos.");
            mano = 1;
        }
        else mano = 0;
        if(mano == -1) return 1;
        Datos[playerid][jMano][mano] = vehData[idex][veh_Guantera];
        Datos[playerid][jManoCant][mano] = vehData[idex][veh_GuanteraCant];
        Datos[playerid][jManoData][mano] = vehData[idex][veh_GuanteraData];
        vehData[idex][veh_Guantera] = 0;
        vehData[idex][veh_GuanteraCant] = 0;
        vehData[idex][veh_GuanteraData] = 0;
        new action[64];
        formatt(action, "saca un %s de la guantera.", ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto]);
        accion_player(playerid, 1, action);
        SendClientMessage(playerid, COLOR_GREEN, "Sacas un %s de la guantera de tu vehículo.", ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto]);
        update_manos(playerid);
    }
    else{ //Si la guantera esta vacía
        if(!Datos[playerid][jMano][0]){
            if(!Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos vacías.");
            else mano = 1;
        }
        else mano = 0;
        if(mano == -1) return 1;
        if(!ObjetoInfo[Datos[playerid][jMano][mano]][Guardable]) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes guardar esto en la guantera!");
        vehData[idex][veh_Guantera] = Datos[playerid][jMano][mano];
        vehData[idex][veh_GuanteraCant] = Datos[playerid][jManoCant][mano];
        vehData[idex][veh_GuanteraData] = Datos[playerid][jManoData][mano];
        Datos[playerid][jMano][mano] = 0;
        Datos[playerid][jManoCant][mano] = 0;
        Datos[playerid][jManoData][mano] = 0;
        new action[64];
        formatt(action, "guarda un %s en la guantera.", ObjetoInfo[vehData[idex][veh_Guantera]][NombreObjeto]);
        accion_player(playerid, 1, action);
        SendClientMessage(playerid, COLOR_GREEN, "Guardas un %s en la guantera de tu vehículo.", ObjetoInfo[vehData[idex][veh_Guantera]][NombreObjeto]);
        update_manos(playerid);
    }
    return 1;
}
CMD:verguantera(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en ningun vehiculo.");
    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 1;
    if(Model_IsBike(veh)) return SendClientMessage(playerid, COLOR_DARKRED, "Este vehículo no tiene una guantera.");
    if(GetPlayerVehicleSeat(playerid) > 1) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes acceder a la guantera desde allí.");
    new idex = FindVehIndxFromVehID(veh);
    if(vehData[idex][veh_Guantera]) return SendClientMessage(playerid, COLOR_SEAGREEN, "Encuentras en la guantera: %s (%d) [%d]", ObjetoInfo[vehData[idex][veh_Guantera]][NombreObjeto], vehData[idex][veh_GuanteraCant], vehData[idex][veh_GuanteraData]);
    else return SendClientMessage(playerid, COLOR_DARKRED, "La guantera se encuentra vacía.");
}

CMD:grack(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en ningun vehiculo.");
    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 1;
    if(Model_IsBike(veh) || !Model_IsPolice(veh)) return SendClientMessage(playerid, COLOR_DARKRED, "Este vehículo no tiene una gunrack.");
    if(GetPlayerVehicleSeat(playerid) > 1) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes acceder al gunrack desde allí.");
    new idex = FindVehIndxFromVehID(veh);
    new mano = -1;
    if(vehData[idex][veh_Gunrack]){ //Si la gunrack tiene algun objeto
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas. Guarda o tira alguno de los objetos.");
            mano = 1;
        }
        else mano = 0;
        if(mano == -1) return 1;
        Datos[playerid][jMano][mano] = vehData[idex][veh_Gunrack];
        Datos[playerid][jManoCant][mano] = vehData[idex][veh_GunrackCant];
        Datos[playerid][jManoData][mano] = vehData[idex][veh_GunrackData];
        vehData[idex][veh_Gunrack] = 0;
        vehData[idex][veh_GunrackCant] = 0;
        vehData[idex][veh_GunrackData] = 0;
        new action[64];
        formatt(action, "saca un %s del gunrack.", ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto]);
        accion_player(playerid, 1, action);
        SendClientMessage(playerid, COLOR_GREEN, "Sacas un %s del gunrack de tu vehículo.", ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto]);
        update_manos(playerid);
    }
    else{ //Si la gunrack esta vacía
        if(!Datos[playerid][jMano][0]){
            if(!Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos vacías.");
            else mano = 1;
        }
        else mano = 0;
        if(mano == -1) return 1;
        if(ObjetoInfo[Datos[playerid][jMano][mano]][Tipo] != 5) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes guardar esto en el gunrack!");
        vehData[idex][veh_Gunrack] = Datos[playerid][jMano][mano];
        vehData[idex][veh_GunrackCant] = Datos[playerid][jManoCant][mano];
        vehData[idex][veh_GunrackData] = Datos[playerid][jManoData][mano];
        Datos[playerid][jMano][mano] = 0;
        Datos[playerid][jManoCant][mano] = 0;
        Datos[playerid][jManoData][mano] = 0;
        new action[64];
        formatt(action, "guarda un %s en el gunrack.", ObjetoInfo[vehData[idex][veh_Gunrack]][NombreObjeto]);
        accion_player(playerid, 1, action);
        SendClientMessage(playerid, COLOR_GREEN, "Guardas un %s en el gunrack de tu vehículo.", ObjetoInfo[vehData[idex][veh_Gunrack]][NombreObjeto]);
        update_manos(playerid);
    }
    return 1;
}
CMD:vergrack(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en ningun vehiculo.");
    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 1;
    if(Model_IsBike(veh) || !Model_IsPolice(veh)) return SendClientMessage(playerid, COLOR_DARKRED, "Este vehículo no tiene una gunrack.");
    if(GetPlayerVehicleSeat(playerid) > 1) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes acceder al gunrack desde allí.");
    new idex = FindVehIndxFromVehID(veh);
    if(vehData[idex][veh_Gunrack]) return SendClientMessage(playerid, COLOR_SEAGREEN, "Encuentras en el gunrack: %s (%d) [%d]", ObjetoInfo[vehData[idex][veh_Gunrack]][NombreObjeto], vehData[idex][veh_GunrackCant], vehData[idex][veh_GunrackData]);
    else return SendClientMessage(playerid, COLOR_DARKRED, "La gunrack se encuentra vacía.");
}

CMD:prestarveh(playerid, params[]){
    new
        user,
        slot,
        veh_id
    ;
    if(sscanf(params, "rd", user, slot) || isnull(params)){
        SendClientMessage(playerid, COLOR_DARKRED, "USO: /prestarveh [id/Nombre] [SLOT]");
        SendClientMessage(playerid, COLOR_DARKBLUE, "Tus vehículos:");
        for(new i; i < 2; i++){
            if(Datos[playerid][jCoche][i]){
                new idex = FindVehIndxFromSQLID(Datos[playerid][jCoche][i]);
                if(idex != -1) SendClientMessage(playerid, COLOR_YELLOW, "[Personal %d] %s (%d)", i+1, modelGetName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
            }
            return 1;
        }
    }
    if(!IsPlayerConnected(user)) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El jugador no está conectado.");
    if(slot > 2 || slot < 1) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: Slot inválido.");
    if(!Datos[playerid][jCoche][slot-1]) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes ningun vehículo en ese slot.");
    veh_id = FindVehIndxFromSQLID(Datos[playerid][jCoche][slot-1]);
    if(veh_id == -1) return 1;
    for(new i; i < 2; i++){
        if(Datos[user][jCocheLlaves][i]){
            if(i == 0) continue;
            else if(i == 1) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El jugador ya tiene sus slots de vehículos ocupados.");   
        }
        SendClientMessage(playerid, COLOR_BLUE, "Le ofreciste las llaves de tu %s a %s. Espera una respuesta.", modelGetName(vehData[veh_id][veh_Modelo]), GetRPName(user));
        SendClientMessage(user, COLOR_BLUE, "%s te ofreció las llaves de su %s. Utiliza /aceptar o /rechazar.", GetRPName(playerid), modelGetName(vehData[veh_id][veh_Modelo]));
        solicitud_tipo[user] = 2;
        solicitante[user] = playerid;
        solicitud_timer[user] = SetTimerEx("TimeOutRequest", 8000, false, "d", user);
        SetPVarInt(playerid, "prestar_veh_slot", slot-1);
        return 1;
    }
    return 1;
}
CMD:mal(playerid, params[]){
    new 
        Float:veh_pos[3],
        idex = -1,
        Float:currdist = 30.0,
        has_keys
    ;
    sscanf(params, "S()[24]", params);
    SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /mal [cerrar, dejar en blanco para abrir y ver el maletero]");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes hacer eso estando dentro de un vehículo.");
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] != INVALID_VEHICLE_ID){

            if(GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehData[i][veh_vID])){
                if(GetPlayerInterior(playerid) == GetVehicleInterior(vehData[i][veh_vID])){
                    GetVehiclePos(vehData[i][veh_vID], veh_pos[0], veh_pos[1], veh_pos[2]);
                    if(GetPlayerDistanceFromPoint(playerid, veh_pos[0], veh_pos[1], veh_pos[2]) < currdist){
                        idex = i;
                        currdist = GetPlayerDistanceFromPoint(playerid, veh_pos[0], veh_pos[1], veh_pos[2]);
                        continue;
                    }
                }
            }
        }
    }
    if(idex != -1 && currdist < 6.8){
        if(strcmp(params, "cerrar", true) == 0 && !isnull(params)){
            if(!vehData[idex][veh_Trunk]) return SendClientMessage(playerid, COLOR_DARKRED, "El maletero ya está cerrado.");
            SendClientMessage(playerid, COLOR_DARKGREEN, "Cierras el maletero del vehículo.");
            vehData[idex][veh_Trunk] = false;
            vehiclesTrunk(idex);
            return 1;
        }
        if(!has_keys){
            if(Datos[playerid][jCoche][0] == vehData[idex][veh_SQLID]) has_keys = 1;
            else if(Datos[playerid][jCoche][1] == vehData[idex][veh_SQLID] && has_keys == -1) has_keys = 1;
            else if(Datos[playerid][jCocheLlaves][0] == vehData[idex][veh_SQLID] && has_keys == -1) has_keys = 1;
            else if(Datos[playerid][jCocheLlaves][1] == vehData[idex][veh_SQLID] && has_keys == -1) has_keys = 1;
            if(!has_keys && vehData[idex][veh_Trunk] != true) return SendClientMessage(playerid, COLOR_DARKRED, "No encontramos un vehículo que puedas abrir.");
            new dlg[3000];
            new dlg_buff[136];
            for(new x; x < vehData[idex][veh_EspacioMal]; x++){
                if(vehData[idex][veh_Maletero][x]) formatt(dlg_buff, "[%d] %s (%d) [%d]\n", x, ObjetoInfo[vehData[idex][veh_Maletero][x]][NombreObjeto], vehData[idex][veh_MaleteroCant][x], vehData[idex][veh_MaleteroData][x]);
                else formatt(dlg_buff, "[%d] Vacío\n", x);
                strcat(dlg, dlg_buff);
                continue;   
            }
            
            strcat(dlg, "————————\n");
            if(Datos[playerid][jMano][0]){
                formatt(dlg_buff, "Mano derecha: %s (%d) [%d]\n", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto], Datos[playerid][jManoCant][0], Datos[playerid][jManoData][0]);
            }
            else formatt(dlg_buff, "Mano derecha: Nada\n");
            strcat(dlg, dlg_buff);
            if(Datos[playerid][jMano][1]){
                formatt(dlg_buff, "Mano izquierda: %s (%d) [%d]", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto], Datos[playerid][jManoCant][1], Datos[playerid][jManoData][1]);
            }
            else formatt(dlg_buff, "Mano izquierda: Nada");
            strcat(dlg, dlg_buff);
            if(!vehData[idex][veh_Trunk]){
                vehData[idex][veh_Trunk] = true;
                vehiclesTrunk(idex);
            }       
            Dialog_Show(playerid, vehicle_trunk, DIALOG_STYLE_LIST, "Maletero del vehículo", dlg, "Seleccionar", "Cerrar");
        }
        else{
            new dlg[3000];
            new dlg_buff[136];
            for(new x; x < vehData[idex][veh_EspacioMal]; x++){
                if(vehData[idex][veh_Maletero][x]) formatt(dlg_buff, "[%d] %s (%d) [%d]\n", x, ObjetoInfo[vehData[idex][veh_Maletero][x]][NombreObjeto], vehData[idex][veh_MaleteroCant][x], vehData[idex][veh_MaleteroData][x]);
                else formatt(dlg_buff, "[%d] Vacío\n", x);
                strcat(dlg, dlg_buff);
                continue;
            }
            
            strcat(dlg, "————————\n");
            if(Datos[playerid][jMano][0]) formatt(dlg_buff, "Mano derecha: %s (%d) [%d]\n", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto], Datos[playerid][jManoCant][0], Datos[playerid][jManoData][0]);
            else formatt(dlg_buff, "Mano derecha: Nada\n");
            strcat(dlg, dlg_buff);
            if(Datos[playerid][jMano][1]) formatt(dlg_buff, "Mano izquierda: %s (%d) [%d]", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto], Datos[playerid][jManoCant][1], Datos[playerid][jManoData][1]);
            else formatt(dlg_buff, "Mano izquierda: Nada");
            strcat(dlg, dlg_buff);
            if(!vehData[idex][veh_Trunk]){
                vehData[idex][veh_Trunk] = true;
                vehiclesTrunk(idex);
            }
            Dialog_Show(playerid, vehicle_trunk, DIALOG_STYLE_LIST, "Maletero del vehículo", dlg, "Seleccionar", "Cerrar");
        }
        SetPVarInt(playerid, "veh_mal", idex+1);
    }
    return 1;
}
alias:miscoches("coches")
alias:mal("maletero")