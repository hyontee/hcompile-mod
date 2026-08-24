// ==============================================
//          КВЕСТ ОТ ДЯДИ НЕСКВИКА
// ==============================================

// ============ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ============
new Kvest_NPC_Dyadya;
new Text3D:Kvest_Text_Dyadya;
new Kvest_NPC_Sanek;
new Text3D:Kvest_Text_Sanek;

new Kvest_PlayerQuest[MAX_PLAYERS];     // 0 - нет квеста, 1 - квест активен
new Kvest_PlayerMapIcon[MAX_PLAYERS];
new Kvest_PlayerHasItem[MAX_PLAYERS];   // есть ли товар

// ============ КООРДИНАТЫ ============
// Дядя Несквик: 1860.340820, 2388.653076, 15.732356
// Санек: 2644.822753, -225.315307, 3.790853

// ============ ИНИЦИАЛИЗАЦИЯ ============
stock Kvest_OnGameModeInit()
{
    // NPC Дядя Несквик
    Kvest_NPC_Dyadya = CreateActor(122, 1860.340820, 2388.653076, 15.732356, 124.727226);
    Kvest_Text_Dyadya = Create3DTextLabel(
        "{FF0000}Дядя Несквик\n{FFFFFF}/kvest1",
        0xFF0000FF,
        1860.340820, 2388.653076, 15.732356 + 1.0,
        10.0, 0, 1
    );
    
    // NPC Санек
    Kvest_NPC_Sanek = CreateActor(7, 2644.822753, -225.315307, 3.790853, 356.370971);
    Kvest_Text_Sanek = Create3DTextLabel(
        "{FF0000}Санек\n{FFFFFF}/kvest2",
        0xFF0000FF,
        2644.822753, -225.315307, 3.790853 + 1.0,
        10.0, 0, 1
    );
    
    return 1;
}

// ============ ЗАВЕРШЕНИЕ ============
stock Kvest_OnGameModeExit()
{
    DestroyActor(Kvest_NPC_Dyadya);
    Delete3DTextLabel(Kvest_Text_Dyadya);
    DestroyActor(Kvest_NPC_Sanek);
    Delete3DTextLabel(Kvest_Text_Sanek);
    return 1;
}

// ============ КОМАНДА /kvest1 ============
CMD:kvest1(playerid, params[])
{
    // Проверка рядом с Дядей Несквиком
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1860.340820, 2388.653076, 15.732356))
    {
        // Показываем диалог
        ShowPlayerDialog(playerid, 5000, DIALOG_STYLE_MSGBOX, "Дядя Несквик", 
            "Приветствую! Хочешь получить деньги за простое задание?", 
            "Да", "Нет");
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы не находитесь рядом с Дядей Несквиком!");
    }
    return 1;
}

// ============ КОМАНДА /kvest2 ============
CMD:kvest2(playerid, params[])
{
    // Проверка рядом с Саньком
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 2644.822753, -225.315307, 3.790853))
    {
        // Проверяем, есть ли у игрока активный квест
        if(Kvest_PlayerQuest[playerid] == 1 && Kvest_PlayerHasItem[playerid] == 1)
        {
            // Завершаем квест
            Kvest_PlayerQuest[playerid] = 2;
            Kvest_PlayerHasItem[playerid] = 0;
            
            // Убираем метку и чекпоинт
            DisablePlayerCheckpoint(playerid);
            RemovePlayerMapIcon(playerid, Kvest_PlayerMapIcon[playerid]);
            
            // Выдаём награду
            GivePlayerMoney(playerid, 1000000);  // 1.000.000$
            // GivePlayerBC(playerid, 1500);     // 1500 BC (если есть функция)
            
            // Сообщения
            SendClientMessage(playerid, 0x00FF00FF, "Санек: Здорово! Я вижу ты взялся за это дело!");
            SendClientMessage(playerid, 0x00FF00FF, "Санек: Спасибо что привёз! Вот твоя награда:");
            SendClientMessage(playerid, 0xFFD700FF, "Вы получили 1.000.000$ и 1.500 BC!");
            SendClientMessage(playerid, 0x00FF00FF, "Удачной игры!");
            
            GameTextForPlayer(playerid, "~g~QUEST COMPLETE!~n~~y~+1.000.000$~n~~b~+1500 BC", 5000, 3);
            PlayerPlaySound(playerid, 1052, 2644.822753, -225.315307, 3.790853);
        }
        else
        {
            SendClientMessage(playerid, 0xFF0000FF, "Санек: У тебя нет задания для меня!");
        }
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы не находитесь рядом с Саньком!");
    }
    return 1;
}

// ============ КОМАНДА /pognali ============
CMD:pognali(playerid, params[])
{
    // Проверяем, есть ли активный диалог (игрок согласился)
    if(Kvest_PlayerQuest[playerid] == 0)
    {
        Kvest_PlayerQuest[playerid] = 1;
        Kvest_PlayerHasItem[playerid] = 1;
        
        // Создаём метку на карте (координаты Санька)
        Kvest_PlayerMapIcon[playerid] = SetPlayerMapIcon(playerid, 1, 2644.822753, -225.315307, 3.790853, 56, 0, MAPICON_GLOBAL);
        SetPlayerCheckpoint(playerid, 2644.822753, -225.315307, 3.790853, 3.0);
        
        // Сообщения
        SendClientMessage(playerid, 0x00FF00FF, "Дядя Несквик: Тогда езжай на метку!");
        SendClientMessage(playerid, 0x00FF00FF, "Дядя Несквик: Там тебя будет ждать мой друг!");
        SendClientMessage(playerid, 0xFFFF00FF, "Вам выдали секретный груз! Не открывайте его!");
        SendClientMessage(playerid, 0x00FF00FF, "Вы получили 5 кг порошка!");
        SendClientMessage(playerid, 0xFFFF00FF, "Отвезите груз к Саньку на карте!");
        
        GameTextForPlayer(playerid, "~y~+5 KG~n~~r~СЕКРЕТНЫЙ ГРУЗ", 3000, 3);
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "У вас уже есть активное задание!");
    }
    return 1;
}

// ============ ОБРАБОТКА ДИАЛОГА ============
stock Kvest_OnDialogResponse(playerid, dialogid, response)
{
    if(dialogid == 5000)
    {
        if(response)
        {
            // Игрок нажал "Да"
            SendClientMessage(playerid, 0x00FF00FF, "Дядя Несквик: Отлично! Введи /pognali чтобы начать!");
        }
        else
        {
            // Игрок нажал "Нет"
            SendClientMessage(playerid, 0xFFA500FF, "Дядя Несквик: Ну как хочешь... Если передумаешь - подходи!");
        }
        return 1;
    }
    return 0;
}

// ============ ВХОД В ЧЕКПОИНТ ============
stock Kvest_OnPlayerEnterCheckpoint(playerid)
{
    if(Kvest_PlayerQuest[playerid] == 1 && Kvest_PlayerHasItem[playerid] == 1)
    {
        SendClientMessage(playerid, 0x00FF00FF, "Вы доставили груз! Подойдите к Саньку и введите /kvest2");
    }
    return 1;
}

// ============ ВЫХОД ИГРОКА ============
stock Kvest_OnPlayerDisconnect(playerid)
{
    if(Kvest_PlayerQuest[playerid] == 1)
    {
        DisablePlayerCheckpoint(playerid);
        RemovePlayerMapIcon(playerid, Kvest_PlayerMapIcon[playerid]);
    }
    Kvest_PlayerQuest[playerid] = 0;
    Kvest_PlayerHasItem[playerid] = 0;
    return 1;
}