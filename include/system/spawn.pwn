//by kuzia_studio
//by kuzia_studio
//by kuzia_studio
//by kuzia_studio
//by kuzia_studio

new Text:spawn_TD[7]; // в начало


//public OnPlayerClickTextDraw

if(clickedid == spawn_TD[1]) //организация
{
    if (GetPlayerTeamEx(playerid))
    {
                SpawnOrg(playerid);
    TextDrawSetString(spawn_TD[1], "gui:brspawn_active"); // !!!
	TextDrawSetString(spawn_TD[2], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[3], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[4], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[5], "gui:brspawn_noactive");
	}
}
	if(clickedid == spawn_TD[2]) //вокзал
	{
	SpawnPlayer(playerid);
	TextDrawSetString(spawn_TD[1], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[2], "gui:brspawn_active"); // !!!
	TextDrawSetString(spawn_TD[3], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[4], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[5], "gui:brspawn_noactive");
	}
	if(clickedid == spawn_TD[3]) // место выхода
	{
	ShowNotification(playerid, 2, "Недоступно", 3, "", "");
	TextDrawSetString(spawn_TD[1], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[2], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[3], "gui:brspawn_noctive"); // !!!
	TextDrawSetString(spawn_TD[4], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[5], "gui:brspawn_noactive");
	}
	if(clickedid == spawn_TD[4]) // гараж
	{
	ShowNotification(playerid, 2, "Недоступно", 3, "", "");
	TextDrawSetString(spawn_TD[1], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[2], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[3], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[4], "gui:brspawn_noctive"); // !!!
	TextDrawSetString(spawn_TD[5], "gui:brspawn_noactive");
	}
	if(clickedid == spawn_TD[5]) // дом
{
	if(GetPlayerData(playerid, P_HOUSE) != -1)
    {
    SpawnHouse(playerid);
	TextDrawSetString(spawn_TD[1], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[2], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[3], "gui:brspawn_noactive");
	TextDrawSetString(spawn_TD[4], "gui:brspawn_noctive");
	TextDrawSetString(spawn_TD[5], "gui:brspawn_active"); // !!!
	}
}
	if(clickedid == spawn_TD[6])
	{
	for(new i; i < sizeof spawn_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, spawn_TD[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	

//stock CreateTextDraws()

spawn_TD[0] = TextDrawCreate(129.7998, 116.9197, "gui:brspawn_main");
TextDrawTextSize(spawn_TD[0], 403.0000, 189.0000);
TextDrawAlignment(spawn_TD[0], 1);
TextDrawColor(spawn_TD[0], -1);
TextDrawBackgroundColor(spawn_TD[0], 255);
TextDrawFont(spawn_TD[0], 4);
TextDrawSetProportional(spawn_TD[0], 0);
TextDrawSetShadow(spawn_TD[0], 0);

spawn_TD[1] = TextDrawCreate(136.1999, 163.2133, "gui:brspawn_noactive");
TextDrawTextSize(spawn_TD[1], 90.0000, 90.0000);
TextDrawAlignment(spawn_TD[1], 1);
TextDrawColor(spawn_TD[1], -1);
TextDrawBackgroundColor(spawn_TD[1], 255);
TextDrawFont(spawn_TD[1], 4);
TextDrawSetProportional(spawn_TD[1], 0);
TextDrawSetShadow(spawn_TD[1], 0);
TextDrawSetSelectable(spawn_TD[1], true);

spawn_TD[2] = TextDrawCreate(215.3999, 153.5066, "gui:brspawn_noactive");
TextDrawTextSize(spawn_TD[2], 84.0000, 100.0000);
TextDrawAlignment(spawn_TD[2], 1);
TextDrawColor(spawn_TD[2], -1);
TextDrawBackgroundColor(spawn_TD[2], 255);
TextDrawFont(spawn_TD[2], 4);
TextDrawSetProportional(spawn_TD[2], 0);
TextDrawSetShadow(spawn_TD[2], 0);
TextDrawSetSelectable(spawn_TD[2], true);

spawn_TD[3] = TextDrawCreate(287.3998, 162.4667, "gui:brspawn_noactive");
TextDrawTextSize(spawn_TD[3], 89.0000, 90.0000);
TextDrawAlignment(spawn_TD[3], 1);
TextDrawColor(spawn_TD[3], -1);
TextDrawBackgroundColor(spawn_TD[3], 255);
TextDrawFont(spawn_TD[3], 4);
TextDrawSetProportional(spawn_TD[3], 0);
TextDrawSetShadow(spawn_TD[3], 0);
TextDrawSetSelectable(spawn_TD[3], true);

spawn_TD[4] = TextDrawCreate(363.3999, 162.4665, "gui:brspawn_noactive");
TextDrawTextSize(spawn_TD[4], 88.0000, 90.0000);
TextDrawAlignment(spawn_TD[4], 1);
TextDrawColor(spawn_TD[4], -1);
TextDrawBackgroundColor(spawn_TD[4], 255);
TextDrawFont(spawn_TD[4], 4);
TextDrawSetProportional(spawn_TD[4], 0);
TextDrawSetShadow(spawn_TD[4], 0);
TextDrawSetSelectable(spawn_TD[4], true);

spawn_TD[5] = TextDrawCreate(437.7998, 161.7198, "gui:brspawn_noactive"); 
TextDrawTextSize(spawn_TD[5], 88.0000, 90.0000);
TextDrawAlignment(spawn_TD[5], 1);
TextDrawColor(spawn_TD[5], -1);
TextDrawBackgroundColor(spawn_TD[5], 255);
TextDrawFont(spawn_TD[5], 4);
TextDrawSetProportional(spawn_TD[5], 0);
TextDrawSetShadow(spawn_TD[5], 0);
TextDrawSetSelectable(spawn_TD[5], true);

//пон
spawn_TD[6] = TextDrawCreate(295.3997, 262.5200, "LD_SPAC:white");
TextDrawTextSize(spawn_TD[6], 73.0000, 24.0000);
TextDrawAlignment(spawn_TD[6], 1);
TextDrawColor(spawn_TD[6], -256);
TextDrawBackgroundColor(spawn_TD[6], 255);
TextDrawFont(spawn_TD[6], 4);
TextDrawSetProportional(spawn_TD[6], 0);
TextDrawSetShadow(spawn_TD[6], 0);
TextDrawSetSelectable(spawn_TD[6], true);



//в конец мода

cmd:testspawn(playerid)
{
for(new i; i < sizeof spawn_TD; i++)
{
	 TextDrawShowForPlayer(playerid, spawn_TD[i]);
}
SelectTextDraw(playerid);
}

stock SpawnOrg(playerid)
                {
                    new team_id = GetPlayerTeamEx(playerid);

                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        GetTeamData(team_id, O_SPAWN)[0],
                        GetTeamData(team_id, O_SPAWN)[1],
                        GetTeamData(team_id, O_SPAWN)[2],
                        GetTeamData(team_id, O_SPAWN)[3],
                        0, 0, 0, 0, 0, 0
                    );

                    SetPlayerInterior(playerid, GetTeamData(team_id, O_SPAWN_INT));
                    SetPlayerVirtualWorld(playerid, GetTeamData(team_id, O_SPAWN_VW));
                }
                
                
stock SpawnHouse(playerid)
                {
                    new type = GetHouseData(GetPlayerHouse(playerid, HOUSE_TYPE_HOME), H_TYPE);

                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        GetHouseTypeInfo(type, HT_ENTER_POS_X),
                        GetHouseTypeInfo(type, HT_ENTER_POS_Y),
                        GetHouseTypeInfo(type, HT_ENTER_POS_Z),
                        GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
                        0, 0, 0, 0, 0, 0
                    );

                    SetPlayerInterior(playerid, GetHouseTypeInfo(type, HT_INTERIOR));
                    SetPlayerVirtualWorld(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME) + 2000);
                    
                    SetPlayerInHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));

                    // EnterPlayerToHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
}