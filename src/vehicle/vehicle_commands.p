

CMD:miscoches(playerid){
    if(!IsPlayerConnected(playerid)) return 1;
    if(Datos[playerid][EnChar]) dialog_vehiculos(playerid);
    return 1;
}


hasVehicleKeys(playerid, veh_index){
    if(vehData[veh_index][veh_Tipo] == 1){ // Si es un vehículo personal:
        if(vehData[veh_index][veh_OwnerID] == Datos[playerid][jSQLIDP]) return 1;
        for(new i; i < 2; i++){
            if(vehData[veh_index][veh_SQLID] == Datos[playerid][jCocheLlaves][i]) return 1;
            else continue;
        }
        return 1;
    }
    return 0;
}

CMD:motor(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en un vehículo.");
    if(GetPlayerVehicleSeat(playerid) != 0) return SendClientMessage(playerid, COLOR_DARKRED, "No eres el conductor del vehículo.");
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] != INVALID_VEHICLE_ID && IsPlayerInVehicle(playerid, vehData[i][veh_vID])){
            new has_keys = hasVehicleKeys(playerid, i);
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
    if(GetPlayerState(playerid) == PLAYER_STATE_EXIT_VEHICLE) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes ponerte el cinturón mientras bajas del vehículo.");
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
                has_keys = hasVehicleKeys(playerid, i);
                if(!has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes las llaves de este vehículo.");
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
        has_keys = hasVehicleKeys(playerid, idex);
        if(currdist > 5.0 && !has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes un vehiculo lo suficientemente cerca.");
        if(!has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes las llaves de este vehículo.");
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
        saveCharacterInventory(playerid);
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
    if(Model_IsBike(GetVehicleModel(veh)) || !Model_IsPolice(GetVehicleModel(veh))) return SendClientMessage(playerid, COLOR_DARKRED, "Este vehículo no tiene una gunrack.");
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
        saveCharacterInventory(playerid);
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
    if(Model_IsBike(GetVehicleModel(veh)) || !Model_IsPolice(GetVehicleModel(veh))) return SendClientMessage(playerid, COLOR_DARKRED, "Este vehículo no tiene una gunrack.");
    if(GetPlayerVehicleSeat(playerid) > 1) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes acceder al gunrack desde allí.");
    new idex = FindVehIndxFromVehID(veh);
    if(vehData[idex][veh_Gunrack]) return SendClientMessage(playerid, COLOR_SEAGREEN, "Encuentras en el gunrack: %s (%d) [%d]", ObjetoInfo[vehData[idex][veh_Gunrack]][NombreObjeto], vehData[idex][veh_GunrackCant], vehData[idex][veh_GunrackData]);
    else return SendClientMessage(playerid, COLOR_DARKRED, "La gunrack se encuentra vacía.");
}

CMD:prestarveh(playerid, params[]){
    new
        user,
        sqlid,
        veh_idex
    ;
    if(sscanf(params, "rd", user, sqlid) || isnull(params)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /prestarveh [id/Nombre] [ID en /coches]");
    if(!IsPlayerConnected(user)) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El jugador no está conectado.");
    if(sqlid < 1) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: ID inválida.");
    veh_idex = FindVehIndxFromSQLID(sqlid);
    if(veh_idex == -1) return 1;
    if(vehData[veh_idex][veh_OwnerID] != Datos[playerid][jSQLIDP]) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: Ese vehículo no es tuyo.");
    for(new i; i < 2; i++){
        if(Datos[user][jCocheLlaves][i]){
            if(i == 0) continue;
            else if(i == 1) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El jugador ya tiene sus slots de vehículos ocupados.");
        }
        SendClientMessage(playerid, COLOR_BLUE, "Le ofreciste las llaves de tu %s a %s. Espera una respuesta.", modelGetName(vehData[veh_idex][veh_Modelo]), GetRPName(user));
        SendClientMessage(user, COLOR_BLUE, "%s te ofreció las llaves de su %s. Utiliza /aceptar o /rechazar.", GetRPName(playerid), modelGetName(vehData[veh_idex][veh_Modelo]));
        solicitud_tipo[user] = 2;
        solicitante[user] = playerid;
        solicitud_timer[user] = SetTimerEx("TimeOutRequest", 8000, false, "d", user);
        SetPVarInt(playerid, "prestar_veh_idex", veh_idex);
        return 1;
    }
    return 1;
}
CMD:mal(playerid, params[]){
    new 
        Float:veh_pos[3],
        idex = -1,
        Float:currdist = 7.0,
        has_keys
    ;
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No puedes hacer eso estando dentro de un vehículo.");
    sscanf(params, "S()[24]", params);
    if(isnull(params)) SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /mal [abrir | cerrar | (dejar en blanco para abrir y ver el maletero)]");
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_SQLID]){
            if(vehData[i][veh_vID] != INVALID_VEHICLE_ID){
                if(GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehData[i][veh_vID])){
                    if(GetPlayerInterior(playerid) == GetVehicleInterior(vehData[i][veh_vID])){
                        if(IsPlayerNearVehiclePart(playerid, vehData[i][veh_vID], VEH_PART_TRUNK, 2.0)){
                            GetPosNearVehiclePart(vehData[i][veh_vID], VEH_PART_TRUNK, veh_pos[0], veh_pos[1], veh_pos[2], 0);
                            if(currdist > GetPlayerDistanceFromPoint(playerid, veh_pos[0], veh_pos[1], veh_pos[2])){
                                idex = i;
                                currdist = GetPlayerDistanceFromPoint(playerid, veh_pos[0], veh_pos[1], veh_pos[2]);
                                continue;
                            }
                            else continue;
                        }
                    }
                }
            }
        }
    }
    if(idex != -1){
        has_keys = hasVehicleKeys(playerid, idex);
        if(strcmp(params, "abrir", true) == 0 && !isnull(params)){
            if(!has_keys) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes llaves para este maletero.");
            if(vehData[idex][veh_Trunk]) return SendClientMessage(playerid, COLOR_DARKRED, "El maletero ya está abierto.");
            SendClientMessage(playerid, COLOR_DARKGREEN, "Abriste el maletero del vehículo.");
            serverLogRegister(sprintf("%s abrió el maletero del vehículo \"%s\" %s ID %d", GetName(playerid), modelGetName(vehData[idex][veh_Modelo]), vehData[idex][veh_Matricula], vehData[idex][veh_SQLID]), CURRENT_MODULE);
            vehData[idex][veh_Trunk] = true;
            vehiclesTrunk(idex);
            return 1;
        }
        if(strcmp(params, "cerrar", true) == 0 && !isnull(params)){
            if(!vehData[idex][veh_Trunk]) return SendClientMessage(playerid, COLOR_DARKRED, "El maletero ya está cerrado.");
            SendClientMessage(playerid, COLOR_DARKGREEN, "Cierras el maletero del vehículo.");
            vehData[idex][veh_Trunk] = false;
            vehiclesTrunk(idex);
            serverLogRegister(sprintf("%s cierra el maletero del vehículo \"%s\" %s ID %d", GetName(playerid), modelGetName(vehData[idex][veh_Modelo]), vehData[idex][veh_Matricula], vehData[idex][veh_SQLID]), CURRENT_MODULE);
            if(GetPVarType(playerid, "veh_mal")) DeletePVar(playerid, "veh_mal");
            foreach(new invplayer: Player){
                if(GetPVarType(invplayer, "veh_mal")){
                    if(GetPVarInt(invplayer, "veh_mal") == idex+1){
                        SendClientMessage(invplayer, COLOR_DARKRED, "El maletero del vehículo fue cerrado.");
                        Dialog_Close(invplayer);
                        DeletePVar(invplayer, "veh_mal");
                    }
                }
            }
            return 1;
        }
        SetPVarInt(playerid, "veh_mal", idex+1);
        dialog_maletero(playerid);
        return 1;
    }
    return SendClientMessage(playerid, COLOR_DARKRED, "No encontramos un vehículo que puedas abrir.");
}
alias:miscoches("coches")
alias:mal("maletero")