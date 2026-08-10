/*
    GUI-навигатор для laird.pwn
    Русская доработка под существующую систему GPS.

    Что делает:
    - заменяет старое меню /gps на удобный GUI-список с категориями;
    - добавляет команду /navigator;
    - ставит метки через штатную функцию EnablePlayerGPS;
    - поддерживает быстрый поиск ближайших АЗС, 24/7, одежды, оружия, казино и тюнинга;
    - позволяет снять текущую GPS-метку.
*/

#if defined _navigator_gui_included
    #endinput
#endif
#define _navigator_gui_included

#define NAVGUI_COLOR_MAIN      (0xFF5252FF)
#define NAVGUI_COLOR_INFO      (0x66CC33FF)
#define NAVGUI_COLOR_ERROR     (0xCECECEFF)

#define NAVGUI_DIALOG_TITLE    "{FFCD00}GPS-навигатор"

enum E_NAVGUI_POINT
{
    NAVP_NAME[64],
    Float:NAVP_X,
    Float:NAVP_Y,
    Float:NAVP_Z,
    NAVP_MARKER
};

new const navgui_important[][E_NAVGUI_POINT] =
{
    {"Правительство", -2569.206787, 2248.303710, 58.188438, 36},
    {"Автошкола", -2561.733398, 37.204780, 27.866283, 36},
    {"Военкомат", 1916.550300, 2302.278600, 15.141200, 46},
    {"Городская больница Арзамас", -286.903400, 576.885900, 12.844700, 22},
    {"СТО и тюнинг-ателье", 1822.497070, -143.917648, 15.688644, 27}
};

new const navgui_newbie_jobs[][E_NAVGUI_POINT] =
{
    {"Шахта", 2382.080810, 1723.076171, -1.847625, 36},
    {"Работа грузчика", 615.201660, 1669.412475, 12.070997, 36},
    {"Завод", -1044.015136, 2207.833740, 38.119235, 36}
};

new const navgui_jobs[][E_NAVGUI_POINT] =
{
    {"База механиков", 1836.630200, -116.033700, 15.571600, 27},
    {"Курьерская служба доставки", 2760.593505, -2396.189697, 21.890625, 27},
    {"Аренда автобуса Южный", 2773.839355, -2452.672607, 21.882169, 27},
    {"Аренда автобуса Арзамас", 889.022521, 787.449279, 14.198203, 27},
    {"Аренда автобуса Батырево", 1795.219238, 2530.799804, 15.672040, 27}
};

new const navgui_state_orgs[][E_NAVGUI_POINT] =
{
    {"Правительство области", -2569.206787, 2248.303710, 58.188438, 19},
    {"Отдел полиции №1 / ГИБДД", 1907.813720, -2232.832275, 11.227499, 30},
    {"Отдел полиции №2 / УМВД", 2578.948200, -2416.119600, 21.992200, 30},
    {"Отдел ФСБ", -2399.956500, -383.990700, 29.440200, 30},
    {"Городская больница", -286.903400, 576.885900, 12.844700, 22},
    {"СМИ", 2412.250488, -1841.700439, 22.949813, 42},
    {"Воинская часть", 1731.489400, 1768.265400, 16.750100, 18}
};

new const navgui_crime_orgs[][E_NAVGUI_POINT] =
{
    {"Арзамасская ОПГ", 409.995300, 1049.588700, 12.078800, 62},
    {"Батыревская ОПГ", 1943.905600, 2164.601600, 15.271400, 61},
    {"Лыткаринская ОПГ", -2405.866200, 58.973300, 26.570200, 60}
};

new const navgui_transport[][E_NAVGUI_POINT] =
{
    {"Транспортная компания Батырево", 2327.637207, 2009.636962, 16.620204, 51},
    {"Транспортная компания Бусаево", -426.065887, -1687.605712, 41.526901, 51},
    {"Контейнерная площадка", 598.226501, 1757.621826, 11.861831, 51},
    {"Депо Южный", 2058.106445, -2604.110351, 10.619886, 51}
};

new const navgui_entertainment[][E_NAVGUI_POINT] =
{
    {"Казино", 1334.033569, 2370.760742, 17.664188, 27},
    {"Битва за контейнеры", 611.408325, 1693.072387, 11.243210, 27},
    {"Компьютерный клуб", -2378.568847, 32.216888, 26.566650, 27}
};

new const navgui_banks[][E_NAVGUI_POINT] =
{
    {"Центральный банк Арзамас", 393.282592, 758.764648, 12.034260, 52},
    {"Центральный банк Батырево", 1852.014404, 2041.454711, 15.922142, 52},
    {"Центральный банк Южный", 2376.754882, -2143.508544, 22.000938, 52}
};

new const navgui_piers[][E_NAVGUI_POINT] =
{
    {"Причал возле Гарели", 2310.545654, 300.313903, 2.039983, 27},
    {"Причал Южный", 2506.951171, -1253.455688, 1.436212, 27},
    {"Причал Арзамас", 654.545776, 168.784423, 2.081145, 27},
    {"Причал Лыткарино", -2530.635986, 355.645568, 2.100287, 27}
};

new const navgui_autosalons[][E_NAVGUI_POINT] =
{
    {"Автосалон низкого класса", 2477.189941, -720.067810, 12.331512, 27},
    {"Автосалон среднего класса", 1409.747558, 458.474578, 13.163024, 27},
    {"Автосалон высокого класса", 657.475830, 2661.963134, 13.516562, 27},
    {"Салон грузовых автомобилей", -2243.496826, 264.510131, 24.539062, 27},
    {"Мотосалон Harley Davidson", -908.894900, 1182.447100, 10.724700, 27},
    {"Авторынок поддержанных авто", 1980.827392, -550.358337, 11.974724, 27}
};

new const navgui_cities[][E_NAVGUI_POINT] =
{
    {"г. Южный", 2741.322753, -1434.873046, 23.814182, 27},
    {"г. Арзамас", 214.106903, 819.745117, 12.132319, 27},
    {"д. Рублевка", -630.529113, 964.976379, 12.004625, 27},
    {"п. Егоровка", -1062.917114, 424.410278, 20.436664, 27},
    {"пгт. Батырево", 1888.277709, 2253.680419, 15.952725, 27},
    {"г. Лыткарино", -2117.363281, -269.016113, 25.883516, 27},
    {"г. Эдово", -1489.310546, 2370.496826, 57.790000, 27},
    {"п. Бусаево", -514.984130, -1594.674072, 40.964874, 27},
    {"д. Корякино", 385.337463, -1252.215576, 40.561260, 27}
};

new const navgui_stations[][E_NAVGUI_POINT] =
{
    {"Вокзал Арзамас", 829.268920, 799.759826, 13.029401, 27},
    {"Вокзал Южный", 2768.988281, -2418.091552, 20.974534, 27},
    {"Вокзал Батырево", 1806.439086, 2518.951660, 14.819187, 27}
};

stock NavGUI_AppendRow(text[], text_size, const point_name[], const hint[])
{
    new row[144];
    format(row, sizeof row, "%s\t%s\n", point_name, hint);
    strcat(text, row, text_size);
    return 1;
}

stock NavGUI_SetPoint(playerid, const point_name[], marker, Float:x, Float:y, Float:z)
{
    new message[160];
    format(message, sizeof message, "{FF5252}[Навигатор]{FFFFFF} %s отмечено на GPS.", point_name);
    EnablePlayerGPS(playerid, marker, x, y, z, message);
    return 1;
}

stock NavGUI_ClearPoint(playerid)
{
    DisablePlayerGPS(playerid);
    DisablePlayerCheckpoint(playerid);
    SendClientMessage(playerid, NAVGUI_COLOR_INFO, "{FF5252}[Навигатор]{FFFFFF} GPS-метка снята.");
    return 1;
}

stock NavGUI_ShowMain(playerid)
{
    new text[2048];
    format(text, sizeof text,
        "Раздел\tОписание\n"\
        "Важные места\tМэрия, автошкола, больница, СТО\n"\
        "Работы для новичков\tШахта, грузчик, завод\n"\
        "Основные работы\tМеханики, курьеры, автобусы\n"\
        "Гос. организации\tПолиция, ФСБ, СМИ, армия\n"\
        "Преступные организации\tБазы ОПГ\n"\
        "Транспорт и склады\tТранспортная компания, депо, площадки\n"\
        "Развлечения\tКазино, контейнеры, компьютерный клуб\n"\
        "Банки\tВсе центральные банки\n"\
        "Причалы\tВодные точки\n"\
        "Автосалоны\tСалоны, мотосалон, авторынок\n"\
        "Города и посёлки\tОсновные населённые пункты\n"\
        "Вокзалы\tЖ/д и автобусные точки\n"\
        "Ближайшие места\tАЗС, 24/7, одежда, оружие, казино, тюнинг\n"\
        "Снять GPS-метку\tОтключить текущий маршрут"
    );
    return Dialog(playerid, DIALOG_NAV_GUI_MAIN, DIALOG_STYLE_TABLIST_HEADERS, NAVGUI_DIALOG_TITLE, text, "Выбрать", "Закрыть");
}

stock NavGUI_ShowImportant(playerid)
{
    new text[1024];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_important; i++) NavGUI_AppendRow(text, sizeof text, navgui_important[i][NAVP_NAME], "важная городская точка");
    return Dialog(playerid, DIALOG_NAV_GUI_IMPORTANT, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: важные места", text, "Поставить", "Назад");
}

stock NavGUI_ShowNewbieJobs(playerid)
{
    new text[768];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_newbie_jobs; i++) NavGUI_AppendRow(text, sizeof text, navgui_newbie_jobs[i][NAVP_NAME], "работа для старта");
    return Dialog(playerid, DIALOG_NAV_GUI_NEWBIE_JOBS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: работы для новичков", text, "Поставить", "Назад");
}

stock NavGUI_ShowJobs(playerid)
{
    new text[1024];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_jobs; i++) NavGUI_AppendRow(text, sizeof text, navgui_jobs[i][NAVP_NAME], "основная работа");
    return Dialog(playerid, DIALOG_NAV_GUI_JOBS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: основные работы", text, "Поставить", "Назад");
}

stock NavGUI_ShowStateOrgs(playerid)
{
    new text[1280];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_state_orgs; i++) NavGUI_AppendRow(text, sizeof text, navgui_state_orgs[i][NAVP_NAME], "государственная организация");
    return Dialog(playerid, DIALOG_NAV_GUI_STATE_ORGS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: гос. организации", text, "Поставить", "Назад");
}

stock NavGUI_ShowCrimeOrgs(playerid)
{
    new text[768];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_crime_orgs; i++) NavGUI_AppendRow(text, sizeof text, navgui_crime_orgs[i][NAVP_NAME], "база организации");
    return Dialog(playerid, DIALOG_NAV_GUI_CRIME_ORGS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: преступные организации", text, "Поставить", "Назад");
}

stock NavGUI_ShowTransport(playerid)
{
    new text[1024];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_transport; i++) NavGUI_AppendRow(text, sizeof text, navgui_transport[i][NAVP_NAME], "транспорт / склад");
    return Dialog(playerid, DIALOG_NAV_GUI_TRANSPORT, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: транспорт и склады", text, "Поставить", "Назад");
}

stock NavGUI_ShowEntertainment(playerid)
{
    new text[768];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_entertainment; i++) NavGUI_AppendRow(text, sizeof text, navgui_entertainment[i][NAVP_NAME], "развлечение");
    return Dialog(playerid, DIALOG_NAV_GUI_ENTERTAINMENT, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: развлечения", text, "Поставить", "Назад");
}

stock NavGUI_ShowBanks(playerid)
{
    new text[768];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_banks; i++) NavGUI_AppendRow(text, sizeof text, navgui_banks[i][NAVP_NAME], "банк");
    return Dialog(playerid, DIALOG_NAV_GUI_BANKS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: банки", text, "Поставить", "Назад");
}

stock NavGUI_ShowPiers(playerid)
{
    new text[768];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_piers; i++) NavGUI_AppendRow(text, sizeof text, navgui_piers[i][NAVP_NAME], "причал");
    return Dialog(playerid, DIALOG_NAV_GUI_PIERS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: причалы", text, "Поставить", "Назад");
}

stock NavGUI_ShowAutosalons(playerid)
{
    new text[1280];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_autosalons; i++) NavGUI_AppendRow(text, sizeof text, navgui_autosalons[i][NAVP_NAME], "покупка транспорта");
    return Dialog(playerid, DIALOG_NAV_GUI_AUTOSALONS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: автосалоны", text, "Поставить", "Назад");
}

stock NavGUI_ShowCities(playerid)
{
    new text[1536];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_cities; i++) NavGUI_AppendRow(text, sizeof text, navgui_cities[i][NAVP_NAME], "населённый пункт");
    return Dialog(playerid, DIALOG_NAV_GUI_CITIES, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: города и посёлки", text, "Поставить", "Назад");
}

stock NavGUI_ShowStations(playerid)
{
    new text[768];
    format(text, sizeof text, "Место\tОписание\n");
    for(new i; i < sizeof navgui_stations; i++) NavGUI_AppendRow(text, sizeof text, navgui_stations[i][NAVP_NAME], "вокзал");
    return Dialog(playerid, DIALOG_NAV_GUI_STATIONS, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: вокзалы", text, "Поставить", "Назад");
}

stock NavGUI_ShowNearest(playerid)
{
    new text[1024];
    format(text, sizeof text,
        "Тип\tЧто будет найдено\n"\
        "Ближайшая АЗС\tЗаправка рядом с вами\n"\
        "Ближайший магазин 24/7\tЕда, товары, мелочи\n"\
        "Ближайший магазин одежды\tСмена скина / одежда\n"\
        "Ближайший магазин оружия\tОружейный магазин\n"\
        "Ближайшее казино\tРазвлечения\n"\
        "Ближайший тюнинг\tТюнинг / СТО"
    );
    return Dialog(playerid, DIALOG_NAV_GUI_NEAREST, DIALOG_STYLE_TABLIST_HEADERS, "{FFCD00}Навигатор: ближайшие места", text, "Найти", "Назад");
}

stock NavGUI_GotoPointFromList(playerid, listid, item)
{
    switch(listid)
    {
        case DIALOG_NAV_GUI_IMPORTANT:
        {
            if(0 <= item <= sizeof navgui_important - 1)
                return NavGUI_SetPoint(playerid, navgui_important[item][NAVP_NAME], navgui_important[item][NAVP_MARKER], navgui_important[item][NAVP_X], navgui_important[item][NAVP_Y], navgui_important[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_NEWBIE_JOBS:
        {
            if(0 <= item <= sizeof navgui_newbie_jobs - 1)
                return NavGUI_SetPoint(playerid, navgui_newbie_jobs[item][NAVP_NAME], navgui_newbie_jobs[item][NAVP_MARKER], navgui_newbie_jobs[item][NAVP_X], navgui_newbie_jobs[item][NAVP_Y], navgui_newbie_jobs[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_JOBS:
        {
            if(0 <= item <= sizeof navgui_jobs - 1)
                return NavGUI_SetPoint(playerid, navgui_jobs[item][NAVP_NAME], navgui_jobs[item][NAVP_MARKER], navgui_jobs[item][NAVP_X], navgui_jobs[item][NAVP_Y], navgui_jobs[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_STATE_ORGS:
        {
            if(0 <= item <= sizeof navgui_state_orgs - 1)
                return NavGUI_SetPoint(playerid, navgui_state_orgs[item][NAVP_NAME], navgui_state_orgs[item][NAVP_MARKER], navgui_state_orgs[item][NAVP_X], navgui_state_orgs[item][NAVP_Y], navgui_state_orgs[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_CRIME_ORGS:
        {
            if(0 <= item <= sizeof navgui_crime_orgs - 1)
                return NavGUI_SetPoint(playerid, navgui_crime_orgs[item][NAVP_NAME], navgui_crime_orgs[item][NAVP_MARKER], navgui_crime_orgs[item][NAVP_X], navgui_crime_orgs[item][NAVP_Y], navgui_crime_orgs[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_TRANSPORT:
        {
            if(0 <= item <= sizeof navgui_transport - 1)
                return NavGUI_SetPoint(playerid, navgui_transport[item][NAVP_NAME], navgui_transport[item][NAVP_MARKER], navgui_transport[item][NAVP_X], navgui_transport[item][NAVP_Y], navgui_transport[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_ENTERTAINMENT:
        {
            if(0 <= item <= sizeof navgui_entertainment - 1)
                return NavGUI_SetPoint(playerid, navgui_entertainment[item][NAVP_NAME], navgui_entertainment[item][NAVP_MARKER], navgui_entertainment[item][NAVP_X], navgui_entertainment[item][NAVP_Y], navgui_entertainment[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_BANKS:
        {
            if(0 <= item <= sizeof navgui_banks - 1)
                return NavGUI_SetPoint(playerid, navgui_banks[item][NAVP_NAME], navgui_banks[item][NAVP_MARKER], navgui_banks[item][NAVP_X], navgui_banks[item][NAVP_Y], navgui_banks[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_PIERS:
        {
            if(0 <= item <= sizeof navgui_piers - 1)
                return NavGUI_SetPoint(playerid, navgui_piers[item][NAVP_NAME], navgui_piers[item][NAVP_MARKER], navgui_piers[item][NAVP_X], navgui_piers[item][NAVP_Y], navgui_piers[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_AUTOSALONS:
        {
            if(0 <= item <= sizeof navgui_autosalons - 1)
                return NavGUI_SetPoint(playerid, navgui_autosalons[item][NAVP_NAME], navgui_autosalons[item][NAVP_MARKER], navgui_autosalons[item][NAVP_X], navgui_autosalons[item][NAVP_Y], navgui_autosalons[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_CITIES:
        {
            if(0 <= item <= sizeof navgui_cities - 1)
                return NavGUI_SetPoint(playerid, navgui_cities[item][NAVP_NAME], navgui_cities[item][NAVP_MARKER], navgui_cities[item][NAVP_X], navgui_cities[item][NAVP_Y], navgui_cities[item][NAVP_Z]);
        }
        case DIALOG_NAV_GUI_STATIONS:
        {
            if(0 <= item <= sizeof navgui_stations - 1)
                return NavGUI_SetPoint(playerid, navgui_stations[item][NAVP_NAME], navgui_stations[item][NAVP_MARKER], navgui_stations[item][NAVP_X], navgui_stations[item][NAVP_Y], navgui_stations[item][NAVP_Z]);
        }
    }
    return 1;
}

stock NavGUI_GotoNearestFuel(playerid)
{
    new stationid = GetNearestFuelStation(playerid, 0.0);
    if(stationid == -1) return SendClientMessage(playerid, NAVGUI_COLOR_ERROR, "{FF5252}[Навигатор]{FFFFFF} На сервере не найдено ни одной АЗС.");

    new station_name[64];
    format(station_name, sizeof station_name, "%s", GetFuelStationData(stationid, FS_NAME));
    if(strlen(station_name) < 1) format(station_name, sizeof station_name, "АЗС №%d", stationid);

    new Float:x = GetFuelStationData(stationid, FS_POS_X);
    new Float:y = GetFuelStationData(stationid, FS_POS_Y);
    new Float:z = GetFuelStationData(stationid, FS_POS_Z);
    new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);

    new message[160];
    format(message, sizeof message, "{FF5252}[Навигатор]{FFFFFF} Ближайшая АЗС: %s (%.1f м).", station_name, dist);
    return EnablePlayerGPS(playerid, 47, x, y, z, message);
}

stock NavGUI_GotoNearestBiz(playerid, business_type, marker, const fallback_name[])
{
    new biz_id = GetNearestBiz(playerid, business_type, 0.0);
    if(biz_id == -1)
    {
        new error[144];
        format(error, sizeof error, "{FF5252}[Навигатор]{FFFFFF} Рядом не найдено: %s.", fallback_name);
        return SendClientMessage(playerid, NAVGUI_COLOR_ERROR, error);
    }

    new biz_name[64];
    format(biz_name, sizeof biz_name, "%s", GetBusinessInteriorInfo(GetBusinessData(biz_id, B_INTERIOR), BT_NAME));
    if(strlen(biz_name) < 1) format(biz_name, sizeof biz_name, "%s", fallback_name);

    new Float:x = GetBusinessData(biz_id, B_POS_X);
    new Float:y = GetBusinessData(biz_id, B_POS_Y);
    new Float:z = GetBusinessData(biz_id, B_POS_Z);
    new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);

    new message[160];
    format(message, sizeof message, "{FF5252}[Навигатор]{FFFFFF} Ближайшее место: %s (%.1f м).", biz_name, dist);
    return EnablePlayerGPS(playerid, marker, x, y, z, message);
}

stock NavGUI_HandleNearest(playerid, listitem)
{
    switch(listitem)
    {
        case 0: return NavGUI_GotoNearestFuel(playerid);
        case 1: return NavGUI_GotoNearestBiz(playerid, BUSINESS_TYPE_SHOP_24_7, 23, "магазин 24/7");
        case 2: return NavGUI_GotoNearestBiz(playerid, BUSINESS_TYPE_CLOTHING_SHOP, 45, "магазин одежды");
        case 3: return NavGUI_GotoNearestBiz(playerid, BUSINESS_TYPE_SHOP_GUN, 18, "магазин оружия");
        case 4: return NavGUI_GotoNearestBiz(playerid, BUSINESS_TYPE_CASINO, 27, "казино");
        case 5: return NavGUI_GotoNearestBiz(playerid, BUSINESS_TYPE_CAR_TUNING, 27, "тюнинг-салон");
    }
    return 1;
}

stock NavGUI_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    switch(dialogid)
    {
        case DIALOG_NAV_GUI_MAIN:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: return NavGUI_ShowImportant(playerid);
                case 1: return NavGUI_ShowNewbieJobs(playerid);
                case 2: return NavGUI_ShowJobs(playerid);
                case 3: return NavGUI_ShowStateOrgs(playerid);
                case 4: return NavGUI_ShowCrimeOrgs(playerid);
                case 5: return NavGUI_ShowTransport(playerid);
                case 6: return NavGUI_ShowEntertainment(playerid);
                case 7: return NavGUI_ShowBanks(playerid);
                case 8: return NavGUI_ShowPiers(playerid);
                case 9: return NavGUI_ShowAutosalons(playerid);
                case 10: return NavGUI_ShowCities(playerid);
                case 11: return NavGUI_ShowStations(playerid);
                case 12: return NavGUI_ShowNearest(playerid);
                case 13: return NavGUI_ClearPoint(playerid);
            }
            return 1;
        }
        case DIALOG_NAV_GUI_IMPORTANT,
             DIALOG_NAV_GUI_NEWBIE_JOBS,
             DIALOG_NAV_GUI_JOBS,
             DIALOG_NAV_GUI_STATE_ORGS,
             DIALOG_NAV_GUI_CRIME_ORGS,
             DIALOG_NAV_GUI_TRANSPORT,
             DIALOG_NAV_GUI_ENTERTAINMENT,
             DIALOG_NAV_GUI_BANKS,
             DIALOG_NAV_GUI_PIERS,
             DIALOG_NAV_GUI_AUTOSALONS,
             DIALOG_NAV_GUI_CITIES,
             DIALOG_NAV_GUI_STATIONS:
        {
            if(!response) return NavGUI_ShowMain(playerid);
            return NavGUI_GotoPointFromList(playerid, dialogid, listitem);
        }
        case DIALOG_NAV_GUI_NEAREST:
        {
            if(!response) return NavGUI_ShowMain(playerid);
            return NavGUI_HandleNearest(playerid, listitem);
        }
    }
    return 0;
}

CMD:navigator(playerid, params[])
{
    #pragma unused params
    return NavGUI_ShowMain(playerid);
}
alias:navigator("nav")
