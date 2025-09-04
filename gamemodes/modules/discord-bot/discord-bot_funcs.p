new serverLogBufferLines;
new serverLogBuffer[1900];

forward discordOnGameModeInit();
forward discordOnGameModeExit();
forward discordOnMessageSent(channel);
forward discordOnPlayerConnect(playerid);

public discordOnGameModeInit(){
    //anuncioadmin = DCC_CreateCommand("mensajeglobal", "Enviar un mensaje global al servidor.", "discordMensajeGlobal", false, DCC_FindGuildById("1070062942319558707"));
    LOG_CHANNEL = DCC_FindChannelById("1411111715348807701");
    CONSOLE_CHANNEL = DCC_FindChannelById("1411154206030565467");
    if(LOG_CHANNEL == DCC_INVALID_CHANNEL) serverLogRegister("No se encontró el canal de Discord al cual enviar logs.");
    new buff[96];
    new logutf[128];
    format(buff, sizeof(buff), "Gamemode iniciada, el bot se conectó correctamente - (%s)", FechaActual());
    Cp1252ToUtf8(logutf, sizeof(logutf), buff);
    DCC_SendChannelMessage(LOG_CHANNEL, logutf);
    return 1;
}

public DCC_OnMessageCreate(DCC_Message:message){
    new DCC_Channel:curr_channel;
    DCC_GetMessageChannel(message, DCC_Channel:curr_channel);
    if(DCC_Channel:curr_channel == LOG_CHANNEL){
        new DCC_User:author;
        DCC_GetMessageAuthor(message, author);
        new UID[DCC_ID_SIZE];
        DCC_GetUserId(author, UID);
        if(strcmp(UID, BOT_USERID) != 0) DCC_DeleteMessage(message);
        return 1;    
    }
    return 1;
}

public discordOnPlayerConnect(playerid){
    new login[94];
    format(login, sizeof login, "%s ingresó al servidor (IP: %s | playerid %d)", GetName(playerid), GetPIP(playerid), playerid);
    serverLogRegister(login);    
    return 1;
}