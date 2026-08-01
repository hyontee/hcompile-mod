#if defined _sander_marketplace_reward_included
    #endinput
#endif
#define _sander_marketplace_reward_included

#define MARKETPLACE_REWARD_CASE_ID       (100)

stock MPReward_CreateTables()
{
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `marketplace_reward_items` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `item_id` INT NOT NULL, `item_count` INT NOT NULL DEFAULT 1, `item_plate` VARCHAR(32) NOT NULL DEFAULT '', `item_name` VARCHAR(64) NOT NULL DEFAULT '', `source_lot` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `account_id` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251");
    return 1;
}

stock MPReward_QueueInvItem(account_id, item_id, item_count, const item_plate[], const item_name[], source_lot = 0)
{
    if(account_id <= 0 || item_id <= 0) return 0;
    if(item_count <= 0) item_count = 1;

    MPReward_CreateTables();

    new query[768];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `marketplace_reward_items` (`account_id`,`item_id`,`item_count`,`item_plate`,`item_name`,`source_lot`,`created_at`) VALUES (%d,%d,%d,'%e','%e',%d,%d)",
        account_id, item_id, item_count, item_plate, item_name, source_lot, gettime());

    new Cache:insert_cache = mysql_query(mysql, query, true);
    new reward_item_id = cache_insert_id();
    cache_delete(insert_cache);

    if(reward_item_id <= 0) return 0;

    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `rewards` (`uid`,`award_id`,`case_id`) VALUES (%d,%d,%d)",
        account_id, reward_item_id, MARKETPLACE_REWARD_CASE_ID);
    mysql_tquery(mysql, query);
    return reward_item_id;
}

stock MPReward_GetInvItemData(reward_item_id, &item_id, &item_count, item_plate[], plate_len, item_name[], name_len)
{
    if(reward_item_id <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "SELECT `item_id`,`item_count`,`item_plate`,`item_name` FROM `marketplace_reward_items` WHERE `id`=%d LIMIT 1",
        reward_item_id);

    new Cache:result = mysql_query(mysql, query, true);
    if(!cache_num_rows())
    {
        cache_delete(result);
        return 0;
    }

    item_id = cache_get_field_content_int(0, "item_id");
    item_count = cache_get_field_content_int(0, "item_count");
    cache_get_field_content(0, "item_plate", item_plate, mysql, plate_len);
    cache_get_field_content(0, "item_name", item_name, mysql, name_len);
    cache_delete(result);

    if(item_count <= 0) item_count = 1;
    if(item_name[0] == EOS) GetItemName(item_id, item_name, name_len);
    return 1;
}

stock MPReward_DelInvItemData(reward_item_id)
{
    if(reward_item_id <= 0) return 0;
    new query[128];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM `marketplace_reward_items` WHERE `id`=%d LIMIT 1", reward_item_id);
    mysql_tquery(mysql, query);
    return 1;
}

stock bool:MPReward_GetCaseAwardData(award_index, &award_type, &internal_id, &award_count, award_name[], name_size, &spray_price)
{
    new plate[32];
    if(!MPReward_GetInvItemData(award_index, internal_id, award_count, plate, sizeof(plate), award_name, name_size)) return false;

    award_type = 11;
    spray_price = 0;
    return true;
}

stock MPReward_GiveToPlayer(playerid, reward_item_id)
{
    new item_id, item_count, item_plate[32], item_name[64];
    if(!MPReward_GetInvItemData(reward_item_id, item_id, item_count, item_plate, sizeof(item_plate), item_name, sizeof(item_name))) return 0;

    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1)
    {
        ShowNotification(playerid, 2, "\xcd\xe5\xf2 \xf1\xe2\xee\xe1\xee\xe4\xed\xee\xe3\xee \xec\xe5\xf1\xf2\xe0 \xe2 \xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xe5. \xcf\xf0\xe5\xe4\xec\xe5\xf2 \xee\xf1\xf2\xe0\xeb\xf1\xff \xe2 /reward.", 4, "", "");
        return 0;
    }

    if(!Inventory_AddItem(playerid, item_id, freeSlot, item_count, item_plate))
    {
        ShowNotification(playerid, 2, "\xcd\xe5 \xf3\xe4\xe0\xeb\xee\xf1\xfc \xe4\xee\xe1\xe0\xe2\xe8\xf2\xfc \xef\xf0\xe5\xe4\xec\xe5\xf2 \xec\xe0\xf0\xea\xe5\xf2\xef\xeb\xe5\xe9\xf1\xe0 \xe2 \xe8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc.", 4, "", "");
        return 0;
    }

    MPReward_DelInvItemData(reward_item_id);
    new text[144];
    format(text, sizeof(text), "Marketplace: item received: %s x%d.", item_name, item_count);
    ShowNotification(playerid, 1, text, 5, "", ">>");
    return 1;
}
