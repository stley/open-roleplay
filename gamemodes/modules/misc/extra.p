
alm(string[], const string2[])
{
    strmid(string, string2, 0, strlen(string2), strlen(string2) + 1);
    return 1;
}
GetPIP(playerid)
{
	new IP[17];
	GetPlayerIp(playerid, IP, sizeof(IP));
	return IP;
}/*
Random(min, max)
{
	new a = random(max - min) + min;
	return a;
}*/
GetMonth(Month)
{
    new MonthStr[15];
    switch(Month)
    {
        case 1:  MonthStr = "Enero";
        case 2:  MonthStr = "Febrero";
        case 3:  MonthStr = "Marzo";
        case 4:  MonthStr = "Abril";
        case 5:  MonthStr = "Mayo";
        case 6:  MonthStr = "Junio";
        case 7:  MonthStr = "Julio";
        case 8:  MonthStr = "Agosto";
        case 9:  MonthStr = "Septiembre";
        case 10: MonthStr = "Octubre";
        case 11: MonthStr = "Noviembre";
        case 12: MonthStr = "Diciembre";
    }
    return MonthStr;
}

GetWeekDay(day=0, month=0, year=0)
{
    if (!day)
    getdate(year, month, day);
    new weekday_str[12],j,e;
    if (month <= 2)
    {
        month += 12;
        --year;
    }
    j = year % 100;
    e = year / 100;
    switch ((day + (month+1)*26/10 + j + j/4 + e/4 - 2*e) % 7)
    {
        case 0: weekday_str = "Sabado";
        case 1: weekday_str = "Domingo";
        case 2: weekday_str = "Lunes";
        case 3: weekday_str = "Martes";
        case 4: weekday_str = "Miercoles";
        case 5: weekday_str = "Jueves";
        case 6: weekday_str = "Viernes";
    }
    return weekday_str;
}
FechaActual()
{
	new thetime[92], Year, Month, Day, horas, mins, segs;
	getdate(Year, Month, Day);
	gettime(horas, mins, segs);

	if(horas >= 12) format(thetime, sizeof(thetime), "%s %d de %s de %d [%02d:%02d PM]", GetWeekDay(), Day, GetMonth(Month), Year, (horas == 12) ? (12) : (horas - 12), mins);
	else if(horas < 12) format(thetime, sizeof(thetime), "%s %d de %s de %d [%02d:%02d AM]", GetWeekDay(), Day, GetMonth(Month), Year, (horas == 0) ? (12) : (horas), mins);
	return thetime;
}
/*stock IsNumeric(const string[])//By Jan "DracoBlue" Schütze (edited by Gabriel "Larcius" Cordes
{
	new j = strlen(string);
	if(j == 0) return 0;

	for(new i = 0; i < j; i++)
	{
		if(string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}*/
stock IsValidEmail(const email[]) //By Jan "DracoBlue" Schütze
{
	new len=strlen(email);
	new cstate=0;
	for(new i=0;i<len;i++)
	{
		if ((cstate==0 || cstate==1) && (email[i]>='A' && email[i]<='Z') || (email[i]>='a' && email[i]<='z')  || (email[i]=='.')  || (email[i]=='-')  || (email[i]=='_'))
		{
		}
		else
		{
			if ((cstate==0) &&(email[i]=='@'))
			{
				cstate=1;
			}
			else
			{
				return false;
			}
		}
	}
	if (cstate<1)
	{
		return false;
	}
	if (len<6)
	{
		return false;
	}
	if ((email[len-3]=='.') || (email[len-4]=='.') || (email[len-5]=='.'))
	{
		return true;
	}
	return false;
}

stock Weapon_IsValid(wepid)
{
  if (wepid > 0 && wepid< 19 || wepid > 21 && wepid < 47)
  {
    return 1;
  }
  return 0;
}
// CP1252 ? UTF-8 (covers Spanish letters and punctuation)
stock Cp1252ToUtf8(out[], size, const in[])
{
    new i=0, j=0, c;
    while ((c = in[i++] & 0xFF) && j < size-1)
    {
        if (c < 0x80) { out[j++] = c; continue; }                // ASCII
        if (c >= 0xA0 && c <= 0xBF) {                            // U+00A0..00BF
            if (j+2 >= size) break; out[j++] = 0xC2; out[j++] = c; continue;
        }
        if (c >= 0xC0) {                                         // U+00C0..00FF
            if (j+2 >= size) break; out[j++] = 0xC3; out[j++] = c - 0x40; continue;
        }
        // Optional CP1252 specials (add more if you need)
        if (c == 0x80) { if (j+3 >= size) break; out[j++] = 0xE2; out[j++] = 0x82; out[j++] = 0xAC; continue; } // €
        // Fallback
        out[j++] = '?';
    }
    out[j] = '\0'; return j;
}

/*stock strreplace(string[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(string)) {
    // No need to do anything if the limit is 0.
    if (limit == 0)
        return 0;
    
    new
             sublen = strlen(search),
             replen = strlen(replacement),
        bool:packed = ispacked(string),
             maxlen = maxlength,
             len = strlen(string),
             count = 0
    ;
    
    
    // "maxlen" holds the max string length (not to be confused with "maxlength", which holds the max. array size).
    // Since packed strings hold 4 characters per array slot, we multiply "maxlen" by 4.
    if (packed)
        maxlen *= 4;
    
    // If the length of the substring is 0, we have nothing to look for..
    if (!sublen)
        return 0;
    
    // In this line we both assign the return value from "strfind" to "pos" then check if it's -1.
    while (-1 != (pos = strfind(string, search, ignorecase, pos))) {
        // Delete the string we found
        strdel(string, pos, pos + sublen);
        
        len -= sublen;
        
        // If there's anything to put as replacement, insert it. Make sure there's enough room first.
        if (replen && len + replen < maxlen) {
            strins(string, replacement, pos, maxlength);
            
            pos += replen;
            len += replen;
        }
        
        // Is there a limit of number of replacements, if so, did we break it?
        if (limit != -1 && ++count >= limit)
            break;
    }
    
    return count;
}*/



stock VehiclesName[212][] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Pereniel",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring-Racer",
	"Hotring-Racer",
	"Bloodring-Banger",
	"Rancher",
	"Super-GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropdust",
	"Stunt",
	"Tanker",
	"RoadTrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster Truck A",
	"Monster Truck B",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight",
	"Trailer",
	"Kart",
	"Mower",
	"Duneride",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Trailer",
	"Trailer",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police Car",
	"Police Car",
	"Police Car",
	"Police Ranger",
	"Picador",
	"S.W.A.T. Van",
	"Alpha",
	"Phoenix",
	"Glendale",
	"Sadler",
	"Luggage Trailer",
	"Luggage Trailer",
	"Stair Trailer",
	"Boxville",
	"Farm Plow",
	"Utility Trailer"
};

stock Float:GetDistanceBetweenPlayers(pl1, pl2)
{
    new Float:pos[6];
    if(!IsPlayerConnected(pl1) || !IsPlayerConnected(pl2)) return -1.0;
    GetPlayerPos(pl1, pos[0], pos[1], pos[2]);
    GetPlayerPos(pl2, pos[3], pos[4], pos[5]);
    return VectorSize(pos[0]-pos[3],pos[1] - pos[4], pos[2]-pos[5]);
}
GetName(playerid){
	new name[25];
	GetPlayerName(playerid, name);
	return name;
}