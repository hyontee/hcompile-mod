#if defined _CUSTOMHUD_FIXED
    #endinput
#endif
#define _CUSTOMHUD_FIXED

#define VALID_PLAYER(%0) ((%0) >= 0 && (%0) < MAX_PLAYERS && IsPlayerConnected(%0))
#define VALID_STREAM(%0) ((%0) >= 0 && (%0) < MAX_STREAM_SOURCES)

#define PACKET_CUSTOMRPC 251
#define CUSTOM_RPC_TOGGLE_HUD_ELEMENT 0x1

#define HUD_ELEMENT_HIDE 0
#define HUD_ELEMENT_SHOW 1

#define HUD_ELEMENT_CHAT 0
#define HUD_ELEMENT_MAP 1
#define HUD_ELEMENT_TAGS 2
#define HUD_ELEMENT_BUTTONS 3
#define HUD_ELEMENT_HUD 4
#define HUD_ELEMENT_VOICE 5
#define HUD_ELEMENT_TEXTLABELS 6
#define HUD_ELEMENT_COUNT 7

#define RPC_GUI_ALT 0x185

#define RPC_STREAM_CREATE 0x2
#define RPC_STREAM_POS 0x3
#define RPC_STREAM_DESTROY 0x4
#define RPC_STREAM_INDIVIDUAL 0x5
#define RPC_STREAM_VOLUME 0x6
#define RPC_STREAM_ISENABLED 0x7

#define RPC_OPEN_LINK 0x8
#define RPC_TIMEOUT_CHAT 0x9
#define RPC_OPEN_SETTINGS 0x15
#define RPC_CUSTOM_SET_FUEL 0x25
#define RPC_CUSTOM_SET_LEVEL 0x26

#define RPC_SHOW_GPS 0x177
#define RPC_HIDE_GPS 0x170
#define RPC_SHOW_X2 0x181
#define RPC_HIDE_X2 0x182
#define RPC_SHOW_ZONA 0x183
#define RPC_HIDE_ZONA 0x184

#define RPC_SHOW_DONATE 0x39

#define RPC_HHUD_BR 0x186
#define RPC_SHUD_BR 0x187
#define RPC_HSPEED_BR 0x188

#define MAX_STREAM_SOURCES 1000

enum E_STREAM_SOURCE
{
    eStreamID,
    eStreamIsFree,
    Float:eStreamPos[3],
    eStreamInt,
    eStreamVirtualWorld,
    Float:eStreamDistance,
    szUrl[255]
};

static g_aStreamSources[MAX_STREAM_SOURCES][E_STREAM_SOURCE];

stock InitStreamSources()
{
    for(new i; i < MAX_STREAM_SOURCES; i++)
    {
        g_aStreamSources[i][eStreamID] = -1;
        g_aStreamSources[i][eStreamIsFree] = 1;
    }
    return 1;
}

stock SendCustomRPC_Float(playerid, rpcid, ...)
{
    if(playerid != -1 && !VALID_PLAYER(playerid)) return 0;

    new BitStream:bs = BS_New();
    if(!bs) return 0;

    BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bs, PR_UINT32, rpcid);

    for(new i; i < numargs() - 2; i++)
        BS_WriteValue(bs, PR_FLOAT, getarg(i + 2));

    BS_Send(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bs);
    return 1;
}

stock PlayerPlayStream(playerid, const url[])
{
    if(!VALID_PLAYER(playerid)) return 0;
    if(!strlen(url)) return 0;

    new BitStream:bs = BS_New();
    if(!bs) return 0;

    BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bs, PR_UINT32, RPC_STREAM_INDIVIDUAL);
    BS_WriteValue(bs, PR_UINT8, strlen(url));
    BS_WriteValue(bs, PR_STRING, url);

    BS_Send(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bs);
    return 1;
}

stock CreateStreamSource(Float:x, Float:y, Float:z, Float:dist, interior, vw, const url[])
{
    if(!strlen(url)) return -1;

    for(new i; i < MAX_STREAM_SOURCES; i++)
    {
        if(g_aStreamSources[i][eStreamIsFree])
        {
            g_aStreamSources[i][eStreamID] = i;
            g_aStreamSources[i][eStreamIsFree] = 0;
            g_aStreamSources[i][eStreamPos][0] = x;
            g_aStreamSources[i][eStreamPos][1] = y;
            g_aStreamSources[i][eStreamPos][2] = z;
            g_aStreamSources[i][eStreamDistance] = dist;
            g_aStreamSources[i][eStreamInt] = interior;
            g_aStreamSources[i][eStreamVirtualWorld] = vw;
            format(g_aStreamSources[i][szUrl], 255, "%s", url);

            new BitStream:bs = BS_New();
            if(!bs) return i;

            BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOMRPC);
            BS_WriteValue(bs, PR_UINT32, RPC_STREAM_CREATE);
            BS_WriteValue(bs, PR_UINT16, i);
            BS_WriteValue(bs, PR_FLOAT, x);
            BS_WriteValue(bs, PR_FLOAT, y);
            BS_WriteValue(bs, PR_FLOAT, z);
            BS_WriteValue(bs, PR_FLOAT, dist);
            BS_WriteValue(bs, PR_UINT16, interior);
            BS_WriteValue(bs, PR_UINT16, vw);
            BS_WriteValue(bs, PR_UINT8, strlen(url));
            BS_WriteValue(bs, PR_STRING, url);

            BS_Send(bs, -1, PR_HIGH_PRIORITY, PR_RELIABLE);
            BS_Delete(bs);
            return i;
        }
    }
    return -1;
}

stock SetStreamPos(id, Float:x, Float:y, Float:z)
{
    if(!VALID_STREAM(id)) return 0;
    if(g_aStreamSources[id][eStreamIsFree]) return 0;

    g_aStreamSources[id][eStreamPos][0] = x;
    g_aStreamSources[id][eStreamPos][1] = y;
    g_aStreamSources[id][eStreamPos][2] = z;

    new BitStream:bs = BS_New();
    if(!bs) return 0;

    BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bs, PR_UINT32, RPC_STREAM_POS);
    BS_WriteValue(bs, PR_UINT16, id);
    BS_WriteValue(bs, PR_FLOAT, x);
    BS_WriteValue(bs, PR_FLOAT, y);
    BS_WriteValue(bs, PR_FLOAT, z);

    BS_Send(bs, -1, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bs);
    return 1;
}

stock DestroyStreamSource(id)
{
    if(!VALID_STREAM(id)) return 0;
    if(g_aStreamSources[id][eStreamIsFree]) return 0;

    g_aStreamSources[id][eStreamIsFree] = 1;
    SendCustomRPC(-1, RPC_STREAM_DESTROY, id);
    return 1;
}

stock SetStreamSourceVolume(id, Float:vol)
{
    if(!VALID_STREAM(id)) return 0;
    SendCustomRPC_Float(-1, RPC_STREAM_VOLUME, id, vol);
    return 1;
}

stock TogglePlayerHudElement(playerid, hudid, value)
{
    if(!VALID_PLAYER(playerid)) return 0;
    if(hudid < 0 || hudid >= HUD_ELEMENT_COUNT) return 0;
//    return SendCustomRPC(playerid, CUSTOM_RPC_TOGGLE_HUD_ELEMENT, hudid, value);
}

stock TogglePlayerAllHudElements(playerid, value)
{
    if(!VALID_PLAYER(playerid)) return 0;
    for(new i; i < HUD_ELEMENT_COUNT; i++)
//        SendCustomRPC(playerid, CUSTOM_RPC_TOGGLE_HUD_ELEMENT, i, value);
    return 1;
}

stock ShowGPS(playerid)        return VALID_PLAYER(playerid) && (playerid, RPC_SHOW_GPS);
stock HideGPS(playerid)        return VALID_PLAYER(playerid) && (playerid, RPC_HIDE_GPS);
stock ShowZona(playerid)       return VALID_PLAYER(playerid) && (playerid, RPC_SHOW_ZONA);
stock HideZona(playerid)       return VALID_PLAYER(playerid) && (playerid, RPC_HIDE_ZONA);
stock ShowX2(playerid)         return VALID_PLAYER(playerid) && (playerid, RPC_SHOW_X2);
stock HideX2(playerid)         return VALID_PLAYER(playerid) && (playerid, RPC_HIDE_X2);
stock ShowHudBR(playerid)      return VALID_PLAYER(playerid) && (playerid, RPC_SHUD_BR);
stock HideHudBR(playerid)      return VALID_PLAYER(playerid) && (playerid, RPC_HHUD_BR);
stock HideSpeedBR(playerid)    return VALID_PLAYER(playerid) && (playerid, RPC_HSPEED_BR);
