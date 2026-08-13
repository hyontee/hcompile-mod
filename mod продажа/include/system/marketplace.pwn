#define MAX_MARKET_PRODUCTS 100 // максимальное количество товаров на сервере

#define ITEMS_PER_PAGE 4 // количество товаров на 1 странице


#define MARKET_TAB_HOME 0
#define MARKET_TAB_LIKED 1
#define MARKET_TAB_MY 2

#define MARKET_TYPE_ACS 1
#define MARKET_TYPE_SKIN 2

// ID диалогов
#define D_MARKET_TYPE            55100
#define D_MARKET_ACS_PICK        55101
#define D_MARKET_SKIN_PICK       55102
#define D_MARKET_PRICE_INPUT     55103
#define D_MARKET_CONFIRM_DUP     55104
#define D_MARKET_EDIT            55105
#define D_MARKET_PRICE_EDIT      55106
#define D_MARKET_CONFIRM_DELETE  55107

// Индексы TextDraw
#define MARKET_MAIN_MENU     0 // фон меню
#define MARKET_BANNER_1      1 // баннер с товаром 1
#define MARKET_BANNER_2      2 // баннер с товаром 2
#define MARKET_BANNER_3      3 // баннер с товаром 3
#define MARKET_BANNER_4      4 // баннер с товаром 4
#define MARKET_RIGHT         5 // перейти на следующую страницу
#define MARKET_LEFT          6 // перейти на предыдущую страницу
#define MARKET_EXIT          7 // выйти из маркетплейса
#define MARKET_SELL          8 // выставить новый товар на продажу
#define MARKET_INFO          9 // информация о маркетплейсе

// Индексы PlayerTextDraw
#define MARKET_NAME_1        0 // имя товара в слоте 1
#define MARKET_NAME_2        1 // имя товара в слоте 2
#define MARKET_NAME_3        2 // имя товара в слоте 3
#define MARKET_NAME_4        3 // имя товара в слоте 4
#define MARKET_BUY_1         4 // кнопка купить/изменить для слота 1
#define MARKET_BUY_2         5 // кнопка купить/изменить для слота 2
#define MARKET_BUY_3         6 // кнопка купить/изменить для слота 3
#define MARKET_BUY_4         7 // кнопка купить/изменить для слота 4
#define MARKET_LIKE_1        8 // кнопка лайкнуть/снять лайк для слота 1
#define MARKET_LIKE_2        9 // кнопка лайкнуть/снять лайк для слота 2
#define MARKET_LIKE_3       10 // кнопка лайкнуть/снять лайк для слота 3
#define MARKET_LIKE_4       11 // кнопка лайкнуть/снять лайк для слота 4
#define MARKET_PRICE_1      12 // цена товара в слоте 1
#define MARKET_PRICE_2      13 // цена товара в слоте 2
#define MARKET_PRICE_3      14 // цена товара в слоте 3
#define MARKET_PRICE_4      15 // цена товара в слоте 4
#define MARKET_AMOUNT_1     16 // количество товара слот 1
#define MARKET_AMOUNT_2     17 // количество товара слот 2
#define MARKET_AMOUNT_3     18 // количество товара слот 3
#define MARKET_AMOUNT_4     19 // количество товара слот 4
#define MARKET_TIME_LEFT_1  20 // время до снятия с продажи слот 1
#define MARKET_TIME_LEFT_2  21 // время до снятия с продажи слот 2
#define MARKET_TIME_LEFT_3  22 // время до снятия с продажи слот 3
#define MARKET_TIME_LEFT_4  23 // время до снятия с продажи слот 4
#define MARKET_ITEM_MODEL_1 24 // текстдрав показывающий модель скина, аксессуара слот 1
#define MARKET_ITEM_MODEL_2 25 // текстдрав показывающий модель скина, аксессуара слот 2
#define MARKET_ITEM_MODEL_3 26 // текстдрав показывающий модель скина, аксессуара слот 3
#define MARKET_ITEM_MODEL_4 27 // текстдрав показывающий модель скина, аксессуара слот 4
#define MARKET_PLAYER_MONEY 28 // текстдрав с балансом игрока
#define MARKET_PLAYER_PAGE  29 // текстдрав показывающий на какой странице маркетплейса находится игрок
#define MARKET_HOME         30 // кнопка которая при нажатии переключает игрока на страницу со всеми товарами, если она нажата, то мы делаем SetString "market:market_home", если игрок переключил на другой режим, то SetString "market:transperent"
#define MARKET_LIKED        31 // аналогично кнопке выше, также делаем SetString "market:market_liked" когда кнопка нажата и делаем SetString "market:market_home", если игрок переключил на другой режим, показывает игроку товары которые он лайкнул
#define MARKET_SALE         32 // аналогично кнопке market_liked и кнопке домой, показывает игроку товары которын он продает

// Глобальные TextDraw и PlayerTextDraw
new Text:market_TD[10];
new PlayerText:market_PTD[MAX_PLAYERS][33];

#define GetProductData(%0,%1)			g_market_product[%0][%1]
#define SetProductData(%0,%1,%2)		g_market_product[%0][%1] = %2

#define GetPlayerProductData(%0,%1,%2)			g_market_player_product[%0][%1][%2]
#define SetPlayerProductData(%0,%1,%2,%3)		g_market_player_product[%0][%1][%2] = %3

enum E_MARKET_PRODUCT_STRUCT
{
	PR_MARKET_SQL_ID,			// ид в базе данных
	PR_MARKET_OWNER_ID,			// ид аккаунта владельца
	PR_MARKET_TYPE,             // тип товара
	PR_MARKET_MODEL,            // айди модели товара
	PR_MARKET_PRICE,            // цена товара
	PR_MARKET_QUANTILY,	        // количество товара
	PR_MARKET_EXPIRE_TIME,      // время до окончания продажи в часах
    PR_MARKET_PAGE,             // на какой странице находится
    PR_MARKET_SLOT              // какой слот занимает на странице от 1 до 4
}
new g_market_product[MAX_MARKET_PRODUCTS][E_MARKET_PRODUCT_STRUCT];
new g_market_product_loaded;

enum E_MARKET_PLAYER_PRODUCT_STRUCT
{
	PLAYER_PR_MARKET_SQL_ID,			// ид в базе данных
	PLAYER_PR_MARKET_OWNER_ID,			// ид аккаунта владельца
	PLAYER_PR_MARKET_TYPE,              // тип товара
	PLAYER_PR_MARKET_MODEL,             // айди модели товара
	PLAYER_PR_MARKET_PRICE,             // цена товара
	PLAYER_PR_MARKET_QUANTILY,	        // количество товара
	PLAYER_PR_MARKET_EXPIRE_TIME,       // время до окончания продажи в часах
    PLAYER_PR_MARKET_PAGE,              // на какой странице находится
    PLAYER_PR_MARKET_SLOT               // какой слот занимает на странице от 1 до 4
}
new g_market_player_product[MAX_PLAYERS][MAX_MARKET_PRODUCTS][E_MARKET_PLAYER_PRODUCT_STRUCT];
new g_market_player_product_loaded[MAX_PLAYERS];

// Утилита: форматирование денег
stock ConvertMoneyMarket(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9')
        {
            strins(string, "_", i, length);
        }
        else
        {
            return;
        }
    }
    if(money < 0)
    {
        strins(string, "-", 0, length);
    }
}

stock ConvertMoneyMarket2(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9')
        {
            strins(string, ".", i, length);
        }
        else
        {
            return;
        }
    }
    if(money < 0)
    {
        strins(string, "-", 0, length);
    }
}

stock Market_CreateTD_Global()
{
    market_TD[MARKET_MAIN_MENU] = TextDrawCreate(-0.1999, -0.7166, "market:market_main");
    TextDrawTextSize(market_TD[MARKET_MAIN_MENU], 641.0000, 447.0000);
    TextDrawAlignment(market_TD[MARKET_MAIN_MENU], 1);
    TextDrawColor(market_TD[MARKET_MAIN_MENU], -1);
    TextDrawBackgroundColor(market_TD[MARKET_MAIN_MENU], 255);
    TextDrawFont(market_TD[MARKET_MAIN_MENU], 4);
    TextDrawSetProportional(market_TD[MARKET_MAIN_MENU], 0);
    TextDrawSetShadow(market_TD[MARKET_MAIN_MENU], 0);

    market_TD[MARKET_BANNER_1] = TextDrawCreate(76.1998, 108.7064, "market:market_banner");
    TextDrawTextSize(market_TD[MARKET_BANNER_1], 234.0000, 155.0000);
    TextDrawAlignment(market_TD[MARKET_BANNER_1], 1);
    TextDrawColor(market_TD[MARKET_BANNER_1], -1);
    TextDrawBackgroundColor(market_TD[MARKET_BANNER_1], 255);
    TextDrawFont(market_TD[MARKET_BANNER_1], 4);
    TextDrawSetProportional(market_TD[MARKET_BANNER_1], 0);
    TextDrawSetShadow(market_TD[MARKET_BANNER_1], 0);

    market_TD[MARKET_BANNER_2] = TextDrawCreate(324.6000, 108.2088, "market:market_banner");
    TextDrawTextSize(market_TD[MARKET_BANNER_2], 234.0000, 157.0000);
    TextDrawAlignment(market_TD[MARKET_BANNER_2], 1);
    TextDrawColor(market_TD[MARKET_BANNER_2], -1);
    TextDrawBackgroundColor(market_TD[MARKET_BANNER_2], 255);
    TextDrawFont(market_TD[MARKET_BANNER_2], 4);
    TextDrawSetProportional(market_TD[MARKET_BANNER_2], 0);
    TextDrawSetShadow(market_TD[MARKET_BANNER_2], 0);

    market_TD[MARKET_BANNER_3] = TextDrawCreate(76.1998, 285.9154, "market:market_banner");
    TextDrawTextSize(market_TD[MARKET_BANNER_3], 234.0000, 155.0000);
    TextDrawAlignment(market_TD[MARKET_BANNER_3], 1);
    TextDrawColor(market_TD[MARKET_BANNER_3], -1);
    TextDrawBackgroundColor(market_TD[MARKET_BANNER_3], 255);
    TextDrawFont(market_TD[MARKET_BANNER_3], 4);
    TextDrawSetProportional(market_TD[MARKET_BANNER_3], 0);
    TextDrawSetShadow(market_TD[MARKET_BANNER_3], 0);

    market_TD[MARKET_BANNER_4] = TextDrawCreate(324.6000, 285.9154, "market:market_banner");
    TextDrawTextSize(market_TD[MARKET_BANNER_4], 234.0000, 155.0000);
    TextDrawAlignment(market_TD[MARKET_BANNER_4], 1);
    TextDrawColor(market_TD[MARKET_BANNER_4], -1);
    TextDrawBackgroundColor(market_TD[MARKET_BANNER_4], 255);
    TextDrawFont(market_TD[MARKET_BANNER_4], 4);
    TextDrawSetProportional(market_TD[MARKET_BANNER_4], 0);
    TextDrawSetShadow(market_TD[MARKET_BANNER_4], 0);

    market_TD[MARKET_RIGHT] = TextDrawCreate(562.2001, 67.8888, "market:market_right");
    TextDrawTextSize(market_TD[MARKET_RIGHT], 22.0000, 29.0000);
    TextDrawAlignment(market_TD[MARKET_RIGHT], 1);
    TextDrawColor(market_TD[MARKET_RIGHT], -1);
    TextDrawBackgroundColor(market_TD[MARKET_RIGHT], 255);
    TextDrawFont(market_TD[MARKET_RIGHT], 4);
    TextDrawSetProportional(market_TD[MARKET_RIGHT], 0);
    TextDrawSetShadow(market_TD[MARKET_RIGHT], 0);
    TextDrawSetSelectable(market_TD[MARKET_RIGHT], true);

    market_TD[MARKET_LEFT] = TextDrawCreate(512.5998, 68.3866, "market:market_left");
    TextDrawTextSize(market_TD[MARKET_LEFT], 22.0000, 29.0000);
    TextDrawAlignment(market_TD[MARKET_LEFT], 1);
    TextDrawColor(market_TD[MARKET_LEFT], -1);
    TextDrawBackgroundColor(market_TD[MARKET_LEFT], 255);
    TextDrawFont(market_TD[MARKET_LEFT], 4);
    TextDrawSetProportional(market_TD[MARKET_LEFT], 0);
    TextDrawSetShadow(market_TD[MARKET_LEFT], 0);
    TextDrawSetSelectable(market_TD[MARKET_LEFT], true);

    market_TD[MARKET_EXIT] = TextDrawCreate(588.6001, 5.6666, "market:transparent"); // выход
    TextDrawTextSize(market_TD[MARKET_EXIT], 22.0000, 33.0000);
    TextDrawAlignment(market_TD[MARKET_EXIT], 1);
    TextDrawColor(market_TD[MARKET_EXIT], -1);
    TextDrawBackgroundColor(market_TD[MARKET_EXIT], 255);
    TextDrawFont(market_TD[MARKET_EXIT], 4);
    TextDrawSetProportional(market_TD[MARKET_EXIT], 0);
    TextDrawSetShadow(market_TD[MARKET_EXIT], 0);
    TextDrawSetSelectable(market_TD[MARKET_EXIT], true);

    market_TD[MARKET_SELL] = TextDrawCreate(26.6000, 401.8977, "market:transparent"); // продать новый товар
    TextDrawTextSize(market_TD[MARKET_SELL], 25.0000, 37.0000);
    TextDrawAlignment(market_TD[MARKET_SELL], 1);
    TextDrawColor(market_TD[MARKET_SELL], -1);
    TextDrawBackgroundColor(market_TD[MARKET_SELL], 255);
    TextDrawFont(market_TD[MARKET_SELL], 4);
    TextDrawSetProportional(market_TD[MARKET_SELL], 0);
    TextDrawSetShadow(market_TD[MARKET_SELL], 0);
    TextDrawSetSelectable(market_TD[MARKET_SELL], true);

    market_TD[MARKET_INFO] = TextDrawCreate(589.7997, 66.3955, "market:transparent"); // пока просто есть
    TextDrawTextSize(market_TD[MARKET_INFO], 23.0000, 33.0000);
    TextDrawAlignment(market_TD[MARKET_INFO], 1);
    TextDrawColor(market_TD[MARKET_INFO], -1);
    TextDrawBackgroundColor(market_TD[MARKET_INFO], 255);
    TextDrawFont(market_TD[MARKET_INFO], 4);
    TextDrawSetProportional(market_TD[MARKET_INFO], 0);
    TextDrawSetShadow(market_TD[MARKET_INFO], 0);
    TextDrawSetSelectable(market_TD[MARKET_INFO], true);
}

stock Market_CreateTD_Player(playerid)
{
market_PTD[playerid][MARKET_NAME_1] = CreatePlayerTextDraw(playerid, 160.3999, 148.1867, "Towar_name_1"); // имя товара в слоте 1
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_NAME_1], 0.2955, 1.6347);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_NAME_1], -10.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_NAME_1], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_NAME_1], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_NAME_1], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_NAME_1], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_NAME_1], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_NAME_1], 0);

market_PTD[playerid][MARKET_NAME_2] = CreatePlayerTextDraw(playerid, 408.8001, 148.1867, "Towar_name_2"); // имя товара в слоте 2
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_NAME_2], 0.2955, 1.6347);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_NAME_2], -10.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_NAME_2], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_NAME_2], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_NAME_2], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_NAME_2], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_NAME_2], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_NAME_2], 0);

market_PTD[playerid][MARKET_NAME_3] = CreatePlayerTextDraw(playerid, 160.4001, 325.3956, "Towar_name_3"); // имя товара в слоте 3
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_NAME_3], 0.2955, 1.6347);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_NAME_3], -10.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_NAME_3], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_NAME_3], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_NAME_3], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_NAME_3], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_NAME_3], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_NAME_3], 0);

market_PTD[playerid][MARKET_NAME_4] = CreatePlayerTextDraw(playerid, 409.2000, 325.3956, "Towar_name_4"); // имя товара в слоте 4
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_NAME_4], 0.2955, 1.6347);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_NAME_4], -10.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_NAME_4], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_NAME_4], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_NAME_4], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_NAME_4], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_NAME_4], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_NAME_4], 0);

    market_PTD[playerid][MARKET_BUY_1] = CreatePlayerTextDraw(playerid, 160.6000, 218.7153, "market:market_buy"); // кнопка купить/изменить для слота 1
    PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_BUY_1], 114.0000, 32.0000);
    PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_BUY_1], 1);
    PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_BUY_1], -1);
    PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_BUY_1], 255);
    PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_BUY_1], 4);
    PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_BUY_1], 0);
    PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_BUY_1], 0);
    PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_BUY_1], true);

    market_PTD[playerid][MARKET_BUY_2] = CreatePlayerTextDraw(playerid, 409.7998, 219.7111, "market:market_buy"); // кнопка купить/изменить для слота 2
    PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_BUY_2], 114.0000, 32.0000);
    PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_BUY_2], 1);
    PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_BUY_2], -1);
    PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_BUY_2], 255);
    PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_BUY_2], 4);
    PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_BUY_2], 0);
    PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_BUY_2], 0);
    PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_BUY_2], true);

    market_PTD[playerid][MARKET_BUY_3] = CreatePlayerTextDraw(playerid, 161.0000, 395.9244, "market:market_buy"); // кнопка купить/изменить для слота 3
    PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_BUY_3], 114.0000, 32.0000);
    PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_BUY_3], 1);
    PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_BUY_3], -1);
    PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_BUY_3], 255);
    PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_BUY_3], 4);
    PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_BUY_3], 0);
    PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_BUY_3], 0);
    PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_BUY_3], true);

    market_PTD[playerid][MARKET_BUY_4] = CreatePlayerTextDraw(playerid, 409.3999, 395.9244, "market:market_buy"); // кнопка купить/изменить для слота 4
    PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_BUY_4], 114.0000, 32.0000);
    PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_BUY_4], 1);
    PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_BUY_4], -1);
    PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_BUY_4], 255);
    PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_BUY_4], 4);
    PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_BUY_4], 0);
    PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_BUY_4], 0);
    PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_BUY_4], true);

    market_PTD[playerid][MARKET_LIKE_1] = CreatePlayerTextDraw(playerid, 281.3999, 218.7156, "market:market_like_off"); // кнопка лайкнуть/снять лайк для слота 1
    PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_LIKE_1], 18.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_LIKE_1], 1);
    PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_LIKE_1], -1);
    PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_LIKE_1], 255);
    PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_LIKE_1], 4);
    PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_LIKE_1], 0);
    PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_LIKE_1], 0);
    PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_LIKE_1], true);

    market_PTD[playerid][MARKET_LIKE_2] = CreatePlayerTextDraw(playerid, 530.1998, 219.2133, "market:market_like_off"); // кнопка лайкнуть/снять лайк для слота 2
    PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_LIKE_2], 18.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_LIKE_2], 1);
    PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_LIKE_2], -1);
    PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_LIKE_2], 255);
    PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_LIKE_2], 4);
    PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_LIKE_2], 0);
    PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_LIKE_2], 0);
    PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_LIKE_2], true);

    market_PTD[playerid][MARKET_LIKE_3] = CreatePlayerTextDraw(playerid, 280.5997, 396.4223, "market:market_like_off"); // кнопка лайкнуть/снять лайк для слота 3
    PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_LIKE_3], 18.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_LIKE_3], 1);
    PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_LIKE_3], -1);
    PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_LIKE_3], 255);
    PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_LIKE_3], 4);
    PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_LIKE_3], 0);
    PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_LIKE_3], 0);
    PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_LIKE_3], true);

    market_PTD[playerid][MARKET_LIKE_4] = CreatePlayerTextDraw(playerid, 529.7998, 396.4223, "market:market_like_off"); // кнопка лайкнуть/снять лайк для слота 4
    TextDrawTextSize(playerid, market_PTD[playerid][MARKET_LIKE_4], 18.0000, 28.0000);
    TextDrawAlignment(playerid, market_PTD[playerid][MARKET_LIKE_4], 1);
    TextDrawColor(playerid, market_PTD[playerid][MARKET_LIKE_4], -1);
    TextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_LIKE_4], 255);
    TextDrawFont(playerid, market_PTD[playerid][MARKET_LIKE_4], 4);
    TextDrawSetProportional(playerid, market_PTD[playerid][MARKET_LIKE_4], 0);
    TextDrawSetShadow(playerid, market_PTD[playerid][MARKET_LIKE_4], 0);
    TextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_LIKE_4], true);

market_PTD[playerid][MARKET_PRICE_1] = CreatePlayerTextDraw(playerid, 160.8000, 181.0404, "2_000_000_?"); // цена товара в слоте 1
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_PRICE_1], 0.3483, 2.1723);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_PRICE_1], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_PRICE_1], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_PRICE_1], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_PRICE_1], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_PRICE_1], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_PRICE_1], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_PRICE_1], 0);

market_PTD[playerid][MARKET_PRICE_2] = CreatePlayerTextDraw(playerid, 409.1998, 181.5381, "2_000_000_?"); // цена товара в слоте 2
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_PRICE_2], 0.3483, 2.1723);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_PRICE_2], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_PRICE_2], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_PRICE_2], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_PRICE_2], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_PRICE_2], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_PRICE_2], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_PRICE_2], 0);

market_PTD[playerid][MARKET_PRICE_3] = CreatePlayerTextDraw(playerid, 160.3999, 358.2492, "2_000_000_?"); // цена товара в слоте 3
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_PRICE_3], 0.3483, 2.1723);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_PRICE_3], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_PRICE_3], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_PRICE_3], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_PRICE_3], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_PRICE_3], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_PRICE_3], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_PRICE_3], 0);

market_PTD[playerid][MARKET_PRICE_4] = CreatePlayerTextDraw(playerid, 408.7999, 358.2492, "2_000_000_?"); // цена товара в слоте 4
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_PRICE_4], 0.3483, 2.1723);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_PRICE_4], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_PRICE_4], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_PRICE_4], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_PRICE_4], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_PRICE_4], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_PRICE_4], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_PRICE_4], 0);

market_PTD[playerid][MARKET_AMOUNT_1] = CreatePlayerTextDraw(playerid, 303.6000, 112.8447, "1_шт."); // количество товара слот 1
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_AMOUNT_1], 0.2520, 1.7790);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_AMOUNT_1], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_AMOUNT_1], 3);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_AMOUNT_1], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_AMOUNT_1], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_AMOUNT_1], 2);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_AMOUNT_1], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_AMOUNT_1], 1);

market_PTD[playerid][MARKET_AMOUNT_2] = CreatePlayerTextDraw(playerid, 552.0006, 112.3470, "2_шт."); // количество товара слот 2
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_AMOUNT_2], 0.2520, 1.7790);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_AMOUNT_2], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_AMOUNT_2], 3);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_AMOUNT_2], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_AMOUNT_2], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_AMOUNT_2], 2);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_AMOUNT_2], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_AMOUNT_2], 1);

market_PTD[playerid][MARKET_AMOUNT_3] = CreatePlayerTextDraw(playerid, 303.6005, 290.0537, "3_шт."); // количество товара слот 3
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_AMOUNT_3], 0.2520, 1.7790);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_AMOUNT_3], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_AMOUNT_3], 3);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_AMOUNT_3], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_AMOUNT_3], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_AMOUNT_3], 2);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_AMOUNT_3], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_AMOUNT_3], 1);

market_PTD[playerid][MARKET_AMOUNT_4] = CreatePlayerTextDraw(playerid, 552.0004, 290.0537, "4_шт."); // количество товара слот 4
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_AMOUNT_4], 0.2520, 1.7790);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_AMOUNT_4], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_AMOUNT_4], 3);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_AMOUNT_4], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_AMOUNT_4], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_AMOUNT_4], 2);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_AMOUNT_4], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_AMOUNT_4], 1);

market_PTD[playerid][MARKET_TIME_LEFT_1] = CreatePlayerTextDraw(playerid, 335.6005, 231.8137, "2_д"); // время до снятия с продажи слот 1
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], 0.2863, 1.6049);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1], 0);

market_PTD[playerid][MARKET_TIME_LEFT_2] = CreatePlayerTextDraw(playerid, 86.8005, 230.3204, "1_д"); // время до снятия с продажи слот 2
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], 0.2863, 1.6049);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_TIME_LEFT_2], 0);

market_PTD[playerid][MARKET_TIME_LEFT_3] = CreatePlayerTextDraw(playerid, 87.2005, 407.5292, "3_д"); // время до снятия с продажи слот 3
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], 0.2863, 1.6049);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_TIME_LEFT_3], 0);

market_PTD[playerid][MARKET_TIME_LEFT_4] = CreatePlayerTextDraw(playerid, 336.0007, 407.5293, "4_д"); // время до снятия с продажи слот 4 
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], 0.2863, 1.6049);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], -5.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_TIME_LEFT_4], 0);

// то что ниже - это текстдравы которые создают 3д модель

market_PTD[playerid][MARKET_ITEM_MODEL_1] = CreatePlayerTextDraw(playerid, 84.5999, 150.0222, ""); // текстдрав показывающий модель скина, аксессуара слот 1
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 68.0000, 100.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 0);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 5);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 0);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 0);
PlayerTextDrawSetPreviewModel(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 18979);
PlayerTextDrawSetPreviewRot(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1], 0.0000, 0.0000, 50.0000, 0.8000);

market_PTD[playerid][MARKET_ITEM_MODEL_2] = CreatePlayerTextDraw(playerid, 333.0000, 150.0222, ""); // текстдрав показывающий модель скина, аксессуара слот 2
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 68.0000, 100.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 0);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 5);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 0);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 0);
PlayerTextDrawSetPreviewModel(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 18979);
PlayerTextDrawSetPreviewRot(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_2], 0.0000, 0.0000, 50.0000, 0.8000);

market_PTD[playerid][MARKET_ITEM_MODEL_3] = CreatePlayerTextDraw(playerid, 85.0000, 327.2311, ""); // текстдрав показывающий модель скина, аксессуара слот 3
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 68.0000, 100.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 0);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 5);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 0);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 0);
PlayerTextDrawSetPreviewModel(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 18979);
PlayerTextDrawSetPreviewRot(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_3], 0.0000, 0.0000, 50.0000, 0.8000);

market_PTD[playerid][MARKET_ITEM_MODEL_4] = CreatePlayerTextDraw(playerid, 333.0000, 326.7333, ""); // текстдрав показывающий модель скина, аксессуара слот 4
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 68.0000, 100.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 0);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 5);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 0);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 0);
PlayerTextDrawSetPreviewModel(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 18979);
PlayerTextDrawSetPreviewRot(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_4], 0.0000, 0.0000, 50.0000, 0.8000);

// текстдравы модель окончены

market_PTD[playerid][MARKET_PLAYER_MONEY] = CreatePlayerTextDraw(playerid, 478.3999, 12.7910, "22.222"); // текстдрав с балансом игрока
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], 0.4023, 2.3615);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], 16.0000, 0.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], 1);

market_PTD[playerid][MARKET_PLAYER_PAGE] = CreatePlayerTextDraw(playerid, 548.3997, 72.0266, "9"); // текстдрав показывающий на какой странице маркетплейса находится игрок
PlayerTextDrawLetterSize(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 0.4228, 2.2321);
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 0.0000, 542.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 2);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 168432895);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 1);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 1);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], 0);

market_PTD[playerid][MARKET_HOME] = CreatePlayerTextDraw(playerid, 27.4000, 159.4799, "market:market_home"); // кнопка которая при нажатии переключает игрока на страницу со всеми товарами, если она нажата, то мы делаем SetString "market:market_home", если игрок переключил на другой режим, то SetString "market:transperent"
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_HOME], 24.0000, 35.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_HOME], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_HOME], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_HOME], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_HOME], 4);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_HOME], 0);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_HOME], 0);
PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_HOME], true);

market_PTD[playerid][MARKET_LIKED] = CreatePlayerTextDraw(playerid, 27.8000, 208.2621, "market:market_liked"); // аналогично кнопке выше, также делаем SetString "market:market_liked" когда кнопка нажата и делаем SetString "market:market_home", если игрок переключил на другой режим, показывает игроку товары которые он лайкнул
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_LIKED], 24.0000, 35.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_LIKED], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_LIKED], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_LIKED], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_LIKED], 4);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_LIKED], 0);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_LIKED], 0);
PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_LIKED], true);

market_PTD[playerid][MARKET_SALE] = CreatePlayerTextDraw(playerid, 27.8000, 253.5598, "market:market_sale"); // аналогично кнопке market_liked и кнопке домой, показывает игроку товары которын он продает
PlayerTextDrawTextSize(playerid, market_PTD[playerid][MARKET_SALE], 24.0000, 35.0000);
PlayerTextDrawAlignment(playerid, market_PTD[playerid][MARKET_SALE], 1);
PlayerTextDrawColor(playerid, market_PTD[playerid][MARKET_SALE], -1);
PlayerTextDrawBackgroundColor(playerid, market_PTD[playerid][MARKET_SALE], 255);
PlayerTextDrawFont(playerid, market_PTD[playerid][MARKET_SALE], 4);
PlayerTextDrawSetProportional(playerid, market_PTD[playerid][MARKET_SALE], 0);
PlayerTextDrawSetShadow(playerid, market_PTD[playerid][MARKET_SALE], 0);
PlayerTextDrawSetSelectable(playerid, market_PTD[playerid][MARKET_SALE], true);
}

public OnGameModeInit()
{
    print("[W_SYSTEM] Система маркетплейса загружена.");
    Market_CreateTD_Global();
    SetTimer("CREATE_TABLIST_MARKET", 4500, false);
    #if defined market_OnGameModeInit
        return market_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit market_OnGameModeInit
#if defined market_OnGameModeInit
    forward market_OnGameModeInit();
#endif

public: CREATE_TABLIST_MARKET()
{
    mysql_query(mysql, "SELECT * FROM market_items");

    if(mysql_errno())
    {
        mysql_query(mysql, 
            "CREATE TABLE `market_items` (\
            `id` INT NOT NULL AUTO_INCREMENT, PRIMARY KEY (`id`),\
            `owner_id` INT NOT NULL,\
            `type` INT NOT NULL,\
            `model_id` INT NOT NULL,\
            `price` INT NOT NULL,\
            `quantity` INT NOT NULL DEFAULT 1,\
            `expire_time` INT NOT NULL\
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;", false);

        if(mysql_errno()) return printf("ERROR CREATE TABLE market_items");
    }

    mysql_query(mysql, "SELECT * FROM market_likes");

    if(mysql_errno())
    {
        mysql_query(mysql, 
            "CREATE TABLE `market_likes` (\
            `id` INT NOT NULL AUTO_INCREMENT, PRIMARY KEY (`id`),\
            `player_id` INT NOT NULL,\
            `item_id` INT NOT NULL\
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;", false);

        if(mysql_errno()) return printf("ERROR CREATE TABLE market_likes");
    }
    Market_LoadItems();
    return 1;
}

public OnPlayerConnect(playerid)
{
    Market_CreateTD_Player(playerid);
    
    #if defined market_OnPlayerConnect
        return market_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect market_OnPlayerConnect
#if defined market_OnPlayerConnect
    forward market_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    DeletePVar(playerid, "Market_Page");
    DeletePVar(playerid, "Market_Page_Type");
    DeletePVar(playerid, "Market_ModelID");
    DeletePVar(playerid, "Market_ItemID");
    DeletePVar(playerid, "Market_ItemQuantity");
    DeletePVar(playerid, "Market_ItemType");

    #if defined market_OnPlayerDisconnect
        return market_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect market_OnPlayerDisconnect
#if defined market_OnPlayerDisconnect
    forward market_OnPlayerDisconnect(playerid, reason);
#endif

stock Market_Show(playerid)
{
    for(new i = 0; i < 10; i++) TextDrawShowForPlayer(playerid, market_TD[i]);
    for(new i = 0; i < 33; i++) PlayerTextDrawShow(playerid, market_PTD[playerid][i]);

    for(new a;a < 12;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");

    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_HOME], "market:market_home");
    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKED], "market:transperent");
    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_SALE], "market:transperent");

    Market_OpenPage(playerid, MARKET_TAB_HOME, 1);

    SelectTextDraw(playerid, 0xFFFFFFAA);

    HideHud(playerid);
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
    return 1;
}

stock Market_Hide(playerid)
{
    for(new i = 0; i < 10; i++) TextDrawHideForPlayer(playerid, market_TD[i]);
    for(new i = 0; i < 33; i++) PlayerTextDrawHide(playerid, market_PTD[playerid][i]);

    CancelSelectTextDraw(playerid);

    ShowHud(playerid);
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

    DeletePVar(playerid, "Market_Page");
    DeletePVar(playerid, "Market_Page_Type");
    DeletePVar(playerid, "Market_ModelID");
    DeletePVar(playerid, "Market_ItemID");
    DeletePVar(playerid, "Market_ItemQuantity");
    DeletePVar(playerid, "Market_ItemType");
    return 1;
}

stock Market_LoadItems()
{
    new Cache:result = mysql_query(mysql, "SELECT * FROM market_items", true);
    new page = 1, slot = 1;

    if(cache_num_rows() > 0)
    {
        for(new i = 0; i < cache_num_rows(); i++)
        {
            if(slot > 4) slot = 1, page++; 

            SetProductData(i, PR_MARKET_SQL_ID, 		cache_get_field_content_int(i, "id"));
		    SetProductData(i, PR_MARKET_OWNER_ID,       cache_get_field_content_int(i, "owner_id"));
            SetProductData(i, PR_MARKET_TYPE,           cache_get_field_content_int(i, "type"));
            SetProductData(i, PR_MARKET_MODEL,          cache_get_field_content_int(i, "model_id"));
            SetProductData(i, PR_MARKET_PRICE,          cache_get_field_content_int(i, "price"));
            SetProductData(i, PR_MARKET_QUANTILY,       cache_get_field_content_int(i, "quantity"));
            SetProductData(i, PR_MARKET_EXPIRE_TIME,    cache_get_field_content_int(i, "expire_time"));
                
            SetProductData(i, PR_MARKET_SLOT, slot);
            SetProductData(i, PR_MARKET_PAGE, page);

            slot++;
        }
        g_market_product_loaded = cache_num_rows();
        printf("[WERTON_MARKET] Загружено %d товаров маркетплейса", g_market_product_loaded);
    }
    
    cache_delete(result);
    return 1;
}

stock Market_LoadPlayerItems(playerid)
{
    new query[128], Cache:result;
    mysql_format(mysql, query, sizeof query, "SELECT * FROM market_items WHERE player_id = %d", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query);
    new page = 1, slot = 1;

    if(cache_num_rows() > 0)
    {
        for(new i = 0; i < cache_num_rows(); i++)
        {
            if(slot > 4) slot = 1, page++; 

            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_SQL_ID, 		   cache_get_field_content_int(i, "id"));
		    SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_OWNER_ID,       cache_get_field_content_int(i, "owner_id"));
            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_TYPE,           cache_get_field_content_int(i, "type"));
            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_MODEL,          cache_get_field_content_int(i, "model_id"));
            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_PRICE,          cache_get_field_content_int(i, "price"));
            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_QUANTILY,       cache_get_field_content_int(i, "quantity"));
            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_EXPIRE_TIME,    cache_get_field_content_int(i, "expire_time"));
                
            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_SLOT, slot);
            SetPlayerProductData(playerid, i, PLAYER_PR_MARKET_PAGE, page);

            slot++;
        }
        g_market_player_product_loaded[playerid] = cache_num_rows();
        printf("[WERTON_MARKET] Загружено %d личных товаров игрока", g_market_player_product_loaded[playerid]);
    }
    
    cache_delete(result);
    return 1;
}

stock Market_OpenPage(playerid, pagetype, pageid)
{
    for(new a;a < 12;a++) SendClientMessage(playerid, 0xFFFFFFFF, "");

    new P_Conwert_Money[15];
    ConvertMoneyMarket2(GetPlayerMoneyEx(playerid), P_Conwert_Money);

    for(new i = MARKET_NAME_1; i < MARKET_SALE; i++) PlayerTextDrawHide(playerid, market_PTD[playerid][i]);
    for(new i = MARKET_BANNER_1; i < MARKET_BANNER_4 + 1; i++) TextDrawHideForPlayer(playerid, market_TD[i]);
    
    new strpageid[3];
    format(strpageid, sizeof strpageid, "%d", pageid);
    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE], strpageid);
    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_PLAYER_PAGE]);

    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY], P_Conwert_Money);
    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_PLAYER_MONEY]);

    SetPVarInt(playerid, "Market_Page", pageid);
    SetPVarInt(playerid, "Market_Page_Type", pagetype);

    switch(pagetype)
    {
        case MARKET_TAB_HOME:
        {
            for(new i = MARKET_BUY_1; i < MARKET_BUY_4; i++) PlayerTextDrawSetString(playerid, market_PTD[playerid][i], "market:market_buy");

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_HOME], "market:market_home");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_HOME]);

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKED], "market:transperent");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_LIKED]);

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_SALE], "market:transperent");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_SALE]);

            for(new i = 0; i < g_market_product_loaded; i++)
            {
                if(GetProductData(i, PR_MARKET_PAGE) == pageid)
                {
                    new slot = GetProductData(i, PR_MARKET_SLOT) - 1, price[15];
                    ConvertMoneyMarket(GetProductData(i, PR_MARKET_PRICE), price);

                    TextDrawShowForPlayer(playerid, market_TD[MARKET_BANNER_1 + slot]);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_BUY_1 + slot]);

                    new query[128], Cache:result;
                    mysql_format(mysql, query, sizeof query, "SELECT id FROM market_likes WHERE player_id = %d AND item_id = %d", GetPlayerAccountID(playerid), GetProductData(i, PR_MARKET_SQL_ID));
                    result = mysql_query(mysql, query);

                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot], "market:market_like_off");
    
                    if(cache_num_rows() > 0) PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot], "market:market_like_on");

                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot]);
                    cache_delete(result);

                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_PRICE_1 + slot], price);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_PRICE_1 + slot]);

                    new strquantily[5];
                    format(strquantily, sizeof strquantily, "%d", GetProductData(i, PR_MARKET_QUANTILY));
                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_AMOUNT_1 + slot], strquantily);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_AMOUNT_1 + slot]);

                    new strtime[5];
                    format(strtime, sizeof strtime, "%d", GetProductData(i, PR_MARKET_EXPIRE_TIME));
                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1 + slot], strtime);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1 + slot]);

                    PlayerTextDrawSetPreviewModel(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1 + slot], GetProductData(i, PR_MARKET_MODEL));
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1 + slot]);

                    new strwerton[30];

                    switch(GetProductData(i, PR_MARKET_TYPE))
                    {
                        case MARKET_TYPE_ACS:
                        {
                            format(strwerton, sizeof strwerton, "%s_(%d)", accessory[GetProductData(i, PR_MARKET_MODEL)][NAME_ACCESSORY], GetProductData(i, PR_MARKET_MODEL));
                        }
                        case MARKET_TYPE_SKIN:
                        {
                            format(strwerton, sizeof strwerton, "Скин_(%d)", GetProductData(i, PR_MARKET_MODEL));
                        }
                    }
                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_NAME_1 + slot], strwerton);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_NAME_1 + slot]);
                }
            }
        }
        case MARKET_TAB_LIKED:
        {
            for(new i = MARKET_BUY_1; i < MARKET_BUY_4; i++) PlayerTextDrawSetString(playerid, market_PTD[playerid][i], "market:market_buy");

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_HOME], "market:transperent");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_HOME]);

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKED], "market:market_liked");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_LIKED]);

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_SALE], "market:transperent");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_SALE]);
        }
        case MARKET_TAB_MY:
        {
            Market_LoadPlayerItems(playerid);

            for(new i = MARKET_BUY_1; i < MARKET_BUY_4; i++) PlayerTextDrawSetString(playerid, market_PTD[playerid][i], "market:market_edit");

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_HOME], "market:transperent");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_HOME]);

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKED], "market:transperent");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_LIKED]);

            PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_SALE], "market:market_sale");
            PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_SALE]);

            for(new i = 0; i < g_market_player_product_loaded[playerid]; i++)
            {
                if(GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_PAGE) == pageid)
                {
                    new slot = GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_SLOT) - 1, price[15];
                    ConvertMoneyMarket(GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_PRICE), price);

                    TextDrawShowForPlayer(playerid, market_TD[MARKET_BANNER_1 + slot]);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_BUY_1 + slot]);

                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot], "market:none");
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot]);

                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_PRICE_1 + slot], price);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_PRICE_1 + slot]);

                    new strquantily[5];
                    format(strquantily, sizeof strquantily, "%d", GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_QUANTILY));
                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_AMOUNT_1 + slot], strquantily);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_AMOUNT_1 + slot]);

                    new strtime[5];
                    format(strtime, sizeof strtime, "%d", GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_EXPIRE_TIME));
                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1 + slot], strtime);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_TIME_LEFT_1 + slot]);

                    PlayerTextDrawSetPreviewModel(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1 + slot], GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_MODEL));
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_ITEM_MODEL_1 + slot]);

                    new strwerton[30];

                    switch(GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_TYPE))
                    {
                        case MARKET_TYPE_ACS:
                        {
                            format(strwerton, sizeof strwerton, "%s_(%d)", accessory[GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_MODEL)][NAME_ACCESSORY], GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_MODEL));
                        }
                        case MARKET_TYPE_SKIN:
                        {
                            format(strwerton, sizeof strwerton, "Скин_(%d)", GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_MODEL));
                        }
                    }
                    PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_NAME_1 + slot], strwerton);
                    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_NAME_1 + slot]);
                }
            }
        }
    }
    SelectTextDraw(playerid, 0xFFFFFFAA);
}

stock Market_BuyItem(playerid, page, slot)
{
    new item_id, item_sql_id, query[258];
    for(new i = 0; i < g_market_product_loaded; i++)
    {
        if(GetProductData(i, PR_MARKET_PAGE) == page && GetProductData(i, PR_MARKET_SLOT) == slot)
        {
            item_id == i;
            item_sql_id == GetProductData(i, PR_MARKET_SQL_ID);
        }
    }

    new price = GetProductData(item_id, PR_MARKET_PRICE), model_id = GetProductData(item_id, PR_MARKET_MODEL);

    if(GetPlayerMoneyEx(playerid) < price) return SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег для покупки этого товара.");

    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET money = money + %d WHERE id = %d", price, GetProductData(item_id, PR_MARKET_OWNER_ID));
    mysql_query(mysql, query, false);
    GivePlayerMoneyEx(playerid, -price, "Покупка товара в маркетплейсе", false, true);

    if(GetProductData(item_id, PR_MARKET_QUANTILY) > 1)
    {
        mysql_format(mysql, query, sizeof query, "UPDATE market_items SET quantity = quantity - 1 WHERE id = %d", GetPVarInt(playerid, "Market_ItemID"));
        mysql_query(mysql, query, false);
    }
    else
    {
        mysql_format(mysql, query, sizeof query, "DELETE FROM market_items WHERE id = %d", item_sql_id);
        mysql_query(mysql, query, false);
    }

    Market_Hide(playerid); // для загрузки обновления товаров
    Market_LoadItems(); // обновление товаров

    switch(GetProductData(item_id, PR_MARKET_TYPE))
    {
        case MARKET_TYPE_ACS:
        {
            GiveAccessory(playerid, model_id);
        }
        case MARKET_TYPE_SKIN:
        {
            GivePlayerOwnableSkin(playerid, model_id);
        }
    }

    return 1;
}

stock Market_EditItem(playerid, page, slot)
{
    for(new i = 0; i < g_market_player_product_loaded[playerid]; i++)
    {
        if(GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_PAGE) == page && GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_SLOT) == slot)
        {
            SetPVarInt(playerid, "Market_Edit_Item_Id", i);
            SetPVarInt(playerid, "Market_Edit_Item_SqlId", GetPlayerProductData(playerid, i, PLAYER_PR_MARKET_SQL_ID));
            Market_ShowEditItemDialog(playerid);
        }
    }
    return 1;
}

stock Market_LikeItem(playerid, page, slot)
{
    new item_id, item_sql_id, query[258];
    for(new i = 0; i < g_market_product_loaded; i++)
    {
        if(GetProductData(i, PR_MARKET_PAGE) == page && GetProductData(i, PR_MARKET_SLOT) == slot)
        {
            item_id == i;
            item_sql_id == GetProductData(i, PR_MARKET_SQL_ID);
        }
    }

    mysql_format(mysql, query, sizeof query, "SELECT id FROM market_likes WHERE player_id = %d AND item_id = %d", GetPlayerAccountID(playerid), item_sql_id);
    new Cache:result = mysql_query(mysql, query);
    
    if(cache_num_rows() > 0)
    {
        // Удаляем лайк
        mysql_format(mysql, query, sizeof query, "DELETE FROM market_likes WHERE player_id = %d AND item_id = %d", GetPlayerAccountID(playerid), item_sql_id);
        mysql_query(mysql, query, false);
        
        PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot - 1], "market:market_like_inactive");
    }
    else
    {
        // Добавляем лайк
        mysql_format(mysql, query, sizeof query, "INSERT INTO market_likes (player_id, item_id) VALUES (%d, %d)", GetPlayerAccountID(playerid), item_sql_id);
        mysql_query(mysql, query, false);
        
        PlayerTextDrawSetString(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot - 1], "market:market_like_active");
    }
    
    PlayerTextDrawShow(playerid, market_PTD[playerid][MARKET_LIKE_1 + slot]);
    cache_delete(result);
    return 1;
}

stock Market_ShowSellTypeDialog(playerid)
{
    new string[256];
    format(string, sizeof string, "Скин - продажа одежды из вашего инвентаря скинов\n\
        Аксессуар - продажа аксессуаров из вашего инвентаря аксессуаров");
    
    ShowPlayerDialog(playerid, D_MARKET_TYPE, DIALOG_STYLE_LIST, "Выберите тип товара для продажи:", string, "Выбрать", "Отмена");
    return 1;
}

stock Market_ShowEditItemDialog(playerid)
{
    new string[256];
    format(string, sizeof string, "Изменить цену\n\
        {636363}Убрать товар");
    
    ShowPlayerDialog(playerid, D_MARKET_EDIT, DIALOG_STYLE_LIST, "Редактирование товара", string, "Выбрать", "Отмена");
    return 1;
}

stock Market_ShowSellAcsDialog(playerid)
{
    new fmt_text[640],
	Cache: result,
	id;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM accessory_inventory WHERE player_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows();

    if(!rows) SendClientMessage(playerid, 0x999999FF, "У Вас нет доступных аксессуаров");
    else
    {	
            new query[78],
                acs, use, acs_use[24];

            format(fmt_text, sizeof fmt_text, "");

            for(new i = 0; i < rows; i ++)
            {
                id = cache_get_field_content_int(i, "id");
                acs = cache_get_field_content_int(i, "acs_id");
                use = cache_get_field_content_int(i, "use");

                SetPVarInt(playerid, "Market_ModelID", acs);

                if(use > 0) continue;

                format
                (
                    query,
                    sizeof query,
                    "{FFFFFF}%d. %s\n",
                    i + 1, 
                    accessory[acs][NAME_ACCESSORY]
                );
                strcat(fmt_text, query);
                SetPlayerListitemValue(playerid, i, id);

                format(query, sizeof query, "acsuse%d", i);
                SetPVarInt(playerid, query, use);
            }

            Dialog
            (
                playerid, D_MARKET_ACS_PICK, DIALOG_STYLE_LIST,
                "{FFCD00}Выберите акссесуар для продажи",
                fmt_text,
                "Выбрать", "Закрыть"
            );
    }

    cache_delete(result);

	return 1;
}

stock Market_ShowSellSkinDialog(playerid)
{
    new fmt_text[1024], Cache:result, id;

    mysql_format(mysql, fmt_text, sizeof fmt_text,
        "SELECT id, skin_id, use_skin FROM inventory_skins WHERE owner_skin='%d'",
        GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows();
    if(!rows)
    {
        SendClientMessage(playerid, 0x999999FF, "У Вас нет личного скина");
        CheckSkinPlayer(playerid);
        cache_delete(result);
        return 0;
    }

    new query[64], skin_id, use, listIndex = 0;
    fmt_text[0] = EOS;

    for(new i = 0; i < rows; i++)
    {
        id      = cache_get_field_content_int(i, "id");
        skin_id = cache_get_field_content_int(i, "skin_id");
        use     = cache_get_field_content_int(i, "use_skin");

        // если скин используется — пропускаем
        if(use > 0) continue;

        format(query, sizeof query, "%d. Скин (%d)\n", listIndex + 1, skin_id);
        strcat(fmt_text, query);

        SetPlayerListitemValue(playerid, listIndex, id); // сохраняем id для продажи
        listIndex++;
    }

    cache_delete(result);

    if(listIndex == 0)
    {
        SendClientMessage(playerid, 0x999999FF, "У Вас нет свободных скинов для продажи");
        return 0;
    }

    Dialog(playerid, D_MARKET_SKIN_PICK, DIALOG_STYLE_LIST,
        "{FFCD00}Выбор скина для продажи",
        fmt_text, "Выбрать", "Отмена");

    return 1;
}

stock Market_CheckDuplicateItem(playerid, type, model_id)
{
    new query[256], Cache:result;
    mysql_format(mysql, query, sizeof query,
        "SELECT id, price, quantity FROM market_items WHERE owner_id = %d AND type = %d AND model_id = %d",
        GetPlayerAccountID(playerid), type, model_id);
    
    result = mysql_query(mysql, query);
    
    if(cache_num_rows() > 0)
    {
        new item_id, price;
        item_id = cache_get_field_content_int(0, "id");
        price = cache_get_field_content_int(0, "price");
        new quantity = cache_get_field_content_int(0, "quantity");

        SetPVarInt(playerid, "Market_ItemID", item_id);
        SetPVarInt(playerid, "Market_ItemQuantity", quantity);
        
        new string[128];
        format(string, sizeof string,
            "У вас уже есть активное объявление для этого товара по цене %d руб.\n\n\
            Хотите добавить еще один экземпляр к существующему объявлению?",
            price);
        
        ShowPlayerDialog(playerid, D_MARKET_CONFIRM_DUP, DIALOG_STYLE_MSGBOX,
            "Подтверждение", string, "Да", "Нет");
        
        cache_delete(result);
        return 1;
    }
    cache_delete(result);
    return 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    for(new i = 0; i < 10; i++)
    {
        if(clickedid == market_TD[i])
        {
            switch(i)
            {
                case MARKET_RIGHT: // Вправо
                {
                    Market_OpenPage(playerid, GetPVarInt(playerid, "Market_Page_Type"), GetPVarInt(playerid, "Market_Page") + 1);
                }
                case MARKET_LEFT: // Влево
                {
                    if(GetPVarInt(playerid, "Market_Page") > 1) Market_OpenPage(playerid, GetPVarInt(playerid, "Market_Page_Type"), GetPVarInt(playerid, "Market_Page") - 1);
                }
                case MARKET_EXIT: // Выход
                {
                    Market_Hide(playerid);
                }
                case MARKET_SELL: // Продать товар
                {
                    Market_ShowSellTypeDialog(playerid);
                }
            }
            return 1;
        }
    }
    
    #if defined market_OnPlayerClickTextDraw
        return market_OnPlayerClickTextDraw(playerid, Text:clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw market_OnPlayerClickTextDraw
#if defined market_OnPlayerClickTextDraw
    forward market_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == market_PTD[playerid][MARKET_HOME]) Market_OpenPage(playerid, MARKET_TAB_HOME, 1);
    if(playertextid == market_PTD[playerid][MARKET_LIKED]) ShowNewNotification(playerid, 2, 4, 1, 1, "В разработке", ""); // Market_OpenPage(playerid, MARKET_TAB_LIKED, 1);
    if(playertextid == market_PTD[playerid][MARKET_SALE]) Market_OpenPage(playerid, MARKET_TAB_MY, 1);

    for(new i = MARKET_BUY_1; i < MARKET_LIKE_4; i++)
    {
        if(playertextid == market_PTD[playerid][i])
        {
            if(GetPVarInt(playerid, "Market_Page_Type") != MARKET_TAB_MY)
            {
                switch(i)
                {
                    // Кнопки покупки
                    case MARKET_BUY_1: Market_BuyItem(playerid, GetPVarInt(playerid, "Market_Page"), 1);
                    case MARKET_BUY_2: Market_BuyItem(playerid, GetPVarInt(playerid, "Market_Page"), 2);
                    case MARKET_BUY_3: Market_BuyItem(playerid, GetPVarInt(playerid, "Market_Page"), 3);
                    case MARKET_BUY_4: Market_BuyItem(playerid, GetPVarInt(playerid, "Market_Page"), 4);

                    // Кнопки лайка
                    case MARKET_LIKE_1: Market_LikeItem(playerid, GetPVarInt(playerid, "Market_Page"), 1);
                    case MARKET_LIKE_2: Market_LikeItem(playerid, GetPVarInt(playerid, "Market_Page"), 2);
                    case MARKET_LIKE_3: Market_LikeItem(playerid, GetPVarInt(playerid, "Market_Page"), 3);
                    case MARKET_LIKE_4: Market_LikeItem(playerid, GetPVarInt(playerid, "Market_Page"), 4);
                }
            }
            else
            {
                switch(i)
                {
                    // Изменения товара
                    case MARKET_BUY_1: Market_EditItem(playerid, GetPVarInt(playerid, "Market_Page"), 1);
                    case MARKET_BUY_2: Market_EditItem(playerid, GetPVarInt(playerid, "Market_Page"), 2);
                    case MARKET_BUY_3: Market_EditItem(playerid, GetPVarInt(playerid, "Market_Page"), 3);
                    case MARKET_BUY_4: Market_EditItem(playerid, GetPVarInt(playerid, "Market_Page"), 4);
                }
            }
        }
    }
    #if defined market_OnPlayerClickPlayerTextDraw
        return market_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickPlayerTD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTD
#endif
#define OnPlayerClickPlayerTextDraw market_OnPlayerClickPlayerTextDraw
#if defined market_OnPlayerClickPlayerTextDraw
    forward market_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case D_MARKET_EDIT:
        {
            if(!response) return 1;
            
            switch(listitem)
            {
                case 0: // Изменить цену
                {
                    ShowPlayerDialog(playerid, D_MARKET_PRICE_EDIT, DIALOG_STYLE_INPUT,
                        "Цена товара", "Введите новую цену товара (от 0 до 100.000.000):",
                        "Далее", "Отмена");
                }

                case 1: // Убрать товар
                {
                    new itemid = GetPVarInt(playerid, "Market_Edit_Item_Id");
                    new item_model = GetPlayerProductData(playerid, itemid, PLAYER_PR_MARKET_MODEL);

                    switch(GetPlayerProductData(playerid, itemid, PLAYER_PR_MARKET_TYPE))
                    {
                        case MARKET_TYPE_ACS:
                        {
                            new string[328];
                            format(string, sizeof string,
                                "Вы действительно хотите убрать свое объявление: {ffff00}%s{ffffff}?.\n\n\
                                Товар будет возвращен Вам, но деньги за размещение\n\
                                товара не будут возвращены",
                                accessory[item_model][NAME_ACCESSORY]);
        
                            ShowPlayerDialog(playerid, D_MARKET_CONFIRM_DELETE, DIALOG_STYLE_MSGBOX,
                                "Подтверждение", string, "Да", "Нет");
                        }
                        case MARKET_TYPE_SKIN:
                        {
                            new skin_string[25];
                            format(skin_string, sizeof skin_string, "Скин (%d)", item_model);

                            new string[328];
                            format(string, sizeof string,
                                "Вы действительно хотите убрать свое объявление: {ffff00}%s{ffffff}?.\n\n\
                                Товар будет возвращен Вам, но деньги за размещение\n\
                                товара не будут возвращены",
                                skin_string);
        
                            ShowPlayerDialog(playerid, D_MARKET_CONFIRM_DELETE, DIALOG_STYLE_MSGBOX,
                                "Подтверждение", string, "Да", "Нет");
                        }
                    }
                }
            }
        }
        case D_MARKET_PRICE_EDIT:
        {
            if(!response) return Market_ShowEditItemDialog(playerid);

            new query[100], chat_price[120], price_convert[15];
            new item_SqlId = GetPVarInt(playerid, "Market_Edit_Item_SqlId");
            new price = strval(inputtext);
            if(price < 0 || price > 100000000)
            {
                SendClientMessage(playerid, COLOR_RED, ""USC"Неверная цена! Допустимый диапазон от 0 до 100.000.000 руб");
                ShowPlayerDialog(playerid, D_MARKET_PRICE_EDIT, DIALOG_STYLE_INPUT,
                    "Цена товара", "Введите новую цену товара (от 0 до 100.000.000 руб):",
                    "Ок", "Отмена");
                return 1;
            }

            mysql_format(mysql, query, sizeof query, "UPDATE market_items SET price = %d WHERE id = %d", price, item_SqlId);
            mysql_query(mysql, query, false);

            Market_Hide(playerid); // для загрузки обновления товаров
            Market_LoadItems(); // обновление товаров

            ConvertMoneyMarket2(price, price_convert);

            format(chat_price, sizeof chat_price, "| {ffffff}Цена товара успешно изменена на {ffff00}%s руб!", price_convert);
            SendClientMessage(playerid, 0x00FF00FF, chat_price);
        }
        case D_MARKET_CONFIRM_DELETE:
        {
            if(!response) return Market_ShowEditItemDialog(playerid);

            new query[100];
            new itemid = GetPVarInt(playerid, "Market_Edit_Item_Id");
            new item_SqlId = GetPVarInt(playerid, "Market_Edit_Item_SqlId");
            new item_model = GetPlayerProductData(playerid, itemid, PLAYER_PR_MARKET_MODEL);

            switch(GetPlayerProductData(playerid, itemid, PLAYER_PR_MARKET_TYPE))
            {
                case MARKET_TYPE_ACS:
                {
                    GiveAccessory(playerid, item_model);
                }
                case MARKET_TYPE_SKIN:
                {
                    GivePlayerOwnableSkin(playerid, item_model);
                }
            }

            mysql_format(mysql, query, sizeof query, "DELETE FROM market_items WHERE id = %d", item_SqlId);
            mysql_query(mysql, query, false);

            Market_Hide(playerid); // для загрузки обновления товаров
            Market_LoadItems(); // обновление товаров

            SendClientMessage(playerid, 0x00FF00FF, "| {ffffff}Товар успешно снят с продажи и возвращен!");
        }
        case D_MARKET_TYPE:
        {
            if(!response) return 1;
            
            switch(listitem)
            {
                case 0: // Скин
                {
                    if(!Market_ShowSellSkinDialog(playerid))
                    {
                        Market_ShowSellTypeDialog(playerid);
                    }
                }
                case 1: // Аксессуар
                {
                    if(!Market_ShowSellAcsDialog(playerid))
                    {
                        Market_ShowSellTypeDialog(playerid);
                    }
                }
            }
        }
        case D_MARKET_ACS_PICK:
        {
            if(!response)
            {
                Market_ShowSellTypeDialog(playerid);
                return 1;
            }

            new idx = GetPlayerListitemValue(playerid, listitem);

            SetPVarInt(playerid, "Market_ItemID", idx);
            SetPVarInt(playerid, "Market_ItemType", MARKET_TYPE_ACS);
            
            new model_id = strval(inputtext);
            
            if(!Market_CheckDuplicateItem(playerid, MARKET_TYPE_ACS, model_id))
            {
                ShowPlayerDialog(playerid, D_MARKET_PRICE_INPUT, DIALOG_STYLE_INPUT,
                    "Цена товара", "Введите цену товара (от 0 до 100.000.000):",
                    "Ок", "Отмена");
            }
        }
        case D_MARKET_SKIN_PICK:
        {
            if(!response)
            {
                Market_ShowSellTypeDialog(playerid);
                return 1;
            }

            new idx = GetPlayerListitemValue(playerid, listitem);
            SetPVarInt(playerid, "Market_ItemID", idx);
            SetPVarInt(playerid, "Market_ItemType", MARKET_TYPE_SKIN);

            new query[128], Cache:result;
            mysql_format(mysql, query, sizeof query, "SELECT skin_id FROM inventory_skins WHERE id = %d AND owner_skin = %d", GetPVarInt(playerid, "Market_ItemID"), GetPlayerAccountID(playerid));
            result = mysql_query(mysql, query, true);

            if(!cache_num_rows())
            {
                cache_delete(result);
                SendClientMessage(playerid, COLOR_RED, "Ошибка: скин не найден.");
                return 1;
            }

            new model_id = cache_get_field_content_int(0, "skin_id");
            cache_delete(result);

            SetPVarInt(playerid, "Market_ModelID", model_id);

            if(!Market_CheckDuplicateItem(playerid, MARKET_TYPE_SKIN, model_id))
            {
                ShowPlayerDialog(playerid, D_MARKET_PRICE_INPUT, DIALOG_STYLE_INPUT,
                    "Цена товара", "Введите цену товара (от 0 до 100.000.000):",
                    "Ок", "Отмена");
            }
        }
        case D_MARKET_PRICE_INPUT:
        {
            if(!response) return 1;

            new query[228];
            new price = strval(inputtext);
            if(price < 0 || price > 100000000)
            {
                SendClientMessage(playerid, COLOR_RED, ""USC"Неверная цена! Допустимый диапазон от 0 до 100.000.000 руб");
                ShowPlayerDialog(playerid, D_MARKET_PRICE_INPUT, DIALOG_STYLE_INPUT,
                    "Цена товара", "Введите цену товара (от 0 до 100.000.000 руб):",
                    "Ок", "Отмена");
                return 1;
            }

            switch(GetPVarInt(playerid, "Market_ItemType"))
            {
                case MARKET_TYPE_ACS:
                {
                    DeleteAccessory(GetPVarInt(playerid, "Market_ItemID"));
                }
                case MARKET_TYPE_SKIN:
                {
                    mysql_format(mysql, query, sizeof query, "DELETE FROM inventory_skins WHERE id = %d AND owner_skin = %d", GetPVarInt(playerid, "Market_ItemID"), GetPlayerAccountID(playerid));
                    mysql_query(mysql, query, false);
                }
            }

            Market_CreateSellItem(playerid, GetPVarInt(playerid, "Market_ItemType"), GetPVarInt(playerid, "Market_ModelID"), price);
        }
        case D_MARKET_CONFIRM_DUP:
        {
            if(response)
            {
                new query[228];
                mysql_format(mysql, query, sizeof query, "UPDATE market_items SET quantity = %d WHERE id = %d", GetPVarInt(playerid, "Market_ItemQuantity") + 1, GetPVarInt(playerid, "Market_ItemID"));
                mysql_query(mysql, query, false);

                switch(GetPVarInt(playerid, "Market_ItemType"))
                {
                    case MARKET_TYPE_ACS:
                    {
                        DeleteAccessory(GetPVarInt(playerid, "Market_ItemID"));
                    }
                    case MARKET_TYPE_SKIN:
                    {
                        mysql_format(mysql, query, sizeof query, "DELETE FROM inventory_skins WHERE id = %d AND owner_skin = %d", GetPVarInt(playerid, "Market_ItemID"), GetPlayerAccountID(playerid));
                        mysql_query(mysql, query, false);
                    }
                }
                Market_Hide(playerid); // для загрузки обновления товаров
                Market_LoadItems(); // обновление товаров

                SendClientMessage(playerid, 0x00FF00FF, "| {ffffff}Товар успешно снят с продажи и возвращен!");
            }
            else return 1;
        }
    }
    #if defined market_OnDialogResponse
        return market_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse market_OnDialogResponse
#if defined market_OnDialogResponse
    forward market_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock Market_CreateSellItem(playerid, type, model_id, price)
{
    if(GetPlayerMoneyEx(playerid) < 10000)
    {
        SendClientMessage(playerid, COLOR_RED, ""USC"Для создания объявления требуется 10.000 руб!");
        return 0;
    }
    
    GivePlayerMoneyEx(playerid, -10000);
    
    new query[556];
    new expire_time = 24; // 24 часа

    mysql_format(mysql, query, sizeof query, "INSERT INTO market_items (owner_id, type, model_id, price, quantity, expire_time) VALUES (%d, %d, %d, %d, 1, %d)", GetPlayerAccountID(playerid), type, model_id, price, expire_time);
    mysql_query(mysql, query, false);
        
    if(!mysql_errno())
	{
        SendClientMessage(playerid, 0x00FF00FF, "| {ffffff}Товар успешно выставлен на продажу!");
        Market_Hide(playerid); // для загрузки обновления товаров
        Market_LoadItems(); // обновление товаров
    }
    else printf("[WERTON_MARKET] ERROR %d Получен запрос на создание товара - %s", mysql_errno(), query);
    return 1;
}

CMD:marketplace(playerid)
{
    Market_Show(playerid);
    return 1;
}

// ==========================================
// ФУНКЦИИ ДЛЯ РАБОТЫ С ИНВЕНТАРЕМ
// ==========================================

// Выдача аксессуара
stock GiveAccessory(playerid, modelid)
{
    return GivePlayerOwnableAccessory(playerid, modelid);
}

// Удаление аксессуара
stock DeleteAccessory(acc_id)
{
    new query[128];
    mysql_format(mysql, query, sizeof query, "DELETE FROM inventory_accessories WHERE id = %d", acc_id);
    mysql_query(mysql, query, false);
    return 1;
}

// Проверка скинов игрока
stock CheckSkinPlayer(playerid)
{
    return 1;
}


/*
// Выдача скина
stock GivePlayerOwnableSkin(playerid, skinid)
{
    return GivePlayerOwnableSkin(playerid, skinid);
}
*/