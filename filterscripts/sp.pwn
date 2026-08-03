#include <a_samp>

#define DIALOG_TEST_MENU     9293
#define DIALOG_TEST_INPUT    9298

new TestTarget[MAX_PLAYERS];
new TestAction[MAX_PLAYERS];

forward OpenTestsMenu(playerid, targetid);

public OnFilterScriptInit()
{
    print("sp loaded");
    return 1;
}

public OpenTestsMenu(playerid, targetid)
{
    if(!IsPlayerConnected(targetid)) return 0;

    TestTarget[playerid] = targetid;

    ShowPlayerDialog(playerid, DIALOG_TEST_MENU, DIALOG_STYLE_LIST,
        "Админ действия",
        "Варн\nБан\nМут\nКик",
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TEST_MENU)
    {
        if(!response) return 1;

        TestAction[playerid] = listitem;

        switch(listitem)
        {
            case 0:
            {
                ShowPlayerDialog(playerid, DIALOG_TEST_INPUT, DIALOG_STYLE_INPUT,
                    "Варн",
                    "Введите причину",
                    "Выдать",
                    "Отмена"
                );
            }
            case 1:
            {
                ShowPlayerDialog(playerid, DIALOG_TEST_INPUT, DIALOG_STYLE_INPUT,
                    "Бан",
                    "Введите всё одной строкой\nПример: 3 дня | Читы",
                    "Бан",
                    "Отмена"
                );
            }
            case 2:
            {
                ShowPlayerDialog(playerid, DIALOG_TEST_INPUT, DIALOG_STYLE_INPUT,
                    "Мут",
                    "Введите всё одной строкой\nПример: 2 часа | Флуд",
                    "Мут",
                    "Отмена"
                );
            }
            case 3:
            {
                ShowPlayerDialog(playerid, DIALOG_TEST_INPUT, DIALOG_STYLE_INPUT,
                    "Кик",
                    "Введите причину",
                    "Кик",
                    "Отмена"
                );
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_TEST_INPUT)
    {
        if(!response) return 1;

        new target = TestTarget[playerid];
        if(!IsPlayerConnected(target)) return 1;

        new nameAdmin[MAX_PLAYER_NAME];
        new nameTarget[MAX_PLAYER_NAME];
        new msg[256];

        GetPlayerName(playerid, nameAdmin, sizeof(nameAdmin));
        GetPlayerName(target, nameTarget, sizeof(nameTarget));

        switch(TestAction[playerid])
        {
            case 0: // WARN
            {
                format(msg, sizeof(msg), "Администратор %s выдал вам WARN. Причина: %s", nameAdmin, inputtext);
                SendClientMessage(target, -1, msg);

                format(msg, sizeof(msg), "Вы выдали WARN игроку %s. Причина: %s", nameTarget, inputtext);
                SendClientMessage(playerid, -1, msg);
            }
            case 1: // BAN
            {
                format(msg, sizeof(msg), "Администратор %s забанил вас. Данные: %s", nameAdmin, inputtext);
                SendClientMessage(target, -1, msg);

                format(msg, sizeof(msg), "Вы забанили игрока %s. Данные: %s", nameTarget, inputtext);
                SendClientMessage(playerid, -1, msg);

                Ban(target);
            }
            case 2: // MUTE
            {
                format(msg, sizeof(msg), "Администратор %s выдал вам мут. Данные: %s", nameAdmin, inputtext);
                SendClientMessage(target, -1, msg);

                format(msg, sizeof(msg), "Вы выдали мут игроку %s. Данные: %s", nameTarget, inputtext);
                SendClientMessage(playerid, -1, msg);
            }
            case 3: // KICK
            {
                format(msg, sizeof(msg), "Администратор %s кикнул вас. Причина: %s", nameAdmin, inputtext);
                SendClientMessage(target, -1, msg);

                format(msg, sizeof(msg), "Вы кикнули игрока %s. Причина: %s", nameTarget, inputtext);
                SendClientMessage(playerid, -1, msg);

                Kick(target);
            }
        }
        return 1;
    }
    return 0;
}