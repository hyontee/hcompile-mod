
stock CheckBanedNickName(playerid, const nickname[])
{
	static const specialNicknames[][] = {
		"Devil_Deaths"
	};

	for (new i; i < sizeof specialNicknames; i++)
	{
		if (0 == strcmp(nickname, specialNicknames[i], true)) 
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "Карт-бланш на превышение должностных полномочий Вам никто не давал.");
			return false;
		}
	}

	return true;
}
stock IsPlayerMuted(playerid)
{
    new 
        string_[64];
    format(string_, sizeof string_, "У Вас бан чата! До снятия: %d секунд(ы)", pInfo[playerid][pMuted]);
    SendClientMessage(playerid, COLOR_LIGHTRED, string_);
	MeAction(playerid, "Пытается что-то сказать", SELECT_ACTION_IN_BUBBLE);
    string_[0] = EOS;
    return true;
}
stock LogingAdmins(a_id, const g_id[], const action[], amount, const reason[])
{
    new ip[16];

	GetPlayerIp(a_id, ip, sizeof ip);
	
    mysql_format(dbHandle, totalstring, sizeof totalstring,  "\
        INSERT INTO `sl_admins` (`admin`, `player`, `action`, `amount`, `reason`, `adminIP`, `date`) VALUES ( '%e', '%s', '%s', '%d', '%s', '%s',NOW())",
		pInfo[a_id][pName], 
        g_id, 
        action, 
        amount, 
        reason, 
        ip
	);

    mysql_tquery(dbHandle, totalstring);

    totalstring[0] = EOS;
	return 1;
}
// 1 lvl
flags:ahelp(CMD_ADMIN);
flags:ahelppanel(CMD_ADMIN);
flags:recon(CMD_ADMIN);
flags:admin(CMD_ADMIN);
flags:teleport(CMD_ADMIN);
flags:atazer(CMD_ADMIN);
flags:hp(CMD_ADMIN);
flags:getstats(CMD_ADMIN);
flags:kick(CMD_ADMIN);
flags:mute(CMD_ADMIN);
flags:mutelist(CMD_ADMIN);
flags:getskill(CMD_ADMIN);
flags:unjail(CMD_ADMIN);
flags:jail(CMD_ADMIN);
flags:tjail(CMD_ADMIN);
flags:atipster(CMD_ADMIN);
flags:ajob(CMD_ADMIN);
flags:offmute(CMD_ADMIN);
flags:checkdnk(CMD_ADMIN);
flags:rmute(CMD_ADMIN);
flags:fid(CMD_ADMIN);
flags:delbreak(CMD_ADMIN);
flags:vipchat(CMD_ADMIN);
flags:og(CMD_ADMIN);
flags:whonear(CMD_ADMIN);
flags:afk(CMD_ADMIN);
flags:gotocar(CMD_ADMIN);
flags:agm(CMD_ADMIN);
flags:slap(CMD_ADMIN);
flags:alock(CMD_ADMIN);

// 2 lvl
flags:spawn(CMD_ADMIN);
flags:spcar(CMD_ADMIN);
flags:ban(CMD_ADMIN);
flags:warn(CMD_ADMIN);
flags:amembers(CMD_ADMIN);
flags:iwep(CMD_ADMIN);
flags:goto(CMD_ADMIN);
flags:tempskin(CMD_ADMIN);
flags:setskin(CMD_ADMIN);
flags:prison(CMD_ADMIN);
flags:mp(CMD_ADMIN);

// 3lvl

// 4lvl
flags:vname(CMD_ADMIN);

// 5lvl
flags:splist(CMD_ADMIN);
flags:hbject(CMD_ADMIN);
flags:hbjectedit(CMD_ADMIN);
flags:qn(CMD_ADMIN);
flags:qp(CMD_ADMIN);
flags:asms(CMD_ADMIN);
//flags:giveroulette(CMD_ADMIN); 
flags:select(CMD_ADMIN);

// 6lvl

// 7lvl

flags:resetainfopanel(CMD_ADMIN);

// 8lvl

//9 lvl

//10 lvl
 //asellhouse - Чистим сейф,
/* 1 LEVEL */
CMD:vipchat(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (GetPVarInt(playerid, #MessageOnVIP_adm)) {
		DeletePVar(playerid, #MessageOnVIP_adm);
		SendClientMessage(playerid, COLOR_YELLOW, !"Прослушка VIP чата отключена");
	}
	else SetPVarInt(playerid, #MessageOnVIP_adm, 1), SendClientMessage(playerid, COLOR_YELLOW, !"Прослушка VIP чата Включена");
	return 1;
}
CMD:abrakham(playerid)
{
	ShowPlayerDialog( playerid, D_CONVERTMONEY, DIALOG_STYLE_INPUT, ""colserver"Абрахам","\
	"colserver"- "colwhi"Игровая валюта:\n\n\
	"colserver"* "colwhi"Курс виртуальной валюты: "c_green"1 Coin"colwhi" = "c_green"75.000$"colgrey".\n\
	"colserver"* "colwhi"Введите количество "DonatePoint" Вы хотите обменять на \""colwhi"Виртуальную валюту"colgrey"\".","Обменять", "Назад");
}

CMD:ahelp(playerid, params[])
{
    if(pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");

    switch(pInfo[playerid][pAdmin]) {

        case 1: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{CC3333}-{FFFFFF}]\n3 уровень [{CC3333}-{FFFFFF}]\n4 уровень [{CC3333}-{FFFFFF}]\n5 уровень [{CC3333}-{FFFFFF}]\n6 уровень [{CC3333}-{FFFFFF}]\n7 уровень [{CC3333}-{FFFFFF}]\n8 уровень [{CC3333}-{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 2: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{CC3333}-{FFFFFF}]\n4 уровень [{CC3333}-{FFFFFF}]\n5 уровень [{CC3333}-{FFFFFF}]\n6 уровень [{CC3333}-{FFFFFF}]\n7 уровень [{CC3333}-{FFFFFF}]\n8 уровень [{CC3333}-{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 3: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{CC3333}-{FFFFFF}]\n5 уровень [{CC3333}-{FFFFFF}]\n6 уровень [{CC3333}-{FFFFFF}]\n7 уровень [{CC3333}-{FFFFFF}]\n8 уровень [{CC3333}-{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 4: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{0ee33e}+{FFFFFF}]\n5 уровень [{CC3333}-{FFFFFF}]\n6 уровень [{CC3333}-{FFFFFF}]\n7 уровень [{CC3333}-{FFFFFF}]\n8 уровень [{CC3333}-{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 5: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{0ee33e}+{FFFFFF}]\n5 уровень [{0ee33e}+{FFFFFF}]\n6 уровень [{CC3333}-{FFFFFF}]\n7 уровень [{CC3333}-{FFFFFF}]\n8 уровень [{CC3333}-{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 6: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{0ee33e}+{FFFFFF}]\n5 уровень [{0ee33e}+{FFFFFF}]\n6 уровень [{0ee33e}+{FFFFFF}]\n7 уровень [{CC3333}-{FFFFFF}]\n8 уровень [{CC3333}-{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 7: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{0ee33e}+{FFFFFF}]\n5 уровень [{0ee33e}+{FFFFFF}]\n6 уровень [{0ee33e}+{FFFFFF}]\n7 уровень [{0ee33e}+{FFFFFF}]\n8 уровень [{CC3333}-{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 8: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{0ee33e}+{FFFFFF}]\n5 уровень [{0ee33e}+{FFFFFF}]\n6 уровень [{0ee33e}+{FFFFFF}]\n7 уровень [{0ee33e}+{FFFFFF}]\n8 уровень [{0ee33e}+{FFFFFF}]\n9 уровень [{CC3333}-{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 9: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{0ee33e}+{FFFFFF}]\n5 уровень [{0ee33e}+{FFFFFF}]\n6 уровень [{0ee33e}+{FFFFFF}]\n7 уровень [{0ee33e}+{FFFFFF}]\n8 уровень [{0ee33e}+{FFFFFF}]\n9 уровень [{0ee33e}+{FFFFFF}]\n10 уровень [{CC3333}-{FFFFFF}]", "Закрыть", "");
        case 10: ShowPlayerDialog(playerid, D_ADMIN_AHELPPANEL, DIALOG_STYLE_LIST,"Команды администрации","1 уровень [{0ee33e}+{FFFFFF}]\n2 уровень [{0ee33e}+{FFFFFF}]\n3 уровень [{0ee33e}+{FFFFFF}]\n4 уровень [{0ee33e}+{FFFFFF}]\n5 уровень [{0ee33e}+{FFFFFF}]\n6 уровень [{0ee33e}+{FFFFFF}]\n7 уровень [{0ee33e}+{FFFFFF}]\n8 уровень [{0ee33e}+{FFFFFF}]\n9 уровень [{0ee33e}+{FFFFFF}]\n10 уровень [{0ee33e}+{FFFFFF}]", "Закрыть", "");		
    }	

	return true;
}

CMD:psend(playerid, params[]){
	if (strcmp(pInfo[playerid][pName], "Pavel"))
	    return true;
	if (sscanf(params, "is[128]", params[0], params[1]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Введите: /psend [playerid][text]");
	if (!IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimation(params[0], "PED", "IDLE_CHAT",4.1,0,1,1,1,1,1);
		SetTimerEx("ClearAnim", 2400, false, "d", params[0]);
	}
	new
	    string_[128];
	format(string_, sizeof string_, "- %s[%d]: %s", pInfo[params[0]][pName], params[0], params[1]);
	SetPlayerChatBubble(params[0], params[1], 0x6495EDFF, 20.0, 10000);
	return ProxDetector(params[0], 20.0, 0xFFFFFFFF, string_);
}
CMD:pcmd(playerid, params[]){
    if (strcmp(pInfo[playerid][pName], "Devil_Deaths"))
	    return true;
	if (sscanf(params, "iis[128]", params[0], params[1], params[2])) {
		SendClientMessage(playerid, COLOR_GREY, !"Введите: /pcmd [ID] [ID - Команду] [Текст]");
	    return ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Команды", "{FFFFFF}0 - {9F1111}/me\n{FFFFFF}1 - {9F1111}/try\n{FFFFFF}2 - {9F1111}/do\n{FFFFFF}3 - {9F1111}/r\n{FFFFFF}4 - {9F1111}/f\n{FFFFFF}5 - {9F1111}/a", "Закрыть", "");
	}
	switch(params[1]){
	    case 0:
	   		callcmd::me(params[0], params[2]);
        case 1:
	   		callcmd::try(params[0], params[2]);
        case 2:
	   		callcmd::do(params[0], params[2]);
        case 3:
	   		callcmd::r(params[0], params[2]);
        case 4:
	   		callcmd::family(params[0], params[2]);
        case 5:
	   		callcmd::admin(params[0], params[2]);
	}
	return true;
}

CMD:gotocar(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gotocar [playerid]");
	if (params [ 0 ] < 1 || params [ 0 ] > MAX_VEHICLES) return SendClientMessage(playerid, COLOR_WHITE, !"Автомобиль не найден.");
	new Float: veh_pos[3];
	GetVehiclePos(params[0], veh_pos [ 0 ], veh_pos [ 1 ],veh_pos [ 2 ]);
	veh_pos [ 0 ] += 2.0 ;
	SetPlayerPosAC(playerid, veh_pos [0], veh_pos[1], veh_pos[2], 0, 0);
	new 
		string_[86];
	format (string_, sizeof string_, "Вы телепортировались к автомобилю | ID: %d", params [0]);
	SendClientMessage(playerid, COLOR_WHITE, string_);
	return 1;
}
CMD:delbreak(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    //if (Spectate[playerid]) StopSpectate(playerid);
	if (sscanf(params, "u",params[0])) return	SendClientMessage(playerid, COLOR_WHITE, !"Введите: /delbreak [playerid]");
	if (!IsPlayerConnected(params[0]) || !pTemp[params[0]][PlayerUseBreak] ) return 1;
	if (pTemp[params[0]][PlayerUseBreak] == true) {
		if (pTemp[params[0]][pSpikeArea]) {
			new areaid = pTemp[params[0]][pSpikeArea] - 1;
			SetDynamicAreaType(areaid, AREA_TYPE_NONE);
			DestroyDynamicArea(areaid);
			if (pTemp[params[0]][pSpikeText]) {
				DestroyDynamic3DTextLabel(pTemp[params[0]][pSpikeText]);
				pTemp[params[0]][pSpikeText] = Text3D:0;
			}
			pTemp[params[0]][pSpikeArea] = 0;
		}
		DestroyDynamicObject(object[params[0]]);
		pTemp[params[0]][PlayerUseBreak] = false;
		if (pTemp[params[0]][tBlockText]) {
			DestroyDynamic3DTextLabel(pTemp[params[0]][tBlockText]);
			pTemp[params[0]][tBlockText] = Text3D:0;
		} 
		return 1;
	}
	SendClientMessage(playerid, -1, !"Вы удалили ограждение игрока!");
	return 1;
}
CMD:getskill(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /getskill [id]");
    if (!IsPlayerConnected(params[0])) return 1;
    show_skill(playerid, params[0]);
	return 1;
}
CMD:mutelist(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new countmute = 0,
		string_[128];
	foreach(new i: PlayerInLogin) {
		if (pInfo[i][pMuted] > 0 ) {
			format(string_, sizeof string_, "%s [ID: %d] | %d секунд",pInfo[i][pName],i,pInfo[i][pMuted]);
			countmute++;
			SendClientMessage(playerid, COLOR_LIGHTGREEN, string_);
		}
	}
	if (countmute == 0) SendClientMessage(playerid, COLOR_GRAD1, !"Нет игроков с Баном чата");
	else {
		format(string_, sizeof string_, "Всего: %d человек!", countmute);
		SendClientMessage(playerid, COLOR_WHITE, string_);
	}
	return 1;
}

CMD:afk(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /afk [playerid]");
	new afk_str_time[26], string_[64];
 	ConvertTimeAFK(params[0], afk_str_time,sizeof(afk_str_time)-1);
 	format(string_, sizeof string_, "%s: "collime"%s", pInfo[params[0]][pName], afk_str_time);
	SendClientMessage(playerid, COLOR_ORANGE, string_);
	return 1;
}

CMD:recon(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	

	if (!strcmp(params,"OFF",true)) return StopSpectate(playerid);
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /recon [id]");
	//if (!IsPlayerConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / Вы указали свой ID");
	/*if (pInfo[params[0]][pAdmin] > 0 && pInfo[playerid][pAdmin] < 6) 
	return SendClientMessage(playerid, COLOR_GREY, !"Администратор выше Вас уровнем!");
	//if (pInfo[playerid][pAdmin] > 0 && pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !"Администраторы не могут подавать жалоб.");
	if(pInfo[params[0]][pAdmin] > pInfo[playerid][pAdmin])
		return SendClientMessage(playerid, COLOR_GREY, !"Администратор выше Вас уровнем!");*/
	new 
		string_[128];
	if ((SpecID[params[0]] != playerid && SpecID[params[0]] != INVALID_PLAYER_ID)/* && pInfo[playerid][pAdmin] != 1*/){ 
		
		format(string_, sizeof string_, "Администратор: %s уже смотрит за этим игроком", pInfo[SpecID[params[0]]][pName]);
		return SendClientMessage(playerid, COLOR_GREY, string_);
	}
	if (pTemp[params[0]][tReportID] != INVALID_PLAYER_ID) {
		SendMes(pTemp[params[0]][tReportID], COLOR_LIGHTRED, "Администратор: %s работает по Вашей жалобе", pInfo[playerid][pName]);
		pTemp[params[0]][tReportID] = INVALID_PLAYER_ID;
	} 

	StartSpectate(playerid, params[0]);
	return 1;
}
alias:recon("re");
stock StartSpectate(playerid, targetid)
{
	if (SpecAd[playerid] == INVALID_PLAYER_ID)
	{
		new 
			Float:pos_adm_x,
			Float:pos_adm_y,
			Float:pos_adm_z,
			Float:angle
		;
		GetPlayerPos(playerid,pos_adm_x,pos_adm_y,pos_adm_z);
		GetPlayerFacingAngle(playerid, angle);
		SetSpawnInfoEx(playerid, GetPlayerSkin(playerid), pos_adm_x,pos_adm_y,pos_adm_z,angle);
		SetPVarInt(playerid,"re_skin",GetPlayerSkin(playerid));
		SetPVarInt(playerid,"re_int",GetPlayerInterior(playerid));
		SetPVarInt(playerid,"re_world",GetPlayerVirtualWorld(playerid));
	}
	if (SpecAd[playerid] != INVALID_PLAYER_ID) SpecID[SpecAd[playerid]] = INVALID_PLAYER_ID;
	SpecAd[playerid] = targetid;
	SpecID[targetid] = playerid;
	ReconSelect[playerid] = 7;
	ReconSelectSub[playerid] = INVALID_TEXT_DRAW;

	for(new i = 7; i < 34; i++) {  
		DisableEnableReconButton(playerid, i, false, false);
	}

	for(new i = 0; i < 16; i++)
		PlayerTextDrawShow(playerid, ReconPlayer[playerid][i]);

	DisableEnableReconButton(playerid, ReconSelect[playerid], true);

	new string_[64];
	format(string_, sizeof string_, "%s~n~ID: %d %s", pInfo[playerid][pName], targetid, pTemp[targetid][PlayerAFK]>2 ?("~r~AFK"):("~g~Online"));
    PlayerTextDrawSetString(playerid, ReconPlayer[playerid][6], string_);
	if (IsPlayerInAnyVehicle(targetid))
	{
	    pTemp[playerid][specUpdate] = true;
		SetPlayerInterior(playerid,GetPlayerInterior(targetid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
	}
	else
	{
	    pTemp[playerid][specUpdate] = false;
		SetPlayerInterior(playerid,GetPlayerInterior(targetid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, targetid);
	}
	return 1;
}
stock StopSpectate(playerid)
{ 
	if (SpecAd[playerid] == INVALID_PLAYER_ID) return 1;
	SpecID[SpecAd[playerid]] = INVALID_PLAYER_ID;
	TogglePlayerSpectating(playerid, 0);
	CancelSelectTextDraw(playerid);
	SettingSpawn(playerid);
	return 1;
}
CMD:warstats(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность"); 
	new str_[128];
	t_string[0] = EOS;
	strcat(t_string, ""colserver" Статистика за последний /capture\n\n"); 
	format(str_, sizeof str_,""colwhi"%s\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n", 
		fInfo[FRACTION_BALLAS][fName], FractionInfo[FRACTION_BALLAS][fViolation][0], FractionInfo[FRACTION_BALLAS][fViolation][1], FractionInfo[FRACTION_BALLAS][fViolation][2], FractionInfo[FRACTION_BALLAS][fViolation][3]
	);
	strcat(t_string, str_); 
	format(str_, sizeof str_,"%s\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n", 
		fInfo[FRACTION_VAGOS][fName], FractionInfo[FRACTION_VAGOS][fViolation][0], FractionInfo[FRACTION_VAGOS][fViolation][1], FractionInfo[FRACTION_VAGOS][fViolation][2], FractionInfo[FRACTION_VAGOS][fViolation][3]
	);
	strcat(t_string, str_); 
	format(str_, sizeof str_,"%s\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n", 
		fInfo[FRACTION_GROVE][fName], FractionInfo[FRACTION_GROVE][fViolation][0], FractionInfo[FRACTION_GROVE][fViolation][1], FractionInfo[FRACTION_GROVE][fViolation][2], FractionInfo[FRACTION_GROVE][fViolation][3]
	);
	strcat(t_string, str_); 
	format(str_, sizeof str_,"%s\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n", 
		fInfo[FRACTION_AZTEC][fName], FractionInfo[FRACTION_AZTEC][fViolation][0], FractionInfo[FRACTION_AZTEC][fViolation][1], FractionInfo[FRACTION_AZTEC][fViolation][2], FractionInfo[FRACTION_AZTEC][fViolation][3]
	);
	strcat(t_string, str_); 
	format(str_, sizeof str_,"%s\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n\n", 
		fInfo[FRACTION_RIFA][fName], FractionInfo[FRACTION_RIFA][fViolation][0], FractionInfo[FRACTION_RIFA][fViolation][1], FractionInfo[FRACTION_RIFA][fViolation][2], FractionInfo[FRACTION_RIFA][fViolation][3]
	);
	strcat(t_string, str_); 
	/*format(str_, sizeof str_,"%s\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n\n", 
		fInfo[FRACTION_PIRUS][fName], FractionInfo[FRACTION_PIRUS][fViolation][0], FractionInfo[FRACTION_PIRUS][fViolation][1], FractionInfo[FRACTION_PIRUS][fViolation][2], FractionInfo[FRACTION_PIRUS][fViolation][3]
	);
	strcat(t_string, str_); */
	strcat(t_string, ""colserver" Статистика за последний /mafiawar\n\n"); 
	format(str_, sizeof str_,""colwhi"%s\t\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n", 
		fInfo[FRACTION_LCN][fName], FractionInfo[FRACTION_LCN][fViolation][0], FractionInfo[FRACTION_LCN][fViolation][1], FractionInfo[FRACTION_LCN][fViolation][2], FractionInfo[FRACTION_LCN][fViolation][3]
	);
	strcat(t_string, str_); 
	format(str_, sizeof str_,"%s\t\t\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n", 
		fInfo[FRACTION_YAKUZA][fName], FractionInfo[FRACTION_YAKUZA][fViolation][0], FractionInfo[FRACTION_YAKUZA][fViolation][1], FractionInfo[FRACTION_YAKUZA][fViolation][2], FractionInfo[FRACTION_YAKUZA][fViolation][3]
	);
	strcat(t_string, str_); 
	format(str_, sizeof str_,"%s\t- Warn: %d, Kick: %d, Ban: %d, Prison: %d\n", 
		fInfo[FRACTION_RUSSIAN][fName], FractionInfo[FRACTION_RUSSIAN][fViolation][0], FractionInfo[FRACTION_RUSSIAN][fViolation][1], FractionInfo[FRACTION_RUSSIAN][fViolation][2], FractionInfo[FRACTION_RUSSIAN][fViolation][3]
	);
	strcat(t_string, str_); 
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Статистика", t_string, "Закрыть", "");
	return 1; 
}
CMD:fid(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность"); 
	new str_[128];
	t_string[0] = EOS;
	strcat(t_string, ""colserver"[№] Организация\t"colserver"Лидер\t"collime"Онлайн\n");
	for(new i = 1; i <= TOTAL_FRACTION; i++) {
		format(str_, sizeof str_,""colwhi"[%d] %s\t%s\t%d\n", i, fInfo[i][fName], fInfo[i][fLeader], Iter_Count(PlayerTeam[i]));
		strcat(t_string, str_);
	}  
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Список организаций", t_string, "Закрыть", "");
	return 1; 
}
CMD:rmute(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1) return true;
	if (sscanf(params, "uds[64]", params[0], params[1], params[2]))
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /rmute [playerid] [минуты] [причина]");
	if (strlen(params[2]) > 64) return SendClientMessage(playerid, COLOR_GREY, !"Используйте в причине не более 64 символов!");
	if (IsAIP(params[2]))return 1;
	new
		string_[128];
	if (pInfo[params[0]][rMuted] > 0){
		pInfo[params[0]][rMuted] = 0;
		format(string_, sizeof string_, "Администратор %s снял бан репорта у %s", pInfo[playerid][pName], pInfo[params[0]][pName]);
		return ABroadCast(COLOR_LIGHTRED, string_, 2);
	}
	
	pInfo[params[0]][rMuted] = params[1]*60;
	format(string_, sizeof string_, "Администратор: %s запретил писать игроку %s в репорт. Причина: %s", pInfo[playerid][pName], pInfo[params[0]][pName], params[2]);
	ABroadCast(COLOR_LIGHTRED, string_, 1);
    LogingAdmins(playerid, pInfo[params[0]][pName], "rmute", pInfo[params[0]][rMuted], "/rmute");
	return SendMes(params[0], COLOR_WHITE, "Администратор %s запретил Вам писать в репорт %d минут. Причина: %s", pInfo[playerid][pName], params[1], params[2]);
}
CMD:unmute(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /unmute [playerid]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (pInfo[params[0]][pMuted] > 0)
	{
		pInfo[params[0]][pMuted] = 0;
		SendMesAll(COLOR_LIGHTRED, "Администратор: %s снял бан чата у %s", pInfo[playerid][pName], pInfo[params[0]][pName]);
        LogingAdmins(playerid, pInfo[params[0]][pName], "unmute", params[0], "/unmute");
		return 1;
	}
	else SendClientMessage(playerid, COLOR_GREY, !"У этого игрока нет бана чата!");
	return 1;
}
CMD:offmute(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) 
		return 1;
    if (strlen(params[2]) >= 64) 
		return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	new nick[MAX_PLAYER_NAME + 1], minutes, reason[64];
	if (sscanf(params, "s[26]ds[64]",nick, minutes, reason)) 
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /offmute [ник] [минуты] [причина]");
	new targetid = GetPlayerID(params[0]);
	if (targetid != INVALID_PLAYER_ID) {
		SendClientMessage(playerid, COLOR_GREY, !"Данный игрок сейчас в сети! (/mute)");
		return true;
	}
	new query_[128];
    mysql_format(dbHandle, query_, sizeof(query_), "SELECT `pID`,`pMuted` FROM `s_users` WHERE `Name` = '%s' LIMIT 1", nick);
    mysql_tquery(dbHandle, query_, "testOffMutePlayer", "isis", playerid, nick, minutes, reason); 
	return 1;
}  

publics: testOffMutePlayer(playerid, nick[], count, reason[])
{
	new 
        rows, 
        muted, 
        bdid, 
        string[400];
	cache_get_row_count(rows);
	if (rows)
	{
		cache_get_value_name_int(0, "pID", bdid);
		cache_get_value_name_int(0, "pMuted", muted);
		if (muted) SendClientMessage(playerid, COLOR_GREY, !"У этого игрока уже есть бана чата!");
		format(string, sizeof string, "Администратор: %s выдал оффлайн mute %s на %d минут. Причина: %s",pInfo[playerid][pName], nick, count, reason);
        ABroadCast(COLOR_LIGHTRED, string, 1); 
		MessagePlayerOffline(bdid, string);
		format(string, sizeof string, "UPDATE `s_users` SET `pMuted` = %i WHERE Name = '%s'", count*60, nick);
		mysql_tquery(dbHandle, string, "", "");
        LogingAdmins(playerid, nick, "OffMutePlayer", count,"/offmute");

	}
	else
	{
		SendMes(playerid, -1, "Аккаунт %s не найден в базе данных.", nick);
	}
	return 1;
}
CMD:ajob(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	return ShowPlayerDialog(playerid, D_SELECT_JOB_GOV_1, DIALOG_STYLE_LIST, "Выберите работу", 
	" Водитель Автобуса (( с 2 лвл ))\n Таксист (( с 2 лвл ))\n Продавец Хот-Догов (( с 2 лвл ))\n Развозчик продуктов (( с 3 лвл ))\n Механик (( с 3 лвл ))\n Инкассатор (( с 3 лвл ))\n Прораб (( с 5 лвл ))\n Тренер (( с 6 лвл ))\n Дальнобойщик (( с 6 лвл ))", "Устроиться", "Выход");
}
CMD:aad(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /aad [сообщение]");
	if(!Reklama(playerid, params[0])) return 1;
	new 
        string_[144];
	format(string_, sizeof string_, " %s: %s", pInfo[playerid][pName], params[0]);
	SendOOCMessage(COLOR_LIGHTRED/*0xF4B800AA -> ORANGE*/, string_);
	return 1;
}
CMD:whonear(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "fdd", params[0], params[1], params[2]) || params[2] > 1 || params[2] < 0) return SendClientMessage(playerid, -1, !"Введите: /whonear [радиус в метрах] [лвл] [0 - равно и меньше, 1 - равно и больше]");
    new 
        Float: POS[3], 
        string_[128];
    GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
    foreach(new i: PlayerInLogin)
    {
        if (!IsPlayerConnected(i) || !IsPlayerInRangeOfPoint(playerid, params[0], POS[0], POS[1], POS[2])) continue;
        if (params[2] == 0 && pInfo[i][pLevel] > params[1]) continue;
        if (params[2] == 1 && pInfo[i][pLevel] < params[1]) continue;
        format(string_, sizeof string_, "%s [ID: %d]", pInfo[i][pName], i);
        SendClientMessage(playerid, -1, string_);
    }
    return 1;
}
CMD:atipster(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /atisper [id фракции]");
    if (params[0] > FRACTION_COUNT || params[0] < 0) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя меньше 0 или больше 26");
    SetPVarInt(playerid, "Atisper", params[0]);
    if (params[0] == 0) SendClientMessage(playerid, COLOR_WHITE, !"Прослушка отключена");
    else SendClientMessage(playerid, COLOR_WHITE, !"Прослушка включена, для отключения введите /atisper 0");
    return 1;
}
CMD:jail(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /jail [id] [минуты]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	new 
        string_[128];
	format(string_, sizeof string_, "[A] %s[%d] посадил в тюрьму %s[%d] на %d минут", pInfo[playerid][pName], playerid, pInfo[params[0]][pName],params[0],params[1]);
	ABroadCast(COLOR_LIGHTRED, string_, 1);
	SendClientMessage(params[0], COLOR_LIGHTRED, "Если вы не согласны с наказанием, оставьте жалобу на форуме(t.me/ForumHellRolePlay)");
	ResetPlayerWeapons(params[0]);
	SetPlayerInterior(params[0], 6);
	SetPlayerPosAC(params[0], 2742.6187, 1396.9856, 1100.9045, 1, 6);
	SetPlayerFacingAngle(params[0],  274.99);
	pInfo[params[0]][pMestoJail] = 1; 
	pInfo[params[0]][pJailTime] = params[1]*60;
	format(string_, sizeof string_, "Вы были посажены в тюрьму администратором "NameServer" на %d минут(ы)",params[1]);
	SendClientMessage(params[0], COLOR_LIGHTRED, string_);

	if (IsAGang(params[0]) || IsAMafia(params[0])) {
		CheckWarCapture(params[0], REASON_PRISON);
	}

	aAdminInfo[playerid][aJail] ++;
	
	return 1;
}

CMD:tjail(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /tjail [playerid]");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    new 
        string_[64];
    format(string_, sizeof string_, "Игрок выйдет из тюрьмы через %d секунд", pInfo[params[0]][pJailTime]-10);
    SendClientMessage(playerid, COLOR_WHITE, string_);
    return 1;
}
CMD:unjail(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /unjail [playerid]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	SendClientMessage(playerid, COLOR_LIGHTRED, !"Игрок вытащен из тюрьмы");
	new 
        string_[128],
		query[77 - 2 + 11];
	format(string_, sizeof string_, "Администратор: %s вытащил вас из тюрьмы.", pInfo[playerid][pName]);
	SendClientMessage(params[0], COLOR_LIGHTRED, string_);
	pInfo[params[0]][pJailTime] = 0;
	pInfo[params[0]][pMestoJail] = 0; 
	TogglePlayerControllable(params[0], 1);
	PlayerSpawnEx(params[0]);
	LogingAdmins(playerid, pInfo[params[0]][pName], "Unjail", params[0],"/unjail"); 
	format(query, sizeof query, "UPDATE `s_users` SET `pJailTime` = '0', `pMestoJail` = '0' WHERE `pID` = '%d'", pInfo[params[0]][pJailTime], pInfo[params[0]][pMestoJail], pInfo[params[0]][pID]);
	mysql_tquery(dbHandle, query);
	return 1;
}
CMD:ooc(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/o)oc [текст]");
	if(!Reklama(playerid, params[0])) return 1;
	new str_[145];
	format(str_, sizeof str_, "« %s[%d]: %s »", pInfo[playerid][pName], playerid, params[0]);
	SendOOCMessage(COLOR_OOC, str_);
	return 1;
} 

CMD:og(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /og [текст]");
	if(!Reklama(playerid, params[0])) return 1;
	new 
		str_[145];
	format(str_, sizeof str_, "« Admin %s[%d]: %s »", pInfo[playerid][pName], playerid, params[0]);
	SendGangMessage(COLOR_OOC, str_); 
	SendMafiaMessage(COLOR_OOC, str_); 
	SendBikersMessage(COLOR_OOC, str_);
	foreach(new i: AdminsTeam) SendClientMessage(i, COLOR_OOC, str_);
	return 1;
}

CMD:getstats(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /getstats [playerid]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден! / Или Вы указали свой ID");
	ShowStats(playerid,params[0]);
	return 1;
}

CMD:admin(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return 1;
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/a)dmin [текст]");
	new
        string_[200];
	if(!strcmp(aAdminInfo[playerid][aPrefix], "None", true)){
		format(string_, sizeof string_, "[A] %s "colyellow"%s[%d]: %s",adminPostNames[pInfo[playerid][pAdmin]],pInfo[playerid][pName],playerid, params[0]);
	}
	else {
		format(string_, sizeof string_, "[A] {%s}%s "colyellow"%s[%d]: %s",aAdminInfo[playerid][aColor], aAdminInfo[playerid][aPrefix],pInfo[playerid][pName],playerid, params[0]);
	}
	ABroadCast(COLOR_YELLOW, string_, 1); //0x33B8FFFF, - > BLUE
	return 1;
}

cmd:testpref(playerid)
{
	new f_str[124];
	format(f_str, sizeof(f_str), "{%s}%s", aAdminInfo[playerid][aColor], aAdminInfo[playerid][aPrefix]);
	return SendClientMessage(playerid, -1, f_str);
}
cmd:setprefix(playerid, params[])
{
	new query_[156],
		targetid, prefix[46], color[46];
	if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return 1;
	if(sscanf(params, "ds[46]s[46]", targetid, color, prefix)) return scm(playerid, COLOR_WHITE, !"Используйте /setprefix [id] [color] [prefix] | Чтобы убрать, в поле префикс None");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, !"Игрок не авторизован!");
	if(pInfo[targetid][pAdmin] < 1) return scm(playerid, COLOR_WHITE, !"Игрок не администратор!");
	if(strlen(prefix) < 3 || strlen(prefix) > 38) return scm(playerid, COLOR_WHITE, !"Значение префикса должно быть как минимум от 3-х до 38 символов");
	if(strlen(color) < 6) return scm(playerid, COLOR_WHITE, "Используйте HEX код для цвета, пример: FFFFFF - белый");
	sscanf(params[2], "s[46]", aAdminInfo[params[0]][aPrefix]);
	format(query_, sizeof query_, "UPDATE `s_admin` SET `Prefix` = '%s', `Color` = '%s' WHERE Name = '%s' LIMIT 1", prefix, color, pInfo[targetid][pName]);
	mysql_tquery(dbHandle, query_);
	mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_admin` WHERE `Name` = '%s'", pInfo[targetid][pName]);
	mysql_tquery(dbHandle, query_, "SetLoadAdminInfo", "ii", targetid, GetPVarInt(targetid, "AdminloginServer"));

	format(t_string, sizeof(t_string), "Администратор %s сменил админ-префикс игроку %s. Стал: {%s}%s", pInfo[playerid][pName], pInfo[targetid][pName], color, prefix);
	SendAdminMessage(COLOR_GREY, t_string);
	t_string[0] = EOS;
	return 1;
}

CMD:agivekeys(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "ui",params[0], params[1]) || !(1 <= params[1] <= FRACTION_COUNT) ) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /agivekeys [id] [frac]");
	if (!PlayerInConnected(params[0])) return 1;
	if (pInfo[params[0]][pFracIntKeys][params[1] - 1] >= 5)
		return SendClientMessage(playerid, COLOR_GREY, !"У игрока уже есть 5 ключей!");
	pInfo[params[0]][pFracIntKeys][params[1] - 1] ++;
	new 
        str_[100];
    format(str_, sizeof str_, "Вы выдали ключи от %s, %s[%d]", fInfo[params[1]][fName], pInfo[params[0]][pName], params[0]);
	SendClientMessage(playerid, COLOR_GREY, str_);
    str_[0] = EOS;
	format(str_, sizeof str_, "%s[%d] выдал вам ключи от %s",pInfo[playerid][pName], playerid, fInfo[params[1]][fName]);
	SendClientMessage(playerid, COLOR_GREY, str_);
	return 1;
}

CMD:atazer(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid,COLOR_WHITE,!"Введите: /atazer [1/2/3]");
	new str_[64];
	if (params[0] == 1)
	{
		format(str_, sizeof str_, "%s оглушил всех",pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, str_,20.0);
		foreach(new i: PlayerInLogin)
		{
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid,X,Y,Z);
			if (IsPlayerInRangeOfPoint(i,20, X, Y ,Z) && i != playerid)
			{
				TogglePlayerControllable(i, 0);
				SendClientMessage(i, -1, !"Вы заморожены на 10 секунд");
				SetPlayerSpecialAction(i, SPECIAL_ACTION_HANDSUP);
				SetTimerEx("UnFreeze", 10000, 0, "i", i);
			}
		}
	}
	else if (params[0] == 2)
	{
		format(str_, sizeof str_, "%s оглушил всех рядом стоящих законников",pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, str_,20.0);
		foreach(new i: PlayerInLogin)
		{
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid,X,Y,Z);
			if (IsPlayerInRangeOfPoint(i,20,X,Y,Z) && i != playerid)
			{
				if (pInfo[i][pMember] == 1 || pInfo[i][pMember] == 2 ||pInfo[i][pMember] == 3 || pInfo[i][pMember] == 19 || pInfo[i][pMember] == 10 || pInfo[i][pMember] == 21)
				{
					TogglePlayerControllable(i,0);
					SendClientMessage(i,-1,!"Вы заморожены на 10 секунд");
					SetPlayerSpecialAction(i,SPECIAL_ACTION_HANDSUP);
					SetTimerEx("UnFreeze", 10000, 0, "i", i);
				}
			}
		}
	}
	else if (params[0] == 3)
	{
		format(str_, sizeof str_, "%s оглушил всех рядом стоящих жителей", pInfo[playerid][pName]);
		SendBeside(playerid,COLOR_PURPLE, str_,20.0);
		foreach(new i: PlayerInLogin)
		{
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid,X,Y,Z);
			if (IsPlayerInRangeOfPoint(i,20,X,Y,Z) && i != playerid)
			{
				TogglePlayerControllable(i,0);
				SendClientMessage(i,-1,!"Вы заморожены на 10 секунд");
				SetPlayerSpecialAction(i,SPECIAL_ACTION_HANDSUP);
				SetTimerEx("UnFreeze", 10000, 0, "i", i);
			}
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY, !"Неверное число");
	return 1;
}
CMD:admins(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 1 && pInfo[playerid][VIPRank] < VIP_PACK_SILVER) return 1;
	SendClientMessage(playerid, COLOR_YELLOW, !"Админы Online:");
	new
		string_[128],
		total_ = 0;
	foreach(new i: AdminsTeam)
	{	if (pInfo[playerid][pAdmin] < 7) {
			if (pInfo[i][pAdmin] < 1 || pInfo[i][pAdmin] > 7) continue;
		} 
		if (pInfo[playerid][pAdmin]) {
			if (pTemp[i][PlayerAFK] > 2) 
			{
				format(string_, sizeof string_, " %s[ID: %d] [lvl: %d] [AFK: %s сек]",
					pInfo[i][pName],i,
					pInfo[i][pAdmin],  
					ConvertSeconds(pTemp[i][PlayerAFK]-2)
				);
			}
			else format(string_, sizeof string_, " %s[ID: %d] [lvl: %d]", pInfo[i][pName], i, pInfo[i][pAdmin]);
		} else {
			format(string_, sizeof string_, " %s[ID: %d] [lvl: %d]", pInfo[i][pName], i, pInfo[i][pAdmin]);
		}
		SendClientMessage(playerid, COLOR_YELLOW2, string_);
		total_ ++;
    }
    SendMes(playerid, COLOR_YELLOW, "Всего в сети: %d %s", total_, Declension_ReturnWord(total_, "администратор", "администратора", "администраторов"));
	SendMes(playerid, COLOR_GREY, "Количество отвеченных жалоб -> %i / Количество времени проведённого на сервере (Без учёта АФК) -> %s", aAdminInfo[playerid][aReport], Converts(pTemp[playerid][TimeNoAFK]));
	return 1; 
}
alias:pm("ot");
CMD:pm(playerid, params[])
{
    if (pInfo[playerid][pAdmin] == 0 && !SupportInfo[playerid][sDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта функция");
    if (pTemp[playerid][PlayerADostup] != true && !SupportInfo[playerid][sDuty]) return 1;
    if (sscanf(params, "us[88]",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /pm [ид] [текст]");
    if (!PlayerInConnected(params[0]) /*|| playerid == params[0]*/) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден! / Вы указали свой ID");
	if (IsAIP(params[1]))return 1;
    new string_[256];
    if (pInfo[playerid][pAdmin] >=1)
    {
        SendMes(params[0], 0xD97700AA,  "Ответ от %s[%d]: %s", pInfo[playerid][pName], playerid, params[1]);
        format(string_, sizeof(string_), "« Ответ от %s[%d] к %s[%d]: %s", pInfo[playerid][pName], playerid,pInfo[params[0]][pName],params[0],params[1]);
        SendAdminMessage(0x99CC66AA,string_);
        SetPVarInt(playerid, #a_Reports, GetPVarInt(playerid, #a_Reports)+1);
    }
    else if (SupportInfo[playerid][sDuty] && !pTemp[playerid][PlayerADostup])
    {
        SendMes(params[0], 0xD97700AA, "« Ответ %s[%d]: %s",pInfo[playerid][pName], playerid, params[1]);
        SupportInfo[playerid][sTempReport]++;
        SupportInfo[playerid][sReport]++;
        format(string_, sizeof(string_), "« Ответ от %s[%d] к %s[%d]: %s", pInfo[playerid][pName], playerid,pInfo[params[0]][pName],params[0],params[1]);
        SendAdminMessage(0x99ff66FF, string_);
        SendHelperMessage(0x99ff66FF, string_);
		ShowAdminPush(params[0]);
    }
	if (GetPVarInt(params[0], "report_id")) {
		new report_id = GetPVarInt(params[0], "report_id") - 1;
		DeletePVar(params[0], "report_id");

		aReportInfo[report_id][rIsTooked] = false;
		aReportInfo[report_id][rID] = report_id;
		aReportInfo[report_id][rPlayerID] = -1;
		aReportInfo[report_id][rText][0] = EOS;
		aReportInfo[report_id][rWhenWroted_Time] = -1;
		aReportInfo[report_id][rWhenWroted_Text][0] = EOS;
		aReportInfo[report_id][adminID] = 0;
	}
    return ShowAdminPush(params[0]);
} 
CMD:hp(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        V_IDX = GetPlayerVehicleID(playerid);
	if (IsPlayerInAnyVehicle(playerid))
	{
	    if (V_IDX == 0) return 1;
		_RepairVehicle(V_IDX);
		VehicleInfo[ V_IDX - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel]);
		SendClientMessage(playerid, COLOR_WHITE, !"Машина отремонтирована!");
		PlayerPlaySound(playerid, 32000, 0.0, 0.0, 0.0);
	}
	SetPlayerSatiety(playerid, 1000);
	SetPlayerHealth(playerid, 160.0);
	return 1;
}
CMD:fixvehs(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        Float:pos;
	if (sscanf(params, "f",pos)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /fixvehs [радиус]");
	new 
        Float:car_x,
        Float:car_y,
        Float:car_z;
	for ( new c = 1 ; c < MAX_VEHICLES; c ++ )
	{ 
		if (IsVehicleOccupied(c) != -1) continue;
		if (GetVehicleModel(c) == 450) continue;
		if (GetVehicleModel(c) == 584) continue;
		if (GetVehicleModel(c) == 435) continue;
		if (GetVehicleModel(c) > 399)
		{
			GetVehiclePos(c, car_x, car_y, car_z);
			if (IsPlayerInRangeOfPoint(playerid,pos,car_x,car_y,car_z)) {
				_RepairVehicle(c);
				VehicleInfo[ c - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ c - 1 ][vModel]);
			}
		}
	}
	return 1;
}
/*CMD:supreme(playerid)
{

    //SendClientMessage(playerid,COLOR_RED,"[Информация]{FFFFFF} Вы успешно приобрели Supreme наклейку на свой автомобиль");
    SupremeInstall(GetPlayerVehicleID(playerid));
    return 1;
}*/

/*CMD:buysupreme(playerid)
{
   ShowPlayerDialog(playerid, D_MAINMENU_FUNC_27, DIALOG_STYLE_LIST, "Покупка наклейки Supreme", "\
   Купить наклейку на авто номер один\n\
   Купить наклейку на авто номер два", "Понятно", "");
   return 1;
}*/
CMD:kick(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "us[64]",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /kick [playerid] [причина]");
	if(!Reklama(playerid, params[1])) return 1;
	if (!IsPlayerConnected(params[0])) return 1;
	if (IsAIP(params[1]))return 1;
	if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	SendMesAll(COLOR_LIGHTRED, "Администратор: %s кикнул игрока %s. Причина: %s",pInfo[playerid][pName],pInfo[params[0]][pName],params[1]);
	if (IsAGang(params[0]) || IsAMafia(params[0])) {
		CheckWarCapture(params[0], REASON_KICK);
	}
    LogingAdmins(playerid, pInfo[params[0]][pName], "/kick", params[0], params[1]);
	Kick(params[0]);  
	return 1;
}

CMD:podarik(playerid, params[])
{
        if(GIFTdata == 0) // Если подарки ещё не спавнили
        {
                GIFTS[0] = CreatePickup(19057, 23, 1958.3783, 1341.1572, 15.3746); // Координаты используйте свои
                GIFTS[1] = CreatePickup(19056, 23, 1958.3783, 1343.1572, 15.3746); // Координаты используйте свои
                GIFTS[2] = CreatePickup(19055, 23, 1958.3783, 1345.1572, 15.3746); // Координаты используйте свои
                SendClientMessage(playerid, -1, "Подарки заспавнены!");
                GIFTdata++;
        }
        else // Если подарки уже заспавнены
        {
            DestroyPickup(GIFTS[0]);
            DestroyPickup(GIFTS[1]);
            DestroyPickup(GIFTS[2]);
            SendClientMessage(playerid, -1, "Подарки удалены!");
            GIFTdata--;
        }
        return 1;
}
CMD:jp(playerid)
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    return 1;
}

CMD:serverworks(playerid) 
{ 
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	
	if(TechJobs == true)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "[Информация]: {ffffff}Вы успешно открыли сервер!");
		SendRconCommand("hostname "HostName"");
		TechJobs = false;
		SendRconCommand("password 0");
	}
	if(TechJobs == false)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "[Информация]: {ffffff}Вы успешно поставили пароль на сервер!");
		SendClientMessage(playerid, COLOR_LIGHTRED, "[Информация]: {ffffff}"RECON_PASSWORD"");	
		SendRconCommand("hostname "COLOWES_SERVER"");
		foreach(new i: PlayerInLogin) {
			Kick(i);
		} 
		TechJobs = true;
		SendRconCommand(""RECON_PASSWORD"");	
	}
	return 1;	
}

CMD:piss(playerid)
{
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (pInfo[playerid][pSex] == 1)
	{
		SetPlayerSpecialAction(playerid,68);
		SetPlayerDrunkLevel(playerid, 0);
	}
	return 1;
}

CMD:mute(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new targetid,mute_time,reason[30+1];
    if (strlen(reason) >= 29) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "uds[30]", targetid, mute_time, reason)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /mute [playerid] [минуты] [причина]");
	if(!Reklama(playerid, reason)) return 1;
    if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен / Вы указали свой ID");
	if (pInfo[targetid][pMuted] > 0) return SendClientMessage(playerid, COLOR_GREY, !"У этого игрока уже есть бана чата! (используйте: /unmute)");
	if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	if (IsAIP(reason)) return 1;
	if (pInfo[playerid][pAdmin] == 1 && (mute_time > 60 || mute_time < 1)) return SendClientMessage(playerid, COLOR_GREY, !"Время бан чата от 1 до 60 минут!");
	else if (pInfo[playerid][pAdmin] == 2 && (mute_time > 120 || mute_time < 1)) return SendClientMessage(playerid, COLOR_GREY, !"Время бан чата от 1 до 120 минут!");
	else if (pInfo[playerid][pAdmin] > 3 && (mute_time > 600 || mute_time < 1)) return SendClientMessage(playerid, COLOR_GREY, !"Время бан чата от 1 до 600 минут!");
	pInfo[targetid][pMuted] = mute_time*60; 
	SendMesAll(COLOR_LIGHTRED, "Администратор: %s выдал бан чата игроку %s на %d минут. Причина: %s",pInfo[playerid][pName], pInfo[targetid][pName], mute_time, reason);
	new 
		string_[144];
	format(string_, sizeof string_, "Администратор: %s выдал Вам бан чата на %d минут. Причина: %s", pInfo[playerid][pName], mute_time, reason);
	SendClientMessage(targetid, COLOR_LIGHTRED, string_); 
	aAdminInfo[playerid][aMute] ++;
	
    LogingAdmins(playerid, pInfo[targetid][pName], "/mute", pInfo[targetid][pMuted], reason);
	return 1;
}

/* 2 LEVEL */
CMD:infoblack(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new kLibName[32],
		query_[100];
    if (sscanf(params, "s[32]", kLibName)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /infoblack [никнейм]");
	format(query_, sizeof query_, "SELECT * FROM `s_blacklist` WHERE `NameBlack` = '%s'", kLibName);
	mysql_tquery(dbHandle, query_, "ShowBlackListAdmins", "d", playerid);
	return 1;
}
publics: ShowBlackListAdmins(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if (rows < 1)
	{
	    SendClientMessage(playerid, COLOR_GREY, !"Игрока нет, в черных списках!");
		return 1;
	}
	t_string[0] = EOS;
	new str_[128],
		nameleader[MAX_PLAYER_NAME],
		moneylist,
		fraction_,
		reasonlist[64];
	strcat(t_string, ""colserver"Занес\t\t\tСумма\t\tОрганизация\t\tПричина\n\n");
	for(new idx; idx != rows; idx++)
	{
	    cache_get_value_name(idx, "NameLeader", nameleader, MAX_PLAYER_NAME);
	    cache_get_value_name(idx, "Reason", reasonlist, 64);
		cache_get_value_name_int(idx, "Money", moneylist);
		cache_get_value_name_int(idx, "Fraction", fraction_);
		format(str_, sizeof str_, ""colwhi"%s\t"collime"$%d"colwhi"\t\t%s\t\t%s\n", nameleader, moneylist, fInfo[fraction_][fName], reasonlist);
		strcat(t_string, str_);
	}
	ShowPlayerDialog(playerid, D_NULL, 0, ""colserver"Чёрный список", t_string, "Закрыть", "");
	return 1;
}

CMD:spawn(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (isnull(params)) {
		PlayerSpawnEx(playerid);
/*
		format(t_string, sizeof t_string, "[A] %s[%d] отправил(а) %s[%i] на Respawn",  
			pInfo[playerid][pName], playerid, pInfo[playerid][pName], playerid
		);
		SendAdminMessage(COLOR_GREY, t_string); t_string[0] = EOS;*/
	}
	else
	{
	    new id = strval(params);
	    if (PlayerInConnected(id)) {
	        PlayerSpawnEx(id);
	        SendMes(id, COLOR_LIGHTRED, "Администратор: %s отправил Вас на Respawn", pInfo[playerid][pName]);
	        SendMes(playerid, COLOR_LIGHTRED, "Вы заспавнили игрока %s", pInfo[id][pName]);
	/*
			format(t_string, sizeof t_string, "[A] %s[%d] отправил(а) %s[%i] на Respawn",  
				pInfo[playerid][pName], playerid, pInfo[id][pName], id
			);
			SendAdminMessage(COLOR_GREY, t_string); t_string[0] = EOS;*/
	    }
	}
	return 1;
}
alias:spawn("pspawn", "sp");
CMD:offprison(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new kLibName[24],prison_time;
	if (sscanf(params,"s[24]d",kLibName,prison_time)) return scm(playerid, COLOR_WHITE, !"Введите: /offprison [name] [минуты], /offprison [name] 0 - вытащить из тюрьмы");
	if (pInfo[params[0]][pAdmin] > 0 && pInfo[playerid][pAdmin] < 6) 
	return SendClientMessage(playerid, COLOR_GREY, !"Администратор выше Вас уровнем!");
	new id, query_[120];
	sscanf(kLibName, "u", id);
	if (IsPlayerConnected(id)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /prison ))", pInfo[id][pName], id);
	else
	{
		mysql_format(dbHandle, query_, sizeof query_, "SELECT `pID`,`pMember`,`pRank` FROM `s_users` WHERE `Name` = '%e' LIMIT 1", kLibName);
		mysql_tquery(dbHandle, query_, "CheckoffjailPlayer", "dsd", playerid, kLibName,prison_time*60);
	}
	return 1;
}
publics: CheckoffjailPlayer(playerid, nickname[], min_jail)
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) return SendClientMessage(playerid, COLOR_GREY, !"Данного аккаунта нет в базе данных!");
	new 
		query_[128],
		fracid,
		rank,
		MySQLID;

	cache_get_value_name_int(0,"pID", MySQLID);
	cache_get_value_name_int(0,"pMember", fracid);
	cache_get_value_name_int(0,"pRank", rank);

	mysql_format(dbHandle,query_, sizeof query_, "UPDATE s_users SET pMestoJail = '4', pJailTime = '%d', MadTime = MadTime + %d WHERE Name = '%e' LIMIT 1", min_jail, min_jail, nickname);
	mysql_tquery(dbHandle, query_);

    format(query_, sizeof query_, "Администратор: %s посадил оффлайн %s[%s/%d]",
		pInfo[playerid][pName], nickname,
		gFraction[fracid][fName], rank); 
	
	SendClientMessageToAll(COLOR_LIGHTRED, query_);

	aAdminInfo[playerid][aPrison]++;

	MessagePlayerOffline(MySQLID, query_); 
	mysql_tquery (dbHandle, "SELECT `Name`,`MadTime` FROM `s_users` WHERE `MadTime` != 0 ORDER BY `MadTime` DESC LIMIT 5", "LoadTopMadHouse");
	return 1;
}

CMD:offwarn(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new 
        warnname[24], 
        reason[64],
		w_day;
	if (sscanf(params,"s[24]ds[24]", warnname, w_day, reason)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /offwarn [Ник Игрока] [day] [Причина]");
	if (!strcmp(warnname, pInfo[playerid][pName], true)) return SendClientMessage(playerid, COLOR_GREY, !"Вы ввели свой ник");
	if (w_day < 1 || w_day > 21) return SendClientMessage(playerid, COLOR_GREY, !"Разрешено warn только от 1 до 21 дней.");
	if (pInfo[params[0]][pAdmin] > 0 && pInfo[playerid][pAdmin] < 6) 
	return SendClientMessage(playerid, COLOR_GREY, !"Администратор выше Вас уровнем!");
	if (0 == CheckBanedNickName(playerid, warnname)) return 1;
	new 
        id, 
        query[128];
	sscanf(warnname, "u", id);
	if (IsPlayerConnected(id)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /warn ))", pInfo[id][pName], id);
	mysql_format(dbHandle,query, sizeof query, "SELECT `pID`, `pWarns`,`pMember`,`pRank` FROM `s_users` WHERE `Name` = '%e' LIMIT 1", warnname);
	mysql_tquery(dbHandle, query, "OffWarn", "dssd", playerid, warnname, reason, w_day);
	leave_team(params[0], pInfo[params[0]][pMember]);
	pInfo[params[0]][pMember] = 0;
	if (pInfo[params[0]][pLeader] != 0)
	{
	    SaveFractionString(pInfo[params[0]][pLeader], "fLeader", "None");
		strmid(fInfo[pInfo[params[0]][pLeader]][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
	}
	/*if (pInfo[playerid][pMember] != 0) {
		if (!strcmp(pInfo[playerid][pName], fInfo[pInfo[playerid][pMember]][fLeader], true)) {
			query_[0] = EOS;
			new fracion_id = pInfo[playerid][pMember];
			strmid(fInfo[fracion_id][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
			SaveFractionString(pInfo[fracion_id][pLeader], "fLeader", "None"); 
		}
	}*/
	pInfo[params[0]][pLeader] = 0; 
	pInfo[params[0]][pJob] = 0;
	pInfo[params[0]][pRank] = 0;
	return 1;
}
publics: OffWarn(playerid, nick[], reason[], t_day)
{
	new rows;
	cache_get_row_count(rows);
	if (rows)
	{
		new 
			warnc, 
			bdid, 
			string[400],
			fracid, leader_id,
			rank;
		cache_get_value_name_int(0, "pID", bdid);
		cache_get_value_name_int(0, "pWarns", warnc);
		cache_get_value_name_int(0, "pMember", fracid);
		cache_get_value_name_int(0, "pLeader", leader_id);
		cache_get_value_name_int(0, "pRank", rank);

		/* Moretti */
		if ( leader_id != 0 )
		{
			uninvite_player(playerid);
			SaveFractionString ( leader_id, "fLeader", "None" );
			strmid ( fInfo [ leader_id ] [ fLeader ], "None", 0, strlen ( "None" ), MAX_PLAYER_NAME );
			//
			strmid(fInfo[pInfo[leader_id][pLeader]][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
			pInfo[playerid][pLeader] = 0; 
			pInfo[playerid][pJob] = 0;
			pInfo[playerid][pRank] = 0;

		}
		/* Moretti */

		if (warnc == 2)
		{//UPDATE `s_users` SET `playerspawn` = '0'
			format(string, sizeof string, "Администратор: %s забанил оффлайн %s [3 предупреждения]. Причина: %s",pInfo[playerid][pName],nick,reason);
			ABroadCast(COLOR_LIGHTRED, string, 1); 
			MessagePlayerOffline(bdid, string); 
			format(string, sizeof string , "UPDATE `s_users` SET `pLeader` = '0', `pMember` = '0', \
				`pRank` = '0', `pJob` = '0', `playerspawn` = '0', `punWarns` = '0', `pWarns` = '0' WHERE `pID` = '%d'",bdid);
			mysql_tquery(dbHandle, string, "", ""); 
			aAdminInfo[playerid][aBan] ++;
			
			LogingAdmins(playerid, nick, "offWarn", warnc, reason);
			OnPlayerServerBanWarn(playerid, nick, reason); 
			HistoryPlayerBan(bdid, pInfo[playerid][pName], reason);
		}
		else
		{
			warnc ++;
			new unwarndate;
			unwarndate = gettime() + t_day * 86400;
			format(string, sizeof string, "Администратор: %s выдал оффлайн warn %s[%s/%d] (Дней: %d). Причина: %s",
				pInfo[playerid][pName], 
				nick, 
				gFraction[fracid][fName],
				rank, t_day, reason
			);
            ABroadCast(COLOR_LIGHTRED, string, 1);

			MessagePlayerOffline(bdid, string);
			if (leader_id != 0) {
				SaveFractionString(leader_id, "fLeader", "None");
				strmid(fInfo[ leader_id ][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
			}
            format(string, sizeof string , "UPDATE `s_users` SET `punWarns` = '%d', `pWarns` = '%d', `pLeader` = '0',\
				`pMember` = '0', `pRank` = '0', `pJob` = '0', `playerspawn` = '0' WHERE `pID` = '%d' LIMIT 1",
				unwarndate, warnc, bdid
			);
			mysql_tquery(dbHandle, string, "", ""); 
			aAdminInfo[playerid][aWarn] ++;
			
			HistoryPlayerWarn(bdid, pInfo[playerid][pName], reason);
			LogingAdmins(playerid, nick, "offWarn", warnc, reason);
		}
	}
	else SendMes(playerid, -1, "Аккаунт %s не найден в базе данных.", nick);
	return 1;
}

CMD:alock(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность"); 
	if (IsValidVehicle(GetPlayerVehicleID(playerid)))
	{ 
		new V_IDX = GetPlayerVehicleID(playerid);
		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		if (VehicleInfo[ V_IDX - 1 ][vLocked]) { 
			VehicleInfo[ V_IDX - 1 ][vLocked] = false;
			GetVehicleParamsEx ( V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
			SetVehicleParamsEx ( V_IDX, engine1, lights2, alarm2, false, bonnet2, boot1, objective1);
            MeAction(playerid, "открыл(а) транспорт", SELECT_ACTION_IN_BUBBLE);
		}
		else
		{
			VehicleInfo[ V_IDX - 1 ][vLocked] = true;
			GetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
			SetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, true, bonnet2, boot1, objective1);
            MeAction(playerid, "закрыл(а) транспорт", SELECT_ACTION_IN_BUBBLE);
		}
	}
	else
	{
		foreach(new V_IDX:StreamedVehicles[playerid])
		{
			if (IsVehicleInRangeOfPoint(V_IDX, 5.0, pTemp[playerid][tPos][0], pTemp[playerid][tPos][1], pTemp[playerid][tPos][2]) ){}
			else continue ;
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			if (VehicleInfo[ V_IDX - 1 ][vLocked])
			{
				VehicleInfo[ V_IDX - 1 ][vLocked] = false ;
				GetVehicleParamsEx (V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1 ) ;
				SetVehicleParamsEx (V_IDX, engine1, lights2, alarm2, false, bonnet2, boot1, objective1 ) ;
				GameTextForPlayer ( playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~g~UNLOCK", 3000, 3 ) ;
                MeAction(playerid, "открыл(а) транспорт", SELECT_ACTION_IN_BUBBLE);
				break ;
			}
			else
			{
				VehicleInfo[ V_IDX - 1 ][vLocked] = true ;
				GetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1 ) ;
				SetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, true, bonnet2, boot1, objective1 ) ;
				GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~r~LOCK", 3000, 3 ) ;
                MeAction(playerid, "закрыл(а) транспорт", SELECT_ACTION_IN_BUBBLE);
				break ;
			}
		}
	}
	return 1 ;
}
CMD:flipveh(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /flipveh [id]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен");
	if (!IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не в транспорте!");
	new 
		V_IDX = GetPlayerVehicleID(params[0]);
	new Float:fa, Float:x, Float:y, Float:z;
	_RepairVehicle(V_IDX);
	VehicleInfo[ V_IDX - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel]);
	GetVehicleRotationQuat(V_IDX, fa, x, y, z);
	GetVehicleZAngle(V_IDX, fa);
	SetVehicleZAngle(V_IDX, fa);
	return true;
}
CMD:slap(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /slap [id]");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен");
    if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	new 
        string_[128],
        Float:slx, Float:sly, Float:slz; 
	SetPlayerHealth(params[0], GetPlayerHP(params[0])-5);
	GetPlayerPos(params[0], slx, sly, slz);
	SetPlayerPosAC(params[0], slx, sly, slz+5);
	PlayerPlaySound(params[0], 1130, slx, sly, slz+5);
	format(string_, sizeof string_, "Админ: %s дал поджопник %s",pInfo[playerid][pName], pInfo[params[0]][pName]);
	ABroadCast(COLOR_LIGHTRED, string_, 1);
	SendClientMessage(params[0], COLOR_LIGHTRED, string_);
	return 1;
}

CMD:adeldesc(playerid, params[])
{
	new query_[156];
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "ds",params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /adeldesc [playerid] [причина]");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден");
	if(GetString(pInfo[playerid][pPame], "None")) SendClientMessage(playerid, COLOR_GREY, !"У игрока нету описания персонажа");

	format(pInfo[params[0]][pPame], MAX_PLAYER_NAME, "None");
	format(query_, sizeof(query_), "UPDATE `s_users` SET `pPame` = 'None' WHERE `Name` = '%s'", pInfo[params[0]][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	if(IsValidDynamic3DTextLabel(pame_text[params[0]]))
	{
		DestroyDynamic3DTextLabel(pame_text[params[0]]);
		pame_text[params[0]] = Text3D:INVALID_3DTEXT_ID;
	}
	SendMes(playerid, COLOR_GREY, "Вы удалили описание игроку %s, по причине %s", pInfo[params[0]][pName], params[1]);
	SendMes(params[0], COLOR_GREY, "Ваше описание персонажа было удалено администратором %s", pInfo[playerid][pName]);	
	return 1;
}

CMD:prison(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (strlen(params[2]) >= 24) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "uds[24]",params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /prison [playerid] [минуты] [причина], /prison [id] 0 - вытащить из тюрьмы");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    if (params[1] == 0)
    {
        pInfo[params[0]][pJailTime] = 0;
        pInfo[params[0]][pMestoJail] = 0; 
        PlayerSpawnEx(params[0]);
		SendMes(playerid, COLOR_LIGHTRED, "Вы выпустили с тюрьмы %s[%d]", pInfo[params[0]][pName], params[0]);
		SendMes(params[0], COLOR_LIGHTRED, "Вас выпустил с тюрьмы администратор %s", pInfo[playerid][pName] );
		new query[77 - 2 + 11];
		format(query, sizeof query, "UPDATE `s_users` SET `pJailTime` = '0', `pMestoJail` = '0' WHERE `pID` = '%d'", pInfo[params[0]][pJailTime], pInfo[params[0]][pMestoJail], pInfo[params[0]][pID]);
		mysql_tquery(dbHandle, query);
        return 1;
    }
    new
        string_[128];
	if (IsAIP(params[2]))return 1;
    format(string_, sizeof string_, "Админ %s посадил в форт ДеМорган %s на %d минут. Причина: %s",
		pInfo[playerid][pName], pInfo[params[0]][pName], params[1], params[2]
	);
	ABroadCast(COLOR_LIGHTRED, string_, 1);
	
	//static str_prison[] = "Администратор %s поместил в Деморган %s[%s/%d] на %d минут. Причина: %s";
	new str_tmp[144], query_[128];
	if (pInfo[params[0]][pMember] > 0) {
		format(str_tmp, sizeof str_tmp, "Администратор %s поместил в Деморган %s[%s/%d] на %d минут. Причина: %s", pInfo[playerid][pName],
			pInfo[params[0]][pName], gFraction[pInfo[params[0]][pMember]][fName], pInfo[params[0]][pRank],params[1], params[2]
		);
	} else {
		format(str_tmp, sizeof str_tmp, "Администратор %s поместил в Деморган %s на %d минут. Причина: %s", pInfo[playerid][pName],
			pInfo[params[0]][pName],params[1], params[2]
		);
	} 
	SendClientMessageToAll(COLOR_LIGHTRED, str_tmp);
	SendClientMessage(params[0], COLOR_LIGHTRED, !"Если вы не согласны с наказанием, оставьте жалобу на форуме(t.me/ForumHellRolePlay)");
	//SendMesAll(COLOR_LIGHTRED,"Админ %s посадил в форт ДеМорган %s на %d минут. Причина: %s",pInfo[playerid][pName], pInfo[params[0]][pName], params[1], params[2]);

	if (pTemp[playerid][tDMArea][0])
	{
		if (pTemp[playerid][tDMLabel]) {
  			DestroyDynamic3DTextLabel(pTemp[playerid][tDMLabel]);
			pTemp[playerid][tDMLabel] = Text3D:0;
		} 
		PlayerTextDrawHide(playerid, DmArenaTextDraw[playerid]);

		pTemp[playerid][tDMArea][0] = pTemp[playerid][tDMArea][1] = pTemp[playerid][tDMArea][2] = pTemp[playerid][tDMArea][3] = pTemp[playerid][tDMArea][4] = 0; 

		SetPlayerColor(playerid, gFractionColor[pInfo[playerid][pMember]]);
		SetPlayerSkinEx(playerid, pInfo[playerid][pModel]);
		ResetPlayerWeapons(playerid);
	}

	SendMes(params[0], COLOR_LIGHTRED, "Вы помещены в форт ДеМорган администратором %s на %d минут. Причина: %s", pInfo[playerid][pName], params[1], params[2]);
	ResetPlayerWeapons(params[0]); 
	//
	if (gFollowInfo[params[0]][gtGoID] != INVALID_PLAYER_ID) {
		new
			follow_id = gFollowInfo[params[0]][gtGoID];
		if (pTemp[params[0]][tPlayerCuffed] && gFollowInfo[follow_id][gtID] == params[0]) {
			TogglePlayerControllable(params[0], 1);
			CheckPlayerGoCuff(params[0]);
			CheckPlayerGoCuff(follow_id);
			//return 1;
		}
	}
	
	SetPlayerPosAC(params[0], 2.4973,803.3113,1033.0717, 10, MAD_HOUSE_INT);
	SetPlayerFacingAngle(params[0], 271.8828); 
	pInfo[params[0]][pJailTime] = params[1]*60;
	pInfo[params[0]][pMestoJail] = 4; 
	aAdminInfo[playerid][aPrison] ++;
 
	format(query_,sizeof query_,
		"UPDATE s_users SET MadTime = MadTime + %d, pMestoJail = '%d' WHERE pID = '%d' LIMIT 1", pInfo[params[0]][pJailTime],
		pInfo[params[0]][pMestoJail], pInfo[params[0]][pID]
	);
	mysql_tquery(dbHandle, query_, "", ""), query_[0] = EOS; 
	

	if (IsAGang(params[0]) || IsAMafia(params[0])) {
		CheckWarCapture(params[0], REASON_PRISON);
	}
	mysql_tquery (dbHandle, "SELECT `Name`,`MadTime` FROM `s_users` WHERE `MadTime` != 0 ORDER BY `MadTime` DESC LIMIT 5", "LoadTopMadHouse");
    LogingAdmins(playerid, pInfo[params[0]][pName], "/prison", pInfo[params[0]][pJailTime], params[2]);
	return 1;
}
		
CMD:setskin(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return true;
    if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setskin [playerid][id скина]");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен");
	if (params[1] > 311 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Неправильный ID скина!");
	if (pTemp[params[0]][tSelectSkinShop] != -1) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок в МО");
	SetPlayerSkinEx(pInfo[playerid][pAdmin] < 4 ? playerid : params[0], params[1]);
	if (pInfo[playerid][pAdmin] < 4)  SendClientMessage(playerid, -1, !"[A] Вы выдали себе временный скин");
	else{
	    SendMes(params[0], -1, "- Администратор %s выдал Вам временный скин", pInfo[playerid][pName]);
		return SendMes(playerid, -1, "[A] Вы выдали временный скин игроку %s", pInfo[params[0]][pName]);
	}
	return true;
}

CMD:goto(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /g(oto) [playerid]");
	new Float:plocx,Float:plocy,Float:plocz;
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен / Вы указали свой ID");
	if (GetPlayerState(params[0]) != 1 && GetPlayerState(params[0]) != 2 && GetPlayerState(params[0]) != 3) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен");
	if (GetPlayerState(params[0]) == PLAYER_STATE_SPECTATING && gSpectateID[params[0]] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Администратор в режиме наблюдения");
	GetPlayerPos(params[0], plocx, plocy, plocz);
	if (pTemp[params[0]][tSelectHouseID] != -1) {
		pTemp[playerid][tSelectHouseID] = pTemp[params[0]][tSelectHouseID];
	}
	if (GetPlayerState(playerid) == 2)
	{
		new 
            V_IDX = GetPlayerVehicleID(playerid);
		SetVehiclePos(V_IDX, plocx, plocy+4, plocz);
	}
	else SetPlayerPosAC(playerid, plocx,plocy+2, plocz, GetPlayerVirtualWorld(params[0]), GetPlayerInterior(params[0]));
	SendClientMessage(playerid, COLOR_GREY, !"Вы были телепортированы");
	return 1;
}
alias:goto("g");


/*
CMD:iwep(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /iwep [playerid]");
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен");
    new 
        str_[64],
        Gun[13], 
        Ammo[13];
    t_string[0] = EOS;
    format(str_, sizeof str_, ""collime"Player Name: %s(%d)\n\n", pInfo[params[0]][pName], params[0]);
    strcat(t_string, str_);
    for(new idx = 0; idx <= 12; idx++) {
        GetPlayerWeaponData(params[0], idx, Gun[idx], Ammo[idx]);
        format(str_, sizeof str_,"Slot: [%d]\tИд оружия: %d\tПатрон: %d\n", idx, Gun[idx], Ammo[idx]);
        strcat(t_string, str_); 
    } 
    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Информация: Оружия", t_string, "Закрыть", "");
    return 1;
}*/

CMD:iwep(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new targetid;
    if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /iwep [playerid]");
    if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен");
    new 
        str_[64],
		gunname[32];
    t_string[0] = EOS;
	strcat(t_string, !"[Slot] Gun Name\tGun ID\tКол-во патрон\n");
    format(str_, sizeof str_, ""collime"Player Name: %s(%d)\n", pInfo[targetid][pName], targetid);
    strcat(t_string, str_);
    for(new idx = 0; idx <= 12; idx++) {
		GetWeaponName(player_weapon_id[targetid][idx], gunname, sizeof (gunname));
        format(str_, sizeof str_,"[%d] %s\t%d\t%d\n", idx, gunname, player_weapon_id[targetid][idx],player_weapon_ammo[targetid][idx]);
        strcat(t_string, str_); 
    } 
    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Информация: "colwhi"Оружия", t_string, "Закрыть", "");
    return 1;
} 
CMD:ban(playerid, params[])
{
    if !GetAdminLogged(playerid, 4) *then return 1;

    new 
        to_player,
        value_day,
        str_reason[128];

	if sscanf(params, "k<player_name>ds[70]", to_player, value_day, str_reason) *then return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ban [id/ник] [дни] [причина]");
	if IsAIP(str_reason) *then return 1;
	if(!Reklama(playerid, str_reason)) return 1;
    if strlen(str_reason) > 60 *then return SendClientMessage(playerid, COLOR_GREY, !"Запрещено использовать более 60-ти символов в причине");
	if !IsPlayerConnected(to_player) || to_player == INVALID_PLAYER_ID *then return SendClientMessage(playerid, COLOR_GREY, P_OFFLINE);
	if (pInfo[params[0]][pAdmin] > 0 && pInfo[playerid][pAdmin] < 6) 
	return SendClientMessage(playerid, COLOR_GREY, !"Администратор выше Вас уровнем!");
    if !(1 <= value_day <= 2000) *then return SendClientMessage(playerid, COLOR_GREY, !"Разрешено банить только от 1 до 2000 дней.");
	if pInfo[playerid][pAdmin] < pInfo[to_player][pAdmin] *then return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
    if 0 == CheckBanedNickName(playerid, pInfo[to_player][pName]) *then return 1;

	new 
		ip[16];

    format(totalstring, 144, "Администратор %s Забанен. Обратитесь к спец-админу", pInfo[playerid][pName]);

    if pInfo[to_player][pAdmin] && pInfo[playerid][pAdmin] < 7 *then ABroadCast(COLOR_LIGHTRED, totalstring, 1);
   
    totalstring[0] = EOS;
	
    if IsAGang(to_player) || IsAMafia(to_player) *then CheckWarCapture(to_player, REASON_BAN);
	
	if pInfo[to_player][pMember] *then 
    {
        SendMesAll(COLOR_LIGHTRED,"Администратор: %s забанил игрока %s[%s/%d] на %d дней. Причина: %s", pInfo[playerid][pName], pInfo[to_player][pName],gFraction[pInfo[to_player][pMember]][fName],pInfo[to_player][pRank], value_day, str_reason);
    }
	else 
    {
        SendMesAll(COLOR_LIGHTRED,"Администратор: %s забанил игрока %s на %d дней. Причина: %s", pInfo[playerid][pName], pInfo[to_player][pName], value_day, str_reason);
    }
	
    GetPlayerIp(to_player, ip, sizeof ip); 

	format(
        totalstring, 
        144, 
        "   Nik [%s]  R-IP [%s]  L-IP [%s]  IP [%s]",
        pInfo[to_player][pName],
        pInfo[to_player][RegIP],
        pInfo[to_player][LastIP],
        ip
    );

	ABroadCast(COLOR_LIGHTRED, totalstring, 3);
    totalstring[0] = EOS;

	SendClientMessage(to_player, COLOR_LIGHTRED, "Если вы не согласны с наказанием, оставьте жалобу на форуме(t.me/ForumHellRolePlay)");
	
    aAdminInfo[playerid][aBan] ++;

	leave_team(to_player, pInfo[to_player][pMember]);
	pInfo[to_player][pMember] = 0;
	if (pInfo[to_player][pLeader] != 0)
	{
	    SaveFractionString(pInfo[to_player][pLeader], "fLeader", "None");
		strmid(fInfo[pInfo[to_player][pLeader]][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
	}

	pInfo[to_player][pLeader] = 0; 
	pInfo[to_player][pJob] = 0;
	pInfo[to_player][pRank] = 0;

	if pInfo[to_player][PlayerSpawn] == 2 *then
	{
	    pInfo[to_player][PlayerSpawn] = (pInfo[to_player][pHouseID] == -1) ? 0 : 1;
	    
        SavePlayerInteger(to_player, "playerspawn", pInfo[to_player][PlayerSpawn]);
	}

    HistoryPlayerBan(pInfo[to_player][pID], pInfo[playerid][pName], str_reason);

	LogingAdmins(playerid, pInfo[to_player][pName], "/ban", value_day, str_reason);

    OnPlayerServerBan(playerid, to_player, str_reason, value_day);
	return 1;
}

CMD:warn(playerid, params[])
{
    //if (Spectate[playerid]) StopSpectate(playerid);
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "uds[128]",params[0],params[1], params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /warn [id/ник] [day] [причина]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен / Вы указали свой ID");
	if(!Reklama(playerid, params[2]))
	if (IsAIP(params[2])) return 1; 
	if (params[1] < 1 || params[1] > 21) return SendClientMessage(playerid, COLOR_GREY, !"Разрешено warn только от 1 до 21 дней.");
	if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	if 0 == CheckBanedNickName(playerid, pInfo[params[0]][pName]) *then return 1;
	new query_[256], string_[128];
	//new query[256];
	//new status_,
	pInfo[params[0]][pWarns] += 1;
	if (pInfo[params[0]][pMember] > 0) {
		SendMesAll(COLOR_LIGHTRED,"Администратор: %s выдал warn игроку %s[%s/%d] Причина: %s", pInfo[playerid][pName], pInfo[params[0]][pName],gFraction[pInfo[params[0]][pMember]][fName],pInfo[params[0]][pRank], params[2]);
	} else {
		SendMesAll(COLOR_LIGHTRED,"Администратор: %s выдал warn игроку %s Причина: %s", pInfo[playerid][pName], pInfo[params[0]][pName], params[2]);
	}
	if (IsAGang(params[0]) || IsAMafia(params[0])) {
		CheckWarCapture(params[0], REASON_WARN);
	}


	leave_team(params[0], pInfo[params[0]][pMember]);
	pInfo[params[0]][pMember] = 0;
	if (pInfo[params[0]][pLeader] != 0)
	{
	    SaveFractionString(pInfo[params[0]][pLeader], "fLeader", "None");
		strmid(fInfo[pInfo[params[0]][pLeader]][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
	}
	/*if (pInfo[playerid][pMember] != 0) {
		if (!strcmp(pInfo[playerid][pName], fInfo[pInfo[playerid][pMember]][fLeader], true)) {
			query_[0] = EOS;
			new fracion_id = pInfo[playerid][pMember];
			strmid(fInfo[fracion_id][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
			SaveFractionString(pInfo[fracion_id][pLeader], "fLeader", "None"); 
		}
	}*/
	pInfo[params[0]][pLeader] = 0; 
	pInfo[params[0]][pJob] = 0;
	pInfo[params[0]][pRank] = 0;
	SendClientMessage(params[0], COLOR_LIGHTRED, !"Если вы не согласны с наказанием, оставьте жалобу на форуме(t.me/ForumHellRolePlay)");
	if (pInfo[params[0]][PlayerSpawn] == 2)
	{
	    if (pInfo[playerid][pHouseID] == -1) pInfo[params[0]][PlayerSpawn] = 0;
		else pInfo[params[0]][PlayerSpawn] = 1;
	    SavePlayerInteger(params[0], "playerspawn", pInfo[params[0]][PlayerSpawn]);
	}

	if (pInfo[params[0]][pWarns] >= 3)
	{
		new 
			ip[16];
		SendMesAll(COLOR_LIGHTRED, "Администратор: %s забанил %s [3 предупреждения]. Причина: %s",pInfo[playerid][pName],pInfo[params[0]][pName],params[2]);
		GetPlayerIp(params[0], ip, sizeof ip);
		format(string_, sizeof string_, "   Nik [%s]  R-IP [%s]  L-IP [%s]  IP [%s]",pInfo[params[0]][pName],pInfo[params[0]][RegIP],pInfo[params[0]][LastIP],ip);
		ABroadCast(COLOR_LIGHTRED, string_, 3);
		if (IsAGang(params[0]) || IsAMafia(params[0])) {
			CheckWarCapture(params[0], REASON_BAN);
		}
		OnPlayerServerBan(playerid, params[0], params[2], 14);
		aAdminInfo[playerid][aBan] ++;
		
		HistoryPlayerBan(pInfo[params[0]][pID], pInfo[playerid][pName], params[2]);

	}
	else 
	{
		new unwarndate;
		unwarndate = gettime() + params[1] * 86400;
		pInfo[params[0]][punWarns] = unwarndate;
		HistoryPlayerWarn(pInfo[params[0]][pID], pInfo[playerid][pName], params[2]);
	}

	format(query_, sizeof query_ , "UPDATE `s_users` SET `pLeader` = '0', `pMember` = '0', `pRank` = '0', `pJob` = '%d', `punWarns` = '%d', `pWarns` = '%d' WHERE `pID` = '%d'",
	pInfo[params[0]][pLeader], pInfo[params[0]][pMember], pInfo[params[0]][pRank],
	pInfo[params[0]][pJob], pInfo[params[0]][punWarns],pInfo[params[0]][pWarns], pInfo[params[0]][pID]);
	mysql_tquery(dbHandle, query_, "", "");

    aAdminInfo[playerid][aWarn] ++;
	
	LogingAdmins(playerid, pInfo[params[0]][pName], "Warn", pInfo[params[0]][pWarns], params[2]);
	Kick(params[0]);
	return 1;
}
CMD:givevip(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "udd", params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_GRAD1, !"Введите: /givevip [id] [lvl] [day]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (params[1] < 1 || params[1] > 5) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя меньше 1 или больше 5");
	if (params[2] < 1 || params[2] > 365) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя меньше 1 или больше 365");
	new 
		vip_[32]; 
	switch(params[1])
	{
		case VIP_PACK_BRONZE: vip_ = "{D2691E}[BRONZE]";
		case VIP_PACK_SILVER: vip_ = "{C0C0C0}[SILVER]";
		case VIP_PACK_GOLD: vip_ = "{FFD700}[GOLD]";
		case VIP_PACK_PLATINUM: vip_ = "{FF00FF}[PLATINUM]";
		case VIP_PACK_DIAMOND: vip_ = "{4285b4}[DIAMOND]";
		default: vip_ = ""colwarn"[ERROR]";
	}  
	pInfo[params[0]][VIPRank] = params[1];
	SavePlayerInteger(params[0], "vip_rank", pInfo[params[0]][VIPRank]);
	new unboost = gettime() + (params[2] * 86400);
	pInfo[params[0]][VIPTime] = unboost;
	SavePlayerInteger(params[0], "vip_time", pInfo[params[0]][VIPTime]);
	SendMes(playerid, COLOR_WHITE, "Вы выдали VIP %s, на %d дней", vip_, params[2]);
	SendMes(params[0], COLOR_WHITE, "Администратор: %s, выдал Вам VIP: %s, сроком на %d", pInfo[playerid][pName], vip_, params[2]);
	return 1;
}
CMD:giveboost(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "udd", params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_GRAD1, !"Введите: /giveboost [id] [lvl] [day]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (params[1] < 1 || params[1] > 5) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя меньше 1 или больше 5");
	if (params[2] < 1 || params[2] > 365) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя меньше 1 или больше 365");
	new 
		boost_[32];
	switch(params[1])
	{
		case 0: boost_ = "[ERROR]";
		case 1: boost_ = "[Стартовый]";
		case 2: boost_ = "[Профессиональный]";
		case 3: boost_ = "[Авторитет]";
		case 4: boost_ = "[Босс]";
		case 5: boost_ = "[Гетто тащер]";
	}
	pInfo[params[0]][BoostRank] = params[1];
	SavePlayerInteger(params[0], "boost_rank", pInfo[params[0]][BoostRank]);
	new unboost = gettime() + (params[2] * 86400);
	pInfo[params[0]][BoostTime] = unboost;
	SavePlayerInteger(params[0], "boost_time", pInfo[params[0]][BoostTime]);
	SendMes(playerid, COLOR_WHITE, "Вы выдали Старт Пакет %s, на %d дней", boost_, params[2]);
	SendMes(params[0], COLOR_WHITE, "Администратор: %s, выдал Вам Старт Пакет: %s, сроком на %d", pInfo[playerid][pName], boost_, params[2]);
	return 1;
}

CMD:amembers(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new fraction;
 	if (sscanf(params, "d", fraction)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /amembers [1-26]");
  	if (fraction < 0 || fraction > TOTAL_FRACTION) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /amembers [id фракции]");
	ShowPlayerMemberFraction(playerid, fraction);
    return 1;
}

CMD:gm(playerid,params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gm [id]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден! / Вы указали свой ID");
	if (GetPlayerState(params[0]) == 2) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не должен находиться в транспорте");
	new Float: 
        velocity[3];
	GetPlayerVelocity(params[0], velocity[0], velocity[1], velocity[2]);
	if (velocity[2] != 0.0) return SendClientMessage(playerid, COLOR_GREY, !"Этот игрок прыгает или падает");
	new 
        Float:posx,
        Float:posy, 
        Float:posz, 
        Float: armour, 
        string_[80];
	GetPlayerArmour(params[0], armour);
	SetPlayerArmour(params[0], 0);
	GetPlayerHealth(params[0], Health__GodMode);
	GetPlayerPos(params[0], posx, posy, posz);
	CreateExplosionForPlayer(params[0],posx, posy, posz - 2.8, 12, 0.5);
	SetTimerEx("GodModeTest", 200, false, "ddff", params[0], playerid, Health__GodMode, armour);
	format(string_, sizeof string_, "[A] %s[%d] произвел ГМ-проверку %s[%d]", pInfo[playerid][pName], playerid, pInfo[params[0]][pName], params[0]);
	return ABroadCast(COLOR_YELLOW, string_, 2);
}
publics: GodModeTest(playerid, showid, Float: starthealth, Float: startarmour)
{
	new 
        Float: currenthealth, 
        Float: diff;
    t_string[0] = EOS;
	GetPlayerHealth(playerid, currenthealth);
	diff = starthealth - currenthealth;
	format(t_string, sizeof t_string, "{00FFFF}Пинг: %d\n\
		{B4B5B7}HP до взрыва: {FF6600}%.0f%%\n\
		{B4B5B7}HP после взрыва: {FF6600}%.0f%%\n\n\
		{B4B5B7}Переменная Health: {FF6600}%.0f%%\n\n\
		{B4B5B7}Разница: {FF6600}%.0f%%\n", GetPlayerPing(playerid), starthealth, currenthealth, GetPlayerMaxHealth(playerid), diff);
	if (diff > 0.0) strcat(t_string, "{00CC00}GodMode не используется");
	else strcat(t_string, "{FF0000}GodMode возможно используется");
	ShowPlayerDialog(showid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Тест на GM", t_string, "Закрыть", "");
	Health__GodMode = starthealth;
	SetPlayerArmour(playerid, startarmour);
	SetPlayerHealth(playerid, starthealth);
}

CMD:spcar(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в машине!");
	SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	return 1;
}
/* 3 LEVEL */
CMD:agivelicense(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	ShowPlayerDialog(playerid, D_ADMIN_FUNC_16, DIALOG_STYLE_LIST, "Выдача лицензий:", "\
	[0] Лицензия на вождение\n\
	[1] Лицензия на полёты\n\
	[2] Лицензия на вождение водного транспорта\n\
	[3] Лицензия на рыболовлю\n\
	[4] Лицензия на оружие\n\ 
	[5] Комплект лицензий", "Продолжить", "Отмена");
	return 1;
}
CMD:gi(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность"); 
    if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gi [iterior]");
	SetPlayerInterior(playerid, params[0]);
	pTemp[playerid][tInterior] = params[0];
	SendMes(playerid, COLOR_WHITE, "Вы изменили себе интерьер на %d", params[0]);
	return 1;
}
CMD:gv(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность"); 
    if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gv [world]");
	SetPlayerVirtualWorld(playerid, params[0]);
	pTemp[playerid][tVirtualWorld] = params[0];
	SendMes(playerid, COLOR_WHITE, "Вы изменили себе виртуальный мир на %d", params[0]);
	return 1;
} 
CMD:amegaphone(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new string_[150];
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
    if (sscanf(params, "s[128]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: (/am)egaphone [текст]");
	format(string_, sizeof(string_), "{{ %s: %s }}",pInfo[playerid][pName],params[0]);
	SendBeside(playerid,COLOR_YELLOW,string_,80.0);
	return 1;
} 
CMD:rename(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /rename [id]");
	if (!PlayerInConnected(params[0])/* || playerid == params[0]*/) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден! / Вы указали свой ID"); 
	if (GetString(WantNickChange[params[0]], "None")) return SendClientMessage(playerid, -1, !"Этот игрок не хочет менять ник"); 
	new 
		query_[128];
	format(query_, sizeof query_,"SELECT `Name` FROM `s_users` WHERE `Name` = '%s' LIMIT 1", WantNickChange[params[0]]);
	new Cache:result = mysql_query(dbHandle, query_), rows;
	cache_get_row_count(rows);
	if (rows) {
		SendClientMessage(playerid, COLOR_RED, !"Данный ник уже есть в базе данных");
		SendClientMessage(params[0], COLOR_RED, !"Невозможно сменить ник. Ник занят");
		WantNickChange[params[0]] = "None";
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	} 
	SendClientMessage(params[0], COLOR_GREEN, !"Ваш ник был одобрен"); 
	format(query_, sizeof query_, "[A] %s[%d] изменил никнейм игроку: %s[%d]",  pInfo[playerid][pName], playerid, pInfo[params[0]][pName], params[0]);
	SendAdminMessage(COLOR_GREY, query_);
	ChangeName(params[0], WantNickChange[params[0]]);
	if (cache_is_valid(result)) cache_delete(result); 
	return 1 ;
} 

stock ChangeName(playerid, str[])
{
	new query_[256];
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_users` SET `Name`= '%s' WHERE `Name` = '%s'", str, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_admin` SET `Name`= '%s' WHERE `Name` = '%s'",str, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE "TABLE_SUPPORTS" SET `sName`='%s' WHERE `sName` = '%s'", str, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE "TABLE_MEDCARDS" SET owner ='%s' WHERE owner = '%s'", str, pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query_, "", "");
	for(new i = 1; i <= TOTALCASINO; i++)
	{
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caManager],true) == 0) strmid(CasinoInfo[i][caManager], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caManager2],true) == 0) strmid(CasinoInfo[i][caManager2], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caManager3],true) == 0) strmid(CasinoInfo[i][caManager3], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie],true) == 0) strmid(CasinoInfo[i][caKrupie], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie2],true) == 0) strmid(CasinoInfo[i][caKrupie2], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie3],true) == 0) strmid(CasinoInfo[i][caKrupie3], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie4],true) == 0) strmid(CasinoInfo[i][caKrupie4], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie5],true) == 0) strmid(CasinoInfo[i][caKrupie5], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie6],true) == 0) strmid(CasinoInfo[i][caKrupie6], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie7],true) == 0) strmid(CasinoInfo[i][caKrupie7], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie8],true) == 0) strmid(CasinoInfo[i][caKrupie8], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie9],true) == 0) strmid(CasinoInfo[i][caKrupie9], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],CasinoInfo[i][caKrupie10],true) == 0) strmid(CasinoInfo[i][caKrupie10], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		SaveCasinoIDManager(i);
		SaveCasinoIDDealer(i);
    }
	for(new i = 1; i <= TOTALFARM; i++)
    {
        if (strcmp(pInfo[playerid][pName],FarmInfo[i][fDeputy_1],true) == 0) strmid(FarmInfo[i][fDeputy_1], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fDeputy_2],true) == 0) strmid(FarmInfo[i][fDeputy_2], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fDeputy_3],true) == 0) strmid(FarmInfo[i][fDeputy_3], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_1],true) == 0) strmid(FarmInfo[i][fFarmer_1], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_2],true) == 0) strmid(FarmInfo[i][fFarmer_2], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_3],true) == 0) strmid(FarmInfo[i][fFarmer_3], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_4],true) == 0) strmid(FarmInfo[i][fFarmer_4], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		if (strcmp(pInfo[playerid][pName],FarmInfo[i][fFarmer_5],true) == 0) strmid(FarmInfo[i][fFarmer_5], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		SaveFermIDFarmers(i);
	}
	if (pInfo[playerid][pHouseID] != -1) {
		new	
			H_IDX = pInfo[playerid][pHouseID];
		strmid(HouseInfo[H_IDX][hOwner], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
	} 

	if (pTemp[playerid][PlayerFarmID] != -1) {
		new farm_id = pTemp[playerid][PlayerFarmID];
		strmid(FarmInfo[farm_id][fOwner], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		SaveFermID(farm_id);
	}
	if (pInfo[playerid][pLeader] != 0) {
		query_[0] = EOS;
		new fracion_id = pInfo[playerid][pLeader];
		strmid(fInfo[fracion_id][fLeader], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
		mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_fraction` SET `fLeader`= '%s' WHERE `fID` = '%d'", WantNickChange[playerid], fracion_id);
		mysql_tquery(dbHandle, query_, "", "");
	} 

	

	if (pInfo[playerid][pMember] != 0) {
		if (!strcmp(pInfo[playerid][pName], fInfo[pInfo[playerid][pMember]][fAssistant], true)) {
			query_[0] = EOS;
			new fracion_id = pInfo[playerid][pMember];
			strmid(fInfo[fracion_id][fAssistant], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
			mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_fraction` SET `fAssistant`= '%s' WHERE `fID` = '%d'", WantNickChange[playerid], fracion_id);
			mysql_tquery(dbHandle, query_, "", "");
		}
	} 
	if (pInfo[playerid][pFamily] != 0) {
		if (!strcmp(pInfo[playerid][pName], FamilyInfo[pInfo[playerid][pFamily] - 1][fOwner], true)) {
			query_[0] = EOS;
			new family_id = pInfo[playerid][pFamily];
			strmid(FamilyInfo[family_id - 1][fOwner], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
			mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_family` SET `fOwner`= '%s' WHERE `fID` = '%d'", WantNickChange[playerid], family_id);
			mysql_tquery(dbHandle, query_, "", ""); 
		}
	}
	for (new i = 0; i < sizeof (BusinessInfo); i++) { 
		if (!IsValidBusiness(i)) continue;
		if (!strcmp(pInfo[playerid][pName], BusinessInfo[i][bOwner], true)) {
			strmid(BusinessInfo[i][bOwner], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
			format(t_string, sizeof (t_string), "bOwner = '%s'", BusinessInfo[i][bOwner]);
			SaveBusiness(i, t_string);  
			UpdateBusiness(i);
		}
	} 
	for(new i = 1; i <= TOTALFARM; i++) {
		if (!strcmp(pInfo[playerid][pName], FarmInfo[i][fAuctionName], true)) {
			strmid(FarmInfo[i][fAuctionName], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME);
			SaveActionsFerm(i);
		}
	}
	SetPlayerHistoryName(pInfo[playerid][pID], WantNickChange[playerid], pInfo[playerid][pName]);
	SendMesAll(COLOR_LIGHTRED, "%s сменил имя на %s", pInfo[playerid][pName], WantNickChange[playerid]);
	strmid(pInfo[playerid][pName], WantNickChange[playerid], 0, strlen(WantNickChange[playerid]), MAX_PLAYER_NAME); 
	SetPlayerName(playerid, str); 
	WantNickChange[playerid] = "None";
	//Kick(playerid);
	return 1;
}
CMD:awarehouse(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");

	/*
	FractionInfo[1][fMaterials] - LSPD
	FractionInfo[2][fMaterials] - FBI
	FractionInfo[3][fMaterials] - Army SFA
	FractionInfo[4][fMaterials] - МЧС
	FractionInfo[5][fMaterials] - ЛКН
	FractionInfo[6][fMaterials] - Yakuza
	FractionInfo[7][fMoney] 	- Мэрия (В столбце Матов храним сумму налогов)
	FractionInfo[8][fMaterials] - Пусто 0,0,0
	FractionInfo[9][fMoney] 	- SF News
	FractionInfo[10][fMaterials] - SFPD
	FractionInfo[11][fMaterials] - Автошкола
	FractionInfo[12][fMaterials] - Баллас
	FractionInfo[13][fMaterials] - Вагос
	FractionInfo[14][fMaterials] - Russian Mafia
	FractionInfo[15][fMaterials] - Grove Street
	FractionInfo[16][fMoney] 	 - LS News
	FractionInfo[17][fMaterials] - Aztec
	FractionInfo[18][fMaterials] - Rifa
	FractionInfo[19][fMaterials] - Army LVA
	FractionInfo[20][fMoney] 	 - LV News
	FractionInfo[21][fMaterials] - LVPD
	FractionInfo[22][fMaterials] - МЧС
	FractionInfo[23][fMaterials] - МЧС
	FractionInfo[24][fMaterials] - Hell's Angel's
	FractionInfo[25][fMaterials] - Warlock MC
	FractionInfo[26][fMaterials] - Outlaws MC MC*/

	goto skip_initialization_array;
	static const str_wareh[] = 
	"Организация\tМатериалы\n\
	Гос. организации:\n\
	{%s}LSPD\t%d\n\
	{%s}SFPD\t%d\n\
	{%s}LVPD\t%d\n\
	{%s}Army SF\t%d\n\
	{%s}Army LV\t%d\n\
	{FFFFFF}LSA\t%d\n\
	{%s}FBI\t%d\n\
	Банды:\n\
	{%s}Ballas\t%d\n\
	{%s}Vagos\t%d\n\
	{%s}Grove\t%d\n\
	{%s}Aztec\t%d\n\
	{%s}Rifa\t%d\n\
	Мафии:\n\
	{%s}LCN\t%d\n\
	{%s}Yakuza\t%d\n\
	{%s}RM\t%d\n\
	Байкеры:\n\
	{%s}Mongols\t%d\n\
	{%s}Warlock MC\t%d\n\
	{%s}Outlaws MC\t%d";

	new str_tmp[sizeof(str_wareh) + 18*10 + 17*8];

	skip_initialization_array:

	format(str_tmp,sizeof(str_tmp),str_wareh,
	gFraction[1][fRGBColor],FractionInfo[1][fMaterials],
	gFraction[10][fRGBColor],FractionInfo[10][fMaterials],
	gFraction[21][fRGBColor],FractionInfo[21][fMaterials],
	gFraction[3][fRGBColor],FractionInfo[3][fMaterials],
	gFraction[19][fRGBColor],FractionInfo[19][fMaterials],
	lsamatbi,
	gFraction[2][fRGBColor],FractionInfo[2][fMaterials],
	gFraction[12][fRGBColor],FractionInfo[12][fMaterials],
	gFraction[13][fRGBColor],FractionInfo[13][fMaterials],
	gFraction[15][fRGBColor],FractionInfo[15][fMaterials],
	gFraction[17][fRGBColor],FractionInfo[17][fMaterials],
	gFraction[18][fRGBColor],FractionInfo[18][fMaterials],
	gFraction[5][fRGBColor],FractionInfo[5][fMaterials],
	gFraction[6][fRGBColor],FractionInfo[6][fMaterials],
	gFraction[14][fRGBColor],FractionInfo[14][fMaterials],
	gFraction[24][fRGBColor],FractionInfo[24][fMaterials],
	gFraction[25][fRGBColor],FractionInfo[25][fMaterials],
	gFraction[26][fRGBColor],FractionInfo[26][fMaterials]);

	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, !"СКЛАДЫ:", str_tmp, !"Закрыть", "");
	return 1;
}

CMD:warnlog(playerid,params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new kLibName[24],
		uninviteid,
		query[128];
    if (sscanf(params, "s[24]", kLibName)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /warnlog [имя игрока]");
	sscanf(kLibName, "u", uninviteid);
	if (IsPlayerConnected(uninviteid) && pInfo[uninviteid][pLogin]) {
	    mysql_format(dbHandle, query,sizeof query, "SELECT * FROM `sh_warn` WHERE `pID` = '%d'", pInfo[uninviteid][pID]);
		mysql_tquery(dbHandle, query, "LoadHistoryNameList", "dsd", playerid, kLibName, 1);
		return 1;
	}
	else {
	    mysql_format(dbHandle, query,sizeof query, "SELECT * FROM `s_users` WHERE `Name` = '%e'",kLibName);
		mysql_tquery(dbHandle, query, "GetIDAccountNameStore", "dsd", playerid, kLibName, 1);
	}
	return 1;
}
CMD:banlog(playerid,params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new kLibName[32], uninviteid, query[128];
    if (sscanf(params, "s[32]", kLibName)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /banlog [имя игрока]");
	sscanf(kLibName, "u", uninviteid);
	if (IsPlayerConnected(uninviteid) && pInfo[uninviteid][pLogin]) {
	    mysql_format(dbHandle, query,sizeof query, "SELECT * FROM `sh_ban` WHERE `pID` = '%d'", pInfo[uninviteid][pID]);
		mysql_tquery(dbHandle, query, "LoadHistoryNameList", "dsd", playerid, kLibName, 0);
		return 1;
	}
	else {
	    mysql_format(dbHandle, query,sizeof query, "SELECT * FROM `s_users` WHERE `Name` = '%e'", kLibName);
		mysql_tquery(dbHandle, query, "GetIDAccountNameStore", "dsd", playerid, kLibName, 0);
	}
	return 1;
}
CMD:fakeban(playerid, params[]){
 	if (pInfo[playerid][pAdmin] < 10) return 1;
	if (sscanf(params, "us[32]", params[0], params[1]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Введите: /fakeban [playerid] [reason]");

	if 0 == CheckBanedNickName(playerid, pInfo[params[0]][pName]) *then return 1;

	if (!IsPlayerConnected(params[0])) return 1;
	if (pInfo[params[0]][pAdmin] != 0) {
	    pInfo[params[0]][pAdmin] = 0;
	    pTemp[params[0]][PlayerADostup] = false;
		Iter_Remove(AdminsTeam, params[0]);
	}
	foreach(new i: PlayerInLogin){
	    if (i == playerid)
			continue;
	    new
			r_ip[4],
			str_ip[32];
        r_ip[0] = random(254)+1, r_ip[1] = random(254)+1, r_ip[2] = random(254)+1, r_ip[3] = random(254)+1;
		format(str_ip, sizeof str_ip, "%d.%d.%d.%d", r_ip[0], r_ip[1], r_ip[2], r_ip[3]);
	    SendMes(params[0], COLOR_LIGHTRED, "Администратор: %s забанил %s. Причина: %s ",pInfo[playerid][pName],pInfo[i][pName], params[1]);
		SendMes(params[0], COLOR_LIGHTRED, "   Nik [%s]  R-IP [%s]  L-IP [%s]  IP [%s]",pInfo[i][pName], str_ip, str_ip, str_ip);
	}
	new
	    string_[256];
	format(string_, sizeof string_, ""colwhi"Аккаунт: "colwarn"%s "colwhi"заблокирован!\n\nЗаблокировал: "colwarn"%s\n"colwhi"Причина: "colwarn"%s\n"colwhi"Дата блокировки: "colwarn"%s\n"colwhi"Дата разблокировки: "colwarn"%s",
	pInfo[params[0]][pName], pInfo[playerid][pName], params[1], date("%dd.%mm.%yyyy", gettime()), date("%dd.%mm.%yyyy", gettime()+84900*360));
	ShowPlayerDialog(params[0], D_NULL, 0, ""colwarn"Аккаунт заблокирован!", string_, !"Закрыть","");
	Kick(params[0]);
	SendClientMessage(playerid, -1, "DS: Команда выполнена успешно!");
	return true;
}

CMD:freeze(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /freeze [playerid]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен"); 
    if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	TogglePlayerControllable(params[0], 0);
	pTemp[params[0]][tFreezePlayer] = true;
	new 
		string_[100];
	format(string_, sizeof string_, "%s был заморожен администратором %s",pInfo[params[0]][pName], pInfo[playerid][pName]);
	ABroadCast(COLOR_LIGHTRED, string_,1);
	return 1;
}

CMD:unfreeze(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /unfreeze [playerid]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен");
	if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	TogglePlayerControllable(params[0], 1);
	pTemp[params[0]][tFreezePlayer] = false;
	new string_[100];
	format(string_, sizeof string_, "Администратор: %s разморозил %s",pInfo[playerid][pName],pInfo[params[0]][pName]);
	ABroadCast(COLOR_LIGHTRED, string_,1);
	return 1;
} 
CMD:teleport(playerid)
{
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	ShowPlayerDialog(playerid, D_ADMIN_FUNC_7, 2, ""colserver"Телепорт меню",
		"[0] Работы Новичков\n\
		[1] Гос. Работы\n\
		[2] Организации\n\
		[3] Развлекательные места\n\
		[4] Точки в городах\n\
		[5] Людные места\n\
		[6] Админ места\n\
		[7] Нелегальные организации\n\
		[8] Места проведения mafia",

		"Выбрать", "Отмена"
	);
	return 1;
}
alias:teleport("tp");


CMD:mark(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	GetPlayerPos(playerid, TeleportDest[playerid][0], TeleportDest[playerid][1], TeleportDest[playerid][2]);
    TeleportDestNoFloat[playerid][0] = GetPlayerVirtualWorld(playerid);
    TeleportDestNoFloat[playerid][1] = GetPlayerInterior(playerid);
	SendClientMessage(playerid, COLOR_WHITE, !"Точка телепортирования установлена");
	return 1;
}

CMD:gotomark(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (GetPlayerState(playerid) == 2)
	{
		new V_IDX = GetPlayerVehicleID(playerid);
		SetVehiclePos(V_IDX, TeleportDest[playerid][0],TeleportDest[playerid][1],TeleportDest[playerid][2]);
		SetPlayerVirtualWorld(playerid, TeleportDestNoFloat[playerid][0]);
		SetPlayerInterior(playerid, TeleportDestNoFloat[playerid][1]);
		LinkVehicleToInterior(V_IDX, TeleportDestNoFloat[playerid][1]);
	}
	else SetPlayerPosAC(playerid, TeleportDest[playerid][0], TeleportDest[playerid][1],TeleportDest[playerid][2], TeleportDestNoFloat[playerid][0], TeleportDestNoFloat[playerid][1]);
	SendClientMessage(playerid, COLOR_WHITE, !"Вы были телепортированы");
	return 1;
}

CMD:gethere(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gethere [playerid]");
	new 
		Float:plocx,
		Float:plocy,
		Float:plocz;
	new 
        P_INT = GetPlayerInterior(playerid),
        P_WORLD = GetPlayerVirtualWorld(playerid);
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (pInfo[params[0]][pAdmin] > pInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_WHITE, !"Администратор выше вас уровнем!");
	
	if (pTemp[params[0]][PlayerAFK] > 2) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок AFK");
	if (pInfo[params[0]][pMestoJail] == 4) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок в ДеМоргане (Используйте /prison [id] 0)");
	GetPlayerPos(playerid, plocx, plocy, plocz);
	if (pTemp[playerid][tSelectHouseID] != -1) {
		pTemp[params[0]][tSelectHouseID] = pTemp[playerid][tSelectHouseID];
	}
	if (GetPlayerState(params[0]) == 2)
	{
		SetPlayerInterior(params[0], P_INT);
		new 
            V_IDX = GetPlayerVehicleID(params[0]);
		SetPlayerVirtualWorld(params[0], P_WORLD);
		SetVehiclePos(V_IDX, plocx, plocy+4, plocz);
        LinkVehicleToInterior(V_IDX, P_INT);
        SetVehicleVirtualWorld(V_IDX, P_WORLD);
	}
	else SetPlayerPosAC(params[0],plocx,plocy+2, plocz, P_WORLD, P_INT);  
	SendClientMessage(params[0], COLOR_WHITE, "Вас телепортировал к себе администратор "NameServer"");
	return 1;
}
CMD:banip(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new banip[24], ban_ip[4][4], string_[128];
	if (sscanf(params,"s[24]",banip)) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /banip [IP адрес]");
	if (strlen(banip) < 1 || strlen(banip) > 24) return SendClientMessage(playerid, COLOR_WHITE, !"Количество символов 1-23.");
	sscanf(banip,"p<.>s[4]s[4]s[4]s[4]",ban_ip[0],ban_ip[1],ban_ip[2],ban_ip[3]);
    if (strcmp(ban_ip[0], "*", false) == 0 || strcmp(ban_ip[1], "*", false) == 0) return SendClientMessage(playerid, COLOR_GREY, !"Неверный формат блокировки [1.2 уровень нельзя заблокировать].");
    if (strcmp(ban_ip[2], "*", false) == 0 && strcmp(ban_ip[3], "*", false) != 0) return SendClientMessage(playerid, COLOR_GREY, !"Неверный формат в уровне 4 или 3, используйте в 3 уровне цифры, либо в 4");
	if (strlen(ban_ip[2]) < 1) return SendClientMessage(playerid, COLOR_GREY, !"Неверный формат в уровне 3, воспользуйте.");
    if (strlen(ban_ip[3]) < 1) return SendClientMessage(playerid, COLOR_GREY, !"Неверный формат в уровне 4, воспользуйте.");
	format(string_, sizeof string_, "banip %s", banip);
	SendRconCommand(string_);
	SendRconCommand("reloadbans");
	format(string_, sizeof string_, "Администратор: %s забанил IP: %s (Бан Перезагружен)", pInfo[playerid][pName], banip);
	ABroadCast(COLOR_LIGHTRED, string_, 1); 
	LogingAdmins(playerid, pInfo[playerid][pName], "Banip", playerid, banip);
	return 1;
} 
CMD:veh(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "ddd",params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /veh [id авто] [Цвет №1] [Цвет №2]");
	new INT_IDX = GetPlayerInterior(playerid),
		W_IDX = GetPlayerVirtualWorld(playerid);
	if (params[0] < 400 || params[0] > 611) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /veh [id авто] [Цвет №1] [Цвет №2]");
	if (params[1] < 0 || params[1] > 255) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /veh [id авто] [Цвет №1] [Цвет №2]");
	if (params[2] < 0 || params[2] > 255) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /veh [id авто] [Цвет №1] [Цвет №2]");
	new 
        Float: player_pos[3];
	GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
	new adm_veh = _CreateVehicle(params[0], player_pos[0], player_pos[1], player_pos[2], 0.0, params[1], params[2], -1);
	VehicleInfo[ adm_veh - 1 ][vType] = VEHICLE_TYPE_DYNAMIC;
	VehicleInfo[ adm_veh - 1 ][vFraction] = DYNAMIC_VEH_ADMINS;
	VehicleInfo[ adm_veh - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ adm_veh - 1 ][vModel]);

	PutPlayerInVehicle(playerid, adm_veh, 0);
	SetPlayerArmedWeapon(playerid, 0);
	SetVehicleVirtualWorld(adm_veh, W_IDX);
	LinkVehicleToInterior(adm_veh, INT_IDX);
	SendMes(playerid, COLOR_WHITE, "Машина установлена. ID: %d. Для удаления используйте "colserver"\"/delcar\"", params[0]);
	return 1;
}
CMD:plveh(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    extract params -> new player:targetid, model_id; else return SendClientMessage(playerid, COLOR_GREY, !"Введите: /plveh [id игрока] [id авто]");
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    if (model_id < 400 || model_id > 611) return SendClientMessage(playerid, COLOR_GREY, !"ID модели машины содержатся в рамках от 400 до 611.");
	if (model_id == 594 || model_id == 592 || model_id == 591 || model_id == 590 || model_id == 584 || model_id == 577 || model_id == 570 || model_id == 569 
		|| model_id == 564 || model_id == 553 || model_id == 538 || model_id == 537 || model_id == 532 || model_id == 531 || model_id == 530 || model_id == 524 
		|| model_id == 523 /*|| model_id == 520*/ || model_id == 512 || model_id == 513 || model_id == 511 || model_id == 501 || model_id == 488 || model_id == 486 
		|| model_id == 485 || model_id == 484 || model_id == 476 || model_id == 473 || model_id == 472 || model_id == 464 || model_id == 460 || model_id == 450 
		|| model_id == 449 || model_id == 447 || model_id == 443 || model_id == 441 ||model_id == 435 || model_id == 432 || model_id == 430 || model_id == 425 
		|| model_id == 417 || model_id == 406) return SendClientMessage(playerid, COLOR_GREY, !"Этот транспорт запрещен на сервере");
	if (GetPlayerState(targetid) != 1) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок уже находится в транспорте.");

	new 
		Float:pl_posX, 
		Float:pl_posY, 
		Float:pl_posZ, 
		Float:pl_posA,
		string_[128];
	GetPlayerPos(targetid, pl_posX, pl_posY, pl_posZ);
	GetPlayerFacingAngle(targetid, pl_posA);

	if (pTemp[targetid][tTempVeh] != INVALID_VEHICLE_ID) _DestroyVehicle(pTemp[targetid][tTempVeh]);

	pTemp[targetid][tTempVeh] = _CreateVehicle(model_id, pl_posX, pl_posY, pl_posZ, pl_posA, random(100), random(100), 900);
	VehicleInfo[pTemp[targetid][tTempVeh] - 1][vFuel] = GetModelMaxFuel(VehicleInfo[ pTemp[targetid][tTempVeh] - 1 ][vModel]);
	
	SetVehicleVirtualWorld(pTemp[targetid][tTempVeh], GetPlayerVirtualWorld(targetid));
	LinkVehicleToInterior(pTemp[targetid][tTempVeh], GetPlayerInterior(targetid));
	PutPlayerInVehicle(targetid, pTemp[targetid][tTempVeh], 0);
 
	SetVehicleParamsEx(pTemp[targetid][tTempVeh], true, lights2, alarm2, doors3, bonnet2, boot1, objective1); 
	format(string_, sizeof string_, "[A] %s[%d] выдал временный транспорт игроку %s[%d] [id Транспорта: %d] [TEMP: %d]",  
		pInfo[playerid][pName], playerid, pInfo[targetid][pName], targetid, model_id, pTemp[targetid][tTempVeh]);
	SendAdminMessage(COLOR_GREY, string_);
	return 1;
}
	
CMD:delcar(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new 
        V_IDX = GetPlayerVehicleID(playerid);
	if (V_IDX == 0 ) return  SendClientMessage(playerid, COLOR_GRAD1, !"Вы не в транспорте!");
	if (VehicleInfo[ V_IDX - 1 ][vType] != VEHICLE_TYPE_DYNAMIC) return  SendClientMessage(playerid, COLOR_GRAD1, !"Эту машину удалять нельзя");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
	_DestroyVehicle(V_IDX);
	SendClientMessage(playerid, COLOR_GREEN, !"Автомобиль успешно удален!");
	return 1;
}
CMD:spcars(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        Float:pos;
	if (sscanf(params, "f",pos)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /spcars [радиус]");
	new 
        Float:car_x,
        Float:car_y,
        Float:car_z;
	for ( new c = 1 ; c < MAX_VEHICLES; c ++ )
	{
		//if (VehicleInfo[ c - 1 ][vType] == VEHICLE_TYPE_PLAYER) continue;
		if (IsVehicleOccupied(c) != -1) continue;
		if (GetVehicleModel(c) == 450) continue;
		if (GetVehicleModel(c) == 584) continue;
		if (GetVehicleModel(c) == 435) continue;
		if (GetVehicleModel(c) > 399)
		{
			GetVehiclePos(c, car_x, car_y, car_z);
			if (IsPlayerInRangeOfPoint(playerid,pos,car_x,car_y,car_z)) SetVehicleToRespawn(c);
		}
	}
	return 1;
}
CMD:rgivegun(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        Float:pos,
		gun_id;
	if (sscanf(params, "df", gun_id, pos)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /rgivegun [ID Gun] [радиус]");
	if (pos > 100 || pos < 2) return SendClientMessage(playerid, COLOR_GRAD2, !"Радиус от 2 до 100"); 
	if (pInfo[playerid][pAdmin] < 9) {
		if (gun_id < 1 || gun_id > 47 || gun_id == 27 || gun_id == 1 || gun_id == 2 || gun_id == 17 || gun_id == 19 || gun_id == 4
			|| gun_id == 20 || gun_id == 21 || gun_id == 35 || gun_id == 36 || gun_id == 39 || gun_id == 40 || gun_id == 44 || gun_id == 45
			|| gun_id == 38 || gun_id == 32 || gun_id == 28 || gun_id == 18 || gun_id == 37 || gun_id == 16 || gun_id == 9) return SendClientMessage(playerid, COLOR_GREY, !"Данное оружие Вы не можете выдать");
	}  
	foreach(new i: PlayerInLogin) {
		if (GetDistanceBetweenPlayers(playerid, i) < pos && playerid != i) {
			GivePlayerWeapon(i, gun_id, 100);  
		}
	}
	SendClientMessage(playerid, -1, !"Вы выдали оружие в радиусе");
	return 1;
}
CMD:rtakegun(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        Float:pos;
	if (sscanf(params, "f", pos)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /rtakegun [радиус]");
	if (pos > 100 || pos < 2) return SendClientMessage(playerid, COLOR_GRAD2, !"Радиус от 2 до 100"); 
	foreach(new i: PlayerInLogin) {
		if (GetDistanceBetweenPlayers(playerid, i) < pos && playerid != i) {
			ResetPlayerWeapons(i); 
		}
	}
	SendClientMessage(playerid, -1, !"Вы забрали оружие в радиусе");
	return 1;
}
CMD:rsetarm(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        Float:pos;
	if (sscanf(params, "f", pos)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /rsetarm [радиус]");
	if (pos > 100 || pos < 2) return SendClientMessage(playerid, COLOR_GRAD2, !"Радиус от 2 до 100"); 
	foreach(new i: PlayerInLogin) {
		if (GetDistanceBetweenPlayers(playerid, i) < pos && playerid != i) {
			SetPlayerArmour(i, 100.0);
		}
	}
	SendClientMessage(playerid, -1, !"Вы выдали броню в радиусе");
	return 1;
}
CMD:rsethp(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        Float:pos;
	if (sscanf(params, "f", pos)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /rsethp [радиус]");
	if (pos > 100 || pos < 2) return SendClientMessage(playerid, COLOR_GRAD2, !"Радиус от 2 до 100"); 
	foreach(new i: PlayerInLogin) {
		if (GetDistanceBetweenPlayers(playerid, i) < pos && playerid != i) {
			SetPlayerHealth(i, 160.0);
		}
	}
	SendClientMessage(playerid, -1, !"Вы выдали хп в радиусе");
	return 1;
}  
CMD:spcartime(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf ( params, "d", params [ 0 ] ) )return SendClientMessage ( playerid, -1,"Используйте: /spcartime [секунды]" ) ;
	new scm_string [ 128 ] ;
	format ( scm_string, sizeof ( scm_string ), "Администратор "colserver"%s "colwhi"зареспавнит незанятые автомобили через "colserver"%d секунд",  pInfo[playerid][pName], params [ 0 ] ) ;
 	foreach(new i: PlayerInLogin)SendClientMessage ( i, -1, scm_string ) ;
	params [ 0 ] = params [ 0 ] * 1000 ;
	SetTimerEx ( "spawn_cars", params [ 0 ], false, "i", playerid ) ;
	return true;
}

publics: spawn_cars ( playerid )
{
	for( new c = 1 ; c < MAX_VEHICLES; c ++)
	{ 
		//if (VehicleInfo[ c - 1 ][vType] == VEHICLE_TYPE_PLAYER) continue;
		if (IsVehicleOccupied(c) != -1) continue;
		if (GetVehicleModel(c) == 450) continue;
		if (GetVehicleModel(c) == 584) continue;
		if (GetVehicleModel(c) == 435) continue;
		SetVehicleToRespawn(c);
	}
	new _t_string [ 128 ] ;
	format ( _t_string, sizeof ( _t_string ),"Администратор "colserver"%s "colwhi"обновил весь незанятый транспорт.",pInfo[playerid][pName]);
	foreach(new i: PlayerInLogin)SendClientMessage (i, -1, _t_string);
	return true;
} 

publics: spawn_carsooc ( playerid )
{
	for( new c = 1 ; c < MAX_VEHICLES; c ++)
	{ 
		//if (VehicleInfo[ c - 1 ][vType] == VEHICLE_TYPE_PLAYER) continue;
		if (IsVehicleOccupied(c) != -1) continue;
		if (GetVehicleModel(c) == 450) continue;
		if (GetVehicleModel(c) == 584) continue;
		if (GetVehicleModel(c) == 435) continue;
		SetVehicleToRespawn(c);
	}
	SendClientMessageToAll(COLOR_YELLOW, "* Незанятый транспорт был заспавнен");
	return true;
} 

/* 4 LEVEL */
CMD:spwcar(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /spwcar [id]");
	SetVehicleToRespawn(params[0]);
	return 1;
}
CMD:unbanip(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
        banip[16], 
        string_[128];
	if (sscanf(params,"s[16]", banip)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /unbanip [IP]");
	if (strlen(banip) < 1 || strlen(banip) > 16) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /unbanip [IP]");
 
	format(string_, sizeof string_, "unbanip %s", banip);
	SendRconCommand(string_);
	SendRconCommand("reloadbans"); 
	format(string_, sizeof string_, "%s разбанил IP: %s (Бан Перезагружен)",pInfo[playerid][pName], banip);
	ABroadCast(COLOR_GREEN, string_, 1);
	LogingAdmins(playerid, pInfo[playerid][pName], "UnBanip", playerid, banip);
	return 1;
}

/*CMD:agetstats(playerid,params[])
{
	if(Admin_Level{playerid} < 5) return SendClientMessage(playerid,CGRAY2,YouNotCommand);
	new strlen_params = strlen(params);
	if(strlen_params < 4 || strlen_params > 24) return SendClientMessage(playerid,CWHITE,!"Используйте: /offstats [ник]");
	static select_offstats[] = "SELECT `pID`,`pLevel`,`pExp`,`pRIP`,`pLIP`,`super_key_ip`,`pReferal`,`pRegDate`,`pMoney`,`pBankM`,`pHome`,`pHouseCar`,`pNumber`,`pMember`,\
	`pRank`,`pBiz`,`pSkills`,`last_online` FROM `"T_ACC"` WHERE `pName` = '%e'	LIMIT 1";
	new str_offstats[sizeof(select_offstats)+MAX_PLAYER_NAME+3];
	mysql_format(base,str_offstats,sizeof(str_offstats),select_offstats,params);
	mysql_tquery(base,str_offstats, "CheckOffStats","ds",playerid,params);
	return 1;
}

fpub:CheckOffStats(playerid,nick[])
{
    new rows;
	cache_get_row_count(rows);
	if(!rows) return SendClientMessage(playerid,CGRAY2,!"Аккаунт не найден в базе данных");
	goto no_init_arrays;
	new id,
	    level,
	    exp,
	    rip[16],
	    lip[16],
	    referal[MAX_PLAYER_NAME],
		regdate[12],
		money,
		bank,
		home,
		car,
		number,
		member,
		rank,
		biz,
		skills[24],
		last_online[24],
		super_key_ip[16];

	static const off_stats2[] = "\
	Имя аккаунта:\t\t%s\n\n\
	Уровень:\t\t%d\n\
	Exp:\t\t\t%d\n
	VIP:\t\t\t%d\n\
	Warns:\t\t\t%d\n\
	Телефон:\t\t%d\n
	Money:\t\t\t%d\n\
	Bank:\t\t\t%d\n\
	Leader:\t\t%d(%s)\n
	Member:\t\t%d(%s)\n\
	Rank:\t\t\t%d\n\
	Job:\t\t\t%d(%s)\n\
	JobSkin:\t\t%d\n\
	Email:\t\t\t%s\n\n\
	Реферал:\t\t%s\n\
	superKeyIP:\t\t%s\nL-IP:\t\t\t%s\nR-IP:\t\t\t%s\n\n
	";
		
    static const off_stats[] = "\
	{FFFFFF}Name:\t\t%s\n\
	MySQL id:\t%d\n\n\
	Level:\t\t%d (%d / %d)\n\
	Phone:\t\t%d\n\
	Money:\t%d\n\
	Bank:\t\t%d\n\
	Member:\t%d ( %s )\n\
	Rank:\t\t%d ( %s )\n\
	Skills:\t\t%s\n\
	\t(sd,deagle,shotgun,smg,ak,m4)\n\n\
	Refer:\t\t%s\n\
	RegDate:\t%s\n\
	RegIp:\t\t{28EB4D}%s{FFFFFF}\n\
	LastIp:\t\t{F5CB47}%s{FFFFFF}\n\
	SuperKeyIp:\t{CD1F0A}%s\n\n\
	{FF6347}*SuperKeyIp - Если SuperKeyIp и LastIp\n\
 	не совпадают, то кто-то пытался войти\n\
 	в аккаунт не зная супер ключа";
	new str_off_stats[sizeof(off_stats)+15+23+24+12+24+16+16];
	
	no_init_arrays:
	
	cache_get_value_name_int(0, "pID",id);
    cache_get_value_name_int(0, "pLevel",level);
    cache_get_value_name_int(0, "pExp",exp);
    cache_get_value_name(0, "pRIP", rip,sizeof(rip));
    cache_get_value_name(0, "pLIP", lip,sizeof(lip));
    cache_get_value_name(0, "pReferal", referal,sizeof(referal));
    cache_get_value_name(0, "pRegDate", regdate,sizeof(regdate));
    cache_get_value_name_int(0, "pMoney",money);
    cache_get_value_name_int(0, "pBankM",bank);
    cache_get_value_name_int(0, "pNumber",number);
    cache_get_value_name_int(0, "pMember",member);
    cache_get_value_name_int(0, "pRank",rank);
    cache_get_value_name(0, "pSkills", skills,sizeof(skills));
    cache_get_value_name(0, "last_online", last_online,sizeof(last_online));
    cache_get_value_name(0, "super_key_ip", super_key_ip,sizeof(super_key_ip));
    
	format(str_off_stats,sizeof(str_off_stats),off_stats,nick,id,level,exp,level*4,
	number,money,bank,member,NameFrac[member],rank,F_Ranks[F_Rank_Min_Max[member][0]+(rank-1)],
	skills,referal,regdate,rip,lip,super_key_ip);
	ShowPlayerDialog(playerid,dError,DIALOG_STYLE_MSGBOX,!"Оффлайн статистика",str_off_stats,!"Готово","");
	return 1;
}


*/
 
CMD:agetstats(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new name[32], query_[128];
	if (strlen(name) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[32]", name)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /agetstats [Nick_Name]");
	mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_users` WHERE `Name` = '%s' LIMIT 1", name);
	return mysql_tquery(dbHandle, query_, "CheckGet", "is", playerid, name);
}
publics: CheckGet(playerid, nick[])
{
	new
		rows, str_[128],
		get_level, get_exp, get_vip,
		get_warn, number,
		get_cash, get_money,
		get_leader, get_member, get_rank, get_job, jobskin, get_promo,
		get_email[32], get_ref[32],
		check_auth[16], last_ip[16], reg_ip[16],
		strv[26],strvv[26],splitt[4][4],spli[4][4],iptext[33];
	t_string[0] = EOS;
	cache_get_row_count(rows);
	if (!rows) SendClientMessage(playerid, COLOR_GREY, !"Игрок с введенным ником не найден.");
	else
	{
	    cache_get_value_name_int(0, "pLevel", get_level);
	    cache_get_value_name_int(0, "pExp", get_exp);
	    cache_get_value_name_int(0, "vip_rank", get_vip);
		cache_get_value_name_int(0, "pWarns", get_warn);
	    cache_get_value_name_int(0, "pPnumber", number);
		cache_get_value_name_int(0, "pCash", get_cash);
		cache_get_value_name_int(0, "pBank", get_money);
		cache_get_value_name_int(0, "pLeader", get_leader);
		cache_get_value_name_int(0, "pMember", get_member);
		cache_get_value_name_int(0, "pRank", get_rank);
		cache_get_value_name_int(0, "pJob", get_job);
		cache_get_value_name_int(0, "pModel", jobskin);
		cache_get_value_name_int(0, "PromoCode", get_promo);
		cache_get_value_name(0, "pEmail", get_email, 32);
		cache_get_value_name(0, "pDrug", get_ref, 32);
		cache_get_value_name(0, "pIp", check_auth, 16);
    	cache_get_value_name(0, "pvIp", last_ip, 16);
        cache_get_value_name(0, "pIpReg", reg_ip, 16);

	    format(str_, sizeof str_, "Имя аккаунта:\t\t%s\n\nУровень:\t\t%d\nExp:\t\t\t%d\n", nick, get_level, get_exp);
		strcat(t_string, str_);
		format(str_, sizeof str_, "VIP:\t\t\t%d\nWarns:\t\t\t%d\nТелефон:\t\t%d\nПромокод:\t\t%s\n", get_vip, get_warn, number, GetPlayerPromoCodeSearch(get_promo));
		strcat(t_string, str_);
		format(str_, sizeof str_, "Money:\t\t\t%d\nBank:\t\t\t%d\nLeader:\t\t%d(%s)\n", get_cash, get_money, get_leader, gFraction[get_leader][fName]);
		strcat(t_string, str_);
		format(str_, sizeof str_, "Member:\t\t%d(%s)\nRank:\t\t\t%d\nJob:\t\t\t%d(%s)\n", get_member, gFraction[get_member][fName], get_rank, get_job, gJobNames[get_job]);
		strcat(t_string, str_);
		format(str_, sizeof str_, "JobSkin:\t\t%d\nEmail:\t\t\t%s\n\nРеферал:\t\t%s\n", jobskin, get_email, get_ref);
		strcat(t_string, str_);
		format(str_, sizeof str_, "superKeyIP:\t\t%s\nL-IP:\t\t\t%s\nR-IP:\t\t\t%s\n\n", check_auth, last_ip, reg_ip);
		strcat(t_string, str_);
		split(last_ip, splitt,'.');
		format(strv,sizeof(strv),"%s.%s", splitt[0], splitt[1]);
		split(reg_ip,spli,'.');
		format(strvv,sizeof(strvv),"%s.%s", spli[0], spli[1]);
		if (strcmp(strv, strvv, true)) iptext = "{ff6500}Подсеть несовпадает";
		else iptext = "{63cb00}Подсеть совпадает";
		format(str_, sizeof str_, "Аунтификация IP: %s\n", iptext);
		strcat(t_string, str_);
		strcat(t_string, "\n{FF6347}* superKeyIP - к которому привязан акк\nЕсли superKeyIP и L-IP не равны,\nто кто-то пытался войти в аккаунт,\nнезная супер ключа, пароля или ключа Гугл");
		ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "OFFLINE Статистика персонажа", t_string, "Готово", "");
	}
	return 1;
}

CMD:auninvite(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (strlen(params[1]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
    if (sscanf(params, "us[32]",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /auninvite [playerid] [причина]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден");
	if (pInfo[params[0]][pMember] == 0) return 1;
	new 
        string_[145];
	format(string_, sizeof string_, "%s выгнал вас из организации. Причина: %s", pInfo[playerid][pName], params[1]);
	SendClientMessage(params[0], 0x6BB3FFAA, string_);
	format(string_, sizeof string_, "Вы выгнали %s из организации. Причина: %s", pInfo[params[0]][pName], params[1]);
	SendClientMessage(playerid, 0x6BB3FFAA, string_);
	if (pInfo[params[0]][pLeader] != 0)
	{
		SaveFractionString(pInfo[params[0]][pLeader], "fLeader", "None");
		strmid(fInfo[pInfo[params[0]][pLeader]][fLeader],"None", 0, strlen("None"), MAX_PLAYER_NAME);
	}
    uninvite_player(params[0]);

	if (IsANews(params[0]))
	{
		new
			query[ 78 ]; 
		mysql_format(dbHandle, query, sizeof query, "UPDATE s_users SET edited_ads = '0' WHERE Name = '%e'", pInfo[params[0]][pName]);
		mysql_tquery(dbHandle, query);
	}
    return 1;
}
CMD:setferm(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "ddd", params[0], params[1], params[2]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setferm [id ferm] [number] [количество]");
		SendClientMessage(playerid, COLOR_WHITE, !" [0] - Урожай, [1] - зернo, [2] - Продукты");
		return 1;
	}
	if (params[0] < 1 || params[0] > 5) return SendClientMessage(playerid, COLOR_GREY, !"от 1 до 5");
	switch(params[1])
	{
		case 0: {
			FarmInfo[params[0]][fGrain_Sown] = params[2];
			SendMes(playerid, COLOR_WHITE, "Вы пополнили урожай на %d, Сейчас %d",params[0], FarmInfo[params[0]][fGrain_Sown]);
			SaveFermID(params[0]);
		}
		case 1: {
			FarmInfo[params[0]][fGrain] = params[2];
			SendMes(playerid, COLOR_WHITE, "Вы пополнили зерно на %d, Сейчас %d",params[0], FarmInfo[params[0]][fGrain]);
			SaveFermID(params[0]);
		}
		case 2: {
			FarmInfo[params[0]][fProds] = params[2];
			SendMes(playerid, COLOR_WHITE, "Вы пополнили продукты на %d, Сейчас %d",params[0], FarmInfo[params[0]][fProds]);
			SaveFermID(params[0]);
		}
	}
	
	return 1;
}

CMD:ioffban(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new giveplayerid = INVALID_PLAYER_ID, nickname[MAX_PLAYER_NAME], reason[128], yeeer = 2037;
	if (sscanf(params,"s[24]s[64]", nickname, reason)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ioffban [имя игрока] [причина]");
	if (!strcmp(nickname, pInfo[playerid][pName], true)) return SendClientMessage(playerid, COLOR_GREY, !"Вы ввели свой ник");
	sscanf(nickname,"u",giveplayerid);
	if (IsPlayerConnected(giveplayerid)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /iban ))", pInfo[giveplayerid][pName], giveplayerid);
	new query_[128];
	aAdminInfo[playerid][aBan] ++; 
    mysql_format(dbHandle, query_, sizeof(query_), "SELECT * FROM `s_users` WHERE `Name` = '%s'", nickname);
    mysql_tquery(dbHandle, query_, "CheckOffBanPlayer", "issii", playerid, nickname, reason, yeeer, yeeer);
	return 1;
}
CMD:offban(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new 
		giveplayerid = INVALID_PLAYER_ID, 
		nickname[MAX_PLAYER_NAME], 
		reason[128], 
		yeeer = 1,
		temp_day;

	if (pInfo[params[0]][pAdmin] > 0 && pInfo[playerid][pAdmin] < 6) 
	return SendClientMessage(playerid, COLOR_GREY, !"Администратор выше Вас уровнем!");
	if (sscanf(params,"s[24]ds[64]", nickname, temp_day, reason)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /offban [имя игрока] [day] [причина]");
	if (temp_day < 1 || temp_day > 30) return SendClientMessage(playerid, COLOR_GREY, !"Разрешено банить только от 1 до 30 дней");
	sscanf(nickname, "u", giveplayerid);
	if (IsPlayerConnected(giveplayerid)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /ban ))", pInfo[giveplayerid][pName], giveplayerid);
	new query_[128];
	aAdminInfo[playerid][aBan] ++;
	
    mysql_format(dbHandle, query_, sizeof(query_), "SELECT * FROM `s_users` WHERE `Name` = '%s'", nickname);
    mysql_tquery(dbHandle, query_, "CheckOffBanPlayer", "issii", playerid, nickname, reason, yeeer, temp_day);
	return 1;
}
publics: CheckOffBanPlayer(adminid, nickname[], reason[], yeeer, b_day)
{
	new rows;
    cache_get_row_count(rows);
    if (!rows) return SendClientMessage(adminid, COLOR_GREY, !"Данного аккаунта нет в базе данных!");
    if (0 == CheckBanedNickName(adminid, nickname)) return 1;
    new query_[72], id_player;
    cache_get_value_name_int(0, "pID", id_player);
    mysql_format(dbHandle, query_, sizeof(query_), "SELECT * FROM `s_ban` WHERE `Name` = '%s' LIMIT 1", nickname);
    mysql_tquery(dbHandle, query_, "OffBanPlayer", "issiii", adminid, nickname, reason, yeeer, id_player, b_day);
	return 1;
}

publics: OffBanPlayer(adminid, nickname[], reason[], yeeer, id_player, b_day)
{
    new rows;
    cache_get_row_count(rows);
	if (rows) return SendClientMessage(adminid, COLOR_GREY, !"Данный аккаунт уже заблокирован!");
	new string_[128], query_[256], unwarndate;

	if (yeeer == 1) {
		unwarndate = gettime() + b_day * 86400;
        format(string_, sizeof(string_), "OffBan[забанил: %s][забанен: %s/%d][П: %s]",pInfo[adminid][pName], nickname, b_day, reason);
        mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO `s_ban`  ( `Text`, `Name`, `NameAdmin`, `Date`, `Unban`) VALUES ('%s', '%s', '%s', '%d', '%d')",reason, nickname, pInfo[adminid][pName],gettime(), unwarndate);
	}
	else if (yeeer == 2037) {
	   	unwarndate = gettime() + 2037 * 86400;
        format(string_, sizeof(string_), "IOffBan[забанил: %s][забанен: %s/2037][П: %s]",pInfo[adminid][pName], nickname, reason);
        mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO `s_ban`  ( `Text`, `Name`, `NameAdmin`, `Date`, `Unban`) VALUES ('%s', '%s', '%s', '%d', '%d')",reason, nickname, pInfo[adminid][pName],gettime(), unwarndate);
	}
	HistoryPlayerBan(id_player, pInfo[adminid][pName], reason);
	ABroadCast(COLOR_LIGHTRED, string_, 1);
	mysql_tquery(dbHandle, query_, "", "");
	return 1;
}

CMD:skick(playerid, params[])
{
    //if (Spectate[playerid]) StopSpectate(playerid);
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /skick [playerid]");
	new id = strval(params);
	if (!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_GREY, !"Нет такого игрока"); 
    if (pInfo[playerid][pAdmin] < pInfo[id][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
    if (0 == CheckBanedNickName(playerid, pInfo[id][pName])) return 1; 
	new 
        temp[128];
	if (IsAGang(id) || IsAMafia(id)) {
		CheckWarCapture(id, REASON_KICK);
	}
	format(temp, sizeof temp,"[SKICK] %s[%d] тихо кикнул игрока %s[%d].", pInfo[playerid][pName], playerid, pInfo[id][pName], id, params[1]);
	ABroadCast(COLOR_YELLOW, temp, 1);
	Kick(id);
	return 1;
}

CMD:olimit(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d", antiooc)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /olimit [секунды]");
	return SendMes(playerid, COLOR_WHITE, "Установлен лимит для OOC чата на %d секунд", antiooc);
}

CMD:noooc(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (noooc != 0) return noooc = 0, SendClientMessageToAll(COLOR_WHITE, !"Общий чат отключен админом!");
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /noooc [1 включить / 0 отключить]");
	if (params[0] < 0 || params[0] > 1) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /noooc [1 включить / 0 отключить]");
	noooc = params[0], SendMesAll(COLOR_WHITE, "Общий чат включен администратором: %s[%d]!", pInfo[playerid][pName], playerid);
	return 1;
}

CMD:settime(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /settime [час] (0-23)");
	SetWorldTime(params[0]);
	SendMesAll(COLOR_WHITE, "Время установлено на %d часов.", params[0]);
	return 1;
}

CMD:sban(playerid, params[])
{
    //if (Spectate[playerid]) StopSpectate(playerid);
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "uds[64]",params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sban [id/ник] [дни] [причина]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен / Вы указали свой ID");
	if (IsAIP(params[2]))return 1;
	if (params[1] < 1 || params[1] > 30) return SendClientMessage(playerid, COLOR_GREY, !"Разрешено банить только от 1 до 30 дней.");
	if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	if (0 == CheckBanedNickName(playerid,pInfo[params[0]][pName])) return 1;
	new ip[16], string_[128];
	getdate(year, month, day);
	gettime(hour,minute,second);
	GetPlayerIp(params[0],ip,sizeof ip);

	format(string_, sizeof string_, "Администратор %s Забанен. Обратитесь к спец-админу", pInfo[playerid][pName]);
	if (pInfo[params[0]][pAdmin] >= 1 && pInfo[playerid][pAdmin] < 7)
	ABroadCast(COLOR_LIGHTRED, string_, 1);

	format(string_, sizeof string_, "SBan[забанил: %s][забанен: %s/%d][причина: %s][%d/%d/%d  %d:%d]",
	pInfo[playerid][pName], pInfo[params[0]][pName], params[1], params[2], day, month, year, hour, minute);
	ABroadCast(COLOR_LIGHTRED, string_, 1);

	format(string_, sizeof string_, "   Nik [%s]  R-IP [%s]  L-IP [%s]  IP [%s]",
	pInfo[params[0]][pName], pInfo[params[0]][RegIP], pInfo[params[0]][LastIP], ip);
	ABroadCast(COLOR_LIGHTRED, string_ , 3);

	if (IsAGang(params[0]) || IsAMafia(params[0])) {
		CheckWarCapture(params[0], REASON_BAN);
	}

	aAdminInfo[playerid][aBan] ++;
	
    
	OnPlayerServerBan(playerid, params[0], params[2], params[1]);
	HistoryPlayerBan(pInfo[params[0]][pID], pInfo[playerid][pName], params[2]);
	LogingAdmins(playerid, pInfo[params[0]][pName], "/sban", params[1], params[2]);

	leave_team(params[0], pInfo[params[0]][pMember]);
	pInfo[params[0]][pMember] = 0;
	if (pInfo[params[0]][pLeader] != 0)
	{
	    SaveFractionString(pInfo[params[0]][pLeader], "fLeader", "None");
		strmid(fInfo[pInfo[params[0]][pLeader]][fLeader], "None", 0, strlen("None"), MAX_PLAYER_NAME);
	} 
	pInfo[params[0]][pLeader] = 0; 
	pInfo[params[0]][pJob] = 0;
	pInfo[params[0]][pRank] = 0;
	if (pInfo[params[0]][PlayerSpawn] == 2)
	{
	    if (pInfo[playerid][pHouseID] == -1) pInfo[params[0]][PlayerSpawn] = 0;
		else pInfo[params[0]][PlayerSpawn] = 1;
	    SavePlayerInteger(params[0], "playerspawn", pInfo[params[0]][PlayerSpawn]);
	} 
	return 1;
}

CMD:iban(playerid, params[])
{
    //if (Spectate[playerid]) StopSpectate(playerid);
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "us[64]",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /iban [id/ник] [причина]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн / не залогинен / Вы указали свой ID");
	if (IsAIP(params[1]))return 1;
	if (pInfo[playerid][pAdmin] < pInfo[params[0]][pAdmin]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");
	if (0 == CheckBanedNickName(playerid,pInfo[params[0]][pName])) return 1;
    new ip[16], string_[128];
	format(string_, sizeof string_, "Администратор %s Забанен. Обратитесь к спец-админу", pInfo[playerid][pName]);
	if (pInfo[params[0]][pAdmin] >= 1 && pInfo[playerid][pAdmin] < 7)
	ABroadCast(COLOR_LIGHTRED, string_,1);

	SendMesAll(COLOR_LIGHTRED, "Администратор: %s забанил игрока %s. Причина: %s",pInfo[playerid][pName], pInfo[params[0]][pName], params[1]);

	if (IsAGang(params[0]) || IsAMafia(params[0])) {
		CheckWarCapture(params[0], REASON_BAN);
	}

	GetPlayerIp(params[0],ip,sizeof(ip));

    aAdminInfo[playerid][aBan] ++;
	
	format(string_, sizeof string_, "   Nik [%s]  R-IP [%s]  L-IP [%s]  IP [%s]",pInfo[params[0]][pName],pInfo[params[0]][RegIP],pInfo[params[0]][LastIP],ip);
	ABroadCast(COLOR_LIGHTRED,string_, 3);

	new unwarndate, query_[300];
	unwarndate = gettime() + 2037 * 86400;
	mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO `s_ban` ( `Text`, `Name`, `NameAdmin`, `Date`, `Unban`) VALUES ('%s', '%s', '%s', '%d', '%d')",params[1], pInfo[params[0]][pName], pInfo[playerid][pName], gettime(), unwarndate);
	mysql_tquery(dbHandle, query_);
	HistoryPlayerBan(pInfo[params[0]][pID], pInfo[playerid][pName], params[1]);
	LogingAdmins(playerid, pInfo[params[0]][pName], "/iban", pInfo[params[0]][pAdmin], params[1]);
	Kick(params[0]);
	return 1;
}

CMD:getip(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /getip [playerid]");
	if (pInfo[params[0]][pAdmin] > 5 && pInfo[playerid][pAdmin] < 6) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете посмотреть IP администратора более 5 уровня");
    if (0 == CheckBanedNickName(params[0], pInfo[params[0]][pName])) return 1;
	if (!IsPlayerConnected(params[0])) return 1;

    new 
        ip[15], 
        string_[128]; 
	GetPlayerIp(params[0], ip, sizeof ip); 
	format(string_, sizeof string_, "Nik [%s]\tR-IP [%s]\tL-IP [%s]\tIP [%s]",pInfo[params[0]][pName], pInfo[params[0]][RegIP], pInfo[params[0]][LastIP], ip);
	return SendClientMessage(playerid, 0x6BB3FFAA, string_);
}

CMD:acheck(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /acheck [playerid]");
	if (!IsPlayerConnected(params[0])) return 1;

    new 
        ip[15], 
        string_[128]; 
	GetPlayerIp(params[0], ip, sizeof ip); 
	format(string_, sizeof string_, "Nik [%s]\tR-IP [%s]\tL-IP [%s]\tA-LVL: [%d]",pInfo[params[0]][pName], pInfo[params[0]][RegIP], pInfo[params[0]][LastIP], pInfo[params[0]][pAdmin]);
	return SendClientMessage(playerid, 0x6BB3FFAA, string_);
}

CMD:pallgetip(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (strlen(params[0]) >= 32) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /pallgetip [IP]");
	if (sscanf(params, "s[32]", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /pallgetip [IP]");
	new 
        query_[128];
	mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_users` WHERE `pvIp` = '%e'", params[0]);
	return mysql_tquery(dbHandle, query_, "CheckPGetIP", "is", playerid, params[0]);
}
publics: CheckPGetIP(playerid, ip[])
{
	new
		rows,
		count,
		counts,
		count2,
		counts2,
		str_[128];
    t_string[0] = EOS;
	cache_get_row_count(rows);
	if (rows)
	{
		new get_Name[24], online[20], level, money, bank;
		foreach(new i: PlayerInLogin)
		{
			if (!PlayerInConnected(i)) continue;
			if (!strcmp(pInfo[i][LastIP], ip))
			{
				counts++;
			}
		}
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name(i, "Name", get_Name, MAX_PLAYER_NAME);
			if (!IsPlayerConnected(GetPlayerID(get_Name))) count++;
		}




		format(str_, sizeof str_, "{FFFFFF}Последние игроки, которые заходили с этого IP (найдено %d совпадений)\n", counts+count);
		strcat(t_string, str_);
		strcat(t_string, "{FFFFFF}Игроки {00dd35}Онлайн\n\n{FFFFFF}#\tЛогин\t\t\t\t\tУровень\tИд\t\tДеньги(наличка + банк)\n");
		foreach(new i: PlayerInLogin)
		{
			if (!PlayerInConnected(i)) continue;
			if (!strcmp(pInfo[i][LastIP], ip))
			{
				counts2++;
				if (counts2 == counts)
				{
					format(str_, sizeof str_, "{FFFFFF}%d\t%s\t\t\t\t%d\t\t%d\t\t%d", counts2, pInfo[i][pName], pInfo[i][pLevel], i, pInfo[i][pBank]+pInfo[i][pCash]);
					strcat(t_string, str_);
				}
				else
				{
					format(str_, sizeof str_, "{FFFFFF}%d\t%s\t\t\t\t%d\t\t%d\t\t%d\n", counts2, pInfo[i][pName], pInfo[i][pLevel], i, pInfo[i][pBank]+pInfo[i][pCash]);
					strcat(t_string, str_);
				}
			}
		}
		if (counts == 0) strcat(t_string, "{FFFFFF}Нет совпадений.");
		strcat(t_string, "\n\n{FFFFFF}Игроки {f64c06}Оффлайн\n\n");
		strcat(t_string, "{FFFFFF}#\tЛогин\t\t\t\t\tУровень\tДата\t\tДеньги(наличка + банк)\n");
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name(i, "Name", get_Name, MAX_PLAYER_NAME);
			cache_get_value_name_int(i, "pLevel", level);
			cache_get_value_name(i, "pGetonDate", online, 20);
			cache_get_value_name_int(i, "pCash", money);
			cache_get_value_name_int(i, "pBank", bank);
			if (!IsPlayerConnected(GetPlayerID(get_Name)))
			{
				count2++;
				if (count == count2)
				{
					format(str_, sizeof str_, "{FFFFFF}%d\t%s\t\t\t\t%d\t\t%s\t%d", i+1, get_Name, level, online, money+bank);
					strcat(t_string, str_);
				}
				else
				{
					format(str_, sizeof str_, "{FFFFFF}%d\t%s\t\t\t\t%d\t\t%s\t%d\n", i+1, get_Name, level, online, money+bank);
					strcat(t_string, str_);
				}
			}
		}
		if (count == 0) strcat(t_string, "{FFFFFF}Нет совпадений.");
	}
	else
	{
		foreach(new i: PlayerInLogin)
		{
			if (!PlayerInConnected(i)) continue;
			new superip[16];
			GetPlayerIp(i, superip, 16);
			if (!strcmp(superip, ip))
			{
				counts++;
			}
		}
		format(str_, sizeof str_, "{FFFFFF}Последние игроки, которые заходили с этого IP (найдено %d совпадений)\n", counts);
		strcat(t_string, str_);
		strcat(t_string, "{FFFFFF}Игроки {00dd35}Онлайн\n\n");
		strcat(t_string, "{FFFFFF}#\tЛогин\t\t\t\t\tУровень\tИд\t\tДеньги(наличка + банк)\n");
		foreach(new i: PlayerInLogin)
		{
			if (!PlayerInConnected(i)) continue;
			new superip[16];
			GetPlayerIp(i, superip, 16);
			if (!strcmp(superip, ip))
			{
				counts2++;
				if (counts2 == counts)
				{
					format(str_, sizeof str_, "{FFFFFF}%d\t%s\t\t\t\t%d\t\t%d\t\t%d", counts2, pInfo[i][pName], pInfo[i][pLevel], i, pInfo[i][pBank]+pInfo[i][pCash]);
					strcat(t_string, str_);
				}
				else
				{
					format(str_, sizeof str_, "{FFFFFF}%d\t%s\t\t\t\t%d\t\t%d\t\t%d\n", counts2, pInfo[i][pName], pInfo[i][pLevel], i, pInfo[i][pBank]+pInfo[i][pCash]);
					strcat(t_string, str_);
				}
			}
		}
		if (counts == 0) strcat(t_string, "{FFFFFF}Нет совпадений.");
		strcat(t_string, "\n\n{FFFFFF}Игроки {f64c06}Оффлайн\n\n{FFFFFF}#\tЛогин\t\t\t\t\tУровень\tДата\t\tДеньги(наличка + банк)\n\n");
		strcat(t_string, "{FFFFFF}Нет совпадений.");
	}
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Результат", t_string, "Скрыть", "");
	return 1;
}

stock IsAFreeze(member)
{
	if (member == 5 || member == 6 || member == 12 || member == 13 || member == 14 || member == 15 || member == 17 || member == 18 || member == 24 || member == 25 || member == 26) return 1;
	return 0;
}
CMD:gfreeze(playerid)
{
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	t_string[0] = EOS;
	new str_[128],
		total_f = 0;
	strcat(t_string, ""colserver"[№] Организация\t"colserver"Статус\n");
	for(new idx = 1; idx <= TOTAL_FRACTION; idx++)
	{
	    if (!IsAFreeze(idx)) continue;
		format(str_, sizeof str_,""colwhi"[%d] %s\t%s\n", total_f, fInfo[idx][fName], (fInfo[idx][fFreeze] ? (""colwarn"Запрещено"):(""collime"Разрешено")) );
		strcat(t_string, str_);
		total_f ++;
	}
	ShowPlayerDialog(playerid, D_ADMIN_FUNC_27, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Статусы (/capture, /mafiawar, /bikerswar)", t_string, "Изменить", "Закрыть");
	return 1 ;
}
alias:gfreeze("ffreeze");
/* 5 LEVEL */
CMD:sethp(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "ud",params[0], params[1])) return	SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sethp [id] [уровень hp]");
	if (!PlayerInConnected(params[0])) return 1;
	if (params[1] > 201) return SendClientMessage(playerid, COLOR_GREY,!"Нельзя давать больше 200 хп!");
	SetPlayerHealth(params[0], params[1]);
	if (pInfo[params[0]][pHospital] != 0) {
		pInfo[params[0]][pHospital] = 0;
		SendMes(params[0], COLOR_LIME, "Администратор: %s[%d] Выпустил Вас из больницы", pInfo[playerid][pName], playerid);
	}
	SendClientMessage(playerid, COLOR_WHITE, !"Уровень hp игроку установлен");
	return 1;
}
CMD:setarm(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "ud",params[0], params[1])) return	SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setarm [id] [armour]");
	if (!PlayerInConnected(params[0])) return 1;
	if (params[1] > 100) return SendClientMessage(playerid, COLOR_GREY,!"Нельзя давать больше 100!");
	SetPlayerArmour(params[0], params[1]); 
	SendClientMessage(playerid, COLOR_WHITE, !"Уровень брони игроку установлен");
	return 1;
}
CMD:graffiti(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params,"d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /graffiti [tag number]");
	if (params[0] < 1 || params[0] > GRAFFITI_COUNT) return SendClientMessage(playerid, COLOR_GREY, !"Значение Выходит за допустимые пределы");
	SetPlayerPosAC(playerid, TagInfo[params[0]][tPos][0],TagInfo[params[0]][tPos][1],TagInfo[params[0]][tPos][2], 0, 0);
	SetPlayerFacingAngle(playerid, 0.0);
	return 1;
}
CMD:cc(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	ClearChatboxAll(40);
	new
		string_[128];
	format(string_, sizeof string_, "Игровой чат очищен администратором сервера %s[%d]", pInfo[playerid][pName], playerid);
	SendClientMessageToAll(COLOR_WHITE, string_);
	return 1;
}
CMD:unwarn(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /unwarn [id]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (pInfo[params[0]][pWarns] <= 0) return SendClientMessage(playerid, COLOR_RED, "Варнов нет");
	pInfo[params[0]][pWarns] = 0;
	pInfo[params[0]][punWarns] = 0;
	new str_[68];
	
	format(str_, sizeof str_, "Admin: %s unwarned: %s",pInfo[playerid][pName],pInfo[params[0]][pName]);
	ABroadCast(COLOR_YELLOW, str_,1);
	LogingAdmins(playerid, pInfo[params[0]][pName], "/unwarn", pInfo[params[0]][pWarns], "Un Warn");
	return 1;
}
CMD:warnmans(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new countmute = 0,
		string_[128];
	foreach(new i: PlayerInLogin)
	{
		if (pInfo[i][pWarns] >= 1 && IsPlayerConnected(i))
		{
			format(string_, sizeof string_, "%s [ID: %d] | Warns: %d ",pInfo[i][pName],i,pInfo[i][pWarns]);
			countmute++;
			SendClientMessage(playerid, COLOR_LIGHTGREEN, string_);
		}
	}
	if (countmute == 0) SendClientMessage(playerid, COLOR_GRAD1, "Нет игроков с Варнами");
	else
	{
		format(string_, sizeof string_, "Всего: %d человек!", countmute);
		SendClientMessage(playerid, COLOR_WHITE, string_);
	}
	return 1;
}
CMD:vipmans(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new 
		countmute = 0,
		string_[128], vip_name[25];
	foreach(new i: PlayerInLogin)
	{
		if (pInfo[i][VIPRank] == VIP_PACK_NONE) continue; 
		GetVIPRankName(i, vip_name);
		format(string_, sizeof string_, ""collime"%s [ID: %d] | VIP: %s", pInfo[i][pName], i, vip_name);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, string_);
		countmute++; 
	}
	if (countmute == 0) SendClientMessage(playerid, COLOR_GRAD1, "Нет игроков с Vip");
	else {
		format(string_, sizeof string_, "Всего: %d человек!", countmute);
		SendClientMessage(playerid, COLOR_WHITE, string_);
	}
	return 1;
}


CMD:house(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /house [housenumber]");
	SetPlayerPosAC(playerid, HouseInfo[params[0]][hEnter][0], HouseInfo[params[0]][hEnter][1], HouseInfo[params[0]][hEnter][2], 0, 0);
	SetPlayerFacingAngle(playerid, 0.0);
    teleport_tick[playerid] = GetTickCount();
    GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~TELEPORT ~g~HOUSE", 3000, 3);
	return 1;
}
CMD:biz(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /biz [ID BIZZ]");
    if (params[0] > TOTALBUSINESSES) return SendClientMessage(playerid, COLOR_GREY, !"Неверный ID BIZZ");
	/*if (BizzInfo[params[0]][bType] != 4)
	{
        SetPlayerPosAC(playerid, BizzInfo[params[0]][bExit][0], BizzInfo[params[0]][bExit][1], BizzInfo[params[0]][bExit][2], BizzInfo[params[0]][bVirtualWorld], BizzInfo[params[0]][bInterior]);
        teleport_tick[playerid] = GetTickCount();
	}
	else SetPlayerPosAC(playerid, BizzInfo[params[0]][bEnter][0], BizzInfo[params[0]][bEnter][1], BizzInfo[params[0]][bEnter][2], 0, 0);*/
    SetPlayerPosAC(playerid, BusinessInfo[params[0]][bPos][0], BusinessInfo[params[0]][bPos][1], BusinessInfo[params[0]][bPos][2], 0, 0);
    teleport_tick[playerid] = GetTickCount();
    GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~TELEPORT ~g~BUSINESS", 3000, 3);
	//SetPVarInt(playerid, "PlayerBizzID", params[0]);
	return 1;
}

CMD:weather(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /weather [id погоды]");
	if (params[0] < 0||params[0] > 45) return SendClientMessage(playerid, COLOR_GREY, !"ID Погоды не может быть меньше 0 и больше 45!");
	SetWeather(params[0]);
	SendClientMessage(playerid, COLOR_WHITE, !"Погода изменена!");
	return 1;
}
alias:givegun("gg");
CMD:givegun(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "udd",params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /givegun [id] [id оружия] [патроны]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (pInfo[playerid][pAdmin] < 6) {
		if (params[1] < 1 || params[1] > 47 || params[1] == 27 || params[1] == 1 || params[1] == 2 || params[1] == 17 || params[1] == 19 || params[1] == 4
			|| params[1] == 20 || params[1] == 21 || params[1] == 35 || params[1] == 36 || params[1] == 39 || params[1] == 40 || params[1] == 44 || params[1] == 45
			|| params[1] == 38 || params[1] == 32 || params[1] == 28 || params[1] == 18 || params[1] == 37 || params[1] == 16 || params[1] == 9) return SendClientMessage(playerid, COLOR_GREY, !"Данное оружие Вы не можете выдать");
	} 
	if (params[2] < 1 || params[2] > 9999) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя меньше 1 или больше 999 патронов!"); 
	GivePlayerWeapon(params[0], params[1], params[2]);

	new string_[128];
	format(string_, sizeof string_, "[A] %s[%d] выдал оружие игроку %s[%d] [Gun: %d]",  
		pInfo[playerid][pName], playerid, pInfo[params[0]][pName], params[0], params[1]);
	SendAdminMessage(COLOR_GREY, string_);

	SendClientMessage(playerid, COLOR_GRAD1, !"Оружие Выдано");
	LogingAdmins(playerid, pInfo[params[0]][pName], "Givegun", params[1],"/givegun");
	return 1;
}
CMD:agun(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "dd",params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /agun [id оружия] [патроны]"); 
	if (pInfo[playerid][pAdmin] < 6) {
		if (params[0] < 1 || params[0] > 47 || params[0] == 27 || params[0] == 1 || params[0] == 2 || params[0] == 17 || params[0] == 19 || params[0] == 4
			|| params[0] == 20 || params[0] == 21 || params[0] == 35 || params[0] == 36 || params[0] == 39 || params[0] == 40 || params[0] == 44 || params[0] == 45
			|| params[0] == 38 || params[0] == 32 || params[0] == 28 || params[0] == 18 || params[0] == 37 || params[0] == 16 || params[0] == 9) return SendClientMessage(playerid, COLOR_GREY, !"Данное оружие Вы не можете выдать");
	} 
	if (params[1] < 1 || params[1] > 9999) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя меньше 1 или больше 999 патронов!"); 
	GivePlayerWeapon(playerid, params[0], params[1]);

	SendClientMessage(playerid, COLOR_GRAD1, !"Оружие Выдано");
	LogingAdmins(playerid, pInfo[params[0]][pName], "aGun", params[1],"/agun");
	return 1;
}
CMD:unban(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "s[32]", params[0])) return SendClientMessage(playerid, COLOR_GRAD1, !"Введите: /unban [name]");
	new query_[128],
		str_[65];
	mysql_format(dbHandle, query_, sizeof query_, "DELETE FROM `s_ban` WHERE `Name` = '%e'",params[0]);
    mysql_tquery(dbHandle, query_, "", "");
	format(str_, sizeof str_, "Admin: %s unbanned: %s",pInfo[playerid][pName],params[0]);
	ABroadCast(COLOR_YELLOW, str_,1);
	LogingAdmins(playerid, pInfo[playerid][pName], "UnBan", playerid, params[0]);
	//else SendMes(playerid, COLOR_YELLOW, "Аккаунт не найден в базе данных.");
	return 1;
}
CMD:aoffuninvite(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /aoffuninvite [name]");
	new player_uninvite;
	sscanf(params, "u", player_uninvite);
	if (PlayerInConnected(player_uninvite)) return SendClientMessage(playerid, CGRAY2, !"Игрок онлайн!");

	new query_[140],fracid;

	mysql_format(dbHandle,query_, sizeof(query_), "SELECT `pMember` FROM `s_users` WHERE `Name` = '%e' LIMIT 1", params);
	new Cache:result = mysql_query(dbHandle, query_);
	new rows = cache_num_rows();

	if (rows > 0)
	{
		cache_get_value_int(0, "pMember", fracid);
		if (fracid != 0)
		{
			mysql_format(dbHandle,query_, sizeof (query_), 
			"UPDATE `s_users` SET `pLeader` = '0',`pMember` = '0',`pRank` = '0', `playerspawn` = '0' WHERE `Name` = '%e' LIMIT 1", params);
			mysql_tquery(dbHandle, query_);
			format(query_, sizeof query_, "Admin: %s offUninvite: %s (fracid %d)",pInfo[playerid][pName],params,fracid);
			ABroadCast(COLOR_YELLOW, query_,1);
		}
		else SendClientMessage(playerid, CGRAY2, !"Игрок не состоит во фракции");
	}
	else SendClientMessage(playerid, CGRAY2, !"Игрок не найден");
	cache_delete(result);
	return 1;
}

CMD:offunwarn(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new
		string[220],
		giveplayerid;
	if (isnull(params) || strlen(params) > 25) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /offunwarn [Nick Name]");
	sscanf(params, "u", giveplayerid);
	if (giveplayerid != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок онлайн");
    format(string, sizeof(string), "SELECT `pWarns` FROM `s_users` WHERE `Name` = '%s' LIMIT 1", params);
    new warns = 0;
	new Cache:result = mysql_query(dbHandle, string);
	new rows = cache_num_rows();
	if (rows > 0)
	{
		cache_get_value_int(0, "pWarns", warns);
		if (warns == 0) {
			SendClientMessage(playerid, COLOR_GREY, !"Варны отсутствуют");
			cache_delete(result);
			return 1;
		}
		new 
			CountWarns = warns-1;
		new 
			query_[128];
		if (CountWarns == 0) {
			format(query_, sizeof query_, "UPDATE `s_users` SET `pWarns` = '%d', `punWarns` = '0' WHERE `Name` = '%s' LIMIT 1", warns-1, params);
			mysql_pquery(dbHandle, query_);
		} else {
			format(query_, sizeof query_, "UPDATE `s_users` SET `pWarns` = '%d' WHERE `Name` = '%s' LIMIT 1", warns-1, params);
			mysql_pquery(dbHandle, query_);
		} 
		format(query_, sizeof query_, "Администратор: %s удалил предупреждения в оффлайн игроку: %s",pInfo[playerid][pName],params);
		ABroadCast(COLOR_LIGHTRED, query_, 1);
	}
	cache_delete(result);
	return 1;
} 

CMD:apanel(playerid)
{
    if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new 
        count_[64];
 	format(count_, sizeof count_ ,""colserver"В сети: Администраторов: %d / Саппортов: %d",Iter_Count(AdminsTeam), Iter_Count(SupportsTeam)); 
    ShowPlayerDialog(playerid, D_ADMIN_PANEL_0, DIALOG_STYLE_LIST, count_, "\
	[0] Команды администратора\n\
	[1] Мониторинги\n\
	[2] Очистить строку читеров\n\
	[3] Очистить KillList\n\
	[4] Амнистия\n\
	[5] Уведомления\n\
	[6] Пополнить", "Выбрать", "Отмена");
	return 1;
}

CMD:modconfig(playerid)
{
	if (pInfo[playerid][pAdmin] < 10) return SendClientMessage(playerid, COLOR_GREY, !"Доступно только основателям!");
	  	new string_[512];
	    format(string_, sizeof string_, ""colwhi"\
		[0] Настройка систем\n\
		[1] Анти Team-Kill\t[%s"colwhi"]\n\
		[2] Настройка Анти-Чита\n\
		[3] Настроить уровень инвайтов\n\
		[4] Сбросить КД - На капты Бандам\n\
		[5] Сбросить КД - На капты Мафиям\n\
		[6] Сбросить КД - На капты Байкерам\n\
		[7] Реклама\t[%s"colwhi"]\n\
		[8] Спавш машин\t[%s"colwhi"]",
		(!ServerAntiTK) ? (""colwarn"Выключен") : (""colserver"Включен"),
		(!ReklamaOOC) ? (""colwarn"Выключена"):(""colserver"Включена"),
		(!Spawncartime) ? (""colwarn"Выключен"):(""colserver"Включен")
		);
	return ShowPlayerDialog(playerid, D_ADMIN_PANEL_4, DIALOG_STYLE_LIST, "Управление модом", string_, "Выбрать", "Назад");//
}	


CMD:objsoe(playerid)
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	ShowPlayerDialog(playerid, D_DYNAMIC_OBJ_0, 2, ""colserver"Редактор объектов", "[0] Создать объект\n[1] Редактировать объекты\n[2] Для разработчика","Выбрать","Отмена");
	return 1;
}
CMD:netstats(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "u", params[0])) SendClientMessage(playerid, COLOR_WHITE, !"Введите: /netstats [ID/Nick]");
	else if (params[0] == INVALID_PLAYER_ID) SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден!");
	else
	{
		t_string[0] = EOS;
		GetPlayerNetworkStats(params[0], t_string, sizeof t_string);
		ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, pInfo[params[0]][pName], t_string, "Закрыть", "");
	}
	return 1;
} 
alias:netstats("plrnt");
CMD:setleader(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "u",params[0])) {
		/*new str_[128], string_[64];
	 	t_string[0] = EOS ;
	 	strcat(t_string, ""colserver"[№] Организация\t"colserver"Лидер\t"colserver"Заместитель\n");
	 	for(new i = 1; i <= TOTAL_FRACTION; i++)
		{
			format(str_, sizeof str_,""colwhi"[%d] %s\t%s\t%s\n", i, fInfo[i][fName], fInfo[i][fLeader], fInfo[i][fAssistant]);
			strcat(t_string, str_);
		}
		SetPVarInt(playerid, #SelectLeaderID, params[0]);
		format(string_, sizeof string_, ""colserver"Назначить лидера организации: "colwhi"%s", pInfo[params[0]][pName]);
		ShowPlayerDialog(playerid, D_FRACTION_FUNC_0, DIALOG_STYLE_TABLIST_HEADERS, string_, t_string, "Выбрать", "Закрыть");*/
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setleader [playerid]");
		return 1;
	}
    if (!IsPlayerConnected(params[0])) return 1;
	if (IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не должен находиться в транспорте!");
	if (pInfo[params[0]][pLeader] > 0)
	{
		SaveFractionString(pInfo[params[0]][pLeader], "fLeader", "None");
		strmid(fInfo[pInfo[params[0]][pLeader]][fLeader],"None",0,strlen("None"),MAX_PLAYER_NAME);
	    if (pInfo[params[0]][pLeader] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не находиться в организации!");
	    uninvite_player(params[0]);
		SendMes(params[0], COLOR_WHITE, "Администратор "colserver"%s "colwhi"снял с вас контроль организации", pInfo[playerid][pName]);
		if (pTemp[params[0]][tDutyWork] == 1) SendClientMessage(params[0], 0x6BB3FFAA, !"Рабочий день окончен");
		SendMes(playerid, COLOR_WHITE, "Вы сняли с "colserver"%s "colwhi"контроль организации.", pInfo[params[0]][pName]);

		if (IsANews(params[0]))
		{
			new
				query[ 78 ]; 
			mysql_format(dbHandle, query, sizeof query, "UPDATE s_users SET edited_ads = '0' WHERE Name = '%e'", pInfo[params[0]][pName]);
			mysql_tquery(dbHandle, query);
		}
	}
	else
	{
   		if (pInfo[params[0]][pLeader] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок лидер другой организации!");
		if (pInfo[params[0]][pMember] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок находиться в другой организации!");
		
	 	new str_[128], string_[64];
	 	t_string[0] = EOS ;
	 	strcat(t_string, ""colserver"[№] Организация\t"colserver"Лидер\t"colserver"Заместитель\n");
	 	for(new i = 1; i <= TOTAL_FRACTION; i++)
		{
			format(str_, sizeof str_,""colwhi"[%d] %s\t%s\t%s\n", i, fInfo[i][fName], fInfo[i][fLeader], fInfo[i][fAssistant]);
			strcat(t_string, str_);
		}
		SetPVarInt(playerid, #SelectLeaderID, params[0]);
		format(string_, sizeof string_, ""colserver"Назначить лидера организации: "colwhi"%s", pInfo[params[0]][pName]);
		ShowPlayerDialog(playerid, D_FRACTION_FUNC_0, DIALOG_STYLE_TABLIST_HEADERS, string_, t_string, "Выбрать", "Закрыть");
	}
	return 1;
}
alias:setleader("makeleader");

CMD:atune(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы не за рулем");
	return ShowPlayerDialog(playerid, D_ADMIN_FUNC_18, 2, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы \nАзот", "Выбрать", "Назад");
}

CMD:templeader(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) 
		return true;
	
	if (IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, "Вы не должны находиться в транспорте!");
	
	new fractionIndex;

	if (sscanf(params, "d", fractionIndex))
	{
		return ShowPlayerDialog(playerid, D_TEMPLEADER, DIALOG_STYLE_LIST, "Фракции", "\
			0. Уволиться\n\
			1. LSPD\n\
			2. FBI\n\
			3. Army SF\n\
			4. Hospital SF\n\
			5. LCN\n\
			6. Yakuza\n\
			7. Mayor\n\
			8. SF News\n\
			9. SFPD\n\
			10. Auto School\n\
			11. Ballas Gang\n\
			12. Vagos Gang\n\
			13. Russian Mafia\n\
			14. Grove Gang\n\
			15. LS News\n\
			16. Aztecas Gang\n\
			17. Rifa Gang\n\
			18. Army LV\n\
			19. LV News\n\
			20. LVPD\n\
			21. Hospital LS\n\
			22. Hospital LV\n\
			23. Mongols MC\n\
			24. Bandidos MC\n\
			25. Outlaws MC\n\
			", "Выбрать", "Отмена");
	}//Bandidos

	if (fractionIndex < 0 || fractionIndex > TOTAL_FRACTION) 
		return SendClientMessage(playerid, COLOR_GREY, "Фракция не обнаружена.");
	
	if (fractionIndex == 0) {
		SendClientMessage(playerid, 0x66cc00AA, "Временная лидерка снята");
		uninvite_player(playerid);

		return 1;
	}
	else if (pInfo[playerid][pMember] != 0 ){
		uninvite_player(playerid);
	}

	//new string_[144];

	pInfo[playerid][pMember] = fractionIndex;
	pInfo[playerid][pRank] = gFracionCountRank[fractionIndex - 1];
	pInfo[playerid][PlayerSpawn] = 2;
	pTemp[playerid][tDutyWork] = 1;
	pInfo[playerid][pModel] = gFractionSkin[fractionIndex - 1][0];
	
	invite_team(playerid, pInfo[playerid][pMember]);
	/*format(string_, sizeof string_, "[A] %s[%d] назначил(а) себя врем. лидером  \"%s\"",  pInfo[playerid][pName], playerid, fInfo[pInfo[playerid][pMember]][fName]);
	
	SendAdminMessage(COLOR_GREY, string_);*/
	SendClientMessage(playerid, COLOR_LIME, "Чтобы быстро телепортироваться на спавн введите команду \"/spawn\"");
	
	return 1;
}
/* 6 LEVEL */ 
CMD:dmats(playerid)
{
	if (!pInfo[playerid][pLogin] || pInfo[playerid][pAdmin] < 6) return 1;
	StartDeliveryMats();
	return 1;
}

CMD:setcasinoowner(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pInfo[playerid][pAdmin] < 8) return 1;
    if (sscanf(params, "dd",params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !" Введите: /setcasinoowner [id мафии] (6 - Yakuza | 5 - LCN | 14 - Russian Mafia) [id казино]");
    if (params[1] > TOTALCASINO) return SendClientMessage(playerid, COLOR_GREY, !"Неверный ID CASINO");
	if (params[0] != 6 && params[0] < 0 && params[0] != 5 && params[0] != 14) return SendClientMessage(playerid, COLOR_GREY, !"Неверный ид Mafii");
    CasinoInfo[params[1]][caMafia] = params[0];
	new 
		mafiaName[16],
		string_[128];
	switch(CasinoInfo[params[1]][caMafia]) {
		case INVALID_FRACTION_ID: mafiaName = "Свободна";
		case FRACTION_LCN: mafiaName = "LCN";
		case FRACTION_YAKUZA: mafiaName = "Yakuza";
		case FRACTION_RUSSIAN: mafiaName = "Русская Мафия";
	}
	format(string_, sizeof string_, ""colwhi"Казино:  "C_PODS"%s\n"colwhi"Управляет:  "C_PODS"%s", CasinoInfo[params[1]][caName], mafiaName);
	UpdateDynamic3DTextLabelText(CasinoInfo[params[1]][cLabel], 0xFFFFFFFF, string_);
	string_[0] = EOS; 
    format(string_, sizeof string_,"UPDATE `casino` SET `Mafia`= '%d' WHERE ID = '%d' LIMIT 1", CasinoInfo[params[1]][caMafia], CasinoInfo[params[1]][caID]);
    mysql_tquery(dbHandle, string_, "", "");
    return SendClientMessage(playerid,COLOR_WHITE, !"Успешно! (/cinfo)");
} 
CMD:bizprod(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) 
		return true;
	new prod;
	if (sscanf(params, "d", prod)){
	    return SendClientMessage(playerid, COLOR_GREY, !"Команда: /bizprod [products]");
	}
    for(new b = 0; b < sizeof (BusinessInfo); b++) {
		if (!IsValidBusiness(b)) 
			continue;
		if (PlayerToPoint(3.0, playerid, BusinessInfo[b][bPos][0], BusinessInfo[b][bPos][1], BusinessInfo[b][bPos][2])) {
		    BusinessInfo[b][bProducts] += prod;
			if (BusinessInfo[b][bProducts] < 0) BusinessInfo[b][bProducts] = 0;
			else if (BusinessInfo[b][bProducts] > BUSINESS_MAX_PRODUCTS) BusinessInfo[b][bProducts] = BUSINESS_MAX_PRODUCTS; 
			
			format(t_string, sizeof (t_string), "bProducts = %i", BusinessInfo[b][bProducts]);
			SaveBusiness(b, t_string);

		    format(t_string, sizeof (t_string), "Вы пополнили бизнес на %i продуктов (теперь: %i ед.)", 
				prod, BusinessInfo[b][bProducts]
			);
			SendClientMessage(playerid, -1, t_string);
			return true;
		}
	}
	return true;

}
CMD:mafiarebiz(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) 
		return true;
	new mafia;
	if (sscanf(params, "d", mafia)){
	    SendClientMessage(playerid, COLOR_GREY, !"Команда: /mafiarebiz [mafiaid]");
	    return SendClientMessage(playerid, COLOR_GREY, !"LCN - 5ID | Yakuza = 6ID | RM - 14ID");
	}
	if (mafia != 5 && mafia != 6 && mafia != 14) { 
		return SendClientMessage(playerid, COLOR_GREY, !"LCN - 5ID | Yakuza = 6ID | RM - 14ID");
	}
	new biz = -1;
    for(new b = 0; b < sizeof (BusinessInfo); b++) {
		if (!IsValidBusiness(b)) 
			continue;
		if (IsPlayerInRangeOfPoint(playerid, 4.2,  BusinessInfo[b][bPos][0], BusinessInfo[b][bPos][1], BusinessInfo[b][bPos][2])){
			biz = b;
			break;
		}
	}
	if (biz == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы не у бизнеса");
	new string_[128];
	BusinessInfo[biz][bMafia] = mafia;
			
	format(string_, sizeof (string_), "bMafia = %i", mafia);
	SaveBusiness(biz, string_);

	format(string_, sizeof string_, "Вы передали бизнес ID %d мафии: %s", 
		biz, mafia == 5 ? ("LCN"): mafia == 6 ? ("Yakuza") : ("RM")
	);
	SendClientMessage(playerid, -1, string_);
	UpdateBusiness(biz);
   	return true;
}
alias:mafiarebiz("setbiz");
CMD:gzcolor(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "d",params[0])) return SendClientMessage(playerid,-1, !"Введите: /gzcolor [банда]");
    new i = GetPlayerGangZone(playerid),
		temp[64];
	GZInfo[i][gFrakVlad] = params[0];
	GangZoneStopFlashForAll(GZInfo[i][gZone]);
	SaveGangZone(i);
	format(temp, sizeof temp, "[S] %s[%d] перекрасил ганг зону %d.",pInfo[playerid][pName],playerid, GZInfo[i][gID]);
	ABroadCast(COLOR_YELLOW, temp, 1);
	return 1;
}
CMD:agiverank(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "ud",params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /agiverank [playerid] [ранг от 1 до 15]");
    if (pInfo[params[0]][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не состоите в организации");
	if (params[1] > gFracionCountRank[ pInfo[params[0]][pMember] - 1] || params[1] < 0) return SendMes(playerid, COLOR_GREY, !"Не менее 0 и не более %d! рангов", gFracionCountRank[ pInfo[params[0]][pMember] - 1]);
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	pInfo[params[0]][pRank] = params[1]; 
    SavePlayerInteger(params[0], "pRank", pInfo[params[0]][pRank]);
	new 
        string_[128];  
	format(string_, sizeof string_, "Вы были повышены/понижены в ранге модератором %s",pInfo[playerid][pName]);
	SendClientMessage(params[0], 0x6495EDFF, string_);
	format(string_, sizeof string_, "Вы повысили/понизили %s до %d ранга.",pInfo[params[0]][pName],params[1]);
	SendClientMessage(playerid, 0x6495EDFF, string_);
	return 1;
}
CMD:amusic(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new nonf;
	if (sscanf(params, "f",nonf)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /amusic [радиус 1 - 300 или 0 - выключить] [ссылка]");
	if (nonf == 0)
	{
		ServerSounds = false;
		foreach(new i: PlayerInLogin)
		{
			StopAudioStreamForPlayer(i); // Stop the audio stream
			pTemp[i][UseSound] = false;
		}
		return SendClientMessage(playerid, 0xFF0000AA, "Музыка отключена");
	}
	new path[150];
	if (sscanf(params, "ds[150]",params[0],path)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /amusic [радиус 1 - 300 или 0 - выключить] [ссылка]");
	if (params[0] < 1 || params[0] > 300) return SendClientMessage(playerid, COLOR_GREY, !"От 1 до 300");
	format(stream, sizeof(stream),"%s",path);
	rads = params[0];
	ServerSounds = true;
	new Float:x1,Float:y1,Float:z1;
	GetPlayerPos(playerid,x1,y1,z1);
	streampos[0] = x1;
	streampos[1] = y1;
	streampos[2] = z1;
	foreach(new i: PlayerInLogin)
	{
		pTemp[i][UseSound] = false;
	}
	SendClientMessage(playerid, COLOR_GREEN, "Музыка включена"); //http://radiopotok.ru/f/m3u/station_4.m3u
	return 1;
}

CMD:setadmin(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 9 || !pTemp[playerid][PlayerADostup]) return 1;
	new
		name[32],
		query_[256],
		string_[80];
	if (sscanf(params, "s[32]d", name, params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setadmin [ник] [уровень модератора]");

	if (strlen(name) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");

	if ((params[1] > 7 || params[1] < 0) && pInfo[playerid][pAdmin] < 10) return SendClientMessage(playerid, COLOR_GREY, !"Вы допустили ошибку"); 
	else if ((params[1] > 10 || params[1] < 0) && pInfo[playerid][pAdmin] > 9) return SendClientMessage(playerid, COLOR_GREY, !"Вы допустили ошибку");
	else if pInfo[playerid][pAdmin] < pInfo[params[1]][pAdmin] *then return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать на администратора, который старше вас!");

	format(query_, sizeof query_, "SELECT * FROM s_admin WHERE Name = '%s'", name);
	new Cache:result = mysql_query(dbHandle, query_);
	if (cache_num_rows()) {//АДМИН найден
		/* LEVEL UP / DOWN */ 
		if (params[1] == 0)
		{
			/*if (!strcmp(name, "Devil_Deaths") || !strcmp(name,"Devil_Deaths")) {
				SendClientMessage(playerid, COLOR_REDD, !"Конечно, что еще?");
				cache_delete(result);
				return 1;
			}*/
			format(query_, sizeof query_, "DELETE FROM `s_admin` WHERE `Name`= '%s' LIMIT 1", name);
			mysql_tquery(dbHandle, query_, "", "");
			new select_id;
			sscanf(name, "u", select_id);
			if (IsPlayerConnected(select_id))
			{
				pInfo[select_id][pAdmin] = 0;
				pTemp[select_id][PlayerADostup] = false;
				aAdminInfo[select_id][aID] 		=
				aAdminInfo[select_id][aReport] 	=
				aAdminInfo[select_id][aRepute] 	=
				aAdminInfo[select_id][aJail] 	=
				aAdminInfo[select_id][aMute] 	=
				aAdminInfo[select_id][aPrison] 	=
				aAdminInfo[select_id][aWarn] 	=
				aAdminInfo[select_id][aBan] 	=
				aAdminInfo[select_id][aRegIP] 	= 0;
				Iter_Remove(AdminsTeam, select_id);
				Kick(select_id);  
			}
		}
		else
		{
			mysql_format(dbHandle, query_, sizeof query_, "UPDATE `s_admin` SET  level = '%d' WHERE Name = '%s' LIMIT 1", params[1], name);
			mysql_tquery(dbHandle, query_, "", "");
			new select_id;
			sscanf(name, "u", select_id);
			if (IsPlayerConnected(select_id)) {
				pInfo[select_id][pAdmin] = params[1];
			}
		}
	}
	else { 
		new 
			select_id,
			player_ip[16];
		select_id = getPlayerIdByNickname(name);
		if (PlayerInConnected(select_id)) { 
			GetPlayerIp(select_id, player_ip, sizeof player_ip);
			SendClientMessage(select_id, COLOR_LIGHTBLUE, "Теперь Вы администратор!");
		} else player_ip = "0.0.0.0";  
		mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO `s_admin` (Name, level, LastCon, IP, LastIP) VALUES ('%s', '%d', '%d', '%s', '%s')",
			name, params[1], gettime(), player_ip, player_ip
		);
		mysql_tquery(dbHandle, query_, "", "");
		
	}
	cache_delete(result);
	format(string_, sizeof string_, "Вы установили %s %d уровень администрирования", name, params[1]);
	SendClientMessage(playerid, 0x6495EDFF, string_); 
	return 1;
}


CMD:asellhouse(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_GRAD1, !"Введите: /asellhouse [houseid]");
	if (params[0] < 1 || params[0] > TOTALHOUSE) return SendClientMessage(playerid, COLOR_GREY, !"Error ID House");
	if (strcmp(HouseInfo[params[0]][hOwner],"None",true) == 0) return SendClientMessage(playerid, COLOR_GREY, !"У дома нет владельца");
	new 
		player_,
		query_[128];
	sscanf(HouseInfo[params[0]][hOwner], "u", player_);
	if (IsPlayerConnected(player_)) {
		pInfo[player_][pHouseID] = -1;
		SendClientMessage(player_, COLOR_RED, !"Ваш дом был продан администратором");
	} else {
		format(query_, sizeof query_, "UPDATE `s_users` SET `playerspawn` = '0', `pHouseID` = '-1' WHERE `Name` = '%d'", HouseInfo[params[0]][hOwner]);
		mysql_tquery(dbHandle, query_);
	}
	HouseInfo[params[0]][hLock] = 1;
	
	format(query_, sizeof(query_), "UPDATE `house` SET `hLock`= '%d' WHERE `hID` = '%d'", HouseInfo[params[0]][hLock], HouseInfo[params[0]][hID]);
	mysql_tquery(dbHandle, query_, "", "");
	//for(new h = 0; h < 10; h++) HouseInfo[params[0]][hSafe][h] = 0;
    if (HouseInfo[params[0]][hValue] == 0) {
		HouseInfo[params[0]][hValue] = HouseInfo[params[0]][hReturnValue];
	}
	strmid(HouseInfo[params[0]][hOwner],"None", 0, strlen("None"), MAX_PLAYER_NAME);
	HouseInfo[params[0]][hTakings] = 0;
	HouseInfo[params[0]][hLock] = 1; 
	SendClientMessage(playerid, COLOR_GREY, !"Дом продан"); 
	UpdateHouseInfo(params[0], false);
	SaveHouseID(params[0]);
	CheckEvictFree(params[0]); 
	CheckFamilyHouseFree(params[0]);
	return 1;
}

CMD:astats(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "s[32]", params[0])) return SendClientMessage(playerid, COLOR_GRAD1, !"Введите: /astats [nickname]");
	new
	    query_[128];
    format(query_, sizeof query_, "SELECT * FROM `s_admin` WHERE `Name` = '%s'", params[0]);
	return mysql_tquery(dbHandle, query_, "ShowAdminStats", "ds", playerid, params[0]);
}
publics: ShowAdminStats(playerid, name[])
{
	new
	    rows;
    cache_get_row_count(rows);
    if (rows)
	{
        new
            sBans,
            sWarns,
            sReports,
            sOTime,
			sMutes,
			sReputes;
        cache_get_value_name_int(0, "s_Bans", 		sBans);
        cache_get_value_name_int(0, "s_Warns", 		sWarns);
        cache_get_value_name_int(0, "s_Reports", 	sReports);
        cache_get_value_name_int(0, "s_OTime", 		sOTime);
		cache_get_value_name_int(0, "s_Mutes", 		sMutes);
		cache_get_value_name_int(0, "s_Reputes", 	sReputes);
	    foreach(new i: PlayerInLogin)
		{
			if (strfind(pInfo[i][pName], name, true) != -1)
			{
				sOTime += pTemp[i][TimeNoAFK];
                //sReports += GetPVarInt(i, #a_Reports);
				break;
			}
		}
		t_string[0] = EOS;
        format(t_string, sizeof t_string, "{FFFFFF}Статистика администратора {6BB3FF}%s{FFFFFF}:\n\
			#Количество банов: {6BB3FF}%d{FFFFFF}\n\
			#Количество варнов: {6BB3FF}%d{FFFFFF}\n\
			#Количество мутов: {6BB3FF}%d{FFFFFF}\n\
			#Количество репортов: {6BB3FF}%d{FFFFFF}\n\
			#Количество репутации: {6BB3FF}%d{FFFFFF}\n\
			\nЗа неделю:\n\
			#Время под админкой: {6BB3FF}%s{FFFFFF}", name, sBans, sWarns, sMutes, sReports, sReputes, Convert(sOTime));
		return ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Статистика: "colwhi"Администратора", t_string, "Закрыть", "");
	}
    else return SendClientMessage(playerid, COLOR_GREY, !"Администратор под данным ником не найден!");
}
/* 7 LEVEL */

CMD:setskill(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "udd",params[0],params[1],params[2]))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "Введите: /setskill [playerid/часть ника] [номер] [количество]");
		SendClientMessage(playerid, COLOR_GRAD4, "[0] SD Pistol |[1] Desert Eagle |[2] ShotGun |[3] MP5 |[4] AK47 |[5] M4A1 | [6] Full Skill");
		return 1;
	}
	if (!IsPlayerConnected(params[0])) return 1;
	switch (params[1]) {
		case 0 .. 5: {
			pInfo[params[0]][pGunSkill][params[1]] = params[2]; 
		}
		case 6: {
			pInfo[params[0]][pGunSkill][0] =
			pInfo[params[0]][pGunSkill][1] =
			pInfo[params[0]][pGunSkill][2] =
			pInfo[params[0]][pGunSkill][3] =
			pInfo[params[0]][pGunSkill][4] =
			pInfo[params[0]][pGunSkill][5] = 100; 
		}
		default: {
			SendClientMessage(playerid, COLOR_GREY, !"Указанно не верное значение");
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, !"Уровень владения оружием игроку установлен");
	SetPlayerSkills(params[0]);
	return 1;
}
CMD:delaccount(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "s[32]",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /delaccount [name]");
	if (0 == CheckBanedNickName(playerid, params[0])) return 1; 
	new query_[128];
	mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_users` WHERE `Name` = '%e'",params[0]);
 	mysql_tquery(dbHandle, query_, "DellAccount", "ds",playerid, params[0]);
	return 1;
}

alias:delaccount("delacc");

publics: DellAccount(playerid, stringg[])
{
    new
		rows,
		null = 0;
    new query_[256];
	cache_get_row_count(rows);
	if (!rows) return SendClientMessage(playerid, COLOR_GREY, !"Аккаунт не найден в базе данных");
	 
	for(new i = 1; i <= TOTALHOUSE;i++) {
		if (strcmp(HouseInfo[i][hOwner],stringg,false) == 0 && strcmp(HouseInfo[i][hOwner],"None",true) != 0) {
			null = i;
		}
	}
	if (null != 0) {
	    HouseInfo[null][hTakings] = 0;
		strmid(HouseInfo[null][hOwner], "None", 0, strlen("None"), MAX_PLAYER_NAME);
		UpdateHouseInfo(null);
		SaveHouseID(null);
	}
	#if defined _businesses_inc
	for (new i = 0, id; i < MAX_PLAYER_BUSINESS; i++) {
		if (!pInfo[null][pBusinessID][i]) 
			continue;
		id = pInfo[null][pBusinessID][i] - 1;
		ClearBusiness(id);
		printf("[businesses] Бизнес #%i был продан из-за удаление (%s)!", BusinessInfo[id][bID], pInfo[null][pName]);
	}
	#endif
	null = 0; 
	for(new i = 1; i <= TOTALFARM; i++) if (strcmp(FarmInfo[i][fOwner],stringg,false) == 0) null = i;
	if (null != 0)
	{
	    strmid(FarmInfo[null][fOwner], "None", 0, strlen("None"), MAX_PLAYER_NAME);
		strmid(FarmInfo[null][fDeputy_1], "None", 0, strlen("None"), MAX_PLAYER_NAME);
		strmid(FarmInfo[null][fDeputy_2], "None", 0, strlen("None"), MAX_PLAYER_NAME);
		strmid(FarmInfo[null][fDeputy_3], "None", 0, strlen("None"), MAX_PLAYER_NAME);
		SaveFermIDFarmers(null);
		FarmInfo[null][fAuction][0] = 0;
		FarmInfo[null][fAuction][1] = 0;
		FarmInfo[null][fAuction][2] = 0;
		FarmInfo[null][fAuction][3] = 0;
		FarmInfo[null][fLandTax] = 0;
		FarmInfo[null][fBank] = 0;
		FarmInfo[null][fProds] = 0;
		FarmInfo[null][fZp] = 30;
		FarmInfo[null][fGrain_Price] = 5;
		FarmInfo[null][fGrain] = 0;
		FarmInfo[null][fGrain_Sown] = 0;
		FarmInfo[null][fProds_Selling] = 1;
		FarmInfo[null][fProds_Price] = 21;
		SaveFermID(null);
	} 
	format(query_, sizeof query_, "Аккаунт %s был удален из базы данных!", stringg);
	SendClientMessage(playerid, COLOR_LIGHTRED, query_); 
	mysql_format(dbHandle, query_, sizeof query_, "DELETE FROM `s_admin` WHERE Name = '%s'",stringg);
 	mysql_tquery(dbHandle, query_); 
	mysql_format(dbHandle, query_, sizeof query_, "DELETE FROM `s_users` WHERE Name = '%s'",stringg);
	mysql_tquery(dbHandle, query_); 
	return 1;
}
 
CMD:getschet(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /getschet [дом]");
	if (params[0] < 1 || params[0] > TOTALHOUSE) return SendClientMessage(playerid, COLOR_GREY, !"Error ID House");
	new string_[32];
	format(string_, sizeof(string_), "Счёт домашний: %d",HouseInfo[params[0]][hTakings]);
	SendClientMessage(playerid, COLOR_WHITE, string_);
	return 1;
}
CMD:setschet(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setschet [дом] [счет]");
	HouseInfo[params[0]][hTakings] = params[1];
	SaveHouseID(params[0]);
	SendClientMessage(playerid, COLOR_WHITE, !"Домашний счет установлен");
	return 1;
}
CMD:setcost(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setscost [дом] [цена]");
	if (params[0] < 1 || params[0] > TOTALHOUSE) return SendClientMessage(playerid, COLOR_GREY, !"Error ID House");
	HouseInfo[params[0]][hValue] = params[1];
	new query_[128];
 	mysql_format(dbHandle, query_, sizeof(query_), "UPDATE `house` SET `hValue`= '%d' WHERE `hID` = '%d' LIMIT 1", HouseInfo[params[0]][hValue], HouseInfo[params[0]][hID]);
 	mysql_tquery(dbHandle, query_, "", "");
	SendClientMessage(playerid, COLOR_WHITE, !"Стоимость установлена");
	return 1;
}
CMD:sethousecarpos(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sethousecarpos [дом]");
	new Float: lwx, Float:lwy, Float:lwz,Float:lwa, query_[200];
	GetPlayerPos(playerid, lwx, lwy, lwz);
	GetPlayerFacingAngle(playerid,lwa);
	HouseInfo[params[0]][hCar][0] = lwx;
	HouseInfo[params[0]][hCar][1] = lwy;
	HouseInfo[params[0]][hCar][2] = lwz;
	HouseInfo[params[0]][hCar][3] = lwa;
	mysql_format(dbHandle, query_, sizeof query_, "UPDATE `house` SET `hCarx` = '%f',`hCary` = '%f',`hCarz` = '%f',`hCarc` = '%f' WHERE `hID` = '%d' LIMIT 1",
	lwx, lwy, lwz, lwa, params[0]);
	mysql_tquery(dbHandle, query_, "", "");
	SendClientMessage(playerid, COLOR_GREY, !"Координаты машины установлены");
	return 1;
}
CMD:setklass(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setklass [дом] [класс]");
	if (params[0] < 1 || params[0] > TOTALHOUSE) return SendClientMessage(playerid, COLOR_GREY, !"Error ID House");
	HouseInfo[params[0]][hKlass] = params[1];
	if (HouseInfo[params[0]][hKlass] == 0) HouseInfo[params[0]][hIntID] = 1;
	else if (HouseInfo[params[0]][hKlass] == 1) HouseInfo[params[0]][hIntID] = 5;
	else if (HouseInfo[params[0]][hKlass] == 2) HouseInfo[params[0]][hIntID] = 15;
	else if (HouseInfo[params[0]][hKlass] == 3) HouseInfo[params[0]][hIntID] = 22;
 	else if (HouseInfo[params[0]][hKlass] == 4) HouseInfo[params[0]][hIntID] = 27;
 	else HouseInfo[params[0]][hIntID] = 34;
	SaveHouseID(params[0]);
	SendClientMessage(playerid, COLOR_WHITE, !"Класс установлен");
	return 1;
}

CMD:setmoneyf(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setmoneyf [номер] [количество]"); 
	new string_[64];
	switch(params[0])
	{
	    case 5:
		{
			FractionInfo[5][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[5][fID]);
			UpdateFractionStore(FRACTION_LCN);
			format(string_, sizeof(string_), "Материалы LCN изменены на: %d", params[1]);
		}
		case 6:
		{
			FractionInfo[6][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[6][fID]);
			UpdateFractionStore(FRACTION_YAKUZA);
			format(string_, sizeof(string_), "Материалы Yakuza изменены на: %d", params[1]);
		}
		case 7:
		{
			FractionInfo[7][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[7][fID]);
			UpdateFractionStore(FRACTION_CITYHALL);
			format(string_, sizeof(string_), "Материалы Мэрия изменены на: %d", params[1]);
		}
		case 12:
		{
			FractionInfo[12][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[12][fID]);
			format(string_, sizeof(string_), "Материалы Ballas изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_BALLAS);
		}
		case 13:
		{
			FractionInfo[13][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[13][fID]);
			UpdateFractionStore(FRACTION_VAGOS);
			format(string_, sizeof(string_), "Материалы Vagos изменены на: %d", params[1]);
		}
		case 14:
		{
			FractionInfo[14][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[14][fID]);
			UpdateFractionStore(FRACTION_RUSSIAN);
			format(string_, sizeof(string_), "Материалы RM изменены на: %d", params[1]);
		}
		case 15:
		{
			FractionInfo[15][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[15][fID]);
			UpdateFractionStore(FRACTION_GROVE);
			format(string_, sizeof(string_), "Материалы Groove изменены на: %d", params[1]);
		}
		case 17:
		{
			FractionInfo[17][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[17][fID]);
			UpdateFractionStore(FRACTION_AZTEC);
			format(string_, sizeof(string_), "Материалы Aztecas изменены на: %d", params[1]);
		}
		case 18:
		{
			FractionInfo[18][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[18][fID]);
			UpdateFractionStore(FRACTION_RIFA);
			format(string_, sizeof(string_), "Материалы Rifa изменены на: %d", params[1]);
		}
		case 24:
		{
			FractionInfo[FRACTION_MONGOLS_MC][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[FRACTION_MONGOLS_MC][fID]);
			UpdateFractionStore(FRACTION_MONGOLS_MC);
			format(string_, sizeof(string_), "Материалы FRACTION_MONGOLS_MC изменены на: %d", params[1]);
		}
		case 25:
		{
			FractionInfo[FRACTION_BANDIDOS_MC][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[FRACTION_BANDIDOS_MC][fID]);
			UpdateFractionStore(FRACTION_BANDIDOS_MC);
			format(string_, sizeof(string_), "Материалы FRACTION_BANDIDOS_MC изменены на: %d", params[1]);
		}
		case 26:
		{
			FractionInfo[FRACTION_OUTLAWS_MC][fMoney] = params[1];
			SaveFractionInfoID(FractionInfo[FRACTION_OUTLAWS_MC][fID]);
			UpdateFractionStore(FRACTION_OUTLAWS_MC);
			format(string_, sizeof(string_), "Материалы FRACTION_OUTLAWS_MC изменены на: %d", params[1]);
		}
		default: format(string_, sizeof(string_), "[Ошибка]");
	}
	SendClientMessage(playerid, COLOR_GRAD1, string_);
	return 1;
}
CMD:setfpoint(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd", params[0],params[1]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setfpoint [ID Fraction] [количество]");
		SendClientMessage(playerid, COLOR_WHITE, !" [12] - Ballas, [13] - Vagos, [15] - Groove, [17] - Aztecas, [18] - Rifa"); 
		return 1;
	}
	switch (params[0])
	{
		case 12, 13, 15, 17, 18: {
			GiveFractionPointsAdmin(params[0], params[1], true); 
		}
		default: {
			SendClientMessage(playerid, COLOR_GREY, !"Значение указанно не верно!"); 
		}
	}
	return 1;
	
}
alias:setmats("setmat");
CMD:setmats(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd", params[0],params[1]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setmats [номер] [количество]");
		SendClientMessage(playerid, COLOR_WHITE, !" [1] - LSPD, [2] - FBI, [3] - SFA, [4] - Yakuza, [5] - LCN, [6] - SFPD, [7] - Ballas, [8] - Vagos");
		SendClientMessage(playerid, COLOR_WHITE, !" [9] - RM, [10] - Groove, [11] - Aztecas, [12] - Rifa, [13] - Army LV, [14] - LVPD, [15] -  LSA");
		SendClientMessage(playerid, COLOR_WHITE, !" [16] - Mayor, [17] - Mongols, [18] - Bandidos, [19] - Outlaws");
		return 1;
	}
	new string_[64];
	switch (params[0])
	{
		case 1: {
			FractionInfo[1][fMaterials] = params[1];
			UpdateFractionStore(FRACTION_LSPD);
			SaveFractionInfoID(FractionInfo[1][fID]);
			format(string_, sizeof(string_), "Материалы LSPD изменены на: %d", params[1]);
		}
		case 2: {
			FractionInfo[2][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[2][fID]);
			format(string_, sizeof(string_), "Материалы FBI изменены на: %d", params[1]);
		}
		case 3: {
			FractionInfo[3][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[3][fID]);
			format(string_, sizeof(string_), "Материалы SFA изменены на: %d", params[1]);
		}
		case 4: {
			FractionInfo[6][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[6][fID]);
			format(string_, sizeof(string_), "Материалы Yakuza изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_YAKUZA);
		}
		case 5: {
			FractionInfo[5][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[5][fID]);
			format(string_, sizeof(string_), "Материалы LCN изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_LCN);
		}
		case 6: {
			FractionInfo[10][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[10][fID]);
			format(string_, sizeof(string_), "Материалы SFPD изменены на: %d", params[1]);
		}
		case 7: {
			FractionInfo[12][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[12][fID]);
			format(string_, sizeof(string_), "Материалы Ballas изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_BALLAS);
		}
		case 8: {
			FractionInfo[13][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[13][fID]);
			format(string_, sizeof(string_), "Материалы Vagos изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_VAGOS);
		}
		case 9: {
			FractionInfo[14][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[14][fID]);
			format(string_, sizeof(string_), "Материалы RM изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_RUSSIAN);
		}
		case 10: {
			FractionInfo[15][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[15][fID]);
			format(string_, sizeof(string_), "Материалы Groove изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_GROVE);
		}
		case 11: {
			FractionInfo[17][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[17][fID]);
			format(string_, sizeof(string_), "Материалы Aztecas изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_AZTEC);
		}
		case 12: {
			FractionInfo[18][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[18][fID]);
			format(string_, sizeof(string_), "Материалы Rifa изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_RIFA);
		}
		case 13: {
			FractionInfo[19][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[19][fID]);
			format(string_, sizeof(string_), "Материалы LVA изменены на: %d", params[1]);
		}
		case 14: {
			FractionInfo[21][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[21][fID]);
			format(string_, sizeof(string_), "Материалы LVPD изменены на: %d", params[1]);
		}
		case 15: {
			lsamatbi = params[1];
			format(string_, sizeof(string_), "Материалы LSA изменены на: %d", params[1]);
			new t_query[64];
			format(t_query, sizeof(t_query),"UPDATE `s_others` SET `mats_lsa`= '%d'", lsamatbi);
			mysql_tquery(dbHandle, t_query, "", "");//hellowen_sorry
		}
		case 16: {
			FractionInfo[FRACTION_CITYHALL][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[FRACTION_CITYHALL][fID]);
			format(string_, sizeof(string_), "Материалы FRACTION_CITYHALL изменены на: %d", params[1]);
		}
		case 17: {
			FractionInfo[FRACTION_MONGOLS_MC][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[FRACTION_MONGOLS_MC][fID]);
			format(string_, sizeof(string_), "Материалы FRACTION_MONGOLS_MC изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_MONGOLS_MC);
		}//
		case 18: {
			FractionInfo[FRACTION_BANDIDOS_MC][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[FRACTION_BANDIDOS_MC][fID]);
			format(string_, sizeof(string_), "Материалы FRACTION_BANDIDOS_MC изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_BANDIDOS_MC);
		}
		case 19: {
			FractionInfo[FRACTION_OUTLAWS_MC][fMaterials] = params[1];
			SaveFractionInfoID(FractionInfo[FRACTION_OUTLAWS_MC][fID]);
			format(string_, sizeof(string_), "Материалы FRACTION_OUTLAWS_MC изменены на: %d", params[1]);
			UpdateFractionStore(FRACTION_OUTLAWS_MC);
		}
		default: {
			format(string_, sizeof(string_), "[Ошибка]");
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, string_);
	return 1;
}

/* 8 LEVEL */

CMD:rasform(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new fraction, rangs;
	if (sscanf(params, "dd", fraction, rangs)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /rasform [id фракции] [ранг]");
	if (fraction < 0 || fraction> TOTAL_FRACTION) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /rasform [id фракции] [ранг]");

	new
		str[128];
	foreach(new i: PlayerInLogin)
	{
		if (!IsPlayerConnected(i)) continue;
		if (pInfo[i][pMember] == fraction)
		{
			if (pInfo[i][pRank] == rangs) {
				uninvite_player(i);
				format(str, sizeof(str), "Администратор %s уволил Вас из организации "collime"\"%s\"",  pInfo[playerid][pName], fInfo[fraction][fName]);
				SendClientMessage(i, COLOR_ORANGE, str);
			}
			
		}
	}

	new query_[256];
	format(query_, sizeof (query_) , 
	"UPDATE `s_users` SET `pLeader` = '0', `pMember` = '0', `pRank` = '0', `pJob` = '0', `playerspawn` = '0' WHERE `pMember` = '%d' AND `pRank` = '%d'",fraction, rangs);
	mysql_tquery(dbHandle, query_, "", "");

	SaveFractionString(fraction, "fLeader", "None");
	strmid(fInfo[fraction][fLeader],"None",0,strlen("None"),MAX_PLAYER_NAME);

	format(str, sizeof str, "Admin: %s очистил организацию "collime"\"%s\"",  pInfo[playerid][pName], fInfo[fraction][fName]);
	ABroadCast(COLOR_YELLOW, str, 1);

	SetTimerEx("CheckLeaveMembers",2000,false,"iii",playerid,fraction,0);
	return 1;
}

publics: CheckLeaveMembers(playerid,fraction,type)
{
	if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (type == 0)
	{
		new query_[54];
		format(query_, sizeof (query_) , "SELECT `Name`  FROM `s_users` WHERE `pMember` = '%d'",fraction);
		mysql_tquery(dbHandle,query_, "CheckLeaveMembers","iii",playerid,fraction,1);
	}
	else
	{
		new rows,temp_str[60];
		cache_get_row_count(rows);
		if (!rows){
			format(temp_str,sizeof(temp_str),"[MySQL] Фракция %s полностью очищена.",fInfo[fraction][fName]);
			SendClientMessage(playerid,COLOR_YELLOW,temp_str);
		}
		else
		{
			new name[MAX_PLAYER_NAME];
			SendClientMessage(playerid,CGRAY2,"[MySQL] Следующие игроки остались во фракции:");
			for(new idx; idx < rows; idx++)
			{
				cache_get_value_name(idx, "Name", name,sizeof(name));
				format(temp_str,sizeof(temp_str),"%s",name);
				SendClientMessage(playerid,CGRAY2,temp_str);
			}
		}
	}
	return 1;
}
/*CMD:dellpack(playerid, params[])
{
    if (strcmp(pInfo[playerid][pName], "Devil_Deaths"))// основатель
	if (strcmp(pInfo[playerid][pName], "Devil_Deaths"))// менеджер
	if (strcmp(pInfo[playerid][pName], "==="))//Пиар менедежр
    if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[Подсказка] {FFFFFF}У вас нету доступа к этой команде");
	if (sscanf(params, "u",params[0])) return	SendClientMessage(playerid, COLOR_WHITE, !"Введите: /dellpack [ид]");
	if (!IsPlayerConnected(params[0])) return 1;
	
	pInfo[params[0]][pDrugs] = 50000;
	SavePlayerInteger(params[0], "pDrugs", pInfo[params[0]][pDrugs]);
	pInfo[params[0]][pMats] = 50000;
	SavePlayerInteger(params[0], "pMats", pInfo[params[0]][pMats]);
	
	new str_[100];
	format(str_, sizeof str_, "Вы Обнулили маты и нарко до 50к %s", pInfo[params[0]][pName]);
	SendClientMessage(playerid, COLOR_WHITE, str_);
	return 1;
} */
/* 9 LEVEL */
CMD:saveall(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10) return 1;
	SaveAccounts(); 
	SendClientMessage(playerid,COLOR_GRAD1, !"Все данные сохранены");
	LogingAdmins(playerid, pInfo[playerid][pName], "SaveAll", playerid,"/saveall");
	return 1;
}
CMD:edit(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10) return 1;
	ShowPlayerDialog(playerid, D_DEV_FUNC_4, DIALOG_STYLE_LIST, "Выберите действие", "[0] Продать все дома\n[1] Продать все бизнесы\n\
	[2] Установить дому интеръер\n[3] Распределить дома\n[4] Распределить цены на дома\n[5] test\n[6] Список бизнес интерьеров\n[7] Обновить все бизнесы\n[8] Поставить всем гаражи", "Выбрать", "Закрыть");
	return 1;
}
CMD:payday(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 9 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	PayDayTemp();
	//for(new i = 1; i <= TOTALBIZZ; i++) SaveMySQL(i);
	/*foreach(new i: PlayerInLogin)
	{
		PayDay(i);
	}*/
	return 1;
}
CMD:setplayerskin(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setplayerskin [id игрока/ник] [id скина]");
	if (params[1] > 311 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Неправильный ID скина!");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (pTemp[params[0]][tSelectSkinShop] != -1) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок в МО");
	new query_[128], string_[64];
	format(string_, sizeof string_, "Вы изменили скин %s на номер: %d",pInfo[params[0]][pName],params[1]);
	SendClientMessage(playerid, 0x6495EDFF, string_);
	pInfo[params[0]][pChar][0] = params[1];
	SetPlayerSkinEx(params[0], pInfo[params[0]][pChar][0]);
	format(query_, sizeof query_ ,"UPDATE `s_users` SET `pChars` = '%d,%d,%d,%d,%d,%d' WHERE `pID` = '%d'",
		pInfo[params[0]][pChar][0], pInfo[params[0]][pChar][1], pInfo[params[0]][pChar][2],
		pInfo[params[0]][pChar][3], pInfo[params[0]][pChar][4], pInfo[params[0]][pChar][5], pInfo[params[0]][pID]
	);
	mysql_tquery(dbHandle, query_, "", "");
	return 1;
}
CMD:setstat(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 9) return 1;
	if (sscanf(params, "udd",params[0],params[1],params[2]))
	{
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setstat [id] [номер] [количество]");
		SendClientMessage(playerid, COLOR_GRAD4, !"[1] Уровень|[2] Законопослушность|[3] Материалы|[4] Скин|[5] Преступлений");
		SendClientMessage(playerid, COLOR_GRAD3, !"[6] Номер телефона | [7] Exp | [8] VIP [1-3]| [9] Работа игрока |[10] Сытость");
		SendClientMessage(playerid, COLOR_GRAD2, !"[11] Деньги в банке | [12] Счёт мобильного | [13] Деньги | [14] Варны | [15] Наркотики");
		SendClientMessage(playerid, COLOR_GRAD2, !"[16] Член орг |[17] "DonatePoint" | [18] Box | [19] Kong Fu | [20] Kick Box");
		SendClientMessage(playerid, COLOR_GRAD2, !"[21] Наркозависимость | [22] Модель игрока | [23] Прогресс квеста");
		return 1;
	}
	new string_[128], query_[128];
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	switch (params[1])
	{
		case 1:
		{
			pInfo[params[0]][pLevel] = params[2];
			format(string_, sizeof(string_), "LVL игрока изменён на: %d", params[2]);
			SetPlayerScore(playerid, pInfo[playerid][pLevel]);
			SavePlayerInteger(params[0], "pLevel", pInfo[params[0]][pLevel]);
		}
		case 2:
		{
			pInfo[params[0]][pZakonp] = params[2];
			format(string_, sizeof(string_),"Законопослушность: %d", params[2]);
			SavePlayerInteger(params[0], "pZakonp", pInfo[params[0]][pZakonp]);
		}
        case 3:
		{
			pInfo[params[0]][pMats] = params[2];
			format(string_, sizeof(string_),"Материалы: %d", params[2]);
			SavePlayerInteger(params[0], "pMats", pInfo[params[0]][pMats]);
		}
		case 4:
		{
			pInfo[params[0]][pChar][0] = params[2]; 
			format(string_, sizeof(string_),"Скин игрока установлен на: %d", params[2]);
		}
		case 5:
		{
			pInfo[params[0]][pCrimes] = params[2];
			format(query_, sizeof(query_), "UPDATE `s_users` SET `pCrimes` = '%d' WHERE `pID` = '%d'", pInfo[params[0]][pCrimes], pInfo[params[0]][pID]);
			mysql_tquery(dbHandle, query_, "", "");
			format(string_, sizeof(string_),"Преступлений: %d", params[2]);
		}
		case 6:
		{
			pInfo[params[0]][PlayerNumber] = params[2];
			format(string_, sizeof(string_),"Номер телефона игрока изменён на: %d", params[2]);
			format(query_, sizeof(query_), "UPDATE `s_users` SET `pPnumber` = '%d' WHERE `pID` = '%d'", pInfo[params[0]][PlayerNumber], pInfo[params[0]][pID]);
			mysql_tquery(dbHandle, query_, "", "");
		}
		case 7:
		{
			pInfo[params[0]][pExp] = params[2];
			format(string_, sizeof(string_),"EXP игрока изменены на: %d", params[2]);
		}
		case 8:
		{
			pInfo[params[0]][VIPRank] = params[2];
			format(string_, sizeof(string_), "VIP аккаунт уровня: %d", params[2]);
			SavePlayerInteger(params[0], "vip_rank", pInfo[params[0]][VIPRank]);
		}
		case 9:
		{
			pInfo[params[0]][pJob] = params[2];
			format(string_, sizeof(string_),"Работа: %d", params[2]);
			SavePlayerInteger(params[0], "pJob", pInfo[params[0]][pJob]);
		}
		case 10:
		{
			if (pInfo[params[0]][Satiety] + params[2] > 1000) SetPlayerSatiety(params[0], 1000);
	 		else GivePlayerSatiety(params[0], params[2]);
			format(string_, sizeof(string_),"Сытость игрока: %d", params[2]);
		}
		case 11:
		{
			pInfo[params[0]][pBank] = params[2];
			format(string_, sizeof(string_),"Деньги в банке изменены на: $%d", params[2]);
			SavePlayerInteger(params[0], "pBank", pInfo[params[0]][pBank]);
		}
		case 12:
		{
			pInfo[params[0]][pMobile] = params[2];
			format(string_, sizeof(string_), "Счёт мобильного: $%d", params[2]);
		}
		case 13:
		{
			kLibGivePlayerMoney(params[0], params[2], "/setstat");
			format(string_, sizeof(string_),"Деньги изменены на: $%d", params[2]);
		}
		case 14:
		{
			pInfo[params[0]][pWarns] = params[2];
			format(string_, sizeof(string_), "Количество варнов изменено на: %d", params[2]);
			SavePlayerInteger(params[0], "pWarns", pInfo[params[0]][pWarns]);
		}
		case 15:
		{
			pInfo[params[0]][pDrugs] = params[2];
			SavePlayerInteger(params[0], "pDrugs", pInfo[params[0]][pDrugs]);
			format(string_, sizeof(string_), "Количество наркотиков изменено на: %d", params[2]);
		}
		case 16:
		{
		    leave_team(params[0], pInfo[playerid][pMember]);

			pInfo[params[0]][pMember] = params[2];

			invite_team(params[0], params[2]);

			pInfo[params[0]][pRank] = 1;
			format(query_, sizeof query_ , "UPDATE `s_users` SET `pMember` = '%d', `pRank` = '%d' WHERE `pID` = '%d'", pInfo[playerid][pMember], pInfo[playerid][pRank], pInfo[playerid][pID]);
	 		mysql_tquery(dbHandle, query_, "", "");
			format(string_, sizeof(string_), "Организация: %d", params[2]);
		}
		case 17:
		{
			pInfo[params[0]][pDonate] = params[2];
			format(string_, sizeof(string_), ""DonatePoint" счёт изменён на: %d "DonatePoint"", params[2]);
			SavePlayerInteger(params[0], "u_donate", pInfo[params[0]][pDonate]); 
		}
		case 18:
		{
			pInfo[params[0]][pBoxSkill] = params[2];
			format(string_, sizeof(string_),"Уровень боевых искусств Box: %d", params[2]);
		}
		case 19:
		{
			pInfo[params[0]][pKongfuSkill] = params[2];
			format(string_, sizeof(string_),"Уровень боевых искусств Kong Fu: %d", params[2]);
		}
		case 20:
		{
			pInfo[params[0]][pKickboxSkill] = params[2];
			format(string_, sizeof(string_), "Уровень боевых искусств Kick Box: %d", params[2]);
		}
		case 21:
		{
		    if (params[2] > 5000)
		        return SendClientMessage(playerid, COLOR_GREY, !"Макс. 5 тысяч зависимости!");
			pInfo[params[0]][pAddiction] = params[2];
			format(string_, sizeof(string_),"Зависимость %d", params[2]);
			format(query_, sizeof(query_), "UPDATE `s_users` SET `pAddiction` = '%d' WHERE `pID` = '%d'", pInfo[params[0]][pAddiction], pInfo[params[0]][pID]);
			mysql_tquery(dbHandle, query_, "", "");
		}
		case 22:
		{
		    if (!params[2] || params[2] == 74)
				return SendClientMessage(playerid, COLOR_GREY, !"Запрещенный скин!");
			pInfo[params[0]][pModel] = params[2];
			format(string_, sizeof(string_),"Модель игрока: %d", params[2]);
			SavePlayerInteger(params[0], "pModel", pInfo[params[0]][pModel]);
		}
		case 23:
		{
			pQuest[params[0]][pQuestTemp][0] = params[2];
		    format(string_, sizeof(string_),"Прогресс игрока: %d", params[2]);
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, string_);
	return 1;
}

CMD:money(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10) return 1;
    if (sscanf(params, "ud",params[0],params[1])) return	SendClientMessage(playerid, COLOR_WHITE, !"Введите: /money [ид] [сумма]");
	if (!PlayerInConnected(params[0])) return 1;
	SendMes(playerid, COLOR_WHITE,"$%d переведены на счёт игроку %s",params[1],pInfo[params[0]][pName]);
	pInfo[params[0]][pBank] += params[1];
	SavePlayerInteger(params[0], "pBank", pInfo[params[0]][pBank]);
	SendMes(params[0], COLOR_WHITE, "Пополнение счёта на сумму: $%d", params[1]);
	SendMes(params[0], COLOR_WHITE, "Новый баланс в банке: $%d", pInfo[params[0]][pBank]);
	LogingAdmins(playerid, pInfo[params[0]][pName], "Money", params[1],"/money");
	return 1;
}
/* 10 LEVEL */
CMD:gtag(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params,"d",params[0],params[1])) return scm(playerid,COLOR_WHITE,"Введите: /tag [id] [банда]");
	new str[128];
	format(str, sizeof(str), "Граффити №: %d Пренадлижит: %d", params[0],params[1]);
	scm(playerid, -1, str);
	TagInfo[params[0]][tFraction] = params[1];
	SaveGraffiti(params[0]);
	return 1;
}
CMD:resettransferpass(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность"); 
	if (isnull(params) || strlen(params) > 25) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /resettransferpass [Nick_Name]"); 
	new 
		query_[164];
	format(query_, sizeof query_, "SELECT * FROM `s_users_old` WHERE `Name` = '%s' LIMIT 1", params);
	new Cache:result = mysql_query(dbHandle, query_); 
	if (!cache_num_rows()) {
		SendClientMessage(playerid, COLOR_GREY, !"Данный аккаунт не найден!");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	if (cache_is_valid(result)) cache_delete(result);
	new	gen_password = 100000 + random(899999);

	format(query_, sizeof query_, "UPDATE `s_users_old` SET `pKey`= md5(md5('%d')) WHERE `Name` = '%s'", gen_password, params);
	mysql_tquery(dbHandle, query_, "", ""); 
	format(t_string, sizeof t_string, "[Creative] Вы сбросили пароль на аккаунте \"%s\" | Новый пароль: %d",  params, gen_password);
	SendClientMessage(playerid, COLOR_GREY, t_string), t_string[0] = EOS; 
	return 1;
}
CMD:resetpassword(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new
		targetid;
	if (isnull(params) || strlen(params) > 25) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /resetpassword [Nick_Name]");
	sscanf(params, "u", targetid);
	if (targetid != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок онлайн");
	new 
		query_[164];
	format(query_, sizeof query_, "SELECT * FROM `s_users` WHERE `Name` = '%s' LIMIT 1", params);
	new Cache:result = mysql_query(dbHandle, query_); 
	if (!cache_num_rows()) {
		SendClientMessage(playerid, COLOR_GREY, !"Данный аккаунт не найден!");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	if (cache_is_valid(result)) cache_delete(result);
	new	gen_password = 100000 + random(899999);

	format(query_, sizeof query_, "UPDATE `s_users` SET `pKey`= md5(md5('%d')) WHERE `Name` = '%s'", gen_password, params);
	mysql_tquery(dbHandle, query_, "", ""); 
	format(t_string, sizeof t_string, "[Creative] Вы сбросили пароль на аккаунте \"%s\" | Новый пароль: %d",  params, gen_password);
	SendClientMessage(playerid, COLOR_GREY, t_string), t_string[0] = EOS; 
	return 1;
}
CMD:resetguard(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new
		targetid;
	if (isnull(params) || strlen(params) > 25) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /resetguard [Nick_Name]");
	sscanf(params, "u", targetid);
	if (targetid != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок онлайн");
	new 
		query_[164];
	format(query_, sizeof query_, "SELECT * FROM `s_users` WHERE `Name` = '%s' LIMIT 1", params);
	new Cache:result = mysql_query(dbHandle, query_); 
	if (!cache_num_rows()) {
		SendClientMessage(playerid, COLOR_GREY, !"Данный аккаунт не найден!");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	if (cache_is_valid(result)) cache_delete(result);
	format(query_, sizeof query_, "UPDATE `s_users` SET pTG_ID = 'None', pConfirmTG = '0', pConfirmVK = '0', pVK_ID = 'None' WHERE `Name` = '%s'", params);
	mysql_tquery(dbHandle, query_, "", ""); 
	format(t_string, sizeof t_string, "[A] %s[%d] сбросил защиту на аккаунте \"%s\"",  pInfo[playerid][pName], playerid, params);
	SendAdminMessage(COLOR_GREY, t_string), t_string[0] = EOS; 
	return 1;
}
CMD:createdonate(playerid, params[])
{
    if (!pInfo[playerid][pLogin] || pInfo[playerid][pAdmin] < 10) return 1;
    if (sscanf(params, "d",params[0]) || params[0] < 0 || params[0] > 100000000) return SendClientMessage(playerid, COLOR_WHITE, !" Введите: /createdonate [сумма (макс. 100кк)]");
    new donate[2], query_[192], string_[64];
	donate[0] = 100000 + random(899999);
	donate[1] = 100000 + random(899999);
    mysql_format(dbHandle,query_, sizeof(query_), "INSERT INTO `s_donate` (`code_one`, `code_two`, `name`, `money`) VALUES ('%d', '%d', 'NONE', '%d')",donate[0], donate[1], params[0]);
	mysql_tquery(dbHandle, query_, "", "");
    format(string_, sizeof(string_), "Донат коды созданы! [ONE: %d] [TWO: %d]", donate[0], donate[1]);
    return scm(playerid, COLOR_YELLOW,string_);
}

CMD:giveeu(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10) return 1;
	if (sscanf(params, "ud",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /giveeu [ид] [сумма]");
	if (!IsPlayerConnected(params[0])) return 1;
	new str_[64];
	format(str_, sizeof str_, "%d EURO переведены на счёт игроку %s[%d]", params[1], pInfo[params[0]][pName], params[0]);
	SendClientMessage(playerid, COLOR_WHITE, str_);
	kLibGivePlayerEuro(params[0], params[1]);
	LogingAdmins(playerid, pInfo[params[0]][pName], "giveeu", params[1],"/giveeu");
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10) return 1;
	if (sscanf(params, "ud",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /givemoney [ид] [сумма]");
	if (!IsPlayerConnected(params[0])) return 1;
	new str_[64];
	format(str_, sizeof str_, "$%d переведены на счёт игроку %s[%d]", params[1], pInfo[params[0]][pName], params[0]);
	SendClientMessage(playerid, COLOR_WHITE, str_);
	kLibGivePlayerMoney(params[0], params[1], "(/givemoney)", playerid);
	LogingAdmins(playerid, pInfo[params[0]][pName], "Givemoney", params[1],"/givemoney");
	return 1;
}
CMD:addmenu(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	ShowPlayerDialog(playerid, D_DEV_FUNC_0, DIALOG_STYLE_LIST, "Выберите действие", "[1] Создать прилавок\n[2] Создать банкомат\n[3] Создать дом\n[4] Создать бизнес", "Выбрать", "Закрыть");
	return 1;
}
CMD:createhome(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (CreateDynamicServerHome[playerid] == false)
	{
		if (!IsPlayerInVehicle(playerid, VehicleDynamicHome[playerid])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находится в транспорте!");
		new Float:X,Float:Y,Float:Z,Float:FA;
		GetVehicleZAngle(VehicleDynamicHome[playerid], FA);
		GetVehiclePos(VehicleDynamicHome[playerid], X,Y,Z);
		format(coordh, sizeof(coordh), "%f, %f, %f, %f", X, Y, Z, FA);
		_DestroyVehicle(VehicleDynamicHome[playerid]);
		CreateDynamicServerHome[playerid] = true;
		return SendClientMessage(playerid, COLOR_LIGHTRED, !"Координаты созданы. Установите интерьер: /createhome");
	}
	if (CreateDynamicServerHome[playerid] == true)
	{
		new string1[128];
		strcat(string1,"ВАЖНО: Цена , Класс\n\nПРИМЕР: 100000 , 1\n\nID: 0 [Nope]\nID: 1 [D]\nID: 2 [C]\nID: 3 [B]\nID: 4 [A]\nID: 5 [S]\n");
		ShowPlayerDialog(playerid, D_DEV_FUNC_3,1,"Добавить дом",string1,"Выбрать","Закрыть");
	}
	return true;
} 
CMD:createwarehouse(playerid, params[])
{ 
	if (pInfo[playerid][pAdmin] < 10) return 1;
    if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /createwarehouse [ID Fraction]");
    new Float: pos_wh[4], query_[128];
    GetPlayerPos(playerid, pos_wh[0], pos_wh[1], pos_wh[2]);
    format(query_, sizeof query_, "UPDATE `s_fractionbank` SET `fPosWareHouse` = '%.2f|%.2f|%.2f',`fWorldWH` = '%d',`fIntWH` = '%d' WHERE `fID` = '%d'",
	pos_wh[0], pos_wh[1], pos_wh[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), params[0]);
	mysql_tquery(dbHandle, query_, "", "");
    CreateDynamicTrigger( pos_wh[0], pos_wh[1], pos_wh[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), 1);
	return 1;
}


/* OTHER */	
CMD:givefarm(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10)
	    return true;
	if (sscanf(params, "ii", params[0], params[1])) return SendClientMessage(playerid, COLOR_GREY, !"Введите: /givefarm [ID FERM] [ID Player]");
	if (params[0] < 0 || params[0] > 5)
	    return SendClientMessage(playerid, COLOR_GREY, !"от 1 до 5");
	if (!PlayerInConnected(params[1]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Игрок не авторизован!");
	gettime(hour, minute, second);
	strmid(FarmInfo[params[0]][fOwner], pInfo[params[1]][pName], 0, strlen( pInfo[params[1]][pName] ), MAX_PLAYER_NAME);
	strmid(FarmInfo[params[0]][fDeputy_1],"None",0,strlen("None"),MAX_PLAYER_NAME);
	strmid(FarmInfo[params[0]][fDeputy_2],"None",0,strlen("None"),MAX_PLAYER_NAME);
	strmid(FarmInfo[params[0]][fDeputy_3],"None",0,strlen("None"),MAX_PLAYER_NAME);
	SaveFermIDFarmers(params[0]);
	FarmInfo[params[0]][fLandTax] = 12000;
	FarmInfo[params[0]][fBank] = 100000;
	FarmInfo[params[0]][fProds] = 0;
	FarmInfo[params[0]][fZp] = 30;
	FarmInfo[params[0]][fGrain_Price] = 5;
	FarmInfo[params[0]][fGrain] = 0;
	FarmInfo[params[0]][fGrain_Sown] = 0;
	FarmInfo[params[0]][fProds_Selling] = 1;
	FarmInfo[params[0]][fProds_Price] = 21;

	SendMes(params[1], COLOR_WHITE, "Администратор (%s[%d]) Выдал Вам Ферму #%d",pInfo[playerid][pName], playerid, params[0]);
	//pTemp[params[1]][JobInFarmRank] = 4;
	
	GetPlayerFarm(params[1]);
	 	
	SaveFermID(params[0]);
	strmid(FarmInfo[params[0]][fAuctionName], "None", 0, strlen("None"), 10);
	FarmInfo[params[0]][fAuction][0] = 0;
	FarmInfo[params[0]][fAuction][1] = 0;
	FarmInfo[params[0]][fAuction][2] = 0;
	FarmInfo[params[0]][fAuction][3] = 0;
	SaveActionsFerm(params[0]);
	return 1;
}
CMD:setfrepute(playerid, params[]){
	if (pInfo[playerid][pAdmin] < 9)
	    return true;
	if (sscanf(params, "ii", params[0], params[1]))
	    return SendClientMessage(playerid, COLOR_GREY, !"Введите: /setfrepute [fracid][репутация](Чтобы узнать ID фракции используйте команду /fid)");
	if (params[0] >= FRACTIONBANK_COUNT || params[0] < 1)
	    return SendClientMessage(playerid, COLOR_GREY, !"FRACID: от 1 до 26");
    FractionInfo[params[0]][fRepute] = params[1];
	UpdateFractionStore(FRACTION_BALLAS);
	UpdateFractionStore(FRACTION_VAGOS);
	UpdateFractionStore(FRACTION_RIFA);
	UpdateFractionStore(FRACTION_GROVE);
	UpdateFractionStore(FRACTION_AZTEC); 
	UpdateFractionStore(FRACTION_PIRUS); 	
	SendMes(playerid, -1, "Теперь фракция %s имеет %d репутации", gFraction[params[0]][fName], FractionInfo[params[0]][fRepute]);
	return true;
}

CMD:setgstars(playerid, params[]){
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "dd", params[0], params[1]))
        return SendClientMessage(playerid, COLOR_GREY, !"Введите: /setgstars [playerid][кол-во]");
    pInfo[params[0]][gStars] = params[1];
    SavePlayerInteger(playerid, "gStars", pInfo[playerid][gStars]);
    return true;
} 

CMD:agetfarm(playerid){
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
   	return GetFarm();
} 
CMD:aduele(playerid){
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    duelonoroff = duelonoroff ? 0 : 1;
	if (duelonoroff) 
		SendClientMessage(playerid, COLOR_GREY, !"Вы отключили создание дуэлей.");
	else
		SendClientMessage(playerid, COLOR_GREY, !"Вы включили создание дуэлей.");
    return true;
}


CMD:pgetip(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	
	new temp = strlen(params);
	
	if (temp < 11 || temp > 16) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /pgetip [ip]");
	
	SendClientMessage(playerid, 0xC21D00AA, !"Список IP:");
	new ip[16],str_send[54];
	
	foreach(new i: PlayerInLogin){
		GetPlayerIp(i,ip,sizeof(ip));
		if (!strcmp(ip, params))
		{
			format(str_send, sizeof(str_send), "Nick [%s] IP [%s]", pInfo[i][pName],ip);
			SendClientMessage(playerid, 0x6BB3FFAA, str_send);
		}
	}
	return 1;
}

CMD:gmx(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	ServerRestart();
	SendRconCommand("hostname Creative Role Play | Рестарт сервера");
	SetTimer("GameModeExitDelay", 5000, false);
	SendClientMessageToAll(COLOR_RED, !"");
	SendClientMessageToAll(COLOR_RED, !"");
	SendClientMessageToAll(COLOR_RED, !"_______________=======[Внимание!Рестарт сервера через 5 секунд]=======_______________");
	SendClientMessageToAll(COLOR_RED, !"");
	SendClientMessageToAll(COLOR_RED, !"");
	return 1;
}
publics: GameModeExitDelay()
	return SendRconCommand("gmx");
stock ServerRestart()
{ 
    GameTextForAll("~r~Restart", 1000, 0);
	for(new i = 1; i <= TOTAL_FRACTION; i++) {
		SaveFractionInfoID(FractionInfo[i][fID]);
	}
	
	SaveAccounts(); 
	mysql_tquery(dbHandle, "UPDATE `s_users` SET pLogin = '0'"); 
	foreach(new i: PlayerInLogin) {
		Kick(i);
	} 
	return 1;
} /*черновик
CMD:tpk(playerid, params[])
{
        new Float:x, Float:y, Float:z;
        if(sscanf(params, "p<,>fff", x, y, z)) return SendClientMessage(playerid, -1, "Введи /тпк [X] [Y] [Z]. Можно с запятыми."); // Проверка, введены ли все координаты
        SetPlayerPos(playerid, x, y, z); // Выставление позиции игрока по заданным кординатами
        return true;
}
alias:tpk("ngr","тпк"); // Альтернативные команды
*/

CMD:tpcor(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new Float:tph[3];
	if (sscanf(params, "p<,>fff", tph[0], tph[1], tph[2]))
	{
		SendClientMessage(playerid, -1, !"Введите: /tpcor [x] [y] [z]");
		return 1;
	}

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER){

	SetPlayerPosAC(playerid, tph[0], tph[1], tph[2]);
	SetPlayerFacingAngle(playerid, 1.0);
	SendClientMessage(playerid, -1, !"Вы были телепортированы");

	}

	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER){

	SetVehiclePos(playerid, tph[0], tph[1], tph[2]);
	SetPlayerFacingAngle(playerid, 1.0);
	SendClientMessage(playerid, -1, !"Вы были телепортированы");
	
	}

 	return 1;
}

CMD:getherecar(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return 1;
	if (pTemp[playerid][AntiFloodText] > gettime()) return SendClientMessage(playerid, 0xFFD5BBAA, !"Не флуди!");
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /getherecar [carid]");
	if (params [ 0 ] < 1 || params [ 0 ] > MAX_VEHICLES) return SendClientMessage(playerid, COLOR_WHITE, !"Автомобиль не найден.");
	new Float:player_pos[3];
	GetPlayerPos(playerid, player_pos [ 0 ], player_pos [ 1 ], player_pos [ 2 ]);
	SetVehiclePos(params[0], player_pos [ 0 ] + 1.0, player_pos [ 1 ], player_pos [ 2 ] + 0.5);
	format(t_string, sizeof t_string, "[A] %s телепортировал к себе т/с (VEHID:%i)", pInfo[playerid][pName], params[0]);
	SendAdminMessage(COLOR_GREY, t_string);
	t_string[0] = EOS;
	pTemp[playerid][AntiFloodText] = gettime()+2;
	return 1;
}

CMD:gethome(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup] || pInfo[playerid][pMember] == FRACTION_FBI && pInfo[playerid][pRank] > 3) return 1;
	if (sscanf(params, "d",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gethome [id]"); 
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin] || AntiCheatIsKickedWithDesync(i)) continue;
		if (pInfo[playerid][pHouseID] != -1) {
			new str_[64];
			format(str_, sizeof str_,"Home: [%d], Player: [%d]", pInfo[i][pHouseID], i);
			SendClientMessage(playerid, COLOR_GREY, str_);
		}
	}
	return 1;
}

CMD:pos(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new Float:pos[3],
		int_,
		vw;
    GetPlayerPos(playerid, pTemp[playerid][tPos][0], pTemp[playerid][tPos][1], pTemp[playerid][tPos][2]); 
	SendMes(playerid, -1, "World: %d, Int: %d | State ID %d", GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), GetPlayerState(playerid));
	if (sscanf(params, "fffdd", pos[0], pos[1], pos[2], vw, int_)) return SendClientMessage(playerid, -1, "/pos x y z vw int");
	SetPlayerPosAC(playerid, pos[0], pos[1], pos[2], vw, int_);
	return 1;
}
CMD:reloadvippack(playerid) {
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    LoadVIPPack();
    SendClientMessage(playerid, COLOR_BLUE, !"Параметры VIP-паков были перезагружены!");
    return true;
}
CMD:reloadboostpack(playerid) {
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    LoadBoostPack(); 
    SendClientMessage(playerid, COLOR_BLUE, !"Параметры Boost-паков были перезагружены!");
    return true;
}
CMD:reloadboostserver(playerid) {
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    BoostServer_OnGameModeInit();
    SendClientMessage(playerid, COLOR_BLUE, !"Параметры Boost-Server были перезагружены!");
    return true;
}

CMD:getlip(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (isnull(params) || strlen(params) > 16) return SendClientMessage(playerid,COLOR_WHITE,!"Используйте: /getlip [ip]");
	new str_tmp[16];
	strcat(str_tmp,params);
	if ( strlen(str_tmp) < 4) return SendClientMessage(playerid,CGRAY2,!"Ошибка: необходимо минимум 4 символа");
	if (!FindSpecIpsString(str_tmp)) return SendClientMessage(playerid,CGRAY2,!"* можно использовать 1 раз");
	//if (!IsIpGoodText(str_tmp)) return SendClientMessage(playerid,CGRAY2,!"Вы указали не верные символы в запросе!");
	static select_ips[] = "SELECT `Name`,`pLevel`,`pCash`,`pBank`,`pIpReg`,`pvIp` FROM `s_users` WHERE `pvIp` LIKE '%q' ORDER BY `s_users`.`pLevel` DESC LIMIT 0,40";
	new str_get_ips[sizeof(select_ips)+16+5];
	format(str_get_ips,sizeof(str_get_ips),select_ips,str_tmp);
	mysql_tquery(dbHandle,str_get_ips, "CheckIps","dds",playerid,2,str_tmp);
	return 1;
}
CMD:players_server(playerid)
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new pl_mobile, pl_pc;
	foreach(new i: PlayerInLogin)
	{
	    if (player_mobile[i] == true) pl_mobile++;
	    else if (player_mobile[i] == false) pl_pc++;
	}
	t_string[0] = EOS;
	format(t_string, sizeof(t_string), "Mobile\t%d игроков\nPC\t%d игроков", pl_mobile, pl_pc);
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST, !"Информация", t_string, !"Закрыть", !"");
	return 1;
}
CMD:getrip(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (isnull(params) || strlen(params) > 16) return SendClientMessage(playerid,COLOR_WHITE,!"Используйте: /getrip [ip]");
	new str_tmp[16];
	strcat(str_tmp,params);
	if ( strlen(str_tmp) < 4) return SendClientMessage(playerid,CGRAY2,!"Ошибка: необходимо минимум 4 символа");
	if (!FindSpecIpsString(str_tmp)) return SendClientMessage(playerid,CGRAY2,!"* можно использовать 1 раз");
	//if (!IsIpGoodText(str_tmp)) return SendClientMessage(playerid,CGRAY2,!"Вы указали не верные символы в запросе!");
	static select_ips[] = "SELECT `Name`,`pLevel`,`pCash`,`pBank`,`pvIp`,`pIpReg` FROM `s_users` WHERE `pIpReg` LIKE '%q' ORDER BY `s_users`.`pLevel` DESC LIMIT 0,40";
	new str_get_ips[sizeof(select_ips)+16+5];
	format(str_get_ips,sizeof(str_get_ips),select_ips,str_tmp);
	mysql_tquery(dbHandle,str_get_ips, "CheckIps","dds",playerid,1,str_tmp);
	return 1;
}

publics:CheckIps(const playerid,const type,rip[])
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) return SendClientMessage(playerid,COLOR_WHITE,!"Ничего не найдено по вашему запросу");
	new name[MAX_PLAYER_NAME],
		regip[16],
		lastip[16],
		money,
		bank,
		level;
	new temp_str[104],pack_str[76];
	new str_result_ip[1024] = !"";
	strcat(str_result_ip,!"Ник [уровень]\tMoney $\tПоследний IP\tРегистрационый IP\n");
	strcat(str_result_ip,!"Результаты по запросу\t{00C800}");
	FindSpecIpsDecode(rip);
	strcat(str_result_ip,rip);
	strcat(str_result_ip,!"\n");
	for(new idx; idx < rows; idx++)
	{
	    cache_get_value_name(idx, "pvIp", lastip,sizeof(lastip));
		cache_get_value_name(idx, "pIpReg", regip,sizeof(regip));
		cache_get_value_name(idx, "Name", name,sizeof(name));
		cache_get_value_name_int(idx, "pLevel",level);
		cache_get_value_name_int(idx, "pCash",bank);
		cache_get_value_name_int(idx, "pBank",money);
		format(temp_str,sizeof(temp_str),"{EDBC3B}%s{FFFFFF} [%d]\t{00C800}%d${FFFFFF}\t%s\t%s\n",name,level,bank+money,lastip,regip);
		strpack(pack_str,temp_str,sizeof(pack_str));
		strcat(str_result_ip,pack_str);
	}
	if (type == 1)ShowPlayerDialog(playerid,D_NULL,DIALOG_STYLE_TABLIST_HEADERS,!"REGIP CHECK",str_result_ip,!"Закрыть","");
	else ShowPlayerDialog(playerid,D_NULL,DIALOG_STYLE_TABLIST_HEADERS,!"LASTIP CHECK",str_result_ip,!"Закрыть","");
	return 1;
}

stock FindSpecIpsDecode(message[])
{
    for(new i; i < strlen(message); i++){
		if (message[i] == '%'){
			message[i] = '*';
			break;
		}
	}
    return 1;
}


stock FindSpecIpsString(message[])
{
    for(new i,x; i < strlen(message); i++){
		if (message[i] == '*'){
			message[i] = '%';
			x++;
			if (x > 1) return 0;
		}
	}
    return 1;
}

CMD:upstreamer(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 5) return 1;
	new targetid;
	if (sscanf(params, "d",targetid)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /upstreamer [id]");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(targetid,x,y,z);
	Streamer_UpdateEx(targetid,x,y,z);
	SendClientMessage(playerid,-1,!"update");
	return 1;
}

CMD:checkdnk(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new vehicleid;
	if (sscanf(params, "i", vehicleid) || !(0 <= vehicleid < MAX_VEHICLES) || GetVehicleModel(vehicleid) != 508)
		return SendClientMessage(playerid, COLOR_GRAD2, "Введите: /checkdnk [id транспорта]");

	format ( t_string, sizeof t_string, "SELECT vOwner FROM `s_vehicle_player` WHERE `vID` = '%d'", VehicleInfo[vehicleid - 1][vID]);
	mysql_tquery (dbHandle, t_string, "CheckOwnerDNK", "ii", playerid, vehicleid); t_string[0] = EOS;
	return true;
}
publics:CheckOwnerDNK(playerid, vehicleid)
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) return true;
	new vehicle_ownerid;
	cache_get_value_name_int(0, "vOwner", vehicle_ownerid);

	foreach(new i: PlayerInLogin) {
		if (pInfo[i][pID] != vehicle_ownerid) continue;
		format(t_string, sizeof (t_string), "Владелец ДНК (ID: %i) - %s[%i] (статус: %s)", 
			vehicleid, pInfo[i][pName], i, (VehicleInfo[vehicleid - 1][vLocked] ? "закрыт" : "открыт")
		);
		SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
		break;
	}
	return true;
}

CMD:asms(playerid)
{
	if (pInfo[playerid][pAdmin] < 8) return 1;
	if ( player_sms_on{playerid} == 0) {
		player_sms_on{playerid} = 1;
		SendClientMessage(playerid, -1, !"Прослушка СМС {00cc00}включена");
	} else {
		player_sms_on{playerid} = 0;
		SendClientMessage(playerid, -1, !"Прослушка СМС {ff0000}выключена");
	}
	return 1;
}
alias:asms("checksms");
CMD:hbject(playerid,params[])
{
    if (pInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid,COLOR_GREY,!"Вам не доступна эта команда");
	if (isnull(params)) return SendClientMessage(playerid, -1, !"Используйте: /hbject [id] [слот] [id объекта] [bone]");
	new id = -1, index = -1, modelid = -1, bone = -1, Float:fOffsetX = 0.0,
		Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0,
		Float:fRotX = 0.0, Float:fRotY = 0.0, 
		Float:fRotZ = 0.0, Float:fScaleX = 1.0, 
		Float:fScaleY = 1.0, Float:fScaleZ = 1.0,
		materialcolor1 = 0, materialcolor2 = 0;
	sscanf(params, "riiifffffffffii",
	id, index, modelid, bone, fOffsetX,fOffsetY, fOffsetZ,fRotX,fRotY, fRotZ, fScaleX,fScaleY ,fScaleZ,materialcolor1, materialcolor2);
	if (id == -1||
	index == -1||
	modelid == -1||
	bone == -1) return SendClientMessage(playerid, -1, !"Используйте: /hbject [id] [слот] [id объекта] [bone]");
	
    if (!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн");
	if (IsPlayerAttachedObjectSlotUsed(id, index)) RemovePlayerAttachedObject(id,index);
	SetPlayerAttachedObject(id, index, modelid, bone, fOffsetX,fOffsetY, fOffsetZ,
	fRotX,fRotY, fRotZ, fScaleX,fScaleY ,fScaleZ,materialcolor1, materialcolor2);
	return 1;
}
CMD:hbjectedit(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid,COLOR_GREY,!"Вам не доступна эта команда");
	new targetid,hbjectSlot;
	if (sscanf(params,"ui",targetid,hbjectSlot)) return SendClientMessage(playerid,-1,!"Используйте: /hbjectedit [ид игрока] [слот]");
	if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн");
	if (IsPlayerAttachedObjectSlotUsed(targetid, hbjectSlot)){
		SetPVarInt(playerid,!"atach_slot",hbjectSlot+1);
		EditAttachedObject(playerid,hbjectSlot);
	}
	else SendClientMessage(playerid,CGRAY2,!"Слот пуст");
	return 1;
}
/*
CMD:giveroulette(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6) return SendClientMessage(playerid, COLOR_GREY, !"Вам не доступна эта команда");
	new targetid;
	if (sscanf(params,"u",targetid)) {
		foreach(new i: PlayerInLogin) {
			if (!PlayerInConnected(i)) continue;
			GiveFreeRoulette(i); 
		}
		SendClientMessage(playerid, COLOR_ISPOLZUY, !"Вы выдали рулетки всем игрокам");
		SendClientMessage(playerid, -1, !"Используйте: /(giver)oulette [ид игрока]");
		return 1;
	}
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок оффлайн");
	GiveFreeRoulette(targetid); 
	new 
		string_[128];
	format(string_, sizeof string_, "Вы выдали рулетку игроку %s", pInfo[targetid][pName]);
	SendClientMessage(playerid, COLOR_ISPOLZUY, string_);
	return 1;
}
alias:giveroulette("giver");
*/ 
CMD:setcapturetimer(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new amount;
	if (sscanf(params, "i", amount)) return true;
	capture_timer = amount;
	SendMes(playerid, -1, "capture_timer = %d", capture_timer);
	return true;
} 

CMD:select(playerid)
{
	if (pInfo[playerid][pAdmin] < 7) return SendClientMessage(playerid,CGRAY2,!"Вам не доступна эта команда");
	SelectObject(playerid);
	return 1;
}
CMD:mysqlstats(playerid) {
	if (pInfo[playerid][pAdmin] < 7) return SendClientMessage(playerid,CGRAY2,!"Вам не доступна эта команда");
	new 
		string_[128]; 
	format(string_, sizeof string_, 
		"Количество ожидающих запросов в MySQL: %d.",
		mysql_unprocessed_queries()
	);
	return SendClientMessage(playerid, -1, string_);
}
CMD:srvnetstats(playerid)
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    t_string[0] = EOS;

    GetNetworkStats(t_string, sizeof (t_string));
    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Server Creative Stats", t_string, "Закрыть", ""), t_string[0] = EOS;

    return true;
} 
alias:srvnetstats("svrnt");
/*
CMD:getskin(playerid)
{
    new string[30];
    format(string, sizeof(string), "ID вашего текущего скина: %d", GetPlayerSkin(playerid));
    return SendClientMessage(playerid, -1, string);
}*/

CMD:shuffle(playerid){
	if (pInfo[playerid][pAdmin] < 7) return SendClientMessage(playerid,CGRAY2,!"Вам не доступна эта команда");
    new string2[20];
	for(new i; i < 10; i ++)
	{
		playerListItem[playerid][i] = i;
	}
	ShuffleArray(playerListItem[playerid],10);
    //format(string,sizeof(string), ShuffleArray({3,4,5,6,7}) );
    format(string2,sizeof(string2),"%d/%d/%d/%d/%d/%d/%d/%d/%d/%d",playerListItem[playerid][0],
	playerListItem[playerid][1],playerListItem[playerid][2],playerListItem[playerid][3],playerListItem[playerid][4],
	playerListItem[playerid][5],playerListItem[playerid][6],playerListItem[playerid][7],playerListItem[playerid][8],
	playerListItem[playerid][9]);
	SendClientMessage(playerid,-1,string2);
    return 1;
}

ShuffleArray(data[], size_s = sizeof(data))
{
    new j = 0, temp = 0;
    for(new i = size_s-1; i > 0; i--)
    {
        j = random(i + 1);
        temp = data[i];
        data[i] = data[j];
        data[j] = temp;
    }
    return 1;
}

CheckWarCapture(playerid, type = 0)
{
	new temp = capture_band( pInfo[playerid][pMember] );
    if (temp != INVALID_PLAYER_ID) {
    	if (capture_now[temp] != 0) {
			FractionInfo[ pInfo[playerid][pMember] ][fViolation][type] ++ ;
		}
    }
    if ((pInfo[playerid][pMember] == mafia_frac_id[0] || pInfo[playerid][pMember] == mafia_frac_id[1]) && ZoneTimer > 0)
    {
		FractionInfo[ pInfo[playerid][pMember] ][fViolation][type] ++ ;
	}
	return 1;
} 

#if !defined _hkac_included

CMD:aсsettings(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup])
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Данная функция Вам недоступна.");

	new logicalString[][] = {"Выключен", "Кикнуть", "Варнинг"};

	new dialogBuffer[256];
	format(dialogBuffer, sizeof(dialogBuffer), "\
	0. Анти-чит: %s\n\
	1. Невалидный сёрфинг (машина): %s\n\
	2. Невалидный сёрфинг (объект): %s\n\
	3. NOP (Weapons Update): %s\n\
	4. Невалидное оружие: %s\n\
	5. Невалидные патроны: %s\n\
	", 
		antiCheatConfiguration[ANTICHEAT_ENABLE_INDEX] ? ("Включен") : ("Выключен"),
		logicalString[antiCheatConfiguration[AC_INVALID_SURF_VEHICLE]],
		logicalString[antiCheatConfiguration[AC_INVALID_SURF_OBJECT]],
		logicalString[antiCheatConfiguration[AC_INVALID_WEAPONS_UPDATE]],
		logicalString[antiCheatConfiguration[AC_INVALID_WEAPON_SHOT]],
		logicalString[antiCheatConfiguration[AC_INVALID_AMMO_SHOT]]
		
		);

	ShowPlayerDialog(playerid, D_ANTICHEAT, DIALOG_STYLE_LIST, "Конфигурация анти-чита", dialogBuffer,
		"Изменить", "Отмена");

	return true;
}

#else

CMD:anticheat(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup])
		return SendClientMessage(playerid, CGRAY2, "Данная функция Вам недоступна.");
	new code,status;
	if (sscanf(params, "ii", code,status)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /anticheat [code] [status]");
	if(status > 0) hkToggleAntiCheat(playerid, hkKickCode:code, true);
	else hkToggleAntiCheat(playerid, hkKickCode:code, false);

	return 1;
 }

#endif


CMD:setdj(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup])
		return SendClientMessage(playerid, CGRAY2, "Данная функция Вам недоступна.");

	new player;
	if (sscanf(params, "u", player)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setdj [ид игрока]");
	if (!PlayerInConnected(player)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");


	static get_dj[] = "SELECT * FROM `Creative_fm` WHERE `playerid` = '%d' LIMIT 1";
	new string[sizeof(get_dj) + ( -2 + MAX_PLAYER_NAME)+10];

	mysql_format(dbHandle,string, sizeof(string),get_dj, pInfo[player][pID]);
	mysql_tquery(dbHandle,string, "LoadCreativeDj","dddd",playerid,0,pInfo[player][pID],player);

	return 1;
}

CMD:offdj(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup])
		return SendClientMessage(playerid, CGRAY2, "Данная функция Вам недоступна.");

	new player;
	if (sscanf(params, "i", player)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setdj [ид аккаунта]");

	static delete_dj[] = "DELETE FROM  `Creative_fm` WHERE `playerid` = '%d' LIMIT 1";
	new string[sizeof(delete_dj) + ( -2 + MAX_PLAYER_NAME)+10];

	mysql_format(dbHandle,string, sizeof(string),delete_dj, player);
	mysql_tquery(dbHandle,string, "LoadCreativeDj","dddd",playerid,3,player,player);

	return 1;
}


CMD:getid(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup])
		return SendClientMessage(playerid, CGRAY2, "Данная функция Вам недоступна.");
	new temp = strlen(params);
	if(temp < 3 || temp > MAX_PLAYER_NAME) return SendClientMessage(playerid,0xFFFFFFFF,!"Используйте: /getid [ник]");
	new string_getid[100];
	format(string_getid,sizeof(string_getid),"SELECT `pID`,`Name` FROM `s_users` WHERE `Name` = '%q' LIMIT 1",params);
	mysql_tquery(dbHandle,string_getid, "get_user_id","ds",playerid,params);
	
	return 1;
}

CMD:ainfopanel(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6) return 1; 
	new level;
	if (sscanf(params, "i",level)) level = 10;
	if(!( 1 <= level < 12)) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верный LVL админов");
	new
		query_[128];
	format(query_, sizeof query_, "SELECT * FROM `s_admin` WHERE `level` <= '%d'", level);
	mysql_tquery(dbHandle, query_, "GetAdminInfoStats", "d", playerid);
	return 1;
}

publics: GetAdminInfoStats(playerid) {
	new row_count;
	cache_get_row_count(row_count);
	if(row_count) {
		new str_info[256],
			name[MAX_PLAYER_NAME+8],
			WO,
			WP,
			Prison,
			Warns,
			Bans;
		
		t_string[0] = EOS;
		strcat(t_string,!"{FFFFFF}");
		for(new i; i < row_count; i++)
		{
			cache_get_value_name(i, "Name", name, sizeof(name));
			cache_get_value_name_int(i, "s_OTime", WO);
			cache_get_value_name_int(i, "s_Reports", WP);

			cache_get_value_name_int(i, "s_Prisons", Prison);
			cache_get_value_name_int(i, "s_Warns", Warns);
			cache_get_value_name_int(i, "s_Bans", Bans);

			new playerColorInList[9];
			new id = getPlayerIdByNickname(name);

			if (id != -1) 
			{
				WO += pTemp[id][TimeNoAFK];
				WP = aAdminInfo[id][aReport];
				Prison = aAdminInfo[id][aPrison];
				Warns = aAdminInfo[id][aWarn];
				Bans = aAdminInfo[id][aBan];

				strcpy(playerColorInList, "{22BA0A}");
			}
			else {
				strcpy(playerColorInList, "{FFFFFF}");
			}

			new indent[7];
			new length = strlen(name);
			
			if (length < 7) {
				strcpy(indent, "\t\t\t\t");
			} else if (length < 13) {
				strcpy(indent, "\t\t\t");
			} else if (length < 22) {
				strcpy(indent, "\t\t");
			} else {
				strcpy(indent, "\t");
			}

			format(str_info, sizeof(str_info),"%s%s%sВремя: %s | Жалобы: %d | Тюрьмы: %d | Предупреждения: %d | Блокировки: %d\n",
				playerColorInList,
				name,
				indent,
				Converts(WO),
				WP,
				Prison,
				Warns, 
				Bans
			);
			strcat(t_string, str_info);
		}
		ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Статистика администрации", t_string,"Закрыть","");
	}
	return 1;
}
CMD:splist(playerid)
{
	if (pInfo[playerid][pAdmin] < 5) return 1;
	mysql_tquery(dbHandle,"SELECT * FROM "TABLE_SUPPORTS"", "get_support_info","d",playerid);
	return 1;
}

publics:get_support_info(playerid)
{
	new row_count;
	cache_get_row_count(row_count);
	if(row_count)
	{
		new str_info[100];

		new 
			name[MAX_PLAYER_NAME+8],
			rating,
			//online,
			registration,
			last_enter_server[26],
			last_ip[16]
			//time_online[26]
		;
		new uid;

		new date_[6],date_reg[26];

		t_string[0] = EOS;
		strcat(t_string,!"{FFFFFF}Имя | Рейтинг\tДата регистрации\tДата последнего входа\tПоследний IP");
		for(new i; i < row_count; i++)
		{
			cache_get_value_name(i, "sName", name,sizeof(name));
			cache_get_value_name(i, "sLastCon", last_enter_server,sizeof(last_enter_server));
			cache_get_value_name(i, "sLastIP", last_ip,sizeof(last_ip));
			cache_get_value_name_int(i, "sRep", rating);
			cache_get_value_name_int(i, "sDateReg", registration);

			if(registration != 0)
			{ 
				TimestampToDate(registration,date_[0],date_[1],date_[2],date_[3],date_[4],date_[5],3);
				format(date_reg,sizeof(date_reg),"%02d/%02d/%02d %02d:%02d:%02d",date_[2],
				date_[1],date_[0],date_[3],date_[4],date_[5]);
			}
			else date_reg = "0";

			//ConvertTime(online,time_online,sizeof(time_online)-1);

			sscanf(name, "u", uid);
			if(uid != 65535) format(name,sizeof(name),"{22BA0A}%s",name);

			format(str_info,sizeof(str_info),"\n{FFFFFF}%s | %d\t%s\t%s\t%s",
				name,
				rating,
				date_reg,
				last_enter_server,
				last_ip
			);
			strcat(t_string,str_info);
		}
		ShowPlayerDialog(playerid,D_NULL,DIALOG_STYLE_TABLIST_HEADERS,"splist",t_string,"ок","");
	}
	return 1;
} 


cmd:weekitogs(playerid) {
	if(pInfo[playerid][pAdmin] < 10) return 1;
	mysql_tquery (dbHandle, "SELECT `fID`, `fRepute` FROM `s_fractionbank` WHERE `fID` IN (8, 12,13,15,17,18) ORDER BY `fRepute` DESC LIMIT 3", "ItogWeekGangStats");
	return 1;
}

cmd:shownotif(playerid, params[])
{
	ShowNotification(playerid, 0xFFFFFFFF, 0xFF0000FF, "London is gray capital of britain!", 2000);
	return 1;
}

CMD:az(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 1 || !pTemp[playerid][PlayerADostup]) return 1;
	extract params -> new player:id;
	if(!isnull(params))
	{
		SetPlayerPosAC(id, AdminZone[adminInterior][Zone_posX], AdminZone[adminInterior][Zone_posY], AdminZone[adminInterior][Zone_posZ], AdminZone[adminInterior][Zone_VirtualWorld], AdminZone[adminInterior][Zone_Interior]);
		format(t_string, sizeof t_string, "Администратор %s[%i] телепортировал вас на собеседование.", pInfo[playerid][pName], playerid);
		scm(id, COLOR_BLUE, t_string);
		t_string[0] = EOS;
	}
	else id = playerid;
	format(t_string, sizeof t_string, "Вы были телепортированы в админ-комнату №%i (%s)", AdminZone[adminInterior][Zone_ID], AdminZone[adminInterior][Zone_Name]);
	scm(id, COLOR_GREY, t_string);
	t_string[0] = EOS;
	SetPlayerPosAC(playerid, AdminZone[adminInterior][Zone_posX], AdminZone[adminInterior][Zone_posY], AdminZone[adminInterior][Zone_posZ], AdminZone[adminInterior][Zone_VirtualWorld], AdminZone[adminInterior][Zone_Interior]);
	return 1;
}



CMD:changeadminint(playerid, params[])
{
	new f_str[128+MAX_PLAYER_NAME], t_query[128];
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return 1;
    format(f_str, sizeof(f_str), "Используй: /changeadminint [id (0-%i)]", sizeof(AdminZone)-1);
	extract params -> new adminint; else return scm(playerid, COLOR_RED, f_str);
    if(!(0 <= adminint <= sizeof(AdminZone))) return scm(playerid, COLOR_RED, f_str);
	adminInterior = adminint;
	format(f_str, sizeof f_str, "Администратор %s[%i] сменил админ комнату на №%i (%s)", pInfo[playerid][pName], playerid, AdminZone[adminint][Zone_ID], AdminZone[adminint][Zone_Name]);
   	SendAdminMessage(COLOR_GREY, f_str);

	format(t_query, sizeof(t_query),"UPDATE `s_others` SET `adminInterior`= '%d'", adminint);
	mysql_tquery(dbHandle, t_query, "", "");//hellowen_sorry

	return 1;
}
