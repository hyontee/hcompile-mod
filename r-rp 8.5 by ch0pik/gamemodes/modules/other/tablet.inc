stock OpenCefGang(playerid)
{
	STRING_GLOBAL[0] = EOS;
	new query[64],name[32],Cache: result,rows;
	new fam_id = GetPlayerFamily(playerid);
	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE family='%d'", fam_id);

	result = mysql_query(mysql, query);
	rows = cache_num_rows();

	for(new i; i < rows; i ++)
	{
		if(cache_get_field_content_int(i, "family_rank") == 10)
		{
			cache_get_field_content(i, "name", name);
		}
	}
	cache_delete(result);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Phone').getCurrentApp().setMainParams([\"%s\",1,\"%s\",0,0,%d,\"#%s\",%d,\"\",\"\",0,0,\"https://gl.hslcdn.com/\",1,1])",
	GetFamilyData(fam_id, F_NAME),name,GetPlayerSkin(playerid),GetFamilyData(fam_id, F_LOGO_TYPE),GetFamilyData(fam_id, F_COLOR_GANG));
	SendClientEvent(playerid, t_CefUpdate, STRING_GLOBAL);
	SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().setSelfStats([\"%s\",%d,[]])", GetPlayerNameEx(playerid), GetPlayerData(playerid, P_FAMILY_RANK));
	SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().setAsideStatsData([\"%s\",%d,[[\"Участников\",0,%d,0],[\"Домов\",1,0,5],[\"Автомобилей\",2,0,15],[\"Гаражей\",3,0,5]],%d,[],5,0,400])", name, GetFamilyData(fam_id, F_MONEY),rows,GetFamilyData(fam_id, F_CRIMINAL_INFLUENCE));
	SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().setAsideStatsDetails([[\"Дата создания\",\"%d.%d.%d %d:%d:%d\"],[\"Захваченных особняков\",0]])",GetFamilyData(fam_id, F_TIME_DAY),GetFamilyData(fam_id, F_TIME_MOUNTH),GetFamilyData(fam_id, F_TIME_YEAR),GetFamilyData(fam_id, F_TIME_HOUR),GetFamilyData(fam_id, F_TIME_MINUTE),GetFamilyData(fam_id, F_TIME_SECOND));
}
new rang_convert[11] = {0,1,1,1,2,2,2,3,3,4,4};
stock RangConvert(family_rank)
	return rang_convert[family_rank];

cmd:givefmoney(playerid)
{
	SetFamilyData(GetPlayerFamily(playerid),F_MONEY, 1000000);
}

stock LoadPhoneGangBuyImrovents(playerid)
{
	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Phone').getCurrentApp().addUpgradesPossibilities([[0,\"Создание отмычек\",\"Доступ к команде /makekey для изготовления отмычек, используемых при угоне транспорта и взломе дверей\",\
	1,5000000,0,0   ,0,0,\"Lockpick.png\","",%d   ,1,0,0,0],\
	[1,\"Угон автомобилей\",\"Занятие для участников семьи, позволяющее зарабатывать на угонах и продаже транспорта из списка заказов\",\
	1,500000,0,0,1,0,\"Car Theft 1.png\","",%d,1,0,0,0],\
	[2,\"Возможность угонять премиум класс\",\"Доступ к угону автомобилей премиального класса из списка заказов\",1,1000000,0,0,2,0,\
	\"Car Theft 2.png\","",%d,1,0,0,0],\
	[3,\"Двойное уменьшение задержки на угон\",\"Сокращение времени ожидания между взятием новых заказов на угон\",\
	1,500000,1,0,3,0,\"Car Theft 3.png\","",%d,1,0,0,0],\
	[4,\"Подпольное производство наркотиков\",\"Возможность заниматься созданием запрещённых веществ в подпольных лабораториях\",\
	1,250000,0,0,0,1,\"Production 3.png\","",%d,1,0,0,0],\
	[5,\"Продажа наркотиков\",\"Возможность торговать нелегальными веществами среди игроков\",1,25000000,0,0,1,1,\"Drugs 1.png\","",%d,\
	1,0,0,0],[6,\"Продажа оружия\",\"Возможность вести торговлю оружием среди игроков\",\
	1,25000000,0,0,2,1,\"Weapons 1.png\","",%d,1,0,0,0],\
	[7,\"Контроль районов\",\"Доступ к захвату территорий и контролю бизнесов\",1,25000000,0,0,0,2,\"Business.png\","",%d,1,0,0,0],\
	[8,\"Увеличеннное действие масок\",\"Длительность действия маски увеличена до 20 минут\"\
	,1,25000000,0,0,1,2,\"Masks.png\","",%d,1,0,0,0],\
	[9,\"Связывание\",\"Возможность связывать игроков с помощью команды /tie\",1,15000000,0,0,2,2,\"Binding.png\","",%d,1,0,0,0],\
	[10,\"Ограбление игроков\",\"Возможность грабить игроков на улице<br/><br/>Уровни улучшения:<n>- Уровень 1: от 1% до 4% \
	наличных<n>- Уровень 2: от 1% до 6% наличных<n>- Уровень 3: от 1% до 8% наличных<n>- Уровень 4: от 1% до 10% наличных\",\
	1,5000000,0,0,0,3,\"Heist 1-1.png\","",%d,4,0,0,0],\
	[11,\"Ограбление домов\",\"Возможность совершать налёты на дома из списка заказов\",1,6500000,1,0,1,3,\"Heist 2.png\","",%d,1,0,0,0],\
	[12,\"Ограбление инкассации\",\"Доступ к ограблению инкассаторов\",1,7500000,1,0,2,3,\"Heist 3.png\","",%d,1,0,0,0],\
	[13,\"Ограбление бизнесов\",\"Возможность устраивать налёты на бизнесы, находящиеся под контролем других семей\",\
	1,8500000,1,0,3,3,\"Heist 4.png\","",%d,1,0,0,0],\
	[14,\"Подпольное производство продуктов\",\"Доступ к подпольному производству продовольственных товаров\",1,2500000,0,0,0,4,\
	\"Production 1.png\","",%d,1,0,0,0],\
	[15,\"Подполье производство оружия\",\"Доступ к подпольным мастерским по изготовлению оружия\",1,2500000,1,0,1,4,\
	\"Production 2.png\","",%d,1,0,0,0],\
	[16,\"Уведомление поставок\",\"Информация о передвижении конвоев с боеприпасами\",1,5000000,0,0,0,5,\
	\"Notification.png\","",%d,1,0,0,0],\
	[17,\"Освобождение заключенного\",\"Возможность освободить заключённого участника семьи из тюрьмы\",1,7500000,1,0,1,5,\
	\"Prisoners.png\","",%d,1,0,0,0],\
	[18,\"Вызов подмоги\",\"Вызов помощи с помощью команды /bk или радиального меню\",1,7500000,1,0,2,5,\"Help.png\","",%d,1,0,0,0],\
	[19,\"Голосовая рация\",\"Возможность использовать голосовую связь между членами семьи\",\
	1,8000000,0,0,3,5,\"Radio.png\","",%d,1,0,1,0]])",

	GetFamilyData(GetPlayerFamily(playerid),CREATE_KEY),GetFamilyData(GetPlayerFamily(playerid),UGON_CAR),
	GetFamilyData(GetPlayerFamily(playerid),UGON_CAR_PREMIUM),GetFamilyData(GetPlayerFamily(playerid),X2_UGON_TIME),
	GetFamilyData(GetPlayerFamily(playerid),CREATE_NARK),GetFamilyData(GetPlayerFamily(playerid),TRADE_NARKOTA),
	GetFamilyData(GetPlayerFamily(playerid),TRADE_GUNS),GetFamilyData(GetPlayerFamily(playerid),CONTRAYBLE_RAYON),
	GetFamilyData(GetPlayerFamily(playerid),MARK_TIME),GetFamilyData(GetPlayerFamily(playerid),CUFF_PLAYER),
	GetFamilyData(GetPlayerFamily(playerid),PLAYER_OGR),GetFamilyData(GetPlayerFamily(playerid),HOME_OGR),
	GetFamilyData(GetPlayerFamily(playerid),INK_OGR),GetFamilyData(GetPlayerFamily(playerid),BUSINESS_OGR),
	GetFamilyData(GetPlayerFamily(playerid),CREATE_PROD),GetFamilyData(GetPlayerFamily(playerid),CREATE_GUN),
	GetFamilyData(GetPlayerFamily(playerid),SMS_POSTAVOK),GetFamilyData(GetPlayerFamily(playerid),UNN_CUFF),
	GetFamilyData(GetPlayerFamily(playerid),GET_HELP));

	SendClientEvent(playerid, t_CefUpdate,  STRING_GLOBAL);
}

public: FAMTBL_OnPlayerOpenTab(playerid,event,args)
{
	switch(event)
	{
		case 0:
		{
			OpenCefGang(playerid);
		}
		case 4:
        {
			SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().setLoading(0)");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[0,1,7,2945.56,-1822.80,\"\",-1,\"\",\"000000\",-1,\
			[15,17,20,24],[[8,1.00],[21,5.00]],0],\
			[1,2,3,-1775.81,-2805.94,\"\",-1,\"\",\"000000\",-1,[139,138],[[17,-10.00]],0],\
			[2,3,1,-1896.57,2898.59,\"\",-1,\"\",\"000000\",-1,[5,106,162,107,105],[[15,10.00]],0],\
			[3,4,6,3347.83,-236.83,\"\",-1,\"\",\"000000\",-1,[65,59,4],[[20,-1.00]],0],\
			[4,5,8,2748.05,634.06,\"\",-1,\"\",\"000000\",-1,[3,66,65,64,67,63],[[4,-50.00],\
			[22,-5.00]],0],[5,6,10,-426.34,3368.64,\"\",-1,\"\",\"000000\",-1,[98,97,2],\
			[[24,-5.00]],0],[6,7,13,1969.07,70.22,\"mrllwnsdev\",16,\"\",\"EC6AAE\",3449,[],\
			[],0],[7,8,14,-3220.40,882.62,\"mrllwnsdev\",21,\"\",\"6F8297\",3420,[],[],0],\
			[8,9,15,4119.39,3818.12,\"mrllwnsdev\",23,\"\",\"F5F5F5\",3468,[],[],0],\
			[9,10,16,2356.76,1554.29,\"mrllwnsdev\",1,\"\",\"4C75B7\",3047,[],[],0],\
			[10,11,17,-2185.42,-310.96,\"\",-1,\"\",\"000000\",-1,[123,124,135,143],\
			[],0],[11,12,17,1870.32,-1903.25,\"\",-1,\"\",\"000000\",-1,[58,13,12,145],\
			[],0],[12,13,11,2122.67,-1991.02,\"\",-1,\"\",\"000000\",-1,[18,21,13,58,16,14],\
			[[2,-5.00],[3,50.00],\
			[25,-90.00]],0],\
			[13,14,0,2082.45,-1738.64,\"mrllwnsdev\",12,\"146.png\",\"7E1A6C\",2082,[11,14,60,62,12],\
			[[7,-10.00]],1759779287],[14,15,0,2281.54,-1738.64,\"mrllwnsdev\",12,\"146.png\",\"7E1A6C\",2082,\
			[15,16,60,12,13],[[0,-5.00],[1,-10.00],[4,-50.00],[10,-5.00]],1759778087],\
			[15,16,0,2480.62,-1738.64,\"mrllwnsdev\",12,\"146.png\",\"7E1A6C\",2082,\
			[16,17,60,0,14],[],1759860885],[16,17,0,2381.08,-1904.39,\"mrllwnsdev\",12,\"146.png\",\"7E1A6C\",2082,\
			[14,12,17,18,19,15],[],1759862085],[17,18,0,2583.15,-1904.39,\"mrllwnsdev\",1,\"\",\"4C75B7\",3047,\
			[15,19,20,0,16],[],1759839286]])");

            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().setCaptureParams\
			('[\"Пистолеты\",\"Автоматы\",\"Дробовики\"]', 1760024084, 15, 5)");

            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints(\
			[[18,19,0,2281.54,-2067.13,\"mrllwnsdev\",6,\"\",\"252527\",909,[12,16,19,21,29],[[6,-10.00]],\
			1759848887],[19,20,0,2483.62,-2073.13,\"mrllwnsdev\",12,\"\",\"F5F5F5\",3087,[17,16,20,23,29,18],\
			[],1759866885],[20,21,0,2685.68,-2073.13,\"mrllwnsdev\",1,\"\",\"4C75B7\",3047,[17,23,24,0,19],\
			[],1759763686],[21,22,0,2179.00,-2235.88,\"mrllwnsdev\",6,\"\",\"252527\",909,[18,12,22,28,30,29],\
			[],1759841687],[22,23,0,2076.45,-2404.63,\"\",-1,\"\",\"000000\",-1,[30,32,34,35,21,28],[],0],\
			[23,24,0,2589.15,-2235.88,\"mrllwnsdev\",12,\"\",\"F5F5F5\",3087,[20,19,24,26,27,29],[],1759691687],\
			[24,25,0,2794.22,-2235.88,\"mrllwnsdev\",1,\"\",\"4C75B7\",3047,[20,25,26,0,23],[],1759678486],\
			[25,26,0,2896.77,-2404.63,\"\",-1,\"\",\"000000\",-1,[26,37,24],[],0],\
			[26,27,0,2691.68,-2404.63,\"mrllwnsdev\",8,\"\",\"252527\",3096,[24,23,27,36,37,25],\
			[[5,-99.00]],1759770335],[27,28,0,2486.62,-2404.63,\"mrllwnsdev\",8,\"\",\"252527\",3096,\
			[23,28,36,29,222,26],[[4,-50.00],[0,-5.00],[1,-10.00]],1759857913],\
			[28,29,0,2281.54,-2404.63,\"\",-1,\"\",\"000000\",-1,[22,21,35,29,222,27],\
			[],0],[29,30,5,2384.08,-2235.88,\"\",-1,\"\",\"000000\",-1,[19,18,27,23,21,28],\
			[[19,5.00]],0],[30,31,0,1973.92,-2235.88,\"\",-1,\"\",\"000000\",-1,\
			[22,21,12,31,32,58],[],0],[31,32,0,1768.83,-2235.88,\"\",-1,\"\",\"000000\",-1,[32,58,30,145],\
			[],0],[32,33,0,1871.38,-2404.63,\"\",-1,\"\",\"000000\",-1,[30,22,33,34,31],[],0],\
			[33,34,0,1768.83,-2573.38,\"\",-1,\"\",\"000000\",-1,[34,38,32],[],0],[34,35,0,1973.92,-2573.38,\
			\"\",-1,\"\",\"000000\",-1,[32,22,35,38,33],[],0],[35,36,0,2179.00,-2573.38,\"\",-1,\"\",\"000000\",\
			-1,[22,28,222,34],[],0]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[36,37,0,2589.15,-2573.38,\"\",-1,\"\",\"000000\",-1,[26,27,37,222],[],0],[37,38,0,2794.22,-2573.38,\"\",-1,\"\",\"000000\",-1,[25,26,36],[],0],[38,39,0,1871.38,-2742.13,\"\",-1,\"\",\"000000\",-1,[33,34,39],[],0],[39,40,0,1973.92,-2910.88,\"mrllwnsdev\",8,\"\",\"252527\",3096,[40,38],[[0,-5.00],[1,-10.00],[4,-50.00]],1759768486],[40,41,0,2076.45,-3079.63,\"\",-1,\"\",\"000000\",-1,[41,47,51,39],[],0],[41,42,0,2281.54,-3079.63,\"\",-1,\"\",\"000000\",-1,[42,46,47,40],[],0],[42,43,0,2486.62,-3079.63,\"\",-1,\"\",\"000000\",-1,[43,45,46,41],[],0],[43,44,0,2691.68,-3079.63,\"\",-1,\"\",\"000000\",-1,[44,45,42],[],0],[44,45,0,2794.22,-3248.38,\"\",-1,\"\",\"000000\",-1,[45,43],[],0],[45,46,0,2589.15,-3248.38,\"\",-1,\"\",\"000000\",-1,[42,43,46,48,44],[],0],[46,47,0,2384.08,-3248.38,\"\",-1,\"\",\"000000\",-1,[41,42,47,48,49,45],[],0],[47,48,0,2179.00,-3248.38,\"\",-1,\"\",\"000000\",-1,[40,41,49,50,51,46],[],0],[48,49,0,2486.62,-3417.13,\"\",-1,\"\",\"000000\",-1,[45,46,49],[],0],[49,50,0,2281.54,-3417.13,\"\",-1,\"\",\"000000\",-1,[46,47,50,48],[],0],[50,51,0,2076.45,-3417.13,\"\",-1,\"\",\"000000\",-1,[47,51,52,49],[],0],[51,52,0,1973.92,-3248.38,\"\",-1,\"\",\"000000\",-1,[40,47,52,50],[],0],[52,53,0,1871.38,-3417.13,\"\",-1,\"\",\"000000\",-1,[50,53,51],[],0],[53,54,0,1666.30,-3417.13,\"\",-1,\"\",\"000000\",-1,[54,52],[],0]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[54,55,0,1563.76,-3248.38,\"\",-1,\"\",\"000000\",-1,[55,56,57,53],[],0],[55,56,0,1461.22,-3079.63,\"\",-1,\"\",\"000000\",-1,[56,57,54],[],0],[56,57,0,1666.30,-3079.63,\"\",-1,\"\",\"000000\",-1,[54,55],[],0],[57,58,0,1358.68,-3248.38,\"\",-1,\"\",\"000000\",-1,[55,54],[],0],[58,59,0,1871.38,-2067.13,\"\",-1,\"\",\"000000\",-1,[11,30,31,12],[],0],[59,60,0,2594.45,-608.59,\"\",-1,\"\",\"000000\",-1,[60,61,65,3],[],0],[60,61,0,2491.91,-777.34,\"\",-1,\"\",\"000000\",-1,[61,13,15,14,59,62],[],0],[61,62,0,2389.38,-608.59,\"mrllwnsdev\",21,\"\",\"6F8297\",3420,[59,62,63,60],[],1759780487],[62,63,0,1939.81,-831.68,\"\",-1,\"\",\"000000\",-1,[146,63,13,61,60,204],[[4,-50.00],[0,-5.00],[1,-10.00]],0],[63,64,0,2285.00,-239.21,\"mrllwnsdev\",21,\"\",\"6F8297\",3420,[64,61,4,66],[],1759687539],[64,65,0,2490.08,-239.21,\"mrllwnsdev\",21,\"\",\"6F8297\",3420,[65,4,63],[[10,-5.00]],1759760714],[65,66,0,2695.15,-239.21,\"mrllwnsdev\",16,\"\",\"EC6AAE\",3449,[59,3,4,64],[],1759772087],[66,67,0,1661.86,664.09,\"\",-1,\"\",\"000000\",-1,[4,71,217,69,63],[[9,2.50]],0],[67,68,0,2144.62,1300.47,\"\",-1,\"\",\"000000\",-1,[68,69,4],[[11,5.00]],0],[68,69,0,2042.08,1469.22,\"\",-1,\"\",\"000000\",-1,[69,70,72,67],[],0],[69,70,0,1939.55,1300.47,\"\",-1,\"\",\"000000\",-1,[67,70,71,66,68],[],0],[70,71,0,1837.01,1469.22,\"\",-1,\"\",\"000000\",-1,[68,71,72,69],[],0],[71,72,0,1734.46,1300.47,\"\",-1,\"\",\"000000\",-1,[69,66,221,213,70],[],0]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[72,73,0,1939.55,1637.97,\"\",-1,\"\",\"000000\",-1,[68,70,73,74],[[0,-5.00],[1,-10.00],[4,-50.00]],0],[73,74,0,2042.08,1806.72,\"\",-1,\"\",\"000000\",-1,[74,75,76,72],[[6,-10.00]],0],[74,75,0,1837.01,1806.72,\"\",-1,\"\",\"000000\",-1,[72,75,73],[[8,1.00]],0],[75,76,0,1939.55,1975.47,\"\",-1,\"\",\"000000\",-1,[73,76,78,79,74],[[14,1.00]],0],[76,77,0,2144.62,1975.47,\"\",-1,\"\",\"000000\",-1,[73,77,79,75],[],0],[77,78,0,2349.69,1975.47,\"\",-1,\"\",\"000000\",-1,[76],[],0],[78,79,0,1837.01,2144.22,\"\",-1,\"\",\"000000\",-1,[75,79,81,82],[],0],[79,80,0,2042.08,2144.22,\"\",-1,\"\",\"000000\",-1,[76,75,80,82,78],[],0],[80,81,0,2144.62,2312.97,\"\",-1,\"\",\"000000\",-1,[82,83,79],[[5,-99.00]],0],[81,82,0,1734.46,2312.97,\"\",-1,\"\",\"000000\",-1,[78,82,84,85],[],0],[82,83,0,1939.55,2312.97,\"\",-1,\"\",\"000000\",-1,[78,79,80,83,84,81],[],0],[83,84,0,2042.08,2481.72,\"\",-1,\"\",\"000000\",-1,[80,84,82,89,96,87],[],0],[84,85,0,1837.01,2481.72,\"\",-1,\"\",\"000000\",-1,[82,81,85,86,83],[[7,-10.00]],0],[85,86,0,1631.93,2481.72,\"mrllwnsdev\",13,\"\",\"1B8A2F\",3642,[81,86,101,84,223],[],1759762486],[86,87,0,1734.46,2650.47,\"\",-1,\"\",\"000000\",-1,[84,87,85],[],0],[87,88,0,1888.01,2867.22,\"\",-1,\"\",\"000000\",-1,[86,96,89,83],[],0],[88,89,0,3911.06,3900.75,\"\",-1,\"\",\"000000\",-1,[89,90,91],[],0],[89,90,2,3705.97,3903.75,\"\",-1,\"\",\"000000\",-1,[90,96,88,83,87],[[16,2.50]],0]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[90,91,0,3808.52,4072.50,\"\",-1,\"\",\"000000\",-1,[88,91,92,95,96,89],[],0],[91,92,0,4013.60,4069.50,\"\",-1,\"\",\"000000\",-1,[88,92,90],[],0],[92,93,0,3911.06,4238.25,\"\",-1,\"\",\"000000\",-1,[90,93,94,95,91],[],0],[93,94,0,4013.60,4407.00,\"\",-1,\"\",\"000000\",-1,[94,92],[[4,-50.00],[0,-5.00],[1,-10.00]],0],[94,95,0,3808.52,4407.00,\"\",-1,\"\",\"000000\",-1,[92,95,93],[],0],[95,96,0,3705.97,4241.25,\"\",-1,\"\",\"000000\",-1,[90,92,96,94],[],0],[96,97,0,3603.44,4072.50,\"\",-1,\"\",\"000000\",-1,[89,90,95,87],[],0],[97,98,0,-78.66,2891.62,\"mrllwnsdev\",0,\"142.png\",\"2A77A1\",1153,[98,99,5,192],[],1759764886],[98,99,0,-283.74,2891.62,\"mrllwnsdev\",0,\"142.png\",\"2A77A1\",1153,[5,97,164],[],1759692887],[99,100,0,297.72,2715.93,\"mrllwnsdev\",0,\"142.png\",\"2A77A1\",1153,[100,97,192],[],1759840486],[100,101,0,502.80,2715.93,\"mrllwnsdev\",13,\"\",\"1B8A2F\",3642,[101,99],[],1759761286],[101,102,0,743.89,2551.47,\"mrllwnsdev\",13,\"\",\"1B8A2F\",3642,[85,193,100],[[0,-5.00],[1,-10.00],[4,-50.00]],1759682087],[102,103,0,-2639.01,2741.30,\"mrllwnsdev\",8,\"\",\"EC6AAE\",3112,[103,104,105],[],1759859685],[103,104,0,-2741.55,2910.05,\"mrllwnsdev\",8,\"\",\"EC6AAE\",3112,[104,102],[],1759858485],[104,105,0,-2536.46,2910.05,\"mrllwnsdev\",8,\"\",\"EC6AAE\",3112,[102,105,106,103],[[6,-10.00]],1759758886],[105,106,0,-2433.92,2741.30,\"mrllwnsdev\",14,\"\",\"2E2D33\",1431,[102,106,107,2,104],[],1759766086],[106,107,0,-2331.38,2910.05,\"mrllwnsdev\",14,\"\",\"2E2D33\",1431,[104,2,105],[],1759754085],[107,108,0,-2331.38,2572.55,\"mrllwnsdev\",14,\"\",\"2E2D33\",1431,[105,108,2],[],1759850087]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[108,109,0,-2397.92,2310.80,\"\",-1,\"\",\"000000\",-1,[109,110,107],[],0],[109,110,0,-2295.38,2142.05,\"\",-1,\"\",\"000000\",-1,[110,111,112,108,121],[],0],[110,111,0,-2500.46,2142.05,\"\",-1,\"\",\"000000\",-1,[108,111,113,109],[],0],[111,112,0,-2397.92,1973.30,\"\",-1,\"\",\"000000\",-1,[109,112,113,114,115,110],[],0],[112,113,0,-2192.85,1973.30,\"\",-1,\"\",\"000000\",-1,[109,114,121,111],[],0],[113,114,0,-2603.01,1973.30,\"\",-1,\"\",\"000000\",-1,[110,111,115,116],[[0,-5.00],[1,-10.00],[4,-50.00]],0],[114,115,0,-2295.38,1804.55,\"\",-1,\"\",\"000000\",-1,[111,112,115,118,121],[],0],[115,116,0,-2500.46,1804.55,\"\",-1,\"\",\"000000\",-1,[111,113,116,117,118,114],[],0],[116,117,0,-2705.55,1804.55,\"\",-1,\"\",\"000000\",-1,[113,117,115],[],0],[117,118,0,-2603.01,1635.80,\"\",-1,\"\",\"000000\",-1,[115,118,119,120,116],[],0],[118,119,0,-2397.92,1635.80,\"\",-1,\"\",\"000000\",-1,[115,114,119,117],[],0],[119,120,0,-2500.46,1467.05,\"\",-1,\"\",\"000000\",-1,[117,120,122,118],[],0],[120,121,0,-2705.55,1467.05,\"\",-1,\"\",\"000000\",-1,[117,122,119],[],0],[121,122,0,-1878.31,1907.56,\"\",-1,\"\",\"000000\",-1,[112,162,179,114,109],[[5,-99.00]],0],[122,123,0,-2518.33,1124.93,\"\",-1,\"\",\"000000\",-1,[133,119,120,128,179],[[2,-5.00],[3,50.00]],0],[123,124,0,-2181.87,-140.36,\"\",-1,\"\",\"000000\",-1,[10,124,130,131],[[6,-10.00]],0],[124,125,0,-2386.94,-140.36,\"\",-1,\"\",\"000000\",-1,[10,125,127,130,123],[],0],[125,126,0,-2489.48,28.38,\"\",-1,\"\",\"000000\",-1,[126,127,128,129,130,124],[],0]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[126,127,0,-2694.57,28.38,\"\",-1,\"\",\"000000\",-1,[127,128,125],[],0],[127,128,0,-2592.03,-140.36,\"\",-1,\"\",\"000000\",-1,[125,124,135,126],[[0,-5.00],[1,-10.00],[4,-50.00]],0],[128,129,0,-2592.03,197.13,\"\",-1,\"\",\"000000\",-1,[125,126,129,122],[],0],[129,130,0,-2386.94,197.13,\"\",-1,\"\",\"000000\",-1,[125,130,132,133,128],[],0],[130,131,0,-2284.40,28.38,\"\",-1,\"\",\"000000\",-1,[123,124,125,131,132,129],[],0],[131,132,0,-2079.33,28.38,\"\",-1,\"\",\"000000\",-1,[123,132,130,175],[],0],[132,133,0,-2181.87,197.13,\"\",-1,\"\",\"000000\",-1,[130,129,133,131],[],0],[133,134,0,-2284.40,365.88,\"\",-1,\"\",\"000000\",-1,[129,122,132,179],[],0],[134,135,0,-2723.12,-1420.54,\"\",-1,\"\",\"000000\",-1,[135,136],[],0],[135,136,0,-2825.65,-1251.79,\"\",-1,\"\",\"000000\",-1,[10,134,127],[],0],[136,137,0,-2287.92,-1614.34,\"\",-1,\"\",\"000000\",-1,[137,134,143],[[14,1.00]],0],[137,138,0,-2185.38,-1783.09,\"\",-1,\"\",\"000000\",-1,[138,136],[],0],[138,139,0,-2082.85,-1951.84,\"\",-1,\"\",\"000000\",-1,[142,1,137],[[0,-5.00],[1,-10.00]],0],[139,140,0,-1285.77,-2297.66,\"\",-1,\"\",\"000000\",-1,[140,1],[],0],[140,141,0,-1183.22,-2128.91,\"\",-1,\"\",\"000000\",-1,[141,142,139],[],0],[141,142,0,-1080.68,-1960.17,\"\",-1,\"\",\"000000\",-1,[142,149,156,140],[],0],[142,143,0,-1285.77,-1960.17,\"\",-1,\"\",\"000000\",-1,[140,138,149,141],[],0],[143,144,0,-1113.94,-857.36,\"\",-1,\"\",\"000000\",-1,[151,150,10,175,166,136],[[9,2.50]],0]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[144,145,0,484.23,-2411.52,\"\",-1,\"\",\"000000\",-1,[145,158,160],[],0],[145,146,0,1032.82,-1939.75,\"\",-1,\"\",\"000000\",-1,[146,147,11,144,31],[],0],[146,147,0,838.99,-1350.98,\"\",-1,\"\",\"000000\",-1,[147,62,145],[],0],[147,148,0,633.91,-1350.98,\"\",-1,\"\",\"000000\",-1,[148,161,145,146,160],[],0],[148,149,0,531.38,-1182.23,\"\",-1,\"\",\"000000\",-1,[161,147,166,168,204],[],0],[149,150,0,-828.69,-1599.70,\"\",-1,\"\",\"000000\",-1,[150,154,141,142,156],[],0],[150,151,0,-726.15,-1430.95,\"\",-1,\"\",\"000000\",-1,[151,153,154,143,149],[],0],[151,152,0,-623.61,-1262.20,\"\",-1,\"\",\"000000\",-1,[152,153,143,150],[],0],[152,153,0,-418.53,-1262.20,\"\",-1,\"\",\"000000\",-1,[153,159,161,151],[[0,-5.00],[1,-10.00]],0],[153,154,0,-521.07,-1430.95,\"\",-1,\"\",\"000000\",-1,[151,150,154,155,159,152],[[10,-5.00],[6,-10.00]],0],[154,155,0,-623.61,-1599.70,\"\",-1,\"\",\"000000\",-1,[150,149,155,156,157,153],[],0],[155,156,2,-418.53,-1599.70,\"\",-1,\"\",\"000000\",-1,[153,157,158,159,160,154],[[11,5.00],[16,2.50]],0],[156,157,0,-726.15,-1768.45,\"\",-1,\"\",\"000000\",-1,[149,154,157,141],[],0],[157,158,0,-521.07,-1768.45,\"\",-1,\"\",\"000000\",-1,[154,155,158,156],[[0,-5.00],[1,-10.00],[4,-50.00]],0],[158,159,0,-315.99,-1768.45,\"\",-1,\"\",\"000000\",-1,[155,160,144,157],[],0],[159,160,0,-315.99,-1430.95,\"\",-1,\"\",\"000000\",-1,[152,155,153,160,161],[],0],[160,161,0,-213.45,-1599.70,\"\",-1,\"\",\"000000\",-1,[158,155,144,159,147],[],0],[161,162,0,-213.45,-1262.20,\"\",-1,\"\",\"000000\",-1,[159,152,148,166,168],[],0]])");
            SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().page().addPoints([[162,163,9,-1102.97,2236.70,\"\",-1,\"\",\"000000\",-1,[165,2,121],[[4,-50.00],[23,-5.00]],0],[163,164,0,-799.43,1907.55,\"\",-1,\"\",\"000000\",-1,[164,165,190,179,184],[],0],[164,165,0,-696.89,2076.30,\"\",-1,\"\",\"000000\",-1,[165,190,98,163,192],[],0],[165,166,0,-901.97,2076.30,\"\",-1,\"\",\"000000\",-1,[162,163,164],[],0],[166,167,0,-13.13,239.89,\"\",-1,\"\",\"000000\",-1,[168,169,170,143,161,148],[],0],[167,168,12,89.40,746.14,\"\",-1,\"\",\"000000\",-1,[172,173,182,186,200,201],[[6,-10.00]],0],[168,169,0,191.94,239.89,\"\",-1,\"\",\"000000\",-1,[166,169,171,148,161],[[12,-20.00],[13,-10.00]],0],[169,170,0,89.40,408.64,\"\",-1,\"\",\"000000\",-1,[166,170,171,172,173,168],[],0],[170,171,0,-115.67,408.64,\"\",-1,\"\",\"000000\",-1,[166,172,174,176,169],[],0],[171,172,0,294.48,408.64,\"\",-1,\"\",\"000000\",-1,[168,169,173,202,203],[],0],[172,173,0,-13.13,577.39,\"\",-1,\"\",\"000000\",-1,[170,169,167,173,176,182],[],0],[173,174,0,191.94,577.39,\"mrllwnsdev\",18,\"\",\"F5F5F5\",3694,[171,167,169,201,202,172],[],1759683287],[174,175,0,-320.75,408.64,\"mrllwnsdev\",13,\"\",\"1B8A2F\",3642,[170,175,176,177],[[2,-5.00],[3,50.00]],1759689287],[175,176,0,-525.82,408.64,\"\",-1,\"\",\"000000\",-1,[177,174,131,143],[],0],[176,177,0,-218.21,577.39,\"\",-1,\"\",\"000000\",-1,[174,170,172,177,181,182],[],0],[177,178,0,-423.28,577.39,\"\",-1,\"\",\"000000\",-1,[175,174,178,181],[],0],[178,179,0,-525.82,746.14,\"\",-1,\"\",\"000000\",-1,[179,180,181,177],[],0],[179,180,0,-628.36,914.89,\"\",-1,\"\",\"000000\",-1,[180,178,133,122,163,121],[],0]])");
        }
		case 1:
		{
			new model_id;
			new query[128];
			new Cache: result, rows;
			new Cache: resultsss, rowssss;

			new fmt_text[128];
			new name[21];
			mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM PlayersMorallwens\
			WHERE family='%d'", GetPlayerData(playerid, P_FAMILY));
			resultsss = mysql_query(mysql, fmt_text);
			rowssss = cache_num_rows();
			string_dialog[0] = EOS;
			new number_phone;
			for(new b; b < rowssss; b ++)
			{
				if(cache_get_field_content_int(b, "family_rank") == 10)
				{
					number_phone = cache_get_field_content_int(b, "phone");
					cache_get_field_content(b, "name", name);
				}
			}
			cache_delete(resultsss);
			mysql_format(mysql, query, sizeof query, "SELECT * FROM family_cars WHERE owner_id='%d'", GetPlayerData(playerid, P_FAMILY));
			result = mysql_query(mysql, query);
			rows = cache_num_rows();
			for(new i = 0; i < rows; i++)
			{
				model_id = cache_get_field_content_int(i, "model_id");
				format(query, sizeof query, "[0,%d,\"%s\",\"%s\",%d,8,1000],",
				GetVehicleInfo(model_id, VI_TYPE),GetVehicleInfo(model_id, VI_NAME),name,number_phone);
				strcat(string_dialog, query);
			}
			strdel(string_dialog, strlen(string_dialog) - 1, strlen(string_dialog));
			cache_delete(result);

			SendClientEventF(playerid, s_CefInterface, t_CefUpdate,"interface('Phone').getCurrentApp().setTransport([%s])",string_dialog);
		}
		case 5:
		{
			SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().setLoading(0)");

			SendClientEvent(playerid, t_CefUpdate,"interface('Phone').getCurrentApp().setUpgrades([5,3,2,[3,5],[],[],\
			[[\"Самый высокий онлайн\",10,0,1],[\"Сбор овощей\",10,0,500000],[\"Сбор шкур животных\",10,75000,500000],[\"Сбор уток\",10,34000,100000],\
			[\"Сбор рыбы\",10,0,500000],[\"Сбор антиквариата\",10,154468,500000],[\"Участие в КТО\",7,0,1],[\"Удачная защита штурма\",20,0,1],\
			[\"Участие в сражении за эйрдроп\",7,0,1],[\"Угон транспорта\",5,0,1],[\"Продажа наркотиков\",1,0,1],[\"Продажа оружия\",1,0,1],\
			[\"Участие в захвате территории\",7,0,1],[\"Победа в захвате территории\",15,0,1],[\"Захват особняка\",50,0,1],\
			[\"Кража ящика с материалами\",5,0,1],[\"Ограбление бизнеса\",5,0,1],[\"Ограбление игрока\",1,0,1],[\"Ограбление дома\",4,0,1]]])");

			LoadPhoneGangBuyImrovents(playerid);

		}
		case 6:
		{
			string_dialog[0] = EOS;
			new query[144], Cache: result, rows;
			new name[21],skin_id,number_phone,family_rank,family_rout,tatu,time;

			mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE family='%d'", GetPlayerData(playerid, P_FAMILY));
			result = mysql_query(mysql, query);
			rows = cache_num_rows();

			for(new i = 0; i < rows; i++)
			{
				cache_get_field_content(i, "name", name);
				skin_id = cache_get_field_content_int(i, "skin");
				number_phone = cache_get_field_content_int(i, "phone");
				family_rank = cache_get_field_content_int(i, "family_rank");
				family_rout = cache_get_field_content_int(i, "family_rout");
				tatu = cache_get_field_content_int(i, "nakolka");
				time = cache_get_field_content_int(i, "game_for_day");
				format(query, sizeof query, "[%d,\"%s\",%d,25,\"%s\",%d,\"%s\",\"05.01.2025 16:16:44\",8,%d,%d,%d,%d],",number_phone, name,IsPlayerConnected(GetPlayerID(name)),nakolka_name[tatu],number_phone, name,skin_id,ConvertUnixTime(time, CONVERT_TIME_TO_MINUTES),RangConvert(family_rank),family_rout);
				strcat(string_dialog, query);
			}
			cache_delete(result);
			strdel(string_dialog, strlen(string_dialog) - 1, strlen(string_dialog));
			print(string_dialog);

			SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().setMembers([[1,1,0],[%s]])",string_dialog);
		}
		case 9:
		{
			SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().setLoading(0)");
			SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().setEditFamilyAvatarParams([[\"000000\",\"F5F5F5\",\"2A77A1\",\"840410\",\"263739\",\"86446E\",\"D78E10\",\"4C75B7\",\"BDBEC6\",\"5E7072\",\"46597A\",\"656A79\",\"5D7E8D\",\"58595A\",\"D6DAD6\",\"9CA1A3\",\"335F3F\",\"730E1A\",\"7B0A2A\",\"9F9D94\",\"3B4E78\",\"732E3E\",\"691E3B\",\"96918C\",\"515459\",\"3F3E45\",\"A5A9A7\",\"635C5A\",\"3D4A68\",\"979592\",\"421F21\",\"5F272B\",\"8494AB\",\"767B7C\",\"646464\",\"5A5752\",\"252527\",\"2D3A35\",\"93A396\",\"6D7A88\",\"221918\",\"6F675F\",\"7C1C2A\",\"5F0A15\",\"193826\",\"5D1B20\",\"9D9872\",\"7A7560\",\"989586\",\"ADB0B0\",\"848988\",\"304F45\",\"4D6268\",\"162248\",\"272F4B\",\"7D6256\",\"9EA4AB\",\"9C8D71\",\"6D1822\",\"4E6881\",\"9C9C98\",\"917347\",\"661C26\",\"949D9F\",\"A4A7A5\",\"8E8C46\",\"341A1E\",\"6A7A8C\",\"AAAD8E\",\"AB988F\",\"851F2E\",\"6F8297\",\"585853\",\"9AA790\",\"601A23\",\"20202C\",\"A4A096\",\"AA9D84\",\"78222B\",\"0E316D\",\"722A3F\",\"7B715E\",\"741D28\",\"1E2E32\",\"4D322F\",\"7C1B44\",\"2E5B20\",\"395A83\",\"6D2837\",\"A7A28F\",\"AFB1B1\",\"364155\",\"6D6C6E\",\"0F6A89\",\"204B6B\",\"2B3E57\",\"9B9F9D\",\"6C8495\",\"4D8495\",\"AE9B7F\",\"406C8F\",\"1F253B\",\"AB9276\",\"134573\",\"96816C\",\"64686A\",\"105082\",\"A19983\",\"385694\",\"525661\",\"7F6956\",\"8C929A\",\"596E87\",\"473532\",\"44624F\",\"730A27\",\"223457\",\"640D1B\",\"A3ADC6\",\"695853\",\"9B8B80\",\"620B1C\",\"5B5D5E\",\"624428\",\"731827\",\"1B376D\",\"EC6AAE\",\"000000\",\"177517\",\"210606\",\"125478\",\"452A0D\",\"571E1E\",\"010701\",\"25225A\",\"2C89AA\",\"8A4DBD\",\"35963A\",\"B7B7B7\",\"464C8D\",\"84888C\",\"817867\",\"817A26\",\"6A506F\",\"583E6F\",\"8CB972\",\"824F78\",\"6D276A\",\"1E1D13\",\"1E1306\",\"1F2518\",\"2C4531\",\"1E4C99\",\"2E5F43\",\"1E9948\",\"1E9999\",\"999976\",\"7C8499\",\"992E1E\",\"2C1E08\",\"142407\",\"993E4D\",\"1E4C99\",\"198181\",\"1A292A\",\"16616F\",\"1B6687\",\"6C3F99\",\"481A0E\",\"7A7399\",\"746D99\",\"53387E\",\"222407\",\"3E190C\",\"46210E\",\"991E1E\",\"8D4C8D\",\"805B80\",\"7B3E7E\",\"3C1737\",\"733517\",\"781818\",\"83341A\",\"8E2F1C\",\"7E3E53\",\"7C6D7C\",\"020C02\",\"072407\",\"163012\",\"16301B\",\"642B4F\",\"368452\",\"999590\",\"818D96\",\"99991E\",\"7F994C\",\"839292\",\"788222\",\"2B3C99\",\"3A3A0B\",\"8A794E\",\"0E1F49\",\"15371C\",\"15273A\",\"375775\",\"060820\",\"071326\",\"20394B\",\"2C5089\",\"15426C\",\"103250\",\"241663\",\"692015\",\"8C8D94\",\"516013\",\"090F02\",\"8C573A\",\"52888E\",\"995C52\",\"92581E\",\"993A63\",\"998F4E\",\"99311E\",\"0D1842\",\"521E1E\",\"42420D\",\"4C991E\",\"082A1D\",\"96821D\",\"197F19\",\"3B141F\",\"745217\",\"893F8D\",\"7E1A6C\",\"0B370B\",\"27450D\",\"071F24\",\"784573\",\"8A653A\",\"732617\",\"319490\",\"56941D\",\"59163D\",\"1B8A2F\",\"38160B\",\"041804\",\"355D8E\",\"2E3F5B\",\"561A28\",\"4E0E27\",\"706C67\",\"3B3E42\",\"2E2D33\",\"7B7E7D\",\"4A4442\",\"28344E\"],399,\"https://radmir.online/avatar-upload?org_id=4458&org_name=%c4%c0%c3%c5%d1%d2%c0%cd%d1%ca%c0%df+%cc%c0%d4%c8%df&username=Danya_Sorlik&account_id=972168&t=1760038120&server=10&sign=a8881b369b182d374cd0a30536ddb17a&cost=399\"])");
		}
		case 7:
		{
			new Cache: result, rows,name[64],query[128],id_fam_table;
			string_dialog[0] = EOS;
			new criminal_infl;
			result = mysql_query(mysql, "SELECT * FROM family WHERE gang='1'");
			rows = cache_num_rows();

			for(new i;i < rows;i++)
			{
				criminal_infl = cache_get_field_content_int(i, "criminal_influence");
				cache_get_field_content(i, "name", name);
				format(query, sizeof query, "[%d,\"%s\",%d,0,0],",i,name,criminal_infl);
				strcat(string_dialog, query);
				if(!strcmp(GetFamilyData(GetPlayerFamily(playerid), F_NAME), name, true))
					id_fam_table = i;
			}
			cache_delete(result);
			strdel(string_dialog, strlen(string_dialog) - 1, strlen(string_dialog));
			//SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().parseLeaderboardItem('[]')");
			SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().setLoading(0)");
			SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().setLeaderboardCurrentFamilyItem('[%d,\"%s\",%d,0,0]')",id_fam_table,GetFamilyData(GetPlayerFamily(playerid), F_NAME),GetFamilyData(GetPlayerFamily(playerid), F_CRIMINAL_INFLUENCE));
			SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').getCurrentApp().addLeaderboardItems('[[%s], 0]', 0)",string_dialog);
		}
		case 8:
		{
			SendClientEventF(playerid, s_CefInterface, t_CefUpdate,"interface('Phone').getCurrentApp().setCreateFamilyParams([[\
			\"000000\",\"F5F5F5\",\"2A77A1\",\"706C67\",\"3B3E42\",\"2E2D33\",\
			\"7B7E7D\",\"4A4442\",\"28344E\"],10,50000000,399,600,1,1,1])");
		}
	}
}

enum GANG_IMROVEMENTS_DATA_STRUCT
{
	NAME[64],
	PRICE,
	E_FAMILY_STRUCT:const_name
}
new const gang_improvements_data[][GANG_IMROVEMENTS_DATA_STRUCT] = {
	{"Создание отмычек",5000000,CREATE_KEY},
	{"Угон автомобилей",500000,UGON_CAR},
	{"Возможность угонять премиум класс",500000,UGON_CAR_PREMIUM},
	{"Двойное уменьшение задержки на угон",1000000,X2_UGON_TIME},
	{"Подпольное производство наркотиков",250000,CREATE_NARK},
	{"Продажа наркотиков",25000000,TRADE_NARKOTA},
	{"Продажа оружия",25000000,TRADE_GUNS},
	{"Контроль районов",25000000,CONTRAYBLE_RAYON},
	{"Увеличеннное действие масок",25000000,MARK_TIME},
	{"Связывание",15000000,CUFF_PLAYER},
	{"Ограбление игроков",5000000,PLAYER_OGR},
	{"Ограбление домов",6500000,HOME_OGR},
	{"Ограбление инкассации",7500000,INK_OGR},
	{"Ограбление бизнесов",8500000,BUSINESS_OGR},
	{"Подпольное производство продуктов",2500000,CREATE_PROD},
	{"Подполье производство оружия",2500000,CREATE_GUN},
	{"Уведомление поставок",5000000,SMS_POSTAVOK},
	{"Освобождение заключенного",7500000,UNN_CUFF},
	{"Вызов подмоги",7500000,GET_HELP}
};
public: FAMTBL_OnUpgradeBuy(playerid, event, type)
{
	if(GetPlayerMoneyEx(playerid) > gang_improvements_data[event][PRICE]) return GameText(playerid, "~r~Недостаточно средств", 3000, 2);
	GivePlayerMoneyEx(playerid, -gang_improvements_data[event][PRICE], "Покупка улучшения", true, true);
	new family_id = GetPlayerFamily(playerid);

	SetFamilyData(family_id, gang_improvements_data[event][const_name], 1);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SCMF(i,0x6495EDFF,"%s[%d] успешно купил улучшения для семьи - {9BF73A}'%s'",GetPlayerNameEx(playerid),playerid,gang_improvements_data[event][NAME]);
	}
	LoadPhoneGangBuyImrovents(playerid);
	return 1;
}
public: FAMTBL_OnVehicleSpawn(playerid)
{
	ViewFamilyCar(playerid);
}

public: FAMTBL_OnCreateFamily(playerid, color[], logo, name[])
{
	static str_global_text[2640];
	SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().setLoading(0)");
	SendClientEvent(playerid, t_CefUpdate, "interface('Phone').getCurrentApp().setDisplayParams(0)");
	mysql_format(mysql, str_global_text, sizeof str_global_text, "SELECT * FROM family WHERE name='%s'", name);
	new Cache:result = mysql_query(mysql, str_global_text, true);
	new rows = cache_num_rows();
	cache_delete(result);
	if(rows)
	{
		SendClientMessage(playerid, 0xCECECEFF, "Данное имя уже используется");
		return 1;
	}
	GivePlayerMoneyEx(playerid, -50000000, "Создание семьи",true,true);
	SendClientMessage(playerid, 0x66CC00FF, "Вы успешно создали семью! {"#cGold"}Используйте /gang_spawn для выбора базы.");

	new time = gettime();
	new query[144];
	mysql_format
	(
		mysql, query, sizeof query,
	    "INSERT INTO family "\
	    "(name,u_id,time) "\
	    "VALUES "\
	    "('%e',%d,%d)",
	    name,
	    GetPlayerAccountID(playerid),
	    time
	);
	result = mysql_query(mysql, query);

	new fam_id = cache_insert_id();

	SetPlayerData(playerid, P_FAMILY, fam_id);
	SetPlayerData(playerid, P_FAMILY_RANK, 10);
	//if(GetPlayerData(playerid, P_FAMILY)
	format(query, sizeof query, "t_CefUpdate PlayersMorallwens SET family=%d, family_rank=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_FAMILY), GetPlayerData(playerid, P_FAMILY_RANK), GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);

	SetFamilyData(fam_id, F_SQL_ID, fam_id);
	format(g_family[fam_id][F_NAME], 64, "%s", name);
	new text_str[144];
	format(text_str, 144, "{FFB500}%s", name);
	g_player[playerid][P_FAM_LABEL] = CreateDynamic3DTextLabel(text_str, -1, 0.0, 0.0, 0.6, 14.0, playerid, INVALID_VEHICLE_ID, 1);

	new
		hour, minute,second,
		day, month, year;

	gettime(hour, minute,second);
	getdate(year, month, day);

	SetFamilyData(fam_id, F_TIME_DAY, day);
	SetFamilyData(fam_id, F_TIME_MOUNTH, month);
	SetFamilyData(fam_id, F_TIME_YEAR, year);
	format(g_family[fam_id][F_COLOR], 32, "%s",color);
    SetFamilyData(fam_id, F_GANG, 1);
    SetFamilyData(fam_id, F_FAMILY_CARS, 10);
	SetFamilyData(fam_id, F_TIME_HOUR, hour);
	SetFamilyData(fam_id, F_TIME_MINUTE, minute);
	SetFamilyData(fam_id, F_TIME_SECOND, second);
	SetFamilyData(fam_id, F_LOGO_TYPE, logo);
	format(g_family[fam_id][F_COLOR_GANG], 32, "%s", color);

	format(query, sizeof query, "t_CefUpdate family SET day=%d, mounth=%d,year=%d,hour=%d,minute=%d,second=%d,gang=1 WHERE id=%d LIMIT 1", day,month,year,hour,minute,second, g_family[fam_id][F_SQL_ID]);
	mysql_query(mysql, query, false);

	SetFamilyData(fam_id, F_HOUSE_ID, -1);
	SetFamilyData(fam_id, F_USER_ID, GetPlayerAccountID(playerid));
	format(g_family[fam_id][F_RANK1], 32, "Терпила");
	format(g_family[fam_id][F_RANK2], 32, "Шнырь");
	format(g_family[fam_id][F_RANK3], 32, "Босяк");
	format(g_family[fam_id][F_RANK4], 32, "Барыга");
	format(g_family[fam_id][F_RANK5], 32, "Вор");
	format(g_family[fam_id][F_RANK6], 32, "Блатной");
	format(g_family[fam_id][F_RANK7], 32, "Пахан");
	format(g_family[fam_id][F_RANK8], 32, "Командир");
	format(g_family[fam_id][F_RANK9], 32, "Заместитель");
	format(g_family[fam_id][F_RANK10], 32, "Создатель");
	mysql_format(mysql, query, sizeof query, "t_CefUpdate family SET rank1='%e', rank2='%e' WHERE id=%d LIMIT 1",
	GetFamilyData(fam_id, F_RANK1),GetFamilyData(fam_id, F_RANK2), g_family[fam_id][F_SQL_ID]);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query, "t_CefUpdate family SET rank3='%e', rank4='%e' WHERE id=%d LIMIT 1",
	GetFamilyData(fam_id, F_RANK3),GetFamilyData(fam_id, F_RANK4), g_family[fam_id][F_SQL_ID]);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query, "t_CefUpdate family SET rank5='%e', rank6='%e' WHERE id=%d LIMIT 1",
	GetFamilyData(fam_id, F_RANK5),GetFamilyData(fam_id, F_RANK6), g_family[fam_id][F_SQL_ID]);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query, "t_CefUpdate family SET rank7='%e',rank8='%e' WHERE id=%d LIMIT 1",
	GetFamilyData(fam_id, F_RANK7),GetFamilyData(fam_id, F_RANK8), g_family[fam_id][F_SQL_ID]);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query, "t_CefUpdate family SET rank9='%e', rank10='%e' WHERE id=%d LIMIT 1",
	GetFamilyData(fam_id, F_RANK9),GetFamilyData(fam_id, F_RANK10), g_family[fam_id][F_SQL_ID]);
	mysql_query(mysql, query, false);
	g_family_loaded ++;
	cache_delete(result);
	OpenCefGang(playerid);
	return 1;
}
