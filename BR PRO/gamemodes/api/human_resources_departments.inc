
new pickupotd1;
new pickupotd2;
new pickupotd3;
new pickupotd4;
new pickupotd5;
new pickupotd6;

#define DIALOG_OTD   28481
#define DIALOG_OTD1  28482
#define DIALOG_OTD2  28483
#define DIALOG_OTD3  28484
#define DIALOG_OTD4  28485
#define DIALOG_OTD5  28486
#define DIALOG_OTD6  28487
#define DIALOG_EX    28488
#define DIALOG_EB    28489
#define DIALOG_EM    28490
#define DIALOG_OPR   28491
#define DIALOG_EK    28492
#define DIALOG_EK1   28493
#define DIALOG_EK2   28494
#define DIALOG_EK3   28495
#define DIALOG_EK4   28496
#define DIALOG_EK5   28497
#define DIALOG_EK6   28498
#define DIALOG_EX1   28499
#define DIALOG_EB1   28500
#define DIALOG_EM1   28501
#define DIALOG_OPR1  28502
#define DIALOG_EX2   28503
#define DIALOG_EB2   28504
#define DIALOG_EM2   28505
#define DIALOG_OPR2  28506
#define DIALOG_EX3   28507
#define DIALOG_EB3   28508
#define DIALOG_EM3   28509
#define DIALOG_AP3   28510
#define DIALOG_OPR3  28511
#define DIALOG_EX4   28512
#define DIALOG_EB4   28513
#define DIALOG_NG    28514
#define DIALOG_EM4   28515
#define DIALOG_AP4   28516
#define DIALOG_OPR4  28517
#define DIALOG_EX5   28518
#define DIALOG_EB5   28519
#define DIALOG_EM5   28520
#define DIALOG_AP5   28521
#define DIALOG_OPR5  28522    
#define DIALOG_EX6   28523
#define DIALOG_EB6   28524
#define DIALOG_EM6   28525
#define DIALOG_AP6   28526
#define DIALOG_OPR6  28527
	// ---------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_OTD)
    {
        if(response)
        {
            if(GetPlayerLevel(playerid) < 3)
                return SendClientMessage(playerid, 0xCECECEFF, "Чтобы пройти тестирование необходим 3 уровень");
            if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 0)
                SendClientMessage(playerid, 0x999999FF, ""USC"У вас нету лицензий");
                    
            ShowPlayerDialog(playerid, DIALOG_OPR, DIALOG_STYLE_LIST, "Что такое RP?", "Убийство по РП\nИгра по ролям\nВоображение из себя героя", "Выбрать", "Отмена");
        }
        else return 1;
    }
            
    if (dialogid == DIALOG_OPR)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EX, DIALOG_STYLE_LIST, "Что такое DM?", "Убийство без причины\nЗеленая зона\nОтыгровка РП", "Выбрать", "Отмена");
                }
                case 2:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EX)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EB, DIALOG_STYLE_LIST, "Как расшифровывается УК?", "Указ\nУголовный Кодекс", "Выбрать", "Отмена");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 2:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EB)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EM, DIALOG_STYLE_LIST, "Что такое зеленая зона?", "зона,в которой разрешен DM\nЗона,в которой запрещено атаковать и можно восстановить хп", "Выбрать", "Отмена");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EM)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    InvitePlayer(playerid, 5, 1, true);
                    ShowPlayerDialog(playerid, DIALOG_EK, DIALOG_STYLE_MSGBOX, "Поздравляю!", "Вы прошли тест! Приступайте к работе.", "Хорошо", "");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_OTD1)
    { 
        if(response)
        {
            if(GetPlayerLevel(playerid) < 3)
                return ShowNotification(playerid, 2, "Чтобы пройти тестирование необходим 3 уровень", 4, " ", "");
            if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 0)
                ShowNotification(playerid, 2, "У вас нету лицензий", 4, " ", "");
                    
            ShowPlayerDialog(playerid, DIALOG_OPR1, DIALOG_STYLE_LIST, "{FF6347}Что такое RolePlay?", "{ffff00}1. {ffffff}Убийство по РП\n{ffff00}2. {ffffff}Игра по ролям\n{ffff00}3. {ffffff}Воображение из себя героя", "Выбрать", "Закрыть");
        }
        else return 1;
    }
            
    if (dialogid == DIALOG_OPR1)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EX1, DIALOG_STYLE_LIST, "{FF6347}Разрешено ли оскорблять своих коллег?", "{ffff00}1. {ffffff}Да, разрешено оскорблять\n{ffff00}2. {ffffff}Можно только когда не видел лидер\n{ffff00}3. {ffffff}Запрещено, сотрудник не должен кого либо оскорблять", "Выбрать", "Закрыть");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EX1)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 2:
                {
                    ShowPlayerDialog(playerid, DIALOG_EB1, DIALOG_STYLE_LIST, "{FF6347}Кто самый главный во фракции?", "{ffff00}1. {ffffff}Адвокат и Депутат\n{ffff00}2. {ffffff}Вице-губернатор и Губернатор\n{ffff00}3. {ffffff}Советник и Лицензер", "Выбрать", "Закрыть");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EB1)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EM1, DIALOG_STYLE_LIST, "{FF6347}Что такое \"Зелёная Зона\"?", "{ffff00}1. {ffffff}Зона, в которой разрешен DeathMach\n{ffff00}2. {ffffff}Зона, в которой запрещено атаковать и можно восстановить здоровье\n{ffff00}3. {ffffff}Зона мероприятий", "Выбрать", "Закрыть");
                }
                case 2:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EM1)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    InvitePlayer(playerid, 1, 1, true);
                    ShowPlayerDialog(playerid, DIALOG_EK1, DIALOG_STYLE_MSGBOX, "{FF6347}"SERVER_NAME" {ffffff}| Информация", "Вы успешно прошли собеседование и были приняты в нашу\nорганизацию.\n\nВаша новая должность - {ffff00}1 ранг, {ffffff}и сейчас Ваша основная задача\nобучаться базовым принципам нашей организации. Воспользуйтесь\nкомандой {ffff00}/mm > Команды сервера, {ffffff}чтобы познакомиться с функционалом.", "Закрыть", "");
                }
                case 2:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_OTD2)
    { 
        if(response)
        {
            if(GetPlayerLevel(playerid) < 3)
                return ShowNotification(playerid, 2, "Чтобы пройти тестирование необходим 3 уровень", 4, " ", "");
            if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 0)
                ShowNotification(playerid, 2, "У вас нету лицензий", 4, " ", "");
                    
            ShowPlayerDialog(playerid, DIALOG_OPR2, DIALOG_STYLE_LIST, "{FF6347}Что такое RolePlay?", "{ffff00}1. {ffffff}Убийство по РП\n{ffff00}2. {ffffff}Игра по ролям\n{ffff00}3. {ffffff}Воображение из себя героя", "Выбрать", "Закрыть");
        }
        else return 1;
    }
            
    if (dialogid == DIALOG_OPR2)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EX2, DIALOG_STYLE_LIST, "{FF6347}Разрешено ли прогуливать рабочий день?", "{ffff00}1. {ffffff}Нет\n{ffff00}2. {ffffff}Да", "Выбрать", "Закрыть");
                }
                case 2:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EX2)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EB2, DIALOG_STYLE_LIST, "{FF6347}Разрешено нарушать устав?", "{ffff00}1. {ffffff}Да, пока не видет лидер\n{ffff00}2. {ffffff}Запрещено, каждый сотрудник обязан соблюдать устав", "Выбрать", "Закрыть");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EB2)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EM2, DIALOG_STYLE_LIST, "{FF6347}Что такое \"Зелёная Зона\"?", "{ffff00}1. {ffffff}Зона, в которой разрешен DeathMach\n{ffff00}2. {ffffff}Зона,в которой запрещено атаковать и можно восстановить здоровье", "Выбрать", "Закрыть");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EM2)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    InvitePlayer(playerid, 2, 1, true);
                    ShowPlayerDialog(playerid, DIALOG_EK2, DIALOG_STYLE_MSGBOX, "{FF6347}"SERVER_NAME" {ffffff}| Информация", "Вы успешно прошли собеседование и были приняты в нашу\nорганизацию.\n\nВаша новая должность - {ffff00}1 ранг, {ffffff}и сейчас Ваша основная задача\nобучаться базовым принципам нашей организации. Воспользуйтесь\nкомандой {ffff00}/mm > Команды сервера, {ffffff}чтобы познакомиться с функционалом.", "Закрыть", "");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_OTD3)
    { 
        if(response)
        {
            if(GetPlayerLevel(playerid) < 3)
                return ShowNotification(playerid, 2, "Чтобы пройти тестирование необходим 3 уровень", 4, " ", "");
            if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 0)
                ShowNotification(playerid, 2, "У вас нету лицензий", 4, " ", "");
                    
            ShowPlayerDialog(playerid, DIALOG_OPR3, DIALOG_STYLE_LIST, "{FF6347}Что такое RolePlay?", "{ffff00}1. {ffffff}Игра по ролям\n{ffff00}2. {ffffff}Убийство по РП\n{ffff00}3. {ffffff}Воображение из себя героя", "Выбрать", "Закрыть");
        }
        else return 1;
    }
            
    if (dialogid == DIALOG_OPR3)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EX3, DIALOG_STYLE_LIST, "{FF6347}За что может быть уволен сотрудник?", "{ffff00}1. {ffffff}За грубое нарушение устава\n{ffff00}2. {ffffff}За то что во время пришел на строй", "Выбрать", "Закрыть");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EX3)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EB3, DIALOG_STYLE_LIST, "{FF6347}Что такое ПРД?", "{ffff00}1. {ffffff}Нарушение устава\n{ffff00}2. {ffffff}Прогул рабочего дня", "Выбрать", "Закрыть");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EB3)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EM3, DIALOG_STYLE_LIST, "{FF6347}Что такое \"Зелёная Зона\"?", "{ffff00}1. {ffffff}Зона, в которой разрешен DeathMach\n{ffff00}2. {ffffff}Зона, в которой запрещено атаковать и можно восстановить здоровье", "Выбрать", "Закрыть");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EM3)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    InvitePlayer(playerid, 7, 1, true);
                    ShowPlayerDialog(playerid, DIALOG_EK3, DIALOG_STYLE_MSGBOX, "{FF6347}"SERVER_NAME" {ffffff}| Информация", "Вы успешно прошли собеседование и были приняты в нашу\nорганизацию.\n\nВаша новая должность - {ffff00}1 ранг, {ffffff}и сейчас Ваша основная задача\nобучаться базовым принципам нашей организации. Воспользуйтесь\nкомандой {ffff00}/mm > Команды сервера, {ffffff}чтобы познакомиться с функционалом.", "Закрыть", "");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_OTD4)
    { 
        if(response)
        {
            if(GetPlayerLevel(playerid) < 3)
                return ShowNotification(playerid, 2, "Чтобы пройти тестирование необходим 3 уровень", 4, " ", "");
            if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 0)
                ShowNotification(playerid, 2, "У вас нету лицензий", 4, " ", "");
                    
            ShowPlayerDialog(playerid, DIALOG_OPR3, DIALOG_STYLE_LIST, "{FF6347}Что такое RolePlay?", "{ffff00}1. {ffffff}Игра по ролям\n{ffff00}2. {ffffff}Убийство по РП\n{ffff00}2. {ffffff}Воображение из себя героя", "Выбрать", "Закрыть");
        }
        else return 1;
    }
            
    if (dialogid == DIALOG_OPR4)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EX4, DIALOG_STYLE_LIST, "{FF6347}Разрешено ли в свободное время ездить в казино?", "{ffff00}1. {ffffff}Да\n{ffff00}2. {ffffff}Нет", "Выбрать", "Закрыть");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EX4)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EB4, DIALOG_STYLE_LIST, "{FF6347}Что такое Power Gaming?", "{ffff00}1. {ffffff}Деморган\n{ffff00}2. {ffffff}Воображение из себя супергероя", "Выбрать", "Закрыть");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EB4)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EM4, DIALOG_STYLE_LIST, "{FF6347}Разрешено ли оскорблять младших по званию?", "{ffff00}1. {ffffff}Да, сотрудник имеет права\n{ffff00}2. {ffffff}Нет, ко всем нужно относится с уважением ", "Выбрать", "Закрыть");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EM4)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    InvitePlayer(playerid, 3, 1, true);
                    ShowPlayerDialog(playerid, DIALOG_EK4, DIALOG_STYLE_MSGBOX, "{FF6347}"SERVER_NAME" {ffffff}| Информация", "Вы успешно прошли собеседование и были приняты в нашу\nорганизацию.\n\nВаша новая должность - {ffff00}1 ранг, {ffffff}и сейчас Ваша основная задача\nобучаться базовым принципам нашей организации. Воспользуйтесь\nкомандой {ffff00}/mm > Команды сервера, {ffffff}чтобы познакомиться с функционалом.", "Закрыть", "");
                }
            }
        }
        return 1;
    }
        
    if (dialogid == DIALOG_OTD5)
    { 
        if(response)
        {
            if(GetPlayerLevel(playerid) < 3)
                return ShowNotification(playerid, 2, "Чтобы пройти тестирование необходим 3 уровень", 4, " ", "");
            if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 0)
                ShowNotification(playerid, 2, "У вас нету лицензий", 4, " ", "");
                    
            ShowPlayerDialog(playerid, DIALOG_OPR5, DIALOG_STYLE_LIST, "{FF6347}Что такое RolePlay?", "{ffff00}1. {ffffff}Убийство по РП\n{ffff00}2. {ffffff}Игра по ролям\n{ffff00}3. {ffffff}Воображение из себя героя", "Выбрать", "Закрыть");
        }
        else return 1;
    }
            
    if (dialogid == DIALOG_OPR5)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EX5, DIALOG_STYLE_LIST, "{FF6347}Что такое DeathMach?", "{ffff00}1. {ffffff}Убийство без причины\n{ffff00}2. {ffffff}Зеленая зона", "Выбрать", "Закрыть");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EX5)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_EB5, DIALOG_STYLE_LIST, "{FF6347}Что такое DriveBy?", "{ffff00}1. {ffffff}Деморган\n{ffff00}2. {ffffff}Убийство машиной", "Выбрать", "Закрыть");
                }
                case 1:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EB5)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_EM5, DIALOG_STYLE_LIST, "{FF6347}Что такое ЕПП?", "{ffff00}1. {ffffff}Зона, в которой разрешен ездить нарушая правила\n{ffff00}2. {ffffff}Езда по полям", "Выбрать", "Закрыть");
                }
            }
        }
        return 1;
    }
            
    if (dialogid == DIALOG_EM5)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                }
                case 1:
                {
                    InvitePlayer(playerid, 4, 1, true);
                    ShowPlayerDialog(playerid, DIALOG_EK5, DIALOG_STYLE_MSGBOX, "{FF6347}"SERVER_NAME" {ffffff}| Информация", "Вы успешно прошли собеседование и были приняты в нашу\nорганизацию.\n\nВаша новая должность - {ffff00}1 ранг, {ffffff}и сейчас Ваша основная задача\nобучаться базовым принципам нашей организации. Воспользуйтесь\nкомандой {ffff00}/mm > Команды сервера, {ffffff}чтобы познакомиться с функционалом.", "Закрыть", "");
                }
            }
        }
        return 1;
    }           
	        if (dialogid == DIALOG_OTD6)
            { 
                if(response)
                {
                    if(GetPlayerLevel(playerid) < 3)
                        return ShowNotification(playerid, 2, "Чтобы пройти тестирование необходим 3 уровень", 4, " ", "");
                    if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 0)
                        ShowNotification(playerid, 2, "У вас нету лицензий", 4, " ", "");
                            
                    ShowPlayerDialog(playerid, DIALOG_OPR6, DIALOG_STYLE_LIST, "{FF6347}Что такое RolePlay?", "{ffff00}1. {ffffff}Убийство по РП\n{ffff00}2. {ffffff}Игра по ролям\n{ffff00}3. {ffffff}Воображение из себя героя", "Выбрать", "Закрыть");
                }
                else return 1;
            }   
            if (dialogid == DIALOG_OPR6)
            {
                if(response)
                {
                    switch(listitem)
                    {
                        case 0:
                        {
                            SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, DIALOG_EX6, DIALOG_STYLE_LIST, "{FF6347}Что такое DeathMach?", "{ffff00}1. {ffffff}Убийство без причины\n{ffff00}2. {ffffff}Зеленая зона\n{ffff00}3. {ffffff}Отыгровка РП", "Выбрать", "Закрыть");
                        }
                        case 2:
                        {
                            SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                        }
                    }
                }
            }
            if (dialogid == DIALOG_EX6)
            {
                if(response)
                {
                    switch(listitem)
                    {
                        case 0:
                        {
                            ShowPlayerDialog(playerid, DIALOG_EB6, DIALOG_STYLE_LIST, "{FF6347}Как расшифровывается УК?", "{ffff00}1. {ffffff}Указ\n{ffff00}2. {ffffff}Уголовный Кодекс", "Выбрать", "Закрыть");
                        }
                        case 1:
                        {
                            SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                        }
                        case 2:
                        {
                            SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                        }
                    }
                }
            }
            if (dialogid == DIALOG_EB6)
            {
                if(response)
                {
                    switch(listitem)
                    {
                        case 0:
                        {
                            SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, DIALOG_EM6, DIALOG_STYLE_LIST, "{FF6347}Что такое \"Зелёная Зона\"?", "{ffff00}1. {ffffff}Зона, в которой разрешен DM\n{ffff00}2. {ffffff}Зона,в которой запрещено атаковать и можно восстановить здоровье", "Выбрать", "Закрыть");
                        }
                    }
                }
            }
            if (dialogid == DIALOG_EM6)
            {
                if(response)
                {
                    switch(listitem)
                    {
                        case 0:
                        {
                            SCM(playerid, -1, "Вы выбрали неверный ответ. Попробуйте еще раз");
                        }
                        case 1:
                        {
                            InvitePlayer(playerid, 6, 1, true);
                            ShowPlayerDialog(playerid, DIALOG_EK6, DIALOG_STYLE_MSGBOX, "{FF6347}"SERVER_NAME" {ffffff}| Информация", "Вы успешно прошли собеседование и были приняты в нашу\nорганизацию.\n\nВаша новая должность - {ffff00}1 ранг, {ffffff}и сейчас Ваша основная задача\nобучаться базовым принципам нашей организации. Воспользуйтесь\nкомандой {ffff00}/mm > Команды сервера, {ffffff}чтобы познакомиться с функционалом.", "Закрыть", "");
                        }
                    }
                }
            }
    #if defined cadry_OnDialogResponse
    return cadry_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse cadry_OnDialogResponse
#if defined cadry_OnDialogResponse
forward cadry_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnGameModeInit()
{
    pickupotd = CreateDynamicSphere(-1106.0161,1513.1263,1499.9532, 1); 				//гибдд
	CreateActorEx("", "", 120, -1106.0161,1513.1263,1499.9532,48.651622, 1, 1);   		//гибдд

 	pickupotd1 = CreateDynamicSphere(-887.4969,-1577.6821,1398.4611, 2.0); 				//праительство
	CreateActorEx("", "", 120, -887.4969,-1577.6821,1398.4611,88.553642, 1, 1);   		//правительство
	
 	pickupotd2 = CreateDynamicSphere(499.133605,1509.873901,1501.000000, 2.0); 			//военкомат
	CreateActorEx("", "", 120, 498.892333,1511.592407,1501.000000,179.753707, 1, 1);   	//военкомат
	
 	pickupotd3 = CreateDynamicSphere(1502.981933, 2500.426025, 2501.000000, 2.0); 		//больница
	CreateActorEx("", "", 120, 1502.981933, 2500.426025, 2501.000000,274.605865, 1, 1); //больница
	
 	pickupotd4 = CreateDynamicSphere(2885.920654, 2005.464965, 2050.988525, 2.0); 		//фсб
	CreateActorEx("", "", 120, 2885.920654, 2005.464965, 2050.988525,219.813049, 1, 1); //фсб
	
 	pickupotd5 = CreateDynamicSphere(1984.850830, -3.287999, 1381.003540, 2.0); 		//сми
	CreateActorEx("", "", 120, 1984.850830, -3.287999, 1381.003540,358.061248, 1, 1);   //сми
	
 	pickupotd6 = CreateDynamicSphere(-1106.0161,1513.1263,1499.9532, 0); 				//умвд
	CreateActorEx("", "", 120, -1106.0161,1513.1263,1499.9532,48.651622, 2, 1);   		//умвд

    CreateDynamic3DTextLabel("<< Отдел кадров >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, -1106.0161,1513.1263,1499.9532 + 0.3, 10.0);      	//гибдд
    CreateDynamic3DTextLabel("<< Отдел кадров >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, -887.4969,-1577.6821,1398.4611 + 0.3, 10.0);      	//правительство
    CreateDynamic3DTextLabel("<< Отдел кадров >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, 498.892333,1511.592407,1501.000000 + 0.3, 10.0);  	//военкомант
    CreateDynamic3DTextLabel("<< Отдел кадров >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, 1502.981933, 2500.426025, 2501.000000 + 0.3, 10.0);   //больница
    CreateDynamic3DTextLabel("<< Отдел кадров >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, 2885.920654, 2005.464965, 2050.988525 + 0.3, 10.0);   //фсб
    CreateDynamic3DTextLabel("<< Отдел кадров >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, 1984.850830, -3.287999, 1381.003540 + 0.3, 10.0);     //сми
    CreateDynamic3DTextLabel("<< Отдел кадров >>\n\n{FFFFFF}Подойдите ближе\n{FFFFFF}для взаимодействия", 0xFFFF00FF, -1106.0161,1513.1263,1499.9532 + 0.3, 10.0);          //умвд

    #if defined cadry_OnGameModeInit
        return cadry_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit cadry_OnGameModeInit
#if defined cadry_OnGameModeInit
    forward cadry_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == pickupotd)
	{
        ShowNewNotification(playerid, 4, 5, YES_FRACTION, 1, "Отдел кадров", "");
    }
    if(areaid == pickupotd1)
	{
        ShowNewNotification(playerid, 4, 5, YES_FRACTION1, 1, "Отдел кадров", "");
    }
    if(areaid == pickupotd2)
	{
        ShowNewNotification(playerid, 4, 5, YES_FRACTION2, 1, "Отдел кадров", "");
    }
    if(areaid == pickupotd3)
	{
        ShowNewNotification(playerid, 4, 5, YES_FRACTION3, 1, "Отдел кадров", "");
    }
    if(areaid == pickupotd4)
	{
        ShowNewNotification(playerid, 4, 5, YES_FRACTION4, 1, "Отдел кадров", "");
    }
    if(areaid == pickupotd5)
	{
        ShowNewNotification(playerid, 4, 5, YES_FRACTION5, 1, "Отдел кадров", "");
    }
    if(areaid == pickupotd6)
	{
        ShowNewNotification(playerid, 4, 5, YES_FRACTION6, 1, "Отдел кадров", "");
    }
    #if defined cadry_OnPlayerEnterDynamicArea
        return cadry_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea cadry_OnPlayerEnterDynamicArea
#if defined cadry_OnPlayerEnterDynamicArea
    forward cadry_OnPlayerEnterDynamicArea(playerid, areaid);
#endif    