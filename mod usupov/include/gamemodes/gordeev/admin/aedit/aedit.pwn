#if defined _gordeev_aedit_included
    #endinput
#endif
#define _gordeev_aedit_included

#ifndef USE_ANIM_TYPE_NONE
    #define USE_ANIM_TYPE_NONE (0)
#endif

#ifndef SetPlayerData
    #define SetPlayerData(%0,%1,%2) g_player[%0][%1] = %2
#endif

#if !defined DIALOG_AEDIT_MAIN
    #define DIALOG_AEDIT_MAIN                  (29810)
    #define DIALOG_AEDIT_ENTITY_TYPE           (29811)
    #define DIALOG_AEDIT_BIZ_TYPE              (29812)
    #define DIALOG_AEDIT_HOUSE_TYPE            (29813)
    #define DIALOG_AEDIT_BIZ_LIST              (29814)
    #define DIALOG_AEDIT_HOUSE_LIST            (29815)
    #define DIALOG_AEDIT_BIZ_ACTION            (29816)
    #define DIALOG_AEDIT_HOUSE_ACTION          (29817)
    #define DIALOG_AEDIT_BIZ_TYPE_SET          (29818)
    #define DIALOG_AEDIT_HOUSE_TYPE_SET        (29819)
    #define DIALOG_AEDIT_BIZ_PRICE_INPUT       (29820)
    #define DIALOG_AEDIT_HOUSE_PRICE_INPUT     (29821)
    #define DIALOG_AEDIT_BIZ_DELETE_CONFIRM    (29822)
    #define DIALOG_AEDIT_HOUSE_DELETE_CONFIRM  (29823)
    #define DIALOG_AEDIT_ENTRANCE_LIST         (29824)
    #define DIALOG_AEDIT_ENTRANCE_ACTION       (29825)
    #define DIALOG_AEDIT_ENTRANCE_FLOORS_INPUT (29826)
    #define AEDIT_LIST_PAGE_SIZE               (25)
    #define AEDIT_LIST_PREV                    (-1)
    #define AEDIT_LIST_NEXT                    (-2)
    #define AEDIT_LIST_CREATE                  (-3)
#endif

forward AEdit_TeleportToBusiness(playerid, biz_id);
forward AEdit_TeleportToHouse(playerid, house_id);
forward AEdit_TeleportToEntrance(playerid, entrance_id);

CMD:aedit(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, 0x999999FF, "Команда доступна только администраторам 8+ уровня");

    return ShowAEditMainDialog(playerid);
}

stock AEdit_HandleDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_AEDIT_MAIN:
        {
            if(!response) return 1;

            new entity_type = GetPlayerListitemValue(playerid, listitem);
            switch(entity_type)
            {
                case 0: return ShowAEditBizTypeDialog(playerid);
                case 1: return ShowAEditHouseTypeDialog(playerid);
                case 2: return ShowAEditEntranceListDialog(playerid);
            }
            return ShowAEditMainDialog(playerid);
        }
        case DIALOG_AEDIT_BIZ_TYPE:
        {
            if(!response) return ShowAEditMainDialog(playerid);

            new biz_type = GetPlayerListitemValue(playerid, listitem);
            if(!AEdit_IsValidBusinessType(biz_type))
                return ShowAEditBizTypeDialog(playerid);

            return ShowAEditBizListDialog(playerid, biz_type, 0);
        }
        case DIALOG_AEDIT_HOUSE_TYPE:
        {
            if(!response) return ShowAEditMainDialog(playerid);

            new house_type = GetPlayerListitemValue(playerid, listitem);
            if(!(0 <= house_type < sizeof g_house_type))
                return ShowAEditHouseTypeDialog(playerid);

            return ShowAEditHouseListDialog(playerid, house_type, 0);
        }
        case DIALOG_AEDIT_BIZ_LIST:
        {
            if(!response) return ShowAEditBizTypeDialog(playerid);

            new biz_type = GetPVarInt(playerid, "aedit_biz_type");
            new page = GetPVarInt(playerid, "aedit_biz_page");
            new biz_id = GetPlayerListitemValue(playerid, listitem);

            if(biz_id == AEDIT_LIST_PREV)
                return ShowAEditBizListDialog(playerid, biz_type, page - 1);

            if(biz_id == AEDIT_LIST_NEXT)
                return ShowAEditBizListDialog(playerid, biz_type, page + 1);

            if(!(0 <= biz_id <= g_business_loaded - 1))
                return ShowAEditBizListDialog(playerid, biz_type, page);

            return ShowAEditBizActionDialog(playerid, biz_id);
        }
        case DIALOG_AEDIT_HOUSE_LIST:
        {
            if(!response) return ShowAEditHouseTypeDialog(playerid);

            new house_type = GetPVarInt(playerid, "aedit_house_type");
            new page = GetPVarInt(playerid, "aedit_house_page");
            new house_id = GetPlayerListitemValue(playerid, listitem);

            if(house_id == AEDIT_LIST_PREV)
                return ShowAEditHouseListDialog(playerid, house_type, page - 1);

            if(house_id == AEDIT_LIST_NEXT)
                return ShowAEditHouseListDialog(playerid, house_type, page + 1);

            if(!(0 <= house_id <= g_house_loaded - 1))
                return ShowAEditHouseListDialog(playerid, house_type, page);

            return ShowAEditHouseActionDialog(playerid, house_id);
        }
        case DIALOG_AEDIT_ENTRANCE_LIST:
        {
            if(!response) return ShowAEditMainDialog(playerid);

            new page = GetPVarInt(playerid, "aedit_entrance_page");
            new entrance_id = GetPlayerListitemValue(playerid, listitem);

            if(entrance_id == AEDIT_LIST_CREATE)
            {
                new created_id = AEdit_CreateEntrance(playerid);
                if(created_id == -1)
                    return ShowAEditEntranceListDialog(playerid, page);

                SendClientMessage(playerid, 0x3399FFFF, "Подъезд создан. В AEdit можно сразу настроить вход, выход и этажи.");
                return ShowAEditEntranceActionDialog(playerid, created_id);
            }

            if(entrance_id == AEDIT_LIST_PREV)
                return ShowAEditEntranceListDialog(playerid, page - 1);

            if(entrance_id == AEDIT_LIST_NEXT)
                return ShowAEditEntranceListDialog(playerid, page + 1);

            if(!(0 <= entrance_id <= g_entrance_loaded - 1))
                return ShowAEditEntranceListDialog(playerid, page);

            return ShowAEditEntranceActionDialog(playerid, entrance_id);
        }
        case DIALOG_AEDIT_ENTRANCE_ACTION:
        {
            new entrance_id = GetPVarInt(playerid, "aedit_entrance_id");
            if(!(0 <= entrance_id <= g_entrance_loaded - 1))
                return ShowAEditEntranceListDialog(playerid, GetPVarInt(playerid, "aedit_entrance_page"));

            if(!response)
                return ShowAEditEntranceListDialog(playerid, GetPVarInt(playerid, "aedit_entrance_page"));

            switch(listitem)
            {
                case 0:
                {
                    AEdit_MoveEntranceToPlayer(playerid, entrance_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы установили вход на позицию игрока.");
                    return ShowAEditEntranceActionDialog(playerid, entrance_id);
                }
                case 1:
                {
                    AEdit_SetEntranceExitToPlayer(playerid, entrance_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы установили выход на позицию игрока.");
                    return ShowAEditEntranceActionDialog(playerid, entrance_id);
                }
                case 2:
                {
                    return Dialog
                    (
                        playerid,
                        DIALOG_AEDIT_ENTRANCE_FLOORS_INPUT,
                        DIALOG_STYLE_INPUT,
                        "{3399FF}AEdit | Этажи подъезда",
                        "Введите количество этажей подъезда:",
                        "Сохранить",
                        "Назад"
                    );
                }
                case 3:
                {
                    AEdit_TeleportToEntrance(playerid, entrance_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы телепортировались к подъезду.");
                    return ShowAEditEntranceActionDialog(playerid, entrance_id);
                }
            }
            return 1;
        }
        case DIALOG_AEDIT_ENTRANCE_FLOORS_INPUT:
        {
            new entrance_id = GetPVarInt(playerid, "aedit_entrance_id");
            if(!(0 <= entrance_id <= g_entrance_loaded - 1))
                return ShowAEditEntranceListDialog(playerid, GetPVarInt(playerid, "aedit_entrance_page"));

            if(!response)
                return ShowAEditEntranceActionDialog(playerid, entrance_id);

            new new_floors;
            if(sscanf(inputtext, "d", new_floors) || !(1 <= new_floors <= MAX_ENTRANCE_FLOORS))
            {
                new message[96];
                format(message, sizeof message, "Введите число этажей от 1 до %d.", MAX_ENTRANCE_FLOORS);
                SendClientMessage(playerid, 0xFF6600FF, message);
                return Dialog(playerid, DIALOG_AEDIT_ENTRANCE_FLOORS_INPUT, DIALOG_STYLE_INPUT, "{3399FF}AEdit | Этажи подъезда", "Введите количество этажей подъезда:", "Сохранить", "Назад");
            }

            AEdit_SetEntranceFloors(entrance_id, new_floors);
            SendClientMessage(playerid, 0x66CC33FF, "Количество этажей подъезда успешно изменено.");
            return ShowAEditEntranceActionDialog(playerid, entrance_id);
        }
        case DIALOG_AEDIT_BIZ_ACTION:
        {
            new biz_id = GetPVarInt(playerid, "aedit_biz_id");
            if(!(0 <= biz_id <= g_business_loaded - 1))
                return ShowAEditBizTypeDialog(playerid);

            if(!response)
                return ShowAEditBizListDialog(playerid, GetPVarInt(playerid, "aedit_biz_type"));

            switch(listitem)
            {
                case 0:
                {
                    return Dialog
                    (
                        playerid,
                        DIALOG_AEDIT_BIZ_DELETE_CONFIRM,
                        DIALOG_STYLE_MSGBOX,
                        "{FF5533}AEdit | Удаление бизнеса",
                        "{FFFFFF}Вы уверены, что хотите удалить бизнес?\n\n{FF9900}Это действие нельзя будет отменить.",
                        "Удалить",
                        "Назад"
                    );
                }
                case 1:
                {
                    return ShowAEditBizTypeSetDialog(playerid);
                }
                case 2:
                {
                    return Dialog
                    (
                        playerid,
                        DIALOG_AEDIT_BIZ_PRICE_INPUT,
                        DIALOG_STYLE_INPUT,
                        "{FFCD00}AEdit | Цена бизнеса",
                        "Введите новую цену бизнеса (только число):",
                        "Сохранить",
                        "Назад"
                    );
                }
                case 3:
                {
                    new query[220];
                    new Float:angle;

                    GetPlayerPos(playerid, g_business[biz_id][B_POS_X], g_business[biz_id][B_POS_Y], g_business[biz_id][B_POS_Z]);
                    GetPlayerFacingAngle(playerid, angle);

                    SetBusinessData(biz_id, B_EXIT_POS_X, GetBusinessData(biz_id, B_POS_X) + 1.5 * floatsin(-angle, degrees));
                    SetBusinessData(biz_id, B_EXIT_POS_Y, GetBusinessData(biz_id, B_POS_Y) + 1.5 * floatcos(-angle, degrees));
                    SetBusinessData(biz_id, B_EXIT_POS_Z, GetBusinessData(biz_id, B_POS_Z));
                    SetBusinessData(biz_id, B_EXIT_ANGLE, angle + 180.0);

                    mysql_format
                    (
                        mysql,
                        query, sizeof query,
                        "UPDATE business SET x='%f',y='%f',z='%f',exit_x='%f',exit_y='%f',exit_z='%f',exit_angle='%f' WHERE id=%d",
                        GetBusinessData(biz_id, B_POS_X),
                        GetBusinessData(biz_id, B_POS_Y),
                        GetBusinessData(biz_id, B_POS_Z),
                        GetBusinessData(biz_id, B_EXIT_POS_X),
                        GetBusinessData(biz_id, B_EXIT_POS_Y),
                        GetBusinessData(biz_id, B_EXIT_POS_Z),
                        GetBusinessData(biz_id, B_EXIT_ANGLE),
                        GetBusinessData(biz_id, B_SQL_ID)
                    );
                    mysql_query(mysql, query, false);

                    if(IsValidDynamic3DTextLabel(GetBusinessData(biz_id, B_LABEL)))
                        DestroyDynamic3DTextLabel(GetBusinessData(biz_id, B_LABEL));

                    SetBusinessData(biz_id, B_LABEL, CreateDynamic3DTextLabel(GetBusinessData(biz_id, B_NAME), 0xFFFF00FF, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z) + 1.0, 6.50));

                    AEdit_RecreateBizEnterPickup(biz_id);
                    return ShowAEditBizActionDialog(playerid, biz_id);
                }
                case 4:
                {
                    AEdit_RecreateBizEnterPickup(biz_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы установили вход бизнеса на позицию игрока.");
                    return ShowAEditBizActionDialog(playerid, biz_id);
                }
                case 5:
                {
                    AEdit_TeleportToBusiness(playerid, biz_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы телепортировались к бизнесу.");
                    return ShowAEditBizActionDialog(playerid, biz_id);
                }
            }
            return 1;
        }
        case DIALOG_AEDIT_HOUSE_ACTION:
        {
            new house_id = GetPVarInt(playerid, "aedit_house_id");
            if(!(0 <= house_id <= g_house_loaded - 1))
                return ShowAEditHouseTypeDialog(playerid);

            if(!response)
                return ShowAEditHouseListDialog(playerid, GetPVarInt(playerid, "aedit_house_type"));

            switch(listitem)
            {
                case 0:
                {
                    return Dialog
                    (
                        playerid,
                        DIALOG_AEDIT_HOUSE_DELETE_CONFIRM,
                        DIALOG_STYLE_MSGBOX,
                        "{FF5533}AEdit | Удаление дома",
                        "{FFFFFF}Вы уверены, что хотите удалить дом?\n\n{FF9900}Это действие нельзя будет отменить.",
                        "Удалить",
                        "Назад"
                    );
                }
                case 1:
                {
                    return ShowAEditHouseTypeSetDialog(playerid);
                }
                case 2:
                {
                    return Dialog
                    (
                        playerid,
                        DIALOG_AEDIT_HOUSE_PRICE_INPUT,
                        DIALOG_STYLE_INPUT,
                        "{33AACC}AEdit | Цена дома",
                        "Введите новую цену дома (только число):",
                        "Сохранить",
                        "Назад"
                    );
                }
                case 3:
                {
                    new query[220];
                    new Float:angle;

                    GetPlayerPos(playerid, g_house[house_id][H_POS_X], g_house[house_id][H_POS_Y], g_house[house_id][H_POS_Z]);
                    GetPlayerFacingAngle(playerid, angle);

                    SetHouseData(house_id, H_EXIT_POS_X, GetHouseData(house_id, H_POS_X) + 1.5 * floatsin(-angle, degrees));
                    SetHouseData(house_id, H_EXIT_POS_Y, GetHouseData(house_id, H_POS_Y) + 1.5 * floatcos(-angle, degrees));
                    SetHouseData(house_id, H_EXIT_POS_Z, GetHouseData(house_id, H_POS_Z));
                    SetHouseData(house_id, H_EXIT_ANGLE, angle + 180.0);

                    mysql_format
                    (
                        mysql,
                        query, sizeof query,
                        "UPDATE houses SET x='%f',y='%f',z='%f',exit_x='%f',exit_y='%f',exit_z='%f',exit_angle='%f' WHERE id=%d",
                        GetHouseData(house_id, H_POS_X),
                        GetHouseData(house_id, H_POS_Y),
                        GetHouseData(house_id, H_POS_Z),
                        GetHouseData(house_id, H_EXIT_POS_X),
                        GetHouseData(house_id, H_EXIT_POS_Y),
                        GetHouseData(house_id, H_EXIT_POS_Z),
                        GetHouseData(house_id, H_EXIT_ANGLE),
                        GetHouseData(house_id, H_SQL_ID)
                    );
                    mysql_query(mysql, query, false);

                    UpdateHouse(house_id);
                    return ShowAEditHouseActionDialog(playerid, house_id);
                }
                case 4:
                {
                    AEdit_MoveEntranceToPlayer(playerid, house_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы установили вход дома на позицию игрока.");
                    return ShowAEditHouseActionDialog(playerid, house_id);
                }
                case 5:
                {
                    AEdit_SetEntranceExitToPlayer(playerid, house_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы установили выход дома на позицию игрока.");
                    return ShowAEditHouseActionDialog(playerid, house_id);
                }
                case 6:
                {
                    AEdit_TeleportToHouse(playerid, house_id);
                    SendClientMessage(playerid, 0x66CC33FF, "Вы телепортировались к дому.");
                    return ShowAEditHouseActionDialog(playerid, house_id);
                }
            }
            return 1;
        }
        case DIALOG_AEDIT_BIZ_TYPE_SET:
        {
            if(!response) return ShowAEditBizActionDialog(playerid, GetPVarInt(playerid, "aedit_biz_id"));

            new biz_id = GetPVarInt(playerid, "aedit_biz_id");
            if(!(0 <= biz_id <= g_business_loaded - 1))
                return ShowAEditBizTypeDialog(playerid);

            new new_type = GetPlayerListitemValue(playerid, listitem);
            if(!AEdit_IsValidBusinessType(new_type))
                return ShowAEditBizTypeSetDialog(playerid);

            SetBusinessData(biz_id, B_TYPE, new_type);
            SetBusinessData(biz_id, B_INTERIOR, (new_type == BUSINESS_TYPE_ACCESSORY_SHOP) ? BUSINESS_INTERIOR_CLOTHING_SHOP : (new_type - 1));

            if(GetBusinessData(biz_id, B_HEALTH_PICKUP))
            {
                DestroyPickup(GetBusinessData(biz_id, B_HEALTH_PICKUP));
                SetBusinessData(biz_id, B_HEALTH_PICKUP, 0);
            }

            BusinessHealthPickupInit(biz_id);

            new query[140];
            mysql_format
            (
                mysql,
                query, sizeof query,
                "UPDATE business SET type=%d,interior=%d WHERE id=%d",
                GetBusinessData(biz_id, B_TYPE),
                GetBusinessData(biz_id, B_INTERIOR),
                GetBusinessData(biz_id, B_SQL_ID)
            );
            mysql_query(mysql, query, false);

            CallLocalFunction("UpdateBusinessLabel", "i", biz_id);

            SendClientMessage(playerid, 0x66CC33FF, "Тип бизнеса успешно изменён.");
            return ShowAEditBizActionDialog(playerid, biz_id);
        }
        case DIALOG_AEDIT_HOUSE_TYPE_SET:
        {
            if(!response) return ShowAEditHouseActionDialog(playerid, GetPVarInt(playerid, "aedit_house_id"));

            new house_id = GetPVarInt(playerid, "aedit_house_id");
            if(!(0 <= house_id <= g_house_loaded - 1))
                return ShowAEditHouseTypeDialog(playerid);

            new new_type = GetPlayerListitemValue(playerid, listitem);
            if(!(0 <= new_type < sizeof g_house_type))
                return ShowAEditHouseTypeSetDialog(playerid);

            SetHouseData(house_id, H_TYPE, new_type);
            format(g_house[house_id][H_NAME], 20, "%s", GetHouseTypeInfo(new_type, HT_NAME));

            SetHouseData(house_id, H_STORE_X, GetHouseTypeInfo(new_type, HT_STORE_POS_X));
            SetHouseData(house_id, H_STORE_Y, GetHouseTypeInfo(new_type, HT_STORE_POS_Y));
            SetHouseData(house_id, H_STORE_Z, GetHouseTypeInfo(new_type, HT_STORE_POS_Z));

            if(GetHouseData(house_id, H_HEALTH_PICKUP))
            {
                DestroyPickup(GetHouseData(house_id, H_HEALTH_PICKUP));
                SetHouseData(house_id, H_HEALTH_PICKUP, 0);
            }

            if(GetHouseData(house_id, H_STORE_LABEL) != Text3D:-1)
            {
                if(IsValidDynamic3DTextLabel(GetHouseData(house_id, H_STORE_LABEL)))
                    DestroyDynamic3DTextLabel(GetHouseData(house_id, H_STORE_LABEL));

                SetHouseData(house_id, H_STORE_LABEL, Text3D:-1);
            }

            UpdateHouse(house_id);
            HouseHealthInit(house_id);
            HouseStoreInit(house_id);

            new query[210];
            mysql_format
            (
                mysql,
                query, sizeof query,
                "UPDATE houses SET type=%d,name='%e',store_x='%f',store_y='%f',store_z='%f' WHERE id=%d",
                GetHouseData(house_id, H_TYPE),
                GetHouseData(house_id, H_NAME),
                GetHouseData(house_id, H_STORE_X),
                GetHouseData(house_id, H_STORE_Y),
                GetHouseData(house_id, H_STORE_Z),
                GetHouseData(house_id, H_SQL_ID)
            );
            mysql_query(mysql, query, false);

            SendClientMessage(playerid, 0x66CC33FF, "Тип дома успешно изменён.");
            return ShowAEditHouseActionDialog(playerid, house_id);
        }
        case DIALOG_AEDIT_BIZ_PRICE_INPUT:
        {
            new biz_id = GetPVarInt(playerid, "aedit_biz_id");
            if(!(0 <= biz_id <= g_business_loaded - 1))
                return ShowAEditBizTypeDialog(playerid);

            if(!response)
                return ShowAEditBizActionDialog(playerid, biz_id);

            new new_price;
            if(sscanf(inputtext, "d", new_price) || new_price < 1)
            {
                SendClientMessage(playerid, 0xFF6600FF, "Введите корректную цену (не меньше 1 рубля).");
                return Dialog(playerid, DIALOG_AEDIT_BIZ_PRICE_INPUT, DIALOG_STYLE_INPUT, "{FFCD00}AEdit | Цена бизнеса", "Введите новую цену бизнеса (только число):", "Сохранить", "Назад");
            }

            SetBusinessData(biz_id, B_PRICE, new_price);

            new query[110];
            mysql_format(mysql, query, sizeof query, "UPDATE business SET price=%d WHERE id=%d", GetBusinessData(biz_id, B_PRICE), GetBusinessData(biz_id, B_SQL_ID));
            mysql_query(mysql, query, false);

            SendClientMessage(playerid, 0x66CC33FF, "Цена бизнеса успешно изменена.");
            return ShowAEditBizActionDialog(playerid, biz_id);
        }
        case DIALOG_AEDIT_HOUSE_PRICE_INPUT:
        {
            new house_id = GetPVarInt(playerid, "aedit_house_id");
            if(!(0 <= house_id <= g_house_loaded - 1))
                return ShowAEditHouseTypeDialog(playerid);

            if(!response)
                return ShowAEditHouseActionDialog(playerid, house_id);

            new new_price;
            if(sscanf(inputtext, "d", new_price) || new_price < 1)
            {
                SendClientMessage(playerid, 0xFF6600FF, "Введите корректную цену (не меньше 1 рубля).");
                return Dialog(playerid, DIALOG_AEDIT_HOUSE_PRICE_INPUT, DIALOG_STYLE_INPUT, "{33AACC}AEdit | Цена дома", "Введите новую цену дома (только число):", "Сохранить", "Назад");
            }

            SetHouseData(house_id, H_PRICE, new_price);

            new query[110];
            mysql_format(mysql, query, sizeof query, "UPDATE houses SET price=%d WHERE id=%d", GetHouseData(house_id, H_PRICE), GetHouseData(house_id, H_SQL_ID));
            mysql_query(mysql, query, false);

            SendClientMessage(playerid, 0x66CC33FF, "Цена дома успешно изменена.");
            return ShowAEditHouseActionDialog(playerid, house_id);
        }
        case DIALOG_AEDIT_BIZ_DELETE_CONFIRM:
        {
            if(!response) return ShowAEditBizTypeDialog(playerid);

            new biz_id = GetPVarInt(playerid, "aedit_biz_id");
            if(!(0 <= biz_id <= g_business_loaded - 1))
                return ShowAEditBizTypeDialog(playerid);

            AEdit_ResetBusiness(biz_id);
            return ShowAEditBizListDialog(playerid, GetPVarInt(playerid, "aedit_biz_type"));
        }
        case DIALOG_AEDIT_HOUSE_DELETE_CONFIRM:
        {
            if(!response) return ShowAEditHouseTypeDialog(playerid);

            new house_id = GetPVarInt(playerid, "aedit_house_id");
            if(!(0 <= house_id <= g_house_loaded - 1))
                return ShowAEditHouseTypeDialog(playerid);

            AEdit_ResetHouse(house_id);
            return ShowAEditHouseListDialog(playerid, GetPVarInt(playerid, "aedit_house_type"));
        }
    }

    return 0;
}

stock AEdit_IsValidBusinessType(type)
{
    return ((1 <= type <= 11) || type == BUSINESS_TYPE_ACCESSORY_SHOP);
}

stock AEdit_RecreateBizEnterPickup(businessid)
{
    for(new pickupid; pickupid < MAX_PICKUPS; pickupid ++)
    {
        if(!IsPickupExists(pickupid)) continue;
        if(GetPickupInfo(pickupid, P_ACTION_TYPE) != PICKUP_ACTION_TYPE_BIZ_ENTER) continue;
        if(GetPickupInfo(pickupid, P_ACTION_ID) != businessid) continue;

        DestroyPickup(pickupid);
    }

    CreatePickup
    (
        1318,
        23,
        GetBusinessData(businessid, B_POS_X),
        GetBusinessData(businessid, B_POS_Y),
        GetBusinessData(businessid, B_POS_Z),
        0,
        PICKUP_ACTION_TYPE_BIZ_ENTER,
        businessid
    );

    return 1;
}

stock AEdit_ResetBusiness(businessid)
{
    if(!(0 <= businessid <= g_business_loaded - 1))
        return 0;

    new query[256];
    new owner_id = GetBusinessData(businessid, B_OWNER_ID);
    new owner_player = GetPlayerIDBySqlID(owner_id);

    if(owner_id > 0)
    {
        if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
        {
            SetPlayerData(owner_player, P_BUSINESS, -1);

            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `business`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
            mysql_query(mysql, query, false);
        }
        else
        {
            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `business`=-1 WHERE `id`=%d LIMIT 1", owner_id);
            mysql_query(mysql, query, false);
        }
    }

    SetBusinessData(businessid, B_OWNER_ID, 0);
    SetBusinessData(businessid, B_IMPROVEMENTS, 0);
    SetBusinessData(businessid, B_EVICTION, 0);
    SetBusinessData(businessid, B_PRODS, 0);
    SetBusinessData(businessid, B_PROD_PRICE, 0);
    SetBusinessData(businessid, B_BALANCE, 0);
    SetBusinessData(businessid, B_RENT_DATE, 0);
    SetBusinessData(businessid, B_ENTER_MUSIC, 0);
    SetBusinessData(businessid, B_ENTER_PRICE, 0);
    SetBusinessData(businessid, B_LOCK_STATUS, false);
    format(g_business[businessid][B_OWNER_NAME], 21, "None");

    if(GetBusinessData(businessid, B_HEALTH_PICKUP))
    {
        DestroyPickup(GetBusinessData(businessid, B_HEALTH_PICKUP));
        SetBusinessData(businessid, B_HEALTH_PICKUP, 0);
    }

    mysql_format
    (
        mysql,
        query, sizeof query,
        "UPDATE business SET owner_id=0,improvements=0,products=0,prod_price=0,balance=0,rent_time=0,enter_music=0,enter_price=0,`lock`=0,eviction=0 WHERE id=%d LIMIT 1",
        GetBusinessData(businessid, B_SQL_ID)
    );
    mysql_query(mysql, query, false);

    mysql_format(mysql, query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", businessid);
    mysql_query(mysql, query, false);

    g_business_gps_init = false;

    BusinessHealthPickupInit(businessid);
    CallLocalFunction("UpdateBusinessLabel", "i", businessid);

    return 1;
}

stock AEdit_ResetHouse(houseid)
{
    if(!(0 <= houseid <= g_house_loaded - 1))
        return 0;

    new query[256];
    new owner_id = GetHouseData(houseid, H_OWNER_ID);
    new owner_player = GetPlayerIDBySqlID(owner_id);

    CallLocalFunction("EvictHouseRentersAll", "i", houseid);

    if(owner_id > 0)
    {
        if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
        {
            SetPlayerData(owner_player, P_HOUSE, -1);
            SetPlayerData(owner_player, P_HOUSE_ROOM, -1);
            SetPlayerData(owner_player, P_HOUSE_TYPE, HOUSE_TYPE_NONE);

            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
            mysql_query(mysql, query, false);
        }
        else
        {
            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", owner_id);
            mysql_query(mysql, query, false);
        }
    }

    SetHouseData(houseid, H_OWNER_ID, 0);
    SetHouseData(houseid, H_IMPROVEMENTS, 0);
    SetHouseData(houseid, H_EVICTION, 0);
    SetHouseData(houseid, H_RENT_DATE, 0);
    SetHouseData(houseid, H_LOCK_STATUS, false);
    format(g_house[houseid][H_OWNER_NAME], 21, "None");

    mysql_format
    (
        mysql,
        query, sizeof query,
        "UPDATE houses SET owner_id=0,improvements=0,rent_time=0,`lock`=0,eviction=0 WHERE id=%d LIMIT 1",
        GetHouseData(houseid, H_SQL_ID)
    );
    mysql_query(mysql, query, false);

    UpdateHouse(houseid);
    HouseHealthInit(houseid);
    HouseStoreInit(houseid);

    return 1;
}

stock AEdit_RecreateEntranceObjects(entranceid)
{
    if(!(0 <= entranceid <= g_entrance_loaded - 1))
        return 0;

    SetEntranceData(entranceid, E_STATUS, -1);
    EntranceStatusInit(entranceid);

    if(IsValidDynamic3DTextLabel(GetEntranceData(entranceid, E_LABEL)))
        DestroyDynamic3DTextLabel(GetEntranceData(entranceid, E_LABEL));

    new label_text[85];
    format(label_text, sizeof label_text, "- Подъезд -\n{FFFFFF}Номер подъезда: %d", entranceid + 1);
    SetEntranceData(entranceid, E_LABEL, CreateDynamic3DTextLabel(label_text, 0x3399FFFF, GetEntranceData(entranceid, E_POS_X), GetEntranceData(entranceid, E_POS_Y), GetEntranceData(entranceid, E_POS_Z) + 1.0, 15.0));

    return 1;
}

stock AEdit_CreateEntrance(playerid)
{
    if(g_entrance_loaded >= MAX_ENTRANCES)
    {
        SendClientMessage(playerid, 0xFF6600FF, "Достигнут лимит подъездов на сервере");
        return -1;
    }

    new idx = g_entrance_loaded;
    new query[512];
    new Float:angle;
    new Cache:result;

    GetPlayerPos(playerid, g_entrance[idx][E_POS_X], g_entrance[idx][E_POS_Y], g_entrance[idx][E_POS_Z]);
    GetPlayerFacingAngle(playerid, angle);

    SetEntranceData(idx, E_FLOORS, 2);
    SetEntranceData(idx, E_EXIT_POS_X, GetEntranceData(idx, E_POS_X));
    SetEntranceData(idx, E_EXIT_POS_Y, GetEntranceData(idx, E_POS_Y));
    SetEntranceData(idx, E_EXIT_POS_Z, GetEntranceData(idx, E_POS_Z));
    SetEntranceData(idx, E_EXIT_ANGLE, angle);
    SetEntranceData(idx, E_PICKUP_ID, 0);
    SetEntranceData(idx, E_MAP_ICON, -1);
    SetEntranceData(idx, E_LABEL, Text3D:-1);
    SetEntranceData(idx, E_STATUS, -1);
    g_entrance_flats_loaded[idx] = 0;

    for(new floor; floor < MAX_ENTRANCE_FLOORS; floor ++)
    {
        for(new flat; flat < 4; flat ++)
        {
            g_entrance_flat[idx][floor][flat] = -1;
        }
    }

    mysql_format
    (
        mysql,
        query, sizeof query,
        "INSERT INTO entrances (floors, pos_x, pos_y, pos_z, exit_x, exit_y, exit_z, exit_angle) VALUES ('%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f')",
        GetEntranceData(idx, E_FLOORS),
        GetEntranceData(idx, E_POS_X),
        GetEntranceData(idx, E_POS_Y),
        GetEntranceData(idx, E_POS_Z),
        GetEntranceData(idx, E_EXIT_POS_X),
        GetEntranceData(idx, E_EXIT_POS_Y),
        GetEntranceData(idx, E_EXIT_POS_Z),
        GetEntranceData(idx, E_EXIT_ANGLE)
    );

    result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[AEDIT_ENTRANCE] SQL ERROR: %d", mysql_errno());
        printf("[AEDIT_ENTRANCE] QUERY: %s", query);
        cache_delete(result);
        SendClientMessage(playerid, 0xFF6600FF, "Ошибка БД при создании подъезда");
        return -1;
    }

    SetEntranceData(idx, E_SQL_ID, cache_insert_id());
    cache_delete(result);

    if(GetEntranceData(idx, E_SQL_ID) <= 0)
    {
        SendClientMessage(playerid, 0xFF6600FF, "Ошибка: подъезд не получил ID в базе данных");
        return -1;
    }

    g_entrance_loaded ++;
    AEdit_RecreateEntranceObjects(idx);

    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
    GetCityName(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), city);
    GetAreaName(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), area);
    format(query, sizeof query, "[A] %s[%d] создал подъезд №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, city, area);
    SendMessageToAdmins(query, 0x66CC33FF);

    return idx;
}

stock AEdit_MoveEntranceToPlayer(playerid, entranceid)
{
    new query[220];

    GetPlayerPos(playerid, g_entrance[entranceid][E_POS_X], g_entrance[entranceid][E_POS_Y], g_entrance[entranceid][E_POS_Z]);

    mysql_format
    (
        mysql,
        query, sizeof query,
        "UPDATE entrances SET pos_x='%f',pos_y='%f',pos_z='%f' WHERE id=%d",
        GetEntranceData(entranceid, E_POS_X),
        GetEntranceData(entranceid, E_POS_Y),
        GetEntranceData(entranceid, E_POS_Z),
        GetEntranceData(entranceid, E_SQL_ID)
    );
    mysql_query(mysql, query, false);

    AEdit_RecreateEntranceObjects(entranceid);
    return 1;
}

stock AEdit_SetEntranceExitToPlayer(playerid, entranceid)
{
    new query[220];

    GetPlayerPos(playerid, g_entrance[entranceid][E_EXIT_POS_X], g_entrance[entranceid][E_EXIT_POS_Y], g_entrance[entranceid][E_EXIT_POS_Z]);
    GetPlayerFacingAngle(playerid, g_entrance[entranceid][E_EXIT_ANGLE]);

    mysql_format
    (
        mysql,
        query, sizeof query,
        "UPDATE entrances SET exit_x='%f',exit_y='%f',exit_z='%f',exit_angle='%f' WHERE id=%d",
        GetEntranceData(entranceid, E_EXIT_POS_X),
        GetEntranceData(entranceid, E_EXIT_POS_Y),
        GetEntranceData(entranceid, E_EXIT_POS_Z),
        GetEntranceData(entranceid, E_EXIT_ANGLE),
        GetEntranceData(entranceid, E_SQL_ID)
    );
    mysql_query(mysql, query, false);

    return 1;
}

stock AEdit_SetEntranceFloors(entranceid, floors)
{
    new query[100];

    SetEntranceData(entranceid, E_FLOORS, floors);
    mysql_format(mysql, query, sizeof query, "UPDATE entrances SET floors=%d WHERE id=%d", GetEntranceData(entranceid, E_FLOORS), GetEntranceData(entranceid, E_SQL_ID));
    mysql_query(mysql, query, false);

    AEdit_RecreateEntranceObjects(entranceid);
    return 1;
}

stock AEdit_TeleportToBusiness(playerid, biz_id)
{
    if(!(0 <= biz_id <= g_business_loaded - 1)) return 0;
    SetPlayerPosEx(playerid, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z) + 1.0, 0.0, 0, 0, false);
    return 1;
}

stock AEdit_TeleportToHouse(playerid, house_id)
{
    if(!(0 <= house_id <= g_house_loaded - 1)) return 0;
    SetPlayerPosEx(playerid, GetHouseData(house_id, H_POS_X), GetHouseData(house_id, H_POS_Y), GetHouseData(house_id, H_POS_Z) + 1.0, 0.0, 0, 0, false);
    return 1;
}

stock AEdit_TeleportToEntrance(playerid, entrance_id)
{
    if(!(0 <= entrance_id <= g_entrance_loaded - 1)) return 0;
    SetPlayerPosEx(playerid, GetEntranceData(entrance_id, E_POS_X), GetEntranceData(entrance_id, E_POS_Y), GetEntranceData(entrance_id, E_POS_Z) + 1.0, 0.0, 0, 0, false);
    return 1;
}

stock ShowAEditMainDialog(playerid)
{
    ClearPlayerListitemValues(playerid);
    SetPlayerListitemValue(playerid, 0, 0);
    SetPlayerListitemValue(playerid, 1, 1);
    SetPlayerListitemValue(playerid, 2, 2);

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_MAIN,
        DIALOG_STYLE_LIST,
        "{FF5A46}AEdit {FFFFFF}| Редактор имущества",
        "{FFFFFF}Бизнесы\nДома\nПодъезды",
        "Выбрать",
        "Закрыть"
    );
}

stock ShowAEditBizTypeDialog(playerid)
{
    new biz_types[] =
    {
        BUSINESS_TYPE_SHOP_24_7,
        BUSINESS_TYPE_CLUB,
        BUSINESS_TYPE_REALTOR_BIZ,
        BUSINESS_TYPE_REALTOR_HOME,
        BUSINESS_TYPE_CLOTHING_SHOP,
        BUSINESS_TYPE_HOTEL,
        BUSINESS_TYPE_CAR_MARKET,
        BUSINESS_TYPE_CASINO,
        BUSINESS_TYPE_CELL_SALON,
        BUSINESS_TYPE_CAR_TUNING,
        BUSINESS_TYPE_SHOP_GUN,
        BUSINESS_TYPE_ACCESSORY_SHOP
    };

    new fmt_text[1800] = "ID\tТип бизнеса\tКол-во\n{FFFFFF}";
    new string[128];
    new type_name[32];

    for(new row; row < sizeof biz_types; row ++)
    {
        new type = biz_types[row];
        new count;

        for(new idx; idx < g_business_loaded; idx ++)
        {
            if(GetBusinessData(idx, B_TYPE) == type)
                count ++;
        }

        GetBusinessTypeName(type, type_name, sizeof type_name);
        format(string, sizeof string, "%d\t%s\t%d\n", type, type_name, count);
        strcat(fmt_text, string);

        SetPlayerListitemValue(playerid, row, type);
    }

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_BIZ_TYPE,
        DIALOG_STYLE_TABLIST_HEADERS,
        "{FF5A46}AEdit {FFFFFF}| Тип бизнеса",
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditHouseTypeDialog(playerid)
{
    new fmt_text[900] = "ID\tТип дома\tКол-во\n{FFFFFF}";
    new string[96];

    for(new type; type < sizeof g_house_type; type ++)
    {
        new count;

        for(new idx; idx < g_house_loaded; idx ++)
        {
            if(GetHouseData(idx, H_TYPE) == type)
                count ++;
        }

        format(string, sizeof string, "%d\t%s\t%d\n", type, GetHouseTypeInfo(type, HT_NAME), count);
        strcat(fmt_text, string);

        SetPlayerListitemValue(playerid, type, type);
    }

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_HOUSE_TYPE,
        DIALOG_STYLE_TABLIST_HEADERS,
        "{33AACC}AEdit {FFFFFF}| Тип дома",
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditBizListDialog(playerid, biz_type, page = 0)
{
    new total;
    for(new idx; idx < g_business_loaded; idx ++)
    {
        if(GetBusinessData(idx, B_TYPE) == biz_type)
            total ++;
    }

    if(!total)
    {
        SendClientMessage(playerid, 0xCECECEFF, "В выбранном типе нет бизнесов");
        return ShowAEditBizTypeDialog(playerid);
    }

    new pages = (total + AEDIT_LIST_PAGE_SIZE - 1) / AEDIT_LIST_PAGE_SIZE;
    if(page < 0) page = 0;
    if(page >= pages) page = pages - 1;

    ClearPlayerListitemValues(playerid);

    new fmt_text[2400] = "ID\tНазвание\tЦена\n{FFFFFF}";
    new string[128];
    new biz_title[64];
    new type_name[32];
    new row;
    new skipped;
    new start = page * AEDIT_LIST_PAGE_SIZE;

    if(page > 0)
    {
        format(string, sizeof string, "<<\tПредыдущая страница\t%d/%d\n", page, pages);
        strcat(fmt_text, string);
        SetPlayerListitemValue(playerid, row, AEDIT_LIST_PREV);
        row ++;
    }

    for(new idx; idx < g_business_loaded; idx ++)
    {
        if(GetBusinessData(idx, B_TYPE) != biz_type) continue;

        if(skipped < start)
        {
            skipped ++;
            continue;
        }

        if(row >= AEDIT_LIST_PAGE_SIZE + (page > 0 ? 1 : 0)) break;

        if(strlen(GetBusinessData(idx, B_NAME)) > 0)
            format(biz_title, sizeof biz_title, "%s", GetBusinessData(idx, B_NAME));
        else
        {
            GetBusinessTypeName(GetBusinessData(idx, B_TYPE), type_name, sizeof type_name);
            format(biz_title, sizeof biz_title, "%s", type_name);
        }

        format(string, sizeof string, "%d\t%s\t%d\n", idx, biz_title, GetBusinessData(idx, B_PRICE));
        strcat(fmt_text, string);

        SetPlayerListitemValue(playerid, row, idx);
        row ++;
        skipped ++;
    }

    if(page < pages - 1)
    {
        format(string, sizeof string, ">>\tСледующая страница\t%d/%d\n", page + 2, pages);
        strcat(fmt_text, string);
        SetPlayerListitemValue(playerid, row, AEDIT_LIST_NEXT);
    }

    SetPVarInt(playerid, "aedit_biz_type", biz_type);
    SetPVarInt(playerid, "aedit_biz_page", page);

    new title[64];
    format(title, sizeof title, "{FF5A46}AEdit {FFFFFF}| Бизнесы %d/%d", page + 1, pages);

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_BIZ_LIST,
        DIALOG_STYLE_TABLIST_HEADERS,
        title,
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditHouseListDialog(playerid, house_type, page = 0)
{
    new total;
    for(new idx; idx < g_house_loaded; idx ++)
    {
        if(GetHouseData(idx, H_TYPE) == house_type)
            total ++;
    }

    if(!total)
    {
        SendClientMessage(playerid, 0xCECECEFF, "В выбранном типе нет домов");
        return ShowAEditHouseTypeDialog(playerid);
    }

    new pages = (total + AEDIT_LIST_PAGE_SIZE - 1) / AEDIT_LIST_PAGE_SIZE;
    if(page < 0) page = 0;
    if(page >= pages) page = pages - 1;

    ClearPlayerListitemValues(playerid);

    new fmt_text[2400] = "ID\tНазвание\tЦена\n{FFFFFF}";
    new string[128];
    new house_title[48];
    new row;
    new skipped;
    new start = page * AEDIT_LIST_PAGE_SIZE;

    if(page > 0)
    {
        format(string, sizeof string, "<<\tПредыдущая страница\t%d/%d\n", page, pages);
        strcat(fmt_text, string);
        SetPlayerListitemValue(playerid, row, AEDIT_LIST_PREV);
        row ++;
    }

    for(new idx; idx < g_house_loaded; idx ++)
    {
        if(GetHouseData(idx, H_TYPE) != house_type) continue;

        if(skipped < start)
        {
            skipped ++;
            continue;
        }

        if(row >= AEDIT_LIST_PAGE_SIZE + (page > 0 ? 1 : 0)) break;

        if(strlen(GetHouseData(idx, H_NAME)) > 0)
            format(house_title, sizeof house_title, "%s", GetHouseData(idx, H_NAME));
        else
            format(house_title, sizeof house_title, "%s", GetHouseTypeInfo(GetHouseData(idx, H_TYPE), HT_NAME));

        format(string, sizeof string, "%d\t%s\t%d\n", idx, house_title, GetHouseData(idx, H_PRICE));
        strcat(fmt_text, string);

        SetPlayerListitemValue(playerid, row, idx);
        row ++;
        skipped ++;
    }

    if(page < pages - 1)
    {
        format(string, sizeof string, ">>\tСледующая страница\t%d/%d\n", page + 2, pages);
        strcat(fmt_text, string);
        SetPlayerListitemValue(playerid, row, AEDIT_LIST_NEXT);
    }

    SetPVarInt(playerid, "aedit_house_type", house_type);
    SetPVarInt(playerid, "aedit_house_page", page);

    new title[64];
    format(title, sizeof title, "{33AACC}AEdit {FFFFFF}| Дома %d/%d", page + 1, pages);

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_HOUSE_LIST,
        DIALOG_STYLE_TABLIST_HEADERS,
        title,
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditEntranceListDialog(playerid, page = 0)
{
    new total = g_entrance_loaded;
    new per_page = AEDIT_LIST_PAGE_SIZE - 1;
    new pages = (total + per_page - 1) / per_page;
    if(pages < 1) pages = 1;
    if(page < 0) page = 0;
    if(page >= pages) page = pages - 1;

    ClearPlayerListitemValues(playerid);

    new fmt_text[3000] = "ID\tЭтажи\tЛокация\n{FFFFFF}";
    new string[160];
    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
    new row;
    new start = page * per_page;

    format(string, sizeof string, "+\tСоздать подъезд\tНа вашей позиции\n");
    strcat(fmt_text, string);
    SetPlayerListitemValue(playerid, row, AEDIT_LIST_CREATE);
    row ++;

    if(page > 0)
    {
        format(string, sizeof string, "<<\tПредыдущая страница\t%d/%d\n", page, pages);
        strcat(fmt_text, string);
        SetPlayerListitemValue(playerid, row, AEDIT_LIST_PREV);
        row ++;
    }

    for(new idx = start, listed; idx < total && listed < per_page; idx ++, listed ++)
    {
        GetCityName(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), city);
        GetAreaName(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), area);

        format(string, sizeof string, "%d\t%d\t%s / %s\n", idx, GetEntranceData(idx, E_FLOORS), city, area);
        strcat(fmt_text, string);

        SetPlayerListitemValue(playerid, row, idx);
        row ++;
    }

    if(page < pages - 1)
    {
        format(string, sizeof string, ">>\tСледующая страница\t%d/%d\n", page + 2, pages);
        strcat(fmt_text, string);
        SetPlayerListitemValue(playerid, row, AEDIT_LIST_NEXT);
    }

    SetPVarInt(playerid, "aedit_entrance_page", page);

    new title[64];
    format(title, sizeof title, "{3399FF}AEdit {FFFFFF}| Подъезды %d/%d", page + 1, pages);

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_ENTRANCE_LIST,
        DIALOG_STYLE_TABLIST_HEADERS,
        title,
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditEntranceActionDialog(playerid, entranceid)
{
    if(!(0 <= entranceid <= g_entrance_loaded - 1))
        return 0;

    SetPVarInt(playerid, "aedit_entrance_id", entranceid);

    new title[64];
    new fmt_text[768];

    format(title, sizeof title, "{3399FF}AEdit {FFFFFF}| Подъезд #%d", entranceid);
    format
    (
        fmt_text, sizeof fmt_text,
        "№\tДействие\tОписание\n"\
        "{FFFFFF}1\tУстановить вход\tНа позиции текущего игрока\n"\
        "2\tУстановить выход\tНа позиции текущего игрока\n"\
        "3\tУстановить этажи\tКоличество этажей: %d\n"\
        "4\tТелепортироваться\tТелепорт к подъезду",
        GetEntranceData(entranceid, E_FLOORS)
    );

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_ENTRANCE_ACTION,
        DIALOG_STYLE_TABLIST_HEADERS,
        title,
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditBizActionDialog(playerid, biz_id)
{
    if(!(0 <= biz_id <= g_business_loaded - 1))
        return 0;

    SetPVarInt(playerid, "aedit_biz_id", biz_id);

    new type_name[32];
    new title[64];
    new fmt_text[768];

    GetBusinessTypeName(GetBusinessData(biz_id, B_TYPE), type_name, sizeof type_name);

    format(title, sizeof title, "{FF5A46}AEdit {FFFFFF}| Бизнес #%d", biz_id);
    format
    (
        fmt_text, sizeof fmt_text,
        "№\tДействие\tОписание\n"\
        "{FFFFFF}1\tУдалить бизнес\tВ 1клик удаление\n"\
        "2\tИзменить тип\tТип: %s\n"\
        "3\tИзменить цену\tЦена: %d рублей\n"\
        "4\tУстановить вход\tНа позиции текущего игрока\n"\
        "5\tУстановить выход\tНа позиции текущего игрока\n"\
        "6\tТелепортироваться\tТелепорт к бизнесу",
        type_name,
        GetBusinessData(biz_id, B_PRICE)
    );

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_BIZ_ACTION,
        DIALOG_STYLE_TABLIST_HEADERS,
        title,
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditHouseActionDialog(playerid, house_id)
{
    if(!(0 <= house_id <= g_house_loaded - 1))
        return 0;

    SetPVarInt(playerid, "aedit_house_id", house_id);

    new title[64];
    new fmt_text[768];

    format(title, sizeof title, "{33AACC}AEdit {FFFFFF}| Дом #%d", house_id);
    format
    (
        fmt_text, sizeof fmt_text,
        "№\tДействие\tОписание\n"\
        "{FFFFFF}1\tУдалить дом\tВ 1клик удаление\n"\
        "2\tИзменить тип\tТип: %s\n"\
        "3\tИзменить цену\tЦена: %d рублей\n"\
        "4\tУстановить вход\tНа позиции текущего игрока\n"\
        "5\tУстановить выход\tНа позиции текущего игрока\n"\
        "6\tТелепортироваться\tТелепорт к дому",
        GetHouseTypeInfo(GetHouseData(house_id, H_TYPE), HT_NAME),
        GetHouseData(house_id, H_PRICE)
    );

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_HOUSE_ACTION,
        DIALOG_STYLE_TABLIST_HEADERS,
        title,
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditBizTypeSetDialog(playerid)
{
    new biz_id = GetPVarInt(playerid, "aedit_biz_id");
    if(!(0 <= biz_id <= g_business_loaded - 1))
        return 0;

    new biz_types[] =
    {
        BUSINESS_TYPE_SHOP_24_7,
        BUSINESS_TYPE_CLUB,
        BUSINESS_TYPE_REALTOR_BIZ,
        BUSINESS_TYPE_REALTOR_HOME,
        BUSINESS_TYPE_CLOTHING_SHOP,
        BUSINESS_TYPE_HOTEL,
        BUSINESS_TYPE_CAR_MARKET,
        BUSINESS_TYPE_CASINO,
        BUSINESS_TYPE_CELL_SALON,
        BUSINESS_TYPE_CAR_TUNING,
        BUSINESS_TYPE_SHOP_GUN,
        BUSINESS_TYPE_ACCESSORY_SHOP
    };

    new fmt_text[1300] = "ID\tТип бизнеса\n{FFFFFF}";
    new string[96];
    new type_name[32];

    for(new row; row < sizeof biz_types; row ++)
    {
        new type = biz_types[row];
        GetBusinessTypeName(type, type_name, sizeof type_name);

        format(string, sizeof string, "%d\t%s\n", type, type_name);
        strcat(fmt_text, string);

        SetPlayerListitemValue(playerid, row, type);
    }

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_BIZ_TYPE_SET,
        DIALOG_STYLE_TABLIST_HEADERS,
        "{FF5A46}AEdit {FFFFFF}| Новый тип бизнеса",
        fmt_text,
        "Выбрать",
        "Назад"
    );
}

stock ShowAEditHouseTypeSetDialog(playerid)
{
    new house_id = GetPVarInt(playerid, "aedit_house_id");
    if(!(0 <= house_id <= g_house_loaded - 1))
        return 0;

    new fmt_text[800] = "ID\tТип дома\n{FFFFFF}";
    new string[96];

    for(new type; type < sizeof g_house_type; type ++)
    {
        format(string, sizeof string, "%d\t%s\n", type, GetHouseTypeInfo(type, HT_NAME));
        strcat(fmt_text, string);

        SetPlayerListitemValue(playerid, type, type);
    }

    return Dialog
    (
        playerid,
        DIALOG_AEDIT_HOUSE_TYPE_SET,
        DIALOG_STYLE_TABLIST_HEADERS,
        "{33AACC}AEdit {FFFFFF}| Новый тип дома",
        fmt_text,
        "Выбрать",
        "Назад"
    );
}
