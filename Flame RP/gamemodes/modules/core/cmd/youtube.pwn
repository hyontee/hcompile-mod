CMD:yhelp(playerid) {
    if(!PI[playerid][pYoutube]) return 1;
	D(playerid,D_YOUTUBE_CMD,DSL,""P"Команды ютубера",""P"1."W" Начинающий [1]\n"P"2."W" Проверенный [2]\n"P"3."W" Официальный [3]","Выбрать","Отмена");
	return 1;
}
CMD:ysay(playerid, params[]) {
	static const fmt_str[] = "- %s {%s}(%s) [%d]";
	new string[sizeof(fmt_str) + (-8 + 64 + 6 + MAX_PLAYER_NAME + 4)];

	new 
		giveplayerid,
		message[64];

	if(!PI[playerid][pYoutube]) return 1;
	if(sscanf(params, "us[64]",giveplayerid,message)) return SendEsp(playerid, "/ysay [id] [текст сообщения]");

	if(strlen(message) > 64) return ErrorMessage(playerid, "Вы ввели слишком длинный текст");

	format(string,sizeof(string), fmt_str,message,GetColor(giveplayerid),player_name[giveplayerid],giveplayerid);
	
	SendOk(playerid, "Сообщение успешно отправлено");
	ProxDetector(25.0,giveplayerid,string,-1);

	SetPlayerChatBubble(giveplayerid, message, COLOR_WHITE, 20.0, 10000);
	return 1;
}
CMD:makeyt(playerid, params[]) {
	if(PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return true;
	new Name[30],Level;
	if(sscanf(params, "s[30]d",Name,Level)) return SendEsp(playerid, "/makeyt [id / ник] [уровень]");
	if(!(0 <= Level <= 3)) return ErrorMessage(playerid, "От 0 до 3");
	new query[128];
	if(IsNumber(Name)) {
		new id_name = strval(Name);
		if(!IsPlayerConnected(id_name)) return ErrorMessage(playerid, not_id);

		format(query, sizeof(query), "SELECT * FROM `youtubers` WHERE `Name` = '%s' LIMIT 1", player_name[id_name]);
		mysql_pquery(connects, query, "Youtuber", "dsd",playerid,player_name[id_name],Level);
		return 1;
	}
	mysql_format(connects, query, sizeof(query), "SELECT * FROM `youtubers` WHERE `Name` = '%e' LIMIT 1", Name);
	mysql_pquery(connects, query, "Youtuber", "dsd",playerid,Name,Level);
	return 1;
}