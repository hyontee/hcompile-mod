#if defined _INC_Damage
    #endinput
#else
    #define _INC_Damage
#endif

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
    new bool: skip_general_damage = false;
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

            SetTimerEx("UnFreezePlayerEx", 15000, false, "i", playerid);

            format(fmt_text, sizeof fmt_text, "Вы оглушили %s на 15 секунд", GetPlayerNameEx(playerid));
            SendClientMessage(issuerid, 0x3399FFFF, fmt_text);

            format(fmt_text, sizeof fmt_text, "%s оглушил Вас на 15 секунд", GetPlayerNameEx(issuerid));
            SendClientMessage(playerid, 0x3399FFFF, fmt_text);

            // Дубинка полиции — это оглушение/задержание, а не урон.
            skip_general_damage = true;
        }
    }

    if(GetPlayerData(issuerid, P_POWER))
    {
        if(!weaponid)
        {
            new Float: armour, Float: taken_health;
            new Float: health = GetPlayerHealthEx(playerid);

            GetPlayerArmour(playerid, armour);

            taken_health = GetPlayerData(issuerid, P_POWER) * 0.05;

            if(armour) SetPlayerArmour(playerid, armour - taken_health);
            else SetPlayerHealthEx(playerid, health - taken_health);

            // Урон от кулака уже применён выше вручную (с учётом P_POWER).
            skip_general_damage = true;
        }
    }

    // Основной урон: раньше выстрелы/удары (кроме двух частных случаев выше)
    // вообще не отнимали здоровье/броню — отсюда "неубиваемые" игроки.
    // Важно: здоровье в этом гейммоде хранится в P_HEALTH и синхронизируется
    // через SetPlayerHealthEx — обычный SetPlayerHealth затирается обратно.
    if(!skip_general_damage)
    {
        new Float: cur_health = GetPlayerHealthEx(playerid);
        new Float: cur_armour;

        GetPlayerArmour(playerid, cur_armour);

        if(cur_armour > 0.0)
        {
            if(cur_armour > amount)
            {
                SetPlayerArmour(playerid, cur_armour - amount);
            }
            else
            {
                SetPlayerArmour(playerid, 0.0);
                SetPlayerHealthEx(playerid, cur_health - (amount - cur_armour));
            }
        }
        else
        {
            SetPlayerHealthEx(playerid, cur_health - amount);
        }
    }

    return 1;
}
