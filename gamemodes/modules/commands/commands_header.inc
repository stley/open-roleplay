#if !defined PAWNCMD_INC_
	#warning Pawn.CMD not included. Including...
	#include <Pawn.CMD>
#endif

#include "../gamemodes/modules/item_system/item_commands"
#include "../gamemodes/modules/admin/admin_commands"
#include "../gamemodes/modules/account-management/account_commands"
#include "../gamemodes/modules/rptools/rptools_commands"
#include "../gamemodes/modules/vehicle/vehicle_commands"
#include "../gamemodes/modules/damage_system/damage_commands"

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(Datos[playerid][EnChar] == false){
		SendClientMessage(playerid, COLOR_DARKRED, "No puedes colocar ningun comando sin ingresar a un personaje.");
		return 0;
	}
	if(!flags) return 1;
	else if (!(flags & a_perms[playerid])){
		SendClientMessage(playerid, COLOR_DARKRED, "No tienes acceso a este comando.");
		return 0;
	}
	else return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if (result == -1)
	{
		SendClientMessage(playerid, COLOR_SYSTEM, "SERVER: Comando desconocido. Visita /ayuda para ver los comandos disponibles."); 
		return 0;
	}
	return 1;
}
