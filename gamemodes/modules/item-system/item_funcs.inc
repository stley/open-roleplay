#include "modules/account-management/account_vars"

forward update_manos(playerid);
forward update_torso(playerid);
tirar_objeto(sueloid){
    new ObjetoID = EnSuelo[sueloid][floor_ObjetoID];
    if(!ObjetoID) return 1;
    for(new i; i < MAX_SUELO; i++){
        if(i == sueloid) continue;
        if(EnSuelo[i][floor_posX] == EnSuelo[sueloid][floor_posX] && EnSuelo[i][floor_posY] == EnSuelo[sueloid][floor_posY] && EnSuelo[i][floor_posZ] == EnSuelo[sueloid][floor_posZ] && EnSuelo[i][floor_VW] == EnSuelo[sueloid][floor_VW])
        EnSuelo[sueloid][floor_posY]+=0.2;
        break;
    }
    SueloObj[sueloid] = CreateDynamicObject(ObjetoInfo[ObjetoID][ModeloObjeto], EnSuelo[sueloid][floor_posX], EnSuelo[sueloid][floor_posY], EnSuelo[sueloid][floor_posZ]-1, 80.0, 0, 0, EnSuelo[sueloid][floor_VW]);
    return 1;
}

public update_torso(playerid){
    new espalda = Datos[playerid][jEspalda];
    new pecho = Datos[playerid][jPecho];
    if(espalda){
        if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid, 2);    
        ColocarObjeto(playerid, 2, espalda);
    }
    else if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid, 2);
    
    if(pecho){
        if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
        ColocarObjeto(playerid, 3, pecho);
    }
    else if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
}
ColocarObjeto(playerid, slot, objeto)
{
    // slot 0 - Mano Derecha
    // slot 1 - Mano Izquierda
    // slot 2 - Espalda
    // slot 3 - Pecho
    
    switch(slot)
    {
        case 0: //Mano Derecha
        {
            new modelo = ObjetoInfo[objeto][ModeloObjeto];
            if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid, 0);
            switch(modelo){
                case 19995: SetPlayerAttachedObject(playerid, 0, modelo, 6, 0.08);
                case -1024: SetPlayerAttachedObject(playerid, 0, modelo, 6, 0.08);
                default: SetPlayerAttachedObject(playerid, 0, modelo, 6);
            }
        }
        case 1: //Mano Izquierda
        {
            new modelo = ObjetoInfo[objeto][ModeloObjeto];
            if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
            if(ObjetoInfo[objeto][IDArma])
            {
                switch(ObjetoInfo[objeto][IDArma])
                {
		            case 22: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.050999, 0.038000, -0.021999, 144.500015, 9.100000, -11.600002, 1.000000, 1.000000, 1.000000); //- 45. Colt
                    case 23: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.033000, 0.057999, -0.017999, 146.299987, 14.999998, -4.700002, 1.000000, 1.000000, 1.000000); //- 45. Colt + silenciador
		            case 24: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.041000, 0.038000, -0.026999, 173.899963, 0.000000, 1.799999, 1.000000, 1.000000, 1.000000); //- Desert Eagle
		            case 25: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.000000, 0.089000, 0.000000, 153.500015, 10.000001, 4.800000, 1.000000, 1.000000, 1.000000); //- Escopeta
		            case 28: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.024999, 0.048000, -0.012000, 172.000076, -3.099988, -2.099991, 1.000000, 1.000000, 1.000000); //- UZI
		            case 32: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.048000, 0.049999, 0.011000, -172.600006, -2.299995, 5.999999, 1.000000, 1.000000, 1.000000); //- Tec9
		            case 29: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.005000, 0.065000, -0.016000, 162.399963, 9.599999, 8.400000, 1.000000, 1.000000, 1.000000); //- MP5
		            case 30: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.057999, 0.076999, -0.023999, 162.799942, 14.399999, 0.000000, 1.000000, 1.000000, 1.000000); //- AK47
		            case 31: SetPlayerAttachedObject(playerid, 1, modelo, 5, 0.043999, 0.028999, -0.038000, 167.499969, 15.999998, 0.000000, 1.000000, 1.000000, 1.000000); //- M4
		            case 33: SetPlayerAttachedObject(playerid, 1, modelo, 5, -0.043000, 0.065999, -0.044999, 167.499954, 17.399999, 0.000000, 1.000000, 1.000000, 1.000000); //- Rifle de caza
		            case 34: SetPlayerAttachedObject(playerid, 1, modelo, 5, -0.018000, 0.085000, 0.033000, 167.399978, 12.200000, -0.299997, 1.000000, 1.000000, 1.000000); //- Rifle de francotirador
                    default: SetPlayerAttachedObject(playerid, 1, modelo, 5);
                }
            }
            else if(modelo == 19995 || modelo == -1024) SetPlayerAttachedObject(playerid, 0, modelo, 5, 0.08);
            else SetPlayerAttachedObject(playerid, 1, modelo, 5);
        }
        case 2:{
            new modelo = ObjetoInfo[objeto][ModeloObjeto];
            switch(ObjetoInfo[objeto][IDArma]){
                case 22: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.133999, -0.051000, -0.129000, -178.700073, 139.699966, 0.000000, 1.000000, 1.000000, 1.000000); //colt45 - Taser
                case 23: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.047000, -0.095999, -0.157998, -174.600128, 143.799514, -14.100011, 1.000000, 1.000000, 1.000000); // silenced - Glocks 19-17
                case 24: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.063999, -0.083999, -0.184000, -8.799997, 44.500000, -174.200042, 1.000000, 1.000000, 1.000000); //DEAGLE - .38 y 1911
                case 25: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.220000, -0.135998, 0.113000, -1.900013, 161.699951, 8.599991, 1.000000, 1.000000, 1.000000); //- Escopeta
				case 28: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.120001, -0.091000, -0.120000, 10.099695, 40.400428, 167.399795, 1.000000, 1.000000, 1.000000); // UZI - GLOCK 18
                case 29: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.205000, -0.136998, 0.156000, -1.500012, 152.599945, 5.399990, 1.000000, 1.000000, 1.000000); //- MP5K
				case 30: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.251000, -0.130998, 0.135999, -1.500012, 152.599945, 5.399990, 1.000000, 1.000000, 1.000000); //- AK47
				case 31: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.251000, -0.130998, 0.135999, -1.500012, 152.599945, 5.399990, 1.000000, 1.000000, 1.000000); //- M4
				case 32: SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.230000, -0.156000, 0.092999, 0.799999, 158.100021, 0.100001, 1.000000, 1.000000, 1.000000); // TEC9
                case 33: SetPlayerAttachedObject(playerid, 2, modelo, 1, -0.050000, -0.133999, 0.026000, -2.100004, 32.799995, 1.899993, 1.000000, 1.000000, 1.000000); //- Rifle de caza
				case 34: SetPlayerAttachedObject(playerid, 2, modelo, 1, -0.089000, -0.172999, 0.000000, -11.200003, 32.799995, 9.599994, 1.000000, 1.000000, 1.000000); //- Rifle de francotirador
                default: SetPlayerAttachedObject(playerid, 2, modelo, 1, -0.116, 0.189, 0.088, 0.0, 44.5, 0.0, 1.000000, 1.000000, 1.000000);
            }
            if(strcmp(ObjetoInfo[objeto][NombreObjeto], "Mochila") == 0) SetPlayerAttachedObject(playerid, 2, modelo, 1, 0.028999, -0.129997, -0.004999, -1.900012, 90.000000, 4.299992, 1.000000, 1.000000, 1.000000);
        }
        case 3:{
            new modelo = ObjetoInfo[objeto][ModeloObjeto];
            if(ObjetoInfo[objeto][Tipo] == 5){
                    switch(ObjetoInfo[objeto][IDArma]){
                    case 22: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.147000, 0.209000, -0.113000, 177.199859, 159.599990, 0.000000, 1.000000, 1.000000, 1.000000); //colt45 - taser
                    case 23: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.178000, 0.164000, -0.137000, 0.199999, 39.900104, 168.000015, 1.000000, 1.000000, 1.000000); // silenced - Glocks 19-17
                    case 24: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.186999, 0.125999, -0.132999, 1.199998, 25.200027, 162.899612, 1.000000, 1.000000, 1.000000); //DEAGLE - .38 y 1911
                    case 25: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.234999, 0.162998, -0.160000, -181.900009, 161.699951, -9.300038, 1.000000, 1.000000, 1.000000); //- Escopeta
			    	case 28: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.199000, 0.171000, -0.156000, 6.199996, 42.800209, 165.099060, 1.000000, 1.000000, 1.000000); // UZI - GLOCK 18
                    case 29: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.168999, 0.154998, -0.156000, -181.500015, 152.599945, -10.700008, 1.000000, 1.000000, 1.000000); //- MP5K
			    	case 30: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.194999, 0.163997, -0.167999, -181.500015, 152.599945, -6.599994, 1.000000, 1.000000, 1.000000); //- AK47
			    	case 31: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.212000, 0.152998, -0.164999, -181.500015, 152.599945, -12.300017, 1.000000, 1.000000, 1.000000); //- M4
                    case 32: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.211001, 0.175000, -0.129998, -174.600128, 144.199874, -14.100011, 1.000000, 1.000000, 1.000000); // TEC9
			    	case 33: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.193001, 0.163999, -0.130000, 3.499947, 32.799995, 166.599609, 1.000000, 1.000000, 1.000000); //- Rifle de caza
			    	case 34: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.172999, 0.166999, -0.175000, -177.100234, 152.799865, -15.399977, 1.000000, 1.000000, 1.000000); //- Rifle de francotirador
                    default: SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.116, -0.189, -0.088, 0.0, -135.5, 0.0, 1.000000, 1.000000, 1.000000);
                }
            }
            if(strcmp(ObjetoInfo[objeto][NombreObjeto], "Mochila") == 0) SetPlayerAttachedObject(playerid, 3, modelo, 1, 0.029999, 0.135997, -0.001999, -179.900009, 90.000000, 2.199994, 1.000000, 1.000000, 1.000000);
        }
    }
    return 1;
}
sacar_bol(playerid, slot)
{
    new manoder = Datos[playerid][jMano][0];
    new manoizq = Datos[playerid][jMano][1];
    new bolsillo = Datos[playerid][jBolsillo][slot];
    new bolsillocant = Datos[playerid][jBolsilloCant][slot];
    new bolsillodata = Datos[playerid][jBolsilloData][slot];
    if(!bolsillo){
        SendClientMessage(playerid, COLOR_DARKRED, "No tienes nada en ese slot.");
        return 0;
    } 
    if(bolsillocant > ObjetoInfo[bolsillo][Capacidad]) Datos[playerid][jBolsilloCant][slot] = ObjetoInfo[bolsillo][Capacidad];
    if(manoder)
    {
        if(manoizq){
            SendClientMessage(playerid, COLOR_DARKRED, "Tienes ambas manos ocupadas. Tira o guarda algo para poder sacar cosas de tus bolsillos.");
            return 0;
        }
        else
        {
            new msg[96];
            Datos[playerid][jMano][1] = bolsillo;
            Datos[playerid][jManoCant][1] = bolsillocant;
            Datos[playerid][jManoData][1] = bolsillodata;
            formatt(msg, "Sacas tu(s) %s de tus bolsillos.", ObjetoInfo[bolsillo][NombreObjeto]);
            Datos[playerid][jBolsillo][slot] = 0;
            Datos[playerid][jBolsilloCant][slot] = 0;
            Datos[playerid][jBolsilloData][slot] = 0;
            SendClientMessage(playerid, COLOR_DARKGREEN, msg);
            update_manos(playerid);
            return 1;
        }
    }
    else
    {
        new msg[96];
        Datos[playerid][jMano][0] = bolsillo;
        Datos[playerid][jManoCant][0] = bolsillocant;
        Datos[playerid][jManoData][0] = bolsillodata;
        formatt(msg, "Sacas tu(s) %s de tus bolsillos.", ObjetoInfo[bolsillo][NombreObjeto]);
        Datos[playerid][jBolsillo][slot] = 0;
        Datos[playerid][jBolsilloCant][slot] = 0;
        Datos[playerid][jBolsilloData][slot] = 0;
        SendClientMessage(playerid, COLOR_DARKGREEN, msg);
        update_manos(playerid);
        return 1;
    }
}

guardar_bol(playerid, mano)
{
    new _mano = Datos[playerid][jMano][mano];
    new _manocant = Datos[playerid][jManoCant][mano];
    new _manodata = Datos[playerid][jManoData][mano];
    if(!ObjetoInfo[_mano][Guardable]){
        SendClientMessageToAll(COLOR_RED, "No puedes guardar este objeto ya que es demasiado grande.");
        return 0;
    }
    for(new i; i < 5; i++)
    {
        if(!Datos[playerid][jBolsillo][i])
        {
            new msg[96];
            Datos[playerid][jBolsillo][i] = _mano;
            if(ObjetoInfo[_mano][Capacidad] < _manocant) Datos[playerid][jBolsilloCant][i] = ObjetoInfo[_mano][Capacidad];
            else Datos[playerid][jBolsilloCant][i] = _manocant;
            Datos[playerid][jBolsilloData][i] = _manodata;
            formatt(msg, "Guardas tu %s en tus bolsillos. (slot: %d)", ObjetoInfo[_mano][NombreObjeto], i);
            Datos[playerid][jMano][mano] = 0;
            Datos[playerid][jManoCant][mano] = 0;
            Datos[playerid][jManoData][mano] = 0;
            SendClientMessage(playerid, COLOR_DARKGREEN, msg);
            update_manos(playerid);
            return 1;
        }
    }
    return 1;
}
public update_manos(playerid)
{
    new manoder = Datos[playerid][jMano][0];
    new manoizq = Datos[playerid][jMano][1];
    if(Datos[playerid][jManoCant][0] > ObjetoInfo[manoder][Capacidad]) Datos[playerid][jManoCant][0] = ObjetoInfo[manoder][Capacidad];
    if(Datos[playerid][jManoCant][1] > ObjetoInfo[manoizq][Capacidad]) Datos[playerid][jManoCant][1] = ObjetoInfo[manoizq][Capacidad];
    if(!manoder){
        Datos[playerid][jManoCant][0] = 0;
        Datos[playerid][jManoData][0] = 0;
    }
    if(!manoizq){
        Datos[playerid][jManoCant][1] = 0;
        Datos[playerid][jManoData][1] = 0;
    }
    if(manoder){
        if(ObjetoInfo[manoder][IDArma])
        {
            new idArma = ObjetoInfo[manoder][IDArma];
            new Balas = Datos[playerid][jManoCant][0];
            ResetPlayerWeapons(playerid);
            /*if(Balas)
            {
                if(Balas < GetPlayerAmmo(playerid))
                {
                    ResetPlayerWeapons(playerid);
                    GivePlayerWeapon(playerid, WEAPON:idArma, Balas);
                }
                if(Balas > GetWeaponMagCapacity(WEAPON:idArma)) GivePlayerWeapon(playerid, WEAPON:idArma, GetWeaponMagCapacity(WEAPON:idArma));
                else GivePlayerWeapon(playerid, WEAPON:idArma, Balas);
            }*/
            if(Balas >= 1){
                ResetPlayerWeapons(playerid);
                GivePlayerWeapon(playerid, WEAPON:idArma, 10500);
            }
            if(ObjetoInfo[manoder][Tipo] == 5){
                
                PlayerTextDrawSetString(playerid, Gun_Hud[playerid][0], "%s", ObjetoInfo[manoder][NombreObjeto]);
                PlayerTextDrawSetString(playerid, Gun_Hud[playerid][1], "%d/%d", Balas, ObjetoInfo[manoder][Capacidad]);
                PlayerTextDrawShow(playerid, Gun_Hud[playerid][0]);
                PlayerTextDrawShow(playerid, Gun_Hud[playerid][1]);
                if(Datos[playerid][jManoCant][0] == -1) PlayerTextDrawHide(playerid, Gun_Hud[playerid][1]);
            }
            if(ObjetoInfo[manoder][IDArma] == 30) SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
            if(ObjetoInfo[manoder][ModeloObjeto] == -1024){
                SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 0);
            }
            ColocarObjeto(playerid, 0, manoder);
        }
        else{
            ColocarObjeto(playerid, 0, manoder);
            PlayerTextDrawHide(playerid, Gun_Hud[playerid][0]);
            PlayerTextDrawHide(playerid, Gun_Hud[playerid][1]);
        }
    }
    else{
        ResetPlayerWeapons(playerid);
        PlayerTextDrawHide(playerid, Gun_Hud[playerid][0]);
        PlayerTextDrawHide(playerid, Gun_Hud[playerid][1]);
        if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid, 0);
    }
    if(manoizq) ColocarObjeto(playerid, 1, manoizq);
    else{
        if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
    }
    return 1;
}
/*GetWeaponMagCapacity(WEAPON:weaponid)
{
    switch(weaponid)
    {
        case WEAPON_DEAGLE: return 7;
        case WEAPON_SILENCED: return 17;
        case WEAPON_COLT45: return 17;
        case WEAPON_AK47: return 30;
        case WEAPON_M4: return 50;
        case WEAPON_TEC9: return 50;
        case WEAPON_UZI: return 50;
        case WEAPON_MP5: return 30;
        case WEAPON_SHOTGUN: return 8;
        case WEAPON_SNIPER: return 6;
        case WEAPON_RIFLE: return 20;
        case WEAPON_SPRAYCAN: return 500;
        default: return 1;
    }
    return 0;
}*/

find_mag(objectid){
    if(ObjetoInfo[objectid][Tipo] != 5){
        return 0;
    }
    if(strcmp(ObjetoInfo[objectid][NombreObjeto], "Revolver .38") == 0){
        for(new i; i < sizeof(ObjetoInfo); i++){
            if(strcmp(ObjetoInfo[i][NombreObjeto], "Munición .38") == 0){
                return i;
            }
            else continue;
        }
        return 0;
    }
    else if(strcmp(ObjetoInfo[objectid][NombreObjeto], "Remington 870") == 0){
        for(new i; i < sizeof(ObjetoInfo); i++){
            if(strcmp(ObjetoInfo[i][NombreObjeto], "Cartuchos 12GA") == 0){
                return i;
            }
            else continue;
        }
        return 0;
    }
    for(new i; i < sizeof(ObjetoInfo); i++){
        if(ObjetoInfo[i][Tipo] == 6){
            if(strfind(ObjetoInfo[i][NombreObjeto], ObjetoInfo[objectid][NombreObjeto]) != -1){
                return i;
            }
            else continue;
        }
        else continue;
    }
    return 0;
}
GetToyIndex(objectid, &index, &bone){
    if(strfind(ObjetoInfo[objectid][NombreObjeto], "Gorro") != -1 || strfind(ObjetoInfo[objectid][NombreObjeto], "Casco") != -1 || strfind(ObjetoInfo[objectid][NombreObjeto], "Sombrero") != -1 || strfind(ObjetoInfo[objectid][NombreObjeto], "Gorra") != -1 || strfind(ObjetoInfo[objectid][NombreObjeto], "Jockey") != -1){
        index = 4; //index 4 - cascos y gorras en general
        bone = 2; //bone head
    }
    else if(strfind(ObjetoInfo[objectid][NombreObjeto], "Lentes") != -1 || strfind(ObjetoInfo[objectid][NombreObjeto], "Gafas") != -1){
        index = 5; //index 5 - lentes
        bone = 2; //bone head
    }
    else if(strfind(ObjetoInfo[objectid][NombreObjeto], "Pañuelo") != -1 || strfind(ObjetoInfo[objectid][NombreObjeto], "Máscara") != -1){
        index = 6; //index 6 - boca
        bone = 2; // bone head
    }
    else if(strfind(ObjetoInfo[objectid][NombreObjeto], "Chaleco") != -1){
        index = 7; //index - pecho
        bone = 1;  // bone spine
    }
    else if(strfind(ObjetoInfo[objectid][NombreObjeto], "Portaplaca") != -1){
        index = 7; //index - pecho
        bone = 1;  // bone spine
    }
    else{
        index = 0;
        bone = 0;
    }
    return 1;
}
find_ammotype(objectid){
    if(ObjetoInfo[objectid][Tipo] != 6){
        return 0;
    }
    for(new i; i < sizeof(ObjetoInfo); i++){
        if(ObjetoInfo[i][Tipo] == 7){
            new ammotype[16];
            strmid(ammotype, ObjetoInfo[objectid][NombreObjeto], strfind(ObjetoInfo[objectid][NombreObjeto], "(")+1, strfind(ObjetoInfo[objectid][NombreObjeto], ")"));
            if(strfind(ObjetoInfo[objectid][NombreObjeto], ammotype) != -1){
                return i;
            }
            else continue;
        }
    }
    return 0;
}
public OnPlayerWeaponShot(playerid, WEAPON:weaponid, BULLET_HIT_TYPE:hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    new manoder = Datos[playerid][jMano][0];
    //new manocant = Datos[playerid][jManoCant][0];
    if(manoder)
    {
        if(!ObjetoInfo[manoder][IDArma]) return update_manos(playerid);
        if(WEAPON:ObjetoInfo[manoder][IDArma] != weaponid) return update_manos(playerid); 
        if(Datos[playerid][jManoCant] < 1) return update_manos(playerid);
        Datos[playerid][jManoCant][0]--;
        if(Datos[playerid][jManoCant][0]) GivePlayerWeapon(playerid, weaponid, 10500);
        
        /*new ammo = GetPlayerAmmo(playerid);
        if(ammo <= 1 && Datos[playerid][jManoCant][0] > ammo){
            if(Datos[playerid][jManoCant][0] >= GetWeaponMagCapacity(weaponid)){
                GivePlayerWeapon(playerid, weaponid, GetWeaponMagCapacity(weaponid)-ammo);
            }
            else GivePlayerWeapon(playerid, WEAPON:ObjetoInfo[manoder][IDArma], Datos[playerid][jManoCant][0]-ammo);
        }*/
        PlayerTextDrawSetString(playerid, Gun_Hud[playerid][1], "%d/%d", Datos[playerid][jManoCant][0], ObjetoInfo[manoder][Capacidad]);
        if(Datos[playerid][jManoCant][0] < 1 && GetPlayerAmmo(playerid)) ResetPlayerWeapons(playerid);
        return 1;
    }
    else return 0;
}

public OnPlayerEditAttachedObject(playerid, EDIT_RESPONSE:response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ){
    new objetoid;
    for(new i; i < sizeof(ObjetoInfo); i++){
        if(ObjetoInfo[i][ModeloObjeto] == modelid){
            objetoid = i;
            break;
        }
    }
    if(!objetoid) return 1;
    if(EditType[playerid] == 1337){
        SendClientMessage(playerid, COLOR_GREEN, "%f, %f, %f, %f, %f, %f, %f, %f, %f);", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
        EditType[playerid] = 0;
        return 1;
    }
    if(!response){
        if(EditType[playerid] == 2){
            SendClientMessage(playerid, COLOR_SYSTEM, "Cancelaste la edición de tu accesorio.");
            RemovePlayerAttachedObject(playerid, index);
            switch(index){
                case 4:{
                    SetPlayerAttachedObject(playerid, index, modelid, boneid, CharToys[playerid][GorroPos][0], CharToys[playerid][GorroPos][1], CharToys[playerid][GorroPos][2], CharToys[playerid][GorroRot][0], CharToys[playerid][GorroRot][1], CharToys[playerid][GorroRot][2], CharToys[playerid][GorroScale][0], CharToys[playerid][GorroScale][1], CharToys[playerid][GorroScale][2]);
                }
                case 5:{
                    SetPlayerAttachedObject(playerid, index, modelid, boneid, CharToys[playerid][GafasPos][0], CharToys[playerid][GafasPos][1], CharToys[playerid][GafasPos][2], CharToys[playerid][GafasRot][0], CharToys[playerid][GafasRot][1], CharToys[playerid][GafasRot][2], CharToys[playerid][GafasScale][0], CharToys[playerid][GafasScale][1], CharToys[playerid][GafasScale][2]);
                }
                case 6:{
                    SetPlayerAttachedObject(playerid, index, modelid, boneid, CharToys[playerid][BocaPos][0], CharToys[playerid][BocaPos][1], CharToys[playerid][BocaPos][2], CharToys[playerid][BocaRot][0], CharToys[playerid][BocaRot][1], CharToys[playerid][BocaRot][2], CharToys[playerid][BocaScale][0], CharToys[playerid][BocaScale][1], CharToys[playerid][BocaScale][2]);
                }
                case 7:{
                    SetPlayerAttachedObject(playerid, index, modelid, boneid, CharToys[playerid][PechoPos][0], CharToys[playerid][PechoPos][1], CharToys[playerid][PechoPos][2], CharToys[playerid][PechoRot][0], CharToys[playerid][PechoRot][1], CharToys[playerid][PechoRot][2], CharToys[playerid][PechoScale][0], CharToys[playerid][PechoScale][1], CharToys[playerid][PechoScale][2]);
                }
            }
            EditType[playerid] = 0;
            return 1;
        }
        EditType[playerid] = 0;
        Datos[playerid][jMano][0] = objetoid;
        Datos[playerid][jManoCant][0] = 1;
        Datos[playerid][jManoData][0] = 0;
        update_manos(playerid);
        RemovePlayerAttachedObject(playerid, index);
        return 1;
    }
    switch(index){
        case 4:{
            CharToys[playerid][jToy_Gorro] = objetoid;
            CharToys[playerid][GorroPos][0] = fOffsetX;
            CharToys[playerid][GorroPos][1] = fOffsetY;
            CharToys[playerid][GorroPos][2] = fOffsetZ;
            CharToys[playerid][GorroRot][0] = fRotX;
            CharToys[playerid][GorroRot][1] = fRotY;
            CharToys[playerid][GorroRot][2] = fRotZ;
            CharToys[playerid][GorroScale][0] = fScaleX;
            CharToys[playerid][GorroScale][1] = fScaleY;
            CharToys[playerid][GorroScale][2] = fScaleZ;
        }
        case 5:{
            CharToys[playerid][jToy_Gafas] = objetoid;
            CharToys[playerid][GafasPos][0] = fOffsetX;
            CharToys[playerid][GafasPos][1] = fOffsetY;
            CharToys[playerid][GafasPos][2] = fOffsetZ;
            CharToys[playerid][GafasRot][0] = fRotX;
            CharToys[playerid][GafasRot][1] = fRotY;
            CharToys[playerid][GafasRot][2] = fRotZ;
            CharToys[playerid][GafasScale][0] = fScaleX;
            CharToys[playerid][GafasScale][1] = fScaleY;
            CharToys[playerid][GafasScale][2] = fScaleZ;
        }
        case 6:{
            CharToys[playerid][jToy_Boca] = objetoid;
            CharToys[playerid][BocaPos][0] = fOffsetX;
            CharToys[playerid][BocaPos][1] = fOffsetY;
            CharToys[playerid][BocaPos][2] = fOffsetZ;
            CharToys[playerid][BocaRot][0] = fRotX;
            CharToys[playerid][BocaRot][1] = fRotY;
            CharToys[playerid][BocaRot][2] = fRotZ;
            CharToys[playerid][BocaScale][0] = fScaleX;
            CharToys[playerid][BocaScale][1] = fScaleY;
            CharToys[playerid][BocaScale][2] = fScaleZ;
        }
        case 7:{
            CharToys[playerid][jToy_Pecho] = objetoid;
            CharToys[playerid][PechoPos][0] = fOffsetX;
            CharToys[playerid][PechoPos][1] = fOffsetY;
            CharToys[playerid][PechoPos][2] = fOffsetZ;
            CharToys[playerid][PechoRot][0] = fRotX;
            CharToys[playerid][PechoRot][1] = fRotY;
            CharToys[playerid][PechoRot][2] = fRotZ;
            CharToys[playerid][PechoScale][0] = fScaleX;
            CharToys[playerid][PechoScale][1] = fScaleY;
            CharToys[playerid][PechoScale][2] = fScaleZ;
        }
    }
    if(EditType[playerid] == 2) SendClientMessage(playerid, COLOR_SYSTEM, "Guardada la posición del accesorio.");
    else SendClientMessage(playerid, COLOR_SYSTEM, "Ajustaste tu objeto, para editar su posición puedes usar /editaracc.");
        
    EditType[playerid] = 0;
    orm_update(CharToys[playerid][ORM_toy]);
    return 1;
}


