#if defined _IXSCAN_V10_INCLUDED
    #endinput
#endif
#define _IXSCAN_V10_INCLUDED

#define IXSCAN_FILE_GOOD "interiors_ultra_good.txt"

// VW/INT: keep OFF by default for compatibility.
// If your BR interiors require fixed VW/Interior, enable.
#define IXSCAN_SET_VW (0)
#define IXSCAN_VW_FIXED (7000)
#define IXSCAN_SET_INTERIOR (0)
#define IXSCAN_INTERIOR_FIXED (0)

// timings
#define IXSCAN_STEP_MS (220)
#define IXSCAN_VALIDATE_MS (280)
#define IXSCAN_VALIDATE_TICKS (18)     // ~5.0 sec decision window
#define IXSCAN_STAY_GOOD_MS (10000)

// settle/fall
#define IXSCAN_FREEZE_TICKS (4)
#define IXSCAN_REPOS_AT_TICK (3)

// fall / void detection
#define IXSCAN_FALL_VZ_BAD (-0.075)    // less strict (was -0.06)
#define IXSCAN_DZ_BAD (0.20)           // less strict (was 0.15)

// stability acceptance
#define IXSCAN_STABLE_DZ (0.06)
#define IXSCAN_STABLE_VZ (0.05)
#define IXSCAN_NEED_STABLE (3)         // was 4

// map bounds
#define IXSCAN_XMIN (-3000.0)
#define IXSCAN_XMAX ( 3000.0)
#define IXSCAN_YMIN (-3000.0)
#define IXSCAN_YMAX ( 3000.0)

// Z pools (adaptive)
#define IXSCAN_Z_GROUND_MIN (3.0)
#define IXSCAN_Z_GROUND_MAX (110.0)

#define IXSCAN_Z_MID_MIN (120.0)
#define IXSCAN_Z_MID_MAX (520.0)

#define IXSCAN_Z_HIGH_MIN (800.0)
#define IXSCAN_Z_HIGH_MAX (2300.0)

#define IXSCAN_Z_ULTRA_MIN (2400.0)
#define IXSCAN_Z_ULTRA_MAX (4200.0)

// base chances (sum <= 100)
#define IXSCAN_CHANCE_HIGH (42)
#define IXSCAN_CHANCE_MID  (22)
#define IXSCAN_CHANCE_ULTRA (6)        // rare, but sometimes magic layers

// dedup
#define IXSCAN_MAX_SAVED (10000)
#define IXSCAN_BUCKETS (65536)
#define IXSCAN_CELL (220.0)
#define IXSCAN_GOOD_CELL (120.0)

// "recently seen" TTL in attempts (prevents spam repeats, but doesn't kill search)
#define IXSCAN_SEEN_TTL (120)          // attempts before a bucket is allowed again (byte-based)

// dialog
#define IXSCAN_DLG_MAIN (9830)

// colors
#define IXSCAN_C_GREEN 0x5CFF5CFF
#define IXSCAN_C_RED   0xFF3B30FF
#define IXSCAN_C_YEL   0xF5D400FF
#define IXSCAN_C_CYAN  0x34D7FFFF

enum IXSCAN_eSaved { Float:sX, Float:sY, Float:sZ, Float:sA, sInt, sVW, gKey };
new IXSCAN_Saved[IXSCAN_MAX_SAVED][IXSCAN_eSaved];
new IXSCAN_SavedCount;

new bool:IXSCAN_Run[MAX_PLAYERS];
new IXSCAN_TimerStep[MAX_PLAYERS]     = {-1, ...};
new IXSCAN_TimerValidate[MAX_PLAYERS] = {-1, ...};

// stats
new IXSCAN_Try[MAX_PLAYERS], IXSCAN_Good[MAX_PLAYERS], IXSCAN_Reject[MAX_PLAYERS], IXSCAN_Dup[MAX_PLAYERS], IXSCAN_Water[MAX_PLAYERS];
new IXSCAN_ConsecutiveBad[MAX_PLAYERS];

// back & start guard
new bool:IXSCAN_HasBack[MAX_PLAYERS];
new Float:IXSCAN_BackX[MAX_PLAYERS], Float:IXSCAN_BackY[MAX_PLAYERS], Float:IXSCAN_BackZ[MAX_PLAYERS], Float:IXSCAN_BackA[MAX_PLAYERS];
new IXSCAN_BackVW[MAX_PLAYERS], IXSCAN_BackInt[MAX_PLAYERS];
new bool:IXSCAN_FirstResultGuard[MAX_PLAYERS];     // prevents logging "start point"

// validate state
new IXSCAN_Freeze[MAX_PLAYERS];
new IXSCAN_TicksLeft[MAX_PLAYERS];
new IXSCAN_Stable[MAX_PLAYERS];
new IXSCAN_FallHits[MAX_PLAYERS];
new Float:IXSCAN_LastZ[MAX_PLAYERS];
new Float:IXSCAN_TargetX[MAX_PLAYERS], Float:IXSCAN_TargetY[MAX_PLAYERS], Float:IXSCAN_TargetZ[MAX_PLAYERS], Float:IXSCAN_TargetA[MAX_PLAYERS];

// seen time (byte epoch)
new IXSCAN_Epoch;                         // 0..255
new IXSCAN_SeenAt[IXSCAN_BUCKETS];        // 0..255

// anchors
enum IXSCAN_eAnchor { Float:ax, Float:ay };
static IXSCAN_Anchors[][IXSCAN_eAnchor] = {
    { 0.0, 0.0 },
    { 300.0, 2000.0 },
    { -200.0, 1400.0 },
    { 2200.0, -1700.0 },
    { -2300.0, 2700.0 },
    { 1500.0, 200.0 },
    { -500.0, -500.0 },
    { 2000.0, 1800.0 },
    { -1500.0, -1200.0 },
    { 2500.0, 500.0 },
    { 1200.0, -1200.0 },
    { -1200.0, 900.0 },
    { -2600.0, 200.0 },
    { 2600.0, -200.0 }
};
#define IXSCAN_ANCHOR_COUNT (sizeof(IXSCAN_Anchors))
new IXSCAN_AnchorCursor[MAX_PLAYERS];

// ---------------- UTILS ----------------
stock Float:IXSCAN_frand(Float:min, Float:max)
{
    return min + (random(1000000) / 1000000.0) * (max - min);
}

stock IXSCAN_Bucket(Float:x, Float:y)
{
    new cx = floatround(x / IXSCAN_CELL);
    new cy = floatround(y / IXSCAN_CELL);
    new h = (cx * 73856093) ^ (cy * 19349663);
    if(h < 0) h = -h;
    return h & (IXSCAN_BUCKETS - 1);
}

stock IXSCAN_GoodKey(Float:x, Float:y, vw, interior)
{
    new cx = floatround(x / IXSCAN_GOOD_CELL);
    new cy = floatround(y / IXSCAN_GOOD_CELL);
    new h = (cx * 83492791) ^ (cy * 21474811) ^ (vw * 97531) ^ (interior * 19211);
    if(h < 0) h = -h;
    return h;
}

stock bool:IXSCAN_SeenRecently(bucket)
{
    // byte distance: (epoch - seenAt) & 255
    new d = (IXSCAN_Epoch - IXSCAN_SeenAt[bucket]) & 255;
    return (d < IXSCAN_SEEN_TTL);
}

stock IXSCAN_MarkSeen(bucket)
{
    IXSCAN_SeenAt[bucket] = IXSCAN_Epoch;
    return 1;
}

stock IXSCAN_NextEpoch()
{
    IXSCAN_Epoch = (IXSCAN_Epoch + 1) & 255;
    return 1;
}

stock IXSCAN_AppendLine(const file[], const line[])
{
    new File:f = fopen(file, io_append);
    if(!f) return 0;
    fwrite(f, line);
    fclose(f);
    return 1;
}

stock IXSCAN_SaveGood(Float:x, Float:y, Float:z, Float:a, vw, interior)
{
    new s[220];
    format(s, sizeof s, "%.6f %.6f %.6f %.6f %d %d\r\n", x, y, z, a, interior, vw);
    return IXSCAN_AppendLine(IXSCAN_FILE_GOOD, s);
}

stock IXSCAN_SetVWINT(playerid)
{
    #if IXSCAN_SET_VW
        SetPlayerVirtualWorld(playerid, IXSCAN_VW_FIXED);
    #endif
    #if IXSCAN_SET_INTERIOR
        SetPlayerInterior(playerid, IXSCAN_INTERIOR_FIXED);
    #endif
    return 1;
}

stock IXSCAN_SaveBack(playerid)
{
    GetPlayerPos(playerid, IXSCAN_BackX[playerid], IXSCAN_BackY[playerid], IXSCAN_BackZ[playerid]);
    GetPlayerFacingAngle(playerid, IXSCAN_BackA[playerid]);
    IXSCAN_BackVW[playerid]  = GetPlayerVirtualWorld(playerid);
    IXSCAN_BackInt[playerid] = GetPlayerInterior(playerid);
    IXSCAN_HasBack[playerid] = true;
    return 1;
}

stock IXSCAN_PickAnchor(playerid, &Float:cx, &Float:cy)
{
    IXSCAN_AnchorCursor[playerid] = (IXSCAN_AnchorCursor[playerid] + 1 + random(3)) % IXSCAN_ANCHOR_COUNT;
    cx = IXSCAN_Anchors[IXSCAN_AnchorCursor[playerid]][ax];
    cy = IXSCAN_Anchors[IXSCAN_AnchorCursor[playerid]][ay];
    return 1;
}

stock Float:IXSCAN_PickZ(playerid)
{
    // adaptive: if too many bad results, bias higher layers
    new bias = IXSCAN_ConsecutiveBad[playerid];
    new high = IXSCAN_CHANCE_HIGH + (bias > 8 ? 18 : (bias > 4 ? 10 : 0));
    if(high > 70) high = 70;

    new ultra = IXSCAN_CHANCE_ULTRA + (bias > 10 ? 6 : 0);
    if(ultra > 20) ultra = 20;

    new mid = IXSCAN_CHANCE_MID;

    new r = random(100);
    if(r < ultra) return IXSCAN_frand(IXSCAN_Z_ULTRA_MIN, IXSCAN_Z_ULTRA_MAX);
    r -= ultra;

    if(r < high) return IXSCAN_frand(IXSCAN_Z_HIGH_MIN, IXSCAN_Z_HIGH_MAX);
    r -= high;

    if(r < mid) return IXSCAN_frand(IXSCAN_Z_MID_MIN, IXSCAN_Z_MID_MAX);

    return IXSCAN_frand(IXSCAN_Z_GROUND_MIN, IXSCAN_Z_GROUND_MAX);
}

stock bool:IXSCAN_BuildCandidate(playerid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    // 75% anchor-biased, 25% pure random
    if(random(100) < 75)
    {
        new Float:cx, Float:cy;
        IXSCAN_PickAnchor(playerid, cx, cy);
        x = cx + IXSCAN_frand(-1000.0, 1000.0);
        y = cy + IXSCAN_frand(-1000.0, 1000.0);
    }
    else
    {
        x = IXSCAN_frand(IXSCAN_XMIN, IXSCAN_XMAX);
        y = IXSCAN_frand(IXSCAN_YMIN, IXSCAN_YMAX);
    }

    if(x < IXSCAN_XMIN) x = IXSCAN_XMIN;
    if(x > IXSCAN_XMAX) x = IXSCAN_XMAX;
    if(y < IXSCAN_YMIN) y = IXSCAN_YMIN;
    if(y > IXSCAN_YMAX) y = IXSCAN_YMAX;

    // don't allow "almost the same as start point" for the very first good result
    if(IXSCAN_FirstResultGuard[playerid])
    {
        if(floatabs(x - IXSCAN_BackX[playerid]) < 120.0 && floatabs(y - IXSCAN_BackY[playerid]) < 120.0)
            return false;
    }

    new b = IXSCAN_Bucket(x, y);
    if(IXSCAN_SeenRecently(b)) { IXSCAN_Dup[playerid]++; return false; }
    IXSCAN_MarkSeen(b);

    z = IXSCAN_PickZ(playerid);
    a = IXSCAN_frand(0.0, 360.0);
    return true;
}

stock IXSCAN_Teleport(playerid, Float:x, Float:y, Float:z, Float:a)
{
    IXSCAN_TargetX[playerid] = x;
    IXSCAN_TargetY[playerid] = y;
    IXSCAN_TargetZ[playerid] = z;
    IXSCAN_TargetA[playerid] = a;

    IXSCAN_SetVWINT(playerid);

    SetPlayerPos(playerid, x, y, z + 0.25);
    SetPlayerFacingAngle(playerid, a);
    TogglePlayerControllable(playerid, 0);

    IXSCAN_Freeze[playerid]    = IXSCAN_FREEZE_TICKS;
    IXSCAN_TicksLeft[playerid] = IXSCAN_VALIDATE_TICKS;
    IXSCAN_Stable[playerid]   = 0;
    IXSCAN_FallHits[playerid]  = 0;
    IXSCAN_LastZ[playerid]     = z + 0.25;

    return 1;
}

stock bool:IXSCAN_IsBadNow(playerid)
{
    if(IsPlayerInWater(playerid)) { IXSCAN_Water[playerid]++; return true; }

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new Float:vx, Float:vy, Float:vz;
    GetPlayerVelocity(playerid, vx, vy, vz);

    new Float:dz = IXSCAN_LastZ[playerid] - pz;

    if(vz < IXSCAN_FALL_VZ_BAD || dz > IXSCAN_DZ_BAD) IXSCAN_FallHits[playerid]++;
    else if(IXSCAN_FallHits[playerid] > 0) IXSCAN_FallHits[playerid]--;

    // stable-ish?
    if(floatabs(dz) <= IXSCAN_STABLE_DZ && floatabs(vz) <= IXSCAN_STABLE_VZ) IXSCAN_Stable[playerid]++;
    else if(IXSCAN_Stable[playerid] > 0) IXSCAN_Stable[playerid]--;

    IXSCAN_LastZ[playerid] = pz;

    return (IXSCAN_FallHits[playerid] >= 2);
}

// ---------------- UI ----------------
stock IXSCAN_ShowMenu(playerid)
{
    ShowPlayerDialog(playerid, IXSCAN_DLG_MAIN, DIALOG_STYLE_LIST,
        "Interior Scanner",
        "START\nSTOP\nSTATS",
        "Select", "Close");
    return 1;
}

stock IXSCAN_ShowStats(playerid)
{
    new s[240];
    format(s, sizeof s, "[INT] Try:%d Good:%d Reject:%d Dup:%d Water:%d Saved:%d",
        IXSCAN_Try[playerid], IXSCAN_Good[playerid], IXSCAN_Reject[playerid], IXSCAN_Dup[playerid],
        IXSCAN_Water[playerid], IXSCAN_SavedCount);
    SendClientMessage(playerid, IXSCAN_C_CYAN, s);
    return 1;
}

stock IXSCAN_ParseInt(const str[])
{
    new i=0, sign=1, val=0;
    while(str[i] == ' ') i++;
    if(str[i] == '-') { sign=-1; i++; }
    while(str[i] >= '0' && str[i] <= '9') { val = val*10 + (str[i]-'0'); i++; }
    return val*sign;
}

stock IXSCAN_HandleIntTP(playerid, const params[])
{
    if(!params[0]) { SendClientMessage(playerid, IXSCAN_C_YEL, "Usage: /inttp <#>"); return 1; }
    new idx = IXSCAN_ParseInt(params) - 1;
    if(idx < 0 || idx >= IXSCAN_SavedCount) { SendClientMessage(playerid, IXSCAN_C_RED, "[INT] Bad #"); return 1; }

    SetPlayerVirtualWorld(playerid, IXSCAN_Saved[idx][sVW]);
    SetPlayerInterior(playerid, IXSCAN_Saved[idx][sInt]);
    SetPlayerPos(playerid, IXSCAN_Saved[idx][sX], IXSCAN_Saved[idx][sY], IXSCAN_Saved[idx][sZ]);
    SetPlayerFacingAngle(playerid, IXSCAN_Saved[idx][sA]);
    SendClientMessage(playerid, IXSCAN_C_GREEN, "[INT] TP saved.");
    return 1;
}

// ---------------- TIMERS ----------------
forward IXSCAN_Step(playerid);
forward IXSCAN_Validate(playerid);

public IXSCAN_Step(playerid)
{
    if(!IXSCAN_Run[playerid]) return 0;

    IXSCAN_NextEpoch();
    IXSCAN_Try[playerid]++;

    new Float:x, Float:y, Float:z, Float:a;

    for(new k=0; k<140; k++)
    {
        if(IXSCAN_BuildCandidate(playerid, x, y, z, a)) break;

        if(k == 139)
        {
            IXSCAN_Reject[playerid]++;
            IXSCAN_ConsecutiveBad[playerid]++;
            if(IXSCAN_TimerStep[playerid] != -1) KillTimer(IXSCAN_TimerStep[playerid]);
            IXSCAN_TimerStep[playerid] = SetTimerEx("IXSCAN_Step", IXSCAN_STEP_MS, false, "i", playerid);
            return 1;
        }
    }

    IXSCAN_Teleport(playerid, x, y, z, a);

    if(IXSCAN_TimerValidate[playerid] != -1) KillTimer(IXSCAN_TimerValidate[playerid]);
    IXSCAN_TimerValidate[playerid] = SetTimerEx("IXSCAN_Validate", IXSCAN_VALIDATE_MS, false, "i", playerid);
    return 1;
}

public IXSCAN_Validate(playerid)
{
    if(!IXSCAN_Run[playerid]) return 0;

    if(IXSCAN_Freeze[playerid] > 0)
    {
        if(IXSCAN_Freeze[playerid] == IXSCAN_REPOS_AT_TICK)
            SetPlayerPos(playerid, IXSCAN_TargetX[playerid], IXSCAN_TargetY[playerid], IXSCAN_TargetZ[playerid] + 0.25);

        IXSCAN_Freeze[playerid]--;

        if(IXSCAN_Freeze[playerid] <= 0)
        {
            TogglePlayerControllable(playerid, 1);

            new Float:px, Float:py, Float:pz;
            GetPlayerPos(playerid, px, py, pz);
            IXSCAN_LastZ[playerid] = pz;

            IXSCAN_Stable[playerid] = 0;
            IXSCAN_FallHits[playerid] = 0;
        }

        if(IXSCAN_TimerValidate[playerid] != -1) KillTimer(IXSCAN_TimerValidate[playerid]);
        IXSCAN_TimerValidate[playerid] = SetTimerEx("IXSCAN_Validate", IXSCAN_VALIDATE_MS, false, "i", playerid);
        return 1;
    }

    IXSCAN_TicksLeft[playerid]--;
    if(IXSCAN_TicksLeft[playerid] <= 0)
    {
        IXSCAN_Reject[playerid]++;
        IXSCAN_ConsecutiveBad[playerid]++;
        if(IXSCAN_TimerStep[playerid] != -1) KillTimer(IXSCAN_TimerStep[playerid]);
        IXSCAN_TimerStep[playerid] = SetTimerEx("IXSCAN_Step", IXSCAN_STEP_MS, false, "i", playerid);
        return 1;
    }

    if(IXSCAN_IsBadNow(playerid))
    {
        IXSCAN_Reject[playerid]++;
        IXSCAN_ConsecutiveBad[playerid]++;
        if(IXSCAN_TimerStep[playerid] != -1) KillTimer(IXSCAN_TimerStep[playerid]);
        IXSCAN_TimerStep[playerid] = SetTimerEx("IXSCAN_Step", IXSCAN_STEP_MS, false, "i", playerid);
        return 1;
    }

    // Accept if stable enough OR time is running out but not bad (prevents "never finds anything")
    if(IXSCAN_Stable[playerid] >= IXSCAN_NEED_STABLE || IXSCAN_TicksLeft[playerid] <= 4)
    {
        new Float:px, Float:py, Float:pz, Float:pa;
        GetPlayerPos(playerid, px, py, pz);
        GetPlayerFacingAngle(playerid, pa);

        new vw = GetPlayerVirtualWorld(playerid);
        new intid = GetPlayerInterior(playerid);
        new gk = IXSCAN_GoodKey(px, py, vw, intid);

        // good dedup
        for(new i=0; i<IXSCAN_SavedCount; i++)
        {
            if(IXSCAN_Saved[i][gKey] == gk)
            {
                IXSCAN_Dup[playerid]++;
                IXSCAN_Reject[playerid]++;
                IXSCAN_ConsecutiveBad[playerid]++;
                if(IXSCAN_TimerStep[playerid] != -1) KillTimer(IXSCAN_TimerStep[playerid]);
                IXSCAN_TimerStep[playerid] = SetTimerEx("IXSCAN_Step", IXSCAN_STEP_MS, false, "i", playerid);
                return 1;
            }
        }

        // first-result guard: ensure not basically the start spot
        if(IXSCAN_FirstResultGuard[playerid])
        {
            if(floatabs(px - IXSCAN_BackX[playerid]) < 80.0 && floatabs(py - IXSCAN_BackY[playerid]) < 80.0)
            {
                IXSCAN_Reject[playerid]++;
                IXSCAN_ConsecutiveBad[playerid]++;
                if(IXSCAN_TimerStep[playerid] != -1) KillTimer(IXSCAN_TimerStep[playerid]);
                IXSCAN_TimerStep[playerid] = SetTimerEx("IXSCAN_Step", IXSCAN_STEP_MS, false, "i", playerid);
                return 1;
            }
        }

        IXSCAN_Good[playerid]++;
        IXSCAN_ConsecutiveBad[playerid] = 0;
        IXSCAN_FirstResultGuard[playerid] = false;

        if(IXSCAN_SavedCount < IXSCAN_MAX_SAVED)
        {
            IXSCAN_Saved[IXSCAN_SavedCount][sX] = px;
            IXSCAN_Saved[IXSCAN_SavedCount][sY] = py;
            IXSCAN_Saved[IXSCAN_SavedCount][sZ] = pz;
            IXSCAN_Saved[IXSCAN_SavedCount][sA] = pa;
            IXSCAN_Saved[IXSCAN_SavedCount][sInt] = intid;
            IXSCAN_Saved[IXSCAN_SavedCount][sVW] = vw;
            IXSCAN_Saved[IXSCAN_SavedCount][gKey] = gk;
            IXSCAN_SavedCount++;
        }

        IXSCAN_SaveGood(px, py, pz, pa, vw, intid);

        new msg[240];
        format(msg, sizeof msg, "[INT] #%d | X %.2f Y %.2f Z %.2f | INT %d | VW %d",
            IXSCAN_SavedCount, px, py, pz, intid, vw);
        SendClientMessage(playerid, IXSCAN_C_GREEN, msg);

        if(IXSCAN_TimerStep[playerid] != -1) KillTimer(IXSCAN_TimerStep[playerid]);
        IXSCAN_TimerStep[playerid] = SetTimerEx("IXSCAN_Step", IXSCAN_STAY_GOOD_MS, false, "i", playerid);
        return 1;
    }

    if(IXSCAN_TimerValidate[playerid] != -1) KillTimer(IXSCAN_TimerValidate[playerid]);
    IXSCAN_TimerValidate[playerid] = SetTimerEx("IXSCAN_Validate", IXSCAN_VALIDATE_MS, false, "i", playerid);
    return 1;
}

// ---------------- CONTROL ----------------
stock IXSCAN_Start(playerid)
{
    if(IXSCAN_Run[playerid]) return 1;

    // hard reset timers/state to avoid "start position accepted"
    if(IXSCAN_TimerStep[playerid] != -1) { KillTimer(IXSCAN_TimerStep[playerid]); IXSCAN_TimerStep[playerid] = -1; }
    if(IXSCAN_TimerValidate[playerid] != -1) { KillTimer(IXSCAN_TimerValidate[playerid]); IXSCAN_TimerValidate[playerid] = -1; }

    IXSCAN_SaveBack(playerid);

    IXSCAN_FirstResultGuard[playerid] = true;
    IXSCAN_ConsecutiveBad[playerid] = 0;

    IXSCAN_Run[playerid] = true;
    SendClientMessage(playerid, IXSCAN_C_CYAN, "[INT] Scanner: ON");

    IXSCAN_TimerStep[playerid] = SetTimerEx("IXSCAN_Step", 50, false, "i", playerid);
    return 1;
}

stock IXSCAN_Stop(playerid)
{
    if(!IXSCAN_Run[playerid]) return 1;

    IXSCAN_Run[playerid] = false;

    if(IXSCAN_TimerStep[playerid] != -1) { KillTimer(IXSCAN_TimerStep[playerid]); IXSCAN_TimerStep[playerid] = -1; }
    if(IXSCAN_TimerValidate[playerid] != -1) { KillTimer(IXSCAN_TimerValidate[playerid]); IXSCAN_TimerValidate[playerid] = -1; }

    TogglePlayerControllable(playerid, 1);
    SendClientMessage(playerid, IXSCAN_C_CYAN, "[INT] Scanner: OFF");
    return 1;
}

// ============================================================================
// CALLBACKS "WORKINGSTYLE" (как в твоих системах)
// ============================================================================

public OnGameModeInit()
{
    IXSCAN_Epoch = 0;
    for(new i=0; i<IXSCAN_BUCKETS; i++) IXSCAN_SeenAt[i] = 0;
    IXSCAN_SavedCount = 0;

    #if defined IXSCAN_OnGameModeInit
        return IXSCAN_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit IXSCAN_OnGameModeInit
#if defined IXSCAN_OnGameModeInit
    forward IXSCAN_OnGameModeInit();
#endif

public OnPlayerDisconnect(playerid, reason)
{
    IXSCAN_Stop(playerid);
    IXSCAN_HasBack[playerid] = false;

    #if defined IXSCAN_OnPlayerDisconnect
        return IXSCAN_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect IXSCAN_OnPlayerDisconnect
#if defined IXSCAN_OnPlayerDisconnect
    forward IXSCAN_OnPlayerDisconnect(playerid, reason);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == IXSCAN_DLG_MAIN)
    {
        if(!response) return 1;

        if(listitem == 0) return IXSCAN_Start(playerid); // START
        if(listitem == 1) return IXSCAN_Stop(playerid);  // STOP
        if(listitem == 2) { IXSCAN_ShowStats(playerid); return 1; } // STATS
        return 1;
    }

    #if defined IXSCAN_OnDialogResponse
        return IXSCAN_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse IXSCAN_OnDialogResponse
#if defined IXSCAN_OnDialogResponse
    forward IXSCAN_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/checkint", true) || !strcmp(cmdtext, "/cheakint", true))
    {
        IXSCAN_ShowMenu(playerid);
        return 1;
    }
    if(!strcmp(cmdtext, "/intstats", true))
    {
        IXSCAN_ShowStats(playerid);
        return 1;
    }
    if(!strcmp(cmdtext, "/intback", true))
    {
        if(!IXSCAN_HasBack[playerid]) { SendClientMessage(playerid, IXSCAN_C_RED, "[INT] No back point."); return 1; }

        IXSCAN_Stop(playerid);
        SetPlayerVirtualWorld(playerid, IXSCAN_BackVW[playerid]);
        SetPlayerInterior(playerid, IXSCAN_BackInt[playerid]);
        SetPlayerPos(playerid, IXSCAN_BackX[playerid], IXSCAN_BackY[playerid], IXSCAN_BackZ[playerid]);
        SetPlayerFacingAngle(playerid, IXSCAN_BackA[playerid]);
        SendClientMessage(playerid, IXSCAN_C_GREEN, "[INT] Back.");
        return 1;
    }

    // /inttp <num>
    if(cmdtext[0] == '/' && cmdtext[1] == 'i' && cmdtext[2] == 'n' && cmdtext[3] == 't' && cmdtext[4] == 't' && cmdtext[5] == 'p')
    {
        new params[120];
        params[0] = '\0';

        new len = strlen(cmdtext);
        new p = 6;
        while(p < len && cmdtext[p] == ' ') p++;
        if(p < len) strmid(params, cmdtext, p, len, sizeof(params));

        IXSCAN_HandleIntTP(playerid, params);
        return 1;
    }

    #if defined IXSCAN_OnPlayerCommandText
        return IXSCAN_OnPlayerCommandText(playerid, cmdtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText IXSCAN_OnPlayerCommandText
#if defined IXSCAN_OnPlayerCommandText
    forward IXSCAN_OnPlayerCommandText(playerid, cmdtext[]);
#endif
