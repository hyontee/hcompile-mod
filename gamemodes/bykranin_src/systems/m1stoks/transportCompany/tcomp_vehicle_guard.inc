//>> Файл: bykranin_src/systems/m1stoks/transportCompany/tcomp_vehicle_guard.inc  (75 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: TC_GuardVehicle, TC_RegisterGuardedVehicle, TC_IsGuardedVehicle, TC_IsModuleWorkVehicle, TC_ClearGuardedVehicle, TC_ForceDestroyVehicle, tc_DestroyVehicle
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/transportCompany/tcomp_vehicle_guard.inc
#if defined _tcomp_vehicle_guard_included
	#endinput
#endif
#define _tcomp_vehicle_guard_included

new bool:g_tc_guarded_vehicle[MAX_VEHICLES];
new g_tc_guard_owner[MAX_VEHICLES];

stock TC_GuardVehicle(vehicleid, bool:guard)
{
	if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
	g_tc_guarded_vehicle[vehicleid] = guard;
	if(!guard)
		g_tc_guard_owner[vehicleid] = -1;
	return 1;
}

stock TC_RegisterGuardedVehicle(vehicleid, playerid)
{
	if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
	g_tc_guarded_vehicle[vehicleid] = true;
	g_tc_guard_owner[vehicleid] = playerid;
	return 1;
}

stock TC_IsGuardedVehicle(vehicleid)
{
	if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
	return g_tc_guarded_vehicle[vehicleid];
}

stock TC_IsModuleWorkVehicle(vehicleid)
{
	if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
	if(TC_IsGuardedVehicle(vehicleid)) return 1;
	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(p_tc_trailer_vehicle[i] == vehicleid) return 1;
		if(p_tc_rent_vehicle[i] == vehicleid) return 1;
	}
	return 0;
}

stock TC_ClearGuardedVehicle(vehicleid)
{
	return TC_GuardVehicle(vehicleid, false);
}

stock TC_ForceDestroyVehicle(vehicleid)
{
	if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;
	TC_ClearGuardedVehicle(vehicleid);
	return n_veh_DestroyVehicle(vehicleid);
}

stock tc_DestroyVehicle(vehicleid)
{
	if(TC_IsGuardedVehicle(vehicleid))
	{
		printf("[TransportCompany] Заблокирован DestroyVehicle для ТС #%d (owner %d)", vehicleid, g_tc_guard_owner[vehicleid]);
		return 0;
	}
	return n_veh_DestroyVehicle(vehicleid);
}

#if defined _ALS_DestroyVehicle
	#undef DestroyVehicle
#else
	#define _ALS_DestroyVehicle
#endif
#define DestroyVehicle tc_DestroyVehicle
// END INLINED: modules/m1stoks/transportCompany/tcomp_vehicle_guard.inc
