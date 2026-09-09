CMD:addtg(playerid)
{
	str_q[0] = EOS;
	mysql_format(mysql,str_q,sizeof str_q,"SELECT tg_id FROM telegram WHERE owner_id=%d",GetPlayerAccountID(playerid));
	new Cache:result = mysql_query(mysql,str_q,true);
	if(cache_num_rows())
	{
		SCM(playerid,-1,"У вас привязан тг!");
	}
	else {
		Dialog(playerid,DIALOG_TG_PRIVAZKA,DIALOG_STYLE_INPUT,"Привязка Аккаунта Телеграмм!","Введите ваш телеграм код в поле ниже","Продолжить","Отмена");
	}
    cache_delete(result);
	return 1;
}
stock GenerateTGCode(playerid) 
{
    new code[5] = EOS;
	format(code, sizeof code, "%d", RandomEx(1000, 9999));
    mysql_queryf(mysql,"UPDATE `telegram` SET `code`=%d WHERE owner_id=%d",false,strval(code),GetPlayerAccountID(playerid));
    return 1;
}
stock tg_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem
    switch(dialogid)
    {
        case DIALOG_TG_PRIVAZKA:
        {
            if(!response) return 1;
            new id = strval(inputtext);
            if(!IsNumeric(inputtext)) return 1;
            str_q[0] = EOS;
            mysql_format(mysql,str_q,sizeof str_q,"SELECT id FROM telegram WHERE code=%d LIMIT 1",id);
            new Cache:result = mysql_query(mysql, str_q, true);
            if(cache_num_rows()) {
                new ida = cache_get_row_int(0, 0);
                mysql_queryf(mysql,"UPDATE telegram SET owner_id = %d, code = 0 WHERE id = %d",false,GetPlayerAccountID(playerid),ida);
                SCM(playerid,COLOR_GREEN,"Вы успешно привязали аккаунт к телеграмму!");
            }
            else {
                SCM(playerid,-1,"Кода не существует");
		        Dialog(playerid,DIALOG_TG_PRIVAZKA,DIALOG_STYLE_INPUT,"Привязка Аккаунта Телеграмм!","Введите ваш телеграм код в поле ниже","Продолжить","Отмена");
            }
            cache_delete(result);
        }
    }
    return 1;
}
stock OnAuthorizationCode(playerid,code[])
{
	if(!IsNumeric(code)) return 1;
	new coe = strval(code);
	str_q[0] = EOS;
	mysql_format(mysql,str_q,sizeof str_q,"SELECT code FROM telegram WHERE owner_id=%d",GetPlayerAccountID(playerid));
	new Cache:result = mysql_query(mysql,str_q,true);
	new codea = cache_get_row_int(0, 0);
	if(coe == codea)
	{
		mysql_queryf(mysql,"UPDATE `telegram` SET `code`=0 WHERE owner_id=%d",false,GetPlayerAccountID(playerid));
		SendClientEvent(playerid, s_CefInterface, t_CefHide, "Authorization");
		CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, LOGIN_STATE_LOAD_ACC, false);
		SendClientEvent(playerid, s_CefInterface, t_CefUpdate, "window.stopSound()");
		SetPlayerSpectateData(playerid, S_PLAYER, -1);
	}
	else {
		SendClientEvent(playerid, s_CefInterface, t_CefUpdate, "interface('Authorization').$refs.auth.setError(\"authCode\", \"Неправильный код\")");
	}
	cache_delete(result);
	return 1;
}