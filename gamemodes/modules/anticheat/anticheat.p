#if !defined PAWNRAKNET_INC_
	#warning Pawn.RakNet not included. Including...
	#include <Pawn.RakNet>
#endif

const packetFoot = 207;
IPacket:packetFoot(playerid, BitStream:bs)
{
	new footdata[PR_OnFootSync];
	new manoder = Datos[playerid][jMano][0];
	BS_IgnoreBits(bs, 8);
	BS_ReadOnFootSync(bs, footdata);
	if(footdata[PR_weaponId] == 0 && Weapon_IsValid(WEAPON:ObjetoInfo[manoder][IDArma]) && Datos[playerid][jManoCant][0] >= 1) SetPlayerArmedWeapon(playerid, WEAPON:ObjetoInfo[manoder][IDArma]);
	if(footdata[PR_weaponId] != 0 && footdata[PR_weaponId] != ObjetoInfo[manoder][IDArma])
	{
		ResetPlayerWeapons(playerid);
		update_manos(playerid);
		printf("RakNet: %s (playerid %d) envió un paquete indicando que tenia un arma distinta a la que realmente poseía (client %d | server %d).", GetName(playerid), playerid, footdata[PR_weaponId], ObjetoInfo[manoder][IDArma]);
		footdata[PR_weaponId] = ObjetoInfo[manoder][IDArma];
		BS_WriteOnFootSync(bs, footdata);
	}
	return 1;
}