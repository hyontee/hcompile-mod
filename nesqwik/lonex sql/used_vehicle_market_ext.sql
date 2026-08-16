-- Used Vehicle Market + Mileage/Wear/Insurance extension
-- Apply once before launching the updated gamemode if automatic migration is disabled.

ALTER TABLE `ownable_cars`
    ADD COLUMN `used_market_price` INT NOT NULL DEFAULT 0,
    ADD COLUMN `used_market_seller` INT NOT NULL DEFAULT 0,
    ADD COLUMN `used_market_time` INT NOT NULL DEFAULT 0,
    ADD COLUMN `car_wear` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    ADD COLUMN `insurance_until` INT NOT NULL DEFAULT 0,
    ADD COLUMN `insurance_claims` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    ADD COLUMN `previous_owners` SMALLINT UNSIGNED NOT NULL DEFAULT 0;

ALTER TABLE `ownable_cars`
    ADD INDEX `idx_used_market_price` (`used_market_price`),
    ADD INDEX `idx_used_market_seller` (`used_market_seller`);
