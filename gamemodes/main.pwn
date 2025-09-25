#include <open.mp>
#include <crashdetect>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <Pawn.CMD>
#include <Pawn.RakNet>
#include <easyDialog>
//#include <discord-connector>
#include <YSI_Core/y_utils>
#include <YSI_Game/y_vehicledata>
#include <samp_bcrypt>
#include <ndialog-pages>
#include <foreach>
#include <requests>
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
#include "modules/discord-webhook/discord-webhook_header.p" // Conexión con bot de discord!
#include "modules/serverLog/serverLog_header.p"
#include "modules/core/core_header.p" //Funciones core del servidor.
//#include "modules/shared/shared_header.p"
#include "modules/database/database_header.p" // Conexión a la base de datos
#include "modules/item-system/item_header.p" // Objetos
#include "modules/admin/admin_header.p" // Admin
#include "modules/vehicle/vehicle_header.p"
#include "modules/damage_system/damage_header.p"
#include "modules/account-management/account_header.p"  //Management de los usuarios y sus personajes
#include "modules/rptools/rptools.p"
#include "modules/player/player_header.p"
#include "modules/commands/commands_header.p" // Comandos (Pawn.CMD)
#include "modules/raknet/raknet_header.p" // (Pawn.RakNet)

main(){
    serverLogRegister(sprintf("SERVIDOR INICIADO, COMPILACIÓN: %s (%s)", __date, __time));
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

