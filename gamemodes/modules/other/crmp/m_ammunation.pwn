new Float: TirInfo [ 6 ] [ 3 ] =
{
	{ 8.4649, -1095.1846, 1029.8208 },
	{ 10.3139, -1095.8544, 1029.8208 },
	{ 12.1566, -1096.5880, 1029.8281 },
	{ 13.9946, -1097.2624, 1029.8208 },
	{ 15.9106, -1097.8937, 1029.8208 },
	{ 17.8469, -1098.5986, 1029.8281 }
} ;

new Tir_CP [ MAX_BUSINESS ] [ 6 ] ;
new Text3D: TirText [ MAX_BUSINESS ] [ 6 ] ;

stock ammunation_create ( )
{
	foreach(new b: business_types[bizz_type_ammo])
	{
		for ( new i = 0 ; i < sizeof TirInfo ; i ++ )
		{
			Tir_CP [ b ] [ i ] = CreateDynamicCP ( TirInfo [ i ] [ 0 ], TirInfo [ i ] [ 1 ], TirInfo [ i ] [ 2 ], 1.0, b + 1000, 1, -1, 10.0);
			TirText [ b ] [ i ] = CreateDynamic3DTextLabel ( "** Тир **\n\n{"#cGR3D"}Место для стрельбы", col_header_3d, TirInfo [ i ] [ 0 ], TirInfo [ i ] [ 1 ], TirInfo [ i ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, b + 1000, -1 ) ;
		}
	}
	return 1 ;
}

stock tir_OnPlayerEnterDynamicCP ( playerid, checkpointid )
{
 	if ( p_t_info [ playerid ] [ shooting_time ] < gettime ( ) )
 	{
		foreach(new b: business_types[bizz_type_ammo])
		{
			for ( new i = 0 ; i < sizeof TirInfo ; i ++ )
			{
				if ( checkpointid == Tir_CP [ b ] [ i ] ) return ShowTirTutDialog ( playerid ) ;
			}
		}
	}
	return true ;
}

stock clear_ammunation ( playerid )
{
	if ( p_t_info [ playerid ] [ shooting_timer ] != -1 )
	{
		KillTimer ( p_t_info [ playerid ] [ shooting_timer ] ) ;
		p_t_info [ playerid ] [ shooting_timer ] = -1 ;
		p_t_info [ playerid ] [ shooting_time ] = gettime ( ) ;
		for ( new A = 0 ; A != 8 ; A ++ )
		{
			if ( IsValidDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) )
		    {
				DestroyDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) ;
				p_t_info [ playerid ] [ shooting_target_id ] [ A ] = INVALID_OBJECT_ID ;
			}
		}
	}
	return 1 ;
}

stock tir_OnPlayerDisconnect ( playerid )
{
	if ( p_t_info [ playerid ] [ shooting_timer ] != -1 )
	{
		KillTimer ( p_t_info [ playerid ] [ shooting_timer ] ) ;
		p_t_info [ playerid ] [ shooting_timer ] = -1 ;
		p_t_info [ playerid ] [ shooting_time ] = gettime ( ) ;
		for ( new A = 0 ; A != 8 ; A ++ )
		{
			if ( IsValidDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) )
		    {
				DestroyDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) ;
				p_t_info [ playerid ] [ shooting_target_id ] [ A ] = INVALID_OBJECT_ID ;
			}
		}
		
		reset_player_weapon ( playerid ) ;
		for ( new g = 0 ; g < 12 ; g ++ )
		{
			give_weapon ( playerid, duel_guns [ playerid ] [ g ] [ 0 ], duel_guns [ playerid ] [ g ] [ 1 ] ) ;
						
			duel_guns [ playerid ] [ g ] [ 0 ] =
			duel_guns [ playerid ] [ g ] [ 1 ] = 0 ;
		}
	}
	return 1 ;
}

stock ShowTirTutDialog ( playerid )
{
	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Здравствуйте! {"#cWH"}Вы заглянули в тир.\n");
	strcat ( global_string, "В тире вы можете практиковать свои навыки стрельбы.\n");
	strcat ( global_string, "Для стрельбы вам будет предложено несколько видов оружия.\n");
	strcat ( global_string, "Выбрав одно из них, нужно будет стрелять по мишени.\n");
	strcat ( global_string, "На мишени отмечены 5 точек, в которые нужно попадать.\n");
	strcat ( global_string, "Успешные пападания будут отображены в нижнем правом углу.\n");
	strcat ( global_string, "Для усложнения, мишень будет двигаться на вас.\n\n");
	strcat ( global_string, "{"#cLY"}1. Попасть надо во все 5 точек определенное кол-во раз.\n");
	strcat ( global_string, "{"#cLY"}2. С каждым разом скорость будет увеличиваться\n\n");
	strcat ( global_string, "{"#cGRDialog"}* Нажмите 'Далее' для продолжения.\n");

	show_dialog ( playerid, d_tir, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тир", global_string, "Далее", "Закрыть" ) ;
	return true ;
}

stock ShowTirDialog ( playerid )
{
    global_string [ 0 ] = EOS ; 
	new string [ 128 ], b = GetPVarInt ( playerid, "p_biz_id" ) - 1 ;
	strcat ( global_string, "{"#cBL"}Товар:\t{"#cBL"}Цена:\n" ) ;
    for ( new g = 0 ; g < 6 ; g ++ )
    {
		new price = b_price_market [ b ] [ g ] ;
		if ( b_info [ b ] [ b_mafia ] == p_info [ playerid ] [ member ] )
		{
		    price = floatround ( b_price_market [ b ] [ g ] / 50 ) ;
		}
		
		format ( string, sizeof ( string ), "{"#cGRDialog"}- {"#cWH"}%s\tЗа {"#cBL"}500 {"#cWH"}патрон {"#cGN"}%d"valute_title_"\n", b_gun_shop [ g ] [ bs_name ], price ) ;
		strcat ( global_string, string ) ;
	}
	show_dialog ( playerid, d_tir_gun, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Тир", global_string, "Выбор", "Закрыть" ) ;
	return true ;
}

stock ammunation_OnDialogResponse ( playerid, dialogid, response, listitem )
{
	switch ( dialogid )
	{
		case d_tir:
		{
			if ( ! response ) return 1 ;
			ShowTirDialog ( playerid ) ;
			return 1 ;
		}
		case d_tir_gun:
		{
			if ( ! response ) return 1 ;
			new b = GetPVarInt ( playerid, "p_biz_id" ) - 1 ;

			new price = b_price_market [ b ] [ listitem ] ;
			if ( b_info [ b ] [ b_mafia ] == p_info [ playerid ] [ member ] )
			{
			    price = floatround ( b_price_market [ b ] [ listitem ] / 50 ) ;
			}
			
			if ( p_info [ playerid ] [ money ] < price )
			{
			    ShowTirDialog ( playerid ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств." ) ;
				return 1 ;
			}
			if ( b_info [ b ] [ b_product ] < b_gun_shop [ listitem ] [ bs_product ] )
			{
			    ShowTirDialog ( playerid ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На складе недостаточно товара." ) ;
				return 1 ;
			}
			
			give_bmoney ( b + 1, price, b_gun_shop [ listitem ] [ bs_product ] ) ;

			give_money ( playerid, -price ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "тир в аммо" ) ;
			
			give_weapon ( playerid, b_gun_shop [ listitem ] [ bs_give ], 500 ) ;

			new _text_string [ 98 ] ;
			format ( _text_string, sizeof _text_string, "Вы приобрели %s (%i патронов) за %i"valute_title_"", b_gun_shop [ listitem ] [ bs_name ], 500, price ) ;
			SendClientMessage ( playerid, col_white, _text_string ) ;
			
			p_t_info [ playerid ] [ shooting_timer ] = SetTimerEx ( "OnPlayerShootingCycle", 2500 + random ( 2500 ), 0, "d", playerid ) ;
		    p_t_info [ playerid ] [ shooting_time ] = gettime ( ) + 300 ;
			
		    CreateShootingTarget ( playerid ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Достаньте нужное оружие и стреляйте по мишени." ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Если мишень автоматически не обновилась, используйте команду /sh_go." ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock ammunation_clear ( playerid )
{
	for ( new A = 0 ; A != 8 ; A ++ )
	{
		p_t_info [ playerid ] [ shooting_target_id ] [ A ] = INVALID_OBJECT_ID ;
		p_t_info [ playerid ] [ shooting_target_destroy ] [ A ] = 0 ;
	}
	p_t_info [ playerid ] [ shooting_timer ] = -1 ;
	p_t_info [ playerid ] [ shooting_time ] = 0 ;
	return 1 ;
}

stock tir_OnPlayerShootDynamicObject ( playerid, weaponid, objectid )
{
	if ( 22 <= weaponid <= 34 && p_t_info [ playerid ] [ shooting_timer ] != -1 )
	{
		for ( new A = 1 ; A != 8 ; A ++ ) if ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] == objectid ) p_t_info [ playerid ] [ shooting_target_destroy ] [ A ] = 1 ;
		for ( new A = 1 ; A != 8 ; A ++ )
		{
			if ( ! p_t_info [ playerid ] [ shooting_target_destroy ] [ A ] ) break ;
			if ( A == 7 ) UpdateShootingTarget ( playerid, 1 ) ;
		}
		gun_skill_up { playerid } += ( 1 * server_bonus [ 5 ] ) + 1 ;
		PlayerPlaySound ( playerid, 6401, 0.0, 0.0, 0.0 ) ;
	}
	return 1 ;
}

stock GetPlayerSkillCount ( playerid )
{
    new Player_Weapon = GetPlayerWeapon ( playerid ) ;
	if ( Player_Weapon == 23 ) return p_info [ playerid ] [ gun_skills ] [ 0 ] ;
    else if ( Player_Weapon == 24 ) return p_info [ playerid ] [ gun_skills ] [ 1 ] ;
    else if ( Player_Weapon == 25 ) return p_info [ playerid ] [ gun_skills ] [ 2 ] ;
    else if ( Player_Weapon == 29 ) return p_info [ playerid ] [ gun_skills ] [ 3 ] ;
    else if ( Player_Weapon == 30 ) return p_info [ playerid ] [ gun_skills ] [ 4 ] ;
    else if ( Player_Weapon == 31 ) return p_info [ playerid ] [ gun_skills ] [ 5 ] ;
    else if ( Player_Weapon == 33 ) return p_info [ playerid ] [ gun_skills ] [ 6 ] ;
	return 0 ;
}

CMD:sh_go ( playerid )
{
	if ( p_t_info [ playerid ] [ shooting_time ] < gettime ( ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У вас нет абонемента в тире." ) ;
	UpdateShootingTarget ( playerid, 1 ) ;
	return 1 ;
}

callback: OnPlayerShootingCycle ( playerid )
{
	if ( p_t_info [ playerid ] [ shooting_time ] < gettime ( ) )
	{
		if ( p_t_info [ playerid ] [ shooting_timer ] != -1 )
		{
			KillTimer ( p_t_info [ playerid ] [ shooting_timer ] ) ;
			p_t_info [ playerid ] [ shooting_timer ] = -1 ;
			for ( new A = 0 ; A != 8 ; A ++ )
			{
				if ( IsValidDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) )
			    {
					DestroyDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) ;
					p_t_info [ playerid ] [ shooting_target_id ] [ A ] = INVALID_OBJECT_ID ;
				}
			}
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Абонемент закончился." ) ;
		}
	}
	else
	{
		new Skill_Count = GetPlayerSkillCount ( playerid ) ;
		UpdateShootingTarget ( playerid ) ;
		p_t_info [ playerid ] [ shooting_timer ] = SetTimerEx ( "OnPlayerShootingCycle", 2500 + random ( 2500 ) - ( 2000 * Skill_Count / 100 ), 0, "d", playerid ) ;
	}
	return 1 ;
}

stock CreateShootingTarget ( playerid )
{
	new Virtual_World = GetPlayerVirtualWorld ( playerid ), Interior_ID = GetPlayerInterior ( playerid ) ;
    p_t_info [ playerid ] [ shooting_target_id ] [ 0 ] = CreateDynamicObject(3025, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	p_t_info [ playerid ] [ shooting_target_id ] [ 1 ] = CreateDynamicObject(3024, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	p_t_info [ playerid ] [ shooting_target_id ] [ 2 ] = CreateDynamicObject(3023, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	p_t_info [ playerid ] [ shooting_target_id ] [ 3 ] = CreateDynamicObject(3022, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	p_t_info [ playerid ] [ shooting_target_id ] [ 4 ] = CreateDynamicObject(3021, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	p_t_info [ playerid ] [ shooting_target_id ] [ 5 ] = CreateDynamicObject(3020, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	p_t_info [ playerid ] [ shooting_target_id ] [ 6 ] = CreateDynamicObject(3019, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	p_t_info [ playerid ] [ shooting_target_id ] [ 7 ] = CreateDynamicObject(3018, 19.0850, -1074.0758, 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
	for ( new A = 0 ; A != 8 ; A ++ ) p_t_info [ playerid ] [ shooting_target_destroy ] [ A ] = 0 ;
	Streamer_Update ( playerid ) ;
	return 1 ;
}

stock UpdateShootingTarget ( playerid, type = 0 )
{
	new Float:Target_Pos [ 2 ] ;
	new Virtual_World = GetPlayerVirtualWorld ( playerid ), Interior_ID = GetPlayerInterior ( playerid ) ;
	Target_Pos [ 0 ] = 12 + float ( random ( 12 ) ) ;
	Target_Pos [ 1 ] = -1094 + float ( random ( 20 ) ) ;
	if ( ! type )
	{
	    new Skill_Count = GetPlayerSkillCount ( playerid ) ;
		for ( new A = 0 ; A != 8 ; A ++ ) 
		{
			if ( IsValidDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) )
			{
				MoveDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ], Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.5+(1.5*Skill_Count/100), 0.00000, 0.00000, -20.00000);
			}
		}
	}
	else
	{
		for ( new A = 0 ; A != 8 ; A ++ ) 
		{
			if ( IsValidDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) )
			{
				DestroyDynamicObject ( p_t_info [ playerid ] [ shooting_target_id ] [ A ] ) ;
			}
		}
		
		p_t_info [ playerid ] [ shooting_target_id ] [ 0 ] = CreateDynamicObject(3025, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID); // -90.00000 - это поворот объекта к игроку
	    p_t_info [ playerid ] [ shooting_target_id ] [ 1 ] = CreateDynamicObject(3024, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
		p_t_info [ playerid ] [ shooting_target_id ] [ 2 ] = CreateDynamicObject(3023, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
		p_t_info [ playerid ] [ shooting_target_id ] [ 3 ] = CreateDynamicObject(3022, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
		p_t_info [ playerid ] [ shooting_target_id ] [ 4 ] = CreateDynamicObject(3021, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
		p_t_info [ playerid ] [ shooting_target_id ] [ 5 ] = CreateDynamicObject(3020, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
		p_t_info [ playerid ] [ shooting_target_id ] [ 6 ] = CreateDynamicObject(3019, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
		p_t_info [ playerid ] [ shooting_target_id ] [ 7 ] = CreateDynamicObject(3018, Target_Pos [ 0 ], Target_Pos [ 1 ], 1032.3549, 0.00000, 0.00000, -20.00000, Virtual_World, Interior_ID);
		for ( new A = 1 ; A != 8 ; A ++ ) p_t_info [ playerid ] [ shooting_target_destroy ] [ A ] = 0 ;
	}
	Streamer_Update ( playerid ) ;
	return 1 ;
}