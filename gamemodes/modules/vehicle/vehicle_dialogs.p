
DialogPages:vehPanelDialog(playerid, response, listitem, inputtext[]){
    if(!response) return 1;
    new cantidad = GetPVarInt(playerid, "vehicle_listsize");
    if(cantidad) DeletePVar(playerid, "vehicle_listsize");
    if(listitem < 0 || listitem >= cantidad) return 1;
    new key[18];
    formatt(key, "veh_list_%d", listitem);
    new v = GetPVarInt(playerid, key);
    for (new p = 0; p < cantidad; p++) {
        new k[18];
        format(k, sizeof k, "veh_list_%d", p);
        if (GetPVarType(playerid, k)) DeletePVar(playerid, k);
    }
    new title[64],
    opts[120];
    formatt(title, "%s [%d] - %s", modelGetName(vehData[v][veh_Modelo]), vehData[v][veh_SQLID], vehData[v][veh_Matricula]);
    if(vehData[v][veh_vID] == INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Sacar vehículo");
    else if(!IsValidTimer(savehTimer[v])) formatt(opts, "{FF0000}Guardar vehículo\n{FFFFFF}Ubicación");
    else if(IsValidTimer(savehTimer[v]) && vehData[v][veh_vID] != INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Cancelar guardado\n{FFFFFF}Ubicación");
    Dialog_Show(playerid, CharVeh_Op, DIALOG_STYLE_LIST, title, opts, "Seleccionar", "Salir");
    SetPVarInt(playerid, "op_veh", v);
    return 1;
}



DialogPages:vehicle_trunk(playerid, response, listitem, inputtext[]){
    new idex = GetPVarInt(playerid, "veh_mal");
    DeletePVar(playerid, "veh_mal");
    if(!idex) return 0;
    idex--;
    if(!response){
        vehData[idex][veh_Trunk] = false;
        SendClientMessage(playerid, COLOR_DARKGREEN, "Cerraste el maletero del vehículo.");
        vehiclesTrunk(idex);
        return 1;
    }
    new espacio = vehData[idex][veh_EspacioMal];
    new slot;
    new bool:success;
    if(listitem > espacio-1){
        if(listitem != espacio){
            if(listitem == espacio+1){
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
                                    save_vehicle(idex);
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
                            save_vehicle(idex);
                            success = true;
                            return 1;
                        }
                    }
                }
                else return SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en tu mano derecha.");
                if(!success) return SendClientMessage(playerid, COLOR_DARKRED, "No hay más espacio en este maletero.");
            }
            else if(listitem == espacio+2){
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
                                    save_vehicle(idex);
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
                            save_vehicle(idex);
                            success = true;
                            return 1;
                        }
                    }
                }
                else return SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en tu mano izquierda.");
                if(!success) return SendClientMessage(playerid, COLOR_DARKRED, "No hay más espacio en este maletero.");
            }
        }
    }
    else{
        slot = vehicleFetchInventorySlot(idex, listitem);
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
    
    return 1;
}


Dialog:CharVeh_Op(playerid, response, listitem, inputtext[]){
    if(!response) return dialog_vehiculos(playerid);
    new idex = GetPVarInt(playerid, "op_veh");
    DeletePVar(playerid, "op_veh");
    switch(listitem){
        case 0:{
            if(vehData[idex][veh_vID] != INVALID_VEHICLE_ID && !IsValidTimer(savehTimer[idex])){
                SendClientMessage(playerid, COLOR_GREEN, "Tu vehículo se guardará dentro de ocho minutos.");
                save_vehicle(idex);
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