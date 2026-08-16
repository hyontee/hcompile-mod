public: ShowPlayerLoginDialog(playerid, step, wrong_pass)
{
	if(GetPlayerData(playerid, P_ACCOUNT_STATE) != ACCOUNT_STATE_LOGIN) return 0;

	/*
	new request_type = REQUEST_TYPE_OFF;
	if(strcmp(GetPlayerIpEx(playerid), GetPlayerData(playerid, P_LAST_IP)) != 0)
	{
		request_type = REQUEST_TYPE_IP;
	}
	else
	{
		new subnet_last_ip[16], subnet_cur_ip[16];

		GetSubnet(subnet_cur_ip, GetPlayerIpEx(playerid));
		GetSubnet(subnet_last_ip, GetPlayerData(playerid, P_LAST_IP));

		if(strcmp(subnet_cur_ip, subnet_last_ip) != 0)
		{
			request_type = REQUEST_TYPE_SUBNET;
		}
	}
	*/

	new fmt_str[790];
	switch(step)
	{
		case LOGIN_STATE_CHECK_BAN:
		{
			new Cache: result;
			format(fmt_str, sizeof fmt_str, "SELECT * FROM ban_list WHERE user_id=%d LIMIT 1", GetPlayerAccountID(playerid));
			result = mysql_query(mysql, fmt_str, true);

			if (cache_num_rows())
			{
				new ban_time = cache_get_field_content_int(0, "time");
				new unban_time = cache_get_field_content_int(0, "ban_time");

				if (GetElapsedTime(unban_time, gettime(), CONVERT_TIME_TO_DAYS))
				{
					new admin_name[102] = "";
					new reason[1028] = "";

					cache_get_field_content(0, "admin", admin_name, mysql, sizeof(admin_name));
					cache_get_field_content(0, "description", reason, mysql, sizeof(reason));

					if (!strlen(reason))
						format(reason, sizeof reason, "Íå óêàçàíà");

					new year, month, day, hour, minute, second;
					new unyear, unmonth, unday, unhour, unminute, unsecond;

					timestamp_to_date(ban_time, year, month, day, hour, minute, second);
					timestamp_to_date(unban_time, unyear, unmonth, unday, unhour, unminute, unsecond);

					format(fmt_str, sizeof fmt_str,
						"{FFFFFF}Âàø èãðîâîé àêêàóíò áûë çàáëîêèðîâàí àäìèíèñòðàöèåé çà íàðóøåíèå\n"\
						"{FFFFFF}ïðàâèë ñåðâåðà. Âû íå ìîæåòå èãðàòü íà ñâîåì àêêàóíòå âî âðåìÿ\n"\
						"{FFFFFF}äåéñòâèÿ áëîêèðîâêè.\n\n"\
						""SC"Âàø íèêíåéì: {FFD700}%s\n"\
						""SC"Íèêíåéì àäìèíèñòðàòîðà: {FFD700}%s\n"\
						""SC"Äàòà âûäàííîé áëîêèðîâêè: {FFD700}%02d.%02d.%d - %02d:%02d:%02d\n"\
						""SC"Äàòà ðàçáëîêèðîâêè àêêàóíòà: {FFD700}%02d.%02d.%d - %02d:%02d:%02d\n"\
						""SC"Ïðè÷èíà áëîêèðîâêè: {FFD700}%s\n\n"\
						"{FFFFFF}Âû íå ñîãëàñíû ñ ðåøåíèåì àäìèíèñòðàòîðà è ñ÷èòàåòå, ÷òî íàêàçàíèå\n"\
						"{FFFFFF}áûëî âûäàíî íåñïðàâåäëèâî èëè îøèáî÷íî? Â òàêîì ñëó÷àå,\n"\
						"{FFFFFF}îáðàòèòåñü â ñïåöèàëüíûé ðàçäåë ñ æàëîáîé íà\n"\
						"{FFFFFF}îôèöèàëüíîì ôîðóìå ïðîåêòà: {FFD700}forum.xwenmobile.ru{FFFFFF}.\n\n"\
						"{FFFFFF}Íå çàáóäüòå ïðèêðåïèòü ñêðèíøîò äàííîãî îêíà â æàëîáó.",
						GetPlayerNameEx(playerid),
						admin_name,
						day, month, year, hour, minute, second,
						unday, unmonth, unyear, unhour, unminute, unsecond,
						reason
					);

					Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFD700}"SERVER_NAME" {FFFFFF}| Àêêàóíò çàáëîêèðîâàí", fmt_str, "Çàêðûòü", "");

					SetTimerEx("KickBannedPlayer", 5000, false, "i", playerid);
				}
				else 
				{
					format(fmt_str, sizeof fmt_str, "DELETE FROM ban_list WHERE user_id=%d LIMIT 1", GetPlayerAccountID(playerid));
					mysql_tquery(mysql, fmt_str, "", "");

					CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
				}
			}
			else
			{
				CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
			}

			return cache_delete(result);
		}
		case LOGIN_STATE_PASSWORD:
		{
			format
			(
fmt_str, sizeof fmt_str,
"{FFFFFF}Äîáðî ïîæàëîâàòü íà {FFD700}"SERVER_NAME"{FF3366}!\n\n\
{FFFFFF}Ðàäû ñíîâà âèäåòü âàñ íà íàøåì ïðîåêòå!\n\n\
{A9E6FF}{FFFFFF}Âàø ëîãèí: {33FF99}%s {A9E6FF}\n\
{FFFFFF}Ãîòîâû ïðîäîëæèòü ïðèêëþ÷åíèå?\n\n\
{FF0000}> {FFFFFF}Íèêîìó íå ñîîáùàéòå ñâîé ïàðîëü! ",
GetPlayerNameEx(playerid)
			);
			if(wrong_pass)
			{
				new ch[3];
				new attemps = GetPlayerData(playerid, P_PASS_ATTEMPS);

				valstr(ch, attemps);

				strcat(fmt_str, "{FF3300}Íåâåðíûé ïàðîëü! Îñòàëîñü ïîïûòîê: ");
				strcat(fmt_str, ch);

				AddPlayerData(playerid, P_PASS_ATTEMPS, -, 1);
				switch(attemps)
				{
					case 0:
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{FF9933}Ëèìèò ïîïûòîê àâòîðèçàöèè",
							"{FFFFFF}Âû ââåëè íåïðàâèëüíûé ïàðîëü 3 ðàçà ïîäðÿä", // . Âàø IP àäðåñ çàáàíåí íà ñóòêè
							"Çàêðûòü", ""
						);
						Kick:(playerid, " ");

						return 1;

						// BanEx(playerid, "Ëèìèò ïîïûòîê àâòîðèçàöèè");
						// return AddBan(0, gettime(), 1, GetPlayerIpEx(playerid), "Ëèìèò ïîïûòîê àâòîðèçàöèè", "Ñèñòåìà áåçîïàñíîñòè");
					}
					case 1:
					{
						SendClientMessage(playerid, 0xFF6600FF, "Ïðè íåïðàâèëüíîì ââîäå ïàðîëÿ Âû áóäåòå çàáàíåíû");
					}
				}
				PlayerPlaySound(playerid, 10.812850, 2513.402099, 1541.041992);
			}
			else strcat(fmt_str, "{FFFFFF} Ââåäèòå ïàðîëü îò àêêàóíòà:");

			Dialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{33FF99}XWEN MOBILE | {FFFFFF}Âõîä â àêêàóíò", "Ââåñòè", "Îòìåíà");
		}
		case LOGIN_STATE_PHONE: // ââîä 5 ïîñëåä. öèôð òåëåôîíà
		{
			if(GetPlayerData(playerid, P_REQUEST_PHONE))
			{
				if(!wrong_pass)
				{
					new phone[13];

					strmid(phone, GetPlayerData(playerid, P_SETTING_PHONE), 0, strlen(GetPlayerData(playerid, P_SETTING_PHONE)) - 5);
					strcat(phone, "*****");

					format
					(
						fmt_str, sizeof fmt_str,
						"{FFFFFF}Ñèñòåìà áåçîïàñíîñòè çàïðàøèâàåò ââîä\n"\
						"Âàøåãî ìîáèëüíîãî òåëåôîíà\n\n{f23a71}%s\n\n"\
						"{FFFFFF}Ââåäèòå ïîñëåäíèå 5 öèôð íîìåðà:",
						phone
					);
					Dialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{66CCFF}Ìîáèëüíûé òåëåôîí", fmt_str, "Ââåñòè", "Âûõîä");
				}
				else
				{
					SendClientMessage(playerid, 0xf23a3aFF, "Íîìåð ìîáèëüíîãî òåëåôîíà ââåäåí íåâåðíî. Äîñòóï çàïðåùåí");
					Kick:(playerid);
				}
			}
			else
			{
				return CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
			}
		}
		case LOGIN_STATE_PIN_CODE: // ââîä ïèí êîäà
		{
			if(GetPlayerData(playerid, P_REQUEST_PIN))
			{
				if(wrong_pass)
				{
					SendClientMessage(playerid, 0xf23a3aFF, "PIN-êîä ââåäåí íåâåðíî. Äîñòóï çàïðåùåí");
					Kick:(playerid);
				}
				else ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_LOGIN_CHECK);
			}
			else
			{
				return CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
			}
		}
		case LOGIN_STATE_LOAD_ACC:
		{
			SetPlayerData(playerid, P_AUTH_TIME, -1);
			LoadPlayerData(playerid);
		}
	}
	SetPlayerData(playerid, P_ACCOUNT_STEP_STATE, step);

	return 1;
}