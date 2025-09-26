characterInventoryDialog(playerid){
    yield 1;
    new inv_dlg[2500];
    new inv_buffer[96];
    new manoder = Datos[playerid][jMano][0];
    new manoizq = Datos[playerid][jMano][1];
    new manodercant = Datos[playerid][jManoCant][0];
    new manoizqcant = Datos[playerid][jManoCant][1];
    new manoderdata = Datos[playerid][jManoData][0];
    new manoizqdata = Datos[playerid][jManoData][1];
    for(new i; i<5; i++)
    {
    
        if(Datos[playerid][jBolsillo][i])
        {
            new bolsillo = Datos[playerid][jBolsillo][i];
            new bolcant = Datos[playerid][jBolsilloCant][i];
            new boldata = Datos[playerid][jBolsilloData][i];
            if(ObjetoInfo[bolsillo][Tipo] == 5) formatt(inv_buffer, "[%d] %s (%d/%d)\t(%d)\n", i, ObjetoInfo[bolsillo][NombreObjeto], bolcant, ObjetoInfo[bolsillo][Capacidad], boldata);
            
            else formatt(inv_buffer, "[%d] %s [%d]\t(%d)\n", i, ObjetoInfo[bolsillo][NombreObjeto], bolcant, boldata);
            
        }
        else formatt(inv_buffer, "[%d] Vacío\n", i);
        strcat(inv_dlg, inv_buffer);
    }
    strcat(inv_dlg, "---\n");
    if(manoder)
    {
        if(ObjetoInfo[manoder][Tipo] == 5) formatt(inv_buffer, "Mano derecha: %s (%d/%d)\t(%d)\n", ObjetoInfo[manoder][NombreObjeto], manodercant, ObjetoInfo[manoder][Capacidad], manoderdata);
        else formatt(inv_buffer, "Mano derecha: %s [%d]\t(%d)\n", ObjetoInfo[manoder][NombreObjeto], manodercant, manoderdata);
        strcat(inv_dlg, inv_buffer);
    }
    else strcat(inv_dlg, "Mano derecha: Nada\n");
    if(manoizq)
    {
        if(ObjetoInfo[manoizq][Tipo] == 5) formatt(inv_buffer, "Mano izquierda: %s (%d/%d)\t(%d)", ObjetoInfo[manoizq][NombreObjeto], manoizqcant, ObjetoInfo[manoizq][Capacidad], manoizqdata);
        else formatt(inv_buffer, "Mano izquierda: %s [%d]\t(%d)", ObjetoInfo[manoizq][NombreObjeto], manoizqcant, manoizqdata);
        strcat(inv_dlg, inv_buffer);
    }
    else strcat(inv_dlg, "Mano izquierda: Nada");
    
    new response[DIALOG_RESPONSE];
    await_arr(response) ShowAsyncDialog(playerid, DIALOG_STYLE_LIST, "Tu inventario", inv_dlg, "Seleccionar", "Cerrar"); 

    //dialog response
    if(!response[DIALOG_RESPONSE_RESPONSE]) return false;
    if(response[DIALOG_RESPONSE_LISTITEM] < 5){
        sacar_bol(playerid, response[DIALOG_RESPONSE_LISTITEM]);
        return 1;
    }
    else if(response[DIALOG_RESPONSE_LISTITEM] > 5){
        guardar_bol(playerid, (response[DIALOG_RESPONSE_LISTITEM] < 7) ? 0 : 1);
        return 1;
    }
    else{
        PC_EmulateCommand(playerid, "/bol");
        return 1;
    }
}