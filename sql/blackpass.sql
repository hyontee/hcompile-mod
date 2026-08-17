-- Black Pass SQL
-- Заливать в базу мода, где таблица игроков называется `players`.

CREATE TABLE IF NOT EXISTS `black_pass` (
  `user_id` INT NOT NULL,
  `exp` INT DEFAULT 0,
  `level` INT DEFAULT 0,
  `premium` INT DEFAULT 0,
  `total_points` INT DEFAULT 0,
  `rewards_bitmap0` INT DEFAULT 0,
  `rewards_bitmap1` INT DEFAULT 0,
  `rewards_bitmap2` INT DEFAULT 0,
  `rewards_bitmap3` INT DEFAULT 0,
  `rewards_bitmap4` INT DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `black_pass_top` (
  `user_id` INT NOT NULL,
  `total_points` INT DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bp_reward_sync` (
  `user_id` INT NOT NULL,
  `level` INT NOT NULL,
  `premium` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`,`level`,`premium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `premium` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `total_points` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap0` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap1` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap2` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap3` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap4` INT DEFAULT 0;

INSERT INTO `black_pass_top` (`user_id`, `total_points`)
SELECT `id`, 0 FROM `players`
ON DUPLICATE KEY UPDATE `total_points` = `total_points`;
