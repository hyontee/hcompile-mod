// Главный врач — медкарта (тест RP). Быстрое лечение отключено.
#if defined _BR_HOSPITAL_CHIEF_DOCTOR_INC_
	#endinput
#endif
#define _BR_HOSPITAL_CHIEF_DOCTOR_INC_

forward ShowPlayerGUI(playerid, guiid, Node:json);
forward HidePlayerGUI(playerid, guiid, Node:json);
forward GivePlayerBlackCoin(playerid, amount);
forward GetPlayerBlackCoin(playerid);
forward ChiefDoctor_ProxTick(playerid);
forward ChiefDoctor_ApplyFastHealDelayed(playerid);
forward ChiefDoctor_FinishFastHealExit(playerid);
forward Hospital_RefreshInteriorInteract(playerid);
forward SavePlayerAccount(playerid);

#define HCD_GUI_ID                  (63)
#define HCD_NPC_SKIN                (70)
#define HCD_NPC_RADIUS              (2.2)
#define HCD_PROX_MS                 (250)

#define HCD_MED_WAIT_SEC            (600)
#define HCD_QUIZ_FAIL_CD_SEC        (300)
#define HCD_FAST_HEAL_BC_COST       (500)
#define HCD_FAST_HEAL_DURATION_SEC  (7 * 86400)
#define HCD_MED_CARD_DURATION_SEC   (30 * 86400)

#if !defined NOTIFY_MEDCARD_OFFER
	#define NOTIFY_MEDCARD_OFFER    (48)
#endif
#if !defined AT_DIALOG_MEDCARD
	#define AT_DIALOG_MEDCARD       (6125)
#endif
#if !defined COLOR_GREY
	#define COLOR_GREY              (0xAAAAAAFF)
#endif
#if !defined COLOR_WHITE
	#define COLOR_WHITE             (0xFFFFFFFF)
#endif

#define HCD_PVAR_GUI_OPEN           "HospChiefGuiOpen"

#define HCD_SCR_MAIN                (1)
#define HCD_SCR_QUIZ                (2)
#define HCD_SCR_QUIZ_OK             (3)
#define HCD_SCR_QUIZ_FAIL           (4)
#define HCD_SCR_FAST_OFFER          (5)
#define HCD_SCR_FAST_THANKS         (6)

#define HCD_BK_MED_CARD             (1)
#define HCD_BK_FAST_HEAL            (2)
#define HCD_BK_EXIT                 (99)
#define HCD_BK_QUIZ_1               (10)
#define HCD_BK_QUIZ_2               (11)
#define HCD_BK_QUIZ_3               (12)
#define HCD_BK_BUY_FAST             (20)
#define HCD_BK_BACK                 (21)
#define HCD_BK_BYE                  (22)

#define HCD_QUIZ_COUNT              (8)

static const g_HcdQuizQ[HCD_QUIZ_COUNT][96] =
{
	"Что такое RP?",
	"Что означает NonRP?",
	"Можно ли убивать без RP-причины?",
	"Что такое DM (Deathmatch)?",
	"Зачем нужна медицинская карта?",
	"Как правильно отыгрывать ранение?",
	"Что делать при конфликте в RP?",
	"Кто такой Главный врач в больнице?"
};

static const g_HcdQuizA0[HCD_QUIZ_COUNT][48] =
{
	"Ролевая игра", "Нарушение ролевой игры", "Нет", "Убийство без RP-причины",
	"Подтверждение здоровья для RP", "Вести себя как раненый", "Решать по правилам сервера", "NPC для медкарты и лечения"
};

static const g_HcdQuizA1[HCD_QUIZ_COUNT][48] =
{
	"Игра с друзьями", "Новый режим игры", "Да", "Дуэль по правилам",
	"Скидка на оружие", "Бежать на полной скорости", "Уйти с сервера", "Босс мафии"
};

static const g_HcdQuizA2[HCD_QUIZ_COUNT][48] =
{
	"Роле плей", "Ночной патруль", "Только ночью", "Ремонт машины",
	"Бесплатный транспорт", "Игнорировать урон", "Оскорблять в чате", "Админ сервера"
};

static const g_HcdQuizCorrect[HCD_QUIZ_COUNT] = {0, 0, 0, 0, 0, 0, 0, 0};

static const Float:g_HcdNpcPos[4] =
	{1501.5657, 2499.4487, 2501.0402, 184.6477};

new STREAMER_TAG_ACTOR:g_HcdActor[HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_3D_TEXT_LABEL:g_HcdLabel[HOSPITAL_BRANCH_COUNT];
new STREAMER_TAG_AREA:g_HcdArea[HOSPITAL_BRANCH_COUNT];

new g_HcdProxTimer[MAX_PLAYERS] = {-1, ...};
new bool:g_HcdNearNpc[MAX_PLAYERS];
new g_HcdGuiScreen[MAX_PLAYERS];
new g_HcdQuizIndex[MAX_PLAYERS];

stock ChiefDoctor_Notify(playerid, type, caption[])
{
	ShowNotification(playerid, type, 5, 0, 1, caption, "");
	return 1;
}

stock ChiefDoctor_NotifyRed(playerid, caption[])
{
	return ChiefDoctor_Notify(playerid, 2, caption);
}

stock ChiefDoctor_NotifyGreen(playerid, caption[])
{
	return ChiefDoctor_Notify(playerid, 3, caption);
}

stock ChiefDoctor_ExpireMedCard(playerid)
{
	if(Player[playerid][pID] <= 0)
		return 0;
	if(Player[playerid][pMedCard] != 1)
		return 0;

	Player[playerid][pMedCard] = 0;
	Player[playerid][pMedCardExpiresAt] = 0;
	Player[playerid][pMedCardReadyAt] = 0;
	SavePlayerAccount(playerid);
	SendClientMessage(playerid, 0xFFAA00FF,
		"{FFCD00}[Больница] {FFFFFF}Срок медицинской карты истёк. Получите новую у Главного врача.");
	return 1;
}

stock bool:ChiefDoctor_PlayerHasMedCard(playerid)
{
	if(Player[playerid][pMedCard] != 1)
		return false;
	if(Player[playerid][pMedCardExpiresAt] > 0 && gettime() >= Player[playerid][pMedCardExpiresAt])
	{
		ChiefDoctor_ExpireMedCard(playerid);
		return false;
	}
	return true;
}

stock bool:ChiefDoctor_PlayerHasFastHeal(playerid)
{
	#pragma unused playerid
	return false;
}

stock ChiefDoctor_ApplyInstantFullHeal(playerid)
{
	if(!IsPlayerConnected(playerid) || Player[playerid][pID] <= 0)
		return 0;

	Player[playerid][pHealth] = 100.0;
	Player[playerid][pArmour] = 0.0;
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0.0);
	ClearAnimations(playerid);

	if(g_HospitalOccupiedBed[playerid] != -1)
	{
		new bed = g_HospitalOccupiedBed[playerid];
		g_HospitalBedOccupant[bed] = -1;
		g_HospitalOccupiedBed[playerid] = -1;
		Hospital_UpdateBedLabel(bed);
	}

	SavePlayerAccount(playerid);
	return 1;
}

stock ChiefDoctor_GetFastHealLeftSec(playerid)
{
	#pragma unused playerid
	return 0;
}

stock ChiefDoctor_GetMedCardLeftSec(playerid)
{
	if(Player[playerid][pMedCardExpiresAt] <= 0)
		return 0;
	new left = Player[playerid][pMedCardExpiresAt] - gettime();
	if(left < 0) left = 0;
	return left;
}

stock bool:ChiefDoctor_IsQuizOnCooldown(playerid)
{
	return (Player[playerid][pMedQuizFailUntil] > gettime());
}

stock ChiefDoctor_GetQuizCooldownLeft(playerid)
{
	new left = Player[playerid][pMedQuizFailUntil] - gettime();
	if(left < 0) left = 0;
	return left;
}

stock bool:ChiefDoctor_IsMedCardPending(playerid)
{
	return (Player[playerid][pMedCardReadyAt] > gettime());
}

stock ChiefDoctor_GetMedCardWaitLeft(playerid)
{
	new left = Player[playerid][pMedCardReadyAt] - gettime();
	if(left < 0) left = 0;
	return left;
}

stock ChiefDoctor_GetPlayerCityName(playerid, dest[], size)
{
	new branch = Hospital_GetPlayerBranch(playerid);
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = Hospital_GetBranchByVW(GetPlayerVirtualWorld(playerid));
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
		branch = HOSPITAL_BRANCH_ARZAMAS;

	return Hospital_GetCityName(branch, dest, size);
}

stock Node:ChiefDoctor_BuildButton(const text[], bt, bk)
{
	return JSON_Object(
		"bn", JSON_String(text),
		"bt", JSON_Int(bt),
		"bk", JSON_Int(bk)
	);
}

stock ChiefDoctor_SendGui(playerid, Node:json)
{
	ShowPlayerGUI(playerid, HCD_GUI_ID, json);
	JSON_Cleanup(json);
	return 1;
}

stock ChiefDoctor_CloseGui(playerid, bool:reshow_interact = false)
{
	if(GetPVarInt(playerid, HCD_PVAR_GUI_OPEN) != 1)
		return 0;

	DeletePVar(playerid, HCD_PVAR_GUI_OPEN);
	g_HcdGuiScreen[playerid] = 0;
	g_HcdQuizIndex[playerid] = -1;

	new Node:close_json = JSON_Object();
	HidePlayerGUI(playerid, HCD_GUI_ID, close_json);
	JSON_Cleanup(close_json);

	if(reshow_interact && g_HcdNearNpc[playerid])
		ToggleInteractionWindow(playerid, true);
	return 1;
}

stock ChiefDoctor_ShowMainGui(playerid, bool:is_update = false)
{
	new city[24], desc[220];
	ChiefDoctor_GetPlayerCityName(playerid, city, sizeof city);
	format(desc, sizeof desc,
		"Здравствуйте! Вы в больнице города %s. Добро пожаловать! Чем могу помочь?",
		city);

	SetPVarInt(playerid, HCD_PVAR_GUI_OPEN, 1);
	g_HcdGuiScreen[playerid] = HCD_SCR_MAIN;

	new Node:buttons = JSON_Array(
		ChiefDoctor_BuildButton("Получить мед карту", 1, HCD_BK_MED_CARD),
		ChiefDoctor_BuildButton("Выход", 3, HCD_BK_EXIT)
	);

	new Node:json = JSON_Object();
	if(is_update)
		JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Главный Врач");
	JSON_SetString(json, "d", desc);
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", HCD_NPC_SKIN);
	JSON_SetArray(json, "b", buttons);

	ChiefDoctor_SendGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock ChiefDoctor_ShowQuizGui(playerid)
{
	new q = g_HcdQuizIndex[playerid];
	if(q < 0 || q >= HCD_QUIZ_COUNT)
		q = 0;

	g_HcdGuiScreen[playerid] = HCD_SCR_QUIZ;

	new Node:buttons = JSON_Array(
		ChiefDoctor_BuildButton(g_HcdQuizA0[q], 2, HCD_BK_QUIZ_1),
		ChiefDoctor_BuildButton(g_HcdQuizA1[q], 2, HCD_BK_QUIZ_2),
		ChiefDoctor_BuildButton(g_HcdQuizA2[q], 2, HCD_BK_QUIZ_3)
	);

	new Node:json = JSON_Object();
	JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Главный Врач");
	JSON_SetString(json, "d", g_HcdQuizQ[q]);
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", HCD_NPC_SKIN);
	JSON_SetArray(json, "b", buttons);

	ChiefDoctor_SendGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock ChiefDoctor_ShowQuizSuccessGui(playerid)
{
	g_HcdGuiScreen[playerid] = HCD_SCR_QUIZ_OK;

	new Node:buttons = JSON_Array(
		ChiefDoctor_BuildButton("До свидания", 1, HCD_BK_BYE)
	);

	new Node:json = JSON_Object();
	JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Главный Врач");
	JSON_SetString(json, "d",
		"Поздравляем! Медкарта будет готова через 10 минут (сообщение в чате). \
Срок действия карты после выдачи — 30 дней.");
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", HCD_NPC_SKIN);
	JSON_SetArray(json, "b", buttons);

	ChiefDoctor_SendGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock ChiefDoctor_ShowQuizFailGui(playerid)
{
	g_HcdGuiScreen[playerid] = HCD_SCR_QUIZ_FAIL;

	new Node:buttons = JSON_Array(
		ChiefDoctor_BuildButton("До свидания", 1, HCD_BK_BYE)
	);

	new Node:json = JSON_Object();
	JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Главный Врач");
	JSON_SetString(json, "d",
		"К сожалению, ответ неверный. В следующий раз повезёт. До свидания!");
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", HCD_NPC_SKIN);
	JSON_SetArray(json, "b", buttons);

	ChiefDoctor_SendGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock ChiefDoctor_ShowFastHealOfferGui(playerid)
{
	g_HcdGuiScreen[playerid] = HCD_SCR_FAST_OFFER;

	new Node:buttons = JSON_Array(
		ChiefDoctor_BuildButton("Покупать", 1, HCD_BK_BUY_FAST),
		ChiefDoctor_BuildButton("Назад", 0, HCD_BK_BACK)
	);

	new Node:json = JSON_Object();
	JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Главный Врач");
	JSON_SetString(json, "d",
		"Быстрое лечение — 500 BC на 7 дней. Пока действует подписка, \
при каждом выходе из больницы у вас будет 100 HP.");
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", HCD_NPC_SKIN);
	JSON_SetArray(json, "b", buttons);

	ChiefDoctor_SendGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock ChiefDoctor_ShowFastHealThanksGui(playerid)
{
	g_HcdGuiScreen[playerid] = HCD_SCR_FAST_THANKS;

	new Node:buttons = JSON_Array(
		ChiefDoctor_BuildButton("До свидания", 1, HCD_BK_BYE)
	);

	new Node:json = JSON_Object();
	JSON_SetInt(json, "t", 1);
	JSON_SetString(json, "n", "Главный Врач");
	JSON_SetString(json, "d",
		"Спасибо за покупку! 7 дней при выходе из больницы — 100 HP. До свидания!");
	JSON_SetInt(json, "ts", 100);
	JSON_SetInt(json, "st", 1);
	JSON_SetInt(json, "m", HCD_NPC_SKIN);
	JSON_SetArray(json, "b", buttons);

	ChiefDoctor_SendGui(playerid, json);
	JSON_Cleanup(buttons);
	return 1;
}

stock ChiefDoctor_OpenGui(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(!Hospital_IsPlayerInside(playerid)) return 0;
	if(GetPVarInt(playerid, HCD_PVAR_GUI_OPEN) == 1) return 0;
	if(!g_HcdNearNpc[playerid]) return 0;

	HideInteractionWindow(playerid);
	return ChiefDoctor_ShowMainGui(playerid);
}

stock ChiefDoctor_StartMedCardQuiz(playerid)
{
	if(ChiefDoctor_PlayerHasMedCard(playerid))
	{
		ChiefDoctor_Notify(playerid, 2, "У вас уже есть медицинская карта. Проверка: /med");
		return 0;
	}
	if(ChiefDoctor_IsMedCardPending(playerid))
	{
		new msg[128], sec = ChiefDoctor_GetMedCardWaitLeft(playerid);
		format(msg, sizeof msg, "Медкарта уже оформляется. Осталось ~%d мин.", (sec + 59) / 60);
		ChiefDoctor_Notify(playerid, 2, msg);
		return 0;
	}
	if(ChiefDoctor_IsQuizOnCooldown(playerid))
	{
		new msg[96], sec = ChiefDoctor_GetQuizCooldownLeft(playerid);
		format(msg, sizeof msg, "Подождите %d мин. %d сек. перед повторной попыткой.", sec / 60, sec % 60);
		ChiefDoctor_NotifyRed(playerid, msg);
		return 0;
	}

	g_HcdQuizIndex[playerid] = random(HCD_QUIZ_COUNT);
	return ChiefDoctor_ShowQuizGui(playerid);
}

stock ChiefDoctor_CheckQuizAnswer(playerid, answer_idx)
{
	new q = g_HcdQuizIndex[playerid];
	if(q < 0 || q >= HCD_QUIZ_COUNT) return 0;

	if(answer_idx == g_HcdQuizCorrect[q])
	{
		Player[playerid][pMedCardReadyAt] = gettime() + HCD_MED_WAIT_SEC;
		Player[playerid][pMedQuizFailUntil] = 0;
		SavePlayerAccount(playerid);
		ChiefDoctor_ShowQuizSuccessGui(playerid);
		return 1;
	}

	Player[playerid][pMedQuizFailUntil] = gettime() + HCD_QUIZ_FAIL_CD_SEC;
	SavePlayerAccount(playerid);
	ChiefDoctor_ShowQuizFailGui(playerid);
	return 0;
}

stock ChiefDoctor_TryBuyFastHeal(playerid)
{
	ChiefDoctor_NotifyRed(playerid, "Быстрое лечение отключено на сервере.");
	return 0;
}

stock ChiefDoctor_DeliverPendingMedCard(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(Player[playerid][pMedCard] == 1) return 0;
	if(Player[playerid][pMedCardReadyAt] <= 0) return 0;
	if(Player[playerid][pMedCardReadyAt] > gettime()) return 0;

	Player[playerid][pMedCard] = 1;
	Player[playerid][pMedCardReadyAt] = 0;
	Player[playerid][pMedCardIssuedAt] = gettime();
	Player[playerid][pMedCardExpiresAt] = gettime() + HCD_MED_CARD_DURATION_SEC;
	if(Player[playerid][pMedCardIssuerBranch] < 0 || Player[playerid][pMedCardIssuerBranch] >= HOSPITAL_BRANCH_COUNT)
	{
		new br = Hospital_GetPlayerBranch(playerid);
		Player[playerid][pMedCardIssuerBranch] = (br >= 0) ? br : HOSPITAL_BRANCH_ARZAMAS;
	}
	SavePlayerAccount(playerid);

	SendClientMessage(playerid, 0x66CC66FF,
		"{FFCD00}[Больница] {FFFFFF}Медкарта выдана на 30 дней. Показать: {FFCD00}/med [id]");
	return 1;
}

stock ChiefDoctor_TickPlayer(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(Player[playerid][pID] <= 0) return 0;

	ChiefDoctor_DeliverPendingMedCard(playerid);

	if(Player[playerid][pMedCard] == 1 && Player[playerid][pMedCardExpiresAt] > 0
		&& gettime() >= Player[playerid][pMedCardExpiresAt])
		ChiefDoctor_ExpireMedCard(playerid);

	return 1;
}

stock bool:ChiefDoctor_HandleGuiPacket(playerid, Node:json)
{
	if(GetPVarInt(playerid, HCD_PVAR_GUI_OPEN) != 1)
		return false;

	new close_flag;
	if(JSON_GetInt(json, "c", close_flag) && close_flag)
	{
		ChiefDoctor_CloseGui(playerid, true);
		return true;
	}

	new click;
	if(!JSON_GetInt(json, "bk", click))
		JSON_GetInt(json, "bt", click);

	switch(click)
	{
		case HCD_BK_EXIT, HCD_BK_BYE:
		{
			ChiefDoctor_CloseGui(playerid, true);
		}
		case HCD_BK_MED_CARD:
		{
			ChiefDoctor_StartMedCardQuiz(playerid);
		}
		case HCD_BK_QUIZ_1: ChiefDoctor_CheckQuizAnswer(playerid, 0);
		case HCD_BK_QUIZ_2: ChiefDoctor_CheckQuizAnswer(playerid, 1);
		case HCD_BK_QUIZ_3: ChiefDoctor_CheckQuizAnswer(playerid, 2);
		case HCD_BK_BACK:
		{
			ChiefDoctor_ShowMainGui(playerid, true);
		}
	}
	return true;
}

stock bool:ChiefDoctor_IsNearNpc(playerid)
{
	if(GetPlayerInterior(playerid) != HOSPITAL_INTERIOR_ID)
		return false;
	if(Hospital_GetPlayerBranch(playerid) < 0)
		return false;
	return (IsPlayerInRangeOfPoint(playerid, HCD_NPC_RADIUS,
		g_HcdNpcPos[0], g_HcdNpcPos[1], g_HcdNpcPos[2]) != 0);
}

stock ChiefDoctor_ProxStop(playerid)
{
	if(g_HcdProxTimer[playerid] != -1)
	{
		KillTimer(g_HcdProxTimer[playerid]);
		g_HcdProxTimer[playerid] = -1;
	}
	g_HcdNearNpc[playerid] = false;
	if(GetPVarInt(playerid, HCD_PVAR_GUI_OPEN) != 1)
		HideInteractionWindow(playerid);
	return 1;
}

stock ChiefDoctor_ProxEnsure(playerid)
{
	if(g_HcdProxTimer[playerid] != -1) return 1;
	g_HcdProxTimer[playerid] = SetTimerEx("ChiefDoctor_ProxTick", HCD_PROX_MS, true, "i", playerid);
	return 1;
}

public ChiefDoctor_ProxTick(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		ChiefDoctor_ProxStop(playerid);
		return 0;
	}
	if(Player[playerid][pID] <= 0 || !Hospital_IsPlayerInside(playerid))
	{
		ChiefDoctor_ProxStop(playerid);
		ChiefDoctor_CloseGui(playerid, false);
		return 0;
	}

	ChiefDoctor_TickPlayer(playerid);

	g_HcdNearNpc[playerid] = ChiefDoctor_IsNearNpc(playerid);
	Hospital_RefreshInteriorInteract(playerid);
	return 1;
}

stock ChiefDoctor_TryInteract(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	if(!ChiefDoctor_IsNearNpc(playerid)) return 0;
	return ChiefDoctor_OpenGui(playerid);
}

stock ChiefDoctor_OnEnterHospital(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	ChiefDoctor_ProxEnsure(playerid);
	return 1;
}

stock ChiefDoctor_ApplyFastHealOnExit(playerid)
{
	#pragma unused playerid
	return 0;
}

public ChiefDoctor_ApplyFastHealDelayed(playerid)
{
	#pragma unused playerid
	return 0;
}

public ChiefDoctor_FinishFastHealExit(playerid)
{
	#pragma unused playerid
	return 0;
}

stock bool:ChiefDoctor_CanLeaveHospital(playerid)
{
	return (Hospital_GetPlayerHP(playerid) >= HOSPITAL_EXIT_MIN_HP);
}

stock ChiefDoctor_ResetPlayer(playerid)
{
	ChiefDoctor_ProxStop(playerid);
	ChiefDoctor_CloseGui(playerid, false);
	g_HcdGuiScreen[playerid] = 0;
	g_HcdQuizIndex[playerid] = -1;
	DeletePVar(playerid, HCD_PVAR_GUI_OPEN);
	DeletePVar(playerid, "hcd_fast_heal_exit");
	return 1;
}

stock ChiefDoctor_Init()
{
	new label[48];
	format(label, sizeof label, "{FFCD00}Главный Врач");

	for(new branch; branch < HOSPITAL_BRANCH_COUNT; branch++)
	{
		new vw = Hospital_GetBranchVW(branch);

		g_HcdActor[branch] = CreateDynamicActor(HCD_NPC_SKIN,
			g_HcdNpcPos[0], g_HcdNpcPos[1], g_HcdNpcPos[2], g_HcdNpcPos[3],
			true, 100.0, vw, HOSPITAL_INTERIOR_ID);

		g_HcdLabel[branch] = CreateDynamic3DTextLabel(label, 0xFFFFFFFF,
			g_HcdNpcPos[0], g_HcdNpcPos[1], g_HcdNpcPos[2] + 1.05,
			14.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, HOSPITAL_INTERIOR_ID);

		g_HcdArea[branch] = CreateDynamicSphere(
			g_HcdNpcPos[0], g_HcdNpcPos[1], g_HcdNpcPos[2],
			HCD_NPC_RADIUS + 0.5, vw, HOSPITAL_INTERIOR_ID);
	}
	return 1;
}

stock ChiefDoctor_FormatUnixDate(unix_ts, dest[], size)
{
	if(unix_ts <= 0)
	{
		format(dest, size, "-");
		return 0;
	}

	new year, month, day, hour, minute, second;
	year = unix_ts / 31557600;
	unix_ts -= year * 31557600;
	year += 1970;
	if(year % 4 == 0) unix_ts -= 21600;
	day = unix_ts / 86400;

	switch(day)
	{
		case 0..30:   { second = day;       month = 1; }
		case 31..58:  { second = day - 31;  month = 2; }
		case 59..89:  { second = day - 59;  month = 3; }
		case 90..119: { second = day - 90;  month = 4; }
		case 120..150:{ second = day - 120; month = 5; }
		case 151..180:{ second = day - 151; month = 6; }
		case 181..211:{ second = day - 181; month = 7; }
		case 212..242:{ second = day - 212; month = 8; }
		case 243..272:{ second = day - 243; month = 9; }
		case 273..303:{ second = day - 273; month = 10; }
		case 304..333:{ second = day - 304; month = 11; }
		default:      { second = day - 334; month = 12; }
	}
	day = second;
	#pragma unused hour, minute
	format(dest, size, "%02d.%02d.%d", day, month, year);
	return 1;
}

stock ChiefDoctor_GetIssuerLabel(ownerid, dest[], size)
{
	new branch = Player[ownerid][pMedCardIssuerBranch];
	if(branch < 0 || branch >= HOSPITAL_BRANCH_COUNT)
	{
		format(dest, size, "Городская больница");
		return 1;
	}
	new city[24];
	Hospital_GetCityName(branch, city, sizeof city);
	format(dest, size, "Городская больница г. %s", city);
	return 1;
}

stock ChiefDoctor_ShowMedCardDialog(viewerid, ownerid)
{
	if(!IsPlayerConnected(viewerid) || !IsPlayerConnected(ownerid)) return 0;
	if(Player[ownerid][pID] <= 0) return 0;
	if(!ChiefDoctor_PlayerHasMedCard(ownerid)) return 0;

	new Float:hp;
	GetPlayerHealth(ownerid, hp);

	new issuer[64], issued_date[16], expdate[16], body[420];
	ChiefDoctor_GetIssuerLabel(ownerid, issuer, sizeof issuer);
	ChiefDoctor_FormatUnixDate(Player[ownerid][pMedCardIssuedAt], issued_date, sizeof issued_date);
	if(Player[ownerid][pMedCardExpiresAt] > 0)
		ChiefDoctor_FormatUnixDate(Player[ownerid][pMedCardExpiresAt], expdate, sizeof expdate);
	else
		format(expdate, sizeof expdate, "-");

	format(body, sizeof body,
		"{FFFFFF}| Никнейм игрока:\t\t{FFCC00}%s\n\
		{FFFFFF}| Состояние игрока:\t\t{FFCC00}%.1f\n\
		{FFFFFF}| Кем выдано:\t\t\t{FFCC00}%s\n\
		{FFFFFF}| Дата выдачи:\t\t\t{FFCC00}%s\n\
		{FFFFFF}| Действует до:\t\t\t{FFCC00}%s",
		Player[ownerid][pName], hp, issuer, issued_date, expdate);

	ShowPlayerDialog(viewerid, AT_DIALOG_MEDCARD, DIALOG_STYLE_MSGBOX,
		"{E0584B}BRBLACKSTUDIO{FFFFFF} | Медицинская карта",
		body, "Закрыть", "");
	return 1;
}

stock ChiefDoctor_SendMedOffer(playerid, targetid)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
	if(Player[playerid][pID] <= 0 || Player[targetid][pID] <= 0) return 0;

	if(!ChiefDoctor_PlayerHasMedCard(playerid))
	{
		SendClientMessage(playerid, COLOR_GREY, "У вас нет медицинской карты.");
		return 0;
	}

	if(playerid != targetid && !Pass_IsPlayerNear(playerid, targetid))
	{
		SendClientMessage(playerid, COLOR_GREY, "Игрок слишком далеко.");
		return 0;
	}

	new msg[160];
	if(playerid == targetid)
		format(msg, sizeof msg, "Просмотр собственной медицинской карты.");
	else
		format(msg, sizeof msg, "Игрок %s[%d] хочет показать вам медицинскую карту.", Player[playerid][pName], playerid);
	ShowNotification(targetid, 4, 15, NOTIFY_MEDCARD_OFFER, playerid, msg, ">>");

	if(playerid == targetid)
		SendClientMessage(playerid, COLOR_WHITE, "Примите уведомление (>>), чтобы открыть мед. карту.");
	else
	{
		format(msg, sizeof msg, "Вы предложили показать мед. карту игроку %s[%d].", Player[targetid][pName], targetid);
		SendClientMessage(playerid, COLOR_WHITE, msg);
	}
	return 1;
}

stock ChiefDoctor_CmdMed(playerid, params[])
{
	if(Player[playerid][pID] <= 0)
		return SendClientMessage(playerid, COLOR_GREY, "Сначала войдите в аккаунт.");

	new targetid;
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GREY, "Используйте: /med [id игрока]");

	if(!IsPlayerConnected(targetid) || Player[targetid][pID] <= 0)
		return SendClientMessage(playerid, COLOR_RED, "Игрок не найден или не авторизован.");

	if(!ChiefDoctor_PlayerHasMedCard(playerid))
	{
		if(ChiefDoctor_IsMedCardPending(playerid))
		{
			new msg[96], sec = ChiefDoctor_GetMedCardWaitLeft(playerid);
			format(msg, sizeof msg,
				"{FFCD00}[Медкарта] {FFFFFF}Карта готовится. Осталось: %d мин. %d сек.",
				sec / 60, sec % 60);
			return SendClientMessage(playerid, 0xFFFFFFFF, msg);
		}
		if(ChiefDoctor_IsQuizOnCooldown(playerid))
		{
			new msg[96], sec = ChiefDoctor_GetQuizCooldownLeft(playerid);
			format(msg, sizeof msg,
				"{FFCD00}[Медкарта] {FFFFFF}Повторная попытка через: %d мин. %d сек.",
				sec / 60, sec % 60);
			return SendClientMessage(playerid, 0xFFFFFFFF, msg);
		}
		return SendClientMessage(playerid, COLOR_GREY,
			"У вас нет медкарты. Получите её у Главного врача в больнице.");
	}

	if(targetid != playerid && !Pass_IsPlayerNear(playerid, targetid))
		return SendClientMessage(playerid, COLOR_GREY, "Игрок слишком далеко.");

	return ChiefDoctor_SendMedOffer(playerid, targetid);
}
