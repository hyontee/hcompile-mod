-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Фев 03 2024 г., 01:14
-- Версия сервера: 10.5.21-MariaDB-0+deb11u1
-- Версия PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gs21732`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE `accounts` (
  `pID` int(11) NOT NULL,
  `Name` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL,
  `pKey` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT 'NULL',
  `pLevel` int(11) NOT NULL DEFAULT 1,
  `pJail` int(11) NOT NULL DEFAULT 0,
  `pvIp` varchar(17) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT 'no',
  `youtube` int(11) NOT NULL DEFAULT 0,
  `pIpReg` varchar(17) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL,
  `pDataReg` varchar(128) CHARACTER SET cp1250 COLLATE cp1250_bin NOT NULL,
  `pKeyip` varchar(5) NOT NULL DEFAULT '-',
  `pHP` float NOT NULL DEFAULT 100,
  `house` int(11) NOT NULL DEFAULT 0,
  `tempkey` int(11) NOT NULL DEFAULT 0,
  `bussiness` int(11) NOT NULL DEFAULT 0,
  `hotelid` int(11) NOT NULL DEFAULT 0,
  `airport` int(11) NOT NULL DEFAULT 0,
  `hotelroom` int(11) NOT NULL DEFAULT 0,
  `plane` int(11) NOT NULL DEFAULT -1,
  `pMats` int(11) NOT NULL DEFAULT 0,
  `pSex` int(11) NOT NULL,
  `pArrested` int(11) NOT NULL DEFAULT 0,
  `mute` int(11) NOT NULL DEFAULT 0,
  `pCrimes` int(11) NOT NULL DEFAULT 0,
  `pExp` int(11) NOT NULL DEFAULT 0,
  `pCash` int(11) NOT NULL DEFAULT 2000,
  `pJailTime` int(11) NOT NULL DEFAULT 0,
  `pDrugs` int(11) NOT NULL DEFAULT 0,
  `pLeader` int(11) NOT NULL DEFAULT 0,
  `pMember` int(11) NOT NULL DEFAULT 0,
  `pRank` int(11) NOT NULL DEFAULT 0,
  `pJob` int(11) NOT NULL DEFAULT 0,
  `pModel` int(11) NOT NULL DEFAULT 0,
  `pPhone` int(11) NOT NULL DEFAULT 0,
  `licenses` varchar(64) NOT NULL DEFAULT '0,0,0,0',
  `pZakonp` int(11) NOT NULL DEFAULT 0,
  `pAddiction` int(11) NOT NULL DEFAULT 0,
  `pWarns` int(11) NOT NULL DEFAULT 0,
  `warntime` int(11) NOT NULL DEFAULT 0,
  `pFuel` int(11) NOT NULL DEFAULT 0,
  `pMarried` varchar(25) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT '-',
  `pDrug` varchar(128) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT '-',
  `pBank` int(11) NOT NULL DEFAULT 0,
  `pMobile` int(11) NOT NULL DEFAULT 0,
  `pSearch` int(11) NOT NULL DEFAULT 0,
  `pWeapons` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `pAmmos` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `pGunSkills` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT '0, 0, 0, 0, 0, 0',
  `pOnline` varchar(128) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT '0',
  `pEmail` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT 'no',
  `Skin` int(5) NOT NULL DEFAULT 1,
  `pPlayTime_one` int(11) NOT NULL DEFAULT 0,
  `pPlayTime_two` int(11) NOT NULL DEFAULT 0,
  `pAccusedof` varchar(50) NOT NULL DEFAULT 'Нет',
  `pVictim` varchar(24) NOT NULL DEFAULT 'Нет',
  `kill_capture` int(11) NOT NULL DEFAULT 0,
  `pHospital` int(3) NOT NULL DEFAULT 0,
  `pRod` int(11) NOT NULL DEFAULT 0,
  `pRopes` int(11) NOT NULL DEFAULT 0,
  `pWorms` int(11) NOT NULL DEFAULT 0,
  `pFish` float NOT NULL DEFAULT 0,
  `family` int(11) NOT NULL DEFAULT 0,
  `progress` int(11) NOT NULL DEFAULT 0,
  `spawn` int(3) NOT NULL DEFAULT 0,
  `salary` int(11) NOT NULL DEFAULT 0,
  `book` int(3) NOT NULL DEFAULT 0,
  `watch` int(3) NOT NULL DEFAULT 0,
  `phonenumber` varchar(256) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `phonename` varchar(1024) NOT NULL DEFAULT ' Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет',
  `MedCard` int(4) NOT NULL DEFAULT 0,
  `MedHeal` int(11) NOT NULL DEFAULT 0,
  `Advert` int(11) NOT NULL DEFAULT 0,
  `ArmSkin` int(3) NOT NULL DEFAULT 0,
  `FracDuty` int(4) NOT NULL DEFAULT 0,
  `Settings` varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1|1|0|0|0|0|0|0|0|1',
  `online_status` int(11) NOT NULL DEFAULT 0,
  `GoogleCode` varchar(50) DEFAULT NULL,
  `SecretCode` varchar(50) DEFAULT NULL,
  `bizz_work` int(11) NOT NULL DEFAULT 0,
  `bizz_cash` int(11) NOT NULL DEFAULT 0,
  `bizz_lcash` int(11) NOT NULL DEFAULT 0,
  `bizz_status` int(11) NOT NULL DEFAULT 0,
  `pGolos` int(11) NOT NULL DEFAULT 0,
  `pBlago` int(11) NOT NULL DEFAULT 0,
  `pVips` int(11) NOT NULL DEFAULT 0,
  `donatemoney` int(30) NOT NULL DEFAULT 0,
  `fwarn` int(11) NOT NULL DEFAULT 0,
  `pDisease_0` int(11) NOT NULL DEFAULT 0,
  `pDisease_1` int(11) NOT NULL DEFAULT 0,
  `pSatiety` int(11) NOT NULL DEFAULT 100,
  `pKills` int(11) NOT NULL DEFAULT 0,
  `pWinArea` int(11) NOT NULL DEFAULT 0,
  `pFamRank` int(11) NOT NULL DEFAULT 0,
  `pDSatiety` int(11) NOT NULL DEFAULT 0,
  `pDDisease` int(11) NOT NULL DEFAULT 0,
  `pBox` int(11) NOT NULL DEFAULT 0,
  `pSnow` float NOT NULL DEFAULT 0,
  `pMedKit` int(11) NOT NULL DEFAULT 0,
  `pMPromo` int(11) NOT NULL DEFAULT 0,
  `pAdmMSG` int(11) NOT NULL DEFAULT 0,
  `pAdmKL` int(11) NOT NULL DEFAULT 0,
  `pMask` int(11) NOT NULL DEFAULT 0,
  `pGoogle` int(11) NOT NULL DEFAULT 0,
  `homesell` int(11) NOT NULL DEFAULT 0,
  `bizzsell` int(11) NOT NULL DEFAULT 0,
  `hotelsell` int(11) NOT NULL DEFAULT 0,
  `airsell` int(11) NOT NULL DEFAULT 0,
  `roomsell` int(11) NOT NULL DEFAULT 0,
  `pVipadd` int(11) NOT NULL DEFAULT 0,
  `lotteryfree` int(11) NOT NULL DEFAULT 0,
  `GunLic` int(11) NOT NULL DEFAULT 0,
  `drunginv` int(11) NOT NULL DEFAULT 0,
  `pHelper` int(11) NOT NULL DEFAULT 0,
  `pAsk` int(11) NOT NULL DEFAULT 0,
  `pSlotItem` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `pSlotItem_Use` varchar(64) NOT NULL DEFAULT '1|1|1|1|1|1|1|1',
  `pInstr` int(5) NOT NULL DEFAULT 0,
  `fraction_date` varchar(64) NOT NULL DEFAULT '0/0/0',
  `pAskmute` int(11) NOT NULL DEFAULT 0,
  `pJemmy` int(11) NOT NULL DEFAULT 0,
  `EmailStatus` int(1) NOT NULL DEFAULT 2,
  `pFMute` int(4) NOT NULL DEFAULT 0,
  `theftSkill` int(3) NOT NULL DEFAULT 0,
  `theftExp` int(5) NOT NULL DEFAULT 0,
  `theftTime` int(11) NOT NULL DEFAULT 0,
  `theftHome` int(11) NOT NULL DEFAULT 0,
  `pDonateBank` int(1) NOT NULL DEFAULT 0,
  `pDonateBh` int(1) NOT NULL DEFAULT 0,
  `pVipTime` int(11) NOT NULL DEFAULT 0,
  `pVipName` int(11) NOT NULL DEFAULT 0,
  `pBoomBox` int(11) NOT NULL DEFAULT 0,
  `Akum` int(12) NOT NULL DEFAULT 0,
  `prefix` varchar(64) NOT NULL,
  `spawnData` varchar(64) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `accounts`
--

INSERT INTO `accounts` (`pID`, `Name`, `pKey`, `pLevel`, `pJail`, `pvIp`, `youtube`, `pIpReg`, `pDataReg`, `pKeyip`, `pHP`, `house`, `tempkey`, `bussiness`, `hotelid`, `airport`, `hotelroom`, `plane`, `pMats`, `pSex`, `pArrested`, `mute`, `pCrimes`, `pExp`, `pCash`, `pJailTime`, `pDrugs`, `pLeader`, `pMember`, `pRank`, `pJob`, `pModel`, `pPhone`, `licenses`, `pZakonp`, `pAddiction`, `pWarns`, `warntime`, `pFuel`, `pMarried`, `pDrug`, `pBank`, `pMobile`, `pSearch`, `pWeapons`, `pAmmos`, `pGunSkills`, `pOnline`, `pEmail`, `Skin`, `pPlayTime_one`, `pPlayTime_two`, `pAccusedof`, `pVictim`, `kill_capture`, `pHospital`, `pRod`, `pRopes`, `pWorms`, `pFish`, `family`, `progress`, `spawn`, `salary`, `book`, `watch`, `phonenumber`, `phonename`, `MedCard`, `MedHeal`, `Advert`, `ArmSkin`, `FracDuty`, `Settings`, `online_status`, `GoogleCode`, `SecretCode`, `bizz_work`, `bizz_cash`, `bizz_lcash`, `bizz_status`, `pGolos`, `pBlago`, `pVips`, `donatemoney`, `fwarn`, `pDisease_0`, `pDisease_1`, `pSatiety`, `pKills`, `pWinArea`, `pFamRank`, `pDSatiety`, `pDDisease`, `pBox`, `pSnow`, `pMedKit`, `pMPromo`, `pAdmMSG`, `pAdmKL`, `pMask`, `pGoogle`, `homesell`, `bizzsell`, `hotelsell`, `airsell`, `roomsell`, `pVipadd`, `lotteryfree`, `GunLic`, `drunginv`, `pHelper`, `pAsk`, `pSlotItem`, `pSlotItem_Use`, `pInstr`, `fraction_date`, `pAskmute`, `pJemmy`, `EmailStatus`, `pFMute`, `theftSkill`, `theftExp`, `theftTime`, `theftHome`, `pDonateBank`, `pDonateBh`, `pVipTime`, `pVipName`, `pBoomBox`, `Akum`, `prefix`, `spawnData`) VALUES
(1, 'Klaus_Gurren', 'ea58bdba4507b20cef448e7c830f98aa', 15, 0, '146.120.175.183', 1, '146.120.175.220', '27/04/2023', '-', 101, 0, 0, 2, 0, 0, 0, -1, 0, 2, 0, 0, 0, 12, 2014329, 0, 0, 0, 0, 0, 0, 0, 0, '1,0,0,0', 8, 0, 0, 0, 0, '-', '-', 797360, 0, 0, '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, ', '03-02-2024', 'no', 49, 20, 163, 'Нет', 'Нет', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', ' Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет', 1, 0, 0, 0, 0, '1|1|0|0|0|0|1|0|0|1|48', 1001, NULL, NULL, 0, 0, 0, 0, 0, 666666, 0, 4400, 0, 0, 0, 100, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1, 0, 0, '18950|19006|0|18915|0|371|0|19045', '1|1|1|1|1|1|1|1', 0, '2023-05-10 21:38:04', 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 'триста', '1500.22,691.76,10.82,185.76');

-- --------------------------------------------------------

--
-- Структура таблицы `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `Name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `rank` int(2) NOT NULL,
  `password` varchar(32) NOT NULL DEFAULT 'qwerty',
  `online_connection` datetime DEFAULT NULL,
  `date_start` datetime DEFAULT NULL,
  `kick` int(11) DEFAULT 0,
  `ban` int(11) NOT NULL DEFAULT 0,
  `mute` int(11) NOT NULL DEFAULT 0,
  `pm` int(11) NOT NULL DEFAULT 0,
  `warn` int(11) NOT NULL DEFAULT 0,
  `jail` int(11) NOT NULL DEFAULT 0,
  `vig` int(11) NOT NULL DEFAULT 0,
  `blockadmin` int(11) NOT NULL DEFAULT 0,
  `rep` int(11) NOT NULL DEFAULT 0,
  `online_status` int(1) NOT NULL DEFAULT 0,
  `online_monday` int(11) NOT NULL DEFAULT 0,
  `online_tuesday` int(11) NOT NULL DEFAULT 0,
  `online_wednesday` int(11) NOT NULL DEFAULT 0,
  `online_thursday` int(11) NOT NULL DEFAULT 0,
  `online_friday` int(11) NOT NULL DEFAULT 0,
  `online_saturday` int(11) NOT NULL DEFAULT 0,
  `online_sunday` int(11) NOT NULL DEFAULT 0,
  `CheckName` varchar(32) NOT NULL DEFAULT 'Oscar_Floyd'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `admin`
--

INSERT INTO `admin` (`id`, `Name`, `rank`, `password`, `online_connection`, `date_start`, `kick`, `ban`, `mute`, `pm`, `warn`, `jail`, `vig`, `blockadmin`, `rep`, `online_status`, `online_monday`, `online_tuesday`, `online_wednesday`, `online_thursday`, `online_friday`, `online_saturday`, `online_sunday`, `CheckName`) VALUES
(1, 'Klaus_Gurren', 7, '', '2024-02-03 01:11:39', NULL, 7, 21, 2, 304, 4, 1, 0, 0, 186, 0, 4909, 5858, 5556, 1940, 9094, 9717, 6734, 'Klaus_Gurren');

-- --------------------------------------------------------

--
-- Структура таблицы `adminlog`
--

CREATE TABLE `adminlog` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` int(11) NOT NULL,
  `Name` varchar(25) NOT NULL,
  `NamePlayer` varchar(25) NOT NULL,
  `reason` varchar(140) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `adminlog`
--

INSERT INTO `adminlog` (`id`, `type`, `Name`, `NamePlayer`, `reason`, `date`, `time`) VALUES
(1, 12, 'Klaus_Gurren', 'Klaus_Gurren', '@', '2023-05-05', '19:32:32'),
(2, 12, 'Klaus_Gurren', 'Klaus_Gurren', '@', '2023-05-05', '20:39:02'),
(3, 12, 'Klaus_Gurren', 'Klaus_Gurren', '1', '2023-05-07', '14:46:49'),
(4, 12, 'Klaus_Gurren', 'Klaus_Gurren', '0', '2023-05-07', '14:53:49'),
(5, 12, 'Klaus_Gurren', 'Klaus_Gurren', 'p', '2023-05-07', '22:24:28'),
(6, 14, 'Klaus_Gurren', 'Klaus_Gurren', 'Видача зброї', '2023-05-09', '21:52:55'),
(7, 14, 'Klaus_Gurren', 'Klaus_Gurren', 'Видача зброї', '2023-05-09', '21:53:07'),
(8, 12, 'Klaus_Gurren', 'Klaus_Gurren', '0', '2023-05-09', '22:15:18');

-- --------------------------------------------------------

--
-- Структура таблицы `adradio`
--

CREATE TABLE `adradio` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `text` varchar(60) NOT NULL,
  `date` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `airports`
--

CREATE TABLE `airports` (
  `id` int(11) NOT NULL,
  `name` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL,
  `ownerid` int(11) NOT NULL,
  `owner` varchar(25) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL,
  `price` int(11) NOT NULL,
  `coast` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `day` int(11) NOT NULL DEFAULT 0,
  `bankday` int(11) NOT NULL DEFAULT 0,
  `bank` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `airports`
--

INSERT INTO `airports` (`id`, `name`, `ownerid`, `owner`, `price`, `coast`, `x`, `y`, `z`, `day`, `bankday`, `bank`) VALUES
(1, 'Los Santos Airport', 0, '', 3500000, 150990, 1892.28, -2328.7, 13.5469, 1587377326, 0, 0),
(2, 'San Fierro Airport', 0, '', 3500000, 120000, -1263.02, 41.1666, 14.1391, 1541861999, 0, 0),
(3, 'Las Venturas Airport', 0, '', 3500000, 120000, 1673.2, 1447.77, 10.7862, 1542236576, 0, 360000);

-- --------------------------------------------------------

--
-- Структура таблицы `anticheats`
--

CREATE TABLE `anticheats` (
  `chID` int(11) NOT NULL,
  `cheatname` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `cheatvalue` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Дамп данных таблицы `anticheats`
--

INSERT INTO `anticheats` (`chID`, `cheatname`, `cheatvalue`) VALUES
(1, 'Air Break - Пешком', 0),
(2, 'Air Break - В машине', 0),
(3, 'Телепорт - Пешком', 1),
(4, 'Телепорт - В машине', 1),
(5, 'Телепорт (into/between vehicles)', 1),
(6, 'Телепорт (vehicle to player)', 1),
(7, 'Телепорт (pickups)', 1),
(8, 'Fly Hack - Пешком', 1),
(9, 'Fly Hack - В машине', 1),
(10, 'Speed Hack - Пешком', 1),
(11, 'Speed Hack - В машине', 1),
(12, 'Восстановление здоровья - Veh', 1),
(13, 'Восстановление здоровья - Foot', 1),
(14, 'Восстановление брони', 1),
(15, 'Чит на деньги', 1),
(16, 'Чит на оружие', 1),
(17, 'Чит на патроны', 1),
(18, 'Чит на бесконечные патроны', 1),
(19, 'Специальные анимации', 1),
(20, 'God Mode - Пешком', 1),
(21, 'God Mode - В машине', 1),
(22, 'Невидимка', 1),
(23, 'LagComp Spoof', 1),
(24, 'Чит на тюнинг', 1),
(25, 'Паркур мод', 1),
(26, 'Быстрый разворот', 1),
(27, 'Ускоренная стрельба', 1),
(28, 'Ложный Спавн', 2),
(29, 'Ложная смерть', 1),
(30, 'Pro Aim', 1),
(31, 'Бег CJ', 1),
(32, 'Car Shot', 1),
(33, 'Антивыкидывание из транспорта', 1),
(34, 'Антифриз', 1),
(35, 'Ghost Hack', 1),
(36, 'Silent Aim', 1),
(37, 'Ракбот', 1),
(38, 'Быстрый реконнект', 1),
(39, 'Высокий пинг', 1),
(40, 'Подмена диалога', 1),
(41, 'Песочница', 1),
(42, 'Неверная версия', 1),
(43, 'Ркон авторизация', 1),
(44, 'Тюнинг крашер', 1),
(45, 'Крашер неверной посадки', 1),
(46, 'Дилог крашер', 1),
(47, 'Attach крашер', 1),
(48, 'Weapon крашер', 1),
(49, 'Подключение в 1 слот', 1),
(50, 'Флуд функциями', 1),
(51, 'Флуд смен позиции', 2),
(52, 'DDoS', 1),
(53, 'Игнорирование функции', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `atms`
--

CREATE TABLE `atms` (
  `ID` int(10) UNSIGNED NOT NULL,
  `atmID` int(11) NOT NULL,
  `ATM_X` float(12,6) NOT NULL,
  `ATM_Y` float(12,6) NOT NULL,
  `ATM_Z` float(12,6) NOT NULL,
  `ATM_ROTX` float(12,6) NOT NULL,
  `ATM_ROTY` float(12,6) NOT NULL,
  `ATM_ROTZ` float(12,6) NOT NULL,
  `ATM_VW` tinyint(4) NOT NULL,
  `ATM_INT` int(11) NOT NULL,
  `ATM_BANK` int(11) NOT NULL DEFAULT 0,
  `ATM_BANKTIME` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `atms`
--

INSERT INTO `atms` (`ID`, `atmID`, `ATM_X`, `ATM_Y`, `ATM_Z`, `ATM_ROTX`, `ATM_ROTY`, `ATM_ROTZ`, `ATM_VW`, `ATM_INT`, `ATM_BANK`, `ATM_BANKTIME`) VALUES
(1, 1, 2851.579590, 1316.570068, 11.209740, 0.000000, 0.000000, -1.920699, 0, 0, 0, 0),
(2, 2, 1979.606445, -2036.451294, 13.510827, 0.000000, 0.000000, 179.447922, 0, 0, 0, 0),
(3, 3, 1751.003662, -1898.520508, 13.402476, 0.000000, 0.000000, 179.294662, 0, 0, 0, 0),
(4, 4, -1977.197388, 115.748726, 27.484739, 0.000000, 0.000000, -91.177917, 0, 0, 0, 0),
(5, 5, 1465.753662, -1750.393066, 15.262108, -0.100002, 0.000000, -89.878761, 0, 0, 0, 0),
(6, 6, 736.604553, -1379.633667, 14.100235, 0.000000, 0.000000, 178.117813, 0, 0, 0, 0),
(7, 7, 2171.284424, 2163.414062, 10.600300, 0.000000, 0.000000, 89.806740, 0, 0, 0, 0),
(8, 8, 1921.307129, -1766.369995, 13.346862, 0.000000, 0.000000, -89.738342, 0, 0, 0, 0),
(9, 9, 1393.306030, -11.028458, 1000.658508, 0.000000, 0.000000, -179.965759, -1, 15, 0, 0),
(10, 10, 541.228699, -1294.438354, 16.962181, 0.000000, 0.000000, -90.188210, 0, 0, 0, 0),
(11, 11, -1966.686768, 296.300507, 35.031902, 0.000000, 0.000000, 0.171264, 0, 0, 0, 0),
(12, 12, 2205.084473, 1395.306519, 10.880314, 0.000000, 0.000000, 88.657448, 0, 0, 0, 0),
(13, 13, 2129.429688, -1152.487549, 23.736387, 0.000000, 0.000000, -14.760539, 0, 0, 0, 0),
(14, 14, -310.136322, 1052.430420, 20.103052, 0.000000, 0.000000, -0.442153, 0, 0, 0, 0),
(15, 15, 169.326736, -152.081711, 1.358125, 0.000000, 0.000000, -90.726097, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `ban`
--

CREATE TABLE `ban` (
  `ID` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL,
  `Admin` varchar(24) NOT NULL,
  `Reason` varchar(100) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `Seconds` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `banip`
--

CREATE TABLE `banip` (
  `id` int(10) UNSIGNED NOT NULL,
  `IP` varchar(16) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `admin` varchar(25) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `bank`
--

CREATE TABLE `bank` (
  `name` varchar(64) NOT NULL,
  `number` int(5) NOT NULL,
  `owner` varchar(24) NOT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `code` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `billboards`
--

CREATE TABLE `billboards` (
  `newid` int(10) UNSIGNED NOT NULL,
  `id` int(11) NOT NULL,
  `bModel` int(11) NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `PosA` float NOT NULL,
  `bText` varchar(144) NOT NULL,
  `bPosText` varchar(32) NOT NULL,
  `bOwner` varchar(24) NOT NULL,
  `bOwned` int(11) NOT NULL DEFAULT 0,
  `bBackColor` int(11) NOT NULL,
  `bFontFace` int(11) NOT NULL,
  `bAligment` int(11) NOT NULL,
  `bFontSize` int(11) NOT NULL,
  `bDay` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `billboards`
--

INSERT INTO `billboards` (`newid`, `id`, `bModel`, `PosX`, `PosY`, `PosZ`, `PosA`, `bText`, `bPosText`, `bOwner`, `bOwned`, `bBackColor`, `bFontFace`, `bAligment`, `bFontSize`, `bDay`) VALUES
(1, 0, 7910, 1415.3, -1719.9, 33.8, 137.5, '-', 'Билборд №1', '-', 0, 1, 0, 1, 25, 0),
(2, 1, 7910, 1716.4, -782.2, 73.6, 346.247, '-', 'Билборд №2', '-', 0, 1, 0, 1, 25, 0),
(3, 2, 7910, 1623.1, 820.7, 27.5, 238, '-', 'Билборд №3', '-', 0, 1, 0, 1, 25, 0),
(4, 3, 4238, 1786.5, 1476, 26.1, 32, '-', 'Билборд №4', '-', 0, 1, 0, 1, 25, 0),
(5, 4, 4238, 356.4, -1718.1, 26.6, 300, '-', 'Билборд №5', '-', 0, 1, 0, 1, 25, 0),
(6, 5, 7910, 1497.1, -945, 54.1, 112.998, '-', 'Билборд №6', '-', 0, 1, 0, 1, 25, 0),
(7, 6, 7910, 1716.7, -778.3, 73.6, 180.75, '-', 'Билборд №7', '-', 0, 1, 0, 1, 25, 0),
(8, 7, 7910, 1777.5, 888, 29.9, 127.748, '-', 'Билборд №8', '-', 0, 1, 0, 1, 25, 0),
(9, 8, 7910, 1854.6, -1487.7, 25.8, 180, '-', 'Билборд №9', '-', 0, 1, 0, 1, 25, 0),
(10, 9, 4238, 1353.9, -1713.6, 26, 120, '-', 'Билборд №10', '-', 0, 1, 0, 1, 25, 0),
(11, 10, 4238, 734.5, -1102.2, 33.4, 180.25, '-', 'Билборд №11', '-', 0, 1, 0, 1, 25, 0),
(12, 11, 7910, 1242.9, 1089.8, 27.6, 159.745, '-', 'Билборд №12', '-', 0, 1, 0, 1, 25, 0),
(13, 12, 7910, 811.5, -1164.8, 37.4, 307.5, '-', 'Билборд №13', '-', 0, 1, 0, 1, 25, 0),
(14, 13, 7910, 1406.44, -1407.05, 34.2147, -96.7, '-', 'Билборд №14', '-', 0, 1, 0, 1, 25, 0),
(15, 14, 7910, 1412.6, -1724.2, 33.8, 331.999, '-', 'Билборд №15', '-', 0, 1, 0, 1, 25, 0),
(16, 15, 7910, 2128.6, -1782.4, 29.9, 270, '-', 'Билборд №16', '-', 0, 1, 0, 1, 25, 0),
(17, 16, 7910, 1863.5, -1450.7, 31.7, 38.248, '-', 'Билборд №17', '-', 0, 1, 0, 1, 25, 0),
(18, 17, 7910, 1629.7, -839, 77, 132.25, '-', 'Билборд №18', '-', 0, 1, 0, 1, 25, 0),
(19, 18, 7909, 219.8, -1434.3, 31, 0.25, '-', 'Билборд №19', '-', 0, 1, 0, 1, 25, 0),
(20, 19, 4238, 704, -1115.6, 32.2, 5, '-', 'Билборд №20', '-', 0, 1, 0, 1, 25, 0),
(21, 20, 7910, 1673.1, -711.1, 69, 187.5, '-', 'Билборд №21', '-', 0, 1, 0, 1, 25, 0),
(22, 21, 7909, 2066.8, -1790.3, 28, 90.5, '-', 'Билборд №22', '-', 0, 1, 0, 1, 25, 0),
(23, 22, 4238, 1007.4, 1314.6, 30.8, 29.25, '-', 'Билборд №23', '-', 0, 1, 0, 1, 25, 0),
(24, 23, 7910, 1240.9, 1086.9, 27.6, 323.75, '-', 'Билборд №24', '-', 0, 1, 0, 1, 25, 0),
(25, 24, 7910, 1493.6, -946.3, 54, 278, '-', 'Билборд №25', '-', 0, 1, 0, 1, 25, 0),
(26, 25, 4238, 516.6, -1725.9, 31.4, 112, '-', 'Билборд №26', '-', 0, 1, 0, 1, 25, 0),
(27, 26, 4238, 1786.9, 1075.9, 26.8, 31.25, '-', 'Билборд №27', '-', 0, 1, 0, 1, 25, 0),
(28, 27, 4238, 1805.1, -1691.5, 30.8, 175.25, '-', 'Билборд №28', '-', 0, 1, 0, 1, 25, 0),
(29, 28, 4238, 597.7, -1744.4, 33.2, 290, '-', 'Билборд №29', '-', 0, 1, 0, 1, 25, 0),
(30, 29, 7910, 1775, 885.3, 29.9, 324, '-', 'Билборд №30', '-', 0, 1, 0, 1, 25, 0),
(31, 30, 7909, 1963.8, -1522.7, 24.6, 90.25, '-', 'Билборд №31', '-', 0, 1, 0, 1, 25, 0),
(32, 31, 7910, 1628.7, -841.9, 77, 326.998, '-', 'Билборд №32', '-', 0, 1, 0, 1, 25, 0),
(33, 32, 7910, 1861.6, -1448, 31.7, 233, '-', 'Билборд №33', '-', 0, 1, 0, 1, 25, 0),
(34, 33, 4238, 1565.3, -1722.5, 31.1967, 34.75, '-', 'Билборд №34', '-', 0, 1, 0, 1, 25, 0),
(35, 34, 7910, 1627.1, 819.5, 27.5, 73.4968, '-', 'Билборд №35', '-', 0, 1, 0, 1, 25, 0),
(36, 35, 7910, 1673.5, -714.1, 69, 22.2482, '-', 'Билборд №36', '-', 0, 1, 0, 1, 25, 0),
(37, 36, 4238, 1538.5, -1609.8, 26, 300, '-', 'Билборд №37', '-', 0, 1, 0, 1, 25, 0),
(38, 37, 7909, 885.1, -971.3, 54.4, 117.75, '-', 'Билборд №38', '-', 0, 1, 0, 1, 25, 0),
(39, 38, 4238, 1427.2, -1138.9, 34.8, 299.745, '-', 'Билборд №39', '-', 0, 1, 0, 1, 25, 0),
(40, 39, 4736, 1403.6, -1309.1, 43.2, 359.75, '-', 'Билборд №40', '-', 0, 1, 0, 1, 25, 0),
(41, 40, 7910, 563.3, -1255.6, 28, 115.25, '-', 'Билборд №41', '-', 0, 1, 0, 1, 25, 0),
(42, 41, 4729, 1850.6, -1051, 34.8, 0, '-', 'Билборд №42', '-', 0, 1, 0, 1, 25, 0),
(43, 42, 7910, 1936.3, -2140.9, 25.2, 77, '-', 'Билборд №43', '-', 0, 1, 0, 1, 25, 0),
(44, 43, 7910, 2029.3, -1763.5, 34.9, 180, '-', 'Билборд №44', '-', 0, 1, 0, 1, 25, 0),
(45, 44, 7910, 1839.6, -1837.2, 24.7, 179.75, '-', 'Билборд №45', '-', 0, 1, 0, 1, 25, 0),
(46, 45, 4729, 799.3, -917.2, 61, 235, '-', 'Билборд №46', '-', 0, 1, 0, 1, 25, 0),
(47, 46, 4729, 1751.6, -1483.6, 30, 329.75, '-', 'Билборд №47', '-', 0, 1, 0, 1, 25, 0),
(48, 47, 7910, 1031, -2075.2, 21.7, 170.25, '-', 'Билборд №48', '-', 0, 1, 0, 1, 25, 0),
(49, 48, 4238, 400.2, -1752.8, 23, 31, '-', 'Билборд №49', '-', 0, 1, 0, 1, 25, 0),
(50, 49, 7910, 619.1, -1297.1, 33.8, 77.5, '-', 'Билборд №50', '-', 0, 1, 0, 1, 25, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `bints`
--

CREATE TABLE `bints` (
  `id` int(4) NOT NULL,
  `interior` int(2) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `r` float NOT NULL,
  `xb` float NOT NULL,
  `yb` float NOT NULL,
  `zb` float NOT NULL,
  `name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;

--
-- Дамп данных таблицы `bints`
--

INSERT INTO `bints` (`id`, `interior`, `x`, `y`, `z`, `r`, `xb`, `yb`, `zb`, `name`) VALUES
(1, 3, 1212.11, -25.8792, 1000.95, 180.26, 1207.25, -30.8732, 1000.95, 'Бар 1 | Big SR'),
(2, 2, 1204.89, -13.8464, 1000.92, 356.029, 1216.01, -13.3525, 1000.92, 'Бар 2 | Pig Pen'),
(3, 18, -229.292, 1401.32, 27.7656, 271.5, -224.782, 1403.8, 27.7734, 'Бар 3 | LPL'),
(4, 11, 501.784, -67.8887, 998.758, 177.288, 494.407, -76.0353, 998.758, 'Бар 4 | Bike'),
(5, 5, 227.299, -8.1967, 1002.21, 94.338, 209.83, -8.2969, 1005.21, 'SkinShop | 1'),
(6, 1, 203.699, -50.653, 1001.8, 356.89, 209.468, -33.8782, 1001.93, 'SkinShop | 2'),
(7, 18, 161.442, -96.8098, 1001.8, 0.0237, 148.453, -74.2944, 1001.8, 'SkinShop | 3'),
(8, 14, 204.306, -168.587, 1000.52, 0.3137, 214.911, -156.171, 1000.52, 'SkinShop | 4'),
(9, 15, 207.696, -110.918, 1005.13, 359.582, 207.663, -100.813, 1005.26, 'SkinShop | 5'),
(10, 3, 207.076, -140.022, 1003.51, 0.9874, 207.054, -129.182, 1003.51, 'SkinShop | 6'),
(11, 3, -2636.61, 1402.51, 906.461, 1.1104, -2653.7, 1408.01, 906.273, 'Jizzy'),
(12, 17, 493.42, -24.8393, 1000.68, 358.267, 499.736, -20.7157, 1000.68, 'Клуб | Alhambra'),
(13, 17, -25.9083, -188.214, 1003.55, 357.435, -29.4885, -185.124, 1003.55, '24-7 | 1'),
(14, 10, 6.122, -31.7169, 1003.55, 359.664, 1.4179, -29.0142, 1003.55, '24-7 | 2'),
(15, 6, -2240.74, 137.22, 1035.41, 265.686, -2237.2, 130.177, 1035.41, '24-7 | 3'),
(16, 10, 362.934, -75.1487, 1001.51, 303.263, 377.112, -67.5704, 1001.52, 'Закусочная | Бургер'),
(17, 9, 364.966, -11.7609, 1001.85, 358.7, 369.467, -6.0708, 1001.85, 'Закусочная | Колок'),
(18, 5, 372.324, -133.463, 1001.49, 1.4964, 374.694, -119.157, 1001.5, 'Закусочная | Пицца'),
(19, 7, 315.763, -143.609, 999.602, 358.004, 314.259, -133.821, 999.602, 'Аммо | 1'),
(20, 1, 285.564, -41.7604, 1001.52, 310.666, 295.414, -38.3791, 1001.52, 'Аммо | 2'),
(21, 4, 285.837, -86.7015, 1001.52, 354.487, 295.572, -80.8112, 1001.52, 'Аммо | 3'),
(22, 1, 2404.61, -42.0818, 1029.63, 357.55, 2405.97, -25.8682, 1029.64, 'Transportation of products'),
(23, 12, 855.019, -230.699, 1001.19, 358.364, 852.985, -223.489, 1001.19, 'Computer Club'),
(24, 1, -2158.65, 643.105, 1052.38, 143.655, -2161.25, 640.359, 1052.38, 'риэлторка'),
(25, 5, 772.327, -5.4651, 1000.73, 2.9704, 756.362, 5.4068, 1000.7, 'Спорт-Зал');

-- --------------------------------------------------------

--
-- Структура таблицы `blackmarket`
--

CREATE TABLE `blackmarket` (
  `id` int(10) UNSIGNED NOT NULL,
  `gang` int(11) NOT NULL,
  `drugs` int(11) NOT NULL,
  `mats` int(11) NOT NULL,
  `armour` int(11) NOT NULL,
  `skin` int(11) NOT NULL,
  `drugsprice` int(11) NOT NULL,
  `matsprice` int(11) NOT NULL,
  `armourprice` int(11) NOT NULL,
  `skinprice` int(11) NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `blackmarket`
--

INSERT INTO `blackmarket` (`id`, `gang`, `drugs`, `mats`, `armour`, `skin`, `drugsprice`, `matsprice`, `armourprice`, `skinprice`, `time`) VALUES
(1, 18, 0, 0, 48, 0, 15, 15, 10000, 10000, 1538499777);

-- --------------------------------------------------------

--
-- Структура таблицы `bonuses`
--

CREATE TABLE `bonuses` (
  `id` int(11) NOT NULL,
  `act_level` int(11) NOT NULL DEFAULT 5,
  `act_select` int(11) NOT NULL DEFAULT 0,
  `act_time` int(11) NOT NULL,
  `act_skill` int(11) NOT NULL DEFAULT 1,
  `act_exp` int(11) NOT NULL DEFAULT 1,
  `act_sport` int(11) NOT NULL DEFAULT 1,
  `act_mp` int(11) NOT NULL DEFAULT 1,
  `act_gun` int(11) NOT NULL DEFAULT 1,
  `act_fish` int(11) NOT NULL DEFAULT 1,
  `act_renthotel` int(11) NOT NULL DEFAULT 0,
  `act_buyskin` int(11) NOT NULL,
  `act_buycar` int(11) NOT NULL,
  `act_rentcar` int(11) NOT NULL,
  `act_buylic` int(11) NOT NULL,
  `act_buyimprove` int(11) NOT NULL,
  `act_disease` int(11) NOT NULL,
  `act_changesex` int(11) NOT NULL,
  `act_medcard` int(11) NOT NULL,
  `act_buynubmbercar` int(11) NOT NULL,
  `act_perfomance` int(11) NOT NULL,
  `act_tune` int(11) NOT NULL,
  `act_timerullet` int(11) NOT NULL DEFAULT 180,
  `act_promocode` int(11) NOT NULL DEFAULT 1,
  `act_payday` int(11) NOT NULL DEFAULT 1,
  `act_donate` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `bonuses`
--

INSERT INTO `bonuses` (`id`, `act_level`, `act_select`, `act_time`, `act_skill`, `act_exp`, `act_sport`, `act_mp`, `act_gun`, `act_fish`, `act_renthotel`, `act_buyskin`, `act_buycar`, `act_rentcar`, `act_buylic`, `act_buyimprove`, `act_disease`, `act_changesex`, `act_medcard`, `act_buynubmbercar`, `act_perfomance`, `act_tune`, `act_timerullet`, `act_promocode`, `act_payday`, `act_donate`) VALUES
(1, 3, 0, 0, 3, 3, 1, 3, 3, 2, 5, 10, 10, 5, 5, 5, 5, 5, 5, 5, 5, 5, 180, 3, 2, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `business`
--

CREATE TABLE `business` (
  `id` int(4) NOT NULL,
  `name` varchar(64) NOT NULL,
  `type` int(2) NOT NULL,
  `bint` int(2) NOT NULL,
  `ownerid` int(9) NOT NULL,
  `sellprice` int(9) NOT NULL,
  `bank` int(11) NOT NULL,
  `bankday` int(11) NOT NULL,
  `price` int(4) NOT NULL,
  `enter` int(11) NOT NULL DEFAULT 0,
  `product` int(7) NOT NULL,
  `visitors` int(11) NOT NULL,
  `upgrade` varchar(64) NOT NULL DEFAULT '5000|0|0',
  `order` int(11) NOT NULL,
  `orderprice` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `r` float NOT NULL,
  `deliving` int(8) NOT NULL DEFAULT 0,
  `mafia` int(11) NOT NULL,
  `owner` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;

--
-- Дамп данных таблицы `business`
--

INSERT INTO `business` (`id`, `name`, `type`, `bint`, `ownerid`, `sellprice`, `bank`, `bankday`, `price`, `enter`, `product`, `visitors`, `upgrade`, `order`, `orderprice`, `status`, `x`, `y`, `z`, `r`, `deliving`, `mafia`, `owner`) VALUES
(1, 'Fishing Business', 9, 15, 0, 1200000, 267622, 15944, 5, 0, 9120, 0, '5000|0|0', 0, 0, 1, -398.139, -430.02, 16.5967, 348.067, 1542384133, 0, ''),
(2, 'Таксопарк', 11, 22, 0, 3000000, 0, 0, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, 1068.02, -1769.33, 13.3695, 268.156, 1683382330, 0, ''),
(3, 'Таксопарк', 11, 22, 0, 3000000, 90, 90, 5, 0, 500, 2, '5000|0|0', 0, 0, 1, -2174.55, 291.047, 35.1291, 86.7811, 1554108338, 0, ''),
(4, 'Таксопарк', 11, 22, 0, 3000000, 1282, 0, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, 2496.37, 1346.4, 10.8276, 92.4444, 1542292054, 0, ''),
(5, 'Транспортная компания', 14, 22, 0, 3000000, 750000, 0, 5, 0, 500, 1, '5000|0|0', 0, 0, 1, -62.941, -1113.35, 1.4203, 242.519, 1597873877, 0, ''),
(6, 'Транспортная компания', 14, 22, 0, 3000000, 599240, 8064, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, -504.398, -522.951, 25.5234, 258.452, 1542467092, 0, ''),
(7, 'Транспортная компания', 14, 22, 0, 3000000, 104980, 0, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, 136.139, -236.311, 2.436, 178.652, 1589104102, 0, ''),
(8, 'Банк ЛС', 15, 22, 0, 4000000, 0, 0, 5, 0, 500, 1, '5000|0|0', 0, 0, 1, 190.978, -277.88, 1000.98, 359.836, 1600680766, 0, ''),
(9, 'Банк СФ', 15, 22, 0, 4000000, 5554067, 3247, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, 190.978, -277.88, 1000.98, 359.836, 1542372640, 0, ''),
(10, 'Банк ЛВ', 15, 22, 0, 4000000, 437885, 8420, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, 190.978, -277.88, 1000.98, 359.836, 1542238190, 0, ''),
(11, 'Computer Club', 10, 23, 0, 1200000, 1151176, 1128, 5, 5000, 500, 0, '5000|0|0', 0, 0, 1, 1022.5, -1121.47, 23.8721, 184.574, 1541946410, 0, ''),
(12, 'Victim', 5, 5, 0, 700000, 180351, 2910, 5, 0, 4569, 3, '5000|0|0', 0, 0, 1, 461.41, -1500.84, 31.0598, 100.614, 1541599702, 0, ''),
(13, 'Z.I.P Gymboree', 5, 8, 0, 700000, 599247, 1455, 5, 0, 6566, 0, '5000|0|0', 0, 0, 1, 2090.49, 2224.39, 11.0234, 178.924, 1542320080, 0, ''),
(14, 'Z.I.P BrandMixx', 5, 7, 0, 500000, 136206, 0, 5, 0, 5451, 0, '5000|0|0', 0, 0, 1, -1882.51, 866.313, 35.1719, 138.794, 1541800878, 0, ''),
(15, 'Victim Peek', 5, 5, 0, 400000, 261854, 0, 5, 0, 2331, 0, '5000|0|0', 0, 0, 1, 2802.66, 2430.47, 11.0625, 133.061, 1541449980, 0, ''),
(16, 'Misty Bar', 3, 1, 0, 300000, 24778, 0, 5, 100, 3173, 0, '5000|0|0', 0, 0, 1, -2242.5, -88.1601, 35.3203, 88.2775, 1542288476, 0, ''),
(17, 'Eastern Standard Bar', 3, 1, 0, 450000, 25726, 3620, 5, 1500, 3551, 0, '5000|0|0', 0, 0, 1, 2244.44, 2524.71, 10.8203, 175.072, 1542303774, 0, ''),
(18, 'Club Alhambra', 4, 12, 0, 750000, 6118, 0, 5, 50, 2998, 0, '5000|0|0', 0, 0, 1, 1836.67, -1682.45, 13.3381, 90.1573, 1542019188, 0, ''),
(19, 'Club Pig-Pen', 4, 2, 0, 400000, 29376, 0, 5, 500, 2805, 0, '5000|0|0', 0, 0, 1, 2421.47, -1219.57, 25.541, 179.122, 1541533234, 0, ''),
(20, 'Big Spread Ranch Club', 4, 1, 0, 250000, 12986, 0, 5, 2000, 4912, 0, '5000|0|0', 0, 0, 1, 693.67, 1967.31, 5.5391, 178.808, 1541576349, 0, ''),
(21, 'Club Jizzy', 4, 11, 0, 900000, 9632, 0, 5, 400, 9008, 0, '5000|0|0', 0, 0, 1, -2624.56, 1412.44, 7.0938, 192.595, 1542131953, 0, ''),
(22, 'Sprouts 24-7', 2, 14, 0, 1500000, 0, 0, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, 1833.43, -1842.58, 13.5781, 87.2802, 1582751466, 0, ''),
(23, 'Walmart 24-7', 2, 14, 0, 1000000, 289890, 0, 5, 0, 8, 0, '5000|0|0', 0, 0, 1, 2424.04, -1742.56, 13.5435, 41.533, 1542204921, 0, ''),
(24, 'Green Apple 24-7', 2, 14, 0, 500000, 235076, 0, 5, 0, 13, 0, '5000|0|0', 0, 0, 1, 172.118, -152.553, 1.575, 312.209, 1542034995, 0, ''),
(25, 'Seven Shop 24-7', 2, 13, 0, 600000, 383935, 2484, 5, 0, 6114, 0, '5000|0|0', 0, 0, 1, 2097.67, 2224.41, 11.0234, 180.271, 1542296369, 0, ''),
(26, 'Whole Foods 24-7', 2, 14, 0, 500000, 11586, 0, 5, 0, 4500, 0, '5000|0|0', 0, 0, 1, 2194.58, 1990.99, 12.2969, 86.5833, 1542400492, 0, ''),
(27, 'Kwik-E-Mart 24-7', 2, 14, 0, 500000, 89099, 0, 5, 0, 23, 0, '5000|0|0', 0, 0, 1, -2479.23, 2317.89, 4.9844, 314.355, 1542378194, 0, ''),
(28, 'Center Stacy 24-7', 2, 13, 0, 1500000, 91067, 4228, 5, 0, 6017, 0, '5000|0|0', 0, 0, 1, -2032.68, 161.448, 29.0461, 265.475, 1542250622, 0, ''),
(29, 'Vons-Jons 24-7', 2, 13, 0, 450000, 0, 0, 5, 0, 4, 0, '5000|0|0', 0, 0, 1, -2442.65, 755.084, 35.1719, 179.935, 1541964842, 0, ''),
(30, 'VineWood Ralphs 24-7', 2, 13, 0, 800000, 509865, 0, 5, 0, 9, 0, '5000|0|0', 0, 0, 1, 1000.25, -919.956, 42.3281, 95.9604, 1541282795, 0, ''),
(31, 'Pike Place 24-7', 2, 14, 0, 650000, 1648, 1648, 5, 0, 332, 0, '5000|0|0', 0, 0, 1, -78.689, -1169.83, 2.1431, 66.5067, 1554036389, 0, ''),
(32, 'City-Market 24-7', 2, 14, 0, 450000, 73622, 0, 5, 0, 7876, 0, '5000|0|0', 0, 0, 1, 2117.5, 897.142, 11.1797, 359.453, 1542379197, 0, ''),
(33, 'WoolWorth 24-7', 2, 13, 0, 800000, 4100, 0, 5, 0, 9, 0, '5000|0|0', 0, 0, 1, 2637.33, 1129.63, 11.1797, 180.248, 1542440043, 0, ''),
(34, 'Zig-Zag 24-7', 2, 14, 0, 450000, 53050, 8822, 5, 0, 8600, 0, '5000|0|0', 0, 0, 1, 1599.3, 2221.57, 11.0625, 218.788, 1542455919, 0, ''),
(35, 'Angel Pine 24-7', 2, 14, 0, 300000, 4102, 0, 5, 0, 7202, 0, '5000|0|0', 0, 0, 1, -2231.77, -2558.15, 31.9219, 64.6268, 1542282248, 0, ''),
(36, 'Marine Creek 24-7', 2, 13, 0, 600000, 125502, 0, 5, 0, 15, 0, '5000|0|0', 0, 0, 1, -1675.91, 432.01, 7.1797, 223.175, 1541958198, 0, ''),
(37, 'Ghetto Center 24-7', 2, 13, 0, 700000, 3061656, 0, 5, 0, 2, 0, '5000|0|0', 0, 0, 1, 1928.85, -1776.27, 13.5469, 271.718, 1541772842, 0, ''),
(38, 'Robois Mart 24-7', 2, 14, 0, 1000000, 130860, 8274, 5, 0, 2351, 0, '5000|0|0', 0, 0, 1, 1352.37, -1758.93, 13.5078, 357.549, 1542204432, 0, ''),
(39, 'Justick 24-7', 2, 14, 0, 600000, 551092, 0, 5, 0, 6700, 0, '5000|0|0', 0, 0, 1, 2546.55, 1972.33, 10.8203, 177.241, 1541908043, 0, ''),
(40, 'VineWood Shell Gas', 7, 0, 0, 1500000, 1163312, 0, 5, 0, 4169, 0, '5000|0|0', 0, 0, 1, 1004.06, -937.533, 42.3281, 0, 1542211613, 0, ''),
(41, 'Mobilbur Gas', 7, 0, 0, 1500000, 27594, 1884, 5, 0, 5454, 0, '5000|0|0', 0, 0, 1, 1940.93, -1772.89, 13.6406, 0, 1541454014, 0, ''),
(42, 'Big-Shell Gas', 7, 0, 0, 1500000, 0, 0, 5, 0, 100, 0, '5000|0|0', 0, 0, 1, -91.3426, -1169.02, 2.43, 0, 1554012332, 0, ''),
(43, 'Mobill-Gas', 7, 0, 0, 1500000, 76396, 636, 5, 0, 1822, 0, '5000|0|0', 0, 0, 1, -2026.6, 156.673, 29.0391, 0, 1542451402, 0, ''),
(44, 'Whistler Gas', 7, 0, 0, 1000000, 94343, 309, 5, 0, 2934, 0, '5000|0|0', 0, 0, 1, -1675.94, 413.083, 7.1797, 0, 1542035501, 0, ''),
(45, 'Easter Gas', 7, 0, 0, 1000000, 32066, 0, 5, 0, 4201, 0, '5000|0|0', 0, 0, 1, -2410.04, 976.199, 45.4255, 0, 1541407565, 0, ''),
(46, 'Emerald Gas', 7, 0, 0, 1200000, 73017, 0, 5, 0, 901, 0, '5000|0|0', 0, 0, 1, 2202.44, 2474.51, 10.8203, 0, 1541434158, 0, ''),
(47, 'Zig-Zag Alov Gas', 7, 0, 0, 1000000, 85211, 363, 5, 0, 8229, 0, '5000|0|0', 0, 0, 1, 1595.98, 2198.91, 10.8203, 0, 1542203982, 0, ''),
(48, 'Last Chance Gas', 7, 0, 0, 1000000, 145738, 1450, 5, 0, 4495, 0, '5000|0|0', 0, 0, 1, 2114.66, 919.99, 10.8203, 0, 1542016566, 0, ''),
(49, 'Firestone Gas', 7, 0, 0, 1200000, 10648, 0, 5, 0, 4979, 0, '5000|0|0', 0, 0, 1, 2639.4, 1106.31, 10.8203, 0, 1541620251, 0, ''),
(50, 'Route us-66 Gas', 7, 0, 0, 1100000, 71240, 0, 5, 0, 5902, 0, '5000|0|0', 0, 0, 1, 70.3325, 1218.58, 18.8119, 0, 1541515293, 0, ''),
(51, 'Regal-Jax Gas', 7, 0, 0, 1000000, 686, 0, 5, 0, 19, 0, '5000|0|0', 0, 0, 1, -1328.19, 2677.41, 50.0625, 0, 1542471022, 0, ''),
(52, 'Pike Casso Gas', 7, 0, 0, 1000000, 5684, 0, 5, 0, 3, 0, '5000|0|0', 0, 0, 1, 655.625, -564.984, 16.3359, 0, 1541919397, 0, ''),
(53, 'Angel Pine Gas', 7, 0, 0, 1000000, 2340, 144, 5, 0, 8457, 0, '5000|0|0', 0, 0, 1, -2244.17, -2560.92, 31.9219, 0, 1542328509, 0, ''),
(54, 'Ocean Flats Cluck', 1, 17, 0, 300000, 526, 0, 5, 0, 9371, 0, '5000|0|0', 0, 0, 1, -2672.27, 258.292, 4.6328, 0, 1542375639, 0, ''),
(55, 'Jefferson Cluck', 1, 17, 0, 300000, 18264, 0, 5, 0, 2686, 0, '5000|0|0', 0, 0, 1, 2420.14, -1508.98, 24, 0, 1542385918, 0, ''),
(56, 'The Well Stacked Pizza', 1, 18, 0, 400000, 1433201, 138, 5, 0, 4840, 0, '5000|0|0', 0, 0, 1, 2105.16, -1806.51, 13.5547, 0, 1541871826, 0, ''),
(57, 'Cluckin Bell Pizza', 1, 17, 0, 300000, 355227, 2452, 5, 0, 4256, 0, '5000|0|0', 0, 0, 1, 928.54, -1352.9, 13.3438, 0, 1541693189, 0, ''),
(58, 'Burger Shot', 1, 16, 0, 300000, 67349, 0, 5, 0, 8830, 0, '5000|0|0', 0, 0, 1, 810.868, -1616.22, 13.5469, 0, 1541776167, 0, ''),
(59, 'VineWood Burger', 1, 16, 0, 400000, 61058, 1780, 5, 0, 2601, 0, '5000|0|0', 0, 0, 1, 1199.31, -918.496, 43.1202, 0, 1542017927, 0, ''),
(60, 'Fort Carson Cluck', 1, 17, 0, 350000, 4478, 0, 5, 0, 4, 0, '5000|0|0', 0, 0, 1, 172.793, 1176.97, 14.7578, 0, 1542384443, 0, ''),
(61, 'Old Venturas Burger', 1, 16, 0, 250000, 175933, 0, 5, 0, 6703, 0, '5000|0|0', 0, 0, 1, 2472.55, 2034.25, 11.0625, 0, 1542465465, 0, ''),
(62, 'Marina Cluck', 1, 17, 0, 400000, 214723, 1106, 5, 0, 8471, 0, '5000|0|0', 0, 0, 1, 2102.24, 2228.81, 11.0234, 0, 1541916548, 0, ''),
(63, 'DownTown Cluck', 1, 17, 0, 250000, 305596, 0, 5, 0, 2676, 0, '5000|0|0', 0, 0, 1, -1816.58, 618.307, 35.1719, 0, 1541692934, 0, ''),
(64, 'Quick-Quack Burger ', 1, 16, 0, 250000, 804, 0, 5, 0, 1839, 0, '5000|0|0', 0, 0, 1, -1912.18, 828.17, 35.213, 0, 1542414695, 0, ''),
(65, 'Burger Yasin', 1, 16, 0, 300000, 648, 256, 5, 0, 5260, 0, '5000|0|0', 0, 0, 1, -2356.2, 1008.18, 50.8984, 0, 1542359360, 0, ''),
(66, 'Ammo LS', 6, 19, 0, 2500000, 19600, 19600, 5, 0, 100, 0, '5000|0|0', 0, 0, 1, 1368.93, -1279.73, 13.5469, 88.9407, 1587548679, 0, ''),
(67, 'Ammo SF', 6, 20, 0, 2000000, 4445, 0, 5, 0, 2, 0, '5000|0|0', 0, 0, 1, -2626.62, 208.31, 4.8125, 2.1467, 1542295354, 0, ''),
(68, 'Ammo LV', 6, 21, 0, 2000000, 229741, 0, 5, 0, 1, 0, '5000|0|0', 0, 0, 1, 2159.48, 943.166, 10.8203, 88.9176, 1541483377, 0, ''),
(69, 'Автосалон', 8, 50, 0, 3000000, 288297, 490, 5, 0, 52, 0, '5000|0|0', 0, 0, 1, 545.704, -1293.48, 17.2422, 179.878, 1542118276, 0, ''),
(70, 'Автосалон', 8, 50, 0, 3000000, 4173, 962, 5, 0, 363, 0, '5000|0|0', 0, 0, 1, -1965.66, 293.938, 35.4688, 88.2859, 1542391376, 0, ''),
(71, 'Автосалон', 8, 50, 0, 3000000, 218296, 218296, 5, 0, 500, 0, '5000|0|0', 0, 0, 1, 2200.86, 1394.81, 11.0625, 358.503, 1683381029, 0, ''),
(72, 'Мотосалон', 8, 50, 0, 2500000, 2542440, 0, 5, 0, 343, 0, '5000|0|0', 0, 0, 1, 2131.82, -1151.32, 24.06, 183.371, 1541539958, 0, ''),
(73, 'Риэлторское агенство ЛС', 12, 24, 0, 1000000, 693636, 12212, 5, 4000, 500, 0, '5000|0|0', 0, 0, 1, 776.369, -1036.25, 24.2736, 189.859, 1542204775, 0, ''),
(74, 'Риэлторское агенство СФ', 12, 24, 0, 1000000, 5851, 1771, 5, 1999, 500, 0, '5000|0|0', 0, 0, 1, -2563.33, 310.073, 15.9453, 265.233, 1541772129, 0, ''),
(75, 'Риэлторское агенство ЛВ', 12, 24, 0, 1000000, 59580, 4410, 5, 5000, 500, 0, '5000|0|0', 0, 0, 1, 2014.86, 1106.97, 10.8203, 198.469, 1542374383, 0, ''),
(76, 'Спорт-Зал', 13, 25, 0, 1500000, 695613, 8530, 5, 5000, 7300, 0, '5000|0|0', 0, 0, 1, 2229.86, -1721.29, 13.5616, 135.136, 1541946682, 0, ''),
(77, 'Shack Shop', 2, 13, 0, 1000000, 318310, 39992, 5, 0, 7243, 0, '5000|0|0', 0, 0, 1, 2673.11, -1095.82, 69.3138, 355.612, 1542380153, 0, ''),
(78, 'Lavanderia 24-7', 2, 14, 0, 1000000, 53316, 0, 5, 0, 2, 0, '5000|0|0', 0, 0, 1, 2472.99, -1922.19, 13.5313, 182.988, 1542032261, 0, ''),
(79, 'Diamonds 24-7', 2, 14, 0, 1000000, 65988, 0, 5, 0, 4, 0, '5000|0|0', 0, 0, 1, 2081.44, -1205.14, 23.9332, 87.7332, 1542029815, 0, ''),
(80, 'Рекламное агенство', 16, 24, 0, 1000000, 4900, 4900, 5, 5000, 500000, 0, '5000|0|0', 0, 0, 1, -2166.12, 329.995, 35.3203, 185.295, 1542453616, 0, ''),
(81, 'Магазин Аксессуаров', 17, 6, 0, 1500000, 32340, 32340, 5, 0, 20, 0, '5000|0|0', 0, 0, 1, 1419.22, -1623.81, 13.5469, 273.461, 1587300996, 0, ''),
(82, 'Perfomance Tune', 18, 0, 0, 3500000, 4322270, 540020, 5, 0, 1580, 0, '5000|0|0', 0, 0, 1, 658.361, -1489.23, 18.5139, 179.261, 1542329355, 0, '');

-- --------------------------------------------------------

--
-- Структура таблицы `business_func`
--

CREATE TABLE `business_func` (
  `ID` int(11) NOT NULL,
  `bizzID` int(11) NOT NULL,
  `name` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '----',
  `name_car` varchar(13) NOT NULL DEFAULT 'TAXI',
  `number` int(11) NOT NULL DEFAULT 0,
  `car` varchar(256) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `tarif` varchar(128) NOT NULL DEFAULT '0|0|0|0',
  `color` int(11) NOT NULL DEFAULT 0,
  `color_shash` int(11) NOT NULL DEFAULT 0,
  `percent` int(11) NOT NULL DEFAULT 1,
  `percent2` float NOT NULL DEFAULT 0,
  `percent3` int(11) NOT NULL DEFAULT 1,
  `members` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `business_func`
--

INSERT INTO `business_func` (`ID`, `bizzID`, `name`, `name_car`, `number`, `car`, `tarif`, `color`, `color_shash`, `percent`, `percent2`, `percent3`, `members`) VALUES
(1, 2, '---', '---', 6666, '580|560|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '200|300|300|500', 2, 1, 50, 0, 1, 0),
(2, 3, '---', '---', 7777, '550|550|550|550|550|550|0|0|550|550|560|0|0|0|0|0|0|0|0|0', '200|400|350|600', 2, 21, 45, 0, 1, 0),
(3, 4, '---', '---', 1111, '438|483|550|550|550|550|426|438|438|438|550|550|438|550|438|438|580|580|438|438', '200|400|250|450', 18, 19, 50, 0, 1, 0),
(4, 5, '---', '---', 0, '0|403|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0', 1, 0, 50, 0, 1, 0),
(5, 6, '---', '---', 0, '515|515|515|515|515|515|515|515|515|515|515|515|515|515|515|515|0|0|0|0', '0|0|0|0', 11, 0, 20, 0, 1, 0),
(6, 7, '---', '---', 0, '515|515|515|515|515|515|515|515|515|515|515|515|515|515|515|515|0|0|0|0', '0|0|0|0', 14, 0, 20, 0, 1, 0),
(7, 8, 'ZentBank 24/7', '---', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0', 15, 0, 5, 0.6, 5, 3),
(8, 9, 'Faletti', '---', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0', 2, 0, 4, 1, 5, 4),
(9, 10, 'Brigante Bank', '---', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0', 18, 0, 5, 1, 5, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `business_stats`
--

CREATE TABLE `business_stats` (
  `id` int(11) NOT NULL,
  `bizz` int(11) NOT NULL,
  `day` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `money` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `business_stats`
--

INSERT INTO `business_stats` (`id`, `bizz`, `day`, `month`, `year`, `money`) VALUES
(1, 70, 27, 3, 2019, 194040),
(2, 1, 30, 3, 2019, 0),
(3, 41, 31, 3, 2019, 0),
(4, 1, 19, 4, 2020, 0),
(5, 7, 19, 4, 2020, 0),
(6, 70, 19, 4, 2020, 400860),
(7, 80, 19, 4, 2020, 0),
(8, 6, 20, 4, 2020, 4980),
(9, 7, 20, 4, 2020, 9800),
(10, 70, 20, 4, 2020, 0),
(11, 6, 21, 4, 2020, 0),
(12, 7, 21, 4, 2020, 0),
(13, 70, 21, 4, 2020, 0),
(14, 1, 6, 5, 2023, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `captchalog`
--

CREATE TABLE `captchalog` (
  `clID` int(11) NOT NULL,
  `clName` varchar(64) NOT NULL,
  `clIP` varchar(64) NOT NULL,
  `clDate` varchar(64) NOT NULL,
  `clStatus` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `cars`
--

CREATE TABLE `cars` (
  `id` int(11) NOT NULL,
  `owner` varchar(24) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 481,
  `color_one` int(11) NOT NULL DEFAULT 1,
  `color_two` int(11) NOT NULL DEFAULT 1,
  `drived` float NOT NULL DEFAULT 0,
  `fuel` float NOT NULL DEFAULT 100,
  `vehcom_1` int(11) NOT NULL DEFAULT 0,
  `vehcom_2` int(11) NOT NULL DEFAULT 0,
  `vehcom_3` int(11) NOT NULL DEFAULT 0,
  `vehcom_4` int(11) NOT NULL DEFAULT 0,
  `vehcom_5` int(11) NOT NULL DEFAULT 0,
  `vehcom_6` int(11) NOT NULL DEFAULT 0,
  `vehcom_7` int(11) NOT NULL DEFAULT 0,
  `vehcom_8` int(11) NOT NULL DEFAULT 0,
  `vehcom_9` int(11) NOT NULL DEFAULT 0,
  `vehcom_10` int(11) NOT NULL DEFAULT 0,
  `vehcom_11` int(11) NOT NULL DEFAULT 0,
  `vehcom_12` int(11) NOT NULL DEFAULT 0,
  `vehcom_13` int(11) NOT NULL DEFAULT 0,
  `vehcom_14` int(11) NOT NULL DEFAULT 0,
  `open` int(11) NOT NULL DEFAULT 0,
  `instrum` int(11) NOT NULL DEFAULT 0,
  `kanistra` int(11) NOT NULL DEFAULT 0,
  `narko` int(11) NOT NULL DEFAULT 0,
  `mats` int(11) NOT NULL DEFAULT 0,
  `deagle` int(11) NOT NULL DEFAULT 0,
  `ak47` int(11) NOT NULL DEFAULT 0,
  `m4` int(11) NOT NULL DEFAULT 0,
  `shot` int(11) NOT NULL DEFAULT 0,
  `number` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT 'TRANSIT',
  `paintjob` int(11) NOT NULL DEFAULT -1,
  `perf_engine_1` int(11) NOT NULL DEFAULT 0,
  `perf_engine_2` int(11) NOT NULL DEFAULT 0,
  `perf_engine_3` int(11) NOT NULL DEFAULT 0,
  `perf_engine_4` int(11) NOT NULL DEFAULT 0,
  `perf_engine_5` int(11) NOT NULL DEFAULT 0,
  `perf_brake_1` int(11) NOT NULL DEFAULT 0,
  `perf_brake_2` int(11) NOT NULL DEFAULT 0,
  `perf_brake_3` int(11) NOT NULL DEFAULT 0,
  `perf_brake_4` int(11) NOT NULL DEFAULT 0,
  `perf_brake_5` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `cars`
--

INSERT INTO `cars` (`id`, `owner`, `model`, `color_one`, `color_two`, `drived`, `fuel`, `vehcom_1`, `vehcom_2`, `vehcom_3`, `vehcom_4`, `vehcom_5`, `vehcom_6`, `vehcom_7`, `vehcom_8`, `vehcom_9`, `vehcom_10`, `vehcom_11`, `vehcom_12`, `vehcom_13`, `vehcom_14`, `open`, `instrum`, `kanistra`, `narko`, `mats`, `deagle`, `ak47`, `m4`, `shot`, `number`, `paintjob`, `perf_engine_1`, `perf_engine_2`, `perf_engine_3`, `perf_engine_4`, `perf_engine_5`, `perf_brake_1`, `perf_brake_2`, `perf_brake_3`, `perf_brake_4`, `perf_brake_5`) VALUES
(1, 'Klaus_Gurren', 451, 108, 117, 0, 50, 114, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'M 632 NH', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 'Klaus_Gurren', 494, 1, 1, 10.4692, 47.3471, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Y 743 SX', -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(3, 'Klaus_Gurrens', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 'Klaus_Gurrens', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 'Klaus_Gurrenha', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 'Klaus_Gurrenha', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 'Klaus_Gurrenaj', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 'Klaus_Gurrenaj', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 'Klaus_Gurrenls', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 'Klaus_Gurrenls', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 'Klaus_Gurrenm', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 'Klaus_Gurrenm', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(13, 'Klaus_Gurrensk', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(14, 'Klaus_Gurrensk', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15, 'Klaus_Gurreno', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(16, 'Klaus_Gurreno', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(17, 'Klaus_Gurrensa', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(18, 'Klaus_Gurrensa', 481, 1, 1, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'TRANSIT', -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `diplomation`
--

CREATE TABLE `diplomation` (
  `f_id` int(11) NOT NULL,
  `f_dip` varchar(32) NOT NULL DEFAULT '0|0|0|0|0|0|0|0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Дамп данных таблицы `diplomation`
--

INSERT INTO `diplomation` (`f_id`, `f_dip`) VALUES
(15, '0|0|0|0|0|0|0|1'),
(16, '0|3|0|1|1|1|2|1'),
(17, '0|0|3|1|1|1|1|1'),
(18, '0|0|0|0|1|1|1|0'),
(19, '0|0|0|0|1|3|1|1'),
(20, '0|0|0|0|2|1|0|0'),
(21, '0|0|0|0|0|1|1|0'),
(22, '0|0|0|0|1|3|1|1');

-- --------------------------------------------------------

--
-- Структура таблицы `dm_arena`
--

CREATE TABLE `dm_arena` (
  `Name` varchar(25) NOT NULL,
  `kills_dm` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `economy`
--

CREATE TABLE `economy` (
  `id` int(10) UNSIGNED NOT NULL,
  `salary_pd` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_fbi` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_mayor` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_army` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_medics` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_news` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_mafia` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_gang` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_whitehouse` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `salary_licensers` varchar(256) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `work_gun` int(11) NOT NULL,
  `work_oil` int(11) NOT NULL,
  `work_alco` int(11) NOT NULL,
  `work_apple` int(11) NOT NULL,
  `work_wood` int(11) NOT NULL DEFAULT 30,
  `nalog_1` int(11) NOT NULL,
  `nalog_2` int(11) NOT NULL,
  `nalog_3` int(11) NOT NULL,
  `nalog_4` int(11) NOT NULL,
  `nalog_5` int(11) NOT NULL,
  `nalog_6` int(11) NOT NULL,
  `nalog_7` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `economy`
--

INSERT INTO `economy` (`id`, `salary_pd`, `salary_fbi`, `salary_mayor`, `salary_army`, `salary_medics`, `salary_news`, `salary_mafia`, `salary_gang`, `salary_whitehouse`, `salary_licensers`, `work_gun`, `work_oil`, `work_alco`, `work_apple`, `work_wood`, `nalog_1`, `nalog_2`, `nalog_3`, `nalog_4`, `nalog_5`, `nalog_6`, `nalog_7`) VALUES
(1, '3400|5400|7000|8400|10000|11000|13000|15000|17200|18000|19000|2', '6800|8000|9000|10000|11000|12400|15000|15000|18000|21000|26000|', '4000|6000|5000|3000|6400|15000|18000', '3000|4000|5000|6000|7000|8200|9000|9400|11000|12200|14000|15400|16000|17000|20200', '8000|10000|12000|14000|16000|18000|22000|0|0|0|0|0|0|0|0', '5000|8000|9000|9400|9800|10000|11000|13800|16200|19000|0|0|0|0|', '2000|3000|4000|4800|5400|6000|7000|8000|10000|13000', '2000|3000|4000|4000|4000|4000|4200|4500|5000|5000', '5400|7800|8400|9800|11000|24000|24000|24000|24000|24000|27000|33000|0|0|0', '2800|4500|6500|8400|9500|10000|0|0|0|0|0|0|0|0|0', 160, 220, 40, 120, 120, 15, 15, 9000, 2, 10, 2, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `email_success`
--

CREATE TABLE `email_success` (
  `id` int(11) NOT NULL,
  `Account` varchar(36) NOT NULL,
  `Type` int(2) NOT NULL DEFAULT 0,
  `HASH` varchar(70) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `exit_coords`
--

CREATE TABLE `exit_coords` (
  `ID` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `family`
--

CREATE TABLE `family` (
  `id` int(11) NOT NULL,
  `cname` varchar(32) NOT NULL,
  `name` varchar(32) NOT NULL,
  `time` varchar(22) NOT NULL,
  `cowner` varchar(24) NOT NULL,
  `owner` varchar(24) NOT NULL,
  `color` int(11) NOT NULL DEFAULT 0,
  `drugs` int(11) NOT NULL DEFAULT 0,
  `mats` int(11) NOT NULL DEFAULT 0,
  `invite` int(11) NOT NULL DEFAULT 7,
  `uninvite` int(11) NOT NULL DEFAULT 7,
  `giverank` int(11) NOT NULL DEFAULT 7,
  `sklad` int(11) NOT NULL DEFAULT 1,
  `Rank_1` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `Rank_2` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `Rank_3` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `Rank_4` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `Rank_5` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `Rank_6` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `Rank_7` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `Rank_8` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'None',
  `message` varchar(71) NOT NULL DEFAULT 'None',
  `exp` int(11) NOT NULL DEFAULT 0,
  `lvl` int(11) NOT NULL DEFAULT 1,
  `point` int(11) NOT NULL DEFAULT 0,
  `drugs_max` int(11) NOT NULL DEFAULT 0,
  `mats_max` int(11) NOT NULL DEFAULT 0,
  `fuel` int(11) NOT NULL DEFAULT 0,
  `fuel_max` int(11) NOT NULL DEFAULT 0,
  `remp` int(11) NOT NULL DEFAULT 0,
  `remp_max` int(11) NOT NULL DEFAULT 0,
  `armour` int(11) NOT NULL DEFAULT 0,
  `armour_max` int(11) NOT NULL DEFAULT 0,
  `health` int(11) NOT NULL DEFAULT 0,
  `health_max` int(11) NOT NULL DEFAULT 0,
  `mask` int(11) NOT NULL DEFAULT 0,
  `mask_max` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `money_max` int(11) NOT NULL DEFAULT 0,
  `house` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `family`
--

INSERT INTO `family` (`id`, `cname`, `name`, `time`, `cowner`, `owner`, `color`, `drugs`, `mats`, `invite`, `uninvite`, `giverank`, `sklad`, `Rank_1`, `Rank_2`, `Rank_3`, `Rank_4`, `Rank_5`, `Rank_6`, `Rank_7`, `Rank_8`, `message`, `exp`, `lvl`, `point`, `drugs_max`, `mats_max`, `fuel`, `fuel_max`, `remp`, `remp_max`, `armour`, `armour_max`, `health`, `health_max`, `mask`, `mask_max`, `money`, `money_max`, `house`, `type`) VALUES
(1, 'dkdkdkk', 'dkdkdkk', '2023-05-08 12:17:46', 'Klaus_Gurren', 'Klaus_Gurren', 0, 0, 0, 7, 7, 7, 1, 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 35, 1, 35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `fraclog`
--

CREATE TABLE `fraclog` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` int(11) NOT NULL,
  `Name` varchar(25) NOT NULL,
  `NameP` varchar(25) NOT NULL,
  `reason` varchar(140) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `fracmorozed`
--

CREATE TABLE `fracmorozed` (
  `MOROZ_BALLAS` int(11) NOT NULL DEFAULT 0,
  `MOROZ_VAGOS` int(11) NOT NULL DEFAULT 0,
  `MOROZ_GROVE` int(11) NOT NULL DEFAULT 0,
  `MOROZ_RIFA` int(11) NOT NULL DEFAULT 0,
  `MOROZ_AZTECAS` int(11) NOT NULL DEFAULT 0,
  `MOROZ_LCN` int(11) NOT NULL DEFAULT 0,
  `MOROZ_YAKUZA` int(11) NOT NULL DEFAULT 0,
  `MOROZ_RM` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `fracmorozed`
--

INSERT INTO `fracmorozed` (`MOROZ_BALLAS`, `MOROZ_VAGOS`, `MOROZ_GROVE`, `MOROZ_RIFA`, `MOROZ_AZTECAS`, `MOROZ_LCN`, `MOROZ_YAKUZA`, `MOROZ_RM`) VALUES
(0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `fractions`
--

CREATE TABLE `fractions` (
  `ID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Leader` varchar(24) NOT NULL DEFAULT 'None',
  `Admin` varchar(25) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT 'None',
  `Time` varchar(54) CHARACTER SET cp1250 COLLATE cp1250_bin NOT NULL,
  `Bank` int(30) NOT NULL,
  `BankCash` int(11) DEFAULT NULL,
  `Drugs` int(11) NOT NULL,
  `Mats` int(11) NOT NULL,
  `Health` int(11) NOT NULL,
  `Sklad` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  `Skin` int(11) NOT NULL,
  `MaxRang` int(4) NOT NULL,
  `RangInvite` int(4) NOT NULL,
  `RangUninvite` int(4) NOT NULL,
  `GiveRang` int(4) NOT NULL,
  `UseStock` int(11) NOT NULL,
  `VW` int(11) NOT NULL,
  `INT` int(11) NOT NULL,
  `Rank_1` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_2` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_3` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_4` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_5` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_6` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_7` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_8` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_9` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_10` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_11` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_12` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_13` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_14` varchar(50) NOT NULL DEFAULT 'None',
  `Rank_15` varchar(50) NOT NULL DEFAULT 'None',
  `Message` varchar(71) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT 'None',
  `DrugsBuy` int(11) NOT NULL DEFAULT 0,
  `DrugsPrice` int(11) NOT NULL DEFAULT 0,
  `AntiTk` int(11) NOT NULL DEFAULT 1,
  `fPoints` int(4) NOT NULL,
  `fRating` int(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `fractions`
--

INSERT INTO `fractions` (`ID`, `Name`, `Leader`, `Admin`, `Time`, `Bank`, `BankCash`, `Drugs`, `Mats`, `Health`, `Sklad`, `Price`, `Skin`, `MaxRang`, `RangInvite`, `RangUninvite`, `GiveRang`, `UseStock`, `VW`, `INT`, `Rank_1`, `Rank_2`, `Rank_3`, `Rank_4`, `Rank_5`, `Rank_6`, `Rank_7`, `Rank_8`, `Rank_9`, `Rank_10`, `Rank_11`, `Rank_12`, `Rank_13`, `Rank_14`, `Rank_15`, `Message`, `DrugsBuy`, `DrugsPrice`, `AntiTk`, `fPoints`, `fRating`) VALUES
(1, 'Поліція ЛС', 'None', 'Klaus_Gurren', '10/05/2023', 0, 0, 0, 3530, 0, 0, 0, 283, 11, 11, 11, 11, 0, 0, 0, 'Кадет', 'Офіцер I', 'Офіцер II', 'Офіцер III', 'Детектив', 'Старший Детектив', 'Молодший Лейтенант', 'Лейтенант', 'Майор', 'Заступник Шерифа', 'Шериф', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(2, 'Поліція СФ', 'None', 'None', '27/02/2020', 250000, 0, 0, 700000, 30, 0, 0, 283, 11, 11, 11, 11, 0, 0, 0, 'Кадет', 'Офіцер I', 'Офіцер II', 'Офіцер III', 'Детектив', 'Старший Детектив', 'Молодший Лейтенант', 'Лейтенант', 'Майор', 'Заступник Шерифа', 'Шериф', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(3, 'Поліція ЛВ', 'None', 'None', '14/10/2018', 250000, 0, 0, 500000, 0, 0, 0, 283, 11, 10, 10, 10, 0, 0, 0, 'Кадет', 'Офіцер I', 'Офіцер II', 'Офіцер III', 'Детектив', 'Старший Детектив', 'Молодший Лейтенант', 'Лейтенант', 'Майор', 'Заступник Шерифа', 'Шериф', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(4, 'ФБР', 'None', 'None', '18/04/2020', 100000, 0, 0, 43500, 500, 0, 0, 166, 11, 9, 9, 10, 0, 0, 0, 'Стажер', 'Молодший Агент ФБР', 'Агент ФБР', 'Старший Агент ФБР', 'Агент CID', 'Агент DEA', 'Глава Керування CID', 'Глава Керування DEA', 'Інспектор ФБР', 'Зам.Директора', 'Директор', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(5, 'Влада', 'None', 'None', '16/06/2018', 150000, 0, 0, 0, 0, 0, 0, 147, 7, 6, 6, 6, 0, 0, 0, 'Водій', 'Охоронець', 'Секретарь', 'Адвокат', 'Нач.служби беспеки', 'Заступник Президента', 'Президент', '', '', '', '', '', '', '', '', 'None', 0, 0, 1, 0, 0),
(6, 'Армія СФ', 'None', 'None', '10/12/2020', 7500, 0, 0, 988740, 0, 0, 0, 61, 15, 12, 13, 13, 0, 0, 0, 'Матрос', 'Ст. Матрос', 'Старшина 2 ст.', 'Старшина 1 ст.', 'Г.К. Старшина', 'Мичман', 'Ст. Мичман', 'Лейтенант', 'Ст. Лейтенант', 'Кап. Лейтенант', 'Капітан 2 ранга', 'Капітан 1 ранга', 'Контр-Адмірал', 'Вице-Адмірал', 'Адмірал', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 0, 0, 0),
(7, 'Армія ЛВ', 'None', 'None', '17/10/2018', 0, 0, 0, 548275, 60, 0, 0, 61, 15, 13, 12, 12, 0, 0, 0, 'Рядовий', 'Ефрейтор', 'Мл. Сержант', 'Сержант', 'Ст. Сержант', 'Старшина', 'Прапорщик', 'Ст. Прапорщик', 'Лейтенант', 'Ст. Лейтенант', 'Капітан', 'Майор', 'Підполковник', 'Полковник', 'Генерал', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(8, 'Лікарня ЛС', 'None', 'None', '20/05/2020', 0, 0, 0, 0, 58, 0, 0, 70, 7, 5, 5, 6, 0, 0, 0, 'Санітар', 'Інтерн', 'Терапевт', 'Нарколог', 'Хірург', 'Заступник гл. лікаря', 'Головний лікарь', '', '', '', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(9, 'Лікарня СФ', 'None', 'None', '22/09/2018', 0, 0, 0, 0, 0, 0, 0, 70, 7, 6, 6, 6, 0, 0, 0, 'Санітар', 'Інтерн', 'Терапевт', 'Нарколог', 'Хірург', 'Заступник гл. Лікаря', 'Головний лікарь', '', '', '', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(10, 'Лікарня ЛВ', 'None', 'None', '20/05/2020', 0, 0, 0, 0, 0, 0, 0, 70, 7, 5, 5, 5, 0, 0, 0, 'Санітар', 'Інтерн', 'Терапевт', 'Нарколог', 'Хірург', 'Заступник гл. Лікаря', 'Головний лікарь', '', '', '', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(11, 'Радіоцентр ЛС', 'None', 'None', '16/10/2018', 12777369, 0, 0, 0, 45, 0, 0, 261, 10, 8, 8, 8, 0, 0, 0, 'Стажер', 'Редактор', 'Журналіст', 'Оператор', 'Кореспондент', 'Репортер', 'Диктор', 'Режиссер радіозв\'язку', 'Заступник директора', 'Директор', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(12, 'Радіоцентр СФ', 'None', 'None', '22/09/2018', 10972000, 0, 0, 0, 0, 0, 0, 261, 10, 9, 9, 9, 0, 0, 0, 'Стажер', 'Редактор', 'Журналист', 'Оператор', 'Кореспондент', 'Репортер', 'Диктор', 'Режиссер радіозв\'язку', 'Заступник директора', 'Директор', '', '', '', '', '', 'None', 0, 0, 1, 0, 0),
(13, 'Радіоцентр ЛВ', 'None', 'None', '12/10/2018', 5507279, 0, 0, 0, 0, 0, 0, 261, 10, 8, 8, 9, 0, 0, 0, 'Стажер', 'Редактор', 'Журналіст', 'Оператор', 'Кореспондент', 'Репортер', 'Диктор', 'Режиссер радіозв\'язку', 'Заступник директора', 'Директор', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(14, 'Ліцензери', 'None', 'None', '09/02/2018', 0, 0, 0, 0, 0, 0, 0, 240, 6, 5, 5, 5, 0, 0, 0, 'Стажер', 'Інструктор', 'Екзаменатор', 'Ліцензер', 'Керуючий', 'Директор', '', '', '', '', '', '', '', '', '', 'None', 0, 0, 1, 0, 0),
(15, 'Італійська мафия', 'None', 'None', '27/10/2018', 12619090, 0, 17373, 300000, 10, 0, 0, 113, 10, 8, 8, 9, 0, 0, 0, 'Новицио', 'Солдато', 'Ассосиате', 'Сегундо', 'Комбаттенте', 'Саргенто', 'Сото-Капо', 'Амиго', 'Консильери', 'Босс', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(16, 'Японська мафия', 'None', 'None', '27/10/2018', 4640354, 0, 19805, 300000, 500, 0, 0, 120, 10, 10, 10, 10, 0, 0, 0, 'Вакасю', 'Сятэй', 'Кёдай', 'Фуку-хомбутё', 'Вакагасира', 'Со-хомбуте', 'Камбу', 'Сайко-комон', 'Оядзи', 'Кумитэ', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(17, 'Українська мафия', 'None', 'None', '23/10/2018', 6374986, 0, 18977, 300000, 0, 0, 0, 272, 10, 8, 9, 9, 0, 0, 0, 'Хлопець', 'Фраер', 'Кабан', 'Барига', 'Клик', 'Страшок', 'Браток', 'Свояк', 'Авторитет', 'Пахан ґ', '', '', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0),
(18, 'Ballas Gang', 'None', 'None', '10/12/2020', 7550843, 0, 0, 300000, 495, 1, 0, 104, 10, 8, 8, 8, 0, 0, 0, 'New Blood', 'Hood Nigga', 'Dirty Nigga', 'Authority', 'Old Gangster', 'Legendary', 'Black Devil', 'East Side Pac', 'Purple Dep', 'Black Crown', '', '', '', '', '', 'discord - YDFmvz', 500, 30, 1, 0, 0),
(19, 'Vagos Gang', 'None', 'None', '09/12/2020', 3191725, 0, 0, 300000, 197, 0, 0, 110, 10, 8, 8, 8, 0, 0, 0, 'CandyBaby [I]', 'Homie [II]', 'Ballin [III]', 'Moneybagg [IV]', 'Iceberg [V]', 'JostkiyVersetti', '† its hatte, my boy -', 'Plugstar [VIII]', '† hatte helper -', '† hatte prod. -', '', '', '', '', '', 'None', 500, 30, 1, 0, 0),
(20, 'Grove Street Gang', 'None', 'None', '22/10/2018', 636806, 0, 0, 300000, 0, 0, 0, 270, 10, 8, 8, 8, 0, 0, 0, 'new [1]', 'playa [2]', 'fighter [3]', 'flamie [4]', 'gangster [5]', 'capture [6]', 'warrior [7]', 'defender [8]', 'legendary [9]', 'legend of gang [10]', '', '', '', '', '', 'салам пидарасы )', 500, 30, 0, 0, 0),
(21, 'Aztecas Gang', 'None', 'None', '15/10/2018', 636623, 0, 0, 300000, 500, 0, 0, 115, 10, 8, 9, 9, 0, 0, 0, 'Novato', 'Crew [2]', 'Default[3]', 'Warrior [4]', 'Tortuga [5]', 'Lowrider[6]', 'techies', 'La Leyenda', 'White Trash', 'White King', '', '', '', '', '', 'aztec - vagos war , ballas war, rifa gold', 500, 30, 1, 0, 0),
(22, 'Rifa Gang', 'None', 'None', '26/10/2018', 793036, 0, 0, 300000, 327, 0, 0, 273, 10, 8, 8, 8, 0, 0, 0, 'PUSSY BOY', 'BROKE BOY', 'Завалил 9 обзвонов', 'PROVERKA', 'SANCTUS HARD FLAVA', 'LIL NIGGAS', 'CAPTURE BOYS', 'Fat.Fatboy Zam', 'FatBoy Zam', 'Padre Fallison', '', '', '', '', '', 'Проверка в капт состав с 12-13 утра, НАЧАЛО КАПТОВ В 18:00', 500, 30, 1, 0, 0),
(23, 'Білий дім', 'None', 'Marcus_Rosberg', '18/04/2020', 406916605, 0, 0, 1000000, 0, 0, 0, 17, 12, 11, 12, 12, 0, 0, 0, 'Водій', 'Пресс-секретарь', 'Охоронець', 'Нач. Охорони', 'Адвокат', 'Міністер СМИ', 'Міністер охорони здоров\'я', 'Міністер Оборони', 'Міністер Внутрішніх справ', 'Міністер Юстиції', 'Премьер-Міністер', 'Президент', '', '', '', 'Знайшли баг? Пишіть ТГ: @vitya19y', 0, 0, 1, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `fraction_bl`
--

CREATE TABLE `fraction_bl` (
  `f_bl_id` int(6) NOT NULL,
  `f_bl_accused` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `f_bl_accuser` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `f_bl_date` date NOT NULL,
  `f_bl_reason` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `frac_vehicle`
--

CREATE TABLE `frac_vehicle` (
  `fvehID` int(11) NOT NULL,
  `fvehFrac` int(11) NOT NULL,
  `fvehModel` int(11) NOT NULL,
  `fvehModelNew` int(11) NOT NULL,
  `fvehTime` int(11) NOT NULL,
  `fvehcCoordsX` float NOT NULL,
  `fvehcCoordsY` float NOT NULL,
  `fvehcCoordZ` float NOT NULL,
  `fvehcCoordA` float NOT NULL,
  `fvehColor1` int(11) NOT NULL,
  `fvehColor2` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `frac_vehicle`
--

INSERT INTO `frac_vehicle` (`fvehID`, `fvehFrac`, `fvehModel`, `fvehModelNew`, `fvehTime`, `fvehcCoordsX`, `fvehcCoordsY`, `fvehcCoordZ`, `fvehcCoordA`, `fvehColor1`, `fvehColor2`) VALUES
(1, 18, 566, 461, 0, 1950.06, -1128.69, 25.423, 125, 85, 85),
(2, 18, 536, 0, 0, 1944.63, -1128.73, 25.1906, 125, 85, 85),
(3, 18, 536, 562, 0, 1939.29, -1128.69, 24.8726, 125, 85, 85),
(4, 18, 566, 461, 0, 1932.94, -1143.08, 25.0443, -65, 85, 85),
(5, 18, 566, 461, 0, 1939.9, -1142.93, 25.2549, -65, 85, 85),
(6, 18, 566, 560, 0, 1946.47, -1142.94, 25.4387, -65, 85, 85),
(7, 18, 482, 0, 0, 1934.47, -1117.67, 26.5031, 180, 85, 85),
(8, 18, 478, 422, 0, 1927.68, -1128.63, 25.1326, 125, 85, 85),
(9, 18, 481, 461, 0, 1947.84, -1114.97, 26.0265, 218, 85, 85),
(10, 18, 481, 461, 0, 1947.9, -1112.95, 26.0213, 218, 85, 85),
(11, 19, 482, 0, 0, 2762.66, -1177.62, 69.5208, 90, 6, 6),
(12, 19, 478, 461, 0, 2744.49, -1172.52, 69.3888, 35, 6, 6),
(13, 19, 509, 461, 0, 2752.5, -1179.01, 68.9124, 47.5, 6, 6),
(14, 19, 509, 461, 0, 2750.07, -1178.94, 68.8956, 47.5, 6, 6),
(15, 19, 516, 461, 0, 2744.68, -1164.91, 69.2505, 35, 6, 6),
(16, 19, 516, 560, 0, 2744.89, -1182.39, 69.1847, 35, 6, 6),
(17, 19, 576, 560, 0, 2732.12, -1176.2, 69.021, 0, 6, 6),
(18, 19, 576, 559, 0, 2732.12, -1183.87, 69.0121, 0, 6, 6),
(19, 19, 516, 562, 0, 2744.93, -1187.9, 69.2083, 35, 6, 6),
(20, 19, 516, 422, 0, 2745.11, -1159.75, 69.2797, 35, 6, 6),
(21, 20, 567, 413, 0, 2479.82, -1655.22, 13.2269, 90, 86, 86),
(22, 20, 412, 461, 0, 2508.83, -1667.09, 13.3984, 7.3957, 86, 86),
(23, 20, 412, 0, 0, 2507.76, -1675.26, 13.264, 333.25, 86, 86),
(24, 20, 482, 0, 0, 2505.54, -1694.42, 13.7178, 0, 86, 86),
(25, 20, 567, 0, 0, 2492.09, -1683.12, 13.2883, 269.898, 86, 86),
(26, 20, 567, 0, 0, 2484.62, -1683.01, 13.2856, 266.806, 86, 86),
(27, 20, 478, 461, 0, 2473.56, -1696.7, 13.5315, 0, 86, 86),
(28, 20, 567, 0, 0, 2468.44, -1670.18, 13.2656, 195.792, 86, 86),
(29, 20, 481, 0, 0, 2508, -1651.03, 13.2157, 99.8, 86, 86),
(30, 20, 481, 461, 0, 2505.96, -1649.25, 13.2594, 99.8, 86, 86),
(31, 21, 405, 461, 0, 1692.95, -2105.57, 13.417, 217.5, 2, 1),
(32, 21, 405, 0, 0, 1687.82, -2105.85, 13.4158, 217.5, 2, 1),
(33, 21, 405, 0, 0, 1687.77, -2120.01, 13.3821, 319.5, 2, 1),
(34, 21, 405, 422, 0, 1693.02, -2120.16, 13.3623, 319.5, 2, 1),
(35, 21, 482, 0, 0, 1674.28, -2086.62, 13.7136, 181.35, 2, 1),
(36, 21, 478, 0, 0, 1665.63, -2115.57, 13.4758, -90, 2, 1),
(37, 21, 575, 579, 0, 1681.86, -2119.96, 13.1622, 319.5, 2, 1),
(38, 21, 575, 0, 0, 1682.8, -2105.84, 13.2022, 217.5, 2, 1),
(39, 21, 481, 461, 0, 1670.94, -2118.26, 13.0297, 306.695, 2, 1),
(40, 21, 481, 0, 0, 1671.93, -2119.2, 13.0331, 306.695, 2, 1),
(41, 22, 482, 0, 0, 2740.61, -1944.27, 13.6632, 90, 12, 12),
(42, 22, 529, 0, 0, 2726.86, -1934.25, 13.1199, 90, 12, 12),
(43, 22, 529, 0, 0, 2726.86, -1938.19, 13.1203, 90, 12, 12),
(44, 22, 600, 0, 0, 2708.62, -1956.03, 13.2767, 180, 12, 12),
(45, 22, 478, 0, 0, 2729.61, -1970.14, 13.5556, 90, 12, 12),
(46, 22, 529, 560, 0, 2721.43, -1957.96, 13.1799, 45, 12, 12),
(47, 22, 529, 461, 0, 2721.46, -1963.18, 13.2107, 45, 12, 12),
(48, 22, 600, 413, 0, 2708.62, -1948.24, 13.2615, 180, 12, 12),
(49, 22, 509, 559, 0, 2726.14, -1955.42, 13.0396, 0, 12, 12),
(50, 22, 509, 0, 0, 2728.05, -1955.42, 13.0364, 0, 12, 12);

-- --------------------------------------------------------

--
-- Структура таблицы `frac_weapon`
--

CREATE TABLE `frac_weapon` (
  `fwID` int(11) NOT NULL,
  `Slot` int(11) NOT NULL,
  `Fraction` int(11) NOT NULL,
  `fwName` varchar(32) NOT NULL,
  `fwGunID` int(11) NOT NULL DEFAULT 0,
  `fwGunAmmo` int(11) NOT NULL DEFAULT 0,
  `fwArmor` int(11) NOT NULL DEFAULT 0,
  `fwRank` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `frac_weapon`
--

INSERT INTO `frac_weapon` (`fwID`, `Slot`, `Fraction`, `fwName`, `fwGunID`, `fwGunAmmo`, `fwArmor`, `fwRank`) VALUES
(1, 0, 1, 'Desert Eagle', 24, 21, 0, 1),
(2, 1, 1, 'Shotgun', 25, 30, 0, 1),
(3, 2, 1, 'MP5', 29, 70, 0, 1),
(4, 3, 1, 'M4A1', 31, 100, 0, 1),
(5, 4, 1, 'Дубинка', 3, 1, 0, 1),
(6, 5, 1, 'Бронежилет', 31, 1, 1, 1),
(7, 0, 2, 'Desert Eagle', 24, 21, 0, 1),
(8, 1, 2, 'Shotgun', 25, 30, 0, 1),
(9, 2, 2, 'MP5', 29, 70, 0, 1),
(10, 3, 2, 'M4A1', 31, 100, 0, 1),
(11, 4, 2, 'Дубинка', 3, 1, 0, 1),
(12, 5, 2, 'Бронежилет', 31, 1, 1, 1),
(13, 0, 3, 'Desert Eagle', 24, 21, 0, 1),
(14, 1, 3, 'Shotgun', 25, 30, 0, 1),
(15, 2, 3, 'MP5', 29, 70, 0, 1),
(16, 3, 3, 'M4A1', 31, 100, 0, 1),
(17, 4, 3, 'Дубинка', 3, 1, 0, 1),
(18, 5, 3, 'Бронежилет', 31, 1, 1, 1),
(19, 0, 4, 'Desert Eagle', 24, 21, 0, 1),
(20, 1, 4, 'SD Pistol', 23, 21, 0, 1),
(21, 2, 4, 'MP5', 29, 70, 0, 1),
(22, 3, 4, 'Rifle', 33, 20, 0, 1),
(23, 4, 4, 'Дымовая шашка', 17, 3, 0, 1),
(24, 5, 4, 'Спрей', 41, 100, 0, 1),
(25, 6, 4, 'Бронежилет', 31, 1, 1, 1),
(26, 7, 4, 'Дубинка', 3, 1, 0, 1),
(27, 8, 4, 'Маска', 99, 1, 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gangzone`
--

CREATE TABLE `gangzone` (
  `id` int(11) NOT NULL,
  `coord_one` float NOT NULL,
  `coord_two` float NOT NULL,
  `coord_three` float NOT NULL,
  `coord_four` float NOT NULL,
  `gang_owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `gangzone`
--

INSERT INTO `gangzone` (`id`, `coord_one`, `coord_two`, `coord_three`, `coord_four`, `gang_owner`) VALUES
(0, 1642.71, -2174.57, 1770.71, -2073.57, 21),
(1, 1770.71, -2174.57, 1898.71, -2073.57, 21),
(2, 1898.71, -2174.57, 2026.71, -2073.57, 21),
(3, 2026.71, -2174.57, 2154.71, -2073.57, 21),
(4, 2154.71, -2174.57, 2282.71, -2073.57, 21),
(5, 2282.71, -2174.57, 2410.71, -2073.57, 19),
(6, 2410.71, -2174.57, 2538.71, -2073.57, 19),
(7, 2538.71, -2174.57, 2666.71, -2073.57, 19),
(8, 2666.71, -2174.57, 2794.71, -2073.57, 19),
(9, 2794.71, -2174.57, 2922.71, -2073.57, 19),
(10, 1642.71, -2073.57, 1770.71, -1972.57, 21),
(11, 1770.71, -2073.57, 1898.71, -1972.57, 21),
(12, 2154.71, -2073.57, 2282.71, -1972.57, 21),
(13, 2282.71, -2073.57, 2410.71, -1972.57, 19),
(14, 2410.71, -2073.57, 2538.71, -1972.57, 19),
(15, 2538.71, -2073.57, 2666.71, -1972.57, 19),
(16, 2666.71, -2073.57, 2794.71, -1972.57, 19),
(17, 2794.71, -2073.57, 2922.71, -1972.57, 19),
(18, 1898.71, -1972.57, 2026.71, -1871.57, 21),
(19, 2026.71, -1972.57, 2154.71, -1871.57, 21),
(20, 2154.71, -1972.57, 2282.71, -1871.57, 21),
(21, 2282.71, -1972.57, 2410.71, -1871.57, 19),
(22, 2410.71, -1972.57, 2538.71, -1871.57, 19),
(23, 2538.71, -1972.57, 2666.71, -1871.57, 19),
(24, 2666.71, -1972.57, 2794.71, -1871.57, 22),
(25, 2794.71, -1972.57, 2922.71, -1871.57, 19),
(26, 1770.71, -1871.57, 1898.71, -1770.57, 18),
(27, 1898.71, -1871.57, 2026.71, -1770.57, 18),
(28, 2026.71, -1871.57, 2154.71, -1770.57, 21),
(29, 2154.71, -1871.57, 2282.71, -1770.57, 21),
(30, 2282.71, -1871.57, 2410.71, -1770.57, 20),
(31, 2410.71, -1871.57, 2538.71, -1770.57, 19),
(32, 2538.71, -1871.57, 2666.71, -1770.57, 19),
(33, 2666.71, -1871.57, 2794.71, -1770.57, 19),
(34, 2794.71, -1871.57, 2922.71, -1770.57, 19),
(35, 1642.71, -1770.57, 1770.71, -1669.57, 18),
(36, 1770.71, -1770.57, 1898.71, -1669.57, 18),
(37, 1898.71, -1770.57, 2026.71, -1669.57, 18),
(38, 2026.71, -1770.57, 2154.71, -1669.57, 20),
(39, 2154.71, -1770.57, 2282.71, -1669.57, 20),
(40, 2282.71, -1770.57, 2410.71, -1669.57, 20),
(41, 2410.71, -1770.57, 2538.71, -1669.57, 20),
(42, 2538.71, -1770.57, 2666.71, -1669.57, 19),
(43, 2666.71, -1770.57, 2794.71, -1669.57, 19),
(44, 2794.71, -1770.57, 2922.71, -1669.57, 19),
(45, 1642.71, -1669.57, 1770.71, -1568.57, 18),
(46, 1770.71, -1669.57, 1898.71, -1568.57, 18),
(47, 1898.71, -1669.57, 2026.71, -1568.57, 18),
(48, 2026.71, -1669.57, 2154.71, -1568.57, 20),
(49, 2154.71, -1669.57, 2282.71, -1568.57, 20),
(50, 2282.71, -1669.57, 2410.71, -1568.57, 20),
(51, 2410.71, -1669.57, 2538.71, -1568.57, 20),
(52, 2538.71, -1669.57, 2666.71, -1568.57, 19),
(53, 2666.71, -1669.57, 2794.71, -1568.57, 19),
(54, 2794.71, -1669.57, 2922.71, -1568.57, 19),
(55, 1642.71, -1568.57, 1770.71, -1467.57, 18),
(56, 1770.71, -1568.57, 1898.71, -1467.57, 18),
(57, 1898.71, -1568.57, 2026.71, -1467.57, 18),
(58, 2026.71, -1568.57, 2154.71, -1467.57, 20),
(59, 2154.71, -1568.57, 2282.71, -1467.57, 19),
(60, 2282.71, -1568.57, 2410.71, -1467.57, 19),
(61, 2410.71, -1568.57, 2538.71, -1467.57, 19),
(62, 2538.71, -1568.57, 2666.71, -1467.57, 19),
(63, 2666.71, -1568.57, 2794.71, -1467.57, 19),
(64, 2794.71, -1568.57, 2922.71, -1467.57, 19),
(65, 1642.71, -1467.57, 1770.71, -1366.57, 18),
(66, 1770.71, -1467.57, 1898.71, -1366.57, 18),
(67, 1898.71, -1467.57, 2026.71, -1366.57, 20),
(68, 2026.71, -1467.57, 2154.71, -1366.57, 20),
(69, 2154.71, -1467.57, 2282.71, -1366.57, 19),
(70, 2282.71, -1467.57, 2410.71, -1366.57, 19),
(71, 2410.71, -1467.57, 2538.71, -1366.57, 19),
(72, 2538.71, -1467.57, 2666.71, -1366.57, 19),
(73, 2666.71, -1467.57, 2794.71, -1366.57, 19),
(74, 2794.71, -1467.57, 2922.71, -1366.57, 19),
(75, 1642.71, -1366.57, 1770.71, -1265.57, 18),
(76, 1770.71, -1366.57, 1898.71, -1265.57, 18),
(77, 1898.71, -1366.57, 2026.71, -1265.57, 20),
(78, 2026.71, -1366.57, 2154.71, -1265.57, 19),
(79, 2154.71, -1366.57, 2282.71, -1265.57, 19),
(80, 2282.71, -1366.57, 2410.71, -1265.57, 19),
(81, 2410.71, -1366.57, 2538.71, -1265.57, 19),
(82, 2538.71, -1366.57, 2666.71, -1265.57, 19),
(83, 2666.71, -1366.57, 2794.71, -1265.57, 19),
(84, 2794.71, -1366.57, 2922.71, -1265.57, 19),
(85, 1642.71, -1265.57, 1770.71, -1164.57, 18),
(86, 1770.71, -1265.57, 1898.71, -1164.57, 18),
(87, 1898.71, -1265.57, 2026.71, -1164.57, 18),
(88, 2026.71, -1265.57, 2154.71, -1164.57, 18),
(89, 2154.71, -1265.57, 2282.71, -1164.57, 18),
(90, 2282.71, -1265.57, 2410.71, -1164.57, 18),
(91, 2410.71, -1265.57, 2538.71, -1164.57, 18),
(92, 2538.71, -1265.57, 2666.71, -1164.57, 18),
(93, 2666.71, -1265.57, 2794.71, -1164.57, 19),
(94, 2794.71, -1265.57, 2922.71, -1164.57, 18),
(95, 1642.71, -1164.57, 1770.71, -1063.57, 18),
(96, 1770.71, -1164.57, 1898.71, -1063.57, 18),
(97, 1898.71, -1164.57, 2026.71, -1063.57, 18),
(98, 2026.71, -1164.57, 2154.71, -1063.57, 18),
(99, 2154.71, -1164.57, 2282.71, -1063.57, 18),
(100, 2282.71, -1164.57, 2410.71, -1063.57, 18),
(101, 2410.71, -1164.57, 2538.71, -1063.57, 18),
(102, 2538.71, -1164.57, 2666.71, -1063.57, 18),
(103, 2666.71, -1164.57, 2794.71, -1063.57, 18),
(104, 2794.71, -1164.57, 2922.71, -1063.57, 18),
(105, 1642.71, -1063.57, 1770.71, -962.568, 18),
(106, 1770.71, -1063.57, 1898.71, -962.568, 18),
(107, 1898.71, -1063.57, 2026.71, -962.568, 18),
(108, 2026.71, -1063.57, 2154.71, -962.568, 18),
(109, 2154.71, -1063.57, 2282.71, -962.568, 18),
(110, 2282.71, -1063.57, 2410.71, -962.568, 18),
(111, 2410.71, -1063.57, 2538.71, -962.568, 18),
(112, 2538.71, -1063.57, 2666.71, -962.568, 18),
(113, 2666.71, -1063.57, 2794.71, -962.568, 18),
(114, 2794.71, -1063.57, 2922.71, -962.568, 18),
(115, 1642.71, -962.568, 1770.71, -861.568, 18),
(116, 1770.71, -962.568, 1898.71, -861.568, 18),
(117, 1898.71, -962.568, 2026.71, -861.568, 18),
(118, 2026.71, -962.568, 2154.71, -861.568, 18),
(119, 2154.71, -962.568, 2282.71, -861.568, 18),
(120, 2282.71, -962.568, 2410.71, -861.568, 18),
(121, 2410.71, -962.568, 2538.71, -861.568, 18),
(122, 2538.71, -962.568, 2666.71, -861.568, 18),
(123, 2666.71, -962.568, 2794.71, -861.568, 18),
(124, 2794.71, -962.568, 2922.71, -861.568, 18);

-- --------------------------------------------------------

--
-- Структура таблицы `givecash`
--

CREATE TABLE `givecash` (
  `id` int(10) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `Reason` varchar(50) NOT NULL,
  `Dollar` int(11) NOT NULL,
  `Cash` int(11) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `givecash`
--

INSERT INTO `givecash` (`id`, `Name`, `IP`, `Reason`, `Dollar`, `Cash`, `Date`) VALUES
(1, 'Klaus_Gurren', '146.120.175.220', 'промокод', 50000, 1000000, '2023-04-26 21:23:10'),
(2, 'Klaus_Gurren', '146.120.175.220', 'GiveMoney(adm)', 3333333, 1050000, '2023-05-05 13:50:19'),
(3, 'Klaus_Gurren', '146.120.175.220', 'GiveMoney(adm)', 3333333, 4383333, '2023-05-05 13:50:23'),
(4, 'Klaus_Gurren', '146.120.175.220', 'покупка бізнеса', -3000000, 7716666, '2023-05-05 13:50:29'),
(5, 'Klaus_Gurren', '146.120.175.220', 'покупка дома', -375000, 4716666, '2023-05-05 13:51:33'),
(6, 'Klaus_Gurren', '146.120.175.220', 'GiveMoney(adm)', 4444444, 4341666, '2023-05-05 13:52:37'),
(7, 'Klaus_Gurren', '146.120.175.220', 'покупка авто', -4500000, 8786110, '2023-05-05 13:52:46'),
(8, 'Klaus_Gurren', '146.120.175.220', 'покупка покращення в дом', -23750, 4286110, '2023-05-05 13:54:07'),
(9, 'Klaus_Gurren', '146.120.175.220', 'покупка покращення в дом', -57000, 4262360, '2023-05-05 13:54:12'),
(10, 'Klaus_Gurren', '146.120.175.220', 'покупка покращення в дом', -61750, 4205360, '2023-05-05 13:54:21'),
(11, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 4143610, '2023-05-05 13:55:13'),
(12, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 3993110, '2023-05-05 13:57:53'),
(13, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 3992610, '2023-05-05 13:58:15'),
(14, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 3992110, '2023-05-05 13:58:40'),
(15, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 3991610, '2023-05-05 13:58:54'),
(16, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 3991110, '2023-05-05 13:59:28'),
(17, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 3990610, '2023-05-05 14:01:21'),
(18, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 3990110, '2023-05-05 14:01:58'),
(19, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 3989610, '2023-05-05 14:02:09'),
(20, 'Klaus_Gurren', '146.120.175.220', 'GiveMoney(adm)', 44444444, 3989110, '2023-05-05 14:03:02'),
(21, 'Klaus_Gurren', '146.120.175.220', 'покупка авто', -4050000, 48433554, '2023-05-05 14:03:08'),
(22, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 44383554, '2023-05-05 14:06:07'),
(23, 'Klaus_Gurren', '146.120.175.220', 'продажа бізнеса', 2400000, 44383054, '2023-05-05 14:10:28'),
(24, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 46783054, '2023-05-05 14:10:48'),
(25, 'Klaus_Gurren', '146.120.175.220', 'покупка бізнеса', -3000000, 46782554, '2023-05-05 14:12:10'),
(26, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 43782554, '2023-05-05 14:16:48'),
(27, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 43782054, '2023-05-05 14:16:58'),
(28, 'Klaus_Gurren', '146.120.175.220', 'продажа дома', 300000, 43781554, '2023-05-05 14:17:49'),
(29, 'Klaus_Gurren', '146.120.175.220', 'покупка дома', -375000, 44081554, '2023-05-05 14:17:57'),
(30, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43706554, '2023-05-05 14:18:49'),
(31, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43706054, '2023-05-05 14:18:54'),
(32, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43705554, '2023-05-05 14:18:57'),
(33, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 43705054, '2023-05-05 14:19:06'),
(34, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 43704554, '2023-05-05 14:19:17'),
(35, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 43704054, '2023-05-05 14:20:35'),
(36, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43703554, '2023-05-05 14:20:43'),
(37, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43703054, '2023-05-05 14:20:49'),
(38, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43702554, '2023-05-05 14:20:51'),
(39, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 43702054, '2023-05-05 14:22:20'),
(40, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС до дому', -500, 43701554, '2023-05-05 15:39:00'),
(41, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43701054, '2023-05-05 15:39:20'),
(42, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 43700554, '2023-05-05 15:39:23'),
(43, 'Klaus_Gurren', '146.120.175.220', 'получение мед карты', -950, 43700054, '2023-05-05 16:34:47'),
(44, 'Klaus_Gurren', '146.120.175.220', 'продажа ТС в гос', 4000000, 43699104, '2023-05-05 17:35:23'),
(45, 'Klaus_Gurren', '146.120.175.220', 'покупка авто', -1980000, 47699104, '2023-05-05 17:35:34'),
(46, 'Klaus_Gurren', '146.120.175.220', 'Доставка ТС к дому', -500, 45719104, '2023-05-05 17:37:14'),
(47, 'Klaus_Gurren', '146.120.175.183', 'продажа бізнеса', 2400000, 0, '2023-05-06 14:13:54'),
(48, 'Klaus_Gurren', '146.120.175.183', 'аренда ТС', -4655, 45718604, '2023-05-06 17:21:43'),
(49, 'Klaus_Gurren', '146.120.175.183', 'покупка в 24-7', -1200, 45713949, '2023-05-06 20:20:03'),
(50, 'Klaus_Gurren', '146.120.175.183', 'аренда номера отель', -380, 45712749, '2023-05-07 11:34:34'),
(51, 'Klaus_Gurren', '146.120.175.183', 'покупка гос.номера', -950, 45712369, '2023-05-07 11:38:55'),
(52, 'Klaus_Gurren', '146.120.175.183', 'покупка гос.номера', -950, 45711419, '2023-05-07 11:39:09'),
(53, 'Klaus_Gurren', '146.120.175.183', 'смена пола', -47500, 45710469, '2023-05-07 11:46:59'),
(54, 'Klaus_Gurren', '146.120.175.183', 'ЗП збройного завод', 160, 45662969, '2023-05-07 11:59:05'),
(55, 'Klaus_Gurren', '146.120.175.183', 'ЗП нефтезавод', 220, 45663129, '2023-05-07 12:01:37'),
(56, 'Klaus_Gurren', '146.120.175.183', 'пожертвование', -666666, 45663349, '2023-05-07 13:09:21'),
(57, 'Klaus_Gurren', '146.120.175.193', 'покупка аксесуара', -2500, 44996, '2023-05-09 19:18:19'),
(58, 'Klaus_Gurren', '146.120.175.193', 'покупка аксесуара', -10000, 42496, '2023-05-09 19:18:40'),
(59, 'Klaus_Gurren', '146.120.175.193', 'покупка аксесуара', -4000, 32496, '2023-05-09 19:18:57'),
(60, 'Klaus_Gurren', '146.120.175.193', 'покупка аксесуара', -8000, 28496, '2023-05-09 19:19:15'),
(61, 'Klaus_Gurren', '146.120.175.193', 'покупка аксесуара', -10000, 20496, '2023-05-09 19:19:24'),
(62, 'Klaus_Gurren', '146.120.175.193', 'GiveMoney(adm)', 3333333, 10496, '2023-05-10 00:03:52'),
(63, 'Klaus_Gurren', '146.120.175.193', 'покупка будинку', -375000, 3343829, '2023-05-10 00:06:15'),
(64, 'Klaus_Gurren', '146.120.175.193', 'Доставка ТС к дому', -500, 2968829, '2023-05-10 00:07:35'),
(65, 'Klaus_Gurren', '146.120.175.193', 'Доставка ТС до дому', -500, 2968329, '2023-05-10 00:07:44'),
(66, 'Klaus_Gurren', '146.120.175.193', 'Доставка ТС до дому', -500, 2967829, '2023-05-10 00:07:50'),
(67, 'Klaus_Gurren', '146.120.175.193', 'Доставка ТС до дому', -500, 2967329, '2023-05-10 00:36:56'),
(68, 'Klaus_Gurren', '146.120.175.193', 'Покраска', -2000, 2966829, '2023-05-10 00:38:15'),
(69, 'Klaus_Gurren', '146.120.175.193', 'Тюннинг', -25000, 2964829, '2023-05-10 00:39:22'),
(70, 'Klaus_Gurren', '146.120.175.193', 'Тюннинг', -40000, 2939829, '2023-05-10 00:39:41'),
(71, 'Klaus_Gurren', '146.120.175.193', 'Тюннинг', -40000, 2899829, '2023-05-10 00:39:44'),
(72, 'Klaus_Gurren', '146.120.175.193', 'Тюннинг', -40000, 2859829, '2023-05-10 00:39:47'),
(73, 'Klaus_Gurren', '146.120.175.193', 'Тюннинг', -35000, 2819829, '2023-05-10 00:39:51'),
(74, 'Klaus_Gurren', '146.120.175.193', 'Тюннинг', -50000, 2784829, '2023-05-10 00:39:55'),
(75, 'Klaus_Gurren', '146.120.175.193', 'Доставка ТС к дому', -500, 2734829, '2023-05-10 00:41:24'),
(76, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -30000, 2734329, '2023-05-10 00:42:26'),
(77, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -50000, 2704329, '2023-05-10 00:42:29'),
(78, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -90000, 2654329, '2023-05-10 00:42:31'),
(79, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -120000, 2564329, '2023-05-10 00:42:36'),
(80, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -150000, 2444329, '2023-05-10 00:42:39'),
(81, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -30000, 2294329, '2023-05-10 00:42:44'),
(82, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -50000, 2264329, '2023-05-10 00:42:45'),
(83, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -50000, 2214329, '2023-05-10 00:42:47'),
(84, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -60000, 2164329, '2023-05-10 00:42:49'),
(85, 'Klaus_Gurren', '146.120.175.193', 'Покупка тюнинга (Perfomance)', -80000, 2104329, '2023-05-10 00:42:50'),
(86, 'Klaus_Gurren', '146.120.175.193', 'покупка ліцензії', -10000, 2024329, '2023-05-10 10:18:00');

-- --------------------------------------------------------

--
-- Структура таблицы `graffity`
--

CREATE TABLE `graffity` (
  `gID` int(4) NOT NULL,
  `gGang` int(10) NOT NULL,
  `coor0` float NOT NULL,
  `coor1` float NOT NULL,
  `coor2` float NOT NULL,
  `coor3` float NOT NULL,
  `coor4` float NOT NULL,
  `coor5` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `graffity`
--

INSERT INTO `graffity` (`gID`, `gGang`, `coor0`, `coor1`, `coor2`, `coor3`, `coor4`, `coor5`) VALUES
(1, 21, 2195.66, -1822.36, 13.6997, 0, 0, 178.4),
(2, 18, 2309.01, -1814.52, 14.1468, -1.1, 0, 92.3),
(3, 19, 2452.21, -1833.96, 3.24463, 0, 33.1, 87.9),
(4, 22, 2614.25, -1828.42, 2.64926, 0, 38.6, 0),
(5, 19, 2738.98, -1832.27, 11.9953, 0, 0, 174.9),
(6, 19, 2808.86, -1747.16, 11.9924, 0, 0, 107.9),
(7, 19, 2725.11, -1689.82, 12.2653, 0.099999, 0, -160.7),
(8, 22, 2576.53, -1723.81, 2.29583, 0, 13.3, 0),
(9, 20, 2458.47, -1744.69, 14.3034, 0, 0, -179.7),
(10, 19, 2377.61, -1705.84, 14.3957, 0, 0, 0),
(11, 22, 2251.41, -1696.76, 14.4171, 0, 0, 178.8),
(12, 22, 2137.82, -1729.66, 14.1599, 0, 0, -86.6),
(13, 21, 1976.08, -1724.57, 16.7888, 0, 0, 90.8),
(14, 18, 1850.82, -1736.28, 14.2135, 0, 0, 88.8),
(15, 21, 1673.86, -1719.81, 14.1368, 1.1, 0, -179.5),
(16, 21, 1672.3, -1614.28, 14.1669, 0, 0, -90.8),
(17, 22, 1868.38, -1628.65, 14.1224, 0, 0, -90.7),
(18, 18, 1987.36, -1599.31, 14.096, 0, 0, -137.3),
(19, 18, 2107.46, -1594.72, 14.13, 0, 0, 87.3),
(20, 19, 2197.41, -1598.51, 15.0375, 0, 0, -10.5),
(21, 18, 2308.84, -1634.74, 15.1835, 0, 0, 0),
(22, 19, 2479.44, -1632.4, 14.2498, 0, 0, 0),
(23, 22, 2629.18, -1599.17, 13.1049, 0, 0, 86),
(24, 19, 2712.86, -1586.84, 15.4542, 0, 0, -176.2),
(25, 22, 2810.68, -1647.26, 11.3337, 2, 0, 89.9),
(26, 22, 2853.65, -1498.38, 11.4168, 0, 0, -90.2),
(27, 19, 2765.16, -1536.28, 25.705, 0, 0, -85.6),
(28, 19, 2630.3, -1492.4, 16.8426, 0, 0, -25),
(29, 19, 2452.73, -1541.41, 24.9938, 0, 0, 90.3),
(30, 20, 2352.51, -1537.65, 24.6627, 0, 0, 0),
(31, 20, 2222.7, -1531.8, 20.3534, 0, 0, 178.1),
(32, 20, 2107.59, -1521.79, 3.28094, 0, 0, -108.8),
(33, 19, 1975.51, -1553.24, 14.4084, 0, 0, -137.5),
(34, 21, 1849.61, -1508.02, 4.27896, 0, 0, -85.7),
(35, 18, 1749.41, -1537.21, 14.0105, 0, 0, 0),
(36, 19, 1739.07, -1419.88, 16.2878, 0, 0, 0),
(37, 18, 1804, -1419.29, 13.9582, 1, 0, 92.3),
(38, 22, 1914.93, -1417.32, 14.1203, 0, 0, -87.7),
(39, 19, 2099.44, -1450.59, 24.6343, 0, 0, -89.4),
(40, 19, 2261.76, -1405.35, 24.42, 0, 0, 178.5),
(41, 19, 2375.37, -1417.41, 24.5317, 0, 0, -179.7),
(42, 19, 2497.76, -1429.26, 29.3038, 0.2, 0, 177.4),
(43, 22, 2581.02, -1437.67, 24.46, 0, 0, 0),
(44, 22, 2756.02, -1384.73, 39.5629, 0, 0, 0),
(45, 22, 2865.36, -1419.76, 11.664, 0, 0, 179.7),
(46, 21, 2848.98, -1340.38, 11.5291, 0, 0, -90.1),
(47, 19, 2709.64, -1333.09, 48.3854, 0, 0, -92.5),
(48, 22, 2605.51, -1348.62, 36.0526, 0, 0, 89.3999),
(49, 18, 2521.69, -1300.24, 35.7615, 0, 0, 0),
(50, 19, 2344.3, -1344.44, 24.4429, 0, 0, 0),
(51, 19, 2192.61, -1338.16, 24.8644, 0, 0, 93.2),
(52, 22, 2107.36, -1345.68, 24.4944, 0, 0, -89.9),
(53, 22, 1966.06, -1322.19, 24.4808, 0, 0, 0),
(54, 18, 1812.32, -1328.48, 15.1986, 0, 0, 179.6),
(55, 18, 1739.2, -1328, 14.0937, 0, 0, 0),
(56, 18, 1704.71, -1214.86, 15.5944, 0, 0, 0),
(57, 18, 1828.74, -1190.83, 24.3281, 0, 0, -89.5),
(58, 19, 1983.07, -1227.1, 20.4591, 0, 0, -171.7),
(59, 19, 2087.7, -1196.66, 24.4887, 0, 0, -89.3),
(60, 19, 2211.38, -1193.06, 26.3286, 0, 0, 91.7),
(61, 21, 2463.59, -1216.23, 31.9861, 0, 0, 92.5),
(62, 19, 2391.16, -1218.94, 27.3061, -1.2, 0, -177.7),
(63, 21, 2632.9, -1203.15, 50.8198, 0, 0, -173.3),
(64, 19, 2704.94, -1197.8, 70.5204, 0, 0, -89.8001),
(65, 20, 2820.75, -1204.67, 25.929, 0, 0, 90.1),
(66, 22, 2474.33, -1115.33, 44.6715, 0, 0, 89.7),
(67, 19, 2583.08, -1101.6, 67.4258, 0, 0, 141.6),
(68, 19, 2701.55, -1121.55, 70.3481, 0, 0, 0),
(69, 21, 2825.06, -1108.21, 25.452, 0, 0, -178.3),
(70, 20, 2366.94, -1132.61, 29.82, 0, 0, 0),
(71, 21, 2256.39, -1103.51, 38.6266, 0, 0, 152.8),
(72, 18, 2095.19, -1118.19, 27.2944, 0, 0, -89.2),
(73, 22, 1991.99, -1088.34, 25.0283, 0, 0, 91.3),
(74, 18, 1831.39, -1080.39, 24.754, 0, 0, 0),
(75, 22, 1720.07, -1111.95, 24.6959, 0, 0, 179.3),
(76, 22, 1662.73, -998.586, 24.9423, 0, 0, 117.5),
(77, 19, 1796.44, -1014.11, 24.7281, 0, 0, 76.7),
(78, 19, 1990.38, -988.816, 31.3167, 0, 0, 51.3001),
(79, 19, 2083.48, -993.37, 52.0583, 0, 0, -109.8),
(80, 19, 2217.34, -987.818, 63.1609, 0, 0, -112.4),
(81, 19, 2375, -1030.59, 54.4322, 0, 0, -89),
(82, 19, 2455.83, -1006.03, 59.7924, 0, 0, -87.2),
(83, 19, 2580.68, -1026.94, 70.1807, 0, 0, -91.9),
(84, 21, 2716.01, -1057.66, 62.6013, 0, -1.5, -89.7999),
(85, 21, 2858.8, -1036.59, 11.7569, 0, 0, 175.7),
(86, 21, 2862.04, -932.395, 11.4269, 0, 0, 178.5),
(87, 19, 2582.87, -946.597, 81.8749, 0, 0, -79.1001),
(88, 19, 2460.57, -941.458, 80.3606, 0, 0, -93.3),
(89, 19, 2091.04, -957.46, 52.5395, 0, 0, -107.8),
(90, 0, 1943.23, -943.676, 61.8657, 0, 0, 114.6),
(91, 22, 1877.42, -946.818, 55.832, 0, -10.2, 68.2999),
(92, 19, 1731.34, -952.41, 44.1016, 0, 0, 5.3),
(93, 19, 2864.22, -2121.92, 8.09001, 0, 0, -179.5),
(94, 22, 2704.22, -2138.04, 11.7289, 0, 0, 178.4),
(95, 19, 2589.51, -2120.14, 1.69727, 0, 0, -6.9),
(96, 19, 2495.61, -2121.54, 14.1469, 0, 0, -91.4),
(97, 22, 2339.5, -2150.7, 14.1938, 0.2, 0, 44.2),
(98, 22, 2222.41, -2155.88, 14.2791, 0, 0, -43.2),
(99, 21, 2110, -2141.15, 14.4828, 0, 0, -179.8),
(100, 21, 1973.37, -2156.58, 14.4306, 0.3, 0, 93.4999),
(101, 19, 1803.67, -2150.85, 14.3069, 0, 0, 91),
(102, 19, 1683.68, -1996.53, 14.8435, 0, 0, 178.4),
(103, 22, 1813.11, -2034.34, 14.2535, 0, 0, -179.4),
(104, 18, 2233.25, -2007.94, 14.0247, 0, 0, 0),
(105, 22, 2345.95, -2018.81, 14.1804, 0, 0, -92.3),
(106, 22, 2451.29, -1993.78, 14.3669, 0, 0, -178.1),
(107, 19, 2640.89, -2027.7, 14.1269, 0, 0, 179.8),
(108, 19, 2735.56, -2019.21, 14.1147, 0, 0, -91),
(109, 19, 2812.98, -2025.34, 11.3718, 0, 0, -179.7),
(110, 22, 2801.68, -1951.61, 14.4269, 0, 0, -179.8),
(111, 22, 2750.99, -1940.91, 14.1769, 0, 0, 86.5999),
(112, 22, 2633.03, -1944.63, 13.9769, 0, 0, 0),
(113, 21, 2453.17, -1942.32, 14.6169, 0, 0, -90.3),
(114, 22, 2330.38, -1950.52, 14.3721, 0, 0, -88.6),
(115, 18, 2245.62, -1943.77, 14.2387, 0, 0, -89.4999),
(116, 21, 2096.81, -1942.99, 14.0369, 0, 0, 89.8),
(117, 18, 1999.02, -1919.84, 14.1069, 0, 0, -179.9),
(118, 19, 1828.01, -1811.98, 4.80438, 0, 0, -104.3),
(119, 18, 1917.96, -1786.48, 14.2806, 0, 0, 86.4),
(120, 0, 2113.61, -1822.33, 14.0768, 0, 0, 90.6);

-- --------------------------------------------------------

--
-- Структура таблицы `greenzone`
--

CREATE TABLE `greenzone` (
  `id` int(11) NOT NULL,
  `grx` float NOT NULL,
  `gry` float NOT NULL,
  `grz` float NOT NULL,
  `grd` float NOT NULL,
  `grname` varchar(64) NOT NULL,
  `grvirt` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `greenzone`
--

INSERT INTO `greenzone` (`id`, `grx`, `gry`, `grz`, `grd`, `grname`, `grvirt`) VALUES
(1, 1755.82, -1904.05, 13.5643, 30, 'SP LS', 0),
(2, 2011.55, -2026.94, 13.5708, 30, 'SP LS 2', 0),
(3, -1968.7, 147.263, 27.7087, 0, 'SP SF', 0),
(4, 2835.56, 1271.52, 10.7805, 30, 'SP LV', 0),
(5, 2707.14, -2405.4, 13.508, 50, 'Ор.Завод', 0),
(6, 273.819, 1416.83, 10.446, 50, 'Нефтезавод', 0),
(7, -130.287, 3.28496, 3.11719, 40, 'Ябл.Сад', 0),
(8, 1480.7, -1711.27, 13.5469, 70, 'Мэрия', 0),
(9, -1351.69, 1928.81, 1083.58, 20, 'Инт мэрия', 44),
(10, 2186.56, 574.014, 1080.46, 50, 'МЧС', 20),
(11, 1299.34, -8.21256, 1000.9, 10, 'КПЗ', 40),
(12, 2068.66, 1710.12, 1113.79, 50, 'Казино', 58),
(13, 1183.3, -1324.49, 13.5775, 100, 'МЧС', 0),
(14, 853.776, -221.544, 1001.19, 30, 'Комп.Клуб', 2),
(15, 2162.83, 2158.05, 10.8203, 50, 'Казино улица', 0),
(16, 2070.78, 1710.49, 1113.78, 40, 'Казино | Инт', 58),
(17, 310.65, 2062.46, 1014.37, 30, 'Госпиталь | Army', 33),
(18, 2612.14, -2225.14, 13.3828, 50, 'Порт ЛС', 0),
(19, 2306.47, -2001.21, 13.5514, 2, 'Дуэль', 0),
(20, 2688.13, -2479.5, 13.4972, 20, 'Разгрузка О.З', 0),
(21, -399.625, -434.179, 16.2031, 25, 'Рыбалка', 0),
(22, -456.494, -90.4, 59.6191, 100, 'Лесопилка', 0),
(23, 1116.68, 1916.25, 10.7703, 50, 'Развоз.продуктов', 0),
(24, 1263.1, -18.5525, 1000.89, 150, 'ПД', 40),
(25, 1554.32, 504.863, 1070.43, 100, 'МЧС 2', 20),
(26, 733.976, -1519.69, 1415.41, 100, 'СМИ', 10),
(27, -1229.08, 1575.77, 1112.66, 50, 'АШ', 45),
(28, 831.071, 2.08068, 1004.18, 30, 'Центр Разв', 200),
(29, 222.759, -1846.57, 3.39014, 50, 'Санта Мария', 0),
(30, 2406.49, -33.2419, 1029.63, 30, 'Инта биза банк лс', 8),
(31, 2406.67, -33.4367, 1029.63, 30, 'Инта биза банка сф', 9),
(32, 2406.74, -32.8397, 1029.63, 30, 'Инта биза банка лв', 10);

-- --------------------------------------------------------

--
-- Структура таблицы `history`
--

CREATE TABLE `history` (
  `id` int(11) NOT NULL,
  `number_1` int(11) NOT NULL DEFAULT 0,
  `name_1` varchar(24) NOT NULL DEFAULT 'None',
  `name_2` varchar(24) NOT NULL DEFAULT 'None',
  `number_2` int(11) NOT NULL DEFAULT 0,
  `status` int(5) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `date` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `hotels`
--

CREATE TABLE `hotels` (
  `id` int(11) NOT NULL,
  `name` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL,
  `ownerid` int(11) NOT NULL,
  `owner` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL,
  `price` int(11) NOT NULL,
  `coast` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `level` int(11) NOT NULL,
  `day` int(11) NOT NULL DEFAULT 0,
  `bankday` int(11) NOT NULL DEFAULT 0,
  `bank` int(11) NOT NULL DEFAULT 0,
  `visitors` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `hotels`
--

INSERT INTO `hotels` (`id`, `name`, `ownerid`, `owner`, `price`, `coast`, `x`, `y`, `z`, `level`, `day`, `bankday`, `bank`, `visitors`) VALUES
(1, 'The Visage Hotel', 0, '', 2000000, 400, 2017.03, 1919.83, 12.3424, 6, 1542405838, 1400, 400, 3),
(2, 'The Radisson Hotel', 0, '', 2000000, 400, 327.8, -1512.05, 36.0325, 6, 1541553051, 0, 0, 1),
(3, 'Vank Hall in the Park', 0, '', 2000000, 400, -2426.19, 337.999, 36.9922, 6, 1542169535, 400, 0, 2),
(4, 'Rock Hotel', 0, '', 2000000, 400, 2628.1, 2349.29, 10.8203, 6, 1542130823, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `houses`
--

CREATE TABLE `houses` (
  `id` int(4) NOT NULL,
  `class` int(1) NOT NULL,
  `day` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `hint` int(3) NOT NULL,
  `improve` varchar(19) NOT NULL,
  `gun` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0',
  `skin` varchar(24) NOT NULL,
  `safecode` int(4) NOT NULL DEFAULT 0,
  `safemoney` int(11) NOT NULL,
  `drugs` int(11) NOT NULL,
  `medkit` int(11) NOT NULL DEFAULT 0,
  `products` int(3) NOT NULL,
  `close` tinyint(1) NOT NULL DEFAULT 0,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `r` float NOT NULL,
  `parkx` float NOT NULL,
  `parky` float NOT NULL,
  `parkz` float NOT NULL,
  `parkr` float NOT NULL,
  `ownerid` int(11) NOT NULL,
  `owner` varchar(24) NOT NULL,
  `peopleid1` int(11) NOT NULL,
  `peopleid2` int(11) NOT NULL,
  `peopleid3` int(11) NOT NULL,
  `people1` varchar(24) NOT NULL,
  `people2` varchar(24) NOT NULL,
  `people3` varchar(24) NOT NULL,
  `family` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;

--
-- Дамп данных таблицы `houses`
--

INSERT INTO `houses` (`id`, `class`, `day`, `price`, `hint`, `improve`, `gun`, `skin`, `safecode`, `safemoney`, `drugs`, `medkit`, `products`, `close`, `x`, `y`, `z`, `r`, `parkx`, `parky`, `parkz`, `parkr`, `ownerid`, `owner`, `peopleid1`, `peopleid2`, `peopleid3`, `people1`, `people2`, `people3`, `family`) VALUES
(1, 0, 0, 30000, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2370.17, -1034.65, 54.41, 182.27, 2380, -1033.32, 53.58, 141, 0, '', 0, 0, 0, '', '', '', 0),
(2, 0, 0, 30000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2335, -1045.9, 52.55, 359.36, 2330.93, -1057.5, 52.05, 268.57, 0, '', 0, 0, 0, '', '', '', 0),
(3, 0, 0, 30000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2297.63, -1053.16, 49.93, 161.29, 2305.53, -1057.54, 49.58, 105.2, 0, '', 0, 0, 0, '', '', '', 0),
(4, 0, 0, 41250, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2284.01, -1046.12, 49.88, 150.76, 2279.52, -1048.99, 49.14, 236.51, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(5, 0, 0, 33750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2389.2, -1037.23, 53.54, 206.57, 2394.46, -1044.18, 52.09, 135.6, 0, '', 0, 0, 0, '', '', '', 0),
(6, 0, 0, 48750, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2440.02, -1010.93, 54.34, 278.68, 2427.14, -1011.49, 54.04, 193.79, 0, '', 0, 0, 0, '', '', '', 0),
(7, 0, 0, 60000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2440.64, -1057.23, 54.73, 357.97, 2432.06, -1057.52, 54.04, 1.2, 0, '', 0, 0, 0, '', '', '', 0),
(8, 0, 0, 60000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2462.32, -1011.19, 60.11, 181.38, 2454.23, -1010.89, 59.47, 175.68, 0, '', 0, 0, 0, '', '', '', 0),
(9, 0, 0, 45000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2457.65, -1054.59, 59.95, 73.39, 2452.08, -1055.36, 59.44, 355.89, 0, '', 0, 0, 0, '', '', '', 0),
(10, 0, 0, 56250, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2491.24, -1012.27, 65.39, 68.19, 2480.98, -1022.8, 64.37, 149.22, 0, '', 0, 0, 0, '', '', '', 0),
(11, 0, 0, 56250, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2479.58, -1063.93, 66.99, 73.21, 2474.77, -1059.56, 66.51, 343.9, 0, '', 0, 0, 0, '', '', '', 0),
(12, 0, 0, 60000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2512.71, -1027.25, 70.08, 184.64, 2503.35, -1024.38, 69.79, 174.5, 0, '', 0, 0, 0, '', '', '', 0),
(13, 0, 0, 45000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2526.24, -1060.71, 69.97, 268.86, 2530.66, -1067.55, 69.27, 0.92, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(14, 0, 0, 45000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2534.36, -1063.31, 69.56, 89.06, 2536.38, -1054.74, 69.28, 269.03, 0, '', 0, 0, 0, '', '', '', 0),
(15, 0, 0, 48750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2526.92, -1033.61, 69.57, 177.22, 2535.93, -1028.23, 69.28, 178.2, 0, '', 0, 0, 0, '', '', '', 0),
(16, 0, 0, 48750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2549.31, -1032.25, 69.57, 265.22, 2547.48, -1040.09, 69.27, 90.41, 0, '', 0, 0, 0, '', '', '', 0),
(17, 0, 0, 52500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2579.6, -1033.29, 69.57, 176.72, 2584.25, -1040.39, 69.28, 89.43, 0, '', 0, 0, 0, '', '', '', 0),
(18, 0, 0, 48750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2561.81, -1034.48, 69.86, 87.55, 2570.45, -1028.33, 69.28, 177.97, 0, '', 0, 0, 0, '', '', '', 0),
(19, 0, 0, 60000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2576.58, -1070.64, 69.83, 85.83, 2568.28, -1064.59, 69.1, 348.79, 0, '', 0, 0, 0, '', '', '', 0),
(20, 0, 0, 60000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2582.92, -953.04, 81.38, 193.8, 2592.56, -948.56, 81.09, 194.99, 0, '', 0, 0, 0, '', '', '', 0),
(21, 0, 0, 48750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2581.39, -969.34, 81.36, 98.32, 2574.83, -971.89, 81.18, 12.25, 0, '', 0, 0, 0, '', '', '', 0),
(22, 0, 0, 48750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2552.14, -958.36, 82.61, 268.31, 2561.94, -955.33, 82.46, 190.35, 0, '', 0, 0, 0, '', '', '', 0),
(23, 0, 0, 48750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2517.96, -965.56, 82.32, 273.4, 2521.24, -960.09, 82.03, 180.88, 0, '', 0, 0, 0, '', '', '', 0),
(24, 0, 0, 48750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2499.52, -947.1, 82.47, 177.33, 2504.44, -944.6, 82.06, 178.34, 0, '', 0, 0, 0, '', '', '', 0),
(25, 0, 0, 48750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2491.98, -965.72, 82.54, 85.69, 2492.96, -951.87, 81.95, 269.5, 0, '', 0, 0, 0, '', '', '', 0),
(26, 0, 0, 48750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2472.05, -962.03, 80.52, 176.56, 2476.46, -960.77, 79.9, 179.57, 0, '', 0, 0, 0, '', '', '', 0),
(27, 0, 0, 48750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2454.28, -965.04, 80.07, 268.51, 2449.04, -969.73, 79.76, 271.1, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(28, 0, 0, 60000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2459.57, -947.8, 80.08, 176.62, 2468.14, -944.02, 79.79, 178.79, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(29, 0, 0, 67500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2572.28, -1091.73, 67.22, 45.01, 2562.85, -1093.87, 66.05, 45.04, 0, '', 0, 0, 0, '', '', '', 0),
(30, 0, 0, 60000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2519.14, -1113.14, 56.59, 272.08, 2524.61, -1113.69, 56.2, 353.4, 0, '', 0, 0, 0, '', '', '', 0),
(31, 0, 0, 67500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2470.79, -1105.21, 44.48, 337.55, 2474.44, -1096.54, 44.88, 262.92, 0, '', 0, 0, 0, '', '', '', 0),
(32, 0, 0, 67500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2457.03, -1102.21, 43.86, 356.79, 2452.22, -1108.76, 43.05, 0.12, 0, '', 0, 0, 0, '', '', '', 0),
(33, 0, 0, 67500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2438.61, -1105.66, 43.08, 357.61, 2435.27, -1092.96, 42.04, 268.87, 0, '', 0, 0, 0, '', '', '', 0),
(34, 0, 0, 60000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2407.94, -1106.86, 40.29, 0.72, 2410.86, -1096.35, 39.57, 281.04, 0, '', 0, 0, 0, '', '', '', 0),
(35, 0, 0, 60000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2373.99, -1139.03, 29.05, 176.9, 2369.09, -1147.7, 27.33, 89.59, 0, '', 0, 0, 0, '', '', '', 0),
(36, 1, 0, 135000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2394.92, -1133.64, 30.71, 177.5, 2399.6, -1135.79, 29.82, 181.49, 0, '', 0, 0, 0, 'None', '', '', 0),
(37, 0, 0, 60000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2488.01, -1135.33, 39.58, 175.59, 2491.1, -1142.68, 38.02, 91.82, 0, '', 0, 0, 0, '', '', '', 0),
(38, 0, 0, 60000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2510.45, -1132.56, 41.62, 89.97, 2507.39, -1142.61, 39.47, 90.37, 0, '', 0, 0, 0, '', '', '', 0),
(39, 1, 0, 135000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2550.18, -1197.4, 60.83, 3.94, 2558.01, -1193.92, 61.13, 0.37, 0, '', 0, 0, 0, '', '', '', 0),
(40, 1, 0, 135000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2520.69, -1197.89, 56.59, 359.35, 2528.73, -1193.84, 56.67, 359.99, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(41, 0, 0, 67500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2467.71, -1200.3, 36.81, 350.65, 2457.92, -1197.27, 35.98, 0.37, 0, '', 0, 0, 0, '', '', '', 0),
(42, 0, 0, 75000, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2472.92, -1238.22, 32.56, 176.2, 2473.04, -1249.61, 26.99, 90.04, 0, '', 0, 0, 0, '', '', '', 0),
(43, 0, 0, 75000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2491.99, -1239.12, 37.9, 175.09, 2491.45, -1248.96, 31.99, 90.42, 0, '', 0, 0, 0, '', '', '', 0),
(44, 0, 0, 71250, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2551.06, -1233.9, 49.33, 176.47, 2544.63, -1248.99, 41.11, 91.02, 0, '', 0, 0, 0, '', '', '', 0),
(45, 1, 0, 135000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2626.06, -1112.68, 67.84, 268.79, 2635.06, -1118.11, 66.93, 179.43, 0, '', 0, 0, 0, '', '', '', 0),
(46, 1, 0, 135000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2625.93, -1098.64, 69.36, 271.91, 2635.42, -1102.81, 68.66, 179.71, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(47, 1, 0, 135000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2627.74, -1085.25, 69.61, 288.58, 2635.28, -1089, 69.32, 180.24, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(48, 1, 0, 135000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2628.18, -1067.99, 69.61, 260.28, 2635.37, -1071.93, 69.32, 179.01, 0, '', 0, 0, 0, '', '', '', 0),
(49, 0, 0, 82500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2433.7, -1275.01, 24.75, 267.35, 2443.28, -1278.17, 23.7, 181.15, 0, '', 0, 0, 0, '', '', '', 0),
(50, 0, 0, 75000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2469.07, -1278.4, 30.36, 83.2, 2458.26, -1281.4, 23.7, 359.8, 0, '', 0, 0, 0, '', '', '', 0),
(51, 0, 0, 82500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2434.91, -1289.25, 25.34, 271.56, 2443.53, -1292.57, 23.7, 181.35, 0, '', 0, 0, 0, '', '', '', 0),
(52, 1, 0, 150000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2434.05, -1303.42, 25, 273.3, 2443.8, -1308.52, 23.69, 180.4, 0, '', 0, 0, 0, 'None', '', '', 0),
(53, 1, 0, 150000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2434.23, -1320.89, 24.96, 265.93, 2443.56, -1325.82, 23.7, 180.66, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(54, 0, 0, 90000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2470.25, -1295.49, 30.23, 91.4, 2458.21, -1282.45, 23.7, 359.36, 0, '', 0, 0, 0, '', '', '', 0),
(55, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2250.35, -1280.14, 25.47, 183.38, 2255.94, -1285.98, 24.49, 179.72, 0, '', 0, 0, 0, '', '', '', 0),
(56, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2230.2, -1280.06, 25.62, 182.68, 2227.65, -1293.47, 23.68, 89.37, 0, '', 0, 0, 0, '', '', '', 0),
(57, 0, 0, 97500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2208.02, -1280.91, 25.12, 178.73, 2211.89, -1293.31, 23.67, 90.32, 0, '', 0, 0, 0, '', '', '', 0),
(58, 0, 0, 101250, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2191.39, -1275.98, 25.15, 176.09, 2196.5, -1284.71, 23.97, 180.75, 0, '', 0, 0, 0, '', '', '', 0),
(59, 0, 0, 90000, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2191.97, -1239.1, 24.48, 356.84, 2196.93, -1228.35, 23.67, 269.18, 0, '', 0, 0, 0, '', '', '', 0),
(60, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2209.79, -1240.14, 24.48, 359.47, 2211.84, -1228.12, 23.67, 269.45, 0, '', 0, 0, 0, '', '', '', 0),
(61, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2229.86, -1241.37, 25.65, 356.17, 2223.64, -1235.89, 24.3, 0.52, 0, '', 0, 0, 0, '', '', '', 0),
(62, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2250, -1238.81, 25.89, 5.94, 2242.25, -1235.4, 24.33, 359.87, 0, '', 0, 0, 0, '', '', '', 0),
(63, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2153.74, -1243.71, 25.36, 2.08, 2148.4, -1236.79, 24.05, 0.81, 0, '', 0, 0, 0, '', '', '', 0),
(64, 0, 0, 97500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2133.49, -1232.86, 24.42, 0.85, 2131.88, -1228.16, 23.68, 269.55, 0, '', 0, 0, 0, '', '', '', 0),
(65, 0, 0, 97500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2111.08, -1244.16, 25.85, 4.96, 2105.21, -1237.75, 24.29, 0.21, 0, '', 0, 0, 0, '', '', '', 0),
(66, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2090.75, -1235.05, 26.01, 359.78, 2095.15, -1228.02, 23.68, 270.01, 0, '', 0, 0, 0, '', '', '', 0),
(67, 0, 0, 101250, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2091.01, -1277.95, 26.17, 185, 2095.36, -1285.08, 24.62, 180.19, 0, '', 0, 0, 0, '', '', '', 0),
(68, 0, 0, 108750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2111.23, -1279.07, 25.83, 182.2, 2102.52, -1284.22, 24.55, 180.04, 0, '', 0, 0, 0, '', '', '', 0),
(69, 0, 0, 97500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2100.86, -1321.83, 25.95, 357.87, 2096.08, -1317.72, 24.51, 359.89, 0, '', 0, 0, 0, '', '', '', 0),
(70, 1, 0, 337500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2126.75, -1320.77, 26.62, 0.66, 2135.98, -1318.57, 24.54, 359.69, 0, '', 0, 0, 0, '', '', '', 0),
(71, 0, 0, 97500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2132.33, -1280.15, 25.89, 179.64, 2137.9, -1284.77, 24.37, 180.44, 0, '', 0, 0, 0, '', '', '', 0),
(72, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2150.25, -1285.14, 24.52, 177, 2147.39, -1293.26, 23.68, 89.88, 0, '', 0, 0, 0, '', '', '', 0),
(73, 0, 0, 97500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2147.6, -1366.23, 25.97, 175.09, 2147.2, -1376.81, 23.68, 89.39, 0, '', 0, 0, 0, '', '', '', 0),
(74, 0, 0, 97500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2185.16, -1363.79, 26.15, 180.02, 2188.99, -1377.07, 23.7, 89.43, 0, '', 0, 0, 0, '', '', '', 0),
(75, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2202.7, -1363.72, 26.19, 180.93, 2209.16, -1376.64, 23.7, 89.31, 0, '', 0, 0, 0, '', '', '', 0),
(76, 0, 0, 97500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2196.47, -1404.09, 25.61, 267.62, 2205.39, -1406.32, 23.68, 179.2, 0, '', 0, 0, 0, '', '', '', 0),
(77, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2188.65, -1419.36, 26.15, 270.9, 2205.24, -1416.26, 23.68, 179.22, 0, '', 0, 0, 0, '', '', '', 0),
(78, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2191.27, -1455.83, 25.98, 268.5, 2198.83, -1452.55, 24.63, 269.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(79, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2190.56, -1470.4, 25.91, 270.63, 2184.5, -1465.67, 25.24, 269.93, 0, '', 0, 0, 0, '', '', '', 0),
(80, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2232.76, -1469.69, 24.25, 178.25, 2230.35, -1476.58, 23.54, 89.43, 0, '', 0, 0, 0, '', '', '', 0),
(81, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2247.62, -1469.33, 24.48, 173.14, 2246, -1476.68, 23.14, 88.87, 0, '', 0, 0, 0, '', '', '', 0),
(82, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2264.12, -1469.33, 24.37, 175.04, 2261.74, -1476.48, 22.67, 89.41, 0, '', 0, 0, 0, '', '', '', 0),
(83, 0, 0, 101250, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2230.27, -1397.24, 24.57, 358.52, 2231.07, -1391.59, 23.7, 269.1, 0, '', 0, 0, 0, '', '', '', 0),
(84, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2243.42, -1396.83, 24.24, 1.64, 2246.79, -1391.47, 23.7, 269.79, 0, '', 0, 0, 0, '', '', '', 0),
(85, 0, 0, 101250, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2256.39, -1397.24, 24.57, 3.61, 2260.46, -1392.38, 23.7, 270.21, 0, '', 0, 0, 0, '', '', '', 0),
(86, 0, 0, 116250, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2151.05, -1400.64, 26.12, 88.81, 2146.27, -1408.35, 24.45, 90.09, 0, '', 0, 0, 0, '', '', '', 0),
(87, 0, 0, 116250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2150.81, -1419.03, 25.92, 82.06, 2156.03, -1423.71, 25.24, 88.61, 0, '', 0, 0, 0, '', '', '', 0),
(88, 0, 0, 116250, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2149.84, -1433.74, 26.07, 85.51, 2141.74, -1437.46, 24.29, 90.14, 0, '', 0, 0, 0, '', '', '', 0),
(89, 0, 0, 116250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2152.1, -1446.32, 26.1, 91.98, 2146.54, -1454.47, 24.61, 89.42, 0, '', 0, 0, 0, '', '', '', 0),
(90, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2148.81, -1484.84, 26.62, 91.64, 2136.57, -1483.87, 23.68, 359.64, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(91, 0, 0, 116250, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2146.68, -1470.52, 26.04, 87.69, 2136.6, -1471.27, 23.66, 359.08, 0, '', 0, 0, 0, '', '', '', 0),
(92, 0, 0, 116250, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2129.55, -1361.93, 25.8, 177.74, 2137.56, -1367.84, 24.53, 179.86, 0, '', 0, 0, 0, '', '', '', 0),
(93, 1, 0, 600000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2486.49, -1644.62, 14.07, 181.61, 2489.69, -1651.44, 13.19, 89.65, 0, '', 0, 0, 0, '', '', '', 0),
(94, 1, 0, 600000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2459.52, -1691.55, 13.54, 2.88, 2462.16, -1683.48, 13.24, 260.98, 0, '', 0, 0, 0, '', '', '', 0),
(95, 1, 0, 637500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2523.06, -1679.26, 15.49, 82.65, 2516.05, -1671.77, 13.53, 57.93, 0, '', 0, 0, 0, 'None', '', '', 0),
(96, 1, 0, 300000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2514.2, -1691.48, 14.04, 40.41, 2510.13, -1680.46, 13.24, 136.57, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(97, 1, 0, 300000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2513.63, -1650.49, 14.35, 133.84, 2504.75, -1655.06, 13.27, 56.94, 0, '', 0, 0, 0, '', '', '', 0),
(98, 0, 0, 127500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2498.4, -1642.36, 14.11, 180.39, 2499.25, -1650.78, 13.23, 169.42, 0, '', 0, 0, 0, '', '', '', 0),
(99, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2469.5, -1646.45, 13.78, 180.05, 2466.14, -1651.64, 13.17, 90.45, 0, '', 0, 0, 0, '', '', '', 0),
(100, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2451.89, -1641.52, 14.06, 177.24, 2443.46, -1638.72, 13.13, 179.09, 0, '', 0, 0, 0, '', '', '', 0),
(101, 0, 0, 123750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2413.75, -1646.92, 14.01, 183.16, 2417.48, -1651.26, 13.25, 89.96, 0, '', 0, 0, 0, '', '', '', 0),
(102, 0, 0, 116250, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2409.01, -1674.75, 14.35, 357.71, 2405.56, -1665.97, 13.25, 269.62, 0, '', 0, 0, 0, '', '', '', 0),
(103, 0, 0, 120000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2393.34, -1646.15, 13.9, 183.99, 2403.38, -1644.14, 13.25, 180, 0, '', 0, 0, 0, '', '', '', 0),
(104, 1, 0, 187500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2384.83, -1675.72, 15.24, 354.8, 2387.39, -1666.5, 13.25, 270.17, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(105, 1, 0, 187500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2368.37, -1675.28, 14.16, 358.75, 2361.73, -1671.66, 13.25, 359.05, 0, '', 0, 0, 0, '', '', '', 0),
(106, 1, 0, 165000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2362.78, -1643.25, 14.35, 173.67, 2372.45, -1644.35, 13.22, 181.48, 0, '', 0, 0, 0, '', '', '', 0),
(107, 1, 0, 225000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2326.98, -1682.05, 14.92, 270.23, 2328.71, -1677.34, 14.13, 269.56, 0, '', 0, 0, 0, '', '', '', 0),
(108, 1, 0, 172500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2282.07, -1641.48, 15.88, 179.91, 2271.28, -1643.23, 15.06, 178.64, 0, '', 0, 0, 0, '', '', '', 0),
(109, 1, 0, 165000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2257.08, -1644.04, 15.8, 171.85, 2253.12, -1650.42, 15.18, 75.24, 0, '', 0, 0, 0, 'None', '', '', 0),
(110, 0, 0, 127500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2307.1, -1679.08, 14.33, 356.57, 2302.8, -1666.66, 14.37, 268.74, 0, '', 0, 0, 0, '', '', '', 0),
(111, 1, 0, 225000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2385.36, -1711.77, 14.24, 186.31, 2389.95, -1714.4, 13.31, 179.82, 0, '', 0, 0, 0, 'None', '', '', 0),
(112, 0, 0, 120000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2524.2, -1998.33, 14.11, 140.08, 2530.08, -2008.19, 13.25, 90.12, 0, '', 0, 0, 0, '', '', '', 0),
(113, 0, 0, 120000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2522.81, -2018.83, 14.07, 41.86, 2531.54, -2011.87, 13.25, 89.51, 0, '', 0, 0, 0, '', '', '', 0),
(114, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2507.8, -2020.93, 14.21, 357.76, 2505.03, -2016.81, 13.25, 268.75, 0, '', 0, 0, 0, '', '', '', 0),
(115, 0, 0, 112500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2508.27, -1998.47, 13.9, 177.22, 2503.3, -2002.28, 13.25, 89.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(116, 0, 0, 112500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2486.61, -2021.43, 13.99, 357.42, 2489.62, -2017.18, 13.25, 269.58, 0, '', 0, 0, 0, '', '', '', 0),
(117, 0, 0, 105000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2483.47, -1995.45, 13.83, 178.27, 2480.79, -2002.52, 13.25, 89.71, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(118, 0, 0, 120000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2465.11, -1995.85, 14.01, 176.62, 2467, -2002.27, 13.25, 89.71, 0, '', 0, 0, 0, '', '', '', 0),
(119, 0, 0, 112500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2465.31, -2020.68, 14.12, 358.22, 2462.91, -2016.79, 13.25, 268.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(120, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2437.94, -2020.75, 13.9, 355.25, 2441.09, -2016.64, 13.25, 269.98, 0, '', 0, 0, 0, '', '', '', 0),
(121, 1, 0, 150000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2067.14, -1731.8, 14.2, 271.68, 2063.89, -1738.96, 13.25, 269.96, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(122, 1, 0, 142500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2066.33, -1717.05, 14.13, 270.94, 2074.85, -1714.17, 13.25, 179.15, 0, '', 0, 0, 0, '', '', '', 0),
(123, 1, 0, 262500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2065.18, -1703.55, 14.14, 271.93, 2065.73, -1694.51, 13.25, 270.02, 0, '', 0, 0, 0, '', '', '', 0),
(124, 1, 0, 225000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2018.12, -1703.13, 14.23, 88.76, 2015.83, -1707.65, 13.25, 89.99, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(125, 1, 0, 187500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2016.04, -1717.03, 14.12, 84.8, 2008.84, -1721.35, 13.25, 359.16, 0, '', 0, 0, 0, '', '', '', 0),
(126, 1, 0, 225000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2015.22, -1732.68, 14.23, 81.18, 2013.75, -1737.5, 13.25, 90.28, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(127, 1, 0, 337500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1980.48, -1718.96, 17.03, 264.5, 1979.14, -1710.21, 15.67, 270.61, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(128, 1, 0, 337500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1981, -1682.93, 17.05, 271.56, 1987.88, -1674.8, 14.68, 269.71, 0, '', 0, 0, 0, '', '', '', 0),
(129, 1, 0, 187500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2013.47, -1656.23, 14.13, 82.07, 2009.93, -1659.6, 13.26, 359.99, 0, '', 0, 0, 0, '', '', '', 0),
(130, 1, 0, 187500, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2016.52, -1641.65, 14.11, 88.81, 2017.67, -1648.87, 13.25, 89.09, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(131, 1, 0, 187500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2018.05, -1630.05, 14.04, 87.16, 2008.94, -1632.93, 13.25, 359.6, 0, '', 0, 0, 0, '', '', '', 0),
(132, 1, 0, 187500, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2011.7, -1594.04, 13.58, 200.83, 2014.96, -1597.89, 13.27, 159.21, 0, '', 0, 0, 0, '', '', '', 0),
(133, 1, 0, 187500, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2002.51, -1594.05, 13.57, 207.56, 2005.95, -1599.21, 13.26, 178.7, 0, '', 0, 0, 0, 'None', 'None', '', 0),
(134, 1, 0, 165000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1972.98, -1559.96, 13.63, 213.31, 1980.17, -1556.95, 13.34, 157.46, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(135, 1, 0, 165000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1958.54, -1560.47, 13.59, 223.74, 1964.09, -1563.05, 13.31, 135.09, 0, '', 0, 0, 0, '', '', '', 0),
(136, 1, 0, 165000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1986.59, -1605.04, 13.53, 233.91, 1989.39, -1612.36, 13.22, 343.6, 0, '', 0, 0, 0, '', '', '', 0),
(137, 1, 0, 187500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2067.78, -1628.71, 14.2, 268.87, 2074.12, -1626.25, 13.25, 179.26, 0, '', 0, 0, 0, '', '', '', 0),
(138, 1, 0, 187500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2067.58, -1643.7, 14.13, 268.7, 2064.03, -1636.56, 13.25, 269.78, 0, '', 0, 0, 0, '', '', '', 0),
(139, 1, 0, 187500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2066.74, -1656.44, 14.13, 271.33, 2074.01, -1653.15, 13.25, 178.42, 0, '', 0, 0, 0, '', '', '', 0),
(140, 1, 0, 165000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1938.41, -1911.33, 15.25, 88.14, 1941.07, -1925.11, 13.25, 89.45, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(141, 1, 0, 165000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1928.54, -1915.9, 15.25, 182.13, 1932.05, -1924.78, 13.25, 89.29, 0, '', 0, 0, 0, '', '', '', 0),
(142, 1, 0, 165000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1913.53, -1911.9, 15.25, 176.2, 1908.06, -1924.74, 13.25, 89.76, 0, '', 0, 0, 0, '', '', '', 0),
(143, 1, 0, 165000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1891.86, -1914.39, 15.25, 178.83, 1894.14, -1925.48, 13.25, 89.19, 0, '', 0, 0, 0, 'None', '', '', 0),
(144, 1, 0, 165000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1872.36, -1911.78, 15.25, 180.8, 1868.41, -1924.92, 13.25, 89.97, 0, '', 0, 0, 0, 'None', '', '', 0),
(145, 1, 0, 165000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1853.95, -1914.37, 15.25, 175.1, 1846.29, -1924.96, 13.25, 89.9, 0, '', 0, 0, 0, 'None', '', '', 0),
(146, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1684.72, -2098.26, 13.83, 185.6, 1698.95, -2083.13, 13.25, 178.56, 0, '', 0, 0, 0, '', '', '', 0),
(147, 0, 0, 127500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1695.62, -2125.73, 13.81, 357.83, 1704.8, -2129.35, 13.25, 358.74, 0, '', 0, 0, 0, '', '', '', 0),
(148, 0, 0, 127500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1711.55, -2101.23, 14.02, 182.96, 1724.88, -2097.24, 13.25, 179.93, 0, '', 0, 0, 0, '', '', '', 0),
(149, 0, 0, 127500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1714.93, -2125.34, 14.05, 357.16, 1714.12, -2120.17, 13.25, 268.75, 0, '', 0, 0, 0, '', '', '', 0),
(150, 0, 0, 127500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1734.61, -2130.35, 14.02, 1.01, 1724.93, -2127.3, 13.25, 358.99, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(151, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1734.02, -2098.09, 14.03, 173.14, 1747.5, -2097.76, 13.25, 180.26, 0, '', 0, 0, 0, '', '', '', 0),
(152, 0, 0, 127500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1761.27, -2125.34, 14.05, 357.44, 1744.85, -2127.44, 13.25, 359.21, 0, '', 0, 0, 0, '', '', '', 0),
(153, 0, 0, 127500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1762.3, -2102.09, 13.85, 177.24, 1772.96, -2097.32, 13.25, 179.81, 0, '', 0, 0, 0, '', '', '', 0),
(154, 0, 0, 127500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1782.32, -2126.32, 14.06, 359.73, 1772.12, -2127.36, 13.25, 359.86, 0, '', 0, 0, 0, '', '', '', 0),
(155, 0, 0, 127500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1781.38, -2101.27, 14.05, 178.61, 1785.12, -2105.91, 13.25, 89.32, 0, '', 0, 0, 0, '', '', '', 0),
(156, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1802.02, -2099.03, 14.02, 181.73, 1805.44, -2105.4, 13.25, 89.4, 0, '', 0, 0, 0, '', '', '', 0),
(157, 1, 0, 142500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1804.16, -2124.78, 13.94, 0.37, 1793.35, -2128.85, 13.25, 0.05, 0, '', 0, 0, 0, '', '', '', 0),
(158, 1, 0, 150000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1851.89, -2134.96, 15.38, 177.18, 1855.7, -2143.99, 13.25, 90.49, 0, '', 0, 0, 0, '', '', '', 0),
(159, 1, 0, 150000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1872.28, -2132.9, 15.48, 175.69, 1876.86, -2143.8, 13.25, 91.68, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(160, 1, 0, 150000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1894.12, -2133.2, 15.46, 179.97, 1898.8, -2144.05, 13.25, 90.67, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(161, 1, 1587300116, 157500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1895.52, -2068.82, 15.66, 359.43, 1899.52, -2060.04, 13.25, 269.6, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(162, 1, 0, 157500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1873.68, -2070.66, 15.49, 358.11, 1876.95, -2060.1, 13.25, 269.78, 0, '', 0, 0, 0, 'None', '', '', 0),
(163, 1, 0, 157500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1851.77, -2070.36, 15.48, 359.75, 1854.44, -2059.53, 13.25, 269.52, 0, '', 0, 0, 0, 'None', '', '', 0),
(164, 1, 0, 202500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2091.67, -1184.41, 27.05, 177.57, 2087.6, -1194.54, 23.56, 88.7, 0, '', 0, 0, 0, '', '', '', 0),
(165, 1, 0, 213750, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2092.13, -1166.47, 26.58, 93.66, 2085.53, -1170.31, 24.56, 87.8, 0, '', 0, 0, 0, 'None', '', '', 0),
(166, 1, 0, 213750, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2095.24, -1145.17, 26.59, 82.54, 2089.99, -1140.95, 25.27, 89.09, 0, '', 0, 0, 0, '', '', '', 0),
(167, 1, 0, 210000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2093.86, -1122.78, 27.68, 178.18, 2079.01, -1119.21, 23.95, 0.56, 0, '', 0, 0, 0, '', '', '', 0),
(168, 1, 0, 217500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2045.53, -1116.53, 26.36, 359.78, 2051.96, -1119.67, 24.46, 180.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(169, 1, 0, 262500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2022.89, -1120.37, 26.42, 183.6, 2018.76, -1128.4, 24.68, 88.14, 0, '', 0, 0, 0, '', '', '', 0),
(170, 1, 0, 300000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1999.92, -1114.17, 27.12, 177.5, 1999.15, -1128.55, 25.23, 89.54, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(171, 1, 0, 262500, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1955.21, -1115.24, 27.83, 271.53, 1958.3, -1128.13, 25.63, 88.7, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(172, 1, 0, 262500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1921.39, -1115.14, 27.08, 267.31, 1918.27, -1128.23, 24.64, 88.91, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(173, 1, 0, 262500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1906.05, -1113.02, 26.66, 180.44, 1910.79, -1118.01, 25.42, 177.79, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(174, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1885.99, -1113.59, 26.27, 265.56, 1889.37, -1128.43, 23.91, 90.18, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(175, 0, 0, 63750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1891.77, -1070.34, 23.93, 268.72, 1892.74, -1084.14, 23.69, 90.45, 0, '', 0, 0, 0, '', '', '', 0),
(176, 0, 0, 63750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1895.81, -1064.89, 23.93, 87.72, 1893.34, -1051.17, 23.54, 276.75, 0, '', 0, 0, 0, '', '', '', 0),
(177, 0, 0, 63750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1916.88, -1064.87, 24.12, 94.03, 1915.21, -1050.98, 23.68, 269.87, 0, '', 0, 0, 0, '', '', '', 0),
(178, 0, 0, 63750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1912.61, -1070.72, 24.23, 271.85, 1915.25, -1082.63, 24.01, 88.24, 0, '', 0, 0, 0, '', '', '', 0),
(179, 0, 0, 63750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1939.17, -1066.37, 24.41, 99.28, 1938.47, -1053.59, 23.87, 260.88, 0, '', 0, 0, 0, '', '', '', 0),
(180, 0, 0, 63750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1934.14, -1071.47, 24.41, 252.59, 1934.85, -1083.99, 24.33, 85.06, 0, '', 0, 0, 0, '', '', '', 0),
(181, 0, 0, 63750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1959.47, -1070.04, 24.79, 70.98, 1959.12, -1057.48, 24.08, 255.09, 0, '', 0, 0, 0, '', '', '', 0),
(182, 0, 0, 63750, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1954.45, -1075.15, 24.79, 255.87, 1953.93, -1088.48, 24.83, 81.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(183, 0, 0, 93750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2023.1, -1053.02, 25.59, 245.66, 2022.74, -1060.08, 24.37, 69.09, 0, '', 0, 0, 0, '', '', '', 0),
(184, 0, 0, 93750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2035.93, -1059.33, 25.65, 245.82, 2035.16, -1066.47, 24.46, 66.57, 0, '', 0, 0, 0, '', '', '', 0),
(185, 0, 0, 93750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2050.7, -1065.79, 25.78, 242.2, 2046.94, -1070.46, 24.53, 65.86, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(186, 0, 0, 108750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2083.16, -1039.82, 32.13, 157.31, 2073.68, -1035.49, 32.93, 68.18, 0, '', 0, 0, 0, '', '', '', 0),
(187, 0, 0, 108750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2077.49, -1057.02, 31.26, 323.45, 2072.42, -1051.64, 32.02, 236.5, 0, '', 0, 0, 0, '', '', '', 0),
(188, 0, 0, 108750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2093.72, -1047.38, 30.02, 138.54, 2088.42, -1045.61, 30.29, 54.79, 0, '', 0, 0, 0, '', '', '', 0),
(189, 0, 0, 108750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2091.61, -1068.21, 28.07, 311.92, 2089.63, -1063.17, 28.16, 228.36, 0, '', 0, 0, 0, '', '', '', 0),
(190, 0, 0, 108750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2099.76, -1051.68, 28.81, 141.65, 2100.24, -1055.25, 27.66, 48.8, 0, '', 0, 0, 0, '', '', '', 0),
(191, 0, 0, 93750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2105.43, -1056.13, 27.15, 147.08, 2115.9, -1059.36, 25.46, 138.57, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(192, 0, 0, 108750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2101.64, -1075.78, 25.85, 312.06, 2093.69, -1075.49, 25.99, 332.93, 0, '', 0, 0, 0, '', '', '', 0),
(193, 0, 0, 108750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2108.93, -1082.33, 25.4, 326.7, 2114.92, -1084.89, 24.19, 234.01, 0, '', 0, 0, 0, '', '', '', 0),
(194, 0, 0, 116250, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2140.6, -1082.6, 24.95, 151.33, 2134.18, -1080.8, 23.97, 55.94, 0, '', 0, 0, 0, '', '', '', 0),
(195, 0, 0, 116250, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2145.07, -1084.58, 25.03, 149.19, 2153.8, -1089.77, 24.83, 67.9, 0, '', 0, 0, 0, '', '', '', 0),
(196, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2207.51, -1100.55, 31.55, 222.8, 2207.2, -1108.34, 25.69, 162.88, 0, '', 0, 0, 0, '', '', '', 0),
(197, 0, 0, 90000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2287.55, -1080.99, 48.17, 344.43, 2293.39, -1082.76, 47.41, 258.5, 0, '', 0, 0, 0, '', '', '', 0),
(198, 0, 0, 90000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2278.86, -1077.38, 48.16, 334.06, 2274.22, -1073.71, 47.43, 244.14, 0, '', 0, 0, 0, '', '', '', 0),
(199, 1, 0, 225000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2259.47, -1019.22, 59.29, 229.76, 2264, -1039.21, 51.68, 136.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(200, 0, 0, 97500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2218.96, -1031.74, 60.18, 348.93, 2223.95, -1029.39, 59.06, 236.94, 0, '', 0, 0, 0, '', '', '', 0),
(201, 0, 0, 97500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2208.25, -1026.67, 61.34, 357.31, 2209.85, -1022.32, 60.52, 244.12, 0, '', 0, 0, 0, '', '', '', 0),
(202, 0, 0, 78750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2142.82, -978.07, 61.37, 253.41, 2138.2, -991.04, 60.3, 72.51, 0, '', 0, 0, 0, '', '', '', 0),
(203, 0, 0, 78750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2154.13, -979.81, 63.29, 72.21, 2150.77, -994.78, 62.12, 75.33, 0, '', 0, 0, 0, '', '', '', 0),
(204, 0, 0, 86250, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2131.88, -973.78, 59.78, 75.9, 2138.37, -990.85, 60.32, 71.08, 0, '', 0, 0, 0, '', '', '', 0),
(205, 0, 0, 82500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2122.12, -970.45, 58.2, 238.16, 2120.56, -985.65, 56.85, 73.07, 0, '', 0, 0, 0, '', '', '', 0),
(206, 1, 0, 150000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2750.31, -1205.73, 67.4844, 87.6743, 2745.09, -1208.54, 66.46, 178.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(207, 1, 0, 150000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2750.39, -1222.21, 64.6, 268.58, 2745.36, -1225.28, 63.44, 179.09, 0, '', 0, 0, 0, '', '', '', 0),
(208, 1, 0, 150000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2750.58, -1238.56, 61.52, 94.05, 2745.34, -1242.44, 60.4, 179.7, 0, '', 0, 0, 0, '', '', '', 0),
(209, 1, 0, 187500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2696.6, -1990.26, 14.22, 178.39, 2684.48, -1991.8, 13.26, 179.56, 0, '', 0, 0, 0, '', '', '', 0),
(210, 1, 0, 187500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2672.82, -1989.14, 14.32, 190.27, 2671.22, -1997.07, 13.25, 89.77, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(211, 1, 0, 187500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2653.04, -1989.47, 13.9988, 184.084, 2652.91, -1997.27, 13.25, 270.89, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(212, 1, 0, 202500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2637.01, -1991.45, 14.32, 215.89, 2641.05, -1998.85, 13.25, 178.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(213, 1, 0, 202500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2635.39, -2012.58, 14.14, 304.09, 2643.61, -2010.25, 13.25, 270.81, 0, '', 0, 0, 0, '', '', '', 0),
(214, 1, 0, 187500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2673.33, -2020.28, 14.16, 0.49, 2673.64, -2011, 13.25, 270.5, 0, '', 0, 0, 0, 'None', '', '', 0),
(215, 1, 0, 187500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2695.34, -2020.75, 14.02, 323.97, 2685.17, -2019.68, 13.24, 0.86, 0, '', 0, 0, 0, 'None', '', '', 0),
(216, 1, 0, 206250, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2308.95, -1714.34, 14.98, 182.66, 2309.78, -1727.25, 13.16, 270.7, 0, '', 0, 0, 0, 'None', '', '', 0),
(217, 1, 0, 206250, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2326.66, -1716.7, 14.23, 186.25, 2319.3, -1719.21, 13.25, 179.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(218, 0, 0, 60000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2383.71, -1366.26, 24.49, 96.8, 2378.18, -1366.93, 23.69, 0.2, 0, '', 0, 0, 0, '', '', '', 0),
(219, 0, 0, 78750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2389.92, -1346.04, 25.07, 92.42, 2378.04, -1348.51, 23.7, 0.58, 0, '', 0, 0, 0, '', '', '', 0),
(220, 0, 0, 60000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2387.86, -1328.34, 25.12, 91.33, 2378.36, -1327.01, 23.7, 0.3, 0, '', 0, 0, 0, '', '', '', 0),
(221, 0, 0, 60000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2388.65, -1279.66, 25.12, 95.55, 2377.59, -1277.14, 23.7, 0.7, 0, '', 0, 0, 0, '', '', '', 0),
(222, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2242.01, -1881.77, 14.23, 172.56, 2241.79, -1887.74, 13.25, 89.62, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(223, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2269.17, -1881.92, 14.23, 198.01, 2269.32, -1887.72, 13.25, 90.17, 0, '', 0, 0, 0, '', '', '', 0),
(224, 1, 0, 262500, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2296.75, -1881.97, 14.23, 177.33, 2296.37, -1887.68, 13.3, 90.24, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(225, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2238.21, -1907.15, 14.93, 279.5, 2233.01, -1901.62, 13.25, 89.9, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(226, 1, 0, 262500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2261.47, -1906.83, 14.93, 13.17, 2260.32, -1901.36, 13.25, 87.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(227, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2284.66, -1906.74, 14.92, 355.16, 2283.94, -1901.45, 13.27, 90.38, 0, '', 0, 0, 0, 'None', '', '', 0),
(228, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2333.36, -1883.74, 15, 1.74, 2321.21, -1897.06, 13.31, 358.73, 0, '', 0, 0, 0, 'None', '', '', 0),
(229, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2333.41, -1943.27, 14.9688, 176.662, 2334.16, -1948.19, 13.28, 90.41, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(230, 1, 0, 750000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1421.77, -886.11, 50.68, 357.95, 1429.32, -882.38, 50.49, 0.84, 0, '', 0, 0, 0, 'None', '', '', 0),
(231, 2, 0, 1875000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1468.62, -906.07, 54.83, 2.95, 1463.69, -900.78, 54.54, 359.31, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(232, 2, 0, 1875000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1540.37, -851.32, 64.33, 90.3, 1532.33, -841.44, 65.05, 92.12, 0, '', 0, 0, 0, 'None', '', '', 0),
(233, 1, 0, 750000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1534.92, -800.19, 72.84, 81.64, 1529.35, -813.09, 71.59, 87.93, 0, '', 0, 0, 0, 'None', '', '', 0),
(234, 1, 0, 750000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1527.74, -772.66, 80.57, 133.62, 1514.17, -767.65, 80.05, 139.27, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(235, 3, 1587300142, 6000000, 2, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1496.83, -687.99, 95.56, 162.21, 1515.01, -694.68, 94.45, 90.53, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(236, 2, 0, 2250000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1442.65, -628.94, 95.71, 176.51, 1460.3, -634.82, 95.54, 180.25, 0, '', 0, 0, 0, 'None', '', '', 0),
(237, 2, 1587300238, 2250000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1332.14, -633.35, 109.13, 15.62, 1354.78, -630.2, 108.83, 16.79, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(238, 3, 0, 6000000, 29, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1298.54, -798.26, 84.14, 181.67, 1249.04, -805.34, 83.84, 179.56, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(239, 2, 0, 1125000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1112.52, -742.02, 100.13, 102.61, 1107.48, -732.12, 100.38, 88, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(240, 3, 0, 2250000, 2, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1093.79, -807.05, 107.42, 6.04, 1087.59, -782.38, 107.07, 92.57, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(241, 2, 0, 1125000, 35, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1034.8, -812.99, 101.85, 20.18, 1028.64, -809.26, 101.55, 20.77, 0, '', 0, 0, 0, 'None', 'None', '', 0),
(242, 2, 0, 1500000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 989.65, -828.6, 95.46, 19.18, 978.42, -828.71, 95.64, 27.88, 0, '', 0, 0, 0, '', '', '', 0),
(243, 2, 0, 1125000, 12, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 937.85, -848.59, 93.59, 20.23, 929.98, -849.12, 93.24, 24.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(244, 3, 0, 2250000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 836.09, -894.82, 68.76, 319.68, 829.06, -886.18, 68.47, 272.73, 0, '', 0, 0, 0, '', '', '', 0),
(245, 2, 0, 1275000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 827.78, -858.12, 70.33, 200.01, 831.64, -857.38, 69.63, 198.29, 0, '', 0, 0, 0, 'None', '', '', 0),
(246, 1, 0, 712500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 724.83, -999.31, 52.73, 330.03, 725.85, -995.24, 52.35, 60.85, 0, '', 0, 0, 0, '', '', '', 0),
(247, 2, 0, 900000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 700.28, -1060.04, 49.42, 62.37, 686.74, -1072.9, 49.23, 60.54, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(248, 1, 0, 712500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 645.83, -1117.41, 44.2, 57.6, 635.48, -1121.08, 44.77, 43.51, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(249, 1, 0, 750000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 553.07, -1200.22, 44.83, 24.7, 541.62, -1200.79, 44.09, 290.78, 0, '', 0, 0, 0, 'None', '', '', 0),
(250, 1, 0, 525000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 432.01, -1253.9, 51.58, 22.89, 421.52, -1260.35, 51.28, 23.64, 0, '', 0, 0, 0, '', '', '', 0),
(251, 1, 0, 637500, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 398.21, -1271.3, 50.01, 25.19, 406.07, -1263.65, 50.23, 23.3, 0, '', 0, 0, 0, '', '', '', 0),
(252, 1, 0, 450000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 355.14, -1281.14, 53.7, 15.32, 357.21, -1274.81, 53.52, 297.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(253, 3, 0, 2250000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 298.83, -1338.46, 53.44, 39.83, 301.66, -1327.29, 53.15, 123.92, 0, '', 0, 0, 0, 'None', '', '', 0),
(254, 3, 0, 3750000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 254.43, -1367.14, 53.1, 321.53, 251.6, -1358.55, 52.81, 305.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(255, 2, 0, 1275000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 228.12, -1405.47, 51.6, 317.25, 225.62, -1397.91, 51.29, 56.32, 0, '', 0, 0, 0, 'None', '', '', 0),
(256, 1, 0, 562500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 142.66, -1470.31, 25.21, 337.81, 148.13, -1466.85, 25.13, 50.03, 0, '', 0, 0, 0, 'None', '', '', 0),
(257, 3, 0, 6000000, 2, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 189.63, -1308.27, 70.24, 270.37, 167.21, -1341.43, 69.39, 179.37, 0, '', 0, 0, 0, '', '', '', 0),
(258, 3, 0, 3750000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 219.31, -1249.8, 78.33, 203.74, 216.9, -1279.68, 62.41, 163.22, 0, '', 0, 0, 0, 'None', '', '', 0),
(259, 3, 0, 3750000, 29, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 253.17, -1269.94, 74.4, 42.13, 245.11, -1264.15, 68.7, 131.41, 0, '', 0, 0, 0, '', '', '', 0),
(260, 3, 0, 3750000, 2, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 251.47, -1220.23, 76.1, 220.69, 261.21, -1220.89, 74.52, 183.28, 0, '', 0, 0, 0, '', '', '', 0),
(261, 3, 0, 4875000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 300.25, -1154.59, 81.34, 142.55, 287.79, -1156.75, 80.61, 226.55, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(262, 1, 0, 750000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 352.48, -1197.79, 76.51, 39.57, 346.34, -1197.51, 76.22, 37.43, 0, '', 0, 0, 0, '', '', '', 0),
(263, 2, 0, 937500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 416.87, -1154.2, 76.68, 149.46, 406.12, -1152.32, 76.77, 146.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(264, 2, 0, 1500000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 470.89, -1163.59, 67.21, 193.29, 475.32, -1176.56, 62.96, 286.91, 0, '', 0, 0, 0, '', '', '', 0),
(265, 2, 1554036508, 2325000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 497.41, -1095, 82.35, 4.53, 479.84, -1090.23, 82.12, 357.26, 0, '', 0, 0, 0, 'None', 'None', '', 0);
INSERT INTO `houses` (`id`, `class`, `day`, `price`, `hint`, `improve`, `gun`, `skin`, `safecode`, `safemoney`, `drugs`, `medkit`, `products`, `close`, `x`, `y`, `z`, `r`, `parkx`, `parky`, `parkz`, `parkr`, `ownerid`, `owner`, `peopleid1`, `peopleid2`, `peopleid3`, `people1`, `people2`, `people3`, `family`) VALUES
(266, 2, 0, 1200000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 559.05, -1076.44, 72.92, 29.04, 563.9, -1064.93, 73.55, 28.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(267, 1, 0, 600000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 785.98, -828.56, 70.28, 7.82, 796.39, -842.36, 60.32, 190.47, 0, '', 0, 0, 0, '', '', '', 0),
(268, 2, 0, 1125000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 808.27, -759.41, 76.53, 270.7, 813.45, -768.11, 76.42, 286.44, 0, '', 0, 0, 0, '', '', '', 0),
(269, 1, 0, 600000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 848.08, -745.58, 94.96, 304.18, 851.11, -741.8, 94.67, 220.42, 0, '', 0, 0, 0, '', '', '', 0),
(270, 3, 0, 2250000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 891.15, -782.97, 101.31, 5.71, 883.15, -783.55, 100.95, 295.65, 0, '', 0, 0, 0, 'None', 'None', '', 0),
(271, 1, 0, 637500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 867.64, -717.6, 105.67, 338.24, 871.89, -705.82, 106.02, 240.45, 0, '', 0, 0, 0, '', '', '', 0),
(272, 2, 0, 1350000, 34, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 897.92, -677.25, 116.89, 237.07, 911.17, -664.25, 116.64, 235.9, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(273, 2, 0, 1275000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 946.15, -710.72, 122.61, 34.5, 942.17, -711.16, 121.92, 27.56, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(274, 3, 1587300832, 4200000, 8, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 980.69, -677.13, 121.97, 35.81, 1010.52, -659.67, 120.84, 34.15, 0, '', 0, 0, 0, 'None', '', '', 0),
(275, 3, 0, 2250000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1045.03, -642.8, 120.11, 1.76, 1038.8, -639.75, 119.82, 11.01, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(276, 3, 0, 3750000, 29, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1094.98, -647.87, 113.64, 359.95, 1088.53, -641.02, 112.85, 272.38, 0, '', 0, 0, 0, '', '', '', 0),
(277, 2, 0, 975000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1411.13, -920.91, 38.42, 172.91, 1420.99, -922.59, 35.73, 172.76, 0, '', 0, 0, 0, 'None', '', '', 0),
(278, 2, 0, 975000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1440.71, -926.2, 39.64, 175.97, 1451.45, -928.94, 36.89, 171.4, 0, '', 0, 0, 0, 'None', '', '', 0),
(279, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1325.97, -1067.96, 31.55, 267.01, 1332.24, -1061.07, 28.11, 269.54, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(280, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1326.28, -1090.54, 27.97, 263.72, 1331.15, -1081.63, 24.96, 269.86, 0, '', 0, 0, 0, '', '', '', 0),
(281, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1285.21, -1090.48, 28.25, 90.33, 1279.15, -1098.82, 25.73, 88.73, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(282, 1, 0, 487500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1285.21, -1067.29, 31.67, 90.83, 1280.8, -1058.57, 29.19, 92.04, 0, '', 0, 0, 0, '', '', '', 0),
(283, 1, 0, 487500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1242.01, -1076.25, 31.55, 272.83, 1248.12, -1068.13, 28.78, 269.02, 0, '', 0, 0, 0, '', '', '', 0),
(284, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1242.32, -1099.57, 27.97, 275.3, 1246.19, -1107.6, 25.23, 270.09, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(285, 1, 0, 487500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1183.47, -1075.98, 31.67, 88.29, 1178.05, -1067.41, 28.69, 90.89, 0, '', 0, 0, 0, '', '', '', 0),
(286, 1, 0, 487500, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1183.41, -1098.79, 28.25, 80.06, 1177.68, -1108.18, 24.93, 91.78, 0, '', 0, 0, 0, '', '', '', 0),
(287, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1142.12, -1092.92, 28.18, 272.76, 1147.57, -1100.82, 25.39, 270.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(288, 1, 0, 487500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1141.8, -1069.98, 31.76, 269.47, 1148.39, -1061.43, 29.39, 271.61, 0, '', 0, 0, 0, 'None', '', '', 0),
(289, 1, 0, 487500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1103.33, -1092.4, 28.46, 90.5, 1098.49, -1101.31, 25.23, 90.73, 0, '', 0, 0, 0, 'None', '', '', 0),
(290, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1103.39, -1069.43, 31.88, 87.86, 1098.41, -1060.76, 29.35, 90.62, 0, '', 0, 0, 0, 'None', '', '', 0),
(291, 2, 0, 825000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1068.44, -1081.27, 27.55, 256.55, 1075.47, -1084.68, 26.22, 179.5, 0, '', 0, 0, 0, 'None', '', '', 0),
(292, 2, 0, 975000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 791.47, -1753.21, 13.46, 171.69, 786.92, -1761.9, 13.01, 85.83, 0, '', 0, 0, 0, '', '', '', 0),
(293, 1, 0, 487500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 769.22, -1745.97, 13.07, 90.43, 762.48, -1750.24, 12.45, 180.64, 0, '', 0, 0, 0, '', '', '', 0),
(294, 1, 0, 487500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 769.16, -1696.51, 5.15, 92.4, 762.16, -1699.25, 4.74, 182.29, 0, '', 0, 0, 0, '', '', '', 0),
(295, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 767.97, -1655.63, 5.6, 85.55, 759.15, -1654.84, 4.36, 186.73, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(296, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 766.8, -1605.73, 13.8, 89.89, 758.52, -1606.65, 12.95, 0.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(297, 2, 0, 975000, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 797.36, -1729.34, 13.54, 258.4, 803.21, -1734.51, 13.25, 179.46, 0, '', 0, 0, 0, '', '', '', 0),
(298, 1, 0, 487500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 794.1, -1707.48, 14.03, 275.83, 803.38, -1710.3, 13.25, 180.66, 0, '', 0, 0, 0, 'None', '', '', 0),
(299, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 794.98, -1691.98, 14.46, 356.1, 803.79, -1687.95, 13.25, 179.11, 0, '', 0, 0, 0, 'None', '', '', 0),
(300, 2, 0, 900000, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 790.93, -1661.25, 13.48, 178.26, 790.21, -1667.45, 13.18, 89.04, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(301, 2, 0, 900000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 652.55, -1694.02, 14.54, 99.13, 645.73, -1691.46, 14.6, 353.95, 0, '', 0, 0, 0, '', '', '', 0),
(302, 1, 0, 487500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 653.47, -1714.2, 14.76, 85.47, 642.56, -1712.36, 14.08, 351.46, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(303, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 657.22, -1652.51, 15.4, 68.35, 652.96, -1657.12, 14.35, 88.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(304, 2, 0, 900000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 653.13, -1619.6, 15, 90.39, 645.7, -1617.93, 14.87, 3.58, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(305, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 692.78, -1602.67, 15.04, 356.03, 688.28, -1598.88, 13.8, 0.21, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(306, 3, 0, 6000000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 691.46, -1275.82, 13.56, 84.79, 669.73, -1264.82, 13.24, 180.01, 0, '', 0, 0, 0, '', '', '', 0),
(307, 3, 0, 6000000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 725.47, -1276.19, 13.64, 275.34, 734.75, -1264.82, 13.26, 0.29, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(308, 2, 0, 2250000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 316.11, -1769.64, 4.63, 176.33, 322.4, -1765.93, 4.31, 179.49, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(309, 1, 0, 750000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 281, -1767.22, 4.55, 176.25, 281.89, -1776.58, 3.94, 89.59, 0, '', 0, 0, 0, '', '', '', 0),
(310, 1, 0, 750000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 206.85, -1768.93, 4.36, 178.78, 206.66, -1775.45, 3.41, 89.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(311, 1, 0, 750000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 167.75, -1759.03, 6.79, 92.15, 168.29, -1776.38, 3.84, 89.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(312, 1, 0, 412500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 902.9, -1815.57, 13.3, 174.07, 906.57, -1822.47, 12.27, 83.08, 0, '', 0, 0, 0, '', '', '', 0),
(313, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 914.52, -1816.84, 13.3, 171.92, 915.64, -1824.02, 12.23, 83.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(314, 1, 0, 412500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 926.27, -1818.05, 13.32, 172.08, 926.65, -1824.85, 12.29, 84.03, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(315, 1, 0, 412500, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 961.07, -1823.97, 13.32, 160.89, 960.94, -1831.46, 12.3, 76.57, 0, '', 0, 0, 0, '', '', '', 0),
(316, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 972.42, -1826.87, 13.33, 165.89, 973.02, -1833.89, 12.31, 74.91, 0, '', 0, 0, 0, '', '', '', 0),
(317, 1, 0, 412500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 983.66, -1829.62, 13.32, 151.57, 984.3, -1837.13, 12.31, 75.79, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(318, 1, 0, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 992.61, -1817.62, 13.89, 340.74, 996.07, -1812.75, 13.92, 253.41, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(319, 1, 0, 412500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 981.24, -1814.88, 13.88, 347.15, 982.13, -1808.46, 13.94, 255.51, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(320, 1, 0, 412500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 969.83, -1811.96, 13.89, 354.05, 971.41, -1805.7, 13.96, 256.15, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(321, 1, 0, 412500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 958.17, -1809.18, 13.88, 350.59, 958.72, -1803.27, 13.98, 256.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(322, 1, 0, 412500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 933.64, -1805.2, 13.84, 5.95, 934.6, -1797.69, 13.47, 260.14, 0, '', 0, 0, 0, '', '', '', 0),
(323, 1, 0, 412500, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 921.99, -1803.89, 13.83, 356.4, 923.47, -1796.02, 13.25, 266.09, 0, '', 0, 0, 0, '', '', '', 0),
(324, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 910.35, -1802.58, 13.79, 1.83, 910.54, -1794.56, 13.25, 267.3, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(325, 0, 0, 93750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -91.07, -1592.59, 3, 299.22, -87.41, -1602.21, 2.31, 299.82, 0, '', 0, 0, 0, '', '', '', 0),
(326, 0, 0, 93750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -89.31, -1564.59, 3, 234.56, -97.77, -1569.66, 2.32, 214.71, 0, '', 0, 0, 0, '', '', '', 0),
(327, 0, 0, 93750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -68.85, -1545.72, 3, 147.53, -60.02, -1550.59, 2.31, 142.12, 0, '', 0, 0, 0, '', '', '', 0),
(328, 0, 0, 127500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -607.68, -1073.99, 23.5, 174.07, -593.65, -1085.07, 23.3, 239.52, 0, '', 0, 0, 0, '', '', '', 0),
(329, 0, 0, 127500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -601.19, -1065.49, 23.4, 185.98, -587.47, -1075.61, 23.14, 234.39, 0, '', 0, 0, 0, '', '', '', 0),
(330, 0, 0, 127500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -594.79, -1056.98, 23.35, 174.3, -581.32, -1066.63, 23.12, 235.17, 0, '', 0, 0, 0, '', '', '', 0),
(331, 0, 0, 127500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -588.6, -1048.54, 23.34, 175.94, -576.09, -1056.95, 23.34, 235.27, 0, '', 0, 0, 0, '', '', '', 0),
(332, 0, 0, 127500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -582.64, -1040.19, 23.58, 176.92, -570.6, -1047.54, 23.57, 234.21, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(333, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -576.77, -1031.97, 23.82, 174.6, -564.25, -1038.54, 23.73, 235.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(334, 2, 0, 937500, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2622.27, 71.63, 4.33, 269.84, -2615.61, 74.94, 4.04, 269.05, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(335, 1, 0, 300000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2619.39, 67.86, 4.51, 265.73, -2616.07, 61.17, 4.04, 269.28, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(336, 1, 1539265308, 412500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2619.37, 57.78, 4.33, 267.7, -2615.58, 51.67, 4.04, 269.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(337, 2, 0, 937500, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2623.32, -99.28, 7.2, 279.28, -2615.86, -96.63, 4.04, 269.63, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(338, 2, 0, 937500, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2622.25, -112.37, 4.34, 271.94, -2611.11, -107.64, 4.04, 179.56, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(339, 1, 0, 375000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2620.85, -120.09, 7.2, 2.15, -2611.14, -119.58, 4.04, 179.46, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(340, 1, 0, 300000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2619.65, -127.75, 4.7, 265.49, -2615.63, -131.21, 4.04, 270, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(341, 1, 0, 337500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2620.89, -134.58, 5, 265.22, -2615.67, -140.1, 4.04, 269.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(342, 1, 1539445705, 450000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2620.68, -146.35, 7.2, 180.73, -2616.15, -143.84, 4.04, 269.79, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(343, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2619.11, -153.61, 4.33, 270.54, -2615.83, -159.61, 4.04, 270.35, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(344, 2, 0, 937500, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2622.23, -169.44, 4.34, 269.62, -2610.86, -168.77, 4.04, 179.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(345, 1, 1538082200, 375000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2620.89, -173.21, 5, 268.21, -2615.7, -178.51, 4.04, 269.45, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(346, 1, 1537617545, 375000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2620.9, -185.84, 7.2, 0.23, -2614.89, -188.41, 4.04, 269.17, 0, '', 0, 0, 0, '', '', '', 0),
(347, 2, 0, 937500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2622.24, -197.84, 4.33, 266.85, -2617.22, -203.17, 4.04, 269.31, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(348, 2, 0, 937500, 21, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2686.93, -188.16, 7.2, 84.25, -2694.6, -190.95, 4.04, 90.56, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(349, 1, 0, 562500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2688.14, -175.18, 4.34, 86.45, -2698.81, -179.87, 4.03, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(350, 1, 0, 375000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2689.48, -167.41, 7.2, 175.84, -2694.45, -164.92, 4.04, 89.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(351, 1, 0, 300000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2690.59, -159.78, 4.7, 105.43, -2694.16, -156.31, 4.04, 89.89, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(352, 1, 0, 337500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2689.34, -152.73, 5, 80.58, -2694.34, -147.38, 4.04, 88.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(353, 1, 1538255393, 412500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2689.57, -141.18, 7.2, 359.48, -2694.31, -143.69, 4.04, 90.19, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(354, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2690.94, -133.81, 4.33, 90.6, -2694, -127.87, 4.04, 89.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(355, 1, 0, 562500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2688.09, -118, 4.34, 70.36, -2699.46, -122.21, 4.03, 0.31, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(356, 1, 0, 412500, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2689.38, -114.17, 5, 94.7, -2693.9, -108.95, 4.04, 89.6, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(357, 1, 0, 225000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2689.48, -101.7, 7.2, 171.09, -2694.24, -99.17, 4.04, 89.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(358, 2, 1541438382, 937500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2688.31, -89.39, 4.33, 96.07, -2688.47, -84.02, 4.04, 89, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(359, 1, 1535945283, 375000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2689.46, 56.98, 7.2, 180.62, -2694.09, 59.43, 4.04, 89.39, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(360, 1, 0, 300000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2690.57, 64.61, 4.7, 80.92, -2694.39, 68.15, 4.04, 90.52, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(361, 1, 0, 412500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2689.44, 74.63, 7.2, 3.51, -2694.14, 72.06, 4.04, 90.17, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(362, 1, 0, 225000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2689.53, 96.21, 7.2, 178.7, -2694.02, 98.77, 4.04, 89.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(363, 1, 1541916424, 300000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2690.86, 102.25, 4.51, 90.68, -2693.84, 108.65, 4.04, 89.32, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(364, 1, 0, 600000, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2686.91, 115.37, 7.19, 90.18, -2695.05, 112.67, 4.04, 89.53, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(365, 1, 0, 300000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2690.57, 123.78, 4.7, 91.82, -2694.22, 127.41, 4.04, 89.76, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(366, 2, 1534927561, 900000, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2688.02, 137.14, 4.34, 92.21, -2698.38, 131.75, 4.03, 359.14, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(367, 2, 0, 900000, 12, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2623.45, 131.6, 7.2, 268.45, -2616.04, 134.73, 4.04, 270.04, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(368, 1, 0, 225000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2620.73, 120.91, 7.2, 359.91, -2616.26, 118.51, 4.04, 269.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(369, 1, 0, 337500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2620.92, 114.94, 5, 278.8, -2616.24, 109.61, 4.04, 268.58, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(370, 1, 0, 337500, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2620.79, 103.38, 7.2, 183.78, -2616.19, 106, 4.04, 268.89, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(371, 1, 0, 300000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2620.94, 96.79, 5, 282.15, -2615.85, 91.33, 4.04, 269.12, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(372, 1, 1541438889, 300000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2791.78, 218.6, 7.85, 93.12, -2796.86, 223.9, 6.89, 89.7, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(373, 1, 1541510947, 300000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.86, 212.08, 10.05, 357.53, -2796.55, 209.52, 6.89, 90.33, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(374, 1, 0, 375000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.72, 200.41, 7.85, 76.15, -2796.4, 205.74, 6.89, 89.91, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(375, 1, 1542185231, 225000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2791.63, 194.42, 10.05, 179.62, -2796.8, 196.8, 6.89, 90.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(376, 2, 0, 937500, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2789.3, 183.5, 10.06, 89.46, -2796.54, 180.75, 6.89, 90.33, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(377, 1, 0, 262500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2791.92, 143.14, 10.05, 184.37, -2796.51, 145.63, 6.89, 89.81, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(378, 1, 1535205471, 337500, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.68, 130.59, 7.85, 95.37, -2796.47, 135.74, 6.89, 89.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(379, 1, 0, 487500, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2790.54, 126.88, 7.2, 78.75, -2800.7, 121.94, 6.89, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(380, 1, 1538299266, 337500, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2793.26, 110.92, 7.18, 93.55, -2796.4, 117.03, 6.89, 90.47, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(381, 1, 0, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.76, 103.7, 10.05, 357.64, -2796.12, 101.27, 6.89, 90.02, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(382, 1, 0, 412500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.61, 92.1, 7.85, 90.74, -2796.04, 97.1, 6.89, 90.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(383, 1, 0, 300000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2792.92, 84.85, 7.57, 69.51, -2796.22, 88.54, 6.89, 89.97, 0, '', 0, 0, 0, 'None', '', '', 0),
(384, 1, 0, 300000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.92, 77.48, 10.05, 185.41, -2796.14, 79.97, 6.89, 89.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(385, 1, 1539291607, 337500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2793.25, 21.47, 7.18, 84.73, -2795.98, 27.49, 6.89, 89.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(386, 1, 1534226004, 337500, 0, '1|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2793.15, 11.02, 7.42, 77.65, -2796.7, 17.63, 6.89, 89.63, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(387, 1, 0, 487500, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2790.36, 7.1, 7.19, 82.24, -2801.1, 6.05, 6.88, 359.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(388, 1, 1541183909, 337500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2791.69, -17.7, 7.85, 86.52, -2796.2, -12.32, 6.89, 90.45, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(389, 1, 0, 262500, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2791.82, -24.29, 10.05, 23.5, -2796.44, -26.64, 6.89, 90.04, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(390, 1, 1541094643, 337500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2791.71, -35.84, 7.85, 80.58, -2796.15, -30.68, 6.89, 89.64, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(391, 1, 0, 225000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2791.87, -41.92, 10.05, 174.83, -2796.49, -39.4, 6.89, 90.18, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(392, 2, 0, 937500, 21, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2789.28, -52.77, 10.06, 78.76, -2796.09, -55.62, 6.89, 89.65, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(393, 2, 1540832377, 900000, 1, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2790.36, -82.51, 7.19, 88.95, -2793.08, -78.15, 6.89, 89.37, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(394, 1, 0, 225000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2792.05, -94.89, 10.05, 183.53, -2796.23, -92.37, 6.89, 89.54, 0, '', 0, 0, 0, '', '', '', 0),
(395, 1, 0, 375000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.69, -107.48, 7.85, 84.5, -2796.41, -101.99, 6.89, 88.5, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(396, 1, 0, 487500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2790.35, -111.1, 7.2, 101.1, -2800.2, -114.88, 6.89, 359.9, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(397, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2793.24, -127.37, 7.18, 85.8, -2796.05, -121.02, 6.89, 90.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(398, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.79, -134.39, 10.05, 5.52, -2796.56, -136.83, 6.89, 90.29, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(399, 1, 0, 337500, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.69, -145.8, 7.85, 91.87, -2796.36, -140.67, 6.89, 89.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(400, 1, 0, 300000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2792.92, -152.96, 7.57, 90.39, -2796.56, -149.47, 6.89, 89.41, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(401, 1, 1540121264, 300000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2791.86, -160.47, 10.05, 178.72, -2796.17, -158.12, 6.89, 89.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(402, 1, 0, 487500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2790.58, -168.27, 7.2, 82.15, -2800.54, -172.22, 6.89, 1.25, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(403, 2, 0, 937500, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2789.29, -181.36, 10.06, 88.72, -2796.28, -183.98, 6.89, 89.67, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(404, 1, 0, 487500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2724.56, -191.36, 4.33, 268.59, -2718.42, -188.23, 4.04, 270.16, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(405, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2722.91, -178.96, 7.2, 0.21, -2718.33, -181.5, 4.04, 271.26, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(406, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2723.29, -166.3, 5, 275.48, -2718.55, -171.46, 4.04, 270.45, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(407, 1, 0, 487500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2724.56, -162.72, 4.34, 266.26, -2718.45, -157.97, 4.04, 271.18, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(408, 1, 0, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2721.66, -146.71, 4.33, 271.03, -2719.09, -152.75, 4.04, 271.24, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(409, 1, 1537888156, 412500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2723.1, -139.54, 7.2, 181.7, -2718.58, -136.95, 4.04, 271.79, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(410, 1, 0, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2723.22, -127.85, 5, 263.12, -2718.54, -133.63, 4.04, 269.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(411, 1, 0, 300000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2721.98, -121, 4.7, 273.48, -2718.43, -124.86, 4.04, 269.83, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(412, 1, 0, 412500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2723.07, -113.29, 7.2, 4.11, -2714.93, -115.76, 4.03, 271.08, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(413, 1, 0, 487500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2724.51, -105.55, 4.34, 264.91, -2718.79, -101.3, 4.04, 271.55, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(414, 2, 1541871355, 937500, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2725.63, -92.3, 7.2, 269.34, -2718.87, -89.72, 4.04, 270.69, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(415, 2, 0, 937500, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2724.44, -57.98, 4.34, 270.16, -2718.07, -54.2, 4.04, 271.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(416, 1, 1541798980, 300000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2722.03, -44.67, 4.71, 285.78, -2718.63, -48.78, 4.03, 269.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(417, 2, 1535125661, 937500, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2725.68, -36.38, 7.19, 266.53, -2720.86, -33.71, 4.02, 271.44, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(418, 1, 0, 300000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2721.72, -23.33, 4.51, 246.78, -2718.62, -29.99, 4.04, 270.18, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(419, 1, 0, 225000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2723.16, -17.2, 7.2, 354.19, -2719.17, -19.39, 4.04, 270.8, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(420, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2723.12, 4.37, 7.2, 177.35, -2715.62, 6.87, 4.03, 272.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(421, 1, 0, 262500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2722.01, 14.67, 4.71, 268.97, -2718.95, 10.43, 4.04, 270.81, 0, '', 0, 0, 0, '', '', '', 0),
(422, 1, 0, 262500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2723.05, 21.99, 7.2, 357.63, -2715.02, 19.5, 4.03, 270.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(423, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2653.88, 200.26, 5, 0.52, -2648.64, 205.11, 4.03, 0.96, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(424, 1, 1541588869, 412500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2660.71, 200.46, 7.19, 272.74, -2663, 205.61, 4.04, 359.8, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(425, 1, 1539184489, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2672.29, 200.23, 5, 353, -2666.74, 204.5, 4.04, 359.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(426, 1, 0, 412500, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2678.17, 200.42, 7.19, 82.32, -2676.1, 204.91, 4.04, 0.53, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(427, 2, 1534927664, 937500, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2689.12, 197.93, 7.2, 350.36, -2691.8, 204.54, 4.04, 0.81, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(428, 1, 1538577053, 412500, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2634.99, 239.56, 4.5, 90.7, -2637.81, 245.65, 4.03, 93.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(429, 2, 0, 937500, 21, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2631.04, 252.84, 7.18, 90.2, -2635.72, 249.96, 3.96, 91.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(430, 1, 0, 412500, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2634.6, 261.1, 4.76, 82.62, -2638.51, 264.76, 4.03, 90.24, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(431, 2, 0, 937500, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2632.12, 274.45, 4.33, 85.58, -2637.99, 271.12, 4.03, 90.82, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(432, 2, 1540727593, 1875000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2706.52, 864.77, 70.7, 355.17, -2711.03, 870.78, 70.4, 90.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(433, 2, 0, 2250000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2661.94, 876.43, 79.77, 7.33, -2679.92, 868.26, 76.12, 2.39, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(434, 3, 0, 3750000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2721.01, 923.88, 67.59, 97.4, -2722.2, 915.87, 67.29, 90.3, 0, '', 0, 0, 0, '', '', '', 0),
(435, 3, 0, 3750000, 2, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2710.92, 967.57, 54.46, 347.84, -2720.72, 976.91, 54.16, 2.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(436, 2, 0, 2250000, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2655.31, 985.99, 64.99, 359.58, -2664.45, 988.88, 64.63, 359.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(437, 2, 1539949966, 2625000, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2641.01, 935.61, 71.95, 165.79, -2636, 932.29, 71.53, 183.68, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(438, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2864.89, 681.57, 23.46, 297.48, -2860.83, 680.15, 23.01, 295.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(439, 1, 1537821992, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2869.28, 690.98, 23.46, 290.9, -2863.38, 686.1, 23.1, 293.61, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(440, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2872.44, 697.57, 23.46, 284.31, -2871.37, 702, 23.3, 296.24, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(441, 1, 1537908411, 375000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2882.35, 726.78, 29.19, 275.98, -2878.62, 724.31, 28.91, 278.25, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(442, 1, 0, 375000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2883.45, 736.6, 29.22, 262.65, -2879.14, 734.29, 29.25, 276.49, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(443, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2884.05, 743.51, 29.22, 267.92, -2880.14, 740.42, 29.4, 275.89, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(444, 1, 0, 375000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2884.7, 750.55, 29.2, 265.44, -2881.28, 747.88, 29.47, 274.9, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(445, 1, 1535528583, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2882.07, 779.77, 35.1, 257.12, -2878.76, 776.23, 34.21, 263.27, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(446, 1, 0, 375000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2881.1, 790.42, 35.19, 259.25, -2877.75, 783.03, 34.63, 261.73, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(447, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2880.66, 797.6, 35.17, 259.24, -2875.96, 800.91, 35.73, 264.15, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(448, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2868.41, 821.19, 39.43, 220.58, -2867.33, 816.76, 38.85, 240.18, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(449, 1, 0, 375000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2863.57, 829.74, 39.54, 242.78, -2861.91, 825.14, 39.28, 238.9, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(450, 1, 0, 375000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2860.37, 835.49, 39.61, 237.34, -2858.97, 830.89, 39.73, 239.49, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(451, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2856.61, 842.02, 39.65, 201.8, -2854.87, 837.34, 40.27, 240.08, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(452, 1, 0, 375000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2840.22, 866.85, 44.05, 269.31, -2836.52, 863.69, 43.75, 269.52, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(453, 1, 0, 375000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2840.15, 877.4, 44.05, 268.81, -2836.98, 880.82, 43.76, 268.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(454, 1, 1542371282, 375000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2840.12, 884.72, 44.05, 264.37, -2836.7, 888.09, 43.75, 268.99, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(455, 1, 0, 375000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2843.1, 904.39, 44.05, 265.51, -2840.15, 901.47, 43.75, 273.69, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(456, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2843.98, 914.43, 44.05, 261.72, -2839.81, 911.63, 43.75, 274.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(457, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2844.63, 921.77, 44.05, 261.06, -2840.32, 918.03, 43.76, 273.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(458, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2845.2, 928.41, 44.05, 268.29, -2840.88, 925.61, 43.76, 272.58, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(459, 1, 0, 375000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2853.2, 947.49, 44.05, 290.07, -2847.94, 946.34, 43.76, 293.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(460, 1, 1540563687, 375000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2857.67, 957.07, 44.05, 298.61, -2855.14, 962.16, 43.69, 295.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(461, 1, 0, 375000, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2860.72, 963.56, 44.05, 298.28, -2858.55, 968.92, 43.63, 298.07, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(462, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2875.92, 981.01, 40.72, 300.58, -2870.94, 980.3, 40.66, 300.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(463, 1, 0, 375000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2881.04, 989.74, 40.71, 288.88, -2875.38, 989.51, 40.27, 300.41, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(464, 1, 0, 375000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2884.46, 995.79, 40.71, 289.37, -2878.5, 995.01, 39.91, 300.8, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(465, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2887.97, 1001.66, 40.71, 298.25, -2883.95, 1000.54, 39.95, 304.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(466, 1, 0, 375000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2895.57, 1017, 36.82, 282.78, -2890.39, 1015.4, 36.52, 289.05, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(467, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2899.06, 1026.82, 36.82, 291.82, -2892.6, 1021.8, 36.27, 288.28, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(468, 1, 0, 375000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2901.49, 1033.47, 36.82, 275.36, -2898.95, 1038.13, 35.92, 290.53, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(469, 1, 0, 375000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2900.36, 1056.86, 32.13, 275.68, -2896.41, 1053.71, 32.09, 270, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(470, 1, 0, 375000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2900.6, 1066.75, 32.13, 272.39, -2896.94, 1063.89, 31.79, 266.32, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(471, 1, 0, 375000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2900.61, 1073.63, 32.13, 274.19, -2896.64, 1070.24, 31.61, 271.22, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(472, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2900.71, 1080.98, 32.13, 266.78, -2896.81, 1077.85, 31.51, 269.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(473, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2904.36, 1101, 27.07, 272.2, -2900.59, 1098.11, 26.98, 269.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(474, 1, 0, 375000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2904.8, 1111.46, 27.07, 253.28, -2900.12, 1115.19, 26.28, 269.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(475, 1, 1541142108, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2904.64, 1118.82, 27.07, 265.61, -2899.96, 1122.55, 25.93, 271.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(476, 1, 1541071908, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2905.06, 1154.71, 13.66, 265.77, -2901.05, 1151.75, 13.51, 271.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(477, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2905.16, 1164.77, 13.66, 261.65, -2900.86, 1161.74, 13.21, 270.27, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(478, 1, 0, 375000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2905.14, 1171.78, 13.66, 269.05, -2900.88, 1167.96, 13.04, 269.92, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(479, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2905.07, 1178.74, 13.66, 258.84, -2900.61, 1175.62, 12.75, 269.05, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(480, 2, 0, 2250000, 1, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2058.9, 889.47, 61.85, 8.39, -2048.3, 899.59, 53.17, 358.47, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(481, 2, 0, 2250000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2084.74, 898.75, 64.13, 356.05, -2080.06, 902.82, 63.96, 0.91, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(482, 2, 0, 3000000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2099.56, 897.45, 76.71, 2.62, -2105.32, 893.61, 76.4, 0.89, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(483, 2, 0, 1500000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2116.84, 927.71, 86.07, 181.66, -2125.87, 921.4, 79.64, 85.88, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(484, 2, 0, 1650000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2523.84, 2238.82, 5.39, 338.25, -2528.68, 2250.17, 4.68, 335.09, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(485, 2, 1541160029, 1650000, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2552.39, 2266.61, 5.47, 333.15, -2560.72, 2257.42, 4.76, 335.61, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(486, 2, 0, 900000, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2583.7, 2307.89, 7, 278.13, -2569.84, 2314, 4.69, 6.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(487, 2, 1536530714, 900000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2583.06, 2300.17, 7, 279.52, -2566.56, 2298.01, 4.69, 197.03, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(488, 2, 1540472047, 900000, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2627.63, 2283.58, 8.31, 261.42, -2623.91, 2273.02, 7.99, 268.32, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(489, 2, 0, 900000, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2627.61, 2291.96, 8.31, 287.58, -2620.31, 2295.29, 7.98, 0.31, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(490, 2, 0, 900000, 12, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2627.58, 2309.82, 8.31, 269.32, -2620.43, 2305.19, 7.98, 359.6, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(491, 2, 0, 900000, 35, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2627.58, 2318.6, 8.31, 279.02, -2620.47, 2323.93, 8, 359.68, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(492, 2, 0, 1050000, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2636.44, 2351.03, 8.49, 2.03, -2620.25, 2347.6, 8.21, 0.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(493, 2, 0, 1050000, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2627.23, 2359.56, 8.97, 269.74, -2620.33, 2362.56, 8.58, 359.99, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(494, 2, 0, 900000, 35, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2597.33, 2357.46, 9.88, 84.94, -2610, 2353, 8.33, 0.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(495, 2, 0, 900000, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2597.3, 2364.97, 9.88, 85.99, -2609.9, 2366.05, 8.76, 1.29, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(496, 2, 0, 1050000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2634.79, 2401.69, 11.22, 347.48, -2618.52, 2397.32, 11.14, 352.43, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(497, 2, 1540743235, 900000, 1, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2479.71, 2449.98, 17.32, 188.15, -2484.09, 2436.82, 16, 107.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(498, 2, 0, 900000, 34, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2472.63, 2451.26, 17.32, 197.03, -2465.09, 2439.91, 15.21, 96.77, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(499, 2, 0, 1050000, 32, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2424.85, 2448.97, 13.14, 170.71, -2428.62, 2446.48, 13.26, 182.33, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(500, 2, 0, 1050000, 1, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2421.71, 2406.53, 13.02, 250.57, -2419.55, 2426.76, 12.52, 268.47, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(501, 2, 0, 1050000, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2381.9, 2406.58, 8.89, 326.97, -2380.66, 2417.29, 8.43, 243.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(502, 2, 0, 900000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2386.49, 2447.54, 10.16, 154.4, -2393.41, 2437.85, 10.26, 73.96, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(503, 2, 0, 900000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2379.27, 2444.53, 10.16, 164.04, -2375.64, 2431.4, 8.56, 64.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(504, 2, 0, 1050000, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2348.38, 2423.61, 7.32, 126.7, -2347.71, 2413.1, 6.3, 56.01, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(505, 0, 0, 127500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2422.48, 2490.71, 13.2, 344.33, -2416.3, 2489.04, 12.49, 0.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(506, 0, 1542166326, 127500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2446.38, 2490.74, 15.54, 342.12, -2453.8, 2491.76, 15.71, 4.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(507, 0, 1540241493, 127500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2446.88, 2512.31, 15.7, 262.34, -2454.42, 2515.01, 15.78, 4.43, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(508, 0, 0, 127500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2478.35, 2489.25, 18.22, 90.2, -2482.96, 2483.34, 17.73, 1.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(509, 0, 0, 127500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2478.9, 2510.04, 17.97, 183.31, -2470.68, 2513.7, 17.34, 182.15, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(510, 1, 0, 187500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1.75, 1075.98, 20.93, 97.77, 3.05, 1083.83, 19.45, 90.09, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(511, 1, 0, 187500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 12.63, 1113.61, 20.93, 184.55, -0.37, 1115.66, 19.42, 178.94, 0, '', 0, 0, 0, '', '', '', 0),
(512, 1, 0, 187500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -18.25, 1115.54, 20.93, 183.56, -26.1, 1116.54, 19.45, 179.29, 0, '', 0, 0, 0, 'None', '', '', 0),
(513, 1, 0, 225000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -36.1, 1115.38, 20.93, 169.81, -51.08, 1114.45, 19.44, 180.35, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(514, 1, 0, 225000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -45.01, 1081.19, 20.93, 347.37, -31.49, 1079.44, 19.45, 359.13, 0, '', 0, 0, 0, '', '', '', 0),
(515, 1, 0, 187500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -32.26, 1038.52, 20.93, 175.95, -45.22, 1042.13, 19.43, 180.89, 0, '', 0, 0, 0, 'None', '', '', 0),
(516, 2, 0, 900000, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -207.41, 1119.18, 20.42, 262.14, -202.83, 1114.96, 19.44, 179.35, 0, '', 0, 0, 0, '', '', '', 0),
(517, 1, 0, 225000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -258.36, 1168.79, 20.93, 89.48, -256.62, 1182.88, 19.45, 88.41, 0, '', 0, 0, 0, '', '', '', 0),
(518, 1, 0, 150000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -258.36, 1151.08, 20.93, 75.65, -259.33, 1158.66, 19.45, 89.51, 0, '', 0, 0, 0, '', '', '', 0),
(519, 1, 1, 187500, 4, '1|1|1', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -290.74, 1176.62, 20.93, 257.98, -292.43, 1163.3, 19.41, 269.81, 0, 'Oscar_Floyd', 0, 0, 0, 'None', 'None', 'None', 0),
(520, 1, 0, 225000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -324.49, 1165.55, 20.93, 175.46, -338.9, 1166.93, 19.45, 178.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(521, 1, 0, 412500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -369.75, 1169.31, 20.27, 239.11, -360.71, 1197.12, 19.44, 180.51, 0, '', 0, 0, 0, '', '', '', 0);
INSERT INTO `houses` (`id`, `class`, `day`, `price`, `hint`, `improve`, `gun`, `skin`, `safecode`, `safemoney`, `drugs`, `medkit`, `products`, `close`, `x`, `y`, `z`, `r`, `parkx`, `parky`, `parkz`, `parkr`, `ownerid`, `owner`, `peopleid1`, `peopleid2`, `peopleid3`, `people1`, `people2`, `people3`, `family`) VALUES
(522, 1, 0, 187500, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -360.72, 1141.8, 20.93, 255.89, -362.72, 1128.39, 19.41, 269.27, 0, '', 0, 0, 0, '', '', '', 0),
(523, 1, 0, 187500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -362.82, 1110.71, 20.93, 279.4, -363.42, 1102.91, 19.45, 268.86, 0, '', 0, 0, 0, '', '', '', 0),
(524, 1, 0, 225000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -328.4, 1118.82, 20.93, 100.58, -325.88, 1133.69, 19.44, 89.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(525, 1, 0, 187500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -298.34, 1115.54, 20.93, 162.09, -306.02, 1116.04, 19.45, 179.5, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(526, 1, 0, 187500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -260.35, 1120.28, 20.93, 88.23, -258.92, 1133.14, 19.41, 90.37, 0, '', 0, 0, 0, '', '', '', 0),
(527, 1, 0, 187500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -258.57, 1083.17, 20.93, 348.04, -245.79, 1080.93, 19.42, 359.44, 0, '', 0, 0, 0, '', '', '', 0),
(528, 1, 0, 225000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -258.36, 1043.8, 20.93, 85.82, -255.92, 1058.11, 19.45, 88.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(529, 1, 0, 187500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -278.79, 1003.16, 20.93, 328.85, -265.66, 1001.13, 19.42, 359.49, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(530, 1, 0, 187500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -248.12, 1001.07, 20.93, 352.53, -240.2, 1000.67, 19.45, 357.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(531, 1, 0, 562500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1030.69, 1848.12, 11.46, 97.38, 1023.09, 1841.05, 10.95, 89.19, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(532, 1, 1541706906, 562500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1030.25, 1876.36, 11.46, 83.72, 1023.17, 1868.23, 10.98, 90, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(533, 1, 0, 562500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1029.25, 1906.05, 11.46, 87.57, 1021.75, 1911.63, 10.96, 90.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(534, 1, 0, 562500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1030.79, 1928.12, 11.46, 87.4, 1022.86, 1921.01, 10.93, 90.22, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(535, 1, 0, 562500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1030.24, 1976.15, 11.46, 99.89, 1022.96, 1968.01, 10.97, 90, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(536, 1, 0, 562500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1029.2, 2005.65, 11.46, 85.81, 1022.08, 2011.26, 10.98, 89.91, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(537, 1, 1539536566, 562500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1030.69, 2028.55, 11.46, 100.11, 1022.85, 2021.14, 10.93, 90.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(538, 1, 0, 562500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 984.05, 1878.78, 11.46, 265, 991.89, 1886.07, 10.94, 269.17, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(539, 1, 1540201576, 562500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 985.51, 1901.26, 11.46, 271.09, 992.56, 1895.33, 10.99, 270.58, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(540, 1, 1541240078, 562500, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 984.72, 1930.77, 11.46, 260.39, 992.49, 1938.3, 10.94, 268.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(541, 1, 0, 562500, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 983.97, 1978.32, 11.46, 265.15, 991.94, 1985.13, 10.93, 269.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(542, 1, 0, 562500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 985.41, 2000.46, 11.46, 257.41, 992.17, 1994.63, 11.01, 270.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(543, 1, 0, 562500, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 984.5, 2029.98, 11.46, 269.25, 992.12, 2038.13, 10.95, 270.26, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(544, 1, 0, 562500, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 930.7, 1928.17, 11.46, 91.25, 922.93, 1921.2, 10.94, 89.68, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(545, 2, 0, 900000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 928.95, 2006.47, 11.46, 88.94, 932.12, 2011.59, 11.16, 89.16, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(546, 1, 1538396615, 562500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 930.79, 2028.07, 11.46, 98.55, 922.44, 2020.73, 10.9, 90.22, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(547, 1, 0, 562500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 885.63, 2046.99, 11.46, 273.65, 893.3, 2041.36, 10.94, 270.5, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(548, 1, 0, 562500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1084.52, 1976.69, 11.46, 270.26, 1091.79, 1984.48, 10.98, 270.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(549, 1, 0, 562500, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1085.51, 2000.81, 11.46, 275.86, 1092.66, 1994.86, 10.98, 270.43, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(550, 1, 0, 562500, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1084.06, 2031.37, 11.46, 268.94, 1091.97, 2038.51, 10.93, 269.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(551, 1, 0, 525000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 986.52, 2271.34, 11.46, 8.95, 992.15, 2278.61, 10.97, 1.1, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(552, 1, 0, 525000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 956.87, 2270.37, 11.46, 1.87, 949.18, 2277.4, 10.99, 0.53, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(553, 1, 0, 525000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 985.47, 2314, 11.46, 275.34, 992.48, 2308.3, 11, 270.69, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(554, 1, 1537466213, 525000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 984.54, 2343.79, 11.46, 280.26, 991.72, 2351.36, 10.98, 269.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(555, 2, 1535994038, 975000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1225.36, 2584.94, 10.82, 265.45, 1236.58, 2592.87, 10.52, 270.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(556, 2, 1542451824, 975000, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1223.11, 2616.75, 10.82, 268.08, 1234.46, 2609.56, 10.52, 270.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(557, 1, 0, 675000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1265.36, 2609.84, 10.82, 178.09, 1272.91, 2603.11, 10.53, 180.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(558, 1, 0, 675000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1284.92, 2610.61, 10.82, 175.28, 1291.98, 2600.49, 10.52, 179.3, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(559, 2, 0, 900000, 12, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1313.77, 2610.08, 11.29, 181.86, 1322.84, 2599.1, 10.52, 179.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(560, 2, 0, 900000, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1344.63, 2610.09, 11.29, 182.35, 1353.73, 2599.31, 10.52, 180.47, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(561, 3, 0, 1500000, 29, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1274.05, 2522.49, 10.82, 269.85, 1275.34, 2529.8, 10.52, 270.1, 0, '', 0, 0, 0, '', '', '', 0),
(562, 2, 1538846311, 1387500, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1269.71, 2554.42, 10.82, 271.49, 1280.95, 2547.09, 10.52, 269.86, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(563, 2, 1538904674, 1387500, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1271.98, 2564.41, 10.82, 263.92, 1283.17, 2571.76, 10.52, 269.01, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(564, 3, 0, 1500000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1316.37, 2524.58, 10.82, 87.4, 1303.58, 2529.89, 10.52, 89.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(565, 3, 0, 1500000, 29, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1325.65, 2567.44, 10.82, 356.33, 1320.42, 2579.68, 10.52, 1.1, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(566, 2, 0, 1387500, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1349.7, 2567.8, 10.82, 0.43, 1342.59, 2578.22, 10.52, 0.56, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(567, 2, 1538774162, 1387500, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1359.6, 2565.43, 10.82, 0.1, 1366.58, 2576.69, 10.52, 0.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(568, 3, 0, 1875000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1362.41, 2525.72, 10.82, 261.62, 1366.62, 2519.86, 10.52, 269.75, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(569, 3, 0, 1500000, 29, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1408.06, 2524.44, 10.82, 89.06, 1395.36, 2529.57, 10.52, 89.53, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(570, 2, 1537711661, 1387500, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1417.77, 2567.59, 10.82, 355.35, 1412.48, 2579.82, 10.52, 0.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(571, 2, 1537531856, 1387500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1441.73, 2567.69, 10.82, 1.83, 1434.37, 2578.57, 10.52, 358.86, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(572, 3, 0, 1875000, 8, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1454.05, 2525.5, 10.82, 264.84, 1459.06, 2520.23, 10.52, 269.56, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(573, 3, 0, 1875000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1500.8, 2535.35, 10.82, 83.72, 1495.56, 2540.52, 10.52, 90.19, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(574, 2, 0, 1387500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1503.2, 2567.8, 10.82, 2.61, 1495.78, 2578.05, 10.52, 0.29, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(575, 2, 0, 1387500, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1513.33, 2565.43, 10.82, 358.24, 1522.17, 2576.86, 10.52, 359.42, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(576, 2, 0, 1387500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1551.61, 2567.46, 10.82, 1.52, 1546.17, 2579.8, 10.52, 0.72, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(577, 2, 0, 1387500, 32, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1596.58, 2567.79, 10.82, 2.63, 1589.25, 2579, 10.52, 0.33, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(578, 1, 0, 675000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1646.33, 2569.7, 10.82, 1.71, 1638.87, 2576.51, 10.53, 0.19, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(579, 2, 0, 900000, 37, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1665.47, 2569.53, 11.29, 5.72, 1656.28, 2580.22, 10.52, 0.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(580, 2, 1542460369, 900000, 35, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1667.06, 2610.12, 11.29, 182.29, 1675.94, 2599.35, 10.52, 180.16, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(581, 1, 0, 675000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1638.06, 2610.61, 10.82, 176.43, 1645.28, 2600.74, 10.52, 179.51, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(582, 1, 0, 675000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1618.7, 2609.81, 10.82, 181.85, 1626.05, 2602.74, 10.53, 180.81, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(583, 1, 0, 675000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1600.48, 2609.91, 10.82, 176.09, 1607.44, 2603.3, 10.53, 180.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(584, 1, 1541392817, 675000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1554.59, 2610.62, 10.82, 182.72, 1560.81, 2600.84, 10.52, 179.72, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(585, 1, 0, 675000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1535.1, 2609.93, 10.82, 181.89, 1542.47, 2603.34, 10.53, 179.96, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(586, 2, 1539687091, 900000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1515.93, 2610.08, 11.29, 182.45, 1524.91, 2599.45, 10.52, 180.71, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(587, 1, 0, 675000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1556.13, 2658.62, 10.82, 6.99, 1548.56, 2665.45, 10.53, 359.45, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(588, 1, 0, 675000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1573.1, 2657.93, 10.82, 1.3, 1565.69, 2668, 10.52, 359.69, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(589, 2, 0, 1125000, 1, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1611.65, 2648.37, 10.82, 87.82, 1600.23, 2655.16, 10.52, 90.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(590, 1, 0, 675000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1607.5, 2679.31, 10.82, 80.81, 1600.4, 2671.52, 10.53, 89.91, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(591, 2, 0, 1387500, 1, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1570.19, 2711.22, 10.82, 358.88, 1563.63, 2721.87, 10.52, 359.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(592, 2, 0, 1387500, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1580.11, 2709.05, 10.82, 1.57, 1587.23, 2719.81, 10.52, 0.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(593, 2, 0, 1387500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1601.16, 2708.96, 10.82, 356.8, 1608.05, 2719.67, 10.52, 1.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(594, 3, 0, 1875000, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1627.4, 2710.87, 10.82, 12.82, 1622.43, 2714.54, 10.52, 1.43, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(595, 2, 0, 1387500, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1652.55, 2708.96, 10.82, 357.58, 1659.43, 2720.14, 10.52, 1.39, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(596, 3, 0, 1875000, 2, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1678.45, 2690.87, 10.82, 355.84, 1673.96, 2695.86, 10.52, 0.47, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(597, 2, 0, 1387500, 35, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1703.84, 2688.95, 10.82, 357.55, 1710.81, 2699.82, 10.52, 0.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(598, 2, 0, 1387500, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1735.65, 2691.19, 10.82, 356.29, 1725.68, 2701.83, 10.52, 0.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(599, 1, 0, 675000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1663.18, 2754.04, 10.82, 176.65, 1670.36, 2744.1, 10.52, 181.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(600, 1, 0, 675000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1643.9, 2753.43, 10.82, 175.49, 1650.69, 2746.74, 10.53, 179.07, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(601, 1, 1540903142, 675000, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1626.82, 2753.92, 10.82, 176.63, 1632.94, 2743.99, 10.52, 179.89, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(602, 1, 0, 675000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1608.5, 2754.11, 10.82, 183.86, 1615.22, 2743.67, 10.52, 180.75, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(603, 2, 0, 1387500, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1599.47, 2757.51, 10.82, 179.42, 1593.78, 2746.26, 10.52, 180.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(604, 1, 0, 675000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1565.36, 2757.01, 10.82, 95.02, 1555.05, 2750.37, 10.52, 89.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(605, 1, 0, 675000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1564.42, 2776.61, 10.82, 91.23, 1557.44, 2769.89, 10.53, 89.28, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(606, 1, 0, 675000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1565.46, 2793.47, 10.82, 89.91, 1555.31, 2786.76, 10.52, 89.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(607, 2, 0, 1387500, 35, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1550.63, 2845.94, 10.82, 176.34, 1543.64, 2834.42, 10.52, 180.79, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(608, 3, 0, 1875000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1575.84, 2844.06, 10.82, 181.59, 1580.4, 2840.33, 10.52, 178.14, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(609, 2, 0, 1387500, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1601.74, 2845.97, 10.82, 180.27, 1595.13, 2834.39, 10.52, 179.86, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(610, 2, 0, 1387500, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1622.81, 2845.97, 10.82, 181.25, 1616.13, 2834.75, 10.54, 180.01, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(611, 2, 0, 1387500, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1632.73, 2843.8, 10.82, 179.11, 1639.54, 2832.8, 10.53, 180.01, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(612, 2, 0, 1387500, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1664.56, 2845.98, 10.82, 184.52, 1658.31, 2834.77, 10.51, 180.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(613, 2, 0, 1387500, 28, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1588.47, 2797.34, 10.82, 6.53, 1594.67, 2808.93, 10.52, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(614, 1, 0, 675000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1618.27, 2800.88, 10.82, 356.72, 1611.78, 2811.08, 10.52, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(615, 1, 0, 675000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1637.99, 2801.59, 10.82, 0.33, 1630.34, 2808.62, 10.53, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(616, 1, 0, 675000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1654.87, 2800.82, 10.82, 354.9, 1648.11, 2810.79, 10.52, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(617, 1, 0, 675000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1672.95, 2800.8, 10.82, 10.02, 1665.86, 2810.95, 10.52, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(618, 1, 0, 337500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1684.61, 2123.27, 11.46, 269.41, 1692.23, 2130.67, 10.95, 269.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(619, 1, 0, 337500, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1685.52, 2093.62, 11.46, 270.89, 1689.13, 2087.26, 11.13, 269.49, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(620, 1, 0, 300000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1680.3, 2069.13, 11.35, 195.68, 1682.59, 2064.28, 11.06, 270.15, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(621, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1684.61, 2046.56, 11.46, 275.2, 1690.86, 2055.13, 11.03, 270.11, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(622, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1641.79, 2044.77, 11.31, 93.91, 1637.15, 2036.65, 10.96, 90.88, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(623, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1640.12, 2075.6, 11.31, 87, 1637.58, 2082.64, 11.03, 89.95, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(624, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1640.34, 2102.79, 11.31, 94.23, 1637.86, 2109.89, 11.03, 89.9, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(625, 1, 0, 300000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1645.46, 2127.49, 11.2, 357.4, 1645.74, 2131.98, 10.9, 87.45, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(626, 1, 0, 337500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1641.13, 2149.83, 11.31, 86.06, 1633.78, 2141.01, 10.8, 90.29, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(627, 1, 0, 337500, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1596.41, 2147.43, 11.46, 267.73, 1599.94, 2140.66, 11.16, 269.8, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(628, 1, 0, 337500, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1595.55, 2123.08, 11.46, 274.31, 1602.82, 2131.67, 10.97, 270.03, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(629, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1596.52, 2093.55, 11.31, 279.4, 1599.93, 2086.67, 10.99, 268.77, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(630, 1, 0, 337500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1595.05, 2070.78, 11.31, 293.21, 1599.81, 2078.9, 10.95, 270.01, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(631, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1595.5, 2038.57, 11.46, 282.51, 1603.96, 2046.88, 10.88, 270.49, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(632, 1, 0, 300000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1554.43, 2074.17, 11.35, 7.95, 1554.07, 2078.37, 11.06, 89.67, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(633, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1550.17, 2096.57, 11.46, 101.06, 1542.75, 2088.34, 10.95, 90.07, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(634, 1, 0, 337500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1549.19, 2125.79, 11.46, 83.52, 1546.01, 2132.4, 11.14, 89.52, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(635, 1, 0, 525000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1845.75, 741.32, 11.46, 263.31, 1849.22, 734.05, 11.13, 269.76, 0, '', 0, 0, 0, 'None', '', '', 0),
(636, 1, 0, 525000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1844.1, 718.78, 11.46, 265.77, 1849.74, 726.72, 11.07, 272.46, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(637, 1, 0, 525000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1844.62, 690.37, 11.45, 270.04, 1850.93, 698.63, 11.02, 270.04, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(638, 1, 0, 525000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1845.6, 661.26, 11.46, 260.49, 1853.07, 654.4, 10.95, 267.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(639, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2013.88, 775.09, 11.46, 170.5, 2007.45, 769.76, 11.08, 179.07, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(640, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2043.24, 775.98, 11.45, 182.5, 2051.44, 769.92, 11.04, 180.07, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(641, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2071.32, 776.63, 11.46, 185.95, 2079.64, 770.03, 11.01, 181.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(642, 1, 0, 375000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2094.08, 775.1, 11.45, 162.26, 2087.28, 770.98, 11.13, 180.04, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(643, 1, 0, 375000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2123.14, 776.09, 11.44, 175.08, 2131.9, 768.15, 10.9, 180.5, 0, '', 0, 0, 0, '', '', '', 0),
(644, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2013.31, 730.47, 11.45, 352.48, 2005.04, 737.26, 10.98, 359.87, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(645, 1, 0, 375000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2042.41, 731.26, 11.46, 5.47, 2049.1, 735.54, 11.12, 359.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(646, 1, 0, 375000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2065.04, 729.92, 11.46, 8.26, 2057.18, 737.63, 10.94, 359.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(647, 1, 0, 375000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2093.06, 730.46, 11.45, 359.2, 2084.83, 737.66, 10.95, 0.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(648, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2122.48, 731.42, 11.46, 6.59, 2128.52, 738.17, 11.02, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(649, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2120.39, 695.97, 11.45, 197.81, 2128.92, 690.23, 11.06, 179.73, 0, '', 0, 0, 0, 'None', '', '', 0),
(650, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2091.28, 695.08, 11.46, 168.68, 2084.45, 690.11, 11.09, 179.63, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(651, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2068.96, 696.52, 11.46, 180.85, 2077.06, 689.23, 10.96, 179.16, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(652, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2040.68, 695.98, 11.45, 180.19, 2048.86, 688.49, 10.94, 180.44, 0, '', 0, 0, 0, 'None', '', '', 0),
(653, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2011.52, 695.18, 11.46, 179.36, 2004.56, 688.22, 10.99, 178.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(654, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2013.98, 650.5, 11.46, 357.25, 2005.36, 657.51, 10.97, 0.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(655, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2043.33, 651.41, 11.46, 9.58, 2050.01, 656.01, 11.1, 358.37, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(656, 1, 0, 375000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2065.73, 649.87, 11.46, 4.31, 2058.16, 657.1, 10.98, 359.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(657, 1, 0, 375000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2094.05, 650.5, 11.46, 6.11, 2086.02, 657.02, 11.02, 359.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(658, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2123.13, 651.31, 11.46, 350.64, 2130.17, 655.86, 11.13, 0.19, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(659, 1, 0, 525000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2169.24, 772.29, 11.46, 102.07, 2162.72, 779.57, 11.01, 87.04, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(660, 1, 0, 375000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2177.69, 735.98, 11.46, 172.31, 2186.53, 728.55, 10.94, 183.05, 0, '', 0, 0, 0, '', '', '', 0),
(661, 1, 0, 375000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2205.86, 736.59, 11.46, 188.75, 2213.52, 728.35, 10.91, 179.07, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(662, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2228.55, 735.18, 11.46, 169.99, 2221.72, 728.34, 11, 178.55, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(663, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2257.65, 736.04, 11.46, 182, 2265.69, 728.32, 10.93, 179.02, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(664, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2177.36, 690.46, 11.46, 5.97, 2168.38, 699.13, 10.85, 0.61, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(665, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2206.36, 691.25, 11.46, 356.59, 2213.27, 697.04, 11.06, 358.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(666, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2228.86, 689.82, 11.46, 10.07, 2220.58, 697.42, 10.94, 359.32, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(667, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2256.82, 690.46, 11.45, 7.6, 2249.04, 696.81, 11.01, 0.35, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(668, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2177.9, 655.98, 11.46, 183.91, 2185.89, 648.58, 10.96, 179.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(669, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2206.26, 656.51, 11.46, 180.78, 2213.99, 650.87, 11.06, 179.95, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(670, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2228.53, 655.17, 11.46, 180.12, 2222.4, 647.47, 10.93, 180.54, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(671, 1, 1542027661, 375000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2258.15, 655.89, 11.45, 199.03, 2266.28, 647.67, 10.89, 179.99, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(672, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2317.84, 656.03, 11.45, 187.01, 2325.94, 647.74, 10.88, 179.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(673, 1, 0, 375000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2345.94, 656.55, 11.46, 182.9, 2353.35, 647.68, 10.86, 179.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(674, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2368.33, 655.13, 11.46, 182.23, 2361.79, 647.31, 10.93, 180.44, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(675, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2397.62, 656.1, 11.46, 198.84, 2405.57, 648.91, 10.97, 179.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(676, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2396.79, 690.4, 11.45, 357.15, 2388.7, 697.4, 10.97, 0.56, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(677, 1, 0, 375000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2368.45, 689.8, 11.46, 11.13, 2360.51, 697.55, 10.93, 359.65, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(678, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2346.01, 691.37, 11.46, 2.57, 2352.97, 697.37, 11.05, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(679, 1, 0, 375000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2317.21, 690.35, 11.46, 354.01, 2308.97, 696.14, 11.08, 0.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(680, 1, 0, 375000, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2346.43, 736.63, 11.46, 206.28, 2354.68, 728.38, 10.9, 179.69, 0, '', 0, 0, 0, '', '', '', 0),
(681, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2369.06, 735.13, 11.46, 196.47, 2362.77, 730.08, 11.12, 179.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(682, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2398.34, 736.09, 11.46, 178.21, 2406.55, 727.44, 10.86, 181.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(683, 1, 0, 525000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2450.17, 742.45, 11.46, 90.19, 2442.36, 733.98, 10.91, 90.32, 0, '', 0, 0, 0, '', '', '', 0),
(684, 1, 0, 525000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2450.28, 714.5, 11.46, 104.99, 2442.19, 706.44, 10.88, 90.77, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(685, 2, 0, 900000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2449.04, 689.85, 11.46, 83.44, 2453.74, 697.66, 11.16, 89.97, 0, '', 0, 0, 0, 'None', '', '', 0),
(686, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1464.59, 1894.95, 11.46, 273.5, 1468.9, 1902.07, 11.11, 271.37, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(687, 1, 0, 337500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1464.5, 1919.76, 11.46, 277.11, 1471.48, 1928.37, 10.98, 270.83, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(688, 1, 0, 337500, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1462.53, 1949.91, 11.46, 0.99, 1454.13, 1958.65, 10.86, 0.65, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(689, 1, 0, 337500, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1439.7, 1951.25, 11.46, 339.11, 1446.53, 1957.75, 11.02, 358.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(690, 1, 0, 337500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1412.66, 1951.34, 11.45, 356.37, 1419.77, 1956.34, 11.08, 357.72, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(691, 1, 0, 337500, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1409.25, 1920.05, 11.46, 81.57, 1403.3, 1911.61, 11.05, 90.57, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(692, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1364.59, 1896.55, 11.46, 280.75, 1372.04, 1905.21, 10.95, 270.81, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(693, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1364.09, 1931.59, 11.46, 275.96, 1371.73, 1939.54, 10.94, 269.9, 0, '', 0, 0, 0, 'None', '', '', 0),
(694, 1, 0, 337500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1336.55, 1931.25, 11.46, 7.42, 1342.87, 1937.37, 11.05, 0.02, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(695, 1, 0, 337500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1309.39, 1931.36, 11.46, 2.64, 1315.89, 1937.02, 11.07, 359.71, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(696, 1, 0, 337500, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1320.75, 2028.27, 11.46, 93.18, 1312.81, 2020.24, 10.93, 90.14, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(697, 1, 0, 337500, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1319.21, 2005.93, 11.46, 77.88, 1315.3, 2012.17, 11.13, 89.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(698, 1, 0, 337500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1320.2, 1976.27, 11.46, 93.17, 1312.24, 1967.44, 10.92, 90.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(699, 1, 0, 337500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1365.43, 1974.22, 11.46, 277.97, 1371.23, 1968.14, 11.09, 269.96, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(700, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1364.41, 2003.54, 11.46, 272.37, 1372.05, 2012.63, 10.93, 272.35, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(701, 1, 0, 337500, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1365.45, 2028.04, 11.46, 266.6, 1371.67, 2020.92, 11.03, 269, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(702, 1, 0, 675000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2065.91, 2721.38, 10.82, 354.93, 2059.13, 2731.5, 10.52, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(703, 1, 0, 675000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2018.04, 2721.95, 10.82, 355.4, 2011.47, 2729.56, 10.54, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(704, 1, 0, 675000, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1998.58, 2721.29, 10.82, 2.96, 1992.35, 2731.14, 10.54, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(705, 2, 0, 900000, 35, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1970.07, 2721.89, 11.29, 357.85, 1961.01, 2732.58, 10.52, 359.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(706, 1, 0, 675000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1950.78, 2722.06, 10.82, 349.95, 1943.42, 2729.21, 10.54, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(707, 1, 0, 675000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1931.17, 2721.26, 10.82, 3.6, 1924.56, 2731.62, 10.52, 359.86, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(708, 2, 0, 1350000, 21, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2049.74, 2764.17, 10.82, 174.01, 2056.57, 2753.17, 10.52, 179.96, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(709, 2, 0, 1350000, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2039.64, 2766.54, 10.82, 180.09, 2032.91, 2754.77, 10.54, 180.03, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(710, 2, 0, 1350000, 20, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2018.41, 2766.54, 10.82, 188.64, 2011.16, 2754.6, 10.53, 180, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(711, 2, 0, 1350000, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1992.59, 2764.61, 10.82, 177.28, 1997.8, 2760.46, 10.52, 180, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(712, 2, 0, 1350000, 18, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1967.34, 2766.43, 10.82, 187.31, 1960.58, 2755.2, 10.52, 179.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(713, 2, 0, 1387500, 13, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1929.73, 2774.26, 10.82, 87.35, 1918.5, 2760.9, 10.52, 90.02, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(714, 1, 0, 675000, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1921.68, 2665.09, 10.82, 187.2, 1928.99, 2654.88, 10.52, 179.98, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(715, 2, 0, 937500, 1, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 1950.5, 2664.55, 11.29, 175.84, 1959.31, 2653.89, 10.52, 179.52, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(716, 1, 0, 675000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1969.61, 2664.37, 10.82, 180.44, 1977.02, 2657.6, 10.53, 180, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(717, 1, 0, 675000, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1989.1, 2665.08, 10.82, 183.23, 1995.91, 2655.1, 10.53, 180, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(718, 2, 0, 937500, 26, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2017.96, 2664.54, 11.29, 178.95, 2026.68, 2654.07, 10.52, 179.41, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(719, 1, 0, 675000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2037.18, 2664.39, 10.82, 189.96, 2044.28, 2657.14, 10.53, 180.58, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(720, 1, 1535846818, 675000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2056.63, 2665.18, 10.82, 182.23, 2064.2, 2654.97, 10.52, 179.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(721, 0, 0, 105000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -152.4, 881.6, 18.44, 273.59, -146.13, 886.24, 18.37, 180.09, 0, '', 0, 0, 0, '', '', '', 0),
(722, 0, 0, 112500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -120.97, 857.62, 18.58, 17.95, -121.82, 862.58, 17.76, 90.9, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(723, 0, 0, 112500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -122.86, 874.9, 18.73, 8.96, -123.85, 880.6, 18.64, 89.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(724, 0, 0, 105000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -153.36, 907.02, 19.3, 164.81, -151.71, 901.48, 18.51, 266.46, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(725, 0, 0, 112500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -151.31, 933.84, 19.72, 168.42, -150.44, 928.08, 19.19, 274.44, 0, '', 0, 0, 0, '', '', '', 0),
(726, 0, 0, 112500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -123.45, 917.69, 19.95, 95.64, -128.18, 915.37, 19.31, 205.82, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(727, 0, 0, 112500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -91.97, 887.24, 21.25, 60.92, -97.2, 889.12, 20.47, 144.33, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(728, 0, 0, 105000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -86.77, 915.67, 21.1, 78.59, -91.12, 911.41, 20.9, 357.47, 0, '', 0, 0, 0, '', '', '', 0),
(729, 0, 0, 105000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -83.07, 933.01, 20.69, 180.8, -86.67, 927.95, 20.48, 93.13, 0, '', 0, 0, 0, '', '', '', 0),
(730, 0, 0, 105000, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -127.32, 974.49, 19.85, 265.35, -122.21, 974.78, 19.56, 1.2, 0, '', 0, 0, 0, '', '', '', 0),
(731, 0, 0, 105000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -92.57, 970.11, 19.97, 342.33, -96.94, 976.36, 19.5, 271.15, 0, '', 0, 0, 0, '', '', '', 0),
(732, 0, 0, 105000, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -66.95, 971.65, 19.88, 94.42, -71.15, 967.5, 19.54, 1.78, 0, '', 0, 0, 0, '', '', '', 0),
(733, 0, 0, 105000, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -37.56, 962.44, 20.05, 266.64, -32.07, 964.58, 19.35, 0.63, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(734, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -56.57, 935.34, 21.2, 349.95, -58.07, 940.86, 20.44, 89.91, 0, '', 0, 0, 0, '', '', '', 0),
(735, 0, 0, 112500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -54.68, 918.71, 22.37, 14.78, -54.45, 923.66, 21.63, 90.33, 0, '', 0, 0, 0, '', '', '', 0),
(736, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -52.75, 894.21, 22.38, 348.12, -54.55, 899.32, 21.69, 92.2, 0, '', 0, 0, 0, '', '', '', 0),
(737, 0, 0, 112500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 17.74, 909.06, 23.95, 2.26, 22.41, 913.25, 23.42, 97.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(738, 0, 0, 112500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 31.47, 924.11, 23.59, 271.29, 30.73, 919.6, 23.32, 280.8, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(739, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -15.55, 934.29, 21.1, 186.56, -14.98, 929, 20.79, 89.42, 0, '', 0, 0, 0, '', '', '', 0),
(740, 0, 0, 112500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 20.67, 948.92, 20.31, 3.23, 19.04, 953.51, 19.7, 90.57, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(741, 0, 0, 112500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -12.84, 974.71, 19.79, 274.46, -6.82, 969.27, 19.47, 0.18, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(742, 0, 0, 112500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 70.3, 973.93, 15.75, 178.98, 67.14, 968.47, 16.22, 271.42, 0, '', 0, 0, 0, '', '', '', 0),
(743, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 65.02, 1005.33, 13.75, 8.64, 69.5, 1003.67, 13.61, 1.49, 0, '', 0, 0, 0, '', '', '', 0),
(744, 0, 0, 112500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 22.78, 968.13, 19.83, 348.4, 19.52, 974.63, 19.4, 263.43, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(745, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 718.95, 300.68, 20.37, 84.37, 712.98, 296.01, 19.94, 185.96, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(746, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 705.31, 292.08, 20.42, 202.7, 701.7, 287.63, 20.25, 278.65, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(747, 0, 0, 112500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 723.46, 269.57, 22.45, 169.37, 717.43, 267.08, 21.99, 89.82, 0, '', 0, 0, 0, '', '', '', 0),
(748, 0, 0, 112500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 748.38, 257.17, 27.08, 14.17, 746.85, 261.45, 26.79, 284.76, 0, '', 0, 0, 0, '', '', '', 0),
(749, 0, 0, 120000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 747.46, 278.16, 27.21, 278.58, 753.42, 275.13, 27.03, 195.34, 0, '', 0, 0, 0, '', '', '', 0),
(750, 0, 0, 112500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 746.46, 305.24, 20.23, 279.3, 751.33, 305.99, 19.93, 9.63, 0, '', 0, 0, 0, '', '', '', 0),
(751, 0, 0, 105000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 772.81, 348.2, 20.15, 92.26, 767.54, 347.13, 19.69, 11.12, 0, '', 0, 0, 0, '', '', '', 0),
(752, 0, 0, 105000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 784.07, 352.63, 19.59, 9.84, 778.76, 350.1, 19.35, 9.14, 0, '', 0, 0, 0, '', '', '', 0),
(753, 0, 0, 105000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 805.44, 358.39, 19.76, 356.84, 809.35, 363.4, 19.05, 85.84, 0, '', 0, 0, 0, '', '', '', 0),
(754, 0, 0, 105000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 758.78, 375.09, 23.39, 100.3, 755.22, 383.16, 22.87, 278.34, 0, '', 0, 0, 0, '', '', '', 0),
(755, 1, 0, 300000, 30, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2551.13, -5.39, 27.67, 87.89, 2551.05, 2.11, 26.18, 90.72, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(756, 1, 0, 300000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2549.22, 25.09, 27.67, 88.44, 2553.57, 13.95, 26.74, 90.15, 0, '', 0, 0, 0, '', '', '', 0),
(757, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2551.1, 57.32, 27.67, 92.77, 2557.36, 72.02, 26.18, 89.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(758, 1, 0, 337500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2551.12, 91.69, 27.67, 92.6, 2549.77, 81.29, 26.18, 90.12, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(759, 1, 1541740601, 337500, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2513.56, -28.37, 28.44, 3.11, 2517.67, -22.66, 26.89, 359.67, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(760, 1, 1541248841, 337500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2484.61, -28.4, 28.44, 354.05, 2479.8, -21.99, 26.78, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(761, 1, 1541222208, 337500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2509.41, 11.64, 28.44, 187.34, 2505.04, 6.08, 26.9, 178.5, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(762, 1, 0, 337500, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2488.26, 11.75, 28.44, 179.1, 2492.68, 6.07, 26.89, 179.44, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(763, 1, 0, 450000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2438.76, -54.85, 28.15, 0.05, 2443.85, -47.68, 26.91, 358.61, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(764, 1, 0, 450000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2415.37, -52.27, 28.15, 351.82, 2424.65, -54.03, 26.99, 359.5, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(765, 1, 0, 450000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2392.36, -54.9, 28.15, 354.11, 2397.59, -47.32, 26.88, 359.33, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(766, 1, 0, 450000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2367.31, -49.1, 28.15, 5.79, 2358.31, -54.68, 27.07, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(767, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2373.96, -8.64, 28.44, 269.48, 2379.93, -12.73, 26.83, 271.27, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(768, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2373.96, 21.95, 28.44, 267.99, 2379.99, 26.27, 26.82, 269.69, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(769, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2373.92, 42.32, 28.44, 269.13, 2379.6, 37.82, 26.88, 269.7, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(770, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2373.84, 70.9, 28.44, 263.7, 2379.19, 75.66, 26.95, 270.02, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(771, 1, 0, 375000, 16, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2411.1, -5.55, 27.68, 71.16, 2411.76, 1.93, 26.18, 89.66, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(772, 1, 0, 375000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2411.22, 21.92, 27.68, 87.83, 2410.68, 11.29, 26.18, 89.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(773, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2398.37, 111.75, 28.44, 171.65, 2402.92, 106.04, 26.89, 179.75, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(774, 1, 0, 375000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2413.57, 61.64, 28.44, 175.92, 2409.43, 55.78, 26.85, 178.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(775, 1, 0, 375000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2443.34, 61.76, 28.44, 176.83, 2447.85, 56.02, 26.88, 180.09, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(776, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2448.42, -11.14, 27.68, 181.34, 2433.6, -4.73, 26.18, 180.04, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(777, 1, 0, 375000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2446.63, 18.81, 27.68, 260.95, 2445.85, 11.42, 26.18, 269.64, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(778, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2481.02, 64.39, 27.68, 109.86, 2482.41, 71.99, 26.18, 90.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(779, 1, 1539958696, 375000, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2479.32, 94.51, 27.68, 344.83, 2494.21, 87.42, 26.18, 0.69, 0, '', 0, 0, 0, 'None', 'None', 'None', 0);
INSERT INTO `houses` (`id`, `class`, `day`, `price`, `hint`, `improve`, `gun`, `skin`, `safecode`, `safemoney`, `drugs`, `medkit`, `products`, `close`, `x`, `y`, `z`, `r`, `parkx`, `parky`, `parkz`, `parkr`, `ownerid`, `owner`, `peopleid1`, `peopleid2`, `peopleid3`, `people1`, `people2`, `people3`, `family`) VALUES
(780, 1, 0, 375000, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2514.15, 94.4, 27.68, 6.28, 2503.64, 95.66, 26.18, 0.4, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(781, 1, 1538417722, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2536.18, 128.89, 27.68, 178.68, 2528.66, 130.72, 26.18, 179.57, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(782, 1, 1539931648, 375000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2518.39, 128.91, 27.67, 181.96, 2503.55, 135.65, 26.18, 180.11, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(783, 1, 0, 375000, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2480.45, 126.99, 27.67, 185.64, 2491.57, 130.2, 26.73, 180.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(784, 1, 1541769751, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2458.92, 128.87, 27.67, 175.18, 2469.28, 127.46, 26.18, 179.62, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(785, 1, 1541395817, 375000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2443.85, 92.24, 28.44, 277.4, 2450.05, 87.79, 26.81, 269.76, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(786, 1, 0, 412500, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2363.88, 116.25, 28.44, 97.92, 2358.39, 120.52, 26.91, 89.3, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(787, 1, 0, 412500, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2363.89, 142.09, 28.44, 93.97, 2365.31, 146.16, 27.54, 89.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(788, 1, 0, 412500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2363.96, 166.02, 28.44, 85.31, 2358.09, 170.41, 26.86, 90.1, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(789, 1, 0, 412500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2363.85, 187.38, 28.44, 91.88, 2358.52, 182.74, 26.93, 90.12, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(790, 1, 0, 412500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2323.96, 191.25, 28.44, 268.88, 2329.4, 195.64, 26.91, 270.69, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(791, 1, 1532019083, 412500, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2323.95, 162.3, 28.44, 276.61, 2329.76, 157.87, 26.86, 269.27, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(792, 1, 1538921005, 412500, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2323.95, 136.16, 28.44, 271.08, 2329.36, 132.12, 26.92, 269.14, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(793, 1, 1540388306, 412500, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2323.95, 116.19, 28.44, 266.96, 2329.07, 124.48, 26.97, 269.93, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(794, 1, 1540678903, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2285.93, 161.54, 28.44, 178.78, 2290.55, 155.86, 26.86, 180.21, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(795, 1, 0, 412500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2258.12, 168.33, 28.15, 188.31, 2252.54, 162.17, 27, 179.8, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(796, 1, 0, 562500, 23, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2236.42, 168.21, 28.15, 177.29, 2231.21, 171.6, 27.18, 180.47, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(797, 1, 0, 375000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2203.96, 106.06, 28.44, 271.87, 2210.22, 110.58, 26.78, 270.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(798, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2203.85, 62.21, 28.44, 283.12, 2209.83, 57.89, 26.85, 269.85, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(799, 1, 0, 375000, 31, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2269.47, 111.76, 28.44, 186.48, 2264.96, 106.24, 26.92, 178.92, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(800, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2249.26, 111.73, 28.44, 179.14, 2253.59, 105.95, 26.88, 179.92, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(801, 1, 0, 375000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2245.28, -1.66, 28.15, 183.98, 2240.18, -9.87, 26.84, 180.24, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(802, 1, 0, 375000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2270.52, -7.6, 28.15, 174.43, 2279.34, -4.54, 26.93, 180.63, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(803, 1, 0, 450000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2200.07, -37.44, 28.15, 261.94, 2198.67, -46.6, 26.97, 270.55, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(804, 1, 0, 450000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2197.35, -60.92, 28.15, 265.55, 2204.92, -66.04, 26.88, 268.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(805, 1, 1540119280, 450000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2203.1, -89.48, 28.15, 267.92, 2201.29, -80.31, 26.87, 269.84, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(806, 1, 0, 450000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2245.52, -122.28, 28.15, 355.1, 2254.49, -124.36, 27.01, 359.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(807, 1, 0, 450000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2272.41, -119.13, 28.15, 3.31, 2263.17, -123.61, 27.01, 0.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(808, 1, 1540402015, 450000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 2293.79, -124.94, 28.15, 359.36, 2298.93, -117.15, 26.87, 0, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(809, 1, 1542351912, 450000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 2322.35, -124.96, 28.15, 3.29, 2327.35, -118.32, 26.96, 0.22, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(810, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 818.32, -509.42, 18.01, 178.7, 827.14, -508.33, 16.68, 179.6, 0, '', 0, 0, 0, '', '', '', 0),
(811, 1, 0, 412500, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 795.21, -506.15, 18.01, 173.85, 786.04, -489.36, 17.04, 180.78, 0, '', 0, 0, 0, '', '', '', 0),
(812, 1, 0, 412500, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 768.39, -503.59, 18.01, 187.17, 762.88, -511.93, 16.68, 180.1, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(813, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 743.06, -509.31, 18.01, 184.04, 752.04, -508.54, 16.67, 179.99, 0, '', 0, 0, 0, '', '', '', 0),
(814, 1, 0, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 766.65, -556.66, 18.01, 3.08, 771.64, -549.66, 16.78, 359.44, 0, '', 0, 0, 0, '', '', '', 0),
(815, 1, 0, 412500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 745.18, -556.78, 18.01, 7.18, 750.26, -549.79, 16.79, 359.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(816, 1, 0, 412500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 745.56, -590.94, 18.01, 83.84, 748.88, -582.31, 16.92, 89.11, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(817, 1, 0, 150000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 1111.51, -976.44, 42.76, 359.76, 1115.29, -963.26, 42.46, 273.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(818, 1, 0, 225000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 267.59, -54.64, 2.77, 170.59, 278.03, -56.73, 1.28, 180.23, 0, '', 0, 0, 0, 'None', '', '', 0),
(819, 1, 0, 225000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 295.02, -54.63, 2.77, 181.28, 287.33, -54.33, 1.28, 180.45, 0, '', 0, 0, 0, 'None', '', '', 0),
(820, 1, 0, 225000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 312.72, -92.37, 3.53, 270, 318.39, -87.76, 1.99, 269.48, 0, '', 0, 0, 0, 'None', '', '', 0),
(821, 1, 0, 225000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 312.83, -121.2, 3.53, 272.95, 318.49, -125.82, 1.98, 269.69, 0, '', 0, 0, 0, '', '', '', 0),
(822, 1, 0, 225000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, 252.82, -92.36, 3.53, 95.78, 247.74, -88.05, 2.08, 90.05, 0, '', 0, 0, 0, '', '', '', 0),
(823, 1, 0, 225000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, 252.79, -121.22, 3.53, 85.74, 247.48, -126, 2.03, 90.09, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(824, 0, 0, 127500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -347.87, -1045.76, 59.81, 174.87, -340.34, -1043.02, 58.94, 173.53, 0, '', 0, 0, 0, '', '', '', 0),
(825, 1, 0, 300000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2563.19, 1148.98, 55.72, 153.9, -2568.16, 1146.99, 55.43, 158.1, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(826, 1, 0, 300000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2549.14, 1145.62, 55.72, 169.11, -2542.13, 1141.01, 55.43, 168.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(827, 1, 1541574893, 300000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2534.75, 1143.6, 55.72, 176.67, -2531.36, 1139.76, 55.43, 172.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(828, 1, 0, 300000, 33, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2523.86, 1142.59, 55.72, 158, -2527.64, 1139.29, 55.43, 172.02, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(829, 1, 0, 300000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2517.05, 1142.41, 55.72, 170.17, -2514.05, 1139.06, 55.43, 176.35, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(830, 1, 0, 300000, 24, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2506.41, 1142.14, 55.72, 182.34, -2499.53, 1138.44, 55.43, 179.59, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(831, 1, 0, 300000, 17, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2493.46, 1141.95, 55.72, 193.59, -2485.82, 1138.25, 55.43, 180.13, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(832, 1, 0, 300000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2479.08, 1141.87, 55.72, 179.1, -2475.27, 1138.45, 55.43, 180.2, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(833, 1, 0, 300000, 22, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2468.51, 1141.81, 55.73, 172.68, -2471.63, 1138.36, 55.43, 180.06, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(834, 1, 0, 300000, 36, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2461.69, 1141.89, 55.72, 169.88, -2454.84, 1138.66, 55.43, 179.19, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(835, 1, 0, 300000, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2451.26, 1141.75, 55.73, 177.93, -2444.64, 1137.84, 55.43, 176.34, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(836, 1, 1541175654, 300000, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2438.36, 1140.9, 55.72, 173.31, -2430.94, 1137, 55.43, 177.54, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(837, 1, 0, 300000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2424.1, 1139.45, 55.72, 171.17, -2421.02, 1135.66, 55.43, 168.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(838, 1, 0, 300000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2413.63, 1137.52, 55.72, 167.05, -2410.88, 1134.69, 55.43, 169.48, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(839, 1, 0, 300000, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2406.93, 1135.74, 55.72, 167.54, -2401.04, 1130.64, 55.43, 164.51, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(840, 1, 0, 300000, 38, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2396.73, 1132.77, 55.73, 158.98, -2390.83, 1127.17, 55.43, 162.37, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(841, 1, 0, 300000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2383.72, 1127.99, 55.72, 154.03, -2377.15, 1122.37, 55.43, 161.68, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(842, 1, 0, 300000, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2369.72, 1121.88, 55.73, 156.17, -2366.73, 1117.79, 55.43, 161.46, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(843, 1, 0, 300000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2358.98, 1117.98, 55.72, 161.42, -2363.32, 1116, 55.43, 160.44, 0, '', 0, 0, 0, '', '', '', 0),
(844, 0, 0, 90000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -168.58, 2707.21, 62.53, 69.83, -178.99, 2706.04, 62.39, 0.26, 0, '', 0, 0, 0, '', '', '', 0),
(845, 0, 0, 90000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -161.44, 2728.21, 62.2, 265.49, -154.72, 2731.3, 61.66, 181.22, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(846, 0, 0, 90000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -201.72, 2771.51, 62.34, 355.97, -206.86, 2771.8, 61.99, 179.16, 0, '', 0, 0, 0, '', '', '', 0),
(847, 0, 0, 90000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -232.21, 2807.59, 62.05, 97.13, -229.51, 2800.57, 61.65, 90.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(848, 0, 0, 90000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -219.56, 2767.56, 62.79, 153.06, -222.95, 2769.77, 62.37, 178.23, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(849, 0, 0, 90000, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -258.08, 2782.9, 62.68, 167.7, -249.58, 2784.78, 62.28, 180.52, 0, '', 0, 0, 0, '', '', '', 0),
(850, 0, 0, 90000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -268.7, 2769.59, 61.87, 118.75, -273.59, 2766.06, 61.75, 179.39, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(851, 0, 0, 90000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -287.62, 2758.22, 62.51, 271.08, -281.89, 2759.3, 61.96, 180.78, 0, '', 0, 0, 0, '', '', '', 0),
(852, 0, 0, 90000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -275.45, 2736.22, 62.75, 178.96, -264.47, 2735.71, 62.39, 180, 0, '', 0, 0, 0, '', '', '', 0),
(853, 0, 0, 90000, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -311.37, 2726.82, 63.07, 273.88, -312.84, 2732.07, 62.39, 272.13, 0, '', 0, 0, 0, '', '', '', 0),
(854, 0, 0, 90000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -279.55, 2721.95, 62.79, 5.93, -275.97, 2719.15, 62.32, 0.38, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(855, 0, 0, 90000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -604.04, 2716.71, 72.72, 111.12, -609.27, 2717.01, 71.97, 181.99, 0, '', 0, 0, 0, '', '', '', 0),
(856, 1, 0, 450000, 6, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -910.81, 2686.12, 42.37, 43.36, -904.58, 2698.45, 42.07, 44.42, 0, '', 0, 0, 0, 'None', '', '', 0),
(857, 0, 0, 82500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1446.78, 2637.23, 56.25, 199.29, -1447.7, 2631.82, 55.54, 270.75, 0, '', 0, 0, 0, '', '', '', 0),
(858, 0, 0, 82500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1445.09, 2653.12, 56.26, 250.78, -1439.95, 2653.71, 55.54, 359.57, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(859, 0, 0, 82500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1459.59, 2653.68, 55.83, 263.54, -1454.68, 2656.66, 55.54, 359.31, 0, '', 0, 0, 0, '', '', '', 0),
(860, 0, 0, 82500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1450.3, 2690.88, 56.17, 89.66, -1450.5, 2681.24, 55.54, 90.53, 0, '', 0, 0, 0, '', '', '', 0),
(861, 0, 0, 82500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1465.9, 2693.06, 56.26, 95.75, -1470.93, 2692.99, 55.44, 180.74, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(862, 0, 0, 82500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1482.52, 2702.7, 56.25, 172.24, -1473, 2703.14, 55.47, 181.85, 0, '', 0, 0, 0, '', '', '', 0),
(863, 0, 0, 82500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1491.49, 2686.02, 55.85, 166.98, -1495.51, 2679.68, 55.54, 89.7, 0, '', 0, 0, 0, '', '', '', 0),
(864, 0, 0, 82500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1512, 2695.84, 56.07, 186.55, -1507.5, 2697.61, 55.44, 180.25, 0, '', 0, 0, 0, '', '', '', 0),
(865, 0, 0, 82500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1529.76, 2686, 55.83, 291.34, -1529.6, 2679.26, 55.54, 89.85, 0, '', 0, 0, 0, '', '', '', 0),
(866, 0, 0, 82500, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1550.43, 2699.79, 56.26, 88.18, -1555.28, 2699.85, 55.44, 181.35, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(867, 0, 0, 93750, 9, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1565.08, 2712.13, 55.85, 278.84, -1559.46, 2712.52, 55.51, 177.5, 0, '', 0, 0, 0, '', '', '', 0),
(868, 0, 0, 82500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1577.66, 2686.57, 55.83, 184.91, -1573.08, 2680.34, 55.54, 86.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(869, 0, 0, 82500, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1563.58, 2651.04, 55.92, 282.55, -1566.41, 2647.66, 55.44, 268.23, 0, '', 0, 0, 0, '', '', '', 0),
(870, 0, 0, 93750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1587.07, 2650.12, 55.85, 89.1, -1590.73, 2655.06, 55.44, 0.52, 0, '', 0, 0, 0, '', '', '', 0),
(871, 0, 0, 82500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1568.22, 2630.22, 55.84, 153.97, -1571.51, 2625.57, 55.46, 267.57, 0, '', 0, 0, 0, '', '', '', 0),
(872, 1, 0, 157500, 25, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1532.65, 2656.7, 56.28, 96.39, -1538.88, 2653.78, 55.54, 0.17, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(873, 0, 0, 82500, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1512.59, 2646.96, 56.17, 93.82, -1510.25, 2637.86, 55.54, 268.72, 0, '', 0, 0, 0, '', '', '', 0),
(874, 0, 0, 82500, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1476.18, 2563.29, 56.17, 171.96, -1475.04, 2558.04, 55.44, 89.34, 0, '', 0, 0, 0, '', '', '', 0),
(875, 0, 0, 82500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1478.49, 2547.23, 56.25, 140.37, -1479.98, 2541.67, 55.44, 64.68, 0, '', 0, 0, 0, '', '', '', 0),
(876, 0, 0, 97500, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1670.14, 2546.27, 85.23, 180.66, -1659.84, 2549.82, 84.95, 177.89, 0, '', 0, 0, 0, '', '', '', 0),
(877, 0, 0, 101250, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1668.03, 2486.12, 87.17, 257.48, -1670.94, 2495.84, 86.78, 270.84, 0, '', 0, 0, 0, '', '', '', 0),
(878, 0, 0, 101250, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1669.56, 2597.6, 81.44, 356.01, -1677.45, 2593.89, 81.12, 359.83, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(879, 0, 0, 108750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -1827.03, 2042.1, 8.66, 117.47, -1831.02, 2049.62, 8.97, 120.53, 0, '', 0, 0, 0, '', '', '', 0),
(880, 0, 0, 108750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1802.59, 2037.85, 9.59, 36.36, -1810.47, 2031.32, 9.1, 28.3, 0, '', 0, 0, 0, '', '', '', 0),
(881, 1, 0, 142500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -1051.55, 1550.06, 33.43, 210.79, -1043.13, 1562.03, 33.09, 221.23, 0, '', 0, 0, 0, '', '', '', 0),
(882, 3, 0, 6000000, 27, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -684.05, 939.65, 13.63, 84.85, -675.9, 966.84, 11.83, 271.81, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(883, 3, 0, 6000000, 2, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -692.22, 939.6, 13.63, 266.03, -689.73, 965.99, 11.88, 88.94, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(884, 0, 0, 75000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -636.57, 1446.85, 13.99, 104.57, -640.16, 1443.77, 13.32, 34.48, 0, '', 0, 0, 0, '', '', '', 0),
(885, 0, 0, 75000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -690.05, 1444.39, 17.8, 275.56, -688.55, 1453.41, 17.1, 269.97, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(886, 0, 0, 75000, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -715.61, 1438.89, 18.88, 86.79, -713.66, 1428.71, 18.18, 90.74, 0, '', 0, 0, 0, '', '', '', 0),
(887, 0, 0, 75000, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -742.99, 1432.53, 16.11, 179.73, -747.48, 1436.32, 15.82, 0.43, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(888, 0, 0, 75000, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -906.45, 1514.49, 26.31, 262.7, -909.79, 1524.01, 25.61, 269.62, 0, '', 0, 0, 0, '', '', '', 0),
(889, 1, 0, 135000, 11, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2075.84, -2312.71, 31.13, 57.73, -2069.54, -2306.23, 30.33, 52.63, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(890, 1, 0, 187500, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2220.34, -2400, 32.58, 226.9, -2217.68, -2407.37, 30.86, 232.62, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(891, 1, 0, 187500, 0, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2239.26, -2423.71, 32.7, 232.98, -2232.12, -2423.86, 31.16, 230.78, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(892, 1, 0, 187500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2214.05, -2451.91, 31.81, 64.69, -2206.26, -2438.99, 30.32, 51.77, 0, '', 0, 0, 0, '', '', '', 0),
(893, 1, 0, 187500, 41, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2224.44, -2482.97, 31.81, 322.03, -2235.14, -2478.4, 30.87, 321.36, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(894, 1, 0, 187500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2173.91, -2481.56, 31.81, 133.51, -2179.18, -2476.33, 30.32, 141.78, 0, '', 0, 0, 0, '', '', '', 0),
(895, 1, 0, 187500, 19, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2192.94, -2510.36, 31.81, 318.47, -2200.32, -2503.05, 30.32, 321.39, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(896, 1, 0, 187500, 5, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2180.96, -2520.03, 31.81, 328.34, -2168.34, -2527.56, 30.32, 321.46, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(897, 1, 0, 187500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2161.36, -2535.62, 31.81, 324.55, -2148.57, -2543.14, 30.32, 321.73, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(898, 1, 0, 187500, 4, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2132.64, -2511.1, 31.81, 226.83, -2124.58, -2504.02, 30.32, 231.55, 0, '', 0, 0, 0, 'None', '', '', 0),
(899, 0, 0, 93750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2069.36, -2494.95, 31.06, 56.23, -2073.02, -2491.43, 30.33, 141.88, 0, '', 0, 0, 0, '', '', '', 0),
(900, 0, 0, 93750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2087.23, -2510.61, 31.06, 51.13, -2091.41, -2507.88, 30.33, 141.46, 0, '', 0, 0, 0, '', '', '', 0),
(901, 0, 0, 93750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2101.06, -2532.63, 31.06, 25.79, -2106.82, -2529.34, 30.33, 319.33, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(902, 0, 0, 93750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2081.85, -2548.35, 30.84, 321.46, -2079.32, -2554.27, 30.19, 319.18, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(903, 0, 0, 93750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2067.68, -2536.86, 30.84, 144.71, -2069.26, -2532.09, 30.33, 138.51, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(904, 0, 0, 93750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2075.22, -2526.52, 31.06, 210.57, -2069.64, -2517.47, 30.25, 224.55, 0, '', 0, 0, 0, '', '', '', 0),
(905, 0, 0, 93750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2058.09, -2503.45, 31.06, 56.92, -2061.15, -2498.7, 30.34, 134.51, 0, '', 0, 0, 0, '', '', '', 0),
(906, 0, 0, 93750, 40, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2045.12, -2522.37, 31.06, 142.61, -2036.53, -2526.63, 30.32, 140.95, 0, '', 0, 0, 0, '', '', '', 0),
(907, 0, 0, 93750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2052.98, -2544.54, 31.06, 42.43, -2057.89, -2553.15, 30.13, 52.24, 0, '', 0, 0, 0, '', '', '', 0),
(908, 0, 0, 93750, 3, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2068.77, -2561.64, 31.06, 45.87, -2073.52, -2570.32, 30.33, 50.65, 0, '', 0, 0, 0, 'None', 'None', 'None', 0),
(909, 0, 0, 93750, 39, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 1, -2031.13, -2538.88, 31.06, 226.07, -2026.15, -2541.32, 30.33, 140.93, 0, '', 0, 0, 0, '', '', '', 0),
(910, 0, 0, 93750, 10, '0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0', 0, 0, 0, 0, 0, 0, -2042.49, -2558.85, 30.84, 119.13, -2045.57, -2565.82, 30.33, 45.07, 0, '', 0, 0, 0, '', '', '', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `jobinfo`
--

CREATE TABLE `jobinfo` (
  `ji_id` int(9) NOT NULL,
  `ji_uid` int(9) NOT NULL,
  `ji_date_invite` date NOT NULL,
  `ji_date_uninvite` date NOT NULL,
  `ji_fraction` int(6) NOT NULL DEFAULT 0,
  `ji_reason` varchar(64) NOT NULL,
  `ji_warnings` int(6) NOT NULL DEFAULT 0,
  `ji_rang` int(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `jobinfo`
--

INSERT INTO `jobinfo` (`ji_id`, `ji_uid`, `ji_date_invite`, `ji_date_uninvite`, `ji_fraction`, `ji_reason`, `ji_warnings`, `ji_rang`) VALUES
(1, 1, '0000-00-00', '2019-03-29', 18, '1', 0, 10),
(2, 5, '0000-00-00', '2019-03-29', 1, '1', 0, 11),
(3, 13, '2020-02-26', '2020-02-26', 2, 'Снят с поста лидера', 0, 11),
(4, 13, '2020-02-26', '2020-02-27', 18, 'Снят с поста лидера', 0, 10),
(5, 13, '2020-02-27', '2020-02-27', 23, 'Снят с поста лидера', 0, 12),
(6, 13, '2020-02-27', '2020-02-27', 2, 'Снят с поста лидера', 0, 11),
(7, 13, '2020-02-27', '2020-04-17', 23, 'Снят с поста лидера', 0, 12),
(8, 16, '2020-04-18', '2020-04-18', 4, 'Снят с поста лидера', 0, 11),
(9, 16, '2020-04-18', '2020-04-19', 23, 'Снят с поста лидера', 0, 12),
(10, 13, '2020-05-20', '2020-05-20', 1, 'Снят с поста лидера', 0, 11),
(11, 13, '2020-05-20', '2020-05-20', 1, 'Снят с поста лидера', 0, 11),
(12, 13, '2020-05-20', '2020-05-20', 8, 'Снят с поста лидера', 0, 7),
(13, 13, '2020-05-20', '2020-05-20', 1, 'Снят с поста лидера', 0, 11),
(14, 13, '2020-05-20', '2020-05-20', 10, 'Снят с поста лидера', 0, 7),
(15, 13, '2020-05-20', '2020-05-23', 6, 'Снят с поста лидера', 0, 15),
(16, 13, '2020-05-23', '2020-06-21', 1, 'Снят с поста лидера', 0, 11),
(17, 13, '2020-12-09', '2020-12-09', 18, 'Снят с поста лидера', 0, 10),
(18, 13, '2020-12-09', '2020-12-10', 19, 'Снят с поста лидера', 0, 10),
(19, 13, '2020-12-10', '2020-12-10', 6, 'Снят с поста лидера', 0, 15),
(20, 1, '0000-00-00', '2023-05-05', 8, '@', 0, 7),
(21, 1, '0000-00-00', '2023-05-05', 8, '@', 0, 7),
(22, 1, '0000-00-00', '2023-05-07', 8, '1', 0, 7),
(23, 1, '0000-00-00', '2023-05-07', 23, '0', 0, 12),
(24, 1, '0000-00-00', '2023-05-07', 1, 'p', 0, 11),
(25, 1, '0000-00-00', '2023-05-09', 1, '0', 0, 11),
(26, 1, '2023-05-10', '2024-02-02', 1, 'Снят с поста лідера', 0, 11);

-- --------------------------------------------------------

--
-- Структура таблицы `keys_log`
--

CREATE TABLE `keys_log` (
  `id` int(5) NOT NULL,
  `owner` varchar(32) NOT NULL,
  `type` varchar(24) NOT NULL,
  `items` varchar(15) NOT NULL,
  `content` varchar(23) NOT NULL,
  `status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `keys_sklad`
--

CREATE TABLE `keys_sklad` (
  `id` int(5) NOT NULL,
  `owner` varchar(32) NOT NULL,
  `type` varchar(24) NOT NULL,
  `items` varchar(15) NOT NULL,
  `content` varchar(23) NOT NULL,
  `status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `labrary`
--

CREATE TABLE `labrary` (
  `id` int(10) UNSIGNED NOT NULL,
  `actor_1` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `actor_2` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `actor_3` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `actor_t1` varchar(128) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `actor_t2` varchar(128) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `actor_t3` varchar(128) NOT NULL DEFAULT '0|0|0|0|0|0|0|0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `labrary`
--

INSERT INTO `labrary` (`id`, `actor_1`, `actor_2`, `actor_3`, `actor_t1`, `actor_t2`, `actor_t3`) VALUES
(1, '0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0', '1538253318|1538675292|1538675297|1538675301|153', '1540224768|1540224773|1540224784|1540224779|153', '1538574656|1538683238|1538683242|1538683245|153');

-- --------------------------------------------------------

--
-- Структура таблицы `lottery_session`
--

CREATE TABLE `lottery_session` (
  `id` int(11) NOT NULL,
  `Name` varchar(32) NOT NULL,
  `type` varchar(32) NOT NULL,
  `win` varchar(32) NOT NULL,
  `sell` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `lottery_sessionall`
--

CREATE TABLE `lottery_sessionall` (
  `id` int(11) NOT NULL,
  `Name` varchar(32) NOT NULL,
  `type` varchar(32) NOT NULL,
  `win` varchar(32) NOT NULL,
  `sell` varchar(32) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `nickname_history`
--

CREATE TABLE `nickname_history` (
  `nh_id` int(6) NOT NULL,
  `nh_owner` int(6) NOT NULL,
  `nh_oldname` varchar(24) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `nh_newname` varchar(24) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `nh_date` date NOT NULL,
  `nh_admin` varchar(24) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'none'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `online_player`
--

CREATE TABLE `online_player` (
  `id` int(11) NOT NULL,
  `accountid` int(11) NOT NULL,
  `date` date NOT NULL,
  `online_sec` int(11) NOT NULL DEFAULT 0,
  `afk_sec` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `online_player`
--

INSERT INTO `online_player` (`id`, `accountid`, `date`, `online_sec`, `afk_sec`) VALUES
(1, 1, '2023-04-27', 337, 20),
(2, 2, '2023-04-27', 36, 10),
(3, 1, '2023-05-05', 4651, 405),
(4, 3, '2023-05-05', 512, 83),
(5, 1, '2023-05-06', 3358, 632),
(6, 1, '2023-05-07', 5967, 537),
(7, 1, '2023-05-08', 5226, 596),
(8, 4, '2023-05-08', 59, 10),
(9, 5, '2023-05-08', 18, 10),
(10, 6, '2023-05-08', 44, 10),
(11, 7, '2023-05-09', 42, 9),
(12, 1, '2023-05-09', 6191, 924),
(13, 8, '2023-05-09', 14, 10),
(14, 1, '2023-05-10', 6316, 914),
(15, 9, '2023-05-10', 32, 19),
(16, 1, '2023-05-11', 304, 44),
(17, 1, '2023-07-13', 298, 98),
(18, 1, '2023-09-17', 343, 49),
(19, 1, '2024-02-02', 1721, 607),
(20, 1, '2024-02-03', 596, 187);

-- --------------------------------------------------------

--
-- Структура таблицы `others`
--

CREATE TABLE `others` (
  `id` int(11) NOT NULL,
  `bonus_payday` int(11) NOT NULL DEFAULT 1,
  `gun_mats` int(11) NOT NULL DEFAULT 0,
  `oil_mats` int(11) NOT NULL DEFAULT 0,
  `pricedrugs` int(11) NOT NULL DEFAULT 0,
  `disease` int(11) NOT NULL DEFAULT 0,
  `bonus_donate` int(11) NOT NULL DEFAULT 0,
  `bonus_skills` int(11) NOT NULL DEFAULT 0,
  `casino` int(11) NOT NULL DEFAULT 0,
  `woodsklad` int(11) NOT NULL DEFAULT 0,
  `tk_unloading_0` int(11) NOT NULL DEFAULT 0,
  `tk_unloading_1` int(11) NOT NULL DEFAULT 0,
  `tk_unloading_2` int(11) NOT NULL DEFAULT 0,
  `tk_unloading_3` int(11) NOT NULL DEFAULT 0,
  `rep_system` int(11) NOT NULL DEFAULT 0,
  `duels` int(11) NOT NULL DEFAULT 0,
  `invite_frac0` int(11) NOT NULL DEFAULT 1,
  `invite_frac1` int(11) NOT NULL DEFAULT 1,
  `invite_frac2` int(11) NOT NULL DEFAULT 1,
  `invite_frac3` int(11) NOT NULL DEFAULT 1,
  `invite_frac4` int(11) NOT NULL DEFAULT 1,
  `invite_frac5` int(11) NOT NULL DEFAULT 1,
  `invite_frac6` int(11) NOT NULL DEFAULT 1,
  `invite_frac7` int(11) NOT NULL DEFAULT 1,
  `anti_tk` int(11) NOT NULL DEFAULT 1,
  `start_money` int(11) NOT NULL DEFAULT 200,
  `start_level` int(11) NOT NULL DEFAULT 1,
  `show_update` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `others`
--

INSERT INTO `others` (`id`, `bonus_payday`, `gun_mats`, `oil_mats`, `pricedrugs`, `disease`, `bonus_donate`, `bonus_skills`, `casino`, `woodsklad`, `tk_unloading_0`, `tk_unloading_1`, `tk_unloading_2`, `tk_unloading_3`, `rep_system`, `duels`, `invite_frac0`, `invite_frac1`, `invite_frac2`, `invite_frac3`, `invite_frac4`, `invite_frac5`, `invite_frac6`, `invite_frac7`, `anti_tk`, `start_money`, `start_level`, `show_update`) VALUES
(1, 1, 84185916, 147689, 50, 2, 0, 1, 1, 2542890, 1000, 760, 850, 850, 1, 1, 3, 8, 1, 2, 2, 1, 8, 4, 1, 2000, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `perenos`
--

CREATE TABLE `perenos` (
  `Name` varchar(69) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `plane`
--

CREATE TABLE `plane` (
  `ID` int(10) UNSIGNED NOT NULL,
  `Airport` int(11) NOT NULL,
  `Plane` int(3) NOT NULL,
  `Owner` varchar(24) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'State',
  `Time` int(11) NOT NULL,
  `Price` int(11) NOT NULL DEFAULT 0,
  `Fuel` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '200.0',
  `PosX` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0.0',
  `PosY` varchar(16) CHARACTER SET ucs2 COLLATE ucs2_general_ci NOT NULL DEFAULT '0.0',
  `PosZ` varchar(16) CHARACTER SET ucs2 COLLATE ucs2_general_ci NOT NULL DEFAULT '0.0',
  `PosXY` varchar(16) CHARACTER SET ucs2 COLLATE ucs2_general_ci NOT NULL DEFAULT '0.0'
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `plane`
--

INSERT INTO `plane` (`ID`, `Airport`, `Plane`, `Owner`, `Time`, `Price`, `Fuel`, `PosX`, `PosY`, `PosZ`, `PosXY`) VALUES
(1, 1, 511, 'State', 0, 1, '200.0', '1887.9478', '-2628.5671', '15.0354', '0.0000'),
(2, 1, 593, 'State', 0, 1, '200.0', '1821.3348', '-2630.3672', '14.1154', '0.0000'),
(3, 1, 487, 'State', 0, 1, '200.0', '1753.2542', '-2630.3672', '13.7354', '0.0000'),
(4, 1, 487, 'State', 0, 1, '200.0', '1681.1455', '-2630.3672', '13.7354', '0.0000'),
(5, 1, 487, 'State', 0, 1, '200.0', '1616.0367', '-2630.3672', '13.7354', '0.0000'),
(6, 1, 469, 'State', 0, 1, '200.0', '1993.6591', '-2383.5505', '13.5154', '90.0000'),
(7, 1, 469, 'State', 0, 1, '200.0', '1993.6591', '-2316.0664', '13.5154', '90.0000'),
(8, 1, 469, 'State', 0, 1, '200.0', '1993.6591', '-2249.4150', '13.5154', '90.0000'),
(9, 2, 511, 'State', 0, 1, '200.0', '-1244.0624', '-95.3488', '15.6125', '135.0000'),
(10, 2, 593, 'State', 0, 1, '200.0', '-1203.8134', '-142.7209', '14.7725', '135.0000'),
(11, 2, 487, 'State', 0, 1, '200.0', '-1186.2402', '24.4745', '14.4445', '45.0000'),
(12, 2, 487, 'State', 0, 1, '200.0', '-1199.0326', '11.3758', '14.4445', '45.0000'),
(13, 2, 487, 'State', 0, 1, '200.0', '-1212.0719', '-1.5953', '14.4445', '45.0000'),
(14, 2, 469, 'State', 0, 1, '200.0', '-1223.6609', '-14.2141', '14.1053', '45.0000'),
(15, 2, 469, 'State', 0, 1, '200.0', '-1234.1038', '-24.4651', '14.1053', '45.0000'),
(16, 2, 469, 'State', 0, 1, '200.0', '-1244.4580', '-34.6806', '14.1053', '45.0000'),
(17, 3, 511, 'State', 0, 1, '200.0', '1282.8374', '1324.0339', '12.2925', '-90.0000'),
(18, 3, 593, 'State', 0, 1, '200.0', '1284.1250', '1361.7029', '11.3808', '-90.0000'),
(19, 3, 487, 'State', 0, 1, '200.0', '1692.5758', '1634.9969', '11.0578', '180.0000'),
(20, 3, 487, 'State', 0, 1, '200.0', '1677.6940', '1634.9969', '11.0578', '180.0000'),
(21, 3, 487, 'State', 0, 1, '200.0', '1661.2939', '1634.9969', '11.0578', '180.0000'),
(22, 3, 469, 'State', 0, 1, '200.0', '1624.0198', '1635.4465', '10.8301', '180.0000'),
(23, 3, 469, 'State', 0, 1, '200.0', '1610.2981', '1635.4465', '10.8301', '180.0000'),
(24, 3, 469, 'State', 0, 1, '200.0', '1596.2383', '1635.4465', '10.8301', '180.0000');

-- --------------------------------------------------------

--
-- Структура таблицы `promocode`
--

CREATE TABLE `promocode` (
  `code` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `money` int(11) NOT NULL,
  `skills` int(11) NOT NULL,
  `lics` int(11) NOT NULL,
  `data` int(11) NOT NULL,
  `used_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `promocode`
--

INSERT INTO `promocode` (`code`, `money`, `skills`, `lics`, `data`, `used_count`) VALUES
('#GREPOY', 50000, 6, 0, 1682544184, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `promocode_used`
--

CREATE TABLE `promocode_used` (
  `id` int(5) NOT NULL,
  `idacca` varchar(30) DEFAULT NULL,
  `code` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_cs DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin ROW_FORMAT=FIXED;

--
-- Дамп данных таблицы `promocode_used`
--

INSERT INTO `promocode_used` (`id`, `idacca`, `code`) VALUES
(8, '1', '#GREPOY');

-- --------------------------------------------------------

--
-- Структура таблицы `questsprogress`
--

CREATE TABLE `questsprogress` (
  `idquest` int(11) NOT NULL,
  `progress` int(11) NOT NULL,
  `accept` int(11) NOT NULL,
  `name` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `questsprogress`
--

INSERT INTO `questsprogress` (`idquest`, `progress`, `accept`, `name`) VALUES
(1, 0, 1, 'Klaus_Gurrens');

-- --------------------------------------------------------

--
-- Структура таблицы `reports`
--

CREATE TABLE `reports` (
  `id` int(5) NOT NULL,
  `rText` varchar(64) NOT NULL,
  `rOtvet` varchar(64) NOT NULL,
  `rNick` varchar(32) NOT NULL,
  `count` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `rjlist`
--

CREATE TABLE `rjlist` (
  `id` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `lvl` int(11) NOT NULL DEFAULT 0,
  `nick` varchar(25) NOT NULL,
  `forum` int(11) NOT NULL DEFAULT 0,
  `vk` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `owner` varchar(24) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL DEFAULT 'None',
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `r` float NOT NULL,
  `doors` int(11) NOT NULL DEFAULT 0,
  `day` int(11) NOT NULL DEFAULT 0,
  `hotel` int(11) NOT NULL,
  `vw` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `rooms`
--

INSERT INTO `rooms` (`id`, `owner`, `x`, `y`, `z`, `r`, `doors`, `day`, `hotel`, `vw`) VALUES
(1, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1683545674, 1, 1),
(2, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1542019483, 1, 1),
(3, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540760247, 1, 1),
(4, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540975157, 1, 1),
(5, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540820259, 1, 1),
(6, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541784514, 1, 1),
(7, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541530066, 1, 1),
(8, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541165220, 1, 1),
(9, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541220825, 1, 1),
(10, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541077937, 1, 1),
(11, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540745039, 1, 2),
(12, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540710499, 1, 2),
(13, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540881026, 1, 2),
(14, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540967371, 1, 2),
(15, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541157110, 1, 2),
(16, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541014253, 1, 2),
(17, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540716796, 1, 2),
(18, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540737713, 1, 2),
(19, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541069208, 1, 2),
(20, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540902424, 1, 2),
(21, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540759964, 1, 3),
(22, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541685765, 1, 3),
(23, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540990841, 1, 3),
(24, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541585932, 1, 3),
(25, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541098137, 1, 3),
(26, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540904135, 1, 3),
(27, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541176823, 1, 3),
(28, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540711438, 1, 3),
(29, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540733791, 1, 3),
(30, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541083323, 1, 3),
(31, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540745882, 1, 4),
(32, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540753699, 1, 4),
(33, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541508188, 1, 4),
(34, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540762646, 1, 4),
(35, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540658508, 1, 4),
(36, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540653537, 1, 4),
(37, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541451149, 1, 4),
(38, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541156593, 1, 4),
(39, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540984675, 1, 4),
(40, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540578189, 1, 4),
(41, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540800609, 1, 5),
(42, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540649455, 1, 5),
(43, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541100535, 1, 5),
(44, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540656172, 1, 5),
(45, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541676822, 1, 5),
(46, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540902433, 1, 5),
(47, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541704090, 1, 5),
(48, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541106588, 1, 5),
(49, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541349247, 1, 5),
(50, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540672035, 1, 5),
(51, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540661171, 1, 6),
(52, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540629633, 1, 6),
(53, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540665444, 1, 6),
(54, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540662420, 1, 6),
(55, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540993059, 1, 6),
(56, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541352376, 1, 6),
(57, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540666062, 1, 6),
(58, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541009495, 1, 6),
(59, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540826089, 1, 6),
(60, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541558722, 1, 6),
(61, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1542033913, 2, 7),
(62, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541599400, 2, 7),
(63, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541313659, 2, 7),
(64, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541865816, 2, 7),
(65, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541937384, 2, 7),
(66, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541181156, 2, 7),
(67, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541069485, 2, 7),
(68, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540749577, 2, 7),
(69, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540792172, 2, 7),
(70, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541871293, 2, 7),
(71, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540892276, 2, 8),
(72, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541439229, 2, 8),
(73, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541317403, 2, 8),
(74, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541414758, 2, 8),
(75, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540746328, 2, 8),
(76, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540836238, 2, 8),
(77, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541168038, 2, 8),
(78, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540737866, 2, 8),
(79, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540837380, 2, 8),
(80, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541703482, 2, 8),
(81, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540882369, 2, 9),
(82, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541497278, 2, 9),
(83, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540747885, 2, 9),
(84, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541009737, 2, 9),
(85, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540994413, 2, 9),
(86, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541157886, 2, 9),
(87, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541522777, 2, 9),
(88, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541562659, 2, 9),
(89, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541089885, 2, 9),
(90, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541799513, 2, 9),
(91, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541188984, 2, 10),
(92, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540742262, 2, 10),
(93, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541515158, 2, 10),
(94, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541151033, 2, 10),
(95, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540914795, 2, 10),
(96, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541507804, 2, 10),
(97, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540756147, 2, 10),
(98, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540673610, 2, 10),
(99, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540908280, 2, 10),
(100, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541748379, 2, 10),
(101, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541318490, 2, 11),
(102, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541304797, 2, 11),
(103, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541163847, 2, 11),
(104, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540903882, 2, 11),
(105, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540732719, 2, 11),
(106, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541424972, 2, 11),
(107, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540988217, 2, 11),
(108, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540906384, 2, 11),
(109, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540925687, 2, 11),
(110, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541652919, 2, 11),
(111, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540749276, 2, 12),
(112, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1542021963, 2, 12),
(113, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541430870, 2, 12),
(114, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541780688, 2, 12),
(115, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1542023126, 2, 12),
(116, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541106972, 2, 12),
(117, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541947004, 2, 12),
(118, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541765468, 2, 12),
(119, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541931129, 2, 12),
(120, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541839970, 2, 12),
(121, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541248648, 3, 13),
(122, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541328401, 3, 13),
(123, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541169235, 3, 13),
(124, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541514177, 3, 13),
(125, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541169243, 3, 13),
(126, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540783752, 3, 13),
(127, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541506600, 3, 13),
(128, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540724269, 3, 13),
(129, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1542007234, 3, 13),
(130, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541526877, 3, 13),
(131, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540819848, 3, 14),
(132, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541832294, 3, 14),
(133, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541922489, 3, 14),
(134, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541351460, 3, 14),
(135, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540753319, 3, 14),
(136, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541092779, 3, 14),
(137, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541522929, 3, 14),
(138, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541786913, 3, 14),
(139, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541170193, 3, 14),
(140, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541670640, 3, 14),
(141, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541691887, 3, 15),
(142, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540828463, 3, 15),
(143, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541964473, 3, 15),
(144, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541322560, 3, 15),
(145, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541181267, 3, 15),
(146, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541084804, 3, 15),
(147, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540833713, 3, 15),
(148, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541666149, 3, 15),
(149, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541614536, 3, 15),
(150, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1542055890, 3, 15),
(151, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541425265, 3, 16),
(152, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540710397, 3, 16),
(153, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541589771, 3, 16),
(154, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1542003353, 3, 16),
(155, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541961367, 3, 16),
(156, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541083295, 3, 16),
(157, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541948570, 3, 16),
(158, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541014330, 3, 16),
(159, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541526877, 3, 16),
(160, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541601855, 3, 16),
(161, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541743741, 3, 17),
(162, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540724704, 3, 17),
(163, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541961375, 3, 17),
(164, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540978744, 3, 17),
(165, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540724720, 3, 17),
(166, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540743670, 3, 17),
(167, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541927632, 3, 17),
(168, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541745701, 3, 17),
(169, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541087636, 3, 17),
(170, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540993923, 3, 17),
(171, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541854182, 3, 18),
(172, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541080226, 3, 18),
(173, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540763516, 3, 18),
(174, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541097384, 3, 18),
(175, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540725782, 3, 18),
(176, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541535681, 3, 18),
(177, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540727726, 3, 18),
(178, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540825744, 3, 18),
(179, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1542055892, 3, 18),
(180, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540726097, 3, 18),
(181, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540723896, 4, 19),
(182, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541753874, 4, 19),
(183, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540824491, 4, 19),
(184, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1541874548, 4, 19),
(185, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540804314, 4, 19),
(186, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541087314, 4, 19),
(187, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1541488554, 4, 19),
(188, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540826199, 4, 19),
(189, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541394574, 4, 19),
(190, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540971220, 4, 19),
(191, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540912970, 4, 20),
(192, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1540749410, 4, 20),
(193, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540752119, 4, 20),
(194, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540724937, 4, 20),
(195, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1541494451, 4, 20),
(196, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541238246, 4, 20),
(197, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540722370, 4, 20),
(198, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1541071953, 4, 20),
(199, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541522143, 4, 20),
(200, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541155769, 4, 20),
(201, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1541610315, 4, 21),
(202, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541189700, 4, 21),
(203, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1540641156, 4, 21),
(204, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540735138, 4, 21),
(205, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540897737, 4, 21),
(206, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1541331867, 4, 21),
(207, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540554938, 4, 21),
(208, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540728251, 4, 21),
(209, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540226949, 4, 21),
(210, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540816335, 4, 21),
(211, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540823430, 4, 22),
(212, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541610306, 4, 22),
(213, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541079569, 4, 22),
(214, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540303435, 4, 22),
(215, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540303444, 4, 22),
(216, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540489582, 4, 22),
(217, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1539441619, 4, 22),
(218, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1539884368, 4, 22),
(219, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1540738910, 4, 22),
(220, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1540554525, 4, 22),
(221, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1539066042, 4, 23),
(222, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1539074292, 4, 23),
(223, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1539884582, 4, 23),
(224, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1539265529, 4, 23),
(225, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540156209, 4, 23),
(226, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1540134591, 4, 23),
(227, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1540134562, 4, 23),
(228, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1539509535, 4, 23),
(229, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1539106041, 4, 23),
(230, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541581032, 4, 23),
(231, 'None', 155.553, -11.1256, 1002.11, 269.371, 0, 1540993532, 4, 24),
(232, 'None', 155.538, -6.2936, 1002.11, 269.371, 0, 1541241285, 4, 24),
(233, 'None', 155.544, -1.3367, 1002.11, 269.685, 0, 1541173720, 4, 24),
(234, 'None', 161.488, 1.5253, 1002.11, 181.324, 0, 1540572306, 4, 24),
(235, 'None', 167.869, 1.548, 1002.11, 181.637, 0, 1540399457, 4, 24),
(236, 'None', 174.092, 1.549, 1002.11, 180.697, 0, 1539866185, 4, 24),
(237, 'None', 180.522, 1.566, 1002.11, 181.951, 0, 1539793088, 4, 24),
(238, 'None', 180.661, -6.8395, 1002.11, 0.8424, 0, 1540131436, 4, 24),
(239, 'None', 174.251, -6.8125, 1002.11, 3.0356, 0, 1541000607, 4, 24),
(240, 'None', 167.876, -6.8075, 1002.11, 0.8422, 0, 1541709882, 4, 24);

-- --------------------------------------------------------

--
-- Структура таблицы `site_offuninvite`
--

CREATE TABLE `site_offuninvite` (
  `id` int(11) NOT NULL,
  `Leader` varchar(50) NOT NULL,
  `Player` varchar(50) NOT NULL,
  `Date` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `give_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `total` int(11) NOT NULL,
  `reason` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `transport`
--

CREATE TABLE `transport` (
  `id` int(3) NOT NULL,
  `model` int(3) NOT NULL,
  `name` varchar(35) NOT NULL,
  `price` int(8) NOT NULL,
  `tank` int(3) NOT NULL,
  `consumption` int(2) NOT NULL,
  `class` int(1) NOT NULL,
  `fuelable` tinyint(1) NOT NULL DEFAULT 1,
  `sellable` tinyint(1) NOT NULL DEFAULT 1,
  `prods` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin ROW_FORMAT=DYNAMIC;

--
-- Дамп данных таблицы `transport`
--

INSERT INTO `transport` (`id`, `model`, `name`, `price`, `tank`, `consumption`, `class`, `fuelable`, `sellable`, `prods`) VALUES
(1, 400, 'Landstalker', 200000, 80, 12, 1, 1, 1, 425),
(2, 401, 'Bravura', 67000, 40, 6, 0, 1, 1, 176),
(3, 402, 'Buffalo', 1250000, 50, 15, 2, 1, 1, 1025),
(4, 403, 'Linerunner', 250000, 140, 12, 9, 1, 0, 0),
(5, 404, 'Perenniel', 28750, 40, 6, 0, 1, 1, 75),
(6, 405, 'Sentinel', 190000, 50, 10, 1, 1, 1, 404),
(7, 406, 'Dumper', 0, 200, 12, 9, 1, 0, 0),
(8, 407, 'Firetruck', 0, 100, 11, 9, 1, 0, 0),
(9, 408, 'Trashmaster', 0, 80, 10, 9, 1, 0, 0),
(10, 409, 'Stretch', 400000, 60, 10, 9, 1, 0, 0),
(11, 410, 'Manana', 45000, 50, 8, 0, 1, 1, 118),
(12, 411, 'Infernus', 5000000, 60, 18, 2, 1, 1, 3450),
(13, 412, 'Voodoo', 132500, 60, 10, 0, 1, 1, 347),
(14, 413, 'Pony', 133125, 110, 12, 0, 1, 1, 350),
(15, 414, 'Mule', 0, 110, 12, 9, 1, 0, 0),
(16, 415, 'Cheetah', 1900000, 60, 16, 2, 1, 1, 1650),
(17, 416, 'Ambulance', 0, 80, 10, 9, 1, 0, 0),
(18, 417, 'Leviathan', 0, 0, 0, 9, 0, 0, 0),
(19, 418, 'Moonbeam', 140000, 70, 10, 9, 1, 0, 0),
(20, 419, 'Esperanto', 95750, 50, 12, 0, 1, 1, 251),
(21, 420, 'Taxi', 0, 60, 10, 9, 1, 0, 0),
(22, 421, 'Washington', 170000, 70, 11, 1, 1, 1, 361),
(23, 422, 'Bobcat', 65000, 80, 9, 0, 1, 1, 170),
(24, 423, 'Mr Whoopee', 0, 35, 5, 9, 1, 0, 0),
(25, 424, 'BF Injection', 800000, 40, 12, 9, 1, 0, 0),
(26, 425, 'Hunter', 0, 0, 0, 9, 0, 0, 0),
(27, 426, 'Premier', 200000, 60, 11, 1, 1, 1, 425),
(28, 427, 'Enforcer', 0, 120, 12, 9, 1, 0, 0),
(29, 428, 'Securicar', 0, 100, 11, 9, 1, 0, 0),
(30, 429, 'Banshee Banger', 1300000, 50, 15, 2, 1, 1, 1050),
(31, 430, 'Predator', 0, 0, 0, 9, 0, 0, 0),
(32, 431, 'Bus', 0, 100, 10, 9, 1, 0, 0),
(33, 432, 'Rhino', 0, 200, 25, 9, 1, 0, 0),
(34, 433, 'Barracks', 0, 150, 18, 9, 1, 0, 0),
(35, 434, 'Hotknife', 1025000, 30, 14, 2, 1, 1, 920),
(36, 435, 'Article Trailer', 0, 0, 0, 9, 0, 0, 0),
(37, 436, 'Previon', 100000, 35, 11, 9, 1, 0, 0),
(38, 437, 'Coach', 0, 100, 10, 9, 1, 0, 0),
(39, 438, 'Cabbie', 90000, 40, 9, 9, 1, 0, 0),
(40, 439, 'Stallion', 108750, 45, 10, 0, 1, 1, 285),
(41, 440, 'Rumpo', 0, 100, 9, 9, 1, 0, 0),
(42, 441, 'RC Bandit', 0, 0, 0, 9, 0, 0, 0),
(43, 442, 'Romero', 140000, 60, 12, 9, 1, 0, 0),
(44, 443, 'Packer', 0, 140, 13, 9, 1, 0, 0),
(45, 444, 'Monster', 2000000, 100, 20, 9, 1, 0, 0),
(46, 445, 'Admiral', 130000, 60, 11, 1, 1, 1, 276),
(47, 446, 'Squallo', 0, 0, 0, 9, 0, 0, 0),
(48, 447, 'Seasparrow', 0, 0, 0, 9, 0, 0, 0),
(49, 448, 'Pizzaboy', 0, 0, 0, 9, 0, 0, 0),
(50, 453, 'Reefer', 0, 0, 0, 9, 0, 0, 0),
(51, 449, 'Tram', 0, 0, 0, 9, 0, 0, 0),
(52, 450, 'Article Trailer 2', 0, 0, 0, 9, 0, 0, 0),
(53, 451, 'Turismo', 2200000, 50, 18, 2, 1, 1, 2010),
(54, 452, 'Speeder', 0, 0, 0, 9, 0, 0, 0),
(55, 454, 'Tropic', 0, 0, 0, 9, 0, 0, 0),
(56, 455, 'Flatbed', 0, 110, 11, 9, 1, 0, 0),
(57, 456, 'Yankee', 0, 110, 10, 9, 1, 0, 0),
(58, 457, 'Caddy', 30000, 20, 3, 0, 1, 1, 0),
(59, 458, 'Solair', 120000, 50, 12, 9, 1, 0, 0),
(60, 459, 'Topfun', 400000, 70, 10, 9, 1, 0, 0),
(61, 460, 'Skimmer', 0, 0, 0, 9, 0, 0, 0),
(62, 461, 'PCJ-600', 250000, 25, 14, 3, 1, 1, 406),
(63, 462, 'Faggio', 10000, 0, 0, 3, 0, 1, 160),
(64, 463, 'Freeway', 150000, 25, 10, 3, 1, 1, 250),
(65, 464, 'RC Baron', 0, 0, 0, 9, 0, 0, 0),
(66, 465, 'RC Raider', 0, 0, 0, 9, 0, 0, 0),
(67, 466, 'Glendale', 81400, 60, 11, 0, 1, 1, 213),
(68, 467, 'Oceanic', 62500, 60, 11, 0, 1, 1, 164),
(69, 468, 'Sanchez', 110000, 15, 7, 3, 1, 1, 200),
(70, 469, 'Sparrow', 0, 0, 0, 9, 0, 0, 0),
(71, 470, 'Patriot', 1200000, 80, 10, 9, 1, 0, 0),
(72, 471, 'Quad', 80000, 30, 10, 3, 1, 1, 260),
(73, 472, 'Coastguard', 0, 0, 0, 9, 0, 0, 0),
(74, 473, 'Dinghy', 0, 0, 0, 9, 0, 0, 0),
(75, 474, 'Hermes', 68750, 50, 10, 0, 1, 1, 180),
(76, 475, 'Sabre', 90000, 50, 13, 1, 1, 1, 191),
(77, 476, 'Rustler', 0, 0, 0, 9, 0, 0, 0),
(78, 477, 'ZR-350', 910000, 50, 14, 2, 1, 1, 820),
(79, 478, 'Walton', 500000, 35, 9, 9, 1, 0, 0),
(80, 479, 'Regina', 56250, 70, 10, 0, 1, 1, 143),
(81, 480, 'Comet', 780000, 40, 14, 2, 1, 1, 690),
(82, 481, 'BMX', 4000, 0, 0, 3, 0, 1, 50),
(83, 482, 'Burrito', 360000, 70, 11, 9, 1, 0, 0),
(84, 483, 'Camper', 160000, 50, 10, 9, 1, 0, 0),
(85, 484, 'Marquis', 0, 0, 0, 9, 0, 0, 0),
(86, 485, 'Baggage', 0, 0, 0, 9, 0, 0, 0),
(87, 486, 'Dozer', 0, 50, 19, 9, 1, 0, 0),
(88, 487, 'Maverick', 0, 0, 0, 9, 0, 0, 0),
(89, 488, 'San News Maverick', 0, 0, 0, 9, 0, 0, 0),
(90, 489, 'Rancher', 140000, 80, 12, 9, 1, 0, 0),
(91, 490, 'FBI Rancher', 1200000, 80, 12, 9, 1, 0, 0),
(92, 491, 'Virgo', 95400, 45, 9, 0, 1, 1, 250),
(93, 492, 'Greenwood', 93850, 50, 10, 0, 1, 1, 246),
(94, 493, 'Jetmax', 0, 0, 0, 9, 0, 0, 0),
(95, 494, 'Hotring Racer', 4500000, 50, 17, 9, 1, 0, 0),
(96, 495, 'Sandking', 4000000, 100, 10, 9, 1, 0, 0),
(97, 496, 'Blista Compact', 140000, 40, 11, 1, 1, 1, 496),
(98, 497, 'Police Maverick', 0, 0, 0, 9, 0, 0, 0),
(99, 498, 'Boxville', 0, 80, 9, 9, 1, 0, 0),
(100, 499, 'Benson', 0, 80, 9, 9, 1, 0, 0),
(101, 500, 'Mesa', 215000, 40, 10, 1, 1, 1, 457),
(102, 501, 'RC Goblin', 0, 0, 0, 9, 0, 0, 0),
(103, 502, 'Hotring Racer', 1000000, 50, 18, 9, 1, 0, 0),
(104, 503, 'Hotring Racer', 1000000, 50, 17, 9, 1, 0, 0),
(105, 504, 'Bloodring Banger', 1000000, 50, 12, 9, 1, 0, 0),
(106, 505, 'Rancher', 210000, 80, 12, 1, 1, 1, 446),
(107, 506, 'Super GT', 850000, 50, 16, 2, 1, 1, 700),
(108, 507, 'Elegant', 145000, 60, 10, 1, 1, 1, 308),
(109, 508, 'Camper', 350000, 45, 12, 9, 1, 0, 0),
(110, 509, 'Bike', 3000, 0, 0, 3, 0, 1, 50),
(111, 510, 'Mountain Bike', 6000, 0, 0, 3, 0, 1, 100),
(112, 511, 'Beagle', 0, 0, 0, 9, 0, 0, 0),
(113, 512, 'Cropduster', 0, 0, 0, 9, 0, 0, 0),
(114, 513, 'Stuntplane', 0, 0, 0, 9, 0, 0, 0),
(115, 514, 'Petrol Tanker', 400000, 120, 12, 9, 1, 0, 0),
(116, 515, 'Roadtrain', 600000, 140, 14, 9, 1, 0, 0),
(117, 516, 'Nebula', 120000, 50, 9, 9, 1, 0, 0),
(118, 517, 'Majestic', 121250, 50, 10, 0, 1, 1, 318),
(119, 518, 'Buccaneer', 53750, 50, 10, 0, 1, 1, 0),
(120, 519, 'Shamal', 0, 0, 0, 9, 0, 0, 0),
(121, 520, 'Hydra', 0, 0, 0, 9, 0, 0, 0),
(122, 521, 'FCR-900', 325000, 25, 14, 3, 1, 1, 525),
(123, 522, 'NRG-500', 2850000, 35, 18, 3, 1, 1, 2800),
(124, 523, 'Cop Bike HPV1000', 0, 25, 9, 9, 1, 0, 0),
(125, 524, 'Cement Truck', 0, 80, 10, 9, 1, 0, 0),
(126, 525, 'Towtruck', 0, 50, 9, 9, 1, 0, 0),
(127, 526, 'Fortune', 160000, 50, 10, 1, 1, 1, 340),
(128, 527, 'Cadrona', 140000, 40, 8, 1, 1, 1, 297),
(129, 528, 'FBI Truck', 1200000, 60, 12, 9, 1, 0, 0),
(130, 529, 'Willard', 100000, 60, 10, 9, 1, 0, 0),
(131, 530, 'Forklift', 0, 15, 3, 9, 1, 0, 0),
(132, 531, 'Tractor', 600000, 20, 4, 9, 1, 0, 0),
(133, 532, 'Combine Harvester', 0, 30, 7, 9, 1, 0, 0),
(134, 533, 'Feltzer', 235000, 40, 11, 1, 1, 1, 500),
(135, 534, 'Remington', 300000, 60, 12, 1, 1, 1, 637),
(136, 535, 'Slamvan', 90000, 60, 14, 1, 1, 1, 191),
(137, 536, 'Blade', 120000, 60, 12, 9, 1, 0, 0),
(138, 537, 'Freight (Train)', 0, 0, 0, 9, 0, 0, 0),
(139, 538, 'Brownstreak (Train)', 0, 0, 0, 9, 0, 0, 0),
(140, 539, 'Vortex', 2400000, 70, 2, 9, 1, 0, 0),
(141, 540, 'Vincent', 100000, 50, 10, 9, 1, 0, 0),
(142, 541, 'Bullet', 1800000, 50, 18, 2, 1, 1, 1600),
(143, 542, 'Clover', 33700, 50, 6, 0, 1, 1, 141),
(144, 543, 'Sadler', 25000, 50, 9, 0, 1, 1, 65),
(145, 544, 'Firetruck', 0, 90, 12, 9, 1, 0, 0),
(146, 545, 'Hustler', 91000, 35, 14, 0, 1, 1, 239),
(147, 546, 'Intruder', 100000, 50, 8, 9, 1, 0, 0),
(148, 547, 'Primo', 100000, 50, 8, 9, 1, 0, 0),
(149, 548, 'Cargobob', 0, 0, 0, 9, 0, 0, 0),
(150, 549, 'Tampa', 39000, 50, 11, 0, 1, 1, 102),
(151, 550, 'Sunrise', 100000, 50, 10, 9, 1, 0, 0),
(152, 551, 'Merit', 135000, 50, 10, 1, 1, 1, 287),
(153, 552, 'Utility Van', 0, 50, 9, 9, 1, 0, 0),
(154, 553, 'Nevada', 0, 0, 0, 9, 0, 0, 0),
(155, 554, 'Yosemite', 200000, 50, 10, 1, 1, 1, 425),
(156, 555, 'Windsor', 180000, 35, 15, 1, 1, 1, 382),
(157, 556, 'Monster \"A\"', 2000000, 100, 15, 9, 1, 0, 0),
(158, 557, 'Monster \"B\"', 2000000, 100, 15, 9, 1, 0, 0),
(159, 558, 'Uranus', 320000, 50, 11, 1, 1, 1, 680),
(160, 559, 'Jester', 850000, 50, 12, 2, 1, 1, 700),
(161, 560, 'Sultan', 1000000, 50, 12, 2, 1, 1, 800),
(162, 561, 'Stratum', 210000, 50, 10, 1, 1, 1, 446),
(163, 562, 'Elegy', 850000, 50, 13, 2, 1, 1, 700),
(164, 563, 'Raindance', 0, 0, 0, 9, 0, 0, 0),
(165, 564, 'RC Tiger', 0, 0, 0, 9, 0, 0, 0),
(166, 565, 'Flash', 100000, 50, 13, 9, 1, 0, 0),
(167, 566, 'Tahoma', 220000, 50, 9, 1, 1, 1, 467),
(168, 567, 'Savanna', 250000, 50, 10, 1, 1, 1, 531),
(169, 568, 'Bandito', 1600000, 15, 10, 9, 1, 0, 0),
(170, 569, 'Flat Trailer (Train)', 0, 0, 0, 9, 0, 0, 0),
(171, 570, 'Streak Trailer (Train)', 0, 0, 0, 9, 0, 0, 0),
(172, 571, 'Kart', 1400000, 10, 2, 9, 1, 0, 0),
(173, 572, 'Mower', 0, 10, 2, 9, 1, 0, 0),
(174, 573, 'Dune', 1800000, 35, 8, 9, 1, 0, 0),
(175, 574, 'Sweeper', 0, 10, 2, 9, 1, 0, 0),
(176, 575, 'Broadway', 80000, 50, 11, 0, 1, 1, 210),
(177, 576, 'Tornado', 119450, 50, 10, 0, 1, 1, 331),
(178, 577, 'AT400', 0, 0, 0, 9, 0, 0, 0),
(179, 578, 'DFT-30', 1800000, 70, 12, 9, 1, 0, 0),
(180, 579, 'Huntley', 342500, 70, 12, 1, 1, 1, 728),
(181, 580, 'Stafford', 287500, 50, 11, 1, 1, 1, 611),
(182, 581, 'BF-400', 600000, 25, 12, 9, 1, 0, 0),
(183, 582, 'Newsvan', 0, 80, 9, 9, 1, 0, 0),
(184, 583, 'Tug', 0, 10, 3, 9, 1, 0, 0),
(185, 584, 'Petrol Trailer', 0, 0, 0, 9, 0, 0, 0),
(186, 585, 'Emperor', 72500, 50, 10, 0, 1, 1, 190),
(187, 586, 'Wayfarer', 110000, 25, 12, 3, 1, 1, 200),
(188, 587, 'Euros', 470000, 50, 10, 2, 1, 1, 470),
(189, 588, 'Hotdog', 0, 30, 7, 9, 1, 0, 0),
(190, 589, 'Club', 370000, 50, 14, 1, 1, 1, 786),
(191, 590, 'Box Trailer (Train)', 0, 0, 0, 9, 0, 0, 0),
(192, 591, 'Article Trailer 3', 0, 0, 0, 9, 0, 0, 0),
(193, 592, 'Andromada', 0, 0, 0, 9, 0, 0, 0),
(194, 593, 'Dodo', 0, 0, 0, 9, 0, 0, 0),
(195, 594, 'RC Cam', 0, 0, 0, 9, 0, 0, 0),
(196, 595, 'Launch', 0, 0, 0, 9, 0, 0, 0),
(197, 596, 'Police Car (LSPD)', 0, 50, 10, 9, 1, 0, 0),
(198, 597, 'Police Car (SFPD)', 0, 50, 10, 9, 1, 0, 0),
(199, 598, 'Police Car (LVPD)', 0, 50, 8, 9, 1, 0, 0),
(200, 599, 'Ranger', 1200000, 80, 10, 9, 1, 0, 0),
(201, 600, 'Picador', 31250, 40, 9, 0, 1, 1, 82),
(202, 601, 'S.W.A.T.', 2400000, 30, 8, 9, 1, 0, 0),
(203, 602, 'Alpha', 350000, 50, 12, 2, 1, 1, 350),
(204, 603, 'Phoenix', 412500, 50, 14, 1, 1, 1, 876),
(205, 604, 'Glendale Shit', 0, 50, 10, 9, 1, 0, 0),
(206, 605, 'Sadler Shit', 0, 50, 10, 9, 1, 0, 0),
(207, 606, 'Baggage Trailer \"A\"', 0, 0, 0, 9, 0, 0, 0),
(208, 607, 'Baggage Trailer \"B\"', 0, 0, 0, 9, 0, 0, 0),
(209, 608, 'Tug Stairs Trailer', 0, 0, 0, 9, 0, 0, 0),
(210, 609, 'Boxburg', 0, 50, 10, 9, 1, 0, 0),
(211, 610, 'Farm Trailer', 0, 0, 0, 9, 0, 0, 0),
(212, 611, 'Utility Trailer', 0, 0, 0, 9, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `ucp_login`
--

CREATE TABLE `ucp_login` (
  `id` int(10) UNSIGNED NOT NULL,
  `Player` varchar(60) NOT NULL,
  `IP` varchar(60) NOT NULL,
  `Type` varchar(60) NOT NULL,
  `Date` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `vip`
--

CREATE TABLE `vip` (
  `id_vip` int(11) NOT NULL,
  `vip_payday` int(11) NOT NULL,
  `vip_afk` int(11) NOT NULL,
  `vip_carlic` int(11) NOT NULL,
  `vip_lvl` int(11) NOT NULL,
  `vip_healtime` int(11) NOT NULL,
  `vip_arrest` int(11) NOT NULL,
  `vip_mute` int(11) NOT NULL,
  `vip_admins` int(11) NOT NULL,
  `vip_mask_time` int(11) NOT NULL,
  `vip_armmats` int(11) NOT NULL,
  `vip_search` int(11) NOT NULL,
  `vip_heal` int(11) NOT NULL,
  `vip_mask` int(11) NOT NULL,
  `vip_fuel` int(11) NOT NULL,
  `vip_jimmy` int(11) NOT NULL,
  `vip_mats` int(11) NOT NULL,
  `vip_drugs` int(11) NOT NULL,
  `vip_satiety` float NOT NULL,
  `vip_fam_point` int(11) NOT NULL,
  `vip_transfer_bank` int(11) NOT NULL,
  `vip_percent_job` int(11) NOT NULL,
  `vip_percent_pension` int(11) NOT NULL,
  `vip_percent_startjob` int(11) NOT NULL,
  `vip_flylic` int(11) NOT NULL,
  `vip_fixcar` int(11) NOT NULL,
  `vip_fine` int(11) NOT NULL,
  `vip_hotel` int(11) NOT NULL,
  `vip_chose` int(11) NOT NULL,
  `vip_buycar` int(11) NOT NULL,
  `vip_rentcar` int(11) NOT NULL,
  `vip_houseupdate` int(11) NOT NULL,
  `vip_changesex` int(11) NOT NULL,
  `vip_number` int(11) NOT NULL,
  `vip_perfonans` int(11) NOT NULL,
  `vip_tune` int(11) NOT NULL,
  `vip_rulet` int(11) NOT NULL,
  `vip_hp` int(11) NOT NULL,
  `vip_useheal` int(11) NOT NULL,
  `vip_changename` int(11) NOT NULL,
  `vip_gunlic` int(11) NOT NULL,
  `vip_radar` int(11) NOT NULL,
  `vip_report` int(11) NOT NULL,
  `vip_ad` int(11) NOT NULL,
  `vip_enterbizz` int(11) NOT NULL,
  `vip_vad` int(11) NOT NULL,
  `vip_sms` int(11) NOT NULL,
  `vip_disease` int(11) NOT NULL,
  `vip_pay` int(11) NOT NULL,
  `vip_chat` int(11) NOT NULL,
  `vip_percent_bank` int(11) NOT NULL,
  `vip_percent_atm` int(11) NOT NULL,
  `vip_call` int(11) NOT NULL,
  `vip_report_color` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Дамп данных таблицы `vip`
--

INSERT INTO `vip` (`id_vip`, `vip_payday`, `vip_afk`, `vip_carlic`, `vip_lvl`, `vip_healtime`, `vip_arrest`, `vip_mute`, `vip_admins`, `vip_mask_time`, `vip_armmats`, `vip_search`, `vip_heal`, `vip_mask`, `vip_fuel`, `vip_jimmy`, `vip_mats`, `vip_drugs`, `vip_satiety`, `vip_fam_point`, `vip_transfer_bank`, `vip_percent_job`, `vip_percent_pension`, `vip_percent_startjob`, `vip_flylic`, `vip_fixcar`, `vip_fine`, `vip_hotel`, `vip_chose`, `vip_buycar`, `vip_rentcar`, `vip_houseupdate`, `vip_changesex`, `vip_number`, `vip_perfonans`, `vip_tune`, `vip_rulet`, `vip_hp`, `vip_useheal`, `vip_changename`, `vip_gunlic`, `vip_radar`, `vip_report`, `vip_ad`, `vip_enterbizz`, `vip_vad`, `vip_sms`, `vip_disease`, `vip_pay`, `vip_chat`, `vip_percent_bank`, `vip_percent_atm`, `vip_call`, `vip_report_color`) VALUES
(0, 4, 2400, 0, 0, 1, 1, 1, 0, 10, 1, 1, 5, 3, 1, 3, 500, 50, 1, 0, 5000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 160, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100000, 0, 0, 0, 0, 0),
(1, 2, 1800, 1, 5000, 2, 2, 2, 1, 15, 2, 2, 6, 6, 2, 4, 1000, 50, 0.8, 5, 5100000, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 160, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100000, 0, 0, 0, 0, 0),
(2, 3, 2100, 1, 10000, 3, 3, 3, 1, 17, 3, 2, 7, 7, 3, 5, 1500, 50, 0.6, 6, 5200000, 10, 10, 10, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 160, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100000, 0, 0, 0, 0, 0),
(3, 4, 2400, 1, 15000, 4, 4, 3, 1, 20, 3, 2, 8, 8, 4, 6, 2000, 50, 0.5, 7, 5300000, 15, 15, 15, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 160, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100000, 0, 0, 0, 0, 0),
(4, 5, 2700, 1, 20000, 5, 5, 5, 1, 25, 4, 3, 9, 9, 5, 7, 2500, 50, 0.4, 8, 5500000, 20, 20, 20, 1, 1, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 60, 170, 90, 10, 1, 1, 1, 1, 2, 1, 1, 2, 100000, 0, 0, 0, 0, 0),
(5, 5, 3000, 1, 25000, 100, 5, 5, 1, 30, 5, 3, 15, 15, 10, 15, 5000, 50, 0.3, 10, 8000000, 25, 25, 25, 1, 1, 0, 16, 16, 0, 16, 16, 20, 20, 20, 20, 50, 180, 100, 5, 1, 1, 1, 1, 100, 1, 1, 100, 150000, 1, 1, 1, 1, 0),
(6, 5, 3600, 1, 30000, 100, 5, 5, 1, 40, 5, 3, 20, 20, 20, 20, 10000, 50, 0.2, 15, 10000000, 30, 30, 30, 1, 1, 100, 18, 18, 18, 18, 18, 25, 25, 25, 25, 40, 200, 120, 3, 1, 1, 1, 1, 100, 1, 1, 100, 200000, 1, 1, 1, 1, 1),
(7, 5, 3600, 1, 30000, 100, 5, 5, 1, 50, 6, 3, 25, 25, 5, 15, 4000, 500, 1, 5, 5000000, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 200, 80, 0, 0, 0, 1, 0, 0, 0, 0, 0, 100000, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `vote`
--

CREATE TABLE `vote` (
  `vote_name` varchar(24) NOT NULL,
  `vote_count` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `warnlog`
--

CREATE TABLE `warnlog` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(25) NOT NULL,
  `warn` int(11) NOT NULL,
  `admin` varchar(25) NOT NULL,
  `reason` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `time` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `warns`
--

CREATE TABLE `warns` (
  `id` int(11) NOT NULL,
  `name` varchar(25) NOT NULL,
  `warn` int(1) NOT NULL,
  `time` datetime NOT NULL,
  `admin` varchar(25) NOT NULL,
  `reason` varchar(34) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`pID`);

--
-- Индексы таблицы `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `adminlog`
--
ALTER TABLE `adminlog`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `adradio`
--
ALTER TABLE `adradio`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `airports`
--
ALTER TABLE `airports`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `atms`
--
ALTER TABLE `atms`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `ban`
--
ALTER TABLE `ban`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `banip`
--
ALTER TABLE `banip`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `bank`
--
ALTER TABLE `bank`
  ADD PRIMARY KEY (`number`);

--
-- Индексы таблицы `billboards`
--
ALTER TABLE `billboards`
  ADD PRIMARY KEY (`newid`);

--
-- Индексы таблицы `bints`
--
ALTER TABLE `bints`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `blackmarket`
--
ALTER TABLE `blackmarket`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `bonuses`
--
ALTER TABLE `bonuses`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `business`
--
ALTER TABLE `business`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `business_func`
--
ALTER TABLE `business_func`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `business_stats`
--
ALTER TABLE `business_stats`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `captchalog`
--
ALTER TABLE `captchalog`
  ADD PRIMARY KEY (`clID`);

--
-- Индексы таблицы `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `diplomation`
--
ALTER TABLE `diplomation`
  ADD PRIMARY KEY (`f_id`);

--
-- Индексы таблицы `economy`
--
ALTER TABLE `economy`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `email_success`
--
ALTER TABLE `email_success`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `family`
--
ALTER TABLE `family`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `fraclog`
--
ALTER TABLE `fraclog`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `fractions`
--
ALTER TABLE `fractions`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `frac_weapon`
--
ALTER TABLE `frac_weapon`
  ADD PRIMARY KEY (`fwID`);

--
-- Индексы таблицы `gangzone`
--
ALTER TABLE `gangzone`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `givecash`
--
ALTER TABLE `givecash`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `graffity`
--
ALTER TABLE `graffity`
  ADD PRIMARY KEY (`gID`);

--
-- Индексы таблицы `greenzone`
--
ALTER TABLE `greenzone`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `history`
--
ALTER TABLE `history`
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
-- Индексы таблицы `jobinfo`
--
ALTER TABLE `jobinfo`
  ADD PRIMARY KEY (`ji_id`);

--
-- Индексы таблицы `keys_log`
--
ALTER TABLE `keys_log`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `keys_sklad`
--
ALTER TABLE `keys_sklad`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `labrary`
--
ALTER TABLE `labrary`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `lottery_session`
--
ALTER TABLE `lottery_session`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `lottery_sessionall`
--
ALTER TABLE `lottery_sessionall`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `nickname_history`
--
ALTER TABLE `nickname_history`
  ADD PRIMARY KEY (`nh_id`),
  ADD UNIQUE KEY `nh_id_3` (`nh_id`),
  ADD KEY `nh_id` (`nh_id`),
  ADD KEY `nh_id_2` (`nh_id`),
  ADD KEY `nh_owner` (`nh_owner`);

--
-- Индексы таблицы `online_player`
--
ALTER TABLE `online_player`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `others`
--
ALTER TABLE `others`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `plane`
--
ALTER TABLE `plane`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `promocode_used`
--
ALTER TABLE `promocode_used`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Индексы таблицы `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `rjlist`
--
ALTER TABLE `rjlist`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `site_offuninvite`
--
ALTER TABLE `site_offuninvite`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `transport`
--
ALTER TABLE `transport`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ucp_login`
--
ALTER TABLE `ucp_login`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `vip`
--
ALTER TABLE `vip`
  ADD PRIMARY KEY (`id_vip`);

--
-- Индексы таблицы `warnlog`
--
ALTER TABLE `warnlog`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `warns`
--
ALTER TABLE `warns`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `accounts`
--
ALTER TABLE `accounts`
  MODIFY `pID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=238;

--
-- AUTO_INCREMENT для таблицы `adminlog`
--
ALTER TABLE `adminlog`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `adradio`
--
ALTER TABLE `adradio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `airports`
--
ALTER TABLE `airports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `atms`
--
ALTER TABLE `atms`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT для таблицы `ban`
--
ALTER TABLE `ban`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `banip`
--
ALTER TABLE `banip`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `bank`
--
ALTER TABLE `bank`
  MODIFY `number` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `billboards`
--
ALTER TABLE `billboards`
  MODIFY `newid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT для таблицы `bints`
--
ALTER TABLE `bints`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT для таблицы `blackmarket`
--
ALTER TABLE `blackmarket`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `bonuses`
--
ALTER TABLE `bonuses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `business`
--
ALTER TABLE `business`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT для таблицы `business_func`
--
ALTER TABLE `business_func`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `business_stats`
--
ALTER TABLE `business_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT для таблицы `captchalog`
--
ALTER TABLE `captchalog`
  MODIFY `clID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `cars`
--
ALTER TABLE `cars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT для таблицы `diplomation`
--
ALTER TABLE `diplomation`
  MODIFY `f_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT для таблицы `economy`
--
ALTER TABLE `economy`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `email_success`
--
ALTER TABLE `email_success`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `family`
--
ALTER TABLE `family`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `fraclog`
--
ALTER TABLE `fraclog`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `fractions`
--
ALTER TABLE `fractions`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT для таблицы `frac_weapon`
--
ALTER TABLE `frac_weapon`
  MODIFY `fwID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT для таблицы `gangzone`
--
ALTER TABLE `gangzone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT для таблицы `givecash`
--
ALTER TABLE `givecash`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT для таблицы `graffity`
--
ALTER TABLE `graffity`
  MODIFY `gID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT для таблицы `greenzone`
--
ALTER TABLE `greenzone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT для таблицы `history`
--
ALTER TABLE `history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `hotels`
--
ALTER TABLE `hotels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=911;

--
-- AUTO_INCREMENT для таблицы `jobinfo`
--
ALTER TABLE `jobinfo`
  MODIFY `ji_id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT для таблицы `keys_log`
--
ALTER TABLE `keys_log`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `keys_sklad`
--
ALTER TABLE `keys_sklad`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `lottery_session`
--
ALTER TABLE `lottery_session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `lottery_sessionall`
--
ALTER TABLE `lottery_sessionall`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `nickname_history`
--
ALTER TABLE `nickname_history`
  MODIFY `nh_id` int(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `online_player`
--
ALTER TABLE `online_player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `others`
--
ALTER TABLE `others`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `plane`
--
ALTER TABLE `plane`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT для таблицы `promocode_used`
--
ALTER TABLE `promocode_used`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `rjlist`
--
ALTER TABLE `rjlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241;

--
-- AUTO_INCREMENT для таблицы `site_offuninvite`
--
ALTER TABLE `site_offuninvite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `transport`
--
ALTER TABLE `transport`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=213;

--
-- AUTO_INCREMENT для таблицы `ucp_login`
--
ALTER TABLE `ucp_login`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `vip`
--
ALTER TABLE `vip`
  MODIFY `id_vip` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `warnlog`
--
ALTER TABLE `warnlog`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `warns`
--
ALTER TABLE `warns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
