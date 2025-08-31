#define MAX_WOUNDS (90)

#define DEATH_INSTANT 90.0
#define DEATH_HEADSHOT 85.0
#define RESPAWN_TIME_INSTANT 180000  // 3 minutos
#define RESPAWN_TIME_WOUNDED 240000  // 4 minutos  
#define RESPAWN_TIME_DEAD 120000     // 2 minutos

#define DMG_9MM_TORSO 12.5
#define DMG_45ACP_TORSO 14.2
#define DMG_38SPL_TORSO 14.2
#define DMG_12GA_TORSO 33.3
#define DMG_76239_TORSO 25.0
#define DMG_556_TORSO 22.0
#define DMG_76251_TORSO 40.0

#define DMG_9MM_GROIN 11.0
#define DMG_45ACP_GROIN 13.0
#define DMG_38SPL_GROIN 13.0
#define DMG_12GA_GROIN 20.0
#define DMG_76239_GROIN 13.0
#define DMG_556_GROIN 13.0
#define DMG_76251_GROIN 20.0

#define DMG_9MM_ARMS 10.0
#define DMG_45ACP_ARMS 12.5
#define DMG_38SPL_ARMS 12.5
#define DMG_12GA_ARMS 20.0
#define DMG_76239_ARMS 15.0
#define DMG_556_ARMS 15.0
#define DMG_76251_ARMS 18.0

#define DMG_9MM_LEGS 11.0
#define DMG_45ACP_LEGS 12.5
#define DMG_38SPL_LEGS 12.5
#define DMG_12GA_LEGS 20.0
#define DMG_76239_LEGS 13.5
#define DMG_556_LEGS 13.0
#define DMG_76251_LEGS 20.0

#define DMG_9MM_HEAD 85.0
#define DMG_45ACP_HEAD 85.0
#define DMG_38SPL_HEAD 85.0
#define DMG_12GA_HEAD 90.0
#define DMG_76239_HEAD 90.0
#define DMG_556_HEAD 90.0
#define DMG_76251_HEAD 90.0

new bool:CanRespawn[MAX_PLAYERS];
new RespawnTimer[MAX_PLAYERS];

enum woundInfo
{
    wnd_ammoType,
    Float:wnd_dmgTaken,
    wnd_bodypart,
    wnd_kevlarHit,
    wnd_IssuerSQLID,
};

new wound_data[MAX_PLAYERS][MAX_WOUNDS][woundInfo];