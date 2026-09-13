-- =====================================================================
-- Миграция БД для системы "Меню организации" (CMD:forg)
-- Выполнить один раз на боевой базе перед запуском сервера с новым кодом.
-- =====================================================================

-- Счётчик выговоров сотрудника внутри своей организации.
-- Обнуляется при увольнении (в т.ч. автоматическом при достижении 3).
ALTER TABLE `accounts`
    ADD COLUMN `org_reprimand` INT(1) NOT NULL DEFAULT 0;

-- Права рангов организаций (кто из рангов что может делать в меню).
-- org_id  -- соответствует TEAM_* (1..11)
-- rang    -- ранг 1..10
-- right_id -- индекс из enum ORG_RIGHT_* в org_menu.pwn (0..7)
-- value   -- 0/1
CREATE TABLE IF NOT EXISTS `org_rang_access` (
    `org_id`   TINYINT(2) NOT NULL,
    `rang`     TINYINT(2) NOT NULL,
    `right_id` TINYINT(2) NOT NULL,
    `value`    TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`org_id`, `rang`, `right_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
