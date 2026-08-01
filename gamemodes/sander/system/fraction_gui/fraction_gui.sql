CREATE TABLE IF NOT EXISTS `fraction_gui_data` (
  `account_id` INT NOT NULL,
  `tokens` INT NOT NULL DEFAULT 0,
  `task_mask` INT NOT NULL DEFAULT 0,
  `tests_passed` INT NOT NULL DEFAULT 0,
  `reprimands` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `fraction_gui_shop_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `price` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
