	if(RAKNET_ONFOOT[PR_quaternion][0] > 1.0 || RAKNET_ONFOOT[PR_quaternion][0] < -1.0 
	|| RAKNET_ONFOOT[PR_quaternion][1] > 1.0 || RAKNET_ONFOOT[PR_quaternion][1] < -1.0 
	|| RAKNET_ONFOOT[PR_quaternion][2] > 1.0 || RAKNET_ONFOOT[PR_quaternion][2] < -1.0 
	|| RAKNET_ONFOOT[PR_quaternion][3] > 1.0 || RAKNET_ONFOOT[PR_quaternion][3] < -1.0)
	{
		SAMP_AC_SEND_WARNING_FOR_SCRIPT(playerid, "Quaterion Crasher", 34, 0);
		return false;
	}