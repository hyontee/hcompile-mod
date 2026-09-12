-- Migration for the reworked wound / hospital / weapon-persistence system.
-- Run this once against your existing database before starting the updated gamemode.

-- 1. New column on `accounts`: tracks a player who died and disconnected
--    BEFORE reaching the hospital (as opposed to `hospital`, which tracks a
--    player who reached the hospital but hasn't finished treatment yet).
ALTER TABLE `accounts`
    ADD COLUMN `wound_pending` TINYINT(1) NOT NULL DEFAULT 0 AFTER `hospital`;

-- 2. New table: persisted weapons/ammo. A row is written for every weapon a
--    player is carrying whenever they die, disconnect (while alive/logged in),
--    or receive a weapon via /givegun. Rows are deleted once restored to the
--    player, so a weapon naturally stops reappearing once its ammo runs out
--    in-game (an empty slot is never saved).
CREATE TABLE IF NOT EXISTS `player_weapons` (
    `id`         INT NOT NULL AUTO_INCREMENT,
    `account_id` INT NOT NULL,
    `weapon_id`  INT NOT NULL,
    `ammo`       INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
