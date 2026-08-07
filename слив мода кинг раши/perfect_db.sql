-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Дек 14 2023 г., 09:56
-- Версия сервера: 10.11.2-MariaDB
-- Версия PHP: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gs70675`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `password` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `referal` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ip` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0.0.0',
  `admin` int(11) NOT NULL DEFAULT 0,
  `securitycode` int(11) NOT NULL DEFAULT 0,
  `checkcode` int(11) NOT NULL DEFAULT 0,
  `mail` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT 8,
  `cash` int(11) NOT NULL DEFAULT 30000000,
  `bank` int(11) NOT NULL DEFAULT 250,
  `exp` int(11) NOT NULL DEFAULT 0,
  `regip` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0.0.0',
  `datareg` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0.0',
  `leader` int(3) NOT NULL DEFAULT 0,
  `member` int(3) NOT NULL DEFAULT 0,
  `rank` int(3) NOT NULL DEFAULT 0,
  `warn` int(11) NOT NULL DEFAULT 0,
  `sex` int(11) NOT NULL DEFAULT 0,
  `age` int(11) NOT NULL DEFAULT 0,
  `model` int(11) NOT NULL DEFAULT 0,
  `memberskin` int(11) NOT NULL DEFAULT 0,
  `lic` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1, 1, 1, 1, 1',
  `guns` varchar(56) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0',
  `ammos` varchar(56) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0',
  `mute` int(11) NOT NULL DEFAULT 0,
  `mutereason` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `defeetkart` int(11) NOT NULL DEFAULT 0,
  `winkart` int(11) NOT NULL DEFAULT 0,
  `pick` int(11) NOT NULL DEFAULT 0,
  `checktime` int(6) NOT NULL DEFAULT 0,
  `news` int(11) NOT NULL DEFAULT 0,
  `phone` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0',
  `phonenumber` int(11) NOT NULL DEFAULT 0,
  `text` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0',
  `jail` int(11) NOT NULL DEFAULT 0,
  `jailtime` int(11) NOT NULL DEFAULT 0,
  `jailreason` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `wanted` int(11) NOT NULL DEFAULT 0,
  `wantedwho` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `wantedreason` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `married` int(11) NOT NULL DEFAULT 0,
  `whomarried` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `paycheck` int(11) NOT NULL DEFAULT 0,
  `charity` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT -1,
  `vip_time` int(20) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `fstyle` int(11) NOT NULL DEFAULT 0,
  `credits` int(11) NOT NULL DEFAULT 0,
  `skin1` int(11) NOT NULL DEFAULT 0,
  `skin2` int(11) NOT NULL DEFAULT 0,
  `skin3` int(11) NOT NULL DEFAULT 0,
  `spawnchange` int(11) NOT NULL DEFAULT 0,
  `sdpistol` int(11) NOT NULL DEFAULT 0,
  `deserteagle` int(11) NOT NULL DEFAULT 0,
  `shotgun` int(11) NOT NULL DEFAULT 0,
  `mp5` int(11) NOT NULL DEFAULT 0,
  `ak47` int(11) NOT NULL DEFAULT 0,
  `m4` int(11) NOT NULL DEFAULT 0,
  `pistol` int(11) NOT NULL DEFAULT 0,
  `microuzi` int(11) NOT NULL DEFAULT 0,
  `sportexp` int(11) NOT NULL DEFAULT 0,
  `online` int(11) NOT NULL DEFAULT 0,
  `zakon` int(11) NOT NULL DEFAULT 0,
  `sprunk` int(11) NOT NULL DEFAULT 7000,
  `phonebalance` int(11) NOT NULL DEFAULT 100,
  `aptechka` int(11) NOT NULL DEFAULT 0,
  `Voennik` int(11) NOT NULL DEFAULT 0,
  `music` int(11) NOT NULL DEFAULT 0,
  `improves` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0',
  `datavhod` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0.0',
  `settings` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0,0,0,0,0',
  `phnumber1` int(11) NOT NULL DEFAULT 0,
  `phnumber2` int(11) NOT NULL DEFAULT 0,
  `phnumber3` int(11) NOT NULL DEFAULT 0,
  `phnumber4` int(11) NOT NULL DEFAULT 0,
  `phnumber5` int(11) NOT NULL DEFAULT 0,
  `phnumber6` int(11) NOT NULL DEFAULT 0,
  `phnumber7` int(11) NOT NULL DEFAULT 0,
  `phnumber8` int(11) NOT NULL DEFAULT 0,
  `mailconf` int(11) NOT NULL DEFAULT 0,
  `family` int(11) NOT NULL DEFAULT 0,
  `familysozd` int(11) NOT NULL DEFAULT 0,
  `familyzam` int(11) NOT NULL DEFAULT 0,
  `black0` int(1) NOT NULL DEFAULT 0,
  `black1` int(1) NOT NULL DEFAULT 0,
  `black2` int(1) NOT NULL DEFAULT 0,
  `black3` int(1) NOT NULL DEFAULT 0,
  `black4` int(1) NOT NULL DEFAULT 0,
  `black5` int(1) NOT NULL DEFAULT 0,
  `black6` int(1) NOT NULL DEFAULT 0,
  `black7` int(1) NOT NULL DEFAULT 0,
  `black8` int(1) NOT NULL DEFAULT 0,
  `black9` int(1) NOT NULL DEFAULT 0,
  `black10` int(1) NOT NULL DEFAULT 0,
  `black11` int(11) NOT NULL DEFAULT 0,
  `black12` int(11) NOT NULL DEFAULT 0,
  `set1` int(1) NOT NULL DEFAULT 0,
  `set2` int(1) NOT NULL DEFAULT 0,
  `set3` int(1) NOT NULL DEFAULT 0,
  `set4` int(1) NOT NULL DEFAULT 0,
  `set5` int(1) NOT NULL DEFAULT 1,
  `set6` int(1) NOT NULL DEFAULT 0,
  `set7` int(1) NOT NULL DEFAULT 0,
  `donatepay` int(11) NOT NULL DEFAULT 0,
  `garage` int(20) NOT NULL DEFAULT -1,
  `familyrank` int(11) NOT NULL DEFAULT 0,
  `lwarn` int(11) NOT NULL DEFAULT 0,
  `countcars` int(11) NOT NULL DEFAULT 3,
  `leaderstats` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0,0,0,0,0,0',
  `mats` int(11) NOT NULL DEFAULT 0,
  `bonusday` int(11) NOT NULL DEFAULT 0,
  `bonusdaytime` int(11) NOT NULL DEFAULT 0,
  `mainbankaccount` int(11) NOT NULL DEFAULT -1,
  `LockPick` int(11) NOT NULL DEFAULT 0,
  `twarn` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `clips` int(11) NOT NULL DEFAULT 0,
  `togphone` int(11) NOT NULL DEFAULT 1,
  `house` int(11) NOT NULL DEFAULT -1,
  `business` int(11) NOT NULL DEFAULT -1,
  `house_arend` int(11) NOT NULL DEFAULT -1,
  `room` int(11) NOT NULL DEFAULT -1,
  `restore_hash` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `day` int(11) NOT NULL DEFAULT 0,
  `mainsub` int(11) DEFAULT 0,
  `scoreivent` int(11) DEFAULT 0,
  `sub_invited` int(11) NOT NULL DEFAULT 0,
  `sub_uninvited` int(11) NOT NULL DEFAULT 0,
  `sub_twarns` int(11) NOT NULL DEFAULT 0,
  `pTaxiJob` int(11) NOT NULL DEFAULT -1,
  `pTaxiKey` int(11) NOT NULL DEFAULT -1,
  `pTaxiFree` int(11) NOT NULL DEFAULT 0,
  `pEQuestBeach` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0',
  `pEQuestGos` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0',
  `pEQuestGang` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0',
  `pEQuestMaf` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0',
  `pVostAccBlat` int(11) NOT NULL DEFAULT 0,
  `vostslegacy` int(11) DEFAULT 0,
  `pVostAccBlatU` int(11) NOT NULL DEFAULT 0,
  `pPumpkin` int(11) NOT NULL DEFAULT 0,
  `pEuro` int(11) NOT NULL DEFAULT 0,
  `GunPack` int(4) NOT NULL DEFAULT 0,
  `MobileBank` int(4) NOT NULL DEFAULT 0,
  `Work` int(4) NOT NULL DEFAULT -1,
  `wSkill` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1|1|1|1|1',
  `wSkillCount` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0|0|0|0|0',
  `RefTime` int(11) NOT NULL DEFAULT 0,
  `RefPay` int(11) NOT NULL DEFAULT 0,
  `Snow` int(11) NOT NULL DEFAULT 0,
  `Game` int(11) NOT NULL DEFAULT 0,
  `Dialog` int(11) NOT NULL DEFAULT 0,
  `SettingTD` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1|1|1|1|1',
  `pGoogle` int(11) NOT NULL DEFAULT 0,
  `pGoogleKey` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `TaxiLicense` int(11) NOT NULL DEFAULT 0,
  `Billet` int(4) NOT NULL DEFAULT 0,
  `BilletTime` int(11) NOT NULL DEFAULT 0,
  `AllDonate` int(11) NOT NULL DEFAULT 0,
  `GiveCoin` int(11) NOT NULL DEFAULT 0,
  `GiveCar` int(11) NOT NULL DEFAULT 0,
  `Love` int(4) NOT NULL DEFAULT 3,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `pVK` int(11) NOT NULL DEFAULT 0,
  `pGuard` int(11) NOT NULL DEFAULT 0,
  `dmkills` int(11) NOT NULL DEFAULT 0,
  `subfractionleader` int(11) NOT NULL DEFAULT 0,
  `subfraction` int(11) NOT NULL DEFAULT 0,
  `musiccar` int(11) NOT NULL DEFAULT 0,
  `prod_vostakk` int(11) NOT NULL DEFAULT 0,
  `gift_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `referal`, `ip`, `admin`, `securitycode`, `checkcode`, `mail`, `level`, `cash`, `bank`, `exp`, `regip`, `datareg`, `leader`, `member`, `rank`, `warn`, `sex`, `age`, `model`, `memberskin`, `lic`, `guns`, `ammos`, `mute`, `mutereason`, `defeetkart`, `winkart`, `pick`, `checktime`, `news`, `phone`, `phonenumber`, `text`, `jail`, `jailtime`, `jailreason`, `wanted`, `wantedwho`, `wantedreason`, `married`, `whomarried`, `paycheck`, `charity`, `vip`, `vip_time`, `time`, `fstyle`, `credits`, `skin1`, `skin2`, `skin3`, `spawnchange`, `sdpistol`, `deserteagle`, `shotgun`, `mp5`, `ak47`, `m4`, `pistol`, `microuzi`, `sportexp`, `online`, `zakon`, `sprunk`, `phonebalance`, `aptechka`, `Voennik`, `music`, `improves`, `datavhod`, `settings`, `phnumber1`, `phnumber2`, `phnumber3`, `phnumber4`, `phnumber5`, `phnumber6`, `phnumber7`, `phnumber8`, `mailconf`, `family`, `familysozd`, `familyzam`, `black0`, `black1`, `black2`, `black3`, `black4`, `black5`, `black6`, `black7`, `black8`, `black9`, `black10`, `black11`, `black12`, `set1`, `set2`, `set3`, `set4`, `set5`, `set6`, `set7`, `donatepay`, `garage`, `familyrank`, `lwarn`, `countcars`, `leaderstats`, `mats`, `bonusday`, `bonusdaytime`, `mainbankaccount`, `LockPick`, `twarn`, `clips`, `togphone`, `house`, `business`, `house_arend`, `room`, `restore_hash`, `day`, `mainsub`, `scoreivent`, `sub_invited`, `sub_uninvited`, `sub_twarns`, `pTaxiJob`, `pTaxiKey`, `pTaxiFree`, `pEQuestBeach`, `pEQuestGos`, `pEQuestGang`, `pEQuestMaf`, `pVostAccBlat`, `vostslegacy`, `pVostAccBlatU`, `pPumpkin`, `pEuro`, `GunPack`, `MobileBank`, `Work`, `wSkill`, `wSkillCount`, `RefTime`, `RefPay`, `Snow`, `Game`, `Dialog`, `SettingTD`, `pGoogle`, `pGoogleKey`, `TaxiLicense`, `Billet`, `BilletTime`, `AllDonate`, `GiveCoin`, `GiveCar`, `Love`, `user_id`, `pVK`, `pGuard`, `dmkills`, `subfractionleader`, `subfraction`, `musiccar`, `prod_vostakk`, `gift_count`) VALUES
(1, 'Romulus', '123456', 'None', '83.220.93.31', 0, 0, 0, 'romulustx@mail.ru', 99, 77438999, 250, 2, '83.220.95.86', '28.07.2021', 0, 0, 0, 0, 1, 27, 23, 0, '1, 1, 1, 1, 1', '0,0,0,0,0,0,0,0,0,0,0,0,0', '0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 'None', 0, 0, 0, 916, 0, '0, 0', 0, '81, 0, 0, 0', 0, 0, 'None', 0, 'None', 'None', 0, 'None', 0, 0, -1, 0, 2, 0, 36845, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1001, 0, 7000, 0, 0, 0, 0, '0, 0, 0, 0', '9.8.2021', '0,1,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 25, '0,0,0,0,0,0', 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, NULL, 9, 0, 0, 0, 0, 0, -1, -1, 0, '0', '0', '0', '0', 0, 0, 0, 0, 380, 0, 0, -1, '1|1|1|1|1', '0|0|0|0|0', 4509, 0, 0, 0, 0, '0|1|1|1', 0, 'None', 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 'Larry_Torres', '123456', 'None', '8.20.126.16', 12, 0, 0, 'dasdasdsa@mail.ru', 99, 100298799, 250, 4, '8.21.110.101', '29.07.2021', 5, 5, 10, 0, 1, 23, 21, 109, '1, 1, 1, 1, 1', '0,0,0,0,0,0,0,0,0,0,0,0,0', '0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 'None', 0, 0, 0, 2716, 0, '0, 0', 0, '0, 0, 0, 0', 0, 0, 'None', 0, 'None', 'None', 0, 'None', 0, 0, -1, -1, 4, 0, 950, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1001, 0, 7000, 0, 0, 0, 0, '0, 0, 0, 0', '9.8.2021', '0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 5, '8193,0,0,0,0,0', 0, 3, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, NULL, 9, 0, 0, 0, 0, 0, -1, -1, 0, '0', '0', '0', '0', 0, 0, 0, 0, 0, 0, 0, -1, '1|1|1|1|1', '0|0|0|0|0', 5629, 0, 0, 0, 0, '1|1|1|1|1', 0, 'None', 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 'Ilya_Macalister', '123456', 'None', '8.20.127.53', 0, 0, 0, '32131@gmail.com', 99, 100099999, 250, 0, '8.20.127.53', '07.08.2021', 0, 0, 0, 0, 1, 19, 26, 0, '1, 1, 1, 1, 1', '0,0,0,0,0,0,0,0,0,0,0,0,0', '0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 'None', 0, 0, 0, 292, 0, '0, 0', 0, '0, 0, 0, 0', 0, 0, 'None', 0, 'None', 'None', 0, 'None', 0, 0, -1, -1, 0, 0, 1000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1001, 0, 7000, 0, 0, 0, 0, '0, 0, 0, 0', '8.8.2021', '0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 6, '0,0,0,0,0,0', 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, NULL, 8, 0, 0, 0, 0, 0, -1, -1, 0, '0', '0', '0', '0', 0, 0, 0, 0, 0, 0, 0, -1, '1|1|1|1|1', '0|0|0|0|0', 292, 0, 0, 0, 0, '1|1|1|1|1', 0, 'None', 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 'Scays_Fresko', '2157663', 'None', '195.19.122.237', 12, 0, 0, 'sdaksdkK@bk.ru', 8, 30100000, 250, 0, '195.19.122.237', '14.12.2023', 5, 5, 10, 0, 1, 20, 21, 109, '1, 1, 1, 1, 1', '0,0,0,0,0,0,0,0,0,0,0,0,0', '0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 'None', 0, 0, 0, 238, 0, '0, 0', 0, '0, 0, 0, 0', 0, 0, 'None', 0, 'None', 'None', 0, 'None', 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1001, 0, 7000, 0, 0, 0, 0, '0, 0, 0, 0', '14.12.2023', '0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 3, '83,0,0,0,0,0', 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, -1, -1, NULL, 14, 0, 0, 0, 0, 0, -1, -1, 0, '0', '0', '0', '0', 0, 0, 0, 0, 0, 0, 0, -1, '1|1|1|1|1', '0|0|0|0|0', 238, 0, 0, 0, 0, '1|1|1|1|1', 0, 'None', 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `accounts_accessories`
--

CREATE TABLE `accounts_accessories` (
  `id` int(11) NOT NULL,
  `owner` int(11) UNSIGNED DEFAULT NULL,
  `name` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL,
  `objectid` int(11) NOT NULL DEFAULT 0,
  `object_x` float NOT NULL DEFAULT 0,
  `object_y` float NOT NULL DEFAULT 0,
  `object_z` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `accounts_online`
--

CREATE TABLE `accounts_online` (
  `id` int(11) UNSIGNED DEFAULT NULL,
  `online_monday` int(11) NOT NULL DEFAULT 0,
  `online_tuesday` int(11) NOT NULL DEFAULT 0,
  `online_wednesday` int(11) NOT NULL DEFAULT 0,
  `online_thursday` int(11) NOT NULL DEFAULT 0,
  `online_friday` int(11) NOT NULL DEFAULT 0,
  `online_saturday` int(11) NOT NULL DEFAULT 0,
  `online_sunday` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `accounts_online`
--

INSERT INTO `accounts_online` (`id`, `online_monday`, `online_tuesday`, `online_wednesday`, `online_thursday`, `online_friday`, `online_saturday`, `online_sunday`) VALUES
(1, 28, 0, 1724, 312, 287, 981, 381),
(2, 80, 0, 0, 3515, 0, 1935, 92),
(3, 0, 0, 0, 0, 0, 203, 85),
(4, 0, 0, 0, 0, 0, 235, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `actors`
--

CREATE TABLE `actors` (
  `actor_id` int(11) NOT NULL DEFAULT -1,
  `actor_skin` int(11) NOT NULL DEFAULT 0,
  `actor_position` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0, 0.0, 0.0, 0.0',
  `actor_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `actor_world` int(11) NOT NULL DEFAULT -1,
  `actor_int` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `admin`
--

CREATE TABLE `admin` (
  `name` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `level` int(2) NOT NULL DEFAULT 0,
  `password` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'qwerty',
  `last_connect` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `put_admin` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `data` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `a_goto` int(1) NOT NULL DEFAULT 0,
  `a_gethere` int(1) NOT NULL DEFAULT 0,
  `a_spec` int(1) NOT NULL DEFAULT 0,
  `timemin` int(11) NOT NULL DEFAULT 0,
  `awarn` int(11) NOT NULL DEFAULT 0,
  `act_time` int(11) NOT NULL DEFAULT 0,
  `warnreason` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'None',
  `timeday` int(11) NOT NULL DEFAULT 0,
  `ans` int(11) NOT NULL DEFAULT 0,
  `warns` int(11) NOT NULL DEFAULT 0,
  `kicks` int(11) NOT NULL DEFAULT 0,
  `bans` int(11) NOT NULL DEFAULT 0,
  `mutes` int(11) NOT NULL DEFAULT 0,
  `jails` int(11) NOT NULL DEFAULT 0,
  `last_ans_text` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_warn_text` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_kick_text` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_ban_text` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_mute_text` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_jail_text` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `day` int(11) DEFAULT 3,
  `buyadmin` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `admin`
--

INSERT INTO `admin` (`name`, `level`, `password`, `last_connect`, `put_admin`, `data`, `a_goto`, `a_gethere`, `a_spec`, `timemin`, `awarn`, `act_time`, `warnreason`, `timeday`, `ans`, `warns`, `kicks`, `bans`, `mutes`, `jails`, `last_ans_text`, `last_warn_text`, `last_kick_text`, `last_ban_text`, `last_mute_text`, `last_jail_text`, `day`, `buyadmin`) VALUES
('Feliks_Macalister', 12, '228322', '4.5.2021', 'Larry_Torres', '13.01.2021', 0, 0, 0, 0, 0, 3756, 'None', 0, 0, 0, 0, 0, 0, 0, '', '', '', '', '', '', 1622725247, 0),
('Ilya_Macalister', 12, '123123', '8.8.2021', 'Feliks_Macalister', '08.02.2021', 0, 0, 0, 0, 0, 8074, 'None', 0, 0, 0, 0, 0, 3, 0, '', '', '', '', '', '', 1630966734, 0),
('Larry_Torres', 11, '228322', '8.8.2021', NULL, NULL, 0, 0, 0, 0, 0, 17681, 'None', 0, 0, 0, 0, 0, 0, 0, '', '', '', '', '', '', 1630966970, 0),
('Romulus', 12, 'kek', '7.8.2021', '', '', 0, 0, 0, 0, 0, 1455, 'None', 0, 0, 0, 0, 0, 0, 0, '', '', '', '', '', '', 1628288014, 0),
('Scays_Fresko', 12, '1', '14.12.2023', 'Beach', '21.03.2021', 0, 0, 0, 0, 0, 1097, 'None', 0, 0, 0, 0, 0, 0, 0, '', '', '', '', '', '', 1702547500, 0),
('Shadow_Dev', 12, '707909', '16.5.2021', NULL, NULL, 0, 0, 0, 0, 0, 9392, 'None', 0, 7, 0, 0, 0, 1, 1, '', '', '', '', '', '', 1621189873, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `atm`
--

CREATE TABLE `atm` (
  `ID` int(11) UNSIGNED NOT NULL,
  `aX` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `aY` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `aZ` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `arX` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `arY` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `arZ` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='TODO: Хранить координаты в формате с плавающей точкой, а не в виде строк\r\n\r\n@ Artem Smirnov';

--
-- Дамп данных таблицы `atm`
--

INSERT INTO `atm` (`ID`, `aX`, `aY`, `aZ`, `arX`, `arY`, `arZ`) VALUES
(1, '149.429', '783.173', '11.145', '0.0', '0.3', '-80.7'),
(2, '473.187', '1627.88', '11.158', '0.0', '0.0', '136.2'),
(3, '1851.391', '2243.426', '14.243', '0.0', '0.0', '-89.2'),
(4, '443.945', '367.431', '11.013', '0.0', '0.0', '-107.6'),
(5, '2515.497', '-2136.129', '20.947', '0.0', '0.0', '-89.3');

-- --------------------------------------------------------

--
-- Структура таблицы `bank_accounts`
--

CREATE TABLE `bank_accounts` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) DEFAULT NULL,
  `name` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `reg_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `bank_accounts`
--

INSERT INTO `bank_accounts` (`id`, `type`, `owner`, `name`, `balance`, `reg_time`) VALUES
(1, 0, 1, 'Основной счёт', 69450, '2021-08-06 20:59:59'),
(2, 0, 2, 'Основной счёт', 29700, '2021-07-29 17:59:59'),
(3, 0, 3, 'Основной счёт', 0, '2021-08-07 19:40:28'),
(4, 0, 4, 'Основной счёт', 0, '2023-12-14 07:53:15');

-- --------------------------------------------------------

--
-- Структура таблицы `bank_accounts_logs`
--

CREATE TABLE `bank_accounts_logs` (
  `id` int(11) NOT NULL,
  `account` int(11) DEFAULT NULL,
  `ip` varchar(16) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0.0.0.0',
  `reason` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `bank_accounts_logs`
--

INSERT INTO `bank_accounts_logs` (`id`, `account`, `ip`, `reason`, `time`) VALUES
(1, 2, '8.21.110.101', '+ Переводы в банке 14850 рублей', '2021-07-29 10:00:03'),
(2, 2, '178.204.4.221', '+ Переводы в банке 14850 рублей', '2021-07-29 17:59:59'),
(3, 1, '83.220.90.204', '+ Переводы в банке 14850 рублей', '2021-07-31 22:59:57'),
(4, 1, '83.220.75.196', '+ Переводы в банке 27300 рублей', '2021-08-06 19:59:57'),
(5, 1, '83.220.75.196', '+ Переводы в банке 27300 рублей', '2021-08-06 20:59:59'),
(6, 1, '83.220.75.196', '+ Продажа квартиры 1200000 рублей', '2021-08-06 21:23:34');

-- --------------------------------------------------------

--
-- Структура таблицы `bans`
--

CREATE TABLE `bans` (
  `name` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `whobanned` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ip` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `bandate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time` int(11) NOT NULL DEFAULT 0,
  `unbandate` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `reason` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `binder_message`
--

CREATE TABLE `binder_message` (
  `account_id` int(11) NOT NULL DEFAULT -1,
  `text_1` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №1',
  `text_2` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №2',
  `text_3` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №3',
  `text_4` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №4',
  `text_5` varchar(128) NOT NULL DEFAULT 'Введите текст для поля №5'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `bizz`
--

CREATE TABLE `bizz` (
  `id` int(11) NOT NULL,
  `owner` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'None',
  `owned` int(11) NOT NULL DEFAULT -1,
  `type` int(11) NOT NULL DEFAULT 1,
  `price` int(11) NOT NULL DEFAULT 100000,
  `buyprice` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 500000,
  `lic` int(11) NOT NULL DEFAULT 0,
  `x` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `y` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `z` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `xt` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `yt` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `zt` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `menux` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `menuy` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `menuz` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `vint` int(11) NOT NULL DEFAULT 0,
  `virt` int(11) NOT NULL DEFAULT 0,
  `icon` int(11) NOT NULL DEFAULT 4,
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `penter` int(11) NOT NULL DEFAULT 100,
  `block` int(11) NOT NULL DEFAULT 0,
  `product` int(11) NOT NULL DEFAULT 0,
  `till` int(11) NOT NULL DEFAULT 50,
  `locktime` int(11) NOT NULL DEFAULT 0,
  `mafia` int(11) NOT NULL DEFAULT 0,
  `oplata` int(20) NOT NULL DEFAULT 0,
  `update_biz` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `bizz`
--

INSERT INTO `bizz` (`id`, `owner`, `owned`, `type`, `price`, `buyprice`, `money`, `lic`, `x`, `y`, `z`, `xt`, `yt`, `zt`, `menux`, `menuy`, `menuz`, `vint`, `virt`, `icon`, `name`, `penter`, `block`, `product`, `till`, `locktime`, `mafia`, `oplata`, `update_biz`) VALUES
(1, 'None', -1, 7, 450000, 0, 408050, 0, '-391.953', '1009.486', '12.145', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 1, 27, 'СТО', 0, 0, 47195, 50, 0, 0, 0, 5),
(2, 'None', -1, 7, 450000, 0, 20000, 0, '2568.269', '-1768.548', '21.72', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 2, 27, 'АЗС', 0, 0, 49750, 50, 0, 0, 0, 0),
(3, 'None', -1, 1, 540000, 0, 0, 0, '2511.679', '-2169.639', '21.977', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 3, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(4, 'None', -1, 9, 1000000, 0, 0, 0, '-110.38', '985.992', '12.756', '-111.788', '-40.774', '1298.008', '2476.768', '1323.099', '3125.571', 22, 4, 25, 'Казино', 0, 0, 50000, 50, 0, 0, 0, 0),
(5, 'None', -1, 9, 1000000, 0, 0, 0, '2349.95', '-2138.315', '22.585', '-111.788', '-40.774', '1298.008', '2476.768', '1323.099', '3125.571', 22, 5, 25, 'Казино \"Южный\"', 0, 0, 50000, 50, 0, 0, 0, 0),
(6, 'None', -1, 1, 540000, 0, 0, 0, '-42.345', '925.907', '12.332', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 6, 56, '24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(7, 'None', -1, 8, 410000, 0, 0, 0, '2261.099', '-2102.713', '21.969', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 7, 45, 'Магазин аксессуаров', 0, 0, 50000, 50, 0, 0, 0, 1),
(8, 'None', -1, 8, 410000, 0, 250000, 0, '-40.565', '925.242', '12.332', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 8, 45, 'Магазин одежды', 0, 0, 30000, 50, 0, 0, 0, 1),
(9, 'None', -1, 8, 410000, 0, 0, 0, '2261.105', '-2107.214', '21.969', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 9, 45, 'Магазин одежды', 0, 0, 50000, 50, 0, 0, 0, 1),
(10, 'None', -1, 1, 540000, 0, 0, 0, '12.953', '911.018', '12.301', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 10, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(11, 'None', -1, 6, 800000, 0, 7695, 0, '-6.07', '911.92', '12.0', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 11, 18, 'Магазин оружия', 0, 0, 19280, 50, 0, 0, 0, 6),
(12, 'None', -1, 1, 540000, 0, 0, 0, '2619.18', '-2469.131', '22.018', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 12, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(13, 'None', -1, 1, 540000, 0, 0, 0, '2235.864', '-1738.983', '21.962', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 13, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 1),
(14, 'None', -1, 2, 500000, 0, 0, 0, '-4.336', '911.271', '12.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 14, 47, 'Аксессуары', 0, 0, 5000, 50, 0, 0, 0, 6),
(15, 'None', -1, 2, 500000, 0, 750, 0, '2245.596', '-1785.016', '21.709', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 15, 47, 'АЗС', 0, 0, 4970, 50, 0, 0, 0, 12),
(16, 'None', -1, 1, 540000, 0, 0, 0, '2619.607', '-1835.717', '21.964', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 16, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(17, 'None', -1, 7, 450000, 0, 0, 0, '2153.325', '-1847.319', '18.82', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 17, 27, 'СТО', 0, 0, 50000, 50, 0, 0, 0, 9),
(18, 'None', -1, 1, 540000, 0, 0, 0, '302.866', '1664.588', '12.431', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 18, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(19, 'None', -1, 6, 800000, 0, 0, 0, '305.515', '1650.025', '12.861', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 19, 18, 'Магазин оружия', 0, 0, 20000, 50, 0, 0, 0, 4),
(20, 'None', -1, 10, 3000000, 0, 0, 0, '300.351', '1784.202', '12.203', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 20, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 2),
(21, 'None', -1, 1, 540000, 0, 0, 0, '346.785', '1632.736', '12.0', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 21, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(22, 'None', -1, 10, 3000000, 0, 0, 0, '287.019', '1509.959', '12.098', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 22, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 1),
(23, 'None', -1, 10, 3000000, 0, 0, 0, '216.609', '860.574', '13.382', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 23, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 1),
(24, 'None', -1, 1, 540000, 0, 0, 0, '207.54', '829.681', '13.383', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 24, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(25, 'None', -1, 8, 410000, 0, 125000, 0, '203.548', '828.686', '13.383', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 25, 45, 'Магазин одежды', 0, 0, 40000, 50, 0, 0, 0, 0),
(26, 'None', -1, 6, 800000, 0, 0, 0, '150.428', '776.213', '12.154', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 26, 18, 'Магазин оружия', 0, 0, 20000, 50, 0, 0, 0, 2),
(27, 'None', -1, 7, 450000, 0, 0, 0, '2423.566', '-2306.548', '21.972', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 27, 27, 'СТО', 0, 0, 50000, 50, 0, 0, 0, 4),
(28, 'None', -1, 1, 540000, 0, 0, 0, '323.242', '778.95', '12.172', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 28, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(29, 'None', -1, 10, 3000000, 0, 0, 0, '400.912', '748.279', '12.0', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 29, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 0),
(30, 'None', -1, 1, 540000, 0, 0, 0, '-314.753', '410.421', '13.114', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 30, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(31, 'None', -1, 6, 800000, 0, 0, 0, '-315.95', '401.511', '13.599', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 31, 18, 'Магазин оружия', 0, 0, 20000, 50, 0, 0, 0, 2),
(32, 'None', -1, 1, 540000, 0, 0, 0, '-390.804', '953.109', '12.142', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 32, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 1),
(33, 'None', -1, 8, 410000, 0, 0, 0, '-335.52', '986.532', '12.149', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 33, 45, 'Магазин одежды', 0, 0, 50000, 50, 0, 0, 0, 0),
(34, 'None', -1, 10, 3000000, 0, 0, 0, '35.624', '885.05', '12.258', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 34, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 1),
(35, 'None', -1, 6, 800000, 0, 0, 0, '393.781', '949.404', '12.263', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 35, 18, 'Магазин оружия', 0, 0, 20000, 50, 0, 0, 0, 5),
(36, 'None', -1, 1, 540000, 0, 0, 0, '385.613', '930.162', '12.052', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 36, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 1),
(37, 'None', -1, 8, 410000, 0, 0, 0, '253.796', '1055.134', '12.256', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 37, 45, 'Магазин одежды', 0, 0, 50000, 50, 0, 0, 0, 2),
(38, 'None', -1, 8, 410000, 0, 0, 0, '164.641', '719.82', '12.749', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 38, 45, 'Магазин одежды', 0, 0, 50000, 50, 0, 0, 0, 2),
(39, 'None', -1, 6, 800000, 0, 0, 0, '171.984', '738.451', '12.749', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 39, 18, 'Магазин оружия', 0, 0, 20000, 50, 0, 0, 0, 2),
(40, 'None', -1, 10, 3000000, 0, 0, 0, '153.933', '696.981', '12.765', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 40, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 0),
(41, 'None', -1, 1, 540000, 0, 0, 0, '2199.143', '-1773.773', '22.736', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 41, 56, 'Аммунация', 0, 0, 5000, 50, 0, 0, 0, 0),
(42, 'None', -1, 1, 540000, 0, 0, 0, '155.962', '572.791', '12.219', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 42, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 1),
(43, 'None', -1, 1, 540000, 0, 0, 0, '131.679', '662.963', '12.765', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 43, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 1),
(44, 'None', -1, 2, 500000, 0, 0, 0, '675.409', '484.051', '12.002', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 44, 47, 'Заправка', 0, 0, 5000, 50, 0, 0, 0, 2),
(45, 'None', -1, 10, 3000000, 0, 0, 0, '-310.201', '447.5', '13.107', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 45, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 0),
(46, 'None', -1, 6, 800000, 0, 0, 0, '-97.462', '986.593', '12.756', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 46, 18, 'Магазин оружия', 0, 0, 20000, 50, 0, 0, 0, 6),
(47, 'None', -1, 1, 540000, 0, 0, 0, '2310.547', '-1926.169', '21.965', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 47, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(48, 'None', -1, 1, 540000, 0, 0, 0, '63.911', '654.442', '12.722', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 48, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(49, 'None', -1, 1, 540000, 0, 0, 0, '1867.714', '1383.158', '9.799', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 49, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 3),
(50, 'None', -1, 1, 540000, 0, 0, 0, '571.317', '646.227', '12.213', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 50, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 0),
(51, 'None', -1, 7, 450000, 0, 0, 0, '2029.308', '1897.549', '15.824', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 51, 27, 'СТО', 0, 0, 50000, 50, 0, 0, 0, 2),
(52, 'None', -1, 8, 410000, 0, 0, 0, '1945.779', '2068.987', '16.199', '2698.342', '295.662', '1401.0', '2697.64', '300.375', '1401.0', 15, 52, 45, 'Магазин одежды', 0, 0, 50000, 50, 0, 0, 0, 1),
(53, 'None', -1, 10, 3000000, 0, 0, 0, '1921.683', '2092.957', '16.199', '2698.342', '295.662', '1401.0', '2697.64', '300.33', '1401.0', 15, 53, 45, 'Магазин аксессуаров', 0, 0, 10000, 50, 0, 0, 0, 1),
(54, 'None', -1, 1, 540000, 0, 0, 0, '1949.886', '1912.755', '15.465', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 54, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(55, 'None', -1, 1, 540000, 0, 0, 0, '1856.457', '2251.376', '15.617', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 55, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 11),
(56, 'None', -1, 7, 450000, 0, 0, 0, '215.986', '1486.49', '11.933', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 56, 27, 'СТО', 0, 0, 50000, 50, 0, 0, 0, 2),
(57, 'None', -1, 1, 540000, 0, 0, 0, '283.782', '1273.841', '12.002', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 57, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 3),
(58, 'None', -1, 1, 540000, 0, 0, 0, '2409.093', '-2140.519', '22.729', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 58, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(59, 'None', -1, 1, 540000, 0, 0, 0, '2096.736', '-1002.377', '2.234', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 59, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(60, 'None', -1, 2, 500000, 0, 0, 0, '1741.662', '2261.124', '15.867', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 60, 47, 'АЗС \"Автостанция\"', 0, 0, 5000, 50, 0, 0, 0, 0),
(61, 'None', -1, 1, 540000, 0, 0, 0, '-333.61', '1309.415', '12.72', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 61, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 1),
(62, 'None', -1, 6, 800000, 0, 1500, 0, '109.928', '574.941', '13.271', '17.486', '-1114.654', '1029.782', '22.063', '-1106.663', '1029.782', 5, 62, 18, 'Аммунация', 0, 0, 19502, 50, 0, 0, 0, 2),
(63, 'None', -1, 1, 540000, 0, 0, 0, '-335.022', '935.16', '13.181', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 63, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 2),
(64, 'None', -1, 1, 540000, 0, 0, 0, '2323.453', '-2550.777', '21.785', '2099.024', '-4.382', '1398.863', '2103.441', '-1.158', '1398.855', 3, 64, 56, 'Магазин 24/7', 0, 0, 5000, 50, 0, 0, 0, 1),
(65, 'None', -1, 7, 450000, 0, 0, 0, '2350.257', '-2610.425', '21.789', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0, 65, 27, 'СТО', 0, 0, 50000, 50, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `buy_packages`
--

CREATE TABLE `buy_packages` (
  `id` int(11) NOT NULL,
  `username` varchar(24) NOT NULL,
  `id_packages` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `family_cars`
--

CREATE TABLE `family_cars` (
  `id` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `x` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `y` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `z` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `fa` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `vint` int(11) NOT NULL DEFAULT 0,
  `world` int(11) NOT NULL DEFAULT 0,
  `family` int(11) NOT NULL DEFAULT 0,
  `color1` int(11) NOT NULL DEFAULT 0,
  `color2` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0,
  `cost` int(11) NOT NULL DEFAULT 0,
  `mileage` float NOT NULL DEFAULT 0,
  `dostup` int(11) NOT NULL DEFAULT 1,
  `fuel` int(11) NOT NULL DEFAULT 45
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `family_cars`
--

INSERT INTO `family_cars` (`id`, `model`, `x`, `y`, `z`, `fa`, `vint`, `world`, `family`, `color1`, `color2`, `status`, `cost`, `mileage`, `dostup`, `fuel`) VALUES
(3, 490, '1871.424072', '2834.130615', '11.886343', '267.574890', 0, 0, 7, 0, 9, 0, 4700000, 0, 1, 45),
(4, 490, '1878.224853', '2833.684570', '11.809400', '268.063110', 0, 0, 7, 0, 8, 0, 4700000, 0, 1, 45),
(5, 490, '1884.699096', '2834.005126', '11.874904', '269.450042', 0, 0, 7, 0, 1, 0, 4700000, 0, 1, 45),
(10, 490, '1782.291503', '2190.083007', '16.055568', '335.347534', 0, 0, 8, 0, 0, 0, 4700000, 0, 1, 45),
(11, 400, '1889.003662', '2837.363525', '12.030572', '90.115219', 0, 0, 7, 0, 8, 0, 2300000, 0, 1, 45),
(12, 400, '1890.085937', '2842.862304', '12.029414', '86.562683', 0, 0, 7, 0, 8, 0, 2300000, 0, 1, 45),
(20, 490, '-273.482757', '1252.142333', '12.673963', '358.982971', 0, 0, 3, 0, 9, 0, 4700000, 0, 1, 45),
(25, 502, '2064.418457', '-1001.449829', '2.028766', '180.378204', 0, 0, 12, 0, 1, 0, 630000, 0, 1, 45),
(26, 567, '2070.714843', '-995.677368', '2.142265', '179.371627', 0, 0, 12, 0, 1, 0, 2200000, 0, 1, 45),
(27, 466, '2078.410156', '-1009.161682', '2.043737', '359.672271', 0, 0, 12, 0, 1, 0, 4800000, 0, 1, 45),
(28, 429, '-253.502212', '1266.804687', '12.312440', '87.747863', 0, 0, 3, 0, 1, 0, 2200000, 0, 1, 45),
(29, 466, '-253.380645', '1263.672607', '12.446814', '89.849777', 0, 0, 3, 0, 6, 0, 4800000, 0, 1, 45),
(31, 400, '2074.763427', '-996.065979', '2.131362', '179.841735', 0, 0, 12, 0, 0, 0, 2300000, 0, 1, 45),
(33, 534, '2178.895996', '-1015.081115', '1.962482', '134.140029', 0, 0, 10, 103, 0, 0, 1900000, 0, 1, 45),
(34, 502, '1811.810302', '1355.061157', '9.562913', '271.462036', 0, 0, 11, 101, 3, 0, 630000, 0, 1, 45),
(35, 490, '1812.647460', '1350.346923', '9.685270', '271.276153', 0, 0, 11, 101, 3, 0, 4700000, 0, 1, 45),
(36, 506, '1819.672729', '1350.091064', '9.464208', '271.905273', 0, 0, 11, 101, 3, 0, 2900000, 0, 1, 45),
(37, 400, '1818.489990', '1355.239868', '9.666408', '272.006469', 0, 0, 11, 101, 3, 0, 2300000, 0, 1, 45),
(39, 466, '1817.632446', '1359.294555', '9.581742', '267.581909', 0, 0, 11, 101, 3, 0, 4800000, 0, 1, 45),
(40, 451, '1808.832763', '2158.937744', '15.555726', '0.735585', 0, 0, 15, 3, 3, 0, 5000000, 0, 1, 45),
(43, 505, '-270.874328', '1252.266113', '12.792875', '358.010772', 0, 0, 3, 0, 6, 0, 4750000, 0, 1, 45),
(52, 466, '2405.196289', '-2513.699218', '21.586246', '179.827011', 0, 0, 16, 3, 0, 0, 4800000, 0, 1, 45),
(53, 502, '2408.240478', '-2513.667968', '21.568218', '179.947647', 0, 0, 16, 3, 5, 0, 630000, 0, 1, 45),
(54, 490, '2400.342285', '-2514.243408', '21.695558', '181.374755', 0, 0, 16, 3, 7, 0, 4700000, 0, 1, 45),
(55, 429, '2411.799072', '-2513.618164', '21.276067', '177.622482', 0, 0, 16, 3, 7, 0, 2200000, 0, 1, 45),
(58, 490, '2257.814453', '-942.933959', '2.151775', '90.360466', 0, 0, 18, 0, 4, 0, 4700000, 0, 1, 45),
(59, 490, '2257.966552', '-946.277038', '2.111958', '91.166397', 0, 0, 18, 8, 4, 0, 4700000, 0, 1, 45),
(60, 502, '2253.507812', '-936.999755', '2.145998', '313.054260', 0, 0, 18, 3, 3, 0, 630000, 0, 1, 45),
(61, 567, '2261.291748', '-937.200134', '2.267354', '322.036987', 0, 0, 18, 86, 1, 0, 2200000, 0, 1, 45),
(62, 506, '2257.452880', '-937.069274', '2.054292', '314.492218', 0, 0, 18, 101, 9, 0, 2900000, 0, 1, 45),
(68, 451, '2414.999023', '-2513.590087', '21.443056', '180.753555', 0, 0, 16, 3, 7, 0, 5000000, 0, 1, 45),
(70, 490, '1800.941406', '2152.459716', '15.746950', '1.542320', 0, 0, 15, 3, 9, 0, 4700000, 0, 1, 45),
(75, 490, '2357.991943', '-954.954650', '2.114935', '359.980041', 0, 0, 19, 0, 1, 0, 4700000, 0, 1, 45),
(76, 400, '2354.950439', '-956.163635', '2.133780', '357.861511', 0, 0, 19, 0, 1, 0, 2300000, 0, 1, 45),
(77, 466, '2352.094970', '-956.376953', '2.045657', '0.612311', 0, 0, 19, 0, 9, 0, 4800000, 0, 1, 45),
(79, 429, '1843.882690', '2190.627441', '15.279855', '268.581756', 0, 0, 13, 3, 8, 0, 2200000, 0, 1, 45),
(80, 404, '2367.864013', '-941.441650', '2.088541', '89.475723', 0, 0, 19, 0, 4, 0, 4200000, 0, 1, 45),
(81, 411, '1856.973510', '2204.230468', '15.624396', '178.300720', 0, 0, 13, 3, 1, 0, 1200000, 0, 1, 45),
(82, 567, '1843.592041', '2187.090576', '15.600522', '268.862762', 0, 0, 13, 3, 0, 0, 2200000, 0, 1, 45),
(83, 490, '1778.819702', '2190.387939', '16.046497', '332.472686', 0, 0, 8, 0, 1, 0, 4700000, 0, 1, 45),
(86, 490, '1785.781494', '2189.752929', '16.053945', '334.764099', 0, 0, 8, 0, 1, 0, 4700000, 0, 1, 45),
(87, 429, '2348.921630', '-956.101867', '1.735558', '0.374823', 0, 0, 19, 0, 1, 0, 2200000, 0, 1, 45),
(89, 490, '1843.390136', '2183.476806', '15.551139', '268.320678', 0, 0, 13, 3, 8, 0, 4700000, 0, 1, 45),
(90, 490, '1789.755859', '2189.963867', '16.054315', '328.515167', 0, 0, 8, 0, 1, 0, 4700000, 0, 1, 45),
(91, 490, '0', '0', '0', '0', 0, 0, 14, 0, 6, 0, 4700000, 0, 1, 45),
(92, 490, '0', '0', '0', '0', 0, 0, 14, 0, 6, 0, 4700000, 0, 1, 45),
(93, 429, '1793.942382', '2159.434082', '15.542389', '3.411623', 0, 0, 15, 3, 7, 0, 2200000, 0, 1, 45),
(94, 490, '1796.796020', '2152.574707', '15.851981', '3.158122', 0, 0, 15, 3, 3, 0, 4700000, 0, 1, 45),
(95, 490, '1805.347167', '2152.692382', '15.660730', '1.731126', 0, 0, 15, 3, 0, 0, 4700000, 0, 1, 45),
(96, 490, '2130.538330', '-996.784179', '2.110566', '181.493606', 0, 0, 20, 0, 6, 0, 4700000, 0, 1, 45),
(97, 429, '2119.099365', '-1014.734863', '1.930122', '231.060714', 0, 0, 20, 0, 9, 0, 2200000, 0, 1, 45),
(98, 429, '2124.907226', '-1014.960205', '1.940475', '233.927917', 0, 0, 20, 0, 2, 0, 2200000, 0, 1, 45),
(99, 490, '2129.459228', '-1015.653137', '2.241613', '206.423950', 0, 0, 20, 0, 7, 0, 4700000, 0, 1, 45),
(100, 529, '2144.457031', '-1013.964477', '2.104094', '126.786994', 0, 0, 20, 1, 6, 0, 800000, 0, 1, 45),
(103, 490, '1796.963378', '2355.509521', '15.304827', '304.888244', 0, 0, 9, 0, 9, 0, 4700000, 0, 1, 45),
(104, 490, '1798.999389', '2352.816406', '15.308806', '303.426452', 0, 0, 9, 0, 0, 0, 4700000, 0, 1, 45),
(106, 429, '0', '0', '0', '0', 0, 0, 9, 0, 0, 0, 2200000, 0, 1, 45),
(107, 429, '1760.484985', '2422.947265', '14.941478', '214.917648', 0, 0, 9, 0, 0, 0, 2200000, 0, 1, 45),
(111, 400, '2517.671142', '-2624.495849', '21.994905', '51.332836', 0, 0, 21, 0, 3, 0, 2300000, 0, 1, 45),
(112, 429, '2519.630859', '-2621.852539', '21.630472', '54.116615', 0, 0, 21, 0, 5, 0, 2200000, 0, 1, 45),
(115, 490, '2521.187011', '-2618.808837', '21.890422', '54.596767', 0, 0, 21, 0, 4, 0, 4700000, 0, 1, 45),
(117, 502, '2193.042236', '-2215.207031', '21.847793', '359.245666', 0, 0, 24, 0, 3, 0, 630000, 0, 1, 45),
(118, 502, '2189.881103', '-2215.175048', '21.847831', '2.225367', 0, 0, 24, 0, 2, 0, 630000, 0, 1, 45),
(119, 490, '2186.761962', '-2215.015625', '21.931146', '359.138275', 0, 0, 24, 0, 1, 0, 4700000, 0, 1, 45),
(120, 490, '2183.152587', '-2215.237548', '21.931320', '1.197685', 0, 0, 24, 0, 4, 0, 4700000, 0, 1, 45),
(121, 506, '2525.787109', '-2612.427490', '21.712554', '62.748439', 0, 0, 21, 0, 7, 0, 2900000, 0, 1, 45),
(124, 429, '2173.341796', '-2203.113281', '21.610534', '180.817794', 0, 0, 24, 0, 9, 0, 2200000, 0, 1, 45),
(125, 502, '398.056213', '911.374023', '11.850037', '246.085464', 0, 0, 23, 0, 3, 0, 630000, 0, 1, 45),
(127, 490, '393.746337', '901.407592', '11.886413', '245.141510', 0, 0, 23, 0, 8, 0, 4700000, 0, 1, 45),
(128, 506, '397.008453', '908.757751', '11.705670', '250.728637', 0, 0, 23, 0, 5, 0, 2900000, 0, 1, 45),
(129, 400, '2299.777832', '-1045.838745', '2.215044', '1.922084', 0, 0, 25, 101, 3, 0, 2300000, 0, 1, 45),
(130, 490, '2295.330322', '-1046.260253', '2.109875', '0.062397', 0, 0, 25, 101, 3, 0, 4700000, 0, 1, 45),
(132, 502, '2313.312500', '-1032.688354', '2.026003', '89.865524', 0, 0, 25, 101, 3, 0, 630000, 0, 1, 45),
(133, 529, '2304.021240', '-1045.814575', '2.037718', '1.056725', 0, 0, 25, 101, 3, 0, 800000, 0, 1, 45),
(134, 490, '395.475402', '904.512939', '11.884321', '246.943130', 0, 0, 23, 0, 6, 0, 4700000, 0, 1, 45),
(135, 502, '398.867462', '914.289794', '11.801894', '248.074157', 0, 0, 23, 1, 8, 0, 630000, 0, 1, 45),
(136, 506, '2313.388427', '-1036.504150', '1.933892', '92.291770', 0, 0, 25, 101, 3, 0, 2900000, 0, 1, 45),
(140, 567, '0', '0', '0', '0', 0, 0, 3, 86, 0, 0, 2200000, 0, 1, 45),
(143, 489, '2059.334228', '-1010.503173', '2.166373', '270.492187', 0, 0, 12, 0, 8, 0, 300000, 0, 1, 45),
(144, 490, '2540.737304', '-2609.922607', '21.889480', '45.004531', 0, 0, 22, 123, 5, 0, 4700000, 0, 1, 45),
(146, 451, '2541.095458', '-2623.672363', '21.716670', '47.608371', 0, 0, 22, 123, 6, 0, 5000000, 0, 1, 45),
(147, 502, '2540.776367', '-2628.040527', '21.806632', '47.692928', 0, 0, 22, 123, 0, 0, 630000, 0, 1, 45),
(148, 505, '2540.843505', '-2614.594970', '22.087045', '46.100418', 0, 0, 22, 123, 4, 0, 4750000, 0, 1, 45),
(149, 411, '2541.102539', '-2619.042968', '21.693387', '46.120353', 0, 0, 22, 123, 9, 0, 1200000, 0, 1, 45),
(151, 490, '2241.754882', '-1032.761108', '2.112673', '272.827728', 0, 0, 17, 3, 8, 0, 4700000, 0, 1, 45),
(155, 466, '2523.594482', '-2615.735351', '21.788478', '58.312259', 0, 0, 21, 0, 7, 0, 4800000, 0, 1, 45),
(158, 404, '1781.886962', '2204.064941', '16.187602', '181.280212', 0, 0, 8, 0, 1, 0, 4200000, 0, 1, 45),
(159, 567, '-190.916717', '1054.242797', '11.927332', '269.505554', 0, 0, 28, 1, 0, 0, 2200000, 0, 1, 45),
(160, 429, '-190.994979', '1058.002685', '11.605446', '269.769927', 0, 0, 28, 1, 0, 0, 2200000, 0, 1, 45),
(162, 502, '-236.721771', '1253.577270', '12.527128', '302.149719', 0, 0, 27, 0, 5, 0, 630000, 0, 1, 45),
(165, 466, '-191.058654', '1061.274047', '11.780591', '271.302551', 0, 0, 28, 0, 0, 0, 4800000, 0, 1, 45),
(166, 490, '-190.441360', '1050.590942', '11.998478', '269.860107', 0, 0, 28, 0, 2, 0, 4700000, 0, 1, 45),
(167, 400, '-190.875320', '1065.318725', '11.989884', '269.126098', 0, 0, 28, 0, 0, 0, 2300000, 0, 1, 45),
(170, 490, '0', '0', '0', '0', 0, 0, 27, 0, 0, 0, 4700000, 0, 1, 45),
(171, 490, '-236.342910', '1260.173461', '12.609474', '307.693084', 0, 0, 27, 0, 9, 0, 4700000, 0, 1, 45),
(173, 451, '2465.615722', '-894.876831', '2.395605', '210.684753', 0, 0, 17, 3, 2, 0, 5000000, 0, 1, 45),
(175, 429, '2241.767822', '-1039.262084', '1.831446', '270.759277', 0, 0, 17, 3, 6, 0, 2200000, 0, 1, 45),
(176, 490, '1993.918334', '1335.377075', '25.973524', '181.706893', 0, 0, 32, 3, 8, 0, 4700000, 0, 1, 45),
(178, 529, '2016.846313', '1336.339599', '25.952920', '179.280700', 0, 0, 32, 3, 1, 0, 800000, 0, 1, 45),
(179, 529, '2013.299560', '1337.307739', '25.955860', '179.887069', 0, 0, 32, 3, 8, 0, 800000, 0, 1, 45),
(180, 567, '2008.573852', '1335.751342', '26.067352', '182.257949', 0, 0, 32, 3, 3, 0, 2200000, 0, 1, 45),
(181, 567, '1997.893066', '1336.055541', '26.072608', '180.431579', 0, 0, 32, 3, 9, 0, 2200000, 0, 1, 45),
(182, 451, '1843.879150', '2197.739990', '15.412257', '272.747924', 0, 0, 13, 3, 6, 0, 5000000, 0, 1, 45),
(183, 400, '2195.013671', '-1007.579284', '2.215874', '90.685272', 0, 0, 26, 0, 1, 0, 2300000, 0, 1, 45),
(184, 490, '2194.873046', '-998.303710', '2.110013', '89.388191', 0, 0, 26, 0, 6, 0, 4700000, 0, 1, 45),
(185, 490, '2194.826904', '-1004.612609', '2.109884', '91.778045', 0, 0, 26, 0, 8, 0, 4700000, 0, 1, 45),
(186, 567, '2195.281005', '-994.824340', '2.154251', '89.095428', 0, 0, 26, 0, 8, 0, 2200000, 0, 1, 45),
(187, 502, '2195.178955', '-1001.619384', '2.028246', '87.599082', 0, 0, 26, 0, 3, 0, 630000, 0, 1, 45),
(188, 466, '-306.813079', '1260.372802', '12.452363', '141.699310', 0, 0, 27, 0, 0, 0, 4800000, 0, 1, 45),
(189, 567, '-306.492156', '1253.458862', '12.650482', '299.406494', 0, 0, 27, 0, 1, 0, 2200000, 0, 1, 45),
(190, 490, '2633.461425', '-225.306396', '3.809171', '43.327148', 0, 0, 35, 0, 6, 0, 4700000, 0, 1, 45),
(191, 466, '2621.351074', '-225.763916', '3.768022', '41.068340', 0, 0, 35, 0, 6, 0, 4800000, 0, 1, 45),
(192, 466, '2628.967529', '-225.496246', '3.727416', '41.995517', 0, 0, 35, 0, 3, 0, 4800000, 0, 1, 45),
(193, 490, '2616.820068', '-225.484603', '3.888341', '40.677871', 0, 0, 35, 0, 0, 0, 4700000, 0, 1, 45),
(194, 466, '2625.266113', '-225.927246', '3.756738', '40.867424', 0, 0, 35, 0, 2, 0, 4800000, 0, 1, 45),
(195, 490, '1806.813720', '2188.015136', '15.595391', '111.048843', 0, 0, 34, 1, 93, 0, 4700000, 0, 1, 45),
(196, 490, '1806.699340', '2191.239501', '15.541913', '118.114143', 0, 0, 34, 1, 3, 0, 4700000, 0, 1, 45),
(197, 502, '1806.692871', '2185.202636', '15.461406', '113.333908', 0, 0, 34, 1, 3, 0, 630000, 0, 1, 45),
(198, 429, '1805.700927', '2198.303955', '15.259435', '122.996337', 0, 0, 34, 1, 3, 0, 2200000, 0, 1, 45),
(199, 567, '1806.132080', '2194.217041', '15.598702', '119.343864', 0, 0, 34, 1, 3, 0, 2200000, 0, 1, 45),
(200, 502, '0', '0', '0', '0', 0, 0, 33, 0, 0, 0, 630000, 0, 1, 45),
(201, 400, '0', '0', '0', '0', 0, 0, 33, 0, 9, 0, 2300000, 0, 1, 45),
(202, 490, '0', '0', '0', '0', 0, 0, 33, 0, 0, 0, 4700000, 0, 1, 45),
(204, 559, '0', '0', '0', '0', 0, 0, 33, 0, 1, 0, 1200000, 0, 1, 45),
(205, 567, '2058.004394', '-1046.910522', '2.152432', '359.887176', 0, 0, 36, 103, 103, 0, 2200000, 0, 1, 45),
(206, 429, '2061.084228', '-1047.103759', '1.841302', '1.877322', 0, 0, 36, 2, 6, 0, 2200000, 0, 1, 45),
(208, 466, '0', '0', '0', '0', 0, 0, 33, 0, 0, 0, 4800000, 0, 1, 45),
(216, 490, '2056.340087', '-1033.181518', '2.110029', '178.861038', 0, 0, 36, 103, 5, 0, 4700000, 0, 1, 45),
(217, 490, '78.282768', '597.663879', '11.980586', '82.094451', 0, 0, 38, 0, 2, 0, 4700000, 0, 1, 45),
(218, 502, '103.622535', '595.766113', '11.956243', '82.362426', 0, 0, 38, 0, 3, 0, 630000, 0, 1, 45),
(219, 400, '2577.800537', '-2175.622802', '21.960824', '178.485214', 0, 0, 30, 86, 86, 0, 2300000, 0, 1, 45),
(220, 400, '0', '0', '0', '0', 0, 0, 30, 86, 86, 0, 2300000, 0, 1, 45),
(221, 529, '2569.918457', '-2175.388183', '21.783081', '179.900100', 0, 0, 30, 86, 86, 0, 800000, 0, 1, 45),
(222, 529, '2566.212890', '-2175.406982', '21.783784', '179.266433', 0, 0, 30, 86, 86, 0, 800000, 0, 1, 45),
(223, 502, '2562.923583', '-2175.176025', '21.771785', '177.370803', 0, 0, 30, 86, 86, 0, 630000, 0, 1, 45),
(228, 490, '2429.988525', '-203.397918', '2.086696', '176.990554', 0, 0, 37, 0, 6, 0, 4700000, 0, 1, 45),
(229, 505, '2432.759765', '-203.026336', '2.205387', '176.543518', 0, 0, 37, 0, 6, 0, 4750000, 0, 1, 45),
(230, 490, '2435.131835', '-203.834899', '2.087236', '174.173629', 0, 0, 37, 0, 7, 0, 4700000, 0, 1, 45),
(231, 451, '2241.492675', '-1042.812133', '1.940472', '271.897338', 0, 0, 17, 3, 0, 0, 5000000, 0, 1, 45),
(232, 490, '2242.003906', '-1035.875122', '2.111292', '274.146087', 0, 0, 17, 3, 1, 0, 4700000, 0, 1, 45),
(233, 451, '93.259887', '600.393676', '11.983615', '82.971832', 0, 0, 38, 0, 0, 0, 5000000, 0, 1, 45),
(234, 429, '87.509635', '614.993286', '11.585077', '165.005050', 0, 0, 38, 0, 5, 0, 2200000, 0, 1, 45),
(235, 400, '100.913688', '591.266479', '12.103651', '85.664443', 0, 0, 38, 0, 3, 0, 2300000, 0, 1, 45),
(236, 526, '2063.954589', '-1047.117065', '1.888934', '2.864399', 0, 0, 36, 103, 0, 0, 1850000, 0, 1, 45),
(237, 490, '2438.150390', '-208.152465', '2.086692', '177.277572', 0, 0, 37, 0, 0, 0, 4700000, 0, 1, 45),
(238, 490, '2056.311523', '-1039.063720', '2.110986', '180.727676', 0, 0, 36, 103, 0, 0, 4700000, 0, 1, 45),
(239, 490, '2441.218505', '-204.479782', '2.086876', '174.429214', 0, 0, 37, 0, 6, 0, 4700000, 0, 1, 45),
(240, 494, '0', '0', '0', '0', 0, 0, 39, 0, 0, 0, 0, 0, 1, 45),
(241, 542, '0', '0', '0', '0', 0, 0, 39, 0, 0, 0, 0, 0, 1, 45),
(242, 495, '0', '0', '0', '0', 0, 0, 40, 0, 0, 0, 0, 0, 1, 45);

-- --------------------------------------------------------

--
-- Структура таблицы `family_system`
--

CREATE TABLE `family_system` (
  `fam_id` int(11) NOT NULL,
  `fam_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `fam_creator` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `fam_data` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `fam_chat_color` int(11) NOT NULL DEFAULT 0,
  `fam_members_amount` int(11) NOT NULL,
  `fam_zamcreator` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `fam_sklad_dostup` int(11) NOT NULL,
  `fam_spawn` int(11) NOT NULL,
  `fam_spawn_x` float NOT NULL,
  `fam_spawn_y` float NOT NULL,
  `fam_spawn_z` float NOT NULL,
  `fam_money` int(11) NOT NULL,
  `fam_euro` int(11) NOT NULL DEFAULT 0,
  `fam_narko` int(11) NOT NULL,
  `fam_patr` int(11) NOT NULL,
  `fam_ranks` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'none, none, none, none, none, none, none',
  `fam_int` int(11) NOT NULL,
  `fam_world` int(11) NOT NULL,
  `fam_house` int(11) NOT NULL DEFAULT 0,
  `fam_victory` int(11) NOT NULL DEFAULT 0,
  `fam_fight` int(11) NOT NULL DEFAULT 0,
  `fam_rating` int(11) NOT NULL DEFAULT 0,
  `fam_total_cars` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `family_system`
--

INSERT INTO `family_system` (`fam_id`, `fam_name`, `fam_creator`, `fam_data`, `fam_chat_color`, `fam_members_amount`, `fam_zamcreator`, `fam_sklad_dostup`, `fam_spawn`, `fam_spawn_x`, `fam_spawn_y`, `fam_spawn_z`, `fam_money`, `fam_euro`, `fam_narko`, `fam_patr`, `fam_ranks`, `fam_int`, `fam_world`, `fam_house`, `fam_victory`, `fam_fight`, `fam_rating`, `fam_total_cars`) VALUES
(1, 'Akeno гей', 'Bodya_Macalister', '2020-10-31 02:37:40', 12, 1, '', 0, 1, 1403.48, 295.311, 1401, 0, 0, 0, 0, ',,,,,,долбаёб', 8, 2, 2, 0, 0, 0, 0),
(2, 'fsd', 'Vago_Soprano', '2020-11-02 17:59:58', 0, 4, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 'none, none, none, none, none, none, none', 0, 0, 0, 0, 0, 0, 0),
(3, '..::Magnezi::..', 'Lord_Magnezi', '2020-11-02 18:23:37', 19, 37, '', 7, 1, 2415.69, 286.332, 1401, 2695000, 0, 0, 0, 'Шнырь,Барыга,Блатной,Браток,Свояк,Вор в закон,Авторитет', 9, 45, 45, 0, 0, 0, 5),
(4, 'БРИГАДА', 'Frank_Terry', '2020-11-02 18:45:40', 13, 95, '', 6, 1, 2415.69, 286.332, 1401, 20000, 4525, 0, 0, 'Шнырь,Водила,Бандит,Глав Бандит,Киллер,Заместитель,Глав. Босс', 9, 43, 43, 3, 3, 0, 0),
(5, 'Criminal Family', 'Ilya_Samorin', '2020-11-02 19:24:21', 9, 19, '', 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Шнырь,Фраер,Барыга,Свояк,Головорез,Блатной,Пахан', 0, 0, 0, 0, 0, 0, 0),
(6, 'Walker', 'Paul_Walker', '2020-11-02 19:28:13', 20, 1, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 'BABYDRIVER,DRIVER,none,none,none,yhhyh,PAUL WALKER', 0, 0, 0, 0, 0, 0, 0),
(7, '* ЮЖНАЯ БРАТВА *', 'Alfredo_Capone', '2020-11-02 20:14:17', 13, 37, '', 4, 0, 1098.22, 293.88, 1401, 1300000, 0, 0, 2700, 'Новичек,Браток,Охраник,Помощник,РЕШАЛА,777)ЗАМ(777,666)BOSS(66', 8, 62, 0, 0, 0, 0, 5),
(8, 'Norik Family', 'Nikita_Norik', '2020-11-03 01:23:26', 9, 88, '', 6, 1, 1403.48, 295.311, 1401, 0, 1220, 0, 153, 'Шнырь,Фраер,Охраник,Барыга,Свояк,Авторитет,ВорВзаконе', 8, 34, 34, 0, 1, 0, 5),
(9, '\"Supreme\"', 'Mason_Monecarlo', '2020-11-03 13:59:49', 13, 65, '', 7, 1, 1403.48, 295.311, 1401, 0, 0, 9, 3180, 'Уборщик,Охранник,Гл Охранник,Зам.Охраник,Мл.Зам.Охра,Зам.Лидера,Лидер.Семьи', 8, 28, 28, 0, 0, 0, 4),
(10, '? Fantasy ?', 'Misha_Noski', '2020-11-03 18:47:07', 9, 1, '', 5, 1, 2415.69, 286.332, 1401, 4500, 0, 0, 0, 'none, none, none, none, none, none, none', 9, 89, 89, 0, 0, 0, 1),
(11, '33322', 'Grigory_Malevich', '2020-11-03 20:00:19', 13, 21, '', 6, 1, 2415.69, 286.332, 1401, 0, 0, 0, 1000, 'Новичок,Старший,Член семьи,Смотрящий,Уважаемый,Заместитель,Основатель', 9, 84, 84, 0, 0, 0, 5),
(12, 'BomJGang', 'Timur_Galimov', '2020-11-03 20:00:40', 6, 8, '', 4, 1, 2415.69, 286.332, 1401, 345000, 0, 0, 1000, 'Бомжик,Лошарик,Обычный чел,Ровный пацы,Оффник,Конор,Гл.Бомж', 9, 90, 90, 0, 0, 0, 5),
(13, '$БРАТВА$', 'Roma_Bercha', '2020-11-03 22:46:47', 13, 12, '', 5, 1, 1403.48, 295.311, 1401, 7375000, 0, 0, 5000, 'Мл.Брат,Братишка,Качок,Склададёр,зам.зама,Зам.Главы,ГЛАВА', 8, 31, 31, 0, 0, 0, 5),
(14, 'The Contrinos', 'Simone_Contrino', '2020-11-04 09:14:07', 13, 1, '', 4, 0, 0, 0, 0, 0, 0, 0, 0, 'none, none, none, none, none, none, none', 0, 0, 0, 0, 0, 0, 2),
(15, '$Sokolovsky$', 'Igor_Sokolovsky', '2020-11-04 09:43:04', 3, 69, '', 5, 1, 1403.48, 295.311, 1401, 2670000, 0, 0, 382, 'Халоп,Лорд.,Маркиз,Дворянин,Надежный,Зам.Барона,Барон', 8, 37, 37, 0, 0, 0, 5),
(16, 'GAMER', 'Ivan_Rybalk', '2020-11-04 14:27:38', 13, 51, '', 7, 0, 0, 0, 0, 2795000, 0, 0, 0, 'none,none,none,none,none,none,Глава', 0, 0, 0, 0, 0, 0, 5),
(17, 'Русские Медведи.', 'Vova_Chemirzov', '2020-11-04 14:39:59', 13, 87, '', 3, 1, 2415.69, 286.332, 1401, 1115000, 0, 0, 2999, 'Бродяга,Молодой ,Прошариный,Проверенный,Борзый,Зам Главы,Глава ', 9, 86, 86, 0, 0, 0, 5),
(18, 'Revel', 'Leonardo_Revel', '2020-11-04 18:20:55', 16, 67, '', 4, 1, 2415.69, 286.332, 1401, 670000, 0, 0, 0, 'Малыш,Зайка,Пончик,Кривой,Lil чича,Зам насяник,Насяник', 9, 78, 78, 0, 0, 0, 5),
(19, 'MARALLES', 'Nick_Maralles', '2020-11-04 21:23:19', 3, 118, '', 6, 1, 2415.69, 286.332, 1401, 0, 0, 0, 0, 'none,none,none,none,none,Заместитель,Создатель', 9, 80, 80, 0, 0, 0, 5),
(20, 'The Morty', 'Rose_Morty', '2020-11-05 11:31:23', 13, 41, '', 5, 1, 2415.69, 286.332, 1401, 18400000, 0, 0, 3900, 'Новичок,Шестерка,Бывалый,Гоп-стопер,Киллер,Крыша,Папочка', 9, 93, 93, 0, 0, 0, 5),
(21, 'Russian Corporation', 'Nikita_Selby', '2020-11-05 15:46:02', 9, 15, '', 5, 0, 0, 0, 0, 6305555, 0, 0, 0, 'Легавый,Богатый,Гонщик,Топчик,Прокурор,Нагибатор,Глава семьи', 0, 0, 0, 0, 0, 0, 5),
(22, 'Takeda', 'Neo_Takeda', '2020-11-05 15:55:32', 20, 8, '', 5, 0, 0, 0, 0, 370000, 0, 0, 5000, 'Салага,,Водитель,Нач.охраны,Доверенные,Заместитель,Лидер', 0, 0, 0, 0, 0, 0, 5),
(23, 'Capkeyca family', 'Matvey_Burylov', '2020-11-05 16:40:16', 17, 7, '', 6, 0, 0, 0, 0, 0, 0, 0, 2200, ' новичок,салага,охраник,сержант,майор,заместитель,глава', 0, 0, 0, 0, 0, 0, 5),
(24, '.::ЮжнаЯ БригадА::.', 'Dimka_Pimka', '2020-11-05 16:57:13', 9, 41, '', 6, 0, 0, 0, 0, 140000, 0, 0, 4600, 'Лошара,Наркоман,Кайфарик,Бучара,Бычара,Хохол,Сталин', 0, 0, 0, 0, 0, 0, 5),
(25, 'Malevich Dynasty', 'Grigory_Malevich', '2020-11-05 22:50:15', 13, 130, '', 2, 1, 2415.69, 286.332, 1401, 0, 1000, 0, 2129, 'Новичок,Член семьи,Помощник,Хелпер,Уважаемый,Заместитель,Основатель', 9, 84, 84, 3, 3, 0, 5),
(26, 'Flatcher', 'Ghost_Fernandez', '2020-11-06 12:36:36', 19, 78, '', 6, 1, 2415.69, 286.332, 1401, 20000000, 0, 0, 0, 'Новичок,Обученный,Помощник,Местный,Проверенный,Зам Лидер,Лидер', 9, 89, 89, 0, 0, 0, 5),
(27, 'RIP Carter', 'Ell_Bruno', '2020-11-06 16:10:27', 13, 114, '', 1, 1, 2415.69, 286.332, 1401, 300000, 75, 0, 4700, 'Мальчик,Мальчишка,Мужик,Мужичек,Батька,Папочка,Избранный', 9, 46, 46, 0, 0, 0, 5),
(28, 'Admins', 'Voloday_Tcahenko', '2020-11-06 16:23:53', 13, 3, '', 7, 0, 0, 0, 0, 0, 0, 0, 0, '[О] 1-4,[П] 1-4,[О] 5-8,[П] 5-8,[О] 9-11,[П] 9-11,Создатель', 0, 0, 0, 0, 0, 0, 5),
(29, 'Carter', 'Ivan_Carter', '2020-11-06 18:42:54', 9, 0, '', 3, 1, 2415.69, 286.332, 1401, 0, 0, 0, 0, 'none, none, none, none, none, none, none', 9, 42, 42, 0, 0, 0, 0),
(30, '• Marlboro •', 'Ilkham_Marlboro', '2020-11-07 10:49:31', 11, 83, '', 6, 1, 2415.69, 286.332, 1401, 0, 0, 0, 0, 'Нубицио,Бандит,Смотритель,Бригадир,Жиган,Вор в закон,Авторитет', 9, 81, 81, 0, 0, 0, 5),
(31, 'bakson', 'Yamato_Kubo', '2020-11-07 15:02:46', 2, 42, '', 7, 0, 0, 0, 0, 0, 815, 100, 3288, 'Фраер,Басота,Щипач,Смотрящий,Блатной,Положенец,Вор в закон', 0, 0, 0, 0, 0, 0, 0),
(32, 'Западное ОПГ', 'John_Pulper', '2020-11-07 15:52:16', 13, 10, '', 5, 0, 0, 0, 0, 150000, 0, 0, 300, 'Печенька,Обученный,Водила,Биг Нига,Братишка,Зам.Главы,Глава', 0, 0, 0, 0, 0, 0, 5),
(33, '.:Fighters Family:.', 'Zardes_Storm', '2020-11-07 20:49:12', 13, 22, '', 6, 0, 0, 0, 0, 20000000, 0, 0, 0, 'Шавка,Шестёрка,Барыга,Наточенный,Воришка,Вор в закон,Авторитет', 0, 0, 0, 0, 0, 0, 5),
(34, 'B L A C K W O O D', 'Ivan_Miniffov', '2020-11-07 21:48:12', 12, 15, '', 6, 1, 1403.48, 295.311, 1401, 5570000, 0, 0, 0, 'Мл.Браток,Браток,,Зам.Босса,,Зам.Босса,Лидер', 8, 35, 35, 0, 0, 0, 5),
(35, 'Parkers Squad', 'Joy_Parker', '2020-11-07 22:44:19', 9, 5, '', 7, 1, 1098.22, 293.88, 1401, 20000000, 0, 0, 0, ',,Буханыч,,,,Браток', 8, 2, 2, 0, 0, 0, 5),
(36, '†Орден Миротворцев†', 'Sasha_Bulgin', '2020-11-08 09:29:50', 13, 46, '', 3, 1, 2415.69, 286.332, 1401, 13450000, 0, 0, 5000, 'Басяк,Барыга,Бандит,Смотритель,Старожила, Аристократ,Авторитет', 9, 91, 91, 0, 0, 0, 5),
(37, '.::Rogers::.', 'Marcus_Rogers', '2020-11-08 14:02:15', 9, 9, '', 7, 1, 1098.22, 293.88, 1401, 105000, 0, 0, 0, 'Новицио,Помошник,Капрал,Капитан,Подполковни,Полковник,Создатель ', 8, 98, 98, 0, 0, 0, 5),
(38, 'Северная ОПГ', 'Artem_Levcenko', '2020-11-08 16:09:44', 13, 6, '', 5, 0, 0, 0, 0, 6170000, 0, 0, 300, 'Охранник,Барыга,Блатной,Свояк,Бывалый,Надёжный,Авторитет', 0, 0, 0, 0, 0, 0, 5),
(39, 'Test Family', 'Shadow_Dev', '2021-03-18 23:11:02', 9, 0, '', 7, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none,none,none,none,Папочка', 0, 0, 0, 0, 0, 0, 0),
(40, 'test]', 'Ilya_Macalister', '2021-03-21 00:07:41', 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 'none, none, none, none, none, none, none', 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `fines`
--

CREATE TABLE `fines` (
  `Num` int(11) NOT NULL,
  `Name` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Sum` int(11) NOT NULL,
  `Reason` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Date` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Writer` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Pay` int(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `frakrang`
--

CREATE TABLE `frakrang` (
  `id` int(11) NOT NULL,
  `rang_1` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '1',
  `rang_2` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '2',
  `rang_3` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '3',
  `rang_4` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '4',
  `rang_5` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '5',
  `rang_6` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '6',
  `rang_7` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '7',
  `rang_8` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '8',
  `rang_9` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '9',
  `rang_10` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '10'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `frakrang`
--

INSERT INTO `frakrang` (`id`, `rang_1`, `rang_2`, `rang_3`, `rang_4`, `rang_5`, `rang_6`, `rang_7`, `rang_8`, `rang_9`, `rang_10`) VALUES
(1, 'Водитель', 'Охраник', 'Нач.Охраны', 'Секретарь', 'Депутат', 'Мэр', 'Губернатор', 'Премьер-Министр', 'Вице-Президент', 'Президент'),
(2, 'Рядовой', 'Ефрейтор', 'Сержант', 'Прапорщик', 'Лейтенант', 'Капитан', 'Майор', 'Подполковник', 'Полковник', 'Генерал-Майор'),
(3, 'Стажер', 'Сержант[2]', 'Старшина[3]', 'Прапорщик[4]', 'Лейтенант[5]', 'Капитан ФСБ[6]', 'Майор ФСБ[7]', 'Подполковник ФСБ[8]', 'Полковник Федеральной Службы[9]', 'Генерал-Майор ФСБ[10]'),
(4, 'Интерн', 'Ординатор', 'Врач - участковый', 'Врач - стоматолог.', 'Нарколог', 'Психолог', 'Хирург', 'Зав.Отделением', 'Зам.Глав.Врача', 'Главный врач'),
(5, 'Малыш', 'Ученик', 'Подросток', 'Старик', 'Бандит', 'Абу Бандиты', 'Гангстер', 'Тащер капта', 'Заместитель', 'Тренер'),
(6, 'Запасной', 'Недо-Футболист', 'Помощник Вратаря', 'Вратарь', 'Защитник', 'Полузащитник', 'Нападающий', 'Капитан', 'Ген.Директор', 'Президент'),
(7, 'Стрелок', 'Наемник', 'Мл. Агент', 'Агент', 'Ст. Агент', 'Снайпер', 'Киллер', 'Гл. Киллер', 'Мясник', 'Хитман'),
(8, 'Рядовой[1]', 'Ефрейтор[2]', 'Сержант[3]', 'Прапорщик[4]', 'Лейтенант[5]', 'Капитан[6]', 'Майор[7]', 'Подполковник[8]', 'Полковник[9]', 'Генерал-Полковник[10]'),
(9, 'Новицио', 'Ассосиато', 'Сомбаттенте', 'Солдато', 'Боец', 'Сото-капо', 'Капо', 'Младший Босс', 'Коньсельери', 'Дон'),
(10, 'Барыга[1]', 'Кабыла[2]', 'Бык', 'Фраер', 'Барыга', 'Сторожила', 'Жиган', 'Свояк', 'Авторитет', 'Вор в законе'),
(11, 'Помощник редакции', 'Верстальщик новостей', 'Радиотехник', 'Журналист', 'Старший журналист', 'Корректор', 'Помощник редактора', 'Редактор', 'Заместитель Директора СМИ', 'Директор СМИ');

-- --------------------------------------------------------

--
-- Структура таблицы `friends`
--

CREATE TABLE `friends` (
  `id` int(11) NOT NULL,
  `login` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `friend` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `fullaccess`
--

CREATE TABLE `fullaccess` (
  `id` int(11) NOT NULL,
  `name` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `rank` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT 'Пидор'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `fullaccess`
--

INSERT INTO `fullaccess` (`id`, `name`, `rank`) VALUES
(0, 'Feliks_Macalister', 'Основатель Проекта'),
(1, 'Shadow_Dev', 'Разработчик'),
(2, 'Larry_Torres', 'Основатель Проекта'),
(3, 'Bodya_Macalister', 'PRIME'),
(4, 'Vago_Soprano', 'PRIME'),
(5, 'Ilya_Macalister', 'PRIME'),
(6, 'Nikol_Soprano', 'RIME'),
(7, 'Scays_Fresko', 'Разработчик');

-- --------------------------------------------------------

--
-- Структура таблицы `gang`
--

CREATE TABLE `gang` (
  `grovebank` int(11) NOT NULL DEFAULT 0,
  `ballasbank` int(11) NOT NULL DEFAULT 0,
  `rifabank` int(11) NOT NULL DEFAULT 0,
  `aztecbank` int(11) NOT NULL DEFAULT 0,
  `vagosbank` int(11) NOT NULL DEFAULT 0,
  `grovedrugs` int(11) NOT NULL DEFAULT 0,
  `ballasdrugs` int(11) NOT NULL DEFAULT 0,
  `rifadrugs` int(11) NOT NULL DEFAULT 0,
  `aztecdrugs` int(11) NOT NULL DEFAULT 0,
  `vagosdrugs` int(11) NOT NULL DEFAULT 0,
  `grovepat` int(11) NOT NULL DEFAULT 0,
  `ballaspat` int(11) NOT NULL DEFAULT 0,
  `rifapat` int(11) NOT NULL DEFAULT 0,
  `aztecpat` int(11) NOT NULL DEFAULT 0,
  `vagospat` int(11) NOT NULL DEFAULT 0,
  `groveed` int(11) NOT NULL DEFAULT 0,
  `ballased` int(11) NOT NULL DEFAULT 0,
  `rifaed` int(11) NOT NULL DEFAULT 0,
  `azteced` int(11) NOT NULL DEFAULT 0,
  `vagosed` int(11) NOT NULL DEFAULT 0,
  `bcapt_g` int(1) NOT NULL DEFAULT 0,
  `bcapt_b` int(1) NOT NULL DEFAULT 0,
  `bcapt_r` int(1) NOT NULL DEFAULT 0,
  `bcapt_a` int(1) NOT NULL DEFAULT 0,
  `bcapt_v` int(1) NOT NULL DEFAULT 0,
  `bskl_g` int(1) NOT NULL DEFAULT 0,
  `bskl_b` int(1) NOT NULL DEFAULT 0,
  `bskl_r` int(1) NOT NULL DEFAULT 0,
  `bskl_a` int(1) NOT NULL DEFAULT 0,
  `bskl_v` int(1) NOT NULL DEFAULT 0,
  `spartak_mats` int(11) NOT NULL,
  `cska_mats` int(11) NOT NULL,
  `itmaf_mats` int(11) NOT NULL,
  `rusmaf_mats` int(11) NOT NULL,
  `army_mats` int(11) NOT NULL,
  `bikers_mats` int(11) NOT NULL DEFAULT 0,
  `stock_rang` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1,1,1,1,1,1,1,1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `gang`
--

INSERT INTO `gang` (`grovebank`, `ballasbank`, `rifabank`, `aztecbank`, `vagosbank`, `grovedrugs`, `ballasdrugs`, `rifadrugs`, `aztecdrugs`, `vagosdrugs`, `grovepat`, `ballaspat`, `rifapat`, `aztecpat`, `vagospat`, `groveed`, `ballased`, `rifaed`, `azteced`, `vagosed`, `bcapt_g`, `bcapt_b`, `bcapt_r`, `bcapt_a`, `bcapt_v`, `bskl_g`, `bskl_b`, `bskl_r`, `bskl_a`, `bskl_v`, `spartak_mats`, `cska_mats`, `itmaf_mats`, `rusmaf_mats`, `army_mats`, `bikers_mats`, `stock_rang`) VALUES
(509713276, 255759106, 0, 0, -130, 38323, 34915, 109, 0, 149632, 1131293690, 31180497, 78391, 2103, 1585784, 24008, 69279, 77327, 69471, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 68406, 73462, 1, 115792, 1043404829, 130050, '1,1,2,1,8,1,1,1');

-- --------------------------------------------------------

--
-- Структура таблицы `gangzone`
--

CREATE TABLE `gangzone` (
  `id` int(4) NOT NULL,
  `fraction` int(3) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `gangzone`
--

INSERT INTO `gangzone` (`id`, `fraction`) VALUES
(1, 8),
(2, 8),
(3, 8),
(4, 8),
(5, 8),
(6, 8),
(7, 5),
(8, 8),
(9, 8),
(10, 8),
(11, 8),
(12, 8),
(13, 6),
(14, 6),
(15, 7),
(16, 7),
(17, 7),
(18, 7),
(19, 8),
(20, 7),
(21, 8),
(22, 8),
(23, 8),
(24, 8),
(25, 7),
(26, 8),
(27, 5),
(28, 8),
(29, 7),
(30, 7),
(31, 7),
(32, 7),
(33, 7),
(34, 7),
(35, 7),
(36, 7),
(37, 7),
(38, 8),
(39, 7),
(40, 7),
(41, 7),
(42, 7),
(43, 8),
(44, 8),
(45, 7),
(46, 7),
(47, 8),
(48, 7),
(49, 7),
(50, 7),
(51, 8),
(52, 8),
(53, 8),
(54, 7),
(55, 8),
(56, 8),
(57, 8),
(58, 7),
(59, 7),
(60, 7),
(61, 8),
(62, 8),
(63, 8),
(64, 8),
(65, 8),
(66, 8),
(67, 8),
(68, 7),
(69, 7),
(70, 7),
(71, 7),
(72, 7),
(73, 7),
(74, 8),
(75, 7),
(76, 7),
(77, 8),
(78, 8),
(79, 7),
(80, 7),
(81, 7),
(82, 7),
(83, 7),
(84, 7),
(85, 7),
(86, 8),
(87, 7),
(88, 8);

-- --------------------------------------------------------

--
-- Структура таблицы `garages`
--

CREATE TABLE `garages` (
  `id` int(11) NOT NULL,
  `enter_x` float NOT NULL,
  `enter_y` float NOT NULL,
  `enter_z` float NOT NULL,
  `enter_x_car` float NOT NULL,
  `enter_y_car` float NOT NULL,
  `enter_z_car` float NOT NULL,
  `enter_a_car` float NOT NULL,
  `exit_x` float NOT NULL,
  `exit_y` float NOT NULL,
  `exit_z` float NOT NULL,
  `lock` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `owner` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `owned` int(11) NOT NULL DEFAULT -1,
  `price` int(11) NOT NULL,
  `update` int(11) NOT NULL,
  `int` int(11) NOT NULL,
  `world` int(11) NOT NULL,
  `day` int(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `garages`
--

INSERT INTO `garages` (`id`, `enter_x`, `enter_y`, `enter_z`, `enter_x_car`, `enter_y_car`, `enter_z_car`, `enter_a_car`, `exit_x`, `exit_y`, `exit_z`, `lock`, `type`, `owner`, `owned`, `price`, `update`, `int`, `world`, `day`) VALUES
(1, 2571.77, -1874.37, 21.964, 2567.99, -1874.03, 21.74, 89.457, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 1, 1, 0),
(2, 2378.92, -2297.86, 21.971, 2378.93, -2301.94, 21.748, 178.881, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 2, 2, 0),
(3, 2382.96, -2297.86, 21.971, 2383.02, -2300.08, 21.751, 180, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 3, 3, 0),
(4, 2387.05, -2297.86, 21.971, 2387.1, -2300.08, 21.752, 180, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 4, 4, 0),
(5, 2391.26, -2297.86, 21.971, 2391.36, -2300.08, 21.752, 180, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 5, 5, 0),
(6, 2395.21, -2297.86, 21.971, 2395.36, -2300.08, 21.755, 180.014, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 6, 6, 0),
(7, 2399.48, -2297.86, 21.971, 2399.65, -2300.1, 21.75, 181.355, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 7, 7, 0),
(8, 2403.56, -2297.86, 21.971, 2403.7, -2300.08, 21.756, 180, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 8, 8, 0),
(9, 2407.88, -2298.04, 21.971, 2407.95, -2300.09, 21.75, 180.482, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 9, 9, 0),
(10, 2407.64, -2310.31, 21.971, 2407.55, -2308.08, 21.75, 0.014, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 10, 10, 0),
(11, 2403.52, -2310.31, 21.971, 2403.54, -2308.07, 21.753, 0.301, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 11, 11, 0),
(12, 2399.58, -2310.31, 21.971, 2399.34, -2308.08, 21.752, 0.0001553, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 12, 12, 0),
(13, 2395.22, -2310.31, 21.971, 2395.38, -2308.08, 21.754, 360, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 13, 13, 0),
(14, 2391.33, -2310.31, 21.971, 2391.19, -2306.72, 21.757, 0, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 14, 14, 0),
(15, 2387, -2310.31, 21.971, 2386.99, -2307.41, 21.748, 359.27, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 15, 15, 0),
(16, 2382.91, -2310.31, 21.971, 2382.68, -2305.63, 21.747, 2.037, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 16, 16, 0),
(17, 2378.78, -2310.31, 21.971, 2378.54, -2307.1, 21.752, 1.785, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 17, 17, 0),
(18, 2407.76, -2284.26, 21.971, 2406, -2279.25, 21.754, 90.694, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 18, 18, 0),
(19, 2403.61, -2284.26, 21.971, 2403.6, -2282.03, 21.752, 0.00008973, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 19, 19, 0),
(20, 2399.41, -2284.26, 21.971, 2399.52, -2282.03, 21.753, 0.024, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 20, 20, 0),
(21, 2395.28, -2284.26, 21.971, 2395.27, -2282.03, 21.752, 359.986, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 21, 21, 0),
(22, 2391.08, -2284.26, 21.971, 2391.12, -2282.03, 21.746, 0.514, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 22, 22, 0),
(23, 2387.15, -2284.26, 21.971, 2386.06, -2280.61, 21.777, 89.974, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 23, 23, 0),
(24, 2382.8, -2284.26, 21.971, 2383.08, -2279.92, 21.778, 91.995, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 24, 24, 0),
(25, 2378.8, -2284.26, 21.971, 2383.03, -2280.16, 21.746, 89.398, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 25, 25, 0),
(26, 2378.82, -2273.73, 21.971, 2380.17, -2277.68, 21.677, 269.893, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 26, 26, 0),
(27, 2382.99, -2273.73, 21.971, 2384.91, -2277.47, 21.755, 270.555, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 27, 27, 0),
(28, 2387.33, -2273.73, 21.971, 2388.39, -2277.08, 21.777, 272.055, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 28, 28, 0),
(29, 2391.25, -2273.73, 21.971, 2392.3, -2276.64, 21.678, 270.259, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 29, 29, 0),
(30, 2395.09, -2273.73, 21.971, 2397.76, -2278.25, 21.678, 269.695, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 30, 30, 0),
(31, 2399.56, -2273.73, 21.971, 2400.76, -2277.42, 21.677, 270.894, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 31, 31, 0),
(32, 2403.55, -2273.73, 21.971, 2404.35, -2278.57, 21.676, 272.909, 1498.58, 2503.88, 1601, 1, 2, 'None', -1, 750000, 0, 32, 32, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gifts`
--

CREATE TABLE `gifts` (
  `id` int(11) NOT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `status` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `gifts`
--

INSERT INTO `gifts` (`id`, `x`, `y`, `z`, `status`) VALUES
(1, 1818.73, 2498.89, 15.6716, 1),
(2, 2498.41, -2152.21, 22.3306, 1),
(3, 2498.41, -2152.21, 22.3306, 1),
(4, 2504.49, -2152.17, 21.9209, 1),
(5, 2512.33, -2153.85, 21.8147, 1),
(6, 1820.93, 2504.1, 15.6639, 1),
(7, 1826.85, 2508.87, 15.6639, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `helicopters`
--

CREATE TABLE `helicopters` (
  `id` int(11) NOT NULL,
  `h_model` int(11) NOT NULL DEFAULT 0,
  `h_owner` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `h_color` int(11) NOT NULL DEFAULT 0,
  `h_lock` int(11) NOT NULL DEFAULT 0,
  `h_price` int(11) NOT NULL DEFAULT 0,
  `h_timer` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `helicopters`
--

INSERT INTO `helicopters` (`id`, `h_model`, `h_owner`, `h_color`, `h_lock`, `h_price`, `h_timer`) VALUES
(2, 417, 'Ivan_Campo', 0, 0, 4000000, 1604249687),
(3, 488, 'Sany_Mihailik', 0, 1, 2700000, 1604395517),
(4, 469, 'Alessandro_Merkyru', 0, 0, 2500000, 1604249810),
(5, 488, 'Danil_Podolskiy', 93, 0, 2700000, 0),
(6, 487, 'Arseniy_Matveev', 0, 0, 2700000, 0),
(10, 487, 'Maxim_Leeq', 0, 1, 2700000, 1604251675),
(12, 487, 'Logan__DeCarlo', 0, 1, 2700000, 1604335657),
(13, 417, 'Viktor_Marlboro', 0, 1, 4000000, 0),
(14, 487, 'Roma_Teyk', 6, 1, 2700000, 0),
(15, 487, 'Artem_Chugunov', 3, 1, 2700000, 0),
(16, 487, 'Alex_Criminalov', 123, 1, 2700000, 1604251671),
(17, 417, 'Dmitry_Evtychenko', 0, 1, 4000000, 0),
(18, 417, 'Diego_Rain', 0, 1, 4000000, 1604331454),
(19, 487, 'Freyn_Young', 3, 1, 2700000, 1604336887),
(20, 487, 'Pasha_Kotovnov', 1, 1, 2700000, 1604330940),
(21, 469, 'Misha_Korshun', 0, 1, 2500000, 0),
(22, 469, 'Masy_Derskiy', 0, 1, 2500000, 0),
(23, 487, 'Kostya_Hokagee', 0, 1, 2700000, 0),
(24, 469, 'Vlad_Blyndu', 0, 1, 2500000, 0),
(25, 488, 'Alina_Getman', 0, 1, 2700000, 0),
(26, 488, 'Morgan_Obihny', 0, 1, 2700000, 0),
(28, 417, 'Valtor_Astro', 0, 1, 4000000, 1604397130),
(29, 487, 'Egor_Smugunov', 0, 1, 2700000, 0),
(30, 469, 'Donald_Davenport', 0, 1, 2500000, 0),
(31, 417, 'Openning_Perfect', 0, 1, 4000000, 0),
(32, 487, 'Ricardo_Mortinos', 0, 1, 2700000, 1604335893),
(33, 487, 'Yura_Muzuchenko', 0, 1, 2700000, 0),
(34, 469, 'Nikita_Mikhienkov', 6, 1, 2500000, 0),
(35, 487, 'Kiragai_Uichiro', 0, 1, 2700000, 1604336676),
(38, 488, 'Vlad_Naskov', 0, 0, 2700000, 1604333072),
(41, 417, 'Vova_Crmpshnik', 0, 1, 4000000, 1604337561),
(42, 487, 'Stefano_DeCarlo', 6, 1, 2700000, 1604425642),
(43, 469, 'Vassi_pupkin', 0, 1, 2500000, 0),
(45, 469, 'Aleksandr_Suzuki', 0, 1, 2500000, 0),
(46, 469, 'Vlad_Poziloy', 0, 1, 2500000, 0),
(47, 487, 'Vova_Chemirzov', 0, 1, 2700000, 1604513291),
(48, 487, 'Kostya_Capone', 0, 1, 2700000, 1604334227),
(49, 417, 'Roman_Romson', 1, 1, 4000000, 0),
(50, 487, 'Amir_Putin', 3, 1, 2700000, 1604406539),
(51, 487, 'Danila_Black', 0, 1, 2700000, 1604334297),
(52, 417, 'Volodya_Tcahenko', 1, 1, 4000000, 1604335643),
(53, 487, 'Al_Maslennikov', 0, 0, 2700000, 0),
(54, 488, 'Joseph_Novikov', 0, 1, 2700000, 1604378167),
(55, 488, 'Waldemar_Toretto', 6, 1, 2700000, 1604335011),
(56, 417, 'Danila_Kuryshev', 0, 1, 4000000, 0),
(57, 488, 'Banan_Cattom', 0, 1, 2700000, 0),
(58, 487, 'Maksim_Taranenko', 0, 1, 2700000, 0),
(59, 469, 'Boris_Markov', 0, 1, 2500000, 0),
(60, 417, 'Vladik_Usmanov', 0, 1, 4000000, 0),
(61, 488, 'Joseph_Winston_M', 3, 1, 2700000, 1604336013),
(62, 488, 'Max_Latow', 0, 1, 2700000, 1604440061),
(64, 487, 'Woody_Woodpecker', 123, 1, 2700000, 0),
(65, 488, 'Arkadiy_Valikov', 0, 1, 2700000, 1604579249),
(66, 417, 'Voloday_Tcahenko', 1, 1, 4000000, 1604483142),
(68, 487, 'Wolfgang_Bosserman', 1, 1, 2700000, 1604339465),
(70, 488, 'Alwaez_Sokol', 0, 0, 2700000, 1604337104),
(71, 487, 'Yuri_Piskun', 0, 1, 2700000, 1604431431),
(73, 487, 'Yevgeniy_Melnik', 0, 0, 2700000, 0),
(74, 469, 'Vitalik_Gasanov', 0, 1, 2500000, 0),
(75, 487, 'Richi_Soprano', 0, 0, 2700000, 1604338736),
(76, 417, 'James_Torrance', 0, 1, 4000000, 0),
(77, 487, 'Vlad_Kaspesky', 0, 1, 2700000, 0),
(78, 417, 'Vladimir_Stalnov', 0, 0, 4000000, 1604339329),
(79, 469, 'Eduard_Solo', 0, 1, 2500000, 1604339905),
(81, 487, 'Maks_Moul', 0, 1, 2700000, 1604380712),
(83, 488, 'Vitalik_Banditov', 0, 1, 2700000, 1604850157),
(84, 487, 'Andy_Monopoly', 6, 0, 2700000, 1604341154),
(86, 417, 'Aziz_Aminovich', 0, 0, 4000000, 0),
(87, 417, 'Alexey_Nedobloger', 0, 1, 4000000, 0),
(88, 488, 'Dima_Lingo', 0, 1, 2700000, 0),
(89, 469, 'Arsen_Champs', 0, 1, 2500000, 0),
(90, 487, 'Thony_Alliance', 101, 1, 2700000, 1604342657),
(91, 469, 'Lesha_Isakov', 0, 1, 2500000, 0),
(92, 488, 'Andrey_Miller', 1, 1, 2700000, 1604340597),
(93, 487, 'Vova_Stepanow', 3, 1, 2700000, 1604339797),
(94, 417, 'Vova_Boolman', 0, 1, 4000000, 1604340211),
(95, 487, 'Adidas_Surwey', 86, 1, 2700000, 1604340922),
(96, 487, 'Ben_Krupez', 93, 1, 2700000, 1604339842),
(97, 469, 'Maksim_Krasavcev', 0, 0, 2500000, 1604574012),
(98, 487, 'Stas_Ruden', 0, 1, 2700000, 1604342740),
(99, 487, 'Egor_Zhnetsov', 0, 0, 2700000, 0),
(100, 417, 'gosha', 0, 0, 4000000, 1604341633),
(102, 487, 'Max_Shalkov', 3, 1, 2700000, 0),
(104, 487, 'Gleb_Winchestero', 0, 1, 2700000, 0),
(105, 487, 'Aist_Moreno', 1, 0, 2700000, 1604342649),
(107, 488, 'Joni_Wilston', 0, 1, 2700000, 0),
(108, 417, 'John_Allen', 0, 0, 4000000, 0),
(110, 417, 'Andrey_Makarov', 123, 1, 4000000, 0),
(111, 488, 'John_Veterkov', 0, 1, 2700000, 1604430088),
(112, 487, 'Gleb_Gromov', 3, 1, 2700000, 1604423158),
(113, 487, 'Williams_Carleone', 0, 1, 2700000, 1604344539),
(115, 487, 'Pavel_Izmaylov', 0, 1, 2700000, 0),
(116, 487, 'Hamato_Nagatake', 101, 1, 2700000, 0),
(117, 488, 'Elon_Musk', 0, 1, 2700000, 1604349507),
(118, 469, 'Daniil_Slivko', 0, 1, 2500000, 0),
(120, 417, 'Roman_Berkozov', 0, 1, 4000000, 0),
(121, 417, 'Ivan_Milovski', 6, 1, 4000000, 1604344172),
(122, 469, 'Dimochka_Macalister', 0, 1, 2500000, 1604553007),
(123, 488, 'Ivan_Shvabra', 0, 1, 2700000, 1604345390),
(124, 469, 'Vlad_Rastamanov', 0, 1, 2500000, 0),
(126, 417, 'Svyat_Maximov', 0, 1, 4000000, 0),
(127, 469, 'Artem_Storm', 123, 1, 2500000, 0),
(129, 487, 'Denver_Helsing', 1, 1, 2700000, 1604347264),
(130, 488, 'Tomas_Shelby', 0, 1, 2700000, 1604345668),
(131, 487, 'Andrey_Uchiha', 0, 0, 2700000, 1604346839),
(132, 487, 'Stepan_Kaspesky', 0, 1, 2700000, 0),
(133, 487, 'Felix_Worow', 0, 0, 2700000, 1604677868),
(135, 469, 'Sergei_Sergei', 0, 1, 2500000, 0),
(136, 487, 'Santiago_Whete', 1, 0, 2700000, 1604350570),
(137, 487, 'Danilla_Sillers', 0, 1, 2700000, 0),
(140, 487, 'Leon_Rizzuto', 0, 1, 2700000, 0),
(142, 487, 'Vlad_Reklezz', 0, 1, 2700000, 0),
(143, 469, 'Vlad_Finn', 0, 1, 2500000, 1604515928),
(144, 488, 'Petr_One_M', 0, 1, 2700000, 0),
(147, 487, 'Lokotay_Shishmorev', 0, 0, 2700000, 1604653739),
(148, 487, 'Danil_Hernandez', 0, 1, 2700000, 1604402928),
(149, 487, 'Grand_Mafioznik', 0, 0, 2700000, 1604513196),
(150, 487, 'Tomi_Hardman', 93, 1, 2700000, 0),
(151, 487, 'Savva_Gaydar', 101, 0, 2700000, 1604505367),
(152, 417, 'Maxim_Kotov', 1, 1, 4000000, 1604828690),
(155, 417, 'Bolot_Doolotbekov', 0, 1, 4000000, 0),
(156, 487, 'Ruslan_Franki', 0, 0, 2700000, 1604699886),
(157, 469, 'Petr_Gromov', 0, 1, 2500000, 0),
(158, 487, 'Alfred_Shramov', 0, 0, 2700000, 1604350289),
(159, 487, 'Robert_Magaramov', 0, 1, 2700000, 0),
(161, 417, 'Maksim_Borzov', 0, 1, 4000000, 0),
(163, 487, 'Vlad_Torgonya', 93, 1, 2700000, 1604411083),
(164, 487, 'William_Hargreeves', 0, 1, 2700000, 0),
(165, 487, 'Sameleon_Hakugava', 0, 1, 2700000, 0),
(166, 488, 'Dias_Nasyrov', 0, 0, 2700000, 0),
(167, 417, 'Nastya_Xanov', 123, 0, 4000000, 0),
(168, 487, 'Semen_Kneazev', 1, 1, 2700000, 1604393098),
(169, 488, 'Tomass_Shelby', 0, 0, 2700000, 1604350894),
(170, 487, 'Angelika_Frank', 0, 1, 2700000, 0),
(171, 469, 'Denis_Cherniack', 0, 1, 2500000, 0),
(172, 487, 'Zaur_Fakevov', 0, 1, 2700000, 1604353195),
(174, 488, 'Oskar_Volk', 0, 1, 2700000, 1604352731),
(175, 488, 'Artem_Polubatko', 6, 0, 2700000, 0),
(177, 487, 'Danil_Duduk', 86, 1, 2700000, 0),
(178, 469, 'Ficus_Zotov', 0, 1, 2500000, 0),
(179, 417, 'Oleg_Sidelnikov', 0, 0, 4000000, 0),
(180, 487, 'Ersultan_Saken', 0, 1, 2700000, 0),
(182, 487, 'Vasya_Bolotka', 6, 1, 2700000, 0),
(183, 487, 'Daniil_Atwell', 1, 1, 2700000, 0),
(186, 488, 'Vladimir_Kutuzov', 1, 1, 2700000, 1604353451),
(187, 469, 'Kiril_Guzun', 93, 1, 2500000, 1604353596),
(188, 488, 'Ivan_Tasovac', 123, 0, 2700000, 1604353644),
(189, 487, 'Sasha_Ciller', 93, 1, 2700000, 0),
(190, 487, 'Arbi_Kerimov', 103, 1, 2700000, 1604490329),
(191, 469, 'John_Fahn', 0, 1, 2500000, 1604356628),
(192, 488, 'Dima_Gagen', 0, 0, 2700000, 1604618851),
(193, 417, 'Stas_Hromovs', 0, 1, 4000000, 1604357685),
(194, 488, 'Strayf_Milochin', 0, 1, 2700000, 0),
(195, 417, 'Ali_Arabov', 6, 0, 4000000, 0),
(197, 488, 'Kirill_Banb', 0, 1, 2700000, 1604358978),
(200, 488, 'Artem_vaseev', 0, 1, 2700000, 1604359953),
(201, 488, 'Andrey_Suvorov', 0, 1, 2700000, 1604362055),
(203, 417, 'Takashi_Asamo', 0, 1, 4000000, 0),
(204, 488, 'Doha_Mas', 0, 1, 2700000, 1604361871),
(205, 417, 'Advokat_Prokurora', 0, 1, 4000000, 1604363237),
(206, 0, 'Feliks_Macalister', 0, 0, 0, 0),
(207, 469, 'Adam_Borz', 93, 1, 2500000, 0),
(211, 417, 'Muslim_Storm', 0, 0, 4000000, 0),
(212, 417, 'Andrey_Babeshkin', 0, 0, 4000000, 0),
(214, 488, 'Kriss_Petechkin', 0, 1, 2700000, 0),
(215, 417, 'Egor_Buster', 0, 0, 4000000, 0),
(218, 487, 'Sasha_Lahmacun', 0, 1, 2700000, 0),
(219, 417, 'Ruslan_lvanov', 0, 0, 4000000, 1604372816),
(220, 417, 'Angel_Novikov', 0, 1, 4000000, 1604372265),
(221, 487, 'Maksim_Versace', 0, 1, 2700000, 1604375103),
(222, 488, 'Faer_Davis', 101, 1, 2700000, 1604397799),
(224, 488, 'Alexander_Mirnov', 0, 0, 2700000, 0),
(225, 487, 'Vadim_Kyznetsov', 0, 0, 2700000, 1604377244),
(226, 487, 'Unskill_Vinson', 0, 1, 2700000, 0),
(227, 487, 'Gleb_Klimovs', 1, 0, 2700000, 1604399412),
(228, 487, 'Aleksandr_Batalov', 0, 1, 2700000, 0),
(229, 487, 'Frendly_Kendary', 0, 1, 2700000, 0),
(230, 487, 'Kendary_Alwaez', 0, 1, 2700000, 0),
(231, 488, 'Santa_Versace', 0, 1, 2700000, 0),
(232, 487, 'Roman_Kurabtsev', 0, 1, 2700000, 1604739111),
(233, 487, 'Garry_Wrong', 1, 1, 2700000, 1604384771),
(234, 488, 'Viego_Kepkin', 0, 0, 2700000, 1604577678),
(235, 487, 'Arslan_Amanzhol', 0, 0, 2700000, 1604386638),
(236, 487, 'Pavel_Skezz', 0, 1, 2700000, 0),
(237, 469, 'Egor_Afanasev', 0, 1, 2500000, 0),
(238, 417, 'Denis_Delrosso', 0, 0, 4000000, 1604387435),
(239, 487, 'Daniil_Ihkinin', 0, 1, 2700000, 0),
(240, 487, 'Max_Vasin', 0, 0, 2700000, 1604388411),
(241, 417, 'Artem_kolmuchpok', 0, 1, 4000000, 0),
(242, 487, 'Slava_Dimovich', 0, 0, 2700000, 0),
(243, 488, 'Ferrero_Roche', 0, 1, 2700000, 1604388627),
(245, 469, 'Francio_Bonucci', 0, 0, 2500000, 1604390301),
(246, 488, 'Jon_Berimor', 0, 1, 2700000, 0),
(247, 487, 'Bogdan_Kulik', 93, 1, 2700000, 0),
(248, 488, 'Maksim_Raevskiy', 0, 0, 2700000, 0),
(249, 487, 'Rasul_Operskiy', 0, 1, 2700000, 1604395316),
(251, 487, 'Sasha_Sancov', 0, 1, 2700000, 1604391666),
(252, 469, 'Cheeter_Govnov', 0, 0, 2500000, 0),
(253, 469, 'Artem_Wright', 0, 1, 2500000, 1604392787),
(254, 487, 'Sergix_Chumak', 0, 0, 2700000, 1604424199),
(257, 488, 'Licvid_Milecov', 0, 1, 2700000, 1604434739),
(258, 487, 'Egor_Arka', 0, 1, 2700000, 0),
(259, 469, 'Shon_Soprano', 0, 1, 2500000, 0),
(262, 487, 'Matvey_Pop', 1, 1, 2700000, 1604574542),
(263, 469, 'Erlan_Jorobekov', 0, 1, 2500000, 1604495162),
(265, 487, 'Kirill_Ustinov', 0, 1, 2700000, 0),
(266, 417, 'Luciffer_Capone', 103, 1, 4000000, 0),
(267, 487, 'ANDREY_GLENOV', 0, 0, 2700000, 0),
(269, 417, 'Dima_Gordov', 0, 0, 4000000, 1604402766),
(271, 487, 'Islam_Atazukin', 0, 1, 2700000, 1604487927),
(272, 488, 'Ivan_Lisyev', 6, 1, 2700000, 1604416103),
(273, 487, 'Daniil_Cokol', 0, 0, 2700000, 1604511489),
(274, 488, 'yarik.lulka', 0, 1, 2700000, 0),
(275, 487, 'Matteo_Sanchez', 0, 1, 2700000, 1604399044),
(276, 488, 'Stanislav_Bykov', 0, 0, 2700000, 1604742614),
(277, 488, 'Toni_Layrent', 0, 0, 2700000, 1604404457),
(278, 487, 'Egor_Asakin', 0, 1, 2700000, 0),
(279, 487, 'Thomas_Escobar', 0, 0, 2700000, 1604500930),
(280, 469, 'Andrei_Squezze', 0, 1, 2500000, 0),
(281, 487, 'Konor_Ganster', 0, 1, 2700000, 1604402130),
(282, 487, 'Liza_Says', 103, 1, 2700000, 1604417841),
(283, 487, 'Lev_Alexandrov', 0, 1, 2700000, 1604547887),
(284, 469, 'Iosif_Gorbachevskii', 0, 0, 2500000, 1604403980),
(285, 469, 'Zenkov_Egor', 0, 1, 2500000, 1604486736),
(286, 487, 'Ilya_Tarasov', 0, 1, 2700000, 1604577577),
(289, 487, 'Winston_Ganster', 0, 1, 2700000, 1604403712),
(291, 487, 'Melvi_Slinko', 3, 1, 2700000, 1604403979),
(292, 487, 'Maksim_Mayski', 0, 1, 2700000, 0),
(293, 469, 'Tesla_Nebezao', 0, 1, 2500000, 1604404517),
(295, 487, 'Vasya_Popkin', 0, 1, 2700000, 1604404010),
(296, 487, 'Ilya_Kyznecov', 1, 1, 2700000, 0),
(297, 487, 'Josh_Unique', 1, 1, 2700000, 0),
(298, 487, 'Vadim_Airon', 1, 0, 2700000, 0),
(299, 417, 'Danil_Mansory', 0, 1, 4000000, 0),
(301, 488, 'Chris_Devis', 0, 0, 2700000, 0),
(302, 488, 'Dima_Lineechkin', 0, 1, 2700000, 0),
(303, 487, 'Karat_Hennessy', 0, 1, 2700000, 1604405934),
(304, 469, 'Max_Deen', 1, 0, 2500000, 0),
(305, 417, 'Aleksei_Strayf', 0, 1, 4000000, 0),
(306, 488, 'Artemiy_Gofgof', 3, 1, 2700000, 0),
(307, 487, 'Nail_Fathulov', 0, 1, 2700000, 1604407432),
(308, 487, 'Liam_Brown', 0, 1, 2700000, 1604848048),
(310, 488, 'Rici_Seone', 103, 0, 2700000, 0),
(312, 487, 'Ibragim_Mafiozik', 0, 0, 2700000, 1604407686),
(313, 487, 'Slava_Arhipkin', 123, 1, 2700000, 0),
(314, 487, 'Andrey_Vinsent', 1, 1, 2700000, 1604407737),
(315, 487, 'Gleb_Balakhonov', 6, 1, 2700000, 1604511514),
(316, 417, 'Andrew_Marn', 0, 1, 4000000, 1604408860),
(317, 469, 'Ruslan_Magaramov', 0, 0, 2500000, 1604419787),
(319, 488, 'Oleg_Viper', 93, 1, 2700000, 1604453275),
(320, 487, 'Danik_Hartanovich', 3, 0, 2700000, 1604490081),
(323, 417, 'Timofey_Grigorov', 0, 1, 4000000, 1604827757),
(326, 469, 'Ramil_Ivanov', 0, 1, 2500000, 0),
(327, 487, 'Denis_Debilov', 0, 1, 2700000, 1604411291),
(328, 417, 'Ilya_Chaily', 0, 1, 4000000, 0),
(329, 488, 'SEltan_Axmetob', 0, 0, 2700000, 0),
(330, 488, 'Andrey_Korol', 0, 0, 2700000, 0),
(331, 487, 'Alekc_Gromov', 0, 0, 2700000, 1604514517),
(332, 488, 'Eduard_Armani', 0, 0, 2700000, 0),
(333, 488, 'Samuel_Armani', 0, 1, 2700000, 0),
(335, 487, 'Nikolai_Ermilov', 3, 1, 2700000, 0),
(336, 487, 'Tommy_Krispin', 101, 0, 2700000, 1604504624),
(337, 487, 'Egor_Agapov', 0, 1, 2700000, 1604413058),
(338, 487, 'Lucky_Luciano', 123, 0, 2700000, 0),
(339, 469, 'Kaleo_Fryman', 123, 0, 2500000, 0),
(340, 469, 'Ivan_Carter', 0, 1, 2500000, 1604411783),
(342, 487, 'Lord_Magnezi', 0, 1, 2700000, 0),
(343, 487, 'Islam_Lyanov', 0, 1, 2700000, 1604413447),
(344, 487, 'Vlad_Ternitsa', 0, 1, 2700000, 0),
(345, 487, 'Jerry_Morty', 0, 0, 2700000, 1604414412),
(346, 488, 'Yung_Hufner', 0, 0, 2700000, 0),
(347, 488, 'Nikita_Fomichev', 0, 1, 2700000, 0),
(348, 469, 'Yura_Pathronovich', 0, 1, 2500000, 0),
(349, 417, 'Stepa_Merlow', 123, 1, 4000000, 0),
(350, 469, 'Tolya_Rubanok', 0, 1, 2500000, 0),
(352, 487, 'Leo_Lagenberg', 0, 1, 2700000, 0),
(353, 487, 'Joni_Naymov', 0, 0, 2700000, 0),
(355, 488, 'James_Clouv', 103, 0, 2700000, 1604492157),
(358, 469, 'Andrey_Turov', 0, 0, 2500000, 1604491002),
(360, 487, 'Islam_Tsurov', 0, 1, 2700000, 1604416112),
(363, 417, 'Nikolay_Egorov', 101, 1, 4000000, 1604418189),
(364, 487, 'Alexandr_Kingston', 0, 1, 2700000, 1604416912),
(365, 487, 'Joseph_Shelby', 3, 1, 2700000, 0),
(366, 487, 'Kirill_Pronsik', 6, 1, 2700000, 0),
(367, 469, 'Leeon_Adame', 0, 1, 2500000, 1604417348),
(368, 417, 'Aleksand_Flores', 0, 0, 4000000, 0),
(369, 469, 'Ruslsn_Mafioziv', 0, 1, 2500000, 0),
(370, 417, 'Bogdan_Xxx', 0, 1, 4000000, 1604664065),
(371, 487, 'Alexander_Gorov', 0, 1, 2700000, 1604438137),
(373, 488, 'Aleksei_Gulitski', 0, 1, 2700000, 1604526503),
(374, 487, 'Ficus_Verebe', 0, 0, 2700000, 0),
(376, 417, 'Operp_stail', 103, 1, 4000000, 0),
(378, 487, 'Leonardo_Revel', 101, 1, 2700000, 1604419917),
(379, 469, 'Saimur_Soprano', 101, 1, 2500000, 0),
(381, 488, 'Ferger_Bondar', 0, 1, 2700000, 0),
(382, 488, 'Papa_Rimsky', 0, 1, 2700000, 0),
(383, 469, 'Artem_Schirov', 6, 1, 2500000, 1604420724),
(384, 488, 'Mike_Nowman', 101, 1, 2700000, 1604687911),
(385, 487, 'Zelezov_Daniil', 0, 0, 2700000, 1604421209),
(387, 488, 'Takeda_Minato', 0, 1, 2700000, 1604670147),
(389, 487, 'Vadim_Versetti', 0, 1, 2700000, 0),
(390, 487, 'VOVA_GNIDA', 0, 1, 2700000, 0),
(391, 487, 'Vova_Versetti', 3, 0, 2700000, 0),
(392, 469, 'Rayan_Levshin', 0, 0, 2500000, 1604528876),
(393, 487, 'Ilya_Malinin', 0, 1, 2700000, 1604504097),
(394, 488, 'Vlad_Likhoivanov', 0, 1, 2700000, 0),
(395, 487, 'Voha_Likhoivanov', 3, 1, 2700000, 1604422707),
(396, 417, 'Lazarev_Tima', 3, 0, 4000000, 1604425094),
(397, 488, 'Dima_Petuhov', 0, 0, 2700000, 1604429081),
(398, 487, 'Ivan_Timohov', 0, 1, 2700000, 1604425505),
(400, 417, '....', 0, 1, 4000000, 0),
(402, 417, 'Ivan_Parchacev', 0, 1, 4000000, 1604593006),
(403, 417, 'Diana_Ahmatova', 0, 1, 4000000, 1604425834),
(404, 417, 'Misha_Bulkin', 0, 1, 4000000, 0),
(406, 417, 'Andrey_Lytikov', 0, 1, 4000000, 0),
(407, 487, 'Max_Ayfovich', 0, 1, 2700000, 1604434111),
(409, 487, 'Jason_Markov', 0, 0, 2700000, 0),
(411, 487, 'paul_xui', 3, 1, 2700000, 0),
(412, 487, 'Denis_Gromov', 3, 1, 2700000, 1604452141),
(413, 487, 'Danil_Deagles', 0, 1, 2700000, 1604427949),
(414, 488, 'Loli_pop', 3, 1, 2700000, 1604506531),
(415, 488, 'Prosto_al', 0, 1, 2700000, 0),
(416, 488, 'Amir_Kusyapkulov', 3, 1, 2700000, 0),
(417, 488, 'lvan_romokd', 0, 1, 2700000, 1604428955),
(418, 469, 'Mitya_Demons', 103, 1, 2500000, 0),
(419, 469, 'Carl_Johnson', 0, 1, 2500000, 0),
(420, 487, 'Alex_Mellian', 0, 0, 2700000, 1604492599),
(422, 488, 'Egor_Majoruk', 3, 1, 2700000, 1604430446),
(423, 487, 'Vasya_Brejov', 93, 1, 2700000, 0),
(424, 487, 'Kerik_Youtube', 0, 0, 2700000, 0),
(425, 417, 'Slavk_Slava', 0, 0, 4000000, 0),
(426, 488, 'Peace_Death', 0, 1, 2700000, 1604430767),
(427, 487, 'Natali_Bogacheva', 1, 1, 2700000, 0),
(428, 417, 'Sakyra_Rmpage', 3, 1, 4000000, 1604431249),
(429, 487, 'Yraslavz_Golos', 6, 1, 2700000, 1604506274),
(430, 417, 'Fedor_Criminalov', 86, 1, 4000000, 1604434122),
(432, 469, 'Misha_Voronin', 0, 0, 2500000, 1604434089),
(434, 487, 'Angpeu_Poka', 0, 0, 2700000, 1604495209),
(435, 487, 'Ivan_Drugan', 0, 1, 2700000, 0),
(437, 417, 'Maxim_Mentov', 0, 1, 4000000, 1604475815),
(438, 487, 'Vlad_Nyman', 3, 1, 2700000, 1604484867),
(439, 487, 'Maxim_Waynne', 0, 1, 2700000, 1604437669),
(440, 487, 'Ulyana_Novikova', 103, 0, 2700000, 1604454659),
(442, 487, 'Rich_Vanfuhrer', 0, 1, 2700000, 0),
(443, 417, 'Artem_Almaev', 0, 1, 4000000, 0),
(444, 417, 'Roma_Bercha', 0, 0, 4000000, 0),
(445, 487, 'ivan_ivanf', 0, 1, 2700000, 1604439022),
(446, 487, 'Maxim_Salan', 0, 0, 2700000, 0),
(447, 487, 'Kirill_Posohin', 0, 0, 2700000, 1604509747),
(449, 469, 'Ivan_Galisin', 0, 1, 2500000, 1604441617),
(450, 417, 'Richard_Cherry', 0, 1, 4000000, 0),
(452, 417, 'Voldemar_Phoenix', 0, 1, 4000000, 0),
(453, 487, 'Cutrys_Tv', 0, 0, 2700000, 0),
(454, 487, 'Mark_Sharipov', 93, 1, 2700000, 0),
(457, 487, 'Vitos_Kotkov', 0, 1, 2700000, 0),
(460, 469, 'Tom_Xeno', 0, 1, 2500000, 0),
(461, 488, 'Nazar_Bovkun', 0, 0, 2700000, 1604464254),
(463, 487, 'Grigoriy_Izmaylov', 0, 1, 2700000, 1604491894),
(465, 487, 'Dima_Mozorov', 0, 1, 2700000, 1604453360),
(467, 488, 'Ramzan_Taramov', 0, 0, 2700000, 0),
(468, 488, 'Roma_Suzuki', 0, 1, 2700000, 1604453625),
(469, 487, 'Nurali_Temergalitop', 0, 1, 2700000, 1604458189),
(470, 417, 'Angel_Crippsite', 123, 0, 4000000, 0),
(471, 487, 'Ilya_Shishkov', 0, 1, 2700000, 1604551481),
(472, 417, 'Ilya_Zhuravlev', 0, 0, 4000000, 1604546826),
(473, 488, 'Bueno_Morty', 0, 0, 2700000, 1604563046),
(474, 487, 'Gucci_Mellstroy', 0, 1, 2700000, 1604466887),
(475, 487, 'Nazar_Gordey', 3, 0, 2700000, 1604479261),
(476, 469, 'dima', 86, 0, 2500000, 0),
(477, 487, 'Don_Macarov', 0, 1, 2700000, 0),
(478, 417, 'Frank_Balenciaga', 0, 1, 4000000, 1604523667),
(479, 469, 'Warrior_Macalister', 0, 1, 2500000, 0),
(480, 487, 'Alex_Prery', 0, 0, 2700000, 0),
(482, 469, 'VITALY_medvedev', 3, 0, 2500000, 1604504257),
(484, 487, 'Daniil_Karmanov', 0, 0, 2700000, 0),
(485, 488, 'Vitalij_Mitukov', 6, 0, 2700000, 0),
(486, 487, 'Frank_Terry', 0, 1, 2700000, 0),
(487, 469, 'Ivan_Miniffov', 0, 1, 2500000, 1604479590),
(490, 417, 'Faizyycrazyyy', 0, 1, 4000000, 0),
(491, 487, 'Bruno_Castello', 0, 0, 2700000, 1604663562),
(493, 487, 'Nail_Shelby', 0, 1, 2700000, 0),
(494, 417, 'The_Seryozha', 0, 1, 4000000, 0),
(497, 469, 'Sakura_Uchiha', 0, 1, 2500000, 0),
(500, 417, 'Nikitap_opalox', 0, 1, 4000000, 0),
(501, 488, 'Nureke_Muhametkali', 0, 0, 2700000, 0),
(502, 469, 'Daniel_Morgan', 0, 1, 2500000, 1604570407),
(503, 417, 'Stepa_Pel', 0, 0, 4000000, 1604487424),
(504, 417, 'DANILKA_RUS', 93, 1, 4000000, 0),
(505, 417, 'Morgan_Cherri', 3, 1, 4000000, 0),
(506, 487, 'Serega_Vologov', 0, 1, 2700000, 1604486364),
(507, 469, 'Maksim_Ty', 0, 1, 2500000, 0),
(509, 488, 'Nikita_Artamonov', 101, 0, 2700000, 1604488758),
(510, 487, 'Alan_Urusov', 0, 1, 2700000, 0),
(513, 487, 'Vadya_Morozov', 86, 1, 2700000, 0),
(516, 487, 'Serega_Anoni', 0, 1, 2700000, 0),
(517, 487, 'Kevin_Dellstalion', 0, 0, 2700000, 1604490519),
(518, 488, 'Pavel_Efremov', 0, 0, 2700000, 0),
(520, 487, 'Daniel_Matveev', 0, 1, 2700000, 1604491593),
(523, 487, 'Michail_Dizel', 0, 0, 2700000, 1604520064),
(524, 469, 'Mihail_Orlov', 0, 0, 2500000, 0),
(525, 487, 'Ilya_Firsov', 3, 1, 2700000, 0),
(526, 488, 'Misha_Mesropov', 0, 0, 2700000, 0),
(529, 487, 'Brain_Soko', 0, 1, 2700000, 1604493188),
(530, 487, 'Arthur_Shelby', 1, 1, 2700000, 0),
(531, 469, 'Denisa_Akulek', 93, 0, 2500000, 1604493763),
(532, 417, 'Zack_Jefferson', 123, 0, 4000000, 1604494278),
(533, 487, 'Sanches_Vinson', 0, 1, 2700000, 1604546611),
(534, 417, 'Artem_Tyrmovich', 0, 0, 4000000, 0),
(535, 469, 'Danylo_Racer', 3, 0, 2500000, 0),
(536, 417, 'Yum_Bratyaga', 0, 1, 4000000, 0),
(538, 469, 'Maksus', 0, 1, 2500000, 0),
(539, 487, 'XaKeR_SaRdeLka', 0, 0, 2700000, 1604637784),
(541, 488, 'Kolya_Litvin', 0, 1, 2700000, 0),
(543, 417, 'Stepa_Lazovscki', 0, 0, 4000000, 0),
(544, 417, 'Nikita_Pavlov', 0, 0, 4000000, 0),
(546, 487, 'Michael_Winston', 0, 1, 2700000, 1604498319),
(548, 488, 'Nikita_Milkin', 0, 0, 2700000, 0),
(549, 417, 'Niqolai_pykakov', 0, 1, 4000000, 0),
(552, 487, 'Artem_Amigos', 0, 1, 2700000, 0),
(553, 488, 'Jone_Wut', 103, 1, 2700000, 0),
(555, 487, 'Nikolas_Soer', 0, 0, 2700000, 1604501873),
(556, 488, 'Ivan_Faytev', 0, 0, 2700000, 1604835868),
(557, 488, 'Kolyan_Nimers', 0, 0, 2700000, 1604501816),
(559, 488, 'Pasha_Grek', 0, 1, 2700000, 1604503108),
(560, 487, 'Kwit_Macalister', 123, 0, 2700000, 0),
(561, 488, 'Temka_MaralIes', 6, 1, 2700000, 0),
(562, 487, 'Igor_Sychev', 6, 1, 2700000, 1604502973),
(563, 417, 'Sand_Asder', 123, 0, 4000000, 0),
(565, 469, 'Fred_Mahwell', 0, 1, 2500000, 0),
(566, 488, 'Daniil_People', 0, 0, 2700000, 0),
(569, 487, 'Ivan_Zverkov', 0, 1, 2700000, 0),
(570, 487, 'Den_Viton', 0, 1, 2700000, 0),
(572, 469, 'Adel_Uzzinov', 0, 0, 2500000, 1604518787),
(575, 487, 'Joe_Macalister', 0, 1, 2700000, 0),
(576, 487, 'Alexey_Veregin', 0, 0, 2700000, 0),
(577, 488, 'Alina_Grig', 86, 0, 2700000, 1604512671),
(578, 488, 'Nikita_Deep', 0, 1, 2700000, 1604512544),
(579, 487, 'Nick_Vanfuhrer', 103, 0, 2700000, 0),
(580, 417, 'Czar_Game', 0, 1, 4000000, 1604516533),
(581, 487, 'Dima_Kolbasa', 0, 0, 2700000, 0),
(582, 488, 'Timur_Galimov', 0, 0, 2700000, 1604655953),
(583, 488, 'Tema_Hollywood', 0, 1, 2700000, 1604515294),
(585, 488, 'Aleksandr_Mihalkov', 3, 0, 2700000, 1604516005),
(586, 487, 'Leonardo_Wayne', 1, 1, 2700000, 1604515861),
(588, 487, 'Miter_dog', 0, 1, 2700000, 0),
(589, 417, 'Anton_Serinko', 0, 1, 4000000, 1604670357),
(590, 469, 'Kroki_Darkside', 0, 0, 2500000, 0),
(591, 487, 'Kenzo_Fiyero', 0, 0, 2700000, 0),
(592, 487, 'Ferger_Bondaq', 0, 0, 2700000, 1604516686),
(596, 417, 'Vano_Malahov', 0, 0, 4000000, 0),
(597, 488, 'Yun_Yeager', 0, 0, 2700000, 0),
(598, 487, 'Ilya_Sayrex', 1, 0, 2700000, 1604841406),
(600, 488, 'Andriana_Uzumaky', 3, 0, 2700000, 1604745268),
(601, 487, 'Vlad_Valaksov', 0, 0, 2700000, 0),
(602, 417, 'Danilka_Racer', 0, 1, 4000000, 1604599826),
(603, 417, 'Maks_Karenkov', 0, 1, 4000000, 1604852773),
(606, 487, 'Jobs_Hobs', 1, 1, 2700000, 0),
(607, 469, 'vlavel_topchik', 0, 0, 2500000, 1604524292),
(608, 417, 'Endo_Tensei', 0, 0, 4000000, 0),
(609, 417, 'Vladimir_Coronavirus', 123, 1, 4000000, 0),
(610, 488, 'Alesha_Petrovich', 0, 1, 2700000, 1604583002),
(611, 487, 'Ivan_Pepper', 0, 1, 2700000, 1604525747),
(612, 417, 'Dinar_Amirzyanov', 0, 1, 4000000, 0),
(613, 488, 'John_Crabery', 0, 1, 2700000, 0),
(614, 487, 'Danil_Karroty', 3, 0, 2700000, 1604537514),
(617, 487, 'Alexander_Ivanov', 93, 0, 2700000, 0),
(618, 487, 'Vasily_Voronin', 0, 1, 2700000, 0),
(619, 488, 'Donalld_Trump', 3, 0, 2700000, 1604556936),
(620, 417, 'Yomi_Tylim', 0, 0, 4000000, 0),
(621, 487, 'Leonardo_Verik', 6, 1, 2700000, 1604557584),
(622, 417, 'Samm_Neckron', 0, 0, 4000000, 1604577093),
(623, 417, 'Nikita_Grabovich', 3, 1, 4000000, 1604560451),
(624, 488, 'Alexsandr_Sopronov', 0, 0, 2700000, 0),
(625, 487, 'Jake_Moon', 0, 0, 2700000, 0),
(627, 469, 'Ivan_Debilov', 0, 0, 2500000, 0),
(628, 417, 'Pasha_Pomidorov', 0, 1, 4000000, 0),
(630, 487, 'Andrey_Stromberger', 0, 0, 2700000, 1604565525),
(632, 488, 'Cyril_Vladimirov', 1, 0, 2700000, 0),
(633, 488, 'Donald_Dag', 0, 1, 2700000, 0),
(635, 488, 'Siko_Alri', 3, 0, 2700000, 0),
(636, 488, 'Maks_Dadruk', 0, 1, 2700000, 0),
(637, 487, 'Vlad_Konashan', 0, 0, 2700000, 0),
(638, 417, 'Kirill_Feet', 0, 1, 4000000, 1604571425),
(640, 469, 'Anya_Keksik', 0, 0, 2500000, 0),
(641, 488, 'Vasa_Vicak', 0, 1, 2700000, 0),
(642, 488, 'Adam_Luxor', 0, 0, 2700000, 1604576923),
(643, 417, 'Tailer_Morgan', 0, 1, 4000000, 1604672469),
(645, 488, 'Done_Karleone', 0, 1, 2700000, 0),
(646, 417, 'Admini_Luchshie', 0, 0, 4000000, 0),
(647, 488, 'Denus_Pankratov', 0, 0, 2700000, 0),
(649, 487, 'Nikos_Larionov', 1, 0, 2700000, 1604579518),
(650, 417, 'Drake_Londom', 0, 0, 4000000, 0),
(651, 487, 'Kosta_Popovoz', 0, 0, 2700000, 1604580226),
(653, 469, 'Dmitriy_Belorusov', 0, 1, 2500000, 1604665506),
(654, 417, 'Nikita_Norik', 103, 1, 4000000, 0),
(656, 487, 'Vladimir_Analniy', 0, 1, 2700000, 0),
(658, 469, 'Sasha_Chmoshnik', 0, 0, 2500000, 1604585053),
(659, 417, 'Slavik_Slava', 86, 0, 4000000, 0),
(660, 487, 'Dimas_Tutakulov', 1, 0, 2700000, 0),
(664, 487, 'Dima_Raniuc', 0, 0, 2700000, 1604593014),
(665, 488, 'Danuul_Benmorov', 0, 1, 2700000, 1604593883),
(667, 487, 'Zeka_Pels', 0, 0, 2700000, 0),
(670, 469, 'Arsen_Odens', 0, 1, 2500000, 1604597528),
(671, 469, 'Jery_Hokage', 0, 0, 2500000, 0),
(672, 488, 'Kirya_Tsahlo', 0, 0, 2700000, 1604598489),
(674, 487, 'Kira_Irak', 0, 0, 2700000, 1604599650),
(676, 487, 'fed', 101, 1, 2700000, 0),
(677, 487, 'Vasiliy_Kozhedub', 103, 1, 2700000, 0),
(679, 488, 'Dima_Hines', 0, 0, 2700000, 0),
(680, 487, 'Egor_Makaronov', 0, 0, 2700000, 0),
(681, 469, 'dereka_lord', 0, 0, 2500000, 0),
(682, 469, 'vlad_morg', 0, 1, 2500000, 0),
(684, 469, 'Danila_Corleone', 0, 1, 2500000, 0),
(685, 488, 'lvan_lvanov', 0, 1, 2700000, 1604621902),
(687, 487, 'Timur_Borzov', 1, 1, 2700000, 1604634326),
(688, 417, 'Anton_Gorodetskiy', 123, 1, 4000000, 0),
(689, 488, 'Arseniy_Shaidurov', 0, 0, 2700000, 1604642486),
(690, 487, 'Andrushka_Ruban', 0, 0, 2700000, 1604662680),
(691, 417, 'BYCTEP_DAQBNU', 103, 0, 4000000, 0),
(692, 417, 'Romik_Nurmagomedov', 0, 1, 4000000, 0),
(693, 417, 'Dan_Ponomar', 0, 1, 4000000, 0),
(694, 487, 'Ray_Crips', 123, 1, 2700000, 0),
(695, 487, 'Nikita_Enin', 0, 0, 2700000, 1604647651),
(696, 487, 'Yura_Astashow', 0, 1, 2700000, 0),
(697, 469, 'Slavik_Dublin', 86, 0, 2500000, 1604815927),
(703, 417, 'Axmed_Flow', 0, 0, 4000000, 0),
(705, 487, 'Nekit_Bichevich', 3, 1, 2700000, 0),
(706, 417, 'Bartolomeo_Allen', 0, 0, 4000000, 1604653321),
(707, 488, 'Andrushka_Vatovski', 0, 0, 2700000, 1604653916),
(708, 469, 'Dima_Dronoiv', 0, 0, 2500000, 1604655001),
(709, 487, 'Kizuki_Futurama', 123, 1, 2700000, 0),
(710, 469, 'Artem_Deepov', 0, 0, 2500000, 0),
(711, 417, 'Maksim_Volkov', 0, 1, 4000000, 0),
(712, 417, 'Artem_Marlow', 3, 0, 4000000, 0),
(713, 488, 'Danila_Efrov', 6, 0, 2700000, 0),
(714, 417, 'Morty_Peep', 0, 0, 4000000, 0),
(716, 487, 'Thomas_Shelby', 0, 0, 2700000, 0),
(717, 487, 'John_SwiftKey', 0, 0, 2700000, 0),
(719, 469, 'Danielo_Konash', 0, 1, 2500000, 0),
(722, 488, 'Mark_Nataliev', 0, 1, 2700000, 0),
(723, 487, 'Denis_Gromnicki', 0, 0, 2700000, 0),
(725, 417, 'Will_Macalister', 0, 1, 4000000, 1604664710),
(726, 469, 'Tom_Redsel', 0, 1, 2500000, 0),
(727, 469, 'Mixa_Polona', 0, 0, 2500000, 0),
(728, 487, 'Demon_Trys', 6, 0, 2700000, 1604667493),
(729, 469, 'Stas_ttte', 0, 1, 2500000, 0),
(731, 469, 'Arina_Kykyshkina', 0, 0, 2500000, 0),
(733, 487, 'Lacoste_Hokage', 0, 0, 2700000, 1604669750),
(734, 417, 'Ivan_Muxamedov', 0, 0, 4000000, 0),
(735, 417, 'Henry_Locometoni', 0, 1, 4000000, 1604672047),
(736, 487, 'Kirill_Play', 0, 1, 2700000, 0),
(737, 487, 'Yraslavz_Maidax', 6, 0, 2700000, 1604672540),
(738, 417, 'Buster_lala', 0, 0, 4000000, 0),
(739, 417, 'Kamo_Stepanov', 0, 0, 4000000, 0),
(740, 417, 'Sasha_Dub', 6, 1, 4000000, 0),
(741, 417, 'Lorenso_Heroes', 0, 0, 4000000, 0),
(742, 487, 'Kalan_Antonuk', 0, 1, 2700000, 0),
(743, 417, 'Nikita_Morozka', 0, 0, 4000000, 0),
(744, 417, 'Frederic_Capone', 0, 0, 4000000, 0),
(745, 417, 'Ditrich_Storm', 123, 0, 4000000, 1604682155),
(747, 469, 'Maksum_Harchenko', 0, 1, 2500000, 1604683335),
(748, 469, 'Pasha_Kros', 0, 1, 2500000, 0),
(751, 469, 'Adam_Kotik', 0, 0, 2500000, 1604688815),
(754, 488, 'Afanasiy_Nikitin', 0, 1, 2700000, 0),
(755, 487, 'Marat_Kozyr', 3, 0, 2700000, 1604692881),
(756, 487, 'Illa_Borovoy', 0, 0, 2700000, 1604693086),
(757, 488, 'Johan_Chpohan', 0, 1, 2700000, 1604693815),
(759, 417, 'Ega_Govnoed', 0, 1, 4000000, 0),
(760, 487, 'Dima_Poholl', 3, 1, 2700000, 0),
(762, 469, 'Nikita_Nikitos', 0, 1, 2500000, 1604697406),
(763, 417, 'Malfoy_Wersetty', 0, 1, 4000000, 1604697371),
(765, 469, 'Putin_Vladimir', 101, 0, 2500000, 0),
(768, 487, 'Maksim_Henessy', 0, 1, 2700000, 0),
(769, 417, 'Robik_Angel', 0, 0, 4000000, 1604702643),
(770, 417, 'Ramazan_Chahuh', 0, 1, 4000000, 1604701655),
(771, 487, 'Motteo_Malboro', 3, 0, 2700000, 0),
(775, 469, 'Sergei_Replay', 0, 0, 2500000, 1604710976),
(776, 487, 'Stepka_Lombardi', 93, 0, 2700000, 1604718232),
(777, 487, 'Erik_Ferreo', 0, 1, 2700000, 0),
(780, 488, 'Lorenzo_Bloodz', 103, 0, 2700000, 0),
(783, 487, 'Alex_Potop', 0, 1, 2700000, 1604740343),
(784, 487, 'Maksym_Maksymov', 0, 1, 2700000, 0),
(786, 417, 'Artem_Mayski', 0, 0, 4000000, 1604743674),
(787, 488, 'Isuzu_Tcof', 6, 1, 2700000, 1604743814),
(788, 417, 'Nikita_Salat', 0, 0, 4000000, 0),
(791, 487, 'Kiril_Habarov', 0, 0, 2700000, 1604817115),
(792, 488, 'Vanya_Latish', 0, 0, 2700000, 1604751622),
(793, 487, 'Knaz_Vladimir', 0, 0, 2700000, 0),
(794, 469, 'Nick_Naty', 0, 1, 2500000, 0),
(795, 487, 'Andrey_Tr', 0, 1, 2700000, 1604754487),
(796, 488, 'Nasta_Izmailova', 0, 0, 2700000, 0),
(799, 469, 'Natali_Pow', 0, 1, 2500000, 0),
(801, 469, 'Bartomero_Gari', 103, 1, 2500000, 0),
(802, 417, 'Vadim_Retri', 0, 0, 4000000, 0),
(803, 487, 'Artem_Kipeev', 0, 1, 2700000, 0),
(804, 417, 'Nikita_Mayskiy', 0, 1, 4000000, 0),
(806, 469, 'Maksim_Safonkin', 0, 0, 2500000, 0),
(807, 487, 'Terry_Lordeckiy', 101, 0, 2700000, 1604764191),
(808, 487, 'Sein_Kapone', 0, 1, 2700000, 1604765061),
(809, 487, 'Nazar_Bernik', 0, 0, 2700000, 1604766829),
(810, 417, 'Ruslan_Seruh', 6, 1, 4000000, 0),
(811, 488, 'Kolya_Hamer', 0, 1, 2700000, 0),
(812, 488, 'Egor_Boreiko', 0, 0, 2700000, 0),
(813, 417, 'Danik_Rolep', 0, 0, 4000000, 1604768896),
(814, 469, 'Artem_Dagaravih', 0, 0, 2500000, 1604838669),
(815, 469, 'John_Harrington', 0, 1, 2500000, 0),
(816, 487, 'Maxim_Gluschenko', 1, 0, 2700000, 1604773464),
(817, 487, 'Nik_Sivo', 0, 1, 2700000, 0),
(818, 487, 'Artem_Lam', 0, 0, 2700000, 1604813341),
(820, 487, 'Andrew_Isanko', 0, 0, 2700000, 0),
(821, 417, 'Adolf_Derkachev', 0, 1, 4000000, 0),
(826, 487, 'Ivan_Mezeev', 0, 0, 2700000, 0),
(827, 487, 'Artem_Temochik', 0, 1, 2700000, 1604784262),
(828, 469, 'Nikita_Kizaru', 0, 1, 2500000, 0),
(829, 417, 'Andrei_Votinov', 101, 0, 4000000, 0),
(830, 469, 'Lev_Feofilov', 0, 0, 2500000, 0),
(831, 417, 'Andreu_Ramanauskas', 123, 0, 4000000, 0),
(832, 417, 'Diana_Yanko', 93, 1, 4000000, 0),
(833, 417, 'Aid_Libovskiy', 0, 1, 4000000, 0),
(834, 417, 'Artem_Levcenko', 0, 0, 4000000, 0),
(835, 487, 'Grigory_Malevich', 101, 1, 2700000, 1604799422),
(837, 417, 'Karim_Tastanov', 0, 0, 4000000, 0),
(838, 469, 'Timur_Tastanov', 0, 0, 2500000, 0),
(839, 417, 'Georgiy_Neroznikov', 93, 1, 4000000, 0),
(840, 417, 'Jackson_Proud', 86, 1, 4000000, 0),
(841, 487, 'Daniel_Karleone', 0, 0, 2700000, 1604815559),
(843, 417, 'Artem_Bakaev', 0, 1, 4000000, 0),
(844, 487, 'Vlad_Kirilov', 0, 0, 2700000, 0),
(845, 488, 'Aram_Gromov', 93, 0, 2700000, 0),
(846, 487, 'Roman_Busterenko', 0, 1, 2700000, 0),
(847, 417, 'Gerald_Spreyt', 0, 0, 4000000, 0),
(850, 487, 'Genrix_Mallkov', 0, 1, 2700000, 1604828488),
(851, 487, 'Artem_Berezovskiy', 0, 1, 2700000, 0),
(852, 487, 'Daniil_Bragas', 6, 1, 2700000, 1604832126),
(853, 417, 'Masha_Laryonova', 6, 1, 4000000, 0),
(854, 487, 'Vitaly_Lipovkin', 0, 1, 2700000, 0),
(856, 417, 'Miroslav_Snow', 0, 1, 4000000, 0),
(857, 417, 'Sasha_Busterenko', 0, 0, 4000000, 0),
(858, 469, 'Ilya_Lemfie', 0, 1, 2500000, 1604867523),
(859, 417, 'Ilya_Varov', 0, 1, 4000000, 0),
(860, 488, 'Artem_Flesh', 0, 1, 2700000, 1604855446),
(861, 487, 'Stas_Wilessn', 0, 1, 2700000, 0),
(862, 417, 'Alisher_Targirow', 0, 1, 4000000, 1604834529),
(864, 488, 'Sasha_Duuuub', 0, 1, 2700000, 1604835881),
(865, 469, 'XXXXX', 0, 1, 2500000, 1604836514),
(866, 469, 'Dima_Mokkii', 86, 0, 2500000, 0),
(867, 487, 'Nick_Nato', 0, 0, 2700000, 0),
(868, 469, 'Sergey_Levchenko', 0, 0, 2500000, 0),
(869, 487, 'Vova_Krollin', 0, 0, 2700000, 1604840395),
(870, 417, 'Ice_Faer', 0, 1, 4000000, 0),
(871, 487, 'Waded_Torrential', 6, 0, 2700000, 1604840466),
(873, 417, 'Roman_Ahmethanov', 0, 0, 4000000, 0),
(875, 487, 'Sanya_D', 3, 0, 2700000, 0),
(876, 417, 'Max_Lut', 0, 0, 4000000, 0),
(880, 417, 'Oleg_Ptyskhin', 0, 1, 4000000, 0),
(882, 487, 'Anton_Pyatigorskiy', 0, 1, 2700000, 0),
(883, 487, 'Ahmed_Nasurov', 0, 0, 2700000, 0),
(884, 487, 'Misha_Nakint', 0, 0, 2700000, 0),
(885, 487, 'Alex_Aprofenov', 93, 0, 2700000, 0),
(887, 469, 'Dronkin_Maxim', 0, 1, 2500000, 0),
(888, 417, 'Don_Ygan', 0, 1, 4000000, 0),
(889, 469, 'Denis_Sabarmetovv', 0, 1, 2500000, 0),
(890, 469, 'Stas_Vetchakov', 0, 1, 2500000, 0),
(893, 487, 'Nick_Maralles', 103, 1, 2700000, 0),
(895, 469, 'Dagestan_Oper', 0, 1, 2500000, 0),
(896, 417, 'Sanya_Polk', 0, 1, 4000000, 0),
(897, 487, 'Ivan_Franchakov', 3, 1, 2700000, 0),
(898, 487, 'Nikita_Frolov', 0, 0, 2700000, 0),
(899, 487, 'Artem_gopnik', 86, 0, 2700000, 1604864782),
(900, 487, 'Nick_Swap', 0, 1, 2700000, 0),
(902, 417, 'Valintin_Nona', 123, 0, 4000000, 0),
(903, 487, 'Vlad_Mollen', 0, 1, 2700000, 0),
(904, 488, 'Drynia_Gazaev', 6, 1, 2700000, 0),
(905, 487, 'Nazar_Fil', 6, 0, 2700000, 0),
(906, 469, 'Yun_Moore', 0, 1, 2500000, 0),
(907, 417, 'Artem_Karp', 0, 1, 4000000, 1604869707),
(911, 487, 'Andriano_Makaka', 86, 1, 2700000, 1604870252),
(912, 487, 'Montano_Corleone', 3, 1, 2700000, 1604871940),
(913, 469, 'Kirill_Tagirov', 0, 0, 2500000, 0),
(914, 417, 'Andrey_Yellow', 0, 1, 4000000, 1606001315),
(915, 417, 'Ilas_Garipov', 0, 1, 4000000, 0),
(916, 469, 'Aleksei_Shitikov', 0, 1, 2500000, 1606028065),
(917, 488, 'Kirill_Tagirovich', 0, 1, 2700000, 0),
(918, 417, 'Rudy_Bill', 0, 1, 4000000, 0),
(919, 469, 'Ilya_Fonerkin', 0, 1, 2500000, 0),
(920, 417, 'Kirill_Fil', 101, 1, 4000000, 0),
(921, 417, 'Artur_Code', 0, 0, 4000000, 0),
(922, 488, 'Alex_Hunder', 0, 1, 2700000, 0),
(923, 487, 'Wexler_Artyom', 0, 1, 2700000, 0),
(924, 487, 'Daniel_Oerko', 0, 0, 2700000, 0),
(925, 417, 'Matvei_Malinovskiy', 0, 1, 4000000, 0),
(926, 469, 'Ilya_Polit', 0, 1, 2500000, 1606525105),
(927, 469, 'Ignat_Laskovenkov', 0, 1, 2500000, 1606578902),
(928, 417, 'Egor_Yakowlew', 0, 1, 4000000, 0),
(929, 488, 'Vasilev_lexs', 0, 0, 2700000, 0),
(930, 488, 'Sanya_Kvitka', 0, 0, 2700000, 1606645054),
(932, 417, 'Denis_Gridin', 86, 1, 4000000, 1606592074),
(933, 488, 'Kostya_Dornod', 0, 0, 2700000, 0),
(934, 417, 'hackope_maksay', 0, 1, 4000000, 0),
(935, 488, 'Alexey_Robertov', 0, 0, 2700000, 0),
(936, 417, 'Michael_Miers', 0, 0, 4000000, 0),
(937, 417, 'Milioner_Maks', 0, 0, 4000000, 0),
(938, 417, 'Dimasik_Uldasev', 0, 1, 4000000, 1606601699),
(939, 488, 'Yarrik_Dester', 0, 1, 2700000, 1606602225),
(940, 487, 'Lisa_pruvet', 0, 0, 2700000, 0),
(942, 488, 'Sasha_Surova', 0, 0, 2700000, 0),
(943, 488, 'Dima_Korotkov', 0, 0, 2700000, 1606623411),
(944, 469, 'Hekit_Cumakov', 0, 0, 2500000, 0),
(945, 417, 'Artur_Dzagoev', 0, 1, 4000000, 1606634335),
(946, 469, 'Tomas_Vetseti', 0, 1, 2500000, 0),
(947, 469, 'Misha_polamarchuck', 0, 1, 2500000, 0),
(948, 487, 'Valrij_Litvin', 0, 0, 2700000, 0),
(949, 417, 'Tom_Jackson', 0, 1, 4000000, 0),
(950, 487, 'Kerill_Enth', 0, 0, 2700000, 1606645738),
(951, 487, 'Dmitry_Romanenko', 0, 1, 2700000, 0),
(953, 417, 'Dmitry_Johnes', 0, 1, 4000000, 0),
(954, 469, 'ARTEM_STAY', 0, 1, 2500000, 0),
(955, 487, 'Igor_Rogovskiu', 93, 1, 2700000, 0),
(956, 469, 'Alex_Martin', 0, 0, 2500000, 0),
(957, 487, 'Sergey_Yrakov', 0, 1, 2700000, 0),
(958, 487, 'Vitalii_Dzagoev', 0, 0, 2700000, 1607617455),
(959, 469, 'Hermann_Eberlin', 101, 0, 2500000, 0),
(960, 417, 'Ravil_Floyd', 0, 0, 4000000, 1609340201),
(961, 488, 'Mixa_Savcenco', 6, 1, 2700000, 0),
(962, 487, 'Dmitry_Howar', 1, 1, 2700000, 1609353350),
(963, 487, 'maxim_gridnov', 0, 0, 2700000, 1609350156),
(964, 488, 'Gleb_Efremov', 0, 0, 2700000, 0),
(965, 417, 'Bogdan_Topo', 0, 1, 4000000, 0),
(966, 487, 'Nikita_RABA', 103, 0, 2700000, 0),
(967, 488, 'Dima_Deryugin', 93, 0, 2700000, 0),
(968, 487, 'Yarick_Cross', 86, 1, 2700000, 1609759084),
(969, 488, 'Daniil_Prull', 93, 1, 2700000, 1609804723),
(970, 487, 'Lord_Drucker', 1, 1, 2700000, 1609830934),
(971, 488, 'Tommu_Flow', 103, 1, 2700000, 0),
(972, 487, 'Tommy_Gop', 93, 0, 2700000, 0),
(973, 488, 'Arik_Vapehk', 0, 1, 2700000, 1609873373),
(974, 488, 'Evgeniy_Kaktus', 1, 0, 2700000, 1609866192),
(975, 487, 'Mister_Pavlik', 0, 0, 2700000, 1609934799),
(976, 417, 'Dima_filatov', 0, 1, 4000000, 0),
(977, 417, 'vovavn_olosenko', 0, 0, 4000000, 0),
(978, 488, 'Hennesy_Lacoste', 0, 1, 2700000, 0),
(979, 487, 'Iliasik_Asik', 0, 0, 2700000, 0),
(980, 487, 'Kirill_Aristarhov', 0, 0, 2700000, 1609923800),
(981, 487, 'Ivan_Dmitrienko', 1, 0, 2700000, 0),
(982, 488, 'Dima_Balik', 101, 0, 2700000, 1609926011),
(983, 417, 'Mark_Bambeto', 0, 1, 4000000, 0),
(984, 417, 'Vany_Kolbasa', 0, 1, 4000000, 0),
(985, 487, 'Dimw_Byv', 0, 1, 2700000, 0),
(986, 417, 'Konstantin_Tureev', 0, 0, 4000000, 0),
(987, 487, 'Cris_Baby', 0, 0, 2700000, 1611214672),
(988, 417, 'Vova_viza', 0, 1, 4000000, 0),
(989, 417, 'Zero_Schevey', 0, 0, 4000000, 0),
(990, 488, 'danil_znamencev', 6, 0, 2700000, 0),
(991, 469, 'ALMAZ_BATIAEV', 0, 1, 2500000, 0),
(992, 488, 'Fania_Oper', 6, 1, 2700000, 0),
(993, 487, 'Gunoev_U', 6, 1, 2700000, 0),
(994, 488, 'Ibragim_Nasuxanov', 0, 1, 2700000, 0),
(995, 417, 'Mark_Sozonov', 0, 1, 4000000, 0),
(996, 487, 'Andrey_Greshuk', 0, 1, 2700000, 0),
(997, 487, 'Nikita_Dembrovskiy', 0, 1, 2700000, 0),
(998, 417, 'Dima_GeDfoR', 0, 1, 4000000, 0),
(999, 487, 'Kostya_Babaeb', 0, 0, 2700000, 0),
(1000, 487, 'Nik_Radek', 103, 0, 2700000, 0),
(1001, 488, 'Fixik_Samp', 0, 1, 2700000, 0),
(1002, 487, 'Dima_Rillon', 3, 0, 2700000, 0),
(1003, 487, 'Nikita_Faleleev', 0, 1, 2700000, 0),
(1004, 469, 'Nikolay_Kravchenko', 103, 1, 2500000, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `historyban`
--

CREATE TABLE `historyban` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(24) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `historyname`
--

CREATE TABLE `historyname` (
  `id` int(5) NOT NULL,
  `idacca` varchar(30) CHARACTER SET cp1251 COLLATE cp1251_bin DEFAULT NULL,
  `name` varchar(30) CHARACTER SET cp1251 COLLATE cp1251_bin DEFAULT NULL,
  `old_name` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_bin DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `allowed` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `historyname`
--

INSERT INTO `historyname` (`id`, `idacca`, `name`, `old_name`, `date`, `allowed`) VALUES
(1, '1264', 'Teddy_Macalister', 'Augustin_Macalister', '2020-11-02 16:37:07', 'Donate System'),
(2, '4745', 'Genrix_Mallkov', 'Alex_Ave', '2020-11-03 12:15:45', 'Donate System'),
(3, '1174', 'Vitali_Magnezi', 'Vitali_Suppes', '2020-11-03 22:04:50', 'Donate System'),
(4, '116', 'Dmitry_Unicorn', 'Henry_Storm', '2020-11-04 09:27:49', 'Donate System'),
(5, '3683', 'Over_Parkinson', 'Willy_Torres', '2020-11-04 09:47:58', 'Donate System'),
(6, '864', 'Richi_Gallardo', 'Nikita_Kato', '2020-11-06 13:19:13', 'Donate System'),
(7, '1881', 'Ilya_Gorin', 'Radmir_Kratov', '2020-11-06 15:01:43', 'Donate System'),
(8, '1306', 'Ivan_Carter', 'Ivan_Salov', '2020-11-06 15:45:16', 'Donate System'),
(9, '12556', 'Ilkham_Marlboro', 'Ilkham_Galimov', '2020-11-07 10:46:20', 'Donate System'),
(10, '640', 'Teodor_Lordeckiy', 'Teddy_Lordeckiy', '2020-11-08 07:02:53', 'Donate System');

-- --------------------------------------------------------

--
-- Структура таблицы `hitman`
--

CREATE TABLE `hitman` (
  `ID` int(11) NOT NULL,
  `ONLINE` int(11) NOT NULL DEFAULT 0,
  `OWNER` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '-',
  `oID` int(11) NOT NULL DEFAULT 0,
  `VICTIM` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '-',
  `vID` int(11) NOT NULL DEFAULT 0,
  `MONEY` int(11) NOT NULL DEFAULT 0,
  `UNIX_TIME` int(16) NOT NULL DEFAULT 0,
  `DATA_TIME` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Заказы для хитманов';

--
-- Дамп данных таблицы `hitman`
--

INSERT INTO `hitman` (`ID`, `ONLINE`, `OWNER`, `oID`, `VICTIM`, `vID`, `MONEY`, `UNIX_TIME`, `DATA_TIME`) VALUES
(2, -1, 'Frederic_Capone', 1032, 'Sergei_Mestniy', 1658, 10, 1604400559, '2020-11-03 10:49:19'),
(3, -1, 'Frederic_Capone', 1032, 'Dmitriy_Speenov', 6710, 10, 1604400673, '2020-11-03 10:51:13'),
(5, -1, 'Joe_Macalister', 2589, 'Doni_Ramirez', 2672, 10, 1604411971, '2020-11-03 13:59:31'),
(7, -1, 'Vladik_Brown', 9053, 'Ilya_Zhuravlev', 4515, 10, 1604456415, '2020-11-04 02:20:15'),
(8, -1, 'Vladik_Brown', 9053, 'Ilya_Zhuravlev', 4515, 10, 1604456504, '2020-11-04 02:21:44'),
(9, -1, 'Sasha_Romban', 2552, 'Dener_Ded', 8121, 10, 1604465303, '2020-11-04 04:48:23'),
(18, -1, 'Crux_Kachika', 3399, 'Marshall_Shvabra', 9757, 30, 1604557952, '2020-11-05 06:32:32'),
(21, -1, 'Zulav_Bondaruk', 1746, 'Kolyan_Nimers', 273, 44, 1604593492, '2020-11-05 16:24:52'),
(22, -1, 'Gosha_Bosow', 6525, 'Slavik_Bosow', 6535, 100, 1604593976, '2020-11-05 16:32:56'),
(25, -1, 'Roma_Harden', 2739, 'Egor_Harden', 2626, 20, 1604635147, '2020-11-06 03:59:07'),
(26, -1, 'Danila_Kogtev', 11660, 'Stepan_Kaspesky', 772, 100, 1604642853, '2020-11-06 06:07:33'),
(31, -1, 'Denis_Gromnicki', 2708, 'Sanches_Vinson', 61, 10, 1604654326, '2020-11-06 09:18:46'),
(32, -1, 'Danila_Kogtev', 11660, 'Maksum_Harchenko', 16034, 80, 1604682024, '2020-11-06 17:00:24'),
(36, -1, 'Bruno_Castello', 8669, 'Billi_Fernandez', 495, 200, 1604686704, '2020-11-06 18:18:24'),
(37, -1, 'Bruno_Castello', 8669, 'Max_Fadeev', 13915, 100, 1604686744, '2020-11-06 18:19:04'),
(38, -1, 'Alfredo_Capone', 2702, 'Sanches_Vinson', 61, 250, 1604718240, '2020-11-07 03:04:00'),
(39, -1, 'Bruno_Castello', 8669, 'Stepan_Kaspesky', 772, 260, 1604735641, '2020-11-07 07:54:01'),
(40, -1, 'Xikka_Ghora', 6434, 'Stepan_Zverev', 1663, 10, 1604750453, '2020-11-07 12:00:53'),
(42, -1, 'Gosha_Bosow', 6525, 'Stepan_Kaspesky', 772, 20, 1604761545, '2020-11-07 15:05:45'),
(44, -1, 'Danila_Kogtev', 11660, 'Stepan_Kaspesky', 772, 150, 1604769464, '2020-11-07 17:17:44'),
(45, -1, 'Kizaru_Grand', 17047, 'Yarik_Lulka', 10362, 50, 1604778371, '2020-11-07 19:46:11'),
(46, -1, 'Oleg_Zaharom', 13273, 'Aleksandr_Evseev', 12542, 40, 1604810227, '2020-11-08 04:37:07'),
(47, -1, 'Egor_Korabin', 10405, 'Nikita_Enin', 13147, 10, 1604812790, '2020-11-08 05:19:50'),
(48, -1, 'Bruno_Castello', 8669, 'Vlad_Kaspesky', 291, 370, 1604818840, '2020-11-08 07:00:40'),
(49, -1, 'Bruno_Castello', 8669, 'Harvis_Meslen', 14279, 200, 1604818867, '2020-11-08 07:01:07'),
(50, -1, 'Chirstopher_Jager', 2518, 'Dmitry_Goblikov', 17559, 20, 1604821957, '2020-11-08 07:52:37'),
(51, -1, 'Sanches_Vinson', 61, 'Harvis_Meslen', 14279, 150, 1604827803, '2020-11-08 09:30:03'),
(53, -1, 'Vlad_Kaspesky', 291, 'Harvis_Meslen', 14279, 225, 1604831575, '2020-11-08 10:32:55'),
(54, -1, 'Harvis_Meslen', 14279, 'Vlad_Kaspesky', 291, 100, 1604831584, '2020-11-08 10:33:04'),
(57, -1, 'Oleg_Zaharom', 13273, 'Denis_With', 15356, 40, 1604841633, '2020-11-08 13:20:33'),
(60, -1, 'Maksim_Safonkin', 932, 'Timur_Galimov', 4361, 99, 1604842381, '2020-11-08 13:33:01'),
(66, -1, 'Maksim_Taskinov', 3203, 'Jack_Bayrov', 365, 390, 1604844938, '2020-11-08 14:15:38'),
(67, -1, 'Artem_Levcenko', 13869, 'Sergey_Levchenko', 89, 10, 1604852222, '2020-11-08 16:17:02'),
(68, -1, 'Roman_Lavrenko', 4829, 'sosiski_v_teste', 19899, 20, 1604858750, '2020-11-08 18:05:50');

-- --------------------------------------------------------

--
-- Структура таблицы `house`
--

CREATE TABLE `house` (
  `id` int(11) NOT NULL,
  `hEntrx` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `hEntry` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `hEntrz` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `hExitx` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `hExity` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `hExitz` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `carx` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `cary` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `carz` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `carfa` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0.0',
  `hOwner` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `hOwned` int(11) NOT NULL DEFAULT -1,
  `hDiscript` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Дом',
  `hPrice` int(11) NOT NULL DEFAULT 10000,
  `hType` int(11) NOT NULL DEFAULT 0,
  `buyprice` int(11) NOT NULL DEFAULT 0,
  `hInt` int(11) NOT NULL DEFAULT 0,
  `hVirtual` int(11) NOT NULL DEFAULT 0,
  `hLock` int(11) NOT NULL DEFAULT 0,
  `hOplata` int(20) NOT NULL DEFAULT 0,
  `hHeal` int(11) NOT NULL DEFAULT 0,
  `hGarage` int(11) NOT NULL DEFAULT 0,
  `hAutoDoors` int(1) NOT NULL DEFAULT 0,
  `hCS` int(1) NOT NULL DEFAULT 0,
  `hMoney` int(30) NOT NULL DEFAULT 0,
  `hPatrons` int(30) NOT NULL DEFAULT 0,
  `hDrugs` int(30) NOT NULL DEFAULT 0,
  `hArendName` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'none,none,none',
  `hRublevka` int(11) NOT NULL DEFAULT 0,
  `hVertX` float NOT NULL DEFAULT 0,
  `hVertY` float NOT NULL DEFAULT 0,
  `hVertZ` float NOT NULL DEFAULT 0,
  `hVertA` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `house`
--

INSERT INTO `house` (`id`, `hEntrx`, `hEntry`, `hEntrz`, `hExitx`, `hExity`, `hExitz`, `carx`, `cary`, `carz`, `carfa`, `hOwner`, `hOwned`, `hDiscript`, `hPrice`, `hType`, `buyprice`, `hInt`, `hVirtual`, `hLock`, `hOplata`, `hHeal`, `hGarage`, `hAutoDoors`, `hCS`, `hMoney`, `hPatrons`, `hDrugs`, `hArendName`, `hRublevka`, `hVertX`, `hVertY`, `hVertZ`, `hVertA`) VALUES
(1, '2685.681', '-231.407', '3.981', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 1, 1, 0, 50, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(2, '2627.594', '-232.806', '3.981', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(3, '2590.334', '-230.937', '4.048', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 3, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(4, '2524.483', '-198.86', '3.719', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(5, '2415.113', '-230.63', '2.059', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(6, '2381.845', '-202.643', '2.83', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 6, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(7, '2330.098', '-205.21', '2.423', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 7, 1, 0, 20, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(8, '2240.517', '-197.046', '2.392', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 8, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(9, '1764.074', '1334.364', '10.126', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 9, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(10, '1800.618', '1337.777', '10.224', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 10, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(11, '1813.163', '1333.637', '10.54', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 11, 1, 0, 50, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(12, '1838.231', '1338.574', '10.28', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 12, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(13, '1865.922', '1337.286', '10.321', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 13, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(14, '1859.487', '1405.134', '9.756', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 14, 1, 0, 10, 0, 0, 0, 9700, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(15, '1994.997', '1746.174', '15.692', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 15, 1, 0, 20, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(16, '1989.359', '1793.923', '15.739', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 16, 1, 0, 20, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(17, '1985.202', '1834.718', '15.512', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 17, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(18, '1943.524', '1752.987', '15.357', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 18, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(19, '1945.144', '1845.223', '15.419', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 19, 1, 0, 10, 0, 0, 0, 100000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(20, '1946.798', '1803.182', '15.505', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 20, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(21, '1750.093', '2073.735', '16.026', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 21, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(22, '1745.886', '2115.202', '15.948', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 22, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(23, '1750.06', '2164.815', '16.203', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 23, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(24, '1749.93', '2188.816', '15.867', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 24, 1, 0, 40, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(25, '1767.177', '2428.677', '15.359', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 25, 1, 0, 20, 0, 0, 0, 500, 540, 0, 'none,none,none', 0, 0, 0, 0, 0),
(26, '1787.685', '2409.314', '15.318', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 26, 1, 0, 0, 0, 0, 0, 1, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(27, '1793.593', '2400.285', '15.307', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 27, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(28, '1806.674', '2372.02', '15.359', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 28, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(29, '1825.231', '2343.887', '15.351', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 29, 1, 0, 20, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(30, '1834.153', '2330.269', '15.355', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 30, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(31, '1859.575', '2198.477', '15.937', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 31, 1, 0, 10, 0, 0, 0, 0, 10, 0, 'none,none,none', 0, 0, 0, 0, 0),
(32, '1859.309', '2164.593', '15.937', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 32, 1, 0, 50, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(33, '1859.483', '2148.271', '15.937', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 33, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(34, '1789.563', '2201.642', '15.621', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 34, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(35, '1800.166', '2201.642', '15.625', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 35, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(36, '1790.478', '2179.396', '15.992', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 36, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(37, '1790.485', '2163.08', '15.992', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 37, 1, 0, 10, 0, 0, 0, 10000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(38, '394.257', '701.245', '12.804', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 38, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(39, '473.281', '673.135', '12.152', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 39, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(40, '2023.348', '-1041.572', '2.693', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 40, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(41, '-308.87', '1222.691', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 41, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(42, '-281.177', '1222.59', '13.217', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 42, 1, 0, 30, 0, 0, 0, 1000000, 500, 0, 'none,none,none', 0, 0, 0, 0, 0),
(43, '-247.327', '1223.151', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 43, 1, 0, 20, 0, 0, 0, 310000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(44, '-223.904', '1258.306', '13.16', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 44, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(45, '-262.719', '1256.77', '12.837', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 45, 1, 0, 50, 0, 0, 0, 999999, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(46, '-295.951', '1257.613', '13.16', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 46, 1, 0, 50, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(47, '-304.055', '1289.3', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 47, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(48, '-275.427', '1288.794', '13.212', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 48, 1, 0, 6, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(49, '-239.021', '1289.39', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 49, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(50, '-228.889', '1321.623', '13.16', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 50, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(51, '-267.006', '1321.381', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 51, 1, 0, 20, 0, 0, 0, 200, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(52, '-297.273', '1322.046', '13.16', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 52, 1, 0, 30, 0, 0, 0, 983270, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(53, '-310.204', '1353.824', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 53, 1, 0, 30, 0, 0, 0, 10000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(54, '-290.23', '1389.557', '13.16', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 54, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(55, '-324.577', '1387.958', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 55, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(56, '-352.024', '1389.375', '13.16', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 56, 1, 0, 10, 0, 0, 0, 0, 250, 0, 'none,none,none', 0, 0, 0, 0, 0),
(57, '-366.799', '1354.1', '13.157', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 57, 1, 0, 40, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(58, '-341.422', '1354.015', '13.16', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 58, 1, 0, 0, 0, 0, 0, 500000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(59, '1736.096', '2825.465', '11.785', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 59, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(60, '1778.429', '2818.449', '11.993', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 60, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(61, '1821.544', '2817.573', '11.838', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 61, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(62, '1864.763', '2824.974', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 62, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(63, '1876.751', '2853.514', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 63, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(64, '1853.075', '2871.755', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 64, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(65, '1883.446', '2905.093', '11.831', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 65, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(66, '1833.561', '2912.324', '12.0', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 66, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(67, '1804.794', '2867.439', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 67, 1, 0, 10, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(68, '1834.535', '2855.178', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 68, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(69, '1806.731', '2920.908', '11.856', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 69, 1, 0, 30, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(70, '1769.723', '2900.548', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 70, 1, 0, 60, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(71, '1741.474', '2854.735', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 71, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(72, '1762.465', '2862.769', '11.695', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 72, 1, 0, 50, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(73, '2464.041', '-955.454', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 73, 1, 0, 50, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(74, '2406.552', '-910.926', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 74, 1, 0, 20, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(75, '2349.874', '-906.79', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 75, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(76, '2295.528', '-910.791', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 76, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(77, '2238.344', '-906.96', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 77, 1, 0, 10, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(78, '2252.552', '-951.667', '2.693', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 78, 1, 0, 29, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(79, '2308.34', '-955.538', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 79, 1, 0, 0, 0, 0, 0, 0, 0, 240, 'none,none,none', 0, 0, 0, 0, 0),
(80, '2362.265', '-951.613', '2.693', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 80, 1, 0, 19, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(81, '2400.067', '-948.858', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 81, 1, 0, 37, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(82, '2363.235', '-1045.466', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 82, 1, 0, 9, 0, 0, 0, 500000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(83, '2355.397', '-1000.946', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 83, 1, 0, 50, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(84, '2308.416', '-1041.496', '2.693', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 84, 1, 0, 51, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(85, '2296.975', '-996.983', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 85, 1, 0, 20, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(86, '2255.046', '-1045.496', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 86, 1, 0, 12, 0, 0, 0, 1000000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(87, '2238.549', '-1001.056', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 87, 1, 0, 5, 0, 0, 0, 1, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(88, '2189.249', '-1041.651', '2.693', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 88, 1, 0, 126, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(89, '2181.152', '-997.168', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 89, 1, 0, 130, 0, 0, 0, 250000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(90, '2063.042', '-996.803', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 90, 1, 0, 104, 0, 0, 0, 0, 1380, 10, 'none,none,none', 0, 0, 0, 0, 0),
(91, '2071.89', '-1045.388', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 91, 1, 0, 60, 0, 0, 0, 500000, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(92, '2108.939', '-1047.934', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 92, 1, 0, 70, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(93, '2125.401', '-1000.679', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 93, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(94, '2136.867', '-1045.439', '2.685', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 94, 1, 0, 30, 0, 0, 0, 0, 10, 0, 'none,none,none', 0, 0, 0, 0, 0),
(95, '2186.567', '-975.619', '2.694', '2415.694', '286.332', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '3', 9000000, 0, 0, 9, 95, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(96, '2260.994', '-230.623', '2.078', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 96, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(97, '2204.782', '-231.382', '2.074', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 97, 1, 0, 480, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(98, '2422.35', '-206.152', '2.357', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '1', 3000000, 0, 0, 8, 98, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(99, '465.157', '-1249.706', '41.889', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 99, 1, 0, 20, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0),
(100, '531.026', '-1275.706', '40.731', '1403.479', '295.311', '1401.0', '0.0', '0.0', '0.0', '0.0', 'None', -1, '2', 6000000, 0, 0, 8, 100, 1, 0, 77, 0, 0, 0, 0, 0, 0, 'none,none,none', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `inventory`
--

CREATE TABLE `inventory` (
  `Name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot0` int(11) NOT NULL DEFAULT 0,
  `Amt0` int(11) NOT NULL DEFAULT 0,
  `Value0` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot1` int(11) NOT NULL DEFAULT 0,
  `Amt1` int(11) NOT NULL DEFAULT 0,
  `Value1` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot2` int(11) NOT NULL DEFAULT 0,
  `Amt2` int(11) NOT NULL DEFAULT 0,
  `Value2` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot3` int(11) NOT NULL DEFAULT 0,
  `Amt3` int(11) NOT NULL DEFAULT 0,
  `Value3` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot4` int(11) NOT NULL DEFAULT 0,
  `Amt4` int(11) NOT NULL DEFAULT 0,
  `Value4` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot5` int(11) NOT NULL DEFAULT 0,
  `Amt5` int(11) NOT NULL DEFAULT 0,
  `Value5` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot6` int(11) NOT NULL DEFAULT 0,
  `Amt6` int(11) NOT NULL DEFAULT 0,
  `Value6` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot7` int(11) NOT NULL DEFAULT 0,
  `Amt7` int(11) NOT NULL DEFAULT 0,
  `Value7` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot8` int(11) NOT NULL DEFAULT 0,
  `Amt8` int(11) NOT NULL DEFAULT 0,
  `Value8` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot9` int(11) NOT NULL DEFAULT 0,
  `Amt9` int(11) NOT NULL DEFAULT 0,
  `Value9` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot10` int(11) NOT NULL DEFAULT 0,
  `Amt10` int(11) NOT NULL DEFAULT 0,
  `Value10` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot11` int(11) NOT NULL DEFAULT 0,
  `Amt11` int(11) NOT NULL DEFAULT 0,
  `Value11` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot12` int(11) NOT NULL DEFAULT 0,
  `Amt12` int(11) NOT NULL DEFAULT 0,
  `Value12` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot13` int(11) NOT NULL DEFAULT 0,
  `Amt13` int(11) NOT NULL DEFAULT 0,
  `Value13` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot14` int(11) NOT NULL DEFAULT 0,
  `Amt14` int(11) NOT NULL DEFAULT 0,
  `Value14` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot15` int(11) NOT NULL DEFAULT 0,
  `Amt15` int(11) NOT NULL DEFAULT 0,
  `Value15` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Slot16` int(11) NOT NULL DEFAULT 0,
  `Amt16` int(11) NOT NULL DEFAULT 0,
  `Value16` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `inventory`
--

INSERT INTO `inventory` (`Name`, `Slot0`, `Amt0`, `Value0`, `Slot1`, `Amt1`, `Value1`, `Slot2`, `Amt2`, `Value2`, `Slot3`, `Amt3`, `Value3`, `Slot4`, `Amt4`, `Value4`, `Slot5`, `Amt5`, `Value5`, `Slot6`, `Amt6`, `Value6`, `Slot7`, `Amt7`, `Value7`, `Slot8`, `Amt8`, `Value8`, `Slot9`, `Amt9`, `Value9`, `Slot10`, `Amt10`, `Value10`, `Slot11`, `Amt11`, `Value11`, `Slot12`, `Amt12`, `Value12`, `Slot13`, `Amt13`, `Value13`, `Slot14`, `Amt14`, `Value14`, `Slot15`, `Amt15`, `Value15`, `Slot16`, `Amt16`, `Value16`) VALUES
('Romulus', 0, 0, '', 44, 150, 'NULL', 0, 0, '', 107, 3, 'NULL', 0, 0, NULL, 0, 0, '', 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL),
('Larry_Torres', 0, 0, NULL, 44, 70, '', 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL),
('Ilya_Macalister', 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL),
('Scays_Fresko', 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `mafia`
--

CREATE TABLE `mafia` (
  `yakuzabank` int(11) NOT NULL DEFAULT 0,
  `lcnbank` int(11) NOT NULL DEFAULT 0,
  `rmbank` int(11) NOT NULL DEFAULT 0,
  `yakuzadrugs` int(11) NOT NULL DEFAULT 0,
  `lcndrugs` int(11) NOT NULL DEFAULT 0,
  `rmdrugs` int(11) NOT NULL DEFAULT 0,
  `lcnpat` int(11) NOT NULL DEFAULT 0,
  `yakpat` int(11) NOT NULL DEFAULT 0,
  `rmpat` int(11) NOT NULL DEFAULT 0,
  `lcned` int(11) NOT NULL DEFAULT 0,
  `yaked` int(11) NOT NULL DEFAULT 0,
  `rmed` int(11) NOT NULL DEFAULT 0,
  `bskl_l` int(11) NOT NULL DEFAULT 0,
  `bskl_y` int(11) NOT NULL DEFAULT 0,
  `bskl_r` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `mafia`
--

INSERT INTO `mafia` (`yakuzabank`, `lcnbank`, `rmbank`, `yakuzadrugs`, `lcndrugs`, `rmdrugs`, `lcnpat`, `yakpat`, `rmpat`, `lcned`, `yaked`, `rmed`, `bskl_l`, `bskl_y`, `bskl_r`) VALUES
(37032579, 26040458, 88330511, 75963, 25281, 1, 1246000, 1251416, 424155, 44528, 37066, 100, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `news`
--

CREATE TABLE `news` (
  `user_id` int(11) NOT NULL,
  `day_1` int(11) NOT NULL DEFAULT 0,
  `day_2` int(11) NOT NULL DEFAULT 0,
  `day_3` int(11) NOT NULL DEFAULT 0,
  `day_4` int(11) NOT NULL DEFAULT 0,
  `day_5` int(11) NOT NULL DEFAULT 0,
  `day_6` int(11) NOT NULL DEFAULT 0,
  `day_7` int(11) NOT NULL DEFAULT 0,
  `day_clear` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Статистика новостей';

--
-- Дамп данных таблицы `news`
--

INSERT INTO `news` (`user_id`, `day_1`, `day_2`, `day_3`, `day_4`, `day_5`, `day_6`, `day_7`, `day_clear`) VALUES
(92, 0, 0, 0, 0, 0, 0, 0, 0),
(273, 0, 0, 0, 0, 0, 0, 0, 0),
(177, 0, 0, 0, 0, 0, 0, 0, 0),
(866, 0, 0, 0, 0, 0, 0, 0, 0),
(244, 0, 0, 0, 0, 0, 0, 0, 0),
(2383, 0, 0, 0, 0, 0, 0, 0, 0),
(6619, 0, 0, 0, 0, 0, 0, 0, 0),
(2387, 0, 0, 0, 0, 0, 0, 0, 0),
(1283, 0, 0, 0, 0, 0, 0, 0, 0),
(6881, 0, 0, 0, 0, 0, 0, 0, 0),
(5616, 0, 0, 0, 0, 0, 0, 0, 0),
(29, 0, 0, 0, 0, 0, 0, 0, 0),
(656, 0, 0, 0, 0, 0, 0, 0, 0),
(2891, 0, 0, 0, 0, 0, 0, 0, 0),
(5169, 0, 0, 0, 0, 0, 0, 0, 0),
(5918, 0, 0, 0, 0, 0, 0, 0, 0),
(7102, 0, 0, 0, 0, 0, 0, 0, 0),
(577, 0, 0, 0, 0, 0, 0, 0, 0),
(2672, 0, 0, 0, 0, 0, 0, 0, 0),
(704, 0, 0, 0, 0, 0, 0, 0, 0),
(3105, 0, 0, 0, 0, 0, 0, 0, 0),
(292, 0, 0, 0, 0, 0, 0, 0, 0),
(501, 0, 0, 0, 0, 0, 0, 0, 0),
(5905, 0, 0, 0, 0, 0, 0, 0, 0),
(2820, 0, 0, 0, 0, 0, 0, 0, 0),
(3227, 0, 0, 0, 0, 0, 0, 0, 0),
(9757, 0, 0, 0, 0, 0, 0, 0, 0),
(8212, 0, 0, 0, 0, 0, 0, 0, 0),
(3399, 0, 0, 0, 0, 0, 0, 0, 0),
(2801, 0, 0, 0, 0, 0, 0, 0, 0),
(10374, 0, 0, 0, 0, 0, 0, 0, 0),
(2979, 0, 0, 0, 0, 0, 0, 0, 0),
(1915, 0, 0, 0, 0, 0, 0, 0, 0),
(640, 0, 0, 0, 0, 0, 0, 0, 0),
(3336, 0, 0, 0, 0, 0, 0, 0, 0),
(1909, 0, 0, 0, 0, 0, 0, 0, 0),
(9433, 0, 0, 0, 0, 0, 0, 0, 0),
(8350, 0, 0, 0, 0, 0, 0, 0, 0),
(7529, 0, 0, 0, 0, 0, 0, 0, 0),
(9510, 0, 0, 0, 0, 0, 0, 0, 0),
(8672, 0, 0, 0, 0, 0, 0, 0, 0),
(727, 0, 0, 0, 0, 0, 0, 0, 0),
(14392, 0, 0, 0, 0, 0, 0, 0, 0),
(14340, 0, 0, 0, 0, 0, 0, 0, 0),
(10862, 0, 0, 0, 0, 0, 0, 0, 0),
(2529, 0, 0, 0, 0, 0, 0, 0, 0),
(449, 0, 0, 0, 0, 0, 0, 0, 0),
(9935, 0, 0, 0, 0, 0, 0, 0, 0),
(3582, 0, 0, 0, 0, 0, 0, 0, 0),
(14847, 0, 0, 0, 0, 0, 0, 0, 0),
(12367, 0, 0, 0, 0, 0, 0, 0, 0),
(6466, 0, 0, 0, 0, 0, 0, 0, 0),
(756, 0, 0, 0, 0, 0, 0, 0, 0),
(2552, 0, 0, 0, 0, 0, 0, 0, 0),
(1724, 0, 0, 0, 0, 0, 0, 0, 0),
(3203, 0, 0, 0, 0, 0, 0, 0, 0),
(1455, 0, 0, 0, 0, 0, 0, 0, 0),
(14845, 0, 0, 0, 0, 0, 0, 0, 0),
(1484, 0, 0, 0, 0, 0, 0, 0, 0),
(4311, 0, 0, 0, 0, 0, 0, 0, 0),
(6964, 0, 0, 0, 0, 0, 0, 0, 0),
(4670, 0, 0, 0, 0, 0, 0, 0, 0),
(546, 0, 0, 0, 0, 0, 0, 0, 0),
(699, 0, 0, 0, 0, 0, 0, 0, 0),
(17106, 0, 0, 0, 0, 0, 0, 0, 0),
(19216, 0, 0, 0, 0, 0, 0, 0, 0),
(864, 0, 0, 0, 0, 0, 0, 0, 0),
(1946, 0, 0, 0, 0, 0, 0, 0, 0),
(19318, 0, 0, 0, 0, 0, 0, 0, 0),
(19278, 0, 0, 0, 0, 0, 0, 0, 0),
(6525, 0, 0, 0, 0, 0, 0, 0, 0),
(10927, 0, 0, 0, 0, 0, 0, 0, 0),
(15900, 0, 0, 0, 0, 0, 0, 0, 0),
(15060, 0, 0, 0, 0, 0, 0, 0, 0),
(530, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `nlogs`
--

CREATE TABLE `nlogs` (
  `id` int(11) NOT NULL,
  `text` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `date` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `nlogs`
--

INSERT INTO `nlogs` (`id`, `text`, `date`) VALUES
(1, '[admin] Romulus авторизовался [83.220.90.204]', '2.8.2021 - 21:38:6'),
(2, '[rankname] Romulus rankname 1 set Стажер [ФСБ]', '2.8.2021 - 21:38:21'),
(3, '[admin] Romulus /logs', '2.8.2021 - 21:38:31'),
(4, '[admin] Romulus /logs', '2.8.2021 - 21:38:35'),
(5, '[admin] Romulus /fmsg', '2.8.2021 - 21:39:37'),
(6, '[admin] Romulus /fmsg', '2.8.2021 - 21:39:40'),
(7, '[admin] Romulus вышел из игры [83.220.90.204]', '2.8.2021 - 21:39:47'),
(8, '[euro] Romulus +190 | SERVER -190 | payday', '6.8.2021 - 23:0:1'),
(9, '[admin] Romulus авторизовался [83.220.75.196]', '6.8.2021 - 23:21:50'),
(10, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:21:56'),
(11, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:21:56'),
(12, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:21:59'),
(13, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:21:59'),
(14, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:0'),
(15, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:0'),
(16, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:1'),
(17, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:1'),
(18, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:4'),
(19, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:4'),
(20, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:6'),
(21, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:6'),
(22, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:18'),
(23, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:18'),
(24, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:19'),
(25, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:19'),
(26, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:20'),
(27, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:20'),
(28, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:21'),
(29, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:21'),
(30, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:23'),
(31, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:23'),
(32, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:24'),
(33, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:24'),
(34, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:25'),
(35, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:25'),
(36, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:26'),
(37, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:26'),
(38, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:27'),
(39, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:27'),
(40, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:28'),
(41, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:28'),
(42, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:29'),
(43, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:29'),
(44, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:30'),
(45, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:30'),
(46, '[admin] Romulus /givecredits Romulus 50', '6.8.2021 - 23:22:31'),
(47, '[coin] Romulus +50 /givecredits Romulus', '6.8.2021 - 23:22:31'),
(48, '[admin] Romulus вышел из игры [83.220.75.196]', '6.8.2021 - 23:22:57'),
(49, '[cars] Romulus +495 донат', '6.8.2021 - 23:24:51'),
(50, '[coin] Romulus -600 тачка Mercedes G65 6x6', '6.8.2021 - 23:24:51'),
(51, '[coin] Romulus -600 тачка Maybach X222', '6.8.2021 - 23:25:2'),
(52, '[cars] Romulus +551 донат', '6.8.2021 - 23:25:2'),
(53, '[coin] Romulus -900 тачка Bugatti Chiron', '6.8.2021 - 23:25:14'),
(54, '[cars] Romulus +494 донат', '6.8.2021 - 23:25:14'),
(55, '[cars] Romulus +542 донат', '6.8.2021 - 23:25:25'),
(56, '[coin] Romulus -2000 тачка Tesla CyberTruck', '6.8.2021 - 23:25:25'),
(57, '[coin] Romulus -75 доп.слоты для тачки', '6.8.2021 - 23:25:30'),
(58, '[coin] Romulus -600 тачка Mercedes G65 6x6', '6.8.2021 - 23:27:0'),
(59, '[cars] Romulus +495 донат', '6.8.2021 - 23:27:0'),
(60, '[cars] Romulus +495 донат', '6.8.2021 - 23:27:15'),
(61, '[coin] Romulus -600 тачка Mercedes G65 6x6', '6.8.2021 - 23:27:15'),
(62, '[cars] Romulus +495 донат', '6.8.2021 - 23:27:22'),
(63, '[coin] Romulus -600 тачка Mercedes G65 6x6', '6.8.2021 - 23:27:22'),
(64, '[coin] Romulus -600 тачка Mercedes G65 6x6', '6.8.2021 - 23:27:31'),
(65, '[cars] Romulus +495 донат', '6.8.2021 - 23:27:31'),
(66, '[cars] Romulus +494 донат', '6.8.2021 - 23:27:41'),
(67, '[coin] Romulus -900 тачка Bugatti Chiron', '6.8.2021 - 23:27:41'),
(68, '[cars] Romulus +494 донат', '6.8.2021 - 23:27:48'),
(69, '[coin] Romulus -900 тачка Bugatti Chiron', '6.8.2021 - 23:27:48'),
(70, '[cars] Romulus +494 донат', '6.8.2021 - 23:27:55'),
(71, '[coin] Romulus -900 тачка Bugatti Chiron', '6.8.2021 - 23:27:55'),
(72, '[cars] Romulus +494 донат', '6.8.2021 - 23:28:5'),
(73, '[coin] Romulus -900 тачка Bugatti Chiron', '6.8.2021 - 23:28:5'),
(74, '[coin] Romulus -900 тачка Bugatti Chiron', '6.8.2021 - 23:28:12'),
(75, '[cars] Romulus +494 донат', '6.8.2021 - 23:28:12'),
(76, '[coin] Romulus -900 тачка Bugatti Chiron', '6.8.2021 - 23:28:21'),
(77, '[cars] Romulus +494 донат', '6.8.2021 - 23:28:21'),
(78, '[cars] Romulus 494 Bugatti Chiron загружен', '6.8.2021 - 23:41:7'),
(79, '[admin] Romulus авторизовался [83.220.75.196]', '6.8.2021 - 23:41:25'),
(80, '[admin] Romulus вышел из игры [83.220.75.196]', '6.8.2021 - 23:42:32'),
(81, '[euro] Romulus +190 | SERVER -190 | payday', '7.8.2021 - 0:0:3'),
(82, '[admin] Romulus авторизовался [83.220.75.196]', '7.8.2021 - 0:19:37'),
(83, '[admin] Romulus /tp 1. Основные Места', '7.8.2021 - 0:19:43'),
(84, '[admin] Romulus /tp 4. Нелегальные Организации', '7.8.2021 - 0:19:57'),
(85, '[admin] Romulus /tp 5. Банки', '7.8.2021 - 0:19:59'),
(86, '[admin] Romulus /tp 6. Развлечения', '7.8.2021 - 0:20:1'),
(87, '[admin] Romulus /tp 1. Основные Места', '7.8.2021 - 0:20:11'),
(88, '[admin] Romulus /veh 522 1 1', '7.8.2021 - 0:20:26'),
(89, '[admin] Romulus /setleader Romulus 0', '7.8.2021 - 0:21:59'),
(90, '[skin] Romulus магазин [0]', '7.8.2021 - 0:22:9'),
(91, '[admin] Romulus вышел из игры [83.220.75.196]', '7.8.2021 - 0:24:57'),
(92, '[admin] Romulus авторизовался [83.220.75.196]', '7.8.2021 - 0:28:30'),
(93, '[admin] Romulus /veh 522 1 1', '7.8.2021 - 0:28:32'),
(94, '[house] Romulus +81 покупка', '7.8.2021 - 0:29:38'),
(95, '[admin] Romulus авторизовался [83.220.75.196]', '7.8.2021 - 1:7:6'),
(96, '[admin] Romulus /setleader Romulus 3(ФСБ)', '7.8.2021 - 1:7:11'),
(97, '[admin] Romulus /spawn Romulus', '7.8.2021 - 1:7:16'),
(98, '[admin] Romulus /veh 522 1 1', '7.8.2021 - 1:7:29'),
(99, '[admin] Romulus /spawn Romulus', '7.8.2021 - 1:8:54'),
(100, '[admin] Romulus авторизовался [83.220.75.196]', '7.8.2021 - 1:13:34'),
(101, '[admin] Romulus /setleader Romulus 0', '7.8.2021 - 1:13:36'),
(102, '[coin] Romulus -600 тачка Maybach X222', '7.8.2021 - 1:14:59'),
(103, '[cars] Romulus +551 донат', '7.8.2021 - 1:14:59'),
(104, '[cars] Romulus 551 Maybach X222 загружен', '7.8.2021 - 1:18:6'),
(105, '[cars] Romulus 551 Maybach X222 загружен', '7.8.2021 - 1:21:58'),
(106, '[admin] Larry_Torres авторизовался [8.40.140.120]', '7.8.2021 - 1:32:28'),
(107, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:33:55'),
(108, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:33:55'),
(109, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:33:56'),
(110, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:33:56'),
(111, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:33:57'),
(112, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:33:57'),
(113, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:45'),
(114, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:45'),
(115, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:46'),
(116, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:46'),
(117, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:47'),
(118, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:47'),
(119, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:48'),
(120, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:48'),
(121, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:49'),
(122, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:49'),
(123, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:50'),
(124, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:50'),
(125, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:51'),
(126, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:51'),
(127, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:34:52'),
(128, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:34:52'),
(129, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:37:59'),
(130, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:37:59'),
(131, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:38:0'),
(132, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:38:0'),
(133, '[admin] Larry_Torres /givecredits Larry_Torres 50', '7.8.2021 - 1:38:1'),
(134, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '7.8.2021 - 1:38:1'),
(135, '[admin] Larry_Torres вышел из игры [8.40.140.120]', '7.8.2021 - 1:41:9'),
(136, '[admin] Larry_Torres авторизовался [8.40.140.120]', '7.8.2021 - 12:2:32'),
(137, '[admin] Larry_Torres вышел из игры [8.40.140.120]', '7.8.2021 - 12:10:25'),
(138, '[admin] Larry_Torres авторизовался [89.232.84.128]', '7.8.2021 - 12:28:19'),
(139, '[admin] Larry_Torres вышел из игры [89.232.84.128]', '7.8.2021 - 12:51:18'),
(140, '[skin] Ilya_Macalister регистрация [0]', '7.8.2021 - 22:40:31'),
(141, '[admin] Ilya_Macalister авторизовался [8.20.127.53]', '7.8.2021 - 22:42:1'),
(142, '[Промокод] Ilya_Macalister активировал промокод TEST123', '7.8.2021 - 22:42:23'),
(143, '[Промокод] Ilya_Macalister получил бонус за промокод TEST123', '7.8.2021 - 22:42:23'),
(144, '[euro] Ilya_Macalister +0 | SERVER -0 | промокод', '7.8.2021 - 22:42:23'),
(145, '[admin] Ilya_Macalister вышел из игры [8.20.127.53]', '7.8.2021 - 22:53:9'),
(146, '[admin] Larry_Torres авторизовался [178.204.211.180]', '8.8.2021 - 1:8:2'),
(147, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:10'),
(148, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:10'),
(149, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:12'),
(150, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:12'),
(151, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:16'),
(152, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:16'),
(153, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:18'),
(154, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:18'),
(155, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:20'),
(156, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:20'),
(157, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:21'),
(158, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:21'),
(159, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:23'),
(160, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:23'),
(161, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:25'),
(162, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:25'),
(163, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:26'),
(164, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:26'),
(165, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:27'),
(166, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:27'),
(167, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:28'),
(168, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:28'),
(169, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:30'),
(170, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:30'),
(171, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:31'),
(172, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:31'),
(173, '[coin] Larry_Torres +50 /givecredits Larry_Torres', '8.8.2021 - 1:8:32'),
(174, '[admin] Larry_Torres /givecredits Larry_Torres 50', '8.8.2021 - 1:8:32'),
(175, '[admin] Ilya_Macalister авторизовался [8.20.127.53]', '8.8.2021 - 1:11:31'),
(176, '[admin] Ilya_Macalister вышел из игры [8.20.127.53]', '8.8.2021 - 1:18:54'),
(177, '[admin] Larry_Torres вышел из игры [178.204.211.180]', '8.8.2021 - 1:22:49'),
(178, '[skin] Scays_Fresko регистрация [0]', '14.12.2023 - 10:53:15'),
(179, '[admin] Scays_Fresko авторизовался [195.19.122.237]', '14.12.2023 - 12:51:40'),
(180, '[admin] Scays_Fresko /ahelp', '14.12.2023 - 12:51:43'),
(181, '[admin] Scays_Fresko /setleader Scays_Fresko 5(ФК ЦСКА)', '14.12.2023 - 12:52:3'),
(182, '[admin] Scays_Fresko /gzcolor 6 53', '14.12.2023 - 12:53:45');

-- --------------------------------------------------------

--
-- Структура таблицы `objects`
--

CREATE TABLE `objects` (
  `id` int(11) NOT NULL,
  `name` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `date` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `slot` int(11) NOT NULL,
  `model` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `rotx` float NOT NULL,
  `roty` float NOT NULL,
  `rotz` float NOT NULL,
  `world` int(11) NOT NULL,
  `inter` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `objects`
--

INSERT INTO `objects` (`id`, `name`, `date`, `slot`, `model`, `posx`, `posy`, `posz`, `rotx`, `roty`, `rotz`, `world`, `inter`) VALUES
(5, 'Vago_Soprano', '7/11/2020 23:0', 0, 987, 64.598, 1877.39, 9.406, 0, 0, 0, 54, 0),
(6, 'Vago_Soprano', '7/11/2020 23:1', 0, 987, -199.873, 1709.97, 12, 0, 0, 0, 54, 0),
(7, 'Vago_Soprano', '8/11/2020 21:9', 1, 9867, 381.442, 2016.59, -5.481, 0, 0, 0, 7, 0),
(8, 'Vago_Soprano', '8/11/2020 21:9', 1, 987, 380.815, 2017.14, -5.471, 0, 0, 0, 7, 0),
(9, 'Nikol_Soprano', '8/11/2020 21:10', 1, 980, 380.511, 2020.3, -5.41, 0, 0, 0, 7, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `other`
--

CREATE TABLE `other` (
  `lsnbank` int(11) NOT NULL DEFAULT 0,
  `sfnbank` int(20) NOT NULL DEFAULT 0,
  `lvnbank` int(11) NOT NULL DEFAULT 0,
  `newsprice` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '15, 15, 2, 2, 8, 8',
  `jobprice` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `merpanel` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `mdpanel` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '1, 1, 1, 1, 1, 1',
  `mineral` int(11) NOT NULL DEFAULT 0,
  `guncoal` int(11) NOT NULL DEFAULT 0,
  `gunwood` int(11) NOT NULL DEFAULT 0,
  `gun` int(11) NOT NULL DEFAULT 0,
  `drova` int(11) NOT NULL DEFAULT 0,
  `armygun` int(11) NOT NULL DEFAULT 0,
  `armyammo` int(11) NOT NULL DEFAULT 0,
  `d_exp` int(1) NOT NULL DEFAULT 0,
  `d_donate` int(1) NOT NULL DEFAULT 1,
  `d_jobik` int(1) NOT NULL DEFAULT 0,
  `lp0` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `lp1` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `lp2` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `lp3` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `lp4` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `lp5` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `materials` int(11) NOT NULL,
  `happy_hours` int(11) NOT NULL,
  `lottery_bank` int(11) NOT NULL DEFAULT 0,
  `event_season_prize` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '5, 4, 3, 5, 4, 3, 5, 4, 3, 5, 4, 3',
  `event_pubg_prize` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '10, 7, 5',
  `event_derby_prize` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '10, 7, 5',
  `event_skydiving_prize` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '10, 7, 5',
  `donate_bonus` int(11) NOT NULL DEFAULT 0,
  `give_car` int(11) NOT NULL DEFAULT 500,
  `roulette_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `other`
--

INSERT INTO `other` (`lsnbank`, `sfnbank`, `lvnbank`, `newsprice`, `jobprice`, `merpanel`, `mdpanel`, `mineral`, `guncoal`, `gunwood`, `gun`, `drova`, `armygun`, `armyammo`, `d_exp`, `d_donate`, `d_jobik`, `lp0`, `lp1`, `lp2`, `lp3`, `lp4`, `lp5`, `materials`, `happy_hours`, `lottery_bank`, `event_season_prize`, `event_pubg_prize`, `event_derby_prize`, `event_skydiving_prize`, `donate_bonus`, `give_car`, `roulette_count`) VALUES
(14952750, 817997260, 0, '20, 20, 3, 3, 50, 50', '4, 0, 3, 0, 500, 0', '300, 200, 50000, 1000, 3, 150', '300, 0, 0, 0, 0, 7960614', 0, 3206549, 2806264, 522, 0, 768204425, 687779050, 0, 0, 0, '0, 5, 0, 1, 0, 0', '0, 1, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0', '0, 0, 0, 1, 0, 0', '0, 0, 0, 1, 0, 0', '1, 0, 0, 0, 0, 0', 1008966004, 0, 1890, '5, 4, 3, 5, 4, 3, 5, 4, 3, 5, 4, 3', '10, 7, 5', '10, 7, 5', '10, 7, 5', 1, 0, 7);

-- --------------------------------------------------------

--
-- Структура таблицы `ownable_cars`
--

CREATE TABLE `ownable_cars` (
  `id` int(11) NOT NULL,
  `c_model` int(11) NOT NULL DEFAULT 0,
  `c_x` float NOT NULL DEFAULT 0,
  `c_y` float NOT NULL DEFAULT 0,
  `c_z` float NOT NULL DEFAULT 0,
  `c_a` float NOT NULL DEFAULT 0,
  `c_class` int(11) NOT NULL DEFAULT 1,
  `c_owner` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'none',
  `c_fuel` int(11) NOT NULL DEFAULT 45,
  `c_color1` int(11) NOT NULL DEFAULT 1,
  `c_color2` int(11) NOT NULL DEFAULT 1,
  `c_lock` int(11) NOT NULL DEFAULT 1,
  `c_price` int(11) NOT NULL DEFAULT 0,
  `c_vehcom` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0,0',
  `c_number` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `c_paintjob` int(11) NOT NULL DEFAULT 3,
  `c_status` int(11) NOT NULL DEFAULT 0,
  `c_world` int(11) NOT NULL DEFAULT 0,
  `c_trunk` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0,0,0,0,0,0,0',
  `c_update` int(11) NOT NULL DEFAULT 0,
  `c_mileage` float NOT NULL DEFAULT 0,
  `c_health` float NOT NULL DEFAULT 1000,
  `c_arrest` int(11) DEFAULT 0,
  `c_arrestinfo` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'None'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `ownable_cars`
--

INSERT INTO `ownable_cars` (`id`, `c_model`, `c_x`, `c_y`, `c_z`, `c_a`, `c_class`, `c_owner`, `c_fuel`, `c_color1`, `c_color2`, `c_lock`, `c_price`, `c_vehcom`, `c_number`, `c_paintjob`, `c_status`, `c_world`, `c_trunk`, `c_update`, `c_mileage`, `c_health`, `c_arrest`, `c_arrestinfo`) VALUES
(1, 409, 0, 0, 0, 0, 1, 'Romulus', 45, -1, -1, 1, 9000000, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'None', 3, 0, 0, '0,0,0,0,0,0,0', 0, 0, 1000, 0, 'None'),
(2, 415, 0, 0, 0, 0, 1, 'Larry_Torres', 45, -1, -1, 1, 9000000, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'None', 3, 0, 0, '0,0,0,0,0,0,0', 0, 0, 1000, 0, 'None'),
(3, 495, 0, 0, 0, 0, 1, 'Romulus', 45, -1, -1, 1, 9000000, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'None', 3, 0, 0, '0,0,0,0,0,0,0', 0, 0, 1000, 0, 'None'),
(4, 495, 0, 0, 0, 0, 1, 'Ilya_Macalister', 45, -1, -1, 1, 9000000, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'None', 3, 0, 0, '0,0,0,0,0,0,0', 0, 0, 1000, 0, 'None'),
(5, 495, 0, 0, 0, 0, 1, 'Ilya_Macalister', 45, -1, -1, 1, 9000000, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'None', 3, 0, 0, '0,0,0,0,0,0,0', 0, 0, 1000, 0, 'None'),
(6, 481, 0, 0, 0, 0, 1, 'Larry_Torres', 45, -1, -1, 1, 9000000, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'None', 3, 0, 0, '0,0,0,0,0,0,0', 0, 0, 1000, 0, 'None'),
(7, 402, 0, 0, 0, 0, 1, 'Ilya_Macalister', 45, -1, -1, 1, 9000000, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'None', 3, 0, 0, '0,0,0,0,0,0,0', 0, 0, 1000, 0, 'None');

-- --------------------------------------------------------

--
-- Структура таблицы `ownable_numbers`
--

CREATE TABLE `ownable_numbers` (
  `id` int(11) UNSIGNED NOT NULL,
  `number` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `is_used` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `pawnac_settings`
--

CREATE TABLE `pawnac_settings` (
  `ac_name` varchar(40) NOT NULL,
  `ac_status` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `pawnac_settings`
--

INSERT INTO `pawnac_settings` (`ac_name`, `ac_status`) VALUES
('crash state', 0),
('crash pass #1', 0),
('crash bullet #1', 0),
('crash pass #2', 0),
('crash pass #3', 0),
('crash inv surf', 0),
('crash ered', 0),
('crash bullet #2', 0),
('[block] crash skin', 0),
('[block] QUANTUM CRASHER', 0),
('[block] unosync new crasher 14/11', 0),
('crash driver #1', 0),
('crash tune', 0),
('crash farb', 0),
('nop rpveh', 0),
('fakekill', 0),
('inv kill', 0),
('spawn car #1', 0),
('max conn', 0),
('spoof conn', 0),
('inv rcon', 0),
('derpcam', 0),
('inv anim', 0),
('[block] spawn car #2', 0),
('[block] New Surf Invisible', 0),
('[block] unosync validity checks', 0),
('TRAILER TELEPORT #1', 0),
('VEHPACKET HACK #1', 0),
('gun cheat', 0),
('ammo cheat', 0),
('nop armour', 0),
('nop health', 0),
('nop hpcar', 0),
('jetpack', 0),
('spawn', 0),
('Unosync #MAX', 0),
('Bypass Connect', 0),
('Bypass Authorization', 0),
('RECONNECT', 0),
('#001', 0),
('#002', 0),
('#003', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `pickup_data`
--

CREATE TABLE `pickup_data` (
  `id` int(11) NOT NULL,
  `e_x` float NOT NULL,
  `e_y` float NOT NULL,
  `e_z` float NOT NULL,
  `e_r` float NOT NULL,
  `v_x` float NOT NULL,
  `v_y` float NOT NULL,
  `v_z` float NOT NULL,
  `v_r` float NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `e_int` int(11) NOT NULL,
  `e_world` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `dostup` int(11) NOT NULL,
  `fraction` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `pickup_data`
--

INSERT INTO `pickup_data` (`id`, `e_x`, `e_y`, `e_z`, `e_r`, `v_x`, `v_y`, `v_z`, `v_r`, `name`, `e_int`, `e_world`, `type`, `dostup`, `fraction`) VALUES
(10, 2198.16, -2279.68, 22.996, 260, -110.503, 252.777, 1201.08, 87, 'Риелторское агентство', 25, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `player_promocode`
--

CREATE TABLE `player_promocode` (
  `id` int(11) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `name` varchar(34) DEFAULT NULL,
  `remain_hours` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `player_promocode`
--

INSERT INTO `player_promocode` (`id`, `userid`, `name`, `remain_hours`, `status`) VALUES
(1, 530, 'Test', 0, 1),
(2, 530, 'PERFECTRP', 0, 1),
(3, 530, 'Shadow', 0, 1),
(4, 530, 'Test2', 0, 1),
(5, 530, 'Test3', 0, 1),
(6, 530, 'Test228', 0, 1),
(7, 530, 'Test1337', 0, 1),
(8, 228, 'Test228', 0, 1),
(9, 530, 'Test24', 0, 1),
(10, 530, 'Test241', 0, 1),
(11, 530, '', 0, 1),
(12, 530, 'Test2412', 0, 1),
(13, 530, 'testveh', 0, 1),
(14, 530, 'Testt', 0, 1),
(15, 539, 'TEST123', 0, 1),
(16, 3, 'TEST123', 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `podezd`
--

CREATE TABLE `podezd` (
  `idpodezd` int(11) NOT NULL,
  `poX` float NOT NULL DEFAULT 0,
  `poY` float NOT NULL DEFAULT 0,
  `poZ` float NOT NULL DEFAULT 0,
  `poExitX` float NOT NULL DEFAULT 0,
  `poExitY` float NOT NULL DEFAULT 0,
  `poExitZ` float NOT NULL DEFAULT 0,
  `poI` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `poV` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `poType` int(11) NOT NULL DEFAULT 0,
  `poSphereEnter` int(11) NOT NULL DEFAULT 0,
  `poSphereExit` int(11) NOT NULL DEFAULT 0,
  `poPickup` int(11) NOT NULL DEFAULT 0,
  `poPickupExit` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `podezd`
--

INSERT INTO `podezd` (`idpodezd`, `poX`, `poY`, `poZ`, `poExitX`, `poExitY`, `poExitZ`, `poI`, `poV`, `poType`, `poSphereEnter`, `poSphereExit`, `poPickup`, `poPickupExit`) VALUES
(1, 2640.34, -2214.17, 22.553, 2107.43, 299.91, 1399.53, '10', '1', 1, 0, 0, 0, 0),
(2, 2640.33, -2230.18, 22.545, 2107.43, 299.91, 1399.53, '10', '2', 1, 0, 0, 0, 0),
(3, 2640.49, -2246.1, 22.545, 2107.43, 299.91, 1399.53, '10', '3', 1, 0, 0, 0, 0),
(4, 2640.34, -2262.13, 22.545, 2107.43, 299.91, 1399.53, '10', '4', 1, 0, 0, 0, 0),
(5, 2640.4, -2289.21, 22.553, 2107.43, 299.91, 1399.53, '10', '5', 1, 0, 0, 0, 0),
(6, 2640.39, -2305.2, 22.545, 2107.43, 299.91, 1399.53, '10', '6', 1, 0, 0, 0, 0),
(7, 2640.57, -2321.2, 22.545, 2107.43, 299.91, 1399.53, '10', '7', 1, 0, 0, 0, 0),
(8, 2640.4, -2337.12, 22.545, 2107.43, 299.91, 1399.53, '10', '8', 1, 0, 0, 0, 0),
(9, 2640.4, -2364.06, 22.553, 2107.43, 299.91, 1399.53, '10', '9', 1, 0, 0, 0, 0),
(10, 2640.39, -2379.97, 22.545, 2107.43, 299.91, 1399.53, '10', '10', 1, 0, 0, 0, 0),
(11, 2640.4, -2395.94, 22.545, 2107.43, 299.91, 1399.53, '10', '11', 1, 0, 0, 0, 0),
(12, 2640.4, -2411.95, 22.545, 2107.43, 299.91, 1399.53, '10', '12', 1, 0, 0, 0, 0),
(13, 2424.25, -2389.78, 21.964, 2107.43, 299.91, 1399.53, '10', '13', 1, 0, 0, 0, 0),
(14, 2306.56, -2390.09, 21.987, 2107.43, 299.91, 1399.53, '10', '14', 1, 0, 0, 0, 0),
(15, 2306.56, -2230.25, 21.987, 2107.43, 299.91, 1399.53, '10', '15', 1, 0, 0, 0, 0),
(16, 2369.71, -2196.06, 21.964, 2107.43, 299.91, 1399.53, '10', '16', 1, 0, 0, 0, 0),
(17, 2424.25, -2219.66, 21.964, 2107.43, 299.91, 1399.53, '10', '17', 1, 0, 0, 0, 0),
(18, 2065.87, -2328.34, 23.14, 2107.43, 299.91, 1399.53, '10', '18', 1, 0, 0, 0, 0),
(19, 2065.91, -2292.92, 23.14, 2107.43, 299.91, 1399.53, '10', '19', 1, 0, 0, 0, 0),
(20, 2234.27, -2392.24, 22.056, 2107.43, 299.91, 1399.53, '10', '20', 1, 0, 0, 0, 0),
(21, 2178.65, -2392.24, 22.056, 2107.43, 299.91, 1399.53, '10', '21', 1, 0, 0, 0, 0),
(22, 2401.25, -2027.61, 22.101, 2107.43, 299.91, 1399.53, '10', '22', 1, 0, 0, 0, 0),
(23, 2401.42, -2046.17, 22.101, 2107.43, 299.91, 1399.53, '10', '23', 1, 0, 0, 0, 0),
(24, 2401.41, -2064.7, 22.101, 2107.43, 299.91, 1399.53, '10', '24', 1, 0, 0, 0, 0),
(25, 2401.25, -2083.21, 22.101, 2107.43, 299.91, 1399.53, '10', '25', 1, 0, 0, 0, 0),
(26, 2401.21, -2115.64, 22.12, 2107.43, 299.91, 1399.53, '10', '26', 1, 0, 0, 0, 0),
(27, 2407.71, -2131.74, 22.12, 2107.43, 299.91, 1399.53, '10', '27', 1, 0, 0, 0, 0),
(28, 2443.05, -2115.69, 22.12, 2107.43, 299.91, 1399.53, '10', '28', 1, 0, 0, 0, 0),
(29, 2436.36, -2131.86, 22.12, 2107.43, 299.91, 1399.53, '10', '29', 1, 0, 0, 0, 0),
(30, 2335.97, -2027.4, 22.101, 2107.43, 299.91, 1399.53, '10', '30', 1, 0, 0, 0, 0),
(31, 2335.97, -2046.13, 22.101, 2107.43, 299.91, 1399.53, '10', '31', 1, 0, 0, 0, 0),
(32, 2336, -2064.65, 22.101, 2107.43, 299.91, 1399.53, '10', '32', 1, 0, 0, 0, 0),
(33, 2335.97, -2083.29, 22.101, 2107.43, 299.91, 1399.53, '10', '33', 1, 0, 0, 0, 0),
(34, 321.288, 801.35, 12.622, 2107.43, 299.91, 1399.53, '10', '34', 1, 0, 0, 0, 0),
(35, 307.106, 806.851, 12.622, 2107.43, 299.91, 1399.53, '10', '35', 1, 0, 0, 0, 0),
(36, 293.111, 812.28, 12.622, 2107.43, 299.91, 1399.53, '10', '36', 1, 0, 0, 0, 0),
(37, 278.837, 817.816, 12.622, 2107.43, 299.91, 1399.53, '10', '37', 1, 0, 0, 0, 0),
(38, 264.873, 823.233, 12.622, 2107.43, 299.91, 1399.53, '10', '38', 1, 0, 0, 0, 0),
(39, 277.42, 856.407, 12.167, 2107.43, 299.91, 1399.53, '10', '39', 1, 0, 0, 0, 0),
(40, 282.635, 869.993, 12.167, 2107.43, 299.91, 1399.53, '10', '40', 1, 0, 0, 0, 0),
(41, 297.974, 918.904, 12.242, 2107.43, 299.91, 1399.53, '10', '41', 1, 0, 0, 0, 0),
(42, 300.345, 935.768, 12.242, 2107.43, 299.91, 1399.53, '10', '42', 1, 0, 0, 0, 0),
(43, 306.275, 977.716, 12.589, 2107.43, 299.91, 1399.53, '10', '43', 1, 0, 0, 0, 0),
(44, 308.111, 994.603, 12.583, 2107.43, 299.91, 1399.53, '10', '44', 1, 0, 0, 0, 0),
(45, 309.954, 1011.58, 12.583, 2107.43, 299.91, 1399.53, '10', '45', 1, 0, 0, 0, 0),
(46, 398.112, 917.961, 12.089, 2107.43, 299.91, 1399.53, '10', '46', 1, 0, 0, 0, 0),
(47, 404.833, 933.379, 12.083, 2107.43, 299.91, 1399.53, '10', '47', 1, 0, 0, 0, 0),
(48, 411.345, 949.139, 12.083, 2107.43, 299.91, 1399.53, '10', '48', 1, 0, 0, 0, 0),
(49, 329.08, 731.676, 12.628, 2107.43, 299.91, 1399.53, '10', '49', 1, 0, 0, 0, 0),
(50, 314.771, 737.083, 12.628, 2107.43, 299.91, 1399.53, '10', '50', 1, 0, 0, 0, 0),
(51, 300.695, 742.562, 12.628, 2107.43, 299.91, 1399.53, '10', '51', 1, 0, 0, 0, 0),
(52, 2416.68, -1914.11, 22.004, 2107.43, 299.91, 1399.53, '10', '52', 1, 0, 0, 0, 0),
(53, 286.562, 747.742, 12.622, 2107.43, 299.91, 1399.53, '10', '53', 1, 0, 0, 0, 0),
(54, 2422.73, -1899.25, 22.004, 2107.43, 299.91, 1399.53, '10', '54', 1, 0, 0, 0, 0),
(55, 272.463, 753.07, 12.628, 2107.43, 299.91, 1399.53, '10', '55', 1, 0, 0, 0, 0),
(56, 2410.66, -1899.33, 22.004, 2107.43, 299.91, 1399.53, '10', '56', 1, 0, 0, 0, 0),
(57, 2416.68, -1926.13, 22.004, 2107.43, 299.91, 1399.53, '10', '57', 1, 0, 0, 0, 0),
(58, 2416.78, -1938.19, 22.004, 2107.43, 299.91, 1399.53, '10', '58', 1, 0, 0, 0, 0),
(59, 2427, -1945.47, 22.004, 2107.43, 299.91, 1399.53, '10', '59', 1, 0, 0, 0, 0),
(60, 2415.18, -1984.82, 22.004, 2107.43, 299.91, 1399.53, '10', '60', 1, 0, 0, 0, 0),
(61, 2415.19, -1966.8, 22.004, 2107.43, 299.91, 1399.53, '10', '61', 1, 0, 0, 0, 0),
(62, 243.118, 756.656, 12.628, 2107.43, 299.91, 1399.53, '10', '62', 1, 0, 0, 0, 0),
(63, 237.633, 742.511, 12.622, 2107.43, 299.91, 1399.53, '10', '63', 1, 0, 0, 0, 0),
(64, 232.218, 728.552, 12.628, 2107.43, 299.91, 1399.53, '10', '64', 1, 0, 0, 0, 0),
(65, 1740.3, -2324.63, 11.405, 2107.43, 299.91, 1399.53, '10', '65', 1, 0, 0, 0, 0),
(66, 226.769, 714.504, 12.628, 2107.43, 299.91, 1399.53, '10', '66', 1, 0, 0, 0, 0),
(67, 221.17, 700.068, 12.628, 2107.43, 299.91, 1399.53, '10', '67', 1, 0, 0, 0, 0),
(68, 1740.3, -2348.43, 11.405, 2107.43, 299.91, 1399.53, '10', '68', 1, 0, 0, 0, 0),
(69, 210.679, 674.198, 12.628, 2107.43, 299.91, 1399.53, '10', '69', 1, 0, 0, 0, 0),
(70, 205.24, 660.178, 12.628, 2107.43, 299.91, 1399.53, '10', '70', 1, 0, 0, 0, 0),
(71, 1740.13, -2372.24, 11.405, 2107.43, 299.91, 1399.53, '10', '71', 1, 0, 0, 0, 0),
(72, 1779.93, -2416.29, 11.405, 2107.43, 299.91, 1399.53, '10', '72', 1, 0, 0, 0, 0),
(73, 199.799, 646.148, 12.628, 2107.43, 299.91, 1399.53, '10', '73', 1, 0, 0, 0, 0),
(74, 1780.13, -2440.24, 11.405, 2107.43, 299.91, 1399.53, '10', '74', 1, 0, 0, 0, 0),
(75, 194.31, 631.999, 12.628, 2107.43, 299.91, 1399.53, '10', '75', 1, 0, 0, 0, 0),
(76, 1780.07, -2464.33, 11.405, 2107.43, 299.91, 1399.53, '10', '76', 1, 0, 0, 0, 0),
(77, 187.552, 602.824, 12.628, 2107.43, 299.91, 1399.53, '10', '77', 1, 0, 0, 0, 0),
(78, 182.138, 588.862, 12.628, 2107.43, 299.91, 1399.53, '10', '78', 1, 0, 0, 0, 0),
(79, 1819.69, -2508.12, 11.405, 2107.43, 299.91, 1399.53, '10', '79', 1, 0, 0, 0, 0),
(80, 176.67, 574.764, 12.628, 2107.43, 299.91, 1399.53, '10', '80', 1, 0, 0, 0, 0),
(81, 1819.62, -2532, 11.405, 2107.43, 299.91, 1399.53, '10', '81', 1, 0, 0, 0, 0),
(82, 171.259, 560.815, 12.628, 2107.43, 299.91, 1399.53, '10', '82', 1, 0, 0, 0, 0),
(83, 1819.68, -2556.21, 11.405, 2107.43, 299.91, 1399.53, '10', '83', 1, 0, 0, 0, 0),
(84, 107.002, 598.585, 13.091, 2107.43, 299.91, 1399.53, '10', '84', 1, 0, 0, 0, 0),
(85, 111.071, 609.411, 13.091, 2107.43, 299.91, 1399.53, '10', '85', 1, 0, 0, 0, 0),
(86, 115.211, 620.426, 13.114, 2107.43, 299.91, 1399.53, '10', '86', 1, 0, 0, 0, 0),
(87, 119.28, 631.254, 13.114, 2107.43, 299.91, 1399.53, '10', '87', 1, 0, 0, 0, 0),
(88, 93.606, 583.493, 13.457, 2107.43, 299.91, 1399.53, '10', '88', 1, 0, 0, 0, 0),
(89, 81.999, 584.958, 13.457, 2107.43, 299.91, 1399.53, '10', '89', 1, 0, 0, 0, 0),
(90, 70.334, 586.432, 13.433, 2107.43, 299.91, 1399.53, '10', '90', 1, 0, 0, 0, 0),
(91, 58.995, 587.864, 13.433, 2107.43, 299.91, 1399.53, '10', '91', 1, 0, 0, 0, 0),
(92, 31.682, 590.704, 13.386, 2107.43, 299.91, 1399.53, '10', '92', 1, 0, 0, 0, 0),
(93, 19.985, 592.181, 13.386, 2107.43, 299.91, 1399.53, '10', '93', 1, 0, 0, 0, 0),
(94, 8.565, 593.772, 13.363, 2107.43, 299.91, 1399.53, '10', '94', 1, 0, 0, 0, 0),
(95, -3.054, 595.091, 13.363, 2107.43, 299.91, 1399.53, '10', '95', 1, 0, 0, 0, 0),
(96, 211.165, 610.05, 12.136, 2107.43, 299.91, 1399.53, '10', '96', 1, 0, 0, 0, 0),
(97, 224.631, 604.882, 12.136, 2107.43, 299.91, 1399.53, '10', '97', 1, 0, 0, 0, 0),
(98, 241.345, 598.465, 12.136, 2107.43, 299.91, 1399.53, '10', '98', 1, 0, 0, 0, 0),
(99, 257.69, 592.192, 12.136, 2107.43, 299.91, 1399.53, '10', '99', 1, 0, 0, 0, 0),
(100, 269.632, 553.976, 12.195, 2107.43, 299.91, 1399.53, '10', '100', 1, 0, 0, 0, 0),
(101, 257.613, 522.667, 12.195, 2107.43, 299.91, 1399.53, '10', '101', 1, 0, 0, 0, 0),
(102, 233.091, 533.803, 12.628, 2107.43, 299.91, 1399.53, '10', '102', 1, 0, 0, 0, 0),
(103, 218.957, 539.284, 12.628, 2107.43, 299.91, 1399.53, '10', '103', 1, 0, 0, 0, 0),
(104, 204.816, 544.769, 12.628, 2107.43, 299.91, 1399.53, '10', '104', 1, 0, 0, 0, 0),
(105, 190.901, 550.166, 12.628, 2107.43, 299.91, 1399.53, '10', '105', 1, 0, 0, 0, 0),
(106, 531.024, 1013.75, 12.448, 2107.43, 299.91, 1399.53, '10', '106', 1, 0, 0, 0, 0),
(107, 531.028, 989.58, 12.448, 2107.43, 299.91, 1399.53, '10', '107', 1, 0, 0, 0, 0),
(108, 531.017, 965.701, 12.448, 2107.43, 299.91, 1399.53, '10', '108', 1, 0, 0, 0, 0),
(109, 531.016, 912.15, 12.448, 2107.43, 299.91, 1399.53, '10', '109', 1, 0, 0, 0, 0),
(110, 531.02, 887.806, 12.448, 2107.43, 299.91, 1399.53, '10', '110', 1, 0, 0, 0, 0),
(111, 531.009, 864.343, 12.448, 2107.43, 299.91, 1399.53, '10', '111', 1, 0, 0, 0, 0),
(112, 512.19, 865.385, 12.484, 2107.43, 299.91, 1399.53, '10', '112', 1, 0, 0, 0, 0),
(113, 512.189, 889.415, 12.484, 2107.43, 299.91, 1399.53, '10', '113', 1, 0, 0, 0, 0),
(114, 512.2, 913.324, 12.484, 2107.43, 299.91, 1399.53, '10', '114', 1, 0, 0, 0, 0),
(115, 512.193, 966.901, 12.484, 2107.43, 299.91, 1399.53, '10', '115', 1, 0, 0, 0, 0),
(116, 512.194, 990.781, 12.484, 2107.43, 299.91, 1399.53, '10', '116', 1, 0, 0, 0, 0),
(117, 512.202, 1015.02, 12.484, 2107.43, 299.91, 1399.53, '10', '117', 1, 0, 0, 0, 0),
(118, 676.613, 661.599, 12.618, 2107.43, 299.91, 1399.53, '10', '118', 1, 0, 0, 0, 0),
(119, 662.644, 666.879, 12.618, 2107.43, 299.91, 1399.53, '10', '119', 1, 0, 0, 0, 0),
(120, 648.279, 672.307, 12.618, 2107.43, 299.91, 1399.53, '10', '120', 1, 0, 0, 0, 0),
(121, 634.339, 677.574, 12.618, 2107.43, 299.91, 1399.53, '10', '121', 1, 0, 0, 0, 0),
(122, 527.007, 645.686, 11.196, 2107.43, 299.91, 1399.53, '10', '122', 1, 0, 0, 0, 0),
(123, 518.04, 621.703, 11.156, 2107.43, 299.91, 1399.53, '10', '123', 1, 0, 0, 0, 0),
(124, 513.704, 595.562, 11.156, 2107.43, 299.91, 1399.53, '10', '124', 1, 0, 0, 0, 0),
(125, 504.745, 571.601, 11.156, 2107.43, 299.91, 1399.53, '10', '125', 1, 0, 0, 0, 0),
(126, 500.913, 545.915, 11.156, 2107.43, 299.91, 1399.53, '10', '126', 1, 0, 0, 0, 0),
(127, 491.874, 521.735, 11.156, 2107.43, 299.91, 1399.53, '10', '127', 1, 0, 0, 0, 0),
(128, 285.47, 593.119, 12.93, 2107.43, 299.91, 1399.53, '10', '128', 1, 0, 0, 0, 0),
(129, 297.464, 624.364, 12.93, 2107.43, 299.91, 1399.53, '10', '129', 1, 0, 0, 0, 0),
(130, 309.556, 655.862, 12.93, 2107.43, 299.91, 1399.53, '10', '130', 1, 0, 0, 0, 0),
(131, 321.51, 687.406, 12.93, 2107.43, 299.91, 1399.53, '10', '131', 1, 0, 0, 0, 0),
(132, -359.762, 1003.28, 12.134, 2107.43, 299.91, 1399.53, '10', '132', 1, 0, 0, 0, 0),
(133, -348.538, 1003.28, 12.134, 2107.43, 299.91, 1399.53, '10', '133', 1, 0, 0, 0, 0),
(134, -337.37, 1003.28, 12.134, 2107.43, 299.91, 1399.53, '10', '134', 1, 0, 0, 0, 0),
(135, -326.284, 1003.28, 12.134, 2107.43, 299.91, 1399.53, '10', '135', 1, 0, 0, 0, 0),
(136, -307.184, 1003.29, 12.38, 2107.43, 299.91, 1399.53, '10', '136', 1, 0, 0, 0, 0),
(137, -296.079, 1003.28, 12.38, 2107.43, 299.91, 1399.53, '10', '137', 1, 0, 0, 0, 0),
(138, -285.179, 1003.28, 12.38, 2107.43, 299.91, 1399.53, '10', '138', 1, 0, 0, 0, 0),
(139, -273.756, 1003.28, 12.38, 2107.43, 299.91, 1399.53, '10', '139', 1, 0, 0, 0, 0),
(140, -244.7, 996.117, 12.38, 2107.43, 299.91, 1399.53, '10', '140', 1, 0, 0, 0, 0),
(141, -233.429, 996.116, 12.38, 2107.43, 299.91, 1399.53, '10', '141', 1, 0, 0, 0, 0),
(142, -222.148, 996.116, 12.38, 2107.43, 299.91, 1399.53, '10', '142', 1, 0, 0, 0, 0),
(143, -179.347, 1005.18, 12.38, 2107.43, 299.91, 1399.53, '10', '143', 1, 0, 0, 0, 0),
(144, -179.344, 1016.37, 12.38, 2107.43, 299.91, 1399.53, '10', '144', 1, 0, 0, 0, 0),
(145, -179.344, 1027.54, 12.38, 2107.43, 299.91, 1399.53, '10', '145', 1, 0, 0, 0, 0),
(146, -179.344, 1038.41, 12.38, 2107.43, 299.91, 1399.53, '10', '146', 1, 0, 0, 0, 0),
(147, -179.344, 1055.62, 12.38, 2107.43, 299.91, 1399.53, '10', '147', 1, 0, 0, 0, 0),
(148, -179.344, 1066.67, 12.38, 2107.43, 299.91, 1399.53, '10', '148', 1, 0, 0, 0, 0),
(149, -179.345, 1077.88, 12.38, 2107.43, 299.91, 1399.53, '10', '149', 1, 0, 0, 0, 0),
(150, -179.344, 1089.03, 12.38, 2107.43, 299.91, 1399.53, '10', '150', 1, 0, 0, 0, 0),
(151, -155.387, 1151.06, 12.276, 2107.43, 299.91, 1399.53, '10', '151', 1, 0, 0, 0, 0),
(152, -143.111, 1139.41, 12.276, 2107.43, 299.91, 1399.53, '10', '152', 1, 0, 0, 0, 0),
(153, -130.722, 1127.66, 12.276, 2107.43, 299.91, 1399.53, '10', '153', 1, 0, 0, 0, 0),
(154, -118.48, 1116.04, 12.276, 2107.43, 299.91, 1399.53, '10', '154', 1, 0, 0, 0, 0),
(155, -105.942, 1104.14, 12.276, 2107.43, 299.91, 1399.53, '10', '155', 1, 0, 0, 0, 0),
(156, -93.743, 1092.56, 12.282, 2107.43, 299.91, 1399.53, '10', '156', 1, 0, 0, 0, 0),
(157, -300.295, 915.424, 13.638, 2107.43, 299.91, 1399.53, '10', '157', 1, 0, 0, 0, 0),
(158, 160.941, 1153.36, 12.265, 2107.43, 299.91, 1399.53, '10', '158', 1, 0, 0, 0, 0),
(159, 159.031, 1136.6, 12.265, 2107.43, 299.91, 1399.53, '10', '159', 1, 0, 0, 0, 0),
(160, 157.097, 1119.62, 12.265, 2107.43, 299.91, 1399.53, '10', '160', 1, 0, 0, 0, 0),
(161, 175.644, 1100.44, 12.276, 2107.43, 299.91, 1399.53, '10', '161', 1, 0, 0, 0, 0),
(162, 177.537, 1117.06, 12.276, 2107.43, 299.91, 1399.53, '10', '162', 1, 0, 0, 0, 0),
(163, 179.468, 1134.01, 12.276, 2107.43, 299.91, 1399.53, '10', '163', 1, 0, 0, 0, 0),
(164, 181.399, 1150.95, 12.276, 2107.43, 299.91, 1399.53, '10', '164', 1, 0, 0, 0, 0),
(165, 131.538, 969.103, 12.276, 2107.43, 299.91, 1399.53, '10', '165', 1, 0, 0, 0, 0),
(166, 115.615, 975.441, 12.276, 2107.43, 299.91, 1399.53, '10', '166', 1, 0, 0, 0, 0),
(167, 86.493, 971.504, 12.265, 2107.43, 299.91, 1399.53, '10', '167', 1, 0, 0, 0, 0),
(168, 80.828, 955.508, 12.265, 2107.43, 299.91, 1399.53, '10', '168', 1, 0, 0, 0, 0),
(169, 75.091, 939.307, 12.265, 2107.43, 299.91, 1399.53, '10', '169', 1, 0, 0, 0, 0),
(170, 69.504, 923.527, 12.265, 2107.43, 299.91, 1399.53, '10', '170', 1, 0, 0, 0, 0),
(171, 55.781, 892.049, 12.265, 2107.43, 299.91, 1399.53, '10', '171', 1, 0, 0, 0, 0),
(172, 71.423, 885.984, 12.265, 2107.43, 299.91, 1399.53, '10', '172', 1, 0, 0, 0, 0),
(173, 87.482, 879.98, 12.265, 2107.43, 299.91, 1399.53, '10', '173', 1, 0, 0, 0, 0),
(174, 103.163, 874.117, 12.265, 2107.43, 299.91, 1399.53, '10', '174', 1, 0, 0, 0, 0),
(175, 141.12, 871.908, 12.265, 2107.43, 299.91, 1399.53, '10', '175', 1, 0, 0, 0, 0),
(176, 157.504, 876.296, 12.265, 2107.43, 299.91, 1399.53, '10', '176', 1, 0, 0, 0, 0),
(177, 173.905, 880.871, 12.265, 2107.43, 299.91, 1399.53, '10', '177', 1, 0, 0, 0, 0),
(178, 190.282, 885.079, 12.265, 2107.43, 299.91, 1399.53, '10', '178', 1, 0, 0, 0, 0),
(179, 214.581, 906.971, 12.242, 2107.43, 299.91, 1399.53, '10', '179', 1, 0, 0, 0, 0),
(180, 218.705, 923.507, 12.242, 2107.43, 299.91, 1399.53, '10', '180', 1, 0, 0, 0, 0),
(181, 226.335, 967.182, 12.265, 2107.43, 299.91, 1399.53, '10', '181', 1, 0, 0, 0, 0),
(182, 228.272, 984.147, 12.265, 2107.43, 299.91, 1399.53, '10', '182', 1, 0, 0, 0, 0),
(183, 230.196, 1001.04, 12.265, 2107.43, 299.91, 1399.53, '10', '183', 1, 0, 0, 0, 0),
(184, 232.034, 1018.05, 12.265, 2107.43, 299.91, 1399.53, '10', '184', 1, 0, 0, 0, 0),
(185, 195.104, 944.447, 12.282, 2107.43, 299.91, 1399.53, '10', '185', 1, 0, 0, 0, 0),
(186, 179.208, 950.614, 12.276, 2107.43, 299.91, 1399.53, '10', '186', 1, 0, 0, 0, 0),
(187, 163.263, 956.798, 12.276, 2107.43, 299.91, 1399.53, '10', '187', 1, 0, 0, 0, 0),
(188, 147.452, 962.992, 12.276, 2107.43, 299.91, 1399.53, '10', '188', 1, 0, 0, 0, 0),
(189, 127.262, 1164.91, 12.265, 2107.43, 299.91, 1399.53, '10', '189', 1, 0, 0, 0, 0),
(190, 123.913, 1148.28, 12.265, 2107.43, 299.91, 1399.53, '10', '190', 1, 0, 0, 0, 0),
(191, 120.535, 1131.85, 12.265, 2107.43, 299.91, 1399.53, '10', '191', 1, 0, 0, 0, 0),
(192, 117.216, 1115.17, 12.265, 2107.43, 299.91, 1399.53, '10', '192', 1, 0, 0, 0, 0),
(193, 108.21, 1069.38, 12.265, 2107.43, 299.91, 1399.53, '10', '193', 1, 0, 0, 0, 0),
(194, 104.684, 1052.84, 12.265, 2107.43, 299.91, 1399.53, '10', '194', 1, 0, 0, 0, 0),
(195, 101.468, 1036.24, 12.265, 2107.43, 299.91, 1399.53, '10', '195', 1, 0, 0, 0, 0),
(196, 98.058, 1019.47, 12.265, 2107.43, 299.91, 1399.53, '10', '196', 1, 0, 0, 0, 0),
(197, 2385.26, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '197', 1, 0, 0, 0, 0),
(198, 2409.14, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '198', 1, 0, 0, 0, 0),
(199, 2433.5, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '199', 1, 0, 0, 0, 0),
(200, 2349.55, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '200', 1, 0, 0, 0, 0),
(201, 2325.53, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '201', 1, 0, 0, 0, 0),
(202, 2301.74, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '202', 1, 0, 0, 0, 0),
(203, 2265.73, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '203', 1, 0, 0, 0, 0),
(204, 2241.65, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '204', 1, 0, 0, 0, 0),
(205, 2217.55, -2473.08, 22.839, 2107.43, 299.91, 1399.53, '10', '205', 1, 0, 0, 0, 0),
(206, 2363.71, -2530.16, 21.871, 2107.43, 299.91, 1399.53, '10', '206', 1, 0, 0, 0, 0),
(207, 2363.71, -2519.84, 21.871, 2107.43, 299.91, 1399.53, '10', '207', 1, 0, 0, 0, 0),
(208, 2363.71, -2509.12, 21.871, 2107.43, 299.91, 1399.53, '10', '208', 1, 0, 0, 0, 0),
(209, 2363.71, -2498.77, 21.871, 2107.43, 299.91, 1399.53, '10', '209', 1, 0, 0, 0, 0),
(210, 2394.88, -2550.67, 21.989, 2107.43, 299.91, 1399.53, '10', '210', 1, 0, 0, 0, 0),
(211, 2408.92, -2550.67, 21.989, 2107.43, 299.91, 1399.53, '10', '211', 1, 0, 0, 0, 0),
(212, 2422.75, -2550.67, 21.989, 2107.43, 299.91, 1399.53, '10', '212', 1, 0, 0, 0, 0),
(213, 2343.87, -2641.21, 22.445, 2107.43, 299.91, 1399.53, '10', '213', 1, 0, 0, 0, 0),
(214, 2314.07, -2641.21, 22.445, 2107.43, 299.91, 1399.53, '10', '214', 1, 0, 0, 0, 0),
(215, 2283.84, -2641.17, 22.445, 2107.43, 299.91, 1399.53, '10', '215', 1, 0, 0, 0, 0),
(216, 2390.21, -2618.82, 22.043, 2107.43, 299.91, 1399.53, '10', '216', 1, 0, 0, 0, 0),
(217, 2390.21, -2598.17, 22.043, 2107.43, 299.91, 1399.53, '10', '217', 1, 0, 0, 0, 0),
(218, 2397.43, -2590.87, 22.043, 2107.43, 299.91, 1399.53, '10', '218', 1, 0, 0, 0, 0),
(219, 2415.34, -2590.86, 22.043, 2107.43, 299.91, 1399.53, '10', '219', 1, 0, 0, 0, 0),
(220, 2436.01, -2590.86, 22.043, 2107.43, 299.91, 1399.53, '10', '220', 1, 0, 0, 0, 0),
(221, 2505.71, -2589.4, 22.604, 2107.43, 299.91, 1399.53, '10', '221', 1, 0, 0, 0, 0),
(222, 2505.71, -2604.38, 22.604, 2107.43, 299.91, 1399.53, '10', '222', 1, 0, 0, 0, 0),
(223, 2505.71, -2619.67, 22.604, 2107.43, 299.91, 1399.53, '10', '223', 1, 0, 0, 0, 0),
(224, 2505.83, -2634.95, 22.604, 2107.43, 299.91, 1399.53, '10', '224', 1, 0, 0, 0, 0),
(225, 2549.37, -2619.53, 22.598, 2107.43, 299.91, 1399.53, '10', '225', 1, 0, 0, 0, 0),
(226, 2549.32, -2634.99, 22.598, 2107.43, 299.91, 1399.53, '10', '226', 1, 0, 0, 0, 0),
(227, 2549.37, -2604.52, 22.598, 2107.43, 299.91, 1399.53, '10', '227', 1, 0, 0, 0, 0),
(228, 2549.37, -2589.17, 22.598, 2107.43, 299.91, 1399.53, '10', '228', 1, 0, 0, 0, 0),
(229, 2549.37, -2540.57, 22.598, 2107.43, 299.91, 1399.53, '10', '229', 1, 0, 0, 0, 0),
(230, 2549.37, -2525.65, 22.598, 2107.43, 299.91, 1399.53, '10', '230', 1, 0, 0, 0, 0),
(231, 2549.36, -2510.42, 22.598, 2107.43, 299.91, 1399.53, '10', '231', 1, 0, 0, 0, 0),
(232, 2549.37, -2495.34, 22.598, 2107.43, 299.91, 1399.53, '10', '232', 1, 0, 0, 0, 0),
(233, 2505.71, -2495.22, 22.603, 2107.43, 299.91, 1399.53, '10', '233', 1, 0, 0, 0, 0),
(234, 2505.71, -2510.29, 22.603, 2107.43, 299.91, 1399.53, '10', '234', 1, 0, 0, 0, 0),
(235, 2505.71, -2525.46, 22.603, 2107.43, 299.91, 1399.53, '10', '235', 1, 0, 0, 0, 0),
(236, 2505.8, -2540.77, 22.603, 2107.43, 299.91, 1399.53, '10', '236', 1, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `promocode`
--

CREATE TABLE `promocode` (
  `id` int(11) NOT NULL,
  `name` varchar(34) NOT NULL,
  `hours` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `coins` int(11) NOT NULL DEFAULT 0,
  `euro` int(11) NOT NULL DEFAULT 0,
  `vehicle` int(11) DEFAULT 0,
  `count` int(11) DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Дамп данных таблицы `promocode`
--

INSERT INTO `promocode` (`id`, `name`, `hours`, `money`, `coins`, `euro`, `vehicle`, `count`, `status`) VALUES
(1, 'Test', 5, 10000, 1000, 1000, 0, NULL, 0),
(6, 'PERFECT', 10, 1000, 1000, 1000, 0, NULL, 1),
(8, 'PERFECTRP', 10, 1000, 100, 1000, 0, NULL, 1),
(9, 'Shadow', 10, 100000, 1000, 1000, 0, NULL, 0),
(10, 'Test2', 2, 24214, 12, 24, 411, NULL, 1),
(11, '', 0, 0, 0, 0, 0, NULL, 1),
(12, 'Test3', 2, 123213, 123, 123, 0, NULL, 1),
(13, 'Test228', 0, 0, 0, 0, 411, NULL, 1),
(14, 'Test1337', 1, 1000, 1000, 1000, 560, NULL, 1),
(15, 'Testo', 0, 100, 1000, 10, 1, 0, 1),
(16, 'Test24', 0, 10, 100, 1, 0, 0, 0),
(17, 'Test241', 0, 10, 10, 10, 0, 1, 1),
(18, 'Test2412', 0, 24, 24, 24, 0, 0, 1),
(19, 'testveh', 0, 0, 0, 0, 560, 0, 0),
(20, 'Testt', 0, 0, 100000, 0, 0, 0, 0),
(21, 'TEST123', 0, 0, 1000000, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `prpdev_key`
--

CREATE TABLE `prpdev_key` (
  `user_id` int(11) NOT NULL,
  `player_key` varchar(15) NOT NULL,
  `nick` varchar(25) NOT NULL,
  `accept` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `radar`
--

CREATE TABLE `radar` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `r` float NOT NULL,
  `speed` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `rX` float NOT NULL DEFAULT 0,
  `rY` float NOT NULL DEFAULT 0,
  `rZ` float NOT NULL DEFAULT 0,
  `rV` float NOT NULL DEFAULT 0,
  `rI` float NOT NULL DEFAULT 0,
  `rExitX` float NOT NULL DEFAULT 0,
  `rExitY` float NOT NULL DEFAULT 0,
  `rExitZ` float NOT NULL DEFAULT 0,
  `rExitV` float NOT NULL DEFAULT 0,
  `rExitI` float NOT NULL DEFAULT 0,
  `rType` int(11) NOT NULL DEFAULT 0,
  `rCost` int(11) NOT NULL DEFAULT 0,
  `rOwner` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'None',
  `rOwned` int(11) NOT NULL DEFAULT -1,
  `rOplata` int(20) NOT NULL DEFAULT 0,
  `rLock` int(11) NOT NULL DEFAULT 0,
  `rPickupEnter` int(11) NOT NULL DEFAULT 0,
  `rPickupExit` int(11) NOT NULL DEFAULT 0,
  `rSphereEnter` int(11) NOT NULL DEFAULT 0,
  `rSphereExit` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `serialbans`
--

CREATE TABLE `serialbans` (
  `id` int(11) NOT NULL,
  `name` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `serial_id` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ip` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `whobanned` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `t_warn_logs`
--

CREATE TABLE `t_warn_logs` (
  `id` int(11) NOT NULL,
  `name` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `issued` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `fraction` int(11) NOT NULL,
  `reason` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `unitpay_payments`
--

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
-- Структура таблицы `vehicle`
--

CREATE TABLE `vehicle` (
  `id` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `x` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `y` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `z` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `fa` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
  `vint` int(11) NOT NULL DEFAULT 0,
  `world` int(11) NOT NULL,
  `colors` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0, 0',
  `fraction` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0,
  `cost` int(11) NOT NULL DEFAULT 0,
  `mileage` float NOT NULL DEFAULT 0,
  `dostup` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `vehicle`
--

INSERT INTO `vehicle` (`id`, `model`, `x`, `y`, `z`, `fa`, `vint`, `world`, `colors`, `fraction`, `status`, `cost`, `mileage`, `dostup`) VALUES
(7, 551, '1880.02453', '-2211.6555', '11.130593', '359.574798', 0, 0, '0, 0', 1, 0, 0, 0, 8),
(8, 400, '1886.43920', '-2211.6296', '11.129943', '0.048457', 0, 0, '0, 0', 1, 0, 0, 0, 1),
(9, 400, '1898.73059', '-2211.4536', '11.110510', '0.339775', 0, 0, '0, 0', 1, 0, 0, 0, 1),
(10, 529, '1915.93371', '-2211.4008', '11.115363', '0.174714', 0, 0, '0, 0', 1, 0, 0, 0, 5),
(11, 579, '1929.16223', '-2211.7553', '11.135858', '358.889678', 0, 0, '0, 0', 1, 0, 0, 0, 3),
(12, 579, '1922.56152', '-2211.2326', '11.044502', '0.549939', 0, 0, '0, 0', 1, 0, 0, 0, 3),
(13, 529, '1892.65295', '-2211.4587', '11.038733', '0.529636', 0, 0, '0, 0', 1, 0, 0, 0, 4),
(14, 489, '2574.77978', '-2445.9946', '21.742746', '359.798248', 0, 0, '1, 1', 2, 0, 0, 0, 4),
(15, 589, '2552.92407', '-2446.0568', '21.799797', '359.459442', 0, 0, '1, 1', 2, 0, 0, 0, 1),
(16, 589, '2571.06591', '-2446.0166', '21.742710', '0.234902', 0, 0, '1, 1', 2, 0, 0, 0, 4),
(17, 599, '2567.32250', '-2446.1716', '21.742805', '0.588838', 0, 0, '1, 1', 2, 0, 0, 0, 2),
(18, 599, '2563.63159', '-2446.0444', '21.776109', '359.790893', 0, 0, '1, 1', 2, 0, 0, 0, 2),
(19, 599, '2560.23291', '-2446.0212', '21.775974', '359.791839', 0, 0, '1, 1', 2, 0, 0, 0, 6),
(20, 589, '2568.66503', '-2428.5493', '21.757549', '221.153305', 0, 0, '1, 1', 2, 0, 0, 0, 1),
(22, 470, '-2554.9158', '-604.4194', '29.4505', '179.7316', 0, 0, '0, 0', 8, 0, 0, 0, 5),
(23, 579, '-2568.4741', '-622.6333', '29.4506', '271.6017', 0, 0, '0, 0', 8, 0, 0, 0, 10),
(24, 563, '-2498.5854', '-719.2565', '30.3801', '89.6223', 0, 0, '123, 123', 8, 0, 0, 0, 5),
(25, 579, '-2512.4219', '-548.6602', '29.9038', '182.2019', 0, 0, '123, 123', 8, 0, 0, 0, 3),
(26, 529, '-2502.5022', '-557.6049', '29.6167', '90.00', 0, 0, '123, 123', 8, 0, 0, 0, 3),
(27, 470, '-2502.5010', '-561.6884', '29.6173', '90.5917', 0, 0, '123, 123', 8, 0, 0, 0, 3),
(28, 579, '-2502.5601', '-566.3994', '29.9745', '90.00', 0, 0, '123, 123', 8, 0, 0, 1.578, 7),
(29, 470, '-2521.3525', '-548.6030', '29.9722', '180.2528', 0, 0, '123, 123', 8, 0, 0, 0, 7),
(30, 432, '-2555.0430', '-549.3094', '29.7888', '180.4301', 0, 0, '123, 123', 8, 0, 0, 0, 10),
(31, 400, '-336.1217', '839.7283', '13.1795', '180.00', 0, 0, '16, 16', 11, 0, 0, 0, 3),
(32, 400, '-329.3221', '839.5938', '12.7831', '180.00', 0, 0, '16, 16', 11, 0, 0, 0, 3),
(33, 529, '-299.8385', '828.1597', '13.1045', '360.00', 0, 0, '16, 16', 11, 0, 0, 0, 8),
(34, 466, '-323.0792', '839.5632', '12.7831', '180.00', 0, 0, '16, 16', 11, 0, 0, 0, 4),
(35, 466, '-316.8892', '839.6926', '12.7807', '180.00', 0, 0, '16, 16', 11, 0, 0, 1.578, 3),
(36, 505, '-311.7798', '840.2236', '13.1504', '180.00', 0, 0, '16, 16', 11, 0, 0, 0, 3),
(37, 505, '-306.3122', '839.9764', '12.6838', '180.00', 0, 0, '16, 16', 11, 0, 0, 0, 3),
(55, 409, '2416.0903', '-1796.4637', '18.7559', '180.0835', 0, 0, '0, 0', 3, 0, 0, 0, 3),
(56, 409, '2411.6067', '-1796.9816', '19.1242', '180.9729', 0, 0, '0, 0', 3, 0, 0, 0, 3),
(57, 459, '2399.4778', '-1796.6848', '19.1719', '180.8925', 0, 0, '0, 0', 3, 0, 0, 0, 4),
(58, 490, '2399.2971', '-1818.8043', '19.1719', '179.7576', 0, 0, '0, 0', 3, 0, 0, 0, 2),
(59, 400, '2407.3633', '-1796.6761', '19.1719', '181.3185', 0, 0, '0, 0', 3, 0, 0, 1.578, 1),
(60, 551, '2420.6921', '-1796.5308', '18.7559', '180.0422', 0, 0, '0, 0', 3, 0, 0, 0, 9),
(61, 551, '2424.6421', '-1796.5612', '19.1845', '179.8652', 0, 0, '0, 0', 3, 0, 0, 0, 9),
(62, 459, '2403.1563', '-1797.0354', '19.1882', '179.9838', 0, 0, '0, 0', 3, 0, 0, 4.366, 2),
(65, 491, '2213.4224', '-2581.4170', '22.0792', '269.4204', 0, 0, '205, 205', 9, 0, 0, 0, 5),
(66, 491, '2213.5090', '-2589.6165', '21.7600', '269.4204', 0, 0, '205, 205', 9, 0, 0, 0, 5),
(67, 410, '2213.7776', '-2585.4243', '21.7780', '269.4204', 0, 0, '205, 205', 9, 0, 0, 0, 1),
(68, 400, '2213.2742', '-2593.7307', '21.7630', '269.4204', 0, 0, '205, 205', 9, 0, 0, 0, 3),
(69, 602, '2261.4155', '-2583.5679', '21.7755', '90.1832', 0, 0, '205, 205', 9, 0, 0, 0, 9),
(70, 400, '2213.0308', '-2597.8691', '22.0549', '270.7493', 0, 0, '205, 205', 9, 0, 0, 0, 4),
(71, 567, '2213.9827', '-2602.0894', '21.8227', '270.3472', 0, 0, '205, 205', 9, 0, 0, 0, 1),
(72, 507, '2214.0266', '-2606.1995', '21.7756', '270.3472', 0, 0, '0, 0', 9, 0, 0, 0, 8),
(73, 567, '2591.4976', '1781.2662', '2.4316', '270.0000', 0, 0, '132, 132', 10, 0, 0, 2.449, 2),
(74, 602, '2592.0874', '1785.3362', '2.2242', '270.0000', 0, 0, '132, 132', 10, 0, 0, 0, 8),
(75, 400, '2592.2268', '1773.0891', '2.1774', '270.0000', 0, 0, '132, 132', 10, 0, 0, 0, 2),
(76, 475, '2591.5588', '1764.6967', '1.9906', '270.0000', 0, 0, '132, 132', 10, 0, 0, 0, 2),
(77, 491, '2591.7300', '1769.0071', '2.1056', '270.0000', 0, 0, '132, 132', 10, 0, 0, 0, 2),
(78, 521, '2592.0540', '1760.3539', '2.1005', '270.0000', 0, 0, '0, 0', 10, 0, 0, 0, 2),
(79, 536, '2592.0549', '1777.1123', '2.0818', '270.0000', 0, 0, '0, 0', 10, 0, 0, 0, 2),
(80, 491, '205.9341', '1356.4237', '11.5651', '353.6674', 0, 0, '0, 0', 5, 0, 0, 0, 10),
(81, 400, '197.6552', '1357.5228', '11.6792', '353.6674', 0, 0, '0, 0', 5, 0, 0, 0, 8),
(82, 400, '209.9525', '1356.3187', '11.6810', '353.6674', 0, 0, '204, 204', 5, 0, 0, 0, 8),
(83, 400, '214.1147', '1355.8269', '11.6797', '353.6674', 0, 0, '204, 204', 5, 0, 0, 0, 1),
(84, 400, '218.2823', '1355.0690', '11.6819', '353.6674', 0, 0, '204, 204', 5, 0, 0, 0, 1),
(85, 400, '222.1852', '1354.6882', '11.7184', '353.6674', 0, 0, '204, 204', 5, 0, 0, 1.578, 1),
(86, 602, '201.7040', '1357.1278', '11.7172', '353.6674', 0, 0, '204, 0', 5, 0, 0, 0, 1),
(87, 536, '226.3581', '1354.0483', '11.6806', '353.6674', 0, 0, '204, 0', 5, 0, 0, 0, 1),
(88, 482, '-895.7245', '1231.5156', '10.2776', '184.2299', 0, 0, '0, 0', 6, 0, 0, 4.366, 3),
(89, 482, '-916.2234', '1229.7354', '10.2790', '184.2299', 0, 0, '0, 0', 6, 0, 0, 0, 3),
(90, 482, '-920.2850', '1229.4932', '10.6291', '184.2299', 0, 0, '133, 133', 6, 0, 0, 0, 3),
(91, 482, '-891.5345', '1231.6520', '10.6263', '184.2299', 0, 0, '133, 133', 6, 0, 0, 0, 1),
(92, 491, '-903.8411', '1230.6749', '10.2788', '184.2299', 0, 0, '133, 0', 6, 0, 0, 0, 1),
(93, 491, '-899.7907', '1230.9471', '10.2767', '184.2299', 0, 0, '133, 0', 6, 0, 0, 0, 1),
(94, 491, '-908.1215', '1230.7146', '10.6113', '184.2299', 0, 0, '133, 133', 6, 0, 0, 0, 2),
(95, 491, '-912.3683', '1230.3712', '10.6113', '184.2299', 0, 0, '133, 133', 6, 0, 0, 0, 1),
(96, 535, '376.5701', '787.9952', '11.8647', '160.82', 0, 0, '0, 0', 7, 0, 0, 0, 3),
(97, 536, '380.5624', '786.5128', '11.7215', '160.82', 0, 0, '0, 0', 7, 0, 0, 0, 8),
(98, 602, '384.4368', '785.6014', '11.7563', '160.82', 0, 0, '0, 0', 7, 0, 0, 0, 1),
(99, 604, '388.3203', '783.9750', '11.7966', '160.82', 0, 0, '0, 0', 7, 0, 0, 2.449, 1),
(100, 482, '392.3513', '782.4946', '11.7943', '160.82', 0, 0, '0, 0', 7, 0, 0, 0, 8),
(101, 536, '399.9998', '780.0806', '12.1082', '160.82', 0, 0, '0, 0', 7, 0, 0, 0, 5),
(102, 602, '396.2416', '781.5951', '12.0888', '160.82', 0, 0, '0, 0', 7, 0, 0, 0, 3),
(118, 601, '2556.63793', '-2445.9782', '21.871011', '359.582489', 0, 0, '1, 1', 2, 0, 0, 0, 8),
(120, 416, '2098.7622', '-2412.6257', '21.9993', '90.0000', 0, 0, '1, 3', 4, 0, 0, 0, 2),
(121, 416, '2098.8286', '-2419.7551', '21.7317', '90.0000', 0, 0, '1, 3', 4, 0, 0, 0, 2),
(122, 507, '2098.9456', '-2426.5771', '21.7317', '90.0000', 0, 0, '1, 3', 4, 0, 0, 0, 5),
(123, 567, '2099.1233', '-2434.0310', '21.7317', '90.0000', 0, 0, '1, 3', 4, 0, 0, 0, 6),
(127, 490, '2399.9302', '-1809.1655', '18.8757', '359.2939', 0, 0, '0, 0', 3, 0, 0, 0, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `vip`
--

CREATE TABLE `vip` (
  `ID` int(4) NOT NULL DEFAULT 0,
  `AD` int(4) NOT NULL DEFAULT 0,
  `SMS` int(4) NOT NULL DEFAULT 0,
  `CAR` int(4) NOT NULL DEFAULT 0,
  `GUN` int(4) NOT NULL DEFAULT 0,
  `EXP` int(4) NOT NULL DEFAULT 0,
  `WORK` int(4) NOT NULL DEFAULT 0,
  `SKIN` int(4) NOT NULL DEFAULT 0,
  `BIZZ` int(4) NOT NULL DEFAULT 0,
  `CHAT` int(4) NOT NULL DEFAULT 0,
  `CALL` int(4) NOT NULL DEFAULT 0,
  `HOUSE` int(4) NOT NULL DEFAULT 0,
  `ADMIN` int(4) NOT NULL DEFAULT 0,
  `DRUGS` int(4) NOT NULL DEFAULT 0,
  `BONUS` int(4) NOT NULL DEFAULT 0,
  `PHONE` int(4) NOT NULL DEFAULT 0,
  `IZNAS` int(4) NOT NULL DEFAULT 0,
  `BOTTLE` int(4) NOT NULL DEFAULT 0,
  `REPORT` int(4) NOT NULL DEFAULT 0,
  `ENGINE` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Конфигурации VIP привелегий';

--
-- Дамп данных таблицы `vip`
--

INSERT INTO `vip` (`ID`, `AD`, `SMS`, `CAR`, `GUN`, `EXP`, `WORK`, `SKIN`, `BIZZ`, `CHAT`, `CALL`, `HOUSE`, `ADMIN`, `DRUGS`, `BONUS`, `PHONE`, `IZNAS`, `BOTTLE`, `REPORT`, `ENGINE`) VALUES
(1, 0, 0, 2, 2, 1, 5, 2, 2, 1, 0, 2, 1, 20, 5, 1, 1, 1, 0, 1),
(2, 0, 1, 5, 5, 1, 10, 5, 5, 1, 1, 5, 1, 25, 7, 1, 1, 1, 0, 1),
(3, 1, 1, 7, 7, 1, 15, 7, 7, 1, 1, 7, 1, 30, 10, 1, 1, 1, 0, 1),
(4, 1, 1, 10, 10, 2, 20, 10, 10, 1, 1, 10, 1, 50, 15, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `yacht`
--

CREATE TABLE `yacht` (
  `id` int(11) NOT NULL,
  `y_model` int(11) NOT NULL DEFAULT 0,
  `y_owner` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL,
  `y_color` int(11) NOT NULL DEFAULT 0,
  `y_lock` int(11) NOT NULL DEFAULT 0,
  `y_price` int(11) NOT NULL DEFAULT 0,
  `y_x` float NOT NULL DEFAULT 0,
  `y_y` float NOT NULL DEFAULT 0,
  `y_z` float NOT NULL DEFAULT 0,
  `y_r` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `yacht`
--

INSERT INTO `yacht` (`id`, `y_model`, `y_owner`, `y_color`, `y_lock`, `y_price`, `y_x`, `y_y`, `y_z`, `y_r`) VALUES
(1, 454, 'James_Goldberg', 0, 1, 60000000, 0, 0, 0, 0),
(2, 446, 'Ivan_Campo', 0, 0, 15000000, 0, 0, 0, 0),
(3, 446, 'Tema_Takt', 101, 1, 15000000, 0, 0, 0, 0),
(4, 446, 'Baby_Monopoly', 0, 1, 15000000, 0, 0, 0, 0),
(6, 446, 'Amir_Putin', 6, 1, 15000000, 0, 0, 0, 0),
(7, 446, 'Daniil_Cokol', 0, 0, 15000000, 0, 0, 0, 0),
(9, 446, 'Sergei_Sergei', 0, 1, 15000000, 0, 0, 0, 0),
(10, 446, 'Fred_Dillinger', 3, 0, 15000000, 1964.82, -2782.56, -0.581, 69.599),
(12, 446, 'Rostik_Gutnik', 123, 0, 15000000, 0, 0, 0, 0),
(13, 446, 'Robert_Magaramov', 0, 1, 15000000, 2698.92, -2762.29, 2.954, 45.501),
(14, 446, 'Daniil_Himan', 123, 1, 15000000, 0, 0, 0, 0),
(15, 446, 'Fedor_Lukyanov', 0, 1, 15000000, 0, 0, 0, 0),
(16, 446, 'Roma_Teyk', 0, 1, 15000000, 0, 0, 0, 0),
(17, 446, 'Bakhtovar_Radjabov', 3, 1, 15000000, 2917.53, 1003.4, -0.121, 283.281),
(19, 446, 'Santa_Versace', 0, 1, 15000000, 0, 0, 0, 0),
(20, 446, 'Trizzini_Defacto', 93, 1, 15000000, 0, 0, 0, 0),
(24, 446, 'Danil_Skillmachine', 0, 1, 15000000, 0, 0, 0, 0),
(25, 446, 'Vladik_Usmanov', 86, 1, 15000000, 0, 0, 0, 0),
(26, 454, 'Vladimir_Kutuzov', 1, 1, 60000000, 0, 0, 0, 0),
(28, 446, 'Kendary_Alwaez', 0, 1, 15000000, 0, 0, 0, 0),
(30, 446, 'Vladimir_Vopovski', 0, 1, 15000000, 0, 0, 0, 0),
(31, 446, 'Zenya_Fedulov', 0, 1, 15000000, 0, 0, 0, 0),
(32, 446, 'Danik_Shalkov', 0, 1, 15000000, 0, 0, 0, 0),
(33, 446, 'Donald_Tramp', 0, 1, 15000000, 0, 0, 0, 0),
(34, 446, 'Dima_Lineechkin', 0, 1, 15000000, 0, 0, 0, 0),
(36, 446, 'Karat_Hennessy', 0, 1, 15000000, 2253.32, -1107.37, -0.656, 53.865),
(37, 446, 'Anton_Bosow', 0, 1, 15000000, 2924.04, 2331.79, -0.414, 100.246),
(39, 446, 'Egor_Agapov', 6, 0, 15000000, 2109.79, -1119.43, -0.513, 1.601),
(41, 446, 'Johan_Game', 3, 1, 15000000, 0, 0, 0, 0),
(42, 454, 'Vova_Stepanow', 0, 1, 60000000, 1878.26, 3000.49, -0.227, 94.547),
(43, 446, 'Chris_Devis', 0, 1, 15000000, 0, 0, 0, 0),
(44, 446, 'Ilya_Thompson', 6, 1, 15000000, 0, 0, 0, 0),
(45, 446, 'Maks_Vyalov', 6, 1, 15000000, 2388.43, -2813.72, -0.472, 16.394),
(46, 446, 'Diana_Ahmatova', 0, 1, 15000000, 0, 0, 0, 0),
(47, 446, 'Dima_Kolbasa', 0, 0, 15000000, 0, 0, 0, 0),
(48, 446, 'Savva_Gaydar', 101, 1, 15000000, 0, 0, 0, 0),
(49, 446, 'paul_xui', 3, 1, 15000000, 0, 0, 0, 0),
(50, 454, 'Timur_Galimov', 0, 0, 60000000, 2103.3, -1121.36, 0.614, 190.257),
(51, 446, 'Staff_McFly', 93, 1, 15000000, 0, 0, 0, 0),
(52, 454, 'Max_Latow', 3, 1, 60000000, 2210.82, -1103.65, 0.069, 87.365),
(54, 446, 'Graun_Dan', 3, 1, 15000000, 2838.77, -2081.8, -0.631, 271.433),
(55, 454, 'Ilya_Shishkov', 0, 1, 60000000, 0, 0, 0, 0),
(56, 446, 'Bogdan_Xxx', 0, 1, 15000000, 0, 0, 0, 0),
(60, 454, 'Muin_Saba', 0, 1, 60000000, 0, 0, 0, 0),
(61, 446, 'Ilya_Firsov', 101, 1, 15000000, 0, 0, 0, 0),
(62, 454, 'Thomas_Shelby', 0, 1, 60000000, 0, 0, 0, 0),
(66, 446, 'Serega_Anoni', 0, 1, 15000000, 0, 0, 0, 0),
(67, 446, 'Ivan_Rodon', 3, 0, 15000000, 2349.58, -1124.8, -0.638, 193.074),
(68, 454, 'Vlad_Valaksov', 1, 0, 60000000, 2421.85, -1090.48, 0.062, 183.91),
(69, 454, 'Vladimir_Coronavirus', 6, 0, 60000000, 0, 0, 0, 0),
(70, 454, 'Alesha_Petrovich', 0, 1, 60000000, 0, 0, 0, 0),
(71, 0, 'Alisher_Morgenstern', 0, 0, 0, 0, 0, 0, 0),
(72, 446, 'Tol_Mob', 0, 1, 15000000, 0, 0, 0, 0),
(73, 454, 'Andrey_Stromberger', 1, 1, 60000000, 0, 0, 0, 0),
(76, 446, 'Admini_Luchshie', 103, 1, 15000000, 0, 0, 0, 0),
(78, 454, 'Denus_Pankratov', 0, 0, 60000000, 0, 0, 0, 0),
(79, 446, 'Nikos_Larionov', 0, 1, 15000000, 2375.04, -2806.3, -0.669, 171.723),
(80, 446, 'Stepan_Zabotin', 1, 0, 15000000, 0, 0, 0, 0),
(81, 454, 'Vladik_Brown', 0, 1, 60000000, 0, 0, 0, 0),
(82, 446, 'Jack_Miller', 0, 0, 15000000, 0, 0, 0, 0),
(83, 446, 'Dmitriy_Flexov', 0, 1, 15000000, 2834.91, -2635.12, -0.611, 185.399),
(85, 446, 'Nikita_Malaev', 3, 1, 15000000, 2835.24, -1746.35, -0.408, 81.262),
(87, 454, 'Vasiliy_Kozhedub', 1, 1, 60000000, 2142.8, -1111.97, 0.071, 167.78),
(88, 446, 'Nikolay_Malaev', 0, 0, 15000000, 0, 0, 0, 0),
(90, 446, 'Gleb_Makarety', 1, 1, 15000000, 0, 0, 0, 0),
(91, 446, 'BYCTEP_DAfgyt', 93, 0, 15000000, 0, 0, 0, 0),
(93, 454, 'Maksim_Versace', 0, 1, 60000000, 0, 0, 0, 0),
(94, 446, 'Buster_But', 0, 1, 15000000, 0, 0, 0, 0),
(95, 446, 'Jon_Verseti', 6, 1, 15000000, 2836.41, -1391.45, -0.491, 318.291),
(96, 446, 'Artem_Amigos', 0, 1, 15000000, 0, 0, 0, 0),
(99, 446, 'Andrushka_Ruban', 123, 1, 15000000, 1487.56, 3000.95, -0.273, 273.965),
(100, 446, 'Andrey_Bogdaev', 0, 1, 15000000, 0, 0, 0, 0),
(101, 446, 'Kirill_Ckorodymov', 0, 1, 15000000, 0, 0, 0, 0),
(102, 446, 'DNNDNFJXHDBSHXH', 0, 1, 15000000, 0, 0, 0, 0),
(104, 446, 'dedred', 0, 1, 15000000, 0, 0, 0, 0),
(105, 446, 'Illa_Borovoy', 123, 1, 15000000, 0, 0, 0, 0),
(106, 446, 'Tol_Saz', 3, 1, 15000000, 0, 0, 0, 0),
(107, 446, 'Lav_Saw', 0, 0, 15000000, 0, 0, 0, 0),
(108, 454, 'Maksim_Safonkin', 0, 1, 60000000, 2718.7, -1281.17, 0.086, 38.363),
(109, 454, 'Robik_Angel', 0, 1, 60000000, 2424.29, -2785.31, 0.439, 173.859),
(110, 454, 'Ramazan_Chahuh', 1, 1, 60000000, 0, 0, 0, 0),
(111, 446, 'Artema_Fuke', 0, 1, 15000000, 0, 0, 0, 0),
(112, 446, 'Danilka_Racer', 0, 0, 15000000, 0, 0, 0, 0),
(113, 454, 'Egor_Korabin', 0, 1, 60000000, 2234.29, -1106.5, 0.073, 152.92),
(114, 454, 'Nikita_Enin', 0, 1, 60000000, 2226.19, -1103.6, 0.075, 87.601),
(115, 446, 'Alex_Lotar', 0, 1, 15000000, 2767.25, -1275.82, -0.656, 257.969),
(117, 446, 'Seen_Kapone', 0, 1, 15000000, 0, 0, 0, 0),
(118, 446, 'Romik_Xhabibaaaaaa', 6, 0, 15000000, 0, 0, 0, 0),
(119, 446, 'Sasha_Govnuk', 0, 1, 15000000, 0, 0, 0, 0),
(120, 446, 'Zardes_Storm', 0, 1, 15000000, 0, 0, 0, 0),
(121, 446, 'Vitolik_Dermolik', 0, 1, 15000000, 0, 0, 0, 0),
(122, 446, 'Maxim_Gluschenko', 0, 1, 15000000, 2248.86, -1107.59, -0.644, 64.082),
(124, 446, 'Dima_Yastrub', 0, 1, 15000000, 0, 0, 0, 0),
(125, 446, 'Legenda_Feofilov', 0, 0, 15000000, 0, 0, 0, 0),
(126, 454, 'Artem_Bakaev', 3, 1, 60000000, 0, 0, 0, 0),
(127, 446, 'Genrix_Mallkov', 6, 1, 15000000, 1099.44, -2611.93, -0.452, 273.408),
(129, 446, 'Connor_Macgregor', 0, 1, 15000000, 2827.88, -2696.57, 1.248, 266.892),
(130, 446, 'Gleb_Kosihenkov', 0, 1, 15000000, 0, 0, 0, 0),
(131, 446, 'Denik_Tomsk', 0, 1, 15000000, 0, 0, 0, 0),
(132, 454, 'Sanches_Vinson', 3, 1, 60000000, 2222.86, -1105.62, 0.052, 186.41),
(133, 446, 'Artem_Levcenko', 0, 1, 15000000, 0, 0, 0, 0),
(134, 454, 'Mickey_MacDonald', 0, 1, 60000000, 0, 0, 0, 0),
(135, 446, 'Maksim_Shestakov', 0, 1, 15000000, 0, 0, 0, 0),
(136, 446, 'Joe_Macalister', 0, 1, 15000000, 2835.07, -1524.6, -0.522, 2),
(137, 446, 'Ivan_Franchakov', 0, 1, 15000000, 0, 0, 0, 0),
(138, 446, 'Sanya_Polk', 86, 1, 15000000, 0, 0, 0, 0),
(139, 446, 'Max_Luqwid', 0, 1, 15000000, 0, 0, 0, 0),
(140, 446, 'Slavik_Dublin', 3, 1, 15000000, 0, 0, 0, 0),
(141, 446, 'Artem_Krutov', 6, 1, 15000000, 2833.83, -1410.5, -0.529, 172.15),
(142, 454, 'Sergey_Rybakin', 123, 1, 60000000, 0, 0, 0, 0),
(144, 454, 'Ilya_Senev', 0, 1, 60000000, 0, 0, 0, 0),
(145, 454, 'Dima_Smot', 0, 1, 60000000, 0, 0, 0, 0),
(146, 454, 'lomah_gleb', 0, 1, 60000000, 0, 0, 0, 0),
(147, 446, 'Evgeny', 93, 1, 15000000, 0, 0, 0, 0),
(148, 446, 'Bamg_Toprl', 101, 1, 15000000, 0, 0, 0, 0),
(150, 454, 'Dimasik_Uldasev', 0, 1, 60000000, 2834.47, -1508.82, 0.038, 49.123),
(151, 446, 'Dima_Fominn', 0, 1, 15000000, 0, 0, 0, 0),
(153, 454, 'Kerill_Enth', 0, 1, 60000000, 0, 0, 0, 0),
(154, 454, 'View_Good', 0, 1, 60000000, 0, 0, 0, 0),
(155, 454, 'lomac_glent', 0, 1, 60000000, 0, 0, 0, 0),
(156, 446, 'Oleg_AsekkQ', 6, 1, 15000000, 1758.48, -1292.28, -0.622, 131.559),
(157, 446, 'MARKIYAN', 0, 1, 15000000, 0, 0, 0, 0),
(158, 454, 'Artshi_Hokag', 0, 1, 60000000, 0, 0, 0, 0),
(160, 446, 'Dmitry_Howar', 1, 1, 15000000, 2085, -1124.9, -0.644, 107.476),
(161, 454, 'Mister_Pavlik', 0, 1, 60000000, 0, 0, 0, 0),
(163, 446, 'Thomas_Delambo', 0, 1, 15000000, 0, 0, 0, 0),
(164, 454, 'Konstantin_Tureev', 0, 0, 60000000, 0, 0, 0, 0),
(165, 446, 'Bohdan_Martyn', 0, 1, 15000000, 0, 0, 0, 0),
(166, 454, 'Nikita_Dembrovskiy', 0, 1, 60000000, 0, 0, 0, 0),
(167, 454, 'Nik_Radek', 0, 1, 60000000, 0, 0, 0, 0);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `password` (`password`),
  ADD KEY `settings` (`settings`),
  ADD KEY `leader` (`leader`),
  ADD KEY `member` (`member`,`online`),
  ADD KEY `family` (`family`,`familyzam`),
  ADD KEY `online` (`online`,`family`),
  ADD KEY `name_2` (`name`,`member`,`online`),
  ADD KEY `name_3` (`name`,`leader`),
  ADD KEY `name_4` (`name`,`family`),
  ADD KEY `mail` (`mail`),
  ADD KEY `house_arend` (`house_arend`),
  ADD KEY `AllDonate` (`AllDonate`),
  ADD KEY `vip_time` (`vip_time`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `pVK` (`pVK`),
  ADD KEY `GiveCar` (`GiveCar`),
  ADD KEY `online_donatepay` (`online`,`donatepay`),
  ADD KEY `GiveCoin` (`GiveCoin`),
  ADD KEY `phonenumber` (`phonenumber`),
  ADD KEY `restore_hash` (`restore_hash`),
  ADD KEY `subfraction` (`subfraction`),
  ADD KEY `dmkills` (`dmkills`),
  ADD KEY `pGuard` (`pGuard`),
  ADD KEY `jail` (`jail`),
  ADD KEY `jailtime` (`jailtime`),
  ADD KEY `mute` (`mute`),
  ADD KEY `jailreason` (`jailreason`),
  ADD KEY `mutereason` (`mutereason`);

--
-- Индексы таблицы `accounts_accessories`
--
ALTER TABLE `accounts_accessories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`);

--
-- Индексы таблицы `accounts_online`
--
ALTER TABLE `accounts_online`
  ADD UNIQUE KEY `id` (`id`);

--
-- Индексы таблицы `actors`
--
ALTER TABLE `actors`
  ADD PRIMARY KEY (`actor_id`);

--
-- Индексы таблицы `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`name`);

--
-- Индексы таблицы `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `bank_accounts`
--
ALTER TABLE `bank_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`);

--
-- Индексы таблицы `bank_accounts_logs`
--
ALTER TABLE `bank_accounts_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account` (`account`);

--
-- Индексы таблицы `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`name`);

--
-- Индексы таблицы `bizz`
--
ALTER TABLE `bizz`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`);

--
-- Индексы таблицы `buy_packages`
--
ALTER TABLE `buy_packages`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `family_cars`
--
ALTER TABLE `family_cars`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `family_system`
--
ALTER TABLE `family_system`
  ADD PRIMARY KEY (`fam_id`);

--
-- Индексы таблицы `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`Num`);

--
-- Индексы таблицы `frakrang`
--
ALTER TABLE `frakrang`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`),
  ADD KEY `login` (`login`);

--
-- Индексы таблицы `fullaccess`
--
ALTER TABLE `fullaccess`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gangzone`
--
ALTER TABLE `gangzone`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `garages`
--
ALTER TABLE `garages`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gifts`
--
ALTER TABLE `gifts`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `helicopters`
--
ALTER TABLE `helicopters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `h_owner` (`h_owner`);

--
-- Индексы таблицы `historyban`
--
ALTER TABLE `historyban`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`);

--
-- Индексы таблицы `historyname`
--
ALTER TABLE `historyname`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `hitman`
--
ALTER TABLE `hitman`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hOwner` (`hOwner`),
  ADD KEY `hOwned` (`hOwned`);

--
-- Индексы таблицы `inventory`
--
ALTER TABLE `inventory`
  ADD KEY `Name` (`Name`);

--
-- Индексы таблицы `nlogs`
--
ALTER TABLE `nlogs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `objects`
--
ALTER TABLE `objects`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ownable_cars`
--
ALTER TABLE `ownable_cars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `c_owner` (`c_owner`),
  ADD KEY `c_number` (`c_number`),
  ADD KEY `c_status` (`c_status`),
  ADD KEY `c_owner_2` (`c_owner`,`c_status`),
  ADD KEY `id_2` (`id`,`c_owner`);

--
-- Индексы таблицы `ownable_numbers`
--
ALTER TABLE `ownable_numbers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `number` (`number`),
  ADD KEY `is_used` (`is_used`);

--
-- Индексы таблицы `pickup_data`
--
ALTER TABLE `pickup_data`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `player_promocode`
--
ALTER TABLE `player_promocode`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `podezd`
--
ALTER TABLE `podezd`
  ADD PRIMARY KEY (`idpodezd`);

--
-- Индексы таблицы `promocode`
--
ALTER TABLE `promocode`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `radar`
--
ALTER TABLE `radar`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rOwner` (`rOwner`);

--
-- Индексы таблицы `serialbans`
--
ALTER TABLE `serialbans`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `t_warn_logs`
--
ALTER TABLE `t_warn_logs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `yacht`
--
ALTER TABLE `yacht`
  ADD PRIMARY KEY (`id`),
  ADD KEY `y_owner` (`y_owner`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `accounts_accessories`
--
ALTER TABLE `accounts_accessories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `atm`
--
ALTER TABLE `atm`
  MODIFY `ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `bank_accounts_logs`
--
ALTER TABLE `bank_accounts_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `bizz`
--
ALTER TABLE `bizz`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT для таблицы `buy_packages`
--
ALTER TABLE `buy_packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `family_cars`
--
ALTER TABLE `family_cars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=243;

--
-- AUTO_INCREMENT для таблицы `family_system`
--
ALTER TABLE `family_system`
  MODIFY `fam_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT для таблицы `fines`
--
ALTER TABLE `fines`
  MODIFY `Num` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `frakrang`
--
ALTER TABLE `frakrang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `fullaccess`
--
ALTER TABLE `fullaccess`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `gangzone`
--
ALTER TABLE `gangzone`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT для таблицы `garages`
--
ALTER TABLE `garages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT для таблицы `gifts`
--
ALTER TABLE `gifts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `helicopters`
--
ALTER TABLE `helicopters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1006;

--
-- AUTO_INCREMENT для таблицы `historyban`
--
ALTER TABLE `historyban`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `historyname`
--
ALTER TABLE `historyname`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `hitman`
--
ALTER TABLE `hitman`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT для таблицы `house`
--
ALTER TABLE `house`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT для таблицы `nlogs`
--
ALTER TABLE `nlogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=183;

--
-- AUTO_INCREMENT для таблицы `objects`
--
ALTER TABLE `objects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT для таблицы `ownable_cars`
--
ALTER TABLE `ownable_cars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `ownable_numbers`
--
ALTER TABLE `ownable_numbers`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `pickup_data`
--
ALTER TABLE `pickup_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `player_promocode`
--
ALTER TABLE `player_promocode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `podezd`
--
ALTER TABLE `podezd`
  MODIFY `idpodezd` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=237;

--
-- AUTO_INCREMENT для таблицы `promocode`
--
ALTER TABLE `promocode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT для таблицы `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `serialbans`
--
ALTER TABLE `serialbans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `t_warn_logs`
--
ALTER TABLE `t_warn_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT для таблицы `yacht`
--
ALTER TABLE `yacht`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
