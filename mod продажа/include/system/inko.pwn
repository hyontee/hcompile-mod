// ==========================================
// СИСТЕМА ИНКАССАТОРА - ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ
// ==========================================

#if defined _inkosystem_included
    #endinput
#endif
#define _inkosystem_included

// ========== КОНСТАНТЫ ==========
#define DIALOG_INKOINFO         8600
#define DIALOG_INKOPOTVERUS     8601
#define DIALOG_INKOPOTVERUVOL   8602
#define DIALOG_INKOCAR          8603
#define DIALOG_INKOZAKAZ        8604

// ========== ПЕРЕМЕННЫЕ ==========
static Inko_ZoneMihalich;
static Inko_ZoneIlya;

// ========== ИНИЦИАЛИЗАЦИЯ ==========
stock Inko_Init()
{
    Inko_ZoneMihalich = CreateDynamicSphere(2892.941406, 2491.156738, 1051.000000, 2.0);
    Inko_ZoneIlya = CreateDynamicSphere(1864.171997, 2018.821411, 16.511747, 2.0);
    return 1;
}

// ========== ОБРАБОТЧИК ЗОН ==========
stock Inko_OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == Inko_ZoneMihalich)
    {
        if(GetPlayerLevel(playerid) < 15) 
            return SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} У вас уровень ниже 15!");
        
        new str[128];
        format(str, sizeof(str), 
            "{ffffff}Информация о работе\n\
            Устроиться на работу/Уволиться с работы\n\
            Переодеться в форму"
        );
        ShowPlayerDialog(playerid, DIALOG_INKOINFO, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Михалыч", str, "Выбрать", "Закрыть");
        return 1;
    }
    if(areaid == Inko_ZoneIlya)
    {
        if(GetPlayerData(playerid, P_INKO_JOB) == 0)
            return SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы не устроены на работу инкассатора!");
        
        ShowPlayerDialog(playerid, DIALOG_INKOCAR, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Получение транспорта", "1. Газель", "Выбрать", "Закрыть");
        return 1;
    }
    return 0;
}

// ========== ОБРАБОТЧИК ДИАЛОГОВ ==========
stock Inko_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_INKOINFO)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(GetPlayerData(playerid, P_INKO_JOB) == 0)
                    {
                        ShowPlayerDialog(playerid, DIALOG_INKOPOTVERUS, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Устройство на работу", "Вы действительно хотите устроиться на работу инкассатора?", "Да", "Нет");
                    }
                    else
                    {
                        ShowPlayerDialog(playerid, DIALOG_INKOPOTVERUVOL, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Увольнение", "Вы действительно хотите уволиться с работы инкассатора?", "Да", "Нет");
                    }
                }
                case 1:
                {
                    if(GetPlayerData(playerid, P_INKO_JOB) == 0)
                    {
                        SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы не устроены на работу");
                    }
                    else
                    {
                        if(GetPlayerData(playerid, P_INKO_ZAKAZ) == 1)
                        {
                            SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} У вас есть действующий заказ!");
                        }
                        else
                        {
                            if(GetPlayerData(playerid, P_INKO_SKIN) == 1)
                            {
                                SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
                                SetPlayerData(playerid, P_INKO_SKIN, 0);
                                SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно переоделись в свою одежду");
                            }
                            else
                            {
                                SetPlayerSkin(playerid, 83);
                                SetPlayerData(playerid, P_INKO_SKIN, 1);
                                SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно переоделись в рабочую форму");
                            }
                        }
                    }
                }
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_INKOPOTVERUS)
    {
        if(response)
        {
            SetPlayerData(playerid, P_INKO_JOB, 1);
            SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно устроились на работу инкассатора!");
            SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Подойдите к Стажеру Илье чтобы взять транспорт!");
        }
        return 1;
    }
    if(dialogid == DIALOG_INKOPOTVERUVOL)
    {
        if(response)
        {
            SetPlayerData(playerid, P_INKO_JOB, 0);
            SetPlayerData(playerid, P_INKO_SKIN, 0);
            SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
            SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно уволились с работы инкассатора!");
        }
        return 1;
    }
    if(dialogid == DIALOG_INKOCAR)
    {
        if(response)
        {
            new veh = CreateVehicle(428, 1858.457275, 2009.823974, 15.847534, 12.165230, 3, 3, -1);
            SetPlayerData(playerid, P_INKO_CAR, veh);
            SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно арендовали машину!");
            SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Для просмотра заказов введите /inkolist");
        }
        return 1;
    }
    if(dialogid == DIALOG_INKOZAKAZ)
    {
        if(response)
        {
            SetPVarInt(playerid, "InkoZakaz", 1);
            SetPlayerData(playerid, P_INKO_ZAKAZ, 1);
            SetPlayerCheckpoint(playerid, 1396.454589, 463.345428, 13.155214, 1.0);
            SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно взяли заказ!");
        }
        return 1;
    }
    return 0;
}

// ========== ОБРАБОТЧИК ЧЕКПОИНТОВ ==========
stock Inko_OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "InkoZakaz") == 1)
    {
        DisablePlayerCheckpoint(playerid);
        DeletePVar(playerid, "InkoZakaz");
        SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно забрали заказ!");
        SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Отправляйтесь в банк для того чтобы закончить заказ!");
        SetPVarInt(playerid, "InkoZakazEnd", 1);
        SetPlayerCheckpoint(playerid, 2888.706542, 2484.422607, 1051.000000, 1.0);
        return 1;
    }
    if(GetPVarInt(playerid, "InkoZakazEnd") == 1)
    {
        DisablePlayerCheckpoint(playerid);
        DeletePVar(playerid, "InkoZakazEnd");
        SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы успешно закончили заказ!");
        SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Введите /inkolist для того чтобы взять новый!");
        GivePlayerMoneyEx(playerid, 16000);
        SetPlayerData(playerid, P_INKO_ZAKAZ, 0);
        return 1;
    }
    return 0;
}

// ========== ОБРАБОТЧИК ОТКЛЮЧЕНИЯ ==========
stock Inko_OnPlayerDisconnect(playerid)
{
    SetPlayerData(playerid, P_INKO_CAR, 0);
    SetPlayerData(playerid, P_INKO_ZAKAZ, 0);
    SetPlayerData(playerid, P_INKO_SKIN, 0);
    return 1;
}

// ========== КОМАНДЫ ==========
CMD:inkinfo(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 5.0, 2892.941406, 2491.156738, 1051.000000))
    {
        if(GetPlayerLevel(playerid) < 15) 
            return SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} У вас уровень ниже 15!");
        
        new str[128];
        format(str, sizeof(str), 
            "{ffffff}Информация о работе\n\
            Устроиться на работу/Уволиться с работы\n\
            Переодеться в форму"
        );
        ShowPlayerDialog(playerid, DIALOG_INKOINFO, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Михалыч", str, "Выбрать", "Закрыть");
    }
    else SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы должны находиться возле Михалыча!");
    return 1;
}

CMD:inkcar(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1864.171997, 2018.821411, 16.511747))
    {
        if(GetPlayerData(playerid, P_INKO_JOB) == 0)
            return SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы не устроены на работу инкассатора!");
        
        ShowPlayerDialog(playerid, DIALOG_INKOCAR, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Получение транспорта", "1. Газель", "Выбрать", "Закрыть");
    }
    else SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы должны находиться возле Ильи!");
    return 1;
}

CMD:inkolist(playerid)
{
    if(GetPlayerData(playerid, P_INKO_JOB) == 1)
    {
        if(GetPlayerData(playerid, P_INKO_CAR) != 0)
        {
            if(GetPlayerData(playerid, P_INKO_ZAKAZ) == 1)
            {
                SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} У вас есть действующий заказ!");
            }
            else
            {
                ShowPlayerDialog(playerid, DIALOG_INKOZAKAZ, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Список заказов", "1. Тестовый заказ", "Выбрать", "Закрыть");
            }
        }
        else SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы должны получить машину у Ильи!");
    }
    else SendClientMessage(playerid, -1, "{ffff00}[Уведомление]{ffffff} Вы должны устроиться прежде чем брать заказ!");
    return 1;
}

// ========== КОНЕЦ ==========