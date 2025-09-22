accion_player(playerid, tipo, const action[]){
    // 0 - /me
    // 1 - /ame
    // 2 - /do
    if(!IsPlayerConnected(playerid)) return 1;
    new Float:playerpos[3];
    new player_vw = GetPlayerVirtualWorld(playerid);
    GetPlayerPos(playerid, playerpos[0], playerpos[1], playerpos[2]);
    foreach(new i: Player){
        if(IsPlayerInRangeOfPoint(i, 30.0, playerpos[0], playerpos[1], playerpos[2])){
            switch(tipo){
                case 0:{
                    if(GetPlayerVirtualWorld(i) == player_vw) SendClientMessage(i, 0xACC97F22A, "* %s %s", Name_sin(GetName(playerid)), action);
                    continue;
                }
                case 2:{
                    if(GetPlayerVirtualWorld(i) == player_vw) SendClientMessage(i, 0x9EC73DAA, "[%s - %d] %s", Name_sin(GetName(playerid)), playerid, action);
                    continue;
                }
                default: continue;
            }
        }
    }
    if(tipo == 1){
        new accion[96];
        formatt(accion, "> %s", action);
        SendClientMessage(playerid, 0xC2A2DAAA, "%s", accion);
        SetPlayerChatBubble(playerid, action, 0xC2A2DAAA, 30.0, 4000);
        return 1;
    }
    return 1;
}
Name_sin(const text[]){
	new name[25];
	alm(name, text);
	strreplace(name, "_", " ");
	return name;
}

stock GetRPName(playerid) return Name_sin(GetName(playerid));

public OnPlayerText(playerid, text[]){
	if(!Datos[playerid][LoggedIn] && !Datos[playerid][EnChar]) return 0;
    new dice[200];
    new Float:distancia;
	if(muerto[playerid] == 2){
		SendClientMessage(playerid, COLOR_DARKRED, "No puedes hablar muerto!");
		return 0;
	}
    formatt(dice, "%s dice: %s", Name_sin(GetName(playerid)), text);
    if (GetPlayerInterior(playerid) != 0 && GetPlayerVirtualWorld(playerid) != 0){
		if (IsPlayerInAnyVehicle(playerid)) distancia = 7.0;
		else distancia = 8.0;
	}
	else{
		if (IsPlayerInAnyVehicle(playerid)) distancia = 12.0;
		else distancia = 15.0;
	}
    ProxDetector(distancia, playerid, dice, C_FADE1, C_FADE2, C_FADE3, C_FADE4, C_FADE5);
    return 0;
}

forward ProxDetector(Float:radi, playerid, string[], color1, color2, color3, color4, color5);
public ProxDetector(Float:radi, playerid, string[], color1, color2, color3, color4, color5)
{
	new
		Float:currentPos[3],
		Float:oldPos[3],
		Float:checkPos[3]
	;
	GetPlayerPos(playerid, oldPos[0], oldPos[1], oldPos[2]);
	foreach(new i: Player)
	{
        if(!IsPlayerConnected(i)) continue;
		GetPlayerPos(i, currentPos[0], currentPos[1], currentPos[2]);
		for (new p = 0; p < 3; p++)
		{
			checkPos[p] = (oldPos[p] - currentPos[p]);
		}

		if (GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))  continue;

		if (((checkPos[0] < radi/16) && (checkPos[0] > -radi/16)) && ((checkPos[1] < radi/16) && (checkPos[1] > -radi/16)) && ((checkPos[2] < radi/16) && (checkPos[2] > -radi/16)))
		{
			if (Datos[i][jNivel] != -1) SendSplitMessage(i, color1, string);
		}
		else if (((checkPos[0] < radi/8) && (checkPos[0] > -radi/8)) && ((checkPos[1] < radi/8) && (checkPos[1] > -radi/8)) && ((checkPos[2] < radi/8) && (checkPos[2] > -radi/8)))
		{
			if (Datos[i][jNivel] != -1) SendSplitMessage(i, color2, string);
		}
		else if (((checkPos[0] < radi/4) && (checkPos[0] > -radi/4)) && ((checkPos[1] < radi/4) && (checkPos[1] > -radi/4)) && ((checkPos[2] < radi/4) && (checkPos[2] > -radi/4)))
		{
			if (Datos[i][jNivel] != -1) SendSplitMessage(i, color3, string);
		}
		else if (((checkPos[0] < radi/2) && (checkPos[0] > -radi/2)) && ((checkPos[1] < radi/2) && (checkPos[1] > -radi/2)) && ((checkPos[2] < radi/2) && (checkPos[2] > -radi/2)))
		{
			if (Datos[i][jNivel] != -1) SendSplitMessage(i, color4, string);
		}
	}
	return 1;
}

SendSplitMessage(playerid, color, const text[])
{
	#define LENGHT (120)

	if(strlen(text) > LENGHT)
	{
		new firstString[LENGHT], secondString[LENGHT];

		strmid(firstString, text, 0, LENGHT);
		strmid(secondString, text, LENGHT - 1, LENGHT * 2);

		format(firstString, LENGHT, "%s...", firstString);
		format(secondString, LENGHT, "...%s", secondString);

		SendClientMessage(playerid, color, firstString);
		SendClientMessage(playerid, color, secondString);
	}
	else SendClientMessage(playerid, color, text);

	#undef LENGHT

	return 1;
}