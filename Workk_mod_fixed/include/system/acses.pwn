//дефайны

#define BIZ_ACCESSORY 14
#define MAX_BIZ 200

//енумы

enum eBiz
{
    bizType,
    Float:bizX,
    Float:bizY,
    Float:bizZ,
    bizPickup
};
new BizInfo[MAX_BIZ][eBiz];
new TotalBiz;

//создание магазина

CMD:addbiz(playerid, params[])
{
    new type;
    if(sscanf(params, "d", type)) 
        return SendClientMessage(playerid, -1, "Используй: /addbiz [type]");

    if(type != BIZ_ACCESSORY)
        return SendClientMessage(playerid, -1, "Неверный тип бизнеса");

    if(TotalBiz >= MAX_BIZ) return 1;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    BizInfo[TotalBiz][bizType] = type;
    BizInfo[TotalBiz][bizX] = x;
    BizInfo[TotalBiz][bizY] = y;
    BizInfo[TotalBiz][bizZ] = z;

    BizInfo[TotalBiz][bizPickup] =
        CreatePickup(1274, 1, x, y, z);

    TotalBiz++;

    SendClientMessage(playerid, 0x33FF33FF, "Магазин аксессуаров создан");
    return 1;
}

//аксы 

enum eAccessory
{
    accModel,
    accName[32],
    accPrice
};

new Accessories[][eAccessory] =
{
    {18926, "Берет", 80},
    {19352, "Золотая корона"},
    {19353, "Корона демона"},
    {19087, "Крылья карамельки"},
    {19086, "Крылья бабочки"},
    {1210, "Кейс черный"},
    {1211, "Кейс белый"},
    {1212, "Кейс Макита"},
    {18641, "Ледяной посох"}
};

//переменные
new PlayerAccIndex[MAX_PLAYERS];
new PlayerAccObject[MAX_PLAYERS];

//вход на пикап

public OnPlayerPickUpPickup(playerid, pickupid)
{
    for(new i; i < TotalBiz; i++)
    {
        if(BizInfo[i][bizPickup] == pickupid &&
           BizInfo[i][bizType] == BIZ_ACCESSORY)
        {
            OpenAccessoryShop(playerid);
            return 1;
        }
    }
    return 1;
}

//установка камеры

stock OpenAccessoryShop(playerid)
{
    PlayerAccIndex[playerid] = 0;

    TogglePlayerControllable(playerid, 0);
    SetPlayerPos(playerid, 203.0, -50.0, 1001.0); // интерьер
    SetPlayerFacingAngle(playerid, 180.0);

    SetPlayerCameraPos(playerid, 203.0, -53.0, 1001.5);
    SetPlayerCameraLookAt(playerid, 203.0, -50.0, 1001.0);

    ShowAccessory(playerid);
}

//установка аксов по центру экрана в 3D

stock ShowAccessory(playerid)
{
    if(PlayerAccObject[playerid])
        DestroyObject(PlayerAccObject[playerid]);

    new id = PlayerAccIndex[playerid];

    PlayerAccObject[playerid] = CreateObject(
        Accessories[id][accModel],
        203.0, -50.0, 1001.0,
        0.0, 0.0, 180.0
    );

    new text[128];
    format(text, sizeof(text),
        "%s\nЦена: %d$\n<<<   КУПИТЬ   >>>",
        Accessories[id][accName],
        Accessories[id][accPrice]
    );

    GameTextForPlayer(playerid, text, 5000, 3);
}


//перелистывание кнопок/смена аксов

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_LEFT)
    {
        PlayerAccIndex[playerid]--;
        if(PlayerAccIndex[playerid] < 0)
            PlayerAccIndex[playerid] = sizeof(Accessories)-1;

        ShowAccessory(playerid);
    }

    if(newkeys & KEY_RIGHT)
    {
        PlayerAccIndex[playerid]++;
        if(PlayerAccIndex[playerid] >= sizeof(Accessories))
            PlayerAccIndex[playerid] = 0;

        ShowAccessory(playerid);
    }

    if(newkeys & KEY_FIRE)
    {
        BuyAccessory(playerid);
    }
    return 1;
}

//покупка аксов
stock BuyAccessory(playerid)
{
    new id = PlayerAccIndex[playerid];
    new price = Accessories[id][accPrice];

    if(GetPlayerMoney(playerid) < price)
        return SendClientMessage(playerid, 0xFF4444FF, "Недостаточно денег");

    GivePlayerMoney(playerid, -price);
    SendClientMessage(playerid, 0x33FF33FF, "Аксессуар куплен");

    SetPlayerAttachedObject(playerid, 0,
        Accessories[id][accModel],
        2, 0.1,0,0, 0,0,0);

    ExitAccessoryShop(playerid);
    return 1;
}

//выход из магаза
stock ExitAccessoryShop(playerid)
{
    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);

    if(PlayerAccObject[playerid])
        DestroyObject(PlayerAccObject[playerid]);
}