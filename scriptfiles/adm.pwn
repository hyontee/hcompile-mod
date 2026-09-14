#include <a_samp>

// Настройки системы
#define ADM_SKIN_ID 122 // ID скина администратора
#define ADM_MONEY 50000 // Сумма денег для выдачи

public OnFilterScriptInit()
{
    print("\n----------------------------------");
    print(" Система выдачи скина админа загружена");
    print(" Команда: /freeadm");
    print("----------------------------------\n");
    return 1;
}

public OnFilterScriptExit()
{
    print("Система выдачи скина админа выгружена");
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(strcmp(cmdtext, "/freeadm", true) == 0)
    {
        // Проверяем, не использовал ли игрок команду раньше
        static bool:usedCommand[MAX_PLAYERS char];
        
        if(usedCommand{playerid})
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Вы уже использовали эту команду!");
            return 1;
        }
        
        // Устанавливаем скин администратора
        SetPlayerSkin(playerid, ADM_SKIN_ID);
        
        // Выдаем деньги
        GivePlayerMoney(playerid, ADM_MONEY);
        
        // Отмечаем, что игрок использовал команду
        usedCommand{playerid} = true;
        
        // Отправляем сообщение игроку
        new string[128];
        format(string, sizeof(string), "Вы получили скин администратора (ID %d) и $%d!", ADM_SKIN_ID, ADM_MONEY);
        SendClientMessage(playerid, 0x00FF00FF, string);
        SendClientMessage(playerid, 0xFFFF00FF, "Команда использована один раз!");
        
        return 1;
    }
    return 0;
}