#if !defined PAWNRAKNET_INC_
	#warning Pawn.RakNet not included. Including...
	#include <Pawn.RakNet>
#endif
const packetInCar = 200;
const packetPassenger = 211;
const packetFoot = 207;
IPacket:packetFoot(playerid, BitStream:bs)
{
	new footdata[PR_OnFootSync];
	new manoder = Datos[playerid][jMano][0];
	BS_IgnoreBits(bs, 8);
	BS_ReadOnFootSync(bs, footdata);
	if(footdata[PR_weaponId] == 0 && Weapon_IsValid(WEAPON:ObjetoInfo[manoder][IDArma]) && Datos[playerid][jManoCant][0] >= 1)SetPlayerArmedWeapon(playerid, WEAPON:ObjetoInfo[manoder][IDArma]);
	if(footdata[PR_weaponId] != 0 && footdata[PR_weaponId] != ObjetoInfo[manoder][IDArma])
	{
		update_manos(playerid);
		serverLogRegister(sprintf("%s (playerid %d) envió un paquete OnFootSync indicando que tenia un arma distinta a la que realmente poseía (client %d | server %d).", GetName(playerid), playerid, footdata[PR_weaponId], ObjetoInfo[manoder][IDArma]), CURRENT_MODULE);
		footdata[PR_weaponId] = ObjetoInfo[manoder][IDArma];
		BS_WriteOnFootSync(bs, footdata);
	}
	return 1;
}


IPacket:packetInCar(playerid, BitStream:bs){
	new inCarData[PR_InCarSync];
	BS_IgnoreBits(bs, 8);
	BS_ReadInCarSync(bs, inCarData);
	if(inCarData[PR_weaponId]){
		ResetPlayerWeapons(playerid);
		inCarData[PR_weaponId] = 0;
	}	
	BS_WriteInCarSync(bs, inCarData);
	return CallLocalFunction("OnVehicleUpdate", "d", inCarData[PR_vehicleId]);
}

IPacket:packetPassenger(playerid, BitStream:bs){
	new passengerData[PR_PassengerSync];
	BS_IgnoreBits(bs, 8);
	BS_ReadPassengerSync(bs,passengerData);
	return CallLocalFunction("OnVehicleUpdate", "d", passengerData[PR_vehicleId]);
}

const rpcSendClientMessage = 93; //SendClientMessage - ID: 93 | Parameters: UINT32 dColor, UINT32 dMessageLength, char[] Message

ORPC:rpcSendClientMessage(playerid, BitStream:bs){
	
	new length;
	new color;
	BS_ReadValue(bs,
	PR_UINT32, color,
	PR_UINT32, length);
	if (length <= 144) return 1;
	new String:message_s = str_new("");
	new bitty;
	for(new l; l < length; l++){
		BS_SetReadOffset(bs, 64+(l*8));
		BS_ReadUint8(bs, bitty);
		str_append_format(message_s, "%c", bitty);
	}
	print_s(message_s);
	new String:substr;
	new buffer[145];
	while(str_len(message_s) > 144){
		new color_embed = str_findc(message_s, '{');
		new color_close = str_findc(message_s, '}');
		new String:embed;
		if(color_embed != -1)
			embed = str_sub(message_s, color_embed, color_close+1);
		substr = str_sub(message_s, 0, ((color_embed) == -1 || color_embed == 0) ? 143 : color_embed);
		print_s(substr);
		str_del(message_s, 0, ((color_embed) == -1 || color_embed == 0) ? 143 : color_embed);
		if(color_embed != -1)
			str_ins(message_s, embed, 0);
		str_get(substr, buffer);
		SendClientMessage(playerid, color, buffer);
		str_delete(substr);
	}
	if(str_len(message_s)){
		str_get(message_s, buffer);
		SendClientMessage(playerid, color, buffer);
		str_delete(message_s);
	}
	return 0;
}