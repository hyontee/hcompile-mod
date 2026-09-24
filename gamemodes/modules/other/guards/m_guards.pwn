CMD:testg ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return false ;

	new actorId = CreateActor ( 110, p_t_info [ playerid ] [ p_pos ] [ 0 ] + ( random ( 2 ) ), p_t_info [ playerid ] [ p_pos ] [ 1 ] + ( random ( 2 ) ), p_t_info [ playerid ] [ p_pos ] [ 2 ], 90.0 ) ;
	GetPlayerTimeInfo ( playerid, PT_GUARD_ID ) = actorId ;
	GetActorInfo ( actorId, ACTOR_TYPE ) = ACTOR_TYPE_GUARD ;
	GetActorInfo ( actorId, ACTOR_NUM_ID ) = playerid ;
	return true ;
}

stock clearPlayerGuards ( playerid )
{
	GetPlayerTimeInfo ( playerid, PT_GUARD_ID ) = INVALID_ACTOR_ID ;
	GetPlayerTimeInfo ( playerid, PT_GUARD ) = -1 ;
	return true ;
}

stock guards_OnActorTakeDamage ( actorid, receiverid, Float: amount, weaponid, bodypart )
{
	#pragma unused bodypart
	if ( GetActorInfo ( actorid, ACTOR_TYPE ) == ACTOR_TYPE_GUARD )
	{
		new ownerId = GetActorInfo ( actorid, ACTOR_NUM_ID ),
			guardNum = GetPlayerTimeInfo ( ownerId, PT_GUARD ) ;

		new guardId = GetPlayerTimeInfo ( receiverid, PT_GUARD_ID ) ;
		if ( guardId != INVALID_ACTOR_ID )
		{
			GetActorInfo ( guardId, ACTOR_ATTACK_ID ) = ownerId ;
			DisableRemoteActorCollisions ( -1, guardId, false ) ;
			actorAttack ( -1, guardId, ownerId ) ;
		}
		
		if ( ( ( 22 <= weaponid <= 34 ) || weaponid == 38 ) )
		{
			#if defined debug_mode
				printf ( "22 <= weaponid <= 34) || weaponid == 38" ) ;
			#endif
			
			if ( pl_afk_time [ receiverid ] > 2 )
			{
				GiveDamageForPlayer ( receiverid, actorid, weaponid, 0.0 ) ;
				return 1 ;
			}

			if ( player_killed [ receiverid ] )
			{
				anti_cheat ( receiverid, "nop gm", 0 ) ;
				if ( GetPlayerDistanceFromPoint ( receiverid, player_death_pos [ receiverid ] [ 0 ],
															player_death_pos [ receiverid ] [ 1 ],
															player_death_pos [ receiverid ] [ 2 ] ) > 5 )
				{
					nop_gm_count ++ ;

					if ( nop_gm_toggled == true ) anti_cheat ( receiverid, "nop gm", 999 ) ;
				}
			}

			switch ( weaponid )
			{
				case 22: GiveDamageForPlayer ( receiverid, actorid, weaponid, 4.0 ) ; // Colt
				case 23: GiveDamageForPlayer ( receiverid, actorid, weaponid, 14.0 ) ; // SD Pistol
				case 24:
				{
					if ( GetGuardStats ( ownerId, GUARD_GUN_SKILLS, guardNum, 1 ) < 20 )
					{
						GiveDamageForPlayer ( receiverid, actorid, weaponid, 24.0 ) ; // Deagle
					}
					else
					{
						GiveDamageForPlayer ( receiverid, actorid, weaponid, 47.0 ) ; // Deagle
					}
				}
				case 25:
				{
					if ( amount <= 0.0 || amount > 30.0 ) amount = 30.0 ;
					GiveDamageForPlayer ( receiverid, actorid, weaponid, amount ) ; // Shotgun
				}
				case 28: GiveDamageForPlayer ( receiverid, actorid, weaponid, 6.0 ) ;  // Micro-Uzi
				case 29: GiveDamageForPlayer ( receiverid, actorid, weaponid, 8.0 ) ;  // MP5
				case 30: GiveDamageForPlayer ( receiverid, actorid, weaponid, 10.0 ) ; // AK-47
				case 31: GiveDamageForPlayer ( receiverid, actorid, weaponid, 10.0 ) ; // M4A1
				case 33: GiveDamageForPlayer ( receiverid, actorid, weaponid, 25.0 ) ; // Rifle
				case 34: GiveDamageForPlayer ( receiverid, actorid, weaponid, 41.0 ) ; // Sniper
				case 38: GiveDamageForPlayer ( receiverid, actorid, weaponid, 47.0 ) ; // Minigun
				default: return 1 ;
			}
		}
	}
	return false ;
}

stock guards_OnActorGiveDamage ( actorid, senderid, Float: amount, weaponid, bodypart )
{
	#pragma unused bodypart
	#pragma unused weaponid
	if ( GetActorInfo ( actorid, ACTOR_TYPE ) == ACTOR_TYPE_GUARD )
	{
		new ownerId = GetActorInfo ( actorid, ACTOR_NUM_ID ),
			actorNum = GetPlayerTimeInfo ( ownerId, PT_GUARD ),
			health ;

		GetGuardInfo ( ownerId, GUARD_HP, actorNum ) -= floatround ( amount ) ;

		health = GetGuardInfo ( ownerId, GUARD_HP, actorNum ) ;
		if ( health < 1 )
		{
			DestroyActor ( actorid ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "Ваш охранник был убит игроком %s", p_info [ senderid ] [ name ] ) ;
			send_check_cinfo ( ownerId, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_WARNING, "", "" ) ;
		}
		if ( health < 100 ) SetActorHealth ( ownerId, health ) ;
		return true ;
	}
	return false ;
}

stock guards_OnPlayerGiveDamage ( playerid, damagedid, Float: amount, weaponid, bodypart )
{
	#pragma unused amount
	#pragma unused bodypart
	#pragma unused weaponid
	new guardId = GetPlayerTimeInfo ( damagedid, PT_GUARD_ID ) ;
	if ( guardId != INVALID_ACTOR_ID )
	{
		DisableRemoteActorCollisions ( -1, guardId, false ) ;
		actorAttack ( -1, guardId, playerid ) ;
		GetActorInfo ( guardId, ACTOR_ATTACK_ID ) = playerid ;
	}
	return true ;
}

stock guards_OnPlayerEnterVehicle ( playerid, vehicleid )
{
	new guardId = GetPlayerTimeInfo ( playerid, PT_GUARD_ID ) ;
	if ( guardId != INVALID_ACTOR_ID )
	{
		if ( GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) == INVALID_VEHICLE_ID )
		{
			GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) = vehicleid ;
			actorEnterCarPass ( -1, guardId, vehicleid, -1 ) ;
		}
	}
	return true ;
}

stock guards_OnPlayerExitVehicle ( playerid, vehicleid )
{
	new guardId = GetPlayerTimeInfo ( playerid, PT_GUARD_ID ) ;
	if ( guardId != INVALID_ACTOR_ID )
	{
		if ( GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) != INVALID_VEHICLE_ID )
		{
			actorRemoveFromVeh ( -1, guardId, vehicleid, 0 ) ;
			GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) = INVALID_VEHICLE_ID ;
		}
	}
	return true ;
}

stock SetMoveGuards ( playerid )
{
	new guardId = GetPlayerTimeInfo ( playerid, PT_GUARD_ID ) ;
	if ( guardId != INVALID_ACTOR_ID )
	{
		new vehicleId = GetPlayerVehicleID ( playerid ) ;
		if ( GetPlayerVehicleID ( playerid ) )
		{
			if ( GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) == INVALID_VEHICLE_ID )
			{
				GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) = vehicleId ;
				actorEnterCarPass ( -1, guardId, vehicleId, -1 ) ;
			}
			else if ( GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) != INVALID_VEHICLE_ID )
				SetActorPos ( guardId, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) ;
            
			return true ;
		}
		else
		{
			if ( GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) != INVALID_VEHICLE_ID )
			{
				actorRemoveFromVeh ( -1, guardId, GetActorInfo ( guardId, ACTOR_VEHICLE_ID ), 0 ) ;
				GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) = INVALID_VEHICLE_ID ;
			}
		}

		if ( GetActorInfo ( guardId, ACTOR_ATTACK_ID ) != INVALID_PLAYER_ID )
		{
			new targetId = GetActorInfo ( guardId, ACTOR_ATTACK_ID ),
				Float: _distance = GetPlayerDistanceFromPoint ( targetId, GetPosActor ( guardId, 0 ), GetPosActor ( guardId, 1 ), GetPosActor ( guardId, 2 ) ) ;
		
			if ( _distance > 300 )
			{
				GetActorInfo ( guardId, ACTOR_ATTACK_ID ) = INVALID_PLAYER_ID ;
				DisableRemoteActorCollisions ( -1, guardId, true ) ;
				actorClearTasks ( -1, guardId ) ;
			}
		}

		new Float: x, Float: y, Float: z,
			Float: _distance = GetPlayerDistanceFromPoint ( playerid, GetPosActor ( guardId, 0 ), GetPosActor ( guardId, 1 ), GetPosActor ( guardId, 2 ) ) ;
		
		GetPosActor ( guardId, 0 ) = p_t_info [ playerid ] [ p_pos ] [ 0 ] + ( random ( 2 ) + 0.5 ) ;
		GetPosActor ( guardId, 1 ) = p_t_info [ playerid ] [ p_pos ] [ 1 ] + ( random ( 2 ) + 0.5 ) ;
		GetPosActor ( guardId, 2 ) = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;
  		actorGuardGoto ( -1, playerid, guardId, GetPosActor ( guardId, 0 ), GetPosActor ( guardId, 1 ), GetPosActor ( guardId, 2 ), 125 ) ;

		GetActorPos ( guardId, x, y, z ) ;
		_distance = GetDistanceBetweenPoints ( x, y, z, GetPosActor ( guardId, 0 ), GetPosActor ( guardId, 1 ), GetPosActor ( guardId, 2 ) ) ;
		if ( _distance > 200 )
		{
			SetActorPos ( guardId, GetPosActor ( guardId, 0 ), GetPosActor ( guardId, 1 ), GetPosActor ( guardId, 2 ) ) ;
		}
	}
	return true ;
}

stock SetMinuteActionGuards ( playerid )
{
	new guardId = GetPlayerTimeInfo ( playerid, PT_GUARD_ID ),
		guardNum = GetPlayerTimeInfo ( playerid, PT_GUARD ) ;
	if ( guardId != INVALID_ACTOR_ID )
	{
		if ( GetGuardInfo ( playerid, GUARD_HP, guardNum ) < floatround ( GetGuardInfo ( playerid, GUARD_MAX_HP, guardNum ) / 10 ) )
		{
			new guardItem = GetInventoryFindItem ( playerid, SUB_INV_GUARDS, ITEM_AID_KIT ) ;
			if ( guardItem > 0 )
			{
				new Float: pl_health ;
				GetActorHealth ( guardId, pl_health ) ;
				if ( pl_health + 65 > 100 ) SetActorHealth ( guardId, 100 ) ;
				else SetActorHealth ( guardId, pl_health + 65 ) ;

				GetGuardInfo ( playerid, GUARD_HP, guardNum ) += 65 ;

				if ( GetActorInfo ( guardId, ACTOR_VEHICLE_ID ) == INVALID_VEHICLE_ID )
					ApplyActorAnimation ( guardId, "ped", "gum_eat", 4.0, 0, 0, 0, 0, 0 ) ;

				ClearInventory ( playerid, SUB_INV_GUARDS, ITEM_AID_KIT, 1 ) ;
			}
			else
			{
				switch ( random ( 3 ) )
				{
					case 0: SetActorChatBubble ( -1, guardId, "Подайте бедолаге аптечку", col_white, 15, 10000 ) ;
					case 1: SetActorChatBubble ( -1, guardId, "Аптечечку бы...", col_white, 15, 10000 ) ;
					case 2: SetActorChatBubble ( -1, guardId, "Человек, лечи меня, быстро", col_white, 15, 10000 ) ;
				}
			}
		}
	}
	return true ;
}

callback: LoadUsersGuards ( playerid, init )
{
	if ( init )
	{
		static const _str [ ] = "SELECT * FROM users_guards WHERE u_id = %d LIMIT %d" ;
		new query_string [ sizeof _str + ( 9 * 2 ) ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], MAX_GUARDS ) ;
		mysql_tquery ( sql_connection, query_string, "LoadUserGuards", "ii", playerid, 0 ) ;
	}
	else
	{
		for ( new i = 0 ; i < MAX_GUARDS ; i ++ )
			GUARD_INFO [ playerid ] [ i ] = clearGuardStruct ;

		new rows, fields ;
		cache_get_data ( rows, fields ) ;
		if ( ! rows ) return false ;

		new guardName [ 32 ] ;
		for ( new i = 0 ; i < rows ; i ++ )
		{
			GetGuardInfo ( playerid, GUARD_ID, i ) = cache_get_field_content_int ( i, "id" ) ;
			GetGuardInfo ( playerid, GUARD_SKIN, i ) = cache_get_field_content_int ( i, "guard_skin" ) ;
			GetGuardInfo ( playerid, GUARD_TYPE, i ) = cache_get_field_content_int ( i, "guard_type" ) ;
			GetGuardInfo ( playerid, GUARD_LEVEL, i ) = cache_get_field_content_int ( i, "guard_level" ) ;
			GetGuardInfo ( playerid, GUARD_EXP, i ) = cache_get_field_content_int ( i, "guard_exp" ) ;
			GetGuardInfo ( playerid, GUARD_HP, i ) = cache_get_field_content_int ( i, "guard_hp" ) ;
			GetGuardInfo ( playerid, GUARD_MAX_HP, i ) = cache_get_field_content_int ( i, "guard_max_hp" ) ;
			GetGuardInfo ( playerid, GUARD_ARM, i ) = cache_get_field_content_int ( i, "guard_arm" ) ;
			GetGuardInfo ( playerid, GUARD_MAX_ARM, i ) = cache_get_field_content_int ( i, "guard_max_arm" ) ;
			cache_get_field_content ( i, "guard_name", guardName ) ;
			SetGuardName ( playerid, i, guardName ) ;

			global_string [ 0 ] = EOS ;
			cache_get_field_content ( i, "guard_main_stats", global_string, sql_connection ) ;
			JsonConvertGuardObject ( global_string, "gm_stats", 0, playerid, i ) ;

			global_string [ 0 ] = EOS ;
			cache_get_field_content ( i, "guard_open_stats", global_string, sql_connection ) ;
			JsonConvertGuardIterate ( global_string, "go_stats", 1, playerid, i ) ;

			global_string [ 0 ] = EOS ;
			cache_get_field_content ( i, "guard_gun_skills", global_string, sql_connection ) ;
			JsonConvertGuardIterate ( global_string, "ggs_stats", 2, playerid, i ) ;
		}

		for ( new i = 0 ; i < MAX_GUARDS ; i ++ )
		{
			if ( GetGuardInfo ( playerid, GUARD_LOAD, i ) ) continue ;

			GetGuardInfo ( playerid, GUARD_LOAD, i ) = true ;
			InventoryLoading ( GetGuardInfo ( playerid, GUARD_ID, i ), playerid, SUB_INV_GUARDS, 1 ) ;
			break ;
		}
	}
	return true ;
}

stock JsonConvertGuardObject ( data [ ], nameUpgrade [ ], upgradeId, playerid, guardId )
{
	new idx = 0 ;
	if ( strlen ( data ) > 5 )
	{
		new Node: json, Node: nodeIterate, Node: nodeWrite ;
		JSON_Parse ( data, json ) ;

		JSON_GetArray ( json, nameUpgrade, nodeIterate ) ;

		while ( ! JSON_ArrayObject ( nodeIterate, idx, nodeWrite ) )
		{
			if ( upgradeId == 0 )
			{
				JSON_GetInt ( nodeWrite, "level", GetGuardStats ( playerid, GUARD_MAIN_LEVEL, guardId, idx ) ) ;
				JSON_GetInt ( nodeWrite, "stats", GetGuardStats ( playerid, GUARD_MAIN_STATS, guardId, idx ) ) ;
			}
			idx ++ ;
		}
	}
	return true ;
}

stock JsonConvertGuardIterate ( data [ ], nameUpgrade [ ], upgradeId, playerid, guardId )
{
	new idx = 0 ;
	if ( strlen ( data ) > 5 )
	{
		new Node: json, Node: nodeIterate, Node: nodeWrite ;
		JSON_Parse ( data, json ) ;

		JSON_GetArray ( json, nameUpgrade, nodeIterate ) ;

		while ( ! JSON_ArrayIterate ( nodeIterate, idx, nodeWrite ) )
		{
			if ( upgradeId == 1 )
			{
				JSON_GetNodeInt ( nodeWrite, GetGuardStats ( playerid, GUARD_OPEN_STATS, guardId, idx ) ) ;
			}
			else if ( upgradeId == 2 )
			{
				JSON_GetNodeInt ( nodeWrite, GetGuardStats ( playerid, GUARD_GUN_SKILLS, guardId, idx ) ) ;
			}
			idx ++ ;
		}
	}
	return true ;
}

stock SaveGuardMain ( playerid, guardId )
{
	new Node: guardMainStats = JSON_Object ( "gm_stats", JSON_Array ( ) ) ;
	for ( new idx = 0 ; idx < 5 ; idx ++ )
    {
        JSON_ArrayAppend ( guardMainStats, "gm_stats", 
			JSON_Object (
				"level",		JSON_Int ( GetGuardStats ( playerid, GUARD_MAIN_LEVEL, guardId, idx ) ),
				"stats",		JSON_Int ( GetGuardStats ( playerid, GUARD_MAIN_STATS, guardId, idx ) )
			)
		) ;
    }

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( guardMainStats, global_string, sizeof global_string ) ;
	static const _str [ ] = "UPDATE users_guards SET guard_main_stats = '%s' WHERE id = %d LIMIT 1" ;
	new query_string [ sizeof _str + 512 ] ;
	format ( query_string, sizeof query_string, _str, global_string, GetGuardInfo ( playerid, GUARD_ID, guardId ) ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}

stock SaveGuardOpen ( playerid, guardId )
{
	new Node: guardOpenStats = JSON_Object ( "go_stats", JSON_Array ( ) ) ;
	for ( new idx = 0 ; idx < 6 ; idx ++ )
    {
        JSON_ArrayAppend ( guardOpenStats, "go_stats", JSON_Int ( GetGuardStats ( playerid, GUARD_OPEN_STATS, guardId, idx ) ) ) ;
    }

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( guardOpenStats, global_string, sizeof global_string ) ;
	static const _str [ ] = "UPDATE users_guards SET guard_open_stats = '%s' WHERE id = %d LIMIT 1" ;
	new query_string [ sizeof _str + 100 ] ;
	format ( query_string, sizeof query_string, _str, global_string, GetGuardInfo ( playerid, GUARD_ID, guardId ) ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}

stock SaveGuardSkills ( playerid, guardId )
{
	new Node: guardGunSkills = JSON_Object ( "ggs_stats", JSON_Array ( ) ) ;
	for ( new idx = 0 ; idx < 7 ; idx ++ )
    {
        JSON_ArrayAppend ( guardGunSkills, "ggs_stats", JSON_Int ( GetGuardStats ( playerid, GUARD_GUN_SKILLS, guardId, idx ) ) ) ;
    }

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( guardGunSkills, global_string, sizeof global_string ) ;
	static const _str [ ] = "UPDATE users_guards SET guard_gun_skills = '%s' WHERE id = %d LIMIT 1" ;
	new query_string [ sizeof _str + 100 ] ;
	format ( query_string, sizeof query_string, _str, global_string, GetGuardInfo ( playerid, GUARD_ID, guardId ) ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}