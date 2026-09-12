#define USCT "{ff2400}| {ffffff}"
#define SCT  "{ffff00}| {ffffff}"

new Text:tel_TD[14];
new Text:tel_pass_TD[2];
new PlayerText:tel_pass_PTD[MAX_PLAYERS][8];

public OnGameModeInit()
{
tel_TD[0] = TextDrawCreate(457.7997, -0.8044, "tel:tel_main"); // основной фон
TextDrawTextSize(tel_TD[0], 183.0000, 451.0000);
TextDrawAlignment(tel_TD[0], 1);
TextDrawColor(tel_TD[0], -1);
TextDrawBackgroundColor(tel_TD[0], 255);
TextDrawFont(tel_TD[0], 4);
TextDrawSetProportional(tel_TD[0], 0);
TextDrawSetShadow(tel_TD[0], 0);

tel_TD[1] = TextDrawCreate(535.1993, 24.7377, "12:52"); // время
TextDrawLetterSize(tel_TD[1], 0.5012, 3.6558);
TextDrawTextSize(tel_TD[1], 0.0000, -57.0000);
TextDrawAlignment(tel_TD[1], 2);
TextDrawColor(tel_TD[1], -1);
TextDrawBackgroundColor(tel_TD[1], 255);
TextDrawFont(tel_TD[1], 2);
TextDrawSetProportional(tel_TD[1], 1);
TextDrawSetShadow(tel_TD[1], 0);

tel_TD[2] = TextDrawCreate(472.1999, 387.4621, "tel:tel_call"); // приложение звонка
TextDrawTextSize(tel_TD[2], 23.0000, 38.0000);
TextDrawAlignment(tel_TD[2], 1);
TextDrawColor(tel_TD[2], -1);
TextDrawBackgroundColor(tel_TD[2], 255);
TextDrawFont(tel_TD[2], 4);
TextDrawSetProportional(tel_TD[2], 0);
TextDrawSetShadow(tel_TD[2], 0);
TextDrawSetSelectable(tel_TD[2], true);

tel_TD[3] = TextDrawCreate(503.8000, 387.4621, "tel:tel_sms"); // приложение смс
TextDrawTextSize(tel_TD[3], 22.0000, 38.0000);
TextDrawAlignment(tel_TD[3], 1);
TextDrawColor(tel_TD[3], -1);
TextDrawBackgroundColor(tel_TD[3], 255);
TextDrawFont(tel_TD[3], 4);
TextDrawSetProportional(tel_TD[3], 0);
TextDrawSetShadow(tel_TD[3], 0);
TextDrawSetSelectable(tel_TD[3], true);

tel_TD[4] = TextDrawCreate(535.4001, 387.4621, "tel:tel_settings"); // приложение настроек
TextDrawTextSize(tel_TD[4], 22.0000, 38.0000);
TextDrawAlignment(tel_TD[4], 1);
TextDrawColor(tel_TD[4], -1);
TextDrawBackgroundColor(tel_TD[4], 255);
TextDrawFont(tel_TD[4], 4);
TextDrawSetProportional(tel_TD[4], 0);
TextDrawSetShadow(tel_TD[4], 0);
TextDrawSetSelectable(tel_TD[4], true);

tel_TD[5] = TextDrawCreate(567.4002, 387.4621, "tel:tel_carsharing"); // приложение каршеринга
TextDrawTextSize(tel_TD[5], 22.0000, 38.0000);
TextDrawAlignment(tel_TD[5], 1);
TextDrawColor(tel_TD[5], -1);
TextDrawBackgroundColor(tel_TD[5], 255);
TextDrawFont(tel_TD[5], 4);
TextDrawSetProportional(tel_TD[5], 0);
TextDrawSetShadow(tel_TD[5], 0);
TextDrawSetSelectable(tel_TD[5], true);

tel_TD[6] = TextDrawCreate(505.4004, 104.2268, "tel:tel_family"); // приложение меню семьи
TextDrawTextSize(tel_TD[6], 22.0000, 49.0000);
TextDrawAlignment(tel_TD[6], 1);
TextDrawColor(tel_TD[6], -1);
TextDrawBackgroundColor(tel_TD[6], 255);
TextDrawFont(tel_TD[6], 4);
TextDrawSetProportional(tel_TD[6], 0);
TextDrawSetShadow(tel_TD[6], 0);
TextDrawSetSelectable(tel_TD[6], true);

tel_TD[7] = TextDrawCreate(474.6004, 103.7290, "tel:tel_gps"); // приложение gps
TextDrawTextSize(tel_TD[7], 22.0000, 49.0000);
TextDrawAlignment(tel_TD[7], 1);
TextDrawColor(tel_TD[7], -1);
TextDrawBackgroundColor(tel_TD[7], 255);
TextDrawFont(tel_TD[7], 4);
TextDrawSetProportional(tel_TD[7], 0);
TextDrawSetShadow(tel_TD[7], 0);
TextDrawSetSelectable(tel_TD[7], true);

tel_TD[8] = TextDrawCreate(535.4003, 103.7290, "tel:tel_gosyslygi"); // приложение Гос Услуги
TextDrawTextSize(tel_TD[8], 22.0000, 50.0000);
TextDrawAlignment(tel_TD[8], 1);
TextDrawColor(tel_TD[8], -1);
TextDrawBackgroundColor(tel_TD[8], 255);
TextDrawFont(tel_TD[8], 4);
TextDrawSetProportional(tel_TD[8], 0);
TextDrawSetShadow(tel_TD[8], 0);
TextDrawSetSelectable(tel_TD[8], true);

tel_TD[9] = TextDrawCreate(564.6005, 103.7290, "tel:tel_gifts"); // приложение с подарками
TextDrawTextSize(tel_TD[9], 28.0000, 57.0000);
TextDrawAlignment(tel_TD[9], 1);
TextDrawColor(tel_TD[9], -1);
TextDrawBackgroundColor(tel_TD[9], 255);
TextDrawFont(tel_TD[9], 4);
TextDrawSetProportional(tel_TD[9], 0);
TextDrawSetShadow(tel_TD[9], 0);
TextDrawSetSelectable(tel_TD[9], true);

tel_TD[10] = TextDrawCreate(610.6000, 12.6355, "tel:transparent"); // кнопка выхода
TextDrawTextSize(tel_TD[10], 27.0000, 23.0000);
TextDrawAlignment(tel_TD[10], 1);
TextDrawColor(tel_TD[10], -1);
TextDrawBackgroundColor(tel_TD[10], 255);
TextDrawFont(tel_TD[10], 4);
TextDrawSetProportional(tel_TD[10], 0);
TextDrawSetShadow(tel_TD[10], 0);
TextDrawSetSelectable(tel_TD[10], true);

tel_TD[11] = TextDrawCreate(606.5999, 118.6621, "tel:transparent"); // кнопка статистики игрока
TextDrawTextSize(tel_TD[11], 33.0000, 53.0000);
TextDrawAlignment(tel_TD[11], 1);
TextDrawColor(tel_TD[11], -1);
TextDrawBackgroundColor(tel_TD[11], 255);
TextDrawFont(tel_TD[11], 4);
TextDrawSetProportional(tel_TD[11], 0);
TextDrawSetShadow(tel_TD[11], 0);
TextDrawSetSelectable(tel_TD[11], true);

tel_TD[12] = TextDrawCreate(606.1998, 223.6932, "tel:transparent"); // кнопка открытия инвентаря
TextDrawTextSize(tel_TD[12], 33.0000, 53.0000);
TextDrawAlignment(tel_TD[12], 1);
TextDrawColor(tel_TD[12], -1);
TextDrawBackgroundColor(tel_TD[12], 255);
TextDrawFont(tel_TD[12], 4);
TextDrawSetProportional(tel_TD[12], 0);
TextDrawSetShadow(tel_TD[12], 0);
TextDrawSetSelectable(tel_TD[12], true);

tel_TD[13] = TextDrawCreate(606.2000, 276.4577, "tel:transparent"); // кнопка помощи
TextDrawTextSize(tel_TD[13], 33.0000, 53.0000);
TextDrawAlignment(tel_TD[13], 1);
TextDrawColor(tel_TD[13], -1);
TextDrawBackgroundColor(tel_TD[13], 255);
TextDrawFont(tel_TD[13], 4);
TextDrawSetProportional(tel_TD[13], 0);
TextDrawSetShadow(tel_TD[13], 0);
TextDrawSetSelectable(tel_TD[13], true);

tel_pass_TD[0] = TextDrawCreate(189.4000, 94.7689, "tel:tel_pass"); // фон паспорта
TextDrawTextSize(tel_pass_TD[0], 243.0000, 256.0000);
TextDrawAlignment(tel_pass_TD[0], 1);
TextDrawColor(tel_pass_TD[0], -1);
TextDrawBackgroundColor(tel_pass_TD[0], 255);
TextDrawFont(tel_pass_TD[0], 4);
TextDrawSetProportional(tel_pass_TD[0], 0);
TextDrawSetShadow(tel_pass_TD[0], 0);

tel_pass_TD[1] = TextDrawCreate(401.3999, 95.2666, "tel:transparent"); // закрыть паспорт
TextDrawTextSize(tel_pass_TD[1], 31.0000, 38.0000);
TextDrawAlignment(tel_pass_TD[1], 1);
TextDrawColor(tel_pass_TD[1], -1);
TextDrawBackgroundColor(tel_pass_TD[1], 255);
TextDrawFont(tel_pass_TD[1], 4);
TextDrawSetProportional(tel_pass_TD[1], 0);
TextDrawSetShadow(tel_pass_TD[1], 0);
TextDrawSetSelectable(tel_pass_TD[1], true);

    #if defined telp_OnGameModeInit
        return telp_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit telp_OnGameModeInit
#if defined telp_OnGameModeInit
    forward telp_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
tel_pass_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 200.3999, 153.1644, "Werton_Werton"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][0], 0.2267, 1.5402);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][0], 1);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][0], 255);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][0], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][0], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][0], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][0], 0);

tel_pass_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 200.0000, 184.5245, "Мужской"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][1], 0.2472, 1.6497);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][1], 1);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][1], 255);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][1], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][1], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][1], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][1], 0);

tel_pass_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 200.0001, 216.8800, "ОПГ"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][2], 0.2444, 1.4755);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][2], 1);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][2], 255);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][2], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][2], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][2], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][2], 0);

tel_pass_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 200.0001, 245.7510, "Нет"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][3], 0.2444, 1.4755);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][3], 1);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][3], 255);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][3], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][3], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][3], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][3], 0);

tel_pass_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 310.8001, 152.6667, "25"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][4], 0.2444, 1.4755);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][4], 1);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][4], 255);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][4], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][4], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][4], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][4], 0);

tel_pass_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 310.8001, 185.0222, "Бомж"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][5], 0.2444, 1.4755);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][5], 1);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][5], 255);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][5], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][5], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][5], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][5], 0);

tel_pass_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 310.4001, 216.3822, "Нет"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][6], 0.2444, 1.4755);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][6], 1);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][6], 255);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][6], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][6], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][6], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][6], 0);

tel_pass_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 396.8001, 105.8755, "№_03_00001103"); // пусто
PlayerTextDrawLetterSize(playerid, tel_pass_PTD[playerid][7], 0.1707, 1.1669);
PlayerTextDrawAlignment(playerid, tel_pass_PTD[playerid][7], 3);
PlayerTextDrawColor(playerid, tel_pass_PTD[playerid][7], -2139062017);
PlayerTextDrawBackgroundColor(playerid, tel_pass_PTD[playerid][7], 255);
PlayerTextDrawFont(playerid, tel_pass_PTD[playerid][7], 1);
PlayerTextDrawSetProportional(playerid, tel_pass_PTD[playerid][7], 1);
PlayerTextDrawSetShadow(playerid, tel_pass_PTD[playerid][7], 0);

    #if defined telp_OnPlayerConnect
        return telp_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect telp_OnPlayerConnect
#if defined telp_OnPlayerConnect
    forward telp_OnPlayerConnect(playerid);
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == tel_TD[2]) // звонки
    {
        callcmd::call(playerid);
    }
    if(clickedid == tel_TD[3]) // смс
    {
        // тут сделай диалоговое окно где мы будеи просить ввести игрока номер куда он хочет написать и смс
    }
    if(clickedid == tel_TD[4]) // настройки
    {
        // тут вообще хз что надо
    }
    if(clickedid == tel_TD[5]) // каршеринг
    {
        callcmd::carshare(playerid); // система каршеринга от велси
    }
    if(clickedid == tel_TD[6]) // семья
    {
        callcmd::family(playerid);
    }
    if(clickedid == tel_TD[7]) // gps
    {
        callcmd::gps(playerid);
    }
    if(clickedid == tel_TD[8]) // госуслуги
    {
        new pass_id[50];
        new pass_lvl[50];
        for(new a;a < 10;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");

        TextDrawShowForPlayer(playerid, tel_pass_TD[0]);
        TextDrawShowForPlayer(playerid, tel_pass_TD[1]);

        PlayerTextDrawSetString(playerid, tel_pass_PTD[playerid][0], GetPlayerNameEx(playerid));
        PlayerTextDrawSetString(playerid, tel_pass_PTD[playerid][1], GetPlayerSexName(playerid));
        PlayerTextDrawSetString(playerid, tel_pass_PTD[playerid][2], GetPlayerTeamName(playerid));

        format(pass_lvl, sizeof pass_lvl, "%d", GetPlayerLevel(playerid));
        PlayerTextDrawSetString(playerid, tel_pass_PTD[playerid][4], pass_lvl);
        PlayerTextDrawSetString(playerid, tel_pass_PTD[playerid][5], GetPlayerHouseName(playerid));
        PlayerTextDrawSetString(playerid, tel_pass_PTD[playerid][6], GetPlayerJobAndRankName(playerid));

        format(pass_id, sizeof pass_id, "03_0000%d", GetPlayerAccountID(playerid));
        PlayerTextDrawSetString(playerid, tel_pass_PTD[playerid][7], pass_id);

        for(new i = 0; i < sizeof tel_pass_PTD - 1; i++) PlayerTextDrawShow(playerid, tel_pass_PTD[playerid][i]);
    }
    if(clickedid == tel_TD[9]) // подарки
    {
        callcmd::roulette(playerid); // сделал команды /roulette которая в системе рулеток велси собирает все призы
    }
    if(clickedid == tel_TD[10]) // выход
    {
        for(new i = 0; i < sizeof tel_TD - 1; i++) TextDrawHideForPlayer(playerid, tel_TD[i]);
        CancelSelectTextDraw(playerid);
    }
    if(clickedid == tel_TD[11]) // статистика игрока
    {
        ShowPlayerStats(playerid);
    }
    if(clickedid == tel_TD[12]) // статистика игрока
    {
        SendClientMessage(playerid, -1, ""SCT"Инвентарь находится в разработке");
    }
    if(clickedid == tel_TD[13]) // помощь
    {
        callcmd::help(playerid);
    }
    if(clickedid == tel_pass_TD[1]) // закрыть паспорт
    {
        TextDrawHideForPlayer(playerid, tel_pass_TD[0]);
        TextDrawHideForPlayer(playerid, tel_pass_TD[1]);
        for(new i = 0; i < sizeof tel_pass_PTD - 1; i++) PlayerTextDrawHide(playerid, tel_pass_PTD[playerid][i]);
    }
    #if defined telp_OnPlayerClickTextDraw
        return telp_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw telp_OnPlayerClickTextDraw
#if defined telp_OnPlayerClickTextDraw
    forward telp_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

CMD:tel(playerid)
{
	if(GetPlayerData(playerid, P_PHONE) <= 0) return SendClientMessage(playerid, -1, ""USCT"У вас нету телефона");

    for(new a;a < 10;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");

    new hour, minute, second;
    new time_td[10];
    new strMinute[5];
    gettime(hour, minute, second);

    if(minute < 10)
    {
        format(strMinute, sizeof strMinute, "0%d", minute);
    }
    else format(strMinute, sizeof strMinute, "%d", minute);

    format(time_td, sizeof time_td, "%d:%s", hour, strMinute);
    TextDrawSetString(tel_TD[1], time_td);

    SetPlayerChatBubble(playerid, "достал(а) телефон", 0xDD90FFFF, 25.0, 7000);
    for(new i = 0; i < sizeof tel_TD - 1; i++) TextDrawShowForPlayer(playerid, tel_TD[i]);

	SelectTextDraw(playerid, -1);
	return 1;
}