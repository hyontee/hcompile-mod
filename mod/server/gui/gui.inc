#include "json.inc"
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

stock Donate(playerid)
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "sv", 1);
    JSON_SetInt(JSONObject, "p", 0);
    JSON_SetInt(JSONObject, "r", GetPlayerMoney(playerid));
    JSON_SetInt(JSONObject, "d", GetPlayerDonateRub(playerid));
    ShowPlayerGUI(playerid, GUIDonate, JSONObject);
}

CMD:donate(playerid)
{
	Donate(playerid);
	SendClientMessage(playerid, 0xFFFFFFFF, "{00CED1}[DEBUG]{FFFFFF} GUI доната вызван");
	return 1;
}

CMD:siren(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleSirenForPlayer(playerid, vehicleid, 1);
   ShowNotificationNew(playerid, 2, 5, -1, -1, "Сирена включена, нажмите на гудок чтоб её активировать", "");
}

CMD:temno(playerid)
{
   ShowPlayerBackground(playerid, 4000, 4000, 2000);
}

CMD:rpc(playerid)
{
    ShowPlayerDialog(playerid, 1100, DIALOG_STYLE_MSGBOX, 
    "{FFFF00}| {FFFFFF}RPC Команды", 
    "{FFFF00}| {FFFFFF}/siren выдача сирены\n\
    {FFFF00}| {FFFFFF}/zdrift выдача прошивки дрифт (выключение /zdriftoff)\n\
    {FFFF00}| {FFFFFF}/temno затемнение экрана\n\
    {FFFF00}| {FFFFFF}/x2 выдача х2\n\
    {FFFF00}| {FFFFFF}/lc выдача лаунча\n\
    {FFFF00}| {FFFFFF}/hl дальний свет\n\
    {FFFF00}| {FFFFFF}/toner выдать тонировку\n\
    {FFFF00}| {FFFFFF}/tablet планшет (если не работает по кнопке)\n\
    {FFFF00}| {FFFFFF}/interbutton интерактивная кнопка (скрытие /cinterbutton)\n\
    {FFFF00}| {FFFFFF}/banner бп баннер\n\
    {FFFF00}| {FFFFFF}/inv инвентарь \n\
    {FFFF00}| {FFFFFF}/donate донат\n\
    {FFFF00}| {FFFFFF}/testnotify тест уведа\n\
    {FFFF00}| {FFFFFF}/evh кнопка эвента на худе\n\
    {FFFF00}| {FFFFFF}Тест 3д метки в /gps", 
    "Закрыть", ""
    );
    return 1;
}

CMD:evh(playerid)
{
	EventHudButton(playerid);
	SendClientMessage(playerid, 0xFFFFFFFF, "{00CED1}[DEBUG]{FFFFFF} Кнопка эвента вызвана");
	return 1;
}

CMD:zdrift(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleDriftForPlayer(playerid, vehicleid, 1);
   ShowNotificationNew(playerid, 2, 5, -1, -1, "Дрифт включен!", "");
}

CMD:zdriftoff(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleDriftForPlayer(playerid, vehicleid, 0);
   ShowNotificationNew(playerid, 2, 5, -1, -1, "Дрифт отключен!", "");
}

CMD:testnotify(playerid)
{
ShowNotificationNew(playerid, 2, 5, -1, -1, "Тест уведомление!", "");
return 1;
}

CMD:inv(playerid)
{
Inventory(playerid);
SendClientMessage(playerid, 0xFFFFFFFF, "{00CED1}[DEBUG]{FFFFFF} GUI инвентаря вызван");
return 1;
}

CMD:banner(playerid)
{
TestBanner(playerid);
SendClientMessage(playerid, 0xFFFFFFFF, "{00CED1}[DEBUG]{FFFFFF} BP баннер вызван");
return 1;
}

CMD:interbutton(playerid)
{
SendClientMessage(playerid, 0xFFFFFFFF, "{00CED1}[DEBUG]{FFFFFF} Интерактивная кнопка вызвана");
ShowInterButton(playerid);
return 1;
}

CMD:cinterbutton(playerid)
{
HideInterButton(playerid);
SendClientMessage(playerid, 0xFFFFFFFF, "{00CED1}[DEBUG]{FFFFFF} Интерактивная кнопка скрыта");
return 1;
}

CMD:tablet(playerid)
{
    new jsonStr[1024];
    
    format(jsonStr, sizeof(jsonStr), 
        "{\"a\":1,\"ac\":[{\"id\":24}],\"d\":{\"ar\":1,\"av\":1,\"bg\":1,\"exm\":%d,\"exp\":%d,\"fn\":\"{FFFFFF}Отсутствует \",\"lv\":%d,\"v\":2},\"n\":[{\"id\":18}],\"o\":1}",
        GetExpToNextLevel(playerid), GetPlayerExp(playerid), GetPlayerLevel(playerid)
    );
    
    new Node:json = JSON_Object();
    JSON_Parse(jsonStr, json);
    ShowPlayerGUI(playerid, 113, json);
    SendClientMessage(playerid, 0xFFFFFFFF, "{00CED1}[DEBUG]{FFFFFF} Интерфейс планшета вызван");
    JSON_Cleanup(json);    
    return 1;
}

stock Inventory(playerid)
{
    new Node:JSONObject = JSON_Object();
    new name[MAX_PLAYER_NAME];
    
    GetPlayerName(playerid, name, sizeof(name));
    
    JSON_SetInt(JSONObject, "o", 1); 
    JSON_SetString(JSONObject, "n", name); 
    JSON_SetInt(JSONObject, "lv", 1); 
    JSON_SetInt(JSONObject, "id", playerid); 
    JSON_SetInt(JSONObject, "w", 5); 
    JSON_SetInt(JSONObject, "mw", 50);
    JSON_SetInt(JSONObject, "s", 100); 
    JSON_SetInt(JSONObject, "v", 0); 
    JSON_SetInt(JSONObject, "ps", GetPlayerSkin(playerid)); 
    JSON_SetInt(JSONObject, "m", 10000); 

    new Node:item = JSON_Object();
    JSON_SetInt(item, "id", 1);
    JSON_SetString(item, "name", "               ");
    JSON_SetString(item, "name_store", "      ");
    JSON_SetString(item, "desc", "                              ");
    JSON_SetInt(item, "modelid", 907);
    JSON_SetInt(item, "weight", 3);
    JSON_SetInt(item, "addw", 50);
    JSON_SetInt(item, "fold", 1);
    JSON_SetInt(item, "rarity", 2);
    JSON_SetInt(item, "itemType", 2);
    JSON_SetInt(item, "tradeMaxPrice", 450000);
    
    
    new Node:itemsArray = JSON_Array();
    JSON_ArrayAppend(itemsArray, "", item);
    
    
    JSON_SetArray(JSONObject, "it", itemsArray);
    JSON_SetInt(JSONObject, "sl", 20); 
    
    ShowPlayerGUI(playerid, GUIUsersInventory, JSONObject);
}
 
stock SetPlayerCleanChat(playerid, clean)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 0); 
	 
	BS_WriteValue(bitstream, PR_UINT8, clean);   

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

stock SetPlayerGPSLine(playerid, Float:x, Float:y, Float:z, color = 0xFFFF00FF)
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

stock CreateWayPoint(playerid, waypoint_id, Float:x, Float:y, Float:z, icon_id, color, Float:dist, interior)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(
        bs,
        PR_UINT16, waypoint_id,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z,
        PR_UINT32, icon_id,
        PR_UINT32, color,
        PR_FLOAT, dist,
        PR_UINT8, interior
    );
    PR_SendRPC(bs, playerid, 169, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}


stock DestroyWayPoint(playerid, waypoint_id)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, waypoint_id);
    PR_SendRPC(bs, playerid, 170, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock ShowInterButton(playerid)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 2);
    BS_WriteValue(bs, PR_UINT8, 1);
 
    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock HideInterButton(playerid)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 2);
    BS_WriteValue(bs, PR_UINT8, 0);
    
    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock EventHudButton(playerid)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 60); 
	
	BS_WriteValue(bitstream, PR_UINT8, 1); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}