// ============================================================
//  RP SYSTEMS Ч ≈ƒ»Ќџ… »Ќ Ћ”ƒ
//  —тройка (стройматериалы + постройка) + Ћетний Summer Fest
//  (—ветлана, доставка арбузов, /ishop) Ч всЄ в одном файле.
//
//  ѕќƒ Ћё„≈Ќ»≈ (3 строки в гамемоде):
//
//     #include "rp_systems.inc"
//
//     public OnGameModeInit()
//     {
//         Systems_Init();
//         return 1;
//     }
//
//     public OnPlayerCommandText(playerid, cmdtext[])
//     {
//         if(Systems_OnCommand(playerid, cmdtext)) return 1;
//         return 0; // не наша команда Ч пусть еЄ обработает остальной код мода
//     }
//
//     public OnPlayerPickUpPickup(playerid, pickupid)
//     {
//         Systems_OnPickup(playerid, pickupid);
//         return 1;
//     }
//
//     public OnPlayerDisconnect(playerid, reason)
//     {
//         Systems_OnDisconnect(playerid);
//         return 1;
//     }
//
//     public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
//     {
//         if(Systems_OnDialog(playerid, dialogid, response, listitem)) return 1;
//         return 1;
//     }
//
//  ≈сли у теб€ ”∆≈ есть тело этих callback'ов в гамемоде Ч не дублируй
//  public-функцию, а просто добавь внутрь неЄ соответствующий вызов
//  Systems_OnXxx(...).
//
//  ‘айл сам защищЄн от повторного подключени€ (include guard) Ч
//  можно спокойно #include его из нескольких мест, ничего не сломаетс€.
//
//   ќƒ»–ќ¬ ј: р€дом лежит верси€ rp_systems_cp1251.inc Ч компилируй
//  ≈®, чтобы кириллица не побилась в игре (SA-MP ждЄт Windows-1251).
// ============================================================

#if defined _rp_systems_included
	#endinput
#endif
#define _rp_systems_included

// в CRMP/SA-MP 0.3e нативы CreateActor/SetActorInvulnerable/
// ApplyActorAnimation по умолчанию Ќ≈ подключены Ч без этого инклуда
// NPC просто не по€вл€ютс€ (не ошибка кода, а отсутствующа€ либа).
// #tryinclude не рон€ет компил€цию, если файла нет в твоЄм пакете.
#tryinclude <a_actor>
// нужен дл€ CreateDynamicSphere / CreateDynamic3DTextLabel / CreateDynamicMapIcon
#tryinclude <streamer>


// ============================================================
//  ЅЋќ  1: —“–ќ»“≈Ћ№Ќјя  ќћѕјЌ»я
// ============================================================
// -------------------- ѕ≈–≈ћ≈ЌЌџ≈ --------------------
#define MAX_STROY_STATE_NONE      0   // не в смене
#define MAX_STROY_STATE_EMPTY     1   // в смене, грузовик пустой, едет за материалом
#define MAX_STROY_STATE_LOADED    2   // материал загружен, едет на объект
#define MAX_STROY_STATE_BUILDING  3   // разгрузилс€, идЄт процесс постройки

new gStroyState[MAX_PLAYERS];         // текущее состо€ние игрока в работе
new gStroyTruck[MAX_PLAYERS];         // id грузовика, выданного игроку
new gStroyBuildTimer[MAX_PLAYERS];    // id таймера процесса стройки
new gStroyTripsDone[MAX_PLAYERS];     // сколько рейсов сделано за смену (статистика)

new StroyWarehousePickup;             // пикап склада (погрузка)
new StroySitePickup;                  // пикап объекта (разгрузка/начало стройки)
new Text3D:StroyWarehouseLabel;
new Text3D:StroySiteLabel;

// -------------------- Ќј—“–ќ… » --------------------
#define STROY_PAY_PER_TRIP      850     // оплата за один завершЄнный рейс (доставка + постройка)
#define STROY_BUILD_TIME        18000   // врем€ постройки на объекте, мс (18 сек)
#define STROY_TRUCK_MODEL       515     // Flatbed Ч стандартна€ грузова€ модель GTA SA

//! ѕќƒ—“ј¬№ —¬ќ»  ќќ–ƒ»Ќј“џ
#define STROY_WAREHOUSE_POS     -1898.3, 344.2, 35.6     // склад стройматериалов
#define STROY_SITE_POS           1215.7, -1320.4, 15.2   // стройплощадка / объект
#define STROY_TRUCK_SPAWN_X     -1892.6
#define STROY_TRUCK_SPAWN_Y      340.1
#define STROY_TRUCK_SPAWN_Z      35.6
#define STROY_TRUCK_SPAWN_A      90.0

// -------------------- FORWARD --------------------
forward StroyFinishBuilding(playerid);

// ============================================================
//  »Ќ»÷»јЋ»«ј÷»я (вызвать из OnGameModeInit)
// ============================================================
stock CreateStroykaCompany()
{
    StroyWarehousePickup = CreatePickup(1239, 1, STROY_WAREHOUSE_POS, -1);
    StroySitePickup      = CreatePickup(1239, 1, STROY_SITE_POS, -1);

    StroyWarehouseLabel = Create3DTextLabel("—клад стройматериалов\n{FFFFFF}/work - начать смену", 0xFFA500FF, STROY_WAREHOUSE_POS, 12.0, -1, 0);
    StroySiteLabel       = Create3DTextLabel("—тройплощадка", 0x55DD55FF, STROY_SITE_POS, 12.0, -1, 0);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        gStroyState[i] = MAX_STROY_STATE_NONE;
        gStroyTruck[i] = 0;
        gStroyBuildTimer[i] = 0;
        gStroyTripsDone[i] = 0;
    }
    return 1;
}

// ============================================================
//  /work Ч начать или закончить смену
// ============================================================
stock StroyCmd_Work(playerid, params[])
{
    #pragma unused params

    if(gStroyState[playerid] == MAX_STROY_STATE_NONE)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 8.0, STROY_WAREHOUSE_POS))
        {
            SendClientMessage(playerid, 0xFF5555FF, "“ы должен быть р€дом со складом стройматериалов, чтобы начать смену.");
            return 1;
        }

        new vid = CreateVehicle(STROY_TRUCK_MODEL, STROY_TRUCK_SPAWN_X, STROY_TRUCK_SPAWN_Y, STROY_TRUCK_SPAWN_Z, STROY_TRUCK_SPAWN_A, 0, 0, -1, 0);
        gStroyTruck[playerid] = vid;
        gStroyState[playerid] = MAX_STROY_STATE_EMPTY;
        gStroyTripsDone[playerid] = 0;

        PutPlayerInVehicle(playerid, vid, 0);
        SendClientMessage(playerid, 0x55DD55FF, "—мена началась! ѕодъезжай к пикапу склада, чтобы загрузить материалы.");
        return 1;
    }

    // остановить смену Ч только когда грузовик пустой (нельз€ бросить смену с грузом)
    if(gStroyState[playerid] != MAX_STROY_STATE_EMPTY)
    {
        SendClientMessage(playerid, 0xFF5555FF, "Ќельз€ закончить смену с незавершЄнным рейсом Ч сначала довези и построй.");
        return 1;
    }

    if(gStroyBuildTimer[playerid] != 0)
    {
        KillTimer(gStroyBuildTimer[playerid]);
        gStroyBuildTimer[playerid] = 0;
    }
    if(gStroyTruck[playerid] != 0 && IsValidVehicle(gStroyTruck[playerid]))
    {
        DestroyVehicle(gStroyTruck[playerid]);
    }
    gStroyTruck[playerid] = 0;
    gStroyState[playerid] = MAX_STROY_STATE_NONE;

    new msg[96];
    format(msg, sizeof(msg), "—мена окончена. –ейсов сделано: %d.", gStroyTripsDone[playerid]);
    SendClientMessage(playerid, 0x55DD55FF, msg);
    return 1;
}

// ============================================================
//  ѕикапы: погрузка на складе / разгрузка на объекте
// ============================================================
stock StroyHandlePickup(playerid, pickupid)
{
    if(pickupid == StroyWarehousePickup)
    {
        if(gStroyState[playerid] != MAX_STROY_STATE_EMPTY) return 0;
        if(!IsPlayerInAnyVehicle(playerid)) return 0;
        if(GetPlayerVehicleID(playerid) != gStroyTruck[playerid]) return 0;

        gStroyState[playerid] = MAX_STROY_STATE_LOADED;
        SendClientMessage(playerid, 0x55DD55FF, "ћатериалы загружены. “еперь доставь их на стройплощадку.");
        GameTextForPlayer(playerid, "~g~ћатериалы загружены", 3000, 4);
        return 1;
    }

    if(pickupid == StroySitePickup)
    {
        if(gStroyState[playerid] != MAX_STROY_STATE_LOADED) return 0;
        if(!IsPlayerInAnyVehicle(playerid)) return 0;
        if(GetPlayerVehicleID(playerid) != gStroyTruck[playerid]) return 0;

        // разгружаемс€ и начинаем непосредственно стройку
        RemovePlayerFromVehicle(playerid);
        gStroyState[playerid] = MAX_STROY_STATE_BUILDING;

        SendClientMessage(playerid, 0x55DD55FF, "ћатериалы выгружены. Ќачинаем стройку Ч не уходи с объекта.");
        GameTextForPlayer(playerid, "~y~—тройка началась...", 3000, 4);

        ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 1, 1, 1, 1, 0, 1);
        gStroyBuildTimer[playerid] = SetTimerEx("StroyFinishBuilding", STROY_BUILD_TIME, false, "i", playerid);
        return 1;
    }

    return 0;
}

// ============================================================
//  ѕостройка завершена Ч оплата
// ============================================================
public StroyFinishBuilding(playerid)
{
    gStroyBuildTimer[playerid] = 0;

    if(!IsPlayerConnected(playerid)) return 1;
    if(gStroyState[playerid] != MAX_STROY_STATE_BUILDING) return 1;

    ClearAnimations(playerid, 1);
    GivePlayerMoney(playerid, STROY_PAY_PER_TRIP);
    gStroyTripsDone[playerid]++;
    gStroyState[playerid] = MAX_STROY_STATE_EMPTY;

    new msg[128];
    format(msg, sizeof(msg), "ќбъект готов! ѕолучено $%d. –ейсов за смену: %d. ¬озвращайс€ на склад за новым грузом.",
        STROY_PAY_PER_TRIP, gStroyTripsDone[playerid]);
    SendClientMessage(playerid, 0x55DD55FF, msg);
    GameTextForPlayer(playerid, "~g~+$850", 3000, 4);

    if(gStroyTruck[playerid] != 0 && IsValidVehicle(gStroyTruck[playerid]))
    {
        PutPlayerInVehicle(playerid, gStroyTruck[playerid], 0);
    }
    return 1;
}

// ============================================================
//  ќтключение игрока Ч убрать грузовик и таймер, чтобы не висели
// ============================================================
stock StroyHandleDisconnect(playerid)
{
    if(gStroyBuildTimer[playerid] != 0)
    {
        KillTimer(gStroyBuildTimer[playerid]);
        gStroyBuildTimer[playerid] = 0;
    }
    if(gStroyTruck[playerid] != 0 && IsValidVehicle(gStroyTruck[playerid]))
    {
        DestroyVehicle(gStroyTruck[playerid]);
    }
    gStroyTruck[playerid] = 0;
    gStroyState[playerid] = MAX_STROY_STATE_NONE;
    return 1;
}

// ============================================================
//  ЅЋќ  2: Ћ≈“Ќ»… SUMMER FEST (—ветлана + арбузы + /ishop)
// ============================================================
// -------------------- NPC "—¬≈“ЋјЌј" Ќј ¬ќ «јЋ≈ --------------------
#define FEST_NPC_SKIN         225
#define FEST_NPC_NAME         "—ветлана"

// координаты сн€ты у здани€ вокзала (скрин с вывеской "Ѕатыревский автовокзал")
#define FEST_NPC_X            1806.831909
#define FEST_NPC_Y            2514.694824
#define FEST_NPC_Z              14.630664
#define FEST_NPC_ANGLE          133.307891

#define FEST_TALK_DISTANCE      3.0
#define DIALOG_FEST_GREETING       998210

new gFestNPC = -1;
new Text3D:gFestNPCLabel;
new gFestCoins[MAX_PLAYERS];   // баланс R-коинс

// ============================================================
//  ƒќ—“ј¬ ј ј–Ѕ”«ќ¬ ("Ё —ѕ≈ƒ»“ќ– ћј —", было "√итлер" Ч заменено,
//  см. по€снение в чате. ѕомен€ть им€ Ч одна строка ниже)
// ============================================================
#define WM_NPC_SKIN            25
#define WM_NPC_NAME            "Ёкспедитор ћакс"

// координаты NPC Ч фото 1 (перенесЄн по твоей правке)
#define WM_NPC_X               -698.2553
#define WM_NPC_Y                105.0698
#define WM_NPC_Z                 16.4212
#define WM_NPC_ANGLE              0.0

#define WM_TALK_DISTANCE        3.0
#define DIALOG_WM_GREETING         998211

// машина дл€ рейсов Ч теперь случайно 466 »Ћ» 499
new const WM_TRUCK_MODELS[] = {466, 499};

// точки погрузки арбузов (фото 12 Ч метка загрузки)
#define WM_LOAD_X              -2471.8427
#define WM_LOAD_Y               -215.4944
#define WM_LOAD_Z                 27.5385

// точка разгрузки (фото 11 Ч у завода)
#define WM_UNLOAD_X              -935.4684
#define WM_UNLOAD_Y              2118.2238
#define WM_UNLOAD_Z                44.5868

#define WM_PAY_MIN               100   // оплата за рейс Ч от 100
#define WM_PAY_MAX               200   // до 200 R-коинс (случайно в этом диапазоне)

new gWmPickup;      // пикап погрузки
new gWmDropoff;     // пикап разгрузки
new gWmTruckMarker; // пикап "забрать машину" пр€мо у ћакса
new Text3D:gWmLoadLabel;
new Text3D:gWmDropLabel;

#define WM_STATE_NONE     0   // не в рейсе
#define WM_STATE_EMPTY    1   // с грузовиком, едет за арбузами
#define WM_STATE_LOADED   2   // арбузы загружены, едет на разгрузку

new gWmState[MAX_PLAYERS];
new gWmTruck[MAX_PLAYERS];

// точки спавна грузовиков на парковке (фото 4,6,7,8,9,5 Ч весь п€тачок сто€нки)
new const Float:WmTruckSpawns[][4] = {
    {-2110.048828, -1853.144897, 14.576358, 177.045623},
    {-2099.936523, -1853.282592, 14.576358, 169.385391},
    {-2092.505859, -1852.432739, 14.576358, 160.637542},
    {-2106.824707, -1852.760253, 14.576358, 169.307723},
    {-2096.196777, -1853.225341, 14.576358, 142.805252},
    {-1335.279296, -1550.082153, 60.841377, 333.820404}
};

// ============================================================
//   ј“јЋќ√ /ISHOP Ч тачки + скины (все ID и цены Ч как ты прислал;
//  где цену не назвал, € выставил свою Ч они помечены ниже в коде)
// ============================================================
enum E_FESTSHOP
{
    FestShop_Name[32],
    FestShop_Type,     // 0 = машина, 1 = скин
    FestShop_Value,
    FestShop_Price
};
new const FestShopCatalog[][E_FESTSHOP] =
{
    {"‘ормула 1",              0, 602, 1000},
    {"BMW",                    0, 466,  750},
    {"BMW M4 F84",             0, 558, 1600},   // цена по умолчанию, не была указана Ч помен€й если нужно
    {"Porsche Panamera S",     0, 604, 1800},   // цена по умолчанию
    {"Ford Mustang GT",        0, 603, 1400},   // цена по умолчанию

    {" астет",                 1, 5903, 500},   // цены скинов по умолчанию Ч не были указаны
    {"—офи€",                  1, 7770, 500},
    {"—окол",                  1, 7771, 500},
    {"√ромов",                 1, 7772, 500},
    {"ƒ€д€ ∆ора",              1, 7773, 500},
    {"¬ульгарна€ ƒевушка",     1, 7774, 500},
    {"Aarne",                  1, 5896, 500},
    {"Bushido Zho",            1, 5897, 500}
};

#define DIALOG_FEST_SHOP           998212
#define DIALOG_FEST_SHOP_CONFIRM   998213
new gFestShopSelected[MAX_PLAYERS];

// ============================================================
//  »Ќ»÷»јЋ»«ј÷»я (вызвать из OnGameModeInit)
// ============================================================
stock Fest_Init()
{
    // NPC "—ветлана" Ч CreateActor + ќЅя«ј“≈Ћ№Ќќ SetActorVirtualWorld,
    // иначе актЄр создаЄтс€ вне мира игрока и физически не виден
    // (это и было причиной "NPC нету" Ч по твоему рабочему примеру)
    gFestNPC = CreateActor(FEST_NPC_SKIN, FEST_NPC_X, FEST_NPC_Y, FEST_NPC_Z, FEST_NPC_ANGLE);
    SetActorInvulnerable(gFestNPC, true);
    SetActorVirtualWorld(gFestNPC, 0);

    CreateDynamicSphere(FEST_NPC_X, FEST_NPC_Y, FEST_NPC_Z, 2.0);
    CreateDynamic3DTextLabel(
        "{FF5252}Ђ "FEST_NPC_NAME" | ќрганизатор Summer Fest ї\n{FFFFFF}/talk - поговорить",
        0xFF5252FF, FEST_NPC_X, FEST_NPC_Y, FEST_NPC_Z + 0.8, 10.0);
    CreateDynamicMapIcon(FEST_NPC_X, FEST_NPC_Y, FEST_NPC_Z, 55, 0xFFFFFFFF);

    // NPC "Ёкспедитор ћакс" Ч тот же принцип
    new wmNpcActor = CreateActor(WM_NPC_SKIN, WM_NPC_X, WM_NPC_Y, WM_NPC_Z, WM_NPC_ANGLE);
    SetActorInvulnerable(wmNpcActor, true);
    SetActorVirtualWorld(wmNpcActor, 0);

    CreateDynamicSphere(WM_NPC_X, WM_NPC_Y, WM_NPC_Z, 2.0);
    CreateDynamic3DTextLabel(
        "{FF5252}Ђ "WM_NPC_NAME" ї\n{FFFFFF}/arbuz - вз€ть грузовик",
        0xFF5252FF, WM_NPC_X, WM_NPC_Y, WM_NPC_Z + 0.8, 10.0);
    CreateDynamicMapIcon(WM_NPC_X, WM_NPC_Y, WM_NPC_Z, 55, 0xFFFFFFFF);

    // пикап "забрать машину" пр€мо у ћакса Ч альтернатива команде /arbuz
    gWmTruckMarker = CreatePickup(1239, 1, WM_NPC_X, WM_NPC_Y, WM_NPC_Z, -1);

    gWmPickup  = CreatePickup(1239, 1, WM_LOAD_X, WM_LOAD_Y, WM_LOAD_Z, -1);
    gWmDropoff = CreatePickup(1239, 1, WM_UNLOAD_X, WM_UNLOAD_Y, WM_UNLOAD_Z, -1);
    gWmLoadLabel = CreateDynamic3DTextLabel("ѕогрузка арбузов", 0x55DD55FF, WM_LOAD_X, WM_LOAD_Y, WM_LOAD_Z + 0.8, 12.0);
    gWmDropLabel = CreateDynamic3DTextLabel("–азгрузка", 0xFFA500FF, WM_UNLOAD_X, WM_UNLOAD_Y, WM_UNLOAD_Z + 0.8, 12.0);
    CreateDynamicMapIcon(WM_LOAD_X, WM_LOAD_Y, WM_LOAD_Z, 55, 0x55DD55FF);
    CreateDynamicMapIcon(WM_UNLOAD_X, WM_UNLOAD_Y, WM_UNLOAD_Z, 55, 0xFFA500FF);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        gFestCoins[i] = 0;
        gWmState[i] = WM_STATE_NONE;
        gWmTruck[i] = 0;
    }
    return 1;
}

// ============================================================
//  /talk Ч поговорить со —ветланой
// ============================================================
stock Fest_Cmd_Talk(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerInRangeOfPoint(playerid, FEST_TALK_DISTANCE, FEST_NPC_X, FEST_NPC_Y, FEST_NPC_Z))
    {
        SendClientMessage(playerid, 0xFF5555FF, "ѕодойди ближе к —ветлане на вокзале.");
        return 1;
    }

    new pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));

    new dlgText[400];
    format(dlgText, sizeof(dlgText),
        "«дравствуйте, %s!\n\n\
Ќа RUSSIA RP сейчас активен ивент {FFDD55}\"Ћетний Summer Fest\"{FFFFFF}.\n\
¬ыполн€й задани€ Ч за них начисл€ютс€ {FFDD55}R-коинс{FFFFFF}.\n\
ѕотрать их в {FFDD55}/ishop{FFFFFF} Ч там тачки и скины.\n\n\
’орошего отдыха на фестивале!",
        pname);

    ShowPlayerDialog(playerid, DIALOG_FEST_GREETING, DIALOG_STYLE_MSGBOX, "—ветлана | Summer Fest", dlgText, "—пасибо", "«акрыть");
    return 1;
}

// ============================================================
//  /arbuz Ч вз€ть грузовик у Ёкспедитора ћакса
// ============================================================
stock Fest_Cmd_TakeTruck(playerid, params[])
{
    #pragma unused params

    if(!IsPlayerInRangeOfPoint(playerid, WM_TALK_DISTANCE, WM_NPC_X, WM_NPC_Y, WM_NPC_Z))
    {
        SendClientMessage(playerid, 0xFF5555FF, "ѕодойди ближе к NPC у парковки грузовиков.");
        return 1;
    }
    if(gWmState[playerid] != WM_STATE_NONE)
    {
        SendClientMessage(playerid, 0xFF5555FF, "” теб€ уже есть грузовик в рейсе.");
        return 1;
    }

    new spawnIdx = random(sizeof(WmTruckSpawns));
    new truckModel = WM_TRUCK_MODELS[random(sizeof(WM_TRUCK_MODELS))];
    new vid = CreateVehicle(truckModel,
        WmTruckSpawns[spawnIdx][0], WmTruckSpawns[spawnIdx][1], WmTruckSpawns[spawnIdx][2], WmTruckSpawns[spawnIdx][3],
        -1, -1, -1, 0);

    gWmTruck[playerid] = vid;
    gWmState[playerid] = WM_STATE_EMPTY;
    PutPlayerInVehicle(playerid, vid, 0);

    SendClientMessage(playerid, 0x55DD55FF, "√рузовик выдан! ≈зжай на точку погрузки арбузов (отмечена на карте).");
    SetPlayerCheckpoint(playerid, WM_LOAD_X, WM_LOAD_Y, WM_LOAD_Z, 4.0);
    return 1;
}

// ============================================================
//  ѕикапы погрузки/разгрузки
// ============================================================
stock Fest_HandlePickup(playerid, pickupid)
{
    if(pickupid == gWmTruckMarker)
    {
        if(gWmState[playerid] != WM_STATE_NONE)
        {
            SendClientMessage(playerid, 0xFF5555FF, "” теб€ уже есть грузовик в рейсе.");
            return 1;
        }
        Fest_Cmd_TakeTruck(playerid, "");
        return 1;
    }

    if(pickupid == gWmPickup)
    {
        if(gWmState[playerid] != WM_STATE_EMPTY) return 0;
        if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleID(playerid) != gWmTruck[playerid]) return 0;

        gWmState[playerid] = WM_STATE_LOADED;
        SendClientMessage(playerid, 0x55DD55FF, "јрбузы загружены! “еперь вези их на разгрузку.");
        GameTextForPlayer(playerid, "~g~јрбузы загружены", 3000, 4);
        SetPlayerCheckpoint(playerid, WM_UNLOAD_X, WM_UNLOAD_Y, WM_UNLOAD_Z, 4.0);
        return 1;
    }

    if(pickupid == gWmDropoff)
    {
        if(gWmState[playerid] != WM_STATE_LOADED) return 0;
        if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleID(playerid) != gWmTruck[playerid]) return 0;

        new pay = WM_PAY_MIN + random(WM_PAY_MAX - WM_PAY_MIN + 1);
        gFestCoins[playerid] += pay;
        gWmState[playerid] = WM_STATE_EMPTY;

        new msg[128];
        format(msg, sizeof(msg), "јрбузы доставлены! +%d R-коинс (баланс: %d). ¬озвращайс€ на погрузку за новой партией.", pay, gFestCoins[playerid]);
        SendClientMessage(playerid, 0xFFDD55FF, msg);
        GameTextForPlayer(playerid, "~g~+R-коинс", 3000, 4);

        DisablePlayerCheckpoint(playerid);
        SetPlayerCheckpoint(playerid, WM_LOAD_X, WM_LOAD_Y, WM_LOAD_Z, 4.0);
        return 1;
    }
    return 0;
}

// закончить рейсы и сдать грузовик (можно вызвать по команде /sdat)
stock Fest_Cmd_ReturnTruck(playerid, params[])
{
    #pragma unused params
    if(gWmState[playerid] == WM_STATE_NONE)
    {
        SendClientMessage(playerid, 0xFF5555FF, "” теб€ нет грузовика в рейсе.");
        return 1;
    }
    if(gWmState[playerid] == WM_STATE_LOADED)
    {
        SendClientMessage(playerid, 0xFF5555FF, "—начала довези загруженные арбузы до разгрузки.");
        return 1;
    }
    if(gWmTruck[playerid] != 0 && IsValidVehicle(gWmTruck[playerid])) DestroyVehicle(gWmTruck[playerid]);
    gWmTruck[playerid] = 0;
    gWmState[playerid] = WM_STATE_NONE;
    DisablePlayerCheckpoint(playerid);
    SendClientMessage(playerid, 0x55DD55FF, "√рузовик сдан.");
    return 1;
}

stock Fest_HandleDisconnect(playerid)
{
    if(gWmTruck[playerid] != 0 && IsValidVehicle(gWmTruck[playerid])) DestroyVehicle(gWmTruck[playerid]);
    gWmTruck[playerid] = 0;
    gWmState[playerid] = WM_STATE_NONE;
    return 1;
}

// ============================================================
//  /ishop Ч магазин за R-коинс
// ============================================================
stock Fest_Cmd_Shop(playerid, params[])
{
    #pragma unused params
    new dlgText[1400];
    new shopPriceBuf[24];
    new dlgTitle[64];

    // баланс Ч в заголовок, а не в тело: в DIALOG_STYLE_LIST  ј∆ƒјя строка
    // тела становитс€ отдельным пунктом списка, и если сюда же пихать
    // текст баланса Ч все listitem сдвигаютс€, и покупка бьЄт мимо товара
    format(dlgTitle, sizeof(dlgTitle), "Summer Fest Ч баланс: %d R-коинс", gFestCoins[playerid]);

    dlgText[0] = '\0';
    for(new i = 0; i < sizeof(FestShopCatalog); i++)
    {
        strcat(dlgText, FestShopCatalog[i][FestShop_Name]);
        strcat(dlgText, " - ");
        format(shopPriceBuf, sizeof(shopPriceBuf), "%d коинс\n", FestShopCatalog[i][FestShop_Price]);
        strcat(dlgText, shopPriceBuf);
    }

    ShowPlayerDialog(playerid, DIALOG_FEST_SHOP, DIALOG_STYLE_LIST, dlgTitle, dlgText, " упить", "«акрыть");
    return 1;
}

// ============================================================
//  /setrcoin <id> <кол-во> Ч админ-команда, устанавливает баланс
//  R-коинс игроку. “ребует уровень админа 6+.
//
//  !ѕ–ќ¬≈– ј јƒћ»Ќ »: своей переменной pAdmin у теб€ в моде нет
//  (компил€тор ругалс€ на "undefined symbol"), поэтому по умолчанию
//  здесь стандартна€ RCON-проверка (IsPlayerAdmin) Ч компилируетс€
//  всегда, без знани€ структуры твоего мода.
//  „тобы вместо RCON была именно “¬ќя система уровней (6+) Ч впиши
//  в тело функции SetRCoin_IsAdmin() свою переменную вместо строки
//  ниже (например: return PlayerInfo[playerid][“¬ќ®_ѕќЋ≈] >= 6;)
//  и просто скажи мне название переменной Ч подставлю сам.
// ============================================================
#define SETRCOIN_REQUIRED_LEVEL   6

stock bool:SetRCoin_IsAdmin(playerid)
{
    return bool:(GetPlayerAdminEx(playerid) >= SETRCOIN_REQUIRED_LEVEL);
}

stock Fest_Cmd_SetRCoin(playerid, params[])
{
    if(!SetRCoin_IsAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF5555FF, "” теб€ нет доступа к этой команде (требуетс€ админ 6+ уровн€).");
        return 1;
    }

    new targetid, amount;
    if(sscanf(params, "ui", targetid, amount))
    {
        SendClientMessage(playerid, 0xFFA500FF, "»спользование: /setrcoin [id игрока] [количество]");
        return 1;
    }

    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF5555FF, "»грок с таким ID не в сети.");
        return 1;
    }
    if(amount < 0)
    {
        SendClientMessage(playerid, 0xFF5555FF, " оличество не может быть отрицательным.");
        return 1;
    }

    gFestCoins[targetid] = amount;

    new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    GetPlayerName(targetid, targetName, sizeof(targetName));

    new msgAdmin[128], msgTarget[128];
    format(msgAdmin, sizeof(msgAdmin), "”становлено %d R-коинс игроку %s [ID %d].", amount, targetName, targetid);
    format(msgTarget, sizeof(msgTarget), "јдминистратор %s установил тебе %d R-коинс.", adminName, amount);

    SendClientMessage(playerid, 0xFFDD55FF, msgAdmin);
    SendClientMessage(targetid, 0xFFDD55FF, msgTarget);
    return 1;
}

stock Fest_HandleDialogResponse(playerid, dialogid, response, listitem)
{
    if(dialogid == DIALOG_FEST_GREETING || dialogid == DIALOG_WM_GREETING) return 1;

    if(dialogid == DIALOG_FEST_SHOP)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= sizeof(FestShopCatalog)) return 1;

        gFestShopSelected[playerid] = listitem;
        new confirmText[160];
        format(confirmText, sizeof(confirmText), " упить \"%s\" за %d R-коинс?",
            FestShopCatalog[listitem][FestShop_Name], FestShopCatalog[listitem][FestShop_Price]);
        ShowPlayerDialog(playerid, DIALOG_FEST_SHOP_CONFIRM, DIALOG_STYLE_MSGBOX, "ѕодтверждение покупки", confirmText, " упить", "ќтмена");
        return 1;
    }

    if(dialogid == DIALOG_FEST_SHOP_CONFIRM)
    {
        if(!response) return 1;
        new idx = gFestShopSelected[playerid];
        if(idx < 0 || idx >= sizeof(FestShopCatalog)) return 1;

        new price = FestShopCatalog[idx][FestShop_Price];
        if(gFestCoins[playerid] < price)
        {
            SendClientMessage(playerid, 0xFF5555FF, "Ќедостаточно R-коинс.");
            return 1;
        }
        gFestCoins[playerid] -= price;

        if(FestShopCatalog[idx][FestShop_Type] == 0)
        {
            new Float:x, Float:y, Float:z, Float:a;
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);
            new vid = CreateVehicle(FestShopCatalog[idx][FestShop_Value], x + 3.0, y, z, a, -1, -1, -1, 0);
            PutPlayerInVehicle(playerid, vid, 0);
            SendClientMessage(playerid, 0x55DD55FF, "ѕокупка успешна! ћашина заспавнена р€дом с тобой.");
        }
        else
        {
            SetPlayerSkin(playerid, FestShopCatalog[idx][FestShop_Value]);
            SendClientMessage(playerid, 0x55DD55FF, "ѕокупка успешна! —кин применЄн.");
        }
        gFestShopSelected[playerid] = -1;
        return 1;
    }
    return 0;
}

// ============================================================
//  ≈ƒ»Ќџ≈ “ќ„ » ¬’ќƒј Ч вызывай только их из своих callback'ов
//  гамемода (пример вставки Ч в шапке файла)
// ============================================================
stock Systems_Init()
{
    CreateStroykaCompany();
    Fest_Init();
    return 1;
}

stock Systems_OnCommand(playerid, cmdtext[])
{
    if(strcmp(cmdtext, "/work", true) == 0)  { StroyCmd_Work(playerid, "");        return 1; }
    if(strcmp(cmdtext, "/talk", true) == 0)  { Fest_Cmd_Talk(playerid, "");        return 1; }
    if(strcmp(cmdtext, "/arbuz", true) == 0) { Fest_Cmd_TakeTruck(playerid, "");   return 1; }
    if(strcmp(cmdtext, "/sdat", true) == 0)  { Fest_Cmd_ReturnTruck(playerid, ""); return 1; }
    if(strcmp(cmdtext, "/ishop", true) == 0) { Fest_Cmd_Shop(playerid, "");        return 1; }
    if(strcmp(cmdtext, "/setrcoin", true, 9) == 0) { Fest_Cmd_SetRCoin(playerid, cmdtext[10]); return 1; }
    return 0; // не наша команда
}

stock Systems_OnPickup(playerid, pickupid)
{
    if(StroyHandlePickup(playerid, pickupid)) return 1;
    if(Fest_HandlePickup(playerid, pickupid)) return 1;
    return 0;
}

stock Systems_OnDialog(playerid, dialogid, response, listitem)
{
    if(Fest_HandleDialogResponse(playerid, dialogid, response, listitem)) return 1;
    return 0;
}

stock Systems_OnDisconnect(playerid)
{
    StroyHandleDisconnect(playerid);
    Fest_HandleDisconnect(playerid);
    return 1;
}

// ============================================================
//   ќћјЌƒџ (CMD:им€(playerid, params[]))
//  –аботают с любым обработчиком, который понимает синтаксис
//  CMD: (ZCMD, YCMD, самописный на той же основе) Ч регистрируютс€
//  автоматически, ничего дополнительно вызывать не нужно (кроме
//  Systems_Init() в OnGameModeInit Ч см. шапку файла).
// ============================================================

CMD:work(playerid, params[])
{
    #pragma unused params
    StroyCmd_Work(playerid, "");
    return 1;
}

CMD:talk(playerid, params[])
{
    #pragma unused params
    Fest_Cmd_Talk(playerid, "");
    return 1;
}

CMD:arbuz(playerid, params[])
{
    #pragma unused params
    Fest_Cmd_TakeTruck(playerid, "");
    return 1;
}

CMD:sdat(playerid, params[])
{
    #pragma unused params
    Fest_Cmd_ReturnTruck(playerid, "");
    return 1;
}

CMD:ishop(playerid, params[])
{
    #pragma unused params
    Fest_Cmd_Shop(playerid, "");
    return 1;
}

CMD:setrcoin(playerid, params[])
{
    Fest_Cmd_SetRCoin(playerid, params);
    return 1;
}
