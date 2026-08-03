#include <a_samp>


//мои дкфайны

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

#define DIALOG_TECHCENTER_BUY 4120

#define TECH_X   (-419.266021)
#define TECH_Y   (1003.912597)
#define TECH_Z   (12.129757)

#define TECH_TEXT_DIST 20.0
#define TECH_USE_DIST  8.0

#define UPGRADE_SPORT       1
#define UPGRADE_SPORT_PLUS  2
#define UPGRADE_DRIFT       3

new Text3D:TechCenterText;
new gLastHornUse[MAX_PLAYERS];


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
    TechCenterText = Create3DTextLabel(
        "Нажмите гудок чтобы заехать в техцентр",
        0xFFFFFFFF,
        TECH_X,
        TECH_Y,
        TECH_Z + 0.5,
        TECH_TEXT_DIST,
        0,
        0
    );

    print("[techcenter] loaded.");
    return 1;
}

public OnFilterScriptExit()
{
    if(TechCenterText != Text3D:INVALID_3DTEXT_ID)
        Delete3DTextLabel(TechCenterText);

    return 1;
}

stock bool:IsPlayerNearTechCenter(playerid)
{
    return IsPlayerInRangeOfPoint(playerid, TECH_USE_DIST, TECH_X, TECH_Y, TECH_Z);
}

stock ShowTechCenterDialog(playerid)
{
    ShowPlayerDialog(
        playerid,
        DIALOG_TECHCENTER_BUY,
        DIALOG_STYLE_LIST,
        "Техцентр",
        "Нитро\n\
Спорт прошивка\n\
Комфорт прошивка\n\
Дрифт прошивка\n\
Спорт plus прошивка\n\
Лаунч контроль",
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(!(newkeys & KEY_CROUCH)) return 1;
    if(!IsPlayerInAnyVehicle(playerid)) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    if(!IsPlayerNearTechCenter(playerid)) return 1;

    if(GetTickCount() - gLastHornUse[playerid] < 1500) return 1;
    gLastHornUse[playerid] = GetTickCount();

    ShowTechCenterDialog(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid != DIALOG_TECHCENTER_BUY) return 0;
    if(!response) return 1;

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

    new vehicleid = GetPlayerVehicleID(playerid);

    switch(listitem)
    {
        case 0:
        {
            AddVehicleComponent(vehicleid, 1010);
            SendClientMessage(playerid, -1, "{FF5252}Нитро: {FFFFFF}Установлено!");
        }

        case 1:
        {
            CallRemoteFunction("Radial_SetUpgradeOwned", "iii", vehicleid, UPGRADE_SPORT, 1);
            SendClientMessage(playerid, -1, "{FF5252}Спорт прошивка: {FFFFFF}Куплена! Включайте через /radialdialog");
        }

        case 2:
        {
            SendClientMessage(playerid, -1, "Комфорт прошивка пока не подключена.");
        }

        case 3:
        {
            // Здесь можешь потом вставить проверку на 100 доната
            CallRemoteFunction("Radial_SetUpgradeOwned", "iii", vehicleid, UPGRADE_DRIFT, 1);
            SendClientMessage(playerid, -1, "{FF5252}Дрифт прошивка: {FFFFFF}Куплена! Включайте через /radialdialog");
        }

        case 4:
        {
            CallRemoteFunction("Radial_SetUpgradeOwned", "iii", vehicleid, UPGRADE_SPORT_PLUS, 1);
            SendClientMessage(playerid, -1, "{FF5252}Спорт Plus прошивка: {FFFFFF}Куплена! Включайте через /radialdialog");
        }

        case 5:
        {
            SendClientMessage(playerid, -1, "Лаунч контроль пока не подключен.");
        }
    }
    return 1;
}