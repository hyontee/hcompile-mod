//>> Файл: bykranin_src/core/vehicle/ownable_14.inc  (489 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: SetVehicleDriftForPlayer, AddToVehicleComponentForPlayer, RemoveAllVehicleComponentsForPlayer, RemoveFromVehicleComponentForPlayer, IsVehicleStoreSelector, ResetVehicleStoreSelectorToStock, ResetOwnableCarSelectorToStock
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SetVehicleDriftForPlayer(playerid, vehicleid, value)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 5); 
	
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);  
	BS_WriteValue(bitstream, PR_UINT8, value);   

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}
#define RPC_VEHICLE_COMPONENT 168
#define VEH_COMP_SUBID        0x0F

// action:
// 0 = add
// 1 = remove all
// 2 = remove by slot
// 3 = remove component

stock AddToVehicleComponentForPlayer(playerid, vehicleid, componentid)
{
	if (componentid == 1008 || componentid == 1009 || componentid == 1010){
		SendCarFirmware(playerid, componentid);
		return 1;
	}
    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT8,  15); // 0x0F
    BS_WriteValue(bs, PR_UINT8,  0);              // action = ADD
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT16, componentid);

    PR_SendRPC(bs, playerid, RPC_VEHICLE_COMPONENT, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock RemoveAllVehicleComponentsForPlayer(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid) || !IsValidVehicle(vehicleid)) return 0;

    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT8,  15);
    BS_WriteValue(bs, PR_UINT8,  1); // action = REMOVE ALL
    BS_WriteValue(bs, PR_UINT16, vehicleid);

    PR_SendRPC(bs, playerid, RPC_VEHICLE_COMPONENT, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock RemoveFromVehicleComponentForPlayer(playerid, vehicleid, componentid)
{
    if(componentid <= 0) return 0;

    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT8,  15);
    BS_WriteValue(bs, PR_UINT8,  3);
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT16, componentid);

    PR_SendRPC(bs, playerid, RPC_VEHICLE_COMPONENT, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock IsVehicleStoreSelector(selector_id)
{
    switch(selector_id)
    {
        case 16, 17, 18, 19, 20, 21, 31, 43, 44, 45, 46, 47: return 1;
    }

    return 0;
}

stock ResetVehicleStoreSelectorToStock(playerid, vehicleid, database_id, selector_id)
{
    if(database_id <= 0 || !IsVehicleStoreSelector(selector_id)) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT componentid FROM vehicle_store_components WHERE vehicleid=%d AND state=2",
        database_id
    );
    mysql_query(mysql, query);

    new rows = cache_num_rows();
    new detail_item_id, componentid;
    new reset_item_ids[128], reset_count;

    for(new x = 0; x < rows; x++)
    {
        detail_item_id = cache_get_field_content_int(x, "componentid");
        if(GetTuneSelectorFromItem(detail_item_id) != selector_id) continue;

        componentid = (selector_id == 31) ? GetWheelTuneComponentId(detail_item_id) : GetTuneIdFromItem(detail_item_id);
        if(componentid > 0)
        {
            // Removed below through the custom CRMP component RPC.
            RemoveFromVehicleComponentForPlayer(playerid, vehicleid, componentid);
        }

        if(reset_count < sizeof(reset_item_ids))
        {
            reset_item_ids[reset_count++] = detail_item_id;
        }
    }

    for(new x = 0; x < reset_count; x++)
    {
        mysql_format(mysql, query, sizeof(query),
            "UPDATE vehicle_store_components SET state=0 WHERE vehicleid=%d AND componentid=%d",
            database_id,
            reset_item_ids[x]
        );
        mysql_query(mysql, query, false);
    }
    PermanentTuning_RebuildVehicleState(vehicleid);

    return 1;
}
stock ResetOwnableCarSelectorToStock(playerid, vehicleid, index, selector_id, database_id)
{
    if(index < 0 || database_id <= 0) return 0;

    new query[512];

    switch(selector_id)
    {
        case 0:
        {
            vInfo[index][body_colors] = 0;
            SetOwnableCarData(index, OC_body_colors, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET body_colors = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleColorHexForPlayers(playerid, vehicleid, vInfo[index][body_colors], vInfo[index][wheel_colors]);
            if(vInfo[index][wheel_colors] == 0)
            {
                ChangeVehicleColor(vehicleid, GetOwnableCarData(index, OC_COLOR_1), GetOwnableCarData(index, OC_COLOR_2));
            }
            return 1;
        }
        case 1, 32:
        {
            vInfo[index][wheel_colors] = 0;
            SetOwnableCarData(index, OC_wheelcolors, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_colors = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleColorHexForPlayers(playerid, vehicleid, vInfo[index][body_colors], vInfo[index][wheel_colors]);
            if(vInfo[index][body_colors] == 0)
            {
                ChangeVehicleColor(vehicleid, GetOwnableCarData(index, OC_COLOR_1), GetOwnableCarData(index, OC_COLOR_2));
            }
            return 1;
        }
        case 2:
        {
            vInfo[index][vinil_current] = 0;
            SetOwnableCarData(index, OC_vinil_current, 0);
            vInfo[index][vynil_name][0] = '\0';
            vInfo[index][vVinylTexture][0] = '\0';
            SetVehicleVinylForPlayer(playerid, vehicleid, "");
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET vinil_current = 0, vynil_name = '' WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            return 1;
        }
        case 3:
        {
            vInfo[index][tonir_ft] = 0;
            SetOwnableCarData(index, OC_tonir_ft, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tonir_ft = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            ApplyOwnableVehicleColors(vehicleid, index);
            return 1;
        }
        case 4:
        {
            vInfo[index][tonir_rr] = 0;
            SetOwnableCarData(index, OC_tonir_rr, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tonir_rr = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            ApplyOwnableVehicleColors(vehicleid, index);
            return 1;
        }
        case 7:
        {
            vInfo[index][horn_current] = 0;
            vInfo[index][vHornSound] = 0;
            vInfo[vehicleid][vHornSound] = 0;
            SetOwnableCarData(index, OC_horn_current, 0);
            SetOwnableCarData(index, OC_HORN, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET horn_current = 0, horn_id = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleHornSound(vehicleid, 0, 0);
            return 1;
        }
        case 9:
        {
            vInfo[index][exhsuast_current] = 0;
            vInfo[index][vExhaustSound] = 0;
            vInfo[vehicleid][vExhaustSound] = 0;
            SetOwnableCarData(index, OC_exhsuast_current, 0);
            SetOwnableCarData(index, OC_EXHAUST, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET exhsuast_current = 0, exhaust_type = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleExhaust(vehicleid, 0, 0);
            return 1;
        }
        case 10:
        {
            vInfo[index][lights_color] = 0;
            SetOwnableCarData(index, OC_lights_color, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET lights_color = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            ddSetVehicleColorHexForPlayers(playerid, vehicleid, 0);
            return 1;
        }
        case 11:
        {
            vInfo[index][underlights_color] = 0;
            vInfo[index][underlights_color_lf] = 0;
            vInfo[index][underlights_color_rt] = 0;
            vInfo[index][vEnableNeon] = 0;
            SetOwnableCarData(index, OC_underlights_color, 0);
            SetOwnableCarData(index, OC_underlights_color_lf, 0);
            SetOwnableCarData(index, OC_underlights_color_rt, 0);
            SetOwnableCarData(index, OC_EnableNeon, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET underlights_color = 0, underlights_color_lf = 0, underlights_color_rt = 0, EnableNeon = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleNeonForPlayer(playerid, vehicleid, 0, 0, 0);
            return 1;
        }
        case 12:
        {
            vInfo[index][underlights_color_rt] = 0;
            new neon_enabled = 0;
            if(vInfo[index][underlights_color] != 0 || vInfo[index][underlights_color_lf] != 0) neon_enabled = 1;
            vInfo[index][vEnableNeon] = neon_enabled;
            SetOwnableCarData(index, OC_underlights_color_rt, 0);
            SetOwnableCarData(index, OC_EnableNeon, neon_enabled);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET underlights_color_rt = 0, EnableNeon = %d WHERE id = %d", neon_enabled, database_id);
            mysql_query(mysql, query, false);
            SetVehicleNeonForPlayer(playerid, vehicleid, vInfo[index][underlights_color], vInfo[index][underlights_color_lf], vInfo[index][underlights_color_rt]);
            return 1;
        }
        case 13:
        {
            vInfo[index][underlights_color_lf] = 0;
            new neon_enabled = 0;
            if(vInfo[index][underlights_color] != 0 || vInfo[index][underlights_color_rt] != 0) neon_enabled = 1;
            vInfo[index][vEnableNeon] = neon_enabled;
            SetOwnableCarData(index, OC_underlights_color_lf, 0);
            SetOwnableCarData(index, OC_EnableNeon, neon_enabled);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET underlights_color_lf = 0, EnableNeon = %d WHERE id = %d", neon_enabled, database_id);
            mysql_query(mysql, query, false);
            SetVehicleNeonForPlayer(playerid, vehicleid, vInfo[index][underlights_color], vInfo[index][underlights_color_lf], vInfo[index][underlights_color_rt]);
            return 1;
        }
        case 14:
        {
            vInfo[index][strab_current] = 0;
            vInfo[index][vStrob] = 0;
            vInfo[vehicleid][strab_current] = 0;
            vInfo[vehicleid][vStrob] = 0;
            EnableStrob[vehicleid] = false;
            SetOwnableCarData(index, OC_strab_current, 0);
            SetOwnableCarData(index, OC_STROBOSCOPE, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET strab_current = 0, stroboscope_type = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleStroboscope(vehicleid, 5, 0);
            return 1;
        }
        case 16, 17, 18, 19, 20, 21, 43, 44, 45, 46, 47:
        {
            return ResetVehicleStoreSelectorToStock(playerid, vehicleid, database_id, selector_id);
        }
        case 22:
        {
            vInfo[index][percentofclirness] = 0;
            SetOwnableCarData(index, OC_percentofclirness, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET percentofclirness = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            if(vInfo[index][SelectedPnevmo] == 0) SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 1.0);
            return 1;
        }
        case 23:
        {
            vInfo[index][percentofclirnessz] = 0;
            SetOwnableCarData(index, OC_percentofclirnessZ, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET percentofclirnessZ = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleSuspensionBiasFor(playerid, vehicleid, 0.5);
            return 1;
        }
        case 24:
        {
            vInfo[index][wheel_offset_ft] = 50;
            SetOwnableCarData(index, OC_wheel_offset_ft, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_offset_ft = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleWheelOffsetForPlayer(playerid, vehicleid, (vInfo[index][wheel_offset_ft] / 400.0) - 0.125, (vInfo[index][wheel_offset_rr] / 400.0) - 0.125);
            return 1;
        }
        case 25:
        {
            vInfo[index][wheel_offset_rr] = 50;
            SetOwnableCarData(index, OC_wheel_offset_rr, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_offset_rr = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleWheelOffsetForPlayer(playerid, vehicleid, (vInfo[index][wheel_offset_ft] / 400.0) - 0.125, (vInfo[index][wheel_offset_rr] / 400.0) - 0.125);
            return 1;
        }
        case 26:
        {
            vInfo[index][align_ft] = 0;
            SetOwnableCarData(index, OC_align_ft, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET align_ft = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleWheelAlignForPlayer(playerid, vehicleid, 0.0, (vInfo[index][align_rr] / -200.0));
            return 1;
        }
        case 27:
        {
            vInfo[index][align_rr] = 0;
            SetOwnableCarData(index, OC_align_rr, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET align_rr = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleWheelAlignForPlayer(playerid, vehicleid, (vInfo[index][align_ft] / -200.0), 0.0);
            return 1;
        }
        case 28:
        {
            vInfo[index][width_ft] = 40;
            SetOwnableCarData(index, OC_width_ft, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET width_ft = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleWheelAddForPlayer(playerid, vehicleid, (vInfo[index][width_ft] / 80.0) + 0.5, (vInfo[index][width_rr] / 80.0) + 0.5);
            return 1;
        }
        case 29:
        {
            vInfo[index][width_rr] = 40;
            SetOwnableCarData(index, OC_width_rr, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET width_rr = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleWheelAddForPlayer(playerid, vehicleid, (vInfo[index][width_ft] / 80.0) + 0.5, (vInfo[index][width_rr] / 80.0) + 0.5);
            return 1;
        }
        case 30:
        {
            vInfo[index][wheel_radius] = 0;
            SetOwnableCarData(index, OC_wheel_radius, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_radius = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            SetVehicleWheelRadForPlayer(playerid, vehicleid, 1.0);
            return 1;
        }
        case 31:
        {
            ResetVehicleStoreSelectorToStock(playerid, vehicleid, database_id, selector_id);

            new wheel_componentid = GetWheelTuneComponentId(vInfo[index][wheel_comp]);
            if(wheel_componentid > 0)
            {
                // Removed below through the custom CRMP component RPC.
                RemoveFromVehicleComponentForPlayer(playerid, vehicleid, wheel_componentid);
            }

            vInfo[index][wheel_comp] = 0;
            SetOwnableCarData(index, OC_wheelcomp, 0);
            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_comp = 0 WHERE id = %d", database_id);
            mysql_query(mysql, query, false);
            return 1;
        }
    }

    return 0;
}

stock SendCarFirmware(playerid, firmware)
{
    new BitStream:bs = BS_New();

    // sub-id (как в RPC 168)
    BS_WriteValue(bs, PR_UINT8, 0);

    // payload
    BS_WriteValue(bs, PR_UINT16, firmware);

    PR_SendRPC(bs, playerid, 255, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock SendOpenLink(playerid, const link[])
{
    new BitStream:bs = BS_New();

    // sub-id
    BS_WriteValue(bs, PR_UINT8, 0);

    // generated
    BS_WriteValue(bs, PR_UINT16, 99);

    // generated
    new len = strlen(link);
    BS_WriteValue(bs, PR_UINT16, len);

    // generated
    BS_WriteValue(bs, PR_STRING, link);

    PR_SendRPC(bs, playerid, 255, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}


stock SetVehicleAccelerations(vehicleid, Float:accel, setvalue=0)
{
    if(setvalue)
    {
        vInfo[vehicleid][vMaxSpeed] *= 1.4;
    }
    foreach(new playerid: Player) SetVehicleAccelerationForPlayer(playerid, vehicleid, accel);
}

stock SetVehicleAccelerationForPlayer(playerid, vehicleid, Float:accel)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 5);

    BS_WriteValue(bs, PR_FLOAT, accel * 10);

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock SetSuitLevelForPlayer(playerid, value)
{
    new BitStream:bitstream = BS_New();

    BS_WriteValue(bitstream, PR_UINT8, 32); //ид кастюма
    BS_WriteValue(bitstream, PR_UINT8, value); //уровень

    PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bitstream);
}

CMD:suittest(playerid)
{
    new level = random(256);

    SetSuitLevelForPlayer(playerid, level);

    SendClientMessage(playerid, -1, "тест");

    return 1;
}

stock SetVehicleMaxSpeedForPlayer(playerid, vehicleid, Float:accel)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 4);

    BS_WriteValue(bs, PR_FLOAT, (accel) / 0.0055556);

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}
stock SetVehicleSportForPlayer(playerid, vehicleid, value){
    new Float:value;
    SetVehicleMaxSpeedForPlayer(playerid, vehicleid, value);
    SetVehicleAccelerations(vehicleid, value, 1);
}
CMD:zdrift(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleDriftForPlayer(playerid, vehicleid, 0);
}
CMD:zdriftoff(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleDriftForPlayer(playerid, vehicleid, 0);
}
