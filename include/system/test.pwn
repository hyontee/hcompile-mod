@___If_u_can_read_this_u_r_nerd();    // 10 different ways to crash DeAMX
@___If_u_can_read_this_u_r_nerd()    // and also a nice tag for exported functions table in the AMX file
{ // by Daniel_Cortez \\ pro-pawn.ru
    #emit    stack    0x7FFFFFFF    // wtf (1) (stack over... overf*ck!?)
    #emit    inc.s    cellmax    // wtf (2) (this one should probably make DeAMX allocate all available memory and lag forever)
    static const ___[][] = {"pro-pawn", ".ru"};    // pretty old anti-deamx trick
    #emit    retn
    #emit    load.s.pri    ___    // wtf (3) (opcode outside of function?)
    #emit    proc    // wtf (4) (if DeAMX hasn't crashed already, it would think it is a new function)
    #emit    proc    // wtf (5) (a function inside of another function!?)
    #emit    fill    cellmax    // wtf (6) (fill random memory block with 0xFFFFFFFF)
    #emit    proc
    #emit    stack    1    // wtf (7) (compiler usually allocates 4 bytes or 4*N for arrays of N elements)
    #emit    stor.alt    ___    // wtf (8) (...)
    #emit    strb.i    2    // wtf (9)
    #emit    switch    0
    #emit    retn    // wtf (10) (no "casetbl" opcodes before retn - invalid switch statement?)
L1:
    #emit    jump    L1    // avoid compiler crash from "#emit switch"
    #emit    zero    cellmin    // wtf (11) (nonexistent address)
}

#include 	<a_samp>
#include 	<a_mysql>
#define FILTERSCRIPT
#include 	<Pawn.CMD>
#include 	<Pawn.RakNet>
#include 	<sscanf2>
#include 	<streamer>
#include 	<foreach>
//==============================================================================
#define CWHITE 		0xFFFFFFFF
#define CRED 		0xFF0000FF
#define CCYAN 		0x0000FFFF
#define CPINK 		0xFF00FFFF
#define CBLUE 		0x00FFFFFF
#define CYELLOW 	0xFFFF00FF
#define CGREY 		0x7F7F7FFF
#define CGREEN   	0x00FF00FF
#define CORANGE 	0xFF8000FF
#define CGOLD		0xFFD700FF
#define CDSB		0x00BFFFFF
#define CPURPLE     0xF7619300
#define CLRED    	0xFF3030FF

//------------------------------Цвет рации--------------------------------------

#define cRR         0x3CB371FF
#define cFF         0x6495EDFF

//______________________________________________________________________________
//------------------------------------------------------------------------------
#define CW          "{FFFFFF}"
#define CR          "{FF0000}"
#define CBB         "{0000FF}"
#define CP          "{FF00FF}"
#define CB          "{00FFFF}"
#define CY          "{FFFF00}"
#define CGRY		"{7F7F7F}"
#define CG	        "{00FF00}"
#define CO          "{FF8000}"
#define CGLD		"{FFD700}"
//------------------------------------------------------------------------------
#define CDG         "{006400}"
#define CDO         "{FF8C00}"
#define CLR         "{FF3030}"
#define cBi			"{3399FF}"

#define randomEx(%0,%1) (%0+random(%1-%0))

#define SCM 			SendClientMessage
#define SCMTA   		SendClientMessageToAll
#define SPD         	ShowPlayerDialog
//------------------------------------------------------------------------------
#define		DSI		DIALOG_STYLE_INPUT
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST
#define 	DSP		DIALOG_STYLE_PASSWORD
#define 	DST		DIALOG_STYLE_TABLIST

#define MAX_FAMILY 2
#define MAX_FAMILY_NAME 30

new DBconnectID;

enum P_Info
{
	pName[MAX_PLAYER_NAME],
	bool:OnFamily, //состоит ли в семье?
	pFamilyId, //айди семьи
	pFWarPoint, //поинты заработанные на капте
	pFWar, //зоны в которой стреляется игрок
	pLastGiveDamageId, //рега урона
}
new pInfo[MAX_PLAYERS][P_Info];

new bool:IsFamilyWar[5][MAX_FAMILY+1];
new FamilyWarPoint[5][MAX_FAMILY+1];


new Text:TD_scoreboard[7];
new Text:TD_scoreboard_text[5][4];
new PlayerText:TD_scoreboard_fam_point[MAX_PLAYERS];

new F_war_zone[5];
new fwarzone_info[5][4] =
{
	{879,1900, 906, 1928}, //Выш арз
	{2667,558, 2682, 578}, //Выш гарель
	{248,-1466, 263,-1484}, //Выш коряк
	{2288,-274,2326,-238}, //Ферма гарель
	{-606, -2024, -555,-1955} //Завод бус
};

new F_war_zone_time[5];

enum F_war_3dtext_info
{
	wName[23],
	wX,
	wY,
	wZ
}
new fwar_3dtext_info[5][F_war_3dtext_info] =
{
	{"Вышка сотовой связи №1", 883, 1924, 25},
	{"Вышка сотовой связи №2", 883, 1924, 0},
	{"Вышка сотовой связи №3", 883, 1924, 0},
	{"Ферма Гарель", 883, 1924, 0},
	{"Завод Бусаево", 883, 1924, 0}
};
new Text3D:FWarText[5];

new bool:Active_war[5];
//new Family_owner_war[5];


//public OnGameModeInit()
public OnFilterScriptInit()
{
	SetTimer("TimerCorrectMinute", 1000, false);
	SetTimer("TimerSecondUpdateFWar", 1000, true);

    DBconnectID = mysql_connect("", "", "", ""); //коннект к бд (замените DBconnectID на свою переменную вашего мода.)

	for(new war; war<5; war++)
	{
    	F_war_zone[war] = GangZoneCreate(fwarzone_info[war][0],fwarzone_info[war][1], fwarzone_info[war][2], fwarzone_info[war][3]);
 	   	FWarText[war] = Create3DTextLabel("", CYELLOW, fwar_3dtext_info[war][wX], fwar_3dtext_info[war][wY], fwar_3dtext_info[war][wZ], 10.0, 0);

  		LoadFWar(war);
	}
	LoadTextDraw();
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
	{
	    LoadPlayerTextDraw(playerid);
	}
	return 1;
}
public OnFilterScriptExit()
{
	return 1;
}
public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, pInfo[playerid][pName], MAX_PLAYER_NAME);
    //LoadPlayerTextDraw(playerid);

	if(pInfo[playerid][OnFamily] == true && pInfo[playerid][pFamilyId] > 0)
	{
 	    for(new war; war < 5; war++)
	  	{
	  	    if(Active_war[war] == true) SendPlayerFWar(playerid, war);
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    pInfo[playerid][pFWarPoint] = 0;
    pInfo[playerid][pFWar] = 0;
	return 1;
}


stock LoadFWar(war)
{
    new qString[46];
	format(qString, sizeof(qString), "SELECT * FROM `family_war` WHERE `warid` = %d", war+1);
	mysql_function_query(DBconnectID, qString, true, "LoadFWarInfo", "d", war);
}
forward LoadFWarInfo(war);
public LoadFWarInfo(war)
{
    new rows, fields;
    cache_get_data(rows, fields);
    if(!rows)
    {
 		printf("ВНИМАНИЕ: В базе данных нет таблицы с фам каптами.");
    }
	else
	{
		new familyowner = cache_get_field_content_int(0, "familyowner", DBconnectID);
		if(familyowner == 0)
		{
    		new strkbass[62]; format(strkbass, sizeof strkbass, "%s\n"CW"Данным предприятием владеет семья", fwar_3dtext_info[war][wName]);
 	   		Update3DTextLabelText(FWarText[war], CYELLOW, strkbass);
		}
		else
		{
		    new strkbass[62+MAX_FAMILY_NAME]; format(strkbass, sizeof strkbass, "%s\n"CW"Данным предприятием владеет семья\n%s", fwar_3dtext_info[war][wName], familyname(familyowner));
 	   		Update3DTextLabelText(FWarText[war], CYELLOW, strkbass);
		}
	}
}

stock SaveFWarOwner(war, familyid)
{
	new qString[64];
	format(qString, sizeof(qString), "UPDATE `family_war` SET `familyowner` = %d WHERE `warid` = %d", familyid, war+1);
	mysql_function_query(DBconnectID, qString, false, "", "");
}

stock familyname(familyid)
{
	new fam_name[MAX_FAMILY_NAME]; format(fam_name, sizeof fam_name, "%d", familyid);
	return fam_name;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(playerid != INVALID_PLAYER_ID && damagedid != INVALID_PLAYER_ID) pInfo[damagedid][pLastGiveDamageId] = playerid;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(pInfo[playerid][OnFamily] == true && pInfo[playerid][pFamilyId] > 0)
	{
		for(new war; war < 5; war++)
		{
			if(IsFamilyWar[war][pInfo[playerid][pFamilyId]] == true)
			{
			    if(IsPlayerInArea(playerid, fwarzone_info[war][0],fwarzone_info[war][1], fwarzone_info[war][2], fwarzone_info[war][3]))
			 	{
				    if(CheckIsFamilyWar(war, pInfo[playerid][pFamilyId]))
					{
					    new strkbass[95];
					    
						if(killerid != 65535)
						{
							if(pInfo[killerid][OnFamily] == true && pInfo[killerid][pFamilyId] > 0)
							{
								if(pInfo[playerid][pFamilyId] != pInfo[killerid][pFamilyId])
								{
								    if(IsFamilyWar[war][pInfo[killerid][pFamilyId]] == true)  pInfo[playerid][pFWarPoint] += pInfo[killerid][pFWarPoint];//FamilyWarPoint[war][pInfo[killerid][pFamilyId]] += intround(FamilyWarPoint[war][pInfo[playerid][pFamilyId]]/2);
								}
								else print("killer fam == killed fam");
						    }
					    }
					    else
					    {
							new killer = pInfo[playerid][pLastGiveDamageId];
							if(pInfo[killer][OnFamily] == true && pInfo[killer][pFamilyId] > 0)
							{
								if(pInfo[playerid][pFamilyId] != pInfo[killer][pFamilyId])
								{
								    if(IsFamilyWar[war][pInfo[killer][pFamilyId]] == true)
									{
										pInfo[killer][pFWarPoint] += pInfo[playerid][pFWarPoint];//FamilyWarPoint[war][pInfo[killer][pFamilyId]] += intround(FamilyWarPoint[war][pInfo[playerid][pFamilyId]]/2);
										
										format(strkbass, sizeof strkbass, "Игрок %s[%d] убил врага и заработал %d очков", pInfo[killer][pName], killer, pInfo[playerid][pFWarPoint]);
          								SMF(pInfo[killer][pFamilyId], strkbass); //Отправка в фаму игрока.
									}
								}
								else print("killer fam == killed fam");
						    }
					    }
					
						format(strkbass, sizeof strkbass, "Игрок %s[%d] был убит на сражении и потерял %d очков", pInfo[playerid][pName], playerid, pInfo[playerid][pFWarPoint]);
						SMF(pInfo[playerid][pFamilyId], strkbass); //Отправка в фаму игрока.
						pInfo[playerid][pFWarPoint] = 0;
					}
				}
			}
		}
	}
    return 1;
}


forward TimerCorrectMinute(); //Калибровка времени для точности в секундах
public TimerCorrectMinute()
{
	new hour, minute, second;
	gettime(hour, minute, second);
	if(second == 0) SetTimer("TimerMinuteUpdateFWar", 60000, true);
	else SetTimer("TimerCorrectMinute", 1000, false);
	return 1;
}


forward TimerSecondUpdateFWar(); //Калибровка времени для точности в секундах
public TimerSecondUpdateFWar()
{
	foreach(new playerid:Player)
	{
	    if(pInfo[playerid][OnFamily] == true && pInfo[playerid][pFamilyId] > 0)
	 	{
	 	    for(new war; war < 5; war++)
		  	{
		  	    if(Active_war[war] == true)
				{
			 	    if(IsPlayerInArea(playerid, fwarzone_info[war][0],fwarzone_info[war][1], fwarzone_info[war][2], fwarzone_info[war][3]))
			        {
			            IsFamilyWar[war][pInfo[playerid][pFamilyId]] = true;
                        pInfo[playerid][pFWar] = war+1;
                        pInfo[playerid][pFWarPoint]++;
                        FamilyWarPoint[war][pInfo[playerid][pFamilyId]]+=pInfo[playerid][pFWarPoint];

			            TextDrawShowForPlayer(playerid, TD_scoreboard[0]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard[1]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard[2]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard[3]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard[4]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard[5]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard[6]);

			            TextDrawShowForPlayer(playerid, TD_scoreboard_text[war][0]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard_text[war][1]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard_text[war][2]);
			            TextDrawShowForPlayer(playerid, TD_scoreboard_text[war][3]);
			            

					   	PlayerTextDrawShow(playerid, TD_scoreboard_fam_point[playerid]);
					}
					else
					{
					    //if(IsFamilyWar[war][pInfo[playerid][pFamilyId]] == true)
					    if(war == pInfo[playerid][pFWar]-1)
					    {
							new strkbass[95];
							format(strkbass, sizeof strkbass, "Игрок %s[%d] покинул территорию сражения и потерял %d очков", pInfo[playerid][pName], playerid, pInfo[playerid][pFWarPoint]);
							SMF(pInfo[playerid][pFamilyId], strkbass); //Отправка в фаму игрока.
								
							pInfo[playerid][pFWarPoint] = 0;
							pInfo[playerid][pFWar] = 0;
								

							TextDrawHideForPlayer(playerid, TD_scoreboard[0]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[1]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[2]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[3]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[4]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[5]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[6]);

				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][0]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][1]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][2]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][3]);

					        PlayerTextDrawHide(playerid, TD_scoreboard_fam_point[playerid]);
								
							if(!CheckIsFamilyWar(war, pInfo[playerid][pFamilyId]))
							{
							    FamilyWarPoint[war][pInfo[playerid][pFamilyId]] = 0;
							}
					    }
					}
				}
			}
	 	}
	}

	for(new war; war < 5; war++)
	{
		//new war = 0;
	    if(Active_war[war] == true)
		{
		    new Leader_war;
		    new Leader_id;

			for(new family=1; family <= MAX_FAMILY; family++)
			{
			    if(IsFamilyWar[war][family] == true)
			    {
					if(FamilyWarPoint[war][family] > Leader_war)
					{
						Leader_war = FamilyWarPoint[war][family];
						Leader_id = family;
					}

					SetFamilyMemberPoint(war, family);
				}
				FamilyWarPoint[war][family] = 0;
			}


			new lead_point[5];
			format(lead_point, sizeof lead_point, "%d", Leader_war);
			TextDrawSetString(TD_scoreboard_text[war][3], lead_point);


			new hour, minute, second;
			gettime(hour, minute, second);

			new war_time[13];
			format(war_time, sizeof war_time, RusText("ВРЕМЯ: %d:%02d"), (second > 0) ? (F_war_zone_time[war]-minute-1) : (F_war_zone_time[war]-minute), (second == 0) ? (second) : (60-second));
			TextDrawSetString(TD_scoreboard_text[war][0], war_time);
			
			
			if(minute >= F_war_zone_time[war] && second == 00)
			{
			    new strkbass[88];
			    format(strkbass, sizeof strkbass, "Сражение закончилось, победу одержала семья (ID:%d), очки %d", Leader_id, Leader_war);
			    
				SaveFWarOwner(war, Leader_id);

			    Active_war[war] = false;
			    
			    foreach(new playerid:Player)
			    {
			        if(pInfo[playerid][OnFamily]) //делайте проверку фамы на синдиката или еще чо по кайфу
			        {
	        			SCM(playerid, CWHITE, strkbass);
			        
			            GangZoneHideForPlayer(playerid, F_war_zone[war]);

                        if(IsPlayerInArea(playerid, fwarzone_info[war][0],fwarzone_info[war][1], fwarzone_info[war][2], fwarzone_info[war][3]))
			        	{
			            	pInfo[playerid][pFWarPoint] = 0;
			            	pInfo[playerid][pFWar] = 0;
			            	
							TextDrawHideForPlayer(playerid, TD_scoreboard[0]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[1]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[2]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[3]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[4]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[5]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard[6]);

				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][0]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][1]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][2]);
				            TextDrawHideForPlayer(playerid, TD_scoreboard_text[war][3]);

					        PlayerTextDrawHide(playerid, TD_scoreboard_fam_point[playerid]);
						}
			        }
			    }
			}
		}
	}
    //SetTimer("TimerSecondUpdateFWar", 1000, false);
}


forward TimerMinuteUpdateFWar(); //Калибровка времени для точности в секундах
public TimerMinuteUpdateFWar()
{
	new hour, minute;
	gettime(hour, minute);
	if(minute == 35)
	{
	    StartFWar(0, 5);
	    StartFWar(1, 5);
	    StartFWar(2, 5);
	}
	if(minute == 40)
	{
	    StartFWar(3, 10);
	}
	if(minute == 45)
	{
	    StartFWar(4, 15);
	}
}

stock StartFWar(war, time) //war - id сражения // time - длительность сражения в минутах
{
   	Active_war[war] = true;

	new hour, minute;
	gettime(hour, minute);
	F_war_zone_time[war] = minute+time;

	foreach(new playerid:Player)
	{
	    if(pInfo[playerid][OnFamily]) SendPlayerFWar(playerid, war);
	}
}


stock intround(Float: number, round = 10)
{
	return floatround(floatround(number/round)*round);
}

stock SendPlayerFWar(playerid, war)
{
    GangZoneHideForPlayer(playerid, F_war_zone[war]);

    //pInfo[playerid][pFWarPoint] = 0;
    //pInfo[playerid][pFWar] = 0;

    GangZoneShowForPlayer(playerid, F_war_zone[war], CYELLOW);
    GangZoneFlashForPlayer(playerid, F_war_zone[war], CRED);

    new strkbass[100];
    format(strkbass, sizeof strkbass, "Началось сражение за "CY"%s"CW", найдите место проведения с помощью карты", fwar_3dtext_info[war][wName]);
    SCM(playerid, CWHITE, strkbass);
}

stock SetFamilyMemberPoint(war, family)
{
    new point[5];
	format(point, sizeof point, "%d", FamilyWarPoint[war][family]);
	foreach(new playerid:Player)
	{
	    if(pInfo[playerid][pFamilyId] == family)
		{
		    if(pInfo[playerid][pFWar]-1 == war)
		    {
			    PlayerTextDrawSetString(playerid, TD_scoreboard_fam_point[playerid], point);
			}
		}
	}
}

stock SMF(family, str[])
{
	foreach(new playerid:Player)
	{
	    if(pInfo[playerid][pFamilyId] == family)
		{
			SCM(playerid, CWHITE, str);
		}
	}
}


stock CheckIsFamilyWar(war, family)
{
	foreach(new playerid: Player)
	{
	    if(pInfo[playerid][pFamilyId] != family) continue;
        if(IsPlayerInArea(playerid, fwarzone_info[war][0],fwarzone_info[war][1], fwarzone_info[war][2], fwarzone_info[war][3]))
        {
            return true;
        }
	}
	IsFamilyWar[war][family] = false;
	return false;
}

CMD:startzon(playerid, params[])
{
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, CWHITE, "| "CW"[warid 1-5] [time]");
	if(!(0 < params[0] < 6)) return 0;
	if(!(0 < params[1] < 31)) return SCM(playerid, CWHITE, "| "CW"Время от 1 до 30.");
   	StartFWar(params[0]-1, params[1]);
   	SCM(playerid, CWHITE, "| "CW"Война начата.");
   	return 1;
}


stock LoadTextDraw()
{
	TD_scoreboard[0] = TextDrawCreate(132.000000, 278.264434, "usebox");
	TextDrawLetterSize(TD_scoreboard[0], 0.000000, 6.707532);
	TextDrawTextSize(TD_scoreboard[0], 4.800000, 0.000000);
	TextDrawAlignment(TD_scoreboard[0], 1);
	TextDrawColor(TD_scoreboard[0], 0);
	TextDrawUseBox(TD_scoreboard[0], true);
	TextDrawBoxColor(TD_scoreboard[0], -1540674817);
	TextDrawSetShadow(TD_scoreboard[0], 0);
	TextDrawSetOutline(TD_scoreboard[0], 0);
	TextDrawFont(TD_scoreboard[0], 0);

	TD_scoreboard[1] = TextDrawCreate(132.000000, 279.757781, "usebox");
	TextDrawLetterSize(TD_scoreboard[1], 0.000000, 6.556910);
	TextDrawTextSize(TD_scoreboard[1], 5.199998, 0.000000);
	TextDrawAlignment(TD_scoreboard[1], 1);
	TextDrawColor(TD_scoreboard[1], 0);
	TextDrawUseBox(TD_scoreboard[1], true);
	TextDrawBoxColor(TD_scoreboard[1], 255);
	TextDrawSetShadow(TD_scoreboard[1], 0);
	TextDrawSetOutline(TD_scoreboard[1], 0);
	TextDrawFont(TD_scoreboard[1], 0);

	TD_scoreboard[2] = TextDrawCreate(132.000000, 322.068847, "usebox");
	TextDrawLetterSize(TD_scoreboard[2], 0.000000, 0.431973);
	TextDrawTextSize(TD_scoreboard[2], 4.799999, 0.000000);
	TextDrawAlignment(TD_scoreboard[2], 1);
	TextDrawColor(TD_scoreboard[2], 0);
	TextDrawUseBox(TD_scoreboard[2], true);
	TextDrawBoxColor(TD_scoreboard[2], -1540674817);
	TextDrawSetShadow(TD_scoreboard[2], 0);
	TextDrawSetOutline(TD_scoreboard[2], 0);
	TextDrawFont(TD_scoreboard[2], 0);

	TD_scoreboard[3] = TextDrawCreate(132.000061, 336.006652, "usebox");
	TextDrawLetterSize(TD_scoreboard[3], 0.000000, -0.350739);
	TextDrawTextSize(TD_scoreboard[3], 4.800000, 0.000000);
	TextDrawAlignment(TD_scoreboard[3], 1);
	TextDrawColor(TD_scoreboard[3], 0);
	TextDrawUseBox(TD_scoreboard[3], true);
	TextDrawBoxColor(TD_scoreboard[3], -1540674817);
	TextDrawSetShadow(TD_scoreboard[3], 0);
	TextDrawSetOutline(TD_scoreboard[3], 0);
	TextDrawFont(TD_scoreboard[3], 0);


	TD_scoreboard[4] = TextDrawCreate(126.399993, 285.233337, "usebox");
	TextDrawLetterSize(TD_scoreboard[4], 0.065999, 0.672921);
	TextDrawTextSize(TD_scoreboard[4], 103.200004, 0.000000);
	TextDrawAlignment(TD_scoreboard[4], 1);
	TextDrawColor(TD_scoreboard[4], 0);
	TextDrawUseBox(TD_scoreboard[4], true);
	TextDrawBoxColor(TD_scoreboard[4], 505290495);
	TextDrawSetShadow(TD_scoreboard[4], 0);
	TextDrawSetOutline(TD_scoreboard[4], 0);
	TextDrawFont(TD_scoreboard[4], 0);

	TD_scoreboard[5] = TextDrawCreate(126.199989, 301.664459, "usebox");
	TextDrawLetterSize(TD_scoreboard[5], 0.065999, 0.672921);
	TextDrawTextSize(TD_scoreboard[5], 103.200004, 0.000000);
	TextDrawAlignment(TD_scoreboard[5], 1);
	TextDrawColor(TD_scoreboard[5], 0);
	TextDrawUseBox(TD_scoreboard[5], true);
	TextDrawBoxColor(TD_scoreboard[5], 505290495);
	TextDrawSetShadow(TD_scoreboard[5], 0);
	TextDrawSetOutline(TD_scoreboard[5], 0);
	TextDrawFont(TD_scoreboard[5], 0);

	TD_scoreboard[6] = TextDrawCreate(6.799999, 280.255554, "usebox");
	TextDrawLetterSize(TD_scoreboard[6], 0.000000, 0.623579);
	TextDrawTextSize(TD_scoreboard[6], 2.000000, 0.000000);
	TextDrawAlignment(TD_scoreboard[6], 1);
	TextDrawColor(TD_scoreboard[6], 0);
	TextDrawUseBox(TD_scoreboard[6], true);
	TextDrawBoxColor(TD_scoreboard[6], 102);
	TextDrawSetShadow(TD_scoreboard[6], 0);
	TextDrawSetOutline(TD_scoreboard[6], 0);
	TextDrawFont(TD_scoreboard[6], 0);


	for(new war; war < 5; war++) //3 вышки 1 ферма 1 завод
	{
		TD_scoreboard_text[war][0] = TextDrawCreate(47.599990, 318.577789, "3:00");
		TextDrawLetterSize(TD_scoreboard_text[war][0], 0.167999, 1.027554);
		TextDrawAlignment(TD_scoreboard_text[war][0], 1);
		TextDrawColor(TD_scoreboard_text[war][0], -1);
		TextDrawSetShadow(TD_scoreboard_text[war][0], 0);
		TextDrawSetOutline(TD_scoreboard_text[war][0], 1);
		TextDrawBackgroundColor(TD_scoreboard_text[war][0], 51);
		TextDrawFont(TD_scoreboard_text[war][0], 1);
		TextDrawSetProportional(TD_scoreboard_text[war][0], 1);

		TD_scoreboard_text[war][1] = TextDrawCreate(12.400019, 282.000000, "TEXT");
		TextDrawLetterSize(TD_scoreboard_text[war][1], 0.314399, 1.256533);
		TextDrawAlignment(TD_scoreboard_text[war][1], 1);
		TextDrawColor(TD_scoreboard_text[war][1], -1);
		TextDrawSetShadow(TD_scoreboard_text[war][1], 0);
		TextDrawSetOutline(TD_scoreboard_text[war][1], 1);
		TextDrawBackgroundColor(TD_scoreboard_text[war][1], 51);
		TextDrawFont(TD_scoreboard_text[war][1], 1);
		TextDrawSetProportional(TD_scoreboard_text[war][1], 1);
		TextDrawSetString(TD_scoreboard_text[war][1], RusText("Очки вашей семьи:"));

		TD_scoreboard_text[war][2] = TextDrawCreate(12.200020, 298.000000, "TEXT");
		TextDrawLetterSize(TD_scoreboard_text[war][2], 0.314399, 1.256533);
		TextDrawAlignment(TD_scoreboard_text[war][2], 1);
		TextDrawColor(TD_scoreboard_text[war][2], -1);
		TextDrawSetShadow(TD_scoreboard_text[war][2], 0);
		TextDrawSetOutline(TD_scoreboard_text[war][2], 1);
		TextDrawBackgroundColor(TD_scoreboard_text[war][2], 51);
		TextDrawFont(TD_scoreboard_text[war][2], 1);
		TextDrawSetProportional(TD_scoreboard_text[war][2], 1);
		TextDrawSetString(TD_scoreboard_text[war][2], RusText("Лидер сражения:"));

		TD_scoreboard_text[war][3] = TextDrawCreate(113.999999, 298.000000, "0");
		TextDrawLetterSize(TD_scoreboard_text[war][3], 0.216800, 1.176888);
		TextDrawAlignment(TD_scoreboard_text[war][3], 1);
		TextDrawColor(TD_scoreboard_text[war][3], -1);
		TextDrawSetShadow(TD_scoreboard_text[war][3], 0);
		TextDrawSetOutline(TD_scoreboard_text[war][3], 1);
		TextDrawBackgroundColor(TD_scoreboard_text[war][3], 51);
		TextDrawFont(TD_scoreboard_text[war][3], 1);
		TextDrawSetProportional(TD_scoreboard_text[war][3], 1);
	}
}

stock LoadPlayerTextDraw(playerid)
{
	TD_scoreboard_fam_point[playerid] = CreatePlayerTextDraw(playerid, 113.999999, 282.000000, "0");
	PlayerTextDrawLetterSize(playerid, TD_scoreboard_fam_point[playerid], 0.216800, 1.176888);
	PlayerTextDrawAlignment(playerid, TD_scoreboard_fam_point[playerid], 1);
	PlayerTextDrawColor(playerid, TD_scoreboard_fam_point[playerid], -1);
	PlayerTextDrawSetShadow(playerid, TD_scoreboard_fam_point[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TD_scoreboard_fam_point[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TD_scoreboard_fam_point[playerid], 51);
	PlayerTextDrawFont(playerid, TD_scoreboard_fam_point[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TD_scoreboard_fam_point[playerid], 1);
}


stock ConvertMoney(money, string[], length = sizeof string)
{
	format(string, length, "%d", money < 0 ? -money : money);
	for(new i = strlen(string); (i -= 3) > 0;)
	{
	    if(string[i] != '\0' && '0' <= string[i] <= '9')
	    {
	        strins(string, ".", i, length);
	    }
	    else
	    {
	        return;
	    }
	}

	if(money < 0)
	{
	    strins(string, "-", 0, length);
	}
}



stock CheckPlayerDistanceToPoint(playerid, Float:x, Float:y, Float:z, Float: distance)
{
	if(IsPlayerInRangeOfPoint(playerid, distance, x, y, z)) return 1;
	else return 0;
}


stock IsPlayerInArea(playerid, Float:min_x, Float:min_y ,Float:max_x, Float:max_y)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X <= max_x && X >= min_x && Y <= max_y && Y >= min_y) return 1;
	return 0;
}



stock RusText(string[])
{
	new result[256];
	for (new i = 0; i < sizeof(result); i++)
	{
		switch(string[i])
		{
			case 'а': result[i] = 'a';
			case 'А': result[i] = 'A';
			case 'б': result[i] = '—';
			case 'Б': result[i] = 'Ђ';
			case 'в': result[i] = 'ў';
			case 'В': result[i] = '‹';
			case 'г': result[i] = '™';
			case 'Г': result[i] = '‚';
			case 'д': result[i] = 'љ';
			case 'Д': result[i] = 'ѓ';
			case 'е': result[i] = 'e';
			case 'Е': result[i] = 'E';
			case 'ё': result[i] = 'e';
			case 'Ё': result[i] = 'E';
			case 'ж': result[i] = '›';
			case 'Ж': result[i] = '„';
			case 'з': result[i] = 'џ';
			case 'З': result[i] = '€';
			case 'и': result[i] = 'њ';
			case 'И': result[i] = '…';
			case 'й': result[i] = 'ќ';
			case 'Й': result[i] = '…';
			case 'к': result[i] = 'k';
			case 'К': result[i] = 'K';
			case 'л': result[i] = 'ћ';
			case 'Л': result[i] = '‡';
			case 'м': result[i] = 'Ї';
			case 'М': result[i] = 'M';
			case 'н': result[i] = '®';
			case 'Н': result[i] = 'H';
			case 'о': result[i] = 'o';
			case 'О': result[i] = 'O';
			case 'п': result[i] = 'Ј';
			case 'П': result[i] = 'Њ';
			case 'р': result[i] = 'p';
			case 'Р': result[i] = 'P';
			case 'с': result[i] = 'c';
			case 'С': result[i] = 'C';
			case 'т': result[i] = '¦';
			case 'Т': result[i] = 'Џ';
			case 'у': result[i] = 'y';
			case 'У': result[i] = 'Y';
			case 'ф': result[i] = 'Ѓ';
			case 'Ф': result[i] = 'Ѓ';
			case 'х': result[i] = 'x';
			case 'Х': result[i] = 'X';
			case 'ц': result[i] = '‰';
			case 'Ц': result[i] = '‰';
			case 'ч': result[i] = '¤';
			case 'Ч': result[i] = 'Ќ';
			case 'ш': result[i] = 'Ґ';
			case 'Ш': result[i] = 'Ћ';
			case 'щ': result[i] = 'Ў';
			case 'Щ': result[i] = 'Љ';
			case 'ь': result[i] = '©';
			case 'Ь': result[i] = '’';
			case 'ъ': result[i] = 'ђ';
			case 'Ъ': result[i] = '§';
			case 'ы': result[i] = 'Ё';
			case 'Ы': result[i] = '‘';
			case 'э': result[i] = 'Є';
			case 'Э': result[i] = '“';
			case 'ю': result[i] = '«';
			case 'Ю': result[i] = '”';
			case 'я': result[i] = '¬';
			case 'Я': result[i] = '•';
			default: result[i] = string[i];
		}
	}
	return result;
}
