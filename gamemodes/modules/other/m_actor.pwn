public OnActorStreamIn ( actorid, forplayerid )
{
	if ( actor_info [ actorid ] [ ACTOR_VEHICLE_ID ] != INVALID_VEHICLE_ID )
	{
		actorPutInVeh ( forplayerid, actorid, actor_info [ actorid ] [ ACTOR_VEHICLE_ID ], -1 ) ;
	}
	return true ;
}

stock actorEmptyAmmo ( actorId )
{
	actorGiveWeapon ( -1, actorId, 0, 0 ) ;
	return true ;
}

stock OnActorTakeDamage ( actorid, receiverid, Float: amount, weaponid, bodypart )
{
	guards_OnActorTakeDamage ( actorid, receiverid, amount, weaponid, bodypart ) ;
	return true ;
}

stock OnActorGiveDamage ( actorid, senderid, Float: amount, weaponid, bodypart )
{
	if ( guards_OnActorGiveDamage ( actorid, senderid, amount, weaponid, bodypart ) ) return true ;

	new zombie = zombie_WeaponShot ( senderid, actorid, amount, weaponid, bodypart ) ;
 	if ( ! zombie )
	{
	    for ( new A = 0 ; A != MAX_DEER ; A ++ )
	    {
	        if ( actorid == DeerInfo [ A ] [ D_ObjectID ] && DeerInfo [ A ] [ D_Status ] != 3 )
	        {
			    if ( weaponid == 34 )
			    {
			        if ( p_info [ senderid ] [ family_quest ] == 5 || p_info [ senderid ] [ family_quest ] == 1 )
				    {
				        if ( p_info [ senderid ] [ family_quest_progress ] < 10 )
				        {
				        	p_info [ senderid ] [ family_quest_progress ] ++ ;
					   		update_int_sql ( senderid, "u_family_quest_progress", p_info [ senderid ] [ family_quest_progress ] ) ;
					   	}
						else SendClientMessage ( senderid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Задание успешно выполнено. Отправляйтесь к квестовому персонажу." ) ;
					}
					checking_quest_progress ( senderid, 3, 1, quest_line_high ) ;

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
			     	SendClientMessage ( senderid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы спугнули оленя. Используйте винтовку! (/gps - Бизнесы - Охота и рыбалка)");

				    if ( IsValidActor ( DeerInfo [ A ] [ D_ObjectID ] ) ) DestroyActor ( DeerInfo [ A ] [ D_ObjectID ] ) ;
					DeerInfo [ A ] [ D_Status ] = 3 ;
					DeerInfo [ A ] [ D_RespawnTime ] = gettime ( ) + 900 ;
					break ;
				}
			}
		}
	}
	return true ;
}