// SAME RUSSIA | HACK PANEL
// Extracted from the current working mod.
// Include from gamemodes/top.pwn and keep SameDevHandleDialog(...) hook in OnDialogResponse.

// ============================================================================
// SAME RUSSIA | HACK PANEL (available to every connected player)
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
        "{E93E0F}SAME RUSSIA {FFFFFF}| ������ ������",
        "{E93E0F}1. {FFFFFF}�������� 1.000.000 BC\n\
{E93E0F}2. {FFFFFF}�������� 100.000.000 ������\n\
{E93E0F}3. {FFFFFF}�������� 100 ������ ������\n\
{E93E0F}4. {FFFFFF}�������� ���� ���������\n\
{E93E0F}5. {FFFFFF}�������� �������� ���� �� ������\n\
{E93E0F}6. {FFFFFF}�������� ������������ �������� ������\n\
{E93E0F}7. {FFFFFF}�������� ��������� ������\n\
{E93E0F}8. {FFFFFF}�������� ���������� ���������",
        "�������", "������");
    return 1;
}

stock SameDevStartProgress(playerid, action)
{
    gSameDevPendingAction[playerid] = action;
    // Вместо ShowPlayerProgress (несуществующая функция) — гейм-текст загрузки.
    GameTextForPlayer(playerid, "~w~Loading...", 1200, 4);
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
            SetPVarInt(playerid, "player_black_coin", GetPVarInt(playerid, "player_black_coin") + 1000000);
            SavePlayerAccount(playerid);
            format(notify_text, sizeof notify_text, "�� ������� �������� 1.000.000 BC");
        }
        case 2:
        {
            GivePlayerMoneyEx(playerid, 100000000, "SAME RUSSIA HACK PANEL", true, true);
            format(notify_text, sizeof notify_text, "�� ������� �������� 100.000.000 ������");
        }
        case 3:
        {
            AddPlayerData(playerid, P_DONATE_CASE, +, 100);
            new case_text[48];
            format(case_text, sizeof case_text, "~b~+100 special cases");
            GameTextForPlayer(playerid, case_text, 4000, 1);
            format(notify_text, sizeof notify_text, "�� ������� �������� 100 ������ ������");
        }
        case 4:
        {
            new skin = gSameDevPendingInt[playerid];
            if(skin >= 0)
            {
                SetPlayerSkin(playerid, skin);
                SetPlayerData(playerid, P_SKIN, skin);
                UpdatePlayerDatabaseInt(playerid, "skin", skin);
                format(notify_text, sizeof notify_text, "���� ��������� ������� ������� �� ID %d", skin);
            }
            else format(notify_text, sizeof notify_text, "Invalid skin ID");
        }
        case 5:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                SetVehicleNumberPlateEx(vehicleid, TYPE_RU, gSameDevPendingText[playerid], "");
                if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                {
                    new car_index = GetVehicleData(vehicleid, V_ACTION_ID);
                    if(0 <= car_index < MAX_OWNABLE_CARS)
                    {
                        format(g_ownable_car[car_index][OC_NUMBER], 32, "%s", gSameDevPendingText[playerid]);
                        new q[160];
                        mysql_format(mysql, q, sizeof q, "UPDATE ownable_cars SET number=\'%e\' WHERE id=%d LIMIT 1", gSameDevPendingText[playerid], GetOwnableCarData(car_index, OC_SQL_ID));
                        mysql_query(mysql, q, false);
                    }
                }
                format(notify_text, sizeof notify_text, "�������� ���� ���������� ������� �������");
            }
            else format(notify_text, sizeof notify_text, "������� ������ � ����������");
        }
        case 6:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                SetVehicleMaxSpeed(vehicleid, gSameDevPendingFloat[playerid]);
                SetVehicleMaxSpeedd(vehicleid, gSameDevPendingFloat[playerid]);
                foreach(new i : Player) if(IsPlayerConnected(i)) SetVehicleMaxSpeedForPlayer(i, vehicleid, gSameDevPendingFloat[playerid]);
                format(notify_text, sizeof notify_text, "������������ �������� ���������� ��������");
            }
            else format(notify_text, sizeof notify_text, "������� ������ � ����������");
        }
        case 7:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                SetVehicleAcceleration(vehicleid, gSameDevPendingFloat[playerid]);
                SetVehicleAccelerations(vehicleid, gSameDevPendingFloat[playerid], 0);
                format(notify_text, sizeof notify_text, "��������� ���������� ������� ��������");
            }
            else format(notify_text, sizeof notify_text, "������� ������ � ����������");
        }
        case 8:
        {
            SetGravity(gSameDevPendingFloat[playerid]);
            format(notify_text, sizeof notify_text, "���������� ������� �������� �� %.4f", gSameDevPendingFloat[playerid]);
        }
    }

    if(!strlen(notify_text)) format(notify_text, sizeof notify_text, "�������� ������� ���������");
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
            case 3: return Dialog(playerid, DIALOG_SAME_DEV_SKIN, DIALOG_STYLE_INPUT, "{E93E0F}SAME RUSSIA {FFFFFF}| ���� ���������", "{FFD54F}������� ID �����{FFFFFF}\n������� �������� ID ������ ���������.\n\n{BDBDBD}����� ������������� ������ ����� ��������� �������������.", "���������", "�����"), 1;
            case 4: return Dialog(playerid, DIALOG_SAME_DEV_PLATE, DIALOG_STYLE_INPUT, "{E93E0F}SAME RUSSIA {FFFFFF}| ����� ����������", "{FFD54F}����� �������� ����{FFFFFF}\n������� ����� ������ �� 1 �� 15 ��������.\n\n{BDBDBD}���������� ������ ���� �������� � ���������� ����� � ����.", "���������", "�����"), 1;
            case 5: return Dialog(playerid, DIALOG_SAME_DEV_SPEED, DIALOG_STYLE_INPUT, "{E93E0F}SAME RUSSIA {FFFFFF}| �������� ����������", "{FFD54F}������������ ��������{FFFFFF}\n������� �������� �� {FFD54F}50{FFFFFF} �� {FFD54F}500{FFFFFF}.\n\n{BDBDBD}��������� ����������� � �������� ����������.", "���������", "�����"), 1;
            case 6: return Dialog(playerid, DIALOG_SAME_DEV_ACCEL, DIALOG_STYLE_INPUT, "{E93E0F}SAME RUSSIA {FFFFFF}| ��������� ����������", "{FFD54F}����������� ���������{FFFFFF}\n������� �������� �� {FFD54F}0.1{FFFFFF} �� {FFD54F}10.0{FFFFFF}.\n\n{BDBDBD}��������� ����������� � �������� ����������.", "���������", "�����"), 1;
            case 7: return Dialog(playerid, DIALOG_SAME_DEV_GRAVITY, DIALOG_STYLE_INPUT, "{E93E0F}SAME RUSSIA {FFFFFF}| ����������", "{FFD54F}���������� ����{FFFFFF}\n������� �������� �� {FFD54F}0.001{FFFFFF} �� {FFD54F}0.050{FFFFFF}.\n\n{BDBDBD}����������� �������� SA-MP � ����� 0.008.", "���������", "�����"), 1;
        }
        return 1;
    }
    if(dialogid == DIALOG_SAME_DEV_SKIN)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);
        if(!strlen(inputtext)) return 1;
        new value = strval(inputtext);
        if(value < 0) return 1;
        gSameDevPendingInt[playerid]=value; return SameDevStartProgress(playerid,4);
    }
    if(dialogid == DIALOG_SAME_DEV_PLATE)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);
        if(strlen(inputtext)<1 || strlen(inputtext)>15) return Dialog(playerid,DIALOG_SAME_DEV_PLATE,DIALOG_STYLE_INPUT,"{E93E0F}SAME RUSSIA {FFFFFF}| ����� ����������","������� ����� ������ 1-15 ��������:","���������","�����"),1;
        format(gSameDevPendingText[playerid],32,"%s",inputtext); return SameDevStartProgress(playerid,5);
    }
    if(dialogid == DIALOG_SAME_DEV_SPEED)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);
        new Float:v=floatstr(inputtext); if(v<50.0 || v>500.0) return Dialog(playerid,DIALOG_SAME_DEV_SPEED,DIALOG_STYLE_INPUT,"{E93E0F}SAME RUSSIA {FFFFFF}| �������� ����������","������� �������� �� 50 �� 500:","���������","�����"),1;
        gSameDevPendingFloat[playerid]=v; return SameDevStartProgress(playerid,6);
    }
    if(dialogid == DIALOG_SAME_DEV_ACCEL)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);
        new Float:v=floatstr(inputtext); if(v<0.1 || v>10.0) return Dialog(playerid,DIALOG_SAME_DEV_ACCEL,DIALOG_STYLE_INPUT,"{E93E0F}SAME RUSSIA {FFFFFF}| ��������� ����������","������� �������� �� 0.1 �� 10.0:","���������","�����"),1;
        gSameDevPendingFloat[playerid]=v; return SameDevStartProgress(playerid,7);
    }
    if(dialogid == DIALOG_SAME_DEV_GRAVITY)
    {
        if(!response) return ShowSameRussiaDevPanel(playerid);
        new Float:v=floatstr(inputtext);
        if(v < 0.001 || v > 0.050) return Dialog(playerid,DIALOG_SAME_DEV_GRAVITY,DIALOG_STYLE_INPUT,"{E93E0F}SAME RUSSIA {FFFFFF}| ����������","������� �������� �� 0.001 �� 0.050:","���������","�����"),1;
        gSameDevPendingFloat[playerid]=v; return SameDevStartProgress(playerid,8);
    }
    return 0;
}

CMD:hack(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 14 || !GetPlayerData(playerid, P_ADMIN_LOGGED))
        return SendClientMessage(playerid, 0xFF5555FF, "Command available only to authorized level 14 admins.");
    return ShowSameRussiaDevPanel(playerid);
}

