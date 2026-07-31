-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Фев 20 2025 г., 10:12
-- Версия сервера: 10.5.23-MariaDB-0+deb11u1
-- Версия PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gs75375`
--

-- --------------------------------------------------------

--
-- Структура таблицы `dragy`
--

CREATE TABLE `dragy` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT -1,
  `veh_id` int(11) NOT NULL,
  `veh_srv` int(11) NOT NULL DEFAULT -1,
  `s100` float NOT NULL DEFAULT 0,
  `s200` float NOT NULL DEFAULT 0,
  `s300` float NOT NULL DEFAULT 0,
  `s400` float NOT NULL DEFAULT 0,
  `s100_200` float NOT NULL DEFAULT 0,
  `s200_300` float NOT NULL DEFAULT 0,
  `s300_400` float NOT NULL DEFAULT 0,
  `date` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `dragy`
--

INSERT INTO `dragy` (`id`, `owner`, `veh_id`, `veh_srv`, `s100`, `s200`, `s300`, `s400`, `s100_200`, `s200_300`, `s300_400`, `date`) VALUES
(10, 3, 415, -1, 8.51, 12.51, 0, 0, 4, 0, 0, 1739720466),
(11, 3, 466, -1, 5.77, 16.9, 0, 0, 11.13, 0, 0, 1739721368),
(12, 3, 466, -1, 9.19, 24.46, 0, 0, 15.27, 0, 0, 1739721403),
(13, 3, 466, -1, 0, 5.91, 0, 0, 5.91, 0, 0, 1739721461),
(14, 3, 466, -1, 6.41, 20.68, 0, 0, 14.27, 0, 0, 1739721484),
(15, 3, 466, -1, 11.12, 25.33, 0, 0, 14.21, 0, 0, 1739721513),
(16, 3, 558, -1, 2.87, 0, 0, 0, 0, 0, 0, 1739722235),
(17, 3, 466, -1, 2.69, 11.68, 0, 0, 8.99, 0, 0, 1739722452),
(18, 3, 411, -1, 4.47, 0, 0, 0, 0, 0, 0, 1739723830),
(19, 3, 411, -1, 3.31, 9.28, 0, 0, 5.97, 0, 0, 1739723863);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `dragy`
--
ALTER TABLE `dragy`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `dragy`
--
ALTER TABLE `dragy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
