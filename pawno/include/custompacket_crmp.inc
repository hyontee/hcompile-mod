const ID_RPC = 20 ;
const ID_CUSTOM_PACKET = 251 ;

#define RPC_MECHANICK_HOOK				86
#define RPC_EXTINGUISH_POINT_WITH_WATER 96

enum EXTINGUISH_STRUCT
{
	Float: EXTINGUISH_POINT_X,
	Float: EXTINGUISH_POINT_Y,
	Float: EXTINGUISH_POINT_Z,
	Float: EXTINGUISH_RADIUS,
	Float: EXTINGUISH_WATER_STRENGTH
} ;
static extinguishData [ EXTINGUISH_STRUCT ] ;

const RPC_GiveActorDamage = 177 ;
const RPC_ModeSettings = 207 ;
const RPC_ModeBinder = 208 ;
const RPC_BattlePass = 211 ;
const RPC_VoiceChat = 212 ;
const RPC_HudManager = 213 ;
const RPC_Finger = 220 ;
const RPC_CasinoDice = 248 ;
const RPC_NewBieBattle = 254 ;

const RPC_NOTIFY_SERVER = 260 ;
const RPC_NOTIFY_SERVER_UI_DESTROYED = 261 ;
const RPC_AUTHORIZATION_DATA = 262 ;
const RPC_RECONNECT = 263 ;
const RPC_NOTICES = 264 ;
const RPC_MOBILE_CONNECT = 265 ;
const RPC_MOBILE_SETTINGS = 266 ;
const RPC_BUOYANCY = 267 ;
const RPC_ACTOR_EMPTY_AMMO = 268 ;

IPacket:ID_CUSTOM_PACKET(playerid, BitStream:bs)
{
    new rpcid ;

    BS_ReadValue(bs,
		PR_IGNORE_BITS, 8, // packet id
		PR_UINT32, rpcid
    );
    
	if ( rpcid == RPC_MECHANICK_HOOK ) // click mechanic button
	{
		#if defined debug_rpc
			printf ( "[RPC_MECHANICK_HOOK] playerid: %d", playerid ) ;
		#endif

		TouchMechanicHook ( playerid ) ;
	}
	else if ( rpcid == RPC_EXTINGUISH_POINT_WITH_WATER ) // пожарная поливалка
	{
		#if defined debug_rpc
			printf ( "[RPC_EXTINGUISH_POINT_WITH_WATER] playerid: %d", playerid ) ;
		#endif

		static clearExtinguishData [ EXTINGUISH_STRUCT ] ;
		extinguishData = clearExtinguishData ;

        BS_ReadValue(bs,
			PR_FLOAT, 	extinguishData [ EXTINGUISH_POINT_X ],
			PR_FLOAT, 	extinguishData [ EXTINGUISH_POINT_Y ],
			PR_FLOAT, 	extinguishData [ EXTINGUISH_POINT_Z ],
			PR_FLOAT, 	extinguishData [ EXTINGUISH_RADIUS ],
			PR_FLOAT, 	extinguishData [ EXTINGUISH_WATER_STRENGTH ]
        );

		/*ExtinguishPointWithWater ( 
			playerid,
			extinguishData [ EXTINGUISH_POINT_X ],
			extinguishData [ EXTINGUISH_POINT_Y ],
			extinguishData [ EXTINGUISH_POINT_Z ],
			extinguishData [ EXTINGUISH_RADIUS ],
			extinguishData [ EXTINGUISH_WATER_STRENGTH ]
		) ;*/
	}
	else if ( rpcid == RPC_GiveActorDamage )
	{
		#if defined debug_rpc
			printf ( "[RPC_GiveActorDamage] playerid: %d", playerid ) ;
		#endif
		
        new bool: status, actorId, Float: amountDamage, weaponId, bodyPart ;

        BS_ReadValue(bs,
			PR_BOOL, 	status,
            PR_UINT16, 	actorId,
			PR_FLOAT, 	amountDamage,
			PR_UINT32, 	weaponId,
			PR_UINT32, 	bodyPart
        );

		if ( status ) // нанёс урон
		{
			OnActorTakeDamage ( actorId, playerid, amountDamage, weaponId, bodyPart ) ;
		}
		else // получил урон
		{
			OnActorGiveDamage ( actorId, playerid, amountDamage, weaponId, bodyPart ) ;
		}
	}
    else if ( rpcid == RPC_ModeSettings )
    {
		#if defined debug_rpc
			printf ( "[RPC_ModeSettings] playerid: %d", playerid ) ;
		#endif
		
        new i_bit ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit
        );

		if ( i_bit == 1 ) 
		{
			if ( p_t_info [ playerid ] [ p_logged ] == false || player_loaded { playerid } == 0 ) return 1 ;
			show_playersettings ( playerid ) ;
		}
    }
	else if ( rpcid == RPC_ModeBinder )
    {
		#if defined debug_rpc
			printf ( "[RPC_ModeBinder] playerid: %d", playerid ) ;
		#endif
		
        new i_bit ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit
        );

		if ( i_bit == 1 )
		{
			if ( p_t_info [ playerid ] [ p_logged ] == false || player_loaded { playerid } == 0 ) return 1 ; 
			show_playerbinder ( playerid ) ;
		}
    }
	else if ( rpcid == RPC_BattlePass )
	{
		#if defined debug_rpc
			printf ( "[RPC_BattlePass] playerid: %d", playerid ) ;
		#endif
		
		new i_bit, i_info, i_pos_bp, i_type ;

        BS_ReadValue(bs,
            PR_INT32, i_bit,
            PR_INT32, i_info,
            PR_INT32, i_pos_bp,
            PR_INT32, i_type
        );
		
		show_packet_battlepass ( playerid, i_bit, i_info, i_pos_bp, i_type ) ;
	}
	else if ( rpcid == RPC_VoiceChat )
	{
		#if defined debug_rpc
			printf ( "[RPC_VoiceChat] playerid: %d", playerid ) ;
		#endif
		
		new i_bit, i_chat ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit,
            PR_UINT8, i_chat
        );
		
		//p_info [ playerid ] [ voice ] = i_bit ;
		p_info [ playerid ] [ chat_status ] = i_chat ;
	}
	else if ( rpcid == RPC_HudManager )
	{
		#if defined debug_rpc
			printf ( "[RPC_HudManager] playerid: %d", playerid ) ;
		#endif
		
		new i_bit ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit
        );
		
		p_info [ playerid ] [ hud_id ] = i_bit ;
		
		if ( p_t_info [ playerid ] [ p_logged ] == true )
		{
			if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] )
			{
				SendCheckHud ( playerid ) ;
			}
		}
	}
	else if ( rpcid == RPC_Finger )
	{
		#if defined debug_rpc
			printf ( "[RPC_Finger] playerid: %d", playerid ) ;
		#endif
		
		new _param1, _param2, _param_len, _param_str [ 128 ] ;
		
		BS_ReadValue(
			bs,
			PR_INT32, _param1,
			PR_INT32, _param2,
			PR_UINT8, _param_len,
			PR_STRING, _param_str, _param_len
		);
		
		show_packet_finger ( playerid, _param1, _param2, _param_str ) ;
	}
	else if ( rpcid == RPC_NewBieBattle )
	{
		#if defined debug_rpc
			printf ( "[RPC_NewBieBattle] playerid: %d", playerid ) ;
		#endif
		
        new _param1, _param2, _param3 ;
		
		BS_ReadValue(
			bs,
			PR_INT32, _param1,
			PR_INT32, _param2,
			PR_INT32, _param3
		);
		
		show_packet_newbie ( playerid, _param1, _param2, _param3 ) ;
	}
	else if ( rpcid == RPC_NOTIFY_SERVER )
	{
		#if defined debug_rpc
			printf ( "[RPC_NOTIFY_SERVER] playerid: %d", playerid ) ;
		#endif
		
		new uiElementId, actionId, data [ 512 ], dataLen ;
		BS_ReadValue(
			bs,
			PR_INT32, uiElementId,
			PR_INT32, actionId,
			PR_UINT8, dataLen,
			PR_STRING, data, dataLen
		);
		
		notify_server ( playerid, uiElementId, actionId, data ) ;
	}
	else if ( rpcid == RPC_NOTIFY_SERVER_UI_DESTROYED )
	{
		#if defined debug_rpc
			printf ( "[RPC_NOTIFY_SERVER_UI_DESTROYED] playerid: %d", playerid ) ;
		#endif
		
		new uiElementId ;
		BS_ReadValue(
			bs,
			PR_INT32, uiElementId
		);
		
		notify_server_ui_destroyed ( playerid, uiElementId ) ;
	}
	else if ( rpcid == RPC_AUTHORIZATION_DATA )
	{
		#if defined debug_rpc
			printf ( "[RPC_AUTHORIZATION_DATA] playerid: %d", playerid ) ;
		#endif
		
		new data [ 256 ], dataLen ;
		BS_ReadValue(
			bs,
			PR_UINT8, dataLen,
			PR_STRING, data, dataLen
		);
		
		set_authorization_data ( playerid, data ) ;
	}
	else if ( rpcid == RPC_NOTICES )
	{
		#if defined debug_rpc
			printf ( "[RPC_NOTICES] playerid: %d", playerid ) ;
		#endif

		new notyId, notyType, bool: status ;
		BS_ReadValue(
			bs,
			PR_INT32, notyId,
			PR_INT32, notyType,
			PR_BOOL, status
		);

		packetNotices ( playerid, notyId, notyType, status ) ;
	}
	else if ( rpcid == RPC_MOBILE_CONNECT )
	{
		#if defined debug_rpc
			printf ( "[RPC_MOBILE_CONNECT] playerid: %d", playerid ) ;
		#endif
		
		new data [ 128 ], dataLen ;
		
		BS_ReadValue (
			bs,
			PR_UINT8, dataLen,
			PR_STRING, data, dataLen,
			PR_INT8, p_t_info [ playerid ] [ nickNameStyle ]
		) ;
		
		player_checking_mobile ( playerid, data ) ;
	}
	else if ( rpcid == RPC_MOBILE_SETTINGS )
	{
		#if defined debug_rpc
			printf ( "[RPC_MOBILE_SETTINGS] playerid: %d", playerid ) ;
		#endif
		
		BS_ReadValue (
			bs,
			PR_INT8, p_t_info [ playerid ] [ nickNameStyle ]
		) ;
	}
	else if ( rpcid == RPC_BUOYANCY )
	{
		#if defined debug_rpc
			printf ( "[RPC_BUOYANCY] playerid: %d", playerid ) ;
		#endif

		VehicleProcessBuoyancy ( playerid ) ;
	}
	else if ( rpcid == RPC_ACTOR_EMPTY_AMMO )
	{
		#if defined debug_rpc
			printf ( "[RPC_ACTOR_EMPTY_AMMO] playerid: %d", playerid ) ;
		#endif
		
		new actorId ;
		BS_ReadValue (
			bs,
			PR_UINT16, actorId
		) ;

		actorEmptyAmmo ( actorId ) ;
	}

	return true ;
}

const RPC_WorldPlayerAdd  			= 32 ;
const RPC_ScrCreateObject 			= 44 ;
const RPC_CREATE_PICKUP 			= 95 ;
const RPC_PlayerAttachedObject 		= 113 ;
const RPC_ScrSetPlayerSkin 			= 153 ;
const RPC_WorldVehicleAdd 			= 164 ;
const RPC_WorldActorAdd 			= 171 ;

enum E_PLAYER_STRUCT
{
	e_usPlayerID,
	e_bTeam,
	e_uiSkin,
	e_pfPosX,
	e_pfPosY,
	e_pfPosZ,
	e_pfRot,
	e_uiColor,
	e_bFighting,
	e_boolVisible
} ;
static playerData [ E_PLAYER_STRUCT ] ;

stock ProcessReplaceSkin ( playerid, BitStream:bs )
{
    new player, skinid ;
	BS_ReadValue(
		bs,
 		PR_UINT32, player,
		PR_UINT32, skinid);

	new modelId = getReplacableSkinModel ( player ) ;
	if ( modelId )
	{
		new BitStream:bitstream = BS_New();
		
		BS_WriteValue(
			bitstream,
			PR_UINT32, player,
			PR_UINT32, modelId
		);
		PR_SendRPC(bitstream, playerid, RPC_ScrSetPlayerSkin, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return true ;
	}
	return false ;
}

stock ProcessReplaceSkinAdd ( playerid, BitStream:bs )
{
    static clearPlayerData [ E_PLAYER_STRUCT ] ;
	playerData = clearPlayerData ;

	BS_ReadValue(
 		bs,
   		PR_INT16, playerData [ e_usPlayerID ],
		PR_UINT8, playerData [ e_bTeam ],
		PR_UINT32, playerData [ e_uiSkin ],
		PR_FLOAT, playerData [ e_pfPosX ],
		PR_FLOAT, playerData [ e_pfPosY ],
		PR_FLOAT, playerData [ e_pfPosZ ],
		PR_FLOAT, playerData [ e_pfRot ],
		PR_UINT32, playerData [ e_uiColor ],
		PR_UINT8, playerData [ e_bFighting ],
		PR_BOOL, playerData [ e_boolVisible ]);

	new modelId = getReplacableSkinModel ( playerData [ e_usPlayerID ] ) ;
	if ( modelId )
	{
		new BitStream:bitstream = BS_New();

		BS_WriteValue(
			bitstream,
			PR_INT16, playerData [ e_usPlayerID ],
			PR_UINT8, playerData [ e_bTeam ],
			PR_UINT32, modelId,
			PR_FLOAT, playerData [ e_pfPosX ],
			PR_FLOAT, playerData [ e_pfPosY ],
			PR_FLOAT, playerData [ e_pfPosZ ],
			PR_FLOAT, playerData [ e_pfRot ],
			PR_UINT32, playerData [ e_uiColor ],
			PR_UINT8, playerData [ e_bFighting ],
			PR_BOOL, playerData [ e_boolVisible ]
		);
	
		PR_SendRPC(bitstream, playerid, RPC_WorldPlayerAdd, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return true ;
	}
	return false ;
}

enum E_VEHICLE_STRUCT
{
	e_vVehicleID, 			// INT16
	e_vModelID,				// UINT32
	Float:e_posX,
	Float:e_posY,
	Float:e_posZ,
	Float:e_rot,
	e_vColor1,
	e_vColor2,
	Float:e_vHealth,
	e_vInterior,
	e_vDoorDamageStatus,
	e_vPanelDamageStatus,
	e_vByteLightDamageStatus,
	e_vByteTimeDamageStatus,
	e_vByteAddSiren
} ;
static vehicleData [ E_VEHICLE_STRUCT ] ;

stock ProcessReplaceVehicle ( playerid, BitStream:bs )
{
    static clearVehicleData [ E_VEHICLE_STRUCT ] ;
	vehicleData = clearVehicleData ;
	new modSlots [ 14 ] ;
	new bytePaintJob ;
	new color1, color2 ;

	BS_ReadValue(
 		bs,
   		PR_INT16, vehicleData [ e_vVehicleID ],
		PR_UINT32, vehicleData [ e_vModelID ],
		PR_FLOAT, vehicleData [ e_posX ],
		PR_FLOAT, vehicleData [ e_posY ],
		PR_FLOAT, vehicleData [ e_posZ ],
		PR_FLOAT, vehicleData [ e_rot ],
		PR_UINT8, vehicleData [ e_vColor1 ],
		PR_UINT8, vehicleData [ e_vColor2 ],
		PR_FLOAT, vehicleData [ e_vHealth ],
		PR_UINT8, vehicleData [ e_vInterior ],
		PR_UINT32, vehicleData [ e_vDoorDamageStatus ],
		PR_UINT32, vehicleData [ e_vPanelDamageStatus ],
		PR_UINT8, vehicleData [ e_vByteLightDamageStatus ],
		PR_UINT8, vehicleData [ e_vByteTimeDamageStatus ],
		PR_UINT8, vehicleData [ e_vByteAddSiren ]);
		
	for(new i = 0; i < 14; i++)
	{
 		BS_ReadValue(bs, PR_UINT8, modSlots[i]);
	}
	BS_ReadValue(bs, PR_UINT8, bytePaintJob);
	BS_ReadValue(bs, PR_UINT32, color1, PR_UINT32, color2);

    new modelId = getReplacableVehicleModel ( vehicleData [ e_vVehicleID ] ) ;
	if ( modelId )
	{
		new BitStream:bitstream = BS_New();

		BS_WriteValue(
			bitstream,
			PR_INT16, vehicleData [ e_vVehicleID ],
			PR_UINT32, GetVehicleModelEx ( vehicleData [ e_vVehicleID ] ),
			PR_FLOAT, vehicleData [ e_posX ],
			PR_FLOAT, vehicleData [ e_posY ],
			PR_FLOAT, vehicleData [ e_posZ ],
			PR_FLOAT, vehicleData [ e_rot ],
			PR_UINT8, vehicleData [ e_vColor1 ],
			PR_UINT8, vehicleData [ e_vColor2 ],
			PR_FLOAT, vehicleData [ e_vHealth ],
			PR_UINT8, vehicleData [ e_vInterior ],
			PR_UINT32, vehicleData [ e_vDoorDamageStatus ],
			PR_UINT32, vehicleData [ e_vPanelDamageStatus ],
			PR_UINT8, vehicleData [ e_vByteLightDamageStatus ],
			PR_UINT8, vehicleData [ e_vByteTimeDamageStatus ],
			PR_UINT8, vehicleData [ e_vByteAddSiren ]);

		for(new i = 0; i < 14; i++)
		{
			BS_WriteValue(bitstream, PR_UINT8, modSlots[i]);
		}
		BS_WriteValue(bitstream, PR_UINT8, bytePaintJob);
		BS_WriteValue(bitstream, PR_UINT32, color1, PR_UINT32, color2);

		PR_SendRPC(bitstream, playerid, RPC_WorldVehicleAdd, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return true ;
	}
	return false ;
}

enum E_ACTOR_STRUCT
{
	E_ACTOR_ID,
	E_ACTOR_SKIN,
	Float: E_ACTOR_POS_X,
	Float: E_ACTOR_POS_Y,
	Float: E_ACTOR_POS_Z,
	Float: E_ACTOR_ROT,
	Float: E_ACTOR_HEALTH,
	E_ACTOR_INVULNERABLE
} ;
static actorData [ E_ACTOR_STRUCT ] ;

stock ProcessReplaceActor ( playerid, BitStream:bs )
{
	static clearActorData [ E_ACTOR_STRUCT ] ;
	actorData = clearActorData ;

	BS_ReadValue(
 		bs,
   		PR_UINT16, actorData [ E_ACTOR_ID ],
		PR_UINT32, actorData [ E_ACTOR_SKIN ],
		PR_FLOAT, actorData [ E_ACTOR_POS_X ],
		PR_FLOAT, actorData [ E_ACTOR_POS_Y ],
		PR_FLOAT, actorData [ E_ACTOR_POS_Z ],
		PR_FLOAT, actorData [ E_ACTOR_ROT ],
		PR_FLOAT, actorData [ E_ACTOR_HEALTH ],
		PR_UINT8, actorData [ E_ACTOR_INVULNERABLE ]);
	
	new BitStream:bitstream = BS_New(), actorId = actorData [ E_ACTOR_ID ] ;
	BS_WriteValue(
		bitstream,
		PR_UINT16, actorId,
		PR_UINT32, actorData [ E_ACTOR_SKIN ],
		PR_FLOAT, actorData [ E_ACTOR_POS_X ],
		PR_FLOAT, actorData [ E_ACTOR_POS_Y ],
		PR_FLOAT, actorData [ E_ACTOR_POS_Z ],
		PR_FLOAT, actorData [ E_ACTOR_ROT ],
		PR_FLOAT, actorData [ E_ACTOR_HEALTH ],
		PR_UINT8, actorData [ E_ACTOR_INVULNERABLE ],
		PR_UINT8, strlen ( actor_info [ actorId ] [ ACTOR_NAME ] ),
		PR_STRING, actor_info [ actorId ] [ ACTOR_NAME ],
		PR_FLOAT, 0.0, // armour
		PR_UINT32, 0, // weapon
		PR_BOOL, actor_info [ actorId ] [ ACTOR_HEALTH_BAR ]);
	PR_SendRPC(bitstream, playerid, RPC_WorldActorAdd, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
	BS_Delete(bitstream);
	return true ;
}

enum E_OBJECT_STRUCT
{
	e_wObjectID, 			// INT16
	e_ModelID,				// UINT32
	Float:e_objectX,		// FLOAT
	Float:e_objectY,		// FLOAT
	Float:e_objectZ,		// FLOAT
	Float:e_rotx,			// FLOAT
	Float:e_roty,			// FLOAT
	Float:e_rotz,			// FLOAT
	float:e_DrawDistance,	// FLOAT
	e_NoCameraCol,			// UINT8
	e_attachedObject,		// UINT16
	e_attachedVehicle,		// UINT16
	float:e_AttachOffsetX,	// FLOAT
	float:e_AttachOffsetY,	// FLOAT
	float:e_AttachOffsetZ,	// FLOAT
	float:e_AttachRotX,		// FLOAT
	float:e_AttachRotY,		// FLOAT
	float:e_AttachRotZ,		// FLOAT
	e_SyncRotation 			// UINT8
} ;
static dataObject [ E_OBJECT_STRUCT ] ;

stock IsShouldSendCreateObject ( playerid, BitStream:bs )
{
	static clearDataObject [ E_OBJECT_STRUCT ] ;
	dataObject = clearDataObject ;
	BS_ReadValue(
		bs,
 		PR_INT16, dataObject[e_wObjectID],
  		PR_UINT32, dataObject[e_ModelID],
   		PR_FLOAT, dataObject[e_objectX],
    	PR_FLOAT, dataObject[e_objectY],
    	PR_FLOAT, dataObject[e_objectZ],
    	PR_FLOAT, dataObject[e_rotx],
    	PR_FLOAT, dataObject[e_roty],
    	PR_FLOAT, dataObject[e_rotz],
    	PR_FLOAT, dataObject[e_DrawDistance],
    	PR_UINT8, dataObject[e_NoCameraCol],
    	PR_UINT16, dataObject[e_attachedObject],
    	PR_UINT16, dataObject[e_attachedVehicle],
    	PR_FLOAT, dataObject[e_AttachOffsetX],
    	PR_FLOAT, dataObject[e_AttachOffsetY],
    	PR_FLOAT, dataObject[e_AttachOffsetZ],
    	PR_FLOAT, dataObject[e_AttachRotX],
    	PR_FLOAT, dataObject[e_AttachRotY],
    	PR_FLOAT, dataObject[e_AttachRotZ],
		PR_UINT8, dataObject[e_SyncRotation]);
	
	if ( dataObject[e_ModelID] == 2935 && ( airdrop_object [ 0 ] == dataObject[e_wObjectID] || family_airdrop_object [ 0 ] == dataObject[e_wObjectID] ) )
	{
		new BitStream:bitstream = BS_New();

		BS_WriteValue(
			bitstream,
			PR_INT16, dataObject[e_wObjectID],
			PR_UINT32, 12741,
			PR_FLOAT, dataObject[e_objectX],
			PR_FLOAT, dataObject[e_objectY],
			PR_FLOAT, dataObject[e_objectZ],
			PR_FLOAT, dataObject[e_rotx],
			PR_FLOAT, dataObject[e_roty],
			PR_FLOAT, dataObject[e_rotz],
			PR_FLOAT, dataObject[e_DrawDistance],
			PR_UINT8, dataObject[e_NoCameraCol],
			PR_UINT16, dataObject[e_attachedObject],
			PR_UINT16, dataObject[e_attachedVehicle],
			PR_FLOAT, dataObject[e_AttachOffsetX],
			PR_FLOAT, dataObject[e_AttachOffsetY],
			PR_FLOAT, dataObject[e_AttachOffsetZ],
			PR_FLOAT, dataObject[e_AttachRotX],
			PR_FLOAT, dataObject[e_AttachRotY],
			PR_FLOAT, dataObject[e_AttachRotZ],
			PR_UINT8, dataObject[e_SyncRotation]);

		PR_SendRPC(bitstream, playerid, RPC_ScrCreateObject, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return 0 ;
	}
	else if ( dataObject[e_ModelID] == 18849 && ( airdrop_object [ 1 ] == dataObject[e_wObjectID] || family_airdrop_object [ 1 ] == dataObject[e_wObjectID] ) )
	{
		new BitStream:bitstream = BS_New();

		BS_WriteValue(
			bitstream,
			PR_INT16, dataObject[e_wObjectID],
			PR_UINT32, 18631,
			PR_FLOAT, dataObject[e_objectX],
			PR_FLOAT, dataObject[e_objectY],
			PR_FLOAT, dataObject[e_objectZ],
			PR_FLOAT, dataObject[e_rotx],
			PR_FLOAT, dataObject[e_roty],
			PR_FLOAT, dataObject[e_rotz],
			PR_FLOAT, dataObject[e_DrawDistance],
			PR_UINT8, dataObject[e_NoCameraCol],
			PR_UINT16, dataObject[e_attachedObject],
			PR_UINT16, dataObject[e_attachedVehicle],
			PR_FLOAT, dataObject[e_AttachOffsetX],
			PR_FLOAT, dataObject[e_AttachOffsetY],
			PR_FLOAT, dataObject[e_AttachOffsetZ],
			PR_FLOAT, dataObject[e_AttachRotX],
			PR_FLOAT, dataObject[e_AttachRotY],
			PR_FLOAT, dataObject[e_AttachRotZ],
			PR_UINT8, dataObject[e_SyncRotation]);

		PR_SendRPC(bitstream, playerid, RPC_ScrCreateObject, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return 0 ;
	}
	
	return 1 ;
}

enum E_ATTACH_STRUCT
{
	e_PlayerID,
	e_Slot,
	e_Created,
	e_ModelID,
	e_Bone,
	Float:e_OffsetX,
	Float:e_OffsetY,
	Float:e_OffsetZ,
	Float:e_RotX,
	Float:e_RotY,
	Float:e_RotZ,
	Float:e_ScaleX,
	Float:e_ScaleY,
	Float:e_ScaleZ,
	e_Color1,
	e_Color2
} ;
static dataAttach [ E_ATTACH_STRUCT ] ;

stock IsShouldSendCreateAttached ( playerid, BitStream:bs )
{
	static clearDataAttach [ E_ATTACH_STRUCT ] ;
	dataAttach = clearDataAttach ;
   	BS_ReadValue(
		bs,
		PR_UINT16, dataAttach [ e_PlayerID ],
		PR_UINT32, dataAttach [ e_Slot ],
		PR_BOOL,   dataAttach [ e_Created ]);
		
	if ( dataAttach [ e_Created ] )
	{
   		BS_ReadValue(
			bs, 
			PR_UINT32, dataAttach [ e_ModelID ],
			PR_FLOAT, dataAttach [ e_OffsetX ],
			PR_FLOAT, dataAttach [ e_OffsetY ],
			PR_FLOAT, dataAttach [ e_OffsetZ ],
			PR_FLOAT, dataAttach [ e_RotX ],
			PR_FLOAT, dataAttach [ e_RotY ],
			PR_FLOAT, dataAttach [ e_RotZ ],
			PR_FLOAT, dataAttach [ e_ScaleX ],
			PR_FLOAT, dataAttach [ e_ScaleY ],
			PR_FLOAT, dataAttach [ e_ScaleZ ],
			PR_UINT32, dataAttach [ e_Color1 ],
			PR_UINT32, dataAttach [ e_Color2 ]);
	}
	return 1 ;
}

enum E_PICKUP_STRUCT
{
	dPickupID,  	 // UINT32 
	dModelID,  		 // UINT32 
    dSpawnType,  	 // UINT32 
    Float: pickupX,   // FLOAT  
    Float: pickupY,   // FLOAT  
    Float: pickupZ    // FLOAT  
} ;

stock isReplacePickup ( _pickup_model )
{
	if ( _pickup_model == 1239 ) return 13705 ;
	else if ( _pickup_model == 1273 ) return 13701 ;
	else if ( _pickup_model == 1272 ) return 13702 ;
	return 0 ;
}

ORPC:RPC_WorldPlayerAdd ( playerid, BitStream:bs )
{
	if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
	if ( player_device { playerid } == 2 )
	{
		if ( ProcessReplaceSkinAdd ( playerid, bs ) )
		{
		    return 0 ;
		}
	}
	return 1 ;
}

ORPC:RPC_ScrSetPlayerSkin ( playerid, BitStream:bs )
{
	if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
	if ( player_device { playerid } == 2 )
	{
		if ( ProcessReplaceSkin ( playerid, bs ) )
		{
		    return 0 ;
		}
	}
	return 1 ;
}

ORPC:RPC_WorldVehicleAdd ( playerid, BitStream:bs )
{
	if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
	if ( player_device { playerid } == 2 )
	{
		if ( ProcessReplaceVehicle ( playerid, bs ) )
		{
		    return 0 ;
		}
	}
	return 1 ;
}

ORPC:RPC_WorldActorAdd ( playerid, BitStream:bs )
{
	if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
	if ( player_device { playerid } == 2 )
	{
		if ( ProcessReplaceActor ( playerid, bs ) )
		{
		    return 0 ;
		}
	}
	return 1 ;
}

ORPC:RPC_ScrCreateObject ( playerid, BitStream:bs )
{
	if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
	if ( player_device { playerid } == 2 )
	{
		if ( ! IsShouldSendCreateObject ( playerid, bs ) )
		{
		    return 0 ;
		}
	}
	return 1 ;
}

/*ORPC:RPC_PlayerAttachedObject(playerid, BitStream:bs)
{
	if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
	if ( player_device { playerid } == 2 )
	{
		if ( ! IsShouldSendCreateAttached ( playerid, bs ) )
		{
		    return 0 ;
		}
	}
	return 1 ;
}*/

/*ORPC:RPC_CREATE_PICKUP(playerid, BitStream:bs)
{
	if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
	if ( player_checking_hash [ playerid ] < 51 ) { }
	else
	{
		if ( player_device { playerid } == 2 ) // РµСЃР»Рё РёРіСЂРѕРє СЃ РІРµРґСЂР°
		{
			new dataPickup[E_PICKUP_STRUCT];
			BS_ReadValue(
				bs,
				PR_UINT32, dataPickup[dPickupID],
				PR_UINT32, dataPickup[dModelID],
				PR_UINT32, dataPickup[dSpawnType],
				PR_FLOAT, dataPickup[pickupX],
				PR_FLOAT, dataPickup[pickupY],
				PR_FLOAT, dataPickup[pickupZ]
				);

			new custom_id = isReplacePickup ( dataPickup[dModelID] ) ;
			if ( custom_id )
			{
				// РїРµСЂРµРїРёСЃР°С‚СЊ РјРѕРґРµР»СЊ
				new BitStream:bitstream = BS_New(); 
				BS_WriteValue( 
					bitstream, 
					PR_UINT32, dataPickup[dPickupID], 	//id 
					PR_UINT32, custom_id,				//model
					PR_UINT32, dataPickup[dSpawnType],  //type. 
					PR_FLOAT, dataPickup[pickupX], 	    //x. 
					PR_FLOAT, dataPickup[pickupY], 		//y. 
					PR_FLOAT, dataPickup[pickupZ] 		//z. 
				); 
				PR_SendRPC(bitstream, playerid, RPC_CREATE_PICKUP, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
				BS_Delete(bitstream);
				return 0 ;
			}
		}
	}
	return 1 ;
}*/