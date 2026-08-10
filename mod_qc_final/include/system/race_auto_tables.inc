// Auto-generated database bootstrap for RACE RUSSIA.
// Creates base SQL tables from bdnewsile.sql if they do not exist.
#if defined _race_auto_tables_included
    #endinput
#endif
#define _race_auto_tables_included

stock RaceDB_RunCreateQuery(const race_db_query[])
{
    mysql_tquery(mysql, race_db_query);
    return 1;
}

stock RaceDatabase_EnsureAllTables()
{
    mysql_tquery(mysql, "SET NAMES cp1251");
    // 1. accessories
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `accessories` ( `id` int(11) NOT NULL, `slot` int(11) NOT NULL, `modelid` int(11) NOT NULL, `bone` int(11) NOT NULL, `x` float NOT NULL DEFAULT 0, `y` float NOT NULL DEFAULT 0, `z` float NOT NULL DEFAULT 0, `rX` float NOT NULL DEFAULT 0, `rY` float NOT NULL DEFAULT 0, `rZ` float NOT NULL DEFAULT 0, `scale` float NOT NULL DEFAULT 1, UNIQUE KEY `account_slot` (`id`,`slot`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 2. accounts
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `accounts` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(24) NOT NULL, `password` varchar(65) NOT NULL, `salt` varchar(10) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL, `email` varchar(61) NOT NULL DEFAULT 'None', `confirm_email` int(11) NOT NULL, `level` int(11) NOT NULL DEFAULT 1, `weekly_prizes` text NOT NULL DEFAULT '0,0,0,0,0,0,0', `weekly_day` int(11) NOT NULL");
        strcat(race_db_query, "DEFAULT 0, `exp` int(11) NOT NULL, `refer` int(11) NOT NULL, `sex` int(11) NOT NULL, `skin` int(11) NOT NULL, `money` int(11) NOT NULL, `roulette_auto` int(11) NOT NULL DEFAULT 0, `roulette_silver` int(11) NOT NULL DEFAULT 0, `roulette_gold` int(11) NOT NULL DEFAULT 0, `satiety` int(11) NOT NULL DEFAULT 100, `roulette_bronz` int(11) NOT NULL DEFAULT 0, `bank` int(11) NOT NULL, `admin` int(11) NOT NULL, `post`");
        strcat(race_db_query, "int(11) NOT NULL, `family_id` int(11) NOT NULL DEFAULT -1, `family_rang` int(11) NOT NULL DEFAULT 1, `family_mute` int(11) NOT NULL, `family_access` varchar(24) NOT NULL DEFAULT '0,0,0,0,0,0,0', `a_secret` int(11) NOT NULL, `prefix` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '[A]', `a_3d_prefix` int(11) NOT NULL, `admin_warn` int(11) NOT NULL, `AdminPass` int(11) NOT NULL,");
        strcat(race_db_query, "`driving_lic` int(11) NOT NULL, `weapon_lic` int(11) NOT NULL, `suspect` int(11) NOT NULL, `phone` int(11) NOT NULL, `phone_balance` int(11) NOT NULL, `phone_color` int(11) NOT NULL DEFAULT 9, `law_abiding` int(11) NOT NULL, `improvements` int(11) NOT NULL, `power` int(11) NOT NULL, `drugs` int(11) NOT NULL, `ammo` int(11) NOT NULL, `metall` int(11) NOT NULL, `wife` int(11) NOT NULL, `team` int(11) NOT NULL,");
        strcat(race_db_query, "`subdivison` int(11) NOT NULL, `wage` int(11) NOT NULL, `job` int(11) NOT NULL, `progress_company` float NOT NULL DEFAULT 1, `t_company` int(11) NOT NULL DEFAULT -1, `tc_owner` int(11) NOT NULL DEFAULT -1, `house_type` int(11) NOT NULL DEFAULT -1, `house_room` int(11) NOT NULL DEFAULT -1, `house` int(11) NOT NULL DEFAULT -1, `business` int(11) NOT NULL DEFAULT -1, `fuel_st` int(11) NOT NULL DEFAULT -1, `reg_time`");
        strcat(race_db_query, "int(11) NOT NULL, `reg_ip` varchar(16) NOT NULL, `last_ip` varchar(16) NOT NULL, `last_login` int(11) NOT NULL, `game_for_hour` int(11) NOT NULL, `game_for_day` int(11) NOT NULL, `game_for_day_prev` int(11) NOT NULL, `setting_phone` varchar(13) NOT NULL DEFAULT 'None', `setting_pin_code` varchar(5) NOT NULL DEFAULT 'None', `request_phone` int(11) NOT NULL, `request_pin` int(11) NOT NULL, `setting1` int(11) NOT NULL");
        strcat(race_db_query, "DEFAULT 2, `setting2` int(11) NOT NULL DEFAULT 1, `setting4` int(11) NOT NULL DEFAULT 1, `setting5` int(11) NOT NULL DEFAULT 0, `setting6` int(11) NOT NULL DEFAULT 1, `warn` int(11) NOT NULL, `warn_time` int(11) NOT NULL, `mute` int(11) NOT NULL, `skill_colt` int(11) NOT NULL, `skill_sdpistol` int(11) NOT NULL, `skill_deagle` int(11) NOT NULL, `skill_shotgun` int(11) NOT NULL, `skill_mp5` int(11) NOT NULL,");
        strcat(race_db_query, "`skill_ak47` int(11) NOT NULL, `skill_m4` int(11) NOT NULL, `skill_sniper_rifle` int(11) NOT NULL, `skill_sawnoff` int(11) NOT NULL, `skill_combat_sg` int(11) NOT NULL, `skill_micro_uzi` int(11) NOT NULL, `donate_current` int(11) NOT NULL, `donate_total` int(11) NOT NULL, `org_skin` int(11) NOT NULL, `setting_spawn` int(11) NOT NULL, `hospital` int(11) NOT NULL, `health` float NOT NULL DEFAULT 100, `car_slots`");
        strcat(race_db_query, "int(11) NOT NULL DEFAULT 1, `jail` int(11) NOT NULL, `premium` int(11) NOT NULL, `premium_date` int(11) NOT NULL, `rub` int(11) NOT NULL, `player` int(11) NOT NULL, `gifts` int(11) NOT NULL, `cmdaccess` varchar(32) NOT NULL DEFAULT '000000000000000', `family` int(11) NOT NULL, `family_rank` int(11) NOT NULL, `test` int(11) NOT NULL, `quest_1` int(11) NOT NULL, `quest_2` int(11) NOT NULL, `quest_3` int(11) NOT NULL,");
        strcat(race_db_query, "`quest_4` int(11) NOT NULL, `quest_5` int(11) NOT NULL, `quest_6` int(11) NOT NULL, `quest_7` int(11) NOT NULL, `quest_8` int(11) NOT NULL, `quest_exp_1` int(11) NOT NULL, `quest_exp_2` int(11) NOT NULL, `quest_exp_3` int(11) NOT NULL, `quest_exp_4` int(11) NOT NULL, `quest_exp_5` int(11) NOT NULL, `quest_exp_6` int(11) NOT NULL, `quest_exp_7` int(11) NOT NULL, `quest_exp_8` int(11) NOT NULL, `youtube` int(11) NOT");
        strcat(race_db_query, "NULL, `AntiBh` int(11) NOT NULL, `get_adm_status` int(11) NOT NULL DEFAULT 0, `get_adm_hour` int(11) NOT NULL DEFAULT 0, `online` int(11) NOT NULL DEFAULT 0, `totalhour` int(11) DEFAULT NULL, `quest231` int(11) NOT NULL DEFAULT 0, `quest232` int(11) NOT NULL DEFAULT 0, `quest233` int(11) NOT NULL, `postcard` int(11) NOT NULL, `repcarid` int(11) NOT NULL, `helper` int(11) NOT NULL, `healme` int(11) NOT NULL,");
        strcat(race_db_query, "`QuestBox1` int(11) NOT NULL, `QuestBox2` int(11) NOT NULL, `QuestBox3` int(11) NOT NULL, `QuestBox4` int(11) NOT NULL, `QuestBox5` int(11) NOT NULL, `QuestBox6` int(11) NOT NULL, `repair` int(11) NOT NULL, `fmute` int(11) NOT NULL, `fwarn` int(11) NOT NULL, `owarn` int(11) NOT NULL, `dmz_kills` int(11) NOT NULL, `Progress1` int(11) NOT NULL, `Progress2` int(11) NOT NULL, `Progress3` int(11) NOT NULL, `Progress4`");
        strcat(race_db_query, "int(11) NOT NULL, `Progress5` int(11) NOT NULL, `Progress6` int(11) NOT NULL, `ProgressExp1` int(11) NOT NULL, `ProgressExp2` int(11) NOT NULL, `ProgressExp3` int(11) NOT NULL, `ProgressExp4` int(11) NOT NULL, `ProgressExp5` int(11) NOT NULL, `ProgressExp6` int(11) NOT NULL, `capt_kills` int(11) NOT NULL, `coins` int(11) NOT NULL, `ytpromo_activate` int(11) NOT NULL, `3d_prefix` int(11) NOT NULL, `loader_skill`");
        strcat(race_db_query, "int(11) NOT NULL, `premium_time` int(11) NOT NULL, `antisliv` int(11) NOT NULL, `QuestBox` int(11) NOT NULL, `flower1` int(11) NOT NULL, `flower2` int(11) NOT NULL, `flower3` int(11) NOT NULL, `TakeFlower` int(11) NOT NULL, `CongratulateWomen` int(11) NOT NULL, `BuyPerfume` int(11) NOT NULL, `GivePerfume` int(11) NOT NULL, `BuyCake` int(11) NOT NULL, `BuyProducts` int(11) NOT NULL, `BuyCandle` int(11) NOT NULL,");
        strcat(race_db_query, "`EndQuest8marta` int(11) NOT NULL, `score` int(11) NOT NULL, `case` int(11) NOT NULL, `online_today` int(11) NOT NULL DEFAULT 0, `golod` int(11) NOT NULL DEFAULT 100, `garage` int(11) NOT NULL DEFAULT -1, `bitcoin` float DEFAULT 0, `mining_rig` int(11) DEFAULT 0, `mining_status` int(11) DEFAULT 0, `work_day` int(11) DEFAULT 0, `counttodaycases` int(11) DEFAULT 0, `countbomjcases` int(11) DEFAULT 0, `countstancases`");
        strcat(race_db_query, "int(11) DEFAULT 0, `countcarcases` int(11) DEFAULT 0, `countosobcases` int(11) DEFAULT 0, `countdopcases1` int(11) NOT NULL DEFAULT 0, `last_x` float DEFAULT 0, `last_y` float DEFAULT 0, `last_z` float DEFAULT 0, `last_a` float DEFAULT 0, `fam_token` int(11) NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `email` (`email`), KEY `phone` (`phone`), KEY `house` (`house`), KEY `name` (`name`) USING BTREE ) ENGINE=MyISAM");
        strcat(race_db_query, "DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 3. aclogs
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `aclogs` ( `id` int(11) NOT NULL AUTO_INCREMENT, `type` varchar(16) NOT NULL, `date` varchar(24) NOT NULL, `name` varchar(24) NOT NULL, `reason` varchar(32) NOT NULL, `data` varchar(128) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci ROW_FORMAT=COMPRESSED;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 4. action_log
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `action_log` ( `id` int(11) NOT NULL AUTO_INCREMENT, `acc_id` int(11) NOT NULL, `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255', `type` int(11) NOT NULL, `description` varchar(128) NOT NULL, `time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 5. activated_promos
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `activated_promos` ( `id` int(11) NOT NULL AUTO_INCREMENT, `account_id` int(11) NOT NULL, `promo_id` int(11) NOT NULL, `activated_at` datetime NOT NULL, PRIMARY KEY (`id`), UNIQUE KEY `account_promo` (`account_id`,`promo_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 6. allowed_servers
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `allowed_servers` ( `id` int(11) NOT NULL AUTO_INCREMENT, `ip_port` varchar(40) NOT NULL, `server_name` varchar(100) DEFAULT '', `added_reason` varchar(255) DEFAULT '', `date_added` timestamp NOT NULL DEFAULT current_timestamp(), `is_active` tinyint(1) DEFAULT 1, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 7. bank_accounts
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `bank_accounts` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `name` varchar(21) NOT NULL DEFAULT 'None', `balance` int(11) NOT NULL, `pin` varchar(9) NOT NULL DEFAULT '0000', `reg_time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 8. bank_accounts_log
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `bank_accounts_log` ( `id` int(11) NOT NULL AUTO_INCREMENT, `acc_id` int(11) NOT NULL, `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255', `time` int(11) NOT NULL, `description` varchar(64) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 9. ban_list
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `ban_list` ( `id` int(11) NOT NULL AUTO_INCREMENT, `user_id` int(11) NOT NULL, `time` int(11) NOT NULL, `ban_time` int(11) NOT NULL, `ip` varchar(16) NOT NULL, `description` varchar(32) NOT NULL, `admin` varchar(24) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 10. business
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `business` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `name` varchar(50) NOT NULL, `improvements` int(11) NOT NULL, `products` int(11) NOT NULL, `prod_price` int(11) NOT NULL, `balance` int(11) NOT NULL, `rent_time` int(11) NOT NULL, `price` int(11) NOT NULL, `rent_price` int(11) NOT NULL, `type` int(11) NOT NULL, `interior` int(11) NOT NULL, `enter_price` int(11)");
        strcat(race_db_query, "NOT NULL, `enter_music` int(11) NOT NULL, `lock` int(11) NOT NULL, `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL, `exit_x` float NOT NULL, `exit_y` float NOT NULL, `exit_z` float NOT NULL, `exit_angle` float NOT NULL, `eviction` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 11. business_gps
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `business_gps` ( `id` int(11) NOT NULL AUTO_INCREMENT, `bid` int(11) NOT NULL, `pos` int(11) NOT NULL, `time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 12. business_profit
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `business_profit` ( `id` int(11) NOT NULL AUTO_INCREMENT, `bid` int(11) NOT NULL, `uid` int(11) NOT NULL, `uip` varchar(16) NOT NULL, `time` int(11) NOT NULL, `money` int(11) NOT NULL, `view` int(11) NOT NULL DEFAULT 1, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 13. car_obmen
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `car_obmen` ( `id` int(11) NOT NULL AUTO_INCREMENT, `car_1` int(11) NOT NULL DEFAULT 5, `car_2` int(11) NOT NULL DEFAULT 5, `car_3` int(11) NOT NULL DEFAULT 5, `car_4` int(11) NOT NULL DEFAULT 5, `car_5` int(11) NOT NULL DEFAULT 1, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 14. change_names
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `change_names` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `name` varchar(21) NOT NULL, `time` int(11) NOT NULL, `ip` varchar(16) NOT NULL DEFAULT '255.255.255.255', PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 15. charity
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `charity` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `money` int(11) NOT NULL, `time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 16. debug
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `debug` ( `id` int(11) NOT NULL AUTO_INCREMENT, `text` varchar(256) NOT NULL, `date` varchar(32) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 17. donate_log
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `donate_log` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `uip` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '255.255.255.255', `time` int(11) NOT NULL, `donate` int(11) NOT NULL, `description` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None', PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=latin1");
        strcat(race_db_query, "COLLATE=latin1_swedish_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 18. family
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `family` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(32) NOT NULL, `color` int(11) NOT NULL DEFAULT 0, `reputation` int(11) NOT NULL DEFAULT 0, `owner` int(11) NOT NULL DEFAULT -1, `slot_veh` int(11) NOT NULL DEFAULT 5, `money` int(11) NOT NULL DEFAULT 0, `armour` int(11) NOT NULL DEFAULT 0, `material` int(11) NOT NULL DEFAULT 0, `heath_kit` int(11) NOT NULL DEFAULT 0, `patron`");
        strcat(race_db_query, "int(11) NOT NULL DEFAULT 0, `level_storage` int(11) NOT NULL DEFAULT 1, `level_weapon` int(11) NOT NULL DEFAULT 1, `level_compound` int(11) NOT NULL DEFAULT 1, `rang_1` varchar(38) NOT NULL DEFAULT '1 Ранг,1,0,0,0,1', `rang_2` varchar(38) NOT NULL DEFAULT '2 Ранг,1,0,0,0,1', `rang_3` varchar(38) NOT NULL DEFAULT '3 Ранг,1,0,0,0,1', `rang_4` varchar(38) NOT NULL DEFAULT '4 Ранг,1,0,0,0,1', `rang_5` varchar(38) NOT");
        strcat(race_db_query, "NULL DEFAULT '5 Ранг,1,1,1,1,1', `house` int(11) NOT NULL DEFAULT -1, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 19. family_ad
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `family_ad` ( `id` int(11) NOT NULL AUTO_INCREMENT, `family` int(11) NOT NULL, `ad_text` varchar(62) NOT NULL, `create_id` int(11) NOT NULL, `create_name` varchar(24) NOT NULL, `time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 20. family_cars
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `family_cars` ( `id` int(11) NOT NULL AUTO_INCREMENT, `model_id` int(11) NOT NULL, `color_1` int(11) NOT NULL, `color_2` int(11) NOT NULL, `number` varchar(32) NOT NULL DEFAULT 'none', `region` varchar(32) NOT NULL DEFAULT '--', `number_type` int(11) NOT NULL DEFAULT 0, `pos_x` float NOT NULL, `pos_y` float NOT NULL, `pos_z` float NOT NULL, `angle` float NOT NULL, `pos_last_x` float");
        strcat(race_db_query, "DEFAULT NULL, `pos_last_y` float DEFAULT NULL, `pos_last_z` float DEFAULT NULL, `angle_last` float DEFAULT NULL, `rang` int(11) NOT NULL DEFAULT 1, `family_owner` int(11) NOT NULL DEFAULT -1, `create_time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 21. family_log
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `family_log` ( `id` int(11) NOT NULL AUTO_INCREMENT, `family` int(11) NOT NULL, `player` int(11) NOT NULL, `to_player` int(11) NOT NULL, `text` varchar(124) NOT NULL, `time` int(11) NOT NULL, `type` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 22. fuel_stations
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `fuel_stations` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `name` varchar(20) NOT NULL DEFAULT 'None', `improvements` int(11) NOT NULL, `fuels` int(11) NOT NULL, `fuel_price` int(11) NOT NULL, `buy_fuel_price` int(11) NOT NULL, `balance` int(11) NOT NULL, `rent_time` int(11) NOT NULL, `price` int(11) NOT NULL, `rent_price` int(11) NOT NULL, `lock` int(11) NOT");
        strcat(race_db_query, "NULL, `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL, `eviction` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 23. fuel_stations_profit
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `fuel_stations_profit` ( `id` int(11) NOT NULL AUTO_INCREMENT, `fid` int(11) NOT NULL, `uid` int(11) NOT NULL, `uip` varchar(16) NOT NULL, `time` int(11) NOT NULL, `money` int(11) NOT NULL, `view` int(11) NOT NULL DEFAULT 1, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 24. full_dostup
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `full_dostup` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(64) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 25. gang_repositories
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `gang_repositories` ( `id` int(11) NOT NULL AUTO_INCREMENT, `metall` int(11) NOT NULL, `ammo` int(11) NOT NULL, `drugs` int(11) NOT NULL, `money` int(11) NOT NULL, `lock` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 26. gang_zones
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `gang_zones` ( `id` int(11) NOT NULL AUTO_INCREMENT, `min_x` float NOT NULL, `min_y` float NOT NULL, `max_x` float NOT NULL, `max_y` float NOT NULL, `fraction` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 27. garages
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `garages` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `price` int(11) NOT NULL, `lock` int(11) NOT NULL, `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL, `exit_x` float NOT NULL, `exit_y` float NOT NULL, `exit_z` float NOT NULL, `exit_angle` float NOT NULL, `improvements` int(11) NOT NULL DEFAULT 1, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT");
        strcat(race_db_query, "CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 28. gates
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `gates` ( `id` int(11) NOT NULL AUTO_INCREMENT, `gate_type` int(11) NOT NULL, `gate1_x` float NOT NULL, `gate1_y` float NOT NULL, `gate1_z` float NOT NULL, `gate1_angle` float NOT NULL, `gate2_x` float NOT NULL, `gate2_y` float NOT NULL, `gate2_z` float NOT NULL, `gate2_angle` float NOT NULL, `gatezone_x` float NOT NULL, `gatezone_y` float NOT NULL, `gatezone_z` float NOT NULL, PRIMARY KEY");
        strcat(race_db_query, "(`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 29. gift
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `gift` ( `id` int(16) NOT NULL AUTO_INCREMENT, `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 30. gift_lose
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `gift_lose` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `gift_id` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 31. hotels
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `hotels` ( `id` int(11) NOT NULL AUTO_INCREMENT, `hotel_id` int(11) NOT NULL, `owner_id` int(11) NOT NULL, `rent_time` int(11) NOT NULL, `status` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 32. houses
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `houses` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `name` varchar(20) NOT NULL, `improvements` int(11) NOT NULL, `rent_time` int(11) NOT NULL, `price` int(11) NOT NULL, `rent_price` int(11) NOT NULL, `type` int(11) NOT NULL, `entrance` int(11) NOT NULL DEFAULT -1, `lock` int(11) NOT NULL, `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL, `exit_x` float");
        strcat(race_db_query, "NOT NULL, `exit_y` float NOT NULL, `exit_z` float NOT NULL, `exit_angle` float NOT NULL, `car_x` float NOT NULL, `car_y` float NOT NULL, `car_z` float NOT NULL, `car_angle` float NOT NULL, `store_x` float NOT NULL, `store_y` float NOT NULL, `store_z` float NOT NULL, `eviction` int(11) NOT NULL, `store_metall` int(11) NOT NULL, `store_drugs` int(11) NOT NULL, `store_weapon` int(11) NOT NULL, `store_ammo` int(11) NOT");
        strcat(race_db_query, "NULL, `store_skin` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 33. houses_renters
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `houses_renters` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `house_id` int(11) NOT NULL, `room_id` int(11) NOT NULL, `rent_time` int(11) NOT NULL, `time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 34. house_storage
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `house_storage` ( `id` int(11) NOT NULL AUTO_INCREMENT, `house_id` int(11) NOT NULL COMMENT 'ID дома из таблицы houses', `slot` int(11) NOT NULL DEFAULT 0 COMMENT 'Слот шкафа (0-79)', `item_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ID предмета', `amount` int(11) NOT NULL DEFAULT 1 COMMENT 'Количество предмета', `item_type` int(11) NOT NULL DEFAULT 0 COMMENT 'Тип предмета', `item_plate`");
        strcat(race_db_query, "varchar(32) NOT NULL DEFAULT '' COMMENT 'Пластина (для номеров, SIM-карт и т.д.)', PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 35. items_data
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `items_data` ( `id` int(11) NOT NULL AUTO_INCREMENT, `item_id` int(11) NOT NULL, `item_name` varchar(64) NOT NULL, `item_type` int(11) NOT NULL DEFAULT 0, `item_weight` int(11) NOT NULL DEFAULT 1, `item_max_stack` int(11) NOT NULL DEFAULT 999, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 36. leaders
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `leaders` ( `id` int(11) NOT NULL AUTO_INCREMENT, `accout_id` int(11) NOT NULL DEFAULT 0, `name` varchar(64) NOT NULL, `frac_id` int(11) NOT NULL DEFAULT 0, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 37. money_log
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `money_log` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255', `time` int(11) NOT NULL, `money` int(11) NOT NULL, `description` varchar(64) NOT NULL DEFAULT 'None', PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 38. objects
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `objects` ( `id` int(11) NOT NULL AUTO_INCREMENT, `model_id` int(11) NOT NULL, `pos_x` float NOT NULL, `pos_y` float NOT NULL, `pos_z` float NOT NULL, `r_pos_x` float NOT NULL, `r_pos_y` float NOT NULL, `r_pos_z` float NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 39. old_accessories
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `old_accessories` ( `account_id` int(11) NOT NULL, `slot` tinyint(4) NOT NULL, `modelid` int(11) NOT NULL, `bone` tinyint(4) NOT NULL, `pos_x` float DEFAULT NULL, `pos_y` float DEFAULT NULL, `pos_z` float DEFAULT NULL, `rot_x` float DEFAULT NULL, `rot_y` float DEFAULT NULL, `rot_z` float DEFAULT NULL, `scale_x` float DEFAULT NULL, `scale_y` float DEFAULT NULL, `scale_z` float DEFAULT NULL,");
        strcat(race_db_query, "PRIMARY KEY (`account_id`, `slot`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 40. orders
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `orders` ( `id` int(11) NOT NULL AUTO_INCREMENT, `type` int(11) NOT NULL, `company` int(11) NOT NULL, `amount` int(11) NOT NULL, `price` int(11) NOT NULL, `time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 41. ownable_cars
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `ownable_cars` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `model_id` int(11) NOT NULL, `comfort` int(11) NOT NULL, `sport` int(11) NOT NULL, `sport_plus` int(11) NOT NULL, `drift` int(11) NOT NULL, `wheels_kl` float NOT NULL, `wheels_size` float NOT NULL, `wheels_raz` int(11) NOT NULL, `wheels_otkl` float NOT NULL, `color_1` int(11) NOT NULL DEFAULT -1, `color_2`");
        strcat(race_db_query, "int(11) NOT NULL DEFAULT -1, `pos_x` float NOT NULL, `pos_y` float NOT NULL, `pos_z` float NOT NULL, `angle` float NOT NULL, `number` varchar(32) NOT NULL DEFAULT 'none', `region` varchar(32) NOT NULL DEFAULT '--', `number_type` int(11) NOT NULL DEFAULT 0, `status` int(11) NOT NULL, `alarm` int(11) NOT NULL, `key_in` int(11) NOT NULL, `mileage` float NOT NULL, `create_time` int(11) NOT NULL, `promo_id` int(11) NOT");
        strcat(race_db_query, "NULL DEFAULT 0, `promo_status_car` tinyint(1) NOT NULL DEFAULT 0, `health` float NOT NULL DEFAULT 1000, `vinilcar` int(11) NOT NULL, `pt_engine` int(11) NOT NULL, `pt_brake` int(11) NOT NULL, `pt_stability` int(11) NOT NULL, `nitro` int(11) NOT NULL, `launch` int(11) NOT NULL, `fars` int(11) NOT NULL, `diski` int(11) NOT NULL, `tuning_neon1` int(11) DEFAULT 0, `tuning_neon2` int(11) DEFAULT 0, `tuning_neon3` int(11)");
        strcat(race_db_query, "DEFAULT 0, `tuning_tint` tinyint(4) DEFAULT 0, `tuning_vinyl` tinyint(4) DEFAULT 0, `tuning_toner_front` int(11) DEFAULT 0, `tuning_toner_rear` int(11) DEFAULT 0, `tuning_toner_front_side` int(11) DEFAULT 0, `tuning_toner_rear_side` int(11) DEFAULT 0, `tuning_suspension_force` float DEFAULT 0, `tuning_suspension_bias` float DEFAULT 0, `tuning_wheel_size` float DEFAULT 0, `tuning_wheel_add_front` float DEFAULT 0,");
        strcat(race_db_query, "`tuning_wheel_add_rear` float DEFAULT 0, `tuning_hydraulics` tinyint(4) DEFAULT 0, `tuning_launch_control` tinyint(4) DEFAULT 0, `tuning_stroboscope` int(11) DEFAULT 0, `tuning_siren` tinyint(4) DEFAULT 0, `tuning_horn_sound` int(11) NOT NULL DEFAULT 0, `tuning_exhaust_sound` int(11) NOT NULL DEFAULT 0, `tuning_drift` tinyint(4) DEFAULT 0, `tuning_plate_type` tinyint(4) DEFAULT 0, `tuning_plate_number` varchar(8)");
        strcat(race_db_query, "DEFAULT '', `tuning_plate_region` varchar(3) DEFAULT '', `fuel` float NOT NULL DEFAULT 40, `firmware` int(11) NOT NULL DEFAULT 0, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 42. payments
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `payments` ( `id` int(11) NOT NULL AUTO_INCREMENT, `user_id` int(11) NOT NULL, `sum` int(11) NOT NULL, `status` int(11) NOT NULL, `name` varchar(24) NOT NULL, `billID` text NOT NULL, `data_create` datetime NOT NULL, `data_accept` datetime NOT NULL DEFAULT current_timestamp(), `server_id` int(11) NOT NULL DEFAULT 1, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        strcat(race_db_query, "COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 43. phone_books
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `phone_books` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner_id` int(11) NOT NULL, `name` varchar(21) DEFAULT NULL, `number` varchar(9) DEFAULT NULL, `time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 44. player_gpus
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `player_gpus` ( `id` int(11) NOT NULL AUTO_INCREMENT, `player_id` int(11) NOT NULL, `gpu_type` int(11) NOT NULL, `active` tinyint(4) DEFAULT 1, `created_at` timestamp NULL DEFAULT current_timestamp(), PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 45. player_inventory
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `player_inventory` ( `id` int(11) NOT NULL AUTO_INCREMENT, `player_id` int(11) NOT NULL, `slot` int(11) NOT NULL, `item_id` int(11) NOT NULL, `item_count` int(11) NOT NULL DEFAULT 1, `item_plate` varchar(32) DEFAULT '', `is_active` tinyint(1) DEFAULT 0, `active_slot` int(11) DEFAULT -1, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 46. player_promos
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `player_promos` ( `id` int(11) NOT NULL AUTO_INCREMENT, `account_id` int(11) NOT NULL, `promo_prize_sql_id` int(11) NOT NULL, `start_time` int(11) NOT NULL, `remaining_time` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 47. promocode
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `promocode` ( `id` int(11) NOT NULL AUTO_INCREMENT, `code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL, `type` int(11) NOT NULL, `amount` int(11) NOT NULL, `usings` int(11) NOT NULL, `paydays` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 48. promocodes
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `promocodes` ( `id` int(11) NOT NULL AUTO_INCREMENT, `code` varchar(32) NOT NULL, `uses_limit` int(11) NOT NULL DEFAULT 1, `uses_left` int(11) NOT NULL DEFAULT 1, `num_prizes` tinyint(1) NOT NULL DEFAULT 1, `activations` int(11) NOT NULL DEFAULT 0, `promo_level` int(11) NOT NULL DEFAULT -1, `promo_balance` int(11) NOT NULL DEFAULT 0, `creator_account_id` int(11) NOT NULL DEFAULT 0,");
        strcat(race_db_query, "`creation_cost` int(11) NOT NULL DEFAULT 0, `created_at` timestamp NOT NULL DEFAULT current_timestamp(), PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 49. promocode_activations
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `promocode_activations` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `code` varchar(32) NOT NULL, `paydays` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 50. promo_prizes
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `promo_prizes` ( `id` int(11) NOT NULL AUTO_INCREMENT, `promo_id` int(11) NOT NULL, `prize_index` tinyint(1) NOT NULL, `prize_type` tinyint(1) NOT NULL DEFAULT 0, `prize_value` int(11) NOT NULL DEFAULT 0, `prize_duration` int(11) NOT NULL DEFAULT 0, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 51. quick_message
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `quick_message` ( `name` varchar(64) NOT NULL, `text_1` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №1', `text_2` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №2', `text_3` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №3', `text_4` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №4', `text_5` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №5',");
        strcat(race_db_query, "`text_6` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №6', `text_7` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №7', `text_8` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №8', `text_9` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №9', `text_10` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №10', `text_11` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №11',");
        strcat(race_db_query, "`text_12` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №12', `text_13` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №13', `text_14` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №14', `text_15` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №15', `text_16` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №16', `text_17` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №17',");
        strcat(race_db_query, "`text_18` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №18', `text_19` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №19', `text_20` varchar(128) NOT NULL, PRIMARY KEY (`name`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 52. repositories
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `repositories` ( `id` int(11) NOT NULL AUTO_INCREMENT, `type` int(11) NOT NULL, `action_id` int(11) NOT NULL, `amount` int(11) NOT NULL, `description` varchar(64) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 53. return_money
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `return_money` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `money` int(11) NOT NULL, `description` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL, `status` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 54. rewards
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `rewards` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL COMMENT 'ID игрока из таблицы аккаунтов', `award_id` int(11) NOT NULL COMMENT '?ндекс приза в массиве Case...Awards', `case_id` int(11) NOT NULL COMMENT 'ID кейса (1-5, 8)', PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 55. roulette_prize
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `roulette_prize` ( `id` int(11) NOT NULL AUTO_INCREMENT, `owner` int(11) NOT NULL, `prize` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 56. server_settings
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `server_settings` ( `admin_price` int(11) NOT NULL DEFAULT 80, `helper_price` int(11) NOT NULL DEFAULT 40, `distrub` int(11) NOT NULL DEFAULT 1, `donpower` int(11) NOT NULL DEFAULT 1, `GiveCoins` int(11) NOT NULL ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 57. tickets
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `tickets` ( `id` int(11) NOT NULL AUTO_INCREMENT, `uid` int(11) NOT NULL, `amount` int(11) NOT NULL, `description` varchar(64) NOT NULL, `issuer` varchar(32) NOT NULL, `status` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 58. trunks
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `trunks` ( `id` int(11) NOT NULL AUTO_INCREMENT, `oc_id` int(11) NOT NULL COMMENT 'ID транспорта из ownable_cars', `slot` int(11) NOT NULL DEFAULT 0 COMMENT 'Слот багажника', `item_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ID предмета', `amount` int(11) NOT NULL DEFAULT 1 COMMENT 'Количество предмета', `item_type` int(11) NOT NULL DEFAULT 0 COMMENT 'Тип предмета', `item_plate` varchar(32)");
        strcat(race_db_query, "NOT NULL DEFAULT '' COMMENT 'Номер машины', PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 59. unitpay_payments
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `unitpay_payments` ( `id` int(10) NOT NULL AUTO_INCREMENT, `unitpayId` varchar(255) NOT NULL, `account` varchar(255) NOT NULL, `sum` float NOT NULL, `itemsCount` int(11) NOT NULL DEFAULT 1, `dateCreate` datetime NOT NULL, `dateComplete` datetime DEFAULT NULL, `status` tinyint(4) NOT NULL DEFAULT 0, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 60. whitelist
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `whitelist` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(64) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    // 61. ytpromocode
    {
        new race_db_query[8192];
        race_db_query[0] = EOS;
        strcat(race_db_query, "CREATE TABLE IF NOT EXISTS `ytpromocode` ( `id` int(11) NOT NULL AUTO_INCREMENT, `code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL, `type` int(11) NOT NULL, `amount` int(11) NOT NULL, `usings` int(11) NOT NULL, `paydays` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");
        RaceDB_RunCreateQuery(race_db_query);
    }
    return 1;
}
