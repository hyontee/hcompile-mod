// Active module registry. Donor callback names are namespaced per module to avoid ALS collisions.
#include "modules/tomato_greenhouse.pwn"

#include "modules/vodo.pwn"
#include "modules/create.pwn"
#include "modules/weekly_prizes.pwn"
#include "modules/event_new_year.pwn"
#include "modules/auction.pwn"
#include "modules/tuning_stage.pwn"
#include "modules/transport_company.pwn"
#include "modules/roulette.pwn"
#include "modules/electric_job.pwn"
#include "modules/family_storage_adapter.pwn"

#include "modules/mchs.pwn"
#include "modules/zavod.pwn"
#include "modules/system_w_mechanic.pwn"
#include "modules/duel_race.pwn"
#include "modules/dragy_welsi.pwn"
#include "modules/family_addition.pwn"
#include "modules/hijacker_job.pwn"
#include "modules/weapon.pwn"

#include "modules/used_veh_market.pwn"
#include "modules/garage.pwn"
#include "modules/orel_reshka.pwn"
#include "modules/nz_welsi_kuzia.pwn"
#include "modules/exchange_welsi.pwn"
stock SystemModules_OnPlayerConnect(playerid)
{
    SYS_VODO_OnPlayerConnect(playerid);
    SYS_WEEKLY_PRIZES_OnPlayerConnect(playerid);
    SYS_EVENT_NEW_YEAR_OnPlayerConnect(playerid);
    SYS_AUCTION_OnPlayerConnect(playerid);
    SYS_TUNING_STAGE_OnPlayerConnect(playerid);
    SYS_TRANSPORT_COMPANY_OnPlayerConnect(playerid);
    SYS_ROULETTE_OnPlayerConnect(playerid);
    SYS_ELECTRIC_JOB_OnPlayerConnect(playerid);
    SYS_MCHS_OnPlayerConnect(playerid);
    SYS_DUEL_RACE_OnPlayerConnect(playerid);
    SYS_HIJACKER_JOB_OnPlayerConnect(playerid);
    SYS_NZ_WELSI_KUZIA_OnPlayerConnect(playerid);
    SYS_EXCHANGE_WELSI_OnPlayerConnect(playerid);
    return 1;
}

stock SystemModules_OnPlayerEnterDynamicArea(playerid, areaid)
{
    SYS_VODO_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_CREATE_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_AUCTION_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_TRANSPORT_COMPANY_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_ELECTRIC_JOB_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_MCHS_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_SYSTEM_W_MECHANIC_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_DUEL_RACE_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_FAMILY_ADDITION_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_HIJACKER_JOB_OnPlayerEnterDynamicArea(playerid, areaid);
    SYS_USED_VEH_MARKET_OnPlayerEnterDynamicArea(playerid, areaid);
    return 1;
}

stock SystemModules_OnGameModeInit()
{
    SYS_VODO_OnGameModeInit();
    SYS_CREATE_OnGameModeInit();
    SYS_WEEKLY_PRIZES_OnGameModeInit();
    SYS_EVENT_NEW_YEAR_OnGameModeInit();
    SYS_AUCTION_OnGameModeInit();
    SYS_TUNING_STAGE_OnGameModeInit();
    SYS_TRANSPORT_COMPANY_OnGameModeInit();
    SYS_ROULETTE_OnGameModeInit();
    SYS_ELECTRIC_JOB_OnGameModeInit();
    SYS_MCHS_OnGameModeInit();
    SYS_ZAVOD_OnGameModeInit();
    SYS_SYSTEM_W_MECHANIC_OnGameModeInit();
    SYS_DUEL_RACE_OnGameModeInit();
    SYS_FAMILY_ADDITION_OnGameModeInit();
    SYS_HIJACKER_JOB_OnGameModeInit();
    SYS_USED_VEH_MARKET_OnGameModeInit();
    SYS_GARAGE_OnGameModeInit();
    SYS_OREL_RESHKA_OnGameModeInit();
    SYS_NZ_WELSI_KUZIA_OnGameModeInit();
    SYS_EXCHANGE_WELSI_OnGameModeInit();
    return 1;
}

stock SystemModules_OnPlayerUpdate(playerid)
{
    SYS_VODO_OnPlayerUpdate(playerid);
    SYS_ZAVOD_OnPlayerUpdate(playerid);
    return 1;
}

stock SystemModules_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    SYS_VODO_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_CREATE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_WEEKLY_PRIZES_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_EVENT_NEW_YEAR_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_AUCTION_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_TUNING_STAGE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_TRANSPORT_COMPANY_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_ROULETTE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_ELECTRIC_JOB_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_MCHS_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_SYSTEM_W_MECHANIC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_DUEL_RACE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_DRAGY_WELSI_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_HIJACKER_JOB_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_USED_VEH_MARKET_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_GARAGE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_OREL_RESHKA_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    SYS_EXCHANGE_WELSI_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    return 1;
}

stock SystemModules_OnPlayerSpawn(playerid)
{
    SYS_VODO_OnPlayerSpawn(playerid);
    SYS_EVENT_NEW_YEAR_OnPlayerSpawn(playerid);
    SYS_TRANSPORT_COMPANY_OnPlayerSpawn(playerid);
    SYS_ELECTRIC_JOB_OnPlayerSpawn(playerid);
    SYS_DUEL_RACE_OnPlayerSpawn(playerid);
    SYS_FAMILY_ADDITION_OnPlayerSpawn(playerid);
    SYS_HIJACKER_JOB_OnPlayerSpawn(playerid);
    SYS_USED_VEH_MARKET_OnPlayerSpawn(playerid);
    SYS_GARAGE_OnPlayerSpawn(playerid);
    SYS_OREL_RESHKA_OnPlayerSpawn(playerid);
    return 1;
}

stock SystemModules_OnPlayerEnterCheckpoint(playerid)
{
    SYS_VODO_OnPlayerEnterCheckpoint(playerid);
    SYS_EVENT_NEW_YEAR_OnPlayerEnterCheckpoint(playerid);
    SYS_TRANSPORT_COMPANY_OnPlayerEnterCheckpoint(playerid);
    SYS_SYSTEM_W_MECHANIC_OnPlayerEnterCheckpoint(playerid);
    return 1;
}

stock SystemModules_OnPlayerDisconnect(playerid, reason)
{
    SYS_WEEKLY_PRIZES_OnPlayerDisconnect(playerid, reason);
    SYS_EVENT_NEW_YEAR_OnPlayerDisconnect(playerid, reason);
    SYS_ROULETTE_OnPlayerDisconnect(playerid, reason);
    SYS_ELECTRIC_JOB_OnPlayerDisconnect(playerid, reason);
    SYS_MCHS_OnPlayerDisconnect(playerid, reason);
    SYS_SYSTEM_W_MECHANIC_OnPlayerDisconnect(playerid, reason);
    SYS_DUEL_RACE_OnPlayerDisconnect(playerid, reason);
    SYS_FAMILY_ADDITION_OnPlayerDisconnect(playerid, reason);
    SYS_HIJACKER_JOB_OnPlayerDisconnect(playerid, reason);
    SYS_USED_VEH_MARKET_OnPlayerDisconnect(playerid, reason);
    SYS_EXCHANGE_WELSI_OnPlayerDisconnect(playerid, reason);
    return 1;
}

stock SystemModules_OnPlayerExitVehicle(playerid, vehicleid)
{
    SYS_EVENT_NEW_YEAR_OnPlayerExitVehicle(playerid, vehicleid);
    return 1;
}

stock SystemModules_OnPlayerLeaveDynamicArea(playerid, areaid)
{
    SYS_EVENT_NEW_YEAR_OnPlayerLeaveDynamicArea(playerid, areaid);
    SYS_FAMILY_ADDITION_OnPlayerLeaveDynamicArea(playerid, areaid);
    return 1;
}

stock SystemModules_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    SYS_AUCTION_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
    SYS_TUNING_STAGE_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
    return 1;
}

stock SystemModules_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    SYS_TUNING_STAGE_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    SYS_FAMILY_ADDITION_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    SYS_HIJACKER_JOB_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    return 1;
}

stock SystemModules_OnPlayerClickTextDraw(playerid, clickedid)
{
    SYS_TUNING_STAGE_OnPlayerClickTextDraw(playerid, clickedid);
    SYS_ROULETTE_OnPlayerClickTextDraw(playerid, clickedid);
    SYS_NZ_WELSI_KUZIA_OnPlayerClickTextDraw(playerid, clickedid);
    return 1;
}

stock SystemModules_OnTrailerUpdate(playerid, vehicleid)
{
    SYS_TRANSPORT_COMPANY_OnTrailerUpdate(playerid, vehicleid);
    return 1;
}

stock SystemModules_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    SYS_MCHS_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    SYS_FAMILY_ADDITION_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    SYS_USED_VEH_MARKET_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    SYS_GARAGE_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    return 1;
}

stock SystemModules_OnPlayerPickUpPickupEx(playerid, pickupid)
{
    SYS_ZAVOD_OnPlayerPickUpPickupEx(playerid, pickupid);
    SYS_GARAGE_OnPlayerPickUpPickupEx(playerid, pickupid);
    return 1;
}

stock SystemModules_OnPlayerCommandText(playerid, cmdtext[])
{
    new handled = 0;
    handled = SYS_DUEL_RACE_OnPlayerCommandText(playerid, cmdtext);
    return handled;
}

stock SystemModules_OnPlayerEnterRaceCheckpoint(playerid)
{
    SYS_DUEL_RACE_OnPlayerEnterRaceCheckpoint(playerid);
    return 1;
}

stock SystemModules_OnPlayerDeath(playerid, killerid, reason)
{
    SYS_FAMILY_ADDITION_OnPlayerDeath(playerid, killerid, reason);
    SYS_GARAGE_OnPlayerDeath(playerid, killerid, reason);
    return 1;
}
