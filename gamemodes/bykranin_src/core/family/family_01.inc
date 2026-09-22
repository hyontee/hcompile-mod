//>> Файл: bykranin_src/core/family/family_01.inc  (355 строк)
//>> Тема: семьи / банды / организации
//>> Внутри: LoadGangZones, CreateZakazZakaz, ShowGangZonesForPlayer, LoadZakazTextz, LoadZakazTexta, LoadZakazTextk, LoadZakazTextb
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// ------------------------------------------
public: LoadGangZones()
{
	return 1;
}
stock CreateZakazZakaz(playerid)
{
//new fmt_str[80];
zakaz3_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 117.9998, 318.4267, " "); // пусто 
PlayerTextDrawLetterSize(playerid, zakaz3_PTD[playerid][0], 0.3118, 1.2713); 
PlayerTextDrawAlignment(playerid, zakaz3_PTD[playerid][0], 1); 
PlayerTextDrawColor(playerid, zakaz3_PTD[playerid][0], -1); 
PlayerTextDrawBackgroundColor(playerid, zakaz3_PTD[playerid][0], 255); 
PlayerTextDrawFont(playerid, zakaz3_PTD[playerid][0], 1); 
PlayerTextDrawSetProportional(playerid, zakaz3_PTD[playerid][0], 0); 
PlayerTextDrawSetShadow(playerid, zakaz3_PTD[playerid][0], 1); 
 
 //format(fmt_str, sizeof fmt_str, "ЛОХХХ");
//PlayerTextDrawSetString(playerid, business_menu_PTD[playerid][0], fmt_str);

 
// Экспортировано 5 текстдравов.
}
stock ShowGangZonesForPlayer(playerid)
{
	/*for(new idx; idx < sizeof g_gang_zone; idx ++)
	{
		GangZoneShowForPlayer(playerid, GetGangZoneData(idx, GZ_ZONE), gang_zone_colors[ GetGangZoneData(idx, GZ_GANG) ]);
	}

	if(g_capture[C_STATUS])
		GangZoneFlashForPlayer(playerid, GetGangZoneData(g_capture[C_GANG_ZONE], GZ_ZONE), gang_zone_colors[ g_capture[C_ATTACK_TEAM] ]);*/
		return 1;
}
stock LoadZakazTextz()
{
new playerid;
new query[100];
   new Cache: result;
new shet=0;
    new fmt_text[555];
    new fmt_msg[555];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    mysql_format(mysql, query, sizeof query, "SELECT name FROM family ORDER BY ochki1 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);

    if (cache_num_rows(result))
    {
        new name[32];
        cache_get_field_content(0, "name", name);
        shet = GetFamilyData(fam_id, F_OCZAVOD);

format(fmt_msg, sizeof fmt_msg, "{ffff00}Завод Бусаево\nДанным предприятием владеет семья: \n{%06x} %s",family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8,name);
vishka2 = Create3DTextLabel("Вышка сотовой связи Номер 1\nДанным предприятием владеет семья", COLOR_RED, -572.333862,-1969.903076,41.242153+1.8, 25.0 , 0, 1);
Update3DTextLabelText (vishka2, COLOR_RED,fmt_msg);
}
}
stock LoadZakazTexta()
{
new playerid;
new query[100];
   new Cache: result;
new shet=0;
    new fmt_text[555];
    new fmt_msg[555];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    mysql_format(mysql, query, sizeof query, "SELECT name FROM family ORDER BY ochki2 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);

    if (cache_num_rows(result))
    {
        new name[32];
        cache_get_field_content(0, "name", name);
        shet = GetFamilyData(fam_id, F_VISHARZ);

format(fmt_msg, sizeof fmt_msg, "{ffff00}Вышка сотовой связи Номер 1\nДанным предприятием владеет семья: \n{%06x} %s",family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8,name);
vishka3 = Create3DTextLabel("Вышка сотовой связи Номер 1\nДанным предприятием владеет семья", COLOR_RED, 883.485351,1923.192260,23.912017+1.8, 25.0 , 0, 1);
Update3DTextLabelText (vishka2, COLOR_RED,fmt_msg);
}
}
stock LoadZakazTextk()
{
new playerid;
new query[100];
   new Cache: result;
new shet=0;
    new fmt_text[555];
    new fmt_msg[555];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    mysql_format(mysql, query, sizeof query, "SELECT name FROM family ORDER BY ochki3 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);

    if (cache_num_rows(result))
    {
        new name[32];
        cache_get_field_content(0, "name", name);
        shet = GetFamilyData(fam_id, F_VISHKAR);

format(fmt_msg, sizeof fmt_msg, "{ffff00}Вышка сотовой связи Номер 2\nДанным предприятием владеет семья: \n{%06x} %s",family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8,name);
vishka5 = Create3DTextLabel("Вышка сотовой связи Номер 1\nДанным предприятием владеет семья", COLOR_RED, 231.307479,-1511.850830,35.371898+1.8, 25.0 , 0, 1);
Update3DTextLabelText (vishka2, COLOR_RED,fmt_msg);
}
}
stock LoadZakazTextb()
{
new playerid;
new query[100];
   new Cache: result;
new shet=0;
    new fmt_text[555];
    new fmt_msg[555];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    mysql_format(mysql, query, sizeof query, "SELECT name FROM family ORDER BY ochki4 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);

    if (cache_num_rows(result))
    {
        new name[32];
        cache_get_field_content(0, "name", name);
        shet = GetFamilyData(fam_id, F_VISBUS);

vishka4 = Create3DTextLabel("Вышка сотовой связи Номер 1\nДанным предприятием владеет семья", COLOR_RED, 2673.193847,569.579406,15.665578+1.8, 25.0 , 0, 1);
Update3DTextLabelText (vishka2, COLOR_RED,fmt_msg);
}
}
stock LoadZakazText()
{
new playerid;
new query[100];
   new Cache: result;
new shet=0;
    new fmt_text[555];
    new fmt_msg[555];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    mysql_format(mysql, query, sizeof query, "SELECT name FROM family ORDER BY ochki DESC LIMIT 1");
    result = mysql_query(mysql, query, true);

    if (cache_num_rows(result))
    {
        new name[32];
        cache_get_field_content(0, "name", name);
        shet = GetFamilyData(fam_id, F_OCKIFARMA);

format(fmt_msg, sizeof fmt_msg, "{ffff00}Ферма Гарель\n  {ffffff}Данным предприятием владеет семья: \n{%06x} %s",family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8,name);
vishka1 = Create3DTextLabel("Вышка сотовой связи Номер 1\nДанным предприятием владеет семья", COLOR_RED, 2323.015136,-264.258728,1.538782+1.8, 25.0 , 0, 1);
Update3DTextLabelText (vishka1, COLOR_RED,fmt_msg);
}
}
public: OnZakazz()
{
zona2 = CreateDynamicRectangle(-520.111389,-2000.643554, -637.456054,-2000.169677, 0, 0,-1);
zona21 = GangZoneCreate(-520.111389,-2000.643554, -637.456054,-2000.169677);
     GangZoneShowForAll(zona21,0xFF0000FF);
}
public: OnZakaza()
{
zona3 = CreateDynamicRectangle(902.390869,1923.410034, 883.663146,1904.885742, 0, 0,-1);
zona31 = GangZoneCreate(902.390869,1923.410034, 883.663146,1904.885742);
     GangZoneShowForAll(zona31,0xFF0000FF);
}
public: OnZakazk()
{
zona5 = CreateDynamicRectangle(237.247787,-1511.454345, 227.611984,-1504.807006, 0, 0,-1);
zona51 = GangZoneCreate(237.247787,-1511.454345, 227.611984,-1504.807006);
     GangZoneShowForAll(zona51,0xFF0000FF);
}
public: OnZakazb()
{
zona4 = CreateDynamicRectangle(2677.253173,561.331115,2677.253173,561.331115, 0, 0,-1);
zona41 = GangZoneCreate(2677.253173,561.331115,2677.253173,561.331115);
     GangZoneShowForAll(zona41,0xFF0000FF);
}
public: OnZakaz()
{
zona1 = CreateDynamicRectangle(2329.879882,-238.996139, 2288.374511,-277.397338, 0, 0,-1);
zona11 = GangZoneCreate(2329.879882,-238.996139, 2288.374511,-277.397338);
     GangZoneShowForAll(zona11,0xFF0000FF);
}
stock UpdateGangZone(idx)
{
	/*if(!GetGangZoneData(idx, GZ_GANG))
	{
		new area_players[3];

		foreach(new i : Player)
		{
			if(!IsPlayerConnected(i)) continue;
			else if(!IsPlayerLogged(i)) continue;
			else if(!IsPlayerInDynamicArea(i, GetGangZoneData(idx, GZ_AREA))) continue;
			else if(!(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(i) <= TEAM_OPG_LYTKARINSKAYA)) continue;

			area_players[ GetPlayerTeamEx(i) - TEAM_OPG_ARZAMASKAYA ] ++;
		}

		for(new i; i < 3; i++)
		{
			if(area_players[i] < MIN_PLAYERS_FOR_CAPTURE) continue;

			SetGangZoneData(idx, GZ_GANG, i + 1);
			SaveGangZone(idx + 1);

			GangZoneShowForAll(GetGangZoneData(idx, GZ_ZONE), gang_zone_colors[i + 1]);

			new fmt_text[50];

			format(fmt_text, sizeof fmt_text, "%s захватили новую территорию", GetTeamName(i + TEAM_OPG_ARZAMASKAYA));
			SendMessageToGang(fmt_text, 0xFF5533FF);

			UpdateGangRepository(i);

			break;
		}
	}*/
	return 1;
}

stock SaveGangZone(idx)
{
	new query[65];

	mysql_format(mysql, query, sizeof query, "UPDATE gang_zones SET fraction=%d WHERE id=%d", GetGangZoneData(idx, GZ_GANG), idx);
	mysql_query(mysql, query, false);
}

stock GetGangZonesCount(team)
{
	new count;

	for(new idx; idx < g_gang_zones_loaded; idx ++)
	{
		if(GetGangZoneData(idx, GZ_GANG) != team) continue;

		count ++;
	}

	return count;
}

// ------------------------------------------
public: LoadGangRepositories()
{
	new idx;
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT * FROM gang_repositories", true);
	rows = cache_num_rows(result);

	if(rows > MAX_GZ)
	{
		rows = MAX_GZ;
		print("[GangRepositories]: DB rows > MAX_GANG_REPOSITORIES");
	}

	for(idx = 0; idx < rows; idx ++)
	{
		SetGangRepositoryData(idx, GR_GANG, 		cache_get_field_content_int(idx, "id"));
		SetGangRepositoryData(idx, GR_METALL, 		cache_get_field_content_int(idx, "metall"));
		SetGangRepositoryData(idx, GR_AMMO, 		cache_get_field_content_int(idx, "ammo"));
		SetGangRepositoryData(idx, GR_DRUGS, 		cache_get_field_content_int(idx, "drugs"));
		SetGangRepositoryData(idx, GR_MONEY, 		cache_get_field_content_int(idx, "money"));

		SetGangRepositoryData(idx, GR_LOCK, 		bool: cache_get_field_content_int(idx, "lock"));

		new fmt_text[330],
			gang_id = GetGangRepositoryData(idx, GR_GANG);

		format
		(
			fmt_text, sizeof fmt_text,
			"Количество\n\
			территорий: {99FF99}%d\n\n\n\n\
			{%06x}Склад\n\
			%s\n\n\
			{FFFFFF}Наркотики: {ff9900}%d из 20000 г\n\
			{FFFFFF}Патроны: {ff9900}%d из 50000 шт\n\
			{FFFFFF}Материалы: {ff9900}%d из 6000 кг\n\
			{FFFFFF}Деньги: {3366FF}%d руб\n\n\
			%s\
			",
			GetGangZonesCount(gang_id + 1),
			gang_zone_colors[gang_id] >>> 8,
			GetTeamName(idx + TEAM_OPG_ARZAMASKAYA),
			GetGangRepositoryData(idx, GR_DRUGS),
			GetGangRepositoryData(idx, GR_AMMO),
			GetGangRepositoryData(idx, GR_METALL),
			GetGangRepositoryData(idx, GR_MONEY),
			GetGangRepositoryData(idx, GR_LOCK) ? "{66CC33}Открыт" : "{FF3300}Закрыт"
		);

		g_gang_repository[idx][GR_LABEL] = Create3DTextLabel
		(
			fmt_text,
			0xFFFFFFFF,
			GetTeamData(idx + TEAM_OPG_ARZAMASKAYA, O_REPOSITORY_POS)[0],
			GetTeamData(idx + TEAM_OPG_ARZAMASKAYA, O_REPOSITORY_POS)[1],
			GetTeamData(idx + TEAM_OPG_ARZAMASKAYA, O_REPOSITORY_POS)[2] + 1.5,
			10.0, idx + 1, 0
		);

		g_gang_repository[idx][GR_PICKUP] = CreatePickup
		(
			1239,
			23,
			GetTeamData(idx + TEAM_OPG_ARZAMASKAYA, O_REPOSITORY_POS)[0],
			GetTeamData(idx + TEAM_OPG_ARZAMASKAYA, O_REPOSITORY_POS)[1],
			GetTeamData(idx + TEAM_OPG_ARZAMASKAYA, O_REPOSITORY_POS)[2],
			idx + 1,
			PICKUP_ACTION_TYPE_GANG_REPOSIT,
			gang_id
		);
	}

	cache_delete(result);

	printf("[GangRepositories]: Склады банд загружены");
}

stock UpdateGangRepository(idx)
{
	new fmt_text[330],
		gang_id = GetGangRepositoryData(idx, GR_GANG);

	format
	(
		fmt_text, sizeof fmt_text,
		"Количество\n\
		территорий: {99FF99}%d\n\n\n\n\
		{%06x}Склад\n\
		%s\n\n\
		{FFFFFF}Наркотики: {ff9900}%d из 20000 г\n\
		{FFFFFF}Патроны: {ff9900}%d из 50000 шт\n\
		{FFFFFF}Материалы: {ff9900}%d из 6000 кг\n\
		{FFFFFF}Деньги: {3366FF}%d руб\n\n\
		%s\
		",
		GetGangZonesCount(gang_id),
		gang_zone_colors[gang_id] >>> 8,
		GetTeamName(idx + TEAM_OPG_ARZAMASKAYA),
		GetGangRepositoryData(idx, GR_DRUGS),
		GetGangRepositoryData(idx, GR_AMMO),
		GetGangRepositoryData(idx, GR_METALL),
		GetGangRepositoryData(idx, GR_MONEY),
		GetGangRepositoryData(idx, GR_LOCK) ? "{66CC33}Открыт" : "{FF3300}Закрыт"
	);

	UpdateDynamic3DTextLabelText(GetGangRepositoryData(idx, GR_LABEL), 0xFFFFFFFF, fmt_text);
}

// ------------------------------------------
public: LoadEntrances()
{
	return 0;
}

