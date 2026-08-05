native 		IsValidVehicle(vehicleid);

stock GetString(const param1[],const param2[]) {
	return !strcmp(param1, param2, false);
}

stock Random(min, max) {
	return (random(max - min) + min);
}
stock Float:GetDistanceBetweenPlayers(p1,p2) {
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2)) return -1.00;
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}
stock bool:IsRPNick(const name[])
{ // http://pro-pawn.ru/showthread.php?7528&p=95478&viewfull=1#post95478
    static i, j, __;
    if ('A' <= name[0] <= 'Z' && 'a' <= name[1] <= 'z')
    {
        for (i = 1, __ = 0;;)
        {
            switch (name[++i])
            {
                case 'a'..'z':
                    continue;
                case '_':
                {
                    static const prefixes[][] =     { "Mc", "Mac", "O", "von_", "van_", "al_", "Al_"};
                    static const prefix_lengths[] = { 2,    3,     1,   4,      4,      3,     3 };
                    for (++__, ++i, j = 0; j < sizeof(prefixes); ++j)
                    {
                        if (0 != strcmp(name[i], prefixes[j], false, prefix_lengths[j]))
                            continue;
                        if ('A' <= name[i + prefix_lengths[j]] <= 'Z')
                            i += prefix_lengths[j];
                        break;
                    }
                    if ('A' <= name[i] <= 'Z' && 'a' <= name[++i] <= 'z')
                        continue;
                    else
                        break;
                }
                case '\0':
                    return (i >= 4 && __ == 1);
                default:
                    return false;
            }
        }
    }
    return false;
}
stock Check_Client(playerid)
{
	new
		buffer[40+1],
		ip[16];


	GetPlayerClientID(playerid, buffer);
	GetPlayerIp(playerid, ip, sizeof(ip));
	printf("gpci: %s | nick: %s, ip: %s", buffer, player_name[playerid], ip);

	if(!strcmp(buffer, "FF2BE5E6F5D9392F57C4E66F7AD78767277C6E4F6B", true))
	{
		TI[playerid][pAndroid] = 1; // ORIGINAL MOBILE client
		printf("android: nick: %s",  player_name[playerid]);
		Android_PlayersCount++;
	}

	else {
		TI[playerid][pAndroid] = 0; // Not found or PC
		PC_PlayersCount++;
	}
	return 0;
}
//

stock D(playerid, dialogid, style, const caption[], const info[], const button1[], const button2[]) {
	if(!TI[playerid][tLogin]) {
		if(dialogid != 0 && dialogid != 1 && dialogid != 2 && dialogid != 3 && dialogid != 4 && dialogid != 402 && dialogid != 463 && !GetPVarInt(playerid, "registration") && dialogid != 135 && dialogid != 128 && dialogid != 127 && dialogid != 562 && dialogid != 563 && dialogid != 553)
		{
			Kick(playerid);

		}
	}
	//if(TI[playerid][tHeal]) TI[playerid][tHeal] = false;
	TI[playerid][tDialog] = true;
	if(OldDialogID[playerid] == INVALID_DIALOG_ID) PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	OldDialogID[playerid] = dialogid;


	printf("%s[%d]: dialog = %d, style = %d", player_name[playerid], playerid, dialogid, style);
	return ShowPlayerDialog(playerid, dialogid, style,caption, info, button1, button2);
}
stock ErrorMessage(playerid, const text[]) {
	new string[144];
	format(string, sizeof(string), ""NO"X"G" %s", text);
	return SendClientMessage(playerid, COLOR_GREY, string);
}
stock SendEsp(playerid, const text[]) {
	new string[144];
	format(string, sizeof(string), "Используйте: %s", text);
	return SendClientMessage(playerid, COLOR_GREY, string);
}
stock SendOk(playerid, const text[]) {
	new string[144];
	format(string, sizeof(string), ""GREEN"V"G" %s", text);
	return SendClientMessage(playerid, COLOR_GREY, string);
}
stock SendUse(playerid, const text[]) {
	new string[144];
	format(string, sizeof(string), ""GREEN"V"G" %s", text);
	return SendClientMessage(playerid, COLOR_GREY, string);
}
stock GetCheckID(const name[]) {
    new ID = INVALID_PLAYER_ID;
	sscanf(name, "u", ID);
	if(IsPlayerConnected(ID)) return ID;
	return INVALID_PLAYER_ID;
}
stock Float:PointToPoint2D(Float:x1,Float:y1,Float:x2,Float:y2) return floatsqroot(floatadd(floatpower(x2-x1,2),floatpower(y2-y1,2)));
stock Float:GetPlayerDistanceToPlayer(playerid, targetid) {
    new Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerPos(targetid, x2, y2, z2);
    return PointToPoint2D(x, y, x2, y2);
}
stock FormatNumber(number)
{
    new 	
		value[15],
        length;

    format(value, sizeof(value), "%d", (number < 0) ? (-number) : (number));

    if ((length = strlen(value)) > 3)
    {
        for (new i = length, l = 0; --i >= 0; l ++)
        {
            if ((l > 0) && (l % 3 == 0)) strins(value, ",", i + 1);
        }
    }

    if (number < 0)
        strins(value, "-", 0);

    return value;
}
stock GiveMoney(playerid, money, const s[]="None") {
	if(strlen(s)) {
	    new ip[16],query[240];
		GetPlayerIp(playerid, ip, sizeof(ip));
	    mysql_format(connects,query, sizeof(query), "INSERT INTO `givecash` (`Name`,`IP`,`Reason`,`Dollar`,`Cash`,`Date`) VALUES ('%e', '%s', '%e','%d','%d',CURRENT_TIMESTAMP);",player_name[playerid],ip,s,money,PI[playerid][pCash]);
		mysql_tquery(connects, query, "", "");
	}
	new string[35];
	if(PI[playerid][pCash] > PI[playerid][pCash]+money) format(string,sizeof(string),"~r~ %d$",money);
	else format(string,sizeof(string),"~g~ +%d$",money);
	GameTextForPlayer(playerid, string, 5000, 1);

	PI[playerid][pCash] += money;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PI[playerid][pCash]);
	UpdatePlayerData(playerid,"pCash",PI[playerid][pCash]);

	if(PI[playerid][pCash] >= 1000000) {
		if(!TI[playerid][tShowKeys]) {
			SetPlayerAttachedObject(playerid,9,1210,5,0.299999,0.099999,0.000000,0.000000,-83.000000,0.000000,1.000000,1.000000,1.000000);
			TI[playerid][tShowKeys] = true;
		}
		if(TI[playerid][tShowKeys]) {
			if(GetPlayerWeapon(playerid) > 0 || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || !PI[playerid][pSettings][7] || TI[playerid][tJobSad][0] || GetPVarInt(playerid,"fish_place") || TI[playerid][tJobGun][0] || TI[playerid][tJobOil][0] || TI[playerid][tClothesWork][0]) {
				if(IsPlayerAttachedObjectSlotUsed(playerid, 9))
					RemovePlayerAttachedObject(playerid, 9);
			}
			else {
				if(!IsPlayerAttachedObjectSlotUsed(playerid, 9))
					SetPlayerAttachedObject(playerid,9,1210,5,0.299999,0.099999,0.000000,0.000000,-83.000000,0.000000,1.000000,1.000000,1.000000);
			}
		}
	}
	else if(PI[playerid][pCash] < 1000000) {
		if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) {
			if(TI[playerid][tShowKeys]) {
				RemovePlayerAttachedObject(playerid, 9);
				TI[playerid][tShowKeys] = false;
			}
		}
	}

/* 	if(TI[playerid][pAndroid]) {

		format(string, 15, "%s", FormatNumber(PI[playerid][pCash]));
		PlayerTextDrawSetString(playerid, mobile_local_hud[playerid][0], string);
		PlayerTextDrawShow(playerid, mobile_local_hud[playerid][0]);
	} */
	return 1;
}

/* stock UpdateMobileHudForPlayer(playerid) {

	// Update Health, Armour, Food(golod)

	new 
		Float:health, 
		Float:armour,
		Float:size;

	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);

	new Float: max_size = 565.0;

	size = 500.0 + health * 0.65;
	if(size > max_size) size = max_size;
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][3], size, 57.500000);

	size = 500 + armour * 0.65;
	if(size > max_size) size = max_size;
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][5], size, 57.500000);

	for (new i = 0; i < 7; i++) PlayerTextDrawShow(playerid, mobile_local_hud[playerid][i]);
}  */