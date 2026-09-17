#if defined _INC_Damage
    #endinput
#else
    #define _INC_Damage
#endif

public OnGameModeInit()
{
    new tick = GetTickCount();

    printf("Модуль загружен за %d секунд", tick);
    #if defined damage_OnGameModeInit
        return damage_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit damage_OnGameModeInit
#if defined damage_OnGameModeInit
    forward damage_OnGameModeInit();
#endif

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return printf("OnPlayerTakeDamage(Игрок не подключен/не авторизован) завершаем процесс", playerid, issuerid, Float:amount, weaponid, bodypart);

    //if(amount >= 70.0) return Kick(issuerid); // проверочка на получаемый урон

    if(GetPlayerLevel(issuerid) < 3) return SendClientMessage(issuerid, 0xFF7F50ff, "SAVA-CORE: {ffffff}Вы можете наносить урон только с 3 уровня.");
    if(GetPlayerLevel(playerid) < 3) return SendClientMessage(issuerid, 0xFF7F50ff, "SAVA-CORE: {ffffff}Нельзя наносить урон новичкам до 3 уровня.");

    new Float:playerHealth, Float:playerArmour;
    GetPlayerHealth(playerid, playerHealth);
    GetPlayerArmour(playerid, playerArmour);

    switch(weaponid)
    {
        // Рукопашный бой и холодное оружие
        case 1:  amount = 2.0; // Кулаки
        case 2:  amount = 3.0; // Кастет
        case 3:  amount = 8.0; // Дубинка
        case 4:  amount = 8.0; // Клюшка для гольфа
        case 5:  amount = 8.0; // Кий
        case 6:  amount = 10.0; // Катана
        case 7:  amount = 15.0; // Бензопила
    
        // Пистолеты
        case 22: amount = 15.0; // Colt 45
        case 23: amount = 15.0; // Бесшумный пистолет
        case 24: amount = 40.0; // Desert Eagle
    
        // Дробовики
        case 25: amount = 35.0; // Дробовик
        case 26: amount = 25.0; // Обрез
        case 27: amount = 40.0; // Боевой дробовик (SPAS-12)
    
        // Пистолеты-пулеметы
        case 28: amount = 8.0; // Micro UZI
        case 29: amount = 10.0; // MP5
        case 32: amount = 8.0; // Tec-9
    
        // Автоматы
        case 30: amount = 20.0; // AK-47
        case 31: amount = 22.0; // M4
    
        // Винтовки
        case 33: amount = 25.0; // Загородная винтовка
        case 34: amount = 25.0; // Снайперская винтовка (убийство с одного выстрела)
    
        // Тяжелое вооружение
        case 35: amount = 5.0; // Огнемет
        case 38: amount = 15.0; // Миниган
        case 37: amount = 50.0; // РПГ
        case 16: amount = 50.0; // Граната (взрыв)
    
        // Другие
        case 41: amount = 1.0; // Баллончик с краской
        case 42: amount = 1.0; // Огнетушитель
        case 43: amount = 0.0; // Фотоаппарат
        case 8:  amount = 5.0; // Дилдо
        case 18: amount = 50.0; // Граната (в руках)
    }

    if(playerArmour > 100.0) return Kick(playerid); // ну типо как может быть больше 100

    if(playerArmour > 0.0)
    {
        if(amount >= playerArmour)
        {
            amount -= playerArmour;
            SetPlayerArmour(playerid, 0.0);
        }
        else
        {
            SetPlayerArmour(playerid, playerArmour - amount);
            amount = 0.0;
        }
    }
    if(GetPlayerHealth(playerid) < 15.0)
    {
    	new Node:tuning_json = JSON_Object();
    	ShowPlayerGUI(playerid, 40, tuning_json);
    	JSON_Cleanup(tuning_json);
	}
    

    if(playerHealth > 100.0) return Kick(playerid); // ну как-бы

    if(amount > 0.0) SetPlayerHealth(playerid, playerHealth - amount);

    if(TEAM_DPS <= GetPlayerTeamEx(issuerid) <= TEAM_FBI)
	{
		if(weaponid == WEAPON_NITESTICK)
		{
			SetPlayerAnimation(playerid, 21);
			TogglePlayerControllable(playerid, false);

			SetTimerEx("UnfreezePlayer", 15000, false, "i", playerid);

			new fmt_text[90];

			format(fmt_text, sizeof fmt_text, "Вы оглушили %s на 15 секунд", GetPlayerNameEx(playerid));
			SendClientMessage(issuerid, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "%s оглушил Вас на 15 секунд", GetPlayerNameEx(issuerid));
			SendClientMessage(playerid, 0x3399FFFF, fmt_text);

			CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);
		}
	}
	    /*if(GetPlayerHealthEx(playerid) < 15.0)
    {
        new Node:json = JSON_Object();
        JSON_SetInt(json, "t", 0);

        ShowPlayerGUI(playerid, 40, json);
    }*/

    return 1;
}
