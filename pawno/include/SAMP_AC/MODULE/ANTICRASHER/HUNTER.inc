			if(SERVER_INFO[playerid][SAMP_TICK] - SERVER_INFO[playerid][SAMP_LAGG][90] < 500 && GetVehicleModel(GetPlayerVehicleID(playerid)) == 425)
			{
				SAMP_AC_SEND_WARNING_FOR_SCRIPT(playerid, "Hunter Crasher", 27, 0);
				return 0;
			}
			SERVER_INFO[playerid][SAMP_LAGG][90] = SERVER_INFO[playerid][SAMP_TICK];