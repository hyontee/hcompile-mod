	if(CENTER_CONTROLE[2][CONTROL_STATE] == 1)
	{
		if((_:RAKNET_ONFOOT[PR_quaternion][1] > _:0.000000 || _:RAKNET_ONFOOT[PR_quaternion][2] > _:0.000000) && RAKNET_ONFOOT[PR_weaponId] != WEAPON_PARACHUTE)
		{
			if(RAKNET_ONFOOT[PR_specialAction] != 3 && RAKNET_ONFOOT[PR_specialAction] != 11 && RAKNET_ONFOOT[PR_specialAction] != 13 && RAKNET_ONFOOT[PR_animationId] != 1130 && RAKNET_ONFOOT[PR_animationId] != 1132)
			{
				SAMP_AC_SEND_WARNING_FOR_SCRIPT(playerid, "Fly Hack", 2, 1);
			}
		}
	}
