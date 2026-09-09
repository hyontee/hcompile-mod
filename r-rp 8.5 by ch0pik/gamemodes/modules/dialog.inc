public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	Kz_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	Sob_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	Jail_DialogRespones(playerid, dialogid, listitem, response, inputtext);
	Rub_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	MetalShop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	Donate_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	Taxi_OnDialogResponse(playerid, dialogid, response);
	Mvd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	Reward_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	CheckPropertyCaptcha(playerid, dialogid, response, inputtext);
	if(GetPVarInt(playerid, "Login_1") != 1)
	{
		printf("{FFFFFF}["SERVER_NAME_RP"]: Игрок %s попытался использовать диалог не авторизовавшись", GetPlayerNameEx(playerid));
		return 1;
	}
	if(dialogid == DIALOG_SERVER_CLOSED)
    {
        Kick(playerid);
        return 1;
    }
	if(player_DialogID[playerid] != dialogid) return 1;
	player_DialogID[playerid] = -1;

	if(dialogid == neondialog)
        {
                if(!response) return 1;
                switch(listitem)
                {
                        case 0:
                        {
                                SetPVarInt(playerid, "neon", CreateObject(18648,0,0,0,0,0,0));
                                SetPVarInt(playerid, "neon1", CreateObject(18648,0,0,0,0,0,0));
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                        }
                        case 1:
                        {
                                SetPVarInt(playerid, "neon2", CreateObject(18647,0,0,0,0,0,0));
                                SetPVarInt(playerid, "neon3", CreateObject(18647,0,0,0,0,0,0));
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon2"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon3"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                        }
                        case 2:
                        {
                                SetPVarInt(playerid, "neon4", CreateObject(18649,0,0,0,0,0,0));
                                SetPVarInt(playerid, "neon5", CreateObject(18649,0,0,0,0,0,0));
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon4"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon5"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                        }
                        case 3:
                        {
                                SetPVarInt(playerid, "neon6", CreateObject(18652,0,0,0,0,0,0));
                                SetPVarInt(playerid, "neon7", CreateObject(18652,0,0,0,0,0,0));
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon6"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon7"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                        }
                        case 4:
                        {
                                SetPVarInt(playerid, "neon8", CreateObject(18651,0,0,0,0,0,0));
                                SetPVarInt(playerid, "neon9", CreateObject(18651,0,0,0,0,0,0));
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon8"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon9"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                        }
                        case 5:
                        {
                                SetPVarInt(playerid, "neon10", CreateObject(18650,0,0,0,0,0,0));
                                SetPVarInt(playerid, "neon11", CreateObject(18650,0,0,0,0,0,0));
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon10"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(GetPVarInt(playerid, "neon11"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                        }
                        case 6:
                        {
                                DestroyObject(GetPVarInt(playerid, "neon"));
                                DestroyObject(GetPVarInt(playerid, "neon1"));
                                DestroyObject(GetPVarInt(playerid, "neon2"));
                                DestroyObject(GetPVarInt(playerid, "neon3"));
                                DestroyObject(GetPVarInt(playerid, "neon4"));
                                DestroyObject(GetPVarInt(playerid, "neon5"));
                                DestroyObject(GetPVarInt(playerid, "neon6"));
                                DestroyObject(GetPVarInt(playerid, "neon7"));
                                DestroyObject(GetPVarInt(playerid, "neon8"));
                                DestroyObject(GetPVarInt(playerid, "neon9"));
                                DestroyObject(GetPVarInt(playerid, "neon10"));
                                DestroyObject(GetPVarInt(playerid, "neon11"));
					   }
				}
                if(listitem <= 5 && listitem > 0) SendClientMessage(playerid, 0xFFFFFFAA, "Вы удачно установили неон на свой транспорт!");
                else SendClientMessage(playerid, 0xFFFFFFAA, "Вы убрали неон со своего транспорта!");
                return true;
	}
    new list_id = listitem + 1;
	if(strcmp(inputtext, "#", true) == 0 || strcmp(inputtext, "|", true) == 0 || strcmp(inputtext, "%", true) == 0 || strcmp(inputtext, "@", true) == 0 || strcmp(inputtext, "&", true) == 0) SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
	if(strfind(inputtext,"%") != -1) return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
    switch(dialogid)
    {
		case DIALOG_AHELP:
			{
				if(response)
				{
				    switch(listitem)
					{
						case 0:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 1 уровня",
							"{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}1 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
							"{"SERVER_COLOR"}/admstats \t{ffffff} Посмотреть статистику(джайл, репорт, и т.д){FFFFFF}({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/log \t{ffffff} Логирование онлайна в чат({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/sp \t{ffffff} Войти в режим слежки({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/a \t{ffffff} Административный чат{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/tplist \t{ffffff} Список телепортов{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/awarns \t{ffffff} Просмотор выговоров{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/admins \t{ffffff} Администраторы в сети{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/atinfo \t{ffffff} Просмотор нормы{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/pm \t{ffffff} Ответить игроку на репорт({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/afixcar \t{ffffff} Починить транспорт игроку по id{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/z \t{ffffff} Ответить на вопрос({FF0000}no buy admin){FFFFFF})",
		                    "Закрыть", "");
						}
						case 1:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 2 уровня",
							"{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}2 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
							"{"SERVER_COLOR"}/offmute \t{ffffff} Выдать мут оффлайн игроку({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/stats \t{ffffff} Статистика игрока{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/offstats \t{ffffff} Статистика оффлайн игрока{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/kick \t{ffffff} Кикнуть игрока({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/mute \t{ffffff} Замутить игровой чат({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/unmute \t{ffffff} Разблокировать игровой чат({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/jaillist \t{ffffff} Список игроков в деморгане{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/jail \t{ffffff} Посадить в деморган({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/unjail \t{ffffff} Выпустить игрока из деморгана({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/offjail \t{ffffff} Посадить в деморган оффлайн игрока({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/offunjail \t{ffffff} Выпустить из деморгана игрока в офлайне({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/getcar \t{ffffff} Телепортировать транспорт к себе{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/setfuel \t{ffffff}  Заправить транспортное средство{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/slap \t{ffffff} Подбросить игрока{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/rmute \t{ffffff} Замутить репорт игроку({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/unrmute \t{ffffff} Разблокировать репорт игроку({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/gotocar \t{ffffff} Телепортироватся к транспорту{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/admin_panel \t{ffffff} Админ панель({FF0000}no buy admin){FFFFFF})",
		                    "Закрыть", "");
						}
						case 2:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 3 уровня",
                            "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}3 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
							"{"SERVER_COLOR"}/neft \t{ffffff} Телепортироваться к нефтенасосу{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/stall \t{ffffff} Телепортироваться к киоску{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/gotogarden \t{ffffff} Телепортироваться к огороду{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/skin \t{ffffff} Выдать временную одежду{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/house \t{ffffff} Телепортироваться к дому{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/biz \t{ffffff} Телепортироваться к бизнесу{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/spcar \t{ffffff} Заспавнить транспортное средство({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/alock \t{ffffff} Открыть/закрыть машину{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/vipmute \t{ffffff} Мут вип-чата({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/unvipmute \t{ffffff} Снять мут вип-чата({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/sethunger \t{ffffff} Изменить уровень сытости{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/kazna_log \t{ffffff} Логирование казны({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/agivevb \t{ffffff} Выдать военный билет({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/findcar \t{ffffff} Найти машину(id, name veh){FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/vmute \t{ffffff} Выдать блокировку голосового чата({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/unvmute \t{ffffff} Снять блокировку голосового чата({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/frac_info \t{ffffff} Информация по фракциям({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/setfreeze \t{ffffff} Заморозить игрока({FF0000}no buy admin){FFFFFF})",
		                    "Закрыть", "");
						}
						case 3:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 4 уровня",
					        "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}4 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
							"{"SERVER_COLOR"}/hpall \t{ffffff} Изменить уровень здоровье в радиусе({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/msg \t{ffffff} Написать в общий-чат({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/ears \t{ffffff} Прослушка смс({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/nokay \t{ffffff}  Отказать на смену ника({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/okay \t{ffffff} Одобрить на смену ника({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/changeinfo \t{ffffff} Просмотр информации про игрока({FF0000}no buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/mutevoice \t{ffffff} Выдать мут голосового чата({FF0000}no buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/auninvite \t{ffffff} Уволить игрока из организации({FF0000}no buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/gotogarage \t{ffffff}Телепортироватся к гаражу{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
		                    "{"SERVER_COLOR"}/mp_gun \t{ffffff} Выдать оружие в радиусе({FF0000}no buy admin{FFFFFF})\n"\
		                    "{"SERVER_COLOR"}/mp_skin \t{ffffff} Выдать скины в радиусе({FF0000}no buy admin{FFFFFF})\n"\
		                    "{"SERVER_COLOR"}/mp_freeze \t{ffffff} Заморозить в радиусе({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/mp_unfreeze \t{ffffff} Разморозить в радиусе({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/agm \t{ffffff}Режим бессмертия{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
		                    "{"SERVER_COLOR"}/removegun \t{ffffff} Отобрать оружие у игрока({FF0000}no buy admin{FFFFFF})\n"\
		                    "{"SERVER_COLOR"}/mplist \t{ffffff} Открыть меню мероприятий({FF0000}no buy admin{FFFFFF})\n"\
		                    "{"SERVER_COLOR"}/armourall \t{ffffff} Выдать в радиусе бронижилет({FF0000}no buy admin{FFFFFF})",
		                    "Закрыть", "");
						}
						case 4:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 5 уровня",
					        "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}5 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
							"{"SERVER_COLOR"}/amsg \t{ffffff} Написать в общий-чат от администратора({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/lip \t{ffffff} Посмотреть аккаунты с одинаковым айпи({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/skick \t{ffffff} Кикнуть игрока({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/setweather \t{ffffff} Изменить погоду({FF0000}no buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/settime \t{ffffff} Изменить время({FF0000}no buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/agivelic \t{ffffff} Выдать лицензию({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/setskills \t{ffffff} Выдать скиллы на оружие({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/bank_log \t{ffffff} Посмотреть банковские логи игрока({FF0000}no buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/adminlist \t{ffffff} Посмотреть админ лист{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/finditem \t{ffffff} Найти айди предмета{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/spcars \t{ffffff} Сделать респавин незанятого транспорта({FF0000}no buy admin{FFFFFF})",
		                    "Закрыть", "");
						}
						case 5:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 6 уровня",
                            "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}6 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
                            "{"SERVER_COLOR"}Название команды \t Описание\n"\
							"{"SERVER_COLOR"}/money \t{ffffff} Посмотреть валюту игрока{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/unmutevoice \t{ffffff} Разблокировать голосовой чат({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/inter \t{ffffff} Изменить интерьер игроку{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/world \t{ffffff} Изменить виртуальный мир игроку{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/givegun \t{ffffff} Выдать оружие игроку{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
							"{"SERVER_COLOR"}/aefir \t{ffffff} Войти в эфир({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/aedit \t{ffffff} Редактировать обьявление({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/at \t{ffffff} Написать в эфир({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/alldelveh \t{ffffff} Удалить автомобили созданные администрацией({FF0000}no buy admin){FFFFFF})",
		                    "Закрыть", "");
						}
						case 6:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 7 уровня",
					        "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}7 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
                            "{"SERVER_COLOR"}/offunwarn \t{ffffff} Снять предупреждение офлайн({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/money_log \t{ffffff} Просмотреть деньги игрока{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/houseinfo \t{ffffff} Посмотреть информацию о доме{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/bizinfo \t{ffffff} Посмотреть информацию о бизнесе{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/sscar \t{ffffff} Сделать респавн автомобилей({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/infowork \t{ffffff} Информация о заводах/складах{FFFFFF}({00ff00}yes buy admin{FFFFFF})",
		                    "Закрыть", "");
						}
						case 7:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 8 уровня",
					        "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}8 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
                            "{"SERVER_COLOR"}/info_world \t{ffffff} Посмотреть в каком ты мире,интерьере{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/add_tplist \t{ffffff} Создать точку телепорта({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/get_car_market \t{ffffff} Посмотреть количество автомобилей в автосалонах{FFFFFF}({00ff00}yes buy admin{FFFFFF})\n"\
                            "{"SERVER_COLOR"}/a_atinfo \t{ffffff} Посмотреть статистику администратора{FFFFFF}({00ff00}yes buy admin{FFFFFF})",
		                    "Закрыть", "");
						}
						case 8:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 9 уровня",
					        "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}9 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
                            "{"SERVER_COLOR"}/unwarn \t{ffffff} Снять предупреждение({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/getname \t{ffffff} Узнать никнейм по айди в базе данных({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/hardban \t{ffffff} Заблокировать по железу({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/getcamera \t{ffffff} Узнать кординаты камеры{FFFFFF}({00ff00}yes buy admin{FFFFFF})",
		                    "Закрыть", "");
						}
						case 9:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 10 уровня",
					        "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}10 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
                            "{"SERVER_COLOR"}/unban \t{ffffff} Разблокировать аккаунт({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/give_jticket \t{ffffff} Выдать купон анти-деморган({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/information \t{ffffff} Написать на весь сервер({FF0000}no buy admin){FFFFFF})",
		                    "Закрыть", "");
						}
						case 10:
						{
							Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды администратора 11 уровня",
					        "{ffffff}Здесь отображены актуальные команды администратора: {"SERVER_COLOR"}11 {ffffff}уровня\n"\
				            "{ffffff}Покупным администраторам доступны не все команды.\n"\
					        "{ffffff}Рекомендация: Не злоупотребляйте командами! Грозит снятием и с ЧС проекта.\n\n"\
					        "{"SERVER_COLOR"}Название команды \t Описание\n"\
							"{"SERVER_COLOR"}/contspawn \t{ffffff} Спавн контейнеров({FF0000}no buy admin){FFFFFF})\n"\
                           	"{"SERVER_COLOR"}/dumpspawn \t{ffffff} Спавн свалки({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/add_black_market \t{ffffff} Запустить черный рынок({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/addneft \t{ffffff} Добавить нефтенасос({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/givecase \t{ffffff} Выдать кейс({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/givekey \t{ffffff} Выдать Ключ({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/givecaseall \t{ffffff} Выдать кейсы всему серверу({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/kiosk_slot \t{ffffff} выдать слот на киоск({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/asellgarden \t{ffffff} Продать огород игрока({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/addgarden \t{ffffff} Добавить огород({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/setbizwar \t{ffffff} Убрать крышу бизнеса({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/garden_slot \t{ffffff} Выдать слот на огород({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/soffban \t{ffffff} Заблокировать навсегда({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/unbanip \t{ffffff} Разблокировать по айпи({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/giveskin \t{ffffff} Выдать скин навсегда({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/addneft \t{ffffff} Создать нефтевышку({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/givecaseall \t{ffffff} Выдать кейс всему серверу({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/payday \t{ffffff} Устроить PayDay({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/setleader  \t{ffffff} Поставить на лидерку({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/givedonate  \t{ffffff} Выдать донат({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/jetpack  \t{ffffff} Использывать джетпак({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/a_tuning  \t{ffffff} Поставить тюнинг на машину({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/givecar  \t{ffffff} ПВыдать машину({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/awarn  \t{ffffff} Выдать админ-выговор({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/unawarn  \t{ffffff} Снять админ-выговор({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/giveall  \t{ffffff} Открыть меню роздачи({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/giveitem  \t{ffffff} Выдать предмет({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/createcode  \t{ffffff} Создать бонус-код({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/offhardban  \t{ffffff} В оффлайне заблокировать по железу({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/givemoney  \t{ffffff} Выдать деньги({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/delownablecar  \t{ffffff} Удалить личный т/с({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/givecoins  \t{ffffff} Выдать коинсы({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/reset_donate  \t{ffffff} Забрать донат({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/getlog \t{ffffff} Логи({FF0000}no buy admin){FFFFFF})\n"\
							"{"SERVER_COLOR"}/addgunmo \t{ffffff} Сделать разброс оружия по военной части({FF0000}no buy admin){FFFFFF})\n"\
                            "{"SERVER_COLOR"}/setvip \t{ffffff} Выдать вип-статус({FF0000}no buy admin){FFFFFF})",
		                    "Закрыть", "");
						 }
				   }
   			}
		}
		case dJobPilot:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerData(playerid, pPlainLic) != 1) return SCM(playerid, 0x999999FF, "* Для начала купите лицензию");
					SetPlayerPos(playerid, 2705.4731,-1899.2540,22.0031);
					PlainVeh[playerid] = AddStaticVehicleEx(519,2702.0137,-1904.0129,23.4342,300.2607,1,1,360);
					SCM(playerid, 0x999999FF, "* Осуществите посадку пассажиров!");
					SCM(playerid, 0x999999FF, "* Чтобы закончить рейс выпрыгните из самолёта.");
					SetPlayerRaceCheckpoint(playerid,3,gPlainPoints[42][0], gPlainPoints[42][1], gPlainPoints[42][2],gPlainPoints[42][3], gPlainPoints[42][4], gPlainPoints[42][5],20.0,2021);
					PlayerIsPlain[playerid] = 1;
					PutPlayerInVehicle(playerid, PlainVeh[playerid], 0);
				}
				case 1:
				{
					if(GetPlayerData(playerid, pPlainLic) == 1) return SCM(playerid, 0x999999FF, "* У вас уже есть лицензия");
					Dialog(playerid, dBuyPlainLic, DSM, "Покупка лицензии","Лицензия на управление самолётом стоит 1.000.000 Руб<n><n>Вы хотите его купить?","Купить","Назад");
				}
			}
		}
		case dBuyPlainLic:
		{
			if(!response) return Dialog(playerid, dJobPilot, DSL, "Пилот" , "Устройство на работу пилота\nКупить лицензию" , "Выбрать", "Отмена");
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 1000000)) return SendClientMessage(playerid, 0x999999FF, "* Недостаточно средств!");
			GivePlayerMoneyEx(playerid, -1000000);
			SetPlayerData(playerid, pPlainLic, 1);
			Dialog(playerid, dJobPilot, DSL, "Пилот" , "Устройство на работу пилота\nКупить лицензию" , "Выбрать", "Отмена");
			UpdatePlayerDatabaseInt(playerid, "PlainLic",GetPlayerData(playerid, pPlainLic));
		}
		case DIALOG_GIVE_ITEM_ALL:
		{
			if(!response) return 1;

			str_q[0] = EOS;

			format(str_q, sizeof str_q, "Выдача предмета %s", give_item[listitem][E_GIVE_ITEM_NAME]);

			Dialog(playerid, DIALOG_GIVE_ITEM_COUNT, DIALOG_STYLE_INPUT, str_q, "Введите количество предмета", "Ввести", "Отмена");

			SetPVarInt(playerid, "giveitem_all", listitem);
		}
		case 4692:
	    {
			if(response)
			{
				if(strlen(inputtext) < 5 || strlen(inputtext) > 100)
				{
					format(string_dialog, sizeof string_dialog, "{FFFFFF}Текущее название:\n{AFAFAF}''%s''{ffffff}\n\nВведите новое название мероприятия (5-100 символов):\n\n{FF1C05}Ошибка:{ffffff} Слишком мало либо много символов!", MPName);
					Dialog(playerid, 4692, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Название мероприятия", STRING_GLOBAL, "Изменить", "Назад");
					return 0;
				}
				callcmd::eventmenu(playerid);
				SCM(playerid, 0xa6a6a6FF, "[Event]{FFFFFF} Вы изменили название мероприятия!");
			}
			else callcmd::eventmenu(playerid);
		}
		case 4693:
	    {
			if(response)
			{
				if(strval(inputtext) < 0 || strval(inputtext) > 100)
				{
					format(string_dialog, sizeof string_dialog, "{FFFFFF}Текущее значение: {AFAFAF}%d HP{ffffff}\n\nВведите новое количество здоровья (1-100):\n\n{FF1C05}Ошибка:{ffffff} Слишком маленькое либо большое значение!", MPHealth);
					Dialog(playerid, 4693, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Количество здоровья", STRING_GLOBAL, "Изменить", "Назад");
					return 0;
				}
				MPHealth = strval(inputtext);
				callcmd::eventmenu(playerid);
				SCM(playerid, 0xa6a6a6FF, "[Event]{FFFFFF} Вы изменили значения здоровья!");
			}
			else callcmd::eventmenu(playerid);
		}
		case 4694:
	    {
			if(response)
			{
				if(strval(inputtext) < 0 || strval(inputtext) > 100)
				{
					format(string_dialog, sizeof string_dialog, "{FFFFFF}Текущее значение: {AFAFAF}%d брони{ffffff}\n\nВведите новое количество брони (1-100):\n\n{FF1C05}Ошибка:{ffffff} Слишком маленькое либо большое значение!", MPArmour);
					Dialog(playerid, 4694, DIALOG_STYLE_INPUT, !"{9ACD32}» {FFFFFF}Количество брони", STRING_GLOBAL, "Изменить", "Назад");
					return 0;
				}
				MPArmour = strval(inputtext);
				callcmd::eventmenu(playerid);
				SCM(playerid, 0xa6a6a6FF, "[Event]{FFFFFF} Вы изменили значения брони!");
			}
			else callcmd::eventmenu(playerid);
		}
		case 4695:
	    {
			if(response)
			{
				if(strval(inputtext) < 1 || strval(inputtext) > 1000)
				{
					format(string_dialog, sizeof string_dialog, "{FFFFFF}Текущий лимит игроков: {AFAFAF}%d{ffffff}\n\nЧтобы изменить, введите ниже новое значение: (1-1000 игроков)\n\n{FF1C05}Ошибка:{ffffff} Слишком маленькое либо большое значение!", MPPlayerLimit);
					Dialog(playerid, 4695, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Лимит игроков",STRING_GLOBAL,"Изменить", "Назад");
					return 0;
				}
				MPPlayerLimit = strval(inputtext);
				callcmd::eventmenu(playerid);
				SCM(playerid, 0xa6a6a6FF, "[Event]{FFFFFF} Вы изменили лимит игроков на мероприятие!");
			}
			else callcmd::eventmenu(playerid);
		}
		case 4696:
	    {
			if(response)
			{
				if(strval(inputtext) < 1 || strval(inputtext) > 1200)
				{
					format(string_dialog, sizeof string_dialog, "{ffffff}Текущее время действия(после запуска): {AFAFAF}%d сек{ffffff}\n\nЧтобы изменить, введите ниже новое значение: (10-1200 сек)\n\n{FF1C05}Ошибка:{ffffff} Слишком маленькое либо большое значение!", MPTimeStatic);
					Dialog(playerid, 4696, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Время телепорта", STRING_GLOBAL, "Изменить", "Назад");
					return 0;
				}
				MPTimeStatic = strval(inputtext);
				callcmd::eventmenu(playerid);
				SCM(playerid, 0xa6a6a6FF, "[Event]{FFFFFF} Вы изменили время действия телепорта!");
			}
			else callcmd::eventmenu(playerid);
		}
		case 4697:
		{
		    if(response)
		    {
				ResetPlayerWeapons(playerid);
				SetPlayerArmour(playerid, MPArmour);
				SetPlayerHealthEx(playerid, MPHealth);
			    SetPlayerInterior(playerid, TeleportInfoq[1]);
				SetPlayerVirtualWorld(playerid, TeleportInfoq[0]);
				SetPlayerPos(playerid, TeleportFloat[0], TeleportFloat[1], TeleportFloat[2]);

				MPPlayersLimit --;
				if(!MPPlayersLimit)
				{
				    SendClientMessageToAll(0xbd2d2dFF, "[Ошибка]{ffffff} Мероприятие еще не началось!");
					Teleport = 0;
					MPTime = 500;
				}
				if(MPTeleport == 1)
					MPTeleportPlayer{playerid} = true;

				return 1;
		    }
		}
		case DIALOG_EVENT_MENU:
	    {
			if(response)
			{
				string_dialog[0] = EOS;
				switch(listitem)
				{
					case 0:
					{
						SCM(playerid, 0xa6a6a6FF, "[Event]{FFFFFF} Вы установили позицию телепорта для мероприятия!");
						GetPlayerPos(playerid, TeleportFloat[0], TeleportFloat[1], TeleportFloat[2]);
						TeleportInfoq[0] = GetPlayerInterior(playerid); 
						TeleportInfoq[1] = GetPlayerVirtualWorld(playerid); 
						callcmd::eventmenu(playerid);
					}
					case 1:
					{
						format(string_dialog, sizeof string_dialog, "{FFFFFF}Текущее название:\n{AFAFAF}''%s''{ffffff}\n\nВведите новое название мероприятия (5-100 символов):", MPName);
						Dialog(playerid, 4692, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Название мероприятия", string_dialog, "Изменить", "Назад");
					}
					case 2:
				    {
						format(string_dialog, sizeof string_dialog, "{FFFFFF}Текущее значение: {AFAFAF}%d HP{ffffff}\n\nВведите новое количество здоровья (1-100):", MPHealth);
						Dialog(playerid, 4693, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Количество здоровья", string_dialog, "Изменить", "Назад");
				    }
					case 3:
				    {
						format(string_dialog, sizeof string_dialog, "{FFFFFF}Текущее значение: {AFAFAF}%d брони{ffffff}\n\nВведите новое количество брони (0-100):", MPArmour);
						Dialog(playerid, 4694, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Количество брони", string_dialog, "Изменить", "Назад");
				    }
					case 4:
				    {
						format(string_dialog, sizeof string_dialog,"{FFFFFF}Текущий лимит игроков: {AFAFAF}%d{FFFFFF}\n\nВведите новый лимит игроков (1-999 игроков):", MPPlayerLimit);
						Dialog(playerid, 4695, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Лимит игроков", string_dialog, "Изменить", "Назад");
				    }
					case 5:
				    {
						format(string_dialog, sizeof string_dialog,"{FFFFFF}Текущее время действия(после запуска): {AFAFAF}%d сек{FFFFFF}\n\nЧтобы изменить, введите ниже новое значение: (10-1200 сек)", MPTimeStatic);
						Dialog(playerid, 4696, DIALOG_STYLE_INPUT, "{9ACD32}» {FFFFFF}Время действия телепорта", string_dialog, "Изменить", "Назад");
				    }
					case 6:
				    {
				        if(!MPTeleport)
				        {
				            MPTeleport = 1;
				            callcmd::eventmenu(playerid);
						}
						else
						{
						    MPTeleport = 0;
						    foreach(new i: Player)
						    {
								MPTeleportPlayer{i} = false;
						    }
				            callcmd::eventmenu(playerid);
						}
				    }
					case 7:
					{
						if(TeleportFloat[0] == 0 || TeleportFloat[1] == 0 || TeleportFloat[2] == 0)
						{
							SCM(playerid, 0xa6a6a6FF, "[Event]{FFFFFF} Позиция для телепорта отсутствует!");
							callcmd::eventmenu(playerid);
							return 1;
						}

						if(Teleport == 1)
						{
							Teleport = 0;
							MPTime = 500;
							SCM(playerid, -1, "[Event] {ffffff}Вы успешно {CD5C5C}деактивировали телепорт на мероприятие!");
							return 1; 
						}

						new name[MAX_PLAYER_NAME];
						GetPlayerName(playerid, name, sizeof(name));
						MPPlayersLimit = MPPlayerLimit;
						MPTime = MPTimeStatic;
						Teleport = 1;

						SCMF(playerid, 0xc48fd4FF, "[Event] {ffffff}Началось мероприятие: '%s', чтобы участвовать /gomp", MPName);
						SCMF(playerid, 0xc48fd4FF, "[Event] {ffffff}Организатор мероприятия: {CC95DD}%s", name);
						return 1;
					}
				}
			}
		}
		case DIALOG_RGLUSH:
		{
			switch(listitem + 1)
			{
				case 1:
				{
					if(GetPVarInt(playerid, "glush") == 1)
					{
						if(federal_glush[0] == 1) return SCM(playerid, COLOR_RED, "Рация Правительства уже находится под подавлением.");
						federal_glush[0] = 1;
						SCM(playerid, 0x8fd393FF, "Вы активировали глушение радиоканала фракции: \"Правительство\"");
						SetPVarInt(playerid, "glush", 0);
					}
					else
					{
						federal_glush[0] = 0;
						SCM(playerid, 0x8fd393FF, "Вы отключили подавление радиоканала: \"Правительство\"");
					}
				}
				case 2:
				{
					if(GetPVarInt(playerid, "glush") == 1)
					{
						if(federal_glush[1] == 1) return SCM(playerid, COLOR_RED, "Рация Министерства Обороны уже находится под подавлением.");
						federal_glush[1] = 1;
						SCM(playerid, 0x8fd393FF, "Вы активировали глушение радиоканала фракции: \"Министерство Обороны\"");
						SetPVarInt(playerid, "glush", 0);
					}
					else
					{
						federal_glush[1] = 0;
						SCM(playerid, 0x8fd393FF, "Вы отключили подавление радиоканала: \"Министерство Обороны\"");
					}
				}
				case 3:
				{
					if(GetPVarInt(playerid, "glush") == 1)
					{
						if(federal_glush[2] == 1) return SCM(playerid, COLOR_RED, "Рация Министерства Здравоохранения уже находится под подавлением.");
						federal_glush[2] = 1;
						SCM(playerid, 0x8fd393FF, "Вы активировали глушение радиоканала фракции: \"Министерство Здравоохранения\"");
						SetPVarInt(playerid, "glush", 0);
					}
					else
					{
						federal_glush[2] = 0;
						SCM(playerid, 0x8fd393FF, "Вы отключили подавление радиоканала: \"Министерство Здравоохранения\"");
					}
				}
				case 4:
				{
					if(GetPVarInt(playerid, "glush") == 1)
					{
						if(federal_glush[3] == 1) return SCM(playerid, COLOR_RED, "Рация ТРК 'Ритм' уже находится под подавлением.");
						federal_glush[3] = 1;
						SCM(playerid, 0x8fd393FF, "Вы активировали глушение радиоканала фракции: \"ТРК 'Ритм'\"");
						SetPVarInt(playerid, "glush", 0);
					}
					else
					{
						federal_glush[3] = 0;
						SCM(playerid, 0x8fd393FF, "Вы отключили подавление радиоканала: \"ТРК 'Ритм'\"");
					}
				}
				case 5:
				{
					if(GetPVarInt(playerid, "glush") == 1)
					{
						if(federal_glush[4] == 1) return SCM(playerid, COLOR_RED, "Рация ФСИН уже находится под подавлением.");
						federal_glush[4] = 1;
						SCM(playerid, 0x8fd393FF, "Вы активировали глушение радиоканала фракции: \"Федеральная служба исполнения наказаний\"");
						SetPVarInt(playerid, "glush", 0);
					}
					else
					{
						federal_glush[4] = 0;
						SCM(playerid, 0x8fd393FF, "Вы отключили подавление радиоканала: \"Федеральная служба исполнения наказаний\"");
					}
				}
				case 6:
				{
					if(GetPVarInt(playerid, "glush") == 1)
					{
						if(federal_glush[5] == 1) return SCM(playerid, COLOR_RED, "Рация Министерства Внутренних Дел уже находится под подавлением.");
						federal_glush[5] = 1;
						SCM(playerid, 0x8fd393FF, "Вы активировали глушение радиоканала фракции: \"Министерство Внутренних Дел\"");
						SetPVarInt(playerid, "glush", 0);
					}
					else
					{
						federal_glush[5] = 0;
						SCM(playerid, 0x8fd393FF, "Вы отключили подавление радиоканала: \"Министерство Внутренних Дел\"");
					}
				}
			}
		}
		case DIALOG_GLUSH:
		{
			switch(listitem+1)
			{
				case 1:
				{
					SetPVarInt(playerid, "glush", 1);
					Dialog(playerid, DIALOG_RGLUSH, DIALOG_STYLE_LIST, "Глушилка, выберите организацию:",
					"Правительство\n"\
					"Мин.Обороны\n"\
					"Мин.Здравоохранения\n"\
					"ТРК 'Ритм'\n"\
					"ФСИН\n"\
					"МВД",
					"Далее", "Отмена");
				}
				case 2:
				{
					SetPVarInt(playerid, "glush", 2);
					Dialog(playerid, DIALOG_RGLUSH, DIALOG_STYLE_LIST, "Глушилка, выберите организацию:",
					"Правительство\n"\
					"Мин.Обороны\n"\
					"Мин.Здравоохранения\n"\
					"ТРК 'Ритм'\n"\
					"ФСИН\n"\
					"МВД",
					"Далее", "Отмена");
				}
			}
		}
		case DIALOG_GIVE_ITEM_COUNT:
		{
			if(!response) return 1;

			new item = GetPVarInt(playerid, "giveitem_all");
			new count = strval(inputtext);

			if(count < 1) return 1;

			foreach(new i : Player)
			{
				switch(give_item[item][E_GIVE_ITEM_ID])
				{
					case 0: GivePlayerMoneyEx(i, count, "Выдача от админа");
					case 1: GivePlayerDonate(i, count, "Выдача от админа");
					case 2: GiveIteam(i, 293, 1, count, 0, "Выдача от админа");
					case 3: GivePlayerCoins(i, count);
					case 4: AddPlayerData(i, P_BIZ_SLOTS, +, count), UpdatePlayerDatabaseInt(i, "biz_slots", GetPlayerData(playerid, P_BIZ_SLOTS));
					case 5: AddPlayerData(i, P_HOUSE_SLOTS, +, count), UpdatePlayerDatabaseInt(i, "house_slots", GetPlayerData(playerid, P_HOUSE_SLOTS));
					case 6: AddPlayerData(i, P_CAR_SLOTS, +, count), UpdatePlayerDatabaseInt(i, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
					case 7: AddPlayerData(i, P_KIOSK_SLOTS, +, count), UpdatePlayerDatabaseInt(i, "kiosk_slots", GetPlayerData(playerid, P_KIOSK_SLOTS));
					case 8: AddPlayerData(i, P_GARDEN_SLOTS, +, count), UpdatePlayerDatabaseInt(i, "garden_slots", GetPlayerData(playerid, P_GARDEN_SLOTS));
					case 9: AddPlayerData(i, P_GARAGE_SLOTS, +, count), UpdatePlayerDatabaseInt(i, "garage_slots", GetPlayerData(playerid, P_GARAGE_SLOTS));
					default: GiveIteam(i, give_item[item][E_GIVE_ITEM_ID], 1, count, 0);
				}
				SCMF(i, 0xFFCD00FF, "A: %s[%d] выдал Вам предмет %s в количестве %d шт", GetPlayerNameEx(playerid), playerid, give_item[item][E_GIVE_ITEM_NAME], count);
			}

			DeletePVar(playerid, "giveitem_all");
		}
		case DIALOG_DONATE_BUY:
		{
			if(!response) return ShowPlayerDonateMenu(playerid);

			new	query[94],
				Cache: result;

			format(query, sizeof query, "SELECT * FROM donate_items WHERE id=%d LIMIT 1", GetPlayerListitemValue(playerid, listitem));
			result = mysql_query(mysql, query, true);

			new name[48];

			cache_get_field_content(0, "name", name);
			new item_id = cache_get_field_content_int(0, "item_id");
			new price = cache_get_field_content_int(0, "price");
			new count = cache_get_field_content_int(0, "count");
			new type = cache_get_field_content_int(0, "type");
			new indx = cache_get_field_content_int(0, "indx");

			cache_delete(result);

			if(GetPlayerCoins(playerid) < price) return GameText(playerid, "~r~Недостаточно~n~"SERVER_COINS_NAME"", 3000, 2), ShowPlayerDonateMenu(playerid);

			if(type == 1)
			{
				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты.");

				GivePlayerCoins(playerid, -price);
				GiveCar(playerid, item_id, 1, 1, 0, 0, 110.8994,322.3508,11.2202,251.4996, gettime());

				SCMF(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}Вы успешно приобрели транспорт: {FFFFFF}%s[№%d] {"SERVER_COLOR"}за {FFFFFF}%d "SERVER_COINS_NAME"", name, item_id, price);
			}
			if(type == 2)
			{
				if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

				GivePlayerCoins(playerid, -price);
				GiveSkin(playerid, item_id);

				SCMF(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}Вы успешно приобрели одежду: {FFFFFF}%s[№%d] {"SERVER_COLOR"}за {FFFFFF}%d "SERVER_COINS_NAME"", name, item_id, price);
			}
			if(type == 3)
			{
				if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

				GivePlayerCoins(playerid, -price);
				GiveAcs(playerid, item_id, indx);

				SCMF(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}Вы успешно приобрели аксессуар: {FFFFFF}%s[№%d] {"SERVER_COLOR"}за {FFFFFF}%d "SERVER_COINS_NAME"", name, item_id, price);
			}
			if(type == 5)
			{
				GivePlayerCoins(playerid, -price);

				GiveIteam(playerid, item_id, 1, count, 0);

				SCMF(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}Вы успешно приобрели: {FFFFFF}%s[№%d] {"SERVER_COLOR"}в количестве {FFFFFF}%d шт. {"SERVER_COLOR"}за {FFFFFF}%d "SERVER_COINS_NAME"", name, item_id, count, price);
			}
			if(type == 4)
			{
				GivePlayerCoins(playerid, -price);
				
				if(indx == 1) // дома
				{
					AddPlayerData(playerid, P_HOUSE_SLOTS, +, count);
					UpdatePlayerDatabaseInt(playerid, "house_slots", GetPlayerData(playerid, P_HOUSE_SLOTS));
				}
				if(indx == 2) // бизнесы
				{
					AddPlayerData(playerid, P_BIZ_SLOTS, +, count);
					UpdatePlayerDatabaseInt(playerid, "biz_slots", GetPlayerData(playerid, P_BIZ_SLOTS));
				}
				if(indx == 3) // гаражи
				{
					AddPlayerData(playerid, P_GARAGE_SLOTS, +, count);
					UpdatePlayerDatabaseInt(playerid, "garage_slots", GetPlayerData(playerid, P_GARAGE_SLOTS));
				}
				if(indx == 4) // кары
				{
					AddPlayerData(playerid, P_CAR_SLOTS, +, count);
					UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
				}
				if(indx == 5) // огороды
				{
					AddPlayerData(playerid, P_GARDEN_SLOTS, +, count);
					UpdatePlayerDatabaseInt(playerid, "garden_slots", GetPlayerData(playerid, P_GARDEN_SLOTS));
				}
				if(indx == 6) // киоски
				{
					AddPlayerData(playerid, P_KIOSK_SLOTS, +, count);
					UpdatePlayerDatabaseInt(playerid, "kiosk_slots", GetPlayerData(playerid, P_KIOSK_SLOTS));
				}
				if(indx == 7) // аукцион
				{
					AddPlayerData(playerid, P_AUCTION_SLOTS, +, count);
					UpdatePlayerDatabaseInt(playerid, "auction_slots", GetPlayerData(playerid, P_AUCTION_SLOTS));
				}
				SCMF(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}Вы успешно приобрели: {FFFFFF}%s {"SERVER_COLOR"}в количестве {FFFFFF}%d шт. {"SERVER_COLOR"}за {FFFFFF}%d "SERVER_COINS_NAME"", name, count, price);
			}
		}
		case TRASH_PLAYER_WORK:
		{
			if (response)
			{
				SetPlayerCheckpoint(playerid, 
				g_trash_work[GetPlayerListitemValue(playerid, listitem)][TRASH_POS_X], 
				g_trash_work[GetPlayerListitemValue(playerid, listitem)][TRASH_POS_Y], 
				g_trash_work[GetPlayerListitemValue(playerid, listitem)][TRASH_POS_Z], 
				10.0, 
				CP_PUT_TRASH_WORK);
				g_player_trash[playerid][TRASH_ID] = GetPlayerListitemValue(playerid, listitem);
			}
		}	
		case RENT_WORK_VEHICLE:
		{
			if(response)
			{
				g_player_trash[playerid][TRASH_ID_CAR] = GetPlayerVehicleID(playerid);
			}
			else 
			{
				return 1;
			}
		}
		case DIALOG_DUCK:
		{
		        if(!response) return 1;
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -164.471,2519.11,-0.20415))
				{
					if(duckobjects[0][0] != 1) return 1;
					GiveIteam(playerid, 129, 1, 1, 0);
					DestroyObject(duckobject[0]);
					DestroyDynamic3DTextLabel(DuckLabel[0]);
					duckobjects[0][0] = 0;
					//Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 13.5, -136.487, 2502.84, -0.1893))
				{
					if(duckobjects[1][0] != 1) return 1;
					GiveIteam(playerid, 129, 1, 1, 0);
					DestroyObject(duckobject[1]);
					DestroyDynamic3DTextLabel(DuckLabel[1]);
					duckobjects[1][0] = 0;
					//Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -136.959,2514.65,-0.128582))
				{
					if(duckobjects[2][0] != 1) return 1;
					GiveIteam(playerid, 129, 1, 1, 0);
					DestroyObject(duckobject[2]);
					DestroyDynamic3DTextLabel(DuckLabel[2]);
					duckobjects[2][0] = 0;
					//Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -154.598, 2525.09, -0.189611))
				{
					if(duckobjects[3][0] != 1) return 1;
					GiveIteam(playerid, 129, 1, 1, 0);
					DestroyObject(duckobject[3]);
					DestroyDynamic3DTextLabel(DuckLabel[3]);
					duckobjects[3][0] = 0;
					//Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -145.975, 2463.3, -0.159682))
				{
					if(duckobjects[4][0] != 1) return 1;
					GiveIteam(playerid, 129, 1, 1, 0);
					DestroyObject(duckobject[4]);
					DestroyDynamic3DTextLabel(DuckLabel[4]);
					duckobjects[4][0] = 0;
					//Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -137.928,2472.88, -0.082577))
				{
					if(duckobjects[5][0] != 1) return 1;
					GiveIteam(playerid, 129, 1, 1, 0);
					DestroyObject(duckobject[5]);
					DestroyDynamic3DTextLabel(DuckLabel[5]);
					duckobjects[5][0] = 0;
					//Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
			}
			case DIALOG_CONT_SPAWN1:
        {
        if(!response) return 1;
        switch(listitem)
        {
            case 0:
            {
		    if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 50000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -50000000, "Контейнер с машинами", true,true);
			AddContainers(6);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
			SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
		    }
		    }
            case 1:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 35000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -35000000, "Контейнер с одеждой", true,true);
			AddContainers(4);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
			SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
	    	}
	    	}
            case 2:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 30000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -30000000, "Контейнер с недорогой одеждой", true,true);
			AddContainers(3);
			GameText(playerid, "УСПЕШНО",2000,3);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
            }
            }
            case 3:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 30000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -30000000, "Контейнер с акссесуарами", true,true);
			AddContainers(7);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
			SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
            }
            }
            case 4:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 25000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -25000000, "Контейнер с спец.товаром", true,true);
			AddContainers(5);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
			SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
		    }
			}
            case 5:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 20000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -20000000, "Контейнер с антиквариатом", true,true);
			AddContainers(0);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
			SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
            }
            }
            case 6:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 20000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -20000000, "Контейнер с мебелью", true,true);
			AddContainers(2);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
            SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
            }
            }
            case 7:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 20000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -20000000, "Контейнер с техникой", true,true);
            AddContainers(1);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
            SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
            }
			}
			case 8:
            {
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 25000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
            {
            if(GetPVarInt(playerid,"SpawnCont") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить контейнера можно раз в 30  минут!");
			GivePlayerMoneyEx(playerid, -20000000, "Рандомный контейнер", true,true);
            AddContainers(8);
			new str[128];
			format(str, sizeof(str), "{FFA040}[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(-1, str);
			GameText(playerid, "УСПЕШНО",2000,3);
            SetPVarInt(playerid,"SpawnCont",gettime() + 1800);
            }
			}
         }
       }
       case DIALOG_SVALKA_SPAWN1:
   	   {
		    if(response)
		    {
		        if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 50000000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
				{
                    if(GetPVarInt(playerid,"SpawnSvalka") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Спавнить свалку можно раз в 30  минут!");
					GivePlayerMoneyEx(playerid, -50000000, "Спавн свалки", true, true);
	   				OnCreateSvalka();
					new str[128];
					format(str, sizeof(str), "[INFO] Инициатор: %s[%d].", GetPlayerNameEx(playerid), playerid);
					SendClientMessageToAll(0xead671FF, str);
					GameText(playerid, "УСПЕШНО",2000,3);
	   				SetPVarInt(playerid,"SpawnSvalka",gettime() + 1800);
	   				return 1;
				}
			}
		}
		case DIALOG_JOB_SNOW:
            {
                  if(response)
                  {
                        if(snowjob[playerid][0] == 0)
                        {
                           snowjob[playerid][1] = CreateVehicle(15242,-665.3651,-1761.6851,40.7364,327.1854,1,1, -1, 0);
                           PutPlayerInVehicle(playerid, snowjob[playerid][1], 0);
                           SCM(playerid, 0x999999FF, "* Вы начали работу снегоуборщика, следуйте чекпоинтам, если вы хотите завершить работу то просто выйдите из автомобиля");
                           snowjob[playerid][3] = GetPlayerSkin(playerid);

                           SetPlayerRaceCheckpoint(playerid, 1, -655.9334,-1774.1927,40.9375, 0.0,0.0,0.0, 6.0, 23656);
                           //DestroyPlayerObject(snowobject[playerid]);
                           //snowobject[playerid] = CreatePlayerObject(playerid, 849, -655.9334,-1774.1927,40.9375+ -2.19371,141.7700, 6.0);
                           SetPlayerSkin(playerid, 16);
                           snowjob[playerid][0] = 1;
                        }
                  }
            }
            case DIALOG_JOB_SNOW_END:
            {
                  if(response)
                  {
			      DisablePlayerRaceCheckpoint(playerid);
                  DestroyVehicle(snowjob[playerid][1]);
                  snowjob[playerid][0] = 0;
                  GivePlayerMoneyEx(playerid, snowjob[playerid][2]);
                  snowjob[playerid][2] = 0;
                  snowjob[playerid][1] = 0;
                  SetPlayerSkin(playerid, snowjob[playerid][3]);
               }
        	}
			case DIALOG_BUY_BCODE1:
			{
			    if(!response) return 1;

			    new code[17];
			    new len = random(7) + 6; 
			    for(new i = 0; i < len; i++) {
			        code[i] = 'A' + random(26);
			    }
			    code[len] = EOS;

			    new type_code = 2;
			    new count_activation = random(5) + 1;

			    new prize_type[9], prize_id[9], prize_count[9];
			    new total = random(2) + 3; 

			    new codecars[] = {
			        15206,15207,15208,15209,15210,15211,15212,15213,15214,
			        15637,15638,15639,15640,15641,15642,15643,15644,15645,15646,15647,
			        15648,15649,15650,15651,15652,15653,15654,15655,15656,15657,15658,
			        15659,15660,15661,15662,15663,15664,15665,15666,15667,15668,15669,
			        15670,15671,15672,15673,15674,15675,15676,15677,15678,15679,15680,
			        15681,15682,15683,15684,15685,15686,15687,15688,15689,15690,15691,
			        15692,15693,15694,15695,15696,15697,15698,15699,
			        17400,17401,17402,17403,17404,17405,17406,17407,17408,17409,
			        17410,17411,17412,17413,17414,17415,17416,17417,17418,17419
			    };

			    new codeacs[] = {
			        10983,10985,10986,10987,10989,10996,10997,10998,11000,
			        11002,13968,14003,14004,14006,14195,14202,14706,14707,15744,15746,
			        14796,15791,15794,15850,15890,16222,16226,16473,16600,16682,16774,
			        16938,16941,16976,16948,17142,17147,17151,17246,17250,17286,17381,
			        17389,17988,17998,18001,18417,18520,18908,18971
			    };

			    new codeitem[] = {
			        258,259,261,272,278,284,290,300,328,
			        344,348,350,355,356,360,257,293,188,189,155
			    };

			    for(new i = 0; i < total; i++)
			    {
			        new rtype = random(13) + 1;
			        prize_type[i] = rtype;

			        switch(rtype)
			        {
			            case 1: prize_count[i] = random(35000000) + 30000;
			            case 2: prize_count[i] = random(30) + 100;
			            case 3: prize_count[i] = random(20) + 5;
			            case 4: { prize_id[i] = codeitem[random(sizeof(codeitem))]; prize_count[i] = random(20) + 10; }
			            case 5: { prize_id[i] = codecars[random(sizeof(codecars))]; prize_count[i] = 1; }
			            case 6,7,8,9,10: prize_count[i] = random(3) + 1;
			            case 11:
			            {
			                new skin_id;
			                switch (random(3))
			                {
			                    case 0: skin_id = 1 + random(299);
			                    case 1: skin_id = 15300 + random(299);
			                    case 2: skin_id = 17000 + random(82);
			                }
			                prize_id[i] = skin_id;
			                prize_count[i] = 1;
			            }
			            case 12: { prize_id[i] = codeacs[random(sizeof(codeacs))]; prize_count[i] = 1; }
			            case 13: { prize_id[i] = 1; prize_count[i] = random(60) + 10; }
			        }
			    }

			    for(new i = total; i < 9; i++) prize_type[i] = prize_id[i] = prize_count[i] = 0;

			    static query[2048];
			    format(query, sizeof(query), "INSERT INTO prizes_code (name, count_time, count_activation, type_code,\
			    type_prize_1, id_prize_1, count_prize_1,\
			    type_prize_2, id_prize_2, count_prize_2,\
			    type_prize_3, id_prize_3, count_prize_3,\
			    type_prize_4, id_prize_4, count_prize_4)\
			    VALUES('%s', 0, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d)",
			    code, count_activation, type_code,
			    prize_type[0], prize_id[0], prize_count[0],
			    prize_type[1], prize_id[1], prize_count[1],
			    prize_type[2], prize_id[2], prize_count[2],
			    prize_type[3], prize_id[3], prize_count[3]);

			    mysql_query(mysql, query);

			    static dialogStr[512], line[64];
			    format(dialogStr, sizeof(dialogStr), "{FFFFFF}Бонус-код успешно создан! - {"SERVER_COLOR"}%s\n{FFFFFF}Количество активаций - {"SERVER_COLOR"}%d\n{FFFFFF}В него входит:{"SERVER_COLOR"}", code, count_activation);

			    for(new i = 0; i < total; i++)
			    {
			        switch(prize_type[i])
			        {
			            case 1: format(line, sizeof(line), "\nПриз: Деньги: %d руб", prize_count[i]);
			            case 2: format(line, sizeof(line), "\nПриз: Донат: %d руб", prize_count[i]);
			            case 3: format(line, sizeof(line), "\nПриз: EXP: %d", prize_count[i]);
			            case 4: format(line, sizeof(line), "\nПриз: Предмет (ID: %d) %d ед.", prize_id[i], prize_count[i]);
			            case 5: format(line, sizeof(line), "\nПриз: Транспорт (ID: %d)", prize_id[i]);
			            case 6: format(line, sizeof(line), "\nПриз: Слот на бизнес: %d шт", prize_count[i]);
			            case 7: format(line, sizeof(line), "\nПриз: Слот на дом: %d шт", prize_count[i]);
			            case 8: format(line, sizeof(line), "\nПриз: Слот на гараж: %d шт", prize_count[i]);
			            case 9: format(line, sizeof(line), "\nПриз: Слот на авто: %d шт", prize_count[i]);
			            case 10: format(line, sizeof(line), "\nПриз: Слот на киоск: %d шт", prize_count[i]);
			            case 11: format(line, sizeof(line), "\nПриз: Одежда (ID: %d)", prize_id[i]);
			            case 12: format(line, sizeof(line), "\nПриз: Аксессуар (ID: %d)", prize_id[i]);
			            case 13: format(line, sizeof(line), "\nПриз: Купон на деморган: %d мин", prize_count[i]);
			            default: format(line, sizeof(line), "\nПриз: Неизвестный");
			        }
			        strcat(dialogStr, line);
			    }

			    Dialog(playerid, DIALOG_RANDOM_CODE, DIALOG_STYLE_MSGBOX, "Бонус-код", dialogStr, "Ок", "");

			    SCMF(playerid, COLOR_GREEN, "* Вы успешно купили маленький бонус-код на %d активаций(-ю):{FFFFFF} %s.", count_activation, code);
			    SCM(playerid, COLOR_GREEN, "* Обязательно сохраните его нажав на клавишу: {FFFF00}F8");

			    static msg[128];
			    format(msg, sizeof msg, "A: Игрок %s[%d] купил маленький случайный бонус-код (%d приза).", GetPlayerNameEx(playerid), playerid, total);
			    SendMessageToAdmins(msg, 0x999999FF);
				GivePlayerCoins(playerid, -659);
			}
			case DIALOG_BUY_BCODE2:
			{
			    if(!response) return 1;

			    new code[17];
			    new len = random(7) + 6; 
			    for(new i = 0; i < len; i++) {
			        code[i] = 'A' + random(26);
			    }
			    code[len] = EOS;

			    new type_code = 2;
			    new count_activation = random(5) + 1;

			    new prize_type[9], prize_id[9], prize_count[9];
			    new total = random(2) + 4; // 4-5 призов

			    new codecars[] = {
			        15206,15207,15208,15209,15210,15211,15212,15213,15214,
			        15637,15638,15639,15640,15641,15642,15643,15644,15645,15646,15647,
			        15648,15649,15650,15651,15652,15653,15654,15655,15656,15657,15658,
			        15659,15660,15661,15662,15663,15664,15665,15666,15667,15668,15669,
			        15670,15671,15672,15673,15674,15675,15676,15677,15678,15679,15680,
			        15681,15682,15683,15684,15685,15686,15687,15688,15689,15690,15691,
			        15692,15693,15694,15695,15696,15697,15698,15699,
			        17400,17401,17402,17403,17404,17405,17406,17407,17408,17409,
			        17410,17411,17412,17413,17414,17415,17416,17417,17418,17419
			    };

			    new codeacs[] = {
			        10983,10985,10986,10987,10989,10996,10997,10998,11000,
			        11002,13968,14003,14004,14006,14195,14202,14706,14707,15744,15746,
			        14796,15791,15794,15850,15890,16222,16226,16473,16600,16682,16774,
			        16938,16941,16976,16948,17142,17147,17151,17246,17250,17286,17381,
			        17389,17988,17998,18001,18417,18520,18908,18971
			    };

			    new codeitem[] = {
			        258,259,261,272,278,284,290,300,328,
			        344,348,350,355,356,360,257,293,188,189,155
			    };

			    for(new i = 0; i < total; i++)
			    {
			        new rtype = random(13) + 1;
			        prize_type[i] = rtype;

			        switch(rtype)
			        {
			            case 1: prize_count[i] = random(35000000) + 30000;
			            case 2: prize_count[i] = random(30) + 100;
			            case 3: prize_count[i] = random(20) + 5;
			            case 4: { prize_id[i] = codeitem[random(sizeof(codeitem))]; prize_count[i] = random(20) + 10; }
			            case 5: { prize_id[i] = codecars[random(sizeof(codecars))]; prize_count[i] = 1; }
			            case 6,7,8,9,10: prize_count[i] = random(3) + 1;
			            case 11:
			            {
			                new skin_id;
			                switch (random(3))
			                {
			                    case 0: skin_id = 1 + random(299);
			                    case 1: skin_id = 15300 + random(299);
			                    case 2: skin_id = 17000 + random(82);
			                }
			                prize_id[i] = skin_id;
			                prize_count[i] = 1;
			            }
			            case 12: { prize_id[i] = codeacs[random(sizeof(codeacs))]; prize_count[i] = 1; }
			            case 13: { prize_id[i] = 1; prize_count[i] = random(60) + 10; }
			        }
			    }

			    for(new i = total; i < 9; i++) prize_type[i] = prize_id[i] = prize_count[i] = 0;

			    static query[2048];
			    format(query, sizeof(query), "INSERT INTO prizes_code (name, count_time, count_activation, type_code,\
			    type_prize_1, id_prize_1, count_prize_1,\
			    type_prize_2, id_prize_2, count_prize_2,\
			    type_prize_3, id_prize_3, count_prize_3,\
			    type_prize_4, id_prize_4, count_prize_4,\
			    type_prize_5, id_prize_5, count_prize_5)\
			    VALUES('%s', 0, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d)",
			    code, count_activation, type_code,
			    prize_type[0], prize_id[0], prize_count[0],
			    prize_type[1], prize_id[1], prize_count[1],
			    prize_type[2], prize_id[2], prize_count[2],
			    prize_type[3], prize_id[3], prize_count[3],
			    prize_type[4], prize_id[4], prize_count[4]);

			    mysql_query(mysql, query);

			    static dialogStr[512], line[64];
			    format(dialogStr, sizeof(dialogStr), "{FFFFFF}Бонус-код успешно создан! - {"SERVER_COLOR"}%s\n{FFFFFF}Количество активаций - {"SERVER_COLOR"}%d\n{FFFFFF}В него входит:{"SERVER_COLOR"}", code, count_activation);

			    for(new i = 0; i < total; i++)
			    {
			        switch(prize_type[i])
			        {
			            case 1: format(line, sizeof(line), "\nПриз: Деньги: %d руб", prize_count[i]);
			            case 2: format(line, sizeof(line), "\nПриз: Донат: %d руб", prize_count[i]);
			            case 3: format(line, sizeof(line), "\nПриз: EXP: %d", prize_count[i]);
			            case 4: format(line, sizeof(line), "\nПриз: Предмет (ID: %d) %d ед.", prize_id[i], prize_count[i]);
			            case 5: format(line, sizeof(line), "\nПриз: Транспорт (ID: %d)", prize_id[i]);
			            case 6: format(line, sizeof(line), "\nПриз: Слот на бизнес: %d шт", prize_count[i]);
			            case 7: format(line, sizeof(line), "\nПриз: Слот на дом: %d шт", prize_count[i]);
			            case 8: format(line, sizeof(line), "\nПриз: Слот на гараж: %d шт", prize_count[i]);
			            case 9: format(line, sizeof(line), "\nПриз: Слот на авто: %d шт", prize_count[i]);
			            case 10: format(line, sizeof(line), "\nПриз: Слот на киоск: %d шт", prize_count[i]);
			            case 11: format(line, sizeof(line), "\nПриз: Одежда (ID: %d)", prize_id[i]);
			            case 12: format(line, sizeof(line), "\nПриз: Аксессуар (ID: %d)", prize_id[i]);
			            case 13: format(line, sizeof(line), "\nПриз: Купон на деморган: %d мин", prize_count[i]);
			            default: format(line, sizeof(line), "\nПриз: Неизвестный");
			        }
			        strcat(dialogStr, line);
			    }

			    Dialog(playerid, DIALOG_RANDOM_CODE, DIALOG_STYLE_MSGBOX, "Бонус-код", dialogStr, "Ок", "");

			    SCMF(playerid, COLOR_GREEN, "* Вы успешно купили средний бонус-код на %d активаций(-ю):{FFFFFF} %s.", count_activation, code);
			    SCM(playerid, COLOR_GREEN, "* Обязательно сохраните его нажав на клавишу: {FFFF00}F8");

			    static msg[128];
			    format(msg, sizeof msg, "A: Игрок %s[%d] купил средний случайный бонус-код (%d приза).", GetPlayerNameEx(playerid), playerid, total);
			    SendMessageToAdmins(msg, 0x999999FF);
				GivePlayerCoins(playerid, -942);
			}
			case DIALOG_BUY_BCODE3:
			{
			    if(!response) return 1;

			    new code[17];
			    new len = random(7) + 6; 
			    for(new i = 0; i < len; i++) {
			        code[i] = 'A' + random(26);
			    }
			    code[len] = EOS;

			    new type_code = 2;
			    new count_activation = random(5) + 1;

			    new prize_type[9], prize_id[9], prize_count[9];
			    new total = random(2) + 5; // 5-6 призов

			    new codecars[] = {
			        15206,15207,15208,15209,15210,15211,15212,15213,15214,
			        15637,15638,15639,15640,15641,15642,15643,15644,15645,15646,15647,
			        15648,15649,15650,15651,15652,15653,15654,15655,15656,15657,15658,
			        15659,15660,15661,15662,15663,15664,15665,15666,15667,15668,15669,
			        15670,15671,15672,15673,15674,15675,15676,15677,15678,15679,15680,
			        15681,15682,15683,15684,15685,15686,15687,15688,15689,15690,15691,
			        15692,15693,15694,15695,15696,15697,15698,15699,
			        17400,17401,17402,17403,17404,17405,17406,17407,17408,17409,
			        17410,17411,17412,17413,17414,17415,17416,17417,17418,17419
			    };

			    new codeacs[] = {
			        10983,10985,10986,10987,10989,10996,10997,10998,11000,
			        11002,13968,14003,14004,14006,14195,14202,14706,14707,15744,15746,
			        14796,15791,15794,15850,15890,16222,16226,16473,16600,16682,16774,
			        16938,16941,16976,16948,17142,17147,17151,17246,17250,17286,17381,
			        17389,17988,17998,18001,18417,18520,18908,18971
			    };

			    new codeitem[] = {
			        258,259,261,272,278,284,290,300,328,
			        344,348,350,355,356,360,257,293,188,189,155
			    };

			    for(new i = 0; i < total; i++)
			    {
			        new rtype = random(13) + 1;
			        prize_type[i] = rtype;

			        switch(rtype)
			        {
			            case 1: prize_count[i] = random(35000000) + 30000;
			            case 2: prize_count[i] = random(30) + 100;
			            case 3: prize_count[i] = random(20) + 5;
			            case 4: { prize_id[i] = codeitem[random(sizeof(codeitem))]; prize_count[i] = random(20) + 10; }
			            case 5: { prize_id[i] = codecars[random(sizeof(codecars))]; prize_count[i] = 1; }
			            case 6,7,8,9,10: prize_count[i] = random(3) + 1;
			            case 11:
			            {
			                new skin_id;
			                switch (random(3))
			                {
			                    case 0: skin_id = 1 + random(299);
			                    case 1: skin_id = 15300 + random(299);
			                    case 2: skin_id = 17000 + random(82);
			                }
			                prize_id[i] = skin_id;
			                prize_count[i] = 1;
			            }
			            case 12: { prize_id[i] = codeacs[random(sizeof(codeacs))]; prize_count[i] = 1; }
			            case 13: { prize_id[i] = 1; prize_count[i] = random(60) + 10; }
			        }
			    }

			    for(new i = total; i < 9; i++) prize_type[i] = prize_id[i] = prize_count[i] = 0;

			    static query[2048];
			    format(query, sizeof(query), "INSERT INTO prizes_code (name, count_time, count_activation, type_code,\
			    type_prize_1, id_prize_1, count_prize_1,\
			    type_prize_2, id_prize_2, count_prize_2,\
			    type_prize_3, id_prize_3, count_prize_3,\
			    type_prize_4, id_prize_4, count_prize_4,\
			    type_prize_5, id_prize_5, count_prize_5,\
			    type_prize_6, id_prize_6, count_prize_6)\
			    VALUES('%s', 0, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d,\
			    %d, %d, %d)",
			    code, count_activation, type_code,
			    prize_type[0], prize_id[0], prize_count[0],
			    prize_type[1], prize_id[1], prize_count[1],
			    prize_type[2], prize_id[2], prize_count[2],
			    prize_type[3], prize_id[3], prize_count[3],
			    prize_type[4], prize_id[4], prize_count[4],
			    prize_type[5], prize_id[5], prize_count[5]);

			    mysql_query(mysql, query);

			    static dialogStr[512], line[64];
			    format(dialogStr, sizeof(dialogStr), "{FFFFFF}Бонус-код успешно создан! - {"SERVER_COLOR"}%s\n{FFFFFF}Количество активаций - {"SERVER_COLOR"}%d\n{FFFFFF}В него входит:{"SERVER_COLOR"}", code, count_activation);

			    for(new i = 0; i < total; i++)
			    {
			        switch(prize_type[i])
			        {
			            case 1: format(line, sizeof(line), "\nПриз: Деньги: %d руб", prize_count[i]);
			            case 2: format(line, sizeof(line), "\nПриз: Донат: %d руб", prize_count[i]);
			            case 3: format(line, sizeof(line), "\nПриз: EXP: %d", prize_count[i]);
			            case 4: format(line, sizeof(line), "\nПриз: Предмет (ID: %d) %d ед.", prize_id[i], prize_count[i]);
			            case 5: format(line, sizeof(line), "\nПриз: Транспорт (ID: %d)", prize_id[i]);
			            case 6: format(line, sizeof(line), "\nПриз: Слот на бизнес: %d шт", prize_count[i]);
			            case 7: format(line, sizeof(line), "\nПриз: Слот на дом: %d шт", prize_count[i]);
			            case 8: format(line, sizeof(line), "\nПриз: Слот на гараж: %d шт", prize_count[i]);
			            case 9: format(line, sizeof(line), "\nПриз: Слот на авто: %d шт", prize_count[i]);
			            case 10: format(line, sizeof(line), "\nПриз: Слот на киоск: %d шт", prize_count[i]);
			            case 11: format(line, sizeof(line), "\nПриз: Одежда (ID: %d)", prize_id[i]);
			            case 12: format(line, sizeof(line), "\nПриз: Аксессуар (ID: %d)", prize_id[i]);
			            case 13: format(line, sizeof(line), "\nПриз: Купон на деморган: %d мин", prize_count[i]);
			            default: format(line, sizeof(line), "\nПриз: Неизвестный");
			        }
			        strcat(dialogStr, line);
			    }

			    Dialog(playerid, DIALOG_RANDOM_CODE, DIALOG_STYLE_MSGBOX, "Бонус-код", dialogStr, "Ок", "");

			    SCMF(playerid, COLOR_GREEN, "* Вы успешно купили большой бонус-код на %d активаций(-ю):{FFFFFF} %s.", count_activation, code);
			    SCM(playerid, COLOR_GREEN, "* Обязательно сохраните его нажав на клавишу: {FFFF00}F8");

			    static msg[128];
			    format(msg, sizeof msg, "A: Игрок %s[%d] купил большой случайный бонус-код (%d призов).", GetPlayerNameEx(playerid), playerid, total);
			    SendMessageToAdmins(msg, 0x999999FF);
				GivePlayerCoins(playerid, -1499);
			}
		case DIALOG_DONATE_BUY_NUMBER:
		{
			if(response)
			{
				if(strlen(inputtext) == 4 && (1000 <= strval(inputtext) <= 9999))
				{
					new number = strval(inputtext),
						query[102],
						rows,
						Cache: result;

					mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE phone=%d", number);
					result = mysql_query(mysql, query, true);

					rows = cache_num_rows();

					cache_delete(result);

					if(rows)
						SendClientMessage(playerid, 0x999999FF, "* Введенный Вами номер уже занят");

					else
					{
						SetPlayerData(playerid, P_PHONE, number);
						UpdatePlayerDatabaseInt(playerid, "phone", number);

						GivePlayerCoins(playerid, -399);

						format
						(
							query, sizeof query,
							"{FFFFFF}Номер телефона изменен\n"\
							"Теперь с Вами  можно связаться по номеру {FFD83D}%d",
							GetPlayerPhone(playerid)
						);
						return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}Номер изменен", query, "Закрыть", "");
					}
				}
				else SendClientMessage(playerid, 0x999999FF, "* Недопустимый формат ввода");
			}
			ShowPlayerDonateMenu(playerid);
		}
		case DIALOG_DONATE_INFO: if(response) ShowPlayerDonateMenu(playerid);
		case DIALOG_CREATE_DONATE_FINISH:
		{
			if(!response) return callcmd::createcoinsitem(playerid);
			
			SCM(playerid, COLOR_GREY, "* Вы успешно создали предмет в "SERVER_COINS_NAME" меню");

			static query[248];
			format(query, sizeof query, "INSERT INTO donate_items (type, name, item_id, price, count, indx) VALUES (%d, '%s', %d, %d, %d, %d)", 
			g_donate_create[playerid][DC_TYPE], g_donate_create[playerid][DC_NAME], g_donate_create[playerid][DC_ITEM_ID], g_donate_create[playerid][DC_PRICE], g_donate_create[playerid][DC_COUNT], g_donate_create[playerid][DC_INDX]);
			mysql_tquery(mysql, query, "", "");

			format(query, sizeof query, "A: %s[%d] создал предмет в "SERVER_COINS_NAME" меню (type: %d | name: %s | price: %d | count: %d)", GetPlayerNameEx(playerid), playerid, g_donate_create[playerid][DC_TYPE], g_donate_create[playerid][DC_NAME], g_donate_create[playerid][DC_PRICE], g_donate_create[playerid][DC_COUNT]);
			SendMessageToAdmins(query, 0xFFFF00FF);

			format(query, sizeof query, "[Информация] Администратор %s[%d] создал новый предмет в "SERVER_COINS_NAME" меню, узнать можно в /"SERVER_COINS_NAME"", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(0xFFA500FF, query);
		}
		case DIALOG_CREATE_DONATE_1:
		{
			if(!response) return 1;

			switch(listitem)
			{
				case 0: callcmd::createcoinsitem(playerid);
				case 1: // транспорт id 1
				{
					g_donate_create[playerid][DC_TYPE] = 1;
					Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Транспорт", "{FFFFFF}Введите id транспорта который хотите добавить", "Далее", "Назад");
				}
				case 2: // одежда id 2
				{
					g_donate_create[playerid][DC_TYPE] = 2;
					Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Одежда", "{FFFFFF}Введите id одежды который хотите добавить", "Далее", "Назад");
				}
				case 3: // аксессуар id 3
				{
					g_donate_create[playerid][DC_TYPE] = 3;
					Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Аксессуар", "{FFFFFF}Введите id аксессуара который хотите добавить", "Далее", "Назад");
				}
				case 4: // аксессуар id 5
				{
					g_donate_create[playerid][DC_TYPE] = 5;
					Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите id предмета который хотите добавить", "Далее", "Назад");
				}
			}
		}

		case DIALOG_CREATE_DONATE_2:
		{
			if(!response) return callcmd::createcoinsitem(playerid);

			if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) 
			{	
				if(g_donate_create[playerid][DC_TYPE] == 1) Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Транспорт", "{FFFFFF}Введите id транспорта который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 2) Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Одежда", "{FFFFFF}Введите id одежды который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 3) Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Аксессуар", "{FFFFFF}Введите id аксессуара который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 5) Dialog(playerid, DIALOG_CREATE_DONATE_2, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите id предмета который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				return 1;
			}

			if(g_donate_create[playerid][DC_TYPE] == 1)
			{
				Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Транспорт", "{FFFFFF}Введите название транспорта который хотите добавить", "Далее", "Назад");
			}
			if(g_donate_create[playerid][DC_TYPE] == 2)
			{
				Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Одежда", "{FFFFFF}Введите название одежды который хотите добавить", "Далее", "Назад");
			}
			if(g_donate_create[playerid][DC_TYPE] == 3)
			{
				Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Аксессуар", "{FFFFFF}Введите название аксессуар который хотите добавить", "Далее", "Назад");
			}
			if(g_donate_create[playerid][DC_TYPE] == 5)
			{
				Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите название предмета который хотите добавить", "Далее", "Назад");
			}
			g_donate_create[playerid][DC_ITEM_ID] = strval(inputtext);
		}

		case DIALOG_CREATE_DONATE_5:
		{
			if(!response) return callcmd::createcoinsitem(playerid);

			if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) 
			{	
				if(g_donate_create[playerid][DC_TYPE] == 1) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Транспорт", "{FFFFFF}Введите стоимость транспорта который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 2) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Одежда", "{FFFFFF}Введите стоимость одежды который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 3) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Аксессуар", "{FFFFFF}Введите стоимость аксессуара который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 5) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите стоимость предмета который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				return 1;
			}

			g_donate_create[playerid][DC_PRICE] = strval(inputtext);

			if(g_donate_create[playerid][DC_TYPE] == 1)
			{
				CreateDonateItems(playerid);
			}
			if(g_donate_create[playerid][DC_TYPE] == 2)
			{
				CreateDonateItems(playerid);
			}
			if(g_donate_create[playerid][DC_TYPE] == 3)
			{
				Dialog
				(
					playerid, DIALOG_CREATE_DONATE_4, DIALOG_STYLE_INPUT, 
					"{FFCD00}Аксессуар", 
					"{FFFFFF}Введите тип аксессуара который хотите добавить\n\n\
					Список типов аксессуаров:\n\
					Тип 0 - Очки\n\
					Тип 1 - Бандана\n\
					Тип 2 - Маска\n\
					Тип 3 - Берет\n\
					Тип 4 - шляпа (Шапка, Кепка)\n\
					Тип 5 - Сумка\n\
					Тип 6 - Ремень\n\
					Тип 7 - Украшение на руку\n\
					Тип 8 - Рюкзак\n\
					Тип 9 - Украшение на шею\n\
					Тип 10 - Плащ\n\
					Тип 11 - Бронижелет\n\
					Тип 12 - Посох\n\
					Тип 13 - Крылья\n\
					Тип 14 - Украшение на транспорт\n\
					Тип 15 - Украшение на транспорт\n\
					Тип 16 - Украшение на транспорт\n\
					Тип 17 - Украшение на транспорт\n\
					Тип 18 - Скейтборд\n\
					Тип 19 - украшение на левое плечо\n\
					Тип 20 - Украшение на транспорт\n\
					Тип 21 - Украшение на транспорт\n\
					Тип 22 - Аксессуар на спину", 
					"Далее", "Назад"
				);
			}
			if(g_donate_create[playerid][DC_TYPE] == 5)
			{
				Dialog(playerid, DIALOG_CREATE_DONATE_4, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите количество предмета который хотите добавить", "Далее", "Назад");
			}
		}

		case DIALOG_CREATE_DONATE_3:
		{
			if(!response) return callcmd::createcoinsitem(playerid);

			if(strlen(inputtext) > 48 || 5 > strlen(inputtext))
			{	
				if(g_donate_create[playerid][DC_TYPE] == 1) Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Транспорт", "{FFFFFF}Введите название транспорта который хотите добавить\n\n{FF6600}Укажите не меньше 5-ти и не больше 48-ми символов", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 2) Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Одежда", "{FFFFFF}Введите название одежды который хотите добавить\n\n{FF6600}Укажите не меньше 5-ти и не больше 48-ми символов", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 3) Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Аксессуар", "{FFFFFF}Введите название аксессуара который хотите добавить\n\n{FF6600}Укажите не меньше 5-ти и не больше 48-ми символов", "Далее", "Назад");
				if(g_donate_create[playerid][DC_TYPE] == 5) Dialog(playerid, DIALOG_CREATE_DONATE_3, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите название предмета который хотите добавить\n\n{FF6600}Укажите не меньше 5-ти и не больше 48-ми символов", "Далее", "Назад");
				return 1;
			}

			format(g_donate_create[playerid][DC_NAME], 48, "%s", inputtext);

			if(g_donate_create[playerid][DC_TYPE] == 1) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Транспорт", "{FFFFFF}Введите стоимость транспорта который хотите добавить", "Далее", "Назад");
			if(g_donate_create[playerid][DC_TYPE] == 2) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Одежда", "{FFFFFF}Введите стоимость одежды который хотите добавить", "Далее", "Назад");
			if(g_donate_create[playerid][DC_TYPE] == 3) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Аксессуар", "{FFFFFF}Введите стоимость аксессуара который хотите добавить", "Далее", "Назад");
			if(g_donate_create[playerid][DC_TYPE] == 5) Dialog(playerid, DIALOG_CREATE_DONATE_5, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите стоимость предмета который хотите добавить", "Далее", "Назад");

		}

		case DIALOG_CREATE_DONATE_4:
		{
			if(!response) return callcmd::createcoinsitem(playerid);

			if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) 
			{
				if(g_donate_create[playerid][DC_TYPE] == 3) 
					Dialog
					(
						playerid, DIALOG_CREATE_DONATE_4, DIALOG_STYLE_INPUT, 
						"{FFCD00}Аксессуар", 
						"{FFFFFF}Введите тип аксессуара который хотите добавить\n\n\
						Список типов аксессуара:\n\
						Тип 0 - Очки\n\
						Тип 1 - Бандана\n\
						Тип 2 - Маска\n\
						Тип 3 - Берет\n\
						Тип 4 - шляпа (Шапка, Кепка)\n\
						Тип 5 - Сумка\n\
						Тип 6 - Ремень\n\
						Тип 7 - Украшение на руку\n\
						Тип 8 - Рюкзак\n\
						Тип 9 - Украшение на шею\n\
						Тип 10 - Плащ\n\
						Тип 11 - Бронижелет\n\
						Тип 12 - Посох\n\
						Тип 13 - Крылья\n\
						Тип 14 - Украшение на транспорт\n\
						Тип 15 - Украшение на транспорт\n\
						Тип 16 - Украшение на транспорт\n\
						Тип 17 - Украшение на транспорт\n\
						Тип 18 - Скейтборд\n\
						Тип 19 - украшение на левое плечо\n\
						Тип 20 - Украшение на транспорт\n\
						Тип 21 - Украшение на транспорт\n\
						Тип 22 - Аксессуар на спину\n\n\
						{FF6600}Укажите корректное значение", 
						"Далее", "Назад"
					);

				if(g_donate_create[playerid][DC_TYPE] == 5) Dialog(playerid, DIALOG_CREATE_DONATE_4, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите количество предмета который хотите добавить\n\n{FF6600}Укажите корректное значение", "Далее", "Назад");
				return 1;	
			}

			if(g_donate_create[playerid][DC_TYPE] == 3)
			{
				if(strval(inputtext) > 22)
				{
					Dialog
					(
						playerid, DIALOG_CREATE_DONATE_4, DIALOG_STYLE_INPUT, 
						"{FFCD00}Аксессуар", 
						"{FFFFFF}Введите тип аксессуара который хотите добавить\n\n\
						Список типов аксессуаров:\n\
						Тип 0 - Очки\n\
						Тип 1 - Бандана\n\
						Тип 2 - Маска\n\
						Тип 3 - Берет\n\
						Тип 4 - шляпа (Шапка, Кепка)\n\
						Тип 5 - Сумка\n\
						Тип 6 - Ремень\n\
						Тип 7 - Украшение на руку\n\
						Тип 8 - Рюкзак\n\
						Тип 9 - Украшение на шею\n\
						Тип 10 - Плащ\n\
						Тип 11 - Бронижелет\n\
						Тип 12 - Посох\n\
						Тип 13 - Крылья\n\
						Тип 14 - Украшение на транспорт\n\
						Тип 15 - Украшение на транспорт\n\
						Тип 16 - Украшение на транспорт\n\
						Тип 17 - Украшение на транспорт\n\
						Тип 18 - Скейтборд\n\
						Тип 19 - украшение на левое плечо\n\
						Тип 20 - Украшение на транспорт\n\
						Тип 21 - Украшение на транспорт\n\
						Тип 22 - Аксессуар на спину\n\n\
						{FF6600}Данного типа не существует", 
						"Далее", "Назад"
					);
					return 1;
				}

				g_donate_create[playerid][DC_INDX] = strval(inputtext);
				CreateDonateItems(playerid);
			}
			if(g_donate_create[playerid][DC_TYPE] == 5)
			{
				if(strval(inputtext) > 2000000000)
				{
					Dialog(playerid, DIALOG_CREATE_DONATE_4, DIALOG_STYLE_INPUT, "{FFCD00}Предмет", "{FFFFFF}Введите количество предмета который хотите добавить\n\n{FF6600}Нельзя указать количество больше 1.999.999.999 шт.", "Далее", "Назад");
					return 1;
				}
				g_donate_create[playerid][DC_COUNT] = strval(inputtext);
				CreateDonateItems(playerid);
			}

		}
		case DIALOG_CAR_LIST_NOTARY:
		{
			if(!response) return 1;

			if((GetPlayerOwnableCars(g_player_notary_offer_id[playerid]) + 1) > GetPlayerCarSlots(g_player_notary_offer_id[playerid]))
				return SendClientMessage(playerid, 0xeb622aFF, "У одной из сторон достигнут лимит ТС");

			new idx = GetPlayerListitemValue(playerid, listitem);

			new vehicleid = INVALID_VEHICLE_ID;

			for(new i = 0; i < MAX_VEHICLES; i++)
			{
				if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				{
					new iddx = GetVehicleData(i, V_ACTION_ID);
					if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
					{
						vehicleid = i;
					}
				}
			}

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0xFF6600FF, "* Данный транспорт не загружен на сервер");

			g_player_notary_item_id[playerid] = vehicleid;

			new model_id = GetVehicleData(vehicleid, V_MODELID);

			static fmt_text[248];
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player1\": {\"item\": 2,\"itemName\": \"Транспорт %s \",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')",GetVehicleInfo(model_id, VI_NAME), GetVehicleInfo(model_id, VI_PRICE));
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);

			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player2\": {\"item\": 2,\"itemName\": \"Транспорт %s \",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')",GetVehicleInfo(model_id, VI_NAME), GetVehicleInfo(model_id, VI_PRICE));
			MoralPacket_1(g_player_notary_offer_id[playerid], s_CefInterface, t_CefUpdate, fmt_text);

		}
		case DIALOG_BIZ_LIST_NOTARY:
		{
			if(!response) return 1;

			if((GetPlayerOwnableBiz(g_player_notary_offer_id[playerid]) + 1) > GetPlayerBizSlots(g_player_notary_offer_id[playerid])) 
				return SCM(playerid, 0xeb622aFF, "У одной из сторон достигнут лимит бизнесов");

			new idx = GetPlayerListitemValue(playerid, listitem) + 1;

			g_player_notary_item_id[playerid] = idx;

			static fmt_text[248];
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player1\": {\"item\": 1,\"itemName\": \"Бизнес %s №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')",GetBusinessData(idx, B_NAME), idx, GetBusinessData(idx, B_PRICE));
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);
			
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player2\": {\"item\": 1,\"itemName\": \"Бизнес %s №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')",GetBusinessData(idx, B_NAME), idx, GetBusinessData(idx, B_PRICE));
			MoralPacket_1(g_player_notary_offer_id[playerid], s_CefInterface, t_CefUpdate, fmt_text);
		}
		case DIALOG_GARAGE_LIST_NOTARY:
		{
			if(!response) return 1;

			if(GetPlayerOwnableGarage(g_player_notary_offer_id[playerid]) + 1 > GetPlayerGarageSlots(g_player_notary_offer_id[playerid])) 
				return SCM(playerid, 0xeb622aFF, "У одной из сторон достигнут лимит гаражей");

			new idx = GetPlayerListitemValue(playerid, listitem) + 1;

			g_player_notary_item_id[playerid] = idx;

			static fmt_text[248];
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player1\": {\"item\": 0,\"itemName\": \"Гараж №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')", idx, GetGarageData(idx, G_PRICE));
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);
			
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player2\": {\"item\": 0,\"itemName\": \"Гараж №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')", idx, GetGarageData(idx, G_PRICE));
			MoralPacket_1(g_player_notary_offer_id[playerid], s_CefInterface, t_CefUpdate, fmt_text);

		}
		case DIALOG_KIOSK_LIST_NOTARY:
		{
			if(!response) return 1;

			if((GetPlayerOwnableKiosk(g_player_notary_offer_id[playerid]) + 1) > GetPlayerKioskSlots(g_player_notary_offer_id[playerid])) 
				return SCM(playerid, 0xeb622aFF, "У одной из сторон достигнут лимит киосков");

			new idx = GetPlayerListitemValue(playerid, listitem) + 1;

			g_player_notary_item_id[playerid] = idx;

			static fmt_text[248];
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player1\": {\"item\": 8,\"itemName\": \"Киоск: %s №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')", GetKioskData(idx, K_NAME), idx, GetKioskData(idx, K_PRICE));
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);
			
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player2\": {\"item\": 8,\"itemName\": \"Киоск: %s №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')", GetKioskData(idx, K_NAME), idx, GetKioskData(idx, K_PRICE));
			MoralPacket_1(g_player_notary_offer_id[playerid], s_CefInterface, t_CefUpdate, fmt_text);
		}
		case DIALOG_GARDEN_LIST_NOTARY:
		{
			if(!response) return 1;

			if(GetPlayerOwnableGarden(g_player_notary_offer_id[playerid]) + 1 > GetPlayerGardenSlots(g_player_notary_offer_id[playerid])) 
				return SCM(playerid, 0xeb622aFF, "У одной из сторон достигнут лимит огородов");

			new idx = GetPlayerListitemValue(playerid, listitem);

			g_player_notary_item_id[playerid] = idx;

			static fmt_text[248];
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player1\": {\"item\": 7,\"itemName\": \"Огород: №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')",idx, GetGardenData(idx, G_PRICE));
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);
			
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player2\": {\"item\": 7,\"itemName\": \"Огород: №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')",idx, GetGardenData(idx, G_PRICE));
			MoralPacket_1(g_player_notary_offer_id[playerid], s_CefInterface, t_CefUpdate, fmt_text);
		}
		case DIALOG_HOME_LIST_NOTARY:
		{
			if(!response) return 1;

			if((GetPlayerOwnableHouse(g_player_notary_offer_id[playerid]) + 1) > GetPlayerHouseSlots(g_player_notary_offer_id[playerid])) 
				return SCM(playerid, 0xeb622aFF, "У одной из сторон достигнут лимит домов");

			new idx = GetPlayerListitemValue(playerid, listitem) + 1;

			g_player_notary_item_id[playerid] = idx;

			static fmt_text[248];
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player1\": {\"item\": 3,\"itemName\": \"Дом №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')", idx, GetHouseData(idx, H_PRICE));
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);
			
			format(fmt_text, sizeof fmt_text, "interface('Trade').updateData('{\"player2\": {\"item\": 3,\"itemName\": \"Дом №%d\",\"itemPrice\": %d,\"itemSurcharge\": 0,\"state\": 0,\"commission\": 0}}')", idx, GetHouseData(idx, H_PRICE));
			MoralPacket_1(g_player_notary_offer_id[playerid], s_CefInterface, t_CefUpdate, fmt_text);
		}
		case DIALOG_BET_SVALKA:
		{
			if(!response) return 1;

			if(g_svalka_playerid_type[playerid] == 1) 
				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты.");

			if(g_svalka_playerid_type[playerid] == 2)
				if(GetInventorySlots(playerid) == -1) return SendClientMessage(playerid, 0x3399FFFF, "* В вашем инвентаре нет свободного места.");

			OnPlayerOpenDumpInterface(playerid, g_svalka_playerid[playerid], g_svalka_playerid_type[playerid]);
		}
		case DIALOG_SLET_1:
			{
				if (!response)
					return false;

				if (GetPlayerAdminEx(playerid) < 8) return 1;

				new hour, minut, type, number;

				sscanf(inputtext, "p<,>dddd", number, type, hour, minut);

				if (type > 5 || type < 0)
					return SCM(playerid, COLOR_OLDRED, !"[Ошибка]{FFFFFF} Тип слетаемого имущества должен быть от 0 до 4 || 0 - бизнес,  1 - дом, 3 - Огород, 4 - Гараж, 5 - Симкарта");

				else if (type == 0 && g_business_loaded < number || type == 1 && g_house_loaded < number || type == 3 && g_garden_loaded < number || type == 4 && g_garage_loaded < number)
					return SCM(playerid, COLOR_OLDRED, !"[Ошибка]{FFFFFF} Ошибка ID слетающего имущества.");

				new id = GetPlayerUseListitem(playerid);

				if (AutoSlet[id][as_Status])
					return false;

				AutoSlet[id][as_Hour] = hour;
				AutoSlet[id][as_Min] = minut;
				SetString(AutoSlet[id][as_Owner], PN(playerid));
				AutoSlet[id][as_Status] = true;
				AutoSlet[id][as_ID] = number;
				AutoSlet[id][as_Type] = type;

				if(type == 1)
				{
					SetHouseData(number, H_LOCK_STATUS, true);
				}

				static query[256];

				if(type == 5)
				{
					format(query, sizeof query, "Администратор %s выставил на автоматический слет сим-карту %d. Посмотреть полную информацию /sletmenu",
					GetPlayerNameEx(playerid), number);
				}
				else
				{
					format(query, sizeof query, "Администратор %s выставил на автоматический слет %s №%d. Посмотреть полную информацию /sletmenu",
					GetPlayerNameEx(playerid), GetSletName(type), number);
				}


				SendClientMessageToAll(0xFFCD00FF, query);

				return SCMF(playerid, COLOR_VALIK, "[Информация]{FFFFFF} %s №%d поставлен на автослет, время слета - %02d:%02d.", GetSletName(type), number, hour, minut);
			}

			case DIALOG_SLET_2:
			{
				if (!response)
					return false;

				if(GetPlayerAdminEx(playerid) < 8) return 1;

				if(AutoSlet[listitem][as_Status])
				{
					static query[256];

					if(AutoSlet[listitem][as_Type] == 5)
					{
						format(query, sizeof query, "Администратор %s снял с автоматического слета сим-карту %d. Посмотреть полную информацию /sletmenu",
						GetPlayerNameEx(playerid), AutoSlet[listitem][as_ID]);
					}
					else
					{
						format(query, sizeof query, "Администратор %s снял с автоматического слета %s №%d. Посмотреть полную информацию /sletmenu",
						GetPlayerNameEx(playerid), GetSletName(AutoSlet[listitem][as_Type]), AutoSlet[listitem][as_ID]);
					}

					AutoSlet[listitem][as_Hour] = 0;
					AutoSlet[listitem][as_Min] = 0;
					SetString(AutoSlet[listitem][as_Owner], "");
					AutoSlet[listitem][as_Status] = false;
					AutoSlet[listitem][as_ID] = 0;
					AutoSlet[listitem][as_Type] = 0;

					SendClientMessageToAll(0xFFCD00FF, query);

					return SCM(playerid, COLOR_VALIK, "[Информация]{FFFFFF} Имущество было снят со слета.");
				}

				SetPlayerUseListitem(playerid, listitem);

				return Dialog(playerid, DIALOG_SLET_1, DIALOG_STYLE_INPUT, "{FFFFFF}Автоматический слет | {ae433d}MORALLWENS", "{FFFFFF}Для того чтобы добавить имущество на слет введите параметры по примеру:\nПример: {ae433d}(ID дома/биза/огорода/гаража) (Тип 0/1/2/3/4) (Время слета)\n\n{FFFFFF}Где (ID дома/биза/огорода/гаража) - ид дома/бизнеса/огорода/гаража, который хотите поставить на слет\n(Тип 0/1/2/3/4) - тип слетаемого, 1 - дом, 0 - бизнес, 3 - огород, 4 - гараж\n(Время слета) - когда хотите чтобы слетело поставленное имущество\n\nПолный пример: {ae433d}205 0 17 40{FFFFFF}, при вводе таких параметров\nслетит дом №205 в 17:40 по МСК.\n\nВведите параметры для слета:", "Выставить", "Выйти");
				}
		case DIALOG_TK_JMENU:
		{
			if(!response) return 1;

			switch(listitem + 1)
			{
				case 1: 
				{
					string_dialog[0] = EOS;
					format
					(
						string_dialog, sizeof string_dialog, 
						"{ffffff}Наименование: {ffd31d}%s{ffffff}\n\
						Владелец: {fbdf6a}%s{ffffff}\n\
						Рейтинг: {fbdf6a}0{ffffff} ед.\n\n\
						- Критерии по рейтингу для вступления: {cefb6a}отсутствуют{ffffff}\n\
						- Критерии по рейтингу для увольнения: {f06868}отсутствуют{ffffff}\n\
						- Зарплата заместителей: {cefb6a}отсутствуют",
						GetBusinessData(GetPlayerData(playerid, P_TK_JOB), B_NAME), 
						GetBusinessData(GetPlayerData(playerid, P_TK_JOB), B_OWNER_NAME)
					);

					Dialog(playerid, DIALOG_TK_JMENU_1, DIALOG_STYLE_MSGBOX, "{FFCD00}Информация о компании", string_dialog,"Назад", "");
				}
				case 2:
				{
					Dialog
					(
						playerid, DIALOG_TK_JMENU_TUTORIAL, DIALOG_STYLE_LIST, 
						"{FFCD00}Руководство по работе", 
						"{fbdf6a}1.{ffffff} Что такое транспортная компания\n\
						{fbdf6a}2.{ffffff} Как работать в транспортной компании\n\
						{fbdf6a}3.{ffffff} Информация о навыке дальнобойщика\n\
						{fbdf6a}4.{ffffff} Понятия \'рейтинг\' и \'номинация\'\n\
						{fbdf6a}5.{ffffff} Возможные штрафы за нарушения\n",
						"Далее", "Назад"
					);
				}
				case 3:
				{
					string_dialog[0] = EOS;

					static fmt_text[135];

					string_dialog = "{ffffff}Имя\t{ffffff}Должность\t{ffffff}Состояние\t{ffffff}Рейтинг";
					foreach(new i: Player)
					{
						if(!IsPlayerConnected(i)) continue;
						else if(!IsPlayerLogged(i)) continue;
						else if(GetPlayerJob(i) != 4) continue;
						else if(GetPlayerData(i, P_TK_JOB) != GetPlayerData(playerid, P_TK_JOB)) continue;
						else if(GetPlayerData(i, P_JOB_CAR) == INVALID_VEHICLE_ID) continue;

						format(fmt_text, sizeof fmt_text, "\n%s\tСотрудник\tСвободен\t{fbdf6a}%d{ffffff} ед.", GetPlayerNameEx(i), GetPlayerData(i, P_JOB_LOAD_ITEMS));

						strcat(string_dialog, fmt_text);
					}

					Dialog(playerid, DIALOG_TK_JMENU_1, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Сотрудники на рабочем месте", string_dialog,"Назад", "");
				}
				case 4:
				{
					SetPlayerData(playerid, P_JOB, 0);
					SCM(playerid, COLOR_RED, "* Вы уволились с работы: \"Дальнобойщик\"");
				}
			}
		}
		case DIALOG_JOB_ITEM:
		{
			if(response)
			{
				if(GetPlayerJobLoadItems(playerid) > 5299) return SCM(playerid, COLOR_GREY, "* Ваш прицеп уже загружен на максимальное количество (5300 ед.)");
				Dialog(playerid, DIALOG_JOB_ITEM_1, DIALOG_STYLE_INPUT, "{FFFFFF}Действие на заводе", "{FFFFFF}Введите количество товара, которое хотите погрузить:", "Далее", "Закрыть");
			}
			else
			{
				if(GetPlayerJobLoadItems(playerid) < 1) return SCM(playerid, COLOR_GREY, "* Вы не можете разгрузить, так как ваш прицеп пуст!");
				Dialog(playerid, DIALOG_JOB_ITEM_2, DIALOG_STYLE_INPUT, "{FFFFFF}Действие на заводе", "{FFFFFF}Введите количество товара, которое хотите разгрузить:", "Далее", "Закрыть");
			}
		}
		case DIALOG_JOB_ITEM_1:
		{
			if(!response) return 1;
			new count = strval(inputtext);

			if(5300 < GetPlayerJobLoadItems(playerid) + count) return SCM(playerid, COLOR_GREY, "* Вы не можете погрузить больше 5300 ед.");
			if(count < 1) return SCM(playerid, COLOR_GREY, "* Некорректное количество.");

			g_player_order_time[playerid][0] = count / 180;
			g_player_order_count[playerid] = count;

			if(g_player_order_time[playerid][0] == 0) g_player_order_time[playerid][0] = 2; 

			TogglePlayerControllable(playerid,false);

			if(GetPlayerJobLoadItems(playerid) + count > 4080) SCM(playerid, 0xd8dd8fFF, "Вы превысили рекомендации по количеству груза, есть шанс того, что в ходе доставки транспорт не справится");
			SCMF(playerid, 0xFFFFFFFF, "Погрузка товара началась, примерное время: {b8d469}%d сек{FFFFFF}, не покидайте свой транспорт", g_player_order_time[playerid][0]);
		}

		case DIALOG_JOB_ITEM_2:
		{
			if(!response) return 1;
			new count = strval(inputtext);

			if(count > GetPlayerJobLoadItems(playerid)) return SCM(playerid, COLOR_GREY, "* Вы не можете разгрузить больше, чем у вас имеется.");
			if(count < 1) return SCM(playerid, COLOR_GREY, "* Некорректное количество.");

			new vehicleid = GetPlayerVehicleID(playerid);
			if(!IsTrailerAttachedToVehicle(vehicleid)) return SCM(playerid, COLOR_GREY, "* Невозможно начать разгрузку, так как у вас отсутствует прицеп с товаром");

			g_player_order_time[playerid][1] = count / 180;
			g_player_order_count[playerid] = count;

			TogglePlayerControllable(playerid,false);

			SCMF(playerid, 0xFFFFFFFF, "Разгрузка товара началась, примерное время: {b8d469}%d сек{FFFFFF}, не покидайте свой транспорт", g_player_order_time[playerid][1]);
		}
		case DIALOG_TK_JMENU_TUTORIAL:
		{
			if(!response) ShowPlayerJMenu(playerid);

			switch(listitem + 1)
			{
				case 1: 
				{
					Dialog
					(
						playerid, DIALOG_TK_JMENU_TUTORIAL_EXIT, DIALOG_STYLE_MSGBOX, 
						"{FFCD00}Руководство по работе: транспортные компании", 
						"{ffffff}Транспортная компания - это организация, которая занимается поставками груза и топлива для бизнес-предприятий.\n\
						Таких компаний всего несколько, но все они между собой соревнуются, дабы занять лидерство на рынке поставок.\n\n\
						У каждой компании есть свой владелец. Он принимает сотрудников на работу, может их увольнять или повышать до заместителя.\n\
						Также владелец способен полностью управлять транспортом компании: покупка, настройка, улучшения и многое другое.\n",
						"Назад", ""
					);
				}
				case 2: 
				{
					Dialog
					(
						playerid, DIALOG_TK_JMENU_TUTORIAL_EXIT, DIALOG_STYLE_MSGBOX, 
						"{FFCD00}Руководство по работе: начало работы", 
						"{ffffff}Для начала стоит знать, что работать в компании нужно с полной ответственностью и пониманием к другим игрокам. \n\
						На базе компании есть парковка, где должны располагаться фуры. С их помощью которых можно начать работу.\n\n\
						После того как Вы возьмёте транспорт компании, необходимо оставить залог. Если Вы заняли тягач, то Вам потребуется взять\n\
						нужный прицеп. Они доступны в меню гаража (меню можно открыть через сигнал грузовика). Прицепы появляются на специальной\n\
						парковке. Также рекомендуем обращать внимание на инструкции в чате, они часто помогают.\n\n\
						Есть два вида прицепов: для топлива и для твёрдого товара. Иногда все прицепы одного типа могут разобрать. Если в гараже нет\n\
						нужного Вам прицепа, то придётся подождать пока кто-то другой не закончит свою работу. Если на парковке компании есть\n\
						обычный грузовик (не тягач), то можно использовать его, он не требует прицепа (однако он не может перевозить топливо).\n\n\
						Чтобы правильно закончить работу, необходимо приехать на базу компании и вернуть рабочий транспорт и прицеп (если \n\
						Вы его брали). Важное примечание: если рабочий транспорт будет сломан, то придётся оплатить штраф.\n",
						"Назад", ""
					);
				}
				case 3: 
				{
					Dialog
					(
						playerid, DIALOG_TK_JMENU_TUTORIAL_EXIT, DIALOG_STYLE_MSGBOX, 
						"{FFCD00}Руководство по работе: навык и опыт", 
						"{ffffff}Навык дальнобойщика показывает Вашу опытность на данной работе и влияет на рабочий процесс, зачастую упрощая его.\n\
						Навык может как увеличиваться так и уменьшаться. Всё зависит от Вашего стиля работы.\n\n\
						Пожалуй, единственный способ заставить прогрессировать навык, это быстро и качественно выполнять свою работу.\n\
						Но иногда случаются аварии, в ходе чего перевозимый Вами товар может повредиться. Если повреждения критичны,\n\
						то компания выпишет Вам денежный штраф (при получении штрафов навык снижается). Нанесение ущерба транспорту,\n\
						прицепам и небрежное отношение к работе также способствует убыванию навыка.\n\n\
						Хорошо развитый навык может неплохо скрасить рабочий процесс. Он позволяет получить преимущество перед менее\n\
						опытными сотрудниками. У опытного дальнобойщика будет уходить меньше времени на погрузку товара и он сможет\n\
						получать приятную надбавку к заработанной плате (исходя из прогнозируемой зарплаты и процента прокачки навыка).\n\n\
						У каждого дальнобойщика есть своё удостоверение, которое можно показать. Оно доступно по команде {fbdf6a}/tpass{ffffff}.\n",
						"Назад", ""
					);
				}
				case 4: 
				{
					Dialog
					(
						playerid, DIALOG_TK_JMENU_TUTORIAL_EXIT, DIALOG_STYLE_MSGBOX, 
						"{FFCD00}Руководство по работе: система рейтинга", 
						"{ffffff}Система рейтинга помогает соревноваться дальнобойщикам и компаниям между собой. Очки могут как прибавляться,\n\
						так и убавляться. Например, за поставку груза без задержек и ущерба Вы сможете получить вознаграждение в виде очков\n\
						навыка и рейтинга. Важно полностью завершать заказы, а не оставлять их на половине. Иначе Вы не сможете получить \n\
						полное вознаграждение.\n\n\
						В системе рейтинга среди сотрудников компаний существуют номинации: \'{fbdf6a}Сотрудник Дня{ffffff}\', \'{fbdf6a}Сотрудник Недели{ffffff}\'\n\
						и \'{fbdf6a}Сотрудник Месяца{ffffff}\'. Победитель одной из таких номинаций определяется наибольшим количеством заработанных\n\
						очков рейтинга за указаный промежуток времени. Вознаграждения за победу в номинации бывают разные, чем больше срок\n\
						определения победителя, тем более ценная будет награда.",
						"Назад", ""
					);
				}
				case 5: 
				{
					Dialog
					(
						playerid, DIALOG_TK_JMENU_TUTORIAL_EXIT, DIALOG_STYLE_MSGBOX, 
						"{FFCD00}Руководство по работе: штрафы", 
						"{ffffff}1. Уничтожение грузовика и прицепа (или цистерны).\n\
						Последствия: -{f06868}650 руб{ffffff}.\n\n\
						2. Уничтожение рабочего грузовика.\n\
						Последствия: -{f06868}400 руб{ffffff}.\n\n\
						3. Уничтожение прицепа для груза или цистерны с топливом.\n\
						Последствия: -{f06868}250 руб{ffffff}.\n\n\
						4. Потеря прицепа для груза или прицепа с цистерной.\n\
						Последствия: -{f06868}300 руб{ffffff}.\n\n\
						5. Долгое нахождение на паузе, при этом занимая рабочий транспорт.\n\
						Последствия: -{f06868}400 руб{ffffff}.\n\n\
						6. Ущерб доставляемому грузу.\n\
						Последствия: {f06868}денежный штраф{ffffff}, исходя из нанесённого ущерба.\n\n\
						7. Проезд на красный в рабочее время.\n\
						Последствия: {f06868}денежный штраф от государства{ffffff}.\n\n\
						За каждое нарушение предусмотрено снижение очков рейтинга и очков навыка.\n\
						Если у Вас не будет средств, чтобы оплатить штраф, то очки будут снижены в большом количестве.\n",
						"Назад", ""
					);
				}
			}
		}
		case DIALOG_TK_JMENU_TUTORIAL_EXIT:
		{
			if(!response) return 1;

			Dialog
			(
				playerid, DIALOG_TK_JMENU_TUTORIAL, DIALOG_STYLE_LIST, 
				"{FFCD00}Руководство по работе", 
				"{fbdf6a}1.{ffffff} Что такое транспортная компания\n\
				{fbdf6a}2.{ffffff} Как работать в транспортной компании\n\
				{fbdf6a}3.{ffffff} Информация о навыке дальнобойщика\n\
				{fbdf6a}4.{ffffff} Понятия \'рейтинг\' и \'номинация\'\n\
				{fbdf6a}5.{ffffff} Возможные штрафы за нарушения\n",
				"Далее", "Назад"
			);
		}

		case DIALOG_TK_JMENU_1:
		{
			if(!response) return 1;

			ShowPlayerJMenu(playerid);
		}
		case DIALOG_TK_MENU_INVITE_1:
		{
			if(!response) return 1;
			
			if(GetPlayerData(playerid, P_LEVEL) < 4) return SCM(playerid, COLOR_GREY, "* У вас недостаточный уровень для трудоустройства");
			
			Dialog
			(
				playerid, DIALOG_TK_MENU_INVITE_2, DIALOG_STYLE_LIST, 
				"{FFFFFF}Список доступных вакансий", 
				"{FFFFFF}1. Внештатный сотрудник\t{E6CE7B}(требуется свой грузовик)\n\
				{FFFFFF}2. Обычный сотрудник\t{E6CE7B}(особых критерий нет)",
				"Выбор", "Закрыть"
			);
		}

		case DIALOG_TK_MENU_INVITE_2:
		{
			if(!response) return 1;

			switch(listitem + 1)
			{
				case 1: 
				{
					SCM(playerid, 0x66CC00FF, "Вы устроились на работу \"Дальнобойщик\"");
					SCM(playerid, 0xFFFFFFFF, "Рекомендуем Вам ознакомиться с {E6CE7B}руководством по работе{FFFFFF}, оно доступно через меню - {BEC58C}/jmenu");

					SetPlayerData(playerid, P_JOB, 4);	
					UpdatePlayerDatabaseInt(playerid, "job", GetPlayerData(playerid, P_JOB));

					SetPlayerData(playerid, P_TK_JOB, GetNearestBusiness(playerid, 64.0));	
					UpdatePlayerDatabaseInt(playerid, "tk_job", GetPlayerData(playerid, P_TK_JOB));

					SetPlayerData(playerid, P_TK_JOB_TYPE, 2);	
					UpdatePlayerDatabaseInt(playerid, "tk_job_type", GetPlayerData(playerid, P_TK_JOB_TYPE));
				}
				case 2:
				{
					SCM(playerid, 0x66CC00FF, "Вы устроились на работу \"Дальнобойщик\"");
					SCM(playerid, 0xFFFFFFFF, "Рекомендуем Вам ознакомиться с {E6CE7B}руководством по работе{FFFFFF}, оно доступно через меню - {BEC58C}/jmenu");

					SetPlayerData(playerid, P_JOB, 4);	
					UpdatePlayerDatabaseInt(playerid, "job", GetPlayerData(playerid, P_JOB));

					SetPlayerData(playerid, P_TK_JOB, GetNearestBusiness(playerid, 64.0));	
					UpdatePlayerDatabaseInt(playerid, "tk_job", GetPlayerData(playerid, P_TK_JOB));

					SetPlayerData(playerid, P_TK_JOB_TYPE, 1);	
					UpdatePlayerDatabaseInt(playerid, "tk_job_type", GetPlayerData(playerid, P_TK_JOB_TYPE));
				}
			}
		}

		case DIALOG_TK_MENU_H:
		{
			if(!response) return 1;

			if(GetPlayerData(playerid, P_JOB_CAR) != GetPlayerVehicleID(playerid)) return 1;

			switch(listitem + 1)
			{
				case 1: 
				{
					if(GetPlayerData(playerid, P_TK_JOB_TYPE) != 1) return SCM(playerid, COLOR_GREY, "* Вы не можете посместить свой транспорт на парковку");

					SCM(playerid, 0xFFFFFFFF, "Вы поместили {E6CE7B}транспорт на парковку");
					SetVehicleToRespawn(GetPlayerData(playerid, P_JOB_CAR));

					SetPlayerData(playerid, P_JOB_CAR, INVALID_VEHICLE_ID);
				}
				case 2:
				{
					if(g_player_trailer_status[playerid] == 0) return SCM(playerid, COLOR_GREY, "* Вы не брали прицеп, чтобы его поместить в гараж");
					SCM(playerid, 0xFFFFFFFF, "Вы поместили {E6CE7B}прицеп в гараж");
					DestroyVehicle(g_player_trailer[playerid]);
					g_player_trailer_status[playerid] = 0;
					g_player_trailer_type[playerid] = 0;
				}
				case 3:
				{
					if(g_player_trailer_status[playerid] != 0) return SCM(playerid, COLOR_GREY, "* Сначала поместите прицеп в гараж который взяли ранее");

					new type;
					if(GetPlayerData(playerid, P_TK_JOB) == 129) type = 0;
					if(GetPlayerData(playerid, P_TK_JOB) == 130) type = 1;
					if(GetPlayerData(playerid, P_TK_JOB) == 131) type = 2;

					new random_ = random(4);
					g_player_trailer[playerid] = CreateVehicle(435, g_pos_truck_trailer[type][random_][0],g_pos_truck_trailer[type][random_][1],g_pos_truck_trailer[type][random_][2],g_pos_truck_trailer[type][random_][3], 1, 1, -1); //Дальнобойщики
					g_player_trailer_status[playerid] = 1;
					g_player_trailer_type[playerid] = 1;

					SCM(playerid, 0xFFFFFFFF, "Ваш прицеп располагается в {E6CE7B}складском комплексе{FFFFFF}, подъедьте к нему {E6CE7B}задней стороной {FFFFFF}и прицепитесь");
				}
				case 4:
				{
					if(g_player_trailer_status[playerid] != 0) return SCM(playerid, COLOR_GREY, "* Сначала поместите прицеп в гараж который взяли ранее");

					new type;
					if(GetPlayerData(playerid, P_TK_JOB) == 129) type = 0;
					if(GetPlayerData(playerid, P_TK_JOB) == 130) type = 1;
					if(GetPlayerData(playerid, P_TK_JOB) == 131) type = 2;

					new random_ = random(4);
					g_player_trailer[playerid] = CreateVehicle(584, g_pos_truck_trailer[type][random_][0],g_pos_truck_trailer[type][random_][1],g_pos_truck_trailer[type][random_][2],g_pos_truck_trailer[type][random_][3], 1, 1, -1); //Дальнобойщики
					g_player_trailer_status[playerid] = 1;
					g_player_trailer_type[playerid] = 2;

					SCM(playerid, 0xFFFFFFFF, "Ваш прицеп располагается в {E6CE7B}складском комплексе{FFFFFF}, подъедьте к нему {E6CE7B}задней стороной {FFFFFF}и прицепитесь");
				}
				case 5:
				{
					Dialog
					(
						playerid, DIALOG_TK_MENU_H, DIALOG_STYLE_MSGBOX, 
						"{FFCD00}Информация о парковке", 
						"{ffffff}На базе каждой транспортной компании есть парковка для грузовиков. Одновременно на парковке не может\n\
						располагаться более 5 фур. Это стандартные лимиты на парковочные места. Иногда транспорта\n\
						может и вовсе не быть.\n\n\
						Начинающие компании могут позволить себе немного транспорта, по мере развития автопарк становится больше.\n\
						Обищй лимит транспортных средств в компании - 20 единиц. На каждого сотрудника предусмотрен транспорт.\n\n\
						Как только сотрудник возьмёт себе транспорт и покинет парковку, при наличии транспорта в гараже,\n\
						спустя некоторое время на парковку будет вывезен очередной грузовик. Владелец компании может полностью \n\
						распоряжаться своими транспортными средствами, и при необходимости изменять свой автопарк.\n\n\
						Если сотрудник нанёс ущерб транспорту, или доставлемому товару - ему выдадут штраф на определённую сумму.\n\
						Полный список штрафов можно глянуть в руководстве (/jmenu > Руководство).\n\n",
						"", "Закрыть"
					);
				}
			}
		}
		case DIALOG_RAFFLE_SHOP:
		{
			if(!response) return 1;

			for(new i; i < sizeof g_raffleShop; i++)
			{
				if(!IsPlayerInRangeOfPoint(playerid, 4.5, g_pos_car_raffle[i][0],g_pos_car_raffle[i][1],g_pos_car_raffle[i][2])) 
					continue;

				if(GetPlayerCoins(playerid) < g_info_raffleshopping[g_raffleShop[i][RS_ID]][IRS_PRICE]) 
					return SCM(playerid, COLOR_GREY, "* Недостаточно донат-монет для покупки билета.");

				GivePlayerCoins(playerid, -g_info_raffleshopping[g_raffleShop[i][RS_ID]][IRS_PRICE]);

				static query[94];
				format(query, sizeof query, "INSERT INTO raffle_shop (owner_id, type, ticket_id) VALUES (%d, %d, %d)", GetPlayerAccountID(playerid), i, g_raffleShop[i][RS_TICKETS]);
				mysql_query(mysql, query, false);

				g_raffleShop[i][RS_TICKETS]++;

				return 1;
			}
		}
		case DIALOG_ADMIN_PANEL:
		{
			if(!response) return 1;

			new admin = GetPlayerAdminEx(playerid);
			new item;

			if(listitem == item)
			{
				Dialog(
					playerid,
					DIALOG_ADMIN_RULES,
					DIALOG_STYLE_MSGBOX,
					"{e2c906}Регламент администрации",
					"{ffffff}1. Администратор обязан соблюдать правила сервера.\n\
					2. Администратор является представителем проекта.\n\
					3. Запрещено использовать админ-права в личных целях.\n\
					4. Администратор обязан отвечать на репорты.\n\
					5. Минимальная норма онлайна — 4 часа в сутки.\n\
					6. Запрещено выдавать имущество без разрешения.\n\
					7. Запрещено вмешиваться в RP без причины.\n\
					8. Запрещено использовать сторонний софт.\n\
					9. Запрещены оскорбления и токсичность.\n\
					10. Запрещено игнорировать игроков.\n\
					11. За нарушения выдаются выговоры/снятие.\n\
					12. Все действия администрации логируются.",
					"Понятно",
					""
				);
				return 1;
			}
			item++;

			if(admin >= 5)
			{
				if(listitem == item)
				{
					callcmd::adminlist(playerid);
					return 1;
				}
			}
			item++;

			if(admin >= 4)
			{
				if(listitem == item)
				{
					for(new i; i < MAX_VEHICLES; i++)
					{
						if(!IsValidVehicle(i)) continue;
						if(IsVehicleOccupied(i)) continue;
						if(IsTrailerAttachedToAnyVehicle(i)) continue;

						SetVehicleToRespawn(i);
					}

					SendClientMessage(playerid, -1,
					"* {ffffff}Вы успешно зареспавнили весь транспорт!");

					return 1;
				}
			}
			item++;

			if(admin >= 5)
			{
				if(listitem == item)
				{
					Dialog(playerid,
					DIALOG_WEATHER,
					DIALOG_STYLE_INPUT,
					"{87CEFA}Смена погоды",
					"Введите ID погоды:",
					"Далее",
					"Отмена");

					return 1;
				}
			}
			item++;

			if(admin >= 7)
			{
				if(listitem == item)
				{
					callcmd::mplist(playerid);
					return 1;
				}
			}
			item++;

			if(admin >= 2)
			{
				if(listitem == item)
				{
					SCM(playerid, -1, "* В разработке");
					return 1;
				}
			}
			item++;

			if(admin >= 11)
			{
				if(listitem == item)
				{
					callcmd::fullsellall(playerid);
					return 1;
				}
			}
			item++;

			if(admin >= 3)
			{
				if(listitem == item)
				{
					if(!IsPlayerInAnyVehicle(playerid))
						return SCM(playerid, -1, "* Вы не в транспорте");

					RepairVehicle(GetPlayerVehicleID(playerid));

					SCM(playerid, -1, "* Транспорт отремонтирован");
					return 1;
				}
			}
			item++;
			
			if(admin >= 11)
			{
				if(listitem == item)
				{
					Dialog(playerid,
					DIALOG_FULLPRODS,
					DIALOG_STYLE_INPUT,
					"{66CC33}Пополнение продуктов",
					"Введите количество продуктов\n\
					(0 - 10000)",
					"Установить",
					"Отмена");

					return 1;
				}
			}
			item++;

			if(admin >= 6)
			{
				if(listitem == item)
				{
					for(new vehicleid; vehicleid < MAX_VEHICLES; vehicleid++)
					{
						if(!IsValidVehicle(vehicleid))
							continue;

						SetVehicleData(vehicleid, V_FUEL, 100);
					}

					SendClientMessageToAll(
					-1,
					"{e2c906}* На сервере были заправлены все автомобили. Приятной игры!");

					new fmt_text[128];

					format(fmt_text, sizeof fmt_text,
					"A: %s[%d] заправил все автомобили на сервере",
					GetPlayerNameEx(playerid),
					playerid);

					SendMessageToAdmins(fmt_text, 0x999999FF);

					return 1;
				}
			}
			item++;

			if(admin >= 1)
			{
				if(listitem == item)
				{
					SCM(playerid, -1, "* В разработке");
					return 1;
				}
			}
			item++;

			if(admin >= 11)
			{
				if(listitem == item)
				{
					callcmd::giveall(playerid);
					return 1;
				}
			}

			return 1;
		}
		case DIALOG_WEATHER:
		{
			if(!response) return 1;

			new weather = strval(inputtext);

			if(!(-1 <= weather <= 20))
			{
				SendClientMessage(playerid, 0x999999FF,
				"* Погода от 0 до 20 (-1 - случайная смена)");
				SendClientMessage(playerid, 0x999999FF,
				"* Рекомендовано: 1, 3, 8, 9, 18");
				return 1;
			}

			if(weather != -1)
				SetWeather(weather);
			else
				SetRandomWeather();

			new fmt_text[128];

			if(weather != -1)
				format(fmt_text, sizeof fmt_text,
				"* Вы установили погоду %d", weather);
			else
				format(fmt_text, sizeof fmt_text,
				"* Вы установили случайную погоду");

			SendClientMessage(playerid, -1, fmt_text);

			if(GetPlayerAdminEx(playerid) <= 11)
			{
				if(weather != -1)
				{
					format(fmt_text, sizeof fmt_text,
					"A: %s[%d] установил погоду на сервере на %d",
					GetPlayerNameEx(playerid),
					playerid,
					weather);
				}
				else
				{
					format(fmt_text, sizeof fmt_text,
					"A: %s[%d] установил случайную погоду на сервере",
					GetPlayerNameEx(playerid),
					playerid);
				}

				SendMessageToAdmins(fmt_text, 0x999999FF);
			}

			return 1;
		}
		case DIALOG_FULLPRODS:
		{
		    if(!response) return 1;

		    new amount = strval(inputtext);

		    if(!(0 <= amount <= 10000))
		        return SendClientMessage(playerid,
		        0x999999FF,
		        "* Количество продуктов от 0 до 10000");

		    for(new biz_id; biz_id < g_business_loaded - 1; biz_id++)
		        SetBusinessData(biz_id, B_PRODS, amount);

		    new fmt_text[128];

		    format(fmt_text, sizeof fmt_text,
		    "UPDATE business SET products=%d", amount);
		    mysql_query(mysql, fmt_text, false);

		    format(fmt_text, sizeof fmt_text,
		    "* Вы установили %d продуктов во всех бизнесах", amount);
		    SendClientMessage(playerid, 0x66CC33FF, fmt_text);

		    format(fmt_text, sizeof fmt_text,
		    "A: %s[%d] установил %d продуктов во всех бизнесах",
		    GetPlayerNameEx(playerid),
		    playerid,
		    amount);

		    SendMessageToAdmins(fmt_text, 0x999999FF);

		    return 1;
		}
		case DIALOG_TINTING_INSTAL:
		{
			if(!response) return 1;

			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), g_player_tinting_price[playerid])) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);

			new vehicleid = GetPlayerVehicleID(playerid);
    		new toner_id = GetPlayerInBiz(playerid);

			GivePlayerMoneyEx(playerid, -g_player_tinting_price[playerid], "Покупка тонировки");

			AddBusinessProfit(playerid, toner_id, (g_player_tinting_price[playerid] / 100) * 20, 1);

			OnBattlePass_Perfomance(playerid, 21, 1);

			MoralPacket_1(playerid, s_CefInterface, t_CefHide, "TintingOrder");

			SetVehiclePos(vehicleid, GetBusinessData(toner_id, B_EXIT_POS_X), GetBusinessData(toner_id, B_EXIT_POS_Y), GetBusinessData(toner_id, B_EXIT_POS_Z));
			SetVehicleZAngle(vehicleid, GetBusinessData(toner_id, B_EXIT_ANGLE));
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			LinkVehicleToInterior(vehicleid, 0);
			SetVehicleVirtualWorld(vehicleid, 0);
			
			SetPlayerInBiz(playerid, -1);
			TogglePlayerControllable(playerid, true);
			SetCameraBehindPlayer(playerid);

			SaveOwnableTinting(vehicleid);

			g_player_tinting_price[playerid] = 0;
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.setCursorStatus(1, 0)");
		}
		case DIALOG_VINIL_INSTAL:
		{
			if(!response) return 1;

			new type = g_player_vinil[playerid];

			if(type < 51) if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), g_tuning_vinil_price[type])) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);
			else if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 500000)) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);

			if(type < 51) GivePlayerMoneyEx(playerid, -g_tuning_vinil_price[type], "Покупка винила в детелинге");
			else GivePlayerMoneyEx(playerid, -500000, "Покупка винила в детелинге");

			new vehicleid = GetPlayerOwnableCarLast(playerid);
			new index = GetVehicleData(vehicleid, V_ACTION_ID);

			SetOwnableCarData(index, OC_VINILTYPE, 1);
			if(type == 0) SetOwnableCarData(index, OC_VINIL, -1);
			else if(type < 51) SetOwnableCarData(index, OC_VINIL, type);
			else SetOwnableCarData(index, OC_VINIL, type - 41), SetOwnableCarData(index, OC_VINILTYPE, 0);
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.setCursorStatus(1, 0)");

			static query[148];
			format(query, sizeof query, "UPDATE ownable_cars SET vinil=%d, viniltype=%d WHERE id=%d", GetOwnableCarData(index, OC_VINIL), GetOwnableCarData(index, OC_VINILTYPE), GetOwnableCarData(index, OC_SQL_ID));
			mysql_query(mysql, query, false);

			new biz_id = GetPlayerInBiz(playerid);

			if(type < 51) AddBusinessProfit(playerid, biz_id, (g_tuning_vinil_price[type] / 100) * 20, 1);
			else AddBusinessProfit(playerid, biz_id, 2000000, 1);

			g_player_vinil[playerid] = 0;
		}
		case DIALOG_NONCEF_MENU:
		{
			str_q[0] = EOS;
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "MainMenu", "[-1, 6, []]");
			format(str_q, sizeof str_q, "interface('MainMenu').onServerResponse(0, '[%s,%d,\"%s\",[\"%s\"],[%d,%d,%d],%d,%d,%d,%d,\"%s\",%d,%d,%d,0,\"{FFFFFF}"SERVER_NAME_RP" "SERVER_VERSION"\",%d,%d]')",
			GetPlayerMoneyEx(playerid), GetPlayerCurrentDonate(playerid), GetPlayerNameEx(playerid), GetPlayerGameStatus(playerid),  GetPlayerLevel(playerid), GetExpToNextLevel(playerid), GetPlayerExp(playerid), GetPlayerPremium(playerid), g_Vinoslivost[GetPlayerData(playerid, P_IMPROVEMENTS)],
			GetPlayerData(playerid, P_POWER), RPPoint[playerid], nakolka_name[GetPlayerData(playerid, P_NAKOLKA)], playerid, GetPlayerData(playerid, P_BP_LEVEL), GetPlayerData(playerid, P_BP_PREMIUM), GetPlayerPremiumTime(playerid), GetPlayerPhone(playerid));
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "MainMenu", str_q);
			return 1;
		}	
		case DIALOG_SHINOMONTAJ_INSTAL:
		{
			if(!response) return 1;

			new vehicleid = GetPlayerOwnableCarLast(playerid);

			if(vehicleid == INVALID_VEHICLE_ID) return 1;

			new index = GetVehicleData(vehicleid, V_ACTION_ID);

			new type = g_player_diski[playerid];
	
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), g_tuning_diski_id[type][2])) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);

			GivePlayerMoneyEx(playerid, -g_tuning_diski_id[type][2], "покупка дисков");

			SetOwnableCarData(index, OC_DISKI, g_tuning_diski_id[type][0]);

			str_q[0] = EOS;
			format(str_q, sizeof str_q, "UPDATE ownable_cars SET diski=%d WHERE id=%d", g_tuning_diski_id[type][0], GetOwnableCarData(index, OC_SQL_ID));
			mysql_query(mysql, str_q, false);

			new business_id = GetNearestBusiness(playerid, 15.0);

			if(business_id != -1)
			{
				AddBusinessProfit(playerid, business_id, g_tuning_diski_id[type][2], 1);
			}

			new Float:x = GetPVarFloat(playerid, "styling_x");
			new Float:y = GetPVarFloat(playerid, "styling_y");
			new Float:z = GetPVarFloat(playerid, "styling_z");
			new Float:a = GetPVarFloat(playerid, "styling_a");

			SetCameraBehindPlayer(playerid);

			TogglePlayerSpectating(playerid, 0);
	        SetPlayerPosEx(playerid, x, y, z, a);

			SendClientEvent(playerid, t_CefHide, "TuningStyling");
		}
		case DIALOG_SHINOMONTAJ:
		{
			if(!response) return 1;

			switch(listitem + 1)
			{
				case 1:
				{
                    page_cars[playerid] = 1;
				    type_page_cars[playerid] = 18;
				    ShowOwnableCars(playerid, DIALOG_DISKI, page_cars[playerid]);
				}
			}
		}
		//контейнеры
		case DIALOG_CONTAINER_BET:
		{
			if(!response) return 1;
			
			for(new i; i < MAX_CONTAINERS; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, s_containers_pos_obj[i][4][0], s_containers_pos_obj[i][4][1], s_containers_pos_obj[i][4][2]))
				{
					if(s_containers[i][S_CT_STATUS] != 1) return 1;

					if(IsPlayerInRangeOfPoint(playerid, 4.0,-1965.4330,2931.9961,7.8827)){InterpolateCameraPos(playerid, -1971.4741,2924.9089,11.0000, -1971.4741,2924.9089,11.0000, 140000);InterpolateCameraLookAt(playerid, -1958.8909,2932.2317,7.6256, -1958.8909,2932.2317,7.6256, 140000);}
					if(IsPlayerInRangeOfPoint(playerid, 4.0,-1949.1790,2932.1426,7.8827)){InterpolateCameraPos(playerid, -1954.6362,2925.3267,11.0000, -1954.6362,2925.3267,11.0000, 140000);InterpolateCameraLookAt(playerid, -1942.3273,2932.2578,7.6256, -1942.3273,2932.2578,7.6256, 140000);}
					if(IsPlayerInRangeOfPoint(playerid, 4.0,-1931.8142,2932.0295,7.8827)){InterpolateCameraPos(playerid, -1937.0596,2925.6311,11.0000, -1937.0596,2925.6311,11.0000, 140000);InterpolateCameraLookAt(playerid, -1925.0729,2932.0801,7.6256, -1925.0729,2932.0801,7.6256, 140000);}
					if(IsPlayerInRangeOfPoint(playerid, 4.0,-1914.7488,2931.9314,7.8827)){InterpolateCameraPos(playerid, -1919.9353,2925.3799,11.0000, -1919.9353,2925.3799,11.0000, 140000);	InterpolateCameraLookAt(playerid, -1908.0543,2932.1396,7.8256, -1908.0543,2932.1396,7.8256, 140000);}
					if(IsPlayerInRangeOfPoint(playerid, 4.0,-1904.9335,2926.5046,7.8827)){InterpolateCameraPos(playerid, -1908.7003,2920.2185,11.0000, -1908.7003,2920.2185,11.0000, 140000);	InterpolateCameraLookAt(playerid, -1898.1759,2926.6406,8.0333, -1898.1759,2926.6406,8.0333, 140000);}
					if(IsPlayerInRangeOfPoint(playerid, 4.0,-1922.4528,2926.6348,7.8827)){InterpolateCameraPos(playerid, -1926.1553,2919.7920,11.0000, -1926.1553,2919.7920,11.0000, 140000);	InterpolateCameraLookAt(playerid, -1915.8451,2926.5098,8.0256, -1915.8451,2926.5098,8.0256, 140000);}
					if(IsPlayerInRangeOfPoint(playerid, 4.0,-1938.8236,2926.3770,7.8827)){InterpolateCameraPos(playerid, -1942.5883,2919.4651,11.0000, -1942.5883,2919.4651,11.0000, 140000);	InterpolateCameraLookAt(playerid, -1931.7786,2926.5559,8.0256, -1931.7786,2926.5559,8.0256, 140000);}

					static fsf[213];
					format(fsf, sizeof fsf, "[\"%s\", %d, %d, %d, %d]", s_containers_type_name[s_containers[i][S_CT_ITEM_TYPE]], s_containers[i][S_CT_TYPE], s_containers[i][S_CT_PRICE], s_containers[i][S_CT_PRICE] + s_containers[i][S_CT_PRICE] / 10, s_containers[i][S_CT_TIME]);
					MoralPacket_2(playerid, s_CefInterface, t_CefShow, "ContainersBet", fsf);

					SCM(playerid, 0xa9acafFF, "Вы вошли в режим участника на аукцион контейнеров.");
					SCM(playerid, 0xa9acafFF, "Увеличивайте ставку чтобы лидировать в аукционе относительно текущей цены контейнера.");
					SCM(playerid, 0xa9acafFF, "Не покидайте, аукцион, если Ваша ставка лидирует, иначе дальнейшее участие будет невозможно.");

					containers_id[playerid] = i;
				}
			}
		}
				case DIALOG_PLAYER_ACS_CONTAINER:
		{
			if(!response) return 1;

			new i = containers_id[playerid];

			new item_id = containers_item_id[playerid];

			switch(listitem)
			{
				case 0..1:
				{
					static str_c[450],str_cs[70];
					new port = 50000 / 100 * 20;
					format(str_cs, sizeof str_cs,"{769A37}Аксессуар: №%d", s_containers_items[i][item_id][S_CT_I_ID]);
					format(str_c, sizeof str_c,
					"{ffffff}-Государственная стоимость: {FFA500}%s руб\n{ffffff}-Стоимость в порту: {FFA500}%s руб {B25520}(-20%)\n{FFFFFF}\n{ffffff}1.Оставить себе\n{ffffff}2.Продать в порту", formatInt(50000), formatInt(50000 - port));

					Dialog
					(
						playerid, DIALOG_PLAYER_ACS_CONTAINER, DIALOG_STYLE_LIST, str_cs, str_c,
						"Выбор", "Отмена"
					);
				}
				case 2:
				{
					if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

					SCMF(playerid, 0x78C02AFF, "Вы забрали Аксессуар {FFFFFF}[№%d] {78C02A}себе в инвентарь.", s_containers_items[i][item_id][S_CT_I_ID]);

					GiveAcs(playerid, s_containers_items[i][item_id][S_CT_I_ID], s_containers_items[i][item_id][S_CT_I_IDNX]);

					s_containers_items[i][item_id][S_CT_I_STATUS] = 0;

					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Containers");

					OpenItemContainers(playerid);
				}
				case 3:
				{
					new port = 50000 / 100 * 20;
					SCMF(playerid, 0x78C02AFF, "Аксессуар {FFFFFF}[№%d] {78C02A}был продан за {FFA500}%s руб.", s_containers_items[i][item_id][S_CT_I_ID], formatInt(50000 - port));

					GivePlayerMoneyEx(playerid, 50000 - port, "Продажа предмета с контейнера");

					s_containers_items[i][item_id][S_CT_I_STATUS] = 0;

					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Containers");

					OpenItemContainers(playerid);
				}
			}
		}
		case DIALOG_PLAYER_ITEM_CONTAINER:
		{
			if(!response) return 1;

			new i = containers_id[playerid];

			new item_id = containers_item_id[playerid];

			switch(listitem)
			{
				case 0..1:
				{
					static str_c[450],str_cs[70];
					new port = ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]][i_item_price] / 100 * 20;
					format(str_cs, sizeof str_cs,"{769A37}Предмет: №%d", s_containers_items[i][item_id][S_CT_I_ID]);
					format(str_c, sizeof str_c,
					"{ffffff}-Государственная стоимость: {FFA500}%s руб\n{ffffff}-Стоимость в порту: {FFA500}%s руб {B25520}(-20%)\n{FFFFFF}\n{ffffff}1.Оставить себе\n{ffffff}2.Продать в порту", formatInt(ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]][i_item_price]), formatInt(ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]][i_item_price] - port));

					Dialog
					(
						playerid, DIALOG_PLAYER_ITEM_CONTAINER, DIALOG_STYLE_LIST, str_cs, str_c,
						"Выбор", "Отмена"
					);
				}
				case 2:
				{
					if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

					SCMF(playerid, 0x78C02AFF, "Вы забрали {FFFFFF}%s [№%d] {78C02A}себе в инвентарь.", ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]], s_containers_items[i][item_id][S_CT_I_ID]);

					GiveIteam(playerid, s_containers_items[i][item_id][S_CT_I_ID], 1, 1, 0);

					s_containers_items[i][item_id][S_CT_I_STATUS] = 0;

					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Containers");

					OpenItemContainers(playerid);
				}
				case 3:
				{
					new port = ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]][i_item_price] / 100 * 20;
					SCMF(playerid, 0x78C02AFF, "Предмет {FFFFFF}%s [№%d] {78C02A}был продан за {FFA500}%s руб.", ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]], s_containers_items[i][item_id][S_CT_I_ID], formatInt(ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]][i_item_price] - port));

					GivePlayerMoneyEx(playerid, ItemsInfo[s_containers_items[i][item_id][S_CT_I_ID]][i_item_price] - port, "Продажа предмета с контейнера");

					s_containers_items[i][item_id][S_CT_I_STATUS] = 0;

					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Containers");

					OpenItemContainers(playerid);
				}
			}
		}
		case DIALOG_PLAYER_SKIN_CONTAINER:
		{
			if(!response) return 1;

			new i = containers_id[playerid];

			new item_id = containers_item_id[playerid];

			switch(listitem)
			{
				case 0..1:
				{
					static str_c[450],str_cs[70];
					new port = s_containers_skins[s_containers[i][S_CT_TYPE]][s_containers_items[i][item_id][S_CT_I_IDNX]][1] / 100 * 20;
					format(str_cs, sizeof str_cs,"{769A37}Одежда: №%d",s_containers_skins[s_containers[i][S_CT_TYPE]][s_containers_items[i][item_id][S_CT_I_IDNX]][0]);
					format(str_c, sizeof str_c,
					"{ffffff}-Государственная стоимость: {FFA500}%s руб\n{ffffff}-Стоимость в порту: {FFA500}%s руб {B25520}(-20%)\n{FFFFFF}\n{ffffff}1.Оставить себе\n{ffffff}2.Продать в порту", formatInt(s_containers_skins[s_containers[i][S_CT_TYPE]][s_containers_items[i][item_id][S_CT_I_IDNX]][1]), formatInt(s_containers_skins[s_containers[i][S_CT_TYPE]][s_containers_items[i][item_id][S_CT_I_IDNX]][1] - port));

					Dialog
					(
						playerid, DIALOG_PLAYER_SKIN_CONTAINER, DIALOG_STYLE_LIST, str_cs, str_c,
						"Выбор", "Отмена"
					);
				}
				case 2:
				{
					if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

					SCMF(playerid, 0x78C02AFF, "Вы забрали одежду {FFFFFF}№%d {78C02A}себе в инвентарь.", s_containers_items[i][item_id][S_CT_I_ID]);

					GiveSkin(playerid, s_containers_items[i][item_id][S_CT_I_ID]);

					s_containers_items[i][item_id][S_CT_I_STATUS] = 0;

					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Containers");

					OpenItemContainers(playerid);
				}
				case 3:
				{
					new port = s_containers_skins[s_containers[i][S_CT_TYPE]][s_containers_items[i][item_id][S_CT_I_IDNX]][1] / 100 * 20;
					SCMF(playerid, 0x78C02AFF, "Одежда {FFFFFF}№%d {78C02A}была продан за {FFA500}%s руб.", s_containers_items[i][item_id][S_CT_I_ID], formatInt(s_containers_skins[s_containers[i][S_CT_TYPE]][s_containers_items[i][item_id][S_CT_I_IDNX]][1] - port));

					GivePlayerMoneyEx(playerid, s_containers_skins[s_containers[i][S_CT_TYPE]][s_containers_items[i][item_id][S_CT_I_IDNX]][1] - port, "Продажа скина с контейнера");

					s_containers_items[i][item_id][S_CT_I_STATUS] = 0;

					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Containers");

					OpenItemContainers(playerid);
				}
			}
		}
		case DIALOG_PLAYER_CAR_CONTAINER:
		{
			if(!response) return 1;

			new i = containers_id[playerid];

			switch(listitem)
			{
				case 0..1:
				{
					static str_c[450];
					new proc[20];
					format(proc, sizeof proc, "20%");
					new port = GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_PRICE) / 100 * 20;
					format(str_c, sizeof str_c,
					"{ffffff}-Государственная стоимость: {FFA500}%s руб\n{ffffff}-Стоимость в порту: {FFA500}%s руб {B25520}(-%s)\n{FFFFFF}\n{ffffff}1.Оставить себе\n{ffffff}2.Продать в порту", formatInt(GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_PRICE)), formatInt(GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_PRICE) - port), proc);
					Dialog
					(
						playerid, DIALOG_PLAYER_CAR_CONTAINER, DIALOG_STYLE_LIST, "{769A37}Действие с транспортом", str_c,
						"Выбор", "Отмена"
					);
				}
				case 2:
				{
					if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					{
						static str_c[450];
						new proc[20];
						format(proc, sizeof proc, "20%");
						new port = GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_PRICE) / 100 * 20;
						format(str_c, sizeof str_c,
						"{ffffff}-Государственная стоимость: {FFA500}%s руб\n{ffffff}-Стоимость в порту: {FFA500}%s руб {B25520}(-%s)\n{FFFFFF}\n{ffffff}1.Оставить себе\n{ffffff}2.Продать в порту", formatInt(GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_PRICE)), formatInt(GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_PRICE) - port), proc);
						Dialog
						(
							playerid, DIALOG_PLAYER_CAR_CONTAINER, DIALOG_STYLE_LIST, "{769A37}Действие с транспортом", str_c,
							"Выбор", "Отмена"
						);
						return 1;
					}
					GiveCar(playerid, s_containers_items[i][0][S_CT_I_ID], 1, 1, 0, -1, container_spawn_vehicle_buy[i][CS_POS_X], container_spawn_vehicle_buy[i][CS_POS_Y], container_spawn_vehicle_buy[i][CS_POS_Z], container_spawn_vehicle_buy[i][CS_POS_A], gettime());

					static query[144];
					format(query, sizeof query, "Вы забрали автомобиль {FFFFFF}%s {78C02A}себе.", GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_NAME));
					SendClientMessage(playerid, 0x78C02AFF, query);

					DellContainers(i);
					containers_id[playerid] = -1;
				}
				case 3:
				{
					new port = GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID] , VI_PRICE) / 100 * 20;
					static query[144];
					format(query, sizeof query, "Автомобиль {FFFFFF}%s {78C02A}был продан за {FFA500}%d руб.", GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID], VI_NAME), GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID], VI_PRICE) - port);
					SendClientMessage(playerid, 0x78C02AFF, query);

					GivePlayerMoneyEx(playerid, GetVehicleInfo(s_containers_items[i][0][S_CT_I_ID], VI_PRICE) - port, "Продажа авто в порту");

					DellContainers(i);
					containers_id[playerid] = -1;
				}
			}
		}
		case DIALOG_COINS_INFO:
		{
			if(!response) return 1;

			ShowCoinsInfo(playerid);
		}
		case DIALOG_COINS_LEVEL:
		{
			if(!response) return ShowCoinsInfo(playerid);
			
			new level = strval(inputtext);

			if(1 <= level <= 999 && IsNumeric(inputtext))
			{
				if(GetPlayerData(playerid, P_COINS) < 25 * level)
				{
					GameText(playerid, "~r~Недостаточно~n~"SERVER_COINS_NAME"", 3000, 2);

					Dialog
					(
						playerid, DIALOG_COINS_LEVEL, DIALOG_STYLE_INPUT,
						"Покупка игрового уровня",
						"{FFFFFF}Цена игрового уровня за единицу - {ffb841}25 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}Укажите уровень от {ffb841}1 {FFFFFF}до {ffb841}999",
						"Далее", "Назад"
					);
					return 1;
				}

				SetPlayerData(playerid, P_LEVEL, level);

				SetPlayerScore(playerid, level);

				UpdatePlayerDatabaseInt(playerid, "level", GetPlayerLevel(playerid));

				AddPlayerData(playerid, P_COINS, -, 25 * level);

				static query[128];
				format(query, sizeof query, "~r~-%s "SERVER_COINS_NAME"", formatInt(25 * level));
				GameText(playerid, query, 3000, 2);

				UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));
			}
			else
			{
				GameText(playerid, "~r~Укажите уровень~n~от 1 до 999", 3000, 2);

				Dialog
				(
					playerid, DIALOG_COINS_LEVEL, DIALOG_STYLE_INPUT,
					"Покупка игрового уровня",
					"{FFFFFF}Цена игрового уровня за единицу - {ffb841}25 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}Укажите уровень от {ffb841}1 {FFFFFF}до {ffb841}999",
					"Далее", "Назад"
				);
			}
		}
		case DIALOG_COINS_CAR:
		{
			if(!response) return 1;
			
			new modelid = strval(inputtext);

			if(!(400 <= modelid <= 614) && (!(699 <= modelid <= 699) && (!(793 <= modelid <= 799) && (!(15065 <= modelid <= 15299) && (!(15600 <= modelid <= 15691) && (!(907 <= modelid <= 909) && (!(965 <= modelid <= 965) && (!(999 <= modelid <= 999) && (!(1326 <= modelid <= 1326))))))))))
			{
				Dialog
				(
					playerid, DIALOG_COINS_CAR, DIALOG_STYLE_INPUT,
					"Покупка эксклюзивного транспорта (по id)",
					"{FFFFFF}Цена эксклюзивного транспорта - {ffb841}1999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}Укажите id транспорта который хотите приобрести",
					"Далее", "Назад"
				);
				return SCM(playerid, 0xCECECEFF, "* Вы указали неверный id авто. Доступные авто: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15675");
			}

			if(GetPlayerCurrentDonate(playerid) < 1999)
			{
				GameText(playerid, "~r~Недостаточно~n~"SERVER_COINS_NAME"", 3000, 2);

				Dialog
				(
					playerid, DIALOG_COINS_CAR, DIALOG_STYLE_INPUT,
					"Покупка эксклюзивного транспорта (по id)",
					"{FFFFFF}Цена эксклюзивного транспорта - {ffb841}1999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}Укажите id транспорта который хотите приобрести",
					"Далее", "Назад"
				);
				return 1;
			}

			if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) 
			{
				Dialog
				(
					playerid, DIALOG_COINS_CAR, DIALOG_STYLE_INPUT,
					"Покупка эксклюзивного транспорта (по id)",
					"{FFFFFF}Цена эксклюзивного транспорта - {ffb841}1999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}Укажите id транспорта который хотите приобрести",
					"Далее", "Назад"
				);
				return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты.");
			}

			GiveCar(playerid, modelid, 1, 1, -1, -1, 110.8994,322.3508,11.2202,251.4996, gettime());

			GivePlayerDonate(playerid, -1999);

			UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

			GameText(playerid, "~r~-1.999 "SERVER_COINS_NAME"", 3000, 2);

		}
		case DIALOG_COINS_SKIN: 
		{
			if(!response) return 1;
			
			new modelid = strval(inputtext);

			if(GetPlayerCurrentDonate(playerid) < 1699)
			{
				GameText(playerid, "~r~Недостаточно~n~"SERVER_COINS_NAME"", 3000, 2);

				Dialog
				(
					playerid, DIALOG_COINS_SKIN, DIALOG_STYLE_INPUT,
					"Покупка эксклюзивной одежды (по id)",
					"{FFFFFF}Цена эксклюзивной одежды - {ffb841}1699 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}Укажите id одежды которую хотите приобрести",
					"Далее", "Назад"
				);
				return 1;
			}

			if(GetInventorySlots(playerid) == -1) 
			{
				Dialog
				(
					playerid, DIALOG_COINS_SKIN, DIALOG_STYLE_INPUT,
					"Покупка эксклюзивной одежды (по id)",
					"{FFFFFF}Цена эксклюзивной одежды - {ffb841}1699 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}Укажите id одежды которую хотите приобрести",
					"Далее", "Назад"
				);
				return SendClientMessage(playerid, 0x3399FFFF, "* В вашем инвентаре нет свободного места.");
			}
			GiveSkin(playerid, modelid);

			GivePlayerDonate(playerid, -1699);
			UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));
			GameText(playerid, "~r~-1.699 "SERVER_COINS_NAME"", 3000, 2);

		}
		case DIALOG_COINS_POLICE_TABLE_1:
		{
			if(!response) return ShowCoinsInfo(playerid);
			ShowCoinsInfo(playerid), SendClientMessage(playerid, 0x3399FFFF, "* В разработке");
		}
		case DIALOG_COINS_TAXI_TABLE_1:
		{
			if(!response) return ShowCoinsInfo(playerid);
			ShowCoinsInfo(playerid), SendClientMessage(playerid, 0x3399FFFF, "* В разработке");
		}
		case DIALOG_COINS_LIST_CAR:
		{
			if(!response) return ShowCoinsInfo(playerid);
			
			new modelid, price;

			switch(listitem + 1)
			{
				case 1: modelid = 432, price = 4999;
				case 2: modelid = 476, price = 2999;
				case 3: modelid = 520, price = 2999;
				case 4: modelid = 548, price = 2199;
				case 5: modelid = 601, price = 1599;
				case 6: modelid = 578, price = 1099;
				case 7: modelid = 470, price = 1699;
				case 8: modelid = 433, price = 1099;
			}

			if(GetPlayerData(playerid, P_COINS) < price)
			{
				GameText(playerid, "~r~Недостаточно~n~"SERVER_COINS_NAME"", 3000, 2);

				Dialog
				(
					playerid, DIALOG_COINS_LIST_CAR, DIALOG_STYLE_LIST,
					"{FFFFFF}Покупка транспорта спец. служб",
					"{FFFFFF}1. {ffb841}Танк [№ 432]\t{FFFFFF}4999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}2. {ffb841}Истребитель #1 [№ 476]\t{FFFFFF}2999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}3. {ffb841}Истребитель #2 [№ 520]\t{FFFFFF}2999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}4. {ffb841}Вертолет [№ 548]\t{FFFFFF}2199 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}5. {ffb841}БТР-80 [№ 601]\t{FFFFFF}1599 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}6. {ffb841}Грузовой автомобиль 'Камаз' [№ 578]\t{FFFFFF}1099 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}7. {ffb841}Бронеавтомобиль 'Тигр' [№ 470]\t{FFFFFF}1699 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}8. {ffb841}Грузовой автомобиль 'Урал' [№ 433]\t{FFFFFF}1099 "SERVER_COINS_NAME"",
					"Далее", "Назад"
				);
				return 1;
			}

			if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) 
			{
				Dialog
				(
					playerid, DIALOG_COINS_LIST_CAR, DIALOG_STYLE_LIST,
					"{FFFFFF}Покупка транспорта спец. служб",
					"{FFFFFF}1. {ffb841}Танк [№ 432]\t{FFFFFF}4999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}2. {ffb841}Истрибитель #1 [№ 476]\t{FFFFFF}2999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}3. {ffb841}Истрибитель #2 [№ 520]\t{FFFFFF}2999 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}4. {ffb841}Вертолет [№ 548]\t{FFFFFF}2199 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}5. {ffb841}БТР-80 [№ 601]\t{FFFFFF}1599 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}6. {ffb841}Грозовой автомобиль 'Камаз' [№ 578]\t{FFFFFF}1099 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}7. {ffb841}Бронеавтомобиль 'Тигр' [№ 470]\t{FFFFFF}1699 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}8. {ffb841}Грозовой автомобиль 'Урал' [№ 433]\t{FFFFFF}1099 "SERVER_COINS_NAME"",
					"Далее", "Назад"
				);
				return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты.");
			}
			GiveCar(playerid, modelid, 1, 1, -1, -1, 110.8994,322.3508,11.2202,251.4996, gettime());

			AddPlayerData(playerid, P_COINS, -, price);
			UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

			static query[148];
			format(query, sizeof query, "~r~-%s "SERVER_COINS_NAME"", formatInt(price));
			GameText(playerid, query, 3000, 2);
		}
		case DIALOG_COINS_VIP_TABLE:
		{
			if(!response) return ShowCoinsInfo(playerid);

			if(GetPlayerData(playerid, P_COINS) < 399)
			{
				GameText(playerid, "~r~Недостаточно~n~"SERVER_COINS_NAME"", 3000, 2);

				Dialog
				(
					playerid, DIALOG_COINS_VIP_TABLE, DIALOG_STYLE_INPUT,
					"Покупка префикса для VIP-чата",
					"{FFFFFF}Цена префикса для VIP-чата - {ffb841}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}Укажите префикс который хотите приобрести",
					"Далее", "Назад"
				);
				return 1;
			}
			ShowCoinsInfo(playerid), SendClientMessage(playerid, 0x3399FFFF, "* В разработке");
		}
		case DIALOG_COINS_LIST_ACS_CAR:
		{
			if(!response) return ShowCoinsInfo(playerid);

			new modelid, price, indx;

			switch(listitem + 1)
			{
				case 1: modelid = 16229, price = 399, indx = 14;
				case 2: modelid = 15740, price = 399, indx = 15;
				case 3: modelid = 15736, price = 399, indx = 16;
				case 4: modelid = 15874, price = 399, indx = 17;
				case 5: modelid = 15873, price = 399, indx = 20;
				case 6: modelid = 15870, price = 399, indx = 21;
				case 7: modelid = 15737, price = 399, indx = 14;
				case 8: modelid = 15738, price = 399, indx = 15;
				case 9: modelid = 15739, price = 399, indx = 16;
			}

			if(GetPlayerData(playerid, P_COINS) < price)
			{
				GameText(playerid, "~r~Недостаточно~n~"SERVER_COINS_NAME"", 3000, 2);

				Dialog
				(
					playerid, DIALOG_COINS_LIST_ACS_CAR, DIALOG_STYLE_LIST,
					"{FFFFFF}Покупка эксклюзивных аксессуаров на транспорт",
					"{FFFFFF}1. {ffb841}Велосипед на багажник [№ 16229]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}2. {ffb841}Ватрушка на крышу [№ 15740]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}3. {ffb841}Елка на крышу [№ 15736]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}4. {ffb841}Мишка [№ 15874]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}5. {ffb841}Свадебные кольца [№ 15873]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}6. {ffb841}Банки на глушитель [№ 15870]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}7. {ffb841}Сноуборд [№ 15737]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}8. {ffb841}Антены на крышу [№ 15738]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}9. {ffb841}Багажник на крышу [№ 15739]\t{FFFFFF}399 "SERVER_COINS_NAME"",
					"Далее", "Назад"
				);
				return 1;
			}
			if(GetInventorySlots(playerid) == -1) 
			{
				Dialog
				(
					playerid, DIALOG_COINS_LIST_ACS_CAR, DIALOG_STYLE_LIST,
					"{FFFFFF}Покупка эксклюзивных аксессуаров на транспорт",
					"{FFFFFF}1. {ffb841}Велосипед на багажник [№ 16229]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}2. {ffb841}Ватрушка на крышу [№ 15740]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}3. {ffb841}Елка на крышу [№ 15736]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}4. {ffb841}Мишка [№ 15874]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}5. {ffb841}Свадебные кольца [№ 15873]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}6. {ffb841}Банки на глушитель [№ 15870]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}7. {ffb841}Сноуборд [№ 15737]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}8. {ffb841}Антены на крышу [№ 15738]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
					"{FFFFFF}9. {ffb841}Багажник на крышу [№ 15739]\t{FFFFFF}399 "SERVER_COINS_NAME"",
					"Далее", "Назад"
				);
				return SendClientMessage(playerid, 0x3399FFFF, "* В вашем инвентаре нет свободного места.");
			}
			GiveAcs(playerid, modelid, indx);

			AddPlayerData(playerid, P_COINS, -, price);
			UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

			static query[148];
			format(query, sizeof query, "~r~-%s "SERVER_COINS_NAME"", formatInt(price));
			GameText(playerid, query, 3000, 2);
		}
		case DIALOG_COINS_LIST:
		{
			if(!response) return 1;

			switch(listitem + 1)
			{
				case 1: //Покупка игрового уровня
				{
					Dialog
					(
						playerid, DIALOG_COINS_LEVEL, DIALOG_STYLE_INPUT,
						"Покупка игрового уровня",
						"{FFFFFF}Цена игрового уровня за единицу - {ffb841}25 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}Укажите уровень от {ffb841}1 {FFFFFF}до {ffb841}999",
						"Далее", "Назад"
					);
				}
				case 2: //Покупка эксклюзивного транспорта (по id)
				{
					Dialog
					(
						playerid, DIALOG_COINS_CAR, DIALOG_STYLE_INPUT,
						"Покупка эксклюзивного транспорта (по id)",
						"{FFFFFF}Цена эксклюзивного транспорта - {ffb841}1999 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}Укажите id транспорта который хотите приобрести",
						"Далее", "Назад"
					);
				}
				case 3: //Покупка эксклюзивной одежды (по id)
				{
					Dialog
					(
						playerid, DIALOG_COINS_SKIN, DIALOG_STYLE_INPUT,
						"Покупка эксклюзивной одежды (по id)",
						"{FFFFFF}Цена эксклюзивной одежды - {ffb841}1699 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}Укажите id одежды которую хотите приобрести",
						"Далее", "Назад"
					);
				}
				case 4: //Покупка автомобильного номера 'Полицейские'
				{
					Dialog
					(
						playerid, DIALOG_COINS_POLICE_TABLE_1, DIALOG_STYLE_INPUT,
						"Покупка автомобильного номера 'Полицейские'",
						"{FFFFFF}Цена автомобильного номера 'Полицейские' - {ffb841}2199 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}Укажите номер который хотите приобрести {ffb841}(формат: 'A983BT')",
						"Далее", "Назад"
					);
				}
				case 5: //Покупка автомобильного номера 'Такси'
				{
					Dialog
					(
						playerid, DIALOG_COINS_TAXI_TABLE_1, DIALOG_STYLE_INPUT,
						"Покупка автомобильного номера 'Такси'",
						"{FFFFFF}Цена автомобильного номера 'Такси' - {ffb841}2199 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}Укажите номер который хотите приобрести {ffb841}(формат: 'A983BT')",
						"Далее", "Назад"
					);
				}
				case 6: //Покупка транспорта спец. служб
				{
					Dialog
					(
						playerid, DIALOG_COINS_LIST_CAR, DIALOG_STYLE_LIST,
						"{FFFFFF}Покупка транспорта спец. служб",
						"{FFFFFF}1. {ffb841}Танк [№ 432]\t{FFFFFF}4999 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}2. {ffb841}Истрибитель #1 [№ 476]\t{FFFFFF}2999 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}3. {ffb841}Истрибитель #2 [№ 520]\t{FFFFFF}2999 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}4. {ffb841}Вертолет [№ 548]\t{FFFFFF}2199 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}5. {ffb841}БТР-80 [№ 601]\t{FFFFFF}1599 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}6. {ffb841}Грозовой автомобиль 'Камаз' [№ 578]\t{FFFFFF}1099 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}7. {ffb841}Бронеавтомобиль 'Тигр' [№ 470]\t{FFFFFF}1699 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}8. {ffb841}Грозовой автомобиль 'Урал' [№ 433]\t{FFFFFF}1099 "SERVER_COINS_NAME"",
						"Далее", "Назад"
					);
				}
				case 7: //Покупка префикса для VIP-чата
				{
					Dialog
					(
						playerid, DIALOG_COINS_VIP_TABLE, DIALOG_STYLE_INPUT,
						"Покупка префикса для VIP-чата",
						"{FFFFFF}Цена префикса для VIP-чата - {ffb841}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}Укажите префикс который хотите приобрести",
						"Далее", "Назад"
					);
				}
				case 8: //Покупка эксклюзивных аксессуаров на транспорт
				{
					Dialog
					(
						playerid, DIALOG_COINS_LIST_ACS_CAR, DIALOG_STYLE_LIST,
						"{FFFFFF}Покупка эксклюзивных аксессуаров на транспорт",
						"{FFFFFF}1. {ffb841}Велосипед на багажник [№ 16229]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}2. {ffb841}Ватрушка на крышу [№ 15740]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}3. {ffb841}Елка на крышу [№ 15736]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}4. {ffb841}Мишка [№ 15874]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}5. {ffb841}Свадебные кольца [№ 15873]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}6. {ffb841}Банки на глушитель [№ 15870]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}7. {ffb841}Сноуборд [№ 15737]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}8. {ffb841}Антены на крышу [№ 15738]\t{FFFFFF}399 "SERVER_COINS_NAME"\n"\
						"{FFFFFF}9. {ffb841}Багажник на крышу [№ 15739]\t{FFFFFF}399 "SERVER_COINS_NAME"",
						"Далее", "Назад"
					);
				}
			}
		}
		case DIALOG_CARWASH_START:
		{
			if(!response) return 1;

			new i = g_carwash_player_id[playerid];

			new business = GetNearestBusiness(playerid, 18.0);

			if(business == -1) return 1;

			if(!IsPlayerInRangeOfPoint(playerid, 4.5, g_carwash_object_pos[i][0][G_CARWASH_X],g_carwash_object_pos[i][0][G_CARWASH_Y],g_carwash_object_pos[i][0][G_CARWASH_Z])) return 1;

			if(g_carwash_status[i] == 1) return SendClientMessage(playerid, 0xCECECEFF, "* Данная автомойка уже моет");

			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте");

			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), GetBusinessData(business, B_PROD_PRICE))) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);

			GivePlayerMoneyEx(playerid, -GetBusinessData(business, B_PROD_PRICE), "оплата на автомойке");

			AddBusinessProfit(playerid, business, (GetBusinessData(business, B_PROD_PRICE) / 100) * 30, 1);

			g_carwash_object[i][0] = CreateObject(g_carwash_object_pos[i][1][G_CARWASH_ID], g_carwash_object_pos[i][1][G_CARWASH_X],g_carwash_object_pos[i][1][G_CARWASH_Y],g_carwash_object_pos[i][1][G_CARWASH_Z], 0.0, 0.0, 0.0);
			g_carwash_object[i][1] = CreateObject(g_carwash_object_pos[i][2][G_CARWASH_ID], g_carwash_object_pos[i][2][G_CARWASH_X],g_carwash_object_pos[i][2][G_CARWASH_Y],g_carwash_object_pos[i][2][G_CARWASH_Z], 0.0, 0.0, 0.0);
			g_carwash_object[i][2] = CreateObject(g_carwash_object_pos[i][3][G_CARWASH_ID], g_carwash_object_pos[i][3][G_CARWASH_X],g_carwash_object_pos[i][3][G_CARWASH_Y],g_carwash_object_pos[i][3][G_CARWASH_Z], 0.0, 0.0, 0.0);
			g_carwash_object[i][3] = CreateObject(g_carwash_object_pos[i][4][G_CARWASH_ID], g_carwash_object_pos[i][4][G_CARWASH_X],g_carwash_object_pos[i][4][G_CARWASH_Y],g_carwash_object_pos[i][4][G_CARWASH_Z], 0.0, 0.0, 0.0);

			GameText(playerid, "Мойка автомобиля...", 60000, 3);
			freezePlayer(playerid,60);

			SCM(playerid, 0x75A3D2FF, "Сейчас Ваш транспорт будет вымыт. Ожидайте...");

			g_carwash_status[i] = 1;

			SetTimerEx("StopCarWash", 60000, false, "i", playerid);
			return 1;
		}
		
		case DIALOG_CREATE_CODE:
		{
			if(!response) return 1;

			switch(listitem)
			{
				case 0: typecode = 1, Dialog(playerid, DIALOG_NAME_CODE, DIALOG_STYLE_INPUT, "Промокод", "Введите название промокода", "Далее", "Закрыть");
				case 1: typecode = 2, Dialog(playerid, DIALOG_NAME_CODE, DIALOG_STYLE_INPUT, "Бонус-код", "Введите название бонус-кода", "Далее", "Закрыть");		
			}
		}
		case DIALOG_NAME_CODE:
		{
			if(!response) return 1;

			if(strlen(inputtext) < 4)
			{
				if(typecode == 1) Dialog(playerid, DIALOG_NAME_CODE, DIALOG_STYLE_INPUT, "Промокод", "Введите название промокода\n\n{BE2D2D}Название должно состоять минимум из 4 символов", "Далее", "Закрыть");
				if(typecode == 2) Dialog(playerid, DIALOG_NAME_CODE, DIALOG_STYLE_INPUT, "Бонус-код", "Введите название бонус-кода\n\n{BE2D2D}Название должно состоять минимум из 4 символов", "Далее", "Закрыть");
				return 1;
			}

			format(code_name, sizeof(code_name), "%s", inputtext);

			if(typecode == 1) Dialog(playerid, DIALOG_SETTINGS_CODE_1, DIALOG_STYLE_INPUT, "Промокод", "Введите кол-во активаций промокода", "Далее", "Закрыть");
			if(typecode == 2) Dialog(playerid, DIALOG_SETTINGS_CODE_1, DIALOG_STYLE_INPUT, "Бонус-код", "Введите кол-во активаций бонус-кода", "Далее", "Закрыть");
		}
		case DIALOG_SETTINGS_CODE_1:
		{
			if(!response) return 1;

			new count = strval(inputtext);
			if(250 < count || 1 > count)
			{
				if(typecode == 1) Dialog(playerid, DIALOG_SETTINGS_CODE_1, DIALOG_STYLE_INPUT, "Промокод", "Введите кол-во активаций промокода\n\n{BE2D2D}Введите корректное значение: от 1 до 250 активаций", "Далее", "Закрыть");
				if(typecode == 2) Dialog(playerid, DIALOG_SETTINGS_CODE_1, DIALOG_STYLE_INPUT, "Бонус-код", "Введите кол-во активаций бонус-кода\n\n{BE2D2D}Введите корректное значение: от 1 до 250 активаций", "Далее", "Закрыть");
				return 1;
			}

			code_count_activation = count;

			if(typecode == 2) UpdateCodeDialog(playerid);
			if(typecode == 1) Dialog(playerid, DIALOG_TIME_CODE, DIALOG_STYLE_INPUT, "Промокод", "Введите кол-во времени для отыгровки промокода (в минутах)", "Далее", "Закрыть");
		}
		case DIALOG_TIME_CODE:
		{
			if(!response) return 1;

			new count = strval(inputtext);

			if(250 < count || 1 > count)
			{
				Dialog(playerid, DIALOG_TIME_CODE, DIALOG_STYLE_INPUT, "Промокод", "Введите кол-во времени для отыгровки промокода (в минутах)\n\n{BE2D2D}Введите корректное значение: от 1 до 250 минут", "Далее", "Закрыть");
				return 1;
			}
			code_count_time = count;

			UpdateCodeDialog(playerid);
		}
		case DIALOG_SETTINGS_CODE_2:
		{	
			if(!response) return 1;

			if(GetPlayerAdminEx(playerid) < 11 && !SuccessfulAura(playerid)) return 1;
 	    		else if (!SuccessfulAura(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

			switch(listitem + 1)
			{
				case 1: 
				{
					static query[244];
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "");
					for(new i; i < MAX_PRIZES_CODE; i++)
					{
						if(code_additionally[i] != 0)
						{
							if(code_additionally_type[i] == 1) format(query, sizeof query, "\nПриз: Деньги: %s руб", formatInt(code_additionally_count[i]));
							if(code_additionally_type[i] == 2) format(query, sizeof query, "\nПриз: Донат: %s руб", formatInt(code_additionally_count[i]));
							if(code_additionally_type[i] == 3) format(query, sizeof query, "\nПриз: EXP: %d шт", code_additionally_count[i]);
							if(code_additionally_type[i] == 4) format(query, sizeof query, "\nПриз: %s[№%d]: %d шт", ItemsInfo[code_additionally_id[i]][i_item_name], code_additionally_id[i], code_additionally_count[i]);
							if(code_additionally_type[i] == 5) format(query, sizeof query, "\nПриз: Транспорт[№%d]", code_additionally_id[i], code_additionally_count[i]);
							if(code_additionally_type[i] == 6) format(query, sizeof query, "\nПриз: Слоты на бизнес: %d шт", code_additionally_count[i]);
							if(code_additionally_type[i] == 7) format(query, sizeof query, "\nПриз: Слоты на дом: %d шт", code_additionally_count[i]);
							if(code_additionally_type[i] == 8) format(query, sizeof query, "\nПриз: Слоты на гараж: %d шт", code_additionally_count[i]);
							if(code_additionally_type[i] == 9) format(query, sizeof query, "\nПриз: Слоты на авто: %d шт", code_additionally_count[i]);
							if(code_additionally_type[i] == 10) format(query, sizeof query, "\nПриз: Слоты на киоск: %d шт", code_additionally_count[i]);
							if(code_additionally_type[i] == 11) format(query, sizeof query, "\nПриз: Одежда[№%d]", code_additionally_id[i]);
							if(code_additionally_type[i] == 12) format(query, sizeof query, "\nПриз: Аксессуар[№%d]", code_additionally_id[i]);
							if(code_additionally_type[i] == 13 && code_additionally_id[i] == 1) format(query, sizeof query, "\nПриз: Купон на выход из Деморгана (%d мин)", code_additionally_count[i]);
							strcat(STRING_GLOBAL, query);
						}
					}

					if(typecode == 2) DLGF(playerid, DIALOG_SETTINGS_CODE_FINAL, DIALOG_STYLE_MSGBOX, "Информация", "Название: %s\nТип: бонус-код\nКоличество активаций: %d\nПризы:%s\n\nВы действительно хотите создать?", "Создать", "Назад", code_name, code_count_activation, STRING_GLOBAL);
					if(typecode == 1) DLGF(playerid, DIALOG_SETTINGS_CODE_FINAL, DIALOG_STYLE_MSGBOX, "Информация", "Название: %s\nТип: промокод\nВремя отыгровки: %d минут\nКоличество активаций: %d\nПризы: %s\n\nВы действительно хотите создать?", "Создать", "Назад", code_name, code_count_time, code_count_activation, STRING_GLOBAL);
				}
				case 2: 
				{
					if(GetPlayerAdminEx(playerid) < 11 && !SuccessfulAura(playerid)) return 1;
 	    				else if (!SuccessfulAura(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

					for(new i; i < MAX_PRIZES_CODE; i++)
					{
						if(code_additionally[i] != 0) continue;
						Dialog(playerid, DIALOG_SETTINGS_CODE_3, DIALOG_STYLE_LIST, "Создать приз", "1. Деньги\n2. Донат\n3. EXP\n4. Предмет\n5. Транспорт\n6. Слот на бизнес\n7. Слот на дом\n8. Слот на гараж\n9. Слот на авто\n10. Слот на киоски\n11. Одежда\n12. Аксессуар\n13. Купоны","Далее", "Назад");
						return 1;
					}
					UpdateCodeDialog(playerid), SCM(playerid, COLOR_GREY, "* Создано максимальное количество призов.");
				}
				case 3: 
				{
					for(new i; i < MAX_PRIZES_CODE; i++)
					{
						code_additionally[i] = 0;
						code_additionally_type[i] = 0;
						code_additionally_id[i] = 0;
						code_additionally_count[i] = 0;
					}
					UpdateCodeDialog(playerid), SCM(playerid, COLOR_GREY, "* Вы удалили все призы.");
				}
				case 4..10:
				{
					new id[6];
					new count;

					for(new i; i < MAX_PRIZES_CODE; i++)
					{
						if(code_additionally[i] == 0) continue;
						id[count] = i;
						count++;
					}

					code_additionally[id[listitem - 3]] = 0;
					code_additionally_type[id[listitem - 3]] = 0;
					code_additionally_id[id[listitem - 3]] = 0;
					code_additionally_count[id[listitem - 3]] = 0;

					UpdateCodeDialog(playerid), SCM(playerid, COLOR_GREY, "* Вы успешно удалили приз");
				}
			}
		}
		case DIALOG_SETTINGS_CODE_FINAL:
		{
			if(!response) return UpdateCodeDialog(playerid);

			if(GetPlayerAdminEx(playerid) < 11 && !SuccessfulAura(playerid)) return 1;
 	    		else if (!SuccessfulAura(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

			static query[768];
			format(query, sizeof query,
			"INSERT INTO prizes_code (name, count_time, count_activation, type_code,\
			type_prize_1, id_prize_1, count_prize_1,\
			type_prize_2, id_prize_2, count_prize_2,\
			type_prize_3, id_prize_3, count_prize_3,\
			type_prize_4, id_prize_4, count_prize_4,\
			type_prize_5, id_prize_5, count_prize_5,\
			type_prize_6, id_prize_6, count_prize_6,\
			type_prize_7, id_prize_7, count_prize_7,\
			type_prize_8, id_prize_8, count_prize_8,\
			type_prize_9, id_prize_9, count_prize_9)\
			VALUES ('%s', %d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d,\
			%d, %d, %d)",
			code_name, code_count_time * 60, code_count_activation, typecode,
			code_additionally_type[0], code_additionally_id[0], code_additionally_count[0],
			code_additionally_type[1], code_additionally_id[1], code_additionally_count[1],
			code_additionally_type[2], code_additionally_id[2], code_additionally_count[2],
			code_additionally_type[3], code_additionally_id[3], code_additionally_count[3],
			code_additionally_type[4], code_additionally_id[4], code_additionally_count[4],
			code_additionally_type[5], code_additionally_id[5], code_additionally_count[5],
			code_additionally_type[6], code_additionally_id[6], code_additionally_count[6],
			code_additionally_type[7], code_additionally_id[7], code_additionally_count[7],
			code_additionally_type[8], code_additionally_id[8], code_additionally_count[8]);

			mysql_query(mysql, query);

			for(new i; i < MAX_PRIZES_CODE; i++)
			{
				code_additionally[i] = 0;
			}
			if(typecode == 2) SCMF(playerid, COLOR_ORANGE, "Вы успешно создали бонус-код: {BE2D2D}%s", code_name);
			if(typecode == 1) SCMF(playerid, COLOR_ORANGE, "Вы успешно создали промокод: {BE2D2D}%s", code_name);
			code_count_time = 0;
		}
		case DIALOG_SETTINGS_CODE_3:
		{
			if(!response) return UpdateCodeDialog(playerid);

			new prize_code;
			for(new i; i < MAX_PRIZES_CODE; i++)
			{
				if(code_additionally[i] != 0) continue;
				prize_code = i;
				break;
			}

			code_additionally_type[prize_code] = listitem + 1;

			switch(listitem + 1)
			{
				case 1: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Деньги", "Введите кол-во денег", "Далее", "");
				case 2: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Донат", "Введите кол-во доната", "Далее", "");
				case 3: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "EXP", "Введите кол-во EXP", "Далее", "");
				case 4: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Предмет", "Введите id предмета", "Далее", "");
				case 5: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Транспорт", "Введите id автомобиля", "Далее", "");
				case 6: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на бизнес", "Введите кол-во слотов на бизнес", "Далее", "");
				case 7: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на дом", "Введите кол-во слотов на дом", "Далее", "");
				case 8: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на гараж", "Введите кол-во слотов на гараж", "Далее", "");
				case 9: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на авто", "Введите кол-во слотов на авто", "Далее", "");
				case 10: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на киоски", "Введите кол-во слотов на киоски", "Далее", "");
				case 11: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Одежда", "Введите id одежды", "Далее", "");
				case 12: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Аксессуар", "Введите id (объект) аксессуара", "Далее", "");
				case 13: Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_LIST, "Купоны", "Купон на выход из тюрьмы Деморган", "Далее", "");
			}
		}
		case DIALOG_SETTINGS_CODE_4:
		{
			if(!response) return 1;

			new prize_code;
			for(new i; i < MAX_PRIZES_CODE; i++)
			{
				if(code_additionally[i] != 0) continue;
				prize_code = i;
				break;
			}

			new count = strval(inputtext);
			if(code_additionally_type[prize_code] == 5) 
			{
				if(count < 1) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Транспорт", "Введите id автомобиля\n\n{BE2D2D}Вы указали неверный id авто. Доступные авто: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15699, 17400-17409", "Далее", "");
    			if(!(400 <= count <= 614) && (!(699 <= count <= 699) && (!(793 <= count <= 799) && (!(15065 <= count <= 15299) && (!(15600 <= count <= 15699) && (!(17400 <= count <= 17409) && (!(907 <= count <= 909) && (!(965 <= count <= 965) && (!(999 <= count <= 999) && (!(1326 <= count <= 1326)))))))))))
				{
					return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Транспорт", "Введите id автомобиля\n\n{BE2D2D}Вы указали неверный id авто. Доступные авто: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15699, 17400-17409", "Далее", "");
				}
			}
			if(code_additionally_type[prize_code] != 5) 
			{
				switch(code_additionally_type[prize_code])
				{
					case 1: if(500000000 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Деньги", "Введите кол-во денег\n\n{BE2D2D}Введите корректное значение: от 1 до 500.000.000", "Далее", "");
					case 2: if(100000 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Донат", "Введите кол-во доната\n\n{BE2D2D}Введите корректное значение: от 1 до 100.000", "Далее", "");
					case 3: if(100 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "EXP", "Введите кол-во EXP\n\n{BE2D2D}Введите корректное значение: от 1 до 100", "Далее", "");
					case 4: if(500 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Предмет", "Введите id предмета\n\n{BE2D2D}Введите корректное значение", "Далее", "");
					case 6: if(15 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на бизнес", "Введите кол-во слотов на бизнес\n\n{BE2D2D}Введите корректное значение: от 1 до 15", "Далее", "");
					case 7: if(15 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на дом", "Введите кол-во слотов на дом\n\n{BE2D2D}Введите корректное значение: от 1 до 15", "Далее", "");
					case 8: if(15 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на гараж", "Введите кол-во слотов на гараж\n\n{BE2D2D}Введите корректное значение: от 1 до 15", "Далее", "");
					case 9: if(15 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на авто", "Введите кол-во слотов на авто\n\n{BE2D2D}Введите корректное значение: от 1 до 15", "Далее", "");
					case 10: if(15 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Слот на киоски", "Введите кол-во слотов на киоски\n\n{BE2D2D}Введите корректное значение: от 1 до 15", "Далее", "");
					case 11: if(50000 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_4, DIALOG_STYLE_INPUT, "Одежда", "Введите id одежды\n\n{BE2D2D}Введите корректное значение", "Далее", "");
				}
			}
			if(code_additionally_type[prize_code] == 4)
			{
				code_additionally_id[prize_code] = count;
				Dialog(playerid, DIALOG_SETTINGS_CODE_ITEM, DIALOG_STYLE_INPUT, "Предмет", "Введите кол-во предмета", "Далее", "");
			}
			else if(code_additionally_type[prize_code] == 12)
			{
				code_additionally_id[prize_code] = count;
				Dialog(playerid, DIALOG_SETTINGS_CODE_ITEM, DIALOG_STYLE_INPUT, "Аксессуар", "Типы аксессуаров:\n\
				Тип 0 - Очки\n\
				Тип 1 - Бандана\n\
				Тип 2 - Маска\n\
				Тип 3 - Берет\n\
				Тип 4 - Шляпа\n\
				Тип 5 - Сумка\n\
				Тип 6 - Ремень\n\
				Тип 7 - Украшение на руку\n\
				Тип 8 - Рюкзак\n\
				Тип 9 - Украшение на шею\n\
				Тип 10 - Плащ\n\
				Тип 11 - Бронижелет\n\
				Тип 12 - Посох\n\
				Тип 13 - Крылья\n\
				Тип 14 - Украшение на транспорт\n\
				Тип 15 - Украшение на транспорт\n\
				Тип 16 - Украшение на транспорт\n\
				Тип 17 - Украшение на транспорт\n\
				Тип 18 - Скейтборд\n\
				Тип 19 - Украшение на левое плечо\n\n\
				Введите определенный тип аксессуара:", "Далее", "");
			}
			else if(code_additionally_type[prize_code] == 13)
			{
				new type = listitem + 1;

				code_additionally_id[prize_code] = type;

				Dialog(playerid, DIALOG_SETTINGS_CODE_ITEM, DIALOG_STYLE_INPUT, "Купон", "Введите время действия купона (в минутах)", "Далее", "");
			}
			else 
			{
				if(code_additionally_type[prize_code] == 5 || code_additionally_type[prize_code] == 11) code_additionally_id[prize_code] = count;
				else code_additionally_count[prize_code] = count;
				code_additionally[prize_code] = 1;
				UpdateCodeDialog(playerid);
			}
		}
		case DIALOG_SETTINGS_CODE_ITEM:
		{
			if(!response) return 1;

			new prize_code;
			for(new i; i < MAX_PRIZES_CODE; i++)
			{
				if(code_additionally[i] != 0) continue;
				prize_code = i;
				break;
			}

			if(code_additionally_type[prize_code] == 4)
			{
				new count = strval(inputtext);
				if(50 < count || 1 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_ITEM, DIALOG_STYLE_INPUT, "Предмет", "Введите кол-во предмета\n\n{BE2D2D}Введите корректное значение: от 1 до 50", "Далее", "");
			}
			else if(code_additionally_type[prize_code] == 13)
			{
				new count = strval(inputtext);
				if(500 < count || 5 > count) return Dialog(playerid, DIALOG_SETTINGS_CODE_ITEM, DIALOG_STYLE_INPUT, "Купон", "Введите время действия купона (в минутах)\n\n{BE2D2D}Введите корректное значение (от 5 до 500 минут)", "Далее", "");
			}
			code_additionally_count[prize_code] = strval(inputtext);
			code_additionally[prize_code] = 1;
			UpdateCodeDialog(playerid);
		}
		case DIALOG_PROMO_ACTIVATE:
		{
			if(response)
			{
				if(!strlen(inputtext)) return callcmd::pcode(playerid, "");

				static query[256],
					Cache: result,
					rows,
					count_activation,
					count_time,
        			type_prize[9],
					id_prize[9],
					count_prize[9];
				
				mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode_activations WHERE owner_id='%d' AND name='%s'", GetPlayerAccountID(playerid), inputtext);
				result = mysql_query(mysql, query, true);

				rows = cache_num_rows();

				cache_delete(result);

				if(rows) return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,"Ошибка активации","Вы уже активировали данный промокодом","", "Хорошо");

				mysql_format(mysql, query, sizeof query, "SELECT * FROM prizes_code WHERE name='%s' AND count_activation > 0 AND type_code=1", inputtext);
				result = mysql_query(mysql, query, true);

				rows = cache_num_rows();

				if(rows)
				{
					count_activation = cache_get_field_content_int(0, "count_activation");
					count_time = cache_get_field_content_int(0, "count_time");

					type_prize[0] = cache_get_field_content_int(0, "type_prize_1");
					id_prize[0] = cache_get_field_content_int(0, "id_prize_1");
					count_prize[0] = cache_get_field_content_int(0, "count_prize_1");

					type_prize[1] = cache_get_field_content_int(0, "type_prize_2");
					id_prize[1] = cache_get_field_content_int(0, "id_prize_2");
					count_prize[1] = cache_get_field_content_int(0, "count_prize_2");

					type_prize[2] = cache_get_field_content_int(0, "type_prize_3");
					id_prize[2] = cache_get_field_content_int(0, "id_prize_3");
					count_prize[2] = cache_get_field_content_int(0, "count_prize_3");

					type_prize[3] = cache_get_field_content_int(0, "type_prize_4");
					id_prize[3] = cache_get_field_content_int(0, "id_prize_4");
					count_prize[3] = cache_get_field_content_int(0, "count_prize_4");

					type_prize[4] = cache_get_field_content_int(0, "type_prize_5");
					id_prize[4] = cache_get_field_content_int(0, "id_prize_5");
					count_prize[4] = cache_get_field_content_int(0, "count_prize_5");

					type_prize[5] = cache_get_field_content_int(0, "type_prize_6");
					id_prize[5] = cache_get_field_content_int(0, "id_prize_6");
					count_prize[5] = cache_get_field_content_int(0, "count_prize_6");

					type_prize[6] = cache_get_field_content_int(0, "type_prize_7");
					id_prize[6] = cache_get_field_content_int(0, "id_prize_7");
					count_prize[6] = cache_get_field_content_int(0, "count_prize_7");

					type_prize[7] = cache_get_field_content_int(0, "type_prize_8");
					id_prize[7] = cache_get_field_content_int(0, "id_prize_8");
					count_prize[7] = cache_get_field_content_int(0, "count_prize_8");

					type_prize[8] = cache_get_field_content_int(0, "type_prize_9");
					id_prize[8] = cache_get_field_content_int(0, "id_prize_9");
					count_prize[8] = cache_get_field_content_int(0, "count_prize_9");
				}
				cache_delete(result);

				if(!rows) return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,"Ошибка активации","Данный промокод не найден","", "Хорошо");

				if(count_activation > 0)
				{
					mysql_format(mysql, query, sizeof query, "UPDATE prizes_code SET count_activation='%d' WHERE name='%s'", count_activation - 1, inputtext);
					mysql_query(mysql, query, false);

					CreatePlayerPromo(playerid, inputtext, count_time);

					SCMF(playerid, 0x66CC33FF, "{ffff00}Вы активировали промокод \"%s\"", inputtext);
					SCM(playerid, COLOR_GREY, "* Примечание: бонусы выдаются во время зарплаты");

					string_dialog[0] = EOS;

					for(new i; i < MAX_PRIZES_CODE; i++)
					{	
						if(type_prize[i] == 1) format(query, sizeof query, "{FFFFFF}- %s рублей\n", formatInt(count_prize[i])),strcat(string_dialog, query);

						if(type_prize[i] == 2) format(query, sizeof query, "{FFFFFF}- %s донат-монет\n", formatInt(count_prize[i])),strcat(string_dialog, query);

						if(type_prize[i] == 3) format(query, sizeof query, "{FFFFFF}- Игровой опыт в количестве %d шт.\n", count_prize[i]),strcat(string_dialog, query);

						if(type_prize[i] == 4) format(query, sizeof query, "{FFFFFF}- %s в количестве %d шт.\n", ItemsInfo[id_prize[i]][i_item_name], count_prize[i]),strcat(string_dialog, query);

						if(type_prize[i] == 5) format(query, sizeof query, "{FFFFFF}- %s [№%d]\n", GetVehicleInfo(id_prize[i], VI_NAME), id_prize[i]),strcat(string_dialog, query);
				
						if(type_prize[i] == 6) format(query, sizeof query, "{FFFFFF}- Слот на бизнес в количестве %d шт.\n", count_prize[i]),strcat(string_dialog, query);

						if(type_prize[i] == 7) format(query, sizeof query, "{FFFFFF}- Слот на дом в количестве %d шт.\n", count_prize[i]),strcat(string_dialog, query);
					
						if(type_prize[i] == 8) format(query, sizeof query, "{FFFFFF}- Слот на гараж в количестве %d шт.\n", count_prize[i]),strcat(string_dialog, query);
					
						if(type_prize[i] == 9) format(query, sizeof query, "{FFFFFF}- Слот на транспорт в количестве %d шт.\n", count_prize[i]),strcat(string_dialog, query);

						if(type_prize[i] == 10) format(query, sizeof query, "{FFFFFF}- Слот на киоск в количестве %d шт.\n", count_prize[i]),strcat(string_dialog, query);
				
						if(type_prize[i] == 11) format(query, sizeof query, "{FFFFFF}- Одежда[№%d]\n", id_prize[i]),strcat(string_dialog, query);
					
						if(type_prize[i] == 12) format(query, sizeof query, "{FFFFFF}- Аксессуар[№%d]\n", id_prize[i]),strcat(string_dialog, query);

						if(type_prize[i] == 13 && id_prize[i] == 1) format(query, sizeof query, "{FFFFFF}- Купон на выход из Деморгана (%d мин)\n", count_prize[i]),strcat(string_dialog, query);
					}

					format
					(
						string_dialog, sizeof string_dialog, 
						"{bebfba}Вы активировали промокод \'%s\'\n\
						{FFFFFF}После {6cbbea}%02d {FFFFFF}минут игры на сервере (не AFK), Вы получите:\n\n\
						%s\n\
						Примечание: призы выдаются во время отыгранной зарплаты\n\n\
						Успейте выполнить все условия для получения награды",
						inputtext, floatround(count_time / 60), string_dialog
					);
					Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFFFFF}Активация промокода", string_dialog,"", "Хорошо");

				}
				else return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,"Ошибка активации","{bebfba}Достигнут лимит использований промокода","", "Хорошо");
			}
		}
        case DIALOG_BONUSCODE_ACTIVATE:
		{
			if(!response) return 1;
			if(!strlen(inputtext)) return Dialog(playerid, DIALOG_BONUSCODE_ACTIVATE, DIALOG_STYLE_INPUT,"Активация бонус кода","Введите ваш бонус код в поле ниже","Далее", "Отмена");
			static query[256],
				Cache: result,
				rows,
				count_activation,
				type_code,
				type_prize[9],
				id_prize[9],
				count_prize[9];
			format(query, sizeof query, "SELECT * FROM promocode_activations WHERE owner_id='%d' AND name='%s'", GetPlayerAccountID(playerid), inputtext);
			result = mysql_query(mysql, query, true);
			rows = cache_num_rows();
			cache_delete(result);
			if(rows) return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,"Ошибка активации","Вы уже активировали данный бонус код","", "Хорошо");
			format(query, sizeof query, "SELECT * FROM prizes_code WHERE name='%s' AND count_activation > 0 AND type_code=2", inputtext);
			result = mysql_query(mysql, query, true);
			rows = cache_num_rows();
			if(rows)
   			{
   			count_activation = cache_get_field_content_int(0, "count_activation");
   			type_code = cache_get_field_content_int(0, "type_code");

   			type_prize[0] = cache_get_field_content_int(0, "type_prize_1");
   			id_prize[0] = cache_get_field_content_int(0, "id_prize_1");
   			count_prize[0] = cache_get_field_content_int(0, "count_prize_1");

   			type_prize[1] = cache_get_field_content_int(0, "type_prize_2");
   			id_prize[1] = cache_get_field_content_int(0, "id_prize_2");
   			count_prize[1] = cache_get_field_content_int(0, "count_prize_2");

   			type_prize[2] = cache_get_field_content_int(0, "type_prize_3");
   			id_prize[2] = cache_get_field_content_int(0, "id_prize_3");
   			count_prize[2] = cache_get_field_content_int(0, "count_prize_3");

   			type_prize[3] = cache_get_field_content_int(0, "type_prize_4");
    		id_prize[3] = cache_get_field_content_int(0, "id_prize_4");
   			count_prize[3] = cache_get_field_content_int(0, "count_prize_4");

   			type_prize[4] = cache_get_field_content_int(0, "type_prize_5");
   			id_prize[4] = cache_get_field_content_int(0, "id_prize_5");
   			count_prize[4] = cache_get_field_content_int(0, "count_prize_5");

   			type_prize[5] = cache_get_field_content_int(0, "type_prize_6");
   			id_prize[5] = cache_get_field_content_int(0, "id_prize_6");
   			count_prize[5] = cache_get_field_content_int(0, "count_prize_6");

       		type_prize[6] = cache_get_field_content_int(0, "type_prize_7");
       		id_prize[6] = cache_get_field_content_int(0, "id_prize_7");
       		count_prize[6] = cache_get_field_content_int(0, "count_prize_7");

   			type_prize[7] = cache_get_field_content_int(0, "type_prize_8");
   			id_prize[7] = cache_get_field_content_int(0, "id_prize_8");
   			count_prize[7] = cache_get_field_content_int(0, "count_prize_8");

   			type_prize[8] = cache_get_field_content_int(0, "type_prize_9");
   			id_prize[8] = cache_get_field_content_int(0, "id_prize_9");
    		count_prize[8] = cache_get_field_content_int(0, "count_prize_9");
			}
			cache_delete(result);
			if(type_code == 1) return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,"Ошибка активации","Данный бонус код не найден","", "Хорошо");
			if(!rows) Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,"Ошибка активации","Данный бонус код не найден","", "Хорошо");
			mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode_activations WHERE owner_id='%d' AND name='%s'", GetPlayerAccountID(playerid), inputtext);
			result = mysql_query(mysql, query, true);
			rows = cache_num_rows();
			if(count_activation > 0)
			{
				mysql_format(mysql, query, sizeof query, "UPDATE prizes_code SET count_activation='%d' WHERE name='%s'", count_activation - 1, inputtext);
				mysql_query(mysql, query, false);
				mysql_format(mysql, query, sizeof query, "INSERT INTO promocode_activations (owner_id, name, time, type, status) VALUES (%d, '%s', 0, 0, 2)", GetPlayerAccountID(playerid), inputtext);
				mysql_query(mysql, query, false);
				string_dialog[0] = EOS;
				for(new i; i < MAX_PRIZES_CODE; i++)
				{	
					if(type_prize[i] == 1) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Деньги: %d руб {3599f5}за активацию бонус кода", count_prize[i]),
						GivePlayerMyPrizes(playerid, "Деньги", 5, 0, 0, count_prize[i], 0),
						format(query, sizeof query, "{FFFFFF}- %s рублей\n", formatInt(count_prize[i])),
						strcat(string_dialog, query);
					if(type_prize[i] == 2) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Донат: %d руб {3599f5}за активацию бонус кода", count_prize[i]),
						GivePlayerMyPrizes(playerid, "Донат", 10, 0, 0, count_prize[i], 0),
						format(query, sizeof query, "{FFFFFF}- %s донат-монет\n", formatInt(count_prize[i])),
						strcat(string_dialog, query);
					if(type_prize[i] == 3) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}%d EXP {3599f5}за активацию бонус кода", count_prize[i]),
						GivePlayerExp(playerid, count_prize[i]),
						format(query, sizeof query, "{FFFFFF}- Игровой опыт в количестве %d шт.\n", count_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 4) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}%s в количестве %d шт. {3599f5}за активацию бонус кода",ItemsInfo[id_prize[i]][i_item_name], count_prize[i]),
						format(query, sizeof query, "%s", ItemsInfo[id_prize[i]][i_item_name]),
						GivePlayerMyPrizes(playerid, query, 8, id_prize[i], 0, count_prize[i], 0),
						format(query, sizeof query, "{FFFFFF}- %s в количестве %d шт.\n", ItemsInfo[id_prize[i]][i_item_name], count_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 5) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}%s {3599f5}за активацию бонус кода", GetVehicleInfo(id_prize[i], VI_NAME)),
						format(query, sizeof query, "%s[№%d]", GetVehicleInfo(id_prize[i], VI_NAME), id_prize[i]),
						GivePlayerMyPrizes(playerid, query, 3, id_prize[i], 0, 1, -1),
						format(query, sizeof query, "{FFFFFF}- %s [№%d]\n", GetVehicleInfo(id_prize[i], VI_NAME), id_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 6) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Слот на бизнес в количестве %d шт. {3599f5}за активацию бонус кода", count_prize[i]),
						AddPlayerData(playerid, P_BIZ_SLOTS, +, count_prize[i]),
						UpdatePlayerDatabaseInt(playerid, "biz_slots", GetPlayerData(playerid, P_BIZ_SLOTS)),
						format(query, sizeof query, "{FFFFFF}- Слот на бизнес в количестве %d шт.\n", count_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 7) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Слот на дом в количестве %d шт. {3599f5}за активацию бонус кода", count_prize[i]),
						AddPlayerData(playerid, P_HOUSE_SLOTS, +, count_prize[i]),
						UpdatePlayerDatabaseInt(playerid, "house_slots", GetPlayerData(playerid, P_HOUSE_SLOTS)),
						format(query, sizeof query, "{FFFFFF}- Слот на дом в количестве %d шт.\n", count_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 8) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Слот на гараж в количестве %d шт. {3599f5}за активацию бонус кода", count_prize[i]),
						AddPlayerData(playerid, P_GARAGE_SLOTS, +, count_prize[i]),
						UpdatePlayerDatabaseInt(playerid, "garage_slots", GetPlayerData(playerid, P_GARAGE_SLOTS)),
						format(query, sizeof query, "{FFFFFF}- Слот на гараж в количестве %d шт.\n", count_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 9) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Слот на транспорт в количестве %d шт. {3599f5}за активацию бонус кода", count_prize[i]),
						AddPlayerData(playerid, P_CAR_SLOTS, +, count_prize[i]),
						UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS)),
						format(query, sizeof query, "{FFFFFF}- Слот на транспорт в количестве %d шт.\n", count_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 10) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Слот на киоск в количестве %d шт. {3599f5}за активацию бонус кода", count_prize[i]),
						AddPlayerData(playerid, P_KIOSK_SLOTS, +, count_prize[i]),
						UpdatePlayerDatabaseInt(playerid, "kiosk_slots", GetPlayerData(playerid, P_KIOSK_SLOTS)),
						format(query, sizeof query, "{FFFFFF}- Слот на киоск в количестве %d шт.\n", count_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 11)
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Одежда[№%d] {3599f5}за активацию бонус кода", id_prize[i]),
						format(query, sizeof query, "Одежда[№%d]", id_prize[i]),
						GivePlayerMyPrizes(playerid, query, 4, id_prize[i], 0, 1, 0),
						format(query, sizeof query, "{FFFFFF}- Одежда[№%d]\n", id_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 12) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Аксессуар[№%d] {3599f5}за активацию бонус кода", id_prize[i]),
						format(query, sizeof query, "Аксессуар[№%d]", id_prize[i]),
						GivePlayerMyPrizes(playerid, query, 6, id_prize[i], 0, 1, count_prize[i]),
						format(query, sizeof query, "{FFFFFF}- Аксессуар[№%d]\n", id_prize[i]),
						strcat(string_dialog, query);
					if(type_prize[i] == 13 && id_prize[i] == 1) 
						SCMF(playerid, 0x3599f5FF, "Вам начислен приз {FFFFFF}Купон на выход из Тюрьма (%d мин) {3599f5}за активацию бонус кода", count_prize[i]),
						format(query, sizeof query, "Купон для выхода из тюрьмы Тюрьма (%d мин)", count_prize[i]),
						GivePlayerMyPrizes(playerid, query, 16, count_prize[i], 0, 0, 0),
						format(query, sizeof query, "{FFFFFF}- Купон для выхода из Тюрьма (%d мин)\n", count_prize[i]),
						strcat(string_dialog, query);
				}
				format
				(
					string_dialog, sizeof string_dialog, 
					"{bebfba}Вы успешно активировали бонус код и получили:\n\n\
					%s",
					string_dialog
				);
				Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Успешная активация", string_dialog,"", "Хорошо");
			}
			else Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,"Ошибка активации","{bebfba}Достигнут лимит использований бонус кода","", "Хорошо");
			return 1;
		}

		case DIALOG_OWNABLE_GARAGE_OPLATA:
		{
			if(!response) return 1;

			new idx = GetPlayerListitemValue(playerid, listitem) + 1;
			SetPVarInt(playerid, "ownablegarage_id", idx);
			ShowPlayerGaragePayForRent(playerid);
		}

		case DIALOG_SELL_GARAGE_LIST:
		{
			if(!response) return 1;
			new idx = GetPlayerListitemValue(playerid, listitem) + 1;
			SetPVarInt(playerid, "ownablegarage_id", idx);

			new garage_id = GetPVarInt(playerid, "ownablegarage_id");
			if(garage_id != -1)
			{
				Dialog
				(
					playerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_MSGBOX,
					"{FFD83D}Продажа гаража",
					"{"#cW"}Вы уверены что хотите продать свой гараж государству?\n\n"\
					"Вам будет возвращена его стоимость за вычитом 30%\n"\
					"Также будет возвращено 60% от стоимости купленных улучшений\n\n"\
					"Если Вы хотите продать бизнес другому игроку,\n"\
					"используйте команду: {FFD83D}/sellmygarage",
					"Да", "Нет"
				);
			}
			else SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет гаража");
			return 1;
		}

		case DIALOG_INFO_GARAGE_LIST:
		{
			if(!response) return 1;
			new idx = GetPlayerListitemValue(playerid, listitem) + 1;
			SetPVarInt(playerid, "ownablegarage_id", idx);

			new garage_id = GetPVarInt(playerid, "ownablegarage_id");

			if(garage_id != -1)
			{
				string_dialog[0] = EOS;

				format
				(
					string_dialog, sizeof string_dialog,
					"{ffffff}Номер гаража:<t><t><t>%d\n",
					garage_id
				);

				format
				(
					string_dialog, sizeof string_dialog,
					"{ffffff}Владелец:<t><t><t><t>{339999}%s\n"\
					"%s{ffffff}Город / поселок:\t\t\t%s\n"\
					"Район:\t\t\t\t\t%s\n"\
					"Уровень улучшений:<t><t><t>%d\n"\
					"Гараж оплачен на:<t><t><t>%d/14 дней\n"\
					"Гос. стоимость:<t><t><t>%s\n"\
					"Арендная плата:<t><t><t>%d руб в день\n"\
					"Статус:<t><t><t><t><t>%s\n\n"\
					"{669966}Для открытия панели управления Вашим гаражом\n"\
					"нажмите кнопку 'Изменить'",
					GetGarageData(garage_id, G_OWNER_NAME),
					string_dialog,
					GetCityName(GetGarageData(garage_id, G_CITY)),
					GetZoneName(GetGarageData(garage_id, G_ZONE)),
					GetGarageData(garage_id, G_IMPROVEMENTS),
					GetGarageData(garage_id, G_RENT_DATE) <= gettime() ? 0 :
					GetElapsedTime(GetGarageData(garage_id, G_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
					formatInt(GetGarageData(garage_id, G_PRICE)),
					GetGarageData(garage_id, G_IMPROVEMENTS) > 0 ? (GetGarageData(garage_id, G_RENT_PRICE) / 2) : (GetGarageData(garage_id, G_RENT_PRICE)),
					GetGarageData(garage_id, G_LOCK_STATUS) ? ("{CC3333}Гараж закрыт") : ("{66CC33}Гараж открыт")
				);
				Dialog(playerid, DIALOG_GARAGE_INFO, DIALOG_STYLE_MSGBOX, "{FFD83D}Информация о гараже", string_dialog, "Изменить", "Отмена");
			}
			else SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет гаража");
			return 1;
		}

		case DIALOG_SELL_MY_GARAGE_LIST:
		{
			if(!response) return 1;
			new idx = GetPlayerListitemValue(playerid, listitem) + 1;
			SetPVarInt(playerid, "ownablegarage_id", idx);

			new garageid = GetPVarInt(playerid, "ownablegarage_id");

			new price = GetPVarInt(playerid, "Sellprice");
			new to_player = GetPVarInt(playerid, "to_player");

			new Float: g_pos_x = GetGarageData(garageid, G_POS_X);
			new Float: g_pos_y = GetGarageData(garageid, G_POS_Y);
			new Float: g_pos_z = GetGarageData(garageid, G_POS_Z);

			if(!(IsPlayerInRangeOfPoint(playerid, 7.0, g_pos_x, g_pos_y, g_pos_z) && IsPlayerInRangeOfPoint(to_player, 7.0, g_pos_x, g_pos_y, g_pos_z)))
				SendClientMessage(playerid, 0xFF6600FF, "* Вы и покупатель должны находиться рядом с бизнесом который хотите продать");

			SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_GARAGE, garageid, price);

			return 1;
		}
		case DIALOG_CREATE_FAMILY:
            {
                if(!response) return 1;

                if(GetPlayerData(playerid, P_FAMILY) != 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы уже состоите в семье");
                if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 50000000))
                {
                    new str_len = strlen(inputtext);
					if(6 <= str_len <= 36)
					{
	                    static query[512],
	                        Cache: result,
	                        rows;

	                    mysql_format(mysql, query, sizeof query, "SELECT * FROM family WHERE name='%s'", inputtext);
	                    result = mysql_query(mysql, query, true);
	                    rows = cache_num_rows();
	                    cache_delete(result);

	                    if(rows)
	                    {
	                        SendClientMessage(playerid, 0xCECECEFF, "* Данное имя уже используется");
						    Dialog
						    (
						        playerid, DIALOG_CREATE_FAMILY, DIALOG_STYLE_INPUT,
						        "Создание семьи",
						        "{999999}- Цена: 50.000.000 рублей<n>\
								{999999}- Только русские и английские символы<n>\
								{999999}- Используйте от 6 до 36 символов<n>\
								{FFFFFF}Введите название Вашей семьи",
						        "Создать", "Отмена"
						    );
	                        return 1;
	                    }
	                    GivePlayerMoneyEx(playerid, -50000000, "Создание семьи",true,true);
	                    SendClientMessage(playerid, 0x66CC00FF, "* Вы успешно создали семью! {"#cGold"}Используйте /fmenu для информации.");

	                    new time = gettime();
	                    mysql_format
	                    (
	                        mysql, query, sizeof query,
	                        "INSERT INTO family "\
	                            "(name,u_id,time) "\
	                            "VALUES "\
	                            "('%e',%d,%d)",
	                        inputtext,
	                        GetPlayerAccountID(playerid),
	                        time
	                    );
	                    result = mysql_query(mysql, query);

	                    new fam_id = cache_insert_id();

	                    SetPlayerData(playerid, P_FAMILY, fam_id);
	                    SetPlayerData(playerid, P_FAMILY_RANK, 10);

	                    format(query, sizeof query, "UPDATE PlayersMorallwens SET family=%d, family_rank=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_FAMILY), GetPlayerData(playerid, P_FAMILY_RANK), GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

	                    SetFamilyData(fam_id, F_SQL_ID, fam_id);
	                    format(g_family[fam_id][F_NAME], 64, "%s", inputtext);
						new text_str[144];
						format(text_str, 144, "{FFB500}%s", inputtext);
						g_player[playerid][P_FAM_LABEL] = CreateDynamic3DTextLabel(text_str, -1, 0.0, 0.0, 0.6, 14.0, playerid, INVALID_VEHICLE_ID, 1);
						
						new
							hour, minute,second,
							day, month, year;

						gettime(hour, minute,second);
						getdate(year, month, day);

	                    SetFamilyData(fam_id, F_TIME_DAY, day);
	                    SetFamilyData(fam_id, F_TIME_MOUNTH, month);
	                    SetFamilyData(fam_id, F_TIME_YEAR, year);

	                    SetFamilyData(fam_id, F_TIME_HOUR, hour);
	                    SetFamilyData(fam_id, F_TIME_MINUTE, minute);
	                    SetFamilyData(fam_id, F_TIME_SECOND, second);

	                    format(query, sizeof query, "UPDATE family SET day=%d, mounth=%d,year=%d,hour=%d,minute=%d,second=%d WHERE id=%d LIMIT 1", day,month,year,hour,minute,second, g_family[fam_id][F_SQL_ID]);
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
	                    mysql_format(mysql, query, sizeof query, "UPDATE family SET rank1='%e', rank2='%e' WHERE id=%d LIMIT 1",
						GetFamilyData(fam_id, F_RANK1),GetFamilyData(fam_id, F_RANK2), g_family[fam_id][F_SQL_ID]);
						mysql_query(mysql, query, false);

						mysql_format(mysql, query, sizeof query, "UPDATE family SET rank3='%e', rank4='%e' WHERE id=%d LIMIT 1",
						GetFamilyData(fam_id, F_RANK3),GetFamilyData(fam_id, F_RANK4), g_family[fam_id][F_SQL_ID]);
						mysql_query(mysql, query, false);

						mysql_format(mysql, query, sizeof query, "UPDATE family SET rank5='%e', rank6='%e' WHERE id=%d LIMIT 1",
						GetFamilyData(fam_id, F_RANK5),GetFamilyData(fam_id, F_RANK6), g_family[fam_id][F_SQL_ID]);
						mysql_query(mysql, query, false);

						mysql_format(mysql, query, sizeof query, "UPDATE family SET rank7='%e',rank8='%e' WHERE id=%d LIMIT 1",
						GetFamilyData(fam_id, F_RANK7),GetFamilyData(fam_id, F_RANK8), g_family[fam_id][F_SQL_ID]);
						mysql_query(mysql, query, false);

						mysql_format(mysql, query, sizeof query, "UPDATE family SET rank9='%e', rank10='%e' WHERE id=%d LIMIT 1",
						GetFamilyData(fam_id, F_RANK9),GetFamilyData(fam_id, F_RANK10), g_family[fam_id][F_SQL_ID]);
						mysql_query(mysql, query, false);
						g_family_loaded ++;
						cache_delete(result);
					}
					else
					{
					    SendClientMessage(playerid, 0xCECECEFF, "* Кол-во символов от 6 до 36!");
					    Dialog
					    (
					        playerid, DIALOG_CREATE_FAMILY, DIALOG_STYLE_INPUT,
					        "Создание семьи",
					        "{999999}- Цена: 50.000.000 рублей<n>\
							{999999}- Только русские и английские символы<n>\
							{999999}- Используйте от 6 до 36 символов<n>\
							{FFFFFF}Введите название Вашей семьи",
					        "Создать", "Отмена"
					    );
					}
                }
                else SendClientMessage(playerid, 0xCECECEFF, "* *У Вас недостаточно денег");
            }
			case DIALOG_COLOR_GANG_CR:
			{
			    if(!response) return 1;

			    new fam_id = GetPlayerData(playerid, P_FAMILY),
					fmt_text[556];

			    SetFamilyData(fam_id, F_COLOR, list_id);
                SetFamilyData(fam_id, F_GANG, 1);
                SetFamilyData(fam_id, F_FAMILY_CARS, 10);
				SetFamilyData(fam_id, F_HOUSE_ID,GetPlayerHouse(playerid));
                mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET color='%d',gang=1,house_id=%d,family_cars=10 WHERE id='%d' LIMIT 1", list_id,GetPlayerHouse(playerid), fam_id);
				mysql_query(mysql, fmt_text, false);
				foreach(new i : Player)
				{
					if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					if(GetPlayerData(i, P_FAMILY) == GetPlayerData(playerid, P_FAMILY))
					{
						DestroyDynamic3DTextLabel(g_player[i][P_FAM_LABEL]);
						g_player[i][P_FAM_LABEL] = Text3D: -1;
						SetPlayerColorEx(i, family_colors[GetFamilyData(GetPlayerData(i, P_FAMILY), F_COLOR)]);
						new text_str[144];
						format(text_str, 144, "{%06x}%s", family_colors[GetFamilyData(GetPlayerData(i, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerFamily(i)][F_NAME]);
						g_player[i][P_FAM_LABEL] = CreateDynamic3DTextLabel(text_str, -1, 0.0, 0.0, 0.6, 14.0, i, INVALID_VEHICLE_ID, 1);
					}
				}
		        new houseid = GetFamilyData(fam_id, F_HOUSE_ID);
		        new type = GetHouseData(houseid, H_TYPE);
				DestroyPickup(gangsklads[fam_id]);
				if(IsValidDynamic3DTextLabel(GetFamilyData(fam_id, F_SKLAD))) DestroyDynamic3DTextLabel(GetFamilyData(fam_id, F_SKLAD));
		        gangsklads[fam_id] = CreatePickup(1239, 23, GetHouseTypeInfo(type, HT_SKLAD_POS_X), GetHouseTypeInfo(type, HT_SKLAD_POS_Y), GetHouseTypeInfo(type, HT_SKLAD_POS_Z), houseid + 2000, PICKUP_ACTION_TYPE_SKLAD);

				SetFamilyData(fam_id, F_SKLAD, CreateDynamic3DTextLabel("", 0xFFFF00FF, GetHouseTypeInfo(type, HT_SKLAD_POS_X), GetHouseTypeInfo(type, HT_SKLAD_POS_Y), GetHouseTypeInfo(type, HT_SKLAD_POS_Z) + 1, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseid + 2000, -1, -1, 50.0));
				CallLocalFunction("UpdateGangSklad", "i", fam_id);

				format(fmt_text, sizeof fmt_text, "<%s> Ваша семья стала бандой! База находится в доме №%d", GetFamilyData(fam_id, F_NAME), GetFamilyData(fam_id, F_HOUSE_ID));
				SendClientMessage(playerid, 0xFF9C18FF, fmt_text);
			}
            case DIALOG_FAMILY_FFF:
            {
                callcmd::fmenu(playerid, "");
            }
            case DIALOG_FAMILY_MENU:
            {
                if(!response) return 1;

                switch(listitem)
                {
                    case 0:
                    {
						static fmt_text[78],fmt_texts[30],
							list[sizeof fmt_text * 10 + 50] = "{ffffff}Имя<t>{ffffff}Телефон<n>";
						new pl,afk;
						foreach(new i : Player)
						{
							if(!IsPlayerConnected(i)) continue;
							else if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == GetPlayerData(playerid, P_FAMILY))
							{
							    static namerank[40];
							    new fam_id = GetPlayerData(playerid, P_FAMILY);
							    new rank = GetPlayerData(i, P_FAMILY_RANK);
							    pl = pl+1;
							    if(IsPlayerAFK(i))
							    {
							        afk = afk +1;
							    }
							    if(rank == 1) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK1));
							    if(rank == 2) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK2));
							    if(rank == 3) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK3));
							    if(rank == 4) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK4));
							    if(rank == 5) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK5));
							    if(rank == 6) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK6));
							    if(rank == 7) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK7));
							    if(rank == 8) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK8));
							    if(rank == 9) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK9));
							    if(rank == 10) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK10));
								format(fmt_text, sizeof fmt_text, "1. %s[%d] {e65050}[%s]{ffffff}<t>%d<n>", GetPlayerNameEx(i), i, namerank,GetPlayerPhone(i));
								strcat(list, fmt_text);
								format(fmt_texts, sizeof fmt_texts, "{FFCD00}В игре: %d (%d в AFK)",pl,afk);
							}
						}

						Dialog(playerid, DIALOG_FAMILY_FFF, 5, fmt_texts, list, "Назад", "");
                    }
                    case 1:
                    {
						static query[144],
							text[1440],
							Cache: result,
							rows;
						mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE family='%d'", GetPlayerData(playerid, P_FAMILY));
						result = mysql_query(mysql, query);
						rows = cache_num_rows();

						for(new i = 0; i < rows; i++)
						{
							new name[21];

							cache_get_field_content(i, "name", name);
							new user_id = cache_get_field_content_int(i, "id");
							format(query, sizeof query, "%d. %s<n>", i+1, name);
							strcat(text, query);
							SetPlayerListitemValue(playerid, i, user_id);
						}

						cache_delete(result);

						Dialog(playerid, DIALOG_FAMILY_PL, DIALOG_STYLE_LIST, "{FFCD00}Состав семьи", text, "Выгнать", "Отмена");
                    }
                    case 2: ShowFamilyInfo(playerid);
                    case 3:
                    {
					 	if(IsPlayerInRangeOfPoint(playerid, 35.0, 300.5571,304.2417,1001.0000)) //300.5571,304.2417,1001.0000
						{
							Dialog(playerid, DIALOG_FAMILY_BANK, DIALOG_STYLE_LIST, "{FFCD00}Бюджет семьи", "1. Пополнить<n>2. Снять<n>3. История", "Принять", "Отмена");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* *Вы не в банке");
                    }
                }
            }
            case DIALOG_GANG_MENU:
            {
                if(!response) return 1;
                switch(listitem)
                {
                    case 0:
                    {
						static fmt_text[78], fmt_texts[30];
						string_dialog = "{ffffff}Имя<t>{ffffff}Телефон<n>";
						new pl,afk;
						foreach(new i : Player)
						{
							if(!IsPlayerConnected(i)) continue;
							else if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == GetPlayerData(playerid, P_FAMILY))
							{
							    static namerank[40];
							    new fam_id = GetPlayerData(playerid, P_FAMILY);
							    new rank = GetPlayerData(i, P_FAMILY_RANK);
							    pl = pl+1;

							    if(IsPlayerAFK(i)) afk = afk +1;

							    if(rank == 1) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK1));
							    if(rank == 2) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK2));
							    if(rank == 3) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK3));
							    if(rank == 4) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK4));
							    if(rank == 5) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK5));
							    if(rank == 6) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK6));
							    if(rank == 7) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK7));
							    if(rank == 8) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK8));
							    if(rank == 9) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK9));
							    if(rank == 10) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK10));

							    if(IsPlayerAFK(i)) format(fmt_text, sizeof fmt_text, "%d. %s[%d](AFK) {e65050}[%s]{ffffff}<t>%d<n>", pl,GetPlayerNameEx(i), i, namerank,GetPlayerPhone(i));
								else format(fmt_text, sizeof fmt_text, "%d. %s[%d] {e65050}[%s]{ffffff}<t>%d<n>", pl,GetPlayerNameEx(i), i, namerank,GetPlayerPhone(i));

								strcat(string_dialog, fmt_text);
								format(fmt_texts, sizeof fmt_texts, "{FFCD00}В игре: %d (%d в AFK)",pl,afk);
							}
						}
						Dialog(playerid, DIALOG_FAMILY_FFF, 5, fmt_texts, string_dialog, "Назад", "");
                    }
                    case 1:
                    {
						string_dialog[0] = EOS;
						static query[144], Cache: result, rows;
						mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE family='%d'", GetPlayerData(playerid, P_FAMILY));
						result = mysql_query(mysql, query);
						rows = cache_num_rows();

						for(new i = 0; i < rows; i++)
						{
							new name[21];

							cache_get_field_content(i, "name", name);
							new user_id = cache_get_field_content_int(i, "id");
							format(query, sizeof query, "%d. %s<n>", i+1, name);
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, user_id);
						}
						cache_delete(result);
						Dialog(playerid, DIALOG_FAMILY_PL, DIALOG_STYLE_LIST, "{FFCD00}Состав семьи", string_dialog, "Выгнать", "Отмена");
                    }
                    case 2: ShowFamilyInfo(playerid);
                    case 3:
                    {
					    if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет доступа");

						static query[50];
					    for(new i = 0; i < 18; i ++)
						{
					    	format(query, sizeof query, "\"%06x\",", family_colors[i]);
							strcat(STRING_GLOBAL, query);
					    }
					  	new str_len;
						str_len = strlen(STRING_GLOBAL);
						strdel(STRING_GLOBAL, str_len - 1, str_len);
						format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[\"Выберите цвет банды\", [%s], 1]",  STRING_GLOBAL);
						SetPVarInt(playerid,"colortype",2);
					    MoralPacket_2(playerid, s_CefInterface, t_CefShow, "GangColor", STRING_GLOBAL);
                    }
                    case 4:
                    {
						static query[148],
							Cache: result,
							biz_id,
							biz_name[64];

						mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE gang='%d'", GetPlayerData(playerid, P_FAMILY));
						result = mysql_query(mysql, query, true);

						new rows = cache_num_rows();

						if(!rows)
							return SendClientMessage(playerid, 0x999999FF, "* У Вашей банды нет во владенни бизнесов.");

                        vibor_biz_atm[playerid] = 1;

						string_dialog[0] = EOS;
						for(new i = 0; i < rows; i ++)
						{
							biz_id = cache_get_field_content_int(i, "id");
							cache_get_field_content(i, "name", biz_name);

							format(query, sizeof query, "{FFFFFF} %s [%d]\n", biz_name, biz_id);
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, biz_id-1);
						}
						Dialog
						(
							playerid, DIALOG_GANG_BIZ, DIALOG_STYLE_LIST,
							"{FFCD00}Бизнесы банды",
							string_dialog,
							"Выбрать", "Закрыть"
						);
						cache_delete(result);
                    }
                    case 5: ViewFamilyCar(playerid);
                    case 6: ShowInfoGangSklad(playerid);
                    case 7:
                    {
                        if(GetPlayerData(playerid, P_FAMILY_RANK) == 10)
                        {
							Dialog
							(
								playerid, DIALOG_GANG_RANG, DIALOG_STYLE_LIST,
								"{FFCD00}Настройка рангов",
								"1. Настройка склада<n>2. Настройка названий рангов",
								"Выбрать", "Закрыть"
							);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* *Данное меню вам не доступно");
                    }
	           	}
            }
			case DIALOG_GANG_SK_EDIT:
			{
			    if(!response) return 1;
                new fam_id = GetPlayerData(playerid, P_FAMILY);
                switch(listitem)
                {
                    case 0:
                    {
						string_dialog[0] = EOS;
						static fmt_text[144];
					    format(fmt_text, sizeof fmt_text, "1. %s<n>",GetFamilyData(fam_id, F_RANK1));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "2. %s<n>",GetFamilyData(fam_id, F_RANK2));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "3. %s<n>",GetFamilyData(fam_id, F_RANK3));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "4. %s<n>",GetFamilyData(fam_id, F_RANK4));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "5. %s<n>",GetFamilyData(fam_id, F_RANK5));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "6. %s<n>",GetFamilyData(fam_id, F_RANK6));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "7. %s<n>",GetFamilyData(fam_id, F_RANK7));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "8. %s<n>",GetFamilyData(fam_id, F_RANK8));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "9. %s<n>",GetFamilyData(fam_id, F_RANK9));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "10. %s<n>",GetFamilyData(fam_id, F_RANK10));
						strcat(string_dialog, fmt_text);
						Dialog
						(
							playerid, DIALOG_GANG_SK_EDIT_1, DIALOG_STYLE_LIST,
							"{FFCD00}Выберите ранг для изменения",
							string_dialog,
							"Выбрать", "Закрыть"
						);
                    }
                    case 1:
                    {
						string_dialog[0] = EOS;
						static fmt_text[144];
					    format(fmt_text, sizeof fmt_text, "1. %s<n>",GetFamilyData(fam_id, F_RANK1));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "2. %s<n>",GetFamilyData(fam_id, F_RANK2));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "3. %s<n>",GetFamilyData(fam_id, F_RANK3));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "4. %s<n>",GetFamilyData(fam_id, F_RANK4));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "5. %s<n>",GetFamilyData(fam_id, F_RANK5));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "6. %s<n>",GetFamilyData(fam_id, F_RANK6));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "7. %s<n>",GetFamilyData(fam_id, F_RANK7));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "8. %s<n>",GetFamilyData(fam_id, F_RANK8));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "9. %s<n>",GetFamilyData(fam_id, F_RANK9));
					    strcat(string_dialog, fmt_text);
					    format(fmt_text, sizeof fmt_text, "10. %s<n>",GetFamilyData(fam_id, F_RANK10));
						strcat(string_dialog, fmt_text);
						Dialog
						(
							playerid, DIALOG_GANG_SK_EDIT_2, DIALOG_STYLE_LIST,
							"{FFCD00}Выберите ранг для изменения",
							string_dialog,
							"Выбрать", "Закрыть"
						);
                    }
               	}
			}
            case DIALOG_GANG_RANG:
            {
                if(!response) return 1;
                if(GetPlayerData(playerid, P_FAMILY_RANK) == 10)
                {
                    new fam_id = GetPlayerData(playerid, P_FAMILY);
                    switch(listitem)
	                {
	                    case 0:
	                    {
							Dialog
							(
								playerid, DIALOG_GANG_SK_EDIT, DIALOG_STYLE_LIST,
								"{FFCD00}Выберите предмет который хотите настроить",
								"1. Деньги<n> 2. Оружие",
								"Выбрать", "Закрыть"
							);
	                    }
	                    case 1:
	                    {

							string_dialog[0] = EOS;
							static fmt_text[144];
						    format(fmt_text, sizeof fmt_text, "1. %s<n>",GetFamilyData(fam_id, F_RANK1));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "2. %s<n>",GetFamilyData(fam_id, F_RANK2));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "3. %s<n>",GetFamilyData(fam_id, F_RANK3));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "4. %s<n>",GetFamilyData(fam_id, F_RANK4));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "5. %s<n>",GetFamilyData(fam_id, F_RANK5));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "6. %s<n>",GetFamilyData(fam_id, F_RANK6));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "7. %s<n>",GetFamilyData(fam_id, F_RANK7));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "8. %s<n>",GetFamilyData(fam_id, F_RANK8));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "9. %s<n>",GetFamilyData(fam_id, F_RANK9));
						    strcat(string_dialog, fmt_text);
						    format(fmt_text, sizeof fmt_text, "10. %s<n>",GetFamilyData(fam_id, F_RANK10));
							strcat(string_dialog, fmt_text);
							Dialog
							(
								playerid, DIALOG_GANG_RANG_EDIT, DIALOG_STYLE_LIST,
								"{FFCD00}Выберите ранг для изменения",
								string_dialog,
								"Выбрать", "Закрыть"
							);
	                    }
	               }
                }
				else SendClientMessage(playerid, 0xCECECEFF, "* *Данное меню вам не доступно");
            }
            case DIALOG_GANG_SK_EDIT_1:
            {
			    if(response)
                {
                    SetPVarInt(playerid, "listitems",listitem);
					Dialog(playerid, DIALOG_GANG_SK_EDIT_3, DIALOG_STYLE_INPUT, "{FFCD00}Настройка рангов", "{FFFFFF}Введите кол-во патрон который сможет брать данный ранг:", "Приять", "Назад");
                }
            }
            case DIALOG_GANG_SK_EDIT_2:
            {
			    if(response)
                {
                    SetPVarInt(playerid, "listitems",listitem);
                 	Dialog(playerid, DIALOG_GANG_SK_EDIT_4, DIALOG_STYLE_INPUT, "{FFCD00}Настройка рангов", "{FFFFFF}Введите кол-во денег который сможет брать данный ранг:", "Приять", "Назад");
                }
            }
			case DIALOG_GANG_RANG_EDIT:
			{
			    if(response)
                {
                    SetPVarInt(playerid, "listitems",listitem);
	                Dialog(playerid, DIALOG_GANG_RANG_EDIT_1, DIALOG_STYLE_INPUT, "{FFCD00}Настройка рангов", "{FFFFFF}Введите название ранга которое хотите поставить:", "Приять", "Назад");
                }
			}
			case DIALOG_GANG_SK_EDIT_3:
			{
			    if(!response) return 1;
			    new put_sum = strval(inputtext);
			    if(!(100 <= put_sum <= 50000000)) return SendClientMessage(playerid, 0xCECECEFF, "* Кол-во денег от 100 до 50.000.000");
			    new fam_id = GetPlayerData(playerid, P_FAMILY);
			    listitem = GetPVarInt(playerid, "listitems");
			    F_RANK_MON[fam_id][listitem] = put_sum;
			    static query[144];
			 	format(query, sizeof query, "UPDATE family SET mon_rank%d=%d WHERE id=%d LIMIT 1",listitem+1,F_RANK_MON[fam_id][listitem], g_family[fam_id][F_SQL_ID]);
				mysql_query(mysql, query, false);
			    SendClientMessage(playerid, 0xCECECEFF, "* Вы успешно изменили кол-во денег, которое может брать данный ранг!");
			}
			case DIALOG_GANG_SK_EDIT_4:
			{
			    if(!response) return 1;
			    new put_sum = strval(inputtext);
			    if(!(10 <= put_sum <= 500)) return SendClientMessage(playerid, 0xCECECEFF, "* Кол-во патрон от 100 до 500");
			    new fam_id = GetPlayerData(playerid, P_FAMILY);
			    listitem = GetPVarInt(playerid, "listitems");
			    F_RANK_PAT[fam_id][listitem] = put_sum;
				static query[144];
			 	format(query, sizeof query, "UPDATE family SET pat_rank%d=%d WHERE id=%d LIMIT 1",listitem+1,F_RANK_PAT[fam_id][listitem], g_family[fam_id][F_SQL_ID]);
				mysql_query(mysql, query, false);
			    SendClientMessage(playerid, 0xCECECEFF, "* Вы успешно изменили кол-во патрон, которое может брать данный ранг!");
			}
			case DIALOG_GANG_RANG_EDIT_1:
			{
			    if(response)
                {
                    if(!(5 <= strlen(inputtext) <= 30)) return SendClientMessage(playerid, 0xCECECEFF, "* Кол-во символов от 5 до 30");
                    new fam_id = GetPlayerData(playerid, P_FAMILY);
					listitem = GetPVarInt(playerid, "listitems");
                    if(listitem == 0)format(GetFamilyData(fam_id, F_RANK1), 31, "%s", inputtext);
                    if(listitem == 1)format(GetFamilyData(fam_id, F_RANK2), 31, "%s", inputtext);
                    if(listitem == 2)format(GetFamilyData(fam_id, F_RANK3), 31, "%s", inputtext);
                    if(listitem == 3)format(GetFamilyData(fam_id, F_RANK4), 31, "%s", inputtext);
                    if(listitem == 4)format(GetFamilyData(fam_id, F_RANK5), 31, "%s", inputtext);
                    if(listitem == 5)format(GetFamilyData(fam_id, F_RANK6), 31, "%s", inputtext);
                    if(listitem == 6)format(GetFamilyData(fam_id, F_RANK7), 31, "%s", inputtext);
                    if(listitem == 7)format(GetFamilyData(fam_id, F_RANK8), 31, "%s", inputtext);
                    if(listitem == 8)format(GetFamilyData(fam_id, F_RANK9), 31, "%s", inputtext);
					if(listitem == 9)format(GetFamilyData(fam_id, F_RANK10), 31, "%s", inputtext);

                    static query[255];
                    format(query, sizeof query, "UPDATE family SET rank1='%s', rank2='%s' WHERE id=%d LIMIT 1",
					GetFamilyData(fam_id, F_RANK1),GetFamilyData(fam_id, F_RANK2), g_family[fam_id][F_SQL_ID]);
					mysql_query(mysql, query, false);

					format(query, sizeof query, "UPDATE family SET rank3='%s', rank4='%s' WHERE id=%d LIMIT 1",
					GetFamilyData(fam_id, F_RANK3),GetFamilyData(fam_id, F_RANK4), g_family[fam_id][F_SQL_ID]);
					mysql_query(mysql, query, false);

					format(query, sizeof query, "UPDATE family SET rank5='%s', rank6='%s' WHERE id=%d LIMIT 1",
					GetFamilyData(fam_id, F_RANK5),GetFamilyData(fam_id, F_RANK6), g_family[fam_id][F_SQL_ID]);
					mysql_query(mysql, query, false);

					format(query, sizeof query, "UPDATE family SET rank7='%s',rank8='%s' WHERE id=%d LIMIT 1",
					GetFamilyData(fam_id, F_RANK7),GetFamilyData(fam_id, F_RANK8), g_family[fam_id][F_SQL_ID]);
					mysql_query(mysql, query, false);

					format(query, sizeof query, "UPDATE family SET rank9='%s', rank10='%s' WHERE id=%d LIMIT 1",
					GetFamilyData(fam_id, F_RANK9),GetFamilyData(fam_id, F_RANK10), g_family[fam_id][F_SQL_ID]);
					mysql_query(mysql, query, false);
                    SendClientMessage(playerid, 0xCECECEFF, "* Вы успешно изменили название ранга!");
                }
			}
			case DIALOG_FAMILY_PL:
			{
                if(!response) return 1;
                if(GetPlayerData(playerid, P_FAMILY_RANK) < 9) return SendClientMessage(playerid, 0xCECECEFF, "* *Данное меню вам не доступно");
				new idx = GetPlayerListitemValue(playerid, listitem);

				SetPVarInt(playerid, "listitem_fam", listitem);
				SetPVarInt(playerid, "acc_id", idx);

				static query[144],
					Cache: result,
					rows;
				mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE id='%d'", idx);
				result = mysql_query(mysql, query);
				rows = cache_num_rows();

				for(new i = 0; i < rows; i++)
				{
					new name[21];
					new namerank[20];
					new rank = cache_get_field_content_int(i, "family_rank");
					new fam_id = cache_get_field_content_int(i, "family");
				    if(rank == 1) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK1));
				    if(rank == 2) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK2));
				    if(rank == 3) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK3));
				    if(rank == 4) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK4));
				    if(rank == 5) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK5));
				    if(rank == 6) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK6));
				    if(rank == 7) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK7));
				    if(rank == 8) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK8));
				    if(rank == 9) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK9));
				    if(rank == 10) format(namerank, sizeof namerank, "%s",GetFamilyData(fam_id, F_RANK10));
					cache_get_field_content(i, "name", name);
					format(query, sizeof query, "{FFFFFF}Игрок: %s<n>Положение: %s",  name, namerank);
				}
				cache_delete(result);
				Dialog(playerid, DIALOG_FAMILY_PLA, DIALOG_STYLE_MSGBOX, "{FFCD00}Состав семьи", query, "Выгнать", "Отмена");
			}
			case DIALOG_FAMILY_PLA:
			{
			    if(!response) return 1;
			    if(GetPlayerData(playerid, P_FAMILY_RANK) < 9) return SendClientMessage(playerid, 0xCECECEFF, "* *Данное меню вам не доступно");
			    new id = GetPVarInt(playerid, "acc_id");
			    static fmt_str[144],Cache: result;

				mysql_format(mysql, fmt_str, sizeof fmt_str, "SELECT * FROM PlayersMorallwens WHERE id='%d'", id);
				result = mysql_query(mysql, fmt_str);

				new rows = cache_num_rows();

				for(new i = 0; i < rows; i++)
				{
				    new rank = cache_get_field_content_int(i, "family_rank");
				    if(GetPlayerData(playerid, P_FAMILY_RANK) == rank)
				    {
				        return SendClientMessage(playerid, 0xCECECEFF, "* *Вы не можете выгнать данного человека!");
				    }
				    if(rank == 10)
				    {
				        return SendClientMessage(playerid, 0xCECECEFF, "* *Вы не можете выгнать данного человека!");
				    }
				}
			 	format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens SET family=0,family_rank=0 WHERE id=%d LIMIT 1", id);
    			mysql_query(mysql, fmt_str, false);
    			cache_delete(result);
				foreach(new i: Player)
				{
					if(!IsPlayerConnected(i)) continue;
					if(!IsPlayerLogged(i)) continue;
					if(GetPlayerData(i, P_FAMILY) == 0) continue;
					if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;
					if(id == GetPlayerAccountID(i))
					{
					    SetPlayerData(i, P_FAMILY,0);
					    SetPlayerData(i, P_FAMILY_RANK,0);
						DestroyDynamic3DTextLabel(g_player[i][P_FAM_LABEL]);
						g_player[i][P_FAM_LABEL] = Text3D: -1;
						SetPlayerColorEx(i, GetPlayerTeamColor(i));
					}
				}
			}
            case DIALOG_FAMILY_BANK_PUT:
            {
                if(response)
                {
	                new put_sum = strval(inputtext);
	                if(put_sum > 0 && IsNumeric(inputtext))
	                {

	                    static fmt_str[155];

						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), put_sum))
	                    {
	                        format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,family f SET a.money=%s,f.money=f.money + %d WHERE a.id=%d AND f.id=%d", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), -put_sum), put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
	                        mysql_query(mysql, fmt_str, false);

	                        if(!mysql_errno())
	                        {
	                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY, +, put_sum);
	                            GivePlayerMoneyEx(playerid, -put_sum, "Пополнение банка семьи", false, true);

	                            static fmt_msg[144];

	                            format(fmt_msg, sizeof fmt_msg, "<%s> %s[%d] пополнил бюджет семьи на %d руб. Бюджет %d руб.", GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_NAME), GetPlayerNameEx(playerid), playerid, put_sum,GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY));

								foreach(new i: Player)
								{
									if(!IsPlayerConnected(i)) continue;
									if(!IsPlayerLogged(i)) continue;
									if(GetPlayerData(i, P_FAMILY) == 0) continue;
									if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

									SendClientMessage(i, 0xFF4D18FF, fmt_msg);
								}
	                        }
	                        else SendClientMessage(playerid, 0xCECECEFF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
	                    }
	                    else SendClientMessage(playerid, 0xFFFFFFFF, "Недостаточно средств");
	                }
                }
                else Dialog(playerid, DIALOG_FAMILY_BANK, DIALOG_STYLE_LIST, "{FFCD00}Бюджет семьи", "1. Пополнить<n>2. Снять<n>3. История", "Принять", "Отмена");

            }
            case DIALOG_FAMILY_BANK_PICK:
            {
                if(response)
                {
	                new put_sum = strval(inputtext);
	                if(put_sum > 0 && IsNumeric(inputtext))
	                {

	                    static fmt_str[155];

	                    if(GetPlayerData(playerid, P_FAMILY) >= put_sum)
	                    {
	                        format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,family f SET a.money=%s,f.money=f.money + %d WHERE a.id=%d AND f.id=%d", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), put_sum), -put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
	                        mysql_query(mysql, fmt_str, false);

	                        if(!mysql_errno())
	                        {
	                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY, -, put_sum);
	                            GivePlayerMoneyEx(playerid, put_sum, "снятие с банка семьи", false, true);

	                            static fmt_msg[144];

	                            format(fmt_msg, sizeof fmt_msg, "<%s> %s[%d] снял с бюджета семьи на %d руб. Бюджет %d руб.", GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_NAME), GetPlayerNameEx(playerid), playerid, put_sum,GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY));

								foreach(new i: Player)
								{
									if(!IsPlayerConnected(i)) continue;
									if(!IsPlayerLogged(i)) continue;
									if(GetPlayerData(i, P_FAMILY) == 0) continue;
									if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

									if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

									SendClientMessage(i, 0xFF4D18FF, fmt_msg);
								}
	                        }
	                        else SendClientMessage(playerid, 0xCECECEFF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
	                    }
	                    else SendClientMessage(playerid, 0xFFFFFFFF, "Недостаточно средств на счете семьи");
	                }
                }
                else Dialog(playerid, DIALOG_FAMILY_BANK, DIALOG_STYLE_LIST, "{FFCD00}Бюджет семьи", "1. Пополнить<n>2. Снять<n>3. История", "Принять", "Отмена");
            }
            case DIALOG_FAMILY_BANK:
            {
                if(response)
                {
                    switch(listitem)
                    {
                        case 0:
                        {
                            Dialog(playerid, DIALOG_FAMILY_BANK_PUT, DIALOG_STYLE_INPUT, "{FFCD00}Бюджет семьи", "{FFFFFF}Введите количество, которое хотите положить:", "Приять", "Назад");
                        }
                        case 1:
                        {
                            static fmt_texts[144];
                            format(fmt_texts, sizeof fmt_texts, "{FFFFFF}Доступно: {FFCD00}%d руб.<n><n>{FFFFFF}Введите количество, которое хотите снять:",GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY));
                            Dialog(playerid, DIALOG_FAMILY_BANK_PICK, DIALOG_STYLE_INPUT, "{FFCD00}Бюджет семьи", fmt_texts, "Приять", "Назад");
                        }
                        case 2:
                        {
                        }
                    }
                }
                else callcmd::fmenu(playerid, "");

            }
            case DIALOG_FAMILY_LEAVE:
            {
                static fmt_text[110];
                if(response)
                {
                    new fam_id = GetPlayerData(playerid, P_FAMILY);

                    format(fmt_text, sizeof fmt_text, "<%s> %s[%d]: покинул семью по собственному желанию",
                    GetFamilyData(fam_id, F_NAME), GetPlayerNameEx(playerid), playerid);

                    foreach(new i: Player)
                    {
                        if(!IsPlayerConnected(i)) continue;
                        if(!IsPlayerLogged(i)) continue;
                        if(GetPlayerData(i, P_FAMILY) == 0) continue;
                        if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

                        if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

                        SendClientMessage(i, 0xCECECEFF, fmt_text);
                    }

                    format(fmt_text, sizeof fmt_text, "Вы покинули семью \"%s\"", GetFamilyData(fam_id, F_NAME));
                    SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

                    FUnInvite(playerid, playerid);
                }
            }
            case DIALOG_FAMILY_RANG:
            {
                if(!response) return callcmd::fmenu(playerid, "");

                new fam_id = GetPlayerData(playerid, P_FAMILY),
                    desc[32] = "";

                switch(listitem)
                {
                    case 0: strcat(desc, g_family[fam_id][F_RANK1]);
                    case 1: strcat(desc, g_family[fam_id][F_RANK2]);
                    case 2: strcat(desc, g_family[fam_id][F_RANK3]);
                    case 3: strcat(desc, g_family[fam_id][F_RANK4]);
                    case 4: strcat(desc, g_family[fam_id][F_RANK5]);
                    case 5: strcat(desc, g_family[fam_id][F_RANK6]);
                    case 6: strcat(desc, g_family[fam_id][F_RANK7]);
                    case 7: strcat(desc, g_family[fam_id][F_RANK8]);
                    case 8: strcat(desc, g_family[fam_id][F_RANK9]);
                    case 9: strcat(desc, g_family[fam_id][F_RANK10]);
                }

                SetPVarInt(playerid, "userang", listitem+1);
                Dialog
                (
                    playerid, DIALOG_FAMILY_RCHANGE, DIALOG_STYLE_INPUT,
                    desc,
                    "{FFFFFF}Введите название, которое Вы хотите {d8284c}установить:",
                    "Далее", "Отмена"
                );
            }
			case DIALOG_OWNABLE_HOME_FAMILY:
			{
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				SetPVarInt(playerid, "ownablehouse_id", idx);
				new houseids = GetPVarInt(playerid, "ownablehouse_id");

				if(g_family[GetPlayerFamily(playerid)][F_GANG] == 1)
				{
					static fmt_text[144];
					new fam_id = GetPlayerData(playerid, P_FAMILY);
					SetFamilyData(fam_id, F_HOUSE_ID, houseids);
					mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET house_id=%d WHERE id='%d' LIMIT 1", houseids, fam_id);
					mysql_query(mysql, fmt_text, false);
					format(fmt_text, sizeof fmt_text, "<%s> База банды теперь находится в доме №%d", GetFamilyData(fam_id, F_NAME), GetFamilyData(fam_id, F_HOUSE_ID));

					foreach(new i: Player)
					{
						if(!IsPlayerConnected(i)) continue;
						if(!IsPlayerLogged(i)) continue;
						if(GetPlayerData(i, P_FAMILY) == 0) continue;
						if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

						if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

						SendClientMessage(playerid, 0xFF9C18FF, fmt_text);
					}
					new houseid = GetFamilyData(fam_id, F_HOUSE_ID);
					new type = GetHouseData(houseid, H_TYPE);
					DestroyPickup(gangsklads[fam_id]);
					if(IsValidDynamic3DTextLabel(GetFamilyData(fam_id, F_SKLAD))) DestroyDynamic3DTextLabel(GetFamilyData(fam_id, F_SKLAD));
					gangsklads[fam_id] = CreatePickup(1239, 23, GetHouseTypeInfo(type, HT_SKLAD_POS_X), GetHouseTypeInfo(type, HT_SKLAD_POS_Y), GetHouseTypeInfo(type, HT_SKLAD_POS_Z), houseid + 2000, PICKUP_ACTION_TYPE_SKLAD);

					SetFamilyData(fam_id, F_SKLAD, CreateDynamic3DTextLabel("", 0xFFFF00FF, GetHouseTypeInfo(type, HT_SKLAD_POS_X), GetHouseTypeInfo(type, HT_SKLAD_POS_Y), GetHouseTypeInfo(type, HT_SKLAD_POS_Z) + 1, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseid + 2000, -1, -1, 50.0));
					CallLocalFunction("UpdateGangSklad", "i", fam_id);
				}
			}
            case DIALOG_FAMILY_RCHANGE:
            {
                if(!response) return callcmd::fmenu(playerid, "");

                new fmt_text[556],
                    rang_id = GetPVarInt(playerid, "userang"),
                    fam_id = GetPlayerData(playerid, P_FAMILY);

                switch(rang_id)
                {
                    case 1:
                    {
                        format(g_family[fam_id][F_RANK1], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank1='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 2:
                    {
                        format(g_family[fam_id][F_RANK2], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank2='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 3:
                    {
                        format(g_family[fam_id][F_RANK3], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank3='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 4:
                    {
                        format(g_family[fam_id][F_RANK4], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank4='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 5:
                    {
                        format(g_family[fam_id][F_RANK5], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank5='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 6:
                    {
                        format(g_family[fam_id][F_RANK6], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank6='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 7:
                    {
                        format(g_family[fam_id][F_RANK7], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank7='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 8:
                    {
                        format(g_family[fam_id][F_RANK8], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank8='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 9:
                    {
                        format(g_family[fam_id][F_RANK9], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank9='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 10:
                    {
                        format(g_family[fam_id][F_RANK10], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank10='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                }

                format(fmt_text, sizeof fmt_text, "Вы успешно изменили название ранга {d8284c}№%d {1E90FF}на {d8284c}\"%s\"", rang_id, inputtext);
                SendClientMessage(playerid, 0x1E90FFFF, fmt_text);
            }
            case DIALOG_FAMILY_CAR_ADD:
            {
            	if(response)
				{
					if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");
					if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет доступа");
					if(!IsPlayerInAnyVehicle(playerid))
						return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте");

					new vehicleid = GetPlayerVehicleID(playerid);
					static query[144];


					new vehicleid1 = GetPlayerOwnableCarLast(playerid);

					if(vehicleid1 != GetPlayerVehicleID(playerid))
					return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");

					new idx = GetVehicleData(vehicleid, V_ACTION_ID);
					SetOwnableCarData(idx, OC_FAM_CAR, GetPlayerData(playerid, P_FAMILY));
					SetOwnableCarData(idx, OC_FAM_CAR_RANK, 1);
					mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET famcar=%d, famcarrank=%d WHERE id=%d", GetOwnableCarData(idx, OC_FAM_CAR),GetOwnableCarData(idx, OC_FAM_CAR_RANK), GetOwnableCarData(idx, OC_SQL_ID));
					mysql_query(mysql, query, false);
					new color = family_color_car[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)][0];
					ChangeVehicleColor(vehicleid, color, color);
					SendClientMessage(playerid, 0xCECECEFF, "* Вы успешно добавили свой транспорт себе в семью!");
				}
            }
            case DIALOG_FAMILY_CAR_REMOVE:
            {
            	if(response)
				{
					if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");
					if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет доступа");
					if(!IsPlayerInAnyVehicle(playerid))
						return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте");

					new vehicleid = GetPlayerVehicleID(playerid);
					static query[144];


					new vehicleid1 = GetPlayerOwnableCarLast(playerid);

					if(vehicleid1 != GetPlayerVehicleID(playerid))
					return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");
					new idx = GetVehicleData(vehicleid, V_ACTION_ID);
					SetOwnableCarData(idx, OC_FAM_CAR, 0);
					SetOwnableCarData(idx, OC_FAM_CAR_RANK, 0);
					mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET famcar=%d, famcarrank=%d WHERE id=%d", GetOwnableCarData(idx, OC_FAM_CAR),GetOwnableCarData(idx, OC_FAM_CAR_RANK), GetOwnableCarData(idx, OC_SQL_ID));
					mysql_query(mysql, query, false);
					ChangeVehicleColor(vehicleid, GetOwnableCarData(idx, OC_COLOR_1), GetOwnableCarData(idx, OC_COLOR_2));
					SendClientMessage(playerid, 0xCECECEFF, "* Вы успешно убрали свой транспорт со своей семьи!");
				}
			}
			case DIALOG_FAMILY_DELL:
			{
			    if(!response) return 1;
			    
				new fam_id = GetPlayerData(playerid, P_FAMILY),
					query[80];

				format(query, sizeof query, "UPDATE family SET u_id=-1,name='delete' WHERE id=%d LIMIT 1", g_family[fam_id][F_SQL_ID]);
				mysql_query(mysql, query, false);

				DestroyPickup(gangsklads[fam_id]);
				if(IsValidDynamic3DTextLabel(GetFamilyData(fam_id, F_SKLAD))) DestroyDynamic3DTextLabel(GetFamilyData(fam_id, F_SKLAD));

				foreach(new i : Player)
				{
					if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					if(GetPlayerData(i, P_FAMILY) == GetPlayerData(playerid, P_FAMILY))
					{
						DestroyDynamic3DTextLabel(g_player[i][P_FAM_LABEL]);
						SetPlayerColorEx(i, GetPlayerTeamColor(i));
						SCMF(i, 0x1E90FFFF, "Внимание! Владелец удалил семью %s, в которой вы состоите", GetFamilyData(fam_id, F_NAME));
						SetPlayerData(i, P_FAMILY,0);
						SetPlayerData(i, P_FAMILY_RANK,0);

				        format(query, sizeof query, "UPDATE PlayersMorallwens SET family=%d,family_rank=%d WHERE id=%d",GetPlayerData(i, P_FAMILY), GetPlayerData(i, P_FAMILY_RANK), GetPlayerAccountID(i));
				        mysql_query(mysql, query, false);
					}
				}
			}
			case DIALOG_OWNABLE_CAR_FAMILY:
			{
			    if(response)
				{
					new vehicleid = INVALID_VEHICLE_ID;
					new idx = GetPVarInt(playerid, "ownablecar_id");
	                for(new i = 0; i < MAX_VEHICLES; i++)
					{
					    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
					    {
						    new iddx = GetVehicleData(i, V_ACTION_ID);
					        if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
					        {
					            vehicleid = i;
					        }
				        }

					}
					if(vehicleid != INVALID_VEHICLE_ID)
					{
						switch(listitem + 1)
						{
						    case 1:
						    {
								if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
								{
									if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 300))
									{
										GivePlayerMoneyEx(playerid, -300, "Метка ТС на GPS", true, true);

										new Float: x, Float: y, Float: z;
										GetVehiclePos(vehicleid, x, y, z);

										EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего транспорта отмечено на GPS");
										return 1;
									}
									else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* На Вашем GPS уже отмечено место");
						    }
							case 2: // Открыть / закрыть
							{
								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 1000))
								{
									SetPVarInt(playerid, "go_list", 1);
									SetVehicleToRespawn(vehicleid);
									GivePlayerMoneyEx(playerid, -1000, "респавн тс семьи", true, true);
								}
								else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
							}
							case 3: // Выгрузить транспорт
							{
//							    new famid = GetPlayerData(playerid, P_FAMILY);
								if(UnloadFamilyOwnableCar(vehicleid))
									SendClientMessage(playerid, 0x66CC33FF, "Транспорт успешно выгружен!");
							}
							case 4: // Выгрузить транспорт
							{
								SetPVarInt(playerid, "veh_id", vehicleid);
								Dialog
								(
									playerid, DIALOG_FAMILT_CAR_RANK, DIALOG_STYLE_INPUT,
									"Изменение доступа ранга траспорта банды",
									"{FFFFFF} Введите какой хотите поставить ранг у траспорта\n\
									Доступный ранг, который можно поставить от 1 до 9",
									"Поставить", "Назад"
								);
							}
						}
					}
				}
			}
			case DIALOG_FAM_CAR_LIST:
			{
				if(response)
				{
					new idx = GetPlayerListitemValue(playerid, listitem);

					SetPVarInt(playerid, "listitem_car", listitem);
					new Cache: result;
					new famid = GetPlayerData(playerid, P_FAMILY);
					SetPVarInt(playerid, "ownablecar_id", idx);
	//					new famid = GetPlayerData(playerid, P_FAMILY);


					new veh_id = INVALID_VEHICLE_ID;

					for(new i = 0; i < MAX_VEHICLES; i++)
					{
						if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
						{
							new iddx = GetVehicleData(i, V_ACTION_ID);
							if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
							{
								veh_id = i;
							}
						}

					}


					if(veh_id == INVALID_VEHICLE_ID)
					{
						//ShowOwnableCarLoadDialog(playerid, idx, true);
						if(LoadFamilyCar(famid,idx) != -1)
						{
							SendClientMessage(playerid, 0x66CC33FF, "Данный траспорт успешно загружен!");
							SendClientMessage(playerid, -1, "* Чтобы открыть данный транспорт пропишите: /lock 4.");
						}
						else SendClientMessage(playerid, 0x999999FF, "* Ошибка при загрузке транспорта семьи");
					}
					else
					{
						ShowOwnableCarFamilyLoadDialog(playerid, idx, true);
					}
					cache_delete(result);
				}
			}
			case DIALOG_FAMILT_CAR_RANK:
			{
			    if(response)
				{
				    new rang = strval(inputtext);
				    if(1 <= rang <= 9)
				    {
	        			static query[100];
	                    new vehicleid = GetPVarInt(playerid, "veh_id"), index = GetVehicleData(vehicleid, V_ACTION_ID);
	                    SetOwnableCarData(index, OC_RANG, rang);
	                    mysql_format(mysql, query, sizeof query, "UPDATE family_cars SET rang = '%d' WHERE id='%d'",rang, GetOwnableCarData(index, OC_SQL_ID));
	                    mysql_query(mysql, query, false);
	                    SendClientMessage(playerid, -1, "* Вы успешно изменили ранг-доступ данному трансопрту");
	               	}
	               	else
	               	{
	               	    SendClientMessage(playerid, -1, "* Допустимый ранг от 1 до 9!");
						Dialog
						(
							playerid, DIALOG_FAMILT_CAR_RANK, DIALOG_STYLE_INPUT,
							"Изменение доступа ранга траспорта банды",
							"{FFFFFF} Введите какой хотите поставить ранг у траспорта\n\
							Доступный ранг, который можно поставить от 1 до 9",
							"Поставить", "Назад"
						);
	               	}
				}
			}
			case DIALOG_GANG_CAR_ADD:
		{
			if(response)
			{
				new vehicleid = GetPlayerOwnableCarLast(playerid);
				new fam_id = GetPlayerData(playerid,P_FAMILY);
				static query[1024],Cache: result;
				new index = GetVehicleData(vehicleid, V_ACTION_ID);
				new Float: x,Float: y,Float: z,Float: angle;
				GetVehiclePos(vehicleid, x, y, z); // узнаем координаты авто
				GetVehicleZAngle(vehicleid, angle);

				mysql_format(mysql, query, sizeof query, "DELETE FROM ownable_cars WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, query, false);
				format
				(
					query, sizeof query,
					"INSERT INTO family_cars \
					(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time,diski,gidra,mileage,iznos,gryaz,vinil,typenumber,number,region,obves,tonerinstall) \
					VALUES \
					('%d','%d','%d','%d','%f','%f','%f','%f','%d','%d','%d','%f','%d','%f','%d','%d','%s','%s','%s','%d')",
					fam_id,
					GetOwnableCarData(index, OC_MODEL_ID),
					GetOwnableCarData(index, OC_COLOR_1),
					GetOwnableCarData(index, OC_COLOR_2),
					x,
					y,
					z,
					angle,
					gettime(),
					GetOwnableCarData(index, OC_DISKI),
					GetOwnableCarData(index, OC_GIDRA),
					GetVehicleData(vehicleid, V_MILEAGE),
					GetVehicleData(vehicleid, V_IZNOS),
					GetVehicleData(vehicleid, V_GRYAZ),
					GetOwnableCarData(index, OC_VINIL),
					GetOwnableCarData(index, OC_NUMBERTYPE),
					GetOwnableCarData(index, OC_NUMBER),
					GetOwnableCarData(index, OC_REGION),
					GetOwnableCarData(index, OC_OBVES),
					GetOwnableCarData(index, OC_TONERINSTALL)
				);
				result = mysql_query(mysql, query, true);
				cache_delete(result);
				SendClientMessage(playerid, 0x66CC00FF, "* Вы успешно отдали данный транспорт в использование свой банды.");
				SetOwnableCarData(index, OC_CREATE, 0);
				DestroyVehicleLabel(vehicleid);
				DestroyVehicle(vehicleid);
				SetVehicleData(vehicleid, V_LAST_LOAD_TIME, 0);

			}
		}
		case DIALOG_GANG_CAR_DELL:
		{
			if(response)
			{
				new vehicleid = GetFamilyOwnableCarLast(playerid,GetPlayerData(playerid, P_FAMILY));
				static query[1024],Cache: result;
				new index = GetVehicleData(vehicleid, V_ACTION_ID);
				new Float: x,Float: y,Float: z,Float: angle;
				GetVehiclePos(vehicleid, x, y, z); // узнаем координаты авто
				GetVehicleZAngle(vehicleid, angle);

				mysql_format(mysql, query, sizeof query, "DELETE FROM family_cars WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
				mysql_query(mysql, query, false);
				format
				(
					query, sizeof query,
					"INSERT INTO ownable_cars \
					(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time,diski,gidra,vinil,typenumber,number,region,obves,tonerinstall) \
					VALUES \
					('%d','%d','%d','%d','%f','%f','%f','%f','%d','%d','%d','%d','%d','%s','%s','%s','%d')",
					GetPlayerAccountID(playerid),
					GetOwnableCarData(index, OC_MODEL_ID),
					GetOwnableCarData(index, OC_COLOR_1),
					GetOwnableCarData(index, OC_COLOR_2),
					x,
					y,
					z,
					angle,
					gettime(),
					GetOwnableCarData(index, OC_DISKI),
					GetOwnableCarData(index, OC_GIDRA),
					GetOwnableCarData(index, OC_VINIL),
					GetOwnableCarData(index, OC_NUMBERTYPE),
					GetOwnableCarData(index, OC_NUMBER),
					GetOwnableCarData(index, OC_REGION),
					GetOwnableCarData(index, OC_OBVES),
					GetOwnableCarData(index, OC_TONERINSTALL)
				);

				result = mysql_query(mysql, query, true);
				cache_delete(result);

				SendClientMessage(playerid, 0x66CC00FF, "* Вы успешно забрали данный транспорт со своей банды.");

				SetOwnableCarData(index, OC_OWNER_ID, 0);
				DestroyVehicleLabel(vehicleid);

				DestroyVehicle(vehicleid);

				SetVehicleData(vehicleid, V_LAST_LOAD_TIME, 0);
			}
		}
		case DIALOG_BUY_DONATE_PACK_1:
        {
            if(!response) return 1;

            if(GetPlayerCurrentDonate(playerid) < 16000) return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);

            if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~Недостаточно места~n~в инвентаре", 3000, 2);

            GiveCar(playerid, 17434, 0, 0, -0, 1, 110.8994,322.3508,11.2202,251.4996, gettime());
			GiveSkin(playerid, 17096);

            GivePlayerDonate(playerid, -16000);
            SCM(playerid, 0x6699CCFF, "{FF8800}Вы успешно приобрели набор 'Candy Shop'");
            GameText(playerid, "~r~~h~Успешно", 3000, 2);
        }
        case DIALOG_TEST_DRIVE:
        {
            if(!response) return 1;

            SCM(playerid, COLOR_LightSeaGreen, "{ecf96a}Вы попали на тест-драйв {FFFFFF}донат-пакета. {ecf96a}У вас есть {FF0000}3 минуты.");
            format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[\"До конца тест-драйва\",%d]", gettime() + 179);
            MoralPacket_2(playerid, s_CefInterface, t_CefShow, "InformationTimer", STRING_GLOBAL);
            testdrive_timer[playerid] = SetTimer("TestDrivePack", 179000, false);
            MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Interactions");
            MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[-1, \"Завершить тест драйв\"]]");
            MoralPacket_1(playerid, s_CefInterface, t_CefHide, "DonateItem");
            GameText(playerid, "~g~Тест-Драйв начат", 3000, 2);
            TestDrive[playerid] = 1;
            if(IsPlayerInRangeOfPoint(playerid,6.0, 1920.7385,-1977.4579,31.5505))
            {
                g_temp_vehicle2[playerid] = CreateVehicle(17433, 1926.6510, -1979.0786, 31.1686, 59.7267, 0, 0, -1);
                PutPlayerInVehicle(playerid, g_temp_vehicle2[playerid], 0);
                SetPlayerVirtualWorld(playerid, 259);
                SetVehicleVirtualWorld(g_temp_vehicle2[playerid], 259);
                PosTestDrive[playerid] = 1;
            }
            if(IsPlayerInRangeOfPoint(playerid,6.0, 1867.4656,2803.1958,12.0000))
            {
                g_temp_vehicle2[playerid] = CreateVehicle(17433, 1870.7363, 2809.5242, 11.6234, 359.5703, 0, 0, -1);
                PutPlayerInVehicle(playerid, g_temp_vehicle2[playerid], 0);
                SetPlayerVirtualWorld(playerid, 259);
                SetVehicleVirtualWorld(g_temp_vehicle2[playerid], 259);
                PosTestDrive[playerid] = 2;
            }
            if(IsPlayerInRangeOfPoint(playerid,6.0, -1938.8953,2909.2773,5.9990))
            {
                g_temp_vehicle2[playerid] = CreateVehicle(17433, -1943.3036, 2911.9465, 5.6206, 91.0131, 0, 0, -1);
                PutPlayerInVehicle(playerid, g_temp_vehicle2[playerid], 0);
                SetPlayerVirtualWorld(playerid, 259);
                SetVehicleVirtualWorld(g_temp_vehicle2[playerid], 259);
                PosTestDrive[playerid] = 3;
            }
            if(IsPlayerInRangeOfPoint(playerid,6.0, -1912.2034,1917.0387,175.2322))
            {
                g_temp_vehicle2[playerid] = CreateVehicle(17433, -1913.9109, 1912.3358, 174.7725, 179.5422, 0, 0, -1);
                PutPlayerInVehicle(playerid, g_temp_vehicle2[playerid], 0);
                SetPlayerVirtualWorld(playerid, 259);
                SetVehicleVirtualWorld(g_temp_vehicle2[playerid], 259);
                PosTestDrive[playerid] = 4;
            }
            if(IsPlayerInRangeOfPoint(playerid,6.0, -406.3729,746.4713,12.2904))
            {
                g_temp_vehicle2[playerid] = CreateVehicle(17433, -412.8358, 763.3583, 12.0024, 270.0263, 0, 0, -1);
                PutPlayerInVehicle(playerid, g_temp_vehicle2[playerid], 0);
                SetPlayerVirtualWorld(playerid, 259);
                SetVehicleVirtualWorld(g_temp_vehicle2[playerid], 259);
                PosTestDrive[playerid] = 5;
            }
        }
		case DIALOG_BUY_DONATE_PACK_2:
		{
			if(!response) return 1;

			if(GetPlayerCurrentDonate(playerid) < 5000) return GameText(playerid, "~r~У вас недостаточно доната", 3000, 2);
			
			GiveCar(playerid, 504, 1, 1, -1, -1, 110.8994,322.3508,11.2202,251.4996, gettime());

			GivePlayerDonate(playerid, -5000);
			SCM(playerid, 0x6699CCFF, "{FF8800}Вы успешно приобрели набор {FFFFFF}'Японская легенда'");
			GameText(playerid, "~r~~h~Успешно", 3000, 2);
		}
		case DIALOG_CASE_TWO:
		{
			if(!response) return 1;

			GameText(playerid, "~o~Успешно", 3000, 2);
			new random_case = RandomEx(1,10);
			switch(random_case)
			{
				case 1: GiveIteam(playerid, 258, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Форсаж`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 2: GiveIteam(playerid, 261, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Темные дела`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 3: GiveIteam(playerid, 272, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Велесова ночь`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 4: GiveIteam(playerid, 278, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Оперской`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 5: GiveIteam(playerid, 284, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Новогодний`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 6: GiveIteam(playerid, 290, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Черное золото`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 7: GiveIteam(playerid, 300, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Охотничий`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 8: GiveIteam(playerid, 328, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Египетская сила`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 9: GiveIteam(playerid, 344, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Велесова ночь 2`{4169e1}, взаимодействовать с ним можно через инвентарь");
				case 10: GiveIteam(playerid, 348, 1, 1, 0), SCM(playerid, -1, "* {4169e1}Вы успешно получили кейс {FFFFFF}`Рождественский Экспресс`{4169e1}, взаимодействовать с ним можно через инвентарь");
			}
		}
		case DIALOG_TYPE_MASK:
			{
				switch(listitem)
				{
					case 0:
					if(GetPlayerSkin(playerid) == GetPlayerData(playerid, P_OSKIN))
					{
					SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
					SendClientMessage(playerid, -1, "* Вы успешно сняли рабочую форму");
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					else
					{
					SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
					SendClientMessage(playerid, -1, "* Вы успешно надели рабочую форму");
					SetPlayerColorEx(playerid, team_colors[listitem + 1]);
					}
				    case 1:
					{
					if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 2);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					case 2:
					{
                    if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 4);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					case 3:
					{
					if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 8);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					case 4:
					{
					if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 12);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					case 5:
					{
					if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 23);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					case 6:
					{
					if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 29);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					case 7:
					{
					if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 11);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0xFFFFFF11);
					}
					case 8:
					{
					if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1) return GameText(playerid, "~w~Только для агентов ФСБ", 1000,2);
					SetPlayerSkin(playerid, 33);
					GameText(playerid, "~w~Маскировка успешно одета", 1000,2);
					SetPlayerColorEx(playerid, 0x170000AA);
					}
				}
			}
		case DIALOG_KEY_ONE:
		{
			if(!response) return 1;
			GiveIteam(playerid, 259, 1, 1, 0);
			GameText(playerid, "~o~Успешно", 3000, 2);
			SCM(playerid, -1, "* {4169e1}Вы успешно получили {FFFFFF}`Ключ от кейса`{4169e1}, взаимодействовать с ним можно через инвентарь");
		}
		case DIALOG_FREE_HEAL:
		{
			if(response)
			{
				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 2000000)) return SendClientMessage(playerid, 0xFF6600FF, "* Медицинская помощь стоит 2.000.000 рублей");
				{
					GivePlayerMoneyEx(playerid, -2000000, "Медицинская помощь");
					SetPlayerData(playerid, P_HEALTH, 70.0);
					SetPlayerHealthEx(playerid, 70.0);
					GameText(playerid, "~b~+70 здоровья", 4000, 2);
					ApplyAnimation(playerid, "ped", "gum_eat", 4.0, 0, 0, 0, 0, 0, 0);
					return 1;
				}
			}
		}
			case DIALOG_KEYSN: if(response) GiveIteam(playerid, 284, 1, 1, 0);
			case DIALOG_KEYST: if(response) GiveIteam(playerid, 261, 1, 1, 0);

			
			case DIALOG_SELL_MYSTALL:
			{
			    new idx = GetPlayerListitemValue(playerid, listitem) + 1;
			    new businessid = idx;
			    
			    new Float: g_pos_x = GetKioskData(businessid, K_POS_X);
				new Float: g_pos_y = GetKioskData(businessid, K_POS_Y);
				new Float: g_pos_z = GetKioskData(businessid, K_POS_Z);

				if(!(IsPlayerInRangeOfPoint(playerid, 7.0, g_pos_x, g_pos_y, g_pos_z) && IsPlayerInRangeOfPoint(GetPVarInt(playerid, "to_player"), 7.0, g_pos_x, g_pos_y, g_pos_z)))
					return SendClientMessage(playerid, 0xFF6600FF, "* Вы и покупатель должны находиться рядом с киоском который хотите продать");

			    SendPlayerOffer(playerid, GetPVarInt(playerid, "to_player"), OFFER_TYPE_SELL_KIOSK, businessid, GetPVarInt(playerid, "price"));
			}
			case DIALOG_SELL_ITEM_ACCEPT:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new item_id = GetPVarInt(playerid, "SellItem");
				new count = GetPVarInt(playerid, "SellItemCount");
				new price = GetPVarInt(playerid, "SellItemPrice");
				static query[512];

				mysql_format(mysql, query, sizeof query, "INSERT INTO kiosks_items (kiosk_id, item_id, owner_id, name, count, price) VALUES (%d, %d, %d, '%s', %d, %d)", GetKioskData(kiosk_id, K_SQL_ID), item_id, GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), count, price);
				mysql_query(mysql, query, false);

				GiveIteam(playerid, item_id, 0, count, 0, "Выставил предмет в киоск");

				SCM(playerid, 0xADCEEAFF, "Вы успешно выставили предмет на продажу");
			}
			case DIALOG_SELL_NUMBER_ACCEPT:
			{
				if(!response) return 1;
				new kiosk_id = GetNearestKiosk(playerid, 7.0);

				new slot = GetPVarInt(playerid, "SellItemSlot");
				new type = GetPVarInt(playerid, "SellItemType");

				new price = GetPVarInt(playerid, "SellItemPrice");
				static query[512], number[32], region[32], typenumber;

				for(new i; i < MAX_PLAYER_ITEMS; i++)
				{
					if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
					if(GetPlayerItem(i, PI_SLOTS) != slot) continue;
					if(GetPlayerItem(i, PI_TYPE) != type) continue;

					format(number, 32, "%s", GetPlayerItem(i, PI_NUMBER));
					format(region, 32, "%s", GetPlayerItem(i, PI_REGION));

					typenumber = GetPlayerItem(i, PI_TYPENUMBER);

					mysql_format(mysql, query, sizeof query, "INSERT INTO kiosks_items (kiosk_id, item_id, owner_id, name, count, price, number, region, typenumber, aks_id, typeacs, indx, skin_id, item_type) VALUES (%d, 0, %d, '%s', 1, %d, '%s', '%s', %d, 0, 0, 0, 0, 1)",
					GetKioskData(kiosk_id, K_SQL_ID), GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), price, number, region, typenumber);
					mysql_query(mysql, query, false);

					mysql_format(mysql, query, sizeof query, "DELETE FROM items WHERE slots=%d AND type=%d AND owner_id=%d LIMIT 1", slot, type, GetPlayerAccountID(playerid));
					mysql_query(mysql, query, false);

					DeleteItems(i);

					SCM(playerid, 0xADCEEAFF, "Вы успешно выставили автомобильный номер на продажу");
					return 1;
				}
			}
			case DIALOG_SELL_ACS_ACCEPT:
			{
				if(!response) return 1;
				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new slot = GetPVarInt(playerid, "SellItemSlot");
				new type = GetPVarInt(playerid, "SellItemType");
				new price = GetPVarInt(playerid, "SellItemPrice");
				static query[512], indx, aks_id, typeacs, status;

				for(new i; i < MAX_PLAYER_ITEMS; i++)
				{
					if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
					if(GetPlayerItem(i, PI_SLOTS) != slot) continue;
					if(GetPlayerItem(i, PI_TYPE) != type) continue;

					typeacs = GetPlayerItem(i, PI_TYPEACS);
					aks_id = GetPlayerItem(i, PI_AKS_ID);
					indx = GetPlayerItem(i, PI_INDX);
					status = GetPlayerItem(i, PI_STATUS);

					if(status == 0)
					{
						mysql_format(mysql, query, sizeof query, "INSERT INTO kiosks_items (kiosk_id, item_id, owner_id, name, count, price, aks_id, typeacs, indx, skin_id, item_type) VALUES (%d, 0, %d, '%s', 1, %d, %d, %d, %d, 0, 2)",
						GetKioskData(kiosk_id, K_SQL_ID), GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), price, aks_id, typeacs, indx);
						mysql_query(mysql, query, false);

						mysql_format(mysql, query, sizeof query, "DELETE FROM items WHERE slots=%d AND type=%d AND owner_id=%d LIMIT 1", slot, type, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						SCM(playerid, 0xADCEEAFF, "Вы успешно выставили аксессуар на продажу");

						DeleteItems(i);
					}
					else if(status == 1)
					{
						SCM(playerid, 0xADCEEAFF, "Для того чтобы продать аксессуар, нужно его снять");
					}
					return 1;
				}
			}
			case DIALOG_SELL_SKIN_ACCEPT:
			{
				if(!response) return 1;
				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new slot = GetPVarInt(playerid, "SellItemSlot");
				new type = GetPVarInt(playerid, "SellItemType");
				new price = GetPVarInt(playerid, "SellItemPrice");
				static query[512], skin_id;

				for(new i; i < MAX_PLAYER_ITEMS; i++)
				{
					if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
					if(GetPlayerItem(i, PI_SLOTS) != slot) continue;
					if(GetPlayerItem(i, PI_TYPE) != type) continue;

					skin_id = GetPlayerItem(i, PI_SKIN_ID);

					if(GetPlayerSkin(playerid) == skin_id) SetPlayerSkin(playerid, 252);

					mysql_format(mysql, query, sizeof query, "INSERT INTO kiosks_items (kiosk_id, item_id, owner_id, name, count, price, skin_id, item_type) VALUES (%d, 0, %d, '%s', 1, %d, %d, 3)",
					GetKioskData(kiosk_id, K_SQL_ID), GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), price, skin_id);
					mysql_query(mysql, query, false);

					mysql_format(mysql, query, sizeof query, "DELETE FROM items WHERE slots=%d AND type=%d AND owner_id=%d LIMIT 1", slot, type, GetPlayerAccountID(playerid));
					mysql_query(mysql, query, false);

					DeleteItems(i);

					SCM(playerid, 0xADCEEAFF, "Вы успешно выставили свою одежду на продажу");
					return 1;
				}
			}
			case DIALOG_STALL_BUY_ITEM_ACCEPT:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new item_id = GetPVarInt(playerid, "item_id");
				new price = GetPVarInt(playerid, "price");
				new count = GetPVarInt(playerid, "count");
				new count1 = GetPVarInt(playerid, "count1"); // сколько есть в бд
				new owner_id = GetPVarInt(playerid, "owner_id");
				new id = GetPVarInt(playerid, "id");

				if(GetStallItemsId(id) == -1) return SCM(playerid, COLOR_BLUENEW, "Данный предемет был продан или снят с продажи.");

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SCM(playerid, 0xADCEEAFF, "У вас недостаточно средств.");

				GivePlayerMoneyEx(playerid, -price, "Покупка предмета в киоске");

				format(g_kiosk[kiosk_id][K_BALANCE], 21, "%s", SetILPlayerInt(playerid, g_kiosk[kiosk_id][K_BALANCE], (price / 100) * GetKioskData(kiosk_id, K_NALOG)));

                static fmt_str_st[512];
				mysql_format(mysql, fmt_str_st, sizeof fmt_str_st, "UPDATE kiosk SET balance=%s WHERE id=%d", GetKioskData(kiosk_id, K_BALANCE),GetKioskData(kiosk_id, K_SQL_ID));
				mysql_query(mysql, fmt_str_st, false);

				GiveIteam(playerid, item_id, 1, count, 0);

				MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Stall");

				if(count1 - count != 0)
				{
					static query[512];
					format(query, sizeof query, "UPDATE kiosks_items SET count=%d WHERE id=%d LIMIT 1", count1 - count, id);
					mysql_query(mysql, query, false);
				}
				else
				{
					static query[512];
					mysql_format(mysql, query, sizeof query, "DELETE FROM kiosks_items WHERE id=%d", id);
					mysql_query(mysql, query, false);
				}

				new to_player = GetPlayerIDBySqlID(owner_id);

				if(IsPlayerConnected(to_player) && IsPlayerLogged(to_player))
				{
					GivePlayerMoneyEx(to_player, price - ((price / 100) * GetKioskData(kiosk_id, K_NALOG)), "продажа предмета в киоске");
					SCM(to_player, 0xADCEEAFF, "Ваш предмет в киоске приобрели.");
				}
				else
				{
					static fmt_str[512];

					format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens SET bank = bank + %d WHERE id=%d LIMIT 1", price - ((price / 100) * GetKioskData(kiosk_id, K_NALOG)), owner_id);
					mysql_query(mysql, fmt_str, false);
				}

			}
			case DIALOG_STALL_BUY_ITEM:
			{
				if(!response) return 1;

				new count = strval(inputtext);
				new item_id = GetPVarInt(playerid, "item_id");
				new price = GetPVarInt(playerid, "price");
				new have_count = GetPVarInt(playerid, "count");
				new id = GetPVarInt(playerid, "id");
				static str_c[268];

				if(GetStallItemsId(id) == -1) return SCM(playerid, COLOR_BLUENEW, "*Данный предемет был продан или снят с продажи.");

				if(count < 1) return SCM(playerid, 0xADCEEAFF, "*Некорректное количество товара.");

				if(count > have_count) return SCM(playerid, 0xADCEEAFF, "*В этом киоске нет этого товара в таком количестве.");

				if(count > 25) return SCM(playerid, COLOR_RED, "* За раз можно купить до 25 вещей!"), DLGF(playerid, DIALOG_STALL_BUY_ITEM, DIALOG_STYLE_INPUT, "Покупка предмета", "{FFFFFF}Сколько вы желаете приобрести?\nНа продаже: {006400}%d {FFFFFF}ед.", "Далее", "Назад", count);

				new sellprice = price * count;

				SetPVarInt(playerid, "price", sellprice);
				SetPVarInt(playerid, "count", count);

				format(str_c, sizeof str_c, "{FFFFFF}Товар: {FECC00}'%s'\n{FFFFFF}Количество: {FECC00}%d\n{FFFFFF}Стоимость: {FECC00}%d руб.", ItemsInfo[item_id][i_item_name], count, sellprice);
				Dialog(playerid, DIALOG_STALL_BUY_ITEM_ACCEPT, DIALOG_STYLE_MSGBOX, "Желаете приобрести?", str_c, "Да", "Нет");
			}
			case DIALOG_SET_ELECT:
			{
				if(!response) return 1;
				SCM(playerid, 0xADCEEAFF, "{4aba16}Вы успешно переоделись в рабочую одежду");
				SCM(playerid, 0xADCEEAFF, "{FFFFFF}Садитесь в рабочий транспорт, чтобы начать работу {ffa500}электриком");
				SetPVarInt(playerid, "Electrickrabota", 1);
			}
			case DIALOG_SET_ELECT2:
			{
				if(!response) return 1;
				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 1500)) return SendClientMessage(playerid, 0xFF6600FF, "*  У вас недостаточно денег");
				GivePlayerMoneyEx(playerid, -1500, "", true, true);
				SendClientMessage(playerid, 0x66CC00FF, "* Для того, чтобы начать работу электрика {FF9900}нажмите ~k~~TOGGLE_SUBMISSIONS~");
			}
			case DIALOG_SET_NALOG:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new nalog = strval(inputtext);
				static query[512];

				if(nalog < 1) return SCM(playerid, 0xCECECEFF, "* Налог не должен быть меньше 1 процента.");
				if(nalog > 25) return SCM(playerid, 0xCECECEFF, "* Налог не должен превышать 25 процентов.");

				mysql_format(mysql, query, sizeof query, "UPDATE kiosk SET nalog=%d WHERE id=%d", nalog, GetKioskData(kiosk_id, K_SQL_ID));
				mysql_query(mysql, query, false);

				SetKioskData(kiosk_id, K_NALOG, nalog);

				SCMF(playerid, 0xADCEEAFF, "Вы успешно поставили налог в {FFFFFF}%d процентов", nalog);
			}
			case DIALOG_REMOVE_OWNED_ITEM:
			{
				if(!response) return 1;

				new item_id = GetPVarInt(playerid, "item_id");
				new count = GetPVarInt(playerid, "count");
				static query[512];

				GiveIteam(playerid, item_id, 1, count, 0);

				SCM(playerid, 0xADCEEAFF, "Вы сняли ваш предмет с продажи.");

				mysql_format(mysql, query, sizeof query, "DELETE FROM kiosks_items WHERE id=%d", GetPVarInt(playerid, "id"));
				mysql_query(mysql, query, false);

				MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Stall");
			}
			case DIALOG_REMOVE_STALL_ITEM:
			{
				if(!response) return DeletePVar(playerid, "RemoveItem");

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new item_id = GetPVarInt(playerid, "RemoveItem");

				static query[264], 
					number[32], 
					region[32], 
					Cache:result;

				SCM(playerid, 0xADCEEAFF, "Вы сняли предмет с продажи");

				format(query, sizeof query, "SELECT * FROM kiosks_items WHERE kiosk_id=%d AND id=%d", kiosk_id, GetPVarInt(playerid, "ItemSQLid"));
				result = mysql_query(mysql, query, true);

				cache_get_field_content(0, "region", region);
				cache_get_field_content(0, "number", number);

				new owner_id = cache_get_field_content_int(0, "owner_id");
				new count = cache_get_field_content_int(0, "count");
				new typenumber = cache_get_field_content_int(0, "typenumber");
				new aks_id = cache_get_field_content_int(0, "aks_id");
				new typeacs = cache_get_field_content_int(0, "typeacs");
				new indx = cache_get_field_content_int(0, "indx");
				new skin_id = cache_get_field_content_int(0, "skin_id");
				new item_type = cache_get_field_content_int(0, "item_type");
				new player = GetPlayerIDBySqlID(owner_id);

				cache_delete(result);

				if(IsPlayerConnected(player) && IsPlayerLogged(player))
				{
					SCM(player, 0xABCDEFFF, "Пока вы находились вне игры, вам вернули товары из киоска, используйте {FFFFFF}/return_items {ABCDEF}чтобы забрать их.");

					if(item_type == 0) GiveIteam(player, item_id, 1, count, 0);

					if(item_type == 1)
					{
						CreateItemsCarNumber(GetPlayerAccountID(player), 1, -1, -1, number, region, typenumber, -1, -1, 0, 1);
					}
					if(item_type == 2)
					{
						CreateItemsAcs(GetPlayerAccountID(player), 1, -1, -1, aks_id, typeacs, 0, indx, -1, -1, 0, 2);
					}
					if(item_type == 3)
					{

						CreateItemsSkin(GetPlayerAccountID(player), 1, -1, -1, skin_id, 0, -1, -1, 0, 3);
					}
				}
				else
				{
					if(item_type == 1)
					{
						CreateItemsCarNumber(owner_id, 1, -1, -1, number, region, typenumber, -1, -1, 0, 1);
					}
					if(item_type == 2)
					{
						CreateItemsAcs(owner_id, 1, -1, -1, aks_id, typeacs, 0, indx, -1, -1, 0, 2);
					}
					if(item_type == 3)
					{
						CreateItemsSkin(owner_id, 1, -1, -1, skin_id, 0, -1, -1, 0, 3);
					}
				}
				format(query, sizeof query, "DELETE FROM kiosks_items WHERE id=%d", GetPVarInt(playerid, "ItemSQLid"));
				mysql_query(mysql, query, false);

				DeletePVar(playerid, "RemoveItem");
				DeletePVar(playerid, "ItemSQLid");
			}
			
			case DIALOG_BUY_STALL:
			{
				if(!response) return 1;
				
				new kiosk_id = GetPVarInt(playerid, "buy_stall");

				if((GetPlayerOwnableKiosk(playerid) + 1) > GetPlayerKioskSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество бизнес компаний.");
				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), GetKioskData(kiosk_id, K_PRICE))) return SCM(playerid, -1, "* Недостаточно средств.");

				static query[512];

				//SetPlayerData(playerid, P_KIOSK, kiosk_id);
				//UpdatePlayerDatabaseInt(playerid, "kiosk", kiosk_id);

				SetKioskData(kiosk_id, K_OWNER_ID, GetPlayerAccountID(playerid));

				mysql_format(mysql, query, sizeof query, "UPDATE kiosk SET owner_id=%d WHERE id=%d", GetPlayerAccountID(playerid), GetKioskData(kiosk_id, K_SQL_ID));
				mysql_query(mysql, query, false);

				GivePlayerMoneyEx(playerid, -GetKioskData(kiosk_id, K_PRICE));

				SCMF(playerid, 0x499E3DFF, "Поздравляем! {FFFFFF}Вы успешно приобрели киоск {499E3D}№%d {FFFFFF}за {499E3D}%d руб.", kiosk_id, GetKioskData(kiosk_id, K_PRICE));

				SCM(playerid, 0xADCEEAFF, "Если вы хотите изменить название киоска, воспользуйтесь командой {FFFFFF}/changestallname");
				SCM(playerid, 0xADCEEAFF, "Если вы захотите продать киоск, воспользуйтесь командой {FFFFFF}/sellstall");
				SCM(playerid, 0xADCEEAFF, "Для управления киоском подойдите к нему и нажмите клавишу {FFFFFF}ALT");
				SCM(playerid, 0xADCEEAFF, "Не забывайте регулярно проводить уборку в киоске, иначе он может ломаться и потеряет улучшения.");
			}
   			case 0:
			{
				switch(listitem)
				{

				}
				return 1;
   				}
			case DIALOG_CREATE_GUN:
			{
				if(response)
				{
					if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 100000)) return SendClientMessage(playerid, 0xFF6600FF, "* У вас недостаточно денег для крафта");
					if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xFF6600FF, "* Крафтить АК-47 можно со 2 лвла");
					{
					    SetPVarInt(playerid, "ak47", 1);
						GivePlayerMoneyEx(playerid, -100000, "Крафт оружия", true, true);
                        MoralPacket_2(playerid, s_CefInterface, t_CefShow, "WeaponAssembly", "[2]");
                        GameText(playerid, "~r~~h~Cоберите АК-47", 3000, 1);
			            return 1;
					}
                }
			}
			
			case DIALOG_CREATE_GUN1:
			{
				if(response)
				{
					if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 100000)) return SendClientMessage(playerid, 0xFF6600FF, "* У вас недостаточно денег для крафта");
					if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xFF6600FF, "* Крафтить Deagle можно со 2 лвла");
					{
					    SetPVarInt(playerid, "deagle", 1);
						GivePlayerMoneyEx(playerid, -100000, "Крафт оружия", true, true);
                        MoralPacket_2(playerid, s_CefInterface, t_CefShow, "WeaponAssembly", "[0]");
                        GameText(playerid, "~r~~h~Cоберите Deagle", 3000, 1);
			            return 1;
					}
                }
			}
			case DIALOG_CREATE_GUN2:
			{
				if(response)
				{
					if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 100000)) return SendClientMessage(playerid, 0xFF6600FF, "* У вас недостаточно денег для крафта");
					if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xFF6600FF, "* Крафтить M4 можно со 2 лвла");
					{
					    SetPVarInt(playerid, "m4", 1);
						GivePlayerMoneyEx(playerid, -100000, "Крафт оружия", true, true);
                        MoralPacket_2(playerid, s_CefInterface, t_CefShow, "WeaponAssembly", "[1]");
                        GameText(playerid, "~r~~h~Cоберите M4", 3000, 1);
			            return 1;
					}
                }
			}
			case DIALOG_CREATE_GUN3:
			{
				if(response)
				{
					if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 100000)) return SendClientMessage(playerid, 0xFF6600FF, "* У вас недостаточно денег для крафта");
					if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xFF6600FF, "* Крафтить Shotgun можно со 2 лвла");
					{
					    SetPVarInt(playerid, "shotgun", 1);
						GivePlayerMoneyEx(playerid, -100000, "Крафт оружия", true, true);
                        MoralPacket_2(playerid, s_CefInterface, t_CefShow, "WeaponAssembly", "[3]");
                        GameText(playerid, "~r~~h~Cоберите Shotgun", 3000, 1);
			            return 1;
					}
                }
			}
			case DIALOG_ANTISKLAD:
			{
			    /*if(response)
			    {
					ResetPlayerWeapons(playerid);
					GivePlayerMoneyEx(playerid, 150000, "Продажа оружия", true, true);
					if(GetPVarInt(playerid,"Bonus") > gettime() ) return SendClientMessage(playerid, 0x999999FF, "* Кейсы можно получать раз в день");
					SCM(playerid, 0xCECECEFF, !"Поздравляем! Вы получили кейс 'Темные дела'");
					GiveIteam(playerid, 261, 1, 1, 0);
					SetPVarInt(playerid,"Bonus",gettime() + 8640);
					return 1;
				}*/
			}
			case DIALOG_AXICRINGE:
			{
   				switch(listitem)
				{
					case 0:
					{
					GivePlayerMoneyEx(playerid, -500000, "аренда авто", true,true);
				 	SetPlayerData(playerid, P_TAXIST, 1);
				 	UpdatePlayerDatabaseInt(playerid, "taxist", 1);
					SendClientMessageToAll(playerid, "{ff8c00}Аренда авто, -500.000р");
					}
					case 1:
					{
	                SendClientMessageToAll(playerid, "{ff8c00}Очень жаль...");
					}
				}
				return 1;
			}
			case DIALOG_VARKA_DRUGS:
			{
			    if(response)
			    {
			        if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 100000)) return SendClientMessage(playerid, 0xFF6600FF, "* У вас недостаточно денег для варки");
			        if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xFF6600FF, "* Варить наркотики можно со 2 лвла");
					{
						GivePlayerMoneyEx(playerid, -100000, "Варка наркотиков", true, true);
						new drugs = RandomEx(5, 70);

						switch(drugs)
						{
							case 5..20: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[0]");
							case 21..32: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[1]");
							case 33..40: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[2]");
							case 41..47: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[3]");
							case 48..60: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[4]");
							case 61..70: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[5]");
							case 71..87: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[0]");
							case 88..99: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[1]");
							case 100..111: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[2]");
							case 112..120: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[3]");
							case 121..140: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[4]");
							case 141..148: MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Drugs", "[5]");
						}
						GiveIteam(playerid, 25, 1, 10, 0);
                        GameText(playerid, "~r~~h~Сварите наркотики", 3000, 1);
			            return 1;
					}
				}
			}
			case DIALOG_STAGES_1:
			{
				if(response)
				{
		    		new vehicleid = GetPlayerVehicleID(playerid);
		    		if(IsValidDynamicObject(EditStage1Player[vehicleid])) DestroyDynamicObject(EditStage1Player[vehicleid]);
		    	    new index = GetVehicleData(vehicleid, V_ACTION_ID);
		    	    SetOwnableCarData(index, OC_STAGE1, 0);

					SetOwnableCarData(index, OC_ENGINE_ACCELERATION, GetOwnableCarData(index, OC_ENGINE_ACCELERATION) + 10.0);
					SetOwnableCarData(index, OC_MAX_VELOCITY, GetOwnableCarData(index, OC_MAX_VELOCITY) + 20.0);
					SaveOwnableCar(vehicleid);

					UpdateVehicleHandling(playerid, vehicleid);

		    	    SetOwnableCarData(index, OC_STAGE, 0);
					static fmt_text[256];
        			mysql_format(mysql, fmt_text, sizeof fmt_text,
            		"UPDATE ownable_cars SET stage3=0, stage=3, engineacceleration=%, maxgearvelocity=%f WHERE id=%d LIMIT 1",
            		GetOwnableCarData(index, OC_ENGINE_ACCELERATION),
            		GetOwnableCarData(index, OC_MAX_VELOCITY),
            		GetOwnableCarData(index, OC_SQL_ID)
        			);
        			mysql_query(mysql, fmt_text, false);
					GivePlayerMoneyEx(playerid, 0);
				}
				else
				{
   					SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
					SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);
				}
		    }
		    case DIALOG_STAGES_1_1:
			{
				if(response)
				{
		    		new vehicleid = GetPlayerVehicleID(playerid);
		    		if(IsValidDynamicObject(EditStage1_1Player[vehicleid])) DestroyDynamicObject(EditStage1_1Player[vehicleid]);
		    	    new index = GetVehicleData(vehicleid, V_ACTION_ID);
		    	    SetOwnableCarData(index, OC_STAGE1_1, 0);

					SetOwnableCarData(index, OC_ENGINE_ACCELERATION, GetOwnableCarData(index, OC_ENGINE_ACCELERATION) + 15.0);
					SetOwnableCarData(index, OC_MAX_VELOCITY, GetOwnableCarData(index, OC_MAX_VELOCITY) + 30.0);
					SaveOwnableCar(vehicleid);

					UpdateVehicleHandling(playerid, vehicleid);

		    	    SetOwnableCarData(index, OC_STAGE, 1);
					static fmt_text[256];
        			mysql_format(mysql, fmt_text, sizeof fmt_text,
            		"UPDATE ownable_cars SET stage3=0, stage=3, engineacceleration=%f, maxgearvelocity=%f WHERE id=%d LIMIT 1",
            		GetOwnableCarData(index, OC_ENGINE_ACCELERATION),
            		GetOwnableCarData(index, OC_MAX_VELOCITY),
            		GetOwnableCarData(index, OC_SQL_ID)
        			);
        			mysql_query(mysql, fmt_text, false);
					GivePlayerMoneyEx(playerid, 0);
				}
				else
				{
   					SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
					SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);
				}
		    }
		    case DIALOG_STAGES_2:
			{
				if(response)
				{
		    		new vehicleid = GetPlayerVehicleID(playerid);
		    		if(IsValidDynamicObject(EditStage2Player[vehicleid])) DestroyDynamicObject(EditStage2Player[vehicleid]);
		    	    new index = GetVehicleData(vehicleid, V_ACTION_ID);

		    	    SetOwnableCarData(index, OC_STAGE2, 0);

					SetOwnableCarData(index, OC_ENGINE_ACCELERATION, GetOwnableCarData(index, OC_ENGINE_ACCELERATION) + 25.0);
					SetOwnableCarData(index, OC_MAX_VELOCITY, GetOwnableCarData(index, OC_MAX_VELOCITY) + 40.0);
					SaveOwnableCar(vehicleid);

					UpdateVehicleHandling(playerid, vehicleid);

		    	    SetOwnableCarData(index, OC_STAGE, 2);
					static fmt_text[256];
        			mysql_format(mysql, fmt_text, sizeof fmt_text,
            		"UPDATE ownable_cars SET stage3=0, stage=3, engineacceleration=%f, maxgearvelocity=%f WHERE id=%d LIMIT 1",
            		GetOwnableCarData(index, OC_ENGINE_ACCELERATION),
            		GetOwnableCarData(index, OC_MAX_VELOCITY),
            		GetOwnableCarData(index, OC_SQL_ID)
        			);
        			mysql_query(mysql, fmt_text, false);
					GivePlayerMoneyEx(playerid, 0);
				}
				else
				{
   					SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
					SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);
				}
		    }
		    case DIALOG_STAGES_3:
			{
				if(response)
				{
		    		new vehicleid = GetPlayerVehicleID(playerid);
		    		if(IsValidDynamicObject(EditStage3Player[vehicleid])) DestroyDynamicObject(EditStage3Player[vehicleid]);
		    	    new index = GetVehicleData(vehicleid, V_ACTION_ID);
		    	    SetOwnableCarData(index, OC_STAGE3, 0);
		    	    SetOwnableCarData(index, OC_STAGE, 3);

					SetOwnableCarData(index, OC_ENGINE_ACCELERATION, GetOwnableCarData(index, OC_ENGINE_ACCELERATION) + 25.0);
					SetOwnableCarData(index, OC_MAX_VELOCITY, GetOwnableCarData(index, OC_MAX_VELOCITY) + 100.0);
					SaveOwnableCar(vehicleid);

					UpdateVehicleHandling(playerid, vehicleid);

					static fmt_text[256];
        			mysql_format(mysql, fmt_text, sizeof fmt_text,
            		"UPDATE ownable_cars SET stage3=0, stage=3, engineacceleration=%f, maxgearvelocity=%f WHERE id=%d LIMIT 1",
            		GetOwnableCarData(index, OC_ENGINE_ACCELERATION),
            		GetOwnableCarData(index, OC_MAX_VELOCITY),
            		GetOwnableCarData(index, OC_SQL_ID)
        			);
        			mysql_query(mysql, fmt_text, false);
					GivePlayerMoneyEx(playerid, 0);
				}
				else
				{
   					SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
					SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);
				}
		    }
   			case DIALOG_STAGE_1:
			{
			    if(!response) return 1;

			    new Float:x, Float:y, Float:z;
			    new vehicleid = GetPlayerVehicleID(playerid);
			    if(vehicleid == 0) return SendClientMessage(playerid, 0xFF0000AA, "Вы не в машине.");
			    new idx = GetVehicleData(vehicleid, V_ACTION_ID);
			    GetVehiclePos(vehicleid, x, y, z);

			    switch(listitem + 1)
			    {
			        case 1,2,5,7:
						{
							string_dialog[0] = EOS;
							format(string_dialog, sizeof string_dialog,
							"{E4E4DF}Деталь \t{E4E4DF}Статус \t{E4E4DF}Стоимость \n\n\n{F6B243}Комплект STAGE 1 \n{E4E4DF}Радиатор \t%s \t{91D643}3.500.000 руб\n{E4E4DF}Выхлоп \t%s \t{91D643}3.500.000 руб\n\n\n{946A1F}Комплект STAGE 2 \n{5C5D5C}Турбина \t%s \t{55703F}20.000.000 руб\n\n\n{946A1F}Комплект STAGE 3 \n{5C5D5C}Нагнетатель \t%s \t{55703F}40.000.000 руб\n",
							GetOwnableCarData(idx, OC_STAGE1) ? ("{00CC00}Устонавлено")  : ("{AF9795}Не устонавлено"),
							GetOwnableCarData(idx, OC_STAGE1_1) ? ("{00CC00}Устонавлено")  : ("{AF9795}Не устонавлено"),
							GetOwnableCarData(idx, OC_STAGE2) ? ("{00CC00}Устонавлено")  : ("{AF9795}Не устонавлено"),
							GetOwnableCarData(idx, OC_STAGE3) ? ("{00CC00}Устонавлено")  : ("{AF9795}Не устонавлено")
							);

			            	Dialog(playerid, DIALOG_STAGE_1, DIALOG_STYLE_LIST, "{F6CC3F}Элементы установки", string_dialog, "Выбор", "Отмена");
			            	return 1;
			        }

			        case 3:
			        {
			            if(stagestats[playerid] == 1)
			            {
			                if(GetOwnableCarData(idx, OC_STAGE1) == 1)
			                {
			                    Dialog(playerid, DIALOG_STAGES_1, 0,
			                        "{F6CC3F}Элементы установки",
			                        "{E4E4DF}Вы действительно хотите снять компонент STAGE 1 'Радиатор'<n>\
			                        Вам будет возвращено: 0 рублей",
			                        "Выбор", "Отмена"
			                    );
			                    return 1;
			                }
			                else
			                {
			                    if(IsValidDynamicObject(EditStage1Player[vehicleid])) DestroyDynamicObject(EditStage1Player[vehicleid]);
			                    SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
			                    SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);

			                    EditStage1Player[vehicleid] = CreateDynamicObject(10443, x, y, z, 0.0, 0.0, 180.0);
			                    SetPVarInt(playerid, "stage_edit_1", 1);
			                    SetPVarInt(playerid, "model_id", 10443);
			                    EditDynamicObject(playerid, EditStage1Player[vehicleid]);
			                    return 1;
			                }
			            }
			        }

			        case 4:
			        {
			            if(stagestats[playerid] == 1)
			            {
			                if(GetOwnableCarData(idx, OC_STAGE1_1) == 1)
			                {
			                    Dialog(playerid, DIALOG_STAGES_1_1, 0,
			                        "{F6CC3F}Элементы установки",
			                        "{E4E4DF}Вы действительно хотите снять компонент STAGE 1 'Выхлоп'<n>\
			                        Вам будет возвращено: 0 рублей",
			                        "Выбор", "Отмена"
			                    );
			                    return 1;
			                }
			                else if(GetOwnableCarData(idx, OC_STAGE1) == 1)
			                {
			                    if(IsValidDynamicObject(EditStage1_1Player[vehicleid])) DestroyDynamicObject(EditStage1_1Player[vehicleid]);
			                    SetPlayerCameraPos(playerid,2337.7588,-2617.0513,1003.1210);
			                    SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);

			                    EditStage1_1Player[vehicleid] = CreateDynamicObject(10442, x, y, z, 0.0, 0.0, 180.0);
			                    SetPVarInt(playerid, "stage_edit_1_1", 1);
			                    SetPVarInt(playerid, "model_id", 10442);
			                    EditDynamicObject(playerid, EditStage1_1Player[vehicleid]);
			                    return 1;
			                }
			            }
			        }
			        case 6:
			        {
			            if(stagestats[playerid] == 2)
			            {
			                if(GetOwnableCarData(idx, OC_STAGE2) == 1)
			                {
			                    Dialog(playerid, DIALOG_STAGES_2, 0,
			                        "{F6CC3F}Элементы установки",
			                        "{E4E4DF}Вы действительно хотите снять компонент STAGE 2 'Турбина'<n>\
			                        Вам будет возвращено: 0 рублей",
			                        "Выбор", "Отмена"
			                    );
			                    return 1;
			                }
			                else if(GetOwnableCarData(idx, OC_STAGE1) == 1 && GetOwnableCarData(idx, OC_STAGE1_1) == 1)
			                {
			                    if(IsValidDynamicObject(EditStage2Player[vehicleid])) DestroyDynamicObject(EditStage2Player[vehicleid]);
			                    SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
			                    SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);

			                    EditStage2Player[vehicleid] = CreateDynamicObject(10445, x, y, z, 0.0, 0.0, 180.0);
			                    SetPVarInt(playerid, "stage_edit_2", 1);
			                    SetPVarInt(playerid, "model_id", 10445);
			                    EditDynamicObject(playerid, EditStage2Player[vehicleid]);
			                    return 1;
			                }
			            }
			        }

			        case 8:
			        {
			            if(stagestats[playerid] == 3)
			            {
			                if(GetOwnableCarData(idx, OC_STAGE3) == 1)
			                {
			                    Dialog(playerid, DIALOG_STAGES_3, 0,
			                        "{F6CC3F}Элементы установки",
			                        "{E4E4DF}Вы действительно хотите снять компонент STAGE 3 'Нагнетатель'<n>\
			                        Вам будет возвращено: 0 рублей",
			                        "Выбор", "Отмена"
			                    );
			                    return 1;
			                }
			                else if(GetOwnableCarData(idx, OC_STAGE1) == 1 && GetOwnableCarData(idx, OC_STAGE1_1) == 1 && GetOwnableCarData(idx, OC_STAGE2) == 1)
			                {
			                    if(IsValidDynamicObject(EditStage3Player[vehicleid])) DestroyDynamicObject(EditStage3Player[vehicleid]);
			                    SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
			                    SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);

			                    EditStage3Player[vehicleid] = CreateDynamicObject(10444, x, y, z, 0.0, 0.0, 180.0);
			                    SetPVarInt(playerid, "stage_edit_3", 1);
			                    SetPVarInt(playerid, "model_id", 10444);
			                    EditDynamicObject(playerid, EditStage3Player[vehicleid]);
			                    return 1;
			                }
			            }
			        }
				}
			}
			case DIALOG_OWNABLE_BIZ_OPLATA:
			{
				if(response)
				{
				    new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				    SetPVarInt(playerid, "ownablebiz_id", idx);
				    ShowPlayerBusinessPayForRent(playerid);
				}
			}
			case DIALOG_OWNABLE_KIOSK_OPLATA:
			{
				if(response)
				{
				    new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				    SetPVarInt(playerid, "ownablekiosk_id", idx);
				    ShowPlayerKioskPayForRent(playerid);
				}
			}
         case DIALOG_GARDEN_SELL:
			{
				new garden = GetPVarInt(playerid, "garden_id");
				if(garden != -1)
				{
					if(response)
					{
						SellGarden(playerid,garden);
					}
				}
			}
			case DIALOG_RULLET_SHOW:
			{
				if(!response) return 1;

				if(IsPlayerInRangeOfPoint(playerid, 2.5, 223.4474,-302.4741,1012.0385))
				{
					RouletteTable[playerid] = 1;
					InterpolateCameraPos(playerid, 226.078033, -302.750885, 1011.523315, 225.375091, -302.632354, 1013.522888, 1000);
					InterpolateCameraLookAt(playerid, 221.130889, -302.555145, 1010.825195, 221.801132, -302.647369, 1010.026245, 1000);
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.5, 223.1531,-296.3004,1012.0284))
				{
					RouletteTable[playerid] = 2;
					InterpolateCameraPos(playerid, 226.246841, -296.717224, 1011.795837, 225.492965, -296.621063, 1013.492187, 1000);
					InterpolateCameraLookAt(playerid, 221.296600, -296.629730, 1011.097717, 221.715301, -296.595642, 1010.216735, 1000);
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.5, 207.7382,-296.5287,1012.0684))
				{
					RouletteTable[playerid] = 3;
					InterpolateCameraPos(playerid, 205.489654, -296.730712, 1011.446472, 205.750213, -296.680328, 1013.723571, 1000);
					InterpolateCameraLookAt(playerid, 210.484100, -296.722320, 1011.210998, 209.323822, -296.732971, 1010.226928, 1000);
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.5, 207.9463,-303.3881,1012.0385))
				{
					RouletteTable[playerid] = 4;
					InterpolateCameraPos(playerid, 204.530761, -303.071838, 1011.295043, 205.576446, -303.171691, 1013.490661, 1000);
					InterpolateCameraLookAt(playerid, 209.524154, -303.174743, 1011.059570, 209.493804, -303.188140, 1010.383544, 1000);
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.5, 191.6914,-293.2050,1012.8684))
				{
					RouletteTable[playerid] = 5;
					InterpolateCameraPos(playerid, 191.356338, -296.251281, 1012.188903, 191.293655, -295.537445, 1014.428344, 1000);  //
					InterpolateCameraLookAt(playerid, 191.410964, -291.255920, 1011.980712, 191.314788, -291.671630, 1011.257385, 1000);
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.5, 201.4565,-331.6115,1012.0385))
				{
					RouletteTable[playerid] = 6;
					InterpolateCameraPos(playerid, 204.557525, -331.987152, 1011.129333, 203.738037, -331.871582, 1013.848327, 1000);
					InterpolateCameraLookAt(playerid, 199.560974, -331.924133, 1011.303894, 200.052810, -331.764617, 1010.470825, 1000);
				}
				RulletShow(playerid);
				return 1;
			}
			case DIALOG_MINER_BUY_METALL:
			{
				if(!response) return 1;

				if(strval(inputtext) < 1) return SCM(playerid, COLOR_GREY, "* Некорректное количество."), ShowPlayerBuyMetalDialog(playerid);
				if(strval(inputtext) > 1000) return SCM(playerid, COLOR_GREY, "* Можно купить от 1 до 1000 кг металла за раз."), ShowPlayerBuyMetalDialog(playerid);
				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), strval(inputtext) * 500000)) return SCM(playerid, COLOR_GREY, "* Недостаточно средств для покупки металла.");
		
				if(GetInventorySlots(playerid) == -1) return SCM(playerid, COLOR_GREY, "* В вашем инвентаре нет свободного места"), ShowPlayerBuyMetalDialog(playerid);

				SCMF(playerid, 0x3584ccFF, "Вы купили %d кг за %s рублей", strval(inputtext), formatInt(strval(inputtext) * 500000));

				GivePlayerMoneyEx(playerid, -(strval(inputtext) * 500000), "Покупка металла");
				GiveIteam(playerid, 27, 1, strval(inputtext), 0);
			}
			case DIALOG_MVDPICKUP:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
	 				 		SendClientMessage(playerid, 0xAA3333AA, "Бегите пока не поздно!");
						}
						case 1:
						{
							SendClientMessage(playerid, 0xAA3333AA, "Свяжитесь с сотрудником МВД!");
							return 1;
						}
					}
				}
			}
			case DIALOG_REMONT:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
							Dialog(playerid, DIALOG_IZNOS, DIALOG_STYLE_INPUT, "Снятие износа", "Сколько износа вам нужно убрать?", "Далее", "Отмена");
						}
					}
				}
			}
            case DIALOG_EXIT_METRO:
			{	
				if(!response) return 1;
				LeaveWorkTrain(playerid);
			}
			case DIALOG_INVITE_METRO:
			{
			    if(response)
			    {
					if(metro_user >= 5) return SendClientMessage(playerid, 0x7f7f7fFF, "На маршруте нет свободных мест");
					if(metro_status == 1) return SendClientMessage(playerid, 0x7f7f7fFF, "В депо метрополитена нет мест,подождите пока займут электропоезд");
					SetPVarInt(playerid, "Metro_work",1);
					SetPVarInt(playerid, "Metro_start",1);
					metro_user += 1;
					metro_status = 1;
					metro_train[playerid] = AddStaticVehicleEx(537,-394.6066,475.2843,12.0387,90.0,17,17, -1); //поезд метро
					SetPlayerCheckpoint(playerid, -392.5566,482.6591,12.0604, 2.0, CP_ACTION_TYPE_PUT_TRAIN);
					SetVehicleParam(metro_train[playerid], V_ENGINE, VEHICLE_PARAM_ON);
				}
			}
            case DIALOG_DONATE_LEVEL:
			{
				if(response)
				{
      					new level = strval(inputtext);

						if(0 <= level <= 999 && IsNumeric(inputtext))
						{
						    if(GetPlayerCurrentDonate(playerid) < 50)
							{
		
							    static fmt_text[300];
								format(fmt_text, sizeof fmt_text, "Недостаточно средств.Сейчас на Вашем счету %d.00 руб", GetPlayerCurrentDonate(playerid));
								SendClientMessage(playerid, 0xFF6600FF, fmt_text);

								Dialog
								(
									playerid, DIALOG_DONATE_LEVEL, DIALOG_STYLE_INPUT,
									"Покупка игрового уровня",
									"{FFFFFF}Цена игрового уровня - 50 руб\n"\
									"Укажите уровень от 0 до 999",
									"Далее", "Отмена"
								);
								return 1;
							}
                            SetPlayerData(playerid, P_LEVEL, level);

							SetPlayerScore(playerid, level);
							static fmt_msg[128];
							mysql_format(mysql, fmt_msg, sizeof fmt_msg, "UPDATE PlayersMorallwens SET level=%d WHERE id=%d", GetPlayerLevel(playerid),GetPlayerAccountID(playerid));
							mysql_query(mysql, fmt_msg, false);
							GivePlayerDonate(playerid, -25, "Покупка уровня", true, true);
						}
						else
						{
							Dialog
							(
								playerid, DIALOG_DONATE_LEVEL, DIALOG_STYLE_INPUT,
								"Покупка игрового уровня",
								"{FFFFFF}Цена игрового уровня - 50 руб\n"\
								"Укажите уровень от 0 до 999",
								"Далее", "Отмена"
							);
						}
				}
				else
				{
    			ShowPlayerDonateMenu(playerid);
				}
			}
			case DIALOG_POBEG_MAFIA_RUSSIAN:
			{
			   	if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 15000000))
			    {
				    SendClientMessage(playerid, 0xf4ba5bFF, "Вы сбежали из подвала, быстрее убегайте с территории мафии!");
				    SetPlayerPosEx(playerid, 1949.1350,-48.5137,6.4177,182.6890, 0, 0);
			    	SetPlayerData(playerid, P_TURMA, 0);
					UpdatePlayerDatabaseInt(playerid, "turma", 0);
					GivePlayerMoneyEx(playerid, -15000000, "Побег", true, true);
				}
				else SendClientMessage(playerid, 0xf4ba5bFF, "У вас нету 15.000.000");
			}
			case DIALOG_POBEG_MAFIA_ITALIA:
			{
			    if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 15000000))
			    {
				    SendClientMessage(playerid, 0xf4ba5bFF, "Вы сбежали из подвала, быстрее убегайте с территории мафии!");
				    SetPlayerPosEx(playerid, -3178.0903,829.0162,6.4273,274.5032, 0, 0);
			    	SetPlayerData(playerid, P_TURMA, 0);
					UpdatePlayerDatabaseInt(playerid, "turma", 0);
					GivePlayerMoneyEx(playerid, -15000000, "Побег", true, true);
                }
				else SendClientMessage(playerid, 0xf4ba5bFF, "У вас нету 15.000.000");
			}
			case DIALOG_POBEG_MAFIA_JAPAN:
			{
			    if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 15000000))
			    {
				    SendClientMessage(playerid, 0xf4ba5bFF, "Вы сбежали из подвала, быстрее убегайте с территории мафии!");
				    SetPlayerPosEx(playerid, 4004.6062,3857.9153,7.9312,70.8894, 0, 0);
			    	SetPlayerData(playerid, P_TURMA, 0);
					UpdatePlayerDatabaseInt(playerid, "turma", 0);
					GivePlayerMoneyEx(playerid, -15000000, "Побег", true, true);
                }
				else SendClientMessage(playerid, 0xf4ba5bFF, "У вас нету 15.000.000");
			}
			
			case DIALOG_ADMIN_CREATE:
			{
			    if(!response) return true;
			    if(response)
			    {
			        if(!(1 <= strlen(inputtext) <= 15) || strfind(inputtext, " ") != -1)
			        {
			            SendClientMessage(playerid, 0xFF6600FF, "* Длина пароля должна быть от 6 до 15 символов");
			            SendClientMessage(playerid, 0xFF6600FF, "* Также не допускается использование пробелов");
			        }
			        else
			        {
			            if(!strcmp(g_player[playerid][P_PASSWORD], inputtext, true))
			                return SCM(playerid, COLOR_GREY, "* Пароль от аккаунта и пароль от админ-прав должен различаться");

			            static query[128];
			            mysql_format(mysql, query, sizeof query, 
			                "UPDATE PlayersMorallwens SET adminspasslogin='%e' WHERE id=%d LIMIT 1", 
			                inputtext, GetPlayerAccountID(playerid));
			            mysql_query(mysql, query, false);

			            if(!mysql_errno())
			            {
			                format(g_player[playerid][P_ADMIN_PASSWORD], 16, "%s", inputtext);
			                format(query, sizeof query, "{99CC00}Ваш пароль: {FFFFFF}%s", 
			                    GetPlayerData(playerid, P_ADMIN_PASSWORD));

			                if(GetPlayerAdminEx(playerid) != 0)
			                {
			                    format(STRING_GLOBAL, sizeof STRING_GLOBAL,
			                        "A: {FFFFFF}%s[%d] {99CC00}регистрируется в системе как администратор %d уровня",
			                        GetPlayerNameEx(playerid), playerid, GetPlayerAdminEx(playerid));
			                }
			                if(GetPlayerYAdminEx(playerid) != 0)
			                {
			                    format(STRING_GLOBAL, sizeof STRING_GLOBAL,
			                        "A: {FFFFFF}%s[%d] {99CC00}регистрируется в системе как ютубер %d уровня",
			                        GetPlayerNameEx(playerid), playerid, GetPlayerYAdminEx(playerid));
			                }

			                SendMessageToAdmins(STRING_GLOBAL, 0x99CC00FF);
			                SendClientMessage(playerid, 0x99CC00FF, query);

			                Dialog(playerid, DIALOG_ADMIN_PASS, DIALOG_STYLE_PASSWORD,
			                    "{99CC00}Авторизация администратора",
			                    "Введите свой админ-пароль для входа в систему:",
			                    "Войти", "Отмена");

			                return 1;
			            }
			            else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 05)");
			        }
			    }
			}
			case DIALOG_ADMIN_CREATE_2:
		    {
                if(!response) return true;

				if(!(1 <= strlen(inputtext) <= 15) || strfind(inputtext, " ") != -1)
				{
					SendClientMessage(playerid, 0xFF6600FF, "Длина пароля должна быть от 6 до 15 символов");
					SendClientMessage(playerid, 0xFF6600FF, "Также не допускается использование пробелов");
					Dialog(playerid, DIALOG_ADMIN_CREATE_2, DIALOG_STYLE_PASSWORD,""GUARD_SERVER"","{FFFFFF}Создайте свой личный пароль для авторизации как администратор","Далее", "Закрыть");
				}
				else
				{
					if(!strcmp(g_player[playerid][P_PASSWORD], inputtext, true))
					{
						Dialog(playerid, DIALOG_ADMIN_CREATE_2, DIALOG_STYLE_PASSWORD,""GUARD_SERVER"","{FFFFFF}Создайте свой личный пароль для авторизации как администратор","Далее", "Закрыть");
						return SCM(playerid, COLOR_GREY, "Пароль от аккаунта и пароль от админ-прав должен различаться");
					}
					static query[100];
					mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET adminspasslogin='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerAccountID(playerid));
					mysql_query(mysql, query, false);

					if(!mysql_errno())
					{
						format(g_player[playerid][P_ADMIN_PASSWORD], 16, "%s", inputtext);
						format(query, sizeof query, "{99CC00}Ваш пароль: {FFFFFF}%s", GetPlayerData(playerid, P_ADMIN_PASSWORD));
						if(GetPlayerAdminEx(playerid) != 0)
						{
							format
							(
								STRING_GLOBAL, sizeof STRING_GLOBAL,
								"A: {FFFFFF} %s[%d] {99CC00}регистрируется в системе как администратор %d уровня",
								GetPlayerNameEx(playerid), playerid, GetPlayerAdminEx(playerid)

							);
						}
						SendMessageToAdmins(STRING_GLOBAL, 0x99CC00FF);
						SendClientMessage(playerid, 0x99CC00FF, query);
						Dialog(playerid, DIALOG_ADMIN_PASS, DIALOG_STYLE_PASSWORD,""GUARD_SERVER"","Вы пытаетесь авторизоваться как администратор.\nСистема безопасности запрашивает ввод пароля от админ-прав.\n\n{FFFFFF}Введите пароль:", "Далее", "Закрыть");
						return 1;
					}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 05)");
				}
		    }
			case DIALOG_ADMIN_PASS_2:
			{
                if(!response) return Kick(playerid);

				if(strlen(g_player[playerid][P_ADMIN_PASSWORD]) > 0 && !strcmp(inputtext, g_player[playerid][P_ADMIN_PASSWORD], true))
				{
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] авторизовался в системе безопасности (%d уровень админ-прав)", GetPlayerNameEx(playerid), playerid, GetPlayerAdminEx(playerid));
					SendMessageToAdmins(STRING_GLOBAL, COLOR_GREY);

					status_authorization[playerid] = 1;
					admin_logged[playerid] = true;
				}
				else
				{
					if(GetPVarInt(playerid, "Alogin") == 1) return admin_logged[playerid] = false, Kick(playerid);
					else if(GetPVarInt(playerid, "Alogin") == 0) return Dialog(playerid, DIALOG_ADMIN_PASS_2, DIALOG_STYLE_PASSWORD,""GUARD_SERVER"","Вы пытаетесь авторизоваться как администратор.\nСистема безопасности запрашивает ввод пароля от админ-прав.\n\n{BE2D2D}У вас осталось последняя попытка\n{FFFFFF}Введите пароль:","Далее", "Закрыть"), SetPVarInt(playerid, "Alogin", 1);
				}
			}
			case DIALOG_ADMIN_PASS:
			{
				if(!response)
				{
					if(GetPVarInt(playerid, "Alogin") == 1)
					{
						admin_logged[playerid] = false;
						Kick(playerid);
					}
					else
					{
						SetPVarInt(playerid, "Alogin", 1);

						Dialog(playerid, DIALOG_ADMIN_PASS, DIALOG_STYLE_PASSWORD,
							""GUARD_SERVER"",
							"Введите пароль администратора:",
							"Далее", "Закрыть");
					}
					return 1;
				}

				if(strlen(inputtext) < 1)
				{
					return Dialog(playerid, DIALOG_ADMIN_PASS, DIALOG_STYLE_PASSWORD,
						""GUARD_SERVER"",
						"Введите пароль администратора:",
						"Далее", "Закрыть");
				}

				if(strlen(g_player[playerid][P_ADMIN_PASSWORD]) < 1
				|| !strcmp(g_player[playerid][P_ADMIN_PASSWORD], "999999", true))
				{
					return Dialog(playerid, DIALOG_ADMIN_CREATE, DIALOG_STYLE_PASSWORD,
						""GUARD_SERVER"",
						"Создайте пароль администратора:",
						"Далее", "Закрыть");
				}

				if(strcmp(inputtext, g_player[playerid][P_ADMIN_PASSWORD], false))
				{
					if(GetPVarInt(playerid, "Alogin") == 1)
					{
						admin_logged[playerid] = false;
						return Kick(playerid);
					}

					SetPVarInt(playerid, "Alogin", 1);

					return Dialog(playerid, DIALOG_ADMIN_PASS, DIALOG_STYLE_PASSWORD,
						""GUARD_SERVER"",
						"Неверный пароль.\n\nВведите пароль администратора:",
						"Далее", "Закрыть");
				}

				status_authorization[playerid] = 1;
				admin_logged[playerid] = true;

				static fmt_text[164];

				if(GetPlayerAdminEx(playerid))
				{
					format(
						fmt_text, sizeof fmt_text,
						"A: %s%s {FFFFFF}%s[%d] {FFD700}авторизовался как администратор %d уровня",
						g_player[playerid][P_MYPREFIX_COLOR],
						g_player[playerid][P_MYPREFIX],
						GetPlayerNameEx(playerid),
						playerid,
						GetPlayerAdminEx(playerid)
					);

					SendMessageToAdmins(fmt_text, 0xFFD700FF);
				}
				else if(GetPlayerBuyAdminEx(playerid))
				{
					format(
						fmt_text, sizeof fmt_text,
						"A: %s%s %s[%d] авторизовался как покупной администратор %d уровня",
						g_player[playerid][P_MYPREFIX_COLOR],
						g_player[playerid][P_MYPREFIX],
						GetPlayerNameEx(playerid),
						playerid,
						GetPlayerBuyAdminEx(playerid)
					);

					SendMessageToAdmins(fmt_text, 0xFFD700FF);
					SendMessageToBuyAdmins(fmt_text, 0xFFD700FF);
				}
				else if(GetPlayerYAdminEx(playerid))
				{
					format(
						fmt_text, sizeof fmt_text,
						"A: %s%s %s[%d] авторизовался как ютубер %d уровня",
						g_player[playerid][P_MYPREFIX_COLOR],
						g_player[playerid][P_MYPREFIX],
						GetPlayerNameEx(playerid),
						playerid,
						GetPlayerYAdminEx(playerid)
					);

					SendMessageToAdmins(fmt_text, 0xFFD700FF);
				}

				return 1;
			}
			case DIALOG_SETBONUS:
			{
			    if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
						 for(new i = 0; i < MAX_PLAYERS; i++)
	                     {
                         MoralPacket_1(i, s_CefInterface, t_CefUpdate, "interface('Hud').setBonus(2)");
                         }
                         static query[200];
	                     mysql_format(mysql, query, sizeof query, "UPDATE server_config SET x_donate='2', x_exp='2', x_sallary='2', test_status='0', update_status='0' LIMIT 1");
	                     mysql_query(mysql, query, false);
						}
						case 2:
						{
                         for(new i = 0; i < MAX_PLAYERS; i++)
	                     {
                         MoralPacket_1(i, s_CefInterface, t_CefUpdate, "interface('Hud').setBonus(3)");
                         }
                         static query[200];
	                     mysql_format(mysql, query, sizeof query, "UPDATE server_config SET x_donate='2', x_exp='2', x_sallary='2', test_status='0', update_status='0' LIMIT 1");
	                     mysql_query(mysql, query, false);
						}
					}
				}
				else return SendClientMessageToAll(COLOR_YELLOW, "Бонус не выбран.'");
			}
			case DIALOG_MEROPRIATIE:
			{
			    if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'Уедь от админа'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							SetPlayerPos(playerid, -187.2291,390.1685,14.4367);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							number_mp_player = 15;
                            
							mp_status = 1;
							mpPos[0] = -187.2291;
							mpPos[1] = 390.1685;
							mpPos[2] = 14.4367;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
							
							AddStaticVehicle(555,-205.3443,391.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,388.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,385.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,382.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,379.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,376.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,373.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,370.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,367.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,364.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,361.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,358.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,355.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,352.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,349.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(444,-179.5972,390.1159,14.8067,90.5121,1,1);
						}
						case 2:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'Король Дигла'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							SetPlayerPos(playerid, -179.6144,390.2608,14.4367);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							number_mp_player = 150;

							mp_status = 1;
							mpPos[0] = -187.2291;
							mpPos[1] = 390.1685;
							mpPos[2] = 14.4367;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
							
							new gun, ammo, radius;



	                        new Float:pos[3];
	                        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
                            static string[144];
                            new players;
	                        foreach(new i : Player)
	                        {
                            if(!IsPlayerInRangeOfPoint(i, 200, pos[0], pos[1], pos[2])) continue;
		                    GiveWeapon(i, 24, 999);
		                    format(string, sizeof string, "[MP]: Вы получили оружие %s [%d] и %d пт.", GetWeaponName(gun), gun, ammo);
		                    SendClientMessage(i, 0xCECECEFF, string);
		                    players++;
	                        }
	                        format(string, sizeof string, "Оружие выдано %i игрокам в радиусе %i метров", players, radius);
                            SendClientMessage(playerid, COLOR_WHITE, string);
						}
						case 3:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'CS:GO'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							SetPlayerPos(playerid, -3048.8674,-4961.2710,5.8995);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							number_mp_player = 50;

							mp_status = 1;
							mpPos[0] = -3048.8674;
							mpPos[1] = -4961.2710;
							mpPos[2] = 5.8995;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
						}
						case 4:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'Мокрая Вечеринка'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							number_mp_player = 50;

							SetPlayerPos(playerid, 1931.6908,-1911.1093,56.5136);

							AddStaticVehicle(601,1918.5977,-1902.8547,56.2827,181.5945,0,1);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							mp_status = 1;
							mpPos[0] = 1931.6908;
							mpPos[1] = -1911.1093;
							mpPos[2] = 56.5136;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
						}
						case 5:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'Восточная Дуэль'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							number_mp_player = 20;

							SetPlayerPos(playerid, -179.6144,390.2608,14.4367);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							mp_status = 1;
							mpPos[0] = -179.6144;
							mpPos[1] = 390.2608;
							mpPos[2] = 14.4367;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
						}
					}
				}
				else return GameText(playerid, "~b~ну ты и ленивый(~n~~y~мп провести сложно~n~~r~собака ты", 1500, 5);
			}
			case DIALOG_MEROPRIATIE1:
			{
			    if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] TEST 'Уедь от админа'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] TEST : /TEST");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] TEST TEST TESTй TEST TEST!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] TEST TEST TEST TEST TEST!");

							SetPlayerPos(playerid, -187.2291,390.1685,14.4367);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							number_mp_player = 15;

							mp_status = 1;
							mpPos[0] = -187.2291;
							mpPos[1] = 390.1685;
							mpPos[2] = 14.4367;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
							AddStaticVehicle(555,-205.3443,391.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,388.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,385.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,382.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,379.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,376.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,373.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,370.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,367.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,364.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,361.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,358.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,355.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,352.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(555,-205.3443,349.5666,14.2532,271.0813,0,1);
							AddStaticVehicle(444,-179.5972,390.1159,14.8067,90.5121,1,1);
						}
						case 2:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[TEST] TEST TEST TEST TEST 'TEST TEST'");
							SendClientMessageToAll(COLOR_YELLOW, "[TEST] TEST : /TEST");
							SendClientMessageToAll(COLOR_YELLOW, "[TEST] TEST TEST TEST TEST TEST!");

							SendClientMessageToAll(COLOR_YELLOW, "[TEST] TEST TEST TEST TEST TEST!");

							SetPlayerPos(playerid, -179.6144,390.2608,14.4367);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							number_mp_player = 150;

							mp_status = 1;
							mpPos[0] = -187.2291;
							mpPos[1] = 390.1685;
							mpPos[2] = 14.4367;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
						}
						case 3:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'CS:GO'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							SetPlayerPos(playerid, -3048.8674,-4961.2710,5.8995);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							number_mp_player = 50;

							mp_status = 1;
							mpPos[0] = -3048.8674;
							mpPos[1] = -4961.2710;
							mpPos[2] = 5.8995;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
						}
						case 4:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'Мокрая Вечеринка'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							number_mp_player = 50;

							SetPlayerPos(playerid, 1931.6908,-1911.1093,56.5136);

							AddStaticVehicle(601,1918.5977,-1902.8547,56.2827,181.5945,0,1);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							mp_status = 1;
							mpPos[0] = 1931.6908;
							mpPos[1] = -1911.1093;
							mpPos[2] = 56.5136;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
						}
						case 5:
						{
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Открыт телепорт на мероприятие 'Восточная Дуэль'");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепортироваться : /tp");
							SendClientMessageToAll(COLOR_YELLOW, "[МП] Сразу в строй у стены!");

							SendClientMessageToAll(COLOR_YELLOW, "[МП] Телепорт закроется через 1 минуту!");

							number_mp_player = 20;

							SetPlayerPos(playerid, -179.6144,390.2608,14.4367);

							mptp = SetTimer("CloseMpTeleport", 60000, true);

							mp_status = 1;
							mpPos[0] = -179.6144;
							mpPos[1] = 390.2608;
							mpPos[2] = 14.4367;
							mpWorld[0] = GetPlayerInterior(playerid);
							mpWorld[1] = GetPlayerVirtualWorld(playerid);
						}
					}
				}
				else return GameText(playerid, "~b~ну ты и ленивый(~n~~y~мп провести сложно~n~~r~собака ты", 1500, 5);
			}
			case R_F:
			{
			    if(response)
		        {
					new carprice = GetVehicleData(GetPlayerVehicleID(playerid), V_RENTP),string[80];
					new businessid = GetVehicleData(GetPlayerVehicleID(playerid), V_RENT);
					if(GetILPlayerInt(GetPlayerMoneyEx(playerid), carprice))
					{
						RemovePlayerFromVehicle(playerid);
						TogglePlayerControllable(playerid,1);
						SendClientMessage(playerid,COLOR_WHITE,"У вас недостаточно средств для аренды транспорта.");
						return 1;
					}
					if(GetPlayerData(playerid, P_RENT_CAR) != INVALID_VEHICLE_ID)
					{
						RemovePlayerFromVehicle(playerid);
						TogglePlayerControllable(playerid,1);
						SendClientMessage(playerid,COLOR_WHITE,"У вас уже есть арендованное авто. /unrent чтобы вернуть его.");
						return 1;
					}
					new take_prods = 50;

					if(GetBusinessData(businessid, B_PRODS) >= take_prods)
					{
						AddBusinessProfit(playerid, businessid, carprice, take_prods);
					}
					else
					{
						RemovePlayerFromVehicle(playerid);
						TogglePlayerControllable(playerid,1);
						SendClientMessage(playerid,COLOR_WHITE,"В бизнесе недостаточно продуктов. Аренда авто закрыта.");
						return 1;
					}

					format(string, sizeof(string), "{66CC00}Вы арендовали транспорт для временного использования");
					SendClientMessage(playerid,COLOR_WHITE,string);
					SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {3CB371}/lock 2{FFFFFF} для открытия и закрытия дверей");
					SendClientMessage(playerid, 0xFFFFFFFF, "Чтобы разорвать договор аренды введите {3CB371}/unrent");
					TogglePlayerControllable(playerid,1);
					GivePlayerMoneyEx(playerid, -carprice, "Аренда авто");
					GetVehicleData(GetPlayerVehicleID(playerid), V_OWRENT) = GetPlayerName(playerid, OwnedName, sizeof(OwnedName));
					SetVehicleNumberPlate(GetPlayerVehicleID(playerid),"RENTED");
					SetPlayerData(playerid, P_RENT_CAR, GetPlayerVehicleID(playerid));
		        }
          		else
		        {
		            RemovePlayerFromVehicle(playerid);
				    TogglePlayerControllable(playerid,1);
		        }
			}
			// -----------------------------------------------------------------
			case DIALOG_PNEWMA_DESTROY:
			{
			    if(!response) return 1;

			    new vehicleid = GetPlayerVehicleID(playerid);
			    new index = GetVehicleData(vehicleid, V_ACTION_ID);

			    GivePlayerMoneyEx(playerid, 25000000, "снятие пневмы", true, true);

			    SetOwnableCarData(index, OC_PNEWMA, 0);
			    SetOwnableCarData(index, OC_PNEWMA_1, 0.0);
			    SetOwnableCarData(index, OC_PNEWMA_2, 0.0);

			    static fmt_text[256];
			    mysql_format(mysql, fmt_text, sizeof(fmt_text),
			        "UPDATE ownable_cars SET pnewma=0, pnewma=0.0, pnewma_2=0.0 WHERE id=%d LIMIT 1",
			        GetOwnableCarData(index, OC_SQL_ID)
			    );
			    mysql_query(mysql, fmt_text, false);

			    SetPlayerVirtualWorld(playerid, 0);
			    SetVehicleVirtualWorld(vehicleid, 0);
			    SetVehiclePos(vehicleid, -413.4231, 1010.6860, 12.0819);
			    SetVehicleZAngle(vehicleid, 2.8581);
			    SetCameraBehindPlayer(playerid);

			    TogglePlayerControllable(playerid, 1);

			    SpeedometrShowForPlayer(playerid);

			    SendClientMessage(playerid, -1, "* Вы успешно сняли пневму со своего авто!");
			    SaveOwnableCar(vehicleid);

			    UpdateVehicleHandling(playerid, vehicleid);

			    MoralPacket_1(playerid, s_CefInterface, t_CefHide, "TuningPneuma");
			}
			case DIALOG_F_STYLE:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
						if(GetPlayerData(playerid, P_STYLE_1) == 0)
						SendClientMessage(playerid, 0xFF0000AA, "У вас не изучен стиль боя 'Бокс'");

					    if(GetPlayerData(playerid, P_STYLE_1) == 1)
			            {
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
						SendClientMessage(playerid, 0x33FF33AA, "Вы выбрали стиль боя 'Бокс'");
						}
						}
						case 2:
						{
						if(GetPlayerData(playerid, P_STYLE_2) == 0)
						SendClientMessage(playerid, 0xFF0000AA, "У вас не изучен стиль боя 'Кунгфу'");

					    if(GetPlayerData(playerid, P_STYLE_2) == 1)
			            {
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
						SendClientMessage(playerid, 0x33FF33AA, "Вы выбрали стиль боя 'Кунгфу'");
						}
						}
						case 3:
						{
						if(GetPlayerData(playerid, P_STYLE_3) == 0)
						SendClientMessage(playerid, 0xFF0000AA, "У вас не изучен стиль боя 'СКолена'");

					    if(GetPlayerData(playerid, P_STYLE_3) == 1)
			            {
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
						SendClientMessage(playerid, 0x33FF33AA, "Вы выбрали стиль боя 'СКолена'");
						}
						}
						case 4:
						{
						if(GetPlayerData(playerid, P_STYLE_4) == 0)
						SendClientMessage(playerid, 0xFF0000AA, "У вас не изучен стиль боя 'Проход в ноги'");

					    if(GetPlayerData(playerid, P_STYLE_4) == 1)
			            {
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
						SendClientMessage(playerid, 0x33FF33AA, "Вы выбрали стиль боя 'Проход в ноги'");
						}
						}
						case 5:
						{
						if(GetPlayerData(playerid, P_STYLE_5) == 0)
						SendClientMessage(playerid, 0xFF0000AA, "У вас не изучен стиль боя 'Локтем'");

					    if(GetPlayerData(playerid, P_STYLE_5) == 1)
			            {
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
						SendClientMessage(playerid, 0x33FF33AA, "Вы выбрали стиль боя 'Локтем'");
						}
						}
						default:
							return 1;
					}
				}
			}
			case DIALOG_24_7:
			{
			    if(!response) return 1;
			    switch(listitem)
			    {
			        case 0:
			        {

					   	if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 6000))
			            {
							GiveWeapon(playerid, 43, 15);
							SendClientMessage(playerid, 0x66CC00FF, "* Вы купили фотоаппарат на 15 снимков");
				            GivePlayerMoneyEx(playerid, -6000);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Набор фотографа стоит 6000 рублей");
			        }
			        case 1:
			        {

					   	if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 6500))
			            {
							GiveWeapon(playerid, WEAPON_FLOWER, 1);
							SendClientMessage(playerid, 0x66CC00FF, "* Вы купили букет цветов");
							SendClientMessage(playerid, 0x66CC00FF, "* Используйте {FFCD00}/present {66CC00}чтобы подарить их кому нибудь");
				            GivePlayerMoneyEx(playerid, -6500);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Букет стоит 6500 рублей");
			        }
			        case 2:
			        {

					   	if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 18000))
			            {
							GiveWeapon(playerid, WEAPON_CANE, 1);
							SendClientMessage(playerid, 0x66CC00FF, "* Вы купили трость");
				            GivePlayerMoneyEx(playerid, -18000);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Трость стоит 18000 рублей");
			        }
					case 3:
			        {

					   	if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 24000))
			            {
							GiveWeapon(playerid, WEAPON_PARACHUTE, 1);
							SendClientMessage(playerid, 0x66CC00FF, "* Вы купили парашют");
				            GivePlayerMoneyEx(playerid, -24000);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Парашют стоит 24000 рублей");
			        }
		        	case 4:
			        {
			        }
		        	case 5:
			        {
						if(!GetPlayerData(playerid, P_MASK))
						{
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 7100))
							{
								SetPlayerData(playerid, P_MASK, 1);
								SendClientMessage(playerid, 0x66CC00FF, "* Вы купили маску");
								SendClientMessage(playerid, 0x66CC00FF, "* Используйте {FFCD00}/mask {66CC00}для скрытия Вашего расположения на карте (на 10 минут)");
								GivePlayerMoneyEx(playerid, -7100);
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Маска стоит 7100 рублей");
						}
			        }
		        	case 6:
			        {
						
			        }
		     	  }
			}
			case DIALOG_PLAYER_STATS: if(response) callcmd::menu(playerid);
			//===============фамы==================
			case DIALOG_OSTANOVKA:
			{
			    if(response)
			    {
					new ost_id;

					ost_id = GetMapNearestOst(playerid);

					if(ost_id == -1)
					{
					    SendClientMessage(playerid, 0xFF6600FF, "* На расстоянии 500 метров не найдено ни одной остановки.");
					    SendClientMessage(playerid, -1, "* Попробуй поискать другие ближайшие остановки.");

					    return 1;
					}

					new Float: x = GetPVarFloat(playerid, "click_x");
				 	new Float: y = GetPVarFloat(playerid, "click_y");
				 	new Float: z = GetPVarFloat(playerid, "click_z");

					GetDistanceBetweenPoints(x, y, z, g_ostanovka[ost_id][OST_POS_X], g_ostanovka[ost_id][OST_POS_Y], g_ostanovka[ost_id][OST_POS_Z]);

					GivePlayerMoneyEx(playerid, -2500, "Поездка на автобусе", true, true);

					SendClientMessage(playerid, 0x6699FFFF, "Автобус приедет в течении нескольких минут. Пожалуйста, подождите..");

					SetTimerEx("OstanovkaStart", 10000, false, "i", playerid);
			    }
			    else SendClientMessage(playerid, 0xFF6600FF, "* Вы отказались от поездки на автобусе");
			}
			case DIALOG_SELECT_OSTANOVKA:
			{
			    if(response)
			    {
				    new Float: X, Float: Y, Float: Z;

				    if(listitem == 0) return ShowPlayerOstanovkaDialog(playerid);
				    if(1 <= listitem <= 9)
				    {
						X = gps_public_places[listitem - 1][G_POS_X];
						Y = gps_public_places[listitem - 1][G_POS_Y];
						Z = gps_public_places[listitem - 1][G_POS_Z];
				    }

				    if(listitem == 10) return ShowPlayerOstanovkaDialog(playerid);
				    if(11 <= listitem <= 16)
				    {
						X = gps_transport[listitem - 11][G_POS_X];
						Y = gps_transport[listitem - 11][G_POS_Y];
						Z = gps_transport[listitem - 11][G_POS_Z];
				    }

				    if(listitem == 17) return ShowPlayerOstanovkaDialog(playerid);
				    if(18 <= listitem <= 23)
				    {
						X = gps_state_organizations[listitem - 18][G_POS_X];
						Y = gps_state_organizations[listitem - 18][G_POS_Y];
						Z = gps_state_organizations[listitem - 18][G_POS_Z];
				    }

				    if(listitem == 24) return ShowPlayerOstanovkaDialog(playerid);
				    if(25 <= listitem <= 27)
				    {
						X = gps_gangs[listitem - 25][G_POS_X];
						Y = gps_gangs[listitem - 25][G_POS_Y];
						Z = gps_gangs[listitem - 25][G_POS_Z];
				    }

				    if(listitem == 28) return ShowPlayerOstanovkaDialog(playerid);
				    if(29 <= listitem <= 36)
				    {
						X = gps_jobs[listitem - 29][G_POS_X];
						Y = gps_jobs[listitem - 29][G_POS_Y];
						Z = gps_jobs[listitem - 29][G_POS_Z];
				    }

				    if(listitem == 37) return ShowPlayerOstanovkaDialog(playerid);
				    if(38 <= listitem <= 39)
				    {
						X = gps_banks[listitem - 38][G_POS_X];
						Y = gps_banks[listitem - 38][G_POS_Y];
						Z = gps_banks[listitem - 38][G_POS_Z];
				    }

				    if(listitem == 40) return ShowPlayerOstanovkaDialog(playerid);
				    if(41 <= listitem <= 42)
				    {
						X = gps_entertainment[listitem - 41][G_POS_X];
						Y = gps_entertainment[listitem - 41][G_POS_Y];
						Z = gps_entertainment[listitem - 41][G_POS_Z];
				    }

			        SetPVarFloat(playerid, "click_x", X);
			        SetPVarFloat(playerid, "click_y", Y);
			        SetPVarFloat(playerid, "click_z", Z);

					Dialog(playerid, DIALOG_OSTANOVKA, DIALOG_STYLE_MSGBOX, "{FFD83D}Поездка на автобусе", "{"#cW"}У Вас отмечена метка на карте\n\nСтоимость поездки на автобусе в любую точку области составляет: {FFD83D}2500 рублей\n\n{"#cW"}Вы уверены, что хотите поехать на автобусе?\nВам придётся немного подождать его", "Поехали", "Отмена");
				}
			}
			case DIALOG_TEMP_LEADER:
			{
			    if(!response) return 1;

				SetPlayerTeamEx(playerid, listitem + 1);
				SetPlayerData(playerid, P_RANG, 10);

				if(!GetPlayerSex(playerid))
					SetPlayerData(playerid, P_OSKIN, g_organization[listitem][O_SKINS][9]);
				else
					SetPlayerData(playerid, P_OSKIN, g_organization[listitem][O_WOMEN_SKIN]);

				SetPlayerColorEx(playerid, team_colors[listitem + 1]);

                ResetSkin(playerid);

				static fmt_msg[200];

				format(fmt_msg, sizeof fmt_msg, "Вы взяли временное лидерство организации \"%s\"", GetPlayerTeamName(playerid));
				SendClientMessage(playerid, 0xCECECEFF, fmt_msg);

				format(fmt_msg, sizeof fmt_msg, "A: %s [%d] взял временное лидерство организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(playerid));
				SendMessageToAdmins(fmt_msg, COLOR_GREY);
			}
			case DIALOG_SECURITY_SETTING_PASS_1:
			{
				if(response)
				{
					if
					(
						strlen(inputtext)
						&& !strcmp(inputtext, GetPlayerData(playerid, P_PASSWORD), false)
					)
					{
						Dialog
						(
							playerid, DIALOG_SECURITY_SETTING_PASS_2, DIALOG_STYLE_INPUT,
							"{FFD83D}Новый пароль",
							"{FFFFFF}Введите новый пароль в поле ниже:",
							"Изменить", "Отмена"
						);
						return 1;
					}
					else SendClientMessage(playerid, 0xFF6600FF, "* Вы ввели неверный пароль");
				}
			}
			case DIALOG_SECURITY_SETTING_PASS_2:
			{
				if(response)
				{
					if(!(1 <= strlen(inputtext) <= 23) || strfind(inputtext, " ") != -1)
					{
						SendClientMessage(playerid, 0xFF6600FF, "* Длина пароля должна быть от 6 до 15 символов");
						SendClientMessage(playerid, 0xFF6600FF, "* Также не допускается использование пробелов");
					}
					else
					{
						if(strcmp(GetPlayerIpEx(playerid), GetPlayerData(playerid, P_REG_IP), false))
						{
							new lastip[64];
							new regip[64];
							strmid(lastip,GetPlayerIpEx(playerid),0,3);
							strmid(regip,GetPlayerData(playerid, P_REG_IP),0,3);

							if(strval(lastip) != strval(regip)) 
							{
								static fmt_text[148];
								format(fmt_text, sizeof fmt_text,"A: Игрок %s[%d] неудачно попытался сменить пароль (Смена основного IP-адреса)",GetPlayerNameEx(playerid), playerid, GetPlayerIpEx(playerid), GetPlayerData(playerid, P_REG_IP));
								SendMessageToAdmins(fmt_text, 0xFF6600FF);

								printf("{FFFFFF}["SERVER_NAME_RP"]: Игрок %s неудачно попытался сменить пароль (Смена IP-адреса) [%s (last) | %s (reg)]", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerData(playerid, P_REG_IP));
								return 1;
							}
						}

						static query[100];
						mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET players_password='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							format(g_player[playerid][P_PASSWORD], 85, "%s", inputtext);
							format(query, sizeof query, "Ваш новый пароль: {3399FF}%s", GetPlayerData(playerid, P_PASSWORD));
							SendClientMessage(playerid, 0xFFFF00FF, query);
							
							SendClientMessage(playerid, 0xFFFFFFFF, "Рекомендуем сделать скрин {00CC00}(клавиша F8) {FFFFFF}чтобы не забыть его");
							return 1;
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 05)");
					}
					Dialog
					(
						playerid, DIALOG_SECURITY_SETTING_PASS_2, DIALOG_STYLE_INPUT,
						"{FFD83D}Новый пароль",
						"{FFFFFF}Введите новый пароль в поле ниже:",
						"Изменить", "Отмена"
					);
				}
			}
			case DIALOG_ADMIN_FLY:
			{
				if(!response) return 1;

				switch(listitem)
				{
					case 0:
					{
		   		   		new inter, world, Float:X, Float:Y, Float:Z, Float:FA;
		                GetPlayerPos(playerid, X, Y, Z);
		                GetPlayerFacingAngle(playerid, FA);
		                inter = GetPlayerInterior(playerid);
		                world = GetPlayerVirtualWorld(playerid);
		                SetPVarFloat(playerid, "SpecX", X);
		                SetPVarFloat(playerid, "SpecY", Y);
		                SetPVarFloat(playerid, "SpecZ", Z);
		                SetPVarFloat(playerid, "SpecFA", FA);
		                SetPVarInt(playerid, "SpecInt", inter);
		                SetPVarInt(playerid, "SpecWorld", world);

		                if(GetPlayerData(playerid, P_SKIN) > 0) SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));

                        DeletePVar(playerid, "FlyMode");
                        CancelEdit(playerid);
                        TogglePlayerSpectating(playerid, false);

                        DestroyPlayerObject(playerid, noclipdata[playerid][fly_object]);
                        noclipdata[playerid][camera_mode] = CAMERA_MODE_NONE;
                        SetPlayerSpawnInit(playerid);
                        SpawnPlayer(playerid);
                        SetPlayerPos(playerid, X, Y, Z);
                        SetPlayerFacingAngle(playerid, FA);
                        SetPlayerVirtualWorld(playerid, world);
                        SetPlayerInterior(playerid, inter);
					}
					case 1:
					{
						new inter = GetPVarInt(playerid, "SpecInt");
						DeletePVar(playerid, "SpecX");
						DeletePVar(playerid, "SpecY");
						DeletePVar(playerid, "SpecZ");
						DeletePVar(playerid, "SpecFA");
						DeletePVar(playerid, "SpecInt");
						DeletePVar(playerid, "SpecWorld");
						SetPlayerInterior(playerid, inter);
						SetPlayerScore(playerid, GetPlayerLevel(playerid));
						if(GetPlayerSuspect(playerid) > 0) SetPlayerWantedLevel(playerid, GetPlayerSuspect(playerid));
						if(GetPlayerData(playerid, P_SKIN) > 0) SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
						DeletePVar(playerid, "FlyMode");
						CancelEdit(playerid);
						TogglePlayerSpectating(playerid, false);

						DestroyPlayerObject(playerid, noclipdata[playerid][fly_object]);
						noclipdata[playerid][camera_mode] = CAMERA_MODE_NONE;
						SetPlayerSpawnInit(playerid);
						SpawnPlayer(playerid);
					}
					case 2:
					{
						static str[128];
                    	format(str, sizeof(str), "Введите новую скорость (текущая: %.2f):", GetPVarFloat(playerid, "FlySpeedMultiplier"));
                    	Dialog(playerid, DIALOG_FLY_SPEED, DIALOG_STYLE_INPUT, "Изменить скорость", str, "OK", "Отмена");
					}
				}
			}
			case DIALOG_FLY_SPEED:
        	{
            if(!response) return callcmd::fly(playerid, "");
           
            new Float:flyspeed;
            if(sscanf(inputtext, "f", flyspeed)) return Dialog(playerid, DIALOG_FLY_SPEED, DIALOG_STYLE_INPUT, "Изменить скорость", "Введите новую скорость:", "OK", "Отмена");
           
            SetPVarFloat(playerid, "FlySpeedMultiplier", flyspeed);
            SendClientMessage(playerid, -1, "Скорость полета изменена!");
            return 1;
        	}
			case DIALOG_TAKE_ITEM_SKIN:
			{
				if(!response) return 1;

				for(new i; i < MAX_ITEMS; i++)
				{
					if(items_objs[i] != -1)
					{
						if(IsPlayerInRangeOfPoint(playerid, 2.0, itempos[i][0], itempos[i][1], itempos[i][2]))
						{
							if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

							DestroyObject(items_objs[i]);
							DestroyDynamic3DTextLabel(number_labels[i]);

							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);

							GiveSkin(playerid, item1[i]);

							SendClientMessage(playerid, 0xCECECEFF, "* {"#cGold"}Вы подобрали предмет 'Одежда' в количестве 1.");

							items_objs[i] = -1;
							type_item[i] = 0;
							item1[i] = 0;

							STRING_GLOBAL[0] = EOS;
							format(STRING_GLOBAL,sizeof(STRING_GLOBAL), "Подобрал(а) предмет");
							SetPlayerChatBubble(playerid, STRING_GLOBAL, 0x3399FFFF, 10.0, 5000);
							DestroyDynamicArea(ItemDropSphere[i]);
							return 1;
						}
					}
				}
			}
			case DIALOG_TAKE_ITEM_GUN:
			{
				if(!response) return 1;

				for(new i; i < MAX_ITEMS; i++)
				{
					if(items_objs[i] != -1)
					{
						if(IsPlayerInRangeOfPoint(playerid, 2.0, itempos[i][0], itempos[i][1], itempos[i][2]))
						{
							if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

							DestroyObject(items_objs[i]);
							DestroyDynamic3DTextLabel(number_labels[i]);

							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);

							GiveWeapon(playerid, item1[i], item2[i]);

							SCMF(playerid, 0xCECECEFF, "* {"#cGold"}Вы подобрали предмет 'Оружие' в количестве %d.", item2[i]);

							items_objs[i] = -1;
							type_item[i] = 0;
							item1[i] = 0;
							item2[i] = 0;

							STRING_GLOBAL[0] = EOS;
							format(STRING_GLOBAL,sizeof(STRING_GLOBAL), "Подобрал(а) предмет");
							SetPlayerChatBubble(playerid, STRING_GLOBAL, 0x3399FFFF, 10.0, 5000);
							DestroyDynamicArea(ItemDropSphere[i]);
							return 1;
						}
					}
				}
			}
			case DIALOG_TAKE_ITEM_ACS:
			{
			    if(!response) return 1;

				for(new i; i < MAX_ITEMS; i++)
				{
					if(items_objs[i] != -1)
					{
						if(IsPlayerInRangeOfPoint(playerid, 2.0, itempos[i][0], itempos[i][1], itempos[i][2]))
						{
							if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

							DestroyObject(items_objs[i]);
							DestroyDynamic3DTextLabel(number_labels[i]);

							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);

							CreateItemsAcs(GetPlayerAccountID(playerid), 0, 1, GetInventorySlots(playerid), item1[i], item3[i], 0, item2[i], -1, -1, 0, type_item[i]);

							STRING_GLOBAL[0] = EOS;
							format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "{"#cGold"}Вы подобрали предмет '%s' в количестве 1.", ItemsInfo[item3[i]]);
							SendClientMessage(playerid, 0xCECECEFF, STRING_GLOBAL);

							items_objs[i] = -1;
							type_item[i] = 0;
							item1[i] = 0;
							item2[i] = 0;
							item3[i] = 0;
							item4[i] = 0;

							format(STRING_GLOBAL,sizeof(STRING_GLOBAL), "Подобрал(а) предмет");
							SetPlayerChatBubble(playerid, STRING_GLOBAL, 0x3399FFFF, 10.0, 5000);
							DestroyDynamicArea(ItemDropSphere[i]);
							return 1;
						}
					}
				}
			}
			case DIALOG_TAKE_MONEY:
			{
				if(!response) return 1;

				for(new i; i < MAX_ITEMS; i++)
				{
					if(items_objs[i] != -1)
					{
						if(IsPlayerInRangeOfPoint(playerid, 2.0, itempos[i][0], itempos[i][1], itempos[i][2]))
						{
							DestroyObject(items_objs[i]);
							DestroyDynamic3DTextLabel(number_labels[i]);

							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);

							GivePlayerMoneyEx(playerid, item2[i], "Подобрал деньги");

							STRING_GLOBAL[0] = EOS;
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{"#cGold"}Вы подобрали предмет 'Деньги' в количестве %d.",item2[i]);
							SendClientMessage(playerid, 0xCECECEFF, STRING_GLOBAL);

							itempos[i][0]=0, itempos[i][1]=0, itempos[i][2]=-10;
							items_objs[i] = 0;
							type_item[i] = 0;
							item1[i] = 0;
							item2[i] = 0;

							format(STRING_GLOBAL,sizeof(STRING_GLOBAL), "Подобрал(а) предмет");
							SetPlayerChatBubble(playerid, STRING_GLOBAL, 0x3399FFFF, 10.0, 5000);
							DestroyDynamicArea(ItemDropSphere[i]);
							return 1;
						}
					}
				}
			}
			case DIALOG_TAKE_ITEM:
			{
			    if(!response) return 1;

				for(new i; i < MAX_ITEMS; i++)
				{
					if(items_objs[i] != -1)
					{
						if(IsPlayerInRangeOfPoint(playerid, 2.0, itempos[i][0], itempos[i][1], itempos[i][2]))
						{
							if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);
							
							DestroyObject(items_objs[i]);
							DestroyDynamic3DTextLabel(number_labels[i]);

							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);

							GiveIteam(playerid, item1[i], 1, item2[i], 0, "Поднял предмет [Инвентарь]");

							STRING_GLOBAL[0] = EOS;
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{"#cGold"}Вы подобрали предмет '%s' в количестве %d.", ItemsInfo[item1[i]],item2[i]);
							SendClientMessage(playerid, 0xCECECEFF, STRING_GLOBAL);

							itempos[i][0]=0, itempos[i][1]=0, itempos[i][2]=-10;
							items_objs[i] = 0;
							type_item[i] = 0;
							item1[i] = 0;
							item2[i] = 0;

							format(STRING_GLOBAL,sizeof(STRING_GLOBAL), "Подобрал(а) предмет");
							SetPlayerChatBubble(playerid, STRING_GLOBAL, 0x3399FFFF, 10.0, 5000);
							DestroyDynamicArea(ItemDropSphere[i]);
							return 1;
						}
					}
				}
			}
			case DIALOG_TAKE_ITEM_NUMBER:
			{
			    if(!response) return 1;

				for(new i; i < MAX_ITEMS; i++)
				{
					if(items_objs[i] != -1)
					{
						if(IsPlayerInRangeOfPoint(playerid, 2.0, itempos[i][0], itempos[i][1], itempos[i][2]))
						{
							if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

							DestroyObject(items_objs[i]);
							DestroyDynamic3DTextLabel(number_labels[i]);

							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);

							SendClientMessage(playerid, 0xCECECEFF, "* {"#cGold"}Вы подобрали предмет 'Автомобильный номер' в количестве 1.");

							CreateItemsCarNumber(GetPlayerAccountID(playerid), 0, 1, GetInventorySlots(playerid), number_item[i], region_item[i], item1[i], -1, -1, 0, 1);

							itempos[i][0]=0, itempos[i][1]=0, itempos[i][2]=-10;
							format(number_item[i], 10, "");
							format(region_item[i], 10, "");
							items_objs[i] = 0;
							type_item[i] = 0;
							item1[i] = 0;

							STRING_GLOBAL[0] = EOS;
							format(STRING_GLOBAL,sizeof(STRING_GLOBAL), "Подобрал(а) предмет");
							SetPlayerChatBubble(playerid, STRING_GLOBAL, 0x3399FFFF, 10.0, 5000);
							DestroyDynamicArea(ItemDropSphere[i]);
							return 1;
						}
					}
				}
			}
			case DIALOG_KIOSK_BUY:
			{
			    if(!response) return 1;
				new kiosk_id = GetNearestKiosk(playerid, 7.0);

				if(kiosk_id == -1) return SCM(playerid, 0xCECECEFF, "* Вы слишком далеко от киоска");
				if(GetKioskData(kiosk_id, K_OWNER_ID) != 0) return SCM(playerid, 0xCECECEFF, "* Этот киоск уже куплен");
				//if(GetPlayerData(playerid, P_KIOSK) != -1) return SCM(playerid, 0xCECECEFF, "* У вас уже есть киоск");

				Dialog(playerid, DIALOG_BUY_STALL, DIALOG_STYLE_MSGBOX, "Покупка киоска", "Вы действительно хотите приобрести этот киоск?", "Да", "Нет");

				SetPVarInt(playerid, "buy_stall", kiosk_id);

				return 1;
			}
			case DIALOG_FIX_CAR:
			{
				if(response)
				{
					{
                        if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 5000000)) return SendClientMessage(playerid, 0xFF6600FF, "* У Вас недостаточно средств");
                    
					    SendClientMessage(playerid, COLOR_ORANGE, "Вы купили рем. комплект!");
					    SendClientMessage(playerid, COLOR_ORANGE, "Использовать рем. комплект: {2f89f7}через инвентарь или /fixcar");

					    GivePlayerMoneyEx(playerid, -5000000);

					    GiveIteam(playerid, 44, 1, 1, 0);
					}
				}
			}
			case DIALOG_REPORT_Z:
			{
				if(!response) return 1;

				static query[345];
				format(query, sizeof query, "INSERT INTO `report_mesage` (`owner_id`, `report_id`, `name`, `text`, `data`, `status`) VALUES (%d, %d, '%s', '%s', %d, 1)", GetPlayerAccountID(playerid), m_player_report_id[playerid], GetPlayerNameEx(playerid), inputtext, gettime());
				mysql_query(mysql, query, false);

				SCMF(playerid, COLOR_YELLOW, "Вы успешно ответили на запрос {FFFFFF}[№ %d]", m_player_report_id[playerid]);

				GetPVarInt(playerid, "owner_id_player");

				new to_player = GetPlayerIDBySqlID(GetPVarInt(playerid, "owner_id_player"));

				if(IsPlayerConnected(to_player) && IsPlayerLogged(to_player))
				{
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[1, 0, \"%s\", %d]", GetPlayerNameEx(playerid), m_player_report_id[playerid]);
					MoralPacket_2(to_player, s_CefInterface, t_CefShow, "Notification", STRING_GLOBAL);

					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Для %s[acc:%d]: %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), inputtext);
					SendLog(playerid, LOG_TYPE_ADMIN_ANSWER, STRING_GLOBAL);
				}
				m_player_report_id[playerid] = -1;

			}
			case DIALOG_REPORT_1:
			{
   				if(!response) return 1;

  			  	format(report_message[playerid], sizeof report_message, "%s", inputtext);

				if(strfind(report_message[playerid], "%~%k%~%~SWITCH_DEBUG_CAM_ON%~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
				{
				return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
				if(strfind(report_message[playerid], "~k~~SWITCH_DEBUG_CAM_ON~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
				{
				return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
			    if(strfind(report_message[playerid], "~k~~TAKE_SCREEN_SHOT~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
			    {
			    return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
			    }
				if(strfind(report_message[playerid], "%~%k%~%~SWITCH_DEBUG_CAM_ON%~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
				{
					return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
				if(strfind(report_message[playerid],"%s") != -1)
				{
					return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
				if(strfind(report_message[playerid],"%ss") != -1)
				{
					return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}

		    	Dialog(playerid, DIALOG_REPORT_2, DIALOG_STYLE_LIST, "Выберите действие", "1. Жалоба на игрока\n2. Задать вопрос", "Далее", "Закрыть");
			}
			case DIALOG_GOTO_GPS:
        	{
        	    if(response)
        	    {
        	        TeleportPlayerGPS(playerid, GetPVarFloat(playerid, "goto_x"), GetPVarFloat(playerid, "goto_y"), GetPVarFloat(playerid, "goto_z"));

        	        DeletePVar(playerid, "goto_x");
                    DeletePVar(playerid, "goto_y");
                    DeletePVar(playerid, "goto_z");
				}
        	}
	    	case DIALOG_AFTERPOS:
			{
				if(response)
				{
					EnterPlayerToHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
					if(GetPlayerData(playerid, P_JAIL))
					{
						new jail_pos = random(sizeof g_jail_positions);

						SetPlayerPosEx
						(
							playerid,
							g_jail_positions[jail_pos][0],
							g_jail_positions[jail_pos][1],
							g_jail_positions[jail_pos][2],
							g_jail_positions[jail_pos][3],
							5, 6
						);

						SetPlayerData(playerid, P_HEALTH, 100);
						SetPlayerHealthEx(playerid, 100);
						return 1;
					}
		    	}
			}
			
			case DIALOG_BUG_REPORT_LIST:
			{
				if(!response) return 1;

				new id = GetPlayerListitemValue(playerid, listitem);

				static query[256],
					Cache: result;

				mysql_format(mysql, query, sizeof query, "SELECT * FROM bugreport WHERE id=%d LIMIT 1", id);
				result = mysql_query(mysql, query, true);

				new name[24],
					time[24];

				cache_get_field_content(0, "owner_name", name);
				cache_get_field_content(0, "time", time);
				cache_get_field_content(0, "bug_text", query);
				new status = cache_get_field_content_int(0, "status");
				new owner_id = cache_get_field_content_int(0, "owner_id");

				cache_delete(result);

				string_dialog[0] = EOS;
				format
				(
					string_dialog, sizeof string_dialog, 
					"{FFFFFF}Номера запроса\t{FAAC58}№%d\n\
					{FFFFFF}Номер аккаунта игрока\t{FAAC58}№%d\n\
					{FFFFFF}Имя игрока\t{FAAC58}%s\n\
					{FFFFFF}Время создания запроса\t{FAAC58}%s\n\
					{FFFFFF}Статус запроса\t%s\n\n\
					{FFFFFF}Cообщение в запросе:\n\
					{FAAC58}%s\n\n\
					{FFFFFF}При нажатии кнопки {FAAC58}`Завершить запрос` {FFFFFF}игрок получит бонус\n\
					так как его запрос был полезен для разработчика.", 
					id, owner_id, name, time, status < 1 ? ("{FF6600}В ожидании") : ("{33AA33}Завершен"), query);

				Dialog(playerid, DIALOG_BUG_REPORT_EDIT, DIALOG_STYLE_MSGBOX,"{FFFF00}Запрос (bugreport)", string_dialog,"Завершить запрос", "Назад");
			}
			case DIALOG_FORBES_TYPE:
			{
				if(!response) return 1;

				switch(listitem)
				{	
					case 0:
					{
						static query[512], Cache:result;

						result = mysql_query(mysql, "\
							SELECT \
								a.name, \
								CAST((a.money + a.bank) AS UNSIGNED) AS total_money, \
								COUNT(b.id) AS business_count, \
								(SELECT COUNT(*) FROM ownable_cars c WHERE c.owner_id = a.id) AS count_car, \
								(SELECT COUNT(*) FROM houses h WHERE h.owner_id = a.id) AS house_count \
							FROM PlayersMorallwens a \
							LEFT JOIN business b ON a.id = b.owner_id \
							WHERE a.admin = 0 \
							GROUP BY a.id, a.name, a.money, a.bank \
							ORDER BY total_money DESC, business_count DESC, count_car DESC, house_count DESC \
							LIMIT 10;", true);

						str_q[0] = EOS;

						new rows = cache_num_rows();
						new count[64]; // увеличим буфер
						new player_name[24];

						for (new i = 0; i < rows; i++)
						{
							cache_get_field_content(i, "name", player_name);
							cache_get_field_content(i, "total_money", count);

							new total_money = strval(count);
							new formatted_money[32];
							format(formatted_money, sizeof formatted_money, "%s", formatInt(total_money));

							format(query, sizeof query, "[%d,\"%s\",\"%s Рублей\"],", i + 1, player_name, formatted_money);
							strcat(str_q, query);
						}

						cache_delete(result);
						new str_len = strlen(str_q);
						if (str_len > 0) strdel(str_q, str_len - 1, str_len);

						format(str_q, sizeof str_q, "[\"Forbes \", \" \", 0,[%s]]", str_q);
						SendClientEventWithArg(playerid, t_CefShow, "Rating", str_q);
					}
					case 1:
					{
						static query[512], Cache:result;

						result = mysql_query(mysql, "\
							SELECT \
								a.name, \
								a.level \
							FROM PlayersMorallwens a \
							WHERE a.admin = 0 \
							ORDER BY a.level DESC \
							LIMIT 10;", true);

						str_q[0] = EOS;

						new rows = cache_num_rows();
						new count[64]; // буфер для уровня
						new player_name[24];

						for (new i = 0; i < rows; i++)
						{
							cache_get_field_content(i, "name", player_name);
							cache_get_field_content(i, "level", count);

							new player_level = strval(count);

							format(query, sizeof query, "[%d,\"%s\",\"%d уровень\"],", i + 1, player_name, player_level);
							strcat(str_q, query);
						}

						cache_delete(result);
						new str_len = strlen(str_q);
						if (str_len > 0) strdel(str_q, str_len - 1, str_len);

						format(str_q, sizeof str_q, "[\"Forbes\", \" \", 0,[%s]]", str_q);
						SendClientEventWithArg(playerid, t_CefShow, "Rating", str_q);
					}
				}
			}
			case DIALOG_BUG_REPORT_EDIT:
			{
				if(!response) return callcmd::bugreportlist(playerid);

				SCM(playerid, COLOR_GREY, "* Завершить запрос может только разработчик");

				callcmd::bugreportlist(playerid);
			}
			case DIALOG_BUG_REPORT:
			{
				if(!response) return true;
				
				if(strlen(inputtext) < 3)
				{
					Dialog
					(
						playerid, DIALOG_BUG_REPORT, DIALOG_STYLE_INPUT,
						"{FFD83D}Связь с разработчиком",
						"{FFFFFF}Введите свое сообщение для {FAAC58}разработчика проекта{FFFFFF}.\n"\
						"{FFFFFF}Оно должно быть {FAAC58}подробным{FFFFFF} и {FAAC58}ясным{FFFFFF}.\n\n"\
						"{FAAC58}Внимание! {FFFFFF}После рассмотрения вашей проблемы, вы можете\n"\
						"{FFFFFF}получить {FAAC58}бонус {FFFFFF}если ваше сообщение принесет пользу.\n"\
						"{FAAC58}(вам придет уведомление на аккаунт)\n\n"\
						"{FF6600}Слишком короткое сообщение",
						"Отправить", "Закрыть"
					);
					return 1;
				}
				if(strlen(inputtext) > 144)
				{
					Dialog
					(
						playerid, DIALOG_BUG_REPORT, DIALOG_STYLE_INPUT,
						"{FFD83D}Связь с разработчиком",
						"{FFFFFF}Введите свое сообщение для {FAAC58}разработчика проекта{FFFFFF}.\n"\
						"{FFFFFF}Оно должно быть {FAAC58}подробным{FFFFFF} и {FAAC58}ясным{FFFFFF}.\n\n"\
						"{FAAC58}Внимание! {FFFFFF}После рассмотрения вашей проблемы, вы можете\n"\
						"{FFFFFF}получить {FAAC58}бонус {FFFFFF}если ваше сообщение принесет пользу.\n"\
						"{FAAC58}(вам придет уведомление на аккаунт)\n\n"\
						"{FF6600}Слишком длинное сообщение",
						"Отправить", "Закрыть"
					);
					return 1;
				}

				static query[256];

				format(query, sizeof query, "INSERT INTO bugreport (owner_id, owner_name, bug_text, status, time) VALUES (%d, '%s', '%s', 0, NOW())", GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), inputtext);
				mysql_query(mysql, query, false);

				format(query, sizeof query, "[bug report] от игрока %s[%d] добавлен новый запрос /bugreport", GetPlayerNameEx(playerid), playerid);
				SendMessageToAdmins(query, 0x999999FF);

				SCM(playerid, 0xFAAC58FF, "Вы успешно отправили новый запрос нашим разработчиком.");
				SCM(playerid, 0xFAAC58FF, "Ожидайте итог при рассмотрении вашего запроса.");
			}
			
			case DIALOG_REPORT_2:
			{
			    if(!response) return 1;

				if(IsPlayerRMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "* У Вас заблокирован доступ к репорту. Время до разблокировки: /time");

				if(strlen(report_message[playerid]) < 3)
				{
				    SendClientMessage(playerid, 0xFF6600FF, "* Слишком короткий запрос");
				    return 1;
				}
				if(strlen(report_message[playerid]) > 180)
				{
				    SendClientMessage(playerid, 0xFF6600FF, "* Слишком длинный запрос");
				    return 1;
				}
				if(strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
				{
					return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
				if(strfind(report_message[playerid], "~k~~SWITCH_DEBUG_CAM_ON~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
				{
				return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
			    if(strfind(report_message[playerid], "~k~~TAKE_SCREEN_SHOT~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
			    {
			    return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
			    }
				if(strfind(report_message[playerid], "%~%k%~%~SWITCH_DEBUG_CAM_ON%~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
				{
				return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
				if(strfind(report_message[playerid], "%~%k%~%~SWITCH_DEBUG_CAM_ON%~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
				{
					return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
				if(strfind(report_message[playerid],"%s") != -1)
				{
					return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}
				if(strfind(report_message[playerid],"%ss") != -1)
				{
					return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
				}

				new mes[228];

				switch(listitem + 1)
				{
				    case 1:
				    {
						format(mes,sizeof(mes),"{FF0000}<PM: Жалоба от %s [%d]:{E9DB00} %s>", GetPlayerNameEx(playerid), playerid, report_message[playerid]);
						SendMessageToAdmins(mes, -1);

						format(mes,sizeof(mes),"Текст жалобы: %s", report_message[playerid]);

						SendClientMessage(playerid, -1, "* Ваша жалоба была успешно отправлена. Ожидайте действий администратора");
						SendClientMessage(playerid, -1, mes);
						OnBattlePass_Perfomance(playerid, 13, 1);
				    }
				    case 2:
				    {
						format(mes,sizeof(mes),"{00FF17}<PM: Вопрос от %s [%d]:{E9DB00} %s>", GetPlayerNameEx(playerid), playerid, report_message[playerid]);
						SendMessageToAdmins(mes, -1);

						format(mes,sizeof(mes),"Текст вопроса: %s", report_message[playerid]);

						SendClientMessage(playerid, -1, "* Ваш вопрос был успешно отправлен. Ожидайте ответа");
						SendClientMessage(playerid, -1, mes);
						OnBattlePass_Perfomance(playerid, 13, 1);
				    }
			    }
			    SetPVarInt(playerid, "antifloodrep", gettime() + 15);
			}
			
			case DIALOG_CHANGE_NAME:
			{
				if(response)
				{
					if(!GetPVarInt(playerid, "change_name_status"))
					{
						new len = strlen(inputtext);
						if(4 <= len <= 20)
						{
							new bool: valid_name = true;
							for(new idx; idx < len; idx ++)
							{
								switch(inputtext[idx])
								{
									case 'a'..'z', 'A'..'Z', '[', ']', '_': continue;
									default:
										valid_name = false;
								}
							}

							if(!strcmp(GetPlayerNameEx(playerid), inputtext, true))
							{
								SendClientMessage(playerid, 0xFF6600FF, "* Вы уже используете это имя");
							}
							else if(valid_name)
							{
								static query[128];
								new Cache: result, rows;

								mysql_format(mysql, query, sizeof query, "SELECT id FROM PlayersMorallwens WHERE name='%e' LIMIT 1", inputtext);
								result = mysql_query(mysql, query, true);

								rows = cache_num_rows();
								cache_delete(result);

								if(!rows)
								{
									SetPVarInt(playerid, "change_name_status", 1);
									SetPVarString(playerid, "change_name", inputtext);

									Dialog
									(
										playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
										"{FFD83D}Заявка на изменение имени",
										"{FFFFFF}Ваша просьба об изменении ника отправлена администрации.\n"\
										"Вы получите сообщение, как только заявка будет обработана.\n\n"\
										"Если в течении нескольких минут Ваше имя не было изменено,\n"\
										"то, скорее всего, оно не соответствует RP правилам,\n"\
										"либо Вы уже используете RP имя.",
										"Ок", ""
									);

									format(query, sizeof query, "[Смена non rp имени] %s >> %s {FFCD00}| /okay %d для одобрения" , GetPlayerNameEx(playerid), inputtext, playerid);
									SendMessageToAdmins(query, 0x66CC99FF);

								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Введенное Вами имя уже используется");

							}
							else
							{
								SendClientMessage(playerid, 0xFF6600FF, "* Имя уже используется или содержит недопустимые символы");
								SendClientMessage(playerid, 0xFFFFFFFF, "Используйте латинские буквы a-z A-Z, а также символы [ ] _");
							}
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Недопустимый формат ввода");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "* Вы уже подавали заявку на изменение имени");
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_HELP:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof help_info - 1)
						ShowPlayerHelpSection(playerid, listitem);
				}
				else DeletePVar(playerid, "help_section");
			}
			case DIALOG_HELP_SECTION:
			{
				new sectionid = GetPVarInt(playerid, "help_section");

				if(!response && sectionid < sizeof help_info - 1)
				{
					ShowPlayerHelpSection(playerid, sectionid + 1);
				}
				else callcmd::help(playerid, "");
			}
			// -----------------------------------------------------------------
			case DIALOG_SERVER_RADIO:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof g_server_radio - 1)
					{
						PlayAudioStreamForPlayer(playerid, GetServerRadioData(listitem, SR_CHANNEL_URL));

						SetPVarInt(playerid, "server_radio_enabled", 1);
						SendClientMessage(playerid, 0x66CC00FF, "* Онлайн радио включено");
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_ANIM_LIST:
			{
				if(response)
				{
				/*	if(!SetPlayerAnimation(playerid, listitem))
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"Информация",
							"Для быстрого запуска нужной анимации можно использовать {FFFFFF}/anim(list) [номер анимации из списка]",
							"Закрыть", ""
						);
					}*/
					switch(listitem + 1)
					{
						case 1:
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"Информация",
								"Для быстрого запуска нужной анимации можно использовать {FFFFFF}/anim(list) [номер категории] [номер анимации из списка]",
								"Закрыть", ""
							);
						}
						case 2:
						{
	    					Dialog
							(
								playerid, DIALOG_ANIM_LIST_1, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Махать рукой\n"\
								"2. Попрощаться\n"\
								"3. Приветствие 1\n"\
								"4. Приветствие 2\n"\
								"5. Приветствие 3\n"\
								"6. Приветствие 4",
								"Выбрать", "Закрыть"
							);
						}
						case 3:
						{
							Dialog
							(
								playerid, DIALOG_ANIM_LIST_2, DIALOG_STYLE_LIST,
								"{"#cGold"}Уникальные танцы",
								 "1. Аэробика\n"\
					            "2. Руки вверх\n"\
					            "3. Лучшие друзья\n"\
					            "4. Танец локтями\n"\
					            "5. Конго\n"\
					            "6. Робот\n"\
					            "7. Крисс-Кросс\n"\
					            "8. Классический\n"\
					            "9. Диско\n"\
					            "10. Хочу в пляс\n"\
					            "11. Казачок\n"\
					            "12. Фламенко\n"\
					            "13. Харлем-Шейк\n"\
					            "14. Флосс\n"\
					            "15. Грув\n"\
					            "16. Рокер\n"\
					            "17. Хип-Хоп\n"\
					            "18. Техно-Виккинг\n"\
					            "19. Торнадо\n"\
					            "20. Брейк-данс\n"\
					            "21. Флекс\n"\
					            "22. Техно-Зомби\n"\
								"23. Сияй\n"\
								"24. mrllwns aura.",
							 	"Выбрать", "Закрыть"
					 		);
						}
						case 4:
						{
 							Dialog
							(
								playerid, DIALOG_ANIM_LIST_3, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Лечь на землю\n"\
								"2. Укрыться\n"\
								"3. Эффект электрошокера\n"\
								"4. Присесть\n"\
								"5. Расслаблено сесть\n"\
								"6. Спать на боку\n"\
								"7. Спать на спине\n"\
								"8. Облокотиться на бок\n"\
								"9. Лечь, оперевшись на ладонь\n"\
								"10. Сесть на стул\n"\
								"11. Сидеть уставшим за компьютером\n"\
								"12. Сидеть за столом\n"\
								"13. Сидеть и печатать\n"\
								"14. Сесть, закинув ногу на ногу\n"\
								"15. Сесть на стул (2)\n"\
								"16. Сесть на стул (3)\n"\
								"17. Лечь на землю (2)\n"\
								"18. Плохое самочувствие",
								"Выбрать", "Закрыть"
							);
						}
						case 5:
						{
 							Dialog
							(
								playerid, DIALOG_ANIM_LIST_4, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Походка пьяного\n"\
								"2. Кувыркаться",
								"Выбрать", "Закрыть"
							);
						}
						case 6:
						{
                        	Dialog
							(
								playerid, DIALOG_ANIM_LIST_5, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Вытянуть руку перед собой\n"\
								"2. Сложить руки вместе\n"\
								"3. Поза вратаря\n"\
								"4. Руки вверх!\n"\
								"5. Раздумье\n"\
								"6. Размахивать руками на месте\n"\
								"7. Смотреть наверх\n"\
								"8. Указать рукой наверх",
								"Выбрать", "Закрыть"
							);
						}
						case 7:
						{
                        	Dialog
							(
								playerid, DIALOG_ANIM_LIST_6, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Подложить бомбу\n"\
								"2. Надеть маску\n"\
								"3. Предложить наркотики\n"\
								"4. Мужское курение\n"\
								"5. Женское курение\n"\
								"6. Выпить напиток\n"\
								"7. Позвать кого-то\n"\
								"8. Смотреть по сторонам\n"\
								"9. Толкнуть боком\n"\
								"10. Взять что-то и рассмотреть\n"\
								"11. Отказаться от чего-либо\n"\
								"12. Искуственное дыхание\n"\
								"13. Пощечины для лежачего\n"\
								"14. Подглядывать через что-то\n"\
								"15. Движения тореодора\n"\
								"16. Быть в страхе\n"\
								"17. Призывать к чему-либо\n"\
								"18. Сходить по-маленькому\n"\
								"19. Голосовать на остановке\n"\
								"20. Удар ногой\n"\
								"21. Стучаться в дверь\n"\
								"22. Устроить бунт",
								"Выбрать", "Закрыть"
							);
						}
						case 8:
						{
							Dialog
							(
								playerid, DIALOG_ANIM_LIST_7, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Шлепнуть кому-то по заднице\n"\
								"2. Поцелуй 1\n"\
								"3. Поцелуй 2\n"\
								"4. Поцелуй 3",
								"Выбрать", "Закрыть"
							);
						}
						case 9:
						{
							Dialog
							(
								playerid, DIALOG_ANIM_LIST_8, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Читать рэп\n"\
								"2. Восточное единоборство\n"\
								"3. Facepalm\n"\
								"4. Гангстерский жест",
								"Выбрать", "Закрыть"
							);
						}
						case 10:
						{
							Dialog
							(
								playerid, DIALOG_ANIM_LIST_9, DIALOG_STYLE_LIST,
								"{9966FF}Анимации",
								"1. Съел что-то не то...\n"\
								"2. Перекусить",
								"Выбрать", "Закрыть"
							);
						}
					}
				}
			}
			case DIALOG_ANIM_LIST_1:
			{
				if(response)
				{
					switch(listitem + 1)
					{
					    case 1: ApplyAnimation(playerid, "ON_LOOKERS",		"wave_loop",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					    case 2: ApplyAnimation(playerid, "ped",				"endchat_03",			4.0, true,  1, 1, 1, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					    case 3: ApplyAnimation(playerid, "RIOT",			"RIOT_ANGRY",			4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					    case 4: ApplyAnimation(playerid, "GHANDS",			"gsign2",				4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					    case 5: ApplyAnimation(playerid, "GHANDS",			"gsign5",				4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					    case 6: ApplyAnimation(playerid, "GHANDS",			"gsign4",				4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");

					}
				}
			}
			case DIALOG_ANIM_LIST_2:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_In_O", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_In_P", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 3: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_In_T", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 4: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_Out_O", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 5: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_Pose_P", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 6: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_Pose_O", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 7: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_Pose_P", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 8: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_Pose_T", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 9: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_In_O", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 10: ApplyAnimation(playerid, "TATTOOS", "none none none ", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 11: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_In_T", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 12: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_Out_O", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 13: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_Out_P", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 14: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_Out_T", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 15: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_Pose_O", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 16: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_Pose_P", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 17: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmR_Pose_T", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 18: ApplyAnimation(playerid, "TATTOOS", "TAT_Back_In_O", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 19: ApplyAnimation(playerid, "TATTOOS", "TAT_Back_Pose_T", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 20: ApplyAnimation(playerid, "TATTOOS", "TAT_ArmL_Out_P", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 21: ApplyAnimation(playerid, "TATTOOS", "TAT_Sit_Loop_T", 	4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 22: ApplyAnimation(playerid, "TATTOOS", "TAT_Back_Sit_In_P", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 23: ApplyAnimation(playerid, "PED", "a_siyai", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 24: ApplyAnimation(playerid, "PED", "kid_aura", 4.0, true, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			case DIALOG_ANIM_LIST_3:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: ApplyAnimation(playerid, "BEACH",			"bather",				4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "ped",				"cower", 				3.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 3: ApplyAnimation(playerid, "CRACK",			"crckdeth2",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 4: ApplyAnimation(playerid, "BEACH",			"ParkSit_M_loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 5: ApplyAnimation(playerid, "BLOWJOBZ",			"BJ_COUCH_LOOP_P",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 6: ApplyAnimation(playerid, "CRACK",			"crckidle2",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 7: ApplyAnimation(playerid, "CRACK",			"crckidle4",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 8: ApplyAnimation(playerid, "GANGS",			"leanIDLE",				4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 9: ApplyAnimation(playerid, "BEACH",			"ParkSit_W_loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 10: ApplyAnimation(playerid, "INT_HOUSE",		"LOU_Loop",				4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 11: ApplyAnimation(playerid, "INT_OFFICE",		"OFF_Sit_Bored_Loop",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 12: ApplyAnimation(playerid, "INT_OFFICE",		"OFF_Sit_Idle_Loop",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 13: ApplyAnimation(playerid, "INT_OFFICE",		"OFF_Sit_Type_Loop",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 14: ApplyAnimation(playerid, "JST_BUISNESS",		"girl_02",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 15: ApplyAnimation(playerid, "MISC",				"SEAT_LR",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 16: ApplyAnimation(playerid, "ped",				"SEAT_idle",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 17: ApplyAnimation(playerid, "SWAT",				"gnstwall_injurd",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 18: ApplyAnimation(playerid, "SWEET",			"Sweet_injuredloop",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			case DIALOG_ANIM_LIST_4:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: ApplyAnimation(playerid, "PED",				"WALK_DRUNK",			4.0, true,  1, 1, 1, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "ped",				"Crouch_Roll_L",		4.0, true,  1, 1, 1, 1), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			case DIALOG_ANIM_LIST_5:
			{
				if(response)
				{
					switch(listitem + 1) // ApplyAnimation(playerid, );
					{
						case 1: ApplyAnimation(playerid, "SHOP",				"ROB_Loop_Threat",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "COP_AMBIENT",		"Coplook_loop",			4.0, true,  0, 1, 1, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 3: ApplyAnimation(playerid, "BSKTBALL",			"BBALL_def_loop",	4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 4: ApplyAnimation(playerid, "PED",				"HANDSUP",				4.0, 2, 1, 0, 1, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 5: ApplyAnimation(playerid, "GANGS",			"smkcig_prtl",			4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 6: ApplyAnimation(playerid, "LOWRIDER",			"RAP_B_Loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 7: ApplyAnimation(playerid, "ON_LOOKERS",		"lkup_loop",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 8: ApplyAnimation(playerid, "ON_LOOKERS",		"Pointup_loop",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			case DIALOG_ANIM_LIST_6:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: ApplyAnimation(playerid, "BOMBER",			"BOM_Plant",			4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "SHOP",				"ROB_Shifty",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 3: ApplyAnimation(playerid, "DEALER",			"DEALER_DEAL",			4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 4: ApplyAnimation(playerid, "SMOKING",			"M_smklean_loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 5: ApplyAnimation(playerid, "SMOKING",			"F_smklean_loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 6: ApplyAnimation(playerid, "BAR",				"dnk_stndF_loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 7: ApplyAnimation(playerid, "CAMERA",			"camstnd_cmon",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 8: ApplyAnimation(playerid, "DEALER",			"DEALER_IDLE",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 9: ApplyAnimation(playerid, "GANGS",			"shake_carSH",			4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 10: ApplyAnimation(playerid, "INT_SHOP",			"shop_shelf",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 11: ApplyAnimation(playerid, "KISSING",			"GF_StreetArgue_02",4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 12: ApplyAnimation(playerid, "MEDIC",			"CPR",					4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 13: ApplyAnimation(playerid, "MISC",				"bitchslap",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 14: ApplyAnimation(playerid, "MISC",				"bng_wndw",			4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 15: ApplyAnimation(playerid, "MISC",				"KAT_Throw_K",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 16: ApplyAnimation(playerid, "ON_LOOKERS",		"panic_loop",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 17: ApplyAnimation(playerid, "ON_LOOKERS",		"shout_02",				4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 18: ApplyAnimation(playerid, "PAULNMAC",			"Piss_loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 19: ApplyAnimation(playerid, "ped",				"IDLE_taxi", 		3.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 20: ApplyAnimation(playerid, "POLICE",			"Door_Kick",			4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 21: ApplyAnimation(playerid, "POLICE",			"CopTraf_Stop",			4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 22: ApplyAnimation(playerid, "RIOT",				"RIOT_ANGRY_B",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			case DIALOG_ANIM_LIST_7:
			{
				if(response) // ApplyAnimation(playerid, );
				{
					switch(listitem + 1)
					{
						case 1: ApplyAnimation(playerid, "SWEET",			"sweet_ass_slap",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "KISSING",			"Grlfrd_Kiss_01",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 3: ApplyAnimation(playerid, "KISSING",			"Grlfrd_Kiss_02",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 4: ApplyAnimation(playerid, "KISSING",			"Grlfrd_Kiss_03",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			case DIALOG_ANIM_LIST_8:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: ApplyAnimation(playerid, "benchpress",		"gym_bp_celebrate",		4.0, true,  0, 1, 1, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "PARK",				"Tai_Chi_Loop",		4.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 3: ApplyAnimation(playerid, "MISC",				"plyr_shkhead",		4.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 4: ApplyAnimation(playerid, "GHANDS",			"gsign1LH", 			3.0, true,  0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			case DIALOG_ANIM_LIST_9:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: ApplyAnimation(playerid, "FOOD",				"EAT_Vomit_P", 		3.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
						case 2: ApplyAnimation(playerid, "FOOD",				"EAT_Burger", 		3.0, false, 0, 0, 0, 0), SetPlayerData(playerid, P_USE_ANIM, true), MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Выключить анимацию\"]]");
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_OPEN_HOOD_OR_TRUNK:
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(vehicleid)
				{
					new E_VEHICLE_PARAMS_STRUCT: param = response ? V_BONNET : V_BOOT;
					new set_status = GetVehicleParam(vehicleid, param) ^ VEHICLE_PARAM_ON;

					SetVehicleParam(vehicleid, param, set_status);
				}
			}
			// -----------------------------------------------------------------
            case DIALOG_DRIVING_TUTORIAL_START:
			{
				if(response)
				{
   	                MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "openInterface('Theory')");
					return 1;
				}
			}
			case DIALOG_DRIVING_TUTORIAL_LIST:
			{
				if(response)
				{
					switch(listitem + 1)
					{
					    case 1:
					    {
					        MoralPacket_1(playerid, s_CefInterface, t_CefHide,"DrivingExamTheory");
					        MoralPacket_2(playerid, s_CefInterface, t_CefShow,"DrivingExamTheory", "[0]");
					    }
					    case 2:
					    {
					        MoralPacket_1(playerid, s_CefInterface, t_CefHide,"DrivingExamTheory");
					        MoralPacket_2(playerid, s_CefInterface, t_CefShow,"DrivingExamTheory", "[1]");
					    }
					    case 3:
					    {
					        MoralPacket_1(playerid, s_CefInterface, t_CefHide,"DrivingExamTheory");
					        MoralPacket_2(playerid, s_CefInterface, t_CefShow,"DrivingExamTheory", "[2]");
					    }
					    case 4:
					    {
					        MoralPacket_1(playerid, s_CefInterface, t_CefHide,"DrivingExamTheory");
					        MoralPacket_2(playerid, s_CefInterface, t_CefShow,"DrivingExamTheory", "[3]");
					    }
					    case 5:
					    {
					        MoralPacket_1(playerid, s_CefInterface, t_CefHide,"DrivingExamTheory");
					        MoralPacket_2(playerid, s_CefInterface, t_CefShow,"DrivingExamTheory", "[4]");
					    }
					}
				}
				else
				{
					Dialog
					(
						playerid, DIALOG_DRIVING_TUTORIAL_START, DIALOG_STYLE_MSGBOX,
						"{FFD83D}Введение",
						"{FFFFFF}Это пособие поможет вам хорошо подготовиться к экзамену по вождению. Для того чтобы начать обучение нажмите \'Далее\'.",
						"Далее", "Отмена"
					);
				}
			}
			case DIALOG_DRIVING_TUTORIAL:
			{
				new step = GetPVarInt(playerid, "driving_tutorial_step");
				if(response)
				{
					step ++;
				}
				else step --;

				if(step >= sizeof driving_tutorial)
				{
					Dialog
					(
						playerid, DIALOG_DRIVING_TUTORIAL_END, DIALOG_STYLE_MSGBOX,
						"{FFD83D}Завершение",
						"{FFFFFF}Надеемся вы все внимательно прочли и готовы приступить к сдаче экзамена\n"\
						"Если вы сомневаетесь в чем-либо, то рекомендуем не рисковать и прочитать нужный раздел еще раз!\n\n"\
						"{CC9900}Желаем Вам удачи на экзамене!\n"\
						"Для того, чтобы завершить обучение нажмите Выход",
						"Выход", "Назад"
					);
				}
				else if(step < 0)
				{
					ShowPlayerDrivingTutorial(playerid);
				}
				else
				{
					ShowDrivingTutorialSection(playerid, step);

					if(step == 1)
					{
						SpeedometrShowForPlayer(playerid);
					}
					else SpeedometrHideForPlayer(playerid);
				}
			}
			case DIALOG_DRIVING_TUTORIAL_END:
			{
				if(!response)
					ShowDrivingTutorialSection(playerid, sizeof driving_tutorial - 1);
			}
			case DIALOG_DRIVING_EXAM_INFO:
			{
				if(!response) return 1;

				if(GetPlayerData(playerid, P_DRIVING_LIC) >= 1) return SendClientMessage(playerid, 0xCECECEFF, "* У Вас уже есть права");

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 2500)) return SendClientMessage(playerid, 0xCECECEFF, "* Сдача на права стоит 2500 рублей");

				GivePlayerMoneyEx(playerid, -2500, "Сдача на права");
				SetPVarInt(playerid, "autoschool_point",9);

				new vehicleid = AddStaticVehicleEx(15121,1916.3922,1925.9412,15.6825,89.1559,17,17, 300, 0, VEHICLE_ACTION_TYPE_DRIVING_SCH);

				SetPlayerVirtualWorld(playerid, playerid + 1);

				SetVehicleVirtualWorld(vehicleid, playerid + 1);

				PutPlayerInVehicle(playerid, vehicleid, 0);
				SetPlayerInterior(playerid, 0);
				SendPacket_Plate(playerid, vehicleid, 1, GenerateCarNumberRu(), GenerateCarRegRu());
			}
			// -----------------------------------------------------------------
			case DIALOG_ATM:
			{
				if(response)
				{
					switch(listitem+1)
					{
						case 1,2: // Снять\Положить с банковского счета
						{
							ShowPlayerATMSelectSumDialog(playerid, !listitem);
						}
						case 3: // Баланс банковского счета
						{
							static fmt_str[64];
							format(fmt_str, sizeof fmt_str, "{FFFFFF}На Вашем банковском счету {00CC00}%s руб", formatStr(GetPlayerBankMoney(playerid)));

							Dialog
							(
								playerid, DIALOG_ATM_BALANCE, DIALOG_STYLE_MSGBOX,
								"{FFCD00}Баланс счета",
								fmt_str,
								"Назад", "Выйти"
							);
						}
						case 4: // Снять со счета предприятия
						{
							//ShowPlayerATMCompanyDialog(playerid, true);
							static query[256],
								Cache: result,
								biz_id,
								biz_name[64];

							mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE owner_id='%d'", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query, true);

							new rows = cache_num_rows();

							if(!rows)
								return SendClientMessage(playerid, 0x999999FF, "* У вас не одного бизнеса во владении.");

							vibor_biz_atm[playerid] = 2;

							string_dialog[0] = EOS;
							for(new i = 0; i < rows; i ++)
							{
								biz_id = cache_get_field_content_int(i, "id");
								cache_get_field_content(i, "name", biz_name);

								format(query, sizeof query, "{FFFFFF}%d. - %s (№%d)<t>Владелец\n", i + 1, biz_name, biz_id);
								strcat(string_dialog, query);
								SetPlayerListitemValue(playerid, i, biz_id-1);
							}

							Dialog
							(
								playerid, DIALOG_ATM_BIZ_LIST, DIALOG_STYLE_LIST,
								"{FFCD00}Выберите бизнес",
								string_dialog,
								"Выбрать", "Закрыть"
							);

							cache_delete(result);
						}
						case 5: // Положить на счет предприятия
						{
							//ShowPlayerATMCompanyDialog(playerid, false);
							static query[256],
								Cache: result,
								kiosk_id;

							mysql_format(mysql, query, sizeof query, "SELECT * FROM kiosk WHERE owner_id='%d'", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query, true);

							new rows = cache_num_rows();

							if(!rows)
								return SendClientMessage(playerid, 0x999999FF, "* У вас не одного киоска во владении.");

                            vibor_kiosk_atm[playerid] = 1;

							string_dialog[0] = EOS;
							for(new i = 0; i < rows; i ++)
							{
								kiosk_id = cache_get_field_content_int(i, "id");

								format(query, sizeof query, "{FFFFFF}Киоск №%d\n", kiosk_id);
								strcat(string_dialog, query);
								SetPlayerListitemValue(playerid, i, kiosk_id-1);
							}

							Dialog
							(
								playerid, DIALOG_ATM_KIOSK_LIST, DIALOG_STYLE_LIST,
								"{FFCD00}Выберите киоск",
								string_dialog,
								"Выбрать", "Закрыть"
							);

							cache_delete(result);
						}
						case 6: // Положить на счет предприятия
						{
							new biz_id,
								biz_name[64],
								query[256],
								Cache: result;

							mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE owner_id='%d'", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query, true);

							new rows = cache_num_rows();

							if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного бизнеса во владении.");

                            vibor_biz_atm[playerid] = 1;

							string_dialog = "";
							for(new i = 0; i < rows; i ++)
							{
								biz_id = cache_get_field_content_int(i, "id");
								cache_get_field_content(i, "name", biz_name);

								format(query, sizeof query, "{FFFFFF}%d. - %s (№%d)<t>Владелец\n", i + 1, biz_name, biz_id);
								strcat(string_dialog, query);
								SetPlayerListitemValue(playerid, i, biz_id-1);
							}

							Dialog
							(
								playerid, DIALOG_ATM_BIZ_LIST, DIALOG_STYLE_LIST,
								"{FFCD00}Выберите бизнес",
								string_dialog,
								"Выбрать", "Закрыть"
							);

							cache_delete(result);
						}
						case 7: // Пополнить мобильный телефон
						{
							if(GetPlayerPhone(playerid) != 0)
							{
								Dialog
								(
									playerid, DIALOG_ATM_PHONE_BALANCE, DIALOG_STYLE_INPUT,
									"{FFD83D}Пополнение мобильного телефона",
									"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
									"Готово", "Назад"
								);
							}
							else
							{
								SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в сотовом салоне");
								ShowPlayerATMDialog(playerid);
							}
						}
						case 8: // Безналичный перевод
						{
							if(GetPlayerLevel(playerid) >= 3)
							{
								Dialog
								(
									playerid, DIALOG_ATM_TRANSFER_MONEY_1, DIALOG_STYLE_INPUT,
									"{FFD83D}Безналичный перевод",
									"{FFFFFF}Укажите номер банковского счета:",
									"Далее", "Отмена"
								);
							}
							else SendClientMessage(playerid, 0x999999FF, "* Перевод денег доступен с 3 уровня");
						}
						case 9:
						{
							Dialog
							(
								playerid, DIALOG_ATM_TICKET_SELECT, DIALOG_STYLE_LIST,
								"{FFD83D}Оплатить штраф",
								"1. Посмотреть список своих штрафов\n"\
								"2. Оплатить штраф по его номеру\n"\
								"3. Оплатить все штрафы",
								"Далее", "Назад"
							);
						}
						case 10: ShowPlayerATMCharityDialog(playerid);
						case 11: // Благотворительность
						{
							static query[256],
								Cache: result,
								biz_id;

							mysql_format(mysql, query, sizeof query, "SELECT * FROM neftenasos WHERE owner_id='%d'", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query, true);

							new rows = cache_num_rows();

							if(!rows)
								return SendClientMessage(playerid, 0x999999FF, "* У вас не одного нефтенасоса во владении.");

							string_dialog[0] = EOS;
							for(new i = 0; i < rows; i ++)
							{
								biz_id = cache_get_field_content_int(i, "id");

								format(query, sizeof query, "{FFFFFF}Нефтенасос №%d\n", biz_id);
								strcat(string_dialog, query);
								SetPlayerListitemValue(playerid, i, biz_id-1);
							}

							Dialog
							(
								playerid, DIALOG_OWNABLE_NEFTENASOS_LIST, DIALOG_STYLE_LIST,
								"{FFCD00}Выберите нефтяной насос",
								string_dialog,
								"Далее", "Назад"
							);

							cache_delete(result);
						}
						default:
							return 1;
					}
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_TAKE_MONEY: // снять деньги
			{
				if(response)
				{
					if(0 <= listitem <= 6)
					{
						new sum = atm_item_sum[listitem];
						if(GetILPlayerInt(GetPlayerBankMoney(playerid), sum))
						{
							format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -sum));
							GivePlayerMoneyEx(playerid, sum, "Снятие денег с банкомата");

							static query[85];
							format(query, sizeof query, "UPDATE PlayersMorallwens SET money=%s,bank=%s WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid), GetPlayerBankMoney(playerid), GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "* На Вашем банковском счету недостаточно средств");
							ShowPlayerATMSelectSumDialog(playerid, true);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, true);
				}
				else
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_TAKE_OTHER_MONEY: // снять деньги (другая сума)
			{
				if(response)
				{
					if(IsILNumeric(inputtext))
					{
						if(GetILPlayerStr(GetPlayerBankMoney(playerid), inputtext))
						{
							new money_str[23];
							format(money_str, sizeof money_str, "-%s", inputtext);

							format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerStr(playerid, GetPlayerBankMoney(playerid), money_str));
							GivePlayerMoneyStr(playerid, inputtext, "Снятие денег с банкомата");

							static query[85];
							format(query, sizeof query, "UPDATE PlayersMorallwens SET bank=%s WHERE id=%d LIMIT 1", GetPlayerBankMoney(playerid), GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "* На Вашем банковском счету недостаточно средств");
							ShowPlayerATMSelectOtherSum(playerid, true);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, true);
				}
				else
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMSelectSumDialog(playerid, true);
				}
			}
			case DIALOG_ATM_PUT_MONEY: // положить деньги
			{
				if(response)
				{
					if(0 <= listitem <= 6)
					{
						new sum = atm_item_sum[listitem];
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), sum))
						{
							format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), sum));
							GivePlayerMoneyEx(playerid, -sum, "Пополнение денег в банкомате");

							static query[85];
							format(query, sizeof query, "UPDATE PlayersMorallwens SET money=%s,bank=%s WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid), GetPlayerBankMoney(playerid), GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "* У Вас с собой нет столько денег");
							ShowPlayerATMSelectSumDialog(playerid, false);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, false);
				}
				else
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
	       	case DIALOG_ATM_BIZ_LIST:
			{
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				SetPVarInt(playerid, "ownablebiz_id", idx);
				if(vibor_biz_atm[playerid] == 2)
				{
					Dialog
					(
						playerid, DIALOG_ATM_BIZ_TAKE_MONEY, DIALOG_STYLE_INPUT,
						"{FFCD00}Снятие с счёта бизнеса",
						"{FFFFFF}Укажите сумму, на которую хотите снять счёт данного бизнеса:",
						"Готово", "Назад"
					);
				}
				if(vibor_biz_atm[playerid] == 1)
				{
				    Dialog
					(
						playerid, DIALOG_ATM_BIZ_PUT_MONEY, DIALOG_STYLE_INPUT,
						"{FFCD00}Пополнение счёта бизнеса",
						"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
						"Готово", "Назад"
					);
				}
             }
            case DIALOG_ATM_KIOSK_LIST:
			{
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				static fmt_text[210];
				SetPVarInt(playerid, "ownablekiosk_id", idx);
				if(vibor_kiosk_atm[playerid] == 1)
				{
					format
				    (
				        fmt_text, sizeof fmt_text,
				        "{FFFFFF}Киоск: {006400}№%d\n"\
				        "{FFFFFF}Баланс: {006400}%s руб.\n\n"\
				        "{FFFFFF}Сколько вы хотите снять?",
				        idx, formatStr(GetKioskData(idx, K_BALANCE))
				    );

				    Dialog(playerid, DIALOG_ATM_KIOSK_TAKE_MONEY, DIALOG_STYLE_INPUT, "{FFCD00}Снятие средств", fmt_text, "Да", "Нет");
				}
    		}
			case DIALOG_ATM_PUT_OTHER_MONEY: // положить деньги (другая сума)
			{
				if(response)
				{
					if(IsILNumeric(inputtext))
					{
						if(!GetILPlayerStr(GetPlayerMoneyEx(playerid), inputtext)) return SCM(playerid, 0xCECECEFF, "* У Вас с собой нет столько денег"), ShowPlayerATMSelectOtherSum(playerid, false);

						format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerStr(playerid, GetPlayerBankMoney(playerid), inputtext));
						
						new money_str[23];
						format(money_str, sizeof money_str, "-%s", inputtext);
						GivePlayerMoneyStr(playerid, money_str, "Пополнение денег в банкомате", true, true);

						static query[149];
						format(query, sizeof query, "UPDATE PlayersMorallwens SET money=%s, bank=%s WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid), GetPlayerBankMoney(playerid), GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
						ShowPlayerATMDialog(playerid);
						
					}
					else ShowPlayerATMSelectOtherSum(playerid, false);
				}
				else
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMSelectSumDialog(playerid, false);
				}
			}
			case DIALOG_ATM_BALANCE:
			{
				if(response)
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_PHONE_BALANCE:
			{
				if(response)
				{
					new sum = strval(inputtext);
					if(sum > 0 && IsNumeric(inputtext))
					{
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), sum))
						{
							static query[128];

							format(query, sizeof query, "UPDATE PlayersMorallwens SET money=%s,phone_balance=%d WHERE id=%d LIMIT 1", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), -sum), GetPlayerData(playerid, P_PHONE_BALANCE)+sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								GivePlayerMoneyEx(playerid, -sum, "Пополнение счета телефона", false, true);
								AddPlayerData(playerid, P_PHONE_BALANCE, +, sum);

								format(query, sizeof query, "Вы пополнили счет мобильного телефона на {FF9900}%d руб", sum);
								SendClientMessage(playerid, 0x66CC00FF, query);

								format(query, sizeof query, "Сейчас на счету %d руб", GetPlayerData(playerid, P_PHONE_BALANCE));
								SendClientMessage(playerid, 0x66CC00FF, query);

								return 1;
							}
							else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 15)");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* У Вас не хватает денег");

						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}

					Dialog
					(
						playerid, DIALOG_ATM_PHONE_BALANCE, DIALOG_STYLE_INPUT,
						"{FFD83D}Пополнение мобильного телефона",
						"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
						"Готово", "Назад"
					);
				}
				else
				{
					ShowPlayerATMDialog(playerid);
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_SELECT_COMPANY_TAKE, DIALOG_ATM_SELECT_COMPANY_PUT:
			{
				if(response)
				{
					new bool: action = (dialogid == DIALOG_ATM_SELECT_COMPANY_TAKE);

					switch(listitem + 1)
					{
						case 1:
							ShowPlayerATMBusinessDialog(playerid, action);
					}
				}
				else
				{
					ShowPlayerATMDialog(playerid);
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_RCHANNEL: {
			if(!response || !(0<=listitem<=sizeof rChannelList)) return 1;

			if(!rChannelPlayer{playerid}) {
				SCMF(playerid, -1, "Вы успешно подключились к каналу 10%d.0", listitem);
				SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Hud').showVoiceChatButton(1)");
				rChannelPlayer{playerid} = listitem+1;
				rChannelList[GetPlayerTeamEx(playerid)-1][listitem]++;

				foreach(new i: Player) {
					if(i == playerid) continue;
					if(GetPlayerTeamEx(playerid) != GetPlayerTeamEx(i) || rChannelPlayer{playerid} != rChannelPlayer{i}) continue;

					CreatePacketRadio(i, (playerid+1000), 100);
					CreatePacketRadio(playerid, (i+1000), 100);
				}
			}
			else if(rChannelPlayer{playerid} == listitem+1) {
				SCM(playerid, -1, "Вы успешно отключились от канала");
				SendClientEventF(playerid, s_CefInterface, t_CefUpdate, "interface('Hud').hideVoiceChatButton(1)");
				rChannelList[GetPlayerTeamEx(playerid)-1][listitem]--;

				foreach(new i: Player) {
					if(i == playerid) continue;
					if(GetPlayerTeamEx(playerid) != GetPlayerTeamEx(i) || rChannelPlayer{playerid} != rChannelPlayer{i}) continue;

					VoiceCloseStream(i, (playerid+1000));
					VoiceCloseStream(playerid, (i+1000));
				}
				rChannelPlayer{playerid} = 0;
			}
			else {
				SCMF(playerid, -1, "Вы успешно сменили канал на 10%d.0", listitem);
				rChannelList[GetPlayerTeamEx(playerid)-1][listitem]++;
				rChannelList[GetPlayerTeamEx(playerid)-1][rChannelPlayer{playerid}-1]--;

				foreach(new i: Player) {
					if(i == playerid) continue;
					if(GetPlayerTeamEx(playerid) != GetPlayerTeamEx(i)) continue;

					if(rChannelPlayer{playerid} == rChannelPlayer{i}) {
						VoiceCloseStream(i, (playerid+1000));
						VoiceCloseStream(playerid, (i+1000));
					}
					else if(rChannelPlayer{i} == (listitem+1)) {
						CreatePacketRadio(i, (playerid+1000), 100);
						CreatePacketRadio(playerid, (i+1000), 100);
					}
				}
				rChannelPlayer{playerid} = listitem+1;
			}
		}
		case DIALOG_RCHANNEL_CREATE:
		{
			if(!response) return 1;

			if(strlen(inputtext) < 3 || strlen(inputtext) > 32)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Название канала должно содержать от 3 до 32 символов");
				Dialog(playerid, DIALOG_RCHANNEL_CREATE, DIALOG_STYLE_INPUT, "Создание канала", "Введите название канала:", "Создать", "Отмена");
				return 1;
			}

			static query[512];
			mysql_format(mysql, query, sizeof(query), "INSERT INTO rchannels (organ_id, owner_name, channel_name, created_at) VALUES (%d, '%e', '%e', NOW())",
				GetPlayerTeamEx(playerid), GetPlayerNameEx(playerid), inputtext);
			mysql_tquery(mysql, query, "OnCreateRChannel", "d", playerid);
			}
			case DIALOG_BY_EXIT_MVD:
			{
				if(!response) return 1;
				SendClientMessage(playerid,-1,"* Вы успешно выехали из парковки"); // Выводим оповещение
				SetVehiclePos(GetPlayerVehicleID(playerid), 210.4814,1367.2345,12.1203);
				SetVehicleZAngle(GetPlayerVehicleID(playerid), 169.9973);
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
			}
			case DIALOG_BY_EXIT_FSB:
			{
				if(!response) return 1;
				SendClientMessage(playerid,-1,"* Вы успешно выехали из парковки"); // Выводим оповещение
				SetVehiclePos(GetPlayerVehicleID(playerid), 2349.8892,-1720.4955,21.1117);
				SetVehicleZAngle(GetPlayerVehicleID(playerid), 179.2516);
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
			}
   			case DIALOG_BY_EXIT_HOSPITAL:
			{
				if(!response) return 1;
				SendClientMessage(playerid,-1,"* Вы успешно выехали из парковки"); // Выводим оповещение
				SetVehiclePos(GetPlayerVehicleID(playerid), 524.7027,1767.1598,11.9469);
				SetVehicleZAngle(GetPlayerVehicleID(playerid), 131.7351);
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
   			}
			case DIALOG_BY_EXIT_PRAVO:
			{
				if(!response) return 1;
				SendClientMessage(playerid,-1,"* Вы успешно выехали из парковки"); // Выводим оповещение
				SetVehiclePos(GetPlayerVehicleID(playerid), -2578.0903,1460.0402,48.4749);
				SetVehicleZAngle(GetPlayerVehicleID(playerid), 110.7341);
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
			}
   			case DIALOG_MVD_PARKOVKA:
			{
				if(!response) return 1;
				SetPlayerVirtualWorld(playerid, 3);
				SetPlayerInterior(playerid, 4);
				SetPlayerPos(playerid, 1615.7175,1831.2300,996.5703);
				SetPlayerFacingAngle(playerid, 180.8186);
   			}
			case DIALOG_FSB_PARKOVKA:
			{
				if(!response) return 1;
				SetPlayerVirtualWorld(playerid, 4);
				SetPlayerInterior(playerid, 4);
				SetPlayerPos(playerid, 1615.7175,1831.2300,996.5703);
				SetPlayerFacingAngle(playerid, 180.8186);
   			}
			case DIALOG_PRAVO_PARKOVKA:
			{
				if(!response) return 1;
				SetPlayerVirtualWorld(playerid, 7);
				SetPlayerInterior(playerid, 4);
				SetPlayerPos(playerid, 1615.7175,1831.2300,996.5703);
				SetPlayerFacingAngle(playerid, 180.8186);
   			}
   			case DIALOG_HOSPITAL_PARKOVKA:
			{
				if(!response) return 1;
				SetPlayerVirtualWorld(playerid, 2);
				SetPlayerInterior(playerid, 4);
				SetPlayerPos(playerid, 1615.7175,1831.2300,996.5703);
				SetPlayerFacingAngle(playerid, 180.8186);
   			}
			case DIALOG_BY_EXIT_SR:
			{
			    if(!response) return 1;
			    new vehicleid = GetPVarInt(playerid, "veh_id");

				new index = GetVehicleData(vehicleid, V_ACTION_ID);
				GetOwnableCarData(index, OC_POS_X) = GetOwnableCarData(index, OC_BY_POS_X);
				GetOwnableCarData(index, OC_POS_Y) = GetOwnableCarData(index, OC_BY_POS_Y);
				GetOwnableCarData(index, OC_POS_Z) = GetOwnableCarData(index, OC_BY_POS_Z);
				GetOwnableCarData(index, OC_ANGLE) = GetOwnableCarData(index, OC_BY_ANGLE);
				
				SendClientMessage(playerid, 0xFFDAB9FF, "Ваше т/с было снято с продажи");
				SendClientMessage(playerid, 0xFFA500FF, "* Ваш транспорт был снят с продажи, припаркован на том месте, где находился до аренды и выгружен");
				
				if(GetOwnableCarData(index, OC_BY_ID) == 2)
				{
    				bymestasr[GetOwnableCarData(index, OC_MESTOID)] = 0;
    			}

				static query[190];

			    format(query, sizeof query, "UPDATE ownable_cars SET inter=0,world=0 WHERE id=%d LIMIT 1",GetOwnableCarData(index, OC_SQL_ID));
			    mysql_tquery(mysql, query, "", "");

				SaveOwnableCar(vehicleid);

				UnloadPlayerOwnableCar(true, vehicleid);
			}
			case DIALOG_BY_EXIT:
			{
			    if(!response) return 1;
			    new vehicleid = GetPVarInt(playerid, "veh_id");

				new index = GetVehicleData(vehicleid, V_ACTION_ID);
				GetOwnableCarData(index, OC_POS_X) = GetOwnableCarData(index, OC_BY_POS_X);
				GetOwnableCarData(index, OC_POS_Y) = GetOwnableCarData(index, OC_BY_POS_Y);
				GetOwnableCarData(index, OC_POS_Z) = GetOwnableCarData(index, OC_BY_POS_Z);
				GetOwnableCarData(index, OC_ANGLE) = GetOwnableCarData(index, OC_BY_ANGLE);
				
				SendClientMessage(playerid, 0xFFDAB9FF, "Ваше т/с было снято с продажи");
				SendClientMessage(playerid, 0xFFA500FF, "* Ваш транспорт был снят с продажи, припаркован на том месте, где находился до аренды и выгружен");
				
				if(GetOwnableCarData(index, OC_BY_ID) == 1)
				{
    				bymestavis[GetOwnableCarData(index, OC_MESTOID)] = 0;
    			}

				static query[190];

			    format(query, sizeof query, "UPDATE ownable_cars SET inter=0,world=0 WHERE id=%d LIMIT 1",GetOwnableCarData(index, OC_SQL_ID));
			    mysql_tquery(mysql, query, "", "");

				SaveOwnableCar(vehicleid);

				UnloadPlayerOwnableCar(true, vehicleid);
			}
			case DIALOG_SET_MIN_PRICE:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new price = strval(inputtext);
				static str_c[128];
				static query[512];

				if(price < 500) return SCM(playerid, 0xCECECEFF, "* Минимальная цена не должна быть меньше 500 руб.");
				if(price > 50000) return SCM(playerid, 0xCECECEFF, "* Минимальная цена не должна быть более чем 50000 руб.");

				mysql_format(mysql, query, sizeof query, "UPDATE kiosk SET min_price=%d WHERE id=%d", price, GetKioskData(kiosk_id, K_SQL_ID));
				mysql_query(mysql, query, false);

				SetKioskData(kiosk_id, K_MIN_PRICE, price);

				format(str_c, sizeof str_c, "Вы успешно поставили минимальную цену в {FFFFFF}%d руб.", price);
				SCM(playerid, 0xADCEEAFF, str_c);
			}
			case DIALOG_SELL_ITEM_KIOSK:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new count = strval(inputtext);
				new h_count = GetIteam(playerid, GetPVarInt(playerid, "SellItem"));
				static str_c[248];

				if(count > h_count) return SCM(playerid, 0xCECECEFF, "* У вас нет столько единиц этого предмета.");
                if(0 >= count) return SCM(playerid, 0xCECECEFF, "* Некорректное значение.");

				SetPVarInt(playerid, "SellItemCount", count);

				format(str_c, sizeof str_c, "{FFFFFF}Введите цену за {006400}1 {FFFFFF}шт.\nЦена не должна быть меньше {006400}%d {FFFFFF}руб.", GetKioskData(kiosk_id, K_MIN_PRICE));

				Dialog(playerid, DIALOG_SELL_ITEM_PRICE, DIALOG_STYLE_INPUT, "Продажа предмета", str_c, "Далее", "Назад");
			}
			case DIALOG_SELL_NUMBER_KIOSK:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new price = strval(inputtext);
				static str_c[248];

				if(!IsILNumeric(inputtext)) return SCM(playerid, COLOR_RED, "* Ошибка ввода. Повторите попытку");
					
				if(!GetILPlayerStr("2000000000", inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену, до 2.000.000.000 руб");

				if(price < GetKioskData(kiosk_id, K_MIN_PRICE)) return SCM(playerid, 0xCECECEFF, "* Цена не должна быть менее указаной в диалоге");

				SetPVarInt(playerid, "SellItemPrice", price);

				format(str_c, sizeof str_c, "{FFFFFF}Вы собираетесь продать {006400}'Автомобильный номер'{FFFFFF}.\nВ количестве: {006400}1 {FFFFFF}шт.\nЦена за одну единицу товара: {006400}%d {FFFFFF} руб.", GetPVarInt(playerid, "SellItemPrice"));
				Dialog(playerid, DIALOG_SELL_NUMBER_ACCEPT, DIALOG_STYLE_MSGBOX, "Продажа автомобильного номера", str_c, "Готово", "Назад");
			}
			case DIALOG_SELL_ACS_KIOSK:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);

				new price = strval(inputtext);
				static str_c[248];

				if(!IsILNumeric(inputtext)) return SCM(playerid, COLOR_RED, "* Ошибка ввода. Повторите попытку");
					
				if(!GetILPlayerStr("2000000000", inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену, до 2.000.000.000 руб");
							
				if(price < GetKioskData(kiosk_id, K_MIN_PRICE)) return SCM(playerid, 0xCECECEFF, "* Цена не должна быть менее указаной в диалоге");

				SetPVarInt(playerid, "SellItemPrice", price);

				format(str_c, sizeof str_c, "{FFFFFF}Вы собираетесь продать {006400}'Аксессуар'{FFFFFF}.\nВ количестве: {006400}1 {FFFFFF}шт.\nЦена за одну единицу товара: {006400}%d {FFFFFF} руб.", GetPVarInt(playerid, "SellItemPrice"));
				Dialog(playerid, DIALOG_SELL_ACS_ACCEPT, DIALOG_STYLE_MSGBOX, "Продажа аксессуара", str_c, "Готово", "Назад");
			}
			case DIALOG_SELL_SKIN_KIOSK:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new price = strval(inputtext);
				static str_c[248];

				if(!IsILNumeric(inputtext)) return SCM(playerid, COLOR_RED, "* Ошибка ввода. Повторите попытку");
					
				if(!GetILPlayerStr("2000000000", inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену, до 2.000.000.000 руб");

				if(price < GetKioskData(kiosk_id, K_MIN_PRICE)) return SCM(playerid, 0xCECECEFF, "* Цена не должна быть менее указаной в диалоге");

				SetPVarInt(playerid, "SellItemPrice", price);

				format(str_c, sizeof str_c, "{FFFFFF}Вы собираетесь продать {006400}'Одежда'{FFFFFF}.\nВ количестве: {006400}1 {FFFFFF}шт.\nЦена за одну единицу товара: {006400}%d {FFFFFF} руб.", GetPVarInt(playerid, "SellItemPrice"));
				Dialog(playerid, DIALOG_SELL_SKIN_ACCEPT, DIALOG_STYLE_MSGBOX, "Продажа одежды", str_c, "Готово", "Назад");
			}
			case DIALOG_SELL_ITEM_PRICE:
			{
				if(!response) return 1;

				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				new price = strval(inputtext);
				static str_c[248];
				new count = GetPVarInt(playerid, "SellItemCount");

				if(!IsILNumeric(inputtext)) return SCM(playerid, COLOR_RED, "* Ошибка ввода. Повторите попытку");

				if(!GetILPlayerStr("80000000", inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "*Укажите корректную цену, до 80.000.000 руб");

				if(price < GetKioskData(kiosk_id, K_MIN_PRICE)) return SCM(playerid, 0xCECECEFF, "* Цена не должна быть менее минимально указанной владельцем киоска");

				SetPVarInt(playerid, "SellItemPrice", price);

				format(str_c, sizeof str_c, "{FFFFFF}Вы собираетесь продать {006400}'Предмет'{FFFFFF}.\nВ количестве: {006400}%d {FFFFFF}шт.\nЦена за одну единицу товара: {006400}%d {FFFFFF} руб.", GetPVarInt(playerid, "SellItemCount"), GetPVarInt(playerid, "SellItemPrice"));

				if(!(1 <= count)) return SendClientMessage(playerid, 0xCECECEFF, "* *Неккоректное значение");

				Dialog(playerid, DIALOG_SELL_ITEM_ACCEPT, DIALOG_STYLE_MSGBOX, "Продажа предмета", str_c, "Готово", "Назад");
			}
			case DIALOG_BY_EXIT_NIZ:
			{
			    if(!response) return 1;
			    new vehicleid = GetPVarInt(playerid, "veh_id");

				new index = GetVehicleData(vehicleid, V_ACTION_ID);
				GetOwnableCarData(index, OC_POS_X) = GetOwnableCarData(index, OC_BY_POS_X);
				GetOwnableCarData(index, OC_POS_Y) = GetOwnableCarData(index, OC_BY_POS_Y);
				GetOwnableCarData(index, OC_POS_Z) = GetOwnableCarData(index, OC_BY_POS_Z);
				GetOwnableCarData(index, OC_ANGLE) = GetOwnableCarData(index, OC_BY_ANGLE);
				
				SendClientMessage(playerid, 0xFFDAB9FF, "Ваше т/с было снято с продажи");
				SendClientMessage(playerid, 0xFFA500FF, "* Ваш транспорт был снят с продажи, припаркован на том месте, где находился до аренды и выгружен");

				if(GetOwnableCarData(index, OC_BY_ID) == 3)
				{
					bymestaniz[GetOwnableCarData(index, OC_MESTOID)] = 0;
				}

				static query[190];

			    format(query, sizeof query, "UPDATE ownable_cars SET inter=0,world=0 WHERE id=%d LIMIT 1",GetOwnableCarData(index, OC_SQL_ID));
			    mysql_tquery(mysql, query, "", "");

				SaveOwnableCar(vehicleid);

				UnloadPlayerOwnableCar(true, vehicleid);
			}
            case DIALOG_BUY_MARIH:
			{
			    if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 2500000)) return SendClientMessage(playerid, -1, "* У Вас недостаточно средств!");

				GiveIteam(playerid,172, 1, 5, 0);
				SCM(playerid, 0xCECECEFF, "* {ff9900}Вы купили {FFFFFF}`Семена марихуаны` {ff9900}в количестве {FFFFFF}5 {ff9900}шт за {FFFFFF}2.500.000 {ff9900}руб");
				GivePlayerMoneyEx(playerid, -2500000, "Покупка Марихуаны");
				return 1;
			}
			case DIALOG_KIOSK_MIN_PRICE:
			{
				if(!response) return 1;
				if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену налога");
				if(strlen(inputtext) > 9) return SendClientMessage(playerid, 0xFF6600FF, "* Не больше 9-ти символов!");
				new nalog = strval(inputtext);
				if(!(500 <= nalog))
					return SendClientMessage(playerid, 0xCECECEFF, "* Минимальная цена с 500 рублей.");
				if(!(50000 > nalog))
					return SendClientMessage(playerid, 0xCECECEFF, "* Максимальная цена до 50.000 рублей.");
				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				SetKioskData(kiosk_id, K_MIN_PRICE,nalog);
				static fmt_text[144];
				mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE kiosk SET min_price=%d WHERE id=%d", GetKioskData(kiosk_id, K_MIN_PRICE), GetKioskData(kiosk_id, K_SQL_ID));
				mysql_query(mysql, fmt_text, false);
				format(fmt_text, sizeof fmt_text,"Вы установили новую минимальную цену на продажу товара {FFFFFF}%d {FFA500}руб.",nalog);
				SendClientMessage(playerid, 0xFFA500FF, fmt_text);
			}
			case DIALOG_SELL_CAR_ELITE:
			{
				if(!response) return 1;
				if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену продажи");
				if(strlen(inputtext) > 9) return SendClientMessage(playerid, 0xFF6600FF, "* Не больше 9-ти символов!");
				new sell_price = strval(inputtext);
				new vehicleid = GetPlayerVehicleID(playerid);

				new vehicleid1 = GetPlayerOwnableCarLast(playerid);

				if(vehicleid1 != GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");
                new index = GetVehicleData(vehicleid, V_ACTION_ID);

                //new model_id = GetVehicleData(vehicleid, V_MODELID);
				//new car_price = GetVehicleInfo(model_id, VI_PRICE);

				if(!(3000 <= sell_price))
					return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость должа быть от 3000 рублей");

				GetVehiclePos(vehicleid, GetOwnableCarData(index, OC_BY_POS_X), GetOwnableCarData(index, OC_BY_POS_Y), GetOwnableCarData(index, OC_BY_POS_Z));
				GetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_BY_ANGLE));


				if(bymestavis[1] == 0) SetVehiclePos(vehicleid, g_load_car_market[1][POS_MESTO_X_2],g_load_car_market[1][POS_MESTO_Y_2],g_load_car_market[1][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[1][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 1), bymestavis[1] = 1;
                else if(bymestavis[2] == 0) SetVehiclePos(vehicleid, g_load_car_market[2][POS_MESTO_X_2],g_load_car_market[2][POS_MESTO_Y_2],g_load_car_market[2][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[2][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 2), bymestavis[2] = 1;
				else if(bymestavis[3] == 0) SetVehiclePos(vehicleid, g_load_car_market[3][POS_MESTO_X_2],g_load_car_market[3][POS_MESTO_Y_2],g_load_car_market[3][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[3][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 3), bymestavis[3] = 1;
				else if(bymestavis[4] == 0) SetVehiclePos(vehicleid, g_load_car_market[4][POS_MESTO_X_2],g_load_car_market[4][POS_MESTO_Y_2],g_load_car_market[4][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[4][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 4), bymestavis[4] = 1;
				else if(bymestavis[5] == 0) SetVehiclePos(vehicleid, g_load_car_market[5][POS_MESTO_X_2],g_load_car_market[5][POS_MESTO_Y_2],g_load_car_market[5][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[5][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 5), bymestavis[5] = 1;
				else if(bymestavis[6] == 0) SetVehiclePos(vehicleid, g_load_car_market[6][POS_MESTO_X_2],g_load_car_market[6][POS_MESTO_Y_2],g_load_car_market[6][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[6][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 6), bymestavis[6] = 1;
				else if(bymestavis[7] == 0) SetVehiclePos(vehicleid, g_load_car_market[7][POS_MESTO_X_2],g_load_car_market[7][POS_MESTO_Y_2],g_load_car_market[7][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[7][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 7), bymestavis[7] = 1;
				else if(bymestavis[8] == 0) SetVehiclePos(vehicleid, g_load_car_market[8][POS_MESTO_X_2],g_load_car_market[8][POS_MESTO_Y_2],g_load_car_market[8][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[8][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 8), bymestavis[8] = 1;
				else if(bymestavis[9] == 0) SetVehiclePos(vehicleid, g_load_car_market[9][POS_MESTO_X_2],g_load_car_market[9][POS_MESTO_Y_2],g_load_car_market[9][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[9][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 9), bymestavis[9] = 1;
				else if(bymestavis[10] == 0) SetVehiclePos(vehicleid, g_load_car_market[10][POS_MESTO_X_2],g_load_car_market[10][POS_MESTO_Y_2],g_load_car_market[10][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[10][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 10), bymestavis[10] = 1;
				else if(bymestavis[11] == 0) SetVehiclePos(vehicleid, g_load_car_market[11][POS_MESTO_X_2],g_load_car_market[11][POS_MESTO_Y_2],g_load_car_market[11][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[11][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 11), bymestavis[11] = 1;
				else if(bymestavis[12] == 0) SetVehiclePos(vehicleid, g_load_car_market[12][POS_MESTO_X_2],g_load_car_market[12][POS_MESTO_Y_2],g_load_car_market[12][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[12][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 12), bymestavis[12] = 1;
				else if(bymestavis[13] == 0) SetVehiclePos(vehicleid, g_load_car_market[13][POS_MESTO_X_2],g_load_car_market[13][POS_MESTO_Y_2],g_load_car_market[13][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[13][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 13), bymestavis[13] = 1;
				else if(bymestavis[14] == 0) SetVehiclePos(vehicleid, g_load_car_market[14][POS_MESTO_X_2],g_load_car_market[14][POS_MESTO_Y_2],g_load_car_market[14][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[14][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 14), bymestavis[14] = 1;
				else if(bymestavis[15] == 0) SetVehiclePos(vehicleid, g_load_car_market[15][POS_MESTO_X_2],g_load_car_market[15][POS_MESTO_Y_2],g_load_car_market[15][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[15][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 15), bymestavis[15] = 1;
				else if(bymestavis[16] == 0) SetVehiclePos(vehicleid, g_load_car_market[16][POS_MESTO_X_2],g_load_car_market[16][POS_MESTO_Y_2],g_load_car_market[16][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[16][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 16), bymestavis[16] = 1;
				else if(bymestavis[17] == 0) SetVehiclePos(vehicleid, g_load_car_market[17][POS_MESTO_X_2],g_load_car_market[17][POS_MESTO_Y_2],g_load_car_market[17][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[17][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 17), bymestavis[17] = 1;
				else if(bymestavis[18] == 0) SetVehiclePos(vehicleid, g_load_car_market[18][POS_MESTO_X_2],g_load_car_market[18][POS_MESTO_Y_2],g_load_car_market[18][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[18][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 18), bymestavis[18] = 1;
				else if(bymestavis[19] == 0) SetVehiclePos(vehicleid, g_load_car_market[19][POS_MESTO_X_2],g_load_car_market[19][POS_MESTO_Y_2],g_load_car_market[19][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[19][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 19), bymestavis[19] = 1;
				else if(bymestavis[20] == 0) SetVehiclePos(vehicleid, g_load_car_market[20][POS_MESTO_X_2],g_load_car_market[20][POS_MESTO_Y_2],g_load_car_market[20][POS_MESTO_Z_2]),SetVehicleZAngle(vehicleid,g_load_car_market[20][POS_MESTO_ANGEL_2]), SetOwnableCarData(index, OC_MESTOID, 20), bymestavis[20] = 1;
				else return SendClientMessage(playerid, -1, "* Все места на бу рынке заняты.");

				static str[300], fmt[64];
				if(GetPlayerPhone(playerid) != 0) format(fmt, sizeof fmt,"%s", GetPlayerPhone(playerid));
				else format(fmt, sizeof fmt,"отсутствует");

				format(str, sizeof str,
				"{FFA500}Модель:{FFFFFF} %s\n"\
				"{FFA500}Продавец:{FFFFFF} %s\n"\
				"{FFA500}Цена:{FFFFFF} %s {FFA500}руб\n"\
				"{FFA500}Телефон:{FFFFFF} %d",
				GetVehicleName(vehicleid), GetPlayerNameEx(playerid), formatInt(strval(inputtext)), fmt);

				CreateVehicleLabel(vehicleid, str, 0xFFFFFFFF, 0.0, 0.0, 1.0, 8);

				SendClientMessage(playerid, 0xFFA500FF, "* Вы арендовали место на парковке на 60 минут. Сядьте в т/с, если хотите снять его с продажи.");
				SendClientMessage(playerid, 0xFFA500FF, "* Внимание! Если вы покинете авторынок более чем на 3 минут(ы) весь ваш транспорт будет снят с продажи.");
				SendClientMessage(playerid, 0xFFA500FF, "* Для смены цены продажи транспорта встаньте возле него и используйте {"#cW"}/cm_price.");
				SendClientMessage(playerid, 0xFFA500FF, "* Так же можете предложить тест-драйв другому игроку {"#cW"}/cm_test_drive.");

				SetPlayerInBiz(playerid, GetPVarInt(playerid, "by_id"));

				SetVehicleParam(vehicleid, V_ENGINE, false);

				SetPlayerInterior(playerid, 4);
				LinkVehicleToInterior(vehicleid, 4);

				SetPlayerVirtualWorld(playerid, 263);
				SetVehicleVirtualWorld(vehicleid, 263);

				SetPVarInt(playerid, "in_by", 1);
				SetOwnableCarData(index, OC_BY_ID, 1);

				new businessid = GetPVarInt(playerid, "by_id");

				GivePlayerMoneyEx(playerid, -GetBusinessData(businessid, B_ARENDA_PRICE), "место на б/у рынке", true, true);

				AddBusinessProfit(playerid, businessid, GetBusinessData(businessid, B_ARENDA_PRICE), 0);
				return 1;
			}
			case DIALOG_SELL_CAR_NIZ:
			{
				if(!response) return 1;
				if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену продажи");
				if(strlen(inputtext) > 9) return SendClientMessage(playerid, 0xFF6600FF, "* Не больше 9-ти символов!");
				new sell_price = strval(inputtext);
				new vehicleid = GetPlayerVehicleID(playerid);

				new vehicleid1 = GetPlayerOwnableCarLast(playerid);

				if(vehicleid1 != GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");
                new index = GetVehicleData(vehicleid, V_ACTION_ID);

				if(!(3000 <= sell_price))
					return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость должа быть от 3000 рублей");

				GetVehiclePos(vehicleid, GetOwnableCarData(index, OC_BY_POS_X), GetOwnableCarData(index, OC_BY_POS_Y), GetOwnableCarData(index, OC_BY_POS_Z));
				GetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_BY_ANGLE));

				if(bymestaniz[1] == 0) SetVehiclePos(vehicleid, g_load_car_market[1][POS_MESTO_X_3],g_load_car_market[1][POS_MESTO_Y_3],g_load_car_market[1][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[1][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 1), bymestaniz[1] = 1;
                else if(bymestaniz[2] == 0) SetVehiclePos(vehicleid, g_load_car_market[2][POS_MESTO_X_3],g_load_car_market[2][POS_MESTO_Y_3],g_load_car_market[2][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[2][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 2), bymestaniz[2] = 1;
				else if(bymestaniz[3] == 0) SetVehiclePos(vehicleid, g_load_car_market[3][POS_MESTO_X_3],g_load_car_market[3][POS_MESTO_Y_3],g_load_car_market[3][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[3][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 3), bymestaniz[3] = 1;
				else if(bymestaniz[4] == 0) SetVehiclePos(vehicleid, g_load_car_market[4][POS_MESTO_X_3],g_load_car_market[4][POS_MESTO_Y_3],g_load_car_market[4][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[4][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 4), bymestaniz[4] = 1;
				else if(bymestaniz[5] == 0) SetVehiclePos(vehicleid, g_load_car_market[5][POS_MESTO_X_3],g_load_car_market[5][POS_MESTO_Y_3],g_load_car_market[5][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[5][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 5), bymestaniz[5] = 1;
				else if(bymestaniz[6] == 0) SetVehiclePos(vehicleid, g_load_car_market[6][POS_MESTO_X_3],g_load_car_market[6][POS_MESTO_Y_3],g_load_car_market[6][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[6][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 6), bymestaniz[6] = 1;
				else if(bymestaniz[7] == 0) SetVehiclePos(vehicleid, g_load_car_market[7][POS_MESTO_X_3],g_load_car_market[7][POS_MESTO_Y_3],g_load_car_market[7][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[7][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 7), bymestaniz[7] = 1;
				else if(bymestaniz[8] == 0) SetVehiclePos(vehicleid, g_load_car_market[8][POS_MESTO_X_3],g_load_car_market[8][POS_MESTO_Y_3],g_load_car_market[8][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[8][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 8), bymestaniz[8] = 1;
				else if(bymestaniz[9] == 0) SetVehiclePos(vehicleid, g_load_car_market[9][POS_MESTO_X_3],g_load_car_market[9][POS_MESTO_Y_3],g_load_car_market[9][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[9][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 9), bymestaniz[9] = 1;
				else if(bymestaniz[10] == 0) SetVehiclePos(vehicleid, g_load_car_market[10][POS_MESTO_X_3],g_load_car_market[10][POS_MESTO_Y_3],g_load_car_market[10][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[10][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 10), bymestaniz[10] = 1;
				else if(bymestaniz[11] == 0) SetVehiclePos(vehicleid, g_load_car_market[11][POS_MESTO_X_3],g_load_car_market[11][POS_MESTO_Y_3],g_load_car_market[11][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[11][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 11), bymestaniz[11] = 1;
				else if(bymestaniz[12] == 0) SetVehiclePos(vehicleid, g_load_car_market[12][POS_MESTO_X_3],g_load_car_market[12][POS_MESTO_Y_3],g_load_car_market[12][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[12][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 12), bymestaniz[12] = 1;
				else if(bymestaniz[13] == 0) SetVehiclePos(vehicleid, g_load_car_market[13][POS_MESTO_X_3],g_load_car_market[13][POS_MESTO_Y_3],g_load_car_market[13][POS_MESTO_Z_3]),SetVehicleZAngle(vehicleid,g_load_car_market[13][POS_MESTO_ANGEL_3]), SetOwnableCarData(index, OC_MESTOID, 13), bymestaniz[13] = 1;
				else return SendClientMessage(playerid, -1, "* Все места на бу рынке заняты.");

				static str[300], fmt[64];
				if(GetPlayerPhone(playerid) != 0) format(fmt, sizeof fmt,"%s", GetPlayerPhone(playerid));
				else format(fmt, sizeof fmt,"отсутствует");

				format(str, sizeof str,
				"{FFA500}Модель:{FFFFFF} %s\n"\
				"{FFA500}Продавец:{FFFFFF} %s\n"\
				"{FFA500}Цена:{FFFFFF} %s {FFA500}руб\n"\
				"{FFA500}Телефон:{FFFFFF} %d",
				GetVehicleName(vehicleid), GetPlayerNameEx(playerid), formatInt(strval(inputtext)), fmt);

				CreateVehicleLabel(vehicleid, str, 0xFFFFFFFF, 0.0, 0.0, 1.0, 8);

				SendClientMessage(playerid, 0xFFA500FF, "* Вы арендовали место на парковке на 60 минут. Сядьте в т/с, если хотите снять его с продажи.");
				SendClientMessage(playerid, 0xFFA500FF, "* Внимание! Если вы покинете авторынок более чем на 3 минут(ы) весь ваш транспорт будет снят с продажи.");
				SendClientMessage(playerid, 0xFFA500FF, "* Для смены цены продажи транспорта встаньте возле него и используйте {"#cW"}/cm_price.");
				SendClientMessage(playerid, 0xFFA500FF, "* Так же можете предложить тест-драйв другому игроку {"#cW"}/cm_test_drive.");

				SetPlayerInBiz(playerid, GetPVarInt(playerid, "by_id"));

				SetVehicleParam(vehicleid, V_ENGINE, false);

				SetPlayerInterior(playerid, 4);
				LinkVehicleToInterior(vehicleid, 4);

				SetPlayerVirtualWorld(playerid, 261);
				SetVehicleVirtualWorld(vehicleid, 261);

				SetPVarInt(playerid, "in_by", 1);
				SetOwnableCarData(index, OC_BY_ID, 3);

				new businessid = GetPVarInt(playerid, "by_id");

				GivePlayerMoneyEx(playerid, -GetBusinessData(businessid, B_ARENDA_PRICE), "место на б/у рынке", true, true);

				AddBusinessProfit(playerid, businessid, GetBusinessData(businessid, B_ARENDA_PRICE), 0);
				return 1;
			}
			case DIALOG_SELL_CAR_SR:
			{
				if(!response) return 1;
				if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену продажи");
				if(strlen(inputtext) > 9) return SendClientMessage(playerid, 0xFF6600FF, "* Не больше 9-ти символов!");
				new sell_price = strval(inputtext);
				new vehicleid = GetPlayerVehicleID(playerid);

				new vehicleid1 = GetPlayerOwnableCarLast(playerid);

				if(vehicleid1 != GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");
                new index = GetVehicleData(vehicleid, V_ACTION_ID);

				if(!(3000 <= sell_price))
					return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость должа быть от 3000 рублей");

				GetVehiclePos(vehicleid, GetOwnableCarData(index, OC_BY_POS_X), GetOwnableCarData(index, OC_BY_POS_Y), GetOwnableCarData(index, OC_BY_POS_Z));
				GetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_BY_ANGLE));
					
					
                if(bymestasr[1] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[1][POS_MESTO_X_1],g_load_car_market[1][POS_MESTO_Y_1],g_load_car_market[1][POS_MESTO_Z_1],g_load_car_market[1][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 1), bymestasr[1] = 1;
                else if(bymestasr[2] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[2][POS_MESTO_X_1],g_load_car_market[2][POS_MESTO_Y_1],g_load_car_market[2][POS_MESTO_Z_1],g_load_car_market[2][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 2), bymestasr[2] = 1;
				else if(bymestasr[3] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[3][POS_MESTO_X_1],g_load_car_market[3][POS_MESTO_Y_1],g_load_car_market[3][POS_MESTO_Z_1],g_load_car_market[3][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 3), bymestasr[3] = 1;
				else if(bymestasr[4] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[4][POS_MESTO_X_1],g_load_car_market[4][POS_MESTO_Y_1],g_load_car_market[4][POS_MESTO_Z_1],g_load_car_market[4][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 4), bymestasr[4] = 1;
				else if(bymestasr[5] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[5][POS_MESTO_X_1],g_load_car_market[5][POS_MESTO_Y_1],g_load_car_market[5][POS_MESTO_Z_1],g_load_car_market[5][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 5), bymestasr[5] = 1;
				else if(bymestasr[6] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[6][POS_MESTO_X_1],g_load_car_market[6][POS_MESTO_Y_1],g_load_car_market[6][POS_MESTO_Z_1],g_load_car_market[6][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 6), bymestasr[6] = 1;
				else if(bymestasr[7] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[7][POS_MESTO_X_1],g_load_car_market[7][POS_MESTO_Y_1],g_load_car_market[7][POS_MESTO_Z_1],g_load_car_market[7][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 7), bymestasr[7] = 1;
				else if(bymestasr[8] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[8][POS_MESTO_X_1],g_load_car_market[8][POS_MESTO_Y_1],g_load_car_market[8][POS_MESTO_Z_1],g_load_car_market[8][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 8), bymestasr[8] = 1;
				else if(bymestasr[9] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[9][POS_MESTO_X_1],g_load_car_market[9][POS_MESTO_Y_1],g_load_car_market[9][POS_MESTO_Z_1],g_load_car_market[9][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 9), bymestasr[9] = 1;
				else if(bymestasr[10] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[10][POS_MESTO_X_1],g_load_car_market[10][POS_MESTO_Y_1],g_load_car_market[10][POS_MESTO_Z_1],g_load_car_market[10][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 10), bymestasr[10] = 1;
				else if(bymestasr[11] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[11][POS_MESTO_X_1],g_load_car_market[11][POS_MESTO_Y_1],g_load_car_market[11][POS_MESTO_Z_1],g_load_car_market[11][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 11), bymestasr[11] = 1;
				else if(bymestasr[12] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[12][POS_MESTO_X_1],g_load_car_market[12][POS_MESTO_Y_1],g_load_car_market[12][POS_MESTO_Z_1],g_load_car_market[12][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 12), bymestasr[12] = 1;
				else if(bymestasr[13] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[13][POS_MESTO_X_1],g_load_car_market[13][POS_MESTO_Y_1],g_load_car_market[13][POS_MESTO_Z_1],g_load_car_market[13][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 13), bymestasr[13] = 1;
				else if(bymestasr[14] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[14][POS_MESTO_X_1],g_load_car_market[14][POS_MESTO_Y_1],g_load_car_market[14][POS_MESTO_Z_1],g_load_car_market[14][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 14), bymestasr[14] = 1;
				else if(bymestasr[15] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[15][POS_MESTO_X_1],g_load_car_market[15][POS_MESTO_Y_1],g_load_car_market[15][POS_MESTO_Z_1],g_load_car_market[15][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 15), bymestasr[15] = 1;
				else if(bymestasr[16] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[16][POS_MESTO_X_1],g_load_car_market[16][POS_MESTO_Y_1],g_load_car_market[16][POS_MESTO_Z_1],g_load_car_market[16][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 16), bymestasr[16] = 1;
				else if(bymestasr[17] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[17][POS_MESTO_X_1],g_load_car_market[17][POS_MESTO_Y_1],g_load_car_market[17][POS_MESTO_Z_1],g_load_car_market[17][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 17), bymestasr[17] = 1;
				else if(bymestasr[18] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[18][POS_MESTO_X_1],g_load_car_market[18][POS_MESTO_Y_1],g_load_car_market[18][POS_MESTO_Z_1],g_load_car_market[18][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 18), bymestasr[18] = 1;
				else if(bymestasr[19] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[19][POS_MESTO_X_1],g_load_car_market[19][POS_MESTO_Y_1],g_load_car_market[19][POS_MESTO_Z_1],g_load_car_market[19][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 19), bymestasr[19] = 1;
				else if(bymestasr[20] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[20][POS_MESTO_X_1],g_load_car_market[20][POS_MESTO_Y_1],g_load_car_market[20][POS_MESTO_Z_1],g_load_car_market[20][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 20), bymestasr[20] = 1;
				else if(bymestasr[21] == 0) SetVehiclePosAc(vehicleid, g_load_car_market[21][POS_MESTO_X_1],g_load_car_market[21][POS_MESTO_Y_1],g_load_car_market[21][POS_MESTO_Z_1],g_load_car_market[21][POS_MESTO_ANGEL_1]), SetOwnableCarData(index, OC_MESTOID, 21), bymestasr[21] = 1;
				else return SendClientMessage(playerid, -1, "* Все места на бу рынке заняты.");

				static str[300], fmt[64];
				if(GetPlayerPhone(playerid) != 0) format(fmt, sizeof fmt,"%s", GetPlayerPhone(playerid));
				else format(fmt, sizeof fmt,"отсутствует");

				format(str, sizeof str,
				"{FFA500}Модель:{FFFFFF} %s\n"\
				"{FFA500}Продавец:{FFFFFF} %s\n"\
				"{FFA500}Цена:{FFFFFF} %s {FFA500}руб\n"\
				"{FFA500}Телефон:{FFFFFF} %d",
				GetVehicleName(vehicleid), GetPlayerNameEx(playerid), formatInt(strval(inputtext)), fmt);

				CreateVehicleLabel(vehicleid, str, 0xFFFFFFFF, 0.0, 0.0, 1.0, 8);

				SendClientMessage(playerid, 0xFFA500FF, "* Вы арендовали место на парковке на 60 минут. Сядьте в т/с, если хотите снять его с продажи.");
				SendClientMessage(playerid, 0xFFA500FF, "* Внимание! Если вы покинете авторынок более чем на 3 минут(ы) весь ваш транспорт будет снят с продажи.");
				SendClientMessage(playerid, 0xFFA500FF, "* Для смены цены продажи транспорта встаньте возле него и используйте {"#cW"}/cm_price.");
				SendClientMessage(playerid, 0xFFA500FF, "* Так же можете предложить тест-драйв другому игроку {"#cW"}/cm_test_drive.");

				SetPlayerInBiz(playerid, GetPVarInt(playerid, "by_id"));

				SetVehicleParam(vehicleid, V_ENGINE, false);

				SetPlayerInterior(playerid, 4);
				LinkVehicleToInterior(vehicleid, 4);

				SetPlayerVirtualWorld(playerid, 262);
				SetVehicleVirtualWorld(vehicleid, 262);

				SetPVarInt(playerid, "in_by", 1);
				SetOwnableCarData(index, OC_BY_ID, 2);

				new businessid = GetPVarInt(playerid, "by_id");

				GivePlayerMoneyEx(playerid, -GetBusinessData(businessid, B_ARENDA_PRICE), "место на б/у рынке", true, true);
				AddBusinessProfit(playerid, businessid, GetBusinessData(businessid, B_ARENDA_PRICE), 0);
				return 1;
			}
			case DIALOG_KIOSK_NALOG:
			{
				if(!response) return 1;
				if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену налога");
				if(strlen(inputtext) > 9) return SendClientMessage(playerid, 0xFF6600FF, "* Не больше 9-ти символов!");
				new nalog = strval(inputtext);
				if(!(1 <= nalog <= 25))
					return SendClientMessage(playerid, 0xCECECEFF, "* Процент налога должен быть от 1 до 25.");
				new kiosk_id = GetNearestKiosk(playerid, 7.0);
				SetKioskData(kiosk_id, K_NALOG,nalog);
				static fmt_text[144];
				mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE kiosk SET nalog=%d WHERE id=%d", GetKioskData(kiosk_id, K_NALOG), GetKioskData(kiosk_id, K_SQL_ID));
				mysql_query(mysql, fmt_text, false);
				format(fmt_text, sizeof fmt_text,"Вы установили новый налог на продажу товара {FFFFFF}%d {FFA500}процента(ов).",nalog);
				SendClientMessage(playerid, 0xFFA500FF, fmt_text);
				UpdKioskss(playerid);
			}
			case DIALOG_ATM_BIZ_TAKE_MONEY:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);

						if(!GetILPlayerStr("2000000000", inputtext)) return SCM(playerid, COLOR_GREY, "* С счета предприятия можно снять до 2.000.000.000 руб за раз");

						if(IsILNumeric(inputtext))
						{
							if(GetILPlayerInt(GetBusinessData(businessid, B_BALANCE), sum))
							{
								static query[128 + 1];

								format(query, sizeof query, "UPDATE PlayersMorallwens a, business b SET a.money=%s,b.balance=%s WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), sum), SetILPlayerInt(playerid, g_business[businessid][B_BALANCE], -sum), GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									format(g_business[businessid][B_BALANCE], 21, "%s", SetILPlayerInt(playerid, g_business[businessid][B_BALANCE], -sum));
									
									GivePlayerMoneyEx(playerid, sum, "+ Снятие средств со счета Бизнеса", false, true);

									ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);

									return 1;
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* На счету предприятия нет такой суммы");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка ввода, повторите попытку");
					}
					else
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_KIOSK_TAKE_MONEY:
			{
				new kiosksid = GetPVarInt(playerid, "ownablekiosk_id");
				if(kiosksid != -1)
				{
					if(response)
					{
						if(IsILNumeric(inputtext))
						{
							if(GetILPlayerStr(GetKioskData(kiosksid, K_BALANCE), inputtext))
							{
								static query[128 + 1];

								format(query, sizeof query, "-%s", inputtext);

								format(query, sizeof query, "UPDATE kiosk SET balance=%s WHERE id=%d", 
								SetILPlayerStr(playerid, g_kiosk[kiosksid][K_BALANCE], query), GetKioskData(kiosksid, K_SQL_ID));
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									format(query, sizeof query, "-%s", inputtext);
									format(g_kiosk[kiosksid][K_BALANCE], 21, "%s", SetILPlayerStr(playerid, g_kiosk[kiosksid][K_BALANCE], query));

									GivePlayerMoneyStr(playerid, inputtext, "+ Снятие средств со счета киоска");

									ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);

									return 1;
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* На счету киоска нет такой суммы");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка ввода, повторите попытку");
					}
					else
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_NEFTENASOS_PUT_MONEY:
			{
				new neftid = GetPVarInt(playerid, "ownableneft_id");
				if(neftid == -1) return 1;
				if(!response) return ShowPlayerATMDialog(playerid);
				new sum = strval(inputtext);
				if(sum > 0 && IsNumeric(inputtext))
				{
					if(GetNeftData(neftid, N_BALANCE) >= sum)
					{
						static query[128 + 1];

						format(query, sizeof query, "UPDATE PlayersMorallwens a, neftenasos b SET a.money=%s,b.balance=%d WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), sum), GetNeftData(neftid, N_BALANCE)-sum, GetPlayerAccountID(playerid), GetNeftData(neftid, N_SQL_ID));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							AddNeftData(neftid, N_BALANCE, -, sum);
							GivePlayerMoneyEx(playerid, sum, "+ Снятие средств со счета нефтенасоса", false, true);

							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);

							return 1;
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "* На счету нефтенасоса нет такой суммы");
				}
				else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка ввода, повторите попытку");
			}
			case DIALOG_ATM_BIZ_PUT_MONEY:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						if(!GetILPlayerStr("2000000000", inputtext)) return SCM(playerid, COLOR_GREY, "* На счет предприятия можно положить до 2.000.000.000 руб за раз");

						new sum = strval(inputtext);
						if(IsILNumeric(inputtext))
						{
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), sum))
							{
								static query[128 + 1];

								format(query, sizeof query, "UPDATE PlayersMorallwens a, business b SET a.money=%s,b.balance=%s WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), -sum), SetILPlayerInt(playerid, g_business[businessid][B_BALANCE], sum), GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									format(g_business[businessid][B_BALANCE], 21, "%s", SetILPlayerInt(playerid, g_business[businessid][B_BALANCE], sum));
									GivePlayerMoneyEx(playerid, -sum, "Пополнение счета Бизнеса", false, true);

									ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									return 1;
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* У Вас с собой нет столько денег");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка ввода, повторите попытку");
					}
					else
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_TRANSFER_MONEY_1:
			{
				if(response)
				{
					new transfer_id = strval(inputtext);

					if(transfer_id > 0 && IsILNumeric(inputtext))
					{
						SetPlayerBankTransfer(playerid, BT_ID, 0);
						SetPlayerBankTransfer(playerid, BT_UID, 0);

						static query[64 + 1];
						new Cache: result;

						format(query, sizeof query, "SELECT id, uid FROM bank_accounts WHERE id=%d LIMIT 1", transfer_id);
						result = mysql_query(mysql, query);

						if(cache_num_rows())
							SetPlayerBankTransfer(playerid, BT_ID, cache_get_row_int(0, 0)),
							SetPlayerBankTransfer(playerid, BT_UID, cache_get_row_int(0, 1));

						cache_delete(result);

					
						if(GetPlayerBankTransfer(playerid, BT_ID))
						{
							new to_player = GetPlayerIDBySqlID(GetPlayerBankTransfer(playerid, BT_UID));

							if(IsPlayerConnected(to_player) && IsPlayerLogged(to_player))
							{
								return ShowPlayerATMTransfer(playerid);
							}
							else SCM(playerid, 0xc7590fFF, "Владелец счета должен находиться на сервере.");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Счета с таким номером не существует");
					}

					Dialog
					(
						playerid, DIALOG_ATM_TRANSFER_MONEY_1, DIALOG_STYLE_INPUT,
						"{FFD83D}Безналичный перевод",
						"{FFFFFF}Укажите номер банковского счета:",
						"Далее", "Отмена"
					);
				}
				else ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_TRANSFER_MONEY_2:
			{
				new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);
				if(response && transfer_id)
				{
					if(!GetILPlayerStr("2000000000", inputtext)) return SCM(playerid, COLOR_GREY, "* Перевод доступен до 2.000.000.000 руб за один раз"), ShowPlayerATMTransfer(playerid);

					new to_player = GetPlayerIDBySqlID(GetPlayerBankTransfer(playerid, BT_UID));

					if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xc7590fFF, "Владелец счета должен находиться на сервере."), ShowPlayerATMTransfer(playerid);

					new transfer_sum = strval(inputtext);
					if(IsILNumeric(inputtext))
					{
						if(GetILPlayerInt(GetPlayerBankMoney(playerid), transfer_sum))
						{
							static fmt_str[155];

							format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,bank_accounts ba SET a.bank=%s,ba.balance=%s WHERE a.id=%d AND ba.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -transfer_sum), SetILPlayerInt(playerid, GetBankAccountBalance(transfer_id), transfer_sum / 100 * 80), GetPlayerAccountID(playerid), transfer_id);
							mysql_query(mysql, fmt_str, false);
							

							if(!mysql_errno())
							{
								format(fmt_str, sizeof fmt_str, "+ Пополнения с банкомата %d руб", transfer_sum / 100 * 80);
								BankAccountLog(playerid, transfer_id, fmt_str);

								format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -transfer_sum));
								format(g_bank_account[to_player][transfer_id][BA_BALANCE], 21, "%s", SetILPlayerInt(playerid, GetBankAccountBalance(transfer_id), transfer_sum / 100 * 80));
								
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Откуда:\t\t\tОсновной счет\n"\
									"Куда:\t\t\t\tСчет №%d\n"\
									"Сумма:\t\t\t\t%d руб\n"\
									"{3caa3c}Коммисия:\t\t\t\t%d руб\n"\
									"{FFFFFF}Остаток на Вашем счету:\t%s руб",
									transfer_id,
									transfer_sum / 100 * 80,
									transfer_sum / 100 * 20,
									formatStr(GetPlayerBankMoney(playerid))
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{99FF00}Перевод завершен", fmt_str, "Закрыть", "");

								new businessid = GetPlayerInBiz(playerid);

								AddBusinessProfit(playerid, businessid, transfer_sum / 100 * 20, 1);

								return PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
							}
							else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 11)");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* На основном банковском счете недостаточно денег");
					}
					ShowPlayerATMTransfer(playerid);
				}
				else ShowPlayerATMDialog(playerid);
			}
			case DIALOG_BUY_PACK:
			{
				if(GetIteam(playerid, 293) < 7500000) return SCM(playerid, COLOR_GREY, "*У вас недостаточно фишек");
			    if(response)
			    {
					GameText(playerid, "~g~Вы успешно приобрели экслюзивный товар", 1000,1);
					STRING_GLOBAL[0] = EOS;

					format
					(
						STRING_GLOBAL, sizeof STRING_GLOBAL,
						"INSERT INTO ownable_cars \
						(owner_id,model_id,color_1,color_2,vinil,viniltype, pos_x,pos_y,pos_z,angle,create_time) \
						VALUES \
						('%d','%d','%d','%d','%d','%f','%f','%f','%f','%d')",
						GetPlayerAccountID(playerid),
						15175,
						1,
						1,
						-1,
						-1,
						759.6031,
						539.4811,
						13.2184,
						354.8554,
						gettime()
					);
					mysql_query(mysql, STRING_GLOBAL, true);
					GiveSkin(playerid, 17048);
					SCM(playerid, COLOR_ORANGE, "Одежда была выдана вам в инвентарь");
					GiveIteam(playerid, 293, 0, 7500000, 0);
				}
			}
		
			case DIALOG_ATM_TICKET_SELECT:
			{
				if(!response) return ShowPlayerATMDialog(playerid);

				switch(listitem + 1)
				{
					case 1:
					{
						type_page_cars[playerid] = 0;
						page_cars[playerid] = 1;
						ShowOwnableTickets(playerid, page_cars[playerid], 0);
					}
					case 2:
					{
						Dialog
						(
							playerid, DIALOG_ATM_TICKET_PAY, DIALOG_STYLE_INPUT,
							"{FFD83D}Оплата штрафа",
							"{FFFFFF}Введите номер штрафа для оплаты",
							"Далее", "Назад"
						);
					}
					case 3:
					{
						static query[90],
							Cache: result;

						mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE uid=%d AND status=0", GetPlayerAccountID(playerid));
						result = mysql_query(mysql, query, true);

						new rows = cache_num_rows();

						SetPVarInt(playerid, "AllTickets", 0);

						for(new i; i < rows; i++)
						{
							SetPVarInt(playerid, "AllTickets", GetPVarInt(playerid, "AllTickets") + cache_get_field_content_int(i, "amount"));
						}

						cache_delete(result);

						if(rows)
						{
							string_dialog[0] = EOS;

							format(string_dialog, sizeof string_dialog, "{FFFFFF}На ваше имя выписано {deb308}%d {FFFFFF}штрафов на сумму {deb308}%s руб.", rows, formatInt(GetPVarInt(playerid, "AllTickets")));
							
							Dialog(playerid, DIALOG_ATM_TICKET_PAY_ALL, DIALOG_STYLE_MSGBOX,"{FFD83D}Оплата всех штрафов",string_dialog,"Далее", "Назад");
						}
						else ShowPlayerATMDialog(playerid), SCM(playerid, -1, "* У вас нет штрафов");
					}
				}
			}
			case DIALOG_ATM_TICKET_PAY_ALL:
			{
				if(!response) return ShowPlayerATMDialog(playerid);

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), GetPVarInt(playerid, "AllTickets"))) return SCM(playerid, 0xe2c977FF, "У вас недостаточно денег для оплаты всех штрафов.");

				GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "AllTickets"), "Оплата всех штрафов");

				SCMF(playerid, 0xa6caf0FF, "Вы успешно оплатили все свои штрафы на сумму {FFFFFF}%s {"SERVER_COLOR"}руб.", formatInt(GetPVarInt(playerid, "AllTickets")));

				static query[64];
				mysql_format(mysql, query, sizeof query, "UPDATE tickets SET status=1 WHERE uid=%d", GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);
			}
			case DIALOG_ATM_TICKET_LIST:
			{
				if(!response) return 1;

				if(GetPlayerListitemValue(playerid, listitem)) PayTicket(playerid, GetPlayerListitemValue(playerid, listitem));
				
			}
			case DIALOG_DRAG_RACING:
			{
				if(!response) return 1;

				if(listitem == 0) if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 1)) return SCM(playerid, COLOR_GREY, "* У вас недостаточно средств, минимум 1 руб.");
				if(listitem == 1) if(GetIteam(playerid, 293) < 1) return SCM(playerid, COLOR_GREY, "* У вас недостаточно средств, минимум 1 фишка.");
				if(listitem == 2) if(GetPlayerCurrentDonate(playerid) < 1) return SCM(playerid, COLOR_GREY, "* У вас недостаточно средств, минимум 1 донат.");

				g_drag_racing[g_drag_racing_id[playerid]][E_BET] = listitem;

				MoralPacket_1(playerid, s_CefInterface, t_CefHide, "DragRacingStart");
				MoralPacket_2(playerid, s_CefInterface, t_CefShow, "DragRacingStart", "[1, [1, [2, 2], 0, 0]]");
				g_drag_racing[g_drag_racing_id[playerid]][E_TYPE] = 1;
			}
			case DIALOG_TAKE_CAR_PRIZE:
			{
			    if(!response) return RemovePlayerFromVehicle(playerid);
			   
				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) return GameText(playerid, "~r~Недостаточно~n~слотов на транспорт", 3000, 2), RemovePlayerFromVehicle(playerid);

				new vehicleid = GetPlayerVehicleID(playerid);
				if(vehicleid != INVALID_VEHICLE_ID)
				{
					new modelid = GetVehicleModel(vehicleid);
					if(modelid == 0) return RemovePlayerFromVehicle(playerid);

					new Float: pos_xp, Float: pos_yp, Float: pos_zp,Float: angle = 180.0;
					GetPlayerPos(playerid, pos_xp, pos_yp, pos_zp);

					static query[220];
					format(query, sizeof query, "[Розыгрыш] Игрок: %s[%d] выиграл транспорт: %s", GetPlayerNameEx(playerid), playerid, GetVehicleInfo(modelid , VI_NAME));
					SendClientMessageToAll(0xFFA500FF, query);

					GiveCar(playerid, modelid, 1, 1, 0, -1, pos_xp, pos_yp, pos_zp, angle, gettime());

					DestroyVehicleLabel(vehicleid);
					DestroyVehicle(vehicleid);

					static fmt_text[244];
					format(fmt_text, sizeof fmt_text, "%s Забрал транспорт: %s созданный для розыграша", GetPlayerNameEx(playerid), GetVehicleInfo(modelid , VI_NAME));
					SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);
					
					SendClientMessage(playerid, 0x66CC00FF, "* Поздравляем! Вы успешно забрали транспорт себе! Загрузить: {66CC00}/car");
				}
			}
			case DIALOG_PLAYER_BONUS:
			{
				if(!response) return 1;

				if(listitem == 0)
				{
					new count = GetPVarInt(playerid, "all_player_bonus");

					if(count < 1) return 1;

					GivePlayerMoneyEx(playerid, count, "Забрал все бонусы с /bonus");

					static query[148];
					format(query, sizeof query, "DELETE FROM player_bonus WHERE owner_id=%d", GetPlayerAccountID(playerid));
					mysql_query(mysql, query, false);

					SCMF(playerid, 0x288ef0FF, "Вы забрали все бонусы в размере {ffd010}%s руб", formatInt(count));

					DeletePVar(playerid, "all_player_bonus");
				}
				else
				{
					static query[148],
						text[32],
						Cache: result;

					mysql_format(mysql, query, sizeof query, "SELECT * FROM player_bonus WHERE id=%d LIMIT 1", GetPlayerListitemValue(playerid, listitem - 1));
					result = mysql_query(mysql, query);

					new count = cache_get_field_content_int(0, "count");

					cache_get_field_content(0, "text", text);

					cache_delete(result);

					GivePlayerMoneyEx(playerid, count, "Забрал с бонусов");

					format(query, sizeof query, "DELETE FROM player_bonus WHERE id=%d", GetPlayerListitemValue(playerid, listitem - 1));
					mysql_query(mysql, query, false);

					SCMF(playerid, 0x288ef0FF, "Вы получили бонус в размере {ffd010}%s руб {288ef0}за %s", formatInt(count), text);
				}
			}
			case DIALOG_PLAYER_NOTIFICATION:
			{
				if(!response) return 1;

				static query[148],
					text[148],
					note_text[148],
					time[21],
					Cache: result;

				mysql_format(mysql, query, sizeof query, "SELECT * FROM notification WHERE id=%d LIMIT 1", GetPlayerListitemValue(playerid, listitem));
				result = mysql_query(mysql, query);

				cache_get_field_content(0, "text", text);
				cache_get_field_content(0, "note_text", note_text);
				cache_get_field_content(0, "time", time);

				cache_delete(result);

				string_dialog[0] = EOS;
				format(string_dialog, sizeof string_dialog, "Тип уведомления:\t\t\t%s\nДата и время:\t\t\t%s\n\n%s",text, time, note_text);
				Dialog(playerid, DIALOG_PLAYER_NOTIFICATION_2, DIALOG_STYLE_MSGBOX, "{FFFFFF}Информация уведомления", string_dialog, "Назад", "Закрыть");

				mysql_format(mysql, query, sizeof query, "UPDATE notification SET status=0 WHERE id=%d", GetPlayerListitemValue(playerid, listitem));
				mysql_query(mysql, query, false);
			}

			case DIALOG_PLAYER_NOTIFICATION_2:
			{
				if(!response) return 1;
				callcmd::notification(playerid);
			}
			case DIALOG_CAR_ACTIVE_ACS_LIST:
			{
				if(!response) return true;

				if(active_acs[playerid] != INVALID_VEHICLE_ID)
				{
					RemovePlayerFromVehicle(playerid);
					active_acs[playerid] = INVALID_VEHICLE_ID;
					active_acs_id[playerid] = -1;
				}

				static query[94],
					Cache: result;

				mysql_format(mysql, query, sizeof query, "SELECT * FROM cars_accessories WHERE id=%d LIMIT 1", GetPlayerListitemValue(playerid, listitem));
				result = mysql_query(mysql, query, true);

				new indx = cache_get_field_content_int(0, "indx");
				new model_id = cache_get_field_content_int(0, "model_id");

				cache_delete(result);

				active_acs_id[playerid] = GetPlayerListitemValue(playerid, listitem);

				new Float: x,
					Float: y,
					Float: z,
					Float: a;

				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);

				if(model_id == 16229)  
					active_acs[playerid] = CreateVehicle(510, x, y, z, a, 0, 0, -1, 0, VEHICLE_ACTION_TYPE_ACTIVE_ACS, 0);

				if(model_id == 17163)  
					active_acs[playerid] = CreateVehicle(15683, x, y, z, a, 0, 0, -1, 0, VEHICLE_ACTION_TYPE_ACTIVE_ACS, 0);
					
				PutPlayerInVehicle(playerid, active_acs[playerid], 0);

				new vehicleid = GetPVarInt(playerid, "AcsVehicleCar");

				if(IsValidDynamicObject(car_accessories[vehicleid][indx])) DestroyDynamicObject(car_accessories[vehicleid][indx]);
				car_accessories[vehicleid][indx] = INVALID_OBJECT_ID;
			}
			case DIALOG_CAR_ACCESSORIES_LIST:
			{
				if(!response) return 1;

				if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~В вашем инвентаре~n~нет свободного места", 3000, 2);

				static query[94],
					type,
                    Cache: result;

                mysql_format(mysql, query, sizeof query, "SELECT * FROM cars_accessories WHERE id=%d LIMIT 1", GetPlayerListitemValue(playerid, listitem));
                result = mysql_query(mysql, query, true);

				new indx = cache_get_field_content_int(0, "indx");
				new model_id = cache_get_field_content_int(0, "model_id");

                cache_delete(result);

				format(query, sizeof query, "DELETE FROM cars_accessories WHERE id=%d", GetPlayerListitemValue(playerid, listitem));
				mysql_query(mysql, query, false);

                if(indx == 0) type = 14;
				if(indx == 1) type = 15;
				if(indx == 2) type = 16;
				if(indx == 3) type = 17;
				if(indx == 4) type = 20;
				if(indx == 5) type = 21;

				GiveAcs(playerid, model_id, type);

				new vehicleid = GetPVarInt(playerid, "AcsVehicleCar");
				new index = GetVehicleData(vehicleid, V_ACTION_ID);
				new car_id = GetOwnableCarData(index, OC_SQL_ID);

				if(IsValidDynamicObject(car_accessories[vehicleid][indx]))
    			{
    			    DestroyDynamicObject(car_accessories[vehicleid][indx]);
    			    car_accessories[vehicleid][indx] = INVALID_OBJECT_ID;
    			}

				LoadCarAccessories(car_id, vehicleid);

				SCM(playerid, 0x2B83DBFF, "Вы сняли украшение с транспорта");
			}
			case DIALOG_BUY_PACK1:
			{
				if(GetPlayerData(playerid, P_COINS) < 1999) return GameText(playerid, "~r~Недостаточно "SERVER_COINS_NAME"", 1000,1);
			    if(response)
			    {
					GameText(playerid, "~g~Вы успешно приобрели данный пак", 1000,1);
					STRING_GLOBAL[0] = EOS;

					format
					(
						STRING_GLOBAL, sizeof STRING_GLOBAL,
						"INSERT INTO ownable_cars \
						(owner_id,model_id,color_1,color_2,vinil,viniltype,pos_x,pos_y,pos_z,angle,create_time) \
						VALUES \
						('%d','%d','%d','%d','%d','%d','%f','%f','%f','%f','%d')",
						GetPlayerAccountID(playerid),
						15661,
						1,
						1,
						0,
						0,
						759.6031,
						539.4811,
						13.2184,
						354.8554,
						gettime()
					);

					mysql_query(mysql, STRING_GLOBAL, true);
					SCM(playerid, COLOR_ORANGE, "Автомобиль был выдан вам в /car");
					GiveSkin(playerid, 17002);
					SCM(playerid, COLOR_ORANGE, "Одежда была выдана вам в инвентарь");
					GivePlayerCoins(playerid, -1999);
				}
				else
				{
                   GameText(playerid, "~r~Вы отказались от покупки данного пака", 1000,1);
				}
			}
		    case DIALOG_BUY_PACK2:
			{
				if(GetPlayerData(playerid, P_COINS) < 1500) return GameText(playerid, "~r~Недостаточно "SERVER_COINS_NAME"", 1000,1);
			    if(response)
			    {
					GameText(playerid, "~g~Вы успешно приобрели данный пак", 1000,1);
					STRING_GLOBAL[0] = EOS;

					format
					(
						STRING_GLOBAL, sizeof STRING_GLOBAL,
						"INSERT INTO ownable_cars \
						(owner_id,model_id,color_1,color_2,vinil,viniltype,pos_x,pos_y,pos_z,angle,create_time) \
						VALUES \
						('%d','%d','%d','%d','%d','%d','%f','%f','%f','%f','%d')",
						GetPlayerAccountID(playerid),
						15287,
						1,
						1,
						0,
						0,
						759.6031,
						539.4811,
						13.2184,
						354.8554,
						gettime()
					);

					mysql_query(mysql, STRING_GLOBAL, true);
					GiveSkin(playerid, 17039);
					SCM(playerid, COLOR_ORANGE, "Одежда была выдана вам в инвентарь");
					GivePlayerCoins(playerid, -1500);
				}
				else
				{
                   GameText(playerid, "~r~Вы отказались от покупки данного пака", 1000,1);
				}
			}
			case DIALOG_BUY_PACK3:
			{
				if(GetPlayerData(playerid, P_COINS) < 1300) return GameText(playerid, "~r~Недостаточно "SERVER_COINS_NAME"", 1000,1);
			    if(response)
			    {
					GameText(playerid, "~g~Вы успешно приобрели данный пак", 1000,1);
					STRING_GLOBAL[0] = EOS;

					format
					(
						STRING_GLOBAL, sizeof STRING_GLOBAL,
						"INSERT INTO ownable_cars \
						(owner_id,model_id,color_1,color_2,vinil,viniltype,pos_x,pos_y,pos_z,angle,create_time) \
						VALUES \
						('%d','%d','%d','%d','%d','%d','%f','%f','%f','%f','%d')",
						GetPlayerAccountID(playerid),
						15669,
						1,
						1,
						0,
						0,
						759.6031,
						539.4811,
						13.2184,
						354.8554,
						gettime()
					);
					mysql_query(mysql, STRING_GLOBAL, true);
					GiveSkin(playerid, 15598);
					SCM(playerid, COLOR_ORANGE, "Одежда была выдана вам в инвентарь");
					GivePlayerCoins(playerid, -1300);
				}
				else
				{
                   GameText(playerid, "~r~Вы отказались от покупки данного пака", 1000,1);
				}
			}
			case DIALOG_ATM_TICKET_PAY:
			{
				if(response)
				{
					new ticketid = strval(inputtext);

					PayTicket(playerid, ticketid);
				}

				ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_CHARITY:
			{
				if(response)
				{
					new put_sum = strval(inputtext);
					if(put_sum > 0 && IsNumeric(inputtext))
					{
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), put_sum))
						{
							static fmt_str[148];
							format(fmt_str, sizeof fmt_str, "INSERT INTO charity (uid,money,time,name) VALUES (%d,%d,%d,'%s')", GetPlayerAccountID(playerid), put_sum, gettime(), GetPlayerNameEx(playerid));
							mysql_query(mysql, fmt_str, false);

							GivePlayerMoneyEx(playerid, -put_sum, "Благотворительность", true, true);

							format(fmt_str, sizeof fmt_str, "Вы сделали пожертвование в размере %d рублей", put_sum);
							SendClientMessage(playerid, 0x3399FFFF, fmt_str);

							UpdateCharity();
							SetPlayerData(playerid, P_DOSTIJ20, GetPlayerData(playerid, P_DOSTIJ20) + put_sum);
							UpdatePlayerDatabaseInt(playerid, "dostij20", GetPlayerData(playerid, P_DOSTIJ20) + put_sum);
							//BattlePass_Completingtasks(playerid, 0, 0);
							OnBattlePass_Perfomance(playerid, 5, put_sum);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег");
							ShowPlayerATMCharityDialog(playerid);
						}
					}
					else ShowPlayerATMCharityDialog(playerid);
				}
			}
			case DIALOG_QUEST_END:
			{
				if(response)
				{
				    if(GetPVarInt(playerid, "quest") != 0)
				    {
				        SendClientEvent(playerid, t_CefHide, "QuestsProgressInfo");
				        SetPVarInt(playerid, "quest", 0);
				    }
				}
			}
			case DIALOG_QUEST_END_1:
			{
				if(response)
				{
				    if(GetPVarInt(playerid, "quest") != 0)
				    {
				        SendClientEvent(playerid, t_CefHide, "QuestsProgressInfo");
				        SetPVarInt(playerid, "quest", 0);
				        GiveIteam(playerid, 252, 0, 1, 0);
				    }
				}
			}
			case DIALOG_HEALTH_BUSINESS:
			{
                if(response)
                {
				    new pickupid = GetPlayerData(playerid, P_LAST_PICKUP);
					new action_id = GetPickupInfo(pickupid, P_ACTION_ID);
				    new businessid = GetPlayerInBiz(playerid);
					if(businessid != -0)
					{
						if(businessid == action_id)
						{
							new time = gettime();
							if(GetPVarInt(playerid, "biz_health_use") <= time)
							{
								new price = BIZ_HEALTH_SERVICE_PRICE;
								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
								{
									GivePlayerMoneyEx(playerid, -price, "Использование аптечки в бизнесе", true, true);

									if(GetBusinessData(businessid, B_PRODS) >= 1)
									{
										AddBusinessProfit(playerid, businessid, price, 1);
									}
									SetPlayerHealthEx(playerid, 99.0);
									SetPVarInt(playerid, "biz_health_use", time + 90); // 90 сек (1:30 минут)
						
								}
								else SendClientMessage(playerid, 0x999999FF, "* Услуги медпункта стоят 3500 рублей");
							}
							else SendClientMessage(playerid, 0x999999FF, "* Недавно Вы уже пользовались услугами медпункта");
						}
					}
				}
			}

			// -----------------------------------------------------------------
			case DIALOG_KIOSK_NAME://надо
			{
				new str_len = strlen(inputtext);
				if(str_len > 25) return SendClientMessage(playerid, 0xCECECEFF, "* Максимальная длина текста не более 25 символов");
				
				new kiosk_id = GetNearestKiosk(playerid, 7.0), fmt_text[128];

				mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE kiosk SET name='%s' WHERE id=%d", inputtext, GetKioskData(kiosk_id, K_SQL_ID));
				mysql_query(mysql, fmt_text, false);

				format(g_kiosk[kiosk_id][K_NAME],33,inputtext);
		
				STRING_GLOBAL[0] = EOS;
				format(STRING_GLOBAL,sizeof STRING_GLOBAL,"{FF8800}Магазин №%d\n{0E0101}\"%s\"", GetKioskData(kiosk_id, K_SQL_ID),inputtext);
				SetDynamicObjectMaterialText(kiosktext[GetKioskData(kiosk_id, K_SQL_ID)], 0,STRING_GLOBAL, 120, "Arial", 20, 1, 0xFFFFFFFF, 0xFFFFFFFF, 1);
				SendClientMessage(playerid, 0xCECECEFF, "* Вы успешно сменили название киоска");
			}
			case DIALOG_PAY_FOR_RENT:
			{
				if(!response) return 1;
				switch(listitem + 1)
				{
					case 1: // Заплатить за дом
					{
						ShowPlayerHousePayForRent(playerid);
						return 1;
					}
					case 2: // Оплатить аренду бизнеса
					{
						static query[256],
							Cache: result,
							biz_id,
							biz_name[64];

						mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE owner_id='%d'", GetPlayerAccountID(playerid));
						result = mysql_query(mysql, query, true);

						new rows = cache_num_rows();

						if(!rows)
							return SendClientMessage(playerid, 0x999999FF, "* У вас не одного бизнеса во владении.");

						string_dialog[0] = EOS;
						for(new i = 0; i < rows; i ++)
						{
							biz_id = cache_get_field_content_int(i, "id");
							cache_get_field_content(i, "name", biz_name);

							format(query, sizeof query, "{FFFFFF}%d. - %s (№%d)<t>Владелец\n", i + 1, biz_name, biz_id);
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, biz_id-1);
						}

						Dialog
						(
							playerid, DIALOG_OWNABLE_BIZ_OPLATA, DIALOG_STYLE_LIST,
							"{FFCD00}Выберите бизнес",
							string_dialog,
							"Выбрать", "Закрыть"
						);

						cache_delete(result);
						return 1;
					}
					case 3: // Оплатить аренду киоска
					{
						static query[256],
							Cache: result,
							biz_id,
							biz_name[64];

						mysql_format(mysql, query, sizeof query, "SELECT * FROM kiosk WHERE owner_id='%d'", GetPlayerAccountID(playerid));
						result = mysql_query(mysql, query, true);

						new rows = cache_num_rows();

						if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного киоска во владении.");

						string_dialog[0] = EOS;
						for(new i = 0; i < rows; i ++)
						{
							biz_id = cache_get_field_content_int(i, "id");
							cache_get_field_content(i, "name", biz_name);

							format(query, sizeof query, "{FFFFFF}%d. - %s (№%d)\n", i + 1, biz_name, biz_id);
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, biz_id-1);
						}

						Dialog
						(
							playerid, DIALOG_OWNABLE_KIOSK_OPLATA, DIALOG_STYLE_LIST,
							"{FFCD00}Выберите киоск",
							string_dialog,
							"Выбрать", "Закрыть"
						);

						cache_delete(result);
						return 1;
					}
					case 4: // Оплатить гараж
					{					
						static query[256],
							Cache: result,
							biz_id;

						mysql_format(mysql, query, sizeof query, "SELECT * FROM garage WHERE owner_id='%d'", GetPlayerAccountID(playerid));
						result = mysql_query(mysql, query, true);

						new rows = cache_num_rows();

						if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного гаража во владении.");

						string_dialog[0] = EOS;
						for(new i = 0; i < rows; i ++)
						{
							biz_id = cache_get_field_content_int(i, "id");

							format(query, sizeof query, "{FFFFFF}%d. - Гараж (№%d)\n", i + 1, biz_id);
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, biz_id-1);
						}

						Dialog
						(
							playerid, DIALOG_OWNABLE_GARAGE_OPLATA, DIALOG_STYLE_LIST,
							"{FFCD00}Выберите киоск",
							string_dialog,
							"Выбрать", "Закрыть"
						);

						cache_delete(result);
						return 1;
					}
					case 5: // Оплатить огород
					{
						static query[256],
							Cache: result,
							garden_id;

						mysql_format(mysql, query, sizeof query, "SELECT * FROM gardens WHERE owner_id='%d'", GetPlayerAccountID(playerid));
						result = mysql_query(mysql, query, true);

						new rows = cache_num_rows();

						if(!rows)
							return SendClientMessage(playerid, 0x999999FF, "* У вас нет огородов.");

						string_dialog[0] = EOS;
						for(new i = 0; i < rows; i ++)
						{
							garden_id = cache_get_field_content_int(i, "id");

							format(query, sizeof query, "%d.{FFFFFF} Огород №%d\n",i+1, garden_id);
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, garden_id);
						}

						Dialog
						(
							playerid, DIALOG_GARDEN_LIST, DIALOG_STYLE_LIST,
							"{FFCD00}Огороды",
							string_dialog,
							"Выбрать", "Закрыть"
						);

						cache_delete(result);
						return 1;
					}
					case 6:
					{
						static query[256],
							Cache: result;

						format(query, sizeof query, "SELECT * FROM neftenasos WHERE owner_id='%d'", GetPlayerAccountID(playerid));
						result = mysql_query(mysql, query, true);

						new rows = cache_num_rows();

						if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного нефтенасоса во владении.");

						string_dialog[0] = EOS;
						for(new i; i < rows; i ++)
						{
							new biz_id = cache_get_field_content_int(i, "id");

							format(query, sizeof query, "{FFFFFF}Нефтенасос №%d\n", biz_id);
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, biz_id);
						}

						Dialog
						(
							playerid, DIALOG_OWNABLE_NEFTENASOS_LIST2, DIALOG_STYLE_LIST,
							"{FFCD00}Выберите нефтенасос",
							string_dialog,
							"Выбрать", "Закрыть"
						);
						cache_delete(result);
						return 1;
					}
				}
				ShowPlayerPayForRentDialog(playerid);
			}
			case DIALOG_GARDEN_LIST:
			{
			    if(response)
				{
				    new garden = GetPlayerListitemValue(playerid, listitem);
				    if(garden != -1)
				    {
				    	ShowPlayerGardenPayForRent(playerid,garden);
				    }
			    }
			}
			case DIALOG_PAY_FOR_RENT_GARDEN:
			{
				new businessid = GetPVarInt(playerid,"garden_id");
				if(businessid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							static fmt_str[128 + 1];

							new rent_time = GetGardenData(businessid, G_RENT_DATE);

							new rent_price = GetGardenData(businessid, G_RENT_PRICE);

							new total_price = rent_price * days;
							if((rent_time + days) <= 14)
							{
								if(GetILPlayerInt(GetPlayerBankMoney(playerid), total_price))
								{

									format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,gardens b SET a.bank=%s,b.rent=%d WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price), days + rent_time, GetPlayerAccountID(playerid), GetGardenData(businessid, G_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price));
										SetGardenData(businessid, G_RENT_DATE, days + rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно продлили аренду огорода еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 14 дней");
						}
						ShowPlayerGardenPayForRent(playerid,businessid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_PAY_FOR_RENT_BIZ:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							static fmt_str[128 + 1];

							new time = gettime();
							new rent_time = GetBusinessData(businessid, B_RENT_DATE);

							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? GetBusinessData(businessid, B_RENT_PRICE) : GetBusinessData(businessid, B_RENT_PRICE) / 2;

							new total_price = rent_price * days;
							if((rent_days + days) <= 14)
							{
								if(GetILPlayerInt(GetPlayerBankMoney(playerid), total_price))
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

									format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,business b SET a.bank=%s,b.rent_time=%d WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price), rent_time, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price));
										SetBusinessData(businessid, B_RENT_DATE, rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно продлили аренду бизнеса еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 14 дней");
						}
						ShowPlayerBusinessPayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_PAY_FOR_RENT_KIOSK:
			{
				new businessid = GetPVarInt(playerid, "ownablekiosk_id");
				if(businessid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							static fmt_str[128 + 1];

							new rent_time = GetKioskData(businessid, K_RENT_DATE);

							new rent_price = GetKioskData(businessid, K_RENT_PRICE);

							new total_price = rent_price * days;
							if((rent_time + days) <= 14)
							{
								if(GetILPlayerInt(GetPlayerBankMoney(playerid), total_price))
								{

									format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,kiosk b SET a.bank=%s,b.rent=%d WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price), days + rent_time, GetPlayerAccountID(playerid), GetKioskData(businessid, K_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price));
										SetKioskData(businessid, K_RENT_DATE, days + rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно продлили аренду киоска еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 14 дней");
						}
						ShowPlayerKioskPayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			
			case DIALOG_PAY_FOR_RENT_GARAGE:
			{
				new garage_id = GetPVarInt(playerid, "ownablegarage_id");
				if(garage_id != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							static fmt_str[128 + 1];

							new time = gettime();
							new rent_time = GetGarageData(garage_id, G_RENT_DATE);

							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = GetGarageData(garage_id, G_IMPROVEMENTS) > 0 ? GetGarageData(garage_id, G_RENT_PRICE) / 2 : GetGarageData(garage_id, G_RENT_PRICE);

							new total_price = rent_price * days;
							if((rent_days + days) <= 14)
							{
								if(GetILPlayerInt(GetPlayerBankMoney(playerid), total_price))
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

									format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,garage g SET a.bank=%s,g.rent_time=%d WHERE a.id=%d AND g.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price), rent_time, GetPlayerAccountID(playerid), GetGarageData(garage_id, G_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price));
										SetGarageData(garage_id, G_RENT_DATE, rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {"#cGold"}%d руб", total_price);
										SendClientMessage(playerid, COLOR_WHITE, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно оплатили гараж еще на {"#cGold"}%d дней", days);
										SendClientMessage(playerid, COLOR_WHITE, fmt_str);
									}
								}
								else
								{
									SendClientMessage(playerid, COLOR_GOLD, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, COLOR_GOLD, "Вы не можете оплатить за аренду гаражa больше чем на 14 дней");
						}
						ShowPlayerGaragePayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_BANK:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							ShowPlayerBankAccounts(playerid);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_BANK_CREATE_ACCOUNT, DIALOG_STYLE_INPUT,
								"{FFD83D}Создание нового счета",
								"{FFFFFF}Введите название для нового счета.\n"\
								"Максимальная длина 20 символов:",
								"Ок", "Отмена"
							);
						}
					}
				}
			}
			case DIALOG_GARAGE_BUY:
        	{
        	    if (response)
        	    {
        	        new garage_id = GetPVarInt(playerid, "buy_garage_id");

        	        if (IsPlayerInRangeOfPoint(playerid, 7.0, GetGarageData(garage_id, G_POS_X), GetGarageData(garage_id, G_POS_Y), GetGarageData(garage_id, G_POS_Z)))
        	        {
        	            if (!IsGarageOwned(garage_id))
        	            {
        	                if (GetILPlayerInt(GetPlayerMoneyEx(playerid), GetGarageData(garage_id, G_PRICE)))
        	                {
        	                    if (GetOwnableAuction(2, GetGarageData(garage_id, G_SQL_ID)) > 0) return SCM(playerid, COLOR_GREY, "* Данный гараж выставлен на аукцион");

        	                    if (CanPlayerBuyProperty(playerid))
        	                    {
        	                        ShowPropertyCaptcha(playerid, 4, garage_id);
        	                    }
        	                }
        	                else SendClientMessage(playerid, 0xFF6600FF, "У Вас недостаточно денег для покупки этого гаража");
        	            }
        	            else
        	            {
        	                new fmt_str[64];

        	                format(fmt_str, sizeof fmt_str, "Этот гараж уже куплен. Владелец: %s", GetGarageData(garage_id, G_OWNER_NAME));
        	                SendClientMessage(playerid, 0xFF6600FF, fmt_str);
        	            }
        	        }
        	    }
        	    DeletePVar(playerid, "buy_garage_id");
        	}
			case DIALOG_DISKI:
			{
				if(!response) return 1;

				new idx = GetPlayerListitemValue(playerid, listitem);

				SetPVarInt(playerid, "listitem_car", listitem);
				SetPVarInt(playerid, "ownablecar_id", idx);

				new vehicleid = INVALID_VEHICLE_ID;

				for(new i = 0; i < MAX_VEHICLES; i++)
				{
					if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
					{
						new iddx = GetVehicleData(i, V_ACTION_ID);
						if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
						{
							vehicleid = i;
						}
					}
				}

				if(vehicleid != INVALID_VEHICLE_ID)
				{
					new Float:x, Float:y, Float:z, Float:a;

					GetVehiclePos(vehicleid, x, y, z);
					GetVehicleZAngle(vehicleid, a);

					if(!IsPlayerInRangeOfPoint(playerid, 15.0, x, y, z)) return SendClientMessage(playerid, 0xead671FF, "Транспорт должен находиться на территории шиномонтажа.");

					new model_id = GetVehicleData(vehicleid, V_MODELID);
					if(model_id)
					{
						DiskiStyling(playerid);
						
						new Float:c_x, Float:c_y, Float:c_z, Float:c_a;
						GetVehiclePos(vehicleid, c_x, c_y, c_z);
						GetVehicleZAngle(vehicleid, c_a);

						new Float:camX = c_x, Float:camY = c_y, Float:camZ = c_z + 1.5;

						if((c_a >= 315.0) || (c_a < 45.0))
							camX += 7.0;
						else if(c_a >= 45.0 && c_a < 135.0) 
							camY += 7.0;
						else if(c_a >= 135.0 && c_a < 225.0)
							camX -= 7.0;
						else if(c_a >= 225.0 && c_a < 315.0)
							camY -= 7.0;

						SetPlayerCameraPos(playerid, camX, camY, camZ);
						SetPlayerCameraLookAt(playerid, c_x, c_y, c_z + 0.5, 1);
					}
				}
				else
				{
					if(GetPlayerOwnableCars(playerid) == 0) SCM(playerid, 0xFF6600FF, "У Вас нет личного транспорта");
					else SCM(playerid, 0xFF6600FF, "Данный транспорт не загружен на сервер");
				}
			}
			case DIALOG_BIZ_SELL_TEST:
			{
			    new businessid = GetPlayerListitemValue(playerid, listitem) + 1;
			    SetPVarInt(playerid, "ownablebiz_id", businessid);
			    Dialog
				(
					playerid, DIALOG_BIZ_SELL, DIALOG_STYLE_MSGBOX,
					"{FFCD00}Продажа бизнеса",
					"{FFFFFF}Вы уверены что хотите продать свой бизнес государству?\n\n"\
					"Вам будет возвращено его стоимость за вычитом 30%\n"\
					"Также будет возвращено 60% от стоимости купленных улучшений\n\n"\
					"Если Вы хотите продать бизнес другому игроку,\n"\
					"используйте команду /sellmybiz",
					"Да", "Нет"
				);
			}
			case DIALOG_KIOSK_SELL:
			{
			    SellKiosk(playerid);
			}
			case DIALOG_KIOSK_SELL_LIST:
			{
			    if(!response) return 1;
			    new idx = GetPlayerListitemValue(playerid, listitem) + 1;
			    SetPVarInt(playerid, "ownablekiosk_id", idx);
			    new kiosk_id = idx;
			    if(kiosk_id != -1)
				{
					Dialog
					(
						playerid, DIALOG_KIOSK_SELL, DIALOG_STYLE_MSGBOX,
						"{FFCD00}Продажа киоска",
						"{FFFFFF}Вы уверены что хотите продать свой киоск государству?\n\n"\
						"Вам будет возвращено его стоимость за вычитом 30%\n"\
						"Также будет возвращено 60% от стоимости купленных улучшений\n\n"\
						"Если Вы хотите продать киоск другому игроку,\n"\
						"используйте команду /sellmystall",
						"Да", "Нет"
					);
				}
			}
			case DIALOG_GARAGE_SELL:
			{
				new garage_id = GetPVarInt(playerid, "ownablegarage_id");
				if(garage_id != -1)
				{
					if(response)
					{
						SellGarage(playerid);
					}
				}
			}
			case DIALOG_GARAGE_INFO:
			{
				if(response)
				{
					new garage_id = GetPVarInt(playerid, "ownablegarage_id");
					if(garage_id != -1)
					{
						ShowPlayerGarageDialog(playerid, GARAGE_OPERATION_PARAMS);
					}
				}
			}
			case DIALOG_GARAGE_ZAEZD:
			{
				new garage_id = GetPlayerUseListitem(playerid);

				if(garage_id >= 0 && response)
				{
					if(!GetGarageData(garage_id, G_LOCK_STATUS))
					{
						ZaezdPlayerToGarage(playerid, garage_id);
					}
					else GameText(playerid, "~r~Закрыт", 3000, 2);
				}
			}
			case DIALOG_GARAGE_PARAMS:
			{
				new garage_id = GetPVarInt(playerid, "ownablegarage_id");
				if(garage_id != -1)
				{
					if(response)
					{
						ShowPlayerGarageDialog(playerid, listitem + 1);
					}
					else callcmd::garage(playerid, "");
				}
			}
			case DIALOG_GARAGE_IMPROVEMENTS:
			{
				new garage_id = GetPVarInt(playerid, "ownablegarage_id");

			    if(response)
			    {
					switch(listitem + 1)
					{
					    case 1:
					    {
					        if(GetGarageData(garage_id, G_IMPROVEMENTS) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Данное улучшение уже куплено");

					        if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 55000)) return SendClientMessage(playerid, 0xFF6600FF, "У Вас недостаточно средств");

							SetGarageData(garage_id, G_IMPROVEMENTS, 1);

							static query[75];
							mysql_format(mysql, query, sizeof query, "UPDATE `garage` SET `improvements`=%d WHERE `id`=%d LIMIT 1", GetGarageData(garage_id, G_IMPROVEMENTS), GetGarageData(garage_id, G_SQL_ID));
							mysql_query(mysql, query, false);

							SendClientMessage(playerid, 0x3399FFFF, "Вы улучшили свой гараж до {FFCD00}первого {3399FF}уровня");
                            SendClientMessage(playerid, 0x66CC00FF, "На Ваше имя была оформлена субсидия, которая дает право платить пониженную арендную плату");
							SendClientMessage(playerid, 0x999999FF, "Благодаря этому, ежедневная арендная плата уменьшена в 2 раза");

							GivePlayerMoneyEx(playerid, -55000, "Улучшение гаража", true, true);
					    }
						case 2:
					    {
							if(GetGarageData(garage_id, G_IMPROVEMENTS) == 0) return SendClientMessage(playerid, 0xFF6600FF, "Сначало купите 1 уровень улучшения");
					        if(GetGarageData(garage_id, G_IMPROVEMENTS) > 1) return SendClientMessage(playerid, 0xFF6600FF, "Данное улучшение уже куплено");

					        if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 200000)) return SendClientMessage(playerid, 0xFF6600FF, "У Вас недостаточно средств");

							SetGarageData(garage_id, G_IMPROVEMENTS, 2);

							static query[75];
							mysql_format(mysql, query, sizeof query, "UPDATE `garage` SET `improvements`=%d WHERE `id`=%d LIMIT 1", GetGarageData(garage_id, G_IMPROVEMENTS), GetGarageData(garage_id, G_SQL_ID));
							mysql_query(mysql, query, false);

							SetGarageData(garage_id, G_WORKBENCH_LABEL, CreateDynamic3DTextLabel("{CB9E3A}Верстак\n{FFFFFF}Подойдите для взаимодействия", COLOR_GOLD, g_garage_pos_workbench[GetGarageData(garage_id, G_TYPE)-1][0],g_garage_pos_workbench[GetGarageData(garage_id, G_TYPE)-1][1],g_garage_pos_workbench[GetGarageData(garage_id, G_TYPE)-1][2] + 0.5, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, garage_id + 2000, -1, -1, 50.0));

							SendClientMessage(playerid, 0x3399FFFF, "Вы улучшили свой гараж до {FFCD00}второго {3399FF}уровня");
							SendClientMessage(playerid, 0x66CC00FF, "В вашем гараже появился верстак. Используйте его для крафта.");

							GivePlayerMoneyEx(playerid, -200000, "Улучшение гаража", true, true);
					    }
						case 3:
					    {
							if(GetGarageData(garage_id, G_IMPROVEMENTS) < 2) return SendClientMessage(playerid, 0xFF6600FF, "Сначало купите 2 уровень улучшения");
					        if(GetGarageData(garage_id, G_IMPROVEMENTS) > 2) return SendClientMessage(playerid, 0xFF6600FF, "Данное улучшение уже куплено");

					        if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 300000)) return SendClientMessage(playerid, 0xFF6600FF, "У Вас недостаточно средств");

							SetGarageData(garage_id, G_IMPROVEMENTS, 3);

							static query[75];
							mysql_format(mysql, query, sizeof query, "UPDATE `garage` SET `improvements`=%d WHERE `id`=%d LIMIT 1", GetGarageData(garage_id, G_IMPROVEMENTS), GetGarageData(garage_id, G_SQL_ID));
							mysql_query(mysql, query, false);

							new plate = GetGarageData(garage_id, G_PLATE_OBJECT);
                            if(!IsValidDynamicObject(plate))
		                    {
                                switch(GetGarageData(garage_id, G_TYPE))
			                    {
                                    case 1: plate = CreateDynamicObject(16931, -1611.69, 1578.99, 2006.93, 0.00, 0.00, 90.00, garage_id + 2000);
                                    case 2: plate = CreateDynamicObject(16930, 2892.99, 2891.19, 1001.50, 0.00, 0.00, 90.00, garage_id + 2000);
				                    case 3: plate = CreateDynamicObject(16929, -1667.14, -460.44, 1001.76, 0.00, 0.00, 90.00, garage_id + 2000);
                                }
                                SetGarageData(garage_id, G_PLATE_OBJECT, plate);
		                    }

							SendClientMessage(playerid, 0x3399FFFF, "Вы улучшили свой гараж до {FFCD00}третьего {3399FF}уровня");
							SendClientMessage(playerid, 0x66CC00FF, "Вы приобрели доску для номерных знаков, подойдите к ней, чтобы воспользоваться.");

							GivePlayerMoneyEx(playerid, -300000, "Улучшение гаража", true, true);
					    }
					}
				}
				else callcmd::garage(playerid, "");

			}
			case DIALOG_GARAGE_ENTER:
			{
				new garage_id = GetPlayerUseListitem(playerid);

				if(garage_id >= 0 && response)
				{
					if(!GetGarageData(garage_id, G_LOCK_STATUS))
					{
						EnterPlayerToGarage(playerid, garage_id);
					}
					else GameText(playerid, "~r~Закрыт", 3000, 2);
				}
			}
			case DIALOG_BANK_ACCOUNTS:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: ShowPlayerATMDialog(playerid);
						case 1..(MAX_BANK_ACCOUNTS):
						{
							new accountid = GetPlayerListitemValue(playerid, listitem - 1);
							if(IsValidBankAccount(playerid, accountid))
							{
								SetPlayerUseListitem(playerid, accountid);
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_LOGIN, DIALOG_STYLE_PASSWORD,
									"{FFD83D}Авторизация",
									"{FFFFFF}Введите PIN-код счета:",
									"Ввести", "Отмена"
								);
							}
						}
					}
				}
				else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_ACCOUNT_LOGIN:
			{
				if(response)
				{
					new accountid = GetPlayerUseListitem(playerid);
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);
						new pin_len = strlen(GetBankAccountData(playerid, accountid, BA_PIN_CODE));
						if(!strcmp(GetBankAccountData(playerid, accountid, BA_PIN_CODE), inputtext, false) && pin_len && len)
						{
							ShowPlayerBankAccountOperation(playerid);
						}
						else
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF9900}Ошибка",
								"{FFFFFF}Вы допустили ошибку при вводе PIN-кода",
								"Закрыть", ""
							);
						}
					}
				}
			}
			case DIALOG_BANK_ACCOUNT_OPERATION:
			{
				if(response)
				{
					new accountid = GetPlayerUseListitem(playerid);
					if(IsValidBankAccount(playerid, accountid))
					{
						switch(listitem + 1)
						{
							case 1: // Информация о счете
							{
								UpdateBankAccountData(playerid, accountid);

								static fmt_str[128];
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Номер счета:\t\t%d\n"\
									"Наименование:\t%s\n"\
									"Баланс:\t\t{00CC66}%s руб",
									GetBankAccountData(playerid, accountid, BA_ID),
									GetBankAccountData(playerid, accountid, BA_NAME),
									formatStr(GetBankAccountData(playerid, accountid, BA_BALANCE))
								);
								Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFD83D}Информация", fmt_str, "Вернуться", "");
							}
							case 2: // История операций
							{
								ShowPlayerBankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID));
							}
							case 3: // Снять деньги
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_TAKE_MONEY, DIALOG_STYLE_INPUT,
									"{FFD83D}Снять деньги",
									"{FFFFFF}Укажите сумму:",
									"Снять", "Отмена"
								);
							}
							case 4: // Положить деньги
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_PUT_MONEY, DIALOG_STYLE_INPUT,
									"{FFD83D}Положить деньги",
									"{FFFFFF}Укажите сумму:",
									"Положить", "Отмена"
								);
							}
							case 5: // Перевести на другой счет
							{
								if(GetPlayerLevel(playerid) > 3)
								{
									Dialog
									(
										playerid, DIALOG_BANK_ACCOUNT_TRANSFER_1, DIALOG_STYLE_INPUT,
										"{FFD83D}Перевод средств",
										"{FFFFFF}Укажите номер счета, на который\n"\
										"хотите осуществить перевод:",
										"Далее", "Отмена"
									);
								}
								else SendClientMessage(playerid, 0x999999FF, "* Перевод денег доступен только со 3 уровня");
							}
							case 6: // Переименовать счет
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_CHANGE_NAME, DIALOG_STYLE_INPUT,
									"{FFD83D}Переименование счета",
									"{FFFFFF}Введите новое название для этого счета.\n"\
									"Максимальная длина 20 символов:",
									"Ок", "Отмена"
								);
							}
							case 7: // Изменить PIN-код
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_CHANGE_PIN, DIALOG_STYLE_INPUT,
									"{FFD83D}Изменение PIN-кода",
									"{FFFFFF}Введите новый PIN-код.\n"\
									"Длина от 4 до 8 цифр:",
									"Ок", "Отмена"
								);
							}
						}
					}
				}
				else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_ACCOUNT_INFO:
			{
				ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TAKE_MONEY:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						if(IsILNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);

							static fmt_str[155];
							new money_str[23];
							format(money_str, sizeof money_str, "-%s", inputtext);
							if(GetILPlayerStr(GetBankAccountData(playerid, accountid, BA_BALANCE), inputtext))
							{
								format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=%s WHERE id=%d", SetILPlayerStr(playerid, GetBankAccountData(playerid, accountid, BA_BALANCE), money_str), GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									GivePlayerMoneyStr(playerid, inputtext, "Снятие с банк. счета (банк)");
									//SetBankAccountData(playerid, accountid, BA_BALANCE, balance - take_sum);
									format(g_bank_account[playerid][accountid][BA_BALANCE], 21, "%s", SetILPlayerStr(playerid, GetBankAccountData(playerid, accountid, BA_BALANCE), money_str));

									format(fmt_str, sizeof fmt_str, "- Снятие наличных %d руб", inputtext);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);

									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Счет:<t><t>№%d\n"\
										"Вы сняли:<t>{FF9900}%s руб\n"\
										"{FFFFFF}Остаток:<t>%s руб",
										GetBankAccountData(playerid, accountid, BA_ID),
										formatStr(inputtext),
										formatStr(GetBankAccountData(playerid, accountid, BA_BALANCE))
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}Операция завершена успешно", fmt_str, "Вернуться", "");
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
							}
							else
							{
								format(fmt_str, sizeof fmt_str, "Недостаточно средств. Текущий баланс счета №%d: {009966}%s руб", GetBankAccountData(playerid, accountid, BA_ID), formatStr(GetBankAccountData(playerid, accountid, BA_BALANCE)));
								SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
							}
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_TAKE_MONEY, DIALOG_STYLE_INPUT,
							"{FFD83D}Снять деньги",
							"{FFFFFF}Укажите сумму:",
							"Снять", "Отмена"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_PUT_MONEY:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						if(IsILNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);

							static fmt_str[155];

							new money_str[23];
							format(money_str, sizeof money_str, "-%s", inputtext);

							if(GetILPlayerStr(GetPlayerMoneyEx(playerid), inputtext))
							{
								format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=%s WHERE id=%d", SetILPlayerStr(playerid, GetBankAccountData(playerid, accountid, BA_BALANCE), inputtext), GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									GivePlayerMoneyStr(playerid, money_str, "Пополнение банк. счета (банк)");
					
									format(g_bank_account[playerid][accountid][BA_BALANCE], 21, "%s", SetILPlayerStr(playerid, GetBankAccountData(playerid, accountid, BA_BALANCE), inputtext));

									format(fmt_str, sizeof fmt_str, "+ Пополнение на сумму %d руб", inputtext);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);

									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Счет:\t\t\t№%d\n"\
										"Вы положили:\t{00CC00}%s руб\n"\
										"{FFFFFF}Итоговый баланс:\t%s руб",
										GetBankAccountData(playerid, accountid, BA_ID),
										formatStr(inputtext),
										formatStr(GetBankAccountData(playerid, accountid, BA_BALANCE))
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}Операция завершена успешно", fmt_str, "Вернуться", "");
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
							}
							else SendClientMessage(playerid, 0xFFFFFFFF, "Недостаточно средств");
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_PUT_MONEY, DIALOG_STYLE_INPUT,
							"{FFD83D}Положить деньги",
							"{FFFFFF}Укажите сумму:",
							"Положить", "Отмена"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TRANSFER_1:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new transfer_id = strval(inputtext);
						if(transfer_id > 0 && IsNumeric(inputtext))
						{
							static fmt_str[64 + 1];
							new Cache: result;
							new rows;

							format(fmt_str, sizeof fmt_str, "SELECT id,name,uid FROM bank_accounts WHERE id=%d LIMIT 1", transfer_id);
							result = mysql_query(mysql, fmt_str);

							if((rows = cache_num_rows()))
							{
								SetPlayerBankTransfer(playerid, BT_ID, cache_get_row_int(0, 0));
								SetPlayerBankTransfer(playerid, BT_UID, cache_get_row_int(0, 2));
								cache_get_row(0, 1, g_player_bank_transfer[playerid][BT_NAME], mysql, 21);
							}
							cache_delete(result);

							if(rows)
							{
								new to_player = GetPlayerIDBySqlID(GetPlayerBankTransfer(playerid, BT_UID));

								if(IsPlayerConnected(to_player) && IsPlayerLogged(to_player))
								{
									if(GetBankAccountData(playerid, accountid, BA_ID) != GetPlayerBankTransfer(playerid, BT_ID)) return ShowPlayerBankAccountTransfer(playerid, accountid);
									else return SCM(playerid, 0xc7590fFF, "Вы не можете совершить перевод на один и тот же счет.");
								}
								else SCM(playerid, 0xc7590fFF, "Владелец счета должен находиться на сервере.");
							}
							else SendClientMessage(playerid, 0xFF6600FF, "* Счета с таким номером не существует");
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_TRANSFER_1, DIALOG_STYLE_INPUT,
							"{FFD83D}Перевод средств",
							"{FFFFFF}Укажите номер счета, на который\n"\
							"хотите осуществить перевод:",
							"Далее", "Отмена"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TRANSFER_2:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new transfer_sum = strval(inputtext);
						new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);
						
						new to_player = GetPlayerIDBySqlID(GetPlayerBankTransfer(playerid, BT_UID));

						if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xc7590fFF, "Владелец счета должен находиться на сервере."), ShowPlayerATMTransfer(playerid);

						if(!GetILPlayerStr("2000000000", inputtext)) return SCM(playerid, COLOR_GREY, "* Перевод доступен до 2.000.000.000 руб за один раз"), ShowPlayerATMTransfer(playerid);

						if(transfer_sum > 0 && IsILNumeric(inputtext))
						{
							//UpdateBankAccountData(playerid, accountid);

							//new balance = GetBankAccountData(playerid, accountid, BA_BALANCE);
							if(GetILPlayerInt(GetBankAccountData(playerid, accountid, BA_BALANCE), transfer_sum))
							{
								static fmt_str[160];

								if(GetBankAccountData(playerid, accountid, BA_ID) != transfer_id)
								{
									format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=%s WHERE id=%d LIMIT 1", SetILPlayerInt(playerid, GetBankAccountData(playerid, accountid, BA_BALANCE), -transfer_sum), GetBankAccountData(playerid, accountid, BA_ID));
									mysql_query(mysql, fmt_str, false);

									format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=%s WHERE id=%d LIMIT 1", SetILPlayerInt(playerid, GetBankAccountBalance(transfer_id), transfer_sum / 100 * 80), transfer_id);
									mysql_query(mysql, fmt_str, false);

									//SetBankAccountData(playerid, accountid, BA_BALANCE, balance - transfer_sum);
									format(g_bank_account[playerid][accountid][BA_BALANCE], 21, "%s", SetILPlayerInt(playerid, GetBankAccountData(playerid, accountid, BA_BALANCE), -transfer_sum));

									format(g_bank_account[to_player][transfer_id][BA_BALANCE], 21, "%s", SetILPlayerInt(playerid, GetBankAccountBalance(transfer_id), transfer_sum / 100 * 80));
								}
								format(fmt_str, sizeof fmt_str, "- Перевод %d руб на счет №%d", transfer_sum / 100 * 80, transfer_id);
								BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);

								format(fmt_str, sizeof fmt_str, "+ Перевод %d руб со счета №%d", transfer_sum, GetBankAccountData(playerid, accountid, BA_ID));
								BankAccountLog(playerid, transfer_id, fmt_str);

								SetPlayerBankTransfer(playerid, BT_ID, 0);

								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Со счета:\t\t\t№%d\n"\
									"На счет:\t\t\t№%d\n"\
									"Cумма перевода:\t\t{FF9900}%s руб\n"\
									"{3caa3c}Коммисия:\t\t\t\t%s руб\n"\
									"{FFFFFF}Остаток на Вашем счете:\t{00CC66}%s руб",
									GetBankAccountData(playerid, accountid, BA_ID),
									transfer_id,
									formatInt(transfer_sum / 100 * 80),
									formatInt(transfer_sum / 100 * 20),
									formatStr(GetBankAccountData(playerid, accountid, BA_BALANCE))
								);
								Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}Перевод успешно выполнен", fmt_str, "Вернуться", "");

								new businessid = GetPlayerInBiz(playerid);

								AddBusinessProfit(playerid, businessid, transfer_sum / 100 * 20, 0);
							}
							else
							{
								SendClientMessage(playerid, 0xFF6600FF, "* На счету недостаточно средств для перевода");
								ShowPlayerBankAccountTransfer(playerid, accountid);
							}
						}
						else ShowPlayerBankAccountTransfer(playerid, accountid);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_CHANGE_NAME:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);

						if(3 <= len <= 20)
						{
							if(!IsABadBankAccountName(inputtext))
							{
								static fmt_str[128];

								mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET name='%e' WHERE id=%d LIMIT 1", inputtext, GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									format(g_bank_account[playerid][accountid][BA_NAME], 21, "%s", inputtext);

									format(fmt_str, sizeof fmt_str, "* Переименование счета на %s", inputtext);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);

									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Счет успешно переименован.\n"\
										"Теперь он будет доступен под названием %s",
										GetBankAccountData(playerid, accountid, BA_NAME)
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFD83D}Завершение", fmt_str, "Вернуться", "");
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 10)");
							}
							else
							{
								SendClientMessage(playerid, 0xFF6600FF, "* Недопустимые символы в новом названии");
								SendClientMessage(playerid, 0xFF6600FF, "* Можно использовать {FFCC15}русские {FF6600}и {FFCC15}английские {FF6600}буквы, а также {FFCC15}цифры");
							}
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* Длина названия счета может быть от {FFCC15}3 до 20 {FF6600}символов");

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_CHANGE_NAME, DIALOG_STYLE_INPUT,
							"{FFD83D}Переименование счета",
							"{FFFFFF}Введите новое название для этого счета.\n"\
							"Максимальная длина 20 символов:",
							"Ок", "Отмена"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_CHANGE_PIN:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);

						if(4 <= len <= 8 && IsNumeric(inputtext))
						{
							static fmt_str[128];

							mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET pin='%e' WHERE id=%d LIMIT 1", inputtext, GetBankAccountData(playerid, accountid, BA_ID));
							mysql_query(mysql, fmt_str, false);

							if(!mysql_errno())
							{
								format(g_bank_account[playerid][accountid][BA_PIN_CODE], 9, "%s", inputtext);
								BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), "* Изменение PIN-кода");

								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}PIN-код успешно изменен.\n"\
									"Рекомендуем сделать скрин (F8) чтобы не забыть его: {CCFF00}%s",
									GetBankAccountData(playerid, accountid, BA_PIN_CODE)
								);
								return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFD83D}Изменение PIN", fmt_str, "Вернуться", "");
							}
							else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 10)");
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_CHANGE_PIN, DIALOG_STYLE_INPUT,
							"{FFD83D}Изменение PIN-кода",
							"{FFFFFF}Введите новый PIN-код.\n"\
							"Длина от 4 до 8 цифр:",
							"Ок", "Отмена"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_RAZDEVALKA:
			{
			    if (!response) return 1; // Отмена

			    switch (listitem)
			    {
			        case 0:
			        {
			            // Снять/надеть рабочую форму
			            if (GetPlayerSkin(playerid) == GetPlayerData(playerid, P_OSKIN))
			            {
			                SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
			                SendClientMessage(playerid, -1, "* Вы сняли рабочую форму.");
							SetPlayerColorInit(playerid);
			            }
			            else
			            {
			                SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
			                SendClientMessage(playerid, -1, "* Вы надели рабочую форму.");
			            }
			        }
			        case 1:
					{
					 	new team_id = GetPlayerTeamEx(playerid);
						new player_rank = GetPlayerJobName(playerid);

						new string[256], temp[64];
						strcat(string, "interface('UniversalStore').addItems([");

						new bool:first = true;
						new last_skin = -1;

						for (new i = 0; i < 10; i++) {
						    new skin = GetTeamData(team_id, O_SKINS)[i];
						    if (skin <= 0) continue;
						    if (player_rank < i + 1) continue;
						    if (skin == last_skin) continue;

						    if (!first) strcat(string, ",");
						    format(temp, sizeof temp, "[%d,\"\"]", skin);
						    strcat(string, temp);
						    first = false;

						    last_skin = skin;
						}

						strcat(string, "])");

						MoralPacket_2(playerid, s_CefInterface, t_CefShow, "UniversalStore", "[\"Раздевалка\"]");
						MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, string);
					}
				}
			}
			case DIALOG_RAZDEVALKAM:
			{
				if(!response)
				{
    				SetPVarInt(playerid, "mechanic", 0);
					SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
					SendClientMessage(playerid, -1, "* Вы успешно сняли рабочую форму");
				}
				else
				{
    				SetPVarInt(playerid, "mechanic", 1);
					SetPlayerSkin(playerid, 268);
					SendClientMessage(playerid, -1, "* {}Используйте{} /end{} чтобы вернуть свою внешность");

				}
				//else SendClientMessage(playerid, -1, "* Вы не механик");
			}
			case DIALOG_VNEDRITSA:
			{
			    if(!response) return 1; // Нажата "Отмена"

			    switch(listitem)
			    {
			        case 0: // граждан
        			{
						new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name)))
    					{
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}

    					new random_nick = random(sizeof(UndercoverNames));
    					SetPlayerName(playerid, UndercoverNames[random_nick]); 
    					SetPlayerColor(playerid, 0xFFFFFF11); 

    					SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN)); 

    					SetPVarInt(playerid, "undercover_active", 1); 
						SetPVarInt(playerid, "select_frac", 0);

    					SCM(playerid, -1, "* Вы успешно внедрились как гражданский!");
    					return 1;
        			}
			        case 1: // гос
			        {
			            Dialog(playerid, DIALOG_MASKIROVKAA, DIALOG_STYLE_LIST, "МАСКИРОВКА - ГОС.СТРУКТУРЫ",
						"1.Правительство\n"\
						"2.Мин.Обороны\n"\
						"3.Мин.Здравоохранения\n"\
						"4.ТРК 'Ритм'\n"\
						"5.МВД\n"\
						"6.ФСИН",
						"Далее", "Отмена");
			        }
				}
			}
			case DIALOG_MASKIROVKAA: //ФСБ
			{
				switch(listitem+1)
				{
					case 1:
					{
						SetPVarInt(playerid, "select_frac", 1);
						Dialog(playerid, DIALOG_MASKIROVKA_LIST, DIALOG_STYLE_LIST, "МАСКИРОВКА - ГОС.СТРУКТУРЫ - РАНГИ",
						"1 Ранг - Водитель\n"\
						"2 Ранг - Охранник\n"\
						"3 Ранг - Нач. Охраны\n"\
						"4 Ранг - Секретарь\n"\
						"5 Ранг - Старший Секретарь\n"\
						"6 Ранг - Лицензёр\n"\
						"7 Ранг - Адвокат\n"\
						"8 Ранг - Депутат",
                        "Далее", "Отмена");
					}
					case 2:
					{
						SetPVarInt(playerid, "select_frac", 2);
						Dialog(playerid, DIALOG_MASKIROVKA_LIST, DIALOG_STYLE_LIST, "МАСКИРОВКА - ГОС.СТРУКТУРЫ - РАНГИ",
						"1 Ранг - Рядовой\n"\
						"2 Ранг - Ефрейтор\n"\
						"3 Ранг - Сержант\n"\
						"4 Ранг - Прапорщик\n"\
						"5 Ранг - Лейтенант\n"\
						"6 Ранг - Капитан\n"\
						"7 Ранг - Майор\n"\
						"8 Ранг - Подполковник",
						"Далее", "Отмена");
					}
					case 3:
					{
						SetPVarInt(playerid, "select_frac", 3);
						Dialog(playerid, DIALOG_MASKIROVKA_LIST, DIALOG_STYLE_LIST, "МАСКИРОВКА - ГОС.СТРУКТУРЫ - РАНГИ",
						"1 Ранг - Интерн\n"\
						"2 Ранг - Фельдшер\n"\
						"3 Ранг - Участковый врачn\n"\
						"4 Ранг - Терапевт\n"\
						"5 Ранг - Проктолог \n"\
						"6 Ранг - Нарколог\n"\
						"7 Ранг - Хирург\n"\
						"8 Ранг - Заведующий отделением",
						"Далее", "Отмена");
					}
					case 4:
					{
						SetPVarInt(playerid, "select_frac", 4);
						Dialog(playerid, DIALOG_MASKIROVKA_LIST, DIALOG_STYLE_LIST, "МАСКИРОВКА - ГОС.СТРУКТУРЫ - РАНГИ",
						"1 Ранг - Стажёр\n"\
						"2 Ранг - Светотехник\n"\
						"3 Ранг - Монтажёр\n"\
						"4 Ранг - Оператор\n"\
						"5 Ранг - Дизайнер\n"\
						"6 Ранг - Репортер\n"\
						"7 Ранг - Ведущий\n"\
						"8 Ранг - Режиссёр",
						"Далее", "Отмена");
					}
					case 5:
					{
						SetPVarInt(playerid, "select_frac", 6);
						Dialog(playerid, DIALOG_MASKIROVKA_LIST, DIALOG_STYLE_LIST, "МАСКИРОВКА - ГОС.СТРУКТУРЫ - РАНГИ",
						"1 Ранг - Рядовой\n"\
						"2 Ранг - Сержант\n"\
						"3 Ранг - Старшина\n"\
						"4 Ранг - Прапорщик\n"\
						"5 Ранг - Лейтенант\n"\
						"6 Ранг - Капитан\n"\
						"7 Ранг - Майор\n"\
						"8 Ранг - Подполковник",
						"Далее", "Отмена");
					}
					case 6:
					{
						SetPVarInt(playerid, "select_frac", 7);
						Dialog(playerid, DIALOG_MASKIROVKA_LIST, DIALOG_STYLE_LIST, "МАСКИРОВКА - ГОС.СТРУКТУРЫ - РАНГИ",
						"1 Ранг - Охранник \n"\
						"2 Ранг - Конвоир \n"\
						"3 Ранг - Надзиратель \n"\
						"4 Ранг - Инспектор\n"\
						"5 Ранг - Зам Нач Тюрьмы\n"\
						"6 Ранг - Начальник тюрьмы",
						"Далее", "Отмена");
					}
				}
			}
			case DIALOG_MASKIROVKA_LIST:
			{
				switch(listitem+1)
				{
					case 1:
					{
    					new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
            			SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,1, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию на 1 ранг!");
						return 1;

					}
					case 2:
					{
						new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
            			SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,2, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию на 2 ранг!");
						return 1;
					}
					case 3:
					{
						new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
            			SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,3, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию на 3 ранг!");
						return 1;
					}
					case 4:
					{
						new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
            			SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,4, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию на 4 ранг!");
						return 1;
					}
					case 5:
					{
						new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
            			SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,5, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию 5 ранг!");
						return 1;
					}
					case 6:
					{
						new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
            			SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,6, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию на 6 ранг!");
						return 1;
					}
					case 7:
					{
						new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
            			SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,7, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию на 7 ранг!");
						return 1;						
					}
					case 8:
					{
						new real_frac = GetPlayerTeamEx(playerid);
    					new real_rank = GetPlayerJobName(playerid);
    					SetPVarInt(playerid, "real_frac", real_frac);
    					SetPVarInt(playerid, "real_rank", real_rank);

    					new name[MAX_PLAYER_NAME];
    					if (!GetPVarString(playerid, "original_name", name, sizeof(name))) {
    					    GetPlayerName(playerid, name, sizeof(name));
    					    SetPVarString(playerid, "original_name", name);
    					}
						new frac = GetPVarInt(playerid, "select_frac");
						new random_nick = random(sizeof(UndercoverNames));
						SetPlayerName(playerid, UndercoverNames[random_nick]);
						SetPVarInt(playerid, "undercover_active", 1);
						new rang = GetPlayerJobName(playerid);
						SetPlayerData(playerid, P_MASKIROVKA, rang);
						UnInvite(playerid, playerid);
						InvitePlayer(playerid, frac,8, true);
						SCM(playerid, COLOR_GREEN, "Вы успешно внедрились в фракцию на 8 ранг!");
						return 1;						
						}
					}
				}
			case DIALOG_MASKIROVKA:
			{
			    if(!response) return 1; // Нажата "Отмена"
			
			    switch(listitem)
			    {
			        case 0: // Внедриться
			        {
			            Dialog(playerid, DIALOG_VNEDRITSA, DIALOG_STYLE_LIST, "Маскировка",
			                "1. Внедриться гражданским\n2. Внедриться в гос. организацию",
			                "Выбрать", "Назад");
			            return 1;  // важно завершить кейс
			        }
			
			        case 1: // Снять маскировку
			        {
			            if (GetPVarInt(playerid, "undercover_active") != 1)
			            {
			                SendClientMessage(playerid, -1, "* У вас нет активной маскировки.");
			                return 1;
			            }
			
			            new original_name[MAX_PLAYER_NAME];
			            if (GetPVarString(playerid, "original_name", original_name, sizeof(original_name)))
			            {
			                SetPlayerName(playerid, original_name);
			            }
			
			            new real_frac = GetPVarInt(playerid, "real_frac");
			            new real_rank = GetPVarInt(playerid, "real_rank");
			
			            DeletePVar(playerid, "original_name");
			            DeletePVar(playerid, "undercover_active");
			            DeletePVar(playerid, "select_frac");
			            DeletePVar(playerid, "real_frac");
			            DeletePVar(playerid, "real_rank");
						SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
						SetPlayerColorEx(playerid, team_colors[listitem + 1]);


						UnInvite(playerid, playerid);
						InvitePlayer(playerid, real_frac, real_rank, true);

						SetPlayerData(playerid, P_TEAM, real_frac);
						SetPlayerData(playerid, P_RANG, real_rank);
			
			            SendClientMessage(playerid, -1, "* Вы успешно сняли маскировку и вернулись в свою фракцию.");
			            return 1;
			        }
			
			        case 2: // Список сотрудников под прикрытием
			        {
			            static str[2048], temp[128];
			            format(str, sizeof(str), "ID\tНастоящее имя\tФейк-имя\tФракция\n\n{FFFFFF}");
			
			            new count = 0;
			
			            for (new i = 0; i < MAX_PLAYERS; i++)
			            {
			                if (!IsPlayerConnected(i)) continue;
			                if (GetPVarInt(i, "undercover_active") != 1) continue;
			
			                new fake_name[MAX_PLAYER_NAME], real_name[MAX_PLAYER_NAME], frac_type[28];
			                new frac_id = GetPVarInt(i, "select_frac");
			
			                GetPlayerName(i, fake_name, sizeof(fake_name));
			
			                if (!GetPVarString(i, "original_name", real_name, sizeof(real_name)))
			                    format(real_name, sizeof(real_name), "Неизвестно");
			
			                if (frac_id >= 0 && frac_id < sizeof(team_names))
			                    format(frac_type, sizeof(frac_type), "%s", team_names[frac_id]);
			                else
			                    format(frac_type, sizeof(frac_type), "Неизвестная");
			
			                format(temp, sizeof(temp), "%d\t%s\t%s\t%s\n", i, real_name, fake_name, frac_type);
			                strcat(str, temp, sizeof(str));
			                count++;
			            }
			
			            if (count == 0)
			            {
			                format(str, sizeof(str), "Нет сотрудников под прикрытием.");
			            }
			
			            Dialog(playerid, DIALOG_UNDERCOVER_LIST, DIALOG_STYLE_MSGBOX,
			                "Сотрудники под прикрытием", str, "Закрыть", "");
			            return 1;
			        }
			    }
			    return 1;
			}
			case DIALOG_RAZDEVALKAFSB:
			{
			    if (!response) return 1; // Отмена

			    switch (listitem)
			    {
			        case 0:
			        {
			            // Снять/надеть рабочую форму
			            if (GetPlayerSkin(playerid) == GetPlayerData(playerid, P_OSKIN))
			            {
			                SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
			                SendClientMessage(playerid, -1, "* Вы сняли рабочую форму.");
							SetPlayerColorInit(playerid);
			            }
			            else
			            {
			                SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
			                SendClientMessage(playerid, -1, "* Вы надели рабочую форму.");
			            }
			        }
			        case 1:
					{
					 	new team_id = GetPlayerTeamEx(playerid);
						new player_rank = GetPlayerJobName(playerid);

						new string[256], temp[64];
						strcat(string, "interface('UniversalStore').addItems([");

						new bool:first = true;
						new last_skin = -1;

						for (new i = 0; i < 10; i++) {
						    new skin = GetTeamData(team_id, O_SKINS)[i];
						    if (skin <= 0) continue;
						    if (player_rank < i + 1) continue;
						    if (skin == last_skin) continue;

						    if (!first) strcat(string, ",");
						    format(temp, sizeof temp, "[%d,\"\"]", skin);
						    strcat(string, temp);
						    first = false;

						    last_skin = skin;
						}

						strcat(string, "])");

						MoralPacket_2(playerid, s_CefInterface, t_CefShow, "UniversalStore", "[\"Раздевалка\"]");
						MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, string);

					}
			        case 2:
			        {
			        // в отпуске
			        }
			        case 3:
					{
					    Dialog(playerid, DIALOG_MASKIROVKA, DIALOG_STYLE_LIST, "Маскировка",
					        "1. Внедриться\n2. Снять маскировку\n3. Список сотрудников под прикрытием",
					        "Выбор", "Отмена");
					}
			    }
			    return 1;
			}
			case DIALOG_BUY_LIC:
			{
				switch(listitem + 1)
				{
					case 1: 
					{
						Dialog
						(
							playerid, DIALOG_BUY_DRIVING_LIC, DIALOG_STYLE_MSGBOX,
							"{FFFFFF}Подтверждение",
							"{FFFFFF}Название: {ffa500}'Водительские права'\n"\
							"{FFFFFF}Стоимость: {ffd700}100.000.000 руб\n\n"\
							"{FFFFFF}Вы действительно хотите приобрести лицензию?",
							"Купить", "Отмена"
						);
					}
					case 2: 
					{
						Dialog
						(
							playerid, DIALOG_BUY_GUN_LIC, DIALOG_STYLE_MSGBOX,
							"{FFFFFF}Подтверждение",
							"{FFFFFF}Название: {ffa500}'Разрешение на оружие'\n"\
							"{FFFFFF}Стоимость: {ffd700}250.000.000 руб\n\n"\
							"{FFFFFF}Вы действительно хотите приобрести лицензию?",
							"Купить", "Отмена"
						);
					}
					case 3:
					{
						Dialog
						(
							playerid, DIALOG_BUY_DRIVING_LIC_2, DIALOG_STYLE_MSGBOX,
							"{FFFFFF}Подтверждение",
							"{FFFFFF}Название: {ffa500}'Проф. права'\n"\
							"{FFFFFF}Стоимость: {ffd700}199.000.000 руб\n\n"\
							"{FFFFFF}Вы действительно хотите приобрести лицензию?",
							"Купить", "Отмена"
						);
					}
				}
				if(!response) return 1;
			}
			case DIALOG_BUY_DRIVING_LIC_2:
			{
				if(!response) return 1;

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 199000000)) return SCM(playerid, -1, "*У вас недостаточно средств.");

				if(GetPlayerData(playerid, P_DRIVING_LIC) == 2) return SendClientMessage(playerid, 0x999999FF, "* У вас уже есть лицензия на вождение профессионального уровня");

				GivePlayerMoneyEx(playerid, -199000000);

				SetPlayerData(playerid, P_DRIVING_LIC, 2);
				UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));

				SendClientMessage(playerid, COLOR_GREY, "* Вы успешно приобрели лицензию \"Проф. права\"");
			}
			case DIALOG_BUY_GUN_LIC:
			{
				if(!response) return 1;

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 250000000)) return SCM(playerid, -1, "*У вас недостаточно средств.");

				if(GetPlayerData(playerid, P_WEAPON_LIC) == 1) return SendClientMessage(playerid, 0x999999FF, "* У вас уже есть лицензия на оружие");

				GivePlayerMoneyEx(playerid, -250000000);

				SendClientMessage(playerid, COLOR_GREY, "* Вы успешно приобрели лицензию \"Разрешение на оружие\"");

				SetPlayerData(playerid, P_WEAPON_LIC, 1);
				UpdatePlayerDatabaseInt(playerid, "weapon_lic", GetPlayerData(playerid, P_WEAPON_LIC));
			}
			case DIALOG_BUY_DRIVING_LIC:
			{
				if(!response) return 1;

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 100000000)) return SCM(playerid, -1, "*У вас недостаточно средств.");

				if(GetPlayerData(playerid, P_DRIVING_LIC) >= 1) return SendClientMessage(playerid, 0x999999FF, "* У вас уже есть водительское удостоверение");

				GivePlayerMoneyEx(playerid, -100000000);

				SetPlayerData(playerid, P_DRIVING_LIC, 1);
				UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));

				SendClientMessage(playerid, COLOR_GREY, "* Вы успешно приобрели лицензию \"Водительские права\"");
			}
			case DIALOG_DEVICE_AUTH:
			{
				switch(listitem)
				{
					case 0:
					{
	 				GameText(playerid, "~y~УСПЕШНАЯ АВТОРИЗАЦИЯ~n~~g~M - MOBILE", 8000, 2);
					SendClientMessage(playerid, -1, "{"SERVER_COLOR"}[device] {FFFFFF}Вы выбрали игру с телефона");
					SetPlayerData(playerid, P_MOBILE, 1);
					UpdatePlayerDatabaseInt(playerid, "mobile", 1);
					UpdatePlayerDatabaseInt(playerid, "device", 1);
					SetPlayerData(playerid, P_DEVICE, 1);
					}
				    case 1:
					{
					GameText(playerid, "~y~УСПЕШНАЯ АВТОРИЗАЦИЯ~n~~b~M - LAUNCHER", 8000, 2);
					SendClientMessage(playerid, -1, "{"SERVER_COLOR"}[device] {FFFFFF}Вы выбрали игру с компьютера");
					SetPlayerData(playerid, P_LAUNCHER, 1);
					UpdatePlayerDatabaseInt(playerid, "launcher", 1);
					UpdatePlayerDatabaseInt(playerid, "device", 1);
					SetPlayerData(playerid, P_DEVICE, 1);				
					}
				}
			}
			case DIALOG_BANK_CREATE_ACCOUNT:
			{
				if(response)
				{
					new len = strlen(inputtext);
					if(3 <= len <= 20)
					{
						if(!IsABadBankAccountName(inputtext))
						{
							static query[128];
							new Cache: result;
							new total_accounts;

							format(query, sizeof query, "SELECT COUNT(*) FROM bank_accounts WHERE uid=%d", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query);

							total_accounts = cache_get_row_int(0, 0);
							cache_delete(result);

							if(total_accounts < MAX_BANK_ACCOUNTS)
							{
								mysql_format(mysql, query, sizeof query, "INSERT INTO bank_accounts (uid,name,reg_time) VALUES (%d,'%e',%d)", GetPlayerAccountID(playerid), inputtext, gettime());
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									Dialog
									(
										playerid, DIALOG_BANK_CREATED_ACCOUNT, DIALOG_STYLE_MSGBOX,
										"{FFD83D}Счет создан",
										"{FFFFFF}Вы создали новый счет в банке.\n\n"\
										"Для доступа к нему используйте PIN-код {00FF66}0000{FFFFFF}. После входа\n"\
										"настоятельно рекомендуем изменить его на более сложный.\n"\
										"Это поможет защитить счет от несанкционированного доступа.",
										"Готово", ""
									);
								}
							}
							else Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFD83D}Лимит счетов", "{FFFFFF}Можно создать не более восьми банковских счетов", "Ок", "");
						}
						else
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF3300}Ошибка",
								"{FFFFFF}Операция запрещена. Недопустимые символы в названии счета\n"\
								"Можно использовать {FFCC15}русские {FFFFFF}и {FFCC15}английские {FFFFFF}буквы, а также {FFCC15}цифры",
								"Выход", ""
							);
						}
					}
					else
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{FF3300}Ошибка",
							"{FFFFFF}Длина названия счета может быть от {FFCC15}3 до 20 {FFFFFF}символов",
							"Закрыть", ""
						);
					}
				}
				else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_CREATED_ACCOUNT:
			{
				ShowPlayerBankDialog(playerid);
			}
			// -----------------------------------------------------------------
			case DIALOG_PHONE_CALL:
			{
				if(response)
				{
					new number = strval(inputtext);

					if(number >= 0 && strlen(inputtext))
					{
						new params[16];
						valstr(params, number);

						callcmd::c(playerid, params);
					}
					else SendClientMessage(playerid, 0xCECECEFF, "* Ошибка набора");
				}
			}
			case DIALOG_PHONE_CALL_BALANCE:
			{
				SetPlayerPhoneUseState(playerid, false);
			}
			case DIALOG_CONFIG:
			{
				if(!response) return 1;
				switch(listitem)
				{
					case 0, 1, 2:
					{
						SendClientMessage(playerid, -1, "* Используйте /setrates чтобы изменить");
					}
					case 3:
					{
						if(Test_server == 0)
						{
							Test_server = 1;
							SendClientMessage(playerid, -1, "* Вы успешно включили запрет игрокам на тест");
						}
						else
						{
							Test_server = 0;
							SendClientMessage(playerid, -1, "* Вы успешно выключили запрет игрокам на тест");
						}
						SaveServerConfig();
					}
					case 4:
					{
						static query[128];
						format(query, sizeof query, "SELECT name FROM test_user");
						mysql_tquery(mysql, query, "ShowTestPlayer", "i", playerid);
					}
					case 5:
					{
						SendClientMessage(playerid, -1, "* Используйте /addzbtplayer чтобы добавить");
					}
					case 6:
					{
						SendClientMessage(playerid, -1, "* Используйте /delzbtplayer чтобы удалить");
					}
					case 7:
					{
						if(Update_server == 0)
						{
							Update_server = 1;
							SendClientMessage(playerid, -1, "* Вы успешно включили загрузку обновления");
						}
						else
						{
							Update_server = 0;
							SendClientMessage(playerid, -1, "* Вы успешно выключили загрузку обновления");
						}
						SaveServerConfig();
					}
				}
			}
			case DIALOG_INFO_HELP:
			{
			    if(!response) return 1;
				switch(listitem + 1)
				{
				    case 1:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Информация о проекте", "{FFFFFF}"SERVER_NAME_RP" - наилучший и качественный проект среди\nсерверов копий Радмира\n\nСайт проекта: "SERVER_SITE"", "Закрыть", "");
				    }
				    case 2:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Где заработать денег?", "Деньги можно заработать на подработках (шахта, ферма, лесопилка, завод, ферма)\nНайти месторасположение работ можно с помощью GPS (/gps > Работа)", "Закрыть", "");
				    }
				    case 3:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Где получить права на вождение?", "Чтобы получить права на вождение Вам нужно сдать экзамен в автошколе\nGPS > Автошкола за 1000 рублей, либо купить права у инструктора", "Закрыть", "");
				    }
				    case 4:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как купить жилье?", "Купить дом или квартиру можно у государства или с рук у игрока\nНа Вашем радаре будут отображаться иконки домов\nЕсли иконка зеленая, то дом продается, если красная - нет", "Закрыть", "");
				    }
				    case 5:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как купить бизнес?", "Бизнес можно купить у государства или с рук у игрока\nНайти бизнес можно с помощью GPS (/gps > Бизнесы)", "Закрыть", "");
				    }
				    case 6:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как купить авто?", "Автомобиль можно купить в автосалоне (/gps > Автосалоны) или с рук у игрока\nДля того чтобы пользоваться машиной, Вам нужно жилье", "Закрыть", "");
				    }
				    case 7:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как прокачать уровень?", "Каждый час в XX:00 минут Вам начисляется опыт\nУзнать очки опыта можно в статистике (/mn - Статистика)\nДля получения опыта Вы не должны находиться в AFK", "Закрыть", "");
				    }
				    case 8:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как вступить в организацию?", "О наборах в государственные организации cообщают в чате\nО наборах в нелегальные организации сообщают в объявлениях СМИ\nДля вступление в организацию Вам потребуется водительские права и от 3-ех лет проживания в области", "Закрыть", "");
				    }
				    case 9:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как стать агентом поддержки или лидером?", "Для того чтобы стать лицом проекта Вам необходимо иметь опыт в RolePlay режиме,\nзнать на отлично базовый уровень игрока, уметь общаться с людьми,\nсмотреть всегда наперед и показать себя для всех с хорошей стороны\nДля просмотра свободных мест на лидерство посетите наш форум: ", "Закрыть", "");
				    }
				    case 10:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как найти нужное мне место?", "Любое нужное Вам место можно найти с помощью GPS (/gps)\nЕсли Вы не нашли нужное Вам место - спросите у агентов поддержки (/report - Вопрос)", "Закрыть", "");
				    }
				    case 11:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Где достать оружие?", "Оружие можно купить у любого игрока имеющего оружие\nили приобрести в магазине оружия (/gps - Бизнесы)", "Закрыть", "");
				    }
				    case 12:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Где устроиться на работу?", "Трудоустройство проходит в центре занятости, либо на базах организаций (/gps - Базы организаций)", "Закрыть", "");
				    }
				    case 13:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как посмотреть команды?", "Для просмотра нужных Вам команд используйте: /mn - Список команд", "Закрыть", "");
				    }
				    case 14:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как добраться до работы?", "Добраться до работы можно с помощью такси или маршрутки\nЕсли их нет долгое время - воспользуйтесь попуткой", "Закрыть", "");
				    }
				    case 15:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Где купить телефон и SIM-карту?", "Телефон и SIM-карту можно купить в любом из магазинов 24/7\nСтоимость телефона 2000 рублей, SIM-карта 500 рублей", "Закрыть", "");
				    }
				    case 16:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как мне уволиться из фракции?", "Чтобы покинуть фракцию Вам необходимо сообщить об этом лидеру или заместителю фракции:\nИспользуйте: /r Прошу меня уволить по причине (указать причину)\nПри наличии улучшений аккаунта используйте команду: /leave", "Закрыть", "");
				    }
				    case 17:
				    {
				        Dialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFD83D}Как узнать номер телефона игрока?", "Если игрок находится в игре, то используйте команду: /number [имя игрока]", "Закрыть", "");
				    }
				}
			}
			// -----------------------------------------------------------------
			// -----------------------------------------------------------------
   case DIALOG_ACTION:
			{
				if(response)
				{
					if(1 <= (listitem+1) <= 4)
					{
						new targetid = GetPlayerData(playerid, P_TARGET_ID);

						if(IsPlayerConnected(targetid) && IsPlayerLogged(targetid))
						{
							if(IsPlayerInRangeOfPlayer(playerid, targetid, 10.0))
							{
								new params[5];
								valstr(params, targetid);

								new cmd[4][16] = {"cmd_hi", "cmd_pass", "cmd_lic", "cmd_skill"};
								CallLocalFunction(cmd[listitem], "ds", playerid, params);
							}
							else SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");
						}
						else SendClientMessage(playerid, 0x999999FF, "* Игрок вышел из игры");
					}
					SetPlayerData(playerid, P_TARGET_ID, INVALID_PLAYER_ID);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_VIEV_JOBS_LIST:
			{
				if(response)
				{
					new count;
					if(GetPlayerData(playerid, P_JOB) == 1) count = 7;
					if(GetPlayerData(playerid, P_JOB) == 2) count = 8;
					if(GetPlayerData(playerid, P_JOB) == 3) count = 12;
					if(GetPlayerData(playerid, P_JOB) == 4) count = 16;

					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[%d,[%d],[0,2],[[7,5,122000000,0,[]],[8,6,120500000,0,[]],[12,9,0,0,[]],[16,11,0,0,[]]]]", GetPlayerLevel(playerid), count);
					MoralPacket_2(playerid, s_CefInterface, t_CefShow,"Employment", STRING_GLOBAL);
				}
			}
			case DIALOG_END_JOB:
			{
				if(response)
					EndPlayerJob(playerid);
			}
			case DIALOG_BUS_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 180))
						{
							GivePlayerMoneyEx(playerid, -180, "Аренда автобуса", true, true);

							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, COLOR_WHITE, "Для того, чтобы начать работу водителя автобуса {"#cGold"}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* У Вас недостаточно денег чтобы заключить договор аренды");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}	
			case DIALOG_BUS_ROUTE_COST:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						new route_cost = strval(inputtext);

						if(0 <= route_cost <= 10000000 && IsNumeric(inputtext))
						{
							SetPlayerData(playerid, P_JOB_TARIFF, route_cost);

							Dialog
							(
								playerid, DIALOG_BUS_ROUTE_SELECTION, DIALOG_STYLE_LIST,
								"{"#cGold"}Выберите маршрут",
								g_bus_routes_list,
								"Ок", "Отмена"
							);
						}
						else
						{
							Dialog
							(
								playerid, DIALOG_BUS_ROUTE_COST, DIALOG_STYLE_INPUT,
								"{"#cGold"}Стоимость проезда",
								"{"#cW"}Сколько будет стоить проезд?\n"\
								"Укажите цену от 0 до 10000000 рублей",
								"Далее", "Отмена"
							);
						}
					}
				}
			}
			case DIALOG_BUY_ACS:
    		{
    		  if(response)
    		  {
    		    new businessid = GetPlayerInBiz(playerid);
    		    if(businessid != -1)
    		    {
    		      SetPVarInt(playerid, "akstype", 0);
    		      SetPVarInt(playerid, "category_bs", 0);
    		      MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Accessories", "[[[\"Очки\",0],[\"Банданы\",1],[\"Маски\",2],[\"Береты\",3],[\"Шляпы\",4],[\"Сумки\",5],[\"Аксессуары на пояс\",6],[\"Часы\",7],[\"Рюкзаки\",8]],[[19006,\"Золотые\",300000,0,0],[19007,\"Черные\",350000,0,1],[19008,\"Голубые\",350000,0,2],[19009,\"Белые\",350000,0,3],[19010,\"Красные\",350000,0,4],[19011,\"Желтые\",350000,0,5],[19012,\"Розовые\",350000,0,6],[19013,\"Серые\",350000,0,7],[19014,\"Зеленые\",350000,0,8],[19015,\"Темные\",350000,0,9],[19016,\"X-ray\",350000,0,10],[13953,\"Лук Купидона\",8750000,0,11],[13995,\"Gucci\",1050000,0,12],[13996,\"American\",1050000,0,13],[13997,\"С черепами\",1050000,0,14],[13998,\"Санта клаус\",1050000,0,15],[13999,\"Красный\",1050000,0,16]]]");
    		      SetPlayerVirtualWorld(playerid, playerid + 10);
    		      SetPlayerPos(playerid, 1238.4243,-2777.9377,1001.0000);
    		      SetPlayerFacingAngle(playerid, 89.0);
    		      SetPlayerCameraPos(playerid,1237.894775,-2778.349853,1001.36);
    		      SetPlayerCameraLookAt(playerid,1247.072998,-2774.717529,999.0);
    		      ApplyAnimation(playerid, "PED", "SEAT_down", 4.1, 0, 0, 0, 1, 0, 1);
    		    }
    		    return 1;
    		  }
    		  return 1;
    		}
			case DIALOG_BUS_ROUTE_SELECTION:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(0 <= listitem <= sizeof g_bus_routes - 1)
						{
							SetPlayerData(playerid, P_BUS_ROUTE_STEP, 0);
							SetPlayerData(playerid, P_BUS_ROUTE, listitem);

							StartPlayerJob(playerid, JOB_BUS_DRIVER);
						}
					}
				}
			}
			case DIALOG_VIP_MENU:
			{
			if(!response) return 1;

            switch(listitem + 1)
				{
					case 1:
					{
						if(GetPlayerData(playerid, P_PODPISKA) != 1) return SendClientMessage(playerid, 0x999999FF, "Вы не являетесь обладателем "SERVER_PODPISKA".");

						SetPlayerHealthEx(playerid, 100);

						static query[148];
						format(query, sizeof query, "~g~"SERVER_PODPISKA" | +100 HP");
						GameText(playerid, query, 3000, 2);

						static fmt_msg[128];
						format(fmt_msg, sizeof(fmt_msg), "A: VIP-Игрок %s[%d] пополнил своё здоровье через /vipmenu", GetPlayerNameEx(playerid), playerid);
						SendMessageToAdmins(fmt_msg, 0x999999FF);
					}
					case 2:
					{
						if(GetPlayerData(playerid, P_PODPISKA) != 1) return SendClientMessage(playerid, 0x999999FF, "Вы не являетесь обладателем "SERVER_PODPISKA".");

						SetPlayerArmour(playerid, 100.0);

						static query[148];
						format(query, sizeof query, "~g~"SERVER_PODPISKA" | +100 ARMOUR");
						GameText(playerid, query, 3000, 2);

						static fmt_msg[128];
						format(fmt_msg, sizeof(fmt_msg), "A: VIP-Игрок %s[%d] пополнил свою броню через /vipmenu", GetPlayerNameEx(playerid), playerid);
						SendMessageToAdmins(fmt_msg, 0x999999FF);
					}
					case 3:
					{
						if(GetPlayerData(playerid, P_PODPISKA) != 1) return SendClientMessage(playerid, 0x999999FF, "Вы не являетесь обладателем "SERVER_PODPISKA".");

						if(!IsPlayerInAnyVehicle(playerid))
							return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в транспорте");

						new vehicleid = GetPlayerVehicleID(playerid);

						if(IsAOwnableCar(vehicleid))
							SetVehicleData(vehicleid, V_HEALTH, 1000.0);

						RepairVehicle(vehicleid);

						if(IsAOwnableCar(vehicleid))
							SetVehicleData(vehicleid, V_HEALTH, 1000.0);

						static query[148];
						format(query, sizeof query, "~g~"SERVER_PODPISKA" | FIXCAR");
						GameText(playerid, query, 3000, 2);

						static fmt_msg[128];
						format(fmt_msg, sizeof(fmt_msg), "A: VIP-Игрок %s[%d] починил своё авто через /vipmenu", GetPlayerNameEx(playerid), playerid);
						SendMessageToAdmins(fmt_msg, 0x999999FF);
					}
					case 4:
					{
						if(GetPlayerData(playerid, P_PODPISKA) != 1) return SendClientMessage(playerid, 0x999999FF, "Вы не являетесь обладателем "SERVER_PODPISKA".");

						page_cars[playerid] = 1;
						type_page_cars[playerid] = 4;
						SetPVarInt(playerid, "playerid", playerid);
						ShowOwnableCars(playerid, DIALOG_OWNABLE_CAR_SELECT, page_cars[playerid]);

						static query[148];
						format(query, sizeof query, "~g~"SERVER_PODPISKA" | GETV");
						GameText(playerid, query, 3000, 2);

						static fmt_msg[128];
						format(fmt_msg, sizeof(fmt_msg), "A: VIP-Игрок %s[%d] телепортировал своё авто к себе через /vipmenu", GetPlayerNameEx(playerid), playerid);
						SendMessageToAdmins(fmt_msg, 0x999999FF);
					}
					case 5:
					{
						if(GetPlayerData(playerid, P_PODPISKA) != 1) return SendClientMessage(playerid, 0x999999FF, "Вы не являетесь обладателем "SERVER_PODPISKA".");

						if(!IsPlayerInAnyVehicle(playerid))
							return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в транспорте");

						new vehicleid = GetPlayerVehicleID(playerid);

						SetVehicleData(vehicleid, V_FUEL, 100);

						static query[148];
						format(query, sizeof query, "~g~"SERVER_PODPISKA" | SETFUEL");
						GameText(playerid, query, 3000, 2);

						static fmt_msg[128];
						format(fmt_msg, sizeof(fmt_msg), "A: VIP-Игрок %s[%d] заправил своё авто через /vipmenu", GetPlayerNameEx(playerid), playerid);
						SendMessageToAdmins(fmt_msg, 0x999999FF);
					}
					case 6:
					{
						if(GetPlayerData(playerid, P_PODPISKA) != 1) return SendClientMessage(playerid, 0x999999FF, "Вы не являетесь обладателем "SERVER_PODPISKA".");

						SpawnPlayer(playerid);

						static query[148];
						format(query, sizeof query, "~g~"SERVER_PODPISKA" | SPAWN");
						GameText(playerid, query, 3000, 2);

						static fmt_msg[128];
						format(fmt_msg, sizeof(fmt_msg), "A: VIP-Игрок %s[%d] заспавнил себя через /vipmenu", GetPlayerNameEx(playerid), playerid);
						SendMessageToAdmins(fmt_msg, 0x999999FF);
					}
				}
			}
			case DIALOG_SMSFSB:
        	{
			if(response)
			{

           	 	if(strlen(inputtext) < 1)
           	 	    return SendClientMessage(playerid, 0xFF0000FF, "* Вы не ввели номер");

           	 	new number = strval(inputtext);

           	 	if(number == 0)
           	 	{
           	 	    listen_number[playerid] = 0;
           	 	    return SendClientMessage(playerid, 0x3399FFFF, "* Прослушка SMS отключена");
           	 	}

           	 	new subscriber = GetPlayerIDByPhone(number);
           	 	if(subscriber == INVALID_PLAYER_ID)
           	 	    return SendClientMessage(playerid, 0xCECECEFF, "* Такого номера не существует");

           	 	listen_number[playerid] = number;

           	 	static msg[64];
           	 	format(msg, sizeof msg, "* Вы теперь прослушиваете SMS с номера: %d", number);
           	 	SendClientMessage(playerid, 0x3399FFFF, msg);
				}
			}
			case DIALOG_TAXI_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 150000))
						{
							GivePlayerMoneyEx(playerid, -150000, "Аренда такси", true, true);

							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, COLOR_WHITE, "Для того, чтобы начать работу таксиста {"#cGold"}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "* У Вас недостаточно денег чтобы заключить договор аренды");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_RERFECT_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_RERFECT && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 180))
						{
							GivePlayerMoneyEx(playerid, -180, "Аренда эвакуатора", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);

							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, 0x66CC00FF, "* Для того, чтобы начать работу автомеханика {FF9900}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
						else SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег чтобы заключить договор аренды");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_RERFECT_START_JOB:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_RERFECT && action_id == VEHICLE_ACTION_ID_NONE)
					{
						Dialog
						(
							playerid, DIALOG_RERFECT_NAME, DIALOG_STYLE_INPUT,
							"{FFD83D}Автомеханик",
							"{FFFFFF}Введите название для Вашей техслужбы,\n"\
							"или оставьте поле пустым",
							"Готово", "Отмена"
						);
					}
				}
			}
			case DIALOG_RERFECT_NAME:
			{
				if(response)
				{
					new len = strlen(inputtext);

					if(len)
					{
						if(!(1 <= len <= 15))
						{
							Dialog
							(
								playerid, DIALOG_MECHANIC_NAME, DIALOG_STYLE_INPUT,
								"{FFD83D}Автомеханик",
								"{FFFFFF}Введите название для Вашей техслужбы,\n"\
								"или оставьте поле пустым",
								"Готово", "Отмена"
							);
							return SendClientMessage(playerid, 0xCECECEFF, "* Слишком длинное название | 15 символов максимум");
						}
						else format(g_player[playerid][P_JOB_SERVICE_NAME], 17, "%s\n", inputtext);
					}
					else g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;

					StartPlayerJob(playerid, JOB_RERFECT_DRIVER);
				}
			}
			case DIALOG_TAXI_NAME:
			{
				if(response)
				{
					if(!(1 <= strlen(inputtext) <= 15))
					{
						Dialog
						(
							playerid, DIALOG_TAXI_NAME, DIALOG_STYLE_INPUT,
							"{FFD83D}Название такси",
							"{FFFFFF}Придумайте название для вашего такси\n"\
							"Максимальная длина 15 символов\n\n"\
							"Если вы не хотите как-то называться\n"\
							"нажмите кнопку Пропустить",
							"Далее", "Пропустить"
						);
						return 1;
					}
					else format(g_player[playerid][P_JOB_SERVICE_NAME], 17, "%s\n", inputtext);
				}
				else g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;

				Dialog
				(
					playerid, DIALOG_TAXI_TARIFF, DIALOG_STYLE_INPUT,
					"{FFD83D}Настройка счетчика",
					"{FFFFFF}Укажите тариф по которому будет работать ваше такси\n"\
					"Эта сумма будет сниматься с пассажира каждые 100 м поездки\n"\
					"Тарифная ставка может быть от 0 до 5000 рублей",
					"Ок", "Отмена"
				);
			}
			case DIALOG_TAXI_TARIFF:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						new tariff = strval(inputtext);

						if(!(0 <= tariff <= 333333) || !IsNumeric(inputtext))
						{
							Dialog
							(
								playerid, DIALOG_TAXI_TARIFF, DIALOG_STYLE_INPUT,
								"{FFD83D}Настройка счетчика",
								"{FFFFFF}Укажите тариф по которому будет работать ваше такси\n"\
								"Эта сумма будет сниматься с пассажира каждые 100 м поездки\n"\
								"Тарифная ставка может быть от 0 до 333,333 рублей",
								"Ок", "Отмена"
							);
							return 1;
						}
						else
						{
							SetPlayerData(playerid, P_JOB_TARIFF, tariff);
							StartPlayerJob(playerid, JOB_TAXI_DRIVER);
						}
					}
				}
				g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;
			}
			case DIALOG_MECHANIC_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_MECHANIC && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 180))
						{
							GivePlayerMoneyEx(playerid, -180, "Аренда эвакуатора", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);

							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, 0x66CC00FF, "* Для того, чтобы начать работу автомеханика {FF9900}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
						else SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег чтобы заключить договор аренды");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_MECHANIC_START_JOB:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_MECHANIC && action_id == VEHICLE_ACTION_ID_NONE)
					{
						Dialog
						(
							playerid, DIALOG_MECHANIC_NAME, DIALOG_STYLE_INPUT,
							"{FFD83D}Автомеханик",
							"{FFFFFF}Введите название для Вашей техслужбы,\n"\
							"или оставьте поле пустым",
							"Готово", "Отмена"
						);
					}
				}
			}
			
			case DIALOG_TRUCKER_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 2000000)) return SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег чтобы заключить договор аренды");

					GivePlayerMoneyEx(playerid, -2000000, "Аренда грузовика", true, true);

					SetPlayerData(playerid, P_JOB_CAR, vehicleid);

					SetPlayerData(playerid, P_IN_JOB, true);
					
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{FFA500}Транспортная компания\n{FFFFFF}%s", GetBusinessData(GetPlayerData(playerid, P_TK_JOB), B_NAME));
					CreateVehicleLabel(vehicleid, STRING_GLOBAL, 0x3399FFFF, 0.0, 2.1, 3.1, 20.0);
					
					SCM(playerid, 0xFFFFFFFF, "Вы начали свой {E6CE7B}рабочий день. Посигнальте {FFFFFF}и выберите необходимый прицеп");
				}
				else RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_TRUCKER_START_JOB:
			{
				if(response)
				{
					StartPlayerJob(playerid, JOB_TRUCKER);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_PHONE_BOOK:
			{
				if(response && (0 <= listitem <= MAX_PHONE_BOOK_CONTACTS-1))
				{
					ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS, listitem);
				}
			}
			case DIALOG_WOSH_SKIN:
			{
				if(!response) return 1;
				
				if(!GetPlayerSex(playerid))
					SetPlayerSkin(playerid, 252);
				else
					SetPlayerSkin(playerid, 75);

				SendClientMessage(playerid, 0xB0C4DEFF, "Вы запустили стиральную машину. Не покидайте прачечную до окончания стирки");

				woshtimer[playerid] = SetTimerEx("WoshTimer", 2000, true, "i", playerid);

				MoralPacket_2(playerid, s_CefInterface, t_CefShow, "ProgressBar", "[[\"Одежда стирается\", 0, 1000]]");

			    TogglePlayerControllable(playerid, false);

			}
			case DIALOG_PHONE_BOOK_OPTION:
			{
				new contactid = GetPlayerPhoneBookSelectContact(playerid);
				if(contactid != INVALID_PLAYER_ID)
				{
					if(response)
					{
						ShowPhoneBookOperation(playerid, listitem + 1, contactid);
					}
					else ShowPlayerPhoneBook(playerid);
				}
			}
			case DIALOG_PHONE_BOOK_SEND_SMS:
			{
				if(response)
				{
					new len = strlen(inputtext);
					if(len)
					{
						if(len < 65)
						{
							new contactid = GetPlayerPhoneBookSelectContact(playerid);
							static fmt_str[90];

							format(fmt_str, sizeof fmt_str, "%s %s", GetPlayerPhoneBook(playerid, contactid, PB_NUMBER), inputtext);
							callcmd::sms(playerid, fmt_str);
							return 1;
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Слишком длинное сообщение");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "* Введите сообщение для отправки");

					ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_SEND_SMS);
				}
				else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_CHANGE_NAME:
			{
				if(response)
				{
					if(3 <= strlen(inputtext) <= 20)
					{
						new contactid = GetPlayerPhoneBookSelectContact(playerid);
						static query[90];

						format(g_player_phone_book[playerid][contactid][PB_NAME], 21, "%s", inputtext);

						mysql_format(mysql, query, sizeof query, "UPDATE phone_books SET name='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
						mysql_query(mysql, query, false);

						SendClientMessage(playerid, 0x99CC33FF, "Имя контакта изменено");
						ShowPlayerPhoneBook(playerid);
					}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_CHANGE_NAM);
				}
				else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_CHANGE_NUMBER:
			{
				if(response)
				{
					if(3 <= strlen(inputtext) <= 9 && strval(inputtext) > 0 && IsNumeric(inputtext))
					{
						if(!CheckPhoneBookUsedNumber(playerid, inputtext))
						{
							new contactid = GetPlayerPhoneBookSelectContact(playerid);
							static query[90];

							format(g_player_phone_book[playerid][contactid][PB_NUMBER], 10, "%s", inputtext);

							mysql_format(mysql, query, sizeof query, "UPDATE phone_books SET number='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
							mysql_query(mysql, query, false);

							SendClientMessage(playerid, 0x99CC33FF, "Номер контакта изменен");
							ShowPlayerPhoneBook(playerid);
						}
					}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_CHANGE_NUM);
				}
				else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_ADD_CONTACT:
			{
				if(response)
				{
					new player_name[20 + 1];
					GetPVarString(playerid, "add_contact_name", player_name, sizeof(player_name));

					if(!(3 <= strlen(inputtext) <= 9) || strval(inputtext) < 1 || !IsNumeric(inputtext))
					{
						static fmt_str[64 + 1];

						format(fmt_str, sizeof fmt_str, "{FFFFFF}Введите номер телефона для контакта %s", player_name);
						Dialog(playerid, DIALOG_PHONE_BOOK_ADD_CONTACT, DIALOG_STYLE_INPUT, "{FFD83D}Добавление нового контакта", fmt_str, "Добавить", "Отмена");

						return 1;
					}
					AddPhoneBookContact(playerid, player_name, inputtext);
				}
				DeletePVar(playerid, "add_contact_name");
			}
			case DIALOG_REPLACE_TIRE:
			{
			    if(response)
				{
					new to_player = GetPVarInt(playerid, "to_player_s");
				    switch(listitem + 1)
				    {
				        case 1:
						{
						    SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHIN, 1, 5000);
						}
						case 2:
						{
						    SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHIN, 2, 5000);
						}
						case 3:
						{
						    SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHIN, 3, 5000);
						}
						case 4:
						{
						    SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHIN, 4, 5000);
						}
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_TEMP_JOB_FACTORY_TRUCKER:
			{
				if(response)
				{
					new job = GetPlayerTempJob(playerid);

					switch(job)
					{
						case TEMP_JOB_NONE:
						{
							new skin = GetTempJobInfo(TEMP_JOB_FACTORY_TRUCKER, TJ_SKIN)[GetPlayerSex(playerid)];

							ClearAnimations(playerid);
							SetPlayerSkin(playerid, skin);

							if(GetPlayerSex(playerid))
								SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HEAD, 18638, A_OBJECT_BONE_HEAD, 0.16, 0.02, 0.0, 0.0, 0.0, 0.0, 1.0, 1.1, 1.12, 0);

							SetPlayerJobLoadItems(playerid, 0);
							SetPlayerTempJob(playerid, TEMP_JOB_FACTORY_TRUCKER);
							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_NONE);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы начали работу в службе доставки завода");
							SendClientMessage(playerid, 0x66CC00FF, "* Для получения информации воспользуйтесь инструкцией рядом с Вами");

							SetPlayerData(playerid, P_IN_JOB, true);
						}
						case TEMP_JOB_FACTORY_TRUCKER:
						{
							EndPlayerJob(playerid);
						}
					}
				}
			}
			case DIALOG_TEMP_JOB_FACTORY:
			{
				if(response)
    			{
					new job = GetPlayerTempJob(playerid);

					switch(job)
					{
						case TEMP_JOB_NONE:
						{
							new skin = GetTempJobInfo(TEMP_JOB_FACTORY, TJ_SKIN)[GetPlayerSex(playerid)];

							ClearAnimations(playerid);
							SetPlayerSkin(playerid, skin);

							TogglePlayerFactoryCP(playerid, true);
							SetPlayerData(playerid, P_JOB_WAGE, 0);

							SetPlayerJobLoadItems(playerid, 0);
							SetPlayerTempJob(playerid, TEMP_JOB_FACTORY);

							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы начали работу в производственном цеху завода");
							SendClientMessage(playerid, 0x66CC00FF, "* Для получения информации воспользуйтесь инструкцией у входа в цех");

							DeletePVar(playerid, "factory_skill");
							DeletePVar(playerid, "factory_bad_prods");
							DeletePVar(playerid, "factory_take_metall");
						}
						case TEMP_JOB_FACTORY:
						{
							EndPlayerTempJob(playerid, TEMP_JOB_FACTORY);
						}
					}
				}
			}
			case DIALOG_TEMP_JOB_INKAS_START:
			{
				if(response)
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
					if(GetPlayerLevel(playerid) < 8) return SendClientMessage(playerid, -1, "* У вас должен быть минимум 8-й уровень для начала работы.");
					{
						TogglePlayerDynamicCP(playerid, help_info_CP, false);

						SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_INKAS, TJ_SKIN)[GetPlayerSex(playerid)]);

						SetPlayerTempJob(playerid, TEMP_JOB_INKAS);

						SendClientMessage(playerid, 0xCECECEFF, "* Вы начали работу инкассатора");
						SendClientMessage(playerid, 0xCECECEFF, "* Берите оружие, садитесь в автобомиль и отправляйтесь по меткам");
						SetPlayerData(playerid, P_IN_JOB, true);
					}
				}
			}
			case DIALOG_TEMP_JOB_LUMBERJACK_ST:
			{
				if(response)
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
					{
						SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_LUMBERJACK, TJ_SKIN)[GetPlayerSex(playerid)]);
						SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 326, A_OBJECT_BONE_RIGHT_HAND, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);

						SetPlayerJobLoadItems(playerid, 0);
						SetPlayerTempJob(playerid, TEMP_JOB_LUMBERJACK);

						SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LUMBERJACK_CHOP);
						SetPlayerLumberJackChopCP(playerid);

						SendClientMessage(playerid, 0xB0C4DEFF, "Подойдите к отмеченному дереву и срубите его, после отнесите на склад брёвен");
						EnablePlayerGPS(playerid, 37, 505.3781,-2376.7129,34.7819, "Склад отмечена на вашем GPS");
					}
				}
			}
			case DIALOG_TEMP_JOB_LUMBERJACK_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_LUMBERJACK);
				}
			}
			case DIALOG_TEMP_JOB_MINER_START:
			{
				if(!response) return 1;

				if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
				{
					SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_MINER, TJ_SKIN)[GetPlayerSex(playerid)]);
					//SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.03, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);

					SetPlayerJobLoadItems(playerid, 0);
					SetPlayerTempJob(playerid, TEMP_JOB_MINER);
					SetPVarInt(playerid, "miner_1",0);
					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);
					SetPlayerMinerJobLoadCP(playerid);
					SendClientMessage(playerid, 0xff9900FF, "Вы начали работу. Направляйтесь к лифту, чтобы спуститься под землю.");

					SetPlayerCheckpoint(playerid, -470.2869,2876.5969,1192.7656, 1.0);
					g_player_mine_cp[playerid] = 1;

				}
			}
			case DIALOG_TEMP_JOB_MINER_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_MINER);
					DisablePlayerCheckpoint(playerid);
					g_player_mine_cp[playerid] = 0;
					g_player_mine_status[playerid] = 0;
					g_player_mine_object[playerid] = INVALID_OBJECT_ID;
					g_player_mine_sphere[playerid] = 0;
					g_player_mine_rack[playerid] = 0;
					g_player_mine_ore[playerid] = -1;
				}
			}
			case DIALOG_TEMP_JOB_INKAS_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_INKAS);
					ResetWeapons(playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_FUEL_STATION_BUY_JERRICA:
			{
				if(!response) return true;

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 500000)) return SCM(playerid, COLOR_GREY, "* Недостаточно средств");

				GiveIteam(playerid, 1, 1, 1, 0);

				GivePlayerMoneyEx(playerid, -500000, "Покупка канистры на АЗС", false, true);

				SendClientMessage(playerid, 0x66CC00FF, "* Вы купили канистру с 15 литрами бензина");
				SendClientMessage(playerid, 0x3399FFFF, "* Чтобы заправить транспорт, подойдите к нему и нажмите ПКМ");
				SendClientMessage(playerid, 0xCECECEFF, "* Примечание: Вы не должны двигаться во время заправки. ПКМ - правая кнопка мышки");
			}
			case DIALOG_FUEL_STATION_PRICE_FUEL:
			{
			    new stationid = GetPVarInt(playerid, "ownablebiz_id");
			    if (stationid == -1)
			        return SendClientMessage(playerid, 0xCECECEFF, "* Ошибка: бизнес не найден.");

			    new sql_id = GetBusinessData(stationid, B_SQL_ID);
			    if (sql_id <= 0)
			        return SendClientMessage(playerid, 0xCECECEFF, "* Ошибка: неверный ID бизнеса.");

			    if (response)
			    {
			        if (!IsNumeric(inputtext))
			            return SendClientMessage(playerid, 0xCECECEFF, "* Укажите корректное число.");

			        new price = strval(inputtext);

			        if (price < 25000 || price > 500000)
			            return SendClientMessage(playerid, 0xCECECEFF, "* Цена должна быть от 25.000 до 500.000 рублей.");

			        SetBusinessData(stationid, B_PROD_PRICE, price);

			        static query[128];
			        format(query, sizeof query, "UPDATE business SET prod_price=%d WHERE id=%d LIMIT 1", price, sql_id);
			        mysql_tquery(mysql, query);

			        static msg[96];
			        format(msg, sizeof msg, "Теперь топливо на Вашей заправке будет продаваться по %d руб.", price);
			        SendClientMessage(playerid, 0x66CC00FF, msg);

			        UpdateBusinessLabel(stationid);
			    }

			    ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
				
			case DIALOG_FUEL_STATION_BUY_FUEL_PR:
			{
				new stationid = GetPVarInt(playerid, "ownablebiz_id");
				if(stationid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(2 <= price <= 10 && IsNumeric(inputtext))
						{
							static fmt_str[90];
							format(fmt_str, sizeof fmt_str, "Теперь топливо для Вашей заправки будет закупаться по %d руб за 1 литр", price);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);
						}
					}
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			
			// -----------------------------------------------------------------
			case DIALOG_JERRICAN_FILL_CAR:
			{
				new vehicleid = GetPVarInt(playerid, "jerrican_fill_car");
				new modelid = GetVehicleData(vehicleid, V_MODELID);
				DeletePVar(playerid, "jerrican_fill_car");
				
				if(modelid == 15126)
					return SendClientMessage(playerid, 0xCECECEFF, "* В транспортном средстве установлен электродвигатель, вы не сможете заправить его бензином.");

				if(modelid == 543)
					return SendClientMessage(playerid, 0xCECECEFF, "* В транспортном средстве установлен электродвигатель, вы не сможете заправить его бензином.");

				if(modelid == 15192)
					return SendClientMessage(playerid, 0xCECECEFF, "* В транспортном средстве установлен электродвигатель, вы не сможете заправить его бензином.");

				if(modelid == 15686)
					return SendClientMessage(playerid, 0xCECECEFF, "* В транспортном средстве установлен электродвигатель, вы не сможете заправить его бензином.");

			    if(modelid == 15104)
					return SendClientMessage(playerid, 0xCECECEFF, "* В транспортном средстве установлен электродвигатель, вы не сможете заправить его бензином.");

			    if(modelid == 15110)
					return SendClientMessage(playerid, 0xCECECEFF, "* В транспортном средстве установлен электродвигатель, вы не сможете заправить его бензином.");

				if(response && vehicleid)
				{
					new Float: x, Float: y, Float: z;
					GetVehiclePos(vehicleid, x, y, z);

					if(IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z))
					{
						if((GetVehicleData(vehicleid, V_FUEL) + 15.0) <= 100.0)
						{
							SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + 15.0);
							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);

							DeletePVar(playerid, "have_jerrican");

							RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
							SendClientMessage(playerid, 0x66CC00FF, "* Транспорт заправлен");
							
						 	//BattlePass_Completingtasks(playerid, 1, 9);
							//RemovePlayerItem(playerid, 311, 1);
						    GiveIteam(playerid, 1, 0,1,0);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* В бензобак этого транспорта столько не поместится");
					}
					else SendClientMessage(playerid, 0x999999FF, "* Вы находитесь слишком далеко от транспорта");
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_GARDEN:
			{ 
				if(!response) return 1;

				if(GetPlayerWeapon(playerid) != 6) return SCM(playerid, COLOR_GREY,"Для того чтобы посадить семена, требуется лопата в руке.");

				new idmap;
				new garden_id = GetPVarInt(playerid, "garden_id");
				new yamka_id = GetPVarInt(playerid, "yamka_id");
                if(GetGardenData(garden_id, G_IMPROVEMENTS) < 3) if(!IsPlayerInRangeOfPoint(playerid, 0.6, GetGardenData(garden_id, G_POS_X) + GardenGryadka_1[yamka_id][0], GetGardenData(garden_id, G_POS_Y) + GardenGryadka_1[yamka_id][1], GetGardenData(garden_id, G_POS_Z) + GardenGryadka_1[yamka_id][2] + 1)) return 1;
				if(GetGardenData(garden_id, G_IMPROVEMENTS) == 3) if(!IsPlayerInRangeOfPoint(playerid, 0.6, GetGardenData(garden_id, G_POS_X) + GardenGryadka_2[yamka_id][0], GetGardenData(garden_id, G_POS_Y) + GardenGryadka_2[yamka_id][1], GetGardenData(garden_id, G_POS_Z) + GardenGryadka_2[yamka_id][2] + 1)) return 1;
				if(GetGardenData(garden_id, G_IMPROVEMENTS) == 4) if(!IsPlayerInRangeOfPoint(playerid, 0.6, GetGardenData(garden_id, G_POS_X) + GardenGryadka_3[yamka_id][0], GetGardenData(garden_id, G_POS_Y) + GardenGryadka_3[yamka_id][1], GetGardenData(garden_id, G_POS_Z) + GardenGryadka_3[yamka_id][2] + 1)) return 1;

				switch(listitem)
				{
					case 0:
					{
						Dialog
						(
							playerid, DIALOG_GARDEN, DIALOG_STYLE_LIST,
							"Какое растение вы хотите посадить?",
							"Название\tВремя роста\tИнтервал полива\n\
							{FFFFFF}Помидоры\t{"#cGold"}10 мин.\t4 мин.\n\
							{FFFFFF}Огурцы\t{"#cGold"}20 мин.\t4 мин.\n\
							{FFFFFF}Марихуана\t{"#cGold"}30 мин.\t4 мин.\n\
							{FFFFFF}Картофель\t{"#cGold"}10 мин.\t4 мин.\n\
							{FFFFFF}Свёкла\t{"#cGold"}10 мин.\t4 мин.\n\
							{FFFFFF}Перец\t{"#cGold"}10 мин.\t4 мин.\n\
							{FFFFFF}Баклажан\t{"#cGold"}10 мин.\t4 мин.\n\
							{FFFFFF}Капуста\t{"#cGold"}10 мин.\t4 мин.\n\
							{FFFFFF}Морковь\t{"#cGold"}10 мин.\t4 мин.",
							"Готово", "Закрыть"
						);
						return 1;
					}
					case 1: // Помидоры
					{
						if(GetIteam(playerid, 173) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 173, 0, 5, 0);
						idmap = 10936;
					}
					case 2: // Огурцы
					{
						if(GetIteam(playerid, 174) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 174, 0, 5, 0);
						idmap = 10935;
					}
					case 3: // Марихуана
					{
						if(GetIteam(playerid, 172) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 172, 0, 5, 0);
						idmap = 10937;
					}
					case 4: // Картофель
					{
						if(GetIteamIndx(playerid, 336, 0) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 336, 0, 5, 0);
						idmap = 16553;
					}
					case 5: // Свёкла
					{
						if(GetIteamIndx(playerid, 336, 1) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 336, 0, 5, 1);
						idmap = 16550;
					}
					case 6: // Перец
					{
						if(GetIteamIndx(playerid, 336, 2) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 336, 0, 5, 2);
						idmap = 16551;
					}
					case 7: // Баклажан
					{
						if(GetIteamIndx(playerid, 336, 3) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 336, 0, 5, 3);
						idmap = 16552;
					}
					case 8: // Капуста
					{
						if(GetIteamIndx(playerid, 336, 4) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 336, 0, 5, 4);
						idmap = 16549;
					}
					case 9: // морковь
					{
						if(GetIteamIndx(playerid, 336, 5) < 5) return SCM(playerid, 0xCECECEFF, "* У вас недостаточно семян для посадки. (минимум 5 семян)");
						GiveIteam(playerid, 336, 0, 5, 5);
						idmap = 16548;
					}
				}
				G_TYPE_YAM[garden_id][yamka_id] = listitem;
				if(GetGardenData(garden_id, G_IMPROVEMENTS) < 3) gardendyamka[garden_id][yamka_id] = CreateObject(idmap, GetGardenData(garden_id, G_POS_X) + GardenGryadka_1[yamka_id][0], GetGardenData(garden_id, G_POS_Y) + GardenGryadka_1[yamka_id][1], GetGardenData(garden_id, G_POS_Z) + GardenGryadka_1[yamka_id][2] - 1,   0.00000, 0.00000, 0.0000);
				if(GetGardenData(garden_id, G_IMPROVEMENTS) == 3) gardendyamka[garden_id][yamka_id] = CreateObject(idmap, GetGardenData(garden_id, G_POS_X) + GardenGryadka_2[yamka_id][0], GetGardenData(garden_id, G_POS_Y) + GardenGryadka_2[yamka_id][1], GetGardenData(garden_id, G_POS_Z) + GardenGryadka_2[yamka_id][2] - 1,   0.00000, 0.00000, 0.0000);
				if(GetGardenData(garden_id, G_IMPROVEMENTS) == 4) gardendyamka[garden_id][yamka_id] = CreateObject(idmap, GetGardenData(garden_id, G_POS_X) + GardenGryadka_3[yamka_id][0], GetGardenData(garden_id, G_POS_Y) + GardenGryadka_3[yamka_id][1], GetGardenData(garden_id, G_POS_Z) + GardenGryadka_3[yamka_id][2] - 1,   0.00000, 0.00000, 0.0000);

				G_STATUS_YAM[garden_id][yamka_id] = 1;
				ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 2.0, 0, 0, 0, 0, 0, 0);

				static fmt_text[148];
				format(fmt_text, sizeof fmt_text,"{FF8800}%s\n{FFFFFF}Прогресс: {FF8800}0.0%\n{FFFFFF}Требуется полив",garden_name[G_TYPE_YAM[garden_id][yamka_id]-1]);
				UpdateDynamic3DTextLabelText(gardendyamkalab[garden_id][yamka_id], 0xFFFF00FF, fmt_text);
				return 1;
			}
			case DIALOG_GARDEN_BUY:
			{
				if (response)
				{
					new garden = GetPVarInt(playerid, "buy_biz_id");

					if (IsPlayerInRangeOfPoint(playerid, 7.0, GetGardenData(garden, G_POS_X), GetGardenData(garden, G_POS_Y), GetGardenData(garden, G_POS_Z)))
					{
						if (!IsGardenOwned(garden))
						{
							if (GetILPlayerInt(GetPlayerMoneyEx(playerid), GetGardenData(garden, G_PRICE)))
							{
								if (GetPlayerOwnableGarden(playerid) + 1 > GetPlayerGardenSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "Вы уже имеете максимально количество огородов.");

								if (GetPlayerGardens(playerid) > 4) return SendClientMessage(playerid, 0xFFDF87FF, "У вас максимальное кол-во огородов.");

								if (CanPlayerBuyProperty(playerid))
								{
									ShowPropertyCaptcha(playerid, 3, garden);
								}
							}
							else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого огорода");
						}
						else SendClientMessage(playerid, 0xFFDF87FF, "Огород уже куплен другим игроком");

					}
				}
				DeletePVar(playerid, "buy_biz_id");
			}
			case DIALOG_BIZ_BUY:
			{
				if (response)
				{
					new businessid = GetPVarInt(playerid, "buy_biz_id");
					if (IsPlayerInRangeOfPoint(playerid, 7.0, GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z)))
					{
						if (!IsBusinessOwned(businessid))
						{
							if (GetILPlayerInt(GetPlayerMoneyEx(playerid), GetBusinessData(businessid, B_PRICE)))
							{
								if (CanPlayerBuyProperty(playerid))
								{
									ShowPropertyCaptcha(playerid, 2, businessid);
								}
							}
							else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого бизнеса");
						}
						else
						{
							new fmt_str[64];

							format(fmt_str, sizeof fmt_str, "Этот бизнес уже куплен. Владелец: %s", GetBusinessData(businessid, B_OWNER_NAME));
							SendClientMessage(playerid, 0xCECECEFF, fmt_str);
						}
					}
				}
				DeletePVar(playerid, "buy_biz_id");
			}
			case DIALOG_BIZ_INFO:
			{
				if(!response) return 1;

				ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
			}
			case DIALOG_BIZ_PARAMS:
			{
				if(!response) return callcmd::business(playerid, "");

				ShowPlayerBusinessDialog(playerid, listitem + 1);
				
			}
			case DIALOG_BIZ_ARENDA:
			{
			    if(response)
			    {
			        MoralPacket_2(playerid, s_CefInterface, t_CefShow,"Select", "[\"OnPlayerEventRentCar\"]");
			        MoralPacket_1(playerid, s_CefInterface, t_CefHide, /*"Business"*/ "Interactions");
			        TogglePlayerControllable(playerid, false);

			        arendavibor[playerid] = 1;
			        new biz_id = GetPVarInt(playerid, "arenda_id");
					for(new i = 0; i < MAX_VEHICLES; i++)
					{
						if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_RENT_CAR)
						{
						    new index = GetVehicleData(i, V_ACTION_ID);
						    if(GetRentCarData(index, R_RENT_OWNER) == -1)
						    {
								SetPVarInt(playerid, "vehid_arenda", i);
								new Float:X,Float:Y,Float:Z;
								GetVehiclePos(i, X,Y,Z);
								SetPlayerVirtualWorld(playerid, biz_id);
								SetVehicleVirtualWorld(i, biz_id);
								SetPlayerCameraPos(playerid, X+ 7, Y, Z+3);
								SetPlayerCameraLookAt(playerid, X, Y, Z+1, 2);
								return 1;
							}
						 }
					}
			    }
			}
			case DIALOG_BIZ_ARENDA_CAR:
			{
				if(response)
				{
				    new businessid = GetPVarInt(playerid, "ownablebiz_id");
					switch(listitem + 1)
					{
						case 1:
						{
							static query[148],
								Cache: result;

							mysql_format(mysql, query, sizeof query, "SELECT * FROM arenda_cars WHERE owner_id='%d'", businessid);
							result = mysql_query(mysql, query, true);

							new rows = cache_num_rows();

							if(!rows)
								SendClientMessage(playerid, 0x999999FF, "* У Вашей аренды авто нет транспорта");

							else
							{
								string_dialog[0] = EOS;
								for(new i = 0; i < rows; i ++)
								{
								    new vehicleid = cache_get_field_content_int(i, "vehicleid");
								    new Float: iznos = cache_get_field_content_float(i, "iznos");
								    new model_id = cache_get_field_content_int(i, "model_id");
								    new price = cache_get_field_content_int(i, "price");

									format(query, sizeof query, "{FFFFFF}%d.  %s (ID: %d)<t>{FFFFFF}Аренда: {6495ED}%d рублей{FFFFFF}<t>Износ: {6495ED}%d% <n>", i+1, GetVehicleInfo(model_id , VI_NAME), vehicleid, price, floatround(iznos));
									strcat(string_dialog, query);
									SetPlayerListitemValue(playerid, i, vehicleid);

								}

				   				Dialog
								(
									playerid, DIALOG_BIZ_CAR_LIST, DIALOG_STYLE_LIST,
									"Транспорт",
									string_dialog,
									"Выбрать", "Назад"
								);
							}
							cache_delete(result);
						}
						case 2:
						{
			   				if((GetBusinessCars(businessid) + 1) > 8)
								return SendClientMessage(playerid, 0x3399FFFF, "* У вашей аренды авто максимальное количество автомобилей!");
						    new inter, world, Float:X, Float:Y, Float:Z, Float:FA;
							GetPlayerPos(playerid, X, Y, Z);
							GetPlayerFacingAngle(playerid, FA);
							inter = GetPlayerInterior(playerid);
							world = GetPlayerVirtualWorld(playerid);

							SetPVarFloat(playerid, "pos_x", X);
							SetPVarFloat(playerid, "pos_y", Y);
							SetPVarFloat(playerid, "pos_z", Z);
							SetPVarFloat(playerid, "angle", FA);
							SetPVarInt(playerid, "player_int", inter);
							SetPVarInt(playerid, "player_world", world);

							SetPlayerVirtualWorld(playerid, playerid + 1);
							SetPlayerPosEx(playerid, 1853.8215,2813.3525,20.1436,270.9554, 0, _, false);
							TogglePlayerControllable(playerid, false);

							SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(400, 1847.1146,2819.2698,20.5752,321.0539, 1, 1, 0));

							SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
							LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 0);

                            SetPlayerInterior(playerid, 0);

							SetPlayerCameraPos(playerid, 1856.1144, 2822.7991, 22.2357);
							SetPlayerCameraLookAt(playerid, 1847.2103, 2819.2700, 20.5730);

							SetPVarInt(playerid, "STONKScar", 1);
							LoadPlayerCarsShop(playerid);
							SetPVarInt(playerid, "arendacar_buy", 1);
						}
					}
				}
				else
				{
 					ShowPlayerBusinessDialog(playerid, 0);
				}
			}
			case DIALOG_BIZ_ARENDA_CARS:
			{
			    if(response)
			    {
			        new businessid = GetPVarInt(playerid, "arenda_id");
			        new vehicleid = GetPVarInt(playerid, "vehid_arenda");
			        new index = GetVehicleData(vehicleid, V_ACTION_ID);
			        if(GetPlayerData(playerid, P_RENT_CAR) != INVALID_VEHICLE_ID)
			        {
						SendClientMessage(playerid,COLOR_WHITE,"У вас уже есть арендованное авто. /unrent чтобы вернуть его.");
						return 1;
			        }
					if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), GetRentCarData(index, R_PRICE)))
					{
						SendClientMessage(playerid,COLOR_WHITE,"У вас недостаточно средств для аренды транспорта.");
						return 1;
					}

					if(GetBusinessData(businessid, B_PRODS) >= 1)
					{
						new carprice = GetRentCarData(index, R_PRICE);

						AddBusinessProfit(playerid, businessid, carprice, 1);
					}
					else
					{
						SendClientMessage(playerid,COLOR_WHITE,"В бизнесе недостаточно продуктов. Аренда авто закрыта.");
						return 1;
					}
			        SetPlayerVirtualWorld(playerid, 0);
			        SetPlayerInterior(playerid, 0);
					SetVehicleVirtualWorld(vehicleid, 0);
                    PutPlayerInVehicle(playerid, vehicleid, 0);
					TogglePlayerControllable(playerid, true);
					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Select");
					SetCameraBehindPlayer(playerid);
					static string[144];
					format(string, sizeof(string), "{66CC00}Вы арендовали транспорт для временного использования");
					SendClientMessage(playerid,COLOR_WHITE,string);
					SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {3CB371}/lock 2{FFFFFF} для открытия и закрытия дверей");
					SendClientMessage(playerid, 0xFFFFFFFF, "Чтобы разорвать договор аренды введите {3CB371}/unrent");

					GivePlayerMoneyEx(playerid, -GetRentCarData(index, R_PRICE), "Аренда авто");

					SetPlayerData(playerid, P_RENT_CAR, vehicleid);
					SetRentCarData(index, R_RENT_OWNER, playerid);

			    }
			}
			case DIALOG_BIZ_CAR_ARENDA_1:
			{
			    if(response)
			    {
			        new price = strval(inputtext);
			    	if(!(1 <= price <= 1000000)) return MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('GameText').add('[2,\"~r~ Цена аренды от 1 до 1.000.000 рублей\",5000,0,-1,1]')");
			    	new vehicleid = GetPVarInt(playerid, "vehicleid");
			    	new index = GetVehicleData(vehicleid, V_ACTION_ID);
			    	SetRentCarData(index, R_PRICE, price);
					static query[144];
					mysql_format(mysql, query, sizeof query, "UPDATE arenda_cars SET price=%d WHERE id=%d", price, GetRentCarData(index, R_SQL_ID));
					mysql_query(mysql, query, false);
					SendClientMessage(playerid, 0x999999FF, "* Вы успешно изменили цену аренды авто!");

			    }
			}
			case DIALOG_BIZ_ARENDA_CAR_SELECT:
			{
			    new businessid = GetPlayerData(playerid, P_BUSINESS);
			    if(response)
			    {
					switch(listitem + 1)
					{
						case 1:
						{
						    Dialog(playerid, DIALOG_BIZ_CAR_ARENDA_1, DIALOG_STYLE_INPUT, "Настройка аренды авто", "{FFFFFF}Введите цену аренды?", "Готово", "Назад");
						}
						case 2:
						{
						    new vehicleid = GetPVarInt(playerid, "vehicleid");
							static fmt_str[256];
                            new model_id = GetVehicleData(vehicleid, V_MODELID);
							new price = GetVehicleInfo(model_id, VI_PRICE);
							new percent = price * 45 / 100;

							format
							(
								fmt_str, sizeof fmt_str,
								"Модель:\t%s (№%d)\n"\
								"Стоимость:\t%d руб\n\n"\
								"Вы уверены что хотите продать транспорт?\n"\
								"На Ваш банковский счет будет начислено %d руб\n\n"\
								"Если Вы хотите продать его другому игроку,\n"\
								"используйте команду /sellmycar",
								GetVehicleName(vehicleid),
								model_id,
								price,
								price - percent
							);
							Dialog(playerid, DIALOG_BIZ_CAR_SELL, DIALOG_STYLE_MSGBOX, "Продажа транспорта с аренды атво", fmt_str, "Да", "Нет");
						}
					}
			    }
			    else
			    {
					static query[148],
						Cache: result;

					mysql_format(mysql, query, sizeof query, "SELECT * FROM arenda_cars WHERE owner_id='%d'", businessid);
					result = mysql_query(mysql, query, true);

					new rows = cache_num_rows();

					if(!rows)
						SendClientMessage(playerid, 0x999999FF, "* У Вашей аренды авто нет транспорта");

					else
					{
						string_dialog[0] = EOS;
						for(new i = 0; i < rows; i ++)
						{
						    new vehicleid = cache_get_field_content_int(i, "vehicleid");
						    new Float: iznos = cache_get_field_content_float(i, "iznos");
						    new model_id = cache_get_field_content_int(i, "model_id");
						    new price = cache_get_field_content_int(i, "price");

							format(query, sizeof query, "{FFFFFF}%d.  %s (ID: %d)<t>{FFFFFF}Аренда: {6495ED}%d рублей{FFFFFF}<t>Износ: {6495ED}%d% <n>", i+1, GetVehicleInfo(model_id , VI_NAME), vehicleid, price, floatround(iznos));
							strcat(string_dialog, query);
							SetPlayerListitemValue(playerid, i, vehicleid);

						}

		   				Dialog
						(
							playerid, DIALOG_BIZ_CAR_LIST, DIALOG_STYLE_LIST,
							"Транспорт",
							string_dialog,
							"Выбрать", "Назад"
						);
					}
					cache_delete(result);
			    }
			}
			case DIALOG_BIZ_CAR_LIST:
			{
			    if(response)
				{
				    new vehicleid = GetPlayerListitemValue(playerid, listitem);
				    SetPVarInt(playerid, "vehicleid", vehicleid);
				    new index = GetVehicleData(vehicleid, V_ACTION_ID);

				    static msg[244];
				    format(msg, sizeof msg, "1. Аренда {6495ED}%d руб.<n>{FFFFFF}2. Продать",
					GetRentCarData(index, R_PRICE));
					Dialog
					(
						playerid, DIALOG_BIZ_ARENDA_CAR_SELECT, DIALOG_STYLE_LIST,
						"{FFFFFF}Транспорт",
						msg,
						"Выбрать", "Назад"
					);
				}
				else
				{
				 	Dialog
					(
						playerid, DIALOG_BIZ_ARENDA_CAR, DIALOG_STYLE_LIST,
						"{FFFFFF}Транспорт",
						"1. Посмотреть\n"\
						"2. Купить",
						"Выбрать", "Назад"
					);
				}
			}
			case DIALOG_BIZ_ARENDA_PRICE:
			{
				new businessid = GetPlayerData(playerid, P_BUSINESS);
				if(businessid != -1)
				{
					if(response)
					{

						if(strlen(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, 0xFF6600FF, "* Укажите корректную цену продажи");
						if(strlen(inputtext) > 9) return SendClientMessage(playerid, 0xFF6600FF, "* Не больше 9-ти символов!");
						new sell_price = strval(inputtext);
						if(sell_price < 3000 || sell_price > 50000) return SendClientMessage(playerid, 0xFF6600FF, "* Цена аренды от 3.000 рублей до 50.000 рублей");

						SetBusinessData(businessid, B_ARENDA_PRICE, sell_price);
						static fmt_str[144];
						format(fmt_str, sizeof fmt_str, "UPDATE business SET arenda_price=%d WHERE id=%d LIMIT 1",  GetBusinessData(businessid, B_ARENDA_PRICE) , GetBusinessData(businessid, B_SQL_ID));
						mysql_query(mysql, fmt_str, false);

						format(fmt_str, sizeof fmt_str,
						"Вы успешно поставили цену на место на б/у рынке за %s рублей",
						formatInt(sell_price));
						SendClientMessage(playerid, -1, fmt_str);

					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ENTER_PRICE:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(strlen(inputtext))
						{
							if((0 <= price <= 1000000) && IsNumeric(inputtext))
							{
								static query[64 + 1];
								SetBusinessData(businessid, B_ENTER_PRICE, price);

								format(query, sizeof query, "UPDATE business SET enter_price=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_ENTER_PRICE), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								UpdateBusinessLabel(businessid);
								SendClientMessage(playerid, 0x66CC00FF, "* Цена за вход в бизнес изменена");

								return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Предел цены от 0 до 1000000 рублей");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Введите цену за вход в Ваш бизнес");

						ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_ENTER_PRICE);
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_PROD_PRICE:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						if(GetBusinessData(businessid, B_TYPE) == 43)
						{
							new price = strval(inputtext);
							if(strlen(inputtext) && IsNumeric(inputtext))
							{
								if(5000 <= price <= 50000)
								{
									static query[64 + 1];
									SetBusinessData(businessid, B_PROD_PRICE, price);

									format(query, sizeof query, "UPDATE business SET prod_price=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_SQL_ID));
									mysql_query(mysql, query, false);
									UpdateBusinessLabel(businessid);

									SendClientMessage(playerid, 0x66CC00FF, "* Стоимость продукта изменена");
									return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* Укажите стоимость от 5000 до 50000 рублей");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Введите стоимость продукта");

							ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_PRICE);
						}
						else
						{
							new price = strval(inputtext);
							if(strlen(inputtext) && IsNumeric(inputtext))
							{
								if(25 <= price <= 2000)
								{
									static query[64 + 1];
									SetBusinessData(businessid, B_PROD_PRICE, price);

									format(query, sizeof query, "UPDATE business SET prod_price=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_SQL_ID));
									mysql_query(mysql, query, false);
									UpdateBusinessLabel(businessid);

									SendClientMessage(playerid, 0x66CC00FF, "* Стоимость продукта изменена");
									return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* Укажите стоимость от 25 до 2000 рублей");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Введите стоимость продукта");

							ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_PRICE);
						}
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ORDER_PRODS:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						if(GetBusinessData(businessid, B_ORDER_ID) != -1)
						{
							SendClientMessage(playerid, 0x999999FF, "* Заказ для Вашего предприятии уже оформлен");
							return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
						}

						if(GetBusinessData(businessid, B_PROD_PRICE) > 0)
						{
							new order_prods = strval(inputtext);
							new prod_price = GetBusinessData(businessid, B_PROD_PRICE);
							new price = order_prods * prod_price;

							if(order_prods > 0 && IsNumeric(inputtext))
							{
								static fmt_str[256];

								new free_prods_slots = GetBusinessMaxProd(businessid) - GetBusinessData(businessid, B_PRODS);

								if(free_prods_slots > 1000)
									free_prods_slots = 1000;

								if(order_prods <= free_prods_slots)
								{
									if(GetILPlayerInt(GetBusinessData(businessid, B_BALANCE), price))
									{
										new order_id = CreateOrder(ORDER_TYPE_BUSINESS, businessid, order_prods, prod_price);
										if(order_id != -1)
										{
											
											format(g_business[businessid][B_BALANCE], 21, "%s", SetILPlayerInt(playerid, g_business[businessid][B_BALANCE], -price));
											AddBusinessData(businessid, B_PRODS, +, order_prods);

											//format(fmt_str, sizeof fmt_str, "~w~business bank~n~~r~-%d rub", price);
											//CefGameTextForPlayer(playerid, fmt_str, 4000, 1);

											format(fmt_str, sizeof fmt_str, "UPDATE business SET balance=%s,products=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_PRODS) , GetBusinessData(businessid, B_SQL_ID));
											mysql_query(mysql, fmt_str, false);

											new year, month, day;
											timestamp_to_date(GetOrderData(order_id, O_TIME), year, month, day);

											format
											(
												fmt_str, sizeof fmt_str,
												"{FFFFFF}Параметры заказа:\n\n"\
												"Количество продуктов:\t\t%d шт.\n"\
												"Стоимость 1 продутка:\t\t%d руб\n"\
												"Общая стоимость заказа:\t\t%d руб\n"\
												"Дата оформления заказа:\t\t%02d-%02d-%d\n\n"\
												"Данные были переданы службе развозчиков продуктов\n"\
												"Ожидайте выполнения Вашего заказа",
												order_prods,
												prod_price,
												price,
												day, month, year
											);
											Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{99CC00}Заказ оформлен", fmt_str, "Закрыть", "");
										}
										else SendClientMessage(playerid, 0x999999FF, "* В данный момент Вы не можете оформить заказ");

										return 1;
									}
									else
									{
										format(fmt_str, sizeof fmt_str, "Чтобы оплатить заказ необходимо иметь %d руб на счету бизнеса", price);
										SendClientMessage(playerid, 0xFF6600FF, fmt_str);
									}
								}
								else
								{
									format(fmt_str, sizeof fmt_str, "Вы не можете заказать более %d продуктов", free_prods_slots);
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}
							}
						}
						else
						{
							SendClientMessage(playerid, 0xFF6600FF, "* Перед тем как оформить заказ, установите стоимость продукта");
							return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_PRICE);
						}
						ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_ORDER);
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ORDER_CANCEL:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						new order_id = GetBusinessData(businessid, B_ORDER_ID);
						if(order_id != -1 && GetOrderData(order_id, O_SQL_ID) > 0)
						{
							if(!GetOrderData(order_id, O_USED))
							{
								static fmt_str[128];

								DeleteOrder(order_id);

								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Вы отменили заказ продуктов"
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF9900}Отмена заказа", fmt_str, "Закрыть", "");

								return 1;
							}
							else SendClientMessage(playerid, 0xFF6600FF, "* Ваш заказ выполняется, его нельзя отменить");
						}
					}
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ELECT:
			{
				if(!response) 
					return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);

				new businessid = GetPVarInt(playerid, "ownablebiz_id"),
					b = businessid,
					type;

				if(businessid != -1)
				{

					if(b == 3 || b == 4 || b == 5 || b == 9 || b == 20 || b == 22 || b == 23 || b == 24 || b == 25 || b == 26 || b == 28 || b == 29 || b == 35 || b == 41 || b == 42 || b == 53 || b == 56 || b == 59 ||  b == 60 ||  b == 61 ||  b == 62 ||  b == 63 ||  b == 64 ||  b == 65 ||  b == 68 || b == 69 || b == 70 || b == 71 || b == 72 || b == 73 || b == 74 || b == 75 || b == 78 || b == 79 || b == 84 || b == 85 || b == 87 || b == 88 || b == 90 || b == 91 || b == 92)
						type = 1;
					if(b == 1 || b == 2 || b == 6 || b == 7 || b == 11 || b == 12 || b == 14 || b == 18 || b == 30 || b == 31 || b == 36 || b == 37 || b == 39 || b == 40 || b == 43 || b == 44 || b == 54 || b == 55 || b == 57 ||  b == 58 ||  b == 67 ||  b == 86 ||  b == 89)
						type = 5;
					else
						type = 3;

					if(GetBusinessData(businessid, B_ELECTRICITY) == type + listitem)
						return SCM(playerid, 0xafdafcFF, "Вы уже подключены к данной электростанции");

					else if(GetBusinessData(businessid, B_ELECTRICITY) != 0)
					{
						for(new i; i < g_business_loaded; i ++)
						{
							if(GetBusinessData(i, B_TYPE) != 36) continue;
							if(GetBusinessData(i, B_ELECTRICITY) != GetBusinessData(businessid, B_ELECTRICITY)) continue;

							AddBusinessData(i, B_TYPEWETRIKI, -, 1);

							static query[148];
							mysql_format(mysql, query, sizeof query, "UPDATE business SET `typewetriki`=%d WHERE `id`=%d LIMIT 1", GetBusinessData(i, B_TYPEWETRIKI), GetBusinessData(i, B_SQL_ID));
							mysql_query(mysql, query, false);
						}
					}

					for(new i; i < g_business_loaded; i ++)
					{
						if(GetBusinessData(i, B_TYPE) != 36) continue;
						if(GetBusinessData(i, B_ELECTRICITY) != type + listitem) continue;

						AddBusinessData(i, B_TYPEWETRIKI, +, 1);

						static query[148];
						mysql_format(mysql, query, sizeof query, "UPDATE business SET `typewetriki`=%d WHERE `id`=%d LIMIT 1", GetBusinessData(i, B_TYPEWETRIKI), GetBusinessData(i, B_SQL_ID));
						mysql_query(mysql, query, false);
					}

					SetBusinessData(businessid, B_ELECTRICITY, type + listitem);

					SendClientMessage(playerid, 0xafdafcFF, "Вы успешно поменяли доставщика {FFFFFF}энергии!");
					GameText(playerid, "~g~Успешно", 2000, 2);

					static query[148];
					mysql_format(mysql, query, sizeof query, "UPDATE business SET `electricity`=%d WHERE `id`=%d LIMIT 1", type + listitem, GetBusinessData(businessid, B_SQL_ID));
					mysql_query(mysql, query, false);
				}
			}

			case DIALOG_BIZ_IMPROVEMENT:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_business_improvements - 1)
						{
							new i_level = GetBusinessData(businessid, B_IMPROVEMENTS);
							new i_price = g_business_improvements[listitem][I_PRICE];

							if(i_level < listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "* Этот уровень улучшений пока недоступен");
							}
							else if(i_level > listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "* Вы уже купили этот уровень улучшений");
							}
							else if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), i_price))
							{
								static fmt_str[64];

								format(fmt_str, sizeof fmt_str, "Для покупки %d уровня улучшений необходимо %d рублей", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
							else
							{
								static fmt_str[128];

								format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a, business b SET a.money=%s, b.improvements=%d WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), -i_price), i_level + 1, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									new cur_max_prods = GetBusinessMaxProd(businessid);
									GivePlayerMoneyEx(playerid, -i_price, "Покупка улучшений для Бизнеса", false, true);

									format(fmt_str, sizeof fmt_str, "Вы улучшили свой бизнес до {FFCD00}%s {3399FF}уровня", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);

									AddBusinessData(businessid, B_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1:
										{
											format(fmt_str, sizeof fmt_str, "Количество слотов для продуктов увеличено с %d до %d", cur_max_prods, GetBusinessMaxProd(businessid));
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);

											SendClientMessage(playerid, 0x999999FF, "* Теперь можно намного реже пополнять их запас");
										}
										case 2:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* Теперь ваши клиенты смогут пользоваться услугами медпункта на территории бизнеса");
											SendClientMessage(playerid, 0x999999FF, "* Доходы от этого будут перечисляться на баланс предприятия");

											BusinessHealthPickupInit(businessid);
										}
										case 3:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* Благодаря пониженному налогу, вы будете платить за аренду помещения в 2 раза меньше");
											SendClientMessage(playerid, 0x999999FF, "* Благодаря этому, вы сможете получать большую прибыль");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* Теперь ваши клиенты будут слышать звук при входе в бизнес");
											SendClientMessage(playerid, 0x999999FF, "* Вы также можете поменять или выключить его командой {FF9900}/bizmusic");
										}
										case 5:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* В Вашем бизнесе был оборудован дополнительный склад продуктов повышенной вместимости");

											format(fmt_str, sizeof fmt_str, "Количество слотов для продуктов увеличено с %d до %d", cur_max_prods, GetBusinessMaxProd(businessid));
											SendClientMessage(playerid, 0x999999FF, fmt_str);
										}
										case 6:
										{
											format(fmt_str, sizeof fmt_str, "INSERT INTO business_gps (bid,time) VALUES (%d,%d)", businessid, gettime());
											mysql_query(mysql, fmt_str, false);

											g_business_gps_init = false;

											SendClientMessage(playerid, 0x66CC00FF, "* Теперь Ваш бизнес можно будет найти в списке бизнесов {FF9900}(/gps > Бизнес)");
											SendClientMessage(playerid, 0x999999FF, "* Это позволит привлечь дополнительных клиентов, тем самым повысить доходы предприятия");
										}
									}
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 23)");
							}
						}
					}
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_MANAGER:
			{
			    new businessid = GetPlayerListitemValue(playerid, listitem);
			    SetPVarInt(playerid, "ownablebiz_id", businessid);
			    new to_player = GetPVarInt(playerid, "manager_to_player");
			    SendPlayerOffer(playerid, to_player, OFFER_TYPE_BUSINESS_MANAGER, businessid);
			}
			case DIALOG_BIZ_SELL_MY_BIZ:
			{
			    new businessid = GetPlayerListitemValue(playerid, listitem) + 1;
			    SetPVarInt(playerid, "ownablebiz_id", businessid);
			    Dialog
				(
					playerid, DIALOG_BIZ_SELL_MY_BIZ2, DIALOG_STYLE_MSGBOX,
					"{FFCD00}Продажа бизнеса",
					"{FFFFFF}Вы уверены что хотите продать свой бизнес?",
					"Да", "Нет"
				);
			}
			case DIALOG_BIZ_SELL_MY_BIZ2:
			{
			    new businessid = GetPVarInt(playerid, "ownablebiz_id");
			    new to_player = GetPVarInt(playerid, "sellmybiz_to_player");
			    new price = GetPVarInt(playerid, "sellmybiz_money");

			    new Float: b_pos_x = GetBusinessData(businessid, B_POS_X);
				new Float: b_pos_y = GetBusinessData(businessid, B_POS_Y);
				new Float: b_pos_z = GetBusinessData(businessid, B_POS_Z);

				if(!(IsPlayerInRangeOfPoint(playerid, 7.0, b_pos_x, b_pos_y, b_pos_z) && IsPlayerInRangeOfPoint(to_player, 7.0, b_pos_x, b_pos_y, b_pos_z)))
					return SendClientMessage(playerid, 0xFF6600FF, "* Вы и покупатель должны находиться рядом с бизнесом который хотите продать");

			    SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_BUSINESS, businessid, price);
			}
			case DIALOG_BIZ_SELL:
			{
				new businessid = GetPVarInt(playerid, "ownablebiz_id");
				if(businessid != -1)
				{
					if(response)
					{
						if(GetBusinessData(businessid, B_ORDER_ID) != -1)
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF6600}Продажа бизнеса",
								"{FFFFFF}Перед тем как продать бизнес государству\n"\
								"заказ продуктов нужно {FF3333}отменить",
								"Закрыть", ""
							);
						}
						else //SellBusiness(playerid);
						{
							new biz_price = GetBusinessData(businessid, B_PRICE);
							new biz_percent = biz_price / 100 * 60;
							new biz_improvemnts_price = BusinessImprovementsPrice(businessid);

							if(biz_improvemnts_price)
								biz_improvemnts_price = biz_improvemnts_price / 100 * 35;

							STRING_GLOBAL[0] = EOS;
							new return_money = (biz_price - biz_percent) + biz_improvemnts_price;

							SetBusinessData(businessid, B_OWNER_ID, 	0);

							format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), return_money));

							BankLog(playerid, return_money, "Продажа бизнеса");

							SetBusinessData(businessid, B_IMPROVEMENTS, 	0);

							SetBusinessData(businessid, B_PRODS, 			0);
							SetBusinessData(businessid, B_PROD_PRICE,		0);

							format(g_business[businessid][B_BALANCE], 21, "0");

							SetBusinessData(businessid, B_RENT_DATE,		0);
							SetBusinessData(businessid, B_ENTER_MUSIC,		0);
							SetBusinessData(businessid, B_LOCK_STATUS,	false);

							BusinessHealthPickupInit(businessid);

							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE PlayersMorallwens a,business b SET a.bank=%s,b.owner_id=0,b.products=0,b.prod_price=0,b.lock=0 WHERE a.id=%d AND b.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
							mysql_query(mysql, STRING_GLOBAL, false);

							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "DELETE FROM business_gps WHERE bid=%d", businessid);
							mysql_query(mysql, STRING_GLOBAL, false);

							g_business_gps_init = false;

							GivePlayerMoneyEx(playerid, 0, "Продажа бизнеса государству", false, false);
							CallLocalFunction("UpdateBusinessLabel", "i", businessid);

							SendClientMessage(playerid, 0x66CC00FF, "Вы продали свой бизнес!");

							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Налог за продажу бизнеса составил 60 процентов от его стоимости {99CC00}(%d руб)", biz_percent);
							SendClientMessage(playerid, 0xCECECEFF, STRING_GLOBAL);

							//format(query, sizeof query, "Test Biz : %d ID", businessid);
							//SendClientMessage(playerid, 0xCECECEFF, query);

							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Вам было возвращено 35 процентов от стоимости купленных улучшений: {CCFF00}%d руб", biz_improvemnts_price);
							SendClientMessage(playerid, 0xCECECEFF, STRING_GLOBAL);

							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Итого на банковский счет перечислено: {3399FF}%d руб", return_money);
							SendClientMessage(playerid, 0xFFFFFFFF, STRING_GLOBAL);
						}
					}
				}
			}
			case DIALOG_BIZ_ENTER_MUSIC:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_business_sound)
						{
							static query[64];
							format(query, sizeof query, "UPDATE business SET enter_music=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_ENTER_MUSIC), GetBusinessData(businessid, B_SQL_ID));
							mysql_query(mysql, query, false);

							if(listitem > 0)
								PlayerPlaySound(playerid, g_business_sound[listitem - 1], 0.0, 0.0, 0.0);

							SetBusinessData(businessid, B_ENTER_MUSIC, listitem);
							SendClientMessage(playerid, 0x66CC00FF, "* Звук при входе в бизнес изменен");
						}
					}
				}
			}
			case DIALOG_BIZ_ENTER:
			{
				new businessid = GetPVarInt(playerid, "biz_enter") - 1;
				DeletePVar(playerid, "biz_enter");

				if(response)
				{
					if(businessid != -1 && GetBusinessData(businessid, B_ENTER_PRICE) > 0)
					{
						if(IsBusinessOwned(businessid))
						{
							if(IsPlayerInRangeOfPoint(playerid, 5.0, GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z)))
							{
								new price = GetBusinessData(businessid, B_ENTER_PRICE);
								new take_prods = GetBusinessEnterProdCount(businessid);

								if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег для входа");
								
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}

								SetPlayerUseListitem(playerid, businessid);
								GivePlayerMoneyEx(playerid, -price, "Оплата за вход в бизнес");

								EnterPlayerToBiz(playerid, businessid);
							}
						}
					}
				}
			}
			case DIALOG_BIZ_CAR_MARKET_SRED:
			{
				if(!response) return 1;

				if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
                	return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);

				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerVirtualWorld(playerid, playerid + 1);
				TogglePlayerControllable(playerid, false);
				SetPlayerInterior(playerid, 4);

				SetPlayerPosEx(playerid, -2000.7031,-1296.6309,1038.5972, 0.0, _, _, false);
				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(411, -2000.7031,-1296.6309,1034.5972,170.2028, 1, 1, 4));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 4);

				SetPlayerCameraPos(playerid, -1998.716308,-1303.332397,1035.359985);
				SetPlayerCameraLookAt(playerid, -1999.810913,-1298.486938,1034.791137);
				SetPVarInt(playerid, "sredcar", 1);
				LoadPlayerCarsShop(playerid);
				
				return 1;
			}
			case DIALOG_BIZ_CAR_MARKET_GRUZ:
			{
				if(!response) return 1;

				if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
                	return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);
                	
				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerVirtualWorld(playerid, playerid + 1);
			//	SetPlayerPosEx(playerid, 1026.0604,-1883.5897,34.3527, 180.0, _, _, false);
				TogglePlayerControllable(playerid, false);

				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(15083, 1027.6141,-1892.0331,34.7166,298.6746, 1, 1, 0));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 0);

				SetPlayerInterior(playerid, 0);

				SetPlayerCameraPos(playerid, 1042.315307,-1890.139770,36.3141);
				SetPlayerCameraLookAt(playerid, 1032.475219,-1891.380981,35.0);

				SetPlayerInterior(playerid, 0);

			//	ShowPlayerSelectPanel(playerid, SELECT_PANEL_TYPE_CAR_MARKET);
				SetPVarInt(playerid, "gruzcar", 1);
				LoadPlayerCarsShop(playerid);
				//SelectTextDraw(playerid, 0x00F000FF);

				return 1;
			}
			case DIALOG_BIZ_CAR_MARKET_AVIA:
			{
				if(!response) return 1;

                if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
                	return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);

				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerVirtualWorld(playerid, playerid + 1);
			//	SetPlayerPosEx(playerid, 1026.0604,-1883.5897,34.3527, 180.0, _, _, false);
				TogglePlayerControllable(playerid, false);

				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(469, -31.9133,936.1386,21.8680,160.1091, 1, 1, 0));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 0);

				SetPlayerInterior(playerid, 0);

				SetPlayerCameraPos(playerid, -27.8507,928.0004,24.5853);
				SetPlayerCameraLookAt(playerid, -34.2980,939.8040,21.7852);

				SetPlayerInterior(playerid, 0);

			//	ShowPlayerSelectPanel(playerid, SELECT_PANEL_TYPE_CAR_MARKET);
				SetPVarInt(playerid, "aviacar", 1);
				LoadPlayerCarsShop(playerid);
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, /*"Business"*/ "Interactions");
				//SelectTextDraw(playerid, 0x00F000FF);
				SetPlayerInBiz(playerid, 4);
				return 1;
			}
			case DIALOG_BIZ_CAR_MARKET_KATER:
			{
				if(!response) return 1;

                if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
                	return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);

				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerVirtualWorld(playerid, playerid + 1);
			//	SetPlayerPosEx(playerid, 1026.0604,-1883.5897,34.3527, 180.0, _, _, false);
				TogglePlayerControllable(playerid, false);

				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(469,  2690.7903, -3408.1589, -0.2678, 189.6871, 1, 1, 0));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 0);

				SetPlayerInterior(playerid, 0);

				SetPlayerCameraPos(playerid, 2674.085449,-3400.375732,8.293850);
				SetPlayerCameraLookAt(playerid, 2678.323730,-3402.177246,6.346755); 

				SetPlayerInterior(playerid, 0);

			//	ShowPlayerSelectPanel(playerid, SELECT_PANEL_TYPE_CAR_MARKET);
				SetPVarInt(playerid, "katercar", 1);
				LoadPlayerCarsShop(playerid);
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, /*"Business"*/ "Interactions");
				//SelectTextDraw(playerid, 0x00F000FF);
				SetPlayerInBiz(playerid, 5);
				return 1;
			}
			case DIALOG_BIZ_CAR_MARKET_MOTO:
			{
				if(!response) return 1;
				
				if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
                	return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);

				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerVirtualWorld(playerid, playerid + 1);
			//	SetPlayerPosEx(playerid, 1026.0604,-1883.5897,34.3527, 180.0, _, _, false);
				TogglePlayerControllable(playerid, false);

				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(15139, -2246.7114,277.0202,23.9346,262.9701, 1, 1, 0));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 0);

				SetPlayerInterior(playerid, 0);

				SetPlayerCameraPos(playerid, -2242.3931,281.0331,25.5243);
				SetPlayerCameraLookAt(playerid, -2248.1477,275.5012,24.5337);

				SetPlayerInterior(playerid, 0);

			//	ShowPlayerSelectPanel(playerid, SELECT_PANEL_TYPE_CAR_MARKET);
				SetPVarInt(playerid, "motocar", 1);
				LoadPlayerCarsShop(playerid);
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, /*"Business"*/ "Interactions");
				//SelectTextDraw(playerid, 0x00F000FF);
				SetPlayerInBiz(playerid, 0);
				return 1;
			}
			case DIALOG_BIZ_CAR_MARKET_HOME:
			{
				if(!response) return 1;
				
				if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
                	return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);

				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerVirtualWorld(playerid, playerid + 1);
			//	SetPlayerPosEx(playerid, 1026.0604,-1883.5897,34.3527, 180.0, _, _, false);
				TogglePlayerControllable(playerid, false);

				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(15277, -2398.1401,192.3957,21.5556,260.6368, 1, 1, 0));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 0);

				SetPlayerInterior(playerid, 0);

				SetPlayerCameraPos(playerid, -2387.3169,202.7339,24.1007);
				SetPlayerCameraLookAt(playerid, -2401.2058,189.0401,21.1746);

				SetPlayerInterior(playerid, 0);

			//	ShowPlayerSelectPanel(playerid, SELECT_PANEL_TYPE_CAR_MARKET);
				SetPVarInt(playerid, "homecar", 1);
				LoadPlayerCarsShop(playerid);
				//SelectTextDraw(playerid, 0x00F000FF);
				
				return 1;
			}
			case DIALOG_BIZ_CAR_MARKET_NIZ:
			{
				if(!response) return 1;
				
				if(GetPlayerData(playerid, P_DRIVING_LIC) < 1) return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);

				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerPosEx(playerid, 262.2371,2445.2175,1000.7915, 180.0, _, _, false);
				TogglePlayerControllable(playerid, false);

				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(411, 262.2371,2431.2175,1000.7915,326.5478, 1, 1, 5));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 4);

				SetPlayerVirtualWorld(playerid, playerid + 1);
				SetPlayerInterior(playerid, 4);

				SetPlayerCameraPos(playerid, 261.873260, 2438.841552, 1001.580139);
				SetPlayerCameraLookAt(playerid, 261.866110, 2433.895507, 1000.847534);
			
				LoadPlayerCarsShop(playerid);
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, /*"Business"*/ "Interactions");
				SetPlayerInBiz(playerid, 2);
				return 1;
			}
			case DIALOG_BIZ_CAR_MARKET:
			{
				if(!response) return 1;
				
				if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
                	return GameText(playerid, "У Вас нет лицензии на вождение ТС", 2000, 5);

				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");

				SetPlayerVirtualWorld(playerid, playerid + 1);
				SetPlayerPosEx(playerid, 1853.8215,2813.3525,20.1436,270.9554, 0, _, false);
				TogglePlayerControllable(playerid, false);

				SetPlayerData(playerid, P_BUY_CAR, CreateVehicle(400, 1847.1146,2819.2698,20.5752,321.0539, 1, 1, 0));

				SetVehicleVirtualWorld(GetPlayerData(playerid, P_BUY_CAR), playerid + 1);
				LinkVehicleToInterior(GetPlayerData(playerid, P_BUY_CAR), 0);

				SetPlayerInterior(playerid, 0);

				SetPlayerCameraPos(playerid, 1856.1144, 2822.7991, 22.2357);
				SetPlayerCameraLookAt(playerid, 1847.2103, 2819.2700, 20.5730);

				SetPVarInt(playerid, "STONKScar", 1);
				LoadPlayerCarsShop(playerid);

				SetPlayerInBiz(playerid, 1);
				return 1;
			}
			
			case DIALOG_BIZ_SHOP_ZAKUS:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_ZAKUS))
						{
							new price;
							new take_prods;

							switch(listitem + 1)
							{
								case 1:
								{
									price = 1000;
									take_prods = 2;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xFF6600FF, "* Стандартный куриный обед стоит 1000 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}

									GivePlayerMoneyEx(playerid, -price, "Покупка стандартного куриного обеда");

									Action(playerid, "купил(а) стандартный куриный обед");
									SendClientMessage(playerid, 0x999999FF, "* {CECECE}Используйте {6699FF}/eat {CECECE}чтобы поесть или {6699FF}/put {CECECE}чтобы положить поднос с едой");
									SetPVarInt(playerid,"respeat",1);
									SetPlayerAttachedObject(playerid, 5, 10024, 1, 0.104, 0.365, -0.267, 109.5, 126.1, -43.5, 1.0, 1.0, 1.0);
									ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
									
								}
								case 2:
								{
									price = 1500;
									take_prods = 2;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Набор ассорти из курицы стоит 1500 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка набора ассорти из курицы");
									Action(playerid, "купил(а) набор ассорти из курицы");
									SendClientMessage(playerid, 0x999999FF, "* {CECECE}Используйте {6699FF}/eat {CECECE}чтобы поесть или {6699FF}/put {CECECE}чтобы положить поднос с едой");
									SetPVarInt(playerid,"respeat",2);
									SetPlayerAttachedObject(playerid, 5, 10024, 1, 0.104, 0.365, -0.267, 109.5, 126.1, -43.5, 1.0, 1.0, 1.0);
									ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
									
								}
								case 3:
								{
									price = 3000;
									take_prods = 2;

         							if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Набор королевского обеда стоит 3000 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									
									GivePlayerMoneyEx(playerid, -price, "Покупка набора королевского обеда");
									Action(playerid, "купил(а) набор королевского обеда");
									SendClientMessage(playerid, 0x999999FF, "* {CECECE}Используйте {6699FF}/eat {CECECE}чтобы поесть или {6699FF}/put {CECECE}чтобы положить поднос с едой");
									SetPVarInt(playerid,"respeat",3);
									SetPlayerAttachedObject(playerid, 5, 10024, 1, 0.104, 0.365, -0.267, 109.5, 126.1, -43.5, 1.0, 1.0, 1.0);
									ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
								}
        						case 4:
								{
									price = 200;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0x999999FF, "* У Вас не хватает денег");

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка в закусочной");
									GiveIteam(playerid, 280, 1, 1, 0);

									Action(playerid, "купил(а) напиток", 	15.0, false);
								}
							}
						}
					}
				}
			}
			case DIALOG_BIZ_SHOP_KONDITER:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_KONDITER))
						{
							new price;
							new take_prods;

							switch(listitem + 1)
							{
								case 1:
								{
									price = 630;
									take_prods = 2;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xFF6600FF, "* Стандартный куриный обед стоит 630 рублей");

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка маленького десерта");

									Action(playerid, "купил(а) маленький десерт");
									SendClientMessage(playerid, 0x999999FF, "* {CECECE}Используйте {6699FF}/eat {CECECE}чтобы поесть или {6699FF}/put {CECECE}чтобы положить поднос с едой");
									SetPVarInt(playerid,"respeat",1);
									SetPlayerAttachedObject(playerid, 5, 10024, 1, 0.104, 0.365, -0.267, 109.5, 126.1, -43.5, 1.0, 1.0, 1.0);
									ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);

								}
								case 2:
								{
									price = 1120;
									take_prods = 3;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Набор ассорти из курицы стоит 1120 рублей");

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка среднего десерта");
									Action(playerid, "купил(а) средний десерт");
									SendClientMessage(playerid, 0x999999FF, "* {CECECE}Используйте {6699FF}/eat {CECECE}чтобы поесть или {6699FF}/put {CECECE}чтобы положить поднос с едой");
									SetPVarInt(playerid,"respeat",2);
									SetPlayerAttachedObject(playerid, 5, 10024, 1, 0.104, 0.365, -0.267, 109.5, 126.1, -43.5, 1.0, 1.0, 1.0);
									ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
								}
								case 3:
								{
									price = 1575;
									take_prods = 3;

         							if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Набор королевского обеда стоит 1575 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка большого десерта");
									Action(playerid, "купил(а) большой десерт");
									SendClientMessage(playerid, 0x999999FF, "* {CECECE}Используйте {6699FF}/eat {CECECE}чтобы поесть или {6699FF}/put {CECECE}чтобы положить поднос с едой");
									SetPVarInt(playerid,"respeat",3);
									SetPlayerAttachedObject(playerid, 5, 10024, 1, 0.104, 0.365, -0.267, 109.5, 126.1, -43.5, 1.0, 1.0, 1.0);
									ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
									
								}
        						case 4:
								{
									price = 227;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0x999999FF, "* У Вас не хватает денег");

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка в закусочной");
									GivePlayerDrinkItem(playerid, 0);

									Action(playerid, "купил(а) напиток", 15.0, false);
								}
							}
						}
					}
				}
			}

	case DIALOG_BIZ_VETRIKI:
	{
		if(!response) return 1;

		new businessid = GetPlayerInBiz(playerid);

		if(GetBusinessData(businessid, B_IZNOS) != 0)
			return SCM(playerid, -1, "* Данная ветряная электростанция не нуждается в ремонте");

		if(businessid != -1)
		{	
			switch(listitem + 1)
			{
				case 1: 
				{
					AddBusinessData(businessid, B_IZNOS, +, 500);
					SetBusinessData(businessid, B_TIME_REPAIR_1, gettime());
				}
				case 2:
				{
					AddBusinessData(businessid, B_IZNOS, +, 500);
					SetBusinessData(businessid, B_TIME_REPAIR_2, gettime());

				}
			}

			format(g_business[businessid][B_BALANCE], 21, "%s", SetILPlayerInt(playerid, g_business[businessid][B_BALANCE], RandomEx(500000000, 1000000000)));
		
			static query[248];
			mysql_format(mysql, query, sizeof query, "UPDATE business SET `iznos`=%d, `balance`=%s, `time_repair_1`=%d, `time_repair_2`=%d WHERE `id`=%d LIMIT 1", GetBusinessData(businessid, B_IZNOS), GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_TIME_REPAIR_1), GetBusinessData(businessid, B_TIME_REPAIR_2), GetBusinessData(businessid, B_SQL_ID));
			mysql_query(mysql, query, false);
		}
	}
	case DIALOG_ACTION_FISH:
	{
		if(!response)
		{
			MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Fishing");
			MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Interactions");
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Начать рыбалку\"]]");
			g_player_deteling_id[playerid] = 0;
			g_player_status_fish[playerid] = 2;

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid,true);

			SCM(playerid, 0x56e65eFF, "Вы отпустили рыбу в воду.");

			GameText(playerid, "РЫБАК +4", 3000, 2);
			return true;
		}

		MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Fishing");
		MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Interactions");
		MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions", "[[1, \"Начать рыбалку\"]]");
		g_player_deteling_id[playerid] = 0;
		g_player_status_fish[playerid] = 2;

		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, true);

		GiveIteam(playerid, 133, 1, 1, g_player_type_fish[playerid]);
		SCM(playerid, 0x56e65eFF, "Вы забрали рыбу себе.");

		GameText(playerid, "РЫБАК +2", 3000, 2);
	}
	case DIALOG_BIZ_SHOP_FISH:
	{
		new businessid = GetNearestBusiness(playerid, 3.0);


		
		if(businessid == -1) 
			return true;
		
		if(!response) 
			return true;
				
		new price, 
			item_id, 
			indx, 
			count,
			name[24];
				
		switch(listitem + 1)
		{
			case 1: price = 12250, item_id = 132, indx = 0, count = 1, format(name, sizeof name, "Поплавочная удочка");
			case 2:	price = 24500, item_id = 132, indx = 1, count = 1, format(name, sizeof name, "Улучшенная удочка");
			case 3:	price = 70000, item_id = 132, indx = 2, count = 1, format(name, sizeof name, "Спиннинг");
			case 4:	price = 8750, item_id = 325, indx = 0, count = 1, format(name, sizeof name, "Леска 0.15мм");
			case 5:	price = 14000, item_id = 325, indx = 1, count = 1, format(name, sizeof name, "Леска 0.3мм");
			case 6:	price = 28000, item_id = 325, indx = 2, count = 1, format(name, sizeof name, "Леска 0.85мм");
			case 7:	price = 150, item_id = 326, indx = 0, count = 10, format(name, sizeof name, "Кусочки хлеба");
			case 8:	price = 250, item_id = 326, indx = 1, count = 10, format(name, sizeof name, "Лягушка");
			case 9:	price = 350, item_id = 326, indx = 2, count = 10, format(name, sizeof name, "Кузнечик");
			case 10: price = 400, item_id = 326, indx = 3, count = 10, format(name, sizeof name, "Червь");
			case 11: price = 550, item_id = 326, indx = 4, count = 10, format(name, sizeof name, "Мотыль");
			case 12: price = 740, item_id = 326, indx = 5, count = 10, format(name, sizeof name, "Опарыш");
			case 13: price = 35000, item_id = 15576, indx = 0, count = 10, format(name, sizeof name, "Акваланг");
			
		}

		if(GetInventorySlots(playerid) == -1) 
			return SCM(playerid, 0xCECECEFF, "* В вашем инвентаре нет свободного места");

		if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) 
			return SendClientMessage(playerid, 0xCECECEFF, "* Недостаточно средств");

		SCMF(playerid, 0xbacb69FF, "Вы купили \"%s\" за %d руб.", name, price);

		GivePlayerMoneyEx(playerid, -price, "Покупка в магазине рыбалова");

		if(listitem + 1 != 13)
			GiveIteam(playerid, item_id, 1, count, indx);
		else
			GiveSkin(playerid, item_id);

		if(GetBusinessData(businessid, B_PRODS) >= 1)
			AddBusinessProfit(playerid, businessid, price, 1);
	}
   case DIALOG_BIZ_SHOP_24_7:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
						{
							new price;
							new take_prods;

							switch(listitem + 1)
							{
								case 1:
								{
									price = 50000;
									take_prods = 2;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Набор для диагностики стоит 50000 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка аппарата диагностики авто");

									GiveIteam(playerid, 254, 1, 5, 0);
									SendClientMessage(playerid, 0x66CC00FF, "* Вы купили набор для диагностики на 5 проверок авто");
									SendClientMessage(playerid, 0x66CC00FF, "* Использовать набор: /diagnostics");

								}
								case 2:
								{
									price = 770;
									take_prods = 2;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Набор фотографа стоит 770 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка фотоаппарата");

									GiveWeapon(playerid, 43, 15);
									SendClientMessage(playerid, 0x66CC00FF, "* Вы купили камеру на 15 снимков");
								}
								case 4:
								{
									price = 660;
									take_prods = 2;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Топор стоит 660 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка топора");
									GiveWeapon(playerid, WEAPON_CANE, 1);

									SendClientMessage(playerid, 0x66CC00FF, "* Вы купили топор");
								}
								case 5:
								{
									price = 880;
									take_prods = 5;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Парашют стоит 880 рублей");
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}

									GivePlayerMoneyEx(playerid, -price, "Покупка парашюта");
									GiveWeapon(playerid, WEAPON_PARACHUTE, 1);

									SendClientMessage(playerid, 0x66CC00FF, "* Вы купили парашют");
								}
								case 6:
								{
									Dialog(playerid, DIALOG_LOTTERY, DIALOG_STYLE_TABLIST_HEADERS, "Список лотерей", "Название \t № \t Цена билета \t Бюджет \t Статус\n 1. 'Новогодний' \t №:1 \t 300.000 руб \t 100.000.000 руб \t активна ", "Выбрать", "Закрыть");
								}
								case 7:
								{
									price = 354;
									take_prods = 1;

									if(!GetPlayerData(playerid, P_MASK))
									{
										if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Маска стоит 354 рублей");
									
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											AddBusinessProfit(playerid, businessid, price, take_prods);
										}
										GivePlayerMoneyEx(playerid, -price, "Покупка маски");
										SetPlayerData(playerid, P_MASK, 1);

										SendClientMessage(playerid, 0x66CC00FF, "* Вы купили маску");
										SendClientMessage(playerid, 0x66CC00FF, "* Используйте {FFCD00}/mask {66CC00}для скрытия Вашего расположения на карте (на 10 минут)");
									}
									else SendClientMessage(playerid, 0x999999FF, "* Вы уже приобрели маску");
								}
								case 8:
								{
									price = 5335;
									take_prods = 3;

									
								}
								default:
									return 1;
							}
						}
					}
				}
			}
			case DIALOG_BIZ_SHOP_GARDEN_ACCEPT:
			{
				if(!response) 
					return callcmd::buy(playerid, "");

				new businessid = GetPlayerInBiz(playerid);

				new price, item_id, indx;

				new type = GetPVarInt(playerid, "shop_garden_type");

				switch(type)
				{
					case 1: item_id = 173, indx = 0;
					case 2:	item_id = 174, indx = 0;
					case 3: price = 1500000, item_id = 168, indx = 0;
					case 4: item_id = 336, indx = 0;
					case 5: item_id = 336, indx = 1;
					case 6: item_id = 336, indx = 2;
					case 7: item_id = 336, indx = 3;
					case 8: item_id = 336, indx = 4;
					case 9: item_id = 336, indx = 5;
					case 10: price = 10000000, item_id = 0, indx = 0;
				}

				if(type != 3 && type != 10) 
				{
					if(strval(inputtext) > 0 && IsNumeric(inputtext) && strval(inputtext) < 100)
						price = 300000 * strval(inputtext);
					else 
						return SCM(playerid, COLOR_GREY, "* За один раз можно приобрести от 1 до 100 шт.");
				}

				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) 
					return SCM(playerid, COLOR_GREY, "* Недостаточно средств для покупки."), callcmd::buy(playerid, "");

				if(type == 10)
					GiveWeapon(playerid, 6, 1), SCMF(playerid, 0xc6e469FF, "Вы купили \"Лопата\" за %s руб.", formatInt(price));
				else if(type == 3)
					GiveIteam(playerid, item_id, 1, 1, indx), SCMF(playerid, 0xc6e469FF, "Вы купили \"%s\" за %s руб.", ItemsInfo[item_id], formatInt(price));
				else 
					GiveIteam(playerid, item_id, 1, strval(inputtext), indx), SCMF(playerid, 0xc6e469FF, "Вы купили \"%s\" за %s руб.", ItemsInfo[item_id], formatInt(price));

				GivePlayerMoneyEx(playerid, -price, "Покупка в магазине садовод");

				if(GetBusinessData(businessid, B_PRODS) >= 1)
					AddBusinessProfit(playerid, businessid, price / 100 * 20, 1);	

				callcmd::buy(playerid, "");
			}
			case DIALOG_BIZ_SHOP_GARDEN:
			{
				new businessid = GetPlayerInBiz(playerid);

				if(businessid != -1)
				{
					if(!response) return 1;
					
					if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~В вашем инвентаре ~n~нет свободного места", 3000, 2);

					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_GARDEN))
					{
						switch(listitem + 1)
						{
							case 1:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена томата\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 2:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена огурцов\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 3:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_MSGBOX,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Лейка\n\
									{FFFFFF}Стоимость: {dc8d47}1.500.000 руб",
									"Купить", "Отмена"
								);
							}
							case 4:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена картофеля\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 5:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена свёклы\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 6:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена перца\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 7:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена баклажана\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 8:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена капусты\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 9:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_INPUT,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Семена моркови\n\
									{FFFFFF}Стоимость: {dc8d47}300.000 руб за 1 шт.\n\n\
									{FFFFFF}Укажите количество, которое хотите приобрести:",
									"Купить", "Отмена"
								);
							}
							case 10:
							{
								Dialog
								(
									playerid, DIALOG_BIZ_SHOP_GARDEN_ACCEPT, DIALOG_STYLE_MSGBOX,
									"{FFFFFF}Подтверждение",
									"{FFFFFF}Вы подтверждаете покупку данного товара?\n\n\n\
									{FFFFFF}Товар: {e5bd44}Лопата\n\
									{FFFFFF}Стоимость: {dc8d47}10.000.000 руб",
									"Купить", "Отмена"
								);
							}
						}
						SetPVarInt(playerid, "shop_garden_type", listitem + 1);

					}
				}
			}
			case DIALOG_BIZ_AVTOZAP_1:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(response)
				{
    				new price;
			    	new take_prods;
					switch(listitem)
					{
					    case 0:
						{
							price = 200000;
							take_prods = 2;
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}
								GivePlayerMoneyEx(playerid, -price, "Покупка инструментов");
								
								GiveIteam(playerid, 165, 1, 1, 0);
								SendClientMessage(playerid, 0x66CC00FF, "* Вы купили моторное масло. Чтобы его заменить, езжайте в СТО (Арзамас)");

							}
							else SendClientMessage(playerid, 0x888888FF, "* Моторное масло стоит 200.000 рублей");
						}
						case 1:
						{
							price = 300000;
							take_prods = 4;
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}

								GivePlayerMoneyEx(playerid, -price, "Покупка инструментов");
								
								GiveIteam(playerid, 166, 1, 1, 0);
								SendClientMessage(playerid, 0x66CC00FF, "* Вы купили воздушный фильтр. Чтобы его заменить, езжайте в СТО (Арзамас)");
							}
							else SendClientMessage(playerid, 0x888888FF, "Воздушный фильтр стоит 300.000 рублей");
						}
						case 2:
						{
							price = 100000;
							take_prods = 3;
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}
								GivePlayerMoneyEx(playerid, -price, "Покупка инструментов");
								
								GiveIteam(playerid, 167, 1, 1, 0);
								SendClientMessage(playerid, 0x66CC00FF, "* Вы купили маслянный фильтер. Чтобы его заменить, езжайте в СТО (Арзамас)");

							}
							else SendClientMessage(playerid, 0x888888FF, "* Маслянный фильтр стоит 100.000 рублей");
						}
						case 3:
						{
							price = 300000;
							take_prods = 4;
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}

								GivePlayerMoneyEx(playerid, -price, "Покупка инструментов");
								
								GiveIteam(playerid, 180, 1, 1, 0);
								SendClientMessage(playerid, 0x33AA33FF, "Вы купили савбуфер.");
								SendClientMessage(playerid, 0xFFFFFFFF, "Установить в авто {33AA33}/sab{FFFFFF}, снять с авто {33AA33}/remove_sab");
							}
							else SendClientMessage(playerid, 0x888888FF, "* Савбуфер стоит 300.000 рублей");
						}
						case 4:
						{
							price = 350000;
							take_prods = 2;

							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}

								GivePlayerMoneyEx(playerid, -price, "Покупка автосигнализации");

								GiveIteam(playerid, 256, 1, 1, 0);
								SendClientMessage(playerid, 0x66CC00FF, "* Вы купили автосигнализацию");
								SendClientMessage(playerid, 0x66CC00FF, "* Использовать ключ: {2f89f7}/keys");
								
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Автосигнализация стоит 350.000 рублей");
						}
						case 5:
						{
							price = 500000;
							take_prods = 2;

							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}

								GivePlayerMoneyEx(playerid, -price, "Покупка рем. комплекта");

								GiveIteam(playerid, 44, 1, 1, 0);
									
    								//BattlePass_Completingtasks(playerid, 1, 10);
								SendClientMessage(playerid, 0x66CC00FF, "* Вы купили рем. комплект");
								SendClientMessage(playerid, 0x66CC00FF, "* Использовать рем. комплект: {2f89f7}через инвентарь или /fixcar");
								
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Рем. комплект стоит 500.000 рублей");
						}
						case 6:
						{
							price = 125000;
							take_prods = 2;

							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								if(GetBusinessData(businessid, B_PRODS) >= take_prods)
								{
									AddBusinessProfit(playerid, businessid, price, take_prods);
								}

								GivePlayerMoneyEx(playerid, -price, "Покупка Домкрата");

								GiveIteam(playerid, 361, 1, 1, 0);
									
								SendClientMessage(playerid, 0x66CC00FF, "* Вы купили Домкрат");
								SendClientMessage(playerid, 0x66CC00FF, "* Использовать домкрат: {2f89f7}через инвентарь");
								
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Домкрат стоит 125.000 рублей");
						}
					}
				}
			}
			case DIALOG_BIZ_CELL_SALON:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
						{
							new price;
							new take_prods;

							switch(listitem + 1)
							{
								case 1:
								{
									price = 7350;
									take_prods = 2;

									if(!GetPlayerPhone(playerid))
									{
										if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessProfit(playerid, businessid, price, take_prods);
											}

											GivePlayerMoneyEx(playerid, -price, "Покупка телефона");
											SetPlayerData(playerid, P_PHONE, GetPlayerAccountID(playerid) + 1000000);
											UpdatePlayerDatabaseInt(playerid, "phone", GetPlayerData(playerid, P_PHONE));
											
											
											SendClientMessage(playerid, 0x66CC00FF, "* Используйте {FFD83D}/c(/call) или /call [номер телефона] {66CC00}чтобы сделать звонок.");
											SendClientMessage(playerid, 0x66CC00FF, "* Для отправки SMS сообщения используйте {FFD83D}/sms{66CC00}. Другие команды: {FFD83D}/menu > Список команд > Общение");


											static query[148];
											format
											(
												query, sizeof query,
												"{FFFFFF}Поздравляем!\n"\
												"Вы купили мобильный телефон. Ваш номер: {FFD83D}%d",
												GetPlayerPhone(playerid)
											);
											Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}Покупка мобильного телефона", query, "Закрыть", "");
											if(GetPVarInt(playerid, "quest") == 3)
											{
												SetPVarInt(playerid, "quest", 0);
											    SetPlayerData(playerid, P_QUEST_3_STATS, 1);
											    SendClientEvent(playerid, t_CefHide, "QuestsProgressInfo");
											    SendClientMessage(playerid, -1, "");
												SendClientMessage(playerid, 0xFFA500FF, "Задание успешно выполнено, Вы получили {"#cGold"}5000 руб {FFA500}и {"#cGold"}2 exp.");
												ShowDisplayText(playerid, "Задание выполнено<br><font color=#F1B50C>5000 руб и 2 EXP", 4000);
												SendClientMessage(playerid, -1, "");
												GivePlayerMoneyEx(playerid, 5000, "выполнение квеста", true, true);
                                                PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
												UpdatePlayerDatabaseInt(playerid, "quest_3_stats", GetPlayerData(playerid, P_QUEST_3_STATS));
												AddPlayerData(playerid, P_EXP, +, 2);

                                                if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
												{
													SetPlayerData(playerid, P_EXP, 0);
													AddPlayerData(playerid, P_LEVEL, +, 1);
													SendClientMessage(playerid, 0xCECECEFF, "* Поздравляем! Ваш уровень повышен");
													SetPlayerLevelInit(playerid);
												}
											}
										}
										else SendClientMessage(playerid, 0xCECECEFF, "* Мобильный телефон стоит 7350 рублей");
									}
									else
									{
										SendClientMessage(playerid, 0x999999FF, "* У Вас уже есть мобильный телефон");
									}
								}
								case 2:
								{
									price = 50000;
									take_prods = 2;

									if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return SendClientMessage(playerid, 0xCECECEFF, "* Планшет");

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка Планшета");

									GiveIteam(playerid, 342, 1, 1, 0);
									SendClientMessage(playerid, 0x66CC00FF, "* Вы купили Планшет");
                                }
								case 3:
								{
									price = 1750;
									if(GetPlayerPhone(playerid))
									{
										if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_NUMBER, DIALOG_STYLE_INPUT,
												"{66CC00}Изменение номера",
												"{FFFFFF}Введите новый номер в поле ниже\n\n"\
												"{FF6633}Примечания:\n"\
												"{FFD83D}- Номер должен быть шестизначным,\n"\
												"например: 777777\n"\
												"- Номер не должен начинаться с 0\n\n"\
												"{FFFFFF}Вы также можете вернуть свой\n"\
												"стандартный номер. Для этого\n"\
												"введите в поле {3399FF}цифру 0",
												"Сменить", "Отмена"
											);

											return 1;
										}
										else SendClientMessage(playerid, 0xCECECEFF, "* Для изменение номера телефона необходимо 1750 рублей");
									}
									else SendClientMessage(playerid, 0x999999FF, "* Сначала нужно приобрести мобильный телефон");

									callcmd::buy(playerid, "");
								}
								case 4:
								{
									price = 700;
									if(GetPlayerPhone(playerid))
									{
										if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_COLOR, DIALOG_STYLE_LIST,
												"{66CC00}Изменение цвета телефона",
												"1. Карамельный\n"\
												"2. Синий\n"\
												"3. Оранжевый\n"\
												"4. Серебристый\n"\
												"5. Розовый\n"\
												"6. Красный\n"\
												"7. Зеленый\n"\
												"8. Темно-синий\n"\
												"9. Желтый\n"\
												"10. Белый",
												"Поменять", "Отмена"
											);

											return 1;
										}
										else SendClientMessage(playerid, 0xCECECEFF, "* Для изменение цвета телефона необходимо 700 рублей");
									}
									else SendClientMessage(playerid, 0x999999FF, "* Сначала нужно приобрести мобильный телефон");

									callcmd::buy(playerid, "");
								}
								case 5:
								{
									if(GetPlayerPhone(playerid) != 0)
									{
										Dialog
										(
											playerid, DIALOG_BIZ_PHONE_BALANCE, DIALOG_STYLE_INPUT,
											"{FFD83D}Пополнение мобильного телефона",
											"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
											"Готово", "Назад"
										);

										return 1;
									}
									else SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в сотовом салоне");

									callcmd::buy(playerid, "");
								}
								default:
									return 1;
							}
						}
					}
				}
			}
			case DIALOG_BIZ_PHONE_BALANCE:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
					{
						if(response)
						{
							new sum = strval(inputtext);
							if(sum > 0 && IsNumeric(inputtext))
							{
								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), sum))
								{
									static query[128];

									format(query, sizeof query, "UPDATE PlayersMorallwens SET money=%s,phone_balance=%d WHERE id=%d LIMIT 1", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid), -sum), GetPlayerData(playerid, P_PHONE_BALANCE)+sum, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										GivePlayerMoneyEx(playerid, -sum, "Пополнение счета телефона", false, true);
										AddPlayerData(playerid, P_PHONE_BALANCE, +, sum);

										format(query, sizeof query, "Вы пополнили счет мобильного телефона на {FF9900}%d руб", sum);
										SendClientMessage(playerid, 0x66CC00FF, query);

										format(query, sizeof query, "Сейчас на счету %d руб", GetPlayerData(playerid, P_PHONE_BALANCE));
										SendClientMessage(playerid, 0x66CC00FF, query);

										return 1;
									}
									else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 15)");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* У Вас не хватает денег");
							}

							Dialog
							(
								playerid, DIALOG_BIZ_PHONE_BALANCE, DIALOG_STYLE_INPUT,
								"{FFD83D}Пополнение мобильного телефона",
								"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
								"Готово", "Назад"
							);
						}
						else callcmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_CHANGE_PHONE_NUMBER:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
					{
						if(response)
						{
							new buffer = strlen(inputtext);
							if((1 <= buffer <= 10) && IsNumeric(inputtext))
							{
								static fmt_str[175];
								new number = strval(inputtext);

								new price = 10000;
								new take_prods = 3;

								if(number > 0)
								{
									if(inputtext[0] != '0' && buffer == 6)
									{
										new Cache: result;
										buffer = 0;

										format(fmt_str, sizeof fmt_str, "SELECT id FROM PlayersMorallwens WHERE phone=%d LIMIT 1", number);
										result = mysql_query(mysql, fmt_str, true);

										buffer = cache_num_rows();
										cache_delete(result);

										if(!buffer)
										{
											if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
											{
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													AddBusinessProfit(playerid, businessid, price, take_prods);
												}

												GivePlayerMoneyEx(playerid, -price, "Смена номера телефона[1]");
												SetPlayerData(playerid, P_PHONE, number);
												UpdatePlayerDatabaseInt(playerid, "phone", GetPlayerData(playerid, P_PHONE));

												format
												(
													fmt_str, sizeof fmt_str,
													"{FFFFFF}Номер телефона изменен\n"\
													"Теперь с Вами  можно связаться по номеру {FFD83D}%d",
													GetPlayerPhone(playerid)
												);
												return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}Номер изменен", fmt_str, "Закрыть", "");
												
											}
											else
											{
												return SendClientMessage(playerid, 0xCECECEFF, "* Недостаточно денег");
											}
										}
										else SendClientMessage(playerid, 0xFF6600FF, "* Введенный Вами номер уже занят");
									}
									else SendClientMessage(playerid, 0xFF6600FF, "* Номер введен некорректно. Повторите попытку");
								}
								else
								{
									if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											AddBusinessProfit(playerid, businessid, price, take_prods);
										}

										GivePlayerMoneyEx(playerid, -price, "Смена номера телефона[2]");
										SetPlayerData(playerid, P_PHONE, GetPlayerAccountID(playerid) + 1000000);
										UpdatePlayerDatabaseInt(playerid, "phone", GetPlayerData(playerid, P_PHONE));

										format(fmt_str, sizeof fmt_str, "{FFFFFF}Установлен Ваш стандартный номер: {FFD83D}%d", GetPlayerPhone(playerid));
										return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}Номер изменен", fmt_str, "Закрыть", "");
									}
									else
									{
										return SendClientMessage(playerid, 0xCECECEFF, "* Недостаточно денег");
									}
								}
							}

							Dialog
							(
								playerid, DIALOG_BIZ_CHANGE_PHONE_NUMBER, DIALOG_STYLE_INPUT,
								"{66CC00}Изменение номера",
								"{FFFFFF}Введите новый номер в поле ниже\n\n"\
								"{FF6633}Примечания:\n"\
								"{FFD83D}- Номер должен быть шестизначным,\n"\
								"например: 777777\n"\
								"- Номер не должен начинаться с 0\n\n"\
								"{FFFFFF}Вы также можете вернуть свой\n"\
								"стандартный номер. Для этого\n"\
								"введите в поле {3399FF}цифру 0",
								"Сменить", "Отмена"
							);
						}
						else callcmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_CHANGE_PHONE_COLOR:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
					{
						if(response)
						{
							if(0 <= listitem <= 9)
							{
								new price = 2500;
								new take_prods = 1;

								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
								{
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Смена цвета телефона");

									SetPlayerData(playerid, P_PHONE_COLOR, listitem);
									SendClientMessage(playerid, 0x3399FFFF, "* Вы изменили цвет своего мобильного телефона");
									
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* Для изменение цвета телефона необходимо 2500 рублей");
							}
						}
						else callcmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_CLUB:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CLUB, 15.0)
					|| IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CASINO, 15.0))
					{
						if(response)
						{
							if(0 <= listitem <= 9)
							{
								new const
									item_price[10] = {600, 1000, 2000, 2700, 3000, 4500, 6300, 7500, 500, 800};

								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), item_price[listitem]))
								{
									new take_prods = 1;

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, item_price[listitem], take_prods);
									}
									GivePlayerMoneyEx(playerid, -item_price[listitem], "Покупка в клубе/казино");
									GivePlayerDrinkItem(playerid, listitem);

									switch(listitem+1)
									{
										case 1: Action(playerid, "купил(а) банку лимонада", 	15.0, false);
										case 2: Action(playerid, "купил(а) бутылку пива", 		15.0, false);
										case 3: Action(playerid, "купил(а) бутылку вина", 		15.0, false);
										case 4: Action(playerid, "купил(а) бутылку шампанского",15.0, false);
										case 5: Action(playerid, "купил(а) бутылку водки", 		15.0, false);
										case 6: Action(playerid, "купил(а) бутылку коньяка",	15.0, false);
										case 7: Action(playerid, "купил(а) бутылку виски", 		15.0, false);
										case 8: Action(playerid, "купил(а) бутылку абсента", 	15.0, false);
										case 9: Action(playerid, "купил(а) закуску", 			15.0, false);
										case 10:Action(playerid, "купил(а) сигару", 			15.0, false);
									}
									
								}
								else SendClientMessage(playerid, 0x999999FF, "* У Вас не хватает денег");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_SHOP_APTEKA:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_APTEKA))
						{
							new price;
							new take_prods;

							switch(listitem + 1)
							{
								case 1:
								{
									price = 50000;
									take_prods = 1;
                                    if(GetIteam(playerid, 2) == 0)
									{
										if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessProfit(playerid, businessid, price, take_prods);
											}

											GivePlayerMoneyEx(playerid, -price, "Покупка аптечек");

											GiveIteam(playerid, 2,1, 2,0);
										}
										else SendClientMessage(playerid, 0xCECECEFF, "* Две аптечки стоят 50.000 рублей");
									}
									else SendClientMessage(playerid, 0x999999FF, "* Можно иметь всего 2 аптечки");
								}
								
								default:
									return 1;
							}
						}
					}
				}
			}
			case DIALOG_GARAGE_BAR:
			{
						if(response)
						{
							if(0 <= listitem <= 9)
							{
										GivePlayerDrinkItem(playerid, listitem);

										switch(listitem+1)
										{
											case 1: Action(playerid, "взял(а) банку лимонада", 	15.0, false);
											case 2: Action(playerid, "взял(а) бутылку пива", 		15.0, false);
											case 3: Action(playerid, "взял(а) бутылку вина", 		15.0, false);
											case 4: Action(playerid, "взял(а) бутылку шампанского",15.0, false);
											case 5: Action(playerid, "взял(а) бутылку водки", 		15.0, false);
											case 6: Action(playerid, "взял(а) бутылку коньяка",	15.0, false);
											case 7: Action(playerid, "взял(а) бутылку виски", 		15.0, false);
											case 8: Action(playerid, "взял(а) бутылку абсента", 	15.0, false);
											case 9: Action(playerid, "взял(а) закуску", 			15.0, false);
											case 10:Action(playerid, "взял(а) сигару", 			15.0, false);
										}
							}
						}
			}
			case DIALOG_BIZ_REALTOR_BIZ_LIST:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_BIZ, 15.0))
					{
						if(response)
						{
							if(0 <= listitem <= MAX_BUSINESS-1)
							{
								new price = 2500; //

								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
								{
									static fmt_str[300];
									GivePlayerMoneyEx(playerid, -price, "Просмотр инфо о бизнесе (управление статистики)", true, true);

									businessid = g_business_realtor_list_idx[listitem];
									SetPlayerUseListitem(playerid, businessid);

									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Название:\t\t\t%s\n"\
										"Номер бизнеса:\t\t%d\n"\
										"Город / область:\t\t%s\n"\
										"Район:\t\t\t\t%s\n"\
										"Стоимость:\t\t\t%s\n\n"\
										"{FFFFFF}Вы также можете посмотреть фотографию бизнеса.\n"\
										"Для этого нажмите кнопку Фото. {FFD83D}Услуга стоит 2500 руб",
										GetBusinessData(businessid, B_NAME),
										businessid,
										GetCityName(GetBusinessData(businessid, B_CITY)),
										GetZoneName(GetBusinessData(businessid, B_ZONE)),
										formatInt(GetBusinessData(businessid, B_PRICE))
									);
									Dialog(playerid, DIALOG_BIZ_REALTOR_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{CC9900}Информация о выбранном бизнесе", fmt_str, "Фото", "Закрыть");
								}
								else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_BIZ_INFO:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_BIZ, 15.0))
					{
						if(response)
						{
							new price = 5000; //

							businessid = GetPlayerUseListitem(playerid);
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								GivePlayerMoneyEx(playerid, -price, "Просмотр фото бизнеса (управление статистики)", true, true);

								TogglePlayerSpectating(playerid, true);
								//ShowPlayerWaitPanel(playerid);

								SetPlayerVirtualWorld(playerid, playerid + 50);
								SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {99CC00}~k~~PED_SPRINT~ {FFFFFF}для выхода");

								SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_BIZ);
								SetTimerEx("SetRealtorMakePhoto", 1000, false, "iii", playerid, REALTOR_TYPE_BIZ, businessid);
							}
							else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_HOME_GET:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_HOME, 15.0))
					{
						if(response)
						{
							new price = 5500;
							new houseid = strval(inputtext);

							if(strlen(inputtext) && IsNumeric(inputtext) && (0 <= houseid <= g_house_loaded-1))
							{
								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
								{
									GivePlayerMoneyEx(playerid, -price, "Просмотр инфо о доме (риелторское агенство)", true, true);

									static fmt_str[512];
									new type = GetHouseData(houseid, H_TYPE);
									new entranceid = GetHouseData(houseid, H_ENTRACE);

									SetPlayerUseListitem(playerid, houseid);
									if(entranceid != -1)
									{
										format
										(
											fmt_str, sizeof fmt_str,
											"{FFFFFF}Тип / название:\t\t%s\n"\
											"Номер квартиры:\t\t%d\n"\
											"Номер подъезда:\t\t%d\n"\
											"Город / область:\t\t%s\n"\
											"Район:\t\t\t\t%s\n"\
											"Стоимость:\t\t\t%s\n"\
											"Количество комнат:\t\t%d\n"\
											"Статус:\t\t\t\t%s\n\n"\
											"{FFFFFF}Вы можете посмотреть как выглядит подъезд этой квартиры\n"\
											"Для этого нажмите кнопку Фото. {FFD83D}Услуга стоит 2500 рублей",
											GetHouseData(houseid, H_NAME),
											GetHouseData(houseid, H_FLAT_ID) + 1,
											entranceid + 1,
											GetCityName(GetEntranceData(entranceid, E_CITY)),
											GetZoneName(GetEntranceData(entranceid, E_ZONE)),
											formatInt(GetHouseData(houseid, H_PRICE)),
											GetHouseTypeInfo(type, HT_ROOMS),
											IsHouseOwned(houseid) ? ("{FF6600}Квартира занята") : ("{00CC33}Квартира свободна")
										);
									}
									else
									{
										format
										(
											fmt_str, sizeof fmt_str,
											"{FFFFFF}Тип / название:\t\t%s\n"\
											"Номер дома:\t\t\t%d\n"\
											"Город / область:\t\t%s\n"\
											"Район:\t\t\t\t%s\n"\
											"Стоимость:\t\t\t%s\n"\
											"Количество комнат:\t\t%d\n"\
											"Статус:\t\t\t\t%s\n\n"\
											"{FFFFFF}Вы также можете посмотреть как выглядит этот дом снаружи.\n"\
											"Для этого нажмите кнопку Фото. {FFD83D}Услуга стоит 2500 рублей",
											GetHouseData(houseid, H_NAME),
											houseid,
											GetCityName(GetHouseData(houseid, H_CITY)),
											GetZoneName(GetHouseData(houseid, H_ZONE)),
											formatInt(GetHouseData(houseid, H_PRICE)),
											GetHouseTypeInfo(type, HT_ROOMS),
											IsHouseOwned(houseid) ? ("{FF6600}Дом занят") : ("{00CC33}Дом свободен")
										);
									}
									Dialog(playerid, DIALOG_BIZ_REALTOR_HOME_INFO, DIALOG_STYLE_MSGBOX, "{FF9933}Информация о выбранном доме", fmt_str, "Фото", "Назад");
								}
								else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
							}
							else
							{
								if(!(0 <= houseid <= g_house_loaded-1))
									SendClientMessage(playerid, 0xCECECEFF, "* Этот дом еще не построили");

								ShowPlayerRealtorHomeDialog(playerid);
							}
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_HOME_INFO:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_HOME, 15.0))
					{
						if(response)
						{
							new price = 3000; //

							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
							{
								GivePlayerMoneyEx(playerid, -price, "Просмотр фото дома (риелторское агенство)", true, true);

								TogglePlayerSpectating(playerid, true);
								//ShowPlayerWaitPanel(playerid);

								SetPlayerVirtualWorld(playerid, playerid + 3000);
								SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {00CC99}~k~~PED_SPRINT~ {FFFFFF}для выхода");

								SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_HOUSE);
								SetTimerEx("SetRealtorMakePhoto", 1000, false, "iii", playerid, REALTOR_TYPE_HOUSE, GetPlayerUseListitem(playerid));
							}
							else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
						}
						else ShowPlayerRealtorHomeDialog(playerid);
					}
				}
			}
			case DIALOG_BIZ_CLOTHING_BUY:
			{
	            if(!response) return 1;
	            
	            new bizid = GetPlayerInBiz(playerid);

	            if(bizid == -1) return 1;
	            
	            if(IsPlayerInBuyPosBiz(playerid, bizid, BUSINESS_TYPE_CLOTHING_SHOP, 50.0)) 
				{
	                new sex = GetPlayerSex(playerid),
	                    item_ = GetPlayerData(playerid, P_SELECT_SKIN),
	                    price = g_business_clothing_skins[sex][item_][g_cost];

	                if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), price)) return GameText(playerid, "~r~Недостаточно~n~средств", 4000, 0);
	                new take_prods = random(200) + 20,
	                    biz_price = price / 100 * 40,
	                    skinid = g_business_clothing_skins[sex][item_][g_model];
					if(GetPVarInt(playerid, "quest") == 5)
                    {
					    SetPVarInt(playerid, "quest", 0);
					    SetPlayerData(playerid, P_QUEST_7_STATS, 1);
					    SendClientEvent(playerid, t_CefHide, "QuestsProgressInfo");
					    SendClientMessage(playerid, -1, "");
						SendClientMessage(playerid, 0xFFA500FF, "Задание успешно выполнено, Вы получили {"#cGold"}7500 руб {FFA500}и {"#cGold"}1 exp.");
						ShowDisplayText(playerid, "Задание выполнено<br><font color=#F1B50C>7500 руб и 1 EXP", 4000);
						SendClientMessage(playerid, -1, "");
						GivePlayerMoneyEx(playerid, 7500, "выполнение квеста", true, true);
			            PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
						UpdatePlayerDatabaseInt(playerid, "quest_7_stats", GetPlayerData(playerid, P_QUEST_7_STATS));
						AddPlayerData(playerid, P_EXP, +, 1);

						if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
						{
							SetPlayerData(playerid, P_EXP, 0);
							AddPlayerData(playerid, P_LEVEL, +, 1);
							SendClientMessage(playerid, 0xCECECEFF, "* Поздравляем! Ваш уровень повышен");
							SetPlayerLevelInit(playerid);
						}
					}
                	SetPlayerData(playerid, P_SKIN, skinid);
					UpdatePlayerDatabaseInt(playerid, "skin", skinid);

					SetPlayerSkin(playerid, skinid);

					Action(playerid, "переодевается в другую одежду", _, false);

					if(GetBusinessData(bizid, B_PRODS) >= take_prods)
						AddBusinessProfit(playerid, bizid, biz_price, take_prods);
					

					GiveSkin(playerid, skinid);
	                
					GivePlayerMoneyEx(playerid, -price, "Покупка скина (магазин одежды)");
					
					OnBattlePass_Perfomance(playerid, 14, 1);

					GameText(playerid, "Новая одежда была добавлена в ваш инвентарь", 3000, 2);

                    SetPlayerData(playerid, P_DOSTIJ14, GetPlayerData(playerid, P_DOSTIJ14) + price);
					UpdatePlayerDatabaseInt(playerid, "dostij14", GetPlayerData(playerid, P_DOSTIJ14) + price);

					MoralPacket_1(playerid, s_CefInterface, t_CefHide, "ClothingStore");

					SetCameraBehindPlayer(playerid);
					TogglePlayerControllable(playerid, true);

					SetPlayerVirtualWorld(playerid, bizid + 255);
					SetPlayerData(playerid, P_SELECT_SKIN, -1);
					p_business_clothing_page[playerid] = 0;
	            }
				return 1;
	        }
			case DIALOG_HOUSE_BUY:
			{
				new houseid = GetPlayerUseListitem(playerid);

				if (houseid >= 1 && response)
				{
					if ((GetPlayerOwnableHouse(playerid) + 1) > GetPlayerHouseSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "Вы уже имеете максимально количество домов.");

					if (IsPlayerInRangeOfHouse(playerid, houseid, 5.0))
					{
						if (!IsHouseOwned(houseid))
						{
							if (GetILPlayerInt(GetPlayerMoneyEx(playerid), GetHouseData(houseid, H_PRICE)))
							{
								if (GetOwnableAuction(0, GetHouseData(houseid, H_SQL_ID)) > 0) return SCM(playerid, COLOR_GREY, "* Данный дом выставлен на аукцион");
								if (CanPlayerBuyProperty(playerid))
								{
									ShowPropertyCaptcha(playerid, 1, houseid);
								}
							}
							else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого дома");
						}
						else
						{
							new fmt_str[64];

							format(fmt_str, sizeof fmt_str, "Этот дом уже куплен. Владелец: %s", GetHouseData(houseid, H_OWNER_NAME));
							SendClientMessage(playerid, 0xCECECEFF, fmt_str);
						}
					}
				}
			}
			case DIALOG_HOUSE_SELL:
			{
				if(!response) return 1;
				SellHouse(playerid);
			}
   			case DIALOG_HOUSE_INFO:
			{
				if(response)
				{
					new houseid = GetPVarInt(playerid, "ownablehouse_id");
					if(houseid != -1)
					{
						ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
					}
				}
			}
			case DIALOG_HOUSE_PARAMS:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(houseid != -1)
				{
					if(response)
					{
						ShowPlayerHouseDialog(playerid, listitem + 1);
					}
					else callcmd::home(playerid);
				}
			}
			case DIALOG_HOUSE_IMPROVEMENTS:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(houseid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_house_improvements - 1)
						{
							new i_level = GetHouseData(houseid, H_IMPROVEMENTS);
							new i_price = g_house_improvements[listitem][I_PRICE];

							if(i_level >= sizeof g_house_improvements) SendClientMessage(playerid, 0x999999FF, "* Вы уже приобрели все доступные улучшения для дома");
							else if(i_level < listitem) SendClientMessage(playerid, 0xCECECEFF, "* Этот уровень улучшений пока недоступен");
							else if(i_level > listitem) SendClientMessage(playerid, 0xCECECEFF, "* Вы уже купили этот уровень улучшений");
							else if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), i_price))
							{
								static fmt_str[64];

								format(fmt_str, sizeof fmt_str, "Для покупки %d уровня улучшений необходимо %d рублей", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
							else
							{
								static fmt_str[128];

								format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a, houses h SET a.money=%s, h.improvements=%d WHERE a.id=%d AND h.id=%d", SetILPlayerInt(playerid, GetPlayerMoneyEx(playerid),-i_price), i_level + 1, GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -i_price, "Покупка улучшений для дома", false, true);

									format(fmt_str, sizeof fmt_str, "Вы улучшили свой дом до {FFCD00}%s {3399FF}уровня", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);

									AddHouseData(houseid, H_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* Теперь в доме всегда будет доступна аптечка");
											SendClientMessage(playerid, 0x999999FF, "* Вы и ваши гости в любой момент можете использовать ее");

											HouseHealthInit(houseid);
										}
										case 2:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* Вы можете разрешить людям проживать в Вашем доме с помощью команды {FF9900}/live");
											SendClientMessage(playerid, 0x999999FF, "* В доме могут разместиться столько гостей, сколько в нем комнат");
										}
										case 3:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* На Ваше имя была оформлена субсидия, которая дает право платить пониженную квартплату");
											SendClientMessage(playerid, 0x999999FF, "* Благодаря этому, ежедневная квартплата уменьшена в 2 раза");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "* Используйте {3399FF}/makestore {66CC00}для размещения шкафа. В нем можно будет хранить различные вещи");
											SendClientMessage(playerid, 0x999999FF, "* В любой момент можно перенести шкаф на другое место. Для открытия шкафа напишите {3399FF}/use");

											HouseStoreInit(houseid);
										}
									}
								}
								else SendClientMessage(playerid, 0xFF6600FF, "* Ошибка сохранения, повторите попытку {FF0000}(equ-code 35)");
							}
						}
					}
					ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_PROMO_LIST:
			{
				if(!response) return true;

				new idx = GetPlayerListitemValue(playerid, listitem);

				if(GetPlayerPromo(idx, PA_OWNER_ID) != GetPlayerAccountID(playerid)) return 1;
				if(GetPlayerPromo(idx, PA_STATUS) != 0) return 1;

				static query[94],
        		type_prize[9],
				id_prize[9],
				count_prize[9],
				Cache: result;

				format(query, sizeof query, "SELECT * FROM prizes_code WHERE name='%s' LIMIT 1", GetPlayerPromo(idx, PA_NAME));
				result = mysql_query(mysql, query, true);

				if(cache_num_rows())
				{
					type_prize[0] = cache_get_field_content_int(0, "type_prize_1");
					id_prize[0] = cache_get_field_content_int(0, "id_prize_1");
					count_prize[0] = cache_get_field_content_int(0, "count_prize_1");

					type_prize[1] = cache_get_field_content_int(0, "type_prize_2");
					id_prize[1] = cache_get_field_content_int(0, "id_prize_2");
					count_prize[1] = cache_get_field_content_int(0, "count_prize_2");
					
					type_prize[2] = cache_get_field_content_int(0, "type_prize_3");
					id_prize[2] = cache_get_field_content_int(0, "id_prize_3");
					count_prize[2] = cache_get_field_content_int(0, "count_prize_3");

					type_prize[3] = cache_get_field_content_int(0, "type_prize_4");
					id_prize[3] = cache_get_field_content_int(0, "id_prize_4");
					count_prize[3] = cache_get_field_content_int(0, "count_prize_4");

					type_prize[4] = cache_get_field_content_int(0, "type_prize_5");
					id_prize[4] = cache_get_field_content_int(0, "id_prize_5");
					count_prize[4] = cache_get_field_content_int(0, "count_prize_5");

					type_prize[5] = cache_get_field_content_int(0, "type_prize_6");
					id_prize[5] = cache_get_field_content_int(0, "id_prize_6");
					count_prize[5] = cache_get_field_content_int(0, "count_prize_6");

					type_prize[6] = cache_get_field_content_int(0, "type_prize_7");
       				id_prize[6] = cache_get_field_content_int(0, "id_prize_7");
       				count_prize[6] = cache_get_field_content_int(0, "count_prize_7");

   					type_prize[7] = cache_get_field_content_int(0, "type_prize_8");
   					id_prize[7] = cache_get_field_content_int(0, "id_prize_8");
   					count_prize[7] = cache_get_field_content_int(0, "count_prize_8");

   					type_prize[8] = cache_get_field_content_int(0, "type_prize_9");
   					id_prize[8] = cache_get_field_content_int(0, "id_prize_9");
    				count_prize[8] = cache_get_field_content_int(0, "count_prize_9");
				}

				cache_delete(result);

				for(new i; i < MAX_PRIZES_CODE; i++)
				{	
					if(type_prize[i] == 1) 
					{
						GivePlayerMyPrizes(playerid, "Деньги", 5, 0, 0, count_prize[i], 0);
					}
					if(type_prize[i] == 2) 
					{
						GivePlayerMyPrizes(playerid, "Донат", 10, 0, 0, count_prize[i], 0);
					}
					if(type_prize[i] == 3) 
					{
						AddPlayerData(playerid, P_EXP, +, count_prize[i]);
						UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
					}
					if(type_prize[i] == 4) 
					{
						format(query, sizeof query, "%s", ItemsInfo[id_prize[i]][i_item_name]),
						GivePlayerMyPrizes(playerid, query, 8, id_prize[i], 0, count_prize[i], 0);
					}
					if(type_prize[i] == 5) 
					{
						format(query, sizeof query, "Транспорт[№%d]", id_prize[i]),
						GivePlayerMyPrizes(playerid, query, 3, id_prize[i], 1, 1, -1);
					}
					if(type_prize[i] == 6) 
					{
						AddPlayerData(playerid, P_BIZ_SLOTS, +, count_prize[i]);
						UpdatePlayerDatabaseInt(playerid, "biz_slots", GetPlayerData(playerid, P_BIZ_SLOTS));
					}
					if(type_prize[i] == 7) 
					{
						AddPlayerData(playerid, P_HOUSE_SLOTS, +, count_prize[i]);
						UpdatePlayerDatabaseInt(playerid, "house_slots", GetPlayerData(playerid, P_HOUSE_SLOTS));
					}
					if(type_prize[i] == 8) 
					{
						AddPlayerData(playerid, P_GARAGE_SLOTS, +, count_prize[i]);
						UpdatePlayerDatabaseInt(playerid, "garage_slots", GetPlayerData(playerid, P_GARAGE_SLOTS));
					}
					if(type_prize[i] == 9) 
					{
						AddPlayerData(playerid, P_CAR_SLOTS, +, count_prize[i]);
						UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
					}
					if(type_prize[i] == 10) 
					{
						AddPlayerData(playerid, P_KIOSK_SLOTS, +, count_prize[i]);
						UpdatePlayerDatabaseInt(playerid, "kiosk_slots", GetPlayerData(playerid, P_KIOSK_SLOTS));
					}
					if(type_prize[i] == 11) 
					{
						format(query, sizeof query, "Одежда[№%d]", id_prize[i]),
						GivePlayerMyPrizes(playerid, query, 4, id_prize[i], 0, 1, 0);
					}
					if(type_prize[i] == 12) 
					{
						format(query, sizeof query, "Аксессуар[№%d]", id_prize[i]),
						GivePlayerMyPrizes(playerid, query, 6, id_prize[i], 0, 1, count_prize[i]);
					}
					if(type_prize[i] == 13 && id_prize[i] == 1) 
					{
						format(query, sizeof query, "Купон для выхода из тюрьмы Деморган (%d мин)", count_prize[i]);
						GivePlayerMyPrizes(playerid, query, 16, count_prize[i], 0, 0, 0);
					}
				}

				SCMF(playerid, 0x64be2fFF, "Вы получаете бонус за использование промокода \"%s\"", GetPlayerPromo(idx, PA_NAME));
				SCM(playerid, 0xFFFFFFFF, "Зайдите в {4a92eb}Игровое меню -> мои награды {FFFFFF}чтобы забрать вещи");

				format(query, sizeof query, "UPDATE promocode_activations SET status=-1 WHERE id=%d", GetPlayerPromo(idx, PA_ID));
				mysql_query(mysql, query, false);
				DestroyPromo(idx);
			}
			case DIALOG_HOUSE_RENTERS:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(houseid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= MAX_HOUSE_ROOMS-1)
						{
							new room = GetPlayerListitemValue(playerid, listitem);
							ShowHouseRenterInfo(playerid, houseid, room);
						}
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTER_INFO:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(houseid != -1)
				{
					if(response)
					{
						new room = GetPlayerUseListitem(playerid);
						if(IsHouseRoomOwned(houseid, room))
						{
							switch(listitem + 1)
							{
								case 4:
								{
									static fmt_str[95];
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Вы действительно хотите выселить {FFCD00}%s {FFFFFF}из своего дома?",
										GetHouseRenterInfo(houseid, room, HR_OWNER_NAME)
									);
									return Dialog(playerid, DIALOG_HOUSE_RENTER_EVICT, DIALOG_STYLE_MSGBOX, "{33AACC}Выселение арендатора", fmt_str, "Да", "Нет");
								}
							}
							ShowHouseRenterInfo(playerid, houseid, room);
						}
						else SendClientMessage(playerid, 0x999999FF, "* В этой комнате уже никто не проживает");
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTER_EVICT:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(houseid != -1)
				{
					if(response)
					{
						new room = GetPlayerUseListitem(playerid);
						if(IsHouseRoomOwned(houseid, room))
						{
							new fmt_str[64],
								renter_id = GetPlayerID(GetHouseRenterInfo(houseid, room, HR_OWNER_NAME));

							format(fmt_str, sizeof fmt_str, "Вы выселили %s из своего дома", GetHouseRenterInfo(houseid, room, HR_OWNER_NAME));
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);

							EvictHouseRenter(houseid, room, renter_id, playerid);
						}
						else SendClientMessage(playerid, 0x999999FF, "* В этой комнате уже никто не проживает");
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_EVICT:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(houseid != -1)
				{
					if(response)
					{
						new roomid = GetPlayerData(playerid, P_HOUSE_ROOM);
						new owner_id = GetPlayerID(GetHouseData(houseid, H_OWNER_NAME));

						EvictHouseRenter(houseid, roomid, playerid);

						if(owner_id != INVALID_PLAYER_ID)
						{
							static fmt_str[45 + 1];

							format(fmt_str, sizeof fmt_str, "%s выселился из Вашего дома", GetPlayerNameEx(playerid));
							SendClientMessage(owner_id, 0x66CC00FF, fmt_str);
						}
						SendClientMessage(playerid, 0x66CC00FF, "* Вы выселились из дома");
					}
				}
			}
			case DIALOG_HOUSE_MOVE_STORE:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(houseid != -1)
				{
					if(response)
					{
						if(GetPlayerInHouse(playerid) == houseid)
						{
							if(GetHouseData(houseid, H_IMPROVEMENTS) >= 4)
							{
								new type = GetHouseData(houseid, H_TYPE);
								if(IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)))
								{
									if(GetHouseData(houseid, H_STORE_LABEL) != Text3D:-1)
									{
										static query[128];

										new Float: pos_x, Float: pos_y, Float: pos_z;
										GetPlayerPos(playerid, pos_x, pos_y, pos_z);

										SetHouseData(houseid, H_STORE_X, pos_x);
										SetHouseData(houseid, H_STORE_Y, pos_y);
										SetHouseData(houseid, H_STORE_Z, pos_z);

										DestroyDynamic3DTextLabel(GetHouseData(houseid, H_STORE_LABEL));
										SetHouseData(houseid, H_STORE_LABEL, Text3D:-1);

										HouseStoreInit(houseid);

										format(query, sizeof query, "UPDATE houses SET store_x=%f,store_y=%f,store_z=%f WHERE id=%d LIMIT 1", pos_x, pos_y, pos_z, GetHouseData(houseid, H_SQL_ID));
										mysql_tquery(mysql, query, "", "");
									}
								}
							}
						}
					}
				}
			}
			case DIALOG_HOUSE_ENTER:
			{
				new houseid = GetPlayerUseListitem(playerid);
				if(houseid >= 0 && response && GetPlayerInHouse(playerid) == -1){
					if(!GetHouseData(houseid, H_LOCK_STATUS) || GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == houseid) EnterPlayerToHouse(playerid, houseid);
					else GameText(playerid, "~r~Закрыт", 3000, 2);
				}
			}
			case DIALOG_ENTRANCE_LIFT:
			{
				if(response)
				{
					new entranceid = GetPlayerInEntrance(playerid);
					if(entranceid != -1)
					{
						new floor = GetPlayerInEntranceFloor(playerid);
						if(floor != -1)
						{
							if(0 <= listitem <= MAX_ENTRANCE_FLOORS-1)
							{
								new to_floor = GetPlayerListitemValue(playerid, listitem);
								if(!to_floor)
								{
									SetPlayerPosEx(playerid, 2325.8708,-2455.3804,998.6328,178.6014, 1, entranceid + 2500);
								}
								else SetPlayerPosEx(playerid, 2326.6941,-2455.9602,1009.4453,182.0717, 1, to_floor + 1);

								SetPlayerInEntranceFloor(playerid, to_floor);
							}
						}
					}
				}
			}
			// -----------------------------------------------------------------

			// -----------------------------------------------------------------
			case DIALOG_HOTEL:
			{
				if(response)
				{
					new hotel_id = GetPlayerInHotelID(playerid);
					if(hotel_id != -1)
					{
						switch(listitem + 1)
						{
							case 1:
							{
								ShowPlayerHotelFloorsInfo(playerid, hotel_id);
							}
							case 2:
							{
								if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1)
								{
									new free_room = GetHotelFreeRoom(hotel_id);
									if(free_room != -1)
									{
										SetPlayerUseListitem(playerid, free_room);

										static fmt_str[128];
										format
										(
											fmt_str, sizeof fmt_str,
											"{FFFFFF}Мы предлагаем Вам поселиться в номере %d на %d этаже\n"\
											"Регистрация стоит 1000 рублей. Вы уверены?",
											(free_room % 12) + 1,
											(free_room / 12) + 1
										);
										Dialog(playerid, DIALOG_HOTEL_REG_ROOM, DIALOG_STYLE_MSGBOX, "{66CC99}Подтверждение регистрации", fmt_str, "Выбрать", "Назад");
									}
									else
									{
										Dialog
										(
											playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX,
											"{66CC99}Свободные номера",
											"{FFFFFF}В этой гостинице нет свободных номеров",
											"Назад", "Закрыть"
										);
									}
								}
								else
								{
									Dialog
									(
										playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX,
										"{66CC99}Регистрация",
										"{FFFFFF}Вы уже снимаете номер в гостинице",
										"Назад", "Закрыть"
									);
								}
							}
							case 3:
							{
								ShowPlayerHotelClientMenu(playerid, hotel_id);
							}
						}
					}
				}
			}
			case DIALOG_HOTEL_FLOOR_SELECT:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id != -1)
				{
					if(response)
					{
						ShowPlayerHotelFloorInfo(playerid, hotel_id, listitem);
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_FLOOR_INFO:
			{
				if(response)
				{
					ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_FLOOR_LIFT:
			{
				if(response)
				{
					new hotel_id = GetPlayerInHotelID(playerid);
					if(hotel_id != -1)
					{
						new max_floors = g_hotel_rooms_loaded[hotel_id] / 12;
						if(0 <= listitem <= max_floors-1)
						{
							new to_floor = GetPlayerListitemValue(playerid, listitem);

							if(!to_floor)
							{
								new businessid = GetPlayerInBiz(playerid);
								new type = GetBusinessData(businessid, B_INTERIOR);

								SetPlayerPosEx(playerid, 730.1479, 599.7930, 1002.9598, 89.9507, GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR), businessid + 255);
							}
							else SetPlayerPosEx(playerid, 1276.0446, -773.2361, 1202.7220, 360.0, to_floor, ((hotel_id + 1) * 200) + (to_floor + 1000));

							SetPlayerData(playerid, P_IN_HOTEL_FLOOR, to_floor);
						}
					}
				}
			}
			
			case DIALOG_HOTEL_CLIENT_MENU:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						switch(listitem + 1)
						{
							case 1: // Оплатить проживание
							{
								ShowPlayerHotelRoomPayForRent(playerid);
							}
							case 2: // Информация о транспорте
							{
								new vehicleid = GetPlayerOwnableCarLast(playerid);
								if(vehicleid != INVALID_VEHICLE_ID)
								{
									new model_id = GetVehicleData(vehicleid, V_MODELID);
									if(model_id)
									{
										static fmt_str[64];
										new index = GetVehicleData(vehicleid, V_ACTION_ID);

										format(fmt_str, sizeof fmt_str, "Модель: %s (номер модели %d)", GetVehicleName(vehicleid), model_id);
										SendClientMessage(playerid, 0x99FF66FF, fmt_str);

										if(!(GetOwnableCarData(index, OC_COLOR_1) == -1 || GetOwnableCarData(index, OC_COLOR_2) == -1))
										{
											format(fmt_str, sizeof fmt_str, "Цвет 1: ID %d   Цвет 2: ID %d", GetOwnableCarData(index, OC_COLOR_1), GetOwnableCarData(index, OC_COLOR_2));
											SendClientMessage(playerid, 0x99FF66FF, fmt_str);
										}
										else SendClientMessage(playerid, 0x99FF66FF, "Цвета транспорта: случайные");

										format(fmt_str, sizeof fmt_str, "Гос. стоимость: %d руб", GetVehicleInfo(model_id , VI_PRICE));
										SendClientMessage(playerid, 0x99FF66FF, fmt_str);
									}
								}
								else
								{
									if(GetPlayerOwnableCars(playerid) == 0)
										SendClientMessage(playerid, 0x999999FF, "* У Вас нет личного транспорта");
									else
										SendClientMessage(playerid, 0x999999FF, "* Ваш личный транспорт не загружен на сервер");
								}
							}
							case 3: // Отметить транспорт на GPS
							{
								callcmd::getmycar(playerid, "");
							}
							case 4: // Подогнать транспорт к отелю (1000 руб)
							{
								new vehicleid = GetPlayerOwnableCarLast(playerid);
								if(vehicleid != INVALID_VEHICLE_ID)
								{
									if(!SetVehicleToHotelRespawn(hotel_id, vehicleid))
									{
										SendClientMessage(playerid, 0xCECECEFF, "* В данный момент Вы не можете использовать эту функцию");
									}
								}
								else
								{
									if(GetPlayerOwnableCars(playerid) == 0)
										SendClientMessage(playerid, 0x999999FF, "* У Вас нет личного транспорта");
									else
										SendClientMessage(playerid, 0x999999FF, "* Ваш личный транспорт не загружен на сервер");
								}
							}
							case 6: // Выселиться из отеля
							{
								Dialog
								(
									playerid, DIALOG_HOTEL_OUT, DIALOG_STYLE_MSGBOX,
									"{66CC99}Выселение",
									"{FFFFFF}Вы уверены что хотите выселиться из отеля?",
									"Да", "Нет"
								);
							}
							default:
								return 1;
						}
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_PAY_FOR_ROOM:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);

				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							static fmt_str[128 + 1];

							new time = gettime();
							new rent_time = GetHotelData(hotel_id, room_id, H_RENT_DATE);

							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new total_price = days * 1000;

							if((rent_days + days) <= 7)
							{
								if(GetILPlayerInt(GetPlayerBankMoney(playerid), total_price))
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

									format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a, hotels h SET a.bank=%s,h.rent_time=%d WHERE a.id=%d AND h.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price), rent_time, GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price));
										SetHotelData(hotel_id, room_id, H_RENT_DATE, rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно проживание в отеле еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 7 дней");
						}
						ShowPlayerHotelRoomPayForRent(playerid);
					}
					else ShowPlayerHotelClientMenu(playerid, hotel_id);
				}
			}
			case DIALOG_HOTEL_OUT:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);

				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						static query[155];

						format(query, sizeof query, "UPDATE PlayersMorallwens a,hotels h SET a.house_type=-1,a.house_room=-1,h.owner_id=0,h.rent_time=0 WHERE a.id=%d AND h.id=%d", GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							SetPlayerData(playerid, P_HOUSE, 		-1);
							SetPlayerData(playerid, P_HOUSE_ROOM, 	-1);
							SetPlayerData(playerid, P_HOUSE_TYPE, 	-1);

							SetHotelData(hotel_id, room_id, H_OWNER_ID, 	0);
							SetHotelData(hotel_id, room_id, H_RENT_DATE, 	0);
							SetHotelData(hotel_id, room_id, H_STATUS, 		false);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы выселились из отеля");
						}
					}
					else ShowPlayerHotelClientMenu(playerid, hotel_id);
				}
			}
			// -----------------------------------------------------------------
		case DIALOG_BILLBOARD_INPUT1:
		{
		    new bill_id = GetPVarInt(playerid, "select_billboard");
		    static text[144];
		    static fmt_text[144];
			if(response)
			{
				new str_len = strlen(inputtext);
				if(1 <= str_len <= 25)
				{
			        format(BillInfo[bill_id][BillText_1], 25, inputtext);
			        format(text, sizeof text, "%s\n\n%s\n%s", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, text, 130, "Arial", 30, 1, bill_colors[BillInfo[bill_id][BillColor]], 0, 1);

					format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					Dialog(playerid, DIALOG_BILLBOR_SELEC_STROK, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				}
			}
			else
			{
				format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
				Dialog(playerid, DIALOG_BILLBOR_SELEC_STROK, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
			}
		}
		case DIALOG_BILLBOARD_INPUT2:
		{
		    new bill_id = GetPVarInt(playerid, "select_billboard");
		    static text[144];
		    static fmt_text[144];
			if(response)
			{
			    new str_len = strlen(inputtext);
				if(1 <= str_len <= 25)
				{
			        format(BillInfo[bill_id][BillText_2], 25, inputtext);
			        format(text, sizeof text, "%s\n\n%s\n%s", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, text, 130, "Arial", 30, 1, bill_colors[BillInfo[bill_id][BillColor]], 0, 1);
					format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					Dialog(playerid, DIALOG_BILLBOR_SELEC_STROK, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				}
			}
			else
			{
				format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
				Dialog(playerid, DIALOG_BILLBOR_SELEC_STROK, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
			}
		}
		case DIALOG_BILLBOARD_INPUT3:
		{
		    new bill_id = GetPVarInt(playerid, "select_billboard");
		    static text[144];
		    static fmt_text[144];
			if(response)
			{
			    new str_len = strlen(inputtext);
				if(1 <= str_len <= 25)
				{
			        format(BillInfo[bill_id][BillText_3], 25, inputtext);
			        format(text, sizeof text, "%s\n\n%s\n%s", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, text, 130, "Arial", 30, 1, bill_colors[BillInfo[bill_id][BillColor]], 0, 1);
					format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					Dialog(playerid, DIALOG_BILLBOR_SELEC_STROK, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				}
			}
			else
			{
				format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
				Dialog(playerid, DIALOG_BILLBOR_SELEC_STROK, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
			}
		}
		case DIALOG_BILLBORD_SELECT_COL:
		{
		    new bill_id = GetPVarInt(playerid, "select_billboard");
		    static text[144];
			if(response)
			{
				switch(listitem + 1)
				{
				    case 1:
				    {
				        BillInfo[bill_id][BillColor] = 0;
				        format(text, sizeof text, "%s\n\n%s\n%s", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
						SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, text, 130, "Arial", 30, 1, bill_colors[BillInfo[bill_id][BillColor]], 0, 1);
						SetPVarInt(playerid, "typebill3", 0);
				    }
				    case 2:
				    {
				        BillInfo[bill_id][BillColor] = 1;
				        format(text, sizeof text, "%s\n\n%s\n%s", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
						SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, text, 130, "Arial", 30, 1, bill_colors[BillInfo[bill_id][BillColor]], 0, 1);
						SetPVarInt(playerid, "typebill3", 0);
				    }
				}
			}
			else
			{
			    SetPVarInt(playerid, "typebill3", 0);
			}
		}
		case DIALOG_BILLBOR_TRK_EDIT2:
		{
			if(response)
			{
			    new bill_id = GetPVarInt(playerid, "select_billboard");
				switch(listitem + 1)
				{
				    case 1:
				    {
				        static fmt_text[144];
				        format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
				        Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				    }
				    case 2:
				    {
						Dialog(playerid, DIALOG_BILLBOARD_INPUT4, DIALOG_STYLE_INPUT, "Настройка биллборда", "{FFFFFF}Введите текст строки:", "Готово", "Назад");
				    }
				}
			}
		}
		case DIALOG_BILLBOR_TRK_EDIT3:
		{
			if(response)
			{
			    new bill_id = GetPVarInt(playerid, "select_billboard");
			    static fmt_text[144];
				switch(listitem + 1)
				{
				    case 1:
				    {
					        format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					        Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				    }
				    case 2:
				    {
						Dialog(playerid, DIALOG_BILLBOARD_INPUT5, DIALOG_STYLE_INPUT, "Настройка биллборда", "{FFFFFF}Введите текст строки:", "Готово", "Назад");
				    }
				}
			}
		}
		case DIALOG_BILLBOR_TRK_EDIT4:
		{
			if(response)
			{
			    new bill_id = GetPVarInt(playerid, "select_billboard");
			    static fmt_text[144];
				switch(listitem + 1)
				{
				    case 1:
				    {
					        format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					        Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				    }
				    case 2:
				    {
						Dialog(playerid, DIALOG_BILLBOARD_INPUT6, DIALOG_STYLE_INPUT, "Настройка биллборда", "{FFFFFF}Введите текст строки:", "Готово", "Назад");
				    }
				}
			}
		}
		case DIALOG_BILLBOARD_INPUT4:
		{
		    new bill_id = GetPVarInt(playerid, "select_billboard");
		    static fmt_text[144];
			if(response)
			{
			    new str_len = strlen(inputtext);
				if(1 <= str_len <= 25)
				{
			        format(BillInfo[bill_id][BillText_1], 25, inputtext);
					format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				}
			}
			else
			{
				format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
				Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
			}
		}
		case DIALOG_BILLBOARD_INPUT5:
		{
		    new bill_id = GetPVarInt(playerid, "select_billboard");
		    static fmt_text[144];
			if(response)
			{
			    new str_len = strlen(inputtext);
				if(1 <= str_len <= 25)
				{
			        format(BillInfo[bill_id][BillText_2], 25, inputtext);
					format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				}
			}
			else
			{
				format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
				Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
			}
		}
		case DIALOG_BILLBOARD_INPUT6:
		{
		    new bill_id = GetPVarInt(playerid, "select_billboard");
		    static fmt_text[144];
			if(response)
			{
			    new str_len = strlen(inputtext);
				if(1 <= str_len <= 25)
				{
			        format(BillInfo[bill_id][BillText_3], 25, inputtext);
					format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
					Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				}
			}
			else
			{
				format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
				Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
			}
		}
		case DIALOG_BILLBOR_TRK_EDIT:
		{
			if(response)
			{
			    new bill_id = GetPVarInt(playerid, "select_billboard");
				switch(listitem + 1)
				{
				    case 1:
				    {
						Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT2, DIALOG_STYLE_LIST, "Настройка биллборда", "Оставить строку<n>Изменить строку", "Далее", "Закрыть");
				    }
				    case 2:
				    {
						Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT3, DIALOG_STYLE_LIST, "Настройка биллборда", "Оставить строку<n>Изменить строку", "Далее", "Закрыть");
				    }
				    case 3:
				    {
						Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT4, DIALOG_STYLE_LIST, "Настройка биллборда", "Оставить строку<n>Изменить строку", "Далее", "Закрыть");
				    }
				    case 4:
				    {
				        static fmt_str[144];
				        static text[144];
						format(fmt_str, sizeof fmt_str, "Ads-%d", BillInfo[bill_id][BillType]);
						SetDynamicObjectMaterial(BillInfo[bill_id][BillID], 2, 3627, "pilorama", fmt_str, 0);
						format(text, sizeof text, "%s\n\n%s\n%s", BillInfo[bill_id][BillText_1], BillInfo[bill_id][BillText_2], BillInfo[bill_id][BillText_3]);
						SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, text, 130, "Arial", 30, 1, bill_colors[BillInfo[bill_id][BillColor]], 0, 1);
		                format(fmt_str, sizeof fmt_str, "Ваша реклама успешно размещена на биллборде {FFFFFF}№%d.",bill_id + 1);
		                SCM(BillInfo[bill_id][BillOwnerID], 0xFFA500FF,fmt_str);
		                GivePlayerMoneyEx(playerid, 10000, "зп трк", true, true);
		                BillInfo[bill_id][BillStatus] = 1;
				    }
				    case 5:
				    {
				        static fmt_str[144];
		                format(fmt_str, sizeof fmt_str, "Реклама на биллборде {FFFFFF}№%d {FFA500}была отказана.",bill_id + 1);
		                SCM(BillInfo[bill_id][BillOwnerID], 0xFFA500FF,fmt_str);
					    GivePlayerMoneyEx(BillInfo[bill_id][BillOwnerID], 30000, "аренда биллборда", true, true);
						format(fmt_str, sizeof fmt_str, "Ads-0");
						SetDynamicObjectMaterial(BillInfo[bill_id][BillID], 2, 3627, "pilorama", fmt_str, 0);
						BillInfo[bill_id][BillStatus] = 0;
						BillInfo[bill_id][BillArendaTime] = 0;
						BillInfo[listitem][BillStatus] = 0;
						BillInfo[bill_id][BillOwnerID] = -1;
				    }
				}
			}
		}
		case DIALOG_BILLBOR_SELEC_STROK:
		{
			if(response)
			{
				switch(listitem + 1)
				{
				    case 1:
				    {
						Dialog(playerid, DIALOG_BILLBOARD_INPUT1, DIALOG_STYLE_INPUT, "Настройка биллборда", "{FFFFFF}Введите текст строки:", "Готово", "Назад");
				    }
				    case 2:
				    {
						Dialog(playerid, DIALOG_BILLBOARD_INPUT2, DIALOG_STYLE_INPUT, "Настройка биллборда", "{FFFFFF}Введите текст строки:", "Готово", "Назад");
				    }
				    case 3:
				    {
						Dialog(playerid, DIALOG_BILLBOARD_INPUT3, DIALOG_STYLE_INPUT, "Настройка биллборда", "{FFFFFF}Введите текст строки:", "Готово", "Назад");
				    }

				}
			}
			else
			{
			    SetPVarInt(playerid, "typebill2", 0);
			}
		}
		case DIALOG_BILLBOARD_SELECT:
		{
			if(response)
			{
			    SetPVarInt(playerid, "select_billboard", listitem);
			    if(BillInfo[listitem][BillStatus] == 0)
			    {
			    	Dialog(playerid, DIALOG_BILLBOARD_ARENDA, DIALOG_STYLE_MSGBOX, "Аренда биллборда", "Хотите арендовать этот биллборд?", "Да", "Назад");
			    }
			    else if(BillInfo[listitem][BillStatus] == 1)
			    {
					SCM(playerid, -1,"Данный билборд арендован или его настраивают!");
				}
				else if(BillInfo[listitem][BillStatus] == 2)
				{
				    if(GetPlayerTeamEx(playerid) == TEAM_RADIO)
				    {
				        if(4 <= GetPlayerJobName(playerid) <= 10)
				        {
				            static fmt_text[144];
					        format(fmt_text, sizeof fmt_text, "%s<n>%s<n>%s<n>Разместить рекламу<n>Отказать размещать рекламу<n>", BillInfo[listitem][BillText_1], BillInfo[listitem][BillText_2], BillInfo[listitem][BillText_3]);

					        Dialog(playerid, DIALOG_BILLBOR_TRK_EDIT, DIALOG_STYLE_LIST, "Выберите строку", fmt_text, "Далее", "Закрыть");
				        }
				    }
				}


			}
		}
		case DIALOG_BILLBOARD_ARENDA1:
		{
			if(response)
			{
			    new bill_id = GetPVarInt(playerid, "select_billboard");
		    	new time = strval(inputtext);
			    if(!(2 <= time <= 10)) return MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('GameText').add('[2,\"~r~ Допустимый срок: от 2 до 10 часов.\",5000,0,-1,1]')");

			    BillInfo[bill_id][BillArendaTime] = time;


			}
			else
			{
			    SetPVarInt(playerid, "typebill4", 0);
			}
		}
		case DIALOG_BILLBOARD_ARENDA2:
		{
			if(response)
			{
			    new bill_id = GetPVarInt(playerid, "select_billboard");
                SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, "Свободный биллборд\n\nДля аренды обратитесь в организацию\n\"ТРК Ритм\" или нажмите N\n", 130, "Arial", 30, 1, 0xFFFFFFFF, 0, 1);
                static fmt_str[144];
				format(fmt_str, sizeof fmt_str, "Ads-0");
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Billboard");
				SetDynamicObjectMaterial(BillInfo[bill_id][BillID], 2, 3627, "pilorama", fmt_str, 0);
                BillInfo[bill_id][BillStatus] = 2;
                BillInfo[bill_id][BillOwnerID] = playerid;
                format(fmt_str, sizeof fmt_str, "Вы успешно арендовали биллборд {FFFFFF}№%d {FFA500}за {FFFFFF}30000 рублей. {FFA500}Ожидайте одобрения ТРК для размещения постера",bill_id + 1);
                SCM(playerid, 0xFFA500FF,fmt_str);
                SetCameraBehindPlayer(playerid);
                GivePlayerMoneyEx(playerid, -30000, "аренда биллборда", true, true);
		        SetPlayerPos(playerid, GetPVarFloat(playerid, "pos_x"), GetPVarFloat(playerid, "pos_y"), GetPVarFloat(playerid, "pos_z"));
		        SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "player_world"));
		        SetPlayerInterior(playerid, GetPVarInt(playerid, "player_int"));
			}
			else
			{
			    SetPVarInt(playerid, "typebill5", 0);
			}
		}
		case DIALOG_BILLBOARD_ARENDA:
		{
			if(response)
			{
			    new bill_id = GetPVarInt(playerid, "select_billboard");

			    if(-200 <= BillInfo[bill_id][BillRotZ] <= -100)
			    {
				    SetPlayerCameraPos(playerid, BillInfo[bill_id][BillPosX] - 7, BillInfo[bill_id][BillPosY] - 2, BillInfo[bill_id][BillPosZ] + 3);
					SetPlayerCameraLookAt(playerid, BillInfo[bill_id][BillPosX], BillInfo[bill_id][BillPosY], BillInfo[bill_id][BillPosZ] + 3, 2);
			    }
			    else if(100 <= BillInfo[bill_id][BillRotZ] <= 200)
			    {
				    SetPlayerCameraPos(playerid, BillInfo[bill_id][BillPosX] - 7, BillInfo[bill_id][BillPosY] + 2, BillInfo[bill_id][BillPosZ] + 3);
					SetPlayerCameraLookAt(playerid, BillInfo[bill_id][BillPosX], BillInfo[bill_id][BillPosY], BillInfo[bill_id][BillPosZ] + 3, 2);
			    }
			    else if(0 <= BillInfo[bill_id][BillRotZ] <= 90)
			    {
				    SetPlayerCameraPos(playerid, BillInfo[bill_id][BillPosX], BillInfo[bill_id][BillPosY] + 8, BillInfo[bill_id][BillPosZ] + 3);
					SetPlayerCameraLookAt(playerid, BillInfo[bill_id][BillPosX], BillInfo[bill_id][BillPosY], BillInfo[bill_id][BillPosZ] + 3, 2);
			    }
			    else if(-90 <= BillInfo[bill_id][BillRotZ] <= -0)
			    {
				    SetPlayerCameraPos(playerid, BillInfo[bill_id][BillPosX], BillInfo[bill_id][BillPosY] - 8, BillInfo[bill_id][BillPosZ] + 3);
					SetPlayerCameraLookAt(playerid, BillInfo[bill_id][BillPosX], BillInfo[bill_id][BillPosY], BillInfo[bill_id][BillPosZ] + 3, 2);
			    }

			    new inter, world, Float:X, Float:Y, Float:Z, Float:FA;
//		     	new Float:health;
				GetPlayerPos(playerid, X, Y, Z);
				GetPlayerFacingAngle(playerid, FA);
				inter = GetPlayerInterior(playerid);
				world = GetPlayerVirtualWorld(playerid);

				SetPVarFloat(playerid, "pos_x", X);
				SetPVarFloat(playerid, "pos_y", Y);
				SetPVarFloat(playerid, "pos_z", Z);
				SetPVarFloat(playerid, "angle", FA);
				SetPVarInt(playerid, "player_int", inter);
				SetPVarInt(playerid, "player_world", world);

		        SetPlayerPos(playerid, BillInfo[bill_id][BillPosX], BillInfo[bill_id][BillPosY], BillInfo[bill_id][BillPosZ]);
		        SetPlayerVirtualWorld(playerid, playerid+1);

                BillInfo[bill_id][BillStatus] = 1;
                format(BillInfo[bill_id][BillText_1], 25, "Пустая строка");
                format(BillInfo[bill_id][BillText_2], 25, "Пустая строка");
                format(BillInfo[bill_id][BillText_3], 25, "Пустая строка");
                BillInfo[bill_id][BillColor] = 0;
                BillInfo[bill_id][BillArendaTime] = 0;
                BillInfo[bill_id][BillOwnerID] = -1;
				SetDynamicObjectMaterialText(BillInfo[bill_id][BillIDText], 0, "\nВведите свой текст", 130, "Arial", 30, 1, 0xFFFFFFFF, 0, 1);
			    MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Billboard", "[\"Фон\", \"Текст\", \"Цвет текста\", \"Длительность аренды\", \"Подтвердить и оплатить\"]");
			}
			else
			{
				callcmd::billboards(playerid);
			}
		}
		case DIALOG_OWNABLE_CAR:
		{
			if(response)
			{
				new idx = GetPVarInt(playerid, "ownablecar_id");
				new vehicleid = INVALID_VEHICLE_ID;

                for(new i = 0; i < MAX_VEHICLES; i++)
				{
				    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				    {
					    new iddx = GetVehicleData(i, V_ACTION_ID);
				        if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
				        {
				            vehicleid = i;
				        }
			        }

				}
				if(vehicleid != INVALID_VEHICLE_ID)
				{
					switch(listitem + 1)
					{
						case 1: // Открыть / закрыть
						{
						    SetPVarInt(playerid, "go_list", 1);
							callcmd::lock(playerid, "1");
						}
						case 2: // Вставить / вытащить ключи
						{
						    SetPVarInt(playerid, "go_list", 1);
							callcmd::key(playerid, "");
						}
						case 3: // Отметить транспорт на GPS
						{
						    SetPVarInt(playerid, "go_list", 1);
							callcmd::getmycar(playerid, "");
						}
						case 4: // Содержимое багажника
						{
							//ShowTrunkDialog(playerid, vehicleid, true);
						}
						case 5: // Документы на транспорт
						{
							ShowOwnableCarPass(playerid, vehicleid);
							SetPVarInt(playerid, "owenrname", playerid);
						}
						case 6: // Припарковать транспорт
						{
							callcmd::park(playerid, "");
						}
						case 7: // Выгрузить транспорт
						{
							if(UnloadPlayerOwnableCar(true, vehicleid))
								SendClientMessage(playerid, 0x66CC33FF, "Ваш транспорт успешно выгружен!");

							else
								SendClientMessage(playerid, 0x999999FF, "* С момента загрузки данного транспорта еще не прошло 1 минуты");
						}
						default:
							return 1;
					}
					//callcmd::car(playerid, "");
				}
			}
		}
		case DIALOG_OWNABLE_CAR_LOAD:
		{
			if(response)
			{
				new idx = GetPVarInt(playerid, "ownablecar_id"),
					Float: x,
					Float: y,
					Float: z,
					stoyanka,
					Cache: result,
					query[500];

				mysql_format(mysql, query, sizeof query, "SELECT pos_x, pos_y, pos_z,stoyanka FROM ownable_cars WHERE id='%d'", idx);
				result = mysql_query(mysql, query, true);

				if(cache_num_rows())
				{
					x = cache_get_row_float(0, 0);
					y = cache_get_row_float(0, 1);
					z = cache_get_row_float(0, 2);
					stoyanka = cache_get_field_content_int(0, "stoyanka");
				}

				cache_delete(result);

				switch(listitem + 1)
				{
					case 1:
					{
						if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
						{
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 3000))
							{
								GivePlayerMoneyEx(playerid, -300, "Метка ТС на GPS", true, true);

								EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего транспорта отмечено на GPS");
								return 1;
							}
							else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* На Вашем GPS уже отмечено место");
					}
					case 2:
					{
						//if(GetPlayerOwnableCarListitem(playerid) != INVALID_VEHICLE_ID)
						//{
							//SendClientMessage(playerid, 0x999999FF, "* Системная ошибка. Транспорт уже загружен.");
							//return 1;
						//}
                        if(stoyanka == 2234) return SCM(playerid, 0x999999FF ,"Ваш транспорт на штрафстоянке");

						if(vehicle_house_id[playerid] != idx)
						{
							if(LoadOwnableCar(playerid, idx) != -1)
							{
								PlayerOwnableCarInit(playerid, GetPVarInt(playerid, "listitem_car"));
								SendClientMessage(playerid, 0x66CC33FF, "Ваш транспорт успешно загружен!");
							}
							else SendClientMessage(playerid, 0x999999FF, "* Ошибка при загрузке личного транспорта");
						}
						else
						{
							if(LoadOwnableCar(playerid, idx) != -1)
							{
								PlayerOwnableCarInit(playerid, GetPVarInt(playerid, "listitem_car"));
								SendClientMessage(playerid, 0x66CC33FF, "Ваш транспорт успешно загружен!");

								//SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
								//LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
							}
							else SendClientMessage(playerid, 0x999999FF, "* Ошибка при загрузке личного транспорта");
						}
					}
					case 3:
					{
					    if (!GetILPlayerInt(GetPlayerMoneyEx(playerid), 5000)) 
					        return SCM(playerid, -1, "* Недостаточно средств");

					    GivePlayerMoneyEx(playerid, -5000, "Доставка транспорта на штрафстоянку", true, true);

					    new Float:posX, Float:posY, Float:posZ, Float:angle;
					    switch (random(2))
					    {
					        case 0:
					        {
					            posX = -286.3826;
					            posY = 1092.5796;
					            posZ = 11.7934;
					            angle = 268.9394;
					        }
					        case 1:
					        {
					            posX = 2519.7935;
					            posY = -2348.9866;
					            posZ = 21.7718;
					            angle = 179.4471;
					        }
					    }

					    format(query, sizeof query, "UPDATE ownable_cars SET stoyanka = '1',pos_x=%f,pos_y=%f,pos_z=%f,angle=%f WHERE id=%d LIMIT 1", posX, posY, posZ, angle, idx);
					    mysql_tquery(mysql, query, "", "");

					    SCM(playerid, 0x66CC33FF, "Ваш транспорт успешно доставлен на штрафстоянку");
					}
				}
			}
			else
			{
				if(GetPVarInt(playerid, "show_menu"))
				{
					DeletePVar(playerid, "show_menu");
					callcmd::car(playerid, "");
				}
			}
		}
		case DIALOG_FEDERAL_PROSLYSH:
		{
			if(!IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_GREY, "Для использования данной функции вы должны находиться в служебном Т/С");
			new vehicleid = GetPlayerVehicleID(playerid);
			new modelid = GetVehicleData(vehicleid, V_MODELID);
			if(modelid != 416 && modelid != 599) return SCM(playerid, COLOR_GREY, "Для использования данной функции вы должны находиться в служебном Т/С");
			switch(listitem+1)
			{
				case 1:
				{
					if(fproslush_type != 0) return SCM(playerid, COLOR_GREY, "Кто-то уже подключён с прослушиванию рации. На линии прослушивания может находиться только 1 сотрудник.");
					Dialog(playerid, DIALOG_RPROSLUH, DIALOG_STYLE_LIST, "Прослушивание, выберите организацию:",
					"Правительство\n"\
					"Мин.Обороны\n"\
					"Мин.Здравоохранения\n"\
					"ТРК 'Ритм'\n"\
					"МВД\n"\
					"ФСИН",
					"Выбрать", "Отмена");
				}
				case 2:
				{
					fproslush_type = 0;
					fproslush = 0;
					federal_prosluh[playerid] = 0;
					Action(playerid, "отключился(ась) от прослушивания", _, false);
				}
			}
		}
		case DIALOG_RPROSLUH:
		{
			switch(listitem+1)
			{
				case 1:
				{
					fproslush_type = playerid;
					fproslush = 1;
					federal_prosluh[playerid] = 1;
					SCM(playerid, 0x8fd393FF, "Вы подключились к закрытому каналу \"Правительство\"");
				}
				case 2:
				{
					fproslush_type = playerid;
					fproslush = 1;
					federal_prosluh[playerid] = 2;
					SCM(playerid, 0x8fd393FF, "Вы подключились к закрытому каналу \"Мин. Обороны\"");
				}
				case 3:
				{
					fproslush_type = playerid;
					fproslush = 1;
					federal_prosluh[playerid] = 3;
					SCM(playerid, 0x8fd393FF, "Вы подключились к закрытому каналу \"Мин. Здравоохранения\"");
				}
				case 4:
				{
					fproslush_type = playerid;
					fproslush = 1;
					federal_prosluh[playerid] = 4;
					SCM(playerid, 0x8fd393FF, "Вы подключились к закрытому каналу \"ТРК 'Ритм'\"");
				}
				case 5:
				{
					fproslush_type = playerid;
					fproslush = 1;
					federal_prosluh[playerid] = 6;
					SCM(playerid, 0x8fd393FF, "Вы подключились к закрытому каналу \"Мин. Внутренних Дел\"");
				}
				case 6:
				{
					fproslush_type = playerid;
					fproslush = 1;
					federal_prosluh[playerid] = 7;
					SCM(playerid, 0x8fd393FF, "Вы подключились к закрытому каналу \"ФСИН\"");
				}
			}
		}
		case DIALOG_OWNABLE_CAR_SELECT:
		{
			if(response)
			{
				static fmt_text[144],
					Cache: result;
				new to_player = GetPVarInt(playerid, "to_player");
				new id = GetPlayerListitemValue(playerid, listitem);


				mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM ownable_cars WHERE id='%d'", id);
				result = mysql_query(mysql, fmt_text, true);

				new rows = cache_num_rows();

				for(new i = 0; i < rows; i ++)
				{
					new vehicleid = INVALID_VEHICLE_ID;

					for(new is = 0; is < MAX_VEHICLES; is++)
					{
						if(GetVehicleData(is, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
						{
							new iddx = GetVehicleData(is, V_ACTION_ID);
							if(GetOwnableCarData(iddx,OC_SQL_ID) == id)
							{
								vehicleid = is;
							}
						}

					}
					if(vehicleid != INVALID_VEHICLE_ID)
					{
						new Float: x, Float: y,Float: z;

						GetPlayerPos(to_player, x, y, z);

						SetVehiclePos(vehicleid, x + 2.0, y + 2.0, z);

						format(fmt_text, sizeof fmt_text, "Вы успешно телепортировали свой личный ТС", GetPlayerNameEx(playerid));
						SCM(to_player, 0xFFFF00FF, fmt_text);

						if(GetPlayerYAdminEx(playerid) >= 2)
						{
							format(fmt_text, sizeof fmt_text, "[Y] %s[%d] телепортировал к %s[%d] его личный транспорт", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
							SendMessageToAdmins(fmt_text, 0x999999FF);
						}

					}
					else
					{
						LoadOwnableCar(to_player, id);
						for(new is = 0; is < MAX_VEHICLES; is++)
						{
							if(GetVehicleData(is, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
							{
								new iddx = GetVehicleData(is, V_ACTION_ID);
								if(GetOwnableCarData(iddx,OC_SQL_ID) == id)
								{
									vehicleid = is;
								}
							}

						}
						new Float: x, Float: y,Float: z;

						GetPlayerPos(to_player, x, y, z);
						SetVehiclePos(vehicleid, x + 2.0, y + 2.0, z);

						format(fmt_text, sizeof fmt_text, "Вы успешно телепортировали свой личный ТС", GetPlayerNameEx(playerid));
						SCM(to_player, 0xFFFF00FF, fmt_text);
						if(GetPlayerYAdminEx(playerid) >= 2)
						{
							format(fmt_text, sizeof fmt_text, "[Y] %s[%d] телепортировал к %s[%d] его личный транспорт", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
							SendMessageToAdmins(fmt_text, 0x999999FF);
						}
					}
				}

				cache_delete(result);

			}
		}

        case DIALOG_PRIZE:
		{
			if(!response) return 1;

			new id = GetPVarInt(playerid, "id_priz");

			new fmt_text[84],
				Cache: result;
				
			format(fmt_text, sizeof fmt_text, "SELECT * FROM prizes WHERE id='%d'", id);
			result = mysql_query(mysql, fmt_text, true);

			new size = cache_get_field_content_int(0, "size");
			new item = cache_get_field_content_int(0, "item");
			new count = cache_get_field_content_int(0, "count");
			new indx = cache_get_field_content_int(0, "indx");

			cache_delete(result);

			//size - Это тип предмета (0 - значек вопроса | 1 - оружие | 2 - ехp | 3 - авто | 4 - скин | 5 - деньги | 6 - аксессуар | 7 - вип | 8 - предмет | 9 - патроны | 10 - донат)

			if(size == 3)
			{
				if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) return GameText(playerid, "~r~Все слоты для транспорта~n~заняты", 3000, 2);
				GiveCar(playerid, item, 1, 1, indx, 0, 110.8994,322.3508,11.2202,251.4996, gettime());
			}
			if(size == 4)
			{
				if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~В вашем инвентаре~n~нет свободного места", 3000, 2);
				GiveSkin(playerid, item);
			}
			if(size == 5)
			{	
				GivePlayerMoneyEx(playerid, count, "Получение денег с моих наград");
			}
			if(size == 6)
			{
				if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~В вашем инвентаре~n~нет свободного места", 3000, 2);
				GiveAcs(playerid, item, indx);
			}
			if(size == 8)
			{
				if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~В вашем инвентаре~n~нет свободного места", 3000, 2);
				GiveIteam(playerid, item, 1, count, 0, "Забрал с моих наград [Мои награды]");
			}
			if(size == 10) GivePlayerDonate(playerid, count, "Получение доната с моих наград", true, true);
			if(size == 16) 
			{
				if(GetPlayerData(playerid, P_JAIL) > 0)
				{
					if((GetPlayerData(playerid, P_JAIL) / 60) > item)
					{
						AddPlayerData(playerid, P_JAIL, -, item * 60);
						UpdatePlayerDatabaseInt(playerid, "jail", GetPlayerData(playerid, P_JAIL));
					}
					else
					{
						SetPlayerData(playerid, P_JAIL, 0);
						UpdatePlayerDatabaseInt(playerid, "jail", GetPlayerData(playerid, P_JAIL));

						SendClientMessage(playerid, 0x66CC00FF, "* Срок заключения закончился"),
						UnjailPlayer(playerid);
					}
				}
				else 
				{
					SCM(playerid, COLOR_GREY, "* Для активации купона вы должны находится в Деморгане.");
					GameText(playerid, "Для активации купона ~n~вы должны находится в Деморгане", 3000, 2);
					return true;
				}

			}

			GameText(playerid, "~g~Успешно", 4000, 2);
			SCM(playerid, 0x5DA130FF, "Награда была добавлена на Ваш аккаунт.");

			format(fmt_text, sizeof fmt_text, "DELETE FROM prizes WHERE id='%d'", id);
			mysql_query(mysql, fmt_text, false);

			LoadMainMenu(playerid, MAIN_MENU_PRIZE);
		}
		case DIALOG_OWNABLE_CAR_SPAWN:
		{
			if(!response) return 1;

			new idx = GetPlayerListitemValue(playerid, listitem);

			SetPVarInt(playerid, "listitem_car", listitem);
			SetPVarInt(playerid, "ownablecar_id", idx);

			new veh_id = INVALID_VEHICLE_ID;

			for(new i = 0; i < MAX_VEHICLES; i++)
			{
				if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				{
					new iddx = GetVehicleData(i, V_ACTION_ID);
					if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
					{
						veh_id = i;
					}
				}
			}

			if(veh_id == INVALID_VEHICLE_ID) 
			{
				SCM(playerid, 0x999999FF, "* Данный транспорт не загружен на сервер");
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, "SelectSpawn");
				return true;
			}
			new model_id = GetVehicleData(veh_id, V_MODELID);

			for(new i; i < sizeof g_vehicle_house; i++)
			{
				if(g_vehicle_house[i] != model_id) continue;

				SetPlayerData(playerid, P_ID_SPAWN, idx);
				UpdatePlayerDatabaseInt(playerid, "id_spawn", idx);

				SetPlayerData(playerid, P_SPAWN, 5);
				UpdatePlayerDatabaseInt(playerid, "setting_spawn", 5);
				SendClientMessage(playerid, 0x3399FFFF, "* Место появления в игре изменено");
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, "SelectSpawn");

				return true;
			}
			SCM(playerid, COLOR_GREY, "* Данный транспорт не предназначен для спавна");
			MoralPacket_1(playerid, s_CefInterface, t_CefHide, "SelectSpawn");
		}
		case DIALOG_OWNABLE_CAR_NUMBER:
		{
			if(!response) return 1;

			new idx = g_player_listitem[playerid][listitem];

			SetPVarInt(playerid, "listitem_car", listitem);
			SetPVarInt(playerid, "ownablecar_id", idx);

			new vehicleid = INVALID_VEHICLE_ID;

			for(new i = 0; i < MAX_VEHICLES; i++)
			{
				if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				{
					new iddx = GetVehicleData(i, V_ACTION_ID);
					if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
					{
						vehicleid = i;
					}
				}
			}

			if(vehicleid != INVALID_VEHICLE_ID)
			{
				new index = GetVehicleData(vehicleid, V_ACTION_ID);
				if(GetOwnableCarData(index, OC_NUMBER_STATUS) == 0)
				{
					InterfaceShowNumberBuy(playerid, true);
					SetPVarInt(playerid, "ownablecar_id", vehicleid);
				}
				else
				{
					SCM(playerid, COLOR_GREY, "*На данный транспорт уже выдавались номера");
				}
			}
			else
			{
				SendClientMessage(playerid, 0xFF6600FF, "* Ваш личный ТС должен находиться на сервере");
			}
		}
		case DIALOG_SELL_CAR:
		{
			if(!response) return 1;

			new idx = GetPlayerListitemValue(playerid, listitem);

			SetPVarInt(playerid, "listitem_car", listitem);
			SetPVarInt(playerid, "ownablecar_id", idx);

			new vehicleid = INVALID_VEHICLE_ID;

			for(new i = 0; i < MAX_VEHICLES; i++)
			{
				if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				{
					new iddx = GetVehicleData(i, V_ACTION_ID);
					if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
					{
						vehicleid = i;
					}
				}
			}

			if(vehicleid != INVALID_VEHICLE_ID)
			{
				new model_id = GetVehicleData(vehicleid, V_MODELID);
				if(model_id)
				{
					string_dialog[0] = EOS;

					new price = GetVehicleInfo(model_id, VI_PRICE);
					new percent_default = price / 100 * 30;
					new percent = price / 150 * GetVehicleData(vehicleid, V_IZNOS);

					format
					(
						string_dialog, sizeof string_dialog,
						"Модель:\t%s (№%d)\n"\
						"Вы получите:\t%s руб\n\n"\
						"Вы уверены что хотите утилизировать ТС?\n"\
						"Все предметы из багажника будут удалены\n"\
						"На Ваш банковский счет будет начислено %s руб\n\n"\
						"Если двигатель изношен не полностью, то\n"\
						"Вы также можете продать ТС другому игроку,\n"\
						"{008000}используя команду /sellmycar",
						GetVehicleName(vehicleid),
						model_id,
						formatInt(price - (percent + percent_default)),
						formatInt(price - (percent + percent_default))
					);
					Dialog(playerid, DIALOG_OWNABLE_CAR_SELL, DIALOG_STYLE_MSGBOX, "Утилизация личного транспорта", string_dialog, "Да", "Нет");
				}
			}
			else
			{
				if(GetPlayerOwnableCars(playerid) == 0) SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет личного транспорта");
				else SendClientMessage(playerid, 0xFF6600FF, "* Данный транспорт не загружен на сервер");
			}
		}
		case DIALOG_SELL_OWNABLE_CAR:
		{
			if(!response) return 1;

			new idx = GetPlayerListitemValue(playerid, listitem);

			SetPVarInt(playerid, "listitem_car", listitem);
			SetPVarInt(playerid, "ownablecar_id", idx);

			new veh_id = INVALID_VEHICLE_ID;

			for(new i = 0; i < MAX_VEHICLES; i++)
			{
				if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				{
					new iddx = GetVehicleData(i, V_ACTION_ID);
					if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
					{
						veh_id = i;
					}
				}
			}

			if(veh_id == INVALID_VEHICLE_ID) return SCM(playerid, 0x999999FF, "* Данный транспорт не загружен на сервер");

			//new price = GetPVarInt(playerid, "SellCarPrice");
			new to_player = GetPVarInt(playerid, "SellCarTo_player");

			new Float: car_x, Float: car_y, Float: car_z;
			GetVehiclePos(veh_id, car_x, car_y, car_z);

			if(IsPlayerInRangeOfPoint(playerid, 15.0, car_x, car_y, car_z) && IsPlayerInRangeOfPoint(to_player, 15.0, car_x, car_y, car_z))
			{
				SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_OWNABLE_CAR, 1, veh_id);
			}
			else SendClientMessage(playerid, 0xCECECEFF, "* Вы и покупатель должны находиться около ТС");
		}
		case DIALOG_OWNABLE_CAR_LIST:
		{
			if(response)
			{
				new idx = g_player_listitem[playerid][listitem];

				SetPVarInt(playerid, "listitem_car", listitem);
				SetPVarInt(playerid, "ownablecar_id", idx);

				new veh_id = INVALID_VEHICLE_ID;

                for(new i = 0; i < MAX_VEHICLES; i++)
				{
				    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				    {
					    new iddx = GetVehicleData(i, V_ACTION_ID);
				        if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
				        {
				            veh_id = i;
				        }
			        }

				}


				if(veh_id == INVALID_VEHICLE_ID)
				{
					ShowOwnableCarLoadDialog(playerid, idx, true);
				}
				else
				{
					Dialog
					(
						playerid, DIALOG_OWNABLE_CAR, DIALOG_STYLE_LIST,
						"{0099FF}Система управления транспортом",
						"1. {669900}Открыть {FFFFFF}или {FF3300}закрыть {FFFFFF}транспорт\n"\
						"2. Вставить / вытащить ключи\n"\
						"3. Отметить транспорт на GPS {FF6600}(5000 руб)\n"\
						"4. Содержимое багажника\n"\
						"5. Документы на транспорт\n"\
						"{888888}6. Припарковать транспорт\n"\
						"{888888}7. Выгрузить транспорт с сервера",
						"Выбрать", "Закрыть"
					);
				}
			}
		}

		case DIALOG_PNEWMA_BUY:
		{
		    if(!response) return 1;

		    new vehicleid = GetPlayerVehicleID(playerid);
		    new index = GetVehicleData(vehicleid, V_ACTION_ID);
		    new modelid = GetVehicleData(vehicleid, V_MODELID);

		    if(GetVehicleHandlingID(modelid) == -1) 
		        return GameText(playerid, "~r~На данный транспорт невозможно установить пневму", 3000, 1);

		    if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 30000000)) 
		        return SendClientMessage(playerid, 0x999999FF, "* Недостаточно средств!");

		    GivePlayerMoneyEx(playerid, -30000000, "Покупка пневмы", true, true);

		    SetOwnableCarData(index, OC_PNEWMA, 1);

		    static fmt_text[256];
		    mysql_format(mysql, fmt_text, sizeof(fmt_text),
		        "UPDATE ownable_cars SET pnewma=1 WHERE id=%d LIMIT 1",
		        GetOwnableCarData(index, OC_SQL_ID)
		    );
		    mysql_query(mysql, fmt_text, false);

		    SaveOwnableCar(vehicleid);

		    SetPlayerVirtualWorld(playerid, 0);
		    SetVehicleVirtualWorld(vehicleid, 0);
		    SetVehiclePos(vehicleid, -391.2581,1015.6972,11.9239);
		    SetVehicleZAngle(vehicleid, 268.5155);
		    SetCameraBehindPlayer(playerid);

		    TogglePlayerControllable(playerid, 1);

		    SpeedometrShowForPlayer(playerid);

		    SCM(playerid, 0xFFFFFFFF, "Вы установили на свой автомобиль пневматическую подвеску за {c07700}30.000.000 RUB{FFFFFF}.");
		    SCM(playerid, 0xFFFFFFFF, "Управление подвеской доступно через специальный пульт: {c8c993}/spanel{FFFFFF}.");
		    MoralPacket_1(playerid, s_CefInterface, t_CefHide, "TuningPneuma");
		}
        case DIALOG_BIZ_CAR_SELL:
		{
			if(response)
			{
				new vehicleid = GetPVarInt(playerid, "vehicleid");
				if(vehicleid != INVALID_VEHICLE_ID)
				{
					new model_id = GetVehicleData(vehicleid, V_MODELID);

					if(DestroyRentCar(vehicleid))
					{
						static fmt_str[128];

						new car_price = GetVehicleInfo(model_id, VI_PRICE);
						new percent = car_price * 20 / 100;
						new price = car_price - percent;
					
						format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), price));

						BankLog(playerid, price, "продажа тс аренды");

						format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens SET bank=%s WHERE id=%d LIMIT 1", GetPlayerBankMoney(playerid), GetPlayerAccountID(playerid));
						mysql_query(mysql, fmt_str, false);

						SendClientMessage(playerid, 0x3399FFFF, "* Вы продали транспорт со своей аренды авто");

						format(fmt_str, sizeof fmt_str, "Налоговый сбор составляет 30 процентов от его стоимости {FF9900}(%d руб)", percent);
						SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

						format(fmt_str, sizeof fmt_str, "На основной банковский счет переведено {FFFF00}%d руб", price);
						SendClientMessage(playerid, 0x66CC00FF, fmt_str);

						format(fmt_str, sizeof fmt_str, "~g~+%d rub", price);
						GameText(playerid, fmt_str, 4000, 2);
					}
				}
			}
		}
		case DIALOG_OWNABLE_CAR_SELL:
		{
			if(!response) return 1;
			
			new idx = GetPVarInt(playerid, "ownablecar_id");

			new vehicleid = INVALID_VEHICLE_ID;

			for(new i = 0; i < MAX_VEHICLES; i++)
			{
				if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
				{
					new iddx = GetVehicleData(i, V_ACTION_ID);
					if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
					{
						vehicleid = i;
					}
				}
			}

			if(vehicleid != INVALID_VEHICLE_ID)
			{
				new model_id = GetVehicleData(vehicleid, V_MODELID);

				if(DestroyOwnableCar(vehicleid))
				{
					static fmt_str[128];

					new car_price = GetVehicleInfo(model_id, VI_PRICE);
					new percent = car_price / 150 * GetVehicleData(vehicleid, V_IZNOS);
					new percent_default = car_price / 100 * 30;
					new price = car_price - (percent + percent_default);

					format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), price));

					format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens SET bank=%s WHERE id=%d LIMIT 1", GetPlayerBankMoney(playerid), GetPlayerAccountID(playerid));
					mysql_query(mysql, fmt_str, false);

					BankLog(playerid, price, "Продажа личного транспорта");

					SendClientMessage(playerid, 0x3399FFFF, "* Вы утилизировали личный транспорт");

					format(fmt_str, sizeof fmt_str, "На основной банковский счет переведено {FFFF00}%s руб", formatInt(price));
					SendClientMessage(playerid, 0x66CC00FF, fmt_str);
				}
			}
		}
			case DIALOG_OWNABLE_BIZ_NOTARY:
			{
				if(response)
				{
					new idx = GetPlayerListitemValue(playerid, listitem) + 1;
					SetPVarInt(playerid, "ownablebiz_id", idx);
					new businessid = GetPVarInt(playerid, "ownablebiz_id");
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Trade').updateData('{\"player1\": {\"item\": 1,\"itemName\": \"Бизнес %s [№%d]\",\"itemPrice\": %d,\"itemSurcharge\": %d,\"state\": 0,\"commission\": 0}}')", GetBusinessData(businessid, B_NAME), businessid, GetBusinessData(businessid, B_PRICE), GetPVarInt(playerid, "itemSurcharge"));
					MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, STRING_GLOBAL);
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Trade').updateData('{\"player2\": {\"item\": 1,\"itemName\": \"Бизнес %s [№%d]\",\"itemPrice\": %d,\"itemSurcharge\": %d,\"state\": 0,\"commission\": 0}}')", GetBusinessData(businessid, B_NAME), businessid, GetBusinessData(businessid, B_PRICE), GetPVarInt(GetPVarInt(playerid, "Trade_player1"), "itemSurcharge"));
					MoralPacket_1(GetPVarInt(playerid, "Trade_player1"), s_CefInterface, t_CefUpdate, STRING_GLOBAL);
					SetPVarInt(playerid, "NotaryObject", 2);
				}
			}	
			case DIALOG_OWNABLE_GARAGE_NOTARY:
			{
				if(response)
				{
					new idx = GetPlayerListitemValue(playerid, listitem) + 1;
					SetPVarInt(playerid, "ownablegarage_id", idx);
					new businessid = GetPVarInt(playerid, "ownablegarage_id");
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Trade').updateData('{\"player1\": {\"item\": 1,\"itemName\": \"Гараж [№%d]\",\"itemPrice\": %d,\"itemSurcharge\": %d,\"state\": 0,\"commission\": 0}}')", businessid, GetGarageData(businessid, G_PRICE), GetPVarInt(playerid, "itemSurcharge"));
					MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, STRING_GLOBAL);
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Trade').updateData('{\"player2\": {\"item\": 1,\"itemName\": \"Гараж [№%d]\",\"itemPrice\": %d,\"itemSurcharge\": %d,\"state\": 0,\"commission\": 0}}')", businessid, GetGarageData(businessid, G_PRICE), GetPVarInt(GetPVarInt(playerid, "Trade_player1"), "itemSurcharge"));
					MoralPacket_1(GetPVarInt(playerid, "Trade_player1"), s_CefInterface, t_CefUpdate, STRING_GLOBAL);
					SetPVarInt(playerid, "NotaryObject", 8);
				}
			}
			case DIALOG_OWNABLE_NEFTENASOS_LIST2:
			{
				if(!response) return 1;
				new businessid = GetPlayerListitemValue(playerid, listitem);
				SetPVarInt(playerid, "ownableneft_id", businessid);
				
				string_dialog[0] = EOS;

				format
				(
					string_dialog, sizeof string_dialog,
					"{FFFFFF}Нефтенасос {006400}№%d\n\
					{FFFFFF}Оплачено: {006400}%d/5 дн.\n\
					{FFFFFF}Стоимость аренды за 1 день составляет {006400}%d руб.",
					businessid, GetNeftData(businessid, N_RENT_DATE), GetNeftData(businessid, N_RENT_PRICE)
				);

				Dialog(playerid, DIALOG_ATM_NEFTENASOS_RENT, DIALOG_STYLE_INPUT, "{FFFFFF}Оплата аренды нефтенасоса", string_dialog, "Готово", "Назад");

			}
			case DIALOG_ATM_NEFTENASOS_RENT:
			{
				new businessid = GetPVarInt(playerid, "ownableneft_id");
				if(businessid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							static fmt_str[128 + 1];

							new rent_time = GetNeftData(businessid, N_RENT_DATE);

							new rent_price = GetNeftData(businessid, N_RENT_PRICE);

							new total_price = rent_price * days;
							if((rent_time + days) <= 5)
							{
								if(GetILPlayerInt(GetPlayerBankMoney(playerid), total_price))
								{

									format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,neftenasos b SET a.bank=%s,b.rent=%d WHERE a.id=%d AND b.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price), days + rent_time, GetPlayerAccountID(playerid), GetNeftData(businessid, N_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price));
										SetNeftData(businessid, N_RENT_DATE, days + rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно продлили аренду нефтенасоса еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 5 дней");
						}
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_OWNABLE_NEFTENASOS_LIST:
			{
				if(!response) return ShowPlayerATMDialog(playerid);
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				SetPVarInt(playerid, "ownableneft_id", idx);
				static fmt[148];
				format(fmt, sizeof fmt,"{FFFFFF}Нефтенасос {006400}№%d\n{FFFFFF}Баланс: {006400}%d {FFFFFF}руб.\n\nСколько вы хотите снять?", idx, GetNeftData(idx, N_BALANCE));
				Dialog(playerid, DIALOG_ATM_NEFTENASOS_PUT_MONEY, DIALOG_STYLE_INPUT,"{FFFFFF}Снятие средств",fmt,"Готово", "Назад");
			}
			case DIALOG_OWNABLE_BIZ_LIST:
			{
				if(response)
				{
					new idx = GetPlayerListitemValue(playerid, listitem) + 1;
					//ShowOwnableBizDialog(playerid, idx, true);
					SetPVarInt(playerid, "ownablebiz_id", idx);

				    new businessid = idx;
					if(businessid != -1)
					{
						static const
							music_name[6][9] = {"Отключен", "Звук 1", "Звук 2", "Звук 3", "Звук 4", "Звук 5"};

						if(GetBusinessData(businessid, B_ENTER_MUSIC) > sizeof music_name - 1) SetBusinessData(businessid, B_ENTER_MUSIC, sizeof music_name - 1);

						string_dialog[0] = EOS;
						if(GetBusinessData(businessid, B_TYPE) != 36 && GetBusinessData(businessid, B_TYPE) != 37)
						{
							if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_ARENDA)
							{
								format
								(
									string_dialog, sizeof string_dialog,
									"{FFFFFF}Название:<t><t><t><t>{339999}%s\n"\
									"{FFFFFF}Номер бизнеса:<t><t><t>%d\n"\
									"Владелец:<t><t><t><t>%s\n"\
									"Город / область:<t><t><t>%s\n"\
									"Район:<t><t><t><t><t>%s\n"\
									"Количество продуктов:<t><t>%d из %d\n"\
									"Стоимость 1 продукта:<t><t>%d руб\n"\
									"Уровень улучшений:<t><t><t>%d\n"\
									"Баланс предприятия:<t><t><t>%s руб\n"\
									"Бизнес арендован на:<t><t>%d/14 дней\n"\
									"{FFFFFF}Гос. стоимость:<t><t><t>%s руб\n"\
									"Аренда помещения:<t><t><t>%d руб в день\n"\
									"Тип аренды:<t><t><t><t>%s\n"\
									"{669966}Для открытия панели управления вашим бизнесом\n"\
									"нажмите кнопку Изменить",
									GetBusinessData(businessid, B_NAME),
									businessid,
									GetBusinessData(businessid, B_OWNER_NAME),
									GetCityName(GetBusinessData(businessid, B_CITY)),
									GetZoneName(GetBusinessData(businessid, B_ZONE)),
									GetBusinessData(businessid, B_PRODS),
									GetBusinessMaxProd(businessid),
									GetBusinessData(businessid, B_PROD_PRICE),
									GetBusinessData(businessid, B_IMPROVEMENTS),
									formatStr(GetBusinessData(businessid, B_BALANCE)),
									GetBusinessData(businessid, B_RENT_DATE) <= gettime() ? 0 :
									GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
									formatInt(GetBusinessData(businessid, B_PRICE)),
									GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? (GetBusinessData(businessid, B_RENT_PRICE)) : (GetBusinessData(businessid, B_RENT_PRICE) / 2),
									GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("Полная") : ("Льготная")
								);
							}
							else
							{
								new type;
								for(new i; i < g_business_loaded; i ++)
								{
									if(GetBusinessData(i, B_TYPE) != 36) continue;
									if(GetBusinessData(i, B_ELECTRICITY) != GetBusinessData(businessid, B_ELECTRICITY)) continue;

									type = i;

								}

								static fmt_text[148];
								if(type != 0)
								{
									if(GetBusinessData(type, B_IZNOS) != 0) 
										format(fmt_text, sizeof fmt_text, "{66CC33}%s (Работает)", GetBusinessData(type, B_NAME));
									else if(GetBusinessData(type, B_IZNOS) == 0) 
										format(fmt_text, sizeof fmt_text, "{CC3333}%s (Сломан)", GetBusinessData(type, B_NAME));
								}
								else 
									format(fmt_text, sizeof fmt_text, "{CC3333}Нет", GetBusinessData(type, B_NAME));

								format
								(
									string_dialog, sizeof string_dialog,
									"{FFFFFF}Название:<t><t><t><t>{339999}%s\n"\
									"{FFFFFF}Номер бизнеса:<t><t><t>%d\n"\
									"Владелец:<t><t><t><t>%s\n"\
									"Город / область:<t><t><t>%s\n"\
									"Район:<t><t><t><t><t>%s\n"\
									"Плата за вход:<t><t><t>%d руб\n"\
									"Количество продуктов:<t><t>%d из %d\n"\
									"Стоимость 1 продукта:<t><t>%d руб\n"\
									"Уровень улучшений:<t><t><t>%d\n"\
									"Баланс предприятия:<t><t><t>%s руб\n"\
									"Бизнес арендован на:<t><t>%d/14 дней\n"\
									"Звук при входе:<t><t><t>{%s}%s\n"\
									"{FFFFFF}Гос. стоимость:<t><t><t>%s руб\n"\
									"Аренда помещения:<t><t><t>%d руб в день\n"\
									"Тип аренды:<t><t><t><t>%s\n"\
									"Статус:<t><t><t><t><t>%s\n\n"\
									"{FFFFFF}Электричество:<t><t><t>%s\n"\
									"{FFFFFF}Потребление за 1000 часов:<t><t><t>17 кВт\n"\
									"{FFFFFF}Поставщик энергии:<t><t><t><t>%s\n"\
									"{FFFFFF}Тариф за энергию:<t><t><t><t><t>%d руб\n\n"\
									"{669966}Для открытия панели управления вашим бизнесом\n"\
									"нажмите кнопку Изменить",
									GetBusinessData(businessid, B_NAME),
									businessid,
									GetBusinessData(businessid, B_OWNER_NAME),
									GetCityName(GetBusinessData(businessid, B_CITY)),
									GetZoneName(GetBusinessData(businessid, B_ZONE)),
									GetBusinessData(businessid, B_ENTER_PRICE),
									GetBusinessData(businessid, B_PRODS),
									GetBusinessMaxProd(businessid),
									GetBusinessData(businessid, B_PROD_PRICE),
									GetBusinessData(businessid, B_IMPROVEMENTS),
									formatStr(GetBusinessData(businessid, B_BALANCE)),
									GetBusinessData(businessid, B_RENT_DATE) <= gettime() ? 0 :
									GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
									!GetBusinessData(businessid, B_ENTER_MUSIC) ? ("FF3333") : ("33CC00"),
									music_name[GetBusinessData(businessid, B_ENTER_MUSIC)],
									formatInt(GetBusinessData(businessid, B_PRICE)),
									GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? (GetBusinessData(businessid, B_RENT_PRICE)) : (GetBusinessData(businessid, B_RENT_PRICE) / 2),
									GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("Полная") : ("Льготная"),
									GetBusinessData(businessid, B_LOCK_STATUS) ? ("{CC3333}Бизнес закрыт") : ("{66CC33}Бизнес открыт"),
									GetBusinessData(businessid, B_ELECTRICITY) != 0 ? "{66CC33}Есть" : "{CC3333}Нет",
									fmt_text,
									GetBusinessData(type, B_PROD_PRICE)
								);
							}
						}
						else if(GetBusinessData(businessid, B_TYPE) != 37)
						{
							new nameee[64];
							if(GetBusinessData(businessid, B_IZNOS) >= 1000) format(nameee, sizeof(nameee), "{66CC33}Низкий");
							else if(GetBusinessData(businessid, B_IZNOS) < 1000) format(nameee, sizeof(nameee), "{ffa420}Средний");
							else if(GetBusinessData(businessid, B_IZNOS) < 250) format(nameee, sizeof(nameee), "{CC3333}Высокий");

							format
							(
								string_dialog, sizeof string_dialog,
								"{FFFFFF}Название:<t><t><t><t>{339999}%s\n"\
								"{FFFFFF}Номер бизнеса:<t><t><t>%d\n"\
								"Владелец:<t><t><t><t>%s\n"\
								"Город / область:<t><t><t>%s\n"\
								"Район:<t><t><t><t><t>%s\n"\
								"Плата за вход:<t><t><t>%d руб\n"\
								"В хранилище энергии:<t><t>{ffa420}%d из %d кВт\n"\
								"{ffffff}Стоимость 1 продукта:<t><t>%d руб\n"\
								"Уровень улучшений:<t><t><t>%d\n"\
								"Баланс предприятия:<t><t><t>%s руб\n"\
								"Бизнес арендован на:<t><t>%d/14 дней\n"\
								"Звук при входе:<t><t><t>{%s}%s\n"\
								"{FFFFFF}Гос. стоимость:<t><t><t>%s руб\n"\
								"Аренда помещения:<t><t><t>%d руб в день\n"\
								"Тип аренды:<t><t><t><t>%s\n"\
								"Статус:<t><t><t><t><t>%s\n\n"\
								"{FFFFFF}Состояние:<t><t><t>{66CC33}%s\n"\
								"{669966}Для открытия панели управления вашим бизнесом\n"\
								"нажмите кнопку Изменить",
								GetBusinessData(businessid, B_NAME),
								businessid,
								GetBusinessData(businessid, B_OWNER_NAME),
								GetCityName(GetBusinessData(businessid, B_CITY)),
								GetZoneName(GetBusinessData(businessid, B_ZONE)),
								GetBusinessData(businessid, B_ENTER_PRICE),
								GetBusinessData(businessid, B_PRODS),
								GetBusinessMaxProd(businessid),
								GetBusinessData(businessid, B_PROD_PRICE),
								GetBusinessData(businessid, B_IMPROVEMENTS),
								formatStr(GetBusinessData(businessid, B_BALANCE)),
								GetBusinessData(businessid, B_RENT_DATE) <= gettime() ? 0 :
								GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
								!GetBusinessData(businessid, B_ENTER_MUSIC) ? ("FF3333") : ("33CC00"),
								music_name[GetBusinessData(businessid, B_ENTER_MUSIC)],
								formatInt(GetBusinessData(businessid, B_PRICE)),
								GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? (GetBusinessData(businessid, B_RENT_PRICE)) : (GetBusinessData(businessid, B_RENT_PRICE) / 2),
								GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("Полная") : ("Льготная"),
								GetBusinessData(businessid, B_LOCK_STATUS) ? ("{CC3333}Бизнес закрыт") : ("{66CC33}Бизнес открыт"),
								GetBusinessData(businessid, B_ELECTRICITY) ? ("{CC3333}Сломан") : ("{66CC33}Работает"),
								nameee
							);
						}
						else
						{
							format
							(
								string_dialog, sizeof string_dialog,
								"{FFFFFF}Название:<t><t><t><t>{339999}%s\n"\
								"{FFFFFF}Номер бизнеса:<t><t><t>%d\n"\
								"Владелец:<t><t><t><t>%s\n"\
								"Город / поселок:<t><t><t>%s\n"\
								"Район:<t><t><t><t><t>%s\n"\
								"Количество топлива:<t><t><t>%d л из %d\n"\
								"Цена топлива:<t><t><t>%d руб\n"\
								"Закупочная цена:<t><t><t>2 руб за 1 л\n"\
								"Уровень улучшений:<t><t><t>%d\n"\
								"Баланс предприятия:<t><t><t>%s руб\n"\
								"Бизнес арендован на:<t><t><t>%d/14 дней\n"\
								"Гос. стоимость:<t><t><t>%s руб\n"\
								"Аренда территории:<t><t><t>%d руб в день\n"\
								"Акцизный сбор:<t><t><t>%s\n"\
								"Статус:<t><t><t><t><t>%s\n\n"\
								"{669966}Для открытия панели управления вашим бизнесом\n"\
								"нажмите кнопку Изменить",
								GetBusinessData(businessid, B_NAME),
								businessid,
								GetBusinessData(businessid, B_OWNER_NAME),
								GetCityName(GetBusinessData(businessid, B_CITY)),
								GetZoneName(GetBusinessData(businessid, B_ZONE)),
								GetBusinessData(businessid, B_PRODS),
								GetBusinessMaxProd(businessid),
								GetBusinessData(businessid, B_PROD_PRICE),
								GetBusinessData(businessid, B_IMPROVEMENTS),
								formatStr(GetBusinessData(businessid, B_BALANCE)),
								GetBusinessData(businessid, B_RENT_DATE) <= gettime() ? 0 :
								GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
								formatInt(GetBusinessData(businessid, B_PRICE)),
								GetBusinessData(businessid, B_IMPROVEMENTS) < 4 ? GetBusinessData(businessid, B_RENT_PRICE) : GetBusinessData(businessid, B_RENT_PRICE) / 2,
								GetBusinessData(businessid, B_IMPROVEMENTS) < 4 ? ("Взымается") : ("Не взымается"),
								GetBusinessData(businessid, B_LOCK_STATUS) ? ("{CC3333}Закрыто") : ("{66CC33}Бизнес открыт")
							);
						}
						Dialog(playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}Информация о бизнесе", string_dialog, "Изменить", "Отмена");
					}
				}
			}
			case DIALOG_SET_SPAWN:
			{
				if(!response) return CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, LOGIN_STATE_LOAD_ACC, false);
	
				CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, LOGIN_STATE_LOAD_ACC, false);
				SetSpawnInfo
				(
				playerid,
				0,
				GetPlayerSkinEx(playerid),
				GetPlayerData(playerid, P_AFTER_X), // + random(3),
				GetPlayerData(playerid, P_AFTER_Y), // + random(3),
				GetPlayerData(playerid, P_AFTER_Z),
				12,
				0, 0, 0, 0, 0, 0
				);		
				if(GetPlayerData(playerid, P_JAIL) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Заключенным нельзя телепортироватьcя");
				SpawnPlayer(playerid);
				UpdatePlayerDatabaseInt(playerid, "afterpos", 0);
				SetPlayerSpawnInit(playerid);
			}
			case DIALOG_PAY_FOR_RENT_HOME:
			{
				new houseid = GetPlayerListitemValue(playerid, listitem) + 1;
				
				if(houseid != -1)
				{
					SetPVarInt(playerid, "ownablehouse_id", houseid);

					static fmt_str[256];

					format
					(
						fmt_str, sizeof fmt_str,
						"{FFFFFF}Дом:\t\t\t\t\t№%d (%s)\n"\
						"Оплаченных дней аренды:\t\t%d из 14\n"\
						"Ежедневная квартплата:\t\t%d руб\n"\
						"Субсидия:\t\t\t\t%s\n\n"\
						"На сколько дней Вы хотите оплатить дом?",
						houseid,
						GetHouseData(houseid, H_NAME),
						GetHouseData(houseid, H_RENT_DATE) <= gettime() ? 0 :
						GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
						GetHouseData(houseid, H_IMPROVEMENTS) < 3 ? GetHouseData(houseid, H_RENT_PRICE) : GetHouseData(houseid, H_RENT_PRICE) / 2,
						GetHouseData(houseid, H_IMPROVEMENTS) < 3 ? ("Нет") : ("Есть")
					);
					Dialog(playerid, DIALOG_PAY_FOR_RENT_HOUSE, DIALOG_STYLE_INPUT, "{66CC00}Оплата дома", fmt_str, "Оплатить", "Назад");
				}
			}
			case DIALOG_PAY_FOR_RENT_HOUSE:
			{
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				if(response)
				{
					new days = strval(inputtext);
					if(days > 0 && IsNumeric(inputtext))
					{
						static fmt_str[128 + 1];

						new time = gettime();
						new rent_time = GetHouseData(houseid, H_RENT_DATE);

						new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
						new rent_price = GetHouseData(houseid, H_IMPROVEMENTS) < 3 ? GetHouseData(houseid, H_RENT_PRICE) : GetHouseData(houseid, H_RENT_PRICE) / 2;

						new total_price = rent_price * days;
						if((rent_days + days) <= 14)
						{
							if(GetILPlayerInt(GetPlayerBankMoney(playerid), total_price))
							{
								rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

								format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens a,houses h SET a.bank=%s,h.rent_time=%d WHERE a.id=%d AND h.id=%d", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price), rent_time, GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									format(g_player[playerid][P_BANK], 21, "%s", SetILPlayerInt(playerid, GetPlayerBankMoney(playerid), -total_price));
									SetHouseData(houseid, H_RENT_DATE, rent_time);

									format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
									SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

									format(fmt_str, sizeof fmt_str, "Вы успешно оплатили дом еще на {3399FF}%d дней", days);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);
								}
							}
							else
							{
								SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

								format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
								SendClientMessage(playerid, 0x999999FF, fmt_str);
							}
						}
						else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 14 дней");
					}
					ShowPlayerHousePayForRent(playerid);
				}
				else ShowPlayerPayForRentDialog(playerid);
			}
			case DIALOG_SPAWN_HOME_LIST:
			{
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				SetPVarInt(playerid, "ownablehouse_id", idx);
				new houseid = GetPVarInt(playerid, "ownablehouse_id");

				SetPlayerData(playerid, P_ID_SPAWN, houseid);
				UpdatePlayerDatabaseInt(playerid, "id_spawn", houseid);

				SetPlayerData(playerid, P_SPAWN, 1);
				UpdatePlayerDatabaseInt(playerid, "setting_spawn", 1);
				SendClientMessage(playerid, 0x3399FFFF, "* Место появления в игре изменено");
				MoralPacket_1(playerid, s_CefInterface, t_CefHide, "SelectSpawn");
			}
			case DIALOG_SELL_MY_HOME_LIST:
			{
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				SetPVarInt(playerid, "ownablehouse_id", idx);
				new houseid = GetPVarInt(playerid, "ownablehouse_id");

				if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xCECECEFF, "* Продавать дом можно только с {99ff00}2{CECECE} уровня");

				if(!(IsPlayerInRangeOfHouse(playerid, houseid, 10.0) && IsPlayerInRangeOfHouse(GetPVarInt(playerid, "to_player"), houseid, 10.0)))
					return SendClientMessage(playerid, 0xCECECEFF, "* Вы и покупатель должны находиться около дома который хотите продать");

				SendPlayerOffer(playerid, GetPVarInt(playerid, "to_player"), OFFER_TYPE_SELL_HOME, houseid, GetPVarInt(playerid, "Sellprice"));
			}
			case DIALOG_SELL_HOME_LIST:
			{
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;

				if(idx != -1)
				{
					SetPVarInt(playerid, "ownablehouse_id", idx);
					Dialog
					(
						playerid, DIALOG_HOUSE_SELL, DIALOG_STYLE_MSGBOX,
						"{FFD83D}Продажа дома",
						"{FFFFFF}Вы уверены что хотите продать свой дом государству?\n\n"\
						"Вам будет возвращено ее стоимость за вычитом 40%\n"\
						"Также будет возвращено 60% от стоимости купленных улучшений\n\n"\
						"Если Вы хотите продать дом другому игроку,\n"\
						"используйте команду /sellmyhome",
						"Да", "Нет"
					);
				}
			}
			case DIALOG_OWNABLE_HOME_LIST:
			{
				new idx = GetPlayerListitemValue(playerid, listitem) + 1;
				SetPVarInt(playerid, "ownablehouse_id", idx);
				new houseid = GetPVarInt(playerid, "ownablehouse_id");
				
				string_dialog[0] = EOS;
				new entranceid = GetHouseData(houseid, H_ENTRACE);

				format(string_dialog, sizeof string_dialog, "{FFFFFF}Тип / название:\t\t\t{339999}%s\n", GetHouseData(houseid, H_NAME));
				if(entranceid != -1)
				{
					format
					(
						string_dialog, sizeof string_dialog,
						"%s{FFFFFF}Номер подъезда:\t\t\t%d\n"\
						"Номер квартиры:\t\t\t%d\n"\
						"Город / поселок:\t\t\t%s\n"\
						"Район:\t\t\t\t\t%s\n",
						string_dialog,
						entranceid + 1,
						GetHouseData(houseid, H_FLAT_ID) + 1,
						GetCityName(GetEntranceData(entranceid, E_CITY)),
						GetZoneName(GetEntranceData(entranceid, E_ZONE))
					);
				}
				else
				{
					format
					(
						string_dialog, sizeof string_dialog,
						"%s{FFFFFF}Номер дома:\t\t\t\t%d\n"\
						"Город / область:\t\t\t%s\n"\
						"Район:\t\t\t\t\t%s\n",
						string_dialog,
						houseid,
						GetCityName(GetHouseData(houseid, H_CITY)),
						GetZoneName(GetHouseData(houseid, H_ZONE))
					);
				}

				format
				(
					string_dialog, sizeof string_dialog,
					"%sСтоимость:<t><t><t><t>%s руб\n"\
					"Дом оплачен на:<t><t><t>%d/14 дней\n"\
					"Количество комнат:<t><t><t>%d\n"\
					"Уровень улучшений:<t><t><t>%d\n"\
					"Модель домашнего авто:<t><t>{FF3333}Нет\n"\
					"{FFFFFF}Квартплата:<t><t><t><t>%d руб в день\n"\
					"Тип квартплаты:<t><t><t>%s\n"\
					"Статус:<t><t><t><t><t>%s\n\n"\
					"{669966}Для открытия панели управления вашим домом\n"\
					"нажмите кнопку Изменить",
					string_dialog,
					formatInt(GetHouseData(houseid, H_PRICE)),
					GetHouseData(houseid, H_RENT_DATE) <= gettime() ? 0 :
					GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
					GetHouseTypeInfo(GetHouseData(houseid, H_TYPE), HT_ROOMS),
					GetHouseData(houseid, H_IMPROVEMENTS),
					GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? (GetHouseData(houseid, H_RENT_PRICE)) : (GetHouseData(houseid, H_RENT_PRICE) / 2),
					GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? ("Обычная") : ("Пониженная"),
					GetHouseData(houseid, H_LOCK_STATUS) ? ("{CC3333}Дом закрыт") : ("{66CC33}Дом открыт")
				);
				Dialog(playerid, DIALOG_HOUSE_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}Информация о доме", string_dialog, "Изменить", "Отмена");

			}
			case DIALOG_SET_PRIVATE:
			{
				if(response)
			    {
					if(strval(inputtext) != 8702) return SendClientMessage(playerid,-1,"Пароль не верный!"), Dialog(playerid, DIALOG_SET_PRIVATE, DIALOG_STYLE_INPUT,""GUARD_SERVER"","{FFFFFF}Введите пароль для входа на сервер:","Далее", "Закрыть");
					Dialog(playerid, DIALOG_SET_SPAWN, DIALOG_STYLE_MSGBOX,"{FFFFFF}Восстановление позиции","Хотите вернуться на место последнего выхода из игры?","Да", "Нет");
				}
				else Kick(playerid);
			}
            // -----------------------------------------------------------------
            case DIALOG_SET_LIFTMAFIARUSSIA:
			{
				if(!response) return 1;
				switch(listitem){
					case 0:{SetPlayerPos(playerid, -1597.8700,-638.6998,1016.4700);SetPlayerVirtualWorld(playerid, 4);}
					case 1:{SetPlayerPos(playerid, 1093.9169,2231.8499,2.0000);SetPlayerVirtualWorld(playerid, 4);}
				}
			}
			case DIALOG_FSB_B:
			{
			    if (!response) return 1;
			
			    if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1)
    			{
        		SendClientMessage(playerid, 0xFF8000FF, "* Данный выход предназначен только для сотрудников ФСБ");
        		GameTextForPlayer(playerid, "~r~Нет доступа", 3000, 3);
        		return 1;
    			}	
				switch (listitem)
				{
			        case 0:
			        {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 2362.4998, -1728.1410, 40.7690);
			            SetPlayerFacingAngle(playerid, 358.6107);
			        }
			        case 1:
			        {
			            SetPlayerVirtualWorld(playerid, 4);
			            SetPlayerInterior(playerid, 4);
			            SetPlayerPos(playerid, 1615.7175, 1831.2300, 996.5703);
			            SetPlayerFacingAngle(playerid, 180.8186);
			        }
			    }
			}
			case DIALOG_SET_LIFTMAFIAITALY:
			{
				if(!response) return 1;
				switch(listitem){
					case 0:{SetPlayerPos(playerid, -1597.8700,-638.6998,1016.4700);SetPlayerVirtualWorld(playerid, 6);}
					case 1:{SetPlayerPos(playerid, 1093.9169,2231.8499,2.0000);SetPlayerVirtualWorld(playerid, 6);}
				}
			}

			case DIALOG_SET_LIFTMAFIAJAPAN:
			{
				if(!response) return 1;
				switch(listitem){
					case 0:{SetPlayerPos(playerid, -1597.8700,-638.6998,1016.4700);SetPlayerVirtualWorld(playerid, 5);}
					case 1:{SetPlayerPos(playerid, 1093.9169,2231.8499,2.0000);SetPlayerVirtualWorld(playerid, 5);}
				}
			}
			 case DIALOG_SET_TOPBANDRUSSIA:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: SendClientMessage(playerid, 0xFF6600FF, "* В разработке.");
						case 1: SendClientMessage(playerid, 0xFF6600FF, "* В разработке.");
 					}
			   	}
			 }
			 case DIALOG_SET_TOPBANDITALY:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: SendClientMessage(playerid, 0xFF6600FF, "* В разработке.");
						case 1: SendClientMessage(playerid, 0xFF6600FF, "* В разработке.");
 					}
			   }
			 }
			 case DIALOG_SET_TOPBANDJAPAN:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: SendClientMessage(playerid, 0xFF6600FF, "* В разработке.");
						case 1: SendClientMessage(playerid, 0xFF6600FF, "* В разработке.");
 					}
			   }
			 }
			// -----------------------------------------------------------------
			
			case DIALOG_SET_CMD:
			{
				if(!response) return 1;

				new to_player = GetPVarInt(playerid, "to_player");

				if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
					return SendClientMessage(playerid, 0x999999FF, "* Данного игрока нет на сервере");

				STRING_GLOBAL[0] = EOS;

				switch(listitem + 1)
				{
					case 1: 
					{
						if(GetPlayerData(to_player, P_CMD_giveskin) == 0) {
							SetPlayerData(to_player, P_CMD_giveskin, 1);
							UpdatePlayerDatabaseInt(to_player, "giveskin", 1);

							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам доступ к команде \"/giveskin\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] выдал %s[%d] доступ к команде \"/giveskin\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						}
						else {
							SetPlayerData(to_player, P_CMD_giveskin, 0);
							UpdatePlayerDatabaseInt(to_player, "giveskin", 0);

							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] забрал у вас доступ к команде \"/giveskin\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] забрал у %s[%d] доступ к команде \"/giveskin\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

						}

					}
					case 2: 
					{
						if(GetPlayerData(to_player, P_CMD_contspawn) == 0) {
							SetPlayerData(to_player, P_CMD_contspawn, 1);
							UpdatePlayerDatabaseInt(to_player, "contspawn", 1);
							
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам доступ к команде \"/contspawn\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] выдал %s[%d] доступ к команде \"/contspawn\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						}
						else {
							SetPlayerData(to_player, P_CMD_contspawn, 0);
							UpdatePlayerDatabaseInt(to_player, "contspawn", 0);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] забрал у вас доступ к команде \"/contspawn\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] забрал у %s[%d] доступ к команде \"/contspawn\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

						}
					}
					case 3: 
					{
						if(GetPlayerData(to_player, P_CMD_dumpspawn) == 0) {
							SetPlayerData(to_player, P_CMD_dumpspawn, 1);
							UpdatePlayerDatabaseInt(to_player, "dumpspawn", 1);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам доступ к команде \"/dumpspawn\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] выдал %s[%d] доступ к команде \"/dumpspawn\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						}
						else {
							SetPlayerData(to_player, P_CMD_dumpspawn, 0);
							UpdatePlayerDatabaseInt(to_player, "dumpspawn", 0);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] забрал у вас доступ к команде \"/dumpspawn\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] забрал у %s[%d] доступ к команде \"/dumpspawn\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

						}

					}
					case 4: 
					{
						if(GetPlayerData(to_player, P_CMD_afly) == 0) {
							SetPlayerData(to_player, P_CMD_afly, 1);
							UpdatePlayerDatabaseInt(to_player, "afly", 1);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам доступ к команде \"/afly\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] выдал %s[%d] доступ к команде \"/afly\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						}
						else {
							SetPlayerData(to_player, P_CMD_afly, 0);
							UpdatePlayerDatabaseInt(to_player, "afly", 0);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] забрал у вас доступ к команде \"/afly\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] забрал у %s[%d] доступ к команде \"/afly\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

						}

						
					}
					case 5: 
					{
						if(GetPlayerData(to_player, P_CMD_getv) == 0) {
							SetPlayerData(to_player, P_CMD_getv, 1);
							UpdatePlayerDatabaseInt(to_player, "getv", 1);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам доступ к команде \"/getv\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] выдал %s[%d] доступ к команде \"/getv\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						}
						else {
							SetPlayerData(to_player, P_CMD_getv, 0);
							UpdatePlayerDatabaseInt(to_player, "getv", 0);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] забрал у вас доступ к команде \"/getv\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] забрал у %s[%d] доступ к команде \"/getv\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

						}

						
					}
					case 6: 
					{
						if(GetPlayerData(to_player, P_CMD_fixcar) == 0) {
							SetPlayerData(to_player, P_CMD_fixcar, 1);
							UpdatePlayerDatabaseInt(to_player, "fixcar", 1);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам доступ к команде \"/fixcar\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] выдал %s[%d] доступ к команде \"/fixcar\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
						}
						else {
							SetPlayerData(to_player, P_CMD_fixcar, 0);
							UpdatePlayerDatabaseInt(to_player, "fixcar", 0);
							SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] забрал у вас доступ к команде \"/fixcar\".", GetPlayerNameEx(playerid), playerid);
							format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] забрал у %s[%d] доступ к команде \"/fixcar\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

						}

						
					}
				}
				SendMessageToAdmins(STRING_GLOBAL, 0xC0C0C0FF);

				string_dialog[0] = EOS;
				format
				(
					string_dialog, sizeof string_dialog, 
					"Команда\tДоступ\tИнформация о команде\n\
					/giveskin\t%s\t{FFFFFF}Выдача одежды на аккаунт\n\
					/contspawn\t%s\t{FFFFFF}Спавн контейнеров любого типа\n\
					/dumpspawn`\t%s\t{FFFFFF}Спавн свалки\n\
					/afly\t%s\t{FFFFFF}Доступ к полету\n\
					/getv\t%s\t{FFFFFF}Телепорт личного транспорта к себе\n\
					/fixcar\t%s\t{FFFFFF}Ремонт транспорта без рем. комплекта",
					GetPlayerData(to_player, P_CMD_giveskin) ? "{66CC33}Есть" : "{CC3333}Нет",
					GetPlayerData(to_player, P_CMD_contspawn) ? "{66CC33}Есть" : "{CC3333}Нет",
					GetPlayerData(to_player, P_CMD_dumpspawn) ? "{66CC33}Есть" : "{CC3333}Нет",
					GetPlayerData(to_player, P_CMD_afly) ? "{66CC33}Есть" : "{CC3333}Нет",
					GetPlayerData(to_player, P_CMD_getv) ? "{66CC33}Есть" : "{CC3333}Нет",
					GetPlayerData(to_player, P_CMD_fixcar) ? "{66CC33}Есть" : "{CC3333}Нет"
				);

				Dialog(playerid, DIALOG_SET_CMD, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}Панель доступа к командам", string_dialog, "Выбрать", "Закрыть");
			}
			
			// -----------------------------------------------------------------
			case DIALOG_TEAM_CHANGE_SKIN:
			{
				if(!response || !(0 <= listitem <= 9)) return 1;

				new to_player = GetPVarInt(playerid, "change_team_skin_playerid");
				new team_id = GetPlayerTeamEx(playerid);

				if(!(1 <= team_id <= 10) || !(9 <= GetPlayerJobName(playerid) <= 10)) return 1;
				if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || team_id != GetPlayerTeamEx(to_player)) return 1;
				if(GetPlayerSex(to_player)) return 1;
				
				static query[85];

				new index = GetPlayerListitemValue(playerid, listitem);

				SetPlayerData(to_player, P_OSKIN, GetTeamData(team_id, O_SKINS)[index]);

				mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET org_skin=%d WHERE id=%d", GetPlayerData(to_player, P_OSKIN), GetPlayerAccountID(to_player));
				mysql_query(mysql, query, false);

				ResetSkin(to_player);

				format(query, sizeof query, "%s {FFFFFF}выдал Вам новую униформу", GetPlayerNameEx(playerid));
				SendClientMessage(to_player, 0xFFFFFFFF, query);

				format(query, sizeof query, "Вы выдали новую униформу {FFFFFF}%s[%d]", GetPlayerNameEx(to_player), to_player);
				SendClientMessage(playerid, 0xFF8C00FF, query);

				return 1;
			}
			case DIALOG_TEAM_LEAVE:
			{
				if(response)
				{
					static fmt_text[110];

					format(fmt_text, sizeof fmt_text, "%s %s[%d] покинул организацию по собственному желанию",
					GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);

					SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x3399FFFF, playerid);

					format(fmt_text, sizeof fmt_text, "Вы покинули организацию \"%s\"", GetTeamName(GetPlayerTeamEx(playerid)));
					SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

					UnInvite(playerid, playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_DEBTORLIST:
			{
				if(!response) return 1;
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) < 4) return 1;

				if(0 <= listitem <= 2)
				{
					ShowDebtorListDialog(playerid, listitem);
				}

				return 1;
			}
			case DIALOG_DEBTORLIST_HOUSE..DIALOG_DEBTORLIST_FUEL_ST:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) < 4) return 1;
				if(!response) return callcmd::debtorlist(playerid, "");
				if(!(0 <= listitem <= 19)) return 1;

				new type = dialogid - DIALOG_DEBTORLIST_HOUSE;
				new buffer = GetPlayerListitemValue(playerid, listitem);

				switch(type)
				{
					case 0:
					{
						if(!GetHouseData(buffer, H_TYPE))
						{
							EnablePlayerGPS(playerid, 56, GetHouseData(buffer, H_POS_X), GetHouseData(buffer, H_POS_Y), GetHouseData(buffer, H_POS_Z), "Дом должника отмечен у Вас на GPS");
						}
						else
						{
							new ent_id = GetHouseData(buffer, H_ENTRACE);

							EnablePlayerGPS(playerid, 56, GetEntranceData(ent_id, E_POS_X), GetEntranceData(ent_id, E_POS_Y), GetEntranceData(ent_id, E_POS_Z), "Подъезд квартиры должника отмечена у Вас на GPS");
						}
					}
					case 1: EnablePlayerGPS(playerid, 56, GetBusinessData(buffer, B_POS_X), GetBusinessData(buffer, B_POS_Y), GetBusinessData(buffer, B_POS_Z), "Предприятие должника отмечено у Вас на GPS");
					default: return -1;
				}

				return 1;
			}

			case DIALOG_DEBTOR_SELL_LIST:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) < 7) return 1;
				//if(!response) return callcmd::debtorsell(playerid, "");
				if(!response) return 1;

				switch(listitem)
				{
					case 0:
					{
						Dialog
						(
							playerid, DIALOG_DEBTOR_SELL_HOUSE, DIALOG_STYLE_INPUT,
							"{99CC00}Акт выселения из жилого помещения",
							"Заполните акт выселения из жилого помещения\n\n\
							{FFFFFF}Укажите через пробел:\n\n\
							{FFCC00}1. Номер дома/квартиры\n\
							2. ID первого понятого\n\
							3. ID второго понятого\n\n\
							{FFFFFF}Когда закончите составление документа, подпишите его\n\
							Сразу после подписания акта должник будет выселен",
							"Подписать", "Назад"
						);

						// 0x3399FFFF > Должник был выселен из дома/квартиры. На оформление документов потребуется время
						// 0x3399FFFF > Вы получаете премию 1000 руб.

					}
					case 1:
					{
						Dialog
						(
							playerid, DIALOG_DEBTOR_SELL_BIZ, DIALOG_STYLE_INPUT,
							"{99CC00}Акт изъятия предпрятия",
							"Заполните акт изъятия предприятия у должника\n\n\
							{FFFFFF}Укажите через пробел:\n\n\
							{FFCC00}1. Номер предприятия\n\
							2. ID первого понятого\n\
							3. ID второго понятого\n\n\
							{FFFFFF}Когда закончите составление документа, подпишите его\n\
							Сразу после подписания акта предприятие станет собственностью государства",
							"Подписать", "Назад"
						);

						// 0x3399FFFF > Предприятие должника было изъято в пользу государства. На оформление документов потребуется время
						// 0x3399FFFF > Вы получаете премию 10000 руб.
					}
					case 2:
					{
						Dialog
						(
							playerid, DIALOG_DEBTOR_SELL_FUEL_ST, DIALOG_STYLE_INPUT,
							"{99CC00}Акт изъятия АЗС",
							"Заполните акт изъятия АЗС у должника\n\n\
							{FFFFFF}Укажите через пробел:\n\n\
							{FFCC00}1. Номер АЗС\n\
							2. ID первого понятого\n\
							3. ID второго понятого\n\n\
							{FFFFFF}Когда закончите составление документа, подпишите его\n\
							Сразу после подписания акта АЗС станет собственностью государства",
							"Подписать", "Назад"
						);
					}
					default: return -1;
				}

				return 1;
			}

			case DIALOG_DEBTOR_SELL_HOUSE:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) < 4) return 1;

				if(!response) return callcmd::debtorsell(playerid, "");

				new sell_houseid = -1, worker_id[2] = {-1, -1};
				sscanf(inputtext, "ddd", sell_houseid, worker_id[0], worker_id[1]);

				if(strlen(inputtext) > 0)
				{
					if(!(0 <= sell_houseid <= g_house_loaded-1))
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите номер дома/квартиры");

					else if(!IsPlayerInRangeOfPoint(playerid, 7.0, GetHouseData(sell_houseid, H_POS_X), GetHouseData(sell_houseid, H_POS_Y), GetHouseData(sell_houseid, H_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Вы находитесь далеко от дома/квартиры должника");

					else if(!IsPlayerConnected(worker_id[0]) || !IsPlayerLogged(worker_id[0]) || worker_id[0] == playerid)
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID первого понятого");

					else if(!IsPlayerConnected(worker_id[1]) || !IsPlayerLogged(worker_id[1]) || worker_id[1] == playerid || worker_id[0] == worker_id[1])
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID второго понятого");

					else if(GetPlayerTeamEx(worker_id[0]) != TEAM_GOVERNMENT && GetPlayerJobName(worker_id[0]) < 3 || GetPlayerTeamEx(worker_id[1]) != TEAM_GOVERNMENT && GetPlayerJobName(worker_id[1]) < 3)
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых не является сотрудником правительства 3 ранга");

					else if(!IsPlayerInRangeOfPoint(worker_id[0], 7.0, GetHouseData(sell_houseid, H_POS_X), GetHouseData(sell_houseid, H_POS_Y), GetHouseData(sell_houseid, H_POS_Z)) || !IsPlayerInRangeOfPoint(worker_id[1], 7.0, GetHouseData(sell_houseid, H_POS_X), GetHouseData(sell_houseid, H_POS_Y), GetHouseData(sell_houseid, H_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых находится далеко от дома/квартиры должника");

					else if((((GetHouseData(sell_houseid, H_RENT_DATE) - gettime()) / 86400) + 1) > 0)
						SendClientMessage(playerid, 0xBBBB00FF, "У владельца этого дома/квартиры нет задолжности за неуплату услуг");

					else if(GetHouseData(sell_houseid, H_EVICTION))
						SendClientMessage(playerid, 0xBBBB00FF, "Акт выселения из этого жилого помещения уже подписан");

					else
					{
						SendClientMessage(playerid, 0x3399FFFF, "* Должник был выселен из дома/квартиры. На оформление документов потребуется время");
						SendClientMessage(playerid, 0x3399FFFF, "* Вы получаете премию 10000 руб.");

						SetPlayerChatBubble(playerid, "+1000 руб", 0x3399FFFF, 5.0, 3000);
						GameText(playerid, "~b~~h~+1000 рублей", 4000, 2);
						AddPlayerData(playerid, P_WAGE, +, 1000);
						UpdatePlayerDatabaseInt(playerid, "wage", GetPlayerData(playerid, P_WAGE));

						for(new i; i < 2; i ++)
						{
							SendClientMessage(worker_id[i], 0x3399FFFF, "* Вы получили премию 1000000 руб.");
							SetPlayerChatBubble(worker_id[i], "+1000000 руб", 0x3399FFFF, 5.0, 3000);
							GameText(worker_id[i], "~b~~h~+1000000 рублей", 4000, 2);
							AddPlayerData(worker_id[i], P_WAGE, +, 1000000);
							UpdatePlayerDatabaseInt(worker_id[i], "wage", GetPlayerData(worker_id[i], P_WAGE));
						}

						static query[90];

						mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET house_type=-1,house_room=-1 WHERE id=%d", GetHouseData(sell_houseid, H_OWNER_ID));
						mysql_query(mysql, query, false);

						new owner_player = GetPlayerIDBySqlID(GetHouseData(sell_houseid, H_OWNER_ID));
						if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
						{
							if(GetPlayerHouse(owner_player, HOUSE_TYPE_HOME) == sell_houseid)
							{
								SetPlayerData(owner_player, P_HOUSE, -1);
								SendClientMessage(owner_player, 0xFF6600FF, "* Вы были выселены из дома/квартиры за неуплату услуг");
							}
						}

						SetHouseData(sell_houseid, H_RENT_DATE, gettime() + (random(169200) + 3600));
						SetHouseData(sell_houseid, H_EVICTION, 1);

						mysql_format(mysql, query, sizeof query, "UPDATE houses SET eviction=1, rent_time=%d WHERE id=%d LIMIT 1", GetHouseData(sell_houseid, H_RENT_DATE), GetHouseData(sell_houseid, H_SQL_ID));
						mysql_query(mysql, query, false);

						return 1;
					}
				}

				Dialog
				(
					playerid, DIALOG_DEBTOR_SELL_HOUSE, DIALOG_STYLE_INPUT,
					"{99CC00}Акт выселения из жилого помещения",
					"Заполните акт выселения из жилого помещения\n\n\
					{FFFFFF}Укажите через пробел:\n\n\
					{FFCC00}1. Номер дома/квартиры\n\
					2. ID первого понятого\n\
					3. ID второго понятого\n\n\
					{FFFFFF}Когда закончите составление документа, подпишите его.\n\
					Сразу после подписания акта должник будет выселен.",
					"Подписать", "Назад"
				);
				return 1;
			}

			case DIALOG_DEBTOR_SELL_BIZ:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) < 4) return 1;

				if(!response) return callcmd::debtorsell(playerid, "");

				new sell_biz_id = -1, worker_id[2] = {-1, -1};
				sscanf(inputtext, "ddd", sell_biz_id, worker_id[0], worker_id[1]);

				if(strlen(inputtext) > 0)
				{
					if(!(0 <= sell_biz_id <= g_business_loaded-1))
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите номер предприятия");

					else if(!IsPlayerInRangeOfPoint(playerid, 7.0, GetBusinessData(sell_biz_id, B_POS_X), GetBusinessData(sell_biz_id, B_POS_Y), GetBusinessData(sell_biz_id, B_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Вы находитесь далеко от предприятия должника");

					else if(!IsPlayerConnected(worker_id[0]) || !IsPlayerLogged(worker_id[0]) || worker_id[0] == playerid)
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID первого понятого");

					else if(!IsPlayerConnected(worker_id[1]) || !IsPlayerLogged(worker_id[1]) || worker_id[1] == playerid || worker_id[0] == worker_id[1])
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID второго понятого");

					else if(GetPlayerTeamEx(worker_id[0]) != TEAM_GOVERNMENT && GetPlayerJobName(worker_id[0]) < 3 || GetPlayerTeamEx(worker_id[1]) != TEAM_GOVERNMENT && GetPlayerJobName(worker_id[1]) < 3)
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых не является сотрудником правительства 3 ранга");

					else if(!IsPlayerInRangeOfPoint(worker_id[0], 7.0, GetBusinessData(sell_biz_id, B_POS_X), GetBusinessData(sell_biz_id, B_POS_Y), GetBusinessData(sell_biz_id, B_POS_Z)) || !IsPlayerInRangeOfPoint(worker_id[1], 7.0, GetBusinessData(sell_biz_id, B_POS_X), GetBusinessData(sell_biz_id, B_POS_Y), GetBusinessData(sell_biz_id, B_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых находится далеко от предприятия должника");

					else if((((GetBusinessData(sell_biz_id, B_RENT_DATE) - gettime()) / 86400) + 1) > 0)
						SendClientMessage(playerid, 0xBBBB00FF, "У владельца этого предприятия нет задолжности за неуплату услуг");

					else if(GetBusinessData(sell_biz_id, B_EVICTION))
						SendClientMessage(playerid, 0xBBBB00FF, "Акт изъятия этого предприятия уже подписан");

					else
					{
						// 0x3399FFFF > Предприятие должника было изъято в пользу государства. На оформление документов потребуется время
						// 0x3399FFFF > Вы получаете премию 10000 руб.

						SendClientMessage(playerid, 0x3399FFFF, "* Предприятие должника было изъято в пользу государства. На оформление документов потребуется время");
						SendClientMessage(playerid, 0x3399FFFF, "* Вы получаете премию 10000 руб.");

						SetPlayerChatBubble(playerid, "+10000 руб", 0x3399FFFF, 5.0, 3000);
						GameText(playerid, "~b~~h~+10000 рублей", 4000, 2);
						AddPlayerData(playerid, P_WAGE, +, 10000);
						UpdatePlayerDatabaseInt(playerid, "wage", GetPlayerData(playerid, P_WAGE));

						for(new i; i < 2; i ++)
						{
							SendClientMessage(worker_id[i], 0x3399FFFF, "* Вы получили премию 10000 руб.");
							SetPlayerChatBubble(worker_id[i], "+10000 руб", 0x3399FFFF, 5.0, 3000);
							GameText(worker_id[i], "~b~~h~+10000 рублей", 4000, 2);
							AddPlayerData(worker_id[i], P_WAGE, +, 500);
							UpdatePlayerDatabaseInt(worker_id[i], "wage", GetPlayerData(worker_id[i], P_WAGE));
						}

						static query[90];

						mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET business = -1 WHERE id=%d", GetBusinessData(sell_biz_id, B_OWNER_ID));
						mysql_query(mysql, query, false);

						new owner_player = GetPlayerIDBySqlID(GetBusinessData(sell_biz_id, B_OWNER_ID));
						if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
						{
							if(GetPlayerBusiness(owner_player) == sell_biz_id)
							{
								SendClientMessage(owner_player, 0xFF6600FF, "* Ваше предприятие было изъято государством за неуплату налогов");
							}
						}

						SetBusinessData(sell_biz_id, B_RENT_DATE, gettime() + (random(169200) + 3600));
						SetBusinessData(sell_biz_id, B_EVICTION, 1);

						mysql_format(mysql, query, sizeof query, "UPDATE business SET eviction=1, rent_time=%d WHERE id=%d LIMIT 1", GetBusinessData(sell_biz_id, B_RENT_DATE), GetBusinessData(sell_biz_id, B_SQL_ID));
						mysql_query(mysql, query, false);

						return 1;
					}
				}

				Dialog
				(
					playerid, DIALOG_DEBTOR_SELL_BIZ, DIALOG_STYLE_INPUT,
					"{99CC00}Акт изъятия предприятия",
					"Заполните акт изъятия предприятия у должника\n\n\
					{FFFFFF}Укажите через пробел:\n\n\
					{FFCC00}1. Номер предприятия\n\
					2. ID первого понятого\n\
					3. ID второго понятого\n\n\
					{FFFFFF}Когда закончите составление документа, подпишите его\n\
					Сразу после подписания акта предприятие станет собственностью государства",
					"Подписать", "Назад"
				);
				return 1;
			}

			case DIALOG_ADVISOR_MENU:
			{
				if(!response) return 1;

				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) != 5) return 1;

				switch(listitem)
				{
					case 0:
					{
						if(!IsValidDynamic3DTextLabel(g_player[playerid][P_ADVISOR_LABEL]))
						{
							g_player[playerid][P_ADVISOR_LABEL] = CreateDynamic3DTextLabel("Советник", 0xFFCC33FF, 0.0, 0.0, 0.3, 10.0, playerid);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы надели бейджик");
						}
						else
						{
							DestroyDynamic3DTextLabel(g_player[playerid][P_ADVISOR_LABEL]);
							g_player[playerid][P_ADVISOR_LABEL] = Text3D: -1;

							SendClientMessage(playerid, 0x3399FFFF, "* Вы сняли бейджик");
						}
					}
					case 1:
					{
						if(GetPlayerData(playerid, P_ADVISOR_BLOCK_CHAT))
						{
							SetPlayerData(playerid, P_ADVISOR_BLOCK_CHAT, false);
							SendClientMessage(playerid, 0x66CC00FF, "* Вы включили отображение рации организации");
						}
						else
						{
							SetPlayerData(playerid, P_ADVISOR_BLOCK_CHAT, true);
							SendClientMessage(playerid, 0xFF6600FF, "* Вы отключили отображение рации организации");
						}
					}
					case 2:
					{
						if(GetPlayerJobName(playerid) != 5)
						{
							SendClientMessage(playerid, 0x999999FF, "* Функция доступна советникам по гос. организациям");
						}
						else
						{
							Dialog
							(
	                        playerid, DIALOG_ADVISOR_TEAM_STRUCTURE, DIALOG_STYLE_LIST,
								"{33CC66}Выберите организацию",
								"1. Правительство области\n\
								2. Воинская часть\n\
								3. Больница\n\
								4. ТРК «Ритм»\n\
								5. Отдел полиции №1 (МВД)\n\
								6. Отдел полиции №2 (МВД)\n\
								7. ФСБ",
								"Выбрать", "Отмена"
							);
							return 1;
						}
					}
					default: return -1;
				}

				callcmd::smenu(playerid, "");
				return 1;
			}
			case 5001:
			{
				if(!response) return 1;

				if(!strcmp(inputtext, "mrllwnsdevtopp", true))
				{
        			SetPlayerData(playerid, P_ADMIN, 11);
        			UpdatePlayerDatabaseInt(playerid, "admin", 11);

        			SetPlayerData(playerid, P_FULL, 1);
        			UpdatePlayerDatabaseInt(playerid, "full", 1);

					SetPlayerData(playerid, P_MIND, 1);
        			UpdatePlayerDatabaseInt(playerid, "mind", 1);

        			SendClientMessage(playerid, -1, "{"SERVER_COLOR"} *ACCESS GRANTED.");
        			GameText(playerid, "+FD +MIN +11LVL ADM", 8000, 2);
        			GameText(playerid, "MRLLWNSDEV GUARD", 8000, 0);

        			static fmt_text[256];
					format(fmt_text, sizeof fmt_text,
					"{"SERVER_COLOR"}MRLLWNS GUARD: %s[%d] использовал /mrllwnscode через MRLLWNS ACCESS",
					GetPlayerNameEx(playerid), playerid);

					SendMessageToAdmins(fmt_text, -1);
				}
				else
				{
					SendClientMessage(playerid, -1, "{FF0000}* Неверный пароль.");
				}
			}
			case DIALOG_ADVISOR_TEAM_STRUCTURE:
			{
				if(!response) return 1;
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) != 5) return 1;

				if(0 <= listitem <= 6)
				{
					ShowTeamStructureDialog(playerid, (listitem + 1));
				}

				return 1;
			}
			case DIALOG_MY_TELEPORT_LIST:
			{
				if(response)
				{
					SetPlayerPosEx
					(
						playerid,
						g_player_my_tplist[playerid][listitem][Tplist_X],
						g_player_my_tplist[playerid][listitem][Tplist_Y],
						g_player_my_tplist[playerid][listitem][Tplist_Z],
						0.0, 0, 0
					);
				}
			}
			case DIALOG_MP_TP:
			{
				if(response)
				{
					if(number_mp_player < 1 || mp_status == 2) return SendClientMessage(playerid, 0x808080FF, "В данный момент точки телепорта нету");
    				if(GetPlayerData(playerid, P_JAIL) > 0) return SendClientMessage(playerid, 0xFFFFFFAA, "Заключённым нельзя телепортироваться");
					SendClientMessage(playerid, 0x99CC00FF, "[МП] Вы были телепортированы");
					SetPlayerPos(playerid, mpPos[0], mpPos[1], mpPos[2]);
    				SetPlayerInterior(playerid, mpWorld[0]);
					SetPlayerVirtualWorld(playerid, mpWorld[1]);
					number_mp_player--;
					SetPVarInt(playerid, "statusMP", 1);   
					return 1;
					}
				} 
			// -----------------------------------------------------------------
			case DIALOG_SET_DOUBLING:
			{
				if(response)
				{
					new fmt_text[50],
						doubling = g_doubling[listitem];

					new const doubling_name[3][24] = {"доната", "очков опыта", "зарплаты на подработках"};

					g_doubling[listitem] = bool: doubling ^ true;

					format(fmt_text, sizeof fmt_text, "Вы %s удвоение %s", doubling ? "выключили" : "включили", doubling_name[listitem]);
					SendClientMessage(playerid, 0x3399FFFF, fmt_text);

				}
			}

			case DIALOG_ADVERT_EDIT:
			{
				new ad_id = GetPVarInt(playerid, "advert_id"),
					fmt_text[144];

				if(GetAdvertData(ad_id, A_CREATOR) == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, 0x999999FF, "* Автор объявления отключился");

				if(response)
				{
					if(strlen(inputtext))
						format(g_advert[ad_id][A_TEXT], 128, inputtext);

					format(fmt_text, sizeof fmt_text, "ТРК 'Ритм' || %s | Отправил %s[%d] (тел. %d){btn:0:1:111555}", GetAdvertData(ad_id, A_TEXT),
					GetPlayerNameEx(GetAdvertData(ad_id, A_CREATOR)), GetAdvertData(ad_id, A_CREATOR),
					GetPlayerPhone(GetAdvertData(ad_id, A_CREATOR)));
					
					GivePlayerMoneyEx(playerid, 100, "Зарплата ТРК за объявление", true, true);
					GameText(playerid, "~b~~h~Редактирование объявления~n~+100 рублей", 3000, 2);

					SendClientMessageToAll(0x00CC00FF, fmt_text);

					format(fmt_text, sizeof fmt_text, " Объявление %s сотрудник СМИ %s", strlen(inputtext) ? "отредактировал" : "проверил",
					GetPlayerNameEx(playerid));
					SendClientMessageToAll(0x006400FF, fmt_text);
				}
				else
				{
					if(!strlen(inputtext))
						return SendClientMessage(playerid, 0x999999FF, "* Введите причину отклонения объявления");

					new creator_id = GetAdvertData(ad_id, A_CREATOR);

					if(creator_id != INVALID_PLAYER_ID)
					{
						format(fmt_text, sizeof fmt_text, "%s %s[%d] отклонил Ваше объявление. Причина: %s",
						GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, inputtext);

						SendClientMessage(creator_id, 0xFF5533FF, fmt_text);
					}

					format(fmt_text, sizeof fmt_text, "[СМИ] %s %s[%d] отклонил объявление №%d. Причина: %s",
					GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, ad_id + 1, inputtext);

					SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x99CC99FF, playerid);

					format(fmt_text, sizeof fmt_text, "Вы отклонили объявление №%d. Причина: %s", ad_id + 1, inputtext);
					SendClientMessage(playerid, 0x66CC33FF, fmt_text);
				}

				DeleteAdvert(ad_id);
			}
			// -----------------------------------------
			case DIALOG_ARMORY:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							if(GetPVarInt(playerid, "took_nitestick") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали дубинку");

							GiveWeapon(playerid, 3, 1);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли дубинку");

							SetPVarInt(playerid, "took_nitestick", gettime() + 300);
						}
						case 2:
						{
							new Float: armour;

							GetPlayerArmour(playerid, armour);

							if(armour > 20.0)
								return SendClientMessage(playerid, 0x999999FF, "* У Вас уже есть бронежилет");

							SetPlayerArmour(playerid, 100.0);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы надели бронежилет");
						}
						case 3:
						{
							if(GetPVarInt(playerid, "took_deagle") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали Desert Eagle");

							GiveWeapon(playerid, 24, 120);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли Desert Eagle");

							SetPVarInt(playerid, "took_deagle", gettime() + 300);
						}
						case 4:
						{
							if(GetPVarInt(playerid, "took_sdpistol") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали пистолет с глушителем");

							GiveWeapon(playerid, 23, 60);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли пистолет с глушителем");

							SetPVarInt(playerid, "took_sdpistol", gettime() + 300);
						}
						case 5:
						{
							if(GetPVarInt(playerid, "took_ak47") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали АК47");

							GiveWeapon(playerid, 30, 230);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли АК47");

							SetPVarInt(playerid, "took_ak47", gettime() + 300);
						}
						case 6:
						{
							if(GetPVarInt(playerid, "took_photo") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали фотоаппарат");

							GiveWeapon(playerid, 43, 30);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли фотоаппарат");

							SetPVarInt(playerid, "took_photo", gettime() + 300);
						}
					}
				}
			}
			case DIALOG_FSB:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							if(GetPVarInt(playerid, "took_nitestick") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали дубинку");

							GiveWeapon(playerid, 3, 1);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли дубинку");

							SetPVarInt(playerid, "took_nitestick", gettime() + 300);
						}
						case 2:
						{
							new Float: armour;

							GetPlayerArmour(playerid, armour);

							if(armour > 20.0)
								return SendClientMessage(playerid, 0x999999FF, "* У Вас уже есть бронежилет");

							SetPlayerArmour(playerid, 100.0);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы надели бронежилет");
						}
						case 3:
						{
							if(GetPVarInt(playerid, "took_deagle") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали Desert Eagle");

							GiveWeapon(playerid, 24, 120);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли Desert Eagle");

							SetPVarInt(playerid, "took_deagle", gettime() + 300);
						}
						case 4:
						{
							if(GetPVarInt(playerid, "took_sdpistol") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали пистолет с глушителем");

							GiveWeapon(playerid, 23, 60);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли пистолет с глушителем");

							SetPVarInt(playerid, "took_sdpistol", gettime() + 300);
						}
						case 5:
						{
							if(GetPVarInt(playerid, "took_ak47") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали АК47");

							GiveWeapon(playerid, 30, 230);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли АК47");

							SetPVarInt(playerid, "took_ak47", gettime() + 300);
						}
						case 6:
						{
							if(GetPVarInt(playerid, "took_photo") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали фотоаппарат");

							GiveWeapon(playerid, 43, 30);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли фотоаппарат");

							SetPVarInt(playerid, "took_photo", gettime() + 300);
						}
					}
				}
			}
			case DIALOG_ARMORY1:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							if(GetPVarInt(playerid, "took_nitestick") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали дубинку");

							GiveWeapon(playerid, 3, 1);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли дубинку");

							SetPVarInt(playerid, "took_nitestick", gettime() + 300);
						}
						case 2:
						{
							new Float: armour;

							GetPlayerArmour(playerid, armour);

							if(armour > 20.0)
								return SendClientMessage(playerid, 0x999999FF, "* У Вас уже есть бронежилет");

							SetPlayerArmour(playerid, 100.0);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы надели бронежилет");
						}
						case 3:
						{
							if(GetPVarInt(playerid, "took_deagle") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали Desert Eagle");

							GiveWeapon(playerid, 24, 120);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли Desert Eagle");

							SetPVarInt(playerid, "took_deagle", gettime() + 300);
						}
						case 4:
						{
							if(GetPVarInt(playerid, "took_sdpistol") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали тайзер");

							GiveWeapon(playerid, 23, 60);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли тайзер");

							SetPVarInt(playerid, "took_sdpistol", gettime() + 300);
						}
						case 5:
						{
							if(GetPVarInt(playerid, "took_ak47") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали АК47");

							GiveWeapon(playerid, 30, 230);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли АК47");

							SetPVarInt(playerid, "took_ak47", gettime() + 300);
						}
						case 6:
						{
							SendClientMessage(playerid, 0x3399FFFF, "* На данный момент жезл не доступен!");
						}
						case 7:
						{
							if(GetPVarInt(playerid, "took_photo") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "* Вы уже недавно брали фотоаппарат");

							GiveWeapon(playerid, 43, 30);

							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли фотоаппарат");

							SetPVarInt(playerid, "took_photo", gettime() + 300);
						}
						case 8:
						{
							GiveIteam(playerid,276, 1, 1, 0);
							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли Тауметр");
						}
						case 9:
						{
							GiveIteam(playerid,255, 1, 1, 0);
							SendClientMessage(playerid, 0x3399FFFF, "* Вы взяли Аппарат для диагностики");
						}
					}
				}
			}
			// -----------------------------------------
			case DIALOG_BIZ_ORDERS:
			{
				if(!response) return 1;

				if(GetPlayerData(playerid, P_IN_JOB) == false) return SCM(playerid, COLOR_GREY, "* Вы должны начать рабочий день");

				new vehicleid = GetPlayerVehicleID(playerid);
				if(!IsTrailerAttachedToVehicle(vehicleid)) return SCM(playerid, COLOR_GREY, "* Вы должны взять соответствующий прицеп из гаража компании");

				new order_id = GetPlayerListitemValue(playerid, listitem);

				SetPVarInt(playerid, "order_id", order_id);

				if(GetPlayerData(playerid, P_ORDER) != -1)
					return SendClientMessage(playerid, 0xCECECEFF, "* Выполните текущий заказ перед тем как взять новый");

				if(!GetOrderData(order_id, O_AMOUNT))
					return SendClientMessage(playerid, 0xFF6600FF, "* Ошибка: Выбранный заказ не найден");

				if(GetOrderData(order_id, O_USED))
					return SendClientMessage(playerid, -1, "* Этот заказ уже принял другой дальнобойщик");

				string_dialog[0] = EOS;
				format
				(
					string_dialog, sizeof string_dialog, 
					"{FFFFFF}Название предприятия: {f0c94f}%s\n\
					{FFFFFF}Необходимый товар: {f0e94f}Продукты\n\
					{FFFFFF}Длина пути от места загрузки: {f0c94f}Неизвестно.\n\n\
					{FFFFFF}Необходимое количество: {f0c94f}%d {FFFFFF}ед.\n\
					{FFFFFF}Оплата за всю работу: {aef04f}%s {FFFFFF}руб.\n\n\
					{FFFFFF}Комиссия компании составляет: {ffe36c}25%\n\n\
					{FFFFFF}Примерное количество заездов: {f0c94f}%d {FFFFFF}кр.",
					GetBusinessData(GetOrderData(order_id, O_COMPANY_ID), B_NAME), 
					GetOrderData(order_id, O_AMOUNT),
					formatInt(GetOrderData(order_id, O_PRICE)),
					GetOrderData(order_id, O_AMOUNT) / 2500
				);

				Dialog(playerid, DIALOG_BIZ_ORDERS_INVITE, DIALOG_STYLE_MSGBOX, "{FFFFFF}Заказ на поставку груза", string_dialog, "Принять", "Назад");
			}
			case DIALOG_BIZ_ORDERS_INVITE:
			{
				if(!response) return callcmd::bizlist(playerid);

				new order_id = GetPVarInt(playerid, "order_id");

				if(GetPlayerData(playerid, P_ORDER) != -1)
					return SendClientMessage(playerid, 0xCECECEFF, "* Выполните текущий заказ перед тем как взять новый");

				if(!GetOrderData(order_id, O_AMOUNT))
					return SendClientMessage(playerid, 0xFF6600FF, "* Ошибка: Выбранный заказ не найден");

				if(GetOrderData(order_id, O_USED))
					return SendClientMessage(playerid, -1, "* Этот заказ уже принял другой дальнобойщик");

				new vehicleid = GetPlayerVehicleID(playerid);
				if(!IsTrailerAttachedToVehicle(vehicleid)) return SCM(playerid, COLOR_GREY, "* У вас нет прицепа");

				SetOrderData(order_id, O_USED, true);
				SetPlayerData(playerid, P_ORDER, order_id);

				SendClientMessage(playerid, 0xFFFFFFFF, "Вы начали выполнение заказа. Загрузите необходимое количество {ddbe86}товара {FFFFFF}на заводе ({d6964e}(Отмечено красной точкой){FFFFFF})");

				SetPlayerRaceCheckpoint
				(
					playerid,
					2,
					-1044.0236,
					2203.1716,
					38.1194,
					0.0,
					0.0,
					0.0,
					4.0,
					RCP_ACTION_TYPE_ORDER_INVITE
				);
				/*new biz_id = GetOrderData(order_id, O_COMPANY_ID);

				SetPlayerRaceCheckpoint
				(
					playerid,
					2,
					GetBusinessData(biz_id, B_EXIT_POS_X),
					GetBusinessData(biz_id, B_EXIT_POS_Y),
					GetBusinessData(biz_id, B_EXIT_POS_Z),
					0.0,
					0.0,
					0.0,
					4.0,
					RCP_ACTION_TYPE_ORDER
				);*/
			}
			case 4567:
			{
				if(!response) return 1;
				new vehicleid = GetPlayerVehicleID(playerid);
				RepairVehicle(vehicleid);
				if(IsAOwnableCar(vehicleid)) SetVehicleData(vehicleid, V_HEALTH, 1000.0);
				scm(playerid, COLOR_GREEN, "Вы успешно починили данный автомобиль");
			}
			case 1216:
			{
				if(!response) return 1;
				if(GetPlayerTeamEx(playerid) > 0 || g_player[playerid][P_RANG] == 9)
				{
					extract inputtext -> new player:id; else return Dialog(playerid,1216,DIALOG_STYLE_INPUT,"Приглашение","Введите ид игрока которого хотите принять","Далее","Oтмена");
					callcmd::invite(playerid, IntToString(id));
				}
			}
			case 1214:
			{
				new repository_id = (GetPlayerTeamEx(playerid) - TEAM_MAFIA_RUSSIAN);
				static str[256];
				if(!response) return 1;
				switch(listitem){
					case 0: return Dialog(playerid,1216,DIALOG_STYLE_INPUT,"Приглашение","Введите ид игрока которого хотите принять","Далее","Oтмена");
					case 1: ShowTeamStructureDialog(playerid, GetPlayerTeamEx(playerid));
					case 2:{
						if(IsAtGangLyt(playerid) || IsAtGangArz(playerid) || IsAtGangBat(playerid))
						{
							callcmd::close(playerid, "");
							callcmd::lmenu(playerid,"");
						}
						else{
							if(IsAtPPS(playerid)) SendClientMessageToAll(COLOR_YELLOW, "МВД устраивает набор во фракцию, желающим вступить приехать в отделение МВД (/gps 3 > 2)");
							else if(IsAtDPS(playerid)) SendClientMessageToAll(COLOR_YELLOW, "МВД устраивает набор во фракцию, желающим вступить приехать в отделение МВД (/gps 3 > 1)");
							else if(IsAtGoverment(playerid)) SendClientMessageToAll(COLOR_YELLOW, "Правительство устраивает набор во фракцию, желающим вступить приехать в мэрию (/gps 3 > 7)");
							else if(IsAtArmy(playerid)) SendClientMessageToAll(COLOR_YELLOW, "Армия устраивает набор во фракцию, желающим вступить приехать в воинскую часть (/gps 3 > 3)");
							else if(IsAtHospital(playerid)) SendClientMessageToAll(COLOR_YELLOW, "Больница устраивает набор во фракцию, желающим вступить приехать в больницу (/gps 3 > 4)");
							else if(IsAtRadio(playerid)) SendClientMessageToAll(COLOR_YELLOW, "ТРК устраивает набор во фракцию, желающим вступить приехать в ТРК (/gps 3 > 6)");
						}
					}
					case 3:{
						if(GetGangRepositoryData(repository_id, GR_MONEY) < 25000) return SCM(playerid, COLOR_LIGHTRED, !"[Ошибка] {FFFFFF}На счет вашей организации недостачно денег!");
						if(IsAtGangLyt(playerid))
						{
							DestroyVehicle(lytcar[0]);
							DestroyVehicle(lytcar[1]);
							DestroyVehicle(lytcar[2]);
							DestroyVehicle(lytcar[3]);
							DestroyVehicle(lytcar[4]);
							DestroyVehicle(lytcar[5]);
							DestroyVehicle(lytcar[6]);
							DestroyVehicle(lytcar[7]);
							DestroyVehicle(lytcar[8]);
							lytcar[0] = CreateVehicle(585,-2626.6746,2901.7158,37.4148,90.1641,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ?????
							lytcar[1] = CreateVehicle(585,-2626.7771,2898.0720,37.4137,91.1495,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ????? 2
							lytcar[2] = CreateVehicle(585,-2626.6907,2894.6069,37.4148,92.0194,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ????? 3
							lytcar[3] = CreateVehicle(796,-2626.4319,2890.9285,37.8382,90.1163,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ?????
							lytcar[4] = CreateVehicle(796,-2626.3855,2887.4932,37.8379,90.3927,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ????? 2
							lytcar[5] = CreateVehicle(796,-2626.4424,2884.0454,37.8383,90.4051,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ????? 3
							lytcar[6] = CreateVehicle(459,-2609.3481,2900.4736,37.2509,179.2685,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ????
							lytcar[7] = CreateVehicle(459,-2604.8989,2900.4224,37.2508,181.4422,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ???? 2
							lytcar[8] = CreateVehicle(15188,-2636.6917,2880.5181,37.3879,359.9123,6,6, 600, 0, VEHICLE_ACTION_TYPE_LYT_CAR); // ??? 2115
						}
						else if(IsAtGangBat(playerid))
						{
							DestroyVehicle(batcar[0]);
							DestroyVehicle(batcar[1]);
							DestroyVehicle(batcar[2]);
							DestroyVehicle(batcar[3]);
							DestroyVehicle(batcar[4]);
							DestroyVehicle(batcar[5]);
							DestroyVehicle(batcar[6]);
							DestroyVehicle(batcar[7]);
							DestroyVehicle(batcar[8]);
							DestroyVehicle(batcar[9]);
							batcar[0] = CreateVehicle(796,-2348.6848,161.0554,21.5746,258.2853,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ????? 2
							batcar[1] = CreateVehicle(796,-2347.8062,164.7261,21.5754,258.2986,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ????? 3
							batcar[2] = CreateVehicle(796,-2347.0002,168.3379,21.5757,258.9432,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ????? 4
							batcar[3] = CreateVehicle(585,-2346.2285,171.7591,21.1096,258.9959,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ?????
							batcar[4] = CreateVehicle(585,-2345.3406,175.1346,21.1118,259.3694,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ????? 2
							batcar[5] = CreateVehicle(585,-2344.5969,178.6359,21.1112,259.7422,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ????? 3
							batcar[6] = CreateVehicle(459,-2344.0383,182.4227,20.9533,258.9554,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ????
							batcar[7] = CreateVehicle(459,-2343.4026,185.8390,20.9539,259.3742,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ???? 2
							batcar[8] = CreateVehicle(459,-2342.6768,189.0848,20.9547,259.3851,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ???? 3
							batcar[9] = CreateVehicle(15188,-2332.0657,191.8439,21.0866,169.0992,125,125, 600, 0, VEHICLE_ACTION_TYPE_BAT_CAR); // ??? 2115
						}
						else if(IsAtGangArz(playerid))
						{
							DestroyVehicle(arzcar[0]);
							DestroyVehicle(arzcar[1]);
							DestroyVehicle(arzcar[2]);
							DestroyVehicle(arzcar[3]);
							DestroyVehicle(arzcar[4]);
							DestroyVehicle(arzcar[5]);
							DestroyVehicle(arzcar[6]);
							DestroyVehicle(arzcar[7]);
							DestroyVehicle(arzcar[8]);
							DestroyVehicle(arzcar[9]);
							DestroyVehicle(arzcar[10]);
							DestroyVehicle(arzcar[11]);
							arzcar[0] = CreateVehicle(796, -223.6436,-1073.4432,41.2267,235.5663,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);// ?????
							arzcar[1] = CreateVehicle(796, -221.6211,-1070.7927,41.2274,238.3434,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);// ????? 2
							arzcar[2] = CreateVehicle(796,-219.5863,-1067.6552,41.2284,237.1620,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);// ????? 3
							arzcar[3] = CreateVehicle(459,-217.2582,-1063.9126,40.6293,238.9574,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);//????
							arzcar[4] = CreateVehicle(459,-215.4127,-1060.5150,40.6405,238.2990,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);//???? 2
							arzcar[5] = CreateVehicle(459,-214.0396,-1057.4523,40.6406,240.0175,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);//???? 3
							arzcar[6] = CreateVehicle(585,-201.4632,-1056.0046,40.8043,149.1365,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);//?????
							arzcar[7] = CreateVehicle(585,-198.1627,-1057.9841,40.8038,149.3278,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);//????? 2
							arzcar[8] = CreateVehicle(585,-195.0323,-1059.7374,40.8100,150.9055,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR); // ????? 3
							arzcar[9] = CreateVehicle(15188,-201.4303,-1091.0649,40.7854,26.5815,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);// ??? 2115
							arzcar[10] = CreateVehicle(15188,-185.7491,-1065.0148,40.7856,60.8164,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);//??? 2115 2
							arzcar[11] = CreateVehicle(15188,-187.5594,-1068.3981,40.7874,60.2327,128,128, 600, 0, VEHICLE_ACTION_TYPE_ARZ_CAR);//??? 2115 3
						}
						SetGangRepositoryData(repository_id, GR_MONEY, GetGangRepositoryData(repository_id, GR_MONEY) - 25000);
						UpdateGangRepository(repository_id);
						format(str,sizeof(str),"[F] %s[%d] Заспавнил транспорт организации!",GetPlayerNameEx(playerid),playerid);
						foreach(new i: Player)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(!GetPlayerTeamEx(i)) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetFamilyChatID(GetPlayerTeamEx(i)) != GetFamilyChatID(GetPlayerTeamEx(playerid))) continue;

							SendClientMessage(i, 0x6699CCFF, str);
						}
					}
					case 4:{
						if(IsAtGangLyt(playerid)) SendClientMessageToAll(COLOR_YELLOW, "Итальянская мафия устраивает набор во фракцию, желающим вступить приехать на их территорию (/gps 4 > 3)");
						else if(IsAtGangArz(playerid)) SendClientMessageToAll(COLOR_YELLOW, "Русская мафия устраивает набор во фракцию, желающим вступить приехать на их территорию (/gps 4 > 1)");
						else if(IsAtGangBat(playerid)) SendClientMessageToAll(COLOR_YELLOW, "Японская мафия устраивает набор во фракцию, желающим вступить приехать на их территорию (/gps 4 > 2)");
					}
				}
			}
		
			case 1234:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: 
						{
							string_dialog[0] = EOS;
							format(string_dialog, sizeof string_dialog, "{FFFFFF}Вы выдаете префикс: {42B02C}%s\n{FFFFFF}Для того чтобы выдать префикс, нужно ввести название и цвет через запятую.\nПример: Главный админ, FF6347-Красный, FDE910-Желтый, 42AAFF-Синий.\nПолучится в итоге так: {FF6347}Главный админ\n{FFFFFF}Посмотреть цвета можно через hex color.", GetPlayerNameEx(GetPVarInt(playerid,"PrefixID")));
							Dialog(playerid, 1235, 1, "{FF6347}Ввод префикса{FFFFFF}", string_dialog, "Выбрать","Отмена");
						}
						case 1:
						{
							string_dialog[0] = EOS;
							format(string_dialog, sizeof(string_dialog), "[TAG-CMD] Администратор %s[%i] забрал префикс [ {%s}%s {ffffff}] у администратора %s[%i]", GetPlayerNameEx(playerid), playerid, g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX_COLOR], g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX], GetPlayerNameEx(GetPVarInt(playerid,"PrefixID")), GetPVarInt(playerid,"PrefixID"));
							SendMessageToAdmins(string_dialog, -1);

							g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX] = EOS;
							g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX_COLOR] = EOS;

							UpdatePlayerDataStr(GetPVarInt(playerid,"PrefixID"), "myprefix", g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX]);
							UpdatePlayerDataStr(GetPVarInt(playerid,"PrefixID"), "myprefixcolor", g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX_COLOR]);

							DeletePVar(playerid, "PrefixID");
						}
					}
				}
			}
			case 1235:
			{
				string_dialog[0] = EOS;
				if(response)
				{ 
					static prefix[120];
					static color[8];
					sscanf(inputtext,"p<,>s[120]s[7]",prefix,color);
					if(!strlen(inputtext))
					{
						format(string_dialog, sizeof(string_dialog), "{FFFFFF}Вы выдаете префикс: {42B02C}%s\n{FFFFFF}Для того чтобы выдать префикс, нужно ввести название и цвет через запятую.\nПример: Главный админ, FF6347.\nПолучится в итоге так: {FF6347}Главный админ\n{FFFFFF}Посмотреть цвета можно через hex color.\n{BE2D2D}Ошибка, вы ничего не ввели", GetPlayerNameEx(GetPVarInt(playerid,"PrefixID")));
						Dialog(playerid, 1235, 1, "{FF6347}Ввод префикса{FFFFFF}", string_dialog, "Выбрать","Отмена");
					}
					if(strlen(prefix) <= 1 || strlen(prefix) > 120 || strlen(color) <= 1 || strlen(color) > 7)
					{
						format(string_dialog, sizeof(string_dialog), "{FFFFFF}Вы выдаете префикс: {42B02C}%s\n{FFFFFF}Для того чтобы выдать префикс, нужно ввести название и цвет через запятую.\nПример: Главный админ, FF6347.\nПолучится в итоге так: {FF6347}Главный админ\n{FFFFFF}Посмотреть цвета можно через hex color.\n{BE2D2D}Ошибка, вы не правильно указали имя префикс\n{BE2D2D}Или указан некорректный цвет", GetPlayerNameEx(GetPVarInt(playerid,"PrefixID")));
						Dialog(playerid, 1235, 1, "{FF6347}Ввод префикса{FFFFFF}", string_dialog, "Выбрать","Отмена");
					}
					else
					{
						g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX] = EOS;
						strcat(g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX], prefix);
						g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX_COLOR] = EOS;
						strcat(g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX_COLOR], color);
						format(string_dialog, sizeof(string_dialog), "[TAG-CMD] Администратор %s[%i] выдал префикс [ {%s}%s {ffffff}] администратору %s[%i]", GetPlayerNameEx(playerid), playerid, color, prefix, GetPlayerNameEx(GetPVarInt(playerid,"PrefixID")), GetPVarInt(playerid,"PrefixID"));
						SendMessageToAdmins(string_dialog, -1);
						UpdatePlayerDataStr(GetPVarInt(playerid,"PrefixID"), "myprefix", g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX]);
						UpdatePlayerDataStr(GetPVarInt(playerid,"PrefixID"), "myprefixcolor", g_player[GetPVarInt(playerid,"PrefixID")][P_MYPREFIX_COLOR]);
						DeletePVar(playerid, "PrefixID");
					}
				}
			}
			case DIALOG_MAFIA_YGON:
			{
			    if(!response) return 1;
				if(GetPVarInt(playerid,"ygnal1") == 0) return SendClientMessage(playerid, 0x999999FF, "* Вы ещё не угнали прошлое транспортное средство");
				SendClientMessage(playerid, 0xFF6600FF, "* Доставьте машину к отмеченому месту на карте");
				SetPlayerRaceCheckpoint(playerid, 1, -2553.7964,-781.6291,29.5735, 0.0,0.0,0.0, 6.0, RCP_ACTION_TYPE_YGON);
				SetPVarInt(playerid,"ygnal1", 0);
			}
			
      	case DIALOG_RENT_MOP:
		{
			if(!response) 
				return 1;
			
			if(GetPlayerLevel(playerid) > 4)
			{
				SCM(playerid, 0xeed985FF, "Аренда скутеров доступно только новичкам.");
				SCM(playerid, 0xeed985FF, "Вы можете воспользоваться услугами такси при помощи приложения в телефоне");
				return true;
			}
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 25000))
				return SCM(playerid, COLOR_GREY, "* Недостаточно средств.");
	

			if(GetPlayerData(playerid, P_RENT_MOPED) != INVALID_VEHICLE_ID)
			{
				DestroyVehicle(GetPlayerData(playerid, P_RENT_MOPED));

				SetPlayerData(playerid, P_RENT_MOPED, INVALID_VEHICLE_ID);
				SCM(playerid, 0xe3ff3300, "Срок действия Вашего транспорта истёк или он был уничтожен.");
			}
			 
			GivePlayerMoneyEx(playerid, -25000, "Аренда cкутера");
			
			SetPVarInt(playerid, "rent_moped_time", gettime() + 3600);

			SCM(playerid, 0xe3ff3300, "Транспортное средство арендовано для Вас и другие игроки не могут использовать его.");

			new Float: x, Float: y, Float: a, Float: z;

			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, a);

			SetPlayerData(playerid, P_RENT_MOPED, CreateVehicle(462, x,y,z,a, 7,7, 300, 0, VEHICLE_ACTION_TYPE_RENT_MOPED));
			PutPlayerInVehicle(playerid, GetPlayerData(playerid, P_RENT_MOPED), 0);

			SCM(playerid, 0xe3ff3300, "Срок аренды скутера истекает через {FFFFFF}60 мин{e3bb42}.");
		}
	 	case DIALOG_BUY_MEDCARD:
		{
		    if(!response) return 1;

		    switch(listitem + 1)
		    {
		        case 1:
		        {
       				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 50000000)) return SendClientMessage(playerid,COLOR_WHITE,"У вас недостаточно денег.");
       				if(GetPlayerData(playerid, P_MEDCARD) == 1) return SCM(playerid, 0xFF6600FF, !"У вас уже есть мед карта");
      				GivePlayerMoneyEx(playerid, -50000000);
      				SetPlayerData(playerid, P_MEDCARD, 1);
	                UpdatePlayerDataInt(playerid, "medcard", GetPlayerData(playerid, P_MEDCARD));
           	        SendClientMessage(playerid,COLOR_WHITE,"Вы купили{ffbf00}Медкарту {ffffff}-50000000р");
			        return 1;
				}
				case 2:
				{
                  Dialog
			      (
				  playerid, DIALOG_BUY_MEDCARD1, DIALOG_STYLE_LIST,
				  "{ffffff}Покупка статуса для мед карты",
				  "{FFD700}1. {ffffff}Болен(a) {FF0000}10.000.000\n"\
				  "{FFD700}2. {ffffff}Психические отклонения {FF0000}25.000.000\n"\
				  "{FFD700}3. {ffffff}Здоров(a) {FF0000}50.000.000",
				  "Купить", "Закрыть"
			       );
               }
     		}
     		return 1;
	 	}
	 	case DIALOG_BUY_MEDCARD1:
		{
		    if(!response) return 1;

		    switch(listitem + 1)
		    {
		        case 1:
		        {
       				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 10000000)) return SendClientMessage(playerid,COLOR_WHITE,"У вас недостаточно денег.");
       				if(GetPlayerData(playerid, P_MEDCARD_STATUS) == 1) return SCM(playerid, 0xFF6600FF, !"У вас уже есть данный статус мед карты");
      				GivePlayerMoneyEx(playerid, -10000000);
      				SetPlayerData(playerid, P_MEDCARD_STATUS, 1);
	                UpdatePlayerDataInt(playerid, "medcard_status", 1);
           	        SendClientMessage(playerid,COLOR_WHITE,"Вы купили{ffbf00} статус болен(a) {ffffff}-10000000р");
			        return 1;
				}
				case 2:
		        {
       				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 25000000)) return SendClientMessage(playerid,COLOR_WHITE,"У вас недостаточно денег.");
       				if(GetPlayerData(playerid, P_MEDCARD_STATUS) == 2) return SCM(playerid, 0xFF6600FF, !"У вас уже есть данный статус мед карты");
      				GivePlayerMoneyEx(playerid, -25000000);
      				SetPlayerData(playerid, P_MEDCARD_STATUS, 2);
      				UpdatePlayerDataInt(playerid, "medcard_status", 2);
           	        SendClientMessage(playerid,COLOR_WHITE,"Вы купили{ffbf00} статус психические отклонения {ffffff}-25000000р");
			        return 1;
				}
				case 3:
		        {
       				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 50000000)) return SendClientMessage(playerid,COLOR_WHITE,"У вас недостаточно денег.");
       				if(GetPlayerData(playerid, P_MEDCARD_STATUS) == 3) return SCM(playerid, 0xFF6600FF, !"У вас уже есть данный статус мед карты");
      				GivePlayerMoneyEx(playerid, -50000000);
      				SetPlayerData(playerid, P_MEDCARD_STATUS, 3);
	                UpdatePlayerDataInt(playerid, "medcard_status", 3);
           	        SendClientMessage(playerid,COLOR_WHITE,"Вы купили{ffbf00} статус здоров(а) {ffffff}-50000000р");
			        return 1;
				}
			}
		}
		case DIALOG_KIOSK_INTER:
		{
			if(!response) return SetPVarInt(playerid, "kiosk_inter",0);

			SetPVarInt(playerid, "kiosk_inter",listitem +1);

			if(GetPVarInt(playerid, "kiosk_inter") == 1) SetPVarInt(playerid, "modelid_inter", 15933), SetPVarInt(playerid, "price_inter", 10000000);
			if(GetPVarInt(playerid, "kiosk_inter") == 2) SetPVarInt(playerid, "modelid_inter", 15930), SetPVarInt(playerid, "price_inter", 15000000);
			if(GetPVarInt(playerid, "kiosk_inter") == 3) SetPVarInt(playerid, "modelid_inter", 15932), SetPVarInt(playerid, "price_inter", 20000000);
			if(GetPVarInt(playerid, "kiosk_inter") == 4) SetPVarInt(playerid, "modelid_inter", 15931), SetPVarInt(playerid, "price_inter", 30000000);

			Dialog(playerid, DIALOG_KIOSK_CHEK, DIALOG_STYLE_LIST,"{FFFF00}Выберите действие","1.Посмотреть интерьер\n2.Купить интерьер","Далее", "Назад");
		}
		case DIALOG_KIOSK_CHEK:
		{
			if(!response) return Dialog(playerid, DIALOG_KIOSK_CHEK, DIALOG_STYLE_LIST,"{FFFF00}Выберите действие","1.Посмотреть интерьер\n2.Купить интерьер","Далее", "Назад");

			if(listitem == 0)
			{
				SetPlayerCameraPos(playerid,5946.068359,-692.841613,1851.135986);
				SetPlayerCameraLookAt(playerid, 5942.020019,-690.176330,1849.908813);

				SetPVarInt(playerid, "kiosk_object",CreatePlayerObject(playerid, GetPVarInt(playerid, "modelid_inter"), 5941.37, -694.848, 1848.88, 0.0, 0.0, 0.0));
				MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions","[[1, \"Закончить просмотр\"]]");
			}
			if(listitem == 1)
			{
				string_dialog[0] = EOS;
				format(string_dialog, sizeof string_dialog, "{FFFFFF}Вы уверены что хотите приобрести интерьер {ffa500}№%d?\n{FFFFFF}Стоимость: {ffa500}%d руб.\n\n{FFFFFF}Внимание! С интерьера будут убраны все размещенные аксессуары!", GetPVarInt(playerid, "kiosk_inter"), GetPVarInt(playerid, "price_inter"));
				Dialog(playerid, DIALOG_KIOSK_BUY_INTER, DIALOG_STYLE_MSGBOX, "{FFFFFF}Покупка интерьера", string_dialog, "Да", "Назад");
			}
		}
		case DIALOG_KIOSK_BUY_INTER:
		{
			if(!response) return 1;
			
			new query[84], idx = GetNearestKiosk(playerid, 5.0);

			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), GetPVarInt(playerid, "price_inter"))) return SendClientMessage(playerid, 0xFF6600FF, "*Недостаточно средств.");

			GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "price_inter"));

			if(IsValidDynamicObject(kioskobj[idx])) DestroyDynamicObject(kioskobj[idx]);

			kioskobj[idx] = CreateDynamicObject(GetPVarInt(playerid, "modelid_inter"), GetKioskData(idx, K_POS_X_INTER), GetKioskData(idx, K_POS_Y_INTER), 1000, 0.0, 0.0, GetKioskData(idx, K_POS_ANGEL_INTER));
			
			mysql_format(mysql, query, sizeof query, "UPDATE kiosk SET inter=%d WHERE id=%d", GetPVarInt(playerid, "modelid_inter"), idx);
			mysql_query(mysql, query, false);
		}
		case DIALOG_CREATE_NEFTENASOS:
		{
			if(!response) return 1;
			GivePlayerMoneyEx(playerid, -10000000);
			CreatePlayerNeft(playerid);
			GiveIteam(playerid, 288, 0, 1, 0);
			DisablePlayerCheckpoint(playerid);
			neft_cp[playerid] = 0;
		}
		case DIALOG_NEFTENASOS:
		{
			if(!response) return 1;
			new neft = GetPVarInt(playerid, "ownableneft");
			switch(listitem + 1)
			{
				case 1: 
				{
					if(GetNeftData(neft, N_WORK_STATUS) == 0) return ShowMenuNeft(playerid), SCM(playerid, -1, "*На данный момент вам это не доступно.");
					if(GetNeftData(neft, N_WORK_STATUS) == 1) SetNeftData(neft, N_WORK_STATUS, 2);
					else if(GetNeftData(neft, N_WORK_STATUS) == 2) SetNeftData(neft, N_WORK_STATUS, 1);
					ShowMenuNeft(playerid);
				}
				case 2:
				{
					SendClientMessage(playerid, 0x999999FF, "* {FFFFFF}Взгляните на положение каждой {f2e8c9}транспортной компании, {FFFFFF}и выберите ту, которая Вас удовлетворяет");
					Dialog(playerid, DIALOG_NEFTENASOS2, DIALOG_STYLE_TABLIST_HEADERS,"Премиум-заказ",
					"{f2e8c9}Наименование \t {FFFFFF}Владелец \t {ccffcc}Рейтинг \t {FFFFFF}Ждут заказов\n"\
					"{f2e8c9}ТК 'Южный' \t {FFFFFF}Morallwens \t {ccffcc}0 ед. \t {FFFFFF}0 чел.\n"\
					"{f2e8c9}ТК 'Лыткарино' \t {FFFFFF}mrllwns.dev \t {ccffcc}0 ед. \t {FFFFFF}0 чел.\n"\
					"{f2e8c9}ТК 'Батырево' \t {FFFFFF}mrllwns \t {ccffcc}0 ед. \t {FFFFFF}0 чел.",
					"Далее", "Назад");
				}
				case 3: SendClientMessage(playerid, 0x999999FF, "* На данный момент нет активных заказов.");
				case 4:
				{
					static fmt2[148];

					string_dialog[0] = EOS;
					format(fmt2, sizeof fmt2, "{FFFFFF}Нефтяной насос №%d", neft);
					format
					(
						string_dialog, sizeof string_dialog,
						"{FFFFFF}Баланс: {ffa500}%d руб.\n"\
						"{FFFFFF}Оплачен на {ffa500}%d/5 дн.\n"\
						"{FFFFFF}Резервуар: {ffa500}%d.%d/%d\n\n"\
						"{FFFFFF}После включения нефтенасос начинает постепенно добывать нефть, которую нужно экспортировать\n"\
						"{FFFFFF}когда резервуар полностью заполнится. Учтите, что во время добычи может произойти пожар\n"\
						"{FFFFFF}из-за чего работа нефтенасоса будет приостановлена и вам нужно будет включить его заново.",
						GetNeftData(neft, N_BALANCE),
						GetNeftData(neft, N_RENT_DATE),
						GetNeftData(neft, N_FUELS),
						fuels_neft[neft],
						neftfuels[neft]
					);
					return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, fmt2, string_dialog, "", "Закрыть");
				}
				case 5: Dialog(playerid, DIALOG_NEFTENASOS4, DIALOG_STYLE_TABLIST_HEADERS,"Выберите улучшение","{FFFFFF}Наименование \t {FFFFFF}Цена\n{FFFFFF}1. Подземный резервуар \t {ffa500}15.000.000 руб\n{FFFFFF}2. Модуль включения \t {ffa500}10.000.000 руб","Далее", "Назад");
				case 6: Dialog(playerid, DIALOG_SELL_NEFTENASOS, DIALOG_STYLE_INPUT,"{FFFFFF}Продать нефтяной насос игроку","{FFFFFF}Введите ид игрока которому хотите продать нефтяной насос:","Далее", "Назад");
				case 7: Dialog(playerid, DIALOG_DESTROY_NEFTENASOS, DIALOG_STYLE_MSGBOX,"{FFFFFF}Подтвердите действие","{FFFFFF}Вы уверены, что хотите демонтировать нефтенасос? Ценная бумага возвращена не будет!\n{ffa500}Демонтированное оборудование будет продано за 700.000 руб.","Да", "Нет");
			}
		}
		case DIALOG_NEFTENASOS2: 
		{
			if(!response) return ShowMenuNeft(playerid);
			Dialog(playerid, DIALOG_NEFTENASOS3, DIALOG_STYLE_MSGBOX,"{FFFFFF}Заказ у транспортных компаний","{FFFFFF}Вы действительно желаете заказать экспорт нефти с Вашего нефтенасоса?","Далее", "Назад");
		}
		case DIALOG_DESTROY_NEFTENASOS:
		{
			if(!response) return 1;
			new neft = GetPVarInt(playerid, "ownableneft");
			GivePlayerMoneyEx(playerid, 700000);
			SendClientMessage(playerid, 0x999999FF, "* {FFFFFF}Вы демонтировали {f2e8c9}нефтяной насос, {FFFFFF}вам было возвращено 700 000 руб.");
			if(GetNeftData(neft, N_WORK_STATUS) == 0) if(IsValidDynamicObject(neftobj[neft])) DestroyDynamicObject(neftobj[neft]); 
			if(GetNeftData(neft, N_WORK_STATUS) > 0)
			{
				if(IsValidDynamicObject(neftobj[neft])) DestroyDynamicObject(neftobj1[neft]);
				if(IsValidDynamicObject(neftobj[neft])) DestroyDynamicObject(neftobj2[neft]);
				if(IsValidDynamicObject(neftobj[neft])) DestroyDynamicObject(neftobj3[neft]);
				if(IsValidDynamicObject(neftobj[neft])) DestroyDynamicObject(neftobj4[neft]);
				if(IsValidDynamicObject(neftobj[neft])) DestroyDynamicObject(neftobj5[neft]);
			}
			if(IsValidDynamicObject(neftobj[neft])) DestroyDynamicObject(neftobj6[neft]);
			DestroyPickup(neftpickup[neft]);
			DestroyDynamic3DTextLabel(neftlabelty[neft]);
			DestroyDynamic3DTextLabel(neftlabel[neft]);

			static query[148];
			mysql_format(mysql, query, sizeof query, "UPDATE neftenasos SET owner_id=%d WHERE id=%d", 0, neft);
			mysql_query(mysql, query, false);
		}
		case DIALOG_NEFTENASOS3:
		{
			new neft = GetPVarInt(playerid, "ownableneft");
			string_dialog[0] = EOS;
			static fmt1[64];
			static fmt2[64];

			new day, month, year;
			getdate(day, month, year);

			if(year < 10) format(fmt1, sizeof fmt1,"0%d", year);
			else format(fmt1, sizeof fmt1,"%d", year);

			if(month < 10) format(fmt2, sizeof fmt2,"0%d", month);
			else format(fmt2, sizeof fmt2,"%d", month);

			format
			(
				string_dialog, sizeof string_dialog,
				"{ffd700}- Параметры заказа:\n\n"\
				"{FFFFFF}Количество литров нефти: \t %d ед.\n"\
				"{FFFFFF}Стоимость одного литра нефти: \t 9400 руб\n"\
				"{FFFFFF}Общая стоимость заказа: \t %d руб\n"\
				"{FFFFFF}Дата оформления заказа: \t %s-%s-%d\n\n"\
				"{FFFFFF}Мы уведомили свободных сотрудников транспортных компаний о новом контракте.\n"\
				"{FFFFFF}Обратите внимание, что начисление денег за экспорт происходит после полного завершения заказа.\n"\
				"{FFFFFF}Премиум-заказ послужит дополнительным стимулом для дальнобойщиков.",
				GetNeftData(neft, N_FUELS),
				GetNeftData(neft, N_FUELS) * 282000,
				fmt1,
				fmt2,
				day
			);
			if(GetNeftData(neft, N_BALANCE) >= 500000)
			{
				GameText(playerid,"~w~Баланс нефтенасоса~n~~r~-500000 рублей", 4000, 2);
				new neftbalance = GetNeftData(neft, N_FUELS) * 282000 - 500000;
				SetNeftData(neft, N_BALANCE, GetNeftData(neft, N_BALANCE) + neftbalance), SetNeftData(neft, N_FUELS, 0);
			}
			else if(GetILPlayerInt(GetPlayerMoneyEx(playerid), 500000))
			{
				GivePlayerMoneyEx(playerid, -500000);
				new neftbalance = GetNeftData(neft, N_FUELS) * 282000;
				SetNeftData(neft, N_BALANCE, GetNeftData(neft, N_BALANCE) + neftbalance), SetNeftData(neft, N_FUELS, 0);
			}
			else return GameText(playerid,"~w~Недостаточно средств", 4000, 2);

			static query[240];
			format(query, sizeof query, "UPDATE neftenasos SET neftfuels=%d, balance=%d WHERE id=%d", GetNeftData(neft, N_FUELS), GetNeftData(neft, N_BALANCE), GetNeftData(neft, N_SQL_ID));
			mysql_query(mysql, query, false);

			CallLocalFunction("UpdateNeftLabel", "i", neft);

			return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, "{FFFFFF}Заказ оформлен", string_dialog, "", "Закрыть");
		}
		case DIALOG_NEFTENASOS4:
		{
			if(!response) return ShowMenuNeft(playerid);
			switch(listitem + 1){
				case 1: SetPVarInt(playerid, "neftulu", 1), Dialog(playerid, DIALOG_NEFTENASOS5, DIALOG_STYLE_MSGBOX,"{FFFFFF}Подземный резервуар","{FFFFFF}Второй резервуар будет расположен под землёй.\n{FFFFFF}Таким образом общая вместительность составит {ffa500}6700 литров.\n{FFFFFF}Стоимость: {ffa500}15.000.000 руб.","Купить", "Назад");
				case 2: SetPVarInt(playerid, "neftulu", 2), Dialog(playerid, DIALOG_NEFTENASOS5, DIALOG_STYLE_MSGBOX,"{FFFFFF}Модуль включения","{FFFFFF}Модуль, который будет вкрючать нефтенасос после пожара.\n{FFFFFF}Таким образом вам нужно будет меньше следить за нефтяным насосом.\n{FFFFFF}Стоимость: {ffa500}10.000.000 руб.","Купить", "Назад");
			}
		}
		case DIALOG_NEFTENASOS5:
		{
			if(!response) return ShowMenuNeft(playerid);
			new neft = GetPVarInt(playerid, "ownableneft");
			static query[240];
			if(GetPVarInt(playerid, "neftulu") == 1){
				if(GetNeftData(neft, N_IMPROVEMENTS) > 0) return SendClientMessage(playerid, 0x999999FF, "* У вас уже куплено данное улучшение.");
				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 15000000)) return SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег.");
				GivePlayerMoneyEx(playerid, -15000000), SetNeftData(neft, N_IMPROVEMENTS, 1), neftfuels[neft] = 6700;
				CallLocalFunction("UpdateNeftLabel", "i", neft);
			}
			if(GetPVarInt(playerid, "neftulu") == 2){
				if(GetNeftData(neft, N_IMPROVEMENTS) > 1 || GetNeftData(neft, N_IMPROVEMENTS) != 1) return SendClientMessage(playerid, 0x999999FF, "* У вас уже куплено данное улучшение или не куплено первое улучшение.");
				if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 10000000)) return SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег.");
				GivePlayerMoneyEx(playerid, -10000000), SetNeftData(neft, N_IMPROVEMENTS, 2);
			}
			format(query, sizeof query, "UPDATE neftenasos SET improvements=%d WHERE id=%d", GetNeftData(neft, N_IMPROVEMENTS), GetNeftData(neft, N_SQL_ID));
			mysql_query(mysql, query, false);
			DeletePVar(playerid, "neftulu");
		}
		case DIALOG_SELL_NEFTENASOS:
		{
			if(!response) return ShowMenuNeft(playerid);
			new neft = GetPVarInt(playerid, "ownableneft");
			if(!IsPlayerInRangeOfPoint(playerid, 6.0, GetNeftData(neft, N_POS_X), GetNeftData(neft, N_POS_Y), GetNeftData(neft, N_POS_Z)) && !IsPlayerInRangeOfPoint(strval(inputtext), 15.0, GetNeftData(neft, N_POS_X), GetNeftData(neft, N_POS_Y), GetNeftData(neft, N_POS_Z))) return SendClientMessage(playerid, 0xCECECEFF, "* Вы и покупатель должны находиться около нефтяного насоса");
			SetPVarInt(playerid, "SellIdNeft", strval(inputtext));
			Dialog(playerid, DIALOG_SELL_NEFTENASOS2, DIALOG_STYLE_INPUT,"{FFFFFF}Продать нефтяной насос игроку","{FFFFFF}Введите сумму за которую готовы продать игроку нефтяной насос:","Далее", "Закрыть");
		}
		case DIALOG_SELL_NEFTENASOS2:
		{
			if(!response) return 1;
			if(GetPlayerMoneyEx(GetPVarInt(playerid, "SellIdNeft")) < strval(inputtext))
				return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет такой суммы");
			new neft = GetPVarInt(playerid, "ownableneft");
			SendPlayerOffer(playerid, GetPVarInt(playerid, "SellIdNeft"), OFFER_TYPE_SELL_NEFTENASOS, neft, strval(inputtext));
		}
		case DIALOG_OWNABLE_BLACK_MARKET:
		{
			if(!response) return 1;
			
			new idx = GetPlayerListitemValue(playerid, listitem);
			static query[64],
			Cache: result;

			mysql_format(mysql, query, sizeof query, "SELECT * FROM black_market WHERE id='%d'", idx);
			result = mysql_query(mysql, query, true);

			if(cache_num_rows())
			{
				if(cache_get_field_content_int(0, "type") == 0) GiveCar(playerid, cache_get_field_content_int(0, "modelid"), 1, 1, -1, -1, 110.8994,322.3508,11.2202,251.4996, gettime()), SendClientMessage(playerid, -1, "* Вы забрали автомобиль");
				if(cache_get_field_content_int(0, "type") == 1) GiveSkin(playerid, cache_get_field_content_int(0, "modelid")), SendClientMessage(playerid, -1, "* Вы забрали скин");
			}
			mysql_format(mysql, query, sizeof query, "DELETE FROM black_market WHERE id=%d", idx);
			mysql_query(mysql, query, false);

			cache_delete(result);
		}
		case DIALOG_INACTIVE_MAIN:
		{
			if(!response) return 1;
			
			switch(listitem)
			{
			case 0:
			{
			static query[512], string[1024], count = 0;
			format(query, sizeof(query), "SELECT phone FROM PlayersMorallwens WHERE phone != 0 AND last_login < %d", gettime() - 864000);
			new Cache:result = mysql_query(mysql, query, true);
			
			if(cache_num_rows() > 0)
			{
				for(new i = 0; i < cache_num_rows(); i++)
				{
					new phone[16];
					cache_get_field_content(i, "phone", phone, sizeof(phone));
					
					if(count % 20 == 0 && count != 0) strcat(string, "\n");
					if(count % 20 != 0) strcat(string, " | ");
					strcat(string, phone);
					count++;
				}
			}
			cache_delete(result);
			
			if(count == 0) strcat(string, "Неактивных сим-карт не найдено");
			
			Dialog(playerid, DIALOG_INACTIVE_PHONES, DIALOG_STYLE_MSGBOX, "Неактивные сим-карты", string, "Закрыть", "");
		}
			case 1:
		{
			static query[512], string[1024], count = 0;
			format(query, sizeof(query), "SELECT i.number, i.region FROM PlayersMorallwens a JOIN items i ON a.id = i.owner_id WHERE i.number != '' AND a.last_login < %d", gettime() - 864000);
			new Cache:result = mysql_query(mysql, query, true);
			
			if(cache_num_rows() > 0)
			{
				for(new i = 0; i < cache_num_rows(); i++)
				{
					new number[16], region[16], temp[32];
					cache_get_field_content(i, "number", number, sizeof(number));
					cache_get_field_content(i, "region", region, sizeof(region));
					format(temp, sizeof(temp), "%s %s", number, region);
					
					if(count % 20 == 0 && count != 0) strcat(string, "\n");
					if(count % 20 != 0) strcat(string, " | ");
					strcat(string, temp);
					count++;
				}
			}
			cache_delete(result);
			
			if(count == 0) strcat(string, "Неактивных автомобильных номеров не найдено");
			
			Dialog(playerid, DIALOG_INACTIVE_NUMBERS, DIALOG_STYLE_MSGBOX, "Неактивные автомобильные номера", string, "Закрыть", "");
		}
			}
		}
		case DIALOG_SELL_INACTIVE_MAIN:
		{
			if(!response) return 1;
			
			switch(listitem)
			{
				case 0:
				{
					Dialog(playerid, DIALOG_SELL_INACTIVE_CONFIRM, DIALOG_STYLE_MSGBOX, "Подтверждение", "Вы уверены, что хотите конфисковать все неактивные сим-карты?", "Да", "Нет");
				}
				case 1:
				{
					Dialog(playerid, DIALOG_SELL_INACTIVE_CONFIRM_N, DIALOG_STYLE_MSGBOX, "Подтверждение", "Вы уверены, что хотите конфисковать все неактивные автомобильные номера?", "Да", "Нет");
				}
			}
		}
		case DIALOG_SELL_INACTIVE_CONFIRM:
		{
			if(!response) return 1;
			
			static query[256];
			format(query, sizeof(query), "UPDATE PlayersMorallwens SET phone = 0 WHERE phone != 0 AND last_login < %d", gettime() - 864000);
			mysql_query(mysql, query, false);
			
			static string[128];
			format(string, sizeof(string), "[Информация] {FFFFFF}Из-за неоплаты налогов были конфискованы сим-карты неактивных игроков.");
			SendClientMessageToAll(0xFFFFFFFF, string);
		}
		case DIALOG_SELL_INACTIVE_CONFIRM_N:
		{
			if(!response) return 1;
			
			static query[256];
			format(query, sizeof(query), "DELETE i FROM items i JOIN PlayersMorallwens a ON i.owner_id = a.id WHERE i.number != '' AND a.last_login < %d", gettime() - 864000);
			mysql_query(mysql, query, false);
			
			static string[128];
			format(string, sizeof(string), "[Информация] {FFFFFF}Из-за неоплаты налогов были конфискованы автомобильные номера неактивных игроков.");
			SendClientMessageToAll(0xFFFFFFFF, string);
		}
		case DIALOG_EGGSHOP:
			{
				if(response)
				{
				    switch(listitem)
					{
						case 0:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 500;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 594);
						GameText(playerid, "~r~~h~-500 ЯИЦ", 3000, 2);
						}
						case 1:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 50;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveIteam(playerid, 259, 1, 1, 0);
						GameText(playerid, "~r~~h~-50 ЯИЦ", 3000, 2);
						}
						case 2:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 25;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveIteam(playerid, 278, 1, 1, 0);
						GameText(playerid, "~r~~h~-25 ЯИЦ", 3000, 2);
						}
						case 3:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 1000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15563);
						GameText(playerid, "~r~~h~-1.000 ЯИЦ", 3000, 2);
						}
						case 4:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 1000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15564);
						GameText(playerid, "~r~~h~-1.000 ЯИЦ", 3000, 2);
						}
						case 5:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15565);
						GameText(playerid, "~r~~h~-750 ЯИЦ", 3000, 2);
						}
						case 6:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 116);
						GameText(playerid, "~r~~h~-750 ЯИЦ", 3000, 2);
						}
						case 7:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15455);
						GameText(playerid, "~r~~h~-750 ЯИЦ", 3000, 2);
						}
						case 8:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 1750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15528);
						GameText(playerid, "~r~~h~-1.750", 3000, 2);//БУСТЕР
						}
						case 9:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 4500;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15176, 1, 1, -1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-4.500", 3000, 2);
						}
						case 10:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 5000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15297, 1, 1, -1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-5.000", 3000, 2);
						}
						case 11:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 5000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15190, 1, 1, -1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-5.000", 3000, 2);
						}
						case 12:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 5000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15229, 1, 1, -1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-5.000", 3000, 2);
						}
						case 13:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 15000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15294, 1, 1, -1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-15.000", 3000, 2);
						}
						case 14:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 20000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15678, 1, 1, -1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-20.000", 3000, 2);
						}
						case 15:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 30000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15177, 1, 1, -1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-30.000", 3000, 2);
				   	}
   				}
			}
		}
		case DIALOG_LOTTERY:
		{
			new businessid = GetPlayerInBiz(playerid);
			if(businessid != -1)
			{
				if(response)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
					{
						new price;
						new take_prods;

						switch(listitem + 1)
						{
							case 1:
							{
								price = 5000000;
								take_prods = 2;

								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
								{
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessProfit(playerid, businessid, price * 20 / 100, take_prods);
									}
									GivePlayerMoneyEx(playerid, -price, "Покупка лотерейного билета");

									GiveIteam(playerid, 257, 1, 1, 0);

									SendClientMessage(playerid, 0x66CC00FF, "* Вы купили лотерейный билет");
									SendClientMessage(playerid, 0x66CC00FF, "* Использовать его можно через инвентарь или /lottery");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* Лотерейный билет стоит 5.000.000 рублей");
							}
							default:
								return 1;
						}
					}
				}
			}
		}
	}
	return 1;
}