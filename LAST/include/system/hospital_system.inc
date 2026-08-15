// Центральная больница BR — вход/выход, койки, лечение, смерть
#if defined _BR_HOSPITAL_SYSTEM_INC_
	#endinput
#endif
#define _BR_HOSPITAL_SYSTEM_INC_

forward Player_FixInteriorWorldLeak(playerid);
forward ShowPlayerGUI(playerid, guiid, Node:json);
forward OnPacketIncoming(playerid, guiid, Node:json);
forward Hospital_DeathRespawn(playerid);
forward Hospital_SyncInterior(playerid);
forward Hospital_WoundAutoTransfer(playerid);
forward Hospital_TreatmentTick();
forward Hospital_BedProxTick(playerid);
forward Inv_ApplySingleWornAccessory(playerid);
forward Hospital_RestoreAppearanceDelayed(playerid);
forward Inv_TryApplyWornAccessories(playerid);
forward Hospital_CompleteTransfer(playerid);
forward Hospital_FadeStepTick(playerid);
forward Hospital_WoundLieTick(playerid);
forward Hospital_WoundCamHoldTick(playerid);
forward Hospital_WoundEnterProneDelayed(playerid);
forward Hospital_WoundAnimApply(playerid);
forward bool:ChiefDoctor_IsNearNpc(playerid);
forward ChiefDoctor_Init();
forward ChiefDoctor_TickPlayer(playerid);
forward ChiefDoctor_ResetPlayer(playerid);
forward ChiefDoctor_OnEnterHospital(playerid);
forward ChiefDoctor_ApplyFastHealOnExit(playerid);
forward ChiefDoctor_ApplyFastHealDelayed(playerid);
forward ChiefDoctor_FinishFastHealExit(playerid);
forward bool:ChiefDoctor_PlayerHasFastHeal(playerid);
forward ChiefDoctor_TryInteract(playerid);
forward ChiefDoctor_ProxStop(playerid);
forward bool:ChiefDoctor_CanLeaveHospital(playerid);
forward bool:ChiefDoctor_HandleGuiPacket(playerid, Node:json);
forward ChiefDoctor_CmdMed(playerid, params[]);
forward ChiefDoctor_ShowMedCardDialog(viewerid, ownerid);
forward bool:ChiefDoctor_PlayerHasMedCard(playerid);
forward bool:Hospital_IsInInteriorZone(playerid);
forward Hospital_OnPlayerDisconnect(playerid);
forward Hospital_ResolveReconnectSpawn(playerid);
forward bool:Hospital_HasUnfinishedSession(playerid);
forward SavePlayerAccount(playerid);
forward Player_SyncVitalsFromGame(playerid);
forward bool:SpawnLoc_HasLastPos(playerid);
forward SpawnLoc_FinalizeWorldSpawn(playerid, Float:sx, Float:sy, Float:sz, Float:sa);
forward Hospital_ApplyUnfinishedSessionSpawn(playerid);
forward Hospital_SyncUnfinishedLoginSpawn(playerid);
forward HideInteractionWindow(playerid);
forward BR_ApplyPvPDamage(damagedid, Float:amount, killerid = INVALID_PLAYER_ID);
forward BR_ProcessPvPHit(victimid, attackerid, weaponid, Float:shotDistance = 0.0, Float:clientAmount = 0.0);

#define HOSPITAL_PVAR_LOGIN_SPAWN_BRANCH   "HospLoginSpawnBr"
#define HOSPITAL_PVAR_LOGIN_SPAWN_BED      "HospLoginSpawnBed"
#define HOSPITAL_PVAR_LOGIN_SPAWN_HP       "HospLoginSpawnHP"

#define HOSPITAL_PVAR_DEATH_RESPAWN      "HospitalDeathRespawn"
#define HOSPITAL_PVAR_TRANSFER_FADE      "HospitalXferFade"
#define HOSPITAL_PVAR_WOUND_CAM          "HospitalWoundCamLock"
#if !defined HCD_PVAR_GUI_OPEN
	#define HCD_PVAR_GUI_OPEN           "HospChiefGuiOpen"
#endif
#define HOSPITAL_PVAR_NEAR_EXIT          "HospitalNearExit"
#define HOSPITAL_EXIT_USE_RADIUS         (2.8)
#define HOSPITAL_WOUND_LIE_TICK_MS       (350)
#define HOSPITAL_WOUND_ANIM_REAPPLY_MS   (2800)
#define HOSPITAL_WOUND_ANIM_LIB          "CRACK"
#define HOSPITAL_WOUND_ANIM_NAME         "crckdeth2"
#define HOSPITAL_WOUND_ANIM_ALT_LIB      "SWEET"
#define HOSPITAL_WOUND_ANIM_ALT_NAME     "Sweet_injuredloop"
#define HOSPITAL_EXIT_PICKUP_MODEL       (1318)
#define HOSPITAL_EXIT_ARROW_MODEL        (1318)
#define HOSPITAL_PVAR_GREEN_ZONE         "HospitalInGreenZone"

#define HOSPITAL_FADE_NONE               (0)
#define HOSPITAL_FADE_IN                 (1)
#define HOSPITAL_FADE_OUT                (2)
#define HOSPITAL_FADE_STEPS              (14)
#define HOSPITAL_FADE_STEP_MS            (50)

#define HOSPITAL_BRANCH_COUNT       (3)
#define HOSPITAL_INTERIOR_ID        (1)
#define HOSPITAL_PICKUP_MODEL       (1318)
#define HOSPITAL_PICKUP_TYPE        (23)
#define HOSPITAL_DEATH_RESPAWN_MS   (120)

// Wounded system (GUI 40)
#define HOSPITAL_WOUND_GUI_ID          (40)
#define HOSPITAL_WOUND_MIN_PRONE_SEC   (300) // 5 минут — авто-перевод в больницу
#define HOSPITAL_WOUND_WAIT_EXTRA_SEC  (30)  // +30 секунд лёжа (кнопка «ждать помощи»)
#define HOSPITAL_WOUND_HOSPITAL_BTN_SEC (15) // таймер кнопки «в больницу» на клиенте
#define HOSPITAL_ATTACKER_TIMEOUT_SEC    (45)

#define HOSPITAL_BRANCH_ARZAMAS     (0)
#define HOSPITAL_BRANCH_LYTKARINO   (1)
#define HOSPITAL_BRANCH_NIZHEGORODSK (2)

#define HOSPITAL_VW_ARZAMAS         (2)
#define HOSPITAL_VW_NIZHEGORODSK    (3)
#define HOSPITAL_VW_LYTKARINO       (4)

#define HOSPITAL_DEATH_BED_COUNT    (4)
#define HOSPITAL_BED_COUNT          (16)

#if !defined HOSPITAL_PICKUP_CD_MS
	#define HOSPITAL_PICKUP_CD_MS   (3000)
#endif
#if !defined HOSPITAL_INTERIOR_RADIUS
	#define HOSPITAL_INTERIOR_RADIUS (120.0)
#endif
#if !defined HOSPITAL_GREEN_ZONE_RADIUS
	#define HOSPITAL_GREEN_ZONE_RADIUS HOSPITAL_INTERIOR_RADIUS
#endif
#if !defined HOSPITAL_BED_LABEL_Z_OFF
	#define HOSPITAL_BED_LABEL_Z_OFF (0.55)
#endif
#define HOSPITAL_CLR_TITLE          "{FFCD00}"
#define HOSPITAL_CLR_LINE             "{FFCD00}"
#define HOSPITAL_CLR_VALUE            "{FFCD00}"
#define HOSPITAL_CLR_ABSENT           "{99FF66}"
#define HOSPITAL_CLR_HINT             "{FFFFFF}"
#define HOSPITAL_LABEL_DRAW_DIST      (12.0)
#if !defined HOSPITAL_BED_LABEL_SHOW_DIST
	#define HOSPITAL_BED_LABEL_SHOW_DIST (HOSPITAL_BED_USE_RADIUS + 0.6)
#endif
#define HOSPITAL_WOUND_CAM_HOLD_MS      (120)
#define HOSPITAL_WOUND_LIE_MIN_SEC      (60)
#if !defined HOSPITAL_BED_USE_RADIUS
	#define HOSPITAL_BED_USE_RADIUS (2.2)
#endif
#if !defined HOSPITAL_BED_PROX_MS
	#define HOSPITAL_BED_PROX_MS    (250)
#endif
#if !defined HOSPITAL_HEAL_AMOUNT
	#define HOSPITAL_HEAL_AMOUNT    (2.0)
#endif
#if !defined HOSPITAL_HEAL_INTERVAL_MS
	#define HOSPITAL_HEAL_INTERVAL_MS (2000)
#endif
#if !defined HOSPITAL_RESPAWN_HP
	#define HOSPITAL_RESPAWN_HP     (10.0)
#endif
#if !defined HOSPITAL_EXIT_MIN_HP
	#define HOSPITAL_EXIT_MIN_HP    (99.5)
#endif

// mod laird/include/anticheat.inc — WeaponDamage + DamageSystem (античит в death.pwn не подключён)
static Float:g_BRWeaponDamage[47] =
{
	6.60, 1.32, 4.62, 6.60, 6.60, 6.60, 6.60,
	6.60, 6.60, 27.06, 4.62, 6.60, 6.60, 6.60,
	4.62, 6.60, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
	8.25, 13.2, 46.2, 49.5, 49.5, 39.6, 6.6,
	8.25, 9.9, 9.9, 6.6, 24.75, 41.25, 0.0,
	0.0, 0.0, 46.2, 0.0, 0.0, 0.33, 0.33,
	0.0, 0.0, 0.0, 0.0
};
// Индекс = weaponid: 0 кулак 6.6 | 1-15 холодное | 9 бензопила 27 | 22-34 стволы
// 24 Deagle 46.2 | 25-27 дробовики | 30 AK 9.9 | 31 M4 6.6 | 32 TEC-9 6.6 | 33 винтовка 24.75 | 34 снайпер 41.25 | 38 миниган 46.2
// 41-42 баллончик/огнетушитель 0.33 | 16-21,35-40,43-46 — без PvP-урона по таблице | 47..54 — cap client amount

#if !defined BR_DMG_DEDUP_MS
	#define BR_DMG_DEDUP_MS (120)
#endif
#if !defined BR_WEAPON_ID_MAX
	#define BR_WEAPON_ID_MAX (54) // как в anticheat.inc (0..54)
#endif
#if !defined BR_DMG_CLIENT_CAP
	#define BR_DMG_CLIENT_CAP (55.0) // потолок для кастомного оружия BR (id > 46)
#endif

new g_BRDamageLastTick[MAX_PLAYERS];
new g_BRDamageLastWeapon[MAX_PLAYERS];

enum E_HOSPITAL_BRANCH
{
	Float:H_OUT_X,
	Float:H_OUT_Y,
	Float:H_OUT_Z,
	Float:H_OUT_A,
	H_VW
};

enum E_HOSPITAL_SPAWN4
{
	Float:HS_X,
	Float:HS_Y,
	Float:HS_Z,
	Float:HS_A
};

static const g_HospitalBranches[HOSPITAL_BRANCH_COUNT][E_HOSPITAL_BRANCH] =
{
	{-287.6206, 569.9645, 12.8479, 173.0348, HOSPITAL_VW_ARZAMAS},
	{-2337.0822, -178.3215, 27.7050, 136.8463, HOSPITAL_VW_LYTKARINO},
	{-2903.8657, 2326.6064, 9.5581, 269.8836, HOSPITAL_VW_NIZHEGORODSK}
};

static const g_HospitalCityName[HOSPITAL_BRANCH_COUNT][20] =
{
	"Арзамас",
	"Лыткарино",
	"Нижегородск"
};

static const Float:g_HospitalEnterSpawn[4] =
	{1501.4237, 2489.5209, 2501.0402, 355.5327};

static const Float:g_HospitalExitSpawn[4] =
	{1501.5859, 2487.5100, 2501.0402, 173.3988};

static const Float:g_HospitalInteriorCenter[3] =
	{1501.4237, 2489.5209, 2501.0402};

// Точки появления после «В больницу» (interior 1, vw филиала) — койку игрок выбирает сам.
static const g_HospitalDeathBeds[HOSPITAL_DEATH_BED_COUNT][E_HOSPITAL_SPAWN4] =
{
	{1471.8157, 2506.7226, 2501.0402, 171.0872},
	{1469.5902, 2493.6201, 2501.0402, 357.8763},
	{1482.9749, 2506.8986, 2501.0402, 178.1441},
	{1485.0269, 2493.3271, 2501.0402, 7.9964}
};

static const g_HospitalBeds[HOSPITAL_BED_COUNT][E_HOSPITAL_SPAWN4] =
{
	{1486.8896, 2492.6223, 2501.6411, 80.7683},
	{1482.7305, 2492.4953, 2501.6411, 274.5830},
	{1482.8996, 2496.4343, 2501.6411, 269.6312},
	{1486.9375, 2496.6718, 2501.6411, 98.3591},
	{1480.7819, 2507.5515, 2501.6411, 268.7439},
	{1484.7658, 2507.5620, 2501.6411, 96.8994},
	{1484.7011, 2503.7263, 2501.6411, 95.6387},
	{1480.8940, 2503.9011, 2501.6411, 275.2358},
	{1471.4267, 2492.5913, 2501.6411, 82.5101},
	{1467.4814, 2492.5234, 2501.6411, 267.9177},
	{1467.4665, 2496.4421, 2501.6411, 259.3803},
	{1471.4858, 2496.3161, 2501.6411, 86.8874},
	{1469.4882, 2507.6674, 2501.6411, 267.6236},
	{1473.6909, 2507.6787, 2501.6411, 94.3213},
	{1473.7545, 2503.5910, 2501.6411, 105.7462},
	{1469.5147, 2503.7238, 2501.6411, 264.9901}
};

new STREAMER_TAG_PICKUP:gHospitalEnterPickup[HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_PICKUP:gHospitalExitPickup[HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_OBJECT:gHospitalExitArrow[HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gHospitalEnterLabel[HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gHospitalExitLabel[HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gHospitalExitSignLabel[HOSPITAL_BRANCH_COUNT];

new STREAMER_TAG_3D_TEXT_LABEL:gHospitalBedLabel[HOSPITAL_BED_COUNT][HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_AREA:gHospitalGreenArea[HOSPITAL_BRANCH_COUNT];

new g_HospitalBedOccupant[HOSPITAL_BED_COUNT] = {-1, ...};
new g_HospitalPlayerBranch[MAX_PLAYERS] = {-1, ...};
new g_HospitalOccupiedBed[MAX_PLAYERS] = {-1, ...};
new g_HospitalNearBed[MAX_PLAYERS] = {-1, ...};
new g_HospitalBedProxTimer[MAX_PLAYERS] = {-1, ...};

new g_HospitalLastEnter[MAX_PLAYERS];
new g_HospitalLastExit[MAX_PLAYERS];

new bool:g_HospitalSessionActive[MAX_PLAYERS];
new bool:g_HospitalDeathPending[MAX_PLAYERS];
new g_HospitalDeathBranch[MAX_PLAYERS] = {-1, ...};
new g_HospitalDeathBed[MAX_PLAYERS];
new g_HospitalDeathTimer[MAX_PLAYERS];

new g_HospitalWoundStart[MAX_PLAYERS];
new g_HospitalWoundAutoAt[MAX_PLAYERS];
new g_HospitalWoundAutoTimer[MAX_PLAYERS];
new g_HospitalWoundInterior[MAX_PLAYERS];
new g_HospitalWoundVW[MAX_PLAYERS];
new Float:g_HospitalWoundX[MAX_PLAYERS];
new Float:g_HospitalWoundY[MAX_PLAYERS];
new Float:g_HospitalWoundZ[MAX_PLAYERS];
new Float:g_HospitalWoundA[MAX_PLAYERS];
new g_HospitalWoundSkin[MAX_PLAYERS];
new g_HospitalWoundKiller[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new g_HospitalLastAttacker[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new g_HospitalLastAttackAt[MAX_PLAYERS];
new g_HospitalLastAttackerName[MAX_PLAYERS][MAX_PLAYER_NAME];
new g_HospitalTransferArrival[MAX_PLAYERS];
new PlayerText:g_HospitalFadePTD[MAX_PLAYERS];
new g_HospitalFadeMode[MAX_PLAYERS];
new g_HospitalFadeStep[MAX_PLAYERS];
new g_HospitalFadeTimer[MAX_PLAYERS];
new g_HospitalWoundLieTimer[MAX_PLAYERS];
new g_HospitalWoundLieUntil[MAX_PLAYERS];
new g_HospitalWoundCamTimer[MAX_PLAYERS];
new g_HospitalWoundLastAnimMs[MAX_PLAYERS];

stock Hospital_SaveSkinAtDeath(playerid)
{
	// Любой скин: обычный, донат (>311), из pSkin / GetPlayerSkin.
	new skin = GetPlayerSkin(playerid);
	if(skin < 1)
		skin = Player[playerid][pSkin];
	g_HospitalWoundSkin[playerid] = skin;
}

stock Hospital_GetActiveSkin(playerid)
{
	if(g_HospitalWoundSkin[playerid] > 0)
		return g_HospitalWoundSkin[playerid];
	return Player[playerid][pSkin];
}

stock Hospital_GetSpawnInfoSkin(playerid)
{
	new skin = Hospital_GetActiveSkin(playerid);
	if(skin < 1)
		return 0;
	// SetSpawnInfo — только GTA 0..311; донат (>311) надевается в RestoreAppearance.
	if(skin > 311)
		return 0;
	return skin;
}

stock bool:Hospital_PlayerCanWound(playerid)
{
	if(!IsPlayerConnected(playerid))
		return false;
	if(Player[playerid][pID] <= 0)
		return false;
	if(Player[playerid][pJailTime] > 0)
		return false;
	if(GetPVarInt(playerid, "auth_reg_flow"))
		return false;
	if(GetPVarInt(playerid, "auth_reg_finish"))
		return false;
	if(GetPVarInt(playerid, "spawn_gui_active"))
		return false;
	if(GetPVarInt(playerid, "spawn_resolving"))
		return false;
	if(GetPVarInt(playerid, "auth_first_play"))
		return false;
	if(Player[playerid][pHospitalUnfinished] == 1)
		return false;
	return true;
}

stock Hospital_RecordAttacker(damagedid, attackerid)
{
	if(damagedid == INVALID_PLAYER_ID || attackerid == INVALID_PLAYER_ID)
		return 0;
	if(!IsPlayerConnected(damagedid) || !IsPlayerConnected(attackerid))
		return 0;
	if(damagedid == attackerid)
		return 0;

	g_HospitalLastAttacker[damagedid] = attackerid;
	g_HospitalLastAttackAt[damagedid] = gettime();
	format(g_HospitalLastAttackerName[damagedid], MAX_PLAYER_NAME, "%s", Player[attackerid][pName]);
	return 1;
}

// Урон по оружию (laird). clientAmount — только для id 47..54 или если в таблице 0.
stock Float:BR_GetWeaponDamage(weaponid, Float:shotDistance = 0.0, Float:clientAmount = 0.0)
{
	new Float:dmg = 0.0;

	if(0 <= weaponid <= 46)
		dmg = g_BRWeaponDamage[weaponid];
	else if(47 <= weaponid <= BR_WEAPON_ID_MAX && clientAmount > 0.0)
		dmg = (clientAmount < BR_DMG_CLIENT_CAP) ? clientAmount : BR_DMG_CLIENT_CAP;

	if(dmg <= 0.0)
		return 0.0;

	// Дробовики: ослабление на дистанции (laird DamageSystem)
	if(25 <= weaponid <= 27 && shotDistance >= 5.0)
	{
		new Float:ndmg = (shotDistance / 7.5);
		if(ndmg >= 1.0)
			dmg = (dmg / ndmg);
	}
	return dmg;
}

stock bool:BR_WeaponHasPvPDamage(weaponid, Float:clientAmount = 0.0)
{
	return (BR_GetWeaponDamage(weaponid, 0.0, clientAmount) > 0.0);
}

stock bool:BR_IsDamageDuplicate(victimid, weaponid)
{
	new tick = GetTickCount();
	if(g_BRDamageLastWeapon[victimid] == weaponid
		&& (tick - g_BRDamageLastTick[victimid]) < BR_DMG_DEDUP_MS)
		return true;

	g_BRDamageLastTick[victimid] = tick;
	g_BRDamageLastWeapon[victimid] = weaponid;
	return false;
}

stock BR_ResetDamageDedup(playerid)
{
	g_BRDamageLastTick[playerid] = 0;
	g_BRDamageLastWeapon[playerid] = -1;
	return 1;
}

// Единая точка PvP-урона: кулак, нож, дробовик, снайперка, AK, кастом BR и т.д.
stock BR_ProcessPvPHit(victimid, attackerid, weaponid, Float:shotDistance = 0.0, Float:clientAmount = 0.0)
{
	if(victimid == INVALID_PLAYER_ID || attackerid == INVALID_PLAYER_ID)
		return 0;
	if(!IsPlayerConnected(victimid) || !IsPlayerConnected(attackerid))
		return 0;
	if(victimid == attackerid)
		return 0;
	if(weaponid < 0 || weaponid > BR_WEAPON_ID_MAX)
		return 0;
	if(g_HospitalDeathPending[victimid])
		return 0;

	new Float:dmg = BR_GetWeaponDamage(weaponid, shotDistance, clientAmount);
	if(dmg <= 0.0)
		return 0;
	if(BR_IsDamageDuplicate(victimid, weaponid))
		return 0;

	Hospital_RecordAttacker(victimid, attackerid);
	return BR_ApplyPvPDamage(victimid, dmg, attackerid);
}

stock Hospital_ResolveKiller(playerid, killerid)
{
	if(killerid != INVALID_PLAYER_ID && killerid != playerid && IsPlayerConnected(killerid))
		return killerid;

	new atk = g_HospitalLastAttacker[playerid];
	if(atk != INVALID_PLAYER_ID && atk != playerid && (gettime() - g_HospitalLastAttackAt[playerid]) <= HOSPITAL_ATTACKER_TIMEOUT_SEC)
	{
		if(IsPlayerConnected(atk))
			return atk;
	}
	return INVALID_PLAYER_ID;
}

stock Hospital_ClearAttacker(playerid)
{
	g_HospitalLastAttacker[playerid] = INVALID_PLAYER_ID;
	g_HospitalLastAttackAt[playerid] = 0;
	g_HospitalLastAttackerName[playerid][0] = EOS;
	return 1;
}

stock Hospital_RestoreAppearance(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	if(g_HospitalDeathPending[playerid])
		return 0;

	new skin = Hospital_GetActiveSkin(playerid);
	if(skin > 0 && GetPlayerSkin(playerid) != skin)
		SetPlayerSkin(playerid, skin);

	Inv_TryApplyWornAccessories(playerid);
	return 1;
}

stock Hospital_CloseInventoryIfOpen(playerid)
{
	if(!GetPVarInt(playerid, "inv_gui_open"))
		return 0;

	new Node:closePkt = JSON_Object();
	JSON_SetInt(closePkt, "c", 1);
	OnPacketIncoming(playerid, 33, closePkt);
	JSON_Cleanup(closePkt);
	DeletePVar(playerid, "inv_gui_open");
	return 1;
}

public Hospital_RestoreAppearanceDelayed(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	return Hospital_RestoreAppearance(playerid);
}

stock Hospital_FadeStop(playerid)
{
	if(g_HospitalFadeTimer[playerid])
	{
		KillTimer(g_HospitalFadeTimer[playerid]);
		g_HospitalFadeTimer[playerid] = 0;
	}
	g_HospitalFadeMode[playerid] = HOSPITAL_FADE_NONE;
	g_HospitalFadeStep[playerid] = 0;

	if(g_HospitalFadePTD[playerid] != PlayerText:INVALID_TEXT_DRAW)
	{
		PlayerTextDrawHide(playerid, g_HospitalFadePTD[playerid]);
		PlayerTextDrawDestroy(playerid, g_HospitalFadePTD[playerid]);
		g_HospitalFadePTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
	}
	return 1;
}

stock Hospital_FadeEnsurePTD(playerid)
{
	if(g_HospitalFadePTD[playerid] != PlayerText:INVALID_TEXT_DRAW)
		return 1;

	g_HospitalFadePTD[playerid] = CreatePlayerTextDraw(playerid, -5.0, -5.0, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, g_HospitalFadePTD[playerid], 650.0, 450.0);
	PlayerTextDrawAlignment(playerid, g_HospitalFadePTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, g_HospitalFadePTD[playerid], 0x000000FF);
	PlayerTextDrawFont(playerid, g_HospitalFadePTD[playerid], 4);
	PlayerTextDrawSetProportional(playerid, g_HospitalFadePTD[playerid], 0);
	return 1;
}

stock Hospital_FadeSetLevel(playerid, level)
{
	if(level < 0) level = 0;
	if(level > HOSPITAL_FADE_STEPS) level = HOSPITAL_FADE_STEPS;

	Hospital_FadeEnsurePTD(playerid);

	new alpha = (level * 255) / HOSPITAL_FADE_STEPS;
	new color = 0x00000000 | (alpha & 0xFF);
	PlayerTextDrawColor(playerid, g_HospitalFadePTD[playerid], color);
	PlayerTextDrawShow(playerid, g_HospitalFadePTD[playerid]);
	return 1;
}

stock Hospital_FadeBegin(playerid, mode)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	Hospital_FadeStop(playerid);
	g_HospitalFadeMode[playerid] = mode;

	if(mode == HOSPITAL_FADE_IN)
		g_HospitalFadeStep[playerid] = 0;
	else if(mode == HOSPITAL_FADE_OUT)
		g_HospitalFadeStep[playerid] = HOSPITAL_FADE_STEPS;

	Hospital_FadeStepTick(playerid);
	return 1;
}

public Hospital_FadeStepTick(playerid)
{
	g_HospitalFadeTimer[playerid] = 0;
	if(!IsPlayerConnected(playerid))
		return 0;

	new mode = g_HospitalFadeMode[playerid];
	if(mode == HOSPITAL_FADE_NONE)
		return 0;

	if(mode == HOSPITAL_FADE_IN)
	{
		g_HospitalFadeStep[playerid]++;
		Hospital_FadeSetLevel(playerid, g_HospitalFadeStep[playerid]);

		if(g_HospitalFadeStep[playerid] >= HOSPITAL_FADE_STEPS)
		{
			if(GetPVarInt(playerid, HOSPITAL_PVAR_TRANSFER_FADE))
			{
				DeletePVar(playerid, HOSPITAL_PVAR_TRANSFER_FADE);
				Hospital_CompleteTransfer(playerid);
				Hospital_FadeBegin(playerid, HOSPITAL_FADE_OUT);
				return 1;
			}
			g_HospitalFadeMode[playerid] = HOSPITAL_FADE_NONE;
			return 1;
		}

		g_HospitalFadeTimer[playerid] = SetTimerEx("Hospital_FadeStepTick", HOSPITAL_FADE_STEP_MS, false, "i", playerid);
		return 1;
	}

	if(mode == HOSPITAL_FADE_OUT)
	{
		g_HospitalFadeStep[playerid]--;
		Hospital_FadeSetLevel(playerid, g_HospitalFadeStep[playerid]);

		if(g_HospitalFadeStep[playerid] <= 0)
		{
			Hospital_FadeStop(playerid);
			return 1;
		}

		g_HospitalFadeTimer[playerid] = SetTimerEx("Hospital_FadeStepTick", HOSPITAL_FADE_STEP_MS, false, "i", playerid);
		return 1;
	}

	return 0;
}

stock Float:Hospital_GetPlayerHP(playerid)
{
	new Float:hp;
	GetPlayerHealth(playerid, hp);
	return hp;
}

stock Hospital_GetBranchVW(branch)
{
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		return 0;
	return g_HospitalBranches[branch][H_VW];
}

stock Hospital_GetDisconnectBranch(playerid)
{
	new branch = g_HospitalPlayerBranch[playerid];
	if(branch < 0)
		branch = g_HospitalDeathBranch[playerid];
	if(branch < 0)
		branch = Hospital_GetBranchByVW(GetPlayerVirtualWorld(playerid));
	if(branch < 0 && Hospital_IsInInteriorZone(playerid))
		branch = Hospital_GetPlayerBranch(playerid);
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = HOSPITAL_BRANCH_ARZAMAS;
	return branch;
}

stock bool:Hospital_IsPlayerInActiveSession(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS)
		return false;
	if(g_HospitalSessionActive[playerid])
		return true;
	if(g_HospitalDeathPending[playerid])
		return true;
	if(GetPVarInt(playerid, HOSPITAL_PVAR_DEATH_RESPAWN))
		return true;
	if(g_HospitalPlayerBranch[playerid] >= 0 && g_HospitalPlayerBranch[playerid] < HOSPITAL_BRANCH_COUNT)
		return true;
	if(g_HospitalOccupiedBed[playerid] != -1)
		return true;
	if(!IsPlayerConnected(playerid))
		return false;
	if(GetPlayerInterior(playerid) == HOSPITAL_INTERIOR_ID)
	{
		if(Hospital_GetBranchByVW(GetPlayerVirtualWorld(playerid)) != -1)
			return true;
		if(Hospital_IsInInteriorZone(playerid))
			return true;
	}
	return false;
}

stock Hospital_MarkSessionUnfinished(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;
	Player[playerid][pHospitalUnfinished] = 1;
	return 1;
}

stock Hospital_SaveDisconnectSession(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;

	new q[256];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `players` SET `player_hp`=%f, `player_armour`=%f, `hospital_unfinished`=1 \
		WHERE `id`=%d LIMIT 1",
		Player[playerid][pHealth], Player[playerid][pArmour],
		Player[playerid][pID]);
	mysql_pquery(db_handle, q);
	return 1;
}

stock bool:Hospital_IsReservedSpawnPos(Float:x, Float:y, Float:z)
{
	if(z > 2499.0 && z < 2502.5)
	{
		if(x > 1465.0 && x < 1490.0 && y > 2487.0 && y < 2512.0)
			return true;
		if(floatabs(x - g_HospitalEnterSpawn[0]) < 6.0
			&& floatabs(y - g_HospitalEnterSpawn[1]) < 6.0)
			return true;
		if(floatabs(x - g_HospitalExitSpawn[0]) < 6.0
			&& floatabs(y - g_HospitalExitSpawn[1]) < 6.0)
			return true;
	}

	for(new branch; branch < HOSPITAL_BRANCH_COUNT; branch++)
	{
		new Float:ox = g_HospitalBranches[branch][H_OUT_X];
		new Float:oy = g_HospitalBranches[branch][H_OUT_Y];
		new Float:oz = g_HospitalBranches[branch][H_OUT_Z];
		if(floatabs(x - ox) < 4.0 && floatabs(y - oy) < 4.0 && floatabs(z - oz) < 4.0)
			return true;
	}
	return false;
}

stock Hospital_SanitizePersistedSpawnPos(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;
	if(!Player[playerid][pLastSpawnValid])
		return 0;
	if(!Hospital_IsReservedSpawnPos(Player[playerid][pLastSpawnX], Player[playerid][pLastSpawnY], Player[playerid][pLastSpawnZ]))
		return 0;
	Player[playerid][pLastSpawnValid] = false;
	return 1;
}

stock Hospital_PickRandomDeathBed()
{
	return random(HOSPITAL_DEATH_BED_COUNT);
}

stock Hospital_PickRandomBranch()
{
	return random(HOSPITAL_BRANCH_COUNT);
}

stock Float:Hospital_GetUnfinishedSessionHP(playerid)
{
	new Float:hp = Player[playerid][pHealth];
	if(hp >= HOSPITAL_EXIT_MIN_HP)
		return HOSPITAL_RESPAWN_HP;
	if(hp < HOSPITAL_RESPAWN_HP)
		return HOSPITAL_RESPAWN_HP;
	return hp;
}

stock Hospital_SaveVitalsSession(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;

	new q[192];
	mysql_format(db_handle, q, sizeof(q),
		"UPDATE `players` SET `player_hp`=%f, `player_armour`=%f, `hospital_unfinished`=1 WHERE `id`=%d LIMIT 1",
		Player[playerid][pHealth], Player[playerid][pArmour], Player[playerid][pID]);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Hospital_FinalizeInteriorSpawn(playerid, branch, bed, Float:hp)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	if(Player[playerid][pID] <= 0)
		return 0;
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = 0;
	if(bed < 0 || bed >= HOSPITAL_DEATH_BED_COUNT)
		bed = 0;

	new spawnSkin = 74;
	if(Player[playerid][pSkin] >= 1 && Player[playerid][pSkin] <= 311)
		spawnSkin = Player[playerid][pSkin];

	new vw = Hospital_GetBranchVW(branch);
	new Float:sx = g_HospitalDeathBeds[bed][HS_X];
	new Float:sy = g_HospitalDeathBeds[bed][HS_Y];
	new Float:sz = g_HospitalDeathBeds[bed][HS_Z];
	new Float:sa = g_HospitalDeathBeds[bed][HS_A];

	HideInteractionWindow(playerid);
	SetPVarInt(playerid, "spawn_resolving", 1);

	SetSpawnInfo(playerid, 0, spawnSkin, sx, sy, sz, sa, 0, 0, 0, 0, 0, 0);
	TogglePlayerSpectating(playerid, false);
	SpawnPlayer(playerid);

	SetPlayerPos(playerid, sx, sy, sz);
	SetPlayerFacingAngle(playerid, sa);
	SetPlayerInterior(playerid, HOSPITAL_INTERIOR_ID);
	SetPlayerVirtualWorld(playerid, vw);
	Streamer_UpdateEx(playerid, sx, sy, sz, vw, HOSPITAL_INTERIOR_ID);

	if(hp < HOSPITAL_RESPAWN_HP)
		hp = HOSPITAL_RESPAWN_HP;
	if(hp > 99.0)
		hp = 99.0;
	SetPlayerHealth(playerid, hp);
	SetPlayerArmour(playerid, 0.0);
	Player[playerid][pHealth] = hp;
	Player[playerid][pArmour] = 0.0;

	Hospital_RestoreAppearance(playerid);
	DeletePVar(playerid, "spawn_resolving");

	SetPVarInt(playerid, HOSPITAL_PVAR_LOGIN_SPAWN_BRANCH, branch);
	SetPVarInt(playerid, HOSPITAL_PVAR_LOGIN_SPAWN_BED, bed);
	SetPVarFloat(playerid, HOSPITAL_PVAR_LOGIN_SPAWN_HP, hp);
	SetTimerEx("Hospital_SyncUnfinishedLoginSpawn", 200, false, "i", playerid);
	SetTimerEx("Hospital_SyncUnfinishedLoginSpawn", 600, false, "i", playerid);
	return 1;
}

public Hospital_SyncUnfinishedLoginSpawn(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	if(Player[playerid][pHospitalUnfinished] != 1)
		return 0;

	new branch = GetPVarInt(playerid, HOSPITAL_PVAR_LOGIN_SPAWN_BRANCH);
	new bed = GetPVarInt(playerid, HOSPITAL_PVAR_LOGIN_SPAWN_BED);
	new Float:hp = GetPVarFloat(playerid, HOSPITAL_PVAR_LOGIN_SPAWN_HP);
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = 0;
	if(bed < 0 || bed >= HOSPITAL_DEATH_BED_COUNT)
		bed = 0;
	if(hp < HOSPITAL_RESPAWN_HP)
		hp = HOSPITAL_RESPAWN_HP;

	new vw = Hospital_GetBranchVW(branch);
	new Float:sx = g_HospitalDeathBeds[bed][HS_X];
	new Float:sy = g_HospitalDeathBeds[bed][HS_Y];
	new Float:sz = g_HospitalDeathBeds[bed][HS_Z];
	new Float:sa = g_HospitalDeathBeds[bed][HS_A];

	SetPlayerInterior(playerid, HOSPITAL_INTERIOR_ID);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerPos(playerid, sx, sy, sz);
	SetPlayerFacingAngle(playerid, sa);
	Streamer_UpdateEx(playerid, sx, sy, sz, vw, HOSPITAL_INTERIOR_ID);
	SetPlayerHealth(playerid, hp);
	SetPlayerArmour(playerid, 0.0);
	Player[playerid][pHealth] = hp;
	Player[playerid][pArmour] = 0.0;
	g_HospitalPlayerBranch[playerid] = branch;
	g_HospitalSessionActive[playerid] = true;
	return 1;
}

stock Hospital_ApplyUnfinishedSessionSpawn(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;

	new branch = Hospital_PickRandomBranch();
	new bed = Hospital_PickRandomDeathBed();
	new Float:hp = Hospital_GetUnfinishedSessionHP(playerid);

	Hospital_ResetPlayer(playerid);

	g_HospitalPlayerBranch[playerid] = branch;
	g_HospitalSessionActive[playerid] = true;
	g_HospitalDeathPending[playerid] = false;

	Hospital_FinalizeInteriorSpawn(playerid, branch, bed, hp);

	SetCameraBehindPlayer(playerid);
	ClearAnimations(playerid);
	Hospital_UnlockWoundCamera(playerid);
	TogglePlayerControllable(playerid, true);
	Hospital_UpdateGreenZone(playerid);
	Hospital_BedProxEnsure(playerid);
	ChiefDoctor_OnEnterHospital(playerid);

	Player[playerid][pHealth] = hp;
	Player[playerid][pArmour] = 0.0;
	SetPlayerHealth(playerid, hp);
	SetPlayerArmour(playerid, 0.0);

	SavePlayerAccount(playerid);

	new msg[128];
	format(msg, sizeof msg,
		"Незавершённое лечение. Вы в больнице г. %s (%d HP). Восстановитесь до 100 HP.",
		g_HospitalCityName[branch], floatround(hp));
	ShowNotification(playerid, 3, 6, 0, 1, msg, "");
	printf("[Hospital] unfinished spawn %s branch=%d bed=%d hp=%.1f int=%d vw=%d",
		Player[playerid][pName], branch, bed, hp,
		GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	return 1;
}

stock Hospital_ClearSessionUnfinished(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;
	if(Player[playerid][pHospitalUnfinished] == 0)
		return 0;
	Player[playerid][pHospitalUnfinished] = 0;
	return 1;
}

stock Hospital_OnPlayerDisconnect(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;

	Player_SyncVitalsFromGame(playerid);

	if(!Hospital_IsPlayerInActiveSession(playerid))
		return 0;

	Hospital_MarkSessionUnfinished(playerid);
	Hospital_SaveDisconnectSession(playerid);
	printf("[Hospital] unfinished session saved for %s (hp=%.1f, flag=%d)",
		Player[playerid][pName], Player[playerid][pHealth], Player[playerid][pHospitalUnfinished]);
	return 1;
}

stock Hospital_ResolveReconnectSpawn(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;
	if(Player[playerid][pHospitalUnfinished] != 1)
		return 0;
	return Hospital_ApplyUnfinishedSessionSpawn(playerid);
}

stock bool:Hospital_HasUnfinishedSession(playerid)
{
	if(playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		return false;
	if(Player[playerid][pID] <= 0)
		return false;
	return (Player[playerid][pHospitalUnfinished] == 1);
}

stock Hospital_GetCityName(branch, dest[], size)
{
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = HOSPITAL_BRANCH_ARZAMAS;
	format(dest, size, "%s", g_HospitalCityName[branch]);
	return 1;
}

stock Hospital_PickRandomHospitalBranch()
{
	return random(HOSPITAL_BRANCH_COUNT);
}

stock Hospital_SyncWoundCoordsFromPlayer(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	GetPlayerPos(playerid, g_HospitalWoundX[playerid], g_HospitalWoundY[playerid], g_HospitalWoundZ[playerid]);
	GetPlayerFacingAngle(playerid, g_HospitalWoundA[playerid]);
	return 1;
}

stock Hospital_WoundCamHoldStop(playerid)
{
	if(g_HospitalWoundCamTimer[playerid])
	{
		KillTimer(g_HospitalWoundCamTimer[playerid]);
		g_HospitalWoundCamTimer[playerid] = 0;
	}
	return 1;
}

stock Hospital_WoundCamHoldStart(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_HospitalDeathPending[playerid])
		return 0;
	Hospital_WoundCamHoldStop(playerid);
	g_HospitalWoundCamTimer[playerid] = SetTimerEx(
		"Hospital_WoundCamHoldTick",
		HOSPITAL_WOUND_CAM_HOLD_MS,
		true,
		"i",
		playerid
	);
	return 1;
}

public Hospital_WoundCamHoldTick(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_HospitalDeathPending[playerid])
	{
		Hospital_WoundCamHoldStop(playerid);
		return 0;
	}
	if(!GetPVarInt(playerid, HOSPITAL_PVAR_WOUND_CAM))
		return 0;

	new Float:sx = g_HospitalWoundX[playerid];
	new Float:sy = g_HospitalWoundY[playerid];
	new Float:sz = g_HospitalWoundZ[playerid];
	new Float:sa = g_HospitalWoundA[playerid];
	new Float:dist = 2.15;

	SetPlayerCameraPos(playerid,
		sx + (dist * floatsin(-sa, degrees)),
		sy + (dist * floatcos(-sa, degrees)),
		sz + 0.55);
	SetPlayerCameraLookAt(playerid, sx, sy, sz + 0.15);
	return 1;
}

stock Hospital_LockWoundCamera(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	if(g_HospitalDeathPending[playerid])
		Hospital_SyncWoundCoordsFromPlayer(playerid);

	new Float:sx = g_HospitalWoundX[playerid];
	new Float:sy = g_HospitalWoundY[playerid];
	new Float:sz = g_HospitalWoundZ[playerid];
	new Float:sa = g_HospitalWoundA[playerid];

	new Float:dist = 2.15;
	SetPlayerCameraPos(playerid,
		sx + (dist * floatsin(-sa, degrees)),
		sy + (dist * floatcos(-sa, degrees)),
		sz + 0.55);
	SetPlayerCameraLookAt(playerid, sx, sy, sz + 0.15);
	SetPVarInt(playerid, HOSPITAL_PVAR_WOUND_CAM, 1);
	Hospital_WoundCamHoldStart(playerid);
	return 1;
}

stock Hospital_UnlockWoundCamera(playerid)
{
	Hospital_WoundCamHoldStop(playerid);
	if(!GetPVarInt(playerid, HOSPITAL_PVAR_WOUND_CAM))
		return 0;

	DeletePVar(playerid, HOSPITAL_PVAR_WOUND_CAM);
	SetCameraBehindPlayer(playerid);
	return 1;
}

stock Hospital_ApplyWoundLieAnim(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	if(!g_HospitalDeathPending[playerid])
		return 0;

	TogglePlayerControllable(playerid, false);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ApplyAnimation(playerid, HOSPITAL_WOUND_ANIM_LIB, HOSPITAL_WOUND_ANIM_NAME,
		4.1, 1, 1, 1, 1, -1, 1);
	g_HospitalWoundLastAnimMs[playerid] = GetTickCount();
	return 1;
}

stock Hospital_ApplyWoundLieAnimAlt(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_HospitalDeathPending[playerid])
		return 0;

	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid, HOSPITAL_WOUND_ANIM_ALT_LIB, HOSPITAL_WOUND_ANIM_ALT_NAME,
		4.1, 1, 1, 1, 1, -1, 1);
	g_HospitalWoundLastAnimMs[playerid] = GetTickCount();
	return 1;
}

public Hospital_WoundAnimApply(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_HospitalDeathPending[playerid])
		return 0;

	Hospital_ApplyWoundLieAnim(playerid);
	if(GetPlayerAnimationIndex(playerid) == 0)
		Hospital_ApplyWoundLieAnimAlt(playerid);
	return 1;
}

stock Hospital_WoundLieBootstrap(playerid)
{
	#pragma unused playerid
	// Анимация ранения должна ставиться один раз и держаться без постоянного re-apply.
	return 1;
}

stock Hospital_WoundLieStop(playerid)
{
	if(g_HospitalWoundLieTimer[playerid])
	{
		KillTimer(g_HospitalWoundLieTimer[playerid]);
		g_HospitalWoundLieTimer[playerid] = 0;
	}
	g_HospitalWoundLieUntil[playerid] = 0;
	g_HospitalWoundLastAnimMs[playerid] = 0;
	return 1;
}

stock Hospital_WoundLieStart(playerid)
{
	Hospital_WoundLieStop(playerid);
	g_HospitalWoundLieUntil[playerid] = g_HospitalWoundAutoAt[playerid];

	Hospital_WoundAnimApply(playerid);
	Hospital_WoundLieBootstrap(playerid);
	g_HospitalWoundLieTimer[playerid] = SetTimerEx(
		"Hospital_WoundLieTick",
		HOSPITAL_WOUND_LIE_TICK_MS,
		true,
		"i",
		playerid
	);
	return 1;
}

public Hospital_WoundLieTick(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_HospitalDeathPending[playerid])
	{
		Hospital_WoundLieStop(playerid);
		return 0;
	}

	TogglePlayerControllable(playerid, false);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	// Жёстко удерживаем игрока на координатах ранения 5 минут.
	SetPlayerPos(playerid,
		g_HospitalWoundX[playerid],
		g_HospitalWoundY[playerid],
		g_HospitalWoundZ[playerid]);
	SetPlayerFacingAngle(playerid, g_HospitalWoundA[playerid]);

	if(GetPVarInt(playerid, HOSPITAL_PVAR_WOUND_CAM))
		Hospital_LockWoundCamera(playerid);

	// Не спамим анимацию: переустанавливаем только если она реально слетела.
	new animIdx = GetPlayerAnimationIndex(playerid);
	new now = GetTickCount();
	if(animIdx == 0 && (now - g_HospitalWoundLastAnimMs[playerid]) >= HOSPITAL_WOUND_ANIM_REAPPLY_MS)
	{
		Hospital_ApplyWoundLieAnim(playerid);
		if(GetPlayerAnimationIndex(playerid) == 0)
			Hospital_ApplyWoundLieAnimAlt(playerid);
	}
	return 1;
}

stock Hospital_WoundEnterProneState(playerid, killerid = INVALID_PLAYER_ID)
{
	if(!IsPlayerConnected(playerid) || !g_HospitalDeathPending[playerid])
		return 0;

	TogglePlayerSpectating(playerid, false);
	Hospital_ApplyDeathPosition(playerid);

	new skin = Hospital_GetActiveSkin(playerid);
	if(skin > 0 && GetPlayerSkin(playerid) != skin)
		SetPlayerSkin(playerid, skin);

	SetPlayerHealth(playerid, HOSPITAL_RESPAWN_HP);
	SetPlayerArmour(playerid, 0.0);
	if(Player[playerid][pID] > 0)
	{
		Player[playerid][pHealth] = HOSPITAL_RESPAWN_HP;
		Player[playerid][pArmour] = 0.0;
	}

	Hospital_SyncWoundCoordsFromPlayer(playerid);
	Hospital_LockWoundCamera(playerid);
	new showKiller = killerid;
	if(showKiller == INVALID_PLAYER_ID)
		showKiller = g_HospitalWoundKiller[playerid];
	Hospital_Wound_ShowGUI(playerid, showKiller);
	Hospital_WoundLieStart(playerid);
	return 1;
}

stock bool:Hospital_IsPhysInGreenZone(playerid)
{
	if(GetPlayerInterior(playerid) != HOSPITAL_INTERIOR_ID)
		return false;
	if(Hospital_GetBranchByVW(GetPlayerVirtualWorld(playerid)) < 0)
		return false;
	return (IsPlayerInRangeOfPoint(playerid, HOSPITAL_GREEN_ZONE_RADIUS,
		g_HospitalInteriorCenter[0], g_HospitalInteriorCenter[1], g_HospitalInteriorCenter[2]) != 0);
}

stock bool:Hospital_PlayerInGreenZone(playerid)
{
	return (Hospital_IsPhysInGreenZone(playerid) || GetPVarInt(playerid, HOSPITAL_PVAR_GREEN_ZONE) == 1);
}

stock Hospital_WarnGreenZoneAttack(playerid)
{
	SendClientMessage(playerid, 0xFF5533FF,
		"{FFCD00}[Больница] {FFFFFF}В зелёной зоне удары и стрельба запрещены.");
	return 1;
}

stock Hospital_LeaveGreenZone(playerid)
{
	if(GetPVarInt(playerid, HOSPITAL_PVAR_GREEN_ZONE) != 1)
		return 0;
	DeletePVar(playerid, HOSPITAL_PVAR_GREEN_ZONE);
	HideZona(playerid);
	MinerJob_SetClientCombatLock(playerid, false);
	return 1;
}

stock Hospital_EnterGreenZone(playerid)
{
	if(!Hospital_IsPhysInGreenZone(playerid))
		return 0;
	if(GetPVarInt(playerid, HOSPITAL_PVAR_GREEN_ZONE) == 1)
		return 0;
	SetPVarInt(playerid, HOSPITAL_PVAR_GREEN_ZONE, 1);
	ShowZona(playerid);
	MinerJob_SetClientCombatLock(playerid, true);
	return 1;
}

stock Hospital_UpdateGreenZone(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	if(Hospital_IsPhysInGreenZone(playerid))
	{
		if(GetPVarInt(playerid, HOSPITAL_PVAR_GREEN_ZONE) != 1)
			Hospital_EnterGreenZone(playerid);
		return 1;
	}
	if(GetPVarInt(playerid, HOSPITAL_PVAR_GREEN_ZONE) == 1)
		Hospital_LeaveGreenZone(playerid);
	return 0;
}

stock Hospital_GetGreenZoneByArea(STREAMER_TAG_AREA:areaid, &branch)
{
	branch = -1;
	for(new b; b < HOSPITAL_BRANCH_COUNT; b++)
	{
		if(_:areaid == _:gHospitalGreenArea[b])
		{
			branch = b;
			return 1;
		}
	}
	return 0;
}

stock Hospital_OnEnterArea(playerid, STREAMER_TAG_AREA:areaid)
{
	new branch;
	if(!Hospital_GetGreenZoneByArea(areaid, branch))
		return 0;
	Hospital_EnterGreenZone(playerid);
	return 1;
}

stock Hospital_OnLeaveArea(playerid, STREAMER_TAG_AREA:areaid)
{
	new branch;
	if(!Hospital_GetGreenZoneByArea(areaid, branch))
		return 0;
	Hospital_LeaveGreenZone(playerid);
	return 1;
}

stock Hospital_OnTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	#pragma unused amount, weaponid, bodypart
	if(issuerid != INVALID_PLAYER_ID && IsPlayerConnected(issuerid) && issuerid != playerid)
	{
		if(!Hospital_PlayerInGreenZone(playerid))
			Hospital_RecordAttacker(playerid, issuerid);
	}
	if(!Hospital_PlayerInGreenZone(playerid))
		return 1;
	if(issuerid != INVALID_PLAYER_ID && IsPlayerConnected(issuerid))
	{
		Hospital_WarnGreenZoneAttack(issuerid);
		return 0;
	}
	return 1;
}

stock Hospital_OnGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	#pragma unused amount, weaponid, bodypart
	if(Hospital_PlayerInGreenZone(playerid))
	{
		Hospital_WarnGreenZoneAttack(playerid);
		return 0;
	}
	if(damagedid != INVALID_PLAYER_ID && Hospital_PlayerInGreenZone(damagedid))
	{
		Hospital_WarnGreenZoneAttack(playerid);
		return 0;
	}
	if(damagedid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID && IsPlayerConnected(damagedid) && IsPlayerConnected(playerid))
		Hospital_RecordAttacker(damagedid, playerid);
	return 1;
}

stock Hospital_OnWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	#pragma unused fX, fY, fZ
	if(Hospital_PlayerInGreenZone(playerid))
	{
		Hospital_WarnGreenZoneAttack(playerid);
		return 0;
	}
	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID && Hospital_PlayerInGreenZone(hitid))
	{
		Hospital_WarnGreenZoneAttack(playerid);
		return 0;
	}
	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID
		&& IsPlayerConnected(hitid) && playerid != hitid)
	{
		new Float:tx, Float:ty, Float:tz, Float:dist = 0.0;
		GetPlayerPos(hitid, tx, ty, tz);
		dist = GetPlayerDistanceFromPoint(playerid, tx, ty, tz);

		if(BR_WeaponHasPvPDamage(weaponid))
		{
			BR_ProcessPvPHit(hitid, playerid, weaponid, dist, 0.0);
			return 0;
		}
	}
	return 1;
}

stock Hospital_GetBranchByVW(vw)
{
	for(new b; b < HOSPITAL_BRANCH_COUNT; b++)
	{
		if(vw == Hospital_GetBranchVW(b))
			return b;
	}
	return -1;
}

stock bool:Hospital_IsAtInteriorCoords(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, HOSPITAL_INTERIOR_RADIUS,
		g_HospitalEnterSpawn[0], g_HospitalEnterSpawn[1], g_HospitalEnterSpawn[2]))
		return true;

	for(new i; i < HOSPITAL_DEATH_BED_COUNT; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 12.0,
			g_HospitalDeathBeds[i][HS_X], g_HospitalDeathBeds[i][HS_Y], g_HospitalDeathBeds[i][HS_Z]))
			return true;
	}
	for(new i; i < HOSPITAL_BED_COUNT; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 12.0,
			g_HospitalBeds[i][HS_X], g_HospitalBeds[i][HS_Y], g_HospitalBeds[i][HS_Z]))
			return true;
	}
	return false;
}

stock bool:Hospital_IsInInteriorZone(playerid)
{
	if(GetPlayerInterior(playerid) != HOSPITAL_INTERIOR_ID)
		return false;
	return Hospital_IsAtInteriorCoords(playerid);
}

stock Hospital_GetPlayerBranch(playerid)
{
	if(!IsPlayerConnected(playerid))
		return -1;
	if(!Hospital_IsInInteriorZone(playerid))
		return -1;

	new vw = GetPlayerVirtualWorld(playerid);
	return Hospital_GetBranchByVW(vw);
}

stock bool:Hospital_IsPlayerInside(playerid)
{
	return (Hospital_GetPlayerBranch(playerid) != -1);
}

stock bool:Hospital_CanLeave(playerid)
{
	return ChiefDoctor_CanLeaveHospital(playerid);
}

stock bool:Hospital_IsNearExitDoor(playerid)
{
	if(GetPlayerInterior(playerid) != HOSPITAL_INTERIOR_ID)
		return false;
	if(Hospital_GetPlayerBranch(playerid) < 0)
		return false;
	return (IsPlayerInRangeOfPoint(playerid, HOSPITAL_EXIT_USE_RADIUS,
		g_HospitalExitSpawn[0], g_HospitalExitSpawn[1], g_HospitalExitSpawn[2]) != 0);
}

stock Hospital_HideAllBedLabelsForPlayer(playerid, branch = -1)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
	{
		for(new b; b < HOSPITAL_BRANCH_COUNT; b++)
			Hospital_HideAllBedLabelsForPlayer(playerid, b);
		return 1;
	}

	for(new bed; bed < HOSPITAL_BED_COUNT; bed++)
	{
		if(gHospitalBedLabel[bed][branch] == STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID)
			continue;
		Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, gHospitalBedLabel[bed][branch], 0);
	}
	return 1;
}

stock Hospital_ClearNearBedLabels(playerid, branch)
{
	return Hospital_HideAllBedLabelsForPlayer(playerid, branch);
}

stock Hospital_RefreshInteriorInteract(playerid)
{
	if(!IsPlayerConnected(playerid) || Player[playerid][pID] <= 0)
		return 0;

	if(!Hospital_IsPlayerInside(playerid))
	{
		HideInteractionWindow(playerid);
		DeletePVar(playerid, HOSPITAL_PVAR_NEAR_EXIT);
		return 0;
	}

	if(GetPVarInt(playerid, HCD_PVAR_GUI_OPEN) == 1)
		return 0;

	new show = 0;

	if(ChiefDoctor_IsNearNpc(playerid))
		show = 1;

	DeletePVar(playerid, HOSPITAL_PVAR_NEAR_EXIT);

	if(!show)
	{
		new bed = g_HospitalNearBed[playerid];
		if(bed < 0)
			bed = Hospital_FindNearBed(playerid);

		if(bed != -1 && Hospital_GetPlayerHP(playerid) < HOSPITAL_EXIT_MIN_HP)
		{
			if(g_HospitalBedOccupant[bed] == -1 || g_HospitalBedOccupant[bed] == playerid
				|| g_HospitalOccupiedBed[playerid] == bed)
				show = 1;
		}
	}

	if(show)
		ToggleInteractionWindow(playerid, true);
	else
		HideInteractionWindow(playerid);
	return 1;
}

stock Hospital_UpdateBedLabel(bedid)
{
	if(bedid < 0 || bedid >= HOSPITAL_BED_COUNT)
		return 0;

	new text[320];
	new occupant = g_HospitalBedOccupant[bedid];

	if(occupant != -1 && IsPlayerConnected(occupant))
	{
		format(text, sizeof text,
			HOSPITAL_CLR_TITLE "« Занятая больничная койка »\n"\
			HOSPITAL_CLR_LINE "|" HOSPITAL_CLR_HINT " Номер койки: " HOSPITAL_CLR_VALUE "%d\n"\
			HOSPITAL_CLR_LINE "|" HOSPITAL_CLR_HINT " Пациент: " HOSPITAL_CLR_VALUE "%s\n"\
			HOSPITAL_CLR_HINT "Подойдите ближе для взаимодействия\n"\
			HOSPITAL_CLR_HINT "с больничной койкой",
			bedid + 1, Player[occupant][pName]);
	}
	else
	{
		format(text, sizeof text,
			HOSPITAL_CLR_TITLE "« Свободная больничная койка »\n"\
			HOSPITAL_CLR_LINE "|" HOSPITAL_CLR_HINT " Номер койки: " HOSPITAL_CLR_VALUE "%d\n"\
			HOSPITAL_CLR_LINE "|" HOSPITAL_CLR_HINT " Пациент: " HOSPITAL_CLR_ABSENT "отсутствует\n"\
			HOSPITAL_CLR_HINT "Подойдите ближе для взаимодействия\n"\
			HOSPITAL_CLR_HINT "с больничной койкой",
			bedid + 1);
	}

	for(new branch; branch < HOSPITAL_BRANCH_COUNT; branch++)
	{
		if(gHospitalBedLabel[bedid][branch] != STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID)
			UpdateDynamic3DTextLabelText(gHospitalBedLabel[bedid][branch], 0xFFCD00FF, text);
	}
	return 1;
}

stock Hospital_ClearPlayerBed(playerid)
{
	new bedid = g_HospitalOccupiedBed[playerid];
	if(bedid < 0 || bedid >= HOSPITAL_BED_COUNT)
		return 0;

	if(g_HospitalBedOccupant[bedid] == playerid)
	{
		g_HospitalBedOccupant[bedid] = -1;
		Hospital_UpdateBedLabel(bedid);
	}
	g_HospitalOccupiedBed[playerid] = -1;
	return 1;
}

stock Hospital_BedProxStop(playerid)
{
	if(g_HospitalBedProxTimer[playerid] != -1)
	{
		KillTimer(g_HospitalBedProxTimer[playerid]);
		g_HospitalBedProxTimer[playerid] = -1;
	}

	new branch = Hospital_GetPlayerBranch(playerid);
	Hospital_ClearNearBedLabels(playerid, branch);
	g_HospitalNearBed[playerid] = -1;
	return 1;
}

stock Hospital_FindNearBed(playerid)
{
	if(GetPlayerInterior(playerid) != HOSPITAL_INTERIOR_ID)
		return -1;

	new branch = Hospital_GetPlayerBranch(playerid);
	if(branch < 0)
		return -1;

	for(new bed; bed < HOSPITAL_BED_COUNT; bed++)
	{
		if(!IsPlayerInRangeOfPoint(playerid, HOSPITAL_BED_USE_RADIUS,
			g_HospitalBeds[bed][HS_X], g_HospitalBeds[bed][HS_Y], g_HospitalBeds[bed][HS_Z]))
			continue;
		return bed;
	}
	return -1;
}

stock Hospital_ShowBedInteract(playerid, bedid)
{
	if(bedid < 0 || bedid >= HOSPITAL_BED_COUNT)
		return 0;
	if(Player[playerid][pID] <= 0)
		return 0;

	if(g_HospitalBedOccupant[bedid] != -1 && g_HospitalBedOccupant[bedid] != playerid)
		return 0;

	if(g_HospitalOccupiedBed[playerid] != -1 && g_HospitalOccupiedBed[playerid] != bedid)
		return 0;

	if(Hospital_GetPlayerHP(playerid) >= HOSPITAL_EXIT_MIN_HP)
		return 0;

	g_HospitalNearBed[playerid] = bedid;
	return 1;
}

public Hospital_BedProxTick(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		Hospital_BedProxStop(playerid);
		return 0;
	}
	if(Player[playerid][pID] <= 0 || !Hospital_IsPlayerInside(playerid))
	{
		Hospital_BedProxStop(playerid);
		return 0;
	}

	new branch = Hospital_GetPlayerBranch(playerid);
	if(branch == -1)
	{
		Hospital_BedProxStop(playerid);
		return 0;
	}

	new bed = Hospital_FindNearBed(playerid);
	if(bed == -1)
	{
		if(g_HospitalNearBed[playerid] != -1)
		{
			Hospital_ClearNearBedLabels(playerid, branch);
			g_HospitalNearBed[playerid] = -1;
		}
		Hospital_RefreshInteriorInteract(playerid);
		return 0;
	}

	new oldBed = g_HospitalNearBed[playerid];
	if(oldBed != bed)
	{
		Hospital_ClearNearBedLabels(playerid, branch);
		if(gHospitalBedLabel[bed][branch] != STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID)
			Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, gHospitalBedLabel[bed][branch], 1);
		g_HospitalNearBed[playerid] = bed;
	}

	if(g_HospitalBedOccupant[bed] == -1 || g_HospitalBedOccupant[bed] == playerid || g_HospitalOccupiedBed[playerid] == bed)
		Hospital_ShowBedInteract(playerid, bed);

	Hospital_RefreshInteriorInteract(playerid);
	return 1;
}

stock Hospital_BedProxEnsure(playerid)
{
	Hospital_HideAllBedLabelsForPlayer(playerid);
	if(g_HospitalBedProxTimer[playerid] != -1)
		return 1;
	g_HospitalBedProxTimer[playerid] = SetTimerEx("Hospital_BedProxTick", HOSPITAL_BED_PROX_MS, true, "i", playerid);
	return 1;
}

stock Hospital_TryOccupyBed(playerid, bedid)
{
	if(bedid < 0 || bedid >= HOSPITAL_BED_COUNT)
		return 0;
	if(!Hospital_IsPlayerInside(playerid))
		return 0;
	if(!IsPlayerInRangeOfPoint(playerid, HOSPITAL_BED_USE_RADIUS + 0.5,
		g_HospitalBeds[bedid][HS_X], g_HospitalBeds[bedid][HS_Y], g_HospitalBeds[bedid][HS_Z]))
		return 0;

	if(g_HospitalOccupiedBed[playerid] != -1)
	{
		ShowNotification(playerid, 2, 4, 0, 1, "Вы уже на койке", "");
		return 0;
	}
	if(g_HospitalBedOccupant[bedid] != -1)
	{
		ShowNotification(playerid, 2, 4, 0, 1, "Эта койка занята", "");
		return 0;
	}
	if(Hospital_GetPlayerHP(playerid) >= HOSPITAL_EXIT_MIN_HP)
	{
		ShowNotification(playerid, 2, 5, 0, 1, "Вы не нуждаетесь в лечении", "");
		return 0;
	}

	g_HospitalBedOccupant[bedid] = playerid;
	g_HospitalOccupiedBed[playerid] = bedid;
	g_HospitalSessionActive[playerid] = true;
	Hospital_UpdateBedLabel(bedid);

	SetPlayerPos(playerid,
		g_HospitalBeds[bedid][HS_X], g_HospitalBeds[bedid][HS_Y], g_HospitalBeds[bedid][HS_Z]);
	SetPlayerFacingAngle(playerid, g_HospitalBeds[bedid][HS_A]);
	ApplyAnimation(playerid, HOSPITAL_WOUND_ANIM_LIB, HOSPITAL_WOUND_ANIM_NAME, 4.1, 1, 1, 1, 1, 0, 1);

	new msg[96];
	format(msg, sizeof msg, "Койка №%d — идёт лечение (+%.0f HP)", bedid + 1, HOSPITAL_HEAL_AMOUNT);
	ShowNotification(playerid, 3, 5, 0, 1, msg, "");
	return 1;
}

stock Hospital_TryInteractKey(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;

	if(ChiefDoctor_TryInteract(playerid))
		return 1;

	new bed = g_HospitalNearBed[playerid];
	if(bed < 0)
		bed = Hospital_FindNearBed(playerid);
	if(bed < 0)
		return 0;

	HideInteractionWindow(playerid);
	return Hospital_TryOccupyBed(playerid, bed);
}

stock Hospital_ResetPlayer(playerid)
{
	if(g_HospitalDeathPending[playerid])
		Hospital_Wound_CloseGUI(playerid);

	ChiefDoctor_ResetPlayer(playerid);
	g_HospitalFadePTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
	Hospital_FadeStop(playerid);
	Hospital_WoundLieStop(playerid);
	Hospital_WoundCamHoldStop(playerid);
	Hospital_LeaveGreenZone(playerid);
	DeletePVar(playerid, HOSPITAL_PVAR_TRANSFER_FADE);
	DeletePVar(playerid, HOSPITAL_PVAR_WOUND_CAM);
	DeletePVar(playerid, HOSPITAL_PVAR_NEAR_EXIT);

	if(g_HospitalDeathTimer[playerid])
	{
		KillTimer(g_HospitalDeathTimer[playerid]);
		g_HospitalDeathTimer[playerid] = 0;
	}
	if(g_HospitalWoundAutoTimer[playerid])
	{
		KillTimer(g_HospitalWoundAutoTimer[playerid]);
		g_HospitalWoundAutoTimer[playerid] = 0;
	}
	Hospital_ClearPlayerBed(playerid);
	Hospital_BedProxStop(playerid);
	ClearAnimations(playerid);
	Hospital_UnlockWoundCamera(playerid);
	TogglePlayerControllable(playerid, true);

	g_HospitalSessionActive[playerid] = false;
	g_HospitalDeathPending[playerid] = false;
	g_HospitalDeathBranch[playerid] = -1;
	g_HospitalPlayerBranch[playerid] = -1;
	g_HospitalLastEnter[playerid] = 0;
	g_HospitalLastExit[playerid] = 0;
	DeletePVar(playerid, HOSPITAL_PVAR_DEATH_RESPAWN);

	g_HospitalWoundStart[playerid] = 0;
	g_HospitalWoundAutoAt[playerid] = 0;
	g_HospitalWoundInterior[playerid] = 0;
	g_HospitalWoundVW[playerid] = 0;
	g_HospitalWoundX[playerid] = 0.0;
	g_HospitalWoundY[playerid] = 0.0;
	g_HospitalWoundZ[playerid] = 0.0;
	g_HospitalWoundA[playerid] = 0.0;
	g_HospitalWoundSkin[playerid] = 0;
	g_HospitalWoundKiller[playerid] = INVALID_PLAYER_ID;
	Hospital_ClearAttacker(playerid);
	g_HospitalTransferArrival[playerid] = 0;

	if(Hospital_IsInInteriorZone(playerid))
		SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

stock Hospital_ApplyDeathPosition(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new interior = g_HospitalWoundInterior[playerid];
	new vw = g_HospitalWoundVW[playerid];
	new Float:sx = g_HospitalWoundX[playerid];
	new Float:sy = g_HospitalWoundY[playerid];
	new Float:sz = g_HospitalWoundZ[playerid];
	new Float:sa = g_HospitalWoundA[playerid];

	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerPos(playerid, sx, sy, sz);
	SetPlayerFacingAngle(playerid, sa);
	Streamer_UpdateEx(playerid, sx, sy, sz, vw, interior);

	if(!g_HospitalDeathPending[playerid])
	{
		if(GetPVarInt(playerid, HOSPITAL_PVAR_WOUND_CAM))
			Hospital_LockWoundCamera(playerid);
		else
			SetCameraBehindPlayer(playerid);
	}

	Hospital_BedProxStop(playerid);
	return 1;
}

stock Hospital_Wound_ShowGUI(playerid, killerid)
{
	new killer_name[MAX_PLAYER_NAME];
	killer_name[0] = EOS;
	new show_id = -1;

	if(killerid != INVALID_PLAYER_ID && killerid != playerid)
	{
		if(IsPlayerConnected(killerid))
		{
			format(killer_name, sizeof killer_name, "%s", Player[killerid][pName]);
			show_id = killerid;
		}
		else if(g_HospitalLastAttackerName[playerid][0])
		{
			format(killer_name, sizeof killer_name, "%s", g_HospitalLastAttackerName[playerid]);
			show_id = killerid;
		}
	}

	if(killer_name[0] == EOS && g_HospitalLastAttackerName[playerid][0]
		&& (gettime() - g_HospitalLastAttackAt[playerid]) <= HOSPITAL_ATTACKER_TIMEOUT_SEC)
	{
		format(killer_name, sizeof killer_name, "%s", g_HospitalLastAttackerName[playerid]);
		show_id = g_HospitalLastAttacker[playerid];
	}

	if(killer_name[0] == EOS)
		format(killer_name, sizeof killer_name, "Неизвестно");

	new Node:json = JSON_Object();
	JSON_SetString(json, "p", killer_name);
	JSON_SetInt(json, "id", show_id);
	JSON_SetInt(json, "h", 1); // сразу экран ранения + таймер кнопки «в больницу» (15 сек)
	ShowPlayerGUI(playerid, HOSPITAL_WOUND_GUI_ID, json);
	JSON_Cleanup(json);
	return 1;
}

stock Hospital_OnPlayerDeath(playerid, killerid = INVALID_PLAYER_ID)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_HospitalDeathPending[playerid]) return 1;
	if(!Hospital_PlayerCanWound(playerid)) return 0;

	killerid = Hospital_ResolveKiller(playerid, killerid);

	Hospital_ClearPlayerBed(playerid);
	Hospital_FadeBegin(playerid, HOSPITAL_FADE_IN);

	Hospital_SaveSkinAtDeath(playerid);

	// Сохраняем позицию смерти для «ранен/лежит».
	GetPlayerPos(playerid, g_HospitalWoundX[playerid], g_HospitalWoundY[playerid], g_HospitalWoundZ[playerid]);
	GetPlayerFacingAngle(playerid, g_HospitalWoundA[playerid]);
	g_HospitalWoundInterior[playerid] = GetPlayerInterior(playerid);
	g_HospitalWoundVW[playerid] = GetPlayerVirtualWorld(playerid);

	g_HospitalWoundStart[playerid] = gettime();
	g_HospitalWoundAutoAt[playerid] = g_HospitalWoundStart[playerid] + HOSPITAL_WOUND_MIN_PRONE_SEC;
	if(g_HospitalWoundAutoAt[playerid] < g_HospitalWoundStart[playerid] + HOSPITAL_WOUND_LIE_MIN_SEC)
		g_HospitalWoundAutoAt[playerid] = g_HospitalWoundStart[playerid] + HOSPITAL_WOUND_LIE_MIN_SEC;
	g_HospitalWoundLieUntil[playerid] = g_HospitalWoundAutoAt[playerid];

	g_HospitalDeathPending[playerid] = true;
	g_HospitalSessionActive[playerid] = true;
	g_HospitalDeathBranch[playerid] = -1;
	g_HospitalWoundKiller[playerid] = killerid;

	if(g_HospitalDeathTimer[playerid])
		KillTimer(g_HospitalDeathTimer[playerid]);
	g_HospitalDeathTimer[playerid] = SetTimerEx("Hospital_DeathRespawn", HOSPITAL_DEATH_RESPAWN_MS, false, "i", playerid);

	if(g_HospitalWoundAutoTimer[playerid])
		KillTimer(g_HospitalWoundAutoTimer[playerid]);
	g_HospitalWoundAutoTimer[playerid] = SetTimerEx(
		"Hospital_WoundAutoTransfer",
		HOSPITAL_WOUND_MIN_PRONE_SEC * 1000,
		false,
		"i",
		playerid
	);
	return 1;
}

// Смертельный PvP-урон -> экран ранения (HP выставляет BR_ApplyPvPDamage).
stock bool:Hospital_TryWoundFromLethalDamage(playerid, killerid = INVALID_PLAYER_ID)
{
	if(!IsPlayerConnected(playerid))
		return false;
	if(g_HospitalDeathPending[playerid])
		return true;
	if(!Hospital_PlayerCanWound(playerid))
		return false;

	killerid = Hospital_ResolveKiller(playerid, killerid);
	return (Hospital_OnPlayerDeath(playerid, killerid) != 0);
}

// Серверный PvP-урон (BR-клиент). Броня -> HP; при 0 HP — ранение.
stock BR_ApplyPvPDamage(damagedid, Float:amount, killerid = INVALID_PLAYER_ID)
{
	if(damagedid == INVALID_PLAYER_ID || !IsPlayerConnected(damagedid))
		return 0;
	if(amount <= 0.0)
		return 0;
	if(g_HospitalDeathPending[damagedid])
		return 0;

	new Float:hp, Float:arm;
	GetPlayerHealth(damagedid, hp);
	GetPlayerArmour(damagedid, arm);

	new Float:dmg = amount;
	if(arm > 0.0)
	{
		new Float:armLoss = arm;
		if(dmg < armLoss)
			armLoss = dmg;
		arm -= armLoss;
		dmg -= armLoss;
		SetPlayerArmour(damagedid, arm);
	}

	if(dmg > 0.0)
	{
		hp -= dmg;
		if(hp <= 0.0)
		{
			if(Hospital_TryWoundFromLethalDamage(damagedid, killerid))
				hp = HOSPITAL_RESPAWN_HP;
			else
				hp = 0.0;
		}
		SetPlayerHealth(damagedid, hp);
		if(Player[damagedid][pID] > 0)
		{
			Player[damagedid][pHealth] = hp;
			Player[damagedid][pArmour] = arm;
		}
	}
	return 1;
}

public Hospital_DeathRespawn(playerid)
{
	g_HospitalDeathTimer[playerid] = 0;
	if(!IsPlayerConnected(playerid)) return 0;
	if(!g_HospitalDeathPending[playerid]) return 0;
	if(Player[playerid][pID] <= 0) return 0;

	new spawnSkin = Hospital_GetSpawnInfoSkin(playerid);

	new Float:sx = g_HospitalWoundX[playerid];
	new Float:sy = g_HospitalWoundY[playerid];
	new Float:sz = g_HospitalWoundZ[playerid];
	new Float:sa = g_HospitalWoundA[playerid];

	SetPVarInt(playerid, HOSPITAL_PVAR_DEATH_RESPAWN, 1);

	SetSpawnInfo(playerid, 0, spawnSkin, sx, sy, sz, sa, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);

	Hospital_ApplyDeathPosition(playerid);
	SetTimerEx("Hospital_WoundEnterProneDelayed", 120, false, "i", playerid);

	SetTimerEx("Hospital_SyncInterior", 400, false, "i", playerid);
	Hospital_FadeBegin(playerid, HOSPITAL_FADE_OUT);
	return 1;
}

public Hospital_WoundEnterProneDelayed(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_HospitalDeathPending[playerid])
		return 0;
	return Hospital_WoundEnterProneState(playerid, g_HospitalWoundKiller[playerid]);
}

public Hospital_SyncInterior(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!g_HospitalDeathPending[playerid])
		return 0;

	new interior = g_HospitalWoundInterior[playerid];
	new vw = g_HospitalWoundVW[playerid];

	if(GetPlayerInterior(playerid) != interior)
		SetPlayerInterior(playerid, interior);
	if(GetPlayerVirtualWorld(playerid) != vw)
		SetPlayerVirtualWorld(playerid, vw);

	DeletePVar(playerid, HOSPITAL_PVAR_DEATH_RESPAWN);
	return 1;
}

stock Hospital_OnPlayerSpawn(playerid)
{
	if(!GetPVarInt(playerid, HOSPITAL_PVAR_DEATH_RESPAWN))
		return 0;

	DeletePVar(playerid, HOSPITAL_PVAR_DEATH_RESPAWN);

	if(!g_HospitalDeathPending[playerid])
		return 0;

	TogglePlayerControllable(playerid, false);
	Hospital_WoundLieBootstrap(playerid);
	return 1;
}

stock Hospital_Wound_CloseGUI(playerid)
{
	// Клиент GUIWoundSystem закрывается по пакету t=2 (не по "c").
	new Node:json = JSON_Object();
	JSON_SetInt(json, "t", 2);
	OnPacketIncoming(playerid, HOSPITAL_WOUND_GUI_ID, json);
	JSON_Cleanup(json);
	return 1;
}

stock Hospital_Wound_TransferToHospital(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!g_HospitalDeathPending[playerid]) return 0;

	g_HospitalDeathBranch[playerid] = Hospital_PickRandomHospitalBranch();
	g_HospitalTransferArrival[playerid] = random(HOSPITAL_DEATH_BED_COUNT);

	Hospital_WoundLieStop(playerid);
	Hospital_ClearPlayerBed(playerid);
	HideInteractionWindow(playerid);
	ClearAnimations(playerid);
	Hospital_Wound_CloseGUI(playerid);
	Hospital_CloseInventoryIfOpen(playerid);

	TogglePlayerControllable(playerid, false);

	g_HospitalDeathPending[playerid] = false;
	g_HospitalDeathBranch[playerid] = -1;
	g_HospitalDeathBed[playerid] = 0;

	if(g_HospitalWoundAutoTimer[playerid])
	{
		KillTimer(g_HospitalWoundAutoTimer[playerid]);
		g_HospitalWoundAutoTimer[playerid] = 0;
	}

	SetPVarInt(playerid, HOSPITAL_PVAR_TRANSFER_FADE, 1);
	Hospital_FadeBegin(playerid, HOSPITAL_FADE_IN);
	return 1;
}

public Hospital_CompleteTransfer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new idx = g_HospitalTransferArrival[playerid];
	if(idx < 0 || idx >= HOSPITAL_DEATH_BED_COUNT)
		idx = 0;

	new Float:x = g_HospitalDeathBeds[idx][HS_X];
	new Float:y = g_HospitalDeathBeds[idx][HS_Y];
	new Float:z = g_HospitalDeathBeds[idx][HS_Z];
	new Float:a = g_HospitalDeathBeds[idx][HS_A];

	new branch = g_HospitalDeathBranch[playerid];
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = Hospital_PickRandomHospitalBranch();

	new vw = Hospital_GetBranchVW(branch);
	if(vw <= 0) vw = HOSPITAL_VW_LYTKARINO;

	g_HospitalPlayerBranch[playerid] = branch;
	g_HospitalNearBed[playerid] = -1;
	g_HospitalSessionActive[playerid] = true;

	Hospital_UnlockWoundCamera(playerid);
	TogglePlayerSpectating(playerid, false);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	SetPlayerInterior(playerid, HOSPITAL_INTERIOR_ID);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, a);
	Streamer_UpdateEx(playerid, x, y, z, vw, HOSPITAL_INTERIOR_ID);

	SetPlayerHealth(playerid, HOSPITAL_RESPAWN_HP);
	SetPlayerArmour(playerid, 0.0);
	if(Player[playerid][pID] > 0)
	{
		Player[playerid][pHealth] = HOSPITAL_RESPAWN_HP;
		Player[playerid][pArmour] = 0.0;
	}
	ClearAnimations(playerid);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, true);
	Hospital_RestoreAppearance(playerid);
	SetTimerEx("Hospital_RestoreAppearanceDelayed", 400, false, "i", playerid);
	Hospital_BedProxEnsure(playerid);
	Hospital_UpdateGreenZone(playerid);
	ChiefDoctor_OnEnterHospital(playerid);

	new msg[160];
	format(msg, sizeof msg,
		"Вы доставлены в больницу г. %s. Подойдите к свободной койке для лечения",
		g_HospitalCityName[branch]);
	ShowNotification(playerid, 3, 6, 0, 1, msg, "");
	return 1;
}

public Hospital_WoundAutoTransfer(playerid)
{
	g_HospitalWoundAutoTimer[playerid] = 0;
	if(!IsPlayerConnected(playerid)) return 0;
	if(!g_HospitalDeathPending[playerid]) return 0;
	return Hospital_Wound_TransferToHospital(playerid);
}

stock Hospital_Wound_OnWaitHelp(playerid)
{
	if(!g_HospitalDeathPending[playerid]) return 0;

	g_HospitalWoundAutoAt[playerid] += HOSPITAL_WOUND_WAIT_EXTRA_SEC;
	g_HospitalWoundLieUntil[playerid] = g_HospitalWoundAutoAt[playerid];

	if(g_HospitalWoundAutoTimer[playerid])
	{
		KillTimer(g_HospitalWoundAutoTimer[playerid]);
		g_HospitalWoundAutoTimer[playerid] = 0;
	}

	new remainingMs = (g_HospitalWoundAutoAt[playerid] - gettime()) * 1000;
	if(remainingMs < 1000) remainingMs = 1000;

	g_HospitalWoundAutoTimer[playerid] = SetTimerEx(
		"Hospital_WoundAutoTransfer",
		remainingMs,
		false,
		"i",
		playerid
	);

	// Клиент: блокировка кнопок на 30 сек.
	new Node:resp = JSON_Object();
	JSON_SetInt(resp, "t", 1);
	OnPacketIncoming(playerid, HOSPITAL_WOUND_GUI_ID, resp);
	JSON_Cleanup(resp);

	Hospital_WoundLieStart(playerid);
	ShowNotification(playerid, 3, 5, 0, 1,
		"Вы ждёте помощь. Оставайтесь на месте ещё 30 сек.", "");
	return 1;
}

stock Hospital_Wound_OnHospitalButton(playerid)
{
	if(!g_HospitalDeathPending[playerid]) return 0;

	new elapsed = gettime() - g_HospitalWoundStart[playerid];
	if(elapsed < HOSPITAL_WOUND_HOSPITAL_BTN_SEC)
	{
		new msg[96];
		format(msg, sizeof msg,
			"Кнопка «В больницу» будет доступна через %d сек.",
			HOSPITAL_WOUND_HOSPITAL_BTN_SEC - elapsed);
		ShowNotification(playerid, 2, 4, 0, 1, msg, "");
		return 0;
	}

	if(g_HospitalWoundAutoTimer[playerid])
	{
		KillTimer(g_HospitalWoundAutoTimer[playerid]);
		g_HospitalWoundAutoTimer[playerid] = 0;
	}

	return Hospital_Wound_TransferToHospital(playerid);
}

public Hospital_TreatmentTick()
{
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
	{
		if(!IsPlayerConnected(playerid)) continue;
		if(Player[playerid][pID] <= 0) continue;

		ChiefDoctor_TickPlayer(playerid);

		if(Hospital_IsPlayerInside(playerid))
		{
			Hospital_UpdateGreenZone(playerid);
			Hospital_BedProxEnsure(playerid);
		}

		new bedid = g_HospitalOccupiedBed[playerid];
		if(bedid < 0 || bedid >= HOSPITAL_BED_COUNT)
			continue;

		if(!Hospital_IsPlayerInside(playerid))
		{
			Hospital_ClearPlayerBed(playerid);
			ClearAnimations(playerid);
			continue;
		}

		if(!IsPlayerInRangeOfPoint(playerid, HOSPITAL_BED_USE_RADIUS + 1.5,
			g_HospitalBeds[bedid][HS_X], g_HospitalBeds[bedid][HS_Y], g_HospitalBeds[bedid][HS_Z]))
		{
			Hospital_ClearPlayerBed(playerid);
			ClearAnimations(playerid);
			ShowNotification(playerid, 2, 4, 0, 1, "Вы отошли от койки", "");
			continue;
		}

		new Float:hp = Hospital_GetPlayerHP(playerid);
		if(hp >= HOSPITAL_EXIT_MIN_HP)
		{
			SetPlayerHealth(playerid, 100.0);
			Hospital_ClearPlayerBed(playerid);
			ClearAnimations(playerid);
			ShowNotification(playerid, 3, 5, 0, 1, "Лечение завершено! Можно выходить из больницы", "");
			continue;
		}

		new Float:newhp = hp + HOSPITAL_HEAL_AMOUNT;
		if(newhp > 100.0) newhp = 100.0;
		SetPlayerHealth(playerid, newhp);
		if(Player[playerid][pID] > 0)
		{
			Player[playerid][pHealth] = newhp;
			if(Player[playerid][pHospitalUnfinished] == 1 || g_HospitalSessionActive[playerid])
				Hospital_SaveVitalsSession(playerid);
		}

		GameTextForPlayer(playerid, "~g~~h~+2 HP", 800, 4);
		SetPlayerChatBubble(playerid, "+2 HP", 0x33CC33FF, 5.0, 800);
	}
	return 1;
}

stock Hospital_InitBeds()
{
	for(new bed; bed < HOSPITAL_BED_COUNT; bed++)
	{
		for(new branch; branch < HOSPITAL_BRANCH_COUNT; branch++)
		{
			new vw = Hospital_GetBranchVW(branch);

			gHospitalBedLabel[bed][branch] = CreateDynamic3DTextLabel(
				"...",
				0xFFCD00FF,
				g_HospitalBeds[bed][HS_X],
				g_HospitalBeds[bed][HS_Y],
				g_HospitalBeds[bed][HS_Z] + HOSPITAL_BED_LABEL_Z_OFF,
				HOSPITAL_BED_LABEL_SHOW_DIST,
				INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, HOSPITAL_INTERIOR_ID);
		}
		Hospital_UpdateBedLabel(bed);
	}
	return 1;
}

stock Hospital_Init()
{
	Hospital_InitBeds();
	ChiefDoctor_Init();
	SetTimer("Hospital_TreatmentTick", HOSPITAL_HEAL_INTERVAL_MS, true);

	new label[192];

	for(new branch; branch < HOSPITAL_BRANCH_COUNT; branch++)
	{
		new vw = Hospital_GetBranchVW(branch);
		new Float:ox = g_HospitalBranches[branch][H_OUT_X];
		new Float:oy = g_HospitalBranches[branch][H_OUT_Y];
		new Float:oz = g_HospitalBranches[branch][H_OUT_Z];

		gHospitalEnterPickup[branch] = CreateDynamicPickup(HOSPITAL_PICKUP_MODEL, HOSPITAL_PICKUP_TYPE,
			ox, oy, oz, 0, 0);

		format(label, sizeof label,
			HOSPITAL_CLR_TITLE "« Городская больница »\n"\
			HOSPITAL_CLR_HINT "Встаньте на пикап\n"\
			HOSPITAL_CLR_HINT "для входа в здание");
		gHospitalEnterLabel[branch] = CreateDynamic3DTextLabel(label, 0xFFCD00FF,
			ox, oy, oz + 1.0, 22.0,
			INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

		gHospitalExitPickup[branch] = CreateDynamicPickup(HOSPITAL_EXIT_PICKUP_MODEL, HOSPITAL_PICKUP_TYPE,
			g_HospitalExitSpawn[0], g_HospitalExitSpawn[1], g_HospitalExitSpawn[2] - 0.35,
			vw, HOSPITAL_INTERIOR_ID);

		gHospitalExitArrow[branch] = CreateDynamicObject(HOSPITAL_EXIT_ARROW_MODEL,
			g_HospitalExitSpawn[0], g_HospitalExitSpawn[1], g_HospitalExitSpawn[2] - 0.55,
			90.0, 0.0, g_HospitalExitSpawn[3],
			vw, HOSPITAL_INTERIOR_ID, -1, 300.0);

		format(label, sizeof label,
			HOSPITAL_CLR_TITLE "« Городская больница »\n"\
			HOSPITAL_CLR_HINT "Встаньте на пикап\n"\
			HOSPITAL_CLR_HINT "для выхода на улицу");
		gHospitalExitLabel[branch] = CreateDynamic3DTextLabel(label, 0xFFCD00FF,
			g_HospitalExitSpawn[0], g_HospitalExitSpawn[1], g_HospitalExitSpawn[2] + 0.95,
			22.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, HOSPITAL_INTERIOR_ID);

		gHospitalExitSignLabel[branch] = STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID;

		gHospitalGreenArea[branch] = CreateDynamicSphere(
			g_HospitalInteriorCenter[0],
			g_HospitalInteriorCenter[1],
			g_HospitalInteriorCenter[2],
			HOSPITAL_GREEN_ZONE_RADIUS,
			vw, HOSPITAL_INTERIOR_ID);
	}

	#pragma unused gHospitalEnterLabel, gHospitalExitLabel, gHospitalExitSignLabel, gHospitalExitArrow
	return 1;
}

stock Hospital_ApplyExitFullHealth(playerid, bool:notify)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	Player[playerid][pHealth] = 100.0;
	Player[playerid][pArmour] = 0.0;
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0.0);

	if(Player[playerid][pID] > 0)
		SavePlayerAccount(playerid);

	if(notify)
		ShowNotification(playerid, 3, 5, 0, 1, "Вы вышли с полным здоровьем (100 HP)", "");
	return 1;
}

stock Hospital_TeleportInside(playerid, branch)
{
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		return 0;

	new vw = Hospital_GetBranchVW(branch);
	g_HospitalPlayerBranch[playerid] = branch;
	g_HospitalSessionActive[playerid] = true;
	g_HospitalDeathPending[playerid] = false;

	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerInterior(playerid, HOSPITAL_INTERIOR_ID);
	SetPlayerPos(playerid, g_HospitalEnterSpawn[0], g_HospitalEnterSpawn[1], g_HospitalEnterSpawn[2]);
	SetPlayerFacingAngle(playerid, g_HospitalEnterSpawn[3]);
	Streamer_UpdateEx(playerid,
		g_HospitalEnterSpawn[0], g_HospitalEnterSpawn[1], g_HospitalEnterSpawn[2],
		vw, HOSPITAL_INTERIOR_ID);
	SetCameraBehindPlayer(playerid);

	if(Hospital_GetPlayerHP(playerid) < HOSPITAL_EXIT_MIN_HP)
	{
		SetPlayerHealth(playerid, HOSPITAL_RESPAWN_HP);
		SetPlayerArmour(playerid, 0.0);
		if(Player[playerid][pID] > 0)
		{
			Player[playerid][pHealth] = HOSPITAL_RESPAWN_HP;
			Player[playerid][pArmour] = 0.0;
		}
	}

	Hospital_UpdateGreenZone(playerid);
	Hospital_BedProxEnsure(playerid);
	ChiefDoctor_OnEnterHospital(playerid);

	new msg[96];
	format(msg, sizeof msg, "Центральная больница г. %s", g_HospitalCityName[branch]);
	ShowNotification(playerid, 3, 5, 0, 1, msg, "");
	return 1;
}

stock Hospital_TeleportOutside(playerid)
{
	if(!Hospital_CanLeave(playerid))
	{
		new msg[128];
		format(msg, sizeof msg,
			"Восстановите здоровье до 100 HP (сейчас %.0f). Лягте на койку",
			Hospital_GetPlayerHP(playerid));
		ShowNotification(playerid, 2, 5, 0, 1, msg, "");
		return 0;
	}

	new branch = g_HospitalPlayerBranch[playerid];
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = Hospital_GetPlayerBranch(playerid);
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = HOSPITAL_BRANCH_ARZAMAS;

	Hospital_ClearPlayerBed(playerid);
	Hospital_LeaveGreenZone(playerid);
	ClearAnimations(playerid);

	new Float:ox = g_HospitalBranches[branch][H_OUT_X];
	new Float:oy = g_HospitalBranches[branch][H_OUT_Y];
	new Float:oz = g_HospitalBranches[branch][H_OUT_Z];
	new Float:oa = g_HospitalBranches[branch][H_OUT_A];

	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, ox, oy, oz + 0.05);
	SetPlayerFacingAngle(playerid, oa);
	Streamer_UpdateEx(playerid, ox, oy, oz, 0, 0);
	SetCameraBehindPlayer(playerid);
	g_HospitalPlayerBranch[playerid] = -1;
	g_HospitalDeathPending[playerid] = false;
	Hospital_BedProxStop(playerid);
	ChiefDoctor_ProxStop(playerid);
	DeletePVar(playerid, HOSPITAL_PVAR_NEAR_EXIT);
	Player_FixInteriorWorldLeak(playerid);

	if(Hospital_GetPlayerHP(playerid) >= HOSPITAL_EXIT_MIN_HP)
	{
		Hospital_ApplyExitFullHealth(playerid, false);
		Hospital_ClearSessionUnfinished(playerid);
		if(Player[playerid][pID] > 0)
			SavePlayerAccount(playerid);
	}

	new msg[96];
	format(msg, sizeof msg, "Вы вышли из больницы (г. %s)", g_HospitalCityName[branch]);
	ShowNotification(playerid, 3, 5, 0, 1, msg, "");
	return 1;
}

stock Hospital_OnPickup(playerid, STREAMER_TAG_PICKUP:pickupid)
{
	new tick = GetTickCount();

	for(new branch; branch < HOSPITAL_BRANCH_COUNT; branch++)
	{
		if(pickupid == gHospitalEnterPickup[branch])
		{
			if(tick - g_HospitalLastEnter[playerid] < HOSPITAL_PICKUP_CD_MS)
				return 1;
			g_HospitalLastEnter[playerid] = tick;
			return Hospital_TeleportInside(playerid, branch);
		}

		if(pickupid == gHospitalExitPickup[branch])
		{
			if(tick - g_HospitalLastExit[playerid] < HOSPITAL_PICKUP_CD_MS)
				return 1;
			if(!Hospital_CanLeave(playerid))
			{
				new msg[128];
				format(msg, sizeof msg,
					"Выход закрыт: нужно 100 HP (сейчас %.0f). Лечение на койке",
					Hospital_GetPlayerHP(playerid));
				ShowNotification(playerid, 2, 5, 0, 1, msg, "");
				return 1;
			}
			g_HospitalLastExit[playerid] = tick;
			g_HospitalPlayerBranch[playerid] = branch;
			return Hospital_TeleportOutside(playerid);
		}
	}
	return 0;
}
