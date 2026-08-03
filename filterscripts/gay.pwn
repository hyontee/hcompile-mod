#include <a_samp>

//мои даф

#define HP_MAX_SPEED            0  // макс. скорость (м/с)
#define HP_ACCELERATION         1  // ускорение (0.4)
#define HP_GEAR                 2  // привод: 0-1.1 задний, 1.2-2.1 перед, 2.2-3.1 полный
#define HP_ENGINE_INERTION      3  // инерция двигателя
#define HP_MASS                 4  // масса
#define HP_MASS_TURN            5  // масса для поворота
#define HP_BRAKE_DECELERATION   6  // сила торможения
#define HP_TRACTION_MULTIPLIER  7  // множитель сцепления
#define HP_TRACTION_LOSS        8  // потеря сцепления при разгоне
#define HP_TRACTION_BIAS        9  // смещение сцепления перед/зад
#define HP_SUSPENSION_LOWER     10 // нижняя граница подвески
#define HP_SUSPENSION_BIAS      11 // смещение подвески
#define HP_WHEEL_SIZE           12 // размер колёс


#define DIALOG_RADIAL_MAIN         50000
#define DIALOG_RADIAL_STROBE       50001
#define DIALOG_RADIAL_NEON         50002
#define DIALOG_SKIN_INV            50003
#define DIALOG_TRUNK_MAIN          50004
#define DIALOG_TRUNK_PUT_SKIN      50005
#define DIALOG_TRUNK_TAKE_SKIN     50006

#define MAX_PLAYER_SKINS           50
#define MAX_TRUNK_SKINS            30

#define UPGRADE_SPORT              1
#define UPGRADE_SPORT_PLUS         2
#define UPGRADE_DRIFT              3

new gVehicleUpgradeOwned[MAX_VEHICLES][4];

new PlayerSkinInv[MAX_PLAYERS][MAX_PLAYER_SKINS];
new PlayerSkinInvCount[MAX_PLAYERS];

new VehicleTrunkSkins[MAX_VEHICLES][MAX_TRUNK_SKINS];
new VehicleTrunkSkinCount[MAX_VEHICLES];

new TempSkinList[MAX_PLAYERS][MAX_PLAYER_SKINS];
new TempSkinListCount[MAX_PLAYERS];

new TempTrunkSkinList[MAX_PLAYERS][MAX_TRUNK_SKINS];
new TempTrunkSkinListCount[MAX_PLAYERS];

forward OpenRadialDialog(playerid);
forward ShowSkinInventory(playerid);
forward AddInventorySkin(playerid, skinid);
forward Radial_SetUpgradeOwned(vehicleid, upgradeid, state);

//стоки

stock SetVehicleHandling(playerid, vehicleid, id, Float:value)
{
 new BitStream:bs = BS_New();
 BS_WriteValue(bs, PR_UINT8, 251, PR_UINT32, 0x11, PR_UINT16, vehicleid, PR_UINT8, 1, PR_UINT8, id, PR_FLOAT, value);
 BS_RPC(bs, playerid, 251);
 BS_Delete(bs);
}

stock SetVehicleHandlingMulti(playerid, vehicleid, params[][2], count)
{
 new BitStream:bs = BS_New();
 BS_WriteValue(bs, PR_UINT8, 251, PR_UINT32, 0x11, PR_UINT16, vehicleid, PR_UINT8, count);
 for(new i = 0; i < count; i++)
  BS_WriteValue(bs, PR_UINT8, params[i][0], PR_FLOAT, Float:params[i][1]);
 BS_RPC(bs, playerid, 251);
 BS_Delete(bs);
}

stock ResetVehicleHandling(playerid, vehicleid)
{
 new BitStream:bs = BS_New();
 BS_WriteValue(bs, PR_UINT8, 251, PR_UINT32, 0x14, PR_UINT16, vehicleid);
 BS_RPC(bs, playerid, 251);
 BS_Delete(bs);
}


public OnFilterScriptInit()
{
    print("[radial] loaded.");
    return 1;
}

public OnFilterScriptExit()
{
    print("[radial] unloaded.");
    return 1;
}

public Radial_SetUpgradeOwned(vehicleid, upgradeid, state)
{
    if(vehicleid <= 0) return 0;
    if(upgradeid < 1 || upgradeid > 3) return 0;

    gVehicleUpgradeOwned[vehicleid][upgradeid] = state;
    return 1;
}

public OpenRadialDialog(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, -1, "Вы не в автомобиле.");
        return 1;
    }

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        SendClientMessage(playerid, -1, "Вы должны быть за рулем.");
        return 1;
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_RADIAL_MAIN,
        DIALOG_STYLE_LIST,
        "Управление автомобилем",
        "Завести автомобиль\n\
Заглушить двигатель\n\
Фары\n\
Спорт прошивка\n\
Спорт plus прошивка\n\
Дрифт прошивка\n\
Комфорт прошивка\n\
Стробоскопы\n\
Настройка неона\n\
Открыть багажник",
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

public ShowSkinInventory(playerid)
{
    new dialogStr[4096];
    dialogStr[0] = '\0';

    if(PlayerSkinInvCount[playerid] <= 0)
    {
        strcat(dialogStr, "У вас нет скинов.");
    }
    else
    {
        for(new i = 0; i < PlayerSkinInvCount[playerid]; i++)
        {
            new line[128];
            format(line, sizeof(line), "Скин (%d) нажмите чтобы одеть\n", PlayerSkinInv[playerid][i]);
            strcat(dialogStr, line);
        }
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_SKIN_INV,
        DIALOG_STYLE_LIST,
        "Инвентарь скинов",
        dialogStr,
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

public AddInventorySkin(playerid, skinid)
{
    if(PlayerSkinInvCount[playerid] >= MAX_PLAYER_SKINS) return 0;

    PlayerSkinInv[playerid][PlayerSkinInvCount[playerid]] = skinid;
    PlayerSkinInvCount[playerid]++;
    return 1;
}

stock ShowStrobeMenu(playerid)
{
    ShowPlayerDialog(
        playerid,
        DIALOG_RADIAL_STROBE,
        DIALOG_STYLE_LIST,
        "Стробоскопы",
        "Стробоскопы 1\n\
Стробоскопы 2\n\
Стробоскопы 3\n\
Стробоскопы 4",
        "Выбрать",
        "Назад"
    );
    return 1;
}

stock ShowNeonMenu(playerid)
{
    ShowPlayerDialog(
        playerid,
        DIALOG_RADIAL_NEON,
        DIALOG_STYLE_LIST,
        "Настройка неона",
        "Красный\n\
Зеленый\n\
Фиолетовый\n\
Синий\n\
Голубой\n\
Белый\n\
Желтый",
        "Выбрать",
        "Назад"
    );
    return 1;
}

stock SetVehicleEngineState(vehicleid, engine_state)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine_state, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}

stock ToggleVehicleLights(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    if(lights == 1)
        SetVehicleParamsEx(vehicleid, engine, 0, alarm, doors, bonnet, boot, objective);
    else
        SetVehicleParamsEx(vehicleid, engine, 1, alarm, doors, bonnet, boot, objective);

    return 1;
}

stock bool:RemoveSkinFromPlayerInvBySlot(playerid, slot)
{
    if(slot < 0 || slot >= PlayerSkinInvCount[playerid]) return false;

    for(new i = slot; i < PlayerSkinInvCount[playerid] - 1; i++)
    {
        PlayerSkinInv[playerid][i] = PlayerSkinInv[playerid][i + 1];
    }

    PlayerSkinInvCount[playerid]--;
    return true;
}

stock bool:AddSkinToVehicleTrunk(vehicleid, skinid)
{
    if(vehicleid <= 0) return false;
    if(VehicleTrunkSkinCount[vehicleid] >= MAX_TRUNK_SKINS) return false;

    VehicleTrunkSkins[vehicleid][VehicleTrunkSkinCount[vehicleid]] = skinid;
    VehicleTrunkSkinCount[vehicleid]++;
    return true;
}

stock bool:RemoveSkinFromVehicleTrunkBySlot(vehicleid, slot)
{
    if(vehicleid <= 0) return false;
    if(slot < 0 || slot >= VehicleTrunkSkinCount[vehicleid]) return false;

    for(new i = slot; i < VehicleTrunkSkinCount[vehicleid] - 1; i++)
    {
        VehicleTrunkSkins[vehicleid][i] = VehicleTrunkSkins[vehicleid][i + 1];
    }

    VehicleTrunkSkinCount[vehicleid]--;
    return true;
}

stock ShowVehicleTrunkMenu(playerid, vehicleid)
{
    if(vehicleid <= 0)
    {
        SendClientMessage(playerid, -1, "Ошибка автомобиля.");
        return 1;
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_TRUNK_MAIN,
        DIALOG_STYLE_LIST,
        "Багажник",
        "Положить скин\n\
Взять скин",
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

stock ShowPutSkinToTrunkDialog(playerid)
{
    new dialogStr[4096];
    dialogStr[0] = '\0';
    TempSkinListCount[playerid] = 0;

    if(PlayerSkinInvCount[playerid] <= 0)
    {
        strcat(dialogStr, "У вас нет скинов.");
    }
    else
    {
        for(new i = 0; i < PlayerSkinInvCount[playerid]; i++)
        {
            TempSkinList[playerid][TempSkinListCount[playerid]] = i;
            TempSkinListCount[playerid]++;

            new line[128];
            format(line, sizeof(line), "Скин (%d)\n", PlayerSkinInv[playerid][i]);
            strcat(dialogStr, line);
        }
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_TRUNK_PUT_SKIN,
        DIALOG_STYLE_LIST,
        "Положить скин в багажник",
        dialogStr,
        "Выбрать",
        "Назад"
    );
    return 1;
}

stock ShowTakeSkinFromTrunkDialog(playerid, vehicleid)
{
    new dialogStr[4096];
    dialogStr[0] = '\0';
    TempTrunkSkinListCount[playerid] = 0;

    if(vehicleid <= 0 || VehicleTrunkSkinCount[vehicleid] <= 0)
    {
        strcat(dialogStr, "В багажнике нет скинов.");
    }
    else
    {
        for(new i = 0; i < VehicleTrunkSkinCount[vehicleid]; i++)
        {
            TempTrunkSkinList[playerid][TempTrunkSkinListCount[playerid]] = i;
            TempTrunkSkinListCount[playerid]++;

            new line[128];
            format(line, sizeof(line), "Скин (%d)\n", VehicleTrunkSkins[vehicleid][i]);
            strcat(dialogStr, line);
        }
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_TRUNK_TAKE_SKIN,
        DIALOG_STYLE_LIST,
        "Взять скин из багажника",
        dialogStr,
        "Выбрать",
        "Назад"
    );
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_RADIAL_MAIN)
    {
        if(!response) return 1;
        if(!IsPlayerInAnyVehicle(playerid)) return 1;
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

        new vehicleid = GetPlayerVehicleID(playerid);

        switch(listitem)
        {
            case 0:
            {
                SetVehicleEngineState(vehicleid, 1);
                SendClientMessage(playerid, -1, "Вы завели автомобиль.");
            }
            case 1:
            {
                SetVehicleEngineState(vehicleid, 0);
                SendClientMessage(playerid, -1, "Вы заглушили двигатель.");
            }
            case 2:
            {
                ToggleVehicleLights(vehicleid);
                SendClientMessage(playerid, -1, "Вы переключили фары.");
            }
            case 3:
            {
                if(!gVehicleUpgradeOwned[vehicleid][UPGRADE_SPORT])
                {
                    SendClientMessage(playerid, -1, "Сначала купите спорт прошивку в техцентре.");
                    return 1;
                }

                new params_arr[4][2];
                params_arr[0][0] = HP_MAX_SPEED;            params_arr[0][1] = 250;
                params_arr[1][0] = HP_ACCELERATION;         params_arr[1][1] = _:35.0;
                params_arr[2][0] = HP_TRACTION_MULTIPLIER;  params_arr[2][1] = _:2.5;
                params_arr[3][0] = HP_BRAKE_DECELERATION;   params_arr[3][1] = _:15.0;
                SetVehicleHandlingMulti(playerid, vehicleid, params_arr, 4);

                SendClientMessage(playerid, -1, "Спорт прошивка включена.");
            }
            case 4:
            {
                if(!gVehicleUpgradeOwned[vehicleid][UPGRADE_SPORT_PLUS])
                {
                    SendClientMessage(playerid, -1, "Сначала купите спорт plus прошивку в техцентре.");
                    return 1;
                }

                new params_arr[4][2];
                params_arr[0][0] = HP_MAX_SPEED;            params_arr[0][1] = 285;
                params_arr[1][0] = HP_ACCELERATION;         params_arr[1][1] = _:45.0;
                params_arr[2][0] = HP_TRACTION_MULTIPLIER;  params_arr[2][1] = _:3.0;
                params_arr[3][0] = HP_BRAKE_DECELERATION;   params_arr[3][1] = _:18.0;
                SetVehicleHandlingMulti(playerid, vehicleid, params_arr, 4);

                SendClientMessage(playerid, -1, "Спорт plus прошивка включена.");
            }
            case 5:
            {
                if(!gVehicleUpgradeOwned[vehicleid][UPGRADE_DRIFT])
                {
                    SendClientMessage(playerid, -1, "Сначала купите дрифт прошивку в техцентре.");
                    return 1;
                }

                CallRemoteFunction("Radial_DriftFirmware", "ii", playerid, vehicleid);
            }
            case 6:
            {
                SendClientMessage(playerid, -1, "Комфорт прошивка пока не реализована.");
            }
            case 7:
            {
                ShowStrobeMenu(playerid);
            }
            case 8:
            {
                ShowNeonMenu(playerid);
            }
            case 9:
            {
                ShowVehicleTrunkMenu(playerid, vehicleid);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_RADIAL_STROBE)
    {
        if(!response)
        {
            OpenRadialDialog(playerid);
            return 1;
        }

        if(!IsPlayerInAnyVehicle(playerid)) return 1;
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

        new vehicleid = GetPlayerVehicleID(playerid);

        switch(listitem)
        {
            case 0: CallRemoteFunction("Radial_SetStrobe", "iii", playerid, vehicleid, 1);
            case 1: CallRemoteFunction("Radial_SetStrobe", "iii", playerid, vehicleid, 2);
            case 2: CallRemoteFunction("Radial_SetStrobe", "iii", playerid, vehicleid, 3);
            case 3: CallRemoteFunction("Radial_SetStrobe", "iii", playerid, vehicleid, 4);
        }
        return 1;
    }

    if(dialogid == DIALOG_RADIAL_NEON)
    {
        if(!response)
        {
            OpenRadialDialog(playerid);
            return 1;
        }

        if(!IsPlayerInAnyVehicle(playerid)) return 1;
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

        new vehicleid = GetPlayerVehicleID(playerid);

        switch(listitem)
        {
            case 0: CallRemoteFunction("Radial_SetNeon", "iii", playerid, vehicleid, 0);
            case 1: CallRemoteFunction("Radial_SetNeon", "iii", playerid, vehicleid, 1);
            case 2: CallRemoteFunction("Radial_SetNeon", "iii", playerid, vehicleid, 2);
            case 3: CallRemoteFunction("Radial_SetNeon", "iii", playerid, vehicleid, 3);
            case 4: CallRemoteFunction("Radial_SetNeon", "iii", playerid, vehicleid, 4);
            case 5: CallRemoteFunction("Radial_SetNeon", "iii", playerid, vehicleid, 5);
            case 6: CallRemoteFunction("Radial_SetNeon", "iii", playerid, vehicleid, 6);
        }
        return 1;
    }

    if(dialogid == DIALOG_SKIN_INV)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= PlayerSkinInvCount[playerid]) return 1;

        SetPlayerSkin(playerid, PlayerSkinInv[playerid][listitem]);
        SendClientMessage(playerid, -1, "Вы надели скин.");
        return 1;
    }

    if(dialogid == DIALOG_TRUNK_MAIN)
    {
        if(!response) return 1;
        if(!IsPlayerInAnyVehicle(playerid)) return 1;

        new vehicleid = GetPlayerVehicleID(playerid);

        switch(listitem)
        {
            case 0: ShowPutSkinToTrunkDialog(playerid);
            case 1: ShowTakeSkinFromTrunkDialog(playerid, vehicleid);
        }
        return 1;
    }

    if(dialogid == DIALOG_TRUNK_PUT_SKIN)
    {
        if(!response)
        {
            if(IsPlayerInAnyVehicle(playerid))
                ShowVehicleTrunkMenu(playerid, GetPlayerVehicleID(playerid));
            return 1;
        }

        if(!IsPlayerInAnyVehicle(playerid)) return 1;

        new vehicleid = GetPlayerVehicleID(playerid);

        if(listitem < 0 || listitem >= TempSkinListCount[playerid]) return 1;

        new invSlot = TempSkinList[playerid][listitem];
        if(invSlot < 0 || invSlot >= PlayerSkinInvCount[playerid]) return 1;

        new skinid = PlayerSkinInv[playerid][invSlot];

        if(!AddSkinToVehicleTrunk(vehicleid, skinid))
        {
            SendClientMessage(playerid, -1, "Багажник заполнен.");
            return 1;
        }

        RemoveSkinFromPlayerInvBySlot(playerid, invSlot);
        SendClientMessage(playerid, -1, "Скин положен в багажник.");
        ShowPutSkinToTrunkDialog(playerid);
        return 1;
    }

    if(dialogid == DIALOG_TRUNK_TAKE_SKIN)
    {
        if(!response)
        {
            if(IsPlayerInAnyVehicle(playerid))
                ShowVehicleTrunkMenu(playerid, GetPlayerVehicleID(playerid));
            return 1;
        }

        if(!IsPlayerInAnyVehicle(playerid)) return 1;

        new vehicleid = GetPlayerVehicleID(playerid);

        if(listitem < 0 || listitem >= TempTrunkSkinListCount[playerid]) return 1;

        new trunkSlot = TempTrunkSkinList[playerid][listitem];
        if(trunkSlot < 0 || trunkSlot >= VehicleTrunkSkinCount[vehicleid]) return 1;

        new skinid = VehicleTrunkSkins[vehicleid][trunkSlot];

        if(AddInventorySkin(playerid, skinid) == 0)
        {
            SendClientMessage(playerid, -1, "Инвентарь скинов заполнен.");
            return 1;
        }

        RemoveSkinFromVehicleTrunkBySlot(vehicleid, trunkSlot);
        SendClientMessage(playerid, -1, "Скин взят из багажника.");
        ShowTakeSkinFromTrunkDialog(playerid, vehicleid);
        return 1;
    }

    return 0;
}