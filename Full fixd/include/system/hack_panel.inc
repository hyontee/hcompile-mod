// SAME RUSSIA | HACK PANEL
// Кодировка: Windows-1251 (CP1251).
// Подключение: #include "../include/system/hack_panel.inc"

// ============================================================================
// SAME RUSSIA | HACK PANEL
// ============================================================================
#define DIALOG_SAME_DEV_MAIN      19981
#define DIALOG_SAME_DEV_SKIN      19982
#define DIALOG_SAME_DEV_PLATE     19983
#define DIALOG_SAME_DEV_SPEED     19984
#define DIALOG_SAME_DEV_ACCEL     19985
#define DIALOG_SAME_DEV_GRAVITY   19986

new gSameDevPendingAction[MAX_PLAYERS];
new gSameDevPendingInt[MAX_PLAYERS];
new Float:gSameDevPendingFloat[MAX_PLAYERS];
new gSameDevPendingText[MAX_PLAYERS][32];

stock ShowSameRussiaDevPanel(playerid)
{
    Dialog(playerid, DIALOG_SAME_DEV_MAIN, DIALOG_STYLE_LIST,
        "{E93E0F}SAME RUSSIA {FFFFFF}| Панель разработчика",
        "{E93E0F}1. {FFFFFF}Получить 1.000.000 BC\n\
{E93E0F}2. {FFFFFF}Получить 100.000.000 рублей\n\
{E93E0F}3. {FFFFFF}Получить 100 донат кейсов\n\
{E93E0F}4. {FFFFFF}Изменить свой скин\n\
{E93E0F}5. {FFFFFF}Изменить номер на машине\n\
{E93E0F}6. {FFFFFF}Изменить максимальную скорость\n\
{E93E0F}7. {FFFFFF}Изменить ускорение машины\n\
{E93E0F}8. {FFFFFF}Изменить гравитацию сервера",
        "Выбрать", "Закрыть");
    return 1;
}

stock SameDevStartProgress(playerid, action)
{
    gSameDevPendingAction[playerid] = action;
    ShowNotificationLaird(playerid, 3, 2, 0, 0, "Обработка запроса...", " ");
    SetTimerEx("SameDevCompleteAction", 1200, false, "i", playerid);
    return 1;
}

forward SameDevCompleteAction(playerid);
public SameDevCompleteAction(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new action = gSameDevPendingAction[playerid];
    gSameDevPendingAction[playerid] = 0;

    new notify_text[144];
    notify_text[0] = EOS;

    switch(action)
    {
        case 1:
        {
            GivePlayerDonateRub(playerid, 1000000, "SAME RUSSIA HACK PANEL", true, false);
            SetPVarInt(playerid, "player_black_coin",
                GetPVarInt(playerid, "player_black_coin") + 1000000);
            SavePlayerAccount(playerid);

            format(notify_text, sizeof notify_text,
                "Вы успешно получили 1.000.000 BC");
        }
        case 2:
        {
            GivePlayerMoneyEx(playerid, 100000000,
                "SAME RUSSIA HACK PANEL", true, true);

            format(notify_text, sizeof notify_text,
                "Вы успешно получили 100.000.000 рублей");
        }
        case 3:
        {
            AddPlayerData(playerid, P_DONATE_CASE, +, 100);

            format(notify_text, sizeof notify_text,
                "Вы успешно получили 100 донат кейсов");
        }
        case 4:
        {
            new skin = gSameDevPendingInt[playerid];

            if(skin >= 0)
            {
                SetPlayerSkin(playerid, skin);
                SetPlayerData(playerid, P_SKIN, skin);
                UpdatePlayerDatabaseInt(playerid, "skin", skin);

                format(notify_text, sizeof notify_text,
                    "Ваш скин успешно изменен на ID %d", skin);
            }
            else
            {
                format(notify_text, sizeof notify_text,
                    "Некорректный ID скина");
            }
        }
        case 5:
        {
            new vehicleid = GetPlayerVehicleID(playerid);

            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                SetVehicleNumberPlateEx(vehicleid, TYPE_RU,
                    gSameDevPendingText[playerid], "");

                if(GetVehicleData(vehicleid, V_ACTION_TYPE) ==
                    VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                {
                    new car_index = GetVehicleData(vehicleid, V_ACTION_ID);

                    if(0 <= car_index < MAX_OWNABLE_CARS)
                    {
                        format(g_ownable_car[car_index][OC_NUMBER], 32, "%s",
                            gSameDevPendingText[playerid]);

                        new q[160];
                        mysql_format(mysql, q, sizeof q,
                            "UPDATE ownable_cars SET number=\'%e\' WHERE id=%d LIMIT 1",
                            gSameDevPendingText[playerid],
                            GetOwnableCarData(car_index, OC_SQL_ID));

                        mysql_query(mysql, q, false);
                    }
                }

                format(notify_text, sizeof notify_text,
                    "Номер вашей машины успешно изменен");
            }
            else
            {
                format(notify_text, sizeof notify_text,
                    "Сначала сядьте в транспорт");
            }
        }
        case 6:
        {
            new vehicleid = GetPlayerVehicleID(playerid);

            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                SetVehicleMaxSpeed(vehicleid, gSameDevPendingFloat[playerid]);
                SetVehicleMaxSpeedd(vehicleid, gSameDevPendingFloat[playerid]);

                foreach(new i : Player)
                {
                    if(IsPlayerConnected(i))
                    {
                        SetVehicleMaxSpeedForPlayer(i, vehicleid,
                            gSameDevPendingFloat[playerid]);
                    }
                }

                format(notify_text, sizeof notify_text,
                    "Максимальная скорость автомобиля изменена");
            }
            else
            {
                format(notify_text, sizeof notify_text,
                    "Сначала сядьте в транспорт");
            }
        }
        case 7:
        {
            new vehicleid = GetPlayerVehicleID(playerid);

            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                SetVehicleAcceleration(vehicleid,
                    gSameDevPendingFloat[playerid]);
                SetVehicleAccelerations(vehicleid,
                    gSameDevPendingFloat[playerid], 0);

                format(notify_text, sizeof notify_text,
                    "Ускорение автомобиля успешно изменено");
            }
            else
            {
                format(notify_text, sizeof notify_text,
                    "Сначала сядьте в транспорт");
            }
        }
        case 8:
        {
            SetGravity(gSameDevPendingFloat[playerid]);

            format(notify_text, sizeof notify_text,
                "Гравитация успешно изменена на %.4f",
                gSameDevPendingFloat[playerid]);
        }
    }

    if(!strlen(notify_text))
    {
        format(notify_text, sizeof notify_text,
            "Действие успешно выполнено");
    }

    ShowNotificationLaird(playerid, 3, 7, 0, 0, notify_text, "SAME RUSSIA");
    return 1;
}

stock SameDevHandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_SAME_DEV_MAIN)
    {
        if(!response) return 1;

        switch(listitem)
        {
            case 0: return SameDevStartProgress(playerid, 1);
            case 1: return SameDevStartProgress(playerid, 2);
            case 2: return SameDevStartProgress(playerid, 3);

            case 3:
            {
                return Dialog(playerid, DIALOG_SAME_DEV_SKIN,
                    DIALOG_STYLE_INPUT,
                    "{E93E0F}SAME RUSSIA {FFFFFF}| Изменение скина",
                    "{FFD54F}Введите ID скина{FFFFFF}\nВведите корректный ID модели персонажа.\n\n{BDBDBD}После подтверждения ваш скин будет изменен автоматически.",
                    "Изменить", "Назад"), 1;
            }

            case 4:
            {
                return Dialog(playerid, DIALOG_SAME_DEV_PLATE,
                    DIALOG_STYLE_INPUT,
                    "{E93E0F}SAME RUSSIA {FFFFFF}| Номер автомобиля",
                    "{FFD54F}Новый номер машины{FFFFFF}\nВведите номер длиной от 1 до 15 символов.\n\n{BDBDBD}Автомобиль должен быть загружен и находиться рядом с вами.",
                    "Изменить", "Назад"), 1;
            }

            case 5:
            {
                return Dialog(playerid, DIALOG_SAME_DEV_SPEED,
                    DIALOG_STYLE_INPUT,
                    "{E93E0F}SAME RUSSIA {FFFFFF}| Скорость автомобиля",
                    "{FFD54F}Максимальная скорость{FFFFFF}\nВведите значение от {FFD54F}50{FFFFFF} до {FFD54F}500{FFFFFF}.\n\n{BDBDBD}Изменение применяется к текущему автомобилю.",
                    "Изменить", "Назад"), 1;
            }

            case 6:
            {
                return Dialog(playerid, DIALOG_SAME_DEV_ACCEL,
                    DIALOG_STYLE_INPUT,
                    "{E93E0F}SAME RUSSIA {FFFFFF}| Ускорение автомобиля",
                    "{FFD54F}Увеличение ускорения{FFFFFF}\nВведите значение от {FFD54F}0.1{FFFFFF} до {FFD54F}10.0{FFFFFF}.\n\n{BDBDBD}Изменение применяется к текущему автомобилю.",
                    "Изменить", "Назад"), 1;
            }

            case 7:
            {
                return Dialog(playerid, DIALOG_SAME_DEV_GRAVITY,
                    DIALOG_STYLE_INPUT,
                    "{E93E0F}SAME RUSSIA {FFFFFF}| Гравитация",
                    "{FFD54F}Гравитация мира{FFFFFF}\nВведите значение от {FFD54F}0.001{FFFFFF} до {FFD54F}0.050{FFFFFF}.\n\n{BDBDBD}Стандартное значение SA-MP равно 0.008.",
                    "Изменить", "Назад"), 1;
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_SAME_DEV_SKIN)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);
        if(!strlen(inputtext)) return 1;

        new value = strval(inputtext);

        if(value < 0)
        {
            ShowNotificationLaird(playerid, 2, 4, 0, 0,
                "Введите корректный ID скина", " ");
            return 1;
        }

        gSameDevPendingInt[playerid] = value;
        return SameDevStartProgress(playerid, 4);
    }

    if(dialogid == DIALOG_SAME_DEV_PLATE)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);

        if(strlen(inputtext) < 1 || strlen(inputtext) > 15)
        {
            ShowNotificationLaird(playerid, 2, 4, 0, 0,
                "Длина номера должна быть от 1 до 15 символов", " ");
            return 1;
        }

        format(gSameDevPendingText[playerid], 32, "%s", inputtext);
        return SameDevStartProgress(playerid, 5);
    }

    if(dialogid == DIALOG_SAME_DEV_SPEED)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);

        new Float:v = floatstr(inputtext);

        if(v < 50.0 || v > 500.0)
        {
            ShowNotificationLaird(playerid, 2, 4, 0, 0,
                "Введите скорость от 50 до 500", " ");
            return 1;
        }

        gSameDevPendingFloat[playerid] = v;
        return SameDevStartProgress(playerid, 6);
    }

    if(dialogid == DIALOG_SAME_DEV_ACCEL)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);

        new Float:v = floatstr(inputtext);

        if(v < 0.1 || v > 10.0)
        {
            ShowNotificationLaird(playerid, 2, 4, 0, 0,
                "Введите значение от 0.1 до 10.0", " ");
            return 1;
        }

        gSameDevPendingFloat[playerid] = v;
        return SameDevStartProgress(playerid, 7);
    }

    if(dialogid == DIALOG_SAME_DEV_GRAVITY)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);

        new Float:v = floatstr(inputtext);

        if(v < 0.001 || v > 0.050)
        {
            ShowNotificationLaird(playerid, 2, 4, 0, 0,
                "Введите значение от 0.001 до 0.050", " ");
            return 1;
        }

        gSameDevPendingFloat[playerid] = v;
        return SameDevStartProgress(playerid, 8);
    }

    return 0;
}

CMD:hack(playerid, params[])
{
    #pragma unused params

    if(GetPlayerAdminEx(playerid) < 14 ||
        !GetPlayerData(playerid, P_ADMIN_LOGGED))
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0,
            "У вас нет доступа к этой команде", " ");
        return 1;
    }

    return ShowSameRussiaDevPanel(playerid);
}
