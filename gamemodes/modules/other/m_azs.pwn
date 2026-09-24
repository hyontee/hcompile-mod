#include <custom/azs_station>

stock show_packet_azs ( playerid, _param1, _param2 )
{
	if ( _param1 == 0 )
	{
		filling_count { playerid } = 0 ;
		hideAzs ( playerid ) ;
		toggle_controlable ( playerid, true ) ;
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	else if ( _param1 == 1 )
	{
		if ( filling_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Ваш транспорт уже заправляется.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
	    new veh_id = GetPlayerVehicleID ( playerid ) ;
		if ( veh_id == 0 || veh_id == INVALID_VEHICLE_ID )
		{
			send_check_cinfo ( playerid, "Вы должны находиться в транспортном средстве.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		filling_count { playerid } = _param2 ;
		new b = GetPVarInt ( playerid, "f_biz" ), _value = filling_count { playerid } ;
		new fill_price = _value * b_price_market [ b ] [ 0 ] ;
		
		#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_FUELL ), __fill_price = fill_price ;
			if ( _perk_stats > 0 ) fill_price = fill_price - floatround ( ( __fill_price * _perk_stats ) / 100 ) ;
		#endif
		
		if ( trucker_check_improve ( playerid, 1 ) )
	    {
			new _fill_price = fill_price ;
			fill_price = floatround ( ( _fill_price * 50 ) / 100 ) ;
	    }
		
		if ( _value < 1 )
		{
			send_check_cinfo ( playerid, "Вы не указали количество топлива.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		if ( p_info [ playerid ] [ money ] < fill_price )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно средств для заправки.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		new bool: _sucess_product = false ;
		if ( b_info [ b ] [ b_product ] < _value ) _sucess_product = true ;
		if ( floatround ( veh_info [ veh_id - 1 ] [ v_fuel ] ) + _value > 100 )
		{
			send_check_cinfo ( playerid, "Вы не можете залить более 100 л.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		give_money ( playerid, -fill_price ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, -fill_price, "заправка" ) ;

		if ( ! _sucess_product ) give_bmoney ( b + 1, fill_price, _value ) ;
		b_info [ b ] [ b_visitors ] ++ ;
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, false, lights, alarm, doors, bonnet, boot, objective ) ;

		toggle_controlable ( playerid, false ) ;
		filling_timer [ playerid ] = SetTimerEx ( "filling_time", 500, 1, "ii", playerid, GetPlayerVehicleID ( playerid ) ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Началась заправка Вашего транспортного средства. Ожидайте завершения..." ) ;
		
		hideAzs ( playerid ) ;
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;

		DeletePVar ( playerid, "f_biz" ) ;
	}
	else if ( _param1 == 2 )
	{
		if ( _param2 == 0 )
		{
			new b = GetPVarInt ( playerid, "f_biz" ), dialog_string [ 115 + 9 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cWH"}Стоимость канистры составляет {"#cGN"}%d$\n\n{"#cGRDialog"}* Вы действитель желаете приобрести канистру?", b_price_market [ b ] [ 1 ] ) ;
			show_dialog ( playerid, d_filling_canister, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка канистры", dialog_string, "Купить", "Назад" ) ;
		}
		else if ( _param2 == 1 )
		{
			new t = GetPVarInt ( playerid, "f_biz" ) ;
			if ( b_price_market [ t ] [ 2 ] < 1 )
			{
				send_check_cinfo ( playerid, "Цена за ремонт не назначена владельцем заправки.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( b_info [ t ] [ b_owner_inc ] == -1 )
			{
				send_check_cinfo ( playerid, "У данной заправки нет владельца, она не работает.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( GetPlayerVehicleID ( playerid ) < 1 )
			{
				send_check_cinfo ( playerid, "Вы не в транспортном средстве.", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

		    new dialog_string [ 102 + 9 ] ;
		    format ( dialog_string, sizeof dialog_string, "{"#cWH"}Стоимость починки: {"#cGN"}%d$\n\n{"#cGRDialog"}* Вы хотите починить транспортное средство?", b_price_market [ t ] [ 2 ] ) ;
			show_dialog ( playerid, d_filling_repair, DIALOG_STYLE_MSGBOX, "{"#cBL"}Заправочная станция", dialog_string, "Выбрать", "Закрыть" ) ;
		}
	}
	return 1 ;
}