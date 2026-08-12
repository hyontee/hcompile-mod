	if(CENTER_CONTROLE[20][CONTROL_STATE] == 1)
	{
		if(0 != RAKNET_ONFOOT[PR_surfingVehicleId] && RAKNET_ONFOOT[PR_surfingVehicleId] != INVALID_VEHICLE_ID && RAKNET_ONFOOT[PR_surfingVehicleId] < 2001)
		{
            if ((floatabs(RAKNET_ONFOOT[PR_surfingOffsets][0]) >= 10.0) 
			|| (floatabs(RAKNET_ONFOOT[PR_surfingOffsets][1]) >= 10.0) 
			|| (floatabs(RAKNET_ONFOOT[PR_surfingOffsets][2]) >= 10.0) 
			|| (floatabs(RAKNET_ONFOOT[PR_surfingOffsets][0]) <= -10.0) 
			|| (floatabs(RAKNET_ONFOOT[PR_surfingOffsets][1]) <= -10.0) 
			|| (floatabs(RAKNET_ONFOOT[PR_surfingOffsets][2]) <= -10.0)) 
			{
				SAMP_AC_SEND_WARNING_FOR_SCRIPT(playerid, "Invisible Surfing", 20, 5);
			}
		}
	}