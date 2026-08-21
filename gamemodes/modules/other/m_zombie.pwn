#define need_re_shot 5000
#define to_re_respawn 7200

new Float: RE_Spawn [ 4 ] = { 2000.4683, -1485.5654, 62.9107, 234.2677 } ;
new RE_Shot = 0, RE_Actor ;
new RE_LastDamaged = -1 ;
new RE_thirty_second [ 3 ] = { 0, ... } ;

stock zombie_OnGameModeInit ( )
{
	RE_Actor = CreateActor ( 4765, RE_Spawn [ 0 ], RE_Spawn [ 1 ], RE_Spawn [ 2 ], 90.0 ) ;
	actorInvulnerable ( -1, RE_Actor, false ) ;
	return 1 ;
}

stock zombie_second_timer ( )
{
	RE_thirty_second [ 0 ] ++ ;
	RE_thirty_second [ 1 ] ++ ;
	RE_thirty_second [ 2 ] ++ ;
	if ( RE_thirty_second [ 0 ] >= 5 )
	{
		if ( IsValidActor ( RE_Actor ) )
		{
			if ( RE_LastDamaged != -1 )
			{
				if ( ! IsPlayerConnected ( RE_LastDamaged ) || GetPlayerDistanceFromPoint ( RE_LastDamaged, RE_Spawn [ 0 ], RE_Spawn [ 1 ], RE_Spawn [ 2 ] ) > 100 )
				{
					RE_LastDamaged = -1 ;
					actorClearTasks ( -1, RE_Actor ) ;
					actorSetPosFindZ ( -1, RE_Actor, RE_Spawn [ 0 ], RE_Spawn [ 1 ], RE_Spawn [ 2 ] ) ;
					return 1 ;
				}
				
				actorClearTasks ( -1, RE_Actor ) ;
				actorInvulnerable ( -1, RE_Actor, false ) ;
				if ( random ( 2 ) == 1 )
				{
					if ( random ( 2 ) == 1 )
					{
						actorGoto ( -1, RE_Actor, p_t_info [ RE_LastDamaged ] [ p_pos ] [ 0 ], p_t_info [ RE_LastDamaged ] [ p_pos ] [ 1 ], p_t_info [ RE_LastDamaged ] [ p_pos ] [ 2 ], 125.0 ) ;
					}
					else
					{
						actorSetPosFindZ ( -1, RE_Actor, p_t_info [ RE_LastDamaged ] [ p_pos ] [ 0 ], p_t_info [ RE_LastDamaged ] [ p_pos ] [ 1 ], p_t_info [ RE_LastDamaged ] [ p_pos ] [ 2 ] ) ;
					}
				}
				else
				{
					actorAttack ( -1, RE_Actor, RE_LastDamaged ) ;
				}
			}
		}
		RE_thirty_second [ 0 ] = 0 ;
	}
	
	if ( RE_thirty_second [ 1 ] >= 10 )
	{
		if ( IsValidActor ( RE_Actor ) )
		{
			if ( RE_LastDamaged != -1 )
			{
				new Float: _maxDamage = 30.0 ;
				set_health ( RE_LastDamaged, p_t_info [ RE_LastDamaged ] [ p_health ] - _maxDamage ) ;
				foreach(new i: streamed_players[RE_LastDamaged])
				{
					if ( GetPlayerDistanceFromPoint ( i, RE_Spawn [ 0 ], RE_Spawn [ 1 ], RE_Spawn [ 2 ] ) > 100 ) continue ;
					if ( _maxDamage < 1 ) break ;
					
					_maxDamage -= 1.0 ;
					set_health ( i, p_t_info [ i ] [ p_health ] - _maxDamage ) ;
				}
			}
		}
		RE_thirty_second [ 1 ] = 0 ;
	}
	
	if ( RE_thirty_second [ 2 ] >= to_re_respawn )
	{
		if ( ! IsValidActor ( RE_Actor ) )
		{
			RE_Actor = CreateActor ( 4765, RE_Spawn [ 0 ], RE_Spawn [ 1 ], RE_Spawn [ 2 ], 90.0 ) ;
			actorInvulnerable ( -1, RE_Actor, false ) ;
		}
		RE_thirty_second [ 2 ] = 0 ;
	}
	return 1 ;
}

stock zombie_WeaponShot ( playerid, _actorId, Float: _amount, _weaponId, _bodypart )
{
	#pragma unused _amount
	#pragma unused _weaponId
	#pragma unused _bodypart
	if ( _actorId == RE_Actor )
	{
		RE_Shot ++ ;
		SetActorHealth ( RE_Actor, 100.0 ) ;
		RE_LastDamaged = playerid ;
		if ( RE_Shot >= need_re_shot )
		{
			actorSetName ( -1, RE_Actor, "" ) ;
			if ( IsValidActor ( RE_Actor ) ) DestroyActor ( RE_Actor ) ;
			RE_thirty_second [ 2 ] = 0 ;
			RE_LastDamaged = -1 ;
			
			if ( random ( 60 ) == 1 )
			{
				new _random = Iter_Random(streamed_players[playerid]), _item ;
				if ( IsPlayerConnected ( _random ) )
				{
					switch ( random ( 3 ) )
					{
						case 0:
						{
							_item = 202 ;
							give_inventory ( _random, 2202, 1, 0, "", "", 0, 0, -1 ) ;
							
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 202 ) ) ;
							SendClientMessage ( _random, col_yellow, global_string ) ;
						}
						case 1:
						{
							_item = 203 ;
							give_inventory ( _random, 2203, 1, 0, "", "", 0, 0, -1 ) ;
							
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 203 ) ) ;
							SendClientMessage ( _random, col_yellow, global_string ) ;
						}
						case 2:
						{
							_item = 204 ;
							give_inventory ( _random, 2204, 1, 0, "", "", 0, 0, -1 ) ;
							
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 204 ) ) ;
							SendClientMessage ( _random, col_yellow, global_string ) ;
						}
					}
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}%s получи(а) %s!", item_name ( _item ) ) ;
					foreach(new i: streamed_players[_random])
					{
						if ( GetPlayerDistanceFromPoint ( i, RE_Spawn [ 0 ], RE_Spawn [ 1 ], RE_Spawn [ 2 ] ) > 100 ) continue ;
						
						SendClientMessage ( i, col_white, scm_string ) ;
					}
				}
			}
			else
			{
				foreach(new i: streamed_players[playerid])
				{
					if ( GetPlayerDistanceFromPoint ( i, RE_Spawn [ 0 ], RE_Spawn [ 1 ], RE_Spawn [ 2 ] ) > 100 ) continue ;
					
					SendClientMessage ( i, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, карманы босса были пусты. Вы ничего не получаете." ) ;
				}
			}
		}
		else
		{
			new _str [ 24 ] ;
			format ( _str, sizeof _str, "%d", need_re_shot - RE_Shot ) ;
			actorSetName ( -1, RE_Actor, _str ) ;
		}
		return 1 ;
	}
	return 0 ;
}