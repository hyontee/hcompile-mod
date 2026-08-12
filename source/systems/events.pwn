/*
if(pTemp[playerid][tPaintTeam] != 0) return SendClientMessage(playerid, COLOR_GREY, !"Ноу юсе");

*/
#define PAINT_BALL_PAYMENT      3000
#define RACE_PAYMENT            1500
#define MAX_PAINT_BALL_PLAYERS  50
#define MAX_RACE_PLAYERS        40 // Макс кол-во участников на Гонках 


//Race
new 
    PlayersInRaceCount,
    PlayerRaceWin; 

new Iterator: RacersList<MAX_PLAYERS>;    
new racee[3];
new raceTime = 1, RaceStarting[3] = 0, typeRace;
new RaceCar[] = {411,562,560,522};
enum E_RACE_LIST {
    raceName[MAX_PLAYER_NAME],
    raceEndTime
};
static const gRaceStats[MAX_RACE_PLAYERS][E_RACE_LIST];
 
static const  defaultRaceStats[E_RACE_LIST] = {
    "None", //raceName[MAX_PLAYER_NAME],
    0 //raceTime
};
new 
    paints[3]; 
/*enum E_PAINT_BALL_LIST {
	pbName[MAX_PLAYER_NAME],
    pbPlayerID,
	pbKills,
	pbDeaths,
    Float: pbKD
};
new pPaintStats[MAX_PAINT_BALL_PLAYERS][E_PAINT_BALL_LIST]; */

new  
    Text: paint_TD[13],
    Text: tRace_TD[10];
new 
    PlayerText: tPaintStats[MAX_PLAYERS],
    PlayerText: tRace_PTD[MAX_PLAYERS]; 

new TimerPaintBall,
	StartPaintBall,
	RedScore,
	BlueScore,
	RedPlayer,
	BluePlayer,
	PaintBallMap ;


new SkinPaint[2][2] = {
    {55, 56},
	{47, 48}
};
new Float: SpawnBlueTeam[2][10][4] = {
	{
		{-2801.7566,-1558.6439,140.7292,2.1118},//les
		{-2834.9138,-1553.3436,140.3487,341.5001},
		{-2856.3674,-1570.9919,141.3133,327.8954},
		{-2827.6458,-1579.4283,141.3203,356.1252},
		{-2805.6375,-1580.6309,141.3203,1.3832},
		{-2786.6289,-1579.2703,141.3300,5.9138},
		{-2787.6526,-1605.9459,141.4236,7.6774},
		{-2801.5774,-1604.0116,141.4267,11.7659},
		{-2831.9187,-1603.2332,141.3323,352.9047},
		{-2818.9546,-1620.7930,141.4647,349.9767}
	},
	{
	    { 2592.5847, 2847.6216, 10.8203, 185.471},//kass
		{ 2612.2883, 2832.2095, 10.8203, 86.4574},
		{ 2613.1196, 2823.4009, 10.8203, 85.5173},
		{ 2609.5974, 2809.9402, 10.8203, 86.1440},
		{ 2613.4524, 2805.5283, 19.9922, 89.2773}, 
		{ 2607.8235, 2825.7415, 19.9999, 91.1574},
		{ 2612.6582, 2848.0586, 19.9922, 92.0974},
		{ 2600.7705, 2847.1016, 10.8203, 130.301},
		{ 2612.2678, 2825.9495, 10.8203, 88.0004},
		{ 2611.1147, 2848.6003, 10.8203, 87.0604}
	}
}; 

new Float: SpawnRedTeam[2][10][4] = {
	{
		{-2802.6504,-1492.4417,139.1176,175.3973},
		{-2845.9958,-1497.7247,137.5006,194.1175},
		{-2852.4460,-1480.0096,136.1986,192.3640},
		{-2831.8931,-1471.3474,136.4821,185.3390},
		{-2806.7224,-1472.2322,137.7370,183.4304},
		{-2784.2095,-1472.9342,137.3327,160.7703},
		{-2798.7026,-1433.0662,136.2958,179.4868},
		{-2826.6138,-1434.2772,136.5237,183.7270},
		{-2841.1321,-1441.3585,136.4133,181.3916},
		{-2863.4673,-1459.1554,136.0605,200.9771}
	},
	{
		{ 2542.7991, 2847.2407, 10.8203, 268.7954},
		{ 2540.2661, 2839.1558, 10.8203, 179.4944},
		{ 2540.5356, 2829.4094, 10.8203, 179.8078},
		{ 2540.6689, 2815.7881, 10.8203, 180.4345},
		{ 2542.4656, 2806.8003, 10.8203, 264.7219},
		{ 2555.8899, 2805.3899, 10.8203, 265.6620},
		{ 2561.2595, 2819.0681, 10.8203, 1.8562},
		{ 2561.0940, 2824.5334, 10.8203, 357.4695},
		{ 2567.1072, 2827.8271, 10.8203, 270.3621},
		{ 2573.0317, 2822.0977, 10.8203, 271.9290}
	}
};
static const  Float:spawn_car [2] [40] [4] =
{
	{
		{2091.895263,-2520.565185,13.433180,37.902584}, {2094.764160,-2518.331298,13.433194,37.902797}, {2097.488037,-2516.210937,13.433210,37.903057}, 
        {2100.653076,-2513.746093,13.433222,37.903259}, {2104.851806,-2510.477783,13.433242,37.903450}, {2107.984619,-2507.750732,13.433382,38.896286},
		{2111.420898,-2505.282226,13.433529,44.362625}, {2119.425537,-2518.171386,13.437009,21.364038}, {2114.278076,-2520.184326,13.437017,21.363973}, 
        {2109.155517,-2523.806152,13.439718,21.364025}, {2103.543212,-2526.568603,13.439425,21.364072}, {2098.313232,-2530.997314,13.438414,21.364183},
		{2097.627441,-2540.054931,13.440947,21.364278}, {2101.975830,-2539.262207,13.440667,21.364345}, {2105.375244,-2538.512207,13.440439,21.364418}, 
        {2108.870117,-2537.145019,13.440454,21.364492}, {2113.717041,-2535.249755,13.440456,21.364530}, {2118.462158,-2533.393798,13.440476,21.364578},
		{2123.893066,-2544.668457,13.433508,3.160697}, {2119.953613,-2544.885742,13.435308,3.160687}, {2116.225341,-2547.537109,13.434331,3.160625}, 
        {2111.804199,-2547.658203,13.434389,3.160687}, {2105.874023,-2549.084472,13.434020,3.160563}, {2100.804199,-2549.364013,13.434053,3.160625},
		{2093.775634,-2556.532958,13.431475,3.160563}, {2099.526367,-2558.672119,13.430426,3.160625}, {2103.135009,-2558.473388,13.886198,3.160563}, 
        {2111.609130,-2558.004394,13.886105,3.160563}, {2116.906005,-2557.713134,13.886048,3.160563}, {2113.164550,-2571.723876,13.441659,321.873443},
		{2106.754638,-2569.824951,13.825028,321.873382}, {2101.283691,-2568.904785,13.956215,321.873382}, {2094.681884,-2563.722900,13.956216,321.873382}, 
        {2088.453857,-2571.658203,13.952000,321.873382}, {2091.333496,-2576.226562,13.951242,321.873382}, {2094.020751,-2580.314453,13.950592,321.873382},
		{2097.216552,-2589.722900,14.985203,321.873687}, {2077.217773,-2598.296386,13.440001,268.024841}, {2076.595947,-2592.791503,13.422363,268.021179}, {2074.781738,-2584.226318,13.421342,268.021179}
	},
	{
		{672.2044,2103.3127,16.2470,177.8561}, {668.3824,2102.3796,16.2030,177.0146}, {664.0132,2102.1299,16.2054,179.0928}, 
        {659.5983,2102.0122,16.1971,178.9829}, {655.3647,2101.7991,16.2386,180.9504}, {650.8540,2101.2305,16.2347,183.3866},
		{650.2929,2111.7456,17.0781,182.7519}, {654.9857,2111.5193,16.9867,179.6493}, {659.1634,2111.3586,16.9531,180.4426}, 
        {663.5944,2111.7275,16.9409,181.3633}, {666.9539,2111.4771,16.9481,180.1949}, {670.0529,2111.6252,16.9527,179.8351},
		{674.6517,2111.3140,16.8065,177.6580}, {674.8973,2119.1531,17.5570,177.8308}, {670.7462,2119.1599,17.5815,178.6785}, 
        {667.4767,2118.9365,17.4795,180.1411}, {663.5541,2118.9109,17.5459,179.1588}, {659.3839,2118.8687,17.5921,180.8173},
		{656.5150,2118.7117,17.5908,181.3367}, {653.0975,2118.6082,17.6121,179.7124}, {653.1479,2124.6274,18.1142,179.5998}, 
        {657.8023,2124.9504,18.0880,180.6734}, {661.5770,2124.6272,18.0182,180.6442}, {664.9161,2124.1855,18.0260,181.8698},
		{668.1638,2123.9641,17.9031,179.0754}, {671.7554,2123.6523,17.8501,176.6323}, {676.2199,2123.3462,17.8528,175.2501}, 
        {676.4521,2131.1335,18.5533,178.2869}, {673.6086,2131.8088,18.5686,177.4951}, {669.5196,2131.8982,18.6098,177.0708},
		{666.6295,2131.7405,18.6057,177.4690}, {663.1808,2131.7803,18.6541,180.2207}, {660.2335,2131.7568,18.7080,180.0066}, 
        {656.9416,2131.7266,18.7175,180.9920}, {654.2312,2131.5225,18.6418,184.7503}, {649.9846,2131.2620,18.7229,183.1566},
		{650.8186,2137.2646,19.0700,180.7624}, {655.8868,2137.0403,19.0259,181.0888}, {663.0311,2137.3953,19.0177,180.3358}, {672.3614,2137.4355,19.0051,179.1938}
	}
};
static const  Float:los_santos_race [2] [52] [3] =
{
	{
		{2068.331542,-2486.419189,13.384812}, {1999.593872,-2443.603515,13.390092}, {1975.960693,-2339.038574,13.389539}, 
        {1974.702636,-2264.686767,13.389196}, {1971.640136,-2207.681640,13.388321}, {1917.494628,-2164.439453,13.225696}, 
        {1835.689331,-2164.458984,13.225584}, {1690.865234,-2165.281250,16.534917}, {1561.424682,-2102.565917,33.548648}, 
        {1534.903198,-2038.627441,30.559921}, {1531.514648,-1925.844116,15.948495}, {1423.284545,-1871.391845,13.225830},
		{1333.105590,-1853.432861,13.231085}, {1198.192626,-1852.575561,13.236808}, {1072.954833,-1851.229614,13.233303}, 
        {1003.930236,-1793.053222,13.893136}, {860.259521,-1771.445312,13.225211}, {703.481445,-1745.561035,13.644369}, 
        {512.652648,-1713.879150,11.951225}, {322.898925,-1700.012817,6.351512}, {181.994613,-1590.681640,13.611264}, 
        {114.987060,-1483.881469,15.716488}, {183.274917,-1392.328613,47.316024}, {235.005859,-1312.519897,54.946090}, 
        {271.210632,-1238.301635,73.749771}, {352.619964,-1172.180297,76.992782}, {373.219757,-1108.971069,74.678642}, 
        {570.886535,-1040.667602,72.893234}, {681.720703,-987.671081,51.723533}, {636.893554,-893.615478,36.238845}, 
        {614.952941,-761.974304,16.934080}, {695.729675,-834.909667,42.609966}, {765.860534,-907.398254,43.168628}, 
        {793.615112,-1049.253906,24.705514}, {796.494628,-1348.491088,13.225209}, {773.605712,-1551.007446,13.219964}, 
        {829.991271,-1606.236572,13.225358},{915.885864,-1572.501342,13.225023}, {1005.193664,-1573.730346,13.225335},
		{1061.528442,-1571.466918,13.002437}, {1132.829345,-1571.714599,12.952020}, {1149.645874,-1663.695434,13.404994}, 
        {1170.087524,-1745.639404,13.021311}, {1172.646362,-1850.471069,13.023327}, {1315.715576,-1855.433837,13.006551}, 
        {1410.950927,-1873.858398,13.006618}, {1532.403076,-1980.743652,22.644147}, {1568.543945,-2112.455322,32.572132}, 
        {1665.617553,-2161.764160,19.083341},
		{1798.388549,-2167.987548,13.006500}, {1917.365234,-2167.838378,13.006553}, {1963.080810,-2218.701660,15.749450}
	},
	{
		{662.1136,2010.5905,8.3228}, {657.7353,1872.6897,5.1959}, {586.1057,1714.4578,7.7091}, 
        {418.1154,1599.8905,17.4339}, {297.1648,1265.8134,14.1913}, {177.7255,1147.1879,13.9948}, 
        {102.8310,1198.1205,18.1525}, {-70.6931,1198.8982,19.3593}, {-267.0687,1197.7285,19.3208}, 
        {-285.8788,1146.9034,19.3216}, {-346.1357,1113.2706,19.3208}, {-278.4934,1053.4348,19.3162},
		{-196.7210,1005.2441,19.2968}, {-287.8996,812.8679,14.2512}, {-118.4552,813.8665,20.2630}, 
        {-280.5372,686.1677,18.6626}, {-135.5672,613.9775,1.8051}, {-157.0415,408.2657,11.8052}, 
        {-233.1215,167.2598,4.6665}, {-259.8236,-270.1633,1.1824}, {-639.3168,-243.3178,63.0318}, 
        {-948.3567,-242.7244,37.5659},
		{-1040.6711,-452.4373,35.6779}, {-1205.6786,-742.9162,59.9608}, {-1456.2135,-818.1087,73.2588}, 
        {-1761.9790,-692.2874,25.2470}, {-1786.9010,-580.0756,16.0630}, {-1912.3389,-580.1558,24.1691}, 
        {-2169.7244,-479.2166,45.1492}, {-2256.6597,-146.2213,34.8988}, {-2371.9287,502.8568,29.2342}, 
        {-2386.4546,622.7631,32.2222},
		{-2397.6143,708.7435,34.7408}, {-2528.8259,707.2769,27.5800}, {-2751.2197,715.6112,40.8544},
		{-2762.5669,808.2616,52.5233}, {-2807.7095,892.2084,43.6334},{-2881.6519,1074.9255,30.5571}, {-2706.0959,1290.5035,6.7805},
		{-2455.3774,1332.6726,9.8476}, {-2488.4287,1190.7368,37.1849}, {-2675.3164,1330.7024,55.1568}, 
        {-2675.8245,1619.2803,64.8538}, {-2676.9116,2083.7742,55.1786}, {-2737.1616,2354.3936,71.7937}, 
        {-2345.4705,2635.2644,53.5232}, {-1944.3154,2472.3635,54.5395}, {-1705.3647,2151.8735,17.8462}, {-1566.9766,1912.0879,24.0401},
		{-1396.4218,1852.4491,36.0523}, {-1028.8517,1853.8967,59.9197}, {-873.0335,1992.7505,60.0198}
	}
};
new paintball_bank;


Event_SecondTimer() {
    if(RaceStarting[0] > 0) {
		RaceStarting[0]--;
        new 
            raceMapName[][32] = {"Wolking Street Race", "Las-Venturas / San-Fierro Race"},
            string_[128]; 
		if(RaceStarting[0] == 120) {
            
            format(string_, sizeof string_, "Внимание! Начало гонок через 2 минуты. Трасса: %s. (( /gps - Развлечения ))", raceMapName[typeRace]);
            SendClientMessageToAll(0xB9B900AA, string_); 
			
		}
		if(RaceStarting[0] == 2 && PlayersInRaceCount > 1 && RaceStarting[2] == 3) { 
            format(string_, sizeof string_, "Внимание! Гонки начались. Трасса: %s", raceMapName[typeRace]);
            SendClientMessageToAll(0xB9B900AA, string_); 
			SetTimer("SecondStartedRaces", 1100, false);
			RaceStarting[0] = 0; RaceStarting[1] = 11;
		}
		else if(RaceStarting[2] == 3 && PlayersInRaceCount < 4 && RaceStarting[0] == 2) {
			SendClientMessageToAll(0xB9B900AA, !"Гонка отменена из - за недостаточного количества участников");
			RaceStarting[2] = 0; RaceStarting[0] = 0; raceTime = 1; PlayersInRaceCount = 0; typeRace = 3;
			foreach(new i: Player)
			{
				if(!pTemp[i][tRacePlayer]) continue;
				pTemp[i][tRacePlayer] = false;
				Iter_Remove(RacersList, i);
			}
		}
	} 
    if(RaceStarting[2] == 1)
	{
		raceTime ++; 
		foreach(new i: RacersList)
		{
			if(!pTemp[i][tRacePlayer]) continue;
            UpdateRaceStats(i); 
		}
	}
    if(TimerPaintBall && (StartPaintBall == 1 || StartPaintBall == 2))
 	{
	 	TimerPaintBall--;
		if(TimerPaintBall == 120) { 
            new 
				paintMapName[][32] = {"Лес", "Военный завод К.А.С.С"},
				string_[128]; 
			format(string_, sizeof string_, "Внимание! Начало пейнтболла через 2 минуты. Место проведения: %s (( /gps - Развлечения ))", paintMapName[PaintBallMap-1]);
			SendClientMessageToAll(0xFFAAFFAA, string_);  
		}
 	    if(StartPaintBall == 2)
 	    {
 			new 
                str_[64];  
            format(str_, sizeof str_, "%04d_~r~Red", RedScore );
            TextDrawSetString(paint_TD[5], str_); 

            format(str_, sizeof str_, "%04d_~b~Blue", BlueScore );
            TextDrawSetString(paint_TD[8], str_); 
            
            format(str_, sizeof str_, "%s", Converts(TimerPaintBall));
            TextDrawSetString(paint_TD[11], str_);  
 	    }
		else if (StartPaintBall == 1)
		{
			if(TimerPaintBall == 5)
			{
				if ( ! RedPlayer || ! BluePlayer )
				{
					foreach(new i: PlayerInLogin)
					{
						if (pTemp[i][tPaintTeam] != 0)
						{
							pTemp[i][tPaintTeam] = 0;
                            kLibGivePlayerMoney(i, PAINT_BALL_PAYMENT, "return money PD"); 
						}
					}
					StartPaintBall  =
					RedScore        =
					BlueScore       =
					RedPlayer       =
					BluePlayer      = 0; 
					SendClientMessageToAll(0xFFAAFFAA, !"Матч по пейнтболу отменен из-за недостаточного количества участников"); 
				}
				else
				{ 
					foreach(new i: PlayerInLogin)
					{
						if(pTemp[i][tPaintTeam])
						{
							SetPlayerHealth(i, 100.0);
							SetPlayerSkin(i, SkinPaint[ pInfo[i][pSex] ][ pTemp[i][tPaintTeam] - 1 ] ); 
                            new 
                                rand = random(10); 
							switch(pTemp[i][tPaintTeam])
							{
								case 1:
								{
                                    SetPlayerPosAC(i, SpawnBlueTeam[PaintBallMap-1][rand][0], SpawnBlueTeam[PaintBallMap-1][rand][1], SpawnBlueTeam[PaintBallMap-1][rand][2], 10, 0); 
                                    pTemp[i][tVirtualWorld] = 10;
                                    pTemp[i][tInterior] = INTERIOR_NONE;
									SetPlayerColor(i, 0x33AAFFFF); // Blue
								}
								case 2:
								{ 
                                    SetPlayerPosAC(i, SpawnRedTeam[PaintBallMap-1][rand][0], SpawnRedTeam[PaintBallMap-1][rand][1], SpawnRedTeam[PaintBallMap-1][rand][2], 10, 0); 
                                    pTemp[i][tVirtualWorld] = 10;
                                    pTemp[i][tInterior] = INTERIOR_NONE;
									SetPlayerColor(i, 0xAA3333FF) ;// red

								}
							}
                            for(new td; td < sizeof (paint_TD); td++) {
                                TextDrawShowForPlayer(i, paint_TD[td]); 
                            }    
							tPaintStats[i] = CreatePlayerTextDraw(i, 284.4666, 369.4144, "0000_0000_00000_1.0"); // пусто
                            PlayerTextDrawLetterSize(i, tPaintStats[i], 0.1706, 0.8183);
                            PlayerTextDrawAlignment(i, tPaintStats[i], 1);
                            PlayerTextDrawColor(i, tPaintStats[i], COLOR_SERVER);
                            PlayerTextDrawSetShadow(i, tPaintStats[i], -1);
                            PlayerTextDrawBackgroundColor(i, tPaintStats[i ], -754100980);
                            PlayerTextDrawFont(i, tPaintStats[i], 1);
                            PlayerTextDrawSetProportional(i, tPaintStats[i ], 1);
                            PlayerTextDrawSetShadow(i, tPaintStats[i], 0);


							PlayerTextDrawShow (i, tPaintStats[i]);

							TogglePlayerControllable(i, 0);
							ResetPlayerWeapons(i) ;
                            GivePlayerWeapon(i, 24, 1000);
                            GivePlayerWeapon(i, 25, 1000);
                            GivePlayerWeapon(i, 31, 1000); 
                            SendClientMessage(i, COLOR_YELLOW, !"[Подсказка] "colwhi"Для выхода из PaintBall, Используйте: "colserver"\"/paintexit\"");
						}
					}
				}
			}
		}
   	}
	if(TimerPaintBall <= 0 && StartPaintBall == 1)
	{
		StartPaintBall = 2;
		TimerPaintBall = 300;
		RedScore    =
		BlueScore   =
		RedPlayer   =
		BluePlayer  = 0;
        SendClientMessageToAll(0xFFAAFFAA, !"Внимание! Матч по Пейнтболлу начался!"); 
		foreach(new i: PlayerInLogin)
		{
		    if(pTemp[i][tPaintTeam])
		    {
				GameTextForPlayer(i, "~g~~h~~h~START", 2000, 4);
				TogglePlayerControllable(i, 1);
			}
		}
	}

	if (StartPaintBall == 2 && TimerPaintBall <= 0)
	{
		foreach(new i: PlayerInLogin)
		{
		    if (pTemp[i][tPaintTeam] > 0)
		    {
			    SetPlayerHealth(i, 100);
	   			ResetPlayerWeapons(i);
                if (pInfo[i][pMember] && pTemp[i][tDutyWork]) {
                    SetPlayerColor(i, gFractionColor[pInfo[i][pMember]]);
                    SetPlayerSkinEx(i, pInfo[i][pModel]);
                }
                else {
                    SetPlayerColor(i, gFractionColor[0]);
                    SetPlayerSkinEx(i, pInfo[i][pChar][0]);
                }  
                SetPlayerPosAC(i, 286.1364, -30.7176, 1001.5156, 1, 1);
				SetPlayerFacingAngle(i, 181.0381); 
				for(new td; td < sizeof (paint_TD); td++) {
                    TextDrawHideForPlayer(i, paint_TD[td]); 
                }    
                PlayerTextDrawDestroy (i, tPaintStats[i]);
				tPaintStats[i] = PlayerText:-1;

				/*for (new j = 0 ; j < 5 ; j ++ ) { 
                    SendDeathMessageToPlayer(i, INVALID_PLAYER_ID-1, INVALID_PLAYER_ID-1, 0);
                }*/


				switch(pTemp[i][tPaintTeam])
				{
					case 1:
					{
						if ( BlueScore > RedScore )
						{
							if ( BluePlayer == 0 ) BluePlayer = 1 ;
							if ( RedPlayer == 0 ) RedPlayer = 1 ;
							new pay_money ;
							switch ( pTemp[i][tPaintTeam] )
							{
								case 1: pay_money = paintball_bank / BluePlayer ;
								case 2: pay_money = paintball_bank / RedPlayer ;
							}
                            kLibGivePlayerMoney(i, pay_money, "Win Team PB"); 

							new 
                                string_[128];
							format(string_, sizeof string_, 
                                "[Поздравляем] "colwhi"Ваша команда победила! Ваш приз составил: "collime"$%d.", pay_money
                            );
							SendClientMessage (i, COLOR_LI_RED, string_);
						}
					}
					case 2:
					{
						if (BluePlayer == 0) BluePlayer = 1;
						if (RedPlayer == 0) RedPlayer = 1;
						if (BlueScore < RedScore )
						{
							new pay_money ;
							switch ( pTemp[i][tPaintTeam] )
							{
								case 1: pay_money = paintball_bank / BluePlayer ;
								case 2: pay_money = paintball_bank / RedPlayer ;
							}
                            kLibGivePlayerMoney(i, pay_money, "Win Team PB"); 
							new 
                                string_[128];
							format(string_, sizeof string_, 
                                "[Поздравляем] "colwhi"Ваша команда победила! Ваш приз составил: "collime"$%d.", pay_money
                            );
							SendClientMessage (i, COLOR_LI_RED, string_);
						}
					}
				}

				pTemp[i][tPaintTeam] = pTemp[i][tPaintKills] = pTemp[i][tPaintDeath] = 0;
                pTemp[i][tPaintDMG] = 0.0;
			}
		}
		paintball_bank  = 0;
		StartPaintBall  = 
        RedScore        =
        BlueScore       =	
        RedPlayer       =	
        BluePlayer      = 0;
        SendClientMessageToAll(0xFFAAFFAA, !"Внимание! Пейнтболл окончен"); 
	} 
    if ( minute == 25 && second == 0 && ( hour == 12 || hour == 14 || hour == 16 || hour == 18 || hour == 20 || hour == 22 || hour == 0 || hour == 2 || hour == 4 || hour == 6 || hour == 8 || hour == 10 ) && StartPaintBall == 0)
	{
		TimerPaintBall = 300;
		StartPaintBall = 1;
		RedScore    = 
        BlueScore   = 
        RedPlayer   = 
        BluePlayer  = 0;

		if ( ++ PaintBallMap > 2) PaintBallMap = 1;
		foreach(new i: PlayerInLogin)
		{
			if (pTemp[i][tPaintTeam])
			{
                pTemp[i][tPaintTeam] = pTemp[i][tPaintKills] = pTemp[i][tPaintDeath] = 0; 
                pTemp[i][tPaintDMG] = 0.0; 
                SetPlayerPosAC(i, 286.1364, -30.7176, 1001.5156, 1, 1);
                SetPlayerFacingAngle(i, 181.0381);
			}
		}
		new 
			paintMapName[][32] = {"Лес", "Военный завод К.А.С.С"},
			string_[128]; 
		format(string_, sizeof string_, "Внимание! Начало пейнтболла через 5 минут. Место проведения: %s (( /gps - Развлечения ))", paintMapName[PaintBallMap-1]);
		SendClientMessageToAll(0xFFAAFFAA, string_);    
	}
    if (minute == 25 && second == 0 && (hour == 11 || hour == 13 || hour == 15 || hour == 17 || hour == 19 || hour == 21 || hour == 23 || hour == 1 || hour == 3 || hour == 7 || hour == 9) && RaceStarting[2] == 0)
	{
		RaceStarting[2] = 3, RaceStarting[0] = 300; 
        switch(random(3)) {
			case 0, 3: typeRace = 0;
			default: typeRace = 1;
		} 
        new 
            raceMapName[][32] = {"Wolking Street Race", "Las-Venturas / San-Fierro Race"},
			string_[128];  
        format(string_, sizeof string_, "Внимание! Начало гонок через 5 минут. Трасса: %s. (( /gps - Развлечения ))", raceMapName[typeRace]);
        SendClientMessageToAll(0xB9B900AA, string_);  
	}  
}
Event_OnPlayerDisconnect(playerid) {
    if (pTemp[playerid][tRacePlayer] && RaceStarting[2] == 1)
	{
		Iter_Remove(RacersList, playerid);
		PlayersInRaceCount--;
		pPressed[playerid] = 0; 
        for(new td; td < sizeof (tRace_TD); td++) {
            TextDrawHideForPlayer(playerid, tRace_TD[td]); 
        }   
        PlayerTextDrawHide(playerid, tRace_PTD[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		pTemp[playerid][tRacePlayer] = false;
        if (pTemp[playerid][tRaceVehicleID] != INVALID_VEHICLE_ID) {
            DestroyVehicle(pTemp[playerid][tRaceVehicleID]);
            pTemp[playerid][tRaceVehicleID] = INVALID_VEHICLE_ID;
        }
		
        new 
            string_[128];
		format(string_, sizeof string_,"[Race Оповещение]: "colwhi"%s[%d] покинул игру. Участников: %d", pInfo[playerid][pName], playerid, PlayersInRaceCount);
		RaceChat(COLOR_LI_RED, string_);
		if (PlayersInRaceCount == 0)
		{
			raceTime = 1;
			PlayersInRaceCount = 0;
			SendClientMessageToAll(COLOR_YELLOW, "Информация: Гонка окончена, все участники покинули игру.");
			foreach(new s: RacersList) {
				for(new td; td < sizeof (tRace_TD); td++) {
                    TextDrawHideForPlayer(s, tRace_TD[td]); 
                }   
                PlayerTextDrawHide(s, tRace_PTD[s]);
				pPressed[s] = 0;
				pTemp[s][tRacePosition] = 0;
				Iter_Remove(RacersList, s);
			}
			RaceStarting[2] = 0;
			typeRace = 3;
			//state RaceStarted:No;
		}
	}
    if(RaceStarting[2] == 3 && pTemp[playerid][tRacePlayer])
	{
		pTemp[playerid][tRacePlayer] = false;
		Iter_Remove(RacersList, playerid);
		pPressed[playerid] = 0;
		PlayersInRaceCount --;
		pTemp[playerid][tRacePosition] = 0;
	}
	
	if (pTemp[playerid][tPaintTeam] > 0) {
		ResetPlayerWeapons(playerid);
		for(new td; td < sizeof (paint_TD); td++) {
			TextDrawHideForPlayer(playerid, paint_TD[td]); 
		}    
		PlayerTextDrawDestroy (playerid, tPaintStats[playerid]);
		tPaintStats[playerid] = PlayerText:-1;
	}
    return true;
}
EV_OnPlayerEnterRaceCheckpoint(playerid)
{
    
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(pTemp[playerid][tRaceVehicleID] == GetPlayerVehicleID(playerid))
		{
			if (pTemp[playerid][tRacePlayer])
			{
                new 
                    string_[128];  
				if (++pPressed[playerid] == 52)
				{
                      
					switch (++PlayerRaceWin)
					{
					    case 1: { //Give Money
							format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] финишировал "collime"1-ым в гонке! "colwhi"Выйграл: "collime"$50000", pInfo[playerid][pName], playerid);
							RaceChat(COLOR_LI_RED, string_); 
                            kLibGivePlayerMoney(playerid, 50000, "Win Race 1");
                            SetMoveCashServer(IN_SERVER, 50000);
						}
					    case 2: {
							format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] финишировал "collime"2-ым в гонке! "colwhi"Выйграл: "collime"$30000", pInfo[playerid][pName], playerid);
							RaceChat(COLOR_LI_RED, string_);
                            kLibGivePlayerMoney(playerid, 30000, "Win Race 2");
                            SetMoveCashServer(IN_SERVER, 30000);
						}
					    case 3: {
							format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] финишировал "collime"3-им в гонке! "colwhi"Выйграл: "collime"$15000", pInfo[playerid][pName], playerid);
							RaceChat(COLOR_LI_RED, string_);
                            kLibGivePlayerMoney(playerid, 15000, "Win Race 2");
                            SetMoveCashServer(IN_SERVER, 15000);
						} 
                        default: {
                            format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] финишировал "collime"%d в гонке! ", pInfo[playerid][pName], playerid, PlayerRaceWin);
							RaceChat(COLOR_LI_RED, string_);
                        }
					} 
                    strmid(gRaceStats[PlayerRaceWin -1][raceName], pInfo[playerid][pName], 0, strlen(pInfo[playerid][pName]), MAX_PLAYER_NAME);
                    gRaceStats[PlayerRaceWin -1][raceEndTime] = raceTime;
                    
					Iter_Remove(RacersList, playerid);
					PlayersInRaceCount --;
					pPressed[playerid] = 0;
					for(new td; td < sizeof (tRace_TD); td++) {
                        TextDrawHideForPlayer(playerid, tRace_TD[td]); 
                    }   
                    PlayerTextDrawHide(playerid, tRace_PTD[playerid]);
                    if (pTemp[playerid][tRaceVehicleID] != INVALID_VEHICLE_ID) {
                        DestroyVehicle(pTemp[playerid][tRaceVehicleID]);
                        pTemp[playerid][tRaceVehicleID] = INVALID_VEHICLE_ID;
                    }
                    SetPlayerPosAC(playerid, 831.7769, 6.8750, 1004.1797, 1, 3); 
					SetPlayerFacingAngle(playerid, 108.1610); 
					pTemp[playerid][tRacePlayer] = false;
					if (PlayersInRaceCount == 0)
					{
						raceTime = 1;
						PlayerRaceWin       =
						PlayersInRaceCount  = 0;
						foreach(new i: RacersList)
						{
							pPressed[i] = 0;
							pTemp[i][tRacePosition] = 0;
							Iter_Remove(RacersList, i);
						}
                        SendClientMessageToAll(0xB9B900AA,!"Внимание! Гонки окончены. (( Список победителей: /racelist ))"); 
						RaceStarting[2] = 0;
						typeRace = 3; 
					}
                    return 1;
				}
				else
				{
					foreach(new i: RacersList)
					{
						if (i != -1 && pPressed[playerid] > pPressed[i] && i != playerid)
						{
							pTemp[playerid][tRacePosition]++;
							pTemp[i][tRacePosition]--;
						}
						break;
					}
                    new idx = pPressed[playerid];
					if(idx < 51) {
                        SetPlayerRaceCheckpoint(playerid, 0, 
                            los_santos_race[typeRace][idx][0], los_santos_race[typeRace][idx][1], los_santos_race[typeRace][idx][2], 
                            los_santos_race[typeRace][idx+1][0], los_santos_race[typeRace][idx+1][1], los_santos_race[typeRace][idx+1][2], 
                            10.0
                        );
                    }
					else SetPlayerRaceCheckpoint(playerid, 1, los_santos_race[typeRace][idx][0], los_santos_race[typeRace][idx][1], los_santos_race[typeRace][idx][2], 0.0, 0.0, 0.0, 10.0);  
                    UpdateRaceStats(playerid);
                    return 1;
				}
			}
		}
	}
	return 0;
}
Event_OnPlayerExitVehicle(playerid)
{ 
	if (pTemp[playerid][tRacePlayer] && RaceStarting[2] == 1)
	{
		Iter_Remove(RacersList, playerid);
		PlayersInRaceCount --;
		pPressed[playerid] = 0;
		for(new td; td < sizeof (tRace_TD); td++) {
            TextDrawHideForPlayer(playerid, tRace_TD[td]); 
        }   
        PlayerTextDrawHide(playerid, tRace_PTD[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		pTemp[playerid][tRacePlayer] = false;
		if (pTemp[playerid][tRaceVehicleID] != INVALID_VEHICLE_ID) {
            DestroyVehicle(pTemp[playerid][tRaceVehicleID]);
            pTemp[playerid][tRaceVehicleID] = INVALID_VEHICLE_ID;
        }
        new 
            string_[128];
        format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] покинул свой ТС!. Участников: %d", pInfo[playerid][pName], playerid, PlayersInRaceCount);
        RaceChat(COLOR_LI_RED, string_); 
		if (PlayersInRaceCount == 0)
		{
			raceTime = 1;
			PlayersInRaceCount = 0;
            SendClientMessageToAll(0xB9B900AA,!"Гонка отменена участники покинули свои транспортные средства"); 
			foreach(new s: RacersList)
			{
				for(new td; td < sizeof (tRace_TD); td++) {
                    TextDrawHideForPlayer(playerid, tRace_TD[td]); 
                }   
                PlayerTextDrawHide(playerid, tRace_PTD[playerid]);
				pPressed[s] = 0;
				pTemp[s][tRacePosition] = 0;
				Iter_Remove(RacersList, s);
			}
			RaceStarting[2] = 0;
			typeRace = 3;
			//state RaceStarted:No;
		}
		SetPlayerPosAC(playerid, 831.7769, 6.8750, 1004.1797, 1, 3); 
        SetPlayerFacingAngle(playerid, 108.1610);
        return 1;
	}
	return 0;
}
Event_OnPlayerDeath(playerid, killerid, reason) {
    //#undef reason
    if(RaceStarting[2] == 3 && pTemp[playerid][tRacePlayer])
	{
		pTemp[playerid][tRacePlayer] = false;
		Iter_Remove(RacersList, playerid);
		pPressed[playerid] = 0;
		PlayersInRaceCount --;
		pTemp[playerid][tRacePosition] = 0;
	}
    if (pTemp[playerid][tRacePlayer] && RaceStarting[2] == 1)
	{
		SetPVarInt(playerid, "AntiDeathRace", 1);
		Iter_Remove(RacersList, playerid);
		PlayersInRaceCount --;
		pPressed[playerid] = 0;
		for(new td; td < sizeof (tRace_TD); td++) {
            TextDrawHideForPlayer(playerid, tRace_TD[td]); 
        }   
        PlayerTextDrawHide(playerid, tRace_PTD[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		pTemp[playerid][tRacePlayer] = false;
		if (pTemp[playerid][tRaceVehicleID] != INVALID_VEHICLE_ID) {
            DestroyVehicle(pTemp[playerid][tRaceVehicleID]);
            pTemp[playerid][tRaceVehicleID] = INVALID_VEHICLE_ID;
        }
        new 
            string_[128];
        format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] разбился!. Участников: %d", pInfo[playerid][pName], playerid, PlayersInRaceCount);
        RaceChat(COLOR_LI_RED, string_); 
		if (!PlayersInRaceCount)
		{
			raceTime = 1;
			PlayersInRaceCount = 0;
			SendClientMessageToAll(0xB9B900AA,!"Гонка отменена участники покинули свои транспортные средства"); 
			foreach(new s: RacersList)
			{
				for(new td; td < sizeof (tRace_TD); td++) {
                    TextDrawHideForPlayer(s, tRace_TD[td]); 
                }   
                PlayerTextDrawHide(s, tRace_PTD[s]);
				pPressed[s] = 0;
				pTemp[s][tRacePosition] = 0;
				Iter_Remove(RacersList, s);
			}
			RaceStarting[2] = 0;
			typeRace = 3;
			//state RaceStarted:No;
		}
	}
    if (pTemp[playerid][tPaintTeam])
	{
		switch(StartPaintBall)
		{
			case 1: {
				switch (pTemp[playerid][tPaintTeam]) {
					case 1: BluePlayer -- ;
					case 2: RedPlayer -- ;
				}
				pTemp[playerid][tPaintTeam]   =
				pTemp[playerid][tPaintKills]   =
				pTemp[playerid][tPaintDeath]  = 0;
                pTemp[playerid][tPaintDMG] = 0.0;
                SendClientMessage (playerid, COLOR_LI_RED, "[Оповещение] "colwhi"Вы были дисквалифицированы"); 
			}
			case 2: {
				if(pTemp[killerid][tPaintTeam] != 0 && pTemp[killerid][tPaintTeam] != pTemp[playerid][tPaintTeam])
				{
					pTemp[playerid][tPaintDeath] ++;
					pTemp[killerid][tPaintKills] ++;
					SetPlayerHealth(killerid, 100.0);
					if (pTemp[killerid][tPaintTeam] == 1) BlueScore++;
					else RedScore++ ;
					new 
                        str_[40];

					
                    UpdatePlayerPaintScore(playerid);
                    UpdatePlayerPaintScore(killerid); 

					format(str_, sizeof str_,"~r~~h~%s_KILLED_YOU", pInfo[killerid][pName]);
					GameTextForPlayer(playerid, str_, 3_000, 3 ) ;

                    //GameTextForPlayer(issuerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~ANTI_CIVIL_KILL", 2000, 3);
					GameTextForPlayer(killerid, !"~g~+1 Kill", 2_000, 1 ) ;

					foreach(new i: PlayerInLogin) {
						if (pTemp[i][tPaintTeam] != 0) SendDeathMessageToPlayer ( i, killerid, playerid, reason ) ;
					}
				}
			}
		}
	}
    return 1;
}
/*Event_OnPlayerSpawn(playerid) { 
    if (pTemp[playerid][tPaintTeam] > 0)
	{
	    switch ( StartPaintBall )
	    {
	        case 0:
	        {
	            pTemp[playerid][tPaintTeam] =
				pTemp[playerid][tPaintKills] =
				pTemp[playerid][tPaintDeath] = 0;
				pTemp[playerid][tPaintDMG] = 0.0;
				for(new td; td < sizeof (paint_TD); td++) {
					TextDrawHideForPlayer(playerid, paint_TD[td]); 
				} 
				PlayerTextDrawDestroy ( playerid, tPaintStats [ playerid ] ) ;
				tPaintStats [ playerid ] = PlayerText:-1 ;
                SetPlayerPosAC(playerid, 286.1364, -30.7176, 1001.5156, 1, 1);
                SetPlayerFacingAngle(playerid, 181.0381);
			}
			case 2:
			{
				SetPlayerHealth(playerid, 100.0);
				SetPlayerSkin(playerid, SkinPaint[ pInfo[playerid][pSex] ][ pTemp[playerid][tPaintTeam] - 1 ] ); 

				GivePlayerWeapon(playerid, 24, 2000);
				GivePlayerWeapon(playerid, 25, 2000);
				GivePlayerWeapon(playerid, 31, 2000);

				new rand = random(10); 
				switch(pTemp[playerid][tPaintTeam])
				{
					case 1: {  
                        SetPlayerPosAC(playerid, SpawnBlueTeam[PaintBallMap-1][rand][0], SpawnBlueTeam[PaintBallMap-1][rand][1], SpawnBlueTeam[PaintBallMap-1][rand][2], 10, INTERIOR_NONE);
                        SetPlayerFacingAngle(playerid, SpawnBlueTeam[PaintBallMap-1][rand][3]);
						pTemp[playerid][tVirtualWorld] = 10;
						pTemp[playerid][tInterior] = INTERIOR_NONE;
						SetPlayerColor(playerid, 0x33AAFFFF); // Blue
					}
					case 2: {  
                        SetPlayerPosAC(playerid, SpawnRedTeam[PaintBallMap-1][rand][0], SpawnRedTeam[PaintBallMap-1][rand][1], SpawnRedTeam[PaintBallMap-1][rand][2], 10, INTERIOR_NONE);
                        SetPlayerFacingAngle(playerid, SpawnRedTeam[PaintBallMap-1][rand][3]);
						pTemp[playerid][tVirtualWorld] = 10;
						pTemp[playerid][tInterior] = INTERIOR_NONE;
						SetPlayerColor(playerid, 0xAA3333FF) ;// red

					}
				} 
				return 1;
			}
		}
	}
	return false;
}*/

Event_OnPlayerPickUpPickup(playerid, pickupid) { 
	new bool:isReturn = false;  
    if (pickupid == paints[0])
	{
		if ( StartPaintBall != 1 ) {
			SendClientMessage(playerid, COLOR_GREY, !"Регистрация закрыта");
			return 1;
		}
		if (pInfo[playerid][pLevel] < 2) return SendClientMessage(playerid, COLOR_GRAD1, !"Участвовать можно с 2-х лет проживания в штате!");
	    if (pInfo[playerid][pWarns]) return SendClientMessage(playerid, COLOR_LI_RED, !"[Оповещение] "colwhi"Нельзя учавствовать с Варном");
		if (pTemp[playerid][tPaintTeam]) {
			SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы уже зарегистрировались на матч!");
			return 1;
		}
		if (kLibGetPlayerMoney(playerid) < PAINT_BALL_PAYMENT) return SendClientMessage(playerid, COLOR_LI_RED, !"[Оповещение] "colwhi"Для регистрации необходимо иметь "collime"$"#PAINT_BALL_PAYMENT"");
		pTemp[playerid][tPaintKills] 	= 
		pTemp[playerid][tPaintDeath] 	= 0;
		new	 
			string_[128];
		if ( RedPlayer == 0 && BluePlayer == 0 || BluePlayer < RedPlayer || RedPlayer == BluePlayer )
		{ 
			SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы успешно зарегистрированы на матч. Не выходите из помещения!");
			format(string_, sizeof string_, "[Команда синих] "colwhi"Зарегистрирован участник: %s[%d]", pInfo[playerid][pName], playerid);
			foreach(new i: PlayerInLogin) {
				if (pTemp[i][tPaintTeam] == 1) {
					SendClientMessage(i, COLOR_BLUE, string_);
				}
			}
			BluePlayer ++ ;
			pTemp[playerid][tPaintTeam] = 1 ;
		}
		else if ( BluePlayer > RedPlayer )
		{
			SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы успешно зарегистрированы на матч. Не выходите из помещения!");
			format(string_, sizeof string_, "[Команда красных] "colwhi"Зарегистрирован участник: %s[%d]", pInfo[playerid][pName], playerid);
			foreach(new i: PlayerInLogin) {
				if (pTemp[i][tPaintTeam] == 1) {
					SendClientMessage(i, COLOR_LI_RED, string_);
				}
			}
			RedPlayer ++ ;
			pTemp[playerid][tPaintTeam] = 2;
		}
		kLibGivePlayerMoney(playerid, -PAINT_BALL_PAYMENT, "Reg PB"); 
		paintball_bank += PAINT_BALL_PAYMENT;	
		isReturn = true; 
	}
    else if (pickupid == paints[1])
	{ 
		SetPlayerPosAC(playerid, 286.4868, -40.2647, 1001.5156, 1, 1);
		SetPlayerFacingAngle(playerid, 318.7845); 
        SetCameraBehindPlayer(playerid);
        isReturn = true; 
	}
	else if (pickupid == paints[2])
	{ 
		SetPlayerPosAC(playerid, 2593.7839, 2790.6182, 10.8203, 0, 0);
		SetPlayerFacingAngle(playerid, 92.0974); 
        SetCameraBehindPlayer(playerid);
		if(pTemp[playerid][tPaintTeam] > 0) {
			pTemp[playerid][tPaintTeam] = 0 ;
            kLibGivePlayerMoney(playerid, PAINT_BALL_PAYMENT, "Return PB Moeny"); 
			SendClientMessage(playerid, 0x6495EDFF, !"Вы покинули здания регистрации на PaintBall.");
		} 
		isReturn = true; 
	}  
    else if (pickupid == racee[0])
	{ 
		SetPlayerPosAC(playerid, 831.7769, 6.8750, 1004.1797, 1, 3);
		SetPlayerFacingAngle(playerid, 108.1610);
        SetCameraBehindPlayer(playerid);
        isReturn = true; 
	}
	else if (pickupid == racee[1])
	{ 
		SetPlayerPosAC(playerid, 1958.6117,-2183.5022,13.5469,0,0);
		SetPlayerFacingAngle(playerid, 271.8013); 
        if (pTemp[playerid][tRacePlayer]) {
            PlayersInRaceCount--;
            Iter_Remove(RacersList, playerid);
            kLibGivePlayerMoney(playerid, RACE_PAYMENT, "Return Race MP");
            pTemp[playerid][tRacePlayer] = false;
        } 
        SetCameraBehindPlayer(playerid);
        isReturn = true; 
	}
    else if (pickupid == racee[2])
	{
	    if (RaceStarting[2] != 3) return SendClientMessage(playerid, COLOR_GREY, !"Регистрация закрыта");
		if (!pInfo[playerid][pLicense][0]) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет водительского удостоверения!");
	    if (pInfo[playerid][pLevel] < 2) return SendClientMessage(playerid, COLOR_GRAD1, !"Участвовать можно с 2-х лет проживания в штате!");
	    if (pInfo[playerid][pWarns]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя учавствовать с Варном"); 
        if (kLibGetPlayerMoney(playerid) < RACE_PAYMENT) return SendClientMessage(playerid, COLOR_LI_RED, !"[Оповещение] "colwhi"Для регистрации необходимо иметь "collime"$"#RACE_PAYMENT"");
        if (PlayersInRaceCount >= MAX_RACE_PLAYERS) return SendClientMessage(playerid, COLOR_GREY, !"Слишком много участников");
		if (pTemp[playerid][tRacePlayer]) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже зарегистрировались на матч!");
        kLibGivePlayerMoney(playerid, -RACE_PAYMENT, "Reg Race MP");
        pTemp[playerid][tRacePlayer] = true;
        PlayersInRaceCount++;
        Iter_Add(RacersList, playerid);
        pTemp[playerid][tRacePosition] = PlayersInRaceCount;
        new 
            string_[128];
        format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] Зарегистрирован под номером: %d", pInfo[playerid][pName], playerid, PlayersInRaceCount);
        RaceChat(COLOR_LI_RED, string_);  
		isReturn = true; 
	}
	if (isReturn) return true;
	return false;
}

Event_OnGameModeInit() { 
    paints[0] = CreateDynamicPickup(353, 23, 294.8574, -38.2151, 1001.5156, .worldid = 1, .interiorid = 1);
    paints[1] = CreateDynamicPickup(1318, 23, 2595.8364, 2790.6592, 10.8203, .worldid = 0, .interiorid = 0);
    paints[2] = CreateDynamicPickup(1318, 23, 285.5204, -41.8050, 1001.5156, .worldid = 1, .interiorid = 1); 

	racee[0] = CreateDynamicPickup(1318,23,1956.7323,-2183.6260,13.5469, .worldid = 0, .interiorid = 0); // Гонка вход
	racee[1] = CreateDynamicPickup(1318,23,834.6671,7.2752,1004.1870, .worldid = 1, .interiorid = 3); // Гонка выход
    racee[2] = CreateDynamicPickup(19134, 23, 822.3992,2.7049,1004.1797, .worldid = 1, .interiorid = 3); // Регистрация на гонку

 
    paint_TD[0] = TextDrawCreate(225.6665, 349.1332, "LD_BEAT:chit"); // пусто
    TextDrawTextSize(paint_TD[0], 14.0000, 17.0000);
    TextDrawAlignment(paint_TD[0], 1);
    TextDrawColor(paint_TD[0], COLOR_SERVER);
    TextDrawBackgroundColor(paint_TD[0], 255);
    TextDrawFont(paint_TD[0], 4);
    TextDrawSetProportional(paint_TD[0], 0);
    TextDrawSetShadow(paint_TD[0], 0);

    paint_TD[1] = TextDrawCreate(230.8663, 351.8218, "LD_SPAC:white"); // пусто
    TextDrawTextSize(paint_TD[1], 169.0000, 10.0000);
    TextDrawAlignment(paint_TD[1], 1);
    TextDrawColor(paint_TD[1], COLOR_SERVER);
    TextDrawBackgroundColor(paint_TD[1], 255);
    TextDrawFont(paint_TD[1], 4);
    TextDrawSetProportional(paint_TD[1], 0);
    TextDrawSetShadow(paint_TD[1], 0);

    paint_TD[2] = TextDrawCreate(393.9996, 349.1333, "LD_BEAT:chit"); // пусто
    TextDrawTextSize(paint_TD[2], 14.0000, 17.0000);
    TextDrawAlignment(paint_TD[2], 1);
    TextDrawColor(paint_TD[2], COLOR_SERVER);
    TextDrawBackgroundColor(paint_TD[2], 255);
    TextDrawFont(paint_TD[2], 4);
    TextDrawSetProportional(paint_TD[2], 0);
    TextDrawSetShadow(paint_TD[2], 0);

    paint_TD[3] = TextDrawCreate(227.6329, 357.0148, "LD_SPAC:white"); // пусто
    TextDrawTextSize(paint_TD[3], 178.0000, 29.0000);
    TextDrawAlignment(paint_TD[3], 1);
    TextDrawColor(paint_TD[3], 421075455);
    TextDrawBackgroundColor(paint_TD[3], 255);
    TextDrawFont(paint_TD[3], 4);
    TextDrawSetProportional(paint_TD[3], 0);
    TextDrawSetShadow(paint_TD[3], 0);

    paint_TD[4] = TextDrawCreate(230.9662, 358.6738, "LD_SPAC:white"); // пусто
    TextDrawTextSize(paint_TD[4], 46.0000, 25.0000);
    TextDrawAlignment(paint_TD[4], 1);
    TextDrawColor(paint_TD[4], 673720575);
    TextDrawBackgroundColor(paint_TD[4], 255);
    TextDrawFont(paint_TD[4], 4);
    TextDrawSetProportional(paint_TD[4], 0);
    TextDrawSetShadow(paint_TD[4], 0);
//TextDrawCreate(252.0666, 370.4736, "00:00_~b~Blue"); // пусто
    paint_TD[5] = TextDrawCreate(251.7332, 360.1033, "00:00_~r~Red"); // пусто
    TextDrawLetterSize(paint_TD[5], 0.2166, 1.0313);
    TextDrawTextSize(paint_TD[5], 0.0000, 40.0000);
    TextDrawAlignment(paint_TD[5], 2);
    TextDrawColor(paint_TD[5], -1);
    TextDrawBackgroundColor(paint_TD[5], 6);
    TextDrawFont(paint_TD[5], 1);
    TextDrawSetProportional(paint_TD[5], 1);
    TextDrawSetShadow(paint_TD[5], 0); 

    paint_TD[6] = TextDrawCreate(278.2997, 358.6736, "LD_SPAC:white"); // пусто
    TextDrawTextSize(paint_TD[6], 77.0000, 25.0000);
    TextDrawAlignment(paint_TD[6], 1);
    TextDrawColor(paint_TD[6], 673720575);
    TextDrawBackgroundColor(paint_TD[6], 255);
    TextDrawFont(paint_TD[6], 4);
    TextDrawSetProportional(paint_TD[6], 0);
    TextDrawSetShadow(paint_TD[6], 0);

    paint_TD[7] = TextDrawCreate(316.4667, 361.2034, "KILLS_DEATH__DMG__K/D"); // пусто
    TextDrawLetterSize(paint_TD[7], 0.1630, 0.7286);
    TextDrawAlignment(paint_TD[7], 2);
    TextDrawColor(paint_TD[7], -1);
    TextDrawBackgroundColor(paint_TD[7], 6);
    TextDrawFont(paint_TD[7], 1);
    TextDrawSetProportional(paint_TD[7], 1);
    TextDrawSetShadow(paint_TD[7], 0); 

    paint_TD[8] = TextDrawCreate(252.0666, 370.4736, "00:00_~b~Blue"); // пусто
    TextDrawLetterSize(paint_TD[8], 0.2166, 1.038);
    TextDrawTextSize(paint_TD[8], 0.0000, 40.0000);
    TextDrawAlignment(paint_TD[8], 2);
    TextDrawColor(paint_TD[8], -1);
    TextDrawBackgroundColor(paint_TD[8], 6);
    TextDrawFont(paint_TD[8], 1);
    TextDrawSetProportional(paint_TD[8], 1);
    TextDrawSetShadow(paint_TD[8], 0);

    paint_TD[9] = TextDrawCreate(356.6329, 358.5591, "LD_SPAC:white"); // пусто
    TextDrawTextSize(paint_TD[9], 46.0000, 25.0000);
    TextDrawAlignment(paint_TD[9], 1);
    TextDrawColor(paint_TD[9], 673720575);
    TextDrawBackgroundColor(paint_TD[9], 255);
    TextDrawFont(paint_TD[9], 4);
    TextDrawSetProportional(paint_TD[9], 0);
    TextDrawSetShadow(paint_TD[9], 0);

    paint_TD[10] = TextDrawCreate(380.6665, 361.2185, "TIME"); // пусто
    TextDrawLetterSize(paint_TD[10], 0.1630, 0.7286);
    TextDrawAlignment(paint_TD[10], 2);
    TextDrawColor(paint_TD[10], -1);
    TextDrawBackgroundColor(paint_TD[10], 6);
    TextDrawFont(paint_TD[10], 1);
    TextDrawSetProportional(paint_TD[10], 1);
    TextDrawSetShadow(paint_TD[10], 0);

    paint_TD[11] = TextDrawCreate(381.6665, 368.3554, "00:00"); // пусто
    TextDrawLetterSize(paint_TD[11], 0.2424, 0.8865);
    TextDrawAlignment(paint_TD[11], 2);
    TextDrawColor(paint_TD[11], COLOR_SERVER);
    TextDrawSetOutline(paint_TD[11], -1);
    TextDrawBackgroundColor(paint_TD[11], -754100980);
    TextDrawFont(paint_TD[11], 1);
    TextDrawSetProportional(paint_TD[11], 1);
    TextDrawSetShadow(paint_TD[11], 0);

    paint_TD[12] = TextDrawCreate(227.6994, 385.0072, "LD_SPAC:white"); // пусто
    TextDrawTextSize(paint_TD[12], 178.5000, 1.0000);
    TextDrawAlignment(paint_TD[12], 1);
    TextDrawColor(paint_TD[12], COLOR_SERVER);
    TextDrawBackgroundColor(paint_TD[12], 255);
    TextDrawFont(paint_TD[12], 4);
    TextDrawSetProportional(paint_TD[12], 0);
    TextDrawSetShadow(paint_TD[12], 0); 
    

    tRace_TD[0] = TextDrawCreate(12.9996, 153.7554, "LD_BEAT:chit"); // пусто
    TextDrawTextSize(tRace_TD[0], 14.0000, 17.0000);
    TextDrawAlignment(tRace_TD[0], 1);
    TextDrawColor(tRace_TD[0], COLOR_SERVER);
    TextDrawBackgroundColor(tRace_TD[0], 255);
    TextDrawFont(tRace_TD[0], 4);
    TextDrawSetProportional(tRace_TD[0], 0);
    TextDrawSetShadow(tRace_TD[0], 0);

    tRace_TD[1] = TextDrawCreate(21.1996, 156.4440, "LD_SPAC:white"); // шапка
    TextDrawTextSize(tRace_TD[1], 82.0000, 9.0000);
    TextDrawAlignment(tRace_TD[1], 1);
    TextDrawColor(tRace_TD[1], COLOR_SERVER);
    TextDrawBackgroundColor(tRace_TD[1], 255);
    TextDrawFont(tRace_TD[1], 4);
    TextDrawSetProportional(tRace_TD[1], 0);
    TextDrawSetShadow(tRace_TD[1], 0);

    tRace_TD[2] = TextDrawCreate(96.6660, 153.7554, "LD_BEAT:chit"); // пусто
    TextDrawTextSize(tRace_TD[2], 14.0000, 17.0000);
    TextDrawAlignment(tRace_TD[2], 1);
    TextDrawColor(tRace_TD[2], COLOR_SERVER);
    TextDrawBackgroundColor(tRace_TD[2], 255);
    TextDrawFont(tRace_TD[2], 4);
    TextDrawSetProportional(tRace_TD[2], 0);
    TextDrawSetShadow(tRace_TD[2], 0);

    tRace_TD[3] = TextDrawCreate(15.2994, 162.0516, "LD_SPAC:white"); // пусто
    TextDrawTextSize(tRace_TD[3], 93.0000, 98.0000);
    TextDrawAlignment(tRace_TD[3], 1);
    TextDrawColor(tRace_TD[3], 421075455);
    TextDrawBackgroundColor(tRace_TD[3], 255);
    TextDrawFont(tRace_TD[3], 4);
    TextDrawSetProportional(tRace_TD[3], 0);
    TextDrawSetShadow(tRace_TD[3], 0);

    tRace_TD[4] = TextDrawCreate(15.3655, 259.7329, "LD_SPAC:white"); // пусто
    TextDrawTextSize(tRace_TD[4], 93.0000, 1.0000);
    TextDrawAlignment(tRace_TD[4], 1);
    TextDrawColor(tRace_TD[4], COLOR_SERVER);
    TextDrawBackgroundColor(tRace_TD[4], 255);
    TextDrawFont(tRace_TD[4], 4);
    TextDrawSetProportional(tRace_TD[4], 0);
    TextDrawSetShadow(tRace_TD[4], 0);

    tRace_TD[5] = TextDrawCreate(17.9657, 201.0437, "LD_SPAC:white"); // пусто
    TextDrawTextSize(tRace_TD[5], 88.0000, -27.0000);
    TextDrawAlignment(tRace_TD[5], 1);
    TextDrawColor(tRace_TD[5], 673720575);
    TextDrawBackgroundColor(tRace_TD[5], 255);
    TextDrawFont(tRace_TD[5], 4);
    TextDrawSetProportional(tRace_TD[5], 0);
    TextDrawSetShadow(tRace_TD[5], 0);

    tRace_TD[6] = TextDrawCreate(17.9657, 252.8954, "LD_SPAC:white"); // control_point
    TextDrawTextSize(tRace_TD[6], 88.0000, -14.0000);
    TextDrawAlignment(tRace_TD[6], 1);
    TextDrawColor(tRace_TD[6], 673720575);
    TextDrawBackgroundColor(tRace_TD[6], 255);
    TextDrawFont(tRace_TD[6], 4);
    TextDrawSetProportional(tRace_TD[6], 0);
    TextDrawSetShadow(tRace_TD[6], 0);

    tRace_TD[7] = TextDrawCreate(22.9993, 175.7958, "1. Akatsuji_Costallone~n~2. Test~n~3. Test"); // пусто
    TextDrawLetterSize(tRace_TD[7], 0.1817, 0.8779);
    TextDrawTextSize(tRace_TD[7], 221.0000, 0.0000);
    TextDrawAlignment(tRace_TD[7], 1);
    TextDrawColor(tRace_TD[7], -1);
    TextDrawBackgroundColor(tRace_TD[7], 6);
    TextDrawFont(tRace_TD[7], 1);
    TextDrawSetProportional(tRace_TD[7], 1);
    TextDrawSetShadow(tRace_TD[7], 0);

    tRace_TD[8] = TextDrawCreate(61.3329, 163.8516, "TOP_3"); // пусто
    TextDrawLetterSize(tRace_TD[8], 0.2424, 0.8865);
    TextDrawAlignment(tRace_TD[8], 2);
    TextDrawColor(tRace_TD[8], COLOR_SERVER);
    TextDrawSetOutline(tRace_TD[8], -1);
    TextDrawBackgroundColor(tRace_TD[8], -754100980);
    TextDrawFont(tRace_TD[8], 1);
    TextDrawSetProportional(tRace_TD[8], 1);
    TextDrawSetShadow(tRace_TD[8], 0);

    tRace_TD[9] = TextDrawCreate(22.9993, 207.3217, "Map:_~r~Wolking_Street_Race~n~~w~Time:_~r~00:00~n~~w~Racers:_~r~44/44"); // пусто
    TextDrawLetterSize(tRace_TD[9], 0.1817, 0.8779);
    TextDrawTextSize(tRace_TD[9], 221.0000, 0.0000);
    TextDrawAlignment(tRace_TD[9], 1);
    TextDrawColor(tRace_TD[9], -1);
    TextDrawBackgroundColor(tRace_TD[9], 6);
    TextDrawFont(tRace_TD[9], 1);
    TextDrawSetProportional(tRace_TD[9], 1);
    TextDrawSetShadow(tRace_TD[9], 0);
} 


CMD:paintexit(playerid )
{
    if (!pTemp[playerid][tPaintTeam]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не участвуете в PaintBall.");
	if (IsPlayerDying(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент Вы не можете использовать данную команду");
	if(StartPaintBall == 2)
	{ 
		if (pInfo[playerid][pMember] && pTemp[playerid][tDutyWork]) {
            SetPlayerColor(playerid, gFractionColor[pInfo[playerid][pMember]]);
            SetPlayerSkinEx(playerid, pInfo[playerid][pModel]);
        }
        else {
            SetPlayerColor(playerid, gFractionColor[0]);
            SetPlayerSkinEx(playerid, pInfo[playerid][pChar][0]);
        }   
		SetPlayerPosAC(playerid, 286.1364, -30.7176, 1001.5156, 1, 1);
        SetPlayerFacingAngle(playerid, 181.0381); 
		for(new i; i < sizeof (paint_TD); i++) {
            TextDrawHideForPlayer(playerid, paint_TD[i]); 
        }   
        PlayerTextDrawDestroy (playerid, tPaintStats[playerid]);
        tPaintStats[playerid] = PlayerText:-1; 
		/*for ( new j = 0 ; j < 5 ; j ++ ) {
            SendDeathMessageToPlayer ( playerid, 1001, 1001, 200 );
        }*/
		pTemp[playerid][tPaintKills]    =
		pTemp[playerid][tPaintDeath]    = 0;
        pTemp[playerid][tPaintDMG] = 0.0;
		ResetPlayerWeapons(playerid) ;
	}
	switch(pTemp[playerid][tPaintTeam])
	{
	    case 1: BluePlayer--;
	    case 2: RedPlayer--;
	}
	pTemp[playerid][tPaintTeam] = 0;
	SendClientMessage(playerid, COLOR_LI_RED, !"[Оповещение] "colwhi"Вы успешно покинули PaintBall."); 
	return 1;
}

CMD:racelist(playerid,params[])
{
	if (!pInfo[playerid][pLogin]) return 1; 
 	new str_[100];
    strcat(t_string, ""colserver"[№] Никнейм\t"colserver"Время\n");
  	for(new i = 0; i < sizeof(gRaceStats); i++)
   	{ 
        if (gRaceStats[i][raceEndTime] == 0) continue;
		format(str_, sizeof str_,"[%d] %s\t%s\n", i, gRaceStats[i][raceName], Converts(gRaceStats[i][raceEndTime]));
		strcat(t_string, str_);
	}
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Список: "colwhi"Участников", t_string, "Закрыть", "");
    return 1;
}
/*enum E_RACE_LIST {
                        raceName[MAX_PLAYER_NAME],
                        raceTime
                    }
                    static const gRaceStats[MAX_RACE_PLAYERS][E_RACE_LIST];*/
/*CMD:painlist(playerid,params[])
{
	new str_[128];
	t_string[0] = EOS;
	format(t_string, sizeof t_string,"[№] Никнейм\tУбийств\tСмертей\tK/D\n");
    new 
		idx[2],
		attack_players[40][2];
	for(new i = 0; i < MAX_PAINT_BALL_PLAYERS; i++)
	{
        if (pPaintStats[i][pbPlayerID] == INVALID_PLAYER_ID) continue;
        attack_players[idx[0]][0] = i;
        attack_players[idx[0]++][1] = pPaintStats[i][paKills];
		//format(str_, sizeof(str_), "%s\t\t\t%d\t\t\t%d\n", PaintStats[i][paName], PaintStats[i][paKills], PaintStats[i][paDeaths]);
		//strcat(t_string, str_);
	}

    SortDeepArray(attack_players, 1, .order = SORT_DESC);
    for (new i = 0, playerid, deaths; i < MAX_PAINT_BALL_PLAYERS; i++) {
		// gang id #1
		if (!attack_players[i][1]) {
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 0], "__");
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 14 + 0], "__");
		} else {
			playerid = attack_players[i][0];
			
			format(t_string, sizeof (t_string), "__%s", pInfo[playerid][pName]);
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 0], t_string);
			 
			deaths = CaptureInfo[playerid][pDeaths];
			if (deaths < 1) deaths = 1;
		
			format(t_string, sizeof (t_string), "%03d___%05d_____%03d_____%.1f",
				CaptureInfo[playerid][pKills], attack_players[i][1], CaptureInfo[playerid][pDeaths], 
				Float:(1.0 * CaptureInfo[playerid][pKills] / deaths)
			);
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 14 + 0], t_string);

            format(str_, sizeof(str_), "%s\t\t\t%d\t\t\t%d\n", PaintStats[i][paName], PaintStats[i][paKills], PaintStats[i][paDeaths]);
            strcat(t_string, str_);
		}
    }

	if (Painlist > 0) return ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Список игроков", t_string, "Закрыть", "");
	SendClientMessage(playerid, COLOR_GREY, !"Список игроков пуст");
	return 1;
}
pPaintStats[Painlist][pbPlayerID] = x;
pPaintStats[Painlist][pbKills] = GetPVarInt(x,"paintkills");
pPaintStats[Painlist][pbDeaths] = GetPVarInt(x,"paintdeaths"); 
strmid(PaintStats[Painlist][paName],pInfo[x][pName], 0, strlen(pInfo[x][pName]), MAX_PLAYER_NAME);*/
CMD:arace(playerid) //<RaceStarted:No>
{ 
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    for(new i = 0; i < sizeof (gRaceStats); i++) {
        gRaceStats[i] = defaultRaceStats; 
    }
    if(RaceStarting[2] == 1 || RaceStarting[2] == 3) return SendClientMessage(playerid, COLOR_GREY, !"Гонка уже запущена");
    RaceStarting[2] = 3;
    RaceStarting[0] = 300;//Time


	new 
		raceMapName[][32] = {"Wolking Street Race", "Las-Venturas / San-Fierro Race"},
		string_[128];   
	switch(random(3)) {
		case 0, 3: typeRace = 0;
		default: typeRace = 1;
	} 
	format(string_, sizeof string_, "Внимание! Начало гонок через 5 минуты. Трасса: %s. (( /gps - Развлечения ))", raceMapName[typeRace]);
	SendClientMessageToAll(0xB9B900AA, string_);   
	return 1;
} 
CMD:paint(playerid)
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	TimerPaintBall = 300;
	StartPaintBall = 1;
	RedScore    = 
    BlueScore   = 
    RedPlayer   = 
    BluePlayer  = 0;

	if ( ++ PaintBallMap > 2 ) PaintBallMap = 1;
	foreach(new i: PlayerInLogin)
	{
		if (pTemp[i][tPaintTeam] ) {
			pTemp[i][tPaintKills]    =
            pTemp[i][tPaintDeath]    =
            pTemp[i][tPaintTeam]     = 0;
            pTemp[i][tPaintDMG]      = 0.0; 
			SetPlayerHealth(i, 100);
			ResetPlayerWeapons(i);
			if (pInfo[i][pMember] && pTemp[i][tDutyWork]) {
				SetPlayerColor(i, gFractionColor[pInfo[i][pMember]]);
				SetPlayerSkinEx(i, pInfo[i][pModel]);
			}
			else {
				SetPlayerColor(i, gFractionColor[0]);
				SetPlayerSkinEx(i, pInfo[i][pChar][0]);
			}  
			SetPlayerPosAC(i, 286.1364, -30.7176, 1001.5156, 1, 1);
			SetPlayerFacingAngle(i, 181.0381); 
			for(new td; td < sizeof (paint_TD); td++) {
				TextDrawHideForPlayer(i, paint_TD[td]); 
			}    
			PlayerTextDrawDestroy (i, tPaintStats[i]);
			tPaintStats[i] = PlayerText:-1;
		}
	} 
	new 
		paintMapName[][32] = {"Лес", "Военный завод К.А.С.С"}, 
		string_[128];
	format(string_, sizeof string_, "Внимание! Начало пейнтболла через 5 минут. Место проведения: %s", paintMapName[PaintBallMap-1]);
	SendClientMessageToAll(0xFFAAFFAA, string_);   
	return true;
}
stock UpdatePlayerPaintScore(playerid) {
    new deaths = pTemp[playerid][tPaintDeath];
	if (deaths < 1) deaths = 1;
	
	format(t_string, sizeof (t_string), "%04d_%04d_%05d_%.1f",
		pTemp[playerid][tPaintKills], pTemp[playerid][tPaintDeath], floatround(pTemp[playerid][tPaintDMG]), 
		Float:(1.0 * pTemp[playerid][tPaintKills] / deaths)
	);
	PlayerTextDrawSetString(playerid, tPaintStats[playerid], t_string), t_string[0] = EOS; 
    return 1;
}
/*

CMD:showtdpaint(playerid) {
    new 
        str_[128];
    for(new i; i < sizeof (paint_TD); i++) {
        TextDrawShowForPlayer(playerid, paint_TD[i]); 
    }   
    format(str_, sizeof str_, "%04d_~r~Red", RedScore );
    TextDrawSetString(paint_TD[5], str_); 

    format(str_, sizeof str_, "%04d_~b~Blue", RedScore );
    TextDrawSetString(paint_TD[8], str_); 
    
    format(str_, sizeof str_, "%s", Converts(TimerPaintBall));
    TextDrawSetString(paint_TD[11], str_);  

    tPaintStats[playerid] = CreatePlayerTextDraw(playerid, 284.4666, 369.4144, "0000_0000_00000_1.0"); // пусто
    PlayerTextDrawLetterSize(playerid, tPaintStats[playerid], 0.1706, 0.8183);
    PlayerTextDrawAlignment(playerid, tPaintStats[playerid], 1);
    PlayerTextDrawColor(playerid, tPaintStats[playerid], COLOR_SERVER);
    PlayerTextDrawSetShadow(playerid, tPaintStats[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, tPaintStats[playerid ], -754100980);
    PlayerTextDrawFont(playerid, tPaintStats[playerid], 1);
    PlayerTextDrawSetProportional(playerid, tPaintStats[playerid ], 1);
    PlayerTextDrawSetShadow(playerid, tPaintStats[playerid ], 0);

    PlayerTextDrawShow (playerid, tPaintStats[playerid] ) ; // show

    SendClientMessage(playerid, -1, "111111111111111111111");
    return 1;
} */
race_vehicledeath(playerid)
{
	if (pTemp[playerid][tRacePlayer] && RaceStarting[2] == 1)
	{
		Iter_Remove(RacersList, playerid);
		PlayersInRaceCount --;
		pPressed[playerid] = 0;
		for(new td; td < sizeof (tRace_TD); td++) {
            TextDrawHideForPlayer(playerid, tRace_TD[td]); 
        }   
        PlayerTextDrawHide(playerid, tRace_PTD[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		pTemp[playerid][tRacePlayer] = false;
		if (pTemp[playerid][tRaceVehicleID] != INVALID_VEHICLE_ID) {
            DestroyVehicle(pTemp[playerid][tRaceVehicleID]);
            pTemp[playerid][tRaceVehicleID] = INVALID_VEHICLE_ID;
        }
		new 
            string_[128];
        format(string_, sizeof string_, "[Race Оповещение]: "colwhi"%s[%d] уничтожил ТС!. Участников: %d", pInfo[playerid][pName], playerid, PlayersInRaceCount);
        RaceChat(COLOR_LI_RED, string_); 
		if (PlayersInRaceCount == 0)
		{
			raceTime = 1;
			PlayersInRaceCount = 0;
			SendClientMessageToAll(0xB9B900AA, !"Гонка отменена участники покинули свои транспортные средства"); 
			foreach(new s: RacersList)
			{
				for(new td; td < sizeof (tRace_TD); td++) {
                    TextDrawHideForPlayer(s, tRace_TD[td]); 
                }   
                PlayerTextDrawHide(s, tRace_PTD[s]);
				pPressed[s] = 0;
				pTemp[s][tRacePosition] = 0;
				Iter_Remove(RacersList, s);
			}
			RaceStarting[2] = 0;
			typeRace = 3;
			//state RaceStarted:No;
		}
		SetPlayerPosEx(playerid, 827.0083,5.8989,1004.1870);
		SetPlayerFacingAngle(playerid, 269.6992);
		SetPlayerInterior(playerid, 3);
		SetPlayerVirtualWorld(playerid, 300);
	}
} 
stock StartedRaces()
{ 
	RaceStarting[2] = 1; 
	foreach(new i: RacersList) {
		pPressed[i] = 0;
		for(new td; td < sizeof (tRace_TD); td++) {
            TextDrawShowForPlayer(i, tRace_TD[td]); 
        }   
        PlayerTextDrawShow(i, tRace_PTD[i]);

		UpdateRaceStats(i);
		GameTextForPlayer(i, !"~p~ START!", 3000, 4);
		TogglePlayerControllable(i, true);
		SetPlayerRaceCheckpoint(i, 0, 
            los_santos_race[typeRace][0][0], los_santos_race[typeRace][0][1], los_santos_race[typeRace][0][2], 
            los_santos_race[typeRace][0+1][0], los_santos_race[typeRace][0+1][1], los_santos_race[typeRace][0+1][2], 10.0
        );
	}
	return 1;
}
publics: SecondStartedRaces()
{
	RaceStarting[1] --;
	if(RaceStarting[1] <= 1) return StartedRaces(), RaceStarting[1] = 0;
    new
        str_[12],
        rand = random(sizeof(RaceCar));
	foreach(new i: RacersList) {
		if(RaceStarting[1] < 10) {
			format(str_, sizeof str_, "~g~%d", RaceStarting[1]);
			GameTextForPlayer(i, str_, 1000, 4);
		}
		if(RaceStarting[1] == 10) {
			DisablePlayerRaceCheckpoint(i);
			TogglePlayerControllable(i, false);
			new position = pTemp[i][tRacePosition]; 
			SetPlayerPosAC(i, spawn_car[typeRace][PlayersInRaceCount][0], spawn_car[typeRace][PlayersInRaceCount][1], spawn_car[typeRace][PlayersInRaceCount][2], 1, INTERIOR_NONE);

            pTemp[i][tRaceVehicleID] = _CreateVehicle(RaceCar[rand], spawn_car[typeRace][position][0],spawn_car[typeRace][position][1],spawn_car[typeRace][position][2],spawn_car[typeRace][position][3], random(128), random(128), 7200);
            GetVehicleParamsEx(pTemp[i][tRaceVehicleID], engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
            SetVehicleParamsEx(pTemp[i][tRaceVehicleID], 1, 1, alarm2, 0, bonnet2, boot1, objective1); 
            VehicleInfo[ pTemp[i][tRaceVehicleID] - 1 ][vFuel] = 100;
			LinkVehicleToInterior(pTemp[i][tRaceVehicleID], 0);
			SetVehicleVirtualWorld(pTemp[i][tRaceVehicleID], 1);
			SetPlayerInterior(i, 0);
			SetPlayerVirtualWorld(i, 1);
			PutPlayerInVehicle(i, pTemp[i][tRaceVehicleID], 0);  
		}
	}
	SetTimer("SecondStartedRaces", 1100, false);
	return 1;
}

stock GetTopOne()
{
	new temp = 0, id = -1;
	foreach(new i: RacersList)
	{
		if (i != -1 && pPressed[i] > temp)
		{
			temp = pPressed[i];
			id = i;
		}
	}
	return id;
}
stock GetTopTwo()
{
	new temp = 0, id = -1;
	foreach(new i: RacersList)
	{
		if (i != -1 && pPressed[i] > temp && (i != GetTopOne()))
		{
			temp = pPressed[i];
			id = i;
		}
	}
	return id;
}
stock GetTopThree()
{
	new temp = 0, id = -1;
	foreach(new i: RacersList)
	{
		if (i != -1 && pPressed[i] > temp && (i != GetTopOne()) && (i != GetTopTwo()))
		{
			temp = pPressed[i];
			id = i;
		}
	}
	return id;
}

stock RaceChat(color, const string_[])
{
	foreach(new i : RacersList)
	{
		if(!IsPlayerConnected(i)) break;
		if(pTemp[i][tRacePlayer]) SendClientMessage(i, color, string_);
	}
}
stock UpdateRaceStats(playerid) { 
    new 
        map_name[35],
        string_[128];
    switch(typeRace)
    {
        case 0: map_name = "Wolking Street Race";
        case 1: map_name = "LV / SF Race";
    }
    format(string_, sizeof string_, //Converts(raceTime)
        "Map:_~r~%s~n~~w~Time:_~r~%s~n~~w~Racers:_~r~%d/40", map_name, Converts(raceTime), PlayersInRaceCount); 
    TextDrawSetString(tRace_TD[9], string_); 
    
    format(string_, sizeof string_, "CONTROL_POINT:~w~%d/52", pPressed[playerid]);
    PlayerTextDrawSetString(playerid, tRace_PTD[playerid], string_);

    if(GetTopOne() == -1 ) {
        format(string_, sizeof string_, "1. None~n~");
    }
    else format(string_, sizeof string_, "1. %s~n~", pInfo[GetTopOne()][pName]);
    if(GetTopTwo() == -1 ) {
        format(string_, sizeof string_, "%s2. None~n~", string_);
    }
    else format(string_, sizeof string_, "%s2. %s~n~", string_, pInfo[GetTopTwo()][pName]);
    if(GetTopThree() == -1 ) {
        format(string_, sizeof string_, "%s3. None~n~", string_);
    }
    else format(string_, sizeof string_, "%s3. %s~n~", string_, pInfo[GetTopThree()][pName]); 
    TextDrawSetString(tRace_TD[7], string_);  
}  