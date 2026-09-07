/*
    GUI-меню личного транспорта
    Авторская доработка для laird.pwn

    Что делает:
    - заменяет старое меню /car на удобное диалоговое GUI;
    - показывает статус авто: пробег, износ, страховка, топливо, состояние;
    - даёт быстрые кнопки управления авто;
    - использует уже существующие функции мода и систему UVM.
*/

#if defined _car_gui_menu_included
    #endinput
#endif
#define _car_gui_menu_included

#define CARGUI_COLOR_INFO      (0x66CC33FF)
#define CARGUI_COLOR_ERROR     (0xCECECEFF)
#define CARGUI_COLOR_GRAY      (0x999999FF)


stock CarGUI_ShowVehicleList(playerid)
{
    new fmt_text[512];
    new Cache:result;
    new rows;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);
    rows = cache_num_rows();

    if(rows == 0)
    {
        SendClientMessage(playerid, CARGUI_COLOR_GRAY, "У Вас нет личного транспорта");
        cache_delete(result);
        return 1;
    }

    new dialog_text[4096] = "";
    strcat(dialog_text, "{FFCD00}№\t{FFCD00}Модель\t{FFCD00}Номер\t{FFCD00}Статус\n");

    new query[196];
    new model_id;
    new num_type;
    new car_number[16];
    new car_region[8];
    new model_name[64];
    new listed = 0;

    for(new i = 0; i < rows; i++)
    {
        new id = cache_get_field_content_int(i, "id");
        model_id = cache_get_field_content_int(i, "model_id");
        num_type = cache_get_field_content_int(i, "number_type");
        cache_get_field_content(i, "number", car_number);
        cache_get_field_content(i, "region", car_region);

        if(g_ownable_car_loaded >= MAX_OWNABLE_CARS && !IsOwnableCarLoaded(id))
            continue;

        GetVehicleModelName(model_id, model_name, sizeof(model_name));

        new status_text[32];
        if(IsOwnableCarLoaded(id))
        {
            format(status_text, sizeof status_text, "{669900}Загружен");
        }
        else
        {
            format(status_text, sizeof status_text, "{FF3300}Не загружен");
        }

        new display_number[32];
        if(num_type == 1 || num_type == 4)
        {
            format(display_number, sizeof display_number, "[%s | %s]", car_number, car_region);
        }
        else if(num_type == 2 || num_type == 3)
        {
            format(display_number, sizeof display_number, "[%s]", car_number);
        }
        else
        {
            format(display_number, sizeof display_number, "[%s | %s]", car_number, car_region);
        }

        format(query, sizeof query, "{FFFFFF}%d\t{FFFFFF}%s\t{888888}%s\t%s\n", listed + 1, model_name, display_number, status_text);

        if(listed >= sizeof(g_player_listitem[]))
            break;

        if(strlen(dialog_text) + strlen(query) >= sizeof(dialog_text) - 1)
            break;

        strcat(dialog_text, query);
        SetPlayerListitemValue(playerid, listed, id);
        listed++;
    }

    if(listed == 0)
    {
        SendClientMessage(playerid, CARGUI_COLOR_GRAY, "Нет доступных к загрузке автомобилей (лимит превышен)");
        cache_delete(result);
        return 1;
    }

    Dialog(playerid, DIALOG_OWNABLE_CAR_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        "{FFCD00}Ваш личный транспорт",
        dialog_text,
        "Выбрать", "Закрыть"
    );

    cache_delete(result);
    return 1;
}

stock CarGUI_Command(playerid)
{
    new ownableCar = GetPlayerOwnableCar(playerid);

    if(ownableCar != INVALID_VEHICLE_ID && !IsValidVehicle(ownableCar))
    {
        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
        ownableCar = INVALID_VEHICLE_ID;
    }

    if(ownableCar != INVALID_VEHICLE_ID && IsValidVehicle(ownableCar) && IsAOwnableCar(ownableCar))
    {
        return CarGUI_ShowMain(playerid);
    }

    return CarGUI_ShowVehicleList(playerid);
}

stock CarGUI_GetPlayerVehicle(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);

    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        if(GetPlayerOwnableCars(playerid) == 0)
            SendClientMessage(playerid, CARGUI_COLOR_GRAY, "У Вас нет личного транспорта");
        else
            SendClientMessage(playerid, CARGUI_COLOR_GRAY, "Ваш личный транспорт не загружен на сервер");

        return INVALID_VEHICLE_ID;
    }

    if(!IsAOwnableCar(vehicleid))
    {
        SendClientMessage(playerid, CARGUI_COLOR_ERROR, "Ошибка: выбранный транспорт не является личным");
        return INVALID_VEHICLE_ID;
    }

    return vehicleid;
}

stock CarGUI_FormatLockStatus(vehicleid, output[], size = sizeof output)
{
    if(GetVehicleParam(vehicleid, V_LOCK))
        format(output, size, "{FF6666}закрыт");
    else
        format(output, size, "{66CC33}открыт");

    return 1;
}

stock CarGUI_FormatEngineStatus(vehicleid, output[], size = sizeof output)
{
    if(IsABike(vehicleid))
    {
        format(output, size, "{888888}не требуется");
        return 1;
    }

    if(GetVehicleParam(vehicleid, V_ENGINE))
        format(output, size, "{66CC33}заведён");
    else
        format(output, size, "{FF6666}заглушен");

    return 1;
}

stock CarGUI_FormatFuel(vehicleid, output[], size = sizeof output)
{
    new fuel = floatround(GetVehicleData(vehicleid, V_FUEL), floatround_floor);
    if(fuel < 0) fuel = 0;
    format(output, size, "%d л", fuel);
    return 1;
}

stock CarGUI_ShowMain(playerid)
{
    new vehicleid = CarGUI_GetPlayerVehicle(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new index = GetVehicleData(vehicleid, V_ACTION_ID);

    new lock_text[24], engine_text[24], fuel_text[24], wear_text[32], insurance_text[40];
    CarGUI_FormatLockStatus(vehicleid, lock_text, sizeof lock_text);
    CarGUI_FormatEngineStatus(vehicleid, engine_text, sizeof engine_text);
    CarGUI_FormatFuel(vehicleid, fuel_text, sizeof fuel_text);
    UVM_GetWearText(g_uvm_car_wear[vehicleid], wear_text, sizeof wear_text);
    UVM_FormatDaysLeft(g_uvm_insurance_until[vehicleid], insurance_text, sizeof insurance_text);

    new Float:health_float;
    GetVehicleHealth(vehicleid, health_float);

    new mileage = floatround(GetVehicleData(vehicleid, V_MILEAGE), floatround_floor);
    new health = floatround(health_float, floatround_floor);
    new sell_price = UVM_GetGovSellPrice(vehicleid);

    new title[96];
    format(title, sizeof title, "{FFCD00}Меню авто: {FFFFFF}%s", GetVehicleInfo(modelid - 400, VI_NAME));

    new text[2048];
    format
    (
        text, sizeof text,
        "Действие\tИнформация\n"\
        "Паспорт авто\tПробег: %d км | Износ: %s\n"\
        "Открыть / закрыть\tСейчас: %s\n"\
        "Завести / заглушить\tСейчас: %s\n"\
        "Отметить на GPS\tСтоимость: 300 руб\n"\
        "Багажник\tОткрыть содержимое\n"\
        "Страховка\t%s\n"\
        "Ремонт износа\tИзнос: %d%%\n"\
        "Снять номера\tТекущий номер: %s\n"\
        "Припарковать\tСохранить позицию\n"\
        "Продать в гос\tЦена: %d руб\n"\
        "Выгрузить с сервера\tОсвободить слот\n"\
        "Добавить авто в семью\tТолько для лидера семьи",
        mileage,
        wear_text,
        lock_text,
        engine_text,
        insurance_text,
        g_uvm_car_wear[vehicleid],
        GetOwnableCarData(index, OC_NUMBER),
        sell_price
    );

    return Dialog(playerid, DIALOG_CAR_GUI_MAIN, DIALOG_STYLE_TABLIST_HEADERS, title, text, "Выбрать", "Закрыть");
}

stock CarGUI_ShowInsuranceMenu(playerid)
{
    new vehicleid = CarGUI_GetPlayerVehicle(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new text[512];
    new price_7 = UVM_GetInsurancePrice(modelid, 7);
    new price_14 = UVM_GetInsurancePrice(modelid, 14);
    new price_30 = UVM_GetInsurancePrice(modelid, 30);

    format
    (
        text, sizeof text,
        "Срок\tСтоимость\n"\
        "7 дней\t%d руб\n"\
        "14 дней\t%d руб\n"\
        "30 дней\t%d руб",
        price_7,
        price_14,
        price_30
    );

    return Dialog(playerid, DIALOG_CAR_GUI_INSURANCE, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Страховка транспорта", text, "Купить", "Назад");
}

stock CarGUI_ShowRepairConfirm(playerid)
{
    new vehicleid = CarGUI_GetPlayerVehicle(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new wear = g_uvm_car_wear[vehicleid];

    if(wear <= 0)
    {
        SendClientMessage(playerid, CARGUI_COLOR_INFO, "Технический износ отсутствует. Ремонт не требуется");
        return CarGUI_ShowMain(playerid);
    }

    new price = UVM_GetRepairWearPrice(modelid, wear);
    new text[256];
    format
    (
        text, sizeof text,
        "{FFFFFF}Текущий износ транспорта: {FFCD00}%d%%\n"\
        "{FFFFFF}Стоимость полного восстановления: {66CC33}%d руб\n\n"\
        "{FFCC66}После оплаты технический износ будет сброшен до 0%%.",
        wear,
        price
    );

    return Dialog(playerid, DIALOG_CAR_GUI_REPAIR_CONFIRM, DIALOG_STYLE_MSGBOX, "{FFCD00}Ремонт износа", text, "Починить", "Назад");
}

stock CarGUI_ShowUnloadConfirm(playerid)
{
    new vehicleid = CarGUI_GetPlayerVehicle(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new text[256];
    format
    (
        text, sizeof text,
        "{FFFFFF}Вы действительно хотите выгрузить личный транспорт с сервера?\n\n"\
        "{CCCCCC}Авто сохранится в базе данных, но исчезнет из мира до следующей загрузки через /car."
    );

    return Dialog(playerid, DIALOG_CAR_GUI_UNLOAD_CONFIRM, DIALOG_STYLE_MSGBOX, "{FFCD00}Выгрузка транспорта", text, "Выгрузить", "Назад");
}

stock CarGUI_ToggleEngine(playerid)
{
    new vehicleid = CarGUI_GetPlayerVehicle(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    if(!IsPlayerInVehicle(playerid, vehicleid) || !IsPlayerDriver(playerid))
    {
        SendClientMessage(playerid, CARGUI_COLOR_ERROR, "Чтобы завести или заглушить двигатель, сядьте за руль своего авто");
        return 1;
    }

    ToggleEngine(playerid);
    return 1;
}

stock CarGUI_AddCarToFamily(playerid)
{
    new vehicleid = CarGUI_GetPlayerVehicle(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    if(GetPlayerRangFamily(playerid) != 5 || GetPlayerIdFamily(playerid) == -1)
    {
        SendClientMessage(playerid, CARGUI_COLOR_ERROR, "Добавлять авто в семью может только лидер семьи");
        return 1;
    }

    new f = GetPlayerIdFamily(playerid);
    new current_cars = GetFamily(f, family_count_veh);
    new max_slots = GetFamily(f, family_slot_veh);

    if(current_cars == max_slots)
    {
        SendClientMessage(playerid, CARGUI_COLOR_ERROR, "В семье нет свободных слотов для транспорта");
        return 1;
    }

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    MoveOwnableCar(playerid, GetOwnableCarData(index, OC_SQL_ID), GetFamily(f, family_database));
    return 1;
}

stock CarGUI_HandleMain(playerid, listitem)
{
    switch(listitem)
    {
        case 0:
        {
            new vehicleid = CarGUI_GetPlayerVehicle(playerid);
            if(vehicleid != INVALID_VEHICLE_ID) UVM_ShowPassport(playerid, vehicleid);
        }
        case 1:
        {
            callcmd::lock(playerid, "");
            CarGUI_ShowMain(playerid);
        }
        case 2:
        {
            CarGUI_ToggleEngine(playerid);
            CarGUI_ShowMain(playerid);
        }
        case 3:
        {
            callcmd::getmycar(playerid, "");
        }
        case 4:
        {
            callcmd::trunk(playerid, "");
        }
        case 5:
        {
            CarGUI_ShowInsuranceMenu(playerid);
        }
        case 6:
        {
            CarGUI_ShowRepairConfirm(playerid);
        }
        case 7:
        {
            RemovePlateFromVehicle(playerid);
            CarGUI_ShowMain(playerid);
        }
        case 8:
        {
            callcmd::park(playerid, "");
            CarGUI_ShowMain(playerid);
        }
        case 9:
        {
            UVM_ShowGovSellDialog(playerid);
        }
        case 10:
        {
            CarGUI_ShowUnloadConfirm(playerid);
        }
        case 11:
        {
            CarGUI_AddCarToFamily(playerid);
        }
    }
    return 1;
}

stock CarGUI_HandleInsurance(playerid, listitem)
{
    new days;

    switch(listitem)
    {
        case 0: days = 7;
        case 1: days = 14;
        case 2: days = 30;
        default: return CarGUI_ShowMain(playerid);
    }

    UVM_BuyInsurance(playerid, days);
    return 1;
}

stock CarGUI_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    switch(dialogid)
    {
        case DIALOG_CAR_GUI_MAIN:
        {
            if(!response) return 1;
            return CarGUI_HandleMain(playerid, listitem);
        }
        case DIALOG_CAR_GUI_INSURANCE:
        {
            if(!response) return CarGUI_ShowMain(playerid);
            return CarGUI_HandleInsurance(playerid, listitem);
        }
        case DIALOG_CAR_GUI_REPAIR_CONFIRM:
        {
            if(!response) return CarGUI_ShowMain(playerid);
            UVM_RepairWear(playerid);
            return 1;
        }
        case DIALOG_CAR_GUI_UNLOAD_CONFIRM:
        {
            if(!response) return CarGUI_ShowMain(playerid);

            if(UnloadPlayerOwnableCar(playerid))
                SendClientMessage(playerid, CARGUI_COLOR_INFO, "Ваш транспорт успешно выгружен с сервера");

            return 1;
        }
    }

    return 0;
}
