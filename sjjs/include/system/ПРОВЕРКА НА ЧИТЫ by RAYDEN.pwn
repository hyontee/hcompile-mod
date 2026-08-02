CMD:anydesk(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

    new targetid, anydesk_id[20];

    if(sscanf(params, "ds[20]", targetid, anydesk_id))
        return SendClientMessage(playerid, -1, "{FFCC00}[Подсказка]{FFFFFF} Используйте: /anydesk [ID игрока] [Ваш AnyDesk ID]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "{FF0000}[Ошибка]{FFFFFF} Игрок не найден на сервере!");
        
    new string[144], admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    GetPlayerName(targetid, target_name, sizeof(target_name));

    SendClientMessage(targetid, 0xFFFFFFFF, "==================================================");
    format(string, sizeof(string), "{FF0000}[ПРОВЕРКА НА ЧИТЫ]{FFFFFF} Администратор %s вызвал вас на проверку читов!", admin_name);
    SendClientMessage(targetid, -1, string);
    format(string, sizeof(string), "{FF0000}[ПРОВЕРКА НА ЧИТЫ]{FFFFFF} Скачайте AnyDesk и подключитесь к ID: {00FF00}%s", anydesk_id);
    SendClientMessage(targetid, -1, string);
    SendClientMessage(targetid, -1, "{FF0000}[ПРОВЕРКА НА ЧИТЫ]{FFFFFF} У вас есть 5 минут. Выход из игры = {FF0000}БАН!");
    SendClientMessage(targetid, 0xFFFFFFFF, "==================================================");

    GameTextForPlayer(targetid, "~r~ANYDESK CHEAT CHECK~n~~w~EXIT = BAN!", 10000, 4);

    TogglePlayerControllable(targetid, 0);

    format(string, sizeof(string), "{00FF00}[Успешно]{FFFFFF} Вы вызвали игрока %s [%d] на проверку. Ваш AnyDesk: %s", target_name, targetid, anydesk_id);
    SendClientMessage(playerid, -1, string);

    format(string, sizeof(string), "[A] %s [%d] вызвал на проверку игрока %s [%d]. AnyDesk: %s", admin_name, playerid, target_name, targetid, anydesk_id);
    SendMessageToAdmins(string, 0xFFCC00AA);

    return 1;
}

CMD:unanydesk(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;
    new targetid;

    if(sscanf(params, "d", targetid))
        return SendClientMessage(playerid, -1, "{FFCC00}[Подсказка]{FFFFFF} Используйте: /unanydesk [ID игрока]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "{FF0000}[Ошибка]{FFFFFF} Игрок не найден на сервере!");

    new string[256], admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    GetPlayerName(targetid, target_name, sizeof(target_name));

    TogglePlayerControllable(targetid, 1);

    GivePlayerMoneyEx(targetid, 500000);

    new dialog_text[256];
    format(dialog_text, sizeof(dialog_text),
        "{FFFFFF}Поздравляем!\n\n\
        Вы успешно прошли проверку на читы от администратора {00FF00}%s{FFFFFF}.\n\
        Вам зачислен небольшой бонус в размере {00FF00}500.000р{FFFFFF} за потраченное время.\n\n\
        Приятной игры на нашем сервере!",
        admin_name
    );
    ShowPlayerDialog(targetid, 9999, DIALOG_STYLE_MSGBOX, "{00FF00}Проверка пройдена", dialog_text, "Закрыть", "");

    format(string, sizeof(string), "{00FF00}[Успешно]{FFFFFF} Игрок %s [%d] успешно прошел проверку. Заморозка снята, бонус выдан.", target_name, targetid);
    SendClientMessage(playerid, -1, string);

    format(string, sizeof(string), "[A] %s [%d] успешно проверил игрока %s [%d]. Читы не обнаружены.", admin_name, playerid, target_name, targetid);
    SendMessageToAdmins(string, 0xFFCC00AA);

    return 1;
}