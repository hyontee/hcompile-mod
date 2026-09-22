//>> Файл: bykranin_src/core/inventory/inventory_10.inc  (502 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: GetCaseBonusesCount, GetCaseBonusNumeric, GetCaseBonusName, explode, split, GetCaseBonusForIndex, GiveCaseSkills
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
new CaseBonusesCount[CASE_BONUS_COUNT] = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5};

stock GetCaseBonusesCount(caseIndex)
{
    if (caseIndex < 0 || caseIndex >= CASE_BONUS_COUNT) return 0;
    caseIndex = ResolveCaseDataIndex(caseIndex);
    return CaseBonusesCount[caseIndex];
}

stock GetCaseBonusNumeric(caseIndex, itemIndex, field)
{
    if (caseIndex < 0 || caseIndex >= CASE_BONUS_COUNT) return -1;
    if (itemIndex < 0 || itemIndex >= MAX_CASE_BONUS_ITEMS) return -1;
    if (field < 0 || field >= 7) return -1;
    caseIndex = ResolveCaseDataIndex(caseIndex);
    return CaseBonusesNum[caseIndex][itemIndex][field];
}

stock GetCaseBonusName(dest[], destlen, caseIndex, itemIndex)
{
    if (destlen <= 0) return 0;
    if (caseIndex < 0 || caseIndex >= CASE_BONUS_COUNT) { dest[0]=0; return 0; }
    if (itemIndex < 0 || itemIndex >= MAX_CASE_BONUS_ITEMS) { dest[0]=0; return 0; }
    caseIndex = ResolveCaseDataIndex(caseIndex);
    format(dest, destlen, "%s", CaseBonusNames[caseIndex][itemIndex]);
    return strlen(dest);
}

stock explode(dest[][], const source[], delimiter = ',', size = sizeof(dest))
{
    new idx = 0, len = strlen(source), start = 0;
    for (new i = 0; i <= len && idx < size; i++)
    {
        if (source[i] == delimiter || source[i] == '\0')
        {
            strmid(dest[idx], source, start, i, 32);
            idx++;
            start = i + 1;
        }
    }
    return idx;
}

stock split(const source[], dest[], part, delimiter = '|')
{
    new len = strlen(source), start = 0, current = 0;
    for (new i = 0; i <= len; i++)
    {
        if (source[i] == delimiter || source[i] == '\0')
        {
            if (current == part)
            {
                strmid(dest, source, start, i, 256);
                return 1;
            }
            current++;
            start = i + 1;
        }
    }
    dest[0] = '\0';
    return 0;
}




stock GetCaseBonusForIndex(const str[], index, output[], output_size)
{
    output[0] = '\0';
    new tmp[256];
    new idx = 0; // 0-based
    new pos = 0;
    new len = strlen(str);

    for (new i = 0; i <= len; i++)
    {
        if (i == len || str[i] == '|')
        {
            tmp[pos] = '\0';
            if (idx == index)
            {
                format(output, output_size, "%s", tmp);
                return 1;
            }
            pos = 0;
            idx++;
        }
					else if (pos < sizeof(tmp)-1)
        {
            tmp[pos++] = str[i];
        }
    }
    return 0;
}

stock GiveCaseSkills(playerid, const jsonStr[], case_id)
{
    printf("[DEBUG] GiveCaseSkills: playerid=%d, case_id=%d", playerid, case_id);
    printf("[DEBUG] raw jsonStr = %s", jsonStr);

    // --- ищем массив bt2 ---
    new start = strfind(jsonStr, "\"bt2\":[");
    if (start == -1)
    {
        printf("[DEBUG] bt2 не найден в строке");
        return 0;
    }

    start += 7; // пропускаем "bt2":[
    new end = start;

    while (jsonStr[end] && jsonStr[end] != ']')
        end++;

    if (jsonStr[end] != ']')
    {
        printf("[DEBUG] не найдена закрывающая скобка ]");
        return 0;
    }

    // вырезаем подстроку bt2
    new bt2Str[512];
    strmid(bt2Str, jsonStr, start, end, sizeof(bt2Str));
    printf("[DEBUG] bt2Str = '%s'", bt2Str);

    // парсим числа
    new items[64];
    new item_count = 0;
    new num = 0, innum = 0;

    for (new i = 0; i < strlen(bt2Str); i++)
    {
        new ch = bt2Str[i];
        if (ch >= '0' && ch <= '9')
        {
            num = num * 10 + (ch - '0');
            innum = 1;
        }
					else if (innum)
        {
            if (item_count < sizeof(items))
                items[item_count++] = num;

            num = 0;
            innum = 0;
        }
    }

    if (innum && item_count < sizeof(items))
        items[item_count++] = num;

    printf("[DEBUG] найдено %d элементов в bt2", item_count);
    for (new i = 0; i < item_count; i++)
        printf("[DEBUG] item[%d] = %d", i, items[i]);

    // --- обработка скиллов ---
    for (new i = 0; i < item_count; i++)
    {
        new item = items[i];
        new addSkill = 0;

        if (case_id >= 1 && case_id <= CASE_COUNT)
        {
            if (item >= 1 && item <= MAX_CASE_ITEMS)
            {
                addSkill = GetCaseItemNumeric(case_id - 1, item - 1, CA_PRICESPRAYED);
            }
        }

        if (addSkill > 0)
        {
            AddPlayerData(playerid, P_SKILL_MICRO_UZI, +, addSkill);
			UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
            printf("[CASE] Player %d получил +%d Micro Uzi skill (item %d, case %d)", playerid, addSkill, item, case_id);
			new skill = GetPlayerData(playerid, P_SKILL_MICRO_UZI);
            new addCases = skill / 2000;
            
            // Считаем остаток
            new remainder = skill % 2000;
            if (addCases > 0)
            {
                AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, addCases);
                SetPlayerData(playerid, P_SKILL_MICRO_UZI, remainder);
				UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
				UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
                printf("[CASE] Player %d получил +%d кейсов, остаток %d", playerid, addCases, remainder);
            }

        }
    }

    return 1;
}



stock OpenCase(playerid, case_id)
{    
new case_sizes[] = {
    20, // case 1
    28, // case 2
    36, // case 3
    31, // case 4
    20, // case 5
    25, // case 6
    24, // case 7
    25, // case 8
    25, // case 9
    25, // case 10
    25, // case 11
    25, // case 12
    25, // case 13
    25, // case 14
    25, // case 15
    25, // case 16
    25, // case 17
    25, // case 18
    25, // case 19
    25, // case 20
    25, // case 21
    25, // case 22
    25, // case 23
    25,  // case 24 (пустой)
    25, // case 25 (АВТО-КЕЙС 3.0)
    6,  // case 26 (КЕЙС С БИЛЕТАМИ ГОНЩИКА)
    53, // case 27 (АВТО-КЕЙС B-C CLASS)
    32, // case 28 (АВТО-КЕЙС A-S CLASS)
    25, // case 29 (КЕЙС: ЖАРА)
    25  // case 30 (КЕЙС: ПЕКЛО)
};

new Float:chances[][] = {
   {0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05}, // case 1
   {0.029,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.046,0.009,0.009,0.005,0.009,0.005,0.009,0.005}, // case 2
   {0.046,0.047,0.047,0.047,0.047,0.024,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.047,0.024,0.024,0.024,0.012,0.012,0.012,0.012,0.012,0.012,0.012,0.006,0.006,0.006,0.005,0.01,0.01,0.01,0.01,0.003,0.003}, // case 3
   {0.059,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.063,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.032,0.008,0.008,0.008,0.008,0.008,0.004,0.004,0.002,0.002,0.001,0.001}, // case 4
   {0.089,0.089,0.089,0.089,0.006,0.089,0.089,0.089,0.089,0.089,0.089,0.016,0.016,0.016,0.016,0.016,0.006,0.006,0.006,0.006}, // case 5
   {0.067,0.067,0.067,0.067,0.033,0.067,0.067,0.067,0.067,0.067,0.067,0.033,0.033,0.027,0.027,0.027,0.027,0.027,0.013,0.027,0.014,0.014,0.014,0.008,0.006}, // case 6
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 7
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 8
   {0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.082,0.084,0.082,0.018,0.018,0.018,0.018,0.013,0.018,0.018,0.006,0.009,0.005,0.009,0.009,0.005,0.01,0.004}, // case 9
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 10
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 11
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 12
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 13
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 14
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 15
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 16
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 17
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 18
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 19
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 20
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 21
   {0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 22
   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 23

   {0.073,0.073,0.073,0.036,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 24 (пустой)

  {0.010,0.010,0.010,0.010,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.02,0.02,0.02,0.02,0.02,0.08,0.05,0.05,0.05,0.05,0.05},  // case 25
{0.40,0.24,0.16,0.10,0.07,0.03}, // case 26
{0.05,0.05,0.05,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.035,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.018,0.015,0.015,0.015,0.015,0.015,0.015,0.01,0.01,0.01,0.01,0.01,0.01,0.008,0.008,0.008,0.008,0.004,0.004,0.003,0.002}, // case 27
{0.11,0.09,0.08,0.07,0.065,0.06,0.055,0.05,0.045,0.04,0.035,0.025,0.023,0.021,0.019,0.017,0.015,0.013,0.012,0.011,0.01,0.009,0.008,0.007,0.006,0.005,0.004,0.003,0.0025,0.002,0.0015,0.001}, // case 28
{0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005}, // case 29
{0.073,0.073,0.073,0.073,0.036,0.073,0.073,0.073,0.036,0.073,0.036,0.073,0.035,0.035,0.036,0.035,0.018,0.005,0.012,0.02,0.007,0.012,0.01,0.005,0.005} // case 30
};


    new case_data_index = ResolveCaseDataIndex(case_id - 1);
    if (case_data_index < 0 || case_data_index >= sizeof(case_sizes)) return 0;

    new Float:rand = frandom(1.0);
    new prize_id = -1;
    new Float:cumulative = 0.0;

    if (case_id >= 6 && case_id <= 11)
    {
        prize_id = random(case_sizes[case_data_index]) + 1;
    }
    else
    {
        for (new i = 0; i < case_sizes[case_data_index]; i++)
        {
            cumulative += chances[case_data_index][i];
            if (rand <= cumulative)
            {
                prize_id = i + 1;
                break;
            }
        }
    }

    if (prize_id == -1) prize_id = 1; // подстраховка
	new JSON:response = JSON_Object(); 
	JSON_SetInt(response, "t", 2); 
	JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid)); 
	JSON_SetInt(response, "s", 1); 
	new JSON:prArray = JSON_Array(JSON_Int(prize_id)); 
	JSON_SetArray(response, "pr", prArray); 
	OnPacketIncoming(playerid, 73, response);
    JSON_Cleanup(response);
    printf("[Case] Player %d opened case %d -> reward %d (rand: %.3f)", playerid, case_id, prize_id, rand);
    return 1;
}
stock loadChanges(playerid, vehicleid, JSON:json)
{
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 0;

    // Дрифт
    JSON_SetInt(json, "t", 8);
    JSON_SetInt(json, "s", vInfo[index][vFstate] == FSTATE_DRIFT);
    OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

    // Комфорт
    JSON_SetInt(json, "t", 9);
    JSON_SetInt(json, "s", vInfo[index][vFstate] == FSTATE_COMFORT);
    OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

    // Спорт
    JSON_SetInt(json, "t", 10);
    JSON_SetInt(json, "s", vInfo[index][vFstate] == FSTATE_SPORT);
    OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

    // Спорт+
    JSON_SetInt(json, "t", 11);
    JSON_SetInt(json, "s", vInfo[index][vFstate] == FSTATE_SPORT_PLUS);
    OnPacketIncoming(playerid, GUIRadialMenuForCar, json);
    return 1;
}
stock SetVehicleNeonForPlayer(playerid, vehicleid, color1, color2, color3) // АВТОР ДАННЫХ РПС ВСЕХ И ТАКЖЕ АВТОР СЛИВА DEATHCODER @deathcoder_twink
{
	new BitStream:bs = BS_New();
	BS_WriteValue(bs, PR_UINT16, vehicleid);
	BS_WriteValue(bs, PR_UINT8, 9);   

	BS_WriteValue(bs, PR_UINT32, color1);
	BS_WriteValue(bs, PR_UINT32, color2);
	BS_WriteValue(bs, PR_UINT32, color3);

	PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bs);
}
CMD:radial(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xCECECE, "Вы должны находиться в транспорте");
    
    
    new vehicleid = GetPlayerVehicleID(playerid);
    
    new JSON:JSONObject = JSON_Object(); 
    new JSON:Info = JSON_Array();

    // Арендованный скутер создаётся без ownable action id.
    // Для него формируем отдельное radial-меню без обращения к vInfo[-1].
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_RENT_BIKE)
    {
        if(GetPlayerData(playerid, P_RENT_BIKE) != vehicleid)
        {
            JSON_Cleanup(Info);
            JSON_Cleanup(JSONObject);
            return SendClientMessage(playerid, 0xCECECEFF, "Этот скутер арендован другим игроком");
        }

        // Массив "s" хранит активные состояния radial, а не список доступных кнопок.
        if(GetVehicleParam(vehicleid, V_ENGINE))
            Info = JSON_Append(Info, JSON_Array(JSON_Int(6)));
        if(GetVehicleParam(vehicleid, V_LIGHTS))
            Info = JSON_Append(Info, JSON_Array(JSON_Int(14)));
        JSON_SetArray(JSONObject, "s", Info);
        ShowPlayerGUI(playerid, GUIRadialMenuForCar, JSONObject);
        return true;
    }
    
	new i = GetVehicleData(vehicleid, V_ACTION_ID);
    
    Info = JSON_Append(Info, JSON_Array( JSON_Int(1) ) );   //Парковка (проверку на ЗЗ)
    //if(vInfo[i][vLaunchControls]) Info = JSON_Append(Info, JSON_Array( JSON_Int(5) ) );   // vLaunchControls
    if(GetVehicleParam(vehicleid, V_LOCK)) Info = JSON_Append(Info, JSON_Array( JSON_Int(3) ) );   //Дверь
    
    if(GetVehicleParam(vehicleid, V_ENGINE))Info = JSON_Append(Info, JSON_Array( JSON_Int(6) ) );   //Двигатель

    switch (vInfo[i][vFstate]){
		case FSTATE_DRIFT:
		    Info = JSON_Append(Info, JSON_Array( JSON_Int(8) ));
		case FSTATE_COMFORT:
		    Info = JSON_Append(Info, JSON_Array( JSON_Int(9) ));
		case FSTATE_SPORT:
		    Info = JSON_Append(Info, JSON_Array( JSON_Int(10) ));
		case FSTATE_SPORT_PLUS:
		    Info = JSON_Append(Info, JSON_Array( JSON_Int(11) ));
	}
	
    if(vInfo[i][vEnableNeon])  Info = JSON_Append(Info, JSON_Array( JSON_Int(12) ) );  //Подсветка
    if(vInfo[i][IsFarLightActive]) Info = JSON_Append(Info, JSON_Array( JSON_Int(13) ) );  //Дальний свет
    if(GetVehicleParam(vehicleid, V_LIGHTS))Info = JSON_Append(Info, JSON_Array( JSON_Int(14) ) );  //Фары
    if(EnableStrob[vehicleid])  Info = JSON_Append(Info, JSON_Array( JSON_Int(15) ) );  //Стробоскопы
    
    
    if(vInfo[i][IsHydroActive]) Info = JSON_Append(Info, JSON_Array( JSON_Int(19) ) );  //Гидравлика
	switch (vInfo[i][SelectedPnevmo]){
		case 1:
		 Info = JSON_Append(Info, JSON_Array( JSON_Int(16) ) );
		case 2:
		 Info = JSON_Append(Info, JSON_Array( JSON_Int(17) ) );
		case 3:
		 Info = JSON_Append(Info, JSON_Array( JSON_Int(18) ) );
	}
    
    JSON_SetArray(JSONObject, "s", Info);
    
    ShowPlayerGUI(playerid, GUIRadialMenuForCar, JSONObject);
    return true;
}
public: ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new JSON:json_packet_data = JSON_Object(), outcoming_data[512];

    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    JSON_SetInt(json_packet_data, "g", internal_id);

    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели набор -");
    JSON_SetString(json_packet_data, "n", pack_name);

    OnPacketIncoming(playerid, 22, json_packet_data);

    JSON_Cleanup(json_packet_data);
}
public: FindGameId(internalId, array[][], array_size) {
    for (new i = 0; i < array_size; i++) {
        if (array[i][0] == internalId) {
            return array[i][1];
        }
    }
    return -1;
}

public: BuyPlayerCar(playerid, internal_id, game_id, color)
{
    if(game_id == -1)
    {
        return -1;
    }

    new body_color = GetPVarInt(playerid, "BUY_CAR_COLOR");
    DeletePVar(playerid, "BUY_CAR_COLOR");

    new free_car_id = GetFreeOwnableCarID();
    if(free_car_id == -1)
    {
        printf("[ERROR] BuyPlayerCar - no free ownable car slot for playerid: %d, internal_id: %d, game_id: %d", playerid, internal_id, game_id);
        return -1;
    }

    if(color < 0 || color > 255)
    {
        color = 0;
    }

    new Float: pos_x = 797.995727;
    new Float: pos_y = 522.099975;
    new Float: pos_z = 12.080810;
    new Float: angle = 335.517456;

    SetOwnableCarData(free_car_id, OC_OWNER_ID, GetPlayerAccountID(playerid));
    SetOwnableCarData(free_car_id, OC_MODEL_ID, game_id);
    SetOwnableCarData(free_car_id, OC_COLOR_1, color);
    SetOwnableCarData(free_car_id, OC_COLOR_2, 0);
    SetOwnableCarData(free_car_id, OC_POS_X, pos_x);
    SetOwnableCarData(free_car_id, OC_POS_Y, pos_y);
    SetOwnableCarData(free_car_id, OC_POS_Z, pos_z);
    SetOwnableCarData(free_car_id, OC_ANGLE, angle);

    strmid(g_ownable_car[free_car_id][OC_NUMBER], "regerds_test_number", 0, 8, 8);

    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());
    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    vInfo[free_car_id][body_colors] = body_color;
    new database_query[256];

    format(database_query, sizeof database_query, "INSERT INTO ownable_cars (owner_id,iscase,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time,body_colors) VALUES ('%d','%d','%d','%d','%d','%f','%f','%f','%f','%d','%d')", GetPlayerAccountID(playerid), 1, game_id, color, 0, pos_x, pos_y, pos_z, angle, gettime(), body_color);
    mysql_query(mysql, database_query, true);

    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }

    return free_car_id;
}

