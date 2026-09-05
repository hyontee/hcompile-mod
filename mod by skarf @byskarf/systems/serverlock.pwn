new lockserver;
new passwordserver[16];
new ServerPassAutorize[MAX_PLAYERS];
new isPasswordInputInProgress[MAX_PLAYERS];
new passserver = 0;

public OnPlayerDisconnect(playerid, reason)
{
    ServerPassAutorize[playerid] = 0;

#if defined lock_OnPlayerDisconnect
        return lock_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect lock_OnPlayerDisconnect
#if defined lock_OnPlayerDisconnect
    forward lock_OnPlayerDisconnect(playerid, reason);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

if(dialogid == 5401) 
	{
	        if(response)
	        {
	                if(listitem == 0)
	                {
	                    ShowPlayerDialog(playerid, 5402, DIALOG_STYLE_LIST, "Выберите", "Поставить пароль\nЗакрыть сервер", "Выбрать", "Закрыть");
	                }
	                if(listitem == 1)
	                {
	                    new string[156];
                        lockserver = 0;
                        format(string, sizeof string, "Администратор %s открыл доступ к серверу", GetPlayerNameEx(playerid));
                        SendMessageToAdmins(string, 0xffffff);

	                }
	        }
	}
	if(dialogid == 5402) 
	{
	        if(response)
	        {
	                if(listitem == 0)
	                {
	                        ShowPlayerDialog(playerid,5403,DIALOG_STYLE_INPUT,"Пароль сервера","Введите пароль сервера","Принять","Отмена");
	                }
	                if(listitem == 1)
	                {
	                        lockserver = 1;
	                        if(GetPlayerAdminEx(playerid) < 5)
	                        {
	                            SendClientMessage(playerid, -1, "Вы администратор, поэтому не были кикнуты с сервера.");
	                        }
							else
							{
								for(new i = 0; i <= MAX_PLAYERS; i++)
								Kick(i);
							}
						new string[156];
       					format(string, sizeof string, "Администратор %s закрыл доступ к серверу", GetPlayerNameEx(playerid));
                        SendMessageToAdmins(string, 0xffffff);

	                }
	        }
	}
	if(dialogid == 5403) 
	{
	        if(response)
	        {
	                if(!strlen(inputtext)) // этта проверка проверяет, если игрок ничего не ввел в окно, тогда действие
	                {
	                        SendClientMessage(playerid, -1, "Вы ничего не ввели!");
	                        ShowPlayerDialog(playerid,5403,DIALOG_STYLE_INPUT,"Пароль сервера","Введите пароль сервера","Принять","Отмена");
	                        return 1;
	                }
	                new string[16];
	                // а если игрок что то ввел тогда:
	                SendClientMessage(playerid, -1, "Вы изменили пароль от сервера");// это будет выводить в чат, то, что вы ввели в окно диалога
	                format(string, sizeof string, "%s", inputtext);
	                passwordserver = string;
	                ShowPlayerDialog(playerid, 5609 , DIALOG_STYLE_MSGBOX, "Хотите закрыть сервер?", "Вы изменили пароль от сервера.\nХотите ли вы закрыть доступ к серверу?", "Да", "Нет");

	        }
	        else
	        {
	                // тут если он нажал на кнопку 2
	                SendClientMessage(playerid, -1, "Вы отменили действие!");
	        }
	}
    if(dialogid == 5671) 
    {
        if(isPasswordInputInProgress[playerid])
        {
            isPasswordInputInProgress[playerid] = false; // Сброс флага после ввода пароля

            if(response)
            {
                if(!strlen(inputtext))
                {
                    SendClientMessage(playerid, -1, "Пароль не введен!");
                    Kick(playerid);
                    return 1;
                }

                // Проверка пароля
                if(strlen(passwordserver) == strlen(inputtext) && !strcmp(passwordserver, inputtext))
                 {
					OnPlayerConnect(playerid);
					ServerPassAutorize[playerid] = 1;
                    // Ваш код здесь
                }
                else
                {
                    SendClientMessage(playerid, -1, "Пароль неверный!");
                    Kick(playerid);
                }
            }
            else
            {
                // Игрок отменил ввод пароля
                Kick(playerid);
            }
        }
    }
	if(dialogid == 5609) 
	{
        if(response)
        {
				new string[156];
                // действие если игрок нажал на кнопку 1
                SendClientMessage(playerid, -1, "Вы закрыли сервер!");
                lockserver = 1;
               	if(GetPlayerAdminEx(playerid) == 0)
				{
					for(new i = 0; i <= MAX_PLAYERS; i++)
					Kick(i);
				}
				format(string, sizeof string, "Администратор %s закрыл доступ к серверу", GetPlayerNameEx(playerid));
    			SendMessageToAdmins(string, 0xffffff);

        }
        else
        {
        }
	}
	#if defined lock_OnDialogResponse
return lock_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse lock_OnDialogResponse
#if defined lock_OnDialogResponse
forward lock_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif


CMD:serverlock(playerid)
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;
    ShowPlayerDialog(playerid, 5401, DIALOG_STYLE_LIST, "Выбор", "Закрыть сервер\nОткрыть сервер", "Принять", "Отклонить");
    return 1;
}