} 
 
    if(FamWar_ForceAllowDamage) 
    { 
        return 1; 
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

    if(!weaponid) 
    { 
        new Float: armour, Float: health; 
 
        GetPlayerHealth(playerid, health); 
        GetPlayerArmour(playerid, armour); 
 
        if(armour > 0.0) 
        { 
            if(armour >= 5.0) 
            { 
                SetPlayerArmour(playerid, armour - 5.0); 
            } 
            else 
            { 
                new Float: leftover = 5.0 - armour; 
                SetPlayerArmour(playerid, 0.0); 
                SetPlayerHealth(playerid, health - leftover); 
            } 
        } 
        else 
        { 
            SetPlayerHealth(playerid, health - 5.0); 
        } 

        return 0; 
    } 
 
    return 1; 
}
