// ../server/bprewards_gui.pwn
#if defined _INC_BPREWARDS_GUI
    #endinput
#endif
#define _INC_BPREWARDS_GUI

#if !defined JSON_Parse
    #include "json.inc"
#endif

#define GUI_BPREWARDS (74)

// incoming/outgoing keys
#define BPR_KEY_T           "t"
#define BPR_KEY_CLOSE       "c"
#define BPR_KEY_LIST        "pr"
#define BPR_KEY_ALARMS      "fl"
#define BPR_KEY_ID          "id"
#define BPR_KEY_NAME        "n"
#define BPR_KEY_TYPE        "td"
#define BPR_KEY_ALARM       "st"
#define BPR_KEY_IMAGE_ID    "el"
#define BPR_KEY_SKIN_MODEL  "c"
#define BPR_KEY_DAYS        "ds"
#define BPR_KEY_SPRAY       "sp"
#define BPR_KEY_PLATE       "els"
#define BPR_KEY_RARITY      "r"
#define BPR_KEY_COUNT       "ct"
#define BPR_KEY_TANPIN      "tn"
#define BPR_KEY_CLICK_TYPE  "s"

// filters (BpRewardsFilterStateEnum)
#define BPR_FILTER_ALL          (1)
#define BPR_FILTER_SKINS        (2)
#define BPR_FILTER_VIP          (3)
#define BPR_FILTER_ACCESSORIES  (4)
#define BPR_FILTER_CARS         (5)
#define BPR_FILTER_CURRENCIES   (6)
#define BPR_FILTER_OTHER        (7)
#define BPR_FILTER_MIN          (1)
#define BPR_FILTER_MAX          (7)
#define BPR_FILTER_COUNT        (7)

// prize types (BpRewardsKeys)
#define BPR_TYPE_CASES      (4)
#define BPR_TYPE_CAR        (5)
#define BPR_TYPE_VIP        (9)
#define BPR_TYPE_INVENTORY  (11)

// special image ids (BpRewardsKeys)
#define BPR_PLATE_RU    (59)
#define BPR_PLATE_UA    (81)
#define BPR_PLATE_BY    (82)
#define BPR_PLATE_KZ    (83)
#define BPR_SKIN_EL     (134)

#define BPR_PAGE_SIZE (12)

#define MAX_BPR_ITEMS           (512)
#define MAX_BPR_ITEM_NAME       (128)
#define MAX_BPR_PLATE_TEXT      (4)
#define MAX_BPR_PLATE_TEXT_LEN  (16)

#define MAX_BPR_AWARD_TYPES         (64)
#define MAX_BPR_AWARD_NAME          (128)
#define MAX_BPR_AWARD_IMAGES        (16)
#define MAX_BPR_AWARD_IMAGE_NAME    (48)

#define BPR_JSON_BUF_SIZE   (16384)

enum E_BPR_AWARD_TYPE
{
    bpr_award_id,
    bpr_award_name[MAX_BPR_AWARD_NAME],
    bpr_award_image_count
};

enum E_BPR_ITEM
{
    bpr_item_id,
    bpr_item_type,
    bpr_item_alarm,
    bpr_item_id_for_images,
    bpr_item_skin_model_id,
    bpr_item_days_left,
    bpr_item_spray_price,
    bpr_item_rarity,
    bpr_item_quantity,
    bpr_item_plate_text_count,
    bpr_item_name[MAX_BPR_ITEM_NAME]
};

new g_BpAwards[MAX_BPR_AWARD_TYPES][E_BPR_AWARD_TYPE];
new g_BpAwardsCount;
new g_BpAwardImages[MAX_BPR_AWARD_TYPES][MAX_BPR_AWARD_IMAGES][MAX_BPR_AWARD_IMAGE_NAME];

new g_BpRewards[MAX_BPR_ITEMS][E_BPR_ITEM];
new g_BpRewardsCount;
new g_BpRewardsNextId = 1;
new g_BpRewardPlateText[MAX_BPR_ITEMS][MAX_BPR_PLATE_TEXT][MAX_BPR_PLATE_TEXT_LEN];


new g_PlayerBpRewards[MAX_PLAYERS][100][E_BPR_ITEM];
new g_PlayerBpRewardsCount[MAX_PLAYERS];
new g_BpRewardsJsonBuf[BPR_JSON_BUF_SIZE];
new g_BpRewardsItemsBuf[BPR_JSON_BUF_SIZE];
new g_BpRewardsAlarmsBuf[512];
static const g_BpHexChars[] = "0123456789ABCDEF";
static const g_BpAwardsDefaultId[] =
{
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
};

static const g_BpAwardsDefaultName[][] =
{
    "            ",
    "              ",
    "Black Coins",
    "    ",
    "         ",
    "     ",
    "               ",
    "X2      ",
    "VIP",
    "           ",
    "                   ",
    "    ",
    "        ",
    "               ",
    "                           ",
    "            ",
    "                 ",
    "E-Points",
    "Donate Coupon",
    "      ",
    "    ",
    "                 ",
    "                  ",
    "                 ",
    "                B",
    "      ",
    "     ",
    "   ",
    "             ",
    "      ",
    "       "
};

static const g_BpAwardsDefaultImageCount[] =
{
    1, 1, 1, 19, 1, 1, 1, 1, 3, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

new g_BpRewardsFilter[MAX_PLAYERS];
new g_BpRewardsOffset[MAX_PLAYERS];

stock BpRewards_InitDefaults()
{
    g_BpAwardsCount = 0;
    for (new i = 0; i < sizeof(g_BpAwardsDefaultId) && g_BpAwardsCount < MAX_BPR_AWARD_TYPES; i++)
    {
        g_BpAwards[g_BpAwardsCount][bpr_award_id] = g_BpAwardsDefaultId[i];
        format(g_BpAwards[g_BpAwardsCount][bpr_award_name], MAX_BPR_AWARD_NAME, "%s", g_BpAwardsDefaultName[i]);
        g_BpAwards[g_BpAwardsCount][bpr_award_image_count] = g_BpAwardsDefaultImageCount[i];

        for (new j = 0; j < MAX_BPR_AWARD_IMAGES; j++)
            g_BpAwardImages[g_BpAwardsCount][j][0] = '\0';

        g_BpAwardsCount++;
    }
    return 1;
}

stock BpRewards_Utf8ToCp1251(const src[], dest[], destSize)
{
    new di = 0;
    for (new i = 0; src[i] != '\0' && di < destSize - 1; i++)
    {
        new c = src[i] & 0xFF;
        if (c < 0x80)
        {
            dest[di++] = c;
            continue;
        }

        if ((c & 0xE0) == 0xC0)
        {
            new c2 = src[i + 1] & 0xFF;
            if (c2 == '\0')
                break;
            if ((c2 & 0xC0) != 0x80)
                continue;

            new code = ((c & 0x1F) << 6) | (c2 & 0x3F);
            i++;

            if (code >= 0x0410 && code <= 0x044F)
            {
                dest[di++] = code - 0x0410 + 0xC0;
            }
            else if (code == 0x0401)
            {
                dest[di++] = 0xA8;
            }
            else if (code == 0x0451)
            {
                dest[di++] = 0xB8;
            }
            else
            {
                dest[di++] = '?';
            }
            continue;
        }

        dest[di++] = '?';
    }
    dest[di] = '\0';
    return di;
}

stock bool:BpRewards_IsValidUtf8(const src[])
{
    for (new i = 0; src[i] != '\0'; i++)
    {
        new c = src[i] & 0xFF;
        if (c < 0x80)
            continue;

        if ((c & 0xE0) == 0xC0)
        {
            new c2 = src[i + 1] & 0xFF;
            if (c2 == '\0' || (c2 & 0xC0) != 0x80)
                return false;
            i += 1;
            continue;
        }

        if ((c & 0xF0) == 0xE0)
        {
            new c2 = src[i + 1] & 0xFF;
            new c3 = src[i + 2] & 0xFF;
            if (c2 == '\0' || c3 == '\0')
                return false;
            if ((c2 & 0xC0) != 0x80 || (c3 & 0xC0) != 0x80)
                return false;
            i += 2;
            continue;
        }

        if ((c & 0xF8) == 0xF0)
        {
            new c2 = src[i + 1] & 0xFF;
            new c3 = src[i + 2] & 0xFF;
            new c4 = src[i + 3] & 0xFF;
            if (c2 == '\0' || c3 == '\0' || c4 == '\0')
                return false;
            if ((c2 & 0xC0) != 0x80 || (c3 & 0xC0) != 0x80 || (c4 & 0xC0) != 0x80)
                return false;
            i += 3;
            continue;
        }

        return false;
    }
    return true;
}

stock bool:BpRewards_IsNameCorrupted(const name[])
{
    for (new i = 0; name[i] != '\0'; i++)
    {
        if (name[i] == '?')
            return true;
    }
    return false;
}

stock BpRewards_GetDefaultNameById(awardId, dest[], destSize)
{
    for (new i = 0; i < sizeof(g_BpAwardsDefaultId); i++)
    {
        if (g_BpAwardsDefaultId[i] == awardId)
        {
            format(dest, destSize, "%s", g_BpAwardsDefaultName[i]);
            return 1;
        }
    }
    dest[0] = '\0';
    return 0;
}

stock BpRewards_NormalizeName(const src[], dest[], destSize)
{
    if (BpRewards_IsValidUtf8(src))
        format(dest, destSize, "%s", src);
    else
        BpRewards_Cp1251ToUtf8(src, dest, destSize);
    return 1;
}

stock BpRewards_SetStr(Node:obj, const key[], const value[])
{
    new tmp[256];
    format(tmp, sizeof(tmp), "%s", value);
    JSON_SetString(obj, key, tmp, sizeof(tmp));
}

stock BpRewards_EscapeJsonString(const src[], dest[], destSize)
{
    new di = 0;
    new bool:isUtf8 = BpRewards_IsValidUtf8(src);
    static const cpTable[64] =
    {
        0x0402, 0x0403, 0x201A, 0x0453, 0x201E, 0x2026, 0x2020, 0x2021,
        0x20AC, 0x2030, 0x0409, 0x2039, 0x040A, 0x040C, 0x040B, 0x040F,
        0x0452, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014,
        0x0000, 0x2122, 0x0459, 0x203A, 0x045A, 0x045C, 0x045B, 0x045F,
        0x00A0, 0x040E, 0x045E, 0x0408, 0x00A4, 0x0490, 0x00A6, 0x00A7,
        0x0401, 0x00A9, 0x0404, 0x00AB, 0x00AC, 0x00AD, 0x00AE, 0x0407,
        0x00B0, 0x00B1, 0x0406, 0x0456, 0x0491, 0x00B5, 0x00B6, 0x00B7,
        0x0451, 0x2116, 0x0454, 0x00BB, 0x0458, 0x0405, 0x0455, 0x0457
    };
    for (new i = 0; src[i] != '\0' && di < destSize - 1; i++)
    {
        new c = src[i] & 0xFF;
        if (c == '\"' || c == '\\')
        {
            if (di + 1 >= destSize)
                break;
            dest[di++] = '\\';
            dest[di++] = c;
        }
        else if (c < 0x20)
        {
            if (di + 5 >= destSize)
                break;
            dest[di++] = '\\';
            dest[di++] = 'u';
            dest[di++] = '0';
            dest[di++] = '0';
            dest[di++] = g_BpHexChars[(c >> 4) & 0xF];
            dest[di++] = g_BpHexChars[c & 0xF];
        }
        else if (c < 0x80)
        {
            dest[di++] = c;
        }
        else
        {
            new code = 0x003F;
            if (isUtf8)
            {
                if ((c & 0xE0) == 0xC0)
                {
                    new c2 = src[i + 1] & 0xFF;
                    if (c2 == '\0' || (c2 & 0xC0) != 0x80)
                        code = 0x003F;
                    else
                    {
                        code = ((c & 0x1F) << 6) | (c2 & 0x3F);
                        i += 1;
                    }
                }
                else if ((c & 0xF0) == 0xE0)
                {
                    new c2 = src[i + 1] & 0xFF;
                    new c3 = src[i + 2] & 0xFF;
                    if (c2 == '\0' || c3 == '\0' || (c2 & 0xC0) != 0x80 || (c3 & 0xC0) != 0x80)
                        code = 0x003F;
                    else
                    {
                        code = ((c & 0x0F) << 12) | ((c2 & 0x3F) << 6) | (c3 & 0x3F);
                        i += 2;
                    }
                }
                else if ((c & 0xF8) == 0xF0)
                {
                    new c2 = src[i + 1] & 0xFF;
                    new c3 = src[i + 2] & 0xFF;
                    new c4 = src[i + 3] & 0xFF;
                    if (c2 == '\0' || c3 == '\0' || c4 == '\0')
                        code = 0x003F;
                    else
                    {
                        code = 0x003F;
                        i += 3;
                    }
                }
            }
            else
            {
                if (c >= 0xC0)
                    code = 0x0410 + (c - 0xC0);
                else
                {
                    code = cpTable[c - 0x80];
                    if (code == 0x0000)
                        code = 0x003F;
                }
            }

            if (code < 0x80)
            {
                dest[di++] = code;
            }
            else
            {
                if (di + 5 >= destSize)
                    break;
                dest[di++] = '\\';
                dest[di++] = 'u';
                dest[di++] = g_BpHexChars[(code >> 12) & 0xF];
                dest[di++] = g_BpHexChars[(code >> 8) & 0xF];
                dest[di++] = g_BpHexChars[(code >> 4) & 0xF];
                dest[di++] = g_BpHexChars[code & 0xF];
            }
        }
    }
    dest[di] = '\0';
    return di;
}

stock BpRewards_ResetBuf()
{
    g_BpRewardsJsonBuf[0] = '\0';
    g_BpRewardsItemsBuf[0] = '\0';
    g_BpRewardsAlarmsBuf[0] = '\0';
    return 1;
}

stock BpRewards_AppendStr(dest[], destSize, const src[])
{
    strcat(dest, src, destSize);
    return 1;
}

stock BpRewards_AppendFmt1(dest[], destSize, const fmt[], a)
{
    new tmp[256];
    format(tmp, sizeof(tmp), fmt, a);
    strcat(dest, tmp, destSize);
    return 1;
}


stock BpRewards_AppendFmt2(dest[], destSize, const fmt[], a, b)
{
    new tmp[256];
    format(tmp, sizeof(tmp), fmt, a, b);
    strcat(dest, tmp, destSize);
    return 1;
}

stock BpRewards_AppendFmt3(dest[], destSize, const fmt[], a, b, c)
{
    new tmp[256];
    format(tmp, sizeof(tmp), fmt, a, b, c);
    strcat(dest, tmp, destSize);
    return 1;
}

stock BpRewards_AppendFmt4(dest[], destSize, const fmt[], a, b, c, d)
{
    new tmp[256];
    format(tmp, sizeof(tmp), fmt, a, b, c, d);
    strcat(dest, tmp, destSize);
    return 1;
}


stock BpRewards_AppendItemJson(itemIndex, dest[], destSize)
{
    new nameEsc[512];
    BpRewards_EscapeJsonString(g_BpRewards[itemIndex][bpr_item_name], nameEsc, sizeof(nameEsc));

    BpRewards_AppendFmt1(dest, destSize, "{\"id\":%d,\"n\":\"", g_BpRewards[itemIndex][bpr_item_id]);
    BpRewards_AppendStr(dest, destSize, nameEsc);
    BpRewards_AppendFmt2(dest, destSize, "\",\"td\":%d,\"st\":%d",
        g_BpRewards[itemIndex][bpr_item_type],
        g_BpRewards[itemIndex][bpr_item_alarm]
    );

    if (g_BpRewards[itemIndex][bpr_item_id_for_images] >= 0)
        BpRewards_AppendFmt1(dest, destSize, ",\"el\":%d", g_BpRewards[itemIndex][bpr_item_id_for_images]);

    if (g_BpRewards[itemIndex][bpr_item_skin_model_id] >= 0)
        BpRewards_AppendFmt1(dest, destSize, ",\"c\":%d", g_BpRewards[itemIndex][bpr_item_skin_model_id]);

    BpRewards_AppendFmt4(dest, destSize,
        ",\"ds\":%d,\"sp\":%d,\"r\":%d,\"ct\":%d,\"els\":[",
        g_BpRewards[itemIndex][bpr_item_days_left],
        g_BpRewards[itemIndex][bpr_item_spray_price],
        g_BpRewards[itemIndex][bpr_item_rarity],
        g_BpRewards[itemIndex][bpr_item_quantity]
    );

    for (new i = 0; i < g_BpRewards[itemIndex][bpr_item_plate_text_count]; i++)
    {
        new plateEsc[128];
        BpRewards_EscapeJsonString(g_BpRewardPlateText[itemIndex][i], plateEsc, sizeof(plateEsc));
        if (i > 0)
            BpRewards_AppendStr(dest, destSize, ",");
        BpRewards_AppendStr(dest, destSize, "\"");
        BpRewards_AppendStr(dest, destSize, plateEsc);
        BpRewards_AppendStr(dest, destSize, "\"");
    }
    BpRewards_AppendStr(dest, destSize, "]}");
    return 1;
}

stock BpRewards_BuildItemsArray(filterState, startIndex, limit, &added)
{
    g_BpRewardsItemsBuf[0] = '\0';
    BpRewards_AppendStr(g_BpRewardsItemsBuf, sizeof(g_BpRewardsItemsBuf), "[");

    added = 0;
    new skipped;
    for (new i = 0; i < g_BpRewardsCount; i++)
    {
        if (!BpRewards_ItemMatchesFilter(i, filterState))
            continue;

        if (skipped < startIndex)
        {
            skipped++;
            continue;
        }

        if (added > 0)
            BpRewards_AppendStr(g_BpRewardsItemsBuf, sizeof(g_BpRewardsItemsBuf), ",");

        BpRewards_AppendItemJson(i, g_BpRewardsItemsBuf, sizeof(g_BpRewardsItemsBuf));
        added++;
        if (added >= limit)
            break;
    }

    BpRewards_AppendStr(g_BpRewardsItemsBuf, sizeof(g_BpRewardsItemsBuf), "]");
    return 1;
}

stock BpRewards_BuildAlarmsArray()
{
    g_BpRewardsAlarmsBuf[0] = '\0';
    BpRewards_AppendStr(g_BpRewardsAlarmsBuf, sizeof(g_BpRewardsAlarmsBuf), "[");
    for (new filterState = BPR_FILTER_MIN; filterState <= BPR_FILTER_MAX; filterState++)
    {
        new alarmCount;
        for (new i = 0; i < g_BpRewardsCount; i++)
        {
            if (BpRewards_ItemMatchesFilter(i, filterState) && g_BpRewards[i][bpr_item_alarm] > 0)
                alarmCount++;
        }
        if (filterState > BPR_FILTER_MIN)
            BpRewards_AppendStr(g_BpRewardsAlarmsBuf, sizeof(g_BpRewardsAlarmsBuf), ",");
        BpRewards_AppendFmt1(g_BpRewardsAlarmsBuf, sizeof(g_BpRewardsAlarmsBuf), "%d", alarmCount);
    }
    BpRewards_AppendStr(g_BpRewardsAlarmsBuf, sizeof(g_BpRewardsAlarmsBuf), "]");
    return 1;
}

stock BpRewards_Cp1251ToUtf8(const src[], dest[], destSize)
{
    static const cpTable[64] =
    {
        0x0402, 0x0403, 0x201A, 0x0453, 0x201E, 0x2026, 0x2020, 0x2021,
        0x20AC, 0x2030, 0x0409, 0x2039, 0x040A, 0x040C, 0x040B, 0x040F,
        0x0452, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014,
        0x0000, 0x2122, 0x0459, 0x203A, 0x045A, 0x045C, 0x045B, 0x045F,
        0x00A0, 0x040E, 0x045E, 0x0408, 0x00A4, 0x0490, 0x00A6, 0x00A7,
        0x0401, 0x00A9, 0x0404, 0x00AB, 0x00AC, 0x00AD, 0x00AE, 0x0407,
        0x00B0, 0x00B1, 0x0406, 0x0456, 0x0491, 0x00B5, 0x00B6, 0x00B7,
        0x0451, 0x2116, 0x0454, 0x00BB, 0x0458, 0x0405, 0x0455, 0x0457
    };

    new di = 0;
    for (new i = 0; src[i] != '\0' && di < destSize - 1; i++)
    {
        new c = src[i] & 0xFF;
        if (c < 0x80)
        {
            dest[di++] = c;
            continue;
        }

        new code;
        if (c >= 0xC0)
            code = 0x0410 + (c - 0xC0);
        else
        {
            code = cpTable[c - 0x80];
            if (code == 0x0000)
                code = 0x003F;
        }

        if (code < 0x80)
        {
            dest[di++] = code;
        }
        else if (code < 0x800)
        {
            if (di + 1 >= destSize)
                break;
            dest[di++] = 0xC0 | (code >> 6);
            dest[di++] = 0x80 | (code & 0x3F);
        }
        else
        {
            if (di + 2 >= destSize)
                break;
            dest[di++] = 0xE0 | (code >> 12);
            dest[di++] = 0x80 | ((code >> 6) & 0x3F);
            dest[di++] = 0x80 | (code & 0x3F);
        }
    }

    dest[di] = '\0';
    return di;
}

stock BpRewards_FindAwardTypeById(awardId)
{
    for (new i = 0; i < g_BpAwardsCount; i++)
    {
        if (g_BpAwards[i][bpr_award_id] == awardId)
            return i;
    }
    return -1;
}

stock BpRewards_GetAwardTypeName(awardId, dest[], destSize)
{
    new idx = BpRewards_FindAwardTypeById(awardId);
    if (idx != -1 && g_BpAwards[idx][bpr_award_name][0])
    {
        if (!BpRewards_IsNameCorrupted(g_BpAwards[idx][bpr_award_name]))
        {
            format(dest, destSize, "%s", g_BpAwards[idx][bpr_award_name]);
            return 1;
        }
    }
    if (BpRewards_GetDefaultNameById(awardId, dest, destSize))
        return 1;
    format(dest, destSize, "Reward %d", awardId);
    return 0;
}

stock BpRewards_NormalizeImageId(awardType, imageId)
{
    if (awardType == BPR_TYPE_CAR || awardType == BPR_TYPE_INVENTORY)
        return imageId;

    new idx = BpRewards_FindAwardTypeById(awardType);
    if (idx != -1)
    {
        new maxImages = g_BpAwards[idx][bpr_award_image_count];
        if (maxImages > 0 && (imageId < 1 || imageId > maxImages))
            return 1;
    }
    return (imageId < 1) ? 1 : imageId;
}

stock bool:BpRewards_IsCurrencyType(awardType)
{
    switch (awardType)
    {
        case 1, 2, 3, 7, 10, 18, 19, 20, 21:
            return true;
    }
    return false;
}

stock bool:BpRewards_IsPlateReward(itemIndex)
{
    if (g_BpRewards[itemIndex][bpr_item_type] != BPR_TYPE_INVENTORY)
        return false;

    new id = g_BpRewards[itemIndex][bpr_item_id_for_images];
    return (id == BPR_PLATE_RU || id == BPR_PLATE_UA || id == BPR_PLATE_BY || id == BPR_PLATE_KZ);
}

stock BpRewards_GetItemGroup(itemIndex)
{
    new awardType = g_BpRewards[itemIndex][bpr_item_type];
    if (awardType == BPR_TYPE_CAR)
        return BPR_FILTER_CARS;
    if (awardType == BPR_TYPE_VIP)
        return BPR_FILTER_VIP;
    if (awardType == BPR_TYPE_INVENTORY)
    {
        if (g_BpRewards[itemIndex][bpr_item_id_for_images] == BPR_SKIN_EL)
            return BPR_FILTER_SKINS;
        if (BpRewards_IsPlateReward(itemIndex))
            return BPR_FILTER_OTHER;
        return BPR_FILTER_ACCESSORIES;
    }
    if (BpRewards_IsCurrencyType(awardType))
        return BPR_FILTER_CURRENCIES;
    return BPR_FILTER_OTHER;
}

stock bool:BpRewards_ItemMatchesFilter(itemIndex, filterState)
{
    if (filterState == BPR_FILTER_ALL)
        return true;
    return (BpRewards_GetItemGroup(itemIndex) == filterState);
}

stock Node:BpRewards_MakeItemObj(itemIndex)
{
    new Node:o = JSON_Object(BPR_KEY_ID, JSON_Int(g_BpRewards[itemIndex][bpr_item_id]));
    BpRewards_SetStr(o, BPR_KEY_NAME, g_BpRewards[itemIndex][bpr_item_name]);
    JSON_SetInt(o, BPR_KEY_TYPE, g_BpRewards[itemIndex][bpr_item_type]);
    JSON_SetInt(o, BPR_KEY_ALARM, g_BpRewards[itemIndex][bpr_item_alarm]);

    if (g_BpRewards[itemIndex][bpr_item_id_for_images] >= 0)
        JSON_SetInt(o, BPR_KEY_IMAGE_ID, g_BpRewards[itemIndex][bpr_item_id_for_images]);

    if (g_BpRewards[itemIndex][bpr_item_skin_model_id] >= 0)
        JSON_SetInt(o, BPR_KEY_SKIN_MODEL, g_BpRewards[itemIndex][bpr_item_skin_model_id]);

    JSON_SetInt(o, BPR_KEY_DAYS, g_BpRewards[itemIndex][bpr_item_days_left]);
    JSON_SetInt(o, BPR_KEY_SPRAY, g_BpRewards[itemIndex][bpr_item_spray_price]);
    JSON_SetInt(o, BPR_KEY_RARITY, g_BpRewards[itemIndex][bpr_item_rarity]);
    JSON_SetInt(o, BPR_KEY_COUNT, g_BpRewards[itemIndex][bpr_item_quantity]);

    JSON_SetArray(o, BPR_KEY_PLATE, JSON_Array());
    for (new i = 0; i < g_BpRewards[itemIndex][bpr_item_plate_text_count]; i++)
    {
        JSON_ArrayAppend(o, BPR_KEY_PLATE, JSON_String(g_BpRewardPlateText[itemIndex][i]));
    }
    return o;
}

stock BpRewards_AppendItems(Node:root, const key[], filterState, startIndex, limit, &added)
{
    JSON_SetArray(root, key, JSON_Array());
    added = 0;

    new skipped;
    for (new i = 0; i < g_BpRewardsCount; i++)
    {
        if (!BpRewards_ItemMatchesFilter(i, filterState))
            continue;

        if (skipped < startIndex)
        {
            skipped++;
            continue;
        }

        JSON_ArrayAppend(root, key, BpRewards_MakeItemObj(i));
        added++;
        if (added >= limit)
            return 1;
    }
    return 1;
}

stock BpRewards_AppendAlarms(Node:root)
{
    JSON_SetArray(root, BPR_KEY_ALARMS, JSON_Array());
    for (new filterState = BPR_FILTER_MIN; filterState <= BPR_FILTER_MAX; filterState++)
    {
        new alarmCount;
        for (new i = 0; i < g_BpRewardsCount; i++)
        {
            if (BpRewards_ItemMatchesFilter(i, filterState) && g_BpRewards[i][bpr_item_alarm] > 0)
                alarmCount++;
        }
        JSON_ArrayAppend(root, BPR_KEY_ALARMS, JSON_Int(alarmCount));
    }
    return 1;
}

stock BpRewards_AddItem(const name[], awardType, imageId, rarity, quantity, daysLeft, skinModelId, sprayPrice, alarm, plateTextCount, const plateText[][MAX_BPR_PLATE_TEXT_LEN])
{
    if (g_BpRewardsCount >= MAX_BPR_ITEMS)
        return -1;

    new idx = g_BpRewardsCount++;
    g_BpRewards[idx][bpr_item_id] = g_BpRewardsNextId++;
    g_BpRewards[idx][bpr_item_type] = awardType;
    g_BpRewards[idx][bpr_item_alarm] = alarm;
    g_BpRewards[idx][bpr_item_id_for_images] = imageId;
    g_BpRewards[idx][bpr_item_skin_model_id] = skinModelId;
    g_BpRewards[idx][bpr_item_days_left] = daysLeft;
    g_BpRewards[idx][bpr_item_spray_price] = sprayPrice;
    g_BpRewards[idx][bpr_item_rarity] = rarity;
    g_BpRewards[idx][bpr_item_quantity] = quantity;

    format(g_BpRewards[idx][bpr_item_name], MAX_BPR_ITEM_NAME, "%s", name);

    if (plateTextCount < 0) plateTextCount = 0;
    if (plateTextCount > MAX_BPR_PLATE_TEXT) plateTextCount = MAX_BPR_PLATE_TEXT;
    g_BpRewards[idx][bpr_item_plate_text_count] = plateTextCount;

    for (new i = 0; i < MAX_BPR_PLATE_TEXT; i++)
        g_BpRewardPlateText[idx][i][0] = '\0';

    for (new i = 0; i < plateTextCount; i++)
        format(g_BpRewardPlateText[idx][i], MAX_BPR_PLATE_TEXT_LEN, "%s", plateText[i]);

    return g_BpRewards[idx][bpr_item_id];
}

stock BpRewards_CopyItem(dst, src)
{
    g_BpRewards[dst][bpr_item_id] = g_BpRewards[src][bpr_item_id];
    g_BpRewards[dst][bpr_item_type] = g_BpRewards[src][bpr_item_type];
    g_BpRewards[dst][bpr_item_alarm] = g_BpRewards[src][bpr_item_alarm];
    g_BpRewards[dst][bpr_item_id_for_images] = g_BpRewards[src][bpr_item_id_for_images];
    g_BpRewards[dst][bpr_item_skin_model_id] = g_BpRewards[src][bpr_item_skin_model_id];
    g_BpRewards[dst][bpr_item_days_left] = g_BpRewards[src][bpr_item_days_left];
    g_BpRewards[dst][bpr_item_spray_price] = g_BpRewards[src][bpr_item_spray_price];
    g_BpRewards[dst][bpr_item_rarity] = g_BpRewards[src][bpr_item_rarity];
    g_BpRewards[dst][bpr_item_quantity] = g_BpRewards[src][bpr_item_quantity];
    g_BpRewards[dst][bpr_item_plate_text_count] = g_BpRewards[src][bpr_item_plate_text_count];
    format(g_BpRewards[dst][bpr_item_name], MAX_BPR_ITEM_NAME, "%s", g_BpRewards[src][bpr_item_name]);

    for (new i = 0; i < MAX_BPR_PLATE_TEXT; i++)
        format(g_BpRewardPlateText[dst][i], MAX_BPR_PLATE_TEXT_LEN, "%s", g_BpRewardPlateText[src][i]);
    return 1;
}

stock BpRewards_GetPositionInFilter(itemIndex, filterState)
{
    if (!BpRewards_ItemMatchesFilter(itemIndex, filterState))
        return -1;

    new position = -1;
    for (new i = 0; i <= itemIndex && i < g_BpRewardsCount; i++)
    {
        if (BpRewards_ItemMatchesFilter(i, filterState))
            position++;
    }
    return position;
}

stock BpRewards_RemoveItemById(itemId)
{
    for (new i = 0; i < g_BpRewardsCount; i++)
    {
        if (g_BpRewards[i][bpr_item_id] != itemId)
            continue;

        for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
        {
            new filterState = g_BpRewardsFilter[playerid];
            if (filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX)
                continue;

            new position = BpRewards_GetPositionInFilter(i, filterState);
            if (position >= 0 && g_BpRewardsOffset[playerid] > position)
                g_BpRewardsOffset[playerid]--;
        }

        for (new j = i; j < g_BpRewardsCount - 1; j++)
            BpRewards_CopyItem(j, j + 1);

        g_BpRewardsCount--;
        return 1;
    }
    return 0;
}

stock BpRewards_Open(playerid)
{
    printf("[BpRewards] Open request from player %d", playerid);

    g_BpRewardsCount = g_PlayerBpRewardsCount[playerid];
    for (new i = 0; i < g_BpRewardsCount; i++)
    {
        g_BpRewards[i][bpr_item_id]            = g_PlayerBpRewards[playerid][i][bpr_item_id];
        g_BpRewards[i][bpr_item_type]          = g_PlayerBpRewards[playerid][i][bpr_item_type];
        g_BpRewards[i][bpr_item_alarm]         = g_PlayerBpRewards[playerid][i][bpr_item_alarm];
        g_BpRewards[i][bpr_item_id_for_images] = g_PlayerBpRewards[playerid][i][bpr_item_id_for_images];
        g_BpRewards[i][bpr_item_skin_model_id] = g_PlayerBpRewards[playerid][i][bpr_item_skin_model_id];
        g_BpRewards[i][bpr_item_days_left]     = g_PlayerBpRewards[playerid][i][bpr_item_days_left];
        g_BpRewards[i][bpr_item_spray_price]   = g_PlayerBpRewards[playerid][i][bpr_item_spray_price];
        g_BpRewards[i][bpr_item_rarity]        = g_PlayerBpRewards[playerid][i][bpr_item_rarity];
        g_BpRewards[i][bpr_item_quantity]      = g_PlayerBpRewards[playerid][i][bpr_item_quantity];
        g_BpRewards[i][bpr_item_plate_text_count] = g_PlayerBpRewards[playerid][i][bpr_item_plate_text_count];
        format(g_BpRewards[i][bpr_item_name], MAX_BPR_ITEM_NAME, "%s", g_PlayerBpRewards[playerid][i][bpr_item_name]);
    }

    g_BpRewardsFilter[playerid] = BPR_FILTER_ALL;
    g_BpRewardsOffset[playerid] = 0;

    new added;
    BpRewards_BuildItemsArray(g_BpRewardsFilter[playerid], g_BpRewardsOffset[playerid], BPR_PAGE_SIZE, added);
    g_BpRewardsOffset[playerid] += added;
    BpRewards_BuildAlarmsArray();

    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"o\":1,\"t\":0,\"tn\":0,\"pr\":%s,\"fl\":%s}",
        g_BpRewardsItemsBuf,
        g_BpRewardsAlarmsBuf
    );

    ShowPlayerGUI_Raw(playerid, GUI_BPREWARDS, g_BpRewardsJsonBuf);
    return 1;
}

stock BpRewards_SendFilterUpdate(playerid, filterState)
{
    g_BpRewardsFilter[playerid] = filterState;
    g_BpRewardsOffset[playerid] = 0;

    new added;
    BpRewards_BuildItemsArray(filterState, 0, BPR_PAGE_SIZE, added);
    g_BpRewardsOffset[playerid] = added;
    BpRewards_BuildAlarmsArray();

    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"t\":1,\"tn\":0,\"pr\":%s,\"fl\":%s}",
        g_BpRewardsItemsBuf,
        g_BpRewardsAlarmsBuf
    );

    UpdatePlayerGUI_Raw(playerid, GUI_BPREWARDS, g_BpRewardsJsonBuf);
    return 1;
}

stock BpRewards_SendNextPage(playerid)
{
    new filterState = g_BpRewardsFilter[playerid];
    new startIndex = g_BpRewardsOffset[playerid];
    if (filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX)
    {
        filterState = BPR_FILTER_ALL;
        g_BpRewardsFilter[playerid] = filterState;
    }

    new added;
    BpRewards_BuildItemsArray(filterState, startIndex, BPR_PAGE_SIZE, added);
    if (added == 0)
        g_BpRewardsOffset[playerid] = startIndex;
    else
        g_BpRewardsOffset[playerid] += added;

    BpRewards_BuildAlarmsArray();

    if (added == 0)
    {
        format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
            "{\"t\":2,\"tn\":0,\"pr\":%s,\"fl\":%s,\"s\":-1}",
            g_BpRewardsItemsBuf,
            g_BpRewardsAlarmsBuf
        );
    }
    else
    {
        format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
            "{\"t\":2,\"tn\":0,\"pr\":%s,\"fl\":%s}",
            g_BpRewardsItemsBuf,
            g_BpRewardsAlarmsBuf
        );
    }

    UpdatePlayerGUI_Raw(playerid, GUI_BPREWARDS, g_BpRewardsJsonBuf);
    return 1;
}

stock BpRewards_SendClickUpdate(playerid, itemId, clickType)
{
    BpRewards_BuildAlarmsArray();
    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"t\":4,\"id\":%d,\"s\":%d,\"fl\":%s}",
        itemId,
        clickType,
        g_BpRewardsAlarmsBuf
    );

    UpdatePlayerGUI_Raw(playerid, GUI_BPREWARDS, g_BpRewardsJsonBuf);
    return 1;
}

stock BpRewards_Init()
{
    g_BpAwardsCount = 0;

    new Node:root;
    if (JSON_ParseFile("awards.json", root) == 0)
    {
        if (JSON_ParseFile("../awards.json", root) == 0)
        {
            printf("[BpRewards] awards.json not found or invalid JSON, using defaults");
            BpRewards_InitDefaults();
            printf("[BpRewards] Loaded %d award types (defaults)", g_BpAwardsCount);
            return 1;
        }
    }

    new Node:types;
    JSON_GetArray(root, "awardsTypes", types);

    new len;
    JSON_ArrayLength(types, len);
    if (len <= 0)
    {
        JSON_Cleanup(root);
        printf("[BpRewards] awards.json empty, using defaults");
        BpRewards_InitDefaults();
        printf("[BpRewards] Loaded %d award types (defaults)", g_BpAwardsCount);
        return 1;
    }

    for (new i = 0; i < len && g_BpAwardsCount < MAX_BPR_AWARD_TYPES; i++)
    {
        new Node:item;
        JSON_ArrayObject(types, i, item);

        new awardId;
        JSON_GetInt(item, "id", awardId);

        new awardName[MAX_BPR_AWARD_NAME];
        JSON_GetString(item, "name", awardName, sizeof(awardName));

        g_BpAwards[g_BpAwardsCount][bpr_award_id] = awardId;
        BpRewards_NormalizeName(awardName, g_BpAwards[g_BpAwardsCount][bpr_award_name], MAX_BPR_AWARD_NAME);
        if (g_BpAwards[g_BpAwardsCount][bpr_award_name][0] == '\0' || BpRewards_IsNameCorrupted(g_BpAwards[g_BpAwardsCount][bpr_award_name]))
            BpRewards_GetDefaultNameById(awardId, g_BpAwards[g_BpAwardsCount][bpr_award_name], MAX_BPR_AWARD_NAME);

        new Node:images;
        JSON_GetArray(item, "image", images);

        new imgLen;
        JSON_ArrayLength(images, imgLen);
        if (imgLen > MAX_BPR_AWARD_IMAGES) imgLen = MAX_BPR_AWARD_IMAGES;
        g_BpAwards[g_BpAwardsCount][bpr_award_image_count] = imgLen;

        for (new j = 0; j < imgLen; j++)
        {
            new Node:imgNode;
            new imgName[MAX_BPR_AWARD_IMAGE_NAME];
            JSON_ArrayObject(images, j, imgNode);
            JSON_GetNodeString(imgNode, imgName, sizeof(imgName));
            format(g_BpAwardImages[g_BpAwardsCount][j], MAX_BPR_AWARD_IMAGE_NAME, "%s", imgName);
        }

        g_BpAwardsCount++;
    }

    JSON_Cleanup(root);
    printf("[BpRewards] Loaded %d award types", g_BpAwardsCount);
    return 1;
}

stock BpRewards_SkipSpaces(const string[], &index)
{
    while (string[index] <= ' ' && string[index] != '\0')
        index++;
    return 1;
}

stock BpRewards_ParseToken(const string[], &index, token[], tokenSize)
{
    BpRewards_SkipSpaces(string, index);
    if (string[index] == '\0')
        return 0;

    new i;
    while (string[index] > ' ' && string[index] != '\0')
    {
        if (i < tokenSize - 1)
            token[i++] = string[index];
        index++;
    }
    token[i] = '\0';
    return 1;
}

stock BpRewards_GetRemainingText(const string[], index, dest[], destSize)
{
    BpRewards_SkipSpaces(string, index);
    if (string[index] == '\0')
    {
        dest[0] = '\0';
        return 0;
    }
    strmid(dest, string, index, strlen(string), destSize);
    return 1;
}

stock bool:BpRewards_ParseIntKey(const data[], const key[], &out)
{
    new pattern[16];
    format(pattern, sizeof(pattern), "\"%s\":", key);

    new idx = strfind(data, pattern, true);
    if (idx == -1)
        return false;

    idx += strlen(pattern);
    while (data[idx] == ' ' || data[idx] == '\t')
        idx++;

    new sign = 1;
    if (data[idx] == '-')
    {
        sign = -1;
        idx++;
    }

    new value;
    new hasDigit;
    while (data[idx] >= '0' && data[idx] <= '9')
    {
        value = (value * 10) + (data[idx] - '0');
        idx++;
        hasDigit = 1;
    }
    if (!hasDigit)
        return false;

    out = value * sign;
    return true;
}

forward BpRewards_OnClaim(playerid, db_row_id, bpr_type, bpr_item, bpr_qty);

stock BpRewards_DefaultClaim(playerid, bpr_type, bpr_item, bpr_qty)
{
    if (bpr_type == BPR_TYPE_CAR)
    {
        new query[512];
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO `ownable_cars` (owner_id, model_id, x, y, z, angle, owner_name, number) VALUES (%d, %d, %f, %f, %f, %f, '%e', 'REWARD')",
            GetPlayerAccountID(playerid), bpr_item, x, y, z, a, GetPlayerNameEx(playerid));
        mysql_tquery(mysql, query);
        ShowClientNotification(playerid, 3, 4, 0, 0, "\xd2\xf0\xe0\xed\xf1\xef\xee\xf0\xf2 \xe4\xee\xe1\xe0\xe2\xeb\xe5\xed \xe2 /car", "");
        return 1;
    }

    new freeSlot = Inventory_GetFreeSlot(playerid);
    if (freeSlot == -1)
    {
        ShowClientNotification(playerid, 2, 7, -1, -1, "\xc8\xed\xe2\xe5\xed\xf2\xe0\xf0\xfc \xef\xee\xeb\xee\xed", "");
        return 0;
    }
    Inventory_SetItem(playerid, freeSlot, bpr_item, bpr_qty, "");
    Inventory_SaveInventoryItem(playerid, freeSlot);
    ShowClientNotification(playerid, 3, 4, 0, 0, "\xcd\xe0\xe3\xf0\xe0\xe4\xe0 \xef\xee\xeb\xf3\xf7\xe5\xed\xe0", "");
    return 1;
}
stock BpRewards_HandlePacket(playerid, Node:JSONObject)
{
    new type;
    JSON_GetInt(JSONObject, BPR_KEY_T, type);

    if (type == 1) return 1;

    if (type == 2)
    {
        new reward_id;
        JSON_GetInt(JSONObject, BPR_KEY_ID, reward_id);

        new idx = -1;
        for (new i = 0; i < g_BpRewardsCount; i++)
        {
            if (g_BpRewards[i][bpr_item_id] == reward_id)
            {
                idx = i;
                break;
            }
        }

        if (idx == -1) return 1;
        if (g_BpRewards[idx][bpr_item_alarm] == 1) return 1;

        new bpr_type  = g_BpRewards[idx][bpr_item_type];
        new bpr_item  = g_BpRewards[idx][bpr_item_id_for_images];
        new bpr_qty   = g_BpRewards[idx][bpr_item_quantity];
        new db_row_id = g_BpRewards[idx][bpr_item_id];

        new bool:given = bool:BpRewards_DefaultClaim(playerid, bpr_type, bpr_item, bpr_qty);

        if (given)
        {
            new query[128];
            mysql_format(mysql, query, sizeof(query),
                "UPDATE `user_rewards` SET `claimed` = 1 WHERE `id` = %d LIMIT 1",
                db_row_id);
            mysql_tquery(mysql, query);

            g_BpRewards[idx][bpr_item_alarm] = 1;

            for (new pi = 0; pi < g_PlayerBpRewardsCount[playerid]; pi++)
            {
                if (g_PlayerBpRewards[playerid][pi][bpr_item_id] == db_row_id)
                {
                    g_PlayerBpRewards[playerid][pi][bpr_item_alarm] = 1;
                    break;
                }
            }
        }

        BpRewards_Open(playerid);
    }
    return 1;
}

stock BpRewards_OnPacket(playerid, Node:JSONObject)
{
    new closeValue;
    JSON_GetInt(JSONObject, BPR_KEY_CLOSE, closeValue);
    if (closeValue == 1)
    {
        HidePlayerGUI(playerid, GUI_BPREWARDS);
        return 1;
    }

    new t;
    JSON_GetInt(JSONObject, BPR_KEY_T, t);

    switch (t)
    {
        case 1:
        {
            new filterState = BPR_FILTER_ALL;
            JSON_GetInt(JSONObject, BPR_KEY_ALARMS, filterState);
            if (filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX)
                filterState = BPR_FILTER_ALL;
            return BpRewards_SendFilterUpdate(playerid, filterState);
        }
        case 2:
        {
            return BpRewards_SendNextPage(playerid);
        }
        case 3:
        {
            return BpRewards_OnCasesButton(playerid);
        }
        case 4:
        {
            new itemId, clickType;
            JSON_GetInt(JSONObject, BPR_KEY_ID, itemId);
            JSON_GetInt(JSONObject, BPR_KEY_CLICK_TYPE, clickType);
            if (clickType == 1 || clickType == 3)
                BpRewards_RemoveItemById(itemId);
            return BpRewards_SendClickUpdate(playerid, itemId, clickType);
        }
        case 5:
        {
            new tanpin;
            JSON_GetInt(JSONObject, BPR_KEY_TANPIN, tanpin);
            return BpRewards_OnTanpinUpdate(playerid, tanpin);
        }
    }
    return 1;
}
CMD:reward(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT * FROM `user_rewards` WHERE `player_id` = %d AND `claimed` = 0",
        GetPlayerAccountID(playerid)
    );
    mysql_tquery(mysql, query, "OnPlayerRewardsLoaded", "i", playerid);
    return 1;
}

stock BpRewards_CmdRewardAdd(playerid, params[])
{
    new awardType, imageId, rarity, quantity, daysLeft;
    new skinModelId = -1;
    new rewardNameRaw[MAX_BPR_ITEM_NAME];
    rewardNameRaw[0] = '\0';

    if (sscanf(params, "ii", awardType, imageId))
        return SendClientMessage(playerid, -1, "Usage: /rewardadd [type] [imageId] [rarity] [quantity] [days] [name...]");

    if (awardType == BPR_TYPE_INVENTORY && imageId == BPR_SKIN_EL)
    {
        if (sscanf(params, "iiiiii", awardType, imageId, rarity, quantity, daysLeft, skinModelId))
            return SendClientMessage(playerid, -1, "Usage: /rewardadd 11 134 [rarity] [quantity] [days] [skinModelId] [name...]");
    }
    else
    {
        if (sscanf(params, "iiiii", awardType, imageId, rarity, quantity, daysLeft))
            return SendClientMessage(playerid, -1, "Usage: /rewardadd [type] [imageId] [rarity] [quantity] [days] [name...]");
    }

    if (rarity < 1) rarity = 1;
    if (quantity < 1) quantity = 1;
    if (daysLeft < 0) daysLeft = 0;
    imageId = BpRewards_NormalizeImageId(awardType, imageId);

    new idx;
    new token[32];
    new tokensToSkip = (awardType == BPR_TYPE_INVENTORY && imageId == BPR_SKIN_EL) ? 6 : 5;
    for (new i = 0; i < tokensToSkip; i++)
    {
        if (!BpRewards_ParseToken(params, idx, token, sizeof(token)))
        {
            rewardNameRaw[0] = '\0';
            break;
        }
    }
    if (rewardNameRaw[0] == '\0')
        BpRewards_GetRemainingText(params, idx, rewardNameRaw, sizeof(rewardNameRaw));

    new rewardName[MAX_BPR_ITEM_NAME];
    if (rewardNameRaw[0])
        BpRewards_NormalizeName(rewardNameRaw, rewardName, sizeof(rewardName));
    else
        BpRewards_GetAwardTypeName(awardType, rewardName, sizeof(rewardName));

    new plateText[MAX_BPR_PLATE_TEXT][MAX_BPR_PLATE_TEXT_LEN];
    for (new i = 0; i < MAX_BPR_PLATE_TEXT; i++)
        plateText[i][0] = '\0';

    new itemId = BpRewards_AddItem(rewardName, awardType, imageId, rarity, quantity, daysLeft, skinModelId, 0, 0, 0, plateText);
    if (itemId == -1)
        return SendClientMessage(playerid, -1, "BpRewards list is full.");

    new msg[96];
    format(msg, sizeof(msg), "Reward added. ID: %d", itemId);
    SendClientMessage(playerid, -1, msg);
    printf("[BpRewards] Added reward id=%d type=%d name=%s", itemId, awardType, rewardName);
    return 1;
}

CMD:rewardadd(playerid, params[])
{
    return BpRewards_CmdRewardAdd(playerid, params);
}

// ---------------------------------------------------------------------------
// Cases button handler (t=3)
// ---------------------------------------------------------------------------
forward BpRewards_OnCasesButtonClick(playerid);

stock BpRewards_OnCasesButton(playerid)
{
    CallLocalFunction("BpRewards_OnCasesButtonClick", "i", playerid);

    BpRewards_BuildAlarmsArray();
    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"t\":3,\"fl\":%s}",
        g_BpRewardsAlarmsBuf
    );
    UpdatePlayerGUI_Raw(playerid, GUI_BPREWARDS, g_BpRewardsJsonBuf);
    return 1;
}

// ---------------------------------------------------------------------------
// Tanpin (single-item purchase) update handler (t=5)
// ---------------------------------------------------------------------------
forward BpRewards_OnTanpinRequest(playerid, tanpin);

stock BpRewards_OnTanpinUpdate(playerid, tanpin)
{
    CallLocalFunction("BpRewards_OnTanpinRequest", "ii", playerid, tanpin);

    BpRewards_BuildAlarmsArray();
    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"t\":5,\"tn\":%d,\"fl\":%s}",
        tanpin,
        g_BpRewardsAlarmsBuf
    );
    UpdatePlayerGUI_Raw(playerid, GUI_BPREWARDS, g_BpRewardsJsonBuf);
    return 1;
}

// ---------------------------------------------------------------------------
// Clear all rewards from the global list
// ---------------------------------------------------------------------------
stock BpRewards_Clear()
{
    g_BpRewardsCount = 0;
    g_BpRewardsNextId = 1;
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        g_BpRewardsFilter[i] = BPR_FILTER_ALL;
        g_BpRewardsOffset[i] = 0;
    }
    return 1;
}

// ---------------------------------------------------------------------------
// Update the alarm flag of an existing item by its ID
// ---------------------------------------------------------------------------
stock BpRewards_SetItemAlarm(itemId, alarm)
{
    for (new i = 0; i < g_BpRewardsCount; i++)
    {
        if (g_BpRewards[i][bpr_item_id] == itemId)
        {
            g_BpRewards[i][bpr_item_alarm] = alarm;
            return 1;
        }
    }
    return 0;
}

// ---------------------------------------------------------------------------
// Refresh current page for a player
// ---------------------------------------------------------------------------
stock BpRewards_Refresh(playerid)
{
    new filterState = g_BpRewardsFilter[playerid];
    if (filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX)
        filterState = BPR_FILTER_ALL;

    new offset = g_BpRewardsOffset[playerid];
    new startIndex = (offset > BPR_PAGE_SIZE) ? (offset - BPR_PAGE_SIZE) : 0;

    new added;
    BpRewards_BuildItemsArray(filterState, startIndex, BPR_PAGE_SIZE, added);
    BpRewards_BuildAlarmsArray();

    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"t\":1,\"tn\":0,\"pr\":%s,\"fl\":%s}",
        g_BpRewardsItemsBuf,
        g_BpRewardsAlarmsBuf
    );
    UpdatePlayerGUI_Raw(playerid, GUI_BPREWARDS, g_BpRewardsJsonBuf);
    return 1;
}

// ---------------------------------------------------------------------------
// Admin commands
// ---------------------------------------------------------------------------

// /rewardremove [id]
CMD:rewardremove(playerid, params[])
{
    new itemId;
    if (sscanf(params, "i", itemId))
        return SendClientMessage(playerid, -1, "Usage: /rewardremove [id]");

    if (BpRewards_RemoveItemById(itemId))
    {
        new msg[64];
        format(msg, sizeof(msg), "[BpRewards] Reward %d removed.", itemId);
        SendClientMessage(playerid, -1, msg);
        printf("[BpRewards] Removed reward id=%d by player %d", itemId, playerid);
    }
    else
    {
        SendClientMessage(playerid, -1, "[BpRewards] Reward not found.");
    }
    return 1;
}

// /rewardclear
CMD:rewardclear(playerid)
{
    BpRewards_Clear();
    SendClientMessage(playerid, -1, "[BpRewards] All rewards cleared.");
    printf("[BpRewards] Reward list cleared by player %d", playerid);
    return 1;
}

// /rewardlist [page]
CMD:rewardlist(playerid, params[])
{
    if (g_BpRewardsCount == 0)
        return SendClientMessage(playerid, -1, "[BpRewards] No rewards.");

    new page;
    sscanf(params, "i", page);
    if (page < 1) page = 1;

    new perPage = 10;
    new start = (page - 1) * perPage;
    new end   = start + perPage;
    if (end > g_BpRewardsCount) end = g_BpRewardsCount;
    if (start >= g_BpRewardsCount)
        return SendClientMessage(playerid, -1, "[BpRewards] Page out of range.");

    new msg[128];
    format(msg, sizeof(msg), "[BpRewards] Rewards %d-%d / %d (page %d):", start + 1, end, g_BpRewardsCount, page);
    SendClientMessage(playerid, -1, msg);

    for (new i = start; i < end; i++)
    {
        format(msg, sizeof(msg), "  id=%d type=%d rarity=%d qty=%d name=%s",
            g_BpRewards[i][bpr_item_id],
            g_BpRewards[i][bpr_item_type],
            g_BpRewards[i][bpr_item_rarity],
            g_BpRewards[i][bpr_item_quantity],
            g_BpRewards[i][bpr_item_name]
        );
        SendClientMessage(playerid, -1, msg);
    }
    return 1;
}

// /rewardalarm [id] [0|1]
CMD:rewardalarm(playerid, params[])
{
    new itemId, alarm;
    if (sscanf(params, "ii", itemId, alarm))
        return SendClientMessage(playerid, -1, "Usage: /rewardalarm [id] [0|1]");

    if (alarm < 0) alarm = 0;
    if (alarm > 1) alarm = 1;

    if (BpRewards_SetItemAlarm(itemId, alarm))
    {
        new msg[64];
        format(msg, sizeof(msg), "[BpRewards] Alarm for id=%d set to %d.", itemId, alarm);
        SendClientMessage(playerid, -1, msg);
    }
    else
    {
        SendClientMessage(playerid, -1, "[BpRewards] Reward not found.");
    }
    return 1;
}
forward LoadPlayerRewards(playerid);
public LoadPlayerRewards(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT * FROM `user_rewards` WHERE `player_id` = %d AND `claimed` = 0",
        GetPlayerAccountID(playerid)
    );
    mysql_tquery(mysql, query, "OnPlayerRewardsLoaded", "i", playerid);
    return 1;
}

forward OnPlayerRewardsLoaded(playerid);
public OnPlayerRewardsLoaded(playerid)
{
    new rows = cache_num_rows();

    g_PlayerBpRewardsCount[playerid] = 0;

    if (!rows) return 1;

    for (new i = 0; i < rows && i < 100; i++)
    {
        new idx = g_PlayerBpRewardsCount[playerid];

        g_PlayerBpRewards[playerid][idx][bpr_item_id]            = cache_get_field_content_int(i, "id");
        g_PlayerBpRewards[playerid][idx][bpr_item_type]          = cache_get_field_content_int(i, "item_type");
        g_PlayerBpRewards[playerid][idx][bpr_item_alarm]         = 0;
        g_PlayerBpRewards[playerid][idx][bpr_item_id_for_images] = cache_get_field_content_int(i, "item_id");
        g_PlayerBpRewards[playerid][idx][bpr_item_skin_model_id] = -1;
        g_PlayerBpRewards[playerid][idx][bpr_item_days_left]     = 0;
        g_PlayerBpRewards[playerid][idx][bpr_item_spray_price]   = 0;
        g_PlayerBpRewards[playerid][idx][bpr_item_rarity]        = 1;
        g_PlayerBpRewards[playerid][idx][bpr_item_quantity]      = cache_get_field_content_int(i, "quantity");
        g_PlayerBpRewards[playerid][idx][bpr_item_plate_text_count] = 0;

        BpRewards_GetAwardTypeName(
            g_PlayerBpRewards[playerid][idx][bpr_item_type],
            g_PlayerBpRewards[playerid][idx][bpr_item_name],
            MAX_BPR_ITEM_NAME
        );

        g_PlayerBpRewardsCount[playerid]++;
    }

    printf("[BpRewards] Loaded %d rewards for player %d", g_PlayerBpRewardsCount[playerid], playerid);
    BpRewards_Open(playerid);
    return 1;
}
