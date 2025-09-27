enum (<<= 1)
{
	CMD_OWNER = 1,
	CMD_ADMIN,
	CMD_OPERATOR,
	CMD_JR_OPERATOR,
	CMD_MOD,
	CMD_JR_MOD,

	CMD_STAFF_MANAGER,
	CMD_FACTION_MANAGER,
	CMD_PROPERTY_MANAGER
};
new a_perms[MAX_PLAYERS];

#include "../gamemodes/modules/admin/admin_dialogs.p" 
#include "../gamemodes/modules/admin/admin_funcs.p"