forward woundHandleDamage(playerid, issuerid, weaponid, bodypart, Float:amount);
forward woundTaser(playerid, issuerid);
forward woundBeanbag(playerid, issuerid);
forward Wound_Succumb(playerid);
forward wound_timer(playerid);

//4 - 9mm
            //5 - .38
            //6 - .45ACP
            //7 - 12GA
            //8 - 7.62x51mm
            //9 - 5.56x45mm
            //10 - 7.62x39mm
#define WOUND_AMMO_FIST (1)
#define WOUND_AMMO_SHARP (2)
#define WOUND_AMMO_HARD (3)
#define WOUND_AMMO_9MM  (4)
#define WOUND_AMMO_38SPL (5)
#define WOUND_AMMO_45ACP (6)
#define WOUND_AMMO_12GA (7)
#define WOUND_AMMO_76251 (8)
#define WOUND_AMMO_556 (9)
#define WOUND_AMMO_76239 (10)


clear_wounds(playerid){
    for(new i; i < MAX_WOUNDS; i++){
        wound_data[playerid][i][wnd_ammoType] = 0;
        wound_data[playerid][i][wnd_dmgTaken] = 0.0;
        wound_data[playerid][i][wnd_bodypart] = 0;
        wound_data[playerid][i][wnd_kevlarHit] = 0;
        wound_data[playerid][i][wnd_IssuerSQLID] = -1;
    }
}

public woundTaser(playerid, issuerid){
    return 1;
}
public woundBeanbag(playerid, issuerid){
    return 1;
}

public woundHandleDamage(playerid, issuerid, weaponid, bodypart, Float:amount){

    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(issuerid)) return 0;
    new
        ammo,
        Float:dmgtaken
    ;
    if(playerid == issuerid){
        SetPlayerHealth(playerid, Datos[playerid][jVida]-amount);
        Datos[playerid][jVida] -= amount;
        return 1;
    }
    SetPlayerHealth(playerid, Datos[playerid][jVida]);
    SetPlayerArmour(playerid, Datos[playerid][jChaleco]);
    if(issuerid == INVALID_PLAYER_ID) return 1;
    if(weaponid != ObjetoInfo[Datos[issuerid][jMano][0]][IDArma]) return 1;
    if(weaponid == 22) return woundTaser(playerid, issuerid);
    if(weaponid == 25 && ObjetoInfo[Datos[issuerid][jMano][0]][ModeloObjeto] == -1005) return woundBeanbag(playerid, issuerid);
    
    if(weaponid == 0 &&  Datos[issuerid][jManoCant][0] == 0){
        ammo = WOUND_AMMO_FIST;
        dmgtaken = amount;
    }
    if(ObjetoInfo[Datos[issuerid][jMano][0]][Tipo] == 4){
        if(weaponid == 4 || weaponid == 8) ammo = WOUND_AMMO_SHARP; //si es cortante
        else ammo = WOUND_AMMO_HARD; //si es contundente
        dmgtaken = amount;
    }
    if(ObjetoInfo[Datos[issuerid][jMano][0]][Tipo] == 5){
        switch(ObjetoInfo[Datos[issuerid][jMano][0]][ModeloObjeto]){

            //4 - 9mm
            //5 - .38
            //6 - .45ACP
            //7 - 12GA
            //8 - 7.62x51mm
            //9 - 5.56x45mm
            //10 - 7.62x39mm
            
            case -1001: ammo = WOUND_AMMO_9MM;
            case -1002: ammo = WOUND_AMMO_9MM;
            case -1003: ammo = WOUND_AMMO_9MM;
            case -1004: ammo = WOUND_AMMO_12GA;
            case -1006: ammo = WOUND_AMMO_76251;
            case -1007: ammo = WOUND_AMMO_9MM;
            case -1008: ammo = WOUND_AMMO_556;
            case -1009: ammo = WOUND_AMMO_76239;
            case -1010: ammo = WOUND_AMMO_9MM;
            case -1011: ammo = WOUND_AMMO_556;
            case -1012: ammo = WOUND_AMMO_38SPL;
            case -1013: ammo = WOUND_AMMO_45ACP;
            case -1014: ammo = WOUND_AMMO_556;
            case -1015: ammo = WOUND_AMMO_76239;
            case -1022: ammo = WOUND_AMMO_45ACP;
            case -1023: ammo = WOUND_AMMO_556;
            case -1025: ammo = WOUND_AMMO_9MM;
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

    
    // Handle instant death (90.0 damage - high caliber headshots)
    if(dmgtaken == 90.0){
        SetPlayerHealth(playerid, 5.0);
        Datos[playerid][jVida] = 5.0;
        if(muerto[playerid] != 2){
            muerto[playerid] = 2;
            TogglePlayerControllable(playerid, false);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza. Mueres al instante. 3 minutos para /reaparecer.");
            if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 180000, false, "d", playerid);
        }
        recordWoundData(playerid, issuerid, ammo, dmgtaken, bodypart);
        return 1;
    }
    
    // Handle potential headshot death (85.0 damage)
    else if(dmgtaken == 85.0){
        if(muerto[playerid] == 0){
            // Healthy player - random chance or insufficient health
            if(random(200) == random(200) || Datos[playerid][jVida] <= dmgtaken){
                SetPlayerHealth(playerid, 5.0);
                Datos[playerid][jVida] = 5.0;
                muerto[playerid] = 2;
                TogglePlayerControllable(playerid, false);
                ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
                SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza, mueres al instante. 2 minutos para /reaparecer.");
                if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
                RespawnTimer[playerid] = SetTimerEx("wound_timer", 120000, false, "d", playerid);
            }
            else {
                // Player survives the headshot but takes damage
                Datos[playerid][jVida] -= dmgtaken;
                if(Datos[playerid][jVida] <= 0.0) Datos[playerid][jVida] = 1.0; // Minimum health
                SetPlayerHealth(playerid, Datos[playerid][jVida]);
            }
        }
        else if(muerto[playerid] == 1){
            // Already wounded - headshot kills them
            SetPlayerHealth(playerid, 5.0);
            Datos[playerid][jVida] = 5.0;
            muerto[playerid] = 2;
            TogglePlayerControllable(playerid, false);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 60000, false, "d", playerid);
            SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza, mueres al instante. 1 minuto para /reaparecer."); 
        }
        recordWoundData(playerid, issuerid, ammo, dmgtaken, bodypart);
        return 1;
    }   
    
    // Handle damage that would incapacitate or kill
    else if(dmgtaken >= Datos[playerid][jVida]){
        if(muerto[playerid] == 0){
            // Healthy player becomes wounded/unconscious
            SetPlayerHealth(playerid, 28.0);
            Datos[playerid][jVida] = 28.0;
            muerto[playerid] = 1;
            TogglePlayerControllable(playerid, false);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            SendClientMessage(playerid, COLOR_DARKRED, "Te desplomas debido a tus heridas. 4 minutos para /reaparecer.");
            if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 240000, false, "d", playerid);
        }
        else if(muerto[playerid] == 1){
            // Already wounded - additional damage kills them
            muerto[playerid] = 2;
            SetPlayerHealth(playerid, 5.0);
            Datos[playerid][jVida] = 5.0;
            TogglePlayerControllable(playerid, false);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, false, false, true, true, 300000, SYNC_ALL);
            if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
            RespawnTimer[playerid] = SetTimerEx("wound_timer", 120000, false, "d", playerid);
            SendClientMessage(playerid, COLOR_DARKRED, "Mueres fatalmente debido a las heridas provocadas. 2 minutos para /reaparecer.");
        }
    }
    
    else {
        if(muerto[playerid] == 0){
            // Healthy player takes normal damage
            Datos[playerid][jVida] -= dmgtaken;
            if(Datos[playerid][jVida] <= 0.0) Datos[playerid][jVida] = 1.0; // Minimum health to prevent death
            SetPlayerHealth(playerid, Datos[playerid][jVida]);
        }
        else if(muerto[playerid] == 1){
            // Wounded player takes additional damage (but not enough to kill)
            Datos[playerid][jVida] -= dmgtaken;
            if(Datos[playerid][jVida] <= 0.0) Datos[playerid][jVida] = 1.0; // Keep them wounded, not dead
            SetPlayerHealth(playerid, Datos[playerid][jVida]);
        }
        // If muerto[playerid] == 2, they're already dead, no need to process damage
    }
    
    // Record wound data
    recordWoundData(playerid, issuerid, ammo, dmgtaken, bodypart);
    return 1;
}

// Helper function to record wound data (same as before)
recordWoundData(playerid, issuerid, ammo, Float:dmgtaken, bodypart) {
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
}

// Improved wound_timer with cleanup
public wound_timer(playerid){
    CanRespawn[playerid] = true;
    if(IsValidTimer(RespawnTimer[playerid])) KillTimer(RespawnTimer[playerid]);
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Ya puedes utilizar el comando /reaparecer.");
    return 1;
}
