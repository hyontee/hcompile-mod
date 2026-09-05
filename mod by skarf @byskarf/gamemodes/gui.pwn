stock CalendarGUI(playerid)
{   
    new Node:JSONObject = JSON_Object();
    
    // Основные параметры
    JSON_SetInt(JSONObject, "t", 1);            
    JSON_SetInt(JSONObject, "d", 43);              // дни до конца сезона
    JSON_SetInt(JSONObject, "vd", 17);     // дни до конца сезона для возвращения
    JSON_SetInt(JSONObject, "tu", 60000);             // секунды до нового дня
    JSON_SetInt(JSONObject, "tp", 20);             // секунды до награды
    JSON_SetInt(JSONObject, "pl", 10);                 // минимальный уровень
    JSON_SetInt(JSONObject, "lv", 11);                 // текущий уровень
    JSON_SetInt(JSONObject, "dp", 27);                     // дни игры
    JSON_SetInt(JSONObject, "vs", 18);             // дни игры для возвращения
    
    new Node:statusMainRewards = JSON_Array(
        JSON_Int(3), JSON_Int(3), JSON_Int(2), JSON_Int(1) // 0 - не собрано, не завершено, 1- таймер, 2- можно забрать, 3- собрано
    );
    JSON_SetArray(JSONObject, "ml", statusMainRewards);          // статус основных наград
    
    new Node:statusBonusRewards = JSON_Array(
        JSON_Int(2), JSON_Int(2), JSON_Int(2), JSON_Int(3), JSON_Int(0) //0 - не собрано разблокировано, 1- заблокано (нету лвла), 3- можно собрать
    );
    JSON_SetArray(JSONObject, "bl", statusBonusRewards);         // статус бонусных наград
    
    new Node:comeBackStatusMainRewards = JSON_Array(     
        JSON_Int(3), JSON_Int(3), JSON_Int(2), JSON_Int(2), JSON_Int(3), JSON_Int(2), JSON_Int(1)   // 0 - не собрано, не завершено, 1- таймер, 2- можно забрать, 3- собрано
    );
    JSON_SetArray(JSONObject, "vml", comeBackStatusMainRewards); // статус основных наград для возвращения
    
    new Node:comeBackStatusBonusRewards = JSON_Array(
        JSON_Int(2), JSON_Int(2), JSON_Int(0)
    );
    JSON_SetArray(JSONObject, "vbl", comeBackStatusBonusRewards); // статус бонусных наград для возвращения
    
    // 
   /* JSON_SetInt(JSONObject, "id", rewardId);                      // ID награды
    if (!isnull(rewardFromList)) {
        JSON_SetArray(JSONObject, "l", rewardFromList);          // награда из списка (может быть массивом)
    }*/
    
    ShowPlayerGUI(playerid, 71, JSONObject); 
    return 1;
}

stock EventGUI(playerid)
{   
    new Node:JSONObject = JSON_Object();
    
    JSON_SetInt(JSONObject, "t", 1);
    JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));           // BC_KEY - количество BC
    JSON_SetInt(JSONObject, "e", 9);              // BUY_CURRENCY_VALUE_KEY - значение валюты для покупки
    JSON_SetInt(JSONObject, "lc", 3499);              // сколько потрачено (лимит миниигр)
    JSON_SetInt(JSONObject, "a", 27);                // GAIN_LVL_KEY - полученный уровень
    JSON_SetInt(JSONObject, "d", 40);                // лвл эвента
    JSON_SetInt(JSONObject, "do", 1260);              // прогресс лвла
    JSON_SetInt(JSONObject, "m", 3);                // MY_PLACE_IN_RATING_KEY - место в рейтинге
    JSON_SetInt(JSONObject, "ln", 1);                // IS_GET_REWARD_FOR_CURRENT_LEVEL_KEY - награда за текущий уровень 0- собрано, 1- можно собрать
    
    // Дополнительный параметр
    JSON_SetInt(JSONObject, "l", 1);                  // CURRENT_LAYOUT_KEY - текущий макет
    
    // Примечание: QUEUE_WAIT_GAME_KEY использует тот же ключ "m", что и MY_PLACE_IN_RATING_KEY
    // Возможно, нужно выбрать что-то одно или уточнить назначение
    
    ShowPlayerGUI(playerid, 30, JSONObject); 
    return 1;
}

stock EventGUITest(playerid)
{   
    new Node:JSONObject = JSON_Object();
    
    // Основной тип GUI (был в исходном коде)
    JSON_SetInt(JSONObject, "t", 1);
    
    // Числовые параметры (int)
    JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));           // BC_KEY - количество BC
    JSON_SetInt(JSONObject, "e", 9);              // BUY_CURRENCY_VALUE_KEY - значение валюты для покупки
    JSON_SetInt(JSONObject, "lc", 3499);              // сколько потрачено (лимит миниигр)
    JSON_SetInt(JSONObject, "a", 27);                // GAIN_LVL_KEY - полученный уровень
    JSON_SetInt(JSONObject, "d", 40);                // лвл эвента
    JSON_SetInt(JSONObject, "do", 1260);              // прогресс лвла
    JSON_SetInt(JSONObject, "m", 3);                // MY_PLACE_IN_RATING_KEY - место в рейтинге
    JSON_SetInt(JSONObject, "ln", 0);                // IS_GET_REWARD_FOR_CURRENT_LEVEL_KEY - награда за текущий уровень 0- собрано, 1- можно собрать
    
    // Дополнительный параметр
    JSON_SetInt(JSONObject, "l", 1);                  // CURRENT_LAYOUT_KEY - текущий макет
    
    // Примечание: QUEUE_WAIT_GAME_KEY использует тот же ключ "m", что и MY_PLACE_IN_RATING_KEY
    // Возможно, нужно выбрать что-то одно или уточнить назначение
    
    ShowPlayerGUI(playerid, 30, JSONObject); 
    return 1;
}

cmd:callgui(playerid, params[])
{
    	if(GetPlayerAdminEx(playerid) < 1) return 1;
    if(isnull(params)) 
    {
        SendClientMessage(playerid, -1, "Использование: /callgui [ID GUI]");
        return 1;
    }
    
    new gui_id = strval(params);
    
    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "t", 1);
    
    ShowPlayerGUI(playerid, gui_id, JSONObject);
    
    return 1;
}

stock ShowPlayerLarekGUI(playerid)
{
    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
    
    ShowPlayerGUI(playerid, 3, JSONObject);
    return 1;
}

stock ShowNewsGUI(playerid)
{
    new Node:json = JSON_Object();
    new param[] = "\
    {\
        \"b\":[\
            {\"btn\":0,\"id\":1,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0},{\"aid\":5,\"s\":0}],\"sh\":1,\"t\":0},\     
            {\"btn\":0,\"id\":2,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0}],\"sh\":1,\"t\":0},\           
            {\"btn\":0,\"id\":3,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0}],\"sh\":1,\"t\":0},\       
            {\"btn\":0,\"id\":4,\"n\":0,\"p\":0,\"r\":[],\"sh\":1,\"t\":67642},\        
            {\"btn\":0,\"id\":6,\"n\":0,\"p\":0,\"r\":[],\"sh\":1,\"t\":67642},\
            {\"btn\":0,\"id\":5,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0}],\"sh\":1,\"t\":0},\     
            {\"btn\":0,\"id\":13,\"n\":0,\"p\":0,\"r\":[{\"aid\":1,\"s\":0},{\"aid\":2,\"s\":0},{\"aid\":3,\"s\":0},{\"aid\":4,\"s\":0},{\"aid\":5,\"s\":0}],\"sh\":1,\"t\":0},\      
            {\"btn\":1,\"id\":14,\"n\":1,\"p\":0,\"r\":[{\"aid\":1,\"s\":0,\"t\":0},{\"aid\":2,\"s\":0,\"t\":0},{\"aid\":3,\"s\":0,\"t\":0},{\"aid\":4,\"s\":0,\"t\":0},{\"aid\":5,\"s\":0,\"t\":0}],\"sh\":1,\"t\":67642}\    
        ],\
        \"o\":1\
    }";
    
    // 1- набор новичка, 2 - набор дяди славы, 3 - набор с бумером, 4 - стандарт новость, 5 - привязка, 13 - выгода каждый день, 14 - бонус за пополнение 
    JSON_Parse(param, json);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    ShowPlayerGUI(playerid, 116, json);
    JSON_Cleanup(json);

    return 1;
}

CMD:infostorm(playerid)
{
    SendClientMessage(playerid, -1, "========== STORM GUI TEST ==========");
    SendClientMessage(playerid, -1, "/stormmain - Главный экран Кубка Шторма");
    SendClientMessage(playerid, -1, "/stormrewards - Лента наград");
    SendClientMessage(playerid, -1, "/stormrewards_full - Лента с большим прогрессом");
    SendClientMessage(playerid, -1, "/stormcmd - Проверка cmd");
    return 1;
}

CMD:stormmain(playerid)
{
    new Node:json = JSON_Object();

    JSON_SetInt(json, "cmd", 0);

    JSON_SetInt(json, "cid", 529);
    JSON_SetInt(json, "sid", 1);

    JSON_SetInt(json, "xp", 2500);
    JSON_SetInt(json, "tc", 999);

    JSON_SetInt(json, "tm", 604800);

    JSON_SetInt(json, "m", 5500);

    JSON_SetInt(json, "tg", 67);
    JSON_SetInt(json, "rt", 30);
    JSON_SetInt(json, "tp", 16);

    ShowPlayerGUI(playerid, 123, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:stormrewards(playerid)
{
    new jsonStr[512];

    format(jsonStr, sizeof(jsonStr),
    "{\
        \"cmd\":2,\
        \"o\":1,\
        \"sid\":1,\
        \"rp\":3200,\
        \"tm\":604800,\
        \"r\":[\
            {\"leveld\":1,\"s\":2},\
            {\"leveld\":2,\"s\":2},\
            {\"leveld\":3,\"s\":2},\
            {\"leveld\":4,\"s\":1},\
            {\"leveld\":5,\"s\":0},\
            {\"leveld\":6,\"s\":0}\
        ]\
    }");

    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);

    ShowPlayerGUI(playerid, 123, json);

    JSON_Cleanup(json);
    return 1;
}

CMD:stormrewardsfull(playerid)
{
    new jsonStr[1024];

    format(jsonStr, sizeof(jsonStr),
    "{\
        \"cmd\":2,\
        \"o\":1,\
        \"sid\":1,\
        \"rp\":15000,\
        \"tm\":999999,\
        \"r\":[\
            {\"leveld\":1,\"s\":2},\
            {\"leveld\":2,\"s\":2},\
            {\"leveld\":3,\"s\":2},\
            {\"leveld\":4,\"s\":2},\
            {\"leveld\":5,\"s\":2},\
            {\"leveld\":6,\"s\":2},\
            {\"leveld\":7,\"s\":2},\
            {\"leveld\":8,\"s\":2},\
            {\"leveld\":9,\"s\":2},\
            {\"leveld\":10,\"s\":2}\
        ]\
    }");

    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);

    ShowPlayerGUI(playerid, 123, json);

    JSON_Cleanup(json);
    return 1;
}


CMD:stormcmd(playerid, params[])
{
    new cmd_num;

    if (sscanf(params, "i", cmd_num))
        return SendClientMessage(playerid, -1, "Использование: /storm_cmd [номер]");

    new Node:json = JSON_Object();
    JSON_SetInt(json, "cmd", cmd_num);
    ShowPlayerGUI(playerid, 123, json);
    JSON_Cleanup(json);
    
    return 1;
}

cmd:trunktest(playerid)
{
    new jsonStr[1024];
    format(jsonStr, sizeof(jsonStr), 
        "{\"o\":1,\"w\":99,\"mw\":100,\"sl\":31,\"tb\":0,\"bw\":2,\"cw\":200,\"sb\":20,\"nm\":6666,\"it\":[23,3,0,0,1061,5,1,0,0,130,1,2,0,0,125,1,3,0,0,794,1,4,0,0,1085,1,5,0,0],\"ai\":[363,1,0,0,0,877,1,2,0,0,134,6801,6,0,0],\"ic\":[58,528843,0,0,0,1061,21,1,0,0,59,\"derix - 77\",2,0,0]}"
    );
    
    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);
    ShowPlayerGUI(playerid, 34, json);
    JSON_Cleanup(json);
    
    return 1;
}

cmd:markett(playerid)
{
    new jsonStr[2048];
    format(jsonStr, sizeof(jsonStr), 
        "{\
            \"o\":1,\
            \"h\":0,\
            \"l\":0,\
            \"ls\":28,\
            \"m\":2100000000,\
            \"n\":[\
                {\"cs\":\"777666\",\"ct\":1,\"dm\":\"Бич пакет\",\"id\":1,\"md\":\"980\",\"rt\":4,\"ti\":207083,\"tp\":1},\             
                {\"cs\":\"1488\",\"ct\":1,\"dm\":\"Сталеен\",\"id\":2,\"md\":759,\"rt\":5,\"ti\":63574,\"tp\":1},\
                {\"cs\":\"75000000\",\"ct\":122,\"dm\":\"Фирменная одежда\",\"id\":3,\"md\":134,\"rt\":5,\"ti\":93874,\"tp\":1}\
            ]\
        }"
    );
    
    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);
    ShowPlayerGUI(playerid, 77, json);
    JSON_Cleanup(json); 
    return 1;
}

cmd:provoda(playerid)
{
    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "t", 1);
    JSON_SetInt(JSONObject, "i", 30);
    JSON_SetInt(JSONObject, "a", 0);
    
    ShowPlayerGUI(playerid, 7, JSONObject);
    return 1;
}

stock ShowTablet(playerid)
{
    new jsonStr[1024];
    
    format(jsonStr, sizeof(jsonStr), 
        "{\"a\":1,\"ac\":[{\"id\":24}],\"d\":{\"ar\":1,\"av\":1,\"bg\":1,\"exm\":%d,\"exp\":%d,\"fn\":\"%s\",\"lv\":%d,\"v\":2},\"n\":[{\"id\":25}],\"o\":1}",
        GetExpToNextLevel(playerid), GetPlayerExp(playerid), GetPlayerFamName(playerid), GetPlayerLevel(playerid)
    );
    
    //av - аватар, a- клик в планшете. 
    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);
    ShowPlayerGUI(playerid, 113, json);
    JSON_Cleanup(json);
    
    return 1;
}

CMD:waypoint(playerid, params[])
{
    new waypointid, Float:x, Float:y, Float:z, icon, value, Float:distance;
    
    if(sscanf(params, "dfffddf", waypointid, x, y, z, icon, value, distance))
    {
        SendClientMessage(playerid, -1, "Использование: /waypoint [айди] [x] [y] [z] [айди иконки] [значение] [дистанция]");
        SendClientMessage(playerid, -1, "Пример: /waypoint 1 5700.0 5300.0 40.0 85 27 7777.0");
        return 1;
    }
    
    CreateWayPoint(playerid, waypointid, x, y, z, icon, value, distance, 0);
    return 1;
}

stock ShowMusicGUI(playerid)
{
    new Node:json = JSON_Object();
    ShowPlayerGUI(playerid, 112, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:casesbanner(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 2);
    JSON_SetInt(json, "bid", 1);     

    ShowPlayerGUI(playerid, 73, json);
    return 1;
}

cmd:testtablet(playerid)
{
    new jsonStr[1024];
    format(jsonStr, sizeof(jsonStr), "{\"a\":100,\"ac\":[{\"id\":109},{\"id\":101},{\"id\":102},{\"id\":108}],\"d\":{\"ar\":1,\"av\":2,\"bg\":1,\"exm\":1488,\"exp\":67,\"f\":3,\"fnr\":2,\"Iv\":4,\"rp\":118,\"rpm\":888,\"v\":1},\"n\":[],\"o\":1}");
    
    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);
    ShowPlayerGUI(playerid, 113, json);
    JSON_Cleanup(json);
    
    return 1;
}

CMD:testgui(playerid, params[])
{
    new o, ci, ic, Float:pc[3], s, t, uid;
    
    if(sscanf(params, "iiif(1)f(-1)f(1)iii", o, ci, ic, pc[0], pc[1], pc[2], s, t, uid))
        return SendClientMessage(playerid, -1, "Использование: /testgui [o] [ci] [ic] [pc_x] [pc_y] [pc_z] [s] [t] [uid]");
    
    new jsonStr[512];
    format(jsonStr, sizeof(jsonStr), 
        "{\"o\":%d,\"ci\":%d,\"ic\":%d,\"pc\":[%f,%f,%f],\"s\":%d,\"t\":%d,\"uid\":%d}",
        o, ci, ic, pc[0], pc[1], pc[2], s, t, uid);
    
    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);
    OnPacketIncoming(playerid, 111, json);
    JSON_Cleanup(json);    
    return 1;
}