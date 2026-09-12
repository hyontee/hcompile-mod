CREATE TABLE IF NOT EXISTS `family_war_seasons`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `active` TINYINT NOT NULL DEFAULT 0,
    `start_time` INT NOT NULL DEFAULT 0,
    `end_time` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `active` (`active`)
);

CREATE TABLE IF NOT EXISTS `family_wars`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `season_id` INT NOT NULL,
    `family1_id` INT NOT NULL,
    `family2_id` INT NOT NULL,

    `start_time` INT NOT NULL,
    `actual_start` INT NOT NULL DEFAULT 0,
    `actual_end` INT NOT NULL DEFAULT 0,

    `duration` INT NOT NULL DEFAULT 900,
    `target_score` INT NOT NULL DEFAULT 50,

    `status` INT NOT NULL DEFAULT 1,

    `score1` INT NOT NULL DEFAULT 0,
    `score2` INT NOT NULL DEFAULT 0,

    `winner_family_id` INT NOT NULL DEFAULT 0,
    `mvp_account_id` INT NOT NULL DEFAULT 0,

    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    KEY `season_id` (`season_id`),
    KEY `family1_id` (`family1_id`),
    KEY `family2_id` (`family2_id`),
    KEY `status_start` (`status`,`start_time`)
);

CREATE TABLE IF NOT EXISTS `family_war_roster`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `war_id` INT NOT NULL,
    `family_id` INT NOT NULL,
    `account_id` INT NOT NULL,
    `player_name` VARCHAR(24) NOT NULL,
    `registered_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `war_account` (`war_id`,`account_id`),
    KEY `war_family` (`war_id`,`family_id`)
);

CREATE TABLE IF NOT EXISTS `family_war_kills`
(
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `war_id` INT NOT NULL,
    `killer_account_id` INT NOT NULL,
    `victim_account_id` INT NOT NULL,
    `killer_family_id` INT NOT NULL,
    `victim_family_id` INT NOT NULL,
    `weapon_id` INT NOT NULL DEFAULT 0,
    `created_at` INT NOT NULL,

    PRIMARY KEY (`id`),
    KEY `war_id` (`war_id`),
    KEY `killer_account_id` (`killer_account_id`)
);

CREATE TABLE IF NOT EXISTS `family_war_player_results`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `war_id` INT NOT NULL,
    `season_id` INT NOT NULL,
    `family_id` INT NOT NULL,
    `account_id` INT NOT NULL,
    `kills` INT NOT NULL DEFAULT 0,
    `deaths` INT NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`),
    UNIQUE KEY `war_player` (`war_id`,`account_id`),
    KEY `season_id` (`season_id`),
    KEY `family_id` (`family_id`)
);

CREATE TABLE IF NOT EXISTS `family_war_family_stats`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `season_id` INT NOT NULL,
    `family_id` INT NOT NULL,

    `points` INT NOT NULL DEFAULT 0,
    `wins` INT NOT NULL DEFAULT 0,
    `losses` INT NOT NULL DEFAULT 0,
    `draws` INT NOT NULL DEFAULT 0,

    `kills` INT NOT NULL DEFAULT 0,
    `deaths` INT NOT NULL DEFAULT 0,
    `wars` INT NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`),
    UNIQUE KEY `season_family` (`season_id`,`family_id`)
);

CREATE TABLE IF NOT EXISTS `family_war_player_stats`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `season_id` INT NOT NULL,
    `account_id` INT NOT NULL,
    `family_id` INT NOT NULL,

    `kills` INT NOT NULL DEFAULT 0,
    `deaths` INT NOT NULL DEFAULT 0,
    `wars` INT NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`),
    UNIQUE KEY `season_player` (`season_id`,`account_id`),
    KEY `family_id` (`family_id`)
);

CREATE TABLE IF NOT EXISTS `family_containers`
(
    `family_id` INT NOT NULL,
    `container_type` INT NOT NULL,
    `amount` INT NOT NULL DEFAULT 0,

    PRIMARY KEY (`family_id`,`container_type`)
);

INSERT INTO `family_war_seasons`
(`name`,`active`,`start_time`)
SELECT 'Season 1',1,UNIX_TIMESTAMP()
WHERE NOT EXISTS
(
    SELECT 1 FROM `family_war_seasons` WHERE `active`=1
);
