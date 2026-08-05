# Документация: Система инвентаря GTA:CR (Inventory Module)

> **Пакет:** `com.rockstargames.gtacr.gui.inventory`
> **Язык исходников:** Kotlin (скомпилирован в Android bytecode / Smali)
> **Платформа:** Android (GTA: Criminal Russia / Black Russia Online)

---

## Содержание

1. [Обзор архитектуры](#1-обзор-архитектуры)
2. [Классы и их роли](#2-классы-и-их-роли)
3. [Константы и параметры (Constants)](#3-константы-и-параметры-constants)
4. [Ключи JSON-протокола](#4-ключи-json-протокола)
   - [GetKeys — ключи для чтения данных с сервера](#41-getkeys--ключи-для-чтения-данных-с-сервера)
   - [PutKeys — ключи для отправки данных на сервер](#42-putkeys--ключи-для-отправки-данных-на-сервер)
5. [Структура входящих JSON-пакетов](#5-структура-входящих-json-пакетов)
   - [Пакет открытия инвентаря (GUIUsersInventory)](#51-пакет-открытия-инвентаря-guiusersinventory)
   - [Пакет открытия багажника/шкафа (GUICarsTrunkOrCloset)](#52-пакет-открытия-багажникашкафа-guicarstrunkorclose)
6. [Типы событий (TYPE_*)](#6-типы-событий-type_)
7. [Статусы (STATUS_*)](#7-статусы-status_)
8. [Исходящие JSON-пакеты (ActionsWithJSON)](#8-исходящие-json-пакеты-actionswithjson)
9. [Главные UI-классы](#9-главные-ui-классы)
   - [GUIUsersInventory](#91-guiusersinventory)
   - [GUICarsTrunkOrCloset](#92-guicarstrunkorclose)
   - [UILayoutUsersInventory](#93-uilayoutusersinventory)
   - [UILayoutExchange](#94-uilayoutexchange)
10. [Система обмена предметами (Exchange)](#10-система-обмена-предметами-exchange)
11. [Система перемещения предметов (Migrate)](#11-система-перемещения-предметов-migrate)
12. [Диалоги и вспомогательные классы](#12-диалоги-и-вспомогательные-классы)
13. [Система обучения (GuideForInventory)](#13-система-обучения-guideforinventory)
14. [Глобальное состояние (GlobalValue)](#14-глобальное-состояние-globalvalue)
15. [Типовые сценарии взаимодействия](#15-типовые-сценарии-взаимодействия)

---

## 1. Обзор архитектуры

Модуль реализует GUI-систему инвентаря для мобильной игры. Общение с сервером построено на **JSON-пакетах**, которые передаются через `GUIManager` (внешний компонент). Модуль разделён на следующие слои:

```
┌─────────────────────────────────────────────────────┐
│                  GUIManager (сетевой слой)           │
│      onPacketIncoming(id, json) / sendJsonData(...)  │
└──────────────────────┬──────────────────────────────┘
                       │
         ┌─────────────▼──────────────┐
         │      GUIUsersInventory      │  ◄── Главный контроллер
         │  (onPacketIncoming / show)  │
         └──┬──────────────────┬──────┘
            │                  │
   ┌────────▼──────┐   ┌──────▼────────────┐
   │UILayoutUsers  │   │  UILayoutExchange  │
   │  Inventory    │   │  (система обмена)  │
   └───────────────┘   └────────────────────┘

┌──────────────────────────────────────────┐
│        GUICarsTrunkOrCloset               │  ◄── Отдельный GUI
│  (багажник авто / шкаф / ящик)           │      для хранилищ
└──────────────────────────────────────────┘

       ActionsWithJSON  ──► отправка JSON на сервер
```

---

## 2. Классы и их роли

| Класс | Назначение |
|---|---|
| `GUIUsersInventory` | Главный контроллер инвентаря игрока. Принимает пакеты с сервера, управляет состоянием, координирует layouts. |
| `GUICarsTrunkOrCloset` | GUI для взаимодействия с багажником автомобиля, шкафом или ящиком (внешнее хранилище). |
| `UILayoutUsersInventory` | View-слой основного инвентаря: сетка предметов, слоты быстрого доступа, логика удаления/перемещения. |
| `UILayoutExchange` | View-слой экрана обмена с другим игроком (трейд). |
| `ActionsWithJSON` | Вспомогательный класс — формирует и отправляет JSON-пакеты на сервер через GUIManager. |
| `Constants` | Singleton с числовыми и строковыми константами системы. |
| `GetKeys` | Singleton с ключами JSON-полей для **входящих** пакетов. |
| `PutKeys` | Singleton с ключами JSON-полей для **исходящих** пакетов. |
| `GlobalValue` | Глобальный флаг `globalStatusBlocker` — блокирует повторные нажатия. |
| `MigrateItemsFromAny` | Логика конвертации raw JSON-предметов в объекты `InvItems`. |
| `LogicForMigrateItemsInCar` | Диалог подтверждения с ползунком количества при перемещении предметов в/из хранилища. |
| `LogicForDialogDelete` | Диалог подтверждения удаления предмета. |
| `UIChat` | Встроенный мини-чат внутри экрана обмена. |
| `GuideForInventory` | 10-шаговое обучение по работе с инвентарём и обменом. |
| `CustomEditText` | Кастомное поле ввода (используется для ввода суммы денег при обмене). |

---

## 3. Константы и параметры (Constants)

Класс `Constants` — Kotlin `object` (singleton), содержит все числовые идентификаторы системы.

### Размеры

| Константа | Значение | Описание |
|---|---|---|
| `SIZE_SLOTS` | `8` | Количество слотов быстрого доступа (hotbar) |
| `SIZE_EXCHANGE` | `16` | Максимальный размер поля обмена |

### Идентификаторы особых предметов

| Константа | Значение | Описание |
|---|---|---|
| `ID_SIM_CARD` | `58` (0x3a) | ID SIM-карты |
| `ID_SKIN` | `134` (0x86) | ID скина персонажа |
| `ID_DOCUMENTS` | `346` (0x15a) | ID документов |
| `ACCESSORY` | `1` | Тип аксессуар |

### Кнопки главного меню инвентаря

| Константа | Значение | Отображаемое название |
|---|---|---|
| `BUTTON_MENU` | `0` | Меню |
| `BUTTON_STATE` | `1` | Статистика |
| `BUTTON_DONATE` | `2` | Донат |
| `BUTTON_RADIAL_MENU` | `3` | Меню действий |
| `BUTTON_BLACK_PASS` | `4` | BLACK PASS |

### Кнопки действий с предметом

| Константа | Значение | Отображаемое название |
|---|---|---|
| `BUTTON_USE_ITEM` | `19` (0x13) | Использовать |
| `BUTTON_CHANGE` | `7` | Обмен |
| `BUTTON_DELETE_ITEM` | `9` | Удалить |

### Типы layout (экрана)

| Константа | Значение | Описание |
|---|---|---|
| `LAYOUT_INVENTORY` | `0` | Экран инвентаря |
| `LAYOUT_EXCHANGE` | `1` | Экран обмена |

### Принадлежность предметов в обмене

| Константа | Значение | Описание |
|---|---|---|
| `MY_ITEM` | `1` | Предмет принадлежит текущему игроку |
| `OTHER_ITEM` | `0` | Предмет другого игрока |
| `OTHER_PLAYERS_ITEM` | `2` | Предмет из инвентаря другого игрока |

### Статусы обмена

| Константа | Значение | Описание |
|---|---|---|
| `STATUS_NOT_APPLY_EXCHANGE` | `0` | Обмен не подтверждён |
| `STATUS_YOUR_APPLY_EXCHANGE` | `1` | Текущий игрок подтвердил |
| `STATUS_BOTH_PLAYERS_APPLY_EXCHANGE` | `2` | Оба игрока подтвердили |

### Типы обмена (VIEW)

| Константа | Значение | Описание |
|---|---|---|
| `VIEW_YOUR_EXCHANGE` | `0` | Просмотр своего поля обмена |
| `VIEW_OTHER_PLAYERS_EXCHANGE` | `1` | Просмотр поля другого игрока |

### Уровни VIP

| Константа | Значение | Описание |
|---|---|---|
| `PREMIUM_NONE` | `0` | Нет VIP |
| `PREMIUM_SILVER` | `1` | Silver |
| `PREMIUM_GOLD` | `2` | Gold |
| `PREMIUM_PLATINUM` | `3` | Platinum |

### Прочие параметры действий

| Константа | Значение | Описание |
|---|---|---|
| `ACTION_USER_TO_CAR` | `1` | Действие: из инвентаря в машину |
| `ACTION_CAR_TO_USER` | `2` | Действие: из машины в инвентарь |
| `ACTION_HOME` | `3` | Действие: домой |
| `ACTION_FROM_MY_TO_EXCHANGE` | `4` | Из инвентаря в обмен |
| `ACTION_FROM_EXCHANGE_TO_MY` | `5` | Из обмена в инвентарь |
| `ACTION_CLOSE_DIALOG` | `10` | Закрыть диалог |
| `ACTION_APPLY_DIALOG` | `11` | Подтвердить диалог |
| `ALPHA_IF_NOT_USED` | `0.2f` | Прозрачность неактивного предмета |
| `ALPHA_IF_USED` | `1.0f` | Прозрачность активного предмета |

---

## 4. Ключи JSON-протокола

### 4.1 GetKeys — ключи для чтения данных с сервера

Сокращённые строковые ключи (минификация трафика).

#### Строковые ключи (значение поля в JSON → смысл)

| Константа | JSON-ключ | Тип | Описание |
|---|---|---|---|
| `GET_TYPE` | `"t"` | Int | Тип пакета/события |
| `GET_STATUS` | `"s"` | Int | Статус / позиция |
| `GET_NEW_PLAYERS_STATE` | `"i"` | Int | Новое состояние игрока / тип интерфейса |
| `GET_TYPE_INTERFACE` | `"i"` | Int | Тип открытого интерфейса (то же поле) |
| `GET_POSITION_TO_SLOT` | `"i"` | Int | Позиция в слоте |
| `GET_PLAYERS_NICK` | `"n"` | String | Никнейм игрока |
| `GET_PLAYERS_NICK_WITH_EXCHANGE` | `"en"` | String | Ник игрока для обмена |
| `GET_PLAYERS_ID` | `"id"` | Int | ID игрока |
| `GET_PLAYERS_LEVEL` | `"lv"` | Int | Уровень игрока |
| `GET_PLAYERS_MONEY` | `"m"` | Int | Деньги игрока |
| `GET_OTHER_PLAYERS_MONEY` | `"gm"` | Int | Деньги другого игрока |
| `GET_THIS_WEIGHT` | `"w"` | Int | Текущий вес инвентаря |
| `GET_MAX_WEIGHT` | `"mw"` | Int | Максимальный вес |
| `GET_NEW_THIS_WEIGHT` | `"w"` | Int | Обновлённый текущий вес |
| `GET_NEW_MAX_WEIGHT` | `"nw"` | Int | Обновлённый максимальный вес |
| `GET_MAX_SIZE_INVENTORY` | `"sl"` | Int | Количество слотов инвентаря |
| `GET_NEW_SIZE_INVENTORY` | `"ns"` | Int | Новый размер инвентаря |
| `GET_VALUE` | `"s"` | Int | Значение / количество |
| `GET_VALUE_DINNER` | `"s"` | Int | Значение еды |
| `GET_ITEMS_ID` | `"ga"` | Int | ID предмета |
| `GET_PLAYERS_ITEMS_IN_INV` | `"it"` | JSONArray | Предметы в инвентаре |
| `GET_PLAYERS_ITEMS_IN_SLOT` | `"ai"` | JSONArray | Предметы в слотах |
| `GET_NUMBER_IN_SLOT` | `"nm"` | Int | Номер SIM-карты / количество |
| `GET_MESSAGE` | `"tx"` | String | Текст сообщения |
| `GET_TYPE_VIP` | `"v"` | Int | Тип VIP |

#### Числовые статусы обработки

| Константа | Значение | Описание |
|---|---|---|
| `STATUS_IS_FALSE` | `0` | Статус: ложь / неактивен |
| `STATUS_IS_TRUE` | `1` | Статус: истина / активен |
| `STATUS_FROM_APPLY_TO_EXCHANGE` | `1` | Переход к обмену |
| `STATUS_TO_DEFAULT` | `2` | Сброс к дефолту |
| `STATUS_CLEAR_INTERFACE` | `3` | Очистить интерфейс |
| `STATUS_OPEN_INVENTORY` | `4` | Открыть инвентарь |
| `STATUS_CLEAR_OTHER_PLAYERS_ITEMS` | `5` | Очистить предметы другого игрока |

---

### 4.2 PutKeys — ключи для отправки данных на сервер

| Константа | JSON-ключ | Описание |
|---|---|---|
| `PUT_TYPE` | `"t"` | Тип действия |
| `PUT_ITEMS_ID` | `"ga"` | ID предмета |
| `PUT_OLD_POSITION` | `"os"` | Старая позиция предмета |
| `PUT_NEW_POSITION` | `"s"` | Новая позиция предмета |
| `PUT_ITEMS_POSITION` | `"s"` | Позиция предмета |
| `PUT_ITEMS_VALUE` | `"s"` | Количество |
| `PUT_MONEY` | `"em"` | Сумма денег для обмена |
| `PUT_MESSAGE` | `"tx"` | Текст сообщения |

---

## 5. Структура входящих JSON-пакетов

### 5.1 Пакет открытия инвентаря (GUIUsersInventory)

Метод `getStartData(json)` разбирает **начальный пакет** при открытии инвентаря:

```json
{
  "i":  0,          // typeInterface: тип интерфейса (0=инвентарь, 1=обмен)
  "n":  "PlayerName", // никнейм игрока
  "lv": 25,         // уровень
  "id": 1234,       // ID игрока
  "w":  50,         // текущий вес
  "mw": 100,        // максимальный вес
  "s":  3,          // valueDinner (ед. еды)
  "v":  2,          // typeVIP (0=нет, 1=Silver, 2=Gold, 3=Platinum)
  "sl": 8,          // количество активных слотов (сервер шлёт +1, UI делает -1)
  "m":  5000,       // деньги игрока
  "nm": 1,          // наличие SIM-карты (0/1)
  "ps": 134,        // ID скина персонажа
  "en": "OtherNick", // никнейм игрока-партнёра по обмену (если есть)
  "it": [ ... ],   // массив предметов в инвентаре (объекты InvItems)
  "ai": [ ... ]    // массив предметов в слотах быстрого доступа
}
```

**Важная особенность:** сервер присылает `sl` = (реальное число слотов + 1), UI отнимает 1: `activeSlotsInInventory = sl - 1`.

---

### 5.2 Пакет открытия багажника/шкафа (GUICarsTrunkOrCloset)

Метод `getStartData(json)` разбирает начальный пакет:

```json
{
  "tb": 1,      // typeInterface: тип хранилища (1=багажник, и др.)
  "w":  40,     // вес игрока (thisPlayersWeight)
  "mw": 100,    // максимальный вес игрока (maxPlayersWeight)
  "sl": 5,      // слоты инвентаря игрока (slotsInInventory, UI делает -1)
  "bw": 20,     // вес хранилища (thisOtherWeight)
  "cw": 50,     // максимальный вес хранилища (maxOtherWeight)
  "sb": 4,      // слоты хранилища (slotsOther, UI делает -1)
  "nm": 1,      // количество SIM-карт
  "it": [ ... ], // предметы в инвентаре игрока
  "ai": [ ... ], // предметы в слотах игрока
  "ic": [ ... ]  // предметы в хранилище (багажнике/шкафу)
}
```

---

## 6. Типы событий (TYPE_*)

Поле `"t"` во входящем пакете определяет, какое действие выполнить. Все значения из `GetKeys`:

| Константа | Значение | Описание |
|---|---|---|
| `TYPE_OTHER_PLAYER_ADD_NEW_ITEM` | `0` | Другой игрок добавил предмет в обмен |
| `TYPE_OTHER_PLAYER_EDIT_ITEM` | `1` | Другой игрок изменил предмет |
| `TYPE_GET_OTHER_PLAYERS_MONEY` | `3` | Получить деньги другого игрока |
| `TYPE_MIGRATE_ITEM_FROM_SLOT` | `4` | Переместить предмет из слота |
| `TYPE_EXCHANGE_ITEM_FROM_INV` | `5` | Добавить предмет из инвентаря в обмен |
| `TYPE_PUT_MONEY` | `6` | Добавить деньги в обмен |
| `TYPE_CLICK_BUTTON_EXCHANGE_CANCEL` | `7` | Отмена обмена |
| `TYPE_CLICK_BUTTON_EXCHANGE` | `8` | Открыть экран обмена |
| `TYPE_CLICK_BUTTON_EXCHANGE_APPLY` | `9` | Подтвердить обмен |
| `TYPE_CLICK_BUTTON_MENU` | `10` | Кнопка «Меню» |
| `TYPE_CLICK_BUTTON_STATISTIC` | `11` | Кнопка «Статистика» |
| `TYPE_CLICK_BUTTON_DONATE` | `12` | Кнопка «Донат» |
| `TYPE_CLICK_BUTTON_MENU_USING` | `13` | Использование пункта меню |
| `TYPE_CLICK_BUTTON_BLACK_PASS` | `14` | Кнопка BLACK PASS |
| `TYPE_CLICK_BUTTON_INVENTORY` | `15` | Кнопка «Инвентарь» |
| `TYPE_CLICK_BUTTON_EXIT` | `16` | Закрыть инвентарь |
| `TYPE_GET_PLAYERS_NICK` | `17` | Получить ник игрока |
| `TYPE_EXCHANGE_ITEM_TO_INV` | `24` (0x18) | Вернуть предмет из обмена в инвентарь |
| `TYPE_CLICK_BUTTON_EXCHANGE_IN_INV` | `25` (0x19) | Кнопка «Обмен» внутри инвентаря |
| `TYPE_BOTH_PLAYERS_APPLY` | `26` (0x1a) | Оба игрока подтвердили обмен |
| `TYPE_MIGRATE_ITEM_FROM_SLOT_IN_EXCHANGE` | `27` (0x1b) | Переместить предмет из слота в контексте обмена |
| `TYPE_MIGRATE_ITEM_IN_INV` | `23` (0x17) | Переместить предмет внутри инвентаря |
| `TYPE_DELETE_ITEM` | `18` (0x12) | Удалить предмет |
| `TYPE_USE_ITEM` | `19` (0x13) | Использовать предмет |
| `TYPE_CHANGE_DINNER` | `20` (0x14) | Изменить количество еды |
| `TYPE_CHANGE_SKIN` | `33` (0x21) | Сменить скин |
| `TYPE_MIGRATE_SIM_CARD_TO_INV` | `32` (0x20) | Переместить SIM-карту в инвентарь |
| `TYPE_MESSENGER` | `31` (0x1f) | Открыть мессенджер |

---

## 7. Статусы (STATUS_*)

Поле `"s"` во входящем пакете определяет детали действия:

| Константа | Значение | Контекст применения |
|---|---|---|
| `STATUS_IS_FALSE` | `0` | Статус «выкл» / неактивно |
| `STATUS_IS_TRUE` | `1` | Статус «вкл» / активно |
| `STATUS_FROM_APPLY_TO_EXCHANGE` | `1` | Переход в режим обмена после подтверждения |
| `STATUS_TO_DEFAULT` | `2` | Сброс состояния к начальному |
| `STATUS_CLEAR_INTERFACE` | `3` | Полная очистка UI |
| `STATUS_OPEN_INVENTORY` | `4` | Команда открыть инвентарь |
| `STATUS_CLEAR_OTHER_PLAYERS_ITEMS` | `5` | Очистить предметы другого игрока на экране |

---

## 8. Исходящие JSON-пакеты (ActionsWithJSON)

Класс `ActionsWithJSON` принимает `GUIManager` и предоставляет методы отправки. Все пакеты уходят через `GUIManager.sendJsonData(channel=34, json)` или `onPacketIncoming(id, json)`.

### Методы и структуры пакетов

#### `sendPressButton(typeKey: Int)`
Нажатие кнопки навигации.
```json
{ "t": <typeKey> }
```

#### `sendPositionToServer(typeKey: Int, positionInSlot: Int)`
Отправить позицию предмета (например, при использовании).
```json
{ "t": <typeKey>, "s": <positionInSlot> }
```

#### `sendIdWithOldAndNewPositionsToServer(typeKey, idItem, oldPosition, newPosition)`
Перемещение предмета (без изменения количества).
```json
{
  "t":  <typeKey>,
  "ga": <idItem>,
  "os": <oldPosition>,
  "s":  <newPosition>
}
```

#### `sendIdWithOldAndNewPositionsAndValueToServer(typeKey, idItem, oldPosition, newPosition, value)`
Перемещение предмета с количеством (например, в багажник).
```json
{
  "t":  <typeKey>,
  "ga": <idItem>,
  "os": <oldPosition>,
  "ns": <newPosition>,
  "v":  <value>
}
```

#### `sendMessageError(message: String)`
Отправить сообщение об ошибке (локально через `onPacketIncoming`).
```json
{
  "o": 1,
  "t": 2,
  "d": 2,
  "i": "<message>",
  "s": -1
}
```

#### `openRadialMenu()`
Открыть радиальное меню действий (локально через `onPacketIncoming`, channel=14).
```json
{ "o": 1 }
```

---

## 9. Главные UI-классы

### 9.1 GUIUsersInventory

Главный контроллер инвентаря. Реализует интерфейс GUIManager-совместимого объекта.

**Поля состояния:**

| Поле | Тип | Описание |
|---|---|---|
| `typeInterface` | Int | Текущий режим (0=инвентарь, 1=обмен) |
| `playersNick` | String | Ник игрока |
| `playersNickWithExchange` | String | Ник партнёра по обмену |
| `playersId` | Int | ID игрока |
| `playersLevel` | Int | Уровень |
| `playersMoney` | Int | Деньги |
| `thisWeight` | Int | Текущий вес |
| `maxWeight` | Int | Максимальный вес |
| `typeVIP` | Int | Уровень VIP |
| `valueDinner` | Int | Значение еды |
| `activeSlotsInInventory` | Int | Активные слоты (= sl-1) |
| `ifHaveSimCard` | Int | Наличие SIM-карты |
| `playersSkin` | Int | ID скина |
| `playersItems` | List | Предметы в инвентаре |
| `playersItemsInSlot` | List | Предметы в слотах |

**Ключевые методы:**

- `onPacketIncoming(json)` — главный роутер входящих пакетов. Читает `"t"` и `"s"`, диспетчеризует обработку.
- `getStartData(json)` — разбор начального пакета (описан в п. 5.1).
- `addDataForInventory()` — обновить UI инвентаря данными из полей.
- `addDataForExchange()` — обновить UI обмена.
- `show(manager, activity)` — отобразить GUI.
- `close()` — закрыть GUI.
- `migrateDataFromAnyToObject(items, newList, ifSlot)` — конвертировать сырые JSON-данные в объекты.
- `sendPressButton(valueMoney)` — обёртка для отправки кнопки с деньгами.

---

### 9.2 GUICarsTrunkOrCloset

GUI для взаимодействия с внешним хранилищем.

**Поля состояния:**

| Поле | Тип | Описание |
|---|---|---|
| `typeInterface` | Int | Тип хранилища (из `"tb"`) |
| `thisPlayersWeight` | Int | Вес игрока |
| `maxPlayersWeight` | Int | Макс. вес игрока |
| `slotsInInventory` | Int | Слоты инвентаря игрока (sl-1) |
| `thisOtherWeight` | Int | Текущий вес хранилища |
| `maxOtherWeight` | Int | Макс. вес хранилища |
| `slotsOther` | Int | Слоты хранилища (sb-1) |
| `simCardsNumber` | Int | Кол-во SIM-карт |
| `playersItemsInInventoryAny` | List | Предметы игрока в инвентаре |
| `playersItemsInSlotAny` | List | Предметы игрока в слотах |
| `otherItemsAny` | List | Предметы в хранилище |

**Операции перемещения:**
- `migrateDataFromUserToCar()` — переместить выбранный предмет из инвентаря игрока в хранилище.
- `migrateDataFromCarToUser()` — переместить из хранилища в инвентарь игрока.
- `migrateDataFromSlotToUser()` — переместить из слота быстрого доступа в инвентарь.

---

### 9.3 UILayoutUsersInventory

View-слой основного экрана инвентаря.

**Функциональность:**
- Отображение сетки предметов (`inventoryItemsAdapter`).
- Отображение слотов быстрого доступа (`itemsInSlotAdapter`).
- Перемещение предметов внутри инвентаря (`migrateDataInInv()`).
- Перемещение предметов из слота в инвентарь (`migrateDataFromSlotToInv()`).
- Перемещение предметов из инвентаря в слот (`migrateDataFromInvToSlot(position)`).
- Управление диалогом удаления (`logicForDialogDelete`).
- Обновление размера инвентаря (`updateSizeInventory(newSize)`).
- Обновление максимального веса (`setMaxWeight(value)`).
- Обновление счётчика еды (`updateValueDinner(value)`).
- Поддержка позиций обмена для координации с `UILayoutExchange`.

---

### 9.4 UILayoutExchange

View-слой экрана обмена с другим игроком.

**Адаптеры:**
- `yourItemsAndTrunkAdapter` — инвентарь текущего игрока (для выбора предметов в обмен).
- `yourExchangeItemsAndTrunkAdapter` — поле обмена текущего игрока.
- `otherPlayersItemsAndTrunkAdapter` — поле обмена другого игрока.
- `itemsInSlotAdapter` — слоты быстрого доступа.

**Состояние:**
- `statusApply` — текущий статус подтверждения обмена.
- `exchangeYourMoney` — сумма своих денег в обмене.
- `listYourItems`, `listYourExchangeItems` — списки предметов.
- `positionWithItem`, `positionWithExchangeItem`, `positionFromSlot` — выбранные позиции.

**Ключевые методы:**
- `clearInfoAboutInv()` / `clearInfoAboutExchange()` / `clearInfoAboutSlot()` — сброс выделения.
- `clearCheckIfFromUserToExchange()` / `clearCheckIfFromExchangeToUser()` — снять флаги направления.
- `changeButtonAndHelpInfo(Z)` — переключить вид кнопки «Подтвердить» и подсказки.
- `startPopupWindowApply()` / `closePopupWindowApply()` — диалог финального подтверждения.
- `getAllInvParameters()`, `getInventoryParameters()`, `getOtherPlayersInvParameters()` — разметка позиций.

---

## 10. Система обмена предметами (Exchange)

Обмен предметами между двумя игроками — многошаговый процесс:

```
Игрок A                        Сервер                       Игрок B
   │                              │                              │
   │── TYPE_CLICK_BUTTON_EXCHANGE─►│                              │
   │                              │──► открыть обмен для B       │
   │◄── пакет с данными обмена ───│◄───────────────────────────── │
   │                              │                              │
   │ [перетаскивает предметы]      │                              │
   │── TYPE_EXCHANGE_ITEM_FROM_INV►│                              │
   │                              │──► TYPE_OTHER_PLAYER_ADD_NEW_ITEM ──►│
   │                              │                              │
   │── TYPE_PUT_MONEY ────────────►│                              │
   │                              │──► TYPE_GET_OTHER_PLAYERS_MONEY ───►│
   │                              │                              │
   │── TYPE_CLICK_BUTTON_EXCHANGE_APPLY ►│                        │
   │                              │──► STATUS_YOUR_APPLY ────────►│
   │                              │                              │
   │                              │◄── TYPE_CLICK_BUTTON_EXCHANGE_APPLY │
   │                              │                              │
   │◄── TYPE_BOTH_PLAYERS_APPLY ──│────────────────────────────►│
   │   (завершение обмена)        │                              │
```

**Структура пакета при добавлении предмета в обмен:**
```json
{ "t": 5, "ga": <idItem>, "os": <oldPos>, "s": <newPos> }
```

**Структура пакета при добавлении денег:**
```json
{ "t": 6, "em": <amount> }
```

**Подтверждение обмена:**
```json
{ "t": 9 }
```

---

## 11. Система перемещения предметов (Migrate)

### LogicForMigrateItemsInCar

Диалог с SeekBar для выбора количества перемещаемого предмета (при передаче в багажник/шкаф).

**Конструктор:**
```
LogicForMigrateItemsInCar(
    item: InvItems,                          // предмет для перемещения
    binding: InventoryDialogValueApplyBinding, // View-биндинг диалога
    action: Int,                              // ACTION_USER_TO_CAR или ACTION_CAR_TO_USER
    clickActionListenerFromDialogApply: Function3,
    context: NvEventQueueActivity
)
```

**Поведение:**
1. Открывается диалог `openDialogApply()`.
2. SeekBar позволяет выбрать количество от 1 до максимума предмета.
3. При подтверждении вызывается callback с выбранным количеством.
4. На сервер уходит пакет `sendIdWithOldAndNewPositionsAndValueToServer`.

### MigrateItemsFromAny

Утилитарный класс для конвертации JSON-массивов предметов.

- `migrateDataFromAnyToObject(items, newList, ifSlot)` — принимает raw List (из JSONArray) и заполняет `newList` объектами `InvItems`. `ifSlot=true` — для слотов.
- `addOtherParametersInList(newList, allItems)` — обогащает список предметов дополнительными параметрами (например, `Bitmap` иконки).

---

## 12. Диалоги и вспомогательные классы

### LogicForDialogDelete

Диалог подтверждения удаления предмета из инвентаря.

- Связан с `UILayoutUsersInventory` и биндингом `InventoryDialogApplyDeletItemBinding`.
- Имеет 3 кнопки (OK / отмена / что-то ещё — 3 lambda-обработчика).
- `startDialogDelete()` — показать диалог.

### UIChat

Встроенный мини-чат для общения во время обмена.

**Конструктор:**
```
UIChat(dialog, messagesList, mainRoot: GUIUsersInventory, playersNickname)
```

**Методы:**
- `setStartLogic()` — инициализация (настройка адаптера и кликов).
- `updateMessage(ifMyMessage: Boolean)` — обновить список сообщений.
- `getMessageAboutExchangeItems(otherNick, ifMyMessage, item)` — сформировать сообщение о добавленном в обмен предмете.
- `closeChat()` — закрыть диалог чата.

**Отправка сообщения уходит через:**
```json
{ "t": <TYPE_MESSENGER>, "tx": "<текст>" }
```

### CustomEditText

Кастомное поле ввода для суммы денег при обмене. Реализует ограничения ввода (только числа, максимальная сумма).

---

## 13. Система обучения (GuideForInventory)

Пошаговое обучение для новых игроков — 10 шагов (`logicForHelp1()` ... `logicForHelp10()`).

**Тексты подсказок (в порядке шагов):**

1. «Это Ваш инвентарь. Выберите ячейку с документами, чтобы взаимодействовать с ними. Помните, взаимодействие происходит только с активным предметом.»
2. «Выберите кнопку 'Обмен', чтобы обмениваться товаром.»
3. «Добро пожаловать в трейд. Место, где Вы сможете обмениваться своими предметами с другими игроками.»
4. «Это - ваш инвентарь. Всё, что находится в этом поле, одновременно находится и в Вашем инвентаре. Если вы желаете что-то отдать игроку - используйте предметы именно из инвентаря.»
5. «Это поле трейда (обмена) - место, в которое игроки кладут предметы для обмена. Именно здесь отображаются предметы, которые Вы отдадите и получите в результате обмена.»
6. «Выберите документы и положите их в поле для обмена.»
7. «Нажмите смену просмотра поля обмена. Изменив поле, Вы сможете узнать, что получите Вы в результате обмена.»
8. «Теперь Вы просматриваете то, что отдает Вам Тетя Лена. Тетя Лена дает Вам канистру, возможно она пригодится.»
9. «Нажмите кнопку 'Обменяться', чтобы предложить обмен.»
10. «При обмене с реальным игроком убедитесь, что Вас устраивают переданные предметы. Перепроверьте что отдает игрок и что отдаете Вы. После - подтвердите обмен, нажав кнопку 'Подтвердить'.»

**Методы:**
- `getHelp(helpsNumber)` — получить состояние определённого шага.
- `setClosedState(state)` — отметить шаг как завершённый.
- `visibleHelp(isVisible)` — показать/скрыть подсказку.

---

## 14. Глобальное состояние (GlobalValue)

Singleton `GlobalValue` содержит единственное поле:

| Поле | Тип | Описание |
|---|---|---|
| `globalStatusBlocker` | Boolean | Блокирует повторные нажатия/действия во время обработки сетевого запроса |

Используется для предотвращения двойных запросов (например, двойного нажатия кнопки «Подтвердить» обмен).

---

## 15. Типовые сценарии взаимодействия

### Сценарий 1: Открытие инвентаря

```
Сервер → onPacketIncoming(json) где json содержит полный пакет п.5.1
  → getStartData(json) — разбор параметров
  → addDataForInventory() — обновление UI инвентаря
  → addDataForExchange() — обновление UI обмена (если нужно)
  → show() — отобразить GUI
```

### Сценарий 2: Перемещение предмета внутри инвентаря

```
Пользователь перетаскивает предмет
  → UILayoutUsersInventory.onItemsClickListener(item, position)
  → [выбор первого предмета] → сохранение positionInInventory
  → [выбор второго предмета] → migrateDataInInv()
  → ActionsWithJSON.sendIdWithOldAndNewPositionsToServer(
      TYPE_MIGRATE_ITEM_IN_INV, idItem, oldPos, newPos)
  → Сервер → подтверждение
```

### Сценарий 3: Перемещение предмета в багажник авто

```
Пользователь нажимает предмет в инвентаре
  → LogicForMigrateItemsInCar создаётся с ACTION_USER_TO_CAR
  → openDialogApply() — диалог с SeekBar
  → Пользователь выбирает количество и подтверждает
  → ActionsWithJSON.sendIdWithOldAndNewPositionsAndValueToServer(
      TYPE_MIGRATE_ITEM_FROM_SLOT, idItem, oldPos, newPos, value)
```

### Сценарий 4: Удаление предмета

```
Пользователь нажимает «Удалить» на предмете
  → LogicForDialogDelete.startDialogDelete()
  → Пользователь подтверждает
  → ActionsWithJSON.sendPositionToServer(TYPE_DELETE_ITEM, position)
  → UILayoutUsersInventory.deleteItemAndUpdateView()
```

### Сценарий 5: Завершение обмена

```
Оба игрока добавили предметы
  → Игрок A: sendPressButton(TYPE_CLICK_BUTTON_EXCHANGE_APPLY)
  → Сервер: STATUS_YOUR_APPLY_EXCHANGE → обновить UI кнопки
  → Игрок B: аналогично
  → Сервер: TYPE_BOTH_PLAYERS_APPLY → finalise exchange
  → UI: очистить все поля обмена, закрыть интерфейс
```

---

*Документация составлена на основе анализа Smali-байткода (декомпилированного Kotlin-кода) модуля `com.rockstargames.gtacr.gui.inventory`.*
