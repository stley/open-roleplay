new serverLogBufferLines;
new String:serverLogBuffer;


forward discordOnGameModeInit();
forward discordOnGameModeExit();
forward discordOnPlayerConnect(playerid);
forward discordSendMessage(const message[]);
forward discordSendMessage_s(ConstStringTag:message);
forward discordOnSendMessage(Requests:id, E_HTTP_STATUS:status, Node:node);
native Node:JsonString_s(ConstAmxString:value) = JsonString;

webhookLinux(url[]){
    while (strlen(url) > 0)
    {
        new last = url[strlen(url) - 1];
        if (last == '\r' || last == '\n' || last == ' ')
            url[strlen(url) - 1] = '\0';
        else
            break;
    }
    return 1;
}

public discordOnGameModeInit(){
    new File:filehandle = fopen("webhook.ini", io_read);
    if(!filehandle) return serverLogRegister("ERROR: No se encontro \"scriptfiles/webhook.ini\"", CURRENT_MODULE);
    if(filehandle) fread(filehandle, webhook_url, sizeof(webhook_url), false);
    if(!strlen(webhook_url)) return serverLogRegister("ERROR: NO SE ENCONTRÓ EL URL DEL WEBHOOK en \"webhook.ini\", ABORTANDO...", CURRENT_MODULE);
    fclose(filehandle);
    webhookLinux(webhook_url);
    LOG_CHANNEL = RequestsClient(webhook_url);
    
    if(IsValidRequestsClient(LOG_CHANNEL)){
        new
            hour, minute, second,
            day, month, year
        ;
        getdate(year, month, day);
        gettime(hour, minute, second);
        discordSendMessage_s(str_format(" **[%02d/%02d/%04d %02d:%02d:%02d] - Conectado al webhook de Discord.**", day, month, year, hour, minute, second));
        //discordSendMessage(sprintf(" **[%02d/%02d/%04d %02d:%02d:%02d] - Conectado al webhook de Discord.**", day, month, year, hour, minute, second));
    }
    else{
        serverLogRegister("Conexión al webhook de Discord fallida!", CURRENT_MODULE);
        isChannelWorking = false;
        SetTimer("discordOnGameModeInit", 300000, false);
    }
    return 1;
}


public discordOnGameModeExit(){
    new
    hour, minute, second,
    day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);
    //discordSendMessage(sprintf("**[%02d/%02d/%04d %02d:%02d:%02d] - Apagando servidor...**", day, month, year, hour, minute, second));
    discordSendMessage_s(str_format("**[%02d/%02d/%04d %02d:%02d:%02d] - Apagando servidor...**", day, month, year, hour, minute, second));
    return 1;
}




stock discordSendMessage_s(ConstStringTag:message){
    if(!isChannelWorking) return 1;
    if(IsValidRequestsClient(LOG_CHANNEL))
    RequestJSON(LOG_CHANNEL,
        "",
        HTTP_METHOD_POST,
        "discordOnSendMessage",
        JsonObject("content", JsonString_s(message))
    );
    return 1;
}


stock discordSendMessage(const message[]){
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
        serverLogRegister("No se pudo enviar el mensaje al webhook. Reintentando en 5 minutos.", CURRENT_MODULE);
        isChannelWorking = false;
        SetTimer("discordOnGameModeInit", 300000, false);
    }
    return 1;
}