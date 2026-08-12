#if defined _key_pickupfix_included
    #endinput
#endif
#define _key_pickupfix_included
 
#if !defined KEY_PICKUPFIX_USED_KEY
    #define KEY_PICKUPFIX_USED_KEY              KEY_WALK
#endif
 
#define KEY_PICKUPFIX_INVALID_PICKUP_ID         (-1)
 
#if defined Streamer_IncludeFileVersion
    #define KEY_PICKUPFIX_PICK_TYPE_INVALID     (-1)
    #define KEY_PICKUPFIX_PICK_TYPE_DEFAULT     (0)
    #define KEY_PICKUPFIX_PICK_TYPE_STREAM      (1)
#endif
 
#define _key_pickupfix_PRESSED(%0)  \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
 
#if defined Streamer_IncludeFileVersion
 
    enum e_PLAYER_PICKUP_DATA
    {
        _key_pickupfix_pickupID,
        _key_pickupfix_pickupType,
        _key_pickupfix_pickupTimestamp,
        bool:_key_pickupfix_IsPickupUsed
    };
    static
        _key_pickupfix_playerPickupData[MAX_PLAYERS][e_PLAYER_PICKUP_DATA];
 
    static const NULL_PLAYER_PICKUP_DATA[e_PLAYER_PICKUP_DATA] = {KEY_PICKUPFIX_INVALID_PICKUP_ID, KEY_PICKUPFIX_PICK_TYPE_INVALID, 0, false};
#else
    enum e_PLAYER_PICKUP_DATA
    {
        _key_pickupfix_pickupID,
        _key_pickupfix_pickupTimestamp,
        bool:_key_pickupfix_IsPickupUsed
    };
    static
        _key_pickupfix_playerPickupData[MAX_PLAYERS][e_PLAYER_PICKUP_DATA];
 
    static const NULL_PLAYER_PICKUP_DATA[e_PLAYER_PICKUP_DATA] = {KEY_PICKUPFIX_INVALID_PICKUP_ID, 0, false};
#endif
 
public OnPlayerConnect(playerid)
{
    _key_pickupfix_playerPickupData[playerid] = NULL_PLAYER_PICKUP_DATA;
 
    #if defined _key_pickupfix_OnPlayerConnect
        _key_pickupfix_OnPlayerConnect(playerid);
    #endif
    return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect _key_pickupfix_OnPlayerConnect
#if defined _key_pickupfix_OnPlayerConnect
forward _key_pickupfix_OnPlayerConnect(playerid);
#endif
 
public OnPlayerPickUpPickup(playerid, pickupid)
{
    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID] = pickupid;
 
    #if defined Streamer_IncludeFileVersion
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupType] = KEY_PICKUPFIX_PICK_TYPE_DEFAULT;
    #endif
 
    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupTimestamp] = gettime();
 
    if(false == _key_pickupfix_playerPickupData[playerid][_key_pickupfix_IsPickupUsed])
        return 1;
 
    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID] = KEY_PICKUPFIX_INVALID_PICKUP_ID;
 
    #if defined Streamer_IncludeFileVersion
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupType] = KEY_PICKUPFIX_PICK_TYPE_INVALID;
    #endif
 
    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupTimestamp] = 0;
    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_IsPickupUsed] = false;
 
    #if defined _key_pickupfix_OnPlayerPickUpPi
        _key_pickupfix_OnPlayerPickUpPi(playerid, pickupid);
    #endif
    return 1;
}
#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup
#else
    #define _ALS_OnPlayerPickUpPickup
#endif
#define OnPlayerPickUpPickup _key_pickupfix_OnPlayerPickUpPi
#if defined _key_pickupfix_OnPlayerPickUpPi
forward _key_pickupfix_OnPlayerPickUpPi(playerid, pickupid);
#endif
 
#if defined Streamer_IncludeFileVersion
    stock Key_OnPlayerPickUpDynamicPickup(playerid, pickupid)
    {
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID] = pickupid;
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupType] = KEY_PICKUPFIX_PICK_TYPE_STREAM;
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupTimestamp] = gettime();
 
        if(false == _key_pickupfix_playerPickupData[playerid][_key_pickupfix_IsPickupUsed])
            return 1;
 
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID] = KEY_PICKUPFIX_INVALID_PICKUP_ID;
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupType] = KEY_PICKUPFIX_PICK_TYPE_INVALID;
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupTimestamp] = 0;
        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_IsPickupUsed] = false;
 
        #if defined _key_pickupfix_OnPlayerPickUpDy
            _key_pickupfix_OnPlayerPickUpDy(playerid, pickupid);
        #endif
        return 1;
    }
/*	#if defined _W_OnPlayerPickUpDynamicPickup
	  #undef OnPlayerPickUpDynamicPickup
	#else
	  #define _W_OnPlayerPickUpDynamicPickup
	#endif
	#define OnPlayerPickUpDynamicPickup _key_pickupfix_OnPlayerPickUpDy
	#if  defined _key_pickupfix_OnPlayerPickUpDy
 	 forward _key_pickupfix_OnPlayerPickUpDy(playerid, pickupid);
	#endif	
#endif*/
 
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(_key_pickupfix_PRESSED(KEY_PICKUPFIX_USED_KEY))
    {
        if(_key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID] != KEY_PICKUPFIX_INVALID_PICKUP_ID)
        {
            if(false == _key_pickupfix_playerPickupData[playerid][_key_pickupfix_IsPickupUsed])
            {
                if(gettime() - _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupTimestamp] <= 1)
                {
                    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_IsPickupUsed] = true;
 
                    #if defined Streamer_IncludeFileVersion
                        if(_key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupType] == KEY_PICKUPFIX_PICK_TYPE_DEFAULT)
                            CallRemoteFunction("OnPlayerPickUpPickup", "dd", playerid, _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID]);
                        else
                            CallRemoteFunction("OnPlayerPickUpDynamicPickup", "dd", playerid, _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID]);
                    #else
                        CallRemoteFunction("OnPlayerPickUpPickup", "dd", playerid, _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID]);
                    #endif
                }
                else
                {
                    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupID] = KEY_PICKUPFIX_INVALID_PICKUP_ID;
 
                    #if defined Streamer_IncludeFileVersion
                        _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupType] = KEY_PICKUPFIX_PICK_TYPE_INVALID;
                    #endif
                    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_pickupTimestamp] = 0;
                    _key_pickupfix_playerPickupData[playerid][_key_pickupfix_IsPickupUsed] = false;
 
                    return 1;
                }
            }
        }
    }
    #if defined _key_pickupfix_OnPlayerKeyState
        _key_pickupfix_OnPlayerKeyState(playerid, newkeys, oldkeys);
    #endif
    return 1;
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange _key_pickupfix_OnPlayerKeyState
#if defined _key_pickupfix_OnPlayerKeyState
forward _key_pickupfix_OnPlayerKeyState(playerid, newkeys, oldkeys);