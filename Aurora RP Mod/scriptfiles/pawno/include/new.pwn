#include 																		a_samp
#include                                                                        streamer

#define DIALOG_QUEST                                                            30000
enum E_USER_DATA
{
	EXP,
	SNOW,
	GAME,
	MONEY,
}
new UserData[MAX_PLAYERS][E_USER_DATA];

enum E_QUEST_DATA
{
	ID,
	STATE,
	RANDOM,
	PROGRESS,
	TIME_LOCK,
}
new QuestData[MAX_PLAYERS][E_QUEST_DATA];

static const ReasonCompleteDialog[][] = {
	"шампанского бокал",
	"новый год",
	"новогодние игрушки",
	"игрушки",
	"снегопад",
	"метель",
	"мороз",
	"снег",
	"маскарад",
	"шампанское",
	"новый год",
	"гирлянда",
	"ананас",
	"носком",
	"телевизор",
	"снежинки",
	"снег",
	"верхушку",
	"гороскоп",
	"дед мороз",
	"зимы",
	"подарки",
	"мороз",
	"дед мороз",
	"новый год",
	"снег",
	"олень",
	"дед мороз",
	"гости",
	"новый год",
	"гирлянда",
	"дед мороз",
	"снегурочка",
	"дед мороз",
	"елка",
	"дед мороз",
	"елка",
	"елка",
	"чудо",
	"елка"
};
			
new PickupSnow[84];
new VehicleGame[5];
new VehicleOlen[5];
new STRING_GLOBAL[2048];
new PlayerTextTime[MAX_PLAYERS];
new PlayerQuestCar[MAX_VEHICLES];
new PickupPlayerGame[MAX_PLAYERS];
new PickupPodarok[MAX_PLAYERS][22];
new PlayerVehicleQuest[MAX_PLAYERS];
new PlayerPickupOlen[MAX_PLAYERS][26];
new PlayerQuestObject[MAX_PLAYERS][13];
new PlayerText3D: PlayerTextBot[MAX_PLAYERS];

public OnGameModeInit()
{
    #include                                                                    exterior_object
    
    VehicleGame[0] = CreateVehicle(578, 1089.5916, -294.3832, 74.5192, 176.7837, 1, 1, 300);
	VehicleGame[1] = CreateVehicle(578, 1083.4821, -294.0134, 74.5868, 176.7991, 1, 1, 300);
	VehicleGame[2] = CreateVehicle(578, 1059.1951, -294.3332, 74.5819, 269.0601, 1, 1, 300);
	VehicleGame[3] = CreateVehicle(578, 1059.1913, -299.1820, 74.5836, 269.5823, 1, 1, 300);
	VehicleGame[4] = CreateVehicle(578, 1059.2391, -304.6786, 74.5870, 270.7324, 1, 1, 300);

    VehicleOlen[0] = CreateVehicle(578, 1115.1644, -333.1797, 74.5813, 89.7038, 1, 1, 300);
	VehicleOlen[1] = CreateVehicle(578, 1099.6776, -332.9792, 74.5829, 88.1910, 1, 1, 300);
	VehicleOlen[2] = CreateVehicle(578, 1086.6157, -327.6982, 74.5859, 89.9286, 1, 1, 300);
	VehicleOlen[3] = CreateVehicle(578, 1086.6108, -322.4204, 74.5844, 89.5354, 1, 1, 300);
	VehicleOlen[4] = CreateVehicle(578, 1086.6907, -316.7986, 74.5864, 89.5913, 1, 1, 300);
	
    Create3DTextLabel("Снеговик\n\n{CCCCCC}Для взаимодействия используйте\n{00FF00}L.ALT", 0x00FF00FF, 1489.1440, -1725.0293, 13.3038, 5.0, 0, 0);
    Create3DTextLabel("Снеговик\n\n{CCCCCC}Для взаимодействия используйте\n{00FF00}L.ALT", 0x00FF00FF, 1469.5425, -1724.8444, 13.3038, 5.0, 0, 0);
    
    Create3DTextLabel("Торговец\n\n{CCCCCC}Для взаимодействия используйте\n{00FF00}L.ALT", 0x00FF00FF, 1444.3473, -1701.4098, 13.3038, 5.0, 0, 0);
    Create3DTextLabel("Торговец\n\n{CCCCCC}Для взаимодействия используйте\n{00FF00}L.ALT", 0x00FF00FF, 1450.3641, -1691.2615, 13.3038, 5.0, 0, 0);
    
    Create3DTextLabel("Санта\n\n{CCCCCC}Для взаимодействия используйте\n{00FF00}L.ALT", 0x00FF00FF, 1478.9650, -1702.9823, 13.3038, 5.0, 0, 0);

    CreateActor(26, 1448.6233, -1691.2485, 13.3038, 270.0000);
	CreateActor(26, 1444.3120, -1699.6689, 13.3038, 180.0000);
	return 0x1;
}



public OnPlayerConnect(playerid)
{
    QuestData[playerid][ID] = 0;
    PlayerTextTime[playerid] = 0;
    PlayerVehicleQuest[playerid] = 0xFFFF;
   	PlayerTextBot[playerid] = PlayerText3D:0xFFFF;
   	QuestData[playerid][STATE] = 0;
	QuestData[playerid][PROGRESS] = 1;
    #include                                                                    remove_object
	return 0x1;
}


public OnPlayerUpdate(playerid)
{
	if(PlayerTextBot[playerid] != PlayerText3D:0xFFFF && PlayerTextTime[playerid] < gettime())
	{
		if(QuestData[playerid][ID] == 0 && QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == 2)
		{
			DeletePlayer3DTextLabel(playerid, PlayerTextBot[playerid]);
			PlayerTextBot[playerid] = PlayerText3D:0xFFFF;
			
			SendBotMessage(playerid, "Возрощайся ко мне через 3 часа, я подготовлю для тебя задание", 3);
			QuestData[playerid][TIME_LOCK] = gettime() + 10800;
			QuestData[playerid][PROGRESS] = 3;
			QuestData[playerid][STATE] = 1;
		}
		if(QuestData[playerid][ID] == 1 && QuestData[playerid][STATE] == 2 && QuestData[playerid][PROGRESS] == 2)
		{
		    DeletePlayer3DTextLabel(playerid, PlayerTextBot[playerid]);
		    PlayerTextBot[playerid] = PlayerText3D:0xFFFF;
		    
		    SendBotMessage(playerid, "Возрощайся ко мне через 3 часа, я подготовлю для тебя задание", 3);
			QuestData[playerid][TIME_LOCK] = gettime() + 10800;
			QuestData[playerid][PROGRESS] = 3;
			QuestData[playerid][STATE] = 3;
		}
		if(QuestData[playerid][ID] == 2 && QuestData[playerid][STATE] == 2 && QuestData[playerid][PROGRESS] == 2)
		{
		    SendBotMessage(playerid, "Возрощайся ко мне через 3 часа, я подготовлю для тебя новое задание", 3);
			QuestData[playerid][TIME_LOCK] = gettime() + 10800;
			QuestData[playerid][PROGRESS] = 3;
			QuestData[playerid][STATE] = 3;
		}
		if(QuestData[playerid][ID] == 3 && QuestData[playerid][PROGRESS] == 555)
		{
		    QuestData[playerid][PROGRESS] = QuestData[playerid][RANDOM] = random(10) + 1;
		    ShowDialogQuest(playerid, QuestData[playerid][PROGRESS]);
		}
		if(QuestData[playerid][ID] == 3 && QuestData[playerid][STATE] == 2)
		{
		    SendBotMessage(playerid, "Возрощайся ко мне через 3 часа, я подготовлю для тебя новое задание", 3);
		    QuestData[playerid][TIME_LOCK] = gettime() + 10800;
			QuestData[playerid][STATE] = 3;
		}
		if(QuestData[playerid][ID] == 4 && QuestData[playerid][STATE] == 2)
		{
		    SendBotMessage(playerid, "Возрощайся ко мне через 3 часа, я подготовлю для тебя новое задание", 3);
		    QuestData[playerid][TIME_LOCK] = gettime() + 10800;
			QuestData[playerid][STATE] = 3;
		}
		if(QuestData[playerid][ID] == 5 && QuestData[playerid][STATE] == 4)
		{
		    SendBotMessage(playerid, "Возрощайся ко мне через 3 часа, я подготовлю для тебя новое задание", 3);
		    QuestData[playerid][TIME_LOCK] = gettime() + 10800;
			QuestData[playerid][STATE] = 5;
		}
		if(QuestData[playerid][ID] == 6 && QuestData[playerid][STATE] == 3)
		{
		    SendBotMessage(playerid, "Возрощайся ко мне через 3 часа, я подготовлю для тебя новое задание", 3);
		    QuestData[playerid][TIME_LOCK] = gettime() + 10800;
			QuestData[playerid][STATE] = 4;
		}
		else
		{
		    DeletePlayer3DTextLabel(playerid, PlayerTextBot[playerid]);
		    PlayerTextBot[playerid] = PlayerText3D:0xFFFF;
		}
	}
	return 0x1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(strcmp("/test", cmdtext, true) == 0x0)
	{
		QuestData[playerid][ID] = 5;
	    QuestData[playerid][STATE] = 0;
		QuestData[playerid][PROGRESS] = 0;
	    return 0x1;
	}
	if(strcmp("/test1", cmdtext, true) == 0x0)
	{
	    QuestData[playerid][STATE] = 1;
	    QuestData[playerid][PROGRESS] = 1;
     	SendClientMessage(playerid, -1, !"Вы добыли ель, теперь отправляйтесь к снеговику или что то типо того");
	}
	if(strcmp("/newyear", cmdtext, true, 10) == 0x0)
	{
	    STRING_GLOBAL[0] = EOS;
	    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{CCCCCC}<< Марафон Новый Год >>\n\nСнежинки: {00FF00}%d\n{CCCCCC}Игрушки: {00FF00}%d", UserData[playerid][SNOW], UserData[playerid][GAME]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !" ", STRING_GLOBAL, !"Скрыть", !"");
		return 0x1;
	}
	return 0x0;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid, 1482.0000, -1739.0000, 13.5000);
	SetPlayerFacingAngle(playerid, 360.0000);
	return 0x1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(pickupid == PickupPlayerGame[playerid])
	{
		QuestData[playerid][STATE] = 1;
		QuestData[playerid][PROGRESS] = 1;
		DestroyDynamicPickup(PickupPlayerGame[playerid]);
		SendClientMessage(playerid, 0xFFFF00FF, !"[Мысли]: {CCCCCC}Кажется я нашел игрушку с ёлки");
		return 0x1;
	}
	if(pickupid >= PickupPodarok[playerid][0] && PickupPodarok[playerid][21] >= pickupid)
	{
	    for(new i = 0; i != 21; i ++)
	    {
	        if(PickupPodarok[playerid][i] == pickupid)
	        {
	        	QuestData[playerid][PROGRESS] ++;
				DestroyDynamicPickup(PickupPodarok[playerid][i]);
				
				switch(QuestData[playerid][PROGRESS])
				{
				    case 2:
					{
						PlayerQuestObject[playerid][0] = CreateDynamicObject(19055,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1, playerid,300.0,300.0);
    					AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][0], PlayerVehicleQuest[playerid], 0.419, 0.927, 0.390, 0.000, 0.000, -36.600);
					}
					case 6:
					{
					    PlayerQuestObject[playerid][1] = CreateDynamicObject(19056,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1, playerid,300.0,300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][1], PlayerVehicleQuest[playerid], -0.420, -0.370, 0.380, 0.000, 0.000, 0.000);
					}
					case 10:
					{
					    PlayerQuestObject[playerid][2] = CreateDynamicObject(19054,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1, playerid, 300.0,300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][2], PlayerVehicleQuest[playerid], 0.564, -1.765, 0.380, 0.000, 0.000, 17.700);
					}
					case 15:
					{
					    PlayerQuestObject[playerid][3] = CreateDynamicObject(19057,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1, playerid,300.0,300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][3], PlayerVehicleQuest[playerid], -0.540, -3.191, 0.300, 0.000, 0.000, 8.999);
					}
					case 20:
					{
					    PlayerQuestObject[playerid][4] = CreateDynamicObject(19058,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1, playerid,300.0,300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][4], PlayerVehicleQuest[playerid], 0.308, -4.632, 0.350, 0.000, 0.000, 15.300);
                    }

				}
				if(QuestData[playerid][PROGRESS] == 23)
				{
				    SendClientMessage(playerid, 0xFFFF00FF, !"[Мысли]: {CCCCCC}Кажется я собрал все подарки, надо отвезти теперь их на место");
				    SetPlayerCheckpoint(playerid, 1060.4400, -340.5300, 73.9900, 3.0);
				    QuestData[playerid][STATE] = 2;
				    return 0x1;
				}
				if(QuestData[playerid][PROGRESS] < 23)
				{
				    STRING_GLOBAL[0] = EOS;
				    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Подарков собрано: %d/22", QuestData[playerid][PROGRESS] - 1);
				    SendClientMessage(playerid, 0x00FF00FF, STRING_GLOBAL);
				    return 0x1;
				}
	        }
	    }
	}
	if(pickupid >= PlayerPickupOlen[playerid][0] && PlayerPickupOlen[playerid][25] >= pickupid)
	{
	    for(new i = 0; i != 25; i ++)
	    {
	        if(PlayerPickupOlen[playerid][i] == pickupid)
	        {
	        	QuestData[playerid][PROGRESS] ++;
				DestroyDynamicPickup(PlayerPickupOlen[playerid][i]);

				switch(QuestData[playerid][PROGRESS])
				{
					case 3:
					{
					    PlayerQuestObject[playerid][0] = CreateDynamicObject(997,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][0], PlayerVehicleQuest[playerid], -1.591, -5.532, -0.240, 0.000, 0.000, 0.000);
					}
					case 5:
					{
						PlayerQuestObject[playerid][1] = CreateDynamicObject(997,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][1], PlayerVehicleQuest[playerid], -1.530, -2.326, -0.260, 0.000, 0.000, -90.199);
					}
					case 7:
					{
					    PlayerQuestObject[playerid][2] = CreateDynamicObject(997,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][2], PlayerVehicleQuest[playerid], -1.509, 0.762, -0.250, 0.000, 0.000, -90.399);
					}
					case 9:
					{
					    PlayerQuestObject[playerid][3] = CreateDynamicObject(997,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][3], PlayerVehicleQuest[playerid], -1.504, -0.830, -0.250, 0.000, 0.000, 89.999);
					}
					case 11:
					{
					    PlayerQuestObject[playerid][4] = CreateDynamicObject(997,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][4], PlayerVehicleQuest[playerid], 1.543, -2.362, -0.270, 0.000, 0.000, -89.599);
					}
					case 13:
					{
					    PlayerQuestObject[playerid][5] = CreateDynamicObject(997,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][5], PlayerVehicleQuest[playerid], 1.538, 0.702, -0.260, 0.000, 0.000, -89.799);
					}
					case 15:
					{
					    PlayerQuestObject[playerid][6] = CreateDynamicObject(997,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][6], PlayerVehicleQuest[playerid], 1.475, 2.399, -0.250, 0.000, 0.000, -88.900);
					}
					case 16:
					{
					    PlayerQuestObject[playerid][7] = CreateDynamicObject(19315,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][7], PlayerVehicleQuest[playerid], 0.000, 1.431, 0.170, 0.000, 0.000, -20.300);
					}
					case 18:
					{
					    PlayerQuestObject[playerid][8] = CreateDynamicObject(19315,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][8], PlayerVehicleQuest[playerid], 0.860, 0.000, 0.150, 0.000, 0.000, 0.000);
					}
					case 20:
					{
					    PlayerQuestObject[playerid][9] = CreateDynamicObject(19315,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][9], PlayerVehicleQuest[playerid], -0.919, -1.042, 0.180, 0.000, 0.000, 151.399);
					}
					case 21:
					{
					    PlayerQuestObject[playerid][10] = CreateDynamicObject(19315,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][10], PlayerVehicleQuest[playerid], 0.000, -2.190, 0.160, 0.000, 0.000, -92.199);
					}
					case 23:
					{
					    PlayerQuestObject[playerid][11] = CreateDynamicObject(19315,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][11], PlayerVehicleQuest[playerid], -0.846, -4.655, 0.180, 0.000, 0.000, -124.599);
					}
					case 25:
					{
					    PlayerQuestObject[playerid][12] = CreateDynamicObject(19315,0.0,0.0,-1000.0,0.0,0.0,0.0, -1, -1, playerid, 300.0, 300.0);
					    AttachDynamicObjectToVehicle(PlayerQuestObject[playerid][12], PlayerVehicleQuest[playerid], 0.766, -3.859, 0.180, 0.000, 0.000, -16.599);
					}

				}
				if(QuestData[playerid][PROGRESS] == 25)
				{
				    SendClientMessage(playerid, 0xFFFF00FF, !"[Мысли]: {CCCCCC}Кажется я собрал всех оленей, надо отвезти теперь их на место");
				    SetPlayerCheckpoint(playerid, -1412.5558, -944.5644, 200.9861, 3.0);
				    QuestData[playerid][STATE] = 1;
				    return 0x1;
				}
				if(QuestData[playerid][PROGRESS] < 25)
				{
				    STRING_GLOBAL[0] = EOS;
				    format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Оленей собрано: %d/25", QuestData[playerid][PROGRESS]);
				    SendClientMessage(playerid, 0x00FF00FF, STRING_GLOBAL);
				    return 0x1;
				}
	        }
	    }
	}
	return 0x1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(QuestData[playerid][ID] == 5 && QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] >= 22)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1060.4400, -340.5300, 73.9900) == 1)
		{
		    QuestData[playerid][STATE] = 2;
		    DisablePlayerCheckpoint(playerid);
			RemovePlayerFromVehicle(playerid);
			for(new i = 0; i != 4; i ++)
			{
				DestroyDynamicObject(PlayerQuestObject[playerid][i]);
			}
			PlayerQuestCar[PlayerVehicleQuest[playerid]] = -1;
			SetVehicleToRespawn(PlayerVehicleQuest[playerid]);
			PlayerVehicleQuest[playerid] = 0xFFFF;
	        SendClientMessage(playerid, 0xFFFF00FF, !"[Мысли]: {CCCCCC}Теперь самое время навестить санту");
		    return 0x1;
		}
	}
	if(QuestData[playerid][ID] == 6 && QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == 25)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, -1412.5558, -944.5644, 200.9861) == 1)
		{
		    QuestData[playerid][STATE] = 3;
		    DisablePlayerCheckpoint(playerid);
			RemovePlayerFromVehicle(playerid);
			for(new i = 0; i != 12; i ++)
			{
				DestroyDynamicObject(PlayerQuestObject[playerid][i]);
			}
			PlayerQuestCar[PlayerVehicleQuest[playerid]] = -1;
			SetVehicleToRespawn(PlayerVehicleQuest[playerid]);
			PlayerVehicleQuest[playerid] = 0xFFFF;
	        SendClientMessage(playerid, 0xFFFF00FF, !"[Мысли]: {CCCCCC}Теперь самое время навестить санту");
		}
	}
	return 0x1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid >= PickupSnow[0] && PickupSnow[83] >= pickupid)
	{
		UserData[playerid][GAME] ++;
		SendClientMessage(playerid, 0xFFFF00FF, !"Вами была найдена игрушка для новогодней елки");

        STRING_GLOBAL[0] = EOS;
		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Всего игрушек в наличие: %d", UserData[playerid][GAME]);
		SendClientMessage(playerid, 0xFFFF00FF, STRING_GLOBAL);
		return 0x1;
	}
	return 0x1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_WALK)  // Cнеговики
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 1489.1440, -1725.0293, 13.3038) == 1 || IsPlayerInRangeOfPoint(playerid, 2.0, 1469.5425, -1724.8444, 13.3038) == 1)
	    {
			if(QuestData[playerid][ID] == 0)
			{
				if(QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == 1)
				{
					SendBotMessage(playerid, "Ну что же, начнем наше приключение", 3);
					QuestData[playerid][PROGRESS] = 2;
					QuestData[playerid][STATE] = 1;
					QuestData[playerid][ID] = 0;
					return 0x1;
				}
				if(QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == 3)
				{
				    if(QuestData[playerid][TIME_LOCK] > gettime())
				    {
				        SendBotMessage(playerid, "Задания для тебя еще не готово, возращайся позже", 3);
				        return 0x1;
				    }
				    if(QuestData[playerid][TIME_LOCK] < gettime())
				    {
				        QuestData[playerid][ID] = 1;
						QuestData[playerid][STATE] = 0;
					    QuestData[playerid][PROGRESS] = 0;
				        
				        STRING_GLOBAL[0] = EOS;
                        strcat(STRING_GLOBAL, "Привет! Ты когда-нибудь видел настоящих говорящих снеговиков? А я вот именно такой!\n");
						strcat(STRING_GLOBAL, "Серьёзно, без шуток, в Новый год и не такие чудеса возможны!\n");
						strcat(STRING_GLOBAL, "Ладно, что-то я всё о себе, да о себе.\n");
						strcat(STRING_GLOBAL, "У меня будет поручение для тебя от главного волшебника этого удивительного морозного праздника – Санта-Клауса!\n");
						strcat(STRING_GLOBAL, "Нам срочно нужна ель, не очень большая, но и не маленькая, не спрашивай для чего, просто нужна.\n");
						strcat(STRING_GLOBAL, "Тебе нужно как можно скорее срубить её и доставить мне, а я подарю тебе самый настоящий новогодний подарок!\n");
						strcat(STRING_GLOBAL, "По рукам?\n");
						ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"В лесу родилась..", STRING_GLOBAL, !"Принять", !"");
						return 0x1;
				    }
				}
			}
			if(QuestData[playerid][ID] == 1)
			{
			    if(QuestData[playerid][STATE] == 0 && QuestData[playerid][PROGRESS] == 0)
			    {
			        SendBotMessage(playerid, "Приходи ко мне когда добудешь елку", 3);
			        return 0x1;
			    }
				if(QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == 1)
				{
				    SendBotMessage(playerid, "Ого! Это именно та ель, которая нам нужна! Не очень большая, но и не маленькая, спасибо тебе! Вот тебе за это", 4);
                    UserData[playerid][EXP] += 3;
                    UserData[playerid][SNOW] += 3;
					QuestData[playerid][STATE] = 2;
					UserData[playerid][MONEY] += 5000;
				    QuestData[playerid][PROGRESS] = 2;
				    return 0x1;
				}
				if(QuestData[playerid][STATE] == 3 && QuestData[playerid][PROGRESS] == 3)
				{
				    if(QuestData[playerid][TIME_LOCK] > gettime())
				    {
				        SendBotMessage(playerid, "Задания для тебя еще не готово, возращайся позже", 3);
				        return 0x1;
				    }
					if(QuestData[playerid][TIME_LOCK] < gettime())
					{
					    STRING_GLOBAL[0] = EOS;
					    strcat(STRING_GLOBAL, "О, снова ты! Я тут уже таять немного начал, пока ждал кого-нибудь, ух, переволновался.\n");
						strcat(STRING_GLOBAL, "Санта уже старенький, иногда что-то забудет, иногда потеряет и не заметит...\n");
						strcat(STRING_GLOBAL, "Так вот, во время своего последнего путешествия с оленями и санями, он умудрился растерять большое количество новогодних игрушек для ёлки по городу!\n");
						strcat(STRING_GLOBAL, "Эльфы заняты приготовлением подарков, а я тут стоять должен и приносить радость людям, даря новогоднее настроение, можешь помочь мне с поиском этих самых ёлочных игрушек?");
						ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"Нарядная, на праздник к нам пришла...", STRING_GLOBAL, !"Скрыть", !"");
						
						QuestData[playerid][ID] = 2;
						QuestData[playerid][STATE] = 0;
						QuestData[playerid][PROGRESS] = 0;
						PickupPlayerGame[playerid] = CreateDynamicPickup(19059, 23, 1512.1938, -1658.8248, 13.4357, -1, -1, playerid);
					}
				}
			}
			if(QuestData[playerid][ID] == 2)
			{
			    if(QuestData[playerid][STATE] == 0 && QuestData[playerid][PROGRESS] == 0)
			    {
			        SendBotMessage(playerid, "Приходи ко мне когда найдешь игрушку, говорят видели ее неподалеку от ёлки", 3);
			        return 0x1;
			    }
			    if(QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == 1)
			    {
			        SendBotMessage(playerid, "Честно, я не знаю чтобы делал без тебя! Ты нашел все утерянные игрушки, спасибо! Вот тебе за это", 3);
			        QuestData[playerid][PROGRESS] = 2;
					UserData[playerid][MONEY] += 5000;
					QuestData[playerid][STATE] = 2;
					UserData[playerid][SNOW] += 3;
					UserData[playerid][EXP] += 3;
					return 0x1;
			    }
			    if(QuestData[playerid][STATE] == 3 && QuestData[playerid][PROGRESS] == 3)
			    {
					if(QuestData[playerid][TIME_LOCK] > gettime())
				    {
				        SendBotMessage(playerid, "Задания для тебя еще не готово, возращайся позже", 3);
				        return 0x1;
				    }
					if(QuestData[playerid][TIME_LOCK] < gettime())
					{
						QuestData[playerid][ID] = 3;
						QuestData[playerid][STATE] = 0;
						QuestData[playerid][PROGRESS] = 0;
						
					    STRING_GLOBAL[0] = EOS;
					    strcat(STRING_GLOBAL, "Ух... Как же я проголодался, вот бы кто-нибудь принёс мне ледяное молоко и хотя бы кусочек печенья\n");
					    strcat(STRING_GLOBAL, "Отправляйся к торговцам которые стоят у прилавка за поездом.");
						ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"Угощение для снеговика", STRING_GLOBAL, !"Скрыть", !"");
						return 0x1;
					}
			    }
			}
			if(QuestData[playerid][ID] == 3)
			{
			    if(QuestData[playerid][STATE] == 0 && QuestData[playerid][PROGRESS] != (QuestData[playerid][RANDOM] * 5))
			    {
			        SendBotMessage(playerid, "Приходи ко мне когда раздабудешь ледяное молоко и печенье для меня у торговцев", 3);
			        return 0x1;
			    }
				if(QuestData[playerid][STATE] == 1 && QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == (QuestData[playerid][RANDOM] * 5))
				{
				    UserData[playerid][EXP] += 3;
                    UserData[playerid][SNOW] += 3;
					QuestData[playerid][STATE] = 2;
					UserData[playerid][MONEY] += 5000;
				    SendBotMessage(playerid, "Ничего себе, я не ожидал от тебя такого! Спасибо, наконец-то я устрою перекус! Вот тебе моя благодарность", 3);
				    return 0x1;
				}
				if(QuestData[playerid][STATE] == 3)
				{
				    if(QuestData[playerid][TIME_LOCK] > gettime())
				    {
				        SendBotMessage(playerid, "Задания для тебя еще не готово, возращайся позже", 3);
				        return 0x1;
				    }
				    if(QuestData[playerid][TIME_LOCK] < gettime())
					{
						QuestData[playerid][ID] = 4;
						QuestData[playerid][STATE] = 0;
						QuestData[playerid][PROGRESS] = 0;
						ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"Шарлотка", !"Мне так понравилось твое угощение, что я хочу попросить тебя об одном одолжении...\nСможешь достать мне яблочную шарлотку, я готов дать тебе за неё", !"Скрыть", !"");
						return 0x1;
					}
				}
			}
			if(QuestData[playerid][ID] == 4)
			{
			    if(QuestData[playerid][STATE] == 0 && QuestData[playerid][PROGRESS] == 0)
			    {
			        SendBotMessage(playerid, "Возращайся ко мне, как раздабудешь яблочную шарлотку", 3);
					return 0x1;
			    }
				if(QuestData[playerid][STATE] == 1 && QuestData[playerid][PROGRESS] == 5)
				{
				    SendBotMessage(playerid, "Как вкусно пахнет! Срочно менять шарлотку на", 3);
				    UserData[playerid][MONEY] += 5000;
				    QuestData[playerid][STATE] = 2;
				    UserData[playerid][SNOW] += 3;
					UserData[playerid][EXP] += 3;
					return 0x1;
				}
				if(QuestData[playerid][STATE] == 3)
				{
				    if(QuestData[playerid][TIME_LOCK] > gettime())
				    {
				        SendBotMessage(playerid, "Задания для тебя еще не готово, возращайся позже", 3);
				        return 0x1;
				    }
					if(QuestData[playerid][TIME_LOCK] < gettime())
					{
					    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"Здравствуй, дедушка..", !"Я рассказал Санте о тебе, о твоих добрых делах и он захотел лично встретиться с тобой, говорит, что у него есть новогоднее задание для тебя, не упусти свой шанс!", !"Скрыть", !"");
						QuestData[playerid][PROGRESS] = 0;
						QuestData[playerid][STATE] = 0;
						QuestData[playerid][ID] = 5;
						return 0x1;
					}
				}
			}
			if(QuestData[playerid][ID] == 5)
			{
			    SendBotMessage(playerid, "Привет еще раз, у санты есть задания для тебя.", 3);
				return 0x1;
			}
	    }
	}
	if(newkeys == KEY_WALK) // Торговцы
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1444.3473, -1701.4098, 13.3038) == 1 || IsPlayerInRangeOfPoint(playerid, 3.0, 1450.3641, -1691.2615, 13.3038) == 1)
		{
			if(QuestData[playerid][ID] == 3 && QuestData[playerid][STATE] == 0)
			{
                SendBotMessage(playerid, "Привет, я знаю зачем ты ко мне пришел, но тебе придется отгадать мои загадки", 3);
				QuestData[playerid][PROGRESS] = 555;
			    return 0x1;
			}
			if(QuestData[playerid][ID] != 2 && QuestData[playerid][PROGRESS] != 1)
			{
			    // Продажа игрушек и снежинок
			    return 0x1;
			}
		    return 0x1;
		}
	}
	if(newkeys == KEY_WALK) // Санта
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1478.9650,-1702.9823,13.3038) == 1)
		{
			if(QuestData[playerid][ID] == 5)
			{
			    if(QuestData[playerid][STATE] == 0 && QuestData[playerid][PROGRESS] == 0)
			    {
			        QuestData[playerid][STATE] = 1;
			        QuestData[playerid][PROGRESS] = 1;
			        
			        STRING_GLOBAL[0] = EOS;
			        strcat(STRING_GLOBAL, "Хо-хо-хо, с наступающим тебя!\n");
					strcat(STRING_GLOBAL, "Я совсем уже старый стал, по сути растерял половину подарков: выпали из саней, когда я пролетал над ТЕКСТ, вот же беда!\n");
					strcat(STRING_GLOBAL, "Детишки не могут остаться без подарков, они весь год хорошо себя вели и заслужили их, ты обязан мне помочь!\n");
					strcat(STRING_GLOBAL, "Направляйся в районы Bluberry и Dillimore, собери все утерянные подарки, затем возвращайся ко мне и помни — праздничное настроение детишек зависит только от тебя!");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"В поисках новогодних подарков", STRING_GLOBAL, !"Скрыть", !"");
					return 0x1;
			    }
			    if(QuestData[playerid][STATE] == 3)
			    {
			        SendBotMessage(playerid, "Хо-хо, ты выручил меня, мой юный друг! Получи за это ТЕКСТ", 3);
			        UserData[playerid][MONEY] += 5000;
					QuestData[playerid][STATE] = 4;
				    UserData[playerid][SNOW] += 3;
					UserData[playerid][EXP] += 3;
			        return 0x1;
			    }
			    if(QuestData[playerid][STATE] == 5)
			    {
			        if(QuestData[playerid][TIME_LOCK] > gettime())
				    {
				        SendBotMessage(playerid, "Задания для тебя еще не готово, возращайся позже", 3);
				        return 0x1;
				    }
					if(QuestData[playerid][TIME_LOCK] < gettime())
					{
					    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"В мире.. оленей", !"Неприятности!\nОлени сбежали, видимо я снова забыл их покормить, а эльфы слишком заняты приготовлением подарков, они не могут помочь мне, я вынужден снова просить тебя о помощи, мой юный друг.\nБери автомобиль и направляйся к ТЕКСТ, пригони моих оленей домой, а потом мы с тобой поговорим, хо-хо-хо!", !"Скрыть", !"");
						QuestData[playerid][PROGRESS] = 0;
						QuestData[playerid][STATE] = 0;
						QuestData[playerid][ID] = 6;
						return 0x1;
					}
			    }
			}
		}
		if(QuestData[playerid][ID] == 6)
		{
		    if(QuestData[playerid][STATE] == 2 && QuestData[playerid][PROGRESS] == 25)
		    {
                SendBotMessage(playerid, "А вот и мои олени! Да, ты не эльф, но ты хорош, хо-хо! Вот тебе мой подарок — текст", 3);
		        UserData[playerid][MONEY] += 5000;
				QuestData[playerid][STATE] = 3;
			    UserData[playerid][SNOW] += 3;
				UserData[playerid][EXP] += 3;
		        return 0x1;
		    }
		    if(QuestData[playerid][STATE] == 4)
		    {
		    	if(QuestData[playerid][TIME_LOCK] > gettime())
			    {
			        SendBotMessage(playerid, "Задания для тебя еще не готово, возращайся позже", 3);
			        return 0x1;
			    }
			}
		}
	}
	return 0x1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid >= VehicleGame[0] && VehicleGame[4] >= vehicleid)
		{
			if(QuestData[playerid][ID] == 5 && QuestData[playerid][STATE] == 1)
			{
			    if(PlayerVehicleQuest[playerid] != 0xFFFF && PlayerVehicleQuest[playerid] != vehicleid && PlayerQuestCar[vehicleid] != playerid)
			    {
			        RemovePlayerFromVehicle(playerid);
			    	return 0x1;
			    }
			    PlayerQuestCar[vehicleid] = playerid;
			    PlayerVehicleQuest[playerid] = vehicleid;

			    PickupPodarok[playerid][0] = CreateDynamicPickup(19054, 23,  966.19810, -397.1275, 66.2382, -1, -1, playerid);
				PickupPodarok[playerid][1] = CreateDynamicPickup(19054, 23,  753.20510, -273.5634, 11.2691, -1, -1, playerid);
				PickupPodarok[playerid][2] = CreateDynamicPickup(19054, 23,  721.34410, -338.6277, 7.83210, -1, -1, playerid);
				PickupPodarok[playerid][3] = CreateDynamicPickup(19054, 23,  547.39240, -359.1025, 28.0504, -1, -1, playerid);
				PickupPodarok[playerid][4] = CreateDynamicPickup(19054, 23,  499.64710, -490.2873, 40.7668, -1, -1, playerid);
				PickupPodarok[playerid][5] = CreateDynamicPickup(19054, 23,  630.69010, -602.1387, 16.3359, -1, -1, playerid);
				PickupPodarok[playerid][6] = CreateDynamicPickup(19054, 23,  737.34110, -619.6038, 15.0068, -1, -1, playerid);
				PickupPodarok[playerid][7] = CreateDynamicPickup(19054, 23,  827.38680, -605.1269, 16.3359, -1, -1, playerid);
				PickupPodarok[playerid][8] = CreateDynamicPickup(19054, 23,  844.24270, -597.6876, 18.4219, -1, -1, playerid);
				PickupPodarok[playerid][9] = CreateDynamicPickup(19054, 23,  871.48650, -511.8520, 27.8192, -1, -1, playerid);
				PickupPodarok[playerid][10] = CreateDynamicPickup(19054, 23, 764.68300, -548.9877, 17.0293, -1, -1, playerid);
				PickupPodarok[playerid][11] = CreateDynamicPickup(19054, 23, 701.35000, -460.2585, 16.3359, -1, -1, playerid);
				PickupPodarok[playerid][12] = CreateDynamicPickup(19054, 23, 316.58040, -579.3849, 8.74020, -1, -1, playerid);
				PickupPodarok[playerid][13] = CreateDynamicPickup(19054, 23, 261.55930, -287.3930, 1.57810, -1, -1, playerid);
				PickupPodarok[playerid][14] = CreateDynamicPickup(19054, 23, 313.72260, -238.9804, 1.57810, -1, -1, playerid);
				PickupPodarok[playerid][15] = CreateDynamicPickup(19054, 23, 363.47400, -90.65540, 1.38280, -1, -1, playerid);
				PickupPodarok[playerid][16] = CreateDynamicPickup(19054, 23, 325.89460, -47.15520, 1.54110, -1, -1, playerid);
				PickupPodarok[playerid][17] = CreateDynamicPickup(19054, 23, 296.98120, 24.783900, 2.59570, -1, -1, playerid);
				PickupPodarok[playerid][18] = CreateDynamicPickup(19054, 23, 171.37120, -14.18040, 1.57810, -1, -1, playerid);
				PickupPodarok[playerid][19] = CreateDynamicPickup(19054, 23, 111.33160, -161.1097, 1.60720, -1, -1, playerid);
				PickupPodarok[playerid][20] = CreateDynamicPickup(19054, 23, 203.29720, -167.9635, 1.57810, -1, -1, playerid);
				PickupPodarok[playerid][21] = CreateDynamicPickup(19054, 23, 249.47100, -154.7087, 1.57030, -1, -1, playerid);
			    return 0x1;
			}
			else
			{
			    RemovePlayerFromVehicle(playerid);
			    return 0x1;
			}
		}
		if(vehicleid >= VehicleOlen[0] && VehicleOlen[4] >= vehicleid)
		{
			if(QuestData[playerid][ID] == 6 && QuestData[playerid][STATE] == 0)
			{
			    if(PlayerVehicleQuest[playerid] != 0xFFFF && PlayerVehicleQuest[playerid] != vehicleid && PlayerQuestCar[vehicleid] != playerid)
			    {
			        RemovePlayerFromVehicle(playerid);
			    	return 0x1;
			    }
			    PlayerQuestCar[vehicleid] = playerid;
			    PlayerVehicleQuest[playerid] = vehicleid;

			    PlayerPickupOlen[playerid][0] = CreateDynamicPickup(19315, 23, -30.992500, -982.31630, 24.6266, -1, -1, playerid);
				PlayerPickupOlen[playerid][1] = CreateDynamicPickup(19315, 23, -95.677000, -1020.1923, 14.7025, -1, -1, playerid);
				PlayerPickupOlen[playerid][2] = CreateDynamicPickup(19315, 23, -377.73500, -1440.1688, 25.4573, -1, -1, playerid);
				PlayerPickupOlen[playerid][3] = CreateDynamicPickup(19315, 23, -76.375200, -1365.4435, 3.22670, -1, -1, playerid);
				PlayerPickupOlen[playerid][4] = CreateDynamicPickup(19315, 23, -343.91030, -812.14590, 33.8862, -1, -1, playerid);
				PlayerPickupOlen[playerid][5] = CreateDynamicPickup(19315, 23, -347.39170, -1031.2408, 59.3153, -1, -1, playerid);
				PlayerPickupOlen[playerid][6] = CreateDynamicPickup(19315, 23, -577.45360, -1045.3300, 23.8554, -1, -1, playerid);
				PlayerPickupOlen[playerid][7] = CreateDynamicPickup(19315, 23, -566.58150, -1504.0328, 9.32820, -1, -1, playerid);
				PlayerPickupOlen[playerid][8] = CreateDynamicPickup(19315, 23, -651.11210, -584.55540, 31.8739, -1, -1, playerid);
				PlayerPickupOlen[playerid][9] = CreateDynamicPickup(19315, 23, -658.59480, -818.30070, 95.7224, -1, -1, playerid);
				PlayerPickupOlen[playerid][10] = CreateDynamicPickup(19315, 23, -614.0332, -928.44430, 101.254, -1, -1, playerid);
				PlayerPickupOlen[playerid][11] = CreateDynamicPickup(19315, 23, -780.5428, -773.37310, 156.900, -1, -1, playerid);
				PlayerPickupOlen[playerid][12] = CreateDynamicPickup(19315, 23, -769.9673, -691.73070, 110.723, -1, -1, playerid);
				PlayerPickupOlen[playerid][13] = CreateDynamicPickup(19315, 23, -920.1595, -561.27550, 25.1946, -1, -1, playerid);
				PlayerPickupOlen[playerid][14] = CreateDynamicPickup(19315, 23, -977.1701, -750.00760, 32.8956, -1, -1, playerid);
				PlayerPickupOlen[playerid][15] = CreateDynamicPickup(19315, 23, -1164.661, -861.85480, 118.297, -1, -1, playerid);
				PlayerPickupOlen[playerid][16] = CreateDynamicPickup(19315, 23, -1079.572, -1260.3248, 129.218, -1, -1, playerid);
				PlayerPickupOlen[playerid][17] = CreateDynamicPickup(19315, 23, -1008.884, -1253.2487, 131.546, -1, -1, playerid);
				PlayerPickupOlen[playerid][18] = CreateDynamicPickup(19315, 23, -970.7300, -1187.3827, 130.094, -1, -1, playerid);
				PlayerPickupOlen[playerid][19] = CreateDynamicPickup(19315, 23, -1175.086, -1163.4937, 129.218, -1, -1, playerid);
				PlayerPickupOlen[playerid][20] = CreateDynamicPickup(19315, 23, -972.8179, -1628.4108, 76.3672, -1, -1, playerid);
				PlayerPickupOlen[playerid][21] = CreateDynamicPickup(19315, 23, -1102.858, -1620.7671, 76.3672, -1, -1, playerid);
				PlayerPickupOlen[playerid][22] = CreateDynamicPickup(19315, 23, -1048.078, -1508.9249, 71.0712, -1, -1, playerid);
				PlayerPickupOlen[playerid][23] = CreateDynamicPickup(19315, 23, -1342.199, -1444.7191, 103.664, -1, -1, playerid);
				PlayerPickupOlen[playerid][24] = CreateDynamicPickup(19315, 23, -1441.017, -1486.0072, 101.746, -1, -1, playerid);
				PlayerPickupOlen[playerid][25] = CreateDynamicPickup(19315, 23, -406.9565, -1766.1626, 5.19620, -1, -1, playerid);
			    return 0x1;
			}
			else
			{
			    RemovePlayerFromVehicle(playerid);
			    return 0x1;
			}
		}
	}
	return 0x1;
}

public OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i != 12; i ++)
	{
		DestroyDynamicObject(PlayerQuestObject[playerid][i]);
	}
	PlayerQuestCar[PlayerVehicleQuest[playerid]] = -1;
	SetVehicleToRespawn(PlayerVehicleQuest[playerid]);
	PlayerVehicleQuest[playerid] = 0xFFFF;
	return 0x1;
}

stock SendBotMessage(playerid, string[], time)
{
	if(PlayerTextBot[playerid] != PlayerText3D:0xFFFF) return 0x1;
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1489.1440, -1725.0293, 13.3038) == 1)
	{
        PlayerTextBot[playerid] = CreatePlayer3DTextLabel(playerid, string, 0xCCCCCCFF, 1489.6067, -1724.3973, 14.5000, 4.0, 0xFFFF, 0xFFFF, 1);
        
        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{FFFF00}Снеговик: {CCCCCC}%s", string);
        SendClientMessage(playerid, 0xFFFF00FF, STRING_GLOBAL);
        PlayerTextTime[playerid] = gettime() + time;
	    return 0x1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1469.5425, -1724.8444, 13.3038) == 1)
	{
	    PlayerTextBot[playerid] = CreatePlayer3DTextLabel(playerid, string, 0xCCCCCCFF, 1489.6067, -1724.3973, 14.5000, 4.0, 0xFFFF, 0xFFFF, 1);
	    
	    STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{FFFF00}Снеговик: {CCCCCC}%s", string);
        SendClientMessage(playerid, 0xFFFF00FF, STRING_GLOBAL);
	    PlayerTextTime[playerid] = gettime() + time;
	    return 0x1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1444.3473, -1701.4098, 13.3038) == 1)
	{
        PlayerTextBot[playerid] = CreatePlayer3DTextLabel(playerid, string, 0xCCCCCCFF, 1444.3473, -1701.4098, 13.3038 + 1.0, 4.0, 0xFFFF, 0xFFFF, 1);

	    STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{FFFF00}Торговец: {CCCCCC}%s", string);
        SendClientMessage(playerid, 0xFFFF00FF, STRING_GLOBAL);
	    PlayerTextTime[playerid] = gettime() + time;
	    return 0x1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1450.3641, -1691.2615, 13.3038) == 1)
	{
	    PlayerTextBot[playerid] = CreatePlayer3DTextLabel(playerid, string, 0xCCCCCCFF, 1450.3641, -1691.2615, 13.3038 + 1.0, 4.0, 0xFFFF, 0xFFFF, 1);

	    STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{FFFF00}Торговец: {CCCCCC}%s", string);
        SendClientMessage(playerid, 0xFFFF00FF, STRING_GLOBAL);
	    PlayerTextTime[playerid] = gettime() + time;
		return 0x1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 1478.9650, -1702.9823, 13.3038) == 1)
	{
	    PlayerTextBot[playerid] = CreatePlayer3DTextLabel(playerid, string, 0xCCCCCCFF, 1476.4521, -1702.1241, 16.0476, 5.0, 0xFFFF, 0xFFFF, 1);

	    STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{FFFF00}Санта: {CCCCCC}%s", string);
        SendClientMessage(playerid, 0xFFFF00FF, STRING_GLOBAL);
	    PlayerTextTime[playerid] = gettime() + time;
		return 0x1;
	}
	return 0x1;
}

ShowDialogQuest(playerid, dialogid)
{
	switch(dialogid)
	{
	    case 1: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Среди традиций новогодних\nЕсть самый главный ритуал,\nНам ровно в полночь нужно выпить...\nА что?\n", !"Принять", !"Отмена");
        case 2: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Если снег кругом лежит,\nКто-то с елкой вон бежит,\nТам — катаются на льду,\nТут — салютов люди ждут,\nА у нас вот на столе\nАпельсины, оливье,\nКакой праздник к нам идет?\nНу, конечно...", !"Принять", !"Отмена");
	    case 3: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Что за шарики на елочке висят,\nИ цветами радуги блестят?\nЕсть у елочки такие вот подружки,\nА зовут их...", !"Принять", !"Отмена");
	    case 4: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Пускай внутри они пусты,\nЗато нет большей красоты:\nНа свету блестят, играют,\nНашу елку украшают,\nВсех оттенков и цветов,\nВ форме звезд, зверей, шаров,\nБудто каждая кричит:\n«Я имею лучше вид!»\nКонкурентки все друг дружке\nНовогодние...", !"Принять", !"Отмена");
	    case 5: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Что так любят все зимою\nИ чему любой ребенок рад?\nКогда вместо дождика и зноя\nЗа окошком валит", !"Принять", !"Отмена");
	    case 6: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Закружила, завертела,\nИ снежинки понесла,\nСтало все вдруг белым-белым —\nНастоящая зима.\nВсе вертеть, нести, кружить,\nЕй положено теперь.\nБратцу-ветру с ней дружить.\nКак зовут ее?", !"Принять", !"Отмена");
	    case 7: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Таинственный художник\nОкно разрисовал,\nВсе реки, водоемы\nПрозрачным льдом сковал.\nИ лежит, не тает снег.\nА детворе раздолье\nДля игр и потех.", !"Принять", !"Отмена");
	    case 8: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Он белый, пушистый,\nПохожий на вату.\nНа солнце — игристый,\nВ руках — мерзловатый.", !"Принять", !"Отмена");
	    case 9: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Мы все в костюмах, ярких масках,\nИ не узнать теперь ребят,\nВон — волк, вон — козочка из сказки,\nВот-вот начнется...", !"Принять", !"Отмена");
	    case 10: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"В пузырьках волшебных — воздух.\nОн щекочет вам язык.\nСпирт содержится в напитке\nИ на стол он ваш проник.\nВ Новый год он уважаем,\nМы его все называем...", !"Принять", !"Отмена");
	    case 11: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"В ярких упаковках\nПодарки под елкой.\nПод окном мальчишки\nРадуются вспышкам.\nЧто за праздник к нам идет?\nНу, конечно...", !"Принять", !"Отмена");
	    case 12: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Ею окошки украшают,\nДома и елку наряжают,\nОна красивая такая,\nВся разноцветная, сияет.\nЕе под Новый год всем надо.\nУзнали, что это? ...", !"Принять", !"Отмена");
	    case 13: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Теснятся за столом закуски,\nНо то — не завтрак, не обед!\nТут и салатов много вкусных\nГурманам на запрос — ответ.\nИ фрукты все на стол хотят:\nТут мандарины, виноград.\nНо в Новый год удивит вас\nЧудесный, крупный ...", !"Принять", !"Отмена");
	    case 14: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Нужная в хозяйстве вещь,\nВроде, неприметная,\nНо под Новый год всегда\nСтанет, вдруг, заметная.\nВ виде праздничной гирлянды\nВисит он в доме высоко,\nПодарки в него кладет Санта,\nА называется ...", !"Принять", !"Отмена");
	    case 15: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Праздник набирает силу,\nСтол уж ломится от яств.\nКаждому можно красиво\nПеть или пуститься в пляс.\nНо всему мешает он —\nОн не просто внешний фон.\nРазвлечениям, сюрпризам\nВторит громко ...", !"Принять", !"Отмена");
	    case 16: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"На крылечко опустились —\nДруг за дружкой торопились.\nЗастелили все вокруг\nИ бело все стало вдруг.\nА они сами — пушинки,\nВсе узорные ...", !"Принять", !"Отмена");
	    case 17: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Он может сиять, а может скрипеть,\nОн может лежать, а может лететь,\nИ есть у него всем известна сестрица —\nВодица. В нее он в тепле превратится.", !"Принять", !"Отмена");
	    case 18: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Все достали украшенья\nС самой дальней полки\nИ развесили гирлянды\nС шарами на елку.\nА теперь она у нас —\nЯркая подружка.\nНе забыли ли надеть\nВы на пик...", !"Принять", !"Отмена");
	    case 19: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Что вас ждет, куда спешить,\nВо что денежку вложить?Стоит плакать иль смеяться?\nБизнесом с кем заниматься?\nИ когда нажать на «стоп» —\nВам ответит ...", !"Принять", !"Отмена");
	    case 20: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Город заспешил куда-то\nИ в цене — дед бородатый.\nВсе его в дом приглашают,\nЧудеса все поджидают.\nОн же — щедрою рукой\nОтберет у всех покой.\nЧто за дедушка такой?", !"Принять", !"Отмена");
	    case 21: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Песни новогодние звучат,\nДетки радостно визжат.\nСнежки, санки и ледянки,\nШубы, свитер и ушанки.\nЖдем от Деда Морозы мы\nЯркой, сказочной...", !"Принять", !"Отмена");
	    case 22: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Часы двенадцать нам пробили,\nВсе обиды отпустили.\nЗагадали мы желанья,\nСбудутся все предсказания.\nДед Мороз принес мешок,\nЧто же спрятал там, дружок?", !"Принять", !"Отмена");
	    case 23: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Мешок огромный у него,\nВ нем полным-полно всего.\nДеткам, взрослым — всем презенты,\nС ним связанны новогодние моменты.\nКак же дедушка назван?\nОчень простенько — ... Роман?", !"Принять", !"Отмена");
	    case 24: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Он на севере живет,\nЛюбит праздник Новый год,\nНа оленях в санках мчится,\nС нами чтоб повеселиться,\nПосохом своим взмахнет,\nЕлочку для нас зажжет,\nЛюбит он курантов звон.\nНу, ребята, кто же он?", !"Принять", !"Отмена");
	    case 25: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Яркими огнями елка сверкает,\nНам на праздник намекает.\nВсе подарочки пакуют,\nФеи в платьицах колдуют.\nДед Мороз почти добрался,\nНикто без внимания не остался.\nЧто за день сегодня такой,\nЗимний праздник, озорной?", !"Принять", !"Отмена");
	    case 26: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Говорят, что он ИДЕТ,\nНо в реальности — летает.\nА когда он упадет,Землю щедро укрывает.\nМожет быть мокрым, холодным,\nДля полей он теплым станет.\nРадость несет с Новым годом,\nТолько очень быстро тает.", !"Принять", !"Отмена");
	    case 27: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Служит преданно он Санте,\nЗапрягают его в санки,\nМчится в небе, словно тень,\nВ праздник — северный ...", !"Принять", !"Отмена");
	    case 28: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Живет он очень далеко,\nНайти его нам нелегко.\nОн только раз в году придет,\nИ, аккурат, под Новый год.\nПодарки у него в мешке,\nИ посох с волшебством в руке.\nЕсть борода и красный нос,\nУзнали, кто он? ...", !"Принять", !"Отмена");
	    case 29: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"С Новым годом поздравляем\nИ подарочки вручаем.\nМы — твои лучшие друзья,\nЖдал ты нас еще с утра,\nГотовил угощения отчаянно,\nМы в доме твоем... хозяева?", !"Принять", !"Отмена");
	    case 30: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Не доллар он, но всем он нравится,\nК нему готовятся, и с ним встречаются,\nПодарки дарят, отрываются,\nС ним чудеса, порой, случаются.\nВсегда стремится он вперед.\nВеселый праздник ...", !"Принять", !"Отмена");
	    case 31: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Она праздник украшает,\nЕю елку наряжают,\nИ под Новый год повсюду\nНа витринах, окнах будет.\nОгоньками нам сверкает,\nС ней светлей повсюду станет.", !"Принять", !"Отмена");
	    case 32: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Есть один на свете дед,\nМного-много ему лет,\nОн жары боится очень,\nЛетом приходить не хочет,\nА когда мороз трещит,\nК деткам он на санках мчит,\nЭтот дед на Новый год\nОбязательно придет.", !"Принять", !"Отмена");
	    case 33: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Белоснежная царица,\nРаспрекрасная девица.\nВнучкой Дед ее зовет,\nЗнает весь ее народ.\nДолгую косу имеет,\nБез нее утренник пустеет.", !"Принять", !"Отмена");
	    case 34: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Бородатый добрый дед,\nВ шубу яркую одет,\nНа спине мешок несет\nИ приходит в Новый год,\nЛюбит очень он детей,\nЗатевает сто затей,\nВсем подарки раздает\nИ на север вновь уйдет.", !"Принять", !"Отмена");
	    case 35: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"И хороша, и зелена,\nПриходит в праздник к нам она,\nВисят на ней игрушки,\nКонфеты и хлопушки,\nИ зелены, и колки\nЕсть у нее иголки,\nВокруг нее все скачут,\nПод ней подарки прячут.", !"Принять", !"Отмена");
	    case 36: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Он с огромной бородой,\nОчень добрый и седой,\nВ шубе, в валенках, с мешком\nВ Новый год приходит дом,\nЗнает, что детей послушных\nНаградить подарком нужно.\nКак ребенок засыпает,\nОн подарок оставляет.", !"Принять", !"Отмена");
	    case 37: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Под Новый год ее мы покупаем,\nВ игрушки, как в одежду одеваем,\nА вместо шапки яркую верхушку\nМы одеваем на ее макушку.\nОна растет не в садике, не в поле,\nА на огромном, на лесном раздолье,\nКак будто ежик, вся она в иголках.\nОтветьте, кто она? Конечно, ...", !"Принять", !"Отмена");
	    case 38: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"На цвет она — зеленая, на запах — ох, пахучая,\nНа рост она — высокая, на ощупь же — колючая,\nНа вид она — прекрасная, хорошая, чудесная,\nМы ходим с хороводами вокруг нее и с песнями.\nНа ветках — не поверите: растут цветные шарики,\nЕще конфеты вкусные и яркие фонарики,\nПод ней на праздник прячутся подарки детям разные,\nСкажите, детки, кто она, такая вот прекрасная?", !"Принять", !"Отмена");
	    case 39: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"Чего ждут дети в Новый год?\nЧто вот-вот произойдет?\nОбъяснений нет ему,\nКто, когда и почему.", !"Принять", !"Отмена");
	    case 40: ShowPlayerDialog(playerid, DIALOG_QUEST, DIALOG_STYLE_INPUT, !"  ", !"И не куст, и не цветок\nВырос аж под потолок,\nВыросло чудесное\nДеревце прелестное,\nС мягкими иголками,\nЛишь немного колкими,\nВсе оно в игрушках, ждет,\nЧтоб украсить Новый год.", !"Принять", !"Отмена");
	}
	return 0x1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_QUEST:
		{
		    if(!response) return 0x1;
		    if(strlen(inputtext) == 0)
		    {
		        SendBotMessage(playerid, "Неправильно, попробуй еще раз", 2);
		        ShowDialogQuest(playerid, QuestData[playerid][PROGRESS]);
				return 0x1;
			}
			if(strcmp(inputtext, ReasonCompleteDialog[QuestData[playerid][PROGRESS] - 1], true) != 0)
			{
			    SendBotMessage(playerid, "Неправильно, попробуй еще раз", 2);
		        ShowDialogQuest(playerid, QuestData[playerid][PROGRESS]);
				return 0x1;
			}
            if(strcmp(inputtext, ReasonCompleteDialog[QuestData[playerid][PROGRESS] - 1], true) == 0)
			{
			    QuestData[playerid][PROGRESS] += QuestData[playerid][RANDOM];
			    if(QuestData[playerid][PROGRESS] == (QuestData[playerid][RANDOM] * 5))
			    {
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"  ", !"Хорошо, молодец.\nВот держи тебе подарок кусочек печенья и ледяное молоко", !"Скрыть", !"");
					QuestData[playerid][STATE] = 1;
			        return 0x1;
			    }
			    SendBotMessage(playerid, "Неправильно, попробуй еще раз", 2);
		        ShowDialogQuest(playerid, QuestData[playerid][PROGRESS]);
				return 0x1;
			}
		}
	}
	return 0x1;
}
