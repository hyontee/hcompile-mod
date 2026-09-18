CMD:settime(playerid, params[]) {

    extract params -> new time; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /settime [время (0-23)]");

	if(!(0 <= time <= 23)) return SendClientMessage(playerid, 0x999999FF, "Время от 0 до 23 часов");

	SetWorldTime(time);

	new fmt_text[70];

	format(fmt_text, sizeof fmt_text, "Вы установили время %02d:00", time);
	SendClientMessage(playerid, -1, fmt_text);

    return true;
}

CMD:setweather(playerid, params[])
{
    extract params -> new weather; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setweather [погода (0-20)]");

    if(!(0 <= weather <= 20))
    {
        SendClientMessage(playerid, 0x999999FF, "Погода от 0 до 20 (-1 - случайная смена погоды)");
        SendClientMessage(playerid, 0x999999FF, "Рекомендовано: 1, 3, 8, 9, 18");
        return 1;
    }

    SetWeather(weather);

    new fmt_text[70];
    format(fmt_text, sizeof fmt_text, "Вы установили погоду %d", weather);
    SendClientMessage(playerid, -1, fmt_text);
    return 1;
}

CMD:coord(playerid, params[])
{
    if(IsPlayerAdmin(playerid))
        return NotDostup(playerid);

    new Float:x, Float:y, Float:z, interior, virtual_world;

    if(sscanf(params, "P<,>fff", x, y, z))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /pos [x y z]");

    sscanf(params, "P<,>{fff}dd", interior, virtual_world);

    SetPlayerPos(playerid, x, y, z);
    SetPlayerInterior(playerid, interior);
    SetPlayerVirtualWorld(playerid, virtual_world);
    return 1;
}

stock CreateWeikObjects() {
	return true;
}
