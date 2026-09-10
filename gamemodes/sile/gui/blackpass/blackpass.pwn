SendBlackPassMainTab(playerid)
{
    new Node:JSONObject = JSON_Object();
    
    JSON_SetInt(JSONObject, "t", -2);          // type = -2 (INIT)
    JSON_SetInt(JSONObject, "ty", -1);         // subtype
    JSON_SetInt(JSONObject, "la", -1);         // layout
    JSON_SetInt(JSONObject, "lc", 0);          // current layout (0 = Pass)
    JSON_SetString(JSONObject, "sn", "тест бист"); // seasonName
    JSON_SetString(JSONObject, "ln", "Danya top"); // leader name (top player)
    JSON_SetInt(JSONObject, "lv", 22);             // bpLevel
    JSON_SetInt(JSONObject, "m_lv", 777);            // maxBpLevel
    JSON_SetInt(JSONObject, "e", 67);                // valueOfExperience
    JSON_SetInt(JSONObject, "m_e", 1488);            // maxLevelExp
    
    JSON_SetInt(JSONObject, "td", 646);           // timerDaysAndHours
    
    JSON_SetInt(JSONObject, "sc", 0xFF6A0DAD);              // seasonColor (фиолетовый)
    JSON_SetInt(JSONObject, "a", 0);
    
    JSON_SetInt(JSONObject, "tm", 222);   // timer for tasks refresh
    JSON_SetInt(JSONObject, "wt", 3333); // weekly timer
    
    new Node:ratingArray = JSON_Array();
    
    for(new i = 1; i <= 10; i++)
    {   
        new name[24];
        format(name, sizeof(name), "danya_%d", i);

        new Node:playerRating = JSON_Object();
        JSON_SetString(playerRating, "n", name);     // name
        JSON_SetInt(playerRating, "och", i);     // score (очки)
        new Node:tempArray = JSON_Array(playerRating);
        ratingArray =JSON_Append(ratingArray, tempArray);
    }
    JSON_SetArray(JSONObject, "j", ratingArray);            // ratingList
    
    JSON_SetInt(JSONObject, "m", 52);
    JSON_SetInt(JSONObject, "p", 599);                      // premiumPrice
    JSON_SetInt(JSONObject, "pp", 1699);                    // premiumDeluxePrice
    
    JSON_SetInt(JSONObject, "sp", 0);                       // show split (0/1)
    JSON_SetInt(JSONObject, "is", 0);                       // is stock (0/1)
    JSON_SetInt(JSONObject, "cat", 1);

    SendPacketToClient(playerid, 22, JSONObject);

    JSON_Cleanup(JSONObject);
    return 1;
}


stock SendBlackPassInit(playerid)
{
    // Корневой JSON объект
    new Node:JSONObject = JSON_Object();
    
    JSON_SetInt(JSONObject, "t", -2);          // type = -2 (INIT)
    JSON_SetInt(JSONObject, "ty", -1);         // subtype
    JSON_SetInt(JSONObject, "la", -1);         // layout
    JSON_SetInt(JSONObject, "lc", 0);          // current layout (0 = Pass)
    JSON_SetString(JSONObject, "sn", "тест бист"); // seasonName
    JSON_SetString(JSONObject, "ln", "Danya top"); // leader name (top player)
    JSON_SetInt(JSONObject, "lv", 22);             // bpLevel
    JSON_SetInt(JSONObject, "m_lv", 777);            // maxBpLevel
    JSON_SetInt(JSONObject, "e", 67);                // valueOfExperience
    JSON_SetInt(JSONObject, "m_e", 1488);            // maxLevelExp
    
    JSON_SetInt(JSONObject, "td", 646);           // timerDaysAndHours
    
    JSON_SetInt(JSONObject, "sc", 0xFF6A0DAD);              // seasonColor (фиолетовый)
    JSON_SetInt(JSONObject, "a", 0);
    
    JSON_SetInt(JSONObject, "tm", 222);   // timer for tasks refresh
    JSON_SetInt(JSONObject, "wt", 3333); // weekly timer
    
    new Node:ratingArray = JSON_Array();
    
    for(new i = 1; i <= 10; i++)
    {   
        new name[24];
        format(name, sizeof(name), "danya_%d", i);

        new Node:playerRating = JSON_Object();
        JSON_SetString(playerRating, "n", name);     // name
        JSON_SetInt(playerRating, "och", i);     // score (очки)
        new Node:tempArray = JSON_Array(playerRating);
        ratingArray = JSON_Append(ratingArray, tempArray);
    }
    JSON_SetArray(JSONObject, "j", ratingArray);            // ratingList
    
    JSON_SetInt(JSONObject, "m", 52);
    JSON_SetInt(JSONObject, "p", 599);                      // premiumPrice
    JSON_SetInt(JSONObject, "pp", 1699);                    // premiumDeluxePrice
    
    JSON_SetInt(JSONObject, "sp", 0);                       // show split (0/1)
    JSON_SetInt(JSONObject, "is", 0);                       // is stock (0/1)
    JSON_SetInt(JSONObject, "cat", 1);

    SendPacketToClient(playerid, 22, JSONObject);

    JSON_Cleanup(JSONObject);
    return 1;
}