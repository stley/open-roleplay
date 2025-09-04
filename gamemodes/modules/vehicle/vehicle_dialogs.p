Dialog:CharVehicles(playerid, response, listitem, inputtext[]){
    if(!response) return 1;
    switch(listitem){
        case 0:{
            if(!Datos[playerid][jCoche][0]){
                SendClientMessage(playerid, COLOR_DARKRED, "No tienes ningun vehiculo en ese slot.");
                return 1;
            }
            new idex = FindVehIndxFromSQLID(Datos[playerid][jCoche][0]);
            new title[32];
            formatt(title, "%s [%d]", modelGetName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
            new opts[128];
            if(vehData[idex][veh_vID] == INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Sacar vehículo");
            else if(!IsValidTimer(savehTimer[idex])) formatt(opts, "{FF0000}Guardar vehículo\n{FFFFFF}Ubicación");
            else if(IsValidTimer(savehTimer[idex]) && vehData[idex][veh_vID] != INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Cancelar guardado\n{FFFFFF}Ubicación");
            Dialog_Show(playerid, CharVeh_Op, DIALOG_STYLE_LIST, title, opts, "Seleccionar", "");
            SetPVarInt(playerid, "op_veh", idex);
            return 1;        
        }
        case 1:{
            if(!Datos[playerid][jCocheLlaves][0]){
                SendClientMessage(playerid, COLOR_DARKRED, "No tienes ningun vehiculo en ese slot.");
                return 1;
            }
            new idex = FindVehIndxFromSQLID(Datos[playerid][jCocheLlaves][0]);
            new title[32];
            formatt(title, "%s [%d]", modelGetName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
            new opts[128];
            if(vehData[idex][veh_vID] == INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Sacar vehículo");
            else if(!IsValidTimer(savehTimer[idex])) formatt(opts, "{FF0000}Guardar vehículo\n{FFFFFF}Ubicación");
            else if(IsValidTimer(savehTimer[idex]) && vehData[idex][veh_vID] != INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Cancelar guardado\n{FFFFFF}Ubicación");
            Dialog_Show(playerid, CharVeh_Op, DIALOG_STYLE_LIST, title, opts, "Seleccionar", "");
            SetPVarInt(playerid, "op_veh", idex);
            return 1;        
        }
        case 2:{
            if(!Datos[playerid][jCoche][1]){
                SendClientMessage(playerid, COLOR_DARKRED, "No tienes ningun vehiculo en ese slot.");
                return 1;
            }
            new idex = FindVehIndxFromSQLID(Datos[playerid][jCoche][1]);
            new title[32];
            formatt(title, "%s [%d]", modelGetName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
            new opts[128];
            if(vehData[idex][veh_vID] == INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Sacar vehículo");
            else if(!IsValidTimer(savehTimer[idex])) formatt(opts, "{FF0000}Guardar vehículo\n{FFFFFF}Ubicación");
            else if(IsValidTimer(savehTimer[idex]) && vehData[idex][veh_vID] != INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Cancelar guardado\n{FFFFFF}Ubicación");
            Dialog_Show(playerid, CharVeh_Op, DIALOG_STYLE_LIST, title, opts, "Seleccionar", "");
            SetPVarInt(playerid, "op_veh", idex);
            return 1;        
        }
        case 3:{
            if(!Datos[playerid][jCocheLlaves][1]){
                SendClientMessage(playerid, COLOR_DARKRED, "No tienes ningun vehiculo en ese slot.");
                return 1;
            }
            new idex = FindVehIndxFromSQLID(Datos[playerid][jCocheLlaves][1]);
            new title[32];
            formatt(title, "%s [%d]", modelGetName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
            new opts[128];
            if(vehData[idex][veh_vID] == INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Sacar vehículo");
            else if(!IsValidTimer(savehTimer[idex])) formatt(opts, "{FF0000}Guardar vehículo\n{FFFFFF}Ubicación");
            else if(IsValidTimer(savehTimer[idex]) && vehData[idex][veh_vID] != INVALID_VEHICLE_ID) formatt(opts, "{00FF00}Cancelar guardado\n{FFFFFF}Ubicación");
            Dialog_Show(playerid, CharVeh_Op, DIALOG_STYLE_LIST, title, opts, "Seleccionar", "");
            SetPVarInt(playerid, "op_veh", idex);
            return 1;  
        }
    }
    return 1;
}

Dialog:vehicle_trunk(playerid, response, listitem, inputtext[]){
    new idex = GetPVarInt(playerid, "veh_mal");
    if(!idex) return 0;
    idex--;
    DeletePVar(playerid, "veh_mal");
    if(!response){
        vehData[idex][veh_Trunk] = false;
        SendClientMessage(playerid, COLOR_DARKGREEN, "Cerraste el maletero del vehículo.");
        vehiclesTrunk(idex);
        return 1;
    }
    new espacio = vehData[idex][veh_EspacioMal];
    if(listitem > espacio-1){
        if(listitem != espacio){
            if(listitem == espacio+1){
                if(Datos[playerid][jMano][0]){
                    for(new i; i < vehData[idex][veh_EspacioMal]; i++){
                        if(!vehData[idex][veh_Maletero][i]){
                            SendClientMessage(playerid, COLOR_DARKGREEN, "Metes un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]]);
                            new action[64];
                            formatt(action, "mete un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
                            accion_player(playerid, 1, action);
                            vehData[idex][veh_Maletero][i] = Datos[playerid][jMano][0];
                            Datos[playerid][jMano][0] = 0;
                            vehData[idex][veh_MaleteroCant][i] = Datos[playerid][jManoCant][0];
                            Datos[playerid][jManoCant][0] = 0;
                            vehData[idex][veh_MaleteroData][i] = Datos[playerid][jManoData][0];
                            Datos[playerid][jManoData][0] = 0;
                            update_manos(playerid);
                            return 1;
                        }
                    }
                }
                return SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en tu mano derecha.");
            }
            else if(listitem == espacio+2){
                if(Datos[playerid][jMano][1]){
                    for(new i; i < vehData[idex][veh_EspacioMal]; i++){
                        if(!vehData[idex][veh_Maletero][i]){
                            SendClientMessage(playerid, COLOR_DARKGREEN, "Metes un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][1]]);
                            new action[64];
                            formatt(action, "mete un %s en el maletero.", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto]);
                            accion_player(playerid, 1, action);
                            vehData[idex][veh_Maletero][i] = Datos[playerid][jMano][1];
                            Datos[playerid][jMano][1] = 0;
                            vehData[idex][veh_MaleteroCant][i] = Datos[playerid][jManoCant][1];
                            Datos[playerid][jManoCant][1] = 0;
                            vehData[idex][veh_MaleteroData][i] = Datos[playerid][jManoData][1];
                            Datos[playerid][jManoData][1] = 0;
                            update_manos(playerid);
                            return 1;
                        }
                    }
                }
                return SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en tu mano izquierda.");
            }
        }
    }
    else{
        if(!vehData[idex][veh_Maletero][listitem]) return SendClientMessage(playerid, COLOR_DARKRED, "Ese hueco está vacío.");
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas. Tira algun objeto o guardalo en tu bolsillo.");
            Datos[playerid][jMano][1] = vehData[idex][veh_Maletero][listitem];
            vehData[idex][veh_Maletero][listitem] = 0;
            Datos[playerid][jManoCant][1] = vehData[idex][veh_MaleteroCant][listitem];
            vehData[idex][veh_MaleteroCant][listitem] = 0;
            Datos[playerid][jManoData][1] = vehData[idex][veh_MaleteroData][listitem];
            vehData[idex][veh_MaleteroData][listitem] = 0;
            update_manos(playerid);
            new action[64];
            formatt(action, "saca un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto]);
            accion_player(playerid, 1, action);
            return SendClientMessage(playerid, COLOR_DARKGREEN, "Sacas un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][1]][NombreObjeto]);
        }
        Datos[playerid][jMano][0] = vehData[idex][veh_Maletero][listitem];
        vehData[idex][veh_Maletero][listitem] = 0;
        Datos[playerid][jManoCant][0] = vehData[idex][veh_MaleteroCant][listitem];
        vehData[idex][veh_MaleteroCant][listitem] = 0;
        Datos[playerid][jManoData][0] = vehData[idex][veh_MaleteroData][listitem];
        vehData[idex][veh_MaleteroData][listitem] = 0;
        update_manos(playerid);
        new action[64];
        formatt(action, "saca un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
        accion_player(playerid, 1, action);
        return SendClientMessage(playerid, COLOR_DARKGREEN, "Sacas un %s del maletero.", ObjetoInfo[Datos[playerid][jMano][0]][NombreObjeto]);
    }
    
    return 1;
}

Dialog:CharVeh_Op(playerid, response, listitem, inputtext[]){
    if(!response){
        PC_EmulateCommand(playerid, "/miscoches");
        return 1;
    }
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