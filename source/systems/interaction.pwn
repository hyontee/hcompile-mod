new actplayer[MAX_PLAYERS];

Interaction_OnPlayerConnect(playerid)
{
	actplayer[playerid] = INVALID_PLAYER_ID;
}

Intrct_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES) 
	{ 
		if(GetPlayerTargetPlayer(playerid) != INVALID_PLAYER_ID) 
		{ 
	        new 
	            string[36],
 	           	targetid = GetPlayerTargetPlayer(playerid); 

	        format(string, sizeof string, ""colserver"%s[%d]", pInfo[targetid][pName], targetid); 
	        ShowPlayerDialog(playerid, D_INTERACTION, DIALOG_STYLE_LIST, string, ""colserver"[0]"colwhi" Показать паспорт\n"colserver"[1]"colwhi" Показать лицензий", "Выбрать", "Отмена");

	        actplayer[playerid] = targetid;
	        return 1; 
 	 	} 
	}
	return 1; 
}

CMD:updatev2arcane(playerid)
{
	new string[36];
	format(string, sizeof string, ""colserver"%s[%d]", pInfo[playerid][pName], playerid); 
	ShowPlayerDialog(playerid, D_INTERACTION, DIALOG_STYLE_LIST, string, ""colserver"[0]"colwhi" Показать паспорт\n"colserver"[1]"colwhi" Показать лицензий", "Выбрать", "Отмена");

	return actplayer[playerid] = playerid;
}