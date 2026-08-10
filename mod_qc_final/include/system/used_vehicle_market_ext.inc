#if defined _USED_VEHICLE_MARKET_EXT_INCLUDED
    #endinput
#endif
#define _USED_VEHICLE_MARKET_EXT_INCLUDED

/*
    Расширение личного транспорта: пробег, износ, страховка и продажа авто в гос.

    Эта версия не добавляет рынок между игроками.
    Она рассчитана на уже существующую команду /sellcar в laird.pwn:
    /sellcar открывает диалог продажи авто государству, а цена зависит от:
        - гос. цены автомобиля;
        - пробега;
        - технического износа;
        - активной страховки.

    Нужные правки в laird.pwn:
        CMD:sellcar -> return UVM_ShowGovSellDialog(playerid);
        положительный ответ DIALOG_OWNABLE_CAR_SELL -> UVM_SellOwnVehicleToState(playerid);
*/

#define UVM_WEAR_MAX             (100)
#define UVM_WEAR_KM_STEP         (10.0)
#define UVM_MAX_INSURANCE_DAYS   (30)

// Настройки баланса продажи в гос
#define UVM_GOV_SELL_PERCENT         (50) // целая машина: 50% от гос. цены
#define UVM_MIN_GOV_SELL_PERCENT     (10) // убитая машина: не ниже 10% от гос. цены
#define UVM_MAX_MILEAGE_PENALTY      (35) // максимум -35% от базовой цены продажи
#define UVM_MAX_WEAR_PENALTY         (60) // максимум -60% от базовой цены продажи
#define UVM_MAX_TOTAL_PENALTY        (75) // общий штраф максимум от базовой цены продажи
#define UVM_INSURANCE_BONUS          (5)  // активная страховка возвращает +5% от базовой цены продажи

new g_uvm_car_wear[MAX_VEHICLES];
new g_uvm_insurance_until[MAX_VEHICLES];
new g_uvm_insurance_claims[MAX_VEHICLES];
new Float:g_uvm_wear_last_mileage[MAX_VEHICLES];

stock UVM_GetPlayerByAccount(account_id)
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(GetPlayerAccountID(i) == account_id) return i;
    }
    return INVALID_PLAYER_ID;
}

stock UVM_GetBaseVehiclePrice(modelid)
{
    new price = GetVehicleMarketPriceByModel(modelid);
    if(price <= 0) GetVehicleJsonCostByModelId(modelid, price);
    if(price <= 0) price = 100000;
    return price;
}

stock UVM_ClearRuntime(vehicleid)
{
    if(!IsValidVehicleID(vehicleid)) return 0;

    g_uvm_car_wear[vehicleid] = 0;
    g_uvm_insurance_until[vehicleid] = 0;
    g_uvm_insurance_claims[vehicleid] = 0;
    g_uvm_wear_last_mileage[vehicleid] = 0.0;
    return 1;
}

stock UVM_SyncRuntimeFromDb(vehicleid)
{
    if(!IsValidVehicleID(vehicleid)) return 0;
    if(!IsAOwnableCar(vehicleid)) return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 0;

    new oc_id = GetOwnableCarData(index, OC_SQL_ID);
    if(oc_id <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof query,
        "SELECT car_wear, insurance_until, insurance_claims FROM ownable_cars WHERE id=%d LIMIT 1",
        oc_id);

    new Cache:result = mysql_query(mysql, query, true);
    if(cache_num_rows())
    {
        g_uvm_car_wear[vehicleid] = cache_get_field_content_int(0, "car_wear");
        g_uvm_insurance_until[vehicleid] = cache_get_field_content_int(0, "insurance_until");
        g_uvm_insurance_claims[vehicleid] = cache_get_field_content_int(0, "insurance_claims");
        g_uvm_wear_last_mileage[vehicleid] = GetVehicleData(vehicleid, V_MILEAGE);
    }
    cache_delete(result);

    return 1;
}

stock UVM_SaveRuntime(vehicleid)
{
    if(!IsValidVehicleID(vehicleid)) return 0;
    if(!IsAOwnableCar(vehicleid)) return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 0;

    new oc_id = GetOwnableCarData(index, OC_SQL_ID);
    if(oc_id <= 0) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof query,
        "UPDATE ownable_cars SET car_wear=%d, insurance_until=%d, insurance_claims=%d WHERE id=%d LIMIT 1",
        g_uvm_car_wear[vehicleid],
        g_uvm_insurance_until[vehicleid],
        g_uvm_insurance_claims[vehicleid],
        oc_id);
    mysql_tquery(mysql, query, "", "");

    return 1;
}

stock UVM_AddWear(vehicleid, amount, bool:save = true)
{
    if(!IsValidVehicleID(vehicleid)) return 0;
    if(!IsAOwnableCar(vehicleid)) return 0;
    if(amount <= 0) return 0;

    g_uvm_car_wear[vehicleid] += amount;
    if(g_uvm_car_wear[vehicleid] > UVM_WEAR_MAX) g_uvm_car_wear[vehicleid] = UVM_WEAR_MAX;

    // Изношенный автомобиль не всегда можно держать в идеальном состоянии.
    new Float:max_health = 1000.0 - float(g_uvm_car_wear[vehicleid] * 3);
    if(max_health < 650.0) max_health = 650.0;

    new Float:health;
    GetVehicleHealth(vehicleid, health);
    if(health > max_health)
    {
        SetVehicleHealth(vehicleid, max_health);
        SetVehicleData(vehicleid, V_HEALTH, max_health);
    }

    if(save) UVM_SaveRuntime(vehicleid);
    return 1;
}

stock UVM_ProcessWearByMileage(playerid)
{
    if(!IsPlayerDriver(playerid)) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 0;
    if(!IsAOwnableCar(vehicleid)) return 0;

    new Float:mileage = GetVehicleData(vehicleid, V_MILEAGE);
    if(g_uvm_wear_last_mileage[vehicleid] <= 0.0)
    {
        g_uvm_wear_last_mileage[vehicleid] = mileage;
        return 1;
    }

    if((mileage - g_uvm_wear_last_mileage[vehicleid]) >= UVM_WEAR_KM_STEP)
    {
        g_uvm_wear_last_mileage[vehicleid] = mileage;
        UVM_AddWear(vehicleid, 1, true);
    }
    return 1;
}

stock UVM_GetInsurancePrice(modelid, days)
{
    new base_price = UVM_GetBaseVehiclePrice(modelid);
    new price_per_day = base_price / 250; // 0.4% в день
    if(price_per_day < 1500) price_per_day = 1500;
    return price_per_day * days;
}

stock UVM_GetRepairWearPrice(modelid, wear)
{
    new base_price = UVM_GetBaseVehiclePrice(modelid);
    new price = (base_price * wear) / 700; // около 14.2% от гос. цены при износе 100
    if(price < 2500) price = 2500;
    return price;
}

stock UVM_GetWearText(wear, output[], size = sizeof output)
{
    if(wear < 20) format(output, size, "отличное");
    else if(wear < 45) format(output, size, "хорошее");
    else if(wear < 70) format(output, size, "изношено");
    else if(wear < 90) format(output, size, "плохое");
    else format(output, size, "критическое");
    return 1;
}

stock UVM_FormatDaysLeft(until_time, output[], size = sizeof output)
{
    new now = gettime();
    if(until_time <= now)
    {
        format(output, size, "нет");
        return 0;
    }

    new seconds = until_time - now;
    new days = seconds / 86400;
    if(days < 1) days = 1;
    format(output, size, "%d дн.", days);
    return 1;
}

stock UVM_GetGovSellPriceEx(vehicleid, &base_price, &clean_sell_price, &mileage_penalty, &wear_penalty, &insurance_bonus, &final_price)
{
    if(!IsValidVehicleID(vehicleid)) return 0;
    if(!IsAOwnableCar(vehicleid)) return 0;

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    base_price = UVM_GetBaseVehiclePrice(modelid);
    clean_sell_price = (base_price * UVM_GOV_SELL_PERCENT) / 100;

    new mileage_km = floatround(GetVehicleData(vehicleid, V_MILEAGE), floatround_floor);
    mileage_penalty = mileage_km / 2500; // -1% за каждые 2500 км
    if(mileage_penalty > UVM_MAX_MILEAGE_PENALTY) mileage_penalty = UVM_MAX_MILEAGE_PENALTY;

    wear_penalty = (g_uvm_car_wear[vehicleid] * UVM_MAX_WEAR_PENALTY) / UVM_WEAR_MAX;
    if(wear_penalty > UVM_MAX_WEAR_PENALTY) wear_penalty = UVM_MAX_WEAR_PENALTY;

    new total_penalty = mileage_penalty + wear_penalty;
    if(total_penalty > UVM_MAX_TOTAL_PENALTY) total_penalty = UVM_MAX_TOTAL_PENALTY;

    final_price = clean_sell_price - ((clean_sell_price * total_penalty) / 100);

    if(g_uvm_insurance_until[vehicleid] > gettime())
    {
        insurance_bonus = (clean_sell_price * UVM_INSURANCE_BONUS) / 100;
        final_price += insurance_bonus;
    }
    else insurance_bonus = 0;

    if(final_price > clean_sell_price) final_price = clean_sell_price;

    new min_price = (base_price * UVM_MIN_GOV_SELL_PERCENT) / 100;
    if(final_price < min_price) final_price = min_price;

    return final_price;
}

stock UVM_GetGovSellPrice(vehicleid)
{
    new base_price, clean_sell_price, mileage_penalty, wear_penalty, insurance_bonus, final_price;
    UVM_GetGovSellPriceEx(vehicleid, base_price, clean_sell_price, mileage_penalty, wear_penalty, insurance_bonus, final_price);
    return final_price;
}

stock UVM_ShowGovSellDialog(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        if(GetPlayerOwnableCars(playerid) == 0)
            return SendClientMessage(playerid, 0x999999FF, "У вас нет личного транспорта.");
        return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен. Сначала используйте /car.");
    }

    if(!IsAOwnableCar(vehicleid)) return 1;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 1;

    if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт вам не принадлежит.");

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new vehicle_name[64];
    if(!GetVehicleJsonNameByModelId(modelid, vehicle_name, sizeof vehicle_name))
        format(vehicle_name, sizeof vehicle_name, "Модель %d", modelid);

    new base_price, clean_sell_price, mileage_penalty, wear_penalty, insurance_bonus, final_price;
    UVM_GetGovSellPriceEx(vehicleid, base_price, clean_sell_price, mileage_penalty, wear_penalty, insurance_bonus, final_price);

    new wear_text[24], insurance_text[32], text[1400];
    UVM_GetWearText(g_uvm_car_wear[vehicleid], wear_text, sizeof wear_text);
    UVM_FormatDaysLeft(g_uvm_insurance_until[vehicleid], insurance_text, sizeof insurance_text);

    format(text, sizeof text,
        "Автомобиль:\t%s (#%d)\n"\
        "Гос. цена:\t%d руб.\n"\
        "Цена продажи без штрафов:\t%d руб. (%d%%)\n"\
        "Пробег:\t%d км (-%d%%)\n"\
        "Износ:\t%d/100, %s (-%d%%)\n"\
        "Страховка:\t%s (+%d руб.)\n\n"\
        "Итоговая цена продажи:\t%d руб.\n\n"\
        "Автомобиль будет удалён из гаража. Продать его государству?",
        vehicle_name,
        modelid,
        base_price,
        clean_sell_price,
        UVM_GOV_SELL_PERCENT,
        floatround(GetVehicleData(vehicleid, V_MILEAGE), floatround_floor),
        mileage_penalty,
        g_uvm_car_wear[vehicleid],
        wear_text,
        wear_penalty,
        insurance_text,
        insurance_bonus,
        final_price
    );

    Dialog(playerid, DIALOG_OWNABLE_CAR_SELL, DIALOG_STYLE_MSGBOX,
        "Продажа авто в гос", text, "Продать", "Отмена");
    return 1;
}

stock UVM_SellOwnVehicleToState(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, 0xCECECEFF, "Ваш личный транспорт не загружен. Сначала используйте /car.");

    if(!IsAOwnableCar(vehicleid)) return 1;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 1;

    if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт вам не принадлежит.");

    new sell_price = UVM_GetGovSellPrice(vehicleid);

    SaveOwnableCar(vehicleid);
    UVM_SaveRuntime(vehicleid);

    if(DestroyOwnableCar(vehicleid))
    {
        new msg[192];
        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
        GivePlayerMoneyEx(playerid, sell_price, "Продажа авто в гос", true, false);

        format(msg, sizeof msg, "Автомобиль продан государству. Вы получили %d руб.", sell_price);
        SendClientMessage(playerid, 0x66CC00FF, msg);
        return 1;
    }

    return SendClientMessage(playerid, 0xCECECEFF, "Ошибка: автомобиль не был продан. Проверьте лог сервера / MySQL.");
}

stock UVM_ShowPassport(playerid, vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsAOwnableCar(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "Сначала загрузите личный транспорт. (/car)");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 1;

    if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт вам не принадлежит.");

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new vehicle_name[64];
    if(!GetVehicleJsonNameByModelId(modelid, vehicle_name, sizeof vehicle_name))
        format(vehicle_name, sizeof vehicle_name, "Модель %d", modelid);

    new wear_text[24], insurance_text[32], text[1024];
    UVM_GetWearText(g_uvm_car_wear[vehicleid], wear_text, sizeof wear_text);
    UVM_FormatDaysLeft(g_uvm_insurance_until[vehicleid], insurance_text, sizeof insurance_text);

    format(text, sizeof text,
        "Автомобиль:\t%s (#%d)\n"\
        "ID в базе:\t%d\n"\
        "Пробег:\t%d км\n"\
        "Износ:\t%d/100 (%s)\n"\
        "Страховка:\t%s\n"\
        "Страховых случаев:\t%d\n"\
        "Текущая цена /sellcar:\t%d руб.",
        vehicle_name,
        modelid,
        GetOwnableCarData(index, OC_SQL_ID),
        floatround(GetVehicleData(vehicleid, V_MILEAGE), floatround_floor),
        g_uvm_car_wear[vehicleid],
        wear_text,
        insurance_text,
        g_uvm_insurance_claims[vehicleid],
        UVM_GetGovSellPrice(vehicleid));

    ShowPlayerDialog(playerid, 28101, DIALOG_STYLE_MSGBOX, "Паспорт автомобиля", text, "Закрыть", "");
    return 1;
}

stock UVM_BuyInsurance(playerid, days)
{
    if(!(1 <= days <= UVM_MAX_INSURANCE_DAYS))
        return SendClientMessage(playerid, 0xCECECEFF, "Использование: /buyinsurance [1-30 дней]");

    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsAOwnableCar(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "Сначала загрузите личный транспорт. (/car)");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 1;

    if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт вам не принадлежит.");

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new price = UVM_GetInsurancePrice(modelid, days);

    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для покупки страховки.");

    GivePlayerMoneyEx(playerid, -price, "Страховка автомобиля", true, true);

    new now = gettime();
    if(g_uvm_insurance_until[vehicleid] < now) g_uvm_insurance_until[vehicleid] = now;
    g_uvm_insurance_until[vehicleid] += days * 86400;

    UVM_SaveRuntime(vehicleid);

    new msg[128];
    format(msg, sizeof msg, "Страховка куплена на %d дн. Цена: %d руб.", days, price);
    SendClientMessage(playerid, 0x66CC00FF, msg);
    return 1;
}

stock UVM_RepairWear(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsAOwnableCar(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "Сначала загрузите личный транспорт. (/car)");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 1;

    if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт вам не принадлежит.");

    new wear = g_uvm_car_wear[vehicleid];
    if(wear <= 0) return SendClientMessage(playerid, 0xCECECEFF, "Износ уже равен 0.");

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new price = UVM_GetRepairWearPrice(modelid, wear);

    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для ремонта.");

    GivePlayerMoneyEx(playerid, -price, "Ремонт износа автомобиля", true, true);
    g_uvm_car_wear[vehicleid] = 0;
    UVM_SaveRuntime(vehicleid);

    SetVehicleHealth(vehicleid, 1000.0);
    SetVehicleData(vehicleid, V_HEALTH, 1000.0);

    new msg[128];
    format(msg, sizeof msg, "Износ автомобиля отремонтирован. Цена: %d руб.", price);
    SendClientMessage(playerid, 0x66CC00FF, msg);
    return 1;
}

stock UVM_InsuranceClaim(vehicleid)
{
    if(!IsValidVehicleID(vehicleid)) return 0;
    if(!IsAOwnableCar(vehicleid)) return 0;

    if(g_uvm_insurance_until[vehicleid] <= gettime())
    {
        UVM_AddWear(vehicleid, 5, true);
        return 0;
    }

    g_uvm_insurance_claims[vehicleid]++;
    UVM_AddWear(vehicleid, 3, false);
    SetVehicleData(vehicleid, V_HEALTH, 1000.0);

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index >= 0)
    {
        new ownerid = UVM_GetPlayerByAccount(GetOwnableCarData(index, OC_OWNER_ID));
        if(ownerid != INVALID_PLAYER_ID)
            SendClientMessage(ownerid, 0x66CC00FF, "Страховка покрыла аварию автомобиля. Износ +3.");
    }

    UVM_SaveRuntime(vehicleid);
    return 1;
}

stock UVM_MigrateColumn(test_query[], alter_query[])
{
    mysql_query(mysql, test_query, false);
    if(mysql_errno()) mysql_tquery(mysql, alter_query, "", "");
    return 1;
}

stock UVM_InitSql()
{
    UVM_MigrateColumn(
        "SELECT car_wear FROM ownable_cars LIMIT 1",
        "ALTER TABLE ownable_cars ADD car_wear TINYINT UNSIGNED NOT NULL DEFAULT 0"
    );
    UVM_MigrateColumn(
        "SELECT insurance_until FROM ownable_cars LIMIT 1",
        "ALTER TABLE ownable_cars ADD insurance_until INT NOT NULL DEFAULT 0"
    );
    UVM_MigrateColumn(
        "SELECT insurance_claims FROM ownable_cars LIMIT 1",
        "ALTER TABLE ownable_cars ADD insurance_claims SMALLINT UNSIGNED NOT NULL DEFAULT 0"
    );
    return 1;
}

// Здесь не регистрируются дополнительные команды.
// /sellcar обрабатывается через исправленную команду в laird.pwn.
// UVM_ShowPassport, UVM_BuyInsurance и UVM_RepairWear оставлены как stock-функции,
// чтобы позже подключить их к меню /car, NPC страховой или автосервису.

stock UVM_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
    new vehicleid = CreateVehicle(modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren, action_type, action_id);
    if(IsValidVehicleID(vehicleid))
    {
        UVM_ClearRuntime(vehicleid);
        if(action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        {
            UVM_SyncRuntimeFromDb(vehicleid);
        }
    }
    return vehicleid;
}
#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle UVM_CreateVehicle

stock UVM_DestroyVehicle(vehicleid)
{
    UVM_ClearRuntime(vehicleid);
    return DestroyVehicle(vehicleid);
}
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle UVM_DestroyVehicle

public OnGameModeInit()
{
#if defined UVM_OnGameModeInit
    new result = UVM_OnGameModeInit();
#else
    new result = 1;
#endif
    // Запускаем SQL-миграцию после основного OnGameModeInit, потому что MySQL подключается там.
    UVM_InitSql();
    return result;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit UVM_OnGameModeInit
#if defined UVM_OnGameModeInit
forward UVM_OnGameModeInit();
#endif

public OnSecondTimer()
{
    foreach(new playerid : Player)
    {
        if(IsPlayerConnected(playerid) && IsPlayerLogged(playerid))
        {
            UVM_ProcessWearByMileage(playerid);
        }
    }
#if defined UVM_OnSecondTimer
    return UVM_OnSecondTimer();
#else
    return 1;
#endif
}
#if defined _ALS_OnSecondTimer
    #undef OnSecondTimer
#else
    #define _ALS_OnSecondTimer
#endif
#define OnSecondTimer UVM_OnSecondTimer
#if defined UVM_OnSecondTimer
forward UVM_OnSecondTimer();
#endif

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if(IsAOwnableCar(vehicleid))
    {
        new Float:health;
        GetVehicleHealth(vehicleid, health);
        if(health < 850.0) UVM_AddWear(vehicleid, 1, true);
    }
#if defined UVM_OnVehicleDamageStatusUpdate
    return UVM_OnVehicleDamageStatusUpdate(vehicleid, playerid);
#else
    return 1;
#endif
}
#if defined _ALS_OnVehicleDamageStatusUpdate
    #undef OnVehicleDamageStatusUpdate
#else
    #define _ALS_OnVehicleDamageStatusUpdate
#endif
#define OnVehicleDamageStatusUpdate UVM_OnVehicleDamageStatusUpdate
#if defined UVM_OnVehicleDamageStatusUpdate
forward UVM_OnVehicleDamageStatusUpdate(vehicleid, playerid);
#endif

public OnVehicleDeath(vehicleid, killerid)
{
    UVM_InsuranceClaim(vehicleid);
#if defined UVM_OnVehicleDeath
    return UVM_OnVehicleDeath(vehicleid, killerid);
#else
    return 1;
#endif
}
#if defined _ALS_OnVehicleDeath
    #undef OnVehicleDeath
#else
    #define _ALS_OnVehicleDeath
#endif
#define OnVehicleDeath UVM_OnVehicleDeath
#if defined UVM_OnVehicleDeath
forward UVM_OnVehicleDeath(vehicleid, killerid);
#endif
