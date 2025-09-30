

flags:crearobjeto(CMD_ADMIN)
CMD:crearobjeto(playerid, params[])
{
    new objetoid;
    new cantidad;
    new mano;
    if(sscanf(params, "ddd", objetoid, cantidad, mano)) return SendClientMessage(playerid, COLOR_GRAYWHITE, "/crearobjeto [id objeto] [cantidad] [mano (0 - Derecha, 1 - Izquierda)]");
    if(mano > 1 || mano < 0) return SendClientMessage(playerid, COLOR_DARKRED, "/crearobjeto [id objeto] [cantidad] [mano (0 - Derecha, 1 - Izquierda)]");
    if(objetoid > sizeof(ObjetoInfo)-1) return SendClientMessage(playerid, COLOR_DARKRED, "ID de objeto inválida, utiliza /listaobjetos para ver los objetos disponibles.");
    if(ObjetoInfo[objetoid][Tipo] == 0) return SendClientMessage(playerid, COLOR_DARKRED, "ID de objeto inválida, utiliza /listaobjetos para ver los objetos disponibles.");
    if(Datos[playerid][jMano][mano])
    {
        if(guardar_bol(playerid, mano))
        {
            Datos[playerid][jMano][mano] = objetoid;
            if(cantidad < ObjetoInfo[objetoid][Capacidad]) Datos[playerid][jManoCant][mano] = cantidad;
            else Datos[playerid][jManoCant][mano] = ObjetoInfo[objetoid][Capacidad];
            update_manos(playerid);
            serverLogRegister(sprintf("%s (%s) creó un objeto: %s (cant: %d)", Datos[playerid][jNombrePJ], username[playerid], ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]), CURRENT_MODULE);
            return SendClientMessage(playerid, COLOR_LIGHTRED,"AdmCmd: Creaste un objeto \"%s\" (cantidad: %d)", ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]);
        }
    }
    else
    {
        Datos[playerid][jMano][mano] = objetoid;
        if(cantidad < ObjetoInfo[objetoid][Capacidad]) Datos[playerid][jManoCant][mano] = cantidad;
        else Datos[playerid][jManoCant][mano] = ObjetoInfo[objetoid][Capacidad];
        update_manos(playerid);
        serverLogRegister(sprintf("%s (%s) creó un objeto: %s (cant: %d)", Datos[playerid][jNombrePJ], username[playerid], ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]), CURRENT_MODULE);
        return SendClientMessage(playerid, COLOR_LIGHTRED,"AdmCmd: Creaste un objeto \"%s\" (cantidad: %d)", ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]);
    }
    return 1;
}


flags:editattached(CMD_ADMIN)
CMD:editattached(playerid, params[]){
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /editattached [Slot del PlayerAttachedObject]");
    if(!IsPlayerAttachedObjectSlotUsed(playerid, params[0])) return SendClientMessage(playerid, COLOR_DARKRED, "No hay ningun objeto en ese slot.");
    EditType[playerid] = 1337;
    EditAttachedObject(playerid, params[0]);
    return 1;
}
flags:listaobjetos(CMD_ADMIN)
CMD:listaobjetos(playerid)
{
    return dialog_listaobjetos(playerid);
}
flags:limpiarmanos(CMD_MOD)
CMD:limpiarmanos(playerid, params[])
{
    new objetivo;
    if(sscanf(params, "r", objetivo)) return SendClientMessage(playerid, COLOR_DARKRED, "/limpiarmanos [playerid/nick]");
    new log[256];
    formatt(log, "%s (%s) limpió las manos de %s (%s).\n\tTenía en sus manos:", Datos[playerid][jNombrePJ], username[playerid], Datos[objetivo][jNombrePJ], username[objetivo]);
    if(Datos[objetivo][jMano][0])
        strcat(log, sprintf(" Mano derecha: %s ID:%d - Cantidad: %d (extra: %d)", ObjetoInfo[Datos[objetivo][jMano][0]][NombreObjeto], Datos[objetivo][jMano][0], Datos[objetivo][jManoCant][0], Datos[objetivo][jManoData][0]));
    if(Datos[objetivo][jMano][1])
        strcat(log, sprintf(" - Mano izquierda: %s ID:%d - Cantidad: %d (extra: %d)", ObjetoInfo[Datos[objetivo][jMano][1]][NombreObjeto], Datos[objetivo][jMano][1], Datos[objetivo][jManoCant][1], Datos[objetivo][jManoData][1]));
    serverLogRegister(log);
    Datos[objetivo][jMano][0] = 0;
    Datos[objetivo][jManoCant][0] = 0;
    Datos[objetivo][jManoData][0] = 0;
    Datos[objetivo][jMano][1] = 0;
    Datos[objetivo][jManoCant][1] = 0;
    Datos[objetivo][jManoData][1] = 0;
    update_manos(objetivo);
    SendClientMessage(playerid, COLOR_LIGHTRED, "AdmCmd: Borraste los objetos de las manos de %s.", Datos[objetivo][jNombrePJ]);
    SendClientMessage(objetivo, COLOR_LIGHTRED, "AdmCmd: El staff %s (%s) borró los objetos de tus manos.", Datos[playerid][jNombrePJ], username[playerid]);
    return 1;
}
flags:darskin(CMD_JR_MOD)
CMD:darskin(playerid, params[]){
    if(sscanf(params, "rd", params[0], params[1])) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /darskin [ID/Nombre] [ID Skin]");
    if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_DARKRED, "El usuario seleccionado no esta conectado.");
    
    serverLogRegister(sprintf("%s (%s) cambió la skin de %s de %d a %d.", Datos[playerid][jNombrePJ], username[playerid], Datos[params[0]][jNombrePJ], Datos[params[0]][jRopa], params[1]), CURRENT_MODULE);
    SendClientMessage(params[0], COLOR_LIGHTRED, "AdmCmd: %s (%s) cambió la skin de %s de %d a %d.", Datos[playerid][jNombrePJ], username[playerid], Datos[params[0]][jNombrePJ], Datos[params[0]][jRopa], params[1]);
    SetPlayerSkin(params[0], params[1]);
    Datos[params[0]][jRopa] = params[1];
    return 1;
}

flags:verstats(CMD_JR_MOD)
CMD:verstats(playerid, params[]){
    if(isnull(params)) return SendClientMessage(playerid, COLOR_INDIGO, "USO: /verstats [ID/Nombre]");
    new target;
    if(sscanf(params, "r", target)) return SendClientMessage(playerid, COLOR_INDIGO, "USO: /verstats [ID/Nombre]");
    new msg[512];
    SendClientMessage(playerid, COLOR_GREEN,"Estadísticas de %s (%s):", Datos[target][jNombrePJ], username[target]);
    SendClientMessage(playerid, COLOR_GREEN, "Estadísticas IC:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Nombre: %s | Edad: %d | Sexo: %s | Trabajo: %s (%d) | Efectivo: %d", Datos[target][jNombrePJ], Datos[target][jEdad], (Datos[target][jSexo] == 1) ? "Hombre" : "Mujer", "Carpintero", 3, Datos[target][jDinero]);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Facción: %d | Rango: %d — | — Facción Secundaria: %d | Rango: %d", Datos[target][jFaccion], Datos[target][jRango], Datos[target][jFaccion2], Datos[target][jRangoFac2]);
    SendClientMessage(playerid, COLOR_GREEN, "Licencias:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Conducir: %s | Armas: %s", (Datos[target][jLicencias][0]) ? "Sí" : "No", (Datos[target][jLicencias][1]) ? "Sí" : "No");
    SendClientMessage(playerid, COLOR_GREEN, "Estadísticas OOC:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "SQLID (usuario): %d | SQLID (personaje): %d ", Datos[target][jSQLID], Datos[target][jSQLIDP]);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Nivel: %d | Puntos de experiencia: %d | Horas jugadas: %d ", Datos[target][jNivel], Datos[target][jExp], Datos[target][jHoras]);
    formatt(msg, "Premium: %s", (Datos[target][jPremium] > 0) ? "Sí" : "No");
    if(Datos[target][jPremium]){
        new little_buff[96];
        formatt(little_buff, " | Vigente hasta: %d de %s de %d", Datos[target][jDpremium], GetMonth(Datos[target][jMpremium]), Datos[target][jApremium]);
        strcat(msg, little_buff);
    }
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, msg);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Puntos de rol: %d / %d", Datos[target][jPuntosRol], Datos[target][jPuntosRolNeg]);
    SendClientMessage(playerid, COLOR_GREEN, "Propiedades:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Casas: %d — %d | Casa prestada: %d", Datos[target][jCasa][0], Datos[target][jCasa][1], Datos[target][jCasaLlaves]);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Vehiculos prestados: %d | %d", Datos[target][jCocheLlaves][0], Datos[target][jCocheLlaves][1]);
    SendClientMessage(playerid, COLOR_GREEN, "Interiores:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Casa: %d — Negocio: %d | Interior: %d — VirtualWorld: %d", DentroCasa[target], DentroNegocio[target], GetPlayerInterior(target), GetPlayerVirtualWorld(target));
    return 1;
}
flags:crearvehiculo(CMD_ADMIN)
CMD:crearvehiculo(playerid, params[]){  //Crear vehiculos personales
    new
        nuevodueno,
        modelo,
        color1,
        color2
    ;
    if(sscanf(params, "rddd", nuevodueno, modelo, color1, color2)){
        SendClientMessage(playerid, COLOR_SYSTEM, "USO: /crearvehiculo [ID/nombrejugador] [modelo] [Color 1] [Color 2]");
        return 1;
    }
    if(!IsPlayerConnected(nuevodueno)){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: Ese jugador no está conectado.");
        return 1;
    }
    if(GetPlayerState(nuevodueno) != PLAYER_STATE_ONFOOT){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El jugador tiene que estar a pie.");
        return 1;
    }
    if(modelo < 400 || modelo > 611){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: ID de modelo inválida.");
        return 1;
    }
    else if(color1 > 255 || color1 < 0 || color2 > 255 || color2 < 0 ){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: ID de colores inválida.");
        return 1;
    }
    for(new i; i < MAX_VEHICULOS; i++){
        if(!vehData[i][veh_Modelo]){
                alm(vehData[i][veh_Owner], GetName(nuevodueno));
                vehData[i][veh_OwnerID] = Datos[nuevodueno][jSQLIDP];
                vehData[i][veh_Modelo] = modelo;
                vehData[i][veh_Tipo] = 1;
                vehData[i][veh_Color1] = color1;
                vehData[i][veh_Color2] = color2;
                GetPlayerPos(nuevodueno, vehData[i][veh_PosX], vehData[i][veh_PosY], vehData[i][veh_PosZ]);
                GetPlayerFacingAngle(nuevodueno, vehData[i][veh_PosR]);
                vehData[i][veh_Interior] = GetPlayerInterior(nuevodueno);
                vehData[i][veh_VW] = GetPlayerVirtualWorld(nuevodueno);
                vehData[i][veh_Gasolina] = 100;
                vehData[i][veh_EspacioMal] = GetBootCapacity(modelo);
                vehData[i][veh_Vida] = 1000.0;
                orm_vehicle(i);
                return get_plate(playerid, nuevodueno, modelo, i, color1, color2);
        }
    }
    return 1;
}

flags:ircoord(CMD_OPERATOR)
CMD:ircoord(playerid, params[]){
    if(sscanf(params, "fff", params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /ircoord [X] [Y] [Z]");
    teleportPlayer(playerid, params[0], params[1], params[2], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    return 1;
}
flags:setplayer(CMD_OPERATOR)
CMD:setplayer(playerid, params[]){
    new id2, vwid, intid;
    if(isnull(params)) return SendClientMessage(playerid, COLOR_DARKRED, "VirtualWorld: %d, Interior: %d", GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    if(sscanf(params, "rdd", id2, vwid, intid)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /setplayer [id/Nombre] [Dim] [Interior]");
    SetPlayerVirtualWorld(playerid, vwid);
    SetPlayerInterior(playerid, intid);
    return 1;
}
flags:fixveh(CMD_JR_MOD)
CMD:fixveh(playerid){
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_DARKRED, "No estás en ningun vehículo.");
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] == GetPlayerVehicleID(playerid)){
            vehData[i][veh_Vida] = 1000.0;
            RepairVehicle(vehData[i][veh_vID]);
            vehData[i][veh_DmgSuperficie] = VEHICLE_PANEL_STATUS_NONE;
            vehData[i][veh_DmgPuertas] = CARDOOR_NONE;
            vehData[i][veh_DmgLuces] = VEHICLE_LIGHT_STATUS_NONE;
            vehData[i][veh_DmgRuedas] = VEHICLE_TYRE_STATUS_NONE;
            SendClientMessage(playerid, COLOR_GREEN, "Reparaste el vehículo ID %d.", vehData[i][veh_vID]);
            new bool:alarm, bool:lights;
            SetVehicleParamsEx(vehData[i][veh_vID], bool:vehData[i][veh_Engine], lights, alarm, bool:vehData[i][veh_Bloqueo], bool:vehData[i][veh_Hood], bool:vehData[i][veh_Trunk]);
            serverLogRegister(sprintf("[AdmCMD] %s (%s) reparó el vehículo modelo %s ID %d (SQLID %d).", username[playerid], GetName(playerid), modelGetName(vehData[i][veh_Modelo]), vehData[i][veh_vID], vehData[i][veh_SQLID]), CURRENT_MODULE);
            return 1;
        }
    }
    RepairVehicle(GetPlayerVehicleID(playerid));
    return 1;
}
flags:traerveh(CMD_JR_MOD)
CMD:traerveh(playerid, params[]){
    new vid;
    if(sscanf(params, "d", vid)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /traerveh [id del vehiculo]");
    if(!IsValidVehicle(vid)) return SendClientMessage(playerid, COLOR_DARKRED, "La ID es inválida, no corresponde a un vehiculo spawneado.");
    new Float:player_pos[4];
    GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
    GetPlayerFacingAngle(playerid, player_pos[3]);
    SetVehicleVirtualWorld(vid, GetPlayerVirtualWorld(playerid));
    SetVehiclePos(vid, player_pos[0], player_pos[1], player_pos[2]);
    SetVehicleZAngle(vid, player_pos[3]);
    LinkVehicleToInterior(vid, GetPlayerInterior(playerid));
    SendClientMessage(playerid, COLOR_GREEN, "Trajiste el vehículo %s ID %d.", modelGetName(GetVehicleModel(vid)), vid);
    return 1;
}
flags:irveh(CMD_JR_MOD)
CMD:irveh(playerid, params[]){
    new vid;
    if(sscanf(params, "d", vid)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /irveh [ID del vehículo]");
    if(!IsValidVehicle(vid)) return SendClientMessage(playerid, COLOR_DARKRED, "La ID es inválida, no corresponde a un vehículo spawneado.");
    new Float:veh_pos[4];
    GetVehiclePos(vid, veh_pos[0], veh_pos[1], veh_pos[2]);
    GetVehicleZAngle(vid, veh_pos[3]);
    teleportPlayer(playerid, veh_pos[0], veh_pos[1], veh_pos[2], GetVehicleInterior(playerid), GetVehicleVirtualWorld(vid));
    SetPlayerFacingAngle(playerid, veh_pos[3]);
    return 1;
}
flags:crearv(CMD_JR_OPERATOR)
CMD:crearv(playerid, params[]){
    new vid;
    if(sscanf(params, "d", vid)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /crearv [ModelID]");
    new Float:player_pos[4];
    GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
    GetPlayerFacingAngle(playerid, player_pos[3]);
    CreateVehicle(vid, player_pos[0], player_pos[1], player_pos[2], player_pos[3], 1, 0, -1, false); 
    return 1;
}
flags:darvida(CMD_JR_MOD)
CMD:darvida(playerid, params[]){
    new target;
    if(sscanf(params, "r", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /darvida [Nombre/ID]");
    Datos[target][jVida] = 100.0;
    SetPlayerHealth(target, Datos[target][jVida]);
    clear_wounds(target);
    SendClientMessage(playerid, COLOR_DARKRED, "ADM: Curas a %s con un comando de moderación.", Name_sin(GetRPName(target)));
    SendClientMessage(target, COLOR_LIGHTBLUE, "%s (%s) te curó con un comando de moderación.", Name_sin(GetRPName(playerid)), username[playerid]);
    return 1;
}
flags:darchaleco(CMD_JR_OPERATOR)
CMD:darchaleco(playerid, params[]){
    new target;
    if(sscanf(params, "r", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /darvida [Nombre/ID]");
    Datos[target][jChaleco] = 100.0;
    SetPlayerArmour(target, Datos[target][jChaleco]);
    SendClientMessage(playerid, COLOR_DARKRED, "ADM: Le otorgas un chaleco a %s con un comando de moderación.", Name_sin(GetRPName(target)));
    SendClientMessage(target, COLOR_LIGHTBLUE, "%s (%s) te dió un chaleco con un comando de moderación.", Name_sin(GetRPName(playerid)), username[playerid]);
    return 1;
}
flags:revivir(CMD_JR_MOD)
CMD:revivir(playerid, params[]){
    new target;
    if(sscanf(params, "r", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /revivir [Nombre/ID]");
    if(!muerto[target]) return SendClientMessage(playerid, COLOR_DARKRED,"¡Ese personaje no esta muerto!");
    TogglePlayerControllable(target, true);
    ClearAnimations(target, SYNC_ALL);
    muerto[target] = 0;
    Datos[target][jVida] = 100.0;
    SetPlayerHealth(target, Datos[target][jVida]);
    KillTimer(RespawnTimer[target]);
    SendClientMessage(playerid, COLOR_DARKRED, "ADM: Revives a %s con un comando de moderación.", Name_sin(GetRPName(target)));
    SendClientMessage(target, COLOR_LIGHTBLUE, "%s (%s) te revivió con un comando de moderación.", Name_sin(GetRPName(playerid)), username[playerid]);
    clear_wounds(target);
    return 1;
}
flags:darmod(CMD_ADMIN)
CMD:darmod(playerid, params[]){
    new target[32], level;
    if(sscanf(params, "s[32]d", target, level)) return SendClientMessage(playerid, COLOR_BRIGHTRED, "USO: /darmod [Cuenta] [Nivel de Rango Administrativo]");
    if(level >= Datos[playerid][jAdmin]) return SendClientMessage(playerid, COLOR_DARKRED, "¡No puedes ceder rangos administrativos superiores o igual al tuyo!");
    //if(!accountCheck(target)) return SendClientMessage(playerid, COLOR_DARKRED, "¡La cuenta %s no existe!");
    new query[256];
    foreach(new i: Player){
        if(strequal(target, username[i], true)){
            if(Datos[i][jAdmin] >= Datos[playerid][jAdmin]) return SendClientMessage(playerid, COLOR_DARKRED, "¡No puedes cambiar el rango de un superior o un usuario de tu mismo rango!");
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "Le cediste el rango administrativo nivel %d a %s (%s)", level, username[i], Name_sin(GetName(i)));
            SendClientMessage(i, COLOR_LIGHTBLUE, "%s (%s) te cedió el rango administrativo nivel %d.", username[playerid], Name_sin(GetName(playerid)), level);
            serverLogRegister(sprintf("%s (%s) le cedió el rango administrativo nivel %d a %s (%s).", username[playerid], Name_sin(GetName(playerid)), level, username[i], Name_sin(GetName(i))), CURRENT_MODULE);
            Datos[i][jAdmin] = level;
            accountSave(i);
            return 1;
        }
    }
    mysql_format(SQLDB, query, sizeof(query), "SELECT `accounts`.`Administrador`, `accounts`.`Nombre`,`accounts`.`SQLID` FROM `accounts` WHERE `Nombre` = '%e' LIMIT 1", target);
    mysql_tquery(SQLDB, query, "adminUpdate", "dsd", playerid, target, level);
    return 1;
}

flags:test_wound(CMD_OWNER)
CMD:test_wound(playerid){
    woundHandleDamage(playerid, playerid, ObjetoInfo[Datos[playerid][jMano][0]][IDArma], 3, 40.0);
    return 1;
}


flags:server_shutdown(CMD_OWNER)
CMD:server_shutdown(playerid){
    CallLocalFunction("serverShutdown");
    return 1;
}
flags:trigger_autosave(CMD_OWNER)
CMD:trigger_autosave(playerid){
    CallLocalFunction("globalAutoSave");
    return 1;
}

