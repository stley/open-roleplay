
CMD:stats(playerid)
{
    if(!Datos[playerid][EnChar]) return 1;
    new msg[512];
    SendClientMessage(playerid, COLOR_GREEN,"Estadísticas de %s (%s):", Datos[playerid][jNombrePJ], username[playerid]);
    SendClientMessage(playerid, COLOR_GREEN, "Estadísticas IC:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Nombre: %s | Edad: %d | Sexo: %s | Trabajo: %s (%d) | Efectivo: %d", Datos[playerid][jNombrePJ], Datos[playerid][jEdad], (Datos[playerid][jSexo] == 1) ? "Hombre" : "Mujer", "Carpintero", 3, Datos[playerid][jDinero]);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Facción: %d | Rango: %d — | — Facción Secundaria: %d | Rango: %d", Datos[playerid][jFaccion], Datos[playerid][jRango], Datos[playerid][jFaccion2], Datos[playerid][jRangoFac2]);
    SendClientMessage(playerid, COLOR_GREEN, "Licencias:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Conducir: %s | Armas: %s", (Datos[playerid][jLicencias][0]) ? "Sí" : "No", (Datos[playerid][jLicencias][1]) ? "Sí" : "No");
    SendClientMessage(playerid, COLOR_GREEN, "Estadísticas OOC:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "SQLID (usuario): %d | SQLID (personaje): %d ", Datos[playerid][jSQLID], Datos[playerid][jSQLIDP]);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Nivel: %d | Puntos de experiencia: %d | Horas jugadas: %d ", Datos[playerid][jNivel], Datos[playerid][jExp], Datos[playerid][jHoras]);
    formatt(msg, "Premium: %s", (Datos[playerid][jPremium] > 0) ? "Sí" : "No");
    if(Datos[playerid][jPremium]){
        new little_buff[96];
        formatt(little_buff, " | Vigente hasta: %d de %s de %d", Datos[playerid][jDpremium], GetMonth(Datos[playerid][jMpremium]), Datos[playerid][jApremium]);
        strcat(msg, little_buff);
    }
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, msg);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Puntos de rol: %d / %d", Datos[playerid][jPuntosRol], Datos[playerid][jPuntosRolNeg]);
    SendClientMessage(playerid, COLOR_GREEN, "Propiedades:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Casas: %d — %d | Casa prestada: %d", Datos[playerid][jCasa][0], Datos[playerid][jCasa][1], Datos[playerid][jCasaLlaves]);
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Vehiculos prestados: %d | %d", Datos[playerid][jCocheLlaves][0], Datos[playerid][jCocheLlaves][1]);
    SendClientMessage(playerid, COLOR_GREEN, "Interiores:");
    SendClientMessage(playerid, COLOR_LIGHTNEUTRALBLUE, "Casa: %d — Negocio: %d | Interior: %d — VirtualWorld: %d", DentroCasa[playerid], DentroNegocio[playerid], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    return 1;
}

CMD:panel(playerid){
    new body[2048];

    new buffer[128];
    formatt(buffer, "Cambiar de personaje\n\
    Salir\
    ");
    strcat(body, buffer);
    formatt(buffer, "Cambia de personaje rápidamente.\nCierra este panel.");
    ShowPlayerInteractionMenu(playerid, ACCOUNT_PANEL_MENU, body, sprintf("%s", Datos[playerid][jNombrePJ]), buffer);
    return 1;
}