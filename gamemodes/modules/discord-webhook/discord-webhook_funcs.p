new serverLogBufferLines;
new serverLogBuffer[1900];


forward discordOnGameModeInit();
forward discordOnGameModeExit();
forward discordOnPlayerConnect(playerid);
forward discordSendMessage(const message[]);
forward discordOnSendMessage(Requests:id, E_HTTP_STATUS:status, Node:node);

webhookLinux(url[]){
    while (strlen(url) > 0)
    {
        new last = str[strlen(str) - 1];
        if (last == '\r' || last == '\n' || last == ' ')
            str[strlen(str) - 1] = '\0';
        else
            break;
    }
    return 1;
}

public discordOnGameModeInit(){
    new File:filehandle = fopen("webhook.ini", io_read);
    if(!filehandle) return serverLogRegister("ERROR: No se encontro \"scriptfiles/webhook.ini\"");
    if(filehandle) fread(filehandle, webhook_url, sizeof(webhook_url), false);
    webhookLinux(webhook_url);
    if(!strlen(webhook_url)) return serverLogRegister("ERROR: NO SE ENCONTRÓ EL URL DEL WEBHOOK en \"webhook.ini\", ABORTANDO...");
    LOG_CHANNEL = RequestsClient(webhook_url);
    if(IsValidRequestsClient(LOG_CHANNEL)) discordSendMessage("Conectado al webhook de Discord.");
    else discordSendMessage("Conexión al webhook de Discord fallida!");
    return 1;
}



public discordOnGameModeExit(){
    discordSendMessage("Apagando servidor...");
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
        serverLogRegister("No se pudo enviar el mensaje al webhook, a partir de ahora no se enviarán más logs al Discord.");
        isChannelWorking = false;
    }
    return 1;
}