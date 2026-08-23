CMD:saves(playerid, params[])
{

	if(pData[playerid][pAdmin] < 7) 
		return NoCMD(playerid);



	if(sscanf(params, "ds[32]s[32]", params[0], params[1], params[2])) 
	{
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"/saves [ID] [Наименование] [Доп.Информация]");
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"ID - для более точного понимания");
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"Наименование - основное наименование координаты. Макс - 32 символа");
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"Доп.Информация - дополнительный данные. Макс - 32 символа");

	}



	new 
		filename[128],
		tagstring[512],
		coordstring[512], 
		namestring[32];

	new 
		local_vw = GetPlayerVirtualWorld(playerid),
		local_int = GetPlayerInterior(playerid);

	new 
		Float:x, Float:y, Float:z, Float:r;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);

	format(filename, 128, "save_coord_brilliant_%d_%s.txt", params[0], params[1]);

	format(tagstring, sizeof(tagstring), "|----------%s----------|\r\n", params[0]);
	format(tagstring, sizeof(tagstring), "%s\r\n", params[2]);
	format(namestring, sizeof(namestring),"Позиция игрока (X | Y | Z | R | VI | VW):\r\n");
	format(coordstring,sizeof(coordstring),"%f, %f, %f, %f, %d, %d", x, y, z, r, local_vw, local_int);
	new File:File = fopen(filename, io_write);
	fwrite(File, tagstring);
	fwrite(File, namestring);
	fwrite(File, coordstring);
	fclose(File);	

	SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"Координаты успешно сохранены!");
	SFCM(playerid,COLOR_BLUE,"Подсказка: "cWH"Номер - %d | Наименование - %s",params[0], params[1]);
	SFCM(playerid,COLOR_BLUE,"Подсказка: "cWH"Доп.Информация - %s",params[2]);
	SFCM(playerid,COLOR_BLUE,"Подсказка: "cWH"Координаты: X - %f Y - %f Z - %f R - %f | Мир - %d | Интерьер - %d", x, y, z, r, local_vw, local_int);


	return true;
}

CMD:savec(playerid, params[])
{

	if(pData[playerid][pAdmin] < 7) 
		return NoCMD(playerid);



	if(sscanf(params, "ds[32]s[32]", params[0], params[1], params[2])) 
	{
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"/savec [ID] [Наименование] [Доп.Информация]");
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"ID - для более точного понимания");
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"Наименование - основное наименование координаты. Макс - 32 символа");
		SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"Доп.Информация - дополнительный данные. Макс - 32 символа");

	}



	new 
		filename[128],
		tagstring[512],
		coordstring[512], 
		namestring[32];

	new 
		local_vw = GetPlayerVirtualWorld(playerid),
		local_int = GetPlayerInterior(playerid);

	new 
		Float:x, Float:y, Float:z, Float:r;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);

	new 
		local_veh = GetPlayerVehicleID(playerid);

	format(filename, 128, "save_coord_brilliant_%d_%s.txt", params[0], params[1]);

	format(tagstring, sizeof(tagstring), "|----------%s----------|\r\n", params[0]);
	format(tagstring, sizeof(tagstring), "%s\r\n", params[2]);
	format(namestring, sizeof(namestring),"Позиция автомобиля (X | Y | Z | R | VI | VW):\r\n");
	format(coordstring,sizeof(coordstring),"%d %f, %f, %f, %f, %d, %d", local_veh, x, y, z, r, local_vw, local_int);
	new File:File = fopen(filename, io_write);
	fwrite(File, tagstring);
	fwrite(File, namestring);
	fwrite(File, coordstring);
	fclose(File);	

	SCM(playerid, COLOR_BLUE, !"Подсказка: "cWH"Координаты успешно сохранены!");
	SFCM(playerid,COLOR_BLUE,"Подсказка: "cWH"Номер - %d | Наименование - %s",params[0], params[1]);
	SFCM(playerid,COLOR_BLUE,"Подсказка: "cWH"Доп.Информация - %s", params[2]);
	SFCM(playerid,COLOR_BLUE,"Подсказка: "cWH"ID автомобиля - %d", local_veh);
	SFCM(playerid,COLOR_BLUE,"Подсказка: "cWH"Координаты: X - %f Y - %f Z - %f R - %f | Мир - %d | Интерьер - %d", x, y, z, r, local_vw, local_int);


	return true;
}