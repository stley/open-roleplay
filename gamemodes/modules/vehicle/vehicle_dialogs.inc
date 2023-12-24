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
            formatt(title, "%s [%d]", Model_RtrName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
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
            formatt(title, "%s [%d]", Model_RtrName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
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
            formatt(title, "%s [%d]", Model_RtrName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
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
            formatt(title, "%s [%d]", Model_RtrName(vehData[idex][veh_Modelo]), vehData[idex][veh_SQLID]);
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