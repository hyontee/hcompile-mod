//>> Файл: bykranin_src/core/combat/combat_01.inc  (664 строк)
//>> Тема: здоровье, смерть, урон, оружие, больница
//>> Внутри: SetPlayerHospitalSpawnInit, HospitalSetPlayerPosition, HospitalPrimeInterior, HospitalLoginSpawnGuard, HospitalSpawnSync, HospitalSpawnLateGuard, HospitalSpawnLateRoom
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).

// Чёрная "шторка" на экран на время переезда в ЦБ (снаружи -> общий вход -> палата).
// Сам многошаговый переход не убираем - он специально нужен на части Android-клиентов,
// чтобы кастомный интерьер больницы гарантированно подгрузился (см. HospitalPrimeInterior
// ниже). Шторка просто визуально прячет некрасивый промежуточный "выход на улицу".
new Text:g_hospital_fade_td = Text:INVALID_TEXT_DRAW;

stock Hospital_EnsureFadeTD()
{
    if(g_hospital_fade_td != Text:INVALID_TEXT_DRAW) return 1;

    g_hospital_fade_td = TextDrawCreate(-20.0, -20.0, "_");
    TextDrawUseBox(g_hospital_fade_td, 1);
    TextDrawBoxColor(g_hospital_fade_td, 0x000000FF);
    TextDrawTextSize(g_hospital_fade_td, 680.0, 700.0);
    TextDrawLetterSize(g_hospital_fade_td, 0.0, 0.0);
    TextDrawColor(g_hospital_fade_td, 0x00000000);
    TextDrawSetOutline(g_hospital_fade_td, 0);
    TextDrawSetShadow(g_hospital_fade_td, 0);
    TextDrawBackgroundColor(g_hospital_fade_td, 0x000000FF);
    TextDrawFont(g_hospital_fade_td, 1);
    return 1;
}

stock Hospital_ShowFade(playerid)
{
    Hospital_EnsureFadeTD();
    TextDrawShowForPlayer(playerid, g_hospital_fade_td);
    return 1;
}

stock Hospital_HideFade(playerid)
{
    if(g_hospital_fade_td != Text:INVALID_TEXT_DRAW) TextDrawHideForPlayer(playerid, g_hospital_fade_td);
    return 1;
}

stock SetPlayerHospitalSpawnInit(playerid)
{
    // Reuse the same room for every duplicate spawn callback belonging to this
    // death.  Randomising it again is what made the player appear to die/spawn
    // twice and could leave the Android client between two interior loads.
    new room = GetPVarInt(playerid, "hospital_spawn_room") - 1;
    if(room < 0 || room >= sizeof g_hospital_death_spawn)
    {
        room = random(sizeof g_hospital_death_spawn);
        SetPVarInt(playerid, "hospital_spawn_room", room + 1);
    }

    SetSpawnInfo
    (
        playerid,
        0,
        GetPlayerHospitalSpawnSkin(playerid),
        g_hospital_death_spawn[room][0],
        g_hospital_death_spawn[room][1],
        g_hospital_death_spawn[room][2],
        g_hospital_death_spawn[room][3],
        0, 0, 0, 0, 0, 0
    );
    return 1;
}

stock HospitalSetPlayerPosition(playerid, room)
{
    if(room < 0 || room >= sizeof g_hospital_death_spawn) return 0;

    // Use the exact same transition order as the normal working hospital
    // teleport: position -> interior -> virtual world.  The old hotfix used
    // VW -> position -> interior, which can leave the mobile client at the
    // correct coordinates while the custom hospital itself is not loaded.
    SetPlayerPos(playerid,
        g_hospital_death_spawn[room][0],
        g_hospital_death_spawn[room][1],
        g_hospital_death_spawn[room][2]);
    SetPlayerFacingAngle(playerid, g_hospital_death_spawn[room][3]);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, 1);
    Streamer_Update(playerid);
    SetPlayerHealthEx(playerid, 30.0);
    return 1;
}

stock HospitalPrimeInterior(playerid)
{
    // This is the same destination used by the regular hospital entrance.
    // Priming the custom interior here before moving to a bed gives Android
    // clients one streaming frame to load the hospital map.
    SetPlayerPos(playerid, 1501.540039, 2489.010986, 2501.000000);
    SetPlayerFacingAngle(playerid, 360.0);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, 1);
    Streamer_Update(playerid);
    SetPlayerHealthEx(playerid, 30.0);
    return 1;
}

// Extra reconnect watchdog for the rare mobile case where SpawnPlayer() is
// accepted by the server but the client remains in PLAYER_STATE_NONE or a late
// auth/spawn callback resets Interior/VW. This runs only for hospital reconnects.
forward HospitalLoginSpawnGuard(playerid, token, session, pass);
public HospitalLoginSpawnGuard(playerid, token, session, pass)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(mysql_race[playerid] != session) return 1;
    if(!GetPlayerData(playerid, P_HOSPITAL)) return 1;
    if(GetPVarInt(playerid, "hospital_spawn_token") != token) return 1;

    new room = GetPVarInt(playerid, "hospital_spawn_room") - 1;
    if(room < 0 || room >= sizeof g_hospital_death_spawn)
    {
        SetPlayerHospitalSpawnInit(playerid);
        room = GetPVarInt(playerid, "hospital_spawn_room") - 1;
    }

    if(GetPlayerState(playerid) == PLAYER_STATE_NONE)
    {
        // The login screen can visually finish while the mobile client has not
        // completed the actual player spawn. Retry the same hospital spawn.
        SetPlayerHospitalSpawnInit(playerid);
        SpawnPlayer(playerid);
    }
    else
    {
        new bool:wrong_world = (GetPlayerInterior(playerid) != 1 || GetPlayerVirtualWorld(playerid) != 1);
        new bool:wrong_pos = !IsPlayerInRangeOfPoint(playerid, 180.0, 1484.458862, 2494.261474, 2501.000000);

        if(wrong_world || wrong_pos)
        {
            // Re-prime instead of only changing VW: on affected Android clients
            // the map itself may still be missing even at correct coordinates.
            TogglePlayerControllable(playerid, false);
            HospitalPrimeInterior(playerid);
            SetTimerEx("HospitalSpawnLateRoom", 700, false, "iiii", playerid, room, token, session);
        }
        else
        {
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, 1);
            Streamer_Update(playerid);
            SetPlayerHealthEx(playerid, 30.0);
        }
    }

    // Three login-only passes cover slow emulators/phones without creating a
    // permanent timer. The normal hospital late guard continues afterwards.
    if(pass < 3)
    {
        SetTimerEx("HospitalLoginSpawnGuard", 3200, false, "iiii", playerid, token, session, pass + 1);
    }
    return 1;
}

forward HospitalSpawnSync(playerid, room, token, session, stage);
public HospitalSpawnSync(playerid, room, token, session, stage)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(mysql_race[playerid] != session) return 1;
    if(!GetPlayerData(playerid, P_HOSPITAL)) return 1;
    if(room < 0 || room >= sizeof g_hospital_death_spawn) return 1;
    if(GetPVarInt(playerid, "hospital_spawn_token") != token) return 1;

    // Some Android clients need substantially longer than one second to load
    // the custom hospital. Keep the player frozen and prime the known-good
    // entrance twice before moving to the bed room.
    switch(stage)
    {
        case 1:
        {
            HospitalPrimeInterior(playerid);
            SetTimerEx("HospitalSpawnSync", 900, false, "iiiii", playerid, room, token, session, 2);
        }
        case 2:
        {
            HospitalSetPlayerPosition(playerid, room);
            SetTimerEx("HospitalSpawnSync", 1400, false, "iiiii", playerid, room, token, session, 3);
        }
        default:
        {
            HospitalSetPlayerPosition(playerid, room);
            SetPVarInt(playerid, "hospital_spawn_state", 2);
            TogglePlayerControllable(playerid, true);
            Hospital_HideFade(playerid);

            // Hospital login bypasses the normal spawn selector, so open the
            // admin PIN only after the hospital transition has fully finished.
            SRAdmin_OpenAfterSpawnSelection(playerid);

            // Catch late teleports/VW resets from other spawn systems.
            SetTimerEx("HospitalSpawnLateGuard", 2500, false, "iiiii", playerid, room, token, session, 1);
        }
    }
    return 1;
}

forward HospitalSpawnLateGuard(playerid, room, token, session, pass);
public HospitalSpawnLateGuard(playerid, room, token, session, pass)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(mysql_race[playerid] != session) return 1;
    if(!GetPlayerData(playerid, P_HOSPITAL)) return 1;
    if(room < 0 || room >= sizeof g_hospital_death_spawn) return 1;
    if(GetPVarInt(playerid, "hospital_spawn_token") != token) return 1;

    new bool:wrong_world = (GetPlayerInterior(playerid) != 1 || GetPlayerVirtualWorld(playerid) != 1);
    new bool:wrong_pos = !IsPlayerInRangeOfPoint(playerid, 180.0, 1484.458862, 2494.261474, 2501.000000);

    if(wrong_world || wrong_pos)
    {
        TogglePlayerControllable(playerid, false);
        HospitalPrimeInterior(playerid);
        SetTimerEx("HospitalSpawnLateRoom", 700, false, "iiii", playerid, room, token, session);
    }
    // FIX (rubber-banding РІ Р¦Р‘ РЅР° Android): СЂР°РЅСЊС€Рµ Р·РґРµСЃСЊ Р‘Р•Р—РЈРЎР›РћР’РќРћ РїРѕРІС‚РѕСЂРЅРѕ
    // РІС‹Р·С‹РІР°Р»СЃСЏ SetPlayerInterior/SetPlayerVirtualWorld/Streamer_Update РґР°Р¶Рµ
    // РєРѕРіРґР° РёРіСЂРѕРє СѓР¶Рµ Рё С‚Р°Рє СЃС‚РѕСЏР» РІ РїСЂР°РІРёР»СЊРЅРѕРј РёРЅС‚РµСЂСЊРµСЂРµ/РјРёСЂРµ - "РЅР° РІСЃСЏРєРёР№
    // СЃР»СѓС‡Р°Р№" РґР»СЏ РјРµРґР»РµРЅРЅС‹С… РєР»РёРµРЅС‚РѕРІ. РќР° РјРѕР±РёР»СЊРЅС‹С… РєР»РёРµРЅС‚Р°С… РїРѕРІС‚РѕСЂРЅС‹Р№ РІС‹Р·РѕРІ
    // SetPlayerInterior СЃ С‚РµРј Р¶Рµ Р·РЅР°С‡РµРЅРёРµРј СЃР°Рј РїРѕ СЃРµР±Рµ РІС‹Р·С‹РІР°РµС‚ РІРёРґРёРјС‹Р№
    // "СЃРЅСЌРї"/С‚РµР»РµРїРѕСЂС‚-РїРѕРґС‘СЂРіРёРІР°РЅРёРµ РїРѕР·РёС†РёРё. Рў.Рє. СЌС‚РѕС‚ РїСЂРѕС…РѕРґ РІС‹РїРѕР»РЅСЏРµС‚СЃСЏ 4
    // СЂР°Р·Р° РїРѕРґСЂСЏРґ (РєР°Р¶РґС‹Рµ 3 СЃРµРє, ~12 СЃРµРє РІСЃРµРіРѕ) РїРѕСЃР»Рµ РєР°Р¶РґРѕР№ СЃРјРµСЂС‚Рё/СЂР°РЅРµРЅРёСЏ,
    // РёРіСЂРѕРє РІРёРґРµР» СЌС‚Сѓ С‚СЂСЏСЃРєСѓ РїРѕ РЅРµСЃРєРѕР»СЊРєСѓ СЂР°Р· РїСЂСЏРјРѕ РІ Р¦Р‘, С…РѕС‚СЏ С„РѕСЂРјР°Р»СЊРЅРѕ СѓР¶Рµ
    // Р±С‹Р» РЅР° РјРµСЃС‚Рµ. РўРµРїРµСЂСЊ С‚СЂРѕРіР°РµРј РёРЅС‚РµСЂСЊРµСЂ/РјРёСЂ С‚РѕР»СЊРєРѕ РµСЃР»Рё РѕРЅРё СЂРµР°Р»СЊРЅРѕ РЅРµ
    // С‚Рµ - С‚Р°Рє Р¶Рµ, РєР°Рє СѓР¶Рµ СЃРґРµР»Р°РЅРѕ РІ Wounded_EnsureCB С‡СѓС‚СЊ РІС‹С€Рµ РїРѕ С„Р°Р№Р»Сѓ.

    // Keep a few finite late passes: on slower Android/emulator clients a
    // delayed auth/spawn helper can still reset Interior/VW several seconds
    // after the first successful room load.
    if(pass < 4)
    {
        SetTimerEx("HospitalSpawnLateGuard", 3000, false, "iiiii", playerid, room, token, session, pass + 1);
    }
    return 1;
}

forward HospitalSpawnLateRoom(playerid, room, token, session);
public HospitalSpawnLateRoom(playerid, room, token, session)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(mysql_race[playerid] != session) return 1;
    if(!GetPlayerData(playerid, P_HOSPITAL)) return 1;
    if(room < 0 || room >= sizeof g_hospital_death_spawn) return 1;
    if(GetPVarInt(playerid, "hospital_spawn_token") != token) return 1;

    HospitalSetPlayerPosition(playerid, room);
    SetPVarInt(playerid, "hospital_spawn_state", 2);
    TogglePlayerControllable(playerid, true);
    return 1;
}

stock ApplyPlayerHospitalSpawn(playerid)
{
    // Reapply only a hospital-safe/resolved model. This is isolated from the
    // normal skin inventory/account logic and never persists a fallback.
    SetPlayerSkin(playerid, GetPlayerHospitalSpawnSkin(playerid));

    new room = GetPVarInt(playerid, "hospital_spawn_room") - 1;
    if(room < 0 || room >= sizeof g_hospital_death_spawn)
    {
        room = random(sizeof g_hospital_death_spawn);
        SetPVarInt(playerid, "hospital_spawn_room", room + 1);
    }

    new hospital_state = GetPVarInt(playerid, "hospital_spawn_state");
    if(hospital_state != 0)
    {
        // A duplicate OnPlayerSpawn may reset interior/VW back to 0. Reapply
        // the same room; if loading is still in progress keep the player frozen.
        HospitalSetPlayerPosition(playerid, room);
        TogglePlayerControllable(playerid, hospital_state == 2);
        return 1;
    }

    SetPVarInt(playerid, "hospital_spawn_state", 1);
    TogglePlayerControllable(playerid, false);
    Hospital_ShowFade(playerid);

    // The hospital geometry is client-side while its labels are server-side.
    // Re-sending 1/1 while the server already reports 1/1 does not make the
    // Android client reload that geometry, leaving only bed labels visible.
    // Establish a real context edge first; stage 1 then enters the hospital in
    // exactly the same order as the working entrance marker. Screen stays
    // covered by Hospital_ShowFade() above, so the player never actually sees
    // themselves standing outside on the street during this edge.
    SetPlayerPos(playerid, -287.528564, 569.952270, 12.807999);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    Streamer_Update(playerid);

    new token = GetPVarInt(playerid, "hospital_spawn_token");
    if(token <= 0)
    {
        token = 1;
        SetPVarInt(playerid, "hospital_spawn_token", token);
    }

    // 350ms explicit 0/0 context -> hospital entrance -> room -> final verify.
    SetTimerEx("HospitalSpawnSync", 350, false, "iiiii", playerid, room, token, mysql_race[playerid], 1);
    return 1;
}

stock Float:GetServerPlayerDamage(weaponid, Float:reported_damage)
{
    // Значения синхронизированы с m_fWeaponDamages мобильного клиента.
    switch(weaponid)
    {
        case 0 .. 15:
        {
            if(reported_damage > 5.0 && reported_damage <= 25.0) return reported_damage;
            return 5.0;
        }
        case 16: return 75.0;
        case 18: return 75.0;
        case 22: return 25.0;
        case 23: return 10.0;
        case 24: return 45.0;
        case 25: return 40.0;
        case 26 .. 31: return 10.0;
        case 32: return 20.0;
        case 33, 34: return 45.0;
        case 35, 36: return 75.0;
        case 37: return 5.0;
        case 38: return 70.0;
        case 39: return 75.0;
        case 41: return 1.0;
        case 42: return 5.0;
    }

    if(reported_damage < 0.0) return 0.0;
    if(reported_damage > 75.0) return 75.0;
    return reported_damage;
}

// V11: authoritative health replay for the mobile client.
// The custom damage path blocks the stock GiveTakeDamage handling, so some
// clients keep their local HP at the pre-hit value until a later sync/death.
new g_damage_health_sync_token[MAX_PLAYERS];

forward DamageHealthResync(playerid, token, race);
public DamageHealthResync(playerid, token, race)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(mysql_race[playerid] != race) return 0;
    if(g_damage_health_sync_token[playerid] != token) return 0;
    if(!IsPlayerLogged(playerid)) return 0;

    new Float:hp = GetPlayerHealthEx(playerid);
    if(hp <= 0.0) return 0; // death is handled by the normal V9/V10 path
    if(hp > 100.0) hp = 100.0;

    SetPlayerHealth(playerid, hp);
    return 1;
}

stock DamageHealthScheduleResync(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;

    new token = ++g_damage_health_sync_token[playerid];
    if(token <= 0)
    {
        token = 1;
        g_damage_health_sync_token[playerid] = token;
    }

    SetTimerEx("DamageHealthResync", 70, false, "iii", playerid, token, mysql_race[playerid]);
    SetTimerEx("DamageHealthResync", 220, false, "iii", playerid, token, mysql_race[playerid]);
    return 1;
}

stock ApplyServerPlayerDamage(playerid, issuerid, Float:reported_damage, weaponid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(issuerid == INVALID_PLAYER_ID || issuerid < 0 || issuerid >= MAX_PLAYERS || !IsPlayerConnected(issuerid)) return 0;
    if(playerid == issuerid || GetPVarInt(playerid, "agm")) return 0;
    if(reported_damage <= 0.0) return 0;

    new Float:damage = GetServerPlayerDamage(weaponid, reported_damage);
    if(damage <= 0.0) return 0;

    // Ранение (systems/wounded.pwn): любой удар по раненому - добивание.
    // Первые WOUND_GRACE_MS после ранения удары игнорируются (тот же залп).
    if(Wounded_IsWounded(playerid))
    {
        if(Wounded_InGrace(playerid))
        {
            SetPlayerHealth(playerid, GetPlayerHealthEx(playerid));
            DamageHealthScheduleResync(playerid);
        }
        else Wounded_Finish(playerid, issuerid, weaponid);
        return 1;
    }

    new Float:armour;
    GetPlayerArmour(playerid, armour);

    if(armour > 0.0)
    {
        if(armour >= damage)
        {
            SetPlayerArmour(playerid, armour - damage);
            // Client may already have changed its local health bar. Keep server HP authoritative.
            SetPlayerHealth(playerid, GetPlayerHealthEx(playerid));
            return 1;
        }
        damage -= armour;
        SetPlayerArmour(playerid, 0.0);
    }

    new Float:health = GetPlayerHealthEx(playerid);
    health -= damage;
    if(health < 0.0) health = 0.0;

    // Keep exact kill credit before forcing HP to zero. SetPlayerHealth() does
    // not carry issuerid/weaponid into OnPlayerDeath on every mobile client.
    if(health <= 0.0)
    {
        // Смертельный удар другого игрока: вместо смерти - ранение (10 HP + меню помощи)
        if(Wounded_CanBeWounded(playerid))
        {
            Wounded_Begin(playerid, issuerid, weaponid);
            DamageHealthScheduleResync(playerid);
            return 1;
        }

        // РАНЬШЕ: SetPlayerHealthEx(playerid, 0.0) убивало игрока по-настоящему, клиент
        // проходил свой цикл wasted -> сам просил спавн через ~3-4 сек - игрока переносило
        // в ЦБ мгновенно (до того как смерть "показалась"), а через 4 сек второй раз, из-за
        // чего слетал интерьер. Тот же баг и то же исправление, что в Wounded_ToHospital /
        // Wounded_Finish (systems/wounded.pwn): реальной смерти не будет вообще.
        SetPVarInt(playerid, "server_death_killer", issuerid + 1);
        SetPVarInt(playerid, "server_death_weapon", weaponid);
        SetPVarInt(playerid, "server_death_tick", GetTickCount());

        // 1) смерть засчитывается один раз (family_addition.pwn подставит killerid/weapon
        // из pvar'ов выше и погасит любой случайный поздний OnPlayerDeath от клиента)
        SetPVarInt(playerid, "death_manual_call", 1);
        CallLocalFunction("OnPlayerDeath", "iii", playerid, INVALID_PLAYER_ID, 255);

        new death_stamp = GetTickCount();
        if(death_stamp == 0) death_stamp = 1;
        SetPVarInt(playerid, "wound_manual_death_tick", death_stamp);

        // то, что игрок терял бы при настоящей смерти (оружие/броню)
        ResetPlayerWeapons(playerid);
        SetPlayerArmour(playerid, 0.0);

        // 2) перенос в ЦБ уже произошёл внутри OnPlayerDeath (callbacks_01.inc) синхронно, выше
        new hospital_token = GetPVarInt(playerid, "hospital_spawn_token");

        // 3) подстраховка интерьера/вирт. мира
        SetTimerEx("Wounded_EnsureCB", 5000, false, "iii", playerid, hospital_token, mysql_race[playerid]);
        SetTimerEx("Wounded_EnsureCB", 9000, false, "iii", playerid, hospital_token, mysql_race[playerid]);
        return 1;
    }

    SetPlayerHealthEx(playerid, health);
    if(health > 0.0) DamageHealthScheduleResync(playerid);
    return 1;
}

// RPC 115 (GiveTakeDamage) is the authoritative player-vs-player damage source.
// true = TakeDamage report, false = GiveDamage report. We apply GiveDamage only
// so the same hit is never counted twice when both clients report it.
new g_damage_rpc_tick[MAX_PLAYERS];
new g_damage_rpc_target[MAX_PLAYERS];
new g_damage_rpc_weapon[MAX_PLAYERS];

stock bool:DamageRpc_IsImmediateDuplicate(playerid, targetid, weaponid)
{
    new now = GetTickCount();
    if(g_damage_rpc_target[playerid] == targetid &&
       g_damage_rpc_weapon[playerid] == weaponid &&
       now - g_damage_rpc_tick[playerid] >= 0 &&
       now - g_damage_rpc_tick[playerid] <= 10)
    {
        return true;
    }

    g_damage_rpc_tick[playerid] = now;
    g_damage_rpc_target[playerid] = targetid;
    g_damage_rpc_weapon[playerid] = weaponid;
    return false;
}

stock DamageRpc_Handle115(playerid, bool:take_damage, targetid, Float:damage, weaponid, bodypart)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;

    // The victim also reports TakeDamage. Ignore that side and trust the shooter's GiveDamage
    // to avoid applying one hit twice.
    if(take_damage) return 1;

    if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid)) return 0;
    if(targetid == playerid) return 0;
    if(damage <= 0.0) return 0;
    if(weaponid < 0 || weaponid > 54) return 0;
    if(bodypart < 0 || bodypart > 9) bodypart = 3;

    // Protect against the same RPC being delivered through both native RakNet and packet 252.
    if(DamageRpc_IsImmediateDuplicate(playerid, targetid, weaponid)) return 1;

    return HandleServerTakeDamage(targetid, playerid, damage, weaponid, bodypart);
}

stock bool:MedBed_IsPlayerInHospitalArea(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 150.0, 1484.458862, 2494.261474, 2501.000000)) return true;
    if(IsPlayerInRangeOfPoint(playerid, 70.0, 2035.7643, 1416.3625, 999.7344)) return true;
    return false;
}

// Новая больница (ЦБ): интерьер 1, оба этажа. Здесь умирающие появляются и лечатся.
stock bool:Hospital_IsPlayerInsideCB(playerid)
{
    return IsPlayerInRangeOfPoint(playerid, 150.0, 1484.458862, 2494.261474, 2501.000000);
}

stock GetNearestMedBed(playerid, Float:range = 2.7)
{
    for(new i; i < sizeof g_med_bed_pos; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, range, g_med_bed_pos[i][0], g_med_bed_pos[i][1], g_med_bed_pos[i][2])) return i;
    }
    return -1;
}

stock bool:IsMedBedDynamicArea(areaid)
{
    return (
        areaid == koika1 || areaid == koika2 || areaid == koika3 || areaid == koika4 ||
        areaid == koika5 || areaid == koika6 || areaid == koika7 || areaid == koika8 ||
        areaid == koika9 || areaid == koika10 || areaid == koika11 || areaid == koika12 ||
        areaid == koika13 || areaid == koika14 || areaid == koika15 || areaid == koika16 ||
        areaid == koika17 || areaid == koika18 || areaid == koika19 || areaid == koika20 ||
        areaid == koika21 || areaid == koika22 || areaid == koika23 || areaid == koika24 ||
        areaid == koika25 || areaid == koika26 || areaid == koika27 || areaid == koika28 ||
        areaid == koika29 || areaid == koika30 || areaid == koika31 || areaid == koika32
    );
}

stock ClearMedBed(playerid, bedid)
{
    if(!(0 <= bedid < sizeof g_med_bed_used)) return 0;

    if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
    {
        SetPlayerData(playerid, P_OCCUPIED_BED, -1);
    }

    g_med_bed_used[bedid] = false;
    UpdateMedBed(bedid);
    return 1;
}

stock UpdateMedBed(bedid)
{
    if(!(0 <= bedid < sizeof g_med_bed_used)) return 0;
    new fmt_text[220];
    format(fmt_text, sizeof fmt_text,
        "{ffff00}« Свободная больничная койка »\n\n{ffff00}|{ffffff}Номер койки: {ffff00}%d\n{ffff00}|{ffffff}Пациент: {ffff00}отсутствует\n\n{ffffff}Подойдите ближе для взаимодействия",
        bedid + 1);
    UpdateDynamic3DTextLabelText(g_med_bed_label[bedid], 0xFFFFFFEE, fmt_text);
    return 1;
}

stock MedBed_TryOccupy(playerid, bedid = -1)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    // Уже лежит на койке: ничего не показываем и не создаём повторное взаимодействие.
    if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1) return 1;
    if(!MedBed_IsPlayerInHospitalArea(playerid)) return 1;

    if(bedid < 0 || bedid >= sizeof g_med_bed_pos ||
       !IsPlayerInRangeOfPoint(playerid, 2.8, g_med_bed_pos[bedid][0], g_med_bed_pos[bedid][1], g_med_bed_pos[bedid][2]))
    {
        bedid = GetNearestMedBed(playerid, 2.8);
    }
    if(bedid == -1) return 1;

    if(GetPlayerHealthEx(playerid) >= 95.0)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не нуждаетесь в лечении");
    if(g_med_bed_used[bedid])
        return SendClientMessage(playerid, 0xCECECEFF, "Эта койка занята");

    SetPlayerData(playerid, P_OCCUPIED_BED, bedid);
    g_med_bed_used[bedid] = true;

    new fmt_msg[220];
    format(fmt_msg, sizeof fmt_msg,
        "{ffff00}« Занятая больничная койка »\n\n{ffff00}|{ffffff}Номер койки: {ffff00}%d\n{ffffff}Пациент: {ffff00}%s",
        bedid + 1, GetPlayerNameEx(playerid));
    UpdateDynamic3DTextLabelText(g_med_bed_label[bedid], 0xFFFFFFFF, fmt_msg);

    format(fmt_msg, sizeof fmt_msg,
        "Вы заняли койку №%d. В зависимости от состояния здоровья лечение может занять время", bedid + 1);
    SendClientMessage(playerid, 0x32a44bFF, fmt_msg);
    SendClientMessage(playerid, -1, "Чтобы выписаться подойдите к врачу или выйдите за пределы больницы");

    // Перезаписываем интерактивный notify обычным коротким сообщением без кнопки.
    ShowNotificationNew(playerid, 3, 2, 0, 0, "Вы заняли больничную койку", "");
    return 1;
}

public: HospitalTreatment()
{
    for(new playerid; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid)) continue;
        else if(!IsPlayerLogged(playerid)) continue;
        else if(GetPlayerData(playerid, P_OCCUPIED_BED) == -1) continue;
        if(!MedBed_IsPlayerInHospitalArea(playerid))
        {
            ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
        }
					else
        {
            new Float:health = GetPlayerHealthEx(playerid);
            if(health >= 100.0) // Проверка на максимальное здоровье
            {
                SendClientMessage(playerid, 0x32a44bFF, "Лечение завершено! Вы полностью здоровы.");
                ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
            }
					else
            {
                // Добавляем здоровье с ограничением до 100.0
                new Float:newhealth = health + 3.0;
                if(newhealth > 100.0) newhealth = 100.0;
                
                GameTextForPlayer(playerid, "~g~~h~~h~+ 3 HP", 1000, 4);
                SetPlayerChatBubble(playerid, "+3 hp", 0x33CC33FF, 5.0, 1000);
                SetPlayerHealthEx(playerid, newhealth);
            }
        }
    }
    SetTimer("HospitalTreatment", (random(5) + 1) * 1000, false);
    return 1;
}

stock FormatNumberDots(value, dest[], size = sizeof(dest))
{
	new src[24], rev[32], idx, count;
	format(src, sizeof src, "%d", value);

	for(new i = strlen(src) - 1; i >= 0; i--)
	{
		if(count == 3)
		{
			rev[idx++] = '.';
			count = 0;
		}
		rev[idx++] = src[i];
		count++;
	}
	rev[idx] = EOS;

	new len = strlen(rev);
	idx = 0;
	for(new i = len - 1; i >= 0 && idx < size - 1; i--)
	{
		dest[idx++] = rev[i];
	}
	dest[idx] = EOS;
	return 1;
}

stock GetCarMarketIdByBizId(biz_id)
{
	switch(biz_id)
	{
		case STATIC_BIZ_ID_MOTO_SALON: return MOTO_SALON_MARKET_ID;
		case 35: return 1;
		case 36: return 2;
		case 37: return 3;
		case STATIC_BIZ_ID_TRUCK_SALON: return TRUCK_SALON_MARKET_ID;
	}
	return -1;
}

stock GetBizIdByCarMarketId(car_market_id)
{
	switch(car_market_id)
	{
		case MOTO_SALON_MARKET_ID: return STATIC_BIZ_ID_MOTO_SALON;
		case 1: return 35;
		case 2: return 36;
		case 3: return 37;
		case TRUCK_SALON_MARKET_ID: return STATIC_BIZ_ID_TRUCK_SALON;
	}
	return -1;
}

stock bool:AutosalonHasBusinessProducts(playerid, car_market_id, &businessid)
{
	businessid = GetBizIdByCarMarketId(car_market_id);
	if(businessid < 0 || businessid >= g_business_loaded ||
		GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_CAR_MARKET)
	{
		SendClientMessage(playerid, 0xCECECEFF, "Автосалон временно недоступен.");
		return false;
	}
	if(GetBusinessData(businessid, B_PRODS) < AUTOSALON_PRODUCTS_PER_CAR)
	{
		SendClientMessage(playerid, 0xCECECEFF, "В автосалоне закончились продукты. Владелец должен пополнить склад.");
		return false;
	}
	return true;
}

stock AutosalonUseBusinessProducts(businessid, playerid, vehicle_price)
{
	if(businessid < 0 || businessid >= g_business_loaded) return 0;
	AddBusinessData(businessid, B_PRODS, -, AUTOSALON_PRODUCTS_PER_CAR);
	new owner_income = vehicle_price * 20 / 100;
	AddBusinessData(businessid, B_BALANCE, +, owner_income);
	new query[320];
	mysql_format(mysql, query, sizeof query,
		"UPDATE business SET products=%d,balance=%d WHERE id=%d LIMIT 1",
		GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_BALANCE),
		GetBusinessData(businessid, B_SQL_ID));
	mysql_query(mysql, query, false);
	mysql_format(mysql, query, sizeof query,
		"INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)",
		GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid),
		gettime(), owner_income, IsBusinessOwned(businessid));
	mysql_query(mysql, query, false);
	CallLocalFunction("UpdateBusinessLabel", "i", businessid);
	return 1;
}

stock bool:IsMotoSalonBiz(biz_id)
{
	return biz_id == STATIC_BIZ_ID_MOTO_SALON;
}

stock GetCarMarketDialogName(car_market_id, dest[], size = sizeof dest)
{
	if(car_market_id == MOTO_SALON_MARKET_ID)
	{
		format(dest, size, "Мотосалон");
	}
	else if(car_market_id == TRUCK_SALON_MARKET_ID)
	{
		format(dest, size, "Автосалон");
	}
	else
	{
		format(dest, size, "Автосалон");
	}
	return 1;
}

stock IsMotoSalonCameraAnimating(playerid)
{
	if(GetPlayerInBiz(playerid) != STATIC_BIZ_ID_MOTO_SALON) return 0;
	return GetPVarInt(playerid, "moto_salon_camera_anim_until") > GetTickCount();
}

