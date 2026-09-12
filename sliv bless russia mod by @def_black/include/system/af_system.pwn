#define AF_CMD_KICK     0            
#define AF_CMD_BAN      1
#define AF_CMD_OFFBAN   2    
#define AF_CMD_JAIL     3
#define AF_CMD_MUTE     4
#define AF_CMD_OFFWARN  5    
#define AF_CMD_WARN     6

enum PLAYER_AF
{
    PLAYER_AF_ID,
    PLAYER_AF_COMMAND,
    PLAYER_AF_COUNT,
    PLAYER_AF_DESCRIPTION[38],
    PLAYER_AF_ID_NAME[24 + 1]
}
new player_af[MAX_PLAYERS][PLAYER_AF];

new af_cmd_lvl[7] = {1, 3, 4, 1, 1, 4, 2};
new af_cmd[7][9] =
{
    "/kick",
    "/ban",
    "/offban",
    "/jail",
    "/mute",
    "/offwarn",
    "/warn"
};
enum AF_STRUCT
{
    AF_Owner_Name[24 + 1],
    AF_Player_Name[24 + 1],
    AF_CommandType,
    AF_Count,
    AF_Player,
    bool:AF_PlayerOff,
    AF_Description[68]
}

new af_list[50][AF_STRUCT];

//af

#define DIALOG_AF_LIST 21421
#define DIALOG_AF_LIST_1 21422
#define DIALOG_AF_MENU 21423
#define DIALOG_CREATE_AF 21424
#define DIALOG_CREATE_AF_CONFIRMATION 21425
cmd:af(playerid)
{
	if(!GetPlayerAdminEx(playerid)) return 0;

    new dialogStr[512];
    format(dialogStr, sizeof(dialogStr),
        "№\tДействие\tОписание\n"\
        "1\tПодать форму\tСоздать новую админ-форму\n"\
        "2\tАктивные формы\tПросмотр активных админ-форм"
    );

    new headers[64];
    format(headers, sizeof(headers), "№\tДействие\tОписание");

    Dialog
    (
        playerid, DIALOG_AF_MENU, DIALOG_STYLE_TABLIST_HEADERS, 
        "Админ-формы",
        dialogStr,
        "Выбрать", "Закрыть"
    );

    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == DIALOG_AF_MENU)
{
    if(response)
    {
        DeletePVar(playerid, "af_command");
        switch(listitem)
        {
            case 0: // Подать форму
            {
                for(new i, s = sizeof af_list, end; i < s; i++) { 
                    if(af_list[i][AF_Player] == -1) { 
                        end = 1; 
                    } 
                    if(i + 1 == s && !end) { 
                        return ShowNewNotification(playerid,  2, 6, 0, 0, "Максимальное количество форм!", "qq"); // вызов уведомление
                    }
                }

                new cmdDialogStr[512];
                format(cmdDialogStr, sizeof(cmdDialogStr),
                    "№\tКоманда\tОписание\n"\
                    "1\t/kick\tКикнуть игрока\n"\
                    "2\t/ban\tЗабанить игрока\n"\
                    "3\t/offban\tОффлайн бан\n"\
                    "4\t/jail\tПосадить в тюрьму\n"\
                    "5\t/mute\tЗаглушить игрока\n"\
                    "6\t/offwarn\tОффлайн варн\n"\
                    "7\t/warn\tВыдать предупреждение"
                );

                new cmdHeaders[64];
                format(cmdHeaders, sizeof(cmdHeaders), "№\tКоманда\tОписание");

                Dialog
                (
                    playerid, DIALOG_CREATE_AF, DIALOG_STYLE_TABLIST_HEADERS,
                    "Выберите команду",
                    cmdDialogStr,
                    "Выбрать", "Закрыть"
                );
            }
                case 1: ShowAFList(playerid, 1);
            }
        }
    }
    if(dialogid == DIALOG_AF_LIST)
    {
        if(!response) return 0;

        new list = GetPVarInt(playerid, "list_af");
        if(listitem == 0 || listitem == 1)
        {
            if(list > 1 && listitem == 1) list--;
            else if(!listitem) list++;

            ShowAFList(playerid, list);

            return 1;
        }

        new af = GetPlayerListitemValue(playerid, listitem - 2);

        if(af_cmd_lvl[af_list[af][AF_CommandType]] > GetPlayerAdminEx(playerid)) 
            return ShowNewNotification(playerid,  2, 6, 0, 0, "Данная команда не доступна вашему уровню", "qq"); // вызов уведомление

        new string[84], cmd = af_list[af][AF_CommandType];
    
        switch(cmd)
        {
            case AF_CMD_KICK, AF_CMD_WARN:
            {
                format(string, sizeof string, "%s %d %s\n", af_cmd[cmd], af_list[af][AF_Player], af_list[af][AF_Description]);
            }
            case AF_CMD_BAN, AF_CMD_JAIL, AF_CMD_MUTE:
            {
                format(string, sizeof string, "%s %d %d %s\n", af_cmd[cmd], af_list[af][AF_Player], af_list[af][AF_Count], af_list[af][AF_Description]);
            }
            case AF_CMD_OFFBAN:
            {
                format(string, sizeof string, "%s %s %d %s\n", af_cmd[cmd], af_list[af][AF_Player_Name], af_list[af][AF_Count], af_list[af][AF_Description]);
            }
            case AF_CMD_OFFWARN:
            {
                format(string, sizeof string, "%s %s %s\n", af_cmd[cmd], af_list[af][AF_Player_Name], af_list[af][AF_Description]);
            }
        }
        
        SetPlayerListitemValue(playerid, 0, af);
        Dialog(playerid, DIALOG_AF_LIST_1, DIALOG_STYLE_LIST, string, "Принять форму\nУдалить форму", "Выбрать",  "Выйти");

        printf("S | ID: %d CommandType: %d String: %s", af, af_list[af][AF_CommandType], string);
    }
    if(dialogid == DIALOG_AF_LIST_1)
    {
        if(response)
        {
            new id = GetPlayerListitemValue(playerid, 0);

            switch(listitem)
            {
                case 0: {
                    new params[148];

                    printf("START |ID: %d CommandType: %d Params: %s", id, af_list[id][AF_CommandType], af_list[id][AF_Description]);

                    switch(af_list[id][AF_CommandType])
                    {
                        case AF_CMD_KICK: { 

                            print("Start Type Kick"); 

                            format(params, sizeof params, "%d %s", af_list[id][AF_Player], af_list[id][AF_Description]);

                            if(GetPlayerAdminEx(playerid) < 1) return 1;

                            if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /kick [id игрока] [причина (необязательно)]");

                            extract params -> new to_player;

                            if(!IsPlayerConnected(to_player)) return ShowNewNotification(playerid,  2, 3, 0, 0, "Такого игрока нет", "qq"); // вызов уведомление
                            else if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return ShowNewNotification(playerid,  2, 3, 0, 0, "Нельзя кикнуть администратора выше по рангу!", "qq");

                            new reason[31];
                            sscanf(params, "{d}s[30]", reason);

                            new fmt_msg[200];
                            format(fmt_msg, sizeof fmt_msg, "Администратор %s отключил от сервера игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

                            if(strlen(reason) > 0)
                                format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

                            SendClientMessageToAll(0xFF5533FF, fmt_msg);
                                AdminKicks[playerid]++;

                            SendClientMessage(to_player, 0xCECECEFF, fmt_msg, sizeof fmt_msg, "{CC6600}Вас отключили от сервера можете выйти");
                            Kick:(playerid);

                            format(fmt_msg, sizeof fmt_msg, "Кикнул %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
                            new adminName[MAX_PLAYER_NAME];
                            GetPlayerName(playerid, adminName, sizeof(adminName));
                            AdminStats_UpdateKick(adminName, reason);
                            SaveAdminStats(adminName);
                            SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

                            Kick:(playerid, "Сервер оборвал соеденение.", 3000);

                            print("Type Kick"); 
                        }
                        case AF_CMD_JAIL:
                        {
                            format(params, sizeof params, "%d %d %s", af_list[id][AF_Player], af_list[id][AF_Count], af_list[id][AF_Description]);

                            if(af_list[id][AF_PlayerOff]) {

                                mysql_format(mysql, params, sizeof params, "UPDATE accounts SET jail = %d WHERE id = %d", af_list[id][AF_Count] * 60 /*перевод в секунды*/ , af_list[id][AF_Player]);
                                mysql_query(mysql, params, false);

                                SendClientMessage(playerid, -1, "Наказание выдано оффлайн");
                            }
                            else {
                                 printf("Start Type Jail");

                                if(GetPlayerAdminEx(playerid) < 1) return printf("GetPlayerAdminEx(playerid) < 1");

                                if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /jail [id игрока] [время в минутах] [причина]");

                                 printf("strlen complete");

                                extract params -> new to_player, jail_time, string: reason[30];

                                printf("extract complete: to_player: %d jail_time:%d reason: %s | params: %s", to_player, jail_time, reason, params);

                                if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
                                    return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

                                printf("connect complete");

                                if(!(1 <= jail_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, "Время должно быть не меньше 1 и не больше 360 минут");
                                if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок уже сидит в тюрьме");
                                else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить затычку самому себе");

                                 printf("anitsliv complete Type Jail");

                                new fmt_msg[128];
                                format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);

                                if(strlen(reason))
                                    format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

                                SendClientMessageToAll(0xFF5533FF, fmt_msg);

                                SendClientMessage(to_player, 0xCECECEFF, "Время до окончания заключения: {CCCC00}/time");

                                JailPlayer(to_player, jail_time);
                                    AdminJails[playerid]++;

                                format(fmt_msg, sizeof fmt_msg, "Посадил в тюрьму %s[acc:%d] на %d мин. Причина: %s",
                                GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), jail_time, reason);
                                new adminName[MAX_PLAYER_NAME];
                                GetPlayerName(playerid, adminName, sizeof(adminName));
                                AdminStats_UpdateJail(adminName, reason);
                                SaveAdminStats(adminName);

                                SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
                            }

                            printf("Type Jail | off: %d", af_list[id][AF_PlayerOff]);

                        }
                        case AF_CMD_MUTE:
                        {
                            format(params, sizeof params, "%d %d %s", af_list[id][AF_Player], af_list[id][AF_Count], af_list[id][AF_Description]);

                            if(af_list[id][AF_PlayerOff]) {

                                mysql_format(mysql, params, sizeof params, "UPDATE accounts SET mute = %d WHERE id = %d", af_list[id][AF_Count] * 60 /*перевод в секунды*/ , af_list[id][AF_Player]);
                                mysql_query(mysql, params, false);

                                ShowNewNotification(playerid,  0, 3, 0, 0, "Наказание было выдано OFFLINE!", "qq");
                            }
                            else {

                                printf("STart Type Mute");

                                if(GetPlayerAdminEx(playerid) < 1) return 1;


                                if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /mute [id игрока] [время в минутах] [причина (необязательно)]");

                                extract params -> new to_player, mute_time, string: reason[30];

                                if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
                                    return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

                                if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, "Время должно быть не меньше 1 и не больше 360 минут");
                                if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока уже есть мут");
                                if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить затычку администратору выше по рангу");


                                new fmt_msg[128];
                                format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);
                                new adminName[MAX_PLAYER_NAME];
                                GetPlayerName(playerid, adminName, sizeof(adminName));
                                AdminStats_UpdateMute(adminName, reason);
                                SaveAdminStats(adminName);

                                if(strlen(reason))
                                    format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

                                SendClientMessageToAll(0xFF5533FF, fmt_msg);

                                SetPlayerData(to_player, P_MUTE, mute_time * 60);
                                UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);
                                    AdminMutes[playerid]++;

                                SendClientMessage(to_player, 0xCECECEFF, "Время до окончания бана чата: {CCCC00}/time");

                                format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d мин. Причина: %s",
                                GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time, reason);

                                SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
                            }
                            printf("Type Mute | off: %d", af_list[id][AF_PlayerOff]);
                        }
                        case AF_CMD_BAN:
                        {
                            print("start Type БАн");

                            format(params, sizeof params, "%d %d %s", af_list[id][AF_Player], af_list[id][AF_Count], af_list[id][AF_Description]);
                    
                            if (TEST_SERVER == 1)
                                return SendClientMessage(playerid, -1, "{ff2400}[INFO] {ffffff}Данная команда не доступна на ТЕСТ СЕРВЕРЕ!");

                            if (GetPlayerAdminEx(playerid) < 3)
                                return ShowNotification(playerid, 2, "У вас нет доступа к использованию данной команде", 3, "", "");

                            if (!strlen(params))
                                return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /ban [ник/ID игрока] [дней] [причина]");

                            new target_str[32], days, reason[64];
                            if (sscanf(params, "s[32]iS()[64]", target_str, days, reason))
                                return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /ban [ник/ID игрока] [дней] [причина]");

                            if (!(1 <= days <= 1000))
                                return SendClientMessage(playerid, 0x999999FF, "{ff4242}[Информация] {d6d6d6}Срок блокировки должен быть от 1 до 1000 дней");

                            new target_id = -1, is_online = 0;
                            new uid = 0, admin_level = 0, ip[16], target_name[MAX_PLAYER_NAME];

                            if (IsNumeric(target_str))
                            {
                                target_id = strval(target_str);
                                if (IsPlayerConnected(target_id) && IsPlayerLogged(target_id))
                                is_online = 1;
                            }

                            if (!is_online)
                            {
                                for (new i = 0; i < MAX_PLAYERS; i++)
                                {
                                if (!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
                                if (strfind(GetPlayerNameEx(i), target_str, true) != -1)
                                {
                                    target_id = i;
                                    is_online = 1;
                                    break;
                                }
                                }
                            }

                            if (is_online)
                            {
                                if (GetPlayerAdminEx(target_id) > GetPlayerAdminEx(playerid))
                                return SendClientMessage(playerid, 0x999999FF, "Нельзя забанить администратора выше по рангу");

                                uid = GetPlayerAccountID(target_id);
                                admin_level = GetPlayerAdminEx(target_id);
                                GetPlayerIp(target_id, ip, sizeof ip);
                                format(target_name, sizeof target_name, "%s", GetPlayerNameEx(target_id));
                            }
                            else
                            {
                                if (IsPlayerConnected(GetPlayerID(target_str)))
                                return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем сейчас в игре");

                                new query[128], Cache: result, rows;
                                mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip FROM accounts WHERE name='%s'", target_str);
                                result = mysql_query(mysql, query, true);

                                rows = cache_num_rows();
                                if (rows)
                                {
                                uid = cache_get_row_int(0, 0);
                                admin_level = cache_get_row_int(0, 1);
                                cache_get_row(0, 2, ip);
                                }
                                cache_delete(result);

                                if (!rows || !uid)
                                return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

                                if (GetPlayerAdminEx(playerid) < admin_level)
                                return SendClientMessage(playerid, 0x999999FF, "Нельзя забанить администратора выше по рангу");

                                mysql_format(mysql, query, sizeof query, "SELECT 1 FROM ban_list WHERE user_id=%d LIMIT 1", uid);
                                result = mysql_query(mysql, query, true);
                                if (cache_num_rows())
                                {
                                cache_delete(result);
                                return SendClientMessage(playerid, 0x999999FF, "Аккаунт игрока уже заблокирован");
                                }
                                cache_delete(result);

                                format(target_name, sizeof target_name, "%s", target_str);
                            }


                            if (!strlen(reason)) format(reason, sizeof reason, "None");

                            new msg[192];
                            if (!strcmp(reason, "None") == 0)
                            {
                                format(msg, sizeof msg, "Администратор %s заблокировал игрока %s на %d дней. Причина: %s", GetPlayerNameEx(playerid), target_name, days, reason);
                            }
                            else
                            {
                                format(msg, sizeof msg, "Администратор %s заблокировал игрока %s на %d дней", GetPlayerNameEx(playerid), target_name, days);
                            }
                            new adminName[MAX_PLAYER_NAME];
                            GetPlayerName(playerid, adminName, sizeof(adminName));
                            AdminStats_UpdateBan(adminName, reason);
                            SaveAdminStats(adminName);
                            SendClientMessageToAll(0xFF5533FF, msg);

                            new log_msg[192];
                            format(log_msg, sizeof log_msg, "%s забанил %s[acc:%d] на %d дней. Причина: %s", GetPlayerNameEx(playerid), target_name, uid, days, reason);
                            SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, log_msg);

                            if (!is_online)
                                format(reason, sizeof reason, "[BAN]%s", reason);

                            AddBan(uid, gettime(), days, ip, reason, GetPlayerNameEx(playerid));


                            if (is_online)
                            {
                                ShowPlayerLoginDialog(target_id, LOGIN_STATE_CHECK_BAN, false);
                                SetTimerEx("KickBannedPlayer", 100, false, "i", target_id);
                            }
                            
                            print("Type БАн");
                        }
                        case AF_CMD_OFFBAN:
                        {
                            print("start Type OffBan"); 

                            format(params, sizeof params, "%s %d %s", af_list[id][AF_Player_Name], af_list[id][AF_Count], af_list[id][AF_Description]);
                       
                            if(GetPlayerAdminEx(playerid) < 4) return 1;

                            if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /offban [ник игрока] [кол-во дней] [причина]");

                            extract params -> new string: player_name[21], days, string: reason[30];

                            if(!(1 <= days <= 90)) return SendClientMessage(playerid, 0x999999FF, "Количество дней от 1 до 90");

                            if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем находится на сервере");

                            new query[144],
                                Cache: result,
                                rows,
                                uid,
                                admin,
                                uip[16];

                            mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip FROM accounts WHERE name='%s'", player_name);
                            result = mysql_query(mysql, query, true);

                            rows = cache_num_rows();

                            if(rows)
                            {
                                uid = cache_get_row_int(0, 0);
                                admin = cache_get_row_int(0, 1);
                                cache_get_row(0, 2, uip);
                            }

                            cache_delete(result);

                            if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

                            if(GetPlayerAdminEx(playerid) < admin) return SendClientMessage(playerid, 0x999999FF, "Нельзя забанить администратора выше по рангу");

                            mysql_format(mysql, query, sizeof query, "SELECT * FROM ban_list WHERE user_id=%d", uid);
                            result = mysql_query(mysql, query, true);

                            rows = cache_num_rows();

                            cache_delete(result);

                            if(rows) return SendClientMessage(playerid, 0x999999FF, "Аккаунт игрока уже заблокирован");

                            

                            format(query, sizeof query, "Администратор %s заблокировал игрока %s на %d дней", GetPlayerNameEx(playerid), player_name, days);

                            if(strlen(reason) > 0)
                                format(query, sizeof query, "%s. Причина: %s", query, reason);

                            if(!strlen(reason)) reason = "None";

                            SendClientMessageToAll(0xFF5533FF, query);

                            format(query, sizeof query, "Оффлайн забанил %s[acc:%d] на %d дней. Причина: %s", player_name, uid, days, reason);
                            SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, query);
                            new adminName[MAX_PLAYER_NAME];
                            GetPlayerName(playerid, adminName, sizeof(adminName));
                            AdminStats_UpdateBan(adminName, reason);

                            format(reason, sizeof reason, "s", reason);

                            AddBan(uid, gettime(), days, uip, reason, GetPlayerNameEx(playerid));

                            print("Type OffBan"); 
                        }
                        case AF_CMD_OFFWARN:
                        {
                            print("start Type Offwarn"); 

                            format(params, sizeof params, "%s %s", af_list[id][AF_Player_Name], af_list[id][AF_Description]);
                        
                            if(GetPlayerAdminEx(playerid) < 2) return 1;

                            if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /offwarn [никнейм игрока] [причина]");

                            new player_name[MAX_PLAYER_NAME], reason[66];
                            if(sscanf(params, "s[24]s[66]", player_name, reason))
                                return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /offwarn [никнейм игрока] [причина]");

                            

                            new targetid = GetPlayerID(player_name);
                            if(targetid != INVALID_PLAYER_ID)
                            {
                                new fmt_text[128];
                                format(fmt_text, sizeof fmt_text, "Игрок %s находится в сети (ID: %d). Используйте /warn", player_name, targetid);
                                ShowNewNotification(playerid, 0, 6, 0, 0, fmt_text, "");
                                return 1;
                            }

                            new query[256];
                            mysql_format(mysql, query, sizeof(query), "SELECT id, warn, warn_time FROM accounts WHERE name = '%e'", player_name);
                            new Cache:result = mysql_query(mysql, query);

                            if(cache_num_rows() == 0)
                            {
                                new fmt_text[128];
                                format(fmt_text, sizeof fmt_text, "Игрок с ником %s не найден в базе данных", player_name);
                                ShowNewNotification(playerid, 0, 6, 0, 0, fmt_text, "");
                                cache_delete(result);
                                return 1;
                            }

                            new account_id, current_warns, warn_time;
                            new query_result[32];

                            cache_get_field_content(0, "id", query_result, mysql);
                            account_id = strval(query_result);

                            cache_get_field_content(0, "warn", query_result, mysql);
                            current_warns = strval(query_result);

                            cache_get_field_content(0, "warn_time", query_result, mysql);
                            warn_time = strval(query_result);

                            cache_delete(result);

                            new new_warns = current_warns + 1;
                            new new_warn_time = gettime() + (86400 * 10);

                            new fmt_msg[128];
                            format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал оффлайн-предупреждение игроку %s [%d|3]", GetPlayerNameEx(playerid), player_name, new_warns);

                            if(strlen(reason) > 0)
                                format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

                            SendClientMessageToAll(0xFF5533FF, fmt_msg);
                            new update_query[256];
                            mysql_format(mysql, update_query, sizeof(update_query),
                                "UPDATE accounts SET warn = %d, warn_time = %d WHERE id = %d",
                                new_warns, new_warn_time, account_id);
                            mysql_tquery(mysql, update_query);

                            AdminWarns[playerid]++;

                            new log_msg[128];
                            format(log_msg, sizeof log_msg, "Выдал оффлайн-варн %s[acc:%d] (%d/3). Причина: %s", player_name, account_id, new_warns, reason);
                            SendLog(playerid, LOG_TYPE_ADMIN_ACTION, log_msg);

                            new adminName[MAX_PLAYER_NAME];
                            GetPlayerName(playerid, adminName, sizeof(adminName));
                            AdminStats_UpdateWarn(adminName, reason);
                            SaveAdminStats(adminName);

                            if(new_warns >= 3)
                            {
                                new ban_msg[128];
                                format(ban_msg, sizeof ban_msg, "Аккаунт %s заблокирован на 10 дней (получено 3 варна)", player_name);
                                SendClientMessageToAll(0xFF5533FF, ban_msg);

                                mysql_format(mysql, update_query, sizeof(update_query),
                                    "UPDATE accounts SET warn = 0, warn_time = 0 WHERE id = %d", account_id);
                                mysql_tquery(mysql, update_query);

                                mysql_format(mysql, update_query, sizeof(update_query),
                                    "INSERT INTO bans (account_id, ban_time, ban_days, ban_reason, admin_name) VALUES (%d, %d, %d, '%e', '%e')",
                                    account_id, gettime(), 10, "получено 3 варна", GetPlayerNameEx(playerid));
                                mysql_tquery(mysql, update_query);
                            }
                            
                            print("Type OffWarn"); 
                        }
                        case AF_CMD_WARN:
                        {
                            print("start Type Warn"); 

                            format(params, sizeof params, "%s %s", af_list[id][AF_Player_Name], af_list[id][AF_Description]);
                        
                            if(GetPlayerAdminEx(playerid) < 2) return 1;

                            if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Информация] {d6d6d6}Используйте:  /warn [id игрока] [причина (необязательно)]");

                            extract params -> new to_player, string:reason[66];

                            if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
                                return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

                            if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
                                return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать предупреждение админу выше по рангу");


                            

                            AddPlayerData(to_player, P_WARN, +, 1);
                            SetPlayerData(to_player, P_WARN_TIME, gettime() + (86400 * 10));
                                AdminWarns[playerid]++;

                            new fmt_msg[128];
                            format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал предупреждение игроку %s [%d|3]", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), GetPlayerData(to_player, P_WARN));
                            GivePlayerDonateRub(playerid, 4);

                            if(strlen(reason) > 0)
                                format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

                            SendClientMessageToAll(0xFF5533FF, fmt_msg);

                            InvitePlayer(to_player, 0, 0, true);

                            new uid = GetPlayerAccountID(to_player);
                            new warns = GetPlayerData(to_player, P_WARN);
                            new warns_time = GetPlayerData(to_player, P_WARN_TIME);

                            format(fmt_msg, sizeof fmt_msg, "Выдал варн %s[acc:%d] (%d/3). Причина: %d", GetPlayerNameEx(to_player), uid, warns, reason);
                            SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
                            new adminName[MAX_PLAYER_NAME];
                            GetPlayerName(playerid, adminName, sizeof(adminName));
                            AdminStats_UpdateWarn(adminName, reason);
                            SaveAdminStats(adminName);

                            if(warns >= 3)
                            {
                                SendClientMessage(to_player, 0xFF5533FF, "Аккаунт заблокирован на 10 дней");

                                warns =
                                warns_time = 0;

                                AddBan(uid, gettime(), 10, GetPlayerIpEx(to_player), "получено 3 варна", GetPlayerNameEx(playerid));
                                BanEx(to_player, "получено 3 варна");
                            }
                            else Kick:(to_player);


                            format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET warn=%d,warn_time=%d WHERE id=%d", warns, warns_time, uid);
                            mysql_query(mysql, fmt_msg, false);

                            print("Type Warn"); 
                        }
                    }

                    printf("END |ID: %d CommandType: %d Params: %s", id, af_list[id][AF_CommandType], params);

                    DefaultAF(id);
                    ShowNewNotification(playerid,  0, 3, 0, 0, "Вы приняли данную форму!", "qq");
            
                }
                case 1: {
                    DefaultAF(id);
                    ShowNewNotification(playerid,  0, 3, 0, 0, "Вы удалили данную форму!", "qq");
                }
            }
        }
    }
    if(dialogid == DIALOG_CREATE_AF_CONFIRMATION)
    {
        if(response) 
        {
            CreateAF(playerid, GetPVarInt(playerid, "af_command")-1, true, "");
        }
    }
    if(dialogid == DIALOG_CREATE_AF)
{
    if(!response) return 1;

    if(GetPVarInt(playerid, "af_command")) { CreateAF(playerid, GetPVarInt(playerid, "af_command")-1, false, inputtext); return 1; }

    SetPVarInt(playerid, "af_command", listitem + 1);

    switch(listitem)
    {
        case AF_CMD_KICK:
        {
            Dialog
            (
                playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT,
                "Создание админ-формы | {CA5757}/kick",
                "Введите данные для создания формы на {CA5757}/kick\n\n\
                {FFFFFF}Образец ввода:\n\
                {CA5757}[ID/ник] [причина]\n\n\
                {FFFFFF}Пример:\n\
                {CA5757}123 Помеха",
                "Подать форму", "Назад"
            );
        }
        case AF_CMD_BAN:
        {
            Dialog
            (
                playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, 
                "Создание админ-формы | {CA5757}/ban",
                "Введите данные для создания формы на {CA5757}/ban\n\n\
                {FFFFFF}Образец ввода:\n\
                {CA5757}[ID/ник] [дни] [причина]\n\n\
                {FFFFFF}Пример:\n\
                {CA5757}123 7 Оскорбление родни",
                "Подать форму", "Назад"
            );
        }
        case AF_CMD_OFFBAN:
        {
            Dialog
            (
                playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, 
                "Создание админ-формы | {CA5757}/offban",
                "Введите данные для создания формы на {CA5757}/offban\n\n\
                {FFFFFF}Образец ввода:\n\
                {CA5757}[NickName] [дни] [причина]\n\n\
                {FFFFFF}Пример:\n\
                {CA5757}Player_Name 7 Оскорбление родни",
                "Подать форму", "Назад"
            );
        }
        case AF_CMD_JAIL:
        {
            Dialog
            (
                playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, 
                "Создание админ-формы | {CA5757}/jail",
                "Введите данные для создания формы на {CA5757}/jail\n\n\
                {FFFFFF}Образец ввода:\n\
                {CA5757}[ID/ник] [минуты] [причина]\n\n\
                {FFFFFF}Пример:\n\
                {CA5757}123 30 DM",
                "Подать форму", "Назад"
            );
        }
        case AF_CMD_MUTE:
        {
            Dialog
            (
                playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, 
                "Создание админ-формы | {CA5757}/mute",
                "Введите данные для создания формы на {CA5757}/mute\n\n\
                {FFFFFF}Образец ввода:\n\
                {CA5757}[ID/ник] [минуты] [причина]\n\n\
                {FFFFFF}Пример:\n\
                {CA5757}123 180 Упоминание родни",
                "Подать форму", "Назад"
            );
        }
        case AF_CMD_OFFWARN:
        {
            Dialog
            (
                playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, 
                "Создание админ-формы | {CA5757}/offwarn",
                "Введите данные для создания формы на {CA5757}/offwarn\n\n\
                {FFFFFF}Образец ввода:\n\
                {CA5757}[NickName] [причина]\n\n\
                {FFFFFF}Пример:\n\
                {CA5757}Player_Name NonRP Cop",
                "Подать форму", "Назад"
            );
        }
        case AF_CMD_WARN:
        {
            Dialog
            (
                playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, 
                "Создание админ-формы | {CA5757}/warn",
                "Введите данные для создания формы на {CA5757}/warn\n\n\
                {FFFFFF}Образец ввода:\n\
                {CA5757}[ID/ник] [причина]\n\n\
                {FFFFFF}Пример:\n\
                {CA5757}123 NonRP Cop",
                "Подать форму", "Назад"
            );
        }
    }
}
   
    #if defined af_OnDialogResponse
    return af_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse af_OnDialogResponse
#if defined af_OnDialogResponse
forward af_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif


stock CreateAF(playerid, command, bool:confirmation = false, inputtext[])
{
    new string[144];

    new firstname[14], lastname[14], support_name[32];

    sscanf(GetPlayerNameEx(playerid), "p<_>s[14]s[14]", firstname, lastname);

    format(support_name, 28, " | %c.%s", firstname[0], lastname);

    new id = -1, desc[36], nickname[24], count;

    if(confirmation) {
        for(new slot, s = sizeof af_list; slot < s; slot++) {
            if(af_list[slot][AF_Player] == -1) {
                af_list[slot][AF_CommandType] = command;
                af_list[slot][AF_Player] = player_af[playerid][PLAYER_AF_ID];
                af_list[slot][AF_PlayerOff] = false;
                af_list[slot][AF_Description][0] = '\0';
                af_list[slot][AF_Owner_Name][0] = '\0';
                af_list[slot][AF_Player_Name][0] = '\0';
                af_list[slot][AF_Count] = player_af[playerid][PLAYER_AF_COUNT];
                strcat(af_list[slot][AF_Description], player_af[playerid][PLAYER_AF_DESCRIPTION]);
                strcat(af_list[slot][AF_Owner_Name], GetPlayerNameEx(playerid));
                strcat(af_list[slot][AF_Player_Name], player_af[playerid][PLAYER_AF_ID_NAME]);

                format(string, sizeof string, "{CA5757}[A] %s внес новую административную форму (/af).", GetPlayerNameEx(playerid));
                SendMessageToAdmins(string, -1);

                printf("CREATE AF: ID: %d Player: %d CommandType: %d Count: %d", slot, af_list[slot][AF_Player], af_list[slot][AF_CommandType], 
                af_list[slot][AF_Count]);
                
                return 1;
            }
        }
    }

    switch(command)
    {
        case AF_CMD_KICK:
        {
            if(sscanf(inputtext, "p< >ds[36]", id, desc) && sscanf(inputtext, "p< >s[24]s[36]", nickname, desc)) return ShowNewNotification(playerid,  2, 3, 0, 0, "Вы ввели неверные данные!", "qq");
            
            
            if(strlen(nickname)) {
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
                    else if(GetPlayerAdminEx(i)) continue;

                    if(strfind(GetPlayerNameEx(i), nickname) != -1) {
                        id = i;
                        break;
                    }
                }
            }

            if(id == -1 || !IsPlayerConnected(id) || GetPlayerAdminEx(id) || id == playerid) return SendClientMessage(playerid, -1, "Данный игрок не в сети");

           strcat(desc, support_name);

            for(new i, s = sizeof af_list; i < s; i++) {
                if(af_list[i][AF_Player] == -1) {

                    format(string, sizeof string, "Вы действительно хотите отправить форму на %s %d %s", af_cmd[command],id, desc);
                    Dialog(playerid, DIALOG_CREATE_AF_CONFIRMATION, DIALOG_STYLE_MSGBOX, "Подтверждение", string, "Да", "Нет");
                    player_af[playerid][PLAYER_AF_ID] = id;
                    player_af[playerid][PLAYER_AF_COMMAND] = command;
                    player_af[playerid][PLAYER_AF_DESCRIPTION][0] = '\0';
                    strcat(player_af[playerid][PLAYER_AF_DESCRIPTION], desc);
                    player_af[playerid][PLAYER_AF_ID_NAME][0] = '\0';
                    strcat(player_af[playerid][PLAYER_AF_ID_NAME], GetPlayerNameEx(id));
                    break;
                }
            }
        }
        case AF_CMD_BAN, AF_CMD_JAIL, AF_CMD_MUTE:
        {
            if(sscanf(inputtext, "p< >dds[36]", id, count, desc) && sscanf(inputtext, "p< >s[24]ds[36]", nickname, count, desc))
                 return ShowNewNotification(playerid,  2, 3, 0, 0, "Вы ввели неверные данные!", "qq");
            
            if(strlen(nickname)) {
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
                    else if(GetPlayerAdminEx(i)) continue;

                    if(strfind(GetPlayerNameEx(i), nickname) != -1) {
                        id = i;
                        break;
                    }
                }
            }

            if(id == -1 || !IsPlayerConnected(id) || GetPlayerAdminEx(id) || id == playerid) return ShowNewNotification(playerid,  2, 3, 0, 0, "Данный игрок не в сети!", "qq");
            

            strcat(desc, support_name);

            for(new i, s = sizeof af_list; i < s; i++) {
                if(af_list[i][AF_Player] == -1) {

                    format(string, sizeof string, "Вы действительно хотите отправить форму на %s %d %d %s", af_cmd[command], id, count, desc);
                    Dialog(playerid, DIALOG_CREATE_AF_CONFIRMATION, DIALOG_STYLE_MSGBOX, "Подтверждение", string, "Да", "Нет");
                    player_af[playerid][PLAYER_AF_ID] = id;
                    player_af[playerid][PLAYER_AF_COMMAND] = command;
                    player_af[playerid][PLAYER_AF_COUNT] = count;
                    player_af[playerid][PLAYER_AF_DESCRIPTION][0] = '\0';
                    strcat(player_af[playerid][PLAYER_AF_DESCRIPTION], desc);
                    player_af[playerid][PLAYER_AF_ID_NAME][0] = '\0';
                    strcat(player_af[playerid][PLAYER_AF_ID_NAME], GetPlayerNameEx(id));
                    break;
                }
            }
        }
        case AF_CMD_OFFBAN:
        {
            if(sscanf(inputtext, "p< >s[24]ds[36]", nickname, count, desc)) return ShowNewNotification(playerid,  2, 3, 0, 0, "Вы ввели неверные данные!", "qq");
            
            
            mysql_format(mysql, string, sizeof string, "SELECT id, admin FROM accounts WHERE name = '%s'", nickname);
            new Cache:cache = mysql_query(mysql, string);

            if(cache_num_rows()) {
                new admin, id_sql, name[24];

                admin = cache_get_row_int(0, 1);

                if(!admin) {
                    id_sql = cache_get_row_int(0, 0);

                    if(id_sql != GetPlayerAccountID(playerid))
                    {
                           
                            for(new i, s = sizeof af_list; i < s; i++) {
                                if(af_list[i][AF_Player] == -1) {
                                    strcat(desc, support_name);
                                    format(string, sizeof string, "Вы действительно хотите отправить форму на %s %s %d %s", af_cmd[command], nickname, count, desc);
                                    Dialog(playerid, DIALOG_CREATE_AF_CONFIRMATION, DIALOG_STYLE_MSGBOX, "Подтверждение", string, "Да", "Нет");
                                    player_af[playerid][PLAYER_AF_ID] = id_sql;
                                    player_af[playerid][PLAYER_AF_COMMAND] = command;
                                    player_af[playerid][PLAYER_AF_COUNT] = count;
                                    player_af[playerid][PLAYER_AF_DESCRIPTION][0] = '\0';
                                    cache_get_row(0, 2, player_af[playerid][PLAYER_AF_ID_NAME]);
                                    strcat(player_af[playerid][PLAYER_AF_DESCRIPTION], desc);
                                    player_af[playerid][PLAYER_AF_ID_NAME][0] = '\0';
                                    strcat(player_af[playerid][PLAYER_AF_ID_NAME], nickname);
                                    break;
                                }
                            }
                    }
                    else ShowNewNotification(playerid,  2, 3, 0, 0, "Вы не можете отправить форму на самого себя!", "qq");
            
                }
                else ShowNewNotification(playerid,  2, 3, 0, 0, "Данный игрок является администратором", "qq");
            
            }
            else ShowNewNotification(playerid,  2, 3, 0, 0, "Данный игрок не найден", "qq");
            

            cache_delete(cache);
        }
        case AF_CMD_OFFWARN:
        {
            if(sscanf(inputtext, "p< >s[24]s[36]", nickname, desc)) return ShowNewNotification(playerid,  2, 3, 0, 0, "Вы ввели неверные данные!", "qq");
            
            
            mysql_format(mysql, string, sizeof string, "SELECT id, admin FROM accounts WHERE name = '%s'", nickname);
            new Cache:cache = mysql_query(mysql, string);

            if(cache_num_rows()) {
                new admin, id_sql, name[ 24 + 1 ];

                admin = cache_get_row_int(0, 1);

                if(!admin) {
                    id_sql = cache_get_row_int(0, 0);

                    if(id_sql != GetPlayerAccountID(playerid))
                    {
                            for(new i, s = sizeof af_list; i < s; i++) {
                                if(af_list[i][AF_Player] == -1) {
                                    strcat(desc, support_name);
                                    format(string, sizeof string, "Вы действительно хотите отправить форму на %s %s %s", af_cmd[command], nickname, desc);
                                    Dialog(playerid, DIALOG_CREATE_AF_CONFIRMATION, DIALOG_STYLE_MSGBOX, "Подтверждение", string, "Да", "Нет");
                                    player_af[playerid][PLAYER_AF_ID] = id_sql;
                                    player_af[playerid][PLAYER_AF_COMMAND] = command;
                                    player_af[playerid][PLAYER_AF_DESCRIPTION][0] = '\0';
                                    cache_get_row(0, 2, player_af[playerid][PLAYER_AF_ID_NAME]);
                                    strcat(player_af[playerid][PLAYER_AF_DESCRIPTION], desc);
                                    player_af[playerid][PLAYER_AF_ID_NAME][0] = '\0';
                                    strcat(player_af[playerid][PLAYER_AF_ID_NAME], nickname);
                                    break;
                                }
                            }
                    }
                    else ShowNewNotification(playerid,  2, 3, 0, 0, "Вы не можете отправить форму на самого себя!", "qq");
            
                }
                else ShowNewNotification(playerid,  2, 3, 0, 0, "Данный игрок является администратором", "qq");
            
            }
            else ShowNewNotification(playerid,  2, 3, 0, 0, "Данный игрок не найден", "qq");
            
        }
        case AF_CMD_WARN:
        {
            if(sscanf(inputtext, "p< >ds[36]", id, desc)
             && sscanf(inputtext, "p< >s[24]s[36]", nickname, desc)) return ShowNewNotification(playerid,  2, 3, 0, 0, "Вы ввели неверные данные!", "qq");
            
            
            if(strlen(nickname)) {
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
                    else if(GetPlayerAdminEx(i)) continue;

                    if(strfind(GetPlayerNameEx(i), nickname) != -1) {
                        id = i;
                        break;
                    }
                }
            }

            if(id == -1 || !IsPlayerConnected(id) || GetPlayerAdminEx(id) || id == playerid) return SendClientMessage(playerid, -1, "Данный игрок не в сети");

           strcat(desc, support_name);

            for(new i, s = sizeof af_list; i < s; i++) {
                if(af_list[i][AF_Player] == -1) {

                    format(string, sizeof string, "Вы действительно хотите отправить форму на %s %d %s", af_cmd[command], id, desc);
                    Dialog(playerid, DIALOG_CREATE_AF_CONFIRMATION, DIALOG_STYLE_MSGBOX, "Подтверждение", string, "Да", "Нет");
                    player_af[playerid][PLAYER_AF_ID] = id;
                    player_af[playerid][PLAYER_AF_COMMAND] = command;
                    player_af[playerid][PLAYER_AF_DESCRIPTION][0] = '\0';
                    strcat(player_af[playerid][PLAYER_AF_DESCRIPTION], desc);
                    player_af[playerid][PLAYER_AF_ID_NAME][0] = '\0';
                    strcat(player_af[playerid][PLAYER_AF_ID_NAME], GetPlayerNameEx(id));
                    break;
                }
            }
        }
    }
    return 1;
}

stock ShowAFList(playerid, list_number)
{
    new list_count = list_number * 10;

    if(sizeof af_list < list_count) list_count = sizeof af_list;

    new list[68], c, dialog[sizeof list * 10 + 48] = "- Следующий список\n- Предыдущий список\n";
    
    for(new i = list_count-10, cmd; i < list_count; i++)
    {
        if(af_list[i][AF_Player] == -1) continue;

        cmd = af_list[i][AF_CommandType];

        switch(cmd)
        {
            case AF_CMD_KICK, AF_CMD_WARN:
            {
                format(list, sizeof list, "%s %d %s\n", af_cmd[cmd], af_list[i][AF_Player], af_list[i][AF_Description]);
            }
            case AF_CMD_BAN, AF_CMD_JAIL, AF_CMD_MUTE:
            {
                format(list, sizeof list, "%s %d %d %s\n", af_cmd[cmd], af_list[i][AF_Player], af_list[i][AF_Count], af_list[i][AF_Description]);
            }
            case AF_CMD_OFFBAN:
            {
                format(list, sizeof list, "%s %s %d %s\n", af_cmd[cmd], af_list[i][AF_Player_Name], af_list[i][AF_Count], af_list[i][AF_Description]);
            }
            case AF_CMD_OFFWARN:
            {
                format(list, sizeof list, "%s %s %s\n", af_cmd[cmd], af_list[i][AF_Player_Name], af_list[i][AF_Description]);
            }
        }

        SetPlayerListitemValue(playerid, c, i);
        strcat(dialog, list);
        c++;
    }
    
    if(!c) return ShowNewNotification(playerid,  2, 3, 0, 0, "Формы отсутствуют", "qq");
            

    Dialog(playerid, DIALOG_AF_LIST, DIALOG_STYLE_LIST, "Список админ-форм", dialog, "Далее", "Выйти");

    SetPVarInt(playerid, "list_af", list_number);

    return 1;
}


/*

    new firstname[14], lastname[14], support_name[28];

    sscanf(GetPlayerNameEx(playerid), "p<_>s[14]s[14]", firstname, lastname);

    format(support_name, 28, "%c.%s", first_name[0], lastname);


*/

/*
    new id = -1, desc[18], nickname[24], count;

    if(sscanf(inputtext, "p< >s[24]ds[18]", nickname, count, desc) && 
    sscanf(inputtext, "p< >dds[18]", id, count, desc)) return ShowNewNotification(playerid,  2, 3, 0, 0, "Вы ввели неверные данные!", "qq");
            
    
    if(strlen(nickname)) {
        foreach(new i : Player)
        {
            if(strfind(GetPlayerNameEx(i), nickname) != -1) {
                id = i;
                break;
            }
        }
    }

    if(id == -1) return ShowNewNotification(playerid,  2, 3, 0, 0, "Данный игрок не в сети!", "qq");
            

    ///код
*/

/*
    if(sscanf(inputtext, "p< >s[24]ds[18]", nickname, count, desc))
    return ShowNewNotification(playerid,  2, 3, 0, 0, "Вы ввели неверные данные!", "qq");
            

    new string[184];

    mysql_format(mysql, string, sizeof string, "SELECT * FROM accounts WHERE name = '%s'", nickname);
    new Cache:cache = mysql_query(mysql, string, true);

    if(cache_num_rows()) {
    
    }
    else ShowNewNotification(playerid,  2, 3, 0, 0, "Игрок с таким именем не найден!", "qq");
            

    cache_delete(cache);
*/

/*

*/

/*

OnPlayerDisconnect


*/

stock DefaultAF(id)
{
    af_list[id][AF_Player] = -1;
    af_list[id][AF_CommandType] = -1;
    af_list[id][AF_Description][0] = '\0';
    af_list[id][AF_Owner_Name][0] = '\0';
    af_list[id][AF_PlayerOff] = false;

    return 1;
}

public OnGameModeInit()
{
    for(new i, s = sizeof af_list; i < s; i++) DefaultAF(i);

    #if defined af_OnGameModeInit
        return af_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit af_OnGameModeInit
#if defined af_OnGameModeInit
    forward af_OnGameModeInit();
#endif

public OnPlayerDisconnect(playerid, reason)
{
    for(new i; i < sizeof af_list; i++)
    {
        if(af_list[i][AF_Player] == -1) continue;
        else if(af_list[i][AF_CommandType] == AF_CMD_OFFBAN || af_list[i][AF_CommandType] == AF_CMD_OFFWARN) continue;
        else if(af_list[i][AF_Player] != playerid) continue;

        switch(af_list[i][AF_CommandType])
        {
            case AF_CMD_BAN:
            {
                af_list[i][AF_Player] = GetPlayerAccountID(playerid);
                af_list[i][AF_CommandType] = AF_CMD_OFFBAN;
            }
            case AF_CMD_WARN:
            {
                af_list[i][AF_Player] = GetPlayerAccountID(playerid);
                af_list[i][AF_CommandType] = AF_CMD_OFFWARN;
            }
            case AF_CMD_KICK: DefaultAF(i);
            default:
            {
                af_list[i][AF_PlayerOff] = true;
                af_list[i][AF_Player] = GetPlayerAccountID(playerid);
            }
        }

    }
    #if defined af_OnPlayerDisconnect
        return af_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect af_OnPlayerDisconnect
#if defined af_OnPlayerDisconnect
    forward af_OnPlayerDisconnect(playerid, reason);
#endif