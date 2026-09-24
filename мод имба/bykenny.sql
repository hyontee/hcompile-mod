-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Сен 21 2026 г., 17:34
-- Версия сервера: 10.11.18-MariaDB-0+deb12u1
-- Версия PHP: 8.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gs350338`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accessories`
--

CREATE TABLE `accessories` (
  `id` int(11) NOT NULL,
  `slot` int(11) NOT NULL,
  `modelid` int(11) NOT NULL,
  `bone` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rX` int(11) NOT NULL,
  `rY` int(11) NOT NULL,
  `rZ` int(11) NOT NULL,
  `scale` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `accessories_players`
--

CREATE TABLE `accessories_players` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `slot` int(11) NOT NULL,
  `bone` int(11) NOT NULL,
  `acs_id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0.01,
  `y` float NOT NULL DEFAULT 0.01,
  `z` float NOT NULL DEFAULT 0.01,
  `rX` float NOT NULL DEFAULT 0.01,
  `rY` float NOT NULL DEFAULT 0.01,
  `rZ` float NOT NULL DEFAULT 0.01,
  `scale` float NOT NULL DEFAULT 1.01
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `accessory_inventory`
--

CREATE TABLE `accessory_inventory` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `acs_id` int(11) NOT NULL,
  `use` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `password` varchar(65) NOT NULL,
  `salt` varchar(10) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `email` varchar(61) NOT NULL DEFAULT 'None',
  `confirm_email` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `weekly_prizes` text NOT NULL DEFAULT '0,0,0,0,0,0,0',
  `weekly_day` int(11) NOT NULL DEFAULT 0,
  `exp` int(11) NOT NULL,
  `refer` int(11) NOT NULL,
  `sex` int(11) NOT NULL,
  `skin` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `roulette_auto` int(11) NOT NULL DEFAULT 0,
  `roulette_silver` int(11) NOT NULL DEFAULT 0,
  `roulette_gold` int(11) NOT NULL DEFAULT 0,
  `satiety` int(11) NOT NULL DEFAULT 100,
  `roulette_bronz` int(11) NOT NULL DEFAULT 0,
  `bank` int(11) NOT NULL,
  `admin` int(11) NOT NULL,
  `post` int(11) NOT NULL,
  `family_id` int(11) NOT NULL DEFAULT -1,
  `family_rang` int(11) NOT NULL DEFAULT 1,
  `family_mute` int(11) NOT NULL,
  `family_vig` int(11) NOT NULL DEFAULT 0,
  `family_access` varchar(24) NOT NULL DEFAULT '0,0,0,0,0,0,0',
  `a_secret` int(11) NOT NULL,
  `prefix` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '[A]',
  `a_3d_prefix` int(11) NOT NULL,
  `admin_warn` int(11) NOT NULL,
  `AdminPass` int(11) NOT NULL,
  `driving_lic` int(11) NOT NULL,
  `weapon_lic` int(11) NOT NULL,
  `suspect` int(11) NOT NULL,
  `phone` int(11) NOT NULL,
  `phone_balance` int(11) NOT NULL,
  `phone_color` int(11) NOT NULL DEFAULT 9,
  `law_abiding` int(11) NOT NULL,
  `improvements` int(11) NOT NULL,
  `power` int(11) NOT NULL,
  `drugs` int(11) NOT NULL,
  `ammo` int(11) NOT NULL,
  `metall` int(11) NOT NULL,
  `wife` int(11) NOT NULL,
  `team` int(11) NOT NULL,
  `subdivison` int(11) NOT NULL,
  `wage` int(11) NOT NULL,
  `job` int(11) NOT NULL,
  `progress_company` float NOT NULL DEFAULT 1,
  `t_company` int(11) NOT NULL DEFAULT -1,
  `tc_owner` int(11) NOT NULL DEFAULT -1,
  `house_type` int(11) NOT NULL DEFAULT -1,
  `house_room` int(11) NOT NULL DEFAULT -1,
  `house` int(11) NOT NULL DEFAULT -1,
  `business` int(11) NOT NULL DEFAULT -1,
  `fuel_st` int(11) NOT NULL DEFAULT -1,
  `reg_time` int(11) NOT NULL,
  `reg_ip` varchar(16) NOT NULL,
  `last_ip` varchar(16) NOT NULL,
  `last_login` int(11) NOT NULL,
  `game_for_hour` int(11) NOT NULL,
  `game_for_day` int(11) NOT NULL,
  `game_for_day_prev` int(11) NOT NULL,
  `setting_phone` varchar(13) NOT NULL DEFAULT 'None',
  `setting_pin_code` varchar(5) NOT NULL DEFAULT 'None',
  `request_phone` int(11) NOT NULL,
  `request_pin` int(11) NOT NULL,
  `setting1` int(11) NOT NULL DEFAULT 2,
  `setting2` int(11) NOT NULL DEFAULT 1,
  `setting4` int(11) NOT NULL DEFAULT 1,
  `setting5` int(11) NOT NULL DEFAULT 0,
  `setting6` int(11) NOT NULL DEFAULT 1,
  `warn` int(11) NOT NULL,
  `warn_time` int(11) NOT NULL,
  `mute` int(11) NOT NULL,
  `skill_colt` int(11) NOT NULL,
  `skill_sdpistol` int(11) NOT NULL,
  `skill_deagle` int(11) NOT NULL,
  `skill_shotgun` int(11) NOT NULL,
  `skill_mp5` int(11) NOT NULL,
  `skill_ak47` int(11) NOT NULL,
  `skill_m4` int(11) NOT NULL,
  `skill_sniper_rifle` int(11) NOT NULL,
  `skill_sawnoff` int(11) NOT NULL,
  `skill_combat_sg` int(11) NOT NULL,
  `skill_micro_uzi` int(11) NOT NULL,
  `donate_current` int(11) NOT NULL,
  `donate_total` int(11) NOT NULL,
  `org_skin` int(11) NOT NULL,
  `setting_spawn` int(11) NOT NULL,
  `hospital` int(11) NOT NULL,
  `health` float NOT NULL DEFAULT 100,
  `car_slots` int(11) NOT NULL DEFAULT 1,
  `jail` int(11) NOT NULL,
  `premium` int(11) NOT NULL,
  `premium_date` int(11) NOT NULL,
  `rub` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `gifts` int(11) NOT NULL,
  `cmdaccess` varchar(32) NOT NULL DEFAULT '000000000000000',
  `family` int(11) NOT NULL,
  `family_rank` int(11) NOT NULL,
  `test` int(11) NOT NULL,
  `quest_1` int(11) NOT NULL,
  `quest_2` int(11) NOT NULL,
  `quest_3` int(11) NOT NULL,
  `quest_4` int(11) NOT NULL,
  `quest_5` int(11) NOT NULL,
  `quest_6` int(11) NOT NULL,
  `quest_7` int(11) NOT NULL,
  `quest_8` int(11) NOT NULL,
  `quest_exp_1` int(11) NOT NULL,
  `quest_exp_2` int(11) NOT NULL,
  `quest_exp_3` int(11) NOT NULL,
  `quest_exp_4` int(11) NOT NULL,
  `quest_exp_5` int(11) NOT NULL,
  `quest_exp_6` int(11) NOT NULL,
  `quest_exp_7` int(11) NOT NULL,
  `quest_exp_8` int(11) NOT NULL,
  `youtube` int(11) NOT NULL,
  `AntiBh` int(11) NOT NULL,
  `get_adm_status` int(11) NOT NULL DEFAULT 0,
  `get_adm_hour` int(11) NOT NULL DEFAULT 0,
  `online` int(11) NOT NULL DEFAULT 0,
  `totalhour` int(11) DEFAULT NULL,
  `quest231` int(11) NOT NULL DEFAULT 0,
  `quest232` int(11) NOT NULL DEFAULT 0,
  `quest233` int(11) NOT NULL,
  `postcard` int(11) NOT NULL,
  `repcarid` int(11) NOT NULL,
  `helper` int(11) NOT NULL,
  `healme` int(11) NOT NULL,
  `QuestBox1` int(11) NOT NULL,
  `QuestBox2` int(11) NOT NULL,
  `QuestBox3` int(11) NOT NULL,
  `QuestBox4` int(11) NOT NULL,
  `QuestBox5` int(11) NOT NULL,
  `QuestBox6` int(11) NOT NULL,
  `repair` int(11) NOT NULL,
  `fmute` int(11) NOT NULL,
  `fwarn` int(11) NOT NULL,
  `owarn` int(11) NOT NULL,
  `dmz_kills` int(11) NOT NULL,
  `Progress1` int(11) NOT NULL,
  `Progress2` int(11) NOT NULL,
  `Progress3` int(11) NOT NULL,
  `Progress4` int(11) NOT NULL,
  `Progress5` int(11) NOT NULL,
  `Progress6` int(11) NOT NULL,
  `ProgressExp1` int(11) NOT NULL,
  `ProgressExp2` int(11) NOT NULL,
  `ProgressExp3` int(11) NOT NULL,
  `ProgressExp4` int(11) NOT NULL,
  `ProgressExp5` int(11) NOT NULL,
  `ProgressExp6` int(11) NOT NULL,
  `capt_kills` int(11) NOT NULL,
  `coins` int(11) NOT NULL,
  `moneti` int(11) NOT NULL DEFAULT 0,
  `family_notif_seen` int(11) NOT NULL DEFAULT 0,
  `family_notif_seen_family` int(11) NOT NULL DEFAULT 0,
  `ytpromo_activate` int(11) NOT NULL,
  `3d_prefix` int(11) NOT NULL,
  `loader_skill` int(11) NOT NULL,
  `premium_time` int(11) NOT NULL,
  `antisliv` int(11) NOT NULL,
  `QuestBox` int(11) NOT NULL,
  `flower1` int(11) NOT NULL,
  `flower2` int(11) NOT NULL,
  `flower3` int(11) NOT NULL,
  `TakeFlower` int(11) NOT NULL,
  `CongratulateWomen` int(11) NOT NULL,
  `BuyPerfume` int(11) NOT NULL,
  `GivePerfume` int(11) NOT NULL,
  `BuyCake` int(11) NOT NULL,
  `BuyProducts` int(11) NOT NULL,
  `BuyCandle` int(11) NOT NULL,
  `EndQuest8marta` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `case` int(11) NOT NULL,
  `online_today` int(11) NOT NULL DEFAULT 0,
  `golod` int(11) NOT NULL DEFAULT 100,
  `garage` int(11) NOT NULL DEFAULT -1,
  `bitcoin` float DEFAULT 0,
  `mining_rig` int(11) DEFAULT 0,
  `mining_status` int(11) DEFAULT 0,
  `work_day` int(11) DEFAULT 0,
  `counttodaycases` int(11) DEFAULT 0,
  `countbomjcases` int(11) DEFAULT 0,
  `countstancases` int(11) DEFAULT 0,
  `countcarcases` int(11) DEFAULT 0,
  `countosobcases` int(11) DEFAULT 0,
  `countdopcases1` int(11) NOT NULL DEFAULT 0,
  `last_x` float DEFAULT 0,
  `last_y` float DEFAULT 0,
  `last_z` float DEFAULT 0,
  `last_a` float DEFAULT 0,
  `fam_token` int(11) NOT NULL DEFAULT 0,
  `vodo_items` int(11) NOT NULL DEFAULT 0,
  `vodo_time` int(11) NOT NULL DEFAULT 0,
  `vodo_task` int(11) NOT NULL DEFAULT 0,
  `med` tinyint(1) NOT NULL DEFAULT 0,
  `house_slots` int(11) NOT NULL DEFAULT 0,
  `buss_slots` int(11) NOT NULL DEFAULT 0,
  `admin_reports` int(11) NOT NULL DEFAULT 0,
  `tc_company_id` int(11) NOT NULL DEFAULT 0,
  `tc_rating` int(11) NOT NULL DEFAULT 0,
  `tc_rating_day` int(11) NOT NULL DEFAULT 0,
  `tc_rating_week` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `salt`, `email`, `confirm_email`, `level`, `weekly_prizes`, `weekly_day`, `exp`, `refer`, `sex`, `skin`, `money`, `roulette_auto`, `roulette_silver`, `roulette_gold`, `satiety`, `roulette_bronz`, `bank`, `admin`, `post`, `family_id`, `family_rang`, `family_mute`, `family_vig`, `family_access`, `a_secret`, `prefix`, `a_3d_prefix`, `admin_warn`, `AdminPass`, `driving_lic`, `weapon_lic`, `suspect`, `phone`, `phone_balance`, `phone_color`, `law_abiding`, `improvements`, `power`, `drugs`, `ammo`, `metall`, `wife`, `team`, `subdivison`, `wage`, `job`, `progress_company`, `t_company`, `tc_owner`, `house_type`, `house_room`, `house`, `business`, `fuel_st`, `reg_time`, `reg_ip`, `last_ip`, `last_login`, `game_for_hour`, `game_for_day`, `game_for_day_prev`, `setting_phone`, `setting_pin_code`, `request_phone`, `request_pin`, `setting1`, `setting2`, `setting4`, `setting5`, `setting6`, `warn`, `warn_time`, `mute`, `skill_colt`, `skill_sdpistol`, `skill_deagle`, `skill_shotgun`, `skill_mp5`, `skill_ak47`, `skill_m4`, `skill_sniper_rifle`, `skill_sawnoff`, `skill_combat_sg`, `skill_micro_uzi`, `donate_current`, `donate_total`, `org_skin`, `setting_spawn`, `hospital`, `health`, `car_slots`, `jail`, `premium`, `premium_date`, `rub`, `player`, `gifts`, `cmdaccess`, `family`, `family_rank`, `test`, `quest_1`, `quest_2`, `quest_3`, `quest_4`, `quest_5`, `quest_6`, `quest_7`, `quest_8`, `quest_exp_1`, `quest_exp_2`, `quest_exp_3`, `quest_exp_4`, `quest_exp_5`, `quest_exp_6`, `quest_exp_7`, `quest_exp_8`, `youtube`, `AntiBh`, `get_adm_status`, `get_adm_hour`, `online`, `totalhour`, `quest231`, `quest232`, `quest233`, `postcard`, `repcarid`, `helper`, `healme`, `QuestBox1`, `QuestBox2`, `QuestBox3`, `QuestBox4`, `QuestBox5`, `QuestBox6`, `repair`, `fmute`, `fwarn`, `owarn`, `dmz_kills`, `Progress1`, `Progress2`, `Progress3`, `Progress4`, `Progress5`, `Progress6`, `ProgressExp1`, `ProgressExp2`, `ProgressExp3`, `ProgressExp4`, `ProgressExp5`, `ProgressExp6`, `capt_kills`, `coins`, `moneti`, `family_notif_seen`, `family_notif_seen_family`, `ytpromo_activate`, `3d_prefix`, `loader_skill`, `premium_time`, `antisliv`, `QuestBox`, `flower1`, `flower2`, `flower3`, `TakeFlower`, `CongratulateWomen`, `BuyPerfume`, `GivePerfume`, `BuyCake`, `BuyProducts`, `BuyCandle`, `EndQuest8marta`, `score`, `case`, `online_today`, `golod`, `garage`, `bitcoin`, `mining_rig`, `mining_status`, `work_day`, `counttodaycases`, `countbomjcases`, `countstancases`, `countcarcases`, `countosobcases`, `countdopcases1`, `last_x`, `last_y`, `last_z`, `last_a`, `fam_token`, `vodo_items`, `vodo_time`, `vodo_task`, `med`, `house_slots`, `buss_slots`, `admin_reports`, `tc_company_id`, `tc_rating`, `tc_rating_day`, `tc_rating_week`) VALUES
(1, 'Danya_Coder', 'B6503FA3F69BFD8B15988A67F571491DBF266E46AEBD072F91C5BA30EDB33668', 'gbP_tqD:[J', 'None', 0, 25, '0,0,0,0,0,0,0', 0, 0, 0, 0, 28, 963460801, 0, 0, 0, 100, 0, 18062000, 13, 0, 3, 5, 0, 0, '1,1,1,1,1,1,1', 0, '[A]', 0, 0, 3333, 2, 1, 0, 7777, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775427818, '31.222.204.60', '95.25.42.10', 1778111036, 1135, 1270, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 0, 0, 1, 0, 0, 13, 0, 0, 0, 35265, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 40, 100, -1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -956.464, 193.487, 24.865, 269.781, 38491, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 'Danya_Family', '0B356121D6C968F3A4701942338DE05416C6767B0D1B0A077E08783C28EDA754', 'RBN02tDI<|', 'None', 0, 1, '0,0,0,0,0,0,0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775499952, '31.222.204.52', '31.222.204.52', 1775500000, 0, 0, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 'Danya_Test', 'DFF76921DBA593599BD5B25BBB1179A74225E8DB7F4EA6DD17B565D6E73E4B76', 'u3=W|/kbl3', 'None', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 161, 39981100, 0, 0, 0, 100, 0, 0, 13, 0, 2, 5, 0, 0, '1,1,1,1,1,1,1', 0, '[A]', 0, 0, 3333, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775500624, '31.222.204.52', '31.222.204.62', 1775507037, 30, 167, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 2, 0, 0, 1778092634, 270, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 'Sile_Test', 'B11CAD546062CA6FC5B24FC433FD803489FAD4524386E435A037FB83A738E51E', '`>C7yVi`hd', 'None', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 79, 50000000, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775500929, '31.222.204.52', '31.222.204.52', 1776617378, 0, 0, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 2, 0, 0, 1778092931, 150, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 'Majorka_Gromov', 'F2373910CA8A9D52C17B3E30E734FED1747493A1443111550C31D7442304615B', '`LoU8[Xm|0', 'egofgfgdfm@gmail.com', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 79, 78642501, 0, 0, 0, 100, 0, 5400000, 13, 0, 8, 4, 0, 0, '0,0,0,0,0,0,0', 0, 'Основатель', 0, 0, 7777, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 10, 1, -1, -1, -1, -1, -1, -1, -1, 1775590850, '81.211.109.240', '81.211.109.240', 1777213778, 29, 45, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 15, 1, 0, 0, 2, 0, 0, 1778182852, 40, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 130, 100, -1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -2440.92, 200.695, 26.135, 128.885, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 'Sanya_Usupka', 'FCE47D3E459A992F5C35A29C1205158C4B54A2FFAD1A3865EFCC73E2D6E58B1F', '[P54>Mlmpl', 'None', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 71, 47009950, 0, 0, 0, 100, 0, 0, 0, 0, 5, 5, 0, 0, '1,1,1,1,1,1,1', 0, '[A]', 0, 0, 0, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775636667, '178.172.246.247', '178.172.246.247', 1775686072, 13, 203, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1778228670, 150, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2667.53, 2006.9, 11.237, 1.44502e-41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 'Dev_Triton', '7201BAC9274EE69B4DFEDB33D6D8540D71853CE7DF92723B259E9CA27556900E', '/={Pg8abb;', 'None', 0, 35, '0,0,0,0,0,0,0', 0, 0, 0, 0, 99, 487866788, 0, 0, 0, 100, 0, 350000, 13, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 1488, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1788244728, '178.216.209.173', '178.216.209.173', 1788366038, 283, 1869, 890, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 2, 0, 0, 1790836729, 961100, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2081.45, -2281.6, 21.931, 68.751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 'Paxan_Terror', '2F925640AB634608BB124581B43358EB6B2772740E1FDF0D258F5EC765741C05', '^B`4JnQxKM', 'None', 0, 10, '0,0,0,0,0,0,0', 0, 0, 0, 0, 301, 562471880, 0, 0, 0, 100, 0, 700000, 13, 0, 1, 5, 0, 0, '1,1,1,1,1,1,1', 0, 'Владелец', 0, 0, 2324, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1788852089, '92.36.120.113', '138.199.35.123', 1790011303, 761, 761, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 2, 0, 2, 1791444094, 16312, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 51, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 'Shizzy_Nafarme', 'C56371D7F0B7D98882F8F3AF71E080518D02C3432EAE2720D2064D4B4A584A27', 'TQ4{ej6\\jz', 'None', 0, 10, '0,0,0,0,0,0,0', 0, 0, 0, 0, 78, 66500000, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1789733931, '37.114.130.149', '37.114.130.149', 1789733972, 26, 26, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 2, 0, 2, 1792325933, 500, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2745.84, -2431.29, 21.813, 67.234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 'Kevin_Kaif', 'B1BD97696FCA5B323963074832ACF255C5AC38C2AAC5BE429BD10EF51D15901B', 'Ve5qOAV6Qr', 'None', 0, 1, '0,0,0,0,0,0,0', 0, 0, 0, 1, 77, 499950, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1790006342, '149.40.62.2', '149.40.62.2', 1790006406, 55, 55, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 2, 0, 0, 1792598344, 500, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 877.523, 853.269, 13.493, 160.02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 'Test_Test', '71BE7A68BF2B164EE05A2553B4D3BCB46B29E09B18C892983E83494DEEFDE773', 'AmumZj[X@;', 'None', 0, 1, '0,0,0,0,0,0,0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1790009590, '138.199.35.123', '138.199.35.123', 1790009754, 71, 71, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1712.89, 2452.62, 14.979, 49.13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 'Test_Tesst', 'B421F4888D6F41ABA073855FACB3FC67475152E90A422EC970C32F453D20E73C', 'f>bBNc=@];', 'None', 0, 1, '0,0,0,0,0,0,0', 0, 0, 0, 0, 78, 30000000, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1790009840, '138.199.35.123', '138.199.35.123', 1790010017, 67, 67, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1792601843, 0, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2638.55, 2000.71, 9.563, 179.142, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(13, 'Foksi_Techo', '01B6FFE04410DF3A8EEEF8275C1B1784548E81B18C157EA23B48DC02FC6C1B34', '\\4h;gp]>f>', 'None', 0, 1, '0,0,0,0,0,0,0', 0, 0, 0, 0, 266, 4645600, 0, 0, 0, 100, 0, 17500000, 11, 0, -1, 1, 0, 0, '0,0,0,0,0,0,0', 0, 'Разработчик', 0, 0, 1488, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1790010603, '77.79.149.199', '77.79.149.199', 1790011712, 1030, 1030, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1792602603, 43218, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -727.463, -1548.69, 41.251, 2.127, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `aclogs`
--

CREATE TABLE `aclogs` (
  `id` int(11) NOT NULL,
  `type` varchar(16) NOT NULL,
  `date` varchar(24) NOT NULL,
  `name` varchar(24) NOT NULL,
  `reason` varchar(32) NOT NULL,
  `data` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci ROW_FORMAT=COMPRESSED;

-- --------------------------------------------------------

--
-- Структура таблицы `action_log`
--

CREATE TABLE `action_log` (
  `id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255',
  `type` int(11) NOT NULL,
  `description` varchar(128) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `action_log`
--

INSERT INTO `action_log` (`id`, `acc_id`, `uip`, `type`, `description`, `time`) VALUES
(1, 7, '178.216.209.173', 3, 'Игрок получил базовые лицензии при регистрации.', 1788244729),
(2, 7, '178.216.209.173', 3, 'Установил Dev_Triton[acc:7] скин 99', 1788326817),
(3, 7, '178.216.209.173', 3, 'Телепортировался к себе авто №1', 1788328250),
(4, 7, '178.216.209.173', 3, 'Телепортировался к себе авто №1', 1788335707),
(5, 7, '178.216.209.173', 3, 'Телепортировался к себе авто №1', 1788336609),
(6, 7, '178.216.209.173', 3, 'Телепортировался к себе авто №1', 1788337619),
(7, 7, '178.216.209.173', 3, 'Телепортировался к себе авто №1', 1788339003),
(8, 7, '178.216.209.173', 3, 'Телепортировался к себе авто №1', 1788339230),
(9, 8, '92.36.120.113', 3, 'Игрок получил базовые лицензии при регистрации.', 1788852094),
(10, 8, '92.36.120.113', 10, 'Выдал Manta_Dev[acc:8] 10000 рублей', 1788853085),
(11, 8, '92.36.120.113', 10, 'Выдал Manta_Dev[acc:8] 10000 рублей', 1788853086),
(12, 8, '92.36.120.113', 10, 'Выдал Manta_Dev[acc:8] 10000 рублей', 1788853088),
(13, 8, '92.36.120.113', 10, 'Выдал Manta_Dev[acc:8] 10000 рублей', 1788853089),
(14, 8, '92.36.120.113', 3, 'Использует меню телепортов', 1788853366),
(15, 8, '92.36.120.113', 10, 'Выдал Manta_Dev[acc:8] 500000000 руб', 1788853436),
(16, 8, '92.36.120.113', 3, 'Использует меню телепортов', 1788853456),
(17, 8, '92.36.120.113', 3, 'Использует меню телепортов', 1788853592),
(18, 8, '92.36.120.113', 7, 'Желаем удачи на сервере RED. С любовью Разработчик', 1788853817),
(19, 8, '146.70.230.147', 3, 'Использует меню телепортов', 1788896256),
(20, 8, '146.70.230.147', 3, 'Использует меню телепортов', 1788896311),
(21, 8, '185.184.192.248', 3, 'Использует меню телепортов', 1789729468),
(22, 8, '185.184.192.248', 3, 'Использует меню телепортов', 1789729483),
(23, 9, '37.114.130.149', 3, 'Игрок получил базовые лицензии при регистрации.', 1789733933),
(24, 8, '169.150.218.139', 3, 'Использует меню телепортов', 1789736112),
(25, 10, '149.40.62.2', 3, 'Игрок получил базовые лицензии при регистрации.', 1790006344),
(26, 12, '138.199.35.123', 3, 'Игрок получил базовые лицензии при регистрации.', 1790009843),
(27, 13, '77.79.149.199', 3, 'Игрок получил базовые лицензии при регистрации.', 1790010603),
(28, 8, '138.199.35.123', 3, 'Использует меню телепортов', 1790010651),
(29, 8, '138.199.35.123', 3, 'Использует меню телепортов', 1790010656),
(30, 8, '138.199.35.123', 3, 'Использует меню телепортов', 1790010707),
(31, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790010793),
(32, 8, '138.199.35.123', 3, '[A] paxan_terror установил префикс \'Разработчик\' администратору: Foksi_Techo', 1790010864),
(33, 8, '138.199.35.123', 1, '!', 1790010872),
(34, 8, '138.199.35.123', 1, '!', 1790010873),
(35, 8, '138.199.35.123', 1, '!', 1790010873),
(36, 8, '138.199.35.123', 3, '[A] paxan_terror установил префикс \'Владклкц\' администратору: paxan_terror', 1790010901),
(37, 8, '138.199.35.123', 3, '[A] paxan_terror установил префикс \'Владелеы\' администратору: paxan_terror', 1790010908),
(38, 8, '138.199.35.123', 3, '[A] paxan_terror установил префикс \'Владелец\' администратору: paxan_terror', 1790010909),
(39, 13, '77.79.149.199', 10, 'Выдал Foksi_Techo[acc:13] 10000 рублей', 1790010948),
(40, 13, '77.79.149.199', 10, 'Выдал Foksi_Techo[acc:13] 10000 рублей', 1790010949),
(41, 13, '77.79.149.199', 10, 'Выдал Foksi_Techo[acc:13] 10000 рублей', 1790010949),
(42, 13, '77.79.149.199', 10, 'Выдал Foksi_Techo[acc:13] 10000 рублей', 1790010950),
(43, 13, '77.79.149.199', 10, 'Выдал Foksi_Techo[acc:13] 10000 рублей', 1790010950),
(44, 13, '77.79.149.199', 3, 'Выдал Foksi_Techo[acc:13] Дробовик[200 патр]', 1790011158),
(45, 13, '77.79.149.199', 3, 'Выдал Foksi_Techo[acc:13] Пустынный орёл[200 патр]', 1790011162),
(46, 8, '138.199.35.123', 3, 'Телепортировал к себе Foksi_Techo[acc:13]', 1790011170),
(47, 8, '138.199.35.123', 3, 'Телепортировал к себе Foksi_Techo[acc:13]', 1790011184),
(48, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011254),
(49, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011257),
(50, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011258),
(51, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011259),
(52, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011259),
(53, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011259),
(54, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011260),
(55, 8, '138.199.35.123', 3, 'Телепортировался к Foksi_Techo[acc:13]', 1790011260),
(56, 8, '138.199.35.123', 1, 'я щяс ему напишк', 1790011266),
(57, 8, '138.199.35.123', 1, 'апрошу где делся иег', 1790011276),
(58, 8, '138.199.35.123', 1, 'апрошу где делся рег', 1790011277),
(59, 13, '77.79.149.199', 1, 'стой дай зама', 1790011278),
(60, 13, '77.79.149.199', 1, 'стой дай зама', 1790011290),
(61, 13, '77.79.149.199', 1, 'дай ажминку зама основателя', 1790011299),
(62, 13, '77.79.149.199', 3, 'Телепортировался к Foksi_Techo[acc:13] его авто', 1790011410),
(63, 13, '77.79.149.199', 3, 'Телепортировался к Foksi_Techo[acc:13] его авто', 1790011491),
(64, 13, '77.79.149.199', 3, 'Телепортировался к Foksi_Techo[acc:13] его авто', 1790011534),
(65, 13, '77.79.149.199', 3, 'Телепортировался к Foksi_Techo[acc:13] его авто', 1790011631),
(66, 13, '77.79.149.199', 3, 'Телепортировался к Foksi_Techo[acc:13] его авто', 1790011655);

-- --------------------------------------------------------

--
-- Структура таблицы `activated_promos`
--

CREATE TABLE `activated_promos` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `promo_id` int(11) NOT NULL,
  `activated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `admin_stats_online`
--

CREATE TABLE `admin_stats_online` (
  `account_id` int(11) NOT NULL,
  `stat_date` date NOT NULL,
  `seconds` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `allowed_servers`
--

CREATE TABLE `allowed_servers` (
  `id` int(11) NOT NULL,
  `ip_port` varchar(40) NOT NULL,
  `server_name` varchar(100) DEFAULT '',
  `added_reason` varchar(255) DEFAULT '',
  `date_added` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `auction_bids`
--

CREATE TABLE `auction_bids` (
  `id` int(11) NOT NULL,
  `auction_id` int(11) NOT NULL,
  `bidder_account_id` int(11) NOT NULL,
  `bidder_name` varchar(24) NOT NULL,
  `amount` int(11) NOT NULL,
  `created_at` int(11) NOT NULL,
  `status` varchar(24) NOT NULL DEFAULT 'active',
  `refunded_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `auction_history`
--

CREATE TABLE `auction_history` (
  `id` int(11) NOT NULL,
  `auction_id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL,
  `seller_account_id` int(11) NOT NULL,
  `buyer_account_id` int(11) NOT NULL DEFAULT -1,
  `final_price` int(11) NOT NULL DEFAULT 0,
  `commission` int(11) NOT NULL DEFAULT 0,
  `result` varchar(32) NOT NULL,
  `completed_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `auction_lots`
--

CREATE TABLE `auction_lots` (
  `id` int(11) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT 0,
  `item_type` int(11) NOT NULL,
  `item_database_id` int(11) NOT NULL,
  `business_type` int(11) NOT NULL DEFAULT 0,
  `seller_account_id` int(11) NOT NULL DEFAULT 0,
  `seller_name` varchar(24) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `description` varchar(128) NOT NULL DEFAULT '',
  `start_price` int(11) NOT NULL,
  `current_price` int(11) NOT NULL,
  `highest_bidder_account_id` int(11) NOT NULL DEFAULT -1,
  `highest_bidder_name` varchar(24) NOT NULL DEFAULT '',
  `commission_percent` int(11) NOT NULL DEFAULT 5,
  `is_state_lot` tinyint(4) NOT NULL DEFAULT 0,
  `state_reason` varchar(64) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL,
  `ends_at` int(11) NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `auction_lots`
--

INSERT INTO `auction_lots` (`id`, `server_id`, `item_type`, `item_database_id`, `business_type`, `seller_account_id`, `seller_name`, `item_name`, `description`, `start_price`, `current_price`, `highest_bidder_account_id`, `highest_bidder_name`, `commission_percent`, `is_state_lot`, `state_reason`, `created_at`, `ends_at`, `status`) VALUES
(1, 0, 1, 1, 1, 0, 'Государство', 'Магазин 24/7 (0)', 'Государственный бизнес [ID:0]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(2, 1, 1, 2, 1, 0, 'Государство', 'Магазин 24/7 (1)', 'Государственный бизнес [ID:1]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(3, 2, 1, 3, 1, 0, 'Государство', 'Магазин 24/7 (2)', 'Государственный бизнес [ID:2]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(4, 3, 1, 4, 1, 0, 'Государство', 'Магазин 24/7 (3)', 'Государственный бизнес [ID:3]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(5, 4, 1, 5, 1, 0, 'Государство', 'Магазин 24/7 (4)', 'Государственный бизнес [ID:4]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(6, 5, 1, 6, 1, 0, 'Государство', 'Магазин 24/7 (5)', 'Государственный бизнес [ID:5]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(7, 6, 1, 7, 1, 0, 'Государство', 'Магазин 24/7 (6)', 'Государственный бизнес [ID:6]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(8, 7, 1, 8, 1, 0, 'Государство', 'Магазин 24/7 (7)', 'Государственный бизнес [ID:7]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(9, 8, 1, 9, 1, 0, 'Государство', 'Магазин 24/7 (8)', 'Государственный бизнес [ID:8]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(10, 9, 1, 10, 1, 0, 'Государство', 'Магазин 24/7 (9)', 'Государственный бизнес [ID:9]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(11, 10, 1, 11, 1, 0, 'Государство', 'Магазин 24/7 (10)', 'Государственный бизнес [ID:10]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(12, 11, 1, 12, 1, 0, 'Государство', 'Магазин 24/7 (11)', 'Государственный бизнес [ID:11]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007993, 'active'),
(13, 12, 1, 13, 1, 0, 'Государство', 'Магазин 24/7 (12)', 'Государственный бизнес [ID:12]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(14, 13, 1, 14, 1, 0, 'Государство', 'Магазин 24/7 (13)', 'Государственный бизнес [ID:13]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(15, 14, 1, 15, 1, 0, 'Государство', 'Магазин 24/7 (14)', 'Государственный бизнес [ID:14]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(16, 15, 1, 16, 1, 0, 'Государство', 'Магазин 24/7 (15)', 'Государственный бизнес [ID:15]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(17, 16, 1, 17, 1, 0, 'Государство', 'Магазин 24/7 (16)', 'Государственный бизнес [ID:16]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(18, 17, 1, 18, 1, 0, 'Государство', 'Магазин 24/7 (17)', 'Государственный бизнес [ID:17]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(19, 18, 1, 19, 1, 0, 'Государство', 'Магазин 24/7 (18)', 'Государственный бизнес [ID:18]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(20, 19, 1, 20, 1, 0, 'Государство', 'Магазин 24/7 (19)', 'Государственный бизнес [ID:19]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(21, 20, 1, 21, 1, 0, 'Государство', 'Магазин 24/7 (20)', 'Государственный бизнес [ID:20]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(22, 21, 1, 22, 3, 0, 'Государство', 'Управление статистики (21)', 'Государственный бизнес [ID:21]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(23, 22, 1, 23, 4, 0, 'Государство', 'Риелторское агентство (22)', 'Государственный бизнес [ID:22]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(24, 23, 1, 24, 5, 0, 'Государство', 'Магазин одежды (23)', 'Государственный бизнес [ID:23]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(25, 24, 1, 25, 5, 0, 'Государство', 'Магазин одежды (24)', 'Государственный бизнес [ID:24]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(26, 25, 1, 26, 5, 0, 'Государство', 'Магазин одежды (25)', 'Государственный бизнес [ID:25]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(27, 26, 1, 56, 1, 0, 'Государство', 'Магазин 24/7 (26)', 'Государственный бизнес [ID:26]', 300000, 300000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(28, 27, 1, 27, 5, 0, 'Государство', 'Магазин одежды (27)', 'Государственный бизнес [ID:27]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(29, 28, 1, 28, 5, 0, 'Государство', 'Магазин одежды (28)', 'Государственный бизнес [ID:28]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(30, 29, 1, 29, 5, 0, 'Государство', 'Магазин одежды (29)', 'Государственный бизнес [ID:29]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(31, 30, 1, 30, 5, 0, 'Государство', 'Магазин одежды (30)', 'Государственный бизнес [ID:30]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(32, 31, 1, 31, 6, 0, 'Государство', 'Отель (31)', 'Государственный бизнес [ID:31]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(33, 32, 1, 32, 6, 0, 'Государство', 'Отель (32)', 'Государственный бизнес [ID:32]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(34, 33, 1, 33, 6, 0, 'Государство', 'Отель (33)', 'Государственный бизнес [ID:33]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(35, 34, 1, 34, 7, 0, 'Государство', 'Автосалон (34)', 'Государственный бизнес [ID:34]', 5800000, 5800000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(36, 35, 1, 35, 7, 0, 'Государство', 'Автосалон низкого класса (35)', 'Государственный бизнес [ID:35]', 100000000, 100000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(37, 36, 1, 36, 7, 0, 'Государство', 'Автосалон высокого класса (36)', 'Государственный бизнес [ID:36]', 6150000, 6150000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(38, 37, 1, 37, 7, 0, 'Государство', 'Автосалон среднего класса (37)', 'Государственный бизнес [ID:37]', 8200000, 8200000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(39, 38, 1, 125, 7, 0, 'Государство', 'Мотосалон (38)', 'Государственный бизнес [ID:38]', 10000000, 10000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(40, 39, 1, 39, 7, 0, 'Государство', 'Салон грузовых автомобилей (39)', 'Государственный бизнес [ID:39]', 4620000, 4620000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(41, 40, 1, 57, 5, 0, 'Государство', 'Магазин одежды (40)', 'Государственный бизнес [ID:40]', 700000, 700000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(42, 41, 1, 58, 1, 0, 'Государство', 'Магазин 24/7 (41)', 'Государственный бизнес [ID:41]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(43, 42, 1, 60, 1, 0, 'Государство', 'Магазин 24/7 (42)', 'Государственный бизнес [ID:42]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(44, 43, 1, 67, 7, 0, 'Государство', 'Автосалон (43)', 'Государственный бизнес [ID:43]', 200000000, 200000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(45, 44, 1, 62, 1, 0, 'Государство', 'Магазин 24/7 (44)', 'Государственный бизнес [ID:44]', 5000000, 5000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(46, 45, 1, 63, 1, 0, 'Государство', 'Магазин 24/7 (45)', 'Государственный бизнес [ID:45]', 3000000, 3000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(47, 46, 1, 64, 5, 0, 'Государство', 'Магазин одежды (46)', 'Государственный бизнес [ID:46]', 500000000, 500000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(48, 47, 1, 66, 11, 0, 'Государство', 'Магазин оружия (47)', 'Государственный бизнес [ID:47]', 50000000, 50000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(49, 48, 1, 68, 10, 0, 'Государство', 'СТО (48)', 'Государственный бизнес [ID:48]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(50, 49, 1, 69, 1, 0, 'Государство', 'Магазин 24/7 (49)', 'Государственный бизнес [ID:49]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(51, 50, 1, 70, 10, 0, 'Государство', 'СТО (50)', 'Государственный бизнес [ID:50]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(52, 51, 1, 71, 2, 0, 'Государство', 'Клуб (51)', 'Государственный бизнес [ID:51]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(53, 52, 1, 81, 5, 0, 'Государство', 'Магазин одежды (52)', 'Государственный бизнес [ID:52]', 10303, 10303, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(54, 53, 1, 75, 9, 0, 'Государство', 'Сотовый салон (53)', 'Государственный бизнес [ID:53]', 1600123, 1600123, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(55, 54, 1, 84, 1, 0, 'Государство', 'Магазин 24/7 (54)', 'Государственный бизнес [ID:54]', 500123, 500123, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(56, 55, 1, 77, 11, 0, 'Государство', 'Магазин оружия (55)', 'Государственный бизнес [ID:55]', 10000000, 10000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(57, 56, 1, 73, 3, 0, 'Государство', 'Управление статистики (56)', 'Государственный бизнес [ID:56]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(58, 57, 1, 74, 11, 0, 'Государство', 'Магазин оружия (57)', 'Государственный бизнес [ID:57]', 10000000, 10000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(59, 58, 1, 78, 1, 0, 'Государство', 'Магазин 24/7 (58)', 'Государственный бизнес [ID:58]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(60, 59, 1, 79, 8, 0, 'Государство', 'Казино (30)', 'Государственный бизнес [ID:59]', 300000000, 300000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(61, 60, 1, 80, 8, 0, 'Государство', 'Казино (60)', 'Государственный бизнес [ID:60]', 12000123, 12000123, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(62, 61, 1, 82, 1, 0, 'Государство', 'Магазин 24/7 (61)', 'Государственный бизнес [ID:61]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(63, 62, 1, 83, 6, 0, 'Государство', 'Отель (62)', 'Государственный бизнес [ID:62]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(64, 63, 1, 85, 1, 0, 'Государство', 'Магазин 24/7 (63)', 'Государственный бизнес [ID:63]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(65, 64, 1, 86, 1, 0, 'Государство', 'Магазин 24/7 (64)', 'Государственный бизнес [ID:64]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(66, 65, 1, 87, 1, 0, 'Государство', 'Магазин 24/7 (65)', 'Государственный бизнес [ID:65]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(67, 66, 1, 88, 1, 0, 'Государство', 'Магазин 24/7 (66)', 'Государственный бизнес [ID:66]', 1200012, 1200012, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(68, 67, 1, 91, 1, 0, 'Государство', 'Магазин 24/7 (67)', 'Государственный бизнес [ID:67]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(69, 68, 1, 92, 1, 0, 'Государство', 'Магазин 24/7 (68)', 'Государственный бизнес [ID:68]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(70, 69, 1, 93, 1, 0, 'Государство', 'Магазин 24/7 (69)', 'Государственный бизнес [ID:69]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(71, 70, 1, 94, 11, 0, 'Государство', 'Магазин оружия (70)', 'Государственный бизнес [ID:70]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(72, 71, 1, 95, 1, 0, 'Государство', 'Магазин 24/7 (71)', 'Государственный бизнес [ID:71]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(73, 72, 1, 96, 1, 0, 'Государство', 'Магазин 24/7 (72)', 'Государственный бизнес [ID:72]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(74, 73, 1, 97, 1, 0, 'Государство', 'Магазин 24/7 (73)', 'Государственный бизнес [ID:73]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(75, 74, 1, 98, 1, 0, 'Государство', 'Магазин 24/7 (74)', 'Государственный бизнес [ID:74]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(76, 75, 1, 99, 1, 0, 'Государство', 'Магазин 24/7 (75)', 'Государственный бизнес [ID:75]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(77, 76, 1, 100, 1, 0, 'Государство', 'Магазин 24/7 (76)', 'Государственный бизнес [ID:76]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(78, 77, 1, 101, 1, 0, 'Государство', 'Магазин 24/7 (77)', 'Государственный бизнес [ID:77]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(79, 78, 1, 102, 1, 0, 'Государство', 'Магазин 24/7 (78)', 'Государственный бизнес [ID:78]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(80, 79, 1, 103, 1, 0, 'Государство', 'Магазин 24/7 (79)', 'Государственный бизнес [ID:79]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(81, 80, 1, 104, 1, 0, 'Государство', 'Магазин 24/7 (80)', 'Государственный бизнес [ID:80]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(82, 81, 1, 105, 1, 0, 'Государство', 'Магазин 24/7 (81)', 'Государственный бизнес [ID:81]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(83, 82, 1, 106, 1, 0, 'Государство', 'Магазин 24/7 (82)', 'Государственный бизнес [ID:82]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(84, 83, 1, 107, 1, 0, 'Государство', 'Магазин 24/7 (83)', 'Государственный бизнес [ID:83]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(85, 84, 1, 108, 11, 0, 'Государство', 'Магазин оружия (84)', 'Государственный бизнес [ID:84]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(86, 85, 1, 109, 11, 0, 'Государство', 'Магазин оружия (85)', 'Государственный бизнес [ID:85]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007994, 'active'),
(87, 86, 1, 110, 1, 0, 'Государство', 'Магазин 24/7 (86)', 'Государственный бизнес [ID:86]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(88, 87, 1, 111, 1, 0, 'Государство', 'Магазин 24/7 (87)', 'Государственный бизнес [ID:87]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(89, 88, 1, 112, 1, 0, 'Государство', 'Магазин 24/7 (88)', 'Государственный бизнес [ID:88]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(90, 89, 1, 113, 1, 0, 'Государство', 'Магазин 24/7 (89)', 'Государственный бизнес [ID:89]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(91, 90, 1, 114, 11, 0, 'Государство', 'Магазин оружия (90)', 'Государственный бизнес [ID:90]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(92, 91, 1, 115, 11, 0, 'Государство', 'Магазин оружия (91)', 'Государственный бизнес [ID:91]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(93, 92, 1, 116, 11, 0, 'Государство', 'Магазин оружия (92)', 'Государственный бизнес [ID:92]', 1000000, 1000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(94, 93, 1, 117, 1, 0, 'Государство', 'Магазин 24/7 (93)', 'Государственный бизнес [ID:93]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(95, 94, 1, 118, 1, 0, 'Государство', 'Магазин 24/7 (94)', 'Государственный бизнес [ID:94]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(96, 95, 1, 119, 1, 0, 'Государство', 'Магазин 24/7 (95)', 'Государственный бизнес [ID:95]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(97, 96, 1, 120, 1, 0, 'Государство', 'Магазин 24/7 (96)', 'Государственный бизнес [ID:96]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(98, 97, 1, 121, 1, 0, 'Государство', 'Магазин 24/7 (97)', 'Государственный бизнес [ID:97]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(99, 98, 1, 122, 1, 0, 'Государство', 'Магазин 24/7 (98)', 'Государственный бизнес [ID:98]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(100, 99, 1, 123, 5, 0, 'Государство', 'Магазин одежды (99)', 'Государственный бизнес [ID:99]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(101, 100, 1, 124, 5, 0, 'Государство', 'Магазин одежды (100)', 'Государственный бизнес [ID:100]', 1, 1, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(102, 101, 1, 126, 5, 0, 'Государство', 'Магазин одежды (101)', 'Государственный бизнес [ID:101]', 6, 6, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(103, 102, 1, 127, 5, 0, 'Государство', 'Магазин одежды (102)', 'Государственный бизнес [ID:102]', 6, 6, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(104, 103, 1, 129, 5, 0, 'Государство', 'Магазин одежды (103)', 'Государственный бизнес [ID:103]', 15000000, 15000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(105, 104, 1, 130, 5, 0, 'Государство', 'Магазин одежды (104)', 'Государственный бизнес [ID:104]', 15000000, 15000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(106, 105, 1, 131, 5, 0, 'Государство', 'Магазин одежды (105)', 'Государственный бизнес [ID:105]', 15000000, 15000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(107, 106, 1, 132, 5, 0, 'Государство', 'Магазин одежды (106)', 'Государственный бизнес [ID:106]', 15000000, 15000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(108, 107, 1, 133, 5, 0, 'Государство', 'Магазин одежды (107)', 'Государственный бизнес [ID:107]', 15000000, 15000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(109, 108, 1, 134, 5, 0, 'Государство', 'Магазин одежды (108)', 'Государственный бизнес [ID:108]', 15000000, 15000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(110, 109, 1, 135, 11, 0, 'Государство', 'Магазин оружия (109)', 'Государственный бизнес [ID:109]', 8750000, 8750000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(111, 110, 1, 136, 12, 0, 'Государство', 'Ларёк (110)', 'Государственный бизнес [ID:110]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(112, 111, 1, 137, 12, 0, 'Государство', 'Ларёк (111)', 'Государственный бизнес [ID:111]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(113, 112, 1, 138, 12, 0, 'Государство', 'Ларёк (112)', 'Государственный бизнес [ID:112]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(114, 113, 1, 139, 12, 0, 'Государство', 'Ларёк (113)', 'Государственный бизнес [ID:113]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(115, 114, 1, 140, 12, 0, 'Государство', 'Ларёк (114)', 'Государственный бизнес [ID:114]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(116, 115, 1, 141, 12, 0, 'Государство', 'Ларёк (115)', 'Государственный бизнес [ID:115]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(117, 116, 1, 142, 12, 0, 'Государство', 'Ларёк (116)', 'Государственный бизнес [ID:116]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(118, 117, 1, 143, 12, 0, 'Государство', 'Ларёк (117)', 'Государственный бизнес [ID:117]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(119, 118, 1, 144, 12, 0, 'Государство', 'Ларёк (118)', 'Государственный бизнес [ID:118]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(120, 119, 1, 145, 12, 0, 'Государство', 'Ларёк (119)', 'Государственный бизнес [ID:119]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(121, 120, 1, 146, 13, 0, 'Государство', 'Магазин аксессуаров (120)', 'Государственный бизнес [ID:120]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(122, 121, 1, 147, 12, 0, 'Государство', 'Ларёк (121)', 'Государственный бизнес [ID:121]', 7000000, 7000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(123, 122, 1, 148, 12, 0, 'Государство', 'Ларёк (122)', 'Государственный бизнес [ID:122]', 7000000, 7000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(124, 124, 1, 149, 14, 0, 'Государство', 'Стайлинг центр (124)', 'Государственный бизнес [ID:124]', 25000000, 25000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(125, 125, 1, 150, 16, 0, 'Государство', 'Шиномонтажный центр (125)', 'Государственный бизнес [ID:125]', 25000000, 25000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(126, 126, 1, 151, 15, 0, 'Государство', 'Технический центр (126)', 'Государственный бизнес [ID:126]', 25000000, 25000000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(127, 127, 1, 152, 1, 0, 'Государство', 'Магазин 24/7 (127)', 'Государственный бизнес [ID:127]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(128, 128, 1, 153, 1, 0, 'Государство', 'Магазин 24/7 (128)', 'Государственный бизнес [ID:128]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(129, 129, 1, 154, 1, 0, 'Государство', 'Магазин 24/7 (129)', 'Государственный бизнес [ID:129]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(130, 130, 1, 155, 1, 0, 'Государство', 'Магазин 24/7 (130)', 'Государственный бизнес [ID:130]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(131, 131, 1, 156, 1, 0, 'Государство', 'Магазин 24/7 (131)', 'Государственный бизнес [ID:131]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(132, 132, 1, 157, 1, 0, 'Государство', 'Магазин 24/7 (132)', 'Государственный бизнес [ID:132]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(133, 133, 1, 158, 1, 0, 'Государство', 'Магазин 24/7 (133)', 'Государственный бизнес [ID:133]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(134, 134, 1, 159, 12, 0, 'Государство', 'Ларёк (134)', 'Государственный бизнес [ID:134]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(135, 135, 1, 160, 12, 0, 'Государство', 'Ларёк (135)', 'Государственный бизнес [ID:135]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(136, 136, 1, 161, 12, 0, 'Государство', 'Ларёк (136)', 'Государственный бизнес [ID:136]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(137, 137, 1, 162, 12, 0, 'Государство', 'Ларёк (137)', 'Государственный бизнес [ID:137]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(138, 138, 1, 163, 12, 0, 'Государство', 'Ларёк (138)', 'Государственный бизнес [ID:138]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(139, 139, 1, 164, 12, 0, 'Государство', 'Ларёк (139)', 'Государственный бизнес [ID:139]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active'),
(140, 140, 1, 165, 12, 0, 'Государство', 'Ларёк (140)', 'Государственный бизнес [ID:140]', 500000, 500000, -1, '', 5, 1, 'Свободный бизнес', 1789935238, 1790007995, 'active');

-- --------------------------------------------------------

--
-- Структура таблицы `auction_pending_items`
--

CREATE TABLE `auction_pending_items` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL,
  `item_plate` varchar(32) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `auction_pending_money`
--

CREATE TABLE `auction_pending_money` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `reason` varchar(96) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `auction_slots`
--

CREATE TABLE `auction_slots` (
  `slot_id` int(11) NOT NULL,
  `slot_type` int(11) NOT NULL,
  `owner_account` int(11) NOT NULL,
  `owner_name` varchar(24) NOT NULL DEFAULT '-',
  `slot_name` varchar(32) NOT NULL DEFAULT '-',
  `description` varchar(124) NOT NULL DEFAULT '-',
  `bidder_account` int(11) NOT NULL DEFAULT -1,
  `start_rate` int(11) NOT NULL DEFAULT 0,
  `current_rate` int(11) NOT NULL DEFAULT 0,
  `timer_end` int(11) NOT NULL DEFAULT 0,
  `database_id` int(11) NOT NULL DEFAULT -1,
  `server_id` int(11) NOT NULL DEFAULT -1,
  `vehicle_number` varchar(7) NOT NULL DEFAULT '-',
  `phone_number` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `auction_slots`
--

INSERT INTO `auction_slots` (`slot_id`, `slot_type`, `owner_account`, `owner_name`, `slot_name`, `description`, `bidder_account`, `start_rate`, `current_rate`, `timer_end`, `database_id`, `server_id`, `vehicle_number`, `phone_number`) VALUES
(0, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (0)', -1, 1000000, 1000000, 1790017189, 1, 0, '-', 0),
(1, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (1)', -1, 1000000, 1000000, 1790017189, 2, 1, '-', 0),
(2, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (2)', -1, 1000000, 1000000, 1790017189, 3, 2, '-', 0),
(3, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (3)', -1, 1000000, 1000000, 1790017189, 4, 3, '-', 0),
(4, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (4)', -1, 1000000, 1000000, 1790017189, 5, 4, '-', 0),
(5, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (5)', -1, 1000000, 1000000, 1790017189, 6, 5, '-', 0),
(6, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (6)', -1, 1000000, 1000000, 1790017189, 7, 6, '-', 0),
(7, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (7)', -1, 1000000, 1000000, 1790017189, 8, 7, '-', 0),
(8, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (8)', -1, 1000000, 1000000, 1790017189, 9, 8, '-', 0),
(9, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (9)', -1, 1000000, 1000000, 1790017189, 10, 9, '-', 0),
(10, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (10)', -1, 1000000, 1000000, 1790017189, 11, 10, '-', 0),
(11, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (11)', -1, 1000000, 1000000, 1790017189, 12, 11, '-', 0),
(12, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (12)', -1, 1000000, 1000000, 1790017189, 13, 12, '-', 0),
(13, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (13)', -1, 1000000, 1000000, 1790017189, 14, 13, '-', 0),
(14, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (14)', -1, 1000000, 1000000, 1790017189, 15, 14, '-', 0),
(15, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (15)', -1, 1000000, 1000000, 1790017189, 16, 15, '-', 0),
(16, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (16)', -1, 1000000, 1000000, 1790017189, 17, 16, '-', 0),
(17, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (17)', -1, 1000000, 1000000, 1790017189, 18, 17, '-', 0),
(18, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (18)', -1, 1000000, 1000000, 1790017189, 19, 18, '-', 0),
(19, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (19)', -1, 1000000, 1000000, 1790017189, 20, 19, '-', 0),
(20, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (20)', -1, 1000000, 1000000, 1790017189, 21, 20, '-', 0),
(21, 1, -2, 'Государство', 'Управление Статистики', 'Государственный бизнес (21)', -1, 5000000, 5000000, 1790017189, 22, 21, '-', 0),
(22, 1, -2, 'Государство', 'Риелторское Агенство', 'Государственный бизнес (22)', -1, 5000000, 5000000, 1790017189, 23, 22, '-', 0),
(23, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (23)', -1, 5000000, 5000000, 1790017189, 24, 23, '-', 0),
(24, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (24)', -1, 5000000, 5000000, 1790017189, 25, 24, '-', 0),
(25, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (25)', -1, 5000000, 5000000, 1790017189, 26, 25, '-', 0),
(26, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (26)', -1, 300000, 300000, 1790017189, 56, 26, '-', 0),
(27, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (27)', -1, 5000000, 5000000, 1790017189, 27, 27, '-', 0),
(28, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (28)', -1, 5000000, 5000000, 1790017189, 28, 28, '-', 0),
(29, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (29)', -1, 5000000, 5000000, 1790017189, 29, 29, '-', 0),
(30, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (30)', -1, 5000000, 5000000, 1790017189, 30, 30, '-', 0),
(31, 1, -2, 'Государство', 'Отель', 'Государственный бизнес (31)', -1, 5000000, 5000000, 1790017189, 31, 31, '-', 0),
(32, 1, -2, 'Государство', 'Отель', 'Государственный бизнес (32)', -1, 5000000, 5000000, 1790017189, 32, 32, '-', 0),
(33, 1, -2, 'Государство', 'Отель', 'Государственный бизнес (33)', -1, 5000000, 5000000, 1790017189, 33, 33, '-', 0),
(34, 1, -2, 'Государство', 'Автосалон', 'Государственный бизнес (34)', -1, 5800000, 5800000, 1790017189, 34, 34, '-', 0),
(35, 1, -2, 'Государство', 'Автосалон', 'Государственный бизнес (35)', -1, 100000000, 100000000, 1790017189, 35, 35, '-', 0),
(36, 1, -2, 'Государство', 'Автосалон', 'Государственный бизнес (36)', -1, 6150000, 6150000, 1790017189, 36, 36, '-', 0),
(37, 1, -2, 'Государство', 'Автосалон', 'Государственный бизнес (37)', -1, 8200000, 8200000, 1790017189, 37, 37, '-', 0),
(38, 1, -2, 'Государство', '', 'Государственный бизнес (38)', -1, 10000000, 10000000, 1790017189, 125, 38, '-', 0),
(39, 1, -2, 'Государство', 'Сотовый салон', 'Государственный бизнес (39)', -1, 4620000, 4620000, 1790017189, 39, 39, '-', 0),
(40, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (40)', -1, 700000, 700000, 1790017189, 57, 40, '-', 0),
(41, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (41)', -1, 1000000, 1000000, 1790017189, 58, 41, '-', 0),
(42, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (42)', -1, 1000000, 1000000, 1790017189, 60, 42, '-', 0),
(43, 1, -2, 'Государство', 'Автосалон', 'Государственный бизнес (43)', -1, 200000000, 200000000, 1790017189, 67, 43, '-', 0),
(44, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (44)', -1, 5000000, 5000000, 1790017189, 62, 44, '-', 0),
(45, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (45)', -1, 3000000, 3000000, 1790017189, 63, 45, '-', 0),
(46, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (46)', -1, 500000000, 500000000, 1790017189, 64, 46, '-', 0),
(47, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (47)', -1, 50000000, 50000000, 1790017189, 66, 47, '-', 0),
(48, 1, -2, 'Государство', 'СТО', 'Государственный бизнес (48)', -1, 1, 1, 1790017189, 68, 48, '-', 0),
(49, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (49)', -1, 1000000, 1000000, 1790017189, 69, 49, '-', 0),
(50, 1, -2, 'Государство', 'СТО', 'Государственный бизнес (50)', -1, 1, 1, 1790017189, 70, 50, '-', 0),
(51, 1, -2, 'Государство', 'Клуб', 'Государственный бизнес (51)', -1, 1, 1, 1790017189, 71, 51, '-', 0),
(52, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (52)', -1, 10303, 10303, 1790017189, 81, 52, '-', 0),
(53, 1, -2, 'Государство', 'Сотовый салон', 'Государственный бизнес (53)', -1, 1600123, 1600123, 1790017189, 75, 53, '-', 0),
(54, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (54)', -1, 500123, 500123, 1790017189, 84, 54, '-', 0),
(55, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (55)', -1, 10000000, 10000000, 1790017189, 77, 55, '-', 0),
(56, 1, -2, 'Государство', 'Управление Статистики', 'Государственный бизнес (56)', -1, 1, 1, 1790017189, 73, 56, '-', 0),
(57, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (57)', -1, 10000000, 10000000, 1790017189, 74, 57, '-', 0),
(58, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (58)', -1, 500000, 500000, 1790017189, 78, 58, '-', 0),
(59, 1, -2, 'Государство', 'Казино', 'Государственный бизнес (59)', -1, 300000000, 300000000, 1790017189, 79, 59, '-', 0),
(60, 1, -2, 'Государство', 'Казино', 'Государственный бизнес (60)', -1, 12000123, 12000123, 1790017189, 80, 60, '-', 0),
(61, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (61)', -1, 1, 1, 1790017189, 82, 61, '-', 0),
(62, 1, -2, 'Государство', 'Отель', 'Государственный бизнес (62)', -1, 1, 1, 1790017189, 83, 62, '-', 0),
(63, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (63)', -1, 500000, 500000, 1790017189, 85, 63, '-', 0),
(64, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (64)', -1, 500000, 500000, 1790017189, 86, 64, '-', 0),
(65, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (65)', -1, 500000, 500000, 1790017189, 87, 65, '-', 0),
(66, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (66)', -1, 1200012, 1200012, 1790017189, 88, 66, '-', 0),
(67, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (67)', -1, 1, 1, 1790017189, 91, 67, '-', 0),
(68, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (68)', -1, 500000, 500000, 1790017189, 92, 68, '-', 0),
(69, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (69)', -1, 1000000, 1000000, 1790017189, 93, 69, '-', 0),
(70, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (70)', -1, 1000000, 1000000, 1790017189, 94, 70, '-', 0),
(71, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (71)', -1, 500000, 500000, 1790017189, 95, 71, '-', 0),
(72, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (72)', -1, 500000, 500000, 1790017189, 96, 72, '-', 0),
(73, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (73)', -1, 500000, 500000, 1790017189, 97, 73, '-', 0),
(74, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (74)', -1, 500000, 500000, 1790017189, 98, 74, '-', 0),
(75, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (75)', -1, 500000, 500000, 1790017189, 99, 75, '-', 0),
(76, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (76)', -1, 500000, 500000, 1790017189, 100, 76, '-', 0),
(77, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (77)', -1, 500000, 500000, 1790017189, 101, 77, '-', 0),
(78, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (78)', -1, 500000, 500000, 1790017189, 102, 78, '-', 0),
(79, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (79)', -1, 500000, 500000, 1790017189, 103, 79, '-', 0),
(80, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (80)', -1, 1000000, 1000000, 1790017189, 104, 80, '-', 0),
(81, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (81)', -1, 500000, 500000, 1790017189, 105, 81, '-', 0),
(82, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (82)', -1, 500000, 500000, 1790017189, 106, 82, '-', 0),
(83, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (83)', -1, 500000, 500000, 1790017189, 107, 83, '-', 0),
(84, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (84)', -1, 1000000, 1000000, 1790017189, 108, 84, '-', 0),
(85, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (85)', -1, 500000, 500000, 1790017189, 109, 85, '-', 0),
(86, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (86)', -1, 1000000, 1000000, 1790017189, 110, 86, '-', 0),
(87, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (87)', -1, 500000, 500000, 1790017189, 111, 87, '-', 0),
(88, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (88)', -1, 500000, 500000, 1790017189, 112, 88, '-', 0),
(89, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (89)', -1, 500000, 500000, 1790017189, 113, 89, '-', 0),
(90, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (90)', -1, 1000000, 1000000, 1790017189, 114, 90, '-', 0),
(91, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (91)', -1, 500000, 500000, 1790017189, 115, 91, '-', 0),
(92, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (92)', -1, 1000000, 1000000, 1790017189, 116, 92, '-', 0),
(93, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (93)', -1, 500000, 500000, 1790017189, 117, 93, '-', 0),
(94, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (94)', -1, 500000, 500000, 1790017189, 118, 94, '-', 0),
(95, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (95)', -1, 500000, 500000, 1790017189, 119, 95, '-', 0),
(96, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (96)', -1, 500000, 500000, 1790017189, 120, 96, '-', 0),
(97, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (97)', -1, 500000, 500000, 1790017189, 121, 97, '-', 0),
(98, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (98)', -1, 500000, 500000, 1790017189, 122, 98, '-', 0),
(99, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (99)', -1, 1, 1, 1790017189, 123, 99, '-', 0),
(100, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (100)', -1, 1, 1, 1790017189, 124, 100, '-', 0),
(101, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (101)', -1, 6, 6, 1790017189, 126, 101, '-', 0),
(102, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (102)', -1, 6, 6, 1790017189, 127, 102, '-', 0),
(103, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (103)', -1, 15000000, 15000000, 1790017189, 129, 103, '-', 0),
(104, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (104)', -1, 15000000, 15000000, 1790017189, 130, 104, '-', 0),
(105, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (105)', -1, 15000000, 15000000, 1790017189, 131, 105, '-', 0),
(106, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (106)', -1, 15000000, 15000000, 1790017189, 132, 106, '-', 0),
(107, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (107)', -1, 15000000, 15000000, 1790017189, 133, 107, '-', 0),
(108, 1, -2, 'Государство', 'Магазин одежды', 'Государственный бизнес (108)', -1, 15000000, 15000000, 1790017189, 134, 108, '-', 0),
(109, 1, -2, 'Государство', 'Магазин Оружия', 'Государственный бизнес (109)', -1, 8750000, 8750000, 1790017189, 135, 109, '-', 0),
(110, 1, -2, 'Государство', 'Ларёк #111', 'Государственный бизнес (110)', -1, 500000, 500000, 1790017189, 136, 110, '-', 0),
(111, 1, -2, 'Государство', 'Ларёк #112', 'Государственный бизнес (111)', -1, 500000, 500000, 1790017189, 137, 111, '-', 0),
(112, 1, -2, 'Государство', 'Ларёк #113', 'Государственный бизнес (112)', -1, 500000, 500000, 1790017189, 138, 112, '-', 0),
(113, 1, -2, 'Государство', 'Ларёк #114', 'Государственный бизнес (113)', -1, 500000, 500000, 1790017189, 139, 113, '-', 0),
(114, 1, -2, 'Государство', 'Ларёк #115', 'Государственный бизнес (114)', -1, 500000, 500000, 1790017189, 140, 114, '-', 0),
(115, 1, -2, 'Государство', 'Ларёк #116', 'Государственный бизнес (115)', -1, 500000, 500000, 1790017189, 141, 115, '-', 0),
(116, 1, -2, 'Государство', 'Ларёк #117', 'Государственный бизнес (116)', -1, 500000, 500000, 1790017189, 142, 116, '-', 0),
(117, 1, -2, 'Государство', 'Ларёк #118', 'Государственный бизнес (117)', -1, 500000, 500000, 1790017189, 143, 117, '-', 0),
(118, 1, -2, 'Государство', 'Ларёк #119', 'Государственный бизнес (118)', -1, 500000, 500000, 1790017189, 144, 118, '-', 0),
(119, 1, -2, 'Государство', 'Ларёк #120', 'Государственный бизнес (119)', -1, 500000, 500000, 1790017189, 145, 119, '-', 0),
(120, 1, -2, 'Государство', '', 'Государственный бизнес (120)', -1, 500000, 500000, 1790017189, 146, 120, '-', 0),
(121, 1, -2, 'Государство', 'Ларёк #122', 'Государственный бизнес (121)', -1, 7000000, 7000000, 1790017189, 147, 121, '-', 0),
(122, 1, -2, 'Государство', 'Магазин аксесуаров', 'Государственный бизнес (122)', -1, 7000000, 7000000, 1790017189, 148, 122, '-', 0),
(123, 1, -2, 'Государство', 'Ларёк #124', 'Государственный бизнес (123)', -1, 500000, 500000, 1790017189, 0, 123, '-', 0),
(124, 1, -2, 'Государство', 'Стайлинг центр', 'Государственный бизнес (124)', -1, 25000000, 25000000, 1790017189, 149, 124, '-', 0),
(125, 1, -2, 'Государство', 'Шиномонтажный центр', 'Государственный бизнес (125)', -1, 25000000, 25000000, 1790017189, 150, 125, '-', 0),
(126, 1, -2, 'Государство', 'Технический центр', 'Государственный бизнес (126)', -1, 25000000, 25000000, 1790017189, 151, 126, '-', 0),
(127, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (127)', -1, 500000, 500000, 1790017189, 152, 127, '-', 0),
(128, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (128)', -1, 500000, 500000, 1790017189, 153, 128, '-', 0),
(129, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (129)', -1, 500000, 500000, 1790017189, 154, 129, '-', 0),
(130, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (130)', -1, 500000, 500000, 1790017189, 155, 130, '-', 0),
(131, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (131)', -1, 500000, 500000, 1790017189, 156, 131, '-', 0),
(132, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (132)', -1, 500000, 500000, 1790017189, 157, 132, '-', 0),
(133, 1, -2, 'Государство', 'Магазин 24/7', 'Государственный бизнес (133)', -1, 500000, 500000, 1790017189, 158, 133, '-', 0),
(134, 1, -2, 'Государство', 'Ларёк #135', 'Государственный бизнес (134)', -1, 500000, 500000, 1790017189, 159, 134, '-', 0),
(135, 1, -2, 'Государство', 'Ларёк #136', 'Государственный бизнес (135)', -1, 500000, 500000, 1790017189, 160, 135, '-', 0),
(136, 1, -2, 'Государство', 'Ларёк #137', 'Государственный бизнес (136)', -1, 500000, 500000, 1790017189, 161, 136, '-', 0),
(137, 1, -2, 'Государство', 'Ларёк #138', 'Государственный бизнес (137)', -1, 500000, 500000, 1790017189, 162, 137, '-', 0),
(138, 1, -2, 'Государство', 'Ларёк #139', 'Государственный бизнес (138)', -1, 500000, 500000, 1790017189, 163, 138, '-', 0),
(139, 1, -2, 'Государство', 'Ларёк #140', 'Государственный бизнес (139)', -1, 500000, 500000, 1790017189, 164, 139, '-', 0),
(140, 1, -2, 'Государство', 'Ларёк #141', 'Государственный бизнес (140)', -1, 500000, 500000, 1790017189, 165, 140, '-', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `autosalon`
--

CREATE TABLE `autosalon` (
  `market_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `slots` int(11) NOT NULL DEFAULT 0,
  `updated_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `bank_accounts`
--

CREATE TABLE `bank_accounts` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `name` varchar(21) NOT NULL DEFAULT 'None',
  `balance` int(11) NOT NULL,
  `pin` varchar(9) NOT NULL DEFAULT '0000',
  `reg_time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `bank_accounts_log`
--

CREATE TABLE `bank_accounts_log` (
  `id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255',
  `time` int(11) NOT NULL,
  `description` varchar(64) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `ban_list`
--

CREATE TABLE `ban_list` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `ban_time` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `description` varchar(32) NOT NULL,
  `admin` varchar(24) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `blackpass_logs`
--

CREATE TABLE `blackpass_logs` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `season_number` int(11) NOT NULL,
  `action` varchar(32) NOT NULL,
  `reward_id` int(11) NOT NULL DEFAULT 0,
  `reward_type` int(11) NOT NULL DEFAULT 0,
  `reward_value` int(11) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `extra` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `blackpass_logs`
--

INSERT INTO `blackpass_logs` (`id`, `account_id`, `season_number`, `action`, `reward_id`, `reward_type`, `reward_value`, `amount`, `extra`, `created_at`) VALUES
(1, 8, 28, 'task_claim', 254, 10, 200, 1, 1, 1790010520),
(2, 13, 28, 'task_claim', 254, 10, 200, 1, 1, 1790010608);

-- --------------------------------------------------------

--
-- Структура таблицы `blackpass_players`
--

CREATE TABLE `blackpass_players` (
  `account_id` int(11) NOT NULL,
  `season_number` int(11) NOT NULL,
  `experience` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `premium_status` int(11) NOT NULL DEFAULT 0,
  `dust` int(11) NOT NULL DEFAULT 0,
  `selected_layout` int(11) NOT NULL DEFAULT 0,
  `deluxe_rewards_claimed` tinyint(1) NOT NULL DEFAULT 0,
  `claimed_standard` varchar(80) NOT NULL DEFAULT '',
  `claimed_premium` varchar(80) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL DEFAULT 0,
  `updated_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `blackpass_players`
--

INSERT INTO `blackpass_players` (`account_id`, `season_number`, `experience`, `level`, `premium_status`, `dust`, `selected_layout`, `deluxe_rewards_claimed`, `claimed_standard`, `claimed_premium`, `created_at`, `updated_at`) VALUES
(8, 28, 200, 1, 0, 0, 0, 0, '0000000000000000000000000000000000000000000000000000000000000', '0000000000000000000000000000000000000000000000000000000000000', 1790010511, 1790010520),
(10, 28, 0, 1, 0, 0, 0, 0, '', '', 1790006344, 1790006344),
(12, 28, 0, 1, 0, 0, 0, 0, '', '', 1790009843, 1790009843),
(13, 28, 200, 1, 0, 0, 0, 0, '0000000000000000000000000000000000000000000000000000000000000', '0000000000000000000000000000000000000000000000000000000000000', 1790010603, 1790010608);

-- --------------------------------------------------------

--
-- Структура таблицы `blackpass_tasks`
--

CREATE TABLE `blackpass_tasks` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `season_number` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `task_group` int(11) NOT NULL,
  `period_key` int(11) NOT NULL,
  `target_count` int(11) NOT NULL DEFAULT 0,
  `reward_exp` int(11) NOT NULL DEFAULT 0,
  `reward_money` int(11) NOT NULL DEFAULT 0,
  `route_id` int(11) NOT NULL DEFAULT 0,
  `button_type` int(11) NOT NULL DEFAULT 0,
  `premium_only` tinyint(1) NOT NULL DEFAULT 0,
  `progress` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0,
  `tracked` tinyint(1) NOT NULL DEFAULT 0,
  `complete_notified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL DEFAULT 0,
  `updated_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `blackpass_tasks`
--

INSERT INTO `blackpass_tasks` (`id`, `account_id`, `season_number`, `task_id`, `task_group`, `period_key`, `target_count`, `reward_exp`, `reward_money`, `route_id`, `button_type`, `premium_only`, `progress`, `status`, `tracked`, `complete_notified`, `created_at`, `updated_at`) VALUES
(1, 10, 28, 254, 1, 20717, 1, 200, 1000, 0, 1, 0, 1, 1, 0, 1, 1790006344, 1790006344),
(2, 10, 28, 52, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(3, 10, 28, 124, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(4, 10, 28, 108, 1, 20717, 1, 200, 1000, 126, 6, 0, 1, 1, 0, 1, 1790006344, 1790006362),
(5, 10, 28, 96, 1, 20717, 1, 200, 1000, 32, 6, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(6, 10, 28, 97, 1, 20717, 1, 200, 1000, 157, 6, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(7, 10, 28, 99, 2, 2959, 15000, 800, 5000, 144, 1, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(8, 10, 28, 256, 2, 2959, 8, 800, 5000, 49, 6, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(9, 10, 28, 257, 2, 2959, 100000, 800, 5000, 0, 6, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(10, 10, 28, 6, 2, 2959, 1, 800, 5000, 69, 1, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(11, 10, 28, 255, 2, 2959, 5, 800, 5000, 0, 4, 0, 0, 0, 0, 0, 1790006344, 1790006344),
(12, 12, 28, 254, 1, 20717, 1, 200, 1000, 0, 1, 0, 1, 1, 0, 1, 1790009843, 1790009964),
(13, 12, 28, 52, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(14, 12, 28, 124, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(15, 12, 28, 108, 1, 20717, 1, 200, 1000, 126, 6, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(16, 12, 28, 96, 1, 20717, 1, 200, 1000, 32, 6, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(17, 12, 28, 97, 1, 20717, 1, 200, 1000, 157, 6, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(18, 12, 28, 99, 2, 2959, 15000, 800, 5000, 144, 1, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(19, 12, 28, 256, 2, 2959, 8, 800, 5000, 49, 6, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(20, 12, 28, 257, 2, 2959, 100000, 800, 5000, 0, 6, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(21, 12, 28, 6, 2, 2959, 1, 800, 5000, 69, 1, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(22, 12, 28, 255, 2, 2959, 5, 800, 5000, 0, 4, 0, 0, 0, 0, 0, 1790009843, 1790009843),
(23, 8, 28, 254, 1, 20717, 1, 200, 1000, 0, 1, 0, 1, 6, 0, 1, 1790010511, 1790010520),
(24, 8, 28, 52, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(25, 8, 28, 124, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(26, 8, 28, 108, 1, 20717, 1, 200, 1000, 126, 6, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(27, 8, 28, 96, 1, 20717, 1, 200, 1000, 32, 6, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(28, 8, 28, 97, 1, 20717, 1, 200, 1000, 157, 6, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(29, 8, 28, 99, 2, 2959, 15000, 800, 5000, 144, 1, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(30, 8, 28, 256, 2, 2959, 8, 800, 5000, 49, 6, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(31, 8, 28, 257, 2, 2959, 100000, 800, 5000, 0, 6, 0, 10000, 0, 0, 0, 1790010511, 1790010740),
(32, 8, 28, 6, 2, 2959, 1, 800, 5000, 69, 1, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(33, 8, 28, 255, 2, 2959, 5, 800, 5000, 0, 4, 0, 0, 0, 0, 0, 1790010511, 1790010511),
(34, 13, 28, 254, 1, 20717, 1, 200, 1000, 0, 1, 0, 1, 6, 0, 1, 1790010603, 1790010608),
(35, 13, 28, 52, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(36, 13, 28, 124, 1, 20717, 1, 200, 1000, 0, 6, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(37, 13, 28, 108, 1, 20717, 1, 200, 1000, 126, 6, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(38, 13, 28, 96, 1, 20717, 1, 200, 1000, 32, 6, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(39, 13, 28, 97, 1, 20717, 1, 200, 1000, 157, 6, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(40, 13, 28, 99, 2, 2959, 15000, 800, 5000, 144, 1, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(41, 13, 28, 256, 2, 2959, 8, 800, 5000, 49, 6, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(42, 13, 28, 257, 2, 2959, 100000, 800, 5000, 0, 6, 0, 0, 0, 0, 0, 1790010603, 1790010603),
(43, 13, 28, 6, 2, 2959, 1, 800, 5000, 69, 1, 0, 1, 1, 0, 1, 1790010603, 1790011644),
(44, 13, 28, 255, 2, 2959, 5, 800, 5000, 0, 4, 0, 0, 0, 0, 0, 1790010603, 1790010603);

-- --------------------------------------------------------

--
-- Структура таблицы `black_pass`
--

CREATE TABLE `black_pass` (
  `user_id` int(11) NOT NULL,
  `exp` int(11) DEFAULT 0,
  `level` int(11) DEFAULT 0,
  `premium` int(11) DEFAULT 0,
  `total_points` int(11) DEFAULT 0,
  `rewards_bitmap0` int(11) DEFAULT 0,
  `rewards_bitmap1` int(11) DEFAULT 0,
  `rewards_bitmap2` int(11) DEFAULT 0,
  `rewards_bitmap3` int(11) DEFAULT 0,
  `rewards_bitmap4` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `black_pass`
--

INSERT INTO `black_pass` (`user_id`, `exp`, `level`, `premium`, `total_points`, `rewards_bitmap0`, `rewards_bitmap1`, `rewards_bitmap2`, `rewards_bitmap3`, `rewards_bitmap4`) VALUES
(7, 375, 1, 0, 375, 0, 0, 0, 0, 0),
(8, 25, 1, 1, 25, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `black_pass_top`
--

CREATE TABLE `black_pass_top` (
  `user_id` int(11) NOT NULL,
  `total_points` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `black_pass_top`
--

INSERT INTO `black_pass_top` (`user_id`, `total_points`) VALUES
(1, 0),
(2, 0),
(3, 0),
(4, 0),
(5, 0),
(6, 0),
(7, 375),
(8, 25),
(9, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `bpr_user_rewards`
--

CREATE TABLE `bpr_user_rewards` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `reward_type` int(11) NOT NULL,
  `image_id` int(11) DEFAULT 0,
  `skin_model_id` int(11) DEFAULT -1,
  `name` varchar(64) NOT NULL,
  `rarity` int(11) DEFAULT 1,
  `quantity` int(11) DEFAULT 1,
  `days_left` int(11) DEFAULT 30,
  `spray_price` int(11) DEFAULT 0,
  `plate_text_0` varchar(8) DEFAULT '',
  `plate_text_1` varchar(8) DEFAULT '',
  `plate_text_2` varchar(8) DEFAULT '',
  `plate_text_3` varchar(8) DEFAULT '',
  `plate_count` int(11) DEFAULT 0,
  `received_date` int(11) NOT NULL,
  `expire_date` int(11) NOT NULL,
  `is_taken` tinyint(4) DEFAULT 0,
  `alarm_state` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `bpr_user_rewards`
--

INSERT INTO `bpr_user_rewards` (`id`, `user_id`, `reward_type`, `image_id`, `skin_model_id`, `name`, `rarity`, `quantity`, `days_left`, `spray_price`, `plate_text_0`, `plate_text_1`, `plate_text_2`, `plate_text_3`, `plate_count`, `received_date`, `expire_date`, `is_taken`, `alarm_state`) VALUES
(1, 7, 2, 0, -1, 'Money x1500000', 3, 1500000, 0, 0, '', '', '', '', 0, 1788285505, 1788285505, 0, 1),
(2, 7, 2, 0, -1, 'Money x600000', 2, 600000, 0, 0, '', '', '', '', 0, 1788285505, 1788285505, 0, 1),
(3, 7, 2, 0, -1, 'Money x600000', 2, 600000, 0, 0, '', '', '', '', 0, 1788285505, 1788285505, 0, 1),
(4, 7, 11, 516, -1, 'Item #516', 3, 1, 365, 0, '', '', '', '', 0, 1788285513, 1819821513, 0, 1),
(5, 7, 5, 524, -1, 'Цементовоз', 5, 1, 365, 0, '', '', '', '', 0, 1788285513, 1819821513, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `bp_reward_sync`
--

CREATE TABLE `bp_reward_sync` (
  `user_id` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `premium` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `business`
--

CREATE TABLE `business` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `improvements` int(11) NOT NULL,
  `products` int(11) NOT NULL,
  `prod_price` int(11) NOT NULL,
  `balance` int(11) NOT NULL,
  `rent_time` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `interior` int(11) NOT NULL,
  `enter_price` int(11) NOT NULL,
  `enter_music` int(11) NOT NULL,
  `lock` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `exit_x` float NOT NULL,
  `exit_y` float NOT NULL,
  `exit_z` float NOT NULL,
  `exit_angle` float NOT NULL,
  `eviction` int(11) NOT NULL,
  `ownership_started_at` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `business`
--

INSERT INTO `business` (`id`, `owner_id`, `name`, `improvements`, `products`, `prod_price`, `balance`, `rent_time`, `price`, `rent_price`, `type`, `interior`, `enter_price`, `enter_music`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `eviction`, `ownership_started_at`) VALUES
(1, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747785600, 1000000, 10000, 1, 0, 4444, 0, 0, -578.011, -2852.72, 1.56921, 0, 0, 0, 0, 0, 0),
(2, 0, 'Магазин 24/7', 4, 10000, 0, 43544884, 0, 1000000, 10000, 1, 0, 500, 4, 0, -578.011, -2852.72, 1.56921, 58.504, 397.444, 10.0043, 59.243, 0, 0),
(3, 0, 'Магазин 24/7', 0, 10000, 0, 1700, 0, 1000000, 10000, 1, 0, 4444, 1, 0, -578.011, -2852.72, 1.56921, 110.703, 474.769, 11.3836, 147.446, 0, 0),
(4, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747353600, 1000000, 10000, 1, 0, 5000, 1, 0, -578.011, -2852.72, 1.56921, 398.435, 966.38, 12.0023, 66.9036, 0, 0),
(5, 0, 'Магазин 24/7', 0, 10000, 100, 11560, 1688083200, 1000000, 10000, 1, 0, 100, 4, 0, -578.011, -2852.72, 1.56921, -288.66, 958.372, 12.3608, 0.675795, 0, 0),
(6, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747267200, 1000000, 10000, 1, 0, 1, 0, 0, -578.011, -2852.72, 1.56921, 1869.58, 1382.87, 9.75565, 271.06, 0, 0),
(7, 0, 'Магазин 24/7', 6, 10000, 0, 43544884, 0, 1000000, 10000, 1, 0, 4999, 0, 0, -578.011, -2852.72, 1.56921, -313.346, 448.362, 12.764, 83.3864, 0, 0),
(8, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747267200, 1000000, 10000, 1, 0, 100, 0, 0, -578.011, -2852.72, 1.56921, 102.391, 814.185, 12.0294, 336.361, 0, 0),
(9, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 777, 0, 0, -578.011, -2852.72, 1.56921, 15.0025, 909.071, 12.1446, 223.424, 0, 0),
(10, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747353600, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 299.938, 1781.41, 12.0283, 175.695, 0, 0),
(11, 0, 'Магазин 24/7', 0, 10000, 100, 5, 1688342400, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 2258.81, -2106.68, 21.9609, 92.9546, 0, 0),
(12, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 5000, 2, 0, -578.011, -2852.72, 1.56921, -541.018, 1305.45, 20.7349, 340.589, 0, 0),
(13, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1688169600, 1000000, 10000, 1, 0, 1000, 3, 0, -578.011, -2852.72, 1.56921, -345.697, 958.087, 12.6123, 0.079129, 0, 0),
(14, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 4999, 2, 0, -578.011, -2852.72, 1.56921, 304.155, 1665.28, 11.9978, 307.751, 0, 0),
(15, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 2351.78, -749.508, 14.5062, 185.481, 0, 0),
(16, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747353600, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 202.873, 827.412, 12.9522, 163.695, 0, 0),
(17, 0, 'Магазин 24/7', 6, 10000, 0, 6602485, 0, 1000000, 10000, 1, 0, 500, 1, 0, -578.011, -2852.72, 1.56921, 2554.58, -2204.34, 22.4537, 351.582, 0, 0),
(18, 0, 'Магазин 24/7', 6, 10000, 0, 43544884, 0, 1000000, 10000, 1, 0, 1000, 0, 0, -578.011, -2852.72, 1.56921, -2312.92, -318.553, 30.4343, 85.3074, 0, 0),
(19, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747267200, 1000000, 10000, 1, 0, 888, 0, 0, -578.011, -2852.72, 1.56921, -2242.55, 222.827, 24.5109, 173.613, 1, 0),
(20, 0, 'Магазин 24/7', 0, 10000, 25, 0, 1749859200, 1000000, 10000, 1, 0, 500, 0, 0, -578.011, -2852.72, 1.56921, -362.989, 1024.73, 13.2443, 94.9952, 0, 0),
(21, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 200, 0, 0, -578.011, -2852.72, 1.56921, 397.588, 552.455, 12.3241, 153.093, 0, 0),
(22, 0, 'Управление Статистики', 6, 10000, 0, 10518460, 0, 5000000, 50000, 3, 2, 5000, 5, 0, 0, 0, 99999, 648.913, 652.386, 12.1395, 159.377, 0, 0),
(23, 0, 'Риелторское Агенство', 0, 10000, 0, 0, 0, 5000000, 50000, 4, 3, 5000, 0, 0, 0, 0, 99999, 2453.14, -1903.42, 21.9839, 269.949, 0, 0),
(24, 0, 'Магазин одежды', 0, 10000, 0, 0, 1749513600, 5000000, 50000, 5, 4, 4666, 0, 0, 145.761, 673.122, 12.763, 144.949, 671.425, 12.7593, 159.2, 0, 0),
(25, 0, 'Магазин одежды', 0, 10000, 0, 780000, 0, 5000000, 50000, 5, 4, 777, 4, 0, -578.011, -2852.72, 1.56921, 257.209, 1054.67, 12.1697, 262.488, 0, 0),
(26, 0, 'Магазин одежды', 0, 10000, 0, 2000000, 1688256000, 5000000, 50000, 5, 4, 500, 0, 0, -578.011, -2852.72, 1.56921, 2258.88, -2099.99, 21.9609, 89.9466, 1, 0),
(56, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1749772800, 300000, 0, 1, 0, 99, 1, 0, -578.011, -2852.72, 1.56921, 1946.27, 2065.99, 15.7053, 193.853, 0, 0),
(27, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 5000000, 50000, 5, 4, 3333, 0, 0, -578.011, -2852.72, 1.56921, 134.643, 661.798, 12.7598, 250.025, 0, 0),
(28, 0, 'Магазин одежды', 0, 10000, 0, 43544884, 0, 5000000, 50000, 5, 4, 3000, 5, 0, -578.011, -2852.72, 1.56921, -578.011, -2852.72, 1.56921, 192.329, 0, 0),
(29, 0, 'Магазин одежды', 6, 10000, 0, 43544884, 0, 5000000, 50000, 5, 4, 5000, 3, 0, -578.011, -2852.72, 1.56921, -2550.85, 2934.69, 37.634, 180.27, 0, 0),
(30, 0, 'Магазин одежды', 0, 10000, 0, 6830115, 0, 5000000, 50000, 5, 4, 100, 0, 0, -578.011, -2852.72, 1.56921, 381.981, 931.703, 12.0023, 71.1223, 0, 0),
(31, 0, 'Отель', 0, 10000, 0, 43544884, 0, 5000000, 50000, 6, 5, 5000, 0, 0, 0, 0, 99999, -112.828, 984.11, 12.7591, 178.972, 0, 0),
(32, 0, 'Отель', 0, 10000, 0, 43544884, 0, 5000000, 50000, 6, 5, 5000, 0, 0, 0, 0, 99999, 2412.38, -1844.08, 21.961, 179.265, 0, 0),
(33, 0, 'Отель', 0, 10000, 0, 43544884, 0, 5000000, 50000, 6, 5, 0, 0, 0, 0, 0, 99999, 174.941, 493.417, 13.1466, 60.9921, 0, 0),
(34, 0, 'Автосалон', 0, 10000, 0, 0, 1778198400, 5800000, 58000, 7, 6, 5000, 0, 0, -915.983, 1188.05, 10.7247, -913.122, 1185.87, 10.7247, 227.03, 0, 0),
(35, 0, 'Автосалон', 0, 10000, 0, 124250, 1775088000, 100000000, 101500, 7, 6, 5000, 0, 0, 2477.2, -718.347, 12.674, 2478.47, -723.627, 12.331, 171.863, 0, 0),
(36, 0, 'Автосалон', 0, 10000, 25, 0, 1778198400, 6150000, 61500, 7, 6, 5000, 1, 0, 660.884, 2667.88, 14.5011, 658.857, 2665.41, 14.5011, 148.792, 0, 0),
(37, 0, 'Автосалон', 0, 10000, 0, 0, 1778198400, 8200000, 82000, 7, 6, 2222, 4, 0, 1410.86, 460.272, 13.163, 1409.41, 457.428, 13.163, 146.915, 0, 0),
(125, 0, '', 0, 0, 0, 0, 0, 10000000, 15000, 20, 0, 0, 0, 0, -432.158, 1005.21, 12.15, 0, 0, 0, 0, 0, 0),
(39, 0, 'Сотовый салон', 0, 10000, 0, 0, 1749686400, 4620000, 46200, 9, 8, 4444, 0, 0, -578.011, -2852.72, 1.56921, 378.57, 919.394, 12.0023, 65.5253, 0, 0),
(57, 0, 'Магазин одежды', 0, 10000, 0, 0, 1749772800, 700000, 0, 5, 4, 1, 0, 0, -578.011, -2852.72, 1.56921, 1918.57, 2093.3, 15.7053, 85.5835, 0, 0),
(58, 0, 'Магазин 24/7', 0, 10000, 200, 5600, 1688169600, 1000000, 0, 1, 0, 5000, 2, 0, -578.011, -2852.72, 1.56921, 1842.68, 2191.77, 15.6422, 270.86, 0, 0),
(60, 0, 'Магазин 24/7', 6, 10000, 0, 6635159, 0, 1000000, 0, 1, 0, 444, 0, 0, -578.011, -2852.72, 1.56921, 255.08, 677.186, 12, 148.226, 0, 0),
(67, 0, 'Автосалон', 0, 10000, 0, 0, 1750550400, 200000000, 0, 7, 6, 0, 0, 0, 0, 0, 1000000000, 0, 0, 0, 0, 0, 0),
(62, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1748908800, 5000000, 0, 1, 0, 5000, 0, 0, -502.044, 1272.12, 20.8908, -499.594, 1271.24, 20.7424, 61.7039, 0, 0),
(63, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 3000000, 0, 1, 0, 777, 0, 0, -5.06985, 911.411, 12.002, -6.80267, 907.861, 12.002, 325.228, 0, 0),
(64, 0, 'Магазин одежды', 0, 10000, 0, 43544884, 0, 500000000, 0, 5, 4, 777, 0, 0, -510.637, -1628.02, 40.8817, -505.794, -1628.36, 40.9692, 115.701, 0, 0),
(66, 0, 'Магазин Оружия', 6, 10000, 0, 0, 0, 50000000, 0, 11, 10, 3333, 0, 0, 219.359, 416.856, 11.5371, 223.043, 415.368, 11.2402, 67.0849, 0, 0),
(68, 0, 'СТО', 0, 10000, 0, 0, 1748908800, 1, 0, 10, 9, 0, 0, 0, 0, 0, 99999, 813.191, 863.348, 11.5394, 356.834, 0, 0),
(69, 0, 'Магазин 24/7', 0, 10000, 0, 8000, 1777507200, 1000000, 0, 1, 0, 0, 0, 0, 2275.58, -726.4, 13.574, 0, 0, 0, 0, 0, 0),
(70, 0, 'СТО', 0, 10000, 0, 0, 0, 1, 0, 10, 9, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0, 0),
(71, 0, 'Клуб', 0, 10000, 25, 0, 1751414400, 1, 0, 2, 1, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0, 0),
(81, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 10303, 0, 5, 4, 0, 0, 0, 1052.4, 1898.64, 20.7936, 0, 0, 0, 0, 0, 0),
(75, 0, 'Сотовый салон', 0, 10000, 0, 0, 1747267200, 1600123, 0, 9, 8, 0, 0, 0, -578.011, -2852.72, 1.56921, 0, 0, 0, 0, 0, 0),
(84, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500123, 0, 1, 0, 0, 0, 0, 1600.6, 2884.64, 12.2384, 1600.76, 2887.36, 12.0431, 343.535, 0, 0),
(77, 0, 'Магазин Оружия', 0, 10000, 0, 2220, 1777852800, 10000000, 0, 11, 10, 0, 0, 0, 207.838, 829.689, 13.4207, 208.785, 827.224, 12.4782, 218.102, 0, 0),
(73, 0, 'Управление Статистики', 0, 10000, 0, 0, 1748908800, 1, 0, 3, 2, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0, 0),
(74, 0, 'Магазин Оружия', 0, 10000, 0, 3090, 1777334400, 10000000, 0, 11, 10, 0, 0, 0, 1950.07, 1899.5, 15.558, 1952.68, 1898.75, 15.558, 236.013, 0, 0),
(78, 0, 'Магазин 24/7', 0, 10000, 0, 4470, 1777680000, 500000, 5000, 1, 0, 0, 0, 0, -1752.23, 774.745, 35.815, -1752.23, 774.745, 35.815, 0, 0, 0),
(79, 0, 'Казино', 0, 10000, 0, 60925, 1779235200, 300000000, 0, 8, 7, 0, 0, 0, 1333.49, 2372.6, 17.6642, 1333.63, 2368.66, 17.6642, 180, 0, 0),
(80, 0, 'Казино', 0, 10000, 0, 661000, 1750118400, 12000123, 0, 8, 7, 0, 0, 0, 1281.31, 2402.09, 17.6138, 1278.71, 2402.17, 17.5447, 27.8223, 0, 0),
(82, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, -1210.57, 3130.86, -0.55, 0, 0, 0, 0, 0, 0),
(83, 0, 'Отель', 0, 10000, 0, 0, 1748908800, 1, 0, 6, 5, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0, 0),
(85, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1751414400, 500000, 5000, 1, 0, 0, 0, 0, -2525.15, -695.42, 29.777, -2525.15, -695.42, 29.777, 0, 0, 0),
(86, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1777939200, 500000, 5000, 1, 0, 0, 0, 0, 1019.39, -791.196, 41.09, 1019.39, -791.196, 41.09, 0, 0, 0),
(87, 0, 'Магазин 24/7', 0, 10, 200, 10900, 1778630400, 500000, 5000, 1, 0, 0, 0, 0, 2241.7, -1796.5, 21.7, 2241.7, -1796.5, 21.7, 0, 0, 0),
(88, 0, 'Магазин 24/7', 0, 10000, 200, 300, 1748908800, 1200012, 0, 1, 0, 0, 0, 0, 2765.84, 743.559, 31.229, 2767.28, 744.654, 31.229, 311.437, 0, 0),
(91, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, -1386.77, -1126.98, -0.55, 0, 0, 0, 0, 0, 0),
(92, 0, 'Магазин 24/7', 0, 10000, 0, 6980, 1774656000, 500000, 5000, 1, 0, 0, 0, 0, 2310.72, -1911.69, 21.968, 2310.72, -1911.69, 21.968, 0, 0, 0),
(93, 0, 'Магазин 24/7', 0, 10000, 0, 5450, 1751414400, 1000000, 0, 1, 0, 0, 0, 0, 2260.66, -2102.8, 22.0009, 2258.17, -2102.66, 22.0009, 81.413, 0, 0),
(94, 0, 'Магазин Оружия', 0, 10000, 200, 1890, 1777507200, 1000000, 0, 11, 10, 0, 0, 0, 2349.78, -2138.18, 22.5789, 2349.68, -2141.84, 22.0009, 174.534, 0, 0),
(95, 0, 'Магазин 24/7', 0, 10000, 0, 800, 0, 500000, 5000, 1, 0, 0, 0, 0, 2578.37, -2377.69, 22.947, 2578.37, -2377.69, 22.947, 0, 0, 0),
(96, 0, 'Магазин 24/7', 0, 10000, 200, 0, 1748908800, 500000, 5000, 1, 0, 0, 0, 0, 2450.67, -1903.48, 21.963, 2450.67, -1903.48, 21.963, 0, 0, 0),
(97, 0, 'Магазин 24/7', 0, 0, 0, 1800, 0, 500000, 5000, 1, 0, 0, 0, 0, 1921.68, 2092.98, 16.199, 1921.68, 2092.98, 16.199, 0, 0, 0),
(98, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 1851.05, 2245.89, 15.617, 1851.05, 2245.89, 15.617, 0, 0, 0),
(99, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1751414400, 500000, 5000, 1, 0, 0, 0, 0, 2629.75, 2584.59, 16.595, 2629.75, 2584.59, 16.595, 0, 0, 0),
(100, 0, 'Магазин 24/7', 0, 10000, 0, 25760, 1777248000, 500000, 5000, 1, 0, 0, 0, 0, 405.642, 1960.66, 8.164, 405.642, 1960.66, 8.164, 0, 0, 0),
(101, 0, 'Магазин 24/7', 0, 10000, 199, 8070, 1777420800, 500000, 5000, 1, 0, 0, 0, 0, -360.702, 1024.97, 13.245, -360.702, 1024.97, 13.245, 0, 0, 0),
(102, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 39.05, 513.922, 13.164, 39.05, 513.922, 13.164, 0, 0, 0),
(103, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1777334400, 500000, 5000, 1, 0, 0, 0, 0, 398.195, 554.202, 12.152, 398.195, 554.202, 12.152, 0, 0, 0),
(104, 0, 'Магазин 24/7', 0, 9987, 0, 2000, 1778198400, 1000000, 0, 1, 0, 0, 0, 0, 150.231, 779.273, 12.0217, 152.688, 779.922, 12.0258, 264.461, 0, 0),
(105, 0, 'Магазин 24/7', 0, 0, 0, 0, 1776038400, 500000, 5000, 1, 0, 0, 0, 0, -541.487, 1303.5, 20.891, -541.487, 1303.5, 20.891, 0, 0, 0),
(106, 0, 'Магазин 24/7', 0, 10000, 0, 2290, 0, 500000, 5000, 1, 0, 0, 0, 0, -2310.42, -318.798, 30.651, -2310.42, -318.798, 30.651, 0, 0, 0),
(107, 0, 'Магазин 24/7', 0, 10000, 100, 383200, 1777593600, 500000, 5000, 1, 0, 0, 0, 0, -2379.93, 4.164, 27.03, -2379.93, 4.164, 27.03, 0, 0, 0),
(108, 0, 'Магазин Оружия', 0, 10000, 0, 0, 1775001600, 1000000, 0, 11, 10, 0, 0, 0, -2381.79, -60.8227, 26.7924, -2379.9, -61.1389, 26.5582, 257.095, 0, 0),
(109, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, -506.326, -1551.81, 41.731, -506.326, -1551.81, 41.731, 0, 0, 0),
(110, 0, 'Магазин 24/7', 0, 10000, 0, 400, 1777593600, 1000000, 0, 1, 0, 0, 0, 0, -523.707, -1779.88, 41.0658, -525.949, -1778.58, 40.9619, 52.0631, 0, 0),
(111, 0, 'Магазин 24/7', 0, 10000, 0, 900, 1751328000, 500000, 5000, 1, 0, 0, 0, 0, -2584.95, 1208.45, 9.92, -2584.95, 1208.45, 9.92, 0, 0, 0),
(112, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1751414400, 500000, 5000, 1, 0, 0, 0, 0, -2574.16, 1598.49, 9.92, -2574.16, 1598.49, 9.92, 0, 0, 0),
(113, 0, 'Магазин 24/7', 0, 10000, 0, -4700, 0, 500000, 5000, 1, 0, 0, 0, 0, -2211.93, 1441.11, 9.9, -2211.93, 1441.11, 9.9, 0, 0, 0),
(114, 0, 'Магазин Оружия', 0, 10000, 25, 1603025, 1751328000, 1000000, 0, 11, 10, 0, 0, 0, -2560.4, 1078.58, 10.3936, -2560.88, 1076.06, 9.89156, 182.641, 0, 0),
(115, 0, 'Магазин 24/7', 0, 10000, 100, 0, 1751414400, 500000, 5000, 1, 0, 0, 0, 0, -2154.9, 2052.25, 9.66, -2154.9, 2052.25, 9.66, 0, 0, 0),
(116, 0, 'Магазин Оружия', 0, 10000, 0, 1180, 1777420800, 1000000, 0, 11, 10, 0, 0, 0, -1932.02, 2380.63, 58.6521, -1931.55, 2382.91, 58.157, 357.035, 0, 0),
(117, 0, 'Магазин 24/7', 0, 10000, 0, -8050, 1751328000, 500000, 5000, 1, 0, 0, 0, 0, -2299.55, 2460.78, 58.088, -2299.55, 2460.78, 58.088, 0, 0, 0),
(118, 0, 'Магазин 24/7', 0, 10000, 155, -5000, 1751328000, 500000, 5000, 1, 0, 0, 0, 0, -2352.22, 2596.98, 58.334, -2352.22, 2596.98, 58.334, 0, 0, 0),
(119, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, -2070.65, 2477.42, 57.86, -2070.65, 2477.42, 57.86, 0, 0, 0),
(120, 0, 'Магазин 24/7', 0, 10000, 0, 900, 1751328000, 500000, 5000, 1, 0, 0, 0, 0, -1683.59, 2334.94, 58.363, -1683.59, 2334.94, 58.363, 0, 0, 0),
(121, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1748822400, 500000, 5000, 1, 0, 0, 0, 0, -1848.03, 2787.13, 58.17, -1848.03, 2787.13, 58.17, 0, 0, 0),
(122, 0, 'Магазин 24/7', 0, 10000, 0, 600, 1748908800, 500000, 5000, 1, 0, 0, 0, 0, 550.564, -1221.8, 41.285, 550.564, -1221.8, 41.285, 0, 0, 0),
(123, 0, 'Магазин одежды', 0, 10000, 0, 0, 1748908800, 1, 0, 5, 4, 0, 0, 0, -2769.01, 1429.95, 64.7275, 0, 0, 0, 0, 0, 0),
(124, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 1, 0, 5, 4, 0, 0, 0, -923.065, -453.353, 832.587, 0, 0, 0, 0, 0, 0),
(126, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 6, 0, 5, 4, 0, 0, 0, -904.167, -508.39, 592.766, 0, 0, 0, 0, 0, 0),
(127, 0, 'Магазин одежды', 0, 10000, 0, 0, 1775260800, 6, 0, 5, 4, 0, 0, 0, -1009.74, 240.372, 24.8679, 0, 0, 0, 0, 0, 0),
(129, 0, 'Магазин одежды', 0, 11, 0, 1000000, 1778630400, 15000000, 0, 5, 4, 0, 0, 0, 203.688, 828.653, 13.4207, 202.449, 824.891, 12.4782, 167, 0, 0),
(130, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -18.5988, 464.405, 13.2139, -14.5805, 464.238, 13.2362, 241.177, 0, 0),
(131, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -2329.33, -320.453, 30.6663, -2329.52, -324.324, 30.4343, 181.521, 0, 0),
(132, 0, 'Магазин одежды', 0, 10000, 0, 624250, 0, 15000000, 0, 5, 4, 0, 0, 0, -1767.48, 682.054, 35.4398, -1771.2, 682.973, 35.4398, 79.0027, 0, 0),
(133, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -2427.04, 1128.51, 10.8551, -2425.6, 1118.84, 9.89156, 169.182, 0, 0),
(134, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -1799.19, 2667.18, 60.5335, -1794.13, 2660.46, 57.9603, 214.892, 0, 0),
(135, 0, 'Магазин Оружия', 0, 10000, 0, 600, 1777420800, 8750000, 0, 11, 10, 0, 0, 0, -1788, 671.136, 35.4398, -1786.63, 673.822, 35.4398, 335.105, 0, 0),
(136, 0, 'Ларёк #111', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 2744.2, -2429.01, 21.899, 2744.2, -2429.01, 21.899, 0, 0, 0),
(137, 0, 'Ларёк #112', 0, 10000, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 1889.19, -2243.52, 11.075, 1889.19, -2243.52, 11.075, 0, 0, 0),
(138, 0, 'Ларёк #113', 0, 10000, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 1912.64, -2266.77, 11.091, 1912.64, -2266.77, 11.091, 0, 0, 0),
(139, 0, 'Ларёк #114', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 847.375, 802.654, 13.379, 847.375, 802.654, 13.379, 0, 0, 0),
(140, 0, 'Ларёк #115', 0, 0, 0, 0, 1789776000, 500000, 5000, 12, 0, 0, 0, 0, 1801.86, 2531.64, 14.658, 1801.86, 2531.64, 14.658, 0, 0, 0),
(141, 0, 'Ларёк #116', 0, 10000, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -1760.46, 790.768, 35.745, -1760.46, 790.768, 35.745, 0, 0, 0),
(142, 0, 'Ларёк #117', 0, 10000, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -2402.3, 194.55, 26.033, -2402.3, 194.55, 26.033, 0, 0, 0),
(143, 0, 'Ларёк #118', 0, 10000, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -111.83, 905.018, 12.214, -111.83, 905.018, 12.214, 0, 0, 0),
(144, 0, 'Ларёк #119', 0, 10000, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -113.201, 942.369, 12.214, -113.201, 942.369, 12.214, 0, 0, 0),
(145, 0, 'Ларёк #120', 0, 10000, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -256.276, 573.732, 12.195, -256.276, 573.732, 12.195, 0, 0, 0),
(146, 0, '', 0, 10000, 0, 1410, 0, 500000, 2500, 13, 11, 0, 0, 0, -1777.69, 817.12, 35.5, 0, 0, 0, 0, 0, 0),
(147, 0, 'Ларёк #122', 0, 0, 0, 15929989, 0, 7000000, 0, 12, 11, 0, 0, 0, 1945.67, 2068.86, 16.1921, 1945.38, 2066.08, 15.7377, 177.967, 0, 0),
(148, 0, 'Магазин аксесуаров', 0, 9993, 0, 6360000, 1778198400, 7000000, 0, 12, 11, 0, 0, 0, 216.569, 860.619, 13.4207, 1945.38, 2066.08, 15.7377, 177.967, 0, 0),
(0, 0, 'Ларёк #124', 0, 0, 0, 0, 0, 500000, 0, 13, 12, 0, 0, 0, 1905.8, 2104.11, 15.7422, 0, 0, 0, 0, 0, 0),
(149, 0, 'Стайлинг центр', 0, 0, 0, 0, 1790035200, 25000000, 25000, 14, 9, 0, 0, 0, 2312.13, -2601.55, 21.829, 2312.13, -2601.55, 21.829, 266.764, 0, 0),
(150, 0, 'Шиномонтажный центр', 0, 0, 0, 0, 0, 25000000, 25000, 16, 9, 0, 0, 0, 1731.65, 2447.96, 14.979, 1731.65, 2447.96, 14.979, 117.855, 0, 0),
(151, 0, 'Технический центр', 0, 0, 0, 0, 0, 25000000, 25000, 15, 9, 0, 0, 0, -431.906, 1005.23, 12.19, -431.906, 1005.23, 12.19, 170.944, 0, 0),
(152, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 13.039, 911.113, 12.307, 13.039, 911.113, 12.307, 0, 0, 0),
(153, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 150.424, 776.249, 12.154, 150.424, 776.249, 12.154, 0, 0, 0),
(154, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 2764.55, 745.323, 31.189, 2764.55, 745.323, 31.189, 0, 0, 0),
(155, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 2260.8, -2106.81, 21.98, 2260.8, -2106.81, 21.98, 0, 0, 0),
(156, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 2252.27, -887.57, 26.54, 2252.27, -887.57, 26.54, 0, 0, 0),
(157, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, 1598.27, 2884.64, 12.198, 1598.27, 2884.64, 12.198, 0, 0, 0),
(158, 0, 'Магазин 24/7', 0, 0, 0, 0, 0, 500000, 5000, 1, 0, 0, 0, 0, -2120.2, 2658.17, 58.178, -2120.2, 2658.17, 58.178, 0, 0, 0),
(159, 0, 'Ларёк #135', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 57.916, 942.644, 12.213, 57.916, 942.644, 12.213, 0, 0, 0),
(160, 0, 'Ларёк #136', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 154.984, 586.486, 12.214, 154.984, 586.486, 12.214, 0, 0, 0),
(161, 0, 'Ларёк #137', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 2283.69, -2171.79, 22.038, 2283.69, -2171.79, 22.038, 0, 0, 0),
(162, 0, 'Ларёк #138', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, 2251.62, -2110.84, 22.038, 2251.62, -2110.84, 22.038, 0, 0, 0),
(163, 0, 'Ларёк #139', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -2322.84, -150.564, 26.527, -2322.84, -150.564, 26.527, 0, 0, 0),
(164, 0, 'Ларёк #140', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -2638.4, 2002.19, 9.649, -2638.4, 2002.19, 9.649, 0, 0, 0),
(165, 0, 'Ларёк #141', 0, 0, 0, 0, 0, 500000, 5000, 12, 0, 0, 0, 0, -2146.13, 1598.92, 9.88, -2146.13, 1598.92, 9.88, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `business_gps`
--

CREATE TABLE `business_gps` (
  `id` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `pos` int(11) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `business_profit`
--

CREATE TABLE `business_profit` (
  `id` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `uip` varchar(16) NOT NULL,
  `time` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `view` int(11) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `calendar_event_state`
--

CREATE TABLE `calendar_event_state` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `total_days` smallint(5) UNSIGNED NOT NULL DEFAULT 42,
  `start_time` int(10) UNSIGNED NOT NULL,
  `end_time` int(10) UNSIGNED NOT NULL,
  `days_left` smallint(5) UNSIGNED NOT NULL DEFAULT 42,
  `last_update_date` date NOT NULL,
  `season_version` smallint(5) UNSIGNED NOT NULL DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `calendar_event_state`
--

INSERT INTO `calendar_event_state` (`id`, `total_days`, `start_time`, `end_time`, `days_left`, `last_update_date`, `season_version`) VALUES
(1, 42, 1788220800, 1791849600, 23, '2026-09-20', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `calendar_user_bonus`
--

CREATE TABLE `calendar_user_bonus` (
  `account_id` int(10) UNSIGNED NOT NULL,
  `season_version` smallint(5) UNSIGNED NOT NULL,
  `bonus_id` tinyint(3) UNSIGNED NOT NULL,
  `claimed` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `calendar_user_progress`
--

CREATE TABLE `calendar_user_progress` (
  `account_id` int(10) UNSIGNED NOT NULL,
  `season_version` smallint(5) UNSIGNED NOT NULL,
  `day_number` tinyint(3) UNSIGNED NOT NULL,
  `play_seconds` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `claimed` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `calendar_user_progress`
--

INSERT INTO `calendar_user_progress` (`account_id`, `season_version`, `day_number`, `play_seconds`, `claimed`, `updated_at`) VALUES
(7, 2, 1, 299, 0, 1788366038);

-- --------------------------------------------------------

--
-- Структура таблицы `calendar_user_state`
--

CREATE TABLE `calendar_user_state` (
  `account_id` int(10) UNSIGNED NOT NULL,
  `season_version` smallint(5) UNSIGNED NOT NULL,
  `claimed_count` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `last_claim_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `calendar_user_state`
--

INSERT INTO `calendar_user_state` (`account_id`, `season_version`, `claimed_count`, `last_claim_at`, `updated_at`) VALUES
(7, 2, 0, 0, 1788285572);

-- --------------------------------------------------------

--
-- Структура таблицы `car_obmen`
--

CREATE TABLE `car_obmen` (
  `id` int(11) NOT NULL,
  `car_1` int(11) NOT NULL DEFAULT 5,
  `car_2` int(11) NOT NULL DEFAULT 5,
  `car_3` int(11) NOT NULL DEFAULT 5,
  `car_4` int(11) NOT NULL DEFAULT 5,
  `car_5` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `change_names`
--

CREATE TABLE `change_names` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `name` varchar(21) NOT NULL,
  `time` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL DEFAULT '255.255.255.255'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `change_names`
--

INSERT INTO `change_names` (`id`, `owner_id`, `name`, `time`, `ip`) VALUES
(1, 8, 'Manta_Dev', 1788897942, '146.70.230.147');

-- --------------------------------------------------------

--
-- Структура таблицы `charity`
--

CREATE TABLE `charity` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `debug`
--

CREATE TABLE `debug` (
  `id` int(11) NOT NULL,
  `text` varchar(256) NOT NULL,
  `date` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `donate_log`
--

CREATE TABLE `donate_log` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `uip` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '255.255.255.255',
  `time` int(11) NOT NULL,
  `donate` int(11) NOT NULL,
  `description` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Дамп данных таблицы `donate_log`
--

INSERT INTO `donate_log` (`id`, `uid`, `uip`, `time`, `donate`, `description`) VALUES
(1, 7, '178.216.209.173', 1788244729, 1000000, 'Бонус за регистрацию'),
(2, 7, '178.216.209.173', 1788285497, -8550, 'Cases: open'),
(3, 7, '178.216.209.173', 1788285506, -8550, 'Cases: open'),
(4, 7, '178.216.209.173', 1788285660, 0, 'акция'),
(5, 7, '178.216.209.173', 1788365945, -3000, 'None'),
(6, 7, '178.216.209.173', 1788365961, -800, 'None'),
(7, 7, '178.216.209.173', 1788365984, -11100, 'Покупка уровней BP'),
(8, 7, '178.216.209.173', 1788365990, -1500, 'Покупка уровней BP'),
(9, 7, '178.216.209.173', 1788365993, -5250, 'Покупка уровней BP'),
(10, 7, '178.216.209.173', 1788365997, -150, 'Покупка уровней BP'),
(11, 8, '92.36.120.113', 1788852094, 500, 'Бонус за регистрацию'),
(12, 8, '92.36.120.113', 1788852130, -70, 'Покупка 4-значной SIM-карты'),
(13, 8, '92.36.120.113', 1788852136, -70, 'Покупка 4-значной SIM-карты'),
(14, 8, '92.36.120.113', 1788852146, -70, 'Покупка 4-значной SIM-карты'),
(15, 8, '92.36.120.113', 1788852152, -70, 'Покупка 4-значной SIM-карты'),
(16, 8, '92.36.120.113', 1788852157, -70, 'Покупка 4-значной SIM-карты'),
(17, 8, '92.36.120.113', 1788852163, -70, 'Покупка 4-значной SIM-карты'),
(18, 8, '92.36.120.113', 1788852172, -70, 'Покупка 4-значной SIM-карты'),
(19, 8, '92.36.120.113', 1788853085, 10000, 'Выдача доната от админа Manta_Dev'),
(20, 8, '92.36.120.113', 1788853086, 10000, 'Выдача доната от админа Manta_Dev'),
(21, 8, '92.36.120.113', 1788853088, 10000, 'Выдача доната от админа Manta_Dev'),
(22, 8, '92.36.120.113', 1788853089, 10000, 'Выдача доната от админа Manta_Dev'),
(23, 8, '92.36.120.113', 1788853145, -3950, 'None'),
(24, 8, '92.36.120.113', 1788853291, -172, 'Покупка стробоскопов'),
(25, 8, '146.70.230.147', 1788897942, -50, 'Смена имени'),
(26, 8, '146.70.230.147', 1788897954, -100, 'Снятие варнов'),
(27, 8, '146.70.230.147', 1788897960, -150, 'Все лицензии'),
(28, 8, '146.70.230.147', 1788897985, -130, 'Военный билет донат'),
(29, 8, '146.70.230.147', 1788898040, -599, 'Покупка Black Pass Premium'),
(30, 8, '146.70.230.147', 1788898048, -1699, 'Покупка Black Pass Premium'),
(31, 8, '146.70.230.147', 1788898061, -11100, 'Покупка уровней BP'),
(32, 8, '146.70.230.147', 1788898067, -750, 'Покупка уровней BP'),
(33, 8, '146.70.230.147', 1788901623, -5000, 'None'),
(34, 8, '103.216.221.105', 1789732860, 0, 'акция'),
(35, 8, '103.216.221.105', 1789732860, 2, 'None'),
(36, 9, '37.114.130.149', 1789733933, 500, 'Бонус за регистрацию'),
(37, 10, '149.40.62.2', 1790006344, 500, 'Бонус за регистрацию'),
(38, 12, '138.199.35.123', 1790009843, 0, 'Бонус за регистрацию'),
(39, 13, '77.79.149.199', 1790010603, 0, 'Бонус за регистрацию'),
(40, 13, '77.79.149.199', 1790010948, 10000, 'Выдача доната от админа Foksi_Techo'),
(41, 13, '77.79.149.199', 1790010949, 10000, 'Выдача доната от админа Foksi_Techo'),
(42, 13, '77.79.149.199', 1790010949, 10000, 'Выдача доната от админа Foksi_Techo'),
(43, 13, '77.79.149.199', 1790010950, 10000, 'Выдача доната от админа Foksi_Techo'),
(44, 13, '77.79.149.199', 1790010950, 10000, 'Выдача доната от админа Foksi_Techo'),
(45, 13, '77.79.149.199', 1790010967, -6000, 'None'),
(46, 13, '77.79.149.199', 1790010990, -600, 'None'),
(47, 13, '77.79.149.199', 1790011584, -182, 'Покупка стробоскопов');

-- --------------------------------------------------------

--
-- Структура таблицы `family`
--

CREATE TABLE `family` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `color` int(11) NOT NULL DEFAULT 0,
  `reputation` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT -1,
  `slot_veh` int(11) NOT NULL DEFAULT 5,
  `money` int(11) NOT NULL DEFAULT 0,
  `armour` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `heath_kit` int(11) NOT NULL DEFAULT 0,
  `patron` int(11) NOT NULL DEFAULT 0,
  `level_storage` int(11) NOT NULL DEFAULT 1,
  `level_weapon` int(11) NOT NULL DEFAULT 1,
  `level_compound` int(11) NOT NULL DEFAULT 1,
  `rang_1` varchar(38) NOT NULL DEFAULT '1 Ранг,1,0,0,0,1',
  `rang_2` varchar(38) NOT NULL DEFAULT '2 Ранг,1,0,0,0,1',
  `rang_3` varchar(38) NOT NULL DEFAULT '3 Ранг,1,0,0,0,1',
  `rang_4` varchar(38) NOT NULL DEFAULT '4 Ранг,1,0,0,0,1',
  `rang_5` varchar(38) NOT NULL DEFAULT '5 Ранг,1,1,1,1,1',
  `house` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `family`
--

INSERT INTO `family` (`id`, `name`, `color`, `reputation`, `owner`, `slot_veh`, `money`, `armour`, `material`, `heath_kit`, `patron`, `level_storage`, `level_weapon`, `level_compound`, `rang_1`, `rang_2`, `rang_3`, `rang_4`, `rang_5`, `house`) VALUES
(1, 'Администрация Се', 0, 0, 8, 5, 0, 0, 0, 0, 0, 1, 1, 1, '1 Ранг,1,0,0,0,1', '2 Ранг,1,0,0,0,1', '3 Ранг,1,0,0,0,1', '4 Ранг,1,0,0,0,1', '5 Ранг,1,1,1,1,1', -1);

-- --------------------------------------------------------

--
-- Структура таблицы `familyblack`
--

CREATE TABLE `familyblack` (
  `family_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `reason` varchar(64) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `familysystem`
--

CREATE TABLE `familysystem` (
  `id` int(11) NOT NULL,
  `family_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `ownable_car_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `access_rank` int(11) NOT NULL DEFAULT 1,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `family_ad`
--

CREATE TABLE `family_ad` (
  `id` int(11) NOT NULL,
  `family` int(11) NOT NULL,
  `ad_text` varchar(62) NOT NULL,
  `create_id` int(11) NOT NULL,
  `create_name` varchar(24) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `family_cars`
--

CREATE TABLE `family_cars` (
  `id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `color_1` int(11) NOT NULL,
  `color_2` int(11) NOT NULL,
  `number` varchar(32) NOT NULL DEFAULT 'none',
  `plate_type` int(11) NOT NULL DEFAULT 1,
  `plate_number` varchar(16) NOT NULL DEFAULT '',
  `plate_region` varchar(8) NOT NULL DEFAULT '',
  `vynil_name` varchar(32) NOT NULL DEFAULT '',
  `f_state` int(11) NOT NULL DEFAULT 0,
  `nitro_level` int(11) NOT NULL DEFAULT 0,
  `launch` int(11) NOT NULL DEFAULT 0,
  `pdvradar` int(11) NOT NULL DEFAULT 0,
  `lights_color` int(11) NOT NULL DEFAULT 0,
  `underlights_color` int(11) NOT NULL DEFAULT 0,
  `underlights_color_lf` int(11) NOT NULL DEFAULT 0,
  `underlights_color_rt` int(11) NOT NULL DEFAULT 0,
  `is_FarLight_active` int(11) NOT NULL DEFAULT 0,
  `pnevmo_selected` int(11) NOT NULL DEFAULT 0,
  `percentofclirness` int(11) NOT NULL DEFAULT 0,
  `percentofclirnessZ` int(11) NOT NULL DEFAULT 0,
  `is_hydro_active` int(11) NOT NULL DEFAULT 0,
  `region` varchar(32) NOT NULL DEFAULT '--',
  `number_type` int(11) NOT NULL DEFAULT 0,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `angle` float NOT NULL,
  `pos_last_x` float DEFAULT NULL,
  `pos_last_y` float DEFAULT NULL,
  `pos_last_z` float DEFAULT NULL,
  `angle_last` float DEFAULT NULL,
  `rang` int(11) NOT NULL DEFAULT 1,
  `family_owner` int(11) NOT NULL DEFAULT -1,
  `create_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `family_log`
--

CREATE TABLE `family_log` (
  `id` int(11) NOT NULL,
  `family` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `to_player` int(11) NOT NULL,
  `text` varchar(124) NOT NULL,
  `time` int(11) NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `fuel_stations`
--

CREATE TABLE `fuel_stations` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL DEFAULT 'None',
  `improvements` int(11) NOT NULL,
  `fuels` int(11) NOT NULL,
  `fuel_price` int(11) NOT NULL,
  `buy_fuel_price` int(11) NOT NULL,
  `balance` int(11) NOT NULL,
  `rent_time` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `lock` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `eviction` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `fuel_stations`
--

INSERT INTO `fuel_stations` (`id`, `owner_id`, `name`, `improvements`, `fuels`, `fuel_price`, `buy_fuel_price`, `balance`, `rent_time`, `price`, `rent_price`, `lock`, `x`, `y`, `z`, `eviction`) VALUES
(19, 0, 'Заправочная станция', 0, 1000, 3, 0, 150, 1776902400, 12000123, 5001, 0, 1016.17, -779.029, 41.165, 0),
(18, 0, 'Заправочная станция', 4, 1000, 5, 0, 476945, 1750204800, 12000123, 10004, 0, -2539.23, -695.798, 29.6205, 0),
(20, 0, 'Заправочная станция', 4, 1000, 15, 0, 1705033479, 1750032000, 12000123, 5000, 0, 2776.67, 751.794, 31.0258, 0),
(17, 0, 'Заправочная станция', 0, 191, 15, 0, 1135, 1779235200, 1000000, 5000, 0, 2276.39, -739.561, 13.4187, 0),
(15, 0, 'Заправочная станция', 0, 1000, 3, 0, 0, 1775692800, 20012300, 400123, 0, 1600.41, 2898.01, 12.0431, 0),
(14, 0, 'Заправочная станция', 0, 1000, 3, 0, 150, 1777680000, 1000000, 10000, 0, -537.518, 1315.61, 20.7424, 0),
(7, 0, 'Заправочная станция', 4, 5000, 3, 0, 4673725, 0, 90000000, 9000, 0, -890.503, 1486.84, 27.4242, 0),
(8, 0, 'Заправочная станция', 0, 5000, 3, 0, 0, 1720310400, 90000000, 9000, 0, 2368.07, -766.732, 14.0431, 0),
(9, 0, 'Заправочная станция', 0, 1000, 3, 0, 1260, 0, 100000000, 10000, 0, 2245.21, -1784.98, 21.7109, 0),
(10, 0, 'Заправочная станция', 4, 1000, 3, 0, 45, 1750204800, 90000000, 9000, 0, 2674.46, 2616.66, 16.9724, 0),
(11, 0, 'Заправочная станция', 4, 1000, 3, 0, 350480, 1750118400, 90000000, 9000, 0, 2877.87, 541.919, 26.3542, 0),
(21, 0, 'Заправочная станция', 0, 1000, 3, 0, 150, 1775433600, 1000000, 5000, 0, 2641.88, 2587, 16.432, 0),
(22, 0, 'Заправочная станция', 4, 1000, 3, 0, 0, 0, 1000000, 5000, 0, -2069.7, 2464.53, 57.665, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `fuel_stations_profit`
--

CREATE TABLE `fuel_stations_profit` (
  `id` int(11) NOT NULL,
  `fid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `uip` varchar(16) NOT NULL,
  `time` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `view` int(11) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `full_dostup`
--

CREATE TABLE `full_dostup` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `gang_repositories`
--

CREATE TABLE `gang_repositories` (
  `id` int(11) NOT NULL,
  `metall` int(11) NOT NULL,
  `ammo` int(11) NOT NULL,
  `drugs` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `lock` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `gang_repositories`
--

INSERT INTO `gang_repositories` (`id`, `metall`, `ammo`, `drugs`, `money`, `lock`) VALUES
(1, 2000, 10000, 500, 20000, 1),
(2, 2000, 10000, 500, 20000, 1),
(3, 2000, 10000, 500, 20000, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gang_zones`
--

CREATE TABLE `gang_zones` (
  `id` int(11) NOT NULL,
  `min_x` float NOT NULL,
  `min_y` float NOT NULL,
  `max_x` float NOT NULL,
  `max_y` float NOT NULL,
  `fraction` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `garages`
--

CREATE TABLE `garages` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `owner_id` int(11) NOT NULL DEFAULT 0,
  `owner_name` varchar(24) NOT NULL DEFAULT 'None',
  `class` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 100000,
  `locked` int(11) NOT NULL DEFAULT 1,
  `max_cars` int(11) NOT NULL DEFAULT 1,
  `wardrobe` int(11) NOT NULL DEFAULT 0,
  `ventilation` int(11) NOT NULL DEFAULT 0,
  `spawn_x` float NOT NULL DEFAULT 0,
  `spawn_y` float NOT NULL DEFAULT 0,
  `spawn_z` float NOT NULL DEFAULT 0,
  `spawn_angle` float NOT NULL DEFAULT 0,
  `safe_exit_x` float NOT NULL DEFAULT 0,
  `safe_exit_y` float NOT NULL DEFAULT 0,
  `safe_exit_z` float NOT NULL DEFAULT 0,
  `safe_exit_angle` float NOT NULL DEFAULT 0,
  `vehicle_exit_x` float NOT NULL DEFAULT 0,
  `vehicle_exit_y` float NOT NULL DEFAULT 0,
  `vehicle_exit_z` float NOT NULL DEFAULT 0,
  `vehicle_exit_angle` float NOT NULL DEFAULT 0,
  `improvements` int(11) NOT NULL DEFAULT 1,
  `rent_time` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `garages`
--

INSERT INTO `garages` (`id`, `x`, `y`, `z`, `owner_id`, `owner_name`, `class`, `price`, `locked`, `max_cars`, `wardrobe`, `ventilation`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_angle`, `safe_exit_x`, `safe_exit_y`, `safe_exit_z`, `safe_exit_angle`, `vehicle_exit_x`, `vehicle_exit_y`, `vehicle_exit_z`, `vehicle_exit_angle`, `improvements`, `rent_time`) VALUES
(7, -721.065, -1559.75, 41.3725, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(8, -718.981, -1556.26, 41.3739, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(9, -716.678, -1552.28, 41.3717, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(10, -714.716, -1548.81, 41.3654, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(11, -712.399, -1545.24, 41.3735, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(12, -710.384, -1541.52, 41.3623, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(13, -708.288, -1537.75, 41.3538, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(14, -705.931, -1534.42, 41.3718, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(15, -703.94, -1530.76, 41.3625, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(16, -715.998, -1523.44, 41.3639, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(17, -718.336, -1527.41, 41.3624, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(18, -720.228, -1530.76, 41.3574, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(19, -722.627, -1534.48, 41.3645, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(20, -724.766, -1538.06, 41.3636, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(21, -726.88, -1541.95, 41.3531, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(22, -728.885, -1545.19, 41.3558, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(23, -731.195, -1548.83, 41.3632, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(24, -733.44, -1552.59, 41.3643, 0, 'None', 0, 500000, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gates`
--

CREATE TABLE `gates` (
  `id` int(11) NOT NULL,
  `gate_type` int(11) NOT NULL,
  `gate1_x` float NOT NULL,
  `gate1_y` float NOT NULL,
  `gate1_z` float NOT NULL,
  `gate1_angle` float NOT NULL,
  `gate2_x` float NOT NULL,
  `gate2_y` float NOT NULL,
  `gate2_z` float NOT NULL,
  `gate2_angle` float NOT NULL,
  `gatezone_x` float NOT NULL,
  `gatezone_y` float NOT NULL,
  `gatezone_z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `gates`
--

INSERT INTO `gates` (`id`, `gate_type`, `gate1_x`, `gate1_y`, `gate1_z`, `gate1_angle`, `gate2_x`, `gate2_y`, `gate2_z`, `gate2_angle`, `gatezone_x`, `gatezone_y`, `gatezone_z`) VALUES
(1, 0, -972.25, 266.04, 26.16, -35, -977.99, 269.97, 26.16, 147, -975.11, 268.111, 25.565),
(2, 0, -981.31, 207.61, 25.42, 56, -985.21, 201.9, 25.42, -126, -983.657, 204.918, 24.823),
(3, 1, -1087.87, 268.21, 25.56, 143.2, 0, 0, 0, 0, -1085.88, 267.159, 24.968),
(4, 0, -1014.42, 199.56, 26.37, 147, -1008.59, 195.75, 26.37, -33, -1011.15, 197.888, 25.771),
(5, 0, -1050.7, 296.34, 25.72, -34, -1056.42, 300.26, 25.72, 146, -1053.92, 297.881, 25.114),
(6, 0, -1138.42, 451.45, 21.36, 145, -1132.72, 447.48, 21.36, -35, -1135.27, 449.727, 20.76),
(7, 1, -1205.47, 547.98, 18.81, 118, 0, 0, 0, 0, -1204.08, 546.165, 18.21),
(8, 0, -1262.13, 650.35, 17.54, 119, -1258.73, 644.24, 17.54, -61, -1260.03, 647.347, 16.922),
(9, 0, -1297.32, 708.67, 17.41, 121, -1293.63, 702.65, 17.41, -58, -1295.06, 705.67, 16.803),
(10, 0, -1258.29, 275.92, 33.81, 176, -1251.21, 275.41, 33.81, -4, -1254.86, 275.269, 33.213),
(11, 0, -1308.53, 310.21, 33.58, 145, -1302.85, 306.26, 33.58, -34, -1306.02, 307.95, 32.985),
(12, 0, -1356.85, 374, 33.5, 124, -1352.94, 368.2, 33.5, -56, -1354.43, 371.076, 32.878),
(13, 0, -1306.15, 386.45, 33.16, -54, -1310.26, 392.01, 33.16, 127, -1308.61, 389.162, 32.56),
(14, 0, -1389.25, 423.23, 32.55, 121, -1385.7, 417.31, 32.55, -59, -1387.17, 420.498, 31.939),
(15, 0, -1328.1, 419.58, 32.08, -59, -1331.62, 425.54, 32.08, 120, -1330.22, 422.353, 31.478),
(16, 0, -1416.2, 468.69, 31.79, 121, -1412.66, 462.75, 31.79, -60, -1414.11, 466.003, 31.182),
(17, 0, -1369.23, 488.98, 31.91, -59, -1372.83, 494.9, 31.91, 121, -1371.35, 491.737, 31.314),
(18, 1, -1458.09, 542.42, 31.78, 121, 0, 0, 0, 0, -1456.66, 540.785, 31.182),
(19, 0, -1411.62, 559.31, 31.87, -59, -1415.23, 565.22, 31.87, 121, -1413.76, 562.036, 31.267),
(20, 0, -1518.83, 643.05, 32.17, 121, -1515.22, 637.15, 32.17, -59, -1516.69, 640.314, 31.569),
(21, 0, -1467.64, 652.09, 31.58, -59, -1471.18, 658.03, 31.58, 120, -1469.79, 654.851, 30.964),
(22, 0, -1563.82, 698.53, 32.17, 126, -1560, 693.19, 31.57, -55, -1561.48, 695.937, 31.574),
(23, 0, -1616.48, 722.02, 33.45, 65, -1619.4, 715.82, 33.45, -115, -1617.59, 718.762, 32.852),
(24, 0, -1943.93, 650.19, 29.71, -77, -1945.47, 656.91, 29.71, 103, -1945.08, 653.502, 29.099),
(25, 0, -1978.35, 630.05, 29.51, 104, -1976.71, 623.32, 29.51, -77, -1977.14, 626.771, 28.895),
(26, 1, -1920.43, 564.34, 30.43, -72, 0, 0, 0, 0, -1921.45, 566.277, 29.834),
(27, 0, -1960.2, 519.3, 29.51, 13, -1966.93, 517.66, 29.51, -166, -1963.49, 518.152, 28.915),
(28, 0, -1879.32, 463.31, 29.14, -64, -1882.41, 469.5, 29.14, 117, -1881.16, 466.212, 28.532),
(29, 0, -1983.9, 458.28, 30.4, -153, -1977.8, 461.39, 30.4, 27, -1981.02, 460.184, 29.796),
(30, 0, -1859.15, 420.81, 29.32, -66, -1862.11, 427.05, 29.32, 116, -1860.95, 423.834, 28.703),
(31, 0, -1886.51, 383.35, 28.61, 116, -1883.47, 377.19, 28.61, -63, -1884.64, 380.324, 28.015);

-- --------------------------------------------------------

--
-- Структура таблицы `gift`
--

CREATE TABLE `gift` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `gift_lose`
--

CREATE TABLE `gift_lose` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `gift_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `hotels`
--

CREATE TABLE `hotels` (
  `id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `rent_time` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `improvements` int(11) NOT NULL,
  `rent_time` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `entrance` int(11) NOT NULL DEFAULT -1,
  `lock` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `exit_x` float NOT NULL,
  `exit_y` float NOT NULL,
  `exit_z` float NOT NULL,
  `exit_angle` float NOT NULL,
  `car_x` float NOT NULL,
  `car_y` float NOT NULL,
  `car_z` float NOT NULL,
  `car_angle` float NOT NULL,
  `store_x` float NOT NULL,
  `store_y` float NOT NULL,
  `store_z` float NOT NULL,
  `eviction` int(11) NOT NULL,
  `store_metall` int(11) NOT NULL,
  `store_drugs` int(11) NOT NULL,
  `store_weapon` int(11) NOT NULL,
  `store_ammo` int(11) NOT NULL,
  `store_skin` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `houses`
--

INSERT INTO `houses` (`id`, `owner_id`, `name`, `improvements`, `rent_time`, `price`, `rent_price`, `type`, `entrance`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `car_x`, `car_y`, `car_z`, `car_angle`, `store_x`, `store_y`, `store_z`, `eviction`, `store_metall`, `store_drugs`, `store_weapon`, `store_ammo`, `store_skin`) VALUES
(878, 0, '', 0, 1777334400, 300000, 0, 0, -1, 1, 2608.47, -200.896, 6.83413, 2606, -200.925, 6.37748, 95.5877, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(877, 0, '', 0, 1776988800, 300000, 0, 0, -1, 0, 2627.61, -232.807, 3.97524, 2627.82, -230.62, 3.97524, 356.252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(876, 0, '', 0, 0, 300000, 0, 0, -1, 0, 2685.55, -231.569, 3.97524, 2685.22, -229.583, 3.97524, 2.10319, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(875, 0, '', 6, 1778630400, 300000, 0, 0, -1, 0, 1732.28, 2197.25, 17.1082, 1732.24, 2200.14, 16.216, 349.859, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(874, 0, '', 0, 1776902400, 300000, 0, 0, -1, 0, 1743.39, 2180.51, 16.2155, 1744.73, 2182.13, 16.2155, 244.985, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(873, 0, '', 0, 1778716800, 300000, 0, 0, -1, 0, 1741.57, 2116.99, 16.1999, 1743.86, 2117.3, 16.1999, 259.611, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(872, 0, '', 0, 0, 300000, 0, 0, -1, 0, 1945.31, 1845.38, 15.4198, 1947.42, 1845.82, 15.4198, 285.242, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(870, 0, '', 6, 0, 300000, 0, 0, -1, 0, 1989.2, 1794, 15.4441, 1987.7, 1794.56, 15.4413, 86.7417, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(869, 0, '', 6, 0, 300000, 0, 0, -1, 0, 1994.83, 1746.33, 15.6989, 1993.11, 1746.58, 15.6989, 87.4468, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(868, 0, '', 0, 1778284800, 300000, 0, 0, -1, 1, 1943.69, 1752.91, 15.3423, 1945.62, 1752.87, 15.3423, 296.995, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(653, 0, '', 0, 0, 10000000, 0, 6, -1, 0, -2693.09, -1164.74, 10.5219, -455.53, 1477.33, 20.8907, 260.765, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(655, 0, '', 0, 0, 10000000, 0, 6, -1, 0, -2776.1, -1088.3, 9.02227, -2770.47, -1088.81, 8.52227, 265.563, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(654, 0, '', 6, 0, 10000000, 0, 6, -1, 0, -2761.8, -1149.09, 8.62222, -2758.14, -1149.43, 8.52378, 275.727, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(657, 0, '', 0, 1777507200, 10000000, 0, 6, -1, 0, -2693.13, -1054.76, 10.522, -2698.62, -1054.46, 10.022, 91.1811, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234),
(656, 0, '', 0, 1748908800, 10000000, 0, 6, -1, 0, -2707.07, -1103.97, 10.1225, -2711.14, -1103.53, 10.0241, 87.3761, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(658, 0, '', 0, 1750464000, 10000000, 0, 6, -1, 0, -2761.78, -1039.05, 8.62239, -2757.91, -1039.35, 8.52395, 263.83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(660, 0, '', 0, 1748908800, 10000000, 0, 6, -1, 0, -2776.1, -878.337, 9.02181, -2770.12, -878.681, 8.52181, 269.795, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(659, 0, '', 0, 1748908800, 10000000, 0, 6, -1, 0, -2707.06, -893.942, 10.1222, -2711.35, -894.013, 10.0237, 89.8524, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(661, 0, '', 0, 1748908800, 10000000, 0, 6, -1, 0, -2692.85, -844.789, 10.5223, -2698.7, -844.572, 10.0223, 84.1394, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(663, 0, '', 0, 1748908800, 10000000, 0, 6, -1, 0, -2707.06, -783.939, 10.122, -2711.23, -783.563, 10.0236, 92.3704, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(662, 0, '', 0, 1748908800, 10000000, 0, 6, -1, 0, -2761.78, -829.16, 8.62202, -2757.46, -829.128, 8.52358, 267.979, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(664, 0, '', 0, 1748908800, 10000000, 0, 6, -1, 0, -2776.09, -768.28, 9.02216, -2770.77, -768.467, 8.52216, 276.269, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(666, 0, '', 0, 1751414400, 10000000, 0, 6, -1, 0, -2748.19, -691.73, 8.62191, -2743.26, -691.613, 8.52348, 262.449, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(665, 0, '', 0, 0, 10000000, 0, 6, -1, 0, -2679.17, -707.211, 10.5219, -2684.96, -707.028, 10.0219, 95.2889, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(667, 0, '', 0, 1751414400, 10000000, 0, 6, -1, 0, -2693.43, -646.539, 10.122, -2697.87, -646.021, 10.0236, 89.5837, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(669, 0, '', 0, 0, 10000000, 0, 6, -1, 0, -2748.2, -581.705, 8.62204, -2743.3, -581.811, 8.52361, 269.885, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(668, 0, '', 6, 0, 10000000, 0, 6, -1, 0, -2762.46, -630.825, 9.02221, -2756.62, -631.174, 8.52221, 274.954, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(670, 0, '', 0, 0, 10000000, 0, 6, -1, 0, -2679.17, -597.261, 10.5219, -2684.39, -596.82, 10.0219, 97.1858, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(672, 0, '', 0, 1776124800, 25000000, 0, 6, -1, 0, -1909.4, 378.102, 28.6363, -1907.12, 378.93, 28.0176, 300.439, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(671, 0, '', 6, 0, 25000000, 0, 6, -1, 0, -1825.23, 420.638, 29.0275, -1827.36, 419.726, 28.8713, 123.966, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(673, 0, '', 0, 1778630400, 25000000, 0, 6, -1, 0, -1873.69, 481.228, 28.9801, -1876.23, 480.146, 28.602, 115.802, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(675, 0, '', 0, 1777593600, 25000000, 0, 6, -1, 1, -1975.67, 544.936, 28.9101, -1975.1, 542.26, 28.9101, 197.373, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(674, 0, '', 0, 1777248000, 25000000, 0, 6, -1, 0, -1959.34, 450.611, 30.421, -1961.53, 455.194, 30.0539, 26.1601, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(676, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1911.96, 577.115, 29.8391, -1915.03, 576.512, 29.8391, 100.633, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(678, 0, '', 0, 1777161600, 25000000, 0, 6, -1, 1, -1920.51, 650.203, 29.7304, -1923.29, 650.172, 29.1118, 95.7938, 0, 0, 0, 0, 312.955, 2157.91, 1765.51, 0, 0, 0, 30, 0, 240),
(677, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -2000.73, 613.702, 29.5068, -1995.93, 614.639, 29.2698, 281.762, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(679, 0, '', 0, 1779235200, 25000000, 0, 6, -1, 1, -1666.15, 722.296, 33.3062, -1663.71, 720.9, 33.0061, 235.471, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(681, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1524.56, 617.828, 32.1888, -1520.5, 620.128, 32.0982, 307.333, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(680, 0, '', 0, 1776902400, 25000000, 0, 6, -1, 0, -1560.09, 669.604, 32.0178, -1557.81, 670.847, 31.8302, 303.327, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(682, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1445.29, 659.15, 31.5992, -1447, 658.589, 31.3577, 125.227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(683, 0, '', 0, 1748908800, 25000000, 0, 6, -1, 0, -1412.91, 588.446, 31.7147, -1415.28, 587.307, 31.4939, 127.605, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(685, 0, '', 0, 1778630400, 25000000, 0, 6, -1, 1, -1349.4, 511.329, 31.3153, -1351.94, 509.639, 31.3153, 114.712, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(684, 0, '', 0, 1749513600, 25000000, 0, 6, -1, 0, -1463.57, 528.016, 31.1849, -1461.2, 529.247, 31.1772, 301.113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(686, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1449.94, 464.916, 31.4915, -1448.28, 466.066, 31.4915, 294.925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(687, 0, '', 0, 1751414400, 25000000, 0, 6, -1, 0, -1405.78, 401.085, 32.5497, -1401.22, 403.696, 32.0669, 305.567, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(688, 0, '', 0, 1748908800, 25000000, 0, 6, -1, 0, -1329.36, 448.761, 31.9248, -1332.14, 447.432, 31.4841, 122.957, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(689, 0, '', 0, 1775174400, 25000000, 0, 6, -1, 0, -1360.98, 348.466, 33.5159, -1357.24, 350.618, 33.5159, 305.806, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(690, 0, '', 0, 1751414400, 25000000, 0, 6, -1, 0, -1284.63, 395.652, 33.1868, -1286.3, 394.648, 32.8069, 122.934, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(691, 0, '', 0, 1778198400, 25000000, 0, 6, -1, 0, -1317.39, 261.332, 33.433, -1315.45, 263.291, 33.133, 315.363, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(692, 0, '', 0, 1748908800, 25000000, 0, 6, -1, 0, -1233.5, 260.171, 33.6513, -1233.22, 262.904, 33.3275, 349.582, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(693, 0, '', 0, 1777593600, 25000000, 0, 6, -1, 0, -1087.42, 252.788, 24.9623, -1085.78, 254.579, 24.9546, 314.901, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(694, 0, '', 0, 1777680000, 25000000, 0, 6, -1, 0, -1064.34, 322.176, 25.5636, -1065.75, 320.191, 25.4922, 144.47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(695, 0, '', 0, 1778198400, 25000000, 0, 6, -1, 0, -964.27, 315.093, 26.0134, -965.831, 313.101, 25.8634, 152.143, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(696, 0, '', 6, 1778284800, 25000000, 0, 6, -1, 0, -956.51, 193.419, 24.8252, -957.978, 194.804, 24.8252, 59.0303, 0, 0, 0, 0, 290.443, 2146.03, 1765.51, 0, 0, 0, 0, 0, 0),
(697, 0, '', 6, 1775865600, 25000000, 0, 6, -1, 0, -1031.28, 183.269, 26.4004, -1030.1, 184.569, 26.1681, 327.862, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(698, 0, '', 0, 1778198400, 25000000, 0, 6, -1, 0, -1147.33, 402.629, 21.2179, -1145.68, 404.841, 20.9179, 322.566, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(699, 0, '', 0, 1776124800, 25000000, 0, 6, -1, 0, -1199.38, 475.468, 20.0275, -1197.47, 476.242, 20.0275, 310.191, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(700, 0, '', 0, 1776988800, 25000000, 0, 6, -1, 0, -1211.57, 533.818, 18.2177, -1209.58, 534.449, 18.21, 305.672, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(701, 0, '', 0, 1777420800, 25000000, 0, 6, -1, 0, -1268.68, 625.419, 17.5641, -1264.43, 627.571, 17.4041, 308.198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(702, 0, '', 0, 1776038400, 25000000, 0, 6, -1, 1, -1316.94, 686.086, 16.8152, -1314.21, 687.645, 16.8152, 304.234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(703, 0, '', 0, 0, 300000, 0, 0, -1, 0, -2361.71, 2556.93, 41.9073, -2361.55, 2558.83, 41.8751, 358.925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(704, 0, '', 0, 0, 300000, 0, 0, -1, 0, -2344.68, 2556.35, 41.8807, -2348.29, 2556.09, 41.8807, 94.6925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(705, 0, '', 0, 0, 300000, 0, 0, -1, 0, -2356.07, 2586.21, 41.7822, -2356.18, 2583.61, 41.7056, 175.521, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(706, 0, '', 0, 0, 300000, 0, 0, -1, 0, -2342.66, 2593.29, 42.0087, -2342.47, 2595.9, 42.0159, 357.106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(707, 0, '', 0, 1720224000, 300000, 0, 0, -1, 0, -2358.29, 2608.53, 42.1794, -2355.73, 2608.37, 41.6961, 278.79, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(708, 0, '', 0, 1720224000, 1, 0, 4, -1, 0, -2975.16, 2906.71, -21.0835, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(709, 0, '', 0, 1720224000, 1, 0, 5, -1, 0, -2973.54, 2823.06, -20.4155, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(710, 0, '', 0, 1720224000, 1, 0, 3, -1, 0, -2977.48, 2822.33, -31.913, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(711, 0, '', 0, 1777939200, 5000000, 0, 3, -1, 0, -441.683, 1309.72, 21.3829, -438.658, 1309.55, 20.8907, 263.811, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(712, 0, '', 6, 0, 5000000, 0, 3, -1, 0, -419.838, 1298.82, 21.3907, -423.169, 1299.26, 20.8907, 91.0164, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(713, 0, '', 0, 1776124800, 5000000, 0, 3, -1, 0, -451.689, 1274.68, 20.9922, -451.993, 1270.26, 20.8317, 183.78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(714, 0, '', 0, 1776902400, 5000000, 0, 3, -1, 0, -404.915, 1272.93, 21.1973, -405.708, 1269.94, 20.8907, 177.867, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(715, 0, '', 0, 1774742400, 5000000, 0, 3, -1, 0, -417.641, 1250.88, 21.3907, -417.256, 1253.93, 20.8907, 359.632, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(716, 0, '', 6, 1778371200, 5000000, 0, 3, -1, 0, -388.207, 1249.38, 20.9922, -387.876, 1253.6, 20.8214, 5.7794, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(717, 0, '', 0, 1778198400, 5000000, 0, 3, -1, 0, -383.089, 1273.68, 21.4921, -383.065, 1269.85, 20.8907, 168.684, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(718, 0, '', 0, 1748908800, 5000000, 0, 3, -1, 0, -373.724, 1250.88, 21.3907, -373.379, 1254.21, 20.8907, 4.60815, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(719, 0, '', 0, 1776816000, 5000000, 0, 3, -1, 0, -351.684, 1289.63, 21.3829, -348.777, 1289.46, 20.8907, 272.99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(722, 0, '', 6, 0, 5000000, 0, 3, -1, 0, -353.634, 1302.83, 20.9922, -348.731, 1302.19, 20.8565, 279.101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(721, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -329.836, 1300.93, 21.3906, -332.743, 1301.21, 20.8906, 96.3524, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(720, 0, '', 0, 1749772800, 5000000, 0, 3, -1, 0, -328.336, 1286.24, 20.9922, -332.239, 1287.05, 20.8052, 86.2336, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(723, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -410.112, 1352.13, 21.197, -409.611, 1354.97, 20.8906, 352.239, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(724, 0, '', 0, 1751328000, 5000000, 0, 3, -1, 0, -394.068, 1374.68, 21.4921, -394.865, 1371.43, 20.8907, 180.623, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(725, 0, '', 0, 1748822400, 5000000, 0, 3, -1, 0, -419.339, 1374.18, 21.3906, -419.685, 1370.83, 20.8906, 186.001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(726, 0, '', 6, 0, 5000000, 0, 3, -1, 0, -460.485, 1378.27, 20.9922, -456.479, 1378.15, 20.8182, 261.083, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(727, 0, '', 0, 1748908800, 5000000, 0, 3, -1, 0, -437.286, 1401.34, 21.3829, -439.768, 1401.2, 20.8907, 90.0487, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(728, 0, '', 6, 0, 5000000, 0, 3, -1, 0, -459.636, 1415.43, 21.4921, -456.27, 1415.06, 20.8907, 263.27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(729, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -458.883, 1437.57, 21.1974, -455.964, 1436.82, 20.8907, 268.391, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(730, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -425.246, 1440.38, 20.9922, -424.493, 1443.86, 20.7836, 359.293, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(731, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -423.325, 1464.18, 21.3907, -423.491, 1460.7, 20.8907, 178.469, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(732, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -410.555, 1441.88, 21.3907, -410.393, 1444.96, 20.8907, 5.35427, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(733, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -397.8, 1463.93, 21.1968, -398.277, 1460.57, 20.8907, 198.894, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(734, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -391.978, 1441.38, 21.4921, -391.58, 1444.95, 20.8906, 8.76733, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(735, 0, '', 0, 1747612800, 5000000, 0, 3, -1, 0, -376.084, 1464.68, 21.4921, -376.652, 1461.16, 20.8907, 189.227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(736, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -364.776, 1465.68, 20.9922, -365.296, 1461.21, 20.8346, 185.824, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(737, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -351.686, 1441.09, 21.3829, -349.07, 1441.01, 20.8907, 273.303, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(738, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -329.342, 1427.03, 21.4921, -333.162, 1427.89, 20.8907, 88.0897, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(739, 0, '', 0, 1776902400, 5000000, 0, 3, -1, 0, -351.883, 1421.26, 21.1966, -349.255, 1420.45, 20.8907, 264.988, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(740, 0, '', 0, 1751328000, 5000000, 0, 3, -1, 0, -328.336, 1415.85, 20.9922, -331.98, 1415.41, 20.792, 97.4815, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(741, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -300.755, 1463.93, 21.1966, -301.448, 1461.37, 20.8907, 168.096, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(742, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -293.218, 1442.52, 21.3829, -305.207, 1506.92, 20.8122, 358.35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(743, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -289.644, 1465.68, 20.9922, -290.462, 1461.81, 20.8036, 179.486, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(744, 0, '', 0, 1720224000, 5000000, 0, 3, -1, 0, -272.932, 1441.38, 21.4921, -272.296, 1444.52, 20.8906, 359.444, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(745, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -260.297, 1464.18, 21.3906, -260.786, 1461.09, 20.8906, 184.388, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(746, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -232.337, 1419.64, 21.4921, -235.932, 1420.18, 20.8906, 81.6814, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(747, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -254.737, 1413.66, 21.1971, -251.924, 1413.11, 20.8907, 276.663, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(748, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -232.835, 1400.88, 21.3906, -235.677, 1401.25, 20.8906, 95.8399, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(749, 0, '', 6, 0, 5000000, 0, 3, -1, 0, -231.337, 1386.27, 20.9922, -234.782, 1386.93, 20.7819, 89.5462, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(750, 0, '', 0, 1750550400, 5000000, 0, 3, -1, 0, -260.351, 1374.18, 21.3906, -260.716, 1371.73, 20.8906, 176.112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(751, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -272.918, 1351.38, 21.4921, -272.373, 1354.64, 20.8906, 3.68865, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(754, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -435.793, 1503.89, 21.4921, -435.192, 1507.77, 20.8906, 4.61923, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(753, 0, '', 0, 1748822400, 5000000, 0, 3, -1, 0, -460.636, 1490.31, 20.9922, -456.318, 1490.44, 20.8265, 269.24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(755, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -419.919, 1526.43, 21.1973, -420.342, 1523.46, 20.8907, 176.448, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(756, 0, '', 0, 1747526400, 5000000, 0, 3, -1, 0, -412.058, 1504.84, 21.3829, -411.822, 1507.69, 20.8906, 351.432, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(757, 0, '', 3, 0, 5000000, 0, 3, -1, 0, -408.803, 1528.18, 20.9922, -409.444, 1523.77, 20.8312, 176.875, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(758, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -388.595, 1504.4, 21.3906, -388.294, 1507.4, 20.8906, 2.54091, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(759, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -376.139, 1527.18, 21.4921, -376.656, 1523.6, 20.8907, 175.212, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(760, 0, '', 0, 1748044800, 5000000, 0, 3, -1, 0, -370.143, 1504.63, 21.1969, -369.591, 1507.34, 20.8906, 355.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(761, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -355.853, 1526.23, 21.3829, -356.016, 1523.82, 20.8907, 176.869, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(762, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -301.098, 1527.18, 21.4921, -301.122, 1523.73, 20.8907, 178.476, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(763, 0, '', 0, 1750032000, 5000000, 0, 3, -1, 0, -306.309, 1502.88, 20.9922, -305.207, 1506.92, 20.8122, 358.35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(764, 0, '', 6, 1747440000, 5000000, 0, 3, -1, 0, -231.338, 1334.7, 20.9922, -930.223, -1879.71, 39.4895, 167.239, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(765, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -254.879, 1318.13, 21.1972, -251.991, 1317.57, 20.8907, 263.125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(766, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -232.835, 1305.48, 21.3907, -235.978, 1305.24, 20.8907, 92.0484, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(767, 0, '', 6, 1747526400, 5000000, 0, 3, -1, 0, -231.339, 1290.72, 20.9922, -235.57, 1291.26, 20.8222, 94.6728, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(768, 0, '', 6, 1750291200, 5000000, 0, 3, -1, 0, -260.126, 1273.68, 21.4921, -260.377, 1270.38, 20.8907, 175.995, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(769, 0, '', 0, 1747872000, 5000000, 0, 3, -1, 0, -272.54, 1251.06, 21.3907, -272.607, 1253.91, 20.8907, 358.728, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(770, 0, '', 0, 1747872000, 5000000, 0, 3, -1, 0, -283.722, 1272.73, 21.3829, -284.2, 1269.99, 20.8907, 182.026, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(771, 0, '', 0, 1777161600, 5000000, 0, 3, -1, 0, -287.333, 1249.38, 20.9922, -286.347, 1255, 20.8929, 356.872, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(772, 0, '', 6, 0, 5000000, 0, 3, -1, 0, -316.667, 1250.89, 21.3907, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(773, 0, '', 0, 0, 5000000, 0, 3, -1, 0, -260.319, 1526.68, 21.3906, -261.219, 1522.54, 20.8906, 184.136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(774, 0, '', 0, 1750377600, 5000000, 0, 3, -1, 0, -272.814, 1503.88, 21.4921, -272.652, 1506.51, 20.8906, 355.456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(775, 0, '', 0, 1748044800, 5000000, 0, 3, -1, 0, -233.498, 1483.7, 21.3829, -235.561, 1483.45, 20.8906, 88.3708, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(776, 0, '', 2, 0, 300000, 0, 0, -1, 0, -668.939, -1913.36, 42.2252, -671.119, -1916.08, 41.0419, 151.714, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(777, 0, '', 0, 1777507200, 300000, 0, 0, -1, 0, -715.995, -1882.22, 41.0419, -719.01, -1884, 41.0489, 150.676, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(778, 0, '', 0, 0, 300000, 0, 0, -1, 0, -746.745, -1863.08, 41.0489, -748.486, -1865.25, 41.0489, 141.552, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(779, 0, '', 0, 1777593600, 300000, 0, 0, -1, 0, -790.019, -1950.13, 41.2141, -795.123, -1950.03, 41.2213, 250.207, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(780, 0, '', 0, 1775433600, 300000, 0, 0, -1, 0, -797.749, -1958.29, 41.2213, -800.727, -1957, 41.2213, 88.1277, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(781, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -800.605, -2032.36, 41.2141, -799.987, -2034.67, 41.2213, 174.732, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(782, 0, '', 0, 1751241600, 300000, 0, 0, -1, 0, -792.186, -2054.84, 42.1262, -792.731, -2057.7, 41.2213, 174.706, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(783, 0, '', 6, 0, 300000, 0, 0, -1, 0, -793.104, -2081.52, 42.3276, -795.77, -2082, 41.2213, 99.1165, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(784, 0, '', 0, 0, 300000, 0, 0, -1, 0, -804.415, -2117.08, 41.2213, -805.071, -2119.52, 41.2213, 179.921, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(785, 0, '', 0, 1777420800, 300000, 0, 0, -1, 0, -800.084, -2151.77, 42.3181, -803.552, -2152.38, 41.2213, 96.7975, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(786, 0, '', 0, 1777507200, 300000, 0, 0, -1, 1, -838.527, -2222.25, 42.026, -839.403, -2218.73, 41.0456, 10.6123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 249),
(787, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -928.57, -2175.15, 40.6782, -930.895, -2175.11, 39.5001, 100.383, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(788, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -981.846, -2179.49, 40.479, -978.621, -2179.65, 39.5001, 274.745, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(789, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -970.257, -2141.66, 39.5001, -968.222, -2141.67, 39.5001, 266.776, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(790, 0, '', 0, 0, 300000, 0, 0, -1, 0, -930.089, -2119.02, 39.5001, -931.615, -2118.29, 39.5001, 83.2881, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(791, 0, '', 0, 0, 300000, 0, 0, -1, 0, -983.057, -2093.42, 39.4928, -984.932, -2092.94, 39.4928, 90.376, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(793, 0, '', 0, 0, 300000, 0, 0, -1, 0, -983.961, -2048.33, 40.6592, -981.235, -2048.98, 39.5001, 262.99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(794, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -922.485, -2030.58, 40.4022, -922.917, -2032.95, 39.5001, 181.318, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(795, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -981.566, -2003.99, 40.6592, -979.138, -2003.48, 39.5001, 274.256, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(796, 0, '', 0, 1750204800, 300000, 0, 0, -1, 0, -984.996, -1988.43, 40.6722, -982.93, -1988.76, 39.5001, 273.776, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(797, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -978.014, -1956.37, 39.5001, -978.608, -1957.77, 39.5001, 186.993, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(798, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, -988.446, -1923.19, 40.6026, -986.746, -1922.68, 39.9319, 269.255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(799, 0, '', 0, 1777248000, 300000, 0, 0, -1, 0, -938.759, -1908.61, 39.5001, -941.652, -1908.21, 39.5001, 93.7762, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(800, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -988.689, -1892.92, 40.6026, -986.65, -1892.63, 39.7746, 275.878, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(801, 0, '', 0, 1777334400, 300000, 0, 0, -1, 0, -981.775, -1857.67, 40.5921, -976.565, -1856.93, 39.4895, 272.957, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(802, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -930.897, -1877.87, 39.4895, -930.223, -1879.71, 39.4895, 167.239, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(803, 0, '', 0, 1750550400, 300000, 0, 0, -1, 0, -943.162, -1829.83, 39.4969, -945.683, -1829.49, 39.4969, 88.5327, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(804, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, -933.116, -1811.18, 39.4969, -935.314, -1811, 39.4969, 93.1076, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(805, 0, '', 6, 1777334400, 300000, 0, 0, -1, 0, -977.163, -1802.5, 39.4969, -977.22, -1800.37, 39.4969, 349.503, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(806, 0, '', 0, 0, 300000, 0, 0, -1, 0, -1022.65, -1699.8, 42.205, -1023.72, -1696.31, 41.2234, 20.3154, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(807, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -1044.85, -1713.51, 42.3973, -1046.21, -1711.33, 41.2234, 23.6349, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(808, 0, '', 0, 0, 300000, 0, 0, -1, 0, -1072.98, -1723.93, 41.2296, -1075.83, -1726.33, 41.2296, 104.458, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(809, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, -1100.45, -1735.69, 42.3853, -1101.18, -1733.3, 41.2234, 18.6019, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(810, 0, '', 0, 0, 300000, 0, 0, -1, 0, -1126.75, -1744.05, 41.2234, -1125.36, -1743.7, 41.2234, 23.9434, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(811, 0, '', 0, 1750291200, 300000, 0, 0, -1, 0, -1157.05, -1749.6, 41.2234, -1157.75, -1747.26, 41.2234, 25.0643, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(812, 0, '', 0, 1750377600, 300000, 0, 0, -1, 0, -1175.01, -1778.21, 42.3286, -1176.13, -1776.76, 41.6887, 28.3681, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(813, 0, '', 6, 0, 300000, 0, 0, -1, 0, 696.753, -927.968, 41.2076, 700.549, -927.613, 40.9502, 287.832, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(814, 0, '', 0, 1748044800, 300000, 0, 0, -1, 0, 653.027, -940.353, 41.2072, 654.91, -939.781, 40.9496, 275.835, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(815, 0, '', 0, 0, 300000, 0, 0, -1, 0, 613.272, -951.263, 40.998, 613.493, -953.917, 40.998, 195.799, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(816, 0, '', 6, 1748044800, 300000, 0, 0, -1, 0, 569.084, -958.964, 41.4513, 569.498, -955.391, 40.9495, 13.0949, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(817, 0, '', 0, 1777507200, 300000, 0, 0, -1, 1, 570.28, -966.055, 41.4513, 570.651, -968.959, 41.4063, 183.553, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(818, 0, '', 0, 0, 300000, 0, 0, -1, 0, 519.725, -980.456, 41.5329, 520.35, -983.227, 40.9495, 212.001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(819, 0, '', 0, 0, 300000, 0, 0, -1, 0, 459.611, -981.773, 41.4499, 462.163, -983.177, 40.9496, 194.342, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(820, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, 434.655, -1010.87, 41.4498, 434.696, -1008.26, 40.9497, 12.3814, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(821, 0, '', 0, 1777507200, 300000, 0, 0, -1, 0, 389.29, -1015.75, 41.4497, 389.455, -1018.69, 40.9998, 207.302, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(822, 0, '', 0, 0, 300000, 0, 0, -1, 0, 304.961, -1042.89, 40.998, 305.437, -1045.25, 40.998, 183.21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(823, 0, '', 0, 0, 300000, 0, 0, -1, 0, 313.149, -1129.59, 40.998, 313.482, -1131.58, 40.998, 196.149, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(824, 0, '', 0, 0, 300000, 0, 0, -1, 0, 353.771, -1119.1, 41.2072, 355.558, -1118.34, 40.9496, 280.951, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(825, 0, '', 0, 0, 300000, 0, 0, -1, 0, 397.11, -1109.13, 41.2076, 400.459, -1109.04, 40.9502, 283.061, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(826, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 440.022, -1102.08, 41.4498, 439.742, -1099.32, 40.9497, 12.8331, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(827, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, 470.612, -1070.41, 41.4499, 472.285, -1072.43, 40.9496, 190.848, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(828, 0, '', 0, 1750118400, 300000, 0, 0, -1, 0, 533.642, -1078.66, 41.5332, 533.581, -1081.54, 40.9494, 185.174, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(829, 0, '', 0, 1751068800, 300000, 0, 0, -1, 0, 580.252, -1072.12, 41.4514, 580.901, -1075.59, 41.1441, 187.638, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(830, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 625.61, -1056.32, 40.998, 626.154, -1058.7, 40.998, 182.885, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(831, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 667.104, -1048.14, 41.2072, 669.358, -1048.12, 40.9496, 271.262, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(832, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, 711.113, -1040.1, 41.2076, 714.679, -1040.21, 40.9502, 277.492, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(833, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, 687.003, -1094.95, 41.2072, 685.002, -1094.84, 40.9496, 110.951, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(834, 0, '', 0, 0, 300000, 0, 0, -1, 0, 645.292, -1103.86, 41.2076, 642.021, -1103.94, 40.9502, 98.2005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(835, 0, '', 0, 0, 300000, 0, 0, -1, 0, 599.916, -1107.19, 41.4498, 600.096, -1109.5, 40.9497, 192.901, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(836, 0, '', 0, 1750464000, 300000, 0, 0, -1, 0, 566.862, -1135.98, 41.4499, 564.503, -1134.28, 40.9496, 14.9721, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(837, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, 508.063, -1125.26, 41.5287, 507.39, -1122.64, 40.9495, 7.71432, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(838, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 462.852, -1135, 41.4514, 461.518, -1131.43, 40.9495, 20.2804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(839, 0, '', 0, 0, 300000, 0, 0, -1, 0, 419.595, -1155.14, 40.998, 418.628, -1151.92, 40.998, 3.83124, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(840, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, 335.93, -1176.09, 41.2076, 332.751, -1176.42, 40.9502, 102.714, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(841, 0, '', 0, 0, 300000, 0, 0, -1, 0, 378.555, -1274.5, 41.4499, 376.37, -1272.59, 40.9496, 24.313, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(842, 0, '', 6, 1774742400, 300000, 0, 0, -1, 0, 416.812, -1230.83, 41.4515, 415.032, -1227.09, 40.9497, 27.4188, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(843, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 458.584, -1230.05, 41.2076, 455.17, -1230.11, 40.9502, 95.1616, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(844, 0, '', 0, 0, 300000, 0, 0, -1, 0, 503.158, -1226.83, 41.2072, 501.549, -1227.16, 40.9496, 92.17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(845, 0, '', 0, 1775433600, 300000, 0, 0, -1, 0, 595.292, -1201.44, 41.4501, 595.808, -1203.9, 40.9501, 198.574, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(846, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 637.423, -1191.42, 41.5337, 637.379, -1188.07, 40.9496, 6.48014, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(847, 0, '', 0, 1747958400, 300000, 0, 0, -1, 0, 692.383, -1189.48, 41.4497, 694.158, -1185.72, 40.9998, 350.46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(792, 0, '', 5, 1777334400, 300000, 0, 0, -1, 0, -932.387, -2077.69, 39.5001, -935.302, -2077.44, 39.5001, 77.0963, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(848, 0, '', 0, 0, 300000, 0, 0, -1, 0, 728.781, -1212.62, 41.4499, 727.556, -1210.36, 40.9496, 349.419, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(849, 0, '', 6, 1777852800, 300000, 0, 0, -1, 0, 708.417, -1294.75, 41.4499, 709.662, -1296.92, 40.9496, 189.799, 0, 0, 0, 0, 2493.24, 999.944, 1499.62, 0, 0, 0, 0, 0, 0),
(850, 0, '', 0, 1750291200, 300000, 0, 0, -1, 0, 672.171, -1319.79, 41.4501, 672.273, -1317.4, 40.9501, 352.571, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(851, 0, '', 0, 1747872000, 300000, 0, 0, -1, 0, 624.916, -1319.29, 41.2076, 627.782, -1319.34, 40.9502, 283.614, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(852, 0, '', 0, 0, 300000, 0, 0, -1, 0, 581.356, -1328.27, 41.2072, 583.01, -1327.68, 40.9496, 272.437, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(853, 0, '', 6, 1774569600, 300000, 0, 0, -1, 0, 503.052, -1326.32, 41.4515, 501.888, -1329.59, 41.1604, 164.603, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(854, 0, '', 0, 1751328000, 7000000, 0, 3, -1, 0, 510.467, 331.293, 12.4531, 510.755, 328.402, 12.4531, 188.535, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(855, 0, '', 0, 1751068800, 7000000, 0, 3, -1, 0, 491.684, 315.853, 12.7031, 494.327, 314.984, 12.7031, 270.021, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(856, 0, '', 0, 0, 7000000, 0, 3, -1, 0, 497.636, 273.956, 12.543, 497.803, 275.816, 12.4531, 351.527, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(857, 0, '', 0, 1775001600, 7000000, 0, 3, -1, 0, 508.282, 273.778, 12.543, 508.505, 276.604, 12.4182, 4.88455, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(858, 0, '', 0, 0, 7000000, 0, 3, -1, 0, 468.376, 273.78, 12.5428, 468.441, 276.239, 12.3116, 1.72714, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(864, 0, '', 0, 1748908800, 7000000, 0, 3, -1, 0, 384.603, 285.153, 12.543, 384.885, 287.602, 12.4408, 351.186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(859, 0, '', 0, 0, 7000000, 0, 3, -1, 0, 457.912, 273.778, 12.5428, 457.524, 275.783, 12.3625, 4.2329, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(860, 0, '', 6, 1774742400, 7000000, 0, 3, -1, 0, 471.331, 315.565, 12.7109, 469.118, 315.975, 12.5427, 82.3947, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(862, 0, '', 0, 1748822400, 7000000, 0, 3, -1, 0, 427.178, 297.097, 12.4531, 430.443, 296.945, 12.3543, 257.646, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(863, 0, '', 0, 1774310400, 7000000, 0, 3, -1, 0, 428.434, 278.945, 12.5, 430.525, 278.505, 12.3884, 263.099, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(865, 0, '', 6, 1777420800, 7000000, 0, 3, -1, 0, 374.136, 285.155, 12.543, 374.314, 287.858, 12.4274, 6.0867, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(866, 0, '', 0, 1777075200, 7000000, 0, 3, -1, 0, 371.064, 328.924, 12.7031, 2893.08, 2399.67, 2.92273, 14.0047, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(871, 0, '', 0, 1778457600, 300000, 0, 0, -1, 0, 1943.52, 1806.86, 15.5073, 1943.24, 1808.69, 15.3979, 6.59181, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(861, 0, '', 0, 0, 7000000, 0, 3, -1, 0, 446.584, 333.995, 12.4608, 446.093, 331.331, 12.4531, 182.426, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(879, 0, '', 0, 1751414400, 300000, 0, 0, -1, 0, 2590.4, -230.938, 4.04322, 2590.62, -229.353, 4.03842, 351.38, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(867, 0, '', 0, 1749686400, 7000000, 0, 3, -1, 0, 390.398, 344.407, 12.4608, 390.087, 341.14, 12.3374, 185.986, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(880, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 2573.42, -230.525, 3.49045, 2573.41, -228.223, 3.49048, 356.337, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(881, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, 2513.71, -230.504, 2.56648, 2513.94, -228.163, 2.56648, 349.615, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(882, 0, '', 0, 1777420800, 300000, 0, 0, -1, 0, 2524.48, -198.828, 3.72267, 2524.81, -200.71, 3.72267, 183.334, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(883, 0, '', 0, 1775433600, 300000, 0, 0, -1, 0, 2487.49, -252.63, 1.842, 2489.37, -252.921, 1.84912, 270.395, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(884, 0, '', 6, 0, 300000, 0, 0, -1, 0, 2466.55, -201.204, 2.14461, 2466.26, -202.736, 2.14461, 178.156, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(885, 0, '', 2, 0, 300000, 0, 0, -1, 0, 2422.08, -206.15, 2.3524, 2420.4, -206.52, 2.1459, 97.8874, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(886, 0, '', 0, 1778284800, 300000, 0, 0, -1, 0, 2414.78, -230.613, 2.06485, 2415.2, -228.768, 2.08585, 355.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(887, 0, '', 0, 1777507200, 300000, 0, 0, -1, 0, 2381.85, -202.497, 2.84304, 2381.56, -204.201, 2.13854, 174.068, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(888, 0, '', 0, 1777075200, 300000, 0, 0, -1, 1, 2330.15, -205.211, 2.4335, 2330.28, -207.804, 2.14294, 168.426, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(889, 0, '', 5, 0, 300000, 0, 0, -1, 0, 2240.52, -197.199, 2.38839, 2242.14, -197.74, 2.29416, 257.608, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(890, 0, '', 0, 1776902400, 300000, 0, 0, -1, 0, 2261.26, -230.622, 2.0732, 2261.53, -229.073, 2.10869, 357.253, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(891, 0, '', 6, 0, 300000, 0, 0, -1, 0, 2204.69, -231.383, 2.06591, 2205.03, -228.732, 2.25664, 6.07351, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(892, 0, '', 0, 1751414400, 300000, 0, 0, -1, 0, -2739.45, 1110.14, 10.301, -2741.6, 1110.29, 9.73145, 85.4818, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(893, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -2717.63, 1161.36, 10.2858, -2718.07, 1159.18, 9.70868, 171.64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(894, 0, '', 0, 1748822400, 300000, 0, 0, -1, 0, -2764.33, 1183.04, 10.2319, -2761.92, 1182.94, 9.73176, 263.586, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(895, 0, '', 6, 0, 300000, 0, 0, -1, 0, -2801.55, 1160.17, 10.2108, -2801.44, 1157.24, 10.1561, 180.02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(896, 0, '', 0, 1747785600, 300000, 0, 0, -1, 0, -2857.5, 1190.77, 9.98919, -2857.57, 1192.61, 9.73171, 358.559, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(897, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2862.07, 1154.18, 9.9896, -2862.06, 1155.88, 9.73236, 2.44937, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(898, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2854.62, 1109.53, 10.3083, -2851.86, 1109.1, 9.73162, 259.613, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(899, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2801.49, 1101.39, 9.98919, -2801.83, 1099.15, 9.73171, 172.335, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(900, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2785.1, 1066.27, 10.2319, -2785.35, 1063.9, 9.73176, 182.809, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(901, 0, '', 0, 1751414400, 300000, 0, 0, -1, 0, -2853.01, 1055.95, 10.2332, -2850.48, 1056.01, 10.2332, 268.634, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(902, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2809.07, 1013.64, 10.2332, -2811.45, 1013.75, 10.2332, 83.6943, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(903, 0, '', 0, 1748044800, 300000, 0, 0, -1, 0, -2863.99, 1013.94, 9.9896, -2863.86, 1015.85, 9.73236, 357.758, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(904, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2800.54, 938.233, 9.9896, -2800.56, 936.207, 9.73236, 171.956, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(905, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2863.56, 928.329, 9.98919, -2862.99, 930.141, 9.73171, 344.189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(906, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, -2818.4, 893.577, 10.309, -2820.37, 894.185, 9.7315, 63.0694, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(907, 0, '', 0, 1749945600, 300000, 0, 0, -1, 0, -2882.05, 891.409, 9.9896, -2880.57, 893.35, 9.73236, 336.048, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(908, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2841.74, 850.977, 10.2332, -2844.04, 852.495, 10.2332, 57.8782, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(909, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2679.66, 1072.39, 10.2319, -2678.89, 1070.25, 9.73176, 207.744, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(910, 0, '', 0, 1774396800, 300000, 0, 0, -1, 0, -2738.35, 948.297, 10.2332, -2738.18, 950.52, 10.2332, 349.746, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(911, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, -2729.54, 823.823, 10.2319, -2731.86, 822.866, 9.73176, 113.839, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(912, 0, '', 0, 1774569600, 300000, 0, 0, -1, 0, -2777.19, 810.609, 9.98919, -2778.33, 809.264, 9.73171, 143.751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(923, 0, '', 0, 1750464000, 200000, 0, 1, -1, 0, 2893.08, 2399.67, 2.92273, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(914, 0, '', 0, 0, 300000, 0, 0, -1, 0, 1764.02, 1334.28, 9.79781, 1765.72, 1333.84, 9.79781, 257.664, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(915, 0, '', 0, 1751414400, 300000, 0, 0, -1, 0, 1800.62, 1337.82, 9.79781, 1800.46, 1335.35, 9.79781, 190.103, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(916, 0, '', 0, 1776556800, 300000, 0, 0, -1, 0, 1813.31, 1333.21, 9.79781, 1812.96, 1331.71, 9.79781, 187.621, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(917, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 1838.1, 1338.24, 9.79781, 1837.77, 1336.47, 9.79781, 160.983, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(918, 0, '', 0, 1774396800, 300000, 0, 0, -1, 0, 1865.88, 1337.12, 9.79781, 1865.9, 1338.92, 9.79781, 344.536, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(919, 0, '', 6, 0, 300000, 0, 0, -1, 0, 1865.36, 1358.17, 9.79781, 1864.86, 1360.28, 9.79781, 357.555, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(920, 0, '', 0, 1777334400, 300000, 0, 0, -1, 0, 1859.39, 1404.84, 9.79781, 1859.2, 1402.87, 9.79781, 183.596, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(921, 0, '', 6, 1774915200, 300000, 0, 0, -1, 0, 1865.03, 1419.19, 10.2681, 1865.65, 1421.54, 9.79781, 0.752886, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(922, 0, '', 0, 1774828800, 300000, 0, 0, -1, 0, 1866.05, 1439.86, 9.79781, 1866, 1441.62, 9.79781, 344.029, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `houses_renters`
--

CREATE TABLE `houses_renters` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `rent_time` int(11) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `house_storage`
--

CREATE TABLE `house_storage` (
  `id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL COMMENT 'ID дома из таблицы houses',
  `slot` int(11) NOT NULL DEFAULT 0 COMMENT 'Слот шкафа (0-79)',
  `item_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ID предмета',
  `amount` int(11) NOT NULL DEFAULT 1 COMMENT 'Количество предмета',
  `item_type` int(11) NOT NULL DEFAULT 0 COMMENT 'Тип предмета',
  `item_plate` varchar(32) NOT NULL DEFAULT '' COMMENT 'Пластина (для номеров, SIM-карт и т.д.)'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `items_data`
--

CREATE TABLE `items_data` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` int(11) NOT NULL DEFAULT 0,
  `item_weight` int(11) NOT NULL DEFAULT 1,
  `item_max_stack` int(11) NOT NULL DEFAULT 999
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `items_data`
--

INSERT INTO `items_data` (`id`, `item_id`, `item_name`, `item_type`, `item_weight`, `item_max_stack`) VALUES
(1, 1, 'Документы', 0, 1, 1),
(2, 22, 'Аптечка', 5, 2, 10),
(3, 58, 'SIM-карта', 2, 1, 1),
(4, 59, 'Номерной знак', 3, 3, 1),
(5, 81, 'Номерной знак (грузовой)', 3, 3, 1),
(6, 82, 'Номерной знак (прицеп)', 3, 3, 1),
(7, 83, 'Номерной знак (спец)', 3, 3, 1),
(8, 134, 'Скин', 1, 5, 1),
(9, 135, 'Еда', 4, 1, 20),
(10, 201, 'Accessory', 6, 2, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `leaders`
--

CREATE TABLE `leaders` (
  `id` int(11) NOT NULL,
  `accout_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(64) NOT NULL,
  `frac_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_favorites`
--

CREATE TABLE `marketplace_favorites` (
  `account_id` int(11) NOT NULL,
  `lot_id` int(11) NOT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_history`
--

CREATE TABLE `marketplace_history` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `lot_id` int(11) NOT NULL DEFAULT 0,
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL DEFAULT 1,
  `amount` int(11) NOT NULL DEFAULT 1,
  `price` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `seller_name` varchar(24) NOT NULL DEFAULT '',
  `buyer_name` varchar(24) NOT NULL DEFAULT '',
  `item_name` varchar(64) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_items`
--

CREATE TABLE `marketplace_items` (
  `id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `seller_name` varchar(24) NOT NULL DEFAULT '',
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL DEFAULT 1,
  `item_name` varchar(64) NOT NULL DEFAULT '',
  `price` int(11) NOT NULL,
  `is_hot` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `buyer_id` int(11) NOT NULL DEFAULT 0,
  `buyer_name` varchar(24) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL DEFAULT 0,
  `expires_at` int(11) NOT NULL DEFAULT 0,
  `sold_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_likes`
--

CREATE TABLE `marketplace_likes` (
  `player_id` int(11) NOT NULL,
  `listing_id` int(11) NOT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_lots`
--

CREATE TABLE `marketplace_lots` (
  `id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `seller_name` varchar(24) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 1,
  `item_plate` varchar(32) NOT NULL DEFAULT '',
  `item_name` varchar(64) NOT NULL DEFAULT '',
  `item_type` int(11) NOT NULL DEFAULT 0,
  `rarity` int(11) NOT NULL DEFAULT 1,
  `price` int(11) NOT NULL,
  `is_hot` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  `expires_at` int(11) NOT NULL,
  `buyer_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_reward_items`
--

CREATE TABLE `marketplace_reward_items` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL DEFAULT 1,
  `item_plate` varchar(32) NOT NULL DEFAULT '',
  `item_name` varchar(64) NOT NULL DEFAULT '',
  `source_lot` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_wallet`
--

CREATE TABLE `marketplace_wallet` (
  `account_id` int(11) NOT NULL,
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `updated_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `mhcwork`
--

CREATE TABLE `mhcwork` (
  `account_id` int(11) NOT NULL,
  `employed` tinyint(1) NOT NULL DEFAULT 0,
  `experience` int(11) NOT NULL DEFAULT 0,
  `extinguisher_count` int(11) NOT NULL DEFAULT 0,
  `shovel_count` int(11) NOT NULL DEFAULT 0,
  `crowbar_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `mhcwork`
--

INSERT INTO `mhcwork` (`account_id`, `employed`, `experience`, `extinguisher_count`, `shovel_count`, `crowbar_count`) VALUES
(8, 0, 0, 0, 0, 0),
(10, 0, 0, 0, 0, 0),
(11, 0, 0, 0, 0, 0),
(12, 0, 0, 0, 0, 0),
(13, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `money_log`
--

CREATE TABLE `money_log` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255',
  `time` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `description` varchar(64) NOT NULL DEFAULT 'None'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `money_log`
--

INSERT INTO `money_log` (`id`, `uid`, `uip`, `time`, `money`, `description`) VALUES
(1, 7, '178.216.209.173', 1788244932, -500000, 'Покупка гаража'),
(2, 7, '178.216.209.173', 1788248018, -500000, 'Покупка гаража'),
(3, 7, '178.216.209.173', 1788266816, -500000, 'Покупка гаража'),
(4, 7, '178.216.209.173', 1788266875, 350000, '[BANK] Продажа гаража'),
(5, 7, '178.216.209.173', 1788266875, 0, 'Продажа гаража государству'),
(6, 7, '178.216.209.173', 1788266878, -500000, 'Покупка гаража'),
(7, 7, '178.216.209.173', 1788266893, -5000000, 'None'),
(8, 7, '178.216.209.173', 1788282079, -500000, 'Покупка гаража'),
(9, 7, '178.216.209.173', 1788285528, 0, 'None'),
(10, 7, '178.216.209.173', 1788285629, 350000, '[BANK] Продажа гаража'),
(11, 7, '178.216.209.173', 1788285629, 0, 'Продажа гаража государству'),
(12, 7, '178.216.209.173', 1788285660, 0, '[BANK] Зарплата'),
(13, 7, '178.216.209.173', 1788285681, -10000000, 'Покупка бизнеса'),
(14, 7, '178.216.209.173', 1788285696, -22500, 'None'),
(15, 7, '178.216.209.173', 1788285701, -22500, 'None'),
(16, 7, '178.216.209.173', 1788285705, -22500, 'None'),
(17, 7, '178.216.209.173', 1788285709, -22500, 'None'),
(18, 7, '178.216.209.173', 1788285713, -22500, 'None'),
(19, 7, '178.216.209.173', 1788285718, -22500, 'None'),
(20, 7, '178.216.209.173', 1788295190, 0, 'None'),
(21, 7, '178.216.209.173', 1788327165, 0, 'None'),
(22, 7, '178.216.209.173', 1788327227, -57500, 'None'),
(23, 7, '178.216.209.173', 1788327232, -57500, 'None'),
(24, 7, '178.216.209.173', 1788327342, -300, 'Метка ТС на GPS'),
(25, 7, '178.216.209.173', 1788332182, -17500, 'None'),
(26, 7, '178.216.209.173', 1788332188, -57500, 'None'),
(27, 7, '178.216.209.173', 1788332200, -27500, 'None'),
(28, 7, '178.216.209.173', 1788332227, -57500, 'None'),
(29, 7, '178.216.209.173', 1788332232, -57500, 'None'),
(30, 7, '178.216.209.173', 1788340975, -500000, 'Покупка гаража'),
(31, 7, '178.216.209.173', 1788340991, -5000000, 'None'),
(32, 7, '178.216.209.173', 1788341617, -500000, 'Покупка гаража'),
(33, 7, '178.216.209.173', 1788341681, -5000000, 'None'),
(34, 7, '178.216.209.173', 1788341694, 350000, '[BANK] Продажа гаража'),
(35, 7, '178.216.209.173', 1788341694, 0, 'Продажа гаража государству'),
(36, 7, '178.216.209.173', 1788341698, -500000, 'Покупка гаража'),
(37, 7, '178.216.209.173', 1788341727, 350000, '[BANK] Продажа гаража'),
(38, 7, '178.216.209.173', 1788341727, 0, 'Продажа гаража государству'),
(39, 7, '178.216.209.173', 1788341786, -500000, 'Покупка гаража'),
(40, 7, '178.216.209.173', 1788341795, 350000, '[BANK] Продажа гаража'),
(41, 7, '178.216.209.173', 1788341795, 0, 'Продажа гаража государству'),
(42, 7, '178.216.209.173', 1788341798, -500000, 'Покупка гаража'),
(43, 7, '178.216.209.173', 1788341805, 350000, '[BANK] Продажа гаража'),
(44, 7, '178.216.209.173', 1788341805, 0, 'Продажа гаража государству'),
(45, 7, '178.216.209.173', 1788341863, -500000, 'Покупка гаража'),
(46, 7, '178.216.209.173', 1788365920, -130000000, 'None'),
(47, 8, '92.36.120.113', 1788853145, 10000, 'За выполнение задания'),
(48, 8, '92.36.120.113', 1788853152, -79000, 'None'),
(49, 8, '92.36.120.113', 1788853213, -17550, 'None'),
(50, 8, '92.36.120.113', 1788853229, -17550, 'None'),
(51, 8, '92.36.120.113', 1788853245, -27550, 'None'),
(52, 8, '92.36.120.113', 1788853436, 500000000, 'Выдача денег от админа Manta_Dev'),
(53, 8, '92.36.120.113', 1788853509, -22550, 'None'),
(54, 8, '92.36.120.113', 1788853513, -22550, 'None'),
(55, 8, '92.36.120.113', 1788853517, -22550, 'None'),
(56, 8, '92.36.120.113', 1788853521, -22550, 'None'),
(57, 8, '92.36.120.113', 1788853527, -22550, 'None'),
(58, 8, '92.36.120.113', 1788853536, -57550, 'None'),
(59, 8, '146.70.230.147', 1788896221, -50, 'Аренда скутера'),
(60, 8, '146.70.230.147', 1788901541, -79000, 'None'),
(61, 8, '185.184.192.248', 1789729389, -500000, 'Покупка бизнеса'),
(62, 8, '185.184.192.248', 1789729399, 350000, '[BANK] Продажа бизнеса'),
(63, 8, '185.184.192.248', 1789729399, 0, 'Продажа бизнеса государству'),
(64, 8, '185.184.192.248', 1789729404, -79000, 'None'),
(65, 8, '103.216.221.105', 1789732844, -120, 'Покупка в ларьке'),
(66, 8, '103.216.221.105', 1789732849, -500000, 'Покупка бизнеса'),
(67, 8, '103.216.221.105', 1789732860, 0, '[BANK] Зарплата'),
(68, 8, '103.216.221.105', 1789732873, 350000, '[BANK] Продажа бизнеса'),
(69, 8, '103.216.221.105', 1789732873, 0, 'Продажа бизнеса государству'),
(70, 9, '37.114.130.149', 1789733948, -500000, 'Покупка бизнеса'),
(71, 10, '149.40.62.2', 1790006362, -50, 'Аренда скутера'),
(72, 8, '138.199.35.123', 1790010520, 1000, 'BlackPass task reward'),
(73, 8, '138.199.35.123', 1790010544, -79000, 'None'),
(74, 13, '77.79.149.199', 1790010608, 1000, 'BlackPass task reward'),
(75, 8, '138.199.35.123', 1790010740, -3000000, 'None'),
(76, 8, '138.199.35.123', 1790010740, 10000, 'Выполнение квеста'),
(77, 13, '77.79.149.199', 1790011329, -25800, 'None'),
(78, 13, '77.79.149.199', 1790011335, -25800, 'None'),
(79, 13, '77.79.149.199', 1790011338, -25800, 'None'),
(80, 13, '77.79.149.199', 1790011341, -25800, 'None'),
(81, 13, '77.79.149.199', 1790011346, -25800, 'None'),
(82, 13, '77.79.149.199', 1790011354, -60800, 'None'),
(83, 13, '77.79.149.199', 1790011506, -20800, 'None'),
(84, 13, '77.79.149.199', 1790011509, -20800, 'None'),
(85, 13, '77.79.149.199', 1790011512, -20800, 'None'),
(86, 13, '77.79.149.199', 1790011553, -25000000, 'Покупка бизнеса'),
(87, 13, '77.79.149.199', 1790011561, -30800, 'None'),
(88, 13, '77.79.149.199', 1790011565, -30800, 'None'),
(89, 13, '77.79.149.199', 1790011576, -20800, 'None'),
(90, 13, '77.79.149.199', 1790011619, 17500000, '[BANK] Продажа бизнеса'),
(91, 13, '77.79.149.199', 1790011619, 0, 'Продажа бизнеса государству'),
(92, 13, '77.79.149.199', 1790011644, -20800, 'None');

-- --------------------------------------------------------

--
-- Структура таблицы `music_albums`
--

CREATE TABLE `music_albums` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `album_id` int(11) NOT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `objects`
--

CREATE TABLE `objects` (
  `id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `r_pos_x` float NOT NULL,
  `r_pos_y` float NOT NULL,
  `r_pos_z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `old_accessories`
--

CREATE TABLE `old_accessories` (
  `account_id` int(11) NOT NULL,
  `slot` tinyint(4) NOT NULL,
  `modelid` int(11) NOT NULL,
  `bone` tinyint(4) NOT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `scale_x` float DEFAULT NULL,
  `scale_y` float DEFAULT NULL,
  `scale_z` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `company` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `order_mchs`
--

CREATE TABLE `order_mchs` (
  `id` int(11) NOT NULL,
  `id_player` int(11) NOT NULL DEFAULT 0,
  `state` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `order_mchs`
--

INSERT INTO `order_mchs` (`id`, `id_player`, `state`) VALUES
(0, 0, 1),
(1, 0, 1),
(2, 0, 1),
(3, 0, 1),
(4, 0, 1),
(5, 0, 1),
(6, 0, 1),
(7, 0, 1),
(8, 0, 1),
(9, 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `org_warehouses`
--

CREATE TABLE `org_warehouses` (
  `org_id` int(11) NOT NULL,
  `opened` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `org_warehouses`
--

INSERT INTO `org_warehouses` (`org_id`, `opened`) VALUES
(1, 1),
(2, 1),
(5, 1),
(6, 1),
(7, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `ownable_cars`
--

CREATE TABLE `ownable_cars` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `comfort` int(11) NOT NULL,
  `sport` int(11) NOT NULL,
  `sport_plus` int(11) NOT NULL,
  `drift` int(11) NOT NULL,
  `wheels_kl` float NOT NULL,
  `wheels_size` float NOT NULL,
  `wheels_raz` int(11) NOT NULL,
  `wheels_otkl` float NOT NULL,
  `color_1` int(11) NOT NULL DEFAULT -1,
  `color_2` int(11) NOT NULL DEFAULT -1,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `angle` float NOT NULL,
  `number` varchar(32) NOT NULL DEFAULT 'none',
  `region` varchar(32) NOT NULL DEFAULT '--',
  `number_type` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL,
  `alarm` int(11) NOT NULL,
  `key_in` int(11) NOT NULL,
  `mileage` float NOT NULL,
  `create_time` int(11) NOT NULL,
  `promo_id` int(11) NOT NULL DEFAULT 0,
  `promo_status_car` tinyint(1) NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 1000,
  `vinilcar` int(11) NOT NULL,
  `pt_engine` int(11) NOT NULL,
  `pt_brake` int(11) NOT NULL,
  `pt_stability` int(11) NOT NULL,
  `nitro` int(11) NOT NULL,
  `launch` int(11) NOT NULL,
  `fars` int(11) NOT NULL,
  `diski` int(11) NOT NULL,
  `tuning_neon1` int(11) DEFAULT 0,
  `tuning_neon2` int(11) DEFAULT 0,
  `tuning_neon3` int(11) DEFAULT 0,
  `tuning_tint` tinyint(4) DEFAULT 0,
  `tuning_vinyl` tinyint(4) DEFAULT 0,
  `tuning_toner_front` int(11) DEFAULT 0,
  `tuning_toner_rear` int(11) DEFAULT 0,
  `tuning_toner_front_side` int(11) DEFAULT 0,
  `tuning_toner_rear_side` int(11) DEFAULT 0,
  `tuning_suspension_force` float DEFAULT 0,
  `tuning_suspension_bias` float DEFAULT 0,
  `tuning_wheel_size` float DEFAULT 0,
  `tuning_wheel_add_front` float DEFAULT 0,
  `tuning_wheel_add_rear` float DEFAULT 0,
  `tuning_hydraulics` tinyint(4) DEFAULT 0,
  `tuning_launch_control` tinyint(4) DEFAULT 0,
  `tuning_stroboscope` int(11) DEFAULT 0,
  `tuning_siren` tinyint(4) DEFAULT 0,
  `tuning_horn_sound` int(11) NOT NULL DEFAULT 0,
  `tuning_exhaust_sound` int(11) NOT NULL DEFAULT 0,
  `tuning_drift` tinyint(4) DEFAULT 0,
  `tuning_plate_type` tinyint(4) DEFAULT 0,
  `tuning_plate_number` varchar(8) DEFAULT '',
  `tuning_plate_region` varchar(3) DEFAULT '',
  `fuel` float NOT NULL DEFAULT 40,
  `firmware` int(11) NOT NULL DEFAULT 0,
  `neon_state` int(11) NOT NULL DEFAULT 0,
  `tuning_light_color` int(11) NOT NULL DEFAULT 0,
  `tuning_vinyl_texture` varchar(32) NOT NULL DEFAULT '',
  `pered_windcolor` int(11) NOT NULL DEFAULT 0,
  `zadni_windcolor` int(11) NOT NULL DEFAULT 0,
  `hydraulics_state` int(11) NOT NULL DEFAULT 0,
  `strob` int(11) NOT NULL DEFAULT 0,
  `strob_state` int(11) NOT NULL DEFAULT 0,
  `dalniysvet` int(11) NOT NULL DEFAULT 0,
  `dalniysvet_state` int(11) NOT NULL DEFAULT 0,
  `tint` int(11) NOT NULL DEFAULT 0,
  `offset_front` float NOT NULL DEFAULT 0,
  `offset_rear` float NOT NULL DEFAULT 0,
  `camber_front` float NOT NULL DEFAULT 0,
  `camber_rear` float NOT NULL DEFAULT 0,
  `tuning_pnevmo` int(11) NOT NULL DEFAULT 0,
  `tuning_wheel_departure_front` float NOT NULL DEFAULT 0,
  `tuning_wheel_departure_rear` float NOT NULL DEFAULT 0,
  `tuning_wheel_alignment_front` float NOT NULL DEFAULT 0,
  `tuning_wheel_alignment_rear` float NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `ownable_cars`
--

INSERT INTO `ownable_cars` (`id`, `owner_id`, `model_id`, `comfort`, `sport`, `sport_plus`, `drift`, `wheels_kl`, `wheels_size`, `wheels_raz`, `wheels_otkl`, `color_1`, `color_2`, `pos_x`, `pos_y`, `pos_z`, `angle`, `number`, `region`, `number_type`, `status`, `alarm`, `key_in`, `mileage`, `create_time`, `promo_id`, `promo_status_car`, `health`, `vinilcar`, `pt_engine`, `pt_brake`, `pt_stability`, `nitro`, `launch`, `fars`, `diski`, `tuning_neon1`, `tuning_neon2`, `tuning_neon3`, `tuning_tint`, `tuning_vinyl`, `tuning_toner_front`, `tuning_toner_rear`, `tuning_toner_front_side`, `tuning_toner_rear_side`, `tuning_suspension_force`, `tuning_suspension_bias`, `tuning_wheel_size`, `tuning_wheel_add_front`, `tuning_wheel_add_rear`, `tuning_hydraulics`, `tuning_launch_control`, `tuning_stroboscope`, `tuning_siren`, `tuning_horn_sound`, `tuning_exhaust_sound`, `tuning_drift`, `tuning_plate_type`, `tuning_plate_number`, `tuning_plate_region`, `fuel`, `firmware`, `neon_state`, `tuning_light_color`, `tuning_vinyl_texture`, `pered_windcolor`, `zadni_windcolor`, `hydraulics_state`, `strob`, `strob_state`, `dalniysvet`, `dalniysvet_state`, `tint`, `offset_front`, `offset_rear`, `camber_front`, `camber_rear`, `tuning_pnevmo`, `tuning_wheel_departure_front`, `tuning_wheel_departure_rear`, `tuning_wheel_alignment_front`, `tuning_wheel_alignment_rear`) VALUES
(1, 7, 500, 0, 0, 0, 0, 0, 0, 0, 0, 15, 15, 0, 0, 0, 0, '', '', 0, 0, 0, 0, 1.36167, 1788266919, 0, 0, 810, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 26.7501, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 7, 524, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 679.412, 2637.06, 12.597, 0, '', '', 0, 0, 0, 0, 0, 1788285523, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 40, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 7, 500, 0, 1, 54321, 0, 0, 0, 0, 0, 15, 15, -430.654, 995.74, 12.0428, 356.799, '', '', 0, 0, 0, 0, 1.38499, 1788285666, 0, 0, 740, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, -16777216, 0, -16777216, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 13.3003, 4, 0, 0, 'remapbody32', -16777216, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 8, 502, 0, 0, 54321, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 'none', '--', 0, 0, 0, 0, 2.86444, 1788853145, 0, 0, 1000, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, -16777216, 0, -16777216, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, '', '', 39.1, 4, 0, 0, '', -16777216, 0, 0, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 13, 632, 0, 0, 54321, 0, 0, 0, 0, 0, 15, 15, 658.857, 2665.41, 14.5011, 356.799, '', '', 0, 0, 0, 0, 2.34806, 1790011270, 0, 0, 760, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, -16777216, -16777216, -16777216, -16777216, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, '', '', 25.2502, 4, 0, 0, '', -16777216, -16777216, 0, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `sum` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `billID` text NOT NULL,
  `data_create` datetime NOT NULL,
  `data_accept` datetime NOT NULL DEFAULT current_timestamp(),
  `server_id` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `phone_books`
--

CREATE TABLE `phone_books` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `name` varchar(21) DEFAULT NULL,
  `number` varchar(9) DEFAULT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `player_cases`
--

CREATE TABLE `player_cases` (
  `user_id` int(11) NOT NULL,
  `bc_balance` int(11) NOT NULL DEFAULT 0,
  `dust` int(11) NOT NULL DEFAULT 0,
  `opened_count` int(11) NOT NULL DEFAULT 0,
  `selected_case` int(11) NOT NULL DEFAULT 1,
  `tutorial` tinyint(4) NOT NULL DEFAULT 0,
  `case_counts` text DEFAULT NULL,
  `bonus_status` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `player_cases`
--

INSERT INTO `player_cases` (`user_id`, `bc_balance`, `dust`, `opened_count`, `selected_case`, `tutorial`, `case_counts`, `bonus_status`) VALUES
(7, 961100, 230, 20, 11, 0, '0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0', '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'),
(8, 16312, 0, 0, 1, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'),
(9, 500, 0, 0, 1, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1');

-- --------------------------------------------------------

--
-- Структура таблицы `player_gpus`
--

CREATE TABLE `player_gpus` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `gpu_type` int(11) NOT NULL,
  `active` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `player_inventory`
--

CREATE TABLE `player_inventory` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `slot` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL DEFAULT 1,
  `item_plate` varchar(32) DEFAULT '',
  `is_active` tinyint(1) DEFAULT 0,
  `active_slot` int(11) DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `player_inventory`
--

INSERT INTO `player_inventory` (`id`, `player_id`, `slot`, `item_id`, `item_count`, `item_plate`, `is_active`, `active_slot`) VALUES
(50, 7, 0, 134, 6894, '', 0, -1),
(51, 7, 1, 915, 1, '', 0, -1),
(52, 7, 6, 134, 78, '', 1, 6),
(216, 12, 6, 134, 78, '', 1, 6),
(865, 8, 6, 134, 301, '', 1, 6),
(1256, 13, 0, 134, 78, '', 0, -1),
(1257, 13, 1, 511, 1, '', 0, -1),
(1258, 13, 6, 134, 266, '', 1, 6);

-- --------------------------------------------------------

--
-- Структура таблицы `player_promos`
--

CREATE TABLE `player_promos` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `promo_prize_sql_id` int(11) NOT NULL,
  `start_time` int(11) NOT NULL,
  `remaining_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `promocode`
--

CREATE TABLE `promocode` (
  `id` int(11) NOT NULL,
  `code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `type` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `usings` int(11) NOT NULL,
  `paydays` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `promocodes`
--

CREATE TABLE `promocodes` (
  `id` int(11) NOT NULL,
  `code` varchar(32) NOT NULL,
  `uses_limit` int(11) NOT NULL DEFAULT 1,
  `uses_left` int(11) NOT NULL DEFAULT 1,
  `num_prizes` tinyint(1) NOT NULL DEFAULT 1,
  `activations` int(11) NOT NULL DEFAULT 0,
  `promo_level` int(11) NOT NULL DEFAULT -1,
  `promo_balance` int(11) NOT NULL DEFAULT 0,
  `creator_account_id` int(11) NOT NULL DEFAULT 0,
  `creation_cost` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `promocode_activations`
--

CREATE TABLE `promocode_activations` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `code` varchar(32) NOT NULL,
  `paydays` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `promo_prizes`
--

CREATE TABLE `promo_prizes` (
  `id` int(11) NOT NULL,
  `promo_id` int(11) NOT NULL,
  `prize_index` tinyint(1) NOT NULL,
  `prize_type` tinyint(1) NOT NULL DEFAULT 0,
  `prize_value` int(11) NOT NULL DEFAULT 0,
  `prize_duration` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `quick_message`
--

CREATE TABLE `quick_message` (
  `name` varchar(64) NOT NULL,
  `text_1` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №1',
  `text_2` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №2',
  `text_3` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №3',
  `text_4` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №4',
  `text_5` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №5',
  `text_6` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №6',
  `text_7` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №7',
  `text_8` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №8',
  `text_9` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №9',
  `text_10` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №10',
  `text_11` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №11',
  `text_12` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №12',
  `text_13` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №13',
  `text_14` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №14',
  `text_15` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №15',
  `text_16` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №16',
  `text_17` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №17',
  `text_18` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №18',
  `text_19` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №19',
  `text_20` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- --------------------------------------------------------

--
-- Структура таблицы `repositories`
--

CREATE TABLE `repositories` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `action_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `description` varchar(64) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `repositories`
--

INSERT INTO `repositories` (`id`, `type`, `action_id`, `amount`, `description`) VALUES
(1, 0, 0, 0, 'Шахта, металл'),
(2, 0, 1, 0, 'Шахта, руда'),
(3, 1, 0, 147, 'Завод, металл'),
(4, 1, 1, 8091, 'Завод, топливо'),
(5, 1, 2, 59913, 'Завод, продукты'),
(6, 3, 0, 98340, 'Склад армии, металл'),
(7, 3, 1, 135811, 'Склад армии, патроны'),
(8, 4, 0, 2000, 'Лесопилка, дерево');

-- --------------------------------------------------------

--
-- Структура таблицы `return_money`
--

CREATE TABLE `return_money` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `description` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `return_money`
--

INSERT INTO `return_money` (`id`, `uid`, `money`, `description`, `status`) VALUES
(1, 7, 5000000, 'слет бизнеса', 0),
(2, 9, 250000, 'слет бизнеса', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `rewards`
--

CREATE TABLE `rewards` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL COMMENT 'ID игрока из таблицы аккаунтов',
  `award_id` int(11) NOT NULL COMMENT '??ндекс приза в массиве Case...Awards',
  `case_id` int(11) NOT NULL COMMENT 'ID кейса (1-5, 8)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `roulette_prize`
--

CREATE TABLE `roulette_prize` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `prize` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `server_settings`
--

CREATE TABLE `server_settings` (
  `admin_price` int(11) NOT NULL DEFAULT 80,
  `helper_price` int(11) NOT NULL DEFAULT 40,
  `distrub` int(11) NOT NULL DEFAULT 1,
  `donpower` int(11) NOT NULL DEFAULT 1,
  `GiveCoins` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `smi_staff`
--

CREATE TABLE `smi_staff` (
  `account_id` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `smi_staff`
--

INSERT INTO `smi_staff` (`account_id`, `level`) VALUES
(8, 0),
(10, 0),
(11, 0),
(12, 0),
(13, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `summer_drive`
--

CREATE TABLE `summer_drive` (
  `account_id` int(11) NOT NULL,
  `last_claim` int(11) NOT NULL DEFAULT 0,
  `claimed_days` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `summer_drive`
--

INSERT INTO `summer_drive` (`account_id`, `last_claim`, `claimed_days`) VALUES
(8, 0, 0),
(10, 0, 0),
(12, 0, 0),
(13, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `tc_companies`
--

CREATE TABLE `tc_companies` (
  `id` int(11) NOT NULL,
  `office` tinyint(4) NOT NULL DEFAULT 0,
  `slot` tinyint(4) NOT NULL DEFAULT 0,
  `name` varchar(48) NOT NULL DEFAULT '',
  `owner_id` int(11) NOT NULL DEFAULT -1,
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `commission` tinyint(4) NOT NULL DEFAULT 10,
  `last_rename` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL DEFAULT 0,
  `upgrade_office` tinyint(4) NOT NULL DEFAULT 0,
  `upgrade_garage` tinyint(4) NOT NULL DEFAULT 0,
  `upgrade_licenses` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `tc_companies`
--

INSERT INTO `tc_companies` (`id`, `office`, `slot`, `name`, `owner_id`, `balance`, `commission`, `last_rename`, `created_at`, `upgrade_office`, `upgrade_garage`, `upgrade_licenses`) VALUES
(1, 0, 0, 'N1', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(2, 0, 1, 'N2', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(3, 0, 2, 'N3', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(4, 0, 3, 'N4', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(5, 0, 4, 'N5', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(6, 0, 5, 'N6', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(7, 0, 6, 'N7', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(8, 0, 7, 'N8', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(9, 0, 8, 'N9', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(10, 0, 9, 'N10', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(11, 0, 10, 'N11', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(12, 0, 11, 'N12', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(13, 1, 0, 'N13', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(14, 1, 1, 'N14', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(15, 1, 2, 'N15', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(16, 1, 3, 'N16', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(17, 1, 4, 'N17', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(18, 1, 5, 'N18', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(19, 1, 6, 'N19', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(20, 1, 7, 'N20', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(21, 1, 8, 'N21', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(22, 1, 9, 'N22', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(23, 1, 10, 'N23', -1, 0, 10, 0, 1789935237, 0, 0, 0),
(24, 1, 11, 'N24', -1, 0, 10, 0, 1789935237, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `tc_employees`
--

CREATE TABLE `tc_employees` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `hired_at` int(11) NOT NULL DEFAULT 0,
  `orders_done` int(11) NOT NULL DEFAULT 0,
  `earned` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tc_finance`
--

CREATE TABLE `tc_finance` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT 0,
  `amount` bigint(20) NOT NULL DEFAULT 0,
  `note` varchar(64) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tc_fleet`
--

CREATE TABLE `tc_fleet` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL DEFAULT 403,
  `name` varchar(32) NOT NULL DEFAULT '',
  `rent_price` int(11) NOT NULL DEFAULT 1000,
  `trips_left` int(11) NOT NULL DEFAULT 50,
  `trips_max` int(11) NOT NULL DEFAULT 50,
  `broken` tinyint(4) NOT NULL DEFAULT 0,
  `rented_account_id` int(11) NOT NULL DEFAULT -1,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tc_orders`
--

CREATE TABLE `tc_orders` (
  `id` int(11) NOT NULL,
  `office` tinyint(4) NOT NULL DEFAULT 0,
  `type` tinyint(4) NOT NULL DEFAULT 0,
  `from_point` tinyint(4) NOT NULL DEFAULT 0,
  `to_point` tinyint(4) NOT NULL DEFAULT 0,
  `business_id` int(11) NOT NULL DEFAULT -1,
  `amount` int(11) NOT NULL DEFAULT 0,
  `total_pay` int(11) NOT NULL DEFAULT 0,
  `min_rating` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `taken_by` int(11) NOT NULL DEFAULT -1,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `description` varchar(64) NOT NULL,
  `issuer` varchar(32) NOT NULL,
  `status` int(11) NOT NULL,
  `issued_at` int(11) NOT NULL DEFAULT 0,
  `expire_at` int(11) NOT NULL DEFAULT 0,
  `auto_penalty` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `tickets`
--

INSERT INTO `tickets` (`id`, `uid`, `amount`, `description`, `issuer`, `status`, `issued_at`, `expire_at`, `auto_penalty`) VALUES
(1, 13, 150000, 'Проезд на красный свет, скорость 157 км/ч', 'Система ГИБДД', 0, 1790011390, 1790097790, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `traffic_lights`
--

CREATE TABLE `traffic_lights` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `transport_companies`
--

CREATE TABLE `transport_companies` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `locality` int(11) NOT NULL,
  `owner_account` int(11) NOT NULL DEFAULT -1,
  `owner_name` varchar(24) NOT NULL DEFAULT 'Государство',
  `balance` int(11) NOT NULL DEFAULT 0,
  `payout_percent` int(11) NOT NULL DEFAULT 85,
  `level` int(11) NOT NULL DEFAULT 1,
  `reputation` int(11) NOT NULL DEFAULT 0,
  `completed_orders` int(11) NOT NULL DEFAULT 0,
  `fleet_count` int(11) NOT NULL DEFAULT 3,
  `fleet_capacity` int(11) NOT NULL DEFAULT 5,
  `max_members` int(11) NOT NULL DEFAULT 10,
  `auction_active` tinyint(4) NOT NULL DEFAULT 1,
  `auction_start_price` int(11) NOT NULL DEFAULT 15000000,
  `auction_current_bid` int(11) NOT NULL DEFAULT 15000000,
  `auction_bidder_account` int(11) NOT NULL DEFAULT -1,
  `auction_bidder_name` varchar(24) NOT NULL DEFAULT '-',
  `auction_end` int(11) NOT NULL DEFAULT 0,
  `auction_listed_by` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `transport_companies`
--

INSERT INTO `transport_companies` (`id`, `name`, `locality`, `owner_account`, `owner_name`, `balance`, `payout_percent`, `level`, `reputation`, `completed_orders`, `fleet_count`, `fleet_capacity`, `max_members`, `auction_active`, `auction_start_price`, `auction_current_bid`, `auction_bidder_account`, `auction_bidder_name`, `auction_end`, `auction_listed_by`) VALUES
(0, 'Батырево Транс', 1, -1, 'Государство', 0, 85, 1, 0, 0, 3, 5, 10, 1, 15000000, 15000000, -1, '-', 1790092211, -1),
(1, 'Бусаево Логистик', 2, -1, 'Государство', 0, 85, 1, 0, 0, 3, 5, 10, 1, 18000000, 18000000, -1, '-', 1790092211, -1);

-- --------------------------------------------------------

--
-- Структура таблицы `transport_company_applications`
--

CREATE TABLE `transport_company_applications` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `player_name` varchar(24) NOT NULL,
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `transport_company_members`
--

CREATE TABLE `transport_company_members` (
  `account_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `player_name` varchar(24) NOT NULL,
  `rank` int(11) NOT NULL DEFAULT 1,
  `deliveries` int(11) NOT NULL DEFAULT 0,
  `earned` int(11) NOT NULL DEFAULT 0,
  `joined_at` int(11) NOT NULL,
  `last_online` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `transport_company_transactions`
--

CREATE TABLE `transport_company_transactions` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `player_name` varchar(24) NOT NULL DEFAULT '-',
  `amount` int(11) NOT NULL,
  `action` varchar(64) NOT NULL,
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `trucking_company`
--

CREATE TABLE `trucking_company` (
  `id` int(11) NOT NULL,
  `owner` varchar(24) NOT NULL DEFAULT 'None',
  `balance` int(11) NOT NULL DEFAULT 0,
  `overdue` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `trucking_company`
--

INSERT INTO `trucking_company` (`id`, `owner`, `balance`, `overdue`) VALUES
(1, 'None', 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `trunks`
--

CREATE TABLE `trunks` (
  `id` int(11) NOT NULL,
  `oc_id` int(11) NOT NULL COMMENT 'ID транспорта из ownable_cars',
  `slot` int(11) NOT NULL DEFAULT 0 COMMENT 'Слот багажника',
  `item_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ID предмета',
  `amount` int(11) NOT NULL DEFAULT 1 COMMENT 'Количество предмета',
  `item_type` int(11) NOT NULL DEFAULT 0 COMMENT 'Тип предмета',
  `item_plate` varchar(32) NOT NULL DEFAULT '' COMMENT 'Номер машины'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `unitpay_payments`
--

CREATE TABLE `unitpay_payments` (
  `id` int(11) NOT NULL,
  `unitpayId` varchar(255) NOT NULL,
  `account` varchar(255) NOT NULL,
  `sum` float NOT NULL,
  `itemsCount` int(11) NOT NULL DEFAULT 1,
  `dateCreate` datetime NOT NULL,
  `dateComplete` datetime DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `vehicle_pneumo_data`
--

CREATE TABLE `vehicle_pneumo_data` (
  `vehicleid` int(11) NOT NULL,
  `bought` int(11) NOT NULL DEFAULT 0,
  `mode` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `vehicle_pneumo_data`
--

INSERT INTO `vehicle_pneumo_data` (`vehicleid`, `bought`, `mode`) VALUES
(4, 0, 0),
(5, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `vehicle_store_components`
--

CREATE TABLE `vehicle_store_components` (
  `vehicleid` int(11) NOT NULL,
  `componentid` int(11) NOT NULL,
  `state` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `vehicle_store_components`
--

INSERT INTO `vehicle_store_components` (`vehicleid`, `componentid`, `state`) VALUES
(5, 1273, 2),
(5, 1274, 0),
(5, 1275, 2),
(5, 1276, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `vehicle_tuning_data`
--

CREATE TABLE `vehicle_tuning_data` (
  `vehicleid` int(11) NOT NULL,
  `color_1` int(11) NOT NULL DEFAULT 0,
  `color_2` int(11) NOT NULL DEFAULT 0,
  `neon1` int(11) NOT NULL DEFAULT 0,
  `neon2` int(11) NOT NULL DEFAULT 0,
  `neon3` int(11) NOT NULL DEFAULT 0,
  `neon_state` int(11) NOT NULL DEFAULT 0,
  `tint` int(11) NOT NULL DEFAULT 0,
  `light_color` int(11) NOT NULL DEFAULT 0,
  `vinyl` int(11) NOT NULL DEFAULT 0,
  `vinyl_texture` varchar(32) NOT NULL DEFAULT '',
  `toner_front` int(11) NOT NULL DEFAULT 0,
  `toner_rear` int(11) NOT NULL DEFAULT 0,
  `toner_front_side` int(11) NOT NULL DEFAULT 0,
  `toner_rear_side` int(11) NOT NULL DEFAULT 0,
  `suspension_force` float NOT NULL DEFAULT 0,
  `suspension_bias` float NOT NULL DEFAULT 0,
  `wheel_size` float NOT NULL DEFAULT 0,
  `wheel_add_front` float NOT NULL DEFAULT 0,
  `wheel_add_rear` float NOT NULL DEFAULT 0,
  `wheel_alignment_front` float NOT NULL DEFAULT 0,
  `wheel_alignment_rear` float NOT NULL DEFAULT 0,
  `wheel_departure_front` float NOT NULL DEFAULT 0,
  `wheel_departure_rear` float NOT NULL DEFAULT 0,
  `wheel_width_front` float NOT NULL DEFAULT 0,
  `wheel_width_rear` float NOT NULL DEFAULT 0,
  `clearance` int(11) NOT NULL DEFAULT 0,
  `separate_clearance` int(11) NOT NULL DEFAULT 0,
  `wheel_radius` int(11) NOT NULL DEFAULT 0,
  `hydraulics` int(11) NOT NULL DEFAULT 0,
  `hydraulics_state` int(11) NOT NULL DEFAULT 0,
  `launch_control` int(11) NOT NULL DEFAULT 0,
  `stroboscope` int(11) NOT NULL DEFAULT 0,
  `strob_state` int(11) NOT NULL DEFAULT 0,
  `high_lights` int(11) NOT NULL DEFAULT 0,
  `high_lights_state` int(11) NOT NULL DEFAULT 0,
  `drift` int(11) NOT NULL DEFAULT 0,
  `firmware` int(11) NOT NULL DEFAULT 0,
  `siren` int(11) NOT NULL DEFAULT 0,
  `horn_sound` int(11) NOT NULL DEFAULT 0,
  `exhaust_sound` int(11) NOT NULL DEFAULT 0,
  `plate_type` int(11) NOT NULL DEFAULT 0,
  `plate_number` varchar(16) NOT NULL DEFAULT '',
  `plate_region` varchar(8) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `vehicle_tuning_data`
--

INSERT INTO `vehicle_tuning_data` (`vehicleid`, `color_1`, `color_2`, `neon1`, `neon2`, `neon3`, `neon_state`, `tint`, `light_color`, `vinyl`, `vinyl_texture`, `toner_front`, `toner_rear`, `toner_front_side`, `toner_rear_side`, `suspension_force`, `suspension_bias`, `wheel_size`, `wheel_add_front`, `wheel_add_rear`, `wheel_alignment_front`, `wheel_alignment_rear`, `wheel_departure_front`, `wheel_departure_rear`, `wheel_width_front`, `wheel_width_rear`, `clearance`, `separate_clearance`, `wheel_radius`, `hydraulics`, `hydraulics_state`, `launch_control`, `stroboscope`, `strob_state`, `high_lights`, `high_lights_state`, `drift`, `firmware`, `siren`, `horn_sound`, `exhaust_sound`, `plate_type`, `plate_number`, `plate_region`) VALUES
(4, 4, 4, 0, 0, 0, 0, 0, 0, 0, '', -16777216, 0, -16777216, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 0, 0, 0, 4, 0, 0, 0, 0, '', ''),
(5, -2650608, 15, 0, 0, 0, 0, 0, 0, 0, '', -16777216, -16777216, -16777216, -16777216, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 0, 0, 0, 4, 0, 0, 0, 0, '', '');

-- --------------------------------------------------------

--
-- Структура таблицы `whitelist`
--

CREATE TABLE `whitelist` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `ytpromocode`
--

CREATE TABLE `ytpromocode` (
  `id` int(11) NOT NULL,
  `code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `type` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `usings` int(11) NOT NULL,
  `paydays` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `accessories`
--
ALTER TABLE `accessories`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `accessories_players`
--
ALTER TABLE `accessories_players`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `accessory_inventory`
--
ALTER TABLE `accessory_inventory`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`),
  ADD KEY `phone` (`phone`),
  ADD KEY `house` (`house`),
  ADD KEY `name` (`name`) USING BTREE;

--
-- Индексы таблицы `aclogs`
--
ALTER TABLE `aclogs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `action_log`
--
ALTER TABLE `action_log`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `activated_promos`
--
ALTER TABLE `activated_promos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_promo` (`account_id`,`promo_id`);

--
-- Индексы таблицы `admin_stats_online`
--
ALTER TABLE `admin_stats_online`
  ADD PRIMARY KEY (`account_id`,`stat_date`),
  ADD KEY `idx_stat_date` (`stat_date`);

--
-- Индексы таблицы `allowed_servers`
--
ALTER TABLE `allowed_servers`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `auction_bids`
--
ALTER TABLE `auction_bids`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_auction_id` (`auction_id`);

--
-- Индексы таблицы `auction_history`
--
ALTER TABLE `auction_history`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `auction_lots`
--
ALTER TABLE `auction_lots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status_ends` (`status`,`ends_at`),
  ADD KEY `idx_item` (`item_type`,`item_database_id`);

--
-- Индексы таблицы `auction_pending_items`
--
ALTER TABLE `auction_pending_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_auction_pending_account` (`account_id`);

--
-- Индексы таблицы `auction_pending_money`
--
ALTER TABLE `auction_pending_money`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_auction_money_account` (`account_id`);

--
-- Индексы таблицы `auction_slots`
--
ALTER TABLE `auction_slots`
  ADD PRIMARY KEY (`slot_id`),
  ADD KEY `idx_auction_owner` (`owner_account`),
  ADD KEY `idx_auction_bidder` (`bidder_account`),
  ADD KEY `idx_auction_end` (`timer_end`);

--
-- Индексы таблицы `autosalon`
--
ALTER TABLE `autosalon`
  ADD PRIMARY KEY (`market_id`,`model_id`);

--
-- Индексы таблицы `bank_accounts`
--
ALTER TABLE `bank_accounts`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `bank_accounts_log`
--
ALTER TABLE `bank_accounts_log`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ban_list`
--
ALTER TABLE `ban_list`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `blackpass_logs`
--
ALTER TABLE `blackpass_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_blackpass_logs_player` (`account_id`,`season_number`),
  ADD KEY `idx_blackpass_logs_action` (`action`);

--
-- Индексы таблицы `blackpass_players`
--
ALTER TABLE `blackpass_players`
  ADD PRIMARY KEY (`account_id`,`season_number`),
  ADD KEY `idx_blackpass_players_season` (`season_number`);

--
-- Индексы таблицы `blackpass_tasks`
--
ALTER TABLE `blackpass_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_blackpass_tasks_player` (`account_id`,`season_number`,`task_group`,`period_key`);

--
-- Индексы таблицы `black_pass`
--
ALTER TABLE `black_pass`
  ADD PRIMARY KEY (`user_id`);

--
-- Индексы таблицы `black_pass_top`
--
ALTER TABLE `black_pass_top`
  ADD PRIMARY KEY (`user_id`);

--
-- Индексы таблицы `bpr_user_rewards`
--
ALTER TABLE `bpr_user_rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `is_taken` (`is_taken`);

--
-- Индексы таблицы `bp_reward_sync`
--
ALTER TABLE `bp_reward_sync`
  ADD PRIMARY KEY (`user_id`,`level`,`premium`);

--
-- Индексы таблицы `business`
--
ALTER TABLE `business`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `business_gps`
--
ALTER TABLE `business_gps`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `business_profit`
--
ALTER TABLE `business_profit`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `calendar_event_state`
--
ALTER TABLE `calendar_event_state`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `calendar_user_bonus`
--
ALTER TABLE `calendar_user_bonus`
  ADD PRIMARY KEY (`account_id`,`season_version`,`bonus_id`),
  ADD KEY `idx_calendar_bonus_season` (`season_version`,`bonus_id`);

--
-- Индексы таблицы `calendar_user_progress`
--
ALTER TABLE `calendar_user_progress`
  ADD PRIMARY KEY (`account_id`,`season_version`,`day_number`),
  ADD KEY `idx_calendar_progress_season` (`season_version`,`day_number`);

--
-- Индексы таблицы `calendar_user_state`
--
ALTER TABLE `calendar_user_state`
  ADD PRIMARY KEY (`account_id`,`season_version`),
  ADD KEY `idx_calendar_state_season` (`season_version`,`claimed_count`);

--
-- Индексы таблицы `car_obmen`
--
ALTER TABLE `car_obmen`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `change_names`
--
ALTER TABLE `change_names`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `charity`
--
ALTER TABLE `charity`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `debug`
--
ALTER TABLE `debug`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `donate_log`
--
ALTER TABLE `donate_log`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `family`
--
ALTER TABLE `family`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `familyblack`
--
ALTER TABLE `familyblack`
  ADD PRIMARY KEY (`family_id`,`account_id`),
  ADD KEY `idx_familyblack_account_id` (`account_id`);

--
-- Индексы таблицы `familysystem`
--
ALTER TABLE `familysystem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_family_ownable` (`family_id`,`ownable_car_id`),
  ADD KEY `idx_family` (`family_id`),
  ADD KEY `idx_owner` (`owner_id`),
  ADD KEY `idx_ownable` (`ownable_car_id`);

--
-- Индексы таблицы `family_ad`
--
ALTER TABLE `family_ad`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `family_cars`
--
ALTER TABLE `family_cars`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `family_log`
--
ALTER TABLE `family_log`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `fuel_stations`
--
ALTER TABLE `fuel_stations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `fuel_stations_profit`
--
ALTER TABLE `fuel_stations_profit`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `full_dostup`
--
ALTER TABLE `full_dostup`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gang_repositories`
--
ALTER TABLE `gang_repositories`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gang_zones`
--
ALTER TABLE `gang_zones`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `garages`
--
ALTER TABLE `garages`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gift`
--
ALTER TABLE `gift`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gift_lose`
--
ALTER TABLE `gift_lose`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `hotels`
--
ALTER TABLE `hotels`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `houses_renters`
--
ALTER TABLE `houses_renters`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `house_storage`
--
ALTER TABLE `house_storage`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `items_data`
--
ALTER TABLE `items_data`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `leaders`
--
ALTER TABLE `leaders`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `marketplace_favorites`
--
ALTER TABLE `marketplace_favorites`
  ADD PRIMARY KEY (`account_id`,`lot_id`),
  ADD KEY `lot_id` (`lot_id`);

--
-- Индексы таблицы `marketplace_history`
--
ALTER TABLE `marketplace_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `lot_id` (`lot_id`);

--
-- Индексы таблицы `marketplace_items`
--
ALTER TABLE `marketplace_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`),
  ADD KEY `seller_id` (`seller_id`),
  ADD KEY `buyer_id` (`buyer_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `price` (`price`),
  ADD KEY `created_at` (`created_at`);

--
-- Индексы таблицы `marketplace_likes`
--
ALTER TABLE `marketplace_likes`
  ADD PRIMARY KEY (`player_id`,`listing_id`),
  ADD KEY `listing_id` (`listing_id`);

--
-- Индексы таблицы `marketplace_lots`
--
ALTER TABLE `marketplace_lots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `seller_id` (`seller_id`),
  ADD KEY `status` (`status`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `expires_at` (`expires_at`);

--
-- Индексы таблицы `marketplace_reward_items`
--
ALTER TABLE `marketplace_reward_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `source_lot` (`source_lot`);

--
-- Индексы таблицы `marketplace_wallet`
--
ALTER TABLE `marketplace_wallet`
  ADD PRIMARY KEY (`account_id`);

--
-- Индексы таблицы `mhcwork`
--
ALTER TABLE `mhcwork`
  ADD PRIMARY KEY (`account_id`);

--
-- Индексы таблицы `money_log`
--
ALTER TABLE `money_log`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `music_albums`
--
ALTER TABLE `music_albums`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uid_album` (`uid`,`album_id`);

--
-- Индексы таблицы `objects`
--
ALTER TABLE `objects`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `old_accessories`
--
ALTER TABLE `old_accessories`
  ADD PRIMARY KEY (`account_id`,`slot`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `order_mchs`
--
ALTER TABLE `order_mchs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `org_warehouses`
--
ALTER TABLE `org_warehouses`
  ADD PRIMARY KEY (`org_id`);

--
-- Индексы таблицы `ownable_cars`
--
ALTER TABLE `ownable_cars`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `phone_books`
--
ALTER TABLE `phone_books`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `player_cases`
--
ALTER TABLE `player_cases`
  ADD PRIMARY KEY (`user_id`);

--
-- Индексы таблицы `player_gpus`
--
ALTER TABLE `player_gpus`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `player_inventory`
--
ALTER TABLE `player_inventory`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `player_promos`
--
ALTER TABLE `player_promos`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promocode`
--
ALTER TABLE `promocode`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promocodes`
--
ALTER TABLE `promocodes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promocode_activations`
--
ALTER TABLE `promocode_activations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promo_prizes`
--
ALTER TABLE `promo_prizes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `quick_message`
--
ALTER TABLE `quick_message`
  ADD PRIMARY KEY (`name`);

--
-- Индексы таблицы `repositories`
--
ALTER TABLE `repositories`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `return_money`
--
ALTER TABLE `return_money`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `rewards`
--
ALTER TABLE `rewards`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `roulette_prize`
--
ALTER TABLE `roulette_prize`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `smi_staff`
--
ALTER TABLE `smi_staff`
  ADD PRIMARY KEY (`account_id`);

--
-- Индексы таблицы `summer_drive`
--
ALTER TABLE `summer_drive`
  ADD PRIMARY KEY (`account_id`);

--
-- Индексы таблицы `tc_companies`
--
ALTER TABLE `tc_companies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `office_slot` (`office`,`slot`);

--
-- Индексы таблицы `tc_employees`
--
ALTER TABLE `tc_employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `company_account` (`company_id`,`account_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Индексы таблицы `tc_finance`
--
ALTER TABLE `tc_finance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`);

--
-- Индексы таблицы `tc_fleet`
--
ALTER TABLE `tc_fleet`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`);

--
-- Индексы таблицы `tc_orders`
--
ALTER TABLE `tc_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `business_id` (`business_id`),
  ADD KEY `status` (`status`);

--
-- Индексы таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `traffic_lights`
--
ALTER TABLE `traffic_lights`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `transport_companies`
--
ALTER TABLE `transport_companies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tc_owner` (`owner_account`),
  ADD KEY `idx_tc_auction` (`auction_active`,`auction_end`);

--
-- Индексы таблицы `transport_company_applications`
--
ALTER TABLE `transport_company_applications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_tc_application` (`company_id`,`account_id`),
  ADD KEY `idx_tc_app_company` (`company_id`);

--
-- Индексы таблицы `transport_company_members`
--
ALTER TABLE `transport_company_members`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `idx_tc_members_company` (`company_id`,`rank`);

--
-- Индексы таблицы `transport_company_transactions`
--
ALTER TABLE `transport_company_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tc_transactions` (`company_id`,`created_at`);

--
-- Индексы таблицы `trucking_company`
--
ALTER TABLE `trucking_company`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `trunks`
--
ALTER TABLE `trunks`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `vehicle_pneumo_data`
--
ALTER TABLE `vehicle_pneumo_data`
  ADD PRIMARY KEY (`vehicleid`);

--
-- Индексы таблицы `vehicle_store_components`
--
ALTER TABLE `vehicle_store_components`
  ADD PRIMARY KEY (`vehicleid`,`componentid`);

--
-- Индексы таблицы `vehicle_tuning_data`
--
ALTER TABLE `vehicle_tuning_data`
  ADD PRIMARY KEY (`vehicleid`);

--
-- Индексы таблицы `whitelist`
--
ALTER TABLE `whitelist`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ytpromocode`
--
ALTER TABLE `ytpromocode`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `accessories`
--
ALTER TABLE `accessories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `accessories_players`
--
ALTER TABLE `accessories_players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `accessory_inventory`
--
ALTER TABLE `accessory_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `aclogs`
--
ALTER TABLE `aclogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `action_log`
--
ALTER TABLE `action_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT для таблицы `activated_promos`
--
ALTER TABLE `activated_promos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `allowed_servers`
--
ALTER TABLE `allowed_servers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `auction_bids`
--
ALTER TABLE `auction_bids`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `auction_history`
--
ALTER TABLE `auction_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `auction_lots`
--
ALTER TABLE `auction_lots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT для таблицы `auction_pending_items`
--
ALTER TABLE `auction_pending_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `auction_pending_money`
--
ALTER TABLE `auction_pending_money`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `bank_accounts_log`
--
ALTER TABLE `bank_accounts_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `ban_list`
--
ALTER TABLE `ban_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `blackpass_logs`
--
ALTER TABLE `blackpass_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `blackpass_tasks`
--
ALTER TABLE `blackpass_tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT для таблицы `bpr_user_rewards`
--
ALTER TABLE `bpr_user_rewards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `business`
--
ALTER TABLE `business`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=166;

--
-- AUTO_INCREMENT для таблицы `business_gps`
--
ALTER TABLE `business_gps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `business_profit`
--
ALTER TABLE `business_profit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `car_obmen`
--
ALTER TABLE `car_obmen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `change_names`
--
ALTER TABLE `change_names`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `charity`
--
ALTER TABLE `charity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `debug`
--
ALTER TABLE `debug`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `donate_log`
--
ALTER TABLE `donate_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT для таблицы `family`
--
ALTER TABLE `family`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `familysystem`
--
ALTER TABLE `familysystem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `family_ad`
--
ALTER TABLE `family_ad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `family_cars`
--
ALTER TABLE `family_cars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `family_log`
--
ALTER TABLE `family_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `fuel_stations`
--
ALTER TABLE `fuel_stations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT для таблицы `fuel_stations_profit`
--
ALTER TABLE `fuel_stations_profit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `full_dostup`
--
ALTER TABLE `full_dostup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `gang_repositories`
--
ALTER TABLE `gang_repositories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `gang_zones`
--
ALTER TABLE `gang_zones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `garages`
--
ALTER TABLE `garages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT для таблицы `gates`
--
ALTER TABLE `gates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT для таблицы `gift`
--
ALTER TABLE `gift`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `gift_lose`
--
ALTER TABLE `gift_lose`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `hotels`
--
ALTER TABLE `hotels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=924;

--
-- AUTO_INCREMENT для таблицы `houses_renters`
--
ALTER TABLE `houses_renters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `house_storage`
--
ALTER TABLE `house_storage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `items_data`
--
ALTER TABLE `items_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `leaders`
--
ALTER TABLE `leaders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `marketplace_history`
--
ALTER TABLE `marketplace_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `marketplace_items`
--
ALTER TABLE `marketplace_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `marketplace_lots`
--
ALTER TABLE `marketplace_lots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `marketplace_reward_items`
--
ALTER TABLE `marketplace_reward_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `money_log`
--
ALTER TABLE `money_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT для таблицы `music_albums`
--
ALTER TABLE `music_albums`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `objects`
--
ALTER TABLE `objects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `ownable_cars`
--
ALTER TABLE `ownable_cars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `phone_books`
--
ALTER TABLE `phone_books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `player_gpus`
--
ALTER TABLE `player_gpus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `player_inventory`
--
ALTER TABLE `player_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1259;

--
-- AUTO_INCREMENT для таблицы `player_promos`
--
ALTER TABLE `player_promos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `promocode`
--
ALTER TABLE `promocode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `promocodes`
--
ALTER TABLE `promocodes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `promocode_activations`
--
ALTER TABLE `promocode_activations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `promo_prizes`
--
ALTER TABLE `promo_prizes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `repositories`
--
ALTER TABLE `repositories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `return_money`
--
ALTER TABLE `return_money`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `rewards`
--
ALTER TABLE `rewards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `roulette_prize`
--
ALTER TABLE `roulette_prize`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tc_companies`
--
ALTER TABLE `tc_companies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT для таблицы `tc_employees`
--
ALTER TABLE `tc_employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tc_finance`
--
ALTER TABLE `tc_finance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tc_fleet`
--
ALTER TABLE `tc_fleet`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tc_orders`
--
ALTER TABLE `tc_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `traffic_lights`
--
ALTER TABLE `traffic_lights`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `transport_company_applications`
--
ALTER TABLE `transport_company_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `transport_company_transactions`
--
ALTER TABLE `transport_company_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `trucking_company`
--
ALTER TABLE `trucking_company`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `trunks`
--
ALTER TABLE `trunks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `whitelist`
--
ALTER TABLE `whitelist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `ytpromocode`
--
ALTER TABLE `ytpromocode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
