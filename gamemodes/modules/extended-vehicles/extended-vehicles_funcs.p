//native CreateVehicle(modelid, Float:spawnX, Float:spawnY, Float:spawnZ, Float:angle, colour1, colour2, respawnDelay, bool:addSiren = false);


spawnCustomVehicle(modelocustom, Float:spawnX, Float:spawnY, Float:spawnZ, Float:angle, colour1, colour2, respawnDelay, bool:addSiren = false){
    for(new x; x < sizeof(custom_vehicles); x++){
        if(modelocustom == custom_vehicles[x][modelID]){
            for(new i; i < 10; i++){
                current_models_list[i][CurrentID] = CreateVehicle(custom_vehicles[x][modelBackEnd], spawnX, spawnY, spawnZ, angle, colour1, colour2, respawnDelay, addSiren);
                alm(current_models_list[i][ModelName], custom_vehicles[x][modelName]);
                current_models_list[i][ModelID] = custom_vehicles[x][modelID];
                break;
            }
            return 1;
        }
    }
    return 1;
}
/*WorldVehicleAdd - ID: 164
Parameters: UINT16 wVehicleID, UINT32 ModelID, 
float X, 
float Y, 
float Z, 
float Angle, 
UINT8 InteriorColor1, 
UINT8 InteriorColor2, 
float Health, 
UINT8 interior, 
UINT32 DoorDamageStatus, 
UINT32 PanelDamageStatus, 
UINT8 LightDamageStatus, 
UINT8 tireDamageStatus, 
UINT8 addSiren, 
UINT8 modslot0, 
UINT8 modslot1, 
UINT8 modslot2, 
UINT8 modslot3, 
UINT8 modslot4, 
UINT8 modslot5, 
UINT8 modslot6, 
UINT8 modslot7, 
UINT8 modslot8, 
UINT8 modslot9, 
UINT8 modslot10, 
UINT8 modslot11, 
UINT8 modslot12, 
UINT8 modslot13, 
UINT8 PaintJob, 
UINT32 BodyColor1, 
UINT32 BodyColor2
*/
const RPC_WVA = 164;
const RPC_InitGame = 139;
public OnOutgoingRPC(playerid, rpcid, BitStream:bs){
    if(rpcid == RPC_WVA){
        new BitStream:bs_cpy = BS_NewCopy(bs);
        new rpc_model, rpc_vID;
        
        BS_ReadValue(bs,
        PR_UINT16, rpc_vID,
        PR_UINT32, rpc_model);

        printf("WorldVehicleAdd: Modelo %d, ID %d.", rpc_model, rpc_vID);

        for(new i; i < 10; i++){
            if(current_models_list[i][CurrentID] == rpc_vID){
                printf("Vehiculo ID %d es un vehículo custom \"%s\".", rpc_vID, current_models_list[i][ModelName]);
                printf("Reescribiendo paquete...");
                BS_SetWriteOffset(bs_cpy, 16);
                BS_WriteUint32(bs_cpy, current_models_list[i][ModelID]);
                PR_SendRPC(bs_cpy, playerid, RPC_WVA);
                BS_Delete(bs_cpy);
                BS_Delete(bs);
                return 0;
            }
        }
    }
    if(rpcid == RPC_InitGame){
        new BitStream:bs_cpy = BS_NewCopy(bs);
    }
    return 1;
}