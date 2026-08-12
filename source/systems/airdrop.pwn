new 
    AirDropObject[2],
    Text3D:AirDropText
;

enum AirDrop_Info
{
	Float:AirDropX,
	Float:AirDropY,
	Float:AirDropZ,
	bool:AirDropStatus
}
new AirDropInfo[][AirDrop_Info] =
{
	{262.4322,2505.1868,16.4844},
	{1896.9647,791.4638,10.8203},
	{1952.6436,226.3472,28.7717},
	{2362.5042,-704.1384,131.1537},
	{1539.7240,-2227.3987,13.5469},
	{1795.9135,-2712.3518,13.5391},
	{1265.5433,-2036.5615,59.2494},
	{991.2833,-2115.6624,13.0938},
	{837.9026,-2046.9525,12.8672},
	{231.5767,-1835.1168,3.6640},
	{-296.9559,-1357.2260,8.1624},
	{-2472.2686,-261.0666,39.5178},
	{-2899.5779,471.4667,4.9141},
	{-196.3857,9.9452,3.1094}
};

AirDrop_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new bool:isReturn = false;
    if(newkeys == KEY_WALK)
    {
        for(new i; i < sizeof(AirDropInfo); i++)
        {
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, AirDropInfo[i][AirDropX], AirDropInfo[i][AirDropY], AirDropInfo[i][AirDropZ]))
	        {
	            if(AirDropInfo[i][AirDropStatus])
	            {
                    //if(pInfo[playerid][pAdmin] > 0 || pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, "Администратору нельзя открывать AirDrop!");
					AirDropInfo[i][AirDropStatus] = false;
					AirDropPrize(playerid);
				}
	        }
        }
    }
    return isReturn;
}

AirDrop_SecondTimer()
{
    if((minute == 00 || minute == 15 || minute == 30 || minute == 45) && second == 00) CreateAirDrop();
}

stock CreateAirDrop()
{
	new AirDropId = random(sizeof(AirDropInfo));
    for(new i; i < sizeof(AirDropObject); i++) DestroyDynamicObject(AirDropObject[i]);
	DestroyDynamic3DTextLabel(AirDropText);
	AirDropObject[0] = CreateDynamicObject(18849, AirDropInfo[AirDropId][AirDropX], AirDropInfo[AirDropId][AirDropY], AirDropInfo[AirDropId][AirDropZ] + 6.4, 0, 0, 180);
	AirDropObject[1] = CreateDynamicObject(18728, AirDropInfo[AirDropId][AirDropX], AirDropInfo[AirDropId][AirDropY], AirDropInfo[AirDropId][AirDropZ] - 2.5, 0, 0, 180);
	AirDropText = CreateDynamic3DTextLabel("{FFF000}AirDrop:\n"c_green"Нажмите ALT", 0xFFFFFFFF, AirDropInfo[AirDropId][AirDropX], AirDropInfo[AirDropId][AirDropY], AirDropInfo[AirDropId][AirDropZ], 10);
								
	foreach(new i: PlayerInLogin)
	{
		SetPlayerCheckpoint(i, AirDropInfo[AirDropId][AirDropX], AirDropInfo[AirDropId][AirDropY], AirDropInfo[AirDropId][AirDropZ],8);
		CP[i] = 777;
	} 

	AirDropInfo[AirDropId][AirDropStatus] = true;

    SendClientMessageToAll(COLOR_YELLOW, "[AirDrop] "colwhi"Только что самолёт уронил {FFF000}AirDrop"colwhi", на мини-карте указано приблизительно место падения.");
    SendClientMessageToAll(COLOR_YELLOW, "[AirDrop] "colwhi"При открытии {FFF000}AirDrop"colwhi", вы сможете получить ценные призы!");
	return 1;
}

stock AirDropPrize(playerid)
{
    for(new i; i < sizeof(AirDropObject); i++) DestroyDynamicObject(AirDropObject[i]);
	DestroyDynamic3DTextLabel(AirDropText);

	foreach(new i: PlayerInLogin) DisablePlayerCheckpoint(i);

    new AirDropPrizeStr[64];
    switch(random(101))
    {
        case 0..17: 
        {
            kLibGivePlayerMoney(playerid, 5000, "AirDrop");
            AirDropPrizeStr = "5000$";
        }
        case 18..36: 
        {
            kLibGivePlayerMoney(playerid, 10000, "AirDrop");
            AirDropPrizeStr = "10.000$";
        }
        case 37..54: 
        {
            kLibGivePlayerMoney(playerid, 20000, "AirDrop");
            AirDropPrizeStr = "20.000$";
        }
        case 55..67: 
        {
            kLibGivePlayerMoney(playerid, 30000, "AirDrop");
            AirDropPrizeStr = "30.000$";
        }
        case 68..75: 
        {
            pInfo[playerid][pDonate] += 10;
			SavePlayerInteger(playerid, "u_donate", pInfo[playerid][pDonate]);
            AirDropPrizeStr = "10 "DonatePoint"";
        }
        case 76..87: 
        {
            pInfo[playerid][pDonate] += 15;
			SavePlayerInteger(playerid, "u_donate", pInfo[playerid][pDonate]);
            AirDropPrizeStr = "15 "DonatePoint"";
        }
        case 88..95: 
        {
            pInfo[playerid][pDonate] += 20;
			SavePlayerInteger(playerid, "u_donate", pInfo[playerid][pDonate]);
            AirDropPrizeStr = "30 "DonatePoint"";
        }
        case 96..100:
        {
            pInfo[playerid][pDonate] += 30;
			SavePlayerInteger(playerid, "u_donate", pInfo[playerid][pDonate]);
            AirDropPrizeStr = "30 "DonatePoint"";
        }
    }

    new string[128];
    format(string, sizeof(string), "[A] Игрок %s[%d] открыл AirDrop и нашёл в нём: %s", GetName(playerid), playerid, AirDropPrizeStr);
    SendAdminMessage(0xBE2D2DFF, string), string[0] = EOS;

    format(string, sizeof(string), "Вы успешно открыли AirDrop и нашли в нём: "c_green"%s", AirDropPrizeStr);
    SendClientMessage(playerid, COLOR_GREY, string), string[0] = EOS;
	return ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
}

CMD:airtestarcane(playerid)
{
	return CreateAirDrop();
}