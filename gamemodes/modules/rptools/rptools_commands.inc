
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