// Auto-synced from http://api.blackrussia.online/client/donate-items.json (type 11)
#if defined _DONATE_ACCESSORIES_INC
#endinput
#endif
#define _DONATE_ACCESSORIES_INC

// internalId, gameId pairs (flat Ч Pawn 3.2 не переваривает большой static const[][2])
#define DONATE_ACC_MAP_PAIRS_A (64)
#define DONATE_ACC_MAP_PAIRS_B (61)

new g_donate_accessory_map_a[DONATE_ACC_MAP_PAIRS_A * 2] = {
    241, 136, 242, 137, 243, 138, 244, 139, 245, 140, 246, 141, 247, 142, 248, 145,
    249, 151, 250, 153, 251, 152, 252, 154, 253, 160, 254, 143, 255, 144, 256, 155,
    258, 149, 259, 146, 260, 147, 261, 148, 263, 156, 264, 157, 265, 158, 266, 159,
    267, 150, 274, 161, 277, 170, 278, 169, 279, 180, 280, 187, 281, 200, 282, 201,
    283, 210, 284, 216, 285, 220, 286, 221, 287, 263, 288, 264, 289, 265, 290, 281,
    291, 287, 292, 289, 293, 290, 294, 291, 295, 295, 296, 296, 297, 297, 298, 301,
    299, 302, 300, 303, 301, 304, 302, 308, 303, 309, 304, 313, 305, 316, 306, 321,
    307, 322, 308, 323, 309, 324, 310, 326, 354, 347, 355, 348, 356, 349, 357, 350
};

new g_donate_accessory_map_b[DONATE_ACC_MAP_PAIRS_B * 2] = {
    358, 351, 359, 352, 360, 353, 361, 354, 362, 355, 363, 356, 364, 357, 365, 358,
    368, 359, 369, 360, 370, 361, 371, 362, 372, 363, 373, 364, 374, 365, 375, 366,
    376, 367, 377, 368, 378, 369, 379, 370, 380, 371, 381, 372, 382, 373, 383, 374,
    384, 375, 385, 376, 386, 377, 387, 378, 388, 379, 389, 380, 422, 508, 423, 511,
    432, 513, 433, 515, 434, 516, 435, 536, 436, 520, 437, 521, 438, 522, 439, 527,
    440, 531, 441, 532, 442, 533, 443, 534, 464, 578, 476, 579, 477, 582, 478, 583,
    479, 585, 493, 660, 494, 662, 495, 663, 496, 664, 518, 709, 530, 914, 531, 915,
    532, 916, 533, 917, 534, 918, 542, 542, 549, 549
};

// type 3 accessory packs: internalId only (items from contains[] at purchase)
new g_donate_accessory_pack_ids[16] = {
    179, 181, 183, 185, 187, 189, 191, 193, 262, 268, 269, 270, 271, 272, 273, 541
};

stock Donate_FindAccessoryItemIdInMap(const map[], pairs, internal_id)
{
    for(new i = 0; i < pairs; i++)
    {
        new idx = i * 2;
        if(map[idx] == internal_id)
            return map[idx + 1];
    }
    return -1;
}

stock Donate_FindAccessoryItemId(internal_id)
{
    new item_id = Donate_FindAccessoryItemIdInMap(g_donate_accessory_map_a, DONATE_ACC_MAP_PAIRS_A, internal_id);
    if(item_id != -1) return item_id;
    return Donate_FindAccessoryItemIdInMap(g_donate_accessory_map_b, DONATE_ACC_MAP_PAIRS_B, internal_id);
}

stock bool:IsDonateAccessoryInternal(internal_id)
{
    return (Donate_FindAccessoryItemId(internal_id) != -1);
}

stock bool:IsDonateAccessoryPackInternal(internal_id)
{
    for(new i = 0; i < sizeof(g_donate_accessory_pack_ids); i++)
    {
        if(g_donate_accessory_pack_ids[i] == internal_id) return true;
    }
    return false;
}

// 1 = успех, 0 = нет места в инвентаре, -1 = неизвестный пак
stock Donate_GiveAccessoryPack(playerid, internal_id)
{
    switch(internal_id)
    {
        case 541:
        {
            new pack_items[] = {508, 539, 540, 136, 122};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 179:
        {
            new pack_items[] = {12, 122, 180};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 181:
        {
            new pack_items[] = {22, 122, 182};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 183:
        {
            new pack_items[] = {23, 122, 184};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 185:
        {
            new pack_items[] = {28, 122, 186};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 268:
        {
            new pack_items[] = {228, 258, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 269:
        {
            new pack_items[] = {227, 241, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 187:
        {
            new pack_items[] = {78, 122, 188};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 189:
        {
            new pack_items[] = {34, 122, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 270:
        {
            new pack_items[] = {229, 267, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 271:
        {
            new pack_items[] = {229, 248, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 272:
        {
            new pack_items[] = {231, 248, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 273:
        {
            new pack_items[] = {230, 255, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 191:
        {
            new pack_items[] = {52, 122, 192};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 193:
        {
            new pack_items[] = {64, 122, 194};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
        case 262:
        {
            new pack_items[] = {237, 241, 190};
            for(new pi = 0; pi < sizeof(pack_items); pi++)
            {
                if(!GivePlayerItem(playerid, pack_items[pi], 1)) return 0;
            }
            return 1;
        }
    }
    return -1;
}
