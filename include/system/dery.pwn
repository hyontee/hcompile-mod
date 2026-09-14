#include <a_samp>

forward CmdDery(playerid, params[]);

public OnFilterScriptInit()
{
    AddCommand("dery", CmdDery);
    return 1;
}

public CmdDery(playerid, params[])
{
    new string[256];
    format(string, sizeof(string), "{FF0000}cmd:dery говорит: Привет! Как дела? Ты бы хотел со мной поиграть?{FFFFFF}");
    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_YESNO, "{FF0000}Диалог с cmd:dery{FFFFFF}", string, "Да", "Нет");
    return 1;
}

forward OnPlayerDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public OnPlayerDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == 1)
    {
        if (response)
        {
            SendClientMessage(playerid, -1, "cmd:dery: Отлично, давай поиграем!");
            SetTimerEx("DeryGameDelay", 5000, false, "i", playerid); // Заменяем Sleep на таймер
        }
        else
        {
            SendClientMessage(playerid, -1, "cmd:dery: Жаль, что ты не хочешь играть. Может, в другой раз!");
        }
    }
    return 1;
}

forward DeryGameDelay(playerid);
public DeryGameDelay(playerid)
{
    new string[512], datetime[64];
    GetDateTime(datetime, sizeof(datetime));

    format(string, sizeof(string),
        "МОЛОДЕЦ! ТЫ ВЫИГРАЛ У МЕНЯ!\n\nПРИЗЫ:\n- Мерседес банан 63 АМГ (id: 410)\n- Скин «Медведь» (id: 299)\n\nПоздравляем! Заберите свои призы в игровом магазине.\n\nВы ввели промо в %s",
        datetime
    );

    ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "{FF0000}Победа!{FFFFFF}", string, "ОК", "");
    return 1;
}