
#if !defined _PawnPlus_included
    #include <PawnPlus>
#endif
#if !defined _requests_included
    #include <requests>
#endif

#if defined __serverLog_as_a_module
    #endinput
#endif
#define __serverLog_as_a_module

#if defined __serverLog_included
    #error "Do not include <serverLog>, as it collapses with serverLog module definitions!"
#endif

#define CURRENT_MODULE "serverLog-Internal"


native Node:JsonString_s(ConstAmxString:value) = JsonString; //PawnPlus implementation of pawn-requests native, supporting PP strings.

forward sLM_discordInit();
forward sLM_discordExit();
forward sLM_serverLogInit();
forward sLM_serverLogExit();
forward sLM_discordSendMessage(ConstStringTag:message);
forward sLM_discordOnSendMessage(Requests:id, E_HTTP_STATUS:status, Node:node);
forward sLM_Register(const info[], const module[]);
forward sLM_Push();
forward sLM_Send(const info[], const module[]);
#define DISCORD_RETRY_MS    300000 //The time in miliseconds the plugin waits before trying to reconnect to the webhook.



new
    String:sLM_Buffer,
    sLM_BufferLines,
    RequestsClient:sLM_client,
    sLM_webhook_url[256],
    bool:sLM_isRClientOnline = true,
    sLM_RetryTimer
;


webhookLinux(url[]){
    //Fix CRLF on webhook.ini file (for Linux servers)
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




sLM_discordTimeOut(){
    if(IsValidTimer(sLM_RetryTimer)) return 1;
    else SetTimer("sLM_discordInit", DISCORD_RETRY_MS, false);
    return 1;    
}

public sLM_discordInit(){
    new File:filehandle = fopen("webhook.ini", io_read);
    if(filehandle){
        fread(filehandle, sLM_webhook_url);
        fclose(filehandle);
    }
    else{
        printf("\"webhook.ini\" not found on scriptfiles folder!");
        print("Could not connect to Discord webhook. Will retry in 5 minutes.");
        sLM_isRClientOnline = false;
        sLM_discordTimeOut();
        return 1;
    }
    webhookLinux(sLM_webhook_url);
    sLM_client = RequestsClient(sLM_webhook_url);
    new
        hour, minute, second,
        day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);
    if(!IsValidRequestsClient(sLM_client)){
        print("Could not connect to Discord webhook. Will retry in 5 minutes.");
        sLM_isRClientOnline = false;
        sLM_discordTimeOut();
    }
    else{
        sLM_isRClientOnline = true;
        sLM_discordSendMessage(str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - Connected to Discord webhook.", day, month, year, hour, minute, second));
        sLM_Buffer = str_new("");
        str_acquire(sLM_Buffer);
    }
    return 1;
}



public sLM_discordExit(){
    new
        hour, minute, second,
        day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);
    sLM_discordSendMessage(str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - Shutting down server...", day, month, year, hour, minute, second));
    return 1;
}

sLM_discordSendMessage(ConstStringTag:message){
    if(!sLM_isRClientOnline) return 1;
    if(IsValidRequestsClient(sLM_client))
    RequestJSON(sLM_client,
        "",
        HTTP_METHOD_POST,
        "sLM_discordOnSendMessage",
        JsonObject("content", JsonString_s(message))
    );
    return 1;
}

public sLM_discordOnSendMessage(Requests:id, E_HTTP_STATUS:status, Node:node){
    if(status == HTTP_STATUS_NO_CONTENT)
        return 1;
    else{
        sLM_isRClientOnline = false;
        sLM_Register("Could not send the message to the Discord webhook. Retrying connection in 5 minutes.", "sLM-Discord");
        sLM_discordTimeOut();
    }
    return 1;
}


sLM_serverLogInit(){
    new
        hour, minute, second,
        day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);

    sLM_discordSendMessage(str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - ***stley/serverLog*** module started!", day, month, year, hour, minute, second));  
    print("\n\nstley/serverLog module started.\n\n");
    return 1;
}
sLM_serverLogExit(){
    if(str_valid(sLM_Buffer)){
        if(str_len(sLM_Buffer) && sLM_isRClientOnline){
            sLM_discordSendMessage(sLM_Buffer);
        }
        str_release(sLM_Buffer);
    }
    delay(500);
    if(sLM_isRClientOnline){
        new
        hour, minute, second,
        day, month, year
        ;
        getdate(year, month, day);
        gettime(hour, minute, second);
        sLM_discordSendMessage(str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - ***stley/serverLog*** module stopping...", day, month, year, hour, minute, second));
    }
    print("\n\nstley/serverLog module stopping.\n\n");
    return 1;
}


sLM_Register(const info[], const module[])
{
    if(!sLM_isRClientOnline) return printf("[%s] - %s", module, info);
    if(!str_valid(sLM_Buffer)){
        sLM_Buffer = str_new("");
        str_acquire(sLM_Buffer);
    }
    const MAX_LINES = 20;

    new hour, minute, second;
    new day, month, year;
    getdate(year, month, day);
    gettime(hour, minute, second);
    
    #if defined serverLog_NO_MODULES
        new String:logline = str_cat(
            str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - ", day, month, year, hour, minute, second),
            str_new(info)
        );  
    #else  
        new String:logline = str_cat(
            str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - [***%s***] ", day, month, year, hour, minute, second, module),
            str_new(info)
        );
    #endif
    if (sLM_BufferLines >= MAX_LINES || (str_len(sLM_Buffer)+str_len(logline)) > 1900)
    {
        sLM_discordSendMessage(sLM_Buffer);
        str_clear(sLM_Buffer);
        sLM_BufferLines = 0;
    }
    if (sLM_BufferLines > 0) str_append_format(sLM_Buffer, "\n");
    str_append(sLM_Buffer, str_convert(logline, "ansi", "utf8"));
    sLM_BufferLines++;
    printf("[%s] - %s", module, info);
    return 1;
}

public sLM_Push(){
    if(str_valid(sLM_Buffer)){
        if(str_len(sLM_Buffer) && sLM_isRClientOnline){
            sLM_discordSendMessage(sLM_Buffer);
            str_clear(sLM_Buffer);
            sLM_BufferLines = 0;
        }
    }
    return 1;
}


stock sLM_Send(const info[], const module[]){
    sLM_Register(info, module); // If lines or character length exceed limits, it pushes the buffer automatically, then starts adding a new line.
    if(sLM_BufferLines) sLM_Push(); // Pushes the current buffer.
    return 1;
}


sLM_Init(){
    sLM_discordInit();
    delay(500);
    sLM_serverLogInit();
    if(CallRemoteFunction("sLFS_Ping") == 1){ //If this function is registered, that means that both module and filterscript are runnning! Not good!
        SendRconCommand("unloadfs serverLog");
        serverLogSend("Warning: serverLog module killed \"serverLog\" side script to prevent further errors and misbehaviors.", "serverLog-internal");
    }
    return 1;
}

sLM_Exit(){
    sLM_serverLogExit();
    delay(500);
    sLM_discordExit();
    return 1;
}
stock serverLogRegister(const info[], const module[] = "serverLog") return sLM_Register(info, module);
forward serverLogPush();
public serverLogPush(){
    return CallLocalFunction("sLM_Push");
}
stock serverLogSend(const info[], const module[] = "serverLog") return sLM_Send(info, module);


#include <pp-hooks>

hook ret OnGameModeInit(&ret){
    sLM_Init();
    ret = 1;
    return 1;
}
#include <pp-hooks>

hook ret OnGameModeExit(&ret){
    sLM_Exit();
    ret = 1;
    return 1;
}

#undef CURRENT_MODULE