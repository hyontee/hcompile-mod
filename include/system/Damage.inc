#if defined _INC_Damage
    #endinput
#else
    #define _INC_Damage
#endif

// NOTE: FamWar_ForceAllowDamage is now defined for real in family_war.pwn
// (make sure family_war.pwn is #included BEFORE this file).
//
// NOTE: there is no working duel system in the project yet (only unused
// timeduel/DuelCash variables exist), so Duel_ForceAllowDamage below is a
// stub that always returns false: code compiles and works as usual (no
// forced damage) until a real duel system exists. Once it does, declare
// Duel_ForceAllowDamage(playerid, issuerid) in it BEFORE this #include and
// delete the stub below.
// NOTE: intentionally NOT wrapped in "#if !defined FuncName" - that check
// is unreliable for functions in Pawn (only reliable for #define macros)
// and can cause error 004 "function not implemented".
stock bool:Duel_ForceAllowDamage(playerid, issuerid)
{
    #pragma unused playerid
    #pragma unused issuerid
    return false;
}

public OnGameModeInit()
{
    new tick = GetTickCount();

    printf("Модуль загружен за %d секунд", tick);
    #if defined damage_OnGameModeInit
        return damage_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit damage_OnGameModeInit
#if defined damage_OnGameModeInit
    forward damage_OnGameModeInit();
#endif

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    new fmt_text[700];
    new Float: health;

    // fix: family war participants ALWAYS take real damage from each other,
    // no matter what weapon the game thinks is in their hand and no matter
    // what other system in the gamemode might otherwise block/reduce it.
    if(FamWar_ForceAllowDamage(playerid, issuerid))
    {
        new Float:hp, Float:ar;
        GetPlayerHealth(playerid, hp);
        GetPlayerArmour(playerid, ar);

        new Float:dmg = amount;
        if(dmg < 25.0) dmg = 25.0; // guarantee kill is possible even with fists (weaponid 0)

        new Float:leftover_health = hp;

        if(ar > 0.0)
        {
            if(dmg >= ar)
            {
                new Float:leftover = dmg - ar;
                SetPlayerArmour(playerid, 0.0);
                leftover_health = hp - leftover;
            }
            else
            {
                SetPlayerArmour(playerid, ar - dmg);
                leftover_health = hp;
            }
        }
        else
        {
            leftover_health = hp - dmg;
        }

        // fix: SetPlayerHealth() alone never actually kills a player in SA-MP -
        // the client only reports a death when it detects health hit 0 from
        // *real* engine-processed damage. Since we bypass that (return 0 below),
        // health was getting stuck at/near 0 forever ("РЅРµСѓР±РёРІР°РµРјС‹Р№"). Now, once
        // our manually-computed health drops to 0 or below, we force a real
        // kill + immediate respawn ourselves instead of just clamping the number.
        if(leftover_health <= 0.0)
        {
            SetPlayerHealth(playerid, 0.0);
            printf("[FAMWAR DEBUG] FORCED KILL: issuer=%d victim=%d weapon=%d amount=%f hp_before=%f ar_before=%f", issuerid, playerid, weaponid, amount, hp, ar);

            OnPlayerDeath(playerid, issuerid, weaponid);
            SpawnPlayer(playerid);
        }
        else
        {
            SetPlayerHealth(playerid, leftover_health);
            printf("[FAMWAR DEBUG] dmg FORCED: issuer=%d victim=%d weapon=%d amount=%f hp_before=%f ar_before=%f", issuerid, playerid, weaponid, amount, hp, ar);
        }

        return 0; // we already applied the damage/death manually above
    }

    // fix: duel participants ALWAYS take real damage from each other, no
    // matter what weapon the game thinks is in their hand and no matter
    // what other system in the gamemode might otherwise block/reduce it
    // (e.g. green zones, anti-cheat weapon checks).
    if(Duel_ForceAllowDamage(playerid, issuerid))
    {
        new Float:hp, Float:ar;
        GetPlayerHealth(playerid, hp);
        GetPlayerArmour(playerid, ar);

        new Float:dmg = amount;
        if(dmg < 25.0) dmg = 25.0; // guarantee kill is possible even with fists (weaponid 0)

        new Float:leftover_health = hp;

        if(ar > 0.0)
        {
            if(dmg >= ar)
            {
                new Float:leftover = dmg - ar;
                SetPlayerArmour(playerid, 0.0);
                leftover_health = hp - leftover;
            }
            else
            {
                SetPlayerArmour(playerid, ar - dmg);
                leftover_health = hp;
            }
        }
        else
        {
            leftover_health = hp - dmg;
        }

        if(leftover_health <= 0.0)
        {
            SetPlayerHealth(playerid, 0.0);
            OnPlayerDeath(playerid, issuerid, weaponid);
            SpawnPlayer(playerid);
        }
        else
        {
            SetPlayerHealth(playerid, leftover_health);
        }

        return 0; // we already applied the damage/death manually above
    }

    if(GetPVarInt(playerid, "player_in_green_zone"))
    {
        new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;

        if(issuerid != INVALID_PLAYER_ID && !(TEAM_DPS <= GetPlayerTeamEx(issuerid) <= TEAM_FBI))
        {
            ClearPlayerAnim(issuerid);

            format
            (
                fmt_text, sizeof fmt_text,
                "{FFFFFF}"\
                "Предупреждение:\n\n"\
                "Игрок находится в зеленой зоне '{66CC33}%s{FFFFFF}'\n"\
                "Нанесение урона запрещено. При повторных попытках Вы будете кикнуты.",
                g_green_zones[green_zone_id][GZ_NAME]
            );

            ShowPlayerDialog(issuerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF5533}Зеленая зона", fmt_text, "Закрыть", "");

            format(fmt_text, sizeof fmt_text, "[SYSTEM] %s[%d] попытался ударить %s[%d] в зеленой зоне %s",
                GetPlayerNameEx(issuerid), issuerid, GetPlayerNameEx(playerid), playerid, g_green_zones[green_zone_id][GZ_NAME]);
            SendMessageToAdmins(fmt_text, 0xFF5533FF);

            return 0;
        }
    }

    if(issuerid == INVALID_PLAYER_ID) return 1;

    if(TEAM_DPS <= GetPlayerTeamEx(issuerid) <= TEAM_FBI)
    {
        if(weaponid == WEAPON_NITESTICK)
        {
            SetPlayerAnimation(playerid, 21);
            TogglePlayerControllable(playerid, false);

            SetTimerEx("unFreezePlayerExEx", 15000, false, "i", playerid);

            format(fmt_text, sizeof fmt_text, "Вы оглушили %s на 15 секунд", GetPlayerNameEx(playerid));
            SendClientMessage(issuerid, 0x3399FFFF, fmt_text);

            format(fmt_text, sizeof fmt_text, "%s оглушил Вас на 15 секунд", GetPlayerNameEx(issuerid));
            SendClientMessage(playerid, 0x3399FFFF, fmt_text);

            CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);
        }
    }

    if(GetPlayerData(issuerid, P_POWER))
    {
        if(!weaponid)
        {
            new Float: armour, Float: taken_health;

            GetPlayerHealth(playerid, health);
            GetPlayerArmour(playerid, armour);

            taken_health = GetPlayerData(issuerid, P_POWER) * 0.05;

            if(armour) SetPlayerArmour(playerid, armour - taken_health);
            else SetPlayerHealth(playerid, health - taken_health);
        }
    }

    return 1;
}