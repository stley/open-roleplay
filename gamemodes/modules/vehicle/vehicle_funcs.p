forward vehiclesOnGameModeInit();
forward vehiclesOnGameModeExit();

forward OnVehicleUpdate();

forward vehiclesOnPlayerExitVehicle(playerid, vehicleid);

forward vehiclesEngine(idex);
forward vehiclesLock(idex);
forward vehiclesLights(vehicleid);
forward vehiclesTrunk(idex);
forward vehiclesHood(idex);
forward vehiclesOnVehicleUpdate();

forward OnCharacterVehicleLoad(playerid);
forward vehicleInventory_Load();
forward vehiclesOnCharVehicleCreated(creatorid, ownerid, modelid, index, slot);
forward vehiclesOnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
forward vehiclesOnPlayerEnterCheckpoint(playerid);
forward vehiclesOnPlayerLeaveCheckpoint(playerid);
forward vehiclesOnVehicleSpawn(vehicleid);
forward CharVeh_Free(index);
forward CharVeh_Spawn(indx);
forward CharVeh_Unspawn(indx);
forward CharVeh_Load(charid);

public vehiclesOnGameModeInit(){
    SetTimer("OnVehicleUpdate", 6000, true);
    for(new i; i < MAX_VEHICULOS; i++){
        vehData[i][veh_vID] = INVALID_VEHICLE_ID;
        continue;
    }
}
public vehiclesOnGameModeExit(){
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_Tipo] || vehData[i][veh_Modelo]){
            clear_vehiclevars(i);
            continue;
        }
    }
    return 1;
}

public CharVeh_Load(charid){
	new connected;
	for(new i; i < MAX_PLAYERS; i++){
		if(Datos[i][jSQLIDP] == charid){
			connected = i;
			break;
		}
	}
	if(connected != INVALID_PLAYER_ID){
		new query[256];
        mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `vehicles` WHERE `Owner_ID` = %d", charid);
        mysql_tquery(SQLDB, query, "OnCharacterVehicleLoad", "d", connected);
        return 1;
	}
    return 1;
}

public OnCharacterVehicleLoad(playerid){
	if(cache_num_rows()){
        new 
            curr_load,
            bool:success = false
            ;
        for(new i; i < cache_num_rows(); i++){
            cache_get_value_name_int(i, "SQLID", curr_load);
            for(new v; v < MAX_VEHICULOS; v++){
                if(vehData[v][veh_SQLID] == curr_load){
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Tu vehículo %s (ID %d) ya fue cargado anteriormente, salteando...", modelGetName(vehData[v][veh_Modelo]), vehData[v][veh_SQLID]);
                    success = true;
                    break;
                }
                else if(vehData[v][veh_SQLID] == 0){
                    orm_vehicle(v);
                    orm_apply_cache(vehData[v][vehORM], i);
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Tu vehículo %s (ID %d) ha sido cargado desde la base de datos.", modelGetName(vehData[v][veh_Modelo]), vehData[v][veh_SQLID]);
                    success = true;
                    break;
                }
            }
            if(!success){
                SendClientMessage(playerid, COLOR_DARKRED, "Hubo un error al cargar el vehículo SQLID %d. Contacta con un administrador.", curr_load);
            }
            success = false;
        }
	}
	return 1;
}
public vehicleInventory_Load(){
    new rows = cache_num_rows();
    new bool:placed = false;
    if(rows){
        for(new i; i < rows; i++){
            new
                sqlid,
                slot,
                tipo, cant, data,
                huellas[25];

            cache_get_value_name_int(i, "vehicle_id", sqlid);
            cache_get_value_name_int(i, "inventory_slot_id", slot);
            cache_get_value_name_int(i, "inventory_value", tipo);
            cache_get_value_name_int(i, "inventory_quantity", cant);
            cache_get_value_name_int(i, "inventory_data", data);
            cache_get_value_name(i, "huellasInventory", huellas, 25);
            for(new inv; inv < MAX_VEHICLE_INVENTORY_CACHE; inv++){
                if(vehicleInventory[inv][vehSQLID] == sqlid && vehicleInventory[inv][veh_Slot] == slot){
                    placed = true;
                    break;
                }
                if(vehicleInventory[inv][vehSQLID] == 0){
                    
                    vehicleInventory[inv][vehSQLID] = sqlid;
                    vehicleInventory[inv][veh_Slot] = slot;
                    vehicleInventory[inv][veh_Maletero] = tipo;
                    vehicleInventory[inv][veh_MaleteroCant] = cant;
                    vehicleInventory[inv][veh_MaleteroData] = data;
                    alm(vehicleInventory[inv][veh_Huellas], huellas);
                    placed = true;
                    break;
                }
            }
            if (!placed){
                new vid; cache_get_value_name_int(i, "vehicle_id", vid);
                printf("[vehicleInventory_Load] Sin espacio para vehicle_id=%d (fila %d).", vid, i);
                return 1;
            }
            placed = false;
        }
    }
    return 1;
}
stock modelGetName(modelid){
    new string[32];
    //formatt(string, "%s", VehiclesName[modelid-400]);
    Model_GetName(modelid, string);
    return string;
}

public vehiclesEngine(idex){
    new
        bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
    GetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, bonnet, boot, objective);
    if(vehData[idex][veh_Engine] == true) SetVehicleParamsEx(vehData[idex][veh_vID], true, lights, alarm, doors, bonnet, boot, objective);
    else SetVehicleParamsEx(vehData[idex][veh_vID], false, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}
Veh_Engine(vehicleid){
    new
        bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(engine == false) SetVehicleParamsEx(vehicleid, true, lights, alarm, doors, bonnet, boot, objective);
    else SetVehicleParamsEx(vehicleid, false, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}
public vehiclesLock(idex){
    new
        bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
    GetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, bonnet, boot, objective);
    if(vehData[idex][veh_Bloqueo] == 1) SetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, true, bonnet, boot, objective); 
    else SetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, false, bonnet, boot, objective); 
    return 1;
}
public vehiclesLights(vehicleid){
    
    new
        bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, (lights) ? false : true, alarm, doors, bonnet, boot, objective); 
    return 1;
}

public vehiclesTrunk(idex){
    new
        bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
    GetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, bonnet, boot, objective);
    if(vehData[idex][veh_Trunk] == true) SetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, bonnet, true, objective); 
    else SetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, bonnet, false, objective);      
    return 1;
}

public vehiclesHood(idex){
    new
        bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
    GetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, bonnet, boot, objective);
    if(vehData[idex][veh_Hood] == true) SetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, true, boot, objective);
    else SetVehicleParamsEx(vehData[idex][veh_vID], engine, lights, alarm, doors, false, boot, objective);
    return 1;
}


public OnVehicleUpdate()
{
    for(new i; i < MAX_VEHICULOS; i++)
    {
        if(vehData[i][veh_vID] != INVALID_VEHICLE_ID){
            new Float: vHealth;
            GetVehicleHealth(vehData[i][veh_vID], vHealth);
            if(vHealth <= 250){
                SetVehicleHealth(vehData[i][veh_vID], 260.0);
                vehData[i][veh_Engine] = false;
                vehData[i][veh_Vida] = 260.0;
                vehiclesEngine(i);
                if(IsVehicleOccupied(vehData[i][veh_vID])){
                    vehiclesLock(i);
                    for(new x; x < MAX_PLAYERS; x++){
                        if(IsPlayerConnected(x) && IsPlayerInVehicle(x, vehData[i][veh_vID])) GameTextForPlayer(x, "~r~VEHICULO DESTRUIDO!", 3000, 4);
                        else continue;
                    }
                }
            } 
        } 
    }
    return 1;
}

public vehiclesOnPlayerEnterCheckpoint(playerid){
    
    if(!checkpoints[playerid] || checkpoints[playerid] != 1) return 1;
    SendClientMessage(playerid, COLOR_GREEN, "Llegaste a la ubicación del vehículo.");
    DisablePlayerCheckpoint(playerid);
    checkpoints[playerid] = 0;
    return 1;
}
 
public vehiclesOnPlayerLeaveCheckpoint(playerid){
    checkpoints[playerid] = 0;
    return 1;
}


public vehiclesOnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] != INVALID_VEHICLE_ID && vehData[i][veh_vID] == vehicleid){
            GetVehiclePos(vehData[i][veh_vID], vehData[i][veh_PosX], vehData[i][veh_PosY], vehData[i][veh_PosZ]);
            GetVehicleZAngle(vehData[i][veh_vID], vehData[i][veh_PosR]);
            vehData[i][veh_Interior] = GetVehicleInterior(vehData[i][veh_vID]);
            vehData[i][veh_VW] = GetVehicleVirtualWorld(vehData[i][veh_vID]);
        }
    }
}
public vehiclesOnPlayerExitVehicle(playerid, vehicleid){
    
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] == vehicleid){
            GetVehiclePos(vehData[i][veh_vID], vehData[i][veh_PosX], vehData[i][veh_PosY], vehData[i][veh_PosZ]);
            GetVehicleZAngle(vehData[i][veh_vID], vehData[i][veh_PosR]);
            vehData[i][veh_Interior] = GetVehicleInterior(vehData[i][veh_vID]);
            vehData[i][veh_VW] = GetVehicleVirtualWorld(vehData[i][veh_vID]); 
        }
    }
    if(CinturonV[playerid]){
        accion_player(playerid, 1, "se quita el cinturón de seguridad.");
        CinturonV[playerid] = 0;
    }
    return 1;
}

public vehiclesOnVehicleSpawn(vehicleid){
    new i;
    for(i = -1; i < MAX_VEHICULOS; i++){
        if(i == -1) continue;
        if(vehicleid == vehData[i][veh_vID]){
            SetVehicleNumberPlate(vehicleid, vehData[i][veh_Matricula]);
            SetVehicleHealth(vehicleid, vehData[i][veh_Vida]);
            UpdateVehicleDamageStatus(vehicleid, vehData[i][veh_DmgSuperficie], vehData[i][veh_DmgPuertas], vehData[i][veh_DmgLuces], vehData[i][veh_DmgRuedas]);
        }
    }
    new bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(i == -1) SetVehicleParamsEx(vehicleid, false, false, false, false, false, false, false);
    else SetVehicleParamsEx(vehicleid, false, false, false, vehData[i][veh_Bloqueo], false, false, false);
    
    return 1;
}
public vehiclesOnCharVehicleCreated(creatorid, ownerid, modelid, index, slot){
    SendClientMessage(creatorid, COLOR_LIGHTCYAN, "Creaste el vehiculo modelo %s para el ID %d (%s) en su slot %d. SQLID: %d", modelGetName(modelid), ownerid, GetRPName(ownerid), slot, vehData[index][veh_SQLID]);
    SendClientMessage(ownerid, COLOR_LIGHTCYAN, "%s creó el vehículo personal modelo %s (SQLID: %d) en tu slot %d.", GetRPName(creatorid), modelGetName(modelid), vehData[index][veh_SQLID], slot);
    //Datos[ownerid][jCoche][slot] = vehData[index][veh_SQLID];
    save_char(ownerid);
    return 1;
}
public CharVeh_Unspawn(indx){
    new dslog[512];
    format(dslog, sizeof(dslog), "Ocultando el vehículo index %d (SQLID: %d | Matrícula: %s | Modelo: %s | Dueño: %s)", indx, vehData[indx][veh_SQLID], vehData[indx][veh_Matricula], modelGetName(vehData[indx][veh_Modelo]), vehData[indx][veh_Owner]);
    serverLogRegister(dslog);
    save_vehicle(indx);
    DestroyVehicle(vehData[indx][veh_vID]);
    vehData[indx][veh_vID] = INVALID_VEHICLE_ID;
    return 1;
}
public CharVeh_Spawn(indx){
    if(vehData[indx][veh_vID] != INVALID_VEHICLE_ID){
        new dslog[512];
        format(dslog, sizeof(dslog), "Hubo un error al spawnear el coche index %d (SQLID %d): Ya esta spawneado!", indx, vehData[indx][veh_SQLID]);
        serverLogRegister(dslog);
        return 1;
    }
    else{
        new dslog[512];
        format(dslog, sizeof(dslog), "Spawneando el vehículo index %d (SQLID: %d | Matrícula: %s | Modelo: %s | Dueño: %s)...", indx, vehData[indx][veh_SQLID], vehData[indx][veh_Matricula], modelGetName(vehData[indx][veh_Modelo]), vehData[indx][veh_Owner]);
        serverLogRegister(dslog);
        vehData[indx][veh_vID] = CreateVehicle(vehData[indx][veh_Modelo], vehData[indx][veh_PosX], vehData[indx][veh_PosY], vehData[indx][veh_PosZ], vehData[indx][veh_PosR], vehData[indx][veh_Color1], vehData[indx][veh_Color2], -1, false);
        LinkVehicleToInterior(vehData[indx][veh_vID], vehData[indx][veh_Interior]);
        SetVehicleVirtualWorld(vehData[indx][veh_vID], vehData[indx][veh_VW]);
        SetVehicleHealth(vehData[indx][veh_vID], vehData[indx][veh_Vida]);
        UpdateVehicleDamageStatus(vehData[indx][veh_vID], vehData[indx][veh_DmgSuperficie], vehData[indx][veh_DmgPuertas], vehData[indx][veh_DmgLuces], vehData[indx][veh_DmgRuedas]);
        new
            bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
        GetVehicleParamsEx(vehData[indx][veh_vID], engine, lights, alarm, doors, bonnet, boot, objective);
        if(vehData[indx][veh_Bloqueo]) SetVehicleParamsEx(vehData[indx][veh_vID], engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
        SetVehicleNumberPlate(vehData[indx][veh_vID], vehData[indx][veh_Matricula]);
        new query[256];
        mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `vehicle_inventory` WHERE `vehicle_id` = %d LIMIT %d", vehData[indx][veh_SQLID], vehData[indx][veh_EspacioMal]);
        mysql_tquery(SQLDB, query, "vehicleInventory_Load");
    }
    return 1;
}

FindVehIndxFromSQLID(sqlid){
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_SQLID] == sqlid){
            return i;
        }
    }
    return -1;
}
FindVehIndxFromVehID(vehicleid){
    for(new i; i < MAX_VEHICULOS; i++){
        if(vehData[i][veh_vID] == vehicleid){
            return i;
        }
    }
    return -1;
}
vehicleFetchInventorySlot(veh_index, arr_slot){
    for(new i; i < MAX_VEHICLE_INVENTORY_CACHE; i++){
        if(vehicleInventory[i][vehSQLID] == vehData[veh_index][veh_SQLID] && vehicleInventory[i][veh_Slot] == arr_slot){
            return i;
        }
    }
    return -1;
}

get_plate(str[], type){
    alm(str, "-");
    new query[96];
    new plate[20];
    switch(type){
        case 1:{
            formatt(plate, "LS%d", Random(100, 99999999));
        }
        case 2:{
            formatt(plate, "SA%d", Random(100, 99999999));
        }
        default:{
            formatt(plate, "LS%d", Random(100, 99999999));
        }
    }
    mysql_format(SQLDB, query, sizeof(query), "SELECT `Matricula` FROM `vehicles` WHERE `Matricula` = '%e'", plate);
    new Cache:check = mysql_query(SQLDB, query);
    cache_set_active(check);
    new rows = cache_num_rows();
    cache_delete(check);
    if(rows){
        return get_plate(str, type);
    }
    alm(str, plate);
    return 1;
}
public CharVeh_Free(index){
    if(vehData[index][veh_SQLID] && vehData[index][veh_Tipo] == 1){
        
        for(new i; i < MAX_PLAYERS; i++){
            if(!IsPlayerConnected(i)) continue;
            if(vehData[index][veh_SQLID] == Datos[i][jCoche][0]) return 1;
            else if(vehData[index][veh_SQLID] == Datos[i][jCoche][1]) return 1;
            else if(vehData[index][veh_SQLID] == Datos[i][jCocheLlaves][0]) return 1;
            else if(vehData[index][veh_SQLID] == Datos[i][jCocheLlaves][1]) return 1;
        }
        save_vehicle(index);
        if(vehData[index][veh_vID] != INVALID_VEHICLE_ID) DestroyVehicle(vehData[index][veh_vID]);
        vehData[index][veh_vID] = INVALID_VEHICLE_ID;
        clear_vehiclevars(index);
    }
    return 1;
}

save_vehicle(index){
    if(vehData[index][veh_vID] != INVALID_VEHICLE_ID){
        GetVehiclePos(vehData[index][veh_vID], vehData[index][veh_PosX], vehData[index][veh_PosY], vehData[index][veh_PosZ]);
        GetVehicleZAngle(vehData[index][veh_vID], vehData[index][veh_PosR]);
        vehData[index][veh_VW] = GetVehicleVirtualWorld(vehData[index][veh_vID]);
        vehData[index][veh_Interior] = GetVehicleInterior(vehData[index][veh_vID]);
        GetVehicleHealth(vehData[index][veh_vID], vehData[index][veh_Vida]);
        GetVehicleDamageStatus(vehData[index][veh_vID], vehData[index][veh_DmgSuperficie], vehData[index][veh_DmgPuertas], vehData[index][veh_DmgLuces], vehData[index][veh_DmgRuedas]);
    }
    orm_update(vehData[index][vehORM]);
    save_veh_inventory(index);
}

GetBootCapacity(modelid)
{
    if (!Model_IsValid(modelid)) return 0;

    // non-land first
    if (Model_IsBike(modelid))         return 0;
    if (Model_IsBoat(modelid))         return 8;
    if (Model_IsHelicopter(modelid))   return 12;
    if (Model_IsPlane(modelid))        return 20;
    if (Model_IsTrain(modelid))        return 30;

    // service and specials
    if (Model_IsAmbulance(modelid))    return 12;
    if (Model_IsFire(modelid))         return 18;
    if (Model_IsTaxi(modelid))         return 8;
    if (Model_IsPolice(modelid)
     || Model_IsFBI(modelid)
     || Model_IsSWAT(modelid))         return 10;
    if (Model_IsMilitary(modelid))     return 10;
    if (Model_IsTank(modelid))         return 4;   // cramped
    if (Model_IsWeaponised(modelid))   return 6;

    // cargo and large
    if (Model_IsVan(modelid))          return 16;
    if (Model_IsTruck(modelid)
     || Model_IsTransport(modelid))    return 24;

    // defaults
    if (Model_IsCar(modelid))          return 8;

    // catch-all
    return 8;
}

save_veh_inventory(index){
    if(index < 0) return 1;
    new query[256];
    mysql_format(SQLDB, query, sizeof(query), "DELETE FROM `vehicle_inventory` WHERE `vehicle_id` = %d", vehData[index][veh_SQLID]);
    mysql_tquery(SQLDB, query);
    for(new i; i < MAX_VEHICLE_INVENTORY_CACHE; i++){
        if(vehData[index][veh_SQLID] == vehicleInventory[i][vehSQLID]){
            if(!vehicleInventory[i][veh_Maletero]) continue;
            mysql_format(SQLDB, query, sizeof(query), "INSERT INTO `vehicle_inventory` VALUES (%d, %d, %d, %d, %d, '%e')", 
            vehicleInventory[i][vehSQLID], 
            vehicleInventory[i][veh_Slot], 
            vehicleInventory[i][veh_Maletero], 
            vehicleInventory[i][veh_MaleteroCant], 
            vehicleInventory[i][veh_MaleteroData],
            vehicleInventory[i][veh_Huellas]);
            mysql_tquery(SQLDB, query);
            continue;
        }
    }
    return 1;
}

clear_vehiclevars(index){
    if(vehData[index][vehORM] != MYSQL_INVALID_ORM){
        orm_destroy(vehData[index][vehORM]);
        vehData[index][vehORM] = MYSQL_INVALID_ORM;
    }
    alm(vehData[index][veh_Owner], "-");
    vehData[index][veh_vID] = INVALID_VEHICLE_ID;
    vehData[index][veh_Vida] = 1000.0;
    vehData[index][veh_PosX] = 0.0;
    vehData[index][veh_PosY] = 0.0;
    vehData[index][veh_PosZ] = 0.0;
    vehData[index][veh_PosR] = 0.0;
    vehData[index][veh_Tipo] = 0;
    alm(vehData[index][veh_Matricula], "-");
    vehData[index][veh_Modelo] = 0;
    vehData[index][veh_Color1] = 0;
    vehData[index][veh_Color2] = 0;
    vehData[index][veh_Gasolina] = 100;
    vehData[index][veh_Bloqueo] = 0;
    vehData[index][veh_VW] = 0;
    vehData[index][veh_Interior] = 0;
    vehData[index][veh_Deposito] = 0;
    vehData[index][veh_DmgSuperficie] = VEHICLE_PANEL_STATUS:0;
    vehData[index][veh_DmgPuertas] = VEHICLE_DOOR_STATUS:0;
    vehData[index][veh_DmgLuces] = VEHICLE_LIGHT_STATUS:0;
    vehData[index][veh_DmgRuedas] = VEHICLE_TYRE_STATUS:0;
    vehData[index][veh_EspacioMal] = 15;
    vehData[index][veh_Guantera] = 0;
    vehData[index][veh_GuanteraCant] = 0;
    vehData[index][veh_GuanteraData] = 0;
    for(new i; i < MAX_MODVEHICULOS; i++){
        vehData[index][veh_mods][i] = 0;
    }
    for(new i; i < MAX_VEHICLE_INVENTORY_CACHE; i++){
        if(vehicleInventory[i][vehSQLID] == vehData[index][veh_SQLID]){
            vehicleInventory[i][vehSQLID] = 0;
            vehicleInventory[i][veh_Slot] = -1;
            vehicleInventory[i][veh_Maletero] = 0;
            vehicleInventory[i][veh_MaleteroCant] = 0;
            vehicleInventory[i][veh_MaleteroData] = 0;
        }
        else continue;
    }
    orm_clear_vars(vehData[index][vehORM]);
    vehData[index][veh_Engine] = false;
    vehData[index][veh_Hood] = false;
    vehData[index][veh_Trunk] = false;
    vehData[index][veh_SQLID] = 0;
    return 1;
}