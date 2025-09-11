public OnOutgoingRPC(playerid, rpcid, BitStream:bs){
    if(rpcid == 164){
        new vehID, modelo;
        //new BitStream:bs_cpy = BS_NewCopy(bs);
        //WorldVehicleAdd main parameters: UINT16 wVehicleID, UINT32 ModelID
        BS_ReadValue(bs,
            PR_UINT16, vehID,
            PR_UINT32, modelo);
        printf("RPC Saliente WorldVehicleAdd (VEHICLEID %d | MODELID %d)", vehID, modelo);
        for(new i; i < MAX_CURRENT_MODELS; i++){
            if(allocated_models[i][alloc_vID] == vehID){
                printf("[RPC-hook] El vehículo ID %d es un modelo custom \"%s\" ID REAL %d\nModificando paquete...", vehID, allocated_models[i][fxtname], allocated_models[i][realModel]);
                //BS_WriteUint16(bs, vehID);
                BS_SetWriteOffset(bs, 16);
                BS_WriteValue(bs,
                PR_UINT32, allocated_models[i][realModel]);
                BS_SetReadOffset(bs, 0);
                BS_ReadValue(bs,
                    PR_UINT16, vehID,
                    PR_UINT32, modelo);
                printf("RPC modificado saliendo: WorldVehicleAdd (VEHICLEID %d | MODELID %d)", vehID, modelo);
                //PR_SendRPC(bs_cpy, playerid, 164);
                return 1;
            }
        }
    }
    return 1;
}