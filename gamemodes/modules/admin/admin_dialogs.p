dialog_listaobjetos(playerid){
    yield 1;
    new dlg[3000];
    formatt(dlg, "\
    Sin uso\n\
    Comestibles\n\
    Bebidas\n\
    Accesorios\n\
    Armas blancas\n\
    Armas de fuego\n\
    Cargadores\n\
    Municiones\n\
    Cajas\n\
    Drogas individuales\n\
    Fardos de droga\n\
    Objetos con utilidades\n\
    Contenedores (pueden almacenar objetos dentro)");


    new response[DIALOG_RESPONSE];
    await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_LIST, "Selecciona la categoría", dlg, "Seleccionar", "");
    if(!response[DIALOG_RESPONSE_RESPONSE]) return true;
    
    new dlg_buff[96];
    switch(response[DIALOG_RESPONSE_LISTITEM]){
        case 0:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 0){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 1:{
            for(new i; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 1){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 2:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 2){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 3:{
            new control;
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 3){
                    formatt(dlg_buff, "%s - %d\t", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                    control++;
                    if(control == 2){
                        control = 0;
                        strcat(dlg, "\n");
                    }
                    
                }
            }
        }
        case 4:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 4){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 5:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 5){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 6:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 6){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 7:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 7){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 8:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 8){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 9:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 9){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 10:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 10){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 11:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 11){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
        case 12:{
            for(new i = 1; i < sizeof(ObjetoInfo); i++){
                if(ObjetoInfo[i][Tipo] == 12){
                    formatt(dlg_buff, "%s - %d \n", ObjetoInfo[i][NombreObjeto], i);
                    strcat(dlg, dlg_buff);
                }
            }
        }
    }
    await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "Objetos disponibles", dlg, "Cerrar", "");
    if(!response[DIALOG_RESPONSE_RESPONSE]) return true;
    else return true;
}