-- Выполнить один раз на базе данных сервера перед запуском обновлённого гейммода.
-- Хранит купленные детали стайлинга/шиномонтажа (выхлопы, гидравлика, пневма, диски,
-- посадка/collapse и т.д.), которые раньше не сохранялись в БД.

CREATE TABLE IF NOT EXISTS `vehicle_tuning_parts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `car_id` INT NOT NULL,
  `part_type` INT NOT NULL,
  `part_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `car_part` (`car_id`,`part_type`,`part_id`),
  KEY `car_id` (`car_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Колонка `vinilcar` в ownable_cars уже существует и используется (см. код),
-- но проверьте на всякий случай:
-- ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `vinilcar` INT NOT NULL DEFAULT 0;
