-- Black Pass for Mod by Ryzen
-- Использует accounts.id как user_id.
-- Выполнить один раз в базе мода.

CREATE TABLE IF NOT EXISTS `black_pass` (
    `user_id` INT NOT NULL,
    `exp` INT NOT NULL DEFAULT 0,
    `level` INT NOT NULL DEFAULT 0,
    `premium` TINYINT NOT NULL DEFAULT 0,
    `total_points` INT NOT NULL DEFAULT 0,
    `rewards_bitmap0` INT NOT NULL DEFAULT 0,
    `rewards_bitmap1` INT NOT NULL DEFAULT 0,
    `rewards_bitmap2` INT NOT NULL DEFAULT 0,
    `rewards_bitmap3` INT NOT NULL DEFAULT 0,
    `rewards_bitmap4` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `black_pass_top` (
    `user_id` INT NOT NULL,
    `total_points` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `black_pass_top` (`user_id`, `total_points`)
SELECT `id`, 0 FROM `accounts`
ON DUPLICATE KEY UPDATE `user_id` = `user_id`;
