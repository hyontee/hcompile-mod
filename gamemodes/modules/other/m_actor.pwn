
stock show_packet_actor ( playerid, _actorId, Float: _amount, _weaponId, _bodypart )
{
	new zombie = zombie_WeaponShot ( playerid, _actorId, Float: _amount, _weaponId, _bodypart ) ;

 	if ( ! zombie )
	{
	    for ( new A = 0 ; A != MAX_DEER ; A ++ )
	    {
	        if ( _actorId == DeerInfo [ A ] [ D_ObjectID ] && DeerInfo [ A ] [ D_Status ] != 3 )
	        {
			    if ( _weaponId == 31 )
			    {
			        if ( p_info [ playerid ] [ family_quest ] == 5 || p_info [ playerid ] [ family_quest ] == 1 )
				    {
				        if ( p_info [ playerid ] [ family_quest_progress ] < 10 )
				        {
				        	p_info [ playerid ] [ family_quest_progress ] ++ ;
					   		update_int_sql ( playerid, "u_family_quest_progress", p_info [ playerid ] [ family_quest_progress ] ) ;
					   	}
						else SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Задание успешно выполнено. Отправляйтесь к квестовому персонажу." ) ;
					}
					checking_quest_progress ( playerid, 3, 1, quest_line_high ) ;

				    if ( IsValidActor ( DeerInfo [ A ] [ D_ObjectID ] ) ) DestroyActor ( DeerInfo [ A ] [ D_ObjectID ] ) ;
		            DeerInfo [ A ] [ D_Status ] = 3 ;
		            DeerInfo [ A ] [ D_RespawnTime ] = gettime ( ) + 180 ;

					DeerInfo [ A ] [ D_Pickup ] = CreateDynamicPickup ( 1239, 23, DeerInfo [ A ] [ D_Pos ] [ 0 ], DeerInfo [ A ] [ D_Pos ] [ 1 ], DeerInfo [ A ] [ D_Pos ] [ 2 ], 0, 0 ) ;
			    	pick_info [ DeerInfo [ A ] [ D_Pickup ] ] [ pick_type ] = pick_type_deer ;
			    	pick_info [ DeerInfo [ A ] [ D_Pickup ] ] [ pick_item ] = A ;
					break ;
				}
				else
				{
			     	SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы спугнули оленя. Используйте винтовку! (/gps - Бизнесы - Охота и рыбалка)");

				    if ( IsValidActor ( DeerInfo [ A ] [ D_ObjectID ] ) ) DestroyActor ( DeerInfo [ A ] [ D_ObjectID ] ) ;
					DeerInfo [ A ] [ D_Status ] = 3 ;
					DeerInfo [ A ] [ D_RespawnTime ] = gettime ( ) + 900 ;
					break ;
				}
			}
		}
	}
	return 1 ;
}