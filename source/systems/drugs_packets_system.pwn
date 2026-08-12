
/*[00:30:41] [ Map Editor ] Exported Objects [chatlog.txt] START:

[00:30:41] CreateDynamicObject(1580, 2669.659912, -1975.123413, 12.484051, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // 0

[00:30:41] CreateDynamicObject(1580, 2796.123779, -1993.116821, 12.502035, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // 1

[00:30:41] CreateDynamicObject(1580, 2803.518798, -1810.304443, 9.262502, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // 2

[00:30:41] CreateDynamicObject(1580, 2831.883789, -1251.352539, 21.884290, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // 3

[00:30:41] CreateDynamicObject(1580, 2588.332275, -1086.080688, 67.415855, 11.699997, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // 4

[00:30:41] CreateDynamicObject(1580, 2500.895019, -1128.287719, 38.329204, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // 5

[00:30:41] CreateDynamicObject(1580, 2315.906494, -1190.872802, 26.876560, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // 6

[00:30:41] CreateDynamicObject(1580, 2405.620605, -1322.737304, 24.214168, 0.000000, 0.000000, -35.100002, 0, 0, -1, 200.00, 200.00); // 7

[00:30:41] CreateDynamicObject(1580, 2377.724609, -1435.961303, 22.931068, 0.000000, 0.000000, -43.100002, 0, 0, -1, 200.00, 200.00); // 8

[00:30:41] [ Map Editor ] Exported Objects [chatlog.txt] END.*/


// СДЕЛАТЬ ОТСЧЕТ ПО ТАЙМЕРУ ДЛЯ СПАВНА ЗАКЛАДОК
// СДЕЛАТЬ АДМИН КОМАНДЫ 1 - ТП К ЗАКЛАДКЕ 2 - СПАВН ЗАКЛАДКИ
// tAntiDrugTP
// Добавить в ptemp замер времени и выводить варнинг админам при слишком быстром сборке закладок, к примеру тп по закладкам на ракботе

enum drugs_info{
	drugObject,
	resptime,	//ms
	bool:drugstatus,
	Float:dposX,
	Float:dposY,
	Float:dposZ,
	Float:drX,
	Float:drY,
	Float:drZ
}

new DrugsInfo[][drugs_info] = {
	{INVALID_OBJECT_ID, 3600, false, 2669.659912, -1975.123413, 12.484051, 0.000000, 0.000000, 0.000000},
	{INVALID_OBJECT_ID, 3600, false, 2796.123779, -1993.116821, 12.502035, 0.000000, 0.000000, 0.000000},
	{INVALID_OBJECT_ID, 3600, false, 2803.518798, -1810.304443, 9.262502, 0.000000, 0.000000, 0.000000},
	{INVALID_OBJECT_ID, 3600, false, 2831.883789, -1251.352539, 21.884290, 0.000000, 0.000000, 0.000000},
	{INVALID_OBJECT_ID, 3600, false, 2588.332275, -1086.080688, 67.415855, 11.699997, 0.000000, 0.000000},
	{INVALID_OBJECT_ID, 3600, false, 2500.895019, -1128.287719, 38.329204, 0.000000, 0.000000, 0.000000},
	{INVALID_OBJECT_ID, 3600, false, 2315.906494, -1190.872802, 26.876560, 0.000000, 0.000000, 0.000000},
	{INVALID_OBJECT_ID, 3600, false, 2405.620605, -1322.737304, 24.214168, 0.000000, 0.000000, -35.100002},
	{INVALID_OBJECT_ID, 3600, false, 2377.724609, -1435.961303, 22.931068, 0.000000, 0.000000, -43.100002}
};

stock drg_OnGameModeInit()
{
	printf("ZAKLADKI LOADED: %d count", sizeof(DrugsInfo));
	for(new i; i < sizeof(DrugsInfo); i++) ZakladkaCreate(i);
	return 0;
}

stock drg_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	#pragma unused oldkeys
	if(newkeys == KEY_WALK)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			for(new i; i < sizeof(DrugsInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, DrugsInfo[i][dposX], DrugsInfo[i][dposY], DrugsInfo[i][dposZ]))
				{
					if(DrugsInfo[i][drugstatus] != true) continue;
					DestroyDynamicObject(DrugsInfo[i][drugObject]);
					DrugsInfo[i][drugObject] = INVALID_OBJECT_ID;
					DrugsInfo[i][resptime] = 3600;
					DrugsInfo[i][drugstatus] = false;
					ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,2000);

					new rand = random(10)+1;
					format(string_chat_, sizeof string_chat_, ""colserver"[Информация] "colwhi"Вы нашли пакет с наркотиками, вами было обнаружено "colserver"%d наркотиков", rand);
					SendClientMessage(playerid, -1, string_chat_), string_chat_[0] = EOS;
					if (pInfo[playerid][pDrugs] >= 100_000) return SendClientMessage(playerid, COLOR_GREY, !"У Вас максимальное количество наркотиков!");
					pInfo[playerid][pDrugs] += rand;
					if (pInfo[playerid][pDrugs] > 100_000) pInfo[playerid][pDrugs] = 100_000;
					break;
				}
			}
		}
	}
	return 0;
}


drugs_timer()
{
	for(new i; i < sizeof(DrugsInfo); i++) 
	{
		DrugsInfo[i][resptime]--;
		if(DrugsInfo[i][drugstatus] == false && DrugsInfo[i][resptime] <= 0) ZakladkaCreate(i);
	}
}
publics:ZakladkaCreate(zakl_id)
{
	new 
		zakladkaobj, 
		rand = random(2);
	switch(rand)
	{
		case 0: zakladkaobj = 1575;
		case 1: zakladkaobj = 1580;
		default: return printf("[zaklada] ERROR GENERATE RANDOM DRUGS PACKET id:%d", zakl_id);
	}

	if(DrugsInfo[zakl_id][drugObject] != INVALID_OBJECT_ID)
		return printf("[zakladka] ERROR ZakladkaCreate - id: %d", zakl_id);
	
	DrugsInfo[zakl_id][drugstatus] = true;
	DrugsInfo[zakl_id][resptime] = -1;
	DrugsInfo[zakl_id][drugObject] = CreateDynamicObject(zakladkaobj, DrugsInfo[zakl_id][dposX], DrugsInfo[zakl_id][dposY], DrugsInfo[zakl_id][dposZ], DrugsInfo[zakl_id][drX], DrugsInfo[zakl_id][drY], DrugsInfo[zakl_id][drZ]);
	return printf("[zakladka] %d has been spawned", zakl_id);
}
flags:spawndrug(CMD_ADMIN);
cmd:spawndrug(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return 1; 
	extract params -> new z_id; else
		return SendClientMessage(playerid, -1, !"yse /spawn_drug [id zakladki]");
	if(z_id < 0 || z_id > sizeof(DrugsInfo)) return
		SendMes(playerid, -1, "Номер закладки не должен быть меньше 0 и больше %d", sizeof(DrugsInfo));
	if(DrugsInfo[z_id][drugstatus] == true) return
		SendClientMessage(playerid, -1, !"Эта закладка уже заспавнена");
	format(string_chat_, sizeof string_chat_, "[A] Администратор %s заспавнил нарко-закладку (id:%d)", pInfo[playerid][pName] ,z_id);
	SendAdminMessage(COLOR_GREY, string_chat_), string_chat_[0] = EOS;
	return ZakladkaCreate(z_id);
}

flags:gozakladka(CMD_ADMIN);
cmd:gozakladka(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return 1; 
	extract params -> new z_id; else
		return SendClientMessage(playerid, -1, !"yse /spawn_drug [id zakladki]");
	if(z_id < 0 || z_id > sizeof(DrugsInfo)) return
		SendMes(playerid, -1, "Номер закладки не должен быть меньше 0 и больше %d", sizeof(DrugsInfo));
	SetPlayerPosAC(playerid, DrugsInfo[z_id][dposX], DrugsInfo[z_id][dposY], DrugsInfo[z_id][dposZ]+1.0, -1, -1);
	format(string_chat_, sizeof string_chat_, "%d %d", z_id, DrugsInfo[z_id][resptime]);
	SendClientMessage(playerid, COLOR_GREY, string_chat_), string_chat_[0] = EOS;
	return 1;
}