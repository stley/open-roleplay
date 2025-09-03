#include <open.mp>
//xd
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <whirlpool>
#include <Pawn.CMD>
#include <Pawn.RakNet>
#include <easyDialog>
#include <discord-connector>
//#include <jit>
#include <YSI_Core/y_utils>
#include <YSI_Game/y_vehicledata>
//#include <bus>
#pragma dynamic 8000
//Módulos
//  BERKELEY 222
// otra vez berkeley?
#include "modules/misc/misc_header" // Misceláneos
#include "modules/discord-bot/discord-bot_header" // Conexión con bot de discord!
#include "modules/serverLog/serverLog_header"
#include "modules/core/core_header" //Funciones core del servidor.
#include "modules/database/database_header" // conexión a la base de datos en OnGameModeInit y OnGameModeExit
#include "modules/item-system/item_header" // Objetos
#include "modules/admin/admin_header" // Objetos
#include "modules/vehicle/vehicle_header"
#include "modules/damage_system/damage_header"
#include "modules/account-management/account_header"  //Management de los usuarios y sus personajes
#include "modules/rptools/rptools"
#include "modules/player/player_header"
#include "modules/commands/commands_header" // Comandos (Pawn.CMD)
#include "modules/anticheat/anticheat_header" // (Pawn.RakNet)
//
// Directivas
main(){}
//#pragma warning disable 239
//#pragma warning disable 214
#pragma unused CONSOLE_CHANNEL
#pragma option -d3
//
