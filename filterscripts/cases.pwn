#include <a_samp>

#define DIALOG_CASES_LIST     18350
#define DIALOG_CASE_INFO      18351
#define DIALOG_CASE_RESULT    18352

#define MAX_CASES             5

enum E_CASE_DATA
{
    caseName[64],
    rewardCount
};

new const CaseData[MAX_CASES][E_CASE_DATA] =
{
    {"ЕЖЕДНЕВНЫЙ КЕЙС", 20},
    {"КЕЙС БОМЖА", 28},
    {"СТАНДАРТНЫЙ КЕЙС", 37},
    {"АВТО-КЕЙС 2.0", 31},
    {"ОСОБЫЙ КЕЙС", 20}
};

new const DailyRewards[][] =
{
    "Рем.комплект",
    "2 EXP",
    "200 BP EXP",
    "Канистра с бензином",
    "4000 Р",
    "5 BC",
    "8000 Р",
    "10 BC",
    "VIP SILVER 2Ч.",
    "400 BP EXP",
    "4 EXP",
    "RACER SPORT",
    "500 BP EXP",
    "20000 Р",
    "15 BC",
    "VIP GOLD 2Ч.",
    "600 BP EXP",
    "30000 Р",
    "6 EXP",
    "ВАЗ 1111"
};

new const BomzhRewards[][] =
{
    "Aprilla MXV 450",
    "VOLKSWAGEN GOLF GTI 2",
    "75000 Р",
    "ВАЗ 2107",
    "12 EXP",
    "ВАЗ 2108",
    "90000 Р",
    "ВАЗ 2109",
    "ВАЗ 2110",
    "ВАЗ 2114",
    "VIP SILVER 7 ДН.",
    "ВАЗ 2112",
    "ВАЗ 2115",
    "16 EXP",
    "120000 Р",
    "VIP GOLD 3 ДН.",
    "VOLVO 242DL",
    "ВАЗ 2170",
    "VIP PLATINUM 3 ДН.",
    "NIVA URBAN",
    "Mercedes-Benz W124",
    "BMW M3 E36",
    "LADA VESTA",
    "ПОБИТЫЕ ОЧКИ",
    "VOLKSWAGEN POLO",
    "РЮКЗАК СИФОНА",
    "Игла преступник",
    "КОРОЛЬ БОМЖЕЙ"
};

new const StandardRewards[][] =
{
    "ЗОЛОТАЯ КОРОНА",
    "VIP GOLD 21 ДН.",
    "600000 Р",
    "КЕЙС ЧЕРНЫЙ",
    "BMW M3 E46",
    "РЫБАК",
    "600 BC",
    "VIP PLATINUM 15 Д.",
    "ACURA TSX",
    "МОПС НА СПИНУ",
    "БАРХАТНЫЕ ТЯГИ ОСОБЫЕ",
    "КОРОНА ДЕМОНА",
    "ХОУМИ С РАЙОНА",
    "VOLKSWAGEN GOLF GTI",
    "BMW X5 E53",
    "NISSAN QASHQAI",
    "TOYOTA CAMRY XV55",
    "NISSAN SILVIA S15",
    "DUCATI SUPERSPORT S",
    "1000000 Р",
    "VIP PLATINUM 30 Д.",
    "БАРЫГА ПРЕСТУПНИК",
    "BMW M5 E60",
    "МЕНТ ИЗ КЛИПА",
    "SUBARU WRX STI",
    "ВУРДАЛААК СТРАШНЫЙ ДЕД",
    "KIA K5",
    "BMW X5M E70",
    "CHEVROLET CAMARO ZL1",
    "DODGE CHARGER SRT",
    "МАСКА СВИНА",
    "MERCEDES-BENZ GT63S",
    "BMW M4 G82",
    "BMW X6M F16",
    "PORSCHE 911 CARRERA S",
    "LAMBORGHINI AVENTADOR S",
    "TESLA MODEL X"
};

new const AutoRewards[][] =
{
    "MITSUBISHI LANCER EVO X",
    "BMW M5 E60",
    "SUBARU WRX STI",
    "TOYOTA CAMRY 3.5",
    "KIA K5",
    "FORD MUSTANG GT",
    "TOYOTA SUPRA A80",
    "MERCEDES-BENZ A45 AMG",
    "MINI COUNTRYMAN",
    "VOLKSWAGEN PASSAT",
    "ALFA ROMEO GUILIA",
    "BMW X5M E70",
    "INFINITI Q60S",
    "LEXUS RCF",
    "SUBARU BRZ",
    "XPENG P7",
    "BMW 3-SERIES G20",
    "BMW Z4 M40I",
    "DODGE CHARGER SRT",
    "BMW M4 F84",
    "MERCEDES-BENZ GT63S",
    "BMW M4 G82",
    "NISSAN GT-R R35",
    "DODGE RAM",
    "BMW X6M F16",
    "Volkswagen Touareg 2022",
    "PORSCHE 911 CARRERA",
    "MARUSSIA B2",
    "MERCEDES-BENZ E63S WAGON",
    "RANGE ROVER III",
    "FERRARI 812 SUPERFAST"
};

new const SpecialRewards[][] =
{
    "Mercedes-Benz C63s",
    "Porsche Panamera S",
    "BMW M6 F12",
    "BMW X7 M50i",
    "Mercedes-Benz G63 AMG 6x6",
    "Lamborghini Gallardo",
    "Mercedes-Benz 300SL Coupe",
    "Lamborghini Urus",
    "Lamborghini Huracan",
    "Chevrolet Corvette C8",
    "Mercedes-Benz G65 AMG",
    "Ferrari 488 Pista",
    "Pagani Zonda 2002",
    "Tesla CyberTruck",
    "Rolls-Royce Cullinan",
    "BENTLEY Continental GT",
    "BUGATTI CHIRON",
    "Koenigsegg Regera",
    "Bugatti Veyron",
    "BMW M5 F90 (ППС)"
};

forward FS_ShowCasesDialog(playerid);

stock GetCaseRewardName(caseid, rewardid, dest[], len)
{
    dest[0] = '\0';

    switch(caseid)
    {
        case 0: format(dest, len, "%s", DailyRewards[rewardid]);
        case 1: format(dest, len, "%s", BomzhRewards[rewardid]);
        case 2: format(dest, len, "%s", StandardRewards[rewardid]);
        case 3: format(dest, len, "%s", AutoRewards[rewardid]);
        case 4: format(dest, len, "%s", SpecialRewards[rewardid]);
    }
    return 1;
}

stock bool:IsVehicleReward(caseid, rewardid)
{
    switch(caseid)
    {
        case 0:
        {
            if(rewardid == 11 || rewardid == 19) return true;
        }
        case 1:
        {
            if(
                rewardid == 0 || rewardid == 1 || rewardid == 3 || rewardid == 5 ||
                rewardid == 7 || rewardid == 8 || rewardid == 9 || rewardid == 11 ||
                rewardid == 12 || rewardid == 16 || rewardid == 17 || rewardid == 19 ||
                rewardid == 20 || rewardid == 21 || rewardid == 22 || rewardid == 24
            ) return true;
        }
        case 2:
        {
            if(
                rewardid == 4 || rewardid == 8 || rewardid == 13 || rewardid == 14 ||
                rewardid == 15 || rewardid == 16 || rewardid == 17 || rewardid == 18 ||
                rewardid == 22 || rewardid == 24 || rewardid == 26 || rewardid == 27 ||
                rewardid == 28 || rewardid == 29 || rewardid == 31 || rewardid == 32 ||
                rewardid == 33 || rewardid == 34 || rewardid == 35 || rewardid == 36
            ) return true;
        }
        case 3, 4:
        {
            return true;
        }
    }
    return false;
}

stock GivePlayerCaseVehicle(playerid, vehicleName[])
{
    new msg[144];
    format(msg, sizeof(msg), "[CASE] Транспорт %s добавлен в автопарк!", vehicleName);
    SendClientMessage(playerid, 0x33CC66FF, msg);

    // СЮДА ВСТАВЬ СВОЮ СИСТЕМУ ВЫДАЧИ В АВТОПАРК
    // Пример:
    // AddVehicleToGarage(playerid, modelid);

    return 1;
}

stock GivePlayerCaseReward(playerid, caseid, rewardid)
{
    new rewardName[64];
    GetCaseRewardName(caseid, rewardid, rewardName, sizeof(rewardName));

    if(!strcmp(rewardName, "4000 Р", true)) GivePlayerMoney(playerid, 4000);
    else if(!strcmp(rewardName, "8000 Р", true)) GivePlayerMoney(playerid, 8000);
    else if(!strcmp(rewardName, "20000 Р", true)) GivePlayerMoney(playerid, 20000);
    else if(!strcmp(rewardName, "30000 Р", true)) GivePlayerMoney(playerid, 30000);
    else if(!strcmp(rewardName, "75000 Р", true)) GivePlayerMoney(playerid, 75000);
    else if(!strcmp(rewardName, "90000 Р", true)) GivePlayerMoney(playerid, 90000);
    else if(!strcmp(rewardName, "120000 Р", true)) GivePlayerMoney(playerid, 120000);
    else if(!strcmp(rewardName, "600000 Р", true)) GivePlayerMoney(playerid, 600000);
    else if(!strcmp(rewardName, "1000000 Р", true)) GivePlayerMoney(playerid, 1000000);

    if(IsVehicleReward(caseid, rewardid))
    {
        GivePlayerCaseVehicle(playerid, rewardName);
    }

    return 1;
}

stock ShowCaseInfoDialog(playerid, caseid)
{
    new text[4096], line[128], rewardName[64];
    text[0] = '\0';

    format(line, sizeof(line), "Награды кейса: %s\n\n", CaseData[caseid][caseName]);
    strcat(text, line);

    for(new i = 0; i < CaseData[caseid][rewardCount]; i++)
    {
        GetCaseRewardName(caseid, i, rewardName, sizeof(rewardName));
        format(line, sizeof(line), "%d. %s\n", i + 1, rewardName);
        strcat(text, line);
    }

    SetPVarInt(playerid, "selected_case_id", caseid);

    ShowPlayerDialog(playerid, DIALOG_CASE_INFO, DIALOG_STYLE_MSGBOX,
        "Информация о кейсе",
        text,
        "Открыть",
        "Назад"
    );
    return 1;
}

stock OpenSelectedCase(playerid)
{
    new caseid = GetPVarInt(playerid, "selected_case_id");
    if(caseid < 0 || caseid >= MAX_CASES) return 1;

    new rewardid = random(CaseData[caseid][rewardCount]);
    new rewardName[64], resultText[256];

    GetCaseRewardName(caseid, rewardid, rewardName, sizeof(rewardName));
    GivePlayerCaseReward(playerid, caseid, rewardid);

    format(resultText, sizeof(resultText),
        "Вы открыли %s\n\nВы выбили:\n%s",
        CaseData[caseid][caseName],
        rewardName
    );

    ShowPlayerDialog(playerid, DIALOG_CASE_RESULT, DIALOG_STYLE_MSGBOX,
        "Открытие кейса",
        resultText,
        "ОК",
        ""
    );
    return 1;
}

public FS_ShowCasesDialog(playerid)
{
    new list[512];
    list[0] = '\0';

    for(new i = 0; i < MAX_CASES; i++)
    {
        strcat(list, CaseData[i][caseName]);
        strcat(list, "\n");
    }

    ShowPlayerDialog(playerid, DIALOG_CASES_LIST, DIALOG_STYLE_LIST,
        "Выбор кейса",
        list,
        "Выбрать",
        "Закрыть"
    );
    return 1;
}

public OnFilterScriptInit()
{
    print("[cases] filterscript loaded");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_CASES_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= MAX_CASES) return 1;

        ShowCaseInfoDialog(playerid, listitem);
        return 1;
    }

    if(dialogid == DIALOG_CASE_INFO)
    {
        if(response)
        {
            OpenSelectedCase(playerid);
        }
        else
        {
            FS_ShowCasesDialog(playerid);
        }
        return 1;
    }

    return 0;
}
