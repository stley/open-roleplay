dialog_heridas(playerid, target){
    yield 1;
    new dialog[5000];
    new dialog_buff[256];
    new total_wounds;
    for(new i; i < MAX_WOUNDS; i++){
        if(wound_data[target][i][wnd_ammoType]){
            total_wounds++;
            formatt(dialog_buff, "Una herida de ");
            strcat(dialog, dialog_buff);
            switch(wound_data[target][i][wnd_ammoType]){
                case 1: formatt(dialog_buff, "moretón en");
                case 2: formatt(dialog_buff, "arma cortante en");
                case 3: formatt(dialog_buff, "hematoma en");
                case 4: formatt(dialog_buff, "bala 9x19mm en");
                case 5: formatt(dialog_buff, "bala .38 Special en");
                case 6: formatt(dialog_buff, "bala .45 ACP en");
                case 7: formatt(dialog_buff, "perdigones del 12 en");
                case 8: formatt(dialog_buff, "bala 7.62x51 en");
                case 9: formatt(dialog_buff, "bala 5.56x45 en");
                case 10: formatt(dialog_buff, "bala 7.62x39 en");
            }
            strcat(dialog, dialog_buff);
            switch(wound_data[target][i][wnd_bodypart]){
                case 3: formatt(dialog_buff, " el torso");
                case 4: formatt(dialog_buff, " la entrepierna");
                case 5: formatt(dialog_buff, " el brazo izquierdo");
                case 6: formatt(dialog_buff, " el brazo derecho");
                case 7: formatt(dialog_buff, " la pierna izquierda");
                case 8: formatt(dialog_buff, " la pierna derecha");
                case 9: formatt(dialog_buff, " la cabeza");
            }
            strcat(dialog, dialog_buff);
            formatt(dialog_buff, " (dmg: %f)", wound_data[target][i][wnd_dmgTaken]);
            strcat(dialog, dialog_buff);
            if(wound_data[target][i][wnd_bodypart] == 3){
                formatt(dialog_buff, " (kevlar: %s)", (wound_data[target][i][wnd_kevlarHit]) ? "Sí" : "No");
                strcat(dialog, dialog_buff);
            }
            strcat(dialog, "\n");
        }
    }
    if(!total_wounds) return SendClientMessage(playerid, COLOR_DARKRED, "¡Este personaje no esta herido!");
    formatt(dialog_buff, "Heridas de %s", Name_sin(GetRPName(target)));
    new response[DIALOG_RESPONSE];
    await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_LIST, dialog_buff, dialog, "Cerrar", "");
    if(!response[DIALOG_RESPONSE_RESPONSE]) return false;
    else return true;
}