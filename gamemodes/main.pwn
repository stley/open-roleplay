#include <open.mp>
#include <crashdetect>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <Pawn.CMD>
#include <Pawn.RakNet>
#include <easyDialog>
#include <discord-connector>
#include <YSI_Core/y_utils>
#include <YSI_Game/y_vehicledata>
#include <samp_bcrypt>
#include <ndialog-pages>
#include <foreach>
#define PP_SYNTAX_AWAIT
#define PP_SYNTAX_YIELD
#include <PawnPlus>
#pragma dynamic 7000
#undef MAX_PLAYERS
#define MAX_PLAYERS (500)


//#define BUILD_PRODUCTION
#define BUILD_DEBUG


//Módulos
#include "modules/misc/misc_header.p" // Misceláneos
#include "modules/discord-bot/discord-bot_header.p" // Conexión con bot de discord!
#include "modules/serverLog/serverLog_header.p"
#include "modules/core/core_header.p" //Funciones core del servidor.
#include "modules/shared/shared_header.p" //Funciones core del servidor.
#include "modules/database/database_header.p" // Conexión a la base de datos
#include "modules/item-system/item_header.p" // Objetos
#include "modules/admin/admin_header.p" // Admin
#include "modules/vehicle/vehicle_header.p"
#include "modules/damage_system/damage_header.p"
#include "modules/account-management/account_header.p"  //Management de los usuarios y sus personajes
#include "modules/rptools/rptools.p"
#include "modules/player/player_header.p"
#include "modules/commands/commands_header.p" // Comandos (Pawn.CMD)
#include "modules/anticheat/anticheat_header.p" // (Pawn.RakNet)

main(){
    printf("SERVIDOR INICIADO, COMPILACIÓN: %s (%s)", __date, __time);
    if(LOG_CHANNEL != DCC_INVALID_CHANNEL){
        new buff[164];
        new logutf[164];
        format(buff, sizeof(buff), "\"%s\" INICIADO - %s\nSERVIDOR INICIADO, COMPILACIÓN: %s (%s)", __file, FechaActual(), __date, __time);
        Cp1252ToUtf8(logutf, sizeof(logutf), buff);
        DCC_SendChannelMessage(LOG_CHANNEL, logutf);
    }
}

// Directivas

#if defined BUILD_DEBUG && defined BUILD_PRODUCTION
    #error "You must choose between BUILD_PRODUCTION or BUILD_DEBUG, can't be both at the same time."
#endif
#if defined BUILD_DEBUG
    #pragma option -d3
#elseif defined BUILD_PRODUCTION
    #pragma option -O2
#endif

