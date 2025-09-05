forward serverLogInit();
forward serverLogExit();

stock serverLogRegister(const info[])
{
    const MAX_LINES = 10;
    const MAX_BYTES = sizeof(serverLogBuffer) - 1; // keep room for '\0'

    new line[512];
    Cp1252ToUtf8(line, sizeof line, info);
    new hour, minute, second;
    new day, month, year;
    // bytes needed if we append now (newline only when buffer not empty)
    new need = (serverLogBufferLines > 0 ? 1 : 0) + strlen(line);
    
    getdate(year, month, day);
    gettime(hour, minute, second);

    // flush BEFORE overflowing line count or size
    if (serverLogBufferLines >= MAX_LINES || strlen(serverLogBuffer) + need > MAX_BYTES)
    {
        DCC_SendChannelMessage(LOG_CHANNEL, serverLogBuffer);
        serverLogBuffer[0] = '\0';
        serverLogBufferLines = 0;
    }
    if (serverLogBufferLines > 0) strcat(serverLogBuffer, "\n");
    new today[32];
    formatt(today, "[%d/%d/%d %d:%d:%d] ", day, month, year, hour, minute, second);
    strcat(serverLogBuffer, today);
    strcat(serverLogBuffer, line);
    serverLogBufferLines++;
    print(info);
    return 1;
}
public serverLogInit(){
    pawn_register_callback("OnGameModeExit", "serverLogExit");
    new buff[150];
    new logutf[160];
    format(buff, sizeof(buff), "serverLog iniciado - (%s)", FechaActual());
    Cp1252ToUtf8(logutf, sizeof(logutf), buff);
    DCC_SendChannelMessage(LOG_CHANNEL, logutf);
}
public serverLogExit(){
    if(strlen(serverLogBuffer) || serverLogBufferLines) DCC_SendChannelMessage(LOG_CHANNEL, serverLogBuffer);
    new today[128];
    new hour, minute, second;
    new day, month, year;
    formatt(today, "[%d/%d/%d %d:%d:%d] Stopping serverLog... - (%s)", day, month, year, hour, minute, second, FechaActual());
    DCC_SendChannelMessage(LOG_CHANNEL, today);
    return 1;
}