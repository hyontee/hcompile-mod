#define ClearAnimationsFix(%0) ApplyAnimation(%0,"CARRY","null",1.0,0,0,0,0,0,0),SetTimerEx("ClearAnim", 400, 0, "d", %0)


#define MAX_PLAYER_BUSINESS		3

enum E_PLAYER_INFO
{
    pID,
	pName[32],
	pKey[40], 
	pInGameDay,
	pInGameAllTime,
	pLastData,
	pInGameMember,
	pInGame,//Временная
	pLogin,//Временная
	pEmail[32],
	pLevel,
	p_Transfer,
	pAdmin,
	pYoutuber, 
	pMestoJail,
	RegIP[16],//РЕГИСТР ИП
	LastIP[16],//pvIp // Последний коннект 
	SuperIP[16],//Если игрок, был отключен за ввод неверного пароля, аунтификатора, кода проверки(Мы сохраняем Адрес) 
	pVK_ID[32],//Legendassd
	pConfirmVK, 
	pTG_ID[32],
	pConfirmTG,
	MailConfirm,//
	Float: PlayerHealth,//ХП сохраняем 
	pKeys,
	Float: pRating,
	Float: Satiety,
	FullSatiety, 
	DataReg, 
	pMats,
	pSex,
	pArrested,
	pMuted,
	rMuted,
	FractionMute,
	FractionWarn,
	pCrimes,
	pExp,
	pCash,
	pWantedDeaths,
	pPayCheck,
	pJailTime,
	pDrugs,
	pLDrugs,
	pLeader,
	pMember,
	pRank,
	pFamily,
	pFamilyRank,
	pFamilyMute,
	pFamilyWarn,
	BoostRank,
	BoostTime,
	VIPRank,
	VIPTime,
	PlayerSettings,//Настройки
	pJob,
	pModel,
	PlayerNumber, 
	pDirectory,
	PlayerSpawn,
	
	pLicense[6],// [0] - pCarLic | [1] - pFlyLic | [2] - pBoatLic | [3] - pFishLic | [4] - pGunLic | [5] - pBizLic
	pLicenseTime[6],
	PhoneBook[8], 
	pChar[11],
	pGunSkill[6],
	pRecordArena[6],
	pZakonp,
	pAddiction,
	pNarcoLomka,
	pWarns,
	punWarns,
	pFuel,
	pMarriedTo[32],
	Referal[32],
	pMushrooms,
	Float: pFishes,
	pFishesPach,
	pFishesTrade,
	pFishesWorms,
	pFishesTicle, 
	pBank, 
	pDonate,
	pFreeDonate,
	pNoDonate,
	pDepInTime,
	pDepPutTime,
	pDepCashBack,
	pDeposit,
	pMobile,
	pDolg,
	pKrisha,
	pUseKrisha,
	pWantedLevel,
	pTaxiExp,
	pTaxiLevel, 
	pBoxstyle,
	pKstyle,
	pKickstyle,
	pBoxSkill,
	pKongfuSkill,
	pKickboxSkill,
	pDLevel,
	pDExp,
	pDMgruz, 
	pSkilla,
	pLighter,
	pCigarettes,
	pRecognition,
	pRobHouse,
    pDrivingSkill, 
	JobDriverProdInfo[3], // | [0]//Уровень |  [1]//Опыт | [2]Максимальный груз 
	pHeadValue,
	KillContract,
	ZakazText[64],
	sAptechka,
	sTool,
 	gStars, 
	pVotingID,
 	PromoCode, 
	//PromoCodeOwner,
 	pDailyReward,
 	pRewardDate[32],
 	pRewardRegDate[32], 
	pFracIntBlock[FRACTION_COUNT],
	pFracIntKeys[FRACTION_COUNT],
	pBoombox[3],
    pHouseID,
	pBusinessID[3], 
	PlayerItems[MAX_ITEMS_SLOTS],
	PlayerItemsCount[MAX_ITEMS_SLOTS],
	PlayerUseItems[20], 
	edited_ads,
    pCaptureKills,
	pCharity,
	pTheftQuest,
	pTheftLevel,
	pTheftExp,
	pRentHouse, 
	pCasinoChips,
	pPokerChips,
	pPokerTutorialKey,
	pPokerTutorialStep,
	pPokerTableID,
	pPokerLanguage,
	pCasinoLanguage,
	pPokerOptions,
	pPokerActiveHand,
	pPokerActionActive,
	pPokerStatus_STR[32],
	pPokerResult_STR[32],
	pPokerCard[2],
	pPokerStatus,
	pPokerRaised,
	pPokerRaisedTime,
	pPokerBet,
	pPokerActiveID,
	pPokerTime,
	pPokerDealer,
	pPokerSeatID,
	pPokerHandRanking,
	Float:pPokerPos[3],
	pPokerWinner,
	pPokerHide,
	pPokerResult[2],
	pPokerGUI,
	pPokerDealerIcon,
	pHospital,
	pReportTimer,
	tAdvertTimer,
	tPostCardTimer,
	BusinessJob,
	BusinessRank,
	BusinessAllCash,
	BusinessCash,
	pRent[2],
	pPame[200],
	pEuro,
	pSpins
}
new pInfo[MAX_PLAYERS][E_PLAYER_INFO];




new defaultPlayerInfo[E_PLAYER_INFO] = {
    0,//pID,
	"0",//pName[32],
	"0",//pKey[40], 
	0,//pInGameDay,
	0,//pInGameAllTime,
	0,//pLastData,
	0,//pInGameMember,
	0,//pInGame,//Временная
	0,//pLogin,//Временная
	"none",//pEmail[32],
	1,//pLevel,
	0,//p_Transfer
	0,//pAdmin,
	0,//pYoutuber, 
	0,//pMestoJail,
	"0.0.0.0",//RegIP[16],//РЕГИСТР ИП
	"0.0.0.0",//LastIP[16],//pvIp // Последний коннект
	"0.0.0.0",//SuperIP[16],//Если игрок, был отключен за ввод неверного пароля, аунтификатора, кода проверки(Мы сохраняем Адрес),
	"None",//pVK_ID[32],
	0,//pConfirmVK, 
	"None",//pTG_ID[32],
	0,//ConfirmTG,
	0,//MailConfirm,// 
	100.0,//Float: PlayerHealth,//ХП сохраняем 
	0,//pKeys,
	0.00,//Float: pRating,
	1000.0,//Float: Satiety,
	0,//FullSatiety, 
	0,//DataReg, 
	0,//pMats,
	0,//pSex,
	0,//pArrested,
	0,//pMuted,
	0,//rMuted,
	0,//FractionMute,
	0,//FractionWarn,
	0,//pCrimes,
	0,//pExp,
	0,//pCash,
	0,//pWantedDeaths,
	0,//pPayCheck,
	0,//pJailTime,
	0,//pDrugs,
	0,//pLDrugs
	0,//pLeader,
	0,//pMember,
	0,//pRank,
	0,//pFamily,
	0,//pFamilyRank,
	0,//pFamilyMute,
	0,//pFamilyWarn,
	0,//BoostRank,
	0,//BoostTime,
	0,//VIPRank,
	0,//VIPTime,
	31,//PlayerSettings,//Настройки
	0,//pJob,
	255,//pModel,
	0,//PlayerNumber, 
	0,//pDirectory,
	0,//PlayerSpawn,
	{0,0,0,0,0,0},//pLicense[6],// [0] - pCarLic | [1] - pFlyLic | [2] - pBoatLic | [3] - pFishLic | [4] - pGunLic | [5] - pBizLic
	{0,0,0,0,0,0},//pLicenseTime[6]
	{0,0,0,0,0,0,0,0},//PhoneBook[8],
	{0,0,0,0,0,0,0,0,0,0,0},//pChar[6],
	{0,0,0,0,0,0},//pGunSkill[6],
	{0,0,0,0,0,0},// pRecordArena[6],
	0,//pZakonp,
	0,//pAddiction,
	0,//pNarcoLomka,
	0,//pWarns,
	0,//punWarns,
	0,//pFuel,
	"-",//pMarriedTo[32],
	"-",//Referal[32],
	0,//pMushrooms,
	0.0,//Float: pFishes,
	0,//pFishesPach,
	0,//pFishesTrade,
	0,//pFishesWorms,
	0,//pFishesTicle,,
	0,//pBank, 
	0,//pDonate,
	0,//pFreeDonate,
	0,//pNoDonate,
	0,//pDepInTime,
	0,//pDepPutTime,
	0,//pDepCashBack,
	0,//pDeposit,
	0,//pMobile,
	0,//pDolg,
	0,//pKrisha,
	0,//pUseKrisha,
	0,//pWantedLevel,
	0,//pTaxiExp,
	1,//pTaxiLevel,,
	0,//pBoxstyle,
	0,//pKstyle,
	0,//pKickstyle,
	0,//pBoxSkill,
	0,//pKongfuSkill,
	0,//pKickboxSkill,
	0,//pDLevel,
	0,//pDExp,
	8,//pDMgruz, 
	0,//pSkilla,
	0,//pLighter,
	0,//pCigarettes,
	0,//pRecognition,
	0,//pRobHouse,
    0,//pDrivingSkill,,
	{1, 0, 1000},//JobDriverProdInfo[3], // | [0]//Уровень |  [1]//Опыт | [2]Максимальный груз,
	0,//pHeadValue,
	0,//KillContract,
	"-",//ZakazText[64],
	0,//sAptechka,
	0,//sTool,
 	0,//gStars, 
	0,//pVotingID,
 	0,//PromoCode, 
	//0,//PromoCodeOwner,
 	0,//pDailyReward,
 	"-",//pRewardDate[32],
 	"-",//pRewardRegDate[32], 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},//pFracIntBlock[FRACTION_COUNT],
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},//pFracIntKeys[FRACTION_COUNT],
	{0, 0, 0},//pBoombox[3],
    -1,// pHouseID
	{0, 0, 0},//pBusinessID[3], 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},//PlayerItems[MAX_ITEMS_SLOTS],
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},//PlayerItemsCount[MAX_ITEMS_SLOTS],
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},//PlayerUseItems[20], 
	0,//edited_ads,
    0,//pCaptureKills
	0,//pCharity,
	0,//pTheftQuest,
	1,//pTheftLevel,
	0,//pTheftExp,
	-1,//pRentHouse,  
	0,//pCasinoChips,
	0,//pPokerChips, 
	0,//pPokerTutorialKey,
	0,//pPokerTutorialStep,
	0,//pPokerTableID,
	1,//pPokerLanguage,
	0,//pCasinoLanguage,
	0,//pPokerOptions,
	0,//pPokerActiveHand,
	0,//pPokerActionActive,
	"-",//pPokerStatus_STR[32],
	"-",//pPokerResult_STR[32],
	{0, 0},//pPokerCard[2],
	0,//pPokerStatus,
	0,//pPokerRaised,
	0,//pPokerRaisedTime,
	0,//pPokerBet,
	0,//pPokerActiveID,
	0,//pPokerTime,
	0,//pPokerDealer,
	0,//pPokerSeatID,
	0,//pPokerHandRanking,
	{0.0, 0.0, 0.0},//Float:pPokerPos[3],
	0,//pPokerWinner,
	0,//pPokerHide,
	{0, 0},//pPokerResult[2], ?
	0,//pPokerGUI,
	0,//pPokerDealerIcon,
	0,//pHospital,
	0,//pReportTimer,,
	0,//tAdvertTimer
	0,//tPostCardTimer
	0, //BusinessJob,
	0, //BusinessRank,
	0, //BusinessAllCash,
	0, //BusinessCash,
	0, // rent
	0,
	0,
	0,
};

// Player Temp
enum E_PLAYER_TEMP
{
	tPlayerCurrentID,
	tPlayerUpdate,
	tPlayerGiveStars,
	tPlayerReg,
    tSatietyUpdate,
	StringName[MAX_PLAYER_NAME + 1],
	bool: tSelectSkin,
	acWeaponTick, 
	tTimeLogin,
	PlayerTimeDrugsCD,
	PlayerTimeRobsCD,
	gContract,
	bool: tJobHunter,
	bool: tJobFactory, 
	tUseDeerKnifeID, 
	tUseFactorySordID,
	bool: PlayerADostup,
	//bool: PlayerSDuty,
	bool: PlayerTied,
	bool: UseSound,
	PlayerTreningBox,
	CheckpointPressed,
	bool: TakingLesson,
	bool: TestAutoShcool,
	AntiFloodText,
	AntiFloodWarning,
	tSelectVehicleShop,
	TempSalonCar,
	LoadShowCar,  
	PlayerIsSmoking, 
	bool: PlayerPhoneOnline,
	bool: tGruzJob,
	tSalaryJob[2],
	bool: tPlayerUseItemJob,
	bool: PlayerSpray,
	bool: PlayerKeyNews,
	bool: PlayerUseBreak,
	bool: InGreenZonePlayer,
	bool: PlayerInArmyForm,
	FBISpyAction, 
	SelectBuyInt,
	bool: CallInNews,
	bool: PlayerEfir,  
	bool: GetHomePlayer, 
	bool: GetFarmPlayer, 
	PlayerFarmID,
	TempFermID,
	JobInFarmRank,
	bool: specUpdate,
	FloodCommandTick,
	TempGunSkill[6],
	TempUseHealth,
	PlayerAFK,
	bool: PlayerUseAdminGM, 
	PlayerVehicle,
	Float: tPos[3],
 	tDutyWork,
 	ac_card,
	TimeNoAFK,
	gTimeNoAFK, // выдача рулктки 
	tVirtualWorld,
	tInterior,
	tSelectPage,
	tSelectRows,
	tPlayerTrailerHome, 
	Text3D: Mechanic3DText,
	Text3D: FamilyText, 
	pEditSuspectID,
	pEditSuspectReason[32],
	pEditSuspectLevel,
	pEditSuspectTargetID, 
	tMayorEconomyID,
	tMayorEconomyOwner[MAX_PLAYER_NAME],
	tMayorEconomyReason[32],
	tMayorEconomyMoney,
	tMayorEconomyFrac, 
	bool: StartAddiction,
	tTimeAddiction,
	tVehicleKey, 
	id_arended_truck, 
	pSpikeArea,
	Text3D:pSpikeText,
	Text3D:tBlockText, 
	Float:tBoomboxRange,
	tBoomboxURL[128],
	tBoomboxArea,
	Float:tBoomboxPos[3],
	tBoomboxObject,
	Text3D:tBoomboxText, 
	tStallID, 
	tBusinessOrderID,
	tBusinessOrderProducts, 
	tBusinessID,
	tFillBusinessID,
	tActorBusinessID, 
	tCurrentBusinessID,
	bool:tGasMenuShowed,
	Float:tGasMenuProgress,  
	tCustomsObjectID[7], 
	tBusinessShowBizTargetID,//
	tBusinessTempTargetID,	// (Для продавца) ИД покупателя
	tBusinessSellID,		// (Для продавца) ИД бизнеса
	tBusinessBuyerTargetID,	// (Для продавца) ИД покупателя
	tBusinessSellerTargetID,// (Для покупателя) ИД продавца
	tBusinessSellPrice,		// (Для продавца-покупателя) цена  
	tAccesoryBuyMenuShowed,
	tAccesoryBuyPage,
	tAccesoryBuySelectID,
	tAccesoryBuyType,   
	status_offer_type,// Предложения YN
	status_offer_confirm, // Предложения YN
	pTaxiRating, // через сколько может выдать рейтинг таксисту
	pTaxiDriver,
	pTaxiCalled[3],
	pRentCar,
	bool: tQuestTheft,
	tTheftSkladID,
	tTheftIDCar,
	tTheftTime,
	tTheftGZ,
	tTempVeh,
	tVehicleRC,
	tRobVeh,
	tDMArea[5], // 0 - Start / 1 Kills / 2 Deaths / 3 Type Map / 4 Type Gun = 1 Random
	tSeriasKilled,
	Text3D: tDMLabel,
	tRaceCP,
	tRaceID,
	tRaceMoney,
	tArmyDuty,
	tArmyJob,
	tArmyHospitalJob,
	tTimeInHour,
    tCurrentHouseID,
    tSelectHouseID,
    bool: tSelectHouseArea,
	tSelectFamilyHouse,
	bool: tFamilyHouseMenuShowed,
	bool: tSelectFamilyHouseArea,
	bool: tSelectAreaATM,
	tSelectATMID,
	bool: tSelectAreaStall,
	tSelectStallID,
	tRentStallID,  
	tCasinoChipsPTD,
	tCasinoRouletteTable,
	tCasinoRouletteBet,
	tCasinoRouletteChips,
	tCasinoRouletteChipsPos,
	tCasinoRouletteChipsObject,
	tDeathReason,
	tHospitalBed,
	TypeCheckpoint,
	tReportID, 
	bool: tAdminInfo,
	bool: tAdminInfoReport,
	pSLimit,
	bool: tRobItems,
	bool: tSpectate,

	tPaintKills,
	tPaintDeath,
	Float: tPaintDMG,
	tPaintTeam,

	bool:tTakeCashATM,
	tActionStep,
	tActionType,
	tActionKey,
	tRacePosition,
	bool: tRacePlayer,
	tRaceVehicleID,
	tPlayerTargetID,
	tTakeDrugsType,
	tTakeEmptyBikers,
	tSelectDealerID,
    bool: tSelectDealerArea, 
	tAntiCrack,
	bool: tDrugsRun,
	tJobTimer,
	tFactoryUseBox,
	tTruckerTrailerBuy,
	tTruckerLoadTime,
	tTruckerLeaveTime,
	tPlayerGTC,
	tPlayerUseReport,
	tJobHotDogSaller,
	tPlayerConractBizzHD,
	tPlayerStartRob,
	tRadioHost,
	tDiceTable,
	tAddBlackName[MAX_PLAYER_NAME + 1],
	tAddBlackReason[32],
	tSelectSkinShop,
	bool: tFreezePlayer,
	tPlayerCuffed,
	bool: tEventPaticipant,
	tCURRENT_DIALOG,
	tLAST_DIALOG,
	tMopedGarage,
	tIgnorePick,
	tempquest,
	bool: isquest,
	tWelcomeTimer,
} 
new pTemp[MAX_PLAYERS][E_PLAYER_TEMP];

/*
stock GetPlayerTempData(playerid, E_PLAYER_TEMP: type) { 
	return pTemp[playerid][type];
}*/

new defaultPlayerTemp[E_PLAYER_TEMP] = {
	0, //tPlayerCurrentID
	0,//tPlayerUpdate,
	0,//tPlayerGiveStars
	0,//tPlayerReg,
    0,//tSatietyUpdate
	"-",//StringName[MAX_PLAYER_NAME + 1],
	false,//bool: tSelectSkin,
	2000,//acWeaponTick, 
	90,//tTimeLogin,
	0,//PlayerTimeDrugsCD,
	-1,//PlayerTimeRobsCD,
	INVALID_PLAYER_ID,//gContract,
	false, //bool: tJobHunter 
	false, //bool: tJobFactory, 
	-1, //tUseDeerKnifeID, 
	-1, //tUseFactorySordID
	false,//bool: PlayerADostup,
	//false,//bool: PlayerSDuty,
	false,//bool: PlayerTied,
	false,//bool: UseSound,
	0,//PlayerTreningBox,
	0,//CheckpointPressed,
	false,//bool: TakingLesson,
	false,//bool: TestAutoShcool,
	0,//AntiFloodText,
	0,//AntiFloodWarning
	-1, //tSelectVehicleShop,
	INVALID_VEHICLE_ID,//TempSalonCar,
	0,//LoadShowCar,  
	0,//PlayerIsSmoking, 
	false,//bool: PlayerPhoneOnline,
	false,//bool: tGruzJob,
	{0, 0},//tSalaryJob[2], 0 - Osnova, 1 - Dop
	false,//bool: tPlayerUseItemJob,
	false,//bool: PlayerSpray,
	false,//bool: PlayerKeyNews,
	false,//bool: PlayerUseBreak,
	false,//bool: InGreenZonePlayer,
	false,//bool: PlayerInArmyForm,
	-1,//FBISpyAction, 
	-1,//SelectBuyInt,
	false,//bool: CallInNews,
	false,//bool: PlayerEfir,  
	false,//bool: GetHomePlayer, 
	false,//bool: GetFarmPlayer, 
	-1, //PlayerFarmID,
	-1,//TempFermID,
	0,//JobInFarmRank,
	false,//bool: specUpdate,
	0,//FloodCommandTick,
	{0, 0, 0, 0, 0, 0},//TempGunSkill[6],
	0,//TempUseHealth,
	-2,//-2,//PlayerAFK,
	false,//bool: PlayerUseAdminGM, 
	INVALID_VEHICLE_ID,//PlayerVehicle,
	{0.0, 0.0, 0.0},//Float: tPos[3],
 	0,//tDutyWork,
 	0,//ac_card,
	0,//TimeNoAFK,
	0,//gTimeNoAFK, // выдача рулктки 
	0,//tVirtualWorld,
	0,//tInterior,
	0,//tSelectPage,
	-1,//tSelectRows,
	0,//tPlayerTrailerHome, 
	Text3D:-1,//Text3D: Mechanic3DText,
	Text3D:-1,//Text3D: FamilyText, 
	0,//pEditSuspectID,
	"-", //pEditSuspectReason[32],
	0,//pEditSuspectLevel,
	INVALID_PLAYER_ID,//pEditSuspectTargetID, 
	0,//tMayorEconomyID,
	"",//tMayorEconomyOwner[MAX_PLAYER_NAME],
	"",//tMayorEconomyReason[32],
	0,//tMayorEconomyMoney,
	0,//tMayorEconomyFrac, 
	false,//bool: StartAddiction,
	0, //tTimeAddiction,
	0,//tVehicleKey, 
	INVALID_VEHICLE_ID,//id_arended_truck, 
	0,//pSpikeArea,
	Text3D:0,//Text3D:pSpikeText, 
	Text3D:0,//Text3D:tBlockText,
	0.0,//Float:tBoomboxRange,
	"-",//tBoomboxURL[128],
	0,//tBoomboxArea,
	{0.0, 0.0, 0.0},//Float:tBoomboxPos[3],
	0,//tBoomboxObject,
	Text3D:0,//Text3D:tBoomboxText, 
	0,//tStallID, 
	0,//tBusinessOrderID,
	0,//tBusinessOrderProducts, 
	0,//tBusinessID,
	-1,//tFillBusinessID,
	0,//tActorBusinessID, 
	0,//-1,//tCurrentBusinessID,
	false,//bool:tGasMenuShowed,
	0.0,//Float:tGasMenuProgress,  
	{0, 0, 0, 0, 0, 0, 0},//tCustomsObjectID[7], 
	INVALID_PLAYER_ID, //tBusinessShowBizTargetID
	INVALID_PLAYER_ID,//tBusinessTempTargetID,	// (Для продавца) ИД покупателя
	0,//tBusinessSellID,		// (Для продавца) ИД бизнеса
	INVALID_PLAYER_ID,//tBusinessBuyerTargetID,	// (Для продавца) ИД покупателя
	INVALID_PLAYER_ID,//tBusinessSellerTargetID,// (Для покупателя) ИД продавца
	0,//tBusinessSellPrice,		// (Для продавца-покупателя) цена 
	false, //tAccesoryBuyMenuShowed,
	0,//tAccesoryBuyPage,
	-1,//tAccesoryBuySelectID,
	1,//tAccesoryBuyType,  
	0,//status_offer_type,
	0,//status_offer_confirm, 
	0,//pTaxiRating, // через сколько может выдать рейтинг таксисту
	INVALID_PLAYER_ID,//pTaxiDriver,
	{INVALID_PLAYER_ID,INVALID_PLAYER_ID,INVALID_PLAYER_ID},//pTaxiCalled[3],
	INVALID_VEHICLE_ID,//pRentCar,
	false,//bool: tQuestTheft,
	-1, //tTheftSkladID,
	INVALID_VEHICLE_ID,//tTheftIDCar,
	0,//tTheftTime,
	INVALID_GANGZONE_ID,//tTheftGZ,
	INVALID_VEHICLE_ID,//tTempVeh,
	INVALID_VEHICLE_ID,//tVehicleRC,
	INVALID_VEHICLE_ID,//tRobVeh,
	{0, 0, 0, 0, 0},//tDMArea[5], // 0 - Start / 1 Kills / 2 Deaths / 3 Type Map / 4 Type Gun = 1 Random
	0,//tSeriasKilled
	Text3D:0,//Text3D: tDMLabel,
	0,//tRaceCP,
	INVALID_VEHICLE_ID,//tRaceID,
	0,//tRaceMoney,
	0,//tArmyDuty,
	0,//tArmyJob,
	0,//tArmyHospitalJob,
	0,//tTimeInHour,
    -1, //tCurrentHouseID
    -1, //tSelectHouseID
    false,//bool: tSelectHouseArea,
	-1,//tSelectFamilyHouse,
	false,//bool: tFamilyHouseMenuShowed,
	false,//bool: tSelectFamilyHouseArea,
	false,//bool: tSelectAreaATM,
	-1,//tSelectATMID,
	false,//bool: tSelectAreaStall,
	-1,//tSelectStallID,
	-1,//tRentStallID,  
	0,//tCasinoChipsPTD,
	0,//tCasinoRouletteTable,
	0,//tCasinoRouletteBet,
	0,//tCasinoRouletteChips,
	0,//tCasinoRouletteChipsPos,
	-1,//tCasinoRouletteChipsObject, 
	0,//tDeathReason,
	-1,//tHospitalBed,
	0,//TypeCheckpoint,
	INVALID_PLAYER_ID,//tReportID, 
	false,//tAdminInfo
	false,//tAdminInfoReport
	0,//pSLimit
	false,//tRobItems
	false,//tSpectate
	0,//tPaintKills,
	0,//tPaintDeath,
	0.0,//Float: tPaintDMG
	0, //tPaintTeam
	false,//bool:tTakeCashATM, 
	0,//tActionStep,
	ACTION_NONE,//tActionType,
	0,//tActionKey
	0,//tRacePosition,
	false,//bool: tRacePlayer
	INVALID_VEHICLE_ID,//tRaceVehicleID
	INVALID_PLAYER_ID,//tPlayerTargetID
	0,//tTakeDrugsType
	0,//tTakeEmptyBikers
	-1,//tSelectDealerID,
    false,//bool: tSelectDealerArea, 
	0,//tAntiCrack
	false,//tDrugsRun
	-1, //tJobTimer
	false,//tFactoryUseBox
	INVALID_VEHICLE_ID,//tTruckerTrailerBuy
	-1,//tTruckerLoadTime
	-1,//tTruckerLeaveTime
	0,//tPlayerGTC
	0,//tPlayerUseReport 
	false,//tJobHotDogSaller
	-1,//, tPlayerConractBizzHD
	0, // tPlayerStartRob
	0, // tRadioHost ведущий радио
	-1, // tDiceTable
	"None",//tAddBlackName
	"None",//tAddBlackReason
	-1,//tSelectSkinShop
	false, //tFreezePlayer
	0,//tPlayerCuffed
	false,//bool: tEventPaticipant
	INVALID_DIALOG_ID, 			// tCURRENT_DIALOG
	INVALID_DIALOG_ID, 			// tLAST_DIALOG
	INVALID_VEHICLE_ID,			// tMopedGarage
	0,//tIgnorePick
	0,
};
stock GetPlayerCuffedAC(playerid) {
	return pTemp[playerid][tPlayerCuffed];
}
/*stock GetPlayerTempInfo(playerid, E_PLAYER_TEMP:type) {
	return pTemp[playerid][tPlayerCuffed];
}*/
enum E_PLAYER_CALL
{
	Float: callx,
	Float: cally,
	Float: callz,
	bool: callused,
};
new CallInfo[MAX_PLAYERS][E_PLAYER_CALL];


new defaultCallInfo[E_PLAYER_CALL] = {
	0.0, //Float: callx,
	0.0, //Float: cally,
	0.0, //Float: callz,
	false //bool: callused,
};

enum E_CHRISTMAS_PLAYER {
	cGift,
	cPoll,
	cBlockGift,
	aCirtificationHome
}
new ChristmasInfo[MAX_PLAYERS][E_CHRISTMAS_PLAYER];

new defaultChristmasInfo[E_CHRISTMAS_PLAYER] = {
	0, //cGift,
	0, //cPoll,
	0, //cBlockGift,
	0 //aCirtificationHome
};

enum E_FOLLOW_PLAYER {
	gtID,
	gtGoID,
	Float:gtX,
	Float:gtY,
	Float:gtZ,
	Float:gtTPX,
	Float:gtTPY,
	Float:gtTPZ,
	gtState,
	gtStayed
}
new gFollowInfo[MAX_PLAYERS][E_FOLLOW_PLAYER];

new defaultFollowInfo[E_FOLLOW_PLAYER] = {
	INVALID_PLAYER_ID,//gtID,
	INVALID_PLAYER_ID,//gtGoID,
	0.0,//Float:gtX,
	0.0,//Float:gtY,
	0.0,//Float:gtZ,
	0.0,//Float:gtTPX,
	0.0,//Float:gtTPY,
	0.0,//Float:gtTPZ,
	0,//gtState,
	0//gtStayed
};


enum PLAYER_TRANSFER {
	//tName[32],
	tID_Users,
	tLevel,//pLevel
	tEXP,//pExp
	tVIP,//vip_rank
	tBoost,//boost_rank
	tNumber,//pPnumber
	tCash,//pCash
	tBank,//pBank
	tDonate,//u_donate
	tDeposit,//
	tMember, //pMember
	tRank,//pRank
	tModel, // pModel
	tMaterials,//pMats
	tDrugs,//pDrugs
	tChar[6],//pChars 
	tGunSkills[6],
	tPlayerItems[MAX_ITEMS_SLOTS],
	tPlayerItemsCount[MAX_ITEMS_SLOTS]
}
new pTransfer[MAX_PLAYERS][PLAYER_TRANSFER];
//pTransfer[playerid] = defaultTransferInfo;
new defaultTransferInfo[PLAYER_TRANSFER] = {
	//"0",//tName
	-1, //tID_Users
	1,//tLevel,//pLevel
	0,//tEXP,//pExp
	0,//tVIP,//vip_rank
	0,//tBoost,//boost_rank
	0,//tNumber,//pPnumber
	0,//tCash,//pCash
	0,//tBank,//pBank
	0,//u_donate
	0,//tDeposit,//
	0,//tMember, //pMember
	0,//tRank,//pRank
	0,//tModel, // pModel
	0,//tMaterials,//pMats
	0,//tDrugs,//pDrugs
	{0, 0, 0, 0, 0, 0},//tChar[6]//pChars 
	{0, 0, 0, 0, 0, 0},//tSkills
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},//PlayerItems[MAX_ITEMS_SLOTS],
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}//PlayerItemsCount[MAX_ITEMS_SLOTS],
};