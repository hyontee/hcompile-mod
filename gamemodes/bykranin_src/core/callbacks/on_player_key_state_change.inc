//>> Файл: bykranin_src/core/callbacks/on_player_key_state_change.inc  (1171 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerKeyStateChange
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(FsinFull_OnPlayerKeyStateChange(playerid,newkeys,oldkeys)) return 1;
    if(GarageSys_OnKeyStateChange(playerid, newkeys, oldkeys)) return 1;
    if(PRESSED(KEY_CROUCH))
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            if(Fuel_TryOpenGuiOnHorn(playerid))
            {
                return 1;
            }
        }

        if(TrunkTest_TryOpenNearby(playerid, false))
        {
            return 1;
        }
    }

	if(newkeys & KEY_YES)
	{
		if(IsPlayerAtATM(playerid))
		{
			return callcmd::bankomat(playerid, "");
		}
	}
	
if(newkeys == KEY_CROUCH)
{
	
    // СТО
	if(IsPlayerInRangeOfPoint(playerid, 7.0, 2164.40302, -870.218139, 28.59245) ||
       IsPlayerInRangeOfPoint(playerid, 7.0, 2164.40302, -865.327270, 28.59245) ||
       IsPlayerInRangeOfPoint(playerid, 7.0, 2164.40302, -854.459777, 28.59245) ||
	   IsPlayerInRangeOfPoint(playerid, 7.0, 2164.40302, -860.289064, 27.29245)
	   )
    {
        new vehicleID = GetPlayerVehicleID(playerid);
        
        if(vehicleID)
        {
            if((GetVehicleModel(vehicleID) == 448) || (GetVehicleModel(vehicleID) == 461) || (GetVehicleModel(vehicleID) == 462) || (GetVehicleModel(vehicleID) == 463) || (GetVehicleModel(vehicleID) == 468) || (GetVehicleModel(vehicleID) == 521) || (GetVehicleModel(vehicleID) == 522) || (GetVehicleModel(vehicleID) == 523) || (GetVehicleModel(vehicleID) == 581) || (GetVehicleModel(vehicleID) == 586) || (GetVehicleModel(vehicleID) == 640) || (GetVehicleModel(vehicleID) == 741) || (GetVehicleModel(vehicleID) == 754) || (GetVehicleModel(vehicleID) == 28659) || (GetVehicleModel(vehicleID) == 28727) || (GetVehicleModel(vehicleID) == 28703)) return SendClientMessage(playerid, -1, "Мотоциклам въезд в этот центр запрещен.");
            SetVehicleVirtualWorld(vehicleID, vehicleID);
            LinkVehicleToInterior(vehicleID, 1);
            SetVehiclePos(vehicleID, 2508.3931, 1504.2278, 1497.5);
            SetVehicleZAngle(vehicleID, 0.0);
        
            SetPlayerCameraPos(playerid, 2501.2969, 1511.0194, 1500.2665);
            SetPlayerCameraLookAt(playerid, 2502.0427, 1510.3536, 1500.0214);
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, vehicleID);
            
            for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleID)
                {
                    SetPlayerVirtualWorld(i, vehicleID);
                    SetPlayerInterior(i, 1);
                }
            }

            new JSON:tuning_jsonn = JSON_Object();
            JSON_SetInt(tuning_jsonn, "o", 1);
            JSON_SetInt(tuning_jsonn, "w", 1);
            JSON_SetInt(tuning_jsonn, "t", 0);
            JSON_SetInt(tuning_jsonn, "j", GetVehiclePriceByModel(vInfo[vehicleID][vModelID]));
            JSON_SetString(tuning_jsonn, "nm", GetPlayerNameEx(playerid));
            JSON_SetInt(tuning_jsonn, "m", GetPlayerMoney(playerid));
            JSON_SetInt(tuning_jsonn, "engine", 1);
            JSON_SetInt(tuning_jsonn, "brakes", 2);
            JSON_SetInt(tuning_jsonn, "suspension", 3);
			new jsonid = GetVehicleJsonIdFromModel(vInfo[vehicleID][vModelID]);
			printf("JSONID : %d", jsonid);
            JSON_SetInt(tuning_jsonn, "s", jsonid);
			new model_name[24];
			GetVehicleModelName(vInfo[vehicleID][vModelID], model_name);
			JSON_SetString(tuning_jsonn, "n", model_name);
			new vehicleid = GetPlayerOwnableCar(playerid);
			new i = GetVehicleData(vehicleid, V_ACTION_ID);
			new is = GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID);
			g_player[playerid][P_LAST_TUNING] = 1;
			
			new JSON:k_array = JSON_Array();
		    
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100)));
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100)));
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100)));
		    JSON_SetArray(tuning_jsonn, "d", k_array);
			
			new query[128];
            mysql_format(mysql, query, sizeof(query),
                "SELECT componentid,state FROM vehicle_store_components WHERE vehicleid=%d",
                vInfo[vehicleID][vSQLID]
            );
            
            mysql_query(mysql, query);
            
            new JSON:d_array = JSON_Array();
            
            if(!cache_num_rows())
            {
                new start, count;
            
                if(GetVehicleComponents(jsonid, start, count))
                {
                    for(new x; x < count; x++)
                    {
                        new component = gVehicleComponentList[start + x];
            
                        d_array = JSON_Append(d_array, JSON_Array(JSON_Int(component)));
                        d_array = JSON_Append(d_array, JSON_Array(JSON_Int(0)));
            
                        mysql_format(mysql, query, sizeof(query),
                            "INSERT INTO vehicle_store_components (vehicleid,componentid,state) VALUES (%d,%d,0)",
                            vInfo[vehicleID][vSQLID],
                            component
                        );
                        mysql_query(mysql, query);
                    }
                }
            }
            else
            {
                new componentid, states;
            
                for(new x; x < cache_num_rows(); x++)
                {
                    componentid = cache_get_field_content_int(x, "componentid");
                    states = cache_get_field_content_int(x, "state");
            
                    d_array = JSON_Append(d_array, JSON_Array(JSON_Int(componentid)));
                    d_array = JSON_Append(d_array, JSON_Array(JSON_Int(states)));
                }
            }
            
            JSON_SetArray(tuning_jsonn, "k", d_array);
            new json_string[1024];
            JSON_Stringify(tuning_jsonn, json_string, sizeof(json_string));
            
            printf("TUNING JSON: %s", json_string);
            
            ShowPlayerGUI(playerid, 28, tuning_jsonn);
            JSON_Cleanup(d_array);
            JSON_Cleanup(tuning_jsonn);
			
			JSON_Cleanup(k_array);
			
        }
    }
	
    if(IsPlayerInRangeOfPoint(playerid, 5.0, -426.235290,1005.412658,12.307508) ||
       IsPlayerInRangeOfPoint(playerid, 5.0, -420.054534,1005.409240,12.307003) ||
       IsPlayerInRangeOfPoint(playerid, 5.0, -413.549285,1005.543029,12.326748))
    {
        new vehicleID = GetPlayerVehicleID(playerid);
        
        if(vehicleID)
        {
            if((GetVehicleModel(vehicleID) == 448) || (GetVehicleModel(vehicleID) == 461) || (GetVehicleModel(vehicleID) == 462) || (GetVehicleModel(vehicleID) == 463) || (GetVehicleModel(vehicleID) == 468) || (GetVehicleModel(vehicleID) == 521) || (GetVehicleModel(vehicleID) == 522) || (GetVehicleModel(vehicleID) == 523) || (GetVehicleModel(vehicleID) == 581) || (GetVehicleModel(vehicleID) == 586) || (GetVehicleModel(vehicleID) == 640) || (GetVehicleModel(vehicleID) == 741) || (GetVehicleModel(vehicleID) == 754) || (GetVehicleModel(vehicleID) == 28659) || (GetVehicleModel(vehicleID) == 28727) || (GetVehicleModel(vehicleID) == 28703)) return SendClientMessage(playerid, -1, "Мотоциклам въезд в этот центр запрещен.");
            SetVehiclePos(vehicleID, 996.368164,999.465759,1001.791540);
            SetVehicleZAngle(vehicleID, 273.919586);
            SetVehicleVirtualWorld(vehicleID, vehicleID);
            LinkVehicleToInterior(vehicleID, 1);
            
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, vehicleID);
            
            SetPlayerCameraPos(playerid, 1001.483154,1002.271240,1000.906738);
            SetPlayerCameraLookAt(playerid, 997.090454,999.934204,1001.398864);
            for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleID)
                {
                    SetPlayerVirtualWorld(i, vehicleID);
                    SetPlayerInterior(i, 1);
                }
            }
            new JSON:tuning_jsonn = JSON_Object();
            JSON_SetInt(tuning_jsonn, "o", 0);
            JSON_SetInt(tuning_jsonn, "w", 3);
            JSON_SetInt(tuning_jsonn, "t", 0);
            JSON_SetInt(tuning_jsonn, "j", GetVehiclePriceByModel(vInfo[vehicleID][vModelID]));
            JSON_SetString(tuning_jsonn, "nm", GetPlayerNameEx(playerid));
            JSON_SetInt(tuning_jsonn, "m", GetPlayerMoney(playerid));
            JSON_SetInt(tuning_jsonn, "engine", 1);
            JSON_SetInt(tuning_jsonn, "brakes", 2);
            JSON_SetInt(tuning_jsonn, "suspension", 3);
            JSON_SetInt(tuning_jsonn, "wheels", 1);
			JSON_SetInt(tuning_jsonn, "s", 5);
            JSON_SetInt(tuning_jsonn, "nitro", 1);
			new model_name[24];
			 GetVehicleModelName(vInfo[vehicleID][vModelID], model_name);
			JSON_SetString(tuning_jsonn, "n", model_name);
			new vehicleid = GetPlayerOwnableCar(playerid);
			new i = GetVehicleData(vehicleid, V_ACTION_ID);
			g_player[playerid][P_LAST_TUNING] = 3;

	       
	        
            new JSON:k_array = JSON_Array();
			new p_values[] = {4,5,6,7,9,10,11,12,14,15,16,17,19,20,21,22,24,25,26,27};
            new oc_slots[] = {
                OC_COMFORT_PL, OC_SPORT, OC_DRIFT, OC_SPORT_PL,
                OC_COMFORT1, OC_SPORT1, OC_DRIFT1, OC_SPORT_PL1,
                OC_COMFORT2, OC_SPORT2, OC_DRIFT2, OC_SPORT_PL2,
                OC_COMFORT3, OC_SPORT3, OC_DRIFT3, OC_SPORT_PL3,
                OC_COMFORT4, OC_SPORT4, OC_DRIFT4, OC_SPORT_PL4
            };
			new is = GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID);
            TechCenter_SyncFirmwareRuntime(is);
			
			for(new i = 0; i < sizeof p_values; i++)
            {
				if (GetOwnableCarData(is, oc_slots[i]) == 1){
					k_array = JSON_Append(k_array, JSON_Array(JSON_Int(p_values[i]))); //
                    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); //
				}
            }
           
		    if(vInfo[is][vLaunchControl] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Array(JSON_Int(35))); //
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); //
			}
			
            switch(vInfo[is][vNitro])
            {
				case 1: {
					k_array = JSON_Append(k_array, JSON_Array(JSON_Int(0))); //
                    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); //
				}
				case 2: {
					k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); //
                    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); //
				}
				case 3: {
					k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); //
                    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); //
				}
			}
			new states = vInfo[is][pdvradar];
            if (states & 1)
            {
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1928)));
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
            }
            
            if (states & 2)
            {
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1929)));
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
            }

		    JSON_SetArray(tuning_jsonn, "k", k_array);
			new json_str[1024];
            JSON_Stringify(tuning_jsonn, json_str, sizeof json_str);
            printf("%s", json_str);
            ShowPlayerGUI(playerid, 28, tuning_jsonn);
			   
	       
			
        }
    }
    // Стайл центр
    else if(IsPlayerInRangeOfPoint(playerid, 5.0, 2311.993896,-2607.235107,21.829063) ||
            IsPlayerInRangeOfPoint(playerid, 5.0, 2311.326416,-2613.377685,21.829063) ||
            IsPlayerInRangeOfPoint(playerid, 5.0, 2311.343261,-2619.453125,21.829063))
    {
        new vehicleID = GetPlayerVehicleID(playerid);
        
        if(vehicleID && Styling_CanEdit(playerid, vehicleID))
        {
            SetVehicleVirtualWorld(vehicleID, vehicleID);
            LinkVehicleToInterior(vehicleID, 1);
			
            SetPlayerCameraPos(playerid, 1001.483154,1002.271240,1000.906738);
            SetPlayerCameraLookAt(playerid, 997.090454,999.934204,1001.398864);
            SetVehiclePos(vehicleID, 1000.0, 1500.0, 1498.0);
            SetVehicleZAngle(vehicleID, 180.0);
            SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
            SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, vehicleID);
			for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleID)
                {
                    SetPlayerVirtualWorld(i, vehicleID);
                    SetPlayerInterior(i, 1);
                }
            }
            
            
            new JSON:tuning_jsonn = JSON_Object();
            JSON_SetInt(tuning_jsonn, "o", 0);
            JSON_SetInt(tuning_jsonn, "w", 0);
            JSON_SetInt(tuning_jsonn, "s", GetVehicleJsonIdFromModel(GetVehicleData(vehicleID, V_MODELID)));
			g_player[playerid][P_LAST_TUNING] = 0;
            JSON_SetInt(tuning_jsonn, "t", 0);
            JSON_SetInt(tuning_jsonn, "j", GetVehiclePriceByModel(GetVehicleData(vehicleID, V_MODELID)));
            JSON_SetString(tuning_jsonn, "nm", GetPlayerNameEx(playerid));
            JSON_SetInt(tuning_jsonn, "m", GetPlayerMoney(playerid));
            JSON_SetInt(tuning_jsonn, "engine", 1);
            JSON_SetInt(tuning_jsonn, "brakes", 2);
            JSON_SetInt(tuning_jsonn, "suspension", 3);
            JSON_SetInt(tuning_jsonn, "wheels", 1);
			new model_name[24];
			 GetVehicleModelName(GetVehicleData(vehicleID, V_MODELID), model_name);
			JSON_SetString(tuning_jsonn, "n", model_name);
            
			new is = GetVehicleData(vehicleID, V_ACTION_ID);
			
			
            new JSON:k_array = JSON_Array(JSON_Int(-1), JSON_Int(-1));
		    // Vinyl catalogue item 0 is valid too; vynil_name tells stock from installed item 0.
		    if(vInfo[is][vynil_name][0] != EOS || vInfo[is][vinil_current] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(vInfo[is][vinil_current])); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
			if(vInfo[is][exhsuast_current] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(vInfo[is][exhsuast_current])); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
			if(vInfo[is][strab_current] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(vInfo[is][strab_current])); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
			if(vInfo[is][horn_current] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(vInfo[is][horn_current])); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
			if(vInfo[is][IsFarLightBought] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(299)); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
	
            

		    JSON_SetArray(tuning_jsonn, "k", k_array);

            printf("[STYLING][OPEN] player=%d vehicle=%d sql=%d model=%d gui_model=%d center=%d",
                playerid, vehicleID, GetOwnableCarData(is, OC_SQL_ID), GetVehicleData(vehicleID, V_MODELID),
                GetVehicleJsonIdFromModel(GetVehicleData(vehicleID, V_MODELID)), GetPlayerData(playerid, P_LAST_TUNING));
            ShowPlayerGUI(playerid, 28, tuning_jsonn);
            JSON_Cleanup(k_array);
            JSON_Cleanup(tuning_jsonn);
        }
    }
    // Шинка центр
    else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1728.810302,2462.126220,14.979245) ||
            IsPlayerInRangeOfPoint(playerid, 5.0, 1729.730712,2457.556396,14.979245) ||
            IsPlayerInRangeOfPoint(playerid, 5.0, 1730.881835,2452.856689,14.979245))
    {
        new vehicleID = GetPlayerVehicleID(playerid);
        
        if(vehicleID && Styling_CanEdit(playerid, vehicleID))
        {
            if((GetVehicleModel(vehicleID) == 448) || (GetVehicleModel(vehicleID) == 461) || (GetVehicleModel(vehicleID) == 462) || (GetVehicleModel(vehicleID) == 463) || (GetVehicleModel(vehicleID) == 468) || (GetVehicleModel(vehicleID) == 521) || (GetVehicleModel(vehicleID) == 522) || (GetVehicleModel(vehicleID) == 523) || (GetVehicleModel(vehicleID) == 581) || (GetVehicleModel(vehicleID) == 586) || (GetVehicleModel(vehicleID) == 640) || (GetVehicleModel(vehicleID) == 741) || (GetVehicleModel(vehicleID) == 754) || (GetVehicleModel(vehicleID) == 28659) || (GetVehicleModel(vehicleID) == 28727) || (GetVehicleModel(vehicleID) == 28703)) return SendClientMessage(playerid, -1, "Мотоциклам въезд в этот центр запрещен.");
            SetVehicleZAngle(vehicleID, 273.919586);
            SetVehicleVirtualWorld(vehicleID, vehicleID);
            LinkVehicleToInterior(vehicleID, 1);
            
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, vehicleID);
            
            SetVehiclePos(vehicleID, 995.7154, 1000.5235, 1500.1683);
  SetVehicleZAngle(vehicleID, 180.0);
  SetPlayerCameraPos(playerid, 999.1838, 995.9953, 1501.7263);
  SetPlayerCameraLookAt(playerid, 998.5103, 996.7333, 1501.5776);
            for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleID)
                {
                    SetPlayerVirtualWorld(i, vehicleID);
                    SetPlayerInterior(i, 1);
                }
            }
            new JSON:tuning_jsonn = JSON_Object();
            JSON_SetInt(tuning_jsonn, "o", 0);
			g_player[playerid][P_LAST_TUNING] = 2;
            JSON_SetInt(tuning_jsonn, "w", 2);
            JSON_SetInt(tuning_jsonn, "s", GetVehicleJsonIdFromModel(GetVehicleData(vehicleID, V_MODELID)));
            JSON_SetInt(tuning_jsonn, "t", 0);
            JSON_SetInt(tuning_jsonn, "j", GetVehiclePriceByModel(GetVehicleData(vehicleID, V_MODELID)));
            JSON_SetString(tuning_jsonn, "nm", GetPlayerNameEx(playerid));
            JSON_SetInt(tuning_jsonn, "m", GetPlayerMoney(playerid));
            JSON_SetInt(tuning_jsonn, "engine", 1);
            JSON_SetInt(tuning_jsonn, "brakes", 2);
            JSON_SetInt(tuning_jsonn, "suspension", 3);
            JSON_SetInt(tuning_jsonn, "wheels", 1);
			new model_name[24];
			GetVehicleModelName(GetVehicleData(vehicleID, V_MODELID), model_name);
			JSON_SetString(tuning_jsonn, "n", model_name);
			new JSON:k_array = JSON_Array(JSON_Int(-1), JSON_Int(-1));
			new is = GetVehicleData(vehicleID, V_ACTION_ID);           
			JSON_SetFloat(tuning_jsonn, "wh_rad", float(vInfo[is][wheel_radius]));
			JSON_SetFloat(tuning_jsonn, "wh_wf", float(vInfo[is][width_ft]));
			JSON_SetFloat(tuning_jsonn, "wh_wr", float(vInfo[is][width_rr]));
			JSON_SetFloat(tuning_jsonn, "wh_of", float(vInfo[is][wheel_offset_ft]));
			JSON_SetFloat(tuning_jsonn, "wh_or", float(vInfo[is][wheel_offset_rr]));
			JSON_SetFloat(tuning_jsonn, "wh_cf", float(vInfo[is][align_ft]));
			JSON_SetFloat(tuning_jsonn, "wh_cr", float(vInfo[is][align_rr]));
			JSON_SetFloat(tuning_jsonn, "wh_clr", float(vInfo[is][percentofclirness]));
			JSON_SetInt(tuning_jsonn, "hydra", vInfo[is][IsHydroBought]);
			JSON_SetInt(tuning_jsonn, "pnevmo", vInfo[is][IsPnevmoBought]);
		    if(vInfo[is][IsHydroBought] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(33)); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
			
			if(vInfo[is][IsPnevmoBought] != 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(34)); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
			if(vInfo[is][wheel_comp] != 0 &&
			   GetTuneSelectorFromItem(vInfo[is][wheel_comp]) == 31 &&
			   GetWheelTuneComponentId(vInfo[is][wheel_comp]) > 0)
            {
				k_array = JSON_Append(k_array, JSON_Int(vInfo[is][wheel_comp])); //
                k_array = JSON_Append(k_array, JSON_Int(2)); //
			}
		    JSON_SetArray(tuning_jsonn, "k", k_array);
            printf("[STYLING][OPEN] player=%d vehicle=%d sql=%d model=%d gui_model=%d center=%d",
                playerid, vehicleID, GetOwnableCarData(is, OC_SQL_ID), GetVehicleData(vehicleID, V_MODELID),
                GetVehicleJsonIdFromModel(GetVehicleData(vehicleID, V_MODELID)), GetPlayerData(playerid, P_LAST_TUNING));
            ShowPlayerGUI(playerid, 28, tuning_jsonn);
            JSON_Cleanup(k_array);
            JSON_Cleanup(tuning_jsonn);
        }
    }
}

if(newkeys == KEY_CROUCH && GetPlayerState(playerid) == PLAYER_STATE_DRIVER &&
   GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
{
	for(new used_market_entry; used_market_entry < sizeof gUsedMarketVehicleEnter; used_market_entry++)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 4.0,
			gUsedMarketVehicleEnter[used_market_entry][0],
			gUsedMarketVehicleEnter[used_market_entry][1],
			gUsedMarketVehicleEnter[used_market_entry][2])) continue;

		if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid)))
			return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");

		new market_vehicle = GetPlayerVehicleID(playerid);
		for(new passenger; passenger < MAX_PLAYERS; passenger++)
		{
			if(!IsPlayerConnected(passenger) || !IsPlayerInVehicle(passenger, market_vehicle)) continue;
			SetPlayerVirtualWorld(passenger, 101);
			SetPlayerInterior(passenger, 1);
			SetCameraBehindPlayer(passenger);
		}
		SetVehicleVirtualWorld(market_vehicle, 101);
		LinkVehicleToInterior(market_vehicle, 1);
		SetVehiclePos(market_vehicle, 440.320770, 982.426330, 1001.000000);
		SetVehicleZAngle(market_vehicle, 270.0);
		return 1;
	}
}
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 482.254608,954.700195,1001.000000))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 499.931915,918.361816,1001.000000))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 481.850952,1081.980712,1001.000000))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 561.913696,1018.296691,1001.000000))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 553.966735,918.125732,1001.000000)) //
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 473.902709,1018.365661,1001.000000))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 553.964111,1082.194213,1001.000000))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   if(newkeys == KEY_CROUCH)
   {
       if(IsPlayerInRangeOfPoint(playerid,  10.0, 562.388244,963.125244,1001.000000))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
          new veh;
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);
		  for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, vehicleID))
          {
              SetPlayerVirtualWorld(i, 0);
              SetPlayerInterior(i, 0);
              SetCameraBehindPlayer(i);
          }
          }
          veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          return true;
       }
   }
   
    if(newkeys == KEY_CROUCH)
    {
        if((IsPlayerInRangeOfPoint(playerid, 2.5, pos_tuning [ 0 ] [ 0 ], pos_tuning [ 0 ] [ 1 ], pos_tuning [ 0 ] [ 2 ])
		|| IsPlayerInRangeOfPoint(playerid, 2.5, pos_tuning [ 1 ] [ 0 ], pos_tuning [ 1 ] [ 1 ], pos_tuning [ 1 ] [ 2 ])
		|| IsPlayerInRangeOfPoint(playerid, 2.5, pos_tuning [ 2 ] [ 0 ], pos_tuning [ 2 ] [ 1 ], pos_tuning [ 2 ] [ 2 ])
		|| IsPlayerInRangeOfPoint(playerid, 2.5, pos_tuning [ 3 ] [ 0 ], pos_tuning [ 3 ] [ 1 ], pos_tuning [ 3 ] [ 2 ])) && GetPlayerState(playerid) == 2) // Заехать в тюнинг
		{
		    if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
            if((GetVehicleModel(GetPlayerVehicleID(playerid)) == 448) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 461) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 462) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 463) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 468) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 521) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 522) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 523) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 581) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 586) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 640) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 741) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 754) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 28659) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 28727) || (GetVehicleModel(GetPlayerVehicleID(playerid)) == 28703)) return SendClientMessage(playerid, -1, "Мотоциклам въезд в этот центр запрещен.");
            //if(GetVehicleFreeSeat(GetPlayerVehicleID(playerid)) == -1) return SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Для начала высадите всех пассажиров.");

		    //SetPVarInt(playerid, "playerTune", 1);
			//SetVehiclePos(GetPlayerOwnableCar(playerid), 2503.1333, 1503.7999, 1498.1379);
			//SetVehicleZAngle(GetPlayerOwnableCar(playerid), 0.1546);

			SetCameraBehindPlayer(playerid);
			//LinkVehicleToInterior(GetPlayerOwnableCar(playerid), 1);
			//SetVehicleVirtualWorld(GetPlayerOwnableCar(playerid), playerid + 1);
			//SetPlayerInteriorEx(playerid, 1);
			//SetPlayerVirtualWorldEx(playerid, playerid + 1);

			//Dialog(playerid, 450, DIALOG_STYLE_LIST, ""SERVER"Автосервис", "1. Перекрасить элементы\n2. Установить нитро\n3. Установить цвет фар\n4. Установить диски\n5. Новый размер кoлес\n6. Лаунч-контроль", "Далее", "Назад");
            ShowTuneShowPlayerDialog(playerid);
			//TogglePlayerControllable(playerid, false);
			return true;
		}
		}

	if(PRESSED(KEY_NO))
		callcmd::no(playerid, "");

	if(PRESSED(KEY_YES))
		callcmd::yes(playerid, "");

	/*if(newkeys & KEY_SPRINT && newkeys & KEY_JUMP)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			if(times[playerid] == true)
				{
					SetTimerEx("AntiBH",1000,false,"i",playerid);
			}
		}
	}*/

	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			/*
			new pedal_type = PEDAL_TYPE_NONE;

			if(PRESSED(KEY_SPRINT) && !PRESSED(KEY_JUMP))
				pedal_type = PEDAL_TYPE_GAS;

			else if(PRESSED(KEY_JUMP) && !PRESSED(KEY_SPRINT))
				pedal_type = PEDAL_TYPE_BRAKE;

			else if(RELEASED(KEY_SPRINT) || RELEASED(KEY_JUMP))
				pedal_type = PEDAL_TYPE_NONE;

			player_press_pedal[playerid] = pedal_type;
			*/

			if(GetPlayerSettingData(playerid, S_VEH_CONTROL) == SETTING_TYPE_ON)
			{
				if(PRESSED(KEY_HANDBRAKE | KEY_FIRE)) // правый ctrl
				{
					if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
					{
						callcmd::lock(playerid, "1");
					}
				}
				if(PRESSED(KEY_ACTION))
				{
				}
				if(PRESSED(KEY_FIRE))
				{
					
				}
				if(PRESSED(KEY_ANALOG_UP)) // num 8
				{
					callcmd::b(playerid, "");
				}
				if(PRESSED(KEY_ANALOG_DOWN)) // num 2
				{
					callcmd::i(playerid, "");
				}
				if(PRESSED(KEY_ANALOG_LEFT)) // num 4
				{
					callcmd::sl(playerid, "");
				}
				if(PRESSED(KEY_ANALOG_RIGHT)) // num 6
				{
					callcmd::alarm(playerid, "");
				}
			}

			if(PRESSED(KEY_SUBMISSION))
			{
				if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid)))
				{
					new job_car = GetPlayerJobCar(playerid);
					if(IsPlayerInVehicle(playerid, job_car))
					{
						new action_type = GetVehicleData(job_car, V_ACTION_TYPE);
						new car_type = (action_type - VEHICLE_ACTION_TYPE_BUS_DRIVER) + 1;

						new job_id = GetPlayerJob(playerid);
						if(job_id == car_type)
						{
							switch(job_id)
							{
								case JOB_BUS_DRIVER:
								{
									if(IsPlayerInJob(playerid))
									{
										Dialog
										(
											playerid, DIALOG_END_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}Диспетчер автопарка",
											"{FFFFFF}Вы уверены что хотите завершить рабочий день?",
											"Да", "Нет"
										);
									}
					else
									{
										Dialog
										(
											playerid, DIALOG_BUS_ROUTE_COST, DIALOG_STYLE_INPUT,
											"{FFCD00}Стоимость проезда",
											"{FFFFFF}Сколько будет стоить проезд?\n"\
											"Укажите цену от 0 до 100 рублей",
											"Далее", "Отмена"
										);
									}
								}
								case 6:
								{
									if(IsPlayerInJob(playerid))
									{
										Dialog
										(
											playerid, DIALOG_END_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}Диспетчер таксопарка",
											"{FFFFFF}Вы уверены что хотите завершить рабочий день?",
											"Да", "Нет"
										);
									}
					else
									{
										Dialog
										(
											playerid, DIALOG_TAXI_NAME, DIALOG_STYLE_INPUT,
											"{FFCD00}Название такси",
											"{FFFFFF}Придумайте название для вашего такси\n"\
											"Максимальная длина 15 символов\n\n"\
											"Если вы не хотите как-то называться\n"\
											"нажмите кнопку \"Пропустить\"",
											"Далее", "Пропустить"
										);
									}
								}
								case JOB_UNUSED_3:
								{
									if(IsPlayerInJob(playerid))
									{
										Dialog
										(
											playerid, DIALOG_END_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}Автомеханик",
											"{FFFFFF}Вы уверены что хотите завершить рабочий день?",
											"Да", "Нет"
										);
									}
					else
									{
										Dialog
										(
											playerid, DIALOG_UNUSED_LEGACY_7, DIALOG_STYLE_MSGBOX,
											"{FFCD00}Диспетчер",
											"{FFFFFF}Вы хотите начать работу автомеханика?",
											"Да", "Нет"
										);
									}
								}
								case JOB_TRUCKER:
								{
									if(IsPlayerInJob(playerid))
									{
										Dialog
										(
											playerid, DIALOG_END_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}Диспетчер автопарка",
											"{FFFFFF}Вы уверены что хотите завершить рабочий день?",
											"Да", "Нет"
										);
									}
					else
									{
										Dialog
										(
											playerid, DIALOG_TRUCKER_START_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}Дальнобойщик",
											"{FFFFFF}Вы хотите начать работу дальнобойщика?",
											"Да", "Нет"
										);
									}
								}
							}
						}
					}
				}
					else callcmd::car(playerid, "");
			}
			if(HOLDING(KEY_CROUCH))
			{
				CallLocalFunction("CheckNearestGate", "i", playerid);
			}
			if(newkeys == KEY_CROUCH)
			{
				if(IsPlayerInRangeOfPoint(playerid,  10.0, -0.2940,2006.1187,1554.2031) && GetPlayerInHouse(playerid) == GetPlayerHouse(playerid) && GetPlayerState(playerid) == 2)
		        {
		        	new houseid = GetPlayerHouse(playerid);
		            SetVehiclePos
		            (
		                GetPlayerOwnableCar(playerid), 
		                GetHouseData(houseid, H_CAR_POS_X),
		                GetHouseData(houseid, H_CAR_POS_Y),
		                GetHouseData(houseid, H_CAR_POS_Z)
		            ); 
		            SetVehicleZAngle(GetPlayerOwnableCar(playerid), GetHouseData(houseid, H_CAR_ANGLE));
		            SetCameraBehindPlayer(playerid);
		            LinkVehicleToInterior(GetPlayerOwnableCar(playerid),0);
		            SetPlayerInterior(playerid,0);
		            SetPlayerVirtualWorld(playerid,0);
		            SetVehicleVirtualWorld(GetPlayerOwnableCar(playerid), 0);
		            return true;
		        }
			}
		}
	}
					else
	{
		if(PRESSED(KEY_FIRE))
		{
			if(GetPlayerData(playerid, P_SNACK))
			{
				SetPlayerData(playerid, P_SNACK, false);

				SetPlayerHealthEx(playerid, 25.0, true);
				GameTextForPlayer(playerid, "~g~~h~+25 hp", 2500, 6);

				ApplyAnimationEx(playerid, "FOOD", "EAT_Chicken", 4.0, 0, 0, 0, 0, 0, 0);
				//SetTimerEx("T_RemovePlayerAttachedObject", 3000, false, "ii", playerid, A_OBJECT_SLOT_HAND);
			}
			if(GetPlayerData(playerid, P_DRINK_STEP) >= 1)
			{
				AddPlayerData(playerid, P_DRINK_STEP, -, 1);
				if(!GetPlayerData(playerid, P_DRINK_STEP))
				{
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				}
			}
		}
/*		if(PRESSED(KEY_SPRINT))
		{
			if(IsPlayerUseAnim(playerid))
			{
				ClearPlayerUseAnim(playerid);
			}

			if(GetPlayerData(playerid, P_REALTOR_TYPE) != REALTOR_TYPE_NONE)
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					new type = GetBusinessData(businessid, B_INTERIOR);
					new interior = GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR);

					//HidePlayerWaitPanel(playerid);
					TogglePlayerSpectating(playerid, false);

					if(GetPlayerData(playerid, P_REALTOR_TYPE) == REALTOR_TYPE_BIZ)
					{
						PlayerTeleportInit(playerid, 331.0103, 662.5683, 49.7290, 67.7277);
						SetPlayerPosEx(playerid, 331.0103, 662.5683, 49.7290, 67.7277, interior, businessid + 255, false);
					}
					else
					{
						PlayerTeleportInit(playerid, 160.7020, 745.5962, 25.8272, 159.1750);
						SetPlayerPosEx(playerid, 160.7020, 745.5962, 25.8272, 159.1750, interior, businessid + 255, false);
					}
				}
				SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_NONE);
			}
		}*/
		if(PRESSED(KEY_WALK))
		{
			if(GetPlayerInHouse(playerid) != -1)
			{
				new houseid = GetPlayerInHouse(playerid);
				if(GetHouseData(houseid, H_IMPROVEMENTS) > 5)
				{
					Dialog
					(
						playerid, DIALOG_ACTION_EXIT_HOUSE, DIALOG_STYLE_LIST,
						"{FFCC00}Выход",
						"1. Улица\n\
						2. Гараж",
						"Далее", "Закрыть"
					);
					return 1;
				}
					else
					ExitPlayerFromHouse(playerid, 3.0);
			}
					else if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) != -1)
			{
				ExitPlayerFromHotelRoom(playerid);
			}
			
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -109.4100,968.7141,12.3526))
			{
  				ShowPlayerQuestMenu(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 1802.2566,2513.8135,15.8725))
			{
  				ShowPlayerQuestMenu(playerid);
			}
			/*if(IsPlayerInRangeOfPoint(playerid, 2.0, 1886.5671,2032.1482,17.3037))
			{
				Dialog
				(
					playerid, DIALOG_QUEST_23, DIALOG_STYLE_LIST,
					"{FFCD00}Квестовый персонаж",
					"- Историческая викторина {ce325b}[Квест]\n"\
					"- Помощь в празднике {ce325b}[Квест]\n"\
					"- Срочная помощь {ce325b}[Сюжетная линия]",
					"Выбрать", "Закрыть"
		 		);
				return 1;
			}*/

			if(IsPlayerInRangeOfPoint(playerid, 3.0, 609.434875,1729.022583,12.078809))
			{
				Dialog
				(
					playerid, DIALOG_CONTENER1, DIALOG_STYLE_MSGBOX,
					"{FFCD00}Может выпасть:",
					"- Аптечки\n"\
					"- Ремонтные комлекты\n"\
					"- Аксессуар на спину\n"\
					"- Пачка денег\n"\
					"- Сертификат на опыт\n"\
					"- Любое оружие",
					"Выбрать", "Закрыть"
				);
				
				//return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 617.468688,1729.151977,12.078809))
			{
				Dialog
				(
					playerid, DIALOG_CONTENER2, DIALOG_STYLE_MSGBOX,
					"{FFCD00}Может выпасть:",
					"- Одежда работника ДПС\n"\
					"- Одежда генирала армии\n"\
					"- Одежда снегурочки\n"\
					"- Одежда 'Илья'\n"\
					"- Одежда генирала ФСБ\n"\
					"- Одежда работника медицинской службы",
					"Понятно", "Закрыть"
				);
				//return 1;
			}
			if(GetNearestMedBed(playerid, 1.8) != -1)
			{
				MedBed_TryOccupy(playerid);
			}


/*			if(GetPlayerNearestATM(playerid) != -1)
			{
				ShowPlayerATMDialog(playerid);
			}*/
			if(GetPlayerInHouse(playerid) != -1)
			{
				new houseid = GetPlayerInHouse(playerid);
				if(GetHouseData(houseid, H_IMPROVEMENTS) >= 1)
				{
					ExitPlayerFromHouse(playerid, 1.1);
				}
			}

	/*		if(GetPlayerData(playerid, P_LAST_PICKUP) != -1)
			{
				new pickupid = GetPlayerData(playerid, P_LAST_PICKUP);
				new action_id = GetPickupInfo(pickupid, P_ACTION_ID);

				if(IsPlayerInRangeOfPoint(playerid, 1.7, GetPickupInfo(pickupid, P_POS_X), GetPickupInfo(pickupid, P_POS_Y), GetPickupInfo(pickupid, P_POS_Z)))
				{
					switch(GetPickupInfo(pickupid, P_ACTION_TYPE))
					{

					}
				}
			}
		*/
			if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) != -1)
			{
				ExitPlayerFromHotelRoom(playerid);
			}
		}
		if(PRESSED(KEY_HANDBRAKE | KEY_WALK))
		{
			new targetid = GetPlayerTargetPlayer(playerid);
			//new targetid = playerid;

			if(targetid != INVALID_PLAYER_ID && !GetPlayerWeapon(playerid))
			{
				SetPlayerData(playerid, P_TARGET_ID, targetid);

				new fmt_str[64];
				format(fmt_str, sizeof fmt_str, "{FFCD00}Действия (%s)", GetPlayerNameEx(targetid));

				Dialog
				(
					playerid, DIALOG_ACTION, DIALOG_STYLE_LIST,
					fmt_str,
					"1. Приветствие\n\
					2. Показать паспорт\n\
					3. Показать лицензии\n\
					4. Показать навыки",
					"Выбрать", "Закрыть"
				);
			}
		}
		if(PRESSED(KEY_HANDBRAKE))
		{
			if(GetPVarInt(playerid, "have_jerrican") == 1 && GetPlayerSpeed(playerid) == 0.0)
			{
				new vehicleid = GetNearestVehicleID(playerid, 2.3);
				if(vehicleid != INVALID_VEHICLE_ID)
				{
					SetPVarInt(playerid, "jerrican_fill_car", vehicleid);

					Dialog
					(
						playerid, DIALOG_JERRICAN_FILL_CAR, DIALOG_STYLE_MSGBOX,
						"{6699FF}Канистра",
						"{FFFFFF}Вы хотите заправить этот транспорт с канистры?",
						"Да", "Нет"
					);
				}
			}
		}
		if(PRESSED(KEY_CTRL_BACK | KEY_HANDBRAKE))
		{
			if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
			{
				callcmd::car(playerid, "");
			}
		}
					else if(PRESSED(KEY_CTRL_BACK))
		{
			callcmd::trunk(playerid, "");
		}
	}
	return 1;
}

