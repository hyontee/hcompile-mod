
#include <a_samp>
#include <a_mysql>

new bool:TurnLightState[MAX_VEHICLES];
new bool:HazardLightState[MAX_VEHICLES];
new MySQL:db;

public OnFilterScriptInit()
{
    db = mysql_connect("localhost", "user", "pass", "dbname");
    if(db == MYSQL_INVALID_HANDLE || mysql_errno(db) != 0)
    {
        print("MySQL connection failed.");
    }
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    HazardLightState[vehicleid] = true;
    SetTimerEx("VehicleUpdateTurnLight", 500, true, "d", vehicleid);
    return 1;
}

forward VehicleUpdateTurnLight(vehicleid);
public VehicleUpdateTurnLight(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return 0;
    TurnLightState[vehicleid] = !TurnLightState[vehicleid];
    if(TurnLightState[vehicleid]) SetVehicleParamsEx(vehicleid, 1,1,0,0,0,0,0);
    else SetVehicleParamsEx(vehicleid, 0,0,0,0,0,0,0);
    return 1;
}

forward CheckMySQLAuthenticatorTL(playerid);
public CheckMySQLAuthenticatorTL(playerid)
{
    new query[128];
    format(query, sizeof(query), "SELECT id FROM accounts WHERE name='%s'", GetName(playerid));
    mysql_tquery(db, query, "OnCheckAuthTL", "d", playerid);
    return 1;
}

forward OnCheckAuthTL(playerid);
public OnCheckAuthTL(playerid)
{
    if(cache_num_rows() > 0)
    {
        print("Auth success.");
    }
    else
    {
        print("Auth failed.");
    }
    return 1;
}

forward OnIncomingRPC(playerid, rpcid, BitStream:bs);
public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
    if(rpcid == 211)
    {
        new veh = GetPlayerVehicleID(playerid);
        if(IsValidVehicle(veh))
        {
            HazardLightState[veh] = !HazardLightState[veh];
        }
    }
    return 1;
}

stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
