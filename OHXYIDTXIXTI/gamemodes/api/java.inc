#define PACKET_CUSTOMRPC    			        251

//Notif define
#define ENTER_ENGINE	3
#define ENTER_WEDDING	4
#define ENTER_CONT	5 // /CONT

stock ShowTestRadialMenuForCar(playerid, const params[], count) {
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 251);
    BS_WriteValue(bitstream, PR_UINT32, 99);

    BS_WriteValue(bitstream, PR_UINT16, count);
    for (new i = 0; i < count; i++) {
        BS_WriteValue(bitstream, PR_UINT16, params[i]);
    }

    BS_Send(bitstream, playerid);
    BS_Delete(bitstream);
    return true;
}

stock ShowBrDialogFuelFill(playerid, i, i2, i3, i4, i5, max_fuel, const initial_hint[]) {
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 251);
    BS_WriteValue(bitstream, PR_UINT32, 200);

	BS_WriteValue(bitstream, PR_UINT16, i);
	BS_WriteValue(bitstream, PR_UINT16, i2);
	BS_WriteValue(bitstream, PR_UINT16, i3);
	BS_WriteValue(bitstream, PR_UINT16, i4);
	BS_WriteValue(bitstream, PR_UINT16, i5);

	BS_WriteValue(bitstream, PR_UINT16, max_fuel);

	BS_WriteValue(bitstream, PR_INT16, strlen(initial_hint));
	BS_WriteValue(bitstream, PR_STRING, initial_hint);

	BS_Send(bitstream, playerid);
    BS_Delete(bitstream);
    return true;
}

stock UpdateGUIRadial(playerid, index, bool:value) {
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 251);
    BS_WriteValue(bitstream, PR_UINT32, 100);

    BS_WriteValue(bitstream, PR_UINT16, index);
    BS_WriteValue(bitstream, PR_BOOL, value);

    BS_Send(bitstream, playerid);
    BS_Delete(bitstream);
    return true;
}


new params1[100];
new paramsCount = 0;

CMD:radial(playerid) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);

	new vehicleid = GetPlayerVehicleID(playerid);
	new index = GetVehicleData(vehicleid, V_ACTION_ID);
    
    if (engine == 1) AddValueToRadialArray(6);
    if (lights == 1) AddValueToRadialArray(14);
	if (doors == 1) AddValueToRadialArray(3);
	if (GetOwnableCarData(index, OC_KEY_IN) == true) AddValueToRadialArray(2);

	ShowTestRadialMenuForCar(playerid, params1, sizeof(params1));

	// все остальное не трогаем, оно не работает, так как GetVehicleParamsEx залупа полная
}

stock AddValueToRadialArray(value) {
    if (paramsCount < sizeof(params1)) {
        params1[paramsCount] = value;
        paramsCount++;
    }
}

/*stock ShowNewNotification(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 251);
    BS_WriteValue(bitstream, PR_UINT32, 199);
    
    BS_WriteValue(bitstream, PR_INT16, type);
	BS_WriteValue(bitstream, PR_INT16, duration);
	BS_WriteValue(bitstream, PR_INT16, id);
	BS_WriteValue(bitstream, PR_INT16, subId);

	BS_WriteValue(bitstream, PR_INT16, strlen(btnCaption));
	BS_WriteValue(bitstream, PR_STRING, btnCaption);
	
	BS_WriteValue(bitstream, PR_INT16, strlen(caption));
	BS_WriteValue(bitstream, PR_STRING, caption);
    
    BS_Send(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);

	return true;
}*/

CMD:ttest(playerid) {
	ShowNewNotification(playerid, 4, 5, 1, 1, "Авторизироваться", "");
}

IPacket:251(playerid, BitStream:bitstream)
{
	new header, rpcid;

	BS_ReadValue(bitstream, PR_UINT8, header);
	BS_ReadValue(bitstream, PR_UINT32, rpcid);

	switch(rpcid) {
		case 27: {
		new operation;
		BS_ReadValue(bitstream, PR_UINT16, operation);

		switch(operation) {
				case 1: {
					callcmd::park(playerid, "");
				}
				case 2: {
					callcmd::key(playerid, "");

					new vehicleid = GetPlayerVehicleID(playerid);
					if(!IsABike(vehicleid))
					{
						if(vehicleid == GetPlayerOwnableCar(playerid) || vehicleid == GetPlayerAllowedCar(playerid))
						{
							new index = GetVehicleData(vehicleid, V_ACTION_ID);
							new bool: status = GetOwnableCarData(index, OC_KEY_IN);

							if(status) UpdateGUIRadial(playerid, 2, false);
							else UpdateGUIRadial(playerid, 2, true);
						}
					}
				}
				case 3: {
					callcmd::lock(playerid, "1");
					callcmd::radial(playerid);
				}
				case 5: {
					SendClientMessage(playerid, -1, "Система лаунч-контроля находиться в разработке!");
				}
				case 6: {
					callcmd::e(playerid, "");

					new vehicleid = GetPlayerVehicleID(playerid);
					if(!GetVehicleParam(vehicleid, V_ENGINE))
					{
						UpdateGUIRadial(playerid, 6, true);
					}
					else 
					{
						UpdateGUIRadial(playerid, 6, false);
					}
				}
				case 8: {
					SendClientMessage(playerid, -1, "Система прошивок (Drift) находиться в разработке!");
				}
				case 9: {
					SendClientMessage(playerid, -1, "Система прошивок (Comfort+) находиться в разработке!");
				}
				case 10: {
					SendClientMessage(playerid, -1, "Система прошивок (Sport) находиться в разработке!");
				}
				case 11: {
					SendClientMessage(playerid, -1, "Система прошивок (Sport+) находиться в разработке!");
				}
				case 12: {
					SendClientMessage(playerid, -1, "Система свечение (Неон) находиться в разработке!");
				}
				case 13: {
					SendClientMessage(playerid, -1, "Система прошивок (Подсветка) находиться в разработке!");
				}
				case 14: {
					callcmd::l(playerid);
					callcmd::radial(playerid);
				}
				case 15: {
					SendClientMessage(playerid, -1, "Система прошивок (Страбоскопы) находиться в разработке!");
				}
				case 16: {
					SendClientMessage(playerid, -1, "Система прошивок (Пневмо1) находиться в разработке!");
				}
				case 17: {
					SendClientMessage(playerid, -1, "Система прошивок (Пневмо2) находиться в разработке!");
				}
				case 18: {
					SendClientMessage(playerid, -1, "Система прошивок (Пневмо3) находиться в разработке!");
				}
				case 19: {
					SendClientMessage(playerid, -1, "Система прошивок (Гидравлика) находиться в разработке!");
				}
			}
		}
		case 28: {
			new sub_id, type;
			BS_ReadValue(bitstream, PR_UINT16, sub_id);
			BS_ReadValue(bitstream, PR_UINT16, type);

			switch(type) {
				case 0: { // когда на уведомлении нажали кнопку (согласие)
					switch(sub_id) { // получаеем уведомление по айди
						case 2: {
							ShowBrDialogFuelFill(playerid, 50, 50, 50, 50, 45, 100, "Рекомендуемый тип топлива: АИ-95");
							return;
						}
						case ENTER_ENGINE:callcmd::e(playerid, "");
						case ENTER_WEDDING:callcmd::yes_wedding(playerid);
						case ENTER_CONT:callcmd::cont(playerid);
					}
				}
				case 1: { // когда уведолмения скрылось при окончании времени или на него нажали (отказ)
					switch(sub_id) { // получаеем уведомление по айди
						case 1: {
							new str[256];
							format(str, sizeof(str), "{FFFF00}| {FFFFFF}Скрыто уведомление, под ID: {FFFF00}%d", sub_id);
							SendClientMessage(playerid, -1, str);
							return;
						}
					}
				}
			}
		}
		case 29: {
			new value, type, str[512];
			BS_ReadValue(bitstream, PR_UINT16, value);
			BS_ReadValue(bitstream, PR_UINT16, type);

			switch(type) {
				case 0: {
					new i = value * 50;

					format(str, sizeof(str), "{FFFF00}| {FFFFFF}Вы успешно заправили свой автомобиль, топливом {FFFF00}АИ-92, {FFFFFF}на сумму: {FFFF00}%d", i);
					SendClientMessage(playerid, -1, str);

					GivePlayerMoneyEx(playerid, -i);
				}
			}
		}
	}
}
