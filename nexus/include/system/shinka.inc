#if !defined RACE_SHINKA_CENTER
#define RACE_SHINKA_CENTER

// ===================== Типы покупаемых улучшений =====================
#define SHINKA_ITEM_HYDRAULICS     0
#define SHINKA_ITEM_PNEVMO         1
// Место для новых улучшений: добавляй новый #define и обрабатывай ниже
// в GetShinkaItemPrice / GetShinkaItemBought / ShinkaGUI_ApplyPurchase

stock GetShinkaItemPrice(itemid)
{
    switch(itemid)
    {
        case SHINKA_ITEM_HYDRAULICS: return 50000;
        case SHINKA_ITEM_PNEVMO:     return 30000;
    }
    return -1; // -1 = неизвестный итем
}

// Возвращает 1, если апгрейд уже куплен на этой машине
stock bool:GetShinkaItemBought(vehicleid, itemid)
{
    switch(itemid)
    {
        case SHINKA_ITEM_HYDRAULICS: return bool:(vInfo[vehicleid][viHydraulics] == 1);
        case SHINKA_ITEM_PNEVMO:     return bool:(vPneumoBought[vehicleid] == 1);
    }
    return false;
}

// Применяет покупку (выставляет флаги на машине). Вызывать ТОЛЬКО после списания денег.
stock ShinkaGUI_ApplyPurchase(vehicleid, itemid)
{
    switch(itemid)
    {
        case SHINKA_ITEM_HYDRAULICS: vInfo[vehicleid][viHydraulics] = 1;
        case SHINKA_ITEM_PNEVMO:     vPneumoBought[vehicleid] = 1;
    }
    // TODO: если апгрейды хранятся отдельно в БД (не вместе с общим сохранением машины),
    // добавь тут вызов своей функции сохранения, например:
    // Race_SaveVehicleUpgrade(vehicleid, itemid);
    return 1;
}

stock ShowRaceShinkaGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
        return RaceNotifyError(playerid, "Вы должны быть в машине!");

    if(Race_GetOwnedVehicleIndex(playerid, vehicleid) == -1)
        return RaceNotifyError(playerid, "Это не ваш личный транспорт!");

    new price = Race_GetVehiclePrice(vehicleid);
    new name[64];
    Race_GetVehicleName(vehicleid, name, sizeof(name));

    InStailing[playerid] = false;
    RaceStyle_SaveReturn(playerid, vehicleid);
    RaceStyleCenterType[playerid] = 2;

    new Node:tuning_json = JSON_Object();
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 2);
    JSON_SetInt(tuning_json, "t", 2);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    JSON_SetFloat(tuning_json, "wh_rad", float(vInfo[vehicleid][vWheelSize]));
    JSON_SetFloat(tuning_json, "wh_wf", float(vInfo[vehicleid][vWheelAddFront]));
    JSON_SetFloat(tuning_json, "wh_wr", float(vInfo[vehicleid][vWheelAddRear]));
    JSON_SetFloat(tuning_json, "wh_of", float(vWheelDepartureFront[vehicleid]));
    JSON_SetFloat(tuning_json, "wh_or", float(vWheelDepartureRear[vehicleid]));
    JSON_SetFloat(tuning_json, "wh_cf", float(vWheelAlignmentFront[vehicleid]));
    JSON_SetFloat(tuning_json, "wh_cr", float(vWheelAlignmentRear[vehicleid]));
    JSON_SetFloat(tuning_json, "wh_clr", float(vInfo[vehicleid][vSuspensionForce]));

    // Состояние апгрейдов (куплено/нет)
    JSON_SetInt(tuning_json, "hydra", vInfo[vehicleid][viHydraulics]);
    JSON_SetInt(tuning_json, "pnevmo", vPneumoBought[vehicleid]);

    // Цены на апгрейды — чтобы клиент мог показать актуальную стоимость в GUI
    JSON_SetInt(tuning_json, "hydra_price", GetShinkaItemPrice(SHINKA_ITEM_HYDRAULICS));
    JSON_SetInt(tuning_json, "pnevmo_price", GetShinkaItemPrice(SHINKA_ITEM_PNEVMO));

    new vw = playerid + 1000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    LinkVehicleToInterior(vehicleid, 1);
    SetPlayerInterior(playerid, 1);
    RaceStyle_SetOccupantsEnvironment(vehicleid, vw, 1);
    // The LAST(3) wheel-center camera is near Y=1000.
    // The old port placed the vehicle at Y=1499, leaving it far outside the camera view.
    SetVehiclePos(vehicleid, 995.7154, 1000.5235, 1500.1683);
    SetVehicleZAngle(vehicleid, 180.0);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    TogglePlayerControllable(playerid, false);
    SetPlayerCameraPos(playerid, 999.1838, 995.9953, 1501.7263);
    SetPlayerCameraLookAt(playerid, 998.5103, 996.7333, 1501.5776);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

CMD:shinka(playerid, params[])
{
    return ShowRaceShinkaGUI(playerid);
}

// ===================== Покупка апгрейда =====================
// Вызывай эту функцию из своего обработчика ответа GUI (там, где ловится клик "купить"
// для guiid 28 / RaceStyleCenterType == 2). itemid — SHINKA_ITEM_HYDRAULICS / SHINKA_ITEM_PNEVMO и т.д.
//
// Если у тебя обработка кликов идёт через отдельный колбэк вида
// OnPlayerGUIResponse(playerid, guiid, Node:json) — просто вызови там:
//     if(guiid == 28 && RaceStyleCenterType[playerid] == 2)
//     {
//         new itemid = JSON_GetInt(json, "buy"); // подставь реальное имя поля, которое шлёт клиент
//         ShinkaGUI_BuyItem(playerid, itemid);
//     }
stock ShinkaGUI_BuyItem(playerid, itemid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
        return RaceNotifyError(playerid, "Вы должны быть в машине!");

    if(Race_GetOwnedVehicleIndex(playerid, vehicleid) == -1)
        return RaceNotifyError(playerid, "Это не ваш личный транспорт!");

    new price = GetShinkaItemPrice(itemid);
    if(price == -1)
        return RaceNotifyError(playerid, "Неизвестное улучшение!");

    if(GetShinkaItemBought(vehicleid, itemid))
        return RaceNotifyError(playerid, "Это улучшение уже куплено на этой машине!");

    if(GetPlayerMoneyEx(playerid) < price)
        return RaceNotifyError(playerid, "Недостаточно денег!");

    GivePlayerMoneyEx(playerid, -price);
    ShinkaGUI_ApplyPurchase(vehicleid, itemid);

    // Обновляем GUI, чтобы клиент увидел новый баланс и статус "куплено"
    ShowRaceShinkaGUI(playerid);
    return 1;
}

// Отдельные команды для теста без ожидания правки клиентского GUI-обработчика
CMD:buyhydra(playerid, params[])
{
    return ShinkaGUI_BuyItem(playerid, SHINKA_ITEM_HYDRAULICS);
}

CMD:buypnevmo(playerid, params[])
{
    return ShinkaGUI_BuyItem(playerid, SHINKA_ITEM_PNEVMO);
}

stock GetShinaPrice(price, type)
{
    switch(type)
    {
        case 0: return (price / 200) + 5000;
        case 1: return (price / 200) + 8000;
        case 2: return (price / 200) + 7000;
        case 3: return (price / 200) + 6000;
        case 4: return (price / 150) + 10000;
        case 5: return (price / 100) + 50000;
        case 6: return (price / 100) + 80000;
    }
    return 1000;
}

#endif
