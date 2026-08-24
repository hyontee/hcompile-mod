#define COLOR_GREEN 0x00FF00FF
#define MAX_GARAGES				(900)// максимальное кол-во гаражей
#define GARAGE_TYPE_NONE		(-1) 	// нет
#define GARAGE_TYPE_GARAGE		(0) 	// дом
#define SetPlayerInGarage(%0,%1)				SetPlayerData(%0, P_IN_GARAGE, %1)		// установить дом в котором находится
#define GetGarageData(%0,%1)			g_garage[%0][%1]
#define SetGarageData(%0,%1,%2)		g_garage[%0][%1] = %2
#define AddGarageData(%0,%1,%2,%3)	g_garage[%0][%1] %2= %3
#define IsGarageOwned(%0)			(GetGarageData(%0, G_OWNER_ID) > 0) // куплен ли гараж
#define	GetPlayerGarage(%0)	GetPlayerData(playerid, P_GARAGE_TYPE)
#define DIALOG_PAY_FOR_RENT_GARAGE  15000		// оплата за гараж
#define DIALOG_GARAGE_BUY	15001			// покупка гаража
#define	DIALOG_GARAGE_SELL 15002				// продажа гаража
#define	DIALOG_GARAGE_INFO	15003			// инфо о гаража
#define	DIALOG_GARAGE_MINU 15004
#define	DIALOG_GARAGE_SELL 15005

#define PICKUP_ACTION_TYPE_GARAGE 5000
#define PICKUP_ACTION_TYPE_GARAGE_EXIT 5000
enum E_GARAGE_STRUCT
{
G_SQL_ID,
G_OWNER_ID,
G_RENT_DATE,
G_RENT_PRICE,
G_YLUCHENIE,
G_PRICE,
//G_RENT_DATE,
G_OPEN,
G_ENTRACE,	
G_MAP_ICON,
G_ENTER_PICKUP,
Text3D: G_LABEL,	// 3д текст
G_OWNER_NAME[20 + 1],	// имя владельца
Float: G_POS_X,		// позиция пикапа входа
	Float: G_POS_Y,		// позиция пикапа входа
	Float: G_POS_Z,		// позиция пикапа входа
	Float: G_EXIT_POS_X,// позиция после выхода из дома
	Float: G_EXIT_POS_Y,// позиция после выхода из дома
	Float: G_EXIT_POS_Z,// позиция после выхода из дома
	Float: G_EXIT_ANGLE // угол поворота
}
enum E_GARAGE_TYPE_STRUCT
{
GT_NAME[20],
	Float: GT_ENTER_POS_X,		// позиции после входа в интерьера
	Float: GT_ENTER_POS_Y,		// позиции после входа в интерьера
	Float: GT_ENTER_POS_Z,		// позиции после входа в интерьера
	Float: GT_ENTER_POS_ANGLE,	// позиции после входа в интерьера
	Float: GT_HEALTH_POS_X,		// позиции аптечки
	Float: GT_HEALTH_POS_Y,		// позиции аптечки
	Float: GT_HEALTH_POS_Z,		// позиции аптечки
	Float: GT_STORE_POS_X,		// позиции шкафа
	Float: GT_STORE_POS_Y,		// позиции шкафа
	Float: GT_STORE_POS_Z,		// позиции шкафа
	GT_INTERIOR				// ид интерьера
}
new g_garage[200][E_GARAGE_STRUCT];
new g_garage_loaded;

public OnGameModeInit()
{
    
    LoadGarage();
    #if defined garage_OnGameModeInit
        garage_OnGameModeInit();
    #endif
    return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit garage_OnGameModeInit
#if defined garage_OnGameModeInit
forward garage_OnGameModeInit();
#endif  

public OnPlayerSpawn(playerid)
{
    SetPlayerData(playerid, P_IN_GARAGE, 		-1);
    
    #if defined garage_OnPlayerSpawn
        garage_OnPlayerSpawn(playerid);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn garage_OnPlayerSpawn
#if defined garage_OnPlayerSpawn
forward garage_OnPlayerSpawn(playerid);
#endif  
public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    switch(pickupid)
    {
    case PICKUP_ACTION_TYPE_GARAGE:
				{
				if(GetGarageData(action_id, G_OWNER_ID) > 1)
				{
				if(GetGarageData(action_id, G_OPEN)==0)
				{
				if(GetGarageData(action_id, G_YLUCHENIE) ==0)
				{
				SetPlayerData(playerid, P_IN_GARAGE, 		action_id);
				EnterPlayerToGarage(playerid, action_id);
			ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
				}else if(GetGarageData(action_id, G_YLUCHENIE) ==1)
				{
				SetPlayerData(playerid, P_IN_GARAGE, 		action_id);
				SetPlayerInGarage(playerid, action_id);

		SetPlayerPosEx(playerid, 495.961517,1989.867797,1547.679687, 271.342468, 1, action_id);

				ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
				}
				}
				}
				else if(GetGarageData(action_id, G_OWNER_ID)== GetPlayerAccountID(playerid))
				{
				if(GetGarageData(action_id, G_YLUCHENIE) ==0)
				{
				SetPlayerData(playerid, P_IN_GARAGE, 		action_id);
				EnterPlayerToGarage(playerid, action_id);
			ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
				}
				else
				{
				SetPlayerData(playerid, P_IN_GARAGE, 		action_id);
				SetPlayerInGarage(playerid, action_id);

		SetPlayerPosEx(playerid, 495.961517,1989.867797,1547.679687, 271.342468, 1, action_id);

				ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
				}
				} else return ShowPlayerGarageInfo(playerid, action_id);
				
				
				}
				case PICKUP_ACTION_TYPE_GARAGE_EXIT:
				{
				new garageid = GetPlayerData(playerid, P_IN_GARAGE);
				SetPlayerPosEx
							(
								playerid,
								GetGarageData(garageid, G_EXIT_POS_X),
								GetGarageData(garageid, G_EXIT_POS_Y),
								GetGarageData(garageid, G_EXIT_POS_Z),
								GetGarageData(garageid, G_EXIT_ANGLE),
								0,
								0
							);
							SetPlayerData(playerid, P_IN_GARAGE, 		-1);
				}
    
    }
    
    #if defined garage_OnPlayerPickUpPickupEx
        garage_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif

#define OnPlayerPickUpPickupEx garage_OnPlayerPickUpPickupEx
#if defined garage_OnPlayerPickUpPickupEx
forward garage_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif  
stock IsPlayerNearGaragePickup(playerid, garageID)
{
    new Float:garageX = GetGarageData(garageID, G_POS_X);
    new Float:garageY = GetGarageData(garageID, G_POS_Y);
    new Float:garageZ = GetGarageData(garageID, G_POS_Z); 

    if (IsPlayerInRangeOfPoint(playerid, 5.0, garageX, garageY, garageZ)) 
    {
        return true;
    }
    return false;
}

public EnterGarage(playerid)
{
new action_id = GetPlayerData(playerid, P_IN_GARAGE);
    // Устанавливаем позицию игрока в гараже
    new vehicleid = GetPlayerVehicleID(playerid);
    

 //   SendClientMessage(playerid, 0x00FF00FF, "Вы вошли в гараж!");

//    new vehicleid = GetPlayerVehicleID(playerid);
    if (vehicleid != 0) // Проверяем, находится ли игрок в автомобиле
    {
    if(GetGarageData(action_id, G_YLUCHENIE) ==0)
				{
				SetPlayerPosEx(playerid, -0.292650,2000.242065,1553.358764,355.240234, 1, GetPlayerData(playerid, P_IN_GARAGE), false);
        SetVehiclePos(vehicleid, -0.292650,2000.242065,1553.358764);
        SetVehicleZAngle(vehicleid, 355.240234);
}
else if(GetGarageData(action_id, G_YLUCHENIE) ==1)
				{
				SetPlayerPosEx(playerid, 501.180450,1998.823486,1547.679687, 357.5, 1, GetPlayerData(playerid, P_IN_GARAGE), false);
				SetVehiclePos(vehicleid, 501.180450,1998.823486,1547.679687);
        SetVehicleZAngle(vehicleid, 348);
				}
        LinkVehicleToInterior(vehicleid, 1); // Связываем транспорт с интерьером
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        PutPlayerInVehicle(playerid, vehicleid, 0); // Сажаем игрока в автомобиль
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Вы не в автомобиле!");
    }
}
forward ExitPlayerGarage(playerid);
public ExitPlayerGarage(playerid)
{
if(GetPlayerData(playerid, P_IN_GARAGE) == -1) return 1;

new garageid = GetPlayerData(playerid, P_IN_GARAGE);
new vehicleid = GetPlayerVehicleID(playerid);
					SetVehiclePos(vehicleid,GetGarageData(garageid, G_EXIT_POS_X),
								GetGarageData(garageid, G_EXIT_POS_Y),
								GetGarageData(garageid, G_EXIT_POS_Z),
								GetGarageData(garageid, G_EXIT_ANGLE) +180);
								   LinkVehicleToInterior(vehicleid, 0);
			SetVehicleVirtualWorld(vehicleid, 0);
			
							
				SetPlayerPosEx
							(
								playerid,
								GetGarageData(garageid, G_EXIT_POS_X),
								GetGarageData(garageid, G_EXIT_POS_Y),
								GetGarageData(garageid, G_EXIT_POS_Z),
								GetGarageData(garageid, G_EXIT_ANGLE),
								0,
								0
							);
							SetPlayerData(playerid, P_IN_GARAGE, 		-1);
							PutPlayerInVehicle(playerid, vehicleid, 0);
							new fmt_text[512];
							format(fmt_text, sizeof fmt_text,"%f, %f, %f", GetGarageData(garageid, G_EXIT_POS_X),
								GetGarageData(garageid, G_EXIT_POS_Y),
								GetGarageData(garageid, G_EXIT_POS_Z));
								Send(playerid,-1,fmt_text);
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys == KEY_CROUCH)
{
if (IsPlayerInRangeOfPoint(playerid, 5, 495.170532,299.884582,1339.000000) || IsPlayerInRangeOfPoint(playerid, 5, -19.821039,4.290028,1129.476562))
{
  SetTimerEx("ExitPlayerGarage", 1000, false, "i", playerid);
}
}
    if (newkeys == KEY_CROUCH)
{
if(GetPlayerGarage(playerid) != -1) 
{
if(GetPlayerData(playerid, P_IN_GARAGE) != -1) return Send(playerid,-1,"[DEBUG] ERROR");
    new idx = GetPlayerGarage(playerid);
        if (IsPlayerNearGaragePickup(playerid, idx))
        {
        Send(playerid,-1,"[DEBUG] ENTER PLAYER TO GARAGE");
        SetPlayerData(playerid, P_IN_GARAGE, idx);
        EnterGarage(playerid);
         //   SendClientMessage(playerid, COLOR_GREEN, "Вы находитесь рядом с гаражом!");
            return 1;
        }
    
    }else return Send(playerid,-1,"[DEBUG] ERRORS 00456");
    //SendClientMessage(playerid, COLOR_RED, "Вы не рядом с гаражом.");
}
    
    #if defined garage_OnPlayerKeyStateChange
        garage_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange garage_OnPlayerKeyStateChange
#if defined garage_OnPlayerKeyStateChange
forward garage_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif  
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])    
{
    if (dialogid == DIALOG_GARAGE_SELL) 
{
        if (response)
 {
            // Разделяем введённый текст на ID игрока и цену
            new temp;
            new to_player;
            sscanf(inputtext, "i i", to_player, temp);

            // Преобразуем строку цены в число
         new    price = temp;
         new Float:x;
         new Float:y;
         new Float:z;
         GetPlayerPos(playerid, x, y, z);
         
if(!IsPlayerInRangeOfPoint(to_player, 5.0, x, y, z)) return Send(playerid,-1,"Игрок далеко");
            // Проверяем, валидны ли введённые данные
if (to_player >= 0 && price > 0) {
if(GetPlayerMoneyEx(to_player) < price) return ShowNotification(playerid, 2, "У игрока не достаточно денег", 4, " ", "");
SendPlayerOffer(playerid, to_player, OFFER_TYPE_BUY_GARAGE, price);
SetPVarInt(to_player, "GarageSellerID", playerid); // ID продавца
        SetPVarInt(to_player, "GaragePrice", price);
ShowNotification(to_player, 4, "Покупка гаража", 7, "/yes", ">>");
                // Вызываем функцию продажи гаража
                
} else {
                // Сообщаем об ошибке
                SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный ID игрока или цена.");
            }
        }
    }
if (dialogid == 1056)
    {
    if (!response) return 1; 
   new idx =  GetPlayerGarage(playerid);
    if(GetGarageData(idx, G_YLUCHENIE)==1) return 1;
    SetGarageData(idx, G_YLUCHENIE, 1);
    new query[128];    
   format(query, sizeof(query), "UPDATE garage g SET g.uluchenie=%d WHERE g.id=%d", 
            GetGarageData(idx, G_YLUCHENIE), GetPlayerGarage(playerid) + 1);
        
    mysql_query(mysql, query, false);
    
    }
    
    switch(dialogid)
    {
    case DIALOG_GARAGE_MINU:
			{
			if (response)
    {
switch (listitem)
        {
            case 0:ShowPlGarageInfo(playerid);
            case 1:SellGarageGos(playerid);
            case 2:Dialog(playerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_INPUT, "Гараж","Введите id игрок и цену", "Далее","Отмена");
            case 3: 
            {
            new action_id = GetPlayerGarage(playerid);
            if(GetGarageData(action_id, G_YLUCHENIE) ==0)
				{
            SetPVarInt(playerid, "garagecar", 1);
            } else if(GetGarageData(action_id, G_YLUCHENIE) ==1)
            {
            SetPVarInt(playerid, "garagecar", 2);
            }
            callcmd::car(playerid, "");
            }
            case 4:
            {
            new idx = GetPlayerGarage(playerid);
            if(GetGarageData(idx, G_OPEN) == 0)
            {
            SetGarageData(idx, G_OPEN, 1);
            Send(playerid,-1,"Гараж закрыт");
     new query[128];    
   format(query, sizeof(query), "UPDATE garage g SET g.open=%d WHERE g.id=%d", 
            GetGarageData(idx, G_OPEN), GetPlayerGarage(playerid) + 1);
        
    mysql_query(mysql, query, false);
    
            }
            else
            {
            SetGarageData(idx, G_OPEN, 0);
            Send(playerid,-1,"Гараж открыт");
          new query[128];    
   format(query, sizeof(query), "UPDATE garage g SET g.open=%d WHERE g.id=%d", 
            GetGarageData(idx, G_OPEN), GetPlayerGarage(playerid) + 1);
        
    mysql_query(mysql, query, false);
    
  }
  UpdateGarageInfo(idx);
            }
            case 5:ShowYluchGarage(playerid);
            
            case 6:
            {
            new idx = GetPlayerGarage(playerid);
            EnablePlayerGPS
							(
								playerid,
								18,
								GetGarageData(idx, G_POS_X),
								GetGarageData(idx, G_POS_Y),
								GetGarageData(idx, G_POS_Z),
								""
							);
            }
            }
            }
			}
			case DIALOG_GARAGE_BUY:
			{
				new garageid = GetPlayerUseListitem(playerid);
				

						if(GetPlayerMoneyEx(playerid) >= 450000)
									{
									SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Вы приобрели гараж");
										BuyPlayerGarage(playerid, garageid);

									}
									else return Send(playerid,-1,"У вас не достаточно денег");
						
						
}
    }
    
    // Тут проблема - нужно либо вернуть результат хука, либо 0
    #if defined garage_OnDialogResponse
    return garage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif

public: LoadGarage()
{
    new idx;
    new Cache: result, rows;
    
    result = mysql_query(mysql, "SELECT * FROM garage", true);
    rows = cache_num_rows();

    if (rows > MAX_GARAGES)
    {
        rows = MAX_GARAGES;
        print("[Garage]: DB rows > MAX_GARAGES");
    }

    for (idx = 0; idx < rows; idx++)
    {
        new pos_x_query[20], pos_y_query[20], pos_z_query[20];
        new exit_x_query[20], exit_y_query[20], exit_z_query[20];
        
        SetGarageData(idx, G_SQL_ID, cache_get_field_content_int(idx, "id"));
        SetGarageData(idx, G_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));

        cache_get_field_content(idx, "owner_name", g_garage[idx][G_OWNER_NAME], mysql, 20);
        SetGarageData(idx, G_PRICE, cache_get_field_content_int(idx, "price"));
        SetGarageData(idx, G_OPEN, cache_get_field_content_int(idx, "open"));
        SetGarageData(idx, G_RENT_PRICE, cache_get_field_content_int(idx, "rent"));
        SetGarageData(idx, G_RENT_DATE, cache_get_field_content_int(idx, "rent_time"));
        SetGarageData(idx, G_YLUCHENIE, cache_get_field_content_int(idx, "uluchenie"));
/*
        // Получаем координаты входа
        cache_get_field_content(idx, "pos_x", pos_x_query, mysql, sizeof(pos_x_query));
        cache_get_field_content(idx, "pos_y", pos_y_query, mysql, sizeof(pos_y_query));
        cache_get_field_content(idx, "pos_z", pos_z_query, mysql, sizeof(pos_z_query));
        
        new Float:x = floatstr(pos_x_query);
        new Float:y = floatstr(pos_y_query);
        new Float:z = floatstr(pos_z_query);

        if (x == 0.0 && y == 0.0 && z == 0.0)
        {
            printf("[Ошибка]: Гараж %d имеет некорректные координаты (0.0, 0.0, 0.0)", idx);
            continue; 
        }
*/
        SetGarageData(idx, G_POS_X, cache_get_field_content_float(idx, "pos_x"));
        SetGarageData(idx, G_POS_Y, cache_get_field_content_float(idx, "pos_y"));
        SetGarageData(idx, G_POS_Z, cache_get_field_content_float(idx, "pos_z"));
/*
        // Получаем координаты выхода
        cache_get_field_content(idx, "exit_x", exit_x_query, mysql, sizeof(exit_x_query));
        cache_get_field_content(idx, "exit_y", exit_y_query, mysql, sizeof(exit_y_query));
        cache_get_field_content(idx, "exit_z", exit_z_query, mysql, sizeof(exit_z_query));
        
        x = floatstr(exit_x_query);
        y = floatstr(exit_y_query);
        z = floatstr(exit_z_query);
*/
        SetGarageData(idx, G_EXIT_POS_X, cache_get_field_content_float(idx, "exit_x"));
        SetGarageData(idx, G_EXIT_POS_Y, cache_get_field_content_float(idx, "exit_y"));
        SetGarageData(idx, G_EXIT_POS_Z, cache_get_field_content_float(idx, "exit_z"));

        new labelText[128];
        format(labelText, sizeof(labelText), "Нажмите [гудок] чтобы выехать");
        SetGarageData(idx, G_LABEL, CreateDynamic3DTextLabel(labelText, 0x3399FFFF, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z) + 1.0, 15.0));
        SetGarageData(idx, G_ENTER_PICKUP, CreatePickup(19134, 23, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z), 0, PICKUP_ACTION_TYPE_GARAGE, idx));
        
        printf("[Garage]: Гараж %d загружен - X: %f, Y: %f, Z: %f", idx, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z));

        UpdateGarageInfo(idx);
    }

    g_garage_loaded = rows;
    cache_delete(result);
    
    CreateDynamic3DTextLabel("Посигнальте чтобы выехать", 0xFFD700FF, 492.701324,1991.680786,1547.679687, 10.0);
    CreateDynamic3DTextLabel("Посигнальте чтобы выехать", 0xFFD700FF, 0.998209,1994.307739,1554.203125, 10.0);
    CreatePickup(1318, 23, 492.701324,1991.680786,1547.679687, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT);
    CreatePickup(1318, 23, 0.998209,1994.307739,1554.203125, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT);

    printf("[Garage]: Загружено гаражей: %d", g_garage_loaded);
}

stock UpdateGarageInfo(idx)
{
    new query[666];
    new Cache: result;

    if (GetGarageData(idx, G_OWNER_ID) > 0) 
    {
        format(query, sizeof(query), "SELECT name FROM accounts WHERE id = %d", GetGarageData(idx, G_OWNER_ID));
        result = mysql_query(mysql, query, true);

        if (cache_num_rows() > 0) 
        {
            new ownerName[32];
            cache_get_field_content(0, "name", ownerName, mysql, 32);

            format(query, sizeof(query), "- Гараж[%d]\nВладелец: %s\nНажмите {db1200}[гудок] {faf2f6} для входа \n \t{38bd1a} [%s]", 
                GetGarageData(idx, G_SQL_ID), ownerName, GetGarageData(idx, G_OPEN) ? ("Закрыт") : ("Открыт"));
        }
        else 
        {
            format(query, sizeof(query), "- Гараж[%d]\nНеверный владелец\nНажмите {db1200}[гудок] {faf2f6} для входа", GetGarageData(idx, G_SQL_ID));
        }
    }
    else 
    {
        format(query, sizeof(query), "- Гараж[%d]\nГараж продается за 450.000 рублей", GetGarageData(idx, G_SQL_ID));
    }

    if (GetGarageData(idx, G_LABEL) != -1) 
    {
        UpdateDynamic3DTextLabelText(GetGarageData(idx, G_LABEL), 0xfaf2f6AA, query);
    }
    else
    {
        printf("Метка для гаража [%d] не найдена при обновлении!", idx);
    }

    cache_delete(result); 
}
public: ShowPlayerGarageInfo(playerid, houseid)
{
	
	SetPlayerUseListitem(playerid, houseid);
	new fmt_str[60];
			new string[256];
			format(fmt_str, sizeof fmt_str, "{FFFFFF}Гараж[%d] \n Цена 450.000\n Аренда 2500 р\n Вы действительно хотите приобрести данный гараж?", houseid +1);
			Dialog(playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "{33CC00}Гараж свободен", fmt_str, "Купить", "Отмена");
	
	
}
stock EnterPlayerToGarage(playerid, entranceid)
{
SetPlayerInGarage(playerid, entranceid);

		SetPlayerPosEx(playerid, 1.387492,1995.810791,1554.203125,180, 1, entranceid);

	//	SendClientMessage(playerid, -1, "Для выбора квартиры поднимитесь на лифте на определенный этаж");
//SetPVarInt(playerid, "vpadike", entranceid);
//		SetPlayerInEntranceFloor(playerid, 0);
		SetPlayerInGarage(playerid, entranceid);
	
}





stock ShowPlGarageInfo(playerid)
{
new garageid = GetGarageData(GetPlayerData(playerid, P_GARAGE_TYPE),G_SQL_ID);
new query[256];

			format(query, sizeof query, "Гараж[%d]\nВладелец: %s\n Цена: 450.000 \n Аренда(в день) 2500 р\n Гараж арендован на %d / 30", garageid, GetPlayerNameEx(playerid), GetElapsedTime(GetGarageData(GetPlayerData(playerid, P_GARAGE_TYPE), G_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS));
			Dialog(playerid,1055,DIALOG_STYLE_MSGBOX,"Гараж",query,"Закрыть","");

}
stock ShowYluchGarage(playerid)
{
new idx = GetPlayerGarage(playerid);
new query[256];
			format(query, sizeof query, "Премиум гараж \t \t \t {13b01b}[%s]", GetGarageData(idx, G_YLUCHENIE) ? ("Куплено") : ("5.000.000"));
			Dialog(playerid,1056,DIALOG_STYLE_LIST,"Гараж",query,"Купить","Отмена");

}


stock SellGarageGos(playerid)
{
    new query[256];
    new garageid = GetPlayerGarage(playerid);
    
    new accountID = GetPlayerAccountID(playerid);
    new garageSQLID = GetGarageData(garageid, G_SQL_ID);
    
    
    
    new price = 300000;
    new pgarage = -1;   
    new powner = 0; 
    
    format(query, sizeof(query), "UPDATE accounts a, garage g SET a.garage=%d, g.uluchenie = %d, g.owner_id=%d, g.owner_name=' ' WHERE a.id=%d AND g.id=%d", 
            pgarage, powner, powner, accountID, garageSQLID);
        
    mysql_query(mysql, query, false);
    GivePlayerMoneyEx(playerid, 300000, "Продажа гаража", true, false);
    printf("sql %s", query);
    
    if (mysql_errno())
    {
        printf("Ошибка выполнения запроса: %s", mysql_errno(mysql));
        return;
    }
    
    SetPlayerData(playerid, P_GARAGE_TYPE, -1);
   // UpdatePlayerDatabaseInt(playerid, "garage", GetPlayerData(playerid, P_GARAGE_TYPE));

    printf("sql %d", garageid);
    SetGarageData(garageid, G_OWNER_ID, 0);
    SetGarageData(garageid, G_YLUCHENIE, 0);
    
    UpdateGarageInfo(garageid);
    SendClientMessage(playerid, COLOR_GREEN, "Вы успешно продали гараж!");
}






stock SellGaragePlayer(playerid, to_player, price)
{
    new query[256];
    new garageid = GetPlayerGarage(playerid);
    
    new accountID = GetPlayerAccountID(playerid);
    new accountPID = GetPlayerAccountID(to_player);
    new garageSQLID = GetGarageData(garageid, G_SQL_ID);
    
    if(GetPlayerMoneyEx(to_player) < price) return 1;
    
   // new price = 300000;
   new pgarage = -1;   
   new powner = 0; 
    
    format(query, sizeof(query), "UPDATE accounts a, garage g SET g.owner_id=%d, g.owner_name='%s' WHERE g.id=%d", 
            accountPID, GetPlayerNameEx(to_player), garageSQLID);
        
    mysql_query(mysql, query, false);
    GivePlayerMoneyEx(playerid, price, "Продажа гаража", true, false);
    printf("sql %s", query);
    //
    
    
    GivePlayerMoneyEx(to_player, -price, "Покупка гаража", true, false);
    if (mysql_errno())
    {
        printf("Ошибка выполнения запроса: %s", mysql_errno(mysql));
        return;
    }
    
    SetPlayerData(playerid, P_GARAGE_TYPE, GetPlayerData(playerid, P_GARAGE_TYPE) ^ -1);
    UpdatePlayerDatabaseInt(playerid, "garage", GetPlayerData(playerid, P_GARAGE_TYPE));

SetPlayerData(to_player, P_GARAGE_TYPE, GetPlayerData(to_player, P_GARAGE_TYPE) ^ garageid);
    UpdatePlayerDatabaseInt(to_player, "garage", GetPlayerData(to_player, P_GARAGE_TYPE));
SetGarageData(garageid, G_OWNER_NAME, GetPlayerNameEx(to_player));  
        SetGarageData(garageid, G_OWNER_ID, GetPlayerAccountID(to_player)); 
    printf("sql %d", garageid);
 //   SetGarageData(garageid, G_OWNER_ID, accountPID);
    
    UpdateGarageInfo(garageid);
    SendClientMessage(playerid, COLOR_GREEN, "Вы успешно продали гараж!");
}

stock BuyPlayerGarage(playerid, garageid, bool: buy_from_owner = false, price = 450000)
{
    new query[256];
    
    if (GetPlayerMoneyEx(playerid) >= price)
    {
    new time = gettime();
				new rent_time = (time - (time % 86400)) + 86400;

        if(GetElapsedTime(GetGarageData(garageid, G_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
					{
						SetGarageData(garageid, G_RENT_DATE, rent_time);
					}
        format(query, sizeof(query), "UPDATE accounts a, garage g SET g.owner_id=%d, g.rent_time =%d, g.owner_name='%s' WHERE a.id=%d AND g.id=%d",
            GetPlayerAccountID(playerid), rent_time, GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), GetGarageData(garageid, G_SQL_ID));
        
        mysql_query(mysql, query, false);
GivePlayerMoneyEx(playerid, -450000, "Покупка гаража", true, false);
        if (mysql_errno())
        {
            printf("Ошибка выполнения запроса: %s", mysql_errno(mysql));
            return;
        }
        

        SetGarageData(garageid, G_OWNER_NAME, GetPlayerNameEx(playerid));  
        SetGarageData(garageid, G_OWNER_ID, GetPlayerAccountID(playerid)); 
        SetPlayerData(playerid, P_GARAGE_TYPE, garageid);
        UpdatePlayerDatabaseInt(playerid, "garage", garageid);

        UpdateGarageInfo(garageid);
        print("%d", garageid);

        Send(playerid, -1, "Поздравляем! Вы приобрели гараж");
    }
    else 
    {
        Send(playerid, -1, "У вас недостаточно денег");
    }
}


stock ShowPlayerGaragePayForRent(playerid)
{
new houseid = GetPlayerGarage(playerid);
new fmt_str[256];

		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Гараж:\t\t\t\t\t№%d\n"\
			"Оплаченных дней арендны:\t\t%d из 30\n"\
			"Ежедневная квартплата:\t\t2500 руб\n"\
			"На сколько дней Вы хотите оплатить дом?",
			houseid + 1,
			GetElapsedTime(GetGarageData(houseid, G_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS)
		);
		Dialog(playerid, DIALOG_PAY_FOR_RENT_GARAGE, DIALOG_STYLE_INPUT, "{66CC00}Оплата гаража", fmt_str, "Оплатить", "Назад");
}
CMD:garage(playerid, params[])
{
if(GetPlayerGarage(playerid) != -1) 
{
Dialog(playerid, DIALOG_GARAGE_MINU, DIALOG_STYLE_LIST, "Гараж","Информация о гараже\nПродать государству\nПродать игроку\nЗагрузить транспорт\nОткрыть/Закрыть\n Улучшения\nОтметить гараж на карте","Далее","Отмена");
}
else return Send(playerid, -1,"Вы не владеете гаражом");
}


CMD:addgarage(playerid)
{
new modelid = 2500;
new query[500];
SendClientMessage(playerid, 0xCECECEFF, "Создание гаража");
		new Float: pos_x;
		new Float: pos_y;
		new Float: pos_z;
		new fmt_text[256];
		GetPlayerPos(playerid, pos_x, pos_y, pos_z);
		format(
    query, sizeof(query),
    "INSERT INTO garage (rent, pos_x, pos_y, pos_z, exit_x, exit_y, exit_z) VALUES ('%d', '%f', '%f', '%f', '%f', '%f', '%f')",
    modelid,
    pos_x, pos_y, pos_z, pos_x, pos_y, pos_z);
mysql_query(mysql, query, false);


//cache_delete(result);
	new Cache: result,
		idx = g_house_loaded;
		SetGarageData(idx, G_SQL_ID, 		cache_insert_id());
SetGarageData(idx, G_POS_X, pos_x);
        SetGarageData(idx, G_POS_Y, pos_y);
        SetGarageData(idx, G_POS_Z, pos_z);


        SetGarageData(idx, G_EXIT_POS_X, pos_x);
        SetGarageData(idx, G_EXIT_POS_Y, pos_y);
        SetGarageData(idx, G_EXIT_POS_Z, pos_z);
new labelText[128];
        format(labelText, sizeof(labelText), "Нажмите [гудок] чтобы выехать");
        SetGarageData(idx, G_LABEL, CreateDynamic3DTextLabel(labelText, 0x3399FFFF, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z) + 1.0, 15.0));
        SetGarageData(idx, G_ENTER_PICKUP, CreatePickup(1318, 23, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z), 0, PICKUP_ACTION_TYPE_GARAGE, idx));
        
	g_garage_loaded ++;

	UpdateGarageInfo(idx);
		return 1;
}
stock SellDebtorsGarage()
{
	new query[800];
	for(new i; i < g_garage_loaded; i ++)
	{
		if(GetGarageData(i, G_RENT_DATE) < gettime())
		{
		    new owner_id = GetGarageData(i, G_OWNER_ID);

			if(owner_id == 0) continue;


			format(query, sizeof query, "UPDATE accounts a,garage h SET `garage`=-1, h.owner_id='0', h.rent_time='0' WHERE a.id=h.owner_id AND h.id='%d'", GetGarageData(i, H_SQL_ID));
			mysql_query(mysql, query, false);

			new Cache: result, owner_name[21];

			mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE id=%d LIMIT 1", owner_id);
			result = mysql_query(mysql, query);

			if(cache_num_rows())
				cache_get_field_content(0, "name", owner_name, mysql, 21);
			cache_delete(result);

			new owner_player = GetPlayerIDBySqlID(owner_id);
			if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
                SetPlayerData(owner_player, P_GARAGE_TYPE, -1);
                mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `garage`=-1, WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
				mysql_query(mysql, query, false);
			} else {
				mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `garage`=-1, WHERE `id`=%d LIMIT 1", owner_id);
				mysql_query(mysql, query, false);
			}
			SetGarageData(i, G_OWNER_ID, 0);
			

			SetGarageData(i, G_RENT_DATE,		0);
			SetGarageData(i, G_OPEN,		false);

			format(query, sizeof query, "UPDATE garage SET `owner_id`=0 WHERE id=%d", GetGarageData(i, G_SQL_ID));
			mysql_query(mysql, query, false);

			
			UpdateGarageInfo(i);

			
			new fmt_text[256];

			new description[64];

			description = "слет гаража";

			format
			(
				fmt_text, sizeof fmt_text,
				"INSERT INTO return_money \
				(uid, money, description, status)\
				VALUES ('%d', '%d', '%s', 0)",
				owner_id,
				300000,
				description
			);

			mysql_query(mysql, fmt_text, true);
		}
	}
//	return 1;
}



