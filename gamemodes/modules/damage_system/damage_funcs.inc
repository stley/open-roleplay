forward Wound_HandleDamage(playerid, issuerid, weaponid, bodypart, Float:amount);
forward Wound_TaseHim(playerid, issuerid);
forward Wound_BeanbagHim(playerid, issuerid);
forward Wound_Succumb(playerid);
forward wound_timer(playerid);

public wound_timer(playerid){
    CanRespawn[playerid] = true;
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Ya puedes utilizar el comando /reaparecer.");
    return 1;
}

clear_wounds(playerid){
    for(new i; i < MAX_WOUNDS; i++){
        wound_data[playerid][i][wnd_ammoType] = 0;
        wound_data[playerid][i][wnd_dmgTaken] = 0.0;
        wound_data[playerid][i][wnd_bodypart] = 0;
        wound_data[playerid][i][wnd_kevlarHit] = 0;
        wound_data[playerid][i][wnd_IssuerSQLID] = -1;
    }
}

public Wound_HandleDamage(playerid, issuerid, weaponid, bodypart, Float:amount){

    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(issuerid)) return 0;
    new
        ammo,
        Float:dmgtaken
    ;
    SetPlayerHealth(playerid, Datos[playerid][jVida]);
    SetPlayerArmour(playerid, Datos[playerid][jChaleco]);
    if(issuerid == INVALID_PLAYER_ID) return 1;
    if(weaponid != ObjetoInfo[Datos[issuerid][jMano][0]][IDArma]) return 1;
    if(weaponid == 22) return Wound_TaseHim(playerid, issuerid);
    if(weaponid == 25 && ObjetoInfo[Datos[issuerid][jMano][0]][ModeloObjeto] == -1005) return Wound_BeanbagHim(playerid, issuerid);
    if(weaponid == 0 &&  Datos[issuerid][jManoCant][0] == 0){
        ammo = 1;
        dmgtaken = amount;
    }
    if(ObjetoInfo[Datos[issuerid][jMano][0]][Tipo] == 4){
        if(weaponid == 4 || weaponid == 8) ammo = 2; //si es cortante
        else ammo = 3; //si es contundente
        dmgtaken = amount;
    }
    if(ObjetoInfo[Datos[issuerid][jMano][0]][Tipo] == 5){
        switch(ObjetoInfo[Datos[issuerid][jMano][0]][ModeloObjeto]){
            /*
            4 - 9mm
            5 - .38
            6 - .45ACP
            7 - 12GA
            8 - 7.62x51mm
            9 - 5.56x45mm
            10 - 7.62x39mm
            */
            case -1001: ammo = 4;
            case -1002: ammo = 4;
            case -1003: ammo = 4;
            case -1004: ammo = 7;
            case -1006: ammo = 8;
            case -1007: ammo = 4;
            case -1008: ammo = 9;
            case -1009: ammo = 10;
            case -1010: ammo = 4;
            case -1011: ammo = 9;
            case -1012: ammo = 5;
            case -1013: ammo = 6;
            case -1014: ammo = 9;
            case -1015: ammo = 10;
            case -1022: ammo = 6;
            case -1023: ammo = 9;
            default: dmgtaken = 0;
        }
        switch(ammo){
            case 4:{
                switch(bodypart){
                    case 3:{
                        if(Datos[playerid][jChaleco]) dmgtaken = 0;
                        else dmgtaken = DMG_9MM_TORSO;
                    }
                    case 4: dmgtaken = DMG_9MM_GROIN;
                    case 5: dmgtaken = DMG_9MM_ARMS;
                    case 6: dmgtaken = DMG_9MM_ARMS;
                    case 7: dmgtaken = DMG_9MM_LEGS;
                    case 8: dmgtaken = DMG_9MM_LEGS;
                    case 9: dmgtaken = DMG_9MM_HEAD;
                }
            }
            case 5:{
                switch(bodypart){
                    case 3:{
                        if(Datos[playerid][jChaleco]) dmgtaken = 0;
                        else dmgtaken = DMG_38SPL_TORSO;
                    }
                    case 4: dmgtaken = DMG_38SPL_GROIN;
                    case 5: dmgtaken = DMG_38SPL_ARMS;
                    case 6: dmgtaken = DMG_38SPL_ARMS;
                    case 7: dmgtaken = DMG_38SPL_LEGS;
                    case 8: dmgtaken = DMG_38SPL_LEGS;
                    case 9: dmgtaken = DMG_38SPL_HEAD;
                }
            }
            case 6:{
                switch(bodypart){
                    case 3:{
                        if(Datos[playerid][jChaleco]) dmgtaken = 0;
                        else dmgtaken = DMG_45ACP_TORSO;
                    }
                    case 4: dmgtaken = DMG_45ACP_GROIN;
                    case 5: dmgtaken = DMG_45ACP_ARMS;
                    case 6: dmgtaken = DMG_45ACP_ARMS;
                    case 7: dmgtaken = DMG_45ACP_LEGS;
                    case 8: dmgtaken = DMG_45ACP_LEGS;
                    case 9: dmgtaken = DMG_45ACP_HEAD;
                }
            }
            case 7:{
                switch(bodypart){
                    case 3:{
                        if(Datos[playerid][jChaleco]) dmgtaken = 0;
                        else dmgtaken = DMG_12GA_TORSO;
                    }
                    case 4: dmgtaken = DMG_12GA_GROIN;
                    case 5: dmgtaken = DMG_12GA_ARMS;
                    case 6: dmgtaken = DMG_12GA_ARMS;
                    case 7: dmgtaken = DMG_12GA_LEGS;
                    case 8: dmgtaken = DMG_12GA_LEGS;
                    case 9: dmgtaken = DMG_12GA_HEAD;
                }
            }
            case 8:{
                switch(bodypart){
                    case 3: dmgtaken = DMG_76251_TORSO;
                    case 4: dmgtaken = DMG_76251_GROIN;
                    case 5: dmgtaken = DMG_76251_ARMS;
                    case 6: dmgtaken = DMG_76251_ARMS;
                    case 7: dmgtaken = DMG_76251_LEGS;
                    case 8: dmgtaken = DMG_76251_LEGS;
                    case 9: dmgtaken = DMG_76251_HEAD;
                }
            }
            case 9:{
                switch(bodypart){
                    case 3: dmgtaken = DMG_556_TORSO;
                    case 4: dmgtaken = DMG_556_GROIN;
                    case 5: dmgtaken = DMG_556_ARMS;
                    case 6: dmgtaken = DMG_556_ARMS;
                    case 7: dmgtaken = DMG_556_LEGS;
                    case 8: dmgtaken = DMG_556_LEGS;
                    case 9: dmgtaken = DMG_556_HEAD;
                }
            }
            case 10:{
                switch(bodypart){
                    case 3: dmgtaken = DMG_76239_TORSO;
                    case 4: dmgtaken = DMG_76239_GROIN;
                    case 5: dmgtaken = DMG_76239_ARMS;
                    case 6: dmgtaken = DMG_76239_ARMS;
                    case 7: dmgtaken = DMG_76239_LEGS;
                    case 8: dmgtaken = DMG_76239_LEGS;
                    case 9: dmgtaken = DMG_76239_HEAD;
                }
            }
        }
    }
    if(dmgtaken == 90.0){
        SetPlayerHealth(playerid, 5.0);
        Datos[playerid][jVida] = 5.0;
        //muerte instantanea
        if(muerto[playerid] != 2){
            muerto[playerid] = 2;
            TogglePlayerControllable(playerid, false);
		    ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza. Mueres al instante. 2 minutos para /reaparecer.");
            if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 180000, false, "d", playerid);
        }
        return 1;
    }
    else if(dmgtaken == 85.0){
        if(muerto[playerid] == 0){
            if(random(200) == random(200) || Datos[playerid][jVida] < dmgtaken){
                SetPlayerHealth(playerid, 5.0);
                Datos[playerid][jVida] = 5.0;
                muerto[playerid] = 2;
                TogglePlayerControllable(playerid, false);
		        ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
                SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza, mueres al instante. 2 minutos para /reaparecer.");
                RespawnTimer[playerid] = SetTimerEx("wound_timer", 120000, false, "d", playerid);
            }
        }
        else if(muerto[playerid] == 1){
            SetPlayerHealth(playerid, 5.0);
            Datos[playerid][jVida] = 5.0;
            muerto[playerid] = 2;
            TogglePlayerControllable(playerid, false);
		    ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 60000, false, "d", playerid);
            SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza, mueres al instante. 1 minuto para /reaparecer."); 
        }
    }   
    else if(dmgtaken >= Datos[playerid][jVida]){
        if(!muerto[playerid]){
            SetPlayerHealth(playerid, 28.0);
            Datos[playerid][jVida] = 28.0;
            muerto[playerid] = 1;
            TogglePlayerControllable(playerid, false);
		    ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            SendClientMessage(playerid, COLOR_DARKRED, "Te desplomas debido a tus heridas. 4 minutos para /reaparecer.");
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 240000, false, "d", playerid);
        }
        else if(muerto[playerid] == 1){
            muerto[playerid] = 2;
            SetPlayerHealth(playerid, 5.0);
            Datos[playerid][jVida] = 5.0;
            TogglePlayerControllable(playerid, false);
		    ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 120000, false, "d", playerid);
            SendClientMessage(playerid, COLOR_DARKRED, "Mueres fatalmente debido a las heridas provocadas. 1 minuto para /reaparecer.");
        }
    }
    else if(muerto[playerid] == 1 && dmgtaken < Datos[playerid][jVida]){
        Datos[playerid][jVida]-=dmgtaken;
        SetPlayerHealth(playerid, Datos[playerid][jVida]); 
    }
    else{
        Datos[playerid][jVida]-=dmgtaken;
        SetPlayerHealth(playerid, Datos[playerid][jVida]);        
    }
    for(new i; i < MAX_WOUNDS; i++){
        if(!wound_data[playerid][i][wnd_ammoType]){
            wound_data[playerid][i][wnd_ammoType] = ammo;
            wound_data[playerid][i][wnd_dmgTaken] = dmgtaken;
            wound_data[playerid][i][wnd_bodypart] = bodypart;
            wound_data[playerid][i][wnd_IssuerSQLID] = Datos[issuerid][jSQLIDP];
            if(bodypart == 3 && !dmgtaken) wound_data[playerid][i][wnd_kevlarHit] = 1;
            break;
        }
        else if(i == MAX_WOUNDS-1 && wound_data[playerid][i][wnd_ammoType]){
            clear_wounds(playerid);
            wound_data[playerid][0][wnd_ammoType] = ammo;
            wound_data[playerid][0][wnd_dmgTaken] = dmgtaken;
            wound_data[playerid][0][wnd_bodypart] = bodypart;
            wound_data[playerid][0][wnd_IssuerSQLID] = Datos[issuerid][jSQLIDP];
            if(bodypart == 3 && !dmgtaken) wound_data[playerid][0][wnd_kevlarHit] = 1;
            break;
        }
    }
    return 1;
}
public Wound_TaseHim(playerid, issuerid){
    return 1;
}
public Wound_BeanbagHim(playerid, issuerid){
    return 1;
}
