#if defined _workbook_included
	#endinput
#endif
#define _workbook_included

// ==============================================================
// =================   ТРУДОВАЯ КНИЖКА (by lordik)   ===========
// ==============================================================
// v2: интерфейс переделан с текстдравов на Dialog — на мобильных
// SA-MP клиентах (например ZR MOSCOW) текстдравы не отображались,
// диалоги поддерживаются надёжно везде.
// ==============================================================

#define WORKBOOK_MYSQL_HANDLE (mysql)
#define MAX_WORK_RECORDS       (60)
#define DIALOG_WORKBOOK         35700

enum e_WORK_RECORD
{
    W_ORG[64],
    W_JOB[64],
    W_DATE_IN[16],
    W_DATE_OUT[16]
}

new g_WorkRecords[MAX_PLAYERS][MAX_WORK_RECORDS][e_WORK_RECORD];
new g_workCount[MAX_PLAYERS];
new g_workbookOffer[MAX_PLAYERS];

stock SetLeaderHireDate(playerid)
{
    new year, month, day;
    getdate(year, month, day);
    format(g_hire_date[playerid], 16, "%02d/%02d/%d", day, month, year);
    return 1;
}

stock LoadWorkbookRecords(playerid)
{
    new query[128];
    mysql_format(WORKBOOK_MYSQL_HANDLE, query, sizeof(query),
        "SELECT `org_name`, `job_name`, `date_in`, `date_out` FROM `workbook` WHERE `account_id` = %d ORDER BY `id` ASC LIMIT %d",
        GetPlayerAccountID(playerid), MAX_WORK_RECORDS);
    mysql_query(WORKBOOK_MYSQL_HANDLE, query);

    new rows = cache_num_rows();
    g_workCount[playerid] = 0;

    if(rows > 0)
    {
        for(new i = 0; i < rows && i < MAX_WORK_RECORDS; i++)
        {
            cache_get_field_content(i, "org_name",  g_WorkRecords[playerid][i][W_ORG],      WORKBOOK_MYSQL_HANDLE, 64);
            cache_get_field_content(i, "job_name",  g_WorkRecords[playerid][i][W_JOB],      WORKBOOK_MYSQL_HANDLE, 64);
            cache_get_field_content(i, "date_in",   g_WorkRecords[playerid][i][W_DATE_IN],  WORKBOOK_MYSQL_HANDLE, 16);
            cache_get_field_content(i, "date_out",  g_WorkRecords[playerid][i][W_DATE_OUT], WORKBOOK_MYSQL_HANDLE, 16);
            g_workCount[playerid]++;
        }
    }
    return 1;
}

stock AddWorkRecord(playerid, org[], job[], date_in[], date_out[])
{
    if(g_workCount[playerid] >= MAX_WORK_RECORDS) return 0;

    new idx = g_workCount[playerid];
    format(g_WorkRecords[playerid][idx][W_ORG],      64, "%s", org);
    format(g_WorkRecords[playerid][idx][W_JOB],      64, "%s", job);
    format(g_WorkRecords[playerid][idx][W_DATE_IN],  16, "%s", date_in);
    format(g_WorkRecords[playerid][idx][W_DATE_OUT], 16, "%s", date_out);
    g_workCount[playerid]++;

    new query[320];
    mysql_format(WORKBOOK_MYSQL_HANDLE, query, sizeof(query),
        "INSERT INTO `workbook` (`account_id`, `org_name`, `job_name`, `date_in`, `date_out`) VALUES (%d, '%e', '%e', '%e', '%e')",
        GetPlayerAccountID(playerid),
        g_WorkRecords[playerid][idx][W_ORG],
        g_WorkRecords[playerid][idx][W_JOB],
        g_WorkRecords[playerid][idx][W_DATE_IN],
        g_WorkRecords[playerid][idx][W_DATE_OUT]
    );
    mysql_query(WORKBOOK_MYSQL_HANDLE, query);
    return 1;
}

stock ShowWorkbookDialog(playerid, targetid)
{
    LoadWorkbookRecords(targetid);

    new text[1600];
    format(text, sizeof text, "{FFD700}Организация\t{FFD700}Должность\t{FFD700}Принят\t{FFD700}Уволен\n");

    if(g_workCount[targetid] == 0)
    {
        strcat(text, "{B3B3B3}Нет записей о трудовой деятельности\n");
    }
    else
    {
        new fmt_str[280];
        for(new i = 0; i < g_workCount[targetid]; i++)
        {
            format(fmt_str, sizeof fmt_str, "{FFFFFF}%s\t%s\t%s\t%s\n",
                g_WorkRecords[targetid][i][W_ORG],
                g_WorkRecords[targetid][i][W_JOB],
                g_WorkRecords[targetid][i][W_DATE_IN],
                g_WorkRecords[targetid][i][W_DATE_OUT]);
            strcat(text, fmt_str);
        }
    }

    new title[80];
    format(title, sizeof title, "{FFD700}Трудовая книжка — %s", GetPlayerNameEx(targetid));

    Dialog(playerid, DIALOG_WORKBOOK, DIALOG_STYLE_TABLIST_HEADERS, title, text, "Закрыть", "");
    return 1;
}

CMD:trudbook(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        ShowWorkbookDialog(playerid, playerid);
        return 1;
    }

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFFFF00FF, "Игрок не найден!");

    if(targetid == playerid)
    {
        ShowWorkbookDialog(playerid, playerid);
        return 1;
    }

    g_workbookOffer[targetid] = playerid;

    new msg[128];
    format(msg, 128, "Игрок %s предлагает Вам посмотреть его трудовую книжку!", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, 0xFFFF00FF, msg);
    SendClientMessage(targetid, 0xFFFF00FF, "Введите /wyes - согласиться, /wno - отказаться");

    format(msg, 128, "Вы отправили запрос игроку %s", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, 0xFFFF00FF, msg);

    return 1;
}

CMD:wyes(playerid, params[])
{
    if(g_workbookOffer[playerid] == -1)
        return SendClientMessage(playerid, 0xFFFF00FF, "У вас нет активных предложений!");

    new offerer = g_workbookOffer[playerid];
    if(!IsPlayerConnected(offerer))
    {
        g_workbookOffer[playerid] = -1;
        return SendClientMessage(playerid, 0xFFFF00FF, "Игрок, отправивший запрос, вышел!");
    }

    ShowWorkbookDialog(playerid, offerer);

    new msg[128];
    format(msg, 128, "Вы открыли трудовую книжку игрока %s", GetPlayerNameEx(offerer));
    SendClientMessage(playerid, 0xFFFF00FF, msg);

    format(msg, 128, "Игрок %s согласился посмотреть Вашу трудовую книжку", GetPlayerNameEx(playerid));
    SendClientMessage(offerer, 0xFFFF00FF, msg);

    g_workbookOffer[playerid] = -1;
    return 1;
}

CMD:wno(playerid, params[])
{
    if(g_workbookOffer[playerid] == -1)
        return SendClientMessage(playerid, 0xFFFF00FF, "У вас нет активных предложений!");

    new offerer = g_workbookOffer[playerid];
    if(IsPlayerConnected(offerer))
    {
        new msg[128];
        format(msg, 128, "Игрок %s отказался смотреть Вашу трудовую книжку", GetPlayerNameEx(playerid));
        SendClientMessage(offerer, 0xFFFF00FF, msg);
    }

    SendClientMessage(playerid, 0xFFFF00FF, "Вы отказались от просмотра трудовой книжки");
    g_workbookOffer[playerid] = -1;
    return 1;
}
