
CMD:bol(playerid)
{
    
    if(!IsPlayerConnected(playerid)) return 1;
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
    Dialog_Show(playerid, CharInv, DIALOG_STYLE_TABLIST, "Mis bolsillos", inv_dlg, "Seleccionar", "");
    return 1;
}



CMD:guardar(playerid)
{
    new manoder = Datos[playerid][jMano][0];
    new manoizq = Datos[playerid][jMano][1];
    if(manoder){
        guardar_bol(playerid, 0);
        return 1;
    }
    else if(manoizq){
        guardar_bol(playerid, 1);
        return 1;
    }
    else return 1;
    /*new manodercant = Datos[playerid][jManoCant][0];
    new manoizqcant = Datos[playerid][jManoCant][1];
    new manoderdata[32];
    alm(manoderdata, Datos[playerid][jManoData][0]);
    new manoizqdata[32];
    alm(manoizqdata, Datos[playerid][jManoData][1]);
    if(manoder)
    {
        return guardar_bol(playerid, 0);
        if(!ObjetoInfo[manoder][Guardable]){
            SendClientMessageToAll(COLOR_RED, "No puedes guardar este objeto ya que es demasiado grande.");
            return 1;
        } 
        for(new i; i < 5; i++)
        {
            if(!Datos[playerid][jBolsillo][i])
            {
                new msg[96];
                Datos[playerid][jBolsillo][i] = manoder;
                Datos[playerid][jBolsilloCant][i] = manodercant;
                alm(Datos[playerid][jBolsilloData][i], manoderdata);
                formatt(msg, "Guardas tu %s en tus bolsillos. (slot: %d)", ObjetoInfo[manoder][NombreObjeto], i);
                Datos[playerid][jMano][0] = 0;
                Datos[playerid][jManoCant][0] = 0;
                alm(Datos[playerid][jManoData][0], "-");
                SendClientMessage(playerid, COLOR_DARKGREEN, msg);
                update_manos(playerid);
                return 1;
            }
        }
        SendClientMessage(playerid, COLOR_DARKRED, "No tienes espacio en tus bolsillos.");
        return 1;
    }
    else if(manoizq)
    {
        return guardar_bol(playerid, 1);
        if(!ObjetoInfo[manoizq][Guardable]){
            SendClientMessageToAll(COLOR_RED, "No puedes guardar este objeto ya que es demasiado grande.");
            return 1;
        }
        for(new i; i < 5; i++)
        {
            if(!Datos[playerid][jBolsillo][i])
            {
                new msg[96];
                Datos[playerid][jBolsillo][i] = manoizq;
                Datos[playerid][jBolsilloCant][i] = manoizqcant;
                alm(Datos[playerid][jBolsilloData][i], manoizqdata);
                formatt(msg, "Guardas tu %s en tus bolsillos. (slot: %d)", ObjetoInfo[manoizq][NombreObjeto], i);
                Datos[playerid][jMano][1] = 0;
                Datos[playerid][jManoCant][1] = 0;
                alm(Datos[playerid][jManoData][1], "-");
                SendClientMessage(playerid, COLOR_DARKGREEN, msg);
                update_manos(playerid);
                return 1;
            }
        }
        SendClientMessage(playerid, COLOR_DARKRED, "No tienes espacio en tus bolsillos.");
        return 1;
    }
    else{
        SendClientMessage(playerid, COLOR_DARKRED, "Tus manos estan vacías.");
        return 1;
    }*/
}
CMD:guardari(playerid)
{
    new manoizq = Datos[playerid][jMano][1];
    if(manoizq){
        guardar_bol(playerid, 1);
        return 1;
    }
    return 1;
    /*{
        new manoizqcant = Datos[playerid][jManoCant][1];
        new manoizqdata[32];
        alm(manoizqdata, Datos[playerid][jManoData][1]);
        if(!ObjetoInfo[manoizq][Guardable]){
            SendClientMessageToAll(COLOR_RED, "No puedes guardar este objeto ya que es demasiado grande.");
            return 1;
        } 
        for(new i; i < 5; i++)
        {
            if(!Datos[playerid][jBolsillo][i])
            {
                new msg[96];
                Datos[playerid][jBolsillo][i] = manoizq;
                Datos[playerid][jBolsilloCant][i] = manoizqcant;
                alm(Datos[playerid][jBolsilloData][i], manoizqdata);
                formatt(msg, "Guardas tu %s en tus bolsillos. (slot: %d)", ObjetoInfo[manoizq][NombreObjeto], i);
                Datos[playerid][jMano][1] = 0;
                Datos[playerid][jManoCant][1] = 0;
                alm(Datos[playerid][jManoData][1], "-");
                SendClientMessage(playerid, COLOR_DARKGREEN, msg);
                update_manos(playerid);
                return 1;
            }
        }
        SendClientMessage(playerid, COLOR_DARKRED, "No tienes espacio en tus bolsillos.");
        return 1;
    }
    else{
        SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en tu mano izquierda.");
    }
    return 1;*/
}
CMD:sacar(playerid, params[])
{
    if(isnull(params)){
        SendClientMessage(playerid, COLOR_DARKRED, "/sacar [slot de tu bolsillo]");
        return 1;
    }
    else if(IsNumeric(params))
    {
        if(strval(params) >= 5){
            SendClientMessage(playerid, COLOR_DARKRED, "/sacar [slot de tu bolsillo]");
            return 1;
        }
        sacar_bol(playerid, strval(params));
    }
    return 1;
}
CMD:mano(playerid)
{
    new manoder = Datos[playerid][jMano][0];
    new manoizq = Datos[playerid][jMano][1];
    new manoderCant = Datos[playerid][jManoCant][0];
    new manoizqCant = Datos[playerid][jManoCant][1];
    new manoderData = Datos[playerid][jManoData][0];
    new manoizqData = Datos[playerid][jManoData][1];
    if(manoder)
    {
        if(manoizq)
        {
            Datos[playerid][jMano][0] = manoizq;
            Datos[playerid][jMano][1] = manoder;
            Datos[playerid][jManoCant][0] = manoizqCant;
            Datos[playerid][jManoCant][1] = manoderCant;
            Datos[playerid][jManoData][0] = manoizqData;
            Datos[playerid][jManoData][1] = manoderData;
            
        }
        else
        {
            Datos[playerid][jMano][0] = 0;
            Datos[playerid][jManoCant][0] = 0;
            Datos[playerid][jManoData][0] = 0;
            Datos[playerid][jMano][1] = manoder;
            Datos[playerid][jManoCant][1] = manoderCant;
            Datos[playerid][jManoData][1] = manoderData;
        }
        update_manos(playerid);
    }
    else if(manoizq)
    {
        Datos[playerid][jMano][0] = manoizq;
        Datos[playerid][jMano][1] = 0;
        Datos[playerid][jManoCant][0] = manoizqCant;
        Datos[playerid][jManoCant][1] = 0;
        Datos[playerid][jManoData][0] = manoizqData;
        Datos[playerid][jManoData][1] = 0;
        update_manos(playerid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_DARKGREEN, "Tus manos estan vacías.");
    }
    return 1;
}
CMD:comer(playerid){
    new manoder = Datos[playerid][jMano][0];
    if(!manoder){
        Datos[playerid][jManoCant][0] = 0;
        return SendClientMessage(playerid, COLOR_DARKRED, "¡Tu mano derecha esta vacía!");
    }
    if(ObjetoInfo[manoder][Tipo] != 1) return SendClientMessage(playerid, COLOR_DARKRED, "¡No puedes comer esto!");
    SendClientMessage(playerid, COLOR_DARKGREEN, "Consumes tu(s) %s.", ObjetoInfo[manoder][NombreObjeto]);
    new act[96];
    formatt(act, "consume su(s) %s.", ObjetoInfo[manoder][NombreObjeto]);
    accion_player(playerid, 1, act);
    Datos[playerid][jManoCant][0]--;
    if(!Datos[playerid][jManoCant][0]) Datos[playerid][jMano][0] = 0;
    update_manos(playerid);

    return 1;
}
CMD:beber(playerid){
    new manoder = Datos[playerid][jMano][0];
    if(!manoder){
        Datos[playerid][jManoCant][0] = 0;
        return SendClientMessage(playerid, COLOR_DARKRED, "¡Tu mano derecha esta vacía!");
    }
    if(ObjetoInfo[manoder][Tipo] != 2) return SendClientMessage(playerid, COLOR_DARKRED, "¡No puedes beber esto!");
    SendClientMessage(playerid, COLOR_DARKGREEN, "Consumes tu(s) %s.", ObjetoInfo[manoder][NombreObjeto]);
    new act[96];
    formatt(act, "bebe de su %s.", ObjetoInfo[manoder][NombreObjeto]);
    accion_player(playerid, 1, act);
    Datos[playerid][jManoCant][0]--;
    if(!Datos[playerid][jManoCant][0]) Datos[playerid][jMano][0] = 0;
    update_manos(playerid);

    return 1;
}
CMD:usar(playerid){
    new 
        manoder = Datos[playerid][jMano][0];/*,
        manocant = Datos[playerid][jManoCant][0],
        manodata = Datos[playerid][jManoData][0]
    ;*/
    if(!manoder){
        SendClientMessage(playerid, COLOR_DARKRED, "Tu mano derecha está vacía.");
        return 1; 
    }
    switch(ObjetoInfo[manoder][Tipo])
    {
        case 1:{ //Si es comida
            SendClientMessage(playerid, COLOR_DARKGREEN, "Consumes tu(s) %s.", ObjetoInfo[manoder][NombreObjeto]);
            new act[96];
            formatt(act, "consume su(s) %s.", ObjetoInfo[manoder][NombreObjeto]);
            accion_player(playerid, 1, act);
            Datos[playerid][jManoCant][0]--;
            if(!Datos[playerid][jManoCant]) Datos[playerid][jMano][0] = 0;
            update_manos(playerid);
            return 1; 
        }
        case 2:{ //Si es una bebida
            SendClientMessage(playerid, COLOR_DARKGREEN, "Bebes de tu %s.", ObjetoInfo[manoder][NombreObjeto]);
            new act[96];
            formatt(act, "bebe de su %s.", ObjetoInfo[manoder][NombreObjeto]);
            accion_player(playerid, 1, act);
            Datos[playerid][jManoCant][0]--;
            if(!Datos[playerid][jManoCant]) Datos[playerid][jMano][0] = 0;
            update_manos(playerid);
            return 1;
        }
        case 3:{ //si es un accesorios
            new data[2]; // 0 - Index | 1 - Bone
            GetToyIndex(manoder, data[0], data[1]);
            if(!data[0] || !data[1]) return 1;
            if(IsPlayerAttachedObjectSlotUsed(playerid, data[0])){
                SendClientMessage(playerid, COLOR_DARKRED, "Ya tienes un objeto en ese slot, quitate ese objeto y vuelve a intentarlo.");
                return 1;
            }
            switch(data[0]){
                case 4:{
                    //Gorro
                    if(CharToys[playerid][GorroPos][0] != 0.0){
                        CharToys[playerid][jToy_Gorro] = manoder;
                        SetPlayerAttachedObject(playerid, data[0], ObjetoInfo[manoder][ModeloObjeto], data[1], CharToys[playerid][GorroPos][0], CharToys[playerid][GorroPos][1], CharToys[playerid][GorroPos][2], CharToys[playerid][GorroRot][0], CharToys[playerid][GorroRot][1], CharToys[playerid][GorroRot][2], CharToys[playerid][GorroScale][0], CharToys[playerid][GorroScale][1], CharToys[playerid][GorroScale][2]);
                        SendClientMessage(playerid, COLOR_DARKGREEN, "Te colocaste tu %s. Utiliza /editaracc para modificar su posición.", ObjetoInfo[manoder][NombreObjeto]);
                        Datos[playerid][jMano][0] = 0;
                        Datos[playerid][jManoCant] = 0;
                        Datos[playerid][jManoData] = 0;
                        update_manos(playerid);
                        return 1;
                    }
                }
                case 5:{
                    //Gafas
                    if(CharToys[playerid][GafasPos][0] != 0.0){
                        CharToys[playerid][jToy_Gafas] = manoder;
                        SetPlayerAttachedObject(playerid, data[0], ObjetoInfo[manoder][ModeloObjeto], data[1], CharToys[playerid][GafasPos][0], CharToys[playerid][GafasPos][1], CharToys[playerid][GafasPos][2], CharToys[playerid][GafasRot][0], CharToys[playerid][GafasRot][1], CharToys[playerid][GafasRot][2], CharToys[playerid][GafasScale][0], CharToys[playerid][GafasScale][1], CharToys[playerid][GafasScale][2]);
                        SendClientMessage(playerid, COLOR_DARKGREEN, "Te colocaste tu %s. Utiliza /editaracc para modificar su posición.", ObjetoInfo[manoder][NombreObjeto]);
                        Datos[playerid][jMano][0] = 0;
                        Datos[playerid][jManoCant] = 0;
                        Datos[playerid][jManoData] = 0;
                        update_manos(playerid);
                        return 1;
                    }
                }
                case 6:{
                    //Boca
                    if(CharToys[playerid][BocaPos][0] != 0.0){
                        CharToys[playerid][jToy_Boca] = manoder;
                        SetPlayerAttachedObject(playerid, data[0], ObjetoInfo[manoder][ModeloObjeto], data[1], CharToys[playerid][BocaPos][0], CharToys[playerid][BocaPos][1], CharToys[playerid][BocaPos][2], CharToys[playerid][BocaRot][0], CharToys[playerid][BocaRot][1], CharToys[playerid][BocaRot][2], CharToys[playerid][BocaScale][0], CharToys[playerid][BocaScale][1], CharToys[playerid][BocaScale][2]);
                        SendClientMessage(playerid, COLOR_DARKGREEN, "Te colocaste tu %s. Utiliza /editaracc para modificar su posición.", ObjetoInfo[manoder][NombreObjeto]);
                        Datos[playerid][jMano][0] = 0;
                        Datos[playerid][jManoCant] = 0;
                        Datos[playerid][jManoData] = 0;
                        update_manos(playerid);
                        return 1;
                    }
                }
                case 7:{
                    //Pecho
                    if(CharToys[playerid][PechoPos][0] != 0.0){
                        CharToys[playerid][jToy_Pecho] = manoder;
                        SetPlayerAttachedObject(playerid, data[0], ObjetoInfo[manoder][ModeloObjeto], data[1], CharToys[playerid][PechoPos][0], CharToys[playerid][PechoPos][1], CharToys[playerid][PechoPos][2], CharToys[playerid][PechoRot][0], CharToys[playerid][PechoRot][1], CharToys[playerid][PechoRot][2], CharToys[playerid][PechoScale][0], CharToys[playerid][PechoScale][1], CharToys[playerid][PechoScale][2]);
                        SendClientMessage(playerid, COLOR_DARKGREEN, "Te colocaste tu %s. Utiliza /editaracc para modificar su posición.", ObjetoInfo[manoder][NombreObjeto]);
                        Datos[playerid][jMano][0] = 0;
                        Datos[playerid][jManoCant] = 0;
                        Datos[playerid][jManoData] = 0;
                        update_manos(playerid);
                        return 1;
                    }
                }
            }
            SetPlayerAttachedObject(playerid, data[0], ObjetoInfo[manoder][ModeloObjeto], data[1]);
            EditAttachedObject(playerid, data[0]);
            EditType[playerid] = 1;
            Datos[playerid][jMano][0] = 0;
            Datos[playerid][jManoCant][0] = 0;
            Datos[playerid][jManoData][0] = 0;
            update_manos(playerid);
            SendClientMessage(playerid, COLOR_SYSTEM, "Te colocaste tu %s, mantén ESPACIO para mover la cámara y utiliza el mouse para ajustar la posición del objeto.", ObjetoInfo[manoder][NombreObjeto]);
        } 
    }
    return 1;
}
CMD:editaracc(playerid, params[]){
    if(isnull(params)){
        SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /quitar [gafas | pecho | gorro | boca]");
        return 1;
    }
    if(sscanf(params, "s[9]", params)){
        SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /quitar [gafas | pecho | gorro | boca]");
        return 1;
    }
    if(!strcmp(params, "gorro", true)){
        new gorro = CharToys[playerid][jToy_Gorro];
        if(!gorro){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        EditType[playerid] = 2;
        EditAttachedObject(playerid, 4);
    }
    else if(!strcmp(params, "gafas", true)){
        new gafas = CharToys[playerid][jToy_Gafas];
        if(!gafas){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        EditType[playerid] = 2;
        EditAttachedObject(playerid, 5);
    }
    else if(!strcmp(params, "boca", true)){
        new Boca = CharToys[playerid][jToy_Boca];
        if(!Boca){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        EditType[playerid] = 2;
        EditAttachedObject(playerid, 6);
    }
    else if(!strcmp(params, "pecho", true)){
        new Pecho = CharToys[playerid][jToy_Pecho];
        if(!Pecho){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        EditType[playerid] = 2;
        EditAttachedObject(playerid, 7);
    }
    return 1;
}
CMD:quitar(playerid, params[])
{
    if(isnull(params)){
        SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /quitar [gafas | pecho | gorro | boca]");
        return 1;
    }
    if(sscanf(params, "s[9]", params)){
        SendClientMessage(playerid, COLOR_SYSTEM, "Uso: /quitar [gafas | pecho | gorro | boca]");
        return 1;
    }
    if(!strcmp(params, "gorro", true)){
        new gorro = CharToys[playerid][jToy_Gorro];
        if(!gorro){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]){
                for(new i; i < 5; i++){
                    if(!Datos[playerid][jBolsillo][i]){
                        Datos[playerid][jBolsillo][i] = gorro;
                        Datos[playerid][jBolsilloCant][i] = 1;
                        Datos[playerid][jBolsilloData][i] = 0;
                        CharToys[playerid][jToy_Gorro] = 0;
                        SendClientMessage(playerid, COLOR_SYSTEM, "Te quitaste tu %s para guardarlo en tus bolsillos (slot %d).", ObjetoInfo[gorro][NombreObjeto], i);
                        RemovePlayerAttachedObject(playerid, 4);
                        return 1;
                    }    
                }
                SendClientMessage(playerid, COLOR_SYSTEM, "Tienes ambas manos ocupadas, además de tus bolsillos llenos, ¿qué hacemos con eso?");
                return 1;
            }
            Datos[playerid][jMano][1] = gorro;
            Datos[playerid][jManoCant][1] = 1;
            Datos[playerid][jManoData][1] = 0;
            CharToys[playerid][jToy_Gorro] = 0;
            update_manos(playerid);
            SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano izquierda.", ObjetoInfo[gorro][NombreObjeto]);
            RemovePlayerAttachedObject(playerid, 4);
            return 1;
        }
        Datos[playerid][jMano][0] = gorro;
        Datos[playerid][jManoCant][0] = 1;
        Datos[playerid][jManoData][0] = 0;
        CharToys[playerid][jToy_Gorro] = 0;
        update_manos(playerid);
        SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano derecha.", ObjetoInfo[gorro][NombreObjeto]);
        RemovePlayerAttachedObject(playerid, 4);  
        return 1;
    }
    else if(!strcmp(params, "gafas", true)){
        new gafas = CharToys[playerid][jToy_Gafas];
        if(!gafas){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]){
                for(new i; i < 5; i++){
                    if(!Datos[playerid][jBolsillo][i]){
                        Datos[playerid][jBolsillo][i] = gafas;
                        Datos[playerid][jBolsilloCant][i] = 1;
                        Datos[playerid][jBolsilloData][i] = 0;
                        CharToys[playerid][jToy_Gafas] = 0;
                        SendClientMessage(playerid, COLOR_SYSTEM, "Te quitaste tu %s para guardarlo en tus bolsillos (slot %d).", ObjetoInfo[gafas][NombreObjeto], i);
                        RemovePlayerAttachedObject(playerid, 5);
                        return 1;
                    }    
                }
                SendClientMessage(playerid, COLOR_SYSTEM, "Tienes ambas manos ocupadas, además de tus bolsillos llenos, ¿qué hacemos con eso?");
                return 1;
            }
            Datos[playerid][jMano][1] = gafas;
            Datos[playerid][jManoCant][1] = 1;
            Datos[playerid][jManoData][1] = 0;
            CharToys[playerid][jToy_Gafas] = 0;
            update_manos(playerid);
            SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano izquierda.", ObjetoInfo[gafas][NombreObjeto]);
            RemovePlayerAttachedObject(playerid, 5);
            return 1;
        }
        Datos[playerid][jMano][0] = gafas;
        Datos[playerid][jManoCant][0] = 1;
        Datos[playerid][jManoData][0] = 0;
        CharToys[playerid][jToy_Gafas] = 0;
        update_manos(playerid);
        SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano derecha.", ObjetoInfo[gafas][NombreObjeto]);
        RemovePlayerAttachedObject(playerid, 5);  
        return 1;
    }
    else if(!strcmp(params, "boca", true)){
        new Boca = CharToys[playerid][jToy_Boca];
        if(!Boca){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]){
                for(new i; i < 5; i++){
                    if(!Datos[playerid][jBolsillo][i]){
                        Datos[playerid][jBolsillo][i] = Boca;
                        Datos[playerid][jBolsilloCant][i] = 1;
                        Datos[playerid][jBolsilloData][i] = 0;
                        CharToys[playerid][jToy_Boca] = 0;
                        SendClientMessage(playerid, COLOR_SYSTEM, "Te quitaste tu %s para guardarlo en tus bolsillos (slot %d).", ObjetoInfo[Boca][NombreObjeto], i);
                        RemovePlayerAttachedObject(playerid, 6);
                        return 1;
                    }    
                }
                SendClientMessage(playerid, COLOR_SYSTEM, "Tienes ambas manos ocupadas, además de tus bolsillos llenos, ¿qué hacemos con eso?");
                return 1;
            }
            Datos[playerid][jMano][1] = Boca;
            Datos[playerid][jManoCant][1] = 1;
            Datos[playerid][jManoData][1] = 0;
            CharToys[playerid][jToy_Boca] = 0;
            update_manos(playerid);
            SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano izquierda.", ObjetoInfo[Boca][NombreObjeto]);
            RemovePlayerAttachedObject(playerid, 6);
            return 1;
        }
        Datos[playerid][jMano][0] = Boca;
        Datos[playerid][jManoCant][0] = 1;
        Datos[playerid][jManoData][0] = 0;
        CharToys[playerid][jToy_Boca] = 0;
        update_manos(playerid);
        SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano derecha.", ObjetoInfo[Boca][NombreObjeto]);
        RemovePlayerAttachedObject(playerid, 6);  
        return 1;
    }
    else if(!strcmp(params, "pecho", true)){
        new Pecho = CharToys[playerid][jToy_Pecho];
        if(!Pecho){
            SendClientMessage(playerid, COLOR_SYSTEM, "No encontramos ningun objeto en ese slot.");
            return 1;
        }
        
        if(Datos[playerid][jMano][0]){
            if(Datos[playerid][jMano][1]){
                for(new i; i < 5; i++){
                    if(!Datos[playerid][jBolsillo][i]){
                        Datos[playerid][jBolsillo][i] = Pecho;
                        Datos[playerid][jBolsilloCant][i] = 1;
                        Datos[playerid][jBolsilloData][i] = 0;
                        CharToys[playerid][jToy_Pecho] = 0;
                        SendClientMessage(playerid, COLOR_SYSTEM, "Te quitaste tu %s para guardarlo en tus bolsillos (slot %d).", ObjetoInfo[Pecho][NombreObjeto], i);
                        RemovePlayerAttachedObject(playerid, 7);
                        return 1;
                    }    
                }
                SendClientMessage(playerid, COLOR_SYSTEM, "Tienes ambas manos ocupadas, además de tus bolsillos llenos, ¿qué hacemos con eso?");
                return 1;
            }
            Datos[playerid][jMano][1] = Pecho;
            Datos[playerid][jManoCant][1] = 1;
            Datos[playerid][jManoData][1] = 0;
            CharToys[playerid][jToy_Pecho] = 0;
            update_manos(playerid);
            SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano izquierda.", ObjetoInfo[Pecho][NombreObjeto]);
            RemovePlayerAttachedObject(playerid, 7);
            return 1;
        }
        Datos[playerid][jMano][0] = Pecho;
        Datos[playerid][jManoCant][0] = 1;
        Datos[playerid][jManoData][0] = 0;
        CharToys[playerid][jToy_Pecho] = 0;
        update_manos(playerid);
        SendClientMessage(playerid, COLOR_DARKGREEN, "Te quitaste tu %s para sostenerlo en tu mano derecha.", ObjetoInfo[Pecho][NombreObjeto]);
        RemovePlayerAttachedObject(playerid, 7);  
        return 1;
    }
    /*else if(!strcmp(params, "cuerpo", true)){

    }*/
    return 1;
}

CMD:descargar(playerid){
    new manoder = Datos[playerid][jMano][0],
        manocant = Datos[playerid][jManoCant][0]
    ;
    if(!manoder){
        SendClientMessage(playerid, COLOR_RED, "No tienes nada en tu mano derecha.");
        return 1;
    }
    else if(ObjetoInfo[manoder][Tipo] != 5){
        SendClientMessage(playerid, COLOR_RED, "No tienes un arma de fuego en tu mano derecha.");
        return 1;
    }
    else if(strfind(ObjetoInfo[manoder][NombreObjeto], "Revolver", false) != -1){
        //revolver
        if(!manocant){
            SendClientMessage(playerid, COLOR_DARKRED, "No puedes quitarle un cargador a esta arma ya que no utiliza estos.");
            return 1;
        }
        else{
            if(Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes tu otra mano ocupada.");
            Datos[playerid][jManoCant][1] = Datos[playerid][jManoCant][0];
            Datos[playerid][jManoCant][0] = 0;
            SendClientMessage(playerid, COLOR_DARKGREEN, "Le quitas la munición que quedaba a tu arma. (%d)", Datos[playerid][jManoCant][1]);
            Datos[playerid][jMano][1] = find_mag(Datos[playerid][jMano][0]);  
        }
    }
    else if(!strcmp(ObjetoInfo[manoder][NombreObjeto], "Remington 870")){
        //escopeta
        if(!manocant){
            SendClientMessage(playerid, COLOR_DARKRED, "No puedes quitarle un cargador a esta arma ya que no utiliza estos.");
            return 1;
        }
        else{
            if(Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes tu otra mano ocupada.");
            Datos[playerid][jManoCant][1] = Datos[playerid][jManoCant][0];
            Datos[playerid][jManoCant][0] = 0;
            SendClientMessage(playerid, COLOR_DARKGREEN, "Le quitas la munición que quedaba a tu arma. (%d)", Datos[playerid][jManoCant][1]);
            Datos[playerid][jMano][1] = find_mag(Datos[playerid][jMano][0]);  
        }
    }
    else if(strfind(ObjetoInfo[manoder][NombreObjeto], "Beanbag") != -1){
        //escopeta
        SendClientMessage(playerid, COLOR_DARKRED, "No puedes quitarle un cargador a esta arma ya que no utiliza estos.");
        return 1;
    }
    else if(manocant == -1){
        SendClientMessage(playerid, COLOR_RED, "Tu arma no tiene un cargador colocado.");
        return 1;
    }
    else if(Datos[playerid][jMano][1]){
        SendClientMessage(playerid, COLOR_RED, "Tu mano izquierda está ocupada.");
        return 1;
    }
    Datos[playerid][jManoCant][0] = -1;
    Datos[playerid][jMano][1] = find_mag(manoder);
    Datos[playerid][jManoCant][1] = manocant;
    SendClientMessage(playerid, COLOR_DARKGREEN, "Le quitas el cargador con %d balas a tu %s, lo sostienes en tu mano izquierda.", manocant, ObjetoInfo[manoder][NombreObjeto]);
    update_manos(playerid); 
    return 1;
}
CMD:rellenarmag(playerid){
    new manoder = Datos[playerid][jMano][0];
    new manoizq = Datos[playerid][jMano][1];
    
    if(!manoder) return 1;
    else if(!manoizq) return 1;
    if(ObjetoInfo[manoder][Tipo] != 6) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes un cargador en tu mano derecha.");
    else if(ObjetoInfo[manoizq][Tipo] != 7) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes municiones en tu mano izquierda.");
    if(manoizq != find_ammotype(manoder)) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes una munición para este cargador.");
    new balasagregadas;
    for(new i = Datos[playerid][jManoCant][0]; i < ObjetoInfo[manoder][Capacidad]; i++){
        if(Datos[playerid][jManoCant][1]){
            Datos[playerid][jManoCant][0]++;
            Datos[playerid][jManoCant][1]--;
            balasagregadas++;
        }
        else{
            Datos[playerid][jMano][1] = 0;
        }
    }
    if(balasagregadas){
        SendClientMessage(playerid, COLOR_DARKGREEN, "Agregaste %d balas a tu cargador.", balasagregadas);
    }
    update_manos(playerid);
    return 1;
}
CMD:recoger(playerid){
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT){
        SendClientMessage(playerid, COLOR_DARKRED, "Tienes que estar a pie para recoger un objeto.");
        return 1;
    }
    if(Datos[playerid][jMano][0]){
        if(Datos[playerid][jMano][1]){
            SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas.");
            return 1;
        }
        new piso;
        new pisocant;
        new pisodata;
        for(new i; i < MAX_SUELO; i++){
            if(EnSuelo[i][floor_ObjetoID]){
                if(IsPlayerInRangeOfPoint(playerid, 3.0, EnSuelo[i][floor_posX], EnSuelo[i][floor_posY], EnSuelo[i][floor_posZ]) && GetPlayerVirtualWorld(playerid) == EnSuelo[i][floor_VW]){
                    piso = EnSuelo[i][floor_ObjetoID];
                    pisocant = EnSuelo[i][floor_ObjetoCant];
                    pisodata = EnSuelo[i][floor_ObjetoData];
                    EnSuelo[i][floor_ObjetoID] = 0;
                    EnSuelo[i][floor_ObjetoCant] = 0;
                    EnSuelo[i][floor_ObjetoData] = 0;
                    EnSuelo[i][floor_posX] = 0.0;
                    EnSuelo[i][floor_posY] = 0.0;
                    EnSuelo[i][floor_posZ] = 0.0;
                    EnSuelo[i][floor_VW] = 0;
                    DestroyDynamicObject(SueloObj[i]);
                    Datos[playerid][jMano][1] = piso;
                    Datos[playerid][jManoCant][1] = pisocant;
                    Datos[playerid][jManoData][1] = pisodata;
                    alm(EnSuelo[i][floor_huella], "-");
                    new act[64];
                    formatt(act, "recoge %s del suelo.", ObjetoInfo[piso][NombreObjeto]);
                    accion_player(playerid, 1, act);
                    update_manos(playerid);
                    return 1;
                }
            }
            
        }
        SendClientMessage(playerid, COLOR_DARKRED, "No hay nada en el suelo para recoger.");
        return 1;
    }
    new piso;
    new pisocant;
    new pisodata;
    for(new i; i < MAX_SUELO; i++){
        if(EnSuelo[i][floor_ObjetoID]){
            if(IsPlayerInRangeOfPoint(playerid, 3.0, EnSuelo[i][floor_posX], EnSuelo[i][floor_posY], EnSuelo[i][floor_posZ]) && GetPlayerVirtualWorld(playerid) == EnSuelo[i][floor_VW]){
                piso = EnSuelo[i][floor_ObjetoID];
                pisocant = EnSuelo[i][floor_ObjetoCant];
                pisodata = EnSuelo[i][floor_ObjetoData];
                EnSuelo[i][floor_ObjetoID] = 0;
                EnSuelo[i][floor_ObjetoCant] = 0;
                EnSuelo[i][floor_ObjetoData] = 0;
                EnSuelo[i][floor_posX] = 0.0;
                EnSuelo[i][floor_posY] = 0.0;
                EnSuelo[i][floor_posZ] = 0.0;
                EnSuelo[i][floor_VW] = 0;
                DestroyDynamicObject(SueloObj[i]);
                Datos[playerid][jMano][0] = piso;
                Datos[playerid][jManoCant][0] = pisocant;
                Datos[playerid][jManoData][0] = pisodata;
                alm(EnSuelo[i][floor_huella], "-");
                new act[64];
                formatt(act, "recoge %s del suelo.", ObjetoInfo[piso][NombreObjeto]);
                accion_player(playerid, 1, act);
                update_manos(playerid);
                return 1;
            }
        }
    }
    SendClientMessage(playerid, COLOR_DARKRED, "No hay nada en el suelo para recoger.");
    return 1;
}
CMD:pecho(playerid){
    new mano = Datos[playerid][jMano][0];
    new cant;
    new data;
    new pecho = Datos[playerid][jPecho];
    if(pecho){
        SendClientMessage(playerid, COLOR_DARKRED, "Ya tienes un objeto en tu pecho, para quitarlo usa /qpecho.");
        return 1;
    }
    if(!mano){
        mano = Datos[playerid][jMano][1];
        if(!mano){
            SendClientMessage(playerid, COLOR_DARKRED, "Tus manos estan vacías.");
            return 1;
        }
        cant = Datos[playerid][jManoCant][1];
        data = Datos[playerid][jManoData][1];
    }
    else{
        cant = Datos[playerid][jManoCant][0];
        data = Datos[playerid][jManoData][0];
    }
    if(ObjetoInfo[mano][Tipo] != 5 && strcmp(ObjetoInfo[mano][NombreObjeto], "Mochila") != 0){
        SendClientMessage(playerid, COLOR_DARKRED, "No puedes colgarte este objeto en tu pecho.");
        SendClientMessage(playerid, COLOR_DARKRED, "Objetos que puedes colgarte: Armas de fuego - Mochilas");
        return 1;
    }
    new action[64];
    formatt(action, "coloca su %s en su pecho.", ObjetoInfo[mano][NombreObjeto]);
    accion_player(playerid, 1, action);
    SendClientMessage(playerid, COLOR_DARKGREEN, "Colocas tu %s en tu pecho.", ObjetoInfo[mano][NombreObjeto]);
    if(Datos[playerid][jMano][0] == mano){
        Datos[playerid][jMano][0] = 0;
        Datos[playerid][jManoCant][0] = 0;
        Datos[playerid][jManoData][0] = 0;
    }
    else{
        Datos[playerid][jMano][1] = 0;
        Datos[playerid][jManoCant][1] = 0;
        Datos[playerid][jManoData][1] = 0;
    }
    Datos[playerid][jPecho] = mano;
    Datos[playerid][jPechoCant] = cant;
    Datos[playerid][jPechoData] = data;
    update_manos(playerid);
    update_torso(playerid);
    return 1;
}
CMD:qpecho(playerid){
    new mano = -1;
    if(Datos[playerid][jMano][0])
    {
        if(Datos[playerid][jMano][1]){
            SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas. Guarda un objeto o tiralo al suelo.");
            return 1;
        }
        mano = 1; 
    }
    else mano = 0;
    if(!Datos[playerid][jPecho]){
        SendClientMessage(playerid, COLOR_DARKRED, "Tu pecho está vacío.");
        return 1;
    }
    new pecho = Datos[playerid][jPecho];
    Datos[playerid][jPecho] = 0;
    new cant = Datos[playerid][jPechoCant];
    Datos[playerid][jPechoCant] = 0;
    new data = Datos[playerid][jPechoData];
    Datos[playerid][jPechoData] = 0;
    Datos[playerid][jMano][mano] = pecho;
    Datos[playerid][jManoCant][mano] = cant;
    Datos[playerid][jManoData][mano] = data;
    SendClientMessage(playerid, COLOR_DARKGREEN, "Tomas tu %s de tu pecho.", ObjetoInfo[pecho][NombreObjeto]);
    new action[64];
    formatt(action, "toma su %s de su pecho.", ObjetoInfo[pecho][NombreObjeto]);
    accion_player(playerid, 1, action);
    update_manos(playerid);
    update_torso(playerid);
    return 1;
}


CMD:revisar(playerid, params[]){
    new id2;
    if(sscanf(params, "r", id2)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /revisar [Nombre/ID del jugador]");
    if(!IsPlayerConnected(id2)) return 1;
    if(id2 == playerid){
        SendClientMessage(playerid, COLOR_DARKRED, "Quisiste revisarte a ti mismo, luego recuerdas que puedes ver tus propios bolsillos.");
        PC_EmulateCommand(playerid, "/bol");
        return 1;
    }
    if(GetDistanceBetweenPlayers(playerid, id2) > 5.0) return SendClientMessage(playerid, COLOR_DARKRED, "¡Estás muy lejos del jugador!");
    if(solicitud_tipo[id2]) return SendClientMessage(playerid, COLOR_DARKRED, "El jugador ya tiene una solicitud en curso.");
    SendClientMessage(id2, COLOR_BLUE, "%s quiere revisarte. Utiliza /aceptar o /rechazar.");
    solicitud_tipo[id2] = 1;
    solicitante[id2] = playerid;
    solicitud_timer[id2] = SetTimerEx("TimeOutRequest", 8000, false, "d", id2);
    return 1;
}


CMD:espalda(playerid){
    new mano = Datos[playerid][jMano][0];
    new cant;
    new data;
    new espalda = Datos[playerid][jEspalda];
    if(espalda) return SendClientMessage(playerid, COLOR_DARKRED, "Ya tienes un objeto en tu espalda, para quitarlo usa /qespalda.");
    if(!mano){
        mano = Datos[playerid][jMano][1];
        if(!mano) return SendClientMessage(playerid, COLOR_DARKRED, "Tus manos estan vacías.");
        cant = Datos[playerid][jManoCant][1];
        data = Datos[playerid][jManoData][1];
    }
    else{
        cant = Datos[playerid][jManoCant][0];
        data = Datos[playerid][jManoData][0];
    }
    if(ObjetoInfo[mano][Tipo] != 5 && strcmp(ObjetoInfo[mano][NombreObjeto], "Mochila") != 0){
        SendClientMessage(playerid, COLOR_DARKRED, "No puedes colgarte este objeto en tu espalda.");
        SendClientMessage(playerid, COLOR_DARKRED, "Objetos que puedes colgarte: Armas de fuego - Mochilas");
        return 1;
    }
    new action[64];
    formatt(action, "coloca su %s en su espalda.", ObjetoInfo[mano][NombreObjeto]);
    accion_player(playerid, 1, action);
    SendClientMessage(playerid, COLOR_DARKGREEN, "Colocas tu %s en tu espalda.", ObjetoInfo[mano][NombreObjeto]);
    if(Datos[playerid][jMano][0] == mano){
        Datos[playerid][jMano][0] = 0;
        Datos[playerid][jManoCant][0] = 0;
        Datos[playerid][jManoData][0] = 0;
    }
    else{
        Datos[playerid][jMano][1] = 0;
        Datos[playerid][jManoCant][1] = 0;
        Datos[playerid][jManoData][1] = 0;
    }
    Datos[playerid][jEspalda] = mano;
    Datos[playerid][jEspaldaCant] = cant;
    Datos[playerid][jEspaldaData] = data;
    update_manos(playerid);
    update_torso(playerid);
    return 1;
}
CMD:qespalda(playerid){
    new mano = -1;
    if(Datos[playerid][jMano][0])
    {
        if(Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas. Guarda un objeto o tiralo al suelo.");
        mano = 1; 
    }
    else mano = 0;
    if(!Datos[playerid][jEspalda]) return SendClientMessage(playerid, COLOR_DARKRED, "Tu espalda está vacía.");
    new espalda = Datos[playerid][jEspalda];
    Datos[playerid][jEspalda] = 0;
    new cant = Datos[playerid][jEspaldaCant];
    Datos[playerid][jEspaldaCant] = 0;
    new data = Datos[playerid][jEspaldaData];
    Datos[playerid][jEspaldaData] = 0;
    Datos[playerid][jMano][mano] = espalda;
    Datos[playerid][jManoCant][mano] = cant;
    Datos[playerid][jManoData][mano] = data;
    SendClientMessage(playerid, COLOR_DARKGREEN, "Tomas tu %s de tu espalda.", ObjetoInfo[espalda][NombreObjeto]);
    new action[64];
    formatt(action, "toma su %s de su espalda.", ObjetoInfo[espalda][NombreObjeto]);
    accion_player(playerid, 1, action);
    update_manos(playerid);
    update_torso(playerid);
    return 1;
}
CMD:ceder(playerid, params[]){
    new id2;
    if(sscanf(params, "r", id2)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /ceder [playerid]");
    if(!IsPlayerConnected(id2)) return SendClientMessage(playerid, COLOR_DARKRED, "Ese jugador no esta conectado.");
    new mano = -1;
    if(!Datos[playerid][jMano][0]){
        if(!Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "¡Tienes ambas manos vacías!");
        mano = 1;
    }
    else mano = 0;
    if(GetDistanceBetweenPlayers(playerid, id2) > 5.0){
        SendClientMessage(playerid, COLOR_DARKRED, "¡Estás muy lejos del jugador!");
        return 1;
    }
    if(Datos[id2][jMano][0]){
        if(Datos[id2][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "El jugador tiene ambas manos ocupadas.");
        Datos[id2][jMano][1] = Datos[playerid][jMano][mano];
        Datos[id2][jManoCant][1] = Datos[playerid][jManoCant][mano];
        Datos[id2][jManoData][1] = Datos[playerid][jManoData][mano];
        SendClientMessage(playerid, COLOR_DARKGREEN, "Le entregas un %s a %s.", ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto], GetRPName(id2));
        SendClientMessage(id2, COLOR_DARKGREEN, "%s te entregó un %s.", GetRPName(playerid), ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto]);
        Datos[playerid][jMano][mano] = 0;
        Datos[playerid][jManoCant][mano] = 0;
        Datos[playerid][jManoData][mano] = 0;
        update_manos(playerid);
        update_manos(id2);
        return 1;
    }
    Datos[id2][jMano][0] = Datos[playerid][jMano][mano];
    Datos[id2][jManoCant][0] = Datos[playerid][jManoCant][mano];
    Datos[id2][jManoData][0] = Datos[playerid][jManoData][mano];
    SendClientMessage(playerid, COLOR_DARKGREEN, "Le entregas un %s a %s.", ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto], GetRPName(id2));
    SendClientMessage(id2, COLOR_DARKGREEN, "%s te entregó un %s.", GetRPName(playerid), ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto]);
    Datos[playerid][jMano][mano] = 0;
    Datos[playerid][jManoCant][mano] = 0;
    Datos[playerid][jManoData][mano] = 0;
    update_manos(playerid);
    update_manos(id2);
    saveCharacterInventory(playerid);
    saveCharacterInventory(id2);
    return 1;
}
CMD:cederizq(playerid, params[]){
    new id2;
    if(sscanf(params, "r", id2)) return SendClientMessage(playerid, COLOR_SYSTEM, "USO: /ceder [playerid]");
    if(!IsPlayerConnected(id2)) return SendClientMessage(playerid, COLOR_DARKRED, "Ese jugador no esta conectado.");
    if(!Datos[playerid][jMano][1]) return SendClientMessage(playerid, COLOR_DARKRED, "Tu mano izquierda esta vacía.");
    new mano = 1;
    Datos[id2][jMano][1] = Datos[playerid][jMano][mano];
    Datos[id2][jManoCant][1] = Datos[playerid][jManoCant][mano];
    Datos[id2][jManoData][1] = Datos[playerid][jManoData][mano];
    SendClientMessage(playerid, COLOR_DARKGREEN, "Le entregas un %s a %s.", ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto], GetRPName(id2));
    SendClientMessage(id2, COLOR_DARKGREEN, "%s te entregó un %s.", GetRPName(playerid), ObjetoInfo[Datos[playerid][jMano][mano]][NombreObjeto]);
    Datos[playerid][jMano][mano] = 0;
    Datos[playerid][jManoCant][mano] = 0;
    Datos[playerid][jManoData][mano] = 0;
    update_manos(playerid);
    update_manos(id2);
    saveCharacterInventory(playerid);
    saveCharacterInventory(id2);
    return 1;
}
CMD:tirar(playerid){
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes que estar a pie para tirar un objeto.");
    new
        manoder = Datos[playerid][jMano][0],
        manocant,
        manodata
    ;
    if(!manoder){
        new manoizq = Datos[playerid][jMano][1];  
        if(!manoizq) return SendClientMessage(playerid, COLOR_DARKRED, "¡Tienes ambas manos vacías!");
        manocant = Datos[playerid][jManoCant][1];
        manodata = Datos[playerid][jManoData][1];
        for(new i; i < MAX_SUELO; i++){
            if(!EnSuelo[i][floor_ObjetoID]){
                Datos[playerid][jMano][1] = 0;
                Datos[playerid][jManoCant][1] = 0;
                Datos[playerid][jManoData][1] = 0;
                EnSuelo[i][floor_ObjetoID] = manoizq;
                EnSuelo[i][floor_ObjetoCant] = manocant;
                EnSuelo[i][floor_ObjetoData] = manodata;
                GetPlayerPos(playerid, EnSuelo[i][floor_posX], EnSuelo[i][floor_posY], EnSuelo[i][floor_posZ]);
                alm(EnSuelo[i][floor_huella], GetRPName(playerid));
                new accion[64];
                formatt(accion, "tira su %s al suelo.", ObjetoInfo[manoizq][NombreObjeto]);
                accion_player(playerid, 1, accion);
                update_manos(playerid);
                tirar_objeto(i);
                return 1;
            }
        }
    }
    manocant = Datos[playerid][jManoCant][0];
    manodata = Datos[playerid][jManoData][0];
    for(new i; i < MAX_SUELO; i++){
        if(!EnSuelo[i][floor_ObjetoID]){
            Datos[playerid][jMano][0] = 0;
            Datos[playerid][jManoCant][0] = 0;
            Datos[playerid][jManoData][0] = 0;
            EnSuelo[i][floor_ObjetoID] = manoder;
            EnSuelo[i][floor_ObjetoCant] = manocant;
            EnSuelo[i][floor_ObjetoData] = manodata;
            GetPlayerPos(playerid, EnSuelo[i][floor_posX], EnSuelo[i][floor_posY], EnSuelo[i][floor_posZ]);
            alm(EnSuelo[i][floor_huella], GetRPName(playerid));
            new accion[64];
            formatt(accion, "tira su %s al suelo.", ObjetoInfo[manoder][NombreObjeto]);
            accion_player(playerid, 1, accion);
            update_manos(playerid);
            tirar_objeto(i);
            return 1;
        }
    }
    return SendClientMessage(playerid, COLOR_DARKRED, "No hay mas slots del suelo, contacta con un administrador.");
}
CMD:tirarizq(playerid){
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_DARKRED, "Tienes que estar a pie para tirar un objeto.");
    new manoizq = Datos[playerid][jMano][1],
        manocant,
        manodata
    ;
    if(!manoizq) return SendClientMessage(playerid, COLOR_DARKRED, "¡Tu mano izquierda está vacía!");
    manocant = Datos[playerid][jManoCant][1];
    manodata = Datos[playerid][jManoData][1];
    for(new i; i < MAX_SUELO; i++){
        if(!EnSuelo[i][floor_ObjetoID]){
            Datos[playerid][jMano][1] = 0;
            Datos[playerid][jManoCant][1] = 0;
            Datos[playerid][jManoData][1] = 0;
            EnSuelo[i][floor_ObjetoID] = manoizq;
            EnSuelo[i][floor_ObjetoCant] = manocant;
            EnSuelo[i][floor_ObjetoData] = manodata;
            GetPlayerPos(playerid, EnSuelo[i][floor_posX], EnSuelo[i][floor_posY], EnSuelo[i][floor_posZ]);
            alm(EnSuelo[i][floor_huella], GetRPName(playerid));
            new accion[64];
            formatt(accion, "tira su %s al suelo.", ObjetoInfo[manoizq][NombreObjeto]);
            accion_player(playerid, 1, accion);
            update_manos(playerid);
            tirar_objeto(i);
            return 1;
        }
    }
    return SendClientMessage(playerid, COLOR_DARKRED, "No hay mas slots del suelo, contacta con un administrador.");
}
CMD:recargar(playerid){
    new manoder = Datos[playerid][jMano][0];
    new manoizq = Datos[playerid][jMano][1];
    if(manoder){
        if(strfind(ObjetoInfo[manoder][NombreObjeto], "Beanbag", true) != -1){
            //Si es una escopeta de bala de goma
            if(Datos[playerid][jManoCant][0]) return SendClientMessage(playerid, COLOR_DARKRED, "Tu escopeta aún tiene cartuchos!");
            new cantbean;
            for(new i; i < ObjetoInfo[manoder][Capacidad]; i++){
                Datos[playerid][jManoCant][0]++;
                cantbean++;
            }
            if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "BUDDY", "buddy_crouchreload", 4.1, false, false, false, false, 1300, SYNC_ALL);
            else ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, false, false, false, false, 1300, SYNC_ALL);
            update_manos(playerid);
            return SendClientMessage(playerid, COLOR_DARKGREEN, "Cargas tu escopeta no letal con %d cartuchos de munición no letal. (duh).", cantbean);
        }
        else if(strcmp(ObjetoInfo[manoder][NombreObjeto], "Taser") == 0){
            if(Datos[playerid][jManoCant][0]) return SendClientMessage(playerid, COLOR_DARKRED, "Tu táser aún tiene cartuchos!");
            Datos[playerid][jManoCant][0] = 2;
            update_manos(playerid);
            if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "PYTHON", "python_crouchreload", 4.1, false, false, false, false, 930, SYNC_ALL);
            else ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, false, false, false, false, 930, SYNC_ALL);
            return SendClientMessage(playerid, COLOR_DARKGREEN, "Cargas tu táser con 2 cartuchos.");
        }
        new cargador = find_mag(manoder);
        if(manoizq){
            if(ObjetoInfo[manoder][Tipo] != 5) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes un arma en tu mano derecha.");
            else if(strcmp(ObjetoInfo[manoder][NombreObjeto], "Revolver .38", false) == 0){
                if(strcmp(ObjetoInfo[manoizq][NombreObjeto], "Munición .38") != 0){
                    SendClientMessage(playerid, COLOR_DARKRED, "No tienes municiones para el revolver.");
                    return 1;
                }
                if(Datos[playerid][jManoCant][0] == ObjetoInfo[manoder][Capacidad]){
                    SendClientMessage(playerid, COLOR_DARKRED, "¡Tu revolver tiene el tambor lleno!");
                    return 1;
                }
                new cantbalas;
                for(new i = Datos[playerid][jManoCant][0]; i < ObjetoInfo[manoder][Capacidad]; i++){
                    if(Datos[playerid][jManoCant][1]){
                        Datos[playerid][jManoCant][0]++;
                        Datos[playerid][jManoCant][1]--;
                        cantbalas++;
                        continue;
                    }
                    else break;
                }
                if(cantbalas){
                    if(!Datos[playerid][jManoCant][1]) Datos[playerid][jMano][1] = 0;
                    update_manos(playerid);
                    SendClientMessage(playerid, COLOR_DARKGREEN, "Cargas con %d balas tu revolver.", cantbalas);
                    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "PYTHON", "python_crouchreload", 4.1, false, false, false, false, 930, SYNC_ALL);
                    else ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, false, false, false, false, 930, SYNC_ALL);
                    return 1;
                }
                else return 1;
            }
            else if(!strcmp(ObjetoInfo[manoder][NombreObjeto], "Remington 870")){
                if(strcmp(ObjetoInfo[manoizq][NombreObjeto], "Cartuchos 12GA") != 0) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes municiones para tu escopeta.");
                if(Datos[playerid][jManoCant][0] == ObjetoInfo[manoder][Capacidad]) return SendClientMessage(playerid, COLOR_DARKRED, "¡Tu escopeta tiene el cargador lleno!");
                new cantbalas;
                for(new i = Datos[playerid][jManoCant][0]; i < ObjetoInfo[manoder][Capacidad]; i++){
                    if(Datos[playerid][jManoCant][1]){
                        Datos[playerid][jManoCant][0]++;
                        Datos[playerid][jManoCant][1]--;
                        cantbalas++;
                        continue;
                    }
                    else break;
                }
                if(cantbalas){
                    if(!Datos[playerid][jManoCant][1]) Datos[playerid][jMano][1] = 0;
                    update_manos(playerid);
                    SendClientMessage(playerid, COLOR_DARKGREEN, "Cargas con %d cartuchos tu escopeta.", cantbalas);
                    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "BUDDY", "buddy_crouchreload", 4.1, false, false, false, false, 1300, SYNC_ALL);
                    else ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, false, false, false, false, 1300, SYNC_ALL);
                    return 1;
                }
                else return 1;
            }
            else if(ObjetoInfo[manoizq][Tipo] != 6) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes un cargador en tu mano izquierda.");
            if(cargador != manoizq) return SendClientMessage(playerid, COLOR_DARKRED, "No tienes un cargador para esta arma.");
            if(Datos[playerid][jManoCant][0] == -1){
                Datos[playerid][jManoCant][0] = Datos[playerid][jManoCant][1];
                Datos[playerid][jManoCant][1] = 0;
                Datos[playerid][jMano][1] = 0;
                SendClientMessage(playerid, COLOR_DARKGREEN, "Cargas tu arma con %d balas.", Datos[playerid][jManoCant][0]);
            }
            else{
                SendClientMessage(playerid, COLOR_DARKGREEN, "Quitas el cargador viejo de tu arma con %d balas, colocas uno nuevo con %d balas.", Datos[playerid][jManoCant][0], Datos[playerid][jManoCant][1]);
                new manoizcant = Datos[playerid][jManoCant][1];
                Datos[playerid][jManoCant][1] = Datos[playerid][jManoCant][0];
                Datos[playerid][jManoCant][0] = manoizcant;
            }
            if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "PYTHON", "python_crouchreload", 4.1, false, false, false, false, 930, SYNC_ALL);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, false, false, false, false, 930, SYNC_ALL);
        }
        else{
            new bolid = -1;
            new quant;
            for(new i; i < 5; i++){
                if(cargador == Datos[playerid][jBolsillo][i]){
                    if(Datos[playerid][jBolsilloCant][i] > quant){
                        quant = Datos[playerid][jBolsilloCant][i];
                        bolid = i;
                        continue;
                    }
                    else continue;
                }
            }
            if(bolid == -1) return SendClientMessage(playerid, COLOR_DARKRED, "No encontramos un cargador para este arma en tus bolsillos o mano.");
            if(Datos[playerid][jManoCant][0] == -1){
                Datos[playerid][jBolsillo][bolid] = 0;
                Datos[playerid][jBolsilloCant][bolid] = 0;
                SendClientMessage(playerid, COLOR_DARKGREEN, "Buscas un cargador con %d balas de tus bolsillos y lo colocas en tu arma.", quant);
                Datos[playerid][jManoCant][0] = quant;     
                update_manos(playerid);
                return 1;
            }
            else{
                
                SendClientMessage(playerid, COLOR_DARKGREEN, "Buscas un cargador con %d balas de tus bolsillos y reemplazas el que ya tenias, con %d balas.", quant, Datos[playerid][jManoCant][0]);
                Datos[playerid][jBolsilloCant][bolid] = Datos[playerid][jManoCant][0];
                Datos[playerid][jManoCant][0] = quant;
                update_manos(playerid);
            }
            if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) ApplyAnimation(playerid, "PYTHON", "python_crouchreload", 4.1, false, false, false, false, 930, SYNC_ALL);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, false, false, false, false, 930, SYNC_ALL);
        }
        update_manos(playerid);
    }
    return 1;
}
alias:ceder("darobjeto")
alias:cederizq("cederi", "darobjetoizq", "darobjetoi")
alias:tirarizq("tirari")
alias:recargar("rec")
alias:sacar("s")
alias:guardar("g")
alias:bol("bolsillos", "inv")
alias:guardari("gi")