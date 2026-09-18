/*1) CreateDynamic3DTextLabel("Нажмите на {8B0000}гудок\n{FFFFFF}Что бы выехать", 0xFFFF00FF, -0.2940,2006.1187,1554.2031, 12.0);
2) CreateDynamic3DTextLabel("{FFFF00}Гараж № \n{FFFFFF}Владелец: {8B0000}\n{B22222}Гараж закрыт", 0xFFFF00FF, -0.2940,2006.1187,1554.2031, 12.0);
3) CreateDynamic3DTextLabel("{FFFF00}Гараж № \n{FFFFFF}Владелец: {8B0000}\n{00FF00}Гараж открыт", 0xFFFF00FF, -0.2940,2006.1187,1554.2031, 12.0);
4) CreateDynamic3DTextLabel("{FFFF00}Гараж № \n{FFFFFF}Гараж продается", 0xFFFF00FF, -0.2940,2006.1187,1554.2031, 12.0);
4) CreateDynamic3DTextLabel("{FFFF00}Шкаф № \nПатрон: /2000\n{FFFFFF} Оружие: \n{FFFF00} Что бы открыть шкаф подойдите к нему", 0xFFFF00FF, -0.2940,2006.1187,1554.2031, 12.0);

    
5) SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Поздравляем с покупкой. Используйте /garage для взаимодействия");
6) SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Теперь Вам нужно поехать в банк и оплатить проживание в гараже, в ином случае Вас автоматически выселят");
7) ShowNotification(playerid, 0, 5, "Вы потратили 500000 рублей");

8) ShowPlayerDialog(playerid, GarageOSN, DIALOG_STYLE_LIST,
   "{8B0000}Панель",
   "1.Открыть/Закрыть гараж\n2.Продать гараж\n3.Улучшения\n4.Доставить транспорт в гараж\n5.Отметить гараж на GPS\n6.Продать гараж другому игроку",
   "Выбрать", "Закрыть");
   
9) ShowPlayerDialog(playerid, GarageAPP, DIALOG_STYLE_LIST,
   "{8B0000}Улучшения",
   "1.Возможность проживания в гараже 30000 руб. \n2.Сейф в гараже 40000 руб.\n3.Улучшение до элитного 5000000 руб.",
   "Далее", "Выйти");
   
10) ShowNotification(playerid, 0, 5, "Вы потратили 30000 рублей");
11) ShowNotification(playerid, 0, 5, "Вы потратили 40000 рублей");
12) ShowNotification(playerid, 0, 5, "Вы потратили 5000000 рублей");

13) ShowPlayerDialog(playerid, 1488, DIALOG_STYLE_LIST, "{8B0000}Шкаф",
    "1.Положить оружие\n2.Взять оружие\n3.Положить патроны\n4.Взять патроны",
    "Выбрать", "Закрыть");
    
14) ShowPlayerDialog(playerid, GarageInf, DIALOG_STYLE_MSGBOX, "{8B0000}Информация о гараже",
    "Номер гаража: \nСостояния: \nОплачен на: \nСтоимость: 500000 руб.{00FF00}Для открытия панели управления вашим гаражом\nнажмите кнопку 'Изменить' ",
    "Изменить", "Закрыть");
    
    ShowPlayerDialog(playerid, GarageBuy, DIALOG_STYLE_MSGBOX, "{8B0000}Покупка гаража",
	"Номер гаража: \nСтоимость: 500000 рублей ",
	"Купить", "Закрыть");
*/




	
    //    public OnPickUpPickup(playerid, pickupid) {
case PICKUP_ACTION_TYPE_GARAGE:
{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: %d\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);

	return 1;
}
case PICKUP_ACTION_TYPE_GARAGE_VLAD:
{
    SetPlayerPos(playerid, 1.716,1999.725,1554.203);
	SetPlayerInterior(playerid, 1);
    return 1;
}








//public OnDialogResponse(playerid, dialogid, response) {

	if (dialogid == DIALOG_MENU_GARAGE_VLAD) {
	    Dialog
		(
			playerid, DIALOG_MENU_GARAGE, DIALOG_STYLE_LIST,
			"{8B0000}Панель",
			"1.Открыть/Закрыть гараж\n"\
			"2.Продать гараж\n"\
			"3.Улучшения\n"\
			"4.Доставить транспорт в гараж\n"\
			"5.Отметить гараж на GPS\n"\
			"6.Продать гараж другому игроку",
			"Выбрать", "Закрыть"
		);
	}

    if (dialogid == DIALOG_GARAGE_BUY) {
        if (response == 1) {
            if (GetPlayerMoney(playerid) >= GARAGE_PRICE) {
                GivePlayerMoney(playerid, -GARAGE_PRICE);

                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Поздравляем с покупкой. Используйте /garage для взаимодействия");
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Теперь Вам нужно поехать в банк и оплатить проживание в гараже, в ином случае Вас автоматически выселят");

                //DestroyPickup(pickupBuy[i]);
                //DestroyDynamic3DTextLabel(garageLabel);

                new Float:playerPos[3];
                GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

                new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				CreatePickup(1318, 23, x, y, z, 0, PICKUP_ACTION_TYPE_GARAGE_VLAD);

				Buygarage[playerid] = true;

				ShowNotification(playerid, 1, "Вы потратили 500000 рублей", 3, "", "");

                new GarageVlad[64];
				format(GarageVlad, sizeof(GarageVlad), "{FFFF00}Гараж №%d\n{FFFFFF}Владелец: {8B0000}%s\n{00FF00}Гараж открыт", g_GarageCount, GetPlayerName(playerid));

       			CreateDynamic3DTextLabel(GarageVlad, 0xFFFF00FF, playerPos[0], playerPos[1], playerPos[2] + 1, 12.0);
            } else {
                SendClientMessage(playerid, COLOR_RED, "У вас недостаточно средств");
            }
        }

    }


CreateDynamic3DTextLabel("Нажмите на {8B0000}гудок\n{FFFFFF}Что бы выехать", -1, 1.2011, 1994.7356, 1554.2031, 9.0, _, _, _, -1, -1);
ExitGarage1 = CreatePickup(1318, 23, 1.2011, 1994.7356, 1554.2031, 0);
    
    
15) #define GARAGE_PRICE 500000
15) new g_CurrentPickup;
15) new g_GarageBuy;
15) new g_GarageTextLabel;
15) PICKUP_TYPE_GARAGE,
15) PICKUP_ACTION_TYPE_GARAGE_VLAD,
15) DIALOG_GARAGE_BUY 
15) new pickupId;
15) new pickupIDs;
15) new garageLabel;
15) #define MAX_GARAGES 1000 // Максимальное количество гаражей
15) new pickupIds[MAX_GARAGES]; // Массив для хранения идентификаторов пикапов
15) new textLabels[MAX_GARAGES]; // Массив для хранения идентификаторов текстовых меток
15) new g_GarageCount = 0; // Счетчик гаражей
15) new ExitGarage1;
15) DIALOG_MENU_GARAGE,
15) DIALOG_MENU_GARAGE_VLAD,
15) DIALOG_GARAGE_APP,
15)

южный координаты:
1)	2571.70, -1874.21, 21.96
2)	2571.70, -1878.73, 21.96
3)	2571.70, -1883.15, 21.96
4)	2571.70, -1887.76, 21.96
5)	2571.70, -1892.41, 21.96
6)	2571.70, -1896.85, 21.96
7)	2571.70, -1901.33, 21.96
8)	2571.70, -1906.02, 21.96
9)	2571.70, -1910.47, 21.96
10)	2571.70, -1915.13, 21.96
11)	2571.70, -1919.56, 21.96
12)	2571.70, -1924.02, 21.96
13)	2571.70, -1928.71, 21.96
14)	2571.70, -1932.97, 21.96
15)	2571.70, -1937.62, 21.96
16)	2571.70, -1942.30, 21.96
17)	2571.70, -1946.80, 21.96
18)	2571.70, -1951.38, 21.96
19)	2571.70, -1955.80, 21.96
20)	2571.70, -1960.42, 21.96
21)	2571.70, -1965.06, 21.96
22)	2571.70, -1969.51, 21.96
23)	2571.70, -1973.91, 21.96
24)	2571.70, -1978.64, 21.96
25)	2571.70, -1983.20, 21.96
26)	2571.70, -1987.68, 21.96
27)	2571.70, -1992.22, 21.96
28)	2571.70, -1996.70, 21.96
29)	2571.70, -2001.31, 21.96
30)	2571.70, -2005.84, 21.96
31)	2571.70, -2010.42, 21.96
32)	2559.48, -1869.62, 21.96
33)	2559.48, -1874.21, 21.96
34)	2559.48, -1878.73, 21.96
35)	2559.48, -1883.15, 21.96
36)	2559.48, -1887.76, 21.96
37)	2559.48, -1892.41, 21.96
38)	2559.48, -1896.85, 21.96
39)	2559.48, -1901.33, 21.96
40)	2559.48, -1906.02, 21.96
41)	2559.48, -1910.47, 21.96
42)	2559.48, -1915.13, 21.96
43)	2559.48, -1919.56, 21.96
44)	2559.48, -1924.02, 21.96
45)	2559.48, -1928.71, 21.96
46)	2559.48, -1932.97, 21.96
47)	2559.48, -1937.62, 21.96
48)	2559.48, -1942.30, 21.96
49)	2559.48, -1946.80, 21.96
50)	2559.48, -1951.38, 21.96
51)	2559.48, -1955.80, 21.96
52)	2559.48, -1960.42, 21.96
53)	2559.48, -1965.06, 21.96
54)	2559.48, -1969.51, 21.96
55)	2559.48, -1973.91, 21.96
56)	2559.48, -1978.64, 21.96
57)	2559.48, -1983.20, 21.96
58)	2559.48, -1987.68, 21.96
59)	2559.48, -1992.22, 21.96
60)	2559.48, -1996.70, 21.96
61)	2559.48, -2001.31, 21.96
62) 2559.48, -2005.84, 21.96
63)	2559.48, -2010.42, 21.96

батырево координаты:

64)  1718.40, 2321.22, 15.76
65)  1722.83, 2321.23, 15.76
66)  1727.42, 2321.22, 15.76
67)  1731.81, 2321.22, 15.76
68)  1736.29, 2321.22, 15.76
69)  1740.72, 2321.22, 15.76
70)  1745.21, 2321.22, 15.76
71)  1749.69, 2321.23, 15.76
72)  1754.23, 2321.21, 15.76
73)  1758.64, 2321.21, 15.77
74)  1763.06, 2321.21, 15.77
75)  1767.48, 2321.23, 15.77
76)	 1771.90, 2321.21, 15.77
77)  1776.44, 2321.21, 15.78
78)  1781.32, 2322.93, 15.76
79)  1785.23, 2325.43, 15.76
80)  1788.91, 2327.79, 15.76
81)  1792.70, 2330.22, 15.76
82)  1796.42, 2332.60, 15.77
83)  1731.28, 2333.64, 15.78
84)  1730.50, 2338.02, 15.80
85)	 1729.71, 2342.23, 15.82
86)  1728.96, 2346.75, 15.83
87)  1728.16, 2351.26, 15.83
88)  1727.40, 2355.60, 15.83
89)  1726.62, 2360.00, 15.83
90)  1725.85, 2364.41, 15.83
91)  1716.59, 2364.70, 15.76
92)  1717.26, 2360.32, 15.76
93)  1718.16, 1355.82, 15.76
94)  1718.94, 2351.35, 15.76
95)  1719.71, 2347.02, 15.76
96)  1738.32, 2366.79, 15.82
97)  1739.13, 2362.23, 15.82
98)  1739.88, 2357.95, 15.82
99)  1740.67, 2353.48, 15.82
100) 1741.43, 2349.14, 15.82
101) 1742.22, 2344.68, 15.84
102) 1742.97, 2340.36, 15.82
103) 1743.76, 2335.90, 15.79
104) 1754.61, 2333.63, 15.76
105) 1753.85, 2338.03, 15.76
106) 1753.07, 2342.45, 15.76
107) 1752.31, 2346.78, 15.75
108) 1751.52, 2351.25, 15.75
109) 1750.76, 2355.56, 15.75
110) 1749.97, 2360.07, 15.74
111) 1749.20, 2364.49, 15.74
112) 1786.67, 2339.79, 15.75
113) 1784.36, 2343.43, 15.76
114) 1781.94, 2347.18, 15.76
115) 1779.47, 2351.04, 15.76
116) 1777.10, 2354.74, 15.76
117) 1774.70, 2358.48, 15.76
118) 1772.29, 2362.25, 15.76
119) 1769.85, 2366.05, 15.76
120) 1767.46, 2369.79, 15.76
121) 1765.05, 2373.54, 15.77
122) 1762.62, 2377.33, 15.77
123) 1759.57, 2379.11, 15.76
124) 1755.00, 2379.11, 15.76
125) 1750.62, 2379.11, 15.76
126) 1746.18, 2379.11, 15.76
127) 1741.56, 2379.11, 15.76
128) 1737.16, 2379.11, 15.76
129) 1742.70, 2379.11, 15.76
130) 1728.34, 2379.11, 15.76
131) 1723.83, 2379.11, 15.76
132) 1719.31, 2379.11, 15.76
133) 1714.81, 2379.11, 15.77

координаты бус:

134) -721.17, -1559.88, 41.32
135) -718.93, -1556.19, 41.33
136) -716.80, -1552.63, 41.33
137) -714.64, -1549.01, 41.33
138) -712.48, -1545.39, 41.33
139) -710.24, -1541.61, 41.33
140) -708.07, -1537.99, 41.32
141) -705.93, -1534.41, 41.32
142) -703.77, -1530.79, 41.32
143) -716.08, -1523.53, 41.32
144) -718.26, -1527.17, 41.32
145) -720.42, -1530.79, 41.32
146) -722.59, -1534.42, 41.32
147) -724.75, -1538.04, 41.32
148) -726.92, -1541.70, 41.32
149) -729.00, -1545.18, 41.31
150) -731.31, -1549.04, 41.31
151) -733.43, -1552.59, 41.32


stock CreateGarage(playerid)
{
        if (g_GarageCount >= MAX_GARAGES) {
        SendClientMessage(playerid, COLOR_RED, "Достигнуто максимальное количество гаражей.");
        return;
    	}

		g_GarageCount++;

       	new Float:playerPos[3];
       	GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

       	new garageLabel[64];
		format(garageLabel, sizeof(garageLabel), "{FFFF00}Гараж № %d\n{FFFFFF}Гараж продается", g_GarageCount);

       	CreateDynamic3DTextLabel(garageLabel, 0xFFFF00FF, playerPos[0], playerPos[1], playerPos[2] + 1, 12.0);

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		CreatePickup(1318, 23, x, y, z, 0, PICKUP_ACTION_TYPE_GARAGE);

       	new message[128];
       	format(message, sizeof(message), "%s.", garageLabel);
       	SendClientMessage(playerid, COLOR_WHITE, message);
}

CMD:addgarage(playerid)
{
    if(GetPlayerAdminEx(playerid) >= 6)
	{
		CreateGarage(playerid);
		return 1;
 	}
}

CMD:garage(playerid)
{
	if(!(Buygarage[playerid]))
	{
    Dialog
	(
		playerid, DIALOG_MENU_GARAGE_VLAD, DIALOG_STYLE_MSGBOX,
		"{8B0000}Информация о гараже",
		"Номер гаража: 	СКОРО...\n"\
		"Состояние:		СКОРО...\n"\
		"Оплачен на:	СКОРО...\n"\
		"Стоимость:		500000 руб.\n\n"\
		"{7FFF00}Для открытия панели управления вашим гаражом\n"\
		"{7FFF00}Нажмите кнопку Изменить.",
		"Изменить", "Закрыть"
	);
	return 1;
	}
	else
	{
	SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} У вас нету гаража");
	}
}

/*new garageid = g_GarageCount;
#define GetGarageData(%0,%1)			g_garage[%0][%1]

enum E_GARAGE_STRUCT
{
	H_APP,
    H_MONEY
};

new g_garage[MAX_GARAGES][E_GARAGE_STRUCT];

    new fmt_str[1024];
    
		format
		(
			fmt_str, sizeof fmt_str,
			"%sНомер гаража:\t\t%d\n"\
			"Состояние:\t\t\t\t%s\n"\
			"Оплачен на:\t\t\t%d/30 дней\n"\
			"Стоимость:		500000 руб.\n\n"\
			"{7FFF00}Для открытия панели управления вашим гаражом\n"\
			"{7FFF00}Нажмите кнопку \"Изменить"\",
			fmt_str,
			garageid,
			GetGarageData(garageid, H_APP) < 1 ? ("гараж открыт") : ("гараж закрыт"),
			GetGarageData(garageid, H_MONEY),
		);
		Dialog(playerid, DIALOG_MENU_GARAGE_VLAD, DIALOG_STYLE_MSGBOX, "{8B0000}Информация о гараже", fmt_str, "Изменить", "Закрыть");
*/


       
// OnDialogResponse
			case DIALOG_MENU_GARAGE:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: {
						    Dialog
							(
								playerid, DIALOG_MENU_GARAGE, DIALOG_STYLE_LIST,
								"{8B0000}Панель",
								"1.Открыть/Закрыть гараж\n"\
								"2.Продать гараж\n"\
								"3.Улучшения\n"\
								"4.Доставить транспорт в гараж\n"\
								"5.Отметить гараж на GPS\n"\
								"6.Продать гараж другому игроку",
								"Выбрать", "Закрыть"
							);
						}
						case 2: {
                            GivePlayerMoneyEx(playerid, 250000);
						}
						case 3: {
							Dialog
							(,
								playerid, DIALOG_GARAGE_APP, DIALOG_STYLE_LIST,
							   "{8B0000}Улучшения",
							   "1.Возможность проживания в гараже 	30000 руб.\n"\
							   "2.Сейф в гараже 					40000 руб.\n"\
							   "3.Улучшение до элитного 			5000000 руб.",
							   "Далее", "Выйти"

							);
						}
						case 4: {
							Dialog
							(
								playerid, DIALOG_ACT_PROMO, DIALOG_STYLE_LIST,

							);
						}
						case 5: {
 							Dialog
							(
								playerid, DIALOG_ACT_PROMO, DIALOG_STYLE_LIST,

							);
						}
						case 6: {
							Dialog
							(
								ShowPlayerDialog(playerid, DIALOR_GARAGE_SELL, DIALOG_STYLE_INPUT, "{8B0000}Продажа гаража",
								"Введите ID игрока и цену за гараж через запятую. (Пример: 188, 1000000)\n"\
								"- Комиссия с продажи 1 процент.",
								"Далее", "Выйти");

							);
						}
						default:
							return 1;
					}
				}
			}

new garage1;
new garage1d;
new garage2;
new garage2d;
new garage3;
new garage3d;
new garage4;
new garage4d;
new garage5;
new garage5d;
new garage6;
new garage6d;
new garage7;
new garage7d;
new garage8;
new garage8d;
new garage9;
new garage9d;
new garage10;
new garage10d;
new garage11;
new garage11d;
new garage12;
new garage12d;
new garage13;
new garage13d;
new garage14;
new garage14d;
new garage15;
new garage15d;
new garage16;
new garage16d;
new garage17;
new garage17d;
new garage18;
new garage18d;
new garage19;
new garage19d;
new garage20;
new garage20d;
new garage21;
new garage21d;
new garage22;
new garage22d;
new garage23;
new garage23d;
new garage24;
new garage24d;
new garage25;
new garage25d;
new garage26;
new garage26d;
new garage27;
new garage27d;
new garage28;
new garage28d;
new garage29;
new garage29d;
new garage30;
new garage30d;
new garage31;
new garage31d;
new garage32;
new garage32d;
new garage33;
new garage33d;
new garage34;
new garage34d;
new garage35;
new garage35d;
new garage36;
new garage36d;
new garage37;
new garage37d;
new garage38;
new garage38d;
new garage39;
new garage39d;
new garage40;
new garage40d;
new garage41;
new garage41d;
new garage42;
new garage42d;
new garage43;
new garage43d;
new garage44;
new garage44d;
new garage45;
new garage45d;
new garage46;
new garage46d;
new garage47;
new garage47d;
new garage48;
new garage48d;
new garage49;
new garage49d;
new garage50;
new garage50d;
new garage51;
new garage51d;
new garage52;
new garage52d;
new garage53;
new garage53d;
new garage54;
new garage54d;
new garage55;
new garage55d;
new garage56;
new garage56d;
new garage57;
new garage57d;
new garage58;
new garage58d;
new garage59;
new garage59d;
new garage60;
new garage60d;
new garage61;
new garage61d;
new garage62;
new garage62d;
new garage63;
new garage63d;
new garage64;
new garage64d;
new garage65;
new garage65d;
new garage66;
new garage66d;
new garage67;
new garage67d;
new garage68;
new garage68d;
new garage69;
new garage69d;
new garage70;
new garage70d;
new garage71;
new garage71d;
new garage72;
new garage72d;
new garage73;
new garage73d;
new garage74;
new garage74d;
new garage75;
new garage75d;
new garage76;
new garage76d;
new garage77;
new garage77d;
new garage78;
new garage78d;
new garage79;
new garage79d;
new garage80;
new garage80d;
new garage81;
new garage81d;
new garage82;
new garage82d;
new garage83;
new garage83d;
new garage84;
new garage84d;
new garage85;
new garage85d;
new garage86;
new garage86d;
new garage87;
new garage87d;
new garage88;
new garage88d;
new garage89;
new garage89d;
new garage90;
new garage90d;
new garage91;
new garage91d;
new garage92;
new garage92d;
new garage93;
new garage93d;
new garage94;
new garage94d;
new garage95;
new garage95d;
new garage96;
new garage96d;
new garage97;
new garage97d;
new garage98;
new garage98d;
new garage99;
new garage99d;
new garage100;
new garage100d;
new garage101;
new garage101d;
new garage102;
new garage102d;
new garage103;
new garage103d;
new garage104;
new garage104d;
new garage105;
new garage105d;
new garage106;
new garage106d;
new garage107;
new garage107d;
new garage108;
new garage108d;
new garage109;
new garage109d;
new garage110;
new garage110d;
new garage111;
new garage111d;
new garage112;
new garage112d;
new garage113;
new garage113d;
new garage114;
new garage114d;
new garage115;
new garage115d;
new garage116;
new garage116d;
new garage117;
new garage117d;
new garage118;
new garage118d;
new garage119;
new garage119d;
new garage120;
new garage120d;
new garage121;
new garage121d;
new garage122;
new garage122d;
new garage123;
new garage123d;
new garage124;
new garage124d;
new garage125;
new garage125d;
new garage126;
new garage126d;
new garage127;
new garage127d;
new garage128;
new garage128d;
new garage129;
new garage129d;
new garage130;
new garage130d;
new garage131;
new garage131d;
new garage132;
new garage132d;
new garage133;
new garage133d;
new garage134;
new garage134d;
new garage135;
new garage135d;
new garage136;
new garage136d;
new garage137;
new garage137d;
new garage138;
new garage138d;
new garage139;
new garage139d;
new garage140;
new garage140d;
new garage141;
new garage141d;
new garage142;
new garage142d;
new garage143;
new garage143d;
new garage144;
new garage144d;
new garage145;
new garage145d;
new garage146;
new garage146d;
new garage147;
new garage147d;
new garage148;
new garage148d;
new garage149;
new garage149d;
new garage150;
new garage150d;
new garage151;
new garage151d;
new garage1dBUY;
new garage1BUY;

DIALOG_GARAGE_BUY1,
DIALOG_GARAGE_BUY2,
DIALOG_GARAGE_BUY3,
DIALOG_GARAGE_BUY4,
DIALOG_GARAGE_BUY5,
DIALOG_GARAGE_BUY6,
DIALOG_GARAGE_BUY7,
DIALOG_GARAGE_BUY8,
DIALOG_GARAGE_BUY9,
DIALOG_GARAGE_BUY10,
DIALOG_GARAGE_BUY11,
DIALOG_GARAGE_BUY12,
DIALOG_GARAGE_BUY13,
DIALOG_GARAGE_BUY14,
DIALOG_GARAGE_BUY15,
DIALOG_GARAGE_BUY16,
DIALOG_GARAGE_BUY17,
DIALOG_GARAGE_BUY18,
DIALOG_GARAGE_BUY19,
DIALOG_GARAGE_BUY20,
DIALOG_GARAGE_BUY21,
DIALOG_GARAGE_BUY22,
DIALOG_GARAGE_BUY23,
DIALOG_GARAGE_BUY24,
DIALOG_GARAGE_BUY25,
DIALOG_GARAGE_BUY26,
DIALOG_GARAGE_BUY27,
DIALOG_GARAGE_BUY28,
DIALOG_GARAGE_BUY29,
DIALOG_GARAGE_BUY30,
DIALOG_GARAGE_BUY31,
DIALOG_GARAGE_BUY32,
DIALOG_GARAGE_BUY33,
DIALOG_GARAGE_BUY34,
DIALOG_GARAGE_BUY35,
DIALOG_GARAGE_BUY36,
DIALOG_GARAGE_BUY37,
DIALOG_GARAGE_BUY38,
DIALOG_GARAGE_BUY39,
DIALOG_GARAGE_BUY40,
DIALOG_GARAGE_BUY41,
DIALOG_GARAGE_BUY42,
DIALOG_GARAGE_BUY43,
DIALOG_GARAGE_BUY44,
DIALOG_GARAGE_BUY45,
DIALOG_GARAGE_BUY46,
DIALOG_GARAGE_BUY47,
DIALOG_GARAGE_BUY48,
DIALOG_GARAGE_BUY49,
DIALOG_GARAGE_BUY50,
DIALOG_GARAGE_BUY51,
DIALOG_GARAGE_BUY52,
DIALOG_GARAGE_BUY53,
DIALOG_GARAGE_BUY54,
DIALOG_GARAGE_BUY55,
DIALOG_GARAGE_BUY56,
DIALOG_GARAGE_BUY57,
DIALOG_GARAGE_BUY58,
DIALOG_GARAGE_BUY59,
DIALOG_GARAGE_BUY60,
DIALOG_GARAGE_BUY61,
DIALOG_GARAGE_BUY62,
DIALOG_GARAGE_BUY63,
DIALOG_GARAGE_BUY64,
DIALOG_GARAGE_BUY65,
DIALOG_GARAGE_BUY66,
DIALOG_GARAGE_BUY67,
DIALOG_GARAGE_BUY68,
DIALOG_GARAGE_BUY69,
DIALOG_GARAGE_BUY70,
DIALOG_GARAGE_BUY71,
DIALOG_GARAGE_BUY72,
DIALOG_GARAGE_BUY73,
DIALOG_GARAGE_BUY74,
DIALOG_GARAGE_BUY75,
DIALOG_GARAGE_BUY76,
DIALOG_GARAGE_BUY77,
DIALOG_GARAGE_BUY78,
DIALOG_GARAGE_BUY79,
DIALOG_GARAGE_BUY80,
DIALOG_GARAGE_BUY81,
DIALOG_GARAGE_BUY82,
DIALOG_GARAGE_BUY83,
DIALOG_GARAGE_BUY84,
DIALOG_GARAGE_BUY85,
DIALOG_GARAGE_BUY86,
DIALOG_GARAGE_BUY87,
DIALOG_GARAGE_BUY88,
DIALOG_GARAGE_BUY89,
DIALOG_GARAGE_BUY90,
DIALOG_GARAGE_BUY91,
DIALOG_GARAGE_BUY92,
DIALOG_GARAGE_BUY93,
DIALOG_GARAGE_BUY94,
DIALOG_GARAGE_BUY95,
DIALOG_GARAGE_BUY96,
DIALOG_GARAGE_BUY97,
DIALOG_GARAGE_BUY98,
DIALOG_GARAGE_BUY99,
DIALOG_GARAGE_BUY100,
DIALOG_GARAGE_BUY101,
DIALOG_GARAGE_BUY102,
DIALOG_GARAGE_BUY103,
DIALOG_GARAGE_BUY104,
DIALOG_GARAGE_BUY105,
DIALOG_GARAGE_BUY106,
DIALOG_GARAGE_BUY107,
DIALOG_GARAGE_BUY108,
DIALOG_GARAGE_BUY109,
DIALOG_GARAGE_BUY110,
DIALOG_GARAGE_BUY111,
DIALOG_GARAGE_BUY112,
DIALOG_GARAGE_BUY113,
DIALOG_GARAGE_BUY114,
DIALOG_GARAGE_BUY115,
DIALOG_GARAGE_BUY116,
DIALOG_GARAGE_BUY117,
DIALOG_GARAGE_BUY118,
DIALOG_GARAGE_BUY119,
DIALOG_GARAGE_BUY120,
DIALOG_GARAGE_BUY121,
DIALOG_GARAGE_BUY122,
DIALOG_GARAGE_BUY123,
DIALOG_GARAGE_BUY124,
DIALOG_GARAGE_BUY125,
DIALOG_GARAGE_BUY126,
DIALOG_GARAGE_BUY127,
DIALOG_GARAGE_BUY128,
DIALOG_GARAGE_BUY129,
DIALOG_GARAGE_BUY130,
DIALOG_GARAGE_BUY131,
DIALOG_GARAGE_BUY132,
DIALOG_GARAGE_BUY133,
DIALOG_GARAGE_BUY134,
DIALOG_GARAGE_BUY135,
DIALOG_GARAGE_BUY136,
DIALOG_GARAGE_BUY137,
DIALOG_GARAGE_BUY138,
DIALOG_GARAGE_BUY139,
DIALOG_GARAGE_BUY140,
DIALOG_GARAGE_BUY141,
DIALOG_GARAGE_BUY142,
DIALOG_GARAGE_BUY143,
DIALOG_GARAGE_BUY144,
DIALOG_GARAGE_BUY145,
DIALOG_GARAGE_BUY146,
DIALOG_GARAGE_BUY147,
DIALOG_GARAGE_BUY148,
DIALOG_GARAGE_BUY149,
DIALOG_GARAGE_BUY150,
DIALOG_GARAGE_BUY151,


// ГАРАЖИ НАЧАЛО ПИКАПЫ+3Д ТЕКСТЫ
stock Garagee1(playerid)
{
garage1d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 1\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1874.21, 21.96 + 1, 12.0);
garage1 = CreatePickup(1318, 23, 2571.70, -1874.21, 21.96, 0);
}

stock Garagee2(playerid)
{
garage2d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 2\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1878.73, 21.96 + 1, 12.0);
garage2 = CreatePickup(1318, 23, 2571.70, -1878.73, 21.96, 0);
}

stock Garagee3(playerid)
{
garage3d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 3\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1883.15, 21.96 + 1, 12.0);
garage3 = CreatePickup(1318, 23, 2571.70, -1883.15, 21.96, 0);
}

stock Garagee4(playerid)
{
garage4d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 4\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1887.76, 21.96 + 1, 12.0);
garage4 = CreatePickup(1318, 23, 2571.70, -1887.76, 21.96, 0);
}

stock Garagee5(playerid)
{
garage5d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 5\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1892.41, 21.96 + 1, 12.0);
garage5 = CreatePickup(1318, 23, 2571.70, -1892.41, 21.96, 0);
}

stock Garagee6(playerid)
{
garage6d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 6\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1896.85, 21.96 + 1, 12.0);
garage6 = CreatePickup(1318, 23, 2571.70, -1896.85, 21.96, 0);
}

stock Garagee7(playerid)
{
garage7d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 7\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1901.33, 21.96 + 1, 12.0);
garage7 = CreatePickup(1318, 23, 2571.70, -1901.33, 21.96, 0);
}

stock Garagee8(playerid)
{
garage8d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 8\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1906.02, 21.96 + 1, 12.0);
garage8 = CreatePickup(1318, 23, 2571.70, -1906.02, 21.96, 0);
}

stock Garagee9(playerid)
{
garage9d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 9\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1910.47, 21.96 + 1, 12.0);
garage9 = CreatePickup(1318, 23, 2571.70, -1910.47, 21.96, 0);
}

stock Garagee10(playerid)
{
garage10d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 10\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1915.13, 21.96 + 1, 12.0);
garage10 = CreatePickup(1318, 23, 2571.70, -1915.13, 21.96, 0);
}

stock Garagee11(playerid)
{
garage11d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 11\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1919.56, 21.96 + 1, 12.0);
garage11 = CreatePickup(1318, 23, 2571.70, -1919.56, 21.96, 0);
}

stock Garagee12(playerid)
{
garage12d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 12\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1924.02, 21.96 + 1, 12.0);
garage12 = CreatePickup(1318, 23, 2571.70, -1924.02, 21.96, 0);
}

stock Garagee13(playerid)
{
garage13d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 13\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1928.71, 21.96 + 1, 12.0);
garage13 = CreatePickup(1318, 23, 2571.70, -1928.71, 21.96, 0);
}

stock Garagee14(playerid)
{
garage14d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 14\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1932.97, 21.96 + 1, 12.0);
garage14 = CreatePickup(1318, 23, 2571.70, -1932.97, 21.96, 0);
}

stock Garagee15(playerid)
{
garage15d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 15\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1937.62, 21.96 + 1, 12.0);
garage15 = CreatePickup(1318, 23, 2571.70, -1937.62, 21.96, 0);
}

stock Garagee16(playerid)
{
garage16d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 16\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1942.30, 21.96 + 1, 12.0);
garage16 = CreatePickup(1318, 23, 2571.70, -1942.30, 21.96, 0);
}

stock Garagee17(playerid)
{
garage17d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 17\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1946.80, 21.96 + 1, 12.0);
garage17 = CreatePickup(1318, 23, 2571.70, -1946.80, 21.96, 0);
}

stock Garagee18(playerid)
{
garage18d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 18\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1951.38, 21.96 + 1, 12.0);
garage18 = CreatePickup(1318, 23, 2571.70, -1951.38, 21.96, 0);
}

stock Garagee19(playerid)
{
garage19d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 19\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1955.80, 21.96 + 1, 12.0);
garage19 = CreatePickup(1318, 23, 2571.70, -1955.80, 21.96, 0);
}

stock Garagee20(playerid)
{
garage20d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 20\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1960.42, 21.96 + 1, 12.0);
garage20 = CreatePickup(1318, 23, 2571.70, -1960.42, 21.96, 0);
}

stock Garagee21(playerid)
{
garage21d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 21\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1965.06, 21.96 + 1, 12.0);
garage21 = CreatePickup(1318, 23, 2571.70, -1965.06, 21.96, 0);
}

stock Garagee22(playerid)
{
garage22d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 22\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1969.51, 21.96 + 1, 12.0);
garage22 = CreatePickup(1318, 23, 2571.70, -1969.51, 21.96, 0);
}

stock Garagee23(playerid)
{
garage23d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 23\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1973.91, 21.96 + 1, 12.0);
garage23 = CreatePickup(1318, 23, 2571.70, -1973.91, 21.96, 0);
}

stock Garagee24(playerid)
{
garage24d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 24\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1978.64, 21.96 + 1, 12.0);
garage24 = CreatePickup(1318, 23, 2571.70, -1978.64, 21.96, 0);
}

stock Garagee25(playerid)
{
garage25d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 25\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1983.20, 21.96 + 1, 12.0);
garage25 = CreatePickup(1318, 23, 2571.70, -1983.20, 21.96, 0);
}

stock Garagee26(playerid)
{
garage26d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 26\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1987.68, 21.96 + 1, 12.0);
garage26 = CreatePickup(1318, 23, 2571.70, -1987.68, 21.96, 0);
}

stock Garagee27(playerid)
{
garage27d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 27\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1992.22, 21.96 + 1, 12.0);
garage27 = CreatePickup(1318, 23, 2571.70, -1992.22, 21.96, 0);
}

stock Garagee28(playerid)
{
garage28d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 28\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1996.70, 21.96 + 1, 12.0);
garage28 = CreatePickup(1318, 23, 2571.70, -1996.70, 21.96, 0);
}

stock Garagee29(playerid)
{
garage29d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 29\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -2001.31, 21.96 + 1, 12.0);
garage29 = CreatePickup(1318, 23, 2571.70, -2001.31, 21.96, 0);
}

stock Garagee30(playerid)
{
garage30d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 30\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -2005.84, 21.96 + 1, 12.0);
garage30 = CreatePickup(1318, 23, 2571.70, -2005.84, 21.96, 0);
}

stock Garagee31(playerid)
{
garage31d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 31\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -2010.42, 21.96 + 1, 12.0);
garage31 = CreatePickup(1318, 23, 2571.70, -2010.42, 21.96, 0);
}

stock Garagee32(playerid)
{
garage32d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 32\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1869.62, 21.96 + 1, 12.0);
garage32 = CreatePickup(1318, 23, 2559.48, -1869.62, 21.96, 0);
}

stock Garagee33(playerid)
{
garage33d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 33\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1874.21, 21.96 + 1, 12.0);
garage33 = CreatePickup(1318, 23, 2559.48, -1874.21, 21.96, 0);
}

stock Garagee34(playerid)
{
garage34d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 34\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1878.73, 21.96 + 1, 12.0);
garage34 = CreatePickup(1318, 23, 2559.48, -1878.73, 21.96, 0);
}

stock Garagee35(playerid)
{
garage35d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 35\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1883.15, 21.96 + 1, 12.0);
garage35 = CreatePickup(1318, 23, 2571.70, -1883.15, 21.96, 0);
}

stock Garagee36(playerid)
{
garage36d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 36\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1887.76, 21.96 + 1, 12.0);
garage36 = CreatePickup(1318, 23, 2559.48, -1887.76, 21.96, 0);
}

stock Garagee37(playerid)
{
garage37d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 37\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1892.41, 21.96 + 1, 12.0);
garage37 = CreatePickup(1318, 23, 2559.48, -1892.41, 21.96, 0);
}

stock Garagee38(playerid)
{
garage38d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 38\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1896.85, 21.96 + 1, 12.0);
garage38 = CreatePickup(1318, 23, 2559.48, -1896.85, 21.96, 0);
}

stock Garagee39(playerid)
{
garage39d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 39\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1901.33, 21.96 + 1, 12.0);
garage39 = CreatePickup(1318, 23, 2559.48, -1901.33, 21.96, 0);
}

stock Garagee40(playerid)
{
garage40d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 40\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1906.02, 21.96 + 1, 12.0);
garage40 = CreatePickup(1318, 23, 2559.48, -1906.02, 21.96, 0);
}

stock Garagee41(playerid)
{
garage41d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 41\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1910.47, 21.96 + 1, 12.0);
garage41 = CreatePickup(1318, 23, 2559.48, -1910.47, 21.96, 0);
}

stock Garagee42(playerid)
{
garage42d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 42\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1915.13, 21.96 + 1, 12.0);
garage42 = CreatePickup(1318, 23, 2559.48, -1915.13, 21.96, 0);
}

stock Garagee43(playerid)
{
garage43d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 43\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1919.56, 21.96 + 1, 12.0);
garage43 = CreatePickup(1318, 23, 2559.48, -1919.56, 21.96, 0);
}

stock Garagee44(playerid)
{
garage44d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 44\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1924.02, 21.96 + 1, 12.0);
garage44 = CreatePickup(1318, 23, 2559.48, -1924.02, 21.96, 0);
}

stock Garagee45(playerid)
{
garage45d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 45\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1928.71, 21.96 + 1, 12.0);
garage45 = CreatePickup(1318, 23, 2559.48, -1928.71, 21.96, 0);
}

stock Garagee46(playerid)
{
garage46d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 46\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1932.97, 21.96 + 1, 12.0);
garage46 = CreatePickup(1318, 23, 2559.48, -1932.97, 21.96, 0);
}

stock Garagee47(playerid)
{
garage47d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 47\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1937.62, 21.96 + 1, 12.0);
garage47 = CreatePickup(1318, 23, 2559.48, -1937.62, 21.96, 0);
}

stock Garagee48(playerid)
{
garage48d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 48\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1942.30, 21.96 + 1, 12.0);
garage48 = CreatePickup(1318, 23, 2559.48, -1942.30, 21.96, 0);
}

stock Garagee49(playerid)
{
garage49d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 49\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1946.80, 21.96 + 1, 12.0);
garage49 = CreatePickup(1318, 23, 2559.48, -1946.80, 21.96, 0);
}

stock Garagee50(playerid)
{
garage50d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 50\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1951.38, 21.96 + 1, 12.0);
garage50 = CreatePickup(1318, 23, 2559.48, -1951.38, 21.96, 0);
}

stock Garagee51(playerid)
{
garage51d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 51\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1955.80, 21.96 + 1, 12.0);
garage51 = CreatePickup(1318, 23, 2559.48, -1955.80, 21.96, 0);
}

stock Garagee52(playerid)
{
garage52d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 52\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1960.42, 21.96 + 1, 12.0);
garage52 = CreatePickup(1318, 23, 2559.48, -1960.42, 21.96, 0);
}

stock Garagee53(playerid)
{
garage53d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 53\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1965.06, 21.96 + 1, 12.0);
garage53 = CreatePickup(1318, 23, 2559.48, -1965.06, 21.96, 0);
}

stock Garagee54(playerid)
{
garage54d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 54\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1969.51, 21.96 + 1, 12.0);
garage54 = CreatePickup(1318, 23, 2559.48, -1969.51, 21.96, 0);
}

stock Garagee55(playerid)
{
garage55d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 55\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1973.91, 21.96 + 1, 12.0);
garage55 = CreatePickup(1318, 23, 2559.48, -1973.91, 21.96, 0);
}

stock Garagee56(playerid)
{
garage56d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 56\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1978.64, 21.96 + 1, 12.0);
garage56 = CreatePickup(1318, 23, 2559.48, -1978.64, 21.96, 0);
}

stock Garagee57(playerid)
{
garage57d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 57\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1983.20, 21.96 + 1, 12.0);
garage57 = CreatePickup(1318, 23, 2559.48, -1983.20, 21.96, 0);
}

stock Garagee58(playerid)
{
garage58d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 58\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1987.68, 21.96 + 1, 12.0);
garage58 = CreatePickup(1318, 23, 2559.48, -1987.68, 21.96, 0);
}

stock Garagee59(playerid)
{
garage59d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 59\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1992.22, 21.96 + 1, 12.0);
garage59 = CreatePickup(1318, 23, 2559.48, -1992.22, 21.96, 0);
}

stock Garagee60(playerid)
{
garage60d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 60\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -1996.70, 21.96 + 1, 12.0);
garage60 = CreatePickup(1318, 23, 2559.48, -1996.70, 21.96, 0);
}

stock Garagee61(playerid)
{
garage61d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 61\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -2001.31, 21.96 + 1, 12.0);
garage61 = CreatePickup(1318, 23, 2559.48, -2001.31, 21.96, 0);
}

stock Garagee62(playerid)
{
garage62d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 62\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -2005.84, 21.96 + 1, 12.0);
garage62 = CreatePickup(1318, 23, 2559.48, -2005.84, 21.96, 0);
}

stock Garagee63(playerid)
{
garage63d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 63\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2559.48, -2010.42, 21.96 + 1, 12.0);
garage63 = CreatePickup(1318, 23, 2559.48, -2010.42, 21.96, 0);
}

stock Garagee64(playerid)
{
garage64d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 64\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1718.40, 2321.22, 15.76 + 1, 12.0);
garage64 = CreatePickup(1318, 23, 1718.40, 2321.22, 15.76, 0);
}

stock Garagee65(playerid)
{
garage65d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 65\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1722.83, 2321.23, 15.76 + 1, 12.0);
garage65 = CreatePickup(1318, 23, 1722.83, 2321.23, 15.76, 0);
}

stock Garagee66(playerid)
{
garage66d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 66\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1727.42, 2321.22, 15.76 + 1, 12.0);
garage66 = CreatePickup(1318, 23, 1727.42, 2321.22, 15.76, 0);
}

stock Garagee67(playerid)
{
garage67d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 67\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1731.81, 2321.22, 15.76 + 1, 12.0);
garage67 = CreatePickup(1318, 23, 1731.81, 2321.22, 15.76, 0);
}

stock Garagee68(playerid)
{
garage68d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 68\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1736.29, 2321.22, 15.76 + 1, 12.0);
garage68 = CreatePickup(1318, 23, 1736.29, 2321.22, 15.76, 0);
}

stock Garagee69(playerid)
{
garage69d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 69\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1740.72, 2321.22, 15.76 + 1, 12.0);
garage69 = CreatePickup(1318, 23, 1740.72, 2321.22, 15.76, 0);
}

stock Garagee70(playerid)
{
garage70d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 70\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1745.21, 2321.22, 15.76 + 1, 12.0);
garage70 = CreatePickup(1318, 23, 1745.21, 2321.22, 15.76, 0);
}

stock Garagee71(playerid)
{
garage71d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 71\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1749.69, 2321.23, 15.76 + 1, 12.0);
garage71 = CreatePickup(1318, 23, 1749.69, 2321.23, 15.76, 0);
}

stock Garagee72(playerid)
{
garage72d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 72\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1754.23, 2321.21, 15.76 + 1, 12.0);
garage72 = CreatePickup(1318, 23, 1754.23, 2321.21, 15.76, 0);
}

stock Garagee73(playerid)
{
garage73d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 73\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1758.64, 2321.21, 15.77 + 1, 12.0);
garage73 = CreatePickup(1318, 23, 1758.64, 2321.21, 15.77, 0);
}

stock Garagee74(playerid)
{
garage74d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 74\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1763.06, 2321.21, 15.77 + 1, 12.0);
garage74 = CreatePickup(1318, 23, 1763.06, 2321.21, 15.77, 0);
}

stock Garagee75(playerid)
{
garage75d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 75\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1767.48, 2321.23, 15.77 + 1, 12.0);
garage75 = CreatePickup(1318, 23, 1767.48, 2321.23, 15.77, 0);
}

stock Garagee76(playerid)
{
garage76d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 76\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1771.90, 2321.21, 15.77 + 1, 12.0);
garage76 = CreatePickup(1318, 23, 1771.90, 2321.21, 15.77, 0);
}

stock Garagee77(playerid)
{
garage77d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 77\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1776.44, 2321.21, 15.78 + 1, 12.0);
garage77 = CreatePickup(1318, 23, 1776.44, 2321.21, 15.78, 0);
}

stock Garagee78(playerid)
{
garage78d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 78\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1781.32, 2322.93, 15.76 + 1, 12.0);
garage78 = CreatePickup(1318, 23, 1781.32, 2322.93, 15.76, 0);
}

stock Garagee79(playerid)
{
garage79d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 79\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1785.23, 2325.43, 15.76 + 1, 12.0);
garage79 = CreatePickup(1318, 23, 1785.23, 2325.43, 15.76, 0);
}

stock Garagee80(playerid)
{
garage80d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 80\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1788.91, 2327.79, 15.76 + 1, 12.0);
garage80 = CreatePickup(1318, 23, 1788.91, 2327.79, 15.76, 0);
}

stock Garagee81(playerid)
{
garage81d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 81\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1792.70, 2330.22, 15.76 + 1, 12.0);
garage81 = CreatePickup(1318, 23, 1792.70, 2330.22, 15.76, 0);
}

stock Garagee82(playerid)
{
garage82d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 82\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1796.42, 2332.60, 15.77 + 1, 12.0);
garage82 = CreatePickup(1318, 23, 1796.42, 2332.60, 15.77, 0);
}

stock Garagee83(playerid)
{
garage83d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 83\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1731.28, 2333.64, 15.78 + 1, 12.0);
garage83 = CreatePickup(1318, 23, 1731.28, 2333.64, 15.78, 0);
}

stock Garagee84(playerid)
{
garage84d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 84\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1730.50, 2338.02, 15.80 + 1, 12.0);
garage84 = CreatePickup(1318, 23, 1730.50, 2338.02, 15.80, 0);
}

stock Garagee85(playerid)
{
garage85d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 85\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1729.71, 2342.23, 15.82 + 1, 12.0);
garage85 = CreatePickup(1318, 23, 1729.71, 2342.23, 15.82, 0);
}

stock Garagee86(playerid)
{
garage86d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 86\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1728.96, 2346.75, 15.83 + 1, 12.0);
garage86 = CreatePickup(1318, 23, 1728.96, 2346.75, 15.83, 0);
}

stock Garagee87(playerid)
{
garage87d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 87\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1728.16, 2351.26, 15.83 + 1, 12.0);
garage87 = CreatePickup(1318, 23, 1728.16, 2351.26, 15.83, 0);
}

stock Garagee88(playerid)
{
garage88d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 88\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1727.40, 2355.60, 15.83 + 1, 12.0);
garage88 = CreatePickup(1318, 23, 1727.40, 2355.60, 15.83, 0);
}

stock Garagee89(playerid)
{
garage89d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 89\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1726.62, 2360.00, 15.83 + 1, 12.0);
garage89 = CreatePickup(1318, 23, 1726.62, 2360.00, 15.83, 0);
}

stock Garagee90(playerid)
{
garage90d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 90\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1725.85, 2364.41, 15.83 + 1, 12.0);
garage90 = CreatePickup(1318, 23, 1725.85, 2364.41, 15.83, 0);
}

stock Garagee91(playerid)
{
garage91d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 91\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1716.59, 2364.70, 15.76 + 1, 12.0);
garage91 = CreatePickup(1318, 23, 1716.59, 2364.70, 15.76, 0);
}

stock Garagee92(playerid)
{
garage92d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 92\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1717.26, 2360.32, 15.76 + 1, 12.0);
garage92 = CreatePickup(1318, 23, 1717.26, 2360.32, 15.76, 0);
}

stock Garagee93(playerid)
{
garage93d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 93\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1718.16, 1355.82, 15.76 + 1, 12.0);
garage93 = CreatePickup(1318, 23, 1718.16, 1355.82, 15.76, 0);
}

stock Garagee94(playerid)
{
garage94d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 94\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1718.94, 2351.35, 15.76 + 1, 12.0);
garage94 = CreatePickup(1318, 23, 1718.94, 2351.35, 15.76, 0);
}

stock Garagee95(playerid)
{
garage95d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 95\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1719.71, 2347.02, 15.76 + 1, 12.0);
garage95 = CreatePickup(1318, 23, 1718.94, 2351.35, 15.76, 0);
}

stock Garagee96(playerid)
{
garage96d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 96\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1738.32, 2366.79, 15.82 + 1, 12.0);
garage96 = CreatePickup(1318, 23, 1738.32, 2366.79, 15.82, 0);
}

stock Garagee97(playerid)
{
garage97d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 97\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1739.13, 2362.23, 15.82 + 1, 12.0);
garage97 = CreatePickup(1318, 23, 1739.13, 2362.23, 15.82, 0);
}

stock Garagee98(playerid)
{
garage98d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 98\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1739.88, 2357.95, 15.82 + 1, 12.0);
garage98 = CreatePickup(1318, 23, 1739.88, 2357.95, 15.82, 0);
}

stock Garagee99(playerid)
{
garage99d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 99\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1740.67, 2353.48, 15.82 + 1, 12.0);
garage99 = CreatePickup(1318, 23, 1740.67, 2353.48, 15.82, 0);
}

stock Garagee100(playerid)
{
garage100d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 100\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1741.43, 2349.14, 15.82 + 1, 12.0);
garage100 = CreatePickup(1318, 23, 1741.43, 2349.14, 15.82, 0);
}

stock Garagee101(playerid)
{
garage101d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 101\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1742.22, 2344.68, 15.84 + 1, 12.0);
garage101 = CreatePickup(1318, 23, 1742.22, 2344.68, 15.842, 0);
}

stock Garagee102(playerid)
{
garage102d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 102\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1742.97, 2340.36, 15.82 + 1, 12.0);
garage102 = CreatePickup(1318, 23, 1742.97, 2340.36, 15.82, 0);
}

stock Garagee103(playerid)
{
garage103d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 103\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1743.76, 2335.90, 15.79 + 1, 12.0);
garage103 = CreatePickup(1318, 23, 1743.76, 2335.90, 15.79, 0);
}

stock Garagee104(playerid)
{
garage104d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 104\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1754.61, 2333.63, 15.76 + 1, 12.0);
garage104 = CreatePickup(1318, 23, 1754.61, 2333.63, 15.76, 0);
}

stock Garagee105(playerid)
{
garage105d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 105\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1753.85, 2338.03, 15.76 + 1, 12.0);
garage105 = CreatePickup(1318, 23, 1753.85, 2338.03, 15.76, 0);
}

stock Garagee106(playerid)
{
garage106d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 106\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1753.07, 2342.45, 15.76 + 1, 12.0);
garage106 = CreatePickup(1318, 23, 1753.07, 2342.45, 15.76, 0);
}

stock Garagee107(playerid)
{
garage107d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 107\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1752.31, 2346.78, 15.75 + 1, 12.0);
garage107 = CreatePickup(1318, 23, 1752.31, 2346.78, 15.75, 0);
}

stock Garagee108(playerid)
{
garage108d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 108\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1751.52, 2351.25, 15.75 + 1, 12.0);
garage108 = CreatePickup(1318, 23, 1751.52, 2351.25, 15.75, 0);
}

stock Garagee109(playerid)
{
garage109d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 109\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1750.76, 2355.56, 15.75 + 1, 12.0);
garage109 = CreatePickup(1318, 23, 1750.76, 2355.56, 15.75, 0);
}

stock Garagee110(playerid)
{
garage110d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 110\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1749.97, 2360.07, 15.74 + 1, 12.0);
garage110 = CreatePickup(1318, 23, 1749.97, 2360.07, 15.74, 0);
}

stock Garagee111(playerid)
{
garage111d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 111\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1749.20, 2364.49, 15.74 + 1, 12.0);
garage111 = CreatePickup(1318, 23, 1749.20, 2364.49, 15.74, 0);
}

stock Garagee112(playerid)
{
garage112d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 112\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1786.67, 2339.79, 15.75 + 1, 12.0);
garage112 = CreatePickup(1318, 23, 1786.67, 2339.79, 15.75, 0);
}

stock Garagee113(playerid)
{
garage113d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 113\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1784.36, 2343.43, 15.76 + 1, 12.0);
garage113 = CreatePickup(1318, 23, 1784.36, 2343.43, 15.76, 0);
}

stock Garagee114(playerid)
{
garage114d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 114\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1781.94, 2347.18, 15.76 + 1, 12.0);
garage114 = CreatePickup(1318, 23, 1781.94, 2347.18, 15.76, 0);
}

stock Garagee115(playerid)
{
garage115d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 115\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1779.47, 2351.04, 15.76 + 1, 12.0);
garage115 = CreatePickup(1318, 23, 1779.47, 2351.04, 15.76, 0);
}

stock Garagee116(playerid)
{
garage116d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 116\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1777.10, 2354.74, 15.76 + 1, 12.0);
garage116 = CreatePickup(1318, 23, 1777.10, 2354.74, 15.76, 0);
}

stock Garagee117(playerid)
{
garage117d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 117\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1774.70, 2358.48, 15.76 + 1, 12.0);
garage117 = CreatePickup(1318, 23, 1774.70, 2358.48, 15.76, 0);
}

stock Garagee118(playerid)
{
garage118d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 118\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1772.29, 2362.25, 15.76 + 1, 12.0);
garage118 = CreatePickup(1318, 23, 1772.29, 2362.25, 15.76, 0);
}

stock Garagee119(playerid)
{
garage119d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 119\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1769.85, 2366.05, 15.76 + 1, 12.0);
garage119 = CreatePickup(1318, 23, 1769.85, 2366.05, 15.76, 0);
}

stock Garagee120(playerid)
{
garage120d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 120\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1767.46, 2369.79, 15.76 + 1, 12.0);
garage120 = CreatePickup(1318, 23, 1767.46, 2369.79, 15.76, 0);
}

stock Garagee121(playerid)
{
garage121d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 121\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1765.05, 2373.54, 15.77 + 1, 12.0);
garage121 = CreatePickup(1318, 23, 1765.05, 2373.54, 15.77, 0);
}

stock Garagee122(playerid)
{
garage122d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 122\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1762.62, 2377.33, 15.77 + 1, 12.0);
garage122 = CreatePickup(1318, 23, 1762.62, 2377.33, 15.77, 0);
}

stock Garagee123(playerid)
{
garage123d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 123\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1759.57, 2379.11, 15.76 + 1, 12.0);
garage123 = CreatePickup(1318, 23, 1759.57, 2379.11, 15.76, 0);
}

stock Garagee124(playerid)
{
garage124d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 124\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1755.00, 2379.11, 15.76 + 1, 12.0);
garage124 = CreatePickup(1318, 23, 1755.00, 2379.11, 15.76, 0);
}

stock Garagee125(playerid)
{
garage125d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 125\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1750.62, 2379.11, 15.76 + 1, 12.0);
garage125 = CreatePickup(1318, 23, 1750.62, 2379.11, 15.76, 0);
}

stock Garagee126(playerid)
{
garage126d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 126\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1746.18, 2379.11, 15.76 + 1, 12.0);
garage126 = CreatePickup(1318, 23, 1746.18, 2379.11, 15.76, 0);
}

stock Garagee127(playerid)
{
garage127d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 127\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1741.56, 2379.11, 15.76 + 1, 12.0);
garage127 = CreatePickup(1318, 23, 1741.56, 2379.11, 15.76, 0);
}

stock Garagee128(playerid)
{
garage128d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 128\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1737.16, 2379.11, 15.76 + 1, 12.0);
garage128 = CreatePickup(1318, 23, 1737.16, 2379.11, 15.76, 0);
}

stock Garagee129(playerid)
{
garage129d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 129\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1742.70, 2379.11, 15.76 + 1, 12.0);
garage129 = CreatePickup(1318, 23, 1742.70, 2379.11, 15.76, 0);
}

stock Garagee130(playerid)
{
garage130d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 130\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1728.34, 2379.11, 15.76 + 1, 12.0);
garage130 = CreatePickup(1318, 23, 1728.34, 2379.11, 15.76, 0);
}

stock Garagee131(playerid)
{
garage131d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 131\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1723.83, 2379.11, 15.76 + 1, 12.0);
garage131 = CreatePickup(1318, 23, 1723.83, 2379.11, 15.76, 0);
}

stock Garagee132(playerid)
{
garage132d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 132\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1719.31, 2379.11, 15.76 + 1, 12.0);
garage132 = CreatePickup(1318, 23, 1719.31, 2379.11, 15.76, 0);
}

stock Garagee133(playerid)
{
garage133d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 133\n{FFFFFF}Гараж продается", 0xFFFF00FF, 1714.81, 2379.11, 15.77 + 1, 12.0);
garage133 = CreatePickup(1318, 23, 1714.81, 2379.11, 15.77, 0);
}

stock Garagee134(playerid)
{
garage134d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 134\n{FFFFFF}Гараж продается", 0xFFFF00FF, -721.17, -1559.88, 41.32 + 1, 12.0);
garage134 = CreatePickup(1318, 23, -721.17, -1559.88, 41.32, 0);
}

stock Garagee135(playerid)
{
garage135d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 135\n{FFFFFF}Гараж продается", 0xFFFF00FF, -718.93, -1556.19, 41.33 + 1, 12.0);
garage135 = CreatePickup(1318, 23, -718.93, -1556.19, 41.33, 0);
}

stock Garagee136(playerid)
{
garage136d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 136\n{FFFFFF}Гараж продается", 0xFFFF00FF, -716.80, -1552.63, 41.33 + 1, 12.0);
garage136 = CreatePickup(1318, 23, -716.80, -1552.63, 41.33, 0);
}

stock Garagee137(playerid)
{
garage137d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 137\n{FFFFFF}Гараж продается", 0xFFFF00FF, -714.64, -1549.01, 41.33 + 1, 12.0);
garage137 = CreatePickup(1318, 23, -714.64, -1549.01, 41.33, 0);
}

stock Garagee138(playerid)
{
garage138d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 138\n{FFFFFF}Гараж продается", 0xFFFF00FF, -712.48, -1545.39, 41.33 + 1, 12.0);
garage138 = CreatePickup(1318, 23, -712.48, -1545.39, 41.33, 0);
}

stock Garagee139(playerid)
{
garage139d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 139\n{FFFFFF}Гараж продается", 0xFFFF00FF, -710.24, -1541.61, 41.33 + 1, 12.0);
garage139 = CreatePickup(1318, 23, -710.24, -1541.61, 41.33, 0);
}

stock Garagee140(playerid)
{
garage140d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 140\n{FFFFFF}Гараж продается", 0xFFFF00FF, -708.07, -1537.99, 41.32 + 1, 12.0);
garage140 = CreatePickup(1318, 23, -708.07, -1537.99, 41.32, 0);
}

stock Garagee141(playerid)
{
garage141d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 141\n{FFFFFF}Гараж продается", 0xFFFF00FF, -705.93, -1534.41, 41.32 + 1, 12.0);
garage141 = CreatePickup(1318, 23, -705.93, -1534.41, 41.32, 0);
}

stock Garagee142(playerid)
{
garage142d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 142\n{FFFFFF}Гараж продается", 0xFFFF00FF, -703.77, -1530.79, 41.32 + 1, 12.0);
garage142 = CreatePickup(1318, 23, -703.77, -1530.79, 41.32, 0);
}

stock Garagee143(playerid)
{
garage143d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 143\n{FFFFFF}Гараж продается", 0xFFFF00FF, -716.08, -1523.53, 41.32 + 1, 12.0);
garage143 = CreatePickup(1318, 23, -716.08, -1523.53, 41.32, 0);
}

stock Garagee144(playerid)
{
garage144d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 144\n{FFFFFF}Гараж продается", 0xFFFF00FF, -718.26, -1527.17, 41.32 + 1, 12.0);
garage144 = CreatePickup(1318, 23, -718.26, -1527.17, 41.32, 0);
}

stock Garagee145(playerid)
{
garage145d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 145\n{FFFFFF}Гараж продается", 0xFFFF00FF, -720.42, -1530.79, 41.32 + 1, 12.0);
garage145 = CreatePickup(1318, 23, -720.42, -1530.79, 41.32, 0);
}

stock Garagee146(playerid)
{
garage146d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 146\n{FFFFFF}Гараж продается", 0xFFFF00FF, -722.59, -1534.42, 41.32 + 1, 12.0);
garage146 = CreatePickup(1318, 23, -722.59, -1534.42, 41.32, 0);
}

stock Garagee147(playerid)
{
garage147d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 147\n{FFFFFF}Гараж продается", 0xFFFF00FF, -724.75, -1538.04, 41.32 + 1, 12.0);
garage147 = CreatePickup(1318, 23, -724.75, -1538.04, 41.32, 0);
}

stock Garagee148(playerid)
{
garage148d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 148\n{FFFFFF}Гараж продается", 0xFFFF00FF, -726.92, -1541.70, 41.32 + 1, 12.0);
garage148 = CreatePickup(1318, 23, -726.92, -1541.70, 41.32, 0);
}

stock Garagee149(playerid)
{
garage149d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 149\n{FFFFFF}Гараж продается", 0xFFFF00FF, -729.00, -1545.18, 41.31 + 1, 12.0);
garage149 = CreatePickup(1318, 23, -729.00, -1545.18, 41.31, 0);
}

stock Garagee150(playerid)
{
garage150d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 150\n{FFFFFF}Гараж продается", 0xFFFF00FF, -731.31, -1549.04, 41.31 + 1, 12.0);
garage150 = CreatePickup(1318, 23, -731.31, -1549.04, 41.31, 0);
}

stock Garagee151(playerid)
{
garage151d = CreateDynamic3DTextLabel("{FFFF00}Гараж № 151\n{FFFFFF}Гараж продается", 0xFFFF00FF, -733.43, -1552.59, 41.32 + 1, 12.0);
garage151 = CreatePickup(1318, 23, -733.43, -1552.59, 41.32, 0);
}





	if(pickupid == garage1)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY1, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 1\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}
	
	if(pickupid == garage2)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY2, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 2\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage3)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY3, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 3\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage4)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY4, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 4\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage5)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY5, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 5\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage6)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY6, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 6\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}


	if(pickupid == garage7)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY7, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 7\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage8)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY8, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 8\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage9)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY9, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 9\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage10)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY10, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 10\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}


	if(pickupid == garage11)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY11, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 11\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage12)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY12, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 12\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage13)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY13, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 13\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage14)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY14, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 14\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage15)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY15, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 15\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage16)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY16, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 16\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage17)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY17, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 17\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage18)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY18, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 18\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage19)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY19, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 19\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage20)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY20, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 20\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage21)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY21, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 21\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage22)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY22, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 22\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage23)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY23, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 23\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage24)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY24, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 24\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage25)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY25, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 25\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage26)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY26, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 26\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage27)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY27, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 27\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage28)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY28, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 28\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage29)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY29, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 29\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage30)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY30, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 30\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage31)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY31, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 31\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage32)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY32, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 32\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage33)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY33, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 33\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage34)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY34, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 34\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage35)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY35, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 35\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage36)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY36, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 36\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage37)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY37, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 37\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage38)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY38, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 38\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage39)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY39, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 39\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage40)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY40, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 40\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage41)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY41, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 41\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage42)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY42, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 42\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage43)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY43, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 43\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage44)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY44, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 44\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage45)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY45, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 45\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage46)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY46, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 46\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage47)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY47, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 47\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage48)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY48, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 48\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage49)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY49, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 49\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage50)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY50, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 50\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage51)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY51, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 51\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage52)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY52, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 52\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage53)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY53, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 53\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage54)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY54, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 54\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage55)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY55, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 55\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage56)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY56, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 56\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage57)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY57, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 57\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage58)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY58, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 58\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage59)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY59, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 59\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage60)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY60, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 60\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage61)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY61, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 61\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage62)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY62, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 62\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage63)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY63, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 63\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage64)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY64, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 64\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage65)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY65, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 65\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage66)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY66, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 66\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage67)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY67, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 67\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage68)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY68, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 68\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage69)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY69, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 69\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage70)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY70, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 70\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage71)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY71, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 71\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage72)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY72, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 72\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage73)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY73, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 73\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage74)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY74, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 74\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage75)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY75, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 75\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage76)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY76, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 76\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage77)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY77, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 77\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage78)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY78, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 78\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage79)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY79, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 70\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage80)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY80, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 80\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage81)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY81, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 81\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}
	
	if(pickupid == garage82)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY82, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 82\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage83)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY83, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 83\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage84)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY84, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 84\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage85)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY85, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 85\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage86)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY86, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 86\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage87)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY87, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 87\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage88)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY88, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 88\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage89)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY89, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 89\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage90)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY90, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 90\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage91)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY91, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 91\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage92)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY92, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 92\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage93)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY93, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 93\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage94)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY94, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 94\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage95)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY95, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 95\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage96)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY96, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 96\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}
	
	if(pickupid == garage97)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY97, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 97\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage98)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY98, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 98\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage99)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY99, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 99\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage100)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY100, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 100\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage101)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY101, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 101\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage102)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY102, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 102\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage103)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY103, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 103\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage104)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY104, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 104\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage105)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY105, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 105\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage106)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY106, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 106\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage107)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY107, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 107\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage108)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY108, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 108\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage109)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY109, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 109\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage110)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY110, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 110\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage111)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY111, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 111\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage112)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY112, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 112\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage113)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY113, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 113\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage114)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY114, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 114\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage115)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY115, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 115\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage116)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY116, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 116\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage117)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY117, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 117\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage118)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY118, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 118\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage119)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY119, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 119\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage120)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY120, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 120\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage121)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY121, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 121\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage122)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY122, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 122\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage123)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY123, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 123\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage124)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY124, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 124\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage125)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY125, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 125\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage126)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY126, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 126\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage127)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY127, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 127\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage128)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY128, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 128\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage129)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY129, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 129\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage130)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY130, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 130\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage131)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY131, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 131\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage132)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY132, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 132\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage133)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY133, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 133\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}
	
	if(pickupid == garage134)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY134, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 134\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage135)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY135, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 135\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage136)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY136, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 136\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}
	
	if(pickupid == garage137)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY137, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 137\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage138)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY138, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 138\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage139)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY139, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 139\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage140)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY140, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 140\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage141)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY141, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 141\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage142)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY142, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 142\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage143)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY143, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 143\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage144)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY144, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 144\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage145)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY145, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 145\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage146)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY146, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 146\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage147)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY147, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 147\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage148)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY148, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 148\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage149)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY149, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 149\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage150)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY150, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 150\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}

	if(pickupid == garage151)
	{
	Dialog
	(
		playerid, DIALOG_GARAGE_BUY151, DIALOG_STYLE_MSGBOX,
		"{8B0000}Покупка гаража",
		"Номер гаража: 151\nСтоимость: 500000 рублей",
		"Купить", "Отменить"
	);
	}
	
	if(pickupid == garage1BUY)
	{
		{
    		SetPlayerPos(playerid, 1.716,1999.725,1554.203);
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, 1);
    		return 1;
		}
	}
	
	
	
    if (dialogid == DIALOG_GARAGE_BUY1) {
        if (response == 1) {
            if (GetPlayerMoney(playerid) >= GARAGE_PRICE) {
                GivePlayerMoney(playerid, -GARAGE_PRICE);

                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Поздравляем с покупкой. Используйте /garage для взаимодействия");
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Теперь Вам нужно поехать в банк и оплатить проживание в гараже, в ином случае Вас автоматически выселят");

                DestroyPickup(garage1);
                DestroyDynamic3DTextLabel(garage1d);

				garage1dBUY = CreateDynamic3DTextLabel("{FFFF00}Гараж № 1\n{FFFFFF}Гараж продается", 0xFFFF00FF, 2571.70, -1874.21, 21.96 + 1, 12.0);
				garage1BUY = CreatePickup(1318, 23, 2571.70, -1874.21, 21.96, 0);

                SetPlayerPos(playerid, 1.716,1999.725,1554.203);
                SetPlayerVirtualWorld(playerid, 1);
                SetPlayerInterior(playerid, 1);

				Buygarage[playerid] = true;

				ShowNotification(playerid, 1, "Вы потратили 500000 рублей", 3, "", "");
            } else {
                SendClientMessage(playerid, COLOR_RED, "У вас недостаточно средств");
            }
        }

    }
