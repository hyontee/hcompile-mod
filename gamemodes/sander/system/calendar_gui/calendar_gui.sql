CREATE TABLE IF NOT EXISTS `calendar_progress` (
  `account_id` INT NOT NULL,
  `season_id` INT NOT NULL DEFAULT 0,
  `main_mask` INT NOT NULL DEFAULT 0,
  `bonus_mask` INT NOT NULL DEFAULT 0,
  `return_main_mask` INT NOT NULL DEFAULT 0,
  `return_bonus_mask` INT NOT NULL DEFAULT 0,
  `last_claim_time` INT NOT NULL DEFAULT 0,
  `updated_at` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
