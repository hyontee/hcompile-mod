# Интеграция marketplace в мод — что сделано

## Файлы
- `gamemodes/bleach.pwn` — из него удалён старый недоделанный маркетплейс
  (~1390 строк, таблица `marketplace_items`, свои GUI-функции), вместо него
  подключён новый файл. Сохранены 6 низкоуровневых хелперов, которые
  реально относятся к инвентарю мода и нужны новой системе:
  `Market_Inv11_GetSlotData`, `Market_Inv11_HasFreeSlot`,
  `Market_Inv11_FindSkinSlotByModel`, `Market_GetAccessoryNameByModel`,
  `Market_IsAccessoryItem`, `Market_GetItemNameByData`.
- `include/system/marketplace.pwn` — новый файл (бывший `marketplace__2_.pwn`),
  переработанный под реальный инвентарь мода (см. ниже).

## Точки подключения в bleach.pwn
1. `OnGameModeInit` → добавлен вызов `Marketplace_Init();`
2. Функция сброса данных игрока (там же, где `Inv11Trade_ResetPlayer`) →
   добавлен `Market_ResetPlayer(playerid);`
3. `OnDialogResponse` → добавлена строка
   `if (Market_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;`
4. Диспетчер входящих пакетов (`switch(rpcid)` в `IPacket:252`) →
   `case 77` теперь зовёт `Market_OnPacket` (маркетплейс), добавлен
   `case 74` для `MPReward_OnPacket` (система наград /reward).

## Главная переделка: инвентарь
Скрипт был написан под другую систему инвентаря (донорский проект) —
массивы в памяти `g_PlayerInventory`/`g_PlayerActiveSlots`, которых в этом
моде нет. Весь слой "источников предмета" (~180 строк) переписан на
реальный, живой SQL API мода:

- Обычные слоты инвентаря → `Market_Inv11_GetSlotData` /
  `Inventory11_AddItemToDatabase` / `Inventory11_DeleteSlotFromDatabase`.
- Экипированный скин / номер телефона → напрямую `P_SKIN` / `P_PHONE`
  (`GetPlayerData`/`SetPlayerData`), а не отдельный массив "активных слотов".
- Экипированные аксессуары (2 слота) → `Inventory11_GetActiveAccessories`
  и таблица `accessories_players` (было 10 несуществующих слотов — стало 2,
  как реально поддерживает мод).
- Донорские функции `Inventory_AddItem/RemoveItem/DeleteItem/GetFreeSlot`,
  `GetItemName(ById)`, `Accessory_GetItemIdByModel`, `ShowNotificationSile`
  реализованы через реальные `Inventory11_*`, `Market_GetItemNameByData`,
  `Inv11_GetAccItemByModel`, `ShowNotificationLaird`.
- `SendPacketToClient(playerid, guiid, json)` (которого не было в моде)
  реализован как обёртка над существующим `OnPacketIncoming`.

## Что НЕ проверено (нет компилятора/сервера в этой среде)
- Реальная компиляция через `pawncc` — здесь недоступна (только .exe без
  wine). Сделана статическая проверка: баланс скобок, разрешение всех
  вызываемых извне функций/имён по всей базе кода.
- Плейт-предметы (номерные знаки) при покупке через маркетплейс — регион
  проставляется как `"RUS"` по умолчанию, т.к. в лоте маркетплейса эта
  информация не хранится. Стоит проверить на реальных данных.
- Стек предметов вроде аптечек/симок: `Market_Inv11_HasFreeSlot` не
  учитывает возможность доклада в существующий стек — в редком случае
  может показать "инвентарь полон", хотя реально место есть.

**Рекомендация: обязательно протестировать на тестовом сервере перед
продакшеном** — система напрямую трогает деньги и предметы игроков.
