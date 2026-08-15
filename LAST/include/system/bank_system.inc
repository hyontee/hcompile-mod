// Центральный банк BR: телепорты, /bank, диалоги (не GUI)
#if defined _BR_BANK_SYSTEM_INC_
	#endinput
#endif
#define _BR_BANK_SYSTEM_INC_

forward Player_FixInteriorWorldLeak(playerid);

#define BANK_BRANCH_COUNT           (5)
#define BANK_INTERIOR               (1)
#define BANK_PICKUP_MODEL           (1318)
#define BANK_SERVICE_PICKUP_MODEL   (1274)
#define BANK_PICKUP_TYPE            (23)
#define BANK_SERVICE_POINT_COUNT    (3)
#define BANK_PAYMENT_POINT_COUNT    (2)
#define BANK_ATM_POINT_COUNT        (6)
#define BANK_ATM_MODEL              (2942)
#define NOTIFY_BANK_ATM             (88)
#define BANK_MAX_EXTRA_ACCOUNTS     (4)
#define BANK_ACCOUNT_NAME_LEN       (20)
#define BANK_ACCOUNT_NAME_MIN       (3)
#define BANK_PIN_LEN                (8)
#define BANK_PIN_MIN_LEN            (4)
#define BANK_SUB_MAX_SUM            (10000000)
#define BANK_SUB_TRANSFER_ACC_MAX   (8)
#define BANK_WITHDRAW_FEE_PC        (15) // 1.5%
#define BANK_DEPOSIT_FEE_PC         (10) // 1.0%

#if !defined BANK_PICKUP_CD_MS
	#define BANK_PICKUP_CD_MS       (3000)
#endif
#if !defined BANK_INTERACT_LEAVE_DIST
	#define BANK_INTERACT_LEAVE_DIST (1.0)
#endif
#if !defined BANK_UNLOCK_CHECK_MS
	#define BANK_UNLOCK_CHECK_MS    (350)
#endif
#if !defined BANK_ATM_NOTIFY_SHOW_RADIUS
	#define BANK_ATM_NOTIFY_SHOW_RADIUS   (1.30)
#endif
#if !defined BANK_ATM_NOTIFY_RESET_RADIUS
	#define BANK_ATM_NOTIFY_RESET_RADIUS  (2.35)
#endif
#if !defined BANK_ATM_USE_RADIUS
	#define BANK_ATM_USE_RADIUS     (1.55)
#endif
#if !defined BANK_ATM_PROX_MS
	#define BANK_ATM_PROX_MS        (200)
#endif
#if !defined BANK_ATM_NOTIFY_REPEAT_MS
	#define BANK_ATM_NOTIFY_REPEAT_MS (300)
#endif
#if !defined BANK_GREEN_ZONE_RADIUS
	#define BANK_GREEN_ZONE_RADIUS      (34.0)
#endif
#define BANK_PVAR_GREEN_ZONE            "BankInGreenZone"
#define BANK_PVAR_GZ_WARN_CD            "BankGzWarnCd"
#define BANK_GREEN_ZONE_NAME            "Банк"
#if !defined BANK_ATM_OPEN_CD_MS
	#define BANK_ATM_OPEN_CD_MS     (600)
#endif
#define BANK_ATM_BACK_IGNORE_MAX    (3)
#define BANK_PVAR_ATM_DIALOG_OPEN   "BankAtmDlgOpen"

#if !defined DIALOG_BR_BANK_MAIN
	#define DIALOG_BR_BANK_MAIN             (19520)
	#define DIALOG_BR_BANK_ACCOUNTS         (19521)
	#define DIALOG_BR_BANK_CREATE           (19522)
	#define DIALOG_BR_BANK_PIN              (19523)
	#define DIALOG_BR_BANK_SUB_OPS          (19524)
	#define DIALOG_BR_BANK_SUB_INFO          (19525)
	#define DIALOG_BR_ATM_MAIN              (19526)
	#define DIALOG_BR_ATM_TAKE_SUM          (19527)
	#define DIALOG_BR_ATM_TAKE_OTHER        (19528)
	#define DIALOG_BR_ATM_PUT_SUM           (19529)
	#define DIALOG_BR_ATM_PUT_OTHER         (19530)
	#define DIALOG_BR_ATM_BALANCE           (19531)
	#define DIALOG_BR_ATM_BIZ_TAKE_SUM      (19532)
	#define DIALOG_BR_ATM_BIZ_TAKE_OTHER    (19533)
	#define DIALOG_BR_ATM_BIZ_PUT_SUM       (19534)
	#define DIALOG_BR_ATM_BIZ_PUT_OTHER     (19535)
	#define DIALOG_BR_ATM_PHONE             (19536)
	#define DIALOG_BR_ATM_TRANSFER_1        (19537)
	#define DIALOG_BR_ATM_TRANSFER_2        (19538)
	#define DIALOG_BR_ATM_CHARITY           (19539)
	#define DIALOG_BR_ATM_FINE              (19540)
	#define DIALOG_BR_PAY_RENT_MAIN         (19541)
	#define DIALOG_BR_PAY_RENT_HOUSE        (19550)
	#define DIALOG_BR_PAY_RENT_BIZ          (19551)
	#define DIALOG_BR_CHARITY_TOP           (19542)
	#define DIALOG_BR_BANK_SUB_HISTORY      (19543)
	#define DIALOG_BR_SUB_TAKE              (19544)
	#define DIALOG_BR_SUB_PUT               (19545)
	#define DIALOG_BR_SUB_TRANSFER_1        (19546)
	#define DIALOG_BR_SUB_TRANSFER_2        (19547)
	#define DIALOG_BR_BANK_RENAME           (19548)
	#define DIALOG_BR_BANK_CHANGE_PIN       (19549)
#endif

#define BANK_PVAR_EXTRA_TARGET_ACC    "BankExtraTrgAcc"
#define BANK_PVAR_PENDING_ACC_DLG     "BankPendingAccDlg"
#define BANK_PVAR_ACC_CREATE_ROW      "BankAccCreateRow"
#define BANK_PVAR_NEW_ACC_NAME        "BankNewAccName"
#define BANK_PVAR_LOAD_GEN            "BankLoadGen"
#define BANK_PVAR_ACC_LAST_CNT        "BankAccLastCnt"
#define BANK_DLG_DELAY_MS             (200)
#define BANK_ACC_BACK_IGNORE_MAX      (3)
#define BANK_DEFAULT_PIN              "0000"

#define BANK_CHARITY_TOP_LIMIT          (10)

#define BANK_PVAR_USE_SLOT            "BankUseSlot"
#define BANK_PVAR_TRANSFER_ID         "BankTransferId"
#define BANK_PVAR_ATM_TAKE            "BankAtmTake"
#define BANK_PVAR_ATM_BIZ_TAKE        "BankAtmBizTake"
#define BANK_PVAR_SUB_OP              "BankSubOp"

enum E_BANK_BRANCH
{
	B_NAME[32],
	Float:B_ENTER_X,
	Float:B_ENTER_Y,
	Float:B_ENTER_Z,
	Float:B_ENTER_A,
	Float:B_EXIT_X,
	Float:B_EXIT_Y,
	Float:B_EXIT_Z,
	Float:B_EXIT_A,
	B_INTERIOR_VW
};

enum E_BANK_EXTRA_ACCOUNT
{
	BEA_SQL_ID,
	BEA_BALANCE,
	BEA_NAME[BANK_ACCOUNT_NAME_LEN + 1],
	BEA_PIN[BANK_PIN_LEN + 1]
};

static const Float:BankEnterSpawn[4] =
	{2889.8894, 2484.9462, 1051.0447, 357.6772};

static const Float:BankInteriorExitA[4] =
	{2893.3127, 2481.4147, 1051.0447, 359.0379};

static const Float:BankInteriorExitB[4] =
	{2887.0944, 2481.4191, 1051.0447, 355.2372};

static const Float:BankServicePos[BANK_SERVICE_POINT_COUNT][3] =
{
	{2900.0544, 2509.2009, 1051.0449},
	{2902.5026, 2506.4587, 1051.0449},
	{2905.6074, 2504.4577, 1051.0449}
};

static const Float:BankPaymentPos[BANK_PAYMENT_POINT_COUNT][3] =
{
	{2908.9990, 2503.0212, 1051.0447},
	{2912.8850, 2502.4807, 1051.0447}
};

static const Float:BankInteriorGreenCenter[3] =
	{2893.0, 2497.0, 1051.0};

static const Float:BankAtmPos[BANK_ATM_POINT_COUNT][4] =
{
	{2879.7578, 2498.7592, 1051.0447, 80.3119},
	{2879.7565, 2501.0971, 1051.0447, 81.3141},
	{2879.7563, 2503.5209, 1051.0447, 77.1040},
	{2879.7570, 2505.9770, 1051.0447, 77.9657},
	{2879.7563, 2508.3649, 1051.0447, 83.4248},
	{2879.7561, 2510.9055, 1051.0447, 96.0722}
};

static const g_BankBranches[BANK_BRANCH_COUNT][E_BANK_BRANCH] =
{
	{"Батырево",       1851.8612,  2037.3320, 16.5517, 179.4135, 1852.1217,  2038.9011, 16.5517,   1.5227, 6},
	{"Арзамас",        394.8446,   762.9340,  12.6643, 328.5370, 394.5037,   761.8340,  12.6643, 161.4045, 4},
	{"Южный",          2376.7722, -2139.3071, 22.1294, 359.5223, 2376.6745, -2140.8979, 22.0009, 186.4105, 5},
	{"Лыткарино",     -2326.8879,  -29.0731, 27.4181, 176.3253,-2326.5808,  -27.4682, 27.4181,   3.0718, 3},
	{"Нижегородск",   -2112.2492, 2169.7856, 58.7244, 350.2008,-2112.3798, 2168.5676, 58.7244, 171.5498, 2}
};

static const g_BankEnterCityLabel[BANK_BRANCH_COUNT][28] =
{
	"Батырова",
	"Арзамаса",
	"Южного",
	"Лыткарино",
	"Нижегородска"
};

static const g_BankAtmPresetSum[7] = {100, 200, 500, 1000, 2000, 5000, 10000};

new STREAMER_TAG_PICKUP:gBankEnterPickup[BANK_BRANCH_COUNT];
new STREAMER_TAG_PICKUP:gBankExitPickupA[BANK_BRANCH_COUNT];
new STREAMER_TAG_PICKUP:gBankExitPickupB[BANK_BRANCH_COUNT];
new STREAMER_TAG_PICKUP:gBankServicePickup[BANK_BRANCH_COUNT][BANK_SERVICE_POINT_COUNT];
new STREAMER_TAG_PICKUP:gBankPaymentPickup[BANK_BRANCH_COUNT][BANK_PAYMENT_POINT_COUNT];
new STREAMER_TAG_OBJECT:gBankAtmObject[BANK_BRANCH_COUNT][BANK_ATM_POINT_COUNT];
new STREAMER_TAG_AREA:gBankAtmArea[BANK_BRANCH_COUNT][BANK_ATM_POINT_COUNT];
new STREAMER_TAG_AREA:gBankGreenArea[BANK_BRANCH_COUNT];

new STREAMER_TAG_3D_TEXT_LABEL:gBankEnterLabel[BANK_BRANCH_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gBankExitLabelA[BANK_BRANCH_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gBankExitLabelB[BANK_BRANCH_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gBankServiceLabel[BANK_BRANCH_COUNT][BANK_SERVICE_POINT_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gBankPaymentLabel[BANK_BRANCH_COUNT][BANK_PAYMENT_POINT_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:gBankAtmLabel[BANK_BRANCH_COUNT][BANK_ATM_POINT_COUNT];

new g_BankPlayerBranch[MAX_PLAYERS] = {-1, ...};
new g_BankLastEnter[MAX_PLAYERS];
new g_BankLastExit[MAX_PLAYERS];
new bool:g_BankPointLock[MAX_PLAYERS];
new Float:g_BankLockPos[MAX_PLAYERS][3];
new g_BankUnlockTimer[MAX_PLAYERS] = {-1, ...};
new g_BankExtraAccount[MAX_PLAYERS][BANK_MAX_EXTRA_ACCOUNTS][E_BANK_EXTRA_ACCOUNT];
new g_BankExtraListMap[MAX_PLAYERS][BANK_MAX_EXTRA_ACCOUNTS];
new g_BankAccBackIgnore[MAX_PLAYERS];
new g_BankAtmStandalone[MAX_PLAYERS];
new g_BankAtmBackIgnore[MAX_PLAYERS];
new g_BankLastAtmOpen[MAX_PLAYERS];
new g_BankAtmNotifyPoint[MAX_PLAYERS] = {-1, ...};
new g_BankAtmProxTimer[MAX_PLAYERS] = {-1, ...};
new g_BankLastNotifyShow[MAX_PLAYERS];
new bool:g_BankAtmInside[MAX_PLAYERS][BANK_ATM_POINT_COUNT];
new bool:g_BankAtmRearmWait[MAX_PLAYERS];
new Float:g_BankAtmRearmPos[MAX_PLAYERS][3];
new g_BankAtmRearmTimer[MAX_PLAYERS] = {-1, ...};

new g_CharityTopRows[MAX_PLAYERS];
new g_CharityTopName[MAX_PLAYERS][BANK_CHARITY_TOP_LIMIT][MAX_PLAYER_NAME];
new g_CharityTopSum[MAX_PLAYERS][BANK_CHARITY_TOP_LIMIT];
new g_CharityOwnTotal[MAX_PLAYERS];

forward Bank_UnlockCheck(playerid);
forward Bank_AtmRearmUnlockCheck(playerid);
forward Shop247_GetPlayer247Biz(playerid);
forward Shop247_OnAtmDialogClosed(playerid);
forward Shop247_OnAtmRearmSynced(playerid);
forward Bank_OnCharityTopLoaded(playerid);
forward Bank_OnCharityOwnLoaded(playerid);
forward Bank_OnExtraHistoryLoaded(playerid, slot);
forward Bank_DelayedOpenAccounts(playerid);
forward Bank_OnTransferTargetChecked(playerid, slot);
forward Bank_AtmProxTick(playerid);
forward Bank_AtmProxSync(playerid);
forward Bank_DelayedGreenSync(playerid);

stock Bank_ArmAccountsBackIgnore(playerid, count = BANK_ACC_BACK_IGNORE_MAX)
{
	g_BankAccBackIgnore[playerid] = count;
}

stock Bank_ArmAtmBackIgnore(playerid, count = BANK_ATM_BACK_IGNORE_MAX)
{
	g_BankAtmBackIgnore[playerid] = count;
}

stock Bank_AtmClearRearm(playerid)
{
	g_BankAtmRearmWait[playerid] = false;
	g_BankAtmRearmPos[playerid][0] = 0.0;
	g_BankAtmRearmPos[playerid][1] = 0.0;
	g_BankAtmRearmPos[playerid][2] = 0.0;
	if(g_BankAtmRearmTimer[playerid] != -1)
	{
		KillTimer(g_BankAtmRearmTimer[playerid]);
		g_BankAtmRearmTimer[playerid] = -1;
	}
}

stock Bank_AtmArmRearm(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	GetPlayerPos(playerid, g_BankAtmRearmPos[playerid][0], g_BankAtmRearmPos[playerid][1], g_BankAtmRearmPos[playerid][2]);
	g_BankAtmRearmWait[playerid] = true;
	for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
		g_BankAtmInside[playerid][a] = false;
	Shop247_OnAtmRearmSynced(playerid);
	if(g_BankAtmRearmTimer[playerid] != -1)
		KillTimer(g_BankAtmRearmTimer[playerid]);
	g_BankAtmRearmTimer[playerid] = SetTimerEx("Bank_AtmRearmUnlockCheck", BANK_UNLOCK_CHECK_MS, true, "i", playerid);
	return 1;
}

public Bank_AtmRearmUnlockCheck(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		Bank_AtmClearRearm(playerid);
		return 0;
	}
	if(!g_BankAtmRearmWait[playerid])
	{
		if(g_BankAtmRearmTimer[playerid] != -1)
		{
			KillTimer(g_BankAtmRearmTimer[playerid]);
			g_BankAtmRearmTimer[playerid] = -1;
		}
		return 0;
	}
	if(IsPlayerInRangeOfPoint(playerid, BANK_INTERACT_LEAVE_DIST,
		g_BankAtmRearmPos[playerid][0], g_BankAtmRearmPos[playerid][1], g_BankAtmRearmPos[playerid][2]))
		return 1;
	g_BankAtmRearmWait[playerid] = false;
	return 1;
}

stock bool:Bank_AtmMayShowNotify(playerid)
{
	if(!g_BankAtmRearmWait[playerid]) return true;
	if(IsPlayerInRangeOfPoint(playerid, BANK_INTERACT_LEAVE_DIST,
		g_BankAtmRearmPos[playerid][0], g_BankAtmRearmPos[playerid][1], g_BankAtmRearmPos[playerid][2]))
		return false;
	g_BankAtmRearmWait[playerid] = false;
	for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
		g_BankAtmInside[playerid][a] = false;
	Shop247_OnAtmRearmSynced(playerid);
	return true;
}

stock Bank_MarkAtmDialogClosed(playerid)
{
	DeletePVar(playerid, BANK_PVAR_ATM_DIALOG_OPEN);
	g_BankAtmStandalone[playerid] = 0;
	g_BankAtmBackIgnore[playerid] = 0;
	g_BankAtmNotifyPoint[playerid] = -1;
	HideInteractionWindow(playerid);
	if(IsPlayerConnected(playerid))
	{
		if(Shop247_GetPlayer247Biz(playerid) != -1)
			Bank_AtmArmRearm(playerid);
		else if(GetPlayerInterior(playerid) == BANK_INTERIOR && Bank_GetPlayerBranch(playerid) >= 0)
			Bank_AtmArmRearm(playerid);
	}
	Shop247_OnAtmDialogClosed(playerid);
	return 1;
}

stock Bank_ResetAtmInsideFlags(playerid)
{
	for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
		g_BankAtmInside[playerid][a] = false;
	g_BankAtmNotifyPoint[playerid] = -1;
	g_BankLastNotifyShow[playerid] = 0;
	Bank_AtmClearRearm(playerid);
}

stock Bank_GetGreenZoneByArea(STREAMER_TAG_AREA:areaid, &branch)
{
	branch = -1;
	for(new b = 0; b < BANK_BRANCH_COUNT; b++)
	{
		if(_:areaid == _:gBankGreenArea[b])
		{
			branch = b;
			return 1;
		}
	}
	return 0;
}

stock bool:Bank_IsPhysInBankGreenZone(playerid)
{
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return false;
	if(Bank_GetPlayerBranch(playerid) < 0) return false;
	return (IsPlayerInRangeOfPoint(playerid, BANK_GREEN_ZONE_RADIUS,
		BankInteriorGreenCenter[0], BankInteriorGreenCenter[1], BankInteriorGreenCenter[2]) != 0);
}

stock bool:Bank_PlayerInGreenZone(playerid)
{
	return (Bank_IsPhysInBankGreenZone(playerid) || GetPVarInt(playerid, BANK_PVAR_GREEN_ZONE) == 1);
}

stock Bank_WarnGreenZoneAttack(playerid)
{
	if(GetPVarInt(playerid, BANK_PVAR_GZ_WARN_CD) > gettime()) return 0;
	SetPVarInt(playerid, BANK_PVAR_GZ_WARN_CD, gettime() + 3);
	SendClientMessage(playerid, 0xFF5533FF,
		"{FFCD00}[Банк] {FFFFFF}В зелёной зоне «Банк» удары и стрельба запрещены.");
	if(!IsPlayerInAnyVehicle(playerid))
	{
		ClearAnimations(playerid);
		ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

stock Bank_LeaveGreenZone(playerid)
{
	if(GetPVarInt(playerid, BANK_PVAR_GREEN_ZONE) != 1) return 0;
	DeletePVar(playerid, BANK_PVAR_GREEN_ZONE);
	HideZona(playerid);
	MinerJob_SetClientCombatLock(playerid, false);
	return 1;
}

stock Bank_EnterGreenZone(playerid)
{
	if(!Bank_IsPhysInBankGreenZone(playerid)) return 0;
	if(GetPVarInt(playerid, BANK_PVAR_GREEN_ZONE) == 1) return 0;
	SetPVarInt(playerid, BANK_PVAR_GREEN_ZONE, 1);
	ShowZona(playerid);
	MinerJob_SetClientCombatLock(playerid, true);
	return 1;
}

stock Bank_UpdateGreenZone(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Bank_IsPhysInBankGreenZone(playerid))
	{
		if(GetPVarInt(playerid, BANK_PVAR_GREEN_ZONE) != 1)
		{
			SetPVarInt(playerid, BANK_PVAR_GREEN_ZONE, 1);
			ShowZona(playerid);
			MinerJob_SetClientCombatLock(playerid, true);
		}
		return 1;
	}
	if(GetPVarInt(playerid, BANK_PVAR_GREEN_ZONE) == 1)
		Bank_LeaveGreenZone(playerid);
	return 0;
}

public Bank_DelayedGreenSync(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	Bank_UpdateGreenZone(playerid);
	if(Bank_PlayerInGreenZone(playerid))
		MinerJob_SetClientCombatLock(playerid, true);
	return 0;
}

stock Bank_OnTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	#pragma unused amount, weaponid, bodypart
	if(!Bank_PlayerInGreenZone(playerid)) return 1;
	if(issuerid != INVALID_PLAYER_ID && IsPlayerConnected(issuerid))
	{
		Bank_WarnGreenZoneAttack(issuerid);
		return 0;
	}
	return 1;
}

stock Bank_OnGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	#pragma unused amount, weaponid, bodypart
	if(Bank_PlayerInGreenZone(playerid))
	{
		Bank_WarnGreenZoneAttack(playerid);
		return 0;
	}
	if(damagedid != INVALID_PLAYER_ID && Bank_PlayerInGreenZone(damagedid))
	{
		Bank_WarnGreenZoneAttack(playerid);
		return 0;
	}
	return 1;
}

stock Bank_OnWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	#pragma unused weaponid, fX, fY, fZ
	if(Bank_PlayerInGreenZone(playerid))
	{
		Bank_WarnGreenZoneAttack(playerid);
		return 0;
	}
	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID && Bank_PlayerInGreenZone(hitid))
	{
		Bank_WarnGreenZoneAttack(playerid);
		return 0;
	}
	return 1;
}

stock Bank_GetAtmPointByArea(STREAMER_TAG_AREA:areaid, &branch, &point_idx)
{
	branch = -1;
	point_idx = -1;
	for(new b = 0; b < BANK_BRANCH_COUNT; b++)
	{
		for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
		{
			if(_:areaid == _:gBankAtmArea[b][a])
			{
				branch = b;
				point_idx = a;
				return 1;
			}
		}
	}
	return 0;
}

stock bool:Bank_IsPlayerNearAtmPoint(playerid, point_idx, Float:radius = BANK_ATM_NOTIFY_SHOW_RADIUS)
{
	if(point_idx < 0 || point_idx >= BANK_ATM_POINT_COUNT) return false;
	return (IsPlayerInRangeOfPoint(playerid, radius,
		BankAtmPos[point_idx][0], BankAtmPos[point_idx][1], BankAtmPos[point_idx][2]) != 0);
}

stock bool:Bank_IsPlayerInAtmNotifyRange(playerid, &point_idx)
{
	point_idx = -1;
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return false;
	if(Bank_GetPlayerBranch(playerid) < 0) return false;
	for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
	{
		if(Bank_IsPlayerNearAtmPoint(playerid, a))
		{
			point_idx = a;
			return true;
		}
	}
	return false;
}

stock Bank_ShowAtmNotifyAt(playerid, point_idx, bool:ignore_cd = false)
{
	if(point_idx < 0 || point_idx >= BANK_ATM_POINT_COUNT) return 0;
	if(Player[playerid][pID] <= 0) return 0;
	if(GetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN) == 1) return 0;
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return 0;
	if(Bank_GetPlayerBranch(playerid) < 0) return 0;
	if(!Bank_IsPlayerNearAtmPoint(playerid, point_idx)) return 0;
	if(!Bank_AtmMayShowNotify(playerid)) return 0;

	new tick = GetTickCount();
	if(!ignore_cd && tick - g_BankLastNotifyShow[playerid] < BANK_ATM_NOTIFY_REPEAT_MS)
		return 0;

	g_BankLastNotifyShow[playerid] = tick;
	g_BankAtmNotifyPoint[playerid] = point_idx;
	g_BankAtmInside[playerid][point_idx] = true;
	ToggleInteractionWindow(playerid, true);
	return 1;
}

stock bool:Bank_IsPlayerAtAtm(playerid)
{
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return false;
	new branch = Bank_GetPlayerBranch(playerid);
	if(branch < 0) return false;
	for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
	{
		if(IsPlayerInRangeOfPoint(playerid, BANK_ATM_USE_RADIUS,
			BankAtmPos[a][0], BankAtmPos[a][1], BankAtmPos[a][2]))
			return true;
	}
	return false;
}

stock Bank_AtmProxStop(playerid)
{
	if(g_BankAtmProxTimer[playerid] != -1)
	{
		KillTimer(g_BankAtmProxTimer[playerid]);
		g_BankAtmProxTimer[playerid] = -1;
	}
	HideInteractionWindow(playerid);
	Bank_ResetAtmInsideFlags(playerid);
}

stock Bank_AtmProxEnsure(playerid)
{
	if(g_BankAtmProxTimer[playerid] != -1) return 1;
	g_BankAtmProxTimer[playerid] = SetTimerEx("Bank_AtmProxTick", BANK_ATM_PROX_MS, true, "i", playerid);
	return 1;
}

stock Bank_UpdateAtmNotify(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return 0;
	if(Bank_GetPlayerBranch(playerid) < 0) return 0;

	new shown = 0;
	new bool:near_show = false;
	for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
	{
		if(!IsPlayerInRangeOfPoint(playerid, BANK_ATM_NOTIFY_RESET_RADIUS,
			BankAtmPos[a][0], BankAtmPos[a][1], BankAtmPos[a][2]))
			g_BankAtmInside[playerid][a] = false;

		if(!Bank_IsPlayerNearAtmPoint(playerid, a, BANK_ATM_NOTIFY_SHOW_RADIUS))
			continue;

		near_show = true;

		if(g_BankAtmInside[playerid][a])
			continue;

		if(Bank_ShowAtmNotifyAt(playerid, a))
			shown = 1;
	}
	if(!near_show)
		HideInteractionWindow(playerid);
	return shown;
}

stock Bank_TryInteractKey(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(GetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN) == 1) return 0;
	if(!Bank_IsPlayerAtAtm(playerid)) return 0;
	return Bank_OpenAtm(playerid);
}

public Bank_AtmProxTick(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		Bank_AtmProxStop(playerid);
		return 0;
	}
	if(GetPlayerInterior(playerid) != BANK_INTERIOR)
	{
		Bank_AtmProxStop(playerid);
		return 0;
	}
	if(Bank_GetPlayerBranch(playerid) < 0)
		return 0;
	Bank_UpdateGreenZone(playerid);
	Bank_UpdateAtmNotify(playerid);
	return 0;
}

public Bank_AtmProxSync(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return 0;
	if(Bank_GetPlayerBranch(playerid) < 0) return 0;
	Bank_AtmProxEnsure(playerid);
	Bank_UpdateAtmNotify(playerid);
	return 0;
}

stock Bank_ShowAtmNotify(playerid)
{
	Bank_AtmProxEnsure(playerid);
	return Bank_UpdateAtmNotify(playerid);
}

stock Bank_HandleNotifyPacket(playerid, notify_id)
{
	if(notify_id != NOTIFY_BANK_ATM) return 0;
	return Bank_OpenAtm(playerid);
}

stock Bank_OpenAtm(playerid)
{
	if(Player[playerid][pID] <= 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Авторизуйтесь на сервере.");
		return 0;
	}
	if(!Bank_IsPlayerAtAtm(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Подойдите к банкомату.");
		return 0;
	}
	new branch = Bank_GetPlayerBranch(playerid);
	if(branch < 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Банкомат недоступен в этом отделении.");
		return 0;
	}
	new tick = GetTickCount();
	if(tick - g_BankLastAtmOpen[playerid] < BANK_ATM_OPEN_CD_MS) return 0;
	if(GetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN) == 1) return 0;
	HideInteractionWindow(playerid);

	g_BankPlayerBranch[playerid] = branch;
	g_BankAtmStandalone[playerid] = 1;
	g_BankLastAtmOpen[playerid] = tick;
	Bank_ArmAtmBackIgnore(playerid);
	SetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN, 1);
	return Bank_ShowAtmMainDialog(playerid);
}

// -----------------------------------------------------------------------------
stock Bank_GetBranchVW(branch)
{
	if(branch < 0 || branch >= BANK_BRANCH_COUNT) return 0;
	return g_BankBranches[branch][B_INTERIOR_VW];
}

stock Bank_GetEnterPosForGps(branch, &Float:x, &Float:y, &Float:z)
{
	if(branch < 0 || branch >= BANK_BRANCH_COUNT) return 0;
	x = g_BankBranches[branch][B_ENTER_X];
	y = g_BankBranches[branch][B_ENTER_Y];
	z = g_BankBranches[branch][B_ENTER_Z];
	return 1;
}

stock Bank_GetBranchName(branch, dest[], size = sizeof dest)
{
	if(branch < 0 || branch >= BANK_BRANCH_COUNT) { dest[0] = '\0'; return 0; }
	format(dest, size, "%s", g_BankBranches[branch][B_NAME]);
	return 1;
}

stock Bank_GetPlayerBranch(playerid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return -1;
	new vw = GetPlayerVirtualWorld(playerid);
	for(new i = 0; i < BANK_BRANCH_COUNT; i++)
		if(vw == g_BankBranches[i][B_INTERIOR_VW]) return i;
	return -1;
}

stock bool:Bank_CanUseServices(playerid)
{
	if(Player[playerid][pID] <= 0) return false;
	if(Bank_GetPlayerBranch(playerid) != -1) return true;
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return false;
	for(new s = 0; s < BANK_SERVICE_POINT_COUNT; s++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0,
			BankServicePos[s][0], BankServicePos[s][1], BankServicePos[s][2]))
			return true;
	}
	return false;
}

stock Bank_CountExtraAccounts(playerid)
{
	new cnt = 0;
	for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
		if(Bank_IsValidExtraSlot(playerid, i)) cnt++;
	return cnt;
}

stock Bank_FindFreeExtraSlot(playerid)
{
	for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
		if(!Bank_IsValidExtraSlot(playerid, i)) return i;
	return -1;
}

stock Bank_PushExtraAccountLocal(playerid, acc_id, const name[], balance, const pin[] = BANK_DEFAULT_PIN)
{
	if(acc_id <= 0) return -1;
	new slot = Bank_FindFreeExtraSlot(playerid);
	if(slot < 0) return -1;
	g_BankExtraAccount[playerid][slot][BEA_SQL_ID] = acc_id;
	g_BankExtraAccount[playerid][slot][BEA_BALANCE] = balance;
	format(g_BankExtraAccount[playerid][slot][BEA_NAME], BANK_ACCOUNT_NAME_LEN + 1, "%s", name);
	format(g_BankExtraAccount[playerid][slot][BEA_PIN], BANK_PIN_LEN + 1, "%s", pin);
	return slot;
}

stock Bank_ClearInteractLock(playerid)
{
	g_BankPointLock[playerid] = false;
	g_BankLockPos[playerid][0] = 0.0;
	g_BankLockPos[playerid][1] = 0.0;
	g_BankLockPos[playerid][2] = 0.0;
	if(g_BankUnlockTimer[playerid] != -1)
	{
		KillTimer(g_BankUnlockTimer[playerid]);
		g_BankUnlockTimer[playerid] = -1;
	}
}

stock Bank_TryUnlockInteract(playerid)
{
	if(!g_BankPointLock[playerid]) return 0;
	if(IsPlayerInRangeOfPoint(playerid, BANK_INTERACT_LEAVE_DIST,
		g_BankLockPos[playerid][0], g_BankLockPos[playerid][1], g_BankLockPos[playerid][2]))
		return 0;

	Bank_ClearInteractLock(playerid);
	return 1;
}

stock Bank_SetInteractLock(playerid, Float:x, Float:y, Float:z)
{
	g_BankPointLock[playerid] = true;
	g_BankLockPos[playerid][0] = x;
	g_BankLockPos[playerid][1] = y;
	g_BankLockPos[playerid][2] = z;

	if(g_BankUnlockTimer[playerid] != -1)
		KillTimer(g_BankUnlockTimer[playerid]);
	g_BankUnlockTimer[playerid] = SetTimerEx("Bank_UnlockCheck", BANK_UNLOCK_CHECK_MS, true, "i", playerid);
}

public Bank_UnlockCheck(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		Bank_ClearInteractLock(playerid);
		return 0;
	}
	if(!g_BankPointLock[playerid])
	{
		if(g_BankUnlockTimer[playerid] != -1)
		{
			KillTimer(g_BankUnlockTimer[playerid]);
			g_BankUnlockTimer[playerid] = -1;
		}
		return 0;
	}
	Bank_TryUnlockInteract(playerid);
	return 1;
}

stock Bank_ResetPlayer(playerid)
{
	g_BankPlayerBranch[playerid] = -1;
	g_BankLastEnter[playerid] = 0;
	g_BankLastExit[playerid] = 0;
	Bank_ClearInteractLock(playerid);
	DeletePVar(playerid, BANK_PVAR_USE_SLOT);
	DeletePVar(playerid, BANK_PVAR_TRANSFER_ID);
	DeletePVar(playerid, BANK_PVAR_ATM_TAKE);
	DeletePVar(playerid, BANK_PVAR_ATM_BIZ_TAKE);
	DeletePVar(playerid, BANK_PVAR_SUB_OP);
	DeletePVar(playerid, BANK_PVAR_PENDING_ACC_DLG);
	DeletePVar(playerid, BANK_PVAR_ACC_CREATE_ROW);
	DeletePVar(playerid, BANK_PVAR_NEW_ACC_NAME);
	DeletePVar(playerid, BANK_PVAR_LOAD_GEN);
	DeletePVar(playerid, BANK_PVAR_ACC_LAST_CNT);
	g_BankAccBackIgnore[playerid] = 0;
	g_BankAtmStandalone[playerid] = 0;
	g_BankAtmBackIgnore[playerid] = 0;
	g_BankLastAtmOpen[playerid] = 0;
	Bank_AtmClearRearm(playerid);
	Bank_LeaveGreenZone(playerid);
	Bank_AtmProxStop(playerid);
	InteractBtn_ResetPlayer(playerid);
	DeletePVar(playerid, BANK_PVAR_ATM_DIALOG_OPEN);
	DeletePVar(playerid, BANK_PVAR_GZ_WARN_CD);
	if(GetPlayerInterior(playerid) != BANK_INTERIOR)
	{
		new vw = GetPlayerVirtualWorld(playerid);
		for(new b = 0; b < BANK_BRANCH_COUNT; b++)
		{
			if(vw == g_BankBranches[b][B_INTERIOR_VW])
			{
				SetPlayerVirtualWorld(playerid, 0);
				break;
			}
		}
	}
	for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
	{
		g_BankExtraAccount[playerid][i][BEA_SQL_ID] = 0;
		g_BankExtraAccount[playerid][i][BEA_BALANCE] = 0;
		g_BankExtraAccount[playerid][i][BEA_NAME][0] = '\0';
		g_BankExtraAccount[playerid][i][BEA_PIN][0] = '\0';
		g_BankExtraListMap[playerid][i] = -1;
	}
}

stock Bank_ClearExtraAccounts(playerid)
{
	for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
	{
		g_BankExtraAccount[playerid][i][BEA_SQL_ID] = 0;
		g_BankExtraAccount[playerid][i][BEA_BALANCE] = 0;
		g_BankExtraAccount[playerid][i][BEA_NAME][0] = '\0';
		g_BankExtraAccount[playerid][i][BEA_PIN][0] = '\0';
		g_BankExtraListMap[playerid][i] = -1;
	}
}

stock Bank_IsValidExtraSlot(playerid, slot)
{
	if(slot < 0 || slot >= BANK_MAX_EXTRA_ACCOUNTS) return false;
	return (g_BankExtraAccount[playerid][slot][BEA_SQL_ID] > 0);
}

stock Bank_RebuildExtraListMap(playerid)
{
	for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
		g_BankExtraListMap[playerid][i] = -1;

	new cnt = 0;
	for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
	{
		if(!Bank_IsValidExtraSlot(playerid, i)) continue;
		g_BankExtraListMap[playerid][cnt] = i;
		cnt++;
	}
	return cnt;
}

stock Bank_GetExtraSlotByListIndex(playerid, list_index)
{
	if(list_index < 0 || list_index >= BANK_MAX_EXTRA_ACCOUNTS) return -1;
	new slot = g_BankExtraListMap[playerid][list_index];
	if(!Bank_IsValidExtraSlot(playerid, slot)) return -1;
	return slot;
}

stock Bank_SaveMainMoney(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `players` SET `money`=%d,`bank`=%d WHERE `id`=%d LIMIT 1",
		Player[playerid][pMoney], Player[playerid][pBank], Player[playerid][pID]);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Bank_SaveBusinessBalance(bizid)
{
	if(bizid < 0 || bizid >= g_business_loaded) return 0;
	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `business` SET `balance`=%d WHERE `id`=%d LIMIT 1",
		GetBusinessData(bizid, B_BALANCE), GetBusinessData(bizid, B_SQL_ID));
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Bank_EnsureTables()
{
	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `bank_accounts` (\
		`id` int(11) NOT NULL AUTO_INCREMENT,\
		`uid` int(11) NOT NULL,\
		`name` varchar(21) NOT NULL DEFAULT 'None',\
		`balance` int(11) NOT NULL DEFAULT 0,\
		`pin` varchar(9) NOT NULL DEFAULT '0000',\
		`reg_time` int(11) NOT NULL DEFAULT 0,\
		PRIMARY KEY (`id`), KEY `uid` (`uid`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");

	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `charity_donations` (\
		`account_id` int(11) NOT NULL,\
		`player_name` varchar(24) NOT NULL DEFAULT '',\
		`total_donated` bigint(20) NOT NULL DEFAULT 0,\
		`last_donation` int(11) NOT NULL DEFAULT 0,\
		PRIMARY KEY (`account_id`),\
		KEY `idx_charity_total` (`total_donated`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");

	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `bank_accounts_log` (\
		`id` int(11) NOT NULL AUTO_INCREMENT,\
		`acc_id` int(11) NOT NULL,\
		`uip` varchar(16) NOT NULL DEFAULT '255.255.255.255',\
		`time` int(11) NOT NULL DEFAULT 0,\
		`description` varchar(64) NOT NULL DEFAULT '',\
		PRIMARY KEY (`id`), KEY `acc_id` (`acc_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
	return 1;
}

stock Bank_RecordCharityDonation(playerid, amount)
{
	if(Player[playerid][pID] <= 0 || amount <= 0) return 0;

	new q[320];
	mysql_format(db_handle, q, sizeof q,
		"INSERT INTO `charity_donations` (`account_id`,`player_name`,`total_donated`,`last_donation`) \
		VALUES (%d,'%e',%d,%d) ON DUPLICATE KEY UPDATE \
		`total_donated`=`total_donated`+%d, `player_name`='%e', `last_donation`=%d",
		Player[playerid][pID], Player[playerid][pName], amount, gettime(),
		amount, Player[playerid][pName], gettime());
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Bank_ShowCharityTop(playerid)
{
	if(Player[playerid][pID] <= 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Благотворительность] {FFFFFF}Вы не авторизованы.");
		return 0;
	}
	g_CharityTopRows[playerid] = 0;
	mysql_tquery(db_handle,
		"SELECT `player_name`,`total_donated` FROM `charity_donations` \
		ORDER BY `total_donated` DESC LIMIT 10",
		"Bank_OnCharityTopLoaded", "d", playerid);
	return 1;
}

public Bank_OnCharityTopLoaded(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	g_CharityTopRows[playerid] = cache_num_rows();
	if(g_CharityTopRows[playerid] > BANK_CHARITY_TOP_LIMIT)
		g_CharityTopRows[playerid] = BANK_CHARITY_TOP_LIMIT;

	for(new i = 0; i < g_CharityTopRows[playerid]; i++)
	{
		cache_get_field_content(i, "player_name", g_CharityTopName[playerid][i], db_handle, MAX_PLAYER_NAME);
		g_CharityTopSum[playerid][i] = cache_get_field_content_int(i, "total_donated", db_handle);
	}

	new q[96];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `total_donated` FROM `charity_donations` WHERE `account_id`=%d LIMIT 1",
		Player[playerid][pID]);
	mysql_tquery(db_handle, q, "Bank_OnCharityOwnLoaded", "d", playerid);
	return 1;
}

public Bank_OnCharityOwnLoaded(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	g_CharityOwnTotal[playerid] = 0;
	if(cache_num_rows() > 0)
		g_CharityOwnTotal[playerid] = cache_get_field_content_int(0, "total_donated", db_handle);

	new body[1400], line[128], moneystr[24];
	format(body, sizeof body,
		CAR_CLR_WHITE "Место\t" CAR_CLR_GOLD "Игрок\t" CAR_CLR_GOLD "Сумма\n");

	if(g_CharityTopRows[playerid] == 0)
		strcat(body, CAR_CLR_DIM "Пожертвований пока нет.\n");
	else
	{
		for(new i = 0; i < g_CharityTopRows[playerid]; i++)
		{
			ConvertMoney(g_CharityTopSum[playerid][i], moneystr);
			format(line, sizeof line,
				CAR_CLR_WHITE "%d.\t%s\t" CAR_CLR_GOLD "%s руб\n",
				i + 1, g_CharityTopName[playerid][i], moneystr);
			strcat(body, line);
		}
	}

	ConvertMoney(g_CharityOwnTotal[playerid], moneystr);
	format(line, sizeof line,
		"\n" CAR_CLR_WHITE "Ваш общий вклад:\t" CAR_CLR_GOLD "%s руб",
		moneystr);
	strcat(body, line);

	ShowPlayerDialog(playerid, DIALOG_BR_CHARITY_TOP, DIALOG_STYLE_TABLIST_HEADERS,
		CAR_DLG_PREFIX "Благотворительность — ТОП-10",
		body, "Закрыть", "");
	return 1;
}

stock Bank_LoadExtraAccounts(playerid, bool:show_accounts_after = false)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(show_accounts_after) SetPVarInt(playerid, BANK_PVAR_PENDING_ACC_DLG, 1);
	else DeletePVar(playerid, BANK_PVAR_PENDING_ACC_DLG);

	new gen = GetPVarInt(playerid, BANK_PVAR_LOAD_GEN) + 1;
	SetPVarInt(playerid, BANK_PVAR_LOAD_GEN, gen);

	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `id`,`name`,`balance`,`pin` FROM `bank_accounts` WHERE `uid`=%d ORDER BY `id` ASC LIMIT %d",
		Player[playerid][pID], BANK_MAX_EXTRA_ACCOUNTS);
	mysql_tquery(db_handle, q, "Bank_OnExtraAccountsLoaded", "dd", playerid, gen);
	return 1;
}

stock Bank_OpenAccountsList(playerid)
{
	DeletePVar(playerid, BANK_PVAR_ATM_DIALOG_OPEN);
	if(Player[playerid][pID] <= 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Данные персонажа ещё не загружены.");
		return 0;
	}
	SetPVarInt(playerid, BANK_PVAR_ACC_LAST_CNT, Bank_CountExtraAccounts(playerid));
	Bank_ArmAccountsBackIgnore(playerid);
	Bank_ShowAccountsDialog(playerid);
	Bank_LoadExtraAccounts(playerid, true);
	return 1;
}

public Bank_DelayedOpenAccounts(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] <= 0) return 0;
	Bank_OpenAccountsList(playerid);
	return 1;
}

forward Bank_OnExtraAccountsLoaded(playerid, load_gen);
public Bank_OnExtraAccountsLoaded(playerid, load_gen)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(load_gen != GetPVarInt(playerid, BANK_PVAR_LOAD_GEN)) return 0;

	new rows, fields;
	cache_get_data(rows, fields, db_handle);

	Bank_ClearExtraAccounts(playerid);
	for(new row = 0; row < rows && row < BANK_MAX_EXTRA_ACCOUNTS; row++)
	{
		g_BankExtraAccount[playerid][row][BEA_SQL_ID] = cache_get_row_int(row, 0, db_handle);
		cache_get_row(row, 1, g_BankExtraAccount[playerid][row][BEA_NAME], db_handle, BANK_ACCOUNT_NAME_LEN);
		g_BankExtraAccount[playerid][row][BEA_BALANCE] = cache_get_row_int(row, 2, db_handle);
		cache_get_row(row, 3, g_BankExtraAccount[playerid][row][BEA_PIN], db_handle, BANK_PIN_LEN);
		if(!g_BankExtraAccount[playerid][row][BEA_PIN][0])
			format(g_BankExtraAccount[playerid][row][BEA_PIN], BANK_PIN_LEN + 1, BANK_DEFAULT_PIN);
	}
	Bank_RebuildExtraListMap(playerid);

	if(GetPVarInt(playerid, BANK_PVAR_PENDING_ACC_DLG))
	{
		DeletePVar(playerid, BANK_PVAR_PENDING_ACC_DLG);
		new prev_cnt = GetPVarInt(playerid, BANK_PVAR_ACC_LAST_CNT);
		new now_cnt = Bank_CountExtraAccounts(playerid);
		SetPVarInt(playerid, BANK_PVAR_ACC_LAST_CNT, now_cnt);
		if(now_cnt != prev_cnt)
		{
			Bank_ArmAccountsBackIgnore(playerid);
			Bank_ShowAccountsDialog(playerid);
		}
	}
	return 1;
}

stock Bank_TeleportInside(playerid, branch)
{
	if(branch < 0 || branch >= BANK_BRANCH_COUNT) return 0;
	new vw = Bank_GetBranchVW(branch);
	g_BankPlayerBranch[playerid] = branch;
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerInterior(playerid, BANK_INTERIOR);
	SetPlayerPos(playerid, BankEnterSpawn[0], BankEnterSpawn[1], BankEnterSpawn[2]);
	SetPlayerFacingAngle(playerid, BankEnterSpawn[3]);
	Streamer_UpdateEx(playerid, BankEnterSpawn[0], BankEnterSpawn[1], BankEnterSpawn[2], vw, BANK_INTERIOR);
	SetCameraBehindPlayer(playerid);
	Bank_AtmProxEnsure(playerid);
	SetTimerEx("Bank_AtmProxSync", 400, false, "i", playerid);
	SetTimerEx("Bank_DelayedGreenSync", 450, false, "i", playerid);
	Bank_EnterGreenZone(playerid);
	new msg[80];
	format(msg, sizeof msg, "Банк г. %s", g_BankBranches[branch][B_NAME]);
	ShowNotification(playerid, 3, 5, 0, 1, msg, "");
	return 1;
}

stock Bank_TeleportOutside(playerid)
{
	new branch = g_BankPlayerBranch[playerid];
	if(branch < 0) branch = Bank_GetPlayerBranch(playerid);
	if(branch < 0) branch = 0;
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid,
		g_BankBranches[branch][B_EXIT_X], g_BankBranches[branch][B_EXIT_Y], g_BankBranches[branch][B_EXIT_Z] + 0.3);
	SetPlayerFacingAngle(playerid, g_BankBranches[branch][B_EXIT_A]);
	Streamer_UpdateEx(playerid, g_BankBranches[branch][B_EXIT_X], g_BankBranches[branch][B_EXIT_Y], g_BankBranches[branch][B_EXIT_Z], 0, 0);
	SetCameraBehindPlayer(playerid);
	g_BankPlayerBranch[playerid] = -1;
	Bank_LeaveGreenZone(playerid);
	Bank_AtmProxStop(playerid);
	Player_FixInteriorWorldLeak(playerid);
	new msg[80];
	format(msg, sizeof msg, "Вы вышли из банка (г. %s)", g_BankBranches[branch][B_NAME]);
	ShowNotification(playerid, 3, 5, 0, 1, msg, "");
	return 1;
}

// ----- Диалоги -----
stock Bank_ShowMainDialog(playerid)
{
	if(!Bank_CanUseServices(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Услуги доступны только внутри отделения банка.");
		return 0;
	}
	ShowPlayerDialog(playerid, DIALOG_BR_BANK_MAIN, DIALOG_STYLE_LIST,
		"{00FF00}Банк",
		CAR_CLR_WHITE "Мои счета\n"\
		CAR_CLR_WHITE "Открыть новый счет",
		"Выбрать", "Отмена");
	return 1;
}

stock Bank_ShowCreateAccountDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_BR_BANK_CREATE, DIALOG_STYLE_INPUT,
		CAR_DLG_PREFIX "Создание счета",
		CAR_CLR_WHITE "Для того, чтобы создать новый банковский счет необходимо придумать \
для него любое понравившееся название, а затем ввести его в диалоговое поле ниже.\n\n"\
		CAR_CLR_GOLD "Примечание: {FFFFFF}доступная длина для названия нового банковского счета — \
от 3 до 20 символов.",
		"Далее", "Назад");
	return 1;
}

stock Bank_ShowAccountsDialog(playerid)
{
	new body[512], line[64];
	format(body, sizeof body, "{99CC00}Основной счет\n");
	for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
	{
		if(!Bank_IsValidExtraSlot(playerid, i)) continue;
		format(line, sizeof line, "%s - №%d\n",
			g_BankExtraAccount[playerid][i][BEA_NAME], g_BankExtraAccount[playerid][i][BEA_SQL_ID]);
		strcat(body, line);
	}
	Bank_RebuildExtraListMap(playerid);
	DeletePVar(playerid, BANK_PVAR_ACC_CREATE_ROW);

	ShowPlayerDialog(playerid, DIALOG_BR_BANK_ACCOUNTS, DIALOG_STYLE_LIST,
		"{FFCD00}Ваши счета", body, "Операции", "Назад");
	return 1;
}

stock Bank_ShowAtmMainDialog(playerid)
{
	SetPVarInt(playerid, BANK_PVAR_ATM_DIALOG_OPEN, 1);
	ShowPlayerDialog(playerid, DIALOG_BR_ATM_MAIN, DIALOG_STYLE_LIST,
		CAR_DLG_PREFIX "Банкомат",
		"1. " CAR_CLR_LABEL "Снять с банковского счета\n"\
		"2. " CAR_CLR_LABEL "Положить на банковский счет\n"\
		"3. " CAR_CLR_LABEL "Баланс банковского счета\n"\
		"4. " CAR_CLR_LABEL "Снять со счета предприятия\n"\
		"5. " CAR_CLR_LABEL "Положить на счет предприятия\n"\
		"6. " CAR_CLR_LABEL "Пополнить мобильный телефон\n"\
		"7. " CAR_CLR_LABEL "Безналичный перевод\n"\
		"8. " CAR_CLR_LABEL "Оплата штрафа\n"\
		"9. " CAR_CLR_LABEL "Благотворительность",
		"Выбрать", "Выйти");
	return 1;
}

stock Bank_ShowAtmSumDialog(playerid, bool:is_take, bool:is_biz = false)
{
	new dlg = is_take ? DIALOG_BR_ATM_TAKE_SUM : DIALOG_BR_ATM_PUT_SUM;
	if(is_biz) dlg = is_take ? DIALOG_BR_ATM_BIZ_TAKE_SUM : DIALOG_BR_ATM_BIZ_PUT_SUM;
	DeletePVar(playerid, BANK_PVAR_SUB_OP);
	SetPVarInt(playerid, is_biz ? BANK_PVAR_ATM_BIZ_TAKE : BANK_PVAR_ATM_TAKE, is_take ? 1 : 0);
	ShowPlayerDialog(playerid, dlg, DIALOG_STYLE_LIST,
		CAR_DLG_PREFIX "Выберите сумму",
		"1. " CAR_CLR_LABEL "100 руб\n"\
		"2. " CAR_CLR_LABEL "200 руб\n"\
		"3. " CAR_CLR_LABEL "500 руб\n"\
		"4. " CAR_CLR_LABEL "1000 руб\n"\
		"5. " CAR_CLR_LABEL "2000 руб\n"\
		"6. " CAR_CLR_LABEL "5000 руб\n"\
		"7. " CAR_CLR_LABEL "10000 руб\n"\
		"8. " CAR_CLR_LABEL "Другая сумма...",
		is_take ? ("Снять") : ("Положить"),
		"Назад");
	return 1;
}

stock Bank_OpenRentPayment(playerid)
{
	return RentPay_ShowMainDialog(playerid);
}

stock Bank_OpenMenu(playerid, bool:from_pickup = false)
{
	if(!Bank_CanUseServices(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Подойдите к стойке в отделении банка.");
		return 0;
	}
	if(from_pickup)
	{
		Bank_TryUnlockInteract(playerid);
		if(g_BankPointLock[playerid])
		{
			SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Отойдите от стойки и подойдите снова.");
			return 0;
		}
	}
	return Bank_ShowMainDialog(playerid);
}

stock bool:Bank_HandleServicePickup(playerid, branch, point_idx)
{
	if(point_idx < 0 || point_idx >= BANK_SERVICE_POINT_COUNT) return false;
	Bank_TryUnlockInteract(playerid);
	if(g_BankPointLock[playerid]) return true;

	g_BankPlayerBranch[playerid] = branch;
	Bank_SetInteractLock(playerid,
		BankServicePos[point_idx][0], BankServicePos[point_idx][1], BankServicePos[point_idx][2]);
	Bank_OpenMenu(playerid, false);
	return true;
}

stock bool:Bank_HandlePaymentPickup(playerid, branch, point_idx)
{
	if(point_idx < 0 || point_idx >= BANK_PAYMENT_POINT_COUNT) return false;
	Bank_TryUnlockInteract(playerid);
	if(g_BankPointLock[playerid]) return true;

	g_BankPlayerBranch[playerid] = branch;
	Bank_SetInteractLock(playerid,
		BankPaymentPos[point_idx][0], BankPaymentPos[point_idx][1], BankPaymentPos[point_idx][2]);
	Bank_OpenRentPayment(playerid);
	return true;
}

stock bool:Bank_IsNumericString(const str[])
{
	if(!str[0]) return false;
	for(new i = 0; str[i]; i++)
		if(str[i] < '0' || str[i] > '9') return false;
	return true;
}

stock bool:Bank_IsValidAccountName(const name[])
{
	new len = strlen(name);
	if(len < BANK_ACCOUNT_NAME_MIN || len > BANK_ACCOUNT_NAME_LEN) return false;
	for(new i = 0; name[i]; i++)
	{
		if(name[i] == ' ') continue;
		if('0' <= name[i] <= '9') continue;
		if('A' <= name[i] <= 'Z') continue;
		if('a' <= name[i] <= 'z') continue;
		if(name[i] >= 192) continue;
		return false;
	}
	return true;
}

stock bool:Bank_IsValidPin(const pin[])
{
	new len = strlen(pin);
	if(len < BANK_PIN_MIN_LEN || len > BANK_PIN_LEN) return false;
	return Bank_IsNumericString(pin);
}

stock Bank_GetExtraSlot(playerid)
{
	new slot = GetPVarInt(playerid, BANK_PVAR_USE_SLOT);
	if(!Bank_IsValidExtraSlot(playerid, slot)) return -1;
	return slot;
}

stock Bank_ExtraSaveBalance(playerid, slot)
{
	if(!Bank_IsValidExtraSlot(playerid, slot)) return 0;
	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `bank_accounts` SET `balance`=%d WHERE `id`=%d AND `uid`=%d LIMIT 1",
		g_BankExtraAccount[playerid][slot][BEA_BALANCE],
		g_BankExtraAccount[playerid][slot][BEA_SQL_ID], Player[playerid][pID]);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Bank_ExtraLog(acc_id, playerid, const desc[])
{
	new ip[16];
	GetPlayerIp(playerid, ip, sizeof ip);
	new q[220];
	mysql_format(db_handle, q, sizeof q,
		"INSERT INTO `bank_accounts_log` (`acc_id`,`uip`,`time`,`description`) VALUES (%d,'%e',%d,'%e')",
		acc_id, ip, gettime(), desc);
	mysql_tquery(db_handle, q, "", "");
}

stock Bank_ShowSubOperations(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_BR_BANK_SUB_OPS, DIALOG_STYLE_LIST,
		CAR_DLG_PREFIX "Операции",
		CAR_CLR_WHITE "Информация о банковском счете\n"\
		CAR_CLR_WHITE "Посмотреть историю операций\n"\
		CAR_CLR_WHITE "Снять денежные средства со счета\n"\
		CAR_CLR_WHITE "Положить денежные средства на счет\n"\
		CAR_CLR_WHITE "Перевести денежные средства на другой счет\n"\
		CAR_CLR_WHITE "Изменить название банковского счета\n"\
		CAR_CLR_WHITE "Изменить PIN-код от банковского счета",
		"Выбрать", "Назад");
}

stock Bank_ShowSubInfo(playerid, slot)
{
	new info[256];
	format(info, sizeof info,
		CAR_CLR_WHITE "| Номер счета: " CAR_CLR_GOLD "№%d.\n"\
		CAR_CLR_WHITE "| Наименование счета: " CAR_CLR_GOLD "%s.\n"\
		CAR_CLR_WHITE "| Состояние счета: " CAR_CLR_GOLD "%d рублей.",
		g_BankExtraAccount[playerid][slot][BEA_SQL_ID],
		g_BankExtraAccount[playerid][slot][BEA_NAME],
		g_BankExtraAccount[playerid][slot][BEA_BALANCE]);
	ShowPlayerDialog(playerid, DIALOG_BR_BANK_SUB_INFO, DIALOG_STYLE_MSGBOX,
		CAR_DLG_PREFIX "Информация", info, "Назад", "");
}

stock Bank_ShowSubHistory(playerid, slot)
{
	if(!Bank_IsValidExtraSlot(playerid, slot)) return 0;
	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"SELECT FROM_UNIXTIME(`time`,'%%d.%%m.%%Y %%H:%%i') AS dt, `description` FROM `bank_accounts_log` \
		WHERE `acc_id`=%d ORDER BY `id` DESC LIMIT 10",
		g_BankExtraAccount[playerid][slot][BEA_SQL_ID]);
	mysql_tquery(db_handle, q, "Bank_OnExtraHistoryLoaded", "dd", playerid, slot);
	return 1;
}

stock Bank_ExtraWithdraw(playerid, slot, sum)
{
	if(sum <= 0 || sum > BANK_SUB_MAX_SUM) return 0;
	new fee = Bank_CalcFee(sum, BANK_WITHDRAW_FEE_PC);
	new need = sum + fee;
	if(g_BankExtraAccount[playerid][slot][BEA_BALANCE] < need)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств (комиссия 1.5%).");
		return 0;
	}
	g_BankExtraAccount[playerid][slot][BEA_BALANCE] -= need;
	Bank_ExtraSaveBalance(playerid, slot);
	SetPVarInt(playerid, "bank_no_money_notify", 1);
	GivePlayerMoneyEx(playerid, sum);
	DeletePVar(playerid, "bank_no_money_notify");
	new logd[48], msg[96];
	format(logd, sizeof logd, "Снятие %d руб.", sum);
	Bank_ExtraLog(g_BankExtraAccount[playerid][slot][BEA_SQL_ID], playerid, logd);
	format(msg, sizeof msg, "{00FF00}Снято %d руб. Комиссия: %d руб.", sum, fee);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

stock Bank_ExtraDeposit(playerid, slot, sum)
{
	if(sum <= 0 || sum > BANK_SUB_MAX_SUM) return 0;
	if(Player[playerid][pMoney] < sum)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно наличных.");
		return 0;
	}
	new fee = Bank_CalcFee(sum, BANK_DEPOSIT_FEE_PC);
	new credit = sum - fee;
	SetPVarInt(playerid, "bank_no_money_notify", 1);
	GivePlayerMoneyEx(playerid, -sum);
	DeletePVar(playerid, "bank_no_money_notify");
	g_BankExtraAccount[playerid][slot][BEA_BALANCE] += credit;
	Bank_ExtraSaveBalance(playerid, slot);
	new logd[48], msg[96];
	format(logd, sizeof logd, "Пополнение %d руб.", credit);
	Bank_ExtraLog(g_BankExtraAccount[playerid][slot][BEA_SQL_ID], playerid, logd);
	format(msg, sizeof msg, "{00FF00}Внесено %d руб. Комиссия: %d руб.", credit, fee);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

stock Bank_SyncExtraBalanceFromDb(playerid, slot)
{
	if(!Bank_IsValidExtraSlot(playerid, slot)) return 0;
	new q[96];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `balance` FROM `bank_accounts` WHERE `id`=%d LIMIT 1",
		g_BankExtraAccount[playerid][slot][BEA_SQL_ID]);
	mysql_tquery(db_handle, q, "Bank_OnExtraBalanceSynced", "dd", playerid, slot);
	return 1;
}

forward Bank_OnExtraBalanceSynced(playerid, slot);
public Bank_OnExtraBalanceSynced(playerid, slot)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!Bank_IsValidExtraSlot(playerid, slot)) return 0;
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows > 0)
		g_BankExtraAccount[playerid][slot][BEA_BALANCE] = cache_get_row_int(0, 0, db_handle);
	return 1;
}

stock Bank_CreditExtraAccountMemory(acc_sql_id, sum)
{
	for(new p = 0; p < MAX_PLAYERS; p++)
	{
		if(!IsPlayerConnected(p) || Player[p][pID] <= 0) continue;
		for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
		{
			if(g_BankExtraAccount[p][i][BEA_SQL_ID] != acc_sql_id) continue;
			g_BankExtraAccount[p][i][BEA_BALANCE] += sum;
			return p;
		}
	}
	return INVALID_PLAYER_ID;
}

stock Bank_ExtraTransfer(playerid, slot, target_acc, sum)
{
	if(sum <= 0 || sum > BANK_SUB_MAX_SUM) return 0;
	if(target_acc == g_BankExtraAccount[playerid][slot][BEA_SQL_ID])
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Нельзя перевести на тот же счёт.");
		return 0;
	}
	if(g_BankExtraAccount[playerid][slot][BEA_BALANCE] < sum)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств на счёте.");
		return 0;
	}
	SetPVarInt(playerid, "BankTransferSum", sum);
	SetPVarInt(playerid, BANK_PVAR_EXTRA_TARGET_ACC, target_acc);

	new q[96];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `id` FROM `bank_accounts` WHERE `id`=%d LIMIT 1", target_acc);
	mysql_tquery(db_handle, q, "Bank_OnTransferTargetChecked", "dd", playerid, slot);
	return 1;
}

public Bank_OnTransferTargetChecked(playerid, slot)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new sum = GetPVarInt(playerid, "BankTransferSum");
	new target = GetPVarInt(playerid, BANK_PVAR_EXTRA_TARGET_ACC);

	if(!Bank_IsValidExtraSlot(playerid, slot))
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Ошибка счёта отправителя.");
		return 0;
	}
	new rows, fields;
	cache_get_data(rows, fields, db_handle);
	if(rows == 0)
	{
		new err[96];
		format(err, sizeof err, "{FFCD00}[Банк] {FFFFFF}Счёт получателя №%d не найден.", target);
		SendClientMessage(playerid, COLOR_WHITE, err);
		Bank_ShowSubOperations(playerid);
		return 0;
	}
	if(g_BankExtraAccount[playerid][slot][BEA_BALANCE] < sum)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств на счёте.");
		return 0;
	}

	g_BankExtraAccount[playerid][slot][BEA_BALANCE] -= sum;
	Bank_ExtraSaveBalance(playerid, slot);

	new q[192];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `bank_accounts` SET `balance`=`balance`+%d WHERE `id`=%d LIMIT 1",
		sum, target);
	mysql_tquery(db_handle, q, "Bank_OnExtraTransferDone", "dd", playerid, slot);
	return 1;
}

forward Bank_OnExtraTransferDone(playerid, slot);
public Bank_OnExtraTransferDone(playerid, slot)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new sum = GetPVarInt(playerid, "BankTransferSum");
	new target = GetPVarInt(playerid, BANK_PVAR_EXTRA_TARGET_ACC);
	new from_acc = 0;

	if(!Bank_IsValidExtraSlot(playerid, slot))
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Ошибка счёта.");
		return 0;
	}
	from_acc = g_BankExtraAccount[playerid][slot][BEA_SQL_ID];

	if(cache_affected_rows() == 0)
	{
		g_BankExtraAccount[playerid][slot][BEA_BALANCE] += sum;
		Bank_ExtraSaveBalance(playerid, slot);
		new err[96];
		format(err, sizeof err, "{FFCD00}[Банк] {FFFFFF}Не удалось зачислить на счёт №%d. Средства возвращены.", target);
		SendClientMessage(playerid, COLOR_WHITE, err);
		Bank_ShowSubOperations(playerid);
		return 0;
	}

	new recv_player = Bank_CreditExtraAccountMemory(target, sum);
	if(recv_player != INVALID_PLAYER_ID && recv_player != playerid)
	{
		new msg[96];
		format(msg, sizeof msg, "{00FF00}[Банк] {FFFFFF}На ваш счёт №%d поступило %d руб.", target, sum);
		SendClientMessage(recv_player, COLOR_WHITE, msg);
	}
	else
	{
		for(new i = 0; i < BANK_MAX_EXTRA_ACCOUNTS; i++)
		{
			if(g_BankExtraAccount[playerid][i][BEA_SQL_ID] == target)
			{
				Bank_SyncExtraBalanceFromDb(playerid, i);
				break;
			}
		}
	}

	new log_out[64], log_in[64];
	format(log_out, sizeof log_out, "Перевод на №%d: %d руб.", target, sum);
	format(log_in, sizeof log_in, "Поступление с №%d: %d руб.", from_acc, sum);
	Bank_ExtraLog(from_acc, playerid, log_out);
	Bank_ExtraLog(target, playerid, log_in);

	new ok[96];
	format(ok, sizeof ok, "{00FF00}[Банк] {FFFFFF}Перевод на счёт №%d выполнен.", target);
	SendClientMessage(playerid, COLOR_WHITE, ok);
	Bank_ShowSubOperations(playerid);
	return 1;
}

public Bank_OnExtraHistoryLoaded(playerid, slot)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new body[900], line[96];
	format(body, sizeof body, CAR_CLR_WHITE "Дата\t" CAR_CLR_GOLD "Операция\n");
	if(cache_num_rows() == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_BR_BANK_SUB_HISTORY, DIALOG_STYLE_MSGBOX,
			CAR_DLG_PREFIX "История", CAR_CLR_WHITE "История операций пуста", "Назад", "");
		#pragma unused slot
		return 1;
	}
	for(new i = 0; i < cache_num_rows(); i++)
	{
		new dt[32], desc[64];
		cache_get_field_content(i, "dt", dt, db_handle, 31);
		cache_get_field_content(i, "description", desc, db_handle, 63);
		format(line, sizeof line, CAR_CLR_WHITE "%s\t" CAR_CLR_GOLD "%s\n", dt, desc);
		strcat(body, line);
	}
	ShowPlayerDialog(playerid, DIALOG_BR_BANK_SUB_HISTORY, DIALOG_STYLE_TABLIST_HEADERS,
		CAR_DLG_PREFIX "История", body, "Назад", "");
	#pragma unused slot
	return 1;
}

stock Bank_CalcFee(sum, percent_x10)
{
	if(sum <= 0) return 0;
	return (sum * percent_x10 + 500) / 1000;
}

stock Bank_GetPlayerBusiness(playerid)
{
	new biz = Player[playerid][pBusiness];
	if(biz < 0 || biz >= g_business_loaded) return -1;
	if(GetBusinessData(biz, B_OWNER_ID) != Player[playerid][pID]) return -1;
	return biz;
}

stock Bank_AtmWithdrawMain(playerid, sum)
{
	if(sum <= 0) return 0;
	new fee = Bank_CalcFee(sum, BANK_WITHDRAW_FEE_PC);
	if(Player[playerid][pBank] < sum + fee)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств на счёте (с учётом комиссии 1.5%).");
		return 0;
	}
	Player[playerid][pBank] -= (sum + fee);
	SetPVarInt(playerid, "bank_no_money_notify", 1);
	GivePlayerMoneyEx(playerid, sum);
	DeletePVar(playerid, "bank_no_money_notify");
	Bank_SaveMainMoney(playerid);
	new msg[96];
	format(msg, sizeof msg, "{00FF00}Снято %d руб. Комиссия: %d руб.", sum, fee);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

stock Bank_AtmDepositMain(playerid, sum)
{
	if(sum <= 0) return 0;
	new fee = Bank_CalcFee(sum, BANK_DEPOSIT_FEE_PC);
	if(Player[playerid][pMoney] < sum)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно наличных.");
		return 0;
	}
	SetPVarInt(playerid, "bank_no_money_notify", 1);
	GivePlayerMoneyEx(playerid, -sum);
	DeletePVar(playerid, "bank_no_money_notify");
	Player[playerid][pBank] += (sum - fee);
	Bank_SaveMainMoney(playerid);
	new msg[96];
	format(msg, sizeof msg, "{00FF00}Внесено %d руб. Комиссия: %d руб.", sum - fee, fee);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

stock Bank_AtmWithdrawBiz(playerid, sum)
{
	new biz = Bank_GetPlayerBusiness(playerid);
	if(biz == -1) return 0;
	if(sum <= 0) return 0;
	if(GetBusinessData(biz, B_BALANCE) < sum)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}На счёте предприятия недостаточно средств.");
		return 0;
	}
	AddBusinessData(biz, B_BALANCE, -, sum);
	SetPVarInt(playerid, "bank_no_money_notify", 1);
	GivePlayerMoneyEx(playerid, sum);
	DeletePVar(playerid, "bank_no_money_notify");
	Bank_SaveBusinessBalance(biz);
	SendClientMessage(playerid, COLOR_WHITE, "{00FF00}Средства предприятия сняты на руки.");
	return 1;
}

stock Bank_AtmDepositBiz(playerid, sum)
{
	new biz = Bank_GetPlayerBusiness(playerid);
	if(biz == -1) return 0;
	if(sum <= 0) return 0;
	if(Player[playerid][pMoney] < sum)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно наличных.");
		return 0;
	}
	SetPVarInt(playerid, "bank_no_money_notify", 1);
	GivePlayerMoneyEx(playerid, -sum);
	DeletePVar(playerid, "bank_no_money_notify");
	AddBusinessData(biz, B_BALANCE, +, sum);
	Bank_SaveBusinessBalance(biz);
	SendClientMessage(playerid, COLOR_WHITE, "{00FF00}Наличные внесены на счёт предприятия.");
	return 1;
}

stock Bank_HandleAtmSumList(playerid, response, listitem, bool:is_biz)
{
	if(!response)
	{
		Bank_ShowAtmMainDialog(playerid);
		return 1;
	}
	new is_take = GetPVarInt(playerid, is_biz ? BANK_PVAR_ATM_BIZ_TAKE : BANK_PVAR_ATM_TAKE);
	if(listitem >= 0 && listitem <= 6)
	{
		new sum = g_BankAtmPresetSum[listitem];
		if(is_biz)
		{
			if(is_take) Bank_AtmWithdrawBiz(playerid, sum);
			else Bank_AtmDepositBiz(playerid, sum);
		}
		else
		{
			if(is_take) Bank_AtmWithdrawMain(playerid, sum);
			else Bank_AtmDepositMain(playerid, sum);
		}
		Bank_ShowAtmMainDialog(playerid);
		return 1;
	}
	new other_dlg;
	if(is_biz)
		other_dlg = is_take ? DIALOG_BR_ATM_BIZ_TAKE_OTHER : DIALOG_BR_ATM_BIZ_PUT_OTHER;
	else
		other_dlg = is_take ? DIALOG_BR_ATM_TAKE_OTHER : DIALOG_BR_ATM_PUT_OTHER;
	ShowPlayerDialog(playerid, other_dlg, DIALOG_STYLE_INPUT,
		CAR_DLG_PREFIX "Другая сумма",
		CAR_CLR_WHITE "Укажите сумму:\n" CAR_CLR_DIM "Комиссия снятия 1.5%, внесения 1%.",
		is_take ? ("Снять") : ("Положить"), "Назад");
	return 1;
}

stock bool:Bank_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(RentPay_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
		return true;

	switch(dialogid)
	{
		case DIALOG_BR_BANK_MAIN:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0:
				{
					SetTimerEx("Bank_DelayedOpenAccounts", BANK_DLG_DELAY_MS, false, "i", playerid);
				}
				case 1:
				{
					if(Bank_CountExtraAccounts(playerid) >= BANK_MAX_EXTRA_ACCOUNTS)
					{
						SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Достигнут лимит дополнительных счетов.");
						return true;
					}
					Bank_ShowCreateAccountDialog(playerid);
				}
			}
			return true;
		}
		case DIALOG_BR_BANK_CREATE:
		{
			if(!response) { Bank_ShowMainDialog(playerid); return true; }
			if(!Bank_IsValidAccountName(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Название: от 3 до 20 символов (буквы и цифры).");
				Bank_ShowCreateAccountDialog(playerid);
				return true;
			}
			SetPVarString(playerid, BANK_PVAR_NEW_ACC_NAME, inputtext);
			new q[256];
			mysql_format(db_handle, q, sizeof q,
				"INSERT INTO `bank_accounts` (`uid`,`name`,`balance`,`pin`,`reg_time`) VALUES (%d,'%e',0,'%e',%d)",
				Player[playerid][pID], inputtext, BANK_DEFAULT_PIN, gettime());
			mysql_tquery(db_handle, q, "Bank_OnAccountCreated", "d", playerid);
			return true;
		}
		case DIALOG_BR_BANK_ACCOUNTS:
		{
			if(!response)
			{
				if(g_BankAccBackIgnore[playerid] > 0)
				{
					g_BankAccBackIgnore[playerid]--;
					return true;
				}
				Bank_ShowMainDialog(playerid);
				return true;
			}
			g_BankAccBackIgnore[playerid] = 0;
			if(listitem == 0)
			{
				Bank_ShowAtmMainDialog(playerid);
				return true;
			}
			new map_idx = listitem - 1;
			new slot = Bank_GetExtraSlotByListIndex(playerid, map_idx);
			if(slot < 0)
			{
				Bank_LoadExtraAccounts(playerid, true);
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Обновление списка счетов...");
				return true;
			}
			SetPVarInt(playerid, BANK_PVAR_USE_SLOT, slot);
			ShowPlayerDialog(playerid, DIALOG_BR_BANK_PIN, DIALOG_STYLE_PASSWORD,
				CAR_DLG_PREFIX "Авторизация",
				CAR_CLR_WHITE "Для того, чтобы получить полный доступ от выбранного банковского счета \
необходимо указать специальный секретный PIN-код и ввести его в диалоговое поле ниже.\n\n"\
				CAR_CLR_GOLD "Примечание: {FFFFFF}без наличия специального секретного PIN-кода вход в меню \
управления выбранного банковского счета будет недоступен.",
				"Далее", "Отмена");
			return true;
		}
		case DIALOG_BR_BANK_PIN:
		{
			if(!response) { Bank_ShowAccountsDialog(playerid); return true; }
			new slot = GetPVarInt(playerid, BANK_PVAR_USE_SLOT);
			if(!Bank_IsValidExtraSlot(playerid, slot)) return true;
			new pin_ref[BANK_PIN_LEN + 1];
			format(pin_ref, sizeof pin_ref, "%s", g_BankExtraAccount[playerid][slot][BEA_PIN]);
			if(!pin_ref[0]) format(pin_ref, sizeof pin_ref, BANK_DEFAULT_PIN);
			if(strcmp(inputtext, pin_ref, true))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Неверный PIN-код. По умолчанию: 0000");
				return true;
			}
			Bank_ShowSubOperations(playerid);
			return true;
		}
		case DIALOG_BR_BANK_SUB_OPS:
		{
			if(!response) { Bank_ShowAccountsDialog(playerid); return true; }
			new slot = Bank_GetExtraSlot(playerid);
			if(slot < 0) return true;
			switch(listitem)
			{
				case 0: Bank_ShowSubInfo(playerid, slot);
				case 1: Bank_ShowSubHistory(playerid, slot);
				case 2:
					ShowPlayerDialog(playerid, DIALOG_BR_SUB_TAKE, DIALOG_STYLE_INPUT,
						CAR_DLG_PREFIX "Снятие средств",
						CAR_CLR_WHITE "Для того, чтобы снять денежные средства со своего банковского счета \
необходимо указать необходимую сумму в диалоговое поле ниже.\n\n"\
						CAR_CLR_GOLD "Примечание:\n{FFFFFF}- максимальная сумма для снятия — 10.000.000 рублей.\n"\
						"- Комиссия на снятие 1.5 процента",
						"Далее", "Назад");
				case 3:
					ShowPlayerDialog(playerid, DIALOG_BR_SUB_PUT, DIALOG_STYLE_INPUT,
						CAR_DLG_PREFIX "Положить средства",
						CAR_CLR_WHITE "Для того, чтобы положить денежные средства на свой банковский счет \
необходимо указать необходимую сумму в диалоговое поле ниже.\n\n"\
						CAR_CLR_GOLD "Примечание:\n{FFFFFF}- максимальная сумма для пополнения — 10.000.000 рублей.\n"\
						"- Комиссия на пополнение 1 процент",
						"Далее", "Назад");
				case 4:
					ShowPlayerDialog(playerid, DIALOG_BR_SUB_TRANSFER_1, DIALOG_STYLE_INPUT,
						CAR_DLG_PREFIX "Перевод средств",
						CAR_CLR_WHITE "Для того, чтобы перевести свои денежные средства на другой банковский счет \
необходимо указать специальный номер счета, на который требуется осуществить перевод \
в диалоговое поле ниже.\n\n"\
						CAR_CLR_GOLD "Примечание: {FFFFFF}максимальная длина номера банковского счета \
не может состоять более чем из 8-ми цифр.",
						"Далее", "Назад");
				case 5:
					ShowPlayerDialog(playerid, DIALOG_BR_BANK_RENAME, DIALOG_STYLE_INPUT,
						CAR_DLG_PREFIX "Переименовать счет",
						CAR_CLR_WHITE "Для того, чтобы переименовать выбранный банковский счет необходимо придумать, \
а затем ввести новое для него название в диалоговое поле ниже.\n\n"\
						CAR_CLR_GOLD "Примечание: {FFFFFF}доступная длина для названия — от 3 до 20 символов.",
						"Далее", "Назад");
				case 6:
					ShowPlayerDialog(playerid, DIALOG_BR_BANK_CHANGE_PIN, DIALOG_STYLE_INPUT,
						CAR_DLG_PREFIX "Изменение PIN-кода",
						CAR_CLR_WHITE "Для того, чтобы изменить PIN-код от выбранного банковского счета необходимо \
придумать, а затем ввести новый PIN-код в диалоговое поле ниже.\n\n"\
						CAR_CLR_GOLD "Примечание: {FFFFFF}доступная длина для нового PIN-кода — от 4 до 8 цифр.",
						"Далее", "Назад");
			}
			return true;
		}
		case DIALOG_BR_BANK_SUB_INFO:
		{
			Bank_ShowSubOperations(playerid);
			return true;
		}
		case DIALOG_BR_BANK_SUB_HISTORY:
		{
			Bank_ShowSubOperations(playerid);
			return true;
		}
		case DIALOG_BR_SUB_TAKE:
		{
			if(!response) { Bank_ShowSubOperations(playerid); return true; }
			new slot = Bank_GetExtraSlot(playerid);
			if(slot < 0) return true;
			new sum = strval(inputtext);
			if(sum <= 0 || sum > BANK_SUB_MAX_SUM || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма (макс. 10.000.000).");
				return true;
			}
			Bank_ExtraWithdraw(playerid, slot, sum);
			Bank_ShowSubOperations(playerid);
			return true;
		}
		case DIALOG_BR_SUB_PUT:
		{
			if(!response) { Bank_ShowSubOperations(playerid); return true; }
			new slot = Bank_GetExtraSlot(playerid);
			if(slot < 0) return true;
			new sum = strval(inputtext);
			if(sum <= 0 || sum > BANK_SUB_MAX_SUM || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма (макс. 10.000.000).");
				return true;
			}
			Bank_ExtraDeposit(playerid, slot, sum);
			Bank_ShowSubOperations(playerid);
			return true;
		}
		case DIALOG_BR_SUB_TRANSFER_1:
		{
			if(!response) { Bank_ShowSubOperations(playerid); return true; }
			if(!Bank_IsNumericString(inputtext) || strlen(inputtext) < 1 || strlen(inputtext) > BANK_SUB_TRANSFER_ACC_MAX)
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Номер счёта: до 8 цифр.");
				return true;
			}
			new target = strval(inputtext);
			if(target <= 0)
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректный номер счёта.");
				return true;
			}
			SetPVarInt(playerid, BANK_PVAR_EXTRA_TARGET_ACC, target);
			new body[128];
			format(body, sizeof body,
				CAR_CLR_WHITE "Перевод на счёт №%d\n\nУкажите сумму (макс. 10.000.000):", target);
			ShowPlayerDialog(playerid, DIALOG_BR_SUB_TRANSFER_2, DIALOG_STYLE_INPUT,
				CAR_DLG_PREFIX "Перевод средств", body, "Далее", "Назад");
			return true;
		}
		case DIALOG_BR_SUB_TRANSFER_2:
		{
			if(!response) { Bank_ShowSubOperations(playerid); return true; }
			new slot = Bank_GetExtraSlot(playerid);
			if(slot < 0) return true;
			new sum = strval(inputtext);
			if(sum <= 0 || sum > BANK_SUB_MAX_SUM || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма.");
				return true;
			}
			Bank_ExtraTransfer(playerid, slot, GetPVarInt(playerid, BANK_PVAR_EXTRA_TARGET_ACC), sum);
			return true;
		}
		case DIALOG_BR_BANK_RENAME:
		{
			if(!response) { Bank_ShowSubOperations(playerid); return true; }
			new slot = Bank_GetExtraSlot(playerid);
			if(slot < 0) return true;
			if(!Bank_IsValidAccountName(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Название: от 3 до 20 символов.");
				return true;
			}
			format(g_BankExtraAccount[playerid][slot][BEA_NAME], BANK_ACCOUNT_NAME_LEN + 1, "%s", inputtext);
			new q[192];
			mysql_format(db_handle, q, sizeof q,
				"UPDATE `bank_accounts` SET `name`='%e' WHERE `id`=%d AND `uid`=%d LIMIT 1",
				inputtext, g_BankExtraAccount[playerid][slot][BEA_SQL_ID], Player[playerid][pID]);
			mysql_tquery(db_handle, q, "", "");
			Bank_ExtraLog(g_BankExtraAccount[playerid][slot][BEA_SQL_ID], playerid, "Переименование счёта");
			SendClientMessage(playerid, COLOR_WHITE, "{00FF00}[Банк] {FFFFFF}Название счёта изменено.");
			Bank_ShowSubOperations(playerid);
			return true;
		}
		case DIALOG_BR_BANK_CHANGE_PIN:
		{
			if(!response) { Bank_ShowSubOperations(playerid); return true; }
			new slot = Bank_GetExtraSlot(playerid);
			if(slot < 0) return true;
			if(!Bank_IsValidPin(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}PIN: от 4 до 8 цифр.");
				return true;
			}
			format(g_BankExtraAccount[playerid][slot][BEA_PIN], BANK_PIN_LEN + 1, "%s", inputtext);
			new q[192];
			mysql_format(db_handle, q, sizeof q,
				"UPDATE `bank_accounts` SET `pin`='%e' WHERE `id`=%d AND `uid`=%d LIMIT 1",
				inputtext, g_BankExtraAccount[playerid][slot][BEA_SQL_ID], Player[playerid][pID]);
			mysql_tquery(db_handle, q, "", "");
			Bank_ExtraLog(g_BankExtraAccount[playerid][slot][BEA_SQL_ID], playerid, "Смена PIN-кода");
			SendClientMessage(playerid, COLOR_WHITE, "{00FF00}[Банк] {FFFFFF}PIN-код изменён.");
			Bank_ShowSubOperations(playerid);
			return true;
		}
		case DIALOG_BR_ATM_MAIN:
		{
			if(!response)
			{
				if(g_BankAtmBackIgnore[playerid] > 0)
				{
					g_BankAtmBackIgnore[playerid]--;
					return true;
				}
				if(g_BankAtmStandalone[playerid])
				{
					Bank_MarkAtmDialogClosed(playerid);
					return true;
				}
				Bank_OpenAccountsList(playerid);
				return true;
			}
			g_BankAtmBackIgnore[playerid] = 0;
			switch(listitem)
			{
				case 0: Bank_ShowAtmSumDialog(playerid, true, false);
				case 1: Bank_ShowAtmSumDialog(playerid, false, false);
				case 2:
				{
					new info[128];
					format(info, sizeof info,
						CAR_CLR_WHITE "На вашем банковском счёте\n" CAR_CLR_GOLD "%d руб.",
						Player[playerid][pBank]);
					ShowPlayerDialog(playerid, DIALOG_BR_ATM_BALANCE, DIALOG_STYLE_MSGBOX,
						CAR_DLG_PREFIX "Баланс счета", info, "Назад", "Выйти");
				}
				case 3:
				{
					if(Bank_GetPlayerBusiness(playerid) == -1)
						SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}У вас нет предприятия.");
					else Bank_ShowAtmSumDialog(playerid, true, true);
				}
				case 4:
				{
					if(Bank_GetPlayerBusiness(playerid) == -1)
						SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}У вас нет предприятия.");
					else Bank_ShowAtmSumDialog(playerid, false, true);
				}
				case 5:
				{
					if(!Player[playerid][pPhoneOwned])
						SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Купите телефон в салоне связи.");
					else
						ShowPlayerDialog(playerid, DIALOG_BR_ATM_PHONE, DIALOG_STYLE_INPUT,
							CAR_DLG_PREFIX "Пополнение мобильного телефона",
							CAR_CLR_WHITE "Сумма с основного счёта.\n"\
							CAR_CLR_DIM "100 руб. = 1 ед. (1 мин. разговора).\n"\
							CAR_CLR_DIM "Пример: 1000 руб. = 10 мин.",
							"Готово", "Назад");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_BR_ATM_TRANSFER_1, DIALOG_STYLE_INPUT,
						CAR_DLG_PREFIX "Безналичный перевод",
						CAR_CLR_WHITE "Укажите номер банковского счёта:",
						"Далее", "Отмена");
				}
				case 7:
				{
					ShowPlayerDialog(playerid, DIALOG_BR_ATM_FINE, DIALOG_STYLE_MSGBOX,
						CAR_DLG_PREFIX "Оплата штрафа",
						CAR_CLR_WHITE "У вас нет неоплаченных штрафов.",
						"Назад", "");
				}
				case 8:
				{
					ShowPlayerDialog(playerid, DIALOG_BR_ATM_CHARITY, DIALOG_STYLE_INPUT,
						CAR_DLG_PREFIX "Благотворительность",
						CAR_CLR_WHITE "Мы предлагаем вам перечислить любую сумму\n"\
						"на благотворительный счёт государства.\n\n"\
						CAR_CLR_DIM "Список жертвователей: /charity",
						"Внести", "Закрыть");
				}
			}
			return true;
		}
		case DIALOG_BR_ATM_TAKE_SUM: Bank_HandleAtmSumList(playerid, response, listitem, false);
		case DIALOG_BR_ATM_PUT_SUM: Bank_HandleAtmSumList(playerid, response, listitem, false);
		case DIALOG_BR_ATM_BIZ_TAKE_SUM: Bank_HandleAtmSumList(playerid, response, listitem, true);
		case DIALOG_BR_ATM_BIZ_PUT_SUM: Bank_HandleAtmSumList(playerid, response, listitem, true);
		case DIALOG_BR_ATM_BALANCE:
		{
			if(response) Bank_ShowAtmMainDialog(playerid);
			else if(g_BankAtmStandalone[playerid]) Bank_MarkAtmDialogClosed(playerid);
			else Bank_ShowAccountsDialog(playerid);
			return true;
		}
		case DIALOG_BR_ATM_TAKE_OTHER, DIALOG_BR_ATM_PUT_OTHER:
		{
			if(!response)
			{
				Bank_ShowAtmSumDialog(playerid, dialogid == DIALOG_BR_ATM_TAKE_OTHER, false);
				return true;
			}
			new sum = strval(inputtext);
			if(sum <= 0 || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма.");
				return true;
			}
			if(dialogid == DIALOG_BR_ATM_TAKE_OTHER) Bank_AtmWithdrawMain(playerid, sum);
			else Bank_AtmDepositMain(playerid, sum);
			Bank_ShowAtmMainDialog(playerid);
			return true;
		}
		case DIALOG_BR_ATM_BIZ_TAKE_OTHER, DIALOG_BR_ATM_BIZ_PUT_OTHER:
		{
			if(!response) { Bank_ShowAtmSumDialog(playerid, dialogid == DIALOG_BR_ATM_BIZ_TAKE_OTHER, true); return true; }
			new sum = strval(inputtext);
			if(sum <= 0 || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма.");
				return true;
			}
			if(dialogid == DIALOG_BR_ATM_BIZ_TAKE_OTHER) Bank_AtmWithdrawBiz(playerid, sum);
			else Bank_AtmDepositBiz(playerid, sum);
			Bank_ShowAtmMainDialog(playerid);
			return true;
		}
		case DIALOG_BR_ATM_PHONE:
		{
			if(!response) { Bank_ShowAtmMainDialog(playerid); return true; }
			new sum = strval(inputtext);
			if(sum <= 0 || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма.");
				return true;
			}
			if(Player[playerid][pBank] < sum)
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств на основном счёте.");
				return true;
			}
			if(!Phone_AtmTopUp(playerid, sum))
			{
				Bank_ShowAtmMainDialog(playerid);
				return true;
			}
			Bank_ShowAtmMainDialog(playerid);
			return true;
		}
		case DIALOG_BR_ATM_TRANSFER_1:
		{
			if(!response) { Bank_ShowAtmMainDialog(playerid); return true; }
			new target = strval(inputtext);
			if(target <= 0 || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректный номер счёта.");
				return true;
			}
			SetPVarInt(playerid, BANK_PVAR_TRANSFER_ID, target);
			new body[96];
			format(body, sizeof body, CAR_CLR_WHITE "Перевод на счёт №%d\n\nУкажите сумму:", target);
			ShowPlayerDialog(playerid, DIALOG_BR_ATM_TRANSFER_2, DIALOG_STYLE_INPUT,
				CAR_DLG_PREFIX "Безналичный перевод", body, "Перевести", "Отмена");
			return true;
		}
		case DIALOG_BR_ATM_TRANSFER_2:
		{
			if(!response) { Bank_ShowAtmMainDialog(playerid); return true; }
			new sum = strval(inputtext);
			new target = GetPVarInt(playerid, BANK_PVAR_TRANSFER_ID);
			if(sum <= 0 || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма.");
				return true;
			}
			if(Player[playerid][pBank] < sum)
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств.");
				return true;
			}
			if(target == Player[playerid][pID])
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Нельзя перевести на свой же счёт.");
				return true;
			}
			Player[playerid][pBank] -= sum;
			Bank_SaveMainMoney(playerid);
			SetPVarInt(playerid, BANK_PVAR_TRANSFER_ID, target);
			SetPVarInt(playerid, "BankTransferSum", sum);
			new q[192];
			mysql_format(db_handle, q, sizeof q,
				"UPDATE `bank_accounts` SET `balance`=`balance`+%d WHERE `id`=%d LIMIT 1",
				sum, target);
			mysql_tquery(db_handle, q, "Bank_OnTransferToAccount", "d", playerid);
			return true;
		}
		case DIALOG_BR_ATM_CHARITY:
		{
			if(!response) { Bank_ShowAtmMainDialog(playerid); return true; }
			new sum = strval(inputtext);
			if(sum <= 0 || !Bank_IsNumericString(inputtext))
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Некорректная сумма.");
				return true;
			}
			if(Player[playerid][pBank] < sum)
			{
				SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств на счёте.");
				return true;
			}
			Player[playerid][pBank] -= sum;
			Bank_SaveMainMoney(playerid);
			Bank_RecordCharityDonation(playerid, sum);
			SendClientMessage(playerid, COLOR_WHITE, "{00FF00}Спасибо за благотворительный взнос!");
			Bank_ShowAtmMainDialog(playerid);
			return true;
		}
		case DIALOG_BR_CHARITY_TOP:
		{
			return true;
		}
		case DIALOG_BR_ATM_FINE:
		{
			Bank_ShowAtmMainDialog(playerid);
			return true;
		}
	}
	return false;
}

forward Bank_OnAccountCreated(playerid);
public Bank_OnAccountCreated(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new acc_id = cache_insert_id();
	if(acc_id <= 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Ошибка создания счёта. Попробуйте снова.");
		DeletePVar(playerid, BANK_PVAR_NEW_ACC_NAME);
		return 0;
	}

	new acc_name[BANK_ACCOUNT_NAME_LEN + 1];
	GetPVarString(playerid, BANK_PVAR_NEW_ACC_NAME, acc_name, sizeof acc_name);
	DeletePVar(playerid, BANK_PVAR_NEW_ACC_NAME);
	if(!acc_name[0]) format(acc_name, sizeof acc_name, "Счёт");

	Bank_PushExtraAccountLocal(playerid, acc_id, acc_name, 0, BANK_DEFAULT_PIN);
	Bank_RebuildExtraListMap(playerid);
	Bank_ExtraLog(acc_id, playerid, "Открытие счёта");

	SendClientMessage(playerid, COLOR_WHITE,
		"{00FF00}[Банк] {FFFFFF}Счёт открыт. PIN по умолчанию: {FFD700}0000 {FFFFFF}(смена в операциях).");

	Bank_ArmAccountsBackIgnore(playerid);
	Bank_ShowAccountsDialog(playerid);
	Bank_LoadExtraAccounts(playerid, false);
	return 1;
}

forward Bank_OnTransferToAccount(playerid);
public Bank_OnTransferToAccount(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new sum = GetPVarInt(playerid, "BankTransferSum");
	new target = GetPVarInt(playerid, BANK_PVAR_TRANSFER_ID);
	if(cache_affected_rows() > 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{00FF00}[Банк] {FFFFFF}Перевод на счёт выполнен.");
		DeletePVar(playerid, "BankTransferSum");
		Bank_ShowAtmMainDialog(playerid);
		return 1;
	}
	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `players` SET `bank`=`bank`+%d WHERE `id`=%d LIMIT 1", sum, target);
	mysql_tquery(db_handle, q, "Bank_OnTransferToPlayer", "d", playerid);
	return 1;
}

forward Bank_OnTransferToPlayer(playerid);
public Bank_OnTransferToPlayer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new sum = GetPVarInt(playerid, "BankTransferSum");
	DeletePVar(playerid, "BankTransferSum");
	if(cache_affected_rows() > 0)
		SendClientMessage(playerid, COLOR_WHITE, "{00FF00}[Банк] {FFFFFF}Перевод на основной счёт игрока выполнен.");
	else
	{
		Player[playerid][pBank] += sum;
		Bank_SaveMainMoney(playerid);
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Счёт не найден. Средства возвращены.");
	}
	Bank_ShowAtmMainDialog(playerid);
	return 1;
}

stock Bank_PickupMatchesBranch(pickupid, branch, &pickup_kind)
{
	pickup_kind = 0;
	if(pickupid == gBankEnterPickup[branch]) { pickup_kind = 1; return 1; }
	if(pickupid == gBankExitPickupA[branch]) { pickup_kind = 2; return 1; }
	if(pickupid == gBankExitPickupB[branch]) { pickup_kind = 3; return 1; }
	for(new s = 0; s < BANK_SERVICE_POINT_COUNT; s++)
		if(pickupid == gBankServicePickup[branch][s]) { pickup_kind = 4; return 1; }
	for(new p = 0; p < BANK_PAYMENT_POINT_COUNT; p++)
		if(pickupid == gBankPaymentPickup[branch][p]) { pickup_kind = 5; return 1; }
	return 0;
}

stock Bank_OnGameModeInit()
{
	Bank_EnsureTables();
	new label[128];
	for(new i = 0; i < BANK_BRANCH_COUNT; i++)
	{
		new vw = g_BankBranches[i][B_INTERIOR_VW];
		gBankGreenArea[i] = CreateDynamicSphere(
			BankInteriorGreenCenter[0], BankInteriorGreenCenter[1], BankInteriorGreenCenter[2],
			BANK_GREEN_ZONE_RADIUS, vw, BANK_INTERIOR);
		gBankEnterPickup[i] = CreateDynamicPickup(BANK_PICKUP_MODEL, BANK_PICKUP_TYPE,
			g_BankBranches[i][B_ENTER_X], g_BankBranches[i][B_ENTER_Y], g_BankBranches[i][B_ENTER_Z], 0, 0);
		format(label, sizeof label, "{66CCFF}Центральный\n{66CCFF}Банк %s", g_BankEnterCityLabel[i]);
		gBankEnterLabel[i] = CreateDynamic3DTextLabel(label, 0x66CCFFFF,
			g_BankBranches[i][B_ENTER_X], g_BankBranches[i][B_ENTER_Y], g_BankBranches[i][B_ENTER_Z] + 0.7,
			20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
		gBankExitPickupA[i] = CreateDynamicPickup(BANK_PICKUP_MODEL, BANK_PICKUP_TYPE,
			BankInteriorExitA[0], BankInteriorExitA[1], BankInteriorExitA[2], vw, BANK_INTERIOR);
		gBankExitPickupB[i] = CreateDynamicPickup(BANK_PICKUP_MODEL, BANK_PICKUP_TYPE,
			BankInteriorExitB[0], BankInteriorExitB[1], BankInteriorExitB[2], vw, BANK_INTERIOR);
		gBankExitLabelA[i] = CreateDynamic3DTextLabel("{66CCFF}Выход из отделения", 0x66CCFFFF,
			BankInteriorExitA[0], BankInteriorExitA[1], BankInteriorExitA[2] + 0.7,
			18.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, BANK_INTERIOR);
		gBankExitLabelB[i] = CreateDynamic3DTextLabel("{66CCFF}Выход из отделения", 0x66CCFFFF,
			BankInteriorExitB[0], BankInteriorExitB[1], BankInteriorExitB[2] + 0.7,
			18.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, BANK_INTERIOR);
		for(new s = 0; s < BANK_SERVICE_POINT_COUNT; s++)
		{
			gBankServicePickup[i][s] = CreateDynamicPickup(BANK_SERVICE_PICKUP_MODEL, BANK_PICKUP_TYPE,
				BankServicePos[s][0], BankServicePos[s][1], BankServicePos[s][2], vw, BANK_INTERIOR);
			gBankServiceLabel[i][s] = CreateDynamic3DTextLabel(
				"{66CC00}Управление счетами\n{FFFFFF}/bank",
				0xFFFFFFFF, BankServicePos[s][0], BankServicePos[s][1], BankServicePos[s][2] + 0.9,
				12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, BANK_INTERIOR);
		}
		for(new p = 0; p < BANK_PAYMENT_POINT_COUNT; p++)
		{
			gBankPaymentPickup[i][p] = CreateDynamicPickup(BANK_SERVICE_PICKUP_MODEL, BANK_PICKUP_TYPE,
				BankPaymentPos[p][0], BankPaymentPos[p][1], BankPaymentPos[p][2], vw, BANK_INTERIOR);
			gBankPaymentLabel[i][p] = CreateDynamic3DTextLabel(
				"{66CC00}Оплата\n{FFCC00}Дом\n{FFCC00}Бизнес",
				0xFFFFFFFF, BankPaymentPos[p][0], BankPaymentPos[p][1], BankPaymentPos[p][2] + 0.9,
				12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, BANK_INTERIOR);
		}
		for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
		{
			gBankAtmObject[i][a] = CreateDynamicObject(BANK_ATM_MODEL,
				BankAtmPos[a][0], BankAtmPos[a][1], BankAtmPos[a][2],
				0.0, 0.0, BankAtmPos[a][3], vw, BANK_INTERIOR);
			SetDynamicObjectMaterial(gBankAtmObject[i][a], 0, -1, "none", "none", 0x3BD16FFF);
			SetDynamicObjectMaterial(gBankAtmObject[i][a], 1, -1, "none", "none", 0x3BD16FFF);
			gBankAtmLabel[i][a] = CreateDynamic3DTextLabel(
				"{3BD16F}Банкомат",
				0x3BD16FFF,
				BankAtmPos[a][0], BankAtmPos[a][1], BankAtmPos[a][2] + 1.05,
				10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, BANK_INTERIOR);
			gBankAtmArea[i][a] = CreateDynamicSphere(
				BankAtmPos[a][0], BankAtmPos[a][1], BankAtmPos[a][2],
				BANK_ATM_NOTIFY_SHOW_RADIUS, vw, BANK_INTERIOR);
		}
	}
	#pragma unused gBankEnterLabel, gBankExitLabelA, gBankExitLabelB, gBankServiceLabel, gBankPaymentLabel, gBankAtmLabel
	return 1;
}

stock Bank_OnGameModeExit()
{
	for(new i = 0; i < BANK_BRANCH_COUNT; i++)
	{
		if(IsValidDynamic3DTextLabel(gBankEnterLabel[i])) DestroyDynamic3DTextLabel(gBankEnterLabel[i]);
		if(IsValidDynamic3DTextLabel(gBankExitLabelA[i])) DestroyDynamic3DTextLabel(gBankExitLabelA[i]);
		if(IsValidDynamic3DTextLabel(gBankExitLabelB[i])) DestroyDynamic3DTextLabel(gBankExitLabelB[i]);
		if(IsValidDynamicArea(gBankGreenArea[i])) DestroyDynamicArea(gBankGreenArea[i]);
		for(new s = 0; s < BANK_SERVICE_POINT_COUNT; s++)
			if(IsValidDynamic3DTextLabel(gBankServiceLabel[i][s])) DestroyDynamic3DTextLabel(gBankServiceLabel[i][s]);
		for(new p = 0; p < BANK_PAYMENT_POINT_COUNT; p++)
			if(IsValidDynamic3DTextLabel(gBankPaymentLabel[i][p])) DestroyDynamic3DTextLabel(gBankPaymentLabel[i][p]);
		for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
		{
			if(IsValidDynamic3DTextLabel(gBankAtmLabel[i][a])) DestroyDynamic3DTextLabel(gBankAtmLabel[i][a]);
			if(IsValidDynamicObject(gBankAtmObject[i][a])) DestroyDynamicObject(gBankAtmObject[i][a]);
			if(IsValidDynamicArea(gBankAtmArea[i][a])) DestroyDynamicArea(gBankAtmArea[i][a]);
		}
	}
	return 1;
}

stock Bank_OnEnterArea(playerid, STREAMER_TAG_AREA:areaid)
{
	new gz_branch;
	if(Bank_GetGreenZoneByArea(areaid, gz_branch))
	{
		if(GetPlayerVirtualWorld(playerid) == Bank_GetBranchVW(gz_branch))
			Bank_EnterGreenZone(playerid);
		return 1;
	}
	if(GetPlayerInterior(playerid) != BANK_INTERIOR) return 0;
	new branch, point_idx;
	if(!Bank_GetAtmPointByArea(areaid, branch, point_idx)) return 0;
	if(GetPlayerVirtualWorld(playerid) != Bank_GetBranchVW(branch)) return 0;
	Bank_AtmProxEnsure(playerid);
	if(!g_BankAtmInside[playerid][point_idx])
	{
		if(Bank_ShowAtmNotifyAt(playerid, point_idx, true))
			g_BankAtmInside[playerid][point_idx] = true;
	}
	return 1;
}

stock Bank_OnLeaveArea(playerid, STREAMER_TAG_AREA:areaid)
{
	new gz_branch;
	if(Bank_GetGreenZoneByArea(areaid, gz_branch))
	{
		Bank_LeaveGreenZone(playerid);
		return 1;
	}
	new branch, point_idx;
	if(!Bank_GetAtmPointByArea(areaid, branch, point_idx)) return 0;
	g_BankAtmInside[playerid][point_idx] = false;
	for(new a = 0; a < BANK_ATM_POINT_COUNT; a++)
	{
		if(Bank_IsPlayerNearAtmPoint(playerid, a, BANK_ATM_NOTIFY_SHOW_RADIUS))
			return 1;
	}
	HideInteractionWindow(playerid);
	return 1;
}

stock Bank_OnPlayerConnect(playerid)
{
	Bank_ResetPlayer(playerid);
	return 1;
}

stock Bank_OnPlayerDisconnect(playerid)
{
	Bank_ResetPlayer(playerid);
	return 1;
}

stock Bank_OnPickup(playerid, STREAMER_TAG_PICKUP:pickupid)
{
	new tick = GetTickCount(), kind;
	for(new branch = 0; branch < BANK_BRANCH_COUNT; branch++)
	{
		if(!Bank_PickupMatchesBranch(pickupid, branch, kind)) continue;
		if(kind == 1)
		{
			if(tick - g_BankLastEnter[playerid] < BANK_PICKUP_CD_MS) return 1;
			g_BankLastEnter[playerid] = tick;
			g_BankLastExit[playerid] = tick;
			return Bank_TeleportInside(playerid, branch);
		}
		if(kind == 2 || kind == 3)
		{
			if(tick - g_BankLastExit[playerid] < BANK_PICKUP_CD_MS) return 1;
			g_BankLastExit[playerid] = tick;
			g_BankLastEnter[playerid] = tick;
			g_BankPlayerBranch[playerid] = branch;
			return Bank_TeleportOutside(playerid);
		}
		if(kind == 4)
		{
			for(new s = 0; s < BANK_SERVICE_POINT_COUNT; s++)
			{
				if(pickupid != gBankServicePickup[branch][s]) continue;
				return Bank_HandleServicePickup(playerid, branch, s);
			}
			return 1;
		}
		if(kind == 5)
		{
			for(new p = 0; p < BANK_PAYMENT_POINT_COUNT; p++)
			{
				if(pickupid != gBankPaymentPickup[branch][p]) continue;
				return Bank_HandlePaymentPickup(playerid, branch, p);
			}
			return 1;
		}
	}
	return 0;
}
