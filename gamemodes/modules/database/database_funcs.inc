public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle){
    new errorlog[300];
    formatt(errorlog, "ERROR al procesar la query correspondiente al callback \"%s\": (%d) %s", callback, errorid, error);
    serverLogRegister(errorlog);
    formatt(errorlog, "Query DUMP: %s", query);
    serverLogRegister(errorlog);
    return 1;
}