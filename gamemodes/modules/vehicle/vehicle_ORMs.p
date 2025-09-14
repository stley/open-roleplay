stock orm_vehicle(index){
    new ORM:ormid = vehData[index][vehORM] = orm_create("vehicles", SQLDB);

    orm_addvar_int(ormid, vehData[index][veh_SQLID], "SQLID");
    orm_addvar_string(ormid, vehData[index][veh_Owner], 25, "Owner");
    orm_addvar_int(ormid, vehData[index][veh_OwnerID], "Owner_ID");
    orm_addvar_float(ormid, vehData[index][veh_Vida], "Vida");
    orm_addvar_float(ormid, vehData[index][veh_PosX], "PosX");
    orm_addvar_float(ormid, vehData[index][veh_PosY], "PosY");
    orm_addvar_float(ormid, vehData[index][veh_PosZ], "PosZ");
    orm_addvar_float(ormid, vehData[index][veh_PosR], "PosR");
    orm_addvar_int(ormid, vehData[index][veh_Tipo], "Tipo");
    orm_addvar_string(ormid, vehData[index][veh_Matricula], 20, "Matricula");
    orm_addvar_int(ormid, vehData[index][veh_Modelo], "Modelo");
    orm_addvar_int(ormid, vehData[index][veh_Color1], "Color1");
    orm_addvar_int(ormid, vehData[index][veh_Color2], "Color2");
    orm_addvar_int(ormid, vehData[index][veh_Gasolina], "Gasolina");
    orm_addvar_int(ormid, vehData[index][veh_Bloqueo], "Bloqueo");
    orm_addvar_int(ormid, vehData[index][veh_VW], "VW");
    orm_addvar_int(ormid, vehData[index][veh_Interior], "Interior");
    orm_addvar_int(ormid, vehData[index][veh_Deposito], "Deposito");
    orm_addvar_int(ormid, _:vehData[index][veh_DmgSuperficie], "DmgSuperficie");
    orm_addvar_int(ormid, _:vehData[index][veh_DmgPuertas], "DmgPuertas");
    orm_addvar_int(ormid, _:vehData[index][veh_DmgLuces], "DmgLuces");
    orm_addvar_int(ormid, _:vehData[index][veh_DmgRuedas], "DmgRuedas");
    orm_addvar_int(ormid, vehData[index][veh_EspacioMal], "EspacioMal");
    orm_addvar_int(ormid, vehData[index][veh_Guantera], "Guantera");
    orm_addvar_int(ormid, vehData[index][veh_GuanteraCant], "GuanteraCant");
    orm_addvar_int(ormid, vehData[index][veh_GuanteraData], "GuanteraData");
    orm_addvar_int(ormid, vehData[index][veh_Gunrack], "Gunrack");
    orm_addvar_int(ormid, vehData[index][veh_GunrackCant], "GunrackCant");
    orm_addvar_int(ormid, vehData[index][veh_GunrackData], "GunrackData");
    for(new i; i < MAX_MODVEHICULOS; i++){
        new sql[8];
        formatt(sql, "mods%d", i);
        orm_addvar_int(ormid, vehData[index][veh_mods][i], sql);
    }
    orm_setkey(ormid, "SQLID");
    return 1;
}