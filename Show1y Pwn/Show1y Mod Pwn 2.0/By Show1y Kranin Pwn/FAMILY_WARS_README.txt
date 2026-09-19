FAMILY WARS — интеграция в Show1y Mod Pwn 2.0

Добавлено:
- семейные войны 2 семей;
- регистрация игроков;
- счёт по убийствам;
- таймер войны и автоматическое завершение;
- награды победителям/участникам;
- рейтинг и история;
- семейные контейнеры;
- SQL-таблицы.

Команды:
 /fwcreate [family1] [family2] [через минут] [длительность сек] [цель киллов]
 /fwarreg [ID]
 /fwarunreg [ID]
 /fwars
 /fwrating
 /fwarhistory
 /fcontainers
 /fcontaineropen [1-3]

ВАЖНО:
Мод из загруженного архива был шаблоном, поэтому в нём не было готового подключения MySQL и реальной системы семей.
Перед запуском нужно подключить ваш g_SQL и заменить адаптеры в family_wars.inc:
FW_GetAccountID, FW_GetFamilyID, FW_IsFamilyLeader, FW_AddFamilyBalance, FW_GetFamilyName.
SQL находится в scriptfiles/family_wars.sql.

Командный процессор pawncmd не используется: команды обработаны через OnPlayerCommandText.
