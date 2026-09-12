-- FAMILY SYSTEM DATABASE
-- This schema matches include/system/family.pwn.
-- IMPORTANT: family membership itself is stored in accounts.family_id/family_rang/family_mute/family_access.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `family` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `owner` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(32) NOT NULL DEFAULT '',
  `color` INT NOT NULL DEFAULT 0,
  `reputation` INT NOT NULL DEFAULT 0,
  `slot_veh` INT NOT NULL DEFAULT 5,
  `count_veh` INT NOT NULL DEFAULT 0,
  `count_people` INT NOT NULL DEFAULT 0,
  `status_storage` INT NOT NULL DEFAULT 0,
  `money` INT NOT NULL DEFAULT 0,
  `armour` INT NOT NULL DEFAULT 0,
  `material` INT NOT NULL DEFAULT 0,
  `heath_kit` INT NOT NULL DEFAULT 0,
  `patron` INT NOT NULL DEFAULT 0,
  `mask` INT NOT NULL DEFAULT 0,
  `lvl_storage` INT NOT NULL DEFAULT 0,
  `lvl_weapon` INT NOT NULL DEFAULT 0,
  `lvl_compound` INT NOT NULL DEFAULT 0,
  `house` INT NOT NULL DEFAULT -1,
  `rang_1` VARCHAR(64) NOT NULL DEFAULT 'Lider,0,0,0,0,0,0',
  `rang_2` VARCHAR(64) NOT NULL DEFAULT 'Zamestitel,0,0,0,0,0,0',
  `rang_3` VARCHAR(64) NOT NULL DEFAULT 'Starshiy,0,0,0,0,0,0',
  `rang_4` VARCHAR(64) NOT NULL DEFAULT 'Boez,0,0,0,0,0,0',
  `rang_5` VARCHAR(64) NOT NULL DEFAULT 'Novichok,0,0,0,0,0,0',
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `family_cars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `family_owner` int(11) NOT NULL DEFAULT 0,
  `model_id` int(11) NOT NULL DEFAULT 0,
  `color_1` int(11) NOT NULL DEFAULT 0,
  `color_2` int(11) NOT NULL DEFAULT 0,
  `pos_x` float NOT NULL DEFAULT 0,
  `pos_y` float NOT NULL DEFAULT 0,
  `pos_z` float NOT NULL DEFAULT 0,
  `angle` float NOT NULL DEFAULT 0,
  `pos_last_x` float NOT NULL DEFAULT 0,
  `pos_last_y` float NOT NULL DEFAULT 0,
  `pos_last_z` float NOT NULL DEFAULT 0,
  `angle_last` float NOT NULL DEFAULT 0,
  `create_time` int(11) NOT NULL DEFAULT 0,
  `number` varchar(32) NOT NULL DEFAULT '',
  `region` varchar(8) NOT NULL DEFAULT '',
  `number_type` int(11) NOT NULL DEFAULT 0,
  `rang` int(11) NOT NULL DEFAULT 1,
  `pt_engine` int(11) NOT NULL DEFAULT 0,
  `pt_brake` int(11) NOT NULL DEFAULT 0,
  `pt_stability` int(11) NOT NULL DEFAULT 0,
  `comfort` int(11) NOT NULL DEFAULT 0,
  `sport` int(11) NOT NULL DEFAULT 0,
  `sport_plus` int(11) NOT NULL DEFAULT 0,
  `drift` int(11) NOT NULL DEFAULT 0,
  `comfort1` int(11) NOT NULL DEFAULT 0,
  `sport1` int(11) NOT NULL DEFAULT 0,
  `drift1` int(11) NOT NULL DEFAULT 0,
  `sport_plus1` int(11) NOT NULL DEFAULT 0,
  `comfort2` int(11) NOT NULL DEFAULT 0,
  `sport2` int(11) NOT NULL DEFAULT 0,
  `drift2` int(11) NOT NULL DEFAULT 0,
  `sport_plus2` int(11) NOT NULL DEFAULT 0,
  `comfort3` int(11) NOT NULL DEFAULT 0,
  `sport3` int(11) NOT NULL DEFAULT 0,
  `drift3` int(11) NOT NULL DEFAULT 0,
  `sport_plus3` int(11) NOT NULL DEFAULT 0,
  `comfort4` int(11) NOT NULL DEFAULT 0,
  `sport4` int(11) NOT NULL DEFAULT 0,
  `drift4` int(11) NOT NULL DEFAULT 0,
  `sport_plus4` int(11) NOT NULL DEFAULT 0,
  `vinil_current` int(11) NOT NULL DEFAULT 0,
  `exhsuast_current` int(11) NOT NULL DEFAULT 0,
  `strab_current` int(11) NOT NULL DEFAULT 0,
  `EnableNeon` int(11) NOT NULL DEFAULT 0,
  `horn_current` int(11) NOT NULL DEFAULT 0,
  `horn_id` int(11) NOT NULL DEFAULT 0,
  `highlight_type` int(11) NOT NULL DEFAULT 0,
  `stroboscope_type` int(11) NOT NULL DEFAULT 0,
  `exhaust_type` int(11) NOT NULL DEFAULT 0,
  `is_hydro_active` int(11) NOT NULL DEFAULT 0,
  `is_hydro_bought` int(11) NOT NULL DEFAULT 0,
  `is_FarLight_active` int(11) NOT NULL DEFAULT 0,
  `is_FarLight_bought` int(11) NOT NULL DEFAULT 0,
  `is_pnevmo_bought` int(11) NOT NULL DEFAULT 0,
  `pnevmo_selected` int(11) NOT NULL DEFAULT 0,
  `pdvradar` int(11) NOT NULL DEFAULT 0,
  `launch` int(11) NOT NULL DEFAULT 0,
  `nitro` int(11) NOT NULL DEFAULT 0,
  `nitro_level` int(11) NOT NULL DEFAULT 0,
  `wheel_offset_ft` int(11) NOT NULL DEFAULT 0,
  `wheel_offset_rr` int(11) NOT NULL DEFAULT 0,
  `align_ft` int(11) NOT NULL DEFAULT 0,
  `align_rr` int(11) NOT NULL DEFAULT 0,
  `width_ft` int(11) NOT NULL DEFAULT 0,
  `width_rr` int(11) NOT NULL DEFAULT 0,
  `wheel_radius` int(11) NOT NULL DEFAULT 0,
  `wheel_colors` int(11) NOT NULL DEFAULT 0,
  `wheel_comp` int(11) NOT NULL DEFAULT 0,
  `lights_color` int(11) NOT NULL DEFAULT 0,
  `underlights_color` int(11) NOT NULL DEFAULT 0,
  `underlights_color_lf` int(11) NOT NULL DEFAULT 0,
  `underlights_color_rt` int(11) NOT NULL DEFAULT 0,
  `body_colors` int(11) NOT NULL DEFAULT 0,
  `tonir_ft` int(11) NOT NULL DEFAULT 0,
  `tonir_rr` int(11) NOT NULL DEFAULT 0,
  `vynil_name` int(11) NOT NULL DEFAULT 0,
  `diski` int(11) NOT NULL DEFAULT 0,
  `supercharger` int(11) NOT NULL DEFAULT 0,
  `pt_turbo` int(11) NOT NULL DEFAULT 0,
  `color_body_r` int(11) NOT NULL DEFAULT 0,
  `color_body_g` int(11) NOT NULL DEFAULT 0,
  `color_wheels` int(11) NOT NULL DEFAULT 0,
  `toner_front` int(11) NOT NULL DEFAULT 0,
  `toner_rear` int(11) NOT NULL DEFAULT 0,
  `light_color` int(11) NOT NULL DEFAULT 0,
  `neon_center` int(11) NOT NULL DEFAULT 0,
  `neon_left` int(11) NOT NULL DEFAULT 0,
  `neon_right` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `family_owner` (`family_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `family_ad` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `family` int(11) NOT NULL DEFAULT 0,
  `ad_text` varchar(184) NOT NULL DEFAULT '',
  `create_id` int(11) NOT NULL DEFAULT 0,
  `create_name` varchar(24) NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `family_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `family` int(11) NOT NULL DEFAULT 0,
  `player` int(11) NOT NULL DEFAULT 0,
  `to_player` int(11) NOT NULL DEFAULT -1,
  `text` varchar(184) NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Required columns in accounts. If your accounts table already contains these columns, DO NOT run this ALTER.
-- ALTER TABLE `accounts`
--   ADD COLUMN `family_id` INT NOT NULL DEFAULT -1,
--   ADD COLUMN `family_rang` INT NOT NULL DEFAULT 1,
--   ADD COLUMN `family_mute` INT NOT NULL DEFAULT 0,
--   ADD COLUMN `family_access` VARCHAR(24) NOT NULL DEFAULT '0,0,0,0,0,0,0';

-- Rank catalog for administration/tools. The Pawn code uses family.rang_1..rang_5 as the authoritative rank settings.
CREATE TABLE IF NOT EXISTS `family_ranks` (
  `family_id` INT NOT NULL,
  `rank_idx` TINYINT NOT NULL,
  `rank_name` VARCHAR(24) NOT NULL,
  `rights_mask` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`family_id`,`rank_idx`),
  KEY `family_id` (`family_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Optional initial rank template for a family. The actual family-specific names/rights remain in family.rang_1..rang_5.
-- INSERT INTO family_ranks (family_id, rank_idx, rank_name, rights_mask) VALUES
-- (1,0,'Lider',8191),(1,1,'Zamestitel',8079),(1,2,'Starshiy',3205),(1,3,'Boez',2176),(1,4,'Novichok',0);
