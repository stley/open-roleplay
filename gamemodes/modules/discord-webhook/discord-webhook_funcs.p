new serverLogBufferLines;
new serverLogBuffer[1900];


forward discordOnGameModeInit();
forward discordOnGameModeExit();
forward discordOnPlayerConnect(playerid);
forward discordSendMessage(const message[]);
forward discordOnSendMessage(Requests:id, E_HTTP_STATUS:status, Node:node);


public discordOnGameModeInit(){
    new File:filehandle = fopen("webhook.ini", io_read);
    if(filehandle) fread(filehandle, webhook_url, sizeof(webhook_url), false);
    if(!strlen(webhook_url)) return printf("NO SE ENCONTRÓ EL URL DEL WEBHOOK, ABORTANDO...");
    LOG_CHANNEL = RequestsClient(webhook_url);
    return 1;
}

public discordOnGameModeExit(){
    if(strlen(serverLogBuffer)){
        discordSendMessage(serverLogBuffer);
        new str_quit[128];
        formatt(str_quit, "APAGANDO SERVIDOR...");
        discordSendMessage(str_quit);
    }
}

public discordOnPlayerConnect(playerid){
    new login[94];
    format(login, sizeof login, "%s ingresó al servidor (IP: %s | playerid %d)", GetName(playerid), GetPIP(playerid), playerid);
    serverLogRegister(login);    
    return 1;
}


discordSendMessage(const message[]){
    if(!isChannelWorking) return 1;
    if(IsValidRequestsClient(LOG_CHANNEL))
    RequestJSON(LOG_CHANNEL,
        "",
        HTTP_METHOD_POST,
        "discordOnSendMessage",
        JsonObject("content", JsonString(message))
    );
    return 1;
}


public discordOnSendMessage(Requests:id, E_HTTP_STATUS:status, Node:node){
    if(status == HTTP_STATUS_NO_CONTENT){
        return 1;
    }
    else{
        printf("No se pudo enviar el mensaje al webhook, a partir de ahora no se enviarán más logs al Discord.");
        isChannelWorking = false;
    }
    return 1;
}