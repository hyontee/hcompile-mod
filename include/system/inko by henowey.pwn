enum E_INKO_DATA {
    bool:iJob,
    iVehID,
    bool:iOrder,
    bool:iUniform
}
new InkoData[MAX_PLAYERS][E_INKO_DATA];

enum {
    DIALOG_INKOINFO = 8000,
    DIALOG_INKOPOTVERUS,
    DIALOG_INKOPOTVERUVOL,
    DIALOG_INKOCAR,
    DIALOG_INKOZAKAZ,
    DIALOG_INKOINFO_HELP
}

case DIALOG_INKOZAKAZ:
{
    if(!response) return 1;
    if(listitem == 0)
    {
        SetPVarInt(playerid, "InkoZakaz", 1);
        InkoData[playerid][iOrder] = true;
        SetPlayerCheckpoint(playerid, 1396.454589, 463.345428, 13.155214, 1.0);
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно взяли заказ!");
    }
}
case DIALOG_INKOCAR:
{
    if(!response) return 1;
    if(listitem == 0)
    {
        if(InkoData[playerid][iVehID] != 0) 
        {
            DestroyVehicle(InkoData[playerid][iVehID]);
        }
        
        InkoData[playerid][iVehID] = CreateVehicle(428, 1858.457275, 2009.823974, 15.847534, 12.165230, 3, 3, -1);
        PutPlayerInVehicle(playerid, InkoData[playerid][iVehID], 0);
        
        SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно арендовали машину!");
        SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Для просмотра заказов введите /clist");
        return 1;
    }
}
case DIALOG_INKOINFO:
{
    if(!response) return 1;
    switch(listitem)
    {
        case 0:
        {
            SPD(playerid, DIALOG_INKOINFO_HELP, DIALOG_STYLE_MSGBOX, "Информация о работе", 
            "Работа инкассатора – очень ответственная и важная работа,\nПоэтому она доступна только с {ffff00}15{FFFFFF} уровня\n\
            Вам предстоит развозить денежные средства от одного банка к другому\n\
            Поскольку данная работа довольно опасная, платить вам будут неплохие деньги!\n\n\
            {FFDC33}Руководство:\n{ffff00}/clist {ffffff}– просмотреть список доступных заказов\n\
            Желаем Вам приятной игры на {ffff00}"SERVER_NAME"!", "ОК", "");
        }
        case 1:
        {
            if(vodous[playerid] == 1)
            {
                return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы устроены на работу водолаза!");
            } 
            
            if(!InkoData[playerid][iJob])
            {
                SPD(playerid, DIALOG_INKOPOTVERUS, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Устройство на работу инкассатора", "Вы действительно хотите устроиться на работу инкассатора?", "Да", "Нет");
            }
            else
            {
                SPD(playerid, DIALOG_INKOPOTVERUVOL, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Увольнение с работы инкассатора", "Вы действительно хотите уволиться с работы инкассатора?", "Да", "Нет");
            }
        }
        case 2:
        {
            if(!InkoData[playerid][iJob])
                return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы не устроены на работу");
                
            if(InkoData[playerid][iOrder])
                return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" У вас есть действующий заказ! Сначала завершите его.");
                
            if(!InkoData[playerid][iUniform])
            {
                SetPlayerSkin(playerid, 83);
                InkoData[playerid][iUniform] = true;
                SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно переоделись в рабочую форму");
            }
            else
            {
                SetPlayerSkin(playerid, g_player[playerid][P_SKIN]);
                InkoData[playerid][iUniform] = false;
                SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно переоделись в свою одежду");
            }
        }
    }
}
case DIALOG_INKOPOTVERUS:
{
    if(response)
    {
        InkoData[playerid][iJob] = true;
        SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно устроились на работу инкассатора!");
        SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Подойдите к Стажеру Илье, чтобы взять транспорт!");
    }
}
case DIALOG_INKOPOTVERUVOL:
{
    if(response)
    {
        InkoData[playerid][iJob] = false;
        InkoData[playerid][iUniform] = false;
        InkoData[playerid][iOrder] = false;
        
        if(InkoData[playerid][iVehID] != 0)
        {
            DestroyVehicle(InkoData[playerid][iVehID]);
            InkoData[playerid][iVehID] = 0;
        }
        
        SetPlayerSkin(playerid, g_player[playerid][P_SKIN]);
        DisablePlayerCheckpoint(playerid);
        SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно уволились с работы инкассатора!");
    }
}

CMD:inkinfo(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 2892.941406, 2491.156738, 1051.000000))
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться возле Михалыча!");
        
    if(GetPlayerLevel(playerid) < 15) 
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" У вас уровень ниже 15!");

    SPD(playerid, DIALOG_INKOINFO, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Михалыч", 
        ""c_white"Информация о работе\nУстроиться на работу/Уволиться с работы\nПереодеться в форму", 
        "Выбрать", "Закрыть");
        
    return 1;
}

CMD:inkcar(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1864.171997, 2018.821411, 16.511747))
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться возле Ильи!");
        
    if(!InkoData[playerid][iJob])
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы не устроены на работу инкассатора!");

    SPD(playerid, DIALOG_INKOCAR, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Получение транспорта", ""c_white"1. Газель", "Выбрать", "Закрыть");
    return 1;
}

CMD:clist(playerid)
{
    if(!InkoData[playerid][iJob])
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны устроиться, прежде чем брать заказ!");
        
    if(InkoData[playerid][iVehID] == 0 || GetPlayerVehicleID(playerid) != InkoData[playerid][iVehID])
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы должны находиться в своей инкассаторской машине!");
        
    if(InkoData[playerid][iOrder])
        return SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы не можете взять заказ, т.к. у вас уже имеется действующий заказ!");

    SPD(playerid, DIALOG_INKOZAKAZ, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Получение транспорта", ""c_white"1. Тестовый заказ", "Выбрать", "Закрыть");
    return 1;
}

if(GetPVarInt(playerid, "InkoZakaz") == 1)
{
    DisablePlayerCheckpoint(playerid);
    DeletePVar(playerid, "InkoZakaz");
    
    SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно забрали заказ!");
    SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Отправляйтесь в банк, чтобы закончить заказ!");
    
    SetPVarInt(playerid, "InkoZakazEnd", 1);
    SetPlayerCheckpoint(playerid, 2888.706542, 2484.422607, 1051.000000, 1.0);
    return 1;
}

if(GetPVarInt(playerid, "InkoZakazEnd") == 1)
{
    DisablePlayerCheckpoint(playerid);
    DeletePVar(playerid, "InkoZakazEnd");
    
    SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Вы успешно закончили заказ!");
    SCM(playerid, COLOR_WHITE, ""c_yellow"[Уведомление]"c_white" Введите /clist для того чтобы взять новый!");
    
    GivePlayerMoneyEx(playerid, 16000);
    InkoData[playerid][iOrder] = false; 
    return 1;
}

if(InkoData[playerid][iVehID] != 0) 
{
    DestroyVehicle(InkoData[playerid][iVehID]);
}

InkoData[playerid][iJob] = false;
InkoData[playerid][iVehID] = 0;
InkoData[playerid][iOrder] = false;
InkoData[playerid][iUniform] = false;
