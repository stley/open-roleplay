enum vehInfo
{
    ORM:vehORM,
    veh_vID,
    //Almacenables
    veh_SQLID,
    veh_Owner[32],
    veh_OwnerID,
    Float:veh_Vida,
    Float:veh_PosX,
    Float:veh_PosY,
    Float:veh_PosZ,
    Float:veh_PosR,
    veh_Tipo,
    veh_Matricula[20],
    veh_Modelo,
    veh_Color1,
    veh_Color2,
    veh_Gasolina,
    veh_Bloqueo,
    veh_VW,
    veh_Interior,
    veh_Deposito,
    VEHICLE_PANEL_STATUS:veh_DmgSuperficie,
    VEHICLE_DOOR_STATUS:veh_DmgPuertas,
    VEHICLE_LIGHT_STATUS:veh_DmgLuces,
    VEHICLE_TYRE_STATUS:veh_DmgRuedas,
    veh_mods[15],
    veh_EspacioMal,
    /*veh_Maletero[15],
    veh_MaleteroCant[15],
    veh_MaleteroData[15],*/
    veh_Guantera,
    veh_GuanteraCant,
    veh_GuanteraData,
    veh_Gunrack,
    veh_GunrackCant,
    veh_GunrackData,
    //
    bool:veh_Engine,
    bool:veh_Trunk,
    bool:veh_Hood
}
#define MAX_VEHICLE_INVENTORY_CACHE   (MAX_VEHICULOS*20)
enum VehicleInventory{
    vehSQLID,
    veh_Slot,
    veh_Maletero,
    veh_MaleteroCant,
    veh_MaleteroData,
    veh_Huellas[25]
}
new vehicleInventory[MAX_VEHICLE_INVENTORY_CACHE][VehicleInventory];
new vehData[MAX_VEHICULOS][vehInfo];
new vehTimer[MAX_VEHICULOS];
new savehTimer[MAX_VEHICULOS];