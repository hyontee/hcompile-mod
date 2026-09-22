#if defined _PWNKOV_VEHICLE_EXCHANGE
    #endinput
#endif
#define _PWNKOV_VEHICLE_EXCHANGE

#define EXCHANGE_MAX_LOTS 20
#define EXCHANGE_PICKUP_X 1967.06
#define EXCHANGE_PICKUP_Y -559.00
#define EXCHANGE_PICKUP_Z 12.01
#define EXCHANGE_PICKUP_A 229.38

#define DLG_EXCHANGE_MAIN 61001
#define DLG_EXCHANGE_SELL_LIST 61002
#define DLG_EXCHANGE_PRICE 61003
#define DLG_EXCHANGE_BUY_ID 61004
#define DLG_EXCHANGE_CONFIRM 61005

new exchange_pickup;
new Text3D:exchange_label = Text3D:INVALID_3DTEXT_ID;
new exchange_selected_vehicle[MAX_PLAYERS];
new exchange_buy_lot[MAX_PLAYERS];
new exchange_lot_count;

enum E_EXCHANGE_LOT { ex_id, ex_seller, ex_vehicle_sql, ex_model, ex_price, ex_name[32], ex_lot[9] };
new ExchangeLot[EXCHANGE_MAX_LOTS][E_EXCHANGE_LOT];

// ============================================================
// ИНИЦИАЛИЗАЦИЯ
// ============================================================

stock Exchange_Init()
{
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `vehicle_exchange` (`id` INT AUTO_INCREMENT PRIMARY KEY,`seller_id` INT NOT NULL,`vehicle_id` INT NOT NULL,`model` INT NOT NULL,`price` INT NOT NULL,`model_name` VARCHAR(32) NOT NULL,`lot_id` VARCHAR(8) NOT NULL UNIQUE,`active` TINYINT NOT NULL DEFAULT 1,`created_at` INT NOT NULL)");
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `exchange_history` (`id` INT AUTO_INCREMENT PRIMARY KEY,`lot_id` VARCHAR(8) NOT NULL,`seller_id` INT NOT NULL,`buyer_id` INT NOT NULL,`vehicle_id` INT NOT NULL,`model` INT NOT NULL,`model_name` VARCHAR(32) NOT NULL,`price` INT NOT NULL,`sold_at` INT NOT NULL)");
    
    exchange_pickup = CreatePickup(1239, 23, EXCHANGE_PICKUP_X, EXCHANGE_PICKUP_Y, EXCHANGE_PICKUP_Z, -1);
    
    if(exchange_label != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(exchange_label);
    exchange_label = Create3DTextLabel("{00FF00}Биржа транспорта{FFFFFF} | Наступите для взаимодействия", -1, EXCHANGE_PICKUP_X, EXCHANGE_PICKUP_Y, EXCHANGE_PICKUP_Z + 0.8, 20.0, 0, 0);
    
    mysql_tquery(mysql, "SELECT id,seller_id,vehicle_id,model,price,model_name,lot_id FROM vehicle_exchange WHERE active=1 ORDER BY id ASC LIMIT 20", "Exchange_LoadLots", "");
    return 1;
}

// ============================================================
// ЗАГРУЗКА ЛОТОВ
// ============================================================

forward Exchange_LoadLots();
public Exchange_LoadLots()
{
    exchange_lot_count = 0;

    new rows;
    new model_name[32];
    new lot_id[9];

    rows = cache_num_rows();

    for(new i = 0; i < rows && i < EXCHANGE_MAX_LOTS; i++)
    {
        ExchangeLot[i][ex_id] = cache_get_field_content_int(i, "id");
        ExchangeLot[i][ex_seller] = cache_get_field_content_int(i, "seller_id");
        ExchangeLot[i][ex_vehicle_sql] = cache_get_field_content_int(i, "vehicle_id");
        ExchangeLot[i][ex_model] = cache_get_field_content_int(i, "model");
        ExchangeLot[i][ex_price] = cache_get_field_content_int(i, "price");

        cache_get_field_content(i, "model_name", model_name, sizeof(model_name));
        cache_get_field_content(i, "lot_id", lot_id, sizeof(lot_id));

        format(ExchangeLot[i][ex_name], 32, "%s", model_name);
        format(ExchangeLot[i][ex_lot], 9, "%s", lot_id);

        exchange_lot_count++;
    }

    Exchange_UpdateLabel();
    return 1;
}

// ============================================================
// ОБНОВЛЕНИЕ 3D-ТЕКСТА
// ============================================================

stock Exchange_UpdateLabel()
{
    new text[1440];
    new line[80];
    new vehicle_name[32];
    new vehicle_lot[9];
    new text_len;

    text_len = format(
        text,
        sizeof(text),
        "{00FF00}Биржа транспорта{FFFFFF} | Наступите для взаимодействия\n"
    );

    if(exchange_lot_count == 0)
    {
        format(
            text[text_len],
            sizeof(text) - text_len,
            "{AAAAAA}Сейчас нет активных лотов"
        );
    }
    else
    {
        for(new i = 0; i < exchange_lot_count; i++)
        {
            format(
                vehicle_name,
                sizeof(vehicle_name),
                "%s",
                ExchangeLot[i][ex_name]
            );

            format(
                vehicle_lot,
                sizeof(vehicle_lot),
                "%s",
                ExchangeLot[i][ex_lot]
            );

            format(
                line,
                sizeof(line),
                "{FFCC00}%s {FFFFFF}%d {FFFF00}%s\n",
                vehicle_name,
                ExchangeLot[i][ex_price],
                vehicle_lot
            );

            strcat(text, line, sizeof(text));

            text_len = strlen(text);

            if(text_len >= sizeof(text) - sizeof(line))
            {
                break;
            }
        }
    }

    Update3DTextLabelText(
        exchange_label,
        0xFFFFFFFF,
        text
    );

    return 1;
}

// ============================================================
// ГЛАВНОЕ МЕНЮ
// ============================================================

stock Exchange_Open(playerid) 
{ 
    ShowPlayerDialog(playerid, DLG_EXCHANGE_MAIN, DIALOG_STYLE_LIST, "Биржа транспорта", "Выставить машину на продажу\nКупить машину", "Выбрать", "Закрыть"); 
    return 1; 
}

// ============================================================
// СПИСОК ДЛЯ ПРОДАЖИ
// ============================================================

stock Exchange_ShowSellList(playerid)
{
    new list[2048], name[64], count=0;
    exchange_selected_vehicle[playerid] = -1;
    for(new v; v < MAX_OWNABLE_CARS; v++) {
        if(GetOwnableCarData(v,OC_SQL_ID) <= 0) continue;
        if(GetOwnableCarData(v,OC_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
        new onmarket=0; 
        for(new j; j<exchange_lot_count; j++) {
            if(ExchangeLot[j][ex_vehicle_sql] == GetOwnableCarData(v,OC_SQL_ID)) { onmarket=1; break; }
        }
        if(onmarket) continue;
        format(name,sizeof name,"%s\n", GetVehicleModelName(GetOwnableCarData(v,OC_MODEL_ID))); 
        strcat(list,name); 
        count++;
    }
    if(!count) {
        SendClientMessage(playerid, -1, "{FF0000}У вас нет машин, доступных для выставления.");
        return 1;
    }
    ShowPlayerDialog(playerid, DLG_EXCHANGE_SELL_LIST, DIALOG_STYLE_LIST, "Выберите машину", list, "Выбрать", "Назад"); 
    return 1;
}

// ============================================================
// ГЕНЕРАЦИЯ ID ЛОТА
// ============================================================

stock Exchange_MakeLotID(dest[], size)
{
    for(new tries; tries < 200; tries++) { 
        format(dest,size,"BR%04d",random(10000)); 
        new found=0; 
        for(new i;i<exchange_lot_count;i++) {
            if(!strcmp(dest,ExchangeLot[i][ex_lot],true)) { found=1; break; }
        } 
        if(!found) return 1; 
    }
    return 0;
}

// ============================================================
// ДОБАВЛЕНИЕ ЛОТА
// ============================================================

stock Exchange_AddLot(playerid, price)
{
    new v=exchange_selected_vehicle[playerid]; 
    if(v < 0 || GetOwnableCarData(v,OC_OWNER_ID) != GetPlayerAccountID(playerid)) return 0;
    new lot[9], name[32], q[512]; 
    if(!Exchange_MakeLotID(lot,sizeof lot)) return 0;
    format(name,sizeof name,"%s", GetVehicleModelName(GetOwnableCarData(v,OC_MODEL_ID)));
    mysql_format(mysql,q,sizeof q,"INSERT INTO vehicle_exchange (seller_id,vehicle_id,model,price,model_name,lot_id,active,created_at) VALUES (%d,%d,%d,%d,'%e','%e',1,%d)", GetPlayerAccountID(playerid), GetOwnableCarData(v,OC_SQL_ID), GetOwnableCarData(v,OC_MODEL_ID), price, name, lot, gettime()); 
    mysql_tquery(mysql,q,"Exchange_LoadLots","");
    new msg[144]; 
    format(msg,sizeof msg,"{00FF00}Вы выставили %s за %d руб. ID лота: %s", name, price, lot); 
    SendClientMessage(playerid, -1, msg); 
    return 1;
}

// ============================================================
// ПОИСК ЛОТА
// ============================================================

stock Exchange_FindLot(const id[]) { 
    for(new i;i<exchange_lot_count;i++) {
        if(!strcmp(id,ExchangeLot[i][ex_lot],true)) return i; 
    } 
    return -1; 
}

// ============================================================
// ПОИСК ИГРОКА ПО АККАУНТУ
// ============================================================

stock Exchange_FindOnlineAccount(acc) { 
    for(new p;p<MAX_PLAYERS;p++) {
        if(IsPlayerConnected(p) && IsPlayerLogged(p) && GetPlayerAccountID(p)==acc) return p; 
    } 
    return INVALID_PLAYER_ID; 
}

// ============================================================
// ПОКУПКА
// ============================================================

stock Exchange_Buy(playerid, lotidx)
{
    if(lotidx < 0 || lotidx >= exchange_lot_count) return 0;
    if(ExchangeLot[lotidx][ex_seller] == GetPlayerAccountID(playerid)) {
        SendClientMessage(playerid, -1, "{FF0000}Нельзя купить собственную машину.");
        return 0;
    }
    if(GetPlayerMoneyEx(playerid) < ExchangeLot[lotidx][ex_price]) {
        SendClientMessage(playerid, -1, "{FF0000}Недостаточно денег.");
        return 0;
    }
    
    new car_count = 0;
    for(new i; i < MAX_OWNABLE_CARS; i++) {
        if(GetOwnableCarData(i, OC_OWNER_ID) == GetPlayerAccountID(playerid)) car_count++;
    }
    if(car_count >= GetPlayerCarSlots(playerid)) {
        SendClientMessage(playerid, -1, "{FF0000}Нет свободного слота транспорта.");
        return 0;
    }
    
    new q[768], seller=ExchangeLot[lotidx][ex_seller], vehicle_sql=ExchangeLot[lotidx][ex_vehicle_sql], price=ExchangeLot[lotidx][ex_price], buyer=GetPlayerAccountID(playerid), lot[9], name[32]; 
    format(lot,sizeof lot,"%s",ExchangeLot[lotidx][ex_lot]); 
    format(name,sizeof name,"%s",ExchangeLot[lotidx][ex_name]);
    
    GivePlayerMoneyEx(playerid,-price);
    
    new sp=Exchange_FindOnlineAccount(seller); 
    if(sp != INVALID_PLAYER_ID) { 
        GivePlayerMoneyEx(sp,price); 
        new m[128]; 
        format(m,sizeof m,"{00FF00}Ваша машина %s продана за %d руб.",name,price); 
        SendClientMessage(sp, -1, m); 
    } else { 
        mysql_format(mysql,q,sizeof q,"UPDATE accounts SET money=money+%d WHERE id=%d",price,seller); 
        mysql_tquery(mysql,q); 
    }
    
    mysql_format(mysql,q,sizeof q,"UPDATE ownable_cars SET owner_id=%d WHERE id=%d",buyer,vehicle_sql); 
    mysql_tquery(mysql,q);
    mysql_format(mysql,q,sizeof q,"INSERT INTO exchange_history (lot_id,seller_id,buyer_id,vehicle_id,model,model_name,price,sold_at) VALUES ('%e',%d,%d,%d,%d,'%e',%d,%d)",lot,seller,buyer,vehicle_sql,ExchangeLot[lotidx][ex_model],name,price,gettime()); 
    mysql_tquery(mysql,q);
    mysql_format(mysql,q,sizeof q,"UPDATE vehicle_exchange SET active=0 WHERE id=%d",ExchangeLot[lotidx][ex_id]); 
    mysql_tquery(mysql,q,"Exchange_LoadLots","");
    
    for(new v;v<MAX_OWNABLE_CARS;v++) {
        if(GetOwnableCarData(v,OC_SQL_ID)==vehicle_sql) { 
            SetOwnableCarData(v,OC_OWNER_ID,buyer); 
            SetOwnableCarData(v,OC_POS_X,0); 
            break;
        }
    }
    
    new msg[128]; 
    format(msg,sizeof msg,"{00FF00}Вы приобрели %s за %d руб.",name,price); 
    SendClientMessage(playerid, -1, msg); 
    return 1;
}

// ============================================================
// ОБРАБОТЧИКИ
// ============================================================

stock Exchange_HandlePickup(playerid,pickupid) { 
    if(pickupid == exchange_pickup) { 
        Exchange_Open(playerid); 
        return 1; 
    } 
    return 0; 
}

stock Exchange_HandleDialog(playerid,dialogid,response,listitem,inputtext[])
{
    if(dialogid < DLG_EXCHANGE_MAIN || dialogid > DLG_EXCHANGE_CONFIRM) return 0;
    if(dialogid==DLG_EXCHANGE_MAIN) { 
        if(!response) return 1; 
        if(listitem==0) Exchange_ShowSellList(playerid); 
        else ShowPlayerDialog(playerid, DLG_EXCHANGE_BUY_ID, DIALOG_STYLE_INPUT, "Покупка машины", "Введите ID лота для покупки (например BR9993):", "Далее", "Отмена"); 
        return 1; 
    }
    if(dialogid==DLG_EXCHANGE_SELL_LIST) { 
        if(!response){ Exchange_Open(playerid); return 1; } 
        new n=-1,c=-1; 
        for(new v; v < MAX_OWNABLE_CARS; v++) {
            if(GetOwnableCarData(v,OC_SQL_ID) <= 0) continue;
            if(GetOwnableCarData(v,OC_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
            new om=0; 
            for(new j;j<exchange_lot_count;j++) {
                if(ExchangeLot[j][ex_vehicle_sql]==GetOwnableCarData(v,OC_SQL_ID)) { om=1; break; }
            }
            if(om) continue;
            c++; if(c==listitem){ n=v; break; }
        } 
        if(n<0) return 1; 
        exchange_selected_vehicle[playerid]=n; 
        ShowPlayerDialog(playerid, DLG_EXCHANGE_PRICE, DIALOG_STYLE_INPUT, "Укажите цену продажи", "Введите цену продажи:", "Выставить", "Отмена"); 
        return 1; 
    }
    if(dialogid==DLG_EXCHANGE_PRICE) { 
        if(!response) return 1; 
        new price=strval(inputtext); 
        if(price<=0) {
            SendClientMessage(playerid, -1, "{FF0000}Укажите корректную цену.");
            return 1;
        }
        Exchange_AddLot(playerid,price); 
        return 1; 
    }
    if(dialogid==DLG_EXCHANGE_BUY_ID) { 
        if(!response) return 1; 
        new idx=Exchange_FindLot(inputtext); 
        if(idx<0) {
            SendClientMessage(playerid, -1, "{FF0000}Лот с таким ID не найден.");
            return 1;
        }
        exchange_buy_lot[playerid]=idx; 
        new t[160]; 
        format(t,sizeof t,"Вы уверены, что приобретаете %s за %d руб.?", ExchangeLot[idx][ex_name], ExchangeLot[idx][ex_price]); 
        ShowPlayerDialog(playerid, DLG_EXCHANGE_CONFIRM, DIALOG_STYLE_MSGBOX, "Подтверждение покупки", t, "Купить", "Отмена"); 
        return 1; 
    }
    if(dialogid==DLG_EXCHANGE_CONFIRM) { 
        if(response) Exchange_Buy(playerid, exchange_buy_lot[playerid]); 
        return 1; 
    }
    return 1;
}