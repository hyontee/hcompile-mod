// ============================================================================
// Система Таксопарков (Таксопарк) - Полный готовый код
// ============================================================================

#define TAKSI_TYPE_YANDEX 1
#define TAKSI_TYPE_BLACK  2
#define TAKSI_TYPE_GETT   3

#define TAKSI_VW_YANDEX 2
#define TAKSI_VW_BLACK  3
#define TAKSI_VW_GETT   4

#define TAKSI_INTERIOR 1

// Координаты интерьера таксопарка (внутри)
#define TAKSI_ENTER_X -0.264573
#define TAKSI_ENTER_Y 2501.775390
#define TAKSI_ENTER_Z 2011.005126
#define TAKSI_ENTER_A 5.905346

#define TAKSI_EMPLOY_X -2.776844
#define TAKSI_EMPLOY_Y 2503.831054
#define TAKSI_EMPLOY_Z 2011.000000
#define TAKSI_EMPLOY_A 77.701583

#define TAKSI_JOB_X 1.967503
#define TAKSI_JOB_Y 2503.443115
#define TAKSI_JOB_Z 2011.005126
#define TAKSI_JOB_A 181.061660

#define TAKSI_EXIT_X -0.300352
#define TAKSI_EXIT_Y 2500.243652
#define TAKSI_EXIT_Z 2011.005126
#define TAKSI_EXIT_A 171.781326

// ID диалогов
#define DIALOG_TAXI_MAIN_MENU       (60100)
#define DIALOG_TAXI_COMPANY_INFO    (60101)
#define DIALOG_TAXI_COMPANY_MANAGE  (60102)
#define DIALOG_TAXI_COMPANY_UPGRADE (60103)
#define DIALOG_TAXI_EMPLOYEES_LIST  (60104)
#define DIALOG_TAXI_DRIVER_CARD     (60105)
#define DIALOG_TAXI_SAFE            (60106)
#define DIALOG_TAXI_HELP            (60107)
#define DIALOG_TAXI_LEAVE           (60108)

enum E_TAKSI_DATA {
    TAKSI_ID,
    TAKSI_TYPE,
    TAKSI_OWNER,
    TAKSI_PRICE,
    TAKSI_RENT,
    TAKSI_VW,
    TAKSI_ENTER_PICKUP,
    TAKSI_EMPLOY_PICKUP,
    TAKSI_JOB_PICKUP,
    TAKSI_EXIT_PICKUP,
    Text3D:TAKSI_LABEL
};

// Отдельные массивы для координат
new Float:gTaksiEnterX[3];
new Float:gTaksiEnterY[3];
new Float:gTaksiEnterZ[3];
new Float:gTaksiExitX[3];
new Float:gTaksiExitY[3];
new Float:gTaksiExitZ[3];

new gTaksiParks[3][E_TAKSI_DATA];
new gTaksiLoaded = 0;

// ============================================================================
// Инициализация БД и Загрузка
// ============================================================================
stock Taksi_EnsureSchema() {
    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `taxi_parks` ( \
        `id` INT(11) NOT NULL AUTO_INCREMENT, \
        `type` INT(11) NOT NULL DEFAULT 1, \
        `owner_id` INT(11) NOT NULL DEFAULT 0, \
        `price` INT(11) NOT NULL DEFAULT 0, \
        `rent_price` INT(11) NOT NULL DEFAULT 0, \
        `enter_x` FLOAT NOT NULL DEFAULT 0, \
        `enter_y` FLOAT NOT NULL DEFAULT 0, \
        `enter_z` FLOAT NOT NULL DEFAULT 0, \
        `exit_x` FLOAT NOT NULL DEFAULT 0, \
        `exit_y` FLOAT NOT NULL DEFAULT 0, \
        `exit_z` FLOAT NOT NULL DEFAULT 0, \
        PRIMARY KEY (`id`) \
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;", false);
    return 1;
}

stock Taksi_Load() {
    new Cache:result = mysql_query(mysql, "SELECT * FROM `taxi_parks`", true);
    if(cache_num_rows()) {
        new rows = cache_num_rows();
        if(rows > 3) rows = 3;
        
        for(new i = 0; i < rows; i++) {
            gTaksiParks[i][TAKSI_ID] = cache_get_field_content_int(i, "id");
            gTaksiParks[i][TAKSI_TYPE] = cache_get_field_content_int(i, "type");
            gTaksiParks[i][TAKSI_OWNER] = cache_get_field_content_int(i, "owner_id");
            gTaksiParks[i][TAKSI_PRICE] = cache_get_field_content_int(i, "price");
            gTaksiParks[i][TAKSI_RENT] = cache_get_field_content_int(i, "rent_price");
            gTaksiEnterX[i] = cache_get_field_content_float(i, "enter_x");
            gTaksiEnterY[i] = cache_get_field_content_float(i, "enter_y");
            gTaksiEnterZ[i] = cache_get_field_content_float(i, "enter_z");
            gTaksiExitX[i] = cache_get_field_content_float(i, "exit_x");
            gTaksiExitY[i] = cache_get_field_content_float(i, "exit_y");
            gTaksiExitZ[i] = cache_get_field_content_float(i, "exit_z");

            switch(gTaksiParks[i][TAKSI_TYPE]) {
                case TAKSI_TYPE_YANDEX: gTaksiParks[i][TAKSI_VW] = TAKSI_VW_YANDEX;
                case TAKSI_TYPE_BLACK: gTaksiParks[i][TAKSI_VW] = TAKSI_VW_BLACK;
                case TAKSI_TYPE_GETT: gTaksiParks[i][TAKSI_VW] = TAKSI_VW_GETT;
            }
            Taksi_CreatePickups(i);
        }
        gTaksiLoaded = rows;
    }
    cache_delete(result);
    printf("[Taksi] Загружено %d таксопарков", gTaksiLoaded);
    return 1;
}

stock Taksi_CreatePickups(id) {
    new vw = gTaksiParks[id][TAKSI_VW];
    new name[32], text[128];
    
    printf("[Taksi] Создание пикапов для таксопарка #%d (VW=%d)", id, vw);
    
    // Пикап входа (снаружи)
    gTaksiParks[id][TAKSI_ENTER_PICKUP] = CreatePickup(19134, 23, gTaksiEnterX[id], gTaksiEnterY[id], gTaksiEnterZ[id], 0);
    
    // 3D текст над пикапом входа
    switch(gTaksiParks[id][TAKSI_TYPE]) {
        case TAKSI_TYPE_YANDEX: name = "YANDEX TAXI";
        case TAKSI_TYPE_BLACK: name = "BLACK TAXI";
        case TAKSI_TYPE_GETT: name = "GETT TAXI";
    }
    format(text, sizeof text, "%s\nВход в таксопарк", name);
    gTaksiParks[id][TAKSI_LABEL] = Create3DTextLabel(text, 0xFFFF00FF, gTaksiEnterX[id], gTaksiEnterY[id], gTaksiEnterZ[id] + 0.8, 15.0, 0);
    
    // Пикапы внутри таксопарка (в виртуальном мире)
    gTaksiParks[id][TAKSI_EMPLOY_PICKUP] = CreatePickup(1239, 23, TAKSI_EMPLOY_X, TAKSI_EMPLOY_Y, TAKSI_EMPLOY_Z, vw);
    gTaksiParks[id][TAKSI_JOB_PICKUP] = CreatePickup(1239, 23, TAKSI_JOB_X, TAKSI_JOB_Y, TAKSI_JOB_Z, vw);
    gTaksiParks[id][TAKSI_EXIT_PICKUP] = CreatePickup(1318, 23, TAKSI_EXIT_X, TAKSI_EXIT_Y, TAKSI_EXIT_Z, vw);
    
    // 3D текст для пикапа трудоустройства
    Create3DTextLabel("Трудоустройство", 0xFFFF00FF, TAKSI_EMPLOY_X, TAKSI_EMPLOY_Y, TAKSI_EMPLOY_Z + 0.5, 10.0, vw);
    
    printf("[Taksi] Все пикапы для таксопарка #%d созданы успешно!", id);
    return 1;
}

// ============================================================================
// Команды
// ============================================================================
CMD:addtakso(playerid, params[]) {
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Недостаточно прав администратора.");
    
    new type, price, rent;
    if(sscanf(params, "ddd", type, price, rent)) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Используйте: /addtakso [1-3] [цена] [аренда]");
    
    if(type < 1 || type > 3) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Тип должен быть от 1 до 3 (1-Yandex, 2-Black, 3-Gett).");
    
    if(gTaksiLoaded >= 3) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Достигнут лимит таксопарков (максимум 3).");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new query[256];
    mysql_format(mysql, query, sizeof query, 
        "INSERT INTO `taxi_parks` (`type`, `owner_id`, `price`, `rent_price`, `enter_x`, `enter_y`, `enter_z`, `exit_x`, `exit_y`, `exit_z`) \
        VALUES (%d, 0, %d, %d, %f, %f, %f, %f, %f, %f)",
        type, price, rent, x, y, z, x, y, z);
    mysql_query(mysql, query, true);

    Taksi_Load();
    
    new taksi_name[32];
    switch(type) {
        case 1: taksi_name = "Yandex Taxi";
        case 2: taksi_name = "Black Taxi";
        case 3: taksi_name = "Gett Taxi";
    }
    
    new msg[128];
    format(msg, sizeof msg, "{66cc00}| {ffffff}Таксопарк '%s' успешно создан на вашей позиции!", taksi_name);
    SendClientMessage(playerid, -1, msg);
    format(msg, sizeof msg, "{ffff00}| {ffffff}Используйте {ffff00}/tsetexitpos %d{ffffff} чтобы установить координаты выхода из таксопарка", gTaksiLoaded - 1);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:tsetexitpos(playerid, params[]) {
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Недостаточно прав администратора.");
    
    new id;
    if(sscanf(params, "d", id)) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Используйте: /tsetexitpos [id таксопарка]");
    
    if(id < 0 || id >= gTaksiLoaded) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Таксопарк с таким ID не найден.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    gTaksiExitX[id] = x;
    gTaksiExitY[id] = y;
    gTaksiExitZ[id] = z;

    new query[128];
    mysql_format(mysql, query, sizeof query, 
        "UPDATE `taxi_parks` SET `exit_x`=%f, `exit_y`=%f, `exit_z`=%f WHERE `id`=%d", 
        x, y, z, gTaksiParks[id][TAKSI_ID]);
    mysql_query(mysql, query, true);

    SendClientMessage(playerid, -1, "{66cc00}| {ffffff}Позиция выхода из таксопарка успешно установлена.");
    return 1;
}

CMD:deltakso(playerid, params[]) {
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Недостаточно прав администратора.");
    
    new id;
    if(sscanf(params, "d", id)) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Используйте: /deltakso [id таксопарка]");
    
    if(id < 0 || id >= gTaksiLoaded) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Таксопарк с таким ID не найден.");

    // Удаляем пикапы
    if(gTaksiParks[id][TAKSI_ENTER_PICKUP]) DestroyPickup(gTaksiParks[id][TAKSI_ENTER_PICKUP]);
    if(gTaksiParks[id][TAKSI_EMPLOY_PICKUP]) DestroyPickup(gTaksiParks[id][TAKSI_EMPLOY_PICKUP]);
    if(gTaksiParks[id][TAKSI_JOB_PICKUP]) DestroyPickup(gTaksiParks[id][TAKSI_JOB_PICKUP]);
    if(gTaksiParks[id][TAKSI_EXIT_PICKUP]) DestroyPickup(gTaksiParks[id][TAKSI_EXIT_PICKUP]);
    if(gTaksiParks[id][TAKSI_LABEL] != Text3D:-1) Delete3DTextLabel(gTaksiParks[id][TAKSI_LABEL]);
    
    // Удаляем из БД
    new query[128];
    mysql_format(mysql, query, sizeof query, "DELETE FROM `taxi_parks` WHERE `id`=%d", gTaksiParks[id][TAKSI_ID]);
    mysql_query(mysql, query, true);
    
    // Очищаем данные в памяти
    gTaksiParks[id][TAKSI_ID] = 0;
    gTaksiParks[id][TAKSI_TYPE] = 0;
    gTaksiParks[id][TAKSI_OWNER] = 0;
    gTaksiParks[id][TAKSI_PRICE] = 0;
    gTaksiParks[id][TAKSI_RENT] = 0;
    gTaksiParks[id][TAKSI_VW] = 0;
    gTaksiParks[id][TAKSI_ENTER_PICKUP] = 0;
    gTaksiParks[id][TAKSI_EMPLOY_PICKUP] = 0;
    gTaksiParks[id][TAKSI_JOB_PICKUP] = 0;
    gTaksiParks[id][TAKSI_EXIT_PICKUP] = 0;
    gTaksiParks[id][TAKSI_LABEL] = Text3D:-1;
    gTaksiEnterX[id] = 0.0;
    gTaksiEnterY[id] = 0.0;
    gTaksiEnterZ[id] = 0.0;
    gTaksiExitX[id] = 0.0;
    gTaksiExitY[id] = 0.0;
    gTaksiExitZ[id] = 0.0;
    
    // Перезагружаем
    Taksi_Load();
    
    SendClientMessage(playerid, -1, "{66cc00}| {ffffff}Таксопарк успешно удалён.");
    return 1;
}

CMD:buytakso(playerid, params[]) {
    new id;
    if(sscanf(params, "d", id)) return SendClientMessage(playerid, -1, "Используйте: /buytakso [id]");
    if(id < 0 || id >= gTaksiLoaded) return SendClientMessage(playerid, -1, "Таксопарк не найден.");
    if(gTaksiParks[id][TAKSI_OWNER] != 0) return SendClientMessage(playerid, -1, "Этот таксопарк уже куплен.");
    if(GetPlayerMoneyEx(playerid) < gTaksiParks[id][TAKSI_PRICE]) return SendClientMessage(playerid, -1, "Недостаточно денег.");

    GivePlayerMoneyEx(playerid, -gTaksiParks[id][TAKSI_PRICE], "Покупка таксопарка");
    gTaksiParks[id][TAKSI_OWNER] = GetPlayerAccountID(playerid);

    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE `taxi_parks` SET `owner_id`=%d WHERE `id`=%d", GetPlayerAccountID(playerid), gTaksiParks[id][TAKSI_ID]);
    mysql_query(mysql, query, true);

    SendClientMessage(playerid, -1, "{66cc00}| {ffffff}Вы успешно купили таксопарк.");
    return 1;
}

CMD:selltakso(playerid, params[]) {
    new id;
    if(sscanf(params, "d", id)) return SendClientMessage(playerid, -1, "Используйте: /selltakso [id]");
    if(id < 0 || id >= gTaksiLoaded) return SendClientMessage(playerid, -1, "Таксопарк не найден.");
    if(gTaksiParks[id][TAKSI_OWNER] != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, -1, "Это не ваш таксопарк.");

    new sell_price = gTaksiParks[id][TAKSI_PRICE] / 2; 
    GivePlayerMoneyEx(playerid, sell_price, "Продажа таксопарка");
    gTaksiParks[id][TAKSI_OWNER] = 0;

    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE `taxi_parks` SET `owner_id`=0 WHERE `id`=%d", gTaksiParks[id][TAKSI_ID]);
    mysql_query(mysql, query, true);

    SendClientMessage(playerid, -1, "{66cc00}| {ffffff}Вы успешно продали таксопарк.");
    return 1;
}

// ============================================================================
// Главное меню таксопарка /tmenu
// ============================================================================
CMD:tmenu(playerid, params[]) {
    if(GetPlayerJob(playerid) != 6) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не работаете таксистом!");
    
    new taksi_id = GetPVarInt(playerid, "taksi_park_id");
    if(taksi_id < 0 || taksi_id >= gTaksiLoaded)
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не устроены в таксопарк!");
    
    new dialog_text[1024];
    format(dialog_text, sizeof dialog_text,
        "{FF8A8A}##\t{FF8A8A}\tНазвание{FF8A8A}\tДоступное действие\n"\
        "{FF8A8A}#1\t{FFFFFF}Информация о компании\t{808080} Нажмите для взаимодействия\n"\
        "{FF8A8A}#2\t{FFFFFF}Управление Компанией\t{808080} Нажмите для взаимодействия\n"\
        "{FF8A8A}#3\t{FFFFFF}Улучшение компании\t{808080} Нажмите для взаимодействия\n"\
        "{FF8A8A}#4\t{FFFFFF}Список сотрудников компании\t{808080} Нажмите для взаимодействия\n"\
        "{FF8A8A}#5\t{FFFFFF}Личная карточка таксиста\t{808080} Нажмите для взаимодействия\n"\
        "{FF8A8A}#6\t{FFFFFF}Сейф\t{808080} Нажмите для взаимодействия\n"\
        "{FF8A8A}#7\t{FFFFFF}Помощь по компании\t{808080} Нажмите для взаимодействия\n"\
        "{FF8A8A}#8\t{FFFF00}Покинуть компанию\t{808080} Нажмите для взаимодействия");
    
    Dialog(playerid, DIALOG_TAXI_MAIN_MENU, DIALOG_STYLE_TABLIST_HEADERS, 
        "{FF5A5A}USUPOVRP {FFFFFF}| Управление таксопарком", 
        dialog_text, "Далее", "Закрыть");
    
    return 1;
}

// ============================================================================
// Внутренний чат таксопарка /tc
// ============================================================================
CMD:tc(playerid, params[]) {
    if(GetPlayerJob(playerid) != 6) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не работаете таксистом!");
    
    if(!strlen(params)) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}/tc [текст]");
    
    new taksi_id = GetPVarInt(playerid, "taksi_park_id");
    if(taksi_id < 0 || taksi_id >= gTaksiLoaded)
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не устроены в таксопарк!");
    
    new taksi_name[32];
    switch(gTaksiParks[taksi_id][TAKSI_TYPE]) {
        case TAKSI_TYPE_YANDEX: taksi_name = "Yandex Taxi";
        case TAKSI_TYPE_BLACK: taksi_name = "Black Taxi";
        case TAKSI_TYPE_GETT: taksi_name = "Gett Taxi";
    }
    
    new fmt_msg[256];
    format(fmt_msg, sizeof fmt_msg, "{FF5A5A}[Рация %s] {FFFFFF}%s: %s", taksi_name, GetPlayerNameEx(playerid), params);
    
    foreach(new i : Player) {
        if(!IsPlayerConnected(i)) continue;
        if(GetPlayerJob(i) != 6) continue;
        if(GetPVarInt(i, "taksi_park_id") != taksi_id) continue;
        SendClientMessage(i, -1, fmt_msg);
    }
    
    return 1;
}

// ============================================================================
// Список заказов /tord
// ============================================================================
CMD:tord(playerid, params[]) {
    if(GetPlayerJob(playerid) != 6) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не работаете таксистом!");
    
    SendClientMessage(playerid, -1, "{FF5A5A}[Заказы] {FFFFFF}Система заказов находится в разработке!");
    return 1;
}

// ============================================================================
// Покинуть компанию /tleave
// ============================================================================
CMD:tleave(playerid, params[]) {
    if(GetPlayerJob(playerid) != 6) 
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы не работаете таксистом!");
    
    Dialog(playerid, DIALOG_TAXI_LEAVE, DIALOG_STYLE_MSGBOX, 
        "{FF5A5A}USUPOVRP {FFFFFF}| Покинуть компанию", 
        "Вы уверены, что хотите покинуть таксопарк?\n\nПосле выхода вы потеряете все свои достижения в компании.", 
        "Да, покинуть", "Отмена");
    
    return 1;
}

CMD:thelp(playerid, params[]) {
    SendClientMessage(playerid, 0xFFFF00FF, "=== Информация по работе таксиста ===");
    SendClientMessage(playerid, -1, "1. Устройтесь в таксопарк (пикап трудоустройства).");
    SendClientMessage(playerid, -1, "2. Подойдите к пикапу 'Задания' для получения заказа.");
    SendClientMessage(playerid, -1, "3. Выполняйте заказы и получайте зарплату.");
    return 1;
}

// ============================================================================
// Public функции для вызова из new.pwn
// ============================================================================
public OnPlayerPickUpTaksoPickup(playerid, pickupid) {
    for(new i = 0; i < gTaksiLoaded; i++) {
        // Пикап входа (снаружи)
        if(pickupid == gTaksiParks[i][TAKSI_ENTER_PICKUP]) {
            SetPlayerPosEx(playerid, TAKSI_ENTER_X, TAKSI_ENTER_Y, TAKSI_ENTER_Z, TAKSI_ENTER_A, TAKSI_INTERIOR, gTaksiParks[i][TAKSI_VW]);
            return 1;
        }
        // Пикап трудоустройства
        if(pickupid == gTaksiParks[i][TAKSI_EMPLOY_PICKUP]) {
            // Проверка: работает ли уже таксистом
            if(GetPlayerJob(playerid) == 6) {
                SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы уже работаете таксистом!");
                return 1;
            }
            
            new name[32];
            switch(gTaksiParks[i][TAKSI_TYPE]) {
                case TAKSI_TYPE_YANDEX: name = "Yandex Taxi";
                case TAKSI_TYPE_BLACK: name = "Black Taxi";
                case TAKSI_TYPE_GETT: name = "Gett Taxi";
            }
            new str[128];
            format(str, sizeof str, "Вы хотите устроится на работу таксиста в таксопарк: {FFFF00}%s", name);
            Dialog(playerid, 60000 + i, DIALOG_STYLE_MSGBOX, "Трудоустройство", str, "Устроиться", "Отмена");
            return 1;
        }
        // Пикап заданий
        if(pickupid == gTaksiParks[i][TAKSI_JOB_PICKUP]) {
            SendClientMessage(playerid, -1, "{66cc00}| {ffffff}Здесь будут выдаваться задания (в разработке).");
            return 1;
        }
        // Пикап выхода
        if(pickupid == gTaksiParks[i][TAKSI_EXIT_PICKUP]) {
            SetPlayerPosEx(playerid, gTaksiExitX[i], gTaksiExitY[i], gTaksiExitZ[i], 0.0, 0, 0);
            return 1;
        }
    }
    return 0;
}

public OnTaksoDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    // Диалог трудоустройства
    if(dialogid >= 60000 && dialogid < 60000 + gTaksiLoaded) {
        if(response) {
            // Проверка: работает ли уже таксистом
            if(GetPlayerJob(playerid) == 6) {
                SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы уже работаете таксистом!");
                return 1;
            }
            
            new taksi_id = dialogid - 60000;
            SetPVarInt(playerid, "taksi_park_id", taksi_id);
            SetPlayerData(playerid, P_JOB, 6);
            
            // Запись в базу данных
            new query[128];
            mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `job`=6 WHERE `id`=%d", GetPlayerAccountID(playerid));
            mysql_query(mysql, query, true);
            
            SendClientMessage(playerid, -1, "Вы трудоустроились на работу таксиста, для информации по работе используйте {FFFF00}/thelp");
        }
        return 1;
    }
    
    // Главное меню /tmenu
    if(dialogid == DIALOG_TAXI_MAIN_MENU) {
        if(!response) return 1;
        
        switch(listitem) {
            case 0: { // Информация о компании
                new taksi_id = GetPVarInt(playerid, "taksi_park_id");
                new taksi_name[32];
                switch(gTaksiParks[taksi_id][TAKSI_TYPE]) {
                    case TAKSI_TYPE_YANDEX: taksi_name = "Yandex Taxi";
                    case TAKSI_TYPE_BLACK: taksi_name = "Black Taxi";
                    case TAKSI_TYPE_GETT: taksi_name = "Gett Taxi";
                }
                
                new dialog_text[512];
                format(dialog_text, sizeof dialog_text,
                    "{FFFFFF}Название:\t\t\t{3399FF}%s\n"\
                    "{FFFFFF}Уровень компании:\t\t{3399FF}1\n"\
                    "{FFFFFF}Опыт:\t\t\t\t{3399FF}0\n"\
                    "{FFFFFF}Баланс:\t\t\t\t{3399FF}$0\n"\
                    "{FFFFFF}Сотрудников:\t\t\t{3399FF}0\n"\
                    "{FFFFFF}Уровень улучшения:\t\t{3399FF}1",
                    taksi_name);
                
                Dialog(playerid, DIALOG_TAXI_COMPANY_INFO, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Информация о компании", 
                    dialog_text, "Назад", "Закрыть");
            }
            case 1: { // Управление компанией
                Dialog(playerid, DIALOG_TAXI_COMPANY_MANAGE, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Управление компанией", 
                    "{FFFFFF}Функция находится в разработке!", 
                    "Назад", "Закрыть");
            }
            case 2: { // Улучшение компании
                Dialog(playerid, DIALOG_TAXI_COMPANY_UPGRADE, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Улучшение компании", 
                    "{FFFFFF}Функция находится в разработке!", 
                    "Назад", "Закрыть");
            }
            case 3: { // Список сотрудников
                Dialog(playerid, DIALOG_TAXI_EMPLOYEES_LIST, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Список сотрудников", 
                    "{FFFFFF}Функция находится в разработке!", 
                    "Назад", "Закрыть");
            }
            case 4: { // Личная карточка
                new taksi_id = GetPVarInt(playerid, "taksi_park_id");
                new taksi_name[32];
                switch(gTaksiParks[taksi_id][TAKSI_TYPE]) {
                    case TAKSI_TYPE_YANDEX: taksi_name = "Yandex Taxi";
                    case TAKSI_TYPE_BLACK: taksi_name = "Black Taxi";
                    case TAKSI_TYPE_GETT: taksi_name = "Gett Taxi";
                }
                
                new dialog_text[512];
                format(dialog_text, sizeof dialog_text,
                    "{FFFFFF}Имя:\t\t\t{3399FF}%s\n"\
                    "{FFFFFF}Компания:\t\t{3399FF}%s\n"\
                    "{FFFFFF}Должность:\t\t{3399FF}Таксист\n"\
                    "{FFFFFF}Статус:\t\t\t{33CC00}Активен",
                    GetPlayerNameEx(playerid),
                    taksi_name);
                
                Dialog(playerid, DIALOG_TAXI_DRIVER_CARD, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Личная карточка", 
                    dialog_text, "Назад", "Закрыть");
            }
            case 5: { // Сейф
                Dialog(playerid, DIALOG_TAXI_SAFE, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Сейф", 
                    "{FFFFFF}Функция находится в разработке!", 
                    "Назад", "Закрыть");
            }
            case 6: { // Помощь
                new dialog_text[1024];
                format(dialog_text, sizeof dialog_text,
                    "{FFFFFF}Основные команды:\n"\
                    "{3399FF}/tmenu {FFFFFF}- основное меню таксопарка\n"\
                    "{3399FF}/tc {FFFFFF}- внутренний чат (рация) сотрудников\n"\
                    "{3399FF}/tord {FFFFFF}- список доступных заказов\n"\
                    "{3399FF}/tleave {FFFFFF}- покинуть компанию\n\n"\
                    "{FFFFFF}Как заработать:\n"\
                    "{33CC00}1. {FFFFFF}Принимайте заказы от игроков\n"\
                    "{33CC00}2. {FFFFFF}Доставляйте пассажиров в указанные места\n"\
                    "{33CC00}3. {FFFFFF}Получайте оплату за каждый заказ\n"\
                    "{33CC00}4. {FFFFFF}Повышайте уровень компании");
                
                Dialog(playerid, DIALOG_TAXI_HELP, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Помощь по компании", 
                    dialog_text, "Назад", "Закрыть");
            }
            case 7: { // Покинуть компанию
                Dialog(playerid, DIALOG_TAXI_LEAVE, DIALOG_STYLE_MSGBOX, 
                    "{FF5A5A}USUPOVRP {FFFFFF}| Покинуть компанию", 
                    "Вы уверены, что хотите покинуть таксопарк?\n\nПосле выхода вы потеряете все свои достижения в компании.", 
                    "Да, покинуть", "Отмена");
            }
        }
        return 1;
    }
    
    // Подменю (кнопка "Назад")
    if(dialogid >= DIALOG_TAXI_COMPANY_INFO && dialogid <= DIALOG_TAXI_HELP) {
        if(response) {
            // Возврат в главное меню
            new dialog_text[1024];
            format(dialog_text, sizeof dialog_text,
                "{FF8A8A}##\t{FF8A8A}\tНазвание{FF8A8A}\tДоступное действие\n"\
                "{FF8A8A}#1\t{FFFFFF}Информация о компании\t{808080} Нажмите для взаимодействия\n"\
                "{FF8A8A}#2\t{FFFFFF}Управление Компанией\t{808080} Нажмите для взаимодействия\n"\
                "{FF8A8A}#3\t{FFFFFF}Улучшение компании\t{808080} Нажмите для взаимодействия\n"\
                "{FF8A8A}#4\t{FFFFFF}Список сотрудников компании\t{808080} Нажмите для взаимодействия\n"\
                "{FF8A8A}#5\t{FFFFFF}Личная карточка таксиста\t{808080} Нажмите для взаимодействия\n"\
                "{FF8A8A}#6\t{FFFFFF}Сейф\t{808080} Нажмите для взаимодействия\n"\
                "{FF8A8A}#7\t{FFFFFF}Помощь по компании\t{808080} Нажмите для взаимодействия\n"\
                "{FF8A8A}#8\t{FFFF00}Покинуть компанию\t{808080} Нажмите для взаимодействия");
            
            Dialog(playerid, DIALOG_TAXI_MAIN_MENU, DIALOG_STYLE_TABLIST_HEADERS, 
                "{FF5A5A}USUPOVRP {FFFFFF}| Управление таксопарком", 
                dialog_text, "Далее", "Закрыть");
        }
        return 1;
    }
    
    // Диалог /tleave
    if(dialogid == DIALOG_TAXI_LEAVE) {
        if(response) {
            SetPlayerData(playerid, P_JOB, 0);
            DeletePVar(playerid, "taksi_park_id");
            
            // Запись в базу данных
            new query[128];
            mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `job`=0 WHERE `id`=%d", GetPlayerAccountID(playerid));
            mysql_query(mysql, query, true);
            
            SendClientMessage(playerid, -1, "{FF5A5A}[Компания] {FFFFFF}Вы покинули таксопарк!");
        }
        return 1;
    }
    
    return 0;
}