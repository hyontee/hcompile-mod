-- BlackPass GUI Quests Upgrade: daily/weekly BP quests in the existing BlackPass GUI.
-- Run this once before starting the server, or let BlackPass_DBInit() create/update it on startup.

ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `season_id` INT DEFAULT 1;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `daily_exp` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `daily_date` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `weekly_date` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `premium` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `total_points` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap0` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap1` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap2` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap3` INT DEFAULT 0;
ALTER TABLE `black_pass` ADD COLUMN IF NOT EXISTS `rewards_bitmap4` INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS `black_pass_tasks` (
  `user_id` INT NOT NULL,
  `season_id` INT NOT NULL DEFAULT 1,
  `task_id` INT NOT NULL,
  `progress` INT NOT NULL DEFAULT 0,
  `claimed` TINYINT NOT NULL DEFAULT 0,
  `updated_date` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`, `season_id`, `task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `bp_reward_sync` (
  `user_id` INT NOT NULL,
  `level` INT NOT NULL,
  `premium` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`, `level`, `premium`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
