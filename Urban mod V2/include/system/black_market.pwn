#if defined _SILE_BLACK_MARKET_INCLUDED
    #endinput
#endif
#define _SILE_BLACK_MARKET_INCLUDED

// Black market system. Added by ChatGPT.
// Main commands: /bm, /blackmarket, /bmwhere, /bmtp, /bmset.

#define BLACK_MARKET_DIALOG_MAIN      (24780)
#define BLACK_MARKET_DIALOG_CONFIRM   (24781)
#define BLACK_MARKET_SKIN_ID          (103)
#define BLACK_MARKET_RADIUS           (3.0)
#define BLACK_MARKET_MIN_LEVEL        (1)

new BlackMarketActor = -1;
new Text3D:BlackMarketLabel = Text3D:INVALID_3DTEXT_ID;
new BlackMarketArea = -1;
new BlackMarketSelectedItem[MAX_PLAYERS] = {-1, ...};

new Float:BlackMarketPosX = 1989.9656;
new Float:BlackMarketPosY = 700.3188;
new Float:BlackMarketPosZ = 24.2600;
new Float:BlackMarketPosA = 180.0;

#define BLACK_MARKET_ITEMS_COUNT (7)

stock BlackMarket_GetItemName(itemid, dest[], size = sizeof(dest))
{
    switch(itemid)
    {
        case 0: format(dest, size, "Desert Eagle");
        case 1: format(dest, size, "AK-47");
        case 2: format(dest, size, "Shotgun");
        case 3: format(dest, size, "Rifle");
        case 4: format(dest, size, "Armor 100");
        case 5: format(dest, size, "Medical help 100 HP");
        case 6: format(dest, size, "Combat set");
        default: format(dest, size, "Unknown");
    }
    return 1;
}

stock BlackMarket_GetItemPrice(itemid)
{
    switch(itemid)
    {
        case 0: return 150000;
        case 1: return 350000;
        case 2: return 250000;
        case 3: return 300000;
        case 4: return 80000;
        case 5: return 50000;
        case 6: return 520000;
    }
    return 0;
}

stock BlackMarket_GetItemWeapon(itemid)
{
    switch(itemid)
    {
        case 0: return 24;
        case 1: return 30;
        case 2: return 25;
        case 3: return 33;
        case 6: return 30;
    }
    return 0;
}

stock BlackMarket_GetItemAmmo(itemid)
{
    switch(itemid)
    {
        case 0: return 70;
        case 1: return 160;
        case 2: return 60;
        case 3: return 50;
        case 6: return 220;
    }
    return 0;
}

stock Float:BlackMarket_GetItemArmor(itemid)
{
    switch(itemid)
    {
        case 4: return 100.0;
        case 6: return 100.0;
    }
    return 0.0;
}

stock Float:BlackMarket_GetItemHealth(itemid)
{
    switch(itemid)
    {
        case 5: return 100.0;
        case 6: return 100.0;
    }
    return 0.0;
}

stock BlackMarket_CreateWorld()
{
    if(BlackMarketActor != -1 && IsValidActor(BlackMarketActor))
        DestroyActor(BlackMarketActor);

    if(IsValidDynamic3DTextLabel(BlackMarketLabel))
        DestroyDynamic3DTextLabel(BlackMarketLabel);

    if(BlackMarketArea != -1 && IsValidDynamicArea(BlackMarketArea))
        DestroyDynamicArea(BlackMarketArea);

    BlackMarketActor = CreateActor(BLACK_MARKET_SKIN_ID, BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ, BlackMarketPosA);
    if(BlackMarketActor != -1)
    {
        SetActorInvulnerable(BlackMarketActor, true);
        SetActorVirtualWorld(BlackMarketActor, 0);
    }

    BlackMarketLabel = CreateDynamic3DTextLabel("{CC0000}\xd7\xe5\xf0\xed\xfb\xe9\x20\xf0\xfb\xed\xee\xea\n{FFFFFF}\xed\xe0\xe6\xec\xe8\xf2\xe5\x20\x59\x20\xe8\xeb\xe8\x20\x2f\x62\x6d", 0xFFFFFFFF, BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ + 1.15, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    BlackMarketArea = CreateDynamicSphere(BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ, BLACK_MARKET_RADIUS, 0, 0, -1);
    return 1;
}

stock BlackMarket_InitWorld()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
        BlackMarketSelectedItem[i] = -1;

    return BlackMarket_CreateWorld();
}

stock BlackMarket_IsNear(playerid)
{
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0)
        return 0;

    return IsPlayerInRangeOfPoint(playerid, BLACK_MARKET_RADIUS + 0.8, BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ);
}

stock BlackMarket_ShowMenu(playerid)
{
    if(GetPlayerLevel(playerid) < BLACK_MARKET_MIN_LEVEL)
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}\xd7\xe5\xf0\xed\xfb\xe9\x20\xf0\xfb\xed\xee\xea\x20\xe4\xee\xf1\xf2\xf3\xef\xe5\xed\x20\xf1\x20\x31\x20\xf3\xf0\xee\xe2\xed\xff\x2e"), 1;

    if(!BlackMarket_IsNear(playerid))
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}\xc2\xfb\x20\xe4\xe0\xeb\xe5\xea\xee\x20\xee\xf2\x20\xf2\xee\xf0\xe3\xee\xe2\xf6\xe0\x20\xf7\xe5\xf0\xed\xee\xe3\xee\x20\xf0\xfb\xed\xea\xe0\x2e"), 1;

    new bmDialogText[512];
    bmDialogText[0] = EOS;

    strcat(bmDialogText, "{FFFFFF}Desert Eagle\t{66CC00}150000 rub\n");
    strcat(bmDialogText, "{FFFFFF}AK-47\t{66CC00}350000 rub\n");
    strcat(bmDialogText, "{FFFFFF}Shotgun\t{66CC00}250000 rub\n");
    strcat(bmDialogText, "{FFFFFF}Rifle\t{66CC00}300000 rub\n");
    strcat(bmDialogText, "{FFFFFF}Armor 100\t{66CC00}80000 rub\n");
    strcat(bmDialogText, "{FFFFFF}Medical help 100 HP\t{66CC00}50000 rub\n");
    strcat(bmDialogText, "{FFFFFF}Combat set\t{66CC00}520000 rub\n");

    return Dialog(playerid, BLACK_MARKET_DIALOG_MAIN, DIALOG_STYLE_TABLIST, "{CC0000}\xd7\xe5\xf0\xed\xfb\xe9\x20\xf0\xfb\xed\xee\xea", bmDialogText, "\xca\xf3\xef\xe8\xf2\xfc", "\xc7\xe0\xea\xf0\xfb\xf2\xfc");
}

stock BlackMarket_ShowConfirm(playerid, itemid)
{
    if(itemid < 0 || itemid >= BLACK_MARKET_ITEMS_COUNT)
        return 1;

    BlackMarketSelectedItem[playerid] = itemid;

    new bmItemName[32];
    BlackMarket_GetItemName(itemid, bmItemName, sizeof(bmItemName));

    new body[256];
    format(body, sizeof(body),
        "{FFFFFF}\xd2\xee\xe2\xe0\xf0: {FFCC00}%s\n{FFFFFF}\xd6\xe5\xed\xe0: {66CC00}%d rub\n\n{AAAAAA}\xcf\xee\xe4\xf2\xe2\xe5\xf0\xe4\xe8\xf2\xe5\x20\xef\xee\xea\xf3\xef\xea\xf3\x20\xf3\x20\xf2\xee\xf0\xe3\xee\xe2\xf6\xe0\x2e",
        bmItemName,
        BlackMarket_GetItemPrice(itemid)
    );

    return Dialog(playerid, BLACK_MARKET_DIALOG_CONFIRM, DIALOG_STYLE_MSGBOX, "{CC0000}\xcf\xee\xea\xf3\xef\xea\xe0", body, "\xca\xf3\xef\xe8\xf2\xfc", "\xcd\xe0\xe7\xe0\xe4");
}

stock BlackMarket_Buy(playerid, itemid)
{
    if(itemid < 0 || itemid >= BLACK_MARKET_ITEMS_COUNT)
        return 1;

    if(!BlackMarket_IsNear(playerid))
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}\xc2\xfb\x20\xee\xf2\xee\xf8\xeb\xe8\x20\xee\xf2\x20\xf2\xee\xf0\xe3\xee\xe2\xf6\xe0\x20\xf7\xe5\xf0\xed\xee\xe3\xee\x20\xf0\xfb\xed\xea\xe0\x2e"), 1;

    new price = BlackMarket_GetItemPrice(itemid);
    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}\xcd\xe5\xe4\xee\xf1\xf2\xe0\xf2\xee\xf7\xed\xee\x20\xe4\xe5\xed\xe5\xe3\x20\xe4\xeb\xff\x20\xef\xee\xea\xf3\xef\xea\xe8\x2e"), 1;

    GivePlayerMoneyEx(playerid, -price, "Black market", false, true);

    new bmWeapon = BlackMarket_GetItemWeapon(itemid);
    new bmAmmo = BlackMarket_GetItemAmmo(itemid);
    new Float:bmArmor = BlackMarket_GetItemArmor(itemid);
    new Float:bmHealth = BlackMarket_GetItemHealth(itemid);

    if(bmWeapon > 0)
        GivePlayerWeapon(playerid, bmWeapon, bmAmmo);

    if(bmArmor > 0.0)
        SetPlayerArmour(playerid, bmArmor);

    if(bmHealth > 0.0)
        SetPlayerHealth(playerid, bmHealth);

    new bmItemName[32];
    BlackMarket_GetItemName(itemid, bmItemName, sizeof(bmItemName));

    new msg[144];
    format(msg, sizeof(msg), "{66CC00}| {FFFFFF}\xc2\xfb\x20\xea\xf3\xef\xe8\xeb\xe8: {FFCC00}%s{FFFFFF} \xe7\xe0 {66CC00}%d rub", bmItemName, price);
    SendClientMessage(playerid, COLOR_WHITE, msg);
    return 1;
}

stock BlackMarket_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == BLACK_MARKET_DIALOG_MAIN)
    {
        if(!response) return 1;
        return BlackMarket_ShowConfirm(playerid, listitem);
    }

    if(dialogid == BLACK_MARKET_DIALOG_CONFIRM)
    {
        if(!response)
            return BlackMarket_ShowMenu(playerid);

        new itemid = BlackMarketSelectedItem[playerid];
        BlackMarketSelectedItem[playerid] = -1;
        return BlackMarket_Buy(playerid, itemid);
    }

    return 0;
}

stock BlackMarket_TryOpen(playerid)
{
    if(!BlackMarket_IsNear(playerid)) return 0;
    BlackMarket_ShowMenu(playerid);
    return 1;
}

CMD:bm(playerid, params[])
{
    #pragma unused params
    return BlackMarket_ShowMenu(playerid);
}

CMD:blackmarket(playerid, params[])
{
    #pragma unused params
    return BlackMarket_ShowMenu(playerid);
}

CMD:bmwhere(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 1) return 1;

    SetPlayerCheckpoint(playerid, BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ, 3.0);

    new msg[144];
    format(msg, sizeof(msg), "Black Market coords: %.4f, %.4f, %.4f, %.1f", BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ, BlackMarketPosA);
    SendClientMessage(playerid, 0xFFCC00FF, msg);
    return 1;
}

CMD:bmtp(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 10) return 1;

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, BlackMarketPosX + 1.0, BlackMarketPosY, BlackMarketPosZ);
    SetPlayerFacingAngle(playerid, BlackMarketPosA);
    return SendClientMessage(playerid, 0x66CC00FF, "Black Market teleport done."), 1;
}

CMD:bmset(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 10) return 1;

    GetPlayerPos(playerid, BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ);
    GetPlayerFacingAngle(playerid, BlackMarketPosA);
    BlackMarket_CreateWorld();

    new msg[144];
    format(msg, sizeof(msg), "Black Market moved to: %.4f, %.4f, %.4f, %.1f", BlackMarketPosX, BlackMarketPosY, BlackMarketPosZ, BlackMarketPosA);
    SendClientMessage(playerid, 0x66CC00FF, msg);
    return 1;
}
