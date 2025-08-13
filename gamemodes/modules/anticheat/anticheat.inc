#if !defined PAWNRAKNET_INC_
	#warning Pawn.RakNet not included. Including...
	#include <Pawn.RakNet>
#endif

const Pkt_Foot = 207;
IPacket:Pkt_Foot(playerid, BitStream:bs)
{
	new footdata[PR_OnFootSync];
	new manoder = Datos[playerid][jMano][0];
	BS_IgnoreBits(bs, 8);
	BS_ReadOnFootSync(bs, footdata);
	if(footdata[PR_weaponId] == 0 && Weapon_IsValid(WEAPON:ObjetoInfo[manoder][IDArma]) && Datos[playerid][jManoCant][0] >= 1) SetPlayerArmedWeapon(playerid, WEAPON:ObjetoInfo[manoder][IDArma]);
	if(footdata[PR_weaponId] != 0 && footdata[PR_weaponId] != ObjetoInfo[Datos[playerid][jMano][0]][IDArma])
	{
		ResetPlayerWeapons(playerid);
		update_manos(playerid);
	}
	return 1;
}

