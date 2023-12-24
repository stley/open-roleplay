forward Wound_HandleDamage(playerid, issuerid, weaponid, bodypart);
forward Wound_TaseHim(playerid, issuerid);



public Wound_HandleDamage(playerid, issuerid, weaponid, bodypart){
    if(issuerid != INVALID_PLAYER_ID && issuerid != playerid){
        if(weaponid == 22) return Wound_TaseHim(playerid, issuerid);
        for(new i; i < sizeof(ObjetoInfo); i++){
            if(ObjetoInfo[i][IDArma] == weaponid && ObjetoInfo[i][Tipo] == 5){
                if(i != Datos[issuerid][jMano][0]) return 1;
                for(new x; x < MAX_WOUNDS; x++){
                    new ammo;
                    if(!wound_data[playerid][x][wnd_ammoType]){
                        switch(ObjetoInfo[i][ModeloObjeto]){
                            //9mm
                            case -1001: ammo = 4;
                            case -1002: ammo = 4;
                            case -1003: ammo = 4;
                            case -1007: ammo = 4;
                            case -1010: ammo = 4;
                            //.45acp
                            case -1013: ammo = 5;
                            //38spl
                            case -1012: ammo = 6;
                            //12GA
                            case -1004: ammo = 7;
                            //beanbag
                            case -1005: ammo = 8;
                            //556
                            case -1008: ammo = 9;
                            case -1014: ammo = 9;
                            case -1011: ammo = 9;
                            //76239
                            case -1009: ammo = 10;
                            case -1015: ammo = 10;
                            //76251
                            case -1006: ammo = 11;

                        } 
                    }
                    if(ObjetoInfo[i][IDArma] == weaponid && ObjetoInfo[i][Tipo] == 4){
                        switch(weaponid)
                        {
                            case 0: ammo = 1;
                            case 1..3: ammo = 2; //Objeto Contundente
                            case 5..7: ammo = 2;
                            case 10..13: ammo = 2;
                            case 15: ammo = 2;
                            //objeto cortante
                            case 4: ammo = 3;
                            case 8: ammo = 3;
                        }
                    }
                    wound_data[playerid][x][wnd_ammoType] = ammo;
                    if(Datos[playerid][jChaleco] && ammo < 8 && bodypart == 3) wound_data[playerid][x][wnd_kevlarHit] = 1;
                    else if(Datos[playerid][jChaleco] && ammo > 8 && bodypart == 3) wound_data[playerid][x][wnd_kevlarHit] = 0;
                    else wound_data[playerid][x][wnd_kevlarHit] = 0;
                    wound_data[playerid][x][wnd_bodypart] = bodypart;
                    wound_data[playerid][x][wnd_IssuerSQLID] = Datos[issuerid][jSQLIDP];
                    SendClientMessage(playerid, COLOR_DARKRED, "%s acaba de atacarte.", GetRPName(issuerid));
                    switch(ammo){
                        case 1:{
                            if(wound_data[playerid][x][wnd_kevlarHit]) wound_data[playerid][x][wnd_dmgTaken] = 0;
                            else wound_data[playerid][x][wnd_dmgTaken] = 5.0;
                        }
                        case 2:{
                            if(wound_data[playerid][x][wnd_kevlarHit]) wound_data[playerid][x][wnd_dmgTaken] = 0;
                            else wound_data[playerid][x][wnd_dmgTaken] = 9.0;
                        } 
                        case 3:{
                            if(wound_data[playerid][x][wnd_kevlarHit])  wound_data[playerid][x][wnd_dmgTaken] = 0.0;
                            else wound_data[playerid][x][wnd_dmgTaken] = 11.0;
                        }
                        case 4:{
                            switch(bodypart){
                                case 3:{
                                    if(!Datos[playerid][jChaleco]){
                                        wound_data[playerid][x][wnd_dmgTaken] = DMG_9MM_TORSO;
                                    }
                                    else wound_data[playerid][x][wnd_dmgTaken] = 0.0;
                                }
                                case 4: wound_data[playerid][x][wnd_dmgTaken] = DMG_9MM_GROIN;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = DMG_9MM_ARMS;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = DMG_9MM_ARMS;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = DMG_9MM_LEGS;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = DMG_9MM_LEGS;   
                                case 9: wound_data[playerid][x][wnd_dmgTaken] = DMG_9MM_HEAD;                     
                            }
                        }
                        case 5:{
                            switch(bodypart){
                                case 3:{
                                    if(!Datos[playerid][jChaleco]){
                                        wound_data[playerid][x][wnd_dmgTaken] = DMG_45ACP_TORSO;
                                    }
                                    else wound_data[playerid][x][wnd_dmgTaken] = 0.0;
                                }
                                case 4: wound_data[playerid][x][wnd_dmgTaken] = DMG_45ACP_GROIN;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = DMG_45ACP_ARMS;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = DMG_45ACP_ARMS;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = DMG_45ACP_LEGS;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = DMG_45ACP_LEGS;   
                                case 9:{
                                    if(Random(0, 10) < 10) wound_data[playerid][x][wnd_dmgTaken] = 90.2;
                                    else wound_data[playerid][x][wnd_dmgTaken] = DMG_45ACP_HEAD;
                                }
                            }
                        }
                        case 6:{
                            switch(bodypart){
                                case 3:{
                                    if(!Datos[playerid][jChaleco]){
                                        wound_data[playerid][x][wnd_dmgTaken] = DMG_38SPL_TORSO;
                                    }
                                    else wound_data[playerid][x][wnd_dmgTaken] = 0.0;
                                }
                                case 4: wound_data[playerid][x][wnd_dmgTaken] = DMG_38SPL_GROIN;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = DMG_38SPL_ARMS;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = DMG_38SPL_ARMS;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = DMG_38SPL_LEGS;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = DMG_38SPL_LEGS;   
                                case 9: wound_data[playerid][x][wnd_dmgTaken] = DMG_38SPL_HEAD;                     
                            }
                        }
                        case 7:{
                            switch(bodypart){
                                case 3:{
                                    if(!Datos[playerid][jChaleco]){
                                        wound_data[playerid][x][wnd_dmgTaken] = DMG_12GA_TORSO;
                                    }
                                    else wound_data[playerid][x][wnd_dmgTaken] = 0.0;
                                }
                                case 4: wound_data[playerid][x][wnd_dmgTaken] = DMG_12GA_GROIN;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = DMG_12GA_ARMS;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = DMG_12GA_ARMS;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = DMG_12GA_LEGS;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = DMG_12GA_LEGS;
                                case 9:{
                                    if(Random(0, 100) > 15) wound_data[playerid][x][wnd_dmgTaken] = DMG_12GA_HEAD;
                                    else wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_HEAD;
                                }
                            }
                        }
                        case 8:{
                            switch(bodypart){
                                case 3:{
                                    if(!Datos[playerid][jChaleco]){
                                        wound_data[playerid][x][wnd_dmgTaken] = 0.2;
                                    }
                                    else wound_data[playerid][x][wnd_dmgTaken] = 1.0;
                                }
                                case 4: wound_data[playerid][x][wnd_dmgTaken] =  1.0;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = 1.0;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = 1.0;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = 1.0;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = 1.0;
                                case 9: wound_data[playerid][x][wnd_dmgTaken] = 90.2;                 
                            }
                        }
                        case 9:{
                            switch(bodypart){
                                case 3: wound_data[playerid][x][wnd_dmgTaken] = DMG_556_TORSO;
                                case 9:{
                                    if(Random(0, 100) < 25) wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_HEAD;
                                    else wound_data[playerid][x][wnd_dmgTaken] = DMG_556_HEAD;
                                }
                                case 4: wound_data[playerid][x][wnd_dmgTaken] = DMG_556_GROIN;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = DMG_556_ARMS;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = DMG_556_ARMS;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = DMG_556_LEGS;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = DMG_556_LEGS;
                            }
                        }
                        case 10:{
                            switch(bodypart){
                                case 3: wound_data[playerid][x][wnd_dmgTaken] = DMG_76239_TORSO;                     
                                case 9:{
                                    if(Random(0, 100) < 30) wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_HEAD;
                                    else wound_data[playerid][x][wnd_dmgTaken] = DMG_76239_HEAD;
                                }
                                case 4: wound_data[playerid][x][wnd_dmgTaken] = DMG_76239_GROIN;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = DMG_76239_ARMS;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = DMG_76239_ARMS;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = DMG_76239_LEGS;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = DMG_76239_LEGS;   
                            }
                        }
                        case 11:{
                            switch(bodypart){
                                case 3: wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_TORSO;                             
                                case 4: wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_GROIN;
                                case 5: wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_ARMS;
                                case 6: wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_ARMS;
                                case 7: wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_LEGS;
                                case 8: wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_LEGS;   
                                case 9: wound_data[playerid][x][wnd_dmgTaken] = DMG_76251_HEAD;                     
                            }
                        }
                    }
                    Wound_LowerLife(playerid, wound_data[playerid][x][wnd_dmgTaken], issuerid);
                    break;
                }   
            }
        }
    }
    return 1;
}
new bool:CanRespawn[MAX_PLAYERS];
new SuccumbTime[MAX_PLAYERS];
new RespawnTime[MAX_PLAYERS];
forward Wound_Succumb(playerid);
forward RespawnTimer(playerid);
Wound_LowerLife(playerid, Float:amount, issuerid){
    new Float:curr_health;
    curr_health = Datos[playerid][jVida];
    SetPlayerArmour(playerid, Datos[playerid][jChaleco]);
    if(amount == DMG_76251_HEAD){
        if(muerto[playerid] == 1){
            SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza. Mueres al instante.");
            SendClientMessage(playerid, COLOR_DARKRED, "Acabas de morir. Utiliza /reaparecer para aparecer en el hospital más cercano luego de 90 segundos.");
            SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu fallecimiento? Utiliza /npc (0 - Policía | 1 - Emergencias)  [Denuncia].");
            if(issuerid != INVALID_PLAYER_ID)alm(asesino[playerid], GetName(issuerid));
            muerto[playerid] = 2;
            if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
            RespawnTime[playerid] = SetTimerEx("RespawnTimer", 90000, false, "d", playerid);
            TogglePlayerControllable(playerid, false);
            SetPlayerChatBubble(playerid, "((Este personaje está muerto.))", COLOR_RED, 30.0, -1);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, false, false, false, true, 0, SYNC_ALL);
            return 1;
        }
        SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza. No llegas ni a oír el disparo ya que la bala atraviesa antes tu masa encefálica.");
        SendClientMessage(playerid, COLOR_DARKRED, "Acabas de morir. Utiliza /reaparecer para aparecer en el hospital más cercano luego de 90 segundos.");
        SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu fallecimiento? Utiliza /npc (0 - Policía | 1 - Emergencias)  [Denuncia].");
        muerto[playerid] = 2;
        if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
        RespawnTime[playerid] = SetTimerEx("RespawnTimer", 90000, false, "d", playerid);
        TogglePlayerControllable(playerid, false);
        SetPlayerChatBubble(playerid, "((Este personaje está muerto.))", COLOR_RED, 30.0, -1);
        ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, false, false, false, true, 0, SYNC_ALL);
        alm(asesino[playerid], GetName(issuerid));
        return 1;
    }
    else if(amount == 90.2){
        if(muerto[playerid] == 1){
            SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza. Mueres al instante.");
            SendClientMessage(playerid, COLOR_DARKRED, "Acabas de morir. Utiliza /reaparecer para aparecer en el hospital más cercano luego de 90 segundos.");
            SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu fallecimiento? Utiliza /npc (0 - Policía | 1 - Emergencias)  [Denuncia].");
            if(issuerid != INVALID_PLAYER_ID)alm(asesino[playerid], GetName(issuerid));
            muerto[playerid] = 2;
            if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
            RespawnTime[playerid] = SetTimerEx("RespawnTimer", 90000, false, "d", playerid);
            TogglePlayerControllable(playerid, false);
            SetPlayerChatBubble(playerid, "((Este personaje está muerto.))", COLOR_RED, 30.0, -1);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, false, false, false, true, 0, SYNC_ALL);
            return 1;
        }
        new randy = Random(0, 100);
        if(randy >= 75 && randy <= 80){
            muerto[playerid] = 1;
            if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
            RespawnTime[playerid] = SetTimerEx("RespawnTimer", 300000, false, "d", playerid);
            SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza. Mueres al instante... ¿no?");
            SendClientMessage(playerid, COLOR_DARKRED, "Parece haber esperanza. Tienes 2 minutos para recibir atención antes de morir.");
            SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu agonía? Utiliza /npc (0 - Policía | 1 - Emergencias) [Denuncia].");
            if(issuerid != INVALID_PLAYER_ID) alm(asesino[playerid], GetName(issuerid));
            SuccumbTime[playerid] = SetTimerEx("Wound_Succumb", 120000, false, "d", playerid);
            TogglePlayerControllable(playerid, false);
            SetPlayerChatBubble(playerid, "((Este personaje está herido de gravedad. Utiliza /heridas %d para más información.))", COLOR_RED, 30.0, -1);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, false, false, false, true, 0, SYNC_ALL);
            return 1;
        }
        SendClientMessage(playerid, COLOR_DARKRED, "Recibes un disparo en la cabeza. Caes desplomado al suelo como un muñeco y mueres al instante.");
        SendClientMessage(playerid, COLOR_DARKRED, "Acabas de morir. Utiliza /reaparecer para aparecer en el hospital más cercano luego de 90 segundos.");
        SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu fallecimiento? Utiliza /npc (0 - Policía | 1 - Emergencias)  [Denuncia].");
        muerto[playerid] = 2;
        if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
        RespawnTime[playerid] = SetTimerEx("RespawnTimer", 90000, false, "d", playerid);
        if(issuerid != INVALID_PLAYER_ID) alm(asesino[playerid], GetName(issuerid));
        TogglePlayerControllable(playerid, false);
        SetPlayerChatBubble(playerid, "((Este personaje está muerto.))", COLOR_RED, 30.0, -1);
        ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, false, false, false, true, 0, SYNC_ALL);
        return 1;
    }
    if(curr_health <= amount || curr_health-amount <= 10.0){
        
        if(!muerto[playerid]){
            SetPlayerHealth(playerid, 15.0);
            Datos[playerid][jVida] = 15.0;
            muerto[playerid] = 1;
            if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
            RespawnTime[playerid] = SetTimerEx("RespawnTimer", 300000, false, "d", playerid);
            SendClientMessage(playerid, COLOR_DARKRED, "La gravedad de tus heridas te hace desplomarte en el suelo. Mantienes la conciencia a duras penas, o no.");
            SendClientMessage(playerid, COLOR_DARKRED, "Estás herido de gravedad. Puedes /reaparecer luego de unos 5 minutos.");
            SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu agonía? Utiliza /npc (0 - Policía | 1 - Emergencias) [Denuncia].");
            if(issuerid != INVALID_PLAYER_ID) alm(asesino[playerid], GetName(issuerid));
            TogglePlayerControllable(playerid, false);
            SetPlayerChatBubble(playerid, "((Este personaje está herido de gravedad. Utiliza /heridas %d para más información.))", COLOR_RED, 30.0, -1);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, false, false, false, true, 0, SYNC_ALL);
            return 1;
        }
        else if (muerto[playerid] == 1){
            SetPlayerHealth(playerid, 5.0);
            Datos[playerid][jVida] = 5.0;
            SendClientMessage(playerid, COLOR_DARKRED, "Finalmente sucumbes a tus heridas, no hay nada más que hacer.");
            SendClientMessage(playerid, COLOR_DARKRED, "Acabas de morir. Utiliza /reaparecer para aparecer en el hospital más cercano luego de 90 segundos.");
            SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu fallecimiento? Utiliza /npc (0 - Policía | 1 - Emergencias) [Denuncia].");
            muerto[playerid] = 2;
            if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
            RespawnTime[playerid] = SetTimerEx("RespawnTimer", 90000, false, "d", playerid);
            if(issuerid != INVALID_PLAYER_ID) alm(asesino[playerid], GetName(issuerid));
            TogglePlayerControllable(playerid, false);
            SetPlayerChatBubble(playerid, "((Este personaje está muerto.))", COLOR_RED, 30.0, -1);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, false, false, false, true, 0, SYNC_ALL);
            return 1;
        }
        else if (muerto[playerid] == 2){
            SetPlayerHealth(playerid, 3.0);
            Datos[playerid][jVida] = 3.0;
            return 1;
        }
    }
    SetPlayerHealth(playerid, curr_health-amount);
    Datos[playerid][jVida]=-amount;
    if(curr_health-amount < 28){
        SendClientMessage(playerid, COLOR_DARKRED, "Estás herido gravemente. El golpe de adrenalina es lo que te mantiene arriba, pero tus facultades se reducen considerablemente.");
	    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 100);
	    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 100);
        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 99);
        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 99);
        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 99);
        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 80);
        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 99);
    }
    return 1;
}
public RespawnTimer(playerid){
    CanRespawn[playerid] = true;
    SendClientMessage(playerid, COLOR_DARKRED, "Ya puedes utilizar /reaparecer.");
    return 1;
}
public Wound_Succumb(playerid){
    muerto[playerid] = 2;
    SendClientMessage(playerid, COLOR_DARKRED, "Finalmente sucumbes a tus heridas, no hay nada más que hacer.");
    SendClientMessage(playerid, COLOR_DARKRED, "Acabas de morir. Utiliza /reaparecer para aparecer en el hospital más cercano luego de 90 segundos.");
    SendClientMessage(playerid, COLOR_DARKRED, "Considerando el entorno, ¿crees realista que se notifique a las autoridades y/o a los servicios de emergencia de tu fallecimiento? Utiliza /npc (0 - Policía | 1 - Emergencias) [Denuncia].");
    if(IsValidTimer(RespawnTime[playerid])) KillTimer(RespawnTime[playerid]);
    SetPlayerChatBubble(playerid, "((Este personaje está muerto.))", COLOR_RED, 30.0, -1);
    RespawnTime[playerid] = SetTimerEx("RespawnTimer", 90000, false, "d", playerid);
    return 1;
}
public Wound_TaseHim(playerid, issuerid){
    return 1;
}


