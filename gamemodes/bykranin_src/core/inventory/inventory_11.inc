//>> Файл: bykranin_src/core/inventory/inventory_11.inc  (389 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: ShowNotificationNew, /notify, GetName, /123_test, ShowCases, /case, SetVehicleTonerr
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).

stock ShowNotificationNew(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new JSON:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    ShowPlayerGUI(playerid, GUINotificationNewStyle, JSONObject);
    return 1;
}

CMD:notify(playerid)
{
    ShowNotificationNew(playerid,  2, 6, 0, 0, "TEST NOTIF", "qq"); // вызов уведомление
    return 1;
}

stock GetName(playerid)
{
    static name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
cmd:123_test(playerid)
{
new vehicleid = GetPlayerOwnableCar(playerid);

AddVehicleComponent(vehicleid, Nitro[2][0]), SendClientMessage(playerid, COLOR_WHITE, !""SC"Нитро X10 успешно установлено");
return 1;
}
stock ShowCases(
    playerid, 
    currentScreen = 1, 
    selectedCaseId = 1, 
    selectedRewardPos = 0, 
    caseCount = 5, 
    goToCasePos = 0, 
    currentRewardIndex = 0, 
    currentRewardNumberForUi = 1, 
    bool:allRewardsOpened = false, 
    totalSprayedDust = 0, 
    selectedSprayedDust = 0, 
    bool:isSprayed = false, 
    bool:isNeedShowButtonSpray = false, 
    openingsCount = 0, 
    openingsProgressBarState = 0, 
    bool:isNeedClose = false, 
    valueOfCurrentDust = 500, 
    valueOfMaxDust = 1000, 
    bool:isHintsOpened = false, 
    bool:isMainHintDialogOpened = false, 
    bool:isHintsBonusInfoOpened = false, 
    buttonPurchaseType = 0, 
    bool:isShowDialogConfirmation = false, 
    dialogConfirmationContextType = 0, 
    valueOfOpenedCases = 5, 
    priceBcOpeningCases = 0, 
    getValueOfDust = 0, 
    bool:isShowDialogPreviewReward = false, 
    selectedBonusRewardId = 0, 
    bool:isGettingBonusReward = false, 
    bool:isNeedAddCountSuperCase = false, 
    bool:isAnimationNeed = false, 
    bool:isShowingShimmer = false, 
    bool:isTutorial = false, 
    donateType = 0,
    openingCaseId = 0, 
    numberOfOpenings = 1, 
    bool:openingAnimationActive = false, 
    currentOpenedRewardId = 0, 
    openingProgress = 0,
    openedRewardName[64] = "", 
    openedRewardRarity = 0, 
    openedRewardType = 0, 
    openedRewardValue = 0, 
    openedRewardRenderType = 0, 
    openedRewardSkinId = 0, 
    bool:openedRewardIsSprayed = false, 
    bool:openedRewardIsRender = false, 
    openedRewardImageName[64] = "", 
    openedRewardInternalId = 0, 
    openedRewardColor = 0, 
    Float:openedRewardZoom = 1.0, 
    Float:buttonsAnimatedFloat = 0.0, 
    Float:cardAnimatedFloat = 0.0, 
    Float:containerAnimatedFloat = 0.0, 
    Float:crossAnimatedFloat = 0.0, 
    Float:lottieAnimatedFloat = 0.0, 
    Float:rewardImageAngleAnimatedFloat = 0.0, 
    Float:rewardImageOffsetAnimatedFloat = 0.0, 
    Float:rewardImageSizeAnimatedFloat = 1.0, 
    Float:titleAnimatedFloat = 0.0, 
    bool:isButtonsEnabled = true, 
    bool:isOpeningCompleted = false, 
    openingDelay = 0, 
    imageSize = 0, 
    bool:isCrossVisible = false, 
    lottieCompositionId = 0,
    // ... остальные параметры ...
    caseOpeningDuration = 2000
)
{
    printf("[ShowCases] playerid: %d | screen: %d | selectedCaseId: %d | rewardPos: %d", playerid, currentScreen, selectedCaseId, selectedRewardPos);

    new JSON:JSONObject = JSON_Object();
    
    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "t", (currentScreen > 0 && currentScreen <= 10) ? currentScreen : 1);
    
    new playerName[MAX_PLAYER_NAME];
    if (GetPlayerName(playerid, playerName, sizeof(playerName)) == 1) {
        JSON_SetString(JSONObject, "n", playerName);
        printf("[ShowCases] Player name: %s", playerName);
    }
					else {
        JSON_SetString(JSONObject, "n", "Unknown");
        printf("[ShowCases] Player name not found, set as Unknown");
    }
    
    new donateRub = GetPlayerDonateRub(playerid);
    printf("[ShowCases] DonateRub: %d | Dust: %d/%d | Cases: %d", donateRub, valueOfCurrentDust, valueOfMaxDust, caseCount);

    // ... остальная генерация JSON (как в твоём коде) ...

    // Debug output JSON
    new debugstr[4096];
    JSON_Stringify(JSONObject, debugstr);
    printf("[ShowCases] JSON Result: %s", debugstr);

    ShowPlayerGUI(playerid, CasesGUIFragment, JSONObject);
    printf("[ShowCases] GUI shown for player %d", playerid);
    
    return 1;
}

CMD:case(playerid, params[])
{
    printf("[CMD:case] Player %d used /case", playerid);
    return ShowCases(playerid);
}
stock SetVehicleTonerr(vehicleid, front, rear, front_side, back_side, setvalue=0)
{
    if(setvalue)
    {
        vInfo[vehicleid][vTonerFront]      = front;
        vInfo[vehicleid][vTonerRear]       = rear;
        vInfo[vehicleid][vTonerFrontSide]  = front_side;
        vInfo[vehicleid][vTonerRearSide]   = back_side;
    }

    new playerid;
    foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid))
            SetVehicleTonerForPlayer(playerid, vehicleid, front, rear, front_side, back_side);
    }
}

stock SetVehicleTonerForPlayer(playerid, vehicleid, front, rear, front_side, back_side)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 0); // тип тюна (тонер)

    BS_WriteValue(bitstream, PR_UINT32, front);
    BS_WriteValue(bitstream, PR_UINT32, rear);
    BS_WriteValue(bitstream, PR_UINT32, front_side);
    BS_WriteValue(bitstream, PR_UINT32, back_side);

    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}


CMD:toner(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid) return SendClientMessage(playerid, -1, !"Ou ia a iaoeia!");

    new front = 0xFF000000;
    new rear = 0xFF000000;
    new front_side = 0xFF000000;
    new rear_side = 0xFF000000;

    SetVehicleTonerr(vehicleid, front, rear, front_side, rear_side, 1);


    SendClientMessage(playerid, -1, !"Тонер установлен!");
    return 1;
}



stock SetVehicleFarLight(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 22);

	BS_WriteValue(bitstream, PR_UINT8, type);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}
stock SetVehicleHydraulics(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vHydraulics] = type;
	foreach(new playerid: Player) SetVehicleHydraulicsForPlayer(playerid, vehicleid, type);
}

stock SetVehicleHydraulicsForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 21);

	BS_WriteValue(bitstream, PR_UINT8, type);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

CMD:hydra(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Вы должны находиться в транспорте!");

    new vehicleid = GetPlayerVehicleID(playerid);

    // type 1
    SetVehicleHydraulics(vehicleid, 1, 1);

    SendClientMessage(playerid, -1, "Hydraulics (type: 1).");

    SendClientMessage(playerid, -1, "Гидравлика применина");

    return 1;
}

stock PlayAudioStreamURL(playerid, const url[])
{
    new BitStream:bs = BS_New();
    new len = strlen(url);

    printf("PlayAudioStreamURL: Player %d, URL length: %d, URL: %s", playerid, len, url);

    BS_WriteValue(bs, PR_INT32, 1);
    BS_WriteValue(bs, PR_UINT8, len);
    BS_WriteValue(bs, PR_STRING, url);
    BS_WriteValue(bs, PR_INT32, 0);
    BS_WriteValue(bs, PR_FLOAT, 1.0);
    BS_WriteValue(bs, PR_UINT8, 0);

    PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    printf("PlayAudioStreamURL: RPC sent for player %d", playerid);
}


CMD:test911(playerid, params[])
{
    PlayAudioStreamURL(playerid, "http://files.catbox.moe/lrgyv6.mp3");
    SendClientMessage(playerid, COLOR_WHITE, "test music");
    return 1;
}

// Сток для остановки аудио
stock StopAudioStream(playerid)
{
    new BitStream:bs = BS_New();

    printf("StopAudioStream: Attempting to stop audio for player %d", playerid);

    BS_WriteValue(bs, PR_INT32, 1);    // ID потока
    BS_WriteValue(bs, PR_UINT8, 0);    // Длина строки = 0
    BS_WriteValue(bs, PR_INT32, 0);    // Позиция
    BS_WriteValue(bs, PR_FLOAT, 0.0);  // Громкость 0
    BS_WriteValue(bs, PR_UINT8, 1);    // Флаг остановки

    PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    printf("StopAudioStream: RPC sent for player %d", playerid);
    BS_Delete(bs);
}

// Команда для игрока
CMD:stopaudio(playerid, params[])
{
    StopAudioStream(playerid);
    SendClientMessage(playerid, 0xFF0000FF, "Музыка остановлена!");
    return 1;
}

stock SetVehicleNumberPlateEx(vehicleid, type, number[], region[])
{
 if(!strlen(number) || !strcmp(number, "------", true))
 {
  vInfo[vehicleid][vNumber][Type] = 0;
  format(vInfo[vehicleid][vNumber][Number], 12, "");
  format(vInfo[vehicleid][vNumber][Region], 4, "");
  return;
 }

 new formatted_number[16];
 FormatPlateByTypeForDisplay(type, number, formatted_number, sizeof(formatted_number));

 if(!strlen(formatted_number))
 {
  return;
 }

 vInfo[vehicleid][vNumber][Type] = type;
 format(vInfo[vehicleid][vNumber][Number], 12, "%s", formatted_number);
 format(vInfo[vehicleid][vNumber][Region], 4, "%s", region);
 foreach(new playerid: Player)
 {
  SetVehicleNumberPlateForPlayer(playerid, vehicleid, type, formatted_number, region);
 }
}

stock SetVehicleNumberPlateForPlayer(playerid, vehicleid, type, number[], region[])
{
 if(!strlen(number) || !strcmp(number, "------", true))
 {
  return;
 }

 new BitStream:bitstream = BS_New();
 BS_WriteValue(bitstream, PR_UINT8, 7);

 BS_WriteValue(bitstream, PR_UINT16, vehicleid);

 BS_WriteValue(bitstream, PR_UINT8, type);

 BS_WriteValue(bitstream, PR_UINT8, strlen(number));
 BS_WriteValue(bitstream, PR_STRING, number);

 BS_WriteValue(bitstream, PR_UINT8, strlen(region));
 BS_WriteValue(bitstream, PR_STRING, region);

 PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
 BS_Delete(bitstream);
}

stock ClearVehicleNumberPlateForPlayer(playerid, vehicleid)
{
 new BitStream:bitstream = BS_New();
 BS_WriteValue(bitstream, PR_UINT8, 7);

 BS_WriteValue(bitstream, PR_UINT16, vehicleid);

 BS_WriteValue(bitstream, PR_UINT8, 0);

 BS_WriteValue(bitstream, PR_UINT8, 0);
 BS_WriteValue(bitstream, PR_STRING, "");

 BS_WriteValue(bitstream, PR_UINT8, 0);
 BS_WriteValue(bitstream, PR_STRING, "");

 PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
 BS_Delete(bitstream);
}

stock ClearVehicleNumberPlate(vehicleid)
{
 vInfo[vehicleid][vNumber][Type] = 0;
 format(vInfo[vehicleid][vNumber][Number], 12, "");
 format(vInfo[vehicleid][vNumber][Region], 4, "");

 foreach(new playerid: Player)
 {
  ClearVehicleNumberPlateForPlayer(playerid, vehicleid);
 }
}
CMD:plate(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Vehicle!");

    new vehicleid = GetPlayerVehicleID(playerid);

 SetVehicleNumberPlateEx(vehicleid, 1, "ADSE", "95");
}

