#define SC              "{ffff00}| {ffffff}"
#define USC             "{ff2400}| {ffffff}"

new Text:klad_TD[3];


new place_td[25][2] =
{
    {0, 0},
    {0, 1},
    {0, 2},
    {0, 3},
    {0, 4},
    {1, 0},
    {1, 1},
    {1, 2},
    {1, 3},
    {1, 4},
    {2, 0},
    {2, 1},
    {2, 2},
    {2, 3},
    {2, 4},
    {3, 0},
    {3, 1},
    {3, 2},
    {3, 3},
    {3, 4},
    {4, 0},
    {4, 1},
    {4, 2},
    {4, 3},
    {4, 4}
};

// Текстдравы для игроков
new PlayerText:klad_PTD[MAX_PLAYERS][26];


new Float:treasure_site[30][3] = //15 - 15
{
    {111.88,2164.76,10.79},
    {45.65,2162.44,10.99},
    {-4.76,2146.60,11.49},
    {-49.42,2152.74,11.49},
    {-64.09,2211.91,12.75},
    {-60.38,2261.99,12.86},
    {-44.93,2277.96,12.85},
    {-4.99,2245.32,12.85},
    {62.03,2248.61,12.85},
    {114.46,2281.57,12.85},
    {115.88,2231.28,12.85},
    {37.94,2198.59,12.01},
    {-0.70,2295.03,12.85},
    {-2.74,2184.38,12.33},
    {46.27,2208.62,12.47},

    {2517.33,2503.20,11.62},
    {2542.43,2528.66,11.69},
    {2545.37,2581.89,12.12},
    {2542.16,2655.73,12.33},
    {2492.41,2646.62,13.63},
    {2475.55,2595.25,13.44},
    {2453.52,2547.04,12.69},
    {2422.21,2568.78,14.00},
    {2375.20,2662.00,18.21},
    {2418.62,2661.59,16.48},
    {2451.45,2502.39,11.92},
    {2390.49,2503.58,12.39},
    {2370.68,2567.30,15.21},
    {2382.29,2610.74,16.40},
    {2515.32,2575.17,12.42}
};



enum TREASURE_HUNTER
{
    bool:InHunterStart,
    HunterSkill,
    TreasureArea,
//    bool:InTreasureArea,
    TreasureID[5],
    TreasureCount,
    TextDraw[25],

    TimerID,
    Second,

    TD_OLD_ID,
    TD_CountDown, //да.

    TD_TreasureStatus[25],
}

new player_thunter[MAX_PLAYERS][TREASURE_HUNTER];

new NPC_Treasure, TH_GangZone[2], TH_Zone[2];

cmd:dig(playerid)
{
    if(!player_thunter[playerid][InHunterStart]) return 0;

    if(DistanceFromTreasure(playerid) >= 11) return SendClientMessage(playerid, -1, ""USC"Вы не на месте!");

    HideDetector(playerid);
    ShowTreasureHunt(playerid);
    return 1;
}

cmd:kleave(playerid)
{
    if(!player_thunter[playerid][InHunterStart]) return 0;

    ShowPlayerDialog(playerid, 8641, DIALOG_STYLE_MSGBOX, "{FF0000}Кладоискатель", "Вы действительно хотите покинуть работу кладоискателя. Если Вы согласитесь. Вы не получите ничего!", "Далее", "Выйти");
    return 1;
}

public:CREATE_TREASURE_HUNTER()
{
    mysql_query(mysql, "SELECT * FROM accounts WHERE skill_treasure", false);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `skill_treasure` INT NOT NULL DEFAULT '0' AFTER `job`, ADD `shovel` INT NULL DEFAULT '0' AFTER `skill_treasure`, ADD `mdetector` INT NOT NULL DEFAULT '0' AFTER `shovel`", false);

        if(mysql_errno()) return printf("[W_SYSTEM - treasure_hunter.amx] Error - Create ALTER TABLE ");
        else if(mysql_errno()) return printf("[W_SYSTEM - treasure_hunter.amx] Create ALTER TABLE ");
    }

    return 1;
}

stock ShowTreasureHunt(playerid)
{
    for(new i; i < 10; i++) SendClientMessage(playerid, -1, "");

    HideHud(playerid);
    TogglePlayerControllable(playerid, 0);

    SelectTextDraw(playerid, 0xFFFFFF00);

    PlayerTextDrawShow(playerid, klad_TD[0]);
    PlayerTextDrawShow(playerid, klad_TD[1]);

    player_thunter[playerid][TD_OLD_ID] = -1;
    player_thunter[playerid][TD_CountDown] = 0;

    for(new i; i < 25; i++) {

        PlayerTextDrawSetString(playerid, klad_PTD[playerid][i], "txd:brzemlya");
        player_thunter[playerid][TD_TreasureStatus][i] = 0;
        PlayerTextDrawShow(playerid, klad_PTD[playerid][i]);
    } 

    new treasure = random(21) + 4, bomb[5] = {-1, -1, -1, -1, -1}, i, count_bomb = random(3) + 2, place;

    player_thunter[playerid][TD_TreasureStatus][treasure] = 3;

    while(i != count_bomb)
    {
        place = random(21) + 4;

        if(place == treasure) continue;
        else if(i != 0 && bomb[i] == place) continue;
        else if(place_td[place][0] == 0) continue;

        bomb[i] = place;
        player_thunter[playerid][TD_TreasureStatus][place] = 2;

        i++;
    }

    return 1;
}

stock ResetTreasureHunt(playerid)
{
    SetTimerEx("ResetTDTreasureHunt", 1500, false, "i", playerid);

    player_thunter[playerid][TD_CountDown] = 1;
}

public:ResetTDTreasureHunt(playerid)
{
    for(new i; i < 25; i++) {
        PlayerTextDrawSetString(playerid, klad_PTD[playerid][i], "txd:brzemlya");
    }  

    for(new i; i < 25; i++) {
        if(player_thunter[playerid][TD_TreasureStatus][i] == 1) player_thunter[playerid][TD_TreasureStatus][i] = 0; 
    }

    player_thunter[playerid][TD_CountDown] = 0;
    player_thunter[playerid][TD_OLD_ID] = -1;
}

//Ваш навык кладоискательно был повышен, поздравляем.
stock CompleteTreasureHunt(playerid)
{
    player_thunter[playerid][TD_CountDown] = 1;

    SetTimerEx("HideTreasureHunt", 1500, false, "i", playerid);

    player_thunter[playerid][TreasureCount] ++;

    new  string[144];

    if(player_thunter[playerid][TreasureCount] == 5)
    {   
        switch(random(2))
        {
            case 0: {
                SendClientMessage(playerid, -1, ""SC"К сожалению, не удалось повысить навык кладоискателя. В следующий раз должно повезти!");

            }
            case 1:
            {
                if(!(player_thunter[playerid][HunterSkill] % 5)) {
                   
			        UpdatePlayerDatabaseInt(playerid, "shovel", 0);
			        SetPlayerData(playerid, P_SHOVEL, 0);

                }
                SendClientMessage(playerid, -1, ""SC"Ваш навык кладоискательно был повышен, поздравляем.");

                player_thunter[playerid][HunterSkill]++;
                mysql_format(mysql, string, sizeof string, "UPDATE accounts SET skill_treasure = %d WHERE id = %d", player_thunter[playerid][HunterSkill], GetPlayerAccountID(playerid));
                mysql_query(mysql, string, false);
            }
        }
        new s = player_thunter[playerid][Second];
        player_thunter[playerid][Second] = 0;
        TimerTreasure(playerid);
        
        new second_salary =  random(s) * 2 + s / 2, salary = 10000 + second_salary, Float:skill = 1.0 + (player_thunter[playerid][HunterSkill] * 0.01);

        salary = floatround(salary * skill);
        format(string, sizeof string, ""SC"Миссия закончена, Вы заработали %d рублей.", salary);
        SendClientMessage(playerid, -1, string);
        GivePlayerMoneyEx(playerid, salary);

    }
    else {

        for(new i; i < 10; i++) SendClientMessage(playerid, -1, "");

        format(string, sizeof string, ""SC"Вы нашли клад! Ваш прогресс {FFFF00}%d {FFFFFF}/{FFFF00} 5", player_thunter[playerid][TreasureCount]);
        SendClientMessage(playerid, -1, string);
        
        SendClientMessage(playerid, -1, ""SC"Найдите новое место для того, чтобы начать копать!");

    }
}

public: HideTreasureHunt(playerid)
{
    player_thunter[playerid][TD_CountDown] = 0;

    ShowHud(playerid);
    TogglePlayerControllable(playerid, 1);

    CancelSelectTextDraw(playerid);

    TextDrawHideForPlayer(playerid, klad_TD[0]);
    TextDrawHideForPlayer(playerid, klad_TD[1]);

    for(new i; i < 25; i++) {
        PlayerTextDrawHide(playerid, klad_PTD[playerid][i]);
    } 

    if(player_thunter[playerid][InHunterStart]) ShowDetector(playerid);
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(klad_PTD[playerid][0] <= playertextid <= klad_PTD[playerid][24])
    {
        new id = -1;

        for(new i; i < 25; i ++) if(klad_PTD[playerid][i] == playertextid) { id = i; break; }

        if(id == -1) return printf("None ID-TextDraw");

        if(player_thunter[playerid][TD_CountDown]) return 1;


        if(player_thunter[playerid][TD_OLD_ID] == -1 && place_td[id][0] != 0) return ShowNotification(playerid, 2, "Вам нужно кликнуть по верхней линии!", 2, "", "");

        new old= player_thunter[playerid][TD_OLD_ID];

        if(old != -1) {
            new bool:error;

            if(place_td[old][0] != place_td[id][0])
            {
                if(place_td[old][0] > place_td[id][0]) error = true;
                else if(/*place_td[old][0] > place_td[id][0] &&*/ place_td[old][0] + 1 != place_td[id][0]) error = true;
                //else if (place_td[old][0]+1 != place_td[id][0]) error = true;
            }

            if(place_td[old][1] != place_td[id][1])
            {
                if(place_td[old][1] > place_td[id][1] && place_td[old][1]-1 != place_td[id][1]) error = true;
                else if (place_td[old][1] < place_td[id][1] && place_td[old][1]+1 != place_td[id][1]) error = true;
            }

            if(place_td[old][0] != place_td[id][0] && place_td[old][1] != place_td[id][1]) error = true;


            if(error){

                ResetTreasureHunt(playerid);
                
                return ShowNotification(playerid, 2, "Туда хода нет!", 2, "", "");
            }
        }

        player_thunter[playerid][TD_OLD_ID] = id;

        switch(player_thunter[playerid][TD_TreasureStatus][id])
        {
            case 0:
            {
                PlayerTextDrawSetString(playerid, klad_PTD[playerid][id], "txd:brzemlyagreen");
                player_thunter[playerid][TD_TreasureStatus][id] = 1;
            }
            case 1:{

                ResetTreasureHunt(playerid);
                
                return ShowNotification(playerid, 2, "Туда нет хода!", 2, "", "");

            }
            case 2:
            {
                PlayerTextDrawSetString(playerid, klad_PTD[playerid][id], "txd:brbomb");

                ResetTreasureHunt(playerid);
                
                return ShowNotification(playerid, 2, "Вы наступили на бомбу, все заново!", 2, "", "");
            }
            case 3:
            {
                PlayerTextDrawSetString(playerid, klad_PTD[playerid][id], "txd:brklad");

                CompleteTreasureHunt(playerid);
            }
        }
    }

	#if defined klad_OnPlayerClickPlayerTextD
		return klad_OnPlayerClickPlayerTextD(playerid, playertextid);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnPlayerClickPlayerTextD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextD
#endif
#if defined klad_OnPlayerClickPlayerTextD
	forward klad_OnPlayerClickPlayerTextD(playerid, PlayerText:playertextid);
#endif
#define	OnPlayerClickPlayerTextDraw klad_OnPlayerClickPlayerTextD


public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == klad_TD[1])
    {
        HideTreasureHunt(playerid);
    }
    #if defined klad_OnPlayerClickTextDraw
        return klad_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw klad_OnPlayerClickTextDraw
#if defined klad_OnPlayerClickTextDraw
    forward klad_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnGameModeInit()
{
    print("\n--------------------------------------");
	print(" WELSI STUDIO | СИСТЕМА КЛАДОИСКАТЕЛЯ (BR)");
	print("--------------------------------------\n");

    // 503.021453,-1211.743774,40.953125,358.034362,0,0 // npc

    // 502.876220,-1210.884155,40.953125,13.375116,0,0 // pickup

    // 130.310684,2130.348876,11.438724,212.041000,0,0 // min
    // -66.806221,2300.878906,12.585665,124.237937,0,0 // max

    // 2548.191650,2492.421142,11.801289,228.688888,0,0 // min
    // 2365.587890,2666.925537,18.396949,239.186065,0,0 // max

    CreateObject(17618, 503.021,-1211.74,40.95,358.03, -90.0, 180.0, 0.0);
    Create3DTextLabel("[NPC]\nПантелеевич", 0x137660FF, 503.021,-1211.74,41.95, 7.5, 0);
    CreateDynamicPickup(23, 1275, 502.876220,-1210.884155,40.95312, 0, 0);
    NPC_Treasure = CreateDynamicSphere(502.876220,-1210.884155,40.95312, 1.5, 0, 0);


    SetTimer("CREATE_TREASURE_HUNTER", 1500, false);

    CreateTreasureHunter();

    //  130.310,2130.348,-66.806,2300.878
    //  2548.191,2492.42,2365.587,2666.92

    TH_Zone[0] = CreateDynamicRectangle(130.310,2130.348,-66.806,2300.878, 0, 0);
    TH_GangZone[0] =GangZoneCreate(130.310,2130.348,-66.806,2300.878);

    TH_Zone[1] = CreateDynamicRectangle(2548.191,2492.42,2365.587,2666.92, 0, 0);
    TH_GangZone[1] =GangZoneCreate(2548.191,2492.42,2365.587,2666.92);

    print("[W_SYSTEM] Система кладоискателя загружена.");

    #if defined klad_OnGameModeInit
        return klad_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit klad_OnGameModeInit
#if defined klad_OnGameModeInit
    forward klad_OnGameModeInit();
#endif
public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == NPC_Treasure)
    {
        if(player_thunter[playerid][InHunterStart])
        {
            callcmd::kleave(playerid);
            return 1;
        }


        if(GetPlayerLevel(playerid) < 3) return SendClientMessage(playerid, -1, ""USC"Для работы кладоискателя Ваш уровень должен быть больше 3");

        if(GetPlayerData(playerid, P_DETECTOR) == 1) return SendClientMessage(playerid, -1, ""USC"Для работы кладоискателя у Вас должен быть металлоискатель");
        else if(GetPlayerData(playerid, P_SHOVEL) == 2) return SendClientMessage(playerid, -1, ""USC"Для работы кладоискателя у Вас должна быть лопата для кладоискателя");

        new string[900] = {
            "Кладоискатель — это одна из самых интереснейший и увлекательнейших работ сервера\n\
            которая предоставляется возможность всем игрокам проявить множество внутренних\n\
            личных качеств, а также свою интуицию. Постарайтесь только вдуматься: отправится в\n\
            путешествие на поиски затерянного клада это невероятно здорово и интересно.\n\
            Мы реализовали действительно интересную, а также динамичную интерактивную игру\n\
            от которой зависит насколько быстро клад будет найден и откопан.\n\n\
            Нельзя не упомянуть о системе скиллов: каждый найденный клад повышает уровень\n\
            кладоискателя, который, в свою очередь, преувеличивает прибыль игрока.\n",
        }, skill[184];

        format(skill, sizeof skill, "На данный момент Ваш уровень кладоискателя составляет: %d / 170. Для того, чтобы отправиться на поиски необходимо будет арендовать специальный\n\
        с помощью которого Вы будете искать местоположение непосредственного самого спрятанного клада.", player_thunter[playerid][HunterSkill]);

        strcat(string, skill);

        ShowPlayerDialog
        (
            playerid, 8640, DIALOG_STYLE_MSGBOX, 
            "{FF0000}Кладоискатель",
            string, "Начать", "Выйти"
        );
    }
    if(player_thunter[playerid][TreasureArea] != -1 && areaid == TH_Zone[player_thunter[playerid][TreasureArea]])
    {
        ShowDetector(playerid);
    }
    

    #if defined klad_OnPlayerEnterDynamicArea
        return klad_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea klad_OnPlayerEnterDynamicArea
#if defined klad_OnPlayerEnterDynamicArea
    forward klad_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    if(player_thunter[playerid][TreasureArea] != -1 && areaid == TH_Zone[player_thunter[playerid][TreasureArea]])
    {
        HideDetector(playerid);
    }

    #if defined klad_OnPlayerLeaveDynamicArea
        return klad_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerLeaveDynamicArea
    #undef OnPlayerLeaveDynamicArea
#else
    #define _ALS_OnPlayerLeaveDynamicArea
#endif
#define OnPlayerLeaveDynamicArea klad_OnPlayerLeaveDynamicArea
#if defined klad_OnPlayerLeaveDynamicArea
    forward klad_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

stock ShowDetector(playerid)
{
    SetPlayerAttachedObject(playerid, 9, 17617, 6);

    UpdateDetector(playerid);

    PlayerTextDrawShow(playerid, klad_TD[2]);

    PlayerTextDrawShow(playerid, klad_PTD[playerid][25]);
}

stock HideDetector(playerid)
{
    RemovePlayerAttachedObject(playerid, 9);

    TextDrawHideForPlayer(playerid, klad_TD[2]);

    PlayerTextDrawHide(playerid, klad_PTD[playerid][25]);
}

stock DeletePlayerTreasure(playerid)
{
    HidePlayerTHGangZone(playerid);
    HideDetector(playerid);

    if(player_thunter[playerid][TimerID] != -1) KillTimer(player_thunter[playerid][TimerID]);

    player_thunter[playerid][TimerID] = -1;
    player_thunter[playerid][Second] = 0;

    player_thunter[playerid][InHunterStart] = false;
    player_thunter[playerid][TreasureArea] = -1;
    player_thunter[playerid][TreasureCount] = 0;
   // player_thunter[playerid][InTreasureArea] = false;

    for(new i; i< 5; i ++) player_thunter[playerid][TreasureID][i] = -1;

}

stock ShowPlayerTHGangZone(playerid)
{
    if(player_thunter[playerid][TreasureArea] != -1) GangZoneShowForPlayer(playerid, TH_GangZone[player_thunter[playerid][TreasureArea]], 0xC2C815D4); //b5ba12
}

stock HidePlayerTHGangZone(playerid)
{
    if(player_thunter[playerid][TreasureArea] != -1) GangZoneHideForPlayer(playerid, TH_GangZone[player_thunter[playerid][TreasureArea]]);
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

    if(dialogid == 8640)
    {
        if(response)
        {
            SendClientMessage(playerid, -1, ""SC"Специальная желтая зона, на территории которой необходимо найти клад - отмечена на карте.");
            SendClientMessage(playerid, -1, ""SC"Воспользуйтесь командой: \"/dig\" когда будете на месте, чтобы начать процесс раскопки.");
            SendClientMessage(playerid, -1, ""SC"Миссию можно закончить в любой момент, для этого воспользутесь командой: \"/kleave\".");

            DeletePlayerTreasure(playerid);

            new area = random(2);
            
            player_thunter[playerid][TreasureArea] = area;
            player_thunter[playerid][InHunterStart] = true;

            ShowPlayerTHGangZone(playerid);

            for(new i, e, r; i < 5; i ++)
            {
                while(player_thunter[playerid][TreasureID][i] == -1)
                {
                    r = random(15);
                
                    for(e = 0; e < 5; e++) if( player_thunter[playerid][TreasureID][e] == r) e = 7;
                    
                    if(e != 7) {
                        player_thunter[playerid][TreasureID][i] = r;
                    }
                }
            }

            if(area) for(new i; i < 5; i ++) player_thunter[playerid][TreasureID][i] = player_thunter[playerid][TreasureID][i] + 15;

            player_thunter[playerid][Second] = 2000;
            player_thunter[playerid][TimerID] = SetTimerEx("TimerTreasure", 1000, true, "i", playerid);
        }
    }
    
    if(dialogid == 8641)
    {
         if(response){
            DeletePlayerTreasure(playerid);

            SendClientMessage(playerid, -1, ""USC"Вы закончили работу кладоискателя.");
         }
    }

    #if defined klad_OnDialogResponse
    return klad_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse klad_OnDialogResponse
#if defined klad_OnDialogResponse
forward klad_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public: TimerTreasure(playerid)
{
    if(player_thunter[playerid][Second] != 0)
    {
        player_thunter[playerid][Second]--;

        new text[56];

        format(text, sizeof text, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~%d ~g~CEK.", player_thunter[playerid][Second]);
        GameTextForPlayer(playerid, text, 900, 3);

        UpdateDetector(playerid);
    }
    else
    {
        SendClientMessage(playerid, -1, ""SC"Время вышло, миссия кладоискателя закончена!");
        DeletePlayerTreasure(playerid);
    }
}

stock UpdateDetector(playerid)
{
    new string[8];

    format(string, 8, "%dЇ.", DistanceFromTreasure(playerid));

    PlayerTextDrawSetString(playerid, klad_PTD[playerid][25], string);
}

stock DistanceFromTreasure(playerid)
{
    if(player_thunter[playerid][TreasureID][0] == -1) return 0;

    new id = player_thunter[playerid][TreasureID][player_thunter[playerid][TreasureCount]]; // :)

    new distance = floatround(GetPlayerDistanceFromPoint(playerid, treasure_site[id][0], treasure_site[id][1], treasure_site[id][2]));

    return distance;
}

public OnPlayerConnect(playerid)
{
    player_thunter[playerid][TimerID] = -1;

    DeletePlayerTreasure(playerid);
    	
    new query[84];

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, MAX_PLAYER_NAME);

    mysql_format(mysql, query, sizeof query, "SELECT skill_treasure FROM accounts WHERE `name`='%e' LIMIT 1", name);
    new Cache:result = mysql_query(mysql, query);

    if(!mysql_errno())
    {
        player_thunter[playerid][HunterSkill] = cache_get_row_int(0, 0);
        CreatePTreasureHunter(playerid);
    }

    cache_delete(result);

    #if defined klad_OnPlayerConnect
        return klad_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect klad_OnPlayerConnect
#if defined klad_OnPlayerConnect
    forward klad_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    DeletePlayerTreasure(playerid);

    #if defined klad_OnPlayerDisconnect
        return klad_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect klad_OnPlayerDisconnect
#if defined klad_OnPlayerDisconnect
    forward klad_OnPlayerDisconnect(playerid, reason);
#endif



stock CreateTreasureHunter()
{
    klad_TD[0] = TextDrawCreate(150.4167, 35.7406, "txd:brosnova"); // пусто
    TextDrawTextSize(klad_TD[0], 330.0000, 358.0000);
    TextDrawAlignment(klad_TD[0], 1);
    TextDrawColor(klad_TD[0], -1);
    TextDrawBackgroundColor(klad_TD[0], 255);
    TextDrawFont(klad_TD[0], 4);
    TextDrawSetProportional(klad_TD[0], 0);
    TextDrawSetShadow(klad_TD[0], 0);

    klad_TD[1] = TextDrawCreate(610.0000, 1.5183, "txd:brexit"); // пусто
    TextDrawTextSize(klad_TD[1], 31.0000, 39.0000);
    TextDrawAlignment(klad_TD[1], 1);
    TextDrawColor(klad_TD[1], -1);
    TextDrawBackgroundColor(klad_TD[1], 255);
    TextDrawFont(klad_TD[1], 4);
    TextDrawSetProportional(klad_TD[1], 0);
    TextDrawSetShadow(klad_TD[1], 0);
    TextDrawSetSelectable(klad_TD[1], true);

    klad_TD[2] = TextDrawCreate(390.8341, 338.0371, "txd:brmettal"); // пусто
    TextDrawTextSize(klad_TD[2], 101.0000, 112.0000);
    TextDrawAlignment(klad_TD[2], 1);
    TextDrawColor(klad_TD[2], -1);
    TextDrawBackgroundColor(klad_TD[2], 255);
    TextDrawFont(klad_TD[2], 4);
    TextDrawSetProportional(klad_TD[2], 0);
    TextDrawSetShadow(klad_TD[2], 0);
}

stock CreatePTreasureHunter(playerid)
{
    klad_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 169.1665, 54.9258, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][0], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][0], true);
    
  //  PlayerTextDrawDestroy(playerid, klad_PTD[playerid][0]);

    klad_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 169.1665, 54.9258, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][0], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][0], true);

    klad_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 228.3332, 54.9258, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][1], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][1], true);

    klad_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 287.9165, 54.9258, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][2], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][2], true);

    klad_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 347.5000, 54.9258, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][3], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][3], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][3], true);

    klad_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 407.0834, 54.9258, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][4], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][4], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][4], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][4], true);

    klad_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 169.1667, 119.2220, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][5], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][5], true);

    klad_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 228.3332, 119.2220, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][6], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][6], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][6], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][6], true);

    klad_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 287.9165, 119.2220, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][7], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][7], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][7], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][7], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][7], true);

    klad_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 347.5000, 119.2220, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][8], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][8], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][8], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][8], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][8], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][8], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][8], true);

    klad_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 407.0834, 119.2220, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][9], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][9], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][9], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][9], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][9], true);

    klad_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 169.1667, 183.5184, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][10], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][10], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][10], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][10], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][10], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][10], true);

    klad_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 228.3332, 183.5184, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][11], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][11], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][11], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][11], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][11], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][11], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][11], true);

    klad_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 287.9165, 183.5184, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][12], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][12], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][12], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][12], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][12], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][12], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][12], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][12], true);

    klad_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 347.5000, 183.5184, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][13], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][13], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][13], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][13], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][13], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][13], true);

    klad_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 407.0834, 183.5186, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][14], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][14], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][14], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][14], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][14], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][14], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][14], true);

    klad_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 169.5832, 248.3332, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][15], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][15], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][15], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][15], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][15], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][15], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][15], true);

    klad_PTD[playerid][16] = CreatePlayerTextDraw(playerid, 228.7500, 248.3332, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][16], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][16], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][16], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][16], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][16], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][16], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][16], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][16], true);

    klad_PTD[playerid][17] = CreatePlayerTextDraw(playerid, 288.3334, 248.3332, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][17], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][17], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][17], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][17], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][17], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][17], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][17], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][17], true);

    klad_PTD[playerid][18] = CreatePlayerTextDraw(playerid, 347.9165, 248.3332, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][18], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][18], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][18], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][18], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][18], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][18], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][18], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][18], true);

    klad_PTD[playerid][19] = CreatePlayerTextDraw(playerid, 407.5000, 248.3332, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][19], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][19], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][19], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][19], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][19], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][19], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][19], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][19], true);

    klad_PTD[playerid][20] = CreatePlayerTextDraw(playerid, 169.5832, 312.6296, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][20], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][20], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][20], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][20], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][20], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][20], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][20], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][20], true);

    klad_PTD[playerid][21] = CreatePlayerTextDraw(playerid, 228.7500, 312.6293, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][21], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][21], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][21], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][21], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][21], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][21], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][21], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][21], true);

    klad_PTD[playerid][22] = CreatePlayerTextDraw(playerid, 288.3334, 312.6293, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][22], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][22], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][22], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][22], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][22], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][22], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][22], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][22], true);

    klad_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 347.9165, 312.6293, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][23], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][23], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][23], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][23], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][23], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][23], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][23], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][23], true);

    klad_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 407.5000, 312.6293, "txd:brzemlya"); // пусто
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][24], 54.0000, 60.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][24], 1);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][24], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][24], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][24], 4);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][24], 0);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][24], 0);
    PlayerTextDrawSetSelectable(playerid, klad_PTD[playerid][24], true);

    klad_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 442.4996, 363.7036, "253Ї."); // пусто
    PlayerTextDrawLetterSize(playerid, klad_PTD[playerid][25], 0.4065, 2.4347);
    PlayerTextDrawTextSize(playerid, klad_PTD[playerid][25], 0.0000, -1.0000);
    PlayerTextDrawAlignment(playerid, klad_PTD[playerid][25], 2);
    PlayerTextDrawColor(playerid, klad_PTD[playerid][25], -1);
    PlayerTextDrawBackgroundColor(playerid, klad_PTD[playerid][25], 255);
    PlayerTextDrawFont(playerid, klad_PTD[playerid][25], 1);
    PlayerTextDrawSetProportional(playerid, klad_PTD[playerid][25], 1);
    PlayerTextDrawSetShadow(playerid, klad_PTD[playerid][25], 0);

    return 1;
}
