forward vehiclesOnGameModeInit();
forward vehiclesOnGameModeExit();


forward vehiclesOnPlayerExitVehicle(playerid, vehicleid);

forward vehiclesEngine(idex);
forward vehiclesLock(idex);
forward vehiclesLights(vehicleid);
forward vehiclesTrunk(idex);
forward vehiclesHood(idex);
forward vehiclesOnVehicleUpdate(vehicleid);

forward vehicleGlobalAutoSave();
forward vehicleAutoSave(index);
forward OnCharacterVehicleLoad(playerid);
forward vehicleInventory_Load();
forward putPlayerInVeh(playerid, vehicleid, seat);
forward vehiclesOnCharVehicleCreated(creatorid, ownerid, modelid, index, color1, color2);
forward vehiclesOnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
forward vehiclesOnPlayerEnterCheckpoint(playerid);
forward vehiclesOnPlayerLeaveCheckpoint(playerid);
forward vehiclesOnVehicleSpawn(vehicleid);
forward CharVeh_Free(index);
forward CharVeh_Spawn(indx);
forward CharVeh_Unspawn(indx);
forward CharVeh_Load(charid);
forward vehicleOnSave(index);


public vehiclesOnGameModeInit(){
    for(new i; i < MAX_VEHICULOS; i++){
        vehData[i][veh_vID] = INVALID_VEHICLE_ID;
        continue;
    }
}
public vehiclesOnGameModeExit(){
    return 1;
}

public CharVeh_Load(charid){
	new connected;
	foreach(new i: Player){
		if(Datos[i][jSQLIDP] == charid){
			connected = i;
			break;
		}
	}
	if(connected != INVALID_PLAYER_ID){
		new query[256];
        mysql_format(SQLDB, query, sizeof(query), "SELECT * FROM `vehicles` WHERE `Owner_ID` = %d OR `SQLID` = %d OR `SQLID` = %d", charid, Datos[connected][jCocheLlaves][0], Datos[connected][jCocheLlaves][1]);
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
                    vehicleSave(v);
                    if(IsValidTimer(vehData[v][veh_AutoSaveTimer])) KillTimer(vehData[v][veh_AutoSaveTimer]);
                    vehData[v][veh_AutoSaveTimer] = SetTimerEx("vehicleAutoSave", 600000, true, "d", v);
                    if(IsValidTimer(vehTimer[v])) KillTimer(vehTimer[v]);
                    success = true;
                    break;
                }
                else if(vehData[v][veh_SQLID] == 0){
                    orm_vehicle(v);
                    orm_apply_cache(vehData[v][vehORM], i);
                    if(curr_load != vehData[v][veh_SQLID]) serverLogRegister(sprintf("[OnCharacterVehicleLoad] ATENCIÓN: curr_load NO ES IGUAL al SQLID del vehículo cargado!! (curr_load %d) - (SQLID %d)", curr_load, vehData[v][veh_SQLID]), CURRENT_MODULE);
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Tu vehículo %s (ID %d) ha sido cargado desde la base de datos.", modelGetName(vehData[v][veh_Modelo]), vehData[v][veh_SQLID]);
                    serverLogRegister(sprintf("Vehículo %s SQLID %d (%s) fue cargado desde la base de datos (callback de %s)", modelGetName(vehData[v][veh_Modelo]), curr_load, vehData[v][veh_Matricula], GetName(playerid)), CURRENT_MODULE);
                    if(IsValidTimer(vehData[v][veh_AutoSaveTimer])) KillTimer(vehData[v][veh_AutoSaveTimer]);
                    vehData[v][veh_AutoSaveTimer] = SetTimerEx("vehicleAutoSave", 600000, true, "d", v);
                    if(IsValidTimer(vehTimer[v])) KillTimer(vehTimer[v]);
                    success = true;
                    break;
                }
            }
            if(!success){
                SendClientMessage(playerid, COLOR_DARKRED, "Hubo un error al cargar el vehículo SQLID %d. Contacta con un administrador.", curr_load);
                (sprintf("Ocurrió un error al cargar el vehículo SQLID %d!", curr_load));
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
                serverLogRegister(sprintf("[vehicleInventory_Load] Sin espacio para vehicle_id=%d (fila %d).", vid, i), CURRENT_MODULE);
                return 1;
            }
            placed = false;
        }
    }
    return 1;
}
stock modelGetName(modelid){
    new string[32];
    formatt(string, "%s", VehiclesName[modelid-400]);
    //Model_GetName(modelid, string);
    return string;
}

public vehiclesOnVehicleUpdate(vehicleid){
    new Float: vHealth;
	new idex = -1;
	for(new i; i < MAX_VEHICULOS; i++){
		if(vehicleid == vehData[i][veh_vID]){
			idex = i;
			break;
		}
		continue;
	}
    GetVehicleHealth(vehicleid, vHealth);
    if(vHealth <= 250){
		if(idex != -1){
			SetVehicleHealth(vehicleid, 260.0);
        	vehData[idex][veh_Engine] = false;
        	vehData[idex][veh_Vida] = 260.0;
        	vehiclesEngine(idex);
        	if(IsVehicleOccupied(vehicleid)){
        	    vehiclesLock(idex);
        	    foreach(new x: Player){
        	        if(IsPlayerConnected(x) && IsPlayerInVehicle(x, vehicleid)) GameTextForPlayer(x, "~r~VEHICULO DESTRUIDO!", 3000, 4);
        	        else continue;
        	    }
        	}
		}
		else{
            Veh_Engine(vehicleid);
            foreach(new x: Player){
        	    if(IsPlayerConnected(x) && IsPlayerInVehicle(x, vehicleid)) GameTextForPlayer(x, "~r~VEHICULO DESTRUIDO!", 3000, 4);
        	    else continue;
        	}
        }
    } 
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
    new i = FindVehIndxFromVehID(vehicleid);
    if(i == -1) return 1;
    GetVehiclePos(vehData[i][veh_vID], vehData[i][veh_PosX], vehData[i][veh_PosY], vehData[i][veh_PosZ]);
    GetVehicleZAngle(vehData[i][veh_vID], vehData[i][veh_PosR]);
    vehData[i][veh_Interior] = GetVehicleInterior(vehData[i][veh_vID]);
    vehData[i][veh_VW] = GetVehicleVirtualWorld(vehData[i][veh_vID]);
    return 1;
}

public vehiclesOnPlayerExitVehicle(playerid, vehicleid){
    update_manos(playerid);
    new i = FindVehIndxFromVehID(vehicleid);
    if(i == -1) return 1; 
    if(vehData[i][veh_vID] && vehData[i][veh_SQLID]){
        GetVehiclePos(vehData[i][veh_vID], vehData[i][veh_PosX], vehData[i][veh_PosY], vehData[i][veh_PosZ]);
        GetVehicleZAngle(vehData[i][veh_vID], vehData[i][veh_PosR]);
        vehData[i][veh_Interior] = GetVehicleInterior(vehData[i][veh_vID]);
        vehData[i][veh_VW] = GetVehicleVirtualWorld(vehData[i][veh_vID]);
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
            SetVehicleVirtualWorld(vehicleid, random(10)+1);
            SetVehicleNumberPlate(vehicleid, vehData[i][veh_Matricula]);
            SetVehicleVirtualWorld(vehicleid, vehData[i][veh_VW]);
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
public putPlayerInVeh(playerid, vehicleid, seat) return PutPlayerInVehicle(playerid, vehicleid, seat);

public vehiclesOnCharVehicleCreated(creatorid, ownerid, modelid, index, color1, color2){
    SendClientMessage(creatorid, COLOR_LIGHTCYAN, "Creaste el vehiculo modelo %s para el ID %d (%s). SQLID: %d", modelGetName(modelid), ownerid, GetRPName(ownerid), vehData[index][veh_SQLID]);
    SendClientMessage(ownerid, COLOR_LIGHTCYAN, "%s creó el vehículo personal modelo %s (SQLID: %d)", GetRPName(creatorid), modelGetName(modelid), vehData[index][veh_SQLID]);
    vehData[index][veh_vID] = CreateVehicle(modelid, vehData[index][veh_PosX], vehData[index][veh_PosY], vehData[index][veh_PosZ], vehData[index][veh_PosR], color1, color2, -1, false);
    SetVehicleVirtualWorld(vehData[index][veh_vID], random(10)+1);
    SetVehicleNumberPlate(vehData[index][veh_vID], vehData[index][veh_Matricula]);
    SetVehicleVirtualWorld(vehData[index][veh_vID], GetPlayerVirtualWorld(ownerid));
    SetTimerEx("putPlayerInVeh", 500, false, "ddd", ownerid, vehData[index][veh_vID], 0);
    characterSave(ownerid);
    return 1;
}

public CharVeh_Unspawn(indx){
    serverLogRegister(sprintf("Ocultando el vehículo index %d (SQLID: %d | Matrícula: %s | Modelo: %s | Dueño: %s)", indx, vehData[indx][veh_SQLID], vehData[indx][veh_Matricula], modelGetName(vehData[indx][veh_Modelo]), vehData[indx][veh_Owner]), CURRENT_MODULE);
    vehicleSave(indx);
    DestroyVehicle(vehData[indx][veh_vID]);
    vehData[indx][veh_vID] = INVALID_VEHICLE_ID;
    for(new i; i < MAX_VEHICLE_INVENTORY_CACHE; i++){
        if(vehicleInventory[i][vehSQLID] == vehData[indx][veh_SQLID]){
            vehicleInventory[i][vehSQLID] = 0;
            vehicleInventory[i][veh_Slot] = -1;
            vehicleInventory[i][veh_Maletero] = 0;
            vehicleInventory[i][veh_MaleteroCant] = 0;
            vehicleInventory[i][veh_MaleteroData] = 0;
        }
        else continue;
    }
    return 1;
}
public CharVeh_Spawn(indx){
    if(vehData[indx][veh_vID] != INVALID_VEHICLE_ID){
        serverLogRegister(sprintf("Hubo un error al spawnear el coche index %d (SQLID %d): Ya esta spawneado!", indx, vehData[indx][veh_SQLID]), CURRENT_MODULE);
        return 1;
    }
    else{
        
        serverLogRegister(sprintf( "Spawneando el vehículo index %d (SQLID: %d | Matrícula: %s | Modelo: %s | Dueño: %s)...", indx, vehData[indx][veh_SQLID], vehData[indx][veh_Matricula], modelGetName(vehData[indx][veh_Modelo]), vehData[indx][veh_Owner]), CURRENT_MODULE);
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
        new query[128];
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

get_plate(playerid, nuevodueno, modelo, index, color1, color2){
    randomPlate(vehData[index][veh_Matricula], 10);
    new query[128];
    mysql_format(SQLDB, query, sizeof(query), "SELECT `Matricula` FROM `vehicles` WHERE `Matricula` = '%e'", vehData[index][veh_Matricula]);
    mysql_tquery(SQLDB, query, "plateCheck", "dddddd", playerid, nuevodueno, modelo, index, color1, color2);
    return 1;
}
forward plateCheck(playerid, nuevodueno, modelo, index, color1, color2);
public plateCheck(playerid, nuevodueno, modelo, index, color1, color2){
    if(cache_num_rows()){
        return get_plate(playerid, nuevodueno, modelo, index, color1, color2);
    }
    else{
        serverLogRegister(sprintf("Creando el vehículo index %d (Matrícula: %s | Modelo: %s (%d) | Dueño: %s) | Comando ejecutado: /crearvehiculo (%s - %s)", index, vehData[index][veh_Matricula], modelGetName(vehData[index][veh_Modelo]), vehData[index][veh_Modelo], vehData[index][veh_Owner], Datos[playerid][jNombrePJ], username[playerid]), CURRENT_MODULE);
        orm_insert(vehData[index][vehORM], "vehiclesOnCharVehicleCreated", "dddddd", playerid, nuevodueno, modelo, index, color1, color2);
    }
    return 1;
}

#define LETTER_A 65          // 'A'
#define LETTERS_COUNT 26

randomPlate(plate[], len)
{
    new leading = random(9) + 1;        // 1..9
    new l1 = LETTER_A + random(LETTERS_COUNT);
    new l2 = LETTER_A + random(LETTERS_COUNT);
    new l3 = LETTER_A + random(LETTERS_COUNT);
    new digits = random(10000);         // 0000..9999

    format(plate, len, "%d%c%c%c%04d",
        leading,
        l1,
        l2,
        l3,
        digits
    );
    return 1;
}


public CharVeh_Free(index){
    if(vehData[index][veh_SQLID] && vehData[index][veh_Tipo] == 1){
        serverLogRegister(sprintf( "Liberando el vehículo SQLID %d matrícula %s...", vehData[index][veh_SQLID], vehData[index][veh_Matricula]), CURRENT_MODULE);
        vehicleSave(index);
        if(vehData[index][veh_vID] != INVALID_VEHICLE_ID) DestroyVehicle(vehData[index][veh_vID]);
        vehData[index][veh_vID] = INVALID_VEHICLE_ID;
        clear_vehiclevars(index);
    }
    return 1;
}

vehicleSave(index){
    if(!vehData[index][veh_SQLID]) return 1;
    yield 1;
    serverLogRegister(sprintf("Guardando los datos del vehículo SQLID %d matrícula %s", vehData[index][veh_SQLID], vehData[index][veh_Matricula]), CURRENT_MODULE);
    if(vehData[index][veh_vID] != INVALID_VEHICLE_ID){
        GetVehiclePos(vehData[index][veh_vID], vehData[index][veh_PosX], vehData[index][veh_PosY], vehData[index][veh_PosZ]);
        GetVehicleZAngle(vehData[index][veh_vID], vehData[index][veh_PosR]);
        vehData[index][veh_VW] = GetVehicleVirtualWorld(vehData[index][veh_vID]);
        vehData[index][veh_Interior] = GetVehicleInterior(vehData[index][veh_vID]);
        GetVehicleHealth(vehData[index][veh_vID], vehData[index][veh_Vida]);
        GetVehicleDamageStatus(vehData[index][veh_vID], vehData[index][veh_DmgSuperficie], vehData[index][veh_DmgPuertas], vehData[index][veh_DmgLuces], vehData[index][veh_DmgRuedas]);
    }
    new error = await Task:orm_async_update(vehData[index][vehORM]);
    if(error != _:ERROR_OK)
        serverLogRegister(sprintf("Ocurrió un error al guardar los datos del vehículo SQLID %d matrícula %s", vehData[index][veh_SQLID], vehData[index][veh_Matricula]), CURRENT_MODULE);
    else{
        serverLogRegister(sprintf("Guardados los datos del vehículo SQLID %d matrícula %s", vehData[index][veh_SQLID], vehData[index][veh_Matricula]), CURRENT_MODULE);
        vehicleInventorySave(index);
    }
    return 1;
}


GetBootCapacity(modelid)
{
    /*if (!Model_IsValid(modelid)) return 0;

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
    if (Model_IsCar(modelid))          return 8;*/

    // catch-all
    #pragma unused modelid
    return 8;
}

Vehicle_IsBike(vehicleid){
    if(IsValidVehicle(vehicleid))
        return Model_IsBike(GetVehicleModel(vehicleid));
    else return 0;
}

Vehicle_IsBoat(vehicleid){
    if(!IsValidVehicle(vehicleid)) return 0;
    new model = GetVehicleModel(vehicleid);
    new boats[] ={
        472,
        473,
        493,
        595,
        484,
        430,
        453,
        452,
        446,
        454
    };
    for(new i; i < sizeof(boats); i++){
        if(model == boats[i]) return 1;
        else continue;
    }
    return 0;
}

Model_IsBike(modelid){
    new bikes[] = {
        581,
        509,
        481,
        462,
        521,
        463,
        510,
        522,
        461,
        448,
        468,
        586
    };
    for(new i; i < sizeof(bikes); i++){
        if(modelid == bikes[i]) return 1;
        else continue;
    }
    #pragma unused modelid
    return 0;
}
Model_IsPolice(modelid){
    new police[] = {
        433,
        427,
        490,
        528,
        470,
        596,
        598,
        599,
        597,
        601
    };
    for(new i; i < sizeof(police); i++){
        if(modelid == police[i]) return 1;
        else continue;
    }
    #pragma unused modelid
    return 0;
}

Vehicle_IsFlowerpot(vehicleid) return (IsValidVehicle(vehicleid) && GetVehicleModel(vehicleid) == 594);



vehicleInventorySave(index){
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
    vehData[index][veh_Owner] = EOS;
    vehData[index][veh_vID] = INVALID_VEHICLE_ID;
    vehData[index][veh_Vida] = 1000.0;
    vehData[index][veh_PosX] = 0.0;
    vehData[index][veh_PosY] = 0.0;
    vehData[index][veh_PosZ] = 0.0;
    vehData[index][veh_PosR] = 0.0;
    vehData[index][veh_Tipo] = 0;
    vehData[index][veh_Matricula] = EOS;
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
    vehData[index][veh_EspacioMal] = 0;
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
    vehData[index][veh_Engine] = false;
    vehData[index][veh_Hood] = false;
    vehData[index][veh_Trunk] = false;
    vehData[index][veh_SQLID] = 0;
    orm_clear_vars(vehData[index][vehORM]);
    if(vehData[index][vehORM] != MYSQL_INVALID_ORM){
        orm_destroy(vehData[index][vehORM]);
        vehData[index][vehORM] = MYSQL_INVALID_ORM;
    }
    return 1;
}


public vehicleGlobalAutoSave(){
    yield 1;
    for(new v; v < MAX_VEHICULOS; v++){
        if(vehData[v][veh_SQLID]){
            vehicleAutoSave(v);
            //wait_ticks(1);
        }
    }
    return 1;
}

public vehicleAutoSave(index){
	if(vehData[index][veh_SQLID]){
        serverLogRegister(sprintf("Ejecutando autoguardado del vehículo SQLID %d Matrícula %s", vehData[index][veh_SQLID], vehData[index][veh_Matricula]), CURRENT_MODULE);
		vehicleSave(index);
	}
    return 1;
}

