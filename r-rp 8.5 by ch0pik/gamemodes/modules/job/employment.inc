#define EM: EM_

/*
	DIALOG_EMPLOYMENT_INFO,
	DIALOG_EMPLOYMENT,
	DIALOG_EMPLOYMENT_QUIT,
*/


enum E_EMPLOYMENT_DATA
{
	em_name[64],
	Float:em_pos_x,
	Float:em_pos_y,
	Float:em_pos_z,
	em_level,
	em_payment,
	em_requirements[6]
}

static const EmploymentData[][E_EMPLOYMENT_DATA] = {
	{"Работник завода",           2463.2830,  -2110.2510, 13.5469,  1,  20000,  {-1, -1, -1, -1, -1, -1}},
	{"Шахтер",                    -437.2260,  2236.6550,  42.9766,  1,  20000,  {-1, -1, -1, -1, -1, -1}},
	{"Лесопилка",                 -264.2250,  -2210.1001, 28.8359,  1,  0,      {-1, -1, -1, -1, -1, -1}},
	{"Фермер",                    -381.2220,  -1438.4200, 26.0234,  1,  0,      {-1, -1, -1, -1, -1, -1}},
	{"Курьер",                    2104.6880,  -1806.5410, 13.5547,  2,  0,      {-1, -1, -1, -1, -1, -1}},
	{"Работник дорожной службы",  -1866.4280, -1688.2700, 21.7578,  2,  30000,  {0,  -1, -1, -1, -1, -1}},
	{"Электрик",                  -1965.8700, 265.91800,  35.1719,  6,  35000,  {0,  -1, -1, -1, -1, -1}},
	{"Водитель автобуса",         1729.8750,  -1944.6490, 13.5625,  4,  40000,  {0,  -1, -1, -1, -1, -1}},
	{"Таксист",                   1154.8900,  -1771.6700, 16.5938,  5,  45000,  {0,  -1, -1, -1, -1, -1}},
	{"Водитель мусоровоза",       2180.9300,  -1978.1301, 13.5469,  3,  55000,  {0,  -1, -1, -1, -1, -1}},
	{"Тонировщик",                -2709.2300, 218.07200,  4.3359,   9,  0,      {5,  -1, -1, -1, -1, -1}},
	{"Автомеханик",               -2035.7100, 147.45700,  28.8359,  8,  60000,  {0,  5,  -1, -1, -1, -1}},
	{"Нотариус",                  -2714.0300, 1481.6488,  1009.218, 10, 0,      {-1, -1, -1, -1, -1, -1}},
	{"Мойщик окон",               1467.4700,  -1790.2600, 12.5484,  12, 75000,  {5,  -1, -1, -1, -1, -1}},
	{"Работник на пирсе",         -2378.8800, 2404.6201,  6.4844,   14, 85000,  {1,  5,  -1, -1, -1, -1}},
	{"Работник на пирсе",         818.24400,  -1584.1600, 13.5469,  16, 0,      {0,  5,  -1, -1, -1, -1}},
	{"Дальнобойщик",              -77.09500,  -1136.3500, 1.0781,   20, 105000, {1,  5,  -1, -1, -1, -1}},
	{"Машинист поезда",           1698.4800,  -1953.1400, 13.5469,  20, 105000, {1,  5,  -1, -1, -1, -1}},
	{"Машинист метрополитена",    1698.4800,  -1953.1400, 13.5469,  25, 120000, {1,  5,  -1, -1, -1, -1}},
	{"Пилот",                     1537.1900,  -2496.9399, 13.5547,  30, 150000, {1,  5,  -1, -1, -1, -1}}
};

new PlayerEmploymentCP[MAX_PLAYERS] = {-1, ...};
new PlayerEmploymentTime[MAX_PLAYERS];
new PlayerEmploymentApply[MAX_PLAYERS] = {-1, ...};
new PlayerEmploymentDialog[MAX_PLAYERS];
new EmploymentCheckpoint;

stock EM_ManageJobs(playerid, type, jobid = -1, output[3] = {-1, -1, -1})
{
	output[0] = output[1] = output[2] = -1;
	mysql_format(mysql, str_q, sizeof(str_q), "SELECT jobs_em FROM PlayersMorallwens WHERE id = %d LIMIT 1", GetPlayerAccountID(playerid));
	new Cache:result = mysql_query(mysql, str_q);
	
	if(cache_num_rows())
	{
		new jobs[32], pos, idx, chr;
		cache_get_field_content(0, "jobs_em", jobs);
		
		if(strlen(jobs))
		{
			new tmp[8];
			while(idx < 3 && pos < strlen(jobs))
			{
				new tmpIdx = 0;
				while(pos < strlen(jobs) && (chr = jobs[pos]) != ',')
					tmp[tmpIdx++] = chr, pos++;
				tmp[tmpIdx] = EOS;
				if(tmpIdx > 0) output[idx++] = strval(tmp);
				pos++;
			}
		}
		
		switch(type)
		{
			case 1:
			{
				for(new i; i < 3; i++) if(output[i] == -1) { output[i] = jobid; break; }
				if(output[0] != -1 && output[1] != -1 && output[2] != -1)
					format(jobs, sizeof(jobs), "%d,%d,%d", output[0], output[1], output[2]);
				else if(output[0] != -1 && output[1] != -1)
					format(jobs, sizeof(jobs), "%d,%d", output[0], output[1]);
				else if(output[0] != -1)
					format(jobs, sizeof(jobs), "%d", output[0]);
				mysql_format(mysql, str_q, sizeof(str_q), "UPDATE PlayersMorallwens SET jobs_em = '%s' WHERE id = %d", jobs, GetPlayerAccountID(playerid));
				mysql_tquery(mysql, str_q);
			}
			case 2:
			{
				new newJobs[3] = {-1, -1, -1}, nIdx;
				for(new i; i < 3; i++) if(output[i] != jobid && output[i] != -1) newJobs[nIdx++] = output[i];
				output[0] = newJobs[0], output[1] = newJobs[1], output[2] = newJobs[2];
				if(newJobs[0] != -1 && newJobs[1] != -1 && newJobs[2] != -1)
					format(jobs, sizeof(jobs), "%d,%d,%d", newJobs[0], newJobs[1], newJobs[2]);
				else if(newJobs[0] != -1 && newJobs[1] != -1)
					format(jobs, sizeof(jobs), "%d,%d", newJobs[0], newJobs[1]);
				else if(newJobs[0] != -1)
					format(jobs, sizeof(jobs), "%d", newJobs[0]);
				else
					jobs[0] = EOS;
				mysql_format(mysql, str_q, sizeof(str_q), "UPDATE PlayersMorallwens SET jobs_em = '%s' WHERE id = %d", jobs, GetPlayerAccountID(playerid));
				mysql_tquery(mysql, str_q);
			}
		}
	}
	cache_delete(result);
	return 1;
}
stock EM_OpenInterface(playerid)
{
    new jobs[3];
    EM_ManageJobs(playerid, 0, -1, jobs);

    new jobsStr[64];
    if(jobs[0] != -1  jobs[1] != -1  jobs[2] != -1)
     format(jobsStr, sizeof(jobsStr), "[%d,%d,%d]", jobs[0], jobs[1], jobs[2]);
    else
     format(jobsStr, sizeof(jobsStr), "[]");

    new reqStr[32] = "[0]";

    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[19,[15,14],3,[0,2,3,4],[[0,1,20000,[0],[],[],1],[1,1,20000,[0],[],[],1],[2,1,0,[],[0,[[\"Лесоруб\",1],[\"Водитель пилорамы\",1],[\"Рамщик\",1]]],[],1],[3,1,0,[],[1,[[\"Перенос урожая\",1,500,500],[\"Посев\",2,500,500],[\"Удобрение\",3,500,500],[\"Сбор урожая\",4,288,500],[\"Вспахивание\",5,288,500],[\"Развозка сена\",6,288,500],[\"Развозка урожая\",7,-1,500],[\"Комбайн\",8,-1,500]]],[[3,1929.81,0,1,[0,0,100]],[4,1367.95,0,1,[0,0,100]]],1],[4,2,0,[],[],[],1],[5,2,30000,[0],[],[],1],[6,6,35000,[0],[],[],1],[7,4,40000,[0],[1,[[\"Сельский\",1,0,1000],[\"Городской\",2,-1,1000],[\"Междугородний\",3,-1,1000]]],[],1],[8,5,45000,[0],[],[],1],[9,3,32000,[0],[1,[[\"Мусорный бак\",1,0,500],[\"Манипулятор\",2,-1,500]]],[],1],[10,9,0,[5],[],[],1],[11,8,60000,[0,5],[1,[[\"Стандартная работа\",1,6,2000],[\"Возможность закупать топливо\",2,-1,2000]]],[],1],[12,10,0,[],[],[],1],[13,12,75000,[5],[],[],1],[14,14,85000,[1,5],[],[],1],[15,16,0,[0,5],[],[[0,2825.62,0,0,[75,99,0]],[1,2199.88,0,0,[75,95,0]],[2,2432.75,0,0,[75,99,0]]],1],[16,20,105000,[1,5],[],[],1],[17,20,105000,[1,5],[],[],1],[18,25,120000,[1,5],[1,[[\"Кукурузник\",1,0,30],[\"Airbus\",2,-1,30],[\"Boeing\",3,-1,30],[\"Business jet\",4,-1,30],[\"Business jet\",5,-1,30]]],[],1]]]", 
	GetPlayerLevel(playerid), jobsStr, reqStr,
	EmploymentData[0][em_level], EmploymentData[1][em_level], EmploymentData[2][em_level], EmploymentData[3][em_level],
	EmploymentData[4][em_level], EmploymentData[5][em_level], EmploymentData[6][em_level], EmploymentData[7][em_level],
	EmploymentData[8][em_level], EmploymentData[9][em_level], EmploymentData[10][em_level], EmploymentData[11][em_level],
	EmploymentData[12][em_level], EmploymentData[13][em_level], EmploymentData[14][em_level], EmploymentData[15][em_level],
	EmploymentData[16][em_level], EmploymentData[17][em_level], EmploymentData[18][em_level], EmploymentData[19][em_level]);
    MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Employment", STRING_GLOBAL);
    return 1;
}

stock EM_OnGameModeInit()
{
	CreateDynamic3DTextLabel("Прием на работу", 0xFFFF00FF, -2714.0300, 1481.6488, 1009.2178, 10.0);
	EmploymentCheckpoint = CreateDynamicCP(-2713.8264, 1481.6355, 1007.4878, 1.5, -1, -1, -1, 7.0);
	return 1;
}

stock EM_OnPlayerKeyStateChange(playerid, newkeys)
{
	#pragma unused newkeys
	if(IsPlayerInDynamicCP(playerid, EmploymentCheckpoint))
	{
		if(gettime() - PlayerEmploymentDialog[playerid] < 2) return 1;
		PlayerEmploymentDialog[playerid] = gettime();
		return Dialog(playerid, DIALOG_EMPLOYMENT, DIALOG_STYLE_MSGBOX, "{FFCD00}Прием на работу", "{FFFFFF}Вы хотите просмотреть список доступных работ?", "Да", "Нет", 0, 0), 1;
	}
	return 0;
}

stock Employment_OnPlayerApply(playerid, jobid)
{
	if(gettime() - PlayerEmploymentTime[playerid] < 2)
		return GameText(playerid, "~y~Подождите немного...", 2000, 2), 1;
	
	PlayerEmploymentTime[playerid] = gettime();
	
	new jobs[3];
	EM_ManageJobs(playerid, 0, -1, jobs);
	
	new count;
	for(new i; i < 3; i++) if(jobs[i] != -1) count++;
	if(count >= 3) return SendClientMessage(playerid, 0x75A3D2AA, "Максимум можно трудоустроиться на 3 работы."), 1;
	
	for(new i; i < 3; i++) if(jobs[i] == jobid)
		return SendClientMessage(playerid, 0x75A3D2AA, "Вы уже работаете на этой профессии."), 1;
	
	if(jobid < 0 || jobid >= sizeof(EmploymentData)) return 1;
	if(GetPlayerLevel(playerid) < EmploymentData[jobid][em_level])
		return SendClientMessage(playerid, 0x75A3D2AA, "Недостаточный уровень для трудоустройства."), 1;
	
	if(EmploymentData[jobid][em_payment] == 0)
	{
		PlayerEmploymentApply[playerid] = jobid;
		return Dialog(playerid, DIALOG_EMPLOYMENT_INFO, DIALOG_STYLE_MSGBOX, "Центр занятости", "Вы не можете устроиться на временную работу.\nДля начала работы Вам необходимо отметить её на карте.\nПосле этого приехать на нее, переодеться и приступить к работе", "Понятно", "", 0, 0);
	}
	
	EM_ManageJobs(playerid, 1, jobid, jobs);
	
	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "[%d,%d,%d]", jobs[0], jobs[1], jobs[2]);
	SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Employment').showNotification()");
	format(str_q, sizeof(str_q), "interface('Employment').setCurrentEmployments(%s)", STRING_GLOBAL);
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, str_q);
	
	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Поздравляем! {66CC00}Вы устроились на работу: %s.", EmploymentData[jobid][em_name]);
	SendClientMessage(playerid, 0xFFFF00FF, STRING_GLOBAL);
	SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {FF9900}навигатор {FFFFFF}чтобы найти стоянку транспорта.");
	SendClientMessage(playerid, 0xFFFFFFFF, "Используйте радиальное меню -> персонаж -> список профессий для ознакомления с Вашими профессиями.");
	return 1;
}

stock Employment_OnPlayerQuit(playerid, jobid)
{
	new jobs[3];
	EM_ManageJobs(playerid, 0, -1, jobs);
	
	new hasJob;
	for(new i; i < 3; i++) if(jobs[i] == jobid) { hasJob = 1; break; }
	if(!hasJob) return SendClientMessage(playerid, 0x75A3D2AA, "Вы не работаете на этой профессии."), 1;
	if(jobid < 0 || jobid >= sizeof(EmploymentData)) return 1;
	
	new dialog_text[256];
	format(dialog_text, sizeof(dialog_text), "{FFFFFF}Вы действительно хотите уволиться с работы: {FFCD00}'%s' {FFFFFF}?", EmploymentData[jobid][em_name]);
	PlayerEmploymentCP[playerid] = jobid;
	return Dialog(playerid, DIALOG_EMPLOYMENT_QUIT, DIALOG_STYLE_MSGBOX, "{B3CA5A}Увольнение с работы", dialog_text, "Уволиться", "Закрыть");
}

stock Employment_OnPlayerMark(playerid, jobid)
{
	if(jobid < 0 || jobid >= sizeof(EmploymentData)) return 1;
	GameText(playerid, "~w~На карте отмечено ~n~местоположение работы", 4000, 2);
	SendClientMessage(playerid, 0x75A3D2AA, "На карте отмечено местоположение работы.");
	SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "window.getRoute(%f,%f,%f,%f,%f,%f,0,1)", EmploymentData[jobid][em_pos_x], EmploymentData[jobid][em_pos_y], EmploymentData[jobid][em_pos_z], EmploymentData[jobid][em_pos_x], EmploymentData[jobid][em_pos_y], EmploymentData[jobid][em_pos_z]);
	return 1;
}

stock Employment_OnPlayerClose(playerid)
{
	#pragma unused playerid
	return 1;
}
CMD:jobs(playerid)
{
	new jobs[3];
	EM_ManageJobs(playerid, 0, -1, jobs);
	
	new count;
	for(new i; i < 3; i++) if(jobs[i] != -1) count++;
	if(!count) return SendClientMessage(playerid, 0x75A3D2AA, "У вас нет профессий."), 1;
	
	new dialog_text[512];
	format(dialog_text, sizeof(dialog_text), "{ffffff}Специальность\t{ffffff}Должность\n");
	
	for(new i; i < 3; i++)
	{
		if(jobs[i] != -1 && jobs[i] >= 0 && jobs[i] < sizeof(EmploymentData))
		{
			format(str_q, sizeof(str_q), "%d. {ffffff}%s\t{ffffff}Обычная\n", i + 1, EmploymentData[jobs[i]][em_name]);
			strcat(dialog_text, str_q);
		}
	}
	return Dialog(playerid, DIALOG_EMPLOYMENT_LIST, DIALOG_STYLE_TABLIST_HEADERS, "{B3CA5A}Мои профессии", dialog_text, "Уволиться", "Закрыть");
}

stock JobInvite(playerid, job)
{
	for(new i; i < 3; i++)
    {
        if(g_player_jobs[playerid][i] != -1) continue;
        if(g_player_jobs[playerid][i] == -1) g_player_jobs[playerid][i] = job;
		break;
    }

	STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE PlayersMorallwens SET job_slot_1='%d',job_slot_2='%d',job_slot_3='%d' WHERE id = %d LIMIT 1", g_player_jobs[playerid][0], g_player_jobs[playerid][1], g_player_jobs[playerid][2], GetPlayerAccountID(playerid));
    mysql_query(mysql, STRING_GLOBAL);

	return 1;
}

stock EM_OnDialogResponse(playerid, dialogid, response, listitem)
{
	#pragma unused listitem
	switch(dialogid)
	{
		case DIALOG_EMPLOYMENT:
		{
			if(response) EM_OpenInterface(playerid);
			return 1;
		}
		case DIALOG_EMPLOYMENT_INFO:
		{
			return 1;
		}
		case DIALOG_EMPLOYMENT_QUIT:
		{
			if(response)
			{
				new jobid = PlayerEmploymentCP[playerid];
				if(jobid != -1 && jobid >= 0 && jobid < sizeof(EmploymentData))
				{
					new jobs[3];
					EM_ManageJobs(playerid, 2, jobid, jobs);

					format(STRING_GLOBAL, sizeof(STRING_GLOBAL), (jobs[0] != -1 || jobs[1] != -1 || jobs[2] != -1) ? "[%d,%d,%d]" : "[]", jobs[0], jobs[1], jobs[2]);
					format(str_q, sizeof(str_q), "interface('Employment').setCurrentEmployments(%s)", STRING_GLOBAL);
					MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, str_q);

					format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Вы уволились с работы: \"%s\"", EmploymentData[jobid][em_name]);
					SendClientMessage(playerid, 0xFF6600FF, STRING_GLOBAL);
					GameText(playerid, "~g~Успешное~n~увольнение", 2500, 2);
					PlayerEmploymentCP[playerid] = -1;
				}
			}
			return 1;
		}
		case DIALOG_EMPLOYMENT_LIST:
		{
			if(response && listitem >= 0 && listitem < 3)
			{
				new jobs[3];
				EM_ManageJobs(playerid, 0, -1, jobs);
				if(jobs[listitem] != -1 && jobs[listitem] >= 0 && jobs[listitem] < sizeof(EmploymentData))
				{
					new jobid = jobs[listitem];
					new dialog_text[256];
					format(dialog_text, sizeof(dialog_text), "{FFFFFF}Вы действительно хотите уволиться с работы: {FFCD00}'%s' {FFFFFF}?", EmploymentData[jobid][em_name]);
					PlayerEmploymentCP[playerid] = jobid;
					Dialog(playerid, DIALOG_EMPLOYMENT_QUIT, DIALOG_STYLE_MSGBOX, "{B3CA5A}Увольнение с работы", dialog_text, "Уволиться", "Закрыть");
				}
			}
			return 1;
		}
	}
	return 0;
}

