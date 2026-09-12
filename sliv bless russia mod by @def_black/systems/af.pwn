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

    Dialog
    (
        playerid, DIALOG_AF_MENU, DIALOG_STYLE_LIST, 
        "Админ-формы",
        "Подать форму\nАктивные формы", "Далее" , "Выйти"
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
                case 0:
                {
                    for(new i, s = sizeof af_list, end; i < s; i++) { if(af_list[i][AF_Player] == -1) { end = 1; } if(i + 1 == s && !end) { return SendClientMessage(playerid, -1, "Максимальное кол-во форм"); }}

                    Dialog
                    (
                        playerid, DIALOG_CREATE_AF, DIALOG_STYLE_LIST,
                        "Выберите команду",
                        "/kick\n"\
                        "/ban\n"\
                        "/offban\n"\
                        "/jail\n"\
                        "/mute\n"\
                        "/offwarn\n"\
                        "/warn", "Далее", "Выйти"
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
            return SendClientMessage(playerid, -1, "Данная команда не доступна вашему уровню");

        new string[84], cmd = af_list[af][AF_CommandType];
    
        switch(cmd)
        {
            case AF_CMD_KICK, AF_CMD_WARN:
            {
                format(string, sizeof list, "%s %d %s\n", af_cmd[cmd], af_list[af][AF_Player], af_list[af][AF_Description]);
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
                    new params[124];

                    switch(af_list[id][AF_CommandType])
                    {
                        case AF_CMD_KICK, AF_CMD_WARN:
                        {
                            format(params, sizeof params, "%d %s", af_list[id][AF_Player], af_list[id][AF_Description]);
                        }
                        case AF_CMD_BAN, AF_CMD_JAIL, AF_CMD_MUTE:
                        {
                            format(params, sizeof params, "%d %d %s", af_list[id][AF_Player], af_list[id][AF_Count], af_list[id][AF_Description]);
                        }
                        case AF_CMD_OFFBAN:
                        {
                            format(params, sizeof params, "%s %d %s", af_list[id][AF_Player_Name], af_list[id][AF_Count], af_list[id][AF_Description]);
                        }
                        case AF_CMD_OFFWARN:
                        {
                            format(params, sizeof params, "%s %s", af_list[id][AF_Player_Name], af_list[id][AF_Description]);
                        }
                    }

                    switch(af_list[id][AF_CommandType])
                    {
                        case AF_CMD_KICK: { callcmd::kick(playerid, params); print("Type Kick"); }
                        case AF_CMD_BAN: { callcmd::ban(playerid, params); print("Type Kick"); }
                        case AF_CMD_OFFBAN: { callcmd::offban(playerid, params); print("Type Kick"); }
                        case AF_CMD_JAIL:   {
                            if(af_list[id][AF_PlayerOff]) {

                                mysql_format(mysql, params, sizeof params, "UPDATE accounts SET jail = %d WHERE id = %d", af_list[id][AF_Count] * 60 /*перевод в секунды*/ , af_list[id][AF_Player]);
                                mysql_query(mysql, params, false);

                                SendClientMessage(playerid, -1, "Наказание выдано оффлайн");
                            }
                            else  callcmd::jail(playerid, params);

                            printf("Type Jail | off: %d", af_list[id][AF_PlayerOff]);
                        }
                        case AF_CMD_MUTE:   {
                            if(af_list[id][AF_PlayerOff]) {

                                mysql_format(mysql, params, sizeof params, "UPDATE accounts SET mute = %d WHERE id = %d", af_list[id][AF_Count] * 60 /*перевод в секунды*/ , af_list[id][AF_Player]);
                                mysql_query(mysql, params, false);

                                SendClientMessage(playerid, -1, "Наказание выдано оффлайн");
                            }
                            else callcmd::mute(playerid, params); 
                            printf("Type Mute | off: %d", af_list[id][AF_PlayerOff]);
                        }
                        case AF_CMD_OFFWARN:{ callcmd::offwarn(playerid, params); print("Type OffWarn"); }
                        case AF_CMD_WARN:{ callcmd::warn(playerid, params); print("Type Warn"); }
                    }

                    printf("ID: %d CommandType: %d Params: %s", id, af_list[id][AF_CommandType], params);

                    DefaultAF(id);
                    SendClientMessage(playerid, -1, "Вы приняли форму");
                }
                case 1: {
                    DefaultAF(id);
                    SendClientMessage(playerid, -1, "Вы удалили форму");
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
                    "Создание админ-формы",
                    "Для создание формы на /kick  введите в строку данные, образец\n\
                    [id/nick] [причина]",
                    "Подать", "Выйти"
                );
            }
            case AF_CMD_BAN:
            {
                Dialog
                (
                    playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, "Создание админ-формы",
                    "Для создание формы на /ban  введите в строку данные, образец\n\
                    [id/nick] [кол-во дней] [причина]",
                    "Подать", "Выйти"
                );
            }
            case AF_CMD_OFFBAN:
            {
                Dialog
                (
                    playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, "Создание админ-формы",
                    "Для создание формы на /offban  введите в строку данные, образец\n\
                    [NickName] [кол-во дней] [причина]",
                    "Подать", "Выйти"
                );
            }
            case AF_CMD_JAIL:
            {
                Dialog
                (
                    playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, "Создание админ-формы",
                    "Для создание формы на /jail  введите в строку данные, образец\n\
                    [id/nick] [кол-во минут] [причина]",
                    "Подать", "Выйти"
                );
            }
            case AF_CMD_MUTE:
            {
                Dialog
                (
                    playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, "Создание админ-формы",
                    "Для создание формы на /mute введите в строку данные, образец\n\
                    [id/nick] [кол-во минут] [причина]",
                    "Подать", "Выйти"
                );
            }
            case AF_CMD_OFFWARN:
            {
                Dialog
                (
                    playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, "Создание админ-формы",
                    "Для создание формы на /offwarn  введите в строку данные, образец\n\
                    [NickName] [причина]",
                    "Подать", "Выйти"
                );
            }
            case AF_CMD_WARN:
            {
                Dialog
                (
                    playerid, DIALOG_CREATE_AF, DIALOG_STYLE_INPUT, "Создание админ-формы",
                    "Для создание формы на /warn  введите в строку данные, образец\n\
                    [id/nick] [причина]",
                    "Подать", "Выйти"
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

                format(string, sizeof string, "{FFFF00}[A] %s внес новую административную форму (/af).", GetPlayerNameEx(playerid));
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
            if(sscanf(inputtext, "p< >ds[36]", id, desc) && sscanf(inputtext, "p< >s[24]s[36]", nickname, desc)) return SendClientMessage(playerid, -1, "Вы ввели не правильные данные");
            
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
                 return SendClientMessage(playerid, -1, "Вы ввели не правильные данные");
            
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
            if(sscanf(inputtext, "p< >s[24]ds[36]", nickname, count, desc)) return SendClientMessage(playerid, -1, "Вы ввели не правильные данные");
            
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
                    else SendClientMessage(playerid, -1, "Вы не можете отправить форму на самого себя");
                }
                else SendClientMessage(playerid, -1, "Данный игрок является администратором");
            }
            else SendClientMessage(playerid, -1, "Данный игрок не найден");

            cache_delete(cache);
        }
        case AF_CMD_OFFWARN:
        {
            if(sscanf(inputtext, "p< >s[24]s[36]", nickname, desc)) return SendClientMessage(playerid, -1, "Вы ввели не правильные данные");
            
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
                    else SendClientMessage(playerid, -1, "Вы не можете отправить форму на самого себя");
                }
                else SendClientMessage(playerid, -1, "Данный игрок является администратором");
            }
            else SendClientMessage(playerid, -1, "Данный игрок не найден");
        }
        case AF_CMD_WARN:
        {
            if(sscanf(inputtext, "p< >ds[36]", id, desc)
             && sscanf(inputtext, "p< >s[24]s[36]", nickname, desc)) return SendClientMessage(playerid, -1, "Вы ввели не правильные данные");
            
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

    new list[68], c, dialog[sizeof list * 10 + 48] = "Следующий список\nПредыдущий список\n";
    
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
    
    if(!c) return SendClientMessage(playerid, -1, "На данный момент формы отсуствуют");

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
    sscanf(inputtext, "p< >dds[18]", id, count, desc)) return SendClientMessage(playerid, -1, "Вы ввели не правильные данные");
    
    if(strlen(nickname)) {
        foreach(new i : Player)
        {
            if(strfind(GetPlayerNameEx(i), nickname) != -1) {
                id = i;
                break;
            }
        }
    }

    if(id == -1) return SendClientMessage(playerid, -1, "Данный игрок не в сети");

    ///код
*/

/*
    if(sscanf(inputtext, "p< >s[24]ds[18]", nickname, count, desc))
    return SendClietMessage(playerid, -1, "Вы ввели не правильные данные");

    new string[184];

    mysql_format(mysql, string, sizeof string, "SELECT * FROM accounts WHERE name = '%s'", nickname);
    new Cache:cache = mysql_query(mysql, string, true);

    if(cache_num_rows()) {
    
    }
    else SendClientMessage(playerid, -1, "Игрок с данным именем не найден");

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

cmd:offwarn(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 2) return 1;

    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Администрация] {d6d6d6}Используйте:  /offwarn [Никнейм игрока] [Причина]");

    new player_name[MAX_PLAYER_NAME], reason[66];
    if(sscanf(params, "s[24]s[66]", player_name, reason))
        return SendClientMessage(playerid, 0xCECECEFF, "{ff4242}[Администрация] {d6d6d6}Используйте:  /offwarn [Никнейм игрока] [Причина]");

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
            account_id, gettime(), 10, "Получено 3 варна", GetPlayerNameEx(playerid));
        mysql_tquery(mysql, update_query);
    }

    return 1;
}