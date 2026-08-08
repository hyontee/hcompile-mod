#include 	<a_samp>
#include 	<Pawn.CMD>
#include 	<sscanf2>


#define randomEx(%0,%1) (%0+random(%1-%0))
//==============================================================================
#define CWHITE 		0xFFFFFFFF
#define CRED 		0xFF0000FF
#define CCYAN 		0x0000FFFF
#define CPINK 		0xFF00FFFF
#define CBLUE 		0x00FFFFFF
#define CYELLOW 	0xFFFF00FF
#define CGREY 		0x7F7F7FFF
#define CGREEN   	0x00FF00FF
#define CORANGE 	0xFF8000FF
#define CGOLD		0xFFD700FF
#define CDSB		0x00BFFFFF
#define CPURPLE     0xF7619300
#define CLRED    	0xFF3030FF

//------------------------------Цвет рации--------------------------------------

#define cRR         0x3CB371FF
#define cFF         0x6495EDFF

//______________________________________________________________________________
//------------------------------------------------------------------------------
#define CW          "{FFFFFF}"
#define CR          "{FF0000}"
#define CBB         "{0000FF}"
#define CP          "{FF00FF}"
#define CB          "{00FFFF}"
#define CY          "{FFFF00}"
#define CGRY		"{7F7F7F}"
#define CG	        "{00FF00}"
#define CO          "{FF8000}"
#define CGLD		"{FFD700}"
//------------------------------------------------------------------------------
#define CDG         "{006400}"
#define CDO         "{FF8C00}"
#define CLR         "{FF3030}"
#define cBi			"{3399FF}"



#define SCM 			SendClientMessage
#define SCMTA   		SendClientMessageToAll
#define SPD         	ShowPlayerDialog
//------------------------------------------------------------------------------
#define		DSI		DIALOG_STYLE_INPUT
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST
#define 	DSP		DIALOG_STYLE_PASSWORD
#define 	DST		DIALOG_STYLE_TABLIST



enum P_INFO
{
	bool:pOnKlado,
	
	bool:pOnOpenChest,

	KladoZONE,
	KladoTIMER,
	
	KladChestX,
	KladChestY,
	
	KladChestLastSlot,
	KladChestSlot,
	KladChestBombSlot[3],
};
new pINFO[MAX_PLAYERS][P_INFO];


new Text:klado_fon;
new Text:klado_metal;
new Text:klado_slot[26];
new Text:klado_slot_active[26];
new Text:klado_slot_bomb[26];
new Text:klado_slot_klad[26];

new PlayerText:klado_metal_distance[MAX_PLAYERS];
new PlayerText:klado_timer[MAX_PLAYERS];


#define MAX_KLADO_ZONE 2
new kladozone[MAX_KLADO_ZONE+1];
new kladozone_info[MAX_KLADO_ZONE+1][7] =
{
	{0,0,0,0,0,0,0}, //ПЕРВУЮ СТРОЧКУ НЕ ТРОГАТЬ НАХУЙ
	//MINX MINY, MAXX MAXY, CENTREX CENTREY CENTREZ
	{-8,-8, 8,8, 0, 0, 0},
	{-16,-16, 16,16, 0, 0, 0}
};


new KladoPickup;



public OnGameModeInit()
{


	CreateObject(19128, 0, 0, 1000,   0.00, 0.00, 0.00);

	CreateObject(19128, 4, 0, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 4, 4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 0, 4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -4, 4, 1000,   0.00, 0.00, 0.00);


	CreateObject(19128, -4, 0, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -4, -4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 0, -4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 4, -4, 1000,   0.00, 0.00, 0.00);


	CreateObject(19128, 0, 8, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 0, -8, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 4, 8, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -4, 8, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 4, -8, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -4, -8, 1000,   0.00, 0.00, 0.00);

	CreateObject(19128, 8, 0, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 8, 4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 8, -4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 8, 8, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, 8, -8, 1000,   0.00, 0.00, 0.00);

	CreateObject(19128, -8, 0, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -8, 4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -8, -4, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -8, 8, 1000,   0.00, 0.00, 0.00);
	CreateObject(19128, -8, -8, 1000,   0.00, 0.00, 0.00);




	LoadTextDraw();

	for(new i = 1; i <= MAX_KLADO_ZONE; i++)
	{
		kladozone[i] = GangZoneCreate(kladozone_info[i][0],kladozone_info[i][1], kladozone_info[i][2],kladozone_info[i][3]);
	}

	CreateActor(300, 0, -2, 1001, 0);
	Create3DTextLabel("[NPC]\nПантелеевич", 0x21cfbd, 0, -2, 1001+2, 5.0, 0);
	KladoPickup = CreatePickup(19902, 1, 0,-2, 1000);
	return 1;
}




public OnPlayerConnect(playerid)
{
	LoadPlayerTextDraw(playerid);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(pINFO[playerid][pOnKlado] == true)
	{
		new strkbass[20];
		format(strkbass, sizeof strkbass, "%d CEK.", pINFO[playerid][KladoTIMER]);
		PlayerTextDrawSetString(playerid, klado_timer[playerid], strkbass);
		new zone = pINFO[playerid][KladoZONE];
		
		if(IsPlayerInArea(playerid, kladozone_info[zone][0],kladozone_info[zone][1], kladozone_info[zone][2],kladozone_info[zone][3]))
		{
		    if(!pINFO[playerid][pOnOpenChest])
		    {
				TextDrawShowForPlayer(playerid, klado_metal);
				PlayerTextDrawShow(playerid, klado_metal_distance[playerid]);


			    new Float: x,
					Float: y,
					Float: z;
				GetPlayerPos(playerid, x,y,z);
				format(strkbass, sizeof strkbass, "%d M.", DistancePointToPoint(x,y,z, pINFO[playerid][KladChestX],pINFO[playerid][KladChestY], z)/*IsPlayerInRangeOfPoint(playerid, 5, pINFO[playerid][KladChestX], pINFO[playerid][KladChestY], z)*/ );
				//printf("DIST:%d",  DistancePointToPoint(x,y,z, pINFO[playerid][KladChestX],pINFO[playerid][KladChestY], z));
				PlayerTextDrawSetString(playerid, klado_metal_distance[playerid], strkbass);
			}

			//if()
		}
		else
		{
			TextDrawHideForPlayer(playerid, klado_metal);
			PlayerTextDrawHide(playerid, klado_metal_distance[playerid]);
		}
    }
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 19996)
	{
		if(response)
		{
		    pINFO[playerid][pOnKlado] = true;
		
		    pINFO[playerid][KladoTIMER] = 2000;
			PlayerTextDrawShow(playerid, klado_timer[playerid]);
			new strkbass[20];
			format(strkbass, sizeof strkbass, "%d CEK.", pINFO[playerid][KladoTIMER]);
			PlayerTextDrawSetString(playerid, klado_timer[playerid], strkbass);
			SetTimerEx("TimerPlayerKlado", 1000, false, "d", playerid);
			

			//можете ставить проверки на металоискатель, мне лень
			new zone = random(MAX_KLADO_ZONE); pINFO[playerid][KladoZONE] = zone;
			GangZoneShowForPlayer(playerid, kladozone[zone], CYELLOW);
			
			new klad_chestx = randomEx(kladozone_info[zone][0], kladozone_info[zone][2]);
			new klad_chesty = randomEx(kladozone_info[zone][1], kladozone_info[zone][3]);
			
			pINFO[playerid][KladChestX] = klad_chestx;
			pINFO[playerid][KladChestY] = klad_chesty;
			
			
			pINFO[playerid][KladChestSlot] = randomEx(21, 25);
			
			for(new i; i < 3; i++)
			{
			    pINFO[playerid][KladChestBombSlot][i] = randomEx(11, 25);
			    while(pINFO[playerid][KladChestBombSlot][i] == pINFO[playerid][KladChestSlot]) pINFO[playerid][KladChestBombSlot][i] = randomEx(1, 25);
			}
			
			
			new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);
			printf("Позиции сундука для игрока %s: X:%d Y:%d", name, klad_chestx, klad_chesty);
		}
	}
	return 1;
}

forward TimerPlayerKlado(playerid);
public TimerPlayerKlado(playerid)
{
	if(pINFO[playerid][KladoTIMER] > 0)
	{
		pINFO[playerid][KladoTIMER]--;
		SetTimerEx("TimerPlayerKlado", 1000, false, "d", playerid);
	}
	else
	{
        PlayerTextDrawHide(playerid, klado_timer[playerid]);
        
	    TextDrawHideForPlayer(playerid, klado_metal);
		PlayerTextDrawHide(playerid, klado_metal_distance[playerid]);

		TextDrawHideForPlayer(playerid, klado_fon);

		for(new i=1; i <= 25; i++)
		{
			TextDrawHideForPlayer(playerid, klado_slot[i]);
		}
	
	
		pINFO[playerid][pOnKlado] = false;
		pINFO[playerid][pOnOpenChest] = false;
		
		
		pINFO[playerid][KladChestX] = 0;
		pINFO[playerid][KladChestY] = 0;
		
		pINFO[playerid][KladChestBombSlot][0] = 0;
		pINFO[playerid][KladChestBombSlot][1] = 0;
		pINFO[playerid][KladChestBombSlot][2] = 0;
		pINFO[playerid][KladChestLastSlot] = 0;
		
	    GangZoneHideForPlayer(playerid, kladozone[pINFO[playerid][KladoZONE]]);
	    
		pINFO[playerid][KladoTIMER] = 2000;
		pINFO[playerid][KladoZONE] = 0;
		
	    SCM(playerid, CLRED, "Лашок ты проиграл лол, время кончилось");
	    CancelSelectTextDraw(playerid);
	}
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)//ВПИСАТЬ ЦВЕТА!
{
    if(clickedid == Text:INVALID_TEXT_DRAW)
    {
 		if(pINFO[playerid][pOnOpenChest]) SelectTextDraw(playerid, false);
    }
	for(new i=1; i <= 25; i++)
	{
		if(clickedid == klado_slot[i])
		{
		    switch(i)
		    {
		    
			        case 1..25:
			        {
					    if(pINFO[playerid][KladChestLastSlot] == 0)
						{
							switch(i)
							{
							    case 1..5: MineSlot(playerid, i);
								case 6..25:
								{
									SCM(playerid, CYELLOW, "| "CW"Начинайте копать сверху.");
								}
							}
						}
						else
						{
						    //new result = i - pINFO[playerid][KladChestLastSlot];
						    //printf("do, last:%d slot:%d; result:%d", pINFO[playerid][KladChestLastSlot], i, result);
			                if(i - pINFO[playerid][KladChestLastSlot] == 1 || pINFO[playerid][KladChestLastSlot] - i == 1) MineSlot(playerid, i);
							else if(i - pINFO[playerid][KladChestLastSlot] == 5 || pINFO[playerid][KladChestLastSlot] - i == 5) MineSlot(playerid, i);
							else SCM(playerid, CYELLOW, "| "CW"Копайте змейкой!");
						}
					}

			}
		}
	}
	return 1;
}


stock MineSlot(playerid, slot)
{
    if(slot == pINFO[playerid][KladChestSlot])
    {
		TextDrawHideForPlayer(playerid, klado_slot[slot]);
		TextDrawShowForPlayer(playerid, klado_slot_klad[slot]);
		SCM(playerid, CGREEN, "| "CW"Вы нашли клад!");
		SetTimerEx("TimerCloseChest", 2000, false, "d", playerid);
    }
    
    else if(slot == pINFO[playerid][KladChestBombSlot][0])
	{
		TextDrawHideForPlayer(playerid, klado_slot[slot]);
		TextDrawShowForPlayer(playerid, klado_slot_bomb[slot]);
		SCM(playerid, CYELLOW, "| "CW"Вы наткнулись на бомбу...");
		SetTimerEx("TimerResetChest", 2000, false, "d", playerid);
	}
 	else if(slot == pINFO[playerid][KladChestBombSlot][1])
	{
		TextDrawHideForPlayer(playerid, klado_slot[slot]);
		TextDrawShowForPlayer(playerid, klado_slot_bomb[slot]);
		SCM(playerid, CYELLOW, "| "CW"Вы наткнулись на бомбу...");
		SetTimerEx("TimerResetChest", 2000, false, "d", playerid);
	}
	else if(slot == pINFO[playerid][KladChestBombSlot][2])
	{
		TextDrawHideForPlayer(playerid, klado_slot[slot]);
		TextDrawShowForPlayer(playerid, klado_slot_bomb[slot]);
		SCM(playerid, CYELLOW, "| "CW"Вы наткнулись на бомбу...");
		SetTimerEx("TimerResetChest", 2000, false, "d", playerid);
	}
	
	else
    {
		pINFO[playerid][KladChestLastSlot] = slot;
		TextDrawHideForPlayer(playerid, klado_slot[slot]);
		TextDrawShowForPlayer(playerid, klado_slot_active[slot]);
	}
}


forward TimerResetChest(playerid);
public TimerResetChest(playerid)
{
    pINFO[playerid][KladChestLastSlot] = 0;
    
	for(new i=1; i <= 25; i++)
	{
		TextDrawShowForPlayer(playerid, klado_slot[i]);
		TextDrawHideForPlayer(playerid, klado_slot_active[i]);
		TextDrawHideForPlayer(playerid, klado_slot_klad[i]);
		TextDrawHideForPlayer(playerid, klado_slot_bomb[i]);
	}
}


forward TimerCloseChest(playerid);
public TimerCloseChest(playerid)
{
	pINFO[playerid][pOnOpenChest] = false;
    pINFO[playerid][KladChestLastSlot] = 0;

	TextDrawHideForPlayer(playerid, klado_fon);

	for(new i=1; i <= 25; i++)
	{
		TextDrawHideForPlayer(playerid, klado_slot[i]);
		TextDrawHideForPlayer(playerid, klado_slot_active[i]);
		TextDrawHideForPlayer(playerid, klado_slot_klad[i]);
		TextDrawHideForPlayer(playerid, klado_slot_bomb[i]);
	}
	CancelSelectTextDraw(playerid);
	

	new zone = pINFO[playerid][KladoZONE];
	new klad_chestx = randomEx(kladozone_info[zone][0], kladozone_info[zone][2]);
	new klad_chesty = randomEx(kladozone_info[zone][1], kladozone_info[zone][3]);

	pINFO[playerid][KladChestX] = klad_chestx;
	pINFO[playerid][KladChestY] = klad_chesty;


	pINFO[playerid][KladChestSlot] = randomEx(1, 25);

	for(new i; i < 3; i++)
	{
	    pINFO[playerid][KladChestBombSlot] = randomEx(1, 25);
	    while(pINFO[playerid][KladChestBombSlot][i] == pINFO[playerid][KladChestSlot]) pINFO[playerid][KladChestBombSlot][i] = randomEx(1, 25);
	}


	new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	printf("Позиции сундука для игрока %s: X:%d Y:%d", name, klad_chestx, klad_chesty);

	TextDrawShowForPlayer(playerid, klado_metal);
	PlayerTextDrawShow(playerid, klado_metal_distance[playerid]);
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == KladoPickup)
	{
		if(pINFO[playerid][pOnKlado] == false)
		{
			new strkbass[875]; //с запасом можн
		    format(strkbass, sizeof strkbass,
			"Кладоискатель — это одна из самых интереснейших и увлекательнейших работ сервера,\n"\
			"которая предоставляет возможность всем игрокам проявить множество внутренних\n"\
			"личных качеств, а также свою интуицию. Постарайтесь только вдуматься: отправится в\n"\
			"путешествие на поиски затерянного клада — это невероятно здорово и интересно.\n"\
			"Мы реализовали действительно интересную, а также динамичную интерактивную игру\n"\
			"от которой зависит насколько быстро клад будет найден и откопан,\n\n");
			
		    format(strkbass, sizeof strkbass,
			"%sНельзя не упомянуть о системе скиллов: каждый найденный клад повышает уровень\n"\
			"кладоискателя, который, в свою очередь, преувеличивает прибыль игрока.\n"\
			"Наданный момент Ваш уровень кладоискателя составляет. 0 / 170.\n"\
			"Для того, чтобы отправиться на поиски необходимо будет арендовать специальный металоискатель\n"\
			"с помощью которого Вы будете искать местоположение непосредственно самого спрятанного клада.", strkbass);
			
	    	SPD(playerid, 19996, DSM, ""CR"Кладоискатель", strkbass, "Начать", "Выйти");
	    }
	}
	return 1;
}




CMD:dig(playerid)
{
	if(pINFO[playerid][pOnKlado] == true)
	{
	    if(pINFO[playerid][pOnOpenChest] == false)
	    {
				new zone = pINFO[playerid][KladoZONE];
			    if(IsPlayerInArea(playerid, kladozone_info[zone][0],kladozone_info[zone][1], kladozone_info[zone][2],kladozone_info[zone][3]))
			    {
					if( IsPlayerInArea(playerid, pINFO[playerid][KladChestX]-5, pINFO[playerid][KladChestY]-5,  pINFO[playerid][KladChestX]+5, pINFO[playerid][KladChestY]+5) )
					{
					    pINFO[playerid][pOnOpenChest] = true;

						TextDrawHideForPlayer(playerid, klado_metal);
						PlayerTextDrawHide(playerid, klado_metal_distance[playerid]);

						TextDrawShowForPlayer(playerid, klado_fon);

						for(new i=1; i <= 25; i++)
						{
							TextDrawShowForPlayer(playerid, klado_slot[i]);
						}
						SelectTextDraw(playerid, false);
					}
			    	else return SCM(playerid, CLRED, "| "CW"Вы слишком далеко от места клада.");
			    }
			    else return SCM(playerid, CLRED, "| "CW"Вы должны находится в желтом квадрате отмеченном на карте.");
	    }
	}
	return 1;
}

cmd:alltp(playerid)
{
	SetPlayerPos(playerid, 0,0,1001.5);
}

stock LoadTextDraw()
{
	klado_fon = TextDrawCreate(110.960083, 39.946651, "kbassklado:kbassosnova");
	TextDrawLetterSize(klado_fon, 0.000000, 0.000000);
	TextDrawTextSize(klado_fon, 388.640350, 329.952178);
	TextDrawAlignment(klado_fon, 1);
	TextDrawColor(klado_fon, -1);
	TextDrawSetShadow(klado_fon, 0);
	TextDrawSetOutline(klado_fon, 0);
	TextDrawFont(klado_fon, 4);

	klado_metal = TextDrawCreate(440.719848, 350.933380, "kbassklado:kbassmettal");
	TextDrawLetterSize(klado_metal, 0.000000, 0.000000);
	TextDrawTextSize(klado_metal, 119.199951, 99.306686);
	TextDrawAlignment(klado_metal, 1);
	TextDrawColor(klado_metal, -1);
	TextDrawSetShadow(klado_metal, 0);
	TextDrawSetOutline(klado_metal, 0);
	TextDrawFont(klado_metal, 4);



	klado_slot[1] = TextDrawCreate(123.999999, 54.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[1], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[1], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[1], 1);
	TextDrawColor(klado_slot[1], -1);
	TextDrawSetShadow(klado_slot[1], 0);
	TextDrawSetOutline(klado_slot[1], 0);
	TextDrawFont(klado_slot[1], 4);
	TextDrawSetSelectable(klado_slot[1], true);

	klado_slot[2] = TextDrawCreate(196.199999, 54.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[2], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[2], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[2], 1);
	TextDrawColor(klado_slot[2], -1);
	TextDrawSetShadow(klado_slot[2], 0);
	TextDrawSetOutline(klado_slot[2], 0);
	TextDrawFont(klado_slot[2], 4);
	TextDrawSetSelectable(klado_slot[2], true);

	klado_slot[3] = TextDrawCreate(269.200000, 54.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[3], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[3], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[3], 1);
	TextDrawColor(klado_slot[3], -1);
	TextDrawSetShadow(klado_slot[3], 0);
	TextDrawSetOutline(klado_slot[3], 0);
	TextDrawFont(klado_slot[3], 4);
	TextDrawSetSelectable(klado_slot[3], true);

	klado_slot[4] = TextDrawCreate(343.000000, 54.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[4], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[4], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[4], 1);
	TextDrawColor(klado_slot[4], -1);
	TextDrawSetShadow(klado_slot[4], 0);
	TextDrawSetOutline(klado_slot[4], 0);
	TextDrawFont(klado_slot[4], 4);
	TextDrawSetSelectable(klado_slot[4], true);

	klado_slot[5] = TextDrawCreate(416.800000, 54.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[5], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[5], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[5], 1);
	TextDrawColor(klado_slot[5], -1);
	TextDrawSetShadow(klado_slot[5], 0);
	TextDrawSetOutline(klado_slot[5], 0);
	TextDrawFont(klado_slot[5], 4);
	TextDrawSetSelectable(klado_slot[5], true);



 	klado_slot[6] = TextDrawCreate(123.999999, 115.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[6], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[6], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[6], 1);
	TextDrawColor(klado_slot[6], -1);
	TextDrawSetShadow(klado_slot[6], 0);
	TextDrawSetOutline(klado_slot[6], 0);
	TextDrawFont(klado_slot[6], 4);
	TextDrawSetSelectable(klado_slot[6], true);
	
	klado_slot[7] = TextDrawCreate(196.199999, 115.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[7], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[7], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[7], 1);
	TextDrawColor(klado_slot[7], -1);
	TextDrawSetShadow(klado_slot[7], 0);
	TextDrawSetOutline(klado_slot[7], 0);
	TextDrawFont(klado_slot[7], 4);
	TextDrawSetSelectable(klado_slot[7], true);
	
	klado_slot[8] = TextDrawCreate(269.200000, 115.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[8], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[8], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[8], 1);
	TextDrawColor(klado_slot[8], -1);
	TextDrawSetShadow(klado_slot[8], 0);
	TextDrawSetOutline(klado_slot[8], 0);
	TextDrawFont(klado_slot[8], 4);
	TextDrawSetSelectable(klado_slot[8], true);
	
	klado_slot[9] = TextDrawCreate(343.000000, 115.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[9], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[9], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[9], 1);
	TextDrawColor(klado_slot[9], -1);
	TextDrawSetShadow(klado_slot[9], 0);
	TextDrawSetOutline(klado_slot[9], 0);
	TextDrawFont(klado_slot[9], 4);
	TextDrawSetSelectable(klado_slot[9], true);
	
	klado_slot[10] = TextDrawCreate(416.800000, 115.500000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[10], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[10], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[10], 1);
	TextDrawColor(klado_slot[10], -1);
	TextDrawSetShadow(klado_slot[10], 0);
	TextDrawSetOutline(klado_slot[10], 0);
	TextDrawFont(klado_slot[10], 4);
	TextDrawSetSelectable(klado_slot[10], true);
	
	

	klado_slot[11] = TextDrawCreate(123.999999, 177.200000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[11], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[11], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[11], 1);
	TextDrawColor(klado_slot[11], -1);
	TextDrawSetShadow(klado_slot[11], 0);
	TextDrawSetOutline(klado_slot[11], 0);
	TextDrawFont(klado_slot[11], 4);
	TextDrawSetSelectable(klado_slot[11], true);

	klado_slot[12] = TextDrawCreate(196.199999, 177.200000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[12], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[12], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[12], 1);
	TextDrawColor(klado_slot[12], -1);
	TextDrawSetShadow(klado_slot[12], 0);
	TextDrawSetOutline(klado_slot[12], 0);
	TextDrawFont(klado_slot[12], 4);
	TextDrawSetSelectable(klado_slot[12], true);

	klado_slot[13] = TextDrawCreate(269.200000, 177.200000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[13], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[13], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[13], 1);
	TextDrawColor(klado_slot[13], -1);
	TextDrawSetShadow(klado_slot[13], 0);
	TextDrawSetOutline(klado_slot[13], 0);
	TextDrawFont(klado_slot[13], 4);
	TextDrawSetSelectable(klado_slot[13], true);

	klado_slot[14] = TextDrawCreate(343.000000, 177.200000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[14], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[14], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[14], 1);
	TextDrawColor(klado_slot[14], -1);
	TextDrawSetShadow(klado_slot[14], 0);
	TextDrawSetOutline(klado_slot[14], 0);
	TextDrawFont(klado_slot[14], 4);
	TextDrawSetSelectable(klado_slot[14], true);

	klado_slot[15] = TextDrawCreate(416.800000, 177.200000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[15], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[15], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[15], 1);
	TextDrawColor(klado_slot[15], -1);
	TextDrawSetShadow(klado_slot[15], 0);
	TextDrawSetOutline(klado_slot[15], 0);
	TextDrawFont(klado_slot[15], 4);
	TextDrawSetSelectable(klado_slot[15], true);



	klado_slot[16] = TextDrawCreate(123.999999, 239.000000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[16], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[16], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[16], 1);
	TextDrawColor(klado_slot[16], -1);
	TextDrawSetShadow(klado_slot[16], 0);
	TextDrawSetOutline(klado_slot[16], 0);
	TextDrawFont(klado_slot[16], 4);
	TextDrawSetSelectable(klado_slot[16], true);

	klado_slot[17] = TextDrawCreate(196.199999, 239.000000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[17], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[17], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[17], 1);
	TextDrawColor(klado_slot[17], -1);
	TextDrawSetShadow(klado_slot[17], 0);
	TextDrawSetOutline(klado_slot[17], 0);
	TextDrawFont(klado_slot[17], 4);
	TextDrawSetSelectable(klado_slot[17], true);

	klado_slot[18] = TextDrawCreate(269.200000, 239.000000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[18], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[18], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[18], 1);
	TextDrawColor(klado_slot[18], -1);
	TextDrawSetShadow(klado_slot[18], 0);
	TextDrawSetOutline(klado_slot[18], 0);
	TextDrawFont(klado_slot[18], 4);
	TextDrawSetSelectable(klado_slot[18], true);

	klado_slot[19] = TextDrawCreate(343.000000, 239.000000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[19], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[19], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[19], 1);
	TextDrawColor(klado_slot[19], -1);
	TextDrawSetShadow(klado_slot[19], 0);
	TextDrawSetOutline(klado_slot[19], 0);
	TextDrawFont(klado_slot[19], 4);
	TextDrawSetSelectable(klado_slot[19], true);

	klado_slot[20] = TextDrawCreate(416.800000, 239.000000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[20], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[20], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[20], 1);
	TextDrawColor(klado_slot[20], -1);
	TextDrawSetShadow(klado_slot[20], 0);
	TextDrawSetOutline(klado_slot[20], 0);
	TextDrawFont(klado_slot[20], 4);
	TextDrawSetSelectable(klado_slot[20], true);



	klado_slot[21] = TextDrawCreate(123.999999, 300.800000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[21], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[21], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[21], 1);
	TextDrawColor(klado_slot[21], -1);
	TextDrawSetShadow(klado_slot[21], 0);
	TextDrawSetOutline(klado_slot[21], 0);
	TextDrawFont(klado_slot[21], 4);
	TextDrawSetSelectable(klado_slot[21], true);
	
	klado_slot[22] = TextDrawCreate(196.199999, 300.800000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[22], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[22], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[22], 1);
	TextDrawColor(klado_slot[22], -1);
	TextDrawSetShadow(klado_slot[22], 0);
	TextDrawSetOutline(klado_slot[22], 0);
	TextDrawFont(klado_slot[22], 4);
	TextDrawSetSelectable(klado_slot[22], true);

	klado_slot[23] = TextDrawCreate(269.200000, 300.800000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[23], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[23], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[23], 1);
	TextDrawColor(klado_slot[23], -1);
	TextDrawSetShadow(klado_slot[23], 0);
	TextDrawSetOutline(klado_slot[23], 0);
	TextDrawFont(klado_slot[23], 4);
	TextDrawSetSelectable(klado_slot[23], true);

	klado_slot[24] = TextDrawCreate(343.000000, 300.800000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[24], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[24], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[24], 1);
	TextDrawColor(klado_slot[24], -1);
	TextDrawSetShadow(klado_slot[24], 0);
	TextDrawSetOutline(klado_slot[24], 0);
	TextDrawFont(klado_slot[24], 4);
	TextDrawSetSelectable(klado_slot[24], true);

	klado_slot[25] = TextDrawCreate(416.800000, 300.800000, "kbassklado:kbasszemlya");
	TextDrawLetterSize(klado_slot[25], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot[25], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot[25], 1);
	TextDrawColor(klado_slot[25], -1);
	TextDrawSetShadow(klado_slot[25], 0);
	TextDrawSetOutline(klado_slot[25], 0);
	TextDrawFont(klado_slot[25], 4);
	TextDrawSetSelectable(klado_slot[25], true);
	
	
	
	
	
	//АКТИВНЫЕ
	klado_slot_active[1] = TextDrawCreate(123.999999, 54.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[1], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[1], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[1], 1);
	TextDrawColor(klado_slot_active[1], -1);
	TextDrawSetShadow(klado_slot_active[1], 0);
	TextDrawSetOutline(klado_slot_active[1], 0);
	TextDrawFont(klado_slot_active[1], 4);
	TextDrawSetSelectable(klado_slot_active[1], true);

	klado_slot_active[2] = TextDrawCreate(196.199999, 54.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[2], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[2], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[2], 1);
	TextDrawColor(klado_slot_active[2], -1);
	TextDrawSetShadow(klado_slot_active[2], 0);
	TextDrawSetOutline(klado_slot_active[2], 0);
	TextDrawFont(klado_slot_active[2], 4);
	TextDrawSetSelectable(klado_slot_active[2], true);

	klado_slot_active[3] = TextDrawCreate(269.200000, 54.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[3], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[3], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[3], 1);
	TextDrawColor(klado_slot_active[3], -1);
	TextDrawSetShadow(klado_slot_active[3], 0);
	TextDrawSetOutline(klado_slot_active[3], 0);
	TextDrawFont(klado_slot_active[3], 4);
	TextDrawSetSelectable(klado_slot_active[3], true);

	klado_slot_active[4] = TextDrawCreate(343.000000, 54.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[4], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[4], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[4], 1);
	TextDrawColor(klado_slot_active[4], -1);
	TextDrawSetShadow(klado_slot_active[4], 0);
	TextDrawSetOutline(klado_slot_active[4], 0);
	TextDrawFont(klado_slot_active[4], 4);
	TextDrawSetSelectable(klado_slot_active[4], true);

	klado_slot_active[5] = TextDrawCreate(416.800000, 54.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[5], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[5], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[5], 1);
	TextDrawColor(klado_slot_active[5], -1);
	TextDrawSetShadow(klado_slot_active[5], 0);
	TextDrawSetOutline(klado_slot_active[5], 0);
	TextDrawFont(klado_slot_active[5], 4);
	TextDrawSetSelectable(klado_slot_active[5], true);



 	klado_slot_active[6] = TextDrawCreate(123.999999, 115.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[6], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[6], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[6], 1);
	TextDrawColor(klado_slot_active[6], -1);
	TextDrawSetShadow(klado_slot_active[6], 0);
	TextDrawSetOutline(klado_slot_active[6], 0);
	TextDrawFont(klado_slot_active[6], 4);
	TextDrawSetSelectable(klado_slot_active[6], true);

	klado_slot_active[7] = TextDrawCreate(196.199999, 115.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[7], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[7], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[7], 1);
	TextDrawColor(klado_slot_active[7], -1);
	TextDrawSetShadow(klado_slot_active[7], 0);
	TextDrawSetOutline(klado_slot_active[7], 0);
	TextDrawFont(klado_slot_active[7], 4);
	TextDrawSetSelectable(klado_slot_active[7], true);

	klado_slot_active[8] = TextDrawCreate(269.200000, 115.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[8], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[8], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[8], 1);
	TextDrawColor(klado_slot_active[8], -1);
	TextDrawSetShadow(klado_slot_active[8], 0);
	TextDrawSetOutline(klado_slot_active[8], 0);
	TextDrawFont(klado_slot_active[8], 4);
	TextDrawSetSelectable(klado_slot_active[8], true);

	klado_slot_active[9] = TextDrawCreate(343.000000, 115.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[9], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[9], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[9], 1);
	TextDrawColor(klado_slot_active[9], -1);
	TextDrawSetShadow(klado_slot_active[9], 0);
	TextDrawSetOutline(klado_slot_active[9], 0);
	TextDrawFont(klado_slot_active[9], 4);
	TextDrawSetSelectable(klado_slot_active[9], true);

	klado_slot_active[10] = TextDrawCreate(416.800000, 115.500000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[10], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[10], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[10], 1);
	TextDrawColor(klado_slot_active[10], -1);
	TextDrawSetShadow(klado_slot_active[10], 0);
	TextDrawSetOutline(klado_slot_active[10], 0);
	TextDrawFont(klado_slot_active[10], 4);
	TextDrawSetSelectable(klado_slot_active[10], true);



	klado_slot_active[11] = TextDrawCreate(123.999999, 177.200000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[11], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[11], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[11], 1);
	TextDrawColor(klado_slot_active[11], -1);
	TextDrawSetShadow(klado_slot_active[11], 0);
	TextDrawSetOutline(klado_slot_active[11], 0);
	TextDrawFont(klado_slot_active[11], 4);
	TextDrawSetSelectable(klado_slot_active[11], true);

	klado_slot_active[12] = TextDrawCreate(196.199999, 177.200000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[12], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[12], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[12], 1);
	TextDrawColor(klado_slot_active[12], -1);
	TextDrawSetShadow(klado_slot_active[12], 0);
	TextDrawSetOutline(klado_slot_active[12], 0);
	TextDrawFont(klado_slot_active[12], 4);
	TextDrawSetSelectable(klado_slot_active[12], true);

	klado_slot_active[13] = TextDrawCreate(269.200000, 177.200000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[13], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[13], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[13], 1);
	TextDrawColor(klado_slot_active[13], -1);
	TextDrawSetShadow(klado_slot_active[13], 0);
	TextDrawSetOutline(klado_slot_active[13], 0);
	TextDrawFont(klado_slot_active[13], 4);
	TextDrawSetSelectable(klado_slot_active[13], true);

	klado_slot_active[14] = TextDrawCreate(343.000000, 177.200000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[14], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[14], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[14], 1);
	TextDrawColor(klado_slot_active[14], -1);
	TextDrawSetShadow(klado_slot_active[14], 0);
	TextDrawSetOutline(klado_slot_active[14], 0);
	TextDrawFont(klado_slot_active[14], 4);
	TextDrawSetSelectable(klado_slot_active[14], true);

	klado_slot_active[15] = TextDrawCreate(416.800000, 177.200000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[15], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[15], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[15], 1);
	TextDrawColor(klado_slot_active[15], -1);
	TextDrawSetShadow(klado_slot_active[15], 0);
	TextDrawSetOutline(klado_slot_active[15], 0);
	TextDrawFont(klado_slot_active[15], 4);
	TextDrawSetSelectable(klado_slot_active[15], true);



	klado_slot_active[16] = TextDrawCreate(123.999999, 239.000000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[16], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[16], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[16], 1);
	TextDrawColor(klado_slot_active[16], -1);
	TextDrawSetShadow(klado_slot_active[16], 0);
	TextDrawSetOutline(klado_slot_active[16], 0);
	TextDrawFont(klado_slot_active[16], 4);
	TextDrawSetSelectable(klado_slot_active[16], true);

	klado_slot_active[17] = TextDrawCreate(196.199999, 239.000000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[17], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[17], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[17], 1);
	TextDrawColor(klado_slot_active[17], -1);
	TextDrawSetShadow(klado_slot_active[17], 0);
	TextDrawSetOutline(klado_slot_active[17], 0);
	TextDrawFont(klado_slot_active[17], 4);
	TextDrawSetSelectable(klado_slot_active[17], true);

	klado_slot_active[18] = TextDrawCreate(269.200000, 239.000000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[18], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[18], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[18], 1);
	TextDrawColor(klado_slot_active[18], -1);
	TextDrawSetShadow(klado_slot_active[18], 0);
	TextDrawSetOutline(klado_slot_active[18], 0);
	TextDrawFont(klado_slot_active[18], 4);
	TextDrawSetSelectable(klado_slot_active[18], true);

	klado_slot_active[19] = TextDrawCreate(343.000000, 239.000000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[19], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[19], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[19], 1);
	TextDrawColor(klado_slot_active[19], -1);
	TextDrawSetShadow(klado_slot_active[19], 0);
	TextDrawSetOutline(klado_slot_active[19], 0);
	TextDrawFont(klado_slot_active[19], 4);
	TextDrawSetSelectable(klado_slot_active[19], true);



	klado_slot_active[20] = TextDrawCreate(416.800000, 239.000000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[20], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[20], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[20], 1);
	TextDrawColor(klado_slot_active[20], -1);
	TextDrawSetShadow(klado_slot_active[20], 0);
	TextDrawSetOutline(klado_slot_active[20], 0);
	TextDrawFont(klado_slot_active[20], 4);
	TextDrawSetSelectable(klado_slot_active[20], true);


	klado_slot_active[21] = TextDrawCreate(123.999999, 300.800000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[21], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[21], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[21], 1);
	TextDrawColor(klado_slot_active[21], -1);
	TextDrawSetShadow(klado_slot_active[21], 0);
	TextDrawSetOutline(klado_slot_active[21], 0);
	TextDrawFont(klado_slot_active[21], 4);
	TextDrawSetSelectable(klado_slot_active[21], true);

	klado_slot_active[22] = TextDrawCreate(196.199999, 300.800000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[22], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[22], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[22], 1);
	TextDrawColor(klado_slot_active[22], -1);
	TextDrawSetShadow(klado_slot_active[22], 0);
	TextDrawSetOutline(klado_slot_active[22], 0);
	TextDrawFont(klado_slot_active[22], 4);
	TextDrawSetSelectable(klado_slot_active[22], true);

	klado_slot_active[23] = TextDrawCreate(269.200000, 300.800000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[23], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[23], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[23], 1);
	TextDrawColor(klado_slot_active[23], -1);
	TextDrawSetShadow(klado_slot_active[23], 0);
	TextDrawSetOutline(klado_slot_active[23], 0);
	TextDrawFont(klado_slot_active[23], 4);
	TextDrawSetSelectable(klado_slot_active[23], true);

	klado_slot_active[24] = TextDrawCreate(343.000000, 300.800000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[24], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[24], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[24], 1);
	TextDrawColor(klado_slot_active[24], -1);
	TextDrawSetShadow(klado_slot_active[24], 0);
	TextDrawSetOutline(klado_slot_active[24], 0);
	TextDrawFont(klado_slot_active[24], 4);
	TextDrawSetSelectable(klado_slot_active[24], true);

	klado_slot_active[25] = TextDrawCreate(416.800000, 300.800000, "kbassklado:kbasszemlyagreen");
	TextDrawLetterSize(klado_slot_active[25], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_active[25], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_active[25], 1);
	TextDrawColor(klado_slot_active[25], -1);
	TextDrawSetShadow(klado_slot_active[25], 0);
	TextDrawSetOutline(klado_slot_active[25], 0);
	TextDrawFont(klado_slot_active[25], 4);
	TextDrawSetSelectable(klado_slot_active[25], true);





	//БОМБЫ
	klado_slot_bomb[1] = TextDrawCreate(123.999999, 54.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[1], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[1], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[1], 1);
	TextDrawColor(klado_slot_bomb[1], -1);
	TextDrawSetShadow(klado_slot_bomb[1], 0);
	TextDrawSetOutline(klado_slot_bomb[1], 0);
	TextDrawFont(klado_slot_bomb[1], 4);
	TextDrawSetSelectable(klado_slot_bomb[1], true);

	klado_slot_bomb[2] = TextDrawCreate(196.199999, 54.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[2], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[2], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[2], 1);
	TextDrawColor(klado_slot_bomb[2], -1);
	TextDrawSetShadow(klado_slot_bomb[2], 0);
	TextDrawSetOutline(klado_slot_bomb[2], 0);
	TextDrawFont(klado_slot_bomb[2], 4);
	TextDrawSetSelectable(klado_slot_bomb[2], true);

	klado_slot_bomb[3] = TextDrawCreate(269.200000, 54.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[3], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[3], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[3], 1);
	TextDrawColor(klado_slot_bomb[3], -1);
	TextDrawSetShadow(klado_slot_bomb[3], 0);
	TextDrawSetOutline(klado_slot_bomb[3], 0);
	TextDrawFont(klado_slot_bomb[3], 4);
	TextDrawSetSelectable(klado_slot_bomb[3], true);

	klado_slot_bomb[4] = TextDrawCreate(343.000000, 54.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[4], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[4], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[4], 1);
	TextDrawColor(klado_slot_bomb[4], -1);
	TextDrawSetShadow(klado_slot_bomb[4], 0);
	TextDrawSetOutline(klado_slot_bomb[4], 0);
	TextDrawFont(klado_slot_bomb[4], 4);
	TextDrawSetSelectable(klado_slot_bomb[4], true);

	klado_slot_bomb[5] = TextDrawCreate(416.800000, 54.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[5], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[5], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[5], 1);
	TextDrawColor(klado_slot_bomb[5], -1);
	TextDrawSetShadow(klado_slot_bomb[5], 0);
	TextDrawSetOutline(klado_slot_bomb[5], 0);
	TextDrawFont(klado_slot_bomb[5], 4);
	TextDrawSetSelectable(klado_slot_bomb[5], true);



 	klado_slot_bomb[6] = TextDrawCreate(123.999999, 115.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[6], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[6], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[6], 1);
	TextDrawColor(klado_slot_bomb[6], -1);
	TextDrawSetShadow(klado_slot_bomb[6], 0);
	TextDrawSetOutline(klado_slot_bomb[6], 0);
	TextDrawFont(klado_slot_bomb[6], 4);
	TextDrawSetSelectable(klado_slot_bomb[6], true);

	klado_slot_bomb[7] = TextDrawCreate(196.199999, 115.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[7], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[7], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[7], 1);
	TextDrawColor(klado_slot_bomb[7], -1);
	TextDrawSetShadow(klado_slot_bomb[7], 0);
	TextDrawSetOutline(klado_slot_bomb[7], 0);
	TextDrawFont(klado_slot_bomb[7], 4);
	TextDrawSetSelectable(klado_slot_bomb[7], true);

	klado_slot_bomb[8] = TextDrawCreate(269.200000, 115.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[8], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[8], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[8], 1);
	TextDrawColor(klado_slot_bomb[8], -1);
	TextDrawSetShadow(klado_slot_bomb[8], 0);
	TextDrawSetOutline(klado_slot_bomb[8], 0);
	TextDrawFont(klado_slot_bomb[8], 4);
	TextDrawSetSelectable(klado_slot_bomb[8], true);

	klado_slot_bomb[9] = TextDrawCreate(343.000000, 115.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[9], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[9], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[9], 1);
	TextDrawColor(klado_slot_bomb[9], -1);
	TextDrawSetShadow(klado_slot_bomb[9], 0);
	TextDrawSetOutline(klado_slot_bomb[9], 0);
	TextDrawFont(klado_slot_bomb[9], 4);
	TextDrawSetSelectable(klado_slot_bomb[9], true);

	klado_slot_bomb[10] = TextDrawCreate(416.800000, 115.500000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[10], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[10], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[10], 1);
	TextDrawColor(klado_slot_bomb[10], -1);
	TextDrawSetShadow(klado_slot_bomb[10], 0);
	TextDrawSetOutline(klado_slot_bomb[10], 0);
	TextDrawFont(klado_slot_bomb[10], 4);
	TextDrawSetSelectable(klado_slot_bomb[10], true);



	klado_slot_bomb[11] = TextDrawCreate(123.999999, 177.200000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[11], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[11], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[11], 1);
	TextDrawColor(klado_slot_bomb[11], -1);
	TextDrawSetShadow(klado_slot_bomb[11], 0);
	TextDrawSetOutline(klado_slot_bomb[11], 0);
	TextDrawFont(klado_slot_bomb[11], 4);
	TextDrawSetSelectable(klado_slot_bomb[11], true);

	klado_slot_bomb[12] = TextDrawCreate(196.199999, 177.200000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[12], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[12], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[12], 1);
	TextDrawColor(klado_slot_bomb[12], -1);
	TextDrawSetShadow(klado_slot_bomb[12], 0);
	TextDrawSetOutline(klado_slot_bomb[12], 0);
	TextDrawFont(klado_slot_bomb[12], 4);
	TextDrawSetSelectable(klado_slot_bomb[12], true);

	klado_slot_bomb[13] = TextDrawCreate(269.200000, 177.200000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[13], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[13], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[13], 1);
	TextDrawColor(klado_slot_bomb[13], -1);
	TextDrawSetShadow(klado_slot_bomb[13], 0);
	TextDrawSetOutline(klado_slot_bomb[13], 0);
	TextDrawFont(klado_slot_bomb[13], 4);
	TextDrawSetSelectable(klado_slot_bomb[13], true);

	klado_slot_bomb[14] = TextDrawCreate(343.000000, 177.200000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[14], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[14], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[14], 1);
	TextDrawColor(klado_slot_bomb[14], -1);
	TextDrawSetShadow(klado_slot_bomb[14], 0);
	TextDrawSetOutline(klado_slot_bomb[14], 0);
	TextDrawFont(klado_slot_bomb[14], 4);
	TextDrawSetSelectable(klado_slot_bomb[14], true);

	klado_slot_bomb[15] = TextDrawCreate(416.800000, 177.200000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[15], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[15], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[15], 1);
	TextDrawColor(klado_slot_bomb[15], -1);
	TextDrawSetShadow(klado_slot_bomb[15], 0);
	TextDrawSetOutline(klado_slot_bomb[15], 0);
	TextDrawFont(klado_slot_bomb[15], 4);
	TextDrawSetSelectable(klado_slot_bomb[15], true);



	klado_slot_bomb[16] = TextDrawCreate(123.999999, 239.000000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[16], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[16], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[16], 1);
	TextDrawColor(klado_slot_bomb[16], -1);
	TextDrawSetShadow(klado_slot_bomb[16], 0);
	TextDrawSetOutline(klado_slot_bomb[16], 0);
	TextDrawFont(klado_slot_bomb[16], 4);
	TextDrawSetSelectable(klado_slot_bomb[16], true);

	klado_slot_bomb[17] = TextDrawCreate(196.199999, 239.000000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[17], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[17], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[17], 1);
	TextDrawColor(klado_slot_bomb[17], -1);
	TextDrawSetShadow(klado_slot_bomb[17], 0);
	TextDrawSetOutline(klado_slot_bomb[17], 0);
	TextDrawFont(klado_slot_bomb[17], 4);
	TextDrawSetSelectable(klado_slot_bomb[17], true);

	klado_slot_bomb[18] = TextDrawCreate(269.200000, 239.000000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[18], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[18], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[18], 1);
	TextDrawColor(klado_slot_bomb[18], -1);
	TextDrawSetShadow(klado_slot_bomb[18], 0);
	TextDrawSetOutline(klado_slot_bomb[18], 0);
	TextDrawFont(klado_slot_bomb[18], 4);
	TextDrawSetSelectable(klado_slot_bomb[18], true);

	klado_slot_bomb[19] = TextDrawCreate(343.000000, 239.000000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[19], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[19], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[19], 1);
	TextDrawColor(klado_slot_bomb[19], -1);
	TextDrawSetShadow(klado_slot_bomb[19], 0);
	TextDrawSetOutline(klado_slot_bomb[19], 0);
	TextDrawFont(klado_slot_bomb[19], 4);
	TextDrawSetSelectable(klado_slot_bomb[19], true);

	klado_slot_bomb[20] = TextDrawCreate(416.800000, 239.000000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[20], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[20], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[20], 1);
	TextDrawColor(klado_slot_bomb[20], -1);
	TextDrawSetShadow(klado_slot_bomb[20], 0);
	TextDrawSetOutline(klado_slot_bomb[20], 0);
	TextDrawFont(klado_slot_bomb[20], 4);
	TextDrawSetSelectable(klado_slot_bomb[20], true);



	klado_slot_bomb[21] = TextDrawCreate(123.999999, 300.800000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[21], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[21], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[21], 1);
	TextDrawColor(klado_slot_bomb[21], -1);
	TextDrawSetShadow(klado_slot_bomb[21], 0);
	TextDrawSetOutline(klado_slot_bomb[21], 0);
	TextDrawFont(klado_slot_bomb[21], 4);
	TextDrawSetSelectable(klado_slot_bomb[21], true);

	klado_slot_bomb[22] = TextDrawCreate(196.199999, 300.800000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[22], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[22], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[22], 1);
	TextDrawColor(klado_slot_bomb[22], -1);
	TextDrawSetShadow(klado_slot_bomb[22], 0);
	TextDrawSetOutline(klado_slot_bomb[22], 0);
	TextDrawFont(klado_slot_bomb[22], 4);
	TextDrawSetSelectable(klado_slot_bomb[22], true);

	klado_slot_bomb[23] = TextDrawCreate(269.200000, 300.800000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[23], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[23], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[23], 1);
	TextDrawColor(klado_slot_bomb[23], -1);
	TextDrawSetShadow(klado_slot_bomb[23], 0);
	TextDrawSetOutline(klado_slot_bomb[23], 0);
	TextDrawFont(klado_slot_bomb[23], 4);
	TextDrawSetSelectable(klado_slot_bomb[23], true);

	klado_slot_bomb[24] = TextDrawCreate(343.000000, 300.800000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[24], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[24], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[24], 1);
	TextDrawColor(klado_slot_bomb[24], -1);
	TextDrawSetShadow(klado_slot_bomb[24], 0);
	TextDrawSetOutline(klado_slot_bomb[24], 0);
	TextDrawFont(klado_slot_bomb[24], 4);
	TextDrawSetSelectable(klado_slot_bomb[24], true);

	klado_slot_bomb[25] = TextDrawCreate(416.800000, 300.800000, "kbassklado:kbassbomb");
	TextDrawLetterSize(klado_slot_bomb[25], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_bomb[25], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_bomb[25], 1);
	TextDrawColor(klado_slot_bomb[25], -1);
	TextDrawSetShadow(klado_slot_bomb[25], 0);
	TextDrawSetOutline(klado_slot_bomb[25], 0);
	TextDrawFont(klado_slot_bomb[25], 4);
	TextDrawSetSelectable(klado_slot_bomb[25], true);





	//БОМБЫ
	klado_slot_klad[1] = TextDrawCreate(123.999999, 54.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[1], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[1], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[1], 1);
	TextDrawColor(klado_slot_klad[1], -1);
	TextDrawSetShadow(klado_slot_klad[1], 0);
	TextDrawSetOutline(klado_slot_klad[1], 0);
	TextDrawFont(klado_slot_klad[1], 4);
	TextDrawSetSelectable(klado_slot_klad[1], true);

	klado_slot_klad[2] = TextDrawCreate(196.199999, 54.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[2], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[2], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[2], 1);
	TextDrawColor(klado_slot_klad[2], -1);
	TextDrawSetShadow(klado_slot_klad[2], 0);
	TextDrawSetOutline(klado_slot_klad[2], 0);
	TextDrawFont(klado_slot_klad[2], 4);
	TextDrawSetSelectable(klado_slot_klad[2], true);

	klado_slot_klad[3] = TextDrawCreate(269.200000, 54.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[3], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[3], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[3], 1);
	TextDrawColor(klado_slot_klad[3], -1);
	TextDrawSetShadow(klado_slot_klad[3], 0);
	TextDrawSetOutline(klado_slot_klad[3], 0);
	TextDrawFont(klado_slot_klad[3], 4);
	TextDrawSetSelectable(klado_slot_klad[3], true);

	klado_slot_klad[4] = TextDrawCreate(343.000000, 54.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[4], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[4], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[4], 1);
	TextDrawColor(klado_slot_klad[4], -1);
	TextDrawSetShadow(klado_slot_klad[4], 0);
	TextDrawSetOutline(klado_slot_klad[4], 0);
	TextDrawFont(klado_slot_klad[4], 4);
	TextDrawSetSelectable(klado_slot_klad[4], true);

	klado_slot_klad[5] = TextDrawCreate(416.800000, 54.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[5], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[5], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[5], 1);
	TextDrawColor(klado_slot_klad[5], -1);
	TextDrawSetShadow(klado_slot_klad[5], 0);
	TextDrawSetOutline(klado_slot_klad[5], 0);
	TextDrawFont(klado_slot_klad[5], 4);
	TextDrawSetSelectable(klado_slot_klad[5], true);




 	klado_slot_klad[6] = TextDrawCreate(123.999999, 115.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[6], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[6], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[6], 1);
	TextDrawColor(klado_slot_klad[6], -1);
	TextDrawSetShadow(klado_slot_klad[6], 0);
	TextDrawSetOutline(klado_slot_klad[6], 0);
	TextDrawFont(klado_slot_klad[6], 4);
	TextDrawSetSelectable(klado_slot_klad[6], true);

	klado_slot_klad[7] = TextDrawCreate(196.199999, 115.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[7], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[7], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[7], 1);
	TextDrawColor(klado_slot_klad[7], -1);
	TextDrawSetShadow(klado_slot_klad[7], 0);
	TextDrawSetOutline(klado_slot_klad[7], 0);
	TextDrawFont(klado_slot_klad[7], 4);
	TextDrawSetSelectable(klado_slot_klad[7], true);

	klado_slot_klad[8] = TextDrawCreate(269.200000, 115.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[8], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[8], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[8], 1);
	TextDrawColor(klado_slot_klad[8], -1);
	TextDrawSetShadow(klado_slot_klad[8], 0);
	TextDrawSetOutline(klado_slot_klad[8], 0);
	TextDrawFont(klado_slot_klad[8], 4);
	TextDrawSetSelectable(klado_slot_klad[8], true);

	klado_slot_klad[9] = TextDrawCreate(343.000000, 115.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[9], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[9], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[9], 1);
	TextDrawColor(klado_slot_klad[9], -1);
	TextDrawSetShadow(klado_slot_klad[9], 0);
	TextDrawSetOutline(klado_slot_klad[9], 0);
	TextDrawFont(klado_slot_klad[9], 4);
	TextDrawSetSelectable(klado_slot_klad[9], true);

	klado_slot_klad[10] = TextDrawCreate(416.800000, 115.500000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[10], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[10], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[10], 1);
	TextDrawColor(klado_slot_klad[10], -1);
	TextDrawSetShadow(klado_slot_klad[10], 0);
	TextDrawSetOutline(klado_slot_klad[10], 0);
	TextDrawFont(klado_slot_klad[10], 4);
	TextDrawSetSelectable(klado_slot_klad[10], true);




	klado_slot_klad[11] = TextDrawCreate(123.999999, 177.200000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[11], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[11], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[11], 1);
	TextDrawColor(klado_slot_klad[11], -1);
	TextDrawSetShadow(klado_slot_klad[11], 0);
	TextDrawSetOutline(klado_slot_klad[11], 0);
	TextDrawFont(klado_slot_klad[11], 4);
	TextDrawSetSelectable(klado_slot_klad[11], true);

	klado_slot_klad[12] = TextDrawCreate(196.199999, 177.200000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[12], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[12], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[12], 1);
	TextDrawColor(klado_slot_klad[12], -1);
	TextDrawSetShadow(klado_slot_klad[12], 0);
	TextDrawSetOutline(klado_slot_klad[12], 0);
	TextDrawFont(klado_slot_klad[12], 4);
	TextDrawSetSelectable(klado_slot_klad[12], true);

	klado_slot_klad[13] = TextDrawCreate(269.200000, 177.200000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[13], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[13], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[13], 1);
	TextDrawColor(klado_slot_klad[13], -1);
	TextDrawSetShadow(klado_slot_klad[13], 0);
	TextDrawSetOutline(klado_slot_klad[13], 0);
	TextDrawFont(klado_slot_klad[13], 4);
	TextDrawSetSelectable(klado_slot_klad[13], true);

	klado_slot_klad[14] = TextDrawCreate(343.000000, 177.200000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[14], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[14], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[14], 1);
	TextDrawColor(klado_slot_klad[14], -1);
	TextDrawSetShadow(klado_slot_klad[14], 0);
	TextDrawSetOutline(klado_slot_klad[14], 0);
	TextDrawFont(klado_slot_klad[14], 4);
	TextDrawSetSelectable(klado_slot_klad[14], true);

	klado_slot_klad[15] = TextDrawCreate(416.800000, 177.200000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[15], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[15], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[15], 1);
	TextDrawColor(klado_slot_klad[15], -1);
	TextDrawSetShadow(klado_slot_klad[15], 0);
	TextDrawSetOutline(klado_slot_klad[15], 0);
	TextDrawFont(klado_slot_klad[15], 4);
	TextDrawSetSelectable(klado_slot_klad[15], true);






	klado_slot_klad[16] = TextDrawCreate(123.999999, 239.000000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[16], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[16], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[16], 1);
	TextDrawColor(klado_slot_klad[16], -1);
	TextDrawSetShadow(klado_slot_klad[16], 0);
	TextDrawSetOutline(klado_slot_klad[16], 0);
	TextDrawFont(klado_slot_klad[16], 4);
	TextDrawSetSelectable(klado_slot_klad[16], true);

	klado_slot_klad[17] = TextDrawCreate(196.199999, 239.000000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[17], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[17], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[17], 1);
	TextDrawColor(klado_slot_klad[17], -1);
	TextDrawSetShadow(klado_slot_klad[17], 0);
	TextDrawSetOutline(klado_slot_klad[17], 0);
	TextDrawFont(klado_slot_klad[17], 4);
	TextDrawSetSelectable(klado_slot_klad[17], true);

	klado_slot_klad[18] = TextDrawCreate(269.200000, 239.000000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[18], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[18], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[18], 1);
	TextDrawColor(klado_slot_klad[18], -1);
	TextDrawSetShadow(klado_slot_klad[18], 0);
	TextDrawSetOutline(klado_slot_klad[18], 0);
	TextDrawFont(klado_slot_klad[18], 4);
	TextDrawSetSelectable(klado_slot_klad[18], true);

	klado_slot_klad[19] = TextDrawCreate(343.000000, 239.000000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[19], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[19], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[19], 1);
	TextDrawColor(klado_slot_klad[19], -1);
	TextDrawSetShadow(klado_slot_klad[19], 0);
	TextDrawSetOutline(klado_slot_klad[19], 0);
	TextDrawFont(klado_slot_klad[19], 4);
	TextDrawSetSelectable(klado_slot_klad[19], true);

	klado_slot_klad[20] = TextDrawCreate(416.800000, 239.000000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[20], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[20], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[20], 1);
	TextDrawColor(klado_slot_klad[20], -1);
	TextDrawSetShadow(klado_slot_klad[20], 0);
	TextDrawSetOutline(klado_slot_klad[20], 0);
	TextDrawFont(klado_slot_klad[20], 4);
	TextDrawSetSelectable(klado_slot_klad[20], true);









	klado_slot_klad[21] = TextDrawCreate(123.999999, 300.800000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[21], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[21], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[21], 1);
	TextDrawColor(klado_slot_klad[21], -1);
	TextDrawSetShadow(klado_slot_klad[21], 0);
	TextDrawSetOutline(klado_slot_klad[21], 0);
	TextDrawFont(klado_slot_klad[21], 4);
	TextDrawSetSelectable(klado_slot_klad[21], true);

	klado_slot_klad[22] = TextDrawCreate(196.199999, 300.800000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[22], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[22], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[22], 1);
	TextDrawColor(klado_slot_klad[22], -1);
	TextDrawSetShadow(klado_slot_klad[22], 0);
	TextDrawSetOutline(klado_slot_klad[22], 0);
	TextDrawFont(klado_slot_klad[22], 4);
	TextDrawSetSelectable(klado_slot_klad[22], true);

	klado_slot_klad[23] = TextDrawCreate(269.200000, 300.800000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[23], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[23], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[23], 1);
	TextDrawColor(klado_slot_klad[23], -1);
	TextDrawSetShadow(klado_slot_klad[23], 0);
	TextDrawSetOutline(klado_slot_klad[23], 0);
	TextDrawFont(klado_slot_klad[23], 4);
	TextDrawSetSelectable(klado_slot_klad[23], true);

	klado_slot_klad[24] = TextDrawCreate(343.000000, 300.800000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[24], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[24], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[24], 1);
	TextDrawColor(klado_slot_klad[24], -1);
	TextDrawSetShadow(klado_slot_klad[24], 0);
	TextDrawSetOutline(klado_slot_klad[24], 0);
	TextDrawFont(klado_slot_klad[24], 4);
	TextDrawSetSelectable(klado_slot_klad[24], true);

	klado_slot_klad[25] = TextDrawCreate(416.800000, 300.800000, "kbassklado:kbassklad");
	TextDrawLetterSize(klado_slot_klad[25], 0.000000, 0.000000);
	TextDrawTextSize(klado_slot_klad[25], 68.000000, 57.493339);
	TextDrawAlignment(klado_slot_klad[25], 1);
	TextDrawColor(klado_slot_klad[25], -1);
	TextDrawSetShadow(klado_slot_klad[25], 0);
	TextDrawSetOutline(klado_slot_klad[25], 0);
	TextDrawFont(klado_slot_klad[25], 4);
	TextDrawSetSelectable(klado_slot_klad[25], true);
}

stock LoadPlayerTextDraw(playerid)
{
	klado_metal_distance[playerid] = CreatePlayerTextDraw(playerid, 502.400054, 376.319946, "150 M.");
	PlayerTextDrawLetterSize(playerid, 		klado_metal_distance[playerid], 0.368400, 1.697067);
	PlayerTextDrawAlignment(playerid, 		klado_metal_distance[playerid], 2);
	PlayerTextDrawColor(playerid, 			klado_metal_distance[playerid], -1);
	PlayerTextDrawSetShadow(playerid, 		klado_metal_distance[playerid], 0);
	PlayerTextDrawSetOutline(playerid, 		klado_metal_distance[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, klado_metal_distance[playerid], 51);
	PlayerTextDrawFont(playerid, 			klado_metal_distance[playerid], 1);
	PlayerTextDrawSetProportional(playerid, klado_metal_distance[playerid], 1);

	klado_timer[playerid] = CreatePlayerTextDraw(playerid, 272.000152, 415.893188, "1400 CEK.");
	PlayerTextDrawLetterSize(playerid,		klado_timer[playerid], 0.586799, 1.973333);
	PlayerTextDrawAlignment(playerid, 		klado_timer[playerid], 1);
	PlayerTextDrawColor(playerid, 			klado_timer[playerid], 41215);
	PlayerTextDrawSetShadow(playerid, 		klado_timer[playerid], 0);
	PlayerTextDrawSetOutline(playerid, 		klado_timer[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, klado_timer[playerid], 51);
	PlayerTextDrawFont(playerid, 			klado_timer[playerid], 1);
	PlayerTextDrawSetProportional(playerid, klado_timer[playerid], 1);
	
}






/*CMD:testtextdraw(playerid)
{
	TextDrawShowForPlayer(playerid, klado_fon);
	
	for(new i; i < 25; i++)
	{
		TextDrawShowForPlayer(playerid, klado_slot[i]);
	}

	PlayerTextDrawShow(playerid, klado_metal_distance[playerid]);
	PlayerTextDrawShow(playerid, klado_timer[playerid]);
	TextDrawShowForPlayer(playerid, klado_metal);
	return 1;
}
*/


stock CheckPlayerDistanceToPoint(playerid, Float:x, Float:y, Float:z, Float: distance)
{
	if(IsPlayerInRangeOfPoint(playerid, distance, x, y, z)) return 1;
	else return 0;
}

stock IsPlayerInArea(playerid, Float:min_x, Float:min_y ,Float:max_x, Float:max_y)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X <= max_x && X >= min_x && Y <= max_y && Y >= min_y) return 1;
	return 0;
}





CMD:getpos(playerid)
{
    new Float: x,
		Float: y,
		Float: z,
		Float: a, string[100];
	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
		SCM(playerid, CWHITE, "Позиции транспорта:");
	}
	else
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
	}

	format(string, sizeof string, "%f, %f, %f, %f", x, y, z, a);
	SCM(playerid, CWHITE, string);
}

CMD:gotopos(playerid,params[])
{
	new Float:aposx,Float:aposy,Float:aposz;
	if(sscanf(params, "p<,>fff", Float:aposx,Float:aposy,Float:aposz)) return SCM (playerid, CGREEN, "|| "CW"/gotopos [X], [Y], [Z]"CG"||");
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		SetVehiclePos(vehicleid, aposx,aposy,aposz);
		PutPlayerInVehicle(playerid, vehicleid, 0);
	}
	else
	{
		SetPlayerPos(playerid, aposx,aposy,aposz);
	}
	return 1;
}

stock DistancePointToPoint(Float: x, Float: y, Float: z, Float: fx, Float:fy, Float: fz) return floatround(floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2) + floatpower(fz - z, 2)));

