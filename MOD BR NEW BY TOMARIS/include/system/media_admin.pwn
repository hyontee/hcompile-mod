#if defined _KIRILL_MEDIA_ADMIN_INCLUDED
    #endinput
#endif
#define _KIRILL_MEDIA_ADMIN_INCLUDED

// ================= MEDIA ADMIN SYSTEM =================
// Безопасные команды для медиа-администрации.
// Выдача: /givebloger или /mediaadm [id]

#define MEDIA_ADMIN_LEVEL         (2)
#define MEDIA_ADMIN_POST          (21)
#define MEDIA_ADMIN_MIN_ISSUER    (9)
#define MEDIA_ADMIN_DIALOG_HELP   (21090)
#define MEDIA_ADMIN_DIALOG_ONLINE (21091)
#define MEDIA_ADMIN_DIALOG_PLAYERS (21092)
#define MEDIA_LOG_TYPE_ADMIN_CHAT (1)
#define MEDIA_ADMIN_BVEH_LIFETIME  (1800)
#define MEDIA_ADMIN_BVEH_COOLDOWN  (300)
#define MEDIA_ADMIN_BFLIP_COOLDOWN (120)

#if !defined INVALID_VEHICLE_ID
    #define INVALID_VEHICLE_ID 65535
#endif

new MediaAdmin_BloggerVeh[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new MediaAdmin_BloggerVehTimer[MAX_PLAYERS];


stock MediaAdmin_GetName(playerid, name[], size)
{
    GetPlayerName(playerid, name, size);
    return 1;
}

stock IsMediaAdminAccess(playerid)
{
    if(GetPlayerAdminEx(playerid) >= MEDIA_ADMIN_MIN_ISSUER) return 1;
    if(GetPlayerAdminEx(playerid) == MEDIA_ADMIN_LEVEL) return 1;
    if(GetPlayerYouTubeEx(playerid) >= 1) return 1;
    return 0;
}

stock SendMediaNoAccess(playerid)
{
    SendClientMessage(playerid, 0xCECECEFF, "У Вас нет доступа к командам медиа-администрации.");
    return 1;
}

stock SetPlayerMediaAdminEx(playerid)
{
    // /givebloger выдаёт только медиа/ютуберский доступ.
    // Обычный admin/post не трогаем, чтобы не выдавать полноценную админку.
    SetPlayerData(playerid, P_YOUTUBE, 1);
    UpdatePlayerDatabaseInt(playerid, "youtube", 1);
    return 1;
}

stock RemovePlayerMediaAdminEx(playerid)
{
    // /takebloger снимает только медиа/ютуберский доступ.
    // Обычные админские права игрока не изменяются.
    SetPlayerData(playerid, P_YOUTUBE, 0);
    UpdatePlayerDatabaseInt(playerid, "youtube", 0);
    return 1;
}

stock ShowMediaAdminHelp(playerid)
{
    new dialog[3600];

    strcat(dialog, "{D952C2}========================================\n");
    strcat(dialog, "{FFFFFF}          МЕНЮ МЕДИА-АДМИНА\n");
    strcat(dialog, "{D952C2}========================================\n\n");

    strcat(dialog, "{FFCC00}>> Основное\n");
    strcat(dialog, "{FFFFFF}/bhelp {AFAFAF}- открыть это меню\n");
    strcat(dialog, "{FFFFFF}/bmenu {AFAFAF}- аналог /bhelp\n");
    strcat(dialog, "{FFFFFF}/bonline {AFAFAF}- медиа-админы онлайн\n");
    strcat(dialog, "{FFFFFF}/badmins {AFAFAF}- администрация онлайн\n");
    strcat(dialog, "{FFFFFF}/bplayers {AFAFAF}- список игроков онлайн\n\n");

    strcat(dialog, "{FFCC00}>> Связь\n");
    strcat(dialog, "{FFFFFF}/bc [текст] {AFAFAF}- написать в медиа/админ чат\n");
    strcat(dialog, "{FFFFFF}/bchat [текст] {AFAFAF}- аналог /bc\n");
    strcat(dialog, "{FFFFFF}/bpm [id] [текст] {AFAFAF}- личное сообщение игроку от медиа\n");
    strcat(dialog, "{FFFFFF}/bnote [текст] {AFAFAF}- заметка/обращение для администрации\n\n");

    strcat(dialog, "{FFCC00}>> Блогерские возможности\n");
    strcat(dialog, "{FFFFFF}/bflip {AFAFAF}- поставить машину на колеса. КД: 2 минуты\n");
    strcat(dialog, "{FFFFFF}/bz {AFAFAF}- телепорт в блогерскую зону\n");
    strcat(dialog, "{FFFFFF}/bveh [model id] {AFAFAF}- временная машина на 30 минут. КД: 5 минут\n");
    strcat(dialog, "{AFAFAF}Поддерживаются ID моделей транспорта SA-MP: 400-611.\n\n");

    strcat(dialog, "{FFCC00}>> Информация без вмешательства в игру\n");
    strcat(dialog, "{FFFFFF}/binfo [id] {AFAFAF}- краткая информация об игроке\n");
    strcat(dialog, "{FFFFFF}/bid [id] {AFAFAF}- ID аккаунта игрока\n");
    strcat(dialog, "{FFFFFF}/bping [id] {AFAFAF}- ping игрока\n");
    strcat(dialog, "{FFFFFF}/bwhere [id] {AFAFAF}- координаты и дистанция до игрока\n");
    strcat(dialog, "{FFFFFF}/bworld [id] {AFAFAF}- виртуальный мир и интерьер игрока\n");
    strcat(dialog, "{FFFFFF}/bskin [id] {AFAFAF}- ID скина игрока\n");
    strcat(dialog, "{FFFFFF}/bpos {AFAFAF}- показать свои координаты\n");
    strcat(dialog, "{FFFFFF}/bvehinfo {AFAFAF}- информация о транспорте, где Вы сидите\n\n");

    if(GetPlayerAdminEx(playerid) >= MEDIA_ADMIN_MIN_ISSUER)
    {
        strcat(dialog, "{FF5252}>> Старшая администрация\n");
        strcat(dialog, "{FFFFFF}/givebloger [id] {AFAFAF}- выдать блогерский доступ\n");
        strcat(dialog, "{FFFFFF}/mediaadm [id] {AFAFAF}- аналог выдачи блогерского доступа\n");
        strcat(dialog, "{FFFFFF}/takebloger [id] {AFAFAF}- снять блогерский доступ\n\n");
    }

    strcat(dialog, "{66CC66}Команды ограничены: без денег/оружия/банов. /givebloger выдает только блогерский доступ, /bveh создает временный транспорт.");
    Dialog(playerid, MEDIA_ADMIN_DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{D952C2}SILE | Медиа меню", dialog, "Закрыть", "");
    return 1;
}

stock MediaAdmin_CommandHelp(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);
    return ShowMediaAdminHelp(playerid);
}

CMD:bhelp(playerid, params[])
{
    return MediaAdmin_CommandHelp(playerid, params);
}

CMD:bmenu(playerid, params[])
{
    return MediaAdmin_CommandHelp(playerid, params);
}

stock MediaAdmin_CommandChat(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);
    if(isnull(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bc [текст]");

    new pname[MAX_PLAYER_NAME];
    new text[192];
    MediaAdmin_GetName(playerid, pname, sizeof(pname));

    format(text, sizeof(text), "{D952C2}[MEDIA] %s[%d]: {FFFFFF}%s", pname, playerid, params);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(!IsMediaAdminAccess(i)) continue;
        SendClientMessage(i, 0xD952C2FF, text);
    }

    SendLog(playerid, MEDIA_LOG_TYPE_ADMIN_CHAT, params);
    return 1;
}

CMD:bc(playerid, params[])
{
    return MediaAdmin_CommandChat(playerid, params);
}

CMD:bchat(playerid, params[])
{
    return MediaAdmin_CommandChat(playerid, params);
}

CMD:bpm(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new targetid, message[96];
    if(sscanf(params, "us[96]", targetid, message)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bpm [id игрока] [текст]");
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");

    new pname[MAX_PLAYER_NAME], tname[MAX_PLAYER_NAME], text[192];
    MediaAdmin_GetName(playerid, pname, sizeof(pname));
    MediaAdmin_GetName(targetid, tname, sizeof(tname));

    format(text, sizeof(text), "{D952C2}[MEDIA PM] %s[%d]: {FFFFFF}%s", pname, playerid, message);
    SendClientMessage(targetid, 0xD952C2FF, text);

    format(text, sizeof(text), "{D952C2}[MEDIA PM] Вы -> %s[%d]: {FFFFFF}%s", tname, targetid, message);
    SendClientMessage(playerid, 0xD952C2FF, text);

    format(text, sizeof(text), "[MEDIA PM] %s[%d] -> %s[%d]: %s", pname, playerid, tname, targetid, message);
    SendMessageToAdmins(text, 0xD952C2FF);
    SendLog(playerid, MEDIA_LOG_TYPE_ADMIN_CHAT, message);
    return 1;
}

CMD:bnote(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);
    if(isnull(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bnote [текст]");

    new pname[MAX_PLAYER_NAME], text[192];
    MediaAdmin_GetName(playerid, pname, sizeof(pname));

    format(text, sizeof(text), "{FFCC00}[MEDIA NOTE] %s[%d]: {FFFFFF}%s", pname, playerid, params);
    SendMessageToAdmins(text, 0xFFCC00FF);
    SendLog(playerid, MEDIA_LOG_TYPE_ADMIN_CHAT, params);
    SendClientMessage(playerid, 0x66CC66FF, "Заметка отправлена администрации.");
    return 1;
}

CMD:bonline(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new dialog[1200];
    new row[128];
    new pname[MAX_PLAYER_NAME];
    new count = 0;

    strcat(dialog, "Ник\tID\tУровень\tСтатус\n");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(GetPlayerAdminEx(i) != MEDIA_ADMIN_LEVEL) continue;

        MediaAdmin_GetName(i, pname, sizeof(pname));
        format(row, sizeof(row), "%s\t%d\t%d\tonline\n", pname, i, GetPlayerAdminEx(i));
        strcat(dialog, row);
        count++;
    }

    if(!count) return SendClientMessage(playerid, 0xCECECEFF, "Медиа-админов онлайн нет.");

    Dialog(playerid, MEDIA_ADMIN_DIALOG_ONLINE, DIALOG_STYLE_TABLIST_HEADERS, "{D952C2}Медиа-админы онлайн", dialog, "Закрыть", "");
    return 1;
}

CMD:badmins(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new dialog[1600];
    new row[128];
    new pname[MAX_PLAYER_NAME];
    new count = 0;

    strcat(dialog, "Ник\tID\tУровень\tPing\n");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(GetPlayerAdminEx(i) <= 0) continue;

        MediaAdmin_GetName(i, pname, sizeof(pname));
        format(row, sizeof(row), "%s\t%d\t%d\t%d\n", pname, i, GetPlayerAdminEx(i), GetPlayerPing(i));
        strcat(dialog, row);
        count++;

        if(count >= 45) break;
    }

    if(!count) return SendClientMessage(playerid, 0xCECECEFF, "Администраторов онлайн нет.");

    Dialog(playerid, MEDIA_ADMIN_DIALOG_PLAYERS + 10, DIALOG_STYLE_TABLIST_HEADERS, "{D952C2}Администрация онлайн", dialog, "Закрыть", "");
    return 1;
}

CMD:bplayers(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new dialog[3000];
    new row[128];
    new pname[MAX_PLAYER_NAME];
    new count = 0;

    strcat(dialog, "Ник\tID\tУровень\tPing\n");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;

        MediaAdmin_GetName(i, pname, sizeof(pname));
        format(row, sizeof(row), "%s\t%d\t%d\t%d\n", pname, i, GetPlayerLevel(i), GetPlayerPing(i));
        strcat(dialog, row);
        count++;

        if(count >= 40) break;
    }

    if(!count) return SendClientMessage(playerid, 0xCECECEFF, "Игроков онлайн нет.");

    Dialog(playerid, MEDIA_ADMIN_DIALOG_PLAYERS, DIALOG_STYLE_TABLIST_HEADERS, "{D952C2}Игроки онлайн", dialog, "Закрыть", "");
    return 1;
}

CMD:binfo(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /binfo [id игрока]");
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");

    new tname[MAX_PLAYER_NAME];
    new Float:hp, Float:armour, Float:x, Float:y, Float:z;
    new vehicleid, text[600];

    MediaAdmin_GetName(targetid, tname, sizeof(tname));
    GetPlayerHealth(targetid, hp);
    GetPlayerArmour(targetid, armour);
    GetPlayerPos(targetid, x, y, z);
    vehicleid = GetPlayerVehicleID(targetid);

    format(text, sizeof(text),
        "{D952C2}Информация об игроке\n\n{FFFFFF}Ник: {AFAFAF}%s[%d]\n{FFFFFF}Аккаунт ID: {AFAFAF}%d\n{FFFFFF}Уровень: {AFAFAF}%d\n{FFFFFF}Admin: {AFAFAF}%d\n{FFFFFF}Ping: {AFAFAF}%d\n{FFFFFF}Skin: {AFAFAF}%d\n{FFFFFF}HP/Armor: {AFAFAF}%.1f / %.1f\n{FFFFFF}Мир/Интерьер: {AFAFAF}%d / %d\n{FFFFFF}Транспорт ID: {AFAFAF}%d\n{FFFFFF}Координаты: {AFAFAF}%.2f, %.2f, %.2f",
        tname, targetid, GetPlayerAccountID(targetid), GetPlayerLevel(targetid), GetPlayerAdminEx(targetid), GetPlayerPing(targetid), GetPlayerSkin(targetid), hp, armour,
        GetPlayerVirtualWorld(targetid), GetPlayerInterior(targetid), vehicleid, x, y, z);

    Dialog(playerid, MEDIA_ADMIN_DIALOG_HELP + 3, DIALOG_STYLE_MSGBOX, "{D952C2}SILE | Информация", text, "Закрыть", "");
    return 1;
}

CMD:bid(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new targetid;
    if(sscanf(params, "u", targetid)) targetid = playerid;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");

    new tname[MAX_PLAYER_NAME], text[128];
    MediaAdmin_GetName(targetid, tname, sizeof(tname));
    format(text, sizeof(text), "{D952C2}[MEDIA] {FFFFFF}%s[%d] | Account ID: %d", tname, targetid, GetPlayerAccountID(targetid));
    SendClientMessage(playerid, 0xD952C2FF, text);
    return 1;
}

CMD:bping(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new targetid;
    if(sscanf(params, "u", targetid)) targetid = playerid;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");

    new tname[MAX_PLAYER_NAME], text[128];
    MediaAdmin_GetName(targetid, tname, sizeof(tname));
    format(text, sizeof(text), "{D952C2}[MEDIA] {FFFFFF}%s[%d] | Ping: %d", tname, targetid, GetPlayerPing(targetid));
    SendClientMessage(playerid, 0xD952C2FF, text);
    return 1;
}

CMD:bwhere(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bwhere [id игрока]");
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");

    new tname[MAX_PLAYER_NAME];
    new Float:px, Float:py, Float:pz, Float:tx, Float:ty, Float:tz, Float:dist;
    new text[192];

    MediaAdmin_GetName(targetid, tname, sizeof(tname));
    GetPlayerPos(playerid, px, py, pz);
    GetPlayerPos(targetid, tx, ty, tz);
    dist = floatsqroot(((px - tx) * (px - tx)) + ((py - ty) * (py - ty)) + ((pz - tz) * (pz - tz)));

    format(text, sizeof(text), "{D952C2}[MEDIA] {FFFFFF}%s[%d]: %.2f, %.2f, %.2f | Мир: %d | Интерьер: %d | Дистанция: %.1f м",
        tname, targetid, tx, ty, tz, GetPlayerVirtualWorld(targetid), GetPlayerInterior(targetid), dist);
    SendClientMessage(playerid, 0xD952C2FF, text);
    return 1;
}

CMD:bworld(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new targetid;
    if(sscanf(params, "u", targetid)) targetid = playerid;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");

    new tname[MAX_PLAYER_NAME], text[144];
    MediaAdmin_GetName(targetid, tname, sizeof(tname));
    format(text, sizeof(text), "{D952C2}[MEDIA] {FFFFFF}%s[%d] | Мир: %d | Интерьер: %d", tname, targetid, GetPlayerVirtualWorld(targetid), GetPlayerInterior(targetid));
    SendClientMessage(playerid, 0xD952C2FF, text);
    return 1;
}

CMD:bskin(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new targetid;
    if(sscanf(params, "u", targetid)) targetid = playerid;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");

    new tname[MAX_PLAYER_NAME], text[128];
    MediaAdmin_GetName(targetid, tname, sizeof(tname));
    format(text, sizeof(text), "{D952C2}[MEDIA] {FFFFFF}%s[%d] | Skin ID: %d", tname, targetid, GetPlayerSkin(targetid));
    SendClientMessage(playerid, 0xD952C2FF, text);
    return 1;
}

CMD:bpos(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new Float:x, Float:y, Float:z, Float:a, text[192];
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    format(text, sizeof(text), "{D952C2}[MEDIA] {FFFFFF}Ваши координаты: %.2f, %.2f, %.2f | Angle: %.2f | Мир: %d | Интерьер: %d", x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    SendClientMessage(playerid, 0xD952C2FF, text);
    return 1;
}

stock MediaAdmin_IsValidVehicleModel(modelid)
{
    return (modelid >= 400 && modelid <= 611);
}

stock MediaAdmin_GetCooldownLeft(playerid, pvarName[])
{
    new cooldown = GetPVarInt(playerid, pvarName);
    if(cooldown <= gettime()) return 0;
    return cooldown - gettime();
}

stock MediaAdmin_DestroyPlayerBloggerVehicle(playerid, bool:notify)
{
    if(MediaAdmin_BloggerVehTimer[playerid] != 0)
    {
        KillTimer(MediaAdmin_BloggerVehTimer[playerid]);
        MediaAdmin_BloggerVehTimer[playerid] = 0;
    }

    if(MediaAdmin_BloggerVeh[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(MediaAdmin_BloggerVeh[playerid]))
    {
        DestroyVehicle(MediaAdmin_BloggerVeh[playerid]);
    }

    MediaAdmin_BloggerVeh[playerid] = INVALID_VEHICLE_ID;

    if(notify && IsPlayerConnected(playerid))
    {
        SendClientMessage(playerid, 0xD952C2FF, "[MEDIA] Ваш временный транспорт удален.");
    }
    return 1;
}

stock MediaAdmin_CleanupBloggerVehicle(playerid)
{
    MediaAdmin_DestroyPlayerBloggerVehicle(playerid, false);
    DeletePVar(playerid, "bflip_cd");
    DeletePVar(playerid, "bveh_cd");
    return 1;
}

forward MediaAdmin_DestroyBloggerVehicleTimer(playerid, vehicleid);
public MediaAdmin_DestroyBloggerVehicleTimer(playerid, vehicleid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 1;

    if(MediaAdmin_BloggerVeh[playerid] == vehicleid)
    {
        if(IsValidVehicle(vehicleid)) DestroyVehicle(vehicleid);
        MediaAdmin_BloggerVeh[playerid] = INVALID_VEHICLE_ID;
        MediaAdmin_BloggerVehTimer[playerid] = 0;

        if(IsPlayerConnected(playerid))
        {
            SendClientMessage(playerid, 0xD952C2FF, "[MEDIA] Временный транспорт удален: прошло 30 минут.");
        }
    }
    return 1;
}

CMD:bflip(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new seconds = MediaAdmin_GetCooldownLeft(playerid, "bflip_cd");
    if(seconds > 0)
    {
        new msg[96];
        format(msg, sizeof(msg), "[MEDIA] Подождите %d сек. перед повторным /bflip.", seconds);
        return SendClientMessage(playerid, 0xCECECEFF, msg);
    }

    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "[MEDIA] Вы должны находиться в транспорте.");

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, 0xCECECEFF, "[MEDIA] Команда доступна только водителю.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "[MEDIA] Транспорт не найден.");

    new Float:x, Float:y, Float:z, Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);
    z += 0.35;

    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, a);
    SetPVarInt(playerid, "bflip_cd", gettime() + MEDIA_ADMIN_BFLIP_COOLDOWN);
    SendClientMessage(playerid, 0xD952C2FF, "[MEDIA] Машина поставлена на колеса. КД: 2 минуты.");
    return 1;
}

CMD:bz(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new Float:x = -413.4000, Float:y = 1004.8000, Float:z = 12.2000, Float:a = 90.0000;

    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(IsValidVehicle(vehicleid))
        {
            SetVehicleVirtualWorld(vehicleid, 0);
            LinkVehicleToInterior(vehicleid, 0);
            SetVehiclePos(vehicleid, x, y, z);
            SetVehicleZAngle(vehicleid, a);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
    }
    else
    {
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 0);
        SetPlayerPos(playerid, x, y, z);
        SetPlayerFacingAngle(playerid, a);
    }

    SetCameraBehindPlayer(playerid);
    SendClientMessage(playerid, 0xD952C2FF, "[MEDIA] Вы перемещены в блогерскую зону.");
    return 1;
}

CMD:bveh(playerid, params[])
{
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);

    new seconds = MediaAdmin_GetCooldownLeft(playerid, "bveh_cd");
    if(seconds > 0)
    {
        new msg[96];
        format(msg, sizeof(msg), "[MEDIA] Подождите %d сек. перед повторным /bveh.", seconds);
        return SendClientMessage(playerid, 0xCECECEFF, msg);
    }

    new modelid;
    if(sscanf(params, "d", modelid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bveh [model id 400-611]");

    if(!MediaAdmin_IsValidVehicleModel(modelid))
        return SendClientMessage(playerid, 0xCECECEFF, "[MEDIA] Неверный ID модели. Доступно: 400-611.");

    MediaAdmin_DestroyPlayerBloggerVehicle(playerid, false);

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    x += floatsin(-a, degrees) * 3.0;
    y += floatcos(-a, degrees) * 3.0;

    new vehicleid = CreateVehicle(modelid, x, y, z + 0.5, a, -1, -1, 1800);
    if(!IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "[MEDIA] Не удалось создать транспорт.");

    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    PutPlayerInVehicle(playerid, vehicleid, 0);

    MediaAdmin_BloggerVeh[playerid] = vehicleid;
    MediaAdmin_BloggerVehTimer[playerid] = SetTimerEx("MediaAdmin_DestroyBloggerVehicleTimer", MEDIA_ADMIN_BVEH_LIFETIME * 1000, false, "ii", playerid, vehicleid);
    SetPVarInt(playerid, "bveh_cd", gettime() + MEDIA_ADMIN_BVEH_COOLDOWN);

    new msg[144];
    format(msg, sizeof(msg), "[MEDIA] Временный транспорт ID %d создан на 30 минут. Повторный спавн через 5 минут.", modelid);
    SendClientMessage(playerid, 0xD952C2FF, msg);
    return 1;
}

CMD:bvehinfo(playerid, params[])
{
    #pragma unused params
    if(!IsMediaAdminAccess(playerid)) return SendMediaNoAccess(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте.");

    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:health;
    new text[160];

    GetVehicleHealth(vehicleid, health);
    format(text, sizeof(text), "{D952C2}[MEDIA] {FFFFFF}Vehicle ID: %d | Model: %d | Health: %.1f", vehicleid, GetVehicleModel(vehicleid), health);
    SendClientMessage(playerid, 0xD952C2FF, text);
    return 1;
}

stock MediaAdmin_CommandGive(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < MEDIA_ADMIN_MIN_ISSUER) return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна только старшей администрации.");

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givebloger [id игрока]");
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");
    SetPlayerMediaAdminEx(targetid);

    new pname[MAX_PLAYER_NAME], tname[MAX_PLAYER_NAME], text[192];
    MediaAdmin_GetName(playerid, pname, sizeof(pname));
    MediaAdmin_GetName(targetid, tname, sizeof(tname));

    format(text, sizeof(text), "[A] %s[%d] выдал блогерский доступ игроку %s[%d].", pname, playerid, tname, targetid);
    SendMessageToAdmins(text, 0xD952C2FF);
    SendClientMessage(targetid, 0xD952C2FF, "Вам выдали блогерский доступ. Используйте /bhelp.");
    SendClientMessage(playerid, 0xD952C2FF, "Блогерский доступ успешно выдан.");
    return 1;
}

CMD:givebloger(playerid, params[])
{
    return MediaAdmin_CommandGive(playerid, params);
}

CMD:mediaadm(playerid, params[])
{
    return MediaAdmin_CommandGive(playerid, params);
}

CMD:takebloger(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < MEDIA_ADMIN_MIN_ISSUER) return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна только старшей администрации.");

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /takebloger [id игрока]");
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");
    if(GetPlayerYouTubeEx(targetid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "У игрока нет блогерского доступа.");

    RemovePlayerMediaAdminEx(targetid);

    new pname[MAX_PLAYER_NAME], tname[MAX_PLAYER_NAME], text[192];
    MediaAdmin_GetName(playerid, pname, sizeof(pname));
    MediaAdmin_GetName(targetid, tname, sizeof(tname));

    format(text, sizeof(text), "[A] %s[%d] снял блогерский доступ с игрока %s[%d].", pname, playerid, tname, targetid);
    SendMessageToAdmins(text, 0xD952C2FF);
    SendClientMessage(targetid, 0xCECECEFF, "С Вас сняли блогерский доступ.");
    SendClientMessage(playerid, 0xD952C2FF, "Блогерский доступ успешно снят.");
    return 1;
}

// ================= END MEDIA ADMIN SYSTEM =================
