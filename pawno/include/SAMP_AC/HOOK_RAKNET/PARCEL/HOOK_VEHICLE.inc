IPacket:PACKET_VEHICLE(playerid, BitStream: bs)
{ 
	new RAKNET_DRIVER_PACKET;
	new RAKNET_DRIVER[PR_InCarSync];
	
	BS_ReadUint8(bs, RAKNET_DRIVER_PACKET);
	BS_ReadInCarSync(bs, RAKNET_DRIVER);
	
	SERVER_INFO[playerid][SAMP_POS_X] = RAKNET_DRIVER[PR_position][0];
	SERVER_INFO[playerid][SAMP_POS_Y] = RAKNET_DRIVER[PR_position][1];
	SERVER_INFO[playerid][SAMP_POS_Z] = RAKNET_DRIVER[PR_position][2];
	
	SERVER_INFO[playerid][SAMP_SPEED_X] = RAKNET_DRIVER[PR_velocity][0];
	SERVER_INFO[playerid][SAMP_SPEED_Y] = RAKNET_DRIVER[PR_velocity][1];
	SERVER_INFO[playerid][SAMP_SPEED_Z] = RAKNET_DRIVER[PR_velocity][2];

	
	#include                                                                        SAMP_AC/MODULE/ANTINOP/REMOVE_VEHICLE
	#include                                                                        SAMP_AC/MODULE/ANTINOP/PUT_VEHICLE
	#include                                                                        SAMP_AC/MODULE/ANTINOP/ARMED_WEAPON
	
	#include																		SAMP_AC/MODULE/ANTICHEAT/FAST_CAR
	#include																		SAMP_AC/MODULE/ANTICHEAT/FAST_ENTER_CAR
	
	#include																		SAMP_AC/MODULE/ANTICHEAT/AIR_CAR
	#include																		SAMP_AC/MODULE/ANTICHEAT/TELEPORT_CAR
	#include																		SAMP_AC/MODULE/ANTICHEAT/CAR_SLAPPER
	
	#include																		SAMP_AC/MODULE/ANTICHEAT/SPEED_HACK_SHARP
	#include																		SAMP_AC/MODULE/ANTICHEAT/SPEED_HACK_SMOOTH
	
	
	SERVER_INFO[playerid][SAMP_ID_VEHICLE] = RAKNET_DRIVER[PR_vehicleId];
	SERVER_INFO[playerid][SAMP_LAST_SPEED] = SAMP_AC_REAL_SPEED(playerid);
	SERVER_INFO[playerid][SAMP_FUNC][0] = SERVER_INFO[playerid][SAMP_WARN][0] = 1;
	
	
	if(CENTER_CONTROLE[0][CONTROL_DAMAGE] == 1)
	{
		if(SAMP_AC_CHECK_PLAYER_HEALTH(playerid, RAKNET_DRIVER[PR_playerHealth]) == 0) return 0;
		
		BS_Reset(bs);
		BS_WriteUint8(bs, RAKNET_DRIVER_PACKET);
		BS_WriteInCarSync(bs, RAKNET_DRIVER);
	}
    return true;
}