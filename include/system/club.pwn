#include <a_samp>
#include <streamer>
#include <icmd>

// ==============================================
// СИСТЕМА НОЧНОГО КЛУБА MOON CLUB
// ==============================================

// Координаты пикапа ВХОДА (СНАРУЖИ)
#define CLUB_ENTER_X 661.314331
#define CLUB_ENTER_Y 262.069122
#define CLUB_ENTER_Z 13.744136

// Координаты ТЕЛЕПОРТА ВНУТРЬ КЛУБА - ТЫ ЗДЕСЬ ПОЯВЛЯЕШЬСЯ!
#define CLUB_IN_X 7.679895
#define CLUB_IN_Y -14.391682
#define CLUB_IN_Z 1511.433227
#define CLUB_IN_ANGLE 266.321746

// Координаты пикапа ВЫХОДА (ВНУТРИ КЛУБА)
#define CLUB_EXIT_X 4.078809
#define CLUB_EXIT_Y -14.073468
#define CLUB_EXIT_Z 1511.426757

// Координаты выхода НА УЛИЦУ
#define CLUB_OUT_X 661.5
#define CLUB_OUT_Y 264.5
#define CLUB_OUT_Z 13.6
#define CLUB_OUT_ANGLE 358.5

// Меню бара
#define CLUB_MENU_X -10.017976
#define CLUB_MENU_Y 13.374330
#define CLUB_MENU_Z 1511.003417

// Продажа котиков
#define CLUB_KOTI_X 8.237821
#define CLUB_KOTI_Y 41.807014
#define CLUB_KOTI_Z 1511.003417

#define CLUB_INT 1
#define CLUB_PRICE 50000

new vhodmoon_pickup;
new exitmoon_pickup;
new clubmenu_pickup;

// ==============================================
// ON GAME MODE INIT
// ==============================================

public OnGameModeInit()
{
    print("[MOON CLUB] Система загружена!");
    
    // 3D тексты
    CreateDynamic3DTextLabel("{ff0000}Ночной клуб\n{ffffff}Вход - 50.000руб", 0xFFFFFFFF, 
        CLUB_ENTER_X, CLUB_ENTER_Y, CLUB_ENTER_Z + 1.5, 5.0, .testlos = 0, .worldid = -1, .interiorid = 0, .playerid = -1, .streamdistance = 100.0);
    
    CreateDynamic3DTextLabel("{ffffff}ВЫХОД", 0xFFFFFFFF, 
        CLUB_EXIT_X, CLUB_EXIT_Y, CLUB_EXIT_Z + 1.0, 5.0, .testlos = 0, .worldid = 1, .interiorid = 1, .playerid = -1, .streamdistance = 100.0);
    
    CreateDynamic3DTextLabel("{ffff00}МЕНЮ БАРА\n{ffffff}/clubmenu", 0xFFFFFFFF, 
        CLUB_MENU_X, CLUB_MENU_Y, CLUB_MENU_Z + 1.0, 5.0, .testlos = 0, .worldid = 1, .interiorid = 1, .playerid = -1, .streamdistance = 100.0);
    
    CreateDynamic3DTextLabel("{00ff00}ПРОДАЖА КОТИКОВ\n{ffffff}/koti", 0xFFFFFFFF, 
        CLUB_KOTI_X, CLUB_KOTI_Y, CLUB_KOTI_Z + 1.0, 5.0, .testlos = 0, .worldid = 1, .interiorid = 1, .playerid = -1, .streamdistance = 100.0);
    
    // Пикапы
    vhodmoon_pickup = CreateDynamicPickup(1273, 23, CLUB_ENTER_X, CLUB_ENTER_Y, CLUB_ENTER_Z, 0, -1, -1, 100.0);
    exitmoon_pickup = CreateDynamicPickup(1273, 23, CLUB_EXIT_X, CLUB_EXIT_Y, CLUB_EXIT_Z, 1, 1, -1, 100.0);
    clubmenu_pickup = CreateDynamicPickup(1239, 23, CLUB_MENU_X, CLUB_MENU_Y, CLUB_MENU_Z, 1, 1, -1, 100.0);
    
    return 1;
}

// ==============================================
// ON PLAYER PICKUP
// ==============================================

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(pickupid == vhodmoon_pickup) // ВХОД
    {
        if(GetPlayerInterior(playerid) == 0)
        {
            if(GetPlayerMoney(playerid) < CLUB_PRICE)
            {
                SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}У вас недостаточно денег! Нужно 50.000руб");
                return 1;
            }
            GivePlayerMoney(playerid, -CLUB_PRICE);
            SendClientMessage(playerid, -1, "{00ffcc}[MOON CLUB] {ffffff}Вы вошли в MOON CLUB и потратили 50,000 руб!");
            SendClientMessage(playerid, -1, "{ffff00}[MOON CLUB] {ffffff}Подождите 3 секунды...");
            TogglePlayerControllable(playerid, 0);
            SetTimerEx("ClubEnterTimer", 3000, false, "i", playerid);
            return 1;
        }
        else
        {
            SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Вы должны быть на улице чтобы войти!");
        }
    }
    
    if(pickupid == exitmoon_pickup) // ВЫХОД
    {
        if(GetPlayerInterior(playerid) == CLUB_INT && GetPlayerVirtualWorld(playerid) == 0)
        {
            SendClientMessage(playerid, -1, "{00ffcc}[MOON CLUB] {ffffff}Вы вышли из MOON CLUB!");
            SetPlayerPos(playerid, CLUB_OUT_X, CLUB_OUT_Y, CLUB_OUT_Z);
            SetPlayerFacingAngle(playerid, CLUB_OUT_ANGLE);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            return 1;
        }
    }
    
    if(pickupid == clubmenu_pickup) // МЕНЮ
    {
        if(GetPlayerInterior(playerid) == CLUB_INT && GetPlayerVirtualWorld(playerid) == 0)
        {
            ShowClubMenu(playerid);
            return 1;
        }
    }
    return 1;
}

// ==============================================
// ТАЙМЕР ВХОДА
// ==============================================

forward ClubEnterTimer(playerid);
public ClubEnterTimer(playerid)
{
    SetPlayerPos(playerid, CLUB_IN_X, CLUB_IN_Y, CLUB_IN_Z);
    SetPlayerFacingAngle(playerid, CLUB_IN_ANGLE);
    SetPlayerInterior(playerid, CLUB_INT);
    SetPlayerVirtualWorld(playerid, 0);
    TogglePlayerControllable(playerid, 1);
    SendClientMessage(playerid, -1, "{00ffcc}[MOON CLUB] {ffffff}Добро пожаловать в MOON CLUB!");
    SendClientMessage(playerid, -1, "{00ffcc}[MOON CLUB] {ffffff}Используйте /exitclub или подойдите к выходу.");
    SendClientMessage(playerid, -1, "{00ffcc}[MOON CLUB] {ffffff}Используйте /clubmenu чтобы открыть меню.");
    return 1;
}

// ==============================================
// МЕНЮ КЛУБА
// ==============================================

stock ShowClubMenu(playerid)
{
    new string[512];
    strcat(string, "1. Лимонад\t\t{00CC00}60 руб\n");
    strcat(string, "2. Пиво\t\t\t{00CC00}100 руб\n");
    strcat(string, "3. Вино\t\t\t{00CC00}200 руб\n");
    strcat(string, "4. Шампанское\t\t{00CC00}270 руб\n");
    strcat(string, "5. Водка\t\t{00CC00}300 руб\n");
    strcat(string, "6. Коньяк\t\t{00CC00}450 руб\n");
    strcat(string, "7. Виски\t\t{00CC00}630 руб\n");
    strcat(string, "8. Абсент\t\t{00CC00}750 руб\n");
    strcat(string, "{CC9900}9. Закуска\t\t{00CC00}50 руб\n");
    strcat(string, "{CC9900}10. Сигара\t\t{00CC00}80 руб");
    
    ShowPlayerDialog(playerid, 5001, DIALOG_STYLE_LIST, "{ffff00}МЕНЮ БАРА", string, "Купить", "Закрыть");
    return 1;
}

// ==============================================
// КОМАНДЫ (icmd)
// ==============================================

command(club, playerid, params[])
{
    #pragma unused params
    if(IsPlayerInRangeOfPoint(playerid, 3.0, CLUB_ENTER_X, CLUB_ENTER_Y, CLUB_ENTER_Z))
    {
        if(GetPlayerInterior(playerid) != 0)
        {
            SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Вы должны быть на улице!");
            return 1;
        }
        if(GetPlayerMoney(playerid) < CLUB_PRICE)
        {
            SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}У вас недостаточно денег! Нужно 50.000руб");
            return 1;
        }
        GivePlayerMoney(playerid, -CLUB_PRICE);
        SendClientMessage(playerid, -1, "{00ffcc}[MOON CLUB] {ffffff}Вы вошли в MOON CLUB и потратили 50,000 руб!");
        SendClientMessage(playerid, -1, "{ffff00}[MOON CLUB] {ffffff}Подождите 3 секунды...");
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("ClubEnterTimer", 3000, false, "i", playerid);
        return 1;
    }
    else
    {
        SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Подойдите ко входу в MOON CLUB!");
    }
    return 1;
}

command(exitclub, playerid, params[])
{
    #pragma unused params
    if(GetPlayerInterior(playerid) == CLUB_INT && GetPlayerVirtualWorld(playerid) == 0)
    {
        SendClientMessage(playerid, -1, "{00ffcc}[MOON CLUB] {ffffff}Вы вышли из MOON CLUB!");
        SetPlayerPos(playerid, CLUB_OUT_X, CLUB_OUT_Y, CLUB_OUT_Z);
        SetPlayerFacingAngle(playerid, CLUB_OUT_ANGLE);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        return 1;
    }
    else
    {
        SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Вы не в клубе!");
    }
    return 1;
}

command(clubmenu, playerid, params[])
{
    #pragma unused params
    if(GetPlayerInterior(playerid) == CLUB_INT && GetPlayerVirtualWorld(playerid) == 0)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, CLUB_MENU_X, CLUB_MENU_Y, CLUB_MENU_Z))
        {
            ShowClubMenu(playerid);
        }
        else
        {
            SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Подойдите к бару!");
        }
    }
    else
    {
        SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Вы не в клубе!");
    }
    return 1;
}

command(koti, playerid, params[])
{
    #pragma unused params
    if(GetPlayerInterior(playerid) == CLUB_INT && GetPlayerVirtualWorld(playerid) == 0)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, CLUB_KOTI_X, CLUB_KOTI_Y, CLUB_KOTI_Z))
        {
            ShowPlayerDialog(playerid, 5002, DIALOG_STYLE_LIST, "{00ff00}ПРОДАЖА КОТИКОВ", 
                "1. Купить котика\t\t{00CC00}10.000 руб\n\
                2. Продать котика\t\t{00CC00}5.000 руб\n\
                3. Информация", 
                "Выбрать", "Закрыть");
        }
        else
        {
            SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Подойдите к продавцу котиков!");
        }
    }
    else
    {
        SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}Вы не в клубе!");
    }
    return 1;
}

command(clubinfo, playerid, params[])
{
    #pragma unused params
    SendClientMessage(playerid, -1, "{00ffcc}=====================================");
    SendClientMessage(playerid, -1, "{ffff00}        MOON CLUB {ffffff}- Элитный ночной клуб");
    SendClientMessage(playerid, -1, "{ffffff}Вход: {ffff00}50.000{ffffff} рублей");
    SendClientMessage(playerid, -1, "{ffffff}Команды:");
    SendClientMessage(playerid, -1, "{ffffff}/club {ffff00}- Войти в клуб (у входа)");
    SendClientMessage(playerid, -1, "{ffffff}/clubmenu {ffff00}- Открыть меню бара");
    SendClientMessage(playerid, -1, "{ffffff}/exitclub {ffff00}- Выйти из клуба");
    SendClientMessage(playerid, -1, "{ffffff}/koti {ffff00}- Продажа котиков");
    SendClientMessage(playerid, -1, "{00ffcc}=====================================");
    return 1;
}

// ==============================================
// ON DIALOG RESPONSE
// ==============================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 5001) // МЕНЮ БАРА
    {
        if(!response) return 1;
        new prices[] = {60, 100, 200, 270, 300, 450, 630, 750, 50, 80};
        new items[10][] = {"Лимонад", "Пиво", "Вино", "Шампанское", "Водка", "Коньяк", "Виски", "Абсент", "Закуска", "Сигара"};
        new isAlcohol[] = {0, 1, 1, 1, 1, 1, 1, 1, 0, 0};
        if(listitem < 0 || listitem > 9) return 1;
        if(GetPlayerMoney(playerid) < prices[listitem])
        {
            SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}У вас недостаточно денег!");
            return 1;
        }
        GivePlayerMoney(playerid, -prices[listitem]);
        new msg[128];
        format(msg, sizeof(msg), "{00ffcc}[МЕНЮ БАРА] {ffffff}Вы купили {ffff00}%s {ffffff}за {00cc00}%d {ffffff}руб.", items[listitem], prices[listitem]);
        SendClientMessage(playerid, -1, msg);
        if(isAlcohol[listitem] == 1)
        {
            new level = GetPlayerDrunkLevel(playerid);
            if(level < 20000) SetPlayerDrunkLevel(playerid, level + 2500);
            SendClientMessage(playerid, -1, "{ffff00}[МЕНЮ БАРА] {ffffff}Вы почувствовали сильное опьянение!");
        }
        else
        {
            SendClientMessage(playerid, -1, "{00ffcc}[МЕНЮ БАРА] {ffffff}Освежающий напиток!");
        }
        return 1;
    }
    
    if(dialogid == 5002) // Продажа котиков
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0:
            {
                if(GetPlayerMoney(playerid) < 10000)
                {
                    SendClientMessage(playerid, -1, "{ff2400}[ОШИБКА] {ffffff}У вас недостаточно денег! Нужно 10.000руб");
                    return 1;
                }
                GivePlayerMoney(playerid, -10000);
                SendClientMessage(playerid, -1, "{00ffcc}[ПРОДАЖА] {ffffff}Вы купили котика за 10.000руб!");
                SendClientMessage(playerid, -1, "{ffff00}[ПРОДАЖА] {ffffff}Мяу! Теперь у вас есть котик!");
                return 1;
            }
            case 1:
            {
                SendClientMessage(playerid, -1, "{00ffcc}[ПРОДАЖА] {ffffff}Вы продали котика за 5.000руб!");
                GivePlayerMoney(playerid, 5000);
                SendClientMessage(playerid, -1, "{ffff00}[ПРОДАЖА] {ffffff}Котик ушел к новому хозяину!");
                return 1;
            }
            case 2:
            {
                SendClientMessage(playerid, -1, "{00ffcc}=====================================");
                SendClientMessage(playerid, -1, "{ffff00}        ПРОДАЖА КОТИКОВ");
                SendClientMessage(playerid, -1, "{ffffff}Купить котика: {00cc00}10.000{ffffff} руб");
                SendClientMessage(playerid, -1, "{ffffff}Продать котика: {00cc00}5.000{ffffff} руб");
                SendClientMessage(playerid, -1, "{00ffcc}=====================================");
                return 1;
            }
        }
        return 1;
    }
    return 0;
}

// ==============================================
// ОБРАБОТКА РАЗЛОГА
// ==============================================

public OnPlayerDisconnect(playerid, reason)
{
    if(GetPlayerInterior(playerid) == CLUB_INT && GetPlayerVirtualWorld(playerid) == 0)
    {
        SetPlayerPos(playerid, CLUB_OUT_X, CLUB_OUT_Y, CLUB_OUT_Z);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }
    return 1;
}