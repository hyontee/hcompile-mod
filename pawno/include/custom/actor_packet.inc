#define PACKET_CUSTOMRPC    			251
#define RPC_ACTOR_ACTION				0x161

stock actorPutInVeh ( playerid, _actorId, _vehicleId, _seatId )
{
	#if defined debug_packet
		printf ( "[actorPutInVeh] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 0,
		
		PR_UINT16, _actorId,
		PR_UINT16, _vehicleId,
		PR_UINT8, _seatId);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorRemoveFromVeh ( playerid, _actorId, _vehicleId, _anim )
{
	#if defined debug_packet
		printf ( "[actorRemoveFromVeh] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	// _anim = 1 - not used anim
	// _anim = 0 - used anim exit
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 1,
		
		PR_UINT16, _actorId,
		PR_UINT16, _vehicleId,
		PR_UINT8, _anim);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorEnterCarPass ( playerid, _actorId, _vehicleId, _seatId )
{
	#if defined debug_packet
		printf ( "[actorEnterCarPass] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
		
		PR_UINT16, _actorId,
		PR_UINT16, _vehicleId,
		PR_UINT8, _seatId);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorSetArmour ( playerid, _actorId, Float: _arm )
{
	#if defined debug_packet
		printf ( "[actorSetArmour] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 3,
		
		PR_UINT16, _actorId,
		PR_FLOAT, _arm);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorSetName ( playerid, _actorId, _str [ ] )
{
	#if defined debug_packet
		printf ( "[actorSetName] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 4,
		
		PR_UINT16, _actorId,
		
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorShootTo ( playerid, _actorId, Float: _x, Float: _y, Float: _z, _time )
{
	#if defined debug_packet
		printf ( "[actorShootTo] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 5,
		
		PR_UINT16, _actorId,
		
		PR_FLOAT, _x,
		PR_FLOAT, _y,
		PR_FLOAT, _z,
		
		PR_UINT32, _time);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorSetPosFindZ ( playerid, _actorId, Float: _x, Float: _y, Float: _z )
{
	#if defined debug_packet
		printf ( "[actorSetPosFindZ] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 6,
		
		PR_UINT16, _actorId,
		
		PR_FLOAT, _x,
		PR_FLOAT, _y,
		PR_FLOAT, _z);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorGoto ( playerid, _actorId, Float: _x, Float: _y, Float: _z, Float: _speed )
{
	#if defined debug_packet
		printf ( "[actorGoto] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 7,
		
		PR_UINT16, _actorId,
		
		PR_FLOAT, _x,
		PR_FLOAT, _y,
		PR_FLOAT, _z,
		PR_FLOAT, _speed);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorGiveWeapon ( playerid, _actorId, _weapon )
{
	#if defined debug_packet
		printf ( "[actorGiveWeapon] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 8,
		
		PR_UINT16, _actorId,
		PR_UINT32, _weapon);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorAttack ( playerid, _actorId, _attackId )
{
	#if defined debug_packet
		printf ( "[actorAttack] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 9,
		
		PR_UINT16, _actorId,
		PR_UINT16, _attackId);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorClearTasks ( playerid, _actorId )
{
	#if defined debug_packet
		printf ( "[actorClearTasks] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 10,
		
		PR_UINT16, _actorId);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock actorInvulnerable ( playerid, _actorId, bool: status )
{
	#if defined debug_packet
		printf ( "[actorClearTasks] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_ACTOR_ACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 11,
		
		PR_UINT16, _actorId,
		PR_BOOL, status);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}