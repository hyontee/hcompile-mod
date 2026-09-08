-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Май 07 2026 г., 00:14
-- Версия сервера: 10.11.14-MariaDB-0+deb12u2-log
-- Версия PHP: 8.2.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `user41260`
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
  `fam_token` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `salt`, `email`, `confirm_email`, `level`, `weekly_prizes`, `weekly_day`, `exp`, `refer`, `sex`, `skin`, `money`, `roulette_auto`, `roulette_silver`, `roulette_gold`, `satiety`, `roulette_bronz`, `bank`, `admin`, `post`, `family_id`, `family_rang`, `family_mute`, `family_access`, `a_secret`, `prefix`, `a_3d_prefix`, `admin_warn`, `AdminPass`, `driving_lic`, `weapon_lic`, `suspect`, `phone`, `phone_balance`, `phone_color`, `law_abiding`, `improvements`, `power`, `drugs`, `ammo`, `metall`, `wife`, `team`, `subdivison`, `wage`, `job`, `progress_company`, `t_company`, `tc_owner`, `house_type`, `house_room`, `house`, `business`, `fuel_st`, `reg_time`, `reg_ip`, `last_ip`, `last_login`, `game_for_hour`, `game_for_day`, `game_for_day_prev`, `setting_phone`, `setting_pin_code`, `request_phone`, `request_pin`, `setting1`, `setting2`, `setting4`, `setting5`, `setting6`, `warn`, `warn_time`, `mute`, `skill_colt`, `skill_sdpistol`, `skill_deagle`, `skill_shotgun`, `skill_mp5`, `skill_ak47`, `skill_m4`, `skill_sniper_rifle`, `skill_sawnoff`, `skill_combat_sg`, `skill_micro_uzi`, `donate_current`, `donate_total`, `org_skin`, `setting_spawn`, `hospital`, `health`, `car_slots`, `jail`, `premium`, `premium_date`, `rub`, `player`, `gifts`, `cmdaccess`, `family`, `family_rank`, `test`, `quest_1`, `quest_2`, `quest_3`, `quest_4`, `quest_5`, `quest_6`, `quest_7`, `quest_8`, `quest_exp_1`, `quest_exp_2`, `quest_exp_3`, `quest_exp_4`, `quest_exp_5`, `quest_exp_6`, `quest_exp_7`, `quest_exp_8`, `youtube`, `AntiBh`, `get_adm_status`, `get_adm_hour`, `online`, `totalhour`, `quest231`, `quest232`, `quest233`, `postcard`, `repcarid`, `helper`, `healme`, `QuestBox1`, `QuestBox2`, `QuestBox3`, `QuestBox4`, `QuestBox5`, `QuestBox6`, `repair`, `fmute`, `fwarn`, `owarn`, `dmz_kills`, `Progress1`, `Progress2`, `Progress3`, `Progress4`, `Progress5`, `Progress6`, `ProgressExp1`, `ProgressExp2`, `ProgressExp3`, `ProgressExp4`, `ProgressExp5`, `ProgressExp6`, `capt_kills`, `coins`, `ytpromo_activate`, `3d_prefix`, `loader_skill`, `premium_time`, `antisliv`, `QuestBox`, `flower1`, `flower2`, `flower3`, `TakeFlower`, `CongratulateWomen`, `BuyPerfume`, `GivePerfume`, `BuyCake`, `BuyProducts`, `BuyCandle`, `EndQuest8marta`, `score`, `case`, `online_today`, `golod`, `garage`, `bitcoin`, `mining_rig`, `mining_status`, `work_day`, `counttodaycases`, `countbomjcases`, `countstancases`, `countcarcases`, `countosobcases`, `countdopcases1`, `last_x`, `last_y`, `last_z`, `last_a`, `fam_token`) VALUES
(1, 'Danya_Coder', 'B6503FA3F69BFD8B15988A67F571491DBF266E46AEBD072F91C5BA30EDB33668', 'gbP_tqD:[J', 'None', 0, 25, '0,0,0,0,0,0,0', 0, 0, 0, 0, 28, 963460801, 0, 0, 0, 100, 0, 18062000, 13, 0, 3, 5, 0, '1,1,1,1,1,1,1', 0, '[A]', 0, 0, 3333, 2, 1, 0, 7777, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775427818, '31.222.204.60', '95.25.42.10', 1778111036, 1135, 1270, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 0, 0, 1, 0, 0, 13, 0, 0, 0, 35265, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 40, 100, -1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -956.464, 193.487, 24.865, 269.781, 38491),
(2, 'Danya_Family', '0B356121D6C968F3A4701942338DE05416C6767B0D1B0A077E08783C28EDA754', 'RBN02tDI<|', 'None', 0, 1, '0,0,0,0,0,0,0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775499952, '31.222.204.52', '31.222.204.52', 1775500000, 0, 0, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 'Danya_Test', 'DFF76921DBA593599BD5B25BBB1179A74225E8DB7F4EA6DD17B565D6E73E4B76', 'u3=W|/kbl3', 'None', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 161, 39981100, 0, 0, 0, 100, 0, 0, 13, 0, 2, 5, 0, '1,1,1,1,1,1,1', 0, '[A]', 0, 0, 3333, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775500624, '31.222.204.52', '31.222.204.62', 1775507037, 30, 167, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 2, 0, 0, 1778092634, 270, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 'Sile_Test', 'B11CAD546062CA6FC5B24FC433FD803489FAD4524386E435A037FB83A738E51E', '`>C7yVi`hd', 'None', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 79, 50000000, 0, 0, 0, 100, 0, 0, 0, 0, -1, 1, 0, '0,0,0,0,0,0,0', 0, '[A]', 0, 0, 0, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775500929, '31.222.204.52', '31.222.204.52', 1776617378, 0, 0, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 2, 0, 0, 1778092931, 150, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 'Majorka_Gromov', 'F2373910CA8A9D52C17B3E30E734FED1747493A1443111550C31D7442304615B', '`LoU8[Xm|0', 'egofgfgdfm@gmail.com', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 79, 78642501, 0, 0, 0, 100, 0, 5400000, 13, 0, 8, 4, 0, '0,0,0,0,0,0,0', 0, 'Основатель', 0, 0, 7777, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 10, 1, -1, -1, -1, -1, -1, -1, -1, 1775590850, '81.211.109.240', '81.211.109.240', 1777213778, 29, 45, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 15, 1, 0, 0, 2, 0, 0, 1778182852, 40, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 130, 100, -1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -2440.92, 200.695, 26.135, 128.885, 0),
(6, 'Sanya_Usupka', 'FCE47D3E459A992F5C35A29C1205158C4B54A2FFAD1A3865EFCC73E2D6E58B1F', '[P54>Mlmpl', 'None', 0, 3, '0,0,0,0,0,0,0', 0, 0, 0, 0, 71, 47009950, 0, 0, 0, 100, 0, 0, 0, 0, 5, 5, 0, '1,1,1,1,1,1,1', 0, '[A]', 0, 0, 0, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, -1, -1, -1, 1775636667, '178.172.246.247', '178.172.246.247', 1775686072, 13, 203, 0, 'None', 'None', 0, 0, 2, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1778228670, 150, 0, 0, '000000000000000', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 100, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2667.53, 2006.9, 11.237, 1.44502e-41, 0);

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

CREATE TABLE `action_log` (
  `id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255',
  `type` int(11) NOT NULL,
  `description` varchar(128) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


CREATE TABLE `activated_promos` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `promo_id` int(11) NOT NULL,
  `activated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


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



CREATE TABLE `bank_accounts_log` (
  `id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `uip` varchar(16) NOT NULL DEFAULT '255.255.255.255',
  `time` int(11) NOT NULL,
  `description` varchar(64) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `bank_accounts_log`

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
  `eviction` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `business`
--

INSERT INTO `business` (`id`, `owner_id`, `name`, `improvements`, `products`, `prod_price`, `balance`, `rent_time`, `price`, `rent_price`, `type`, `interior`, `enter_price`, `enter_music`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `eviction`) VALUES
(1, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747785600, 1000000, 10000, 1, 0, 4444, 0, 0, -578.011, -2852.72, 1.56921, 0, 0, 0, 0, 0),
(2, 0, 'Магазин 24/7', 4, 10000, 0, 43544884, 0, 1000000, 10000, 1, 0, 500, 4, 0, -578.011, -2852.72, 1.56921, 58.504, 397.444, 10.0043, 59.243, 0),
(3, 0, 'Магазин 24/7', 0, 10000, 0, 1700, 0, 1000000, 10000, 1, 0, 4444, 1, 0, -578.011, -2852.72, 1.56921, 110.703, 474.769, 11.3836, 147.446, 0),
(4, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747353600, 1000000, 10000, 1, 0, 5000, 1, 0, -578.011, -2852.72, 1.56921, 398.435, 966.38, 12.0023, 66.9036, 0),
(5, 0, 'Магазин 24/7', 0, 10000, 100, 11560, 1688083200, 1000000, 10000, 1, 0, 100, 4, 0, -578.011, -2852.72, 1.56921, -288.66, 958.372, 12.3608, 0.675795, 0),
(6, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747267200, 1000000, 10000, 1, 0, 1, 0, 0, -578.011, -2852.72, 1.56921, 1869.58, 1382.87, 9.75565, 271.06, 0),
(7, 0, 'Магазин 24/7', 6, 10000, 0, 43544884, 0, 1000000, 10000, 1, 0, 4999, 0, 0, -578.011, -2852.72, 1.56921, -313.346, 448.362, 12.764, 83.3864, 0),
(8, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747267200, 1000000, 10000, 1, 0, 100, 0, 0, -578.011, -2852.72, 1.56921, 102.391, 814.185, 12.0294, 336.361, 0),
(9, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 777, 0, 0, -578.011, -2852.72, 1.56921, 15.0025, 909.071, 12.1446, 223.424, 0),
(10, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747353600, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 299.938, 1781.41, 12.0283, 175.695, 0),
(11, 0, 'Магазин 24/7', 0, 10000, 100, 5, 1688342400, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 2258.81, -2106.68, 21.9609, 92.9546, 0),
(12, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 5000, 2, 0, -578.011, -2852.72, 1.56921, -541.018, 1305.45, 20.7349, 340.589, 0),
(13, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1688169600, 1000000, 10000, 1, 0, 1000, 3, 0, -578.011, -2852.72, 1.56921, -345.697, 958.087, 12.6123, 0.079129, 0),
(14, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 4999, 2, 0, -578.011, -2852.72, 1.56921, 304.155, 1665.28, 11.9978, 307.751, 0),
(15, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 2351.78, -749.508, 14.5062, 185.481, 0),
(16, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747353600, 1000000, 10000, 1, 0, 5000, 0, 0, -578.011, -2852.72, 1.56921, 202.873, 827.412, 12.9522, 163.695, 0),
(17, 0, 'Магазин 24/7', 6, 10000, 0, 6602485, 0, 1000000, 10000, 1, 0, 500, 1, 0, -578.011, -2852.72, 1.56921, 2554.58, -2204.34, 22.4537, 351.582, 0),
(18, 0, 'Магазин 24/7', 6, 10000, 0, 43544884, 0, 1000000, 10000, 1, 0, 1000, 0, 0, -578.011, -2852.72, 1.56921, -2312.92, -318.553, 30.4343, 85.3074, 0),
(19, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1747267200, 1000000, 10000, 1, 0, 888, 0, 0, -578.011, -2852.72, 1.56921, -2242.55, 222.827, 24.5109, 173.613, 1),
(20, 0, 'Магазин 24/7', 0, 10000, 25, 0, 1749859200, 1000000, 10000, 1, 0, 500, 0, 0, -578.011, -2852.72, 1.56921, -362.989, 1024.73, 13.2443, 94.9952, 0),
(21, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1000000, 10000, 1, 0, 200, 0, 0, -578.011, -2852.72, 1.56921, 397.588, 552.455, 12.3241, 153.093, 0),
(22, 0, 'Управление Статистики', 6, 10000, 0, 10518460, 0, 5000000, 50000, 3, 2, 5000, 5, 0, 0, 0, 99999, 648.913, 652.386, 12.1395, 159.377, 0),
(23, 0, 'Риелторское Агенство', 0, 10000, 0, 0, 0, 5000000, 50000, 4, 3, 5000, 0, 0, 0, 0, 99999, 2453.14, -1903.42, 21.9839, 269.949, 0),
(24, 0, 'Магазин одежды', 0, 10000, 0, 0, 1749513600, 5000000, 50000, 5, 4, 4666, 0, 0, 145.761, 673.122, 12.763, 144.949, 671.425, 12.7593, 159.2, 0),
(25, 0, 'Магазин одежды', 0, 10000, 0, 780000, 0, 5000000, 50000, 5, 4, 777, 4, 0, -578.011, -2852.72, 1.56921, 257.209, 1054.67, 12.1697, 262.488, 0),
(26, 0, 'Магазин одежды', 0, 10000, 0, 2000000, 1688256000, 5000000, 50000, 5, 4, 500, 0, 0, -578.011, -2852.72, 1.56921, 2258.88, -2099.99, 21.9609, 89.9466, 1),
(56, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1749772800, 300000, 0, 1, 0, 99, 1, 0, -578.011, -2852.72, 1.56921, 1946.27, 2065.99, 15.7053, 193.853, 0),
(27, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 5000000, 50000, 5, 4, 3333, 0, 0, -578.011, -2852.72, 1.56921, 134.643, 661.798, 12.7598, 250.025, 0),
(28, 0, 'Магазин одежды', 0, 10000, 0, 43544884, 0, 5000000, 50000, 5, 4, 3000, 5, 0, -578.011, -2852.72, 1.56921, -578.011, -2852.72, 1.56921, 192.329, 0),
(29, 0, 'Магазин одежды', 6, 10000, 0, 43544884, 0, 5000000, 50000, 5, 4, 5000, 3, 0, -578.011, -2852.72, 1.56921, -2550.85, 2934.69, 37.634, 180.27, 0),
(30, 0, 'Магазин одежды', 0, 10000, 0, 6830115, 0, 5000000, 50000, 5, 4, 100, 0, 0, -578.011, -2852.72, 1.56921, 381.981, 931.703, 12.0023, 71.1223, 0),
(31, 0, 'Отель', 0, 10000, 0, 43544884, 0, 5000000, 50000, 6, 5, 5000, 0, 0, 0, 0, 99999, -112.828, 984.11, 12.7591, 178.972, 0),
(32, 0, 'Отель', 0, 10000, 0, 43544884, 0, 5000000, 50000, 6, 5, 5000, 0, 0, 0, 0, 99999, 2412.38, -1844.08, 21.961, 179.265, 0),
(33, 0, 'Отель', 0, 10000, 0, 43544884, 0, 5000000, 50000, 6, 5, 0, 0, 0, 0, 0, 99999, 174.941, 493.417, 13.1466, 60.9921, 0),
(34, 25, 'Мотосалон Harley Davidson', 0, 10000, 0, 0, 1778198400, 5800000, 58000, 7, 6, 5000, 0, 0, -915.983, 1188.05, 10.7247, -913.122, 1185.87, 10.7247, 227.03, 0),
(35, 429, 'Автосалон низкого класса', 0, 10000, 0, 124250, 1775088000, 100000000, 101500, 7, 6, 5000, 0, 0, 2477.2, -718.347, 12.674, 2478.47, -723.627, 12.331, 171.863, 0),
(36, 7, '', 0, 10000, 25, 0, 1778198400, 6150000, 61500, 7, 6, 5000, 1, 0, 660.884, 2667.88, 14.5011, 658.857, 2665.41, 14.5011, 148.792, 0),
(37, 23, 'Автосалон среднего класса', 0, 10000, 0, 0, 1778198400, 8200000, 82000, 7, 6, 2222, 4, 0, 1410.86, 460.272, 13.163, 1409.41, 457.428, 13.163, 146.915, 0),
(125, 9, '', 0, 10000, 0, 0, 1778198400, 10000000, 15000, 20, 0, 0, 0, 0, -432.158, 1005.21, 12.15, 0, 0, 0, 0, 0),
(39, 0, 'Сотовый салон', 0, 10000, 0, 0, 1749686400, 4620000, 46200, 9, 8, 4444, 0, 0, -578.011, -2852.72, 1.56921, 378.57, 919.394, 12.0023, 65.5253, 0),
(57, 0, 'Магазин одежды', 0, 10000, 0, 0, 1749772800, 700000, 0, 5, 4, 1, 0, 0, -578.011, -2852.72, 1.56921, 1918.57, 2093.3, 15.7053, 85.5835, 0),
(58, 0, 'Магазин 24/7', 0, 10000, 200, 5600, 1688169600, 1000000, 0, 1, 0, 5000, 2, 0, -578.011, -2852.72, 1.56921, 1842.68, 2191.77, 15.6422, 270.86, 0),
(60, 0, 'Магазин 24/7', 6, 10000, 0, 6635159, 0, 1000000, 0, 1, 0, 444, 0, 0, -578.011, -2852.72, 1.56921, 255.08, 677.186, 12, 148.226, 0),
(67, 0, 'Автосалон', 0, 10000, 0, 0, 1750550400, 200000000, 0, 7, 6, 0, 0, 0, 0, 0, 1000000000, 0, 0, 0, 0, 0),
(62, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1748908800, 5000000, 0, 1, 0, 5000, 0, 0, -502.044, 1272.12, 20.8908, -499.594, 1271.24, 20.7424, 61.7039, 0),
(63, 0, '', 0, 10000, 0, 0, 0, 3000000, 0, 1, 0, 777, 0, 0, -5.06985, 911.411, 12.002, -6.80267, 907.861, 12.002, 325.228, 0),
(64, 0, 'Магазин одежды', 0, 10000, 0, 43544884, 0, 500000000, 0, 5, 4, 777, 0, 0, -510.637, -1628.02, 40.8817, -505.794, -1628.36, 40.9692, 115.701, 0),
(66, 0, 'Магазин Оружия', 6, 10000, 0, 0, 0, 50000000, 0, 11, 10, 3333, 0, 0, 219.359, 416.856, 11.5371, 223.043, 415.368, 11.2402, 67.0849, 0),
(68, 0, 'СТО', 0, 10000, 0, 0, 1748908800, 1, 0, 10, 9, 0, 0, 0, 0, 0, 99999, 813.191, 863.348, 11.5394, 356.834, 0),
(69, 0, '', 0, 10000, 0, 8000, 1777507200, 1000000, 0, 1, 0, 0, 0, 0, 2275.58, -726.4, 13.574, 0, 0, 0, 0, 0),
(70, 0, 'СТО', 0, 10000, 0, 0, 0, 1, 0, 10, 9, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0),
(71, 0, 'Клуб', 0, 10000, 25, 0, 1751414400, 1, 0, 2, 1, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0),
(81, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 10303, 0, 5, 4, 0, 0, 0, 1052.4, 1898.64, 20.7936, 0, 0, 0, 0, 0),
(75, 0, 'Сотовый салон', 0, 10000, 0, 0, 1747267200, 1600123, 0, 9, 8, 0, 0, 0, -578.011, -2852.72, 1.56921, 0, 0, 0, 0, 0),
(84, 0, '', 0, 0, 0, 0, 0, 500123, 0, 1, 0, 0, 0, 0, 1600.6, 2884.64, 12.2384, 1600.76, 2887.36, 12.0431, 343.535, 0),
(77, 0, '', 0, 10000, 0, 2220, 1777852800, 10000000, 0, 11, 10, 0, 0, 0, 207.838, 829.689, 13.4207, 208.785, 827.224, 12.4782, 218.102, 0),
(73, 0, 'Управление Статистики', 0, 10000, 0, 0, 1748908800, 1, 0, 3, 2, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0),
(74, 0, 'Магазин Оружия', 0, 10000, 0, 3090, 1777334400, 10000000, 0, 11, 10, 0, 0, 0, 1950.07, 1899.5, 15.558, 1952.68, 1898.75, 15.558, 236.013, 0),
(78, 0, '', 0, 10000, 0, 4470, 1777680000, 15000000, 0, 1, 0, 0, 0, 0, -1752.71, 774.723, 35.8554, -1755.63, 774.858, 35.5212, 94.0207, 0),
(79, 22, '', 0, 10000, 0, 60925, 1779235200, 300000000, 0, 8, 7, 0, 0, 0, 1333.49, 2372.6, 17.6642, 1333.63, 2368.66, 17.6642, 180, 0),
(80, 0, 'Казино', 0, 10000, 0, 661000, 1750118400, 12000123, 0, 8, 7, 0, 0, 0, 1281.31, 2402.09, 17.6138, 1278.71, 2402.17, 17.5447, 27.8223, 0),
(82, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, -1210.57, 3130.86, -0.55, 0, 0, 0, 0, 0),
(83, 0, 'Отель', 0, 10000, 0, 0, 1748908800, 1, 0, 6, 5, 0, 0, 0, 0, 0, 99999, 0, 0, 0, 0, 0),
(85, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1751414400, 500123, 0, 1, 0, 0, 0, 0, -2525.15, -694.514, 29.8158, -2528.79, -694.22, 29.6205, 70.1954, 0),
(86, 0, '', 0, 10000, 0, 0, 1777939200, 1001230, 0, 1, 0, 0, 0, 0, 1019.1, -791.287, 41.3681, 1018.94, -789.251, 41.165, 33.42, 0),
(87, 111, '', 0, 10, 200, 10900, 1778630400, 1200123, 0, 1, 0, 0, 0, 0, 2241.48, -1796.22, 21.7635, 2241.45, -1794.65, 21.7626, 14.4039, 0),
(88, 0, 'Магазин 24/7', 0, 10000, 200, 300, 1748908800, 1200012, 0, 1, 0, 0, 0, 0, 2765.84, 743.559, 31.229, 2767.28, 744.654, 31.229, 311.437, 0),
(91, 0, 'Магазин 24/7', 0, 10000, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, -1386.77, -1126.98, -0.55, 0, 0, 0, 0, 0),
(92, 0, 'Магазин 24/7', 0, 10000, 0, 6980, 1774656000, 1000000, 0, 1, 0, 0, 0, 0, 2310.62, -1911.56, 22.0088, 2307.68, -1912.02, 21.8525, 92.2264, 0),
(93, 0, 'Магазин 24/7', 0, 10000, 0, 5450, 1751414400, 1000000, 0, 1, 0, 0, 0, 0, 2260.66, -2102.8, 22.0009, 2258.17, -2102.66, 22.0009, 81.413, 0),
(94, 0, 'Магазин Оружия', 0, 10000, 200, 1890, 1777507200, 1000000, 0, 11, 10, 0, 0, 0, 2349.78, -2138.18, 22.5789, 2349.68, -2141.84, 22.0009, 174.534, 0),
(95, 0, 'Магазин 24/7', 0, 10000, 0, 800, 0, 1000000, 0, 1, 0, 0, 0, 0, 2577.81, -2377.66, 22.9787, 2578.43, -2380.7, 22.0223, 173.657, 0),
(96, 0, 'Магазин 24/7', 0, 10000, 200, 0, 1748908800, 1000000, 0, 1, 0, 0, 0, 0, 2450.39, -1903.5, 22.0009, 2453, -1903.4, 22.0009, 262.245, 0),
(97, 0, '', 0, 0, 0, 1800, 0, 1000000, 0, 1, 0, 0, 0, 0, 1921.41, 2093.06, 16.1921, 1918.56, 2093.02, 15.7282, 89.9195, 0),
(98, 0, '', 0, 10000, 0, 0, 0, 1000000, 0, 1, 0, 0, 0, 0, 1850.95, 2245.98, 15.6698, 1853.4, 2245.72, 15.6698, 259.537, 0),
(99, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1751414400, 1000000, 0, 1, 0, 0, 0, 0, 2629.28, 2584.43, 16.6351, 2631.55, 2584.53, 16.432, 274.944, 0),
(100, 0, 'Магазин 24/7', 0, 10000, 0, 25760, 1777248000, 1000000, 0, 1, 0, 0, 0, 0, 405.653, 1960.77, 8.20754, 408.478, 1960.72, 8.20755, 260.942, 0),
(101, 0, '', 0, 10000, 199, 8070, 1777420800, 1000000, 0, 1, 0, 0, 0, 0, -359.955, 1025, 13.2853, -362.81, 1025.22, 13.283, 81.748, 0),
(102, 0, '', 0, 0, 0, 0, 0, 1000000, 0, 1, 0, 0, 0, 0, 37.8563, 513.608, 13.2138, 38.7087, 510.755, 13.2344, 179.408, 0),
(103, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1777334400, 1000000, 0, 1, 0, 0, 0, 0, 398.482, 554.672, 12.1884, 397.341, 550.7, 12.3525, 157.989, 0),
(104, 14, 'Магазин 24/7', 0, 9987, 0, 2000, 1778198400, 1000000, 0, 1, 0, 0, 0, 0, 150.231, 779.273, 12.0217, 152.688, 779.922, 12.0258, 264.461, 0),
(105, 0, '', 0, 0, 0, 0, 1776038400, 1000000, 0, 1, 0, 0, 0, 0, -541.414, 1303.48, 20.9306, -540.513, 1305.67, 20.7822, 339.308, 0),
(106, 0, '', 0, 10000, 0, 2290, 0, 1000000, 0, 1, 0, 0, 0, 0, -2310.42, -318.864, 30.6908, -2312.85, -319.018, 30.4343, 84.4298, 0),
(107, 0, 'Магазин 24/7', 0, 10000, 100, 383200, 1777593600, 1000000, 0, 1, 0, 0, 0, 0, -2379.94, 5.15279, 27.07, -2377.45, 5.13003, 26.563, 267.929, 0),
(108, 0, '', 0, 10000, 0, 0, 1775001600, 1000000, 0, 11, 10, 0, 0, 0, -2381.79, -60.8227, 26.7924, -2379.9, -61.1389, 26.5582, 257.095, 0),
(109, 0, '', 0, 0, 0, 0, 0, 1000000, 0, 11, 10, 0, 0, 0, -506.315, -1551.79, 41.7679, -507.909, -1554.75, 41.2679, 163.155, 0),
(110, 0, 'Магазин 24/7', 0, 10000, 0, 400, 1777593600, 1000000, 0, 1, 0, 0, 0, 0, -523.707, -1779.88, 41.0658, -525.949, -1778.58, 40.9619, 52.0631, 0),
(111, 0, 'Магазин 24/7', 0, 10000, 0, 900, 1751328000, 1000000, 0, 1, 0, 0, 0, 0, -2584.39, 1208.41, 9.91683, -2588.63, 1209.21, 9.89156, 78.2092, 0),
(112, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1751414400, 1000000, 0, 1, 0, 0, 0, 0, -2573.37, 1598.57, 9.94134, -2577.39, 1598.85, 9.89156, 77.2062, 0),
(113, 0, 'Магазин 24/7', 0, 10000, 0, -4700, 0, 1000000, 0, 1, 0, 0, 0, 0, -2211.25, 1441.28, 9.94205, -2213.85, 1441.5, 9.88994, 65.7093, 0),
(114, 0, 'Магазин Оружия', 0, 10000, 25, 1603025, 1751328000, 1000000, 0, 11, 10, 0, 0, 0, -2560.4, 1078.58, 10.3936, -2560.88, 1076.06, 9.89156, 182.641, 0),
(115, 0, 'Магазин Оружия', 0, 10000, 100, 0, 1751414400, 1000000, 0, 11, 10, 0, 0, 0, -2154.72, 2052.94, 9.66061, -2154.95, 2050.25, 9.55562, 179.624, 0),
(116, 0, 'Магазин Оружия', 0, 10000, 0, 1180, 1777420800, 1000000, 0, 11, 10, 0, 0, 0, -1932.02, 2380.63, 58.6521, -1931.55, 2382.91, 58.157, 357.035, 0),
(117, 0, 'Магазин 24/7', 0, 10000, 0, -8050, 1751328000, 1000000, 0, 1, 0, 0, 0, 0, -2299.71, 2460.79, 58.0877, -2300.13, 2457.6, 57.8916, 172.669, 0),
(118, 0, 'Магазин 24/7', 0, 10000, 155, -5000, 1751328000, 1000000, 0, 1, 0, 0, 0, 0, -2352.27, 2596.97, 58.3341, -2351.62, 2594.33, 57.9308, 190.863, 0),
(119, 0, '', 0, 10000, 0, 0, 0, 1000000, 0, 1, 0, 0, 0, 0, -2070.58, 2477.42, 57.8603, -2070.92, 2474.01, 57.665, 171.006, 0),
(120, 0, 'Магазин 24/7', 0, 10000, 0, 900, 1751328000, 1000000, 0, 1, 0, 0, 0, 0, -1683.51, 2334.93, 58.363, -1683.09, 2337.83, 58.1071, 358.576, 0),
(121, 0, 'Магазин 24/7', 0, 10000, 0, 0, 1748822400, 1000000, 0, 1, 0, 0, 0, 0, -1848.19, 2786.38, 58.173, -1848.34, 2789.2, 57.9925, 346.034, 0),
(122, 0, 'Магазин 24/7', 0, 10000, 0, 600, 1748908800, 1000000, 0, 1, 0, 0, 0, 0, 550.565, -1221.8, 41.2851, 548.653, -1220.67, 41.0869, 53.9127, 0),
(123, 0, 'Магазин одежды', 0, 10000, 0, 0, 1748908800, 1, 0, 5, 4, 0, 0, 0, -2769.01, 1429.95, 64.7275, 0, 0, 0, 0, 0),
(124, 0, 'Магазин одежды', 0, 10000, 0, 0, 0, 1, 0, 5, 4, 0, 0, 0, -923.065, -453.353, 832.587, 0, 0, 0, 0, 0),
(126, 0, '', 0, 10000, 0, 0, 0, 6, 0, 5, 4, 0, 0, 0, -904.167, -508.39, 592.766, 0, 0, 0, 0, 0),
(127, 0, '', 0, 10000, 0, 0, 1775260800, 6, 0, 5, 4, 0, 0, 0, -1009.74, 240.372, 24.8679, 0, 0, 0, 0, 0),
(129, 82, '', 0, 11, 0, 1000000, 1778630400, 15000000, 0, 5, 4, 0, 0, 0, 203.688, 828.653, 13.4207, 202.449, 824.891, 12.4782, 167, 0),
(130, 0, 'Магазин Одежды', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -18.5988, 464.405, 13.2139, -14.5805, 464.238, 13.2362, 241.177, 0),
(131, 0, '', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -2329.33, -320.453, 30.6663, -2329.52, -324.324, 30.4343, 181.521, 0),
(132, 0, '', 0, 10000, 0, 624250, 0, 15000000, 0, 5, 4, 0, 0, 0, -1767.48, 682.054, 35.4398, -1771.2, 682.973, 35.4398, 79.0027, 0),
(133, 0, 'Магазин Одежды', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -2427.04, 1128.51, 10.8551, -2425.6, 1118.84, 9.89156, 169.182, 0),
(134, 0, 'Магазин Одежды', 0, 10000, 0, 0, 0, 15000000, 0, 5, 4, 0, 0, 0, -1799.19, 2667.18, 60.5335, -1794.13, 2660.46, 57.9603, 214.892, 0),
(135, 0, 'Магазин Оружия', 0, 10000, 0, 600, 1777420800, 8750000, 0, 11, 10, 0, 0, 0, -1788, 671.136, 35.4398, -1786.63, 673.822, 35.4398, 335.105, 0),
(136, 0, '', 0, 0, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, 2744.39, -2429.17, 21.7, 0, 0, 0, 0, 0),
(137, 0, 'Ларек', 0, 10000, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, 1889.02, -2243.58, 11, 0, 0, 0, 0, 0),
(138, 0, '', 0, 10000, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, 1912.4, -2266.84, 11, 0, 0, 0, 0, 0),
(139, 0, '', 0, 0, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, 847.11, 802.56, 13.37, 0, 0, 0, 0, 0),
(140, 0, '', 0, 0, 0, 1360, 1776038400, 500000, 2500, 13, 11, 0, 0, 0, 1801.61, 2531.53, 14.6, 0, 0, 0, 0, 0),
(141, 0, 'Ларек', 0, 10000, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, -1760.9, 790.95, 35.7, 0, 0, 0, 0, 0),
(142, 0, '', 0, 10000, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, -2402.36, 194.53, 26, 0, 0, 0, 0, 0),
(143, 0, 'Ларек', 0, 10000, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, -111.86, 905.17, 12.21, 0, 0, 0, 0, 0),
(144, 0, 'Ларек', 0, 10000, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, -113.26, 942.28, 12.21, 0, 0, 0, 0, 0),
(145, 0, 'Ларек', 0, 10000, 0, 0, 0, 500000, 2500, 13, 11, 0, 0, 0, -256, 573.98, 12.19, 0, 0, 0, 0, 0),
(146, 0, '', 0, 10000, 0, 1410, 0, 500000, 2500, 13, 11, 0, 0, 0, -1777.69, 817.12, 35.5, 0, 0, 0, 0, 0),
(147, 0, '', 0, 0, 0, 15929989, 0, 7000000, 0, 12, 11, 0, 0, 0, 1945.67, 2068.86, 16.1921, 1945.38, 2066.08, 15.7377, 177.967, 0),
(148, 26, 'Магазин аксесуаров', 0, 9993, 0, 6360000, 1778198400, 7000000, 0, 12, 11, 0, 0, 0, 216.569, 860.619, 13.4207, 1945.38, 2066.08, 15.7377, 177.967, 0),
(0, 0, 'Ларек', 0, 0, 0, 0, 0, 500000, 0, 13, 12, 0, 0, 0, 1905.8, 2104.11, 15.7422, 0, 0, 0, 0, 0);

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


CREATE TABLE `car_obmen` (
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



CREATE TABLE `family_ad` (
  `id` int(11) NOT NULL,
  `family` int(11) NOT NULL,
  `ad_text` varchar(62) NOT NULL,
  `create_id` int(11) NOT NULL,
  `create_name` varchar(24) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `family_cars` (
  `id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `color_1` int(11) NOT NULL,
  `color_2` int(11) NOT NULL,
  `number` varchar(32) NOT NULL DEFAULT 'none',
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


CREATE TABLE `family_log` (
  `id` int(11) NOT NULL,
  `family` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `to_player` int(11) NOT NULL,
  `text` varchar(124) NOT NULL,
  `time` int(11) NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


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
(17, 22, 'Заправочная станция', 0, 191, 15, 0, 1135, 1779235200, 1000000, 5000, 0, 2276.39, -739.561, 13.4187, 0),
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
  `owner_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `lock` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `exit_x` float NOT NULL,
  `exit_y` float NOT NULL,
  `exit_z` float NOT NULL,
  `exit_angle` float NOT NULL,
  `improvements` int(11) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

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
  `id` int(16) NOT NULL,
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
(873, 80, '', 0, 1778716800, 300000, 0, 0, -1, 0, 1741.57, 2116.99, 16.1999, 1743.86, 2117.3, 16.1999, 259.611, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(872, 0, '', 0, 0, 300000, 0, 0, -1, 0, 1945.31, 1845.38, 15.4198, 1947.42, 1845.82, 15.4198, 285.242, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(870, 0, '', 6, 0, 300000, 0, 0, -1, 0, 1989.2, 1794, 15.4441, 1987.7, 1794.56, 15.4413, 86.7417, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(869, 0, '', 6, 0, 300000, 0, 0, -1, 0, 1994.83, 1746.33, 15.6989, 1993.11, 1746.58, 15.6989, 87.4468, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(868, 40, '', 6, 1778284800, 300000, 0, 0, -1, 1, 1943.69, 1752.91, 15.3423, 1945.62, 1752.87, 15.3423, 296.995, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
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
(673, 82, '', 6, 1778630400, 25000000, 0, 6, -1, 0, -1873.69, 481.228, 28.9801, -1876.23, 480.146, 28.602, 115.802, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(675, 0, '', 0, 1777593600, 25000000, 0, 6, -1, 1, -1975.67, 544.936, 28.9101, -1975.1, 542.26, 28.9101, 197.373, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(674, 0, '', 0, 1777248000, 25000000, 0, 6, -1, 0, -1959.34, 450.611, 30.421, -1961.53, 455.194, 30.0539, 26.1601, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(676, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1911.96, 577.115, 29.8391, -1915.03, 576.512, 29.8391, 100.633, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(678, 0, '', 0, 1777161600, 25000000, 0, 6, -1, 1, -1920.51, 650.203, 29.7304, -1923.29, 650.172, 29.1118, 95.7938, 0, 0, 0, 0, 312.955, 2157.91, 1765.51, 0, 0, 0, 30, 0, 240),
(677, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -2000.73, 613.702, 29.5068, -1995.93, 614.639, 29.2698, 281.762, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(679, 22, '', 6, 1779235200, 25000000, 0, 6, -1, 1, -1666.15, 722.296, 33.3062, -1663.71, 720.9, 33.0061, 235.471, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(681, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1524.56, 617.828, 32.1888, -1520.5, 620.128, 32.0982, 307.333, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(680, 0, '', 0, 1776902400, 25000000, 0, 6, -1, 0, -1560.09, 669.604, 32.0178, -1557.81, 670.847, 31.8302, 303.327, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(682, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1445.29, 659.15, 31.5992, -1447, 658.589, 31.3577, 125.227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(683, 0, '', 0, 1748908800, 25000000, 0, 6, -1, 0, -1412.91, 588.446, 31.7147, -1415.28, 587.307, 31.4939, 127.605, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(685, 111, '', 6, 1778630400, 25000000, 0, 6, -1, 1, -1349.4, 511.329, 31.3153, -1351.94, 509.639, 31.3153, 114.712, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(684, 0, '', 0, 1749513600, 25000000, 0, 6, -1, 0, -1463.57, 528.016, 31.1849, -1461.2, 529.247, 31.1772, 301.113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(686, 0, '', 0, 0, 25000000, 0, 6, -1, 0, -1449.94, 464.916, 31.4915, -1448.28, 466.066, 31.4915, 294.925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(687, 0, '', 0, 1751414400, 25000000, 0, 6, -1, 0, -1405.78, 401.085, 32.5497, -1401.22, 403.696, 32.0669, 305.567, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(688, 0, '', 0, 1748908800, 25000000, 0, 6, -1, 0, -1329.36, 448.761, 31.9248, -1332.14, 447.432, 31.4841, 122.957, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(689, 0, '', 0, 1775174400, 25000000, 0, 6, -1, 0, -1360.98, 348.466, 33.5159, -1357.24, 350.618, 33.5159, 305.806, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(690, 0, '', 0, 1751414400, 25000000, 0, 6, -1, 0, -1284.63, 395.652, 33.1868, -1286.3, 394.648, 32.8069, 122.934, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(691, 21, '', 0, 1778198400, 25000000, 0, 6, -1, 0, -1317.39, 261.332, 33.433, -1315.45, 263.291, 33.133, 315.363, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(692, 0, '', 0, 1748908800, 25000000, 0, 6, -1, 0, -1233.5, 260.171, 33.6513, -1233.22, 262.904, 33.3275, 349.582, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(693, 0, '', 0, 1777593600, 25000000, 0, 6, -1, 0, -1087.42, 252.788, 24.9623, -1085.78, 254.579, 24.9546, 314.901, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(694, 0, '', 0, 1777680000, 25000000, 0, 6, -1, 0, -1064.34, 322.176, 25.5636, -1065.75, 320.191, 25.4922, 144.47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(695, 7, '', 6, 1778198400, 25000000, 0, 6, -1, 0, -964.27, 315.093, 26.0134, -965.831, 313.101, 25.8634, 152.143, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(696, 0, '', 6, 1778284800, 25000000, 0, 6, -1, 0, -956.51, 193.419, 24.8252, -957.978, 194.804, 24.8252, 59.0303, 0, 0, 0, 0, 290.443, 2146.03, 1765.51, 0, 0, 0, 0, 0, 0),
(697, 0, '', 6, 1775865600, 25000000, 0, 6, -1, 0, -1031.28, 183.269, 26.4004, -1030.1, 184.569, 26.1681, 327.862, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(698, 23, '', 0, 1778198400, 25000000, 0, 6, -1, 0, -1147.33, 402.629, 21.2179, -1145.68, 404.841, 20.9179, 322.566, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
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
(871, 85, '', 0, 1778457600, 300000, 0, 0, -1, 0, 1943.52, 1806.86, 15.5073, 1943.24, 1808.69, 15.3979, 6.59181, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(861, 0, '', 0, 0, 7000000, 0, 3, -1, 0, 446.584, 333.995, 12.4608, 446.093, 331.331, 12.4531, 182.426, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(879, 0, '', 0, 1751414400, 300000, 0, 0, -1, 0, 2590.4, -230.938, 4.04322, 2590.62, -229.353, 4.03842, 351.38, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(867, 0, '', 0, 1749686400, 7000000, 0, 3, -1, 0, 390.398, 344.407, 12.4608, 390.087, 341.14, 12.3374, 185.986, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(880, 0, '', 0, 1748908800, 300000, 0, 0, -1, 0, 2573.42, -230.525, 3.49045, 2573.41, -228.223, 3.49048, 356.337, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(881, 0, '', 0, 1751328000, 300000, 0, 0, -1, 0, 2513.71, -230.504, 2.56648, 2513.94, -228.163, 2.56648, 349.615, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(882, 0, '', 0, 1777420800, 300000, 0, 0, -1, 0, 2524.48, -198.828, 3.72267, 2524.81, -200.71, 3.72267, 183.334, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(883, 0, '', 0, 1775433600, 300000, 0, 0, -1, 0, 2487.49, -252.63, 1.842, 2489.37, -252.921, 1.84912, 270.395, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(884, 0, '', 6, 0, 300000, 0, 0, -1, 0, 2466.55, -201.204, 2.14461, 2466.26, -202.736, 2.14461, 178.156, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(885, 0, '', 2, 0, 300000, 0, 0, -1, 0, 2422.08, -206.15, 2.3524, 2420.4, -206.52, 2.1459, 97.8874, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(886, 45, '', 5, 1778284800, 300000, 0, 0, -1, 0, 2414.78, -230.613, 2.06485, 2415.2, -228.768, 2.08585, 355.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
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
  `firmware` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


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


CREATE TABLE `player_promos` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `promo_prize_sql_id` int(11) NOT NULL,
  `start_time` int(11) NOT NULL,
  `remaining_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


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


CREATE TABLE `promocode_activations` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `code` varchar(32) NOT NULL,
  `paydays` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


CREATE TABLE `promo_prizes` (
  `id` int(11) NOT NULL,
  `promo_id` int(11) NOT NULL,
  `prize_index` tinyint(1) NOT NULL,
  `prize_type` tinyint(1) NOT NULL DEFAULT 0,
  `prize_value` int(11) NOT NULL DEFAULT 0,
  `prize_duration` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


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


CREATE TABLE `rewards` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL COMMENT 'ID игрока из таблицы аккаунтов',
  `award_id` int(11) NOT NULL COMMENT '�?ндекс приза в массиве Case...Awards',
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
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `description` varchar(64) NOT NULL,
  `issuer` varchar(32) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


CREATE TABLE `trunks` (
  `id` int(11) NOT NULL,
  `oc_id` int(11) NOT NULL COMMENT 'ID транспорта из ownable_cars',
  `slot` int(11) NOT NULL DEFAULT 0 COMMENT 'Слот багажника',
  `item_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ID предмета',
  `amount` int(11) NOT NULL DEFAULT 1 COMMENT 'Количество предмета',
  `item_type` int(11) NOT NULL DEFAULT 0 COMMENT 'Тип предмета',
  `item_plate` varchar(32) NOT NULL DEFAULT '' COMMENT 'Номер машины'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;


CREATE TABLE `unitpay_payments` (
  `id` int(10) NOT NULL,
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
-- �?ндексы сохранённых таблиц
--

-- =====================================================
-- ПЕРВ�?ЧНЫЕ КЛЮЧ�? (PRIMARY KEY) ДЛЯ ВСЕХ ТАБЛ�?Ц
-- =====================================================

ALTER TABLE `accessories` ADD PRIMARY KEY (`id`);
ALTER TABLE `accounts` ADD PRIMARY KEY (`id`), ADD KEY `email` (`email`), ADD KEY `phone` (`phone`), ADD KEY `house` (`house`), ADD KEY `name` (`name`) USING BTREE;
ALTER TABLE `aclogs` ADD PRIMARY KEY (`id`);
ALTER TABLE `action_log` ADD PRIMARY KEY (`id`);
ALTER TABLE `activated_promos` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `account_promo` (`account_id`,`promo_id`);
ALTER TABLE `allowed_servers` ADD PRIMARY KEY (`id`);
ALTER TABLE `bank_accounts` ADD PRIMARY KEY (`id`);
ALTER TABLE `bank_accounts_log` ADD PRIMARY KEY (`id`);
ALTER TABLE `ban_list` ADD PRIMARY KEY (`id`);
ALTER TABLE `business` ADD PRIMARY KEY (`id`);
ALTER TABLE `business_gps` ADD PRIMARY KEY (`id`);
ALTER TABLE `business_profit` ADD PRIMARY KEY (`id`);
ALTER TABLE `car_obmen` ADD COLUMN `id` int(11) NOT NULL AUTO_INCREMENT FIRST, ADD PRIMARY KEY (`id`);
ALTER TABLE `change_names` ADD PRIMARY KEY (`id`);
ALTER TABLE `charity` ADD PRIMARY KEY (`id`);
ALTER TABLE `debug` ADD PRIMARY KEY (`id`);
ALTER TABLE `donate_log` ADD PRIMARY KEY (`id`);
ALTER TABLE `family` ADD PRIMARY KEY (`id`);
ALTER TABLE `family_ad` ADD PRIMARY KEY (`id`);
ALTER TABLE `family_cars` ADD PRIMARY KEY (`id`);
ALTER TABLE `family_log` ADD PRIMARY KEY (`id`);
ALTER TABLE `fuel_stations` ADD PRIMARY KEY (`id`);
ALTER TABLE `fuel_stations_profit` ADD PRIMARY KEY (`id`);
ALTER TABLE `full_dostup` ADD PRIMARY KEY (`id`);
ALTER TABLE `gang_repositories` ADD PRIMARY KEY (`id`);
ALTER TABLE `gang_zones` ADD PRIMARY KEY (`id`);
ALTER TABLE `garages` ADD PRIMARY KEY (`id`);
ALTER TABLE `gates` ADD PRIMARY KEY (`id`);
ALTER TABLE `gift` ADD PRIMARY KEY (`id`);
ALTER TABLE `gift_lose` ADD PRIMARY KEY (`id`);
ALTER TABLE `hotels` ADD PRIMARY KEY (`id`);
ALTER TABLE `houses` ADD PRIMARY KEY (`id`);
ALTER TABLE `houses_renters` ADD PRIMARY KEY (`id`);
ALTER TABLE `house_storage` ADD PRIMARY KEY (`id`);
ALTER TABLE `items_data` ADD PRIMARY KEY (`id`);
ALTER TABLE `leaders` ADD PRIMARY KEY (`id`);
ALTER TABLE `money_log` ADD PRIMARY KEY (`id`);
ALTER TABLE `objects` ADD PRIMARY KEY (`id`);
ALTER TABLE `old_accessories` ADD PRIMARY KEY (`account_id`, `slot`);
ALTER TABLE `orders` ADD PRIMARY KEY (`id`);
ALTER TABLE `ownable_cars` ADD PRIMARY KEY (`id`);
ALTER TABLE `payments` ADD PRIMARY KEY (`id`);
ALTER TABLE `phone_books` ADD PRIMARY KEY (`id`);
ALTER TABLE `player_gpus` ADD PRIMARY KEY (`id`);
ALTER TABLE `player_inventory` ADD PRIMARY KEY (`id`);
ALTER TABLE `player_promos` ADD PRIMARY KEY (`id`);
ALTER TABLE `promocode` ADD PRIMARY KEY (`id`);
ALTER TABLE `promocodes` ADD PRIMARY KEY (`id`);
ALTER TABLE `promocode_activations` ADD PRIMARY KEY (`id`);
ALTER TABLE `promo_prizes` ADD PRIMARY KEY (`id`);
ALTER TABLE `quick_message` ADD PRIMARY KEY (`name`);
ALTER TABLE `repositories` ADD PRIMARY KEY (`id`);
ALTER TABLE `return_money` ADD PRIMARY KEY (`id`);
ALTER TABLE `rewards` ADD PRIMARY KEY (`id`);
ALTER TABLE `roulette_prize` ADD PRIMARY KEY (`id`);
ALTER TABLE `tickets` ADD PRIMARY KEY (`id`);
ALTER TABLE `trunks` ADD PRIMARY KEY (`id`);
ALTER TABLE `unitpay_payments` ADD PRIMARY KEY (`id`);
ALTER TABLE `whitelist` ADD PRIMARY KEY (`id`);
ALTER TABLE `ytpromocode` ADD PRIMARY KEY (`id`);

-- =====================================================
-- AUTO_INCREMENT ДЛЯ ВСЕХ ТАБЛ�?Ц
-- =====================================================

ALTER TABLE `accessories` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `accounts` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
ALTER TABLE `aclogs` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `action_log` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `activated_promos` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `allowed_servers` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `bank_accounts` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `bank_accounts_log` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `ban_list` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `business` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `business_gps` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `business_profit` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `car_obmen` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `change_names` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `charity` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `debug` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `donate_log` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `family` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `family_ad` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `family_cars` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `family_log` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `fuel_stations` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `fuel_stations_profit` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `full_dostup` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `gang_repositories` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `gang_zones` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `garages` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `gates` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `gift` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `gift_lose` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `hotels` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `houses` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `houses_renters` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `house_storage` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `items_data` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `leaders` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `money_log` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `objects` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `orders` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `ownable_cars` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `payments` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `phone_books` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `player_gpus` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `player_inventory` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `player_promos` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `promocode` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `promocodes` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `promocode_activations` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `promo_prizes` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `repositories` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `return_money` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `rewards` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `roulette_prize` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `tickets` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `trunks` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `unitpay_payments` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `whitelist` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
ALTER TABLE `ytpromocode` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
