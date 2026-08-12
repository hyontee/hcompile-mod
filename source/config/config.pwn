#define REMOVE_BUILDINGS_DISABLED	0 //0 = false
#define debug_mode 	0 

#undef MAX_PLAYERS
#undef MAX_VEHICLES

const MAX_PLAYERS     		= 1000;
const MAX_VEHICLES    		= 2000; 

#define STREAMER_MAP_ICON_SD 150.0
#define FOREACH_I_PlayerInVehicle true

native gpci(playerid, buffer[], size = sizeof(buffer));
#if !defined IsValidVehicle
    native IsValidVehicle(vehicleid);
#endif
stock strcpy(dest[], const source[], maxlength = sizeof dest)
    return strcat((dest[0] = EOS, dest), source, maxlength);

new 
	NEW_ANTICHEAT_ALF = 1,
	NEW_ANTICHEAT_ALF_CAR = 1;