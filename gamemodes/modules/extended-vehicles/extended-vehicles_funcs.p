//native CreateVehicle(modelid, Float:spawnX, Float:spawnY, Float:spawnZ, Float:angle, colour1, colour2, respawnDelay, bool:addSiren = false);


spawnCustomVehicle(modelid, Float:spawnX, Float:spawnY, Float:spawnZ, Float:angle, colour1, colour2, respawnDelay, bool:addSiren = false){
    for(new x; x < sizeof(custom_vehicles); x++){
        if(modelid == custom_vehicles[x][modelID]){
            for(new i; i < 10; i++){
                current_models_list[i][vehicleId] = CreateVehicle(custom_vehicles[x][modelBackEnd], spawnX, spawnY, spawnZ, angle, colour1, colour2, respawnDelay, addSiren);
                alm(current_models_list[i][ModelName], custom_vehicles[x][modelName]);
            }
            return 1;
        }
    }
    return 1;
}
//WorldVehicleAdd - ID: 164
//Parameters: UINT16 wVehicleID, UINT32 ModelID, float X, float Y, float Z, float Angle, UINT8 InteriorColor1, UINT8 InteriorColor2, float Health, UINT8 interior, UINT32 DoorDamageStatus, UINT32 PanelDamageStatus, UINT8 LightDamageStatus, UINT8 tireDamageStatus, UINT8 addSiren, UINT8 modslot0, UINT8 modslot1, UINT8 modslot2, UINT8 modslot3, UINT8 modslot4, UINT8 modslot5, UINT8 modslot6, UINT8 modslot7, UINT8 modslot8, UINT8 modslot9, UINT8 modslot10, UINT8 modslot11, UINT8 modslot12, UINT8 modslot13, UINT8 PaintJob, UINT32 BodyColor1, UINT32 BodyColor2
const RPC_WVA = 164;
public OnOutgoingRPC(playerid, rpcid, BitStream:bs){
    if(rpcid == RPC_WVA){

        new modelo, vehId;
        
        BS_ReadValue(bs,
        PR_IGNORE_BITS, 8,
        PR_UINT16, vehId,
        PR_UINT32, modelo);

        printf("WorldVehicleAdd: Modelo %d, ID %d." modelo, vehId);

        for(new i; i < 10; i++){
            if(current_models_list[i][vehicleId] == vehId){
                printf("Vehiculo ID %d es un vehículo custom \"%s\".", vehId, current_models_list[i][ModelName]);
                printf("Reescribiendo paquete...");
                BS_SetWriteOffset(bs, 8);
                BS_WriteValue(bs, PR_UINT16, vehId,
                PR_UINT32, current_models_list[i][ModelID]);
                PR_SendPacket(bs, playerid);
                return 0;
                break;
            }
        }
    }
    return 1;
}