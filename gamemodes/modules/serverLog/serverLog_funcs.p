
forward serverLogInit();
forward serverLogExit();

serverLogRegister(const info[])
{
    const MAX_LINES = 20;
    const MAX_BYTES = sizeof(serverLogBuffer) - 1;

    new line[512];
    Cp1252ToUtf8(line, sizeof line, info);

    new need = (serverLogBufferLines > 0 ? 1 : 0) + strlen(line);
    new hour, minute, second;
    new day, month, year;
    getdate(year, month, day);
    gettime(hour, minute, second);

    if (serverLogBufferLines >= MAX_LINES || strlen(serverLogBuffer) + need > MAX_BYTES)
    {
        discordSendMessage(serverLogBuffer);
        serverLogBuffer[0] = '\0';
        serverLogBufferLines = 0;
    }
    if (serverLogBufferLines > 0) strcat(serverLogBuffer, "\n");
    new today[32];
    formatt(today, "**[%02d/%02d/%04d %02d:%02d:%02d]** - ", day, month, year, hour, minute, second);
    strcat(serverLogBuffer, today);
    strcat(serverLogBuffer, line);
    serverLogBufferLines++;
    print(info);
    return 1;
}

public serverLogInit(){
    new init_str[96];
    new
        hour, minute, second,
        day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);
    formatt(init_str, "**[%02d/%02d/%04d %02d:%02d:%02d]** - *serverLog* Iniciado", day, month, year, hour, minute, second);
    discordSendMessage(init_str);
    return 1;
}
public serverLogExit(){
    new
        hour, minute, second,
        day, month, year
    ;
    getdate(year, month, day);
    gettime(hour, minute, second);
    new exit_str[96];
    if(strlen(serverLogBuffer)) discordSendMessage(serverLogBuffer);
    delay(1000);
    formatt(exit_str, "**[%02d/%02d/%04d %02d:%02d:%02d] - Deteniendo** ***serverLog***...", day, month, year, hour, minute, second);
    discordSendMessage(exit_str);
    return 1;
}