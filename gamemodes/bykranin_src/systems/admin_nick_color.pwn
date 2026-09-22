//>> Файл: bykranin_src/systems/admin_nick_color.pwn
//>> Подключается из bykranin.pwn сразу после core/admin/admin_02.inc.
//>> Цвет ника: /nickcolor (себе; без аргументов - меню как раньше), /setnickcolor (другому игроку, админ 3+).
//>> Формат: RRGGBB | rainbow | off. Работает поверх существующей системы admin_02.inc
//>> (P_ADMIN_NICK_COLOR / P_ADMIN_NICK_RAINBOW / AdminNickRainbowTick) и сохраняется в accounts.nick_color / nick_rainbow.
#if defined _ADMIN_NICK_COLOR_INC
    #endinput
#endif
#define _ADMIN_NICK_COLOR_INC

stock bool:IsValidHexColor(const str[])
{
    if(strlen(str) != 6) return false;

    for(new i; i < 6; i++)
    {
        new c = str[i];
        if(!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')))
            return false;
    }
    return true;
}

// RRGGBB -> 0xRRGGBBAA (строка должна быть проверена через IsValidHexColor)
stock HexColorToRGBA(const str[])
{
    new value;
    for(new i; i < 6; i++)
    {
        new c = str[i];
        if(c >= '0' && c <= '9') c -= '0';
        else if(c >= 'a' && c <= 'f') c = c - 'a' + 10;
        else c = c - 'A' + 10;
        value = (value << 4) | c;
    }
    return (value << 8) | 0xFF;
}

stock SaveNickColor(playerid)
{
    new query[160];
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET nick_color=%d, nick_rainbow=%d WHERE id=%d LIMIT 1",
        GetPlayerData(playerid, P_ADMIN_NICK_COLOR), GetPlayerData(playerid, P_ADMIN_NICK_RAINBOW), GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query);
    return 1;
}

// rainbow = true -> переливающийся (обновляет AdminNickRainbowTick); color = 0 и rainbow = false -> сброс
stock ApplyNickColor(playerid, color, bool:rainbow)
{
    if(!IsPlayerConnected(playerid)) return 0;

    if(rainbow)
    {
        SetPlayerData(playerid, P_ADMIN_NICK_COLOR, 0);
        SetPlayerData(playerid, P_ADMIN_NICK_RAINBOW, 1);
        // визуально стартует со следующего тика AdminNickRainbowTick
    }
    else
    {
        SetPlayerData(playerid, P_ADMIN_NICK_RAINBOW, 0);
        SetPlayerData(playerid, P_ADMIN_NICK_COLOR, color);

        if(color) SetPlayerColorEx(playerid, color);
        else SetPlayerColorInit(playerid);
    }

    SaveNickColor(playerid);
    return 1;
}

CMD:nickcolor(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1 || !GetPlayerData(playerid, P_ADMIN_LOGGED))
        return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна только авторизованным администраторам.");

    new value[16];
    if(sscanf(params, "s[16]", value))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Использование: /nickcolor [RRGGBB|rainbow|off]");
        ShowAdminNickColorMenu(playerid);
        return 1;
    }

    if(value[0] == '#') strdel(value, 0, 1);

    if(!strcmp(value, "rainbow", true))
    {
        ApplyNickColor(playerid, 0, true);
        SendClientMessage(playerid, 0x1E90FFFF, "Установлен переливающийся цвет ника");
        return 1;
    }

    if(!strcmp(value, "off", true))
    {
        ApplyNickColor(playerid, 0, false);
        SendClientMessage(playerid, 0x1E90FFFF, "Цвет ника сброшен");
        return 1;
    }

    if(!IsValidHexColor(value))
        return SendClientMessage(playerid, 0xCECECEFF, "Неверный формат. Пример: /nickcolor FF8800");

    ApplyNickColor(playerid, HexColorToRGBA(value), false);
    SendClientMessage(playerid, 0x1E90FFFF, "Цвет ника изменён");
    return 1;
}

CMD:setnickcolor(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 || !GetPlayerData(playerid, P_ADMIN_LOGGED))
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет доступа");

    new to_player, value[16];
    if(sscanf(params, "us[16]", to_player, value))
        return SendClientMessage(playerid, 0xCECECEFF, "Использование: /setnickcolor [id] [RRGGBB|rainbow|off]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не в сети");

    if(value[0] == '#') strdel(value, 0, 1);

    if(!strcmp(value, "rainbow", true))
    {
        ApplyNickColor(to_player, 0, true);
    }
    else if(!strcmp(value, "off", true))
    {
        ApplyNickColor(to_player, 0, false);
    }
    else
    {
        if(!IsValidHexColor(value))
            return SendClientMessage(playerid, 0xCECECEFF, "Неверный формат. Пример: /setnickcolor 0 FF8800");

        ApplyNickColor(to_player, HexColorToRGBA(value), false);
    }

    new fmt_text[128];
    format(fmt_text, sizeof fmt_text, "Админ %s изменил цвет вашего ника", GetPlayerNameEx(playerid));
    SendClientMessage(to_player, 0x1E90FFFF, fmt_text);

    format(fmt_text, sizeof fmt_text, "Вы изменили цвет ника игроку %s", GetPlayerNameEx(to_player));
    SendClientMessage(playerid, 0x1E90FFFF, fmt_text);
    return 1;
}
