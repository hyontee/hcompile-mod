//>> Файл: bykranin_src/core/decl/globals_03.inc  (1509 строк)
//>> Тема: макросы, константы, enum и глобальные массивы (данные, без логики)
//>> Внутри: FindAccsDataIndexByModel, ShowAcsDialog, CaseClientIdToLogical, CaseLogicalIdToClient, ResolveCaseDataIndex, InitPlayerCaseBonusStates, IsValidCaseBonusStates
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock FindAccsDataIndexByModel(modelid)
{
    for(new i; i < sizeof(AccsData); i++)
    {
        if(AccsData[i][accModel] == modelid) return i;
    }
    return -1;
}

stock ShowAcsDialog(playerid, page)
{
    const items_per_page = 30;

    new total = sizeof(accessory);
    if(total <= 0) return 0;

    new max_page = (total - 1) / items_per_page;
    if(page < 0) page = 0;
    if(page > max_page) page = max_page;

    gAcsDialogPage[playerid] = page;

    new text[4096];
    text[0] = '\0';

    new start = page * items_per_page;
    new end = start + items_per_page;
    if(end > total) end = total;

    for(new i = start; i < end; i++)
    {
        strcat(text, accessory[i][NAME_ACCESSORY]);
        strcat(text, "\n");
    }

    if(page > 0) strcat(text, "{AAAAAA}<< Предыдущая страница\n");
    if(page < max_page) strcat(text, "{AAAAAA}Следующая страница >>\n");
    strcat(text, "{FF0000}Снять все аксессуары");

    new title[96];
    format(title, sizeof title, "{FF0000}%s {FFFFFF}| Выдача аксов (%d/%d)", SERVER_NAME, page + 1, max_page + 1);

    ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_LIST, title, text, "Выбрать", "Назад");
    return 1;
}
new Float:SvetforsPos[18][4] =
{
//арз
	{-366.0, 981.0, 11.14, 0.0},
	{-368.546600,957.560302,11.14, 270.0},
	{-391.058990,961.149108,11.14, 180.0},
	{328.835540,1699.297729,11.14,250.971023},
	{318.586883,1671.872436,11.14,172.068237},
	{345.156921,1663.895263,11.14,267.259231},
	{360.339538,1687.765258,11.14,358.703964},
	{-388.625457,983.269531,11.14, -270.0}, 
//юж возле гибдд
    {2249.259033,-2144.601074,20.960937,359.253479},
    {2224.446533,-2140.237060,20.960937,93.107521},
    {2245.327148,-2169.859130,20.960937,275.290405},
//юж
    {2454.441406,-2140.342773,20.968269,95.382904},
    {2450.083496,-2165.327880,20.970085,176.587860},
    {2475.265869,-2169.774658,20.976562,266.861999},
    {2479.759277,-2144.504394,20.973707,3.563263}, 
//юж рядом со спавном
    {2732.063476,-2144.249023,20.979000,357.948333},
    {2704.337402,-2139.719238,20.981679,91.915931},
    {2701.037841,-2165.455810,20.976562,185.278167,}
};

new SvetforsColor[sizeof SvetforsPos];
new Float:gVezd[16][4] = {
{457.414428,994.900451,1001.039978,180.0},
{460.409393,994.633666,1001.039978,180.0},
{463.527008,994.476196,1001.039978,180.0},
{466.723785,994.493286,1001.039978,180.0},
{479.496978,994.941101,1001.039978,180.0},
{482.490447,994.761840,1001.039978,180.0},
{485.538940,994.795043,1001.039978,180.0},
{488.777587,994.781494,1001.039978,180.0},
{484.581085,976.139648,1001.039978,0.0},
{481.391479,976.139526,1001.039978,0.0},
{478.450775,976.211486,1001.039978,0.0},
{475.372680,976.791320,1001.039978,0.0},
{470.754516,976.268493,1001.039978,0.0},
{467.648162,976.436279,1001.039978,0.0},
{464.430145,976.352416,1001.039978,0.0},
{461.381805,976.542419,1001.039978,0.0}
};
#define MAX_CASES               (30)
#define ACTIVE_CASES_COUNT      (15)
#define MAX_CASE_BONUSES        (5)
#define CASE_BONUS_STR_LEN      (1024)

// Keep client IDs 27-30 for their built-in card names/art, but expose them
// as logical server slots 12-15. Client case 26 (racer tickets) stays hidden.
// V20: vehicle rewards in logical cases 12/13 are permanent (CA_COUNT=0).
stock CaseClientIdToLogical(clientCaseId)
{
    switch (clientCaseId)
    {
        case 27: return 12;
        case 28: return 13;
        case 29: return 14;
        case 30: return 15;
    }
    if (clientCaseId >= 1 && clientCaseId <= 11) return clientCaseId;
    return 0;
}

stock CaseLogicalIdToClient(logicalCaseId)
{
    switch (logicalCaseId)
    {
        case 12: return 27;
        case 13: return 28;
        case 14: return 29;
        case 15: return 30;
    }
    if (logicalCaseId >= 1 && logicalCaseId <= 11) return logicalCaseId;
    return 0;
}

// 0-based logical case index -> 0-based source reward-data index.
stock ResolveCaseDataIndex(caseIndex)
{
    switch (caseIndex)
    {
        case 11: return 26; // logical 12 <- old case 27 (B-C CLASS)
        case 12: return 27; // logical 13 <- old case 28 (A-S CLASS)
        case 13: return 28; // logical 14 <- old case 29 (HEAT)
        case 14: return 29; // logical 15 <- old case 30 (INFERNO)
    }
    return caseIndex;
}

#define CASE_BONUS_STATE_LOCKED     (1)
#define CASE_BONUS_STATE_AVAILABLE  (2)
#define CASE_BONUS_STATE_CLAIMED    (3)

stock InitPlayerCaseBonusStates(dest[], destlen)
{
    dest[0] = '\0';

    for (new caseId = 1; caseId <= MAX_CASES; caseId++)
    {
        new part[64];
        format(part, sizeof(part), "%d:1,1,1,1,1", caseId);
        strcat(dest, part, destlen);

        if (caseId != MAX_CASES)
            strcat(dest, "|", destlen);
    }
    return 1;
}

stock IsValidCaseBonusStates(const str[])
{
    if (isnull(str) || !strlen(str))
        return 0;

    new token[64];
    new pos = 0;
    new parsedCases = 0;

    for (new i = 0; ; i++)
    {
        if (str[i] == '|' || str[i] == '\0')
        {
            token[pos] = '\0';
            if (!strlen(token)) return 0;

            new colonPos = -1;
            for (new j = 0; token[j] != '\0'; j++)
            {
                if (token[j] == ':')
                {
                    colonPos = j;
                    break;
                }
            }

            if (colonPos == -1) return 0;

            new left[8], right[32];
            strmid(left, token, 0, colonPos, sizeof(left));
            strmid(right, token, colonPos + 1, strlen(token), sizeof(right));

            new caseId = strval(left);
            if (caseId < 1 || caseId > MAX_CASES) return 0;

            new stateCount = 0;
            new stateBuf[8], sPos = 0;

            for (new k = 0; ; k++)
            {
                if (right[k] == ',' || right[k] == '\0')
                {
                    stateBuf[sPos] = '\0';
                    if (!strlen(stateBuf)) return 0;

                    new st = strval(stateBuf);
                    if (st < 1 || st > 3) return 0;

                    stateCount++;
                    sPos = 0;

                    if (right[k] == '\0')
                        break;
                }
                else
                {
                    if (right[k] < '0' || right[k] > '9')
                        return 0;

                    if (sPos < sizeof(stateBuf) - 1)
                        stateBuf[sPos++] = right[k];
					else
                        return 0;
                }
            }

            if (stateCount != MAX_CASE_BONUSES)
                return 0;

            parsedCases++;
            pos = 0;

            if (str[i] == '\0')
                break;
        }
        else
        {
            if (pos < sizeof(token) - 1)
                token[pos++] = str[i];
            else
                return 0;
        }
    }

    return (parsedCases == MAX_CASES);
}

stock GetCaseBonusState(const source[], caseId, bonusIndex)
{
    if (caseId < 1 || caseId > MAX_CASES) return CASE_BONUS_STATE_LOCKED;
    if (bonusIndex < 1 || bonusIndex > MAX_CASE_BONUSES) return CASE_BONUS_STATE_LOCKED;

    new token[64];
    new pos = 0;

    for (new i = 0; ; i++)
    {
        if (source[i] == '|' || source[i] == '\0')
        {
            token[pos] = '\0';

            new colonPos = -1;
            for (new j = 0; token[j] != '\0'; j++)
            {
                if (token[j] == ':')
                {
                    colonPos = j;
                    break;
                }
            }

            if (colonPos != -1)
            {
                new left[8], right[32];
                strmid(left, token, 0, colonPos, sizeof(left));
                strmid(right, token, colonPos + 1, strlen(token), sizeof(right));

                if (strval(left) == caseId)
                {
                    new currentBonus = 1;
                    new stateBuf[8], sPos = 0;

                    for (new k = 0; ; k++)
                    {
                        if (right[k] == ',' || right[k] == '\0')
                        {
                            stateBuf[sPos] = '\0';

                            if (currentBonus == bonusIndex)
                                return strval(stateBuf);

                            currentBonus++;
                            sPos = 0;

                            if (right[k] == '\0')
                                break;
                        }
    					else
                        {
                            if (sPos < sizeof(stateBuf) - 1)
                                stateBuf[sPos++] = right[k];
                        }
                    }
                }
            }

            pos = 0;
            if (source[i] == '\0')
                break;
        }
        else
        {
            if (pos < sizeof(token) - 1)
                token[pos++] = source[i];
        }
    }

    return CASE_BONUS_STATE_LOCKED;
}

stock SetCaseBonusState(sourceDest[], destlen, caseId, bonusIndex, newState)
{
    if (caseId < 1 || caseId > MAX_CASES) return 0;
    if (bonusIndex < 1 || bonusIndex > MAX_CASE_BONUSES) return 0;
    if (newState < 1 || newState > 3) return 0;

    if (!IsValidCaseBonusStates(sourceDest))
        InitPlayerCaseBonusStates(sourceDest, destlen);

    new finalStr[CASE_BONUS_STR_LEN];
    finalStr[0] = '\0';

    new token[64];
    new pos = 0;

    for (new i = 0; ; i++)
    {
        if (sourceDest[i] == '|' || sourceDest[i] == '\0')
        {
            token[pos] = '\0';

            new outToken[64];
            format(outToken, sizeof(outToken), "%s", token);

            new colonPos = -1;
            for (new j = 0; token[j] != '\0'; j++)
            {
                if (token[j] == ':')
                {
                    colonPos = j;
                    break;
                }
            }

            if (colonPos != -1)
            {
                new left[8], right[32];
                strmid(left, token, 0, colonPos, sizeof(left));
                strmid(right, token, colonPos + 1, strlen(token), sizeof(right));

                if (strval(left) == caseId)
                {
                    new buffer[32];
                    buffer[0] = '\0';

                    new currentBonus = 1;
                    new stateBuf[8], sPos = 0;

                    for (new k = 0; ; k++)
                    {
                        if (right[k] == ',' || right[k] == '\0')
                        {
                            stateBuf[sPos] = '\0';

                            new writeVal = strval(stateBuf);
                            if (currentBonus == bonusIndex)
                                writeVal = newState;

                            new tmp[8];
                            format(tmp, sizeof(tmp), "%d", writeVal);
                            strcat(buffer, tmp, sizeof(buffer));

                            if (right[k] == ',')
                                strcat(buffer, ",", sizeof(buffer));

                            currentBonus++;
                            sPos = 0;

                            if (right[k] == '\0')
                                break;
                        }
    					else
                        {
                            if (sPos < sizeof(stateBuf) - 1)
                                stateBuf[sPos++] = right[k];
                        }
                    }

                    format(outToken, sizeof(outToken), "%d:%s", caseId, buffer);
                }
            }

            strcat(finalStr, outToken, sizeof(finalStr));
            if (sourceDest[i] == '|')
                strcat(finalStr, "|", sizeof(finalStr));

            pos = 0;

            if (sourceDest[i] == '\0')
                break;
        }
        else
        {
            if (pos < sizeof(token) - 1)
                token[pos++] = sourceDest[i];
        }
    }

    format(sourceDest, destlen, "%s", finalStr);
    return 1;
}

stock GetCaseBonusRequiredOpenCount(bonusIndex)
{
    new thresholds[5] = {40, 30, 20, 10, 5};

    if (bonusIndex < 1 || bonusIndex > 5)
        return 999999;

    return thresholds[bonusIndex - 1];
}

stock RefreshCaseBonusStatesForCase(bonusStr[], len, caseId, openedCount)
{
    if (!IsValidCaseBonusStates(bonusStr))
        InitPlayerCaseBonusStates(bonusStr, len);

    for (new i = 1; i <= MAX_CASE_BONUSES; i++)
    {
        new currentState = GetCaseBonusState(bonusStr, caseId, i);

        if (currentState == CASE_BONUS_STATE_CLAIMED)
            continue;

        new needOpen = GetCaseBonusRequiredOpenCount(i);

        if (openedCount >= needOpen)
            SetCaseBonusState(bonusStr, len, caseId, i, CASE_BONUS_STATE_AVAILABLE);
        else
            SetCaseBonusState(bonusStr, len, caseId, i, CASE_BONUS_STATE_LOCKED);
    }

    return 1;
}

stock BuildCaseBonusJsonForClient(dest[], destlen, const bonusStr[], caseId)
{
    dest[0] = '\0';
    strcat(dest, "[", destlen);

    for (new i = 1; i <= MAX_CASE_BONUSES; i++)
    {
        new st = GetCaseBonusState(bonusStr, caseId, i);

        new temp[64];
        format(temp, sizeof(temp),
            "{\"id\":%d,\"state\":%d}%s",
            i, st, (i < MAX_CASE_BONUSES) ? "," : ""
        );
        strcat(dest, temp, destlen);
    }

    strcat(dest, "]", destlen);
    return 1;
}
new Float:gViezd[4][4] = {
{897.632299,-893.109711,41.651085,63.484764},
{894.056105,-899.970972,41.663616,70.726615},
{890.738134,-905.790282,41.656777,63.251934},
{887.291113,-912.136567,41.656777,63.251934}
};
new const Float:gUsedMarketVehicleEnter[4][4] = {
{902.982299,-895.829711,41.351085,63.484764},
{899.696105,-902.008972,41.363616,70.726615},
{896.088134,-908.514282,41.356777,63.251934},
{892.641113,-914.856567,41.356777,63.251934}
};
new golod[MAX_PLAYERS] = 100;
new g_golod_timer[MAX_PLAYERS];

new Float:urogcheck[MAX_UCHECK][3] = {
    {1218.839355,1186.336303,22.195657},
    {1210.846557,1186.252319,22.238286},
    {1203.372802,1186.267578,22.311395},
    {1203.215698,1191.280029,22.215251},
    {1211.415771,1191.924316,22.124559},
    {1219.193481,1191.427612,22.094377},
    {1211.420532,1207.481811,21.820604},
    {1203.383789,1236.951171,21.298858},
    {1211.013671,1236.726074,21.251373},
    {1218.504882,1236.500122,21.271039},
    {1218.564575,1241.166137,21.227155},
    {1211.262573,1242.359375,21.148031},
    {1203.682861,1242.962646,21.147756},
    {1203.859985,1247.785766,20.981599},
    {1210.098632,1248.272949,21.046739},
    {1201.990600,1259.066528,20.220586},
    {1210.714965,1259.207519,20.337518},
    {1190.945556,1315.731811,18.601379} 
};

new Float:urogscheck[MAX_USCHECK][3] = {
   {1190.945556,1315.731811,18.601379},
   {1190.945556,1315.731811,18.601379} 
};

#include <customhud> // - с маги
#include <customtune> // - с брп
#include <sampvoice>


forward AntiDeAMX2();
forward AntiDeAMX();

#define SERVER            "{ffff00}" // - Цветовая гамма сервера
#define SC              "{ffff00}| {ffffff}"
#define USC             "{ff2400}| {ffffff}"

new SV_GSTREAM:gstream = SV_NULL;
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

new razdev;
new razdev1;
new razdev2;
new razdev3;
new razdev4;
new razdev5;
new Text: acs_TD[26];

new PlayerText: acs_coords_PTD[MAX_PLAYERS][1];
new razdev6;
new razdev7;
new razdev8;
new razdev9;
new medka;
new kaptfam;
new kaptfam2;
new avtorinokz;
new avtorinokv;
new shetochkovferma = 1;
new pkvixod;
new pkvxod;
new starik;
new prizrak;
new NPC_Dityukovich;
new pickupferma;
new pickuplarek;
new OtdelKadrovPravo;
new OtdelKadrovVoenkom;
new OtdelKadrovCb;
new OtdelKadrovSmi;
new OtdelKadrovGibdd;
new OtdelKadrovUmvd;

new g_HalloweenQuestActive = 0;
new g_PlayerQuestStatus[MAX_PLAYERS];
new playerid;

#define MAX_GREEN_ZONES            (128)	 // максимальное кол-во зеленых зон

enum E_GREEN_ZONES_STRUCT
{
	Float: GZ_X,
	Float: GZ_Y,
	Float: GZ_Z,
	Float: GZ_SIZE,
	GZ_NAME[32],
	GZ_AREA,
	bool: GZ_ALLOW_PARK,
	bool: GZ_NO_WEAPON
}

new
	g_green_zones[MAX_GREEN_ZONES][E_GREEN_ZONES_STRUCT] =
{
	{2907.5503,1513.4010,1551.9464, 50.00, "Отделение Полиции", -1, false, false},
	{1854.6537,2043.9581,15.8865, 50.00, "Банк", -1, true, false},
	{406.4704,1940.9047,8.1792, 50.00, "Банк", -1, false, false}, // банк арзамас
	{655.1985, 2658.7541, 13.5165, 99.00, "Автосалон премиум класса", -1, false, false},
	{1410.7759,460.1069,13.1630, 99.00, "Автосалон среднего класса", -1, false, false},
	{1761.8707,2279.4844,15.8625, 70.00, "Автосалон эконом класса'", -1, true, false},
	{-2239.9749,268.9089,24.5391, 70.00, "Мото-вело рынок", -1, false, false},
	{-113.0476,981.1268,12.0230, 50.00, "Гостинница Диана", -1, false, false},
	{-2561.733398,37.204780,27.866283, 35.00, "Автошкола", -1, false, false},
	{498.0786,1499.4578,1501.0000, 80.00, "Военкомат", -1, false, false}, // внутри
	{1916.9771,2312.2861,15.6606, 20.00, "Военкомат", -1, false, false}, // наружа
	{-126.2508,620.1169,12.0158, 70.00, "Правительство", -1, false, false},
	{978.1717,-5.9652,1380.9962, 99.00, "Правительство", -1, false, false}, // внутри
	{1818.683227,2516.680419,15.664262, 50.00, "Вокзал бат", -1, false, false},
	{642.583312,1691.444580,12.162509, 200.00, "Зеленая зона", -1, false, true},
	{846.602600, 796.555847, 13.400512, 100.00, "Спавн Арзамас", -1, false, true},
	{2740.712158, -2441.565185, 21.774286, 100.00, "Спавн Южный", -1, false, true},
	{-2429.236083, 203.175277, 26.096101, 100.00, "Спавн Лыткарино", -1, false, true},
	{1801.694091, 2523.137695, 14.602633, 100.00, "Спавн Батырево", -1, false, true},
	{-2667.526611, 2006.567016, 11.197804, 100.00, "Спавн Нижегородск", -1, false, true},
	{-2159.371093, 1558.103271, 9.840852, 100.00, "Южный вокзал НГ", -1, false, true},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false},
	{0.0, 0.0, 0.0, 0.0, "", -1, false, false}
};

new g_green_zones_loaded = 21;

new Text: green_zone_TD[1]; // боксы зеленой зоны




new Text: report_edit_TD;
new Text: admin_datetime_TD;
new texvzai;
new LastFixTick[MAX_PLAYERS];
new bool:EnableNeon[MAX_VEHICLES];
new bool:EnableHighLights[MAX_VEHICLES];
new bool:EnableStrob[MAX_VEHICLES];
new bool:EnableHydraulics[MAX_VEHICLES];


//НАСТРОЙКИ СЕРВЕРА

main(){
new a[][] = {"Unarmed (Fist)","Brass K"};
#pragma unused a
}

AntiDeAMX2()
{
        new a[][] =
        {
                "Unarmed (Fist)",
                "Brass K"
        };
        #pragma unused a
}

// -- flame fixx
#define M_DIALOG_DialogForPlayer 1

#define COLOR_YELLOW       0xFFFF00AA

new cont1 = 10;
new cont3 = 10;

new gPlayerLoggin[MAX_PLAYERS char];

//new DuelOffer[999];
new timeduel[MAX_PLAYERS]; 
new DuelTimer[MAX_PLAYERS]; 
new DuelCash[MAX_PLAYERS];

new g_bChatHidden[MAX_PLAYERS];

new stringer1[256];

new Text:autosalon_select_TD[3];
new vixodpravo;
new vxodpravo;
new Text:autosalon_color_TD[9];
new PlayerText:autosalon_select_PTD[MAX_PLAYERS][1];
new Text:autosalon_price_TD[3];
new PlayerText:autosalon_price_PTD[MAX_PLAYERS][1];
new Text:business_menu_TD[4];
new PlayerText:business_menu_PTD[MAX_PLAYERS][4];
new PlayerText:shop_clothes_PTD[MAX_PLAYERS][1];
new Text:shop_clothes_TD[6];
new Text:buy_car_number_TD[14];
new PlayerText:buy_car_number_PTD[MAX_PLAYERS][2];
new PlayerText:logo_PTD[MAX_PLAYERS][2];
new g_stability_logo_online[MAX_PLAYERS];
new g_stability_logo_power[MAX_PLAYERS];
new g_stability_hint_tick[MAX_PLAYERS];
new g_stability_visual_timer[MAX_PLAYERS];
new mysql_query_[512];
new PlayerText:speedometr02_PTD[MAX_PLAYERS][8];
new Text:speedometr02_TD[1];
new Text:enter_speedometr_TD[4];
new Text:meetentop_TD[4];
new tkvxodpon;
new tkvixodpon;
new lazaretvhod;
new lazaretvihod;
new cameravhod;
new cameravihod;
new lesopilvhod;
new lesopilvihod;

// -- pr
#define SPD ShowPlayerDialog

#define         c_main              	"{bb7dff}"
#define         c_white             	"{ffffff}"
#define         c_red               	"{d54a4a}"
#define         c_green             	"{7aca74}"
#define         c_orange            	"{ffad55}"
#define         c_yellow            	"{f9b961}"
#define         c_purple            	"{ea8afd}"
#define         c_gray              	"{999999}"
#define         c_brown             	"{97754f}"
#define         c_black             	"{080808}"
#define         c_lightyellow           "{e1daa3}"
#define         c_lightred          	"{FFFF00}"

new brak[MAX_PLAYERS];

new af[MAX_PLAYERS];//Переменная которая хранит общие формы
//Завод
new zona2;
new zona21;
new minzavod=9;
new siczavod=59;
new timerzavod;
new timerzavodp;
new vishka2;
//Вышка арз
new zona3;
new zona31;
new minarz=9;
new minvish=4;
//new minzavod=14;
//new siczavod=59;
new sicvish=59;
new sicarz=59;
new timerarz;
new timerarzl;
new vishka3;
//Вышка кар
new zona5;
new zona51;
new minkar=9;
new sickar=59;
new timerkar;
new timerkarr;
new vishka5;
//Вышка бус
new zona4;
new zona41;
new minbus=9;
new sicbus=59;
new timebusz;
new timerbuszl;
new vishka4;
new PlayerText:tiningbr_TD[MAX_PLAYERS][66];

// ------------------------------------
new bool:vodolazrabota[MAX_PLAYERS];
new bool:mestogovodo[MAX_PLAYERS][1];
#define VODOLAZ_CAPTAIN_COUNT (4)
new vodolazactor[VODOLAZ_CAPTAIN_COUNT];
new bool:vodogopoint[MAX_PLAYERS][1];
new bool:vodolod[MAX_PLAYERS];
new vodolootsphere[1][1];
new minferma=9;
new sicferma=59;
new zakaz11=0;
new zakaz22=0;
new bfam=0;
new shcarup;
new bool:mestolootgo[MAX_PLAYERS][1][1];
// -----------------------------------

new Text:REP_TEXT_TD[2]; // изображения кол-ва репорта и вопросов

new Text:avtsln_TD[13];
new PlayerText:avtsln_PTDD[MAX_PLAYERS][5];
new quest = -1;

new PickupPoint;
new PickupCreated = 0;


new mexpick = -1;
new mexs[MAX_PLAYERS];
//by Dergen and Tima
//new vehidtun[MAX_PLAYERS];
new launch[MAX_PLAYERS];
new nitro[MAX_PLAYERS];
new diski[MAX_PLAYERS];
new fars[MAX_PLAYERS];

//============инко============



new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];


/*new UserInfo[MAX_PLAYERS];
new UserNotif[MAX_PLAYERS];
new SetLeader[MAX_PLAYERS];
new IDPlayerAdminPrefix[MAX_PLAYERS];*/

//new Text:avtosalonpysto[11];

new PlayerReportFix[MAX_PLAYERS];

#define REPORT_STATUS_NONE			0
#define REPORT_STATUS_ANSWERED		1
#define REPORT_STATUS_SKIPPED		2
#define REPORT_STATUS_DISCONNECT	3

#define TABLE_REPORTS				"reports_list"

new const SkinMapping[][2] = {
    {548, 5500001}, // Предупреждение: modelid недопустим, будет использоваться internal_id
    {535, 6871},    // Предупреждение: modelid недопустим
    {529, 6894},    // Предупреждение: modelid недопустим
    {527, 6892},    // Предупреждение: modelid недопустим
    {528, 6895},    // Предупреждение: modelid недопустим
    {526, 6896},    // Предупреждение: modelid недопустим
    {525, 6893},    // Предупреждение: modelid недопустим
    {519, 6832},    // Предупреждение: modelid недопустим
    {513, 19262},   // Предупреждение: modelid недопустим
    {514, 19273},   // Предупреждение: modelid недопустим
    {515, 6780},    // Предупреждение: modelid недопустим
    {516, 11961},   // Предупреждение: modelid недопустим
    {517, 11962},   // Предупреждение: modelid недопустим
    {486, 11956},   // Предупреждение: modelid недопустим
    {487, 11958},   // Предупреждение: modelid недопустим
    {488, 11953},   // Предупреждение: modelid недопустим
    {489, 11948},   // Предупреждение: modelid недопустим
    {490, 11951},   // Предупреждение: modelid недопустим
    {491, 11947},   // Предупреждение: modelid недопустим
    {492, 11957},   // Предупреждение: modelid недопустим
    {497, 11959},   // Предупреждение: modelid недопустим
    {480, 11934},   // Предупреждение: modelid недопустим
    {481, 11933},   // Предупреждение: modelid недопустим
    {482, 11935},   // Предупреждение: modelid недопустим
    {483, 11944},   // Предупреждение: modelid недопустим
    {475, 11917},   // Предупреждение: modelid недопустим
    {462, 12293},   // Предупреждение: modelid недопустим
    {463, 12291},   // Предупреждение: modelid недопустим
    {457, 14386},   // Предупреждение: modelid недопустим
    {458, 14388},   // Предупреждение: modelid недопустим
    {419, 5323},    // Предупреждение: modelid недопустим
    {430, 5326},    // Предупреждение: modelid недопустим
    {431, 5325},    // Предупреждение: modelid недопустим
    {425, 5362},    // Предупреждение: modelid недопустим
    {420, 5367},    // Предупреждение: modelid недопустим
    {421, 5365},    // Предупреждение: modelid недопустим
    {399, 18606},   // Предупреждение: modelid недопустим
    {390, 310},     // Допустимый ID скина
    {391, 18621},   // Предупреждение: modelid недопустим
    {392, 311},     // Допустимый ID скина
    {393, 18620},   // Предупреждение: modelid недопустим
    {394, 18623},   // Предупреждение: modelid недопустим
    {395, 18624},   // Предупреждение: modelid недопустим
    {396, 18625},   // Предупреждение: modelid недопустим
    {397, 18626},   // Предупреждение: modelid недопустим
    {398, 18628},   // Предупреждение: modelid недопустим
    {346, 2},       // Допустимый ID скина
    {344, 302},     // Допустимый ID скина
    {345, 301},     // Допустимый ID скина
    {332, 196},     // Допустимый ID скина
    {333, 129},     // Допустимый ID скина
    {334, 130},     // Допустимый ID скина
    {335, 24},      // Допустимый ID скина
    {340, 197},     // Допустимый ID скина
    {336, 245},     // Допустимый ID скина
    {337, 243},     // Допустимый ID скина
    {338, 89},      // Допустимый ID скина
    {339, 88},      // Допустимый ID скина
    {341, 10},      // Допустимый ID скина
    {342, 92},      // Допустимый ID скина
    {343, 99},      // Допустимый ID скина
    {315, 110},     // Допустимый ID скина
    {313, 108},     // Допустимый ID скина
    {311, 95},      // Допустимый ID скина
    {322, 49},      // Допустимый ID скина
    {323, 53},      // Допустимый ID скина
    {324, 160},     // Допустимый ID скина
    {314, 109},     // Допустимый ID скина
    {312, 106},     // Допустимый ID скина
    {316, 165},     // Допустимый ID скина
    {317, 166},     // Допустимый ID скина
    {318, 174},     // Допустимый ID скина
    {319, 5},       // Допустимый ID скина
    {320, 267},     // Допустимый ID скина
    {321, 283},     // Допустимый ID скина
    {325, 162},     // Допустимый ID скина
    {326, 210},     // Допустимый ID скина
    {238, 65},      // Допустимый ID скина
    {257, 209},     // Допустимый ID скина
    {239, 39},      // Допустимый ID скина
    {240, 207},     // Допустимый ID скина
    {225, 86},      // Допустимый ID скина
    {226, 224},     // Допустимый ID скина
    {227, 232},     // Допустимый ID скина
    {228, 269},     // Допустимый ID скина
    {205, 252},     // Допустимый ID скина
    {206, 236},     // Допустимый ID скина
    {207, 48},      // Допустимый ID скина
    {208, 63},      // Допустимый ID скина
    {91, 23},       // Допустимый ID скина
    {92, 22},       // Допустимый ID скина
    {229, 231},     // Допустимый ID скина
    {93, 220},      // Допустимый ID скина
    {94, 225},      // Допустимый ID скина
    {230, 175},     // Допустимый ID скина
    {95, 202},      // Допустимый ID скина
    {96, 204},      // Допустимый ID скина
    {97, 229},      // Допустимый ID скина
    {203, 57},      // Допустимый ID скина
    {231, 208},     // Допустимый ID скина
    {232, 199},     // Допустимый ID скина
    {233, 264},     // Допустимый ID скина
    {234, 262},     // Допустимый ID скина
    {235, 62},      // Допустимый ID скина
    {98, 200},      // Допустимый ID скина
    {99, 234},      // Допустимый ID скина
    {100, 249},     // Допустимый ID скина
    {101, 235},     // Допустимый ID скина
    {236, 298},     // Допустимый ID скина
    {237, 266},     // Допустимый ID скина
    {209, 270},     // Допустимый ID скина
    {210, 122},      // Допустимый ID скина
	{561, 5500046},
	{562, 5500047},
	{564, 5500075}
};
// internal_id (donate) -> inventory item id (gameId) -> accessory model id
new const AccessoryMapping[][3] = {
    { 241, 136, 15135 },
    { 242, 137, 15136 },
    { 243, 138, 15137 },
    { 244, 139, 15138 },
    { 245, 140, 15139 },
    { 246, 141, 15140 },
    { 247, 142, 15141 },
    { 248, 145, 15144 },
    { 249, 151, 15152 },
    { 250, 153, 15154 },
    { 251, 152, 15153 },
    { 252, 154, 15155 },
    { 253, 160, 15157 },
    { 254, 143, 15142 },
    { 255, 144, 15143 },
    { 256, 155, 15150 },
    { 258, 149, 15148 },
    { 259, 146, 15145 },
    { 260, 147, 15146 },
    { 261, 148, 15147 },
    { 263, 156, 15160 },
    { 264, 157, 15161 },
    { 265, 158, 15159 },
    { 266, 159, 15151 },
    { 267, 150, 15149 },
    { 274, 161, 15158 },
    { 277, 170, 18233 },
    { 278, 169, 18232 },
    { 279, 180, 18243 },
    { 280, 187, 18250 },
    { 281, 200, 18263 },
    { 282, 201, 18264 },
    { 283, 210, 18273 },
    { 284, 216, 18279 },
    { 285, 220, 18285 },
    { 286, 221, 18286 },
    { 287, 263, 18346 },
    { 288, 264, 18347 },
    { 289, 265, 18348 },
    { 290, 281, 18369 },
    { 291, 287, 18375 },
    { 292, 289, 18377 },
    { 293, 290, 18378 },
    { 294, 291, 18379 },
    { 295, 295, 18383 },
    { 296, 296, 18384 },
    { 297, 297, 18385 },
    { 298, 301, 18389 },
    { 299, 302, 18390 },
    { 300, 303, 18391 },
    { 301, 304, 18392 },
    { 302, 308, 18396 },
    { 303, 309, 18397 },
    { 304, 313, 18401 },
    { 305, 316, 18404 },
    { 306, 321, 18409 },
    { 307, 322, 18410 },
    { 308, 323, 18411 },
    { 309, 324, 18412 },
    { 310, 326, 18414 },
    { 354, 347, 18497 },
    { 355, 348, 18498 },
    { 356, 349, 18499 },
    { 357, 350, 18500 },
    { 358, 351, 18501 },
    { 359, 352, 18502 },
    { 360, 353, 18503 },
    { 361, 354, 18504 },
    { 362, 355, 18505 },
    { 363, 356, 18506 },
    { 364, 357, 18507 },
    { 365, 358, 18508 },
    { 368, 359, 18509 },
    { 369, 360, 18510 },
    { 370, 361, 18511 },
    { 371, 362, 18512 },
    { 372, 363, 18513 },
    { 373, 364, 18514 },
    { 374, 365, 18515 },
    { 375, 366, 18516 },
    { 376, 367, 18517 },
    { 377, 368, 18518 },
    { 378, 369, 18519 },
    { 379, 370, 18520 },
    { 380, 371, 18521 },
    { 381, 372, 18522 },
    { 382, 373, 18523 },
    { 383, 374, 18524 },
    { 384, 375, 18525 },
    { 385, 376, 18526 },
    { 386, 377, 18527 },
    { 387, 378, 18528 },
    { 388, 379, 18529 },
    { 389, 380, 18530 },
    { 422, 508, 13883 },
    { 423, 511, 14575 },
    { 432, 513, 14589 },
    { 433, 515, 14591 },
    { 434, 516, 14592 },
    { 435, 536, 4165 },
    { 436, 520, 14596 },
    { 437, 521, 14597 },
    { 438, 522, 14598 },
    { 439, 527, 14603 },
    { 440, 531, 4160 },
    { 441, 532, 4161 },
    { 442, 533, 4162 },
    { 443, 534, 4163 },
    { 464, 578, 13803 },
    { 476, 579, 11919 },
    { 477, 582, 11922 },
    { 478, 583, 11923 },
    { 479, 585, 11925 },
    { 493, 660, 9824 },
    { 494, 662, 9826 },
    { 495, 663, 9827 },
    { 496, 664, 9828 },
    { 518, 709, 16055 },
    { 530, 914, 2655 },
    { 531, 915, 2656 },
    { 532, 916, 2657 },
    { 533, 917, 676 },
    { 534, 918, 677 },
    { 542, 576, 13801 },
    { 549, 983, 31949 }
};

// case reward internalId -> accessory model for Inventory11 (cases.json renderId)
new const CaseAccessoryRewardMapping[][2] = {
    { 890, 1652 },
    { 891, 1651 },
    { 892, 1653 },
    { 919, 4859 },
    { 924, 4864 },
    { 938, 4546 },
    { 939, 10492 },
    { 940, 4547 },
    { 944, 14647 },
    { 945, 14643 },
    { 946, 4702 },
    { 965, 11304 },
    { 966, 15055 },
    { 970, 16699 },
    { 978, 15635 },
    { 979, 15636 },
    { 990, 31965 },
    { 991, 31961 },
    { 999, 32129 },
    { 1000, 32136 },
    { 1001, 32130 },
    { 1002, 32137 },
    { 1003, 32138 },
    { 1017, 32418 },
    { 1018, 32419 },
    { 1019, 32420 },
    { 1029, 100071 },
    { 1030, 100072 },
    { 1031, 100073 },
    { 1032, 100074 },
    { 1033, 100075 },
    { 1043, 100077 },
    { 1044, 100078 },
    { 1053, 100108 },
    { 1054, 100109 },
    { 1055, 100110 },
    { 1056, 100111 },
    { 1058, 100113 },
    { 1066, 100166 },
    { 1067, 100167 },
    { 1077, 100179 },
    { 1078, 100180 },
    { 1079, 100181 },
    { 1080, 100182 },
    { 1087, 100085 },
    { 1088, 100086 },
    { 1089, 100087 },
    { 1090, 100088 },
    { 1103, 14593 }, // Карамельные крылья
    { 1104, 18377 }, // Очки-сердечки
    { 1105, 14575 }, // Крылья ангела
    { 1106, 14574 }  // Крылья демона
};

enum TEMP_REPORT_E {
	reportID,
	reportPlayerID,
	reportDate[20],
	reportText[144]
};
new TempReportInfo[MAX_PLAYERS][TEMP_REPORT_E];

// -- камера входа/рега
#define AUTH_CAMERA_POS 	19.2, 479.3, 13.1
#define AUTH_CAMERA_LOOK 	-400.0, 400.0, 5.0

// -- подключение базы данных
// #define LAN_MODE
//РАБОТЫ ____________________________________________________________________________________________________________________________
//АВТОБУС **/////////////////////*/
new buspick1;
new buspick2;
new buspick3;
new buses[MAX_PLAYERS];

new Float:zakazlist[3][11] =
{
{-2404.693603,2709.432373,37.918350,53.883522}, // edovo

{-1092.844970,2200.376708,37.713562,53.883522}, // zavod

{-514.258728,-1653.446655,40.586181,83.539146} // bysaevo
};
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****************************** [ TUNING ] ************************************/
new Float: pos_tuning [ 4 ] [ 4 ] =
{
	/*{1868.0150, -124.3506, 15.6880, 116.8298},
	{1865.8472, -120.0419, 15.6731, 114.6306},
	{1863.4740, -115.1540, 15.6288, 115.4123},
	{1861.3612, -110.0618, 15.6346, 116.4446}*/
	{0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0}
};
new Nitro[3][] = {
    {1009, 100,"Nitro 2X"},
    {1008, 200,"Nitro 5X"},
    {1010, 300,"Nitro 10X"}
};
/*******************************************************************************/

new l_string[64];

#define MAX_FLOOD_RATE	(3000)
#define FLOOD_RATE_INC	(1000)
#define FLOOD_RATE_KICK	(5000)

// раздевалки

#define MAX_PFORMA 7

#define SPD ShowPlayerDialog

#define DSMB DIALOG_STYLE_MSGBOX


#define DONATE_CAR_ID_1 	1
#define DONATE_CAR_ID_2 	1
#define DONATE_CAR_ID_3 	1
#define DONATE_CAR_ID_4 	1
#define DONATE_CAR_ID_5 	1
#define DONATE_CAR_ID_6 	1
#define DONATE_CAR_ID_7 	1
#define DONATE_CAR_ID_8 	1
#define DONATE_CAR_ID_9 	1
#define DONATE_CAR_ID_10 	1

#define DONATE_CAR_PRICE_1 		1
#define DONATE_CAR_PRICE_2 		1
#define DONATE_CAR_PRICE_3 		1
#define DONATE_CAR_PRICE_4 		1
#define DONATE_CAR_PRICE_5 		1
#define DONATE_CAR_PRICE_6 		1
#define DONATE_CAR_PRICE_7 		1
#define DONATE_CAR_PRICE_8 		1
#define DONATE_CAR_PRICE_9 		1
#define DONATE_CAR_PRICE_10 	1

#define RAND_WEATHER				// система рандомной погоды
#define ATM_CREATED_PICKUP			// создавать ли пикапы для банкоматов
#define FUEL_ST_CREATED_PICKUP		// создавать ли пикапы для азс

#define ENTER_PASSWORD_ATTEMPS 	(3)  // кол-во попыток на ввод пароля
#define REFER_BONUS_MONEY	(50_000) // бонус выдача денег реферу

#define MAX_FAMILY              (30000) // максимальное кол-во семей
#define MAX_GIFT                (100) // максимальное кол-во подков
#define DIALOG_START_QUEST 1323
#define DIALOG_END_QUEST 1324
#define vDifferential       17
#define vVinyl             9
#define vTint              3


#define MAX_AFK_TIME 			(30) // максимальное время афк (в минутах)
#define MAX_BANK_ACCOUNTS 		(5)	 // максимальное кол счетов в банке
#define MAX_PHONE_BOOK_CONTACTS (20) // макс. кол-во контактов для телефонной книги
#define MAX_AUTHORIZATION_TIME	(90) // время на авторизацию (в секундах)
#define MAX_FUEL_STATIONS		(18) // максимальное кол-во заправок
#define MAX_BUSINESS			(200)// максимальное кол-во предприятий
#define MAX_BUSINESS_GPS		(50) // максимальное кол-во предприятий в GPS
#define MAX_HOUSES				(900)// максимальное кол-во домов
#define MAX_HOUSE_ROOMS			(5)	 // максимальное кол-во комнат в доме
#define MAX_GATES				(1)	 // максимальное кол-во шлагбаум/ворот
#define MAX_ENTRANCES			(200) // максимальное кол-во подъездов
#define MAX_ENTRANCE_FLOORS		(5)	 // максимальное кол-во этажей в подъезде
#define MAX_HOTELS 				(3)	 // максимальное кол-во отелей
#define MAX_HOTEL_FLOORS 		(7)  // максимальное кол-во этажей отеля
#define MAX_HOTEL_ROOMS 		(MAX_HOTEL_FLOORS * 12) // максимальное кол-во номеров в отеле
#define MAX_OWNABLE_CARS		(15000)// максимальное кол-во личных ТС
#define MAX_VEHICLE_TRUNK_SLOTS	(26)	 // максимальное кол-во слотов багажника
#define MAX_GANG_REPOSITORIES	(3)  // максимальное кол-во складов для банд
#define MAX_GZ					(101)// максимальное кол-во ганг-зон
//#define MAX_RADARS				(100)// максимальное кол-во радаров
//#define MAX_WEAPON_TINTS		(13) // максимальное кол-во раскрасок оружия
#define MAX_ADVERTS				(100)// максимальное кол-во объявлений
#define MAX_GREEN_ZONES            (128)	 // максимальное кол-во зеленых зон
#define RandomEx(%0,%1) (%0+random(%1-%0))


#define MIN_PLAYERS_FOR_CAPTURE (1)	 // минимальное кол-во игроков для захвата территории

#define BIZ_HEALTH_SERVICE_PRICE (150)	// стоимость использование аптечки в бизнесе

#define ADVERT_SEND_PRICE		(250) // стоимость отправки объявления

#define MAP_ICON_STREAM_DISTANCE (100.0) // прорисовка иконок на карте (радиус)

#define MAX_ADMINS 30


#define MAX_REPORTS				(100)

enum R_REPORT_STRUCT
{
	REP_CREATOR,
	bool: REP_EDIT,
	REP_TEXT[128]
}

enum ASTATS {
     mute,
     ban,
     report,
     spawn,
     kick,
     warn,
     jail
};
new InfoAstats[ASTATS];

new g_PlayerQuestState[MAX_PLAYERS]; // Хранит состояние квеста для каждого игрока

enum QuestState {
    QUEST_NOT_STARTED,
    QUEST_IN_PROGRESS,
    QUEST_COMPLETED
}


new g_report[MAX_REPORTS][R_REPORT_STRUCT];

new g_report_created;

#define MAX_BIND 20
#define DIALOG

#define DIALOG_QM 6565
#define DIALOG_EDIT_QM 6566
#define DIALOG_TEXT_QM 6567

// ------------------------------------------
#define public:%0(%1) \
			forward %0(%1); \
				public %0(%1)

#define Kick:(%0) FixKick(%0)


#define RandomPrize   100000
new Text3D:g_admin_badge[MAX_PLAYERS];
//#define Dialog ShowPlayerDialog

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define PRESSING(%0,%1) \
	(%0 & (%1))

//forward AntiBH(playerid);
//forward AntiBH1(playerid);

// ------------------------------------------
#define VEHICLE_COORD_TYPE_BOOT		(1)
#define VEHICLE_COORD_TYPE_BONNET	(2)

// ------------------------------------------
#define SELECT_PANEL_TYPE_NONE			0
#define SELECT_PANEL_TYPE_CLOTHING		1
#define SELECT_PANEL_TYPE_REG_SKIN		2
#define SELECT_PANEL_TYPE_CAR_MARKET 	3
#define PICKUP_ACTION_TYPE_MOTO_SALON_ENTER 300
#define PICKUP_ACTION_TYPE_MOTO_SALON_EXIT 301
#define SELECT_PANEL_TYPE_MOTO_SALON 4
//*****************************************

#define PT_ITEM_TYPE_NONE   		(0)
#define PT_ITEM_TYPE_ENGINE     	(1)
#define PT_ITEM_TYPE_BRAKE     		(2)
#define PT_ITEM_TYPE_STABILITY     	(3)

// ------------------------------------------
#define GATE_STATUS_OPEN	true
#define GATE_STATUS_CLOSE	false

// ------------------------------------------
#define GPS_STATUS_ON	true
#define GPS_STATUS_OFF	false

// ------------------------------------------
#define ADMIN_TYPE_NONE 	0

// ------------------------------------------
#define CONVERT_TIME_TO_SECONDS 	1
#define CONVERT_TIME_TO_MINUTES 	2
#define CONVERT_TIME_TO_HOURS 		3
#define CONVERT_TIME_TO_DAYS 		4
#define CONVERT_TIME_TO_MONTHS 		5
#define CONVERT_TIME_TO_YEARS 		6

// ------------------------------------------
#define ACCOUNT_STATE_NONE 		0
#define ACCOUNT_STATE_REGISTER 	1
#define ACCOUNT_STATE_LOGIN 	2
#define ACCOUNT_STATE_REG_SKIN 	3

// ------------------------------------------
#define REQUEST_TYPE_OFF		-1
#define REQUEST_TYPE_SUBNET		1
#define REQUEST_TYPE_IP			2

// ------------------------------------------
#define PIN_CODE_STATE_NONE 	0
#define PIN_CODE_STATE_SET 		1 // установка пин кода
#define PIN_CODE_STATE_CHECK	2 // проверка пин кода
#define PIN_CODE_STATE_CHANGE	3 // смена пин кода
#define PIN_CODE_STATE_LOGIN_CHECK 4 // проверка пин кода при авторизации

// ------------------------------------------
#define HOUSE_TYPE_NONE		(-1) 	// нет
#define HOUSE_TYPE_HOME		(0) 	// дом
#define HOUSE_TYPE_ROOM		(1) 	// аренда комнаты
#define HOUSE_TYPE_HOTEL	(2) 	// отель

// ------------------------------------------
#define REALTOR_TYPE_NONE	(0)
#define REALTOR_TYPE_HOUSE	(1) // дом
#define REALTOR_TYPE_BIZ	(2) // биз

// ------------------------------------------
#define GetItemInfo(%0,%1) 		g_item_type[%0][%1]


#define GetPromoPayDayInfo(%0)		GetPromoPayDayInfo[%0]

#define GetPromoPrizInfo(%0, %1)           GetPromoPriz(%0, %1)

// ------------------------------------------
#define GetTrunkData(%0,%1,%2) 			g_vehicle_trunk[%0][%1][%2]
#define SetTrunkData(%0,%1,%2,%3) 		g_vehicle_trunk[%0][%1][%2] = %3
#define AddTrunkData(%0,%1,%2,%3,%4) 	g_vehicle_trunk[%0][%1][%2] %3= %4

#define IsTrunkFreeSlot(%0,%1)			!GetTrunkData(%0, %1, VT_SQL_ID)

// ------------------------------------------
#define GetOwnableCarData(%0,%1) 		g_ownable_car[%0][%1]
#define SetOwnableCarData(%0,%1,%2)		g_ownable_car[%0][%1] = %2
