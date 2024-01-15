CMD:heridas(playerid, params[]){
    new id2;
    if(sscanf(params, "u", id2)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /heridas [Nombre/ID]");
    if(!IsPlayerConnected(id2)) return SendClientMessage(playerid, COLOR_DARKRED, "ERROR: El usuario no está conectado.");
    new dlg[3000];
    new dlg_buff[134];
    new cantheridas;
    for(new i; i < MAX_WOUNDS; i++){
        if(wound_data[id2][i][wnd_ammoType]){
            cantheridas++;
            new ammo = wound_data[id2][i][wnd_ammoType];
            switch(ammo){
                case 1:{
                    formatt(dlg_buff, "Moretón en ");
                    strcat(dlg, dlg_buff);
                }
                case 2:{
                    formatt(dlg_buff, "Herida de un objeto contundente en ");
                    strcat(dlg, dlg_buff);
                }
                case 3:{
                    formatt(dlg_buff, "Corte de un objeto cortante en ");
                    strcat(dlg, dlg_buff);
                }
                case 4:{
                    formatt(dlg_buff, "Herida de 9x19mm en ");
                    strcat(dlg, dlg_buff);
                }
                case 5:{
                    formatt(dlg_buff, "Herida de .45 ACP en ");
                    strcat(dlg, dlg_buff);
                }
                case 6:{
                    formatt(dlg_buff, "Herida de .38 Special en ");
                    strcat(dlg, dlg_buff);
                }
                case 7:{
                    formatt(dlg_buff, "Herida de perdigones en ");
                    strcat(dlg, dlg_buff);
                }
                case 8:{
                    formatt(dlg_buff, "Hematoma circular en ");
                    strcat(dlg, dlg_buff);
                }
                case 9:{
                    formatt(dlg_buff, "Herida de 5.56x45mm NATO en ");
                    strcat(dlg, dlg_buff);
                }
                case 10:{
                    formatt(dlg_buff, "Herida de 7.62x39mm en ");
                    strcat(dlg, dlg_buff);
                }
                case 11:{
                    formatt(dlg_buff, "Herida de 7.62x51mm en ");
                    strcat(dlg, dlg_buff);
                }
            }
            switch(wound_data[id2][i][wnd_bodypart]){
                case 3:{
                    formatt(dlg_buff, "el torso (dió en el chaleco: %s) ", (!wound_data[id2][i][wnd_kevlarHit]) ? "No" : "Sí" );                       
                }                                                        
                case 4:{
                    formatt(dlg_buff, "la entrepierna ");  
                    strcat(dlg, dlg_buff);
                }                                                    
                case 5:{
                    formatt(dlg_buff, "el brazo izquierdo ");
                    strcat(dlg, dlg_buff);
                }                                                    
                case 6:{
                    formatt(dlg_buff, "el brazo derecho ");
                    strcat(dlg, dlg_buff);
                }                    
                case 7:{
                    formatt(dlg_buff, "la pierna izquierda ");
                    strcat(dlg, dlg_buff);
                }                    
                case 8:{
                    formatt(dlg_buff, "la pierna derecha ");
                    strcat(dlg, dlg_buff);
                }                        
                case 9:{
                    formatt(dlg_buff, "la cabeza ");
                    strcat(dlg, dlg_buff);
                }                                                        
            }
            if(wound_data[id2][i+1][wnd_ammoType]){
                formatt(dlg_buff, "dmgTaken: %f\n", wound_data[id2][i][wnd_dmgTaken]);
                strcat(dlg, dlg_buff);
            }
            else{
                formatt(dlg_buff, "dmgTaken: %f", wound_data[id2][i][wnd_dmgTaken]);
                strcat(dlg, dlg_buff);
            }
        }
    }
    if(!cantheridas) return SendClientMessage(playerid, COLOR_GREEN, "¡Este jugador no está herido!");
    formatt(dlg_buff, "Heridas de %s (%d) [%d]", GetRPName(id2), id2, cantheridas);
    Dialog_Show(playerid, Wound_Dialog, DIALOG_STYLE_LIST, dlg_buff, dlg, "Cerrar", "");
    return 1;
}