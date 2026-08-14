stock ShowTabletGUI(playerid)
{
	new f = GetPlayerIdFamily(playerid);
    new Node:json = JSON_Object();

    JSON_SetInt(json, "a", 1);
    JSON_SetInt(json, "f", 2);
    JSON_SetInt(json, "o", 1);

    new Node:acArray = JSON_Array();
    new Node:acItem = JSON_Object("id", JSON_Int(24));
    JSON_Append(acArray, acItem);
    JSON_SetArray(json, "ac", acArray);

    new Node:nArray = JSON_Array();
    new Node:nItem = JSON_Object("id", JSON_Int(3));
    JSON_Append(nArray, nItem);
    JSON_SetArray(json, "n", nArray);
  
    new Node:dObject = JSON_Object();
    JSON_SetInt(dObject, "ar", GetPlayerData(playerid, P_PREMIUM) + 1);
    JSON_SetInt(dObject, "av", 15);
    JSON_SetInt(dObject, "bg", 9);
    JSON_SetInt(dObject, "exm", GetExpToNextLevel(playerid));
    JSON_SetInt(dObject, "exp", GetPlayerExp(playerid));
    if(f != -1)
    {
        JSON_SetString(dObject, "fn", GetFamily(f, family_name));
    }
    else
    {
        JSON_SetString(dObject, "fn", "Отсутствует");
    }
    JSON_SetInt(dObject, "lv", GetPlayerLevel(playerid));
    JSON_SetInt(dObject, "v", GetPlayerData(playerid, P_PREMIUM));
    JSON_SetObject(json, "d", dObject);
    
    new strdb[512];
    JSON_Stringify(json, strdb, sizeof(strdb));
    printf("tablet debug: %s", strdb);
    ShowPlayerGUI(playerid, 113, json);
	JSON_Cleanup(json, true);
    
    return 1;
}

stock GetTimeStringChas(unixtime)
{
    new output[512];
    new minutes = ConvertUnixTime(unixtime, CONVERT_TIME_TO_MINUTES);
    
    format(output, sizeof(output), "%dм", minutes);
    return output;
}

stock GetTimeString(unixtime, output[], size = sizeof(output))
{
    new hours = ConvertUnixTime(unixtime, CONVERT_TIME_TO_HOURS);
    new minutes = ConvertUnixTime(unixtime, CONVERT_TIME_TO_MINUTES);
    format(output, size, "%dч %dм", hours, minutes);
}

stock GetIntString(value, output[], size = sizeof(output))
{
    format(output, size, "%d", value);
}

stock GetVIPText(vip_level)
{
    new vip_text[32];
    switch(vip_level)
    {
        case 1: vip_text = "Bronze";
        case 2: vip_text = "Silver";
        case 3: vip_text = "Platinum";
        default: vip_text = "Отсутствует";
    }
    return vip_text;
}

stock GetSexText(sex)
{
    new sex_text[32];
    if(sex == 0)
        sex_text = "Мужской";
    else
        sex_text = "Женский";
    return sex_text;
}

stock GetTabletJobName(playerid)
{
    new job_name[64];
    format(job_name, sizeof(job_name), "%s", GetPlayerOfficialJobName(playerid));
    return job_name;
}

stock GetTabletRankName(playerid)
{
    new rank_name[64];
    format(rank_name, sizeof(rank_name), "%s", GetPlayerRankName(playerid));
    return rank_name;
}

stock GetTabletHouseName(playerid)
{
    new hm[64];
    format(hm, sizeof(hm), "%s", GetPlayerHouseName(playerid));
    return hm;
}

stock GetTabletFuelStationName(playerid)
{
    new hm[64];
    format(hm, sizeof(hm), "%s", GetPlayerFuelStationName(playerid));
    return hm;
}

stock GetTabletBusinessName(playerid)
{
    new hm[64];
    format(hm, sizeof(hm), "%s", GetPlayerBizName(playerid));
    return hm;
}

stock SendPlayerProfile113(playerid)
{
    new Node:json = JSON_Object(), f = GetPlayerIdFamily(playerid);
    
    JSON_SetInt(json, "a", 4);
    JSON_SetInt(json, "o", 1);
    
    new Node:dObject = JSON_Object();
    JSON_SetInt(dObject, "ar", GetPlayerData(playerid, P_PREMIUM) + 1);
    JSON_SetInt(dObject, "av", 15);
    JSON_SetInt(dObject, "bg", 9);
    JSON_SetInt(dObject, "exm", GetExpToNextLevel(playerid));
    JSON_SetInt(dObject, "exp", GetPlayerExp(playerid));
    JSON_SetString(dObject, "fn", GetFamily(f, family_name));
    JSON_SetInt(dObject, "lv", GetPlayerLevel(playerid));
    JSON_SetInt(dObject, "v", GetPlayerData(playerid, P_PREMIUM));
    JSON_SetObject(json, "d", dObject);
    
    new temp_str[64];
    
    new Node:list = JSON_Array(
        JSON_Object(
            "n", JSON_String("ID аккаунта"),
            "t", JSON_Int(1),
            "v", JSON_String((GetIntString(GetPlayerAccountID(playerid), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("ic_crown.png"),
            "n", JSON_String("VIP-статус"),
            "t", JSON_Int(1),
            "v", JSON_String(GetVIPText(GetPlayerData(playerid, P_PREMIUM)))
        ),
        JSON_Object(
            "i", JSON_String("ic_gender.png"),
            "n", JSON_String("Пол"),
            "v", JSON_String(GetSexText(GetPlayerData(playerid, P_SEX)))
        ),
        JSON_Object(
            "i", JSON_String("bi_phone.png"),
            "n", JSON_String("Номер телефона"),
            "v", JSON_String((GetIntString(GetPlayerPhone(playerid), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("bi_phone.png"),
            "n", JSON_String("На счету телефона"),
            "v", JSON_String((GetIntString(GetPlayerData(playerid, P_PHONE_BALANCE), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("ic_mace.png"),
            "n", JSON_String("Законопослушность"),
            "v", JSON_String((GetIntString(GetPlayerData(playerid, P_LAW_ABIDING), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("ic_star.png"),
            "n", JSON_String("Уровень розыска"),
            "v", JSON_String((GetIntString(GetPlayerSuspect(playerid), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("ic_status.png"),
            "n", JSON_String("Игровой статус"),
            "v", JSON_String(GetPlayerGameStatus(playerid))
        ),
        JSON_Object(
            "i", JSON_String("ic_skill.png"),
            "n", JSON_String("Уровень улучшений"),
            "v", JSON_String((GetIntString(GetPlayerData(playerid, P_IMPROVEMENTS), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("ic_progress.png"),
            "n", JSON_String("Материалы"),
            "v", JSON_String((GetIntString(GetPlayerData(playerid, P_METALL), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("ic_timer.png"),
            "n", JSON_String("Время за час"),
            "v", JSON_String(GetTimeStringChas(GetPlayerData(playerid, P_GAME_FOR_HOUR)))
        ),
        JSON_Object(
            "i", JSON_String("ic_timer.png"),
            "n", JSON_String("Время за сегодня"),
            "v", JSON_String((GetTimeString(GetPlayerData(playerid, P_GAME_FOR_DAY), temp_str), temp_str))
        ),
        JSON_Object(
            "i", JSON_String("ic_timer.png"),
            "n", JSON_String("Время за вчера"),
            "v", JSON_String((GetTimeString(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), temp_str), temp_str))
        ),
        JSON_Object(
             "i", JSON_String("ic_works.png"),
        	 "n", JSON_String("Работа"),
        	 "v", JSON_String(GetTabletJobName(playerid))
        ),
        JSON_Object(
             "i", JSON_String("ic_star.png"),
        	 "n", JSON_String("Должность"),
        	 "v", JSON_String(GetTabletRankName(playerid))
        ),
        JSON_Object(
             "i", JSON_String("ic_round_home.png"),
        	 "n", JSON_String("Проживание"),
        	 "v", JSON_String(GetTabletHouseName(playerid))
        ),
        JSON_Object(
             "i", JSON_String("ic_gas_stations.png"),
        	 "n", JSON_String("Заправка"),
        	 "v", JSON_String(GetTabletFuelStationName(playerid))
        ),
        JSON_Object(
             "i", JSON_String("ic_status.png"),
        	 "n", JSON_String("Бизнес"),
        	 "v", JSON_String(GetTabletBusinessName(playerid))
        )
    );
    
    JSON_SetArray(json, "p", list);
    
    new strdb[512];
    JSON_Stringify(json, strdb, sizeof(strdb));
    printf("tablet debug: %s", strdb);
    SendPacketToClient(playerid, 113, json);
    JSON_Cleanup(json, true);
}
/*
stock SendPlayerProfile113(playerid)
{
    new f = GetPlayerIdFamily(playerid);
    
    new vp[32];
    new pl = GetPlayerData(playerid, P_PREMIUM);
    switch(pl)
    {
        case 1: vp = "Bronze";
        case 2: vp = "Silver";
        case 3: vp = "Platinum";
        default: vp = "Отсутствует";
    }
    
    new sex[32];
    if(GetPlayerData(playerid, P_SEX) == 0)
	{
		sex = "Мужской";
	}
	else
	{
		sex = "Женский";
	}
	new fmt_accid[512];
	format(fmt_accid, sizeof(fmt_accid), "%d", GetPlayerAccountID(playerid));
	
	new fmt_np[512];
	format(fmt_np, sizeof(fmt_np), "%d", GetPlayerPhone(playerid));
	
	new fmt_bp[512];
	format(fmt_bp, sizeof(fmt_bp), "%d", GetPlayerData(playerid, P_PHONE_BALANCE));
	
	new fmt_zp[512];
	format(fmt_zp, sizeof(fmt_zp), "%d", GetPlayerData(playerid, P_LAW_ABIDING));
	
	new fmt_ur[512];
	format(fmt_ur, sizeof(fmt_ur), "%d", GetPlayerSuspect(playerid));
	
	new fmt_uu[512];
	format(fmt_uu, sizeof(fmt_uu), "%d", GetPlayerData(playerid, P_IMPROVEMENTS));
	
	new fmt_m[512];
	format(fmt_m, sizeof(fmt_m), "%d", GetPlayerData(playerid, P_METALL));
	
	new fmt_tch[512];
	format(fmt_tch, sizeof(fmt_tch), "%dм", ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_HOUR), CONVERT_TIME_TO_MINUTES));
	
	new fmt_zs[512];
	format(fmt_zs, sizeof(fmt_zs), "%dч %d", ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_HOURS), ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_MINUTES));
	
	new fmt_zv[512];
	format(fmt_zv, sizeof(fmt_zv), "%dч %d", ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_HOURS), ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_MINUTES));
	
	new fmt_j[512];
	format(fmt_j, sizeof(fmt_j), "%s", GetPlayerOfficialJobName(playerid));
	
	new fmt_r[512];
	format(fmt_r, sizeof(fmt_r), "%s", GetPlayerRankName(playerid));
	
	new fmt_h[512];
	format(fmt_h, sizeof(fmt_h), "%s", GetPlayerHouseName(playerid));
	
	new fmt_f[512];
	format(fmt_f, sizeof(fmt_f), "%s", GetPlayerFuelStationName(playerid));
	
	new fmt_b[512];
	format(fmt_b, sizeof(fmt_b), "%s", GetPlayerBizName(playerid));
	
	new Node:json = JSON_Object();
	
	JSON_SetInt(json, "a", 4);
    JSON_SetInt(json, "o", 1);
    
    new Node:dObject = JSON_Object();
    JSON_SetInt(dObject, "ar", GetPlayerData(playerid, P_PREMIUM) + 1);
    JSON_SetInt(dObject, "av", 15);
    JSON_SetInt(dObject, "bg", 9);
    JSON_SetInt(dObject, "exm", GetExpToNextLevel(playerid));
    JSON_SetInt(dObject, "exp", GetPlayerExp(playerid));
    JSON_SetString(dObject, "fn", GetFamily(f, family_name));
    JSON_SetInt(dObject, "lv", GetPlayerLevel(playerid));
    JSON_SetInt(dObject, "v", GetPlayerData(playerid, P_PREMIUM));
    JSON_SetObject(json, "d", dObject); 
    
    new Node:list = JSON_Array(
        JSON_Object(
            "n", JSON_String("ID аккаунта"),
        	 "t", JSON_Int(1),
        	 "v", JSON_String(fmt_accid)
        ),
        JSON_Object(
            "i", JSON_String("ic_crown.png"),
        	 "n", JSON_String("VIP-статус"),
    	     "t", JSON_Int(1),
	         "v", JSON_String(vp)
        ),
        JSON_Object(
             "i", JSON_String("ic_gender.png"),
        	 "n", JSON_String("Пол"),
        	 "v", JSON_String(sex)
        ),
        JSON_Object(
             "i", JSON_String("bi_phone.png"),
        	 "n", JSON_String("Номер телефона"),
        	 "v", JSON_String(fmt_np)
        ),
        JSON_Object(
             "i", JSON_String("bi_phone.png"),
        	 "n", JSON_String("На счету телефона"),
        	 "v", JSON_String(fmt_bp)
        ),
        JSON_Object(
             "i", JSON_String("ic_law.png"),
        	 "n", JSON_String("Законопослушность"),
        	 "v", JSON_String(fmt_zp)
        ),
        JSON_Object(
             "i", JSON_String("ic_star.png"),
        	 "n", JSON_String("Уровень розыска"),
        	 "v", JSON_String(fmt_ur)
        ),
        JSON_Object(
             "i", JSON_String("ic_status.png"),
        	 "n", JSON_String("Игровой статус"),
        	 "v", JSON_String(GetPlayerGameStatus(playerid))
        ),
        JSON_Object(
             "i", JSON_String("ic_skill.png"),
        	 "n", JSON_String("Уровень улучшений"),
        	 "v", JSON_String(fmt_uu)
        ),
        JSON_Object(
             "i", JSON_String("ic_craft.png"),
        	 "n", JSON_String("Материалы"),
        	 "v", JSON_String(fmt_m)
        ),
        JSON_Object(
             "i", JSON_String("ic_time.png"),
        	 "n", JSON_String("Время за час"),
        	 "v", JSON_String(fmt_tch)
        ),
        JSON_Object(
             "i", JSON_String("ic_time.png"),
        	 "n", JSON_String("Время за сегодня"),
        	 "v", JSON_String(fmt_zs)
        ),
        JSON_Object(
             "i", JSON_String("ic_time.png"),
        	 "n", JSON_String("Время за вчера"),
        	 "v", JSON_String(fmt_zv)
        ),
        JSON_Object(
             "i", JSON_String("ic_job.png"),
        	 "n", JSON_String("Работа"),
        	 "v", JSON_String(fmt_j)
        ),
        JSON_Object(
             "i", JSON_String("ic_rank.png"),
        	 "n", JSON_String("Должность"),
        	 "v", JSON_String(fmt_r)
        ),
        JSON_Object(
             "i", JSON_String("ic_home.png"),
        	 "n", JSON_String("Проживание"),
        	 "v", JSON_String(fmt_h)
        ),
        JSON_Object(
             "i", JSON_String("ic_fuel.png"),
        	 "n", JSON_String("Заправка"),
        	 "v", JSON_String(fmt_f)
        ),
        JSON_Object(
             "i", JSON_String("ic_business.png"),
        	 "n", JSON_String("Бизнес"),
        	 "v", JSON_String(fmt_b)
        )
    );
    JSON_SetArray(json, "p", list);

    SendPacketToClient(playerid, 113, json);
    JSON_Cleanup(json, true);
}*/

stock SendTabletInfoList113(playerid)
{
    new Node:list = JSON_Array(
        JSON_Object(
            "id",  JSON_Int(1),
            "nm",  JSON_String("Parasha ebanaya"),
            "nn",  JSON_String("Danya_Coder"),
            "dsc", JSON_String("Need passport 3y, license B, weapon license, med card"),
            "tm",  JSON_Object(
                "dt", JSON_String("8 march 2026"),
                "h",  JSON_Int(14),
                "m",  JSON_Int(40)
            )
        ),
        JSON_Object(
            "id",  JSON_Int(2),
            "nm",  JSON_String("Army Recruitment"),
            "nn",  JSON_String("Grigoriy_Leps"),
            "dsc", JSON_String("Need med card, license pack, clean look, passport 3y"),
            "tm",  JSON_Object(
                "dt", JSON_String("09 March 2026"),
                "h",  JSON_Int(14),
                "m",  JSON_Int(25)
            )
        )
    );

    new Node:json = JSON_Object(
        "a", JSON_Int(5),
        "o", JSON_Int(1),
        "d", list
    );

    SendPacketToClient(playerid, 113, json);
    JSON_Cleanup(json);
}

stock SendTabletNotificationList113(playerid)
{
    new Node:list = JSON_Array(
        JSON_Object(
            "d",  JSON_String("17 March 2026"),
            "id", JSON_Int(1),
            "n",  JSON_String("Test bistik"),
            "t",  JSON_String("Subscription Telegram channel @studio_bist")
        ),
        JSON_Object(
            "d",  JSON_String("None"),
            "id", JSON_Int(2),
            "n",  JSON_String("Lildrug"),
            "t",  JSON_String("Subscription Telegram channel https://t.me/+6EIdaplWqHJlZDAy")
        )
    );

    new Node:json = JSON_Object(
        "a", JSON_Int(3), 
        "d", list,
        "l", JSON_Int(1),
        "o", JSON_Int(1),
        "r", JSON_Int(0),
        "s", JSON_Int(2),
        "w", JSON_Int(2)
    );

    SendPacketToClient(playerid, 113, json);
    JSON_Cleanup(json);
}

stock TabletHandlePacket(playerid, Node:JSONObject)
        {
            new a = -1, o = -1, t = -1, c = -1;

            if (JSON_GetType(JSONObject, "c") == JSON_NODE_NUMBER)
            {
                JSON_GetInt(JSONObject, "c", c);
                if (c == 1)
                {
                    printf("[IPacket:252][GUI113] close packet from %s[%d]",
                           GetPlayerNameEx(playerid), playerid);
                }
            }

            if (c != 1)
            {
                if (JSON_GetType(JSONObject, "a") != JSON_NODE_NUMBER)
                {
                    printf("[IPacket:252][GUI113] packet without numeric a");
                }
                else
                {
                    JSON_GetInt(JSONObject, "a", a);

                    if (JSON_GetType(JSONObject, "o") == JSON_NODE_NUMBER)
                    {
                        JSON_GetInt(JSONObject, "o", o);
                    }

                    if (JSON_GetType(JSONObject, "t") == JSON_NODE_NUMBER)
                    {
                        JSON_GetInt(JSONObject, "t", t);
                    }
                    
                    if (a == 1 && o == 1)
                    {
                        ShowTabletGUI(playerid);
                    }
                    if (a == 2 && o == 1)
                    {
                        if(t == 2)
                        {
                            new id, s;
                            JSON_GetInt(JSONObject, "id", id);
                            JSON_GetInt(JSONObject, "status", s);

                            printf("a: %d, id: %d, s: %d, t: %d", a, id, s, t);

                            new Node:json = JSON_Object();

                            JSON_SetInt(json, "a", a);
                            JSON_SetInt(json, "t", t);
                            JSON_SetInt(json, "id", id);
                            JSON_SetInt(json, "status", s);

                            SendPacketToClient(playerid, 113, json);
                        }
                        else if(t == 3)
                        {
                            new id, s;
                            JSON_GetInt(JSONObject, "id", id);
                            JSON_GetInt(JSONObject, "status", s);

                            printf("a: %d, id: %d, s: %d, t: %d", a, id, s, t);

                            new Node:json = JSON_Object();

                            JSON_SetInt(json, "a", a);
                            JSON_SetInt(json, "t", t);
                            JSON_SetInt(json, "id", id);
                            JSON_SetInt(json, "status", s);

                            SendPacketToClient(playerid, 113, json);
                        }
                        else if(t == 4)
                        {
                            new id, s;
                            JSON_GetInt(JSONObject, "id", id);
                            JSON_GetInt(JSONObject, "status", s);

                            printf("a: %d, id: %d, s: %d, t: %d", a, id, s, t);

                            new Node:json = JSON_Object();

                            JSON_SetInt(json, "a", a);
                            JSON_SetInt(json, "t", t);
                            JSON_SetInt(json, "id", id);
                            JSON_SetInt(json, "status", s);

                            SendPacketToClient(playerid, 113, json);
                        }
                        else
                        {
                            new Node:json = JSON_Object();
                            JSON_SetInt(json, "a", 2);
                            JSON_SetInt(json, "o", 1);
                                
                            new Node:dObject = JSON_Object();
                            JSON_SetInt(dObject, "id", 1);
                            JSON_SetInt(dObject, "av", 15);
                            JSON_SetInt(dObject, "bg", 9);
                                
                            new Node:pnObject = JSON_Object();
                            JSON_SetInt(pnObject, "s", 1);
                            JSON_SetInt(pnObject, "v1", 1);
                            JSON_SetInt(pnObject, "v2", 0);
                            JSON_SetInt(pnObject, "v3", 0);
                            JSON_SetInt(pnObject, "tg", 1);
                            JSON_SetInt(pnObject, "vk", 1);
                                
                            new Node:styleObject = JSON_Object();
                            JSON_SetString(styleObject, "ar", "");
                            JSON_SetObject(pnObject, "style", styleObject);
                                
                            JSON_SetObject(dObject, "pn", pnObject);
                            JSON_SetObject(json, "d", dObject);
                                
                            new debugStr[1024];
                            JSON_Stringify(json, debugStr, sizeof(debugStr));
                            printf("[DEBUG] Test 3: %s", debugStr);
                                
                            SendPacketToClient(playerid, 113, json);
                        }
                    }

                    //a 2 id 15 status 1 t 2
                   // a 2 id 8 status 1 t 3
                    //a 2 id 2 status 1 t 4 

                    /*if (a == 2 && o == 1)
                    {
                        new Node:json = JSON_Object();
                        JSON_SetInt(json, "a", 2);
                        JSON_SetInt(json, "o", 1);

                        // ---- d[0] ----
                        new Node:dItem = JSON_Object();

                        // secur
                        new Node:securObject = JSON_Object();
                        JSON_SetInt(securObject, "ds", 0);
                        JSON_SetInt(securObject, "em", 0);

                        new Node:glObject = JSON_Object();
                        JSON_SetInt(glObject, "ask_code", 0);
                        JSON_SetInt(glObject, "ask_ip", 0);
                        JSON_SetInt(glObject, "linked", 0);
                        JSON_SetObject(securObject, "gl", glObject);

                        new Node:pnObject = JSON_Object();
                        JSON_SetInt(pnObject, "s", 1);
                        JSON_SetInt(pnObject, "v1", 1);
                        JSON_SetInt(pnObject, "v2", 0);
                        JSON_SetInt(pnObject, "v3", 0);
                        JSON_SetInt(pnObject, "tg", 0);
                        JSON_SetInt(pnObject, "vk", 0);
                        JSON_SetObject(securObject, "pn", pnObject);

                        JSON_SetObject(dItem, "secur", securObject);

                        // style
                        new Node:styleObject = JSON_Object();

                        new Node:arObject = JSON_Object();
                        JSON_SetInt(arObject, "id", 1);
                        JSON_SetArray(arObject, "oth", JSON_Array());
                        JSON_SetObject(styleObject, "ar", arObject);

                        new Node:avObject = JSON_Object();
                        JSON_SetInt(avObject, "id", 2);
                        JSON_SetArray(avObject, "oth", JSON_Array());
                        JSON_SetObject(styleObject, "av", avObject);

                        new Node:bgObject = JSON_Object();
                        JSON_SetInt(bgObject, "id", 1);
                        JSON_SetArray(bgObject, "oth", JSON_Array());
                        JSON_SetObject(styleObject, "bg", bgObject);

                        JSON_SetObject(dItem, "style", styleObject);

                        JSON_SetInt(dItem, "b", 1);

                        // pers[]
                        JSON_SetArray(dItem, "pers", JSON_Array());

                        new persIds[7]  = { 4, 5, 6, 105, 106, 107, 108 };
                        new persVals[7] = { 1, 1, 1, 0,   0,   0,   0   };

                        for (new i = 0; i < 7; i++)
                        {
                            new Node:persItem = JSON_Object();
                            JSON_SetInt(persItem, "id", persIds[i]);
                            JSON_SetInt(persItem, "s", persVals[i]);
                            JSON_ArrayAppend(dItem, "pers", persItem);
                        }

                        JSON_SetInt(dItem, "stm", 0);
                        JSON_SetInt(dItem, "strmt", 0);

                        // stream[]
                        JSON_SetArray(dItem, "stream", JSON_Array());

                        new streamIds[4] = { 101, 102, 103, 104 };

                        for (new i = 0; i < 4; i++)
                        {
                            new Node:streamItem = JSON_Object();
                            JSON_SetInt(streamItem, "id", streamIds[i]);
                            JSON_SetInt(streamItem, "s", 0);
                            JSON_ArrayAppend(dItem, "stream", streamItem);
                        }

                        // ---- d = [ dItem ] ----
                        JSON_SetArray(json, "d", JSON_Array());
                        JSON_ArrayAppend(json, "d", dItem);

                        new debugStr[1024];
                        JSON_Stringify(json, debugStr, sizeof(debugStr));
                        printf("[DEBUG] Test 3: %s", debugStr);

                        SendPacketToClient(playerid, 113, json);
                    }*/
                    if (a == 3 && o == 1)
                    {
                        SendTabletNotificationList113(playerid);
                    }
                    if (a == 4 && o == 1)
                    {
                        SendPlayerProfile113(playerid);
                    }
                    if (a == 5 && o == 1)
                    {
                   	    SendTabletInfoList113(playerid);
                    }
                    if (a == 6 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 7 && o == 1)
                    {
                        callcmd::gps(playerid, "");
                    }
                    if (a == 8 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 9 && o == 1)
                    {
                        callcmd::mm(playerid, "");
                    }
                    if (a == 10 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 11 && o == 1)
                    {
                        callcmd::inv(playerid, "");
                    }
                    if (a == 12 && o == 1)
                    {
                        callcmd::anim(playerid, "");
                    }
                    if (a == 13 && o == 1)
                    {
                        callcmd::donate(playerid, "");
                    }
                    if (a == 14 && o == 1)
                    {
                        callcmd::car(playerid, "");
                    }
                    if (a == 15 && o == 1)
                    {
                        callcmd::promo(playerid, "");
                    }
                    if (a == 16 && o == 1)
                    {
                        callcmd::report(playerid, "");
                    }
                    if (a == 17 && o == 1)
                    {
                        callcmd::family(playerid, "");
                    }
                    if (a == 18 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 19 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 20 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 21 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 22 && o == 1)
                    {
                        callcmd::reward(playerid, "");
                    }
                    if (a == 23 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 24 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 25 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "В разработке!", "");
                    }
                    if (a == 26 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a26 o1", "");
                    }
                    if (a == 27 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a27 o1", "");
                    }
                    if (a == 28 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a28 o1", "");
                    }
                    if (a == 29 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a29 o1", "");
                    }
                    if (a == 30 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a30 o1", "");
                    }
                    if (a == 31 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a31 o1", "");
                    }
                    if (a == 32 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a32 o1", "");
                    }
                    if (a == 33 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a33 o1", "");
                    }
                    if (a == 34 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a34 o1", "");
                    }
                    if (a == 35 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a35 o1", "");
                    }
                    if (a == 36 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a36 o1", "");
                    }
                    if (a == 37 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a37 o1", "");
                    }
                    if (a == 38 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a38 o1", "");
                    }
                    if (a == 39 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a39 o1", "");
                    }
                    if (a == 40 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a40 o1", "");
                    }
                    if (a == 41 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a41 o1", "");
                    }
                    if (a == 42 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a42 o1", "");
                    }
                    if (a == 43 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a43 o1", "");
                    }
                    if (a == 44 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a44 o1", "");
                    }
                    if (a == 45 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a45 o1", "");
                    }
                    if (a == 46 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a46 o1", "");
                    }
                    if (a == 47 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a47 o1", "");
                    }
                    if (a == 48 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a48 o1", "");
                    }
                    if (a == 49 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a49 o1", "");
                    }
                    if (a == 50 && o == 1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "case a50 o1", "");
                    }
                }
            }
        }
