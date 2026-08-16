#define VODOLAZ_OFFER 10

// Compatibility layer for the donor VODO system.
// The host mod uses the Misters notification implementation and does not have
// the donor-only P_VODORPEDM player-data field. Keep the counter local to this
// system so the module compiles without borrowing an unrelated player field.
new VodoRewardCount[MAX_PLAYERS];
new VodoTaskCount[MAX_PLAYERS];
new VodoTime[MAX_PLAYERS];
#define ShowNotificationLaird ShowNotificationMisters
#define VodoGetReward(%0) VodoRewardCount[%0]
#define VodoSetReward(%0,%1) VodoRewardCount[%0] = (%1)
#define VODOLAZKA_OFFER 7
new kapitanp1;
new kapitanp2;
new kapitanp3;
new kapitanp4;
new yg_areas[6]; //  test 2 yg
new bat_areas1[7]; //  test 1 bat
new bat_areas2[6]; //  test 2 bat
new lit_areas1[6]; //  test 1 lit
new lit_areas2[6]; //  test 2 lit
new yzka_areas[7]; //  yzka
new PlayerBoatID[MAX_PLAYERS];
new gBoatPrices[] = {
    7000,   //   "" (ID  : 0)
    15000,  //   " " (ID: 1)
    17000,  //   "Speedy Yacht" (ID: 2)
    20000,  //   "Marine Yacht" (ID: 3)
    45000,  //   "Sea Yacht" (ID: 4)
    100000  //   "Ocean Yacht" (ID: 5)
};
enum E_PLAYER_VODO_ITEMS {
    yg_collected[6],      // test 2 yg (6 )
    bat1_collected[7],    // test 1 bat (7 )
    bat2_collected[6],    // test 2 bat (6 )
    lit1_collected[6],    // test 1 lit (6 )
    lit2_collected[6],    // test 2 lit (6 )
    yzka_collected[7]     // yzka (7 )
}
new PlayerVodoItems[MAX_PLAYERS][E_PLAYER_VODO_ITEMS];
new VodolazItemNames[][64] = {
    " ",
    " ", 
    " ",
    " ",
    " ",
    " "
};

//    ( 20000  25000)
new VodolazItemPrices[] = {
    21000,  //  
    22000,  //  
    24000,  //  
    23000,  //  
    20000,  //  
    25000   //  
};
// 3.     ()
new gBoatNames[][32] = {
    "",
    " ",
    "Speedy Yacht",
    "Marine Yacht",
    "Sea Yacht",
    "Ocean Yacht"
};
new gBoatCarID[] = {
    473,  // Dinghy ()
    472,  // Coastguard ( )
    493,  // Jetmax (Speedy Yacht)
    452,  // Speeder (Marine Yacht)
    453,  // Reefer (Sea Yacht)
    454  // Tropic (Ocean Yacht)
};
new Float:vodovedisyda[6][3] = {
    {-2469.009277, 579.343261, -0.550000},
    {-1897.012817, -513.759460, -0.550000},
    {1459.005371, -1838.905883, -0.550000},
    {2739.108886, 224.467178, -0.550000},
    {1514.171020, 129.642410, -0.550000},
    {2861.607910, -1165.949462, -0.550000}
};
enum E_POSITIONVODO {
    Float:posX,
    Float:posY,
    Float:posZ,
    Float:posAngle
};
new lodkaPositions[][E_POSITIONVODO] = {
    {2484.252197, -1235.883178, -0.800403, 36.087886},    // yzka lodka1
    {2499.357177, -1228.727783, -0.544732, 6.103890},     // yzka lodka1
    {2514.747070, -1229.557250, -0.544732, 351.048431},   // yzka lodka1
    {2528.980712, -1235.333496, -0.544748, 321.481231},   // yzka lodka1
    {2537.453857, -1243.588989, -0.801097, 323.264831}    // yzka lodka1
};

new lodkaPositionsA[][E_POSITIONVODO] = {
    {681.311767,155.555221,-0.168156,184.687622},    // yzka lodka1
    {670.662048,157.195251,-0.032777,174.723907,},     // yzka lodka1
    {660.937194,157.427490,-0.032965,188.136123},   // yzka lodka1
    {650.579589,157.222229,-0.206876,187.75630},   // yzka lodka1
    {640.811462,155.052581,-0.032689,181.975753}    // yzka lodka1
};
new lodkaPositionsB[][E_POSITIONVODO] = {
    {2367.010253,289.144042,1.262846,186.726348},    // yzka lodka1
    {2352.787353,284.411468,-0.167348,193.099563},     // yzka lodka1
    {2340.795410,284.272491,-0.169282,189.794570},   // yzka lodka1
    {2316.613525,287.917694,-0.032778,179.226531},   // yzka lodka1
    {2302.809570,288.758605,-0.170388,184.518768}    // yzka lodka1
};
new lodkaPositionsL[][E_POSITIONVODO] = {
    {-2519.548339,363.730804,-0.032780,268.533996},    // yzka lodka1
    {-2520.387451,377.281982,-0.165156,274.241729},     // yzka lodka1
    {-2521.538574,390.698913,-0.166875,260.146026},   // yzka lodka1
    {-2539.335937,363.776123,-0.034559,88.848045},   // yzka lodka1
    {-2541.254394,377.489624,-0.162565,89.772666}    // yzka lodka1
};


public SYS_VODO_OnPlayerConnect(playerid)
{
    VodoRewardCount[playerid] = 0;
    VodoTaskCount[playerid] = 0;
    VodoTime[playerid] = 0;
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][yg_collected][i] = 0;
    for(new i = 0; i < 7; i++) PlayerVodoItems[playerid][bat1_collected][i] = 0;
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][bat2_collected][i] = 0;
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][lit1_collected][i] = 0;
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][lit2_collected][i] = 0;
    for(new i = 0; i < 7; i++) PlayerVodoItems[playerid][yzka_collected][i] = 0;
    #if defined vodo_OnPlayerConnect
        return vodo_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_VODO_OnPlayerConnect
    #undef SYS_VODO_OnPlayerConnect
#else
    #define _ALS_SYS_VODO_OnPlayerConnect
#endif
#define SYS_VODO_OnPlayerConnect vodo_OnPlayerConnect
#if defined vodo_OnPlayerConnect
    forward vodo_OnPlayerConnect(playerid);
#endif

public SYS_VODO_OnPlayerEnterDynamicArea(playerid, areaid)
{
for(new i = 0; i < sizeof(yg_areas); i++)
    {
        if(areaid == yg_areas[i])
        {
            // ,      
            if(PlayerVodoItems[playerid][yg_collected][i] == 0)
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "", ">>");
                return callcmd::vodopremd(playerid);
                return 1;
            }
            else
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "  ", " ");
                return 1;
            }
        }
    }
    
    //   test 1 bat
    for(new i = 0; i < sizeof(bat_areas1); i++)
    {
        if(areaid == bat_areas1[i])
        {
            // ,      
            if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "", ">>");
                return callcmd::vodopremd(playerid);
                return 1;
            }
            else
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "  ", " ");
                return 1;
            }
        }
    }
    
    //   test 2 bat
    for(new i = 0; i < sizeof(bat_areas2); i++)
    {
        if(areaid == bat_areas2[i])
        {
            // ,      
            if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "", ">>");
                return callcmd::vodopremd(playerid);
                return 1;
            }
            else
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "  ", " ");
                return 1;
            }
        }
    }
    
    //   test 1 lit
    for(new i = 0; i < sizeof(lit_areas1); i++)
    {
        if(areaid == lit_areas1[i])
        {
            // ,      
            if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "", ">>");
                return callcmd::vodopremd(playerid);
                return 1;
            }
            else
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "  ", " ");
                return 1;
            }
        }
    }
    
    //   test 2 lit
    for(new i = 0; i < sizeof(lit_areas2); i++)
    {
        if(areaid == lit_areas2[i])
        {
            // ,      
            if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "", ">>");
                return callcmd::vodopremd(playerid);
                return 1;
            }
            else
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "  ", " ");
                return 1;
            }
        }
    }
    
    //   yzka
    for(new i = 0; i < sizeof(yzka_areas); i++)
    {
        if(areaid == yzka_areas[i])
        {
            // ,      
            if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "", ">>");
                return callcmd::vodopremd(playerid);
                return 1;
            }
            else
            {
                ShowNotificationLaird(playerid, 4, 6, VODOLAZ_OFFER, 0, "  ", " ");
                return 1;
            }
        }
    }
    if(areaid == kapitanp1 || areaid == kapitanp2 || areaid == kapitanp3 || areaid == kapitanp4)
	{
	ShowNotificationLaird(playerid, 4, 6, VODOLAZKA_OFFER, 0, "", ">>");
	return callcmd::vodogo(playerid);
	}
    return 0;
}

public SYS_VODO_OnGameModeInit()
{
    printf("[VODO SYSTEM]   .");
// 
  kapitanp1 = CreateDynamicSphere(-2528.527832,357.601684,2.100287, 2.0);
    kapitanp2 = CreateDynamicSphere(652.959899,173.051406,2.081145, 2.0);
    kapitanp3 = CreateDynamicSphere(2273.179443,310.147216,4.03999, 2.0);
    kapitanp4 = CreateDynamicSphere(2501.043701,-1253.509033,1.436212, 2.0);
    
    CreateActor(236, 652.252075,173.563812,2.041145,183.585617);
    Create3DTextLabel("{ffff00} \n{ffffff}  ", -1, 652.252075,173.563812,2.041145, 15.0, 0);
    
    CreateActor(236, 2272.684570,309.651611,4.000000,344.699798);
    Create3DTextLabel("{ffff00} \n{ffffff}  ", -1, 2272.684570,309.651611,4.000000, 15.0, 0);
    
    CreateActor(236, 2500.639648,-1252.934204,1.396202,207.274276);
    Create3DTextLabel("{ffff00} \n{ffffff}  ", -1, 2500.639648,-1252.934204,1.396202, 15.0, 0);
    
    CreateActor(236, -2527.409423,358.139892,2.060437,144.376846);
    Create3DTextLabel("{ffff00} \n{ffffff}  ", -1, -2527.409423,358.139892,2.060437, 15.0, 0);
    
// 
    
    yg_areas[0] = CreateDynamicSphere(1466.904296, -1824.186645, -17.164403, 3.0);
    yg_areas[1] = CreateDynamicSphere(1472.079833, -1834.940795, -19.254344, 3.0);
    yg_areas[2] = CreateDynamicSphere(1472.845581, -1845.868530, -18.554044, 3.0);
    yg_areas[3] = CreateDynamicSphere(1462.724609, -1837.813354, -19.553617, 3.0);
    yg_areas[4] = CreateDynamicSphere(1446.883789, -1842.590576, -16.100713, 3.0);
    yg_areas[5] = CreateDynamicSphere(1454.368652, -1851.529296, -15.718278, 3.0);
    
    // test 1 bat (7 )
    bat_areas1[0] = CreateDynamicSphere(2752.146972, 221.677474, -23.452600, 3.0);
    bat_areas1[1] = CreateDynamicSphere(2760.477783, 245.626312, -25.607845, 3.0);
    bat_areas1[2] = CreateDynamicSphere(2748.700439, 238.873016, -23.258836, 3.0);
    bat_areas1[3] = CreateDynamicSphere(2719.258544, 236.032180, -23.346479, 3.0);
    bat_areas1[4] = CreateDynamicSphere(2718.580810, 232.052291, -25.169128, 3.0);
    bat_areas1[5] = CreateDynamicSphere(2711.500244, 210.675140, -24.449611, 3.0);
    bat_areas1[6] = CreateDynamicSphere(2716.578369, 209.340133, -20.733572, 3.0);
    
    // test 2 bat (6 )
    bat_areas2[0] = CreateDynamicSphere(1520.854614, 139.562210, -39.823081, 3.0);
    bat_areas2[1] = CreateDynamicSphere(1509.491699, 141.896606, -40.452293, 3.0);
    bat_areas2[2] = CreateDynamicSphere(1516.119995, 142.102798, -40.669239, 3.0);
    bat_areas2[3] = CreateDynamicSphere(1518.225463, 133.190155, -40.942207, 3.0);
    bat_areas2[4] = CreateDynamicSphere(1512.053833, 135.413940, -40.162685, 3.0);
    bat_areas2[5] = CreateDynamicSphere(1506.213867, 119.769546, -36.237327, 3.0);
    
    // test 1 lit (6 )
    lit_areas1[0] = CreateDynamicSphere(-2468.029052, 586.753845, -46.060962, 3.0);
    lit_areas1[1] = CreateDynamicSphere(-2463.144531, 575.098999, -45.783679, 3.0);
    lit_areas1[2] = CreateDynamicSphere(-2469.093505, 572.723022, -46.698123, 3.0);
    lit_areas1[3] = CreateDynamicSphere(-2472.774414, 579.592773, -46.421581, 3.0);
    lit_areas1[4] = CreateDynamicSphere(-2490.635009, 571.858337, -43.316829, 3.0);
    lit_areas1[5] = CreateDynamicSphere(-2488.437011, 570.524291, -40.731388, 3.0);
    
    // test 2 lit (6 )
    lit_areas2[0] = CreateDynamicSphere(-1917.172607, -518.188293, -23.232200, 3.0);
    lit_areas2[1] = CreateDynamicSphere(-1910.247558, -527.531066, -22.862688, 3.0);
    lit_areas2[2] = CreateDynamicSphere(-1908.961303, -522.390319, -27.755836, 3.0);
    lit_areas2[3] = CreateDynamicSphere(-1899.620727, -515.446289, -28.269762, 3.0);
    lit_areas2[4] = CreateDynamicSphere(-1894.446044, -518.390930, -28.755828, 3.0);
    lit_areas2[5] = CreateDynamicSphere(-1901.051513, -507.493560, -28.172092, 3.0);
    
    // yzka (7 )
    yzka_areas[0] = CreateDynamicSphere(2894.851074, -1164.413574, -20.902873, 3.0);
    yzka_areas[1] = CreateDynamicSphere(2878.929931, -1150.683471, -17.238021, 3.0);
    yzka_areas[2] = CreateDynamicSphere(2873.409667, -1147.650268, -9.720733, 3.0);
    yzka_areas[3] = CreateDynamicSphere(2845.903076, -1154.326904, -9.028607, 3.0);
    yzka_areas[4] = CreateDynamicSphere(2839.530517, -1165.238403, -9.042394, 3.0);
    yzka_areas[5] = CreateDynamicSphere(2859.249511, -1172.719604, -5.868109, 3.0);
    yzka_areas[6] = CreateDynamicSphere(2870.954833, -1173.163452, -9.505463, 3.0);
    #if defined vodo_OnGameModeInit
        return vodo_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_SYS_VODO_OnGameModeInit
    #undef SYS_VODO_OnGameModeInit
#else
    #define _ALS_SYS_VODO_OnGameModeInit
#endif
#define SYS_VODO_OnGameModeInit vodo_OnGameModeInit
#if defined vodo_OnGameModeInit
    forward vodo_OnGameModeInit();
#endif
public SYS_VODO_OnPlayerUpdate(playerid)
{

#if defined vodo_OnPlayerUpdate
        return vodo_OnPlayerUpdate(playerid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_SYS_VODO_OnPlayerUpdate
    #undef SYS_VODO_OnPlayerUpdate
#else
    #define _ALS_SYS_VODO_OnPlayerUpdate
#endif
#define SYS_VODO_OnPlayerUpdate vodo_OnPlayerUpdate
#if defined vodo_OnPlayerUpdate
    forward vodo_OnPlayerUpdate(playerid);
#endif
public SYS_VODO_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == 58909) //   
{
    if(response)
    {
        new items_count = GetPVarInt(playerid, "Vodolaz_ItemsCount");
        
        if(items_count <= 0 || listitem < 0 || listitem >= items_count)
        {
            SendClientMessage(playerid, -1, ":   !");
            DeletePVar(playerid, "Vodolaz_ItemsCount");
            return 1;
        }
        
        //        
        new item_name[64], item_price;
        new item_index = listitem % sizeof(VodolazItemNames);
        new price_index = listitem % sizeof(VodolazItemPrices);
        
        format(item_name, sizeof(item_name), "%s", VodolazItemNames[item_index]);
        item_price = VodolazItemPrices[price_index];
        
        //   
        GivePlayerMoneyEx(playerid, item_price, "  ", true, true);
        
        //   
        VodoRewardCount[playerid] -= 1;
        UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
        
        //   
        new msg[128];
        format(msg, sizeof(msg), "  {FF9900}%s {FFFFFF} {00FF00}%d{FFFFFF}!", 
            item_name, item_price);
        SendClientMessage(playerid, -1, msg);
        
        format(msg, sizeof(msg), " : {FF9900}%d", 
            VodoGetReward(playerid));
        SendClientMessage(playerid, -1, msg);
        
        //   
        DeletePVar(playerid, "Vodolaz_ItemsCount");
    }
    return 1;
}
//   SYS_VODO_OnDialogResponse :
if(dialogid == 58911) //   
{
    if(response)
    {
        new items_count = GetPVarInt(playerid, "vodo_items_count");
        
        if(items_count <= 0)
        {
            SendClientMessage(playerid, -1, ":   !");
            DeletePVar(playerid, "vodo_items_count");
            return 1;
        }
        
        //      
        new max_items_in_list = min(items_count, 6);
        
        //    "  " (  )
        if(listitem == max_items_in_list)
        {
            //   
            new total_price = 0;
            
            //      
            for(new i = 0; i < items_count; i++)
            {
                total_price += (20000 + random(5001)); //  20000  25000  
            }
            
            //   
            GivePlayerMoneyEx(playerid, total_price, "   ", true, true);
            
            //   
            VodoRewardCount[playerid] = 0;
            UpdatePlayerDatabaseInt(playerid, "vodopr", 0);
            
            //  
            new msg[128];
            format(msg, sizeof(msg), "    ({FF9900}%d{FFFFFF} .)  {00FF00}%d{FFFFFF}!", 
                items_count, total_price);
            SendClientMessage(playerid, -1, msg);
        }
        else
        {
            //    
            if(items_count <= 0)
            {
                SendClientMessage(playerid, -1, "      !");
                DeletePVar(playerid, "vodo_items_count");
                return 1;
            }
            
            //     
            new price = 20000 + random(5001); //  20000  25000
            
            //   
            GivePlayerMoneyEx(playerid, price, "  ", true, true);
            
            //     1
            VodoRewardCount[playerid] -= 1;
            UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
            
            //  
            new msg[128];
            format(msg, sizeof(msg), "     {00FF00}%d{FFFFFF}!  : {FF9900}%d", 
                price, VodoGetReward(playerid));
            SendClientMessage(playerid, -1, msg);
        }
        
        //   
        DeletePVar(playerid, "vodo_items_count");
    }
    return 1;
}
if(dialogid == 58904)
{
    if(response)
    {
        new text[686];

        switch(listitem)
        {
            case 0:
            {
                if(PlayerBoatID[playerid] == INVALID_VEHICLE_ID) 
                    return SendClientMessage(playerid, -1, " !");
                
                //  :    GetPlayerData,    gettime()
                if(VodoTime[playerid] <= gettime())
                {
                    new rand = random(sizeof(vodovedisyda));
                    EnablePlayerGPS(playerid, 0, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]);
                    SetPVarInt(playerid, "vodomesto", rand);
                    SetPlayerSkin(playerid, 5344);
                    //     ( 1 )
                    GPSPoint(playerid, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]);
                    VodoTime[playerid] = 0;
                    UpdatePlayerDatabaseInt(playerid, "vodotime", 0);
                    
                    SendClientMessage(playerid, -1, "      gps [,   GPS ,    ]!");
                }
                else 
                {
                    
                    new message[128];
                    format(message, sizeof(message), "  2-   ! ");
                    ShowNewNotification(playerid, 2, 5, 1, 10, message, "");
                }  
            }
        }         
    }     
}
    if(dialogid == 58902)
    {
        if(response)
        {
            new text[686];

            switch(listitem)
            {
            
            case 0,1,2,3,4,5:
            {
            SetPVarInt(playerid, "vodocar", listitem);
            format(text, sizeof text,"      {f0de41}%s {ffffff} {f0de41}%d {ffffff}  {f0de41}1?\n\n{ffffff}       .\n ,       ,     (1000/)", gBoatNames[listitem], gBoatPrices[listitem]);
            ShowPlayerDialog(playerid, 58903, DIALOG_STYLE_MSGBOX, "{ed4b00} {fff7fc} | ", text,"","");
            }
            }
            
         }
         else {
        ShowPlayerDialog(playerid, 58901, DIALOG_STYLE_LIST, "{ed4b00} ", "{ed4b00}1.{fff7fc}  \t\t\t\t{dbd5d9}  \n{ed4b00}2.{fff7fc}   \t\t\t\t{dbd5d9}  \n{ed4b00}3.{fff7fc}    \t\t\t\t{dbd5d9}  ","","");
        }
     }
if(dialogid == 58903)
    {
        if(response)
        {
            new text[286];
CreateLoadkaVodolaz(playerid);
            
        }
        else {
        ShowPlayerDialog(playerid, 58901, DIALOG_STYLE_LIST, "{ed4b00} ", "{ed4b00}1.{fff7fc}  \t\t\t\t{dbd5d9}  \n{ed4b00}2.{fff7fc}   \t\t\t\t{dbd5d9}  \n{ed4b00}3.{fff7fc}    \t\t\t\t{dbd5d9}  ","","");
        }
  }
if(dialogid == 58901)
    {
        if(response)
        {
            new text[286];

            switch(listitem +1)
            {
            case 1:
            {
            ShowPlayerDialog(playerid, 58902, DIALOG_STYLE_TABLIST_HEADERS, "{ed4b00} {fff7fc} | ",
" \t\t\n\
{ed4b00}1.{fff7fc}\t7000.\t{dbd5d9}  \n\
{ed4b00}2.{fff7fc} \t15000\t{dbd5d9}  \n\
{ed4b00}3.{fff7fc}Speedy Yacht\t17000.\t{dbd5d9}  \n\
{ed4b00}4.{fff7fc}Marine Yacht\t20000\t{dbd5d9}  \n\
{ed4b00}5.{fff7fc}Sea Yacht\t45000.\t{dbd5d9}  \n\
{ed4b00}6.{fff7fc}Ocean Yacht\t100000.\t{dbd5d9}  ", //  ..
"", "");
            }
            case 2:
            {
            

            ShowPlayerDialog(playerid, 58904, DIALOG_STYLE_LIST, "{ed4b00} {fff7fc} |  ", "{ed4b00}1.{ffffff} ()","","");
            
            }
            case 3:
            {
            callcmd::vodopredmpokaz(playerid, "");
            }
            }
          }
     }
    #if defined vodo_OnDialogResponse
    return vodo_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_VODO_OnDialogResponse
#undef SYS_VODO_OnDialogResponse
#else
#define _ALS_SYS_VODO_OnDialogResponse
#endif
#define SYS_VODO_OnDialogResponse vodo_OnDialogResponse
#if defined vodo_OnDialogResponse
forward vodo_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
stock CreateLoadkaVodolaz(playerid)
{

    new vehicleid = INVALID_VEHICLE_ID;
    new modelid;
    new rand;
    new Float:spawnX, Float:spawnY, Float:spawnZ, Float:spawnAngle;
    new message[128];
    
    // ,      
    if(PlayerBoatID[playerid] != INVALID_VEHICLE_ID)
    {
        if(IsValidVehicle(PlayerBoatID[playerid]))
        {
            DestroyVehicle(PlayerBoatID[playerid]);
        }
        PlayerBoatID[playerid] = INVALID_VEHICLE_ID;
    }
    
    //   
    modelid = gBoatCarID[GetPVarInt(playerid, "vodocar")];
    
    //   
    if(modelid <= 0)
    {
        SendClientMessage(playerid, -1, ":   !");
        return 0;
    }
    GivePlayerMoneyEx(playerid, -gBoatPrices[GetPVarInt(playerid, "vodocar")], " ", true, true);
    //       
    if(IsPlayerInRangeOfPoint(playerid, 50.0, 2501.043701, -1253.509033, 1.436212))
    {
        rand = random(sizeof(lodkaPositions));
        spawnX = lodkaPositions[rand][posX];
        spawnY = lodkaPositions[rand][posY];
        spawnZ = lodkaPositions[rand][posZ];
        spawnAngle = lodkaPositions[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        //    
        format(message, sizeof(message), "   : X=%.6f, Y=%.6f, Z=%.6f, =%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
    //    SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, -2528.527832, 357.601684, 2.100287))
    {
        rand = random(sizeof(lodkaPositionsL));
        spawnX = lodkaPositionsL[rand][posX];
        spawnY = lodkaPositionsL[rand][posY];
        spawnZ = lodkaPositionsL[rand][posZ];
        spawnAngle = lodkaPositionsL[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        format(message, sizeof(message), "   : X=%.6f, Y=%.6f, Z=%.6f, =%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
      //  SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, 652.959899, 173.051406, 2.08114))
    {
        rand = random(sizeof(lodkaPositionsA));
        spawnX = lodkaPositionsA[rand][posX];
        spawnY = lodkaPositionsA[rand][posY];
        spawnZ = lodkaPositionsA[rand][posZ];
        spawnAngle = lodkaPositionsA[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        format(message, sizeof(message), "   : X=%.6f, Y=%.6f, Z=%.6f, =%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
     //   SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, 2273.179443, 310.147216, 4.03999))
    {
        rand = random(sizeof(lodkaPositionsB));
        spawnX = lodkaPositionsB[rand][posX];
        spawnY = lodkaPositionsB[rand][posY];
        spawnZ = lodkaPositionsB[rand][posZ];
        spawnAngle = lodkaPositionsB[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        format(message, sizeof(message), "   : X=%.6f, Y=%.6f, Z=%.6f, =%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
      //  SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else
    {
        SendClientMessage(playerid, -1, "       !");
        return 0;
    }
    
    // ,   
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        SendClientMessage(playerid, -1, "  !");
        return 0;
    }
    
    //  ID 
    PlayerBoatID[playerid] = vehicleid;
    
    //    
    //PutPlayerInVehicle(playerid, vehicleid, 0);
    
    //  
   // SendClientMessage(playerid, -1, " !   .");
    return 1;
}
public SYS_VODO_OnPlayerSpawn(playerid)
{
    PlayerBoatID[playerid] = INVALID_VEHICLE_ID;

    #if defined vodo_OnPlayerSpawn
        return vodo_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_VODO_OnPlayerSpawn
    #undef SYS_VODO_OnPlayerSpawn
#else
    #define _ALS_SYS_VODO_OnPlayerSpawn
#endif
#define SYS_VODO_OnPlayerSpawn vodo_OnPlayerSpawn
#if defined vodo_OnPlayerSpawn
    forward vodo_OnPlayerSpawn(playerid);
#endif



forward vodo_OnPlayerEnterCheckpoint(playerid);
public vodo_OnPlayerEnterCheckpoint(playerid)
{
    return 1;
}

public SYS_VODO_OnPlayerEnterCheckpoint(playerid)
{
    return vodo_OnPlayerEnterCheckpoint(playerid);
}
   #if defined _ALS_SYS_VODO_OnPlayerEnterCheckpoint
    #undef SYS_VODO_OnPlayerEnterCheckpoint
#else
    #define _ALS_SYS_VODO_OnPlayerEnterCheckpoint
#endif
#define SYS_VODO_OnPlayerEnterCheckpoint vodo_OnPlayerEnterCheckpoint
#if defined vodo_OnPlayerEnterCheckpoint
    forward vodo_OnPlayerEnterCheckpoint(playerid);
#endif

CMD:vodogo(playerid)
{

if(VodoCompatGetPlayerLevel(playerid)<18) return ShowNotificationLaird(playerid, 2, 6, 0, 0, "   18 !", "");
ShowPlayerDialog(playerid, 58901, DIALOG_STYLE_LIST, "{ed4b00} ", "{ed4b00}1.{fff7fc}  \t\t\t\t{dbd5d9}  \n{ed4b00}2.{fff7fc}   \t\t\t\t{dbd5d9}  \n{ed4b00}3.{fff7fc}    \t\t\t\t{dbd5d9}  ","","");
}
/*
CMD:vodopremd(playerid)
{
    new rand = GetPVarInt(playerid, "vodomesto");
    
    if(IsPlayerInRangeOfPoint(playerid, 200.0, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]))
    {
        // ,     
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        
        //    
        for(new i = 0; i < sizeof(yg_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yg_areas[i]))
            {
                //     
                if(PlayerVodoItems[playerid][yg_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][yg_collected][i] = 1; //   
                    SendClientMessage(playerid, -1, "  ");
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas1[i]))
            {
                if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][bat1_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas2[i]))
            {
                if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][bat2_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas1[i]))
            {
                if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][lit1_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas2[i]))
            {
                if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][lit2_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(yzka_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yzka_areas[i]))
            {
                if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][yzka_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        SendClientMessage(playerid, -1, "       !");
        return 1;
    }
    else return SendClientMessage(playerid, -1,"   \n      [,   GPS ,    ]!!");
}*/
CMD:vodopremd(playerid)
{
    new rand = GetPVarInt(playerid, "vodomesto");
    
    if(IsPlayerInRangeOfPoint(playerid, 200.0, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]))
    {
        // ,     
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        
        //    
        for(new i = 0; i < sizeof(yg_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yg_areas[i]))
            {
                //     
                if(PlayerVodoItems[playerid][yg_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][yg_collected][i] = 1; //   
                    SendClientMessage(playerid, -1, "  ");
                    
                    // ,       
                    CheckAllItemsCollected(playerid, "yg", i);
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas1[i]))
            {
                if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][bat1_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    
                    // ,       
                    CheckAllItemsCollected(playerid, "bat1", i);
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas2[i]))
            {
                if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][bat2_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    
                    // ,       
                    CheckAllItemsCollected(playerid, "bat2", i);
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas1[i]))
            {
                if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][lit1_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    
                    // ,       
                    CheckAllItemsCollected(playerid, "lit1", i);
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas2[i]))
            {
                if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][lit2_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    
                    // ,       
                    CheckAllItemsCollected(playerid, "lit2", i);
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(yzka_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yzka_areas[i]))
            {
                if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
                {
                    VodoRewardCount[playerid] += 1;
                    UpdatePlayerDatabaseInt(playerid, "vodopr", VodoGetReward(playerid));
                    PlayerVodoItems[playerid][yzka_collected][i] = 1;
                    SendClientMessage(playerid, -1, "  ");
                    
                    // ,       
                    CheckAllItemsCollected(playerid, "yzka", i);
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, -1, "    !");
                    return 1;
                }
            }
        }
        
        SendClientMessage(playerid, -1, "       !");
        return 1;
    }
    else return SendClientMessage(playerid, -1,"   \n      [,   GPS ,    ]!!");
}
//        
stock CheckAllItemsCollected(playerid, zone_name[], collected_index)
{
    // ,       
    new all_collected = 1;
    
    if(strcmp(zone_name, "yg") == 0)
    {
        for(new i = 0; i < sizeof(yg_areas); i++)
        {
            if(PlayerVodoItems[playerid][yg_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "bat1") == 0)
    {
        for(new i = 0; i < sizeof(bat_areas1); i++)
        {
            if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "bat2") == 0)
    {
        for(new i = 0; i < sizeof(bat_areas2); i++)
        {
            if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "lit1") == 0)
    {
        for(new i = 0; i < sizeof(lit_areas1); i++)
        {
            if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "lit2") == 0)
    {
        for(new i = 0; i < sizeof(lit_areas2); i++)
        {
            if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "yzka") == 0)
    {
        for(new i = 0; i < sizeof(yzka_areas); i++)
        {
            if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    
    //    
    if(all_collected == 1)
    {
        //    
        new Float:player_x, Float:player_y, Float:player_z;
        GetPlayerPos(playerid, player_x, player_y, player_z);
        
        //  
        new Float:kapitan_coords[4][3] = {
            {-2528.527832, 357.601684, 2.100287},    // kapitanp1
            {652.959899, 173.051406, 2.081145},      // kapitanp2
            {2273.179443, 310.147216, 4.03999},      // kapitanp3
            {2501.043701, -1253.509033, 1.436212}    // kapitanp4
        };
        
        //   
        new closest_kapitan = 0;
        new Float:closest_distance = Float:0x7F800000; //   float
        
        for(new i = 0; i < 4; i++)
        {
            new Float:distance = GetPlayerDistanceFromPoint(playerid, 
                kapitan_coords[i][0], 
                kapitan_coords[i][1], 
                kapitan_coords[i][2]);
            
            if(distance < closest_distance)
            {
                closest_distance = distance;
                closest_kapitan = i;
            }
        }
        
        //     
        new kapitan_name[32];
        switch(closest_kapitan)
        {
            case 0: kapitan_name = " ";
            case 1: kapitan_name = " ";
            case 2: kapitan_name = " ";
            case 3: kapitan_name = " ";
        }
        
        //    GPS
        EnablePlayerGPS(playerid, 0, 
            kapitan_coords[closest_kapitan][0], 
            kapitan_coords[closest_kapitan][1], 
            kapitan_coords[closest_kapitan][2]);
        
        //  
        new msg[128];
        format(msg, sizeof(msg), "      !   {FF9900}%s {FFFFFF} .", kapitan_name);
        SendClientMessage(playerid, -1, msg);
        SendClientMessage(playerid, -1, "    GPS.");
        VodoTaskCount[playerid] += 1;
        UpdatePlayerDatabaseInt(playerid, "vodozadanie", VodoTaskCount[playerid]);
        if(VodoTaskCount[playerid]==2)
        {
 VodoTaskCount[playerid] = 0;
        UpdatePlayerDatabaseInt(playerid, "vodozadanie", VodoTaskCount[playerid]);       
 new time = gettime();
new stop_time = time + 3600; // 3600  = 1 
VodoTime[playerid] = stop_time;
UpdatePlayerDatabaseInt(playerid, "vodotime", VodoTime[playerid]);
        }
        //    ,    
        SetPVarInt(playerid, "Vodolaz_ZoneCompleted", 1);
        SetPVarInt(playerid, "Closest_Kapitan", closest_kapitan);
    }
    else
    {
        //      ,   
        new items_left = 0;
        
        if(strcmp(zone_name, "yg") == 0)
        {
            for(new i = 0; i < sizeof(yg_areas); i++)
            {
                if(PlayerVodoItems[playerid][yg_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "bat1") == 0)
        {
            for(new i = 0; i < sizeof(bat_areas1); i++)
            {
                if(PlayerVodoItems[playerid][bat1_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "bat2") == 0)
        {
            for(new i = 0; i < sizeof(bat_areas2); i++)
            {
                if(PlayerVodoItems[playerid][bat2_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "lit1") == 0)
        {
            for(new i = 0; i < sizeof(lit_areas1); i++)
            {
                if(PlayerVodoItems[playerid][lit1_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "lit2") == 0)
        {
            for(new i = 0; i < sizeof(lit_areas2); i++)
            {
                if(PlayerVodoItems[playerid][lit2_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "yzka") == 0)
        {
            for(new i = 0; i < sizeof(yzka_areas); i++)
            {
                if(PlayerVodoItems[playerid][yzka_collected][i] == 0) items_left++;
            }
        }
        
        new msg[64];
        format(msg, sizeof(msg), "     : {FF9900}%d", items_left);
        SendClientMessage(playerid, -1, msg);
    }
}

//       

CMD:vodopredmpokaz(playerid)
{
    new items_count = VodoGetReward(playerid);
    
    if(items_count <= 0)
    {
        SendClientMessage(playerid, -1, "     !");
        return 1;
    }
    
    new query[256];
    new listed = 0;
    new dialog_text[1024] = "\t\t\n";
    
    //        
    for (new i = 0; i < items_count; i++)
    {
        new item_index = i % sizeof(VodolazItemNames); //  
        new price_index = i % sizeof(VodolazItemPrices); //    
        
        format(query, sizeof query, "%d\t%s\t%d\n", 
            listed + 1, 
            VodolazItemNames[item_index], 
            VodolazItemPrices[price_index]
        );
        strcat(dialog_text, query);
        listed++;
    }
    
    //     
    SetPVarInt(playerid, "Vodolaz_ItemsCount", listed);
    
    ShowPlayerDialog(playerid, 58909, DIALOG_STYLE_TABLIST_HEADERS, 
        "{ed4b00} {fff7fc} |  ",
        dialog_text,
        "", ""
    );
    
    return 1;
}
stock GPSPoint(playerid, Float:x, Float:y, Float:z, color = 0xFF0000FF) 
{
    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT8, 0x1A);

    BS_WriteValue(bs, PR_UINT32, color);

    BS_WriteValue(bs, PR_FLOAT, x);
    BS_WriteValue(bs, PR_FLOAT, y);
    BS_WriteValue(bs, PR_FLOAT, z);

    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED); 
    BS_Delete(bs);

    return 1;
} 

//     @HOZYAEVSTUDIO
//    @HOZYAEVSTUDIO
//    @HOZYAEVSTUDIO
//    @HOZYAEVSTUDIO
