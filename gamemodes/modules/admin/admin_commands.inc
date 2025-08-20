flags:crearobjeto(CMD_OWNER | CMD_ADMIN)
CMD:crearobjeto(playerid, params[])
{
    new objetoid;
    new cantidad;
    new mano;
    if(sscanf(params, "ddd", objetoid, cantidad, mano)) return SendClientMessage(playerid, COLOR_GRAYWHITE, "/crearobjeto [id objeto] [cantidad] [mano (0 - Derecha, 1 - Izquierda)]");
    if(mano > 1 || mano < 0) return SendClientMessage(playerid, COLOR_DARKRED, "/crearobjeto [id objeto] [cantidad] [mano (0 - Derecha, 1 - Izquierda)]");
    if(objetoid > sizeof(ObjetoInfo)-1) return SendClientMessage(playerid, COLOR_DARKRED, "ID de objeto inválida, utiliza /listaobjetos para ver los objetos disponibles.");
    if(strcmp(ObjetoInfo[objetoid][NombreObjeto], "SLOT LIBRE", true) == 0) return SendClientMessage(playerid, COLOR_DARKRED, "ID de objeto inválida, utiliza /listaobjetos para ver los objetos disponibles.");
    if(Datos[playerid][jMano][mano])
    {
        if(guardar_bol(playerid, mano))
        {
            Datos[playerid][jMano][mano] = objetoid;
            if(cantidad < ObjetoInfo[objetoid][Capacidad]) Datos[playerid][jManoCant][mano] = cantidad;
            else Datos[playerid][jManoCant][mano] = ObjetoInfo[objetoid][Capacidad];
            update_manos(playerid);
            printf("%s (%s) creó un objeto: %s (cant: %d)", Datos[playerid][jNombrePJ], username[playerid], ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]);
            return SendClientMessage(playerid, COLOR_LIGHTRED,"AdmCmd: Creaste un objeto \"%s\" (cantidad: %d)", ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]);
        }
    }
    else
    {
        Datos[playerid][jMano][mano] = objetoid;
        if(cantidad < ObjetoInfo[objetoid][Capacidad]) Datos[playerid][jManoCant][mano] = cantidad;
        else Datos[playerid][jManoCant][mano] = ObjetoInfo[objetoid][Capacidad];
        update_manos(playerid);
        printf("%s (%s) creó un objeto: %s (cant: %d)", Datos[playerid][jNombrePJ], username[playerid], ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]);
        return SendClientMessage(playerid, COLOR_LIGHTRED,"AdmCmd: Creaste un objeto \"%s\" (cantidad: %d)", ObjetoInfo[objetoid][NombreObjeto], Datos[playerid][jManoCant][mano]);
    }
    return 1;
}
Dialog:D_PLACEHOLDER(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;
    else return 1;
}
Dialog:D_LISTAOBJETO(playerid, response, listitem, inputtext[]){
    new dlg[3000];
    new dlg_buff[96];
    switch(listitem){
        case 0:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 0){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 1:{
            for(new i; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 1){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 2:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 2){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 3:{
            new control;
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 3){
                    formatt(dlg_buff, "%s - %d\t", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                    control++;
                    if(control == 2){
                        control = 0;
                        strcat(dlg, "\n");
                    }
                    
                }
            }
        }
        case 4:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 4){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 5:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 5){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 6:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 6){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 7:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 7){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 8:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 8){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 9:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 9){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 10:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 10){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 11:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 11){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 12:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 12){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
    }
    Dialog_Show(playerid, D_PLACEHOLDER, DIALOG_STYLE_MSGBOX, "Objetos disponibles", dlg, "Aceptar", "");
    return;  
}
flags:editattached(CMD_OWNER | CMD_ADMIN)
CMD:editattached(playerid, params[]){
    if(sscanf(params, "d", params[0])){
        SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /editattached [Slot del PlayerAttachedObject]");
        return;
    }
    if(!IsPlayerAttachedObjectSlotUsed(playerid, params[0])){
        SendClientMessage(playerid, COLOR_DARKRED, "No hay ningun objeto en ese slot.");
        return;
    }
    EditAttachedObject(playerid, params[0]);
    EditType[playerid] = 1337;
}
flags:listaobjetos(CMD_OWNER | CMD_ADMIN)
CMD:listaobjetos(playerid)
{
    new dlg[200];
    formatt(dlg, "\
        Sin uso\n\
        Comestibles\n\
        Bebidas\n\
        Accesorios\n\
        Armas blancas\n\
        Armas de fuego\n\
        Cargadores\n\
        Municiones\n\
        Cajas\n\
        Drogas individuales\n\
        Fardos de droga\n\
        Objetos con utilidades\n\
        Contenedores (pueden almacenar objetos dentro)");
    Dialog_Show(playerid, D_LISTAOBJETO, DIALOG_STYLE_LIST, "Selecciona la categoría", dlg, "Seleccionar", "");
}
flags:limpiarmanos(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD)
CMD:limpiarmanos(playerid, params[])
{
    new objetivo;
    if(sscanf(params, "u[25]", objetivo)) return SendClientMessage(playerid, COLOR_DARKRED, "/limpiarmanos [playerid/nick]");
    printf("AdmCmd: %s (%s) limpió las manos de %s (%s).", Datos[playerid][jNombrePJ], username[playerid], Datos[objetivo][jNombrePJ], username[objetivo]);
    printf("Tenía en sus manos:");
    if(Datos[objetivo][jMano][0]) printf("Mano derecha: %s ID:%d - Cantidad: %d (extra: %d)", ObjetoInfo[Datos[objetivo][jMano][0]][NombreObjeto], Datos[objetivo][jMano][0], Datos[objetivo][jManoCant][0], Datos[objetivo][jManoData][0]);
    if(Datos[objetivo][jMano][1]) printf("Mano izquierda: %s ID:%d - Cantidad: %d (extra: %d)", ObjetoInfo[Datos[objetivo][jMano][1]][NombreObjeto], Datos[objetivo][jMano][1], Datos[objetivo][jManoCant][1], Datos[objetivo][jManoData][1]);
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
flags:darskin(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD)
CMD:darskin(playerid, params[]){
    if(sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /darskin [ID/Nombre] [ID Skin]");
    if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_DARKRED, "El usuario seleccionado no esta conectado.");

    printf("%s (%s) cambió la skin de %s de %d a %d.", Datos[playerid][jNombrePJ], username[playerid], Datos[params[0]][jNombrePJ], Datos[params[0]][jRopa], params[1]);
    SendClientMessage(params[0], COLOR_LIGHTRED, "AdmCmd: %s (%s) cambió la skin de %s de %d a %d.", Datos[playerid][jNombrePJ], username[playerid], Datos[params[0]][jNombrePJ], Datos[params[0]][jRopa], params[1]);
    SetPlayerSkin(params[0], params[1]);
    Datos[params[0]][jRopa] = params[1];
    return 1;
}

flags:verstats(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD)
CMD:verstats(playerid, params[]){
    if(isnull(params)) return SendClientMessage(playerid, COLOR_INDIGO, "USO: /verstats [ID/Nombre]");
    new target;
    if(sscanf(params, "u[25]", target)) return SendClientMessage(playerid, COLOR_INDIGO, "USO: /verstats [ID/Nombre]");
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
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Vehiculos: %d — %d | Vehículo prestado: %d", Datos[target][jCoche][0], Datos[target][jCoche][1], Datos[target][jCocheLlaves]);
    SendClientMessage(playerid, COLOR_GREEN, "Interiores:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Casa: %d — Negocio: %d | Interior: %d — VirtualWorld: %d", DentroCasa[target], DentroNegocio[target], GetPlayerInterior(target), GetPlayerVirtualWorld(target));
    return 1;
}
flags:crearvehiculo(CMD_OWNER | CMD_ADMIN)
CMD:crearvehiculo(playerid, params[]){  //Crear vehiculos personales
    new
        nuevodueno,
        modelo,
        color1,
        color2
    ;
    if(sscanf(params, "uddd", nuevodueno, modelo, color1, color2)){
        SendClientMessage(playerid, COLOR_SYSTEM, "USO: /crearvehiculo [ID/nombrejugador] [modelo] [Color 1] [Color 2]");
        return;
    }
    if(!IsPlayerConnected(nuevodueno)){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: Ese jugador no está conectado.");
        return;
    }
    if(GetPlayerState(nuevodueno) != PLAYER_STATE_ONFOOT){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El jugador tiene que estar a pie.");
        return;
    }
    if(modelo < 400 || modelo > 611){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: ID de modelo inválida.");
        return;
    }
    else if(color1 > 255 || color1 < 0 || color2 > 255 || color2 < 0 ){
        SendClientMessage(playerid, COLOR_DARKRED, "ERROR: ID de colores inválida.");
        return;
    }
    for(new i; i < MAX_VEHICULOS; i++){
        if(!vehData[i][veh_Modelo]){
            for(new x; x < 2; x++){
                if(!Datos[nuevodueno][jCoche][x]){
                    alm(vehData[i][veh_Dueno], GetName(nuevodueno));
                    vehData[i][veh_Modelo] = modelo;
                    vehData[i][veh_Tipo] = 1;
                    vehData[i][veh_Color1] = color1;
                    vehData[i][veh_Color2] = color2;
                    GetPlayerPos(nuevodueno, vehData[i][veh_PosX], vehData[i][veh_PosY], vehData[i][veh_PosZ]);
                    GetPlayerFacingAngle(nuevodueno, vehData[i][veh_PosR]);
                    vehData[i][veh_Interior] = GetPlayerInterior(nuevodueno);
                    vehData[i][veh_VW] = GetPlayerVirtualWorld(nuevodueno);
                    vehData[i][veh_Matricula] = get_plate();
                    vehData[i][veh_Gasolina] = 100;
                    orm_vehicle(i);
                    printf("Creando el vehículo index %d  (Matrícula: LS%s | Modelo: %s | Dueño: %s) | Comando ejecutado: /crearvehiculo (%s - %s)", i, vehData[i][veh_SQLID], vehData[i][veh_Matricula], modelGetName(vehData[i][veh_Modelo]), vehData[i][veh_Dueno], Datos[playerid][jNombrePJ], username[playerid]);
                    orm_insert(vehData[i][vehORM], "vehiclesOnCharVehicleCreated", "ddddd", playerid, nuevodueno, modelo, i, x);
                    vehData[i][veh_vID] = CreateVehicle(modelo, vehData[i][veh_PosX], vehData[i][veh_PosY], vehData[i][veh_PosZ], vehData[i][veh_PosR], color1, color2, -1, false);
                    PutPlayerInVehicle(nuevodueno, vehData[i][veh_vID], 0);
                    
                    return;
                }
                else if(Datos[nuevodueno][jCoche][x] && x == 1){
                    SendClientMessage(playerid, COLOR_DARKRED, "ERROR: Este jugador tiene sus slots de vehiculos ya ocupados.");
                    return;
                }
            }
            SendClientMessage(playerid, COLOR_DARKRED, "ERROR: No hay más index para vehiculos, contacta con un administrador.");
        }
    }
    return;
}
flags:ircoord(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR)
CMD:ircoord(playerid, params[]){
    if(sscanf(params, "fff", params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /ircoord [X] [Y] [Z]");
    teleportPlayer(playerid, params[0], params[1], params[2], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    return 1;
}
flags:setplayer(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR)
CMD:setplayer(playerid, params[]){
    new id2, vwid, intid;
    if(isnull(params)) return SendClientMessage(playerid, COLOR_DARKRED, "VirtualWorld: %d, Interior: %d", GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    if(sscanf(params, "udd", id2, vwid, intid)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /setplayer [id/Nombre] [Dim] [Interior]");
    SetPlayerVirtualWorld(playerid, vwid);
    SetPlayerInterior(playerid, intid);
    return 1;
}
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
            GetVehicleParamsEx(vehData[i][veh_vID], bool:vehData[i][veh_Engine], lights, alarm, bool:vehData[i][veh_Bloqueo], bool:vehData[i][veh_Hood], bool:vehData[i][veh_Trunk]);
        }
    }
    return 1;
}
flags:traerveh(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD)
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
flags:irveh(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD)
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
flags:crearv(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD)
CMD:crearv(playerid, params[]){
    new vid;
    if(sscanf(params, "d", vid)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /crearv [ModelID]");
    new Float:player_pos[4];
    GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
    GetPlayerFacingAngle(playerid, player_pos[3]);
    CreateVehicle(vid, player_pos[0], player_pos[1], player_pos[2], player_pos[3], 1, 0, -1, false); 
    return 1;
}
flags:darvida(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD)
CMD:darvida(playerid, params[]){
    new target;
    if(sscanf(params, "u[25]", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /darvida [Nombre/ID]");
    Datos[target][jVida] = 100.0;
    SetPlayerHealth(target, Datos[target][jVida]);
    clear_wounds(target);
    SendClientMessage(playerid, COLOR_DARKRED, "ADM: Curas a %s con un comando de moderación.", Name_sin(GetRPName(target)));
    SendClientMessage(target, COLOR_LIGHTBLUE, "%s (%s) te curó con un comando de moderación.", Name_sin(GetRPName(playerid)), username[playerid]);
    return 1;
}
flags:darchaleco(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR )
CMD:darchaleco(playerid, params[]){
    new target;
    if(sscanf(params, "u[25]", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /darvida [Nombre/ID]");
    Datos[target][jChaleco] = 100.0;
    SetPlayerArmour(target, Datos[target][jChaleco]);
    SendClientMessage(playerid, COLOR_DARKRED, "ADM: Le otorgas un chaleco a %s con un comando de moderación.", Name_sin(GetRPName(target)));
    SendClientMessage(target, COLOR_LIGHTBLUE, "%s (%s) te dió un chaleco con un comando de moderación.", Name_sin(GetRPName(playerid)), username[playerid]);
    return 1;
}
flags:revivir(CMD_OWNER | CMD_ADMIN | CMD_OPERATOR | CMD_JR_OPERATOR | CMD_MOD | CMD_JR_MOD)
CMD:revivir(playerid, params[]){
    new target;
    if(sscanf(params, "u[25]", target)) return SendClientMessage(playerid, COLOR_DARKRED, "USO: /revivir [Nombre/ID]");
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
flags:test_wound(CMD_OWNER)
CMD:test_wound(playerid){
    Wound_HandleDamage(playerid, playerid, ObjetoInfo[Datos[playerid][jMano][0]][IDArma], 3, 40.0);
    return 1;
}