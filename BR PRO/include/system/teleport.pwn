//#include <a_samp>

#define COLOR_GREEN 0x00FF00AA
#define COLOR_RED 0xFF0000AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFFF

// Константы для ID диалогов (начиная с 20000)
#define DIALOG_TELEPORT_MAIN 20000
#define DIALOG_TELEPORT_PLACES 20001
#define DIALOG_TELEPORT_NEWBIE_JOBS 20002
#define DIALOG_TELEPORT_MAIN_JOBS 20003
#define DIALOG_TELEPORT_STATE_ORG 20004
#define DIALOG_TELEPORT_GANGS 20005
#define DIALOG_TELEPORT_TRANSPORT 20006
#define DIALOG_TELEPORT_ENTERTAINMENT 20007
#define DIALOG_TELEPORT_BANKS 20008
#define DIALOG_TELEPORT_AUTOSALONS 20009
#define DIALOG_TELEPORT_CITIES 20010
#define DIALOG_TELEPORT_STATIONS 20011

// Ваши глобальные переменные (должны быть определены где-то в коде)

CMD:tp(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1 && GetPlayerYouTubeEx(playerid) < 1)
        return ShowNotification(playerid, 2, "У вас нет доступа к использованию данной команды", 3, "", "");
    
    ShowPlayerDialog(playerid, DIALOG_TELEPORT_MAIN, DIALOG_STYLE_LIST,
        "{FFD700}Админ-телепорт{ffffff} | Выберите категорию",
        "1. Важные места\n\
        2. Работы для новичков\n\
        3. Основные работы\n\
        4. Государственные организации\n\
        5. Базы преступных группировок\n\
        6. Транспортные компании\n\
        7. Развлечения\n\
        8. Банки\n\
        9. Автосалоны\n\
        10. Города и населенные пункты\n\
        11. Вокзалы",
        "Выбрать", "Отмена");
    
    printf("[TP] Player %d opened teleport menu", playerid);
    return 1;
}

// ============= ОБРАБОТЧИК ДИАЛОГОВ =============
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    printf("[DIALOG] Player %d: dialogid=%d, response=%d, listitem=%d", 
        playerid, dialogid, response, listitem);
    
    // Обработка диалогов телепорта (от 20000 до 20099)
    if(20000 <= dialogid <= 20099)
    {
        switch(dialogid)
        {
            case DIALOG_TELEPORT_MAIN: // Основное меню телепорта
            {
                if(!response) 
                {
                    SendClientMessage(playerid, COLOR_WHITE, "Меню телепорта закрыто.");
                    return 1;
                }
                
                switch(listitem)
                {
                    case 0: // Важные места
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_PLACES, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| Важные места",
                            "1. Правительство\n\
                            2. Автошкола\n\
                            3. Военкомат\n\
                            4. Городская больница г.Арзамас",
                            "Телепорт", "Назад");
                    }
                    case 1: // Работы для новичков
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_NEWBIE_JOBS, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| Работы для новичков",
                            "1. Шахта\n\
                            2. Грузчик\n\
                            3. Завод",
                            "Телепорт", "Назад");
                    }
                    case 2: // Основные работы
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_MAIN_JOBS, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| По работе",
                            "1. База механиков\n\
                            2. Курьерская служба доставки\n\
                            3. Аренда автобуса(Южный)\n\
                            4. Аренда автобуса(Арзамас)\n\
                            5. Аренда автобуса(Батырево)",
                            "Телепорт", "Назад");
                    }
                    case 3: // Государственные организации
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_STATE_ORG, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| Государственные организации",
                            "1. Правительство области\n\
                            2. Отдел полиции №1 (ГИБДД)\n\
                            3. Отдел полиции №2 (УМВД)\n\
                            4. Отдел ФСБ\n\
                            5. Городская больница г. Арзамас\n\
                            6. СМИ\n\
                            7. Воинская часть",
                            "Телепорт", "Назад");
                    }
                    case 4: // Базы преступных группировок
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_GANGS, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| Базы преступных группировок",
                            "1. Арзамасская ОПГ\n\
                            2. Батыревская ОПГ\n\
                            3. Лыткаринская ОПГ",
                            "Телепорт", "Назад");
                    }
                    case 5: // Транспортные компании
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_TRANSPORT, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff} | Транспортные компании",
                            "1. Офис транспортной компании пгт. Батырево\n\
                            2. Склад п. Бусаево\n\
                            3. Склад г. Эдово\n\
                            4. Завод г. Эдово\n\
                            5. Шахта пгт. Батырево\n\
                            6. Загрузка нефти 'Лукойл' пгт. Батырево",
                            "Телепорт", "Назад");
                    }
                    case 6: // Развлечения
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_ENTERTAINMENT, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff} | Развлечения",
                            "1. Казино\n\
                            2. Битва за контейнеры\n\
                            3. Компьютерный клуб",
                            "Телепорт", "Назад");
                    }
                    case 7: // Банки
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_BANKS, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff} | Банки",
                            "1. Центральный банк Арзамаса\n\
                            2. Центральный банк Южный\n\
                            3. Центральный банк Батырево",
                            "Телепорт", "Назад");
                    }
                    case 8: // Автосалоны
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_AUTOSALONS, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| Автосалоны",
                            "1. Автосалон низкого класса\n\
                            2. Автосалон среднего класса\n\
                            3. Автосалон высокого класса\n\
                            4. Салон грузовых автомобилей\n\
                            5. Мотосалон 'Harley Davidson'\n\
                            6. Авторынок поддержанных автомобилей",
                            "Телепорт", "Назад");
                    }
                    case 9: // Города и населенные пункты
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_CITIES, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| Города и населенные пункты",
                            "1. г. Южный\n\
                            2. г. Арзамас\n\
                            3. д. Рублевка\n\
                            4. п. Егоровка\n\
                            5. пгт. Батырево\n\
                            6. г. Лыткарино\n\
                            7. г. Эдово\n\
                            8. п. Бусаево\n\
                            9. п. Роговичи\n\
                            10. д. Корякино",
                            "Телепорт", "Назад");
                    }
                    case 10: // Вокзалы
                    {
                        ShowPlayerDialog(playerid, DIALOG_TELEPORT_STATIONS, DIALOG_STYLE_LIST,
                            "{FFD700}Админ-телепорт{ffffff}| Вокзалы",
                            "1. Вокзал г. Арзамас\n\
                            2. Вокзал г. Южный\n\
                            3. Вокзал пгт. Батырево",
                            "Телепорт", "Назад");
                    }
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_PLACES: // Важные места
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 4)
                {
                    SetPlayerPosEx(playerid, 
                        gps_public_places[listitem][G_POS_X],
                        gps_public_places[listitem][G_POS_Y],
                        gps_public_places[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к важному месту №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_NEWBIE_JOBS: // Работы для новичков
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 3)
                {
                    SetPlayerPosEx(playerid, 
                        gps_transport[listitem][G_POS_X],
                        gps_transport[listitem][G_POS_Y],
                        gps_transport[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к работе для новичков №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_MAIN_JOBS: // Основные работы
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 5)
                {
                    SetPlayerPosEx(playerid, 
                        gps_jobs[listitem][G_POS_X],
                        gps_jobs[listitem][G_POS_Y],
                        gps_jobs[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к работе №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_STATE_ORG: // Государственные организации
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 7)
                {
                    SetPlayerPosEx(playerid, 
                        gps_state_organizations[listitem][G_POS_X],
                        gps_state_organizations[listitem][G_POS_Y],
                        gps_state_organizations[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к гос. организации №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_GANGS: // Базы преступных группировок
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 3)
                {
                    SetPlayerPosEx(playerid, 
                        gps_gangs[listitem][G_POS_X],
                        gps_gangs[listitem][G_POS_Y],
                        gps_gangs[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к базе группировки №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_TRANSPORT: // Транспортные компании
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 6)
                {
                    SetPlayerPosEx(playerid, 
                        gps_tk[listitem][G_POS_X],
                        gps_tk[listitem][G_POS_Y],
                        gps_tk[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к транспортной компании №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_ENTERTAINMENT: // Развлечения
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 3)
                {
                    SetPlayerPosEx(playerid, 
                        gps_entertainment[listitem][G_POS_X],
                        gps_entertainment[listitem][G_POS_Y],
                        gps_entertainment[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к развлечению №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_BANKS: // Банки
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 3)
                {
                    SetPlayerPosEx(playerid, 
                        gps_banks[listitem][G_POS_X],
                        gps_banks[listitem][G_POS_Y],
                        gps_banks[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к банку №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_AUTOSALONS: // Автосалоны
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 6)
                {
                    SetPlayerPosEx(playerid, 
                        gps_autosalons[listitem][G_POS_X],
                        gps_autosalons[listitem][G_POS_Y],
                        gps_autosalons[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к автосалону №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_CITIES: // Города и населенные пункты
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 10)
                {
                    SetPlayerPosEx(playerid, 
                        gps_cities[listitem][G_POS_X],
                        gps_cities[listitem][G_POS_Y],
                        gps_cities[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к городу №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
            
            case DIALOG_TELEPORT_STATIONS: // Вокзалы
            {
                if(!response) return callcmd::tp(playerid, "");
                
                if(0 <= listitem && listitem < 3)
                {
                    SetPlayerPosEx(playerid, 
                        gps_vokzals[listitem][G_POS_X],
                        gps_vokzals[listitem][G_POS_Y],
                        gps_vokzals[listitem][G_POS_Z], 0, 0);
                        
                    new msg[128];
                    format(msg, sizeof(msg), "Вы телепортированы к вокзалу №%d", listitem+1);
                    SendClientMessage(playerid, COLOR_GREEN, msg);
                }
                return 1;
            }
        }
    }
    
    // Если у вас есть другие обработчики диалогов, добавьте их здесь
    // или передайте дальше через hook
    
    #if defined tele_OnDialogResponse
    return tele_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse tele_OnDialogResponse
#if defined tele_OnDialogResponse
forward tele_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// Тестовая команда для проверки
CMD:testtele(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "Тест системы телепорта: используйте /tp");
    printf("[TEST] Teleport system test for player %d", playerid);
    return 1;
}