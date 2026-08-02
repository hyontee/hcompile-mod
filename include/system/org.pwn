// автор слива @nexus_gei
// пишите в своем пвн (моде) просто: #include #include "../include/system/org.pwn" 
// и компилируете мод!
// если будут ошибки пишите в лс @yebanveseniychelovek  помогу
// спасибо за внимание !!

#define GOVNPC_RADIUS           (2.5)
#define GOVNPC_LABEL_DIST       (8.0)

#define DIALOG_GOVNPC_MENU      (12801)
#define DIALOG_GOVNPC_INFO      (12802)
#define DIALOG_GOVNPC_STAFF     (12803)

#define GOVNPC_GOV      0
#define GOVNPC_FSB      1
#define GOVNPC_SMI      2
#define GOVNPC_UMVD     3
#define GOVNPC_GIBDD    4
#define GOVNPC_CB       5
#define GOVNPC_COUNT    6

enum e_gov_npc_data
{
    GNPC_SKIN,
    Float:GNPC_X,
    Float:GNPC_Y,
    Float:GNPC_Z,
    Float:GNPC_A,
    GNPC_WORLD,
    GNPC_INTERIOR,
    GNPC_TEAM,          
    GNPC_NAME[32],
    GNPC_INFO[192]
}

new gGovNpcData[GOVNPC_COUNT][e_gov_npc_data] =
{
    // skin, x, y, z, angle, world, interior, team(заполняется в Init), название, инфо-текст
    {17,  -878.519226, -1593.920043, 1398.501098, 343.628326, 1,   1, 0, "Правительство", "Дежурный по Правительству. Доступ имеют только действующие сотрудники Правительства."},
    {163, 2914.058349,  1997.271118,  2051.028564, 357.213317, 1,   1, 0, "ФСБ",           "Дежурный по ФСБ. Доступ имеют только действующие сотрудники ФСБ."},
    {188, 1980.068115,  -9.491991,    1381.043579, 245.322677, 1,   1, 0, "СМИ",           "Дежурный по СМИ. Доступ имеют только действующие сотрудники СМИ."},
    {72,  -1090.981079, 1521.961059,  1499.987304, 83.969673,  103, 1, 0, "УМВД",          "Дежурный по УМВД. Доступ имеют только действующие сотрудники УМВД."},
    {72,  -1090.838867, 1521.633422,  1499.987304, 85.100059,  101, 1, 0, "ГИБДД",         "Дежурный по ГИБДД. Доступ имеют только действующие сотрудники ГИБДД."},
    {70,  1501.189453,  2532.345947,  2501.040283, 177.372039, 1,   1, 0, "ЦБ",            "Дежурный по ЦБ. Доступ имеют только действующие сотрудники больницы."}
};

new gGovNpcActor[GOVNPC_COUNT];
new Text3D:gGovNpcLabel[GOVNPC_COUNT] = {Text3D:INVALID_3DTEXT_ID, ...};
new gGovNpcNear[MAX_PLAYERS];
new gGovNpcActiveIdx[MAX_PLAYERS];
new gGovNpcLastCheckTick[MAX_PLAYERS];

#define GOVNPC_RECHECK_INTERVAL (2000)

{
    format(out_name, out_len, "%s", g_organization[team_id][O_NAME]);
    return 1;
}

stock GovNpc_Init()
{
    gGovNpcData[GOVNPC_GOV][GNPC_TEAM]   = TEAM_GOVERNMENT;
    gGovNpcData[GOVNPC_FSB][GNPC_TEAM]   = TEAM_FBI;
    gGovNpcData[GOVNPC_SMI][GNPC_TEAM]   = TEAM_RADIO;
    gGovNpcData[GOVNPC_UMVD][GNPC_TEAM]  = TEAM_PPS;
    gGovNpcData[GOVNPC_GIBDD][GNPC_TEAM] = TEAM_DPS;
    gGovNpcData[GOVNPC_CB][GNPC_TEAM]    = TEAM_HOSPITAL;

    for(new i = 0; i < GOVNPC_COUNT; i++)
    {
        gGovNpcActor[i] = CreateActor(gGovNpcData[i][GNPC_SKIN], gGovNpcData[i][GNPC_X], gGovNpcData[i][GNPC_Y], gGovNpcData[i][GNPC_Z], gGovNpcData[i][GNPC_A]);
        SetActorVirtualWorld(gGovNpcActor[i], gGovNpcData[i][GNPC_WORLD]);
        SetActorInvulnerable(gGovNpcActor[i], true);

        gGovNpcLabel[i] = CreateDynamic3DTextLabel(
            "{FFFFFF}Дежурный",
            0x00CCFFFF,
            gGovNpcData[i][GNPC_X], gGovNpcData[i][GNPC_Y], gGovNpcData[i][GNPC_Z] + 1.05,
            GOVNPC_LABEL_DIST,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
            gGovNpcData[i][GNPC_WORLD], gGovNpcData[i][GNPC_INTERIOR]
        );
    }
    printf("[GovNpcSystem] Создано NPC: %d (Правительство/ФСБ/СМИ/УМВД/ГИБДД/ЦБ)", GOVNPC_COUNT);
    return 1;
}

stock GovNpc_OnPlayerConnect(playerid)
{
    gGovNpcNear[playerid] = -1;
    gGovNpcActiveIdx[playerid] = -1;
    return 1;
}


stock GovNpc_OnPlayerUpdate(playerid)
{
    new near_idx = -1;

    for(new i = 0; i < GOVNPC_COUNT; i++)
    {
        if(GetPlayerVirtualWorld(playerid) != gGovNpcData[i][GNPC_WORLD]) continue;
        if(GetPlayerInterior(playerid) != gGovNpcData[i][GNPC_INTERIOR]) continue;

        if(IsPlayerInRangeOfPoint(playerid, GOVNPC_RADIUS, gGovNpcData[i][GNPC_X], gGovNpcData[i][GNPC_Y], gGovNpcData[i][GNPC_Z]))
        {
            near_idx = i;
            break;
        }
    }

    if(near_idx != -1)
    {
        if(gGovNpcNear[playerid] != near_idx)
        {
            // РўРѕР»СЊРєРѕ С‡С‚Рѕ РїРѕРґРѕС€Р»Рё Рє РїРѕСЃС‚Сѓ вЂ” РїРµСЂРІР°СЏ РїСЂРѕРІРµСЂРєР° РґРѕСЃС‚СѓРїР°.
            gGovNpcNear[playerid] = near_idx;
            gGovNpcLastCheckTick[playerid] = GetTickCount();
            GovNpc_TryOpenMenu(playerid, near_idx);
        }
        else if(gGovNpcActiveIdx[playerid] != near_idx)
        {
            if(GetTickCount() - gGovNpcLastCheckTick[playerid] > GOVNPC_RECHECK_INTERVAL)
            {
                gGovNpcLastCheckTick[playerid] = GetTickCount();
                GovNpc_TryOpenMenu(playerid, near_idx);
            }
        }
    }
    else
    {
        gGovNpcNear[playerid] = -1;
    }
    return 1;
}


stock GovNpc_TryOpenMenu(playerid, idx)
{
    new bool:is_admin = (GetPlayerData(playerid, P_ADMIN_STATUS) > 0);
    new bool:is_staff = (GetPlayerTeamEx(playerid) == gGovNpcData[idx][GNPC_TEAM]);

    if(!is_staff && !is_admin)
    {
        new msg[128];
        format(msg, sizeof(msg), "Доступ только для: %s", gGovNpcData[idx][GNPC_NAME]);
        ShowNotificationKirill(playerid, 2, 5, 0, 0, "Доступ запрещён", msg);
        return 0;
    }

    gGovNpcActiveIdx[playerid] = idx;

    Dialog(playerid, DIALOG_GOVNPC_MENU, DIALOG_STYLE_LIST, "Дежурный", "Информация\nЗадания\nСотрудники", "Выбрать", "Отмена");
    return 1;
}


stock GovNpc_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_GOVNPC_MENU)
    {
        if(!response) return 1;

        new idx = gGovNpcActiveIdx[playerid];
        if(idx < 0 || idx >= GOVNPC_COUNT) return 1;

        switch(listitem)
        {
            case 0: // Информация
            {
                new msg[256];
                format(msg, sizeof(msg), "Пост: %s\n\n%s", gGovNpcData[idx][GNPC_NAME], gGovNpcData[idx][GNPC_INFO]);
                Dialog(playerid, DIALOG_GOVNPC_INFO, DIALOG_STYLE_MSGBOX, "Информация", msg, "Ок", "");
            }
            case 1: // Задания
            {
                ShowNotificationKirill(playerid, 2, 5, 0, 0, "Задания", "Раздел заданий в разработке");
            }
            case 2: // Сотрудники
            {
                new list[600];
                new count = 0;

                format(list, sizeof(list), "Сотрудники на посту \"%s\":\n\n", gGovNpcData[idx][GNPC_NAME]);

                for(new i = 0; i < MAX_PLAYERS; i++)
                {
                    if(!IsPlayerConnected(i)) continue;
                    if(GetPlayerTeamEx(i) != gGovNpcData[idx][GNPC_TEAM]) continue;

                    new pname[MAX_PLAYER_NAME];
                    GetPlayerName(i, pname, sizeof(pname));
                    format(list, sizeof(list), "%s%s (ID: %d)\n", list, pname, i);
                    count++;
                }

                if(count == 0)
                {
                    format(list, sizeof(list), "%sНикого нет в сети.", list);
                }

                Dialog(playerid, DIALOG_GOVNPC_STAFF, DIALOG_STYLE_MSGBOX, "Сотрудники", list, "Ок", "");
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_GOVNPC_INFO || dialogid == DIALOG_GOVNPC_STAFF)
    {
        return 1;
    }

    return 0;
}

// автор слива @nexus_gei
// пишите в своем пвн (моде) просто: #include "../include/system/org.pwn" 
// и компилируете мод!
// если будут ошибки пишите в лс @yebanveseniychelovek  помогу
// спасибо за внимание !!
