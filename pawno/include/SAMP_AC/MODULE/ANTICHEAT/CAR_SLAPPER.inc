	if(CENTER_CONTROLE[22][CONTROL_STATE] == 1 && SAMP_AC_CHECK_MODEL_VEHICLE(RAKNET_DRIVER[PR_vehicleId]))
	{
		if(SERVER_INFO[playerid][SAMP_TICK] > SERVER_INFO[playerid][SAMP_FIX_SPEED] && RAKNET_DRIVER[PR_velocity][2] > 3.50)
		{
			SAMP_AC_SEND_WARNING_FOR_SCRIPT(playerid, "Car Slapper", 22, 0); 
			return 0;
		}
	}
