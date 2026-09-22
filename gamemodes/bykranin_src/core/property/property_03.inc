//>> Файл: bykranin_src/core/property/property_03.inc  (234 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: ShowPlayerBusinessDialog, GetSelectedBusiness, SetSelectedBusiness, ShowBusinessProfit
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: ShowPlayerBusinessDialog(playerid, operationid)
{
	new businessid = GetSelectedBusiness(playerid);
	if(businessid == -1) businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		switch(operationid)
		{
			case BIZ_OPERATION_PARAMS: // управление параметрами
			{
                new business_menu[384];
                format(business_menu, sizeof business_menu,
                    "1. Изменить стоимость продукта\n2. Заказать продукты\n3. Информация о заказе\n4. Финансовая статистика\n5. Улучшить бизнес\n6. Отметить бизнес на GPS\n7. Сменить бизнес%s",
                    GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_CASINO ? ("\n{FFD700}8. Управление сотрудниками") : (""));
                Dialog(playerid, DIALOG_BIZ_PARAMS, DIALOG_STYLE_LIST, "{33AACC}Изменение параметров бизнеса", business_menu, "Выбрать", "Назад");
			}
			case BIZ_OPERATION_LOCK: // открыть / закрыть
			{
				if(GetBusinessData(businessid, B_LOCK_STATUS))
				{
					SetBusinessData(businessid, B_LOCK_STATUS, false);
					SendClientMessage(playerid, 0x66CC00FF, "Бизнес открыт");
				}
					else
				{
					SetBusinessData(businessid, B_LOCK_STATUS, true);
					SendClientMessage(playerid, 0xFF6600FF, "Бизнес закрыт");
				}
				UpdateBusinessLabel(businessid);

				new query[75];
				mysql_format(mysql, query, sizeof query, "UPDATE business SET `lock`=%d WHERE `id`=%d LIMIT 1", GetBusinessData(businessid, B_LOCK_STATUS), GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);

				CallLocalFunction("ShowPlayerBusinessDialog", "ii", playerid, BIZ_OPERATION_PARAMS);
			}			
			case BIZ_OPERATION_PROD_PRICE: // установить стоимость продукта
			{
				Dialog
				(
					playerid, DIALOG_BIZ_PROD_PRICE, DIALOG_STYLE_INPUT,
					"{33AACC}Стоимость продукта",
					"{FFFFFF}Тут Вы можете изменить стоимость продукта для бизнеса\n"\
					"Укажите цену в пределах от 25 до 28 рублей\n\n"\
					"Стоимость продукта определяет привлекательность\n"\
					"Вашего бизнеса для развозчиков продуктов\n"\
					"Чем выше цена, тем охотнее они продадут Вам свой товар\n"\
					"Однако помните, что чересчур высокая цена\n"\
					"может привести Вас к банкротству",
					"Сменить", "Назад"
				);
			}
			case BIZ_OPERATION_PROD_ORDER: // заказать продукты
			{
				Dialog
				(
					playerid, DIALOG_BIZ_ORDER_PRODS, DIALOG_STYLE_INPUT,
					"{E0584B}{SERVER_NAME} {FFFFFF}| Заказ продуктов",
					"{FFFFFF}Сколько продуктов Вы хотите заказать?",
					"Заказать", "Назад"
				);
			}
			case BIZ_OPERATION_PROD_ORDER_CANCEL: // отменить заказ
			{
				new order_id = GetBusinessData(businessid, B_ORDER_ID);
				if(order_id != -1)
				{
					new fmt_str[128];
					format
					(
						fmt_str, sizeof fmt_str,
						"{FFFFFF}Вы действительно хотите отменить заказ?\n"\
						"На счет бизнеса будет возвращено {FFCD00}%d руб",
						GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE)
					);
					Dialog(playerid, DIALOG_BIZ_ORDER_CANCEL, DIALOG_STYLE_MSGBOX, "{33AADD}Отмена заказа", fmt_str, "Да", "Нет");
				}
					else
				{
					SendClientMessage(playerid, 0xFF6600FF, "Вы не оформляли заказ продуктов для своего бизнеса");
					CallLocalFunction("ShowPlayerBusinessDialog", "ii", playerid, BIZ_OPERATION_PARAMS);
				}
			}
				
			case BIZ_OPERATION_PROFIT_STATS: // финансовая статистика
			{
				new query[256];

				new time = gettime();
				new cur_day = time - (time % 86400);
				new start_day = cur_day - (86400 * 20);

				mysql_format(mysql, query, sizeof query, "SELECT FROM_UNIXTIME(time, '%%Y-%%m-%%d') AS date, SUM(money) as total FROM business_profit WHERE bid=%d AND view=1 AND time >= %d AND time < %d GROUP BY time ORDER BY time DESC LIMIT 20", GetBusinessData(businessid, B_SQL_ID), start_day, cur_day);
				mysql_tquery(mysql, query, "ShowBusinessProfit", "ii", playerid, ++ mysql_race[playerid]);
			}
			case BIZ_OPERATION_IMPROVEMENTS: // Улучшения
			{
				new fmt_str[128];
				new string[512];
				new buffer[14 + 1];
				new i_level = GetBusinessData(businessid, B_IMPROVEMENTS);

				string = "{FFFFFF}Уровень\t{FFFFFF}Название\t{FFFFFF}Цена\n";
				for(new idx; idx < sizeof(g_business_improvements); idx ++)
				{
					valfmt(buffer, g_business_improvements[idx][I_PRICE]);
					format(fmt_str, sizeof fmt_str, "%d уровень:\t%s\t%s руб.", idx + 1, g_business_improvements[idx][I_NAME], buffer);

					if(i_level > idx)
						strins(fmt_str, "{2277AA}", 0, sizeof fmt_str);
        					else if(i_level < idx)
						strins(fmt_str, "{CC3344}", 0, sizeof fmt_str);
					else
						strins(fmt_str, "{FFFFFF}", 0, sizeof fmt_str);

					strcat(fmt_str, "\n");
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_BIZ_IMPROVEMENT, DIALOG_STYLE_TABLIST_HEADERS, "{FF0000}Доступные улучшения", string, "Купить", "Назад" );
			}
			case BIZ_OPERATION_ORDER_INFO:
			{
				new order_id = GetBusinessData(businessid, B_ORDER_ID);
				new fmt_str[512];

				if(order_id != -1 && GetOrderData(order_id, O_SQL_ID) > 0)
				{
					new year, month, day, hour, minute, second;
					timestamp_to_date(GetOrderData(order_id, O_TIME), year, month, day, hour, minute, second);

					format
					(
						fmt_str, sizeof fmt_str,
						"{FFFFFF}Это система отслеживание доставок\n\n"\
						"Ваш заказ: {FFFF00}Продукты питания\n"\
						"{FFFFFF}Номер заказа: {FFFF00}%d\n"\
						"{FFFFFF}Время создания: {FFFF00}%02d:%02d:%02d\n\n"\
						"{FFFFFF}Заказано: {FFFF00}%d кг. продуктов\n"\
						"{FFFFFF}Статус заказа: {FFFF00}%s",
						GetOrderData(order_id, O_SQL_ID),
						hour, minute, second,
						GetOrderData(order_id, O_AMOUNT),
						GetOrderData(order_id, O_USED) ? ("Доставляется") : ("В обработке")
					);
				}
					else
				{
					fmt_str = "{FFFFFF}Активных заказов для Вашего бизнеса нет.";
				}
				Dialog(playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{FF0000}Отслеживание", fmt_str, "Изменить", "Выйти" );
			}
			case BIZ_OPERATION_EMPLOYEES:
			{
				Dialog
				(
					playerid, DIALOG_BIZ_EMPLOYEES, DIALOG_STYLE_LIST,
					"{FF0000}Сотрудники",
					"{FFFFFF}1. Нанять сотрудника\n"\
					"2. Список всех сотрудников",
					"Далее", "Выйти"
				);
			}
			case BIZ_OPERATION_GPS_MARK:
			{
				SetPlayerRaceCheckpoint
				(
					playerid,
					1,
					GetBusinessData(businessid, B_POS_X),
					GetBusinessData(businessid, B_POS_Y),
					GetBusinessData(businessid, B_POS_Z),
					0.0,
					0.0,
					0.0,
					4.0
				);
				SendClientMessage(playerid, 0x66CC00FF, "Бизнес отмечен на GPS");
				CallLocalFunction("ShowPlayerBusinessDialog", "ii", playerid, BIZ_OPERATION_PARAMS);
			}
			case BIZ_OPERATION_CHANGE_BUSINESS:
			{
				return callcmd::business(playerid, "");
			}
		}
	}

	return 1;
}
stock GetSelectedBusiness(playerid)
{
    return GetPVarInt(playerid, "selected_business");
}

stock SetSelectedBusiness(playerid, businessid)
{
    SetPVarInt(playerid, "selected_business", businessid);
}
AntiDeAMX()
{
        new a[][] =
        {
                "Unarmed (Fist)",
                "Brass K"
        };
        #pragma unused a
}

public: ShowBusinessProfit(playerid, race)
{
	if(race != mysql_race[playerid])
	{
		new string[600];
		new fmt_str[32];
		new rows = cache_num_rows();

		if(rows)
		{
			string = "Дата\t\t\tПрибыль\n\n{FFFFFF}";
		}
					else string = "{FFFFFF}Финансовая статистика Вашего бизнеса еще не сформирована";

		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, fmt_str, mysql, sizeof fmt_str);
			strcat(string, fmt_str);

			format(fmt_str, sizeof fmt_str, "\t\t%d руб\n", cache_get_row_int(idx, 1));
			strcat(string, fmt_str);
		}
		Dialog(playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{33AADD}Доход бизнеса за 20 дней", string, "<< Назад", "Закрыть");
	}
}

