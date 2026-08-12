#if defined _medcard_inc
	#endinput
#endif
#define _medcard_inc

#define TABLE_MEDCARDS			"s_medcards"
#define HOSPITAL_MEDCARD_PRICE	1000

enum MEDCARD_e {
	pMedcardID,
	pMedcardBlood,
	pMedcardBloodDirection,
	pMedcardHospital,
	pMedcardDate[22],
}
new MedcardInfo[MAX_PLAYERS][MEDCARD_e];

stock LoadPlayerMedcardData(playerid) {
	format(t_string, sizeof (t_string), "SELECT * FROM "TABLE_MEDCARDS" WHERE owner = '%s'", pInfo[playerid][pName]);
	new Cache:tempQuery = mysql_query(dbHandle, t_string), rows;
	t_string[0] = EOS;

	cache_get_row_count(rows);
	if (!rows) {
		if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		return;
	}
	cache_get_value_name_int(0, "id", MedcardInfo[playerid][pMedcardID]);
	cache_get_value_name_int(0, "bloodGroup", MedcardInfo[playerid][pMedcardBlood]);
	cache_get_value_name_int(0, "bloodDirection", MedcardInfo[playerid][pMedcardBloodDirection]);
	cache_get_value_name_int(0, "hospital", MedcardInfo[playerid][pMedcardHospital]);
	cache_get_value_name(0, "date", MedcardInfo[playerid][pMedcardDate], 22);
	//cache_get_value_name(0, "date", MedcardInfo[playerid][pMedcardDate], 22);

	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
}
stock CreatePlayerMedcard(playerid) {
	if (MedcardInfo[playerid][pMedcardID]) {
		SendClientMessage(playerid, COLOR_GREY, !"У вас уже есть медицинская карта! (( /medcard ))");
		return false;
	}
	if (kLibGetPlayerMoney(playerid) < HOSPITAL_MEDCARD_PRICE) {
		SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств! ("#HOSPITAL_MEDCARD_PRICE")");
		return false;
	}
	kLibGivePlayerMoney(playerid, -HOSPITAL_MEDCARD_PRICE);

	MedcardInfo[playerid][pMedcardBlood] = random(4);
	MedcardInfo[playerid][pMedcardBloodDirection] = random(2);
	if (pTemp[playerid][tVirtualWorld] == 7){
		MedcardInfo[playerid][pMedcardHospital] = FRACTION_HOSPITAL_LS;
	}
	else if (pTemp[playerid][tVirtualWorld] == HOSPITAL_SF_INT) {
		MedcardInfo[playerid][pMedcardHospital] = FRACTION_HOSPITAL_SF;
	}
	else {
		MedcardInfo[playerid][pMedcardHospital] = FRACTION_HOSPITAL_LV;
	}
	

	getdate(year, month, day);
	gettime(hour, minute, second);

	format(MedcardInfo[playerid][pMedcardDate], 22, "%02d:%02d:%02d %02d.%02d.%d", hour, minute, second, day, month, year);
	format(t_string, sizeof (t_string), "INSERT INTO "TABLE_MEDCARDS" \
		(`owner`, `hospital`, `bloodGroup`, `bloodDirection`) VALUES \
		('%s', %i, %i, %i)",
		pInfo[playerid][pName],
		MedcardInfo[playerid][pMedcardHospital],
		MedcardInfo[playerid][pMedcardBlood],
		MedcardInfo[playerid][pMedcardBloodDirection]
	);
	new Cache:tempQuery = mysql_query(dbHandle, t_string);
	MedcardInfo[playerid][pMedcardID] = cache_insert_id();
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
	
	t_string[0] = EOS;

	SendClientMessage(playerid, COLOR_BLUE, !"Поздравляем, вы получили медицинскую карту! (( /medcard ))");
	return true;
}
stock SetActionKiss(playerid, targetid) {
	if (!IsPlayerInRangeOfPlayer(4.0, playerid, targetid)) { 
		SendClientMessage(targetid, COLOR_GREY, !"Вы далеко друг от друга");
		//ResetTargetYN(playerid, idx);
		return 1;
	} 
	if (!PlayerInConnected(playerid)) {
		//ResetTargetYN(playerid, idx);
		return SendClientMessage(targetid, COLOR_GREY, !"Игрок который хотел поцеловать Вас оффлайн"); 
	}
	SetPosInFrontOfPlayer(playerid, targetid, 1);
	new 
		Float: angle;
	GetPlayerFacingAngle(playerid, angle);
	SetPlayerFacingAngle(targetid, 180 + angle);
	ApplyAnimation(playerid, "BD_FIRE","GRLFRD_KISS_03", 4.0, 0, 0, 0, 0, 0, 1);
	ApplyAnimation(targetid, "BD_FIRE","PLAYA_KISS_03", 4.0, 0, 0, 0, 0, 0, 0); 
	return 1;
}
stock ShowMedcard(playerid, targetid) {
	if (!MedcardInfo[playerid][pMedcardID]) 
		return false;
	static const BloodGroupName[][8] = { 
		"O(I)", 
		"A(II)", 
		"B(III)", 
		"AB(IV)"
	};
	format(t_string, sizeof (t_string), "\
		"colwhi"Данные медицинской карты:\n\
		"colwhi"\t- Владелец: "colserver"%s\n\
		"colwhi"\t- Пол: "colserver"%s\n\
		"colwhi"\t- Группа крови: "colserver"%s %s\n\
		"colwhi"\t- Отделение регистрации: "colserver"Больница г.Лос Сантос\n\
		"colwhi"\t- Дата получения: "colserver"%s\n \n\
		"colwhi"Результаты последнего осмотра [%s]:\n\
		"colwhi"\t- Болезни не обнаружены.", 
		pInfo[playerid][pName],
		(pInfo[playerid][pSex] == 1) ? "мужской" : "женский",
		BloodGroupName[MedcardInfo[playerid][pMedcardBlood]], (MedcardInfo[playerid][pMedcardBloodDirection] == 1) ? "Rh+" : "Rh-",
		MedcardInfo[playerid][pMedcardDate],
		MedcardInfo[playerid][pMedcardDate]
	);
	ShowPlayerDialog(targetid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Медицинская карта", t_string, "Закрыть", "");

	t_string[0] = EOS;
	return true;
}  