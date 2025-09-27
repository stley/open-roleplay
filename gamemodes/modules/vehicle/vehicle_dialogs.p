


dialog_vehiculos(playerid){
    
    new cantidad;
    for(new i; i < MAX_VEHICULOS; i++){
        new buffer[128];
        if (vehData[i][veh_SQLID]){
            if(vehData[i][veh_OwnerID] == Datos[playerid][jSQLIDP]){
                formatt(buffer, "%s\t%s\t%d", vehData[i][veh_Matricula], modelGetName(vehData[i][veh_Modelo]), vehData[i][veh_SQLID]);
                AddPaginatedDialogRow(playerid, buffer, i);
                cantidad++;
                continue;
            }
            for(new x; x < 2; x++){
                if(vehData[i][veh_SQLID] == Datos[playerid][jCocheLlaves][x]){
                    formatt(buffer, "%s\t%s (prestado)\t%d", vehData[i][veh_Matricula], modelGetName(vehData[i][veh_Modelo]), vehData[i][veh_SQLID]);
                    AddPaginatedDialogRow(playerid, buffer, i);
                    cantidad++;
                    continue;
                }
            }
        }
        continue;
    }
    if(!cantidad) return SendClientMessage(playerid, COLOR_DARKRED, "¡No tienes ningun vehículo!");
    yield 1;
    new response[DIALOG_RESPONSE];
    await_arr(response) ShowAsyncPaginatedDialog(playerid, DIALOG_STYLE_TABLIST_HEADERS, 10, "Tus vehículos", "Seleccionar", "Cancelar", "Matrícula\tModelo\tID");
    if(!response[DIALOG_RESPONSE_RESPONSE]) return false;
    if(!cantidad) return false;
    if(response[DIALOG_RESPONSE_LISTITEM] < 0 || response[DIALOG_RESPONSE_LISTITEM] >= cantidad) return 1;
    new v = response[DIALOG_RESPONSE_EXTRAID];
    new
        title[64],
        opts[120]
    ;
    formatt(title, "%s [%d] - %s", modelGetName(vehData[v][veh_Modelo]), vehData[v][veh_SQLID], vehData[v][veh_Matricula]);
    if(vehData[v][veh_vID] == INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Sacar vehículo");
    else if(!IsValidTimer(savehTimer[v])) formatt(opts, "{FF0000}Guardar vehículo\n{FFFFFF}Ubicación");
    else if(IsValidTimer(savehTimer[v]) && vehData[v][veh_vID] != INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Cancelar guardado\n{FFFFFF}Ubicación");
    
    await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_LIST, title, opts, "Seleccionar", "Salir");
    if(!response[DIALOG_RESPONSE_RESPONSE]) return dialog_vehiculos(playerid);
    new idex = v;
    switch(response[DIALOG_RESPONSE_LISTITEM]){
        case 0:{
            if(vehData[idex][veh_vID] != INVALID_VEHICLE_ID && !IsValidTimer(savehTimer[idex])){
                SendClientMessage(playerid, COLOR_GREEN, "Tu vehículo se guardará dentro de ocho minutos.");
                vehicleSave(idex);
                savehTimer[idex] = SetTimerEx("CharVeh_Unspawn", 480000, false, "d", idex);
            }
            else if(IsValidTimer(savehTimer[idex])){
                KillTimer(savehTimer[idex]);
                SendClientMessage(playerid, COLOR_GREEN, "Cancelaste el guardado de tu vehiculo.");
            }
            else{
                
                savehTimer[idex] = SetTimerEx("CharVeh_Spawn", 500, false, "d", idex);
                SendClientMessage(playerid, COLOR_GREEN, "Tu vehículo ha sido spawneado en el último lugar donde lo guardaste/estacionaste.");
            }
        }
        case 1:{
            if(vehData[idex][veh_Deposito]){
                SendClientMessage(playerid, COLOR_YELLOW, "Tu vehículo se encuentra confiscado. No puedes localizarlo.");
                return 1;
            }
            else if(vehData[idex][veh_vID] == INVALID_VEHICLE_ID){
                SendClientMessage(playerid, COLOR_DARKRED, "Ocurrió un error localizando tu vehículo. Notifica a un administrador. (INVALID_VEHICLE_ID)");
                return 1;
            }
            if(GetVehicleVirtualWorld(vehData[idex][veh_vID]) != 0) SendClientMessage(playerid, COLOR_GREEN, "((Localizamos tu vehículo en otra dimensión. Contacta a un staff si no es posible que puedas recuperar tu vehículo.))");
            new zonename[MAX_MAP_ZONE_NAME];
            if(GetVehicleMapZone(vehData[idex][veh_vID]) == INVALID_MAP_ZONE_ID) formatt(zonename, "San Andreas");
            else GetMapZoneName(GetVehicleMapZone3D(vehData[idex][veh_vID]), zonename);
            SendClientMessage(playerid, COLOR_GREEN, "Localizamos tu vehículo cerca de %s.", zonename);
            SetPlayerCheckpoint(playerid, vehData[idex][veh_PosX], vehData[idex][veh_PosY], vehData[idex][veh_PosZ], 10.0);
            checkpoints[playerid] = 1;
        }
    }
    return 1;
}

dialog_maletero(playerid){
    yield 1;
    new idex = GetPVarInt(playerid, "veh_mal");
    if(!idex) return 0;
    DeletePVar(playerid, "veh_mal");
    idex--;
    
    new response[DIALOG_RESPONSE];
    new has_keys = hasVehicleKeys(playerid, idex);
    if(vehData[idex][veh_Trunk] != false || has_keys){
        if(!vehData[idex][veh_Trunk]){
            SendClientMessage(playerid, COLOR_DARKGREEN, "Abriste el maletero del vehículo.");
            vehData[idex][veh_Trunk] = true;
            vehiclesTrunk(idex);
        }
        else if(!vehData[idex][veh_Trunk] && !has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes las llaves para este vehículo.");
        new dlg_buff[136];
        for(new x; x < vehData[idex][veh_EspacioMal]; x++){
            new slot;
            slot = vehicleFetchInventorySlot(idex, x);
            if(slot != -1){
                if(vehicleInventory[slot][veh_Maletero]) formatt(dlg_buff, "[%d]\t%s\t(%d)\t[%d]", x, ObjetoInfo[vehicleInventory[slot][veh_Maletero]][NombreObjeto], vehicleInventory[slot][veh_MaleteroCant], vehicleInventory[slot][veh_MaleteroData]);
                else formatt(dlg_buff, "[%d]\tVacío\t\t", x);
                AddPaginatedDialogRow(playerid, dlg_buff);
                continue;
            }
            else formatt(dlg_buff, "[%d]\tVacío\t\t", x);
            AddPaginatedDialogRow(playerid, dlg_buff);
            continue;
        }
        
        //AddPaginatedDialogRow(playerid, "—————————————————");
        if(Datos[playerid][jMano][0]){
            formatt(dlg_buff, "Mano derecha:\t%s\t(%d)\t[%d]", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto], Datos[playerid][jManoCant][0], Datos[playerid][jManoData][0]);
        }
        else formatt(dlg_buff, "Mano derecha:\tNada\t\t");
        AddPaginatedDialogRow(playerid, dlg_buff);
        if(Datos[playerid][jMano][1]){
            formatt(dlg_buff, "Mano izquierda:\t%s\t(%d)\t[%d]", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto], Datos[playerid][jManoCant][1], Datos[playerid][jManoData][1]);
        }
        else formatt(dlg_buff, "Mano izquierda:\tNada\t\t");
        AddPaginatedDialogRow(playerid, dlg_buff);       
        await_arr(response) ShowAsyncPaginatedDialog(playerid, DIALOG_STYLE_TABLIST_HEADERS, 18, "Maletero", "Seleccionar", "Cerrar", "Slot\tObjeto\tCantidad\tData");
    }
    //dialog response
    if(!response[DIALOG_RESPONSE_RESPONSE]) return true;
    new
        Float:veh_X,
        Float:veh_Y,
        Float:veh_Z,
        vehVW,
        vehInt,
        espacio = vehData[idex][veh_EspacioMal],
        slot,
        bool:success
    ;
    if(vehData[idex][veh_vID]){
        GetVehiclePartPos(vehData[idex][veh_vID], VEH_PART_TRUNK, veh_X, veh_Y, veh_Z);
        vehInt = GetVehicleInterior(vehData[idex][veh_vID]);
        vehVW = GetVehicleVirtualWorld(vehData[idex][veh_vID]);
    }
    else return false;
    if(vehInt != GetPlayerInterior(playerid) || vehVW != GetPlayerVirtualWorld(playerid)) return false;
    if(!IsPlayerNearVehiclePart(playerid, vehData[idex][veh_vID], VEH_PART_TRUNK, 2.0) || GetPlayerVirtualWorld(playerid) != vehVW || GetPlayerInterior(playerid) != vehInt) return SendClientMessage(playerid, COLOR_DARKRED, "El vehículo se alejó demasiado.");
    if(response[DIALOG_RESPONSE_LISTITEM] >= espacio){
        if(response[DIALOG_RESPONSE_LISTITEM] == espacio){
            if(Datos[playerid][jMano][0]){
                for(new i; i < vehData[idex][veh_EspacioMal]; i++){
                    slot = vehicleFetchInventorySlot(idex, i);
                    if(slot == -1){
                        for(new arr; arr < MAX_VEHICLE_INVENTORY_CACHE; arr++){
                            if(!vehicleInventory[arr][vehSQLID]){
                                SendClientMessage(playerid, COLOR_DARKGREEN, "Metes un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]]);
                                new action[64];
                                formatt(action, "mete un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
                                accion_player(playerid, 1, action);
                                vehicleInventory[arr][vehSQLID] = vehData[idex][veh_SQLID];
                                vehicleInventory[arr][veh_Slot] = i;
                                vehicleInventory[arr][veh_Maletero] = Datos[playerid][jMano][0];
                                Datos[playerid][jMano][0] = 0;
                                vehicleInventory[arr][veh_MaleteroCant] = Datos[playerid][jManoCant][0];
                                Datos[playerid][jManoCant][0] = 0;
                                vehicleInventory[arr][veh_MaleteroData] = Datos[playerid][jManoData][0];
                                Datos[playerid][jManoData][0] = 0;
                                alm(vehicleInventory[arr][veh_Huellas], GetName(playerid));
                                update_manos(playerid);
                                saveCharacterInventory(playerid);
                                vehicleSave(idex);
                                success = true;
                                return 1;
                            }
                        }
                    }
                    else if(slot != -1 && !vehicleInventory[slot][veh_Maletero]){
                        SendClientMessage(playerid, COLOR_DARKGREEN, "Metes un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]]);
                        new action[64];
                        formatt(action, "mete un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
                        accion_player(playerid, 1, action);
                        vehicleInventory[slot][veh_Maletero] = Datos[playerid][jMano][0];
                        Datos[playerid][jMano][0] = 0;
                        vehicleInventory[slot][veh_MaleteroCant] = Datos[playerid][jManoCant][0];
                        Datos[playerid][jManoCant][0] = 0;
                        vehicleInventory[slot][veh_MaleteroData] = Datos[playerid][jManoData][0];
                        Datos[playerid][jManoData][0] = 0;
                        update_manos(playerid);
                        saveCharacterInventory(playerid);
                        vehicleSave(idex);
                        success = true;
                        return 1;
                    }
                }
            }
            else return SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en tu mano derecha.");
        }
        else if(response[DIALOG_RESPONSE_LISTITEM] == espacio+1){
            if(Datos[playerid][jMano][1]){
                for(new i; i < vehData[idex][veh_EspacioMal]; i++){
                    slot = vehicleFetchInventorySlot(idex, i);
                    if(slot == -1){
                        for(new arr; arr < MAX_VEHICLE_INVENTORY_CACHE; arr++){
                            if(!vehicleInventory[arr][vehSQLID]){
                                SendClientMessage(playerid, COLOR_DARKGREEN, "Metes un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]]);
                                new action[64];
                                formatt(action, "mete un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
                                accion_player(playerid, 1, action);
                                vehicleInventory[arr][vehSQLID] = vehData[idex][veh_SQLID];
                                vehicleInventory[arr][veh_Slot] = i;
                                vehicleInventory[arr][veh_Maletero] = Datos[playerid][jMano][1];
                                Datos[playerid][jMano][1] = 0;
                                vehicleInventory[arr][veh_MaleteroCant] = Datos[playerid][jManoCant][1];
                                Datos[playerid][jManoCant][1] = 0;
                                vehicleInventory[arr][veh_MaleteroData] = Datos[playerid][jManoData][1];
                                Datos[playerid][jManoData][1] = 0;
                                alm(vehicleInventory[arr][veh_Huellas], GetName(playerid));
                                update_manos(playerid);
                                saveCharacterInventory(playerid);
                                vehicleSave(idex);
                                success = true;
                                return 1;
                            }
                        }
                    }
                    else if(slot != -1 && !vehicleInventory[slot][veh_Maletero]){
                        SendClientMessage(playerid, COLOR_DARKGREEN, "Metes un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][1]]);
                        new action[64];
                        formatt(action, "mete un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto]);
                        accion_player(playerid, 1, action);
                        vehicleInventory[slot][veh_Maletero] = Datos[playerid][jMano][1];
                        Datos[playerid][jMano][1] = 0;
                        vehicleInventory[slot][veh_MaleteroCant] = Datos[playerid][jManoCant][1];
                        Datos[playerid][jManoCant][1] = 0;
                        vehicleInventory[slot][veh_MaleteroData] = Datos[playerid][jManoData][1];
                        Datos[playerid][jManoData][1] = 0;
                        update_manos(playerid);
                        saveCharacterInventory(playerid);
                        vehicleSave(idex);
                        success = true;
                        return 1;
                    }
                }
            }
            else return SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en tu mano izquierda.");   
        }
        if(!success) return SendClientMessage(playerid, COLOR_DARKRED, "No hay más espacio en este maletero.");
    }
    else{
        slot = vehicleFetchInventorySlot(idex, response[DIALOG_RESPONSE_LISTITEM]);
        if(slot == -1 || !vehicleInventory[slot][veh_Maletero]) return SendClientMessage(playerid, COLOR_DARKRED, "Ese hueco está vacío.");
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas. Tira algun objeto o guardalo en tu bolsillo.");
            Datos[playerid][jMano][1] = vehicleInventory[slot][veh_Maletero];
            vehicleInventory[slot][veh_Maletero] = 0;
            Datos[playerid][jManoCant][1] = vehicleInventory[slot][veh_MaleteroCant];
            vehicleInventory[slot][veh_MaleteroCant] = 0;
            Datos[playerid][jManoData][1] = vehicleInventory[slot][veh_MaleteroData];
            vehicleInventory[slot][veh_MaleteroData] = 0;
            
            new query[128];
            mysql_format(SQLDB, query, sizeof(query), "DELETE FROM `vehicle_inventory` WHERE `vehicle_id` = %d AND `inventory_slot_id` = %d", vehData[idex][veh_SQLID], vehicleInventory[slot][veh_Slot]);
            mysql_tquery(SQLDB, query);
            update_manos(playerid);
            formatt(query, "saca un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto]);
            accion_player(playerid, 1, query);
            saveCharacterInventory(playerid);
            return SendClientMessage(playerid, COLOR_DARKGREEN, "Sacas un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto]);
        }
        Datos[playerid][jMano][0] = vehicleInventory[slot][veh_Maletero];
        vehicleInventory[slot][veh_Maletero] = 0;
        Datos[playerid][jManoCant][0] = vehicleInventory[slot][veh_MaleteroCant];
        vehicleInventory[slot][veh_MaleteroCant] = 0;
        Datos[playerid][jManoData][0] = vehicleInventory[slot][veh_MaleteroData];
        vehicleInventory[slot][veh_MaleteroData] = 0;
        update_manos(playerid);
        new query[128];
        mysql_format(SQLDB, query, sizeof(query), "DELETE FROM `vehicle_inventory` WHERE `vehicle_id` = %d AND `inventory_slot_id` = %d", vehData[idex][veh_SQLID], vehicleInventory[slot][veh_Slot]);
        mysql_tquery(SQLDB, query);
        formatt(query, "saca un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
        accion_player(playerid, 1, query);
        saveCharacterInventory(playerid);
        return SendClientMessage(playerid, COLOR_DARKGREEN, "Sacas un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
    }
    return false;
}