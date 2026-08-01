CREATE TABLE IF NOT EXISTS `marketplace_lots` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `seller_id` INT NOT NULL,
  `seller_name` VARCHAR(24) NOT NULL,
  `item_id` INT NOT NULL,
  `item_count` INT NOT NULL,
  `amount` INT NOT NULL DEFAULT 1,
  `item_plate` VARCHAR(32) NOT NULL DEFAULT '',
  `item_name` VARCHAR(64) NOT NULL DEFAULT '',
  `item_type` INT NOT NULL DEFAULT 0,
  `rarity` INT NOT NULL DEFAULT 1,
  `price` INT NOT NULL,
  `is_hot` TINYINT NOT NULL DEFAULT 0,
  `status` TINYINT NOT NULL DEFAULT 0,
  `created_at` INT NOT NULL,
  `expires_at` INT NOT NULL,
  `buyer_id` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `seller_id` (`seller_id`),
  KEY `status` (`status`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `marketplace_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `lot_id` INT NOT NULL DEFAULT 0,
  `item_id` INT NOT NULL,
  `amount` INT NOT NULL DEFAULT 1,
  `price` INT NOT NULL DEFAULT 0,
  `status` TINYINT NOT NULL DEFAULT 0,
  `seller_name` VARCHAR(24) NOT NULL DEFAULT '',
  `buyer_name` VARCHAR(24) NOT NULL DEFAULT '',
  `item_name` VARCHAR(64) NOT NULL DEFAULT '',
  `created_at` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  KEY `lot_id` (`lot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `marketplace_reward_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `item_count` INT NOT NULL DEFAULT 1,
  `item_plate` VARCHAR(32) NOT NULL DEFAULT '',
  `item_name` VARCHAR(64) NOT NULL DEFAULT '',
  `source_lot` INT NOT NULL DEFAULT 0,
  `created_at` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
