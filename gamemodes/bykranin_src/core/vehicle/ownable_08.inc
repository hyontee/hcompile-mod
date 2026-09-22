//>> Файл: bykranin_src/core/vehicle/ownable_08.inc  (234 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: GetPlayerSpeed, SetVehicleSpeed, IsPlayerDriver, IsPlayerPassenger, Speedometr01ShowForPlayer, SpeedometrHideForPlayer, CreateSpeedometr01ForPlayer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetPlayerSpeed(playerid)
{
	new Float: x, Float: y, Float: z;
	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehicleVelocity(GetPlayerVehicleID(playerid), x, y, z);
	}
					else GetPlayerVelocity(playerid, x, y, z);

	return floatround(floatsqroot(x*x+y*y+z*z)*100);
}

stock SetVehicleSpeed(vehicleid, Float: speed)
{
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		new Float: x,
			Float: y,
			Float: z,
			Float: angle;

		GetVehicleVelocity(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);

		speed /= 100.0;
        x = speed * floatsin(-angle, degrees);
        y = speed * floatcos(-angle, degrees);

        return SetVehicleVelocity(vehicleid, x, y, z - speed / 1000.0);

/*
		speed = floatsqroot(x*x+y*y+z*z);

		if(speed > 0)
		{
			multiple = (kmh / (speed * 100));

			return SetVehicleVelocity(vehicleid, x * multiple, y * multiple, z * multiple);
		}
*/
	}

	return 0;
}
stock IsPlayerDriver(playerid) // сидит ли игрок за рулем ТС
{
	return (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER);
}

stock IsPlayerPassenger(playerid) // сидит ли игрок как пассажир
{
	return (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER);
}

stock Speedometr01ShowForPlayer(playerid)
{
}

stock SpeedometrHideForPlayer(playerid)
{

}

stock CreateSpeedometr01ForPlayer(playerid)
{
	speedometr_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 273.3996, 377.2600, "Sheatch_A"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][0], 0.1602, 0.6442);
	PlayerTextDrawTextSize(playerid, speedometr_PTD[playerid][0], -58.0000, 0.0000);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][0], -2147483393);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][0], 0);

	speedometr_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 276.1997, 384.3466, "0"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][1], 0.4731, 2.2022);
	PlayerTextDrawTextSize(playerid, speedometr_PTD[playerid][1], 2.0000, 0.0000);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][1], -16776961);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][1], 0);

	speedometr_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 338.6995, 407.5964, "100_L"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][2], 0.1558, 0.8732);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][2], 0);

	speedometr_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 365.1012, 407.2963, "100_%"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][3], 0.1578, 0.8732);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][3], 0);

	speedometr_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 346.7994, 364.3417, "."); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][4], 0.6183, 2.7697);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][4], 16711935);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][4], 0);

	speedometr_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 372.5010, 364.3417, "."); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][5], 0.6183, 2.7697);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][5], 16711935);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][5], 0);

	speedometr_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 364.7669, 370.6374, "."); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][6], 0.6183, 2.7697);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][6], 16711935);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][6], 0);

	speedometr_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 293.9000, 415.2975, "00000_km"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][7], 0.0915, 0.6686);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][7], -1378294017);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][7], 0);

}

stock Speedometr02ShowForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][0]);
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][1]);
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][2]);
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][3]);
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][4]);
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][5]);
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][6]);
	PlayerTextDrawShow(playerid, speedometr02_PTD[playerid][7]);

    for(new idx; idx < sizeof speedometr02_TD; idx ++)
		TextDrawShowForPlayer(playerid, speedometr02_TD[idx]);
}

stock CreateSpeedometr02ForPlayer(playerid)
{

    speedometr02_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 284.0002, 370.9864, "Sheatch_A"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][0], 0.1442, 0.6392);
	PlayerTextDrawTextSize(playerid, speedometr02_PTD[playerid][0], -1.0000, 0.0000);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][0], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][0], 0);

	speedometr02_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 283.8999, 380.1507, "000"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][1], 0.5735, 2.5308);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][1], 0);

	speedometr02_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 289.2998, 410.5108, "00000_km"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][2], 0.1090, 0.8582);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][2], 0);

	speedometr02_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 360.2994, 359.6276, "."); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][3], 0.4751, 2.3217);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][3], 16711935);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][3], 0);

	speedometr02_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 359.8994, 370.7283, "."); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][4], 0.4751, 2.3217);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][4], 16711935);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][4], 0);

	speedometr02_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 366.9998, 381.6290, "."); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][5], 0.4751, 2.3217);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][5], 16711935);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][5], 0);

	speedometr02_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 348.5995, 410.7492, "50_L"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][6], 0.0990, 0.7039);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][6], 0);

	speedometr02_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 364.8005, 410.7515, "100%"); // generated
	PlayerTextDrawLetterSize(playerid, speedometr02_PTD[playerid][7], 0.0955, 0.7188);
	PlayerTextDrawAlignment(playerid, speedometr02_PTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, speedometr02_PTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr02_PTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, speedometr02_PTD[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, speedometr02_PTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, speedometr02_PTD[playerid][7], 0);
}

