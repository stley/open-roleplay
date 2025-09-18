static const g_aPreloadLibs[][] =
{
	"AIRPORT",      "ATTRACTORS",   "BAR",          "BASEBALL",     "BD_FIRE",
	"BEACH",        "BENCHPRESS",   "BF_INJECTION", "BIKE_DBZ",     "BIKED",
	"BIKEH",        "BIKELEAP",     "BIKES",        "BIKEV",        "BLOWJOBZ",
	"BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
	"BUS",          "CAMERA",       "CAR",          "CAR_CHAT",     "CARRY",
	"CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
	"COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
	"DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
	"DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
	"FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
	"FLOWERS",      "FOOD",         "FREEWEIGHTS",  "GANGS",        "GFUNK",
	"GHANDS",       "GHETTO_DB",    "GOGGLES",      "GRAFFITI",     "GRAVEYARD",
	"GRENADE",      "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",
	"INT_OFFICE",   "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",
	"KNIFE",        "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",
	"MD_CHASE",     "MD_END",       "MEDIC",        "MISC",         "MTB",
	"MUSCULAR",     "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",
	"PARK",         "PAULNMAC",     "PED",          "PLAYER_DVBYS", "PLAYIDLES",
	"POLICE",       "POOL",         "POOR",         "PYTHON",       "QUAD",
	"QUAD_DBZ",     "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",
	"ROCKET",       "RUNNINGMAN",   "RUSTLER",      "RYDER",        "SCRATCHING",
	"SEX",          "SHAMAL",       "SHOP",         "SHOTGUN",      "SILENCED",
	"SKATE",        "SMOKING",      "SNIPER",       "SNM",          "SPRAYCAN",
	"STRIP",        "SUNBATHE",     "SWAT",         "SWEET",        "SWIM",
	"SWORD",        "TANK",         "TATTOOS",      "TEC",          "TRAIN",
	"TRUCK",        "UZI",          "VAN",          "VENDING",      "VORTEX",
	"WAYFARER",     "WEAPONS",      "WOP",          "WUZI"
};

animationsPreload(playerid)
{
	for (new i = 0; i < sizeof(g_aPreloadLibs); i ++)
	{
		ApplyAnimation(playerid, g_aPreloadLibs[i], "null", 0.0, 0, 0, 0, 0, 0);
	}
	return 1;
} 


forward Models_OnGameModeInit();
public Models_OnGameModeInit()
{
    //SKINS
    print("Adding character models");
    AddCharModel(280, 20001, "skins/police/lapd1.dff", "skins/police/lapd1.txd");
    AddCharModel(267, 20002, "skins/police/hern.dff", "skins/police/hern.txd");
    AddCharModel(284, 20003, "skins/police/lapdm1.dff", "skins/police/lapdm1.txd");
    AddCharModel(266, 20004, "skins/police/pulaski.dff", "skins/police/pulaski.txd");
    AddCharModel(281, 20005, "skins/police/sfpd1.dff", "skins/police/sfpd1.txd");
    AddCharModel(265, 20006, "skins/police/tenpen.dff", "skins/police/tenpen.txd");
    AddCharModel(306, 20007, "skins/police/wfyclpd.dff", "skins/police/wfyclpd.txd");
    //GUNS
    print("Adding object models");
    AddSimpleModel(-1, 11747, -1000, "gun/taser.dff", "gun/taser.txd"); // TASER
    AddSimpleModel(-1, 11747, -1001, "gun/glock18.dff", "gun/glock18.txd"); // GLOCK 18
    AddSimpleModel(-1, 11747, -1002, "gun/glock17.dff", "gun/glock17.txd"); // GLOCK 17
    AddSimpleModel(-1, 11747, -1003, "gun/glock19.dff", "gun/glock19.txd"); // GLOCK 19
    AddSimpleModel(-1, 11747, -1004, "gun/870.dff", "gun/870.txd"); // REMINGTON 870
    AddSimpleModel(-1, 11747, -1005, "gun/870.dff", "gun/870beanbag.txd"); //REMINGTON BEANBAG
    AddSimpleModel(-1, 11747, -1006, "gun/scout.dff", "gun/scout.txd"); //STEYR SCOUT
    AddSimpleModel(-1, 11747, -1007, "gun/hkmp5.dff", "gun/hkmp5.txd"); //HK MP5
    AddSimpleModel(-1, 11747, -1008, "gun/hk416.dff", "gun/hk416.txd"); //HK 416
    AddSimpleModel(-1, 11747, -1009, "gun/ak47.dff", "gun/ak47.txd"); //AK 47
    AddSimpleModel(-1, 11747, -1010, "gun/tec9.dff", "gun/tec9.txd"); //ITec9
    AddSimpleModel(-1, 11747, -1011, "gun/m16.dff", "gun/m16.txd"); //M16
    AddSimpleModel(-1, 11747, -1012, "gun/detspl.dff", "gun/detspl.txd"); //Detective Special
    AddSimpleModel(-1, 11747, -1013, "gun/1911.dff", "gun/1911.txd"); //1911
    AddSimpleModel(-1, 11747, -1014, "gun/m4a1.dff", "gun/m4a1.txd"); //M4A1
    AddSimpleModel(-1, 11747, -1015, "gun/kruger.dff", "gun/kruger.txd"); //Ruger
    AddSimpleModel(-1, 11747, -1016, "gun/pepper.dff", "gun/pepper.txd"); //Gas Pimienta
    AddSimpleModel(-1, 11747, -1017, "gun/spraycan.dff", "gun/spraycan.txd"); //Lata de spray
    AddSimpleModel(-1, 11747, -1018, "gun/baton.dff", "gun/baton.txd"); //Baston policial
    AddSimpleModel(-1, 19142, -1019, "obj/police/GND.dff", "obj/police/GND.txd");
    AddSimpleModel(-1, 19142, -1020, "obj/police/platePD.dff", "obj/police/platePD.txd");
    AddSimpleModel(-1, 19142, -1021, "obj/police/plateSH.dff", "obj/police/plateSH.txd");
    AddSimpleModel(-1, 11747, -1022, "gun/kriss.dff", "gun/kriss.txd"); //Vector
    AddSimpleModel(-1, 11747, -1023, "gun/ar15.dff", "gun/ar15.txd"); //AR15MP
    AddSimpleModel(-1, 19995, -1024, "gun/magazine.dff", "gun/m4a1.txd"); //cargadores de arma larga
    return 1;
}
