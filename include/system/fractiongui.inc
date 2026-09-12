#if defined _fractiongui_included
    #endinput
#endif
#define _fractiongui_included

#define FRACGUIID 46
#define FRACDOCMAX 32

#if !defined NOTIFICATION_ID_FRAC_INVITE
    #define NOTIFICATION_ID_FRAC_INVITE (1306)
#endif

forward Fracdocsload(playerid, teamid);
forward Fracctrlload(playerid, teamid);
forward Fracplayerdb(playerid, uid, teamid);
forward Fracplayeract(playerid, uid, actionid, changeid, teamid);

new fracpayload[16384];
new fracpiece[512];
new fracname[64];
new fracescaped[128];
new fracnp[8192];
new fracrs[8192];
new fracchosen[MAX_PLAYERS];
new fracdocs[FRACDOCMAX];
new fractestdoc[MAX_PLAYERS];
new fractestpos[MAX_PLAYERS];
new fractestok[MAX_PLAYERS];
new fractesttotal[MAX_PLAYERS];

stock Fracnotifykmonarch(playerid, sid, text[])
{
    ShowNotificationNew(playerid, 1, 4, sid, 0, text, "ОК");
    return 1;
}

stock FracInviteSend(playerid, to_player)
{
    if (!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG))
    {
        return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
    }

    if (GetPlayerJob(playerid) != 10)
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна только лидеру фракции");
    }

    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
    }

    if (1 <= GetPlayerTeamEx(to_player) < MAX_ORG)
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок уже состоит в организации");
    }

    if (GetPlayerData(to_player, P_WARN))
    {
        return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть предупреждения");
    }

    if (!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0))
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");
    }

    if (GetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER) != INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {FF9900}/cancel {FFFFFF}чтобы отозвать предыдущее предложение");
    }

    SendPlayerOffer(playerid, to_player, OFFER_TYPE_INVITE);

    new caption[160];
    format(caption, sizeof(caption), "%s приглашает Вас во фракцию \"%s\"", GetPlayerNameEx(playerid), GetPlayerTeamName(playerid));
    ShowNotificationNew(to_player, 4, 6, NOTIFICATION_ID_FRAC_INVITE, playerid, caption, "Да");
    return 1;
}

stock FracInviteAccept(playerid, inviterid)
{
    new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);
    new offer_type = GetPlayerOfferInfo(playerid, O_INCOMING_TYPE);

    if (offer_id == INVALID_PLAYER_ID || offer_type != OFFER_TYPE_INVITE || offer_id != inviterid)
    {
        ClearPlayerOffer(playerid);
        return Fracnotifykmonarch(playerid, 4611, "Приглашение во фракцию уже не активно");
    }

    if (!IsPlayerConnected(offer_id) || !IsPlayerLogged(offer_id))
    {
        ClearPlayerOffer(playerid);
        return Fracnotifykmonarch(playerid, 4612, "Лидер вышел из игры");
    }

    if (GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) != playerid)
    {
        ClearPlayerOffer(playerid);
        return Fracnotifykmonarch(playerid, 4613, "Приглашение во фракцию уже не активно");
    }

    new teamid = GetPlayerTeamEx(offer_id);
    if (!(1 <= teamid < MAX_ORG))
    {
        ClearPlayerOffer(offer_id);
        ClearPlayerOffer(playerid);
        return Fracnotifykmonarch(playerid, 4614, "Фракция лидера не найдена");
    }

    if (1 <= GetPlayerTeamEx(playerid) < MAX_ORG)
    {
        ClearPlayerOffer(offer_id);
        ClearPlayerOffer(playerid);
        return Fracnotifykmonarch(playerid, 4615, "Вы уже состоите в организации");
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(offer_id, x, y, z);

    if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 10.0)
    {
        ClearPlayerOffer(offer_id);
        ClearPlayerOffer(playerid);
        return Fracnotifykmonarch(playerid, 4616, "Лидер слишком далеко");
    }

    ClearPlayerOffer(offer_id);
    ClearPlayerOffer(playerid);

    InvitePlayer(playerid, teamid, 1, true);

    new msg[160];
    format(msg, sizeof(msg), "Поздравляем! Вы вступили во фракцию \"%s\"", GetTeamName(teamid));
    SendClientMessage(playerid, 0x66CC00FF, msg);

    format(msg, sizeof(msg), "%s принял приглашение во фракцию", GetPlayerNameEx(playerid));
    SendClientMessage(offer_id, 0x66CC00FF, msg);
    GameTextForPlayer(offer_id, "~b~~h~yes", 4000, 1);

    format(msg, sizeof(msg), "Принял %s[acc:%d] во фракцию %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), GetTeamName(teamid));
    SendLog(offer_id, LOG_TYPE_FRACTION, msg);
    Fracmainkmonarch(playerid, 1);
    return 1;
}

stock FracInviteDecline(playerid, inviterid)
{
    new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);
    new offer_type = GetPlayerOfferInfo(playerid, O_INCOMING_TYPE);

    if (offer_id != INVALID_PLAYER_ID && offer_type == OFFER_TYPE_INVITE && offer_id == inviterid)
    {
        if (GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) == playerid)
        {
            ClearPlayerOffer(offer_id);

            new msg[96];
            format(msg, sizeof(msg), "%s отказался от приглашения во фракцию", GetPlayerNameEx(playerid));
            SendClientMessage(offer_id, 0xFF6600FF, msg);
            GameTextForPlayer(offer_id, "~r~no", 4000, 1);
        }
    }

    ClearPlayerOffer(playerid);
    return 1;
}
stock Fracfractionidkmonarch(teamid)
{
    switch (teamid)
    {
        case 1..7, 11: return teamid;
    }

    return 0;
}

stock Fracesckmonarch(const source[], destination[], size)
{
    new w = 0;

    for (new r = 0; source[r] != '\0' && w < size - 1; r++)
    {
        switch (source[r])
        {
            case '\\', '"':
            {
                if (w >= size - 2)
                {
                    break;
                }

                destination[w++] = '\\';
                destination[w++] = source[r];
            }
            case '\n':
            {
                if (w >= size - 2)
                {
                    break;
                }

                destination[w++] = '\\';
                destination[w++] = 'n';
            }
            case '\r':
            {
                if (w >= size - 2)
                {
                    break;
                }

                destination[w++] = '\\';
                destination[w++] = 'r';
            }
            case '\t':
            {
                if (w >= size - 2)
                {
                    break;
                }

                destination[w++] = '\\';
                destination[w++] = 't';
            }
            default: destination[w++] = source[r];
        }
    }

    destination[w] = '\0';
    return 1;
}

stock Fracsendkmonarch(playerid, const payload[])
{
    new BitStream:bitstream = BS_New();

    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, FRACGUIID);
    BS_WriteValue(bitstream, PR_UINT32, strlen(payload));
    BS_WriteValue(bitstream, PR_STRING, payload);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
    return 1;
}

stock Fracensurekmonarch()
{
    static bool:done = false;

    if (done)
    {
        return 1;
    }

    done = true;

    mysql_query
    (
        mysql,
        "CREATE TABLE IF NOT EXISTS `fraction_documents` (\
        `uid` INT NOT NULL,\
        `fraction_id` INT NOT NULL,\
        `document_id` INT NOT NULL DEFAULT 0,\
        `document_number` INT NOT NULL DEFAULT 0,\
        `acquainted` INT NOT NULL DEFAULT 1,\
        PRIMARY KEY (`uid`,`fraction_id`,`document_number`),\
        KEY `uid` (`uid`)\
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci",
        false
    );

    return 1;
}

stock Fracfindkmonarch(const json[], const key[])
{
    new pattern[48];
    format(pattern, sizeof(pattern), "\"%s\":", key);

    new plen = strlen(pattern);
    new jlen = strlen(json);

    for (new i = 0; i <= jlen - plen; i++)
    {
        if (!strcmp(json[i], pattern, true, plen))
        {
            i += plen;

            while (json[i] == ' ' || json[i] == '\t')
            {
                i++;
            }

            return i;
        }
    }

    return -1;
}

stock bool:Fracintkmonarch(const json[], const key[], &value)
{
    new pos = Fracfindkmonarch(json, key);
    if (pos == -1)
    {
        return false;
    }

    new sign = 1;
    if (json[pos] == '-')
    {
        sign = -1;
        pos++;
    }

    if (!(json[pos] >= '0' && json[pos] <= '9'))
    {
        return false;
    }

    value = 0;

    while (json[pos] >= '0' && json[pos] <= '9')
    {
        value = (value * 10) + (json[pos] - '0');
        pos++;
    }

    value *= sign;
    return true;
}

stock Fracutfkmonarch(const source[], destination[], size)
{
    new r = 0;
    new w = 0;

    while (source[r] != '\0' && w < size - 1)
    {
        new cur = source[r] & 0xFF;

        if (cur == 0xD0 && source[r + 1] != '\0')
        {
            new nxt = source[r + 1] & 0xFF;

            if (nxt == 0x81)
            {
                destination[w++] = 0xA8;
                r += 2;
                continue;
            }

            if (nxt >= 0x90 && nxt <= 0xBF)
            {
                destination[w++] = nxt + 0x30;
                r += 2;
                continue;
            }
        }
        else if (cur == 0xD1 && source[r + 1] != '\0')
        {
            new nxt = source[r + 1] & 0xFF;

            if (nxt == 0x91)
            {
                destination[w++] = 0xB8;
                r += 2;
                continue;
            }

            if (nxt >= 0x80 && nxt <= 0x8F)
            {
                destination[w++] = nxt + 0x70;
                r += 2;
                continue;
            }
        }

        destination[w++] = source[r++];
    }

    destination[w] = '\0';
    return 1;
}

stock bool:Fracstrkmonarch(const json[], const key[], output[], size)
{
    new pos = Fracfindkmonarch(json, key);
    if (pos == -1 || json[pos] != '"')
    {
        output[0] = '\0';
        return false;
    }

    pos++;

    new w = 0;
    while (json[pos] != '\0' && json[pos] != '"' && w < size - 1)
    {
        if (json[pos] == '\\' && json[pos + 1] != '\0')
        {
            pos++;

            switch (json[pos])
            {
                case 'n': output[w++] = '\n';
                case 'r': output[w++] = '\r';
                case 't': output[w++] = '\t';
                default: output[w++] = json[pos];
            }

            pos++;
            continue;
        }

        output[w++] = json[pos++];
    }

    output[w] = '\0';
    Fracutfkmonarch(output, output, size);
    return true;
}

stock Fracuidkmonarch(uid)
{
    foreach (new i : Player)
    {
        if (!IsPlayerLogged(i))
        {
            continue;
        }

        if (GetPlayerAccountID(i) == uid)
        {
            return i;
        }
    }

    return INVALID_PLAYER_ID;
}

stock Fraconlinekmonarch(uid)
{
    return Fracuidkmonarch(uid) != INVALID_PLAYER_ID;
}

stock Fracranknamekmonarch(teamid, rankid, output[], size)
{
    if (rankid < 1 || rankid > 10)
    {
        rankid = 1;
    }

    format(output, size, GetTeamRankName(teamid, rankid));
    return 1;
}

stock Fracmainkmonarch(playerid, openid = 0)
{
    new teamid = GetPlayerTeamEx(playerid);
    new fractionid = Fracfractionidkmonarch(teamid);
    new rankid = GetPlayerJob(playerid);
    new status[10];

    if (rankid < 1 || rankid > 10)
    {
        rankid = 1;
    }

    for (new i = 0; i < 10; i++)
    {
        new rowrank = i + 1;

        if (rowrank < rankid)
        {
            status[i] = 4;
        }
        else if (rowrank == rankid)
        {
            status[i] = 1;
        }
        else if (rowrank == rankid + 1)
        {
            status[i] = 5;
        }
        else
        {
            status[i] = 0;
        }
    }

    format
    (
        fracpayload,
        sizeof(fracpayload),
        "%s\"page\":1,\"fraction_id\":%d,\"fraction_tokens\":1,\"fraction_tokens_value\":0,\"token_price\":0,\"rank_status\":[%d,%d,%d,%d,%d,%d,%d,%d,%d,%d],\"rank_progress\":[0,0]}",
        openid ? ("{\"o\":1,") : ("{"),
        fractionid,
        status[0], status[1], status[2], status[3], status[4],
        status[5], status[6], status[7], status[8], status[9]
    );
    Fracsendkmonarch(playerid, fracpayload);
    return 1;
}

stock Fracdocskmonarch(playerid)
{
    new query[160];
    new teamid = GetPlayerTeamEx(playerid);

    Fracensurekmonarch();

    mysql_format
    (
        mysql,
        query,
        sizeof(query),
        "SELECT `document_number`,`acquainted` FROM `fraction_documents` WHERE `uid`=%d AND `fraction_id`=%d ORDER BY `document_number` ASC",
        GetPlayerAccountID(playerid),
        teamid
    );
    mysql_tquery(mysql, query, "Fracdocsload", "dd", playerid, teamid);
    return 1;
}

stock Fraccontrolkmonarch(playerid)
{
    new query[160];
    new teamid = GetPlayerTeamEx(playerid);

    mysql_format
    (
        mysql,
        query,
        sizeof(query),
        "SELECT `id`,`name`,`job` FROM `accounts` WHERE `team`=%d ORDER BY `job` DESC, `name` ASC LIMIT 200",
        teamid
    );
    mysql_tquery(mysql, query, "Fracctrlload", "dd", playerid, teamid);
    return 1;
}

stock Fracplayerkmonarch(playerid, uid)
{
    new target = Fracuidkmonarch(uid);
    new teamid = GetPlayerTeamEx(playerid);

    fracchosen[playerid] = uid;

    if (target != INVALID_PLAYER_ID)
    {
        Fracranknamekmonarch(teamid, GetPlayerJob(target), fracname, sizeof(fracname));
        Fracesckmonarch(GetPlayerNameEx(target), fracescaped, sizeof(fracescaped));
        Fracesckmonarch(fracname, fracpiece, sizeof(fracpiece));

        format
        (
            fracpayload,
            sizeof(fracpayload),
            "{\"page\":9,\"type\":2,\"nickname\":\"%s\",\"skin_id\":%d,\"level\":%d,\"rank_name\":\"%s\",\"rank\":%d,\"reprimand\":%d,\"phone\":\"%d\"}",
            fracescaped,
            GetPlayerData(target, P_OSKIN),
            GetPlayerLevel(target),
            fracpiece,
            GetPlayerJob(target),
            GetPlayerData(target, P_OWARN),
            GetPlayerPhone(target)
        );
        Fracsendkmonarch(playerid, fracpayload);
        return 1;
    }

    new query[192];
    mysql_format
    (
        mysql,
        query,
        sizeof(query),
        "SELECT `id`,`name`,`level`,`phone`,`job`,`owarn`,`org_skin`,`team` FROM `accounts` WHERE `id`=%d AND `team`=%d LIMIT 1",
        uid,
        teamid
    );
    mysql_tquery(mysql, query, "Fracplayerdb", "ddd", playerid, uid, teamid);
    return 1;
}

stock Fracquestkmonarch(playerid)
{
    format(fracpayload, sizeof(fracpayload), "{\"page\":3,\"taskRank\":%d}", GetPlayerJob(playerid));
    Fracsendkmonarch(playerid, fracpayload);
    return 1;
}

stock Fracshopkmonarch(playerid)
{
    format(fracpayload, sizeof(fracpayload), "{\"page\":8,\"fraction_tokens\":1,\"fraction_tokens_value\":0,\"token_price\":0}");
    Fracsendkmonarch(playerid, fracpayload);
    return 1;
}

stock FracTestCountkmonarch(docid)
{
    switch (docid)
    {
        case 1: return 2;
        case 2: return 10;
        case 3: return 2;
        case 4: return 13;
        case 5: return 2;
        case 6: return 10;
        case 7: return 6;
        case 8: return 2;
        case 9: return 10;
        case 10: return 9;
        case 11: return 5;
        case 12: return 2;
        case 13: return 11;
        case 14: return 10;
        case 15: return 6;
        case 16: return 2;
        case 17: return 11;
        case 18: return 10;
        case 19: return 6;
        case 20: return 2;
        case 21: return 11;
        case 22: return 10;
        case 23: return 6;
        case 24: return 2;
        case 25: return 13;
    }

    return 0;
}

stock FracTestCorrectkmonarch(docid, indexid)
{
    switch (docid)
    {
        case 1:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 2:
        {
            switch (indexid)
            {
                case 0: return 2;
                case 1: return 1;
                case 2: return 3;
                case 3: return 3;
                case 4: return 4;
                case 5: return 2;
                case 6: return 3;
                case 7: return 1;
                case 8: return 4;
                case 9: return 4;
            }
        }
        case 3:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 4:
        {
            switch (indexid)
            {
                case 0: return 4;
                case 1: return 3;
                case 2: return 1;
                case 3: return 2;
                case 4: return 4;
                case 5: return 3;
                case 6: return 3;
                case 7: return 1;
                case 8: return 2;
                case 9: return 4;
                case 10: return 3;
                case 11: return 3;
                case 12: return 1;
            }
        }
        case 5:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 6:
        {
            switch (indexid)
            {
                case 0: return 2;
                case 1: return 1;
                case 2: return 2;
                case 3: return 3;
                case 4: return 4;
                case 5: return 1;
                case 6: return 2;
                case 7: return 1;
                case 8: return 4;
                case 9: return 2;
            }
        }
        case 7:
        {
            switch (indexid)
            {
                case 0: return 4;
                case 1: return 2;
                case 2: return 1;
                case 3: return 3;
                case 4: return 1;
                case 5: return 4;
            }
        }
        case 8:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 9:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 4;
                case 3: return 2;
                case 4: return 1;
                case 5: return 3;
                case 6: return 1;
                case 7: return 2;
                case 8: return 3;
                case 9: return 4;
            }
        }
        case 10:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
                case 2: return 1;
                case 3: return 4;
                case 4: return 2;
                case 5: return 3;
                case 6: return 1;
                case 7: return 4;
                case 8: return 2;
            }
        }
        case 11:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 2;
                case 3: return 4;
                case 4: return 3;
            }
        }
        case 12:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 13:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 4;
                case 3: return 3;
                case 4: return 1;
                case 5: return 2;
                case 6: return 4;
                case 7: return 3;
                case 8: return 1;
                case 9: return 2;
                case 10: return 3;
            }
        }
        case 14:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 2;
                case 3: return 4;
                case 4: return 3;
                case 5: return 3;
                case 6: return 1;
                case 7: return 2;
                case 8: return 4;
                case 9: return 1;
            }
        }
        case 15:
        {
            switch (indexid)
            {
                case 0: return 2;
                case 1: return 3;
                case 2: return 1;
                case 3: return 4;
                case 4: return 2;
                case 5: return 1;
            }
        }
        case 16:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 17:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 4;
                case 3: return 3;
                case 4: return 1;
                case 5: return 2;
                case 6: return 4;
                case 7: return 3;
                case 8: return 1;
                case 9: return 2;
                case 10: return 2;
            }
        }
        case 18:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 2;
                case 3: return 4;
                case 4: return 3;
                case 5: return 3;
                case 6: return 1;
                case 7: return 2;
                case 8: return 4;
                case 9: return 1;
            }
        }
        case 19:
        {
            switch (indexid)
            {
                case 0: return 2;
                case 1: return 3;
                case 2: return 1;
                case 3: return 4;
                case 4: return 2;
                case 5: return 1;
            }
        }
        case 20:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 21:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 4;
                case 3: return 3;
                case 4: return 1;
                case 5: return 2;
                case 6: return 4;
                case 7: return 3;
                case 8: return 1;
                case 9: return 2;
                case 10: return 4;
            }
        }
        case 22:
        {
            switch (indexid)
            {
                case 0: return 3;
                case 1: return 1;
                case 2: return 2;
                case 3: return 4;
                case 4: return 3;
                case 5: return 3;
                case 6: return 1;
                case 7: return 2;
                case 8: return 4;
                case 9: return 1;
            }
        }
        case 23:
        {
            switch (indexid)
            {
                case 0: return 2;
                case 1: return 3;
                case 2: return 1;
                case 3: return 4;
                case 4: return 2;
                case 5: return 1;
            }
        }
        case 24:
        {
            switch (indexid)
            {
                case 0: return 1;
                case 1: return 3;
            }
        }
        case 25:
        {
            switch (indexid)
            {
                case 0: return 4;
                case 1: return 2;
                case 2: return 3;
                case 3: return 1;
                case 4: return 2;
                case 5: return 3;
                case 6: return 4;
                case 7: return 2;
                case 8: return 1;
                case 9: return 3;
                case 10: return 1;
                case 11: return 4;
                case 12: return 2;
            }
        }
    }

    return 0;
}


stock FracTestAnswerkmonarch(playerid, answerid)
{
    new total = fractesttotal[playerid];

    if (total <= 0)
    {
        total = FracTestCountkmonarch(fractestdoc[playerid]);
        fractesttotal[playerid] = total;
    }

    if (total <= 0)
    {
        return Fractestresultkmonarch(playerid, 0, 0, 1);
    }

    new indexid = fractestpos[playerid];
    new correct = FracTestCorrectkmonarch(fractestdoc[playerid], indexid);

    if (answerid == correct)
    {
        fractestok[playerid]++;
    }

    fractestpos[playerid]++;

    if (fractestpos[playerid] >= total)
    {
        new passed = fractestok[playerid] == total ? 1 : 0;
        new right = fractestok[playerid];

        fractestdoc[playerid] = 0;
        fractestpos[playerid] = 0;
        fractestok[playerid] = 0;
        fractesttotal[playerid] = 0;

        return Fractestresultkmonarch(playerid, passed, right, total);
    }

    return 1;
}
stock Fractestresultkmonarch(playerid, positive = 1, total = 1, questions = 1)
{
    format
    (
        fracpayload,
        sizeof(fracpayload),
        "{\"page\":6,\"testing_result\":%d,\"testing_total\":%d,\"question_total\":%d}",
        positive,
        total,
        questions
    );
    Fracsendkmonarch(playerid, fracpayload);
    return 1;
}

stock Fracbuydialogkmonarch(playerid, bcvalue = 0)
{
    format(fracpayload, sizeof(fracpayload), "{\"page\":7,\"type\":2,\"bc_value\":%d,\"token_price\":0}", bcvalue);
    Fracsendkmonarch(playerid, fracpayload);
    return 1;
}

stock Fracrewardkmonarch(playerid)
{
    if (GetPlayerJob(playerid) < 10)
    {
        return Fracnotifykmonarch(playerid, 4601, "Доступно только лидеру");
    }

    return Fracnotifykmonarch(playerid, 4602, "Лидер назначается через /setleader");
}

stock Fracdocsetkmonarch(playerid, docid, docnum)
{
    new query[256];
    new teamid = GetPlayerTeamEx(playerid);

    fractestdoc[playerid] = docid;
    fractestpos[playerid] = 0;
    fractestok[playerid] = 0;
    fractesttotal[playerid] = FracTestCountkmonarch(docid);
    Fracensurekmonarch();

    mysql_format
    (
        mysql,
        query,
        sizeof(query),
        "INSERT INTO `fraction_documents` (`uid`,`fraction_id`,`document_id`,`document_number`,`acquainted`) VALUES (%d,%d,%d,%d,1) \
        ON DUPLICATE KEY UPDATE `document_id`=%d,`acquainted`=1",
        GetPlayerAccountID(playerid),
        teamid,
        docid,
        docnum,
        docid
    );
    mysql_query(mysql, query, false);
    format(fracpayload, sizeof(fracpayload), "{\"page\":5}");
    Fracsendkmonarch(playerid, fracpayload);
    return 1;
}

stock Fracactkmonarch(playerid, actionid, changeid)
{
    new uid = fracchosen[playerid];

    if (uid <= 0)
    {
        return 1;
    }

    new query[224];
    new teamid = GetPlayerTeamEx(playerid);

    mysql_format
    (
        mysql,
        query,
        sizeof(query),
        "SELECT `id`,`name`,`job`,`owarn`,`phone`,`level`,`org_skin`,`sex`,`team` FROM `accounts` WHERE `id`=%d AND `team`=%d LIMIT 1",
        uid,
        teamid
    );
    mysql_tquery(mysql, query, "Fracplayeract", "ddddd", playerid, uid, actionid, changeid, teamid);
    return 1;
}

stock Fracopenkmonarch(playerid)
{
    new teamid = GetPlayerTeamEx(playerid);

    if (teamid < 1 || teamid >= MAX_ORG)
    {
        return Fracnotifykmonarch(playerid, 4600, "Вы не состоите во фракции");
    }

    if (!Fracfractionidkmonarch(teamid))
    {
        return Fracnotifykmonarch(playerid, 4610, "Меню доступно только для гос. фракций");
    }

    fracchosen[playerid] = 0;
    Fracmainkmonarch(playerid, 1);
    return 1;
}

stock FracHandlekmonarch(playerid, const data[])
{
    new pageid;
    new buttonid;
    new changeid;
    new uid;
    new docid;
    new docnum;
    new typeid;
    new amount;

    if (!Fracintkmonarch(data, "page", pageid))
    {
        return 1;
    }

    Fracintkmonarch(data, "button", buttonid);
    Fracintkmonarch(data, "type", typeid);

    switch (buttonid)
    {
        case 1: return 1;
        case 3: return Fracshopkmonarch(playerid);
        case 4: return Fraccontrolkmonarch(playerid);
        case 5: return Fracdocskmonarch(playerid);
        case 6: return Fracquestkmonarch(playerid);
        case 7: return Fracrewardkmonarch(playerid);
        case 8: return Fracmainkmonarch(playerid);
        case 9:
        {
            if (pageid == 4)
            {
                if (Fracintkmonarch(data, "document_id", docid) && Fracintkmonarch(data, "document_number", docnum))
                {
                    return Fracdocsetkmonarch(playerid, docid, docnum);
                }
            }
            return 1;
        }
        case 10:
        {
            return Fracnotifykmonarch(playerid, 4603, "Квесты в разработке");
        }
        case 11: return Fracmainkmonarch(playerid);
        case 12: return Fracdocskmonarch(playerid);
        case 13:
        {
            new answerid;
            Fracintkmonarch(data, "answer_id", answerid);
            return FracTestAnswerkmonarch(playerid, answerid);
        }
        case 14:
        {
            if (pageid == 7)
            {
                Fracnotifykmonarch(playerid, 4604, "Покупка токенов в разработке");
            }
            return 1;
        }
        case 15:
        {
            if (Fracintkmonarch(data, "account_id", uid))
            {
                return Fracplayerkmonarch(playerid, uid);
            }
            return 1;
        }
        case 16:
        {
            Fracintkmonarch(data, "change", changeid);
            return Fracactkmonarch(playerid, 16, changeid);
        }
        case 17:
        {
            Fracintkmonarch(data, "change", changeid);
            return Fracactkmonarch(playerid, 17, changeid);
        }
        case 18: return Fracactkmonarch(playerid, 18, 0);
        case 20:
        {
            return Fracnotifykmonarch(playerid, 4605, "Магазин фракции в разработке");
        }
        case 21: return 1;
    }

    if (pageid == 7 && typeid == 1 && Fracintkmonarch(data, "token_amount", amount))
    {
        if (amount < 0)
        {
            amount = 0;
        }
        return Fracbuydialogkmonarch(playerid, amount);
    }

    return 1;
}

public Fracdocsload(playerid, teamid)
{
    #pragma unused teamid

    for (new i = 0; i < FRACDOCMAX; i++)
    {
        fracdocs[i] = 0;
    }

    for (new row = 0; row < cache_num_rows(); row++)
    {
        new num = cache_get_field_content_int(row, "document_number");
        if (num >= 0 && num < FRACDOCMAX)
        {
            fracdocs[num] = cache_get_field_content_int(row, "acquainted") ? 1 : 0;
        }
    }

    format(fracpayload, sizeof(fracpayload), "{\"page\":4,\"document_status\":[");

    for (new i = 0; i < FRACDOCMAX; i++)
    {
        format(fracpiece, sizeof(fracpiece), "%s%d", i ? "," : "", fracdocs[i]);
        strcat(fracpayload, fracpiece, sizeof(fracpayload));
    }

    strcat(fracpayload, "]}", sizeof(fracpayload));
    Fracsendkmonarch(playerid, fracpayload);
    return 1;
}

public Fracctrlload(playerid, teamid)
{
    fracnp[0] = '\0';
    fracrs[0] = '\0';

    strcat(fracnp, "[", sizeof(fracnp));
    strcat(fracrs, "[", sizeof(fracrs));

    for (new row = 0; row < cache_num_rows(); row++)
    {
        new uid = cache_get_field_content_int(row, "id");
        new rankid = cache_get_field_content_int(row, "job");
        new online = Fraconlinekmonarch(uid) ? 1 : 0;

        cache_get_field_content(row, "name", fracname, mysql, sizeof(fracname));
        Fracesckmonarch(fracname, fracescaped, sizeof(fracescaped));

        format(fracpiece, sizeof(fracpiece), "%s\"%s\"", row ? "," : "", fracescaped);
        strcat(fracnp, fracpiece, sizeof(fracnp));

        format(fracpiece, sizeof(fracpiece), "%s%d,%d,%d", row ? "," : "", uid, rankid, online);
        strcat(fracrs, fracpiece, sizeof(fracrs));
    }

    strcat(fracnp, "]", sizeof(fracnp));
    strcat(fracrs, "]", sizeof(fracrs));

    format
    (
        fracpayload,
        sizeof(fracpayload),
        "{\"t\":4,\"page\":9,\"type\":1,\"np\":%s,\"rs\":%s}",
        fracnp,
        fracrs
    );
    Fracsendkmonarch(playerid, fracpayload);

    if (cache_num_rows() > 0)
    {
        fracchosen[playerid] = cache_get_field_content_int(0, "id");
        Fracplayerkmonarch(playerid, fracchosen[playerid]);
    }

    #pragma unused teamid
    return 1;
}

public Fracplayerdb(playerid, uid, teamid)
{
    if (!cache_num_rows())
    {
        return 1;
    }

    new rankid = cache_get_field_content_int(0, "job");
    new skinid = cache_get_field_content_int(0, "org_skin");
    new levelid = cache_get_field_content_int(0, "level");
    new owarn = cache_get_field_content_int(0, "owarn");
    new phone = cache_get_field_content_int(0, "phone");

    cache_get_field_content(0, "name", fracname, mysql, sizeof(fracname));
    Fracesckmonarch(fracname, fracescaped, sizeof(fracescaped));
    Fracranknamekmonarch(teamid, rankid, fracname, sizeof(fracname));
    Fracesckmonarch(fracname, fracpiece, sizeof(fracpiece));

    format
    (
        fracpayload,
        sizeof(fracpayload),
        "{\"page\":9,\"type\":2,\"nickname\":\"%s\",\"skin_id\":%d,\"level\":%d,\"rank_name\":\"%s\",\"rank\":%d,\"reprimand\":%d,\"phone\":\"%d\"}",
        fracescaped,
        skinid,
        levelid,
        fracpiece,
        rankid,
        owarn,
        phone
    );
    Fracsendkmonarch(playerid, fracpayload);

    #pragma unused uid
    return 1;
}

public Fracplayeract(playerid, uid, actionid, changeid, teamid)
{
    if (!cache_num_rows())
    {
        return 1;
    }

    if (GetPlayerJob(playerid) < 10)
    {
        return Fracnotifykmonarch(playerid, 4606, "Действие доступно только лидеру");
    }

    new rankid = cache_get_field_content_int(0, "job");
    new owarn = cache_get_field_content_int(0, "owarn");
    new target = Fracuidkmonarch(uid);

    if (rankid >= 10)
    {
        return Fracnotifykmonarch(playerid, 4607, "Нельзя изменять лидера");
    }

    switch (actionid)
    {
        case 16:
        {
            new newrank = rankid;
            new sexid = cache_get_field_content_int(0, "sex");
            new skinid;

            if (changeid == 1)
            {
                if (newrank >= 9)
                {
                    return Fracnotifykmonarch(playerid, 4608, "Максимальный ранг 9");
                }
                newrank++;
            }
            else
            {
                if (newrank <= 1)
                {
                    return Fracnotifykmonarch(playerid, 4609, "Минимальный ранг 1");
                }
                newrank--;
            }

            if (!sexid)
            {
                skinid = GetTeamData(teamid, O_SKINS)[newrank - 1];
            }
            else
            {
                skinid = GetTeamData(teamid, O_WOMEN_SKIN);
            }

            format(fracpayload, sizeof(fracpayload), "UPDATE accounts SET job=%d,org_skin=%d WHERE id=%d", newrank, skinid, uid);
            mysql_query(mysql, fracpayload, false);

            if (target != INVALID_PLAYER_ID)
            {
                SetPlayerData(target, P_JOB, newrank);

                if (!GetPlayerSex(target))
                {
                    SetPlayerData(target, P_OSKIN, GetTeamData(teamid, O_SKINS)[newrank - 1]);
                }
                else
                {
                    SetPlayerData(target, P_OSKIN, GetTeamData(teamid, O_WOMEN_SKIN));
                }

                ResetSkin(target);
            }

            Fracranknamekmonarch(teamid, newrank, fracname, sizeof(fracname));
            Fracesckmonarch(fracname, fracescaped, sizeof(fracescaped));

            format
            (
                fracpayload,
                sizeof(fracpayload),
                "{\"page\":9,\"type\":3,\"new_rank\":%d,\"new_rank_name\":\"%s\"}",
                newrank,
                fracescaped
            );
            Fracsendkmonarch(playerid, fracpayload);
            return 1;
        }
        case 17:
        {
            new newwarn = owarn;

            if (changeid == 1)
            {
                newwarn++;
            }
            else if (newwarn > 0)
            {
                newwarn--;
            }

            if (newwarn >= 3)
            {
                if (target != INVALID_PLAYER_ID)
                {
                    SetPlayerData(target, P_OWARN, 0);
                    InvitePlayer(target, 0, 0, true);
                }
                else
                {
                    format(fracpayload, sizeof(fracpayload), "UPDATE accounts SET owarn=0,team=0,job=0,org_skin=0 WHERE id=%d", uid);
                    mysql_query(mysql, fracpayload, false);
                }

                fracchosen[playerid] = 0;
                format(fracpayload, sizeof(fracpayload), "{\"page\":9,\"type\":5,\"dismissed_account_id\":%d}", uid);
                Fracsendkmonarch(playerid, fracpayload);
                return 1;
            }

            format(fracpayload, sizeof(fracpayload), "UPDATE accounts SET owarn=%d WHERE id=%d", newwarn, uid);
            mysql_query(mysql, fracpayload, false);

            if (target != INVALID_PLAYER_ID)
            {
                SetPlayerData(target, P_OWARN, newwarn);
            }

            format
            (
                fracpayload,
                sizeof(fracpayload),
                "{\"page\":9,\"type\":4,\"reprimand\":%d}",
                newwarn
            );
            Fracsendkmonarch(playerid, fracpayload);
            return 1;
        }
        case 18:
        {
            if (target != INVALID_PLAYER_ID)
            {
                UnInvite(playerid, target, "GUI");
            }
            else
            {
                format(fracpayload, sizeof(fracpayload), "UPDATE accounts SET owarn=0,team=0,job=0,org_skin=0 WHERE id=%d", uid);
                mysql_query(mysql, fracpayload, false);
            }

            fracchosen[playerid] = 0;
            format(fracpayload, sizeof(fracpayload), "{\"page\":9,\"type\":5,\"dismissed_account_id\":%d}", uid);
            Fracsendkmonarch(playerid, fracpayload);
            return 1;
        }
    }

    return 1;
}
