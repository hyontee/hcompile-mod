stock AC_MODE_PutPlayerInVehicle(playerid,vehicleid,seatid)
{
	SetPVarInt(playerid,"cheat_info_veh",vehicleid);
	return PutPlayerInVehicle(playerid,vehicleid,seatid);
}
#define PutPlayerInVehicle AC_MODE_PutPlayerInVehicle

stock AC_MODE_SetVehiclePos(vehicleid,Float:x,Float:y,Float:z)
{
	return CallRemoteFunction("AC_SetVehiclePos","ifff",vehicleid,x,y,z);
}
#define SetVehiclePos AC_MODE_SetVehiclePos

stock AC_MODE_ResetPlayerWeapons(playerid)
{
	return CallRemoteFunction("AC_ResetPlayerWeapons","i",playerid);
}
#define ResetPlayerWeapons AC_MODE_ResetPlayerWeapons

stock AC_MODE_RemovePlayerFromVehicle(playerid)
{
	return CallRemoteFunction("AC_RemovePlayerFromVehicle","i",playerid);
}
#define RemovePlayerFromVehicle AC_MODE_RemovePlayerFromVehicle

stock AC_MODE_SetPlayerPos(playerid, Float:X,Float:Y,Float:Z)
{
	return CallRemoteFunction("AC_SetPlayerPos","ifff",playerid,X,Y,Z);
}
#define SetPlayerPos AC_MODE_SetPlayerPos

stock AC_MODE_GivePlayerWeapon(playerid,weapid,ammo)
{
	return CallRemoteFunction("AC_GivePlayerWeapon","iii",playerid,weapid,ammo);
}
#define GivePlayerWeapon AC_MODE_GivePlayerWeapon

forward OnPlayerCheat(playerid,code);