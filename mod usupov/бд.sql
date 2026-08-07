SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
    `id`                INT(11) NOT NULL AUTO_INCREMENT,
    `name`              VARCHAR(24)  NOT NULL,
    `password`          VARCHAR(129) NOT NULL DEFAULT '',
    `salt`              VARCHAR(65)  NOT NULL DEFAULT '',
    `email`             VARCHAR(64)  NOT NULL DEFAULT '',
    `confirm_email`     TINYINT(1)   NOT NULL DEFAULT 0,
    `refer`             INT(11)      NOT NULL DEFAULT 0,
    `sex`               TINYINT(1)   NOT NULL DEFAULT 0,
    `skin`              INT(11)      NOT NULL DEFAULT 0,
    `org_skin`          INT(11)      NOT NULL DEFAULT 0,

    `money`             INT(11)      NOT NULL DEFAULT 5000,
    `bank`              INT(11)      NOT NULL DEFAULT 0,
    `phone`             INT(11)      NOT NULL DEFAULT 0,
    `phone_balance`     INT(11)      NOT NULL DEFAULT 0,
    `phone_color`       INT(11)      NOT NULL DEFAULT 0,

    `admin`             INT(11)      NOT NULL DEFAULT 0,
    `admin_prefix_id`   INT(11)      NOT NULL DEFAULT 0,
    `3d_prefix`         INT(11)      NOT NULL DEFAULT 0,
    `AdminPass`         INT(11)      NOT NULL DEFAULT 0,
    `admin_pass_hash`   VARCHAR(129) NOT NULL DEFAULT '',
    `admin_pass_salt`   VARCHAR(65)  NOT NULL DEFAULT '',
    `a_secret`          INT(11)      NOT NULL DEFAULT 0,
    `admin_warn`        INT(11)      NOT NULL DEFAULT 0,
    `get_adm_hour`      INT(11)      NOT NULL DEFAULT 0,
    `get_adm_status`    INT(11)      NOT NULL DEFAULT 0,
    `helper`            INT(11)      NOT NULL DEFAULT 0,
    `cmdaccess`         TEXT         NULL,
    `prefix`            VARCHAR(16)  NOT NULL DEFAULT '',

    `level`             INT(11)      NOT NULL DEFAULT 1,
    `exp`               INT(11)      NOT NULL DEFAULT 0,
    `player`            INT(11)      NOT NULL DEFAULT 0,

    `driving_lic`       TINYINT(1)   NOT NULL DEFAULT 0,
    `weapon_lic`        TINYINT(1)   NOT NULL DEFAULT 0,
    `suspect`           INT(11)      NOT NULL DEFAULT 0,

    `law_abiding`       INT(11)      NOT NULL DEFAULT 0,
    `improvements`      INT(11)      NOT NULL DEFAULT 0,
    `power`             INT(11)      NOT NULL DEFAULT 0,

    `drugs`             INT(11)      NOT NULL DEFAULT 0,
    `ammo`              INT(11)      NOT NULL DEFAULT 0,
    `metall`            INT(11)      NOT NULL DEFAULT 0,
    `wife`              INT(11)      NOT NULL DEFAULT 0,
    `team`              INT(11)      NOT NULL DEFAULT 0,
    `subdivison`        INT(11)      NOT NULL DEFAULT 0,
    `wage`              INT(11)      NOT NULL DEFAULT 0,
    `job`               INT(11)      NOT NULL DEFAULT 0,
    `loader_skill`      INT(11)      NOT NULL DEFAULT 0,

    `family`            INT(11)      NOT NULL DEFAULT -1,
    `family_rank`       INT(11)      NOT NULL DEFAULT 0,
    `family_id`         INT(11)      NOT NULL DEFAULT -1,
    `family_rang`       INT(11)      NOT NULL DEFAULT 0,
    `family_access`     VARCHAR(32)  NOT NULL DEFAULT '',
    `family_mute`       INT(11)      NOT NULL DEFAULT 0,

    `house_type`        INT(11)      NOT NULL DEFAULT -1,
    `house_room`        INT(11)      NOT NULL DEFAULT -1,
    `house`             INT(11)      NOT NULL DEFAULT -1,
    `business`          INT(11)      NOT NULL DEFAULT -1,
    `fuel_st`           INT(11)      NOT NULL DEFAULT -1,
    `eviction`          INT(11)      NOT NULL DEFAULT 0,

    `reg_time`          INT(11)      NOT NULL DEFAULT 0,
    `reg_ip`            VARCHAR(16)  NOT NULL DEFAULT '',
    `last_ip`           VARCHAR(16)  NOT NULL DEFAULT '',
    `last_login`        INT(11)      NOT NULL DEFAULT 0,
    `online`            TINYINT(1)   NOT NULL DEFAULT 0,

    `game_for_hour`     INT(11)      NOT NULL DEFAULT 0,
    `game_for_day`      INT(11)      NOT NULL DEFAULT 0,
    `game_for_day_prev` INT(11)      NOT NULL DEFAULT 0,
    `totalhour`         INT(11)      NOT NULL DEFAULT 0,

    `setting1`          INT(11)      NOT NULL DEFAULT 0,
    `setting2`          INT(11)      NOT NULL DEFAULT 0,
    `setting4`          INT(11)      NOT NULL DEFAULT 0,
    `setting5`          INT(11)      NOT NULL DEFAULT 0,
    `setting6`          INT(11)      NOT NULL DEFAULT 0,
    `setting_spawn`     INT(11)      NOT NULL DEFAULT 0,
    `setting_pin_code`  VARCHAR(8)   NOT NULL DEFAULT '',
    `request_phone`     INT(11)      NOT NULL DEFAULT 0,
    `request_pin`       INT(11)      NOT NULL DEFAULT 0,

    `warn`              INT(11)      NOT NULL DEFAULT 0,
    `warn_time`         INT(11)      NOT NULL DEFAULT 0,
    `mute`              INT(11)      NOT NULL DEFAULT 0,
    `jail`              INT(11)      NOT NULL DEFAULT 0,
    `fwarn`             INT(11)      NOT NULL DEFAULT 0,
    `fmute`             INT(11)      NOT NULL DEFAULT 0,
    `owarn`             INT(11)      NOT NULL DEFAULT 0,
    `antisliv`          INT(11)      NOT NULL DEFAULT 0,

    `skill_colt`            INT(11)  NOT NULL DEFAULT 0,
    `skill_sdpistol`        INT(11)  NOT NULL DEFAULT 0,
    `skill_deagle`          INT(11)  NOT NULL DEFAULT 0,
    `skill_shotgun`         INT(11)  NOT NULL DEFAULT 0,
    `skill_mp5`             INT(11)  NOT NULL DEFAULT 0,
    `skill_ak47`            INT(11)  NOT NULL DEFAULT 0,
    `skill_m4`              INT(11)  NOT NULL DEFAULT 0,
    `skill_sniper_rifle`    INT(11)  NOT NULL DEFAULT 0,
    `skill_sawnoff`         INT(11)  NOT NULL DEFAULT 0,
    `skill_combat_sg`       INT(11)  NOT NULL DEFAULT 0,
    `skill_micro_uzi`       INT(11)  NOT NULL DEFAULT 0,

    `rub`               INT(11)      NOT NULL DEFAULT 0,
    `donate_current`    INT(11)      NOT NULL DEFAULT 0,
    `donate_total`      INT(11)      NOT NULL DEFAULT 0,
    `premium`           TINYINT(1)   NOT NULL DEFAULT 0,
    `premium_time`      INT(11)      NOT NULL DEFAULT 0,
    `premium_date`      INT(11)      NOT NULL DEFAULT 0,
    `coins`             INT(11)      NOT NULL DEFAULT 0,

    `gifts`             INT(11)      NOT NULL DEFAULT 0,
    `postcard`          INT(11)      NOT NULL DEFAULT 0,

    `hospital`          TINYINT(1)   NOT NULL DEFAULT 0,
    `health`            FLOAT        NOT NULL DEFAULT 100,
    `healme`            INT(11)      NOT NULL DEFAULT 0,
    `repair`            INT(11)      NOT NULL DEFAULT 0,
    `repcarid`          INT(11)      NOT NULL DEFAULT 0,
    `car_slots`         INT(11)      NOT NULL DEFAULT 0,
    `speedometr`        TINYINT(1)   NOT NULL DEFAULT 0,

    `score`             INT(11)      NOT NULL DEFAULT 0,
    `dmz_kills`         INT(11)      NOT NULL DEFAULT 0,
    `capt_kills`        INT(11)      NOT NULL DEFAULT 0,

    `youtube`           TINYINT(1)   NOT NULL DEFAULT 0,
    `ytpromo_activate`  TINYINT(1)   NOT NULL DEFAULT 0,

    `test`              INT(11)      NOT NULL DEFAULT 0,

    `TOP_SalaryNewWork` INT(11)      NOT NULL DEFAULT 0,
    `TOP_SalaryGosWork` INT(11)      NOT NULL DEFAULT 0,
    `TOP_PayDay`        INT(11)      NOT NULL DEFAULT 0,
    `TOP_Quest`         INT(11)      NOT NULL DEFAULT 0,
    `TOP_Progress`      INT(11)      NOT NULL DEFAULT 0,

    `quest_1` INT(11) NOT NULL DEFAULT 0, `quest_2` INT(11) NOT NULL DEFAULT 0,
    `quest_3` INT(11) NOT NULL DEFAULT 0, `quest_4` INT(11) NOT NULL DEFAULT 0,
    `quest_5` INT(11) NOT NULL DEFAULT 0, `quest_6` INT(11) NOT NULL DEFAULT 0,
    `quest_7` INT(11) NOT NULL DEFAULT 0, `quest_8` INT(11) NOT NULL DEFAULT 0,
    `quest_exp_1` INT(11) NOT NULL DEFAULT 0, `quest_exp_2` INT(11) NOT NULL DEFAULT 0,
    `quest_exp_3` INT(11) NOT NULL DEFAULT 0, `quest_exp_4` INT(11) NOT NULL DEFAULT 0,
    `quest_exp_5` INT(11) NOT NULL DEFAULT 0, `quest_exp_6` INT(11) NOT NULL DEFAULT 0,
    `quest_exp_7` INT(11) NOT NULL DEFAULT 0, `quest_exp_8` INT(11) NOT NULL DEFAULT 0,
    `quest231` INT(11) NOT NULL DEFAULT 0, `quest232` INT(11) NOT NULL DEFAULT 0,
    `quest233` INT(11) NOT NULL DEFAULT 0,
    `QuestBox` INT(11) NOT NULL DEFAULT 0,  `QuestBox1` INT(11) NOT NULL DEFAULT 0,
    `QuestBox2` INT(11) NOT NULL DEFAULT 0, `QuestBox3` INT(11) NOT NULL DEFAULT 0,
    `QuestBox4` INT(11) NOT NULL DEFAULT 0, `QuestBox5` INT(11) NOT NULL DEFAULT 0,
    `QuestBox6` INT(11) NOT NULL DEFAULT 0,
    `Progress1` INT(11) NOT NULL DEFAULT 0, `Progress2` INT(11) NOT NULL DEFAULT 0,
    `Progress3` INT(11) NOT NULL DEFAULT 0, `Progress4` INT(11) NOT NULL DEFAULT 0,
    `Progress5` INT(11) NOT NULL DEFAULT 0, `Progress6` INT(11) NOT NULL DEFAULT 0,
    `ProgressExp1` INT(11) NOT NULL DEFAULT 0, `ProgressExp2` INT(11) NOT NULL DEFAULT 0,
    `ProgressExp3` INT(11) NOT NULL DEFAULT 0, `ProgressExp4` INT(11) NOT NULL DEFAULT 0,
    `ProgressExp5` INT(11) NOT NULL DEFAULT 0, `ProgressExp6` INT(11) NOT NULL DEFAULT 0,
    `FracQuest1` INT(11) NOT NULL DEFAULT 0, `FracQuest2` INT(11) NOT NULL DEFAULT 0,
    `FracQuest3` INT(11) NOT NULL DEFAULT 0, `FracQuest4` INT(11) NOT NULL DEFAULT 0,
    `FracQuest5` INT(11) NOT NULL DEFAULT 0,
    `FracQuestExp1` INT(11) NOT NULL DEFAULT 0, `FracQuestExp2` INT(11) NOT NULL DEFAULT 0,
    `FracQuestExp3` INT(11) NOT NULL DEFAULT 0, `FracQuestExp4` INT(11) NOT NULL DEFAULT 0,
    `FracQuestExp5` INT(11) NOT NULL DEFAULT 0,
    `EndQuest8marta`     TINYINT(1) NOT NULL DEFAULT 0,
    `CongratulateWomen`  TINYINT(1) NOT NULL DEFAULT 0,
    `TakeFlower`         TINYINT(1) NOT NULL DEFAULT 0,
    `GivePerfume`        TINYINT(1) NOT NULL DEFAULT 0,
    `BuyPerfume`         TINYINT(1) NOT NULL DEFAULT 0,
    `BuyCake`            TINYINT(1) NOT NULL DEFAULT 0,
    `BuyCandle`          TINYINT(1) NOT NULL DEFAULT 0,
    `BuyProducts`        TINYINT(1) NOT NULL DEFAULT 0,
    `flower1` INT(11) NOT NULL DEFAULT 0, `flower2` INT(11) NOT NULL DEFAULT 0,
    `flower3` INT(11) NOT NULL DEFAULT 0,

    `AntiBh`            TINYINT(1)   NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_name` (`name`),
    KEY `idx_phone` (`phone`),
    KEY `idx_family` (`family`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `family`;
CREATE TABLE `family` (
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `name`          VARCHAR(64) NOT NULL DEFAULT '',
    `u_id`          INT(11) NOT NULL DEFAULT 0,
    `time`          INT(11) NOT NULL DEFAULT 0,
    `color`         INT(11) NOT NULL DEFAULT 0,
    `level`         INT(11) NOT NULL DEFAULT 1,
    `exp`           INT(11) NOT NULL DEFAULT 0,
    `score`         INT(11) NOT NULL DEFAULT 0,

    `rank1`  VARCHAR(32) NOT NULL DEFAULT 'Новичок',
    `rank2`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank3`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank4`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank5`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank6`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank7`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank8`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank9`  VARCHAR(32) NOT NULL DEFAULT '',
    `rank10` VARCHAR(32) NOT NULL DEFAULT 'Лидер',

    `pos_x`  FLOAT NOT NULL DEFAULT 0,
    `pos_y`  FLOAT NOT NULL DEFAULT 0,
    `pos_z`  FLOAT NOT NULL DEFAULT 0,
    `pos_fa` FLOAT NOT NULL DEFAULT 0,
    `inter`  INT(11) NOT NULL DEFAULT 0,
    `world`  INT(11) NOT NULL DEFAULT 0,

    `money`  INT(11) NOT NULL DEFAULT 0,
    `drugs`  INT(11) NOT NULL DEFAULT 0,
    `tree`   INT(11) NOT NULL DEFAULT 0,
    `metal`  INT(11) NOT NULL DEFAULT 0,
    `ammo`   INT(11) NOT NULL DEFAULT 0,

    `house_id`      INT(11) NOT NULL DEFAULT -1,
    `family_cars`   INT(11) NOT NULL DEFAULT 0,

    `r_TakeMoney`  INT(11) NOT NULL DEFAULT 1,
    `r_TakeDrugs`  INT(11) NOT NULL DEFAULT 1,
    `r_TakeMetall` INT(11) NOT NULL DEFAULT 1,
    `r_TakeAmmo`   INT(11) NOT NULL DEFAULT 1,
    `r_Inv`        INT(11) NOT NULL DEFAULT 1,
    `r_UnInv`      INT(11) NOT NULL DEFAULT 1,
    `r_Mute`       INT(11) NOT NULL DEFAULT 1,
    `r_UnMute`     INT(11) NOT NULL DEFAULT 1,
    `r_Warn`       INT(11) NOT NULL DEFAULT 1,
    `r_UnWarn`     INT(11) NOT NULL DEFAULT 1,
    `r_GiveRang`   INT(11) NOT NULL DEFAULT 1,

    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `family_cars`;
CREATE TABLE `family_cars` (
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `owner_id`      INT(11) NOT NULL DEFAULT 0,
    `family_owner`  INT(11) NOT NULL DEFAULT 0,
    `model_id`      INT(11) NOT NULL DEFAULT 0,
    `color_1`       INT(11) NOT NULL DEFAULT 0,
    `color_2`       INT(11) NOT NULL DEFAULT 0,
    `pos_x`         FLOAT NOT NULL DEFAULT 0,
    `pos_y`         FLOAT NOT NULL DEFAULT 0,
    `pos_z`         FLOAT NOT NULL DEFAULT 0,
    `angle`         FLOAT NOT NULL DEFAULT 0,
    `angle_last`    FLOAT NOT NULL DEFAULT 0,
    `pos_last_x`    FLOAT NOT NULL DEFAULT 0,
    `pos_last_y`    FLOAT NOT NULL DEFAULT 0,
    `pos_last_z`    FLOAT NOT NULL DEFAULT 0,
    `create_time`   INT(11) NOT NULL DEFAULT 0,
    `number`        VARCHAR(8) NOT NULL DEFAULT '',
    `number_type`   INT(11) NOT NULL DEFAULT 0,
    `region`        VARCHAR(8) NOT NULL DEFAULT '',
    `rang`          INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_family_owner` (`family_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `family_auto`;
CREATE TABLE `family_auto` (
    `id`        INT(11) NOT NULL AUTO_INCREMENT,
    `owner_id`  INT(11) NOT NULL DEFAULT 0,
    `pos_x`     FLOAT NOT NULL DEFAULT 0,
    `pos_y`     FLOAT NOT NULL DEFAULT 0,
    `pos_z`     FLOAT NOT NULL DEFAULT 0,
    `angle`     FLOAT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `family_ad`;
CREATE TABLE `family_ad` (
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `family`        INT(11) NOT NULL DEFAULT 0,
    `ad_text`       VARCHAR(255) NOT NULL DEFAULT '',
    `create_id`     INT(11) NOT NULL DEFAULT 0,
    `create_name`   VARCHAR(24) NOT NULL DEFAULT '',
    `time`          INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_family` (`family`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `family_log`;
CREATE TABLE `family_log` (
    `id`         INT(11) NOT NULL AUTO_INCREMENT,
    `family`     INT(11) NOT NULL DEFAULT 0,
    `player`     VARCHAR(24) NOT NULL DEFAULT '',
    `to_player`  VARCHAR(24) NOT NULL DEFAULT '',
    `type`       INT(11) NOT NULL DEFAULT 0,
    `text`       VARCHAR(255) NOT NULL DEFAULT '',
    `time`       INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_family` (`family`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `business`;
CREATE TABLE `business` (
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `owner_id`      INT(11) NOT NULL DEFAULT 0,
    `name`          VARCHAR(64) NOT NULL DEFAULT '',
    `improvements`  INT(11) NOT NULL DEFAULT 0,
    `products`      INT(11) NOT NULL DEFAULT 0,
    `prod_price`    INT(11) NOT NULL DEFAULT 0,
    `balance`       INT(11) NOT NULL DEFAULT 0,
    `rent_time`     INT(11) NOT NULL DEFAULT 0,
    `price`         INT(11) NOT NULL DEFAULT 0,
    `rent_price`    INT(11) NOT NULL DEFAULT 0,
    `type`          INT(11) NOT NULL DEFAULT 0,
    `interior`      INT(11) NOT NULL DEFAULT 0,
    `enter_price`   INT(11) NOT NULL DEFAULT 0,
    `enter_music`   INT(11) NOT NULL DEFAULT 0,
    `lock`          TINYINT(1) NOT NULL DEFAULT 0,
    `x`             FLOAT NOT NULL DEFAULT 0,
    `y`             FLOAT NOT NULL DEFAULT 0,
    `z`             FLOAT NOT NULL DEFAULT 0,
    `exit_x`        FLOAT NOT NULL DEFAULT 0,
    `exit_y`        FLOAT NOT NULL DEFAULT 0,
    `exit_z`        FLOAT NOT NULL DEFAULT 0,
    `exit_angle`    FLOAT NOT NULL DEFAULT 0,
    `eviction`      INT(11) NOT NULL DEFAULT 0,
    `progress_company` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `business_profit`;
CREATE TABLE `business_profit` (
    `id`    INT(11) NOT NULL AUTO_INCREMENT,
    `bid`   INT(11) NOT NULL DEFAULT 0,
    `uid`   INT(11) NOT NULL DEFAULT 0,
    `uip`   VARCHAR(16) NOT NULL DEFAULT '',
    `time`  INT(11) NOT NULL DEFAULT 0,
    `money` INT(11) NOT NULL DEFAULT 0,
    `view`  TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_bid` (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `business_gps`;
CREATE TABLE `business_gps` (
    `id`   INT(11) NOT NULL AUTO_INCREMENT,
    `bid`  INT(11) NOT NULL DEFAULT 0,
    `time` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `fuel_stations`;
CREATE TABLE `fuel_stations` (
    `id`              INT(11) NOT NULL AUTO_INCREMENT,
    `name`            VARCHAR(64) NOT NULL DEFAULT '',
    `owner_id`        INT(11) NOT NULL DEFAULT 0,
    `improvements`    INT(11) NOT NULL DEFAULT 0,
    `fuels`           INT(11) NOT NULL DEFAULT 0,
    `fuel_price`      INT(11) NOT NULL DEFAULT 0,
    `buy_fuel_price`  INT(11) NOT NULL DEFAULT 0,
    `balance`         INT(11) NOT NULL DEFAULT 0,
    `rent_time`       INT(11) NOT NULL DEFAULT 0,
    `price`           INT(11) NOT NULL DEFAULT 0,
    `rent_price`      INT(11) NOT NULL DEFAULT 0,
    `lock`            TINYINT(1) NOT NULL DEFAULT 0,
    `x`               FLOAT NOT NULL DEFAULT 0,
    `y`               FLOAT NOT NULL DEFAULT 0,
    `z`               FLOAT NOT NULL DEFAULT 0,
    `eviction`        INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `fuel_stations_profit`;
CREATE TABLE `fuel_stations_profit` (
    `id`    INT(11) NOT NULL AUTO_INCREMENT,
    `fid`   INT(11) NOT NULL DEFAULT 0,
    `uid`   INT(11) NOT NULL DEFAULT 0,
    `uip`   VARCHAR(16) NOT NULL DEFAULT '',
    `time`  INT(11) NOT NULL DEFAULT 0,
    `money` INT(11) NOT NULL DEFAULT 0,
    `view`  TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `hotels`;
CREATE TABLE `hotels` (
    `id`         INT(11) NOT NULL AUTO_INCREMENT,
    `hotel_id`   INT(11) NOT NULL DEFAULT 0,
    `owner_id`   INT(11) NOT NULL DEFAULT 0,
    `rent_time`  INT(11) NOT NULL DEFAULT 0,
    `status`     INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `houses`;
CREATE TABLE `houses` (
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `type`          INT(11) NOT NULL DEFAULT 0,
    `name`          VARCHAR(64) NOT NULL DEFAULT '',
    `owner_id`      INT(11) NOT NULL DEFAULT 0,
    `improvements`  INT(11) NOT NULL DEFAULT 0,
    `rent_time`     INT(11) NOT NULL DEFAULT 0,
    `price`         INT(11) NOT NULL DEFAULT 0,
    `rent_price`    INT(11) NOT NULL DEFAULT 0,
    `lock`          TINYINT(1) NOT NULL DEFAULT 0,
    `entrance`      INT(11) NOT NULL DEFAULT 0,
    `x`             FLOAT NOT NULL DEFAULT 0,
    `y`             FLOAT NOT NULL DEFAULT 0,
    `z`             FLOAT NOT NULL DEFAULT 0,
    `exit_x`        FLOAT NOT NULL DEFAULT 0,
    `exit_y`        FLOAT NOT NULL DEFAULT 0,
    `exit_z`        FLOAT NOT NULL DEFAULT 0,
    `exit_angle`    FLOAT NOT NULL DEFAULT 0,
    `car_x`         FLOAT NOT NULL DEFAULT 0,
    `car_y`         FLOAT NOT NULL DEFAULT 0,
    `car_z`         FLOAT NOT NULL DEFAULT 0,
    `car_angle`     FLOAT NOT NULL DEFAULT 0,
    `store_x`       FLOAT NOT NULL DEFAULT 0,
    `store_y`       FLOAT NOT NULL DEFAULT 0,
    `store_z`       FLOAT NOT NULL DEFAULT 0,
    `eviction`      INT(11) NOT NULL DEFAULT 0,
    `store_metall`  INT(11) NOT NULL DEFAULT 0,
    `store_drugs`   INT(11) NOT NULL DEFAULT 0,
    `store_weapon`  INT(11) NOT NULL DEFAULT 0,
    `store_ammo`    INT(11) NOT NULL DEFAULT 0,
    `store_skin`    INT(11) NOT NULL DEFAULT 0,
    `flat_floor`    INT(11) NOT NULL DEFAULT 0,
    `flat_number`   INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `houses_renters`;
CREATE TABLE `houses_renters` (
    `id`         INT(11) NOT NULL AUTO_INCREMENT,
    `owner_id`   INT(11) NOT NULL DEFAULT 0,
    `house_id`   INT(11) NOT NULL DEFAULT 0,
    `room_id`    INT(11) NOT NULL DEFAULT 0,
    `rent_time`  INT(11) NOT NULL DEFAULT 0,
    `time`       INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_house` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `entrances`;
CREATE TABLE `entrances` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `floors`      INT(11) NOT NULL DEFAULT 1,
    `pos_x`       FLOAT NOT NULL DEFAULT 0,
    `pos_y`       FLOAT NOT NULL DEFAULT 0,
    `pos_z`       FLOAT NOT NULL DEFAULT 0,
    `exit_x`      FLOAT NOT NULL DEFAULT 0,
    `exit_y`      FLOAT NOT NULL DEFAULT 0,
    `exit_z`      FLOAT NOT NULL DEFAULT 0,
    `exit_angle`  FLOAT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `ownable_cars`;
CREATE TABLE `ownable_cars` (
    `id`             INT(11) NOT NULL AUTO_INCREMENT,
    `owner_id`       INT(11) NOT NULL DEFAULT 0,
    `model_id`       INT(11) NOT NULL DEFAULT 0,
    `color_1`        INT(11) NOT NULL DEFAULT 0,
    `color_2`        INT(11) NOT NULL DEFAULT 0,
    `pos_x`          FLOAT NOT NULL DEFAULT 0,
    `pos_y`          FLOAT NOT NULL DEFAULT 0,
    `pos_z`          FLOAT NOT NULL DEFAULT 0,
    `angle`          FLOAT NOT NULL DEFAULT 0,
    `create_time`    INT(11) NOT NULL DEFAULT 0,
    `status`         INT(11) NOT NULL DEFAULT 0,
    `alarm`          TINYINT(1) NOT NULL DEFAULT 0,
    `key_in`         TINYINT(1) NOT NULL DEFAULT 0,
    `mileage`        FLOAT NOT NULL DEFAULT 0,
    `vinilcar`       INT(11) NOT NULL DEFAULT 0,
    `pt_engine`      INT(11) NOT NULL DEFAULT 0,
    `pt_brake`       INT(11) NOT NULL DEFAULT 0,
    `pt_stability`   INT(11) NOT NULL DEFAULT 0,
    `nitro`          INT(11) NOT NULL DEFAULT 0,
    `launch`         INT(11) NOT NULL DEFAULT 0,
    `fars`           INT(11) NOT NULL DEFAULT 0,
    `diski`          INT(11) NOT NULL DEFAULT 0,
    `fuel`           FLOAT NOT NULL DEFAULT 100,
    `number`         VARCHAR(8) NOT NULL DEFAULT '',
    `number_type`    INT(11) NOT NULL DEFAULT 0,
    `region`         VARCHAR(8) NOT NULL DEFAULT '',
    `vehicle_id`     INT(11) NOT NULL DEFAULT -1,
    `unload_x`       FLOAT NOT NULL DEFAULT 0,
    `unload_y`       FLOAT NOT NULL DEFAULT 0,
    `unload_z`       FLOAT NOT NULL DEFAULT 0,
    `unload_angle`   FLOAT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `ownable_cars_lighting`;
CREATE TABLE IF NOT EXISTS `ownable_cars_lighting` (
    `oc_id`             INT NOT NULL,
    `high_light`        TINYINT NOT NULL DEFAULT 0,
    `stroboscope_type`  INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`oc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS `ownable_cars_radial`;
CREATE TABLE IF NOT EXISTS `ownable_cars_radial` (
    `oc_id`             INT NOT NULL,
    `chip_drift`        TINYINT NOT NULL DEFAULT 0,
    `chip_comfort`      TINYINT NOT NULL DEFAULT 0,
    `chip_sport`        TINYINT NOT NULL DEFAULT 0,
    `chip_sportplus`    TINYINT NOT NULL DEFAULT 0,
    `has_pneumo`        TINYINT NOT NULL DEFAULT 0,
    `has_hydraulics`    TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`oc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS `trunks`;
CREATE TABLE `trunks` (
    `id`       INT(11) NOT NULL AUTO_INCREMENT,
    `oc_id`    INT(11) NOT NULL DEFAULT 0,
    `item_id`  INT(11) NOT NULL DEFAULT 0,
    `amount`   INT(11) NOT NULL DEFAULT 0,
    `value`    INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_oc` (`oc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `car_obmen`;
CREATE TABLE `car_obmen` (
    `id`     INT(11) NOT NULL AUTO_INCREMENT,
    `car_1`  INT(11) NOT NULL DEFAULT 0,
    `car_2`  INT(11) NOT NULL DEFAULT 0,
    `car_3`  INT(11) NOT NULL DEFAULT 0,
    `car_4`  INT(11) NOT NULL DEFAULT 0,
    `car_5`  INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `player_number_inventory`;
CREATE TABLE `player_number_inventory` (
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `player_id`     INT(11) NOT NULL DEFAULT 0,
    `plate_number`  VARCHAR(16) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`),
    KEY `idx_player` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `taxi_parks`;
CREATE TABLE IF NOT EXISTS `taxi_parks` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `type`        INT(11) NOT NULL DEFAULT 1,
    `owner_id`    INT(11) NOT NULL DEFAULT 0,
    `price`       INT(11) NOT NULL DEFAULT 0,
    `rent_price`  INT(11) NOT NULL DEFAULT 0,
    `enter_x`     FLOAT NOT NULL DEFAULT 0,
    `enter_y`     FLOAT NOT NULL DEFAULT 0,
    `enter_z`     FLOAT NOT NULL DEFAULT 0,
    `exit_x`      FLOAT NOT NULL DEFAULT 0,
    `exit_y`      FLOAT NOT NULL DEFAULT 0,
    `exit_z`      FLOAT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `player_inventory`;
CREATE TABLE `player_inventory` (
    `id`             INT(11) NOT NULL AUTO_INCREMENT,
    `player_id`      INT(11) NOT NULL DEFAULT 0,
    `slot`           INT(11) NOT NULL DEFAULT 0,
    `item_id`        INT(11) NOT NULL DEFAULT 0,
    `item_count`     INT(11) NOT NULL DEFAULT 0,
    `item_plate`     VARCHAR(32) NOT NULL DEFAULT '',
    `is_active`      TINYINT(1) NOT NULL DEFAULT 0,
    `active_slot`    INT(11) NOT NULL DEFAULT -1,
    PRIMARY KEY (`id`),
    KEY `idx_player` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `inventory_skins`;
CREATE TABLE `inventory_skins` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `owner_skin`  INT(11) NOT NULL DEFAULT 0,
    `skin_id`     INT(11) NOT NULL DEFAULT 0,
    `use_skin`    TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner_skin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `inventory_accessories`;
CREATE TABLE `inventory_accessories` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `account_id`  INT(11) NOT NULL DEFAULT 0,
    `modelid`     INT(11) NOT NULL DEFAULT 0,
    `bone`        INT(11) NOT NULL DEFAULT 0,
    `pos_x`       FLOAT NOT NULL DEFAULT 0,
    `pos_y`       FLOAT NOT NULL DEFAULT 0,
    `pos_z`       FLOAT NOT NULL DEFAULT 0,
    `rot_x`       FLOAT NOT NULL DEFAULT 0,
    `rot_y`       FLOAT NOT NULL DEFAULT 0,
    `rot_z`       FLOAT NOT NULL DEFAULT 0,
    `scale_x`     FLOAT NOT NULL DEFAULT 1,
    `scale_y`     FLOAT NOT NULL DEFAULT 1,
    `scale_z`     FLOAT NOT NULL DEFAULT 1,
    `in_use`      TINYINT(1) NOT NULL DEFAULT 0,
    `slot`        INT(11) NOT NULL DEFAULT -1,
    PRIMARY KEY (`id`),
    KEY `idx_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `accessories`;
CREATE TABLE `accessories` (
    `id`       INT(11) NOT NULL AUTO_INCREMENT,
    `modelid`  INT(11) NOT NULL DEFAULT 0,
    `slot`     INT(11) NOT NULL DEFAULT 0,
    `bone`     INT(11) NOT NULL DEFAULT 0,
    `x`        FLOAT NOT NULL DEFAULT 0,
    `y`        FLOAT NOT NULL DEFAULT 0,
    `z`        FLOAT NOT NULL DEFAULT 0,
    `rX`       FLOAT NOT NULL DEFAULT 0,
    `rY`       FLOAT NOT NULL DEFAULT 0,
    `rZ`       FLOAT NOT NULL DEFAULT 0,
    `scale`    FLOAT NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `accessories_players`;
CREATE TABLE IF NOT EXISTS `accessories_players` (
    `id`         INT NOT NULL AUTO_INCREMENT,
    `player_id`  INT(11) NOT NULL,
    `slot`       INT(11) NOT NULL,
    `bone`       INT(11) NOT NULL,
    `acs_id`     INT(11) NOT NULL,
    `x`          FLOAT NOT NULL DEFAULT 0.01,
    `y`          FLOAT NOT NULL DEFAULT 0.01,
    `z`          FLOAT NOT NULL DEFAULT 0.01,
    `rX`         FLOAT NOT NULL DEFAULT 0.01,
    `rY`         FLOAT NOT NULL DEFAULT 0.01,
    `rZ`         FLOAT NOT NULL DEFAULT 0.01,
    `scale`      FLOAT NOT NULL DEFAULT 1.01,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `accessory_inventory`;
CREATE TABLE IF NOT EXISTS `accessory_inventory` (
    `id`         INT NOT NULL AUTO_INCREMENT,
    `player_id`  INT NOT NULL,
    `acs_id`     INT NOT NULL,
    `use`        INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `bank_accounts`;
CREATE TABLE `bank_accounts` (
    `id`        INT(11) NOT NULL AUTO_INCREMENT,
    `uid`       INT(11) NOT NULL DEFAULT 0,
    `name`      VARCHAR(64) NOT NULL DEFAULT '',
    `pin`       VARCHAR(8) NOT NULL DEFAULT '',
    `balance`   INT(11) NOT NULL DEFAULT 0,
    `reg_time`  INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `bank_accounts_log`;
CREATE TABLE `bank_accounts_log` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `acc_id`       INT(11) NOT NULL DEFAULT 0,
    `uip`          VARCHAR(16) NOT NULL DEFAULT '',
    `time`         INT(11) NOT NULL DEFAULT 0,
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`),
    KEY `idx_acc` (`acc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `phone_books`;
CREATE TABLE `phone_books` (
    `id`        INT(11) NOT NULL AUTO_INCREMENT,
    `owner_id`  INT(11) NOT NULL DEFAULT 0,
    `name`      VARCHAR(24) NOT NULL DEFAULT '',
    `number`    VARCHAR(16) NOT NULL DEFAULT '',
    `time`      INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `player_sim_cards`;
CREATE TABLE `player_sim_cards` (
    `id`         INT(11) NOT NULL AUTO_INCREMENT,
    `player_id`  INT(11) NOT NULL DEFAULT 0,
    `number`     VARCHAR(16) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`),
    KEY `idx_player` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `player_sim_inventory`;
CREATE TABLE IF NOT EXISTS `player_sim_inventory` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `player_id`   INT(11) NOT NULL,
    `sim_number`  VARCHAR(16) NOT NULL,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `unitpay_payments`;
CREATE TABLE `unitpay_payments` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `account`     VARCHAR(24) NOT NULL DEFAULT '',
    `sum`         INT(11) NOT NULL DEFAULT 0,
    `currency`    VARCHAR(8) NOT NULL DEFAULT 'RUB',
    `status`      TINYINT(1) NOT NULL DEFAULT 0,
    `activated`   TINYINT(1) NOT NULL DEFAULT 0,
    `time`        INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `player_promos`;
DROP TABLE IF EXISTS `promo_prizes`;
DROP TABLE IF EXISTS `activated_promos`;
DROP TABLE IF EXISTS `promocodes`;

CREATE TABLE `promocodes` (
    `id`                  INT NOT NULL AUTO_INCREMENT,
    `code`                VARCHAR(32) NOT NULL UNIQUE,
    `uses_limit`          INT NOT NULL DEFAULT 1,
    `uses_left`           INT NOT NULL DEFAULT 1,
    `num_prizes`          TINYINT(1) NOT NULL DEFAULT 1,
    `activations`         INT NOT NULL DEFAULT 0,
    `promo_level`         INT NOT NULL DEFAULT -1,
    `promo_balance`       INT NOT NULL DEFAULT 0,
    `creator_account_id`  INT NOT NULL DEFAULT 0,
    `creation_cost`       INT NOT NULL DEFAULT 0,
    `created_at`          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `activated_promos` (
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `account_id`    INT(11) NOT NULL,
    `promo_id`      INT(11) NOT NULL,
    `activated_at`  DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `account_promo` (`account_id`, `promo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `promo_prizes` (
    `id`              INT NOT NULL AUTO_INCREMENT,
    `promo_id`        INT NOT NULL,
    `prize_index`     TINYINT(1) NOT NULL,
    `prize_type`      TINYINT(1) NOT NULL DEFAULT '0',
    `prize_value`     INT NOT NULL DEFAULT '0',
    `prize_duration`  INT NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY `promo_prize_unique` (`promo_id`, `prize_index`),
    FOREIGN KEY (`promo_id`) REFERENCES `promocodes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `player_promos` (
    `id`                    INT NOT NULL AUTO_INCREMENT,
    `account_id`            INT NOT NULL,
    `promo_prize_sql_id`    INT NOT NULL,
    `start_time`            INT NOT NULL,
    `remaining_time`        INT NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `account_promo_prize_unique` (`account_id`, `promo_prize_sql_id`),
    FOREIGN KEY (`promo_prize_sql_id`) REFERENCES `promo_prizes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `dev_promocode_activations`;
DROP TABLE IF EXISTS `dev_promocodes`;

CREATE TABLE `dev_promocodes` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `code`        VARCHAR(32) NOT NULL UNIQUE,
    `money`       INT NOT NULL DEFAULT 0,
    `donate`      INT NOT NULL DEFAULT 0,
    `exp`         INT NOT NULL DEFAULT 0,
    `created_by`  INT NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dev_promocode_activations` (
    `id`            INT NOT NULL AUTO_INCREMENT,
    `account_id`    INT NOT NULL,
    `promo_id`      INT NOT NULL,
    `activated_at`  DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `account_promo` (`account_id`, `promo_id`),
    FOREIGN KEY (`promo_id`) REFERENCES `dev_promocodes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `promocode`;
CREATE TABLE `promocode` (
    `id`      INT(11) NOT NULL AUTO_INCREMENT,
    `code`    VARCHAR(32) NOT NULL DEFAULT '',
    `type`    INT(11) NOT NULL DEFAULT 0,
    `amount`  INT(11) NOT NULL DEFAULT 0,
    `usings`  INT(11) NOT NULL DEFAULT 0,
    `paydays` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `promocode_activations`;
CREATE TABLE `promocode_activations` (
    `id`       INT(11) NOT NULL AUTO_INCREMENT,
    `uid`      INT(11) NOT NULL DEFAULT 0,
    `uip`      VARCHAR(16) NOT NULL DEFAULT '',
    `code`     VARCHAR(32) NOT NULL DEFAULT '',
    `paydays`  INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `ytpromocode`;
CREATE TABLE `ytpromocode` (
    `id`      INT(11) NOT NULL AUTO_INCREMENT,
    `code`    VARCHAR(32) NOT NULL DEFAULT '',
    `type`    INT(11) NOT NULL DEFAULT 0,
    `amount`  INT(11) NOT NULL DEFAULT 0,
    `usings`  INT(11) NOT NULL DEFAULT 0,
    `paydays` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `ytpromocode_activations`;
CREATE TABLE `ytpromocode_activations` (
    `id`       INT(11) NOT NULL AUTO_INCREMENT,
    `uid`      INT(11) NOT NULL DEFAULT 0,
    `uip`      VARCHAR(16) NOT NULL DEFAULT '',
    `code`     VARCHAR(32) NOT NULL DEFAULT '',
    `paydays`  INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `auction_lots`;
CREATE TABLE IF NOT EXISTS `auction_lots` (
    `slot`             INT NOT NULL,
    `slot_type`        INT NOT NULL DEFAULT 0,
    `owner_slot_sql`   INT NOT NULL DEFAULT -1,
    `owner_slot_name`  VARCHAR(24) NOT NULL DEFAULT '-',
    `slot_name`        VARCHAR(24) NOT NULL DEFAULT '-',
    `opisanie_slot`    VARCHAR(124) NOT NULL DEFAULT '-',
    `owner_rate`       INT NOT NULL DEFAULT -1,
    `start_rate`       INT NOT NULL DEFAULT 0,
    `current_rate`     INT NOT NULL DEFAULT 0,
    `timer_end`        INT NOT NULL DEFAULT 0,
    `database_id`      INT NOT NULL DEFAULT -1,
    `server_id`        INT NOT NULL DEFAULT -1,
    `number_vehicle`   VARCHAR(7) NOT NULL DEFAULT '-',
    `number_sum`       INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS `reports_list`;
CREATE TABLE IF NOT EXISTS `reports_list` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `status`      INT(11) NOT NULL DEFAULT 0,
    `answer`      TEXT NOT NULL,
    `player_name` VARCHAR(24) NOT NULL,
    `player_id`   INT(11) NOT NULL DEFAULT 0,
    `text`        TEXT NOT NULL,
    `date`        DATETIME NOT NULL,
    `admin`       INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `ban_list`;
CREATE TABLE `ban_list` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `user_id`      INT(11) NOT NULL DEFAULT 0,
    `time`         INT(11) NOT NULL DEFAULT 0,
    `ban_time`     INT(11) NOT NULL DEFAULT 0,
    `ip`           VARCHAR(16) NOT NULL DEFAULT '',
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    `admin`        VARCHAR(24) NOT NULL DEFAULT '',
    `admin_name`   VARCHAR(24) NOT NULL DEFAULT '',
    `player_name`  VARCHAR(24) NOT NULL DEFAULT '',
    `unban_date`   INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `logs_anticheat`;
CREATE TABLE `logs_anticheat` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `player_id`    INT(11) NOT NULL DEFAULT 0,
    `player_name`  VARCHAR(24) NOT NULL DEFAULT '',
    `ip`           VARCHAR(16) NOT NULL DEFAULT '',
    `time`         INT(11) NOT NULL DEFAULT 0,
    `money`        INT(11) NOT NULL DEFAULT 0,
    `bank`         INT(11) NOT NULL DEFAULT 0,
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `logs_deleted_accounts`;
CREATE TABLE `logs_deleted_accounts` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `account_id`   INT(11) NOT NULL DEFAULT 0,
    `player_name`  VARCHAR(24) NOT NULL DEFAULT '',
    `admin_id`     INT(11) NOT NULL DEFAULT 0,
    `admin_name`   VARCHAR(24) NOT NULL DEFAULT '',
    `ip`           VARCHAR(16) NOT NULL DEFAULT '',
    `time`         INT(11) NOT NULL DEFAULT 0,
    `reason`       VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `aclogs`;
CREATE TABLE `aclogs` (
    `id`      INT(11) NOT NULL AUTO_INCREMENT,
    `name`    VARCHAR(24) NOT NULL DEFAULT '',
    `type`    INT(11) NOT NULL DEFAULT 0,
    `reason`  VARCHAR(255) NOT NULL DEFAULT '',
    `data`    TEXT NULL,
    `date`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `action_log`;
CREATE TABLE `action_log` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `acc_id`       INT(11) NOT NULL DEFAULT 0,
    `uip`          VARCHAR(16) NOT NULL DEFAULT '',
    `type`         INT(11) NOT NULL DEFAULT 0,
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    `time`         INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `money_log`;
CREATE TABLE `money_log` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `uid`          INT(11) NOT NULL DEFAULT 0,
    `uip`          VARCHAR(16) NOT NULL DEFAULT '',
    `time`         INT(11) NOT NULL DEFAULT 0,
    `money`        INT(11) NOT NULL DEFAULT 0,
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `donate_log`;
CREATE TABLE `donate_log` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `uid`          INT(11) NOT NULL DEFAULT 0,
    `uip`          VARCHAR(16) NOT NULL DEFAULT '',
    `time`         INT(11) NOT NULL DEFAULT 0,
    `donate`       INT(11) NOT NULL DEFAULT 0,
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `change_names`;
CREATE TABLE `change_names` (
    `id`        INT(11) NOT NULL AUTO_INCREMENT,
    `owner_id`  INT(11) NOT NULL DEFAULT 0,
    `name`      VARCHAR(24) NOT NULL DEFAULT '',
    `time`      INT(11) NOT NULL DEFAULT 0,
    `ip`        VARCHAR(16) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `debug`;
CREATE TABLE `debug` (
    `id`    INT(11) NOT NULL AUTO_INCREMENT,
    `text`  TEXT NULL,
    `date`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `tickets`;
CREATE TABLE `tickets` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `uid`          INT(11) NOT NULL DEFAULT 0,
    `amount`       INT(11) NOT NULL DEFAULT 0,
    `issuer`       VARCHAR(24) NOT NULL DEFAULT '',
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    `status`       INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `charity`;
CREATE TABLE `charity` (
    `id`     INT(11) NOT NULL AUTO_INCREMENT,
    `uid`    INT(11) NOT NULL DEFAULT 0,
    `money`  INT(11) NOT NULL DEFAULT 0,
    `time`   INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `gift`;
CREATE TABLE `gift` (
    `id`  INT(11) NOT NULL AUTO_INCREMENT,
    `x`   FLOAT NOT NULL DEFAULT 0,
    `y`   FLOAT NOT NULL DEFAULT 0,
    `z`   FLOAT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `gift_lose`;
CREATE TABLE `gift_lose` (
    `id`        INT(11) NOT NULL AUTO_INCREMENT,
    `uid`       INT(11) NOT NULL DEFAULT 0,
    `gift_id`   INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `return_money`;
CREATE TABLE `return_money` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `uid`          INT(11) NOT NULL DEFAULT 0,
    `money`        INT(11) NOT NULL DEFAULT 0,
    `description`  VARCHAR(255) NOT NULL DEFAULT '',
    `status`       INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
    `id`       INT(11) NOT NULL AUTO_INCREMENT,
    `type`     INT(11) NOT NULL DEFAULT 0,
    `company`  INT(11) NOT NULL DEFAULT 0,
    `amount`   INT(11) NOT NULL DEFAULT 0,
    `price`    INT(11) NOT NULL DEFAULT 0,
    `time`     INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `repositories`;
CREATE TABLE `repositories` (
    `id`      INT(11) NOT NULL AUTO_INCREMENT,
    `amount`  INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `gang_zones`;
CREATE TABLE `gang_zones` (
    `id`        INT(11) NOT NULL AUTO_INCREMENT,
    `fraction`  INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `leaders`;
CREATE TABLE `leaders` (
    `id`          INT(11) NOT NULL AUTO_INCREMENT,
    `frac_id`     INT(11) NOT NULL DEFAULT 0,
    `accout_id`   INT(11) NOT NULL DEFAULT 0,
    `name`        VARCHAR(24) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `quick_message`;
CREATE TABLE `quick_message` (
    `id`    INT(11) NOT NULL AUTO_INCREMENT,
    `name`  VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
    `id`               INT(11) NOT NULL,
    `gfx_water`        TINYINT(1) NOT NULL DEFAULT 1,
    `gfx_reflections`  TINYINT(1) NOT NULL DEFAULT 1,
    `gfx_distance`     INT(11) NOT NULL DEFAULT 300,
    `gfx_sky`          TINYINT(1) NOT NULL DEFAULT 1,
    `gfx_aa`           TINYINT(1) NOT NULL DEFAULT 1,
    `gfx_lower_dd`     TINYINT(1) NOT NULL DEFAULT 0,
    `gfx_lower_cars`   TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;