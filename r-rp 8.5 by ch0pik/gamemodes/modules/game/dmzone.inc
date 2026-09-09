const MAX_DMZONE_PLAYERS = 30;
const MIN_DMZONE_PLAYERS = 5;
const DMZONE_VIRTUAL_WORLD = 4;
const MAX_GUN_POSITION     = 20;
const MAX_SPAWN_POSITION = 20;

#define DMZONE_REGISTER_POSITION    -143.0069,398.9308,1001.0000

new Iterator:DmZonePlayers<MAX_PLAYERS>;

new top_kills[MAX_PLAYERS], top_deaths[MAX_PLAYERS], top_players[MAX_PLAYERS];
new top_players_count = 0;
new TopPlayerNames[MAX_PLAYERS][32];

enum E_DMZONE_STRUCT
{
    E_DMZONE_TIMER,
    E_DMZONE_WAIT,
    bool:E_DMZONE_STATUS,
    bool:E_DMZONE_STARTED,
    E_DMZONE_COUNT_PLAYER
}

new g_dmzone_data[E_DMZONE_STRUCT];

enum E_GUN_STRUCT
{
    E_PICKUP_MODEL,
    E_GUN_ID,
    E_GUN_AMMO,
    Float:E_POS_X,
    Float:E_POS_Y,
    Float:E_POS_Z,
    E_GUN_PICKUP,
}

new g_dmzone_spawn_gun[MAX_GUN_POSITION][E_GUN_STRUCT] =
{
    {348, 24, 30, 745.5278,-1733.6185,43.5187},
    {356, 31, 100, 712.1480,-1749.0989,44.2091},
    {355, 30, 100, 710.3478,-1674.4579,43.0223},

    {348, 24, 30, 744.0699,-1734.8220,39.8216},
    {356, 31, 100, 791.2252,-1750.4581,39.2619},
    
    {355, 30, 100, 794.4850,-1733.6083,40.3817},

    {348, 24, 30, 783.5618,-1728.8448,40.9454},
    {356, 31, 100, 837.9748,-1707.2893,46.4863},
    {355, 30, 100, 831.9140,-1760.3024,39.5168},

    {348, 24, 30, 855.3632,-1760.9502,40.6336},
    {356, 31, 100, 836.1272,-1783.9270,40.1262},
    {355, 30, 100, 863.6200,-1719.8787,42.3120},

    {348, 24, 30, 884.0905,-1741.9188,44.9312},
    {356, 31, 100, 843.4468,-1747.5262,44.8243},
    {355, 30, 100, 762.2950,-1762.3953,40.5606},   

    {348, 24, 30, 758.7966,-1763.1235,45.0920},
    {348, 24, 30, 727.5661,-1758.9294,44.1801},
    {348, 24, 30, 720.9855,-1754.1945,43.6393},

    {348, 24, 30, 757.3370,-1743.1810,41.3109},
    {348, 24, 30, 848.5169,-1766.5748,45.5811}
};

new const Float:g_dmzone_player_pos[MAX_SPAWN_POSITION][3] = 
{
    {827.7031,-1755.2126,39.2247},
    {840.7611,-1752.5129,40.0275},
    {875.9033,-1747.9662,40.6247},
    {864.4948,-1717.9510,41.0947},
    {867.0148,-1679.7671,40.6676},
    {825.2789,-1709.5569,40.3949},
    {809.1041,-1792.5261,39.5688},
    {770.3334,-1758.3323,38.8923},
    {777.5060,-1733.8342,39.3345},
    {767.2133,-1703.8391,38.8165},
    {741.3335,-1733.6384,39.8000},
    {755.8830,-1747.5609,39.5031},
    {755.5231,-1763.3126,39.4937},
    {736.8930,-1792.9362,39.4203},
    {716.7511,-1749.8092,40.9252},
    {702.4926,-1722.3546,39.9754},
    {704.5372,-1664.5472,39.5280},
    {801.9078,-1721.6893,39.4998},
    {836.1930,-1788.6104,40.1954},
    {773.3367,-1729.4425,39.4181}
};

stock dmzone_OnGameModeInit()
{
    CreatePickup(1313, 23, DMZONE_REGISTER_POSITION, 0);
    CreateDynamic3DTextLabel("{fab13b}Регистрация на пейнтбол\n{abcdef}Для регистрации используйте клавишу {ffa500}ALT", 0xfab13bFF, -143.0069,398.9308,1001.0000 + 0.5, 5.0);

	return 1;
}


stock dmzone_OnPlayerKeyStateChange(playerid, newkeys)
{

    if(newkeys == KEY_WALK)
    {
        if(g_dmzone_data[E_DMZONE_STARTED])
        {
            for(new idx; idx < sizeof g_dmzone_spawn_gun; idx++)
            {
                if(IsPlayerInRangeOfPoint(playerid, 2.0, g_dmzone_spawn_gun[idx][E_POS_X], g_dmzone_spawn_gun[idx][E_POS_Y], g_dmzone_spawn_gun[idx][E_POS_Z]))
                {
                    //if(g_player[playerid][P_GUN_KD] >= gettime()) return SCM(playerid, 0xC0C0C0FF, "Вы недавно подбирали оружие");

                    //g_player[playerid][P_GUN_KD] = gettime() + 2;

                    if(g_player[playerid][P_DM_TAKE_GUN] == 1) return SCM(playerid, 0xC0C0C0FF, "Вы подбирали данное оружие");

                    GivePlayerWeapon(playerid, g_dmzone_spawn_gun[idx][E_GUN_ID], g_dmzone_spawn_gun[idx][E_GUN_AMMO]);

                    g_player[playerid][P_DM_TAKE_GUN] = 1;
                }
            }
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.5, DMZONE_REGISTER_POSITION))
        {
            if(g_dmzone_data[E_DMZONE_STATUS])
            {
                if(Iter_Contains(DmZonePlayers, playerid)) return SCMF(playerid, 0xC0C0C0FF, "Вы уже зарегистрированы на мероприятие. До начала мероприятия осталось - %d секунд", g_dmzone_data[E_DMZONE_WAIT]);

                if(Iter_Count(DmZonePlayers) >= MAX_DMZONE_PLAYERS) 
                {
                    return SendClientMessage(playerid, 0xC0C0C0FF, "На пейнтбол зарегистрировано максимальное количество участников");
                }
                else
                {
                    Iter_Add(DmZonePlayers, playerid);

                    SendClientMessage(playerid, 0xabcdefFF, "Ожидайте уведомления о начале пейнтбола");
                    SCMF(playerid, 0xfab13bFF, "Вы успешно зарегистрировались на мероприятие под номером: {abcdef}%d", Iter_Count(DmZonePlayers));
                }
            }
            else
            {
                return SCM(playerid, 0xC0C0C0FF, "{fab13b}В данный момент регистрация на пейнтбол - {ff0000}Закрыта");
            }
        }
            
    }

    return false;
}


stock StartDmZone()
{
    g_dmzone_timer = -1;

    g_dmzone_data[E_DMZONE_STATUS] = false;

    g_dmzone_data[E_DMZONE_STARTED] = true;

    g_dmzone_data[E_DMZONE_TIMER] = 600;

    for(new idx; idx < sizeof g_dmzone_spawn_gun; idx++)
    {
        g_dmzone_spawn_gun[idx][E_GUN_PICKUP] = CreatePickup(g_dmzone_spawn_gun[idx][E_PICKUP_MODEL], 23, g_dmzone_spawn_gun[idx][E_POS_X], g_dmzone_spawn_gun[idx][E_POS_Y], g_dmzone_spawn_gun[idx][E_POS_Z], -1);
    }

    new index;

    SendClientMessageToAll(0xffa500ff, "Внимание! Пейнтбол начался");
    
    foreach(new i : DmZonePlayers)
    {
        SetPlayerInterior(i, 0);


        SetPlayerVirtualWorld(i, DMZONE_VIRTUAL_WORLD);

        SetPlayerPos(i, g_dmzone_player_pos[index][0], g_dmzone_player_pos[index][1], g_dmzone_player_pos[index][2]);

        index++;

        GivePlayerWeapon(i, 24, 100);

        TogglePlayerControllable(i, true);

        SetPlayerData(i, P_SKILL_DEAGLE, 100);
        SetPlayerData(i, P_SKILL_M4, 100);
        SetPlayerData(i, P_SKILL_AK47, 100);
        SetPlayerData(i, P_SKILL_MP5, 100);

        if(GetPlayerAdminEx(i) < 5)
        {

            callcmd::outlogin(i);
        }
        SetPlayerSkin(i, 230);
    
    }

    for(new idx; idx < MAX_PLAYERS; idx++)
    {
        top_kills[idx] = -1;
        top_deaths[idx] = -1;

        format(TopPlayerNames[idx], 32, "");    
    }
}

stock EndDmZone()
{
    new j, temp;
    foreach(new i : DmZonePlayers)
    {
        top_kills[i] = g_player[i][P_DM_KILLS];
        top_deaths[i] = g_player[i][P_DM_DEATH];
        
        strcat(TopPlayerNames[i], GetPlayerNameEx(i));

        top_players[i] = i;
        top_players_count++;
    }
    for (new i = 0; i < MAX_PLAYERS - 1; i++)
    {
        for (j = i + 1; j < MAX_PLAYERS; j++)
        {
            if (top_kills[i] < top_kills[j])
            {
                temp = top_kills[i];
                top_kills[i] = top_kills[j];
                top_kills[j] = temp;

                temp = top_deaths[i];
                top_deaths[i] = top_deaths[j];
                top_deaths[j] = temp;

                temp = top_players[i];
                top_players[i] = top_players[j];
                top_players[j] = temp;
            }
        }
    }

    GivePlayerDonate(top_players[0], 45, "Победитель пейнтболла");
    GivePlayerDonate(top_players[1], 30, "Победитель пейнтболла");
    GivePlayerDonate(top_players[2], 15, "Победитель пейнтболла");

    SCM(top_players[0], 0xfab13bFF, "Поздравляем! Вы заняли первое место");
    SCM(top_players[1], 0xfab13bFF, "Поздравляем! Вы заняли второе место");
    SCM(top_players[2], 0xfab13bFF, "Поздравляем! Вы заняли третье место");

    SendClientMessageToAll(0xabcdefFF, "Внимание! Пейнтбол окончен. Список победителей /painlist");

    foreach(new idx : DmZonePlayers)
    {
        
        SetPlayerInterior(idx, 1);
        SetPlayerArmedWeapon(idx, 0);

        SetPlayerVirtualWorld(idx, 0);
        SetPlayerPos(idx, DMZONE_REGISTER_POSITION);

        g_player[idx][P_DM_KILLS] = 0;
        g_player[idx][P_DM_DEATH] = 0;

        if(idx == Iter_Last(DmZonePlayers))
        {
            Iter_Clear(DmZonePlayers);
        }
    }

    g_dmzone_data[E_DMZONE_STATUS] = false;

    g_dmzone_timer = 900;
}

CMD:painlist(playerid)
{
    STRING_GLOBAL[0] = EOS;

    strcat(STRING_GLOBAL, "Место\t\tНик\t\tУбийств\t\tСмертей\n\n");

    for(new idx; idx < top_players_count; idx++)
    {
        if(top_kills[idx] != -1)
        {
            format(STRING_GLOBAL, sizeof STRING_GLOBAL, "%s%d\t\t%s\t\t%d\t\t%d\n", STRING_GLOBAL, idx + 1, TopPlayerNames[top_players[idx]], top_kills[idx], top_deaths[idx]);
        }
    }

    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Список победителей", STRING_GLOBAL, "Закрыть", "");
}

CMD:start_dm_zone(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;

    //if(!IsPlayerOsnova(playerid)) return 1;

    if(g_dmzone_data[E_DMZONE_STARTED]) return SCM(playerid, -1, "В данный момент уже идёт пб");

    SendStartDmZone();

    Iter_Clear(DmZonePlayers);

    return 1;
}

stock SendStartDmZone()
{
    SendClientMessageToAll(0xfab13bFF, "Внимание! Открыта регистрация на пейнтбол");
    SendClientMessageToAll(0xfab13bFF, "Отметить место мероприятия /getpaintball");

    g_dmzone_data[E_DMZONE_STATUS] = true;

    g_dmzone_data[E_DMZONE_WAIT] = 300;
}