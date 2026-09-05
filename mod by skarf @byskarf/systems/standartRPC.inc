#define PACKET_BLACKRRPC					251
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
#define GUITuning1 							28
#define GUITuning2 							28
#define GUITuning3 							28
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

stock ShowPlayerGUI(playerid, guiid, Node:json)
{
	JSON_SetInt(json, "o", 1);
	OnPacketIncoming(playerid, guiid, json);
	JSON_Cleanup(json);
}
stock HidePlayerGUI(playerid, guiid) 
{
	new Node:json = JSON_Object();
	JSON_SetInt(json, "c", 1);
	OnPacketIncoming(playerid, guiid, json);
	JSON_Cleanup(json);
}

stock ShowNewNotification(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, 13, JSONObject);
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

    ShowPlayerGUI(playerid, 13, JSONObject);
}

stock ShowNotification(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, 13, JSONObject);
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
    new data[1024];
    JSON_Stringify(json, data);
    
    printf("[OnPacketIncoming] Incoming ui for %d, json: %s", playerid, json);
    printf("[OnPacketIncoming] GUI: %d, Params: %s", guiid, data);
    
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, guiid);
    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);
    
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock SetPlayerCleanChat(playerid, clean)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 0); 
	 
	BS_WriteValue(bitstream, PR_UINT8, clean);   

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
