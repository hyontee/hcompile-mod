IPacket:PACKET_PASSENGER(playerid, BitStream:bs)
{ 
	new RAKNET_PASSENGER_PACKET;
	new RAKNET_PASSENGER[PR_PassengerSync];

	BS_ReadUint8(bs, RAKNET_PASSENGER_PACKET);
	BS_ReadPassengerSync(bs, RAKNET_PASSENGER);
	
	/*
		RAKNET_PASSENGER[RAKNET_VEHICLE],
        RAKNET_PASSENGER[PR_driveBy],
        RAKNET_PASSENGER[PR_seatId],
        RAKNET_PASSENGER[PR_additionalKey],
        RAKNET_PASSENGER[PR_weaponId],
        RAKNET_PASSENGER[PR_playerHealth],
        RAKNET_PASSENGER[PR_playerArmour],
        RAKNET_PASSENGER[PR_lrKey],
        RAKNET_PASSENGER[PR_udKey],
        RAKNET_PASSENGER[PR_keys],
        RAKNET_PASSENGER[PR_position][0],
        RAKNET_PASSENGER[PR_position][1],
        RAKNET_PASSENGER[PR_position][2]
	*/
	
	SERVER_INFO[playerid][SAMP_POS_X] = RAKNET_PASSENGER[PR_position][0];
	SERVER_INFO[playerid][SAMP_POS_Y] = RAKNET_PASSENGER[PR_position][1];
	SERVER_INFO[playerid][SAMP_POS_Z] = RAKNET_PASSENGER[PR_position][2];
	
	
	#include																		SAMP_AC/MODULE/ANTICRASHER/SEAT
	
	#include																		SAMP_AC/MODULE/ANTICHEAT/FAST_CAR_PASSENGER
	#include																		SAMP_AC/MODULE/ANTICHEAT/FAST_ENTER_CAR_PASSENGER

	
	SERVER_INFO[playerid][SAMP_ID_VEHICLE] = RAKNET_PASSENGER[PR_vehicleId];
	#include                                                                        SAMP_AC/MODULE/ANTINOP/REMOVE_VEHICLE
	#include                                                                        SAMP_AC/MODULE/ANTINOP/PUT_VEHICLE
	
	#include                                                                        SAMP_AC/MODULE/ANTINOP/ARMED_WEAPON
	
	if(CENTER_CONTROLE[0][CONTROL_DAMAGE] == 1)
	{
		if(SAMP_AC_CHECK_PLAYER_HEALTH(playerid, RAKNET_PASSENGER[PR_playerHealth]) == 0) return 0;
		
		BS_Reset(bs);
		BS_WriteUint8(bs, RAKNET_PASSENGER_PACKET);
		BS_WritePassengerSync(bs, RAKNET_PASSENGER);
	}
	return true;
}