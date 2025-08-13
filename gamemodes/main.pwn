#include <open.mp>
#include <fixes>
//xd
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <whirlpool>
#include <Pawn.CMD>
#include <Pawn.RakNet>
#include <easyDialog>
#include <jit>
#include <YSI-Includes/YSI_Core/y_utils>
#include <YSI-Includes/YSI_Game/y_vehicledata>
//#include <bus>
#pragma dynamic 8000
//Módulos
#include "modules/core/core_header" //Funciones core del servidor.
#include "modules/misc/misc_header" // Misceláneos
#include "modules/database/database_header" // conexión a la base de datos en OnGameModeInit y OnGameModeExit
#include "modules/item_system/item_header" // Objetos
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

#pragma option -d3
//
