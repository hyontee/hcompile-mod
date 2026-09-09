#define FINE_STATION_X          -276.2394
#define FINE_STATION_Y          1102.4607
#define FINE_STATION_Z          12.0392

CMD:attach(playerid, params[])
{
    if(!IsPlayerInPoliceTeam(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");

    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

    new currentVehicle = GetPlayerVehicleID(playerid);

    if(GetVehicleModel(currentVehicle) != 525)
        return SendClientMessage(playerid, 0xCECECEFF, "Для эвакуации вам необходим служебный эвакуатор!");

    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    new Float:vX, Float:vY, Float:vZ;
    new Found = 0;
    new vid = 0;

    while((vid < MAX_VEHICLES) && (!Found))
    {
        vid++;
        if(!IsValidVehicle(vid) || vid == currentVehicle) continue;

        GetVehiclePos(vid, vX, vY, vZ);

        if((floatabs(pX - vX) < 6.0) && (floatabs(pY - vY) < 6.0) && (floatabs(pZ - vZ) < 6.0))
        {
            Found = 1;

            if(IsTrailerAttachedToVehicle(currentVehicle))
                DetachTrailerFromVehicle(currentVehicle);

            AttachTrailerToVehicle(vid, currentVehicle);

            SendClientMessage(playerid, 0x33AA33AA, "Транспорт успешно подцеплен! Езжайте на штраф стоянку и посигнальте.");
        }
    }

    if(!Found)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Поблизости нет подходящего транспорта для буксировки.");
    }
    return 1;
}

stock Mvd_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    #pragma unused oldkeys

    if((newkeys & KEY_CROUCH) && IsPlayerInAnyVehicle(playerid))
    {
        if(IsPlayerInPoliceTeam(playerid)
        && GetVehicleModel(GetPlayerVehicleID(playerid)) == 525)
        {
            if(IsPlayerInRangeOfPoint(playerid,
            8.0,
            FINE_STATION_X,
            FINE_STATION_Y,
            FINE_STATION_Z))
            {
                new currentVehicle = GetPlayerVehicleID(playerid);
                new attachedVehicle = GetVehicleTrailer(currentVehicle);

                if(!IsValidVehicle(attachedVehicle))
                {
                    return SendClientMessage(playerid,
                    0xFF3333FF,
                    "У эвакуатора нет транспорта.");
                }
                SetPVarInt(playerid,
                "EvacVehicleID",
                attachedVehicle);
                new ownerid = GetPVarInt(attachedVehicle, "ownerid");

                SetPVarInt(playerid,
                "ownerid",
                ownerid);

                Dialog(playerid,
                DIALOG_FINE_STATION,
                DIALOG_STYLE_INPUT,
                "Штрафстоянка",
                "{FFFFFF}Вы действительно хотите поставить этот ТС на штрафстоянку?\n\
                 Владельцу будет выписан штраф {FF3333}15.000 руб.\n\n\
                 {CCCCCC}Введите причину:",
                "Далее",
                "Отмена");

                return 1;
            }
        }
    }

    return 1;
}

stock Mvd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem

    switch(dialogid)
    {
        case DIALOG_FINE_STATION:
{
    if(!response)
        return 1;

    if(isnull(inputtext))
    {
        return SendClientMessage(playerid,
        0xFF3333FF,
        "Введите причину эвакуации!");
    }

    new currentVehicle = GetPlayerVehicleID(playerid);
    new attachedVehicle = GetPVarInt(playerid, "EvacVehicleID");

    if(!IsValidVehicle(attachedVehicle))
    {
        DeletePVar(playerid, "EvacVehicleID");

        return SendClientMessage(playerid,
        0xFF3333FF,
        "Ошибка: транспорт не найден.");
    }

    new carid = GetVehicleData(attachedVehicle, V_ACTION_ID);

    if(carid < 0)
    {
        return SendClientMessage(playerid,
        0xFF3333FF,
        "Не удалось определить транспорт.");
    }

    if(!IsOwnableCarOwned(carid))
    {
        return SendClientMessage(playerid,
        0xFF3333FF,
        "У транспорта отсутствует владелец.");
    }

    new owner_accid = GetOwnableCarData(carid, OC_OWNER_ID);

    CreateTicketByAccount(
        owner_accid,
        15000,
        "МВД",
        inputtext
    );

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i)
        && GetPlayerAccountID(i) == owner_accid)
        {
            SendClientMessage(i,
            0xFF3333FF,
            "[Штрафстоянка] Ваш транспорт эвакуирован сотрудником МВД.");

            break;
        }
    }

    if(GetVehicleTrailer(currentVehicle) == attachedVehicle)
    {
        DetachTrailerFromVehicle(currentVehicle);
    }

    DestroyVehicle(attachedVehicle);

    GivePlayerMoneyEx(playerid,
        5000,
        "Вознаграждение за эвакуацию ТС",
        true,
        true);

    new str[144];

    format(str, sizeof(str),
        "Вы эвакуировали транспорт. Владельцу выписан штраф 15.000 руб. Причина: %s",
        inputtext);

    SendClientMessage(playerid,
        0x66CC33FF,
        str);

    DeletePVar(playerid, "EvacVehicleID");

    return 1;
}
    }

    return 1;
}

stock CreateTicketByAccount(accountid, amount, issuer[], description[])
{
    new query[256];

    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO tickets (uid, amount, issuer, description, time) \
        VALUES (%d, %d, '%e', '%e', %d)",
        accountid,
        amount,
        issuer,
        description,
        gettime());

    mysql_tquery(mysql, query);

    return 1;
}
