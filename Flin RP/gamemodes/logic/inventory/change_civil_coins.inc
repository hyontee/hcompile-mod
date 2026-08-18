#define MAX_CHANGE_CIVIL_COINS      42

enum
{
    TYPE_CHANGE_ROULETTE,
    TYPE_CHANGE_ACCESSORIES,
    TYPE_CHANGE_SKIN,
    TYPE_CHANGE_COSTUME
}

new ChangeCivilCoinsTypeName[4][12] = {"Рулетка", "Аксессуар", "Скин", "Костюм"};

enum E_CHANGE_CIVIL_COINS
{
    ChangeCivilCoinsType,
    ChangeCivilCoinsIDx,
    ChangeCivilCoinsPrice
}

new ChangeCivilCoins[MAX_CHANGE_CIVIL_COINS][E_CHANGE_CIVIL_COINS] = {
    {TYPE_CHANGE_ACCESSORIES, 589, 5000},
    {TYPE_CHANGE_ACCESSORIES, 590, 5000},
    {TYPE_CHANGE_ACCESSORIES, 591, 5000},
    {TYPE_CHANGE_ACCESSORIES, 592, 5000},
    {TYPE_CHANGE_ACCESSORIES, 442, 4000},
    {TYPE_CHANGE_ACCESSORIES, 533, 4000},
    {TYPE_CHANGE_ACCESSORIES, 532, 3000},
    {TYPE_CHANGE_ACCESSORIES, 531, 2000},
    {TYPE_CHANGE_ACCESSORIES, 536, 2000},
    {TYPE_CHANGE_ACCESSORIES, 593, 2000},
    {TYPE_CHANGE_ACCESSORIES, 594, 2000},
    {TYPE_CHANGE_ACCESSORIES, 604, 2000},
    {TYPE_CHANGE_ACCESSORIES, 621, 2000},
    {TYPE_CHANGE_ACCESSORIES, 622, 2000},
    {TYPE_CHANGE_ACCESSORIES, 487, 1000},
    {TYPE_CHANGE_ACCESSORIES, 488, 1000},
    {TYPE_CHANGE_ACCESSORIES, 560, 1000},
    {TYPE_CHANGE_ACCESSORIES, 561, 1000},
    {TYPE_CHANGE_ACCESSORIES, 562, 1000},
    {TYPE_CHANGE_ACCESSORIES, 563, 1000},
    {TYPE_CHANGE_ACCESSORIES, 564, 1000},
    {TYPE_CHANGE_ACCESSORIES, 565, 1000},
    {TYPE_CHANGE_ACCESSORIES, 566, 1000},
    {TYPE_CHANGE_ACCESSORIES, 567, 1000},
    {TYPE_CHANGE_ACCESSORIES, 568, 1000},
    {TYPE_CHANGE_ACCESSORIES, 569, 1000},
    {TYPE_CHANGE_ACCESSORIES, 570, 1000},
    {TYPE_CHANGE_ACCESSORIES, 571, 1000},
    {TYPE_CHANGE_ACCESSORIES, 572, 1000},
    {TYPE_CHANGE_ACCESSORIES, 514, 750},
    {TYPE_CHANGE_ACCESSORIES, 518, 750},
    {TYPE_CHANGE_ACCESSORIES, 494, 500},
    {TYPE_CHANGE_ACCESSORIES, 495, 500},
    {TYPE_CHANGE_ACCESSORIES, 496, 500},
    {TYPE_CHANGE_ACCESSORIES, 466, 500},
    {TYPE_CHANGE_ACCESSORIES, 467, 500},
    {TYPE_CHANGE_ACCESSORIES, 468, 500},
    {TYPE_CHANGE_ACCESSORIES, 469, 500},
    {TYPE_CHANGE_ACCESSORIES, 470, 500},
    {TYPE_CHANGE_ACCESSORIES, 471, 500},
    {TYPE_CHANGE_ACCESSORIES, 473, 500},
    {TYPE_CHANGE_ACCESSORIES, 474, 500}
};

ShowChangeCivilCoinsList(playerid)
{
    STRING_GLOBAL = "[#] Название\tКоличество гражданских монет\n", STRING_MIN[0] = EOS;
    for(new i = 0; i < MAX_CHANGE_CIVIL_COINS; i++)
    {
        format(STRING_MIN, sizeof(STRING_MIN), ""I"[%d]"W" %s\t%d\n", i + 1, GetChangeCivilCoinsName(ChangeCivilCoins[i][ChangeCivilCoinsType], ChangeCivilCoins[i][ChangeCivilCoinsIDx]), ChangeCivilCoins[i][ChangeCivilCoinsPrice]);
        strcat(STRING_GLOBAL, STRING_MIN);
    }
    ShowPlayerDialog(playerid, D_CHANGE_CIVIL_COINS_LIST, DIALOG_STYLE_TABLIST_HEADERS, ""I"Обмен гражданских монет", STRING_GLOBAL, "Далее", "Отмена");
    return 1;
}

GetChangeCivilCoinsName(type, idx)
{
    new str[256];
    switch(type)
    {
        case TYPE_CHANGE_ACCESSORIES, TYPE_CHANGE_ROULETTE:
        {
            format(str, sizeof(str), "%s: %s", ChangeCivilCoinsTypeName[type], ItemsInfo[idx][iName]);
        }
        case TYPE_CHANGE_SKIN:
        {
            format(str, sizeof(str), "%s: %d", ChangeCivilCoinsTypeName[type], idx);
        }
        case TYPE_CHANGE_COSTUME:
        {
            format(str, sizeof(str), "%s: %s", ChangeCivilCoinsTypeName[type], CostumeName[idx]);
        }
    }
    return str;
}

new pickup_change_civil_coins;

ShowChangeCivilCoins(playerid)
{
    ShowPlayerDialog(playerid, D_CHANGE_CIVIL_COINS, DIALOG_STYLE_MSGBOX, ""I"Обмен гражданских монет", ""W"\
    В данном месте ты можешь обменять гражданские монеты на различные игровые предметы, а именно: "I" уникальные\n\
    аксессуары и уникальные скины."W"\n\n\
    Гражданские монеты выдаются каждый час, а также их можно приобрести на центральном рынке или в нашем магазине.\n\n\
    При нажатии "I"\"Далее\""W" откроется диалог с обменом гражданских монет на вышеперечисленные предметы. ", "Далее", "Отмена");
    return 1;
}

LoadChangeCivilCoins()
{
    // Обменщик гражданских монет;
    CreateActor(188, 1417.0363,-1707.5519,13.5469,270.1089);
    CreateDynamic3DTextLabel("NPC: "I"Обменщик гражданских монет", COLOR_WHITE, 1417.0363,-1707.5519,13.5469 + 1.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, streamer_TESTLOL);

    pickup_change_civil_coins = CreatePickup(1239, 23, 1418.7518,-1707.5118,13.5469);
    CreateDynamic3DTextLabel("<< Обмен гражданских монет >>", COLOR_MAIN, 1418.7518,-1707.5118,13.5469, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, streamer_TESTLOL);

    CreateDynamicObject(1570, 1417.58142, -1707.07385, 13.78690, 0.00000, 0.00000, 90.00000);
    return 1;
}
