#include <open.mp>
#include <crashdetect>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
//#include <whirlpool>
#include <Pawn.CMD>
#include <Pawn.RakNet>
#include <easyDialog>
#include <discord-connector>
#include <YSI_Core/y_utils>
#include <YSI_Game/y_vehicledata>
#include <PawnPlus>
#include <samp_bcrypt>
#pragma dynamic 8000
#undef MAX_PLAYERS
#define MAX_PLAYERS (500)
//Módulos
#include "modules/misc/misc_header.p" // Misceláneos
#include "modules/discord-bot/discord-bot_header.p" // Conexión con bot de discord!
#include "modules/serverLog/serverLog_header.p"
#include "modules/core/core_header.p" //Funciones core del servidor.
#include "modules/database/database_header.p" // conexión a la base de datos en OnGameModeInit y OnGameModeExit
#include "modules/item-system/item_header.p" // Objetos
#include "modules/admin/admin_header.p" // Objetos
#include "modules/vehicle/vehicle_header.p"
#include "modules/damage_system/damage_header.p"
#include "modules/account-management/account_header.p"  //Management de los usuarios y sus personajes
#include "modules/rptools/rptools.p"
#include "modules/player/player_header.p"
#include "modules/commands/commands_header.p" // Comandos (Pawn.CMD)
#include "modules/anticheat/anticheat_header.p" // (Pawn.RakNet)
//

main(){}

// Directivas
#pragma option -d3
//
