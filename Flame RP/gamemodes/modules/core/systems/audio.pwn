stock StopStream(playerid) {
	DeletePVar(playerid, #pAudioStream);
	return StopAudioStreamForPlayer(playerid);
}
stock PlayStream(playerid, const url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0) {
	if(GetPVarType(playerid, #pAudioStream)) StopAudioStreamForPlayer(playerid);
	else SetPVarInt(playerid, #pAudioStream, 1);
	return PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}
stock GivePlayerBoomBoxObj(playerid) {
	if(IsPlayerAttachedObjectSlotUsed(playerid, 6)) RemovePlayerAttachedObject(playerid, 6);
	return SetPlayerAttachedObject(playerid, 6, 2226, 1, 0.0000, -0.1780, -0.0689, -0.3000, 17.3999, 0.0000, 1.0000, 1.0000, 1.0000);
}
stock RemovePlayerBoomBoxObj(playerid) return RemovePlayerAttachedObject(playerid, 6);