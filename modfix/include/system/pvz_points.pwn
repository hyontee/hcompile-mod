#if defined _PVZ_POINTS_INCLUDED
    #endinput
#endif
#define _PVZ_POINTS_INCLUDED

// =====================================================================
// ПВЗ (пункты выдачи заказов) — точки, где игрок забирает товары,
// купленные на маркетплейсе. Все покупки уходят в reward-очередь
// (см. Marketplace_ConfirmBuy в marketplace.pwn) и забираются здесь
// через MPReward_OpenGUI.
// =====================================================================

enum E_PICKUP_POINT
{
    pp_name[64],
    Float:pp_enter_x, Float:pp_enter_y, Float:pp_enter_z, pp_enter_vw,
    Float:pp_exit_x, Float:pp_exit_y, Float:pp_exit_z, pp_exit_vw, pp_exit_int,
    Float:pp_inside_x, Float:pp_inside_y, Float:pp_inside_z,  // координаты выхода внутри
    pp_enter_pickup,
    pp_exit_pickup
}

new PickupPoints[][E_PICKUP_POINT] =
{
    {"Батырево", 1803.149047, 2037.017944, 16.008436, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Арзамас", 292.996765, 1541.501220, 12.156729, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Арзамас", 614.631835, 579.856567, 12.188437, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Южный", 2566.409179, -2516.000488, 22.119831, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Южный", 2386.718017, -1708.890747, 22.084220, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Бусаево", -528.563598, -1788.569946, 41.065799, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Лыткарино", -2265.864746, -322.510284, 28.101448, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Нижегородск", -2457.938476, 1134.409301, 10.855109, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1},
    {"Нижегородск", -1824.447631, 2717.559814, 57.766563, 0, 2283.669921, 1836.158691, 1519.743286, 1, 1, 2282.679199, 1836.778442, 1519.743286, -1, -1}
};

// Отдельный пикап получения товара (reward). Общий на всех, т.к. все ПВЗ
// физически ведут в один и тот же интерьер/виртуальный мир (см. pp_exit_vw/pp_exit_int).
#define PVZ_REWARD_X (2287.283691)
#define PVZ_REWARD_Y (1834.868408)
#define PVZ_REWARD_Z (1519.743286)
#define PVZ_REWARD_VW (1)

new bool:g_PvzPointsCreated = false;
new g_PvzRewardPickup = -1;

// Создание пикапов (вызывается из основного OnGameModeInit в lonexs.pwn)
stock CreatePickupPoints()
{
    if(g_PvzPointsCreated) return 1;

    for(new i = 0; i < sizeof(PickupPoints); i++)
    {
        // Пикап входа (стоит на улице у каждого города)
        PickupPoints[i][pp_enter_pickup] = CreatePickup(19132, 23,
            PickupPoints[i][pp_enter_x],
            PickupPoints[i][pp_enter_y],
            PickupPoints[i][pp_enter_z],
            PickupPoints[i][pp_enter_vw]);

        // Пикап выхода внутри здания ПВЗ (возвращает игрока обратно на улицу)
        PickupPoints[i][pp_exit_pickup] = CreatePickup(19132, 23,
            PickupPoints[i][pp_inside_x],
            PickupPoints[i][pp_inside_y],
            PickupPoints[i][pp_inside_z],
            PickupPoints[i][pp_exit_vw]);
    }

    // Отдельный пикап получения товара (reward) — только открывает reward gui,
    // никуда не телепортирует.
    g_PvzRewardPickup = CreatePickup(19135, 23, PVZ_REWARD_X, PVZ_REWARD_Y, PVZ_REWARD_Z, PVZ_REWARD_VW);

    // Табличка над пикапом получения товара (виден в любом случае, даже если
    // модель пикапа не отрисовалась).
    Create3DTextLabel("{2299ee}ПВЗ\n{ffffff}Получение покупок Marketplace", -1,
        PVZ_REWARD_X, PVZ_REWARD_Y, PVZ_REWARD_Z + 0.7,
        20.0, 0, 1);

    g_PvzPointsCreated = true;
    return 1;
}

// Обработка входа/выхода в ПВЗ и получения товара.
// Вызывается из OnPlayerPickUpPickupEx в lonexs.pwn.
// Возвращает 1, если пикап был обработан как ПВЗ (чтобы прервать дальнейшую обработку).
stock HandlePickupPoint(playerid, pickupid)
{
    // Пикап получения товара (reward)
    if(pickupid == g_PvzRewardPickup)
    {
        if(!IsPlayerLogged(playerid)) return 1;

        MPReward_OpenGUI(playerid, 1);
        return 1;
    }

    // Проверка на вход
    for(new i = 0; i < sizeof(PickupPoints); i++)
    {
        if(pickupid == PickupPoints[i][pp_enter_pickup])
        {
            if(!IsPlayerLogged(playerid)) return 1;

            // Телепортируем внутрь ПВЗ
            SetPlayerPos(playerid,
                PickupPoints[i][pp_exit_x],
                PickupPoints[i][pp_exit_y],
                PickupPoints[i][pp_exit_z]);
            SetPlayerInterior(playerid, PickupPoints[i][pp_exit_int]);
            SetPlayerVirtualWorld(playerid, PickupPoints[i][pp_exit_vw]);

            SetPVarInt(playerid, "in_pickup_point", i);

            new msg[128];
            format(msg, sizeof(msg), "{33aa33}| {ffffff}Вы вошли в ПВЗ \"%s\".", PickupPoints[i][pp_name]);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
    }

    // Проверка на выход
    for(new i = 0; i < sizeof(PickupPoints); i++)
    {
        if(pickupid == PickupPoints[i][pp_exit_pickup])
        {
            // Телепортируем наружу
            SetPlayerPos(playerid,
                PickupPoints[i][pp_enter_x],
                PickupPoints[i][pp_enter_y],
                PickupPoints[i][pp_enter_z]);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, PickupPoints[i][pp_enter_vw]);
            DeletePVar(playerid, "in_pickup_point");

            new msg[128];
            format(msg, sizeof(msg), "{33aa33}| {ffffff}Вы вышли из ПВЗ \"%s\".", PickupPoints[i][pp_name]);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
    }

    return 0;
}
