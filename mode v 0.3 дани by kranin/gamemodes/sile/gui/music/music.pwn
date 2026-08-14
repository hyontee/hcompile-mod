#define BR_AUDIO_GUI_ID                  (9)
#define BR_MUSIC_PAGE_SIZE               (4)
#define BR_MUSIC_INVALID_TRACK           (-1)
#define BR_AUDIO_TAB_RADIO               (1)
#define BR_AUDIO_TAB_LIBRARY             (2)
#define BR_MUSIC_MODE_CAR                (0)
#define BR_MUSIC_MODE_PLAYER             (1)
#define DIALOG_BR_MUSIC_BUY              (31337)

new g_BRMusicRadioPage[MAX_PLAYERS];
new g_BRMusicLibPage[MAX_PLAYERS];
new g_BRMusicActiveRadio[MAX_PLAYERS];
new g_BRMusicActiveLib[MAX_PLAYERS];

enum E_BR_MUSIC_DATA
{
    BR_MUSIC_NAME[80],
    BR_MUSIC_URL[200],
    BR_MUSIC_PRICE
};

// Библиотека на прямых open-internet MP3 ссылках, чтобы исключить дохлые старые muzonovs.
new const g_BRMusicList[][E_BR_MUSIC_DATA] =
{
    {"SoundHelix - Song 1",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", 50},
    {"SoundHelix - Song 2",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", 120},
    {"SoundHelix - Song 3",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", 0},
    {"SoundHelix - Song 4",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", 0},
    {"SoundHelix - Song 5",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3", 0},
    {"SoundHelix - Song 6",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3", 0},
    {"SoundHelix - Song 7",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3", 0},
    {"SoundHelix - Song 8",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3", 0},
    {"SoundHelix - Song 9",  "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3", 0},
    {"SoundHelix - Song 10", "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3", 0},
    {"SoundHelix - Song 11", "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3", 0},
    {"SoundHelix - Song 12", "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3", 0},
    {"SoundHelix - Song 13", "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3", 0},
    {"SoundHelix - Song 14", "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3", 0},
    {"SoundHelix - Song 15", "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3", 0},
    {"SoundHelix - Song 16", "http://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3", 0}
};


stock BRMusic_GetPageCount(total)
{
    if(total <= 0) return 1;
    return (total + BR_MUSIC_PAGE_SIZE - 1) / BR_MUSIC_PAGE_SIZE;
}

stock BRMusic_GetPageButtons(page, total)
{
    new buttons = 0;
    if(page < BRMusic_GetPageCount(total) - 1) buttons |= 1;
    if(page > 0) buttons |= 2;
    buttons |= 4;
    return buttons;
}

stock BRMusic_Notify(playerid, type, text[])
{
    ShowNotificationSile(playerid, type, 5, 0, 0, text, "");
    return 1;
}

stock BRMusic_CloseGui(playerid)
{
    new Node:j = JSON_Object();
    JSON_SetInt(j, "c", 1);
    SendPacketToClient(playerid, BR_AUDIO_GUI_ID, j);
    JSON_Cleanup(j);
    return 1;
}

stock BRMusic_PlayerOwnsTrack(playerid, trackid)
{
    if(trackid < 0 || trackid >= sizeof(g_BRMusicList)) return 0;
    if(g_BRMusicList[trackid][BR_MUSIC_PRICE] <= 0) return 1;
    new pvar[32];
    format(pvar, sizeof(pvar), "br_music_%d", trackid);
    return GetPVarInt(playerid, pvar);
}

stock BRMusic_SetPlayerOwnsTrack(playerid, trackid)
{
    new pvar[32];
    format(pvar, sizeof(pvar), "br_music_%d", trackid);
    SetPVarInt(playerid, pvar, 1);
    return 1;
}

stock BRMusic_LoadPurchases(playerid)
{
    new query[160];
    mysql_format(mysql, query, sizeof(query), "SELECT track_id FROM player_music WHERE account_id=%d", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "BRMusic_OnPurchasesLoaded", "i", playerid);
    return 1;
}

forward BRMusic_OnPurchasesLoaded(playerid);
public BRMusic_OnPurchasesLoaded(playerid)
{
    new rows = cache_get_row_count();
    for(new i = 0; i < rows; i++)
    {
        new trackid = cache_get_field_content_int(i, "track_id");
        if(trackid >= 0 && trackid < sizeof(g_BRMusicList)) BRMusic_SetPlayerOwnsTrack(playerid, trackid);
    }
    return 1;
}

stock BRMusic_OpenGui(playerid, mode)
{
    SetPVarInt(playerid, "br_music_gui_mode", mode);
    BRMusic_LoadPurchases(playerid);
    g_BRMusicRadioPage[playerid] = 0;
    g_BRMusicLibPage[playerid] = 0;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    SendPacketToClient(playerid, BR_AUDIO_GUI_ID, json);
    JSON_Cleanup(json);

    SetTimerEx("BRMusic_SendRadioPage", 700, false, "i", playerid);
    SetTimerEx("BRMusic_SendLibPage", 1500, false, "i", playerid);
    return 1;
}

stock BRMusic_GetActiveTab(playerid)
{
    if(g_BRMusicActiveLib[playerid] != BR_MUSIC_INVALID_TRACK) return BR_AUDIO_TAB_LIBRARY;
    if(g_BRMusicActiveRadio[playerid] != BR_MUSIC_INVALID_TRACK) return BR_AUDIO_TAB_RADIO;
    return 0;
}

forward BRMusic_SendRadioPage(playerid);
public BRMusic_SendRadioPage(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new page = g_BRMusicRadioPage[playerid];
    new total = sizeof(g_server_radio);
    new pages = BRMusic_GetPageCount(total);
    if(page < 0) page = 0;
    if(page >= pages) page = pages - 1;
    g_BRMusicRadioPage[playerid] = page;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 0);
    JSON_SetInt(json, "p", page + 1);
    JSON_SetInt(json, "b", BRMusic_GetPageButtons(page, total));
    JSON_SetInt(json, "a", BRMusic_GetActiveTab(playerid));
    JSON_SetInt(json, "e", 0);
    JSON_SetString(json, "n", "STOP", 4);

    new count = total - page * BR_MUSIC_PAGE_SIZE;
    if(count > BR_MUSIC_PAGE_SIZE) count = BR_MUSIC_PAGE_SIZE;
    JSON_SetInt(json, "nu", count);

    new key[8], radioid;
    for(new i = 0; i < count; i++)
    {
        radioid = page * BR_MUSIC_PAGE_SIZE + i;
        format(key, sizeof(key), "r%d", i);
        JSON_SetString(json, key, GetServerRadioData(radioid, SR_CHANNEL_NAME), strlen(GetServerRadioData(radioid, SR_CHANNEL_NAME)));
    }
    SendPacketToClient(playerid, BR_AUDIO_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

forward BRMusic_SendLibPage(playerid);
public BRMusic_SendLibPage(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new page = g_BRMusicLibPage[playerid];
    new total = sizeof(g_BRMusicList);
    new pages = BRMusic_GetPageCount(total);
    if(page < 0) page = 0;
    if(page >= pages) page = pages - 1;
    g_BRMusicLibPage[playerid] = page;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "p", page + 1);
    JSON_SetInt(json, "b", BRMusic_GetPageButtons(page, total));
    JSON_SetInt(json, "a", BRMusic_GetActiveTab(playerid));
    JSON_SetInt(json, "e", 0);
    JSON_SetInt(json, "s", 0);
    JSON_SetString(json, "n", "STOP", 4);

    new count = total - page * BR_MUSIC_PAGE_SIZE;
    if(count > BR_MUSIC_PAGE_SIZE) count = BR_MUSIC_PAGE_SIZE;
    JSON_SetInt(json, "nu", count);

    new key[8], trackid, price;
    for(new i = 0; i < count; i++)
    {
        trackid = page * BR_MUSIC_PAGE_SIZE + i;
        format(key, sizeof(key), "m%d", i);
        JSON_SetString(json, key, g_BRMusicList[trackid][BR_MUSIC_NAME], strlen(g_BRMusicList[trackid][BR_MUSIC_NAME]));
        price = g_BRMusicList[trackid][BR_MUSIC_PRICE];
        if(price > 0 && BRMusic_PlayerOwnsTrack(playerid, trackid)) price = 0;
        format(key, sizeof(key), "r%d", i);
        JSON_SetInt(json, key, price);
    }
    SendPacketToClient(playerid, BR_AUDIO_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

stock BRMusic_Stop(playerid)
{
    PlayerPlayStream(playerid, "");
    DeletePVar(playerid, "server_radio_enabled");
    g_BRMusicActiveRadio[playerid] = BR_MUSIC_INVALID_TRACK;
    g_BRMusicActiveLib[playerid] = BR_MUSIC_INVALID_TRACK;
    return 1;
}

stock BRMusic_StopIfCarMode(playerid)
{
    if(GetPVarInt(playerid, "server_radio_enabled") == 1 && GetPVarInt(playerid, "br_music_gui_mode") == BR_MUSIC_MODE_CAR)
    {
        BRMusic_Stop(playerid);
    }
    return 1;
}

stock BRMusic_PlayRadio(playerid, radioid)
{
    if(radioid < 0 || radioid >= sizeof(g_server_radio)) return 0;
    g_BRMusicActiveRadio[playerid] = radioid;
    g_BRMusicActiveLib[playerid] = BR_MUSIC_INVALID_TRACK;
    PlayerPlayStream(playerid, GetServerRadioData(radioid, SR_CHANNEL_URL));
    SetPVarInt(playerid, "server_radio_enabled", 1);
    if(GetPVarInt(playerid, "br_music_gui_mode") == BR_MUSIC_MODE_CAR) BRMusic_Notify(playerid, 3, "Радио в машине включено");
    else BRMusic_Notify(playerid, 3, "Музыка в наушниках включена");
    BRMusic_SendRadioPage(playerid);
    BRMusic_SendLibPage(playerid);
    return 1;
}

stock BRMusic_PlayLibTrack(playerid, trackid)
{
    if(trackid < 0 || trackid >= sizeof(g_BRMusicList)) return 0;
    g_BRMusicActiveLib[playerid] = trackid;
    g_BRMusicActiveRadio[playerid] = BR_MUSIC_INVALID_TRACK;
    PlayerPlayStream(playerid, g_BRMusicList[trackid][BR_MUSIC_URL]);
    SetPVarInt(playerid, "server_radio_enabled", 1);
    if(GetPVarInt(playerid, "br_music_gui_mode") == BR_MUSIC_MODE_CAR) BRMusic_Notify(playerid, 3, "Трек в машине включен");
    else BRMusic_Notify(playerid, 3, "Трек в наушниках включен");
    BRMusic_SendRadioPage(playerid);
    BRMusic_SendLibPage(playerid);
    return 1;
}

stock BRMusic_ShowBuyDialog(playerid, trackid)
{
    if(trackid < 0 || trackid >= sizeof(g_BRMusicList)) return 0;
    new price = g_BRMusicList[trackid][BR_MUSIC_PRICE];
    new text[256];
    SetPVarInt(playerid, "br_music_buy_track", trackid);

    // Закрываем GUI 9 перед обычным диалогом, иначе GUI перекрывает окно покупки.
    BRMusic_CloseGui(playerid);

    format(text, sizeof(text), "Вы хотите купить трек:\n\n{FFFF00}%s\n\n{FFFFFF}Цена: {FFFF00}%d донат-рублей", g_BRMusicList[trackid][BR_MUSIC_NAME], price);
    Dialog(playerid, DIALOG_BR_MUSIC_BUY, DIALOG_STYLE_MSGBOX, "{FFCD00}Покупка музыки", text, "Купить", "Отмена");
    return 1;
}

stock BRMusic_TryPlayLibTrack(playerid, trackid)
{
    if(trackid < 0 || trackid >= sizeof(g_BRMusicList)) return 0;
    new price = g_BRMusicList[trackid][BR_MUSIC_PRICE];
    if(price <= 0 || BRMusic_PlayerOwnsTrack(playerid, trackid)) return BRMusic_PlayLibTrack(playerid, trackid);
    return BRMusic_ShowBuyDialog(playerid, trackid);
}

stock BRMusic_BuyTrack(playerid, trackid)
{
    if(trackid < 0 || trackid >= sizeof(g_BRMusicList)) return 0;
    if(BRMusic_PlayerOwnsTrack(playerid, trackid)) return BRMusic_PlayLibTrack(playerid, trackid);

    new price = g_BRMusicList[trackid][BR_MUSIC_PRICE];
    if(GetPlayerDonateRub(playerid) < price)
    {
        new msg[128];
        format(msg, sizeof(msg), "Недостаточно донат-рублей. Нужно: %d", price);
        BRMusic_Notify(playerid, 2, msg);
        return 1;
    }

    AddPlayerData(playerid, P_DONATE_RUB, -, price);
    UpdatePlayerDatabaseInt(playerid, "rub", GetPlayerDonateRub(playerid));

    new query[320];
    mysql_format(mysql, query, sizeof(query), "INSERT IGNORE INTO player_music (account_id, track_id, buy_time) VALUES (%d, %d, %d)", GetPlayerAccountID(playerid), trackid, gettime());
    mysql_tquery(mysql, query, "", "");

    BRMusic_SetPlayerOwnsTrack(playerid, trackid);
    BRMusic_Notify(playerid, 3, "Трек куплен");
    return BRMusic_PlayLibTrack(playerid, trackid);
}

stock BRMusic_HandleBuyDialog(playerid, response)
{
    new trackid = GetPVarInt(playerid, "br_music_buy_track");
    DeletePVar(playerid, "br_music_buy_track");
    if(!response) return 1;
    return BRMusic_BuyTrack(playerid, trackid);
}

stock BRMusic_HandleGuiPacket(playerid, Node:json)
{
    new t;
    JSON_GetInt(json, "t", t);
    switch(t)
    {
        case 0:
        {
            // t=0 приходит при закрытии GUI. Музыку НЕ выключаем.
            return 1;
        }
        case 1:
        {
            new tab;
            JSON_GetInt(json, "b", tab);
            if(tab == 0) BRMusic_SendRadioPage(playerid);
            else if(tab == 1) BRMusic_SendLibPage(playerid);
            return 1;
        }
        case 2:
        {
            new tab, button;
            JSON_GetInt(json, "a", tab);
            JSON_GetInt(json, "b", button);

            if(button == 4)
            {
                BRMusic_Stop(playerid);
                BRMusic_Notify(playerid, 3, "Музыка выключена");
                BRMusic_SendRadioPage(playerid);
                BRMusic_SendLibPage(playerid);
                return 1;
            }

            if(tab == BR_AUDIO_TAB_RADIO)
            {
                if(button == 5)
                {
                    if(g_BRMusicRadioPage[playerid] > 0) g_BRMusicRadioPage[playerid]--;
                    return BRMusic_SendRadioPage(playerid);
                }
                if(button == 6)
                {
                    if(g_BRMusicRadioPage[playerid] < BRMusic_GetPageCount(sizeof(g_server_radio)) - 1) g_BRMusicRadioPage[playerid]++;
                    return BRMusic_SendRadioPage(playerid);
                }
                if(button >= 0 && button < BR_MUSIC_PAGE_SIZE)
                {
                    new radioid = g_BRMusicRadioPage[playerid] * BR_MUSIC_PAGE_SIZE + button;
                    return BRMusic_PlayRadio(playerid, radioid);
                }
            }
            else if(tab == BR_AUDIO_TAB_LIBRARY)
            {
                if(button == 5)
                {
                    if(g_BRMusicLibPage[playerid] > 0) g_BRMusicLibPage[playerid]--;
                    return BRMusic_SendLibPage(playerid);
                }
                if(button == 6)
                {
                    if(g_BRMusicLibPage[playerid] < BRMusic_GetPageCount(sizeof(g_BRMusicList)) - 1) g_BRMusicLibPage[playerid]++;
                    return BRMusic_SendLibPage(playerid);
                }
                if(button >= 0 && button < BR_MUSIC_PAGE_SIZE)
                {
                    new trackid = g_BRMusicLibPage[playerid] * BR_MUSIC_PAGE_SIZE + button;
                    return BRMusic_TryPlayLibTrack(playerid, trackid);
                }
            }
            return 1;
        }
    }
    return 1;
}

CMD:musiccc(playerid, params[])
{
    if(IsPlayerDriver(playerid))
    {
        if(GetPVarInt(playerid, "server_radio_enabled") == 1)
        {
            BRMusic_Stop(playerid);
            BRMusic_Notify(playerid, 3, "Радио выключено");
        }
        BRMusic_OpenGui(playerid, BR_MUSIC_MODE_CAR);
        return 1;
    }

    if(GetPlayerData(playerid, P_PLAY_PLAYER) <= 0)
    {
        BRMusic_Notify(playerid, 2, "У вас нет наушников");
        return 1;
    }

    if(GetPVarInt(playerid, "server_radio_enabled") == 1)
    {
        BRMusic_Stop(playerid);
        RemovePlayerAttachedObject(playerid, 3);
        BRMusic_Notify(playerid, 3, "Музыка выключена");
    }
    BRMusic_OpenGui(playerid, BR_MUSIC_MODE_PLAYER);
    return 1;
}