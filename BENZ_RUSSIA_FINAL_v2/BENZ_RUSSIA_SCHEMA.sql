-- BENZ RUSSIA / SA-MP
-- Import-ready SQL for an EXISTING hosting database.
-- IMPORTANT: select your existing database in phpMyAdmin BEFORE importing this file.
-- This file intentionally does NOT CREATE or SELECT a database, so it does not require CREATE DATABASE privilege.
-- Target database example: gs110713

-- BENZ RUSSIA / SA-MP database generated from uploaded source
-- Source: sliv mod v1.zip
-- This schema uses exact CREATE TABLE statements found in the source where available,
-- and conservative inferred schemas for core tables whose original DDL was not included.
-- Review/adjust inferred tables against your production dump before claiming 100% compatibility.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `accessories_players` (`id` INT NOT NULL AUTO_INCREMENT, `player_id` INT NOT NULL, `slot` INT NOT NULL, `bone` INT NOT NULL, `acs_id` INT NOT NULL, `x` FLOAT NOT NULL DEFAULT 0.01, `y` FLOAT NOT NULL DEFAULT 0.01, `z` FLOAT NOT NULL DEFAULT 0.01, `rX` FLOAT NOT NULL DEFAULT 0.01, `rY` FLOAT NOT NULL DEFAULT 0.01, `rZ` FLOAT NOT NULL DEFAULT 0.01, `scale` FLOAT NOT NULL DEFAULT 1.01, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `accessory_inventory` (`id` INT NOT NULL AUTO_INCREMENT, `player_id` INT NOT NULL, `acs_id` INT NOT NULL, `use` INT NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS `admin_templates` (`id` INT NOT NULL AUTO_INCREMENT,`category` INT NOT NULL DEFAULT 3,`title` VARCHAR(64) NOT NULL,`description` VARCHAR(255) NOT NULL,`time_value` INT NOT NULL DEFAULT 0,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS auction_lots (id INT NOT NULL AUTO_INCREMENT,slot_type TINYINT NOT NULL,seller_id INT NOT NULL,seller_name VARCHAR(24) NOT NULL DEFAULT '',title VARCHAR(64) NOT NULL DEFAULT '',description VARCHAR(124) NOT NULL DEFAULT '',bidder_id INT NOT NULL DEFAULT -1,start_price INT NOT NULL,current_price INT NOT NULL,expires_at INT NOT NULL,database_id INT NOT NULL DEFAULT -1,server_id INT NOT NULL DEFAULT -1,number_vehicle VARCHAR(16) NOT NULL DEFAULT '',number_sum INT NOT NULL DEFAULT 0,item_id INT NOT NULL DEFAULT 0,item_model INT NOT NULL DEFAULT 0,item_amount INT NOT NULL DEFAULT 0,item_extra1 INT NOT NULL DEFAULT 0,item_extra2 INT NOT NULL DEFAULT 0,item_old_skin INT NOT NULL DEFAULT 0,item_sim INT NOT NULL DEFAULT 0,item_oldsim INT NOT NULL DEFAULT 0,item_meta VARCHAR(40) NOT NULL DEFAULT '',status TINYINT NOT NULL DEFAULT 0,created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY(id),KEY active_idx(status,expires_at),KEY seller_idx(seller_id,status)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS auction_notifications (id INT NOT NULL AUTO_INCREMENT,account_id INT NOT NULL,lot_id INT NOT NULL DEFAULT 0,kind TINYINT NOT NULL,title VARCHAR(64) NOT NULL DEFAULT '',object_id INT NOT NULL DEFAULT 0,amount INT NOT NULL DEFAULT 0,created_at INT NOT NULL DEFAULT 0,shown TINYINT NOT NULL DEFAULT 0,PRIMARY KEY(id),KEY account_idx(account_id,shown)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS autosalon (market_id TINYINT NOT NULL,model_id INT NOT NULL,slots INT NOT NULL DEFAULT 0,PRIMARY KEY (market_id,model_id)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `blackpass_logs` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `season_number` INT NOT NULL, `action` VARCHAR(32) NOT NULL, `reward_id` INT NOT NULL DEFAULT 0, `reward_type` INT NOT NULL DEFAULT 0, `reward_value` INT NOT NULL DEFAULT 0, `amount` INT NOT NULL DEFAULT 0, `extra` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `idx_blackpass_logs_player` (`account_id`,`season_number`), KEY `idx_blackpass_logs_action` (`action`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `blackpass_players` (`account_id` INT NOT NULL, `season_number` INT NOT NULL, `experience` INT NOT NULL DEFAULT 0, `level` INT NOT NULL DEFAULT 1, `premium_status` INT NOT NULL DEFAULT 0, `dust` INT NOT NULL DEFAULT 0, `selected_layout` INT NOT NULL DEFAULT 0, `deluxe_rewards_claimed` TINYINT(1) NOT NULL DEFAULT 0, `claimed_standard` VARCHAR(80) NOT NULL DEFAULT '', `claimed_premium` VARCHAR(80) NOT NULL DEFAULT '', `created_at` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`,`season_number`), KEY `idx_blackpass_players_season` (`season_number`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `blackpass_tasks` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `season_number` INT NOT NULL, `task_id` INT NOT NULL, `task_group` INT NOT NULL, `period_key` INT NOT NULL, `target_count` INT NOT NULL DEFAULT 0, `reward_exp` INT NOT NULL DEFAULT 0, `reward_money` INT NOT NULL DEFAULT 0, `route_id` INT NOT NULL DEFAULT 0, `button_type` INT NOT NULL DEFAULT 0, `premium_only` TINYINT(1) NOT NULL DEFAULT 0, `progress` INT NOT NULL DEFAULT 0, `status` INT NOT NULL DEFAULT 0, `tracked` TINYINT(1) NOT NULL DEFAULT 0, `complete_notified` TINYINT(1) NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `idx_blackpass_tasks_player` (`account_id`,`season_number`,`task_group`,`period_key`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `calendar_event_state` (`id` TINYINT UNSIGNED NOT NULL,`total_days` SMALLINT UNSIGNED NOT NULL DEFAULT 42,`start_time` INT UNSIGNED NOT NULL,`end_time` INT UNSIGNED NOT NULL,`days_left` SMALLINT UNSIGNED NOT NULL DEFAULT 42,`last_update_date` DATE NOT NULL,`season_version` SMALLINT UNSIGNED NOT NULL DEFAULT 2,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS `calendar_user_bonus` (`account_id` INT UNSIGNED NOT NULL,`season_version` SMALLINT UNSIGNED NOT NULL,`bonus_id` TINYINT UNSIGNED NOT NULL,`claimed` TINYINT UNSIGNED NOT NULL DEFAULT 0,`updated_at` INT UNSIGNED NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`,`season_version`,`bonus_id`),KEY `idx_calendar_bonus_season` (`season_version`,`bonus_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS `calendar_user_progress` (`account_id` INT UNSIGNED NOT NULL,`season_version` SMALLINT UNSIGNED NOT NULL,`day_number` TINYINT UNSIGNED NOT NULL,`play_seconds` SMALLINT UNSIGNED NOT NULL DEFAULT 0,`claimed` TINYINT UNSIGNED NOT NULL DEFAULT 0,`updated_at` INT UNSIGNED NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`,`season_version`,`day_number`),KEY `idx_calendar_progress_season` (`season_version`,`day_number`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS `calendar_user_state` (`account_id` INT UNSIGNED NOT NULL,`season_version` SMALLINT UNSIGNED NOT NULL,`claimed_count` TINYINT UNSIGNED NOT NULL DEFAULT 0,`last_claim_at` INT UNSIGNED NOT NULL DEFAULT 0,`updated_at` INT UNSIGNED NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`,`season_version`),KEY `idx_calendar_state_season` (`season_version`,`claimed_count`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS casino_staff (account_id INT NOT NULL,business_id INT NOT NULL,owner_id INT NOT NULL,job_role TINYINT NOT NULL DEFAULT 1,hired_at INT NOT NULL DEFAULT 0,PRIMARY KEY (account_id),KEY business_id (business_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `event_calendar_players` (`account_id` INT NOT NULL, `day` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `event_dacha_players` (`account_id` INT NOT NULL, `level` INT NOT NULL DEFAULT 0, `experience` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `family` (`id` INT NOT NULL AUTO_INCREMENT,`owner` INT NOT NULL DEFAULT '0',`color` INT NOT NULL DEFAULT '0',`reputation` INT NOT NULL DEFAULT '0',`name` VARCHAR(32) NOT NULL DEFAULT '',`slot_veh` INT NOT NULL DEFAULT '5',`patron` INT NOT NULL DEFAULT '0',`material` INT NOT NULL DEFAULT '0',`heath_kit` INT NOT NULL DEFAULT '0',`armour` INT NOT NULL DEFAULT '0',`arnour_count` INT NOT NULL DEFAULT '0',`money` INT NOT NULL DEFAULT '0',`mask` INT NOT NULL DEFAULT '0',`level_storage` INT NOT NULL DEFAULT '1',`level_weapon` INT NOT NULL DEFAULT '1',`level_compound` INT NOT NULL DEFAULT '1',`house` INT NOT NULL DEFAULT '-1',`rang_1` VARCHAR(96) NOT NULL DEFAULT '1 ,0,0,0,0,0,0',`rang_2` VARCHAR(96) NOT NULL DEFAULT '2 ,0,0,0,0,0,0',`rang_3` VARCHAR(96) NOT NULL DEFAULT '3 ,0,0,0,0,0,0',`rang_4` VARCHAR(96) NOT NULL DEFAULT '4 ,0,0,0,0,0,0',`rang_5` VARCHAR(96) NOT NULL DEFAULT '5 ,1,1,1,1,1,1',PRIMARY KEY (`id`), KEY `idx_family_owner` (`owner`), UNIQUE KEY `uniq_family_name` (`name`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `family_ad` (`id` INT NOT NULL AUTO_INCREMENT,`family` INT NOT NULL DEFAULT '0',`ad_text` VARCHAR(192) NOT NULL DEFAULT '',`create_id` INT NOT NULL DEFAULT '0',`create_name` VARCHAR(24) NOT NULL DEFAULT '',`time` INT NOT NULL DEFAULT '0',PRIMARY KEY (`id`), KEY `idx_family_ad_family` (`family`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `family_cars` (`id` INT NOT NULL AUTO_INCREMENT,`family_owner` INT NOT NULL DEFAULT '0',`model_id` INT NOT NULL DEFAULT '0',`color_1` INT NOT NULL DEFAULT '0',`color_2` INT NOT NULL DEFAULT '0',`pos_x` FLOAT NOT NULL DEFAULT '0',`pos_y` FLOAT NOT NULL DEFAULT '0',`pos_z` FLOAT NOT NULL DEFAULT '0',`angle` FLOAT NOT NULL DEFAULT '0',`pos_last_x` FLOAT NOT NULL DEFAULT '0',`pos_last_y` FLOAT NOT NULL DEFAULT '0',`pos_last_z` FLOAT NOT NULL DEFAULT '0',`angle_last` FLOAT NOT NULL DEFAULT '0',`world` INT NOT NULL DEFAULT '0',`interior` INT NOT NULL DEFAULT '0',`create_time` INT NOT NULL DEFAULT '0',`number` VARCHAR(32) NOT NULL DEFAULT '',`region` VARCHAR(8) NOT NULL DEFAULT '',`number_type` INT NOT NULL DEFAULT '1',`plate_number` VARCHAR(16) NOT NULL DEFAULT '',`plate_region` VARCHAR(8) NOT NULL DEFAULT '',`plate_type` INT NOT NULL DEFAULT '1',`rang` INT NOT NULL DEFAULT '1',`vynil_name` VARCHAR(32) NOT NULL DEFAULT '',`f_state` INT NOT NULL DEFAULT '0',`nitro_level` INT NOT NULL DEFAULT '0',`launch` INT NOT NULL DEFAULT '0',`pdvradar` INT NOT NULL DEFAULT '0',`lights_color` INT NOT NULL DEFAULT '0',`underlights_color` INT NOT NULL DEFAULT '0',`underlights_color_lf` INT NOT NULL DEFAULT '0',`underlights_color_rt` INT NOT NULL DEFAULT '0',`is_FarLight_active` INT NOT NULL DEFAULT '0',`pnevmo_selected` INT NOT NULL DEFAULT '0',`percentofclirness` INT NOT NULL DEFAULT '0',`percentofclirnessZ` INT NOT NULL DEFAULT '0',`is_hydro_active` INT NOT NULL DEFAULT '0',`fuel` FLOAT NOT NULL DEFAULT '40',`health` FLOAT NOT NULL DEFAULT '1000',PRIMARY KEY (`id`), KEY `idx_family_cars_owner` (`family_owner`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `family_log` (`id` INT NOT NULL AUTO_INCREMENT,`family` INT NOT NULL DEFAULT '0',`player` INT NOT NULL DEFAULT '0',`to_player` INT NOT NULL DEFAULT '0',`text` VARCHAR(192) NOT NULL DEFAULT '',`time` INT NOT NULL DEFAULT '0',`type` INT NOT NULL DEFAULT '0',PRIMARY KEY (`id`), KEY `idx_family_log_family` (`family`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `family_storage_items` (`family_id` INT NOT NULL DEFAULT '0',`slot` INT NOT NULL DEFAULT '0',`item_id` INT NOT NULL DEFAULT '0',`amount` INT NOT NULL DEFAULT '1',`value` INT NOT NULL DEFAULT '0',`model_id` INT NOT NULL DEFAULT '0',`extra_1` INT NOT NULL DEFAULT '0',`extra_2` INT NOT NULL DEFAULT '0',`old_skin` INT NOT NULL DEFAULT '0',PRIMARY KEY (`family_id`,`slot`), KEY `idx_family_storage_family` (`family_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `familyblack` (`family_id` INT NOT NULL, `account_id` INT NOT NULL, `reason` VARCHAR(64) NOT NULL DEFAULT '', `created_at` INT NOT NULL DEFAULT '0', PRIMARY KEY (`family_id`, `account_id`), KEY `idx_familyblack_account_id` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `familysystem` (`id` INT NOT NULL AUTO_INCREMENT, `family_id` INT NOT NULL, `owner_id` INT NOT NULL, `ownable_car_id` INT NOT NULL, `model_id` INT NOT NULL, `access_rank` INT NOT NULL DEFAULT 1, `status` TINYINT NOT NULL DEFAULT 0, `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`), UNIQUE KEY `idx_family_ownable` (`family_id`,`ownable_car_id`), KEY `idx_family` (`family_id`), KEY `idx_owner` (`owner_id`), KEY `idx_ownable` (`ownable_car_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `fraction_gui_progress` (`account_id` INT NOT NULL,`docs_mask` INT NOT NULL DEFAULT 0,`test_passed` TINYINT NOT NULL DEFAULT 0,`quest_rank` INT NOT NULL DEFAULT 0,`quest_progress` INT NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `fraction_gui_stats` (`account_id` INT NOT NULL,`completed_tasks` INT NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `fraction_gui_tokens` (`account_id` INT NOT NULL,`tokens` INT NOT NULL DEFAULT 0,PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `garages` (`id` INT(11) NOT NULL, `owner_id` INT(11) NOT NULL, `price` INT(11) NOT NULL, `lock` INT(11) NOT NULL, `x` FLOAT NOT NULL, `y` FLOAT NOT NULL, `z` FLOAT NOT NULL, `exit_x` FLOAT NOT NULL, `exit_y` FLOAT NOT NULL, `exit_z` FLOAT NOT NULL, `exit_angle` FLOAT NOT NULL, `improvements` INT(11) NOT NULL DEFAULT 1) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
CREATE TABLE IF NOT EXISTS `gates` (`id` INT(11) NOT NULL AUTO_INCREMENT,`gate_type` INT NOT NULL,`gate1_x` FLOAT NOT NULL,`gate1_y` FLOAT NOT NULL,`gate1_z` FLOAT NOT NULL,`gate1_angle` FLOAT NOT NULL,`gate2_x` FLOAT NOT NULL,`gate2_y` FLOAT NOT NULL,`gate2_z` FLOAT NOT NULL,`gate2_angle` FLOAT NOT NULL,`gatezone_x` FLOAT NOT NULL,`gatezone_y` FLOAT NOT NULL,`gatezone_z` FLOAT NOT NULL,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `marketplace_favorites` (`account_id` INT NOT NULL, `lot_id` INT NOT NULL, `created_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`,`lot_id`), KEY `lot_id` (`lot_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `marketplace_history` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `lot_id` INT NOT NULL DEFAULT 0, `item_id` INT NOT NULL, `amount` INT NOT NULL DEFAULT 1, `price` INT NOT NULL DEFAULT 0, `status` TINYINT NOT NULL DEFAULT 0, `seller_name` VARCHAR(24) NOT NULL DEFAULT '', `buyer_name` VARCHAR(24) NOT NULL DEFAULT '', `item_name` VARCHAR(64) NOT NULL DEFAULT '', `created_at` INT NOT NULL, PRIMARY KEY (`id`), KEY `account_id` (`account_id`), KEY `lot_id` (`lot_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `marketplace_lots` (`id` INT NOT NULL AUTO_INCREMENT, `seller_id` INT NOT NULL, `seller_name` VARCHAR(24) NOT NULL, `item_id` INT NOT NULL, `item_count` INT NOT NULL, `amount` INT NOT NULL DEFAULT 1, `item_plate` VARCHAR(32) NOT NULL DEFAULT '', `item_name` VARCHAR(64) NOT NULL DEFAULT '', `item_type` INT NOT NULL DEFAULT 0, `rarity` INT NOT NULL DEFAULT 1, `price` INT NOT NULL, `is_hot` TINYINT NOT NULL DEFAULT 0, `status` TINYINT NOT NULL DEFAULT 0, `created_at` INT NOT NULL, `expires_at` INT NOT NULL, `buyer_id` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `seller_id` (`seller_id`), KEY `status` (`status`), KEY `item_id` (`item_id`), KEY `expires_at` (`expires_at`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `marketplace_reward_items` (`id` INT NOT NULL AUTO_INCREMENT, `account_id` INT NOT NULL, `item_id` INT NOT NULL, `item_count` INT NOT NULL DEFAULT 1, `item_plate` VARCHAR(32) NOT NULL DEFAULT '', `item_name` VARCHAR(64) NOT NULL DEFAULT '', `source_lot` INT NOT NULL DEFAULT 0, `created_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `account_id` (`account_id`), KEY `source_lot` (`source_lot`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `marketplace_wallet` (`account_id` INT NOT NULL, `balance` BIGINT NOT NULL DEFAULT 0, `updated_at` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `mhcwork` (`account_id` INT NOT NULL, `employed` TINYINT(1) NOT NULL DEFAULT 0, `experience` INT NOT NULL DEFAULT 0, `extinguisher_count` INT NOT NULL DEFAULT 0, `shovel_count` INT NOT NULL DEFAULT 0, `crowbar_count` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `music_albums` (`id` INT(11) NOT NULL AUTO_INCREMENT, `uid` INT(11) NOT NULL, `album_id` INT(11) NOT NULL, `created_at` INT(11) NOT NULL DEFAULT 0, PRIMARY KEY (`id`), UNIQUE KEY `uid_album` (`uid`, `album_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `rewards` (`id` INT NOT NULL AUTO_INCREMENT, `uid` INT NOT NULL, `award_id` INT NOT NULL, `case_id` INT NOT NULL, PRIMARY KEY (`id`), KEY `uid_idx` (`uid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `roulette_prize` ( `id` INT NOT NULL AUTO_INCREMENT , `owner` INT NOT NULL , `prize` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `tcompany_meta` (`company_id` INT NOT NULL,`points` INT NOT NULL DEFAULT 0,PRIMARY KEY (`company_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `tcompany_staff` (`company_id` INT NOT NULL,`account_id` INT NOT NULL,`player_name` VARCHAR(24) NOT NULL DEFAULT '',`joined_at` INT NOT NULL DEFAULT 0,PRIMARY KEY (`company_id`,`account_id`),UNIQUE KEY `uniq_tcompany_account` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `tcompany_vehicles` (`id` INT NOT NULL AUTO_INCREMENT,`company_id` INT NOT NULL,`model_id` INT NOT NULL,`color_1` INT NOT NULL DEFAULT 1,`color_2` INT NOT NULL DEFAULT 1,`spawn_slot` INT NOT NULL DEFAULT 0,`purchased_at` INT NOT NULL DEFAULT 0,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `trunkcar` (`id` INT NOT NULL AUTO_INCREMENT,`acc_id` INT NOT NULL,`oc_id` INT NOT NULL,`slot` INT NOT NULL,`item_id` INT NOT NULL,`amount` INT NOT NULL DEFAULT 1,`value` INT NOT NULL DEFAULT 0,PRIMARY KEY (`id`),UNIQUE KEY `acc_car_slot` (`acc_id`,`oc_id`,`slot`),KEY `car_idx` (`oc_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
CREATE TABLE IF NOT EXISTS `accessories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `modelid` INT NOT NULL DEFAULT 0,
  `slot` INT NOT NULL DEFAULT 0,
  `bone` INT NOT NULL DEFAULT 1,
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0,
  `rx` FLOAT NOT NULL DEFAULT 0,
  `ry` FLOAT NOT NULL DEFAULT 0,
  `rz` FLOAT NOT NULL DEFAULT 0,
  `scale` FLOAT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `accounts` (
  `3d_prefix` INT NOT NULL DEFAULT 0,
  `AdminPass` INT NOT NULL DEFAULT 0,
  `AntiBh` INT NOT NULL DEFAULT 0,
  `BuyCake` INT NOT NULL DEFAULT 0,
  `BuyCandle` INT NOT NULL DEFAULT 0,
  `BuyPerfume` INT NOT NULL DEFAULT 0,
  `BuyProducts` INT NOT NULL DEFAULT 0,
  `CongratulateWomen` INT NOT NULL DEFAULT 0,
  `EndQuest8marta` INT NOT NULL DEFAULT 0,
  `FracQuest1` INT NOT NULL DEFAULT 0,
  `FracQuest2` INT NOT NULL DEFAULT 0,
  `FracQuest3` INT NOT NULL DEFAULT 0,
  `FracQuest4` INT NOT NULL DEFAULT 0,
  `FracQuest5` INT NOT NULL DEFAULT 0,
  `FracQuestExp1` INT NOT NULL DEFAULT 0,
  `FracQuestExp2` INT NOT NULL DEFAULT 0,
  `FracQuestExp3` INT NOT NULL DEFAULT 0,
  `FracQuestExp4` INT NOT NULL DEFAULT 0,
  `FracQuestExp5` INT NOT NULL DEFAULT 0,
  `GivePerfume` INT NOT NULL DEFAULT 0,
  `Progress1` INT NOT NULL DEFAULT 0,
  `Progress2` INT NOT NULL DEFAULT 0,
  `Progress3` INT NOT NULL DEFAULT 0,
  `Progress4` INT NOT NULL DEFAULT 0,
  `Progress5` INT NOT NULL DEFAULT 0,
  `Progress6` INT NOT NULL DEFAULT 0,
  `ProgressExp1` INT NOT NULL DEFAULT 0,
  `ProgressExp2` INT NOT NULL DEFAULT 0,
  `ProgressExp3` INT NOT NULL DEFAULT 0,
  `ProgressExp4` INT NOT NULL DEFAULT 0,
  `ProgressExp5` INT NOT NULL DEFAULT 0,
  `ProgressExp6` INT NOT NULL DEFAULT 0,
  `QuestBox` INT NOT NULL DEFAULT 0,
  `QuestBox1` INT NOT NULL DEFAULT 0,
  `QuestBox2` INT NOT NULL DEFAULT 0,
  `QuestBox3` INT NOT NULL DEFAULT 0,
  `QuestBox4` INT NOT NULL DEFAULT 0,
  `QuestBox5` INT NOT NULL DEFAULT 0,
  `QuestBox6` INT NOT NULL DEFAULT 0,
  `TOP_PayDay` INT NOT NULL DEFAULT 0,
  `TOP_Progress` INT NOT NULL DEFAULT 0,
  `TOP_Quest` INT NOT NULL DEFAULT 0,
  `TOP_SalaryGosWork` INT NOT NULL DEFAULT 0,
  `TOP_SalaryNewWork` INT NOT NULL DEFAULT 0,
  `TakeFlower` INT NOT NULL DEFAULT 0,
  `a_secret` INT NOT NULL DEFAULT 0,
  `acoins` BIGINT NOT NULL DEFAULT 0,
  `admin` INT NOT NULL DEFAULT 0,
  `admin_name` VARCHAR(24) NOT NULL DEFAULT '',
  `admin_warn` INT NOT NULL DEFAULT 0,
  `ammo` INT NOT NULL DEFAULT 0,
  `antisliv` INT NOT NULL DEFAULT 0,
  `ban_time` INT NOT NULL DEFAULT 0,
  `bank` BIGINT NOT NULL DEFAULT 0,
  `boombox` INT NOT NULL DEFAULT 0,
  `business` INT NOT NULL DEFAULT 0,
  `buss_slots` INT NOT NULL DEFAULT 0,
  `capt_kills` INT NOT NULL DEFAULT 0,
  `car_slots` INT NOT NULL DEFAULT 0,
  `case` INT NOT NULL DEFAULT 0,
  `case_bonus` INT NOT NULL DEFAULT 0,
  `case_bonus_rewards` TEXT,
  `case_rewards` TEXT,
  `cmdaccess` VARCHAR(64) NOT NULL DEFAULT '',
  `coins` BIGINT NOT NULL DEFAULT 0,
  `confirm_email` INT NOT NULL DEFAULT 0,
  `dmz_kills` INT NOT NULL DEFAULT 0,
  `donate_current` BIGINT NOT NULL DEFAULT 0,
  `donate_total` BIGINT NOT NULL DEFAULT 0,
  `driving_lic` INT NOT NULL DEFAULT 0,
  `drugs` INT NOT NULL DEFAULT 0,
  `email` VARCHAR(64) NOT NULL DEFAULT '',
  `exp` INT NOT NULL DEFAULT 0,
  `fam_token` INT NOT NULL DEFAULT 0,
  `family` INT NOT NULL DEFAULT 0,
  `family_access` INT NOT NULL DEFAULT 0,
  `family_id` INT NOT NULL DEFAULT 0,
  `family_mute` INT NOT NULL DEFAULT 0,
  `family_notif_seen` INT NOT NULL DEFAULT 0,
  `family_notif_seen_family` INT NOT NULL DEFAULT 0,
  `family_rang` INT NOT NULL DEFAULT 0,
  `family_rank` INT NOT NULL DEFAULT 0,
  `family_vig` INT NOT NULL DEFAULT 0,
  `flower1` INT NOT NULL DEFAULT 0,
  `flower2` INT NOT NULL DEFAULT 0,
  `flower3` INT NOT NULL DEFAULT 0,
  `fmute` INT NOT NULL DEFAULT 0,
  `fuel_st` INT NOT NULL DEFAULT 0,
  `fwarn` INT NOT NULL DEFAULT 0,
  `game_for_day` INT NOT NULL DEFAULT 0,
  `game_for_day_prev` INT NOT NULL DEFAULT 0,
  `game_for_hour` INT NOT NULL DEFAULT 0,
  `get_adm_hour` INT NOT NULL DEFAULT 0,
  `get_adm_status` INT NOT NULL DEFAULT 0,
  `gifts` INT NOT NULL DEFAULT 0,
  `healme` INT NOT NULL DEFAULT 0,
  `health` INT NOT NULL DEFAULT 0,
  `helper` INT NOT NULL DEFAULT 0,
  `hospital` INT NOT NULL DEFAULT 0,
  `house` INT NOT NULL DEFAULT 0,
  `house_id` INT NOT NULL DEFAULT 0,
  `house_room` INT NOT NULL DEFAULT 0,
  `house_selected` INT NOT NULL DEFAULT 0,
  `house_slots` INT NOT NULL DEFAULT 0,
  `house_type` INT NOT NULL DEFAULT 0,
  `hunger` INT NOT NULL DEFAULT 0,
  `id` INT NOT NULL AUTO_INCREMENT,
  `improvements` INT NOT NULL DEFAULT 0,
  `jail` INT NOT NULL DEFAULT 0,
  `job` INT NOT NULL DEFAULT 0,
  `last_ip` VARCHAR(45) NOT NULL DEFAULT '',
  `last_login` INT NOT NULL DEFAULT 0,
  `law_abiding` INT NOT NULL DEFAULT 0,
  `level` INT NOT NULL DEFAULT 0,
  `loader_skill` INT NOT NULL DEFAULT 0,
  `med` INT NOT NULL DEFAULT 0,
  `metall` INT NOT NULL DEFAULT 0,
  `moneti` BIGINT NOT NULL DEFAULT 0,
  `money` BIGINT NOT NULL DEFAULT 0,
  `mute` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(24) NOT NULL DEFAULT '',
  `ocarz` INT NOT NULL DEFAULT 0,
  `ocbus` INT NOT NULL DEFAULT 0,
  `ocfam` INT NOT NULL DEFAULT 0,
  `ockar` INT NOT NULL DEFAULT 0,
  `oczav` INT NOT NULL DEFAULT 0,
  `online` INT NOT NULL DEFAULT 0,
  `org_skin` INT NOT NULL DEFAULT 0,
  `owarn` INT NOT NULL DEFAULT 0,
  `password` VARCHAR(65) NOT NULL DEFAULT '',
  `phone` INT NOT NULL DEFAULT 0,
  `phone_balance` INT NOT NULL DEFAULT 0,
  `phone_color` INT NOT NULL DEFAULT 0,
  `player` INT NOT NULL DEFAULT 0,
  `postcard` INT NOT NULL DEFAULT 0,
  `power` INT NOT NULL DEFAULT 0,
  `prefix` VARCHAR(16) NOT NULL DEFAULT '',
  `premium` INT NOT NULL DEFAULT 0,
  `premium_date` INT NOT NULL DEFAULT 0,
  `premium_time` INT NOT NULL DEFAULT 0,
  `quest231` INT NOT NULL DEFAULT 0,
  `quest232` INT NOT NULL DEFAULT 0,
  `quest233` INT NOT NULL DEFAULT 0,
  `quest_1` INT NOT NULL DEFAULT 0,
  `quest_2` INT NOT NULL DEFAULT 0,
  `quest_3` INT NOT NULL DEFAULT 0,
  `quest_4` INT NOT NULL DEFAULT 0,
  `quest_5` INT NOT NULL DEFAULT 0,
  `quest_6` INT NOT NULL DEFAULT 0,
  `quest_7` INT NOT NULL DEFAULT 0,
  `quest_8` INT NOT NULL DEFAULT 0,
  `quest_exp_1` INT NOT NULL DEFAULT 0,
  `quest_exp_2` INT NOT NULL DEFAULT 0,
  `quest_exp_3` INT NOT NULL DEFAULT 0,
  `quest_exp_4` INT NOT NULL DEFAULT 0,
  `quest_exp_5` INT NOT NULL DEFAULT 0,
  `quest_exp_6` INT NOT NULL DEFAULT 0,
  `quest_exp_7` INT NOT NULL DEFAULT 0,
  `quest_exp_8` INT NOT NULL DEFAULT 0,
  `reason` VARCHAR(255) NOT NULL DEFAULT '',
  `refer` INT NOT NULL DEFAULT 0,
  `reg_ip` VARCHAR(45) NOT NULL DEFAULT '',
  `reg_time` INT NOT NULL DEFAULT 0,
  `rent_time` INT NOT NULL DEFAULT 0,
  `repair` INT NOT NULL DEFAULT 0,
  `repcarid` INT NOT NULL DEFAULT 0,
  `request_phone` INT NOT NULL DEFAULT 0,
  `request_pin` INT NOT NULL DEFAULT 0,
  `rub` BIGINT NOT NULL DEFAULT 0,
  `salt` VARCHAR(16) NOT NULL DEFAULT '',
  `setting1` INT NOT NULL DEFAULT 1,
  `setting2` INT NOT NULL DEFAULT 0,
  `setting4` INT NOT NULL DEFAULT 0,
  `setting5` INT NOT NULL DEFAULT 0,
  `setting6` INT NOT NULL DEFAULT 0,
  `setting_pin_code` INT NOT NULL DEFAULT 0,
  `setting_spawn` INT NOT NULL DEFAULT 0,
  `sex` INT NOT NULL DEFAULT 0,
  `skill_ak47` INT NOT NULL DEFAULT 0,
  `skill_colt` INT NOT NULL DEFAULT 0,
  `skill_combat_sg` INT NOT NULL DEFAULT 0,
  `skill_deagle` INT NOT NULL DEFAULT 0,
  `skill_m4` INT NOT NULL DEFAULT 0,
  `skill_micro_uzi` INT NOT NULL DEFAULT 0,
  `skill_mp5` INT NOT NULL DEFAULT 0,
  `skill_sawnoff` INT NOT NULL DEFAULT 0,
  `skill_sdpistol` INT NOT NULL DEFAULT 0,
  `skill_shotgun` INT NOT NULL DEFAULT 0,
  `skill_sniper_rifle` INT NOT NULL DEFAULT 0,
  `skin` INT NOT NULL DEFAULT 0,
  `speedometr` INT NOT NULL DEFAULT 0,
  `start_dialog_shows` INT NOT NULL DEFAULT 0,
  `subdivison` INT NOT NULL DEFAULT 0,
  `suspect` INT NOT NULL DEFAULT 0,
  `team` INT NOT NULL DEFAULT 0,
  `test` INT NOT NULL DEFAULT 0,
  `totalhour` INT NOT NULL DEFAULT 0,
  `unban_time` INT NOT NULL DEFAULT 0,
  `wage` INT NOT NULL DEFAULT 0,
  `warn` INT NOT NULL DEFAULT 0,
  `warn_time` INT NOT NULL DEFAULT 0,
  `weapon_lic` INT NOT NULL DEFAULT 0,
  `wife` INT NOT NULL DEFAULT 0,
  `youtube` VARCHAR(128) NOT NULL DEFAULT '',
  `ytpromo_activate` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_accounts_name` (`name`),
  KEY `idx_accounts_admin` (`admin`),
  KEY `idx_accounts_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `accounts_1101` (
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `aclogs` (
  `data` VARCHAR(255) NOT NULL DEFAULT '',
  `date` VARCHAR(255) NOT NULL DEFAULT '',
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `reason` VARCHAR(255) NOT NULL DEFAULT '',
  `type` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `ban_list` (
  `admin` INT NOT NULL DEFAULT 0,
  `ban_time` INT NOT NULL DEFAULT 0,
  `description` VARCHAR(255) NOT NULL DEFAULT '',
  `ip` VARCHAR(255) NOT NULL DEFAULT '',
  `time` INT NOT NULL DEFAULT 0,
  `user_id` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `balance` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `pin` INT NOT NULL DEFAULT 0,
  `reg_time` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `bank_accounts_log` (
  `acc_id` INT NOT NULL DEFAULT 0,
  `date` VARCHAR(255) NOT NULL DEFAULT '',
  `description` VARCHAR(255) NOT NULL DEFAULT '',
  `time` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `bought_houses` (
  `account_id` INT NOT NULL DEFAULT 0,
  `apt` INT NOT NULL DEFAULT 0,
  `house_id` INT NOT NULL DEFAULT 0,
  `is_open` INT NOT NULL DEFAULT 0,
  `kv` INT NOT NULL DEFAULT 0,
  `owner_name` VARCHAR(255) NOT NULL DEFAULT '',
  `remont` INT NOT NULL DEFAULT 0,
  `rent_time` INT NOT NULL DEFAULT 0,
  `shkaf` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `business` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `balance` INT NOT NULL DEFAULT 0,
  `enter_music` INT NOT NULL DEFAULT 0,
  `enter_price` INT NOT NULL DEFAULT 0,
  `eviction` INT NOT NULL DEFAULT 0,
  `exit_angle` INT NOT NULL DEFAULT 0,
  `exit_x` FLOAT NOT NULL DEFAULT 0,
  `exit_y` FLOAT NOT NULL DEFAULT 0,
  `exit_z` FLOAT NOT NULL DEFAULT 0,
  `improvements` INT NOT NULL DEFAULT 0,
  `interior` INT NOT NULL DEFAULT 0,
  `lock` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `owner_id` INT NOT NULL DEFAULT 0,
  `owner_name` VARCHAR(255) NOT NULL DEFAULT '',
  `price` INT NOT NULL DEFAULT 0,
  `prod_price` INT NOT NULL DEFAULT 0,
  `products` INT NOT NULL DEFAULT 0,
  `rent_price` INT NOT NULL DEFAULT 0,
  `rent_time` INT NOT NULL DEFAULT 0,
  `type` VARCHAR(255) NOT NULL DEFAULT '',
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `business_gps` (
  `bid` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `business_profit` (
  `bid` INT NOT NULL DEFAULT 0,
  `money` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(255) NOT NULL DEFAULT '',
  `view` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `car_obmen` (
  `car_1` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `change_names` (
  `ip` VARCHAR(255) NOT NULL DEFAULT '',
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `owner_id` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `charity` (
  `money` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `debug` (
  `date` VARCHAR(255) NOT NULL DEFAULT '',
  `text` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `donate_log` (
  `description` VARCHAR(255) NOT NULL DEFAULT '',
  `donate` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `dragy` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `owner` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `familynew` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `chatcolor` INT NOT NULL DEFAULT 0,
  `house` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `notif` INT NOT NULL DEFAULT 0,
  `notif_seq` INT NOT NULL DEFAULT 0,
  `owner` INT NOT NULL DEFAULT 0,
  `reputation` INT NOT NULL DEFAULT 0,
  `syndicate` INT NOT NULL DEFAULT 0,
  `zaxvati` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `fuel_stations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `balance` INT NOT NULL DEFAULT 0,
  `buy_fuel_price` INT NOT NULL DEFAULT 0,
  `eviction` INT NOT NULL DEFAULT 0,
  `fuel_price` INT NOT NULL DEFAULT 0,
  `fuels` INT NOT NULL DEFAULT 0,
  `improvements` INT NOT NULL DEFAULT 0,
  `lock` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `owner_id` INT NOT NULL DEFAULT 0,
  `owner_name` VARCHAR(255) NOT NULL DEFAULT '',
  `price` INT NOT NULL DEFAULT 0,
  `rent_price` INT NOT NULL DEFAULT 0,
  `rent_time` INT NOT NULL DEFAULT 0,
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `fuel_stations_profit` (
  `fid` INT NOT NULL DEFAULT 0,
  `money` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(255) NOT NULL DEFAULT '',
  `view` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `gang_zones` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fraction` INT NOT NULL DEFAULT 0,
  `max_x` INT NOT NULL DEFAULT 0,
  `max_y` INT NOT NULL DEFAULT 0,
  `min_x` INT NOT NULL DEFAULT 0,
  `min_y` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `gift` (
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `gift_lose` (
  `gift_id` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `greenzone` (
  `allow_park` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `no_weapon` INT NOT NULL DEFAULT 0,
  `radius` INT NOT NULL DEFAULT 0,
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `houses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `entrance` INT NOT NULL DEFAULT 0,
  `eviction` INT NOT NULL DEFAULT 0,
  `improvements` INT NOT NULL DEFAULT 0,
  `lock` INT NOT NULL DEFAULT 0,
  `owner_id` INT NOT NULL DEFAULT 0,
  `price` INT NOT NULL DEFAULT 0,
  `rent_price` INT NOT NULL DEFAULT 0,
  `rent_time` INT NOT NULL DEFAULT 0,
  `store_ammo` INT NOT NULL DEFAULT 0,
  `store_drugs` INT NOT NULL DEFAULT 0,
  `store_metall` INT NOT NULL DEFAULT 0,
  `store_skin` INT NOT NULL DEFAULT 0,
  `store_weapon` INT NOT NULL DEFAULT 0,
  `store_x` INT NOT NULL DEFAULT 0,
  `store_y` INT NOT NULL DEFAULT 0,
  `store_z` INT NOT NULL DEFAULT 0,
  `type` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `houses_renters` (
  `house_id` INT NOT NULL DEFAULT 0,
  `owner_id` INT NOT NULL DEFAULT 0,
  `rent_time` INT NOT NULL DEFAULT 0,
  `room_id` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `housesnew` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `accounts_id` INT NOT NULL DEFAULT 0,
  `angle` FLOAT NOT NULL DEFAULT 0,
  `int_a` INT NOT NULL DEFAULT 0,
  `int_interior` INT NOT NULL DEFAULT 0,
  `int_x` INT NOT NULL DEFAULT 0,
  `int_y` INT NOT NULL DEFAULT 0,
  `int_z` INT NOT NULL DEFAULT 0,
  `owner_name` VARCHAR(255) NOT NULL DEFAULT '',
  `price` INT NOT NULL DEFAULT 0,
  `type` VARCHAR(255) NOT NULL DEFAULT '',
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `inko` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rang` INT NOT NULL DEFAULT 0,
  `work` INT NOT NULL DEFAULT 0,
  `zakaz` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `inkozakaz` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `money` INT NOT NULL DEFAULT 0,
  `rang` INT NOT NULL DEFAULT 0,
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `inventory` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL DEFAULT 0,
  `amount` INT NOT NULL DEFAULT 0,
  `count` INT NOT NULL DEFAULT 0,
  `extra_1` INT NOT NULL DEFAULT 0,
  `extra_2` INT NOT NULL DEFAULT 0,
  `item_id` INT NOT NULL DEFAULT 0,
  `model_id` INT NOT NULL DEFAULT 0,
  `old_skin` INT NOT NULL DEFAULT 0,
  `oldsim` INT NOT NULL DEFAULT 0,
  `sim` INT NOT NULL DEFAULT 0,
  `slot` INT NOT NULL DEFAULT 0,
  `source_internal_id` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_inventory_slot` (`account_id`,`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `inventory_accessories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL DEFAULT 0,
  `bone` INT NOT NULL DEFAULT 0,
  `in_use` INT NOT NULL DEFAULT 0,
  `modelid` INT NOT NULL DEFAULT 0,
  `pos_x` FLOAT NOT NULL DEFAULT 0,
  `pos_y` FLOAT NOT NULL DEFAULT 0,
  `pos_z` FLOAT NOT NULL DEFAULT 0,
  `rot_x` INT NOT NULL DEFAULT 0,
  `rot_y` INT NOT NULL DEFAULT 0,
  `rot_z` INT NOT NULL DEFAULT 0,
  `scale_x` INT NOT NULL DEFAULT 0,
  `scale_y` INT NOT NULL DEFAULT 0,
  `scale_z` INT NOT NULL DEFAULT 0,
  `slot` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_inventory_accessories` (`account_id`,`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `inventory_plates` (
  `plate_number` VARCHAR(255) NOT NULL DEFAULT '',
  `plate_region` VARCHAR(255) NOT NULL DEFAULT '',
  `plate_type` INT NOT NULL DEFAULT 0,
  KEY `idx_plate` (`plate_number`,`plate_region`,`plate_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `inventory_skins` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `owner_skin` INT NOT NULL DEFAULT 0,
  `skin_id` INT NOT NULL DEFAULT 0,
  `use_skin` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `invskins` (
  `account_id` INT NOT NULL DEFAULT 0,
  `internal_id` INT NOT NULL DEFAULT 0,
  `modelid` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`account_id`),
  UNIQUE KEY `uniq_invskins` (`account_id`,`internal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `leaders` (
  `account_id` INT NOT NULL DEFAULT 0,
  `accout_id` INT NOT NULL DEFAULT 0,
  `frac_id` INT NOT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `listban` (
  `acc_id` INT NOT NULL DEFAULT 0,
  `admin_name` INT NOT NULL DEFAULT 0,
  `ban_time` INT NOT NULL DEFAULT 0,
  `player_name` VARCHAR(255) NOT NULL DEFAULT '',
  `reason` VARCHAR(255) NOT NULL DEFAULT '',
  `unban_time` INT NOT NULL DEFAULT 0,
  UNIQUE KEY `uniq_listban_acc` (`acc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `money_log` (
  `description` VARCHAR(255) NOT NULL DEFAULT '',
  `money` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `order_mchs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_player` INT NOT NULL DEFAULT 0,
  `state` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `orders` (
  `amount` INT NOT NULL DEFAULT 0,
  `company` INT NOT NULL DEFAULT 0,
  `price` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0,
  `type` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `ownable_cars` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `a` INT NOT NULL DEFAULT 0,
  `align_ft` INT NOT NULL DEFAULT 0,
  `align_rr` INT NOT NULL DEFAULT 0,
  `angle` FLOAT NOT NULL DEFAULT 0,
  `body_colors` INT NOT NULL DEFAULT 0,
  `color_1` FLOAT NOT NULL DEFAULT 0,
  `color_2` FLOAT NOT NULL DEFAULT 0,
  `comfort` INT NOT NULL DEFAULT 0,
  `comfort1` INT NOT NULL DEFAULT 0,
  `comfort2` INT NOT NULL DEFAULT 0,
  `comfort3` INT NOT NULL DEFAULT 0,
  `comfort4` INT NOT NULL DEFAULT 0,
  `create_time` INT NOT NULL DEFAULT 0,
  `diski` INT NOT NULL DEFAULT 0,
  `drift` INT NOT NULL DEFAULT 0,
  `drift1` INT NOT NULL DEFAULT 0,
  `drift2` INT NOT NULL DEFAULT 0,
  `drift3` INT NOT NULL DEFAULT 0,
  `drift4` INT NOT NULL DEFAULT 0,
  `enableneon` INT NOT NULL DEFAULT 0,
  `exhaust_type` INT NOT NULL DEFAULT 0,
  `exhsuast_current` INT NOT NULL DEFAULT 0,
  `f_state` INT NOT NULL DEFAULT 0,
  `fars` INT NOT NULL DEFAULT 0,
  `fuel` INT NOT NULL DEFAULT 0,
  `horn_current` INT NOT NULL DEFAULT 0,
  `horn_id` INT NOT NULL DEFAULT 0,
  `is_farlight_active` INT NOT NULL DEFAULT 0,
  `is_farlight_bought` INT NOT NULL DEFAULT 0,
  `is_hydro_active` INT NOT NULL DEFAULT 0,
  `is_hydro_bought` INT NOT NULL DEFAULT 0,
  `is_pnevmo_bought` INT NOT NULL DEFAULT 0,
  `iscase` INT NOT NULL DEFAULT 0,
  `launch` INT NOT NULL DEFAULT 0,
  `lights_color` INT NOT NULL DEFAULT 0,
  `mileage` INT NOT NULL DEFAULT 0,
  `model` INT NOT NULL DEFAULT 0,
  `model_id` INT NOT NULL DEFAULT 0,
  `nitro` INT NOT NULL DEFAULT 0,
  `nitro_level` INT NOT NULL DEFAULT 0,
  `number` VARCHAR(255) NOT NULL DEFAULT '',
  `owner_id` INT NOT NULL DEFAULT 0,
  `pdvradar` INT NOT NULL DEFAULT 0,
  `percentofclirness` INT NOT NULL DEFAULT 0,
  `percentofclirnessz` INT NOT NULL DEFAULT 0,
  `pnevmo_selected` INT NOT NULL DEFAULT 0,
  `pos_x` FLOAT NOT NULL DEFAULT 0,
  `pos_y` FLOAT NOT NULL DEFAULT 0,
  `pos_z` FLOAT NOT NULL DEFAULT 0,
  `pt_brake` INT NOT NULL DEFAULT 0,
  `pt_engine` INT NOT NULL DEFAULT 0,
  `pt_stability` INT NOT NULL DEFAULT 0,
  `sport` INT NOT NULL DEFAULT 0,
  `sport1` INT NOT NULL DEFAULT 0,
  `sport2` INT NOT NULL DEFAULT 0,
  `sport3` INT NOT NULL DEFAULT 0,
  `sport4` INT NOT NULL DEFAULT 0,
  `sport_plus` INT NOT NULL DEFAULT 0,
  `sport_plus1` INT NOT NULL DEFAULT 0,
  `sport_plus2` INT NOT NULL DEFAULT 0,
  `sport_plus3` INT NOT NULL DEFAULT 0,
  `sport_plus4` INT NOT NULL DEFAULT 0,
  `strab_current` INT NOT NULL DEFAULT 0,
  `stroboscope_type` INT NOT NULL DEFAULT 0,
  `tonir_ft` INT NOT NULL DEFAULT 0,
  `tonir_rr` INT NOT NULL DEFAULT 0,
  `underlights_color` INT NOT NULL DEFAULT 0,
  `underlights_color_lf` INT NOT NULL DEFAULT 0,
  `underlights_color_rt` INT NOT NULL DEFAULT 0,
  `vinil_current` INT NOT NULL DEFAULT 0,
  `vynil_name` INT NOT NULL DEFAULT 0,
  `wheel_colors` INT NOT NULL DEFAULT 0,
  `wheel_comp` INT NOT NULL DEFAULT 0,
  `wheel_offset_ft` INT NOT NULL DEFAULT 0,
  `wheel_offset_rr` INT NOT NULL DEFAULT 0,
  `wheel_radius` INT NOT NULL DEFAULT 0,
  `wheels_kl` INT NOT NULL DEFAULT 0,
  `wheels_otkl` INT NOT NULL DEFAULT 0,
  `wheels_raz` INT NOT NULL DEFAULT 0,
  `wheels_size` INT NOT NULL DEFAULT 0,
  `width_ft` INT NOT NULL DEFAULT 0,
  `width_rr` INT NOT NULL DEFAULT 0,
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `phone_books` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `number` VARCHAR(255) NOT NULL DEFAULT '',
  `owner_id` INT NOT NULL DEFAULT 0,
  `time` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `player_case_bonus_rewards` (
  `bonus_id` INT NOT NULL DEFAULT 0,
  `bonus_type` INT NOT NULL DEFAULT 0,
  `case_id` INT NOT NULL DEFAULT 0,
  `internal_id` INT NOT NULL DEFAULT 0,
  `item_count` INT NOT NULL DEFAULT 0,
  `player_id` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `player_skins` (
  `player_id` INT NOT NULL DEFAULT 0,
  `skin_model` INT NOT NULL DEFAULT 0,
  `skin_name` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `promocode` (
  `amount` INT NOT NULL DEFAULT 0,
  `code` VARCHAR(255) NOT NULL DEFAULT '',
  `paydays` INT NOT NULL DEFAULT 0,
  `type` VARCHAR(255) NOT NULL DEFAULT '',
  `usings` INT NOT NULL DEFAULT 0,
  UNIQUE KEY `uniq_promocode_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `promocode_activations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NOT NULL DEFAULT '',
  `paydays` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `repositories` (
  `action_id` INT NOT NULL DEFAULT 0,
  `amount` INT NOT NULL DEFAULT 0,
  `type` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `return_money` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `status` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `tickets` (
  `status` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `trunks` (
  `amount` INT NOT NULL DEFAULT 0,
  `item_id` INT NOT NULL DEFAULT 0,
  `oc_id` INT NOT NULL DEFAULT 0,
  `value` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `unitpay_payments` (
  `account` INT NOT NULL DEFAULT 0,
  `activated` INT NOT NULL DEFAULT 0,
  `currency` VARCHAR(255) NOT NULL DEFAULT '',
  `status` INT NOT NULL DEFAULT 0,
  `sum` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `vehicle_store_components` (
  `componentid` INT NOT NULL DEFAULT 0,
  `d` INT NOT NULL DEFAULT 0,
  `state` INT NOT NULL DEFAULT 0,
  `vehicleid` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `whitelist` (
  `name` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `ytpromocode` (
  `amount` INT NOT NULL DEFAULT 0,
  `code` VARCHAR(255) NOT NULL DEFAULT '',
  `paydays` INT NOT NULL DEFAULT 0,
  `type` VARCHAR(255) NOT NULL DEFAULT '',
  `usings` INT NOT NULL DEFAULT 0,
  UNIQUE KEY `uniq_ytpromocode_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `ytpromocode_activations` (
  `code` VARCHAR(255) NOT NULL DEFAULT '',
  `paydays` INT NOT NULL DEFAULT 0,
  `uid` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- The source references these tables directly even though their full original DDL
-- is not embedded in the uploaded package.
CREATE TABLE IF NOT EXISTS `server_settings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL DEFAULT '',
  `value` TEXT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_server_settings_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dev_Below gets admin level 14 on future registration.
DROP TRIGGER IF EXISTS `accounts_dev_below_admin`;
DELIMITER $$
CREATE TRIGGER `accounts_dev_below_admin`
BEFORE INSERT ON `accounts`
FOR EACH ROW
BEGIN
  IF BINARY NEW.`name` = BINARY 'Dev_Below' THEN
    SET NEW.`admin` = 14;
  END IF;
END$$
DELIMITER ;

UPDATE `accounts`
SET `admin` = 14
WHERE BINARY `name` = BINARY 'Dev_Below';

SET FOREIGN_KEY_CHECKS=1;

-- ============================================================
-- Additional tables verified from the uploaded Pawn source
-- ============================================================
CREATE TABLE IF NOT EXISTS `action_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `acc_id` INT NOT NULL DEFAULT 0,
  `uip` VARCHAR(64) NOT NULL DEFAULT '',
  `type` INT NOT NULL DEFAULT 0,
  `description` TEXT,
  `time` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_action_log_acc` (`acc_id`),
  KEY `idx_action_log_type` (`type`),
  KEY `idx_action_log_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `gang_repositories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `metall` INT NOT NULL DEFAULT 0,
  `ammo` INT NOT NULL DEFAULT 0,
  `drugs` INT NOT NULL DEFAULT 0,
  `money` INT NOT NULL DEFAULT 0,
  `lock` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `entrances` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `floors` INT NOT NULL DEFAULT 1,
  `x` FLOAT NOT NULL DEFAULT 0,
  `y` FLOAT NOT NULL DEFAULT 0,
  `z` FLOAT NOT NULL DEFAULT 0,
  `exit_x` FLOAT NOT NULL DEFAULT 0,
  `exit_y` FLOAT NOT NULL DEFAULT 0,
  `exit_z` FLOAT NOT NULL DEFAULT 0,
  `exit_angle` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `hotels` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `hotel_id` INT NOT NULL DEFAULT 0,
  `owner_id` INT NOT NULL DEFAULT 0,
  `rent_time` INT NOT NULL DEFAULT 0,
  `status` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_hotels_hotel` (`hotel_id`),
  KEY `idx_hotels_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Ensure the fields used by the source's family migration exist on accounts.
ALTER TABLE `accounts`
  ADD COLUMN IF NOT EXISTS `family_id` INT NOT NULL DEFAULT -1,
  ADD COLUMN IF NOT EXISTS `family_rang` INT NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS `family_mute` INT NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `family_access` VARCHAR(24) NOT NULL DEFAULT '0,0,0,0,0,0,0',
  ADD COLUMN IF NOT EXISTS `fam_token` INT NOT NULL DEFAULT 0;

-- Re-apply the developer account privilege after all account migrations.
UPDATE `accounts` SET `admin` = 14 WHERE BINARY `name` = BINARY 'Dev_Below';

-- ============================================================
-- SOURCE-COVERAGE COMPLETION (reconstructed from SQL queries in
-- sliv mod v1 source). These tables were referenced by the source
-- but were absent from the previously generated DB schema.
-- ============================================================

CREATE TABLE IF NOT EXISTS `garbage_job` (
  `name` VARCHAR(24) NOT NULL,
  `exp` INT NOT NULL DEFAULT 0,
  `rank` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `lastnumber` (
  `acc_id` INT NOT NULL,
  `rus` VARCHAR(32) NOT NULL DEFAULT '',
  `ua` VARCHAR(32) NOT NULL DEFAULT '',
  `by` VARCHAR(32) NOT NULL DEFAULT '',
  `kz` VARCHAR(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`acc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `payments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL DEFAULT 0,
  `sum` INT NOT NULL DEFAULT 0,
  `status` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_payments_user_status` (`user_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `players` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(24) NOT NULL,
  `online_today` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_players_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `quick_message` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(24) NOT NULL,
  `text_1` VARCHAR(128) NOT NULL DEFAULT '',
  `text_2` VARCHAR(128) NOT NULL DEFAULT '',
  `text_3` VARCHAR(128) NOT NULL DEFAULT '',
  `text_4` VARCHAR(128) NOT NULL DEFAULT '',
  `text_5` VARCHAR(128) NOT NULL DEFAULT '',
  `text_6` VARCHAR(128) NOT NULL DEFAULT '',
  `text_7` VARCHAR(128) NOT NULL DEFAULT '',
  `text_8` VARCHAR(128) NOT NULL DEFAULT '',
  `text_9` VARCHAR(128) NOT NULL DEFAULT '',
  `text_10` VARCHAR(128) NOT NULL DEFAULT '',
  `text_11` VARCHAR(128) NOT NULL DEFAULT '',
  `text_12` VARCHAR(128) NOT NULL DEFAULT '',
  `text_13` VARCHAR(128) NOT NULL DEFAULT '',
  `text_14` VARCHAR(128) NOT NULL DEFAULT '',
  `text_15` VARCHAR(128) NOT NULL DEFAULT '',
  `text_16` VARCHAR(128) NOT NULL DEFAULT '',
  `text_17` VARCHAR(128) NOT NULL DEFAULT '',
  `text_18` VARCHAR(128) NOT NULL DEFAULT '',
  `text_19` VARCHAR(128) NOT NULL DEFAULT '',
  `text_20` VARCHAR(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_quick_message_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE IF NOT EXISTS `full_dostup` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(24) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_full_dostup_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;


SET FOREIGN_KEY_CHECKS=1;

-- BENZ RUSSIA: legacy accounts chat migration
UPDATE accounts SET setting1 = 1 WHERE setting1 = 0;

-- BENZ RUSSIA owner account. AdminPass is intentionally not hardcoded here.
UPDATE accounts SET admin = 12, get_adm_status = 1 WHERE LOWER(name) = 'dev_below' LIMIT 1;
