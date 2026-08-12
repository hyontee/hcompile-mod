#if defined _logs_inc
	#endinput
#endif
#define _logs_inc
new 
	LOG_MONEY_VALUE = 30000,
	LOG_FRACTION_MONEY_VALUE = 5000;
CMD:setlogs(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) 
		return 1;
	new value;
	if (sscanf(params, "i", value) || value < 1) {
		return err("/setlogs [money]");
	}
	LOG_MONEY_VALUE = value;
	err("setlogs success.");
	return true;
}
stock LogMoney(playerid, money, const reason[]) {
	if (reason[0] == '.' || money == 0 || -LOG_MONEY_VALUE <= money <= LOG_MONEY_VALUE) return;
	new 
		logs_string[256];
	mysql_format(dbHandle, logs_string, sizeof (logs_string), "\
		INSERT INTO `s_logs_money` \
		(`name`, `reason`, `amount`, `pCash`, `pBank`) VALUES \
		('%s[%i]', '%s', %i, %i, %i)",
		pInfo[playerid][pName], playerid, 
		reason, 
		money, 
		pInfo[playerid][pCash], 
		pInfo[playerid][pBank]
	);
	mysql_tquery(dbHandle, logs_string), logs_string[0] = EOS;
}
stock HistoryStoreLog(playerid, money, const reason[]) { 
	if (reason[0] == '.' || money == 0 || -LOG_FRACTION_MONEY_VALUE <= money <= LOG_FRACTION_MONEY_VALUE) return;
	new 
		logs_string[256];
	format(logs_string, sizeof logs_string, "INSERT INTO `s_logs_f_money` (`pID`, `pName`, `Money`, `Reason`, `pMember`, `pRank`) VALUES ('%d', '%s', '%d', '%s', '%d', '%d')",
		pInfo[playerid][pID],
		pInfo[playerid][pName],
		money,
		reason,
		pInfo[playerid][pMember],
		pInfo[playerid][pRank]
	);
	mysql_tquery(dbHandle, logs_string), logs_string[0] = EOS;
} 
enum {
	Log_Server = 0,
	Log_Money,
	Log_Admin,
	Log_Ban,
	Log_Warn/*,
	tCars,
	tHouse*/
}//logType:type = SERVER
//ÎÊåéLogTransferAll(playerid, targetid, money, reason, MAIN_LOG_SERVER:tMoney);
//new LogType[MAIN_LOG_SERVER];
/*stock LogTransferAll(playerid, targetid, money_amount, const action[], type = Log_Server)
{
	new 
		logs_string[198]; 
	if (targetid == INVALID_PLAYER_ID) {
		format(logs_string, sizeof logs_string, "INSERT INTO `s_logs` (`type`,`Name`,`tName`,`pCash`,`pBank`,`pDeposit`,`u_donate`,`action`,`date`) VALUES ('%d','%s','Server','%d','%d','%d','%d','%s',NOW())", 
			type, pInfo[playerid][pName], money_amount, action
		);
		mysql_tquery(dbHandle, logs_string), logs_string[0] = EOS;
	} else {
		format(logs_string, sizeof logs_string, "INSERT INTO `s_logs` (`type`,`Name`,`tName`,`pCash`,`pBank`,`pDeposit`,`u_donate`,`action`,`date`) VALUES ('%d','%s','%s','%d','%d','%d','%d','%s',NOW())", 
			type, pInfo[playerid][pName], pInfo[targetid][pName], money_amount, action
		);
		mysql_tquery(dbHandle, logs_string), logs_string[0] = EOS;
	}
	//return 1 ;
}*/

/*
LogTransferAll(playerid, targetid, money, reason, LogMoney);*/

stock LogsGiveMoney(playerid, targetid, money_amount, const action[], type = Log_Server)
{
	if (/*reason[0] == '.' || */money_amount == 0 || -LOG_MONEY_VALUE <= money_amount <= LOG_MONEY_VALUE) return;
	new  
		name_act[90]; 
	if (targetid == INVALID_PLAYER_ID) {
		format(name_act, sizeof name_act, "Ïîëó÷èë $%d %s", money_amount, action);
		format(t_string, sizeof t_string, 
			"INSERT INTO s_logs (type,Name,tName,pID,pCash,pBank,pDeposit,u_donate,action,date,pIp) \
			VALUES ('%d','%s','Server','%d','%d','%d','%d','%d','%s','%d','%s')", 
			type, pInfo[playerid][pName], pInfo[playerid][pID],
			pInfo[playerid][pCash], pInfo[playerid][pBank], pInfo[playerid][pDeposit], pInfo[playerid][pDonate], name_act, gettime(),
			pInfo[playerid][LastIP]
		);
		mysql_tquery(dbHandle, t_string), t_string[0] = EOS;
	} else {
		format(name_act, sizeof name_act, "Ïîëó÷èë $%d %s", money_amount, action);
		format(t_string, sizeof t_string, 
			"INSERT INTO s_logs (type,Name,tName,pID,tID,pCash,pBank,pDeposit,u_donate,action,date,pIp,tIp) \
			VALUES ('%d','%s','%s','%d','%d','%d','%d','%d','%d','%s','%d','%s','%s')", 
			type, pInfo[playerid][pName], pInfo[targetid][pName], pInfo[playerid][pID], pInfo[targetid][pID],
			pInfo[playerid][pCash], pInfo[playerid][pBank], pInfo[playerid][pDeposit], pInfo[playerid][pDonate], name_act, gettime(),
			pInfo[playerid][LastIP], pInfo[targetid][LastIP]
		);
		mysql_tquery(dbHandle, t_string), t_string[0] = EOS;
	}
	//return 1 ;
}
stock LogsUnGiveMoney(playerid, targetid, money_amount, const action[], type = Log_Server)
{
	if (/*reason[0] == '.' || */money_amount == 0 || -LOG_MONEY_VALUE <= money_amount <= LOG_MONEY_VALUE) return;
	new  
		name_act[90]; 
	if (targetid == INVALID_PLAYER_ID) {
		format(name_act, sizeof name_act, "Ïîòåðÿë $%d %s", money_amount, action);
		format(t_string, sizeof t_string, 
			"INSERT INTO s_logs (type,Name,tName,pID,pCash,pBank,pDeposit,u_donate,action,date,pIp) \
			VALUES ('%d','%s','Server','%d','%d','%d','%d','%d','%s','%d','%s')", 
			type, pInfo[playerid][pName], pInfo[playerid][pID],
			pInfo[playerid][pCash], pInfo[playerid][pBank], pInfo[playerid][pDeposit], pInfo[playerid][pDonate], name_act, gettime(),
			pInfo[playerid][LastIP]
		);
		mysql_tquery(dbHandle, t_string), t_string[0] = EOS;
	} else {
		format(name_act, sizeof name_act, "Ïîòåðÿë $%d %s", money_amount, action);
		format(t_string, sizeof t_string, 
			"INSERT INTO s_logs (type,Name,tName,pID,tID,pCash,pBank,pDeposit,u_donate,action,date,pIp,tIp) \
			VALUES ('%d','%s','%s','%d','%d','%d','%d','%d','%d','%s','%d','%s','%s')", 
			type, pInfo[playerid][pName], pInfo[targetid][pName], pInfo[playerid][pID], pInfo[targetid][pID],
			pInfo[playerid][pCash], pInfo[playerid][pBank], pInfo[playerid][pDeposit], pInfo[playerid][pDonate], name_act, gettime(),
			pInfo[playerid][LastIP], pInfo[targetid][LastIP]
		);
		mysql_tquery(dbHandle, t_string), t_string[0] = EOS;
	}
	//return 1 ;
}