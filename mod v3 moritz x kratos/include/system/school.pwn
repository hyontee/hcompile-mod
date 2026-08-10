// ================================================================
//  ШКОЛЬНАЯ СИСТЕМА — School System
//  Версия: 2.0
//  Описание: Полная система школы с рангами, уроками, журналом и БД
//  Стиль кода: как в Black Pass
// ================================================================

#if defined _SCHOOL_SYSTEM_
    #endinput
#endif
#define _SCHOOL_SYSTEM_

// ================================================================
//  КОНСТАНТЫ
// ================================================================

#define SCHOOL_COLOR                0xFFD700FF
#define MAX_RANKS                   10

#define RANK_PRACTICANT             0
#define RANK_JUNIOR_TEACHER         1
#define RANK_TEACHER                2
#define RANK_SENIOR_TEACHER         3
#define RANK_CLASS_TEACHER          4
#define RANK_HEAD_TEACHER_EDUC      5
#define RANK_HEAD_TEACHER_ACAD      6
#define RANK_DEPUTY_DIRECTOR        7
#define RANK_DIRECTOR               8
#define RANK_MINISTER               9

// ================================================================
//  ID ДИАЛОГОВ
// ================================================================

#define SCHOOL_DIALOG_MAIN          20000
#define SCHOOL_DIALOG_MEMBERS       20001
#define SCHOOL_DIALOG_JOURNAL       20002
#define SCHOOL_DIALOG_PROFILE       20003
#define SCHOOL_DIALOG_LESSON        20004
#define SCHOOL_DIALOG_HOMEWORK      20005
#define SCHOOL_DIALOG_ANNOUNCE      20006
#define SCHOOL_DIALOG_MEETING       20007
#define SCHOOL_DIALOG_RANK          20008

// ================================================================
//  СТРУКТУРА ДАННЫХ
// ================================================================

enum E_SCHOOL_INFO
{
    s_IsMember,
    s_Rank,
    s_Attendence,
    Float:s_GPA,
    s_Warnings,
    s_DetentionTime,
    s_SubjectsPassed,
    s_Skin,
    s_Homework[256],
    s_JoinedDate,
    s_LastUpdate,
    bool:s_DataLoaded
}

new SchoolInfo[MAX_PLAYERS][E_SCHOOL_INFO];
new SchoolJournal[MAX_PLAYERS][12][6];

// ================================================================
//  МАССИВЫ С НАЗВАНИЯМИ
// ================================================================

new RankNames[MAX_RANKS][32];
new RankSkins[MAX_RANKS];

// ================================================================
//  ФОРВАРДЫ
// ================================================================

forward OnPlayerSchoolDataLoaded(playerid);
forward School_LoadTop();

// ================================================================
//  ИНИЦИАЛИЗАЦИЯ
// ================================================================

stock School_Init()
{
    format(RankNames[0], 32, "Ученик-практикант");
    format(RankNames[1], 32, "Младший учитель");
    format(RankNames[2], 32, "Учитель");
    format(RankNames[3], 32, "Старший учитель");
    format(RankNames[4], 32, "Классный руководитель");
    format(RankNames[5], 32, "Завуч по воспитательной работе");
    format(RankNames[6], 32, "Завуч по учебной части");
    format(RankNames[7], 32, "Заместитель директора");
    format(RankNames[8], 32, "Директор");
    format(RankNames[9], 32, "Министр образования");

    RankSkins[0] = 190;
    RankSkins[1] = 191;
    RankSkins[2] = 192;
    RankSkins[3] = 193;
    RankSkins[4] = 194;
    RankSkins[5] = 195;
    RankSkins[6] = 196;
    RankSkins[7] = 197;
    RankSkins[8] = 198;
    RankSkins[9] = 199;

    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `school_data` (`user_id` INT PRIMARY KEY, `is_member` INT DEFAULT 0, `rank` INT DEFAULT 0, `attendence` INT DEFAULT 0, `gpa` FLOAT DEFAULT 0.0, `warnings` INT DEFAULT 0, `detention_time` INT DEFAULT 0, `subjects_passed` INT DEFAULT 0, `skin` INT DEFAULT 0, `homework` TEXT DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
    mysql_tquery(mysql, "ALTER TABLE `school_data` ADD COLUMN IF NOT EXISTS `homework` TEXT DEFAULT NULL", "", "");

    printf("[SCHOOL] Система инициализирована!");
    return 1;
}

// ================================================================
//  ЗАГРУЗКА ДАННЫХ
// ================================================================

stock School_LoadData(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT is_member, rank, attendence, gpa, warnings, detention_time, subjects_passed, skin, homework "
        "FROM `school_data` WHERE user_id = %d",
        GetPlayerAccountID(playerid)
    );
    mysql_tquery(mysql, query, "OnPlayerSchoolDataLoaded", "i", playerid);

    return 1;
}

public OnPlayerSchoolDataLoaded(playerid)
{
    new rows;
    cache_get_data(rows, mysql);

    if(rows > 0)
    {
        SchoolInfo[playerid][s_IsMember] = cache_get_field_content_int(0, "is_member", mysql);
        SchoolInfo[playerid][s_Rank] = cache_get_field_content_int(0, "rank", mysql);
        SchoolInfo[playerid][s_Attendence] = cache_get_field_content_int(0, "attendence", mysql);
        SchoolInfo[playerid][s_GPA] = cache_get_field_content_float(0, "gpa", mysql);
        SchoolInfo[playerid][s_Warnings] = cache_get_field_content_int(0, "warnings", mysql);
        SchoolInfo[playerid][s_DetentionTime] = cache_get_field_content_int(0, "detention_time", mysql);
        SchoolInfo[playerid][s_SubjectsPassed] = cache_get_field_content_int(0, "subjects_passed", mysql);
        SchoolInfo[playerid][s_Skin] = cache_get_field_content_int(0, "skin", mysql);
        cache_get_field_content(0, "homework", SchoolInfo[playerid][s_Homework], mysql, 256);

        SchoolInfo[playerid][s_DataLoaded] = true;

        for(new i = 0; i < 12; i++) {
            for(new j = 0; j < 6; j++) {
                SchoolJournal[playerid][i][j] = 0;
            }
        }

        printf("[SCHOOL] Данные загружены для игрока %d", playerid);
    }
    else
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO `school_data` (user_id, is_member, rank) VALUES (%d, 0, 0)",
            GetPlayerAccountID(playerid)
        );
        mysql_tquery(mysql, query, "", "");

        SchoolInfo[playerid][s_IsMember] = 0;
        SchoolInfo[playerid][s_Rank] = 0;
        SchoolInfo[playerid][s_Attendence] = 0;
        SchoolInfo[playerid][s_GPA] = 0.0;
        SchoolInfo[playerid][s_Warnings] = 0;
        SchoolInfo[playerid][s_DetentionTime] = 0;
        SchoolInfo[playerid][s_SubjectsPassed] = 0;
        SchoolInfo[playerid][s_Skin] = 0;
        format(SchoolInfo[playerid][s_Homework], 256, "Нет задания");
        SchoolInfo[playerid][s_DataLoaded] = true;

        printf("[SCHOOL] Создана новая запись для игрока %d", playerid);
    }

    return 1;
}

// ================================================================
//  СОХРАНЕНИЕ ДАННЫХ
// ================================================================

stock School_SaveData(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!SchoolInfo[playerid][s_DataLoaded]) return 0;

    new escaped_homework[256];
    strmid(escaped_homework, SchoolInfo[playerid][s_Homework], 0,
        strlen(SchoolInfo[playerid][s_Homework]), 255);

    for(new i = 0; i < strlen(escaped_homework); i++) {
        if(escaped_homework[i] == '\'') {
            strins(escaped_homework, "'", i, 256);
            i++;
        }
    }

    new query[1024];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE `school_data` SET "
        "is_member = %d, "
        "rank = %d, "
        "attendence = %d, "
        "gpa = %.2f, "
        "warnings = %d, "
        "detention_time = %d, "
        "subjects_passed = %d, "
        "skin = %d, "
        "homework = '%s' "
        "WHERE user_id = %d",
        SchoolInfo[playerid][s_IsMember],
        SchoolInfo[playerid][s_Rank],
        SchoolInfo[playerid][s_Attendence],
        SchoolInfo[playerid][s_GPA],
        SchoolInfo[playerid][s_Warnings],
        SchoolInfo[playerid][s_DetentionTime],
        SchoolInfo[playerid][s_SubjectsPassed],
        SchoolInfo[playerid][s_Skin],
        escaped_homework,
        GetPlayerAccountID(playerid)
    );
    mysql_tquery(mysql, query, "", "");

    printf("[SCHOOL] Данные сохранены для игрока %d", playerid);
    return 1;
}

// ================================================================
//  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ================================================================

stock bool:School_CheckRank(playerid, rank)
{
    if(!SchoolInfo[playerid][s_IsMember]) return false;
    if(SchoolInfo[playerid][s_Rank] >= rank) return true;
    return false;
}

stock School_SendMessage(color, const msg[])
{
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && SchoolInfo[i][s_IsMember]) {
            SendClientMessage(i, color, msg);
        }
    }
}

stock School_UpdateGPA(playerid)
{
    new sum = 0, count = 0;
    for(new i = 0; i < 12; i++) {
        if(SchoolJournal[playerid][i][0] > 0) {
            sum += SchoolJournal[playerid][i][0];
            count++;
        }
    }
    SchoolInfo[playerid][s_GPA] = count > 0 ? floatdiv(sum, count) : 0.0;
    School_SaveData(playerid);
    return 1;
}

// ================================================================
//  МЕНЮ
// ================================================================

stock School_ShowMainMenu(playerid)
{
    new dialog[1024];
    new rank = SchoolInfo[playerid][s_Rank];

    strcat(dialog, "=== ШКОЛА ===\n\n");
    strcat(dialog, "1. Мой профиль\n");
    strcat(dialog, "2. Список членов\n");
    strcat(dialog, "3. Журнал\n");

    if(rank >= RANK_JUNIOR_TEACHER) {
        strcat(dialog, "4. Начать урок\n");
        strcat(dialog, "5. Поставить оценку\n");
        strcat(dialog, "6. Выдать ДЗ\n");
        strcat(dialog, "7. Отметить посещаемость\n");
        strcat(dialog, "8. Звонок\n");
    }

    if(rank >= RANK_TEACHER) {
        strcat(dialog, "9. Оставить после уроков\n");
    }

    if(rank >= RANK_HEAD_TEACHER_EDUC) {
        strcat(dialog, "10. Пригласить\n");
        strcat(dialog, "11. Исключить\n");
        strcat(dialog, "12. Собрание\n");
        strcat(dialog, "13. Объявление\n");
    }

    if(rank >= RANK_DEPUTY_DIRECTOR) {
        strcat(dialog, "14. Изменить ранг\n");
    }

    if(rank >= RANK_DIRECTOR) {
        strcat(dialog, "15. Бюджет\n");
        strcat(dialog, "16. Зарплата\n");
    }

    ShowPlayerDialog(playerid, SCHOOL_DIALOG_MAIN, DIALOG_STYLE_LIST,
        "Школа", dialog, "Выбрать", "Закрыть");
}

// ================================================================
//  КОМАНДЫ
// ================================================================

CMD:school(playerid, params[])
{
    if(!SchoolInfo[playerid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не являетесь членом школы!");
        return 1;
    }
    School_ShowMainMenu(playerid);
    return 1;
}

CMD:schoolmembers(playerid, params[])
{
    if(!SchoolInfo[playerid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не являетесь членом школы!");
        return 1;
    }

    new dialog[2048];
    strcat(dialog, "Список членов школы:\n\n");

    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && SchoolInfo[i][s_IsMember]) {
            new name[MAX_PLAYER_NAME];
            GetPlayerName(i, name, sizeof(name));
            new line[256];
            format(line, sizeof(line), "%s | %s | GPA: %.1f\n",
                name,
                RankNames[SchoolInfo[i][s_Rank]],
                SchoolInfo[i][s_GPA]);
            strcat(dialog, line);
        }
    }

    ShowPlayerDialog(playerid, SCHOOL_DIALOG_MEMBERS, DIALOG_STYLE_MSGBOX,
        "Члены школы", dialog, "Закрыть", "");
    return 1;
}

CMD:sinvite(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_HEAD_TEACHER_EDUC)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "У вас недостаточно прав!");
        return 1;
    }

    new targetid;
    if(sscanf(params, "u", targetid)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /sinvite [ID]");
        return 1;
    }

    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не найден!");
        return 1;
    }

    if(SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок уже в школе!");
        return 1;
    }

    SchoolInfo[targetid][s_IsMember] = 1;
    SchoolInfo[targetid][s_Rank] = RANK_PRACTICANT;
    SchoolInfo[targetid][s_Attendence] = 0;
    SchoolInfo[targetid][s_Warnings] = 0;
    SchoolInfo[targetid][s_DetentionTime] = 0;
    SchoolInfo[targetid][s_SubjectsPassed] = 0;
    SchoolInfo[targetid][s_GPA] = 0.0;
    format(SchoolInfo[targetid][s_Homework], 256, "Нет задания");

    School_SaveData(targetid);

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "Игрок %s был принят в школу!", name);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:suninvite(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_HEAD_TEACHER_EDUC)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "У вас недостаточно прав!");
        return 1;
    }

    new targetid;
    if(sscanf(params, "u", targetid)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /suninvite [ID]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    SchoolInfo[targetid][s_IsMember] = 0;
    SchoolInfo[targetid][s_Rank] = 0;
    School_SaveData(targetid);

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "Игрок %s был исключен из школы!", name);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:sgiverank(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_DEPUTY_DIRECTOR)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "У вас недостаточно прав!");
        return 1;
    }

    new targetid, rank;
    if(sscanf(params, "ui", targetid, rank)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /sgiverank [ID] [ранг 0-9]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    if(rank < 0 || rank >= MAX_RANKS) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Неверный ранг! (0-9)");
        return 1;
    }

    new old_rank = SchoolInfo[targetid][s_Rank];
    SchoolInfo[targetid][s_Rank] = rank;
    School_SaveData(targetid);

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "Игроку %s назначен ранг: %s (было: %s)",
        name,
        RankNames[rank],
        RankNames[old_rank]);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:fskin(playerid, params[])
{
    if(!SchoolInfo[playerid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не член школы!");
        return 1;
    }

    new rank = SchoolInfo[playerid][s_Rank];
    SetPlayerSkin(playerid, RankSkins[rank]);
    SchoolInfo[playerid][s_Skin] = RankSkins[rank];
    School_SaveData(playerid);
    SendClientMessage(playerid, SCHOOL_COLOR, "Вы надели школьную форму!");
    return 1;
}

CMD:fchat(playerid, params[])
{
    if(!SchoolInfo[playerid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не член школы!");
        return 1;
    }

    new text[128];
    if(sscanf(params, "s[128]", text)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /fchat [текст]");
        return 1;
    }

    new msg[256];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "[Школа] %s: %s", name, text);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:lesson(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_JUNIOR_TEACHER)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не учитель!");
        return 1;
    }

    new subject[32];
    if(sscanf(params, "s[32]", subject)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /lesson [тема]");
        return 1;
    }

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "[УРОК] Начался урок: %s (учитель %s)", subject, name);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:grade(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_JUNIOR_TEACHER)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не учитель!");
        return 1;
    }

    new targetid, grade;
    if(sscanf(params, "ui", targetid, grade)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /grade [ID] [1-5]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    if(grade < 1 || grade > 5) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Оценка должна быть от 1 до 5!");
        return 1;
    }

    for(new i = 0; i < 12; i++) {
        if(SchoolJournal[targetid][i][0] == 0) {
            SchoolJournal[targetid][i][0] = grade;
            break;
        }
    }

    School_UpdateGPA(targetid);

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "Ученику %s поставлена оценка %d", name, grade);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:journal(playerid, params[])
{
    if(!SchoolInfo[playerid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не член школы!");
        return 1;
    }

    new targetid;
    if(sscanf(params, "u", targetid)) {
        targetid = playerid;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    if(SchoolInfo[playerid][s_Rank] < RANK_JUNIOR_TEACHER && targetid != playerid) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы можете просматривать только свой журнал!");
        return 1;
    }

    new dialog[1024];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(dialog, sizeof(dialog), "Журнал ученика %s\nСредний балл: %.1f\nПропуски: %d\n\nОценки:\n",
        name,
        SchoolInfo[targetid][s_GPA],
        SchoolInfo[targetid][s_Attendence]);

    new count = 0;
    for(new i = 0; i < 12; i++) {
        if(SchoolJournal[targetid][i][0] > 0) {
            new line[64];
            format(line, sizeof(line), "Урок %d: %d\n", i+1, SchoolJournal[targetid][i][0]);
            strcat(dialog, line);
            count++;
        }
    }

    if(count == 0) {
        strcat(dialog, "Оценок пока нет.");
    }

    ShowPlayerDialog(playerid, SCHOOL_DIALOG_JOURNAL, DIALOG_STYLE_MSGBOX,
        "Журнал", dialog, "Закрыть", "");
    return 1;
}

CMD:homework(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_JUNIOR_TEACHER)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не учитель!");
        return 1;
    }

    new text[128];
    if(sscanf(params, "s[128]", text)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /homework [задание]");
        return 1;
    }

    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && SchoolInfo[i][s_IsMember] && SchoolInfo[i][s_Rank] == RANK_PRACTICANT) {
            format(SchoolInfo[i][s_Homework], 256, "%s", text);
            School_SaveData(i);
            count++;
        }
    }

    new msg[128];
    format(msg, sizeof(msg), "[ДЗ] Домашнее задание выдано %d ученикам: %s", count, text);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:attendance(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_JUNIOR_TEACHER)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не учитель!");
        return 1;
    }

    new targetid, status;
    if(sscanf(params, "ui", targetid, status)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /attendance [ID] [1-присутствует, 0-отсутствует]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    if(status == 0) {
        SchoolInfo[targetid][s_Attendence]++;
        if(SchoolInfo[targetid][s_Attendence] % 3 == 0) {
            new msg[128];
            new name[MAX_PLAYER_NAME];
            GetPlayerName(targetid, name, sizeof(name));
            format(msg, sizeof(msg), "[ВНИМАНИЕ] Ученик %s получил предупреждение за пропуски!", name);
            School_SendMessage(SCHOOL_COLOR, msg);
            SchoolInfo[targetid][s_Warnings]++;
        }
    }

    School_SaveData(targetid);

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "[ПОСЕЩАЕМОСТЬ] %s: %s",
        name, status ? "Присутствует" : "Отсутствует");
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:schedule(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_HEAD_TEACHER_ACAD)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "У вас недостаточно прав!");
        return 1;
    }

    SendClientMessage(playerid, SCHOOL_COLOR, "[РАСПИСАНИЕ]");
    SendClientMessage(playerid, SCHOOL_COLOR, "ПН: Математика, Русский, Литература");
    SendClientMessage(playerid, SCHOOL_COLOR, "ВТ: История, Физика, Биология");
    SendClientMessage(playerid, SCHOOL_COLOR, "СР: Математика, Русский, История");
    SendClientMessage(playerid, SCHOOL_COLOR, "ЧТ: Литература, Физика, Биология");
    SendClientMessage(playerid, SCHOOL_COLOR, "ПТ: Математика, Русский, Литература");
    return 1;
}

CMD:meeting(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_HEAD_TEACHER_EDUC)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "У вас недостаточно прав!");
        return 1;
    }

    new text[128];
    if(sscanf(params, "s[128]", text)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /meeting [текст]");
        return 1;
    }

    new msg[256];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "[СОБРАНИЕ] %s: %s", name, text);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:budget(playerid, params[])
{
    if(SchoolInfo[playerid][s_Rank] != RANK_DIRECTOR) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Только директор может смотреть бюджет!");
        return 1;
    }

    SendClientMessage(playerid, SCHOOL_COLOR, "[БЮДЖЕТ] Бюджет школы: $50,000");
    return 1;
}

CMD:salary(playerid, params[])
{
    if(SchoolInfo[playerid][s_Rank] != RANK_DIRECTOR) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Только директор может выдавать зарплату!");
        return 1;
    }

    new msg[128];
    format(msg, sizeof(msg), "[ЗАРПЛАТА] Зарплата выдана всем сотрудникам школы!");
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:announce(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_HEAD_TEACHER_EDUC)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "У вас недостаточно прав!");
        return 1;
    }

    new text[128];
    if(sscanf(params, "s[128]", text)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /announce [текст]");
        return 1;
    }

    new msg[256];
    format(msg, sizeof(msg), "[ОБЪЯВЛЕНИЕ] %s", text);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:bell(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_JUNIOR_TEACHER)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не учитель!");
        return 1;
    }

    School_SendMessage(SCHOOL_COLOR, "[ЗВОНОК] Школьный звонок прозвенел!");
    return 1;
}

CMD:detention(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_TEACHER)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Вы не учитель!");
        return 1;
    }

    new targetid, time;
    if(sscanf(params, "ui", targetid, time)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /detention [ID] [время в минутах]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    SchoolInfo[targetid][s_DetentionTime] = time;
    School_SaveData(targetid);

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "[НАКАЗАНИЕ] Ученик %s оставлен после уроков на %d минут!", name, time);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:certificate(playerid, params[])
{
    if(!School_CheckRank(playerid, RANK_CLASS_TEACHER)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "У вас недостаточно прав!");
        return 1;
    }

    new targetid;
    if(sscanf(params, "u", targetid)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /certificate [ID]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "[ГРАМОТА] Ученику %s выдана грамота за успехи!", name);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

CMD:expel(playerid, params[])
{
    if(SchoolInfo[playerid][s_Rank] != RANK_DIRECTOR) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Только директор может исключать!");
        return 1;
    }

    new targetid;
    if(sscanf(params, "u", targetid)) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Использование: /expel [ID]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !SchoolInfo[targetid][s_IsMember]) {
        SendClientMessage(playerid, SCHOOL_COLOR, "Игрок не состоит в школе!");
        return 1;
    }

    SchoolInfo[targetid][s_IsMember] = 0;
    SchoolInfo[targetid][s_Rank] = 0;
    School_SaveData(targetid);

    new msg[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    format(msg, sizeof(msg), "[ИСКЛЮЧЕНИЕ] Игрок %s исключен из школы!", name);
    School_SendMessage(SCHOOL_COLOR, msg);
    return 1;
}

// ================================================================
//  ОБРАБОТЧИК ДИАЛОГОВ
// ================================================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid >= 20000 && dialogid <= 20008)
    {
        switch(dialogid)
        {
            case SCHOOL_DIALOG_MAIN:
            {
                if(!response) return 1;

                switch(listitem)
                {
                    case 0:
                    {
                        new msg[512];
                        format(msg, sizeof(msg),
                            "=== ШКОЛЬНЫЙ ПРОФИЛЬ ===\n\n"
                            "Ранг: %s\n"
                            "Средний балл: %.1f\n"
                            "Посещаемость: %d\n"
                            "Предупреждений: %d\n"
                            "Сдано предметов: %d\n"
                            "ДЗ: %s\n"
                            "После уроков: %d мин",
                            RankNames[SchoolInfo[playerid][s_Rank]],
                            SchoolInfo[playerid][s_GPA],
                            SchoolInfo[playerid][s_Attendence],
                            SchoolInfo[playerid][s_Warnings],
                            SchoolInfo[playerid][s_SubjectsPassed],
                            SchoolInfo[playerid][s_Homework],
                            SchoolInfo[playerid][s_DetentionTime]
                        );
                        ShowPlayerDialog(playerid, SCHOOL_DIALOG_PROFILE, DIALOG_STYLE_MSGBOX,
                            "Профиль", msg, "Закрыть", "");
                    }
                    case 1:
                    {
                        cmd_schoolmembers(playerid, "");
                    }
                    case 2:
                    {
                        cmd_journal(playerid, "");
                    }
                    case 3:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_JUNIOR_TEACHER) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_LESSON, DIALOG_STYLE_INPUT,
                                "Начать урок", "Введите тему урока:", "Начать", "Отмена");
                        }
                    }
                    case 4:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_JUNIOR_TEACHER) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_RANK, DIALOG_STYLE_INPUT,
                                "Поставить оценку", "Введите: [ID] [оценка 1-5]", "Поставить", "Отмена");
                            SetPVarInt(playerid, "SchoolAction", 1);
                        }
                    }
                    case 5:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_JUNIOR_TEACHER) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_HOMEWORK, DIALOG_STYLE_INPUT,
                                "Выдать ДЗ", "Введите задание:", "Выдать", "Отмена");
                        }
                    }
                    case 6:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_JUNIOR_TEACHER) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_RANK, DIALOG_STYLE_INPUT,
                                "Отметить посещаемость", "Введите: [ID] [1-присутствует, 0-отсутствует]", "Отметить", "Отмена");
                            SetPVarInt(playerid, "SchoolAction", 2);
                        }
                    }
                    case 7:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_JUNIOR_TEACHER) {
                            cmd_bell(playerid, "");
                        }
                    }
                    case 8:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_TEACHER) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_RANK, DIALOG_STYLE_INPUT,
                                "Оставить после уроков", "Введите: [ID] [время в минутах]", "Оставить", "Отмена");
                            SetPVarInt(playerid, "SchoolAction", 3);
                        }
                    }
                    case 9:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_HEAD_TEACHER_EDUC) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_RANK, DIALOG_STYLE_INPUT,
                                "Пригласить", "Введите ID игрока:", "Пригласить", "Отмена");
                            SetPVarInt(playerid, "SchoolAction", 4);
                        }
                    }
                    case 10:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_HEAD_TEACHER_EDUC) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_RANK, DIALOG_STYLE_INPUT,
                                "Исключить", "Введите ID игрока:", "Исключить", "Отмена");
                            SetPVarInt(playerid, "SchoolAction", 5);
                        }
                    }
                    case 11:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_HEAD_TEACHER_EDUC) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_MEETING, DIALOG_STYLE_INPUT,
                                "Собрание", "Введите текст:", "Отправить", "Отмена");
                        }
                    }
                    case 12:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_HEAD_TEACHER_EDUC) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_ANNOUNCE, DIALOG_STYLE_INPUT,
                                "Объявление", "Введите текст:", "Отправить", "Отмена");
                        }
                    }
                    case 13:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_DEPUTY_DIRECTOR) {
                            ShowPlayerDialog(playerid, SCHOOL_DIALOG_RANK, DIALOG_STYLE_INPUT,
                                "Изменить ранг", "Введите: [ID] [ранг 0-9]", "Изменить", "Отмена");
                            SetPVarInt(playerid, "SchoolAction", 6);
                        }
                    }
                    case 14:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_DIRECTOR) {
                            cmd_budget(playerid, "");
                        }
                    }
                    case 15:
                    {
                        if(SchoolInfo[playerid][s_Rank] >= RANK_DIRECTOR) {
                            cmd_salary(playerid, "");
                        }
                    }
                }
            }

            case SCHOOL_DIALOG_LESSON:
            {
                if(response) {
                    new msg[128];
                    new name[MAX_PLAYER_NAME];
                    GetPlayerName(playerid, name, sizeof(name));
                    format(msg, sizeof(msg), "[УРОК] Начался урок: %s (учитель %s)", inputtext, name);
                    School_SendMessage(SCHOOL_COLOR, msg);
                }
            }

            case SCHOOL_DIALOG_HOMEWORK:
            {
                if(response) {
                    new count = 0;
                    for(new i = 0; i < MAX_PLAYERS; i++) {
                        if(IsPlayerConnected(i) && SchoolInfo[i][s_IsMember] && SchoolInfo[i][s_Rank] == RANK_PRACTICANT) {
                            format(SchoolInfo[i][s_Homework], 256, "%s", inputtext);
                            School_SaveData(i);
                            count++;
                        }
                    }
                    new msg[128];
                    format(msg, sizeof(msg), "[ДЗ] Домашнее задание выдано %d ученикам: %s", count, inputtext);
                    School_SendMessage(SCHOOL_COLOR, msg);
                }
            }

            case SCHOOL_DIALOG_ANNOUNCE:
            {
                if(response) {
                    new msg[256];
                    format(msg, sizeof(msg), "[ОБЪЯВЛЕНИЕ] %s", inputtext);
                    School_SendMessage(SCHOOL_COLOR, msg);
                }
            }

            case SCHOOL_DIALOG_MEETING:
            {
                if(response) {
                    new msg[256];
                    new name[MAX_PLAYER_NAME];
                    GetPlayerName(playerid, name, sizeof(name));
                    format(msg, sizeof(msg), "[СОБРАНИЕ] %s: %s", name, inputtext);
                    School_SendMessage(SCHOOL_COLOR, msg);
                }
            }

            case SCHOOL_DIALOG_RANK:
            {
                if(response) {
                    new targetid, value;
                    if(sscanf(inputtext, "ui", targetid, value)) {
                        SendClientMessage(playerid, SCHOOL_COLOR, "Неверный формат!");
                        return 1;
                    }

                    new action = GetPVarInt(playerid, "SchoolAction");

                    switch(action) {
                        case 1: cmd_grade(playerid, inputtext);
                        case 2: cmd_attendance(playerid, inputtext);
                        case 3: cmd_detention(playerid, inputtext);
                        case 4: cmd_sinvite(playerid, inputtext);
                        case 5: cmd_suninvite(playerid, inputtext);
                        case 6: cmd_sgiverank(playerid, inputtext);
                    }

                    DeletePVar(playerid, "SchoolAction");
                }
            }
        }
        return 1;
    }
    return 0;
}

printf("[SCHOOL] Школьная система успешно подключена!");