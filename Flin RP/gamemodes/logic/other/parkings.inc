#define MAX_PARKING 50
enum e_parking
{
    p_mysql_id,
    Float:p_enter[4],
    Text3D:p_label,
    p_pickip_enter,
    p_area_enter
}
new ParkData[MAX_PARKING][e_parking],
    totalpark;

CMD:addpark(playerid, params[])
{
    if(p_info[playerid][admin] < 7) return 1;
    if(totalpark >= MAX_PARKING)
        return SendError(playerid, "Максимальное количество парковок уже создано.");

    new Float:Pos[3];
    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

    new Float:pA;
    GetPlayerFacingAngle(playerid, pA);

    ParkData[totalpark][p_enter][0] = Pos[0];
    ParkData[totalpark][p_enter][1] = Pos[1];
    ParkData[totalpark][p_enter][2] = Pos[2];
    ParkData[totalpark][p_enter][3] = pA;

    STRING_GLOBAL[0] = EOS;
    f(STRING_GLOBAL, "Парковка [ID: %d]\nНажмите: "W"ALT"I" для входа или въезда", totalpark);
    ParkData[totalpark][p_label] =
        CreateDynamic3DTextLabel(STRING_GLOBAL, COLOR_MAIN, ParkData[totalpark][p_enter][0], ParkData[totalpark][p_enter][1], ParkData[totalpark][p_enter][2],11.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, streamer_TESTLOL, totalpark, -1);
    ParkData[totalpark][p_pickip_enter] = CreateDynamicPickup(1318, 23, ParkData[totalpark][p_enter][0], ParkData[totalpark][p_enter][1], ParkData[totalpark][p_enter][2]);

    ParkData[totalpark][p_area_enter] = CreateDynamicSphere(ParkData[totalpark][p_enter][0], ParkData[totalpark][p_enter][1], ParkData[totalpark][p_enter][2], 2.0);
    UpdateAreaInfo(ParkData[totalpark][p_area_enter], TYPE_PARKING, AREA_SUBTYPE_INVALID_ID, totalpark);

    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `parkings` (`p_enterX`, `p_enterY`, `p_enterZ`, `p_enterA`) VALUES ('%f', '%f', '%f', '%f')",
        Pos[0], Pos[1], Pos[2], pA);
    mysql_tquery(con_bd, STRING_GLOBAL, "create_park","i", totalpark);
    if(SRV_ID == 0) WriteLog("update", STRING_GLOBAL);
    totalpark++;

    SendInfo(playerid, "Установите угол поворота при выходе из парковки: /spa");
    return 1;
}

forward create_park(i);
public create_park(i)
{
    ParkData[i][p_mysql_id] = cache_insert_id();
    return 1;
}

forward load_park();
public load_park()
{
    new rows, time = GetTickCount();

    cache_get_row_count(rows);
    if(rows)
    {
        for(new idx; idx < rows; idx++)
        {
            cache_get_value_name_int(idx, "p_mysql_id",ParkData[idx][p_mysql_id]);

            cache_get_value_name_float(idx, "p_enterX",ParkData[idx][p_enter][0]);
            cache_get_value_name_float(idx, "p_enterY",ParkData[idx][p_enter][1]);
            cache_get_value_name_float(idx, "p_enterZ",ParkData[idx][p_enter][2]);
            cache_get_value_name_float(idx, "p_enterA",ParkData[idx][p_enter][3]);

            STRING_GLOBAL[0] = EOS;
            f(STRING_GLOBAL, "Парковка [ID: %d]\nНажмите "W"ALT"I" для входа или въезда", idx);
            ParkData[idx][p_label] =
                CreateDynamic3DTextLabel(STRING_GLOBAL, COLOR_MAIN, ParkData[idx][p_enter][0], ParkData[idx][p_enter][1], ParkData[idx][p_enter][2],11.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, streamer_TESTLOL, -1, -1, -1);
            ParkData[idx][p_pickip_enter] = CreateDynamicPickup(1318, 23, ParkData[idx][p_enter][0], ParkData[idx][p_enter][1], ParkData[idx][p_enter][2]);

            ParkData[idx][p_area_enter] = CreateDynamicSphere(ParkData[idx][p_enter][0], ParkData[idx][p_enter][1], ParkData[idx][p_enter][2], 1.5);
            UpdateAreaInfo(ParkData[idx][p_area_enter], TYPE_PARKING, AREA_SUBTYPE_INVALID_ID, idx);

            totalpark++;
        }

    }
    printf("Парковок загружено: %i за %d мс",totalpark,GetTickCount()-time);
    return true;
}
