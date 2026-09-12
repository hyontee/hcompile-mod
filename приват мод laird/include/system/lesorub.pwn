// ==================================================================================
// СИСТЕМА "ЛЕСОРУБ" — полностью самостоятельный модуль.
// ЗП-текстдрав переиспользует ShowZPFelix/SetZPFelix/HideZPFelix из transport_company.pwn
// (компилировать вместе, порядок #include: сначала transport_company.pwn, потом этот файл).
// Всё остальное (уровни, рубка, форма, машинист) — свои массивы, без чужого enum.
//
// GUI (cmd:lesorub -> ShowPlayerGUI(playerid,23,json)) не подключал — схему этого GUI вы
// не присылали, а гадать вслепую (как было с такси) плохая идея. Интерфейс сделан на
// обычных зонах/диалогах, работает без единой команды на саму рубку. Если пришлёте
// JSON-схему GUI 23 — прикручу поверх этой же логики.
// ==================================================================================

#define LES_MIN_ACCOUNT_LEVEL 2   // устроиться лесорубом можно с 2 уровня аккаунта
#define LES_MACHINIST_MIN_LEVEL 3 // машинистом (доставка на грузовике) можно с 3 уровня лесоруба

#define LES_SALARY_MIN 250000
#define LES_SALARY_RANGE 500000   // 250 000 - 750 000 за дерево

#define LES_TREE_COOLDOWN 120000  // 2 мин — дерево не рубится второй раз подряд (выросло/убрали)

#define LES_LOG_BONUS_MIN 100000
#define LES_LOG_BONUS_RANGE 200000 // 100 000 - 300 000 бонуса за бревно при доставке машинистом

#define DIALOG_LES_HIRE 8910
#define DIALOG_LES_UNIFORM 8911
#define DIALOG_LES_MACHINIST 8912

new les_orders_for_level[6] = {0, 0, 20, 50, 100, 200}; // сколько деревьев нужно нарубить для перехода НА индекс-уровень (1..5)

// ==================================================================================
// Координаты (взяты с ваших скриншотов)
// ==================================================================================
new Float:les_trees[9][3] =
{
    {2332.2202, 580.3923, 27.1581},
    {2423.7497, 585.2711, 25.8002},
    {2416.9714, 639.1186, 22.8407},
    {2389.5268, 591.9610, 26.7747},
    {2432.6550, 630.8061, 22.8568},
    {2351.9423, 577.4795, 27.5197},
    {2327.2253, 592.1566, 26.6961},
    {2384.1276, 631.3131, 26.9598},
    {2425.2041, 601.7957, 25.3853}
};

new Float:les_npc_pos2[4] = {2373.7695, 580.9074, 26.7411, 0.0};    // Алёша — у раздевалки (уточнённые координаты)
new Float:les_changeroom[3] = {2372.5864, 578.4534, 26.7470};        // фото 11 — раздевалка
new Float:les_truck_spawn[4] = {2366.4602, 576.5072, 26.8822, 0.0};  // машина для доставки брёвен
new Float:les_warehouse[3] = {2382.0000, 622.0000, 26.2325};         // склад — сдвинут от камней/стены
#define LES_MARKER_OBJECT 18000 // объект-маркер на раздевалке/складе/точке машиниста

#define LES_TRUCK_MODEL 498 // модель грузовика — та же, что у "Озон" в системе дальнобойщика

// ==================================================================================
// Данные игрока
// ==================================================================================
enum E_LES_PLAYER
{
    bool:les_Hired,        // устроен ли лесорубом (постоянно, не сбрасывается при выходе)
    les_Level,             // 1-5
    les_TreesChopped,
    les_Earned,
    bool:les_Uniform,      // надета ли форма (работает ли прямо сейчас)
    bool:les_Chopping,     // рубит ли дерево прямо сейчас (анти-спам)
    les_Logs,              // сколько брёвен накоплено для доставки на склад
    les_Truck,             // машинист: id грузовика
    bool:les_DataLoaded,
    les_OriginalSkin // сохраняем скин игрока перед переодеванием в форму
}
new LesPlayer[MAX_PLAYERS][E_LES_PLAYER];

new les_tree_cooldown[9]; // GetTickCount() момента, когда дерево снова можно рубить
new les_changeroom_area;
new les_npc_area2; // зона найма у Алёши (у раздевалки)
new les_tree_area[9];
new Text3D:les_tree_label[9]; // ДОБАВЛЕНО: метки статуса деревьев (можно рубить / растёт)
new les_truck_area;
new les_warehouse_area;

// ==================================================================================
// MySQL
// ==================================================================================
public:CREATE_TABLE_LESORUB()
{
    mysql_query(mysql, "SELECT les_hired, les_level, les_trees, les_earned FROM accounts LIMIT 1", false);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` \
ADD `les_hired` TINYINT(1) NOT NULL DEFAULT '0' AFTER `job`, \
ADD `les_level` INT NOT NULL DEFAULT '1' AFTER `les_hired`, \
ADD `les_trees` INT NOT NULL DEFAULT '0' AFTER `les_level`, \
ADD `les_earned` INT NOT NULL DEFAULT '0' AFTER `les_trees`", false);
    }
    return 1;
}

forward LoadPlayerLesorubData(playerid);
public LoadPlayerLesorubData(playerid)
{
    new string[128], Cache:cache;
    mysql_format(mysql, string, sizeof string, "SELECT les_hired, les_level, les_trees, les_earned FROM accounts WHERE id=%d", GetPlayerAccountID(playerid));
    cache = mysql_query(mysql, string);

    if(cache_num_rows(cache))
    {
        LesPlayer[playerid][les_Hired] = bool:cache_get_row_int(0, 0);
        LesPlayer[playerid][les_Level] = cache_get_row_int(0, 1);
        LesPlayer[playerid][les_TreesChopped] = cache_get_row_int(0, 2);
        LesPlayer[playerid][les_Earned] = cache_get_row_int(0, 3);
        if(LesPlayer[playerid][les_Level] < 1) LesPlayer[playerid][les_Level] = 1;
    }
    else
    {
        LesPlayer[playerid][les_Hired] = false;
        LesPlayer[playerid][les_Level] = 1;
        LesPlayer[playerid][les_TreesChopped] = 0;
        LesPlayer[playerid][les_Earned] = 0;
    }
    LesPlayer[playerid][les_DataLoaded] = true;

    cache_delete(cache);
    return 1;
}

stock SavePlayerLesorubData(playerid)
{
    new query[192];
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET les_hired=%d, les_level=%d, les_trees=%d, les_earned=%d WHERE id=%d",
        LesPlayer[playerid][les_Hired], LesPlayer[playerid][les_Level], LesPlayer[playerid][les_TreesChopped], LesPlayer[playerid][les_Earned], GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    return 1;
}

// ==================================================================================
// Логика
// ==================================================================================
stock TryHireAtAlyosha(playerid)
{
    if(LesPlayer[playerid][les_Hired])
    {
        SendClientMessage(playerid, -1, "{2ECC71}[Алёша]{FFFFFF} Ты уже наш, топай к раздевалке.");
    }
    else if(GetPlayerLevel(playerid) < LES_MIN_ACCOUNT_LEVEL)
    {
        new string[128];
        format(string, sizeof string, "{2ECC71}[Алёша]{FFFFFF} Рубить лес у нас можно с %d уровня, подрасти ещё.", LES_MIN_ACCOUNT_LEVEL);
        SendClientMessage(playerid, -1, string);
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_LES_HIRE, DIALOG_STYLE_MSGBOX, "{2ECC71}Алёша — лесорубщик",
        "Устроиться на работу лесорубом?", "Устроиться", "Отмена");
    }
    return 1;
}

stock CheckLesorubLevelUp(playerid)
{
    new lvl = LesPlayer[playerid][les_Level];
    if(lvl >= 5) return 0;

    if(LesPlayer[playerid][les_TreesChopped] >= les_orders_for_level[lvl+1])
    {
        LesPlayer[playerid][les_Level]++;
        new string[144];
        format(string, sizeof string, "{2ECC71}[Лесоруб]{FFFFFF} Поздравляем! Вы повысили уровень лесоруба до {FFAE00}%d{FFFFFF}.", LesPlayer[playerid][les_Level]);
        SendClientMessage(playerid, -1, string);
        return 1;
    }
    return 0;
}

stock TakeOffLesUniform(playerid, const reason[])
{
    LesPlayer[playerid][les_Uniform] = false;
    if(LesPlayer[playerid][les_Chopping]) // снял форму во время рубки — прерываем
    {
        LesPlayer[playerid][les_Chopping] = false;
        ClearAnimations(playerid, true);
    }
    HideZPFelix(playerid); // переиспользуем ЗП-текстдрав из transport_company.pwn
    SetPlayerSkin(playerid, LesPlayer[playerid][les_OriginalSkin]); // возвращаем скин игрока

    new string[144];
    format(string, sizeof string, "{2ECC71}[Лесоруб]{FFFFFF} Вы сняли форму (%s).", reason);
    SendClientMessage(playerid, -1, string);
    return 1;
}

// ==================================================================================
// Рубка дерева командой /lesorub — без мини-игры, деньги начисляются сразу
// ==================================================================================
stock SetTreeRegrowing(treeid)
{
    les_tree_cooldown[treeid] = GetTickCount() + LES_TREE_COOLDOWN;
    if(IsValidDynamic3DTextLabel(les_tree_label[treeid]))
        UpdateDynamic3DTextLabelText(les_tree_label[treeid], -1, "{888888}Дерево растёт...");
    SetTimerEx("RestoreTreeLabel", LES_TREE_COOLDOWN, false, "i", treeid);
    return 1;
}

forward RestoreTreeLabel(treeid);
public RestoreTreeLabel(treeid)
{
    if(IsValidDynamic3DTextLabel(les_tree_label[treeid]))
        UpdateDynamic3DTextLabelText(les_tree_label[treeid], -1, "{2ECC71}Можно рубить");
    return 1;
}

forward FinishChoppingTree(playerid, treeid);
public FinishChoppingTree(playerid, treeid)
{
    if(!LesPlayer[playerid][les_Chopping]) return 1; // отменили раньше (снял форму/умер/ушёл)

    LesPlayer[playerid][les_Chopping] = false;
    SetTreeRegrowing(treeid);

    new salary = LES_SALARY_MIN + random(LES_SALARY_RANGE); // 250к - 750к за дерево
    GivePlayerMoneyEx(playerid, salary);
    LesPlayer[playerid][les_TreesChopped]++;
    LesPlayer[playerid][les_Earned] += salary;
    LesPlayer[playerid][les_Logs]++;

    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, false, false, false, false, 2000, true); // анимация переноски бревна, 2 сек

    new string[144];
    format(string, sizeof string, "{2ECC71}[Лесоруб]{FFFFFF} Дерево срублено! Получено {FFAE00}%d{FFFFFF} руб. Брёвен на складе ожидает доставки: {FFAE00}%d{FFFFFF}.", salary, LesPlayer[playerid][les_Logs]);
    SendClientMessage(playerid, -1, string);

    CheckLesorubLevelUp(playerid);
    SavePlayerLesorubData(playerid);

    SetZPFelix(playerid, salary); // показываем, сколько заработали за это дерево
    ShowZPFelix(playerid);
    return 1;
}

stock TryChopTree(playerid, treeid)
{
    if(!LesPlayer[playerid][les_Uniform])
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Сначала наденьте форму в раздевалке.");

    if(LesPlayer[playerid][les_Chopping])
        return 1; // уже рубит, не спамим

    if(GetPlayerVehicleID(playerid) != 0)
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Выйдите из транспорта, чтобы рубить дерево.");

    if(GetTickCount() < les_tree_cooldown[treeid])
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Это дерево уже срублено, поищите другое.");

    LesPlayer[playerid][les_Chopping] = true;
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 3000, true); // 3 сек анимация рубки, без цикла
    SetTimerEx("FinishChoppingTree", 3000, false, "ii", playerid, treeid); // ИЗМЕНЕНО: через 3 сек сразу оплата, без мини-игры
    return 1;
}

// ==================================================================================
// Диалоги
// ==================================================================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_LES_HIRE)
    {
        if(!response) return 1;

        LesPlayer[playerid][les_Hired] = true;
        SavePlayerLesorubData(playerid);
        SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Вы устроились лесорубом! Наденьте форму в раздевалке, чтобы начать работу.");
        return 1;
    }

    if(dialogid == DIALOG_LES_UNIFORM)
    {
        if(!response) return 1;

        if(LesPlayer[playerid][les_Uniform])
        {
            TakeOffLesUniform(playerid, "вручную");
        }
        else
        {
            LesPlayer[playerid][les_Uniform] = true;
            LesPlayer[playerid][les_OriginalSkin] = GetPlayerSkin(playerid); // ДОБАВЛЕНО: запоминаем скин перед переодеванием
            SetPlayerSkin(playerid, 8); // ИЗМЕНЕНО: скин формы лесоруба — id 8
            SetZPFelix(playerid, 0);
            ShowZPFelix(playerid); // ДОБАВЛЕНО: ЗП-текстдрав включается сразу при надевании формы
            SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Форма надета. Идите к деревьям и рубите.");
        }
        return 1;
    }

    if(dialogid == DIALOG_LES_MACHINIST)
    {
        if(!response) return 1;

        if(LesPlayer[playerid][les_Truck] != -1)
            return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} У вас уже есть рабочий грузовик.");

        LesPlayer[playerid][les_Truck] = CreateVehicle(LES_TRUCK_MODEL, les_truck_spawn[0], les_truck_spawn[1], les_truck_spawn[2], les_truck_spawn[3], random(255), random(255), 0);
        PutPlayerInVehicle(playerid, LesPlayer[playerid][les_Truck], 0);

        EnablePlayerGPS(playerid, 0, les_warehouse[0], les_warehouse[1], les_warehouse[2],
        "{2ECC71}[Лесоруб]{FFFFFF} Грузовик выдан — метка отмечена на GPS. Отвезите брёвна на склад.");
        SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Приятной дороги, машинист!");
        return 1;
    }

    #if defined lj_OnDialogResponse
        return lj_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse lj_OnDialogResponse
#if defined lj_OnDialogResponse
    forward lj_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// ==================================================================================
// Команда статистики (единственная команда во всей системе — сама рубка идёт без команд)
// ==================================================================================
// ДОБАВЛЕНО: команда запуска рубки — работает только если рядом есть дерево в радиусе зоны (4.0)
CMD:lesorub(playerid, params[])
{
    if(!LesPlayer[playerid][les_DataLoaded])
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Данные ещё загружаются, подождите пару секунд.");

    if(!LesPlayer[playerid][les_Hired])
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Сначала устройтесь на работу у Алёши.");

    if(!LesPlayer[playerid][les_Uniform])
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Сначала наденьте форму в раздевалке.");

    new nearest = -1; new Float:best = 9999.0;
    for(new i; i < 9; i++)
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, les_trees[i][0], les_trees[i][1], les_trees[i][2]);
        if(dist < best) { best = dist; nearest = i; }
    }

    if(nearest == -1 || best > 4.0)
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Рядом нет дерева — подойдите ближе.");

    TryChopTree(playerid, nearest);
    return 1;
}

// ДОБАВЛЕНО: админ-команда изменения уровня лесоруба (по аналогии с /setlvltc у дальнобойщика)
CMD:setlvles(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 10)
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Недостаточно прав администратора.");

    new id, lvl;
    if(sscanf(params, "dd", id, lvl))
        return SendClientMessage(playerid, -1, "Использование: /setlvles [id игрока] [уровень 1-5]");

    if(!IsPlayerConnected(id))
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Игрок не в сети.");

    if(lvl < 1 || lvl > 5)
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Уровень должен быть от 1 до 5.");

    LesPlayer[id][les_Level] = lvl;
    SavePlayerLesorubData(id);

    new string[144];
    format(string, sizeof string, "{2ECC71}[Лесоруб]{FFFFFF} Администратор изменил ваш уровень лесоруба на {FFAE00}%d{FFFFFF}.", lvl);
    SendClientMessage(id, -1, string);

    format(string, sizeof string, "{2ECC71}[Лесоруб]{FFFFFF} Вы изменили уровень лесоруба игроку %d на {FFAE00}%d{FFFFFF}.", id, lvl);
    SendClientMessage(playerid, -1, string);
    return 1;
}

CMD:lesorubinfo(playerid, params[])
{
    if(!LesPlayer[playerid][les_DataLoaded])
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Данные ещё загружаются, подождите пару секунд.");

    if(!LesPlayer[playerid][les_Hired])
        return SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Вы ещё не устроены лесорубом.");

    new string[400];
    format(string, sizeof string,
    "{FFFFFF}Уровень:{FFAE00} %d/5\n{FFFFFF}Срублено деревьев:{FFAE00} %d\n{FFFFFF}Заработано всего:{FFAE00} %d руб\n{FFFFFF}Брёвен на выгрузку машинисту:{FFAE00} %d\n{FFFFFF}Форма надета:{FFAE00} %s",
    LesPlayer[playerid][les_Level], LesPlayer[playerid][les_TreesChopped], LesPlayer[playerid][les_Earned], LesPlayer[playerid][les_Logs],
    LesPlayer[playerid][les_Uniform] ? ("Да") : ("Нет"));
    ShowPlayerDialog(playerid, DIALOG_LES_MACHINIST+1, DIALOG_STYLE_MSGBOX, "{2ECC71}Статистика лесоруба", string, "Закрыть", "");
    return 1;
}

// ==================================================================================
// Зоны: деревья, раздевалка, найм у Алёши, машинист
// ==================================================================================
public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i; i < 9; i++)
    {
        if(areaid == les_tree_area[i])
        {
            // ИЗМЕНЕНО: рубка теперь запускается только командой /lesorub, а не автоматически при входе в зону
            if(LesPlayer[playerid][les_Uniform] && GetTickCount() >= les_tree_cooldown[i])
                SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Дерево рядом — используйте {FFAE00}/lesorub{FFFFFF}, чтобы начать рубку.");
        }
    }

    if(areaid == les_npc_area2) // найм по заходу в зону
    {
        TryHireAtAlyosha(playerid);
    }

    if(areaid == les_changeroom_area)
    {
        if(!LesPlayer[playerid][les_Hired])
        {
            SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Сначала устройтесь на работу у Алёши.");
        }
        else
        {
            ShowPlayerDialog(playerid, DIALOG_LES_UNIFORM, DIALOG_STYLE_MSGBOX, "{2ECC71}Раздевалка лесоруба",
            LesPlayer[playerid][les_Uniform] ? ("Снять рабочую форму?") : ("Надеть рабочую форму и начать смену?"),
            LesPlayer[playerid][les_Uniform] ? ("Снять") : ("Надеть"), "Отмена");
        }
    }

    if(areaid == les_truck_area)
    {
        if(!LesPlayer[playerid][les_Hired] || LesPlayer[playerid][les_Level] < LES_MACHINIST_MIN_LEVEL)
        {
            new string[144];
            format(string, sizeof string, "{2ECC71}[Лесоруб]{FFFFFF} Работа машиниста доступна с {FFAE00}%d{FFFFFF} уровня лесоруба.", LES_MACHINIST_MIN_LEVEL);
            SendClientMessage(playerid, -1, string);
        }
        else if(!GetPlayerData(playerid, P_DRIVING_LIC))
        {
            SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Для работы машинистом нужны права на вождение.");
        }
        else if(LesPlayer[playerid][les_Logs] <= 0)
        {
            SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} У вас нет брёвен на доставку — сначала нарубите дров.");
        }
        else
        {
            ShowPlayerDialog(playerid, DIALOG_LES_MACHINIST, DIALOG_STYLE_MSGBOX, "{2ECC71}Работа машиниста",
            "Взять грузовик и отвезти брёвна на склад?", "Взять", "Отмена");
        }
    }

    if(areaid == les_warehouse_area && LesPlayer[playerid][les_Truck] != -1)
    {
        if(GetPlayerVehicleID(playerid) != LesPlayer[playerid][les_Truck])
        {
            SendClientMessage(playerid, -1, "{2ECC71}[Лесоруб]{FFFFFF} Вы должны находиться в рабочем грузовике.");
        }
        else
        {
            new logs = LesPlayer[playerid][les_Logs], bonus = 0;
            for(new i; i < logs; i++) bonus += LES_LOG_BONUS_MIN + random(LES_LOG_BONUS_RANGE);

            GivePlayerMoneyEx(playerid, bonus);
            LesPlayer[playerid][les_Earned] += bonus;
            LesPlayer[playerid][les_Logs] = 0;
            SavePlayerLesorubData(playerid);

            if(IsValidVehicle(LesPlayer[playerid][les_Truck])) DestroyVehicle(LesPlayer[playerid][les_Truck]);
            LesPlayer[playerid][les_Truck] = -1;
            DisablePlayerGPS(playerid);

            new string[144];
            format(string, sizeof string, "{2ECC71}[Лесоруб]{FFFFFF} Брёвна (%d шт) сданы на склад! Бонус машиниста: {FFAE00}%d{FFFFFF} руб.", logs, bonus);
            SendClientMessage(playerid, -1, string);
        }
    }

    #if defined lj_OnPlayerEnterDynamicArea
        return lj_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea lj_OnPlayerEnterDynamicArea
#if defined lj_OnPlayerEnterDynamicArea
    forward lj_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnGameModeInit()
{
    SetTimer("CREATE_TABLE_LESORUB", 2900, false);

    // ДОБАВЛЕНО: Алёша у раздевалки (ИСПРАВЛЕНО: раньше был обычный CreateActor — не показывался,
    // теперь ваш готовый CreateActorEx(имя, текст, скин, x,y,z,angle,world,interior), как в системе дальнобойщика)
    CreateActorEx("Алёша", "{828282}Лесорубщик — подойдите, чтобы устроиться", 25, les_npc_pos2[0], les_npc_pos2[1], les_npc_pos2[2], les_npc_pos2[3], 0, 0);
    les_npc_area2 = CreateDynamicSphere(les_npc_pos2[0], les_npc_pos2[1], les_npc_pos2[2], 3.0, 0, 0);

    les_changeroom_area = CreateDynamicSphere(les_changeroom[0], les_changeroom[1], les_changeroom[2], 2.5, 0, 0);
    Create3DTextLabel("{2ECC71}[Лесоруб]{FFFFFF}\nРаздевалка", -1, les_changeroom[0], les_changeroom[1], les_changeroom[2], 6.0, 0);
    CreateDynamicObject(LES_MARKER_OBJECT, les_changeroom[0], les_changeroom[1], les_changeroom[2]-1.0, 0.0, 0.0, 0.0); // ДОБАВЛЕНО: объект-маркер
    CreateDynamicPickup(1274, 23, les_changeroom[0], les_changeroom[1], les_changeroom[2], 0, 0); // ДОБАВЛЕНО: монетка-маркер, как у дальнобойщика

    les_truck_area = CreateDynamicSphere(les_truck_spawn[0], les_truck_spawn[1], les_truck_spawn[2], 3.0, 0, 0);
    Create3DTextLabel("{2ECC71}[Лесоруб]{FFFFFF}\nРабота машиниста (с 3 ур.)", -1, les_truck_spawn[0], les_truck_spawn[1], les_truck_spawn[2], 6.0, 0);
    CreateDynamicObject(LES_MARKER_OBJECT, les_truck_spawn[0], les_truck_spawn[1], les_truck_spawn[2]-1.0, 0.0, 0.0, 0.0); // ДОБАВЛЕНО: объект-маркер

    // ИЗМЕНЕНО: склад чуть сдвинут вперёд (+3 по Y), чтобы монетка и объект не оказались в стене/камне
    les_warehouse_area = CreateDynamicSphere(les_warehouse[0], les_warehouse[1], les_warehouse[2], 5.0, 0, 0);
    Create3DTextLabel("{2ECC71}[Лесоруб]{FFFFFF}\nСклад — сдать брёвна", -1, les_warehouse[0], les_warehouse[1], les_warehouse[2], 8.0, 0);
    CreateDynamicObject(LES_MARKER_OBJECT, les_warehouse[0], les_warehouse[1], les_warehouse[2]-1.0, 0.0, 0.0, 0.0); // ДОБАВЛЕНО: объект-маркер
    CreateDynamicPickup(1274, 23, les_warehouse[0], les_warehouse[1], les_warehouse[2], 0, 0); // ДОБАВЛЕНО: монетка-маркер, как у дальнобойщика

    for(new i; i < 9; i++)
    {
        les_tree_area[i] = CreateDynamicSphere(les_trees[i][0], les_trees[i][1], les_trees[i][2], 4.0, 0, 0); // ИЗМЕНЕНО: радиус увеличен 2.0 -> 4.0
        // ДОБАВЛЕНО: статус дерева виден издалека — зелёный "можно рубить" / серый "растёт"
        les_tree_label[i] = CreateDynamic3DTextLabel("{2ECC71}Можно рубить", -1, les_trees[i][0], les_trees[i][1], les_trees[i][2]+1.0, 15.0, _, _, _, 0, 0);
    }

    for(new i; i < MAX_PLAYERS; i++) LesPlayer[i][les_Truck] = -1;

    #if defined lj_OnGameModeInit
        return lj_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit lj_OnGameModeInit
#if defined lj_OnGameModeInit
    forward lj_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    LesPlayer[playerid][les_DataLoaded] = false;
    LesPlayer[playerid][les_Uniform] = false;
    LesPlayer[playerid][les_Chopping] = false;
    LesPlayer[playerid][les_Logs] = 0;
    LesPlayer[playerid][les_Truck] = -1;
    SetTimerEx("LoadPlayerLesorubData", 3000, false, "i", playerid);

    #if defined lj_OnPlayerConnect
        return lj_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect lj_OnPlayerConnect
#if defined lj_OnPlayerConnect
    forward lj_OnPlayerConnect(playerid);
#endif

// анти-чит: если рабочий грузовик уничтожен посреди доставки — брёвна теряются
public OnVehicleDeath(vehicleid, killerid)
{
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(vehicleid == LesPlayer[i][les_Truck])
        {
            LesPlayer[i][les_Truck] = -1;
            DisablePlayerGPS(i);
            SendClientMessage(i, -1, "{2ECC71}[Лесоруб]{FFFFFF} Рабочий грузовик уничтожен — брёвна утеряны.");
            LesPlayer[i][les_Logs] = 0;
            SavePlayerLesorubData(i);
        }
    }

    #if defined lj_OnVehicleDeath
        return lj_OnVehicleDeath(vehicleid, killerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnVehicleDeath
    #undef OnVehicleDeath
#else
    #define _ALS_OnVehicleDeath
#endif
#define OnVehicleDeath lj_OnVehicleDeath
#if defined lj_OnVehicleDeath
    forward lj_OnVehicleDeath(vehicleid, killerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(LesPlayer[playerid][les_Truck] != -1 && IsValidVehicle(LesPlayer[playerid][les_Truck])) DestroyVehicle(LesPlayer[playerid][les_Truck]);
    if(LesPlayer[playerid][les_Hired]) SavePlayerLesorubData(playerid);

    #if defined lj_OnPlayerDisconnect
        return lj_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect lj_OnPlayerDisconnect
#if defined lj_OnPlayerDisconnect
    forward lj_OnPlayerDisconnect(playerid, reason);
#endif
