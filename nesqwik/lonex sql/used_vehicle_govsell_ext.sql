-- Русифицированный патч /sellcar: пробег, износ и страховка личного авто.
-- Названия колонок оставлены английскими, потому что они используются в Pawn-коде.

ALTER TABLE `ownable_cars`
    ADD COLUMN `car_wear` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    ADD COLUMN `insurance_until` INT NOT NULL DEFAULT 0,
    ADD COLUMN `insurance_claims` SMALLINT UNSIGNED NOT NULL DEFAULT 0;
