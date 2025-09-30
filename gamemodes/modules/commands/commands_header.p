#if !defined PAWNCMD_INC_
	#warning Pawn.CMD not included. Including...
	#include <Pawn.CMD>
#endif

#define CURRENT_MODULE "commands"

#include "../gamemodes/modules/item-system/item_commands.p"
#include "../gamemodes/modules/admin/admin_commands.p"
#include "../gamemodes/modules/account-management/account_commands.p"
#include "../gamemodes/modules/rptools/rptools_commands.p"
#include "../gamemodes/modules/vehicle/vehicle_commands.p"
#include "../gamemodes/modules/damage_system/damage_commands.p"
#undef CURRENT_MODULE

new const available_commands[][32] = {
	{"me"},
	{"ame"},
	{"do"},
	{"ceder"},
	{"revivir"}
};
public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(Datos[playerid][EnChar] == false){
		SendClientMessage(playerid, COLOR_DARKRED, "No puedes colocar ningun comando sin ingresar a un personaje.");
		return 0;
	}
	new isvalid = 0;
	for(new i; i < sizeof(available_commands); i++){
		if(!strcmp(available_commands[i], cmd, true)){
			isvalid = 1;
			break;
		}
	}
	if(!isvalid && muerto[playerid] != 0 && !(a_perms[playerid] & CMD_OWNER)){
		SendClientMessage(playerid, COLOR_DARKRED, "¡No puedes ejecutar comandos estando muerto!");
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

