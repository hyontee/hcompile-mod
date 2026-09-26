// === Client/UI helpers (используются уже в твоём моде) ===
stock NC_UI_Lock(playerid)
{
    #if defined HideHud
        HideHud(playerid);
    #endif
    #if defined FreezePlayer
        FreezePlayer(playerid);
    #else
        TogglePlayerControllable(playerid, false);
    #endif
    return 1;
}
stock NC_UI_Unlock(playerid)
{
    #if defined ShowHud
        ShowHud(playerid);
    #endif
    #if defined UnFreezePlayer
        UnFreezePlayer(playerid);
    #else
        TogglePlayerControllable(playerid, true);
    #endif
    return 1;
}
stock NC_SetGreen(playerid, value)
{
    #if defined SetGreenZoneForPlayer
        SetGreenZoneForPlayer(playerid, value);
    #endif
    #if defined gPlayerInGreenZone
        gPlayerInGreenZone[playerid] = (value != 0);
    #endif
    return 1;
}

// ============================================================
//  Nightclub MOON system (CRMP) - v5 (CP1251)
//  - Reception uses Interaction Button (RPC action 18)
//  - All other points are PICKUPS (no Interaction Button)
//  - GUI 15 dance events are handled via NC_TryHandlePacket252() (call from your IPacket:252)
//  - DB: uses existing mysql handle "mysql"
// ============================================================

#if defined _NC_MOON_INCLUDED

    #endinput

#endif

#define _NC_MOON_INCLUDED


#if !defined INVALID_AREA_ID

    #define INVALID_AREA_ID (-1)

#endif



new PlayerCurrentAreaType[MAX_PLAYERS];

new PlayerCurrentAreaID[MAX_PLAYERS];

stock NC_ToggleInteractionWindow(playerid, bool:show)
{
    #if defined ToggleInteractionWindow
        ToggleInteractionWindow(playerid, show);
    #endif
    return 1;
}







CMD:clubhelp(playerid, params[])

{

    SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} ??????? ?????: /buyclub, /club, /dancepool, /cyes, /cno");

    SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} ??????: ??????/??????????/?????. ????????: ????????? ? ?????? ? ??????? ?????.");

    return 1;

}


// ---------- CONFIG ----------
#define NC_CLUB_NAME            "MOON"
#define NC_BUY_PRICE            (300000000)     // 300 mln ?
#define NC_DANCE_REWARD         (500000)        // 500k ?
#define NC_DANCE_CD_SEC         (30*60)         // 30 minutes

// Reception actor skin (not "Ahmed")
#define NC_RECEPTION_SKIN       (172) // businesswoman

// Dialog IDs (pick high values to avoid collisions)
#define DIALOG_NC_RECEPTION     9501
#define DIALOG_NC_BARMAN_JOB  9130
#define DIALOG_NC_BARMAN_MENU   9502
#define DIALOG_NC_STRIP_MENU    9503

#define DIALOG_NC_OWNER_MAIN     9510
#define DIALOG_NC_OWNER_INFO     9511
#define DIALOG_NC_OWNER_SETTINGS 9512
#define DIALOG_NC_OWNER_ROOF     9513
#define DIALOG_NC_OWNER_FEE      9514
#define DIALOG_NC_OWNER_UPGR     9515
#define DIALOG_NC_OWNER_TEAM     9516
#define DIALOG_NC_OWNER_ADDCO    9517
#define DIALOG_NC_OWNER_REMCO    9518

// Interaction area types (must NOT collide with your enum)
#define AREA_TYPE_NC_RECEPTION      1001

// ---------- COORDS ----------
// Enter club (outside)
static const Float:NC_ENTER_X = 661.41;
static const Float:NC_ENTER_Y = 262.06;
static const Float:NC_ENTER_Z = 13.94;
static const Float:NC_ENTER_A = 179.31;
static const NC_ENTER_VW = 0;
static const NC_ENTER_INT = 0;

// Enter club spawn (inside)
static const Float:NC_INSIDE_X = 7.43;
static const Float:NC_INSIDE_Y = -14.35;
static const Float:NC_INSIDE_Z = 1511.46;
static const Float:NC_INSIDE_A = 268.85;
static const NC_INSIDE_VW = 0;
static const NC_INSIDE_INT = 1;

// Reception (inside)
static const Float:NC_RECEPT_X = 5.76;
static const Float:NC_RECEPT_Y = -11.05;
static const Float:NC_RECEPT_Z = 1511.46;
static const Float:NC_RECEPT_A = 183.94;
static const NC_RECEPT_VW = 0;
static const NC_RECEPT_INT = 1;

// Barman job (inside) (PICKUP)
static const Float:NC_BARMAN_JOB_X = -12.19;
static const Float:NC_BARMAN_JOB_Y = 12.22;
static const Float:NC_BARMAN_JOB_Z = 1511.04;
static const Float:NC_BARMAN_JOB_A = 265.09;

// Barman order (inside) (PICKUP)
static const Float:NC_BARMAN_ORD_X = -10.40;
static const Float:NC_BARMAN_ORD_Y = 12.03;
static const Float:NC_BARMAN_ORD_Z = 1511.04;
static const Float:NC_BARMAN_ORD_A = 91.08;

// Dance pool positions
static const Float:NC_DANCEPOOL_X = 0.08;
static const Float:NC_DANCEPOOL_Y = 23.17;
static const Float:NC_DANCEPOOL_Z = 1511.42;
static const Float:NC_DANCEPOOL_A = 174.57;

static const Float:NC_DANCE3D_X = 0.03;
static const Float:NC_DANCE3D_Y = 30.94;
static const Float:NC_DANCE3D_Z = 1511.63;
static const Float:NC_DANCE3D_A = 178.96;

// Dressing room for stripper (PICKUP)
static const Float:NC_RAZD_X = -2.82;
static const Float:NC_RAZD_Y = 39.80;
static const Float:NC_RAZD_Z = 1511.13;
static const Float:NC_RAZD_A = 277.53;

// Garage enter (outside)
static const Float:NC_GARAGE_X = 677.12;
static const Float:NC_GARAGE_Y = 249.10;
static const Float:NC_GARAGE_Z = 9.87;
static const Float:NC_GARAGE_A = 176.11;
static const NC_GARAGE_INT = 0;

// Garage interior type 3
static const Float:NC_GARINT_X = 0.0;
static const Float:NC_GARINT_Y = 2500.0;
static const Float:NC_GARINT_Z = 1540.0;
static const Float:NC_GARINT_A = 0.0;
static const NC_GARINT_INT = 3;

// ---------- DB STATE ----------
enum e_nc_data {
    nc_owner_id,
    nc_owner_name[MAX_PLAYER_NAME],
    nc_co1_id,
    nc_co1_name[MAX_PLAYER_NAME],
    nc_co2_id,
    nc_co2_name[MAX_PLAYER_NAME],
    nc_roof,        // 0 none, 1 bat, 2 lyt, 3 arz
    nc_entry_fee,   // 100..10000
    nc_balance,
    nc_upg_light,
    nc_upg_sound,
    nc_upg_capacity
};
new NC[e_nc_data];

// Entities
new NC_EnterPickup = -1;
new Text3D:NC_EnterText = Text3D:INVALID_3DTEXT_ID;

new NC_GaragePickup = -1;
new Text3D:NC_GarageText = Text3D:INVALID_3DTEXT_ID;

new NC_BarmanJobPickup = -1;
new NC_BarmanOrderPickup = -1;
new NC_StripPickup = -1;

new Text3D:NC_DanceText = Text3D:INVALID_3DTEXT_ID;

new NC_ReceptionActor = INVALID_ACTOR_ID;
new NC_ReceptionArea = -1;
new NC_GreenOutsideArea = -1;
new NC_GreenInsideArea = -1;
new NC_GreenCount[MAX_PLAYERS];

// Per-player
new bool:NC_IsBarman[MAX_PLAYERS];
new bool:NC_IsStripper[MAX_PLAYERS];

// Anti-spam (диалоги/пикапы)
new NC_NextInteractTick[MAX_PLAYERS];
new NC_NextDialogTick[MAX_PLAYERS];

#define NC_INTERACT_COOLDOWN_MS (800)
#define NC_DIALOG_COOLDOWN_MS   (800)

stock bool:NC_CanInteract(playerid)
{
    new now = GetTickCount();
    if(now < NC_NextInteractTick[playerid]) return false;
    NC_NextInteractTick[playerid] = now + NC_INTERACT_COOLDOWN_MS;
    return true;
}
stock bool:NC_CanDialog(playerid)
{
    new now = GetTickCount();
    if(now < NC_NextDialogTick[playerid]) return false;
    NC_NextDialogTick[playerid] = now + NC_DIALOG_COOLDOWN_MS;
    return true;
}

new NC_PaidUntil[MAX_PLAYERS];             // unix time (entry ticket)
new NC_DanceCooldownUntil[MAX_PLAYERS];    // unix time
new bool:NC_DanceSessionActive[MAX_PLAYERS];
new NC_DanceRound[MAX_PLAYERS];
new NC_DanceRoundRetry[MAX_PLAYERS];
new NC_DanceMistakes[MAX_PLAYERS];
new NC_LastInteractTick[MAX_PLAYERS];

// Parking per-player
new NC_ParkedVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new NC_ParkedVW[MAX_PLAYERS] = {0, ...};
new NC_GarageExitPickup[MAX_PLAYERS] = {-1, ...};

// Pending co-owner invite
new NC_PendingInviteSlot[MAX_PLAYERS];
new NC_PendingInviteUntil[MAX_PLAYERS]; // unix time

// ---------- FORWARDS (call from your main callbacks) ----------
forward NC_OnGameModeInit();
forward NC_OnGameModeExit();
forward NC_OnPlayerConnect(playerid);
forward NC_OnPlayerDisconnect(playerid, reason);
forward NC_OnPlayerPickUpPickup(playerid, pickupid);
forward NC_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
forward NC_OnPlayerEnterDynamicArea(playerid, areaid);
forward NC_OnPlayerLeaveDynamicArea(playerid, areaid);
forward NC_OnIncomingRPC(playerid, rpcid, BitStream:bs);
forward NC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);

// DB load callback
forward NC_OnLoad();
forward NC_ParkingFixTimer(playerid);

forward NC_DanceStartRoundTimer(playerid);
forward NC_ParkingResyncTimer(playerid);
forward NC_Dance_HandleJson(playerid, const jsonStr[]);

// ---------- Helpers ----------
stock NC_GetRoofName(dest[], size)
{
    switch(NC[nc_roof]) {
        case 1: format(dest, size, "Крыша: Батыревское ОПГ");
        case 2: format(dest, size, "Крыша: Лыткаренское ОПГ");
        case 3: format(dest, size, "Крыша: Арзамасское ОПГ");
        default: format(dest, size, "Крыша: Нет");
    }
    return 1;
}

stock NC_IsOwner(playerid)  return (NC[nc_owner_id] != 0 && GetPlayerAccountID(playerid) == NC[nc_owner_id]);
stock NC_IsCoOwner(playerid)
{
    new uid = GetPlayerAccountID(playerid);
    return (uid != 0 && (uid == NC[nc_co1_id] || uid == NC[nc_co2_id]));
}

stock NC_UpdateEnter3D()
{
    if(NC_EnterText != Text3D:INVALID_3DTEXT_ID) DestroyDynamic3DTextLabel(NC_EnterText);

    new roof[64], ownerLine[96], feeLine[64];
    NC_GetRoofName(roof, sizeof roof);

    if(NC[nc_owner_id] == 0) format(ownerLine, sizeof ownerLine, "Владелец: Нет");
    else format(ownerLine, sizeof ownerLine, "Владелец: %s", NC[nc_owner_name]);

    format(feeLine, sizeof feeLine, "Плата за вход: %d ?", NC[nc_entry_fee]);

    new label[256];
    format(label, sizeof label, "{FFD200}%s\n{FFFFFF}%s\n{FFFFFF}%s\n{FFFFFF}%s", "Ночной клуб", roof, ownerLine, feeLine);

    NC_EnterText = CreateDynamic3DTextLabel(label, 0xFFFFFFFF, NC_ENTER_X, NC_ENTER_Y, NC_ENTER_Z + 0.8, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, NC_ENTER_VW, NC_ENTER_INT);
    return 1;
}

stock NC_Save()
{
    new q[512];
    mysql_format(mysql, q, sizeof q,
        "UPDATE nightclub SET owner_id=%d, owner_name='%e', co1_id=%d, co1_name='%e', co2_id=%d, co2_name='%e', roof=%d, entry_fee=%d, balance=%d, upg_light=%d, upg_sound=%d, upg_capacity=%d WHERE id=1",
        NC[nc_owner_id], NC[nc_owner_name],
        NC[nc_co1_id], NC[nc_co1_name],
        NC[nc_co2_id], NC[nc_co2_name],
        NC[nc_roof], NC[nc_entry_fee], NC[nc_balance],
        NC[nc_upg_light], NC[nc_upg_sound], NC[nc_upg_capacity]
    );
    mysql_tquery(mysql, q);
    return 1;
}

stock NC_EnsureDefaults()
{
    if(NC[nc_entry_fee] < 100) NC[nc_entry_fee] = 500;
    if(NC[nc_entry_fee] > 10000) NC[nc_entry_fee] = 10000;
    return 1;
}

stock NC_CanEnter(playerid)
{
    if(NC_IsOwner(playerid) || NC_IsCoOwner(playerid)) return 1;
    new now = gettime();
    if(NC_PaidUntil[playerid] > now) return 1;

    NC_EnsureDefaults();
    new fee = NC[nc_entry_fee];

    if(GetPlayerMoneyEx(playerid) < fee) {
        new msg[128];
        format(msg, sizeof msg, "{FFFF00}[MOON]{FFFFFF} Недостаточно денег для входа. Нужно %d руб.", fee);
        SendClientMessage(playerid, -1, msg);
        return 0;
    }

    GivePlayerMoneyEx(playerid, -fee, "Nightclub entry fee", true, true);
NC[nc_balance] += fee;
NC_PaidUntil[playerid] = now + (30*60);
NC_Save();

new msg2[144];
format(msg2, sizeof msg2, "{FFFF00}[MOON]{FFFFFF} За вход в клуб списано: %d руб. (доступ 30 минут).", fee);
SendClientMessage(playerid, -1, msg2);
return 1;
}

stock NC_EnterClub(playerid)
{
    if(!NC_CanEnter(playerid)) return 1;
    SetPlayerInterior(playerid, NC_INSIDE_INT);
    SetPlayerVirtualWorld(playerid, NC_INSIDE_VW);
    SetPlayerPos(playerid, NC_INSIDE_X, NC_INSIDE_Y, NC_INSIDE_Z);
    SetPlayerFacingAngle(playerid, NC_INSIDE_A);
    SetCameraBehindPlayer(playerid);
    NC_SetGreen(playerid, 1);
    return 1;
}

// ---------- Reception (Interaction Button) ----------
stock NC_OpenReceptionDialog(playerid)
{
    new roof[64]; NC_GetRoofName(roof, sizeof roof);
    new s[512];
    format(s, sizeof s,
        "Добро пожаловать в ночной клуб %s!\n\n%s\nПлата за вход: %d ?\n\nВыберите действие:",
        NC_CLUB_NAME, roof, NC[nc_entry_fee]
    );
    ShowPlayerDialog(playerid, DIALOG_NC_RECEPTION, DIALOG_STYLE_LIST, "Ресепшен MOON",
        "Купить/обновить билет на вход (30 минут)\nИнформация о клубе\nВыйти", "Выбрать", "Закрыть");
    return 1;
}

// ---------- Barman (PICKUP) ----------
stock NC_HasBarmanOnline()
{
    for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i) && NC_IsBarman[i]) return 1;
    return 0;
}

stock NC_OpenBarmanMenu(playerid)
{
    if(!NC_HasBarmanOnline()) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Сейчас нет бармена.");

    ShowPlayerDialog(playerid, DIALOG_NC_BARMAN_MENU, DIALOG_STYLE_LIST, "Бар MOON",
        "Пиво (500 ?)\nВиски (1500 ?)\nШампанское (2500 ?)\nКоктейль MOON (5000 ?)", "Купить", "Закрыть");
    return 1;
}

// ---------- Stripper (PICKUP) ----------
stock NC_OpenStripperMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_NC_STRIP_MENU, DIALOG_STYLE_LIST, "Раздевалка",
        "Устроиться стриптизёром\nУволиться", "Выбрать", "Закрыть");
    return 1;
}

stock NC_SetStripperSkin(playerid)
{
    // В твоём моде GetPlayerSex(playerid): 0 = Мужской, 1 = Женский
    if(GetPlayerSex(playerid) == 0)
    {
        SetPlayerSkin(playerid, 2);
    }
    else
    {
        SetPlayerSkin(playerid, (random(2) ? 139 : 140));
    }
    return 1;
}

// ---------- Dance GUI 15 ----------
stock NC_JsonGetInt(const str[], const key[], defval)
{
    new needle[64];
    format(needle, sizeof needle, "\"%s\"", key);

    new pos = strfind(str, needle, true);
    if(pos == -1) return defval;

    pos = strfind(str[pos], ":", true);
    if(pos == -1) return defval;

    new i = pos + 1;
    while(str[i] == ' ' || str[i] == '\t') i++;

    new sign = 1;
    if(str[i] == '-') { sign = -1; i++; }

    if(str[i] < '0' || str[i] > '9') return defval;

    new val = 0;
    while(str[i] >= '0' && str[i] <= '9')
    {
        val = val * 10 + (str[i] - '0');
        i++;
    }
    return val * sign;
}

stock NC_DanceSendTip(playerid, amount)
{
    if(amount <= 0) return 1;
    new Node:j = JSON_Object();
    JSON_SetInt(j, "t", 0);
    JSON_SetInt(j, "m", amount);
    ShowPlayerGUI(playerid, 15, j);
    JSON_Cleanup(j);
    return 1;
}

stock NC_DanceStart(playerid)
{
    NC_UI_Lock(playerid);
NC_DanceSessionActive[playerid] = true;
    NC_DanceMistakes[playerid] = 0;

    new Node:j = JSON_Object();
    JSON_SetInt(j, "ti", 25);
    JSON_SetInt(j, "e", 0);
    JSON_SetInt(j, "ne", 7);
    JSON_SetInt(j, "g", 150);
    JSON_SetInt(j, "ng", 300);
    JSON_SetInt(j, "b", 0);
    ShowPlayerGUI(playerid, 15, j);
    JSON_Cleanup(j);
    return 1;
}

stock NC_DanceFinishSuccess(playerid)
{
    NC_DanceSessionActive[playerid] = false;
    NC_DanceRound[playerid] = 0;
    NC_DanceRoundRetry[playerid] = 0;

    NC_NextInteractTick[playerid] = 0;
    NC_NextDialogTick[playerid] = 0;
    NC_DanceCooldownUntil[playerid] = gettime() + NC_DANCE_CD_SEC;

    NC_UI_Unlock(playerid);

    GivePlayerMoneyEx(playerid, NC_DANCE_REWARD, "Nightclub dance reward", true, true);
    SetPlayerPos(playerid, NC_DANCE3D_X, NC_DANCE3D_Y, NC_DANCE3D_Z);
    SetPlayerFacingAngle(playerid, NC_DANCE3D_A);
    SetCameraBehindPlayer(playerid);

    SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Вы отлично выступили! Получено 500000 руб.");
    return 1;
}

public NC_DanceStartRoundTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!NC_DanceSessionActive[playerid]) return 0;
    NC_DanceRound[playerid] = 1;
    NC_DanceRoundRetry[playerid] = 0;
    NC_DanceStart(playerid);
    return 1;
}

stock NC_DanceFinishFail(playerid)
{
    NC_DanceSessionActive[playerid] = false;
    NC_DanceRound[playerid] = 0;
    NC_DanceRoundRetry[playerid] = 0;

    NC_NextInteractTick[playerid] = 0;
    NC_NextDialogTick[playerid] = 0;
    NC_DanceCooldownUntil[playerid] = gettime() + NC_DANCE_CD_SEC;

    NC_UI_Unlock(playerid);

    SetPlayerPos(playerid, NC_DANCE3D_X, NC_DANCE3D_Y, NC_DANCE3D_Z);
    SetPlayerFacingAngle(playerid, NC_DANCE3D_A);
    SetCameraBehindPlayer(playerid);

    SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Вы не прошли выступление. Попробуйте позже.");
    return 1;
}

// === GUI 15 (Dance) ===
// ВАЖНО: чтобы не было краша, BitStream читаем ОДИН раз в IPacket:252,
// а сюда передаём уже готовую JSON-строку.
// Хук для IPacket:252, если ты УЖЕ распарсил guiid+jsonStr своим кодом.
// Возвращает 1 если обработано системой клуба.
stock NC_OnGui252Parsed(playerid, guiid, const jsonStr[])
{
    if(guiid != 15) return 0;
    NC_OnDanceGuiJson(playerid, jsonStr);
    return 1;
}

// Alias for ipacket: keeps GUI parsing in ipacket, system handles logic here.
stock NC_Dance_HandleJson(playerid, const jsonStr[])
{
    return NC_OnDanceGuiJson(playerid, jsonStr);
}

stock NC_OnDanceGuiJson(playerid, const jsonStr[])
{
    if(!NC_DanceSessionActive[playerid]) return 1;

    new t = NC_JsonGetInt(jsonStr, "t", -999);

    if(t == 1)
    {
        // correct press
        if(random(100) < 30)
        {
            new tip = 50 + random(151);
            NC_DanceSendTip(playerid, tip);
        }
        return 1;
    }
    if(t == 2)
    {
        // wrong press
        NC_DanceMistakes[playerid]++;
        return 1;
    }
    if(t == 0)
    {
        // close
        new closed = NC_JsonGetInt(jsonStr, "cl_marathon_level", -999);
        if(closed == -999) closed = NC_JsonGetInt(jsonStr, "cl", 0);

        if(closed == 1 && NC_DanceMistakes[playerid] <= 12)
{
    // 2 раунда: награда только после 2-го
    if(NC_DanceRound[playerid] < 2)
    {
        NC_DanceRound[playerid] = 2;
        NC_DanceMistakes[playerid] = 0;
        NC_DanceRoundRetry[playerid] = 0;

        SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Раунд 1 пройден! Стартует раунд 2.");
        SetTimerEx("NC_DanceStartRoundTimer", 900, false, "i", playerid);
        return 1;
    }
    return NC_DanceFinishSuccess(playerid);
}
return NC_DanceFinishFail(playerid);
        return 1;
    }
    return 1;
}

// (Опционально) если тебе всё-таки нужно вызывать из места, где УЖЕ есть BitStream,
// можно использовать этот wrapper. Но НЕ вызывай его, если в IPacket ниже у тебя
// тоже читается этот же BitStream вторым разом!
// Wrapper: можно использовать, ТОЛЬКО если кроме него НИКТО больше не читает этот BitStream.
// Для "вставки без замены" используй код в README с сохранением оффсета!
stock NC_TryHandlePacket252(playerid, BitStream:bitstream)
{
    new guiid, len;
    if(!BS_ReadValue(bitstream, PR_UINT16, guiid)) return 1;
    if(!BS_ReadValue(bitstream, PR_UINT32, len)) return 1;

    if(len < 1 || len > 2047) return 1;

    new jsonStr[2048];
    if(!BS_ReadValue(bitstream, PR_STRING, jsonStr)) return 1;

    if(guiid != 15) return 1;
    return NC_OnDanceGuiJson(playerid, jsonStr);
}

public NC_ParkingFixTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerInAnyVehicle(playerid)) return 0;

    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 0;

    SetPlayerVirtualWorld(playerid, NC_ParkedVW[playerid]);
    SetPlayerInterior(playerid, NC_GARINT_INT);

    SetVehicleVirtualWorld(veh, NC_ParkedVW[playerid]);
    LinkVehicleToInterior(veh, NC_GARINT_INT);

    SetVehiclePos(veh, NC_GARINT_X, NC_GARINT_Y, NC_GARINT_Z);
    SetVehicleZAngle(veh, NC_GARINT_A);

    PutPlayerInVehicle(playerid, veh, 0);
    SetCameraBehindPlayer(playerid);
    return 1;
}

// ---------- Parking ----------
stock NC_TryEnterParking(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)) return 0;

    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 0;

    // only driver
    if(GetPlayerVehicleSeat(playerid) != 0) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Заезд на парковку только водителю.");
    // outside position save removed (not needed)

    // Use small VW per player for stability
    NC_ParkedVW[playerid] = 100 + playerid;

    // set vehicle first, then player
    SetVehicleVirtualWorld(veh, NC_ParkedVW[playerid]);
    LinkVehicleToInterior(veh, NC_GARINT_INT);
    SetVehiclePos(veh, NC_GARINT_X, NC_GARINT_Y, NC_GARINT_Z);
    SetVehicleZAngle(veh, NC_GARINT_A);

    SetPlayerVirtualWorld(playerid, NC_ParkedVW[playerid]);
    SetPlayerInterior(playerid, NC_GARINT_INT);

    PutPlayerInVehicle(playerid, veh, 0);
    SetCameraBehindPlayer(playerid);

    // exit pickup inside garage (persistent)
    if(NC_GarageExitPickup[playerid] != -1) DestroyPickup(NC_GarageExitPickup[playerid]);
    NC_GarageExitPickup[playerid] = CreatePickup(1318, 23, NC_GARINT_X, NC_GARINT_Y - 5.0, NC_GARINT_Z, NC_ParkedVW[playerid]);

    // small delayed re-apply to avoid "empty interior" / vehicle vanish on some clients
    SetTimerEx("NC_ParkingFixTimer", 350, false, "i", playerid);

    SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Вы въехали на парковку. Подъедьте к пикапу, чтобы выехать.");
    return 1;
}

public NC_ParkingResyncTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerInAnyVehicle(playerid)) return 0;

    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 0;

    SetVehicleVirtualWorld(veh, NC_ParkedVW[playerid]);
    LinkVehicleToInterior(veh, NC_GARAGE_INT);

    SetPlayerVirtualWorld(playerid, NC_ParkedVW[playerid]);
    SetPlayerInterior(playerid, NC_GARAGE_INT);

    SetCameraBehindPlayer(playerid);
    return 1;
}

stock NC_ExitParking(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)) return 1;
    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 1;

    // Всегда выводим на внешний въезд парковки клуба (фиксированные координаты)
    SetVehicleVirtualWorld(veh, 0);
    LinkVehicleToInterior(veh, 0);

    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);

    SetVehiclePos(veh, NC_GARAGE_X, NC_GARAGE_Y, NC_GARAGE_Z);
    SetVehicleZAngle(veh, NC_GARAGE_A);
    PutPlayerInVehicle(playerid, veh, 0);
    SetCameraBehindPlayer(playerid);

    if(NC_GarageExitPickup[playerid] != -1) {
        DestroyPickup(NC_GarageExitPickup[playerid]);
        NC_GarageExitPickup[playerid] = -1;
    }
    return 1;
}

// ---------- Commands ----------
CMD:buyclub(playerid, params[])
{
    if(NC[nc_owner_id] != 0) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Клуб уже куплен.");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, NC_ENTER_X, NC_ENTER_Y, NC_ENTER_Z)) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Подойдите ко входу клуба.");

    if(GetPlayerMoneyEx(playerid) < NC_BUY_PRICE) {
        SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Недостаточно денег. Стоимость: 300000000 руб.");
        return 1;
    }

    GivePlayerMoneyEx(playerid, -NC_BUY_PRICE, "Nightclub purchase", true, true);
    NC[nc_owner_id] = GetPlayerAccountID(playerid);
    format(NC[nc_owner_name], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));

    NC[nc_roof] = 0;
    NC[nc_entry_fee] = 500;
    NC[nc_balance] = 0;
    NC[nc_co1_id] = 0; NC[nc_co2_id] = 0;
    format(NC[nc_co1_name], MAX_PLAYER_NAME, "");
    format(NC[nc_co2_name], MAX_PLAYER_NAME, "");

    NC_Save();
    NC_UpdateEnter3D();

    SendClientMessage(playerid, -1, "{00FF00}Вы успешно приобрели ночной клуб. Используйте /club.");
    return 1;
}

stock NC_ShowOwnerMain(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_NC_OWNER_MAIN, DIALOG_STYLE_LIST, "Ночной клуб MOON",
        "Информация\nНастройки\nУлучшения\nКоманда", "Выбрать", "Закрыть");
    return 1;
}

CMD:club(playerid, params[])
{
    if(!(NC_IsOwner(playerid) || NC_IsCoOwner(playerid))) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Доступно только владельцу/совладельцу.");
    return NC_ShowOwnerMain(playerid);
}

CMD:cyes(playerid, params[])
{
    if(NC_PendingInviteUntil[playerid] < gettime()) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} У вас нет активных приглашений.");
    new uid = GetPlayerAccountID(playerid);
    if(uid == 0) return 1;

    if(NC_PendingInviteSlot[playerid] == 1) {
        NC[nc_co1_id] = uid;
        format(NC[nc_co1_name], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));
    } else {
        NC[nc_co2_id] = uid;
        format(NC[nc_co2_name], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));
    }

    NC_Save();
    NC_UpdateEnter3D();

    NC_PendingInviteUntil[playerid] = 0;
    SendClientMessage(playerid, -1, "{00FF00}Вы стали совладельцем ночного клуба MOON.");
    return 1;
}

CMD:cno(playerid, params[])
{
    if(NC_PendingInviteUntil[playerid] < gettime()) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} У вас нет активных приглашений.");
    NC_PendingInviteUntil[playerid] = 0;
    SendClientMessage(playerid, -1, "{FF0000}Вы отказались от приглашения.");
    return 1;
}

CMD:dancepool(playerid, params[])
{
    if(!NC_IsStripper[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Доступно только работникам (стриптизёр).");
    if(NC_DanceSessionActive[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Вы уже выступаете.");

    new now = gettime();
    if(NC_DanceCooldownUntil[playerid] > now) {
        new left = NC_DanceCooldownUntil[playerid] - now;
        new msg[128];
        format(msg, sizeof msg, "{FFFF00}[MOON]{FFFFFF} Подождите %d сек. до следующего выступления.", left);
        SendClientMessage(playerid, -1, msg);
        return 1;
    }

    SetPlayerInterior(playerid, NC_INSIDE_INT);
    SetPlayerVirtualWorld(playerid, NC_INSIDE_VW);
    SetPlayerPos(playerid, NC_DANCEPOOL_X, NC_DANCEPOOL_Y, NC_DANCEPOOL_Z);
    SetPlayerFacingAngle(playerid, NC_DANCEPOOL_A);
    SetCameraBehindPlayer(playerid);

    NC_DanceRound[playerid] = 1;

    NC_DanceStart(playerid);
    return 1;
}

// ---------- DB load ----------
public NC_OnLoad()
{
    if(cache_num_rows() > 0)
    {
        NC[nc_owner_id] = cache_get_field_content_int(0, "owner_id");
        cache_get_field_content(0, "owner_name", NC[nc_owner_name], MAX_PLAYER_NAME);

        NC[nc_co1_id] = cache_get_field_content_int(0, "co1_id");
        cache_get_field_content(0, "co1_name", NC[nc_co1_name], MAX_PLAYER_NAME);

        NC[nc_co2_id] = cache_get_field_content_int(0, "co2_id");
        cache_get_field_content(0, "co2_name", NC[nc_co2_name], MAX_PLAYER_NAME);

        NC[nc_roof] = cache_get_field_content_int(0, "roof");
        NC[nc_entry_fee] = cache_get_field_content_int(0, "entry_fee");
        NC[nc_balance] = cache_get_field_content_int(0, "balance");
        NC[nc_upg_light] = cache_get_field_content_int(0, "upg_light");
        NC[nc_upg_sound] = cache_get_field_content_int(0, "upg_sound");
        NC[nc_upg_capacity] = cache_get_field_content_int(0, "upg_capacity");
    }
    NC_EnsureDefaults();
    NC_UpdateEnter3D();
    print("[TED_SYSTEM] Система ночного клуба загружена");
    return 1;
}

// ---------- Main callbacks ----------
public NC_OnGameModeInit()
{
    mysql_tquery(mysql, "SELECT * FROM nightclub WHERE id=1 LIMIT 1", "NC_OnLoad");

    NC_EnterPickup = CreatePickup(1318, 23, NC_ENTER_X, NC_ENTER_Y, NC_ENTER_Z, NC_ENTER_VW);
    NC_UpdateEnter3D();

    NC_GaragePickup = CreatePickup(1318, 23, NC_GARAGE_X, NC_GARAGE_Y, NC_GARAGE_Z, 0);
    NC_GarageText = CreateDynamic3DTextLabel("{FFD200}Парковка ночного клуба\n{FFFFFF}Для въезда нажмите на гудок", 0xFFFFFFFF,
        NC_GARAGE_X, NC_GARAGE_Y, NC_GARAGE_Z+0.8, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);

    NC_BarmanJobPickup = CreatePickup(1318, 23, NC_BARMAN_JOB_X, NC_BARMAN_JOB_Y, NC_BARMAN_JOB_Z, 0);
    NC_BarmanOrderPickup = CreatePickup(1318, 23, NC_BARMAN_ORD_X, NC_BARMAN_ORD_Y, NC_BARMAN_ORD_Z, 0);
    NC_StripPickup = CreatePickup(1318, 23, NC_RAZD_X, NC_RAZD_Y, NC_RAZD_Z, 0);

    NC_DanceText = CreateDynamic3DTextLabel("{FFD200}Танцевальный подиум\n{FFFFFF}Для взаимодействия используйте /dancepool", 0xFFFFFFFF,
        NC_DANCE3D_X, NC_DANCE3D_Y, NC_DANCE3D_Z+0.8, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 1);

    NC_ReceptionActor = CreateActor(NC_RECEPTION_SKIN, NC_RECEPT_X, NC_RECEPT_Y, NC_RECEPT_Z, NC_RECEPT_A);
    SetActorVirtualWorld(NC_ReceptionActor, NC_RECEPT_VW);
    SetActorInvulnerable(NC_ReceptionActor, 1);

    NC_ReceptionArea = CreateDynamicCircle(NC_RECEPT_X, NC_RECEPT_Y, 1.7, NC_RECEPT_VW, NC_RECEPT_INT);
    // Green zones: внутри клуба и вокруг входа (снаружи)
NC_GreenOutsideArea = CreateDynamicCircle(NC_ENTER_X, NC_ENTER_Y, 55.0, 0, 0);
NC_GreenInsideArea  = CreateDynamicCircle(NC_INSIDE_X, NC_INSIDE_Y, 120.0, NC_INSIDE_VW, NC_INSIDE_INT);

    return 1;
}

public NC_OnGameModeExit()
{
    NC_Save();
    return 1;
}

public NC_OnPlayerConnect(playerid)
{
    NC_IsBarman[playerid] = false;
    NC_IsStripper[playerid] = false;
    NC_PaidUntil[playerid] = 0;
    NC_GreenCount[playerid] = 0;
    NC_DanceCooldownUntil[playerid] = 0;
    NC_DanceSessionActive[playerid] = false;
    NC_DanceRound[playerid] = 0;
    NC_DanceRoundRetry[playerid] = 0;
    NC_DanceMistakes[playerid] = 0;
    NC_LastInteractTick[playerid] = 0;
    NC_GarageExitPickup[playerid] = -1;
    NC_PendingInviteUntil[playerid] = 0;
    return 1;
}

public NC_OnPlayerDisconnect(playerid, reason)
{
    if(NC_GarageExitPickup[playerid] != -1) {
        DestroyPickup(NC_GarageExitPickup[playerid]);
        NC_GarageExitPickup[playerid] = -1;
    }
    return 1;
}

public NC_OnPlayerPickUpPickup(playerid, pickupid)

{

    if(pickupid == NC_EnterPickup)

    {

        if(!NC_CanInteract(playerid)) return 1;

        return NC_EnterClub(playerid);

    }

    if(pickupid == NC_GaragePickup)

    {

        if(!NC_CanInteract(playerid)) return 1;

        SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} ??? ?????? ?? ???????? ??????? ?? ?????, ???????? ? ????.");

        return 1;

    }

    if(pickupid == NC_BarmanJobPickup)

    {

        if(!NC_CanInteract(playerid)) return 1;

        if(!NC_CanDialog(playerid)) return 1;



        new list[96];

        if(!NC_IsBarman[playerid]) format(list, sizeof list, "?????????? ????????\n???????");

        else format(list, sizeof list, "????????? ? ??????\n???????");



        ShowPlayerDialog(playerid, DIALOG_NC_BARMAN_JOB, DIALOG_STYLE_LIST, "?????? ???????", list, "???????", "??????");

        return 1;

    }

    if(pickupid == NC_BarmanOrderPickup) return NC_OpenBarmanMenu(playerid);

    if(pickupid == NC_StripPickup) return NC_OpenStripperMenu(playerid);

    if(pickupid == NC_GarageExitPickup[playerid]) return NC_ExitParking(playerid);

    return 0;

}



public NC_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_CROUCH) && IsPlayerInAnyVehicle(playerid))
    {
        if(IsPlayerInRangeOfPoint(playerid, 4.0, NC_GARAGE_X, NC_GARAGE_Y, NC_GARAGE_Z))
        {
            NC_TryEnterParking(playerid);
            return 1;
        }
    }
    return 1;
}

public NC_OnPlayerEnterDynamicArea(playerid, areaid)
{
if(areaid == NC_GreenOutsideArea || areaid == NC_GreenInsideArea)
{
    NC_GreenCount[playerid]++;
    NC_SetGreen(playerid, 1);
}


    if(areaid == NC_ReceptionArea) {
        PlayerCurrentAreaType[playerid] = AREA_TYPE_NC_RECEPTION;
        PlayerCurrentAreaID[playerid] = areaid;
        if(NC_CanInteract(playerid)) NC_ToggleInteractionWindow(playerid, true);
        return 1;
    }
    return 1;
}

public NC_OnPlayerLeaveDynamicArea(playerid, areaid)
{
if(areaid == NC_GreenOutsideArea || areaid == NC_GreenInsideArea)
{
    if(NC_GreenCount[playerid] > 0) NC_GreenCount[playerid]--;
    if(NC_GreenCount[playerid] <= 0)
    {
        NC_GreenCount[playerid] = 0;
        NC_SetGreen(playerid, 0);
    }
}


    if(areaid == PlayerCurrentAreaID[playerid] && PlayerCurrentAreaType[playerid] == AREA_TYPE_NC_RECEPTION)
    {
        NC_ToggleInteractionWindow(playerid, false);
        PlayerCurrentAreaType[playerid] = INVALID_AREA_ID;
        PlayerCurrentAreaID[playerid] = -1;
        return 1;
    }
    return 1;
}

stock NC_OnInteractionAction(playerid, action)

{

    if(action != 18) return 0;



    new now = GetTickCount();

    if(now - NC_LastInteractTick[playerid] < 700) return 1;

    NC_LastInteractTick[playerid] = now;



    if(PlayerCurrentAreaType[playerid] == AREA_TYPE_NC_RECEPTION)

    {

        NC_OpenReceptionDialog(playerid);

        return 1;

    }

    return 0;

}



public NC_OnIncomingRPC(playerid, rpcid, BitStream:bs)

{

    if(rpcid != 97) return 1;



    new action;

    if(!BS_ReadUint8(bs, action)) return 1;



    NC_OnInteractionAction(playerid, action);

    return 1;

}



// ---------- Owner dialogs ----------
stock NC_ShowOwnerInfo(playerid)
{
    new roof[64]; NC_GetRoofName(roof, sizeof roof);

    new ownerName[32], co1Name[32], co2Name[32];
    if(NC[nc_owner_id] == 0) format(ownerName, sizeof ownerName, "Нет");
    else format(ownerName, sizeof ownerName, "%s", NC[nc_owner_name]);

    if(NC[nc_co1_id] == 0) format(co1Name, sizeof co1Name, "Нет");
    else format(co1Name, sizeof co1Name, "%s", NC[nc_co1_name]);

    if(NC[nc_co2_id] == 0) format(co2Name, sizeof co2Name, "Нет");
    else format(co2Name, sizeof co2Name, "%s", NC[nc_co2_name]);

    new msg[512];
    format(msg, sizeof msg,
        "Клуб: %s\nВладелец: %s\nСовладелец #1: %s\nСовладелец #2: %s\n%s\nПлата за вход: %d ?\nБаланс клуба: %d ?",
        NC_CLUB_NAME, ownerName, co1Name, co2Name, roof, NC[nc_entry_fee], NC[nc_balance]);

    ShowPlayerDialog(playerid, DIALOG_NC_OWNER_INFO, DIALOG_STYLE_MSGBOX, "MOON | Информация", msg, "Назад", "Закрыть");
    return 1;
}

stock NC_ShowOwnerSettings(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_NC_OWNER_SETTINGS, DIALOG_STYLE_LIST, "MOON | Настройки",
        "Крыша\nПлата за вход", "Выбрать", "Назад");
    return 1;
}

stock NC_ShowOwnerRoof(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_NC_OWNER_ROOF, DIALOG_STYLE_LIST, "MOON | Крыша",
        "Бат ОПГ\nЛыт ОПГ\nАрз ОПГ\nСнять крышу", "Выбрать", "Назад");
    return 1;
}

stock NC_ShowOwnerFee(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_NC_OWNER_FEE, DIALOG_STYLE_INPUT, "MOON | Плата за вход",
        "Введите сумму от 100 до 10000 (?):", "Сохранить", "Назад");
    return 1;
}

stock NC_ShowOwnerUpgr(playerid)
{
    new s[256];
    format(s, sizeof s,
        "Свет (уровень %d)\nЗвук (уровень %d)\nВместимость (уровень %d)",
        NC[nc_upg_light], NC[nc_upg_sound], NC[nc_upg_capacity]);
    ShowPlayerDialog(playerid, DIALOG_NC_OWNER_UPGR, DIALOG_STYLE_LIST, "MOON | Улучшения", s, "Улучшить", "Назад");
    return 1;
}

stock NC_ShowOwnerTeam(playerid)
{
    new co1[32], co2[32];
    if(NC[nc_co1_id] == 0) format(co1, sizeof co1, "Нет");
    else format(co1, sizeof co1, "%s", NC[nc_co1_name]);

    if(NC[nc_co2_id] == 0) format(co2, sizeof co2, "Нет");
    else format(co2, sizeof co2, "%s", NC[nc_co2_name]);

    new s[256];
    format(s, sizeof s, "Добавить совладельца\nУбрать совладельца\n\nТекущие:\n#1: %s\n#2: %s", co1, co2);
    ShowPlayerDialog(playerid, DIALOG_NC_OWNER_TEAM, DIALOG_STYLE_LIST, "MOON | Команда", s, "Выбрать", "Назад");
    return 1;
}

stock NC_InviteCoOwner(playerid, targetid, slot)
{
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Игрок не в сети.");

    NC_PendingInviteSlot[targetid] = slot;
    NC_PendingInviteUntil[targetid] = gettime() + 120;

    new msg[170];
    format(msg, sizeof msg, "{FFFF00}[MOON]{FFFFFF} Вас пригласили стать совладельцем ночного клуба %s. Используйте /cyes или /cno.", NC_CLUB_NAME);
    SendClientMessage(targetid, -1, msg);
    SendClientMessage(playerid, -1, "{00FF00}Приглашение отправлено.");
    return 1;
}

public NC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_NC_OWNER_MAIN)
    {
        if(!response) return 1;
        if(listitem == 0) return NC_ShowOwnerInfo(playerid);
        if(listitem == 1) return NC_ShowOwnerSettings(playerid);
        if(listitem == 2) return NC_ShowOwnerUpgr(playerid);
        if(listitem == 3) return NC_ShowOwnerTeam(playerid);
        return 1;
    }

    if(dialogid == DIALOG_NC_OWNER_INFO)
    {
        if(response) return NC_ShowOwnerMain(playerid);
        return 1;
    }

    if(dialogid == DIALOG_NC_OWNER_SETTINGS)
    {
        if(!response) return NC_ShowOwnerMain(playerid);
        if(listitem == 0) return NC_ShowOwnerRoof(playerid);
        if(listitem == 1) return NC_ShowOwnerFee(playerid);
        return 1;
    }

    if(dialogid == DIALOG_NC_OWNER_ROOF)
    {
        if(!response) return NC_ShowOwnerSettings(playerid);
        if(listitem == 0) NC[nc_roof] = 1;
        else if(listitem == 1) NC[nc_roof] = 2;
        else if(listitem == 2) NC[nc_roof] = 3;
        else NC[nc_roof] = 0;

        NC_Save();
        NC_UpdateEnter3D();
        SendClientMessage(playerid, -1, "{00FF00}Крыша обновлена.");
        return NC_ShowOwnerSettings(playerid);
    }

    if(dialogid == DIALOG_NC_OWNER_FEE)
    {
        if(!response) return NC_ShowOwnerSettings(playerid);
        new fee = strval(inputtext);
        if(fee < 100 || fee > 10000) {
            SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Введите сумму от 100 до 10000 руб.");
            return NC_ShowOwnerFee(playerid);
        }
        NC[nc_entry_fee] = fee;
        NC_Save();
        NC_UpdateEnter3D();
        SendClientMessage(playerid, -1, "{00FF00}Плата за вход обновлена.");
        return NC_ShowOwnerSettings(playerid);
    }

    if(dialogid == DIALOG_NC_OWNER_UPGR)
    {
        if(!response) return NC_ShowOwnerMain(playerid);

        new cost;
        if(listitem == 0) cost = (NC[nc_upg_light] + 1) * 5000000;
        else if(listitem == 1) cost = (NC[nc_upg_sound] + 1) * 7000000;
        else cost = (NC[nc_upg_capacity] + 1) * 9000000;

        if(NC[nc_balance] < cost) {
            new msg[128];
            format(msg, sizeof msg, "{FFFF00}[MOON]{FFFFFF} Недостаточно денег на балансе клуба. Нужно %d руб.", cost);
            SendClientMessage(playerid, -1, msg);
            return NC_ShowOwnerUpgr(playerid);
        }

        NC[nc_balance] -= cost;
        if(listitem == 0) NC[nc_upg_light]++;
        else if(listitem == 1) NC[nc_upg_sound]++;
        else NC[nc_upg_capacity]++;

        NC_Save();
        SendClientMessage(playerid, -1, "{00FF00}Улучшение куплено.");
        return NC_ShowOwnerUpgr(playerid);
    }

    if(dialogid == DIALOG_NC_OWNER_TEAM)
    {
        if(!response) return NC_ShowOwnerMain(playerid);
        if(listitem == 0) {
            ShowPlayerDialog(playerid, DIALOG_NC_OWNER_ADDCO, DIALOG_STYLE_INPUT, "MOON | Добавить совладельца",
                "Введите ID игрока:", "Пригласить", "Назад");
            return 1;
        }
        if(listitem == 1) {
            ShowPlayerDialog(playerid, DIALOG_NC_OWNER_REMCO, DIALOG_STYLE_LIST, "MOON | Убрать совладельца",
                "Убрать #1\nУбрать #2", "Убрать", "Назад");
            return 1;
        }
        return 1;
    }

    if(dialogid == DIALOG_NC_OWNER_ADDCO)
    {
        if(!response) return NC_ShowOwnerTeam(playerid);
        new target = strval(inputtext);
        if(target < 0 || target >= MAX_PLAYERS || !IsPlayerConnected(target)) {
            SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Неверный ID.");
            return NC_ShowOwnerTeam(playerid);
        }

        if(NC[nc_co1_id] == 0) return NC_InviteCoOwner(playerid, target, 1);
        if(NC[nc_co2_id] == 0) return NC_InviteCoOwner(playerid, target, 2);

        SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Уже есть 2 совладельца.");
        return NC_ShowOwnerTeam(playerid);
    }

    if(dialogid == DIALOG_NC_OWNER_REMCO)
    {
        if(!response) return NC_ShowOwnerTeam(playerid);
        if(listitem == 0) { NC[nc_co1_id] = 0; format(NC[nc_co1_name], MAX_PLAYER_NAME, ""); }
        else { NC[nc_co2_id] = 0; format(NC[nc_co2_name], MAX_PLAYER_NAME, ""); }
        NC_Save();
        NC_UpdateEnter3D();
        SendClientMessage(playerid, -1, "{00FF00}Совладелец убран.");
        return NC_ShowOwnerTeam(playerid);
    }

    if(dialogid == DIALOG_NC_RECEPTION)
    {
        if(!response) return 1;
        if(listitem == 0) {
            NC_CanEnter(playerid);
            SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Билет активирован (30 минут).");
        } else if(listitem == 1) {
            new roof[64]; NC_GetRoofName(roof, sizeof roof);
            new msg[256];
            format(msg, sizeof msg, "{FFFF00}[MOON]{FFFFFF} %s | %s | Вход: %d ? | Баланс: %d ?", NC_CLUB_NAME, roof, NC[nc_entry_fee], NC[nc_balance]);
            SendClientMessage(playerid, -1, msg);
        }
        return 1;
    }

    if(dialogid == DIALOG_NC_BARMAN_MENU)
    {
        if(!response) return 1;
        new price;
        new itemName[32];
        if(listitem == 0) { price = 500; format(itemName, sizeof itemName, "Пиво"); }
        else if(listitem == 1) { price = 1500; format(itemName, sizeof itemName, "Виски"); }
        else if(listitem == 2) { price = 2500; format(itemName, sizeof itemName, "Шампанское"); }
        else { price = 5000; format(itemName, sizeof itemName, "Коктейль MOON"); }

        if(GetPlayerMoneyEx(playerid) < price) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Недостаточно денег.");
        GivePlayerMoneyEx(playerid, -price, "Nightclub bar purchase", true, true);
        NC[nc_balance] += price;
        NC_Save();

        new msg[128];
        format(msg, sizeof msg, "{00FF00}Вы купили: %s за %d руб.", itemName, price);
        SendClientMessage(playerid, -1, msg);
        return 1;
    }

    if(dialogid == DIALOG_NC_STRIP_MENU)
    {
        if(!response) return 1;
        if(listitem == 0)
        {
            if(NC_IsStripper[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Вы уже работаете стриптизёром.");
            if(g_player[playerid][P_LEVEL] < 4) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Нужно 4 уровень.");

            NC_IsStripper[playerid] = true;
            NC_SetStripperSkin(playerid);
            SendClientMessage(playerid, -1, "{00FF00}Вы устроились стриптизёром.");
        }
        else
        {
            if(!NC_IsStripper[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}[MOON]{FFFFFF} Вы не работаете стриптизёром.");
            NC_IsStripper[playerid] = false;
            SendClientMessage(playerid, -1, "{FF0000}Вы уволились.");
        }
        return 1;
    }

    if(dialogid == DIALOG_NC_BARMAN_JOB)
{
    if(!response) return 1;
    // listitem 0 = action, 1 = close
    if(listitem == 0)
    {
        if(!NC_IsBarman[playerid])
        {
            NC_IsBarman[playerid] = true;
            SetPlayerSkin(playerid, 128);
            SendClientMessage(playerid, -1, "{00FF00}Вы устроились барменом.");
        }
        else
        {
            NC_IsBarman[playerid] = false;
            SendClientMessage(playerid, -1, "{FF0000}Вы уволились с работы бармена.");
        }
    }
    return 1;
}

return 0;
}
