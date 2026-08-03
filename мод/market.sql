-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Июл 27 2026 г., 17:05
-- Версия сервера: 10.5.29-MariaDB-0+deb11u1
-- Версия PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gs330563`
--

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
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 active, 1 sold, 2 cancelled',
  `buyer_id` int(11) NOT NULL DEFAULT 0,
  `buyer_name` varchar(24) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL DEFAULT 0,
  `expires_at` int(11) NOT NULL DEFAULT 0,
  `sold_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Дамп данных таблицы `marketplace_items`
--

INSERT INTO `marketplace_items` (`id`, `seller_id`, `seller_name`, `item_id`, `item_count`, `item_name`, `price`, `is_hot`, `status`, `buyer_id`, `buyer_name`, `created_at`, `expires_at`, `sold_at`) VALUES
(1, 48, 'shramip_dev', 220, 1, '?????-????', 100, 0, 0, 0, '', 1780429565, 0, 0),
(2, 48, 'shramip_dev', 501, 1, '???? ? ????????', 1000, 0, 0, 0, '', 1780429623, 0, 0),
(3, 48, 'shramip_dev', 134, 122, '???? #122', 1000, 0, 0, 0, '', 1780429638, 0, 0),
(4, 48, 'shramip_dev', 350, 2, '????? ??????', 1111, 0, 0, 0, '', 1780485776, 0, 0),
(5, 48, 'shramip_dev', 475, 1, '??????????? ?????', 1111, 0, 0, 0, '', 1780485789, 0, 0),
(6, 48, 'shramip_dev', 944, 1, '????? SpeedPack', 1111, 0, 0, 0, '', 1780502453, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_likes`
--

CREATE TABLE `marketplace_likes` (
  `player_id` int(11) NOT NULL,
  `listing_id` int(11) NOT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `items_data`
--
ALTER TABLE `items_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `item_id` (`item_id`);

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
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `items_data`
--
ALTER TABLE `items_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `marketplace_items`
--
ALTER TABLE `marketplace_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
