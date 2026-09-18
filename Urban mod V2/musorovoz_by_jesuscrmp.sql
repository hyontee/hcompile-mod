-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Май 21 2026 г., 16:46
-- Версия сервера: 10.11.6-MariaDB-0+deb12u1
-- Версия PHP: 8.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gs326144`
--

-- --------------------------------------------------------

--
-- Структура таблицы `garbage_job`
--

CREATE TABLE `garbage_job` (
  `name` varchar(24) NOT NULL,
  `exp` int(11) DEFAULT 0,
  `rank` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `garbage_job`
--

INSERT INTO `garbage_job` (`name`, `exp`, `rank`) VALUES
('Bratishka_Azer', 0, 1),
('Fillip_Liga', 0, 1),
('Jesus_Fdr', 11050, 3),
('Kapibar_Kapibarov', 0, 1),
('Krik_Hell', 0, 1),
('Papa_Cartel', 30, 1);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `garbage_job`
--
ALTER TABLE `garbage_job`
  ADD PRIMARY KEY (`name`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
