Dialog:CharInv(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;
    if(listitem < 5){
        sacar_bol(playerid, listitem);
        return 1;
    }
    else if(listitem > 5){
        guardar_bol(playerid, (listitem < 7) ? 0 : 1);
        return 1;
    }
    else{
        PC_EmulateCommand(playerid, "/bol");
        return 1;
    }
}
