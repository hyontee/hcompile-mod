#if defined _BR_MINER_JOB_INC_
    #endinput
#endif
#define _BR_MINER_JOB_INC_

forward bool:MinerJob_IsWorking(playerid);
forward bool:MinerJob_IsAtDigPoint(playerid, dig_idx = -1);
forward Player_FixInteriorWorldLeak(playerid);

#if !defined _CUSTOMHUD_FIXED
    #include "../../pawno/include/customhud.inc"
#endif

// =============================================================================
//  Работа шахтёра (BR) — GUI 63 диалог, GUI 26 капча, GUI 31 (g=1 круг + g=2 QTE)
//  Координаты: интерьер шахты (interior 1), по miner by jesus / laird
// =============================================================================

#define MJ_GUI_CAPTCHA          (26)
#define MJ_GUI_MINIGAME         (31)
#define MJ_GUI_NPC              (63)

#define MJ_INTERIOR             (1)
#define MJ_ENTER_DIALOG_ID      (9217)
#define MJ_ROOM_COUNT           (3)
#define MJ_ROOM_CAPACITY        (10)
#define MJ_JOB_SKIN             (16)
#define MJ_MAX_DIG_POINTS       (7)
#define MJ_MAX_CAPTCHA_TRIES    (3)
#define MJ_CAPTCHA_LEN          (5)
#define MJ_DIG_MILESTONE_QTE1   (50)
#define MJ_DIG_MILESTONE_DONE   (100)
#define MJ_DIG_PROGRESS_TICK    (1)
#define MJ_DIG_PROGRESS_TIMER   (100)
#define MJ_MINIGAME_LAYOUT_LOAD (1)  // legacy: круговой прогресс (halloween_game_untie)
#define MJ_MINIGAME_LAYOUT_QTE  (2)  // legacy: полоска + отпечаток (halloween_game_finger)
#define MJ_MINIGAME_HIDE_CLOSE  (1)  // legacy GUIMiniGameEventsGame: x=1 скрывает кнопку X
#define MJ_QTE_MAX_MISSES       (5)
#define MJ_PVAR_MINI_MODE       "MinerJobMiniMode"
#define MJ_PVAR_PROG_TIMER      "MinerJobProgTimer"
#define MJ_PVAR_MILESTONE_DONE  "MinerJobMilestoneDone"
#define MJ_QTE_OPEN_DELAY_MS    (650)
// HUD заработка через готовый moneytd
#define MJ_EARN_HUD_PARTS       (2)
#define MJ_EARN_HUD_BG          (0)
#define MJ_EARN_HUD_TEXT        (1)
#define MJ_EARN_HUD_BG_X        (10.0)
#define MJ_EARN_HUD_BG_Y        (166.0)
#define MJ_EARN_HUD_BG_W        (102.0)
#define MJ_EARN_HUD_BG_H        (17.0)
#define MJ_EARN_HUD_BG_SPRITE   "txd:moneytd"
#define MJ_EARN_HUD_TEXT_X      (38.0)
#define MJ_EARN_HUD_TEXT_Y      (169.2)
#define MJ_EARN_HUD_TEXT_LX     (0.25)
#define MJ_EARN_HUD_TEXT_LY     (1.08)
#define MJ_EARN_HUD_TEXT_COLOR  (0xFFFFFFFF)
#define MJ_ATTACH_PICKAXE       (1)
#define MJ_ATTACH_ORE           (2)

#define MJ_BTN_YES              (1)
#define MJ_BTN_NO               (2)

#define MJ_STATE_NONE           (0)
#define MJ_STATE_CAPTCHA        (1)
#define MJ_STATE_WORKING        (2)
#define MJ_STATE_MINING         (3)
#define MJ_STATE_CARRY_ORE      (4)

#define MJ_DLG_HIRE             (1)
#define MJ_DLG_QUIT             (2)

#define MJ_PVAR_NPC_OPEN        "MinerJobNpcOpen"
#define MJ_PVAR_INTERACT_CD     "MinerJobInteractCd"
#define MJ_PVAR_ENTER_CD        "MinerJobEnterCd"
#define MJ_PVAR_ENTER_DLG_OPEN  "MinerJobEnterDlgOpen"
#define MJ_INTERACT_CD_SEC      (6)
#define MJ_ENTER_CD_SEC         (3)

#define MJ_PVAR_FOREMAN_NOTIFY  "MinerForemanNotify"
#define MJ_PVAR_GREEN_ZONE      "MinerInGreenZone"
#define MJ_LOCKER_AREA_RADIUS   (4.5)
#define MJ_GREEN_ZONE_RADIUS    (58.0)
#define MJ_GREEN_ZONE_NAME      "Шахта"
#define MJ_GZ_WARN_CD_SEC       (4)
#define MJ_PVAR_GZ_WARN_CD      "MinerGZWarnCd"

#define MJ_COL_ORANGE           "{E0584B}"
#define MJ_COL_WHITE            "{FFFFFF}"
#define MJ_COL_GOLD             "{FFCD00}"
#define MJ_COL_GREEN            "{00FF00}"
#define MJ_PREFIX               MJ_COL_ORANGE "[Шахта] " MJ_COL_WHITE

enum E_MINER_PLAYER
{
    mj_State,
    mj_DialogMode,
    mj_CaptchaAttempts,
    mj_DigProgress,
    mj_DigPoint,
    bool:mj_HasOre,
    mj_OreWeight,
    mj_SessionOreKg,
    mj_SessionEarned,
    mj_SavedSkin,
    mj_DigAnimTimer,
    mj_DeliverLock,
    mj_DeliverCount,
    mj_QtePassed,
    mj_QteMissLeft
};

new MinerPlayer[MAX_PLAYERS][E_MINER_PLAYER];
new MinerPlayerCaptcha[MAX_PLAYERS][MJ_CAPTCHA_LEN + 1];
new PlayerText:moneytd[MAX_PLAYERS][MJ_EARN_HUD_PARTS];
new bool:MinerEarnHudOn[MAX_PLAYERS];

new MinerPickupEnter;
new MinerPickupExit;
new STREAMER_TAG_ACTOR:MinerActorForeman[MJ_ROOM_COUNT];
new STREAMER_TAG_AREA:MinerAreaForeman;
new STREAMER_TAG_AREA:MinerAreaGreenZone;
new Text3D:MinerLabelEnter;
new Text3D:MinerLabelExit;
new Text3D:MinerLabelForeman;
new Text3D:MinerLabelDig[MJ_MAX_DIG_POINTS];
new Text3D:MinerLabelConveyor;

new STREAMER_TAG_AREA:MinerAreaDig[MJ_MAX_DIG_POINTS];
new STREAMER_TAG_AREA:MinerAreaConveyor;
new STREAMER_TAG_CP:MinerCPGuide[MAX_PLAYERS];

static const Float:MinerDigPos[MJ_MAX_DIG_POINTS][3] =
{
    {550.5598, 541.8028, 998.6555},
    {553.0218, 542.6298, 998.6711},
    {554.4490, 544.1111, 998.7049},
    {557.2224, 544.2178, 998.6926},
    {559.3512, 544.1144, 998.6926},
    {575.8900, 541.1766, 998.6555},
    {575.5040, 539.0059, 998.6484}
};

static const Float:MinerConveyorPos[4] = {557.3574, 516.0079, 999.7136, 91.8346};
// Прораб Кирилл (int 1, vw 0)
static const Float:MinerForemanPos[4] = {540.2032, 514.1591, 1000.3195, 93.9685};

// Вход на улице (int 0, vw 0) — по метке на скрине
static const Float:MinerEnterWorldPos[4] =
    {2378.7800, 1677.6953, 15.2829, 172.7322};
static const MinerRoomVW[MJ_ROOM_COUNT] = {2, 4, 6};
// Точка появления внутри шахты (int 1)
static const Float:MinerEnterInteriorPos[4] =
    {522.987304, 517.629821, 1000.336730, 180.6500};
// Выход из шахты (int 1) -> мир
static const Float:MinerExitInteriorPos[3] =
    {519.045959, 517.649047, 1000.347412};
static const Float:MinerExitWorldPos[4] =
    {2378.930664, 1675.177856, 15.254065, 172.7322};
// Зелёная зона — весь интерьер шахты (шкафчики, добыча, конвейер, выход)
static const Float:MinerGreenZoneCenter[3] = {547.0, 530.0, 999.5};

forward MinerJob_DigAnimTick(playerid);
forward MinerJob_UnlockDeliver(playerid);
forward MinerJob_FixForemanActor();
forward MinerJob_DelayedGreenSync(playerid);
forward MinerJob_ProgressBackup(playerid);
forward MinerJob_MiningShowQte(playerid, reset_chances);
forward MinerJob_MiningOpenQte(playerid);

// -----------------------------------------------------------------------------
stock MinerJob_ResetPlayer(playerid)
{
    MinerPlayer[playerid][mj_State] = MJ_STATE_NONE;
    MinerPlayer[playerid][mj_DialogMode] = 0;
    MinerPlayer[playerid][mj_CaptchaAttempts] = 0;
    MinerPlayer[playerid][mj_DigProgress] = 0;
    MinerPlayer[playerid][mj_DigPoint] = -1;
    MinerPlayer[playerid][mj_HasOre] = false;
    MinerPlayer[playerid][mj_OreWeight] = 0;
    MinerPlayer[playerid][mj_SessionOreKg] = 0;
    MinerPlayer[playerid][mj_SessionEarned] = 0;
    MinerPlayer[playerid][mj_SavedSkin] = 0;
    MinerPlayer[playerid][mj_DigAnimTimer] = -1;
    MinerPlayer[playerid][mj_DeliverLock] = 0;
    MinerPlayer[playerid][mj_DeliverCount] = 0;
    MinerPlayer[playerid][mj_QtePassed] = 0;
    MinerPlayer[playerid][mj_QteMissLeft] = 0;
    MinerPlayerCaptcha[playerid][0] = EOS;

    if(MinerCPGuide[playerid] != STREAMER_TAG_CP:INVALID_STREAMER_ID)
    {
        DestroyDynamicCP(MinerCPGuide[playerid]);
        MinerCPGuide[playerid] = STREAMER_TAG_CP:INVALID_STREAMER_ID;
    }

    if(IsPlayerAttachedObjectSlotUsed(playerid, MJ_ATTACH_PICKAXE))
        RemovePlayerAttachedObject(playerid, MJ_ATTACH_PICKAXE);
    if(IsPlayerAttachedObjectSlotUsed(playerid, MJ_ATTACH_ORE))
        RemovePlayerAttachedObject(playerid, MJ_ATTACH_ORE);

    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);
    DeletePVar(playerid, "MinerJobMiniOpen");
    DeletePVar(playerid, MJ_PVAR_MINI_MODE);
    DeletePVar(playerid, "MinerJobDigTarget");
    DeletePVar(playerid, MJ_PVAR_PROG_TIMER);
    DeletePVar(playerid, MJ_PVAR_MILESTONE_DONE);
    DeletePVar(playerid, MJ_PVAR_NPC_OPEN);
    DeletePVar(playerid, MJ_PVAR_INTERACT_CD);
    DeletePVar(playerid, MJ_PVAR_ENTER_CD);
    DeletePVar(playerid, MJ_PVAR_ENTER_DLG_OPEN);
    DeletePVar(playerid, MJ_PVAR_FOREMAN_NOTIFY);
    DeletePVar(playerid, MJ_PVAR_GZ_WARN_CD);
    MinerJob_DestroyEarnHud(playerid);
    MinerJob_UpdateGreenZone(playerid);
    SetTimerEx("MinerJob_DelayedGreenSync", 300, false, "i", playerid);
    return 1;
}

stock MinerJob_FormatRubles(amount, dest[], size = sizeof dest)
{
    format(dest, size, "%d", amount < 0 ? -amount : amount);
    for(new i = strlen(dest); (i -= 3) > 0;)
        strins(dest, " ", i, size);
    return 1;
}

stock MinerJob_DestroyEarnHud(playerid)
{
    HideShiftEarnHud(playerid);
    for(new i = 0; i < MJ_EARN_HUD_PARTS; i++)
    {
        if(moneytd[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawDestroy(playerid, moneytd[playerid][i]);
            moneytd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    MinerEarnHudOn[playerid] = false;
    return 1;
}

stock MinerJob_HideEarnHud(playerid)
{
    if(!MinerEarnHudOn[playerid])
        return 0;

    for(new i = 0; i < MJ_EARN_HUD_PARTS; i++)
    {
        if(moneytd[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
            PlayerTextDrawHide(playerid, moneytd[playerid][i]);
    }
    MinerEarnHudOn[playerid] = false;
    return 1;
}

stock MinerJob_CreateEarnHud(playerid)
{
    if(moneytd[playerid][MJ_EARN_HUD_BG] != PlayerText:INVALID_TEXT_DRAW)
        return 1;

    moneytd[playerid][MJ_EARN_HUD_BG] = CreatePlayerTextDraw(playerid, MJ_EARN_HUD_BG_X, MJ_EARN_HUD_BG_Y, MJ_EARN_HUD_BG_SPRITE);
    PlayerTextDrawLetterSize(playerid, moneytd[playerid][MJ_EARN_HUD_BG], 0.0, 0.0);
    PlayerTextDrawTextSize(playerid, moneytd[playerid][MJ_EARN_HUD_BG], MJ_EARN_HUD_BG_W, MJ_EARN_HUD_BG_H);
    PlayerTextDrawAlignment(playerid, moneytd[playerid][MJ_EARN_HUD_BG], 1);
    PlayerTextDrawColor(playerid, moneytd[playerid][MJ_EARN_HUD_BG], -1);
    PlayerTextDrawBackgroundColor(playerid, moneytd[playerid][MJ_EARN_HUD_BG], 255);
    PlayerTextDrawFont(playerid, moneytd[playerid][MJ_EARN_HUD_BG], 4);
    PlayerTextDrawSetProportional(playerid, moneytd[playerid][MJ_EARN_HUD_BG], 0);
    PlayerTextDrawSetShadow(playerid, moneytd[playerid][MJ_EARN_HUD_BG], 0);

    moneytd[playerid][MJ_EARN_HUD_TEXT] = CreatePlayerTextDraw(playerid,
        MJ_EARN_HUD_TEXT_X, MJ_EARN_HUD_TEXT_Y, "0 P");
    PlayerTextDrawLetterSize(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT],
        MJ_EARN_HUD_TEXT_LX, MJ_EARN_HUD_TEXT_LY);
    PlayerTextDrawAlignment(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], 1);
    PlayerTextDrawColor(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], MJ_EARN_HUD_TEXT_COLOR);
    PlayerTextDrawBackgroundColor(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], 255);
    PlayerTextDrawFont(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], 2);
    PlayerTextDrawSetProportional(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], 1);
    PlayerTextDrawSetShadow(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], 0);
    PlayerTextDrawSetOutline(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], 1);
    return 1;
}

stock MinerJob_ShowEarnHudLayers(playerid)
{
    if(moneytd[playerid][MJ_EARN_HUD_BG] == PlayerText:INVALID_TEXT_DRAW)
        return 0;

    PlayerTextDrawShow(playerid, moneytd[playerid][MJ_EARN_HUD_BG]);
    PlayerTextDrawShow(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT]);
    return 1;
}

stock MinerJob_UpdateEarnHud(playerid)
{
    if(!MinerJob_IsWorking(playerid))
        return 0;

    new label[48];
    MinerJob_FormatRubles(MinerPlayer[playerid][mj_SessionEarned], label, sizeof label);

    if(moneytd[playerid][MJ_EARN_HUD_TEXT] == PlayerText:INVALID_TEXT_DRAW)
        MinerJob_CreateEarnHud(playerid);

    strcat(label, " P", sizeof label);
    PlayerTextDrawSetString(playerid, moneytd[playerid][MJ_EARN_HUD_TEXT], label);

    if(MinerEarnHudOn[playerid])
        MinerJob_ShowEarnHudLayers(playerid);
    return 1;
}

stock MinerJob_ShowEarnHud(playerid)
{
    if(!MinerJob_IsWorking(playerid))
        return 0;

    HideShiftEarnHud(playerid);
    MinerJob_DestroyEarnHud(playerid);
    MinerJob_CreateEarnHud(playerid);
    MinerJob_UpdateEarnHud(playerid);
    MinerJob_ShowEarnHudLayers(playerid);
    MinerEarnHudOn[playerid] = true;
    return 1;
}

stock bool:MinerJob_IsInMineGreenZone(playerid)
{
    if(GetPlayerInterior(playerid) != MJ_INTERIOR)
        return false;
    if(GetPlayerVirtualWorld(playerid) != 0)
        return false;
    return (IsPlayerInRangeOfPoint(playerid, MJ_GREEN_ZONE_RADIUS,
        MinerGreenZoneCenter[0], MinerGreenZoneCenter[1], MinerGreenZoneCenter[2]) != 0);
}

stock bool:MinerJob_PlayerInGreenZone(playerid)
{
    return (MinerJob_IsInMineGreenZone(playerid) || GetPVarInt(playerid, MJ_PVAR_GREEN_ZONE) == 1);
}

// BR client: RPC 168 — полная блокировка удара/стрельбы (как SetGreenZoneForPlayer в laird)
stock MinerJob_SetClientCombatLock(playerid, bool:lock)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    new BitStream:bs = BS_New();
    if(!bs)
        return 0;

    BS_WriteValue(bs, PR_UINT8, 6);
    BS_WriteValue(bs, PR_UINT16, playerid);
    BS_WriteValue(bs, PR_UINT8, lock ? 1 : 0);
    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock MinerJob_WarnGreenZoneAttack(playerid)
{
    if(GetPVarInt(playerid, MJ_PVAR_GZ_WARN_CD) > gettime())
        return 0;

    SetPVarInt(playerid, MJ_PVAR_GZ_WARN_CD, gettime() + MJ_GZ_WARN_CD_SEC);

    new msg[160];
    format(msg, sizeof msg,
        MJ_PREFIX "{FFFFFF}В зелёной зоне «%s%s%s» удары и стрельба запрещены.",
        MJ_COL_GREEN, MJ_GREEN_ZONE_NAME, MJ_COL_WHITE);
    SendClientMessage(playerid, 0xFF5533FF, msg);

    if(!IsPlayerInAnyVehicle(playerid))
    {
        ClearAnimations(playerid);
        ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0, 1);
    }
    return 1;
}

stock MinerJob_UpdateGreenZone(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    if(MinerJob_IsInMineGreenZone(playerid))
    {
        if(GetPVarInt(playerid, MJ_PVAR_GREEN_ZONE) != 1)
        {
            SetPVarInt(playerid, MJ_PVAR_GREEN_ZONE, 1);
            ShowZona(playerid);
            MinerJob_SetClientCombatLock(playerid, true);
        }
        return 1;
    }

    if(GetPVarInt(playerid, MJ_PVAR_GREEN_ZONE) == 1)
        MinerJob_LeaveGreenZone(playerid);
    return 0;
}

public MinerJob_DelayedGreenSync(playerid)
{
    new ret = MinerJob_UpdateGreenZone(playerid);
    if(MinerJob_PlayerInGreenZone(playerid))
        MinerJob_SetClientCombatLock(playerid, true);
    return ret;
}

stock MinerJob_EnterGreenZone(playerid)
{
    if(!MinerJob_IsInMineGreenZone(playerid))
        return 0;
    if(GetPVarInt(playerid, MJ_PVAR_GREEN_ZONE) == 1)
        return 0;

    SetPVarInt(playerid, MJ_PVAR_GREEN_ZONE, 1);
    ShowZona(playerid);
    MinerJob_SetClientCombatLock(playerid, true);
    return 1;
}

stock MinerJob_LeaveGreenZone(playerid)
{
    if(GetPVarInt(playerid, MJ_PVAR_GREEN_ZONE) != 1)
        return 0;

    DeletePVar(playerid, MJ_PVAR_GREEN_ZONE);
    HideZona(playerid);
    MinerJob_SetClientCombatLock(playerid, false);
    return 1;
}

stock MinerJob_OnTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount, weaponid, bodypart

    if(!MinerJob_PlayerInGreenZone(playerid))
        return 1;

    if(issuerid != INVALID_PLAYER_ID && IsPlayerConnected(issuerid))
    {
        MinerJob_WarnGreenZoneAttack(issuerid);
        return 0;
    }
    return 1;
}

stock MinerJob_OnGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount, weaponid, bodypart

    if(MinerJob_PlayerInGreenZone(playerid))
    {
        MinerJob_WarnGreenZoneAttack(playerid);
        return 0;
    }

    if(damagedid != INVALID_PLAYER_ID && MinerJob_PlayerInGreenZone(damagedid))
    {
        MinerJob_WarnGreenZoneAttack(playerid);
        return 0;
    }
    return 1;
}

stock MinerJob_OnWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    #pragma unused weaponid, fX, fY, fZ

    if(MinerJob_PlayerInGreenZone(playerid))
    {
        MinerJob_WarnGreenZoneAttack(playerid);
        return 0;
    }

    if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
    {
        if(MinerJob_PlayerInGreenZone(hitid))
        {
            MinerJob_WarnGreenZoneAttack(playerid);
            return 0;
        }
    }
    return 1;
}

stock MinerJob_OnKeyStateChange(playerid, newkeys, oldkeys)
{
    if(!MinerJob_PlayerInGreenZone(playerid))
        return 1;

    if(newkeys & KEY_FIRE)
    {
        MinerJob_WarnGreenZoneAttack(playerid);
    }
    #pragma unused oldkeys
    return 1;
}

stock MinerJob_CloseNpcDialog(playerid)
{
    if(GetPVarInt(playerid, MJ_PVAR_NPC_OPEN))
    {
        MinerJob_CloseGui(playerid, MJ_GUI_NPC);
        DeletePVar(playerid, MJ_PVAR_NPC_OPEN);
    }
    return 1;
}

stock MinerJob_SetInteractCooldown(playerid)
{
    SetPVarInt(playerid, MJ_PVAR_INTERACT_CD, gettime() + MJ_INTERACT_CD_SEC);
    MinerJob_HideForemanNotify(playerid);
    MinerJob_CloseNpcDialog(playerid);
    return 1;
}

stock bool:MinerJob_CanInteract(playerid)
{
    if(GetPVarInt(playerid, MJ_PVAR_NPC_OPEN))
        return false;
    if(GetPVarInt(playerid, MJ_PVAR_INTERACT_CD) > gettime())
        return false;
    if(MinerPlayer[playerid][mj_State] == MJ_STATE_CAPTCHA)
        return false;
    if(GetPVarInt(playerid, "MinerJobMiniOpen") == 1)
        return false;
    return true;
}

stock bool:MinerJob_IsWorking(playerid)
{
    return (MinerPlayer[playerid][mj_State] >= MJ_STATE_WORKING);
}

stock MinerJob_GenerateCaptcha(dest[])
{
    new const chars[] = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    for(new i; i < MJ_CAPTCHA_LEN; i++)
        dest[i] = chars[random(sizeof(chars) - 1)];
    dest[MJ_CAPTCHA_LEN] = EOS;
}

stock MinerJob_ShowCaptcha(playerid)
{
    MinerJob_GenerateCaptcha(MinerPlayerCaptcha[playerid]);
    MinerPlayer[playerid][mj_State] = MJ_STATE_CAPTCHA;

    new url[144];
    format(url, sizeof url,
        "https://dummyimage.com/200x80/ffffff/000000.png&text=%s",
        MinerPlayerCaptcha[playerid]);

    new Node:json = JSON_Object();
    JSON_SetString(json, "u", url);
    ShowPlayerGUI(playerid, MJ_GUI_CAPTCHA, json);
    JSON_Cleanup(json);
    return 1;
}

stock MinerJob_CloseGui(playerid, guiid)
{
    new Node:close_json = JSON_Object();
    HidePlayerGUI(playerid, guiid, close_json);
    JSON_Cleanup(close_json);
    return 1;
}

stock Node:MinerJob_BuildNpcButton(text[], bt, bk)
{
    return JSON_Object(
        "bn", JSON_String(text),
        "bt", JSON_Int(bt),
        "bk", JSON_Int(bk)
    );
}

stock MinerJob_ShowNpcDialog(playerid, title[], desc[], dialog_mode)
{
    if(!MinerJob_CanInteract(playerid))
        return 0;

    MinerPlayer[playerid][mj_DialogMode] = dialog_mode;
    SetPVarInt(playerid, MJ_PVAR_NPC_OPEN, 1);

    new Node:buttons;
    if(dialog_mode == MJ_DLG_HIRE)
    {
        buttons = JSON_Array(
            MinerJob_BuildNpcButton("Да", 1, MJ_BTN_YES),
            MinerJob_BuildNpcButton("Нет", 2, MJ_BTN_NO)
        );
    }
    else
    {
        buttons = JSON_Array(
            MinerJob_BuildNpcButton("Уволиться", 1, MJ_BTN_YES),
            MinerJob_BuildNpcButton("Отмена", 2, MJ_BTN_NO)
        );
    }

    new Node:json = JSON_Object();
    JSON_SetString(json, "n", title, strlen(title));
    JSON_SetString(json, "d", desc, strlen(desc));
    JSON_SetInt(json, "ts", 0);
    JSON_SetInt(json, "st", 1);
    JSON_SetInt(json, "m", MJ_JOB_SKIN);
    JSON_SetArray(json, "b", buttons);

    ShowPlayerGUI(playerid, MJ_GUI_NPC, json);
    JSON_Cleanup(json);
    JSON_Cleanup(buttons);
    return 1;
}

stock MinerJob_IsNearForemanZone(playerid)
{
    if(GetPlayerInterior(playerid) != MJ_INTERIOR)
        return false;
    return (IsPlayerInRangeOfPoint(playerid, MJ_LOCKER_AREA_RADIUS,
        MinerForemanPos[0], MinerForemanPos[1], MinerForemanPos[2]) != 0);
}

stock MinerJob_ShowForemanNotify(playerid)
{
    if(!MinerJob_IsNearForemanZone(playerid))
        return 0;
    if(!MinerJob_CanInteract(playerid))
        return 0;
    if(GetPVarInt(playerid, MJ_PVAR_FOREMAN_NOTIFY) == 1)
        return 0;

    SetPVarInt(playerid, MJ_PVAR_FOREMAN_NOTIFY, 1);
    ToggleInteractionWindow(playerid, true);
    return 1;
}

stock MinerJob_HideForemanNotify(playerid)
{
    if(GetPVarInt(playerid, MJ_PVAR_FOREMAN_NOTIFY))
        DeletePVar(playerid, MJ_PVAR_FOREMAN_NOTIFY);
    if(GetPVarInt(playerid, MJ_PVAR_NPC_OPEN) != 1)
        HideInteractionWindow(playerid);
    return 1;
}

stock MinerJob_TryInteractKey(playerid)
{
    if(!MinerJob_IsNearForemanZone(playerid))
        return 0;
    if(!MinerJob_CanInteract(playerid))
        return 0;

    MinerJob_HideForemanNotify(playerid);
    if(MinerJob_IsWorking(playerid))
        return MinerJob_ShowQuitDialog(playerid);
    return MinerJob_ShowHireDialog(playerid);
}

stock MinerJob_ShowHireDialog(playerid)
{
    if(MinerJob_IsWorking(playerid))
    {
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "Вы уже работаете шахтёром.");
        return 0;
    }
    return MinerJob_ShowNpcDialog(playerid,
        "Трудоустройство",
        "Вы хотите устроиться на работу шахтёра?",
        MJ_DLG_HIRE);
}

stock MinerJob_ShowQuitDialog(playerid)
{
    if(!MinerJob_IsWorking(playerid))
    {
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "Вы не устроены на работу шахтёра.");
        return 0;
    }
    if(MinerPlayer[playerid][mj_HasOre])
    {
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "Сначала сдайте руду на конвейер.");
        return 0;
    }
    if(MinerPlayer[playerid][mj_State] == MJ_STATE_MINING)
    {
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "Завершите раскопку руды.");
        return 0;
    }

    new desc[160];
    format(desc, sizeof desc,
        "Завершить рабочий день?\nДобыто: "MJ_COL_GOLD"%d кг"MJ_COL_WHITE" | Заработано: "MJ_COL_GOLD"%d руб.",
        MinerPlayer[playerid][mj_SessionOreKg],
        MinerPlayer[playerid][mj_SessionEarned]);
    return MinerJob_ShowNpcDialog(playerid, "Прораб Кирилл", desc, MJ_DLG_QUIT);
}

stock MinerJob_EquipWorkGear(playerid)
{
    MinerPlayer[playerid][mj_SavedSkin] = Player[playerid][pSkin];
    SetPlayerSkin(playerid, MJ_JOB_SKIN);

    if(IsPlayerAttachedObjectSlotUsed(playerid, MJ_ATTACH_PICKAXE))
        RemovePlayerAttachedObject(playerid, MJ_ATTACH_PICKAXE);
    SetPlayerAttachedObject(playerid, MJ_ATTACH_PICKAXE, 18634, 6,
        0.07, 0.03, 0.04, 0.0, 270.0, 270.0, 1.0, 1.0, 1.0);
    return 1;
}

stock MinerJob_RemoveWorkGear(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, MJ_ATTACH_PICKAXE))
        RemovePlayerAttachedObject(playerid, MJ_ATTACH_PICKAXE);
    if(IsPlayerAttachedObjectSlotUsed(playerid, MJ_ATTACH_ORE))
        RemovePlayerAttachedObject(playerid, MJ_ATTACH_ORE);

    if(MinerPlayer[playerid][mj_SavedSkin] > 0)
        SetPlayerSkin(playerid, MinerPlayer[playerid][mj_SavedSkin]);
    else
        SetPlayerSkin(playerid, Player[playerid][pSkin]);
    return 1;
}

stock MinerJob_AttachOre(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, MJ_ATTACH_ORE))
        RemovePlayerAttachedObject(playerid, MJ_ATTACH_ORE);
    // Руда (1458) в правой руке, подогнанная под размер
    SetPlayerAttachedObject(playerid, MJ_ATTACH_ORE, 1458, 6,
        0.09, 0.06, 0.02, 0.0, 90.0, 0.0, 0.30, 0.30, 0.28);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 0, 1, 1, 1, 1);
    return 1;
}

stock MinerJob_ClearGuideCP(playerid)
{
    if(MinerCPGuide[playerid] != STREAMER_TAG_CP:INVALID_STREAMER_ID)
    {
        DestroyDynamicCP(MinerCPGuide[playerid]);
        MinerCPGuide[playerid] = STREAMER_TAG_CP:INVALID_STREAMER_ID;
    }
    DisablePlayerCheckpoint(playerid);
    return 1;
}

stock MinerJob_SetGuideToDig(playerid)
{
    MinerJob_ClearGuideCP(playerid);
    new idx = random(MJ_MAX_DIG_POINTS);
    MinerPlayer[playerid][mj_DigPoint] = idx;

    MinerCPGuide[playerid] = CreateDynamicCP(
        MinerDigPos[idx][0], MinerDigPos[idx][1], MinerDigPos[idx][2],
        2.0, -1, MJ_INTERIOR, -1, playerid + 1);

    SetPlayerCheckpoint(playerid,
        MinerDigPos[idx][0], MinerDigPos[idx][1], MinerDigPos[idx][2], 2.0);
    return 1;
}

stock MinerJob_SetGuideToConveyor(playerid)
{
    MinerJob_ClearGuideCP(playerid);

    MinerCPGuide[playerid] = CreateDynamicCP(
        MinerConveyorPos[0], MinerConveyorPos[1], MinerConveyorPos[2],
        2.0, -1, MJ_INTERIOR, -1, playerid + 1);

    SetPlayerCheckpoint(playerid,
        MinerConveyorPos[0], MinerConveyorPos[1], MinerConveyorPos[2], 2.0);
    return 1;
}

stock MinerJob_StartWork(playerid)
{
    MinerPlayer[playerid][mj_State] = MJ_STATE_WORKING;
    MinerPlayer[playerid][mj_CaptchaAttempts] = 0;
    MinerPlayer[playerid][mj_DigProgress] = 0;
    MinerPlayer[playerid][mj_HasOre] = false;
    MinerPlayer[playerid][mj_OreWeight] = 0;
    MinerPlayer[playerid][mj_SessionOreKg] = 0;
    MinerPlayer[playerid][mj_SessionEarned] = 0;
    MinerPlayer[playerid][mj_DeliverCount] = 0;

    MinerJob_EquipWorkGear(playerid);
    MinerJob_SetGuideToDig(playerid);

    SendClientMessage(playerid, COLOR_WHITE,
        MJ_PREFIX "{00FF00}Вы устроились шахтёром. {FFFFFF}Следуйте к метке и начните раскопку.");
    ShowNotification(playerid, 1, 5, 1, 0, "Работа шахтёра начата", "");
    MinerJob_ShowEarnHud(playerid);
    return 1;
}

stock MinerJob_EndWork(playerid, bool:pay = true)
{
    new total_kg = MinerPlayer[playerid][mj_SessionOreKg];
    new total_pay = MinerPlayer[playerid][mj_SessionEarned];

    if(pay && total_pay > 0)
        GivePlayerMoneyEx(playerid, total_pay);

    new msg[192];
    format(msg, sizeof msg,
        "Ваш рабочий день завершён. Было добыто %d кг руды и заработано %d рублей.",
        total_kg, total_pay);
    ShowNotification(playerid, 1, 6, 1, 0, msg, "");

    format(msg, sizeof msg, MJ_PREFIX "%s", msg);
    SendClientMessage(playerid, COLOR_WHITE, msg);

    MinerJob_RemoveWorkGear(playerid);
    MinerJob_ResetPlayer(playerid);
    return 1;
}

stock MinerJob_KillProgressBackup(playerid)
{
    new tid = GetPVarInt(playerid, MJ_PVAR_PROG_TIMER);
    if(tid > 0)
        KillTimer(tid);
    DeletePVar(playerid, MJ_PVAR_PROG_TIMER);
}

stock MinerJob_CalcProgressDuration(start_pct, end_pct)
{
    new steps = (end_pct - start_pct) / MJ_DIG_PROGRESS_TICK;
    if(steps < 1)
        steps = 1;
    return (steps * MJ_DIG_PROGRESS_TIMER) + MJ_DIG_PROGRESS_TIMER + 200;
}

stock MinerJob_TriggerDigMilestone(playerid)
{
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;

    new target = GetPVarInt(playerid, "MinerJobDigTarget");
    if(target != MJ_DIG_MILESTONE_QTE1 && target != MJ_DIG_MILESTONE_DONE)
        return 0;

    if(GetPVarInt(playerid, MJ_PVAR_MILESTONE_DONE) == target)
        return 0;
    SetPVarInt(playerid, MJ_PVAR_MILESTONE_DONE, target);

    MinerJob_KillProgressBackup(playerid);
    DeletePVar(playerid, "MinerJobMiniOpen");
    DeletePVar(playerid, MJ_PVAR_MINI_MODE);

    if(!MinerJob_IsAtDigPoint(playerid))
    {
        DeletePVar(playerid, "MinerJobDigTarget");
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "{E0584B}Вы отошли от места добычи.");
        MinerJob_CancelMining(playerid, true);
        MinerJob_SetGuideToDig(playerid);
        return 0;
    }

    MinerPlayer[playerid][mj_DigProgress] = target;
    DeletePVar(playerid, "MinerJobDigTarget");

    new msg[128];
    if(target == MJ_DIG_MILESTONE_DONE)
        format(msg, sizeof msg,
            MJ_PREFIX "{FFFFFF}Финальный этап: отпечаток в зелёной зоне. Попыток: {00FF00}%d",
            MJ_QTE_MAX_MISSES);
    else
        format(msg, sizeof msg,
            MJ_PREFIX "{FFFFFF}50%% — нажмите отпечаток в зелёной зоне. Попыток: {00FF00}%d",
            MJ_QTE_MAX_MISSES);
    SendClientMessage(playerid, COLOR_WHITE, msg);

    MinerJob_CloseGui(playerid, MJ_GUI_MINIGAME);
    SetTimerEx("MinerJob_MiningShowQte", MJ_QTE_OPEN_DELAY_MS, false, "ii", playerid, 1);
    return 1;
}

stock MinerJob_ShowDigProgress(playerid, end_percent)
{
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;

    MinerJob_KillProgressBackup(playerid);
    DeletePVar(playerid, MJ_PVAR_MILESTONE_DONE);

    SetPVarInt(playerid, "MinerJobMiniOpen", 1);
    SetPVarInt(playerid, MJ_PVAR_MINI_MODE, MJ_MINIGAME_LAYOUT_LOAD);
    SetPVarInt(playerid, "MinerJobDigTarget", end_percent);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "g", MJ_MINIGAME_LAYOUT_LOAD);
    JSON_SetString(json, "h", "");
    JSON_SetString(json, "m", "");
    JSON_SetInt(json, "p_start", MinerPlayer[playerid][mj_DigProgress]);
    JSON_SetInt(json, "p_max", end_percent);
    JSON_SetInt(json, "p_max_bar", MJ_DIG_MILESTONE_DONE);
    JSON_SetString(json, "p_title", "Раскопка руды");
    JSON_SetInt(json, "p_tick", MJ_DIG_PROGRESS_TICK);
    JSON_SetInt(json, "p_timer", MJ_DIG_PROGRESS_TIMER);
    JSON_SetInt(json, "x", MJ_MINIGAME_HIDE_CLOSE);

    ShowPlayerGUI(playerid, MJ_GUI_MINIGAME, json);
    JSON_Cleanup(json);

    new duration = MinerJob_CalcProgressDuration(MinerPlayer[playerid][mj_DigProgress], end_percent);
    SetPVarInt(playerid, MJ_PVAR_PROG_TIMER,
        SetTimerEx("MinerJob_ProgressBackup", duration, false, "i", playerid));
    return 1;
}

stock MinerJob_ShowDigQte(playerid)
{
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;

    MinerJob_KillProgressBackup(playerid);

    SetPVarInt(playerid, "MinerJobMiniOpen", 1);
    SetPVarInt(playerid, MJ_PVAR_MINI_MODE, MJ_MINIGAME_LAYOUT_QTE);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "g", MJ_MINIGAME_LAYOUT_QTE);
    JSON_SetInt(json, "x", MJ_MINIGAME_HIDE_CLOSE);

    ShowPlayerGUI(playerid, MJ_GUI_MINIGAME, json);
    JSON_Cleanup(json);
    return 1;
}

public MinerJob_ProgressBackup(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;
    DeletePVar(playerid, MJ_PVAR_PROG_TIMER);
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;
    if(GetPVarInt(playerid, MJ_PVAR_MINI_MODE) != MJ_MINIGAME_LAYOUT_LOAD)
        return 0;

    MinerJob_TriggerDigMilestone(playerid);
    return 1;
}

stock MinerJob_CancelMining(playerid, bool:notify = true)
{
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;

    MinerPlayer[playerid][mj_State] = MJ_STATE_WORKING;
    MinerPlayer[playerid][mj_DigProgress] = 0;
    MinerPlayer[playerid][mj_QtePassed] = 0;
    MinerPlayer[playerid][mj_QteMissLeft] = 0;
    KillTimer(MinerPlayer[playerid][mj_DigAnimTimer]);
    MinerPlayer[playerid][mj_DigAnimTimer] = -1;

    DeletePVar(playerid, "MinerJobMiniOpen");
    DeletePVar(playerid, MJ_PVAR_MINI_MODE);
    DeletePVar(playerid, "MinerJobDigTarget");
    DeletePVar(playerid, MJ_PVAR_PROG_TIMER);
    DeletePVar(playerid, MJ_PVAR_MILESTONE_DONE);
    MinerJob_KillProgressBackup(playerid);
    MinerJob_CloseGui(playerid, MJ_GUI_MINIGAME);

    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);

    if(notify)
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "Добыча прервана.");
    return 1;
}

stock MinerJob_BeginMining(playerid, dig_idx)
{
    if(!MinerJob_IsWorking(playerid) || MinerPlayer[playerid][mj_HasOre])
        return 0;
    if(MinerPlayer[playerid][mj_State] == MJ_STATE_MINING)
        return 0;

    MinerPlayer[playerid][mj_State] = MJ_STATE_MINING;
    MinerPlayer[playerid][mj_DigPoint] = dig_idx;
    MinerPlayer[playerid][mj_DigProgress] = 0;
    MinerPlayer[playerid][mj_QtePassed] = 0;
    MinerPlayer[playerid][mj_QteMissLeft] = 0;

    MinerJob_ClearGuideCP(playerid);

    TogglePlayerControllable(playerid, false);
    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 1, 1, 1);
    MinerPlayer[playerid][mj_DigAnimTimer] = SetTimerEx("MinerJob_DigAnimTick", 1200, true, "i", playerid);

    SendClientMessage(playerid, COLOR_WHITE,
        MJ_PREFIX "{FFFFFF}Раскопка руды. На 50% и 100% — отпечаток в зелёной зоне ({00FF00}5{FFFFFF} попыток на этап).");
    MinerJob_ShowDigProgress(playerid, MJ_DIG_MILESTONE_QTE1);
    return 1;
}

stock bool:MinerJob_IsAtDigPoint(playerid, dig_idx = -1)
{
    if(dig_idx == -1)
        dig_idx = MinerPlayer[playerid][mj_DigPoint];
    if(dig_idx < 0 || dig_idx >= MJ_MAX_DIG_POINTS)
        return false;
    if(GetPlayerInterior(playerid) != MJ_INTERIOR)
        return false;
    return (IsPlayerInRangeOfPoint(playerid, 3.5,
        MinerDigPos[dig_idx][0], MinerDigPos[dig_idx][1], MinerDigPos[dig_idx][2]) != 0);
}

public MinerJob_DigAnimTick(playerid)
{
    if(!IsPlayerConnected(playerid) || MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
    {
        if(MinerPlayer[playerid][mj_DigAnimTimer] != -1)
            KillTimer(MinerPlayer[playerid][mj_DigAnimTimer]);
        MinerPlayer[playerid][mj_DigAnimTimer] = -1;
        return 0;
    }
    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 1, 1, 1);
    return 1;
}

stock MinerJob_FinishMining(playerid)
{
    MinerJob_CancelMining(playerid, false);

    MinerPlayer[playerid][mj_HasOre] = true;
    MinerPlayer[playerid][mj_State] = MJ_STATE_CARRY_ORE;
    MinerPlayer[playerid][mj_OreWeight] = 25 + random(26);

    MinerJob_AttachOre(playerid);
    MinerJob_SetGuideToConveyor(playerid);

    new notify[64];
    format(notify, sizeof notify, "+%d кг руды", MinerPlayer[playerid][mj_OreWeight]);
    ShowNotification(playerid, 1, 4, 1, 0, notify, "");
    SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "{00FF00}Руда добыта. {FFFFFF}Отнесите её к конвейеру.");
    return 1;
}

stock MinerJob_DeliverOre(playerid)
{
    if(!MinerPlayer[playerid][mj_HasOre] || MinerPlayer[playerid][mj_DeliverLock])
        return 0;

    MinerPlayer[playerid][mj_DeliverLock] = 1;

    new weight = MinerPlayer[playerid][mj_OreWeight];
    new pay = weight * (50 + random(51));

    MinerPlayer[playerid][mj_HasOre] = false;
    MinerPlayer[playerid][mj_OreWeight] = 0;
    MinerPlayer[playerid][mj_State] = MJ_STATE_WORKING;
    MinerPlayer[playerid][mj_SessionOreKg] += weight;
    MinerPlayer[playerid][mj_SessionEarned] += pay;
    MinerPlayer[playerid][mj_DeliverCount]++;

    if(IsPlayerAttachedObjectSlotUsed(playerid, MJ_ATTACH_ORE))
        RemovePlayerAttachedObject(playerid, MJ_ATTACH_ORE);
    ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
    ClearAnimations(playerid);

    new msg[160];
    format(msg, sizeof msg,
        "Вы доставили руду %d кг. Добудьте новую руду для переплавки. Всего за смену: %d кг.",
        weight, MinerPlayer[playerid][mj_SessionOreKg]);
    format(msg, sizeof msg, MJ_PREFIX "%s", msg);
    SendClientMessage(playerid, COLOR_WHITE, msg);

    if((MinerPlayer[playerid][mj_DeliverCount] % 3) == 0)
    {
        GivePlayerExp(playerid, 2);
        ShowNotification(playerid, 1, 4, 1, 0, "+2 EXP за 3 доставки руды", "");
        SendClientMessage(playerid, COLOR_WHITE,
            MJ_PREFIX "{00FF00}Бонус: +2 EXP {FFFFFF}за каждые 3 доставки руды.");
    }

    MinerJob_SetGuideToDig(playerid);
    MinerJob_UpdateEarnHud(playerid);
    SetTimerEx("MinerJob_UnlockDeliver", 1500, false, "i", playerid);
    return 1;
}

public MinerJob_UnlockDeliver(playerid)
{
    if(IsPlayerConnected(playerid))
        MinerPlayer[playerid][mj_DeliverLock] = 0;
    return 1;
}

stock bool:MinerJob_IsNearEnterPickup(playerid)
{
    if(GetPlayerInterior(playerid) != 0)
        return false;
    return (IsPlayerInRangeOfPoint(playerid, 4.0,
        MinerEnterWorldPos[0], MinerEnterWorldPos[1], MinerEnterWorldPos[2]) != 0);
}

stock MinerJob_GetRoomPopulationByIndex(room_idx)
{
    if(room_idx < 0 || room_idx >= MJ_ROOM_COUNT)
        return 0;

    new vw = MinerRoomVW[room_idx];
    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i))
            continue;
        if(GetPlayerInterior(i) != MJ_INTERIOR)
            continue;
        if(GetPlayerVirtualWorld(i) != vw)
            continue;
        count++;
    }
    return count;
}

stock MinerJob_ShowEnterRoomDialog(playerid)
{
    if(!MinerJob_IsNearEnterPickup(playerid))
        return 0;
    if(GetPVarInt(playerid, MJ_PVAR_ENTER_DLG_OPEN) == 1)
        return 0;

    new list[256];
    format(list, sizeof list,
        "Номер\tЛюдей\n"\
        "1\t%d/%d\n"\
        "2\t%d/%d\n"\
        "3\t%d/%d",
        MinerJob_GetRoomPopulationByIndex(0), MJ_ROOM_CAPACITY,
        MinerJob_GetRoomPopulationByIndex(1), MJ_ROOM_CAPACITY,
        MinerJob_GetRoomPopulationByIndex(2), MJ_ROOM_CAPACITY);

    SetPVarInt(playerid, MJ_PVAR_ENTER_DLG_OPEN, 1);
    ShowPlayerDialog(playerid, MJ_ENTER_DIALOG_ID, DIALOG_STYLE_TABLIST_HEADERS,
        "{FFCD00}Вход в шахту", list, "Выбрать", "Назад");
    return 1;
}

stock bool:MinerJob_OnDialogResponse(playerid, dialogid, response, listitem)
{
    if(dialogid != MJ_ENTER_DIALOG_ID)
        return false;

    DeletePVar(playerid, MJ_PVAR_ENTER_DLG_OPEN);
    SetPVarInt(playerid, MJ_PVAR_ENTER_CD, gettime() + MJ_ENTER_CD_SEC);

    if(!response)
        return true;
    if(!MinerJob_IsNearEnterPickup(playerid))
        return true;
    if(listitem < 0 || listitem >= MJ_ROOM_COUNT)
        return true;

    new count = MinerJob_GetRoomPopulationByIndex(listitem);
    if(count >= MJ_ROOM_CAPACITY)
    {
        ShowNotification(playerid, 2, 4, 1, 1, "Комната заполнена (10/10)", "");
        SendClientMessage(playerid, 0xFF4444FF, MJ_PREFIX "{E0584B}Комната заполнена. Выберите другой номер.");
        return true;
    }

    MinerJob_TeleportToMine(playerid, MinerRoomVW[listitem]);
    return true;
}

stock MinerJob_TeleportToMine(playerid, room_vw = 2)
{
    if(MinerPlayer[playerid][mj_State] == MJ_STATE_MINING)
    {
        MinerJob_CancelMining(playerid, true);
    }

    SetPlayerInterior(playerid, MJ_INTERIOR);
    SetPlayerVirtualWorld(playerid, room_vw);
    SetPlayerPos(playerid,
        MinerEnterInteriorPos[0],
        MinerEnterInteriorPos[1],
        MinerEnterInteriorPos[2]);
    SetPlayerFacingAngle(playerid, MinerEnterInteriorPos[3]);
    MinerJob_UpdateGreenZone(playerid);
    SetTimerEx("MinerJob_DelayedGreenSync", 300, false, "i", playerid);
    SetTimerEx("MinerJob_DelayedGreenSync", 1200, false, "i", playerid);

    SendClientMessage(playerid, COLOR_WHITE,
        MJ_PREFIX "{FFFFFF}Вы вошли в шахту. Подойдите к прорабу для устройства на работу.");
    return 1;
}

stock MinerJob_TeleportFromMine(playerid)
{
    if(MinerPlayer[playerid][mj_HasOre])
    {
        SendClientMessage(playerid, COLOR_WHITE,
            MJ_PREFIX "{E0584B}Сначала сдайте руду на конвейер.");
        return 0;
    }
    if(MinerPlayer[playerid][mj_State] == MJ_STATE_MINING)
    {
        SendClientMessage(playerid, COLOR_WHITE,
            MJ_PREFIX "{E0584B}Завершите раскопку руды.");
        return 0;
    }

    MinerJob_ClearGuideCP(playerid);
    MinerJob_LeaveGreenZone(playerid);

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid,
        MinerExitWorldPos[0],
        MinerExitWorldPos[1],
        MinerExitWorldPos[2]);
    SetPlayerFacingAngle(playerid, MinerExitWorldPos[3]);
    Player_FixInteriorWorldLeak(playerid);

    SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "{FFFFFF}Вы вышли из шахты.");
    return 1;
}

stock MinerJob_GetDigIndexByArea(STREAMER_TAG_AREA:areaid)
{
    for(new i = 0; i < MJ_MAX_DIG_POINTS; i++)
    {
        if(_:areaid == _:MinerAreaDig[i])
            return i;
    }
    return -1;
}

// =============================================================================
//  Пакеты GUI (death.pwn -> case 26 / 63 / 31)
// =============================================================================

stock MinerJob_HandleCaptchaPacket(playerid, Node:json)
{
    new input_text[32];
    JSON_GetString(json, "s", input_text, sizeof input_text);
    BR_FixUserText(input_text, sizeof input_text);

    if(MinerPlayer[playerid][mj_State] != MJ_STATE_CAPTCHA)
    {
        MinerJob_CloseGui(playerid, MJ_GUI_CAPTCHA);
        return 1;
    }

    if(!strcmp(input_text, MinerPlayerCaptcha[playerid], true))
    {
        MinerPlayerCaptcha[playerid][0] = EOS;
        MinerJob_CloseGui(playerid, MJ_GUI_CAPTCHA);
        MinerJob_StartWork(playerid);
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "{00FF00}Капча пройдена. {FFFFFF}Приступайте к работе!");
        return 1;
    }

    MinerPlayer[playerid][mj_CaptchaAttempts]++;
    if(MinerPlayer[playerid][mj_CaptchaAttempts] >= MJ_MAX_CAPTCHA_TRIES)
    {
        MinerJob_CloseGui(playerid, MJ_GUI_CAPTCHA);
        MinerPlayer[playerid][mj_State] = MJ_STATE_NONE;
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "{E0584B}Слишком много ошибок. Попробуйте позже.");
        return 1;
    }

    SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "{E0584B}Неверная капча. {FFFFFF}Введите новый код.");
    MinerJob_ShowCaptcha(playerid);
    return 1;
}

stock MinerJob_GetNpcButtonKey(Node:json)
{
    new key = 0;
    new bk = 0, bt = 0, b = 0, id = 0, k = 0;
    JSON_GetInt(json, "bk", bk);
    JSON_GetInt(json, "bt", bt);
    JSON_GetInt(json, "b", b);
    JSON_GetInt(json, "id", id);
    JSON_GetInt(json, "k", k);

    if(bk != 0) key = bk;
    else if(bt != 0) key = bt;
    else if(id != 0) key = id;
    else if(k != 0) key = k;
    else
    {
        // Некоторые клиенты присылают индекс кнопки 0/1 в поле b
        if(JSON_GetType(json, "b") == JSON_NODE_NUMBER)
        {
            if(b == 0) key = MJ_BTN_YES;
            else if(b == 1) key = MJ_BTN_NO;
            else if(b > 1) key = b;
        }
    }

    if(key == 100 || key == 102)
        key = MJ_BTN_YES;
    else if(key == 101 || key == 103)
        key = MJ_BTN_NO;

    return key;
}

stock MinerJob_HandleNpcDialogPacket(playerid, Node:json)
{
    if(GetPVarInt(playerid, MJ_PVAR_NPC_OPEN) != 1)
        return 0;

    new button_key = MinerJob_GetNpcButtonKey(json);
    new close_flag;
    JSON_GetInt(json, "c", close_flag);
    if(close_flag && button_key == 0)
    {
        MinerJob_SetInteractCooldown(playerid);
        return 1;
    }

    if(button_key == 0)
        return 1;

    new dialog_mode = MinerPlayer[playerid][mj_DialogMode];

    if(button_key == MJ_BTN_YES)
    {
        if(dialog_mode == MJ_DLG_HIRE)
        {
            if(MinerJob_IsWorking(playerid))
            {
                SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "Вы уже на смене.");
                MinerJob_SetInteractCooldown(playerid);
                return 1;
            }
            MinerJob_CloseNpcDialog(playerid);
            DeletePVar(playerid, MJ_PVAR_NPC_OPEN);
            MinerPlayer[playerid][mj_CaptchaAttempts] = 0;
            MinerJob_ShowCaptcha(playerid);
            return 1;
        }
        if(dialog_mode == MJ_DLG_QUIT)
        {
            MinerJob_CloseNpcDialog(playerid);
            DeletePVar(playerid, MJ_PVAR_NPC_OPEN);
            MinerJob_EndWork(playerid, true);
            SetPVarInt(playerid, MJ_PVAR_INTERACT_CD, gettime() + MJ_INTERACT_CD_SEC);
            return 1;
        }
    }
    else if(button_key == MJ_BTN_NO)
    {
        if(dialog_mode == MJ_DLG_HIRE)
            SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "Трудоустройство отменено.");
    }

    MinerJob_SetInteractCooldown(playerid);
    return 1;
}

stock MinerJob_HandleMiniGamePacket(playerid, Node:json)
{
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
    {
        DeletePVar(playerid, "MinerJobMiniOpen");
        DeletePVar(playerid, MJ_PVAR_MINI_MODE);
        DeletePVar(playerid, "MinerJobDigTarget");
        return 1;
    }

    new close_flag;
    if(JSON_GetInt(json, "c", close_flag) && close_flag)
    {
        if(GetPVarInt(playerid, MJ_PVAR_MINI_MODE) == MJ_MINIGAME_LAYOUT_QTE
            && JSON_GetType(json, "s") == JSON_NODE_NUMBER)
        {
            new hit_on_close;
            JSON_GetInt(json, "s", hit_on_close);
            DeletePVar(playerid, "MinerJobMiniOpen");
            DeletePVar(playerid, MJ_PVAR_MINI_MODE);
            MinerJob_HandleDigQteResult(playerid, (hit_on_close != 0));
            return 1;
        }

        if(GetPVarInt(playerid, MJ_PVAR_MINI_MODE) == MJ_MINIGAME_LAYOUT_LOAD)
        {
            DeletePVar(playerid, "MinerJobMiniOpen");
            DeletePVar(playerid, MJ_PVAR_MINI_MODE);
            return 1;
        }

        if(GetPVarInt(playerid, "MinerJobMiniOpen") == 1)
        {
            DeletePVar(playerid, "MinerJobMiniOpen");
            DeletePVar(playerid, MJ_PVAR_MINI_MODE);
            DeletePVar(playerid, "MinerJobDigTarget");
            MinerJob_KillProgressBackup(playerid);
            MinerJob_CancelMining(playerid, true);
            MinerJob_SetGuideToDig(playerid);
        }
        return 1;
    }

    new packet_type;
    if(JSON_GetInt(json, "t", packet_type) && packet_type == 1)
    {
        if(GetPVarInt(playerid, MJ_PVAR_MINI_MODE) != MJ_MINIGAME_LAYOUT_LOAD)
            return 1;

        MinerJob_TriggerDigMilestone(playerid);
        return 1;
    }

    if(JSON_GetType(json, "s") != JSON_NODE_NUMBER)
        return 1;

    if(GetPVarInt(playerid, MJ_PVAR_MINI_MODE) != MJ_MINIGAME_LAYOUT_QTE)
        return 1;

    new hit = 0;
    JSON_GetInt(json, "s", hit);

    DeletePVar(playerid, "MinerJobMiniOpen");
    DeletePVar(playerid, MJ_PVAR_MINI_MODE);

    MinerJob_HandleDigQteResult(playerid, (hit != 0));
    return 1;
}

stock MinerJob_HandleDigQteResult(playerid, bool:success)
{
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;

    if(!MinerJob_IsAtDigPoint(playerid))
    {
        SendClientMessage(playerid, COLOR_WHITE, MJ_PREFIX "{E0584B}Вы отошли от места добычи.");
        MinerJob_CancelMining(playerid, true);
        MinerJob_SetGuideToDig(playerid);
        return 0;
    }

    if(!success)
    {
        MinerPlayer[playerid][mj_QteMissLeft]--;

        if(MinerPlayer[playerid][mj_QteMissLeft] > 0)
        {
            new msg[128];
            format(msg, sizeof msg,
                MJ_PREFIX "{E0584B}Промах! {FFFFFF}Осталось попыток: {00FF00}%d{FFFFFF}. Попадите в зелёную зону.",
                MinerPlayer[playerid][mj_QteMissLeft]);
            SendClientMessage(playerid, COLOR_WHITE, msg);
            SetTimerEx("MinerJob_MiningShowQte", 400, false, "ii", playerid, 0);
            return 0;
        }

        SendClientMessage(playerid, COLOR_WHITE,
            MJ_PREFIX "{E0584B}Неудача! {FFFFFF}Пять промахов — руда не добыта. Вернитесь к метке и начните заново.");
        MinerJob_CancelMining(playerid, false);
        MinerJob_SetGuideToDig(playerid);
        return 0;
    }

    MinerPlayer[playerid][mj_QteMissLeft] = 0;
    MinerPlayer[playerid][mj_QtePassed]++;

    if(MinerPlayer[playerid][mj_QtePassed] == 1)
    {
        MinerPlayer[playerid][mj_DigProgress] = MJ_DIG_MILESTONE_QTE1;
        DeletePVar(playerid, MJ_PVAR_MILESTONE_DONE);
        SendClientMessage(playerid, COLOR_WHITE,
            MJ_PREFIX "{00FF00}Отлично! {FFFFFF}Продолжайте раскопку до 100%.");
        MinerJob_CloseGui(playerid, MJ_GUI_MINIGAME);
        SetTimerEx("MinerJob_MiningQteResume", MJ_QTE_OPEN_DELAY_MS, false, "i", playerid);
        return 1;
    }

    if(MinerPlayer[playerid][mj_QtePassed] >= 2)
    {
        MinerPlayer[playerid][mj_DigProgress] = MJ_DIG_MILESTONE_DONE;
        MinerJob_FinishMining(playerid);
        return 1;
    }

    return 1;
}

forward MinerJob_MiningQteResume(playerid);
public MinerJob_MiningQteResume(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;
    if(MinerPlayer[playerid][mj_DigProgress] >= MJ_DIG_MILESTONE_DONE)
        return 0;
    if(!MinerJob_IsAtDigPoint(playerid))
    {
        MinerJob_CancelMining(playerid, true);
        MinerJob_SetGuideToDig(playerid);
        return 0;
    }

    if(MinerPlayer[playerid][mj_QtePassed] == 0)
        MinerJob_ShowDigProgress(playerid, MJ_DIG_MILESTONE_QTE1);
    else
        MinerJob_ShowDigProgress(playerid, MJ_DIG_MILESTONE_DONE);
    return 1;
}

public MinerJob_MiningShowQte(playerid, reset_chances)
{
    if(!IsPlayerConnected(playerid))
        return 0;
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;
    if(!MinerJob_IsAtDigPoint(playerid))
    {
        MinerJob_CancelMining(playerid, true);
        MinerJob_SetGuideToDig(playerid);
        return 0;
    }

    if(reset_chances)
        MinerPlayer[playerid][mj_QteMissLeft] = MJ_QTE_MAX_MISSES;

    MinerJob_CloseGui(playerid, MJ_GUI_MINIGAME);
    SetTimerEx("MinerJob_MiningOpenQte", 450, false, "i", playerid);
    return 1;
}

public MinerJob_MiningOpenQte(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;
    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;
    if(!MinerJob_IsAtDigPoint(playerid))
    {
        MinerJob_CancelMining(playerid, true);
        MinerJob_SetGuideToDig(playerid);
        return 0;
    }

    MinerJob_ShowDigQte(playerid);
    return 1;
}

// =============================================================================
//  События мира / игрока
// =============================================================================

stock MinerJob_OnGameModeInit()
{
    MinerPickupEnter = CreateDynamicPickup(19134, 23,
        MinerEnterWorldPos[0], MinerEnterWorldPos[1], MinerEnterWorldPos[2],
        0, 0);

    MinerPickupExit = CreateDynamicPickup(19134, 23,
        MinerExitInteriorPos[0], MinerExitInteriorPos[1], MinerExitInteriorPos[2],
        -1, MJ_INTERIOR);

    MinerLabelEnter = CreateDynamic3DTextLabel(
        "{E0584B}Шахта\n{FFFFFF}Подойдите, чтобы войти",
        -1,
        MinerEnterWorldPos[0], MinerEnterWorldPos[1], MinerEnterWorldPos[2] + 0.9,
        18.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    MinerLabelExit = CreateDynamic3DTextLabel(
        "{E0584B}Выход\n{FFFFFF}Покинуть шахту",
        -1,
        MinerExitInteriorPos[0], MinerExitInteriorPos[1], MinerExitInteriorPos[2] + 0.9,
        12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, MJ_INTERIOR);

    MinerAreaForeman = CreateDynamicSphere(
        MinerForemanPos[0], MinerForemanPos[1], MinerForemanPos[2],
        MJ_LOCKER_AREA_RADIUS, -1, MJ_INTERIOR);

    MinerAreaGreenZone = CreateDynamicSphere(
        MinerGreenZoneCenter[0], MinerGreenZoneCenter[1], MinerGreenZoneCenter[2],
        MJ_GREEN_ZONE_RADIUS, -1, MJ_INTERIOR);

    for(new i = 0; i < MJ_ROOM_COUNT; i++)
    {
        MinerActorForeman[i] = CreateDynamicActor(MJ_JOB_SKIN,
            MinerForemanPos[0], MinerForemanPos[1], MinerForemanPos[2], MinerForemanPos[3],
            true, 100.0, MinerRoomVW[i], MJ_INTERIOR);
    }
    SetTimerEx("MinerJob_FixForemanActor", 500, false, "");

    MinerLabelForeman = CreateDynamic3DTextLabel(
        "{E0584B}Прораб Кирилл\n{FFFFFF}Подойдите для взаимодействия",
        -1, MinerForemanPos[0], MinerForemanPos[1], MinerForemanPos[2] + 1.0,
        12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, MJ_INTERIOR);

    MinerLabelConveyor = CreateDynamic3DTextLabel(
        "{E0584B}Конвейер\n{FFFFFF}Сдача руды",
        -1, MinerConveyorPos[0], MinerConveyorPos[1], MinerConveyorPos[2] + 0.6,
        12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, MJ_INTERIOR);

    MinerAreaConveyor = CreateDynamicSphere(
        MinerConveyorPos[0], MinerConveyorPos[1], MinerConveyorPos[2],
        2.5, -1, MJ_INTERIOR);

    for(new i = 0; i < MJ_MAX_DIG_POINTS; i++)
    {
        MinerAreaDig[i] = CreateDynamicSphere(
            MinerDigPos[i][0], MinerDigPos[i][1], MinerDigPos[i][2],
            2.5, -1, MJ_INTERIOR);

        new label[96];
        format(label, sizeof label,
            "{E0584B}Место добычи руды\n{FFFFFF}Подойдите для раскопки");
        MinerLabelDig[i] = CreateDynamic3DTextLabel(label, -1,
            MinerDigPos[i][0], MinerDigPos[i][1], MinerDigPos[i][2] + 0.5,
            10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, MJ_INTERIOR);
    }

    return 1;
}

stock MinerJob_OnGameModeExit()
{
    if(IsValidDynamic3DTextLabel(MinerLabelEnter))
        DestroyDynamic3DTextLabel(MinerLabelEnter);
    if(IsValidDynamic3DTextLabel(MinerLabelExit))
        DestroyDynamic3DTextLabel(MinerLabelExit);
    if(IsValidDynamic3DTextLabel(MinerLabelForeman))
        DestroyDynamic3DTextLabel(MinerLabelForeman);
    if(IsValidDynamic3DTextLabel(MinerLabelConveyor))
        DestroyDynamic3DTextLabel(MinerLabelConveyor);
    for(new i = 0; i < MJ_MAX_DIG_POINTS; i++)
    {
        if(IsValidDynamic3DTextLabel(MinerLabelDig[i]))
            DestroyDynamic3DTextLabel(MinerLabelDig[i]);
    }
    return 1;
}

stock MinerJob_OnConnect(playerid)
{
    MinerCPGuide[playerid] = STREAMER_TAG_CP:INVALID_STREAMER_ID;
    for(new i = 0; i < MJ_EARN_HUD_PARTS; i++)
        moneytd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
    MinerEarnHudOn[playerid] = false;
    MinerJob_ResetPlayer(playerid);
    return 1;
}

stock MinerJob_OnDisconnect(playerid)
{
    MinerJob_DestroyEarnHud(playerid);
    if(MinerJob_IsWorking(playerid))
        MinerJob_EndWork(playerid, true);
    else
        MinerJob_ResetPlayer(playerid);
    return 1;
}

stock bool:MinerJob_OnPickup(playerid, pickupid)
{
    if(pickupid == MinerPickupEnter)
    {
        if(GetPlayerInterior(playerid) != 0)
            return false;
        if(GetPVarInt(playerid, MJ_PVAR_ENTER_CD) > gettime())
            return false;
        if(!IsPlayerInRangeOfPoint(playerid, 4.0,
            MinerEnterWorldPos[0], MinerEnterWorldPos[1], MinerEnterWorldPos[2]))
            return false;

        return (MinerJob_ShowEnterRoomDialog(playerid) != 0);
    }

    if(pickupid == MinerPickupExit)
    {
        if(GetPlayerInterior(playerid) != MJ_INTERIOR)
            return false;
        if(GetPVarInt(playerid, MJ_PVAR_ENTER_CD) > gettime())
            return false;
        if(!IsPlayerInRangeOfPoint(playerid, 4.0,
            MinerExitInteriorPos[0], MinerExitInteriorPos[1], MinerExitInteriorPos[2]))
            return false;

        SetPVarInt(playerid, MJ_PVAR_ENTER_CD, gettime() + MJ_ENTER_CD_SEC);
        if(MinerJob_TeleportFromMine(playerid))
            return true;
        return false;
    }

    return false;
}

public MinerJob_FixForemanActor()
{
    for(new i = 0; i < MJ_ROOM_COUNT; i++)
    {
        if(MinerActorForeman[i] == STREAMER_TAG_ACTOR:INVALID_STREAMER_ID)
            continue;

        SetDynamicActorPos(MinerActorForeman[i],
            MinerForemanPos[0], MinerForemanPos[1], MinerForemanPos[2]);
        SetDynamicActorFacingAngle(MinerActorForeman[i], MinerForemanPos[3]);
        ClearDynamicActorAnimations(MinerActorForeman[i]);
        ApplyDynamicActorAnimation(MinerActorForeman[i],
            "PED", "IDLE_STANCE", 4.1, 1, 1, 1, 1, 0);
    }
    return 1;
}

stock bool:MinerJob_OnEnterCP(playerid, STREAMER_TAG_CP:checkpointid)
{
    if(MinerCPGuide[playerid] == STREAMER_TAG_CP:INVALID_STREAMER_ID)
        return false;
    if(checkpointid != MinerCPGuide[playerid])
        return false;

    if(!MinerJob_IsWorking(playerid) || MinerPlayer[playerid][mj_HasOre])
        return false;
    if(MinerPlayer[playerid][mj_State] == MJ_STATE_MINING)
        return false;

    new dig_idx = MinerPlayer[playerid][mj_DigPoint];
    if(dig_idx < 0 || !MinerJob_IsAtDigPoint(playerid, dig_idx))
        return false;

    MinerJob_BeginMining(playerid, dig_idx);
    return true;
}

stock MinerJob_OnEnterArea(playerid, STREAMER_TAG_AREA:areaid)
{
    if(_:areaid == _:MinerAreaGreenZone)
    {
        MinerJob_UpdateGreenZone(playerid);
        return 1;
    }

    if(GetPlayerInterior(playerid) != MJ_INTERIOR)
        return 0;

    if(_:areaid == _:MinerAreaForeman)
    {
        MinerJob_ShowForemanNotify(playerid);
        return 1;
    }

    if(_:areaid == _:MinerAreaConveyor)
    {
        if(MinerJob_IsWorking(playerid) && MinerPlayer[playerid][mj_HasOre])
            MinerJob_DeliverOre(playerid);
        return 1;
    }

    return 0;
}

stock MinerJob_OnLeaveArea(playerid, STREAMER_TAG_AREA:areaid)
{
    if(_:areaid == _:MinerAreaGreenZone)
    {
        MinerJob_UpdateGreenZone(playerid);
        return 1;
    }

    if(_:areaid == _:MinerAreaForeman)
    {
        MinerJob_HideForemanNotify(playerid);
        return 1;
    }

    if(MinerPlayer[playerid][mj_State] != MJ_STATE_MINING)
        return 0;

    if(MinerJob_GetDigIndexByArea(areaid) != -1)
    {
        MinerJob_CancelMining(playerid, true);
        if(MinerJob_IsWorking(playerid) && !MinerPlayer[playerid][mj_HasOre])
            MinerJob_SetGuideToDig(playerid);
    }
    return 1;
}
