#define ACCOUNT_PANEL_MENU  (1)

public OnInteractionMenuResponse(playerid, menuid, bool:response, menuitem){
    switch(menuid){
        case ACCOUNT_PANEL_MENU:{
            switch(menuitem){
                case 0:{
                    SendClientMessage(playerid, COLOR_DARKRED, "Cambiando de personaje.");
                    characterSave(playerid);
                    clear_chardata(playerid);
                    return dialog_personajes(playerid);
                }
                case 1:{
                    return 1;
                }
            }
        }
    }
    return 1;
}