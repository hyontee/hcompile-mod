
// (md_OnPlayerKeyStateChange)


stock md_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	new bool:isReturn = false;
	if ((oldkeys & newkeys)) 
		return isReturn;
	switch (newkeys) {
		case KEY_WALK, KEY_CROUCH, KEY_CTRL_BACK: {
			if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
				for (new id = 0; id < sizeof (MovingDoorInfo); id++) {
					if (MovingDoorInfo[id][mdKeyAction] != newkeys) 
						continue;
					if (MovingDoorInfo[id][mdInterior] != -1 && GetPlayerInterior(playerid) != MovingDoorInfo[id][mdInterior])
						continue;
					if (MovingDoorInfo[id][mdWorld] != -1 && GetPlayerVirtualWorld(playerid) != MovingDoorInfo[id][mdWorld])
						continue;
					if (!IsPlayerInRangeOfPoint(playerid, 2.2, MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1], MovingDoorInfo[id][mdClosedPos][2]))
						continue;
					if (MovingDoorInfo[id][mdMember] && MovingDoorInfo[id][mdMember] != pInfo[playerid][pMember] && pInfo[playerid][pFracIntKeys][MovingDoorInfo[id][mdMember]-1] != 322)
						continue;
					MovingDoorInfo[id][mdIsOpened] = !MovingDoorInfo[id][mdIsOpened];
					if (MovingDoorInfo[id][mdIsOpened]) {
						MoveDynamicObject(MovingDoorInfo[id][mdObjectID],
							MovingDoorInfo[id][mdOpenPos][0], MovingDoorInfo[id][mdOpenPos][1] + 0.001,
							MovingDoorInfo[id][mdOpenPos][2], 0.020,
							MovingDoorInfo[id][mdOpenPos][3], MovingDoorInfo[id][mdOpenPos][4],
							MovingDoorInfo[id][mdOpenPos][5]
						);
					} else {
						MoveDynamicObject(MovingDoorInfo[id][mdObjectID],
							MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1] - 0.001,
							MovingDoorInfo[id][mdClosedPos][2], 0.020,
							MovingDoorInfo[id][mdClosedPos][3], MovingDoorInfo[id][mdClosedPos][4],
							MovingDoorInfo[id][mdClosedPos][5]
						);
					}
					isReturn = true;
					break;
				}
			}
			if (isReturn) return true;
			for (new id = 0, Float:distance; id < sizeof (MovingGateInfo); id++) {
				if (gettime() <= MovingGateInfo[id][mdFloodTimer]) 
					continue;
				if (MovingGateInfo[id][mdInterior] != -1 && GetPlayerInterior(playerid) != MovingGateInfo[id][mdInterior])
					continue;
				if (MovingGateInfo[id][mdWorld] != -1 && GetPlayerVirtualWorld(playerid) != MovingGateInfo[id][mdWorld])
					continue;
				if (MovingGateInfo[id][mdMember][0] && MovingGateInfo[id][mdMember][0] == pInfo[playerid][pMember]) { }
				else if (MovingGateInfo[id][mdMember][1] && MovingGateInfo[id][mdMember][1] == pInfo[playerid][pMember]) { }
				else continue;

				if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
					distance = 0.50;
					if (newkeys != KEY_WALK) continue;
				}
				else if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
					distance = 10.0;
					if (newkeys != KEY_CROUCH) continue;
				}
				else continue;

				if (!IsPlayerInRangeOfPoint(playerid, distance, MovingGateInfo[id][mdActionPos][0], MovingGateInfo[id][mdActionPos][1], MovingGateInfo[id][mdActionPos][2]))
					continue;
				MovingGateInfo[id][mdFloodTimer] = gettime() + 10;

				if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
					ApplyAnimation(playerid, "CASINO", "Slot_Plyr", 4.1, 0, 1, 1, 1, 0);
					SetPlayerFacingAngle(playerid, MovingGateInfo[id][mdActionPos][3]);
				}
				MovingGateInfo[id][mdIsOpened] = !MovingGateInfo[id][mdIsOpened];

				if (MovingGateInfo[id][mdIsOpened]) {
					MoveDynamicObject(MovingGateInfo[id][mdObjectID],
						MovingGateInfo[id][mdOpenPos][0], MovingGateInfo[id][mdOpenPos][1],
						MovingGateInfo[id][mdOpenPos][2], 1.020,
						MovingGateInfo[id][mdOpenPos][3], MovingGateInfo[id][mdOpenPos][4],
						MovingGateInfo[id][mdOpenPos][5]
					);
				} else {
					MoveDynamicObject(MovingGateInfo[id][mdObjectID],
						MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1],
						MovingGateInfo[id][mdClosedPos][2], 1.020,
						MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
						MovingGateInfo[id][mdClosedPos][5]
					);
				}
				isReturn = true;
				break;
			}
			if (isReturn) return true;
			
		}
	}
	return isReturn;
}





// (Перед) enum MOVING_DOOR_e {


enum MOVING_GATE_e {
	mdModel,
	Float:mdClosedPos[6],
	Float:mdOpenPos[6],
	Float:mdActionPos[4],
	mdMember[2],
	mdWorld,
	mdInterior,
	mdIndex,
	mdModelID,
	mdTXD[32],
	mdTexture[32],
	mdColor,
	mdObjectID,
	Text3D:mdTextID,
	bool:mdIsOpened,
	mdFloodTimer,
	mdTimer,
};
new MovingGateInfo[][MOVING_GATE_e] = {
	{ 975,
		{ 1135.374389, 1361.747314, 11.482428, 0.000000, 0.000000, 0.000000 }, // closed
		{ 1126.544433, 1361.747314, 11.482428, 0.000000, 0.000000, 0.000000 }, // opened
		{ 1140.6737, 1362.7390, 10.7796, 2.2409 }, // keyPos
		{ FRACTION_ARMY_SF, FRACTION_ARMY_LV }, 0, 0, 
		2, 19962, "samproadsigns", "stopsign", 0x00000000
	}
};



// (Перед) MySQLConnectToServerDataBase

	for (new id = 0, objectid; id < sizeof (MovingGateInfo); id++) {
		switch (MovingGateInfo[id][mdModel]) {
			case 975: format(t_string, sizeof (t_string), "Открыть/закрыть ворота: "colserver"\"ALT\"");
			default: format(t_string, sizeof (t_string), "Открыть/закрыть шлагбаум: "colserver"\"ALT\"");
		}
		MovingGateInfo[id][mdTextID] = CreateDynamic3DTextLabel(t_string, -1,
			MovingGateInfo[id][mdActionPos][0], MovingGateInfo[id][mdActionPos][1],
			MovingGateInfo[id][mdActionPos][2] + 0.5, 7.5, .testlos = 1,
			.worldid = MovingGateInfo[id][mdWorld], .interiorid = MovingGateInfo[id][mdInterior]
		), t_string[0] = EOS;

		objectid = CreateDynamicObject(MovingGateInfo[id][mdModel],
			MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1],
			MovingGateInfo[id][mdClosedPos][2], MovingGateInfo[id][mdClosedPos][3],
			MovingGateInfo[id][mdClosedPos][4], MovingGateInfo[id][mdClosedPos][5],
			MovingGateInfo[id][mdWorld], MovingGateInfo[id][mdInterior], -1, 180.0, 180.0
		);
		MovingGateInfo[id][mdObjectID] = objectid;

		SetDynamicObjectMaterial(objectid, MovingGateInfo[id][mdIndex],
			MovingGateInfo[id][mdModelID], MovingGateInfo[id][mdTXD],
			MovingGateInfo[id][mdTexture], MovingGateInfo[id][mdColor]
		);
		MovingGateInfo[id][mdIsOpened] = false;
	}


// Заменить (md_Timer)



static md_TimerTicks[2] = { 5, 10 };
stock md_Timer() {
	if (--md_TimerTicks[0] <= 0) {
		for (new id = 0; id < sizeof (MovingDoorInfo); id++) {
			if (!MovingDoorInfo[id][mdIsOpened]) 
				continue;
			MovingDoorInfo[id][mdTimer] -= md_TimerTicks[0];
	
			if (MovingDoorInfo[id][mdTimer] <= 0) {
				MovingDoorInfo[id][mdIsOpened] = false;

				MoveDynamicObject(MovingDoorInfo[id][mdObjectID],
					MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1] - 0.001,
					MovingDoorInfo[id][mdClosedPos][2], 0.020,
					MovingDoorInfo[id][mdClosedPos][3], MovingDoorInfo[id][mdClosedPos][4],
					MovingDoorInfo[id][mdClosedPos][5]
				);
				MovingDoorInfo[id][mdTimer] = 0;
			}
		}
		md_TimerTicks[0] = 5;
	}
	if (--md_TimerTicks[1] <= 0) {
		for (new id = 0; id < sizeof (MovingGateInfo); id++) {
			if (!MovingGateInfo[id][mdIsOpened]) 
				continue;
			if (gettime() <= MovingGateInfo[id][mdFloodTimer]) 
				continue;
			MovingGateInfo[id][mdTimer] -= md_TimerTicks[1];
	
			if (MovingGateInfo[id][mdTimer] <= 0) {
				MovingGateInfo[id][mdIsOpened] = false;

				MoveDynamicObject(MovingGateInfo[id][mdObjectID],
					MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1] - 0.001,
					MovingGateInfo[id][mdClosedPos][2], 0.020,
					MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
					MovingGateInfo[id][mdClosedPos][5]
				);
				MovingGateInfo[id][mdTimer] = 0;
			}
		}
		md_TimerTicks[1] = 20;
	}
}