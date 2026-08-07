new g_player_anticheat[MAX_PLAYERS] = -1;
new g_anticheat_timer[MAX_PLAYERS];

new g_client_anticheat_status = 1;

const RPC_HWID_REQUEST = 230;
const RPC_HWID_RESPONSE = 231;

IPacket:RPC_HWID_RESPONSE(playerid, BitStream: bs)
{
	if(IsPlayerFromThePhone(playerid)) return 1;
	
	BS_IgnoreBits(bs, 40);
 
	new motherBoardID[200];
	new BIOSUUID[100];
	new systemUUID[100];
	new CPUID[100];
	new MEMORY[100];
 
	BS_ReadValue(bs,
        PR_STRING, motherBoardID, 200,
        PR_STRING, BIOSUUID, 100,
        PR_STRING, systemUUID, 100,
        PR_STRING, CPUID, 100,
        PR_STRING, MEMORY, 100
    );
 
 	printf("[HWID DETECT] motherBoardID: %s", motherBoardID);
	printf("[HWID DETECT] BIOSUUID: %s", BIOSUUID);
	printf("[HWID DETECT] systemUUID: %s", systemUUID);
	printf("[HWID DETECT] CPUID: %s", CPUID);
	printf("[HWID DETECT] MEMORY: %s", MEMORY);
	
//	AddHWIDToDatabase(playerid, motherBoardID);
 
	return 1;
}

stock GetPlayerHWID(playerid)
{
	if(IsPlayerFromThePhone(playerid)) return 1;
		
	new BitStream: bs = BS_New();
	
	PR_SendRPC(bs, playerid, RPC_HWID_REQUEST);
	BS_Delete(bs);
	
	return 1;
}

CMD:get_hwid(playerid, const params[])
{
    if(!GetString(GetName(playerid), "Sambero_Lucanio") && !GetString(GetName(playerid), "Eduard_Haunted")) return false;
	extract params -> new to_player; else return SendClientMessage(playerid, -1, "Используйте: /get_hwid [ID игрока]");
	
	GetPlayerHWID(to_player);
	
	return 1;
}
 
const RPC_ANTICHEAT_REQUEST = 229;
const RPC_ANTICHEAT = 232;
 
ICustomRPC:RPC_ANTICHEAT(playerid, BitStream: bs)
{
	if(IsPlayerFromThePhone(playerid)) return 1;
	
    new row, 
		shift, 
		code = -1;
 
    BS_IgnoreBits(bs, 48);
    BS_ReadUint8(bs, row);
	
    BS_IgnoreBits(bs, 32);
    BS_ReadUint8(bs, shift);
 
	code = row - shift;
 
	if(row == shift) 
		code = 6;
 
    if(code == -1 || code > 1)
    {
    	ClientAnticheatKick(playerid, code);
    }
	
	g_player_anticheat[playerid] = code;
 
    return 1;
}

stock ClientAnticheatKick(playerid, code)
{
	/*if(g_client_anticheat_status != 1) return 1;
	if(IsPlayerFromThePhone(playerid)) return 1;
	
	printf("[debug] client ac kick -> player_id: %d code: %d", playerid, code);
	
	new fmt_str[300];
	
	format
	(
		fmt_str, sizeof fmt_str, 
		"{ffffff}Вы были {ff6b81}отключены {ffffff}от сервера по причине использования {ff6b81}запрещенного\n"\
		"программного обеспечения{ffffff}.\n\n"\
		"Код анти-чита: {ff6b81}%d\n\n"\
		"Если Вы считаете, что произошла ошибка, обратитесь на форум: {ff6b81}forum.kaifrp.ru",
		code
	);
	
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ff6b81}Клиентский анти-чит", fmt_str, "Хорошо", "Закрыть");
	
	return KickEx(playerid, "AC -> Client");*/
}
