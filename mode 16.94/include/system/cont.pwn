#include 	<a_samp>
#include "../include/a_mysql.inc"
#define FILTERSCRIPT
#include "../include/Pawn.CMD.inc" // -- старое гавно, но нада
#include "../include/Pawn.RakNet.inc" // -- еще хуже чем гавно лол
#include "../include/streamer.inc"
#include "../include/foreach.inc"

//==============================================================================
#define HUD_ELEMENT_HIDE				0
#define HUD_ELEMENT_SHOW				1

#define HUD_ELEMENT_CHAT    			0
#define HUD_ELEMENT_MAP     			1

#include <customhud>

#define ShowNotification snot
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

#define randomEx(%0,%1) (%0+random(%1-%0))

#define SCM 			SendClientMessage
#define SCMTA   		SendClientMessageToAll
#define SPD         	ShowPlayerDialog
//------------------------------------------------------------------------------
#define		DSI		DIALOG_STYLE_INPUT
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST
#define 	DSP		DIALOG_STYLE_PASSWORD
#define 	DST		DIALOG_STYLE_TABLIST








new DBconnectID;






#define MAX_CONT 12


new Text3D:ContsText[MAX_CONT+1];
new ContsZone[MAX_CONT+1];
new ContsTimer[MAX_CONT+1];

new Text:cont_fon;
new Text:cont_take;
new Text:cont_sell;
new Text:cont_close;

new Text:cont_name[MAX_CONT+1];
new Text:cont_price[MAX_CONT+1];
new Text:cont_model[MAX_CONT+1];

enum P_Info
{
	BetUseCont,
	BuyUseCont,
}
new pInfo[MAX_PLAYERS][P_Info];

enum Cont_Info
{
	Id,
	
	ContObjectId,
	ContObjectDoorLId,
	ContObjectDoorRId,
	ContObjectOdejdaId,
	
	ContVehicleId,
	ContVehicleColor,
	
	ContModelId,
	ContModelDoorId,
	
	ContRegion,
	ItemType,
		 	//1 - ТС
			//2 - Одежда
			//...
	Item,
	
	ContPrice,
	ItemPrice,
	
	bool:Saled,
	SaleTime,
	
	BetPrice,
	BetedId,
	BetedName[MAX_PLAYER_NAME],
};
new cInfo[MAX_CONT+1][Cont_Info];


enum Cont_Item_Structure
{
	Type,
			//1 - Одежда
		 	//2 - ТС
			//...
	ItemId,
	Name[30],
	
	ContPrice, //Цена конта
	ItemPrice, //Цена конта
}
/*static const cItem_Info[5][10][Cont_Item_Structure] =
{
	{ {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0}, {0, 0, "", 0, 0} }, //by KBASs
	
	{ //RUS
		{2, 404, "Шаха нахуй", 100000,  140000},
		{2, 555, "ЛЕГЕНДА СССР", 100000,  20000},
		{1, 122, "Соска", 2000000, 2200000},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0}
	},
	
	{ //China
        {2, 430, "Шедевро плыви нахуй", 2000000,  1400000},
        {2, 478, "Китайский хуй", 2000000,  1250000},
		{2, 523, "Suzuki GSX-R", 9000000,  9100000},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0}
	},
	
	{ //Dubai
        {2, 466, "BMW M5 F90", 9000000,  8910000},
        {2, 490, "Range Rover", 9000000,  8100000},
        {1, 300, "БАГАТИЧЕЛ", 9000000, 10000000},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0}
	}, 
	
	{ //Germania
		{2, 400, "BMW X6M", 4350000,  6000000},
		{2, 402, "Mercedes Benz GT63s", 4350000, 7800000},
		{2, 480, "BMW Z4", 4350000, 2700000},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0},
		{0, 0, "", 0, 0}
	} 
};*/
new cItem_Info[5][10][Cont_Item_Structure];
new cItem_InfoSize[5];


new Float: ContBuyTextPos[MAX_CONT+1][3] =
{
	{0.0,0.0,0.0},
	{683.51898, 1738.27002, 14.73000},
	{683.51898, 1731.78003, 14.73000},
	{665.81897, 1733.96997, 14.73000},
	{680.23999, 1701.77002, 14.73000},
	{672.75598, 1701.77002, 14.73000},
	{665.81897, 1701.77002, 14.73000},
	{648.51898, 1676.51001, 14.73000},
	{648.51898, 1669.80005, 14.73000},
	{648.51898, 1663.40002, 14.73000},
	{638.91901, 1709.30005, 14.73000},
	{638.91901, 1702.55005, 14.73000},
	{638.91901, 1695.93994, 14.73000}
};










main()
{
    new a[][] =     {"Unarmed (Fist)","Brass K"};
	#pragma unused a
}

//public OnGameModeInit()
public OnFilterScriptInit()
{

    print("--------------------------------------");
    print("         Система КОНТЫ by KBAS's");
    print("--------------------------------------\n");
	
	LoadTextDraw();
	
 	for(new cont=1; cont < MAX_CONT+1; cont++)
 	{
 		cInfo[cont][BetedId] = 1000;
 		ContsText[cont] = CreateDynamic3DTextLabel("", CWHITE, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2], 4.0);
 		ContsZone[cont] = CreateDynamicCircle(ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], 3.0, 0, 0, -1);
	}
	SetTimer("CorrectTimerMinute", 1000, false);
	return 1;
}
public OnFilterScriptExit()
{
	StopCont();
	return 1;
}
public OnPlayerConnect(playerid)
{
    pInfo[playerid][BetUseCont] = 0;
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 19996)
	{
		if(response)
		{
		    new cont = pInfo[playerid][BetUseCont];
			if(cont == 0) return printf("ERROR PLAYERID: %d (contuse == 0)");
			if(cInfo[cont][Saled] == true)
			{
				if(cInfo[cont][BetedId] == playerid) return SCM(playerid, CLRED, "| "CW"Ставка на контейнер уже ваша, вы не можете перебить свою ставку");
				if(0 < strval(inputtext) < 100000000)
				{
				    if(GetPlayerMoney(playerid) >= strval(inputtext))
				    {
				        if(strval(inputtext)-99999 > cInfo[cont][BetPrice])
				        {
							if(strval(inputtext) > cInfo[cont][ContPrice] && strval(inputtext) > cInfo[cont][BetPrice])
							{
								new strkbass[111];
								new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);

								if(cInfo[cont][BetedId] < 1000 || cInfo[cont][ContPrice] != cInfo[cont][BetPrice])
								{
								    format(strkbass, sizeof strkbass, "| "CW"Ваша ставка была отменена в связи с тем, что игрок "CLR"%s "CW"поставил больше!", name);
								    SCM(cInfo[cont][BetedId], CLRED, strkbass);
								}

								cInfo[cont][BetPrice] = strval(inputtext);
			                    cInfo[cont][BetedId] = playerid;
								format(cInfo[cont][BetedName], MAX_PLAYER_NAME, "%s", name);
								cInfo[cont][SaleTime] = 30;

								new betstr[10];
								ConvertMoney(cInfo[cont][BetPrice], betstr);
								format(strkbass, sizeof strkbass, "| "CW"Вы успешно сделали ставку в размере "CY"%s "CW"рублей за контейнер "CY"#%d", betstr, cont);
								SCM(playerid, CYELLOW, strkbass);
							}
							else
							{
								new strkbass[140], betstr[10];
								ConvertMoney(cInfo[cont][BetPrice], betstr);
								format(strkbass, sizeof strkbass, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
							    SPD(playerid, 19996, DSI, ""CLR"KBR ONLINE "CW"| Битва за контейнер", strkbass,  "Готово", "Отмена");
								SCM(playerid, CLRED, "| "CW"Ваша ставка должна быть выше последней!");
							}
						}
						else
						{
							new strkbass[140], betstr[10];
							ConvertMoney(cInfo[cont][BetPrice], betstr);
							format(strkbass, sizeof strkbass, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
						    SPD(playerid, 19996, DSI, ""CLR"KBR ONLINE "CW"| Битва за контейнер", strkbass,  "Готово", "Отмена");
							SCM(playerid, CLRED, "| "CW"Минимальный подьем ставки 100.000 рублей!");
						}
					}
					else
					{
						new strkbass[140], betstr[10];
						ConvertMoney(cInfo[cont][BetPrice], betstr);
						format(strkbass, sizeof strkbass, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
					    SPD(playerid, 19996, DSI, ""CLR"KBR ONLINE "CW"| Битва за контейнер", strkbass,  "Готово", "Отмена");
					    SCM(playerid, CLRED, "| "CW"У вас недостаточно средств для такой ставки!");
					}
				}
				else
				{
					new strkbass[140], betstr[10];
					ConvertMoney(cInfo[cont][BetPrice], betstr);
					format(strkbass, sizeof strkbass, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
				    SPD(playerid, 19996, DSI, ""CLR"KBR ONLINE "CW"| Битва за контейнер", strkbass,  "Готово", "Отмена");
				    SCM(playerid, CLRED, "| "CW"Введите корректную ставку!");
				}
			}
		}
	}
	return pInfo[playerid][BetUseCont] = 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == cont_sell)
    {
    	new cont = pInfo[playerid][BuyUseCont];
    	if(CheckPlayerDistanceToPoint(playerid, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2], 4.0) && cInfo[cont][Saled] == false)
		{
			if(cInfo[cont][BetedId] == playerid)
			{
	 			GivePlayerMoney(playerid, cInfo[cont][ItemPrice]);

				TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

				TextDrawHideForPlayer(playerid, cont_fon);
				TextDrawHideForPlayer(playerid, cont_take);
				TextDrawHideForPlayer(playerid, cont_sell);
				TextDrawHideForPlayer(playerid, cont_close);

				TextDrawHideForPlayer(playerid, cont_name[cont]);
				TextDrawHideForPlayer(playerid, cont_price[cont]);
				TextDrawHideForPlayer(playerid, cont_model[cont]);
				CancelSelectTextDraw(playerid);


			    DestroyObject(cInfo[cont][ContObjectId]);
			    DestroyObject(cInfo[cont][ContObjectOdejdaId]);
				DestroyVehicle(cInfo[cont][ContVehicleId]);
			    KillTimer(ContsTimer[cont]);
				ResetContInfo(cont);
			}
		}
    }
    if(clickedid == cont_take) return 1; //SCM(playerid, CYELLOW, "| "CW"Данная функция недоступна ;3 "CY"| "CW"by KBAS's");
    
	if(clickedid == cont_close)
	{
		TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

		TextDrawHideForPlayer(playerid, cont_fon);
		TextDrawHideForPlayer(playerid, cont_take);
		TextDrawHideForPlayer(playerid, cont_sell);
		TextDrawHideForPlayer(playerid, cont_close);
		CancelSelectTextDraw(playerid);

    	for(new cont=1; cont < MAX_CONT+1; cont++)
		{
			TextDrawHideForPlayer(playerid, cont_name[cont]);
			TextDrawHideForPlayer(playerid, cont_price[cont]);
			TextDrawHideForPlayer(playerid, cont_model[cont]);
		}
	}
    return 1;
}




forward TimerSecondUpdateCont(contid);
public TimerSecondUpdateCont(contid)
{
	new hour, minute;
	gettime(hour, minute);
	if(!(8 < hour < 23)) return 0;
	//if(!(30 < minute < 40)) return 0;
	if(cInfo[contid][Saled] == false) return 0;
	if(cInfo[contid][BetedId] < 1000)
	{
	    if(cInfo[contid][SaleTime] > 1)
	    {
        	cInfo[contid][SaleTime]--;

            new regionstr[9];
			switch(cInfo[contid][ContRegion])
			{
			    case 1: format(regionstr, sizeof regionstr, "Россия");
			    case 2: format(regionstr, sizeof regionstr, "Китай"); 
			    case 3: format(regionstr, sizeof regionstr, "Дубай");
			    case 4: format(regionstr, sizeof regionstr, "Германия");
			}

            new typestr[22];
    		if(cInfo[contid][ItemType] == 1)
			{
				format(typestr, sizeof typestr, "Одежда");
			}
			else
			{
				format(typestr, sizeof typestr, "Транспортное средство");
				if(cInfo[contid][SaleTime] == 1)
				{
				    cInfo[contid][ContVehicleColor] = randomEx(1, 7);
				    TextDrawSetPreviewVehCol(cont_model[contid], cInfo[contid][ContVehicleColor], 1);
				    switch(contid)
			 		{
						case 1: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 690.51898, 1738.27002, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
						case 2: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 690.51898, 1731.78003, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
						case 3: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 665.81897, 1726.96997, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
						case 4: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 680.23999, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
						case 5: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 672.75598, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
						case 6: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 665.81897, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
						case 7: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 655.51898, 1676.51001, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
						case 8: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 655.51898, 1669.80005, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
						case 9: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 655.51898, 1663.40002, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
						case 10: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 631.91901, 1709.30005, 14.73000, 270, cInfo[contid][ContVehicleColor], 1, 0);
						case 11: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 631.91901, 1702.55005, 14.73000, 270, cInfo[contid][ContVehicleColor], 1, 0);
						case 12: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 631.91901, 1695.93994, 14.73000, 270, cInfo[contid][ContVehicleColor], 1, 0);
					}
					SetVehicleParamsEx(cInfo[contid][ContVehicleId], false, false, false, true, false, false, false);
				}
			}
			
			new moneystr[10], betstr[11];
			ConvertMoney(cInfo[contid][ContPrice], moneystr);
			ConvertMoney(cInfo[contid][BetPrice], betstr);

			new strkbass[366];
			format(strkbass, sizeof strkbass, "Контейнер #%d\n\nСтрана отправитель: "CW"%s\n"CLR"Содержимое контейнера: "CW"%s\n"CLR"Статус: "CW"идут активные торги\n"CLR"Последняя ставка: "CW"%s рублей\n"CLR"Начальная ставка: "CW"%s рублей\n"CLR"Ставка сделана от: "CW"%s\n"CLR"До конца торгов осталось: "CW"%d секунд", contid, regionstr, typestr, betstr, moneystr, cInfo[contid][BetedName], cInfo[contid][SaleTime]);
		    UpdateDynamic3DTextLabelText(ContsText[contid], CLRED, strkbass);
	    }
	    else
		{
			new strkbass[90];
			format(strkbass, sizeof strkbass, "| "CW"Поздравляем с безупречной победой в торгах за контейнер "CY"#%d.", contid);
		    SCM(cInfo[contid][BetedId], CYELLOW, strkbass);
		    
		    new betstr[10]; ConvertMoney(cInfo[contid][BetPrice], betstr);
		    format(strkbass, sizeof strkbass, "| "CW"За победу в торгах со счета было списано: "CY"%s "CW"рублей.", betstr);
		    SCM(cInfo[contid][BetedId], CYELLOW, strkbass);
		    
		    GivePlayerMoney(cInfo[contid][BetedId], -cInfo[contid][BetPrice]);
		    
		    cInfo[contid][Saled] = false;

	        DestroyObject(cInfo[contid][ContObjectDoorLId]);
	        DestroyObject(cInfo[contid][ContObjectDoorRId]);
		    
		    UpdateDynamic3DTextLabelText(ContsText[contid], CLRED, "");
			KillTimer(ContsTimer[contid]);
		}
	}
	return 1;
}

forward CorrectTimerMinute(); //Калибровка времени для точности в секундах
public CorrectTimerMinute()
{
	new hour, minute, second;
	gettime(hour, minute, second);
	if(second == 0) SetTimer("TimerMinuteUpdatePort", 60000, true);
	else SetTimer("CorrectTimerMinute", 1000, false);
	return 1;
}


forward TimerMinuteUpdatePort();
public TimerMinuteUpdatePort()
{
	new hour, minute;
	gettime(hour, minute);
	if(8 < hour < 24)
	{
		if(minute == 20) return SCMTA(CYELLOW, "| ВНИМАНИЕ | Через 10 минут в порт будет доставлена партия контейнеров.");
	    if(minute == 30) StartCont();
		if(minute == 40) StopCont();
	}
	return 1;
}

stock StartCont()
{
	print("=== Доставка контейнеров в порт | by KBAS's ===");
    StopCont();
    for(new cont=1; cont < MAX_CONT+1; cont++)
    {
	    SpawnCont(cont);
	}
	

	foreach(new i:Player)
	{
		CancelSelectTextDraw(i);
		TogglePlayerHudElement(i, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
		TogglePlayerHudElement(i, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
	}
}

stock StopCont()
{
	for(new cont=1; cont < MAX_CONT+1; cont++)
    {
	    DestroyObject(cInfo[cont][ContObjectId]);
	    DestroyObject(cInfo[cont][ContObjectDoorLId]);
	    DestroyObject(cInfo[cont][ContObjectDoorRId]);
	    DestroyObject(cInfo[cont][ContObjectOdejdaId]);
		DestroyVehicle(cInfo[cont][ContVehicleId]);
	    UpdateDynamic3DTextLabelText(ContsText[cont], CLRED, "");
	    KillTimer(ContsTimer[cont]);
		ResetContInfo(cont);

		TextDrawHideForAll(cont_name[cont]);
		TextDrawHideForAll(cont_price[cont]);
		TextDrawHideForAll(cont_model[cont]);
	}



	TextDrawHideForAll(cont_fon);
	TextDrawHideForAll(cont_take);
	TextDrawHideForAll(cont_sell);
	TextDrawHideForAll(cont_close);


	foreach(new i:Player)
	{
		CancelSelectTextDraw(i);
		TogglePlayerHudElement(i, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
		TogglePlayerHudElement(i, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
	}
}

stock ResetContInfo(contid)
{
    cInfo[contid][ContModelId] = 18639;
    cInfo[contid][ContModelDoorId] = 18639;
    cInfo[contid][ContVehicleColor] = 0;
    cInfo[contid][ContRegion] = 0;
    cInfo[contid][ItemType] = 0;
    cInfo[contid][Item] = 0;
    cInfo[contid][ContPrice] = 0;
    cInfo[contid][ItemPrice] = 0;
    cInfo[contid][Saled] = false;
    cInfo[contid][SaleTime] = 30;
    
    cInfo[contid][BetPrice] = 0;
    cInfo[contid][BetedId] = 1000;
    cInfo[contid][BetedName] = EOS;
}




stock SpawnCont(contid)
{
	cInfo[contid][ContRegion] = randomEx(1, 5);
	new regionstr[9];
	switch(cInfo[contid][ContRegion])
	{
	    case 1: { cInfo[contid][ContModelId] = 934; cInfo[contid][ContModelDoorId] = 933; format(regionstr, sizeof regionstr, "Россия"); }//RUS
	    case 2: { cInfo[contid][ContModelId] = 954; cInfo[contid][ContModelDoorId] = 953; format(regionstr, sizeof regionstr, "Китай"); }//China
	    case 3: { cInfo[contid][ContModelId] = 956; cInfo[contid][ContModelDoorId] = 955; format(regionstr, sizeof regionstr, "Дубай"); }//Dubai
	    case 4: { cInfo[contid][ContModelId] = 958; cInfo[contid][ContModelDoorId] = 957; format(regionstr, sizeof regionstr, "Германия"); }//Germania
	}

    new item_td[30];
    
	new size = cItem_InfoSize[cInfo[contid][ContRegion]];
    new item, limit;
    do
    {
        item = random(size);
    	cInfo[contid][ItemType] = cItem_Info[cInfo[contid][ContRegion]][item][Type];
    	limit++;
    	if(limit == size && cInfo[contid][ItemType] == 0) return printf("В регионе %s отсуствуют контейнеры!", regionstr);
    }
    while(cInfo[contid][ItemType] == 0 && limit < size);




	switch(contid)
	{
        case 1: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 690.51898, 1738.27002, 14.73000,   0.00000, 0.00000,   0.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 684.96442, 1738.25000, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 684.96442, 1736.30005, 13.00000,   0.00000, 0.00000, 0.00000); }//1
		case 2: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 690.51898, 1731.78003, 14.73000,   0.00000, 0.00000,   0.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 684.96442, 1731.75000, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 684.96442, 1729.80005, 13.00000,   0.00000, 0.00000, 0.00000); }//2
		case 3: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 665.81897, 1726.96997, 14.73000,   0.00000, 0.00000, 270.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 665.79999, 1732.50000, 13.00000,   0.00000, 0.00000, -90.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 663.84998, 1732.50000, 13.00000,   0.00000, 0.00000, -90.00000); }//3
		case 4: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 680.23999, 1694.77002, 14.73000,   0.00000, 0.00000, 270.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 680.22101, 1700.30005, 13.00000,   0.00000, 0.00000, -90.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 678.27100, 1700.30005, 13.00000,   0.00000, 0.00000, -90.00000); }//4
		case 5: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 672.75598, 1694.77002, 14.73000,   0.00000, 0.00000, 270.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 672.73700, 1700.30005, 13.00000,   0.00000, 0.00000, -90.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 670.78699, 1700.30005, 13.00000,   0.00000, 0.00000, -90.00000); }//5
		case 6: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 665.81897, 1694.77002, 14.73000,   0.00000, 0.00000, 270.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 665.79999, 1700.30005, 13.00000,   0.00000, 0.00000, -90.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 663.84998, 1700.30005, 13.00000,   0.00000, 0.00000, -90.00000); }//6
		case 7: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 655.51898, 1676.51001, 14.73000,   0.00000, 0.00000,   0.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 649.96973, 1676.48999, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 649.96973, 1674.54004, 13.00000,   0.00000, 0.00000, 0.00000); }//7
		case 8: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 655.51898, 1669.80005, 14.73000,   0.00000, 0.00000,   0.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 649.96973, 1669.78003, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 649.96973, 1667.82996, 13.00000,   0.00000, 0.00000, 0.00000); }//8
		case 9: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 655.51898, 1663.40002, 14.73000,   0.00000, 0.00000,   0.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 649.96973, 1663.38000, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 649.96973, 1661.43005, 13.00000,   0.00000, 0.00000, 0.00000); }//9
		case 10: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 631.91901, 1709.30005, 14.73000,   0.00000, 0.00000, 180.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 637.36829, 1707.35986, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 637.36829, 1709.30994, 13.00000,   0.00000, 0.00000, 0.00000); }//10
		case 11: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 631.91901, 1702.55005, 14.73000,   0.00000, 0.00000, 180.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 637.36829, 1700.58984, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 637.36829, 1702.53979, 13.00000,   0.00000, 0.00000, 0.00000); }//11
		case 12: { cInfo[contid][ContObjectId] = CreateObject(cInfo[contid][ContModelId], 631.91901, 1695.93994, 14.73000,   0.00000, 0.00000, 180.00000); cInfo[contid][ContObjectDoorLId] = CreateObject(cInfo[contid][ContModelDoorId], 637.36829, 1693.96985, 13.00000,   0.00000, 0.00000, 0.00000); cInfo[contid][ContObjectDoorRId] = CreateObject(cInfo[contid][ContModelDoorId], 637.36829, 1695.91992, 13.00000,   0.00000, 0.00000, 0.00000); }//12
	}
	
	
	
    new typestr[22];
    if(cInfo[contid][ItemType] == 1)
    {
		format(typestr, sizeof typestr, "Одежда");
    	switch(contid)
		{
	        case 1: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 690.51898, 1738.27002, 14.73000,   0.00000, 0.00000,   0.00000); //1
			case 2: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 690.51898, 1731.78003, 14.73000,   0.00000, 0.00000,   0.00000); //2
			case 3: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 665.81897, 1726.96997, 14.73000,   0.00000, 0.00000, 270.00000); //3
			case 4: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 680.23999, 1694.77002, 14.73000,   0.00000, 0.00000, 270.00000); //4
			case 5: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 672.75598, 1694.77002, 14.73000,   0.00000, 0.00000, 270.00000); //5
			case 6: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 665.81897, 1694.77002, 14.73000,   0.00000, 0.00000, 270.00000); //6
			case 7: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 655.51898, 1676.51001, 14.73000,   0.00000, 0.00000,   0.00000); //7
			case 8: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 655.51898, 1669.80005, 14.73000,   0.00000, 0.00000,   0.00000); //8
			case 9: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 655.51898, 1663.40002, 14.73000,   0.00000, 0.00000,   0.00000); //9
			case 10: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 631.91901, 1709.30005, 14.73000,   0.00000, 0.00000, 180.00000); //10
			case 11: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 631.91901, 1702.55005, 14.73000,   0.00000, 0.00000, 180.00000); //11
			case 12: cInfo[contid][ContObjectOdejdaId] = CreateObject(959, 631.91901, 1695.93994, 14.73000,   0.00000, 0.00000, 180.00000); //12
		}
    }
    else format(typestr, sizeof typestr, "Транспортное средство");
    
	cInfo[contid][Item] = cItem_Info[cInfo[contid][ContRegion]][item][ItemId];
	TextDrawSetPreviewModel(cont_model[contid], cInfo[contid][Item]);
	
	cInfo[contid][ContPrice] = cItem_Info[cInfo[contid][ContRegion]][item][ContPrice];
	cInfo[contid][ItemPrice] = cItem_Info[cInfo[contid][ContRegion]][item][ItemPrice];
	
    new itemprice[15];
    ConvertMoney(cInfo[contid][ItemPrice], itemprice);
    format(item_td, sizeof item_td, "%s PYЂ", itemprice);
    TextDrawSetString(cont_price[contid], item_td);

	new moneystr[10];
	ConvertMoney(cInfo[contid][ContPrice], moneystr);


    cInfo[contid][BetPrice] = cInfo[contid][ContPrice];
    
    format(item_td, sizeof item_td, "%s", RusText(cItem_Info[cInfo[contid][ContRegion]][item][Name]));
    TextDrawSetString(cont_name[contid], item_td);
    

    cInfo[contid][Saled] = true;
    cInfo[contid][SaleTime] = 30;

	new strkbass[215];
	format(strkbass, sizeof strkbass, "Контейнер #%d\n\nСтрана отправитель: "CW"%s\n"CLR"Содержимое контейнера: "CW"%s\n"CLR"Статус: "CW"торги за контейнер открыты\n"CLR"Начальная ставка: "CW"%s рублей", contid, regionstr, typestr, moneystr);
    UpdateDynamic3DTextLabelText(ContsText[contid], CLRED, strkbass);

    printf("spawn %d cont ||| type %d ||| region %d", contid, cInfo[contid][ItemType], cInfo[contid][ContRegion]);
    //ЗАПУСКАЕМ ТОРГИ
    ContsTimer[contid] = SetTimerEx("TimerSecondUpdateCont", 1000, true, "d", contid);
    return 1;
}


CMD:startcont(playerid)
{
	new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME); //Timofey_Gardeev //Dev_Weis
    if(!strcmp(name, "Dev_Kuzia", true))
	{
		StartCont();
	}
	return 1;
}
CMD:stopcont(playerid)
{
	new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);
    if(!strcmp(name, "Dev_Kuzia", true))
	{
		StopCont();
	}
	return 1;
}

CMD:cont(playerid)
{
	new bool:sell_limit;
	for(new cont=1; cont < MAX_CONT+1; cont++)
	{
	    if(sell_limit == true) continue;
		if(CheckPlayerDistanceToPoint(playerid, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2], 3.0))
		{
		    sell_limit = true;
			if(cInfo[cont][Saled] == true)
			{
			    if(cInfo[cont][BetedId] == playerid) return SCM(playerid, CLRED, "| "CW"Ставка на контейнер уже ваша, вы не можете перебить свою ставку");
			    pInfo[playerid][BetUseCont] = cont;

				new strkbass[140], betstr[10];
				ConvertMoney(cInfo[cont][BetPrice], betstr);
				format(strkbass, sizeof strkbass, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
			    SPD(playerid, 19996, DSI, ""CLR"KBR ONLINE "CW"| Битва за контейнер", strkbass,  "Готово", "Отмена");
			}
			else
			{
				if(cInfo[cont][BetedId] == playerid)
				{
                    pInfo[playerid][BuyUseCont] = cont;
                    
					TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
					TogglePlayerHudElement(playerid, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
					
					TextDrawShowForPlayer(playerid, cont_fon);
					TextDrawShowForPlayer(playerid, cont_take);
					TextDrawShowForPlayer(playerid, cont_sell);
					TextDrawShowForPlayer(playerid, cont_close);
					
					TextDrawShowForPlayer(playerid, cont_name[cont]);
					TextDrawShowForPlayer(playerid, cont_price[cont]);
					TextDrawShowForPlayer(playerid, cont_model[cont]);
					
					SelectTextDraw(playerid, CWHITE);
					TogglePlayerHudElement(playerid, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
				}
			}
		}
		else if(cInfo[cont][BetedId] == playerid)
		{
			if(CheckPlayerDistanceToPoint(playerid, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2], 4.0))
			{
		    	sell_limit = true;
				if(cInfo[cont][Saled] == false)
				{
                    pInfo[playerid][BuyUseCont] = cont;
				
					TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
					TogglePlayerHudElement(playerid, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);

					TextDrawShowForPlayer(playerid, cont_fon);
					TextDrawShowForPlayer(playerid, cont_take);
					TextDrawShowForPlayer(playerid, cont_sell);
					TextDrawShowForPlayer(playerid, cont_close);

					TextDrawShowForPlayer(playerid, cont_name[cont]);
					TextDrawShowForPlayer(playerid, cont_price[cont]);
					TextDrawShowForPlayer(playerid, cont_model[cont]);

					SelectTextDraw(playerid, CWHITE);
					TogglePlayerHudElement(playerid, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
				}
				else return SCM(playerid, CLRED, "| "CW"Ставка на контейнер уже ваша, ожидайте конца аукциона.");
			}
			else if(cInfo[cont][Saled] == false) SCM(playerid, CYELLOW, "| "CW"Подойдите к контейнеру для получения содержимого.");
		}
	}
	return 1;
}


public OnPlayerEnterDynamicArea(playerid, areaid)
{
	for(new cont=1; cont < MAX_CONT+1; cont++)
	{
		if(areaid == ContsZone[cont])
		{
			if(cInfo[cont][Saled] == true)
			{
		    	ShowNotificationNew(playerid, 4, 5, 0, 0, "Взаимодействовать", ">>");
			}
		}
	}
    return 1;
}



stock LoadTextDraw()
{
	cont_fon = TextDrawCreate(190.000198, 109.013328, "contbykbass:kbasscontosnova");
	TextDrawLetterSize(cont_fon, 0.000000, 0.000000);
	TextDrawTextSize(cont_fon, 237.999938, 237.937759);
	TextDrawAlignment(cont_fon, 1);
	TextDrawColor(cont_fon, -1);
	TextDrawSetShadow(cont_fon, 0);
	TextDrawSetOutline(cont_fon, 0);
	TextDrawFont(cont_fon, 4);


	cont_take = TextDrawCreate(190.800003, 349.937774, "contbykbass:kbassconttake");
	TextDrawLetterSize(cont_take, 0.000000, 0.000000);
	TextDrawTextSize(cont_take, 132.400009, 36.835563);
	TextDrawAlignment(cont_take, 1);
	TextDrawColor(cont_take, -1);
	TextDrawFont(cont_take, 4);
	TextDrawSetSelectable(cont_take, true);

	cont_sell = TextDrawCreate(324.800170, 349.937957, "contbykbass:kbasscontsell");
	TextDrawLetterSize(cont_sell, 0.000000, 0.000000);
	TextDrawTextSize(cont_sell, 103.600006, 36.337799);
	TextDrawAlignment(cont_sell, 1);
	TextDrawColor(cont_sell, -1);
	TextDrawFont(cont_sell, 4);
	TextDrawSetSelectable(cont_sell, true);

	cont_close = TextDrawCreate(395.600006, 108.515548, "contbykbass:kbasscontclose");
	TextDrawLetterSize(cont_close, 0.000000, 0.000000);
	TextDrawTextSize(cont_close, 31.199993, 37.333328);
	TextDrawAlignment(cont_close, 1);
	TextDrawColor(cont_close, -1);
	TextDrawFont(cont_close, 4);
	TextDrawSetSelectable(cont_close, true);
	
	
	for(new cont = 1; cont < MAX_CONT+1; cont++)
	{
		cont_name[cont] = TextDrawCreate(294.799987, 121.457778, "by KBAS's");
		TextDrawLetterSize(cont_name[cont], 0.327599, 1.321245);
		TextDrawAlignment(cont_name[cont], 2);
		TextDrawColor(cont_fon, -1);
		TextDrawSetOutline(cont_name[cont], 1);
		TextDrawBackgroundColor(cont_name[cont], 51);
		TextDrawFont(cont_name[cont], 1);
		TextDrawSetProportional(cont_name[cont], 1);

		cont_price[cont] = TextDrawCreate(374.399963, 323.057739, "15.555.555 PYB");
		TextDrawLetterSize(cont_price[cont], 0.307599, 1.236622);
		TextDrawAlignment(cont_price[cont], 2);
		TextDrawColor(cont_price[cont], -1);
		TextDrawSetShadow(cont_price[cont], 0);
		TextDrawSetOutline(cont_price[cont], 1);
		TextDrawBackgroundColor(cont_price[cont], 51);
		TextDrawFont(cont_price[cont], 1);
		TextDrawSetProportional(cont_price[cont], 1);
		
		cont_model[cont] = TextDrawCreate(226.399902, 149.333343, "by KBAS's");
		TextDrawTextSize(cont_model[cont], 175.599990, 165.804412);
		TextDrawColor(cont_fon, -1);
		TextDrawUseBox(cont_model[cont], true);
		TextDrawFont(cont_model[cont], 5);
		TextDrawSetPreviewModel(cont_model[cont], 18639);
		TextDrawBackgroundColor(cont_model[cont], 0x00000000);
		TextDrawSetPreviewRot(cont_model[cont], 0.000000, 0.000000, -30.000000, 1.000000);
	}
	return 1;
}



stock ConvertMoney(money, string[], length = sizeof string)
{
	format(string, length, "%d", money < 0 ? -money : money);
	for(new i = strlen(string); (i -= 3) > 0;)
	{
	    if(string[i] != '\0' && '0' <= string[i] <= '9')
	    {
	        strins(string, ".", i, length);
	    }
	    else
	    {
	        return;
	    }
	}

	if(money < 0)
	{
	    strins(string, "-", 0, length);
	}
}



stock CheckPlayerDistanceToPoint(playerid, Float:x, Float:y, Float:z, Float: distance)
{
	if(IsPlayerInRangeOfPoint(playerid, distance, x, y, z)) return 1;
	else return 0;
}


stock RusText(string[])
{
	new result[256];
	for (new i = 0; i < sizeof(result); i++)
	{
		switch(string[i])
		{
			case 'а': result[i] = 'a';
			case 'А': result[i] = 'A';
			case 'б': result[i] = '—';
			case 'Б': result[i] = 'Ђ';
			case 'в': result[i] = 'ў';
			case 'В': result[i] = '‹';
			case 'г': result[i] = '™';
			case 'Г': result[i] = '‚';
			case 'д': result[i] = 'љ';
			case 'Д': result[i] = 'ѓ';
			case 'е': result[i] = 'e';
			case 'Е': result[i] = 'E';
			case 'ё': result[i] = 'e';
			case 'Ё': result[i] = 'E';
			case 'ж': result[i] = '›';
			case 'Ж': result[i] = '„';
			case 'з': result[i] = 'џ';
			case 'З': result[i] = '€';
			case 'и': result[i] = 'њ';
			case 'И': result[i] = '…';
			case 'й': result[i] = 'ќ';
			case 'Й': result[i] = '…';
			case 'к': result[i] = 'k';
			case 'К': result[i] = 'K';
			case 'л': result[i] = 'ћ';
			case 'Л': result[i] = '‡';
			case 'м': result[i] = 'Ї';
			case 'М': result[i] = 'M';
			case 'н': result[i] = '®';
			case 'Н': result[i] = 'H';
			case 'о': result[i] = 'o';
			case 'О': result[i] = 'O';
			case 'п': result[i] = 'Ј';
			case 'П': result[i] = 'Њ';
			case 'р': result[i] = 'p';
			case 'Р': result[i] = 'P';
			case 'с': result[i] = 'c';
			case 'С': result[i] = 'C';
			case 'т': result[i] = '¦';
			case 'Т': result[i] = 'Џ';
			case 'у': result[i] = 'y';
			case 'У': result[i] = 'Y';
			case 'ф': result[i] = 'Ѓ';
			case 'Ф': result[i] = 'Ѓ';
			case 'х': result[i] = 'x';
			case 'Х': result[i] = 'X';
			case 'ц': result[i] = '‰';
			case 'Ц': result[i] = '‰';
			case 'ч': result[i] = '¤';
			case 'Ч': result[i] = 'Ќ';
			case 'ш': result[i] = 'Ґ';
			case 'Ш': result[i] = 'Ћ';
			case 'щ': result[i] = 'Ў';
			case 'Щ': result[i] = 'Љ';
			case 'ь': result[i] = '©';
			case 'Ь': result[i] = '’';
			case 'ъ': result[i] = 'ђ';
			case 'Ъ': result[i] = '§';
			case 'ы': result[i] = 'Ё';
			case 'Ы': result[i] = '‘';
			case 'э': result[i] = 'Є';
			case 'Э': result[i] = '“';
			case 'ю': result[i] = '«';
			case 'Ю': result[i] = '”';
			case 'я': result[i] = '¬';
			case 'Я': result[i] = '•';
			default: result[i] = string[i];
		}
	}
	return result;
}







stock LoadContItemList()
{
	DBconnectID = mysql_connect("188.165.55.190", "gs71596", "gs71596", "kuzia1");//"", "", "", ""
	mysql_function_query(DBconnectID, !"SET NAMES 'cp1251'", false, "", ""); // Руссификатор пон
	if(mysql_errno() == 0)
	{
	    for(new i=1; i <= 4; i++)
	    {
			new qString[47];
			format(qString, sizeof(qString), "SELECT * FROM `contbykbass` WHERE `region` = %d", i);
			mysql_function_query(DBconnectID, qString, true, "LoadContItemListInfo", "d", i);
		}
	}
	else
	{
 		print("ВНИМАНИЕ: Ошибка c подключением к базе данных. Обратитесь к t.me/woifp.");
		mysql_close(DBconnectID);
	}
}

forward LoadContItemListInfo(region);
public LoadContItemListInfo(region)
{
    new rows, fields;
    cache_get_data(rows, fields);
    if(!rows)
    {
 		printf("ВНИМАНИЕ: В базе данных нет товаров для контейнеров %d-го региона.", region);
    }
	else
	{
		if(rows <= sizeof cItem_Info[])
		{
			cItem_InfoSize[region] = rows;
		    for(new i; i < rows; i++)
		    {
  				//region = cache_get_field_content_int(i, "region", DBconnectID);
		        cItem_Info[region][i][Type] = cache_get_field_content_int(i, "type", DBconnectID);
		        cItem_Info[region][i][ItemId] = cache_get_field_content_int(i, "item", DBconnectID);
		        cache_get_field_content(i, "name", cItem_Info[region][i][Name], DBconnectID, 30);
		        cItem_Info[region][i][ContPrice] = cache_get_field_content_int(i, "contprice", DBconnectID);
		        cItem_Info[region][i][ItemPrice] = cache_get_field_content_int(i, "itemprice", DBconnectID);
		        
		        printf("load item %d region ||| type %d ||| item %d ||| name %s ||| cp %d ||| ip %d |||", region, cItem_Info[region][i][Type], cItem_Info[region][i][ItemId], cItem_Info[region][i][Name], cItem_Info[region][i][ContPrice], cItem_Info[region][i][ItemPrice]);
			}
		}
	}
	if(region == 4) mysql_close(DBconnectID);
}
