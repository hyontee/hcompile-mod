#if defined _car_donate_included
    #endinput
#endif
#define _car_donate_included

#include <a_samp>
#include <streamer>

#define DONATE_PACK_OBJ_ID      16255      
#define PASSAGE_LOCATION        "Торговом Центре 'Пассаж' (г. Арзамас)"
#define ANTI_FLOOD_TIME         2          

static Float:DonateCoords[3][3][4] = 
{
    //Машина, Скин, Объект
    // Пассаж 
    {{167.7768, 771.0508, 11.8573, 156.0649}, {162.6818, 767.0912, 11.9442, 154.0266}, {167.7300, 771.5360, 12.8028, 163.0}},
    // МГУ
    {{100.0, 100.0, 10.0, 0.0}, {102.0, 102.0, 10.0, 0.0}, {100.0, 100.0, 11.0, 0.0}},
    // Контейнеры
    {{200.0, 200.0, 5.0, 0.0}, {202.0, 202.0, 5.0, 0.0}, {200.0, 200.0, 6.0, 0.0}}
};

new 
    Pack_Name[32] = "Лимитированный набор",
    Pack_Location = 0,
    Pack_CarModel,      
    Pack_SkinID,        
    Pack_Price,         
    Pack_Currency,      
    Pack_Limit,         
    bool:Pack_Active = false,
    donate_car_id = INVALID_VEHICLE_ID,
    donate_actor_id = -1,
    donate_object_id = -1,
    Text3D:donate_label = Text3D:INVALID_3DTEXT_ID,
    p_buy_tick[MAX_PLAYERS],
    Pack_TimeStart,    
    Pack_TimeEnd,       
    Pack_TimerID = -1;

forward LoadDonatePackFromDB();
forward DonateCar_limit(playerid);
forward DCrs_OnPlayerBuyLimit(playerid);
forward DonatePackTimer();

public LoadDonatePackFromDB()
{
    new rows, fields;
    cache_get_data(rows, fields);
    
    if(rows > 0)
    {
        Pack_Active = bool:cache_get_field_content_int(0, "active");
        
        if(Pack_Active)
        {
            Pack_SkinID = cache_get_field_content_int(0, "skin_id");
            Pack_CarModel = cache_get_field_content_int(0, "car_model");
            Pack_Price = cache_get_field_content_int(0, "price");
            Pack_Currency = cache_get_field_content_int(0, "currency");
            Pack_Limit = cache_get_field_content_int(0, "total_count");
            
            if(Pack_Limit > 0) StartEntities();
            else StopDonatePack("Лимит исчерпан при загрузке");
        }
    }
    printf("[MySQL] Система лимитированных наборов загружена. Строк: %d", rows);
    return 1;
}

stock StartEntities()
{
    if(donate_car_id != INVALID_VEHICLE_ID) { DestroyVehicle(donate_car_id); donate_car_id = INVALID_VEHICLE_ID; }
    if(donate_actor_id != -1) { DestroyDynamicActor(donate_actor_id); donate_actor_id = -1; }
    if(donate_object_id != -1) { DestroyDynamicObject(donate_object_id); donate_object_id = -1; }
    if(donate_label != Text3D:INVALID_3DTEXT_ID) { DestroyDynamic3DTextLabel(donate_label); donate_label = Text3D:INVALID_3DTEXT_ID; }
    
    donate_car_id = CreateVehicle(Pack_CarModel, DonateCoords[Pack_Location][0][0], DonateCoords[Pack_Location][0][1], DonateCoords[Pack_Location][0][2], DonateCoords[Pack_Location][0][3], 1, 1, 0, -1, VEHICLE_ACTION_TYPE_DONATE_CAR);
    SetVehicleParamsEx(donate_car_id, 0, 1, 0, 1, 0, 0, 0); 
    
    donate_actor_id = CreateDynamicActor(Pack_SkinID, DonateCoords[Pack_Location][1][0], DonateCoords[Pack_Location][1][1], DonateCoords[Pack_Location][1][2], DonateCoords[Pack_Location][1][3]);
    donate_object_id = CreateDynamicObject(DONATE_PACK_OBJ_ID, DonateCoords[Pack_Location][2][0], DonateCoords[Pack_Location][2][1], DonateCoords[Pack_Location][2][2], 0.0, 0.0, DonateCoords[Pack_Location][2][3]);

    static str[128];
    format(str, sizeof(str), "{FFCC00}%s\n{FFFFFF}Нажмите {FFCC00}ALT{FFFFFF}", Pack_Name);
    donate_label = CreateDynamic3DTextLabel(str, -1, DonateCoords[Pack_Location][1][0], DonateCoords[Pack_Location][1][1], DonateCoords[Pack_Location][1][2] + 1.1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
    return 1;
}

stock Donate_OnPlayerKeyStateChange(playerid, newkeys)
{
    if(IsPlayerInRangeOfPoint(playerid, 4.0, 163.3604, 765.2334, 11.9484))
    {
        if(newkeys & KEY_WALK) 
        {
            if(Pack_TimeStart > 0)
            {
                static str[64];
                format(str, sizeof(str), "~r~НАЧАЛО ЧЕРЕЗ: ~w~%d SEC", Pack_TimeStart);
                GameText(playerid, str, 2000, 3);
                return 1;
            }

            if(!Pack_Active) return 0;
            
            DonateCar_limit(playerid);
            return 1;
        }
    }
    return 0;
}

public DonateCar_limit(playerid)
{
    if(!Pack_Active || Pack_Limit <= 0) 
    {
        return SendClientMessage(playerid, 0xCECECEFF, "К сожалению, лимитированный набор сейчас недоступен.");
    }
    
    static msg[850], cur_name[32];
    if(Pack_Currency == 0) format(cur_name, sizeof(cur_name), "Доната");
    else format(cur_name, sizeof(cur_name), "Денег");
    
    format(msg, sizeof(msg), 
        "{FFFFFF}Добро пожаловать в отдел эксклюзивных товаров {FFCC00}Пассажа{FFFFFF}!\n\n\
        {FFFFFF}Вам предлагается уникальный комплект:\n\
        {777777}• {FFFFFF}Транспорт: {FFCC00}ID %d\n\
        {777777}• {FFFFFF}Скин: {FFCC00}ID %d\n\n\
        {FFFFFF}Стоимость предложения: {66CC66}%d %s\n\
        {FFFFFF}Доступно для покупки: {FF8800}%d шт.\n\
        {FFFFFF}Акция завершится через: {FFCC00}%d сек.\n\n\
        {FFFFFF}Вы действительно хотите совершить покупку?\n\
        {777777}Транспорт будет зачислен в ваше владение сразу.", 
        Pack_CarModel, Pack_SkinID, Pack_Price, cur_name, Pack_Limit, Pack_TimeEnd);
        
    Dialog(playerid, DIALOG_DONATE_BUY_CONFIRM, DIALOG_STYLE_MSGBOX, "{FFCC00}Оформление заказа", msg, "Купить", "Отмена");
    return 1;
}

public DCrs_OnPlayerBuyLimit(playerid)
{
    if(!Pack_Active || Pack_Limit <= 0) return 1;
    if(gettime() - p_buy_tick[playerid] < ANTI_FLOOD_TIME) return SendClientMessage(playerid, 0xFF0000FF, "[!] Пожалуйста, не нажимайте так часто!");
    
    p_buy_tick[playerid] = gettime();
    
    if(Pack_Currency == 0) 
    {
        if(GetPlayerCurrentDonate(playerid) < Pack_Price) return SendClientMessage(playerid, -1, "{FF0000}[Ошибка] {FFFFFF}У вас недостаточно Доната!");
        GivePlayerDonate(playerid, -Pack_Price, "Покупка Лимит.Пака");
    } 
    else 
    {
        if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), Pack_Price)) return SendClientMessage(playerid, -1, "{FF0000}[Ошибка] {FFFFFF}У вас недостаточно Денег!");
        GivePlayerMoneyEx(playerid, -Pack_Price, "Покупка Лимит.Пака");
    }

    GivePlayerMyPrizes(playerid, "Транспорт из набора", 3, Pack_CarModel, 0, 1, -1);
    GivePlayerMyPrizes(playerid, "Скин из набора", 4, Pack_SkinID, 0, 1, 0);
    SendClientMessage(playerid, 0x66FF66FF, "Поздравляем! Набор куплен (см. /mm -> Мои Награды).");
    GameText(playerid, "~g~~h~УСПЕШНО", 4000, 1);
    
    Pack_Limit--;
    if(Pack_Limit <= 0) StopDonatePack("Товар полностью распродан");
    else 
    {
        new query[128];
        mysql_format(mysql, query, sizeof(query), "UPDATE donate_packs SET total_count = %d WHERE id = 1", Pack_Limit);
        mysql_tquery(mysql, query);
    }
    return 1;
}

CMD:car_menu(playerid)
{
    if(GetPlayerAdminEx(playerid) < 11 && !SuccessfulAura(playerid)) return 1;
    
    static fmt[1200], cur[32], loc_name[32];
    if(Pack_Currency == 0) cur = "Донат"; else cur = "Деньги";
    
    if(Pack_Location == 0) loc_name = "Пассаж";
    else if(Pack_Location == 1) loc_name = "МГУ";
    else loc_name = "Контейнеры";

    format(fmt, sizeof(fmt), 
        "{FFFFFF}0. Название: {FFCC00}%s\n\
        {777777}1. {FFFFFF}Скин: {FFCC00}%d\n\
        {777777}2. {FFFFFF}Транспорт: {FFCC00}%d\n\
        {777777}3. {FFFFFF}Цена: {FFCC00}%d (%s)\n\
        {777777}4. {FFFFFF}Лимит: {FFCC00}%d шт.\n\
        {777777}5. {FFFFFF}Локация: {FFCC00}%s\n\
        {777777}6. {FFFFFF}Старт через: {FFCC00}%d сек.\n\
        {777777}7. {FFFFFF}Конец через: {FFCC00}%d сек.\n\n\
        {00FF00}>> АКТИВИРОВАТЬ АКЦИЮ\n\
        {FF0000}>> ДЕАКТИВИРОВАТЬ АКЦИЮ", 
        Pack_Name, Pack_SkinID, Pack_CarModel, Pack_Price, cur, Pack_Limit, loc_name, Pack_TimeStart, Pack_TimeEnd);
    Dialog(playerid, DIALOG_DONATE_CAR_MENU, DIALOG_STYLE_LIST, "{FFCC00}Управление", fmt, "Выбрать", "Закрыть");
    return 1;
}
stock Donate_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_DONATE_BUY_CONFIRM)
    {
        if(response) DCrs_OnPlayerBuyLimit(playerid);
        return 1;
    }
    
    if(!response) return 0;
    
    switch(dialogid)
    {
        case DIALOG_DONATE_CAR_MENU:
        {
            switch(listitem)
            {
                case 0: Dialog(playerid, DIALOG_DONATE_NAME, DIALOG_STYLE_INPUT, "Название набора", "Введите название:", "Принять", "Назад");
                case 1: Dialog(playerid, DIALOG_DONATE_SKIN, DIALOG_STYLE_INPUT, "Установка скина", "Введите ID скина:", "Принять", "Назад");
                case 2: Dialog(playerid, DIALOG_DONATE_CAR, DIALOG_STYLE_INPUT, "Установка авто", "Введите ID модели машины:", "Принять", "Назад");
                case 3: Dialog(playerid, DIALOG_DONATE_PRICE, DIALOG_STYLE_INPUT, "Цена и Валюта", "Введите: [Цена] [0 - Донат / 1 - Деньги]:", "Принять", "Назад");
                case 4: Dialog(playerid, DIALOG_DONATE_LIMIT, DIALOG_STYLE_INPUT, "Количество", "Введите количество наборов:", "Принять", "Назад");
                case 5:
                {
                    new str_loc[500];
                    format(str_loc, sizeof(str_loc), 
                        "Локация\tСтатус\n\
                        {FFFFFF}Пассаж\t%s\n\
                        {FFFFFF}МГУ\t%s\n\
                        {FFFFFF}Контейнеры\t%s\n\n\
                        {00FF00}>> ПРОДОЛЖИТЬ",
                        (Pack_Location == 0) ? ("{00FF00}?") : ("{FF0000}?"),
                        (Pack_Location == 1) ? ("{00FF00}?") : ("{FF0000}?"),
                        (Pack_Location == 2) ? ("{00FF00}?") : ("{FF0000}?")
                    );
                    Dialog(playerid, DIALOG_DONATE_LOC_SELECT, DIALOG_STYLE_TABLIST_HEADERS, "Где разместить набор?", str_loc, "Выбрать", "Назад");
                }
                case 6: Dialog(playerid, DIALOG_DONATE_TIME_START, DIALOG_STYLE_INPUT, "Время до начала", "Введите время в секундах:", "Принять", "Назад");
                case 7: Dialog(playerid, DIALOG_DONATE_TIME_END, DIALOG_STYLE_INPUT, "Время до конца", "Введите время в секундах:", "Принять", "Назад");
                case 8: StartDonatePackAdmin(playerid);
                case 9: StopDonatePack("Отключено администратором"); 
            }
            return 1;
        }

        case DIALOG_DONATE_LOC_SELECT:
        {
            if(listitem == 3) return callcmd::car_menu(playerid);
            Pack_Location = listitem;
            return Donate_OnDialogResponse(playerid, DIALOG_DONATE_CAR_MENU, 1, 5, ""); 
        }
        case DIALOG_DONATE_NAME: { format(Pack_Name, 32, "%s", inputtext); callcmd::car_menu(playerid); }
        case DIALOG_DONATE_SKIN: { Pack_SkinID = strval(inputtext); callcmd::car_menu(playerid); }
        case DIALOG_DONATE_CAR:  { Pack_CarModel = strval(inputtext); callcmd::car_menu(playerid); }
        case DIALOG_DONATE_PRICE: { sscanf(inputtext, "dd", Pack_Price, Pack_Currency); callcmd::car_menu(playerid); }
        case DIALOG_DONATE_LIMIT: { Pack_Limit = strval(inputtext); callcmd::car_menu(playerid); }
        case DIALOG_DONATE_TIME_START: { Pack_TimeStart = strval(inputtext); callcmd::car_menu(playerid); }
        case DIALOG_DONATE_TIME_END: { Pack_TimeEnd = strval(inputtext); callcmd::car_menu(playerid); }
    }
    return 1;
}
stock StartDonatePackAdmin(adminid)
{
    if(!(400 <= Pack_CarModel <= 614) && 
       (!(699 <= Pack_CarModel <= 699) && 
       (!(793 <= Pack_CarModel <= 799) && 
       (!(15065 <= Pack_CarModel <= 15299) && 
       (!(15600 <= Pack_CarModel <= 15699) && 
       (!(907 <= Pack_CarModel <= 909) && 
       (!(965 <= Pack_CarModel <= 965) && 
       (!(999 <= Pack_CarModel <= 999) && 
       (!(1326 <= Pack_CarModel <= 1326) && 
       (!(17400 <= Pack_CarModel <= 17409) && 
       (!(17410 <= Pack_CarModel <= 17447)))))))))))) 
    {
        return SendClientMessage(adminid, 0xCECECEFF, "Вы указали неверный id авто. Доступные: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15699, 17400-17409, 17410-17447");
    }
    Pack_Active = true;
    
    StartEntities(); 
    
    if(Pack_TimerID != -1) KillTimer(Pack_TimerID);
    Pack_TimerID = SetTimer("DonatePackTimer", 1000, true);
    
    new query[512];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO donate_packs (id, skin_id, car_model, price, currency, total_count, active) VALUES (1, %d, %d, %d, %d, %d, 1) ON DUPLICATE KEY UPDATE active=1, skin_id=%d, car_model=%d, price=%d, currency=%d, total_count=%d", Pack_SkinID, Pack_CarModel, Pack_Price, Pack_Currency, Pack_Limit, Pack_SkinID, Pack_CarModel, Pack_Price, Pack_Currency, Pack_Limit);
    mysql_tquery(mysql, query);
    
    new str[144];
    format(str, sizeof(str), "{FFCC00}[DONATE] {FFFFFF}В "PASSAGE_LOCATION" активирован новый лимитированный набор!");
    SendClientMessageToAll(-1, str);
    return 1;
}

stock StopDonatePack(const reason[])
{
    if(!Pack_Active) return 0;
    
    if(donate_car_id != INVALID_VEHICLE_ID) { DestroyVehicle(donate_car_id); donate_car_id = INVALID_VEHICLE_ID; }
    if(donate_actor_id != -1) { DestroyDynamicActor(donate_actor_id); donate_actor_id = -1; }
    if(donate_object_id != -1) { DestroyDynamicObject(donate_object_id); donate_object_id = -1; }
    if(donate_label != Text3D:INVALID_3DTEXT_ID) { DestroyDynamic3DTextLabel(donate_label); donate_label = Text3D:INVALID_3DTEXT_ID; }
    
    Pack_Active = false;
    if(Pack_TimerID != -1) { KillTimer(Pack_TimerID); Pack_TimerID = -1; }
    
    mysql_tquery(mysql, "UPDATE donate_packs SET active = 0 WHERE id = 1");
    printf("[DONATE] Остановлено. Причина: %s", reason);
    return 1;
}

public DonatePackTimer()
{
    if(Pack_TimeStart > 0)
    {
        Pack_TimeStart--;
        if(Pack_TimeStart == 0)
        {
            SendClientMessageToAll(-1, "{FFCC00}[DONATE] {FFFFFF}Лимитированный набор в "PASSAGE_LOCATION" теперь доступен для покупки!");
        }
    }
    else if(Pack_Active && Pack_TimeEnd > 0)
    {
        Pack_TimeEnd--;
        if(Pack_TimeEnd == 0)
        {
            StopDonatePack("Время акции истекло");
        }
    }
}