CMD:heridas(playerid, params[]){
    new id2;
    if(sscanf(params, "u", id2)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /heridas [Nombre/ID]");
    if(!IsPlayerConnected(id2)) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El usuario no está conectado.");
    new dlg[3000];
    new dlg_buff[134];
    for(new i; i < MAX_WOUNDS; i++){
        if(woundData[id2][i][wnd_ammoType]){
            formatt(dlg_buff, "%s | %s")
        }
    }
}