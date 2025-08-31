

stock serverLogRegister(const info[])
{
    const MAX_LINES = 10;
    const MAX_BYTES = sizeof(serverLogBuffer) - 1; // keep room for '\0'

    new line[512];
    Cp1252ToUtf8(line, sizeof line, info);

    // bytes needed if we append now (newline only when buffer not empty)
    new need = (serverLogBufferLines > 0 ? 1 : 0) + strlen(line);

    // flush BEFORE overflowing line count or size
    if (serverLogBufferLines >= MAX_LINES || strlen(serverLogBuffer) + need > MAX_BYTES)
    {
        DCC_SendChannelMessage(LOG_CHANNEL, serverLogBuffer);
        serverLogBuffer[0] = '\0';
        serverLogBufferLines = 0;
    }
    if (serverLogBufferLines > 0) strcat(serverLogBuffer, "\n");
    strcat(serverLogBuffer, line);
    serverLogBufferLines++;
    print(info);
    return 1;
}