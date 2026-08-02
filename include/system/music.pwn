#if defined _BR_MUSIC_SYSTEM_INCLUDED
    #endinput
#endif
#define _BR_MUSIC_SYSTEM_INCLUDED

#define BRMUS_DIALOG_MAIN      45910
#define BRMUS_DIALOG_RADIO     45911
#define BRMUS_DIALOG_SONGS     45912

#define BRMUS_TD_COLOR         0xFFFFFFFF

enum E_BRMUS_ITEM
{
    br_name[48],
    br_link[160],
    br_dur
};

static const BRMUS_Radios[][E_BRMUS_ITEM] =
{
    {"DFM (RU)", "http://dfm.hostingradio.ru/dfm128.mp3", 0},
    {"Русское Радио (RU)", "http://rusradio.hostingradio.ru/rusradio128.mp3", 0},
    {"Наше Радио (RU)", "http://nashe.streamr.ru/nashe-128.mp3", 0},
    {"Европа Плюс (RU)", "http://ep256.hostingradio.ru:8052/europaplus256.mp3", 0},
    {"Ретро FM (RU)", "http://retroserver.streamr.ru:8043/retro256.mp3", 0},
    {"Love Radio (RU)", "http://stream.love-radio.ru/love128.mp3", 0},
    {"Радио Шансон (RU)", "http://chanson.hostingradio.ru:8041/chanson256.mp3", 0},
    {"Радио MAXIMUM (RU)", "http://maximum.hostingradio.ru/maximum128.mp3", 0},
    {"Monte Carlo (RU)", "http://montecarlo.hostingradio.ru/montecarlo128.mp3", 0},
    {"Record - Main (RU)", "http://air.radiorecord.ru:805/rr_128", 0},
    {"Record - Russian Mix", "http://air.radiorecord.ru:805/rr_rus_128", 0},
    {"Record - 90s", "http://air.radiorecord.ru:805/rr_sd90_128", 0},
    {"Record - Chill-Out", "http://air.radiorecord.ru:805/rr_chill_128", 0},
    {"Record - Deep", "http://air.radiorecord.ru:805/rr_deep_128", 0},
    {"Record - Rock", "http://air.radiorecord.ru:805/rr_rock_128", 0},
    {"Record - Rap", "http://air.radiorecord.ru:805/rr_rap_128", 0},
    {"Record - Trance", "http://air.radiorecord.ru:805/rr_trance_128", 0},
    {"Classic FM (EN)", "http://media-ice.musicradio.com/ClassicFMMP3", 0},
    {"Smooth Radio (EN)", "http://media-ice.musicradio.com/SmoothUKMP3", 0},
    {"Kiss FM (EN)", "http://icecast.thisisdax.com/KISSFMMP3", 0},
    {"Capital FM (EN)", "http://media-ice.musicradio.com/CapitalMP3", 0}
};

static const BRMUS_Songs[][E_BRMUS_ITEM] =
{
    {"Новогодний микс 01", "http://dfm.hostingradio.ru/dfm128.mp3", 180},
    {"Новогодний микс 02", "http://dfm.hostingradio.ru/dfm128.mp3", 195},
    {"Новогодний микс 03", "http://dfm.hostingradio.ru/dfm128.mp3", 210},
    {"Новогодний микс 04", "http://dfm.hostingradio.ru/dfm128.mp3", 175},
    {"Новогодний микс 05", "http://dfm.hostingradio.ru/dfm128.mp3", 200},
    {"Праздничный вайб 06", "http://dfm.hostingradio.ru/dfm128.mp3", 190},
    {"Праздничный вайб 07", "http://dfm.hostingradio.ru/dfm128.mp3", 205},
    {"Праздничный вайб 08", "http://dfm.hostingradio.ru/dfm128.mp3", 220},
    {"Праздничный вайб 09", "http://dfm.hostingradio.ru/dfm128.mp3", 185},
    {"Праздничный вайб 10", "http://dfm.hostingradio.ru/dfm128.mp3", 215},
    {"Снежный драйв 11", "http://dfm.hostingradio.ru/dfm128.mp3", 180},
    {"Снежный драйв 12", "http://dfm.hostingradio.ru/dfm128.mp3", 200},
    {"Снежный драйв 13", "http://dfm.hostingradio.ru/dfm128.mp3", 210},
    {"Снежный драйв 14", "http://dfm.hostingradio.ru/dfm128.mp3", 195},
    {"Снежный драйв 15", "http://dfm.hostingradio.ru/dfm128.mp3", 205},
    {"Ёлка & Биты 16", "http://dfm.hostingradio.ru/dfm128.mp3", 180},
    {"Ёлка & Биты 17", "http://dfm.hostingradio.ru/dfm128.mp3", 190},
    {"Ёлка & Биты 18", "http://dfm.hostingradio.ru/dfm128.mp3", 200},
    {"Ёлка & Биты 19", "http://dfm.hostingradio.ru/dfm128.mp3", 210},
    {"Ёлка & Биты 20", "http://dfm.hostingradio.ru/dfm128.mp3", 220},
    {"New Year Party 21", "http://dfm.hostingradio.ru/dfm128.mp3", 180},
    {"New Year Party 22", "http://dfm.hostingradio.ru/dfm128.mp3", 190},
    {"New Year Party 23", "http://dfm.hostingradio.ru/dfm128.mp3", 200},
    {"New Year Party 24", "http://dfm.hostingradio.ru/dfm128.mp3", 210},
    {"New Year Party 25", "http://dfm.hostingradio.ru/dfm128.mp3", 220},
    {"Winter Night 26", "http://dfm.hostingradio.ru/dfm128.mp3", 180},
    {"Winter Night 27", "http://dfm.hostingradio.ru/dfm128.mp3", 190},
    {"Winter Night 28", "http://dfm.hostingradio.ru/dfm128.mp3", 200},
    {"Winter Night 29", "http://dfm.hostingradio.ru/dfm128.mp3", 210},
    {"Winter Night 30", "http://dfm.hostingradio.ru/dfm128.mp3", 220}
};

static bool:brmus_inited;
static brmus_last_choice[MAX_PLAYERS];
static bool:brmus_last_is_radio[MAX_PLAYERS];
static brmus_last_link[MAX_PLAYERS][160];
static brmus_last_title[MAX_PLAYERS][64];

static Text:brmus_td_title[MAX_PLAYERS] = {Text:INVALID_TEXT_DRAW, ...};
static Text:brmus_td_time[MAX_PLAYERS]  = {Text:INVALID_TEXT_DRAW, ...};

static brmus_playing_index[MAX_VEHICLES] = {-1, ...};
static bool:brmus_playing_is_radio[MAX_VEHICLES];
static brmus_playing_link[MAX_VEHICLES][160];
static brmus_playing_title[MAX_VEHICLES][64];
static brmus_started_tick[MAX_VEHICLES];
static brmus_total_sec[MAX_VEHICLES];

stock BRMUS_InitOnce()
{
    if (brmus_inited) return 1;
    brmus_inited = true;

    print("[TED_SYSTEM] Система музыки загружена");

    for (new v=0; v<MAX_VEHICLES; v++)
    {
        brmus_playing_index[v] = -1;
        brmus_playing_is_radio[v] = false;
        brmus_playing_link[v][0] = '\0';
        brmus_playing_title[v][0] = '\0';
        brmus_started_tick[v] = 0;
        brmus_total_sec[v] = 0;
    }
    for (new p=0; p<MAX_PLAYERS; p++)
    {
        brmus_last_choice[p] = -1;
        brmus_last_is_radio[p] = true;
        brmus_last_link[p][0] = '\0';
        brmus_last_title[p][0] = '\0';
    }
    return 1;
}

static stock bool:BRMUS_IsLinkOK(const link[])
{
    if (!link[0]) return false;
    if (strfind(link, "http://", true) != 0) return false;
    if (strfind(link, ".m3u", true) != -1) return false;
    if (strfind(link, ".pls", true) != -1) return false;
    if (strfind(link, ".m3u8", true) != -1) return false;
    if (strfind(link, ".aac", true) != -1) return false;
    if (strfind(link, ".aacp", true) != -1) return false;
    if (strfind(link, ".ogg", true) != -1) return false;
    if (strfind(link, ".wav", true) != -1) return false;
    return true;
}

stock BRMUS_StopAudioStream(playerid)
{
    #if defined PR_SendRPC && defined BS_New
        new BitStream:bs = BS_New();
        BS_WriteValue(bs, PR_INT32, 1);
        BS_WriteValue(bs, PR_UINT8, 0);
        BS_WriteValue(bs, PR_INT32, 0);
        BS_WriteValue(bs, PR_FLOAT, 0.0);
        BS_WriteValue(bs, PR_UINT8, 1);
        PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
        BS_Delete(bs);
    #else
        StopAudioStreamForPlayer(playerid);
    #endif
    return 1;
}

static stock BRMUS_TD_Create(playerid)
{
    if (brmus_td_title[playerid] != Text:INVALID_TEXT_DRAW) return 1;

    brmus_td_title[playerid] = TextDrawCreate(425.0, 380.0, " ");
    TextDrawFont(brmus_td_title[playerid], 1);
    TextDrawLetterSize(brmus_td_title[playerid], 0.20, 1.00);
    TextDrawColor(brmus_td_title[playerid], BRMUS_TD_COLOR);
    TextDrawSetOutline(brmus_td_title[playerid], 1);
    TextDrawSetProportional(brmus_td_title[playerid], 1);

    brmus_td_time[playerid] = TextDrawCreate(425.0, 395.0, " ");
    TextDrawFont(brmus_td_time[playerid], 1);
    TextDrawLetterSize(brmus_td_time[playerid], 0.20, 1.00);
    TextDrawColor(brmus_td_time[playerid], BRMUS_TD_COLOR);
    TextDrawSetOutline(brmus_td_time[playerid], 1);
    TextDrawSetProportional(brmus_td_time[playerid], 1);
    return 1;
}

static stock BRMUS_TD_Show(playerid)
{
    BRMUS_TD_Create(playerid);
    TextDrawShowForPlayer(playerid, brmus_td_title[playerid]);
    TextDrawShowForPlayer(playerid, brmus_td_time[playerid]);
    return 1;
}

static stock BRMUS_TD_Hide(playerid)
{
    if (brmus_td_title[playerid] == Text:INVALID_TEXT_DRAW) return 1;
    TextDrawHideForPlayer(playerid, brmus_td_title[playerid]);
    TextDrawHideForPlayer(playerid, brmus_td_time[playerid]);
    return 1;
}

static stock BRMUS_TimeStr(secs, outStr[6])
{
    if (secs < 0) secs = 0;
    new mm = secs / 60;
    new ss = secs % 60;
    if (mm > 99) mm = 99;
    outStr[0] = '0' + (mm / 10);
    outStr[1] = '0' + (mm % 10);
    outStr[2] = ':';
    outStr[3] = '0' + (ss / 10);
    outStr[4] = '0' + (ss % 10);
    outStr[5] = 0;
    return 1;
}

static stock BRMUS_TD_UpdateForVehicle(vehicleid)
{
    if (vehicleid == INVALID_VEHICLE_ID) return 1;
    if (brmus_playing_index[vehicleid] == -1) return 1;

    new now = GetTickCount();
    new elapsed = (now - brmus_started_tick[vehicleid]) / 1000;

    new titleLine[96], timeLine[64], t1[6], t2[6];
    BRMUS_TimeStr(elapsed, t1);

    if (brmus_playing_is_radio[vehicleid])
    {
        format(titleLine, sizeof titleLine, "Radio: %s", brmus_playing_title[vehicleid]);
        format(timeLine, sizeof timeLine, "Time: %s/LIVE", t1);
    }
    else
    {
        format(titleLine, sizeof titleLine, "Song: %s", brmus_playing_title[vehicleid]);
        if (brmus_total_sec[vehicleid] > 0) BRMUS_TimeStr(brmus_total_sec[vehicleid], t2);
        else { t2[0]='-'; t2[1]='-'; t2[2]=':'; t2[3]='-'; t2[4]='-'; t2[5]=0; }
        format(timeLine, sizeof timeLine, "Time: %s/%s", t1, t2);
    }

    for (new p=0; p<MAX_PLAYERS; p++)
    {
        if (!IsPlayerConnected(p)) continue;
        if (GetPlayerVehicleID(p) != vehicleid) continue;
        if (GetPlayerState(p) != PLAYER_STATE_DRIVER && GetPlayerState(p) != PLAYER_STATE_PASSENGER) continue;

        BRMUS_TD_Create(p);
        TextDrawSetString(brmus_td_title[p], titleLine);
        TextDrawSetString(brmus_td_time[p], timeLine);
        BRMUS_TD_Show(p);
    }
    return 1;
}

static stock BRMUS_StopForVehicle(vehicleid)
{
    if (vehicleid == INVALID_VEHICLE_ID) return 1;
    if (brmus_playing_index[vehicleid] == -1) return 1;

    for (new p=0; p<MAX_PLAYERS; p++)
    {
        if (!IsPlayerConnected(p)) continue;
        if (GetPlayerVehicleID(p) != vehicleid) continue;
        if (GetPlayerState(p) != PLAYER_STATE_DRIVER && GetPlayerState(p) != PLAYER_STATE_PASSENGER) continue;

        BRMUS_StopAudioStream(p);
        BRMUS_TD_Hide(p);
    }

    brmus_playing_index[vehicleid] = -1;
    brmus_playing_is_radio[vehicleid] = false;
    brmus_playing_link[vehicleid][0] = '\0';
    brmus_playing_title[vehicleid][0] = '\0';
    brmus_started_tick[vehicleid] = 0;
    brmus_total_sec[vehicleid] = 0;
    return 1;
}

static stock BRMUS_StartForVehicle(vehicleid, bool:is_radio, const link[], const title[], idx, totalSec)
{
    if (vehicleid == INVALID_VEHICLE_ID) return 1;
    if (!BRMUS_IsLinkOK(link)) return 0;

    brmus_playing_index[vehicleid] = idx;
    brmus_playing_is_radio[vehicleid] = is_radio;
    format(brmus_playing_link[vehicleid], 160, "%s", link);
    format(brmus_playing_title[vehicleid], 64, "%s", title);
    brmus_started_tick[vehicleid] = GetTickCount();
    brmus_total_sec[vehicleid] = totalSec;

    for (new p=0; p<MAX_PLAYERS; p++)
    {
        if (!IsPlayerConnected(p)) continue;
        if (GetPlayerVehicleID(p) != vehicleid) continue;
        if (GetPlayerState(p) != PLAYER_STATE_DRIVER && GetPlayerState(p) != PLAYER_STATE_PASSENGER) continue;

        PlayAudioStreamURL(p, link);
        format(brmus_last_link[p], 160, "%s", link);
        format(brmus_last_title[p], 64, "%s", title);
        brmus_last_is_radio[p] = is_radio;
        brmus_last_choice[p] = idx;
        BRMUS_TD_Show(p);
    }
    BRMUS_TD_UpdateForVehicle(vehicleid);
    return 1;
}

static stock BRMUS_ShowMain(playerid)
{
    ShowPlayerDialog(playerid, BRMUS_DIALOG_MAIN, DIALOG_STYLE_LIST, "Музыка", "Радио\nПесни\nВыключить", "ОК", "Назад");
    return 1;
}

static stock BRMUS_ShowRadios(playerid)
{
    new list[4096]; list[0] = '\0';
    for (new i=0; i<sizeof(BRMUS_Radios); i++)
    {
        strcat(list, BRMUS_Radios[i][br_name]);
        strcat(list, "\n");
    }
    ShowPlayerDialog(playerid, BRMUS_DIALOG_RADIO, DIALOG_STYLE_LIST, "Радио", list, "Включить", "Назад");
    return 1;
}

static stock BRMUS_ShowSongs(playerid)
{
    new list[4096]; list[0] = '\0';
    for (new i=0; i<sizeof(BRMUS_Songs); i++)
    {
        strcat(list, BRMUS_Songs[i][br_name]);
        strcat(list, "\n");
    }
    ShowPlayerDialog(playerid, BRMUS_DIALOG_SONGS, DIALOG_STYLE_LIST, "Песни", list, "Включить", "Назад");
    return 1;
}

CMD:music(playerid, params[])
{
    #pragma unused params
    BRMUS_InitOnce();

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, 0xFF6666FF, "Музыку в машине может включать только водитель.");

    BRMUS_ShowMain(playerid);
    return 1;
}

stock BRMUS_HandleDialogResponse(playerid, dialogid, response, listitem)
{
    if (dialogid == BRMUS_DIALOG_MAIN)
    {
        if (!response) return 1;
        if (listitem == 0) return BRMUS_ShowRadios(playerid);
        if (listitem == 1) return BRMUS_ShowSongs(playerid);
        if (listitem == 2)
        {
            new v = GetPlayerVehicleID(playerid);
            if (v != 0) BRMUS_StopForVehicle(v);
            SendClientMessage(playerid, 0xFFFFFFFF, "Музыка выключена.");
            return 1;
        }
        return 1;
    }

    if (dialogid == BRMUS_DIALOG_RADIO)
    {
        if (!response) return BRMUS_ShowMain(playerid);
        if (listitem < 0 || listitem >= sizeof(BRMUS_Radios)) return 1;

        new v2 = GetPlayerVehicleID(playerid);
        if (v2 == 0) return 1;
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

        BRMUS_StopForVehicle(v2);
        if (!BRMUS_StartForVehicle(v2, true, BRMUS_Radios[listitem][br_link], BRMUS_Radios[listitem][br_name], listitem, 0))
            return SendClientMessage(playerid, 0xFF6666FF, "Ссылка не подходит (нужен http:// поток).");

        SendClientMessage(playerid, 0x66FF66FF, "Радио включено.");
        return 1;
    }

    if (dialogid == BRMUS_DIALOG_SONGS)
    {
        if (!response) return BRMUS_ShowMain(playerid);
        if (listitem < 0 || listitem >= sizeof(BRMUS_Songs)) return 1;

        new v3 = GetPlayerVehicleID(playerid);
        if (v3 == 0) return 1;
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

        BRMUS_StopForVehicle(v3);
        if (!BRMUS_StartForVehicle(v3, false, BRMUS_Songs[listitem][br_link], BRMUS_Songs[listitem][br_name], listitem, BRMUS_Songs[listitem][br_dur]))
            return SendClientMessage(playerid, 0xFF6666FF, "Ссылка не подходит (нужен http:// поток).");

        SendClientMessage(playerid, 0x66FF66FF, "Трек включён.");
        return 1;
    }

    return 0;
}

stock BRMUS_HandlePlayerStateChange(playerid, newstate, oldstate)
{
    BRMUS_InitOnce();

    if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
    {
        BRMUS_StopAudioStream(playerid);
        BRMUS_TD_Hide(playerid);
    }

    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        new v = GetPlayerVehicleID(playerid);
        if (v != 0 && brmus_playing_index[v] != -1)
        {
            PlayAudioStreamURL(playerid, brmus_playing_link[v]);
            BRMUS_TD_Show(playerid);
            BRMUS_TD_UpdateForVehicle(v);
        }
    }
    return 1;
}

stock BRMUS_HandleVehicleDeath(vehicleid)
{
    BRMUS_InitOnce();
    BRMUS_StopForVehicle(vehicleid);
    return 1;
}

stock BRMUS_Tick()
{
    for (new v=1; v<MAX_VEHICLES; v++)
        if (brmus_playing_index[v] != -1)
            BRMUS_TD_UpdateForVehicle(v);
    return 1;
}

stock BRMUS_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    return BRMUS_HandleDialogResponse(playerid, dialogid, response, listitem);
}

stock BRMUS_HandleStateChange(playerid, newstate, oldstate)
{
    return BRMUS_HandlePlayerStateChange(playerid, newstate, oldstate);
}