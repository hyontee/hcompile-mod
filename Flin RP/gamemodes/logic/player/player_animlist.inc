alias:animlist("anim");
CMD:animlist(playerid, params[])
{
	
	if(!GetPlayerStatusUseAnim(playerid))
		return SendError(playerid, "В данный момент Вы не можете воспользоваться анимациями.");
	if(OnPlayerCheckEvent(playerid) != -1) return 1;
	if(GetPVarInt(playerid, "UseAnim") == 1) StopLoopingAnim(playerid);
	if(!sscanf(params, "i", params[0])) return GivePlayerAnim(playerid, params[0] - 1);
	STRING_GLOBAL[0] = EOS;
	strcat(STRING_GLOBAL, ""I"[1]"W" Танец № 1\n"I"[2]"W" Танец № 2\n"I"[3]"W" Танец № 3\n"I"[4]"W" Танец № 4\n");
	strcat(STRING_GLOBAL, ""I"[5]"W" Танец № 5\n"I"[6]"W" Танец № 6\n"I"[7]"W" Танец № 7\n"I"[8]"W" Танец № 8\n");
	strcat(STRING_GLOBAL, ""I"[9]"W" Танец № 9\n"I"[10]"W" Танец № 10\n"I"[11]"W" Руки вверх № 1\n"I"[12]"W" Руки вверх № 2\n");
	strcat(STRING_GLOBAL, ""I"[13]"W" Курить № 1\n"I"[14]"W" Курить № 2\n"I"[15]"W" Сесть № 1\n"I"[16]"W" Сесть № 2\n");
	strcat(STRING_GLOBAL, ""I"[17]"W" Сесть № 3\n"I"[18]"W" Сесть № 4\n"I"[19]"W" Сесть № 5\n"I"[20]"W" Лежать № 1\n");
	strcat(STRING_GLOBAL, ""I"[21]"W" Лежать № 2\n"I"[22]"W" Лежать № 3\n"I"[23]"W" Дилер № 1\n"I"[24]"W" Дилер № 2\n");
	strcat(STRING_GLOBAL, ""I"[25]"W" Дилер № 3\n"I"[26]"W" Дилер № 4\n"I"[27]"W" Читать рэп № 1\n"I"[28]"W" Читать рэп № 2\n");
	strcat(STRING_GLOBAL, ""I"[29]"W" Болельщик № 1\n"I"[30]"W" Болельщик № 2\n"I"[31]"W" Болельщик № 3\n"I"[32]"W" Держать биту № 1\n");
	strcat(STRING_GLOBAL, ""I"[33]"W" Держать биту № 2\n"I"[34]"W" Гангстерский жест № 1\n"I"[35]"W" Гангстерский жест № 2\n"I"[36]"W" Гангстерский жест № 3\n");
	strcat(STRING_GLOBAL, ""I"[37]"W" Гангстерский жест № 4\n"I"[38]"W" Гангстерский жест № 5\n"I"[39]"W" Гангстерский жест № 6\n"I"[40]"W" Гангстерский жест № 7\n");
	strcat(STRING_GLOBAL, ""I"[41]"W" Гангстерский жест № 8\n"I"[42]"W" Наносить графити № 1\n"I"[43]"W" Наносить графити № 2\n"I"[44]"W" Облокотится № 1\n");
	strcat(STRING_GLOBAL, ""I"[45]"W" Облокотится № 2\n"I"[46]"W" Возмущение\n"I"[47]"W" Жест рукой\n"I"[48]"W" Зевать\n");
	strcat(STRING_GLOBAL, ""I"[49]"W" Передал что-то\n"I"[50]"W" Съел что-то\n"I"[51]"W" Справить нужду\n"I"[52]"W" Медитация\n");
	strcat(STRING_GLOBAL, ""I"[53]"W" Шлепнуть рукой\n"I"[54]"W" Курение\n"I"[55]"W" Мужское курение\n"I"[56]"W" Женское курение\n");
	strcat(STRING_GLOBAL, ""I"[57]"W" Позвать кого-то\n"I"[58]"W" Выпить что-то\n"I"[59]"W" Махать руками\n"I"[60]"W" Чинить транспорт\n");
	strcat(STRING_GLOBAL, ""I"[61]"W" Прислониться к транспорту\n"I"[62]"W" Плакать\n"I"[63]"W" Искусственное дыхание\n"I"[64]"W" Чесаться\n");
	strcat(STRING_GLOBAL, ""I"[65]"W" Недоволен");
	ShowPlayerDialog(playerid, D_ANIMLIST, DIALOG_STYLE_LIST, ""I"Анимации", STRING_GLOBAL, "Далее", "Отмена");
	return 1;
}

GivePlayerAnim(playerid, animid)
{
	switch(animid)
	{
		case 0: UseAnim(playerid), SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE1);
		case 1: UseAnim(playerid), SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE2);
		case 2: UseAnim(playerid), SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE3);
		case 3: UseAnim(playerid), SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE4);
		case 4: LoopingAnim(playerid, "DANCING", "dnce_M_b", 4.1, 1, 1, 1, 1, 0);
		case 5: LoopingAnim(playerid, "DANCING", "dnce_M_a", 4.1, 1, 1, 1, 1, 0);
		case 6: LoopingAnim(playerid, "DANCING", "dnce_M_b", 4.1, 1, 1, 1, 1, 0);
		case 7: LoopingAnim(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 1, 1, 1, 0);
		case 8: LoopingAnim(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 1, 1, 1, 0);
		case 9: LoopingAnim(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 1, 1, 1, 0);
		case 10: UseAnim(playerid), SetPlayerSpecialAction (playerid, SPECIAL_ACTION_HANDSUP);
		case 11: LoopingAnim(playerid, "RIOT", "RIOT_ANGRY", 4.0, 0, 1, 1, 1, 0);
		case 12: LoopingAnim(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 1, 1, 1, 0);
		case 13: LoopingAnim(playerid, "SMOKING", "M_smk_drag", 4.0, 0, 1, 1, 1, 0);
		case 14: LoopingAnim(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 0, 1, 1, 1, 1);
		case 15: LoopingAnim(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 1);
		case 16: LoopingAnim(playerid, "BEACH", "ParkSit_W_Loop", 4.1, 1, 1, 1, 1, 1);
		case 17: LoopingAnim(playerid, "CRACK", "Crckidle1", 4.1, 1, 0, 0, 0, 0, 0);
		case 18: LoopingAnim(playerid, "MISC", "seat_LR", 4.1, 1, 0, 0, 0, 0, 0);
		case 19: LoopingAnim(playerid, "BEACH", "SitnWait_loop_W", 4.1, 0, 1, 1, 1, 1);
		case 20: LoopingAnim(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 0, 1, 1, 1, 1);
		case 21: LoopingAnim(playerid, "CRACK", "Crckidle2", 4.1, 1, 0, 0, 0, 0, 0);
		case 22: LoopingAnim(playerid, "DEALER", "DEALER_IDLE", 4.1, 1, 1, 1, 1, 1);
		case 23: LoopingAnim(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 1, 1, 1, 1);
		case 24: LoopingAnim(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 1, 1, 1, 1);
		case 25: LoopingAnim(playerid, "DEALER", "DRUGS_BUY", 4.1, 1, 1, 1, 1, 1);
		case 26: LoopingAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 1, 1, 1, 0);
		case 27: LoopingAnim(playerid, "RAPPING", "RAP_B_IN", 4.0, 0, 1, 1, 1, 0);
		case 28: LoopingAnim(playerid, "RIOT", "Riot_Angry_B", 4.1, 1, 0, 0, 0, 0, 0);
		case 29: LoopingAnim(playerid, "RIOT", "Riot_Chant", 4.1, 1, 1, 0, 0, 0, 0);
		case 30: LoopingAnim(playerid, "RIOT", "Riot_Punches", 4.1, 1, 0, 0, 0, 0, 0);
		case 31: LoopingAnim(playerid, "CRACK", "Bbalbat_Idle_01", 4.1, 1, 0, 0, 0, 0, 0);
		case 32: LoopingAnim(playerid, "CRACK", "Bbalbat_Idle_02", 4.1, 1, 0, 0, 0, 0, 0);
		case 33: LoopingAnim(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0, 1);
		case 34: LoopingAnim(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0, 1);
		case 35: LoopingAnim(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0, 1);
		case 36: LoopingAnim(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0, 1);
		case 37: LoopingAnim(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
		case 38: LoopingAnim(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 39: LoopingAnim(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 40: LoopingAnim(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 41: LoopingAnim(playerid, "SPRAYCAN", "spraycan_full", 4.1, 1, 0, 0, 0, 0, 0);
		case 42: LoopingAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 0);
		case 43: LoopingAnim(playerid, "GANGS", "LeanIn", 4.1, 0, 1, 1, 1, 1,0);
		case 44: LoopingAnim(playerid, "MISC", "plyrlean_loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 45: LoopingAnim(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0);
		case 46: LoopingAnim(playerid, "GANGS", "hndshkba", 4.1, 0, 1, 1, 1, 1);
		case 47: LoopingAnim(playerid, "GANGS", "smkcig_prtl", 4.1, 0, 1, 1, 1, 1);
		case 48: LoopingAnim(playerid, "DEALER", "Dealer_Deal", 4.1, 0, 0, 0, 0, 0, 1);
		case 49: LoopingAnim(playerid, "FOOD", "Eat_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		case 50: LoopingAnim(playerid, "PAULNMAC", "Piss_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 51: LoopingAnim(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 52: LoopingAnim(playerid, "SWEET", "sweet_ass_slap", 4.1, 0, 0, 0, 0, 0, 1);
		case 53: LoopingAnim(playerid, "SMOKING", "M_smkstnd_loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 54: LoopingAnim(playerid, "BD_FIRE", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 55: LoopingAnim(playerid, "LOWRIDER", "F_smklean_loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 56: LoopingAnim(playerid, "RYDER", "Ryd_Beckon_02", 4.1, 1, 0, 0, 0, 0, 0);
		case 57: LoopingAnim(playerid, "BAR", "dnK_StndM_loop", 4.1, 0, 0, 0, 0, 0, 1);
		case 58: LoopingAnim(playerid, "BD_FIRE", "BD_Panic_03", 4.1, 1, 0, 0, 0, 0, 0);
		case 59: LoopingAnim(playerid, "CAR", "fixn_car_loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 60: LoopingAnim(playerid, "CAR_CHAT", "car_talkm_loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 61: LoopingAnim(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 0);
		case 62: LoopingAnim(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
		case 63: LoopingAnim(playerid, "MISC", "scratchballs_01", 4.1, 1, 0, 0, 0, 0, 0);
		case 64: LoopingAnim(playerid, "MISC", "plyr_shkhead", 4.1, 0, 0, 0, 0, 0, 1);
	}
	SendInfo(playerid, "Для отмены анимации нажмите ALT.");
	return 1;
}

LoopingAnim(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	ApplyAnimation(playerid, animlib, animname, Float:fDelta, loop, lockx, locky, freeze, time, forcesync);
	ApplyAnimation(playerid, animlib, animname, Float:fDelta, loop, lockx, locky, freeze, time, forcesync);
	ApplyAnimation(playerid, animlib, animname, Float:fDelta, loop, lockx, locky, freeze, time, forcesync);
	UseAnim(playerid);
}

StopLoopingAnim(playerid)
{
	SetPVarInt(playerid, "UseAnim", 0);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}

UseAnim(playerid)
{
	SetPVarInt(playerid, "UseAnim", 1);
	return 1;
}

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0);
	return 0;
}

PreloadAllAnims(playerid)
{
	PreloadAnimLib(playerid, "DEALER");
	PreloadAnimLib(playerid, "GHANDS");
	PreloadAnimLib(playerid, "PED");
	PreloadAnimLib(playerid, "CRACK");
	PreloadAnimLib(playerid, "SWORD");
	PreloadAnimLib(playerid, "BOMBER");
	PreloadAnimLib(playerid, "CARRY");
	PreloadAnimLib(playerid, "CAR_CHAT");
	PreloadAnimLib(playerid, "GYMNASIUM");
	PreloadAnimLib(playerid, "RIOT");
	PreloadAnimLib(playerid, "RAPPING");
	PreloadAnimLib(playerid, "freeweights");
	PreloadAnimLib(playerid, "BAR");
	PreloadAnimLib(playerid, "GANGS");
	PreloadAnimLib(playerid, "KISSING");
	PreloadAnimLib(playerid, "SNM");
	PreloadAnimLib(playerid, "COP_AMBIENT");
	PreloadAnimLib(playerid, "ON_LOOKERS");
	PreloadAnimLib(playerid, "SMOKING");
	PreloadAnimLib(playerid, "FOOD");
	PreloadAnimLib(playerid, "DANCING");
	PreloadAnimLib(playerid, "INT_OFFICE");
	PreloadAnimLib(playerid, "INT_HOUSE");
	PreloadAnimLib(playerid, "BEACH");
	PreloadAnimLib(playerid, "MISC");
	PreloadAnimLib(playerid, "SPRAYCAN");
	PreloadAnimLib(playerid, "GRAFFITI");
	PreloadAnimLib(playerid, "PAULNMAC");
	PreloadAnimLib(playerid, "PARK");
	PreloadAnimLib(playerid, "SWEET");
	PreloadAnimLib(playerid, "BD_FIRE");
	PreloadAnimLib(playerid, "CAR");
	PreloadAnimLib(playerid, "GRAVEYARD");
	PreloadAnimLib(playerid, "MEDIC");
	return 1;
}

ApplyAnimationFix(playerid, animlib[], animname[], Float:speed)
{
    ApplyAnimation(playerid,animlib, animname, speed, 1, 1, 1, 1, 0, 1);
    ApplyAnimation(playerid,animlib, animname, speed, 1, 1, 1, 1, 1, 0);
    return 1;
}