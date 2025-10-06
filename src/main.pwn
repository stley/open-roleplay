#include <open.mp>
#include <crashdetect>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <foreach>
#include <Pawn.CMD>
#include <Pawn.RakNet>
#include <samp_bcrypt>
#include <strlib>
#include <requests>
#include <VehiclePartPosition>

#define PP_SYNTAX_AWAIT
#define PP_SYNTAX_YIELD
#include <PawnPlus>
#include <pp-mysql>
#include <tdialogs>

#include <pp-hooks>

#pragma dynamic 7000
#undef MAX_PLAYERS
#define MAX_PLAYERS (500)


//#define BUILD_PRODUCTION
#define BUILD_DEBUG


//Módulos
#if defined CURRENT_MODULE
    #undef CURRENT_MODULE
#endif
#include "misc/misc_header.p" // Misceláneos
#include "serverLog/serverLog.p"
#include "core/core_header.p" //Funciones core del servidor.
#include "shared/shared_header.p"
#include "database/database_header.p" // Conexión a la base de datos
#include "item-system/item_header.p" // Objetos
#include "admin/admin_header.p" // Admin
#include "vehicle/vehicle_header.p"
#include "damage_system/damage_header.p"
#include "account-management/account_header.p"  //Management de los usuarios y sus personajes
#include "rptools/rptools.p"
#include "player/player_header.p"
#include "commands/commands_header.p" // Comandos (Pawn.CMD)
#include "raknet/raknet_header.p" // (Pawn.RakNet)
#if defined CURRENT_MODULE
    #undef CURRENT_MODULE
#endif

#define CURRENT_MODULE "main"
main(){
    serverLogRegister(sprintf("SERVIDOR INICIADO, COMPILACIÓN: %s (%s)", __date, __time), CURRENT_MODULE);
}

#undef CURRENT_MODULE
// Directivas

#if defined BUILD_DEBUG && defined BUILD_PRODUCTION
    #error "You must choose between BUILD_PRODUCTION or BUILD_DEBUG, can't be both at the same time."
#endif
#if defined BUILD_DEBUG
    #pragma option -d3
#elseif defined BUILD_PRODUCTION
    #pragma option -O2
#endif

