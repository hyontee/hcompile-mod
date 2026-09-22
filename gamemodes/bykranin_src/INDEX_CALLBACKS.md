# Индекс колбэков

Один и тот же колбэк (например `OnPlayerConnect`) обрабатывается в **нескольких** файлах: каждый модуль подключает свою копию через ALS-цепочку (`#define OnX prefix_OnX`).
Поэтому, если нужно понять, что происходит при подключении игрока, смотрите **все** файлы из списка.

## OnAdminCompanyListRefreshed  (1)
- `systems/m1stoks/transportCompany/tcomp_logic.inc:43`  (prefix `TC`)

## OnBizParamsListPublic  (1)
- `systems/m1stoks/larek/functions.inc:695`  (prefix `Larek`)

## OnBusinessCreatedPublic  (1)
- `systems/m1stoks/larek/functions.inc:481`  (prefix `Larek`)

## OnCompaniesLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_logic.inc:234`  (prefix `TC`)

## OnCompaniesSeeded  (1)
- `systems/m1stoks/transportCompany/tcomp_logic.inc:202`  (prefix `TC`)

## OnDialogResponse  (13)
- `core/admin/admin_02.inc:198`
- `core/callbacks/on_dialog_response.inc:5`
- `systems/accessory.pwn:1574`
- `systems/auction.pwn:362`
- `systems/blackjack_full.pwn:581`
- `systems/carshare_welsi.pwn:118`
- `systems/electric_job.pwn:104`
- `systems/exchange_welsi.pwn:85`
- `systems/family.pwn:3241`
- `systems/inventory_skin.pwn:507`
- `systems/orel_reshka.pwn:281`
- `systems/roulette.pwn:92`
- `systems/weekly_prizes.pwn:220`

## OnEmployeesLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_ui.inc:562`  (prefix `TC`)

## OnFinanceDetailLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_ui.inc:672`  (prefix `TC`)

## OnFleetLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_logic.inc:277`  (prefix `TC`)

## OnGameModeExit  (1)
- `core/callbacks/callbacks_01.inc:5`

## OnGameModeInit  (15)
- `core/callbacks/on_game_mode_init.inc:5`
- `systems/accessory.pwn:1392`
- `systems/auction.pwn:1352`
- `systems/blackjack_full.pwn:3055`
- `systems/carshare_welsi.pwn:99`
- `systems/electric_job.pwn:344`
- `systems/exchange_welsi.pwn:19`
- `systems/family.pwn:213`
- `systems/family_addition.pwn:77`
- `systems/m1stoks/larek/callbacks.inc:12`  (prefix `Larek`)
- `systems/orel_reshka.pwn:26`
- `systems/pickup.pwn:147`
- `systems/roulette.pwn:70`
- `systems/vehicle.pwn:2348`
- `systems/weekly_prizes.pwn:139`

## OnHousesLoad  (1)
- `core/inventory/inventory_12.inc:2014`

## OnIncomingRPC  (1)
- `core/callbacks/callbacks_09.inc:28`

## OnInfoLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_ui.inc:59`  (prefix `TC`)

## OnLoadPlayerAccessories  (1)
- `core/vehicle/ownable_12.inc:244`

## OnLoadUnloadDone  (1)
- `systems/m1stoks/transportCompany/tcomp_logic.inc:1674`  (prefix `TC`)

## OnMinuteTimer  (1)
- `core/callbacks/callbacks_07.inc:123`

## OnObjectMoved  (1)
- `core/callbacks/callbacks_03.inc:243`

## OnPersonalLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_ui.inc:712`  (prefix `TC`)

## OnPlayerBindingLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_logic.inc:2578`  (prefix `TC`)

## OnPlayerClickMap  (1)
- `core/inventory/inventory_02.inc:188`

## OnPlayerClickPlayer  (1)
- `core/inventory/inventory_02.inc:173`

## OnPlayerClickPlayerTextDraw  (2)
- `core/callbacks/callbacks_06.inc:5`
- `systems/auction.pwn:1454`

## OnPlayerClickTextDraw  (4)
- `core/callbacks/on_player_click_text_draw.inc:5`
- `systems/accessory.pwn:915`
- `systems/blackjack_full.pwn:284`
- `systems/roulette.pwn:271`

## OnPlayerCommandPerformed  (1)
- `core/inventory/inventory_02.inc:246`

## OnPlayerCommandReceived  (1)
- `core/inventory/inventory_02.inc:209`

## OnPlayerCommandText  (1)
- `core/callbacks/callbacks_01.inc:1408`

## OnPlayerConnect  (11)
- `core/callbacks/callbacks_01.inc:106`
- `systems/auction.pwn:1388`
- `systems/blackjack_full.pwn:3074`
- `systems/carshare_welsi.pwn:60`
- `systems/electric_job.pwn:66`
- `systems/exchange_welsi.pwn:64`
- `systems/family.pwn:370`
- `systems/m1stoks/larek/callbacks.inc:22`  (prefix `Larek`)
- `systems/pickup.pwn:182`
- `systems/roulette.pwn:250`
- `systems/weekly_prizes.pwn:101`

## OnPlayerDeath  (2)
- `core/callbacks/callbacks_01.inc:814`
- `systems/family_addition.pwn:584`

## OnPlayerDisconnect  (10)
- `core/callbacks/callbacks_01.inc:277`
- `systems/blackjack_full.pwn:251`
- `systems/carshare_welsi.pwn:80`
- `systems/electric_job.pwn:47`
- `systems/exchange_welsi.pwn:38`
- `systems/family.pwn:389`
- `systems/family_addition.pwn:356`
- `systems/m1stoks/larek/callbacks.inc:29`  (prefix `Larek`)
- `systems/roulette.pwn:979`
- `systems/weekly_prizes.pwn:120`

## OnPlayerEnterCheckpoint  (1)
- `core/callbacks/on_player_enter_checkpoint.inc:5`

## OnPlayerEnterDynamicArea  (6)
- `core/callbacks/on_player_enter_dynamic_area.inc:5`
- `systems/auction.pwn:1412`
- `systems/blackjack_full.pwn:3027`
- `systems/electric_job.pwn:245`
- `systems/family_addition.pwn:106`
- `systems/m1stoks/larek/callbacks.inc:38`  (prefix `Larek`)

## OnPlayerEnterDynamicCP  (1)
- `core/callbacks/callbacks_06.inc:152`

## OnPlayerEnterRaceCheckpoint  (1)
- `core/callbacks/callbacks_03.inc:10`

## OnPlayerEnterVehicle  (3)
- `core/callbacks/callbacks_01.inc:1413`
- `systems/family.pwn:7169`
- `systems/family_addition.pwn:1046`

## OnPlayerExitedMenu  (1)
- `core/callbacks/callbacks_04.inc:154`

## OnPlayerInteriorChange  (1)
- `core/callbacks/callbacks_04.inc:179`

## OnPlayerKeyStateChange  (2)
- `core/callbacks/on_player_key_state_change.inc:5`
- `systems/family_addition.pwn:175`

## OnPlayerLeaveCheckpoint  (1)
- `core/callbacks/callbacks_03.inc:5`

## OnPlayerLeaveDynamicArea  (4)
- `core/callbacks/on_player_leave_dynamic_area.inc:5`
- `systems/family_addition.pwn:260`
- `systems/m1stoks/larek/callbacks.inc:48`  (prefix `Larek`)
- `systems/pickup.pwn:238`

## OnPlayerLeaveDynamicCP  (1)
- `core/callbacks/callbacks_06.inc:344`

## OnPlayerLeaveRaceCheckpoint  (1)
- `core/callbacks/callbacks_03.inc:233`

## OnPlayerNotificationClick  (1)
- `core/callbacks/callbacks_08.inc:89`

## OnPlayerObjectMoved  (1)
- `core/callbacks/callbacks_03.inc:248`

## OnPlayerPickUpDynamicPickup  (1)
- `core/property/property_12.inc:705`

## OnPlayerPickUpPickup  (1)
- `systems/pickup.pwn:118`

## OnPlayerPickUpPickupEx  (2)
- `core/callbacks/on_player_pick_up_pickup_ex.inc:5`
- `systems/m1stoks/larek/callbacks.inc:61`  (prefix `Larek`)

## OnPlayerRequestClass  (1)
- `core/callbacks/callbacks_01.inc:15`

## OnPlayerRequestSpawn  (1)
- `core/callbacks/callbacks_01.inc:27`

## OnPlayerSelectedMenuRow  (1)
- `core/callbacks/callbacks_04.inc:34`

## OnPlayerSkinLoaded  (1)
- `core/server/server_09.inc:144`

## OnPlayerSpawn  (6)
- `core/callbacks/callbacks_01.inc:677`
- `systems/accessory.pwn:836`
- `systems/electric_job.pwn:85`
- `systems/family_addition.pwn:547`
- `systems/orel_reshka.pwn:357`
- `systems/pickup.pwn:205`

## OnPlayerStateChange  (1)
- `core/callbacks/callbacks_02.inc:135`

## OnPlayerStreamIn  (1)
- `core/callbacks/callbacks_05.inc:5`

## OnPlayerStreamOut  (1)
- `core/callbacks/callbacks_05.inc:10`

## OnPlayerTakeDamage  (1)
- `core/callbacks/callbacks_01.inc:1166`

## OnPlayerText  (1)
- `core/callbacks/callbacks_01.inc:1315`

## OnPlayerTimerPublic  (1)
- `systems/m1stoks/larek/functions.inc:562`  (prefix `Larek`)

## OnPlayerUpdate  (2)
- `core/callbacks/on_player_update.inc:5`
- `systems/accessory.pwn:882`

## OnPlayerUpdatePublic  (1)
- `systems/m1stoks/larek/functions.inc:557`  (prefix `Larek`)

## OnRatingLoaded  (1)
- `systems/m1stoks/transportCompany/tcomp_ui.inc:440`  (prefix `TC`)

## OnRconCommand  (1)
- `core/callbacks/callbacks_03.inc:238`

## OnRconLoginAttempt  (1)
- `core/vehicle/ownable_04.inc:5`

## OnSecondTimer  (1)
- `core/callbacks/callbacks_07.inc:62`

## OnSkinSaved  (1)
- `core/server/server_09.inc:125`

## OnTimer  (1)
- `core/world/world_02.inc:87`  (prefix `GreenZoneBrBonus`)

## OnTrailerUpdate  (1)
- `core/callbacks/callbacks_01.inc:1295`

## OnVehicleDamageStatusUpdate  (1)
- `core/callbacks/callbacks_02.inc:164`

## OnVehicleDeath  (1)
- `core/callbacks/callbacks_01.inc:1301`

## OnVehicleMod  (1)
- `core/callbacks/callbacks_04.inc:14`

## OnVehiclePaintjob  (1)
- `core/callbacks/callbacks_04.inc:22`

## OnVehicleRespray  (1)
- `core/callbacks/callbacks_04.inc:28`

## OnVehicleSpawn  (1)
- `core/callbacks/callbacks_01.inc:1191`

## OnVehicleStoreLoad  (1)
- `core/social/social_02.inc:450`

## OnVehicleStreamIn  (1)
- `core/callbacks/callbacks_05.inc:15`

## OnVehicleStreamOut  (1)
- `core/callbacks/callbacks_05.inc:43`

## OnWhitelistCheck  (1)
- `core/vehicle/ownable_13.inc:46`
