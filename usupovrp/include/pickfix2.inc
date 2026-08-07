
/*
		pickfix | v2.0
		Исправление повторения срабатывания пикапов
		Edwin, 2016 RU
		
		Инклуд так же работает и с пикапами плагина streamer от Incognito. Важно, что бы streamer был подключен раньше pickfix.
			Действие фиксов не распространиются на динамические пикапы, созданные через CreateDynamicPickupEx.
		На динамические пикапы установлен лимит в '4096' пикапов. Что бы его изменить, 
			нужно объявить макрос MAX_DYNAMIC_PICKUPS до подключения инклуда.
		
		Коллбэки:
			OnPlayerPickupExit (playerid, pickupid) // Срабатывает при выходе игрока из пикапа
			OnPlayerDynamicPickupExit (playerid, pickupid) // Срабатывает при выходе игрока из динамического пикапа
			
		Функции:
			IsValidPickup (pickupid) // Проверяет существует ли пикап pickupid
			GetPickupPos (pickupid, Float:X, Float:Y, Float:Z) // Возвращает 0, если пикапа не существует. Косвенно возвращает X, Y и Z позицию пикапа
			GetPickupVirtualWorld (pickupid) // Получает виртуальный мир пикапа
*/


forward OnPlayerPickupExit(playerid, pickupid);


enum fx_pkp_inf
{
		bool:crtd,
		Float:pos_pkp[3],
		vir_pkp		
}
static 	pickfix_inf[MAX_PICKUPS][fx_pkp_inf];
static 	player_on_pkp[MAX_PLAYERS];



// ====================================


#if defined Streamer_IncludeFileVersion


	#if !defined MAX_DYNAMIC_PICKUPS
		#define MAX_DYNAMIC_PICKUPS 4096
	#endif 


	forward OnPlayerDynamicPickupExit(playerid, pickupid);
	
	
	
	enum fx_dyn_pkp_inf
	{
			bool:crtd,
			Float:pos_pkp[3],
			vir_pkp,
			int_pkp
	}
	static 	pickfix_dyn_inf[MAX_DYNAMIC_PICKUPS][fx_dyn_pkp_inf];
	static 	player_on_dyn_pkp[MAX_PLAYERS];


	stock pickfix__CreateDynamicPickup(modelid, type, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = 100.0)
	{
			new pkp_id = CreateDynamicPickup(modelid, type, x, y, z, worldid, interiorid, playerid, streamdistance);
			if(pkp_id == -1) return -1;
			pickfix_dyn_inf[pkp_id][crtd] = true;
			pickfix_dyn_inf[pkp_id][pos_pkp][0] = x;
			pickfix_dyn_inf[pkp_id][pos_pkp][1] = y;
			pickfix_dyn_inf[pkp_id][pos_pkp][2] = z;
			pickfix_dyn_inf[pkp_id][vir_pkp] = worldid;
			pickfix_dyn_inf[pkp_id][int_pkp] = interiorid;
			return pkp_id;
	}
	
	stock pickfix__DestroyDynamicPickup(pickupid)
	{
			if(!pickfix_dyn_inf[pickupid][crtd]) return 0;
			pickfix_dyn_inf[pickupid][crtd] = false;
			pickfix_dyn_inf[pickupid][pos_pkp][0] = 0.0;
			pickfix_dyn_inf[pickupid][pos_pkp][1] = 0.0;
			pickfix_dyn_inf[pickupid][pos_pkp][2] = 0.0;
			pickfix_dyn_inf[pickupid][vir_pkp] = 0;
			pickfix_dyn_inf[pickupid][int_pkp] = 0;
			return DestroyDynamicPickup(pickupid);
	}
	
	public OnPlayerPickUpDynamicPickup(playerid, pickupid)
	{
			if(player_on_dyn_pkp[playerid] != -1) return 1;
			
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, 
											pickfix_inf[pickupid][pos_pkp][0], 
											pickfix_inf[pickupid][pos_pkp][1], 
											pickfix_inf[pickupid][pos_pkp][2])) return 1;
			
			player_on_dyn_pkp[playerid] = pickupid;
			player_on_pkp[playerid] = -2;
		
	#if defined pickfix__OnPlayerPickUpDynamicP
			return pickfix__OnPlayerPickUpDynamicP(playerid, pickupid);
	#endif
	} 

	

	#if defined	_ALS_CreateDynamicPickup
		#undef	CreateDynamicPickup
	#else
		#define	_ALS_CreateDynamicPickup
	#endif
	#define CreateDynamicPickup		pickfix__CreateDynamicPickup  
	
	
	#if defined _ALS_DestroyDynamicPickup
		#undef 	DestroyDynamicPickup
	#else
		#define	_ALS_DestroyDynamicPickup
	#endif
	#define DestroyDynamicPickup	pickfix__DestroyDynamicPickup
	
	
	#if defined _ALS_OnPlayerPickUpDynamicP
		#undef OnPlayerPickUpDynamicP 
	#else
		#define    _ALS_OnPlayerPickUpDynamicP
	#endif

	#define OnPlayerPickUpDynamicPickup   pickfix__OnPlayerPickUpDynamicP

	#if defined pickfix__OnPlayerPickUpDynamicP
		forward pickfix__OnPlayerPickUpDynamicP(playerid, pickupid);
	#endif 


#endif


// ====================================
		
		
stock pickfix__CreatePickup(model, type, Float:X, Float:Y, Float:Z, Virtualworld = 0)
{
		new pkp_id = CreatePickup(model, type, X, Y, Z, Virtualworld);
		if(pkp_id == -1) return -1;
		pickfix_inf[pkp_id][crtd] = true;
		pickfix_inf[pkp_id][pos_pkp][0] = X;
		pickfix_inf[pkp_id][pos_pkp][1] = Y;
		pickfix_inf[pkp_id][pos_pkp][2] = Z;
		pickfix_inf[pkp_id][vir_pkp] = Virtualworld;
		return pkp_id;
}

stock pickfix__DestroyPickup(pickup)
{
		if(!pickfix_inf[pickup][crtd]) return 0;
		pickfix_inf[pickup][crtd] = false;
		pickfix_inf[pickup][pos_pkp][0] = 0.0;
		pickfix_inf[pickup][pos_pkp][1] = 0.0;
		pickfix_inf[pickup][pos_pkp][2] = 0.0;
		pickfix_inf[pickup][vir_pkp] = 0;
		return DestroyPickup(pickup);
}


public OnPlayerPickUpPickup(playerid, pickupid)
{
		if(player_on_pkp[playerid] != -1) return 1;
		
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, 
											pickfix_inf[pickupid][pos_pkp][0], 
											pickfix_inf[pickupid][pos_pkp][1], 
											pickfix_inf[pickupid][pos_pkp][2])) return 1;
		
		player_on_pkp[playerid] = pickupid;
		
#if defined pickfix__OnPlayerPickUpPickup
		return pickfix__OnPlayerPickUpPickup(playerid, pickupid);
#endif
}


public OnPlayerConnect(playerid)
{
		player_on_pkp[playerid] = -1;

#if defined Streamer_IncludeFileVersion
		player_on_dyn_pkp[playerid] = -1;
#endif

#if defined pickfix__OnPlayerConnect
		return pickfix__OnPlayerConnect(playerid);
#endif
}

		
		
public OnPlayerUpdate(playerid)
{
		if(player_on_pkp[playerid] > -1)
		{
				if(!IsPlayerInRangeOfPoint(	playerid, 1.4, 
											pickfix_inf[player_on_pkp[playerid]][pos_pkp][0], 
											pickfix_inf[player_on_pkp[playerid]][pos_pkp][1], 
											pickfix_inf[player_on_pkp[playerid]][pos_pkp][2]))
				{
						CallRemoteFunction("OnPlayerPickupExit", "ii", playerid, player_on_pkp[playerid]);
						player_on_pkp[playerid] = -1;
				}
		}
		
#if defined Streamer_IncludeFileVersion
		
		if(player_on_dyn_pkp[playerid] > -1)
		{
				if(!IsPlayerInRangeOfPoint(	playerid, 1.4, 
											pickfix_dyn_inf[player_on_dyn_pkp[playerid]][pos_pkp][0],
											pickfix_dyn_inf[player_on_dyn_pkp[playerid]][pos_pkp][1],
											pickfix_dyn_inf[player_on_dyn_pkp[playerid]][pos_pkp][2]))
				{					
						CallRemoteFunction("OnPlayerDynamicPickupExit", "ii", playerid, player_on_dyn_pkp[playerid]);
						player_on_dyn_pkp[playerid] = -1;
						player_on_pkp[playerid] = -1;
				}
		}
		
#endif

#if defined pickfix__OnPlayerUpdate
		return pickfix__OnPlayerUpdate(playerid);
#endif
}



stock	IsValidPickup (pickupid)
        return pickfix_inf[pickupid][crtd];

stock 	GetPickupPos (pickupid, &Float:X, &Float:Y, &Float:Z)
{
		if(!pickfix_inf[pickupid][crtd]) return 0;
		X = pickfix_inf[pickupid][pos_pkp][0];
		Y = pickfix_inf[pickupid][pos_pkp][1];
		Z = pickfix_inf[pickupid][pos_pkp][2];
		return 1;
}

stock 	GetPickupVirtualWorld (pickupid)
		return pickfix_inf[pickupid][vir_pkp];
		
	 




#if defined _ALS_CreatePickup
    #undef 	CreatePickup
#else
    #define	_ALS_CreatePickup
#endif
#define CreatePickup	pickfix__CreatePickup  


#if defined _ALS_DestroyPickup
    #undef 	DestroyPickup
#else
    #define	_ALS_DestroyPickup
#endif
#define DestroyPickup	pickfix__DestroyPickup


#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup    

#else
    #define    _ALS_OnPlayerPickUpPickup
#endif

#define OnPlayerPickUpPickup   pickfix__OnPlayerPickUpPickup

#if defined pickfix__OnPlayerPickUpPickup
	forward pickfix__OnPlayerPickUpPickup(playerid, pickupid);
#endif  



#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect pickfix__OnPlayerConnect
#if defined pickfix__OnPlayerConnect
	forward pickfix__OnPlayerConnect(playerid);
#endif



#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate   
#else
    #define    _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate   pickfix__OnPlayerUpdate
#if defined pickfix__OnPlayerUpdate
	forward pickfix__OnPlayerUpdate(playerid);
#endif


// ====================================
