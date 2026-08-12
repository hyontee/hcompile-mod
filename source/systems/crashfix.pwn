#define _crashfix_inc
	#endinput
#endif
const PLAYER_SYNC = 207;
const UNOCCUPIED_SYNC = 209;
// const PASSENGER_SYNC = 211;

/*IPacket:PASSENGER_SYNC(playerid, BitStream:bs) {
	new passengerData[PR_PassengerSync];

	BS_IgnoreBits(bs, 8);
	BS_ReadPassengerSync(bs, passengerData);

	if (GetPlayerVehicleSeat(playerid) == 0) {
		return 0;
	}
	return 1;
}*/
IPacket:PLAYER_SYNC(playerid, BitStream:bs) {
	new onFootData[PR_OnFootSync];

	BS_IgnoreBits(bs, 8);
	BS_ReadOnFootSync(bs, onFootData);

	if (onFootData[PR_quaternion][0] > 1.0 || onFootData[PR_quaternion][0] < -1.0 
		|| onFootData[PR_quaternion][1] > 1.0 || onFootData[PR_quaternion][1] < -1.0 
		|| onFootData[PR_quaternion][2] > 1.0 || onFootData[PR_quaternion][2] < -1.0 
		|| onFootData[PR_quaternion][3] > 1.0 || onFootData[PR_quaternion][3] < -1.0
	) return false;

	return 1;
}

IPacket:UNOCCUPIED_SYNC(playerid, BitStream:bs) {
	new unoccupiedData[PR_UnoccupiedSync];

	BS_IgnoreBits(bs, 8);
	BS_ReadUnoccupiedSync(bs, unoccupiedData);

	if (floatcmp(floatabs(unoccupiedData[PR_roll][0]), 1.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_roll][1]), 1.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_roll][2]), 1.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_direction][0]), 1.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_direction][1]), 1.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_direction][2]), 1.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_position][0]), 20000.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_position][1]), 20000.00000) == 1
		|| floatcmp(floatabs(unoccupiedData[PR_position][2]), 20000.00000) == 1 
		|| !(-1.00000 <= unoccupiedData[PR_roll][0] <= 1.00000)
		|| !(-1.00000 <= unoccupiedData[PR_roll][1] <= 1.00000)
		|| !(-1.00000 <= unoccupiedData[PR_roll][2] <= 1.00000)
		|| !(-1.00000 <= unoccupiedData[PR_direction][0] <= 1.00000)
		|| !(-1.00000 <= unoccupiedData[PR_direction][1] <= 1.00000)
		|| !(-1.00000 <= unoccupiedData[PR_direction][2] <= 1.00000)
		|| !(-20000.0 <= unoccupiedData[PR_position][0] <= 20000.00000)
		|| !(-20000.0 <= unoccupiedData[PR_position][1] <= 20000.00000)
		|| !(-20000.0 <= unoccupiedData[PR_position][2] <= 20000.00000)
		|| !(-1.00000 <= unoccupiedData[PR_angularVelocity][0] <= 1.00000)
		|| !(-1.00000 <= unoccupiedData[PR_angularVelocity][1] <= 1.00000)
		|| !(-1.00000 <= unoccupiedData[PR_angularVelocity][2] <= 1.00000)
		|| !(-100.00000 <= unoccupiedData[PR_velocity][0] <= 100.00000)
		|| !(-100.00000 <= unoccupiedData[PR_velocity][1] <= 100.00000)
		|| !(-100.00000 <= unoccupiedData[PR_velocity][2] <= 100.00000) 
        || floatcmp(floatabs(unoccupiedData[PR_angularVelocity][0]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_angularVelocity][1]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_angularVelocity][2]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_velocity][0]), 100.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_velocity][1]), 100.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_velocity][2]), 100.00000) == 1
    ) return false;

	return true;
}