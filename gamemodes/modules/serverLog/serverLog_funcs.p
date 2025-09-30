
forward serverLogInit();
forward serverLogExit();

serverLogRegister(const info[], const module[] = "undefined")
{
    const MAX_LINES = 20;

    new hour, minute, second;
    new day, month, year;
    getdate(year, month, day);
    gettime(hour, minute, second);
    

    new String:logline = str_cat(str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - [***%s***] ", day, month, year, hour, minute, second, module), str_new(info));
    if (serverLogBufferLines >= MAX_LINES || (str_len(serverLogBuffer)+str_len(logline)) > 1900)
    {
        discordSendMessage_s(serverLogBuffer);
        str_clear(serverLogBuffer);
        serverLogBufferLines = 0;
    }
    if (serverLogBufferLines > 0) str_append_format(serverLogBuffer, "\n");
    str_append(serverLogBuffer, str_convert(logline, "ansi", "utf8"));
    serverLogBufferLines++;
    printf("[%s] - %s", module, info);
    return 1;
}

public serverLogInit(){
    //new init_str[96];
    new
        hour, minute, second,
        day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);
    //formatt(init_str, "**[%02d/%02d/%04d %02d:%02d:%02d]** - *serverLog* Iniciado", day, month, year, hour, minute, second);
    //discordSendMessage(init_str);
    discordSendMessage_s(str_format("**[%02d/%02d/%04d %02d:%02d:%02d]** - *serverLog* Iniciado", day, month, year, hour, minute, second));
    serverLogBuffer = str_new("");
    
    str_acquire(serverLogBuffer);
    return 1;
}
public serverLogExit(){
    new
        hour, minute, second,
        day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);
    //new exit_str[96];
    if(str_len(serverLogBuffer)) discordSendMessage_s(serverLogBuffer);
    delay(1000);
    //formatt(exit_str, "**[%02d/%02d/%04d %02d:%02d:%02d] - Deteniendo** ***serverLog***...", day, month, year, hour, minute, second);
    //discordSendMessage(exit_str);
    discordSendMessage_s(str_format("**[%02d/%02d/%04d %02d:%02d:%02d] - Deteniendo** ***serverLog***...", day, month, year, hour, minute, second));
    str_release(serverLogBuffer);
    return 1;
}