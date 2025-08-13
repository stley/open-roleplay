
CMD:me(playerid, params[]){
    new accion[128];
    if(sscanf(params, "s[128]", accion)){
        SendClientMessage(playerid, COLOR_SYSTEM, "USO: /me [accion]");
        return;
    }
    accion_player(playerid, 0, accion);
    return;
}
CMD:do(playerid, params[]){
    new accion[128];
    if(sscanf(params, "s[128]", accion)){
        SendClientMessage(playerid, COLOR_SYSTEM, "USO: /do [texto]");
        return;
    }
    accion_player(playerid, 2, accion);
    return;
}
CMD:ame(playerid, params[]){
    new accion[64];
    if(sscanf(params, "s[64]", accion)){
        SendClientMessage(playerid, COLOR_SYSTEM, "USO: /ame [accion corta]");
        return;
    }
    accion_player(playerid, 1, accion);
}
CMD:sus(playerid, params[]){
    new accion[128];
    if(sscanf(params, "s[128]", accion)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /sus [Susurro]");
    new sentence[160];
    formatt(sentence, "%s susurra: %s", Name_sin(GetRPName(playerid)), accion);
    if(IsPlayerInAnyVehicle(playerid)){
        new vid = GetPlayerVehicleID(playerid);
        for(new i; i < MAX_PLAYERS; i++){
            if(IsPlayerInVehicle(i, vid)){
                SendClientMessage(playerid, C_FADE1, sentence);
                continue;
            }
        }
        ProxDetector(1.0, playerid, sentence, C_FADE1, C_FADE2, C_FADE3, C_FADE4, C_FADE5);
    }
    else ProxDetector(3.0, playerid, sentence, C_FADE1, C_FADE2, C_FADE3, C_FADE4, C_FADE5);
    return 1;    
}