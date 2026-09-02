// =============================================================
//  include/systems/report_gui.pwn
//  Textdraw GUI ответа на /rep (замена dialog 5512)
// =============================================================

#define DIALOG_REPGUI_CUSTOM   20591

#define REPGUI_TEMPLATES 5
new report_gui_templates[REPGUI_TEMPLATES][64] =
{
    "{FFFFFF}Помощь оказана игроку!",
    "{FFFFFF}Оффтоп, репорт закрыт.",
    "{FFFFFF}Обратитесь к хелперам сервера.",
    "{FFFFFF}Слишком большой акк. репорт, разберитесь между собой.",
    "{FFFFFF}Отправьте жалобу на форум сервера."
};

new PlayerText: RepGUI_Box[MAX_PLAYERS];
new PlayerText: RepGUI_Title[MAX_PLAYERS];
new PlayerText: RepGUI_Tpl[MAX_PLAYERS][REPGUI_TEMPLATES];
new PlayerText: RepGUI_Select[MAX_PLAYERS];
new PlayerText: RepGUI_Custom[MAX_PLAYERS];
new PlayerText: RepGUI_Back[MAX_PLAYERS];

new repgui_selected[MAX_PLAYERS] = {-1, ...};
new bool: repgui_created[MAX_PLAYERS] = {false, ...};

/*==================== CREATE ====================*/

stock CreateReportGUI(playerid)
{
    if(repgui_created[playerid]) return 1;

    new Float:bx[REPGUI_TEMPLATES] = {90.0, 183.0, 276.0, 369.0, 462.0};

    RepGUI_Box[playerid] = CreatePlayerTextDraw(playerid, 90.0, 150.0, "_");
    PlayerTextDrawUseBox(playerid, RepGUI_Box[playerid], 1);
    PlayerTextDrawBoxColor(playerid, RepGUI_Box[playerid], 0x00000099);
    PlayerTextDrawTextSize(playerid, RepGUI_Box[playerid], 549.0, 262.0);
    PlayerTextDrawAlignment(playerid, RepGUI_Box[playerid], 2);

    RepGUI_Title[playerid] = CreatePlayerTextDraw(playerid, 320.0, 154.0, "Выберите шаблон ответа на репорт");
    PlayerTextDrawFont(playerid, RepGUI_Title[playerid], 2);
    PlayerTextDrawLetterSize(playerid, RepGUI_Title[playerid], 0.22, 1.1);
    PlayerTextDrawAlignment(playerid, RepGUI_Title[playerid], 2);
    PlayerTextDrawColor(playerid, RepGUI_Title[playerid], 0xFFFFFFFF);

    for(new i = 0; i < REPGUI_TEMPLATES; i++)
    {
        RepGUI_Tpl[playerid][i] = CreatePlayerTextDraw(playerid, bx[i], 182.0, "_");
        PlayerTextDrawUseBox(playerid, RepGUI_Tpl[playerid][i], 1);
        PlayerTextDrawBoxColor(playerid, RepGUI_Tpl[playerid][i], 0x2B2E38C8);
        PlayerTextDrawTextSize(playerid, RepGUI_Tpl[playerid][i], bx[i] + 87.0, 218.0);
        PlayerTextDrawFont(playerid, RepGUI_Tpl[playerid][i], 2);
        PlayerTextDrawLetterSize(playerid, RepGUI_Tpl[playerid][i], 0.19, 1.0);
        PlayerTextDrawAlignment(playerid, RepGUI_Tpl[playerid][i], 2);
        PlayerTextDrawColor(playerid, RepGUI_Tpl[playerid][i], 0xFFFFFFFF);
        PlayerTextDrawSetSelectable(playerid, RepGUI_Tpl[playerid][i], 1);
    }

    RepGUI_Select[playerid] = CreatePlayerTextDraw(playerid, 90.0, 228.0, "Выбрать");
    PlayerTextDrawUseBox(playerid, RepGUI_Select[playerid], 1);
    PlayerTextDrawBoxColor(playerid, RepGUI_Select[playerid], 0x5B1414C8);
    PlayerTextDrawTextSize(playerid, RepGUI_Select[playerid], 220.0, 258.0);
    PlayerTextDrawFont(playerid, RepGUI_Select[playerid], 2);
    PlayerTextDrawLetterSize(playerid, RepGUI_Select[playerid], 0.22, 1.2);
    PlayerTextDrawAlignment(playerid, RepGUI_Select[playerid], 2);
    PlayerTextDrawColor(playerid, RepGUI_Select[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetSelectable(playerid, RepGUI_Select[playerid], 1);

    RepGUI_Custom[playerid] = CreatePlayerTextDraw(playerid, 230.0, 228.0, "Свой ответ");
    PlayerTextDrawUseBox(playerid, RepGUI_Custom[playerid], 1);
    PlayerTextDrawBoxColor(playerid, RepGUI_Custom[playerid], 0xB33A2CE6);
    PlayerTextDrawTextSize(playerid, RepGUI_Custom[playerid], 410.0, 258.0);
    PlayerTextDrawFont(playerid, RepGUI_Custom[playerid], 2);
    PlayerTextDrawLetterSize(playerid, RepGUI_Custom[playerid], 0.22, 1.2);
    PlayerTextDrawAlignment(playerid, RepGUI_Custom[playerid], 2);
    PlayerTextDrawColor(playerid, RepGUI_Custom[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetSelectable(playerid, RepGUI_Custom[playerid], 1);

    RepGUI_Back[playerid] = CreatePlayerTextDraw(playerid, 420.0, 228.0, "Назад");
    PlayerTextDrawUseBox(playerid, RepGUI_Back[playerid], 1);
    PlayerTextDrawBoxColor(playerid, RepGUI_Back[playerid], 0x4C5163C8);
    PlayerTextDrawTextSize(playerid, RepGUI_Back[playerid], 549.0, 258.0);
    PlayerTextDrawFont(playerid, RepGUI_Back[playerid], 2);
    PlayerTextDrawLetterSize(playerid, RepGUI_Back[playerid], 0.22, 1.2);
    PlayerTextDrawAlignment(playerid, RepGUI_Back[playerid], 2);
    PlayerTextDrawColor(playerid, RepGUI_Back[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetSelectable(playerid, RepGUI_Back[playerid], 1);

    repgui_created[playerid] = true;
    return 1;
}

stock DestroyReportGUI(playerid)
{
    if(!repgui_created[playerid]) return 1;

    PlayerTextDrawDestroy(playerid, RepGUI_Box[playerid]);
    PlayerTextDrawDestroy(playerid, RepGUI_Title[playerid]);
    for(new i = 0; i < REPGUI_TEMPLATES; i++) PlayerTextDrawDestroy(playerid, RepGUI_Tpl[playerid][i]);
    PlayerTextDrawDestroy(playerid, RepGUI_Select[playerid]);
    PlayerTextDrawDestroy(playerid, RepGUI_Custom[playerid]);
    PlayerTextDrawDestroy(playerid, RepGUI_Back[playerid]);

    repgui_created[playerid] = false;
    return 1;
}

/*==================== SHOW / HIDE ====================*/

stock ShowReportAnswerGUI(playerid, report_playerid, report_id, const report_player_name[])
{
    if(!repgui_created[playerid]) CreateReportGUI(playerid);

    new title[128];
    format(title, sizeof(title), "Выберите шаблон ответа на репорт от игрока: %s [%d]", report_player_name, report_playerid);
    PlayerTextDrawSetString(playerid, RepGUI_Title[playerid], title);

    for(new i = 0; i < REPGUI_TEMPLATES; i++)
    {
        PlayerTextDrawSetString(playerid, RepGUI_Tpl[playerid][i], report_gui_templates[i]);
        PlayerTextDrawBoxColor(playerid, RepGUI_Tpl[playerid][i], 0x2B2E38C8);
        PlayerTextDrawShow(playerid, RepGUI_Tpl[playerid][i]);
    }
    repgui_selected[playerid] = -1;

    PlayerTextDrawShow(playerid, RepGUI_Box[playerid]);
    PlayerTextDrawShow(playerid, RepGUI_Title[playerid]);
    PlayerTextDrawShow(playerid, RepGUI_Select[playerid]);
    PlayerTextDrawShow(playerid, RepGUI_Custom[playerid]);
    PlayerTextDrawShow(playerid, RepGUI_Back[playerid]);

    SelectTextDraw(playerid, 0xFFFFFFAA);
    SetPVarInt(playerid, "SelectTextDraw", 3);
    TogglePlayerControllable(playerid, false);
    return 1;
}

stock HideReportAnswerGUI(playerid)
{
    if(repgui_created[playerid])
    {
        PlayerTextDrawHide(playerid, RepGUI_Box[playerid]);
        PlayerTextDrawHide(playerid, RepGUI_Title[playerid]);
        for(new i = 0; i < REPGUI_TEMPLATES; i++) PlayerTextDrawHide(playerid, RepGUI_Tpl[playerid][i]);
        PlayerTextDrawHide(playerid, RepGUI_Select[playerid]);
        PlayerTextDrawHide(playerid, RepGUI_Custom[playerid]);
        PlayerTextDrawHide(playerid, RepGUI_Back[playerid]);
    }

    CancelSelectTextDraw(playerid);
    DeletePVar(playerid, "SelectTextDraw");
    TogglePlayerControllable(playerid, true);
    return 1;
}

/*==================== SUBMIT (переиспользует существующий report_checked) ====================*/

stock SubmitReportAnswer(playerid, response, const inputtext[])
{
    new report_id = TempReportInfo[playerid][reportID];
    if(!report_id)
    {
        SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Этот репорт уже закрыт или недоступен.");
        return 0;
    }

    new query[160];
    mysql_format(connects, query, sizeof(query),
        "SELECT `id` FROM `"TABLE_REPORTS"` WHERE `id` = '%d' AND `status` = 0", report_id);
    mysql_tquery(connects, query, "report_checked", "dds", playerid, response, inputtext);
    return 1;
}

/*==================== ОБРАБОТКА КЛИКОВ (вызывать из OnPlayerClickPlayerTextDraw) ====================*/

stock bool: HandleReportGUIClick(playerid, PlayerText:playertextid)
{
    if(GetPVarInt(playerid, "SelectTextDraw") != 3) return false;

    if(_:playertextid == INVALID_TEXT_DRAW) return true; // клик мимо GUI

    for(new i = 0; i < REPGUI_TEMPLATES; i++)
    {
        if(playertextid == RepGUI_Tpl[playerid][i])
        {
            if(repgui_selected[playerid] != -1)
                PlayerTextDrawBoxColor(playerid, RepGUI_Tpl[playerid][repgui_selected[playerid]], 0x2B2E38C8);

            repgui_selected[playerid] = i;
            PlayerTextDrawBoxColor(playerid, RepGUI_Tpl[playerid][i], 0xB33A2CE6);
            return true;
        }
    }

    if(playertextid == RepGUI_Select[playerid])
    {
        if(repgui_selected[playerid] == -1)
        {
            SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Сначала выберите шаблон ответа!");
            return true;
        }
        new tpl[64];
        strmid(tpl, report_gui_templates[repgui_selected[playerid]], 0, strlen(report_gui_templates[repgui_selected[playerid]]), 64);
        HideReportAnswerGUI(playerid);
        SubmitReportAnswer(playerid, 1, tpl);
        return true;
    }

    if(playertextid == RepGUI_Custom[playerid])
    {
        HideReportAnswerGUI(playerid);
        ShowPlayerDialog(playerid, DIALOG_REPGUI_CUSTOM, DIALOG_STYLE_INPUT,
            !""SERVER"Свой ответ на репорт", !"{FFFFFF}Введите текст ответа игроку:", !"Отправить", !"Отмена");
        return true;
    }

    if(playertextid == RepGUI_Back[playerid])
    {
        HideReportAnswerGUI(playerid);
        SubmitReportAnswer(playerid, 0, "");
        return true;
    }

    return true;
}

/*==================== ОБРАБОТКА ДИАЛОГА "Свой ответ" (вызывать из OnDialogResponse) ====================*/

stock HandleReportGUIDialog(playerid, response, const inputtext[])
{
    if(!response)
    {
        SubmitReportAnswer(playerid, 0, "");
        return 1;
    }

    if(!strlen(inputtext))
    {
        SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Ответ не может быть пустым!");
        ShowPlayerDialog(playerid, DIALOG_REPGUI_CUSTOM, DIALOG_STYLE_INPUT,
            !""SERVER"Свой ответ на репорт", !"{FFFFFF}Введите текст ответа игроку:", !"Отправить", !"Отмена");
        return 1;
    }

    SubmitReportAnswer(playerid, 1, inputtext);
    return 1;
}
