//>> Файл: bykranin_src/systems/contnewsystem/contnewsystem_ru.inc  (47 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: CONT_NEW_LABEL_NO_BID, CONT_NEW_LABEL_BID, CONT_NEW_LABEL_TIMER, CONT_NEW_LABEL_WIN, CONT_NEW_MSG_CONTAINER_NOT_FOUND, CONT_NEW_MSG_AUCTION_CLOSED, CONT_NEW_MSG_ALREADY_LEADER
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: contnewsystem_ru.inc
#if defined _inc_contnewsystem_ru
    #endinput
#endif
#define _inc_contnewsystem_ru

new const CONT_NEW_LABEL_NO_BID[] = "{FFC700}Контейнер #%d\n\n{FFC700}Страна: {FFFFFF}%s\n{FFC700}Содержимое: {FFFFFF}%s\n{FFC700}Статус: {FFFFFF}Торги открыты\n{FFC700}Начальная ставка: {FFFFFF}%s";
new const CONT_NEW_LABEL_BID[] = "{FFC700}Контейнер #%d\n\n{FFC700}Страна: {FFFFFF}%s\n{FFC700}Содержимое: {FFFFFF}%s\n{FFC700}Статус: {FFFFFF}Активные торги\n{FFC700}Последняя ставка: {FFFFFF}%s\n{FFC700}Начальная ставка: {FFFFFF}%s\n{FFC700}Ставка сделана от: {FFFFFF}%s";
new const CONT_NEW_LABEL_TIMER[] = "{FFC700}До конца торгов: {009900}%d секунд";
new const CONT_NEW_LABEL_WIN[] = "{FFC700}Контейнер #%d\n\n{FFC700}Страна: {FFFFFF}%s\n{FFC700}Содержимое: {FFFFFF}%s\n{FFC700}Статус: {FFFFFF}Торги завершены\n{FFC700}Победная ставка: {FFFFFF}%s\n{FFC700}Начальная ставка: {FFFFFF}%s\n{FFC700}Победитель: {FFFFFF}%s";

new const CONT_NEW_MSG_CONTAINER_NOT_FOUND[] = "Контейнер не найден";
new const CONT_NEW_MSG_AUCTION_CLOSED[] = "Торги за этот контейнер уже завершены";
new const CONT_NEW_MSG_ALREADY_LEADER[] = "Вы уже лидируете в торгах за этот контейнер";
new const CONT_NEW_MSG_MIN_BID_FMT[] = "Минимальная ставка на контейнер #%d: %s";
new const CONT_NEW_MSG_NOT_ENOUGH_MONEY[] = "Недостаточно денег для ставки на контейнер";
new const CONT_NEW_MSG_REWARD_UNAVAILABLE[] = "Награда из контейнера сейчас недоступна";
new const CONT_NEW_MSG_CLOSER[] = "Подойди ближе к контейнеру";
new const CONT_NEW_MSG_REWARD_FAILED[] = "Не удалось выдать награду из контейнера";
new const CONT_NEW_MSG_CONTGUI_USAGE[] = "Используйте /contgui [id] рядом с контейнером";

new const CONT_NEW_CHAT_BID_SUCCESS[] = "Ты успешно сделал {FFC700}ставку на контейнер #%d на сумму %s";
new const CONT_NEW_CHAT_BID_OVERBID[] = "Твоя ставка за контейнер #%d {FFC700}была перебита!";
new const CONT_NEW_CHAT_BID_WIN[] = "{FFC700}Ты победил в торгах за контейнер #%d на сумму %s";
new const CONT_NEW_CHAT_BID_RESERVED[] = "Зарезервировано {FFC700}%s рублей за ставку на контейнер #%d";
new const CONT_NEW_HINT_REWARD_TAKE[] = "Ты получил %s из контейнера, проверь добычу";
new const CONT_NEW_HINT_REWARD_SELL[] = "Ты получил %s рублей за продажу %s из контейнера";

new const g_cont_new_type_names_ru[CONT_NEW_TYPE_COUNT][] =
{
    "Индия",
    "Россия",
    "Китай",
    "Германия",
    "Дубай",
    "Италия",
    "Дипломатический груз"
};

new const g_cont_new_award_type_names_ru[3][] =
{
    "Транспорт",
    "Одежда",
    "Аксессуары"
};
// END INLINED: contnewsystem_ru.inc
