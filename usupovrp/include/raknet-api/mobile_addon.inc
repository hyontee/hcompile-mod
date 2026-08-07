/*
	Packet 246
	
	RPC 0 - выход из игры
	RPC 1 - краш игры
*/

const RPC_GAME_EXIT = 246;

IPacket:RPC_GAME_EXIT(playerid, BitStream: bs)
{
	if(!IsPlayerFromThePhone(playerid)) return 1;
	
	new game_exit_id;
	
	BS_IgnoreBits(bs, 40);
 
	BS_ReadValue
	(
		bs,
        PR_UINT8, game_exit_id
    );
 
 	printf(game_exit_id);
 
	return 1;
}