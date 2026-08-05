#if defined _damages_included
	#endinput
#endif
#define _damages_included

#define MAX_DAMAGES_INFO	(20)

enum DAMAGES_E {
  	damagesTime,
  	damagesBodypart,
	damagesWeaponID,
	Float:damagesAmount,
}
new DamagesInfo[MAX_PLAYERS][MAX_DAMAGES_INFO][DAMAGES_E], NULL_DI[MAX_DAMAGES_INFO][DAMAGES_E];

alias:dm("damageinfo", "damages");
CMD:dm(playerid, params[]) {
	new targetid;
	if (sscanf(params, "u", targetid) || !IsPlayerConnected(targetid) || !TI[targetid][tLogin])
		return SendEsp(playerid, "/dm [id игрока]");
	damages_Show(playerid, targetid);
	return true;
}
stock damages_Record(playerid, bodypart, Float:amount, weaponid) {
	if (!(0 <= weaponid < 50) || !amount || !IsPlayerConnected(playerid)) return false;
	new id = -1;

	for (new i = 0; i < MAX_DAMAGES_INFO; i++) {
		if (!DamagesInfo[playerid][i][damagesTime] || !DamagesInfo[playerid][i][damagesAmount]) {
			id = i;
			break;
		}
	}
	if (id != -1) {
		DamagesInfo[playerid][id][damagesBodypart] = bodypart;
		DamagesInfo[playerid][id][damagesWeaponID] = weaponid;
		DamagesInfo[playerid][id][damagesAmount] = amount;
		DamagesInfo[playerid][id][damagesTime] = gettime();
	}
	return true;
}
CMD:dmrecordz(playerid, params[]) {
	new bodypart, Float:amount, weaponid;
	if (sscanf(params, "ifi", bodypart, amount, weaponid))
		return SendEsp(playerid, "/dmrecord bodypart Float:amount weaponid");
	damages_Record(playerid, bodypart, Float:amount, weaponid);
	return true;
}
stock damages_Clear(playerid) {
	DamagesInfo[playerid] = NULL_DI;
}
stock damages_Show(playerid, targetid) {
	format(STRING_GLOBAL, sizeof(STRING_GLOBAL),
		""P"Часть тела\t"P"Оружие\t"P"Урон\t"P"Время\n"
	);
	for (new i = 0, weapon[32]; i < MAX_DAMAGES_INFO; i++) {
		if (DamagesInfo[targetid][i][damagesTime] && DamagesInfo[targetid][i][damagesAmount]) {
  			GetWeaponName(DamagesInfo[targetid][i][damagesWeaponID], weapon, sizeof(weapon));

			/*printf("i%d w%d a%.2f t%d b%s wn%s", 
				i,
				DamagesInfo[targetid][i][damagesWeaponID],
				DamagesInfo[targetid][i][damagesAmount],
				DamagesInfo[targetid][i][damagesTime],
				GetBodypartName(DamagesInfo[targetid][i][damagesBodypart]),  
				DamagesInfo[targetid][i][damagesWeaponID],
				weapon

			);*/
	  		format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"W"\
	  			%s\
	  			\t%s\
	  			\t{B22222}-%.2fHP\
	  			\t"W"%s \n", STRING_GLOBAL,
				GetBodypartName(DamagesInfo[targetid][i][damagesBodypart]),  
				weapon,
				DamagesInfo[targetid][i][damagesAmount],
				damages_ConvertTime(gettime() - DamagesInfo[targetid][i][damagesTime])
			);
		}
  	}
	if (!strlen(STRING_GLOBAL))
		ErrorMessage(playerid, "У игрока нет активных повреждений.");
 	else ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, player_name[targetid], STRING_GLOBAL, "Закрыть", "");

 	STRING_GLOBAL[0] = 0;
  	return true;
}
stock GetBodypartName(bodypartid) {
	new name[14];
	switch(bodypartid) {
		case 3: name = "Тело";
		case 4: name = "Пах";
		case 5: name = "Левая рука";
		case 6: name = "Правая рука";
		case 7: name = "Левая нога";
		case 8: name = "Правая нога";
		case 9: name = "Голова";
		default: name = "Тело"; // unknown
	}
	return name;
}
stock damages_ConvertTime(time, ago = 1) {
	new str[32];
	if (time < 0 || time == gettime()) {
		format(str, sizeof(str), "Никогда");
		return str;
	}
	else if (time < 60)
		format(str, sizeof(str), "%d сек.", time);
	else if (time >= 0 && time < 60)
		format(str, sizeof(str), "%d сек.", time);
	else if (time >= 60 && time < 3600)
		format(str, sizeof(str), (time >= 120) ? ("%d мин.") : ("%d мин."), time / 60);
	else if (time >= 3600 && time < 86400)
		format(str, sizeof(str), (time >= 7200) ? ("%d ч.") : ("%d ч."), time / 3600);
	else if (time >= 86400 && time < 2592000)
		format(str, sizeof(str), (time >= 172800) ? ("%d д.") : ("%d д."), time / 86400);
	else if (time >= 2592000 && time < 31536000)
		format(str, sizeof(str), (time >= 5184000) ? ("%d мес.") : ("%d мес."), time / 2592000);
	else if (time >= 31536000)
		format(str, sizeof(str), (time >= 63072000) ? ("%d г.") : ("%d г."), time / 31536000);
	if (ago) strcat(str, " назад");
	return str;
}
