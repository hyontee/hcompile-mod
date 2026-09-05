#include "../include/json.inc" //плагин для json

#define BrDialogVoice 						0
#define BrDialogPlates 						1
#define BrDialogFuelFill 					2
#define BrDialogDiner 						3
#define BrDialogHack 						4
#define BrDialogRobbery 					5
#define BrDialogRent 						6
#define BrDialogWires 						7
#define BrDialogPipes 						8
#define BrAudioDialog 						9
#define BrDialogWindow 						10
#define BrChooseServerDialog 				11
#define BrFingerPrintDialog 				12
#define BrNotification 						13
#define BrDialogMenu 						14
#define BrDialogDance 						15
#define BrDialogTaxi 						16
#define BrDialogTaxiOrder 					17
#define BrDialogTaxiRating 					18
#define BrDialogGraphicsSetting 			19
#define BrCaptcha 							20
#define BrDialogMap 						21
#define GUIDonate 							22
#define BrDialogSawmill 					23
#define GUISmiEditor 						24
#define GUIPlayersList 						25
#define BrNewCaptcha 						26
#define GUIRadialMenuForCar 				27
#define GUITuning 							28
#define GUIHalloween 						30
#define GUIHalloweenGame 					31
#define HudManager 							32
#define GUIUsersInventory 					33
#define GUICarsTrunkOrCloset 				34
#define GUIBlackPassBanner 					35
#define GUISocialInteraction 				36
#define GUIDrivingSchool 					37
#define GUIRegistration 					38
#define GUITutorial 						39
#define GUIWoundSystem 						40
#define GUIVipAccount 						41
#define GUIEntertainmentSystem 				42
#define GUIEntertainmentSystemFinalWindow 	43
#define GUIFamilySystem 					45
#define GUIFractionSystem 					46
#define GUISpawnLocation 					50
#define GUIOpenURL							51 
#define GUISocialNetworkLink 				52	
#define GUIInviteBanner 					55

#define PACKET_BLACKRRPC					252

stock ShowPlayerGUI(playerid, guiid, Node:json)
{
	JSON_SetInt(json, "o", 1);
	OnPacketIncoming(playerid, guiid, json);
}
stock HidePlayerGUI(playerid, guiid) //, Node:json)
{
	new Node:json = JSON_Object(); 
	JSON_SetInt(json, "c", 1);
	OnPacketIncoming(playerid, guiid, json);
}

stock ShowNotificationNew(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, BrNotification, JSONObject);
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_BLACKRRPC);
	
	BS_WriteValue(bitstream, PR_UINT16, guiid);
	
	new data[1024]; //4294967295
    JSON_Stringify(json, data); 
	
    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
}

stock TestBanner(playerid)
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", 1);
    ShowPlayerGUI(playerid, GUIBlackPassBanner, JSONObject);
}

stock Inventory(playerid)
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "o", 1);
    ShowPlayerGUI(playerid, GUIUsersInventory, JSONObject);

}

//by KBAS's  t.me/kbasstudio 
stock SetPlayerCleanChat(playerid, clean)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 0); 
	 
	BS_WriteValue(bitstream, PR_UINT8, clean);   

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock SetVehicleDriftForPlayer(playerid, vehicleid, value)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 5); 
	
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);  
	BS_WriteValue(bitstream, PR_UINT8, value);   

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock ShowPlayerBackground(playerid, showtime, waittime, hidetime)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 13); 
	
	BS_WriteValue(bitstream, PR_UINT32, showtime);  
	BS_WriteValue(bitstream, PR_UINT32, waittime);  
	BS_WriteValue(bitstream, PR_UINT32, hidetime);  

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock SetPlayerX2(playerid, value, tovalue)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 24); 
	
	BS_WriteValue(bitstream, PR_UINT8, value); 
	BS_WriteValue(bitstream, PR_UINT8, tovalue); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock TogglePlayerServerIcon(playerid, value)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 25); 
	
	BS_WriteValue(bitstream, PR_UINT8, value); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock TogglePlayerChat(playerid, toggle)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 27); 
	
	BS_WriteValue(bitstream, PR_UINT8, toggle); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock SendPlayerFireCarValue(playerid, value)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 30); 
	
	BS_WriteValue(bitstream, PR_UINT8, value); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock SendPlayerTreesWork(playerid, value)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 32); 
	
	BS_WriteValue(bitstream, PR_UINT8, value); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock SendPlayerHudFone(playerid, value)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 33); 
	
	BS_WriteValue(bitstream, PR_UINT8, value); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock SendFamilyInfoPackage(playerid, isFamily)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 34); 
	
	BS_WriteValue(bitstream, PR_UINT8, isFamily); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock SendPlayerHaloweenMed(playerid, value)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 38); 
	
	BS_WriteValue(bitstream, PR_UINT8, value); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

new car_game_ids[][2] = {
    {5, 555},
    {6, 549},
    {7, 401},
    {8, 479},
    {9, 496},
    {10, 404},
    {11, 458},
    {12, 585},
    {13, 536},
    {14, 529},
    {15, 534},
    {16, 542},
    {17, 540},
    {18, 559},
    {19, 421},
    {20, 2554},
    {21, 2548},
    {22, 419},
    {23, 562},
    {24, 507},
    {25, 426},
    {26, 516},
    {27, 467},
    {28, 527},
    {29, 445},
    {30, 589},
    {31, 587},
    {32, 436},
    {33, 560},
    {34, 550},
    {35, 603},
    {36, 2552},
    {37, 565},
    {38, 551},
    {39, 526},
    {40, 442},
    {41, 489},
    {42, 543},
    {43, 480},
    {44, 558},
    {45, 495},
    {46, 475},
    {47, 503},
    {48, 410},
    {49, 402},
    {50, 2553},
    {51, 505},
    {52, 2547},
    {53, 502},
    {54, 400},
    {55, 604},
    {56, 405},
    {57, 506},
    {58, 2550},
    {59, 466},
    {60, 2545},
    {61, 490},
    {62, 420},
    {63, 533},
    {64, 2546},
    {65, 494},
    {66, 429},
    {67, 451},
    {68, 2544},
    {69, 2551},
    {70, 2549},
    {71, 579},
    {72, 541},
    {73, 411},
    {74, 415},
    {75, 2543},
    {76, 462},
    {77, 468},
    {78, 461},
    {79, 463},
    {80, 523},
    {81, 586},
    {82, 521},
    {83, 581},
    {84, 522},
    {85, 582},
    {86, 529},
    {87, 470},
    {88, 416},
    {89, 516},
    {90, 466},
    {201, 413},
    {202, 418},
    {195, 440},
    {211, 2555},
    {212, 2557},
    {213, 2565},
    {214, 2566},
    {215, 2560},
    {216, 2561},
    {217, 2568},
    {218, 2567},
    {219, 2559},
    {220, 2558},
    {353, 2583},
    {221, 2564},
    {222, 2563},
    {223, 2570},
    {224, 2569},
    {275, 2571},
    {276, 2572},
    {327, 2574},
    {328, 2575},
    {329, 2573},
    {330, 2577},
    {331, 2576},
    {366, 2586},
    {367, 2585},
    {349, 2582},
    {400, 412},
    {401, 439},
    {402, 492},
    {403, 547},
    {404, 491},
    {405, 546},
    {406, 2589},
    {407, 2588},
    {408, 2587},
    {409, 483},
    {410, 2590},
    {411, 2591},
    {413, 452},
    {414, 453},
    {415, 454},
    {416, 472},
    {417, 473},
    {418, 493},
    {424, 2592},
    {426, 2594},
    {427, 2596},
    {428, 2595},
    {429, 2593},
    {444, 2597},
    {445, 2598},
    {446, 2599},
    {447, 2600},
    {448, 2601},
    {449, 2602},
    {450, 2603},
    {451, 2604},
    {452, 2607},
    {453, 2608},
    {454, 2609},
    {455, 2610},
    {456, 2611},
    {459, 448},
    {460, 2616},
    {461, 2617},
    {465, 2618},
    {466, 2619},
    {467, 2620},
    {468, 2621},
    {469, 2622},
    {470, 2623},
    {471, 2624},
    {472, 2625},
    {473, 2626},
    {474, 2627},
    {484, 434}
};

new clothes_game_ids[][2] = {
    {475, 11917},
    {462, 12293},
    {463, 12291},
    {457, 14386},
    {458, 14388},
    {419, 5323},
    {430, 5326},
    {431, 5325},
    {425, 5362},
    {420, 5367},
    {421, 5365},
    {399, 18606},
    {390, 310},
    {391, 18621},
    {392, 311},
    {393, 18620},
    {394, 18623},
    {395, 18624},
    {396, 18625},
    {397, 18626},
    {398, 18628},
    {346, 2},
    {344, 302},
    {345, 301},
    {332, 196},
    {333, 129},
    {334, 130},
    {335, 24},
    {340, 197},
    {336, 245},
    {337, 243},
    {338, 89},
    {339, 88},
    {341, 10},
    {342, 92},
    {343, 99},
    {315, 110},
    {313, 108},
    {311, 95},
    {322, 49},
    {323, 53},
    {324, 160},
    {314, 109},
    {312, 106},
    {316, 165},
    {317, 166},
    {318, 174},
    {319, 5},
    {320, 267},
    {321, 283},
    {325, 162},
    {326, 210},
    {238, 65},
    {257, 209},
    {239, 39},
    {240, 207},
    {225, 86},
    {226, 224},
    {227, 232},
    {228, 269},
    {205, 252},
    {206, 236},
    {207, 48},
    {208, 63},
    {91, 23},
    {92, 22},
    {229, 231},
    {93, 220},
    {94, 225},
    {230, 175},
    {95, 202},
    {96, 204},
    {97, 229},
    {203, 57},
    {231, 208},
    {232, 199},
    {233, 264},
    {234, 262},
    {235, 62},
    {98, 200},
    {99, 234},
    {100, 249},
    {101, 235},
    {236, 298},
    {237, 266},
    {209, 270},
    {210, 122}
};

IPacket:252(playerid, BitStream:bitstream)
{
 	new header, guiid;
 	BS_ReadValue(bitstream, PR_UINT8, header);
 	BS_ReadValue(bitstream, PR_UINT16, guiid);
 	
	new lenght, data[256];
	BS_ReadValue(bitstream, PR_UINT32, lenght);
	BS_ReadValue(bitstream, PR_STRING, data, lenght);

	new Node:JSONObject = JSON_Object();
    JSON_Parse(data, JSONObject);
 	
	switch(guiid)
	{ 
		case 22:
        {
            new type;
            JSON_GetInt(JSONObject, "t", type);

            switch(type)
            {
                case 2:
                {
                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}�������", "��� �������� �������, �� �������� ��������� �������!", "�������", "");

                    JSON_SetInt(JSONObject, "t", 2);

                    JSON_Stringify(JSONObject);
                    Donate(playerid, 1);

                    JSON_Cleanup(JSONObject);
                }

                case 0:
                {                    
                   new price, internal_id;

                   JSON_GetInt(JSONObject, "p", internal_id);
                   JSON_GetInt(JSONObject, "m", price);

                   new result = GetPlayerDonateRub(playerid) - price;
                   printf("result = %d", result);

                   new result_json[256];
                   JSON_Stringify(JSONObject, result_json);

                   printf("result (json) = %s", result_json);

                   if (GetPlayerDonateRub(playerid) < price || GetPlayerDonateRub(playerid) < GetPlayerDonateRub(playerid) - price)
                   {
                        JSON_SetInt(JSONObject, "t", 0);
                        JSON_SetInt(JSONObject, "y", 0);
                        JSON_SetInt(JSONObject, "k", 1);

                        JSON_SetString(JSONObject, "m", "������������ �������.");
                        JSON_SetString(JSONObject, "n", "��������� ���� ����� ������!");

                        JSON_Stringify(JSONObject);
                        Donate(playerid, 1);

                        JSON_Cleanup(JSONObject);

                        return;
                   }

                   switch(internal_id)
                   {
                        case 349,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,201,202,195,211,212,213,214,215,216,217,218,219,220,353,221,222,223,224,275,276,327,328,329,330,331,366,367,400,401,402,403,404,405,406,407,408,409,410,411,413,414,415,416,417,418,424,426,427,428,429,444,445,446,447,448,449,450,451,452,453,454,455,456,459,460,461,465,466,467,468,469,470,471,472,473,474,484:
                        {
                            if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                            {
                                JSON_SetInt(JSONObject, "t", 0);
                                JSON_SetInt(JSONObject, "y", 0);
                                JSON_SetInt(JSONObject, "k", -1);

                                JSON_SetString(JSONObject, "m", "��� ����� ��� ������� ������\n��������� ������.");
                                JSON_SetString(JSONObject, "n", "�� ������ ��������� �� � ������� {FFFF00}������.");
                                
                                JSON_Stringify(JSONObject);
                                Donate(playerid, 1);

                                JSON_Cleanup(JSONObject);
                                
                                return;
                            }

                            BuyPlayerCar(playerid, internal_id, FindGameId(internal_id, car_game_ids, sizeof(car_game_ids)), 0);
                            GivePlayerDonateRub(playerid, -price);

                            JSON_SetInt(JSONObject, "t", 0);
                            JSON_SetInt(JSONObject, "y", 1);

                            JSON_SetInt(JSONObject, "g", internal_id);

                            JSON_SetInt(JSONObject, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(JSONObject, "s", GetPlayerDonateRub(playerid));

                            JSON_SetString(JSONObject, "m", "�� ������� ��������� ����������!");
                            JSON_SetString(JSONObject, "n", "��� ���� ����� ��������� ����,\n����������� /car");

                            JSON_Stringify(JSONObject);
                            Donate(playerid, 1);

                            JSON_Cleanup(JSONObject);
                        }
                        case 475, 462, 463, 457, 458, 419, 430, 431, 425, 420, 421, 399, 390, 391, 392, 393, 394, 395, 396, 397, 398, 346, 344, 345, 332, 333, 334, 335, 340, 336, 337, 338, 339, 341, 342, 343, 315, 313, 311, 322, 323, 324, 314, 312, 316, 317, 318, 319, 320, 321, 325, 326, 238, 257, 239, 240, 225, 226, 227, 228, 205, 206, 207, 208, 91, 92, 229, 93, 94, 230, 95, 96, 97, 203, 231, 232, 233, 234, 235, 98, 99, 100, 101, 236, 237, 209, 210:
                        {
                            JSON_SetInt(JSONObject, "t", 0);
                            JSON_SetInt(JSONObject, "y", 1);

                            JSON_SetInt(JSONObject, "g", internal_id);

                            JSON_SetInt(JSONObject, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(JSONObject, "s", GetPlayerDonateRub(playerid) - 50);

                            JSON_SetString(JSONObject, "m", "�� ������� ��������� ������");
                            JSON_SetString(JSONObject, "n", "��� ���� ����� ����� �, ����������� ���������");

                            JSON_Stringify(JSONObject);
                            Donate(playerid, 1);

                            JSON_Cleanup(JSONObject);

                            BuyPlayerSkin(playerid, internal_id, FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids)));

                            GivePlayerDonateRub(playerid, -price);
                        }
                        case 179:
                        {
                            BuyPlayerCar(playerid, 12, 585, 0);
                            BuyPlayerSkin(playerid, 180, 30);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "���������", price, internal_id);
                        }
                        case 181:
                        {
                            BuyPlayerCar(playerid, 22, 419, 0);
                            BuyPlayerSkin(playerid, 182, 60);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "������", price, internal_id);
                        }
                        case 183:
                        {
                            BuyPlayerCar(playerid, 23, 562, 0);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            SetPlayerData(playerid, P_PREMIUM, 1);
         		            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "�������", price, internal_id);
                        }
                        case 185:
                        {
                            BuyPlayerCar(playerid, 28, 527, 0);

                            SetPlayerData(playerid, P_PREMIUM, 1);
         		            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "��������", price, internal_id);
                        }
                        case 269:
                        {
                            BuyPlayerSkin(playerid, 227, 232);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "��������", price, internal_id);
                        }
                        case 176:
                        {
                            GivePlayerMoney(playerid, 500000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "�������", price, internal_id);
                        }
                        case 177:
                        {
                            GivePlayerMoney(playerid, 1000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "�� �������", price, internal_id);
                        }
                        case 178:
                        {
                            GivePlayerMoney(playerid, 10000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "����������", price, internal_id);
                        }
                       case 102:
                       {
                       
					    if(GetPlayerDonateRub(playerid) >= 50)
						{
							Dialog
							(
								playerid, DIALOG_DONATE_CHANGE_NAME, DIALOG_STYLE_INPUT,
								"{FFCD00}��������� �����",
								"{FFFFFF}������� ����� ��� � ���� ����:",
								"��������", "�������"
							);
						}
						else JSON_SetString(JSONObject, "m", "������������ �������.");
                               
                               JSON_SetInt(JSONObject, "r", GetPlayerMoney(playerid));
					
                      } 
                   }
                }
            }
        }
    }
}

public: FindGameId(internalId, array[][], array_size) {
    for (new i = 0; i < array_size; i++) {
        if (array[i][0] == internalId) {
            return array[i][1];
        }
    }
    return -1;
}

public: BuyPlayerCar(playerid, internal_id, game_id, color)
{
    if(game_id == -1)
    {
        return;
    }

    new free_car_id = GetFreeOwnableCarID();

    new Float: pos_x = 2498.205810;
    new Float: pos_y = -742.256042;
    new Float: pos_z = 12.164166;
    new Float: angle = 356.240051;

    SetOwnableCarData(free_car_id, OC_OWNER_ID, GetPlayerAccountID(playerid));
    SetOwnableCarData(free_car_id, OC_MODEL_ID, game_id);
    SetOwnableCarData(free_car_id, OC_COLOR_1, color);
    SetOwnableCarData(free_car_id, OC_COLOR_2, 0);
    SetOwnableCarData(free_car_id, OC_POS_X, pos_x);
    SetOwnableCarData(free_car_id, OC_POS_Y, pos_y);
    SetOwnableCarData(free_car_id, OC_POS_Z, pos_z);
    SetOwnableCarData(free_car_id, OC_ANGLE, angle);

    strmid(g_ownable_car[free_car_id][OC_NUMBER], "regerds_test_number", 0, 8, 8);

    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());

    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new database_query[256];
    
    format(database_query, sizeof database_query, "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')", GetPlayerAccountID(playerid), game_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);

/*    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }
    */
}

public: BuyPlayerSkin(playerid, internal_id, game_id)
{
    SetPlayerData(playerid, P_SKIN, game_id);
    UpdatePlayerDatabaseInt(playerid, "skin", game_id);
    SetPlayerSkin(playerid, game_id);
    SetPlayerSkinInit(playerid);
}

public: ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), outcoming_data[512];

    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    JSON_SetInt(json_packet_data, "g", internal_id);

    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

    JSON_SetString(json_packet_data, "m", "�� ������� ��������� ����� -");
    JSON_SetString(json_packet_data, "n", pack_name);

    JSON_Stringify(json_packet_data, outcoming_data);
    Donate(playerid, 1);

    JSON_Cleanup(json_packet_data);
}