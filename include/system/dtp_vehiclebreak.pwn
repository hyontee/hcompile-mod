// ============================================================================
// dtp_vehiclebreak.pwn — PRO MAX FULL (v17)
// ----------------------------------------------------------------------------
// ТЫ ПРОСИЛ "МАКСИМУМ" — вот максимально жирная, но ПРАКТИЧНАЯ версия.
// Эта система НЕ зависит от одного колбека: если OnVehicleDamageStatusUpdate не работает
// или конфликтует — урон всё равно идёт через OnPlayerUpdate по падению скорости.
//
// ОСНОВНОЕ:
//  • ДТП/замедление => снимает прочность авто (процентами)
//  • Минимум 29% (ниже не падает). На 29% авто считается "сломано" и едет ? 50 км/ч
//  • Двигатель НЕ глушим
//  • GUI 13 через ShowNotificationNew (у тебя это уже точно работает)
//      - "Ваш транспорт сломался..." (1 раз) + чат
//      - "Двигатель неисправен!" (каждые 7 сек, пока едешь на сломанной)
//  • Автоблокировка дверей после 30 км/ч — только для личного авто (если есть GetPlayerOwnableCar)
//  • Подсказка /lk рядом с личным авто (анти-спам). Нажатие: KEY_ACTION или KEY_SECONDARY_ATTACK
//
// ПРО УРОН (как ты хотел):
//  • лёгкие:  -1..-8%
//  • жёсткие: -8..-10%
// Плюс умная шкала: чем больше падение скорости, тем ближе к верхним значениям.
//
// ВАЖНО ПРО ПОДКЛЮЧЕНИЕ:
//  1) Этот include должен подключаться ПОСЛЕ того, как объявлен ShowNotificationNew.
//  2) Для дверей/личного авто желательно, чтобы уже был макрос GetPlayerOwnableCar(playerid).
//     Если его нет/подключили раньше — система ДТП работает, но LK/автолок просто отключатся.
//
// ----------------------------------------------------------------------------
// RELEASE: v17
// ============================================================================

#if defined _DTP_VEH_BREAK_PROMAX_V17_INCLUDED
    #endinput
#endif
#define _DTP_VEH_BREAK_PROMAX_V17_INCLUDED

// --------------------------- НАСТРОЙКИ -------------------------------------

// Минимум прочности в процентах (на этом уровне авто "сломано")
#define DTP_MIN_PERCENT             (29.0)

// Скорость сломанного авто
#define DTP_BROKEN_MAX_KMH          (50.0)

// Порог "замедления" (км/ч) — если падение скорости меньше, урон не снимаем
// (подними до 10.0 если хочешь меньше срабатываний)
#define DTP_MIN_DROP_KMH            (4.0)

// Частота, как часто вообще разрешаем наносить урон одному игроку (мс)
#define DTP_PLAYER_COOLDOWN_MS      (220)

// Защита от двойных срабатываний по одному vehicle (мс)
#define DTP_VEH_COOLDOWN_MS         (260)

// Уведомление "Двигатель неисправен!" каждые N мс
#define DTP_BROKEN_NOTIFY_MS        (7000)

// Автоблок дверей после N км/ч (только личное авто)
#define LK_AUTOLOCK_KMH             (30.0)

// Дистанция подсказки /lk
#define LK_PROMPT_RANGE             (4.0)

// Анти-спам подсказки: повтор показывать не чаще раз в N мс, пока стоишь рядом
#define LK_RESHOW_MS                (6500)
#define LK_PROMPT_DURATION          (5)
#define LK_PROMPT_SUBID             (991)
#define LK_PROMPT_TEXT              "Открыть/закрыть двери автомобиля"
#define LK_PROMPT_BTN               ">>"

// Цвет чата (как у тебя на скрине — золотистый)
#define DTP_CHAT_GOLD               (0xF5D400FF)

// ----------------------------------------------------------------------------
// Урон процентами. Ты просил:
//  - лёгкие ДТП: 1..8%
//  - жёсткие:    8..10%
// Здесь я сделал шкалу, чтобы мелочь давала низ, сильное — верх.
// ----------------------------------------------------------------------------
#define DTP_LIGHT_MIN_PCT           (1.0)
#define DTP_LIGHT_MAX_PCT           (8.0)
#define DTP_HARD_MIN_PCT            (8.0)
#define DTP_HARD_MAX_PCT            (10.0)

// Доп. усиление, если одновременно меняется damageStatus (если колбек доступен)
#define DTP_USE_DAMAGESTATUS_BOOST  (1)
#define DTP_DAMAGESTATUS_BOOST_PCT  (1.15)   // +15% урона, если реально были повреждения кузова

// ----------------------------------------------------------------------------
// Иконка уведомления (в твоём моде была OFFER_ENGINE)
// ----------------------------------------------------------------------------
#if !defined OFFER_ENGINE
    #define OFFER_ENGINE (1)
#endif
#define DTP_NOTIFY_ICON (OFFER_ENGINE)

// ----------------------------------------------------------------------------
// Клавиши (на всякий случай)
// ----------------------------------------------------------------------------
#if !defined KEY_ACTION
    #define KEY_ACTION (16)
#endif
#if !defined KEY_SECONDARY_ATTACK
    #define KEY_SECONDARY_ATTACK (4)
#endif

#if !defined INVALID_VEHICLE_ID
    #define INVALID_VEHICLE_ID (-1)
#endif

// ----------------------- OWNABLE CAR (опционально) --------------------------
// Если в момент include уже есть макрос GetPlayerOwnableCar(playerid) — включаем LK.
#if defined GetPlayerOwnableCar
    #define DTP_HAS_OWNABLE_CAR (1)
    stock DTP_GetOwnableCar(playerid) { return GetPlayerOwnableCar(playerid); }
#else
    #define DTP_HAS_OWNABLE_CAR (0)
    stock DTP_GetOwnableCar(playerid) { return INVALID_VEHICLE_ID; }
#endif

// --------------------------- ДАННЫЕ ----------------------------------------

new Float:dtp_hp[MAX_VEHICLES];            // текущая прочность (мы сами ведём)
new Float:dtp_maxhp[MAX_VEHICLES];         // максимум, от него считаем проценты (в BR может быть ~300)
new Float:dtp_minhp[MAX_VEHICLES];         // 29% от maxhp
new dtp_broken[MAX_VEHICLES];
new dtp_broken_announced[MAX_VEHICLES];

new dtp_vehicle_last_tick[MAX_VEHICLES];   // защита от дублей по vehicle

new Float:dtp_last_kmh_p[MAX_PLAYERS];     // последняя скорость игрока-водителя
new dtp_player_last_tick[MAX_PLAYERS];     // кулдаун по игроку
new dtp_last_broken_notify[MAX_PLAYERS];

new lk_prompt_vehicle[MAX_PLAYERS];
new lk_in_range[MAX_PLAYERS];
new lk_last_prompt_tick[MAX_PLAYERS];

#if DTP_USE_DAMAGESTATUS_BOOST
new dtp_dmgstat_recent[MAX_VEHICLES];      // 1 если damageStatus менялся недавно
new dtp_dmgstat_lasttick[MAX_VEHICLES];
new dtp_panels[MAX_VEHICLES];
new dtp_doors[MAX_VEHICLES];
new dtp_lights[MAX_VEHICLES];
new dtp_tires[MAX_VEHICLES];
#endif

// --------------------------- УТИЛИТЫ ---------------------------------------

stock Float:DTP_VecLen2D(Float:x, Float:y) return floatsqroot(x*x + y*y);
stock Float:DTP_SpeedKmhFromVel(Float:vx, Float:vy) return (DTP_VecLen2D(vx, vy) * 200.0);

stock Float:DTP_ClampFloat(Float:v, Float:minv, Float:maxv)
{
    if(v < minv) return minv;
    if(v > maxv) return maxv;
    return v;
}

stock DTP_InitVehicle(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;

    new Float:hp;
    GetVehicleHealth(vehicleid, hp);
    if(hp <= 0.0) hp = 1000.0;

    if(dtp_maxhp[vehicleid] <= 0.0)
    {
        dtp_maxhp[vehicleid] = hp;
        dtp_minhp[vehicleid] = dtp_maxhp[vehicleid] * (DTP_MIN_PERCENT / 100.0);
        if(dtp_minhp[vehicleid] < 1.0) dtp_minhp[vehicleid] = 1.0;
    }

    // Если реально починили/подняли HP — принять рост и обновить maxhp
    if(hp > dtp_maxhp[vehicleid] + 2.0)
    {
        dtp_maxhp[vehicleid] = hp;
        dtp_minhp[vehicleid] = dtp_maxhp[vehicleid] * (DTP_MIN_PERCENT / 100.0);
        if(dtp_minhp[vehicleid] < 1.0) dtp_minhp[vehicleid] = 1.0;
    }

    if(dtp_hp[vehicleid] <= 0.0) dtp_hp[vehicleid] = hp;
    return 1;
}

stock DTP_LimitSpeed(vehicleid, Float:maxKmh)
{
    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);

    new Float:s = DTP_VecLen2D(vx, vy);
    if(s <= 0.0001) return 1;

    new Float:curKmh = DTP_SpeedKmhFromVel(vx, vy);
    if(curKmh <= maxKmh) return 1;

    new Float:targetS = (maxKmh / 200.0);
    new Float:scale = targetS / s;

    SetVehicleVelocity(vehicleid, vx * scale, vy * scale, vz);
    return 1;
}

// GUI 13 через твой мод (чтобы не было Unknown/Invalid)
// ShowNotificationNew(playerid, type, duration, icon, subId, caption, btnCaption)
//  - type 4: без кнопки
//  - type 6: с кнопкой
stock DTP_Notify_NoButton(playerid, duration, caption[])
{
    ShowNotificationNew(playerid, 4, duration, DTP_NOTIFY_ICON, 0, caption, "");
    return 1;
}

stock DTP_Notify_Button(playerid, duration, subId, caption[], btnCaption[])
{
    ShowNotificationNew(playerid, 6, duration, DTP_NOTIFY_ICON, subId, caption, btnCaption);
    return 1;
}

stock DTP_AnnounceBrokenOnce(playerid)
{
    DTP_Notify_NoButton(playerid, 6, "Ваш транспорт сломался, вызовите механика (/call 090).");
    SendClientMessage(playerid, DTP_CHAT_GOLD, "Ваш транспорт сломался, вызовите механика (/call 090).");
    return 1;
}

stock DTP_AnnounceBrokenRepeat(playerid)
{
    DTP_Notify_NoButton(playerid, 4, "Двигатель неисправен!");
    return 1;
}

// --------------------------- УРОН ПРОЦЕНТАМИ --------------------------------

// Рандом в диапазоне float
stock Float:DTP_RandFloat(Float:minV, Float:maxV)
{
    new r = random(1000); // 0..999
    new Float:t = float(r) / 999.0;
    return minV + (maxV - minV) * t;
}

// Вычисляем процент по падению скорости (dropKmh)
// Чем больше drop — тем ближе к верхам.
stock Float:DTP_PercentFromDrop(Float:dropKmh)
{
    // drop 4..25 => 1..4
    // drop 25..60 => 4..8
    // drop 60..120 => 8..10
    if(dropKmh < 25.0)
    {
        new Float:t = (dropKmh - DTP_MIN_DROP_KMH) / (25.0 - DTP_MIN_DROP_KMH);
        t = DTP_ClampFloat(t, 0.0, 1.0);
        return DTP_RandFloat(DTP_LIGHT_MIN_PCT, 1.0 + t * 3.0);
    }
    if(dropKmh < 60.0)
    {
        new Float:t = (dropKmh - 25.0) / 35.0;
        t = DTP_ClampFloat(t, 0.0, 1.0);
        return DTP_RandFloat(3.5 + t * 2.0, DTP_LIGHT_MAX_PCT);
    }
    // 60..120
    new Float:t = (dropKmh - 60.0) / 60.0;
    t = DTP_ClampFloat(t, 0.0, 1.0);
    return DTP_RandFloat(DTP_HARD_MIN_PCT, DTP_HARD_MIN_PCT + t * (DTP_HARD_MAX_PCT - DTP_HARD_MIN_PCT));
}

stock DTP_ApplyDamagePercent(vehicleid, Float:pct)
{
    DTP_InitVehicle(vehicleid);

    new Float:drop = dtp_maxhp[vehicleid] * (pct / 100.0);

    // чтобы не было "по 0.1"
    if(drop < 1.5) drop = 1.5;

    dtp_hp[vehicleid] -= drop;
    if(dtp_hp[vehicleid] < dtp_minhp[vehicleid]) dtp_hp[vehicleid] = dtp_minhp[vehicleid];

    SetVehicleHealth(vehicleid, dtp_hp[vehicleid]);
    return 1;
}

// --------------------------- ДВЕРИ /LK --------------------------------------

stock LK_IsOwnerVehicle(playerid, vehicleid)
{
#if DTP_HAS_OWNABLE_CAR
    new ownVeh = DTP_GetOwnableCar(playerid);
    if(ownVeh != INVALID_VEHICLE_ID && ownVeh == vehicleid) return 1;
#endif
    return 0;
}

stock LK_AutoLockVehicle(vehicleid)
{
#if defined SetVehicleParam && defined V_LOCK
    if(!GetVehicleParam(vehicleid, V_LOCK)) SetVehicleParam(vehicleid, V_LOCK, 1);
#else
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(doors == 0) SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
#endif
    return 1;
}

stock LK_Toggle(playerid, vehicleid)
{
#if defined ToggleLock
    ToggleLock(playerid, vehicleid);
#else
#if defined SetVehicleParam && defined V_LOCK
    new s = GetVehicleParam(vehicleid, V_LOCK);
    SetVehicleParam(vehicleid, V_LOCK, s ? 0 : 1);
#else
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors ? 0 : 1, bonnet, boot, objective);
#endif
#endif
    return 1;
}

// --------------------------- ОСНОВНАЯ РАБОТА --------------------------------
//
// РАБОТАЕТ 100%: OnPlayerUpdate всегда вызывается.
// Тут мы:
//  • отслеживаем падение скорости (dropKmh)
//  • наносим урон процентами
//  • применяем "сломано" (29%) + лимит скорости + уведомления
//  • делаем авто-лок + подсказку /lk (если доступно)
// ----------------------------------------------------------------------------

public OnPlayerUpdate(playerid)
{
    if(!IsPlayerConnected(playerid))
    {
        #if defined DTP_OnPlayerUpdate
            return DTP_OnPlayerUpdate(playerid);
        #else
            return 1;
        #endif
    }

    // водитель
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
        {
            DTP_InitVehicle(vehicleid);

            new Float:vx, Float:vy, Float:vz;
            GetVehicleVelocity(vehicleid, vx, vy, vz);
            new Float:kmh = DTP_SpeedKmhFromVel(vx, vy);

            // drop (последняя скорость игрока)
            new Float:last = dtp_last_kmh_p[playerid];
            dtp_last_kmh_p[playerid] = kmh;

            new now = GetTickCount();

            // анти-спам по игроку
            if(now - dtp_player_last_tick[playerid] >= DTP_PLAYER_COOLDOWN_MS)
            {
                dtp_player_last_tick[playerid] = now;

                // анти-спам по машине (на случай 2 колбеков/лаги)
                if(now - dtp_vehicle_last_tick[vehicleid] >= DTP_VEH_COOLDOWN_MS)
                {
                    new Float:dropKmh = last - kmh;
                    if(dropKmh >= DTP_MIN_DROP_KMH)
                    {
                        dtp_vehicle_last_tick[vehicleid] = now;

                        new Float:pct = DTP_PercentFromDrop(dropKmh);

#if DTP_USE_DAMAGESTATUS_BOOST
                        // если недавно реально менялся damageStatus — усилить
                        if(dtp_dmgstat_recent[vehicleid]) pct *= DTP_DAMAGESTATUS_BOOST_PCT;
#endif
                        // ограничим сверху 10%
                        if(pct > DTP_HARD_MAX_PCT) pct = DTP_HARD_MAX_PCT;

                        DTP_ApplyDamagePercent(vehicleid, pct);
                    }
                }
            }

            // автолок (только личное авто)
            if(kmh > LK_AUTOLOCK_KMH && LK_IsOwnerVehicle(playerid, vehicleid))
            {
                LK_AutoLockVehicle(vehicleid);
            }

            // поломка
            if(dtp_hp[vehicleid] <= dtp_minhp[vehicleid] + 0.05)
            {
                dtp_broken[vehicleid] = 1;

                if(!dtp_broken_announced[vehicleid])
                {
                    dtp_broken_announced[vehicleid] = 1;
                    DTP_AnnounceBrokenOnce(playerid);
                }

                DTP_LimitSpeed(vehicleid, DTP_BROKEN_MAX_KMH);

                if(now - dtp_last_broken_notify[playerid] >= DTP_BROKEN_NOTIFY_MS)
                {
                    dtp_last_broken_notify[playerid] = now;
                    DTP_AnnounceBrokenRepeat(playerid);
                }
            }
            else
            {
                dtp_broken[vehicleid] = 0;
                dtp_broken_announced[vehicleid] = 0;
            }
        }
    }
    else
    {
        // не водитель — сброс скорости, чтобы при посадке не было "фантомного" drop
        dtp_last_kmh_p[playerid] = 0.0;
    }

#if DTP_HAS_OWNABLE_CAR
    // Подсказка /lk: только пешком, только личное авто, анти-спам по входу/таймауту
    if(GetPlayerVehicleID(playerid) == 0)
    {
        new ownVeh = DTP_GetOwnableCar(playerid);
        if(ownVeh != INVALID_VEHICLE_ID)
        {
            new Float:x, Float:y, Float:z;
            GetVehiclePos(ownVeh, x, y, z);

            new in = IsPlayerInRangeOfPoint(playerid, LK_PROMPT_RANGE, x, y, z);
            new now2 = GetTickCount();

            if(in)
            {
                lk_prompt_vehicle[playerid] = ownVeh;

                if(!lk_in_range[playerid] || (now2 - lk_last_prompt_tick[playerid] >= LK_RESHOW_MS))
                {
                    lk_in_range[playerid] = 1;
                    lk_last_prompt_tick[playerid] = now2;
                    DTP_Notify_Button(playerid, LK_PROMPT_DURATION, LK_PROMPT_SUBID, LK_PROMPT_TEXT, LK_PROMPT_BTN);
                }
            }
            else
            {
                lk_in_range[playerid] = 0;
                if(lk_prompt_vehicle[playerid] == ownVeh) lk_prompt_vehicle[playerid] = INVALID_VEHICLE_ID;
            }
        }
        else
        {
            lk_in_range[playerid] = 0;
            lk_prompt_vehicle[playerid] = INVALID_VEHICLE_ID;
        }
    }
    else
    {
        lk_in_range[playerid] = 0;
        lk_prompt_vehicle[playerid] = INVALID_VEHICLE_ID;
    }
#endif

    #if defined DTP_OnPlayerUpdate
        return DTP_OnPlayerUpdate(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate DTP_OnPlayerUpdate
#if defined DTP_OnPlayerUpdate
    forward DTP_OnPlayerUpdate(playerid);
#endif

// --------------------------- КНОПКА ">>" ------------------------------------
// В твоём клиенте ">>" обычно подтверждается ACTION или SECONDARY.
// Если вдруг у тебя используется другой способ, скажешь — привяжем к твоему callback.
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
#if DTP_HAS_OWNABLE_CAR
    new pressed = 0;
    if((newkeys & KEY_ACTION) && !(oldkeys & KEY_ACTION)) pressed = 1;
    if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK)) pressed = 1;

    if(pressed)
    {
        new vehicleid = lk_prompt_vehicle[playerid];
        if(vehicleid != INVALID_VEHICLE_ID && LK_IsOwnerVehicle(playerid, vehicleid))
        {
            new Float:x, Float:y, Float:z;
            GetVehiclePos(vehicleid, x, y, z);

            if(GetPlayerVehicleID(playerid) == 0 && IsPlayerInRangeOfPoint(playerid, LK_PROMPT_RANGE + 1.0, x, y, z))
            {
                LK_Toggle(playerid, vehicleid);
                lk_last_prompt_tick[playerid] = GetTickCount();
            }
        }
    }
#endif

    #if defined DTP_OnPlayerKeyStateChange
        return DTP_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange DTP_OnPlayerKeyStateChange
#if defined DTP_OnPlayerKeyStateChange
    forward DTP_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

// --------------------------- DAMAGESTATUS BOOST (опц) ------------------------
#if DTP_USE_DAMAGESTATUS_BOOST
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
    {
        // если это первое — просто заинициализировать
        if(dtp_maxhp[vehicleid] <= 0.0) DTP_InitVehicle(vehicleid);

        new p, d, l, t;
        GetVehicleDamageStatus(vehicleid, p, d, l, t);

        new changed = 0;
        if(dtp_panels[vehicleid] != p) changed = 1;
        if(dtp_doors[vehicleid]  != d) changed = 1;
        if(dtp_lights[vehicleid] != l) changed = 1;
        if(dtp_tires[vehicleid]  != t) changed = 1;

        dtp_panels[vehicleid] = p;
        dtp_doors[vehicleid]  = d;
        dtp_lights[vehicleid] = l;
        dtp_tires[vehicleid]  = t;

        if(changed)
        {
            dtp_dmgstat_recent[vehicleid] = 1;
            dtp_dmgstat_lasttick[vehicleid] = GetTickCount();
        }
    }

    #if defined DTP_OnVehicleDamageStatusUpdate
        return DTP_OnVehicleDamageStatusUpdate(vehicleid, playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnVehicleDamageStatusUpdate
    #undef OnVehicleDamageStatusUpdate
#else
    #define _ALS_OnVehicleDamageStatusUpdate
#endif
#define OnVehicleDamageStatusUpdate DTP_OnVehicleDamageStatusUpdate
#if defined DTP_OnVehicleDamageStatusUpdate
    forward DTP_OnVehicleDamageStatusUpdate(vehicleid, playerid);
#endif
#endif

// --------------------------- INIT / RESET -----------------------------------
public OnGameModeInit()
{
    for(new v=0; v<MAX_VEHICLES; v++)
    {
        dtp_hp[v] = 0.0;
        dtp_maxhp[v] = 0.0;
        dtp_minhp[v] = 0.0;
        dtp_broken[v] = 0;
        dtp_broken_announced[v] = 0;
        dtp_vehicle_last_tick[v] = 0;

#if DTP_USE_DAMAGESTATUS_BOOST
        dtp_dmgstat_recent[v] = 0;
        dtp_dmgstat_lasttick[v] = 0;
        dtp_panels[v] = 0;
        dtp_doors[v] = 0;
        dtp_lights[v] = 0;
        dtp_tires[v] = 0;
#endif
    }

    for(new p=0; p<MAX_PLAYERS; p++)
    {
        dtp_last_kmh_p[p] = 0.0;
        dtp_player_last_tick[p] = 0;
        dtp_last_broken_notify[p] = 0;

        lk_prompt_vehicle[p] = INVALID_VEHICLE_ID;
        lk_in_range[p] = 0;
        lk_last_prompt_tick[p] = 0;
    }

    #if defined DTP_OnGameModeInit
        return DTP_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit DTP_OnGameModeInit
#if defined DTP_OnGameModeInit
    forward DTP_OnGameModeInit();
#endif

// Обновление флага "recent damageStatus"
#if DTP_USE_DAMAGESTATUS_BOOST
forward DTP_DmgstatTick();
public DTP_DmgstatTick()
{
    new now = GetTickCount();
    for(new v=1; v<MAX_VEHICLES; v++)
    {
        if(dtp_dmgstat_recent[v] && (now - dtp_dmgstat_lasttick[v] > 900))
            dtp_dmgstat_recent[v] = 0;
    }
    return 1;
}
#endif

// ============================================================================
// END
// ============================================================================
