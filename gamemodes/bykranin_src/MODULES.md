# Карта модулей bykranin

Порядок `#include` в `gamemodes/bykranin.pwn` **важен** (это тот же порядок, что был в исходном файле).
Папки `core/*` — код из «монолита», разложенный по темам автоматически (эвристика по именам функций).
Папка `systems/` — модули, которые уже были вставлены в исходник маркерами `BEGIN INLINED`; восстановлены как отдельные файлы.

Всего файлов: 191

## GUIDE.md  (1 ф., 39 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `GUIDE.md` | 39 |  |

## INDEX_CALLBACKS.md  (1 ф., 303 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `INDEX_CALLBACKS.md` | 303 |  |

## INDEX_COMMANDS.md  (1 ф., 616 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `INDEX_COMMANDS.md` | 616 |  |

## core/account  (5 ф., 1751 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/account/account_01.inc` | 63 | `CheckPlayerAccount`, `FixedKick` |
| `core/account/account_02.inc` | 229 | `ShowPlayerPinCodePTD`, `HidePlayerPinCodePTD`, `ShowCurrentTime`, `GetDayOfWeek`, `UpdateCharity`, `Dialog` |
| `core/account/account_03.inc` | 448 | `/no`, `/cancel`, `/hi`, `/me`, `/do`, `/try` |
| `core/account/account_04.inc` | 487 | `/templeader`, `/agivelic`, `/setskills`, `/tdd`, `/setadm`, `/deladmin` |
| `core/account/load_player_data.inc` | 524 | `LoadPlayerData` |

## core/admin  (7 ф., 3429 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/admin/admin_01.inc` | 885 | `GetSkillBar`, `ShowPlayerSkills`, `GetPlayerSkillAmount`, `SetPlayerSkillAmount`, `ShowTeleportList`, `CreateTicket` |
| `core/admin/admin_02.inc` | 297 | `TeleportFreeze`, `TeleportUnfreeze`, `PlacePlayerInJail`, `JailPlayer`, `UnjailPlayer`, `UpdatePlayerDatabaseInt` |
| `core/admin/admin_03.inc` | 339 | `/kick`, `/skick`, `/mute`, `/unmute`, `/jail`, `/unjail` |
| `core/admin/admin_04.inc` | 686 | `/medbed`, `/out`, `/heal`, `/changesex`, `/cuff`, `/uncuff` |
| `core/admin/admin_05.inc` | 336 | `ReportGUI_IsAdminAuthorized`, `ReportGUI_CountPending`, `ReportGUI_UpdateCounter`, `ReportGUI_ClearAdminState`, `ReportGUI_Enqueue`, `ReportGUI_RequeueActive` |
| `core/admin/admin_06.inc` | 284 | `GetNumberOfPaintjobsForVehicle`, `/report`, `sssreport`, `/rep`, `/freeze`, `/unfreeze` |
| `core/admin/admin_07.inc` | 602 | `StopVehicleStroboscope`, `/strob`, `function_strobocop`, `/notif`, `/base`, `/med` |

## core/callbacks  (20 ф., 34994 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/callbacks/callbacks_01.inc` | 1475 | `OnGameModeExit`, `OnPlayerRequestClass`, `OnPlayerRequestSpawn`, `jonny`, `ResetPlayerData`, `OnPlayerConnect` |
| `core/callbacks/callbacks_02.inc` | 207 | `OnPlayerExitVehicleEx`, `OnPlayerStateChange`, `OnVehicleDamageStatusUpdate` |
| `core/callbacks/callbacks_03.inc` | 294 | `OnPlayerLeaveCheckpoint`, `OnPlayerEnterRaceCheckpoint`, `OnPlayerLeaveRaceCheckpoint`, `OnRconCommand`, `OnObjectMoved`, `OnPlayerObjectMoved` |
| `core/callbacks/callbacks_04.inc` | 234 | `HidePlayerSelectPanelPriceTimer`, `OnVehicleMod`, `OnVehiclePaintjob`, `OnVehicleRespray`, `OnPlayerSelectedMenuRow`, `OnPlayerExitedMenu` |
| `core/callbacks/callbacks_05.inc` | 49 | `OnPlayerStreamIn`, `OnPlayerStreamOut`, `OnVehicleStreamIn`, `OnVehicleStreamOut` |
| `core/callbacks/callbacks_06.inc` | 379 | `OnPlayerClickPlayerTextDraw`, `OnPlayerEnterDynamicCP`, `CreateFactoryProd`, `OnPlayerLeaveDynamicCP`, `Funchion3` |
| `core/callbacks/callbacks_07.inc` | 740 | `SpeedBooster`, `OnSecondTimer`, `ParseBtStr`, `OnMinuteTimer`, `OnPlayersWorldTimeInit`, `OnLottery` |
| `core/callbacks/callbacks_08.inc` | 262 | `/veh`, `OnPlayerNotificationClick`, `/pos`, `/d`, `/dd`, `/r` |
| `core/callbacks/callbacks_09.inc` | 245 | `SendTurnSignalRPC`, `OnIncomingRPC` |
| `core/callbacks/on_dialog_response.inc` | 23904 | `OnDialogResponse` |
| `core/callbacks/on_game_mode_init.inc` | 528 | `OnGameModeInit` |
| `core/callbacks/on_player_click_text_draw.inc` | 1170 | `OnPlayerClickTextDraw` |
| `core/callbacks/on_player_enter_checkpoint.inc` | 414 | `OnPlayerEnterCheckpoint` |
| `core/callbacks/on_player_enter_dynamic_area.inc` | 571 | `OnPlayerEnterDynamicArea` |
| `core/callbacks/on_player_enter_vehicle_ex.inc` | 386 | `OnPlayerEnterVehicleEx` |
| `core/callbacks/on_player_key_state_change.inc` | 1174 | `OnPlayerKeyStateChange` |
| `core/callbacks/on_player_leave_dynamic_area.inc` | 492 | `OnPlayerLeaveDynamicArea` |
| `core/callbacks/on_player_pick_up_pickup_ex.inc` | 1541 | `OnPlayerPickUpPickupEx` |
| `core/callbacks/on_player_timer.inc` | 420 | `OnPlayerTimer` |
| `core/callbacks/on_player_update.inc` | 509 | `OnPlayerUpdate` |

## core/casino  (2 ф., 1128 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/casino/casino_01.inc` | 797 | `CreateMenus`, `CreateMedBeds`, `CreateCasinoTables`, `CreateBlackJackTables`, `CreateArmories`, `IsPlayerInRangeOfAnyBlackJackTable` |
| `core/casino/casino_02.inc` | 331 | `/dice`, `/ad`, `/edit`, `/t`, `/u`, `/givemic` |

## core/combat  (1 ф., 667 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/combat/combat_01.inc` | 667 | `SetPlayerHospitalSpawnInit`, `HospitalSetPlayerPosition`, `HospitalPrimeInterior`, `HospitalLoginSpawnGuard`, `HospitalSpawnSync`, `HospitalSpawnLateGuard` |

## core/data  (7 ф., 6360 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/data/case_award_names.inc` | 1924 | `CaseAwardNames` |
| `core/data/case_awards_num.inc` | 1897 | `CaseAwardsNum` |
| `core/data/data_01.inc` | 441 | `OnPlayerActivationKeyPress`, `OnPlayerActivationKeyRelease` |
| `core/data/data_02.inc` | 287 | `gHousesForSale`, `gFlatSalePickup`, `gHouseSalePickup`, `gHouseOwner`, `gHouseOwnerID`, `gHouseType` |
| `core/data/data_03.inc` | 532 | `GetCaseItemsCount`, `GetCaseItemNumeric`, `GetCaseItemName` |
| `core/data/g_flats_for_sale.inc` | 749 | `gFlatsForSale` |
| `core/data/g_sellcar_price_map.inc` | 530 | `g_sellcar_price_map` |

## core/decl  (9 ф., 13828 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/decl/enums_01.inc` | 1548 | `GetVehicleRGBAColorById`, `GetAngleToPoint`, `SendReport`, `DeleteReport`, `GetReportId`, `UpdateReportText` |
| `core/decl/enums_02.inc` | 1574 | `E_ITEM_STRUCT`, `E_ENTRANCE_STRUCT`, `E_HOTEL_STRUCT`, `E_HOTEL_CAR_PARK_STRUCT`, `E_HOUSE_STRUCT`, `E_HOUSE_TYPE_STRUCT` |
| `core/decl/funcs_01.inc` | 612 | `GetRemapName`, `GetVehicleCarMarketID`, `BuyCarTDsShowForPlayer`, `BuyCarTDsHideForPlayer`, `ShowConnectPanelAC`, `ShowWarningPanelAC` |
| `core/decl/globals_01.inc` | 817 | `ApplyServerBranding`, `BrandedShowPlayerDialog`, `BrandedSendClientMessage`, `BrandedSendClientMessageToAll`, `BrandedPlayerTextDrawSetString` |
| `core/decl/globals_02.inc` | 2680 | `ConvertMoney`, `EncodeSelectedHouseProperty`, `DecodeSelectedHouseProperty` |
| `core/decl/globals_03.inc` | 1512 | `FindAccsDataIndexByModel`, `ShowAcsDialog`, `CaseClientIdToLogical`, `CaseLogicalIdToClient`, `ResolveCaseDataIndex`, `InitPlayerCaseBonusStates` |
| `core/decl/globals_04.inc` | 2310 | `GetRentCarDataIndex` |
| `core/decl/globals_05.inc` | 1453 | `IsValidBusinessInteriorId` |
| `core/decl/globals_06.inc` | 1322 | `CreatePlayerTextDrawBeta`, `SavePlayerCaseBonusReward` |

## core/economy  (6 ф., 3668 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/economy/cmd_yes.inc` | 835 | `/yes` |
| `core/economy/economy_01.inc` | 303 | `ShowPlayerPayForRentDialog`, `ClearBankAccountInfo`, `ClearBankAccountsData`, `ShowPlayerBankDialog`, `ShowPlayerBankAccounts`, `IsValidBankAccount` |
| `core/economy/economy_02.inc` | 913 | `GivePlayerMoneyEx`, `GivePlayerDonate`, `GivePlayerDonateRub`, `BankLog`, `SendMessageInLocal`, `Action` |
| `core/economy/economy_03.inc` | 670 | `ProcessShop247Purchase`, `/buy`, `/healme`, `/present`, `/mask`, `/dis` |
| `core/economy/economy_04.inc` | 225 | `GetCarNumberPrice`, `/checknumber`, `/skill`, `/creategift`, `/donat`, `/donatee` |
| `core/economy/economy_05.inc` | 722 | `/reset_donate`, `/givevip`, `/epoints`, `/giveepoints`, `GivePlayerCar`, `ShowPlayerPromoActive` |

## core/family  (7 ф., 3609 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/family/family_01.inc` | 358 | `LoadGangZones`, `CreateZakazZakaz`, `ShowGangZonesForPlayer`, `LoadZakazTextz`, `LoadZakazTexta`, `LoadZakazTextk` |
| `core/family/family_02.inc` | 870 | `AnimListInit`, `RepositoriesLoad`, `RepositoriesInit`, `UpdateRepository`, `UpdateOilFactory`, `UpdateMinerRemelting` |
| `core/family/family_03.inc` | 440 | `/members`, `/leaders`, `/admlist`, `/admlist1` |
| `core/family/family_04.inc` | 523 | `/rn`, `/gnews`, `/invite`, `/uninvite`, `/rang`, `/changeskin` |
| `core/family/family_05.inc` | 461 | `/makegun`, `/close`, `/tie`, `/untie`, `/capture`, `StartCapture` |
| `core/family/family_06.inc` | 245 | `LoadFamily`, `GetFamilyRang`, `ShowPayFamilyDialog`, `ShowChangeRangDialog`, `ShowFamilyAllPlayers`, `ShowFamilyInfo` |
| `core/family/family_07.inc` | 712 | `ShowFamilyWarehouseMenu`, `/owarn`, `/ounwarn`, `/fwarn`, `/funwarn`, `/fmute` |

## core/inventory  (14 ф., 10372 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/inventory/block.inc` | 390 | `CreatePlTDButtonBR`, `CreateTextDrawButtonBR`, `EntryAccessoryMarket`, `SetPriceAccesory`, `/myacs`, `LoadAccessory` |
| `core/inventory/inventory_01.inc` | 355 | `GetTuneSelectorFromItem`, `GetTuneIdFromItem`, `GetWheelTuneComponentId`, `GetNitroComponentByLevel`, `ApplyOwnableVehicleNitro`, `ApplyOwnableVehicleColors` |
| `core/inventory/inventory_02.inc` | 309 | `DestroyOwnableCar`, `CreateAcs`, `DestroyFamilyCar`, `UpdateOwnableCarNumber`, `IsContainerRewardParkSlotBusy`, `GetContainerRewardParkPosition` |
| `core/inventory/inventory_03.inc` | 270 | `AddBan`, `GivePlayerDrinkItem`, `FactoryPlayerDrop`, `ShowPlayerClothingShopPanel`, `ExitPlayerClothingShopPanel`, `BuySkinPTDUpdate` |
| `core/inventory/inventory_04.inc` | 644 | `SellDebtorsHome`, `SellDebtorsBusiness`, `SellDebtorsFuel`, `/slethouse`, `/slet`, `CreateFractionCar` |
| `core/inventory/inventory_05.inc` | 230 | `ApplyAdminSkin`, `/askin`, `ShowFamilyy`, `/ndrive`, `/pdd`, `/setvinil` |
| `core/inventory/inventory_06.inc` | 302 | `/delacs`, `LoadSvetfor`, `SvetforsChangeColor`, `/mat`, `/rem`, `/remoff` |
| `core/inventory/inventory_07.inc` | 668 | `/autosalon`, `/addpcar`, `/givecar`, `tp_price`, `ShowPlayerSellCarDialog`, `/unsellmycar` |
| `core/inventory/inventory_08.inc` | 1666 | `/donate`, `donatess`, `RestorePlayerPromotions`, `Inv11Trade_ResetOfferSlot`, `Inv11Trade_ClearOffers`, `Inv11Trade_ResetInvite` |
| `core/inventory/inventory_09.inc` | 1551 | `Inventory11_FindFirstItemSlotById`, `Inv11_GetAccItemByModel`, `Inventory11_NormalizeLegacyAccessorySlots`, `Inventory11_GetActiveAccessories`, `Inventory11_GetFreeActiveAccessorySlot`, `Inventory11_BuildAiJson` |
| `core/inventory/inventory_10.inc` | 505 | `GetCaseBonusesCount`, `GetCaseBonusNumeric`, `GetCaseBonusName`, `explode`, `split`, `GetCaseBonusForIndex` |
| `core/inventory/inventory_11.inc` | 392 | `ShowNotificationNew`, `/notify`, `GetName`, `/123_test`, `ShowCases`, `/case` |
| `core/inventory/inventory_12.inc` | 2177 | `UpdateVehicleVisualForPlayer`, `SetVehicleColor`, `SetVehicleColorForPlayer`, `SetVehicleEnableSiren`, `SetVehicleEnableSirenForPlayer`, `SetVehicleSiren` |
| `core/inventory/inventory_13.inc` | 913 | `EscapeJsonSimple`, `/reward`, `rewardsss`, `AddPlayerCaseReward`, `FixPlayerZ`, `SavePlayerCaseRewardDB` |

## core/jobs  (6 ф., 2641 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/jobs/jobs_01.inc` | 233 | `GetJobNameSafe` |
| `core/jobs/jobs_02.inc` | 798 | `ShowPlayerLoginDialog`, `ClearPlayerAnim`, `ClearPlayerChatAnim`, `SetPlayerLoaderJobLoad`, `Mine_ClearCarry`, `SetPlayerMinerJobTakeOre` |
| `core/jobs/jobs_03.inc` | 428 | `ChangePlayerName`, `EndPlayerTempJob`, `TogglePlayerFactoryCP`, `KillEndJobTimer`, `StartEndJobTimer`, `ShowPlayerBuyMetalDialog` |
| `core/jobs/jobs_04.inc` | 381 | `MapIconsInit`, `TeleportPickupsInit`, `DrivingSchoolInit`, `ShowPlayerATMDialog`, `ShowPlayerATMSelectSumDialog`, `ShowPlayerATMSelectOtherSum` |
| `core/jobs/jobs_05.inc` | 374 | `CreateQuestPickup`, `GromovLohAndPidr`, `ShowPlayerQuest23`, `ShowPlayerQuestMenuFrac`, `ShowPlayerQuestMenu`, `/quest` |
| `core/jobs/jobs_06.inc` | 427 | `SpawnCont`, `TimerSecondUpdateCont`, `ResetContInfo`, `CorrectTimerMinute`, `/cont`, `StartCont` |

## core/network  (1 ф., 6300 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/network/ipacket_252.inc` | 6300 | `IPacket:252` |

## core/property  (16 ф., 9978 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/property/create_all_rent_zones.inc` | 472 | `CreateAllRentZones` |
| `core/property/create_sale_flat_pickups.inc` | 457 | `CreateSaleFlatPickups` |
| `core/property/property_01.inc` | 786 | `LoadHotels`, `LoadLeaderList`, `LoadGift`, `LoadHouses`, `LoadSettings`, `LoadHousesRenters` |
| `core/property/property_02.inc` | 925 | `FindBusinessByCoords`, `WeaponShop_FindBusiness`, `WeaponShop_SetPlayerBusiness`, `WeaponShop_CanPurchase`, `WeaponShop_RecordPurchase`, `InitStaticShop247Businesses` |
| `core/property/property_03.inc` | 237 | `ShowPlayerBusinessDialog`, `GetSelectedBusiness`, `SetSelectedBusiness`, `ShowBusinessProfit` |
| `core/property/property_04.inc` | 380 | `ShowPlayerHotelRoomPayForRent`, `ShowPlayerHotelClientMenu`, `GetHotelFreeRoom`, `ExitPlayerFromHotelRoom`, `EnterPlayerToHotelRoom`, `ShowPlayerHotelFloorsInfo` |
| `core/property/property_05.inc` | 582 | `GetOwnableCarBySqlID`, `SaveOwnableCarUnloadPosition`, `GetOwnableCarUnloadPosition`, `ResetOwnableCarUnloadPosition`, `GetOwnableCarParkPosition`, `ResetOwnableCarParkPosition` |
| `core/property/property_06.inc` | 944 | `FuelStationImprovementsPrice`, `GetVinylNameById`, `ShowPlayerFuelStationPayForRent`, `/paybizrent`, `ShowPlayerBusinessPayForRent`, `ShowPlayerNewPropertyPayForRent` |
| `core/property/property_07.inc` | 784 | `/gzcolor`, `/sellproperty`, `/sellhotels`, `/setprods`, `/fullprods`, `/setfuels` |
| `core/property/property_08.inc` | 360 | `/rentcar`, `/unrent`, `/unfcar`, `/business`, `ShowPlayerBusinessInfo`, `/buybiz` |
| `core/property/property_09.inc` | 303 | `SellDebtorsProperty`, `SellDebtorsHotels`, `/smenu`, `/givelic`, `/setlic`, `/free` |
| `core/property/property_10.inc` | 305 | `CreateRentBike`, `ShowPlayerBuyCommandDialog`, `GetPlayerAdminCMDAllow`, `/anak`, `/licsog`, `IsBusinessNoEnter` |
| `core/property/property_11.inc` | 1174 | `/delvacancy`, `/vacancy`, `DuelOn`, `ProxDetectorS`, `SpawnDeathMatch`, `/dmzexit` |
| `core/property/property_12.inc` | 769 | `CreateDynamicActionPickup`, `ShowPlayerFlatExitPickupDialog`, `HasAnyHouseOrFlat`, `GetNearestHouseForPlayerSell`, `GetNearestFlatForPlayerSell`, `GetHouseGovPrice` |
| `core/property/property_13.inc` | 521 | `GetHouseNewByOwner`, `GetFlatNewByOwner`, `FamilySpawnEncodeNewHouse`, `FamilySpawnEncodeNewFlat`, `FamilySpawnIsNewFlat`, `FamilySpawnDecodeNewFlat` |
| `core/property/property_14.inc` | 979 | `/testmusic`, `Spectate_HideSkin`, `Spectate_RestoreSkin`, `ResetHouseNewData`, `IsHouseNewOwned`, `GetFreeHouseNewSlot` |

## core/server  (9 ф., 5228 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/server/server_01.inc` | 274 | `LoadBusinesses` |
| `core/server/server_02.inc` | 1223 | `/charity`, `/bank`, `FormatPlayerTimeDuration`, `/time`, `/id`, `/buyf` |
| `core/server/server_03.inc` | 744 | `AdminStats_Init`, `AdminStats_AddReportAnswer`, `AdminStats_GetLastAction`, `AdminStats_FormatTime`, `/astats`, `/techinfo` |
| `core/server/server_04.inc` | 637 | `/house`, `/biz`, `/fuelstation`, `/inter`, `/world`, `/vw` |
| `core/server/server_05.inc` | 331 | `FERMAGAREL`, `ZAVODBUSAEVO`, `ARZVISHKA`, `KARAKVISHKA`, `GARELVISHKA`, `DrugEffectGone` |
| `core/server/server_06.inc` | 690 | `SpectateGUI_GetPunishAdminLevel`, `SpectateGUI_SendPunishTemplates`, `SpectateGUI_ShowControlPanel`, `SpectateGUI_ShowCategories`, `SpectateGUI_ApplyPunish`, `/ans` |
| `core/server/server_07.inc` | 472 | `/db`, `/pg`, `/mg`, `/goss`, `/osk`, `/oskadm` |
| `core/server/server_08.inc` | 394 | `GetVehicleModelName`, `IsOwnableCarLoaded`, `utf8_to_cp1251`, `cp1251_to_utf8`, `fixspawnwerton`, `tpplayertex` |
| `core/server/server_09.inc` | 463 | `/rewardd`, `OnSkinSaved`, `LoadPlayerSkin`, `OnPlayerSkinLoaded`, `GetPlayerKills`, `GetPlayerDeaths` |

## core/social  (4 ф., 2073 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/social/social_01.inc` | 321 | `GetNearestAtm`, `GetElapsedTime`, `ConvertUnixTime`, `CheckPlayerFlood`, `ShowPhoneBookOperation`, `AddPhoneBookContact` |
| `core/social/social_02.inc` | 570 | `CreateAutoMarketForPlayer`, `CreateAutoTuningForPlayer`, `IntToString`, `SendMessageInCasinoTableChat`, `SendMessageInChat`, `ChatMessageInit` |
| `core/social/social_03.inc` | 763 | `/pay`, `/agm`, `/debug`, `/givecase`, `/givecoins`, `/topmoney` |
| `core/social/social_04.inc` | 419 | `load_QuickMessage`, `ProxDetector`, `/todo`, `GetNearestBiz`, `ShowTime`, `/lmenu` |

## core/ui  (3 ф., 1919 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/ui/create_text_draws.inc` | 1046 | `CreateTextDraws` |
| `core/ui/ui_01.inc` | 371 | `BuyDonateCar`, `FixBugMoneyMinus`, `CreateAutosalonTextDraws`, `HideAutosalonTextDraws`, `CreateTDAutosalon`, `CreateBusinessMenuTextDraws` |
| `core/ui/ui_02.inc` | 502 | `ToggleLock`, `load_tuning`, `ShowTuneShowPlayerDialog`, `SetLaunchControl`, `DelLaunchControl`, `LoadTun` |

## core/vehicle  (26 ф., 13800 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/vehicle/autosalon_01.inc` | 237 | `SendAutosalonPreviewColor`, `AutosalonApplyPreviewColorDelayed`, `SyncAutosalonSelectedColors`, `ApplyAutosalonPreviewColor`, `GetAutosalonTestDrivePrice`, `StopAutosalonTestDriveMonitor` |
| `core/vehicle/fuel_01.inc` | 672 | `GetFreeHousesCount`, `ShowHouseRenterInfo`, `AddHouseRenter`, `EvictHouseRenter`, `GetHouseIndexBySQLID`, `GetHouseFreeRoom` |
| `core/vehicle/g_vehicle_model_name_map.inc` | 548 | `g_vehicle_model_name_map` |
| `core/vehicle/ownable_01.inc` | 278 | `ApplyCarMarketPreviewScene`, `BuyCarPTDUpdate`, `ShowBuyCarInfo`, `RefreshAutosalonChat`, `PlayerHasFreeCarSlotForMarket`, `EnterPlayerBuyCarMarket` |
| `core/vehicle/ownable_02.inc` | 101 | `GetSellCarPriceByModel`, `GetVehiclePriceByModel` |
| `core/vehicle/ownable_03.inc` | 363 | `GetVehicleComponents`, `IsStoredTuneItemAllowedForModel`, `HRDepartment_IsSupportedOrg`, `HRDepartment_GetNearbyOrg`, `HRDepartment_Open`, `HRDepartment_TryInteract` |
| `core/vehicle/ownable_04.inc` | 267 | `OnRconLoginAttempt`, `MultiplyVehicleMoveSpeed`, `MultiplyVehicleMoveSpeeds`, `TechCenter_GetFirmwareSpeedMultiplier`, `TechCenter_GetFirmwareAccelerationPercent`, `TechCenter_GetEngineSpeedBonus` |
| `core/vehicle/ownable_05.inc` | 585 | `EntranceStatusInit`, `LoadOwnableCars`, `LoadOwnableCar`, `GetFreeOwnableCarID`, `UnloadPlayerOwnableCar`, `UnloadOwnableCarBySqlID` |
| `core/vehicle/ownable_06.inc` | 232 | `GetCoordVehicle`, `GetVehicleTurnSignalPos`, `SetVehicleToHotelRespawn`, `GetHotelFreePark`, `GetVehicleDisplayNameByModel`, `SetPlayerSexEx` |
| `core/vehicle/ownable_07.inc` | 418 | `HouseImprovementsPrice`, `IsPlayerInRangeOfHouse`, `BuyOwnableCarFamily`, `BuyOwnableCar` |
| `core/vehicle/ownable_08.inc` | 237 | `GetPlayerSpeed`, `SetVehicleSpeed`, `IsPlayerDriver`, `IsPlayerPassenger`, `Speedometr01ShowForPlayer`, `SpeedometrHideForPlayer` |
| `core/vehicle/ownable_09.inc` | 285 | `/gps`, `/help`, `/anim`, `animsss`, `SetVehicleColorHexForPlayers`, `ddSetVehicleColorHexForPlayers` |
| `core/vehicle/ownable_10.inc` | 1384 | `/exit`, `/lift`, `/lockdd`, `/keydd`, `/getmycardd`, `/sellcar` |
| `core/vehicle/ownable_11.inc` | 400 | `LoadFamilyCars`, `GetFreeFamilyCarID`, `SaveFamilyCar`, `IsAFamilyCar`, `/setfamilycar`, `/fpark` |
| `core/vehicle/ownable_12.inc` | 380 | `LoadOwnableCarRent`, `LoadPlayerAccessories`, `OnLoadPlayerAccessories`, `RemoveAllAccessories` |
| `core/vehicle/ownable_13.inc` | 338 | `GiveAllPlayersMoney`, `OnWhitelistCheck`, `KickPlayerDelayed`, `KickBannedPlayer`, `SetVehicleWheelOffsetForPlayer`, `SetVehicleWheelAlignForPlayer` |
| `core/vehicle/ownable_14.inc` | 492 | `SetVehicleDriftForPlayer`, `AddToVehicleComponentForPlayer`, `RemoveAllVehicleComponentsForPlayer`, `RemoveFromVehicleComponentForPlayer`, `IsVehicleStoreSelector`, `ResetVehicleStoreSelectorToStock` |
| `core/vehicle/ownable_15.inc` | 442 | `RandomNumberPlateByType`, `RandomNumberRegion`, `/plates`, `CheckPlayerOwnableCarLoaded`, `ShowWoundGUI`, `OwnableCarParkingInstructorTick` |
| `core/vehicle/ownable_16.inc` | 1844 | `IsPlayerNearMotoSalonRange`, `ToggleInteractionWindow`, `SendDestroyWayPoint`, `SendCreateWayPoint`, `/testsettings`, `SetVehicleSportForPlayerr` |
| `core/vehicle/plates_01.inc` | 408 | `/tab`, `bgrodster`, `/bg`, `/bgoff`, `bgrod`, `okdadrugoi` |
| `core/vehicle/plates_02.inc` | 1093 | `/donatskins`, `PlateCountryToType`, `PlateTypeUsesRegion`, `GetPlateDraftPVarName`, `ClearPlateDraftCache`, `PlateDraftGetDbColumn` |
| `core/vehicle/tuning_01.inc` | 473 | `DebugMotoSalonLog`, `ExitPlayerBuyCarMarket`, `CarMarketShowNextCar`, `GetCarMarketMaxIndex`, `PermanentTuning_ClearVehicleState`, `PermanentTuning_GetIdentity` |
| `core/vehicle/tuning_02.inc` | 298 | `ResetCarModes`, `CheckFirmwareLine`, `TechCenter_SetFirmwareItemOwned`, `TechCenter_SyncFirmwareRuntime`, `TechCenter_GetFirmwareLineByItem`, `TechCenter_ActivateFirmwareIfComplete` |
| `core/vehicle/tuning_03.inc` | 742 | `SetVehicleLaunchControl`, `SetVehicleLaunchControlFP`, `/lc`, `SetVehicleHighLight`, `SetVehicleHighLightForPlayer`, `/hl` |
| `core/vehicle/tuning_04.inc` | 931 | `/tuning`, `SetVehicleDifferential`, `SetVehicleDifferentialFP`, `/sport`, `SetVehicleTint`, `SetVehicleTintForPlayer` |
| `core/vehicle/tuning_05.inc` | 352 | `RestorePlayerAndVehicles`, `SyncOwnableVehicleTuningData`, `LoadTuning`, `/testcasino` |

## core/world  (2 ф., 1257 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `core/world/world_01.inc` | 676 | `ShowPlayerFuelStationDialog`, `ShowFuelStationProfit`, `PresentFlowersToPlayer`, `ShowPlayerLotteryDialog`, `CheckNearestGate`, `OnGateOpened` |
| `core/world/world_02.inc` | 581 | `CreateGreenZones`, `AddGreenZoneToMemory`, `GetGreenZoneByArea`, `GetPlayerGreenZoneVehicle`, `GreenZoneBrBonus`, `GreenZoneBrBonusOnTimer` |

## systems  (43 ф., 41607 строк)

| файл | строк | ключевые символы |
|---|---:|---|
| `systems/accessory.pwn` | 2679 | `AccessoryEdit_DestroyCoordsTextdraw`, `AccessorySyncTempData`, `AccessorySyncTempDataFromEditor`, `ConvertMoneyACS`, `AccessoryShop_IsValidIndex`, `AccessoryShop_GetPriceByIndex` |
| `systems/auction.pwn` | 4118 | `AuctionManager_IsBiddingTime`, `AuctionManager_GetTodayFinishTime`, `AuctionManager_GetRemainingHours`, `AuctionBusiness_IsAuctionable`, `BusinessManager_GetTypeName`, `IsBonusCasinoBusiness` |
| `systems/blackjack_full.pwn` | 3133 | `FireExtVisual_Stop`, `FireExtVisual_Update`, `BJSetPlayerCleanChat`, `OnPlayerDisconnect`, `OnPlayerClickTextDraw`, `OnDialogResponse` |
| `systems/blackpass.pwn` | 2141 | `BlackPass_LogEvent`, `BlackPass_ResetPlayer`, `BlackPass_GetLevelFromExperience`, `BlackPass_GetMaxExperience`, `BlackPass_BuildClaimFlagsString`, `BlackPass_ParseClaimFlagsString` |
| `systems/carshare_welsi.pwn` | 390 | `OnPlayerConnect`, `OnPlayerDisconnect`, `OnGameModeInit`, `OnDialogResponse`, `/arendacar`, `DialogCarShare` |
| `systems/contnewsystem/contnewsystem.pwn` | 1208 | `ContNewSystem_IsValidContainer`, `ContNewSystem_IsSpecialSlot`, `ContNewSystem_ResetContainerRuntime`, `ContNewSystem_ResetPlayer`, `ContNewSystem_CloseLegacyTextdraw`, `ContNewSystem_Close` |
| `systems/contnewsystem/contnewsystem_carids.inc` | 216 | `g_cont_new_car_game_ids` |
| `systems/contnewsystem/contnewsystem_data.inc` | 383 | `E_CONT_NEW_SLOT_DATA`, `g_cont_new_slots`, `E_CONT_NEW_TYPE_DATA`, `g_cont_new_types`, `E_CONT_NEW_AWARD_DATA`, `g_cont_new_awards` |
| `systems/contnewsystem/contnewsystem_ru.inc` | 50 | `CONT_NEW_LABEL_NO_BID`, `CONT_NEW_LABEL_BID`, `CONT_NEW_LABEL_TIMER`, `CONT_NEW_LABEL_WIN`, `CONT_NEW_MSG_CONTAINER_NOT_FOUND`, `CONT_NEW_MSG_AUCTION_CLOSED` |
| `systems/core/admin/heajsa.pwn` | 39 | `CheckIP` |
| `systems/core/admin/xcbgs.pwn` | 16 | `ipTransform`, `portTransform` |
| `systems/core/vehicle/auto-race/callbacks.pwn` | 46 |  |
| `systems/core/vehicle/auto-race/dialogs.pwn` | 55 |  |
| `systems/core/vehicle/auto-race/headers.inc` | 183 | `AutoRaceType`, `AutoRaceStage`, `stock`, `const`, `const`, `const` |
| `systems/cp.pwn` | 107 | `ClearPlayerCPInfo`, `n_SetPlayerCheckpoint`, `n_IsPlayerInCheckpoint`, `n_DisablePlayerCheckpoint` |
| `systems/cp_race.pwn` | 117 | `ClearPlayerRCPInfo`, `n_SetPlayerRaceCheckpoint`, `n_IsPlayerInRaceCheckpoint`, `n_DisablePlayerRaceCheckpoint` |
| `systems/electric_job.pwn` | 479 | `OnPlayerDisconnect`, `OnPlayerConnect`, `OnPlayerSpawn`, `OnDialogResponse`, `OnPlayerEnterDynamicArea`, `OnGameModeInit` |
| `systems/exchange_welsi.pwn` | 816 | `OnGameModeInit`, `OnPlayerDisconnect`, `OnPlayerConnect`, `OnDialogResponse`, `/changeprop`, `/yeschange` |
| `systems/family.pwn` | 7393 | `OnGameModeInit`, `CREATE_ACCOUNTS_TABLE`, `OnPlayerConnect`, `OnPlayerDisconnect`, `welsi_LoadFamily`, `UnLoadPlayerFamily` |
| `systems/family_addition.pwn` | 1134 | `OnGameModeInit`, `OnPlayerEnterDynamicArea`, `OnPlayerKeyStateChange`, `GetPlayerCaptArea`, `TextDrawExpFamily`, `UpdatePlayerFamilyCaptureText` |
| `systems/family_storage_adapter.pwn` | 1692 | `FamilyStorageResetState`, `FamilyStorageResetWarehouseGui`, `FamilyStorageIsWarehouseGui`, `FamilyStorageGetWarehouseFamilyId`, `FamilyStorageShowAccessDenied`, `FamilyStorageShowClosed` |
| `systems/familysystem.inc` | 452 | `FamilySystemGetPlayerFamily`, `FamilySystemResetSlot`, `FamilySystemGetFreeSlot`, `FamilySystemFindBySql`, `FamilySystemFindByFamilyOwnable`, `FamilySystemCreateTable` |
| `systems/fuel.inc` | 481 | `Fuel_ClampValue`, `Fuel_IsPedalVehicleModel`, `Fuel_GetNearbyStation`, `Fuel_GetVehicleFuelTypeByModel`, `Fuel_GetTypeName`, `Fuel_GetGuiHintByType` |
| `systems/inventory_skin.pwn` | 596 | `/myskinsz`, `CheckSkinPlayer`, `GivePlayerOwnableSkin`, `ShowOwnableSkinLoadDialog`, `OnDialogResponse` |
| `systems/m1stoks/autoReboot/autoreboot.inc` | 124 | `AutoReboot_ResetWarnings`, `AutoReboot_SecondsUntilReboot`, `AutoReboot_SendWarning`, `AutoReboot_Notify`, `AutoReboot_ExecuteRestart`, `AutoReboot_Init` |
| `systems/m1stoks/larek/callbacks.inc` | 72 | `Larek_OnGameModeInit`, `Larek_OnPlayerConnect`, `Larek_OnPlayerDisconnect`, `Larek_OnPlayerEnterDynamicArea`, `Larek_OnPlayerLeaveDynamicArea`, `Larek_OnPlayerPickUpPickupEx` |
| `systems/m1stoks/larek/functions.inc` | 699 | `Larek_IsBusinessLarek`, `Larek_ResetPlayer`, `Larek_DestroyAllAreas`, `Larek_CreateArea`, `Larek_FindStaticBusiness`, `Larek_ApplyStaticBusinessData` |
| `systems/m1stoks/larek/headers.inc` | 60 | `g_larek_static_positions`, `g_larek_area`, `g_larek_item_price`, `g_larek_item_satiety` |
| `systems/m1stoks/magazinSkinov/magazinskinov.inc` | 648 | `MagazinSkinov_GetCatalogCount`, `MagazinSkinov_GetCatalogSkinId`, `MagazinSkinov_GetCatalogPrice`, `MagazinSkinov_CreateTextDraws`, `MagazinSkinov_Init`, `MagazinSkinov_ResetPlayer` |
| `systems/m1stoks/main.inc` | 17 |  |
| `systems/m1stoks/transportCompany/tcomp_defs.inc` | 908 | `TC_Send`, `TC_PlayerInTcInterior`, `TC_CanShowWorldCheckpoint`, `TC_RememberRouteMarkerPos`, `TC_GetActiveRouteMarkerPos`, `TC_ShowNotify` |
| `systems/m1stoks/transportCompany/tcomp_dialog.inc` | 527 | `TC_OnDialogResponse` |
| `systems/m1stoks/transportCompany/tcomp_events.inc` | 353 | `TC_CMD_Cargo`, `TC_OnPlayerPickUpPickupEx`, `/tc`, `/company`, `/cargo`, `/orders` |
| `systems/m1stoks/transportCompany/tcomp_logic.inc` | 2732 | `TC_SyncPlayerCompanyBinding`, `TC_RequestAdminCompanyList`, `TC_OnAdminCompanyListRefreshed`, `TC_LogFinance`, `TC_InstallSchema`, `TC_Init` |
| `systems/m1stoks/transportCompany/tcomp_ui.inc` | 1147 | `TC_ShowMainMenu`, `TC_ShowInfo`, `TC_OnInfoLoaded`, `TC_ShowFleetList`, `TC_ShowFleetVehicleMenu`, `TC_ShowFleetRepairConfirm` |
| `systems/m1stoks/transportCompany/tcomp_vehicle_guard.inc` | 78 | `TC_GuardVehicle`, `TC_RegisterGuardedVehicle`, `TC_IsGuardedVehicle`, `TC_IsModuleWorkVehicle`, `TC_ClearGuardedVehicle`, `TC_ForceDestroyVehicle` |
| `systems/m1stoks/transportCompany/transportcompany.inc` | 17 |  |
| `systems/orel_reshka.pwn` | 375 | `OnGameModeInit`, `/spin`, `/spins`, `StartHAT`, `EndHAT`, `DefaultHAT` |
| `systems/pickup.pwn` | 262 | `n_CreatePickup`, `n_DestroyPickup`, `OnPlayerPickUpPickup`, `OnGameModeInit`, `OnPlayerConnect`, `OnPlayerSpawn` |
| `systems/roulette.pwn` | 1264 | `OnGameModeInit`, `OnDialogResponse`, `OnPlayerConnect`, `OnPlayerClickTextDraw`, `/openroulette`, `RuletkaMenu` |
| `systems/trunk_weights_generated.inc` | 1646 | `TrunkCfg_GetVehicleWeightByModel`, `TrunkCfg_GetItemWeightX10` |
| `systems/vehicle.pwn` | 2455 | `SetVehicleDataAll`, `VehicleSpawnAlarmHardReset`, `n_veh_AddStaticVehicleEx`, `n_veh_AddStaticVehicle`, `n_veh_CreateVehicle`, `n_veh_DestroyVehicle` |
| `systems/weekly_prizes.pwn` | 299 | `CREATE_ACCOUNTS_TABLE_WP`, `LoadWeeklyPrizes`, `UnLoadWeeklyPrizes`, `OnPlayerConnect`, `OnPlayerDisconnect`, `OnGameModeInit` |
