-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Мар 04 2026 г., 23:28
-- Версия сервера: 10.3.31-MariaDB-0+deb10u1
-- Версия PHP: 7.3.31-1~deb10u7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gs277232`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `usepassword` int(11) NOT NULL DEFAULT 0,
  `online` int(11) NOT NULL DEFAULT 0,
  `money` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bank` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bank_deposit` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bank_deposit_limit` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bank_deposit_limit_put` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bank_deposit_limit_take` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bank_pension` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bank_pension_status` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bitcoin` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `donate` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `flinmoney` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `donate_all` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `donate_all_new` int(11) NOT NULL DEFAULT 0,
  `source_reg` int(11) NOT NULL DEFAULT 0,
  `mail` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_confirmed` int(11) NOT NULL DEFAULT 0,
  `vk_userid` int(11) NOT NULL DEFAULT 0,
  `vk_type` int(11) NOT NULL DEFAULT 0,
  `vk_code` int(11) NOT NULL DEFAULT 0,
  `vk_session` int(11) NOT NULL DEFAULT 0,
  `vk_confirmed` int(11) NOT NULL DEFAULT 0,
  `vk_auth` int(11) NOT NULL DEFAULT 0,
  `tg_userid` int(11) NOT NULL DEFAULT 0,
  `tg_confirmed` int(11) NOT NULL DEFAULT 0,
  `tg_auth` int(11) NOT NULL DEFAULT 0,
  `datareg` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `regip` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastip` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `skin` int(11) NOT NULL DEFAULT 79,
  `passport` int(11) NOT NULL DEFAULT 0,
  `passport_time` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `sex` int(11) NOT NULL DEFAULT 1,
  `exp` int(11) NOT NULL DEFAULT 0,
  `admin` int(11) NOT NULL DEFAULT 0,
  `youtube_adm` int(11) NOT NULL DEFAULT 0,
  `admin_pass` int(11) NOT NULL DEFAULT 0,
  `google_code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `med_card` int(11) NOT NULL DEFAULT 0,
  `leader` int(11) NOT NULL DEFAULT 0,
  `member` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `rang` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `fskin` int(11) NOT NULL DEFAULT 0,
  `spawn` int(11) NOT NULL DEFAULT 0,
  `job` int(11) NOT NULL DEFAULT 0,
  `active_phone_id` int(11) NOT NULL DEFAULT 0,
  `phone_number` int(11) NOT NULL DEFAULT 0,
  `phone_balance` int(11) NOT NULL DEFAULT 0,
  `ban` int(11) NOT NULL DEFAULT 0,
  `mute` int(11) NOT NULL DEFAULT 0,
  `warn` int(11) NOT NULL DEFAULT 0,
  `wanted` int(11) NOT NULL DEFAULT 0,
  `jail_time` int(11) NOT NULL DEFAULT 0,
  `jail` int(11) NOT NULL DEFAULT 0,
  `helper` int(11) NOT NULL DEFAULT 0,
  `pin_code` int(11) NOT NULL DEFAULT 0,
  `free_change_nick` int(11) NOT NULL DEFAULT 0,
  `d_demolition` int(11) NOT NULL DEFAULT 0,
  `d_addiction` int(11) NOT NULL DEFAULT 0,
  `Lic` varchar(144) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0',
  `Lic_Warn` varchar(144) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0',
  `Lic_Time` varchar(144) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0',
  `paintball` int(11) NOT NULL DEFAULT 0,
  `Weapon` varchar(144) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0',
  `Ammo` varchar(144) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0',
  `fwork` tinyint(1) NOT NULL DEFAULT 0,
  `h_r_settings` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0',
  `rmute` int(11) NOT NULL DEFAULT 0,
  `p_game_time` int(11) NOT NULL DEFAULT 0,
  `p_limite_bank_count` int(11) NOT NULL DEFAULT 0,
  `satiety` float NOT NULL DEFAULT 100,
  `thirst` float NOT NULL DEFAULT 100,
  `need` float NOT NULL DEFAULT 100,
  `style_styde` int(11) NOT NULL DEFAULT 0,
  `walk_style` int(11) NOT NULL DEFAULT 0,
  `walk_status` int(11) NOT NULL DEFAULT 0,
  `style_progress` int(11) NOT NULL DEFAULT 0,
  `style_chat` int(11) NOT NULL DEFAULT 0,
  `Style` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0',
  `stylestyde` int(11) NOT NULL DEFAULT 0,
  `styleprogress` int(11) NOT NULL DEFAULT 0,
  `styles` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0',
  `current_quest` int(11) NOT NULL DEFAULT -1,
  `p_flin_music_free` int(11) NOT NULL DEFAULT 0,
  `p_flin_music` int(11) NOT NULL DEFAULT 0,
  `p_flin_music_time` int(11) NOT NULL DEFAULT 0,
  `p_vip` int(11) NOT NULL DEFAULT 0,
  `p_vip_time` int(11) NOT NULL DEFAULT 0,
  `p_add_vip` int(11) NOT NULL DEFAULT 0,
  `p_add_vip_time` int(11) NOT NULL DEFAULT 0,
  `lastenter` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `family_id` int(11) NOT NULL DEFAULT -1,
  `family_rang` int(11) NOT NULL DEFAULT 0,
  `family_mute` int(11) NOT NULL DEFAULT 0,
  `family_warn` int(11) NOT NULL DEFAULT 0,
  `family_exp` int(11) NOT NULL DEFAULT 0,
  `family_enter` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checkdrug` int(11) NOT NULL DEFAULT 0,
  `p_time_payday` int(11) NOT NULL DEFAULT 0,
  `p_time_today` int(11) NOT NULL DEFAULT 0,
  `p_time_yesterday` int(11) NOT NULL DEFAULT 0,
  `p_afk_today` int(11) NOT NULL DEFAULT 0,
  `p_afk_yesterday` int(11) NOT NULL DEFAULT 0,
  `bonus_time` int(11) NOT NULL DEFAULT 0,
  `bonus_today` int(11) NOT NULL DEFAULT 0,
  `bonus_days` int(11) NOT NULL DEFAULT 0,
  `rob_time` int(11) NOT NULL DEFAULT 0,
  `news` int(11) NOT NULL DEFAULT 0,
  `fwarn` int(11) NOT NULL DEFAULT 0,
  `warn_time` int(11) NOT NULL DEFAULT 0,
  `time_exit_game` int(11) NOT NULL DEFAULT 0,
  `spawn_x` float NOT NULL DEFAULT 0,
  `spawn_y` float NOT NULL DEFAULT 0,
  `spawn_z` float NOT NULL DEFAULT 0,
  `spawn_r` float NOT NULL DEFAULT 0,
  `p_settings` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0',
  `skin_default` int(4) NOT NULL DEFAULT 0,
  `Update` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0',
  `DonateUpdate` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0',
  `CaptKill` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `pick` int(11) NOT NULL DEFAULT 1,
  `fracdata` varchar(256) CHARACTER SET utf8 NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `TaxiTime` int(11) NOT NULL DEFAULT 0,
  `referral` int(11) NOT NULL DEFAULT 0,
  `referralmoney` int(11) NOT NULL DEFAULT 0,
  `referralcount` int(11) NOT NULL DEFAULT 0,
  `job_skill_new` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1',
  `job_skill_count_new` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `job_skill_salary_new` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `costume` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `costume_use` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `disease` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0',
  `partner` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'None',
  `service` int(11) NOT NULL DEFAULT 0,
  `veh_slots` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1|1|2|1|1|0',
  `skin_slots` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '3',
  `bizz_slots` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `active_bizz_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `inv_slots` int(11) NOT NULL DEFAULT 60,
  `skins` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0',
  `active_skin_id` int(11) NOT NULL DEFAULT 0,
  `gift_promocode_status` int(11) NOT NULL DEFAULT 0,
  `gift_promocode_time` int(11) NOT NULL DEFAULT 0,
  `house_slots` int(11) NOT NULL DEFAULT 1,
  `active_house_id` int(11) NOT NULL DEFAULT 0,
  `spawn_house_id` int(11) NOT NULL DEFAULT 0,
  `med_insurance` int(11) NOT NULL DEFAULT 0,
  `med_insurance_time` int(11) NOT NULL DEFAULT 0,
  `billet_army` int(11) NOT NULL DEFAULT 0,
  `billet_cop` int(11) NOT NULL DEFAULT 0,
  `billet_exp` int(11) NOT NULL DEFAULT 0,
  `escape_limit` int(11) NOT NULL DEFAULT 0,
  `commit_a_robbery` int(11) NOT NULL DEFAULT 0,
  `robbed` int(11) NOT NULL DEFAULT 0,
  `lastenter_new` date NOT NULL,
  `free_roulette_time` int(11) NOT NULL DEFAULT 0,
  `free_roulette_status` int(11) NOT NULL DEFAULT 0,
  `fixcar_time` int(11) NOT NULL DEFAULT 0,
  `roulette_items_bronze` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_count_bronze` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_idx_bronze` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_silver` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_count_silver` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_idx_silver` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_gold` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_count_gold` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `roulette_items_idx_gold` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `ftop_unarrest` int(11) NOT NULL DEFAULT 0,
  `ftop_givepass` int(11) NOT NULL DEFAULT 0,
  `ftop_selllawyerlic` int(11) NOT NULL DEFAULT 0,
  `ftop_arrest` int(11) NOT NULL DEFAULT 0,
  `ftop_unkpz` int(11) NOT NULL DEFAULT 0,
  `ftop_su` int(11) NOT NULL DEFAULT 0,
  `ftop_unsu` int(11) NOT NULL DEFAULT 0,
  `ftop_ticket` int(11) NOT NULL DEFAULT 0,
  `ftop_frisk` int(11) NOT NULL DEFAULT 0,
  `ftop_take` int(11) NOT NULL DEFAULT 0,
  `ftop_sellgunlic` int(11) NOT NULL DEFAULT 0,
  `ftop_pkills` int(11) NOT NULL DEFAULT 0,
  `ftop_aload_materials` int(11) NOT NULL DEFAULT 0,
  `ftop_aunload_materials` int(11) NOT NULL DEFAULT 0,
  `ftop_akills` int(11) NOT NULL DEFAULT 0,
  `ftop_heal` int(11) NOT NULL DEFAULT 0,
  `ftop_heal_drugs` int(11) NOT NULL DEFAULT 0,
  `ftop_sex` int(11) NOT NULL DEFAULT 0,
  `ftop_medcard` int(11) NOT NULL DEFAULT 0,
  `ftop_hload_medicines` int(11) NOT NULL DEFAULT 0,
  `ftop_hunload_medicines` int(11) NOT NULL DEFAULT 0,
  `ftop_edit` int(11) NOT NULL DEFAULT 0,
  `ftop_rob_shop` int(11) NOT NULL DEFAULT 0,
  `ftop_gload_drugs` int(11) NOT NULL DEFAULT 0,
  `ftop_gunload_drugs` int(11) NOT NULL DEFAULT 0,
  `ftop_gload_materials` int(11) NOT NULL DEFAULT 0,
  `ftop_gunload_materials` int(11) NOT NULL DEFAULT 0,
  `ftop_gkills` int(11) NOT NULL DEFAULT 0,
  `ftop_gdeaths` int(11) NOT NULL DEFAULT 0,
  `ftop_rob_bank` int(11) NOT NULL DEFAULT 0,
  `ftop_mload_drugs` int(11) NOT NULL DEFAULT 0,
  `ftop_munload_drugs` int(11) NOT NULL DEFAULT 0,
  `ftop_mload_materials` int(11) NOT NULL DEFAULT 0,
  `ftop_munload_materials` int(11) NOT NULL DEFAULT 0,
  `ftop_mbkills` int(11) NOT NULL DEFAULT 0,
  `ftop_mbdeaths` int(11) NOT NULL DEFAULT 0,
  `ftop_selllic` int(11) NOT NULL DEFAULT 0,
  `ftop_sellinsurance` int(11) NOT NULL DEFAULT 0,
  `ftop_bload_drugs` int(11) NOT NULL DEFAULT 0,
  `ftop_bunload_drugs` int(11) NOT NULL DEFAULT 0,
  `ftop_bload_materials` int(11) NOT NULL DEFAULT 0,
  `ftop_bunload_materials` int(11) NOT NULL DEFAULT 0,
  `quest` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mission` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mission_exp` int(11) NOT NULL DEFAULT 0,
  `mission_days` int(11) NOT NULL DEFAULT 0,
  `achievement` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `achievement_progress` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `check_active_time` int(11) NOT NULL DEFAULT 0,
  `pame_text` char(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pame_time` int(11) NOT NULL DEFAULT 0,
  `lotto` int(11) NOT NULL DEFAULT 0,
  `casino_block` int(11) NOT NULL DEFAULT 0,
  `job_block` int(11) NOT NULL DEFAULT 0,
  `block_theft_car_acc` int(11) NOT NULL DEFAULT 0,
  `promocode_use` int(11) NOT NULL DEFAULT 0,
  `promocode_create` int(11) NOT NULL DEFAULT 0,
  `promocode_time` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '01.01.1980 00:00:00',
  `promocode_donate` int(11) NOT NULL DEFAULT 0,
  `promocode_prize` int(11) NOT NULL DEFAULT 0,
  `newyear_quest` int(11) NOT NULL DEFAULT 0,
  `newyear_quest_stage` int(11) NOT NULL DEFAULT 0,
  `gift_check` int(11) NOT NULL DEFAULT 0,
  `gift_idx` int(11) NOT NULL DEFAULT 0,
  `gift` int(11) NOT NULL DEFAULT 0,
  `donate_show` int(11) NOT NULL DEFAULT 0,
  `taxi` int(11) NOT NULL DEFAULT 0,
  `taxi_idx` int(11) NOT NULL DEFAULT 0,
  `taxi_rank` int(11) NOT NULL DEFAULT 0,
  `taxi_percent` int(11) NOT NULL DEFAULT 0,
  `taxi_salary` int(11) NOT NULL DEFAULT 0,
  `taxi_salary_all` int(11) NOT NULL DEFAULT 0,
  `tc` int(11) NOT NULL DEFAULT 0,
  `tc_idx` int(11) NOT NULL DEFAULT 0,
  `tc_rank` int(11) NOT NULL DEFAULT 0,
  `tc_percent` int(11) NOT NULL DEFAULT 0,
  `tc_salary` int(11) NOT NULL DEFAULT 0,
  `tc_salary_all` int(11) NOT NULL DEFAULT 0,
  `freelance_lvl` int(11) NOT NULL DEFAULT 1,
  `freelance_success` int(11) NOT NULL DEFAULT 0,
  `freelance_money` int(11) NOT NULL DEFAULT 0,
  `freelance_fm` int(11) NOT NULL DEFAULT 0,
  `battle_lvl` int(11) NOT NULL DEFAULT 1,
  `battle_lvl_task` int(11) NOT NULL DEFAULT 1,
  `battle_info` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0',
  `battle_task` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `battle_task_active` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0',
  `daily_days` int(11) NOT NULL DEFAULT 0,
  `daily_time` int(11) NOT NULL DEFAULT 0,
  `daily_today` int(11) NOT NULL DEFAULT 0,
  `daily_update_reward` int(11) NOT NULL DEFAULT 1,
  `payday_oil_count` int(11) NOT NULL DEFAULT 0,
  `halloween_id` int(11) NOT NULL DEFAULT 0,
  `halloween_progress` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `usepassword`, `online`, `money`, `bank`, `bank_deposit`, `bank_deposit_limit`, `bank_deposit_limit_put`, `bank_deposit_limit_take`, `bank_pension`, `bank_pension_status`, `bitcoin`, `donate`, `flinmoney`, `donate_all`, `donate_all_new`, `source_reg`, `mail`, `email_confirmed`, `vk_userid`, `vk_type`, `vk_code`, `vk_session`, `vk_confirmed`, `vk_auth`, `tg_userid`, `tg_confirmed`, `tg_auth`, `datareg`, `regip`, `lastip`, `skin`, `passport`, `passport_time`, `level`, `sex`, `exp`, `admin`, `youtube_adm`, `admin_pass`, `google_code`, `med_card`, `leader`, `member`, `rang`, `fskin`, `spawn`, `job`, `active_phone_id`, `phone_number`, `phone_balance`, `ban`, `mute`, `warn`, `wanted`, `jail_time`, `jail`, `helper`, `pin_code`, `free_change_nick`, `d_demolition`, `d_addiction`, `Lic`, `Lic_Warn`, `Lic_Time`, `paintball`, `Weapon`, `Ammo`, `fwork`, `h_r_settings`, `rmute`, `p_game_time`, `p_limite_bank_count`, `satiety`, `thirst`, `need`, `style_styde`, `walk_style`, `walk_status`, `style_progress`, `style_chat`, `Style`, `stylestyde`, `styleprogress`, `styles`, `current_quest`, `p_flin_music_free`, `p_flin_music`, `p_flin_music_time`, `p_vip`, `p_vip_time`, `p_add_vip`, `p_add_vip_time`, `lastenter`, `family_id`, `family_rang`, `family_mute`, `family_warn`, `family_exp`, `family_enter`, `checkdrug`, `p_time_payday`, `p_time_today`, `p_time_yesterday`, `p_afk_today`, `p_afk_yesterday`, `bonus_time`, `bonus_today`, `bonus_days`, `rob_time`, `news`, `fwarn`, `warn_time`, `time_exit_game`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_r`, `p_settings`, `skin_default`, `Update`, `DonateUpdate`, `CaptKill`, `pick`, `fracdata`, `TaxiTime`, `referral`, `referralmoney`, `referralcount`, `job_skill_new`, `job_skill_count_new`, `job_skill_salary_new`, `costume`, `costume_use`, `disease`, `partner`, `service`, `veh_slots`, `skin_slots`, `bizz_slots`, `active_bizz_id`, `inv_slots`, `skins`, `active_skin_id`, `gift_promocode_status`, `gift_promocode_time`, `house_slots`, `active_house_id`, `spawn_house_id`, `med_insurance`, `med_insurance_time`, `billet_army`, `billet_cop`, `billet_exp`, `escape_limit`, `commit_a_robbery`, `robbed`, `lastenter_new`, `free_roulette_time`, `free_roulette_status`, `fixcar_time`, `roulette_items_bronze`, `roulette_items_count_bronze`, `roulette_items_idx_bronze`, `roulette_items_silver`, `roulette_items_count_silver`, `roulette_items_idx_silver`, `roulette_items_gold`, `roulette_items_count_gold`, `roulette_items_idx_gold`, `ftop_unarrest`, `ftop_givepass`, `ftop_selllawyerlic`, `ftop_arrest`, `ftop_unkpz`, `ftop_su`, `ftop_unsu`, `ftop_ticket`, `ftop_frisk`, `ftop_take`, `ftop_sellgunlic`, `ftop_pkills`, `ftop_aload_materials`, `ftop_aunload_materials`, `ftop_akills`, `ftop_heal`, `ftop_heal_drugs`, `ftop_sex`, `ftop_medcard`, `ftop_hload_medicines`, `ftop_hunload_medicines`, `ftop_edit`, `ftop_rob_shop`, `ftop_gload_drugs`, `ftop_gunload_drugs`, `ftop_gload_materials`, `ftop_gunload_materials`, `ftop_gkills`, `ftop_gdeaths`, `ftop_rob_bank`, `ftop_mload_drugs`, `ftop_munload_drugs`, `ftop_mload_materials`, `ftop_munload_materials`, `ftop_mbkills`, `ftop_mbdeaths`, `ftop_selllic`, `ftop_sellinsurance`, `ftop_bload_drugs`, `ftop_bunload_drugs`, `ftop_bload_materials`, `ftop_bunload_materials`, `quest`, `mission`, `mission_exp`, `mission_days`, `achievement`, `achievement_progress`, `check_active_time`, `pame_text`, `pame_time`, `lotto`, `casino_block`, `job_block`, `block_theft_car_acc`, `promocode_use`, `promocode_create`, `promocode_time`, `promocode_donate`, `promocode_prize`, `newyear_quest`, `newyear_quest_stage`, `gift_check`, `gift_idx`, `gift`, `donate_show`, `taxi`, `taxi_idx`, `taxi_rank`, `taxi_percent`, `taxi_salary`, `taxi_salary_all`, `tc`, `tc_idx`, `tc_rank`, `tc_percent`, `tc_salary`, `tc_salary_all`, `freelance_lvl`, `freelance_success`, `freelance_money`, `freelance_fm`, `battle_lvl`, `battle_lvl_task`, `battle_info`, `battle_task`, `battle_task_active`, `daily_days`, `daily_time`, `daily_today`, `daily_update_reward`, `payday_oil_count`, `halloween_id`, `halloween_progress`) VALUES
(3, 'Federico_Voidson', '$2y$08$by3/ORPLZjHUOyPEOzL0QeolbTMNKXQCIgGJxwWBMPDXlKmo4ab42', 1, 0, 362491694, 500000, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 2, 'romak9505@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '17.2.2026', '146.59.45.242', '88.135.253.8', 79, 0, 0, 10000, 2, 20, 0, 0, 0, '', 0, 3, 3, 10, 283, 2, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0', '8757|8757|8757|8757|8757|8757|8757|8757|8757', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 1, '0|0|0', 0, 23769, 0, 95, 97.5, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 1, 0, 0, 0, 0, 0, 0, '04/03/2026', -1, -1, 0, 0, 384, '-', 0, 1915, 399, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2281.37, 2426.09, 3.47656, 174.716, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '1|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|50|50|50|1|50|1|1|1|1|1|50|1|1|1|50|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|3|1|1|0', '3', '1', '0', 70, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, '0000-00-00', 9899, 0, 0, '4, 7, 1, 5, 2, 6, 8, 8, 6, 10, 2, 3, 2, 10, 2, 1', '2, 484, 2, 2500, 5144, 2, 24, 176, 2, 401, 7498, 2500000, 6018, 540, 5949, 2', '0, 0, 0, 0, 0, 651, 0, 0, 648, 0, 0, 0, 0, 0, 0, 0', '1, 6, 3, 1, 2, 8, 10, 6, 4, 2, 7, 2, 8, 5, 2, 10', '4, 7, 5000000, 3, 138656, 184, 467, 5, 47, 144931, 524, 135494, 184, 5000, 130885, 475', '0, 641, 0, 0, 0, 0, 0, 647, 0, 0, 0, 0, 0, 0, 0, 0', '6, 5, 11, 6, 1, 4, 2, 8, 2, 10, 9, 7, 10, 8, 3, 7', '10, 10000, 599, 10, 5, 68, 171572, 47, 276689, 560, 265, 540, 402, 33, 10000000, 515', '647, 0, 0, 648, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|1|0|0|0|10|0|0|0|0|0|0|1|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '5|0|0|10|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 'Основателя Проекта', 1771403444, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 399, 0, 0, 0, 0, 0),
(4, 'Boot_Heyn', '$2y$08$YVfWaBfiTy2yPiDsWRXhQOoaCm654JaIC2l1tavF9n4drFi05jpLe', 1, 0, 588, 950000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 'kuznecovr880@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '17.2.2026', '46.98.213.79', '46.98.212.164', 79, 0, 0, 1402, 2, 11, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '333|333|333|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 19910, 0, 83, 91.5, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', -1, 0, 0, 0, 0, NULL, 0, 352, 0, 1287, 0, 101, 0, 0, 0, 0, 0, 0, 0, 1772558188, 1794.32, -1752.47, 13.1448, 29.831, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 2486, 0, 0, '4, 3, 8, 1, 2, 5, 10, 2, 10, 6, 7, 2, 2, 8, 1, 6', '2, 2500000, 177, 2, 7954, 2500, 526, 8426, 516, 1, 534, 7060, 8593, 2, 2, 1', '0, 0, 0, 0, 0, 0, 0, 0, 0, 641, 0, 0, 0, 0, 0, 641', '4, 7, 9, 1, 1, 2, 10, 10, 5, 2, 3, 6, 6, 8, 2, 8', '44, 569, 128, 4, 3, 74881, 586, 550, 5000, 78520, 5000000, 9, 8, 180, 80172, 28', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 649, 651, 0, 0, 0', '1, 3, 8, 8, 10, 7, 10, 9, 2, 4, 7, 11, 5, 2, 6, 6', '6, 10000000, 291, 292, 493, 587, 446, 57, 179606, 53, 558, 488, 10000, 189180, 14, 11', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 651, 641', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|1|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '5|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 1771403709, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(11, 'Artem_Kovalev', '$2y$08$RjPBX1T/RyfncBToZhXITuGgZ2MtBgofbjuR9YMEWZ3JM0DLJwBXy', 1, 0, 673430, 1525000, 0, 0, 0, 0, 0, 0, 0, 0, 99957445, 0, 0, 0, 'artemkovalev098@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '26.2.2026', '91.201.247.183', '91.201.247.204', 79, 1, 319, 14, 2, 22, 10, 0, 123123, '', 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0', '8759|8759|8759|8759|8759|8759|8759|8759|8759', 1, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 64225, 0, 100, 100, 100, 0, 0, 0, 0, 0, '1|1|1|1', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '04/03/2026', -1, 0, 0, 0, 0, NULL, 0, 265, 2559, 7094, 1734, 982, 0, 0, 0, 0, 0, 0, 0, 1772637467, -2424.36, 494.985, 29.922, 325.429, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '50|50|50|50|2|2|1|1|1|1|1|1|1|1|1|1|1|1|1|2|1|1|1', '0|0|0|0|24|24|24|25|0|1|25|0|5|3|0|0|0|0|0|24|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 4345, 0, 0, '1, 2, 8, 3, 2, 6, 1, 4, 2, 8, 5, 6, 7, 10, 2, 10', '2, 8799, 177, 2500000, 9767, 2, 2, 1, 6297, 7, 2500, 1, 521, 542, 9074, 422', '0, 0, 0, 0, 0, 645, 0, 0, 0, 0, 0, 641, 0, 0, 0, 0', '4, 1, 2, 5, 7, 10, 9, 1, 8, 8, 2, 6, 3, 2, 6, 10', '26, 3, 61806, 5000, 471, 558, 210, 4, 28, 60, 144205, 6, 5000000, 61570, 8, 489', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 641, 0, 0, 649, 0', '10, 10, 5, 3, 8, 8, 6, 7, 6, 9, 2, 11, 2, 7, 4, 1', '453, 480, 10000, 10000000, 289, 19, 13, 618, 13, 113, 291962, 490, 187787, 529, 51, 6', '0, 0, 0, 0, 0, 0, 649, 0, 641, 0, 0, 0, 0, 0, 0, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|50|25|50|50|50|50|25|50|1|1|1|25|25|0|1|0|3|5|0|0|0|0|0|0|0|1|0|0|0|0', '1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|5|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0||0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '15|50|25|50|50|50|50|25|25|25|0|1|0|3|5|0|0|0|0|0|0|50|0|0|0|15|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108, 1, 30, 3150, 3150, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 2559, 0, 0, 0, 0, 0),
(12, 'Fantan_Strayfa', '$2y$08$RCfAWxjDXyzOUhWxPVHOZO1qVOMn4bdWaGgj7czpGBGs7mNiJUZt.', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 'dpdpdpd@gmail.ru', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '26.2.2026', '176.98.21.128', '176.98.21.128', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 1016, 0, 91.5, 95.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '26/02/2026', -1, 0, 0, 0, 0, NULL, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772107136, 1775.99, -1893.78, 13.3965, 154.799, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(13, 'Adam_Lord', '$2y$08$bSHhQBOvKCPrPkX2XRLzS.myT5.KQR3llmqO3zF5buTgwqd/RXJzS', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'artempanikarevic5@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '27.2.2026', '176.60.54.41', '176.60.47.2', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 1237, 0, 89.5, 94.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', -1, 0, 0, 0, 0, NULL, 0, 1185, 0, 1113, 0, 33, 0, 0, 0, 0, 0, 0, 0, 1772564955, 1772.66, -1895.92, 13.5625, 9.4601, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '4, 6, 3, 8, 5, 10, 8, 6, 1, 2, 10, 2, 7, 1, 2, 2', '2, 1, 2500000, 154, 2500, 471, 67, 2, 1, 8682, 540, 7433, 481, 1, 8303, 7197', '0, 647, 0, 0, 0, 0, 0, 645, 0, 0, 0, 0, 0, 0, 0, 0', '1, 10, 2, 3, 7, 5, 8, 4, 2, 9, 6, 6, 10, 8, 2, 2', '4, 418, 85380, 5000000, 488, 5000, 273, 37, 119579, 157, 6, 5, 400, 298, 102739, 129775', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 641, 647, 0, 0, 0, 0', '11, 3, 2, 2, 6, 9, 10, 4, 8, 5, 1, 10, 6, 7, 7, 8', '568, 10000000, 202188, 284819, 11, 171, 487, 62, 249, 10000, 5, 484, 10, 555, 586, 299', '0, 0, 0, 0, 651, 0, 0, 0, 0, 0, 0, 0, 650, 0, 0, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(14, 'texas_holdems', '$2y$08$MUvMYBP/LjPiZiLtclX2WOa2EqDcsOXrySOp0wlxoe4g8AzoLyXSC', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'gey123@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1.3.2026', '195.133.81.72', '195.133.81.72', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 48, 0, 100, 100, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '01/03/2026', -1, 0, 0, 0, 0, NULL, 0, 41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772366049, 1857.61, -1879.77, 15.478, 106.436, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(15, 'Amiri_Junk', '$2y$08$bxfyORLLQkCwbUHGMDXkR.THbueaWsSXtEbMqfJNKvecuP2ZaKKri', 1, 0, 168205354, 34710000, 0, 0, 0, 0, 0, 0, 1, 0, 1037925, 0, 0, 0, 'molodez2213@gmail.com ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1.3.2026', '84.52.10.7', '84.52.10.7', 79, 1, 332, 777, 2, 12, 7, 0, 569727, '', 0, 0, 0, 0, 0, 1, 0, 0, 777, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0', '8756|8756|8756|8756|8756|8756|8756|8756|8756', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 14984, 0, 99.5, 99.75, 100, 0, 0, 0, 0, 0, '1|1|1|1', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', 410, 10, 0, 0, 0, '03/03/2026', 0, 1339, 0, 1166, 0, 69, 0, 0, 0, 0, 0, 0, 0, 1772544493, -1537.49, -2342.83, 15.843, 127.559, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '1|0|1|1|0', '1|1|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '6', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 9259, 0, 0, '2, 7, 8, 6, 8, 5, 1, 2, 2, 1, 3, 2, 4, 10, 6, 10', '9945, 528, 101, 2, 146, 2500, 2, 9876, 7934, 2, 2500000, 6846, 2, 479, 1, 500', '0, 0, 0, 641, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 645, 0', '3, 6, 9, 10, 2, 6, 5, 8, 7, 2, 8, 1, 10, 4, 2, 2', '5000000, 9, 128, 533, 149767, 7, 5000, 183, 468, 145250, 184, 4, 576, 48, 59464, 128249', '0, 647, 0, 0, 0, 650, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '7, 10, 3, 1, 11, 2, 9, 8, 6, 4, 7, 5, 10, 2, 8, 6', '511, 484, 10000000, 5, 504, 282023, 276, 293, 10, 69, 609, 10000, 580, 160074, 46, 10', '0, 0, 0, 0, 0, 0, 0, 0, 641, 0, 0, 0, 0, 0, 0, 641', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '3|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(16, 'shalava_lalala', '$2y$08$bC71WTW2bUHXbiHLSznSY.XrcdabsTG92DopeI68oZiPQU9oedr7y', 1, 0, 102000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 79950, 0, 0, 1, 'vladinkognito6@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1.3.2026', '77.239.108.55', '77.239.108.55', 79, 1, 335, 1, 1, 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 1228, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 668, 0, 94.5, 97.25, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '01/03/2026', -1, 0, 0, 0, 0, NULL, 0, 601, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '7, 6, 10, 4, 2, 5, 3, 8, 10, 6, 1, 2, 8, 1, 2, 2', '523, 2, 516, 2, 9215, 2500, 2500000, 7, 458, 2, 1, 5090, 7, 2, 8442, 7596', '0, 647, 0, 0, 0, 0, 0, 0, 0, 651, 0, 0, 0, 0, 0, 0', '7, 9, 5, 4, 6, 1, 10, 10, 3, 8, 8, 6, 1, 2, 2, 2', '563, 159, 5000, 47, 6, 3, 421, 602, 5000000, 170, 60, 6, 4, 132969, 60400, 74580', '0, 0, 0, 0, 651, 0, 0, 0, 0, 0, 0, 641, 0, 0, 0, 0', '10, 2, 1, 10, 9, 5, 11, 4, 7, 7, 3, 2, 6, 6, 8, 8', '453, 187574, 6, 453, 92, 10000, 522, 65, 609, 555, 10000000, 203580, 12, 10, 22, 33', '0, 645, 650, 0, 0, 0, 0, 0, 0, 0, 0, 0, 650, 645, 0, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(17, 'Rahatlukum_Bezvednik', '$2y$08$LE2vRxfpTz.yKzD2UkzrSOKNRyogGB15TqThxHYPtox6GESLQ0RHG', 1, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'kfalsfk@mail.ru', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1.3.2026', '178.125.204.32', '178.125.204.32', 79, 1, 336, 1, 2, 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 774, 0, 93.5, 96.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '01/03/2026', -1, 0, 0, 0, 0, NULL, 0, 366, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772387325, 1254.69, -1403.73, 13.0032, 315.419, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(18, 'Kizaru_Bishop', '$2y$08$WzHJclPqT1XLaxGzZzjKYOyXy5fmQ9xk/u8xydpVe5paPvjqBX75O', 1, 0, 92195000, 3456200, 50000000, 0, 0, 2, 0, 1, 10000, 0, 10802753, 0, 0, 0, 'gogogog@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2.3.2026', '95.153.107.57', '95.153.107.57', 79, 1, 324, 777, 2, 35, 8, 0, 810480, '', 0, 0, 0, 0, 0, 0, 0, 676, 666, 490, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 364, '1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0', '8747|8747|8747|8747|8747|8747|8747|8747|8747', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 33990, 0, 100, 100, 100, 0, 0, 0, 0, 0, '1|1|1|1', 0, 0, '0|0|0|0', -1, 1, 1, 1772827598, 3, 2087908988, 0, 0, '04/03/2026', 411, 10, 0, 0, 48, '03/03/2026', 0, 369, 4803, 18582, 16, 114, 0, 0, 0, 0, 0, 0, 0, 1772637374, -2422.27, 496.608, 30.0703, 118.177, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '1|0|1|1|0', '1|1|1|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '50|50|1|50|1|50|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|50|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|2|5|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00', 6257, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0', '2|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0||0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '12|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|2|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 1, 4803, 0, 0, 0, 0, 0),
(19, 'Nicky_Scarfo', '$2y$08$RSa3LFHFXDTiR1PgTibfPOxbjffBQ9fNIKz3hDZ.ZvkRjPG/I6i26', 1, 0, 12100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'ha@mail.ru', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2.3.2026', '185.167.217.41', '185.167.217.41', 79, 1, 336, 1, 2, 3, 0, 0, 0, '', 0, 8, 8, 10, 113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '336|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 1, '0|0|0', 0, 1211, 0, 89.5, 94.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '02/03/2026', -1, 0, 0, 0, 0, NULL, 0, 1008, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772462596, 1776.35, -1905.4, 13.3967, 20.7935, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '10, 3, 5, 4, 10, 6, 6, 7, 2, 1, 1, 8, 2, 8, 2, 2', '479, 2500000, 2500, 2, 422, 2, 2, 600, 8497, 1, 1, 24, 8872, 156, 9967, 9595', '0, 0, 0, 0, 0, 648, 649, 0, 0, 0, 0, 0, 0, 0, 0, 0', '10, 3, 2, 1, 2, 2, 5, 6, 6, 2, 1, 10, 9, 8, 4, 7', '467, 5000000, 61600, 3, 100901, 94345, 5000, 8, 5, 67204, 4, 533, 128, 298, 28, 580', '0, 0, 0, 0, 0, 0, 0, 648, 651, 0, 0, 0, 0, 0, 0, 0', '4, 7, 10, 7, 11, 8, 10, 2, 1, 9, 8, 5, 6, 2, 6, 3', '74, 462, 446, 458, 442, 91, 484, 241682, 5, 266, 84, 10000, 11, 250624, 11, 10000000', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 651, 0, 647, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(20, 'Artur_YT', '$2y$08$RCTfaEDzTx/RYjm1PCC2Q.9orNIuW7sfMU2i8P1cAoSv3LrAxf7JK', 1, 0, 801000, 25000, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 'sdasdasdfas@mail.ru', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2.3.2026', '5.77.203.206', '5.77.203.206', 79, 0, 0, 50, 2, 1, 4, 0, 293169, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0', '8760|8760|8760|8760|8760|8760|8760|8760|8760', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 4505, 0, 79, 89.5, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '04/03/2026', -1, 0, 0, 0, 0, NULL, 0, 2958, 1031, 0, 1105, 0, 0, 0, 0, 0, 0, 0, 0, 1772635762, -1562.96, 632.913, 7.03906, 214.541, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 203, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 203, 0, 0, 0, 0, 0),
(21, 'Armoh_Billionaires', '$2y$08$TlbBXz/vKhjWa0HzTSznQuO3uguhjh0N8jF5tLhkj5IOnZKHfm6NG', 1, 0, 551000, 125000, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 2, 'xachatryanarman996@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2.3.2026', '46.162.201.19', '46.162.201.19', 79, 0, 0, 1, 2, 1, 0, 0, 0, '', 0, 4, 4, 10, 165, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '336|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 1, '0|0|0', 0, 1859, 0, 84.5, 92.25, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 1, 1, 1772727714, 0, 0, 0, 0, '02/03/2026', -1, 0, 0, 0, 0, NULL, 0, 1857, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772469684, 1865.33, -2364.12, 13.5547, 43.7401, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(22, 'Manch_Eagle', '$2y$08$LCP/cijkZxjTPCr/LhLibu7YEQJfbyA/meR6cucKDCanWj7LRkw9W', 1, 0, 751000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sahakyanartur035@gmail.com\n\n', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2.3.2026', '91.231.202.139', '178.78.129.48', 79, 0, 0, 1, 2, 1, 0, 0, 0, '', 0, 4, 4, 10, 165, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '336|0|0|0|0|0|0|0|0', 0, '0|0|24|0|29|31|0|0|17|0|0|0|0', '0|0|11|0|30|30|0|0|5|0|0|0|0', 1, '0|0|0', 0, 2308, 0, 80.5, 90.25, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '04/03/2026', -1, 0, 0, 0, 0, NULL, 0, 2170, 830, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1772635396, -1572.5, 621.741, 7.22588, 91.1566, '1|1|1|1|1|1|0|0|1|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0),
(23, 'Sas_Food', '$2y$08$W0rKTyTjbDLGWyi1T0j4YOYTAdva.ofg44KEz/HpFDdaJGr9vEeRy', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'asdde@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2.3.2026', '217.113.13.135', '217.113.13.135', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 14, 14, 10, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 1, '0|0|0', 0, 299, 0, 97.5, 98.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '02/03/2026', -1, 0, 0, 0, 0, NULL, 0, 228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772468826, 1780.34, -1894.3, 13.3609, 328.271, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '2, 1, 8, 7, 5, 2, 1, 4, 2, 10, 2, 8, 10, 6, 3, 6', '8679, 2, 45, 520, 2500, 9918, 1, 2, 6837, 462, 6507, 146, 401, 1, 2500000, 2', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 647, 0, 649', '1, 8, 2, 10, 6, 8, 9, 1, 2, 10, 6, 4, 2, 7, 3, 2', '3, 180, 140273, 536, 5, 273, 202, 4, 79705, 575, 5, 40, 124132, 533, 5000000, 85317', '0, 0, 0, 0, 649, 0, 0, 0, 0, 0, 641, 0, 0, 0, 0, 0', '3, 5, 2, 7, 9, 1, 4, 10, 6, 10, 7, 6, 2, 8, 11, 8', '10000000, 10000, 195868, 464, 279, 5, 59, 512, 11, 511, 459, 13, 244463, 84, 430, 214', '0, 0, 0, 0, 0, 0, 0, 0, 649, 0, 0, 645, 0, 0, 0, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(24, 'Litov_Unwanted', '$2y$08$Y1XqOkXgZ1fgTyPrRCDDLuUhWmkf9LTta60TRwtE54f49rR5TSXCi', 1, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'hrtgsbh@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3.3.2026', '195.140.224.139', '195.140.224.139', 79, 1, 335, 1, 2, 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 489, 0, 95.5, 97.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', -1, 0, 0, 0, 0, NULL, 0, 480, 0, 480, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(25, 'Kitaec', '$2y$08$RTXFYDXORBPTRR.2XivKUexvcsVOBGF.UceyCNkyvsJ2FlT2nkuB.', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2000000, 0, 0, 'bsnsnsn@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3.3.2026', '77.222.99.179', '77.222.99.179', 79, 0, 0, 1, 2, 0, 7, 0, 123123, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 383, 0, 99.5, 99.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', -1, 0, 0, 0, 0, NULL, 0, 355, 0, 355, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, -1290.98, 2686.88, 50.0625, 132.542, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '5, 10, 8, 2, 2, 2, 1, 6, 1, 6, 7, 4, 8, 10, 2, 3', '2500, 462, 156, 7825, 5170, 6336, 1, 1, 1, 2, 477, 2, 144, 527, 8447, 2500000', '0, 0, 0, 0, 0, 0, 0, 649, 0, 647, 0, 0, 0, 0, 0, 0', '4, 9, 5, 8, 1, 6, 2, 2, 1, 7, 8, 6, 2, 10, 10, 2', '36, 202, 5000, 28, 4, 6, 95013, 116015, 4, 566, 180, 8, 92955, 603, 566, 83168', '0, 0, 0, 0, 0, 641, 0, 0, 0, 0, 0, 651, 0, 0, 0, 0', '2, 10, 2, 4, 5, 6, 6, 1, 11, 7, 8, 7, 9, 10, 3, 8', '168091, 463, 158845, 58, 10000, 13, 10, 6, 571, 614, 294, 486, 208, 519, 10000000, 46', '0, 0, 0, 0, 0, 645, 648, 0, 0, 0, 0, 0, 0, 0, 0, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(26, 'Roma_Myers', '$2y$08$YF/GQVHqZijVXk3xKlC3a.AxZOWE/b3yRReuQPjA2MJ4ro/RnpnmO', 1, 0, 560004461, 9945000, 0, 0, 0, 0, 0, 0, 0, 0, 99959392, 0, 0, 3, 'kuznecovevgenij437@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3.3.2026', '46.98.212.164', '46.98.212.19', 79, 1, 332, 10, 2, 12, 1, 0, 917382, '', 0, 0, 0, 0, 0, 0, 0, 677, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0', '8760|8760|8760|8760|8760|8760|8760|8760|8760', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 12523, 0, 100, 100, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 3, 2087973065, 0, 0, '04/03/2026', -1, 0, 0, 0, 0, '-', 0, 2949, 3391, 8549, 167, 261, 0, 0, 0, 0, 0, 0, 0, 0, 2111.29, 1377.02, 10.666, 180, '1|1|1|1|1|1|0|0|0|0|1|3|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '1|1|0|1', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '4|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '404|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 1263, 0, 0, '8, 3, 5, 10, 8, 10, 2, 6, 7, 2, 6, 1, 2, 4, 2, 1', '67, 2500000, 2500, 542, 224, 473, 9041, 2, 516, 6693, 1, 1, 8522, 1, 7843, 1', '0, 0, 0, 0, 0, 0, 0, 650, 0, 0, 647, 0, 0, 0, 0, 0', '3, 8, 8, 6, 5, 4, 2, 9, 1, 6, 2, 1, 10, 2, 10, 7', '5000000, 184, 180, 5, 5000, 28, 80759, 157, 3, 6, 96206, 3, 579, 132177, 535, 561', '0, 0, 0, 648, 0, 0, 0, 0, 0, 647, 0, 0, 0, 0, 0, 0', '11, 10, 1, 8, 7, 2, 4, 9, 6, 7, 3, 5, 2, 10, 6, 8', '504, 506, 6, 297, 527, 236576, 58, 300, 10, 511, 10000000, 10000, 169672, 487, 14, 228', '0, 0, 0, 0, 0, 0, 0, 0, 647, 0, 0, 0, 0, 0, 647, 0', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|4|0|0|0|0|0|0|0|0|1|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|0|0|0', '1|4|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0||0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '3|4|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 3391, 0, 0, 0, 0, 0);
INSERT INTO `accounts` (`id`, `name`, `password`, `usepassword`, `online`, `money`, `bank`, `bank_deposit`, `bank_deposit_limit`, `bank_deposit_limit_put`, `bank_deposit_limit_take`, `bank_pension`, `bank_pension_status`, `bitcoin`, `donate`, `flinmoney`, `donate_all`, `donate_all_new`, `source_reg`, `mail`, `email_confirmed`, `vk_userid`, `vk_type`, `vk_code`, `vk_session`, `vk_confirmed`, `vk_auth`, `tg_userid`, `tg_confirmed`, `tg_auth`, `datareg`, `regip`, `lastip`, `skin`, `passport`, `passport_time`, `level`, `sex`, `exp`, `admin`, `youtube_adm`, `admin_pass`, `google_code`, `med_card`, `leader`, `member`, `rang`, `fskin`, `spawn`, `job`, `active_phone_id`, `phone_number`, `phone_balance`, `ban`, `mute`, `warn`, `wanted`, `jail_time`, `jail`, `helper`, `pin_code`, `free_change_nick`, `d_demolition`, `d_addiction`, `Lic`, `Lic_Warn`, `Lic_Time`, `paintball`, `Weapon`, `Ammo`, `fwork`, `h_r_settings`, `rmute`, `p_game_time`, `p_limite_bank_count`, `satiety`, `thirst`, `need`, `style_styde`, `walk_style`, `walk_status`, `style_progress`, `style_chat`, `Style`, `stylestyde`, `styleprogress`, `styles`, `current_quest`, `p_flin_music_free`, `p_flin_music`, `p_flin_music_time`, `p_vip`, `p_vip_time`, `p_add_vip`, `p_add_vip_time`, `lastenter`, `family_id`, `family_rang`, `family_mute`, `family_warn`, `family_exp`, `family_enter`, `checkdrug`, `p_time_payday`, `p_time_today`, `p_time_yesterday`, `p_afk_today`, `p_afk_yesterday`, `bonus_time`, `bonus_today`, `bonus_days`, `rob_time`, `news`, `fwarn`, `warn_time`, `time_exit_game`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_r`, `p_settings`, `skin_default`, `Update`, `DonateUpdate`, `CaptKill`, `pick`, `fracdata`, `TaxiTime`, `referral`, `referralmoney`, `referralcount`, `job_skill_new`, `job_skill_count_new`, `job_skill_salary_new`, `costume`, `costume_use`, `disease`, `partner`, `service`, `veh_slots`, `skin_slots`, `bizz_slots`, `active_bizz_id`, `inv_slots`, `skins`, `active_skin_id`, `gift_promocode_status`, `gift_promocode_time`, `house_slots`, `active_house_id`, `spawn_house_id`, `med_insurance`, `med_insurance_time`, `billet_army`, `billet_cop`, `billet_exp`, `escape_limit`, `commit_a_robbery`, `robbed`, `lastenter_new`, `free_roulette_time`, `free_roulette_status`, `fixcar_time`, `roulette_items_bronze`, `roulette_items_count_bronze`, `roulette_items_idx_bronze`, `roulette_items_silver`, `roulette_items_count_silver`, `roulette_items_idx_silver`, `roulette_items_gold`, `roulette_items_count_gold`, `roulette_items_idx_gold`, `ftop_unarrest`, `ftop_givepass`, `ftop_selllawyerlic`, `ftop_arrest`, `ftop_unkpz`, `ftop_su`, `ftop_unsu`, `ftop_ticket`, `ftop_frisk`, `ftop_take`, `ftop_sellgunlic`, `ftop_pkills`, `ftop_aload_materials`, `ftop_aunload_materials`, `ftop_akills`, `ftop_heal`, `ftop_heal_drugs`, `ftop_sex`, `ftop_medcard`, `ftop_hload_medicines`, `ftop_hunload_medicines`, `ftop_edit`, `ftop_rob_shop`, `ftop_gload_drugs`, `ftop_gunload_drugs`, `ftop_gload_materials`, `ftop_gunload_materials`, `ftop_gkills`, `ftop_gdeaths`, `ftop_rob_bank`, `ftop_mload_drugs`, `ftop_munload_drugs`, `ftop_mload_materials`, `ftop_munload_materials`, `ftop_mbkills`, `ftop_mbdeaths`, `ftop_selllic`, `ftop_sellinsurance`, `ftop_bload_drugs`, `ftop_bunload_drugs`, `ftop_bload_materials`, `ftop_bunload_materials`, `quest`, `mission`, `mission_exp`, `mission_days`, `achievement`, `achievement_progress`, `check_active_time`, `pame_text`, `pame_time`, `lotto`, `casino_block`, `job_block`, `block_theft_car_acc`, `promocode_use`, `promocode_create`, `promocode_time`, `promocode_donate`, `promocode_prize`, `newyear_quest`, `newyear_quest_stage`, `gift_check`, `gift_idx`, `gift`, `donate_show`, `taxi`, `taxi_idx`, `taxi_rank`, `taxi_percent`, `taxi_salary`, `taxi_salary_all`, `tc`, `tc_idx`, `tc_rank`, `tc_percent`, `tc_salary`, `tc_salary_all`, `freelance_lvl`, `freelance_success`, `freelance_money`, `freelance_fm`, `battle_lvl`, `battle_lvl_task`, `battle_info`, `battle_task`, `battle_task_active`, `daily_days`, `daily_time`, `daily_today`, `daily_update_reward`, `payday_oil_count`, `halloween_id`, `halloween_progress`) VALUES
(27, 'Xuligan_Admins', '$2y$08$SjXJLx/yXybRLE7MTkLQTOoM28cB9JHEDMJf.GLyqnGknZX7Ca4NG', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'hshshdufbfuxjk@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3.3.2026', '91.231.202.159', '91.231.202.159', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 137, 0, 99, 99.5, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', -1, 0, 0, 0, 0, NULL, 0, 120, 0, 120, 0, 14, 0, 0, 0, 0, 0, 0, 0, 1772551692, 1651.52, -1869.99, 13.3828, 46.5075, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(28, 'Nikushka_Vendetta', '$2y$08$TUL4chfrTjbhRzK2T0DnOO4xBCscKrNPuZgkFOpcy703NTChfyW9m', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'kuzfegeld@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3.3.2026', '46.98.212.164', NULL, 79, 0, 0, 1, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 0, 0, 100, 100, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '0', -1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 26, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(29, 'The_Bizzaro', '$2y$08$QSPYcBSuTzLBbTbzKzKuYuXKKfvZ255TB2NQLx7IgxX8lASGWsQJq', 1, 0, 2000, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1, 'kuzfeged@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3.3.2026', '146.59.32.70', '57.128.241.4', 79, 1, 335, 1, 2, 3, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 4651, 0, 83, 91.5, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', 411, 1, 0, 0, 0, '03/03/2026', 0, 1460, 0, 4190, 0, 436, 0, 0, 0, 0, 0, 0, 0, 0, 1756.85, -1895.19, 13.5664, 271.439, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 28, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(30, 'Monser_Bog', '$2y$08$KxjwR0TkO0TsOUvLUjjmXuuYonxA0pfHLILmHlT0hWh7zgt1YxdJy', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'fggdfgdfgd@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3.3.2026', '178.120.54.67', '178.120.54.67', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 174, 0, 98.5, 99.25, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '03/03/2026', -1, 0, 0, 0, 0, NULL, 0, 173, 0, 173, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772564236, 1787.13, -1892.73, 13.4046, 264.922, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|0|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0),
(31, 'Sova_Nemo', '$2y$08$XzXzbB/rRinsSCHELBjhXO4Itbi6dsImtD26wRuRFLy4jznBBNKBS', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 'mikcaelnegodjaev@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '4.3.2026', '23.137.12.15', '194.110.207.30', 79, 0, 0, 1, 2, 0, 4, 0, 410754, '', 0, 19, 19, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 1, '0|0|0', 0, 1461, 0, 91.5, 95.75, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '04/03/2026', -1, 0, 0, 0, 0, NULL, 0, 1196, 1196, 0, 208, 0, 0, 0, 0, 0, 0, 0, 0, 0, 312.831, -1788.39, 4.59418, 338.068, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|1|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0),
(32, 'No_Name', '$2y$08$b1DzUkDVajjFYyrXQlCzbeBCxCSVcpgzK14ETNSJmZJPeyg8c5WeO', 1, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'gg@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '4.3.2026', '89.232.4.86', '89.232.4.86', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 153, 0, 98.5, 99.25, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 0, 0, 0, 0, '04/03/2026', -1, 0, 0, 0, 0, NULL, 0, 152, 152, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1772626605, 1796.99, -1893.33, 13.4119, 102.619, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|1|1', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0),
(33, 'Lain', '$2y$08$aCP/Qi3xTliuYyLQXjnPYe2HJkl.X5SWrTxtzSl2.D21MbRL3jc8K', 1, 0, 705045281, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4962725, 0, 0, 0, '213123ef@gmail.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '4.3.2026', '84.189.162.7', '84.189.162.7', 79, 0, 0, 1, 2, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', 0, '0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0|0|0', 0, 384, 0, 97, 98.5, 100, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, '0|0|0|0', -1, 0, 0, 0, 3, 2087993659, 1, 2087993663, '04/03/2026', -1, 0, 0, 0, 0, NULL, 0, 363, 363, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 1772634303, 329.611, -1778.86, 4.95656, 129.149, '1|1|1|1|1|1|0|0|0|0|1|0|0|0|0|0|1|0|1|1|1|1|1|1|1|1|1|0|1|1|1|0', 0, '0|0|0|0|0', '0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0', 'None', 0, '1|1|2|1|1|0', '3', '1', '0', 60, '0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00', 0, 0, 0, '8, 6, 3, 6, 5, 8, 7, 2, 2, 10, 4, 2, 2, 1, 1, 10', '2, 1, 2500000, 2, 2500, 177, 485, 6904, 6061, 526, 1, 5099, 6130, 1, 1, 410', '0, 645, 0, 647, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '4, 1, 5, 10, 3, 7, 2, 2, 10, 6, 2, 9, 2, 1, 6, 8', '49, 4, 5000, 400, 5000000, 582, 108480, 117641, 421, 7, 100996, 159, 93359, 4, 6, 184', '0, 0, 0, 0, 0, 0, 0, 0, 0, 648, 0, 0, 0, 0, 647, 0', '3, 4, 5, 7, 8, 6, 7, 11, 8, 10, 10, 1, 9, 6, 2, 2', '10000000, 57, 10000, 458, 295, 14, 613, 597, 289, 560, 453, 6, 122, 12, 189844, 203186', '0, 0, 0, 0, 0, 650, 0, 0, 0, 0, 0, 0, 0, 651, 0, 0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '', 0, 0, 0, 0, 0, 0, 0, '01.01.1980 00:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, '0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `aclogs`
--

CREATE TABLE `aclogs` (
  `id` int(11) NOT NULL,
  `type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED;

--
-- Дамп данных таблицы `aclogs`
--

INSERT INTO `aclogs` (`id`, `type`, `date`, `name`, `reason`, `data`) VALUES
(0, 'kicklog', '18-2-2026', 'Misha_Swaagbomjfg', '[kick] inv client', '2:32:28 | 5.136.222.182 | 0 | 65535 | 0.000000'),
(0, 'kicklog', '18-2-2026', 'Diler_Narkoop', '[kick] inv client', '11:5:44 | 5.136.222.182 | 0 | 65535 | 0.000000'),
(0, 'kicklog', '18-2-2026', 'Diler_Narkoop', '[kick] inv client', '11:6:0 | 5.136.222.182 | 0 | 65535 | 0.000000'),
(0, 'panellog', '18-2-2026', 'Erik_Kogan', '[block] tp pickup', '12:30:16 | 77.219.13.13 | 1 | 105 | 0.000000'),
(0, 'panellog', '18-2-2026', 'Erik_Kogan', '[block] tp pickup', '12:32:47 | 77.219.13.13 | 1 | 75 | 0.808727'),
(0, 'panellog', '18-2-2026', 'Erik_Kogan', '[block] tp pickup', '12:37:0 | 77.219.13.13 | 1 | 186 | 0.011898'),
(0, 'panellog', '18-2-2026', 'Erik_Kogan', '[block] tp pickup', '13:2:48 | 77.219.13.13 | 1 | 75 | 2.141402'),
(0, 'panellog', '18-2-2026', 'Erik_Kogan', '[block] tp pickup', '13:4:52 | 77.219.13.13 | 1 | 80 | 2.093464'),
(0, 'panellog', '18-2-2026', 'Andrew_Gerty', '[block] tp pickup', '14:26:58 | 46.98.213.220 | 1 | 65 | 0.955121'),
(0, 'panellog', '18-2-2026', 'John_Altezza', '[block] tp pickup', '14:40:4 | 176.54.79.132 | 1 | 105 | 0.037838'),
(0, 'panellog', '18-2-2026', 'Tana_Shav', '[block] nop pos', '20:34:14 | 46.98.213.220 | 1 | 60 | 8.986393'),
(0, 'panellog', '27-2-2026', 'Adam_Lord', '[block] tp pickup', '23:35:12 | 176.60.54.41 | 1 | 86 | 0.000000'),
(0, 'panellog', '1-3-2026', 'shalava_lalala', '[block] tp pickup', '18:53:3 | 77.239.108.55 | 1 | 131 | 0.000000'),
(0, 'panellog', '1-3-2026', 'shalava_lalala', '[block] tp pickup', '18:58:27 | 77.239.108.55 | 1 | 130 | 0.000000'),
(0, 'panellog', '1-3-2026', 'shalava_lalala', '[block] tp pickup', '19:1:23 | 77.239.108.55 | 1 | 125 | 0.000000'),
(0, 'panellog', '1-3-2026', 'shalava_lalala', '[block] tp pickup', '19:2:36 | 77.239.108.55 | 1 | 125 | 0.000000'),
(0, 'panellog', '1-3-2026', 'Rahatlukum_Bezvednik', '[block] tp pickup', '20:28:19 | 178.125.204.32 | 1 | 49 | 0.071690'),
(0, 'panellog', '1-3-2026', 'Rahatlukum_Bezvednik', '[block] tp pickup', '20:29:19 | 178.125.204.32 | 1 | 54 | 0.039198'),
(0, 'panellog', '2-3-2026', 'Nicky_Scarfo', '[block] tp pickup', '17:13:18 | 185.167.217.41 | 1 | 206 | 0.000000'),
(0, 'panellog', '2-3-2026', 'Nicky_Scarfo', '[block] tp pickup', '17:13:55 | 185.167.217.41 | 1 | 90 | 3.210850'),
(0, 'panellog', '2-3-2026', 'Nicky_Scarfo', '[block] tp pickup', '17:19:51 | 185.167.217.41 | 1 | 86 | 1.170740'),
(0, 'panellog', '2-3-2026', 'Nicky_Scarfo', '[block] tp pickup', '17:28:0 | 185.167.217.41 | 1 | 81 | 0.754045'),
(0, 'panellog', '2-3-2026', 'Artur_YT', '[block] tp pickup', '18:51:30 | 5.77.203.206 | 1 | 87 | 0.000000'),
(0, 'panellog', '2-3-2026', 'Artur_YT', '[block] tp pickup', '18:57:29 | 5.77.203.206 | 1 | 85 | 0.000000'),
(0, 'panellog', '2-3-2026', 'Sas_Food', '[block] nop pos', '19:12:17 | 217.113.13.135 | 1 | 85 | 0.000000'),
(0, 'panellog', '2-3-2026', 'Sas_Food', '[block] tp pickup', '19:12:39 | 217.113.13.135 | 1 | 80 | 0.067673'),
(0, 'panellog', '2-3-2026', 'Sas_Food', '[block] tp pickup', '19:13:51 | 217.113.13.135 | 1 | 91 | 0.732368'),
(0, 'panellog', '2-3-2026', 'Sas_Food', '[block] carhack #6', '19:13:59 | 217.113.13.135 | 2 | 90 | 0.669532'),
(0, 'kicklog', '2-3-2026', 'Sas_Food', '[kick] wide flood', '19:17:5 | 217.113.13.135 | 2 | 91 | 1.024208'),
(0, 'panellog', '2-3-2026', 'Artur_YT', '[block] tp pickup', '19:20:12 | 5.77.203.206 | 1 | 81 | 0.000000'),
(0, 'panellog', '2-3-2026', 'Armoh_Billionaires', '[block] tp pickup', '19:20:23 | 46.162.201.19 | 1 | 80 | 0.017050'),
(0, 'panellog', '2-3-2026', 'Artur_YT', '[block] tp pickup', '19:25:51 | 5.77.203.206 | 1 | 80 | 0.000000'),
(0, 'panellog', '2-3-2026', 'Armoh_Billionaires', '[block] tp pickup', '19:25:51 | 46.162.201.19 | 1 | 107 | 0.013425'),
(0, 'panellog', '2-3-2026', 'Artur_YT', '[block] tp pickup', '19:26:36 | 5.77.203.206 | 1 | 85 | 0.000000'),
(0, 'panellog', '2-3-2026', 'Federico_Voidson', '[block] tp pickup', '22:25:49 | 46.98.212.125 | 1 | 65 | 5.714288'),
(0, 'panellog', '2-3-2026', 'Boot_Heyn', '[block] tp pickup', '22:34:9 | 46.98.212.125 | 1 | 71 | 0.588538'),
(0, 'panellog', '2-3-2026', 'Boot_Heyn', '[block] tp pickup', '22:37:14 | 46.98.212.125 | 1 | 65 | 0.712969'),
(0, 'panellog', '3-3-2026', 'Litov_Unwanted', '[block] tp pickup', '12:56:20 | 195.140.224.139 | 1 | 55 | 0.820191'),
(0, 'panellog', '3-3-2026', 'Litov_Unwanted', '[block] tp pickup', '12:56:55 | 195.140.224.139 | 1 | 55 | 4.169238'),
(0, 'panellog', '3-3-2026', 'Litov_Unwanted', '[block] nop pos', '13:3:47 | 195.140.224.139 | 1 | 55 | 12.690866'),
(0, 'kicklog', '3-3-2026', 'Litov_Unwanted', '[kick] noppos kick', '13:4:13 | 195.140.224.139 | 1 | 55 | 16.827185'),
(0, 'panellog', '3-3-2026', 'Roma_Myers', '[block] nop pos', '16:36:17 | 46.98.212.164 | 1 | 65 | 27.989185'),
(0, 'panellog', '3-3-2026', 'Roma_Myers', '[block] tp pickup', '16:40:15 | 146.59.45.5 | 1 | 201 | 0.000000'),
(0, 'kicklog', '3-3-2026', 'Roma_Myers', '[block] packet flood', '16:45:16 | 146.59.45.5 | 1 | 141 | 6.830835'),
(0, 'panellog', '3-3-2026', 'Roma_Myers', '[block] tp pickup', '16:54:5 | 46.98.212.164 | 1 | 70 | 0.528231'),
(0, 'kicklog', '3-3-2026', 'Roma_Myers', '[block] packet flood', '16:54:53 | 46.98.212.164 | 1 | 120 | 5.877184'),
(0, 'panellog', '3-3-2026', 'Roma_Myers', '[block] tp pickup', '17:6:33 | 57.128.240.251 | 1 | 141 | 1.531853'),
(0, 'panellog', '3-3-2026', 'Roma_Myers', '[block] tp pickup', '17:24:46 | 57.128.240.251 | 1 | 131 | 1.310711'),
(0, 'kicklog', '3-3-2026', 'Roma_Myers', '[kick] fast tp', '17:31:15 | 57.128.240.251 | 1 | 299 | 18.433599'),
(0, 'panellog', '3-3-2026', 'Xuligan_Admins', '[block] tp pickup', '18:16:27 | 91.231.202.159 | 1 | 101 | 0.923934'),
(0, 'panellog', '3-3-2026', 'The_Bizzaro', '[block] tp pickup', '21:30:18 | 146.59.32.70 | 1 | 95 | 2.261094'),
(0, 'panellog', '3-3-2026', 'The_Bizzaro', '[block] tp pickup', '21:31:23 | 146.59.32.70 | 1 | 125 | 3.310570'),
(0, 'panellog', '3-3-2026', 'Adam_Lord', '[block] tp pickup', '21:40:45 | 109.126.168.123 | 1 | 101 | 2.624023'),
(0, 'panellog', '3-3-2026', 'Adam_Lord', '[block] tp pickup', '21:42:50 | 109.126.168.123 | 1 | 85 | 5.627028'),
(0, 'panellog', '3-3-2026', 'Adam_Lord', '[block] tp pickup', '21:44:31 | 109.126.168.123 | 1 | 100 | 4.785676'),
(0, 'panellog', '3-3-2026', 'Adam_Lord', '[block] tp pickup', '21:58:3 | 176.60.47.2 | 1 | 80 | 8.192821'),
(0, 'panellog', '4-3-2026', 'No_Name', '[block] tp pickup', '15:5:23 | 89.232.4.86 | 1 | 90 | 0.013798'),
(0, 'panellog', '4-3-2026', 'Sova_Nemo[PC]', '[block] tp pickup', '15:7:24 | 23.137.12.15 | 1 | 90 | 0.000000'),
(0, 'panellog', '4-3-2026', 'Sova_Nemo[PC]', '[block] tp pickup', '15:8:17 | 23.137.12.15 | 1 | 90 | 0.000000'),
(0, 'panellog', '4-3-2026', 'Sova_Nemo', '[block] tp pickup', '15:14:11 | 23.137.12.15 | 1 | 95 | 0.000000'),
(0, 'panellog', '4-3-2026', 'Lain', '[block] tp pickup', '17:11:29 | 84.189.162.7 | 1 | 34 | 0.000000');

-- --------------------------------------------------------

--
-- Структура таблицы `admin_log`
--

CREATE TABLE `admin_log` (
  `ID` int(11) NOT NULL,
  `TYPE` int(11) NOT NULL DEFAULT 0,
  `ADMIN` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'None',
  `PLAYER` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'None',
  `REASON` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'None',
  `DATA` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логи администрации';

--
-- Дамп данных таблицы `admin_log`
--

INSERT INTO `admin_log` (`ID`, `TYPE`, `ADMIN`, `PLAYER`, `REASON`, `DATA`) VALUES
(1, 24, 'Artem_Kovalev', 'Federico_Voidson', 'Установил TYPE: 0 | VALUE: 50', '2026-02-17 20:53:51'),
(2, 14, 'xScandal_Revengen', 'Federico_Voidson', 'Причина: ошибка ', '2026-02-17 21:53:27'),
(3, 14, 'xScandal_Revengen', 'Federico_Voidson', 'Причина: ошибка ', '2026-02-17 21:56:53'),
(4, 14, 'xScandal_Revengen', 'Federico_Voidson', 'Причина: ошибка ', '2026-02-17 22:00:10'),
(5, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: 9 | VALUE: 9', '2026-02-17 22:33:32'),
(6, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: -1 | VALUE: 1', '2026-02-17 22:34:03'),
(7, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: 0 | VALUE: 100', '2026-02-17 22:37:18'),
(8, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: 0 | VALUE: 100', '2026-02-17 22:37:41'),
(9, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: 0 | VALUE: 100', '2026-02-17 22:39:39'),
(10, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: 0 | VALUE: 100', '2026-02-17 22:43:31'),
(11, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: 0 | VALUE: 1000', '2026-02-17 22:44:03'),
(12, 24, 'Federico_Voidson', 'Boot_Heyn', 'Установил TYPE: 0 | VALUE: 1', '2026-02-17 22:45:26'),
(13, 24, 'Federico_Voidson', 'Federico_Voidson', 'Установил TYPE: 0 | VALUE: 100', '2026-02-17 22:55:34'),
(14, 24, 'Federico_Voidson', 'Federico_Voidson', 'Установил TYPE: -1 | VALUE: 100', '2026-02-17 22:55:42'),
(15, 24, 'Federico_Voidson', 'Federico_Voidson', 'Установил TYPE: 0 | VALUE: 100', '2026-02-17 22:56:04'),
(16, 24, 'Federico_Voidson', 'Federico_Voidson', 'Установил TYPE: 0 | VALUE: 1000', '2026-02-17 22:56:19'),
(17, 24, 'Federico_Voidson', 'Federico_Voidson', 'Установил TYPE: 0 | VALUE: 10000', '2026-02-17 22:56:27'),
(18, 14, 'Federico_Voidson', 'Boot_Heyn', 'Причина: gh', '2026-02-17 23:02:57'),
(19, 5, 'Federico_Voidson', 'Andrew_Gerty', '1', '2026-02-18 08:44:55'),
(20, 9, 'Boot_Heyn', 'Tana_Shav', 'd', '2026-02-18 17:35:13'),
(21, 14, 'Boot_Heyn', 'Federico_Voidson', 'Причина: 4', '2026-02-18 17:41:07'),
(22, 14, 'Boot_Heyn', 'Federico_Voidson', 'Причина: 4', '2026-02-18 17:48:47'),
(23, 14, 'Boot_Heyn', 'Federico_Voidson', 'Причина: fdkd', '2026-02-18 18:36:09'),
(24, 14, 'Boot_Heyn', 'Federico_Voidson', 'Причина: fdkd', '2026-02-18 18:38:16'),
(25, 14, 'Federico_Voidson', 'Boot_Heyn', 'Причина: f', '2026-02-18 18:42:14'),
(26, 8, 'Artem_Kovalev', 'Artem_Kovalev', 'Уволил из организации', '2026-02-26 22:20:36'),
(27, 8, 'Artem_Kovalev', 'Artem_Kovalev', 'Уволил из организации', '2026-02-26 22:22:12'),
(28, 8, 'Artem_Kovalev', 'Artem_Kovalev', 'Уволил из организации', '2026-02-27 08:33:57'),
(29, 4, 'Artem_Kovalev', 'shalava_lalala', 'так администрации ', '2026-03-01 15:54:13'),
(30, 8, 'Artem_Kovalev', 'Artem_Kovalev', 'Уволил из организации', '2026-03-02 14:20:43'),
(31, 8, 'Artem_Kovalev', 'Artem_Kovalev', 'Уволил из организации', '2026-03-02 14:34:02'),
(32, 8, 'Artem_Kovalev', 'Artem_Kovalev', 'Уволил из организации', '2026-03-02 14:37:25'),
(33, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-02 15:39:30'),
(34, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-02 16:10:07'),
(35, 24, 'Amiri_Junk', 'Amiri_Junk', 'Установил TYPE: 0 | VALUE: 455', '2026-03-02 17:58:27'),
(36, 24, 'Amiri_Junk', 'Amiri_Junk', 'Установил TYPE: 0 | VALUE: 777', '2026-03-02 17:58:38'),
(37, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 777', '2026-03-02 20:02:34'),
(38, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 777', '2026-03-02 20:03:13'),
(39, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 1', '2026-03-02 20:03:24'),
(40, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 1', '2026-03-02 20:03:27'),
(41, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 777', '2026-03-02 20:03:37'),
(42, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 777', '2026-03-02 20:03:49'),
(43, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 777', '2026-03-02 20:04:14'),
(44, 24, 'Artem_Kovalev', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 10', '2026-03-02 20:05:13'),
(45, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 10', '2026-03-02 20:06:52'),
(46, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 10', '2026-03-02 20:07:15'),
(47, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 10', '2026-03-02 20:07:54'),
(48, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 0 | VALUE: 777', '2026-03-02 20:08:02'),
(49, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-02 20:16:26'),
(50, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-02 20:29:48'),
(51, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-02 20:32:51'),
(52, 24, 'Artem_Kovalev', 'Artem_Kovalev', 'Установил TYPE: 0 | VALUE: 10', '2026-03-02 23:08:51'),
(53, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-03 13:13:30'),
(54, 24, 'Kizaru_Bishop', 'Roma_Myers', 'Установил TYPE: 0 | VALUE: 10', '2026-03-03 14:02:42'),
(55, 19, 'Kizaru_Bishop', 'Roma_Myers', 'До выяснений связаться можно со мной тг @TaLaXeRU', '2026-03-03 17:08:26'),
(56, 11, 'Kizaru_Bishop', '46.98.212.164', 'Связать со мной в тг @TaLaXeRU', '2026-03-03 17:12:33'),
(57, 19, 'Kizaru_Bishop', 'The_Bizzaro', 'Твинк', '2026-03-03 19:39:38'),
(58, 24, 'Kizaru_Bishop', 'Roma_Myers', 'Установил TYPE: 2 | VALUE: 0', '2026-03-03 19:47:49'),
(59, 24, 'Kizaru_Bishop', 'Roma_Myers', 'Установил TYPE: 2 | VALUE: 5', '2026-03-03 19:56:12'),
(60, 7, 'Kizaru_Bishop', 'Roma_Myers', '1', '2026-03-03 19:57:03'),
(61, 8, 'Kizaru_Bishop', 'Roma_Myers', 'Уволил из организации', '2026-03-03 19:58:24'),
(62, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-03 19:58:26'),
(63, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 2 | VALUE: 0', '2026-03-03 19:59:04'),
(64, 24, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Установил TYPE: 2 | VALUE: 5000000', '2026-03-03 19:59:11'),
(65, 7, 'Kizaru_Bishop', 'Roma_Myers', '1', '2026-03-03 20:00:50'),
(66, 7, 'Kizaru_Bishop', 'Roma_Myers', '1', '2026-03-03 20:09:14'),
(67, 4, 'Kizaru_Bishop', 'Roma_Myers', '1', '2026-03-03 20:09:20'),
(68, 16, 'Kizaru_Bishop', 'Roma_Myers', '1', '2026-03-03 20:15:29'),
(69, 8, 'Kizaru_Bishop', 'Sova_Nemo', 'Уволил из организации', '2026-03-04 13:09:35'),
(70, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-04 13:10:44'),
(71, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-04 13:57:05'),
(72, 8, 'Kizaru_Bishop', 'Artur_YT', 'Уволил из организации', '2026-03-04 14:04:47'),
(73, 8, 'Kizaru_Bishop', 'Manch_Eagle', 'Уволил из организации', '2026-03-04 14:20:49'),
(74, 8, 'Artem_Kovalev', 'Manch_Eagle', 'Уволил из организации', '2026-03-04 14:22:02'),
(75, 24, 'Kizaru_Bishop', 'Artur_YT', 'Установил TYPE: 0 | VALUE: 50', '2026-03-04 14:29:33'),
(76, 8, 'Kizaru_Bishop', 'Kizaru_Bishop', 'Уволил из организации', '2026-03-04 14:58:24');

-- --------------------------------------------------------

--
-- Структура таблицы `admin_logs`
--

CREATE TABLE `admin_logs` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `a_day_0` int(11) NOT NULL DEFAULT 0,
  `a_day_1` int(11) NOT NULL DEFAULT 0,
  `a_day_2` int(11) NOT NULL DEFAULT 0,
  `a_day_3` int(11) NOT NULL DEFAULT 0,
  `a_day_4` int(11) NOT NULL DEFAULT 0,
  `a_day_5` int(11) NOT NULL DEFAULT 0,
  `a_day_6` int(11) NOT NULL DEFAULT 0,
  `a_ans` int(11) NOT NULL DEFAULT 0,
  `a_kick` int(11) NOT NULL DEFAULT 0,
  `a_mute` int(11) NOT NULL DEFAULT 0,
  `a_jail` int(11) NOT NULL DEFAULT 0,
  `a_warn` int(11) NOT NULL DEFAULT 0,
  `a_ban` int(11) NOT NULL DEFAULT 0,
  `a_offban` int(11) NOT NULL DEFAULT 0,
  `a_offjail` int(11) NOT NULL DEFAULT 0,
  `a_offwarn` int(11) NOT NULL DEFAULT 0,
  `a_offmute` int(11) NOT NULL DEFAULT 0,
  `a_rep` int(11) NOT NULL DEFAULT 0,
  `a_afk_0` int(11) NOT NULL DEFAULT 0,
  `a_afk_1` int(11) NOT NULL DEFAULT 0,
  `a_afk_2` int(11) NOT NULL DEFAULT 0,
  `a_afk_3` int(11) NOT NULL DEFAULT 0,
  `a_afk_4` int(11) NOT NULL DEFAULT 0,
  `a_afk_5` int(11) NOT NULL DEFAULT 0,
  `a_afk_6` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логи по админам';

--
-- Дамп данных таблицы `admin_logs`
--

INSERT INTO `admin_logs` (`id`, `name`, `a_day_0`, `a_day_1`, `a_day_2`, `a_day_3`, `a_day_4`, `a_day_5`, `a_day_6`, `a_ans`, `a_kick`, `a_mute`, `a_jail`, `a_warn`, `a_ban`, `a_offban`, `a_offjail`, `a_offwarn`, `a_offmute`, `a_rep`, `a_afk_0`, `a_afk_1`, `a_afk_2`, `a_afk_3`, `a_afk_4`, `a_afk_5`, `a_afk_6`) VALUES
(1, 'Federico_Voidson', 0, 0, 0, 0, 1849, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 0, 0),
(2, 'xScandal_Revengen', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 'Boot_Heyn', 0, 0, 0, 0, 1836, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 0, 0),
(4, 'Amiri_Junk', 0, 0, 0, 0, 13683, 1244, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2253, 69, 0),
(5, 'Kizaru_Bishop', 0, 0, 0, 0, 10178, 18763, 4827, 3, 0, 1, 3, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 235, 114, 16),
(6, 'Kitaec', 0, 0, 0, 0, 0, 302, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 0),
(9, 'Roma_Myers', 0, 0, 0, 0, 0, 3918, 3603, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 102, 167),
(10, 'Sova_Nemo', 0, 0, 0, 0, 0, 0, 481, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26),
(11, 'Artur_YT', 0, 0, 0, 0, 0, 0, 2038, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1105);

-- --------------------------------------------------------

--
-- Структура таблицы `anticheats`
--

CREATE TABLE `anticheats` (
  `id` int(11) UNSIGNED NOT NULL,
  `cheatname` varchar(56) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cheatvalue` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Античит-названия';

--
-- Дамп данных таблицы `anticheats`
--

INSERT INTO `anticheats` (`id`, `cheatname`, `cheatvalue`) VALUES
(1, 'Air Break - Пешком', 1),
(2, 'Air Break - В машине', 1),
(3, 'Телепорт - Пешком', 1),
(4, 'Телепорт - В машине', 1),
(5, 'Телепорт (into/between vehicles)', 1),
(6, 'Телепорт (vehicle to player)', 1),
(7, 'Телепорт (pickups)', 1),
(8, 'Fly Hack - Пешком', 1),
(9, 'Fly Hack - В машине', 2),
(10, 'Speed Hack - Пешком', 1),
(11, 'Speed Hack - В машине', 1),
(12, 'Восстановление здоровья - Veh', 1),
(13, 'Восстановление здоровья - Foot', 0),
(14, 'Восстановление брони', 0),
(15, 'Чит на деньги', 0),
(16, 'Чит на оружие', 1),
(17, 'Чит на патроны', 1),
(18, 'Чит на бесконечные патроны', 0),
(19, 'Специальные анимации', 1),
(20, 'God Mode - Пешком', 0),
(21, 'God Mode - В машине', 1),
(22, 'Невидимка', 1),
(23, 'LagComp Spoof', 1),
(24, 'Чит на тюнинг', 1),
(25, 'Паркур мод', 0),
(26, 'Быстрый разворот', 1),
(27, 'Ускоренная стрельба', 1),
(28, 'Ложный Спавн', 0),
(29, 'Ложная смерть', 2),
(30, 'Pro Aim', 1),
(31, 'Бег CJ', 1),
(32, 'Car Shot', 1),
(33, 'Антивыкидывание из транспорта', 1),
(34, 'Антифриз', 0),
(35, 'Ghost Hack', 1),
(36, 'Silent Aim', 1),
(37, 'Ракбот', 0),
(38, 'Быстрый реконнект', 0),
(39, 'Высокий пинг', 0),
(40, 'Подмена диалога', 1),
(41, 'Песочница', 0),
(42, 'Неверная версия', 1),
(43, 'Ркон авторизация', 0),
(44, 'Тюнинг крашер', 1),
(45, 'Крашер неверной посадки', 1),
(46, 'Дилог крашер', 1),
(47, 'Attach крашер', 1),
(48, 'Weapon крашер', 1),
(49, 'Подключение в 1 слот', 0),
(50, 'Флуд функциями', 1),
(51, 'Флуд смен позиции', 1),
(52, 'DDoS', 1),
(53, 'Игнорирование функции', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `antidm_info`
--

CREATE TABLE `antidm_info` (
  `id` int(10) UNSIGNED NOT NULL,
  `X1` float NOT NULL DEFAULT 0,
  `Y1` float NOT NULL DEFAULT 0,
  `Z1` float NOT NULL DEFAULT 0,
  `X2` float NOT NULL DEFAULT 0,
  `Y2` float NOT NULL DEFAULT 0,
  `Z2` float NOT NULL DEFAULT 0,
  `infoX` float NOT NULL DEFAULT 0,
  `infoY` float NOT NULL DEFAULT 0,
  `infoZ` float NOT NULL DEFAULT 0,
  `infoRZ` float NOT NULL DEFAULT 0,
  `radius` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `type` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `int` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `virt` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `flags` varchar(68) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `antidm_info`
--

INSERT INTO `antidm_info` (`id`, `X1`, `Y1`, `Z1`, `X2`, `Y2`, `Z2`, `infoX`, `infoY`, `infoZ`, `infoRZ`, `radius`, `type`, `int`, `virt`, `flags`) VALUES
(1, -2106.61, -284.592, 35.3203, -2010.9, -61.8712, 35.3203, -2033.6, -91.4878, 34.1203, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(2, -2042.51, 1087.52, 52.819, -1957.7, 1139.14, 55.7188, -1984.65, 1108.04, 51.9635, 90.4, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(3, 1069.76, 1011.68, 11, 1112.89, 1147.59, 11, 1072.05, 1065.4, 9.00019, -32.5, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(4, 945.324, -1388.16, 13.559, 973.745, -1348.08, 16.3384, 948.202, -1384.34, 12.1438, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(5, 1045.8, -1843.71, 13.5469, 1289.06, -1719.84, 13.5469, 1149.52, -1748.14, 12.3703, -178.9, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(6, -2020.95, 54.1571, 28.8422, -1966.38, 215.248, 29.5295, -1984.34, 152.299, 26.4875, -90.9, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(7, 2753.25, 1219.98, 9.95098, 2876.24, 1398.41, 10.8873, 2838.64, 1295.33, 10.1906, -88.9, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(8, 1083.01, -1252.92, 15.8272, 1117.51, -1219.43, 17.9711, 1085.38, -1236.01, 14.6203, 90.8, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(9, 2279.59, -2385.3, 13.5469, 2288.77, -2304.96, 13.5469, 2284.05, -2368.18, 12.3469, 48, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(10, -1702.79, 644.591, 7.1875, -1568.27, 721.524, 24.8906, -1611.36, 718.821, 11.8203, -176.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(11, 2237.64, 2420.78, 10.8203, 2360.05, 2506.79, 10.8203, 2346.31, 2455.52, 13.7742, -88.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(12, 598.529, -622.006, 16.3359, 646.672, -535.198, 16.38, 634.028, -575.004, 15.1359, 91.9, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(13, -2491.88, 464.587, 24.8906, -2396.68, 556.507, 28.7064, -2455.54, 499.596, 28.8804, 91.8, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(14, -2743.21, 575.597, 14.6094, -2535.38, 700.816, 41.2734, -2673.15, 632.303, 13.2531, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(15, 1575.97, 1720.8, 10.8203, 1640.28, 1866.03, 10.8203, 1591.82, 1819.67, 9.62031, -179.2, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(16, 644.606, -1387.72, 13.5469, 788.678, -1328.93, 13.6734, 646.37, -1362.28, 12.4048, -89.2, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(17, -2138.55, 329.67, 35.1719, -2015.28, 496.775, 35.3203, -2045.7, 456.112, 33.9719, -178.2, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(18, 2615.42, 1161.41, 10.4932, 2679.05, 1246.54, 10.8203, 2651.67, 1184.31, 9.62031, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(19, 1341.3, 305.308, 19.5547, 1353.45, 382.063, 19.5547, 1349.5, 345.044, 19.1662, -114.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(20, 1899.88, 122.418, 29.2563, 2011.64, 261.341, 29.7763, 1933.84, 168.132, 36.0752, 159.4, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(21, -1214.43, -1246.77, 128.454, -1044.95, -906.99, 129.434, -1059.7, -1200.42, 128.019, 89.4, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(22, 1878, 940.655, 9.92908, 2085.26, 1085.12, 10.8203, 2023.86, 1000.62, 9.62031, 89.5, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(23, 2094.77, 1662.12, 11.084, 2197.63, 1724.34, 20.3906, 2187.9, 1681.01, 9.90985, -87.4, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(24, 82.6389, -1883.03, 1.84908, 178.768, -1753.26, 5.07858, 148.332, -1793.57, 2.69513, 98.1, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(25, -2243.57, 218.001, 35.3203, -2152.61, 328.273, 35.3203, -2187.71, 310.696, 34.1203, -179, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(26, 0, 0, 0, 0, 0, 0, 1572.54, 1129.52, 1037.42, -91.9, 60, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(27, 0, 0, 0, 0, 0, 0, 2291.51, -58.078, 1069.11, -90, 50, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(28, 0, 0, 0, 0, 0, 0, -2103.97, -120.377, 1043.49, 0, 50, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(29, 0, 0, 0, 0, 0, 0, 2478.39, -1550.12, 2000.51, 0, 30, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(30, 0, 0, 0, 0, 0, 0, 2610.04, 2114.17, 1028.71, 0, 40, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(31, 0, 0, 0, 0, 0, 0, 2611.72, 2114.12, 1039.1, 0, 40, 0, 1, 2, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(32, 0, 0, 0, 0, 0, 0, 2611.75, 2113.87, 1034.14, 0, 40, 0, 1, 3, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(33, 0, 0, 0, 0, 0, 0, 2610.72, 2114.18, 1018.02, 0, 50, 0, 1, 4, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(34, 0, 0, 0, 0, 0, 0, -1320.38, 1777.67, 1064.2, 0, 40, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(35, 0, 0, 0, 0, 0, 0, -2965.14, 1082.98, 993.919, 0, 50, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(36, 0, 0, 0, 0, 0, 0, -2966.3, 1082.92, 993.099, 0, 50, 0, 1, 2, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(37, 0, 0, 0, 0, 0, 0, -2967.49, 1083.17, 995.339, 0, 50, 0, 1, 3, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(38, 0, 0, 0, 0, 0, 0, 1212.75, 2060.78, 996.677, 0, 40, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(39, 0, 0, 0, 0, 0, 0, 1212.78, 2062.07, 984.697, 0, 40, 0, 1, 2, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(40, 0, 0, 0, 0, 0, 0, 1212.75, 2063.26, 980.436, 0, 40, 0, 1, 3, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(41, 0, 0, 0, 0, 0, 0, -301.871, 1446.35, 2041.8, 0, 50, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(42, 0, 0, 0, 0, 0, 0, 167.312, 1116.65, 2061.54, 0, 35, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(43, 0, 0, 0, 0, 0, 0, 34.0905, 1438.97, 2040.47, 0, 20, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(44, 2808.67, 1480.18, 10.8465, 2854.67, 1532.12, 10.8529, 2823.44, 1523.1, 9.70815, 90.6, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(45, -626.004, -566.386, 23.5027, -463.194, -466.554, 26.1563, -478.755, -516.469, 24.3178, -90.8, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(46, -252.531, -302.863, 1.42188, -169.127, -172.117, 2.42358, -230.998, -248.296, 0.221875, 125.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(47, 19.9228, -298.494, 1.57812, 126.856, -219.838, 2.50946, 56.1968, -263.513, 0.378125, 178.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(48, 2460.64, -2249.03, 13.5469, 2602.2, -2202.51, 13.5469, 2484.67, -2237.56, 12.3469, -179.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(49, 1323.94, -1602.65, 13.5397, 1418.45, -1554.16, 13.5469, 1418.98, -1603.27, 12.4269, 90.6, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(50, 1900.47, 942.505, 1994.47, 2020.84, 1066.65, 1994.47, 2012.1, 1030.11, 1995.68, 0, 0, 1, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(51, 0, 0, 0, 0, 0, 0, 1029.57, 1865.76, 1506.89, 0, 25, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(52, 0, 0, 0, 0, 0, 0, 1299.96, -50.1772, 2001.3, 0, 100, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(53, -2847.42, 1268.26, 7.10156, -2789.93, 1328.74, 7.2395, -2810.91, 1328.48, 5.90156, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(54, 1333.62, -1289.12, 13.5469, 1333.96, -1289.1, 15.7933, 1333.96, -1289.12, 12.3469, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(55, 1381.55, -1861.41, 13.5469, 1617.81, -1583.52, 13.7188, 1474.08, -1723.27, 12.3469, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(56, 2373.98, -2696.71, 13.6295, 2526.06, -2466.02, 13.6529, 2453.36, -2569.13, 12.4763, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(57, 2399.89, -2592.07, 1013.62, 2440.44, -2474.28, 1013.62, 2440.9, -2592.5, 1012.42, -179.2, 0, 1, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(58, 1699.83, -1942.65, 13.5804, 1810.58, -1860.24, 16.4225, 1770.09, -1910.27, 12.1918, 90.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(59, 1026.09, -1583.64, 13.5469, 1367.32, -1269.44, 13.5469, 1128.93, -1438.32, 14.7269, 178.9, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(60, -502.35, -1651.93, 5.37053, -3.49578, -1254.9, 10.4809, -380.547, -1450.77, 24.5266, -89.5, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(61, 0, 0, 0, 0, 0, 0, 198.301, -1687.62, 997.389, 0, 50, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(62, 0, 0, 0, 0, 0, 0, 198.566, -1687.89, 997.099, 0, 50, 0, 1, 2, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(63, 0, 0, 0, 0, 0, 0, 198.827, -1688.22, 996.819, 0, 50, 0, 1, 3, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(64, 971.531, -2009.92, 1.20652, 1110.06, -1874.37, 13.5469, 1037.48, -1961.11, 11.7939, -92.6, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(65, 897.218, 2529.56, 10.8203, 1191.54, 2711.55, 12.2304, 1129.64, 2601.97, 9.62031, 66.7, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(66, -297.981, -87.8674, 1.45009, -32.5531, 165.724, 2.43941, -79.4681, 80.0422, 1.91719, -19, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(67, 2335.43, 1576.87, 1010.79, 2353.67, 1596, 1011.25, 2336.57, 1591.6, 1021.3, 0, 0, 1, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(68, 1699.54, -1644.02, 20.2071, 1744.35, -1608.3, 20.222, 1732.82, -1637.11, 19.0157, 179.5, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(69, 1647.78, -1430.66, 13.5469, 1667.61, -1394.46, 13.5469, 1654.6, -1394.23, 12.3469, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(70, 1343.72, 1571.86, 1010.79, 1367.38, 1600.27, 1010.9, 1365.72, 1595.19, 1016.29, 0, 0, 1, 1, 99, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(71, 1542.75, -1714.18, 28.3948, 1619.07, -1561.6, 28.75, 1564.97, -1667.34, 27.1956, -179.8, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(72, 1418.63, -1602.59, 13.5469, 1449.57, -1527.23, 13.5469, 1419.55, -1557.02, 12.3469, 89.4, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(73, 0, 0, 0, 0, 0, 0, -1888.52, -1660.8, 20.55, 88, 200, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(74, 0, 0, 0, 0, 0, 0, 224.86, -1688.1, 1983.31, 0, 100, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(75, 0, 0, 0, 0, 0, 0, 229.7, -1685.7, 2983.65, 0, 50, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(76, 0, 0, 0, 0, 0, 0, 224.86, -1688.1, 1983.31, 0, 100, 0, 1, 2, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(77, 0, 0, 0, 0, 0, 0, 229.7, -1685.7, 2983.65, 0, 50, 0, 1, 2, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(78, 0, 0, 0, 0, 0, 0, 224.86, -1688.1, 1983.31, 0, 100, 0, 1, 3, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(79, 0, 0, 0, 0, 0, 0, 229.7, -1685.7, 2983.65, 0, 50, 0, 1, 3, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(80, 0, 0, 0, 0, 0, 0, 1603.87, 809.717, 1168.48, 0, 100, 0, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(81, 1347.42, -1683.83, 13.5469, 1380.82, -1614.01, 13.5993, 1358.41, -1654.98, 12.1828, 88.7, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(82, 0, 0, 0, 0, 0, 0, 1410.36, -1486.55, 19.2344, 0, 50, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(83, 0, 0, 0, 0, 0, 0, 2333.8, 1586.46, 987.768, 0, 50, 0, 1, 111, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(84, 0, 0, 0, 0, 0, 0, 2321.96, 559.193, 6.58125, -178.9, 50, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(85, 0, 0, 0, 0, 0, 0, -81.4308, 400.839, 7.66565, -88.9, 25, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(86, 0, 0, 0, 0, 0, 0, 3044.74, 2529.76, 8.4449, -89.2, 25, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(87, 0, 0, 0, 0, 0, 0, 3077.57, -1389.99, 8.48375, -89.3, 25, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(88, 0, 0, 0, 0, 0, 0, -64.9868, -1125.46, -0.121875, -109.3, 25, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(89, 0, 0, 0, 0, 0, 0, 1493.92, 1305.79, 1074.77, 0, 25, 0, 3, 98, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(90, 1606.57, -1150.87, 24.0781, 1685.34, -1090.89, 24.0781, 1647.71, -1150.85, 23.0163, 0, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(91, -2701.4, -65.05, 4.27961, -2609.32, -13.5974, 4.32812, -2696.85, -53.7238, 3.12812, -90.8, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(92, 2122.66, 1778.43, 10.8203, 2258.59, 1838.99, 10.8203, 2147.63, 1823.62, 9.62031, -116.3, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(93, 1745.8, -1814.08, 13.3828, 1816.33, -1737.49, 13.5391, 1777.89, -1742.09, 12.3469, 179.4, 0, 1, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(94, 0, 0, 0, 0, 0, 0, 356.88, 1311.86, 11.3766, -179.4, 50, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(95, 0, 0, 0, 0, 0, 0, 631.448, 1364.25, 10.86, -179.8, 50, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'),
(96, 0, 0, 0, 0, 0, 0, 437.17, 1575.85, 10.4122, 177.7, 50, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0');

-- --------------------------------------------------------

--
-- Структура таблицы `apbs`
--

CREATE TABLE `apbs` (
  `id` int(10) NOT NULL,
  `charge` varchar(128) CHARACTER SET utf8 NOT NULL,
  `suspect` varchar(24) CHARACTER SET utf8 NOT NULL,
  `officer` varchar(24) CHARACTER SET utf8 NOT NULL,
  `date` varchar(32) CHARACTER SET utf8 NOT NULL,
  `faction` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `battlepass_reward`
--

CREATE TABLE `battlepass_reward` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `reward_id` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `billboard`
--

CREATE TABLE `billboard` (
  `id` int(11) NOT NULL,
  `playerid` int(11) DEFAULT 0,
  `days` int(11) DEFAULT 0,
  `name` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство',
  `materialsize` int(11) DEFAULT 110,
  `fontface` int(11) DEFAULT 13,
  `fontsize` int(11) DEFAULT 28,
  `fontbold` int(11) DEFAULT 1,
  `fontcolor` int(11) DEFAULT 6,
  `backcolor` int(11) DEFAULT 0,
  `textaligment` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `billboard`
--

INSERT INTO `billboard` (`id`, `playerid`, `days`, `name`, `text`, `materialsize`, `fontface`, `fontsize`, `fontbold`, `fontcolor`, `backcolor`, `textaligment`) VALUES
(1, 0, 0, 'Мэрия', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 20, 42, 1, 0, 0, 1),
(2, 0, 0, 'Банк', '(008000)Рекламное место свободно///(FFA500)\"Обращайтесь в рекламное\"/агентство', 130, 11, 42, 1, 1, 0, 1),
(3, 0, 0, 'Автошкола', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 20, 42, 1, 0, 0, 1),
(4, 0, 0, 'Военкомат', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(5, 0, 0, 'Рынок', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 20, 42, 1, 0, 0, 1),
(6, 0, 0, 'Офисы компаний', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(7, 0, 0, 'Авторынок', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 20, 42, 1, 0, 0, 1),
(8, 0, 0, 'Аукцион контейнеров', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(9, 0, 0, 'Town', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(10, 0, 0, 'Церковь', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(11, 0, 0, 'Центр развлечений', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 20, 42, 1, 0, 0, 1),
(12, 0, 0, 'Casino Four Dragons', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(13, 0, 0, 'Casino Caligula', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(14, 0, 0, 'Выезд из ЛС в СФ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(15, 0, 0, 'Выезд из ЛС в ЛВ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(16, 0, 0, 'Въезд в СФ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(17, 0, 0, 'Въезд в ЛВ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(18, 0, 0, 'Больница ЛС', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(19, 0, 0, 'Больница СФ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(20, 0, 0, 'Больница ЛВ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(21, 0, 0, 'Автовокзал ЛС', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(22, 0, 0, 'ЖД СФ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1),
(23, 0, 0, 'ЖД ЛВ', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 20, 42, 1, 0, 0, 1),
(24, 0, 0, 'ЖД ЛС', '(008000)Рекламное место свободно///(FFA500)Обращайтесь в рекламное/агентство', 130, 11, 42, 1, 1, 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `binder`
--

CREATE TABLE `binder` (
  `i` int(11) NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(24) CHARACTER SET cp1251 NOT NULL DEFAULT 'None',
  `enb` int(11) NOT NULL DEFAULT 0,
  `cmd` varchar(32) CHARACTER SET cp1251 NOT NULL DEFAULT 'None',
  `text` varchar(128) CHARACTER SET cp1251 NOT NULL DEFAULT 'None'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `bitcoin`
--

CREATE TABLE `bitcoin` (
  `id` int(11) NOT NULL,
  `sum` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `bitcoin`
--

INSERT INTO `bitcoin` (`id`, `sum`, `date`) VALUES
(1, 16606, '2022-11-24 15:37:03');

-- --------------------------------------------------------

--
-- Структура таблицы `biz`
--

CREATE TABLE `biz` (
  `b_mysql_id` int(11) UNSIGNED NOT NULL,
  `b_user_id` int(11) NOT NULL DEFAULT 0,
  `b_bank` int(11) NOT NULL DEFAULT 0,
  `b_upgrade_warehouse` int(11) NOT NULL DEFAULT 0,
  `b_upgrade_class` int(11) NOT NULL DEFAULT 0,
  `b_upgrade_tax` int(11) NOT NULL DEFAULT 0,
  `b_rent` int(11) NOT NULL DEFAULT 0,
  `b_order` int(11) NOT NULL DEFAULT 0,
  `b_int` int(11) NOT NULL DEFAULT 0,
  `b_world` int(11) NOT NULL DEFAULT 0,
  `b_price` int(11) NOT NULL DEFAULT 0,
  `b_owner` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_name` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_tip` int(11) NOT NULL DEFAULT 0,
  `b_enterX` float NOT NULL DEFAULT 0,
  `b_enterY` float NOT NULL DEFAULT 0,
  `b_enterZ` float NOT NULL DEFAULT 0,
  `b_enterA` float NOT NULL DEFAULT 0,
  `b_exitX` float DEFAULT 0,
  `b_exitY` float NOT NULL DEFAULT 0,
  `b_exitZ` float NOT NULL DEFAULT 0,
  `b_menuX` float NOT NULL DEFAULT 0,
  `b_menuY` float NOT NULL DEFAULT 0,
  `b_menuZ` float NOT NULL DEFAULT 0,
  `b_otherX` float NOT NULL DEFAULT 0,
  `b_otherY` float NOT NULL DEFAULT 0,
  `b_otherZ` float NOT NULL DEFAULT 0,
  `b_prod` int(11) NOT NULL DEFAULT 0,
  `b_lock` int(11) NOT NULL DEFAULT 0,
  `b_till` int(11) NOT NULL DEFAULT 1,
  `b_enter` int(11) NOT NULL DEFAULT 0,
  `b_percent` int(11) NOT NULL DEFAULT 0,
  `b_oil` int(11) NOT NULL DEFAULT 0,
  `b_mafia` int(11) NOT NULL DEFAULT 0,
  `b_fare_1` int(11) NOT NULL DEFAULT 200,
  `b_fare_2` int(11) NOT NULL DEFAULT 250,
  `b_fare_3` int(11) NOT NULL DEFAULT 200,
  `b_fare_4` int(11) NOT NULL DEFAULT 500,
  `b_garden_items` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `b_auction_bet` int(11) NOT NULL DEFAULT 0,
  `b_auction_time` int(11) NOT NULL DEFAULT 0,
  `b_auction_user_id` int(11) NOT NULL DEFAULT 0,
  `b_owned_at` int(11) DEFAULT 0,
  `b_paydays_received` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Бизнесы игроков' ROW_FORMAT=DYNAMIC;

--
-- Дамп данных таблицы `biz`
--

INSERT INTO `biz` (`b_mysql_id`, `b_user_id`, `b_bank`, `b_upgrade_warehouse`, `b_upgrade_class`, `b_upgrade_tax`, `b_rent`, `b_order`, `b_int`, `b_world`, `b_price`, `b_owner`, `b_name`, `b_tip`, `b_enterX`, `b_enterY`, `b_enterZ`, `b_enterA`, `b_exitX`, `b_exitY`, `b_exitZ`, `b_menuX`, `b_menuY`, `b_menuZ`, `b_otherX`, `b_otherY`, `b_otherZ`, `b_prod`, `b_lock`, `b_till`, `b_enter`, `b_percent`, `b_oil`, `b_mafia`, `b_fare_1`, `b_fare_2`, `b_fare_3`, `b_fare_4`, `b_garden_items`, `b_auction_bet`, `b_auction_time`, `b_auction_user_id`, `b_owned_at`, `b_paydays_received`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 6, 0, 3000000, 'The State', 'Супермаркет', 1, 1928.58, -1776.3, 13.5469, 89.6507, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(2, 0, 0, 0, 0, 0, 0, 0, 6, 1, 3000000, 'The State', 'Супермаркет', 1, 1000.6, -919.944, 42.3281, 279.799, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(3, 0, 0, 0, 0, 0, 0, 0, 6, 2, 3000000, 'The State', 'Супермаркет', 1, -78.3926, -1169.94, 2.13542, 246.272, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(4, 0, 0, 0, 0, 0, 0, 0, 6, 3, 2500000, 'The State', 'Супермаркет', 1, -2032.98, 161.458, 29.0461, 88.9775, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(5, 0, 0, 0, 0, 0, 0, 0, 6, 4, 2500000, 'The State', 'Супермаркет', 1, -1676.15, 432.213, 7.17969, 43.857, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(6, 0, 0, 0, 0, 0, 0, 0, 6, 5, 2500000, 'The State', 'Супермаркет', 1, -2420.16, 969.839, 45.2969, 90.2308, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(7, 0, 0, 0, 0, 0, 0, 0, 6, 6, 2000000, 'The State', 'Супермаркет', 1, -145.772, 1172.39, 19.7422, 179.822, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(8, 0, 0, 0, 0, 0, 0, 0, 6, 7, 2000000, 'The State', 'Супермаркет', 1, 663.128, 1716.34, 7.1875, 220.868, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(9, 0, 0, 0, 0, 0, 0, 0, 6, 8, 2000000, 'The State', 'Супермаркет', 1, 1599.1, 2221.84, 11.0625, 44.7969, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(10, 0, 0, 0, 0, 0, 0, 0, 6, 9, 2000000, 'The State', 'Супермаркет', 1, 2187.71, 2469.66, 11.2422, 90.8817, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(11, 0, 0, 0, 0, 0, 0, 0, 6, 10, 2000000, 'The State', 'Супермаркет', 1, 2637.29, 1129.68, 11.1797, 0, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(12, 0, 0, 0, 0, 0, 0, 0, 6, 11, 2000000, 'The State', 'Супермаркет', 1, 2117.49, 896.78, 11.1797, 180.112, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(13, 15, 0, 0, 0, 0, 325, 0, 6, 12, 3000000, 'Amiri_Junk', 'amiri shop ', 1, 1848.33, -1871.7, 13.5781, 270.353, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 500, 0, 1, 0, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1772447348, 1),
(14, 0, 0, 0, 0, 0, 0, 0, 6, 13, 3000000, 'The State', 'Супермаркет', 1, 1081.23, -1696.79, 13.5469, 359.98, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(15, 0, 0, 0, 0, 0, 0, 0, 6, 14, 3000000, 'The State', 'Супермаркет', 1, 1352.37, -1759.25, 13.5078, 179.823, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(16, 0, 0, 0, 0, 0, 0, 0, 6, 15, 3000000, 'The State', 'Супермаркет', 1, 2424.21, -1742.81, 13.5456, 227.229, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(17, 0, 0, 0, 0, 0, 0, 0, 6, 16, 3000000, 'The State', 'Супермаркет', 1, 1836.51, -1445.06, 13.5962, 90.5908, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(18, 0, 0, 0, 0, 0, 0, 0, 6, 17, 3000000, 'The State', 'Супермаркет', 1, 2174.57, -1741.86, 13.5507, 44.5303, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(19, 0, 0, 0, 0, 0, 0, 0, 6, 18, 3000000, 'The State', 'Супермаркет', 1, 1976.65, -2036.65, 13.5469, 269.506, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(20, 0, 0, 0, 0, 0, 0, 0, 6, 19, 3000000, 'The State', 'Супермаркет', 1, 2256.14, -1069.85, 49.4766, 139.158, -26.6362, -57.9207, 1003.85, -23.1813, -55.1033, 1003.55, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(21, 15, 4951000, 1, 0, 1, 325, 24500, 5, 20, 5000000, 'Amiri_Junk', 'Лучший магазин', 2, 461.698, -1500.79, 31.0455, 279.533, 227.563, -8.1, 1002.21, 210.568, -8.2071, 1005.21, 0, 0, 0, 500, 0, 1, 100, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1772448136, 1),
(22, 0, 432, 0, 0, 0, 0, 0, 5, 21, 4000000, 'The State', 'Магазин одежды', 2, -1694.56, 951.9, 24.8906, 313.373, 227.563, -8.1, 1002.21, 210.568, -8.2071, 1005.21, 0, 0, 0, 96, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(23, 0, 0, 0, 0, 0, 0, 0, 5, 22, 3000000, 'The State', 'Магазин одежды', 2, 2802.93, 2430.72, 11.0625, 314.313, 227.563, -8.1, 1002.21, 210.568, -8.2071, 1005.21, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(24, 0, 0, 0, 0, 0, 0, 0, 17, 23, 2000000, 'The State', 'Бар', 3, 1836.96, -1682.49, 13.3262, 269.506, 493.407, -24.82, 1000.68, 499.645, -20.677, 1000.68, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(25, 0, 0, 0, 0, 0, 0, 0, 11, 24, 1500000, 'The State', 'Бар', 3, 2310.02, -1643.47, 14.827, 313.999, 502.014, -67.61, 998.758, 496.488, -75.825, 998.758, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(26, 0, 0, 0, 0, 0, 0, 0, 2, 25, 1000000, 'The State', 'Бар', 3, 2421.54, -1219.24, 25.5616, 358.493, 1204.75, -13.801, 1000.92, 1215.92, -13.11, 1000.92, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(27, 0, 0, 0, 0, 0, 0, 0, 11, 26, 1000000, 'State', 'Бар', 3, -2242.14, -88.1926, 35.3203, 269.506, 502.014, -67.61, 998.758, 496.488, -75.825, 998.758, 0, 0, 0, 500, 0, 1, 0, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1772463111, 5),
(28, 0, 0, 0, 0, 0, 0, 0, 3, 27, 2000000, 'The State', 'Бар', 3, -2624.69, 1412.71, 7.09375, 11.6533, -2636.68, 1402.53, 906.461, -2662.28, 1415.7, 906.273, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(29, 0, 0, 0, 0, 0, 0, 0, 11, 28, 1000000, 'The State', 'Бар', 3, 2507.35, 1242.25, 10.827, 179.918, 502.014, -67.61, 998.758, 496.488, -75.825, 998.758, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(30, 0, 0, 0, 0, 0, 0, 0, 18, 29, 1000000, 'The State', 'Бар', 3, -89.6158, 1378.26, 10.4698, 95.6274, -229.248, 1401.26, 27.766, -224.799, 1403.83, 27.773, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(31, 0, 0, 0, 0, 0, 0, 0, 0, 30, 3000000, 'The State', 'Заправочная станция №30', 4, 1940.22, -1772.86, 13.3906, 271.771, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(32, 0, 0, 0, 0, 0, 0, 0, 0, 31, 3000000, 'The State', 'Заправочная станция №31', 4, 1004.14, -938.12, 42.1797, 11.7975, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(33, 0, 0, 0, 0, 0, 0, 0, 0, 32, 3000000, 'The State', 'Заправочная станция №32', 4, -91.2654, -1169.1, 2.42751, 243.257, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(34, 0, 0, 0, 0, 0, 0, 0, 0, 33, 2500000, 'The State', 'Заправочная станция №33', 4, -2029.64, 156.69, 28.8359, 328.171, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(35, 0, 0, 0, 0, 0, 0, 0, 0, 34, 2500000, 'The State', 'Заправочная станция №34', 4, -1675.8, 413.412, 7.17969, 358.252, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(36, 0, 0, 0, 0, 0, 0, 0, 0, 35, 2500000, 'The State', 'Заправочная станция №35', 4, -2413.16, 976.061, 45.2969, 138.771, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(37, 0, 0, 0, 0, 0, 0, 0, 0, 36, 2000000, 'The State', 'Заправочная станция №36', 4, 611.985, 1695.03, 6.99219, 257.044, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(38, 0, 0, 0, 0, 0, 0, 0, 0, 37, 2000000, 'The State', 'Заправочная станция №37', 4, 70.605, 1218.59, 18.8128, 19.4379, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(39, 0, 0, 0, 0, 0, 0, 0, 0, 38, 2000000, 'The State', 'Заправочная станция №38', 4, 1596.14, 2199.24, 10.8203, 308.286, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(40, 0, 0, 0, 0, 0, 0, 0, 0, 39, 2000000, 'The State', 'Заправочная станция №39', 4, 2202.67, 2474.58, 10.8203, 279.146, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(41, 0, 0, 0, 0, 0, 0, 0, 0, 40, 2000000, 'The State', 'Заправочная станция №40', 4, 2639.79, 1106.15, 10.8203, 174.178, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(42, 0, 0, 0, 0, 0, 0, 0, 0, 41, 2000000, 'The State', 'Заправочная станция №41', 4, 2114.85, 919.925, 10.8203, 119.344, 2063.04, -5745.1, 5006.3, 2063.04, -5745.1, 5006.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(43, 0, 0, 0, 0, 0, 0, 0, 4, 42, 5000000, 'The State', 'Амуниция', 5, 2400.45, -1981.96, 13.5469, 181.53, 285.756, -86.1907, 1001.53, 295.635, -80.363, 1001.53, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(44, 0, 0, 0, 0, 0, 0, 0, 4, 43, 5000000, 'The State', 'Амуниция', 5, 1368.89, -1279.81, 13.5469, 272.06, 285.756, -86.1907, 1001.53, 295.635, -80.363, 1001.53, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(45, 0, 0, 0, 0, 0, 0, 0, 4, 44, 5000000, 'The State', 'Амуниция', 5, -2625.87, 208.235, 4.8125, 180.253, 285.756, -86.1907, 1001.53, 295.635, -80.363, 1001.53, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(46, 0, 0, 0, 0, 0, 0, 0, 4, 45, 5000000, 'The State', 'Амуниция', 5, 2159.49, 943.226, 10.8203, 272.374, 285.756, -86.1907, 1001.53, 295.635, -80.363, 1001.53, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(47, 0, 0, 0, 0, 0, 0, 0, 4, 46, 5000000, 'The State', 'Амуниция', 5, -316.12, 829.888, 14.2422, 88.4453, 285.756, -86.1907, 1001.53, 295.635, -80.363, 1001.53, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(48, 0, 0, 0, 0, 0, 0, 0, 10, 47, 1000000, 'The State', 'Закусочная', 6, 2105.48, -1806.5, 13.5547, 274.399, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(49, 0, 0, 0, 0, 0, 0, 0, 10, 48, 1000000, 'The State', 'Закусочная', 6, 1199.28, -918.156, 43.123, 6.03777, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(50, 0, 0, 0, 0, 0, 0, 0, 10, 49, 1000000, 'The State', 'Закусочная', 6, 810.517, -1616.2, 13.5469, 90.3252, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(51, 0, 0, 0, 0, 0, 0, 0, 10, 50, 750000, 'The State', 'Закусочная', 6, -2355.86, 1008.06, 50.8984, 270.784, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(52, 0, 0, 0, 0, 0, 0, 0, 10, 51, 750000, 'The State', 'Закусочная', 6, -2336.85, -166.824, 35.5547, 87.5052, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(53, 0, 0, 0, 0, 0, 0, 0, 10, 52, 750000, 'The State', 'Закусочная', 6, -1816.55, 618.675, 35.1719, 3.53108, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(54, 0, 0, 0, 0, 0, 0, 0, 10, 53, 500000, 'The State', 'Закусочная', 6, 1157.94, 2072.28, 11.0625, 91.892, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(55, 0, 0, 0, 0, 0, 0, 0, 10, 54, 500000, 'The State', 'Закусочная', 6, 1872.32, 2071.87, 11.0625, 91.5786, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(56, 0, 0, 0, 0, 0, 0, 0, 10, 55, 500000, 'The State', 'Закусочная', 6, 2330.65, 2533.58, 10.8203, 2.90448, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(57, 0, 0, 0, 0, 0, 0, 0, 10, 56, 500000, 'The State', 'Закусочная', 6, 173.021, 1177.12, 14.7578, 324.677, 363.235, -74.855, 1001.51, 376.652, -67.8214, 1001.52, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(58, 0, 0, 0, 0, 0, 0, 0, 10, 57, 5000000, 'The State', 'Риелторское агентство', 7, 811.681, -1062.05, 24.9523, 195.583, -1170.16, 640.749, 1052.48, -1161.24, 640.477, 1052.38, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(59, 0, 0, 0, 0, 0, 0, 0, 5, 58, 3000000, 'The State', 'Спортзал', 8, 2229.89, -1721.32, 13.5619, 318.411, 772.259, -5.474, 1000.73, 757.363, 5.674, 1000.7, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(60, 0, 0, 0, 0, 0, 0, 0, 5, 59, 2500000, 'The State', 'Спортзал', 8, -2270.64, -155.968, 35.3203, 90.1569, 772.259, -5.474, 1000.73, 757.363, 5.674, 1000.7, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(61, 0, 0, 0, 0, 0, 0, 0, 5, 60, 2000000, 'The State', 'Спортзал', 8, 1968.77, 2295.79, 16.4559, 3.98939, 772.259, -5.474, 1000.73, 757.363, 5.674, 1000.7, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(62, 0, 8000, 0, 0, 0, 0, 0, 12, 61, 5000000, 'The State', 'Магазин аксессуаров', 9, 776.379, -1036.23, 24.274, 12.7627, 411.979, -54.3839, 1001.9, 412.079, -49.659, 1001.9, 0, 0, 0, 20, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(63, 0, 0, 0, 0, 0, 0, 0, 15, 62, 1500000, 'The State', 'Отель', 10, 325.427, -1515.44, 36.0325, 51.4476, 2214.43, -1150.46, 1025.8, 2217.41, -1146.41, 1025.8, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(64, 0, 0, 0, 0, 0, 0, 0, 15, 63, 1500000, 'The State', 'Отель', 10, 1217.31, -1692.6, 19.7344, 272.494, 2214.43, -1150.46, 1025.8, 2217.41, -1146.41, 1025.8, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(65, 0, 2250, 0, 0, 0, 0, 0, 15, 64, 1500000, 'The State', 'Отель', 10, 2233.29, -1159.81, 25.8906, 269.867, 2214.43, -1150.46, 1025.8, 2217.41, -1146.41, 1025.8, 0, 0, 0, 75, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(66, 0, 0, 0, 0, 0, 0, 0, 15, 65, 1000000, 'The State', 'Отель', 10, -2426.21, 338.072, 36.9922, 62.7752, 2214.43, -1150.46, 1025.8, 2217.41, -1146.41, 1025.8, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(67, 0, 0, 0, 0, 0, 0, 0, 15, 66, 1000000, 'The State', 'Отель', 10, 1965.06, 1623.2, 12.8622, 91.9155, 2214.43, -1150.46, 1025.8, 2217.41, -1146.41, 1025.8, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(68, 0, 0, 0, 0, 0, 0, 0, 3, 67, 5000000, 'The State', 'Садовый центр', 11, -2579.43, 310.064, 5.17969, 268.252, 1494.39, 1303.58, 1093.29, 1490.42, 1305.72, 1093.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(69, 0, 0, 0, 0, 0, 0, 0, 1, 4, 100000000, 'The State', 'Автосалон', 12, 2204.37, 1818.49, 10.9985, 0.0105, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(70, 0, 0, 0, 0, 0, 0, 0, 1, 3, 100000000, 'The State', 'Автосалон', 12, -1952.65, 305.986, 35.4688, 320.24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(71, 0, 0, 0, 0, 0, 0, 0, 1, 2, 100000000, 'The State', 'Автосалон', 12, -2695.81, -51.2147, 4.3359, 179.552, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(72, 0, 0, 0, 0, 0, 0, 0, 1, 1, 100000000, 'The State', 'Автосалон', 12, 1626.28, -1137.52, 23.9063, 180.806, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(73, 0, 0, 0, 0, 0, 0, 0, 1, 5, 100000000, 'The State', 'Автосалон', 12, 2131.88, -1150.92, 24.1046, 1.1574, 1308.63, -50.7176, 2002.5, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2500000, 'The State', 'Автосервис', 13, 2073.1, -1831.37, 13.5469, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2500000, 'The State', 'Автосервис', 13, 488.454, -1732.63, 11.1931, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2500000, 'The State', 'Автосервис', 13, 1025.02, -1031.94, 31.9452, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(77, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2000000, 'The State', 'Автосервис', 13, -1904.35, 275.887, 41.0469, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1500000, 'The State', 'Автосервис', 13, -2425.73, 1029.91, 50.3906, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(79, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000000, 'The State', 'Автосервис', 13, -99.9069, 1109.74, 19.7422, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000000, 'The State', 'Автосервис', 13, 1966.43, 2162.29, 10.8203, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №80', 14, -2034.76, -64.228, 35.3203, 1.6637, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №81', 14, 2661.89, -2386.33, 13.6663, 90.6142, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'State', 'Ларек с едой №82', 14, 2031.79, 1001.69, 10.8131, 91.2778, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500, 0, 1, 0, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1772462517, 1),
(84, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №83', 14, 2185.85, 1683.73, 11.0954, 272.049, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №84', 14, 1142.89, -1426.86, 15.7969, 269.229, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №85', 14, 1033.47, -1963.96, 13.1011, 268.879, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(87, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №86', 14, 1189.82, -1331.9, 13.5688, 92.8212, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №87', 14, -2668.54, 636.091, 14.4531, 0.7003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №88', 14, 1633.24, 1825.67, 10.8203, 271.049, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №89', 14, 1162.01, -1734.84, 13.7734, 0.9436, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(91, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №90', 14, -1985.74, 126.997, 27.6875, 271.049, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(92, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №91', 14, 2826.79, 1299.37, 10.7676, 93.041, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500000, 'The State', 'Ларек с едой №92', 14, 1804.88, -1745.95, 13.5491, 359.747, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(94, 0, 0, 0, 0, 0, 0, 0, 1, 93, 2500000, 'The State', 'Магазин рыбака №93', 15, -2798.27, 1317.47, 7.6983, 177.82, 2153.49, 1828.56, 1021.7, 2154.32, 1818.11, 1021.7, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(95, 0, 0, 0, 0, 0, 0, 0, 3, 94, 2500000, 'The State', 'Рекламное агентство', 16, 1247.98, -1559.94, 13.5634, 0.907413, 1494.39, 1303.58, 1093.29, 1490.42, 1305.72, 1093.3, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(96, 0, 0, 0, 0, 0, 0, 0, 3, 95, 2500000, 'The State', 'Мастерская одежды', 17, 1073.23, -1384.87, 13.8698, 314.522, 1494.39, 1303.58, 1093.29, 1490.42, 1305.72, 1093.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(97, 15, 450, 0, 0, 0, 325, 0, 0, 96, 500000, 'Amiri_Junk', 'Ларек с едой №96', 14, 1772.84, -1888.2, 13.5708, 90.9808, 0, 0, 0, 0, 0, 0, 0, 0, 0, 495, 0, 1, 0, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1772447467, 1),
(98, 0, 0, 0, 0, 0, 0, 0, 3, 98, 10000000, 'The State', 'Магазин солнечных панел', 18, 1004.22, -1430.84, 13.5469, 357.338, 1494.39, 1303.58, 1093.29, 1490.42, 1305.72, 1093.3, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(99, 0, 0, 1, 0, 1, 0, 0, 1, 99, 10000000, 'State', 'Магазин видеокарт', 19, 1418.92, -1553.69, 13.5625, 90.9275, 1351.25, 1583.88, 1010.9, 1359.34, 1583.83, 1010.79, 0, 0, 0, 500, 0, 1, 0, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1772458472, 1),
(100, 0, 0, 0, 0, 0, 0, 0, 0, 100, 10000000, 'The State', 'Электростанция', 20, 2357.79, -2106.87, 13.8104, 87.7961, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(101, 0, 0, 0, 0, 0, 0, 0, 0, 101, 10000000, 'The State', 'Электростанция', 20, -1899.09, -190.258, 23.3327, 1.07228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(102, 0, 0, 0, 0, 0, 0, 0, 0, 102, 10000000, 'The State', 'Электростанция', 20, 1988.91, 2605.19, 11.0338, 181.554, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(103, 0, 300, 0, 0, 0, 0, 0, 0, 103, 25000000, 'The State', 'Тюнинг центр', 22, -2089.12, 84.2703, 35.3134, 271.108, 0, 0, 0, 0, 0, 0, 0, 0, 0, 96, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(104, 0, 0, 0, 0, 0, 0, 0, 0, 104, 25000000, 'The State', 'Тюнинг центр', 22, -1799.94, 1200.37, 25.1194, 1.03571, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(105, 0, 0, 0, 0, 0, 0, 0, 3, 105, 5000000, 'The State', 'Таксопарк', 23, 1274.26, -1802.19, 13.3915, 359.231, 1494.39, 1303.58, 1093.29, 1490.28, 1305.34, 1093.3, 1492.8, 1308.48, 1093.29, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(106, 0, 0, 0, 0, 0, 0, 0, 3, 106, 5000000, 'The State', 'Таксопарк', 23, -2202.92, 298.249, 35.1172, 181.883, 1494.39, 1303.58, 1093.29, 1490.28, 1305.34, 1093.3, 1492.8, 1308.48, 1093.29, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(107, 0, 0, 0, 0, 0, 0, 0, 3, 107, 5000000, 'The State', 'Таксопарк', 23, 2822.39, 1519.42, 10.9081, 90.4122, 1494.39, 1303.58, 1093.29, 1490.28, 1305.34, 1093.3, 1492.8, 1308.48, 1093.29, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(108, 0, 2530, 0, 0, 0, 0, 0, 3, 108, 10000000, 'The State', 'Транспортная компания', 24, -478.446, -513.438, 25.5178, 268.99, 1494.39, 1303.58, 1093.29, 1490.28, 1305.34, 1093.3, 1492.8, 1308.48, 1093.29, 69, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(109, 0, 0, 0, 0, 0, 0, 0, 3, 109, 10000000, 'The State', 'Транспортная компания', 24, -229.097, -251.117, 1.42188, 125.482, 1494.39, 1303.58, 1093.29, 1490.28, 1305.34, 1093.3, 1492.8, 1308.48, 1093.29, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(110, 0, 0, 0, 0, 0, 0, 0, 3, 110, 10000000, 'The State', 'Транспортная компания', 24, 58.7898, -263.999, 1.57812, 175.93, 1494.39, 1303.58, 1093.29, 1490.28, 1305.34, 1093.3, 1492.8, 1308.48, 1093.29, 100, 0, 1, 0, 10, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(111, 0, 0, 0, 0, 0, 0, 0, 1, 111, 25000000, 'The State', 'Биржа труда', 21, 1498.48, -1580.52, 13.5498, 0, 2333.8, 1586.46, 1010.81, 2349.87, 1586.4, 1010.81, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(112, 0, 0, 0, 0, 0, 0, 0, 0, 112, 200000000, 'The State', 'Нефтебаза', 25, 2289.58, 552.711, 7.78125, 180.125, 0, 0, 0, 0, 0, 0, 2325.4, 561.541, 7.7813, 100, 0, 1, 0, 0, 0, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(113, 0, 0, 0, 0, 0, 0, 0, 0, 113, 100000000, 'The State', 'Нефтевышка', 26, -83.3752, 407.701, 8.86565, 359.98, 0, 0, 0, 0, 0, 0, -79.9286, 380.793, 8.9021, 100, 0, 1, 0, 0, 100000, 0, 100, 125, 100, 250, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(114, 0, 0, 0, 0, 0, 0, 0, 0, 114, 100000000, 'The State', 'Нефтевышка', 26, 3042.89, 2536.62, 9.6449, 1.23385, 0, 0, 0, 0, 0, 0, 3046.21, 2509.7, 9.6813, 100, 0, 1, 0, 0, 100000, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(115, 0, 0, 0, 0, 0, 0, 0, 0, 115, 100000000, 'The State', 'Нефтевышка', 26, 3075.69, -1383.4, 9.68375, 1.5941, 0, 0, 0, 0, 0, 0, 3079.11, -1410.35, 9.7202, 100, 0, 1, 0, 0, 100000, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(116, 0, 9000, 0, 0, 0, 0, 0, 0, 116, 50000000, 'The State', 'Аренда транспорта', 27, 561.073, -1256.83, 17.2422, 285.196, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(117, 0, 0, 0, 0, 0, 0, 0, 0, 117, 50000000, 'The State', 'Аренда транспорта', 27, -1980.14, 278.144, 35.1719, 90.2771, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(118, 0, 0, 0, 0, 0, 0, 0, 0, 118, 50000000, 'State', 'Аренда транспорта', 27, 2116.38, 1386.07, 10.8203, 179.265, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500, 0, 1, 0, 10, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 1772464876, 1),
(119, 0, 0, 0, 0, 0, 0, 0, 0, 119, 50000000, 'The State', 'Нефтевышка', 26, 353.356, 1313.75, 12.4766, 179.555, 0, 0, 0, 0, 0, 0, 353.81, 1299.65, 13.3625, 100, 0, 1, 0, 0, 100000, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(120, 0, 0, 0, 0, 0, 0, 0, 0, 120, 50000000, 'The State', 'Нефтевышка', 26, 627.835, 1366.17, 11.9868, 180.181, 0, 0, 0, 0, 0, 0, 628.319, 1352.02, 13.1828, 100, 0, 1, 0, 0, 100000, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(121, 0, 0, 0, 0, 0, 0, 0, 0, 121, 50000000, 'The State', 'Нефтевышка', 26, 433.574, 1577.73, 11.4922, 181.435, 0, 0, 0, 0, 0, 0, 434.114, 1563.57, 12.7844, 100, 0, 1, 0, 0, 100000, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0),
(122, 0, 0, 0, 0, 0, 0, 0, 1, 122, 10000000, 'The State', 'Прачечная', 28, 1046.95, -1419.08, 13.5469, 135.758, 1854.03, -408.82, 1010.88, 1859.91, -410.974, 1010.88, 0, 0, 0, 100, 0, 1, 0, 0, 0, 0, 200, 250, 200, 500, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `bizz_finka`
--

CREATE TABLE `bizz_finka` (
  `bizz_id` int(11) NOT NULL DEFAULT 0,
  `day_1` int(11) NOT NULL DEFAULT 0,
  `day_2` int(11) NOT NULL DEFAULT 0,
  `day_3` int(11) NOT NULL DEFAULT 0,
  `day_4` int(11) NOT NULL DEFAULT 0,
  `day_5` int(11) NOT NULL DEFAULT 0,
  `day_6` int(11) NOT NULL DEFAULT 0,
  `day_7` int(11) NOT NULL DEFAULT 0,
  `day_clear` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `bizz_finka`
--

INSERT INTO `bizz_finka` (`bizz_id`, `day_1`, `day_2`, `day_3`, `day_4`, `day_5`, `day_6`, `day_7`, `day_clear`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 0, 0, 0, 0, 0, 0, 0, 0),
(13, 0, 0, 0, 0, 10000, 0, 0, 0),
(14, 0, 0, 0, 0, 0, 0, 0, 0),
(15, 0, 0, 0, 0, 0, 0, 0, 0),
(16, 0, 0, 0, 0, 0, 0, 0, 0),
(17, 0, 0, 0, 0, 0, 0, 0, 0),
(18, 0, 0, 0, 0, 0, 0, 0, 0),
(19, 0, 0, 0, 0, 0, 0, 0, 0),
(20, 0, 0, 0, 0, 0, 0, 0, 0),
(21, 0, 0, 0, 0, 0, 0, 0, 0),
(22, 756, 0, 0, 0, 324, 0, 0, 0),
(23, 0, 0, 0, 0, 0, 0, 0, 0),
(24, 0, 0, 0, 0, 0, 0, 0, 0),
(25, 0, 0, 0, 0, 0, 0, 0, 0),
(26, 0, 0, 0, 0, 0, 0, 0, 0),
(27, 0, 0, 0, 0, 0, 0, 0, 0),
(28, 0, 0, 0, 0, 0, 0, 0, 0),
(29, 0, 0, 0, 0, 0, 0, 0, 0),
(30, 0, 0, 0, 0, 0, 0, 0, 0),
(31, 0, 0, 0, 0, 0, 0, 0, 0),
(32, 0, 0, 0, 0, 0, 0, 0, 0),
(33, 0, 0, 0, 0, 0, 0, 0, 0),
(34, 0, 0, 0, 0, 0, 0, 0, 0),
(35, 0, 0, 0, 0, 0, 0, 0, 0),
(36, 0, 0, 0, 0, 0, 0, 0, 0),
(37, 0, 0, 0, 0, 0, 0, 0, 0),
(38, 0, 0, 0, 0, 0, 0, 0, 0),
(39, 0, 0, 0, 0, 0, 0, 0, 0),
(40, 0, 0, 0, 0, 0, 0, 0, 0),
(41, 0, 0, 0, 0, 0, 0, 0, 0),
(42, 0, 0, 0, 0, 0, 0, 0, 0),
(43, 0, 0, 0, 0, 0, 0, 0, 0),
(44, 0, 0, 0, 0, 0, 0, 0, 0),
(45, 0, 0, 0, 0, 0, 0, 0, 0),
(46, 0, 0, 0, 0, 0, 0, 0, 0),
(47, 0, 0, 0, 0, 0, 0, 0, 0),
(48, 0, 0, 0, 0, 0, 0, 0, 0),
(49, 0, 0, 0, 0, 0, 0, 0, 0),
(50, 0, 0, 0, 0, 0, 0, 0, 0),
(51, 0, 0, 0, 0, 0, 0, 0, 0),
(52, 0, 0, 0, 0, 0, 0, 0, 0),
(53, 0, 0, 0, 0, 0, 0, 0, 0),
(54, 0, 0, 0, 0, 0, 0, 0, 0),
(55, 0, 0, 0, 0, 0, 0, 0, 0),
(56, 0, 0, 0, 0, 0, 0, 0, 0),
(57, 0, 0, 0, 0, 0, 0, 0, 0),
(58, 0, 0, 0, 0, 0, 0, 0, 0),
(59, 0, 0, 0, 0, 0, 0, 0, 0),
(60, 0, 0, 0, 0, 0, 0, 0, 0),
(61, 0, 0, 0, 0, 0, 0, 0, 0),
(62, 0, 8000, 0, 0, 0, 0, 0, 0),
(63, 0, 0, 0, 0, 0, 0, 0, 0),
(64, 0, 0, 0, 0, 0, 0, 0, 0),
(65, 0, 2250, 0, 0, 0, 0, 0, 0),
(66, 0, 0, 0, 0, 0, 0, 0, 0),
(67, 0, 0, 0, 0, 0, 0, 0, 0),
(68, 0, 0, 0, 0, 0, 0, 0, 0),
(69, 0, 0, 0, 0, 0, 0, 0, 0),
(70, 0, 0, 0, 0, 0, 0, 0, 0),
(71, 0, 0, 0, 0, 0, 0, 0, 0),
(72, 0, 0, 0, 0, 0, 0, 0, 0),
(73, 0, 0, 0, 0, 0, 0, 0, 0),
(74, 0, 0, 0, 0, 0, 0, 0, 0),
(75, 0, 0, 0, 0, 0, 0, 0, 0),
(76, 0, 0, 0, 0, 0, 0, 0, 0),
(77, 0, 0, 0, 0, 0, 0, 0, 0),
(78, 0, 0, 0, 0, 0, 0, 0, 0),
(79, 0, 0, 0, 0, 0, 0, 0, 0),
(80, 0, 0, 0, 0, 0, 0, 0, 0),
(81, 0, 0, 0, 0, 0, 0, 0, 0),
(82, 0, 0, 0, 0, 0, 0, 0, 0),
(83, 0, 0, 0, 0, 0, 0, 0, 0),
(84, 0, 0, 0, 0, 0, 0, 0, 0),
(85, 0, 0, 0, 0, 0, 0, 0, 0),
(86, 0, 0, 0, 0, 0, 0, 0, 0),
(87, 0, 0, 0, 0, 0, 0, 0, 0),
(88, 0, 0, 0, 0, 0, 0, 0, 0),
(89, 0, 0, 0, 0, 0, 0, 0, 0),
(90, 0, 0, 0, 0, 0, 0, 0, 0),
(91, 0, 0, 0, 0, 0, 0, 0, 0),
(92, 0, 0, 0, 0, 0, 0, 0, 0),
(93, 0, 0, 0, 0, 0, 0, 0, 0),
(94, 0, 0, 0, 0, 0, 0, 0, 0),
(95, 0, 0, 0, 0, 0, 0, 0, 0),
(96, 0, 0, 0, 0, 0, 0, 0, 0),
(97, 0, 0, 0, 0, 0, 450, 0, 0),
(98, 0, 0, 0, 0, 0, 0, 0, 0),
(99, 0, 0, 0, 0, 36000, 0, 0, 0),
(100, 0, 0, 0, 0, 0, 0, 0, 0),
(101, 0, 0, 0, 0, 0, 0, 0, 0),
(102, 0, 0, 0, 0, 0, 0, 0, 0),
(103, 6900, 300, 0, 0, 0, 0, 0, 0),
(104, 0, 0, 0, 0, 0, 0, 0, 0),
(105, 0, 0, 0, 0, 0, 0, 0, 0),
(106, 0, 0, 0, 0, 0, 0, 0, 0),
(107, 0, 0, 0, 0, 0, 0, 0, 0),
(108, 0, 0, 0, 0, 3150, 0, 0, 0),
(109, 0, 0, 0, 0, 0, 0, 0, 0),
(110, 0, 0, 0, 0, 0, 0, 0, 0),
(111, 0, 0, 0, 0, 0, 0, 0, 0),
(112, 0, 0, 0, 0, 0, 0, 0, 0),
(113, 0, 0, 0, 0, 0, 0, 0, 0),
(114, 0, 0, 0, 0, 0, 0, 0, 0),
(115, 0, 0, 0, 0, 0, 0, 0, 0),
(111, 0, 0, 0, 0, 0, 0, 0, 0),
(112, 0, 0, 0, 0, 0, 0, 0, 0),
(113, 0, 0, 0, 0, 0, 0, 0, 0),
(114, 0, 0, 0, 0, 0, 0, 0, 0),
(115, 0, 0, 0, 0, 0, 0, 0, 0),
(111, 0, 0, 0, 0, 0, 0, 0, 0),
(112, 0, 0, 0, 0, 0, 0, 0, 0),
(113, 0, 0, 0, 0, 0, 0, 0, 0),
(114, 0, 0, 0, 0, 0, 0, 0, 0),
(115, 0, 0, 0, 0, 0, 0, 0, 0),
(116, 9000, 0, 0, 0, 0, 0, 0, 0),
(117, 0, 0, 0, 0, 0, 0, 0, 0),
(118, 0, 0, 0, 0, 0, 0, 0, 0),
(116, 9000, 0, 0, 0, 0, 0, 0, 0),
(117, 0, 0, 0, 0, 0, 0, 0, 0),
(118, 0, 0, 0, 0, 0, 0, 0, 0),
(116, 9000, 0, 0, 0, 0, 0, 0, 0),
(117, 0, 0, 0, 0, 0, 0, 0, 0),
(118, 0, 0, 0, 0, 0, 0, 0, 0),
(116, 9000, 0, 0, 0, 0, 0, 0, 0),
(117, 0, 0, 0, 0, 0, 0, 0, 0),
(118, 0, 0, 0, 0, 0, 0, 0, 0),
(116, 9000, 0, 0, 0, 0, 0, 0, 0),
(117, 0, 0, 0, 0, 0, 0, 0, 0),
(118, 0, 0, 0, 0, 0, 0, 0, 0),
(119, 0, 0, 0, 0, 0, 0, 0, 0),
(120, 0, 0, 0, 0, 0, 0, 0, 0),
(121, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `box_coords`
--

CREATE TABLE `box_coords` (
  `id` int(11) NOT NULL,
  `x` float DEFAULT 0,
  `y` float DEFAULT 0,
  `z` float DEFAULT 0,
  `r` float DEFAULT 0,
  `status` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `box_coords`
--

INSERT INTO `box_coords` (`id`, `x`, `y`, `z`, `r`, `status`) VALUES
(1, 2770.7, -2564.99, 3, 90.5424, 0),
(2, -2637.86, -199.411, 4.33594, 271.235, 0),
(3, 2831.08, 990.217, 10.75, 179.907, 0),
(4, 2802.64, -2443.79, 13.63, 180.376, 0),
(5, 2870.22, 858.199, 10.75, 89.9013, 0),
(6, -2651.97, -155.574, 4.33625, 180.518, 0),
(7, 2798.74, -2376.87, 13.631, 179.782, 1),
(8, -2758.69, 92.2637, 7.03125, 177.385, 0),
(9, 2789.12, 1237.03, 10.75, 90.1205, 0),
(10, 2750.97, -2187.37, 13.5469, 269.002, 0),
(11, -2769.8, 224.996, 7.1875, 89.1284, 0),
(12, 2763.25, 1444.41, 10.7711, 1.05481, 0),
(13, 2768.01, -2087.3, 12.0615, 88.8754, 0),
(14, -2620.31, 187.321, 4.34219, 89.9875, 0),
(15, 2817.62, 1670.34, 10.8203, 180.886, 0),
(16, 2794.01, -1941.51, 17.3129, 90.7692, 0),
(17, -2535.03, 207.464, 11.0938, 294.7, 0),
(18, 2821.65, 1636.31, 10.8203, 180.431, 0),
(19, 2810.59, 2056.29, 10.7754, 0.920686, 0),
(20, 2928.28, 2102.97, 17.8955, 90.339, 0),
(21, -2660.42, 228.394, 4.33594, 270.156, 0),
(22, 2768.29, -1623.25, 10.9272, 179.956, 0),
(23, 2876.92, 2520.39, 11.0625, 224.917, 0),
(24, 2825.97, -1443.5, 16.25, 359.676, 0),
(25, 2842.11, -1347.8, 11.0625, 0.515862, 0),
(26, -2538.76, 33.6824, 8.60606, 180.518, 0),
(27, 2805.93, 2577.11, 10.8203, 314.979, 0),
(28, 2803.66, -1196.61, 25.4688, 358.746, 0),
(29, -2456.47, -96.2774, 25.9909, 359.63, 1),
(30, 2791.7, -1101.07, 30.7188, 0.709416, 0),
(31, -2463.6, -0.10725, 27.9447, 180.472, 0),
(32, 2742.73, 2778.02, 10.8203, 270.784, 0),
(33, -2617.16, 383.444, 4.28393, 0.455425, 0),
(34, 2674.54, 2738.2, 10.8203, 180.997, 0),
(35, 2673.66, 2843.56, 10.8203, 270.807, 0),
(36, 2506.23, 2844.93, 10.8203, 90.6773, 0),
(37, 2667.64, -1106.17, 69.3817, 90.7537, 0),
(38, 2767.23, -1302.16, 40.729, 179.252, 0),
(39, 2325.99, 2783.96, 10.8203, 271.565, 1),
(40, 2768.75, -1360.48, 39.7259, 180.234, 0),
(41, -2487.82, 383.841, 27.7656, 52.5724, 1),
(42, 2752.56, -1425.88, 16.25, 270.856, 0),
(43, 2782.75, -1465.78, 30.4531, 180.04, 0),
(44, -2208.78, -23.0907, 35.3203, 269.633, 0),
(45, 2635.05, -1972.18, 13.5469, 270.016, 0),
(46, 2155.95, 2833.9, 10.8203, 179.626, 0),
(47, 2648.75, -2050.78, 13.55, 89.7355, 0),
(48, 1987.96, 2785.53, 10.8203, 89.1493, 0),
(49, 1844.24, 2840.53, 10.8359, 1.12518, 0),
(50, -2222.2, 147.644, 35.3203, 90.1724, 0),
(51, 1547.52, 2862.12, 10.8203, 271.08, 0),
(52, -2204.65, 365.903, 35.3203, 269.482, 1),
(53, 2665.21, -2091.64, 13.5469, 181.094, 0),
(54, 1425.01, 2807.94, 10.8203, 270.688, 0),
(55, 2645.52, -2191.46, 13.5469, 180.726, 0),
(56, -2889.72, 723.331, 29.1719, 4.52705, 0),
(57, 2694.3, 824.632, 10.9545, 91.2873, 0),
(58, 2675.97, 863.548, 10.9395, 269.497, 0),
(59, 2657.31, -2235.95, 13.5469, 270.857, 0),
(60, 2636.62, -2457.96, 3, 88.9294, 0),
(61, 2557.76, 797.143, 5.3158, 180.376, 1),
(62, 2515.25, -2450.19, 13.626, 134.95, 0),
(63, -2730.18, 735.561, 39.7188, 179.137, 0),
(64, 2538.75, -2531.96, 13.6242, 90.9632, 0),
(65, 2659.19, 1968.82, 10.8202, 91.9835, 0),
(66, 2597.71, -2125.65, 0.54405, 89.6835, 0),
(67, 2575.7, 2080.42, 10.8203, 180.853, 0),
(68, -2511.75, 777.846, 35.1719, 89.9869, 0),
(69, 2547.08, -2044.22, 4.34319, 89.0696, 0),
(70, 2553.9, -1929.98, 3.85938, 179.324, 1),
(71, -2549.8, 1231.91, 37.4219, 180.331, 0),
(72, 2549.13, -1730.59, 6.24219, 180.375, 0),
(73, 2657.13, 2268.43, 10.8203, 181.591, 0),
(74, -2317.19, 1030.28, 50.6953, 359.828, 0),
(75, 2626.46, 2419.83, 10.8203, 90.3716, 0),
(76, -2710.18, 1458.32, 7.10701, 270.156, 0),
(77, 2488.1, 2393.78, 4.21094, 270.837, 0),
(78, -2182.6, 1216.91, 33.9297, 270.678, 0),
(79, 2407.05, 2577.38, 10.8203, 76.3729, 0),
(80, 2404.77, 2525.21, 21.875, 271.268, 1),
(81, 2215.91, 680.12, 11.4609, 90.6689, 0),
(82, 2202.55, 942.453, 10.8203, 91.0998, 0),
(83, -2187.28, -270.912, 35.3203, 89.9869, 0),
(84, 2549.67, -1289.33, 41.1641, 89.2114, 1),
(85, 2541.5, -1228.8, 43.6562, 359.89, 0),
(86, -2135.7, 157.902, 35.3162, 270.155, 0),
(87, -2040.49, 306.464, 35.2206, 358.412, 0),
(88, 2482.71, -1130.78, 39.1418, 0.360452, 0),
(89, -1983.78, 483.068, 29.0156, 179.96, 1),
(90, 2239.79, 1043.52, 10.8203, 153.65, 0),
(91, 2243.59, 1129.7, 10.8203, 334.343, 0),
(92, 2532.14, -956.338, 82.3653, 276.489, 1),
(93, -2082.34, 999.746, 62.9219, 269.447, 0),
(94, 2412.05, 1294.32, 7.16406, 1.69674, 0),
(95, -1496.65, 1290.51, 7.17569, 180.147, 0),
(96, -1482.38, 688.48, 1.32031, 179.96, 0),
(97, 2267.94, 1509.02, 10.8203, 181.129, 0),
(98, 2474.75, -1339.98, 27.5436, 180.134, 1),
(99, 2283.53, 1718.34, 11.0469, 180.996, 0),
(100, -1802.65, 752.455, 24.8906, 179.777, 0),
(101, 2473.72, -1464.66, 24.0105, 269.897, 0),
(102, 2299.7, 1872.38, 10.8203, 179.956, 0),
(103, 2295.97, 1985.02, 9.86713, 91.6716, 0),
(104, 2442.57, -1553.63, 23.9999, 183.447, 0),
(105, 2344.31, 2250.96, 8.14062, 270.148, 0),
(106, -1667.64, 453.316, 7.1875, 314.696, 0),
(107, 2534.8, 2536.67, 10.8203, 1.43899, 0),
(108, 1897.99, 663.673, 10.8203, 269.545, 0),
(109, 2535.27, -1660.04, 15.2303, 179.427, 0),
(110, -1630.45, -45.3494, 3.55496, 224.908, 0),
(111, 2514.1, -1712.72, 13.5054, 269.874, 1),
(112, 1951.44, 1345.71, 15.3746, 181.661, 0),
(113, -1826.04, -149.806, 9.39844, 180.518, 0),
(114, 1867.22, 1318.8, 16.9223, 181.057, 0),
(115, 1887.1, 1402.07, 9.2501, 90.801, 0),
(116, 1940.94, 1568.67, 10.7022, 1.79755, 0),
(117, 2441.49, -1762.16, 13.5893, 181.565, 0),
(118, 1918.67, 1747.4, 12.7144, 359.095, 0),
(119, -1889.74, -208.494, 18.3964, 180.181, 0),
(120, 2421.74, -1826.29, 9.27344, 90.6274, 1),
(121, 1584.25, 2403.12, 10.8552, 270.835, 0),
(122, -1996.43, -496.396, 35.5406, 270.704, 0),
(123, 1567.81, 2102.13, 10.8203, 182.098, 0),
(124, 2473.45, -1901.79, 13.5469, 268.804, 0),
(125, -2489.98, -719.18, 139.32, 269.996, 0),
(126, 2501.75, -1958.44, 16.7578, 90.0669, 0),
(127, 1621.07, 747.633, 10.8203, 181.197, 0),
(128, -1952.31, -1087.13, 30.7734, 180, 0),
(129, 1757.05, 765.813, 10.8203, 1.06826, 1),
(130, -1151.82, -104.772, 14.144, 224.899, 0),
(131, 1596.84, 988.339, 10.8094, 270.71, 1),
(132, 1630.5, 1040.7, 10.8203, 271, 0),
(133, 1745.89, 1089.13, 10.7441, 180.977, 1),
(134, 2470.54, -2035.67, 13.5469, 90.2419, 0),
(135, 2523.11, -2132.58, 17.2712, 91.5395, 0),
(136, 1326.37, 1529.56, 10.8203, 269.824, 0),
(137, 1286.4, 1649.93, 10.8203, 270.944, 0),
(138, 1578.36, 1681.28, 10.8203, 181.251, 0),
(139, 1390.78, 2179.85, 11.0234, 271.507, 0),
(140, 2429.06, -2212.52, 13.5469, 292.211, 0),
(141, -1501.75, -657.37, 14.1484, 87.0396, 0),
(142, 2492.94, -2360.24, 13.625, 314.669, 0),
(143, 1375.83, 2310.63, 10.8203, 359.382, 0),
(144, 2552.63, -2456.47, 17.8828, 45.362, 0),
(145, -1908.48, 300.987, 41.0469, 179.288, 0),
(146, 1463.81, 1053.08, 10.8203, 181.618, 0),
(147, 2478.23, -2481.55, 17.8828, 134.581, 0),
(148, 1474.28, 936.196, 10.8203, 91.5728, 0),
(149, 2390.75, -2495.73, 13.6465, 224.028, 0),
(150, -2201.14, 616.969, 35.1641, 89.9876, 0),
(151, 2423.03, -2492.85, 13.6429, 300.239, 1),
(152, -2208.44, 698.231, 49.4375, 180.695, 1),
(153, 2412.04, -2630.93, 13.6841, 0.49614, 0),
(154, 2395.07, -2685.01, 13.6535, 90.575, 1),
(155, -2443.03, 1023.78, 50.3906, 0.155766, 0),
(156, 1649.1, 2250.04, 11.0701, 271.464, 0),
(157, 1662.44, 2287.08, 10.8203, 90.5743, 0),
(158, 1738.25, 2292.6, 10.8203, 181.731, 0),
(159, 1873.05, 2385.06, 10.9799, 271.847, 0),
(160, 1986.46, 2332, 10.8203, 91.0752, 0),
(161, 1401.97, 2221.78, 11.0234, 236.214, 0),
(162, 1346.79, 2372.54, 10.7002, 113.738, 0),
(163, 1118.27, 2014.53, 10.8203, 180.384, 0),
(164, 1047.92, 1880.24, 10.8203, 179.98, 1),
(165, 1152.22, 1932.54, 10.8203, 1.83632, 0),
(166, 1157.75, 1649.78, 5.82031, 181.378, 0),
(167, -2503.28, 109.091, 25.8672, 179.81, 0),
(168, 1154.54, 1592.99, 5.82031, 35.9118, 0),
(169, 1133.96, 1393.65, 5.82031, 271.266, 0),
(170, -2562.46, 322.842, 10.5625, 359.271, 0),
(171, -2710.51, 834.782, 49.9844, 269.785, 0),
(172, 1030.93, 1798.59, 10.8203, 91.5149, 0),
(173, 1051.93, 2038.4, 10.8203, 89.8933, 0),
(174, 1058.26, 2199.29, 10.8203, 180.131, 1),
(175, 1085.71, 2065.97, 10.8203, 271.157, 0),
(176, -2439.31, 935.161, 45.4228, 359.272, 0),
(177, 1138.88, 2275.55, 10.8272, 1.34988, 0),
(178, 1108.91, 2329.28, 16.7188, 90.7605, 0),
(179, 967.975, 2346.9, 11.3672, 180.61, 1),
(180, -2046.09, 972.607, 54.6844, 270.122, 0),
(181, 958.448, 2182.24, 10.8203, 90.3948, 0),
(182, 948.647, 2043.9, 10.8203, 271.033, 0),
(183, -2202.96, 961.962, 80, 90.5354, 0),
(184, -2039.39, 830.012, 54.8438, 359.828, 0),
(185, -1805.69, 1337.18, 7.1875, 112.258, 0),
(186, -1628.01, 1387.29, 7.1875, 224.873, 0),
(187, -1620.3, 145.354, -7.22658, 44.1828, 1),
(188, 918.966, 1735.52, 8.64844, 181.771, 0),
(189, -1739.56, 42.7366, 3.55469, 270.484, 0),
(190, 960.433, 1671.28, 8.85156, 179.98, 0),
(191, -2058.17, 162.401, 28.8359, 359.972, 0),
(192, 1057.62, 1231.08, 10.8203, 181.997, 0),
(193, -1825.8, 1054.67, 46.0781, 90.3239, 0),
(194, 1099.21, 1220.07, 10.8203, 180.688, 1),
(195, 1137.58, 985.766, 10.8203, 118.96, 0),
(196, -1662.07, 1082.15, 7.92188, 0.315279, 0),
(197, 1530.22, 754.305, 11.0234, 181.628, 1),
(198, 1757.05, 672.689, 10.8203, 1.59176, 0),
(199, -1840.17, -71.5736, 15.1094, 90.1298, 0),
(200, 1808.94, 708.706, 10.8203, 173.597, 0),
(201, -1885.94, -442.123, 25.1719, 270.121, 0),
(202, 2707.4, 783.675, 10.8984, 270.888, 0),
(203, 2699.44, 909.769, 10.7216, 85.9406, 0),
(204, 2551.01, 723.232, 11.0234, 181.536, 0),
(205, 2488.35, 1126.95, 10.8203, 89.4781, 1),
(206, -1994.11, -378.385, 25.7109, 68.2047, 0),
(207, 2346.5, 1385.9, 10.8203, 0.90547, 1),
(208, -2097.71, -81.8192, 35.3273, 89.6075, 0),
(209, 2154.83, 1480.73, 10.8203, 0.326259, 0),
(210, 2218.17, 1750.73, 11.0469, 270.845, 0),
(211, 1892.55, 1807.27, 12.7437, 270.14, 0),
(212, -2119.93, -20.1999, 35.3203, 358.89, 1),
(213, 2047.99, 1989.82, 11.6484, 271.377, 0),
(214, 1879.29, 2012.56, 7.59459, 271.18, 0),
(215, 2034.31, 2203.56, 10.8203, 0.559531, 0),
(216, -1711.44, 1232.02, 17.9237, 314.475, 0),
(217, 2026.42, 2235.84, 10.8203, 181.315, 0),
(218, -1959.18, 1491.89, 7.1875, 315.36, 0),
(219, 2008.47, 2132.98, 10.8203, 270.303, 1),
(220, 2195.25, 2062.78, 10.8203, 270.404, 1),
(221, 2271.88, 2040.46, 10.8203, 180.593, 0),
(222, -2221.95, -374.935, 35.5197, 359.572, 0),
(223, 2392.9, 2010.08, 10.8203, 1.91356, 0),
(224, 2544.49, 2011.93, 10.8172, 0.228997, 0),
(225, 2578.22, 2165.8, 10.8203, 179.631, 0),
(226, -1707.31, 1030.19, 17.5859, 179.81, 0),
(227, -1740.16, 977.424, 17.5859, 179.288, 0),
(228, -1833.85, 663.954, 30.4297, 179.288, 0),
(229, -2045.24, 755.481, 60.625, 270.156, 0),
(230, 2470.49, 2340.39, 10.8203, 90.1097, 1),
(231, -1820.09, 1142.26, 45.4554, 269.819, 1),
(232, -1849.43, 1280.8, 22.5625, 200.354, 0),
(233, 2321.17, 2567.35, 10.8208, 271.578, 1),
(234, 2188.95, 2508.03, 10.8203, 271.859, 0),
(235, -1457.9, 1017.77, 1.78906, 269.634, 0),
(236, 374.24, 2598.13, 16.4844, 191.104, 0),
(237, 210.412, 2618.72, 16.5365, 202.368, 0),
(238, -1450.01, -218.49, 14.1484, 339.275, 0),
(239, 144.089, 2405.95, 16.4881, 346.777, 0),
(240, -231.545, 2815.87, 62.0471, 268.482, 0),
(241, -1399.43, -479.328, 14.1719, 206.966, 0),
(242, -279.111, 2653.9, 62.7331, 270.989, 0),
(243, -257.051, 2592.22, 63.5703, 90.726, 0),
(244, -2561.97, 2247.68, 5.0456, 63.6907, 0),
(245, -2490.57, 2537.24, 18.1491, 359.483, 0),
(246, -156.016, 2764.52, 62.6236, 232.354, 0),
(247, -620.475, 2714.74, 72.375, 178.24, 0),
(248, -581.979, 2611.42, 53.9348, 270.853, 0),
(249, -890.922, 2684.49, 42.3418, 313.036, 0),
(250, -734.099, 2754.55, 47.2266, 271.44, 0),
(251, -2518.52, 2352.64, 4.98355, 271.04, 0),
(252, -2427.09, 2457.63, 13.1409, 269.297, 1),
(253, -771.195, 2425.02, 157.076, 82.2562, 1),
(254, -2292.06, 2286.35, 4.98238, 0.164325, 0),
(255, -1475.14, 2624.02, 55.8359, 272.02, 0),
(256, -2097.77, 2317.74, 24.102, 158.248, 1),
(257, -1581.44, 2646.59, 55.8359, 91.6632, 0),
(258, -1599.27, 2698.72, 55.1273, 177.361, 0),
(259, -1514.16, 2568.25, 55.8359, 1.95465, 0),
(260, -2471.9, 2406.78, 16.663, 119.638, 0),
(261, -1511.26, 2508.72, 55.9488, 90.7464, 0),
(262, -1429.62, 2577.26, 55.8359, 0.638884, 0),
(263, -1315.01, 2513.66, 87.046, 97.9689, 0),
(264, -1456.89, 1874.12, 32.6328, 94.9211, 1),
(265, -1503.27, 1972.88, 48.4219, 1.70341, 0),
(266, -1861.74, -1552.29, 21.75, 266.535, 0),
(267, -1790.62, -1607.51, 21.75, 179.5, 0),
(268, -1236.42, 1829.99, 41.4613, 256.367, 0),
(269, -866.636, 1518.3, 22.587, 1.3584, 1),
(270, -1825.97, -1688.2, 21.75, 120.833, 0),
(271, -1899.35, -1684.05, 23.0156, 0.906334, 0),
(272, -1899.67, -1627.29, 21.7564, 1.95074, 0),
(273, -2217.32, -2304.16, 30.625, 50.6948, 0),
(274, -2199.55, -2339.02, 30.625, 52.0759, 0),
(275, -708.164, 1596.01, 28.3236, 272.175, 0),
(276, -288.189, 1833.87, 42.2891, 25.2893, 0),
(277, -354.21, 1511.05, 75.5625, 91.7008, 0),
(278, -357.017, 1591.99, 76.6691, 2.51754, 0),
(279, -2229.27, -2400.09, 32.1823, 321.545, 0),
(280, -320.314, 1297.38, 53.6643, 91.9908, 0),
(281, -2034.87, -2558.79, 30.625, 130.746, 0),
(282, -187.676, 1226.48, 19.7422, 271.102, 0),
(283, -207.457, 1177.55, 19.7145, 91.2073, 0),
(284, -274.611, 987.367, 20.2462, 91.3873, 0),
(285, -326.983, 818.898, 14.3937, 271.281, 0),
(286, -1985.25, -2396.05, 30.625, 225.27, 0),
(287, 19.8178, 1070.21, 19.7422, 180.79, 1),
(288, 116.53, 1020.44, 13.6094, 91.9587, 0),
(289, -2201.48, -2454.69, 31.1172, 232.581, 0),
(290, 564.648, 822.524, -29.8438, 10.964, 0),
(291, 316.57, 857.928, 20.4062, 28.4325, 0),
(292, -689.263, 960.289, 12.1701, 271.369, 0),
(293, -664.402, 880.563, 2, 136.486, 0),
(294, -2086.1, -2422.87, 30.625, 230.652, 0),
(295, -2236.12, 2371.43, 5.03945, 223.671, 0),
(296, -2208.81, 2419.91, 2.48014, 47.012, 0),
(297, -2235.04, 2317.05, 7.54688, 272.144, 0),
(298, -2440.33, 2302.9, 4.98189, 90.4951, 0),
(299, -2517.84, 2295.28, 4.98438, 91.631, 0),
(300, -2379.84, 2210.16, 4.98438, 269.136, 0),
(301, -2584.34, 2355.52, 9.81211, 180, 0),
(302, -2415.61, -2185.85, 33.2891, 356.694, 0),
(303, -1821.37, 1461.43, 7.1875, 1.36602, 0),
(304, -2822.24, -1523.43, 139.289, 0.349426, 0),
(305, -2242.76, -1748.81, 480.862, 240.423, 0),
(306, -1560.86, -2723.44, 48.7435, 235.529, 0),
(307, -483.499, -70.947, 60.8672, 270.208, 0),
(308, -1624.36, -2687.53, 48.7427, 235.874, 0),
(309, -578.246, -68.1022, 64.793, 2.61913, 0),
(310, -57.2048, 40.078, 3.11027, 339.401, 0),
(311, -95.8579, -31.4826, 3.11719, 161.449, 1),
(312, -1634.48, -2232.63, 31.4766, 92.4386, 0),
(313, -71.1357, -107.412, 3.11719, 172.259, 0),
(314, -8.69292, -240.451, 5.42969, 182.09, 0),
(315, -1964.92, -1585.97, 87.953, 70.1684, 0),
(316, 161.371, -255.637, 1.57812, 270.447, 0),
(317, 104.727, -331.432, 1.57812, 92.1585, 0),
(318, 264.872, -299.004, 1.57812, 230.379, 0),
(319, -771.817, -2655.91, 83.8933, 240.389, 1),
(320, 205.92, -183.477, 1.57812, 271.331, 0),
(321, 83.6785, -166.874, 2.5929, 0.811565, 1),
(322, 199.379, -102.24, 1.55219, 269.615, 0),
(323, -565.789, -2299.39, 28.0702, 190.777, 0),
(324, 212.637, -4.89936, 2.57812, 91.6793, 0),
(325, 160.389, -20.2632, 1.57812, 91.8593, 0),
(326, -424.649, -1753.63, 6.65868, 311.075, 0),
(327, -566.357, -1498.86, 9.32846, 126.729, 0),
(328, -395.413, -1150.38, 69.4566, 176.863, 1),
(329, 719.218, -446.238, 16.3359, 272.207, 0),
(330, 661.36, -502.359, 16.3359, 1.0772, 0),
(331, 606.797, -605.925, 17.021, 2.00105, 1),
(332, -29.7411, -1118.38, 1.07812, 70.1426, 0),
(333, 799.554, -619.733, 16.3359, 1.72045, 0),
(334, 727.422, 274.718, 22.3203, 180.463, 0),
(335, -81.0427, -1210.32, 2.70635, 165.896, 0),
(336, 745.469, 384.496, 23.1719, 98.9409, 0),
(337, -1111.35, -748.21, 32.0078, 41.0836, 0),
(338, -1048.64, -700.475, 32.3516, 89.6506, 0),
(339, 1299.29, 222.421, 19.5547, 67.1056, 1),
(340, 1279.28, 290.062, 19.5547, 336.434, 0),
(341, 1306.97, 428.845, 19.2251, 1.1161, 0),
(342, -1116.46, -598.741, 32.0078, 359.642, 0),
(343, 1438.17, 330.743, 18.8438, 342.183, 0),
(344, 1543.12, 21.353, 24.1406, 100.412, 0),
(345, -993.59, -719.797, 32.0078, 90.872, 0),
(346, -948.833, -535.168, 25.9536, 90.1726, 0),
(347, 2258.53, 68.3839, 26.4844, 1.28831, 0),
(348, 2257.5, -62.8439, 26.5134, 270.781, 0),
(349, 2383.13, 137.625, 27.84, 0.551429, 0),
(350, 2569.34, 70.8929, 26.4844, 179.372, 0),
(351, -434.393, -62.6701, 58.875, 359.305, 0),
(352, -539.042, -97.0956, 63.2969, 178.615, 0),
(353, -35.0715, -381.618, 5.42969, 272.417, 0),
(354, -469.913, -167.182, 78.3309, 177.57, 0),
(355, -139.956, -327.891, 1.42188, 89.319, 0),
(356, -141.07, -49.1096, 3.11719, 162.17, 0),
(357, -565.111, -174.233, 78.4062, 269.482, 0),
(358, -52.5197, 3.42543, 3.11719, 336.502, 0),
(359, -1208.78, -1171.61, 129.219, 353.56, 0),
(360, -977.327, -946.763, 130.404, 266.163, 1),
(361, -843.863, -846.391, 149.628, 210.285, 0),
(362, -951.179, -1150.55, 129.181, 215.136, 0),
(363, -1084.52, -1385.37, 129.154, 45.7145, 0),
(364, -1418.85, -1544.81, 101.758, 179.405, 0),
(365, -1464.43, -1533.02, 101.758, 87.4927, 0),
(366, -1432.97, -1585.18, 101.758, 88.0149, 0),
(367, -1346.57, -1580.38, 102.398, 150.682, 0),
(368, -1121.59, -1617.73, 76.3672, 1.13952, 0),
(369, -1092.71, -1666.18, 76.3672, 83.1294, 0),
(370, -2578.08, -931.067, 15.9247, 264.597, 0),
(371, -2452.5, -957.774, 12.3085, 100.095, 0),
(372, -2289.87, -1039.63, 15.6719, 193.759, 1),
(373, -2236.62, -1080.13, 15.6719, 110.54, 1),
(374, -2209.27, -1121.7, 15.6719, 111.584, 0),
(375, -2198.45, -1168.79, 15.6719, 101.847, 0),
(376, -1590.18, -1348.28, 49.4577, 157.204, 0),
(377, -1662.49, -1256.62, 56.2074, 210.285, 0),
(378, -1689.97, -1026.41, 72.9485, 149.892, 0),
(379, -1714.43, -943.933, 72.0975, 150.937, 0),
(380, -1438.41, -967.589, 201.069, 0, 0),
(381, -718.364, -518.606, 31.4626, 115.425, 0),
(382, -826.802, 53.5549, 39.3153, 304.842, 0),
(383, -737.382, 155.266, 24.0669, 270.375, 0),
(384, -439.358, 4.89514, 52.5868, 248.071, 0),
(385, -251.514, -2195.93, 29.0369, 205.248, 1),
(386, -789.088, -1906.44, 6.81693, 76.2584, 0),
(387, -682.823, -2130.28, 26.2768, 260.234, 0),
(388, -1230.11, -2173.83, 29.266, 169.366, 0),
(389, -2598.12, -2216.24, 27.1579, 331.105, 0),
(390, 2352.09, -2244.63, 13.5469, 314.862, 0),
(391, 2339.04, -2150.94, 13.5538, 45.3795, 0),
(392, 2377.38, -2059.59, 13.4713, 180.814, 1),
(393, 2364.16, -2007.86, 13.5537, 90.6823, 1),
(394, 2387.43, -1939.13, 13.5469, 0.358274, 1),
(395, 2385.68, -1898.78, 13.5469, 270.401, 0),
(396, 2409.74, -1876.79, 9.26606, 271.279, 0),
(397, 2375.11, -1697.75, 13.6408, 270.051, 0),
(398, 2392.29, -1633.66, 13.4635, 270.174, 1),
(399, 2406.36, -1562.19, 31.4943, 271.209, 0),
(400, 2375.92, -1446.99, 24.0019, 270.648, 0),
(401, 2420.59, -1407.11, 24.2318, 1.02431, 0),
(402, 2402.55, -1353.59, 25.0442, 93.1895, 0),
(403, 2351.64, -1254.99, 22.5, 1.12761, 0),
(404, 2356.63, -1183.19, 28.0837, 90.5408, 0),
(405, 2430.18, -1105.06, 42.4512, 180.199, 0),
(406, 2512.75, -1105.44, 56.2031, 272.539, 0),
(407, 2606.13, -1069.09, 69.588, 5.93128, 0),
(408, 2580.92, -1026.55, 69.5709, 268.418, 0),
(409, 2527.75, -1028.78, 69.5748, 0.706929, 0),
(410, 2494, -941.392, 82.2488, 268.839, 0),
(411, 2367.04, -1030.4, 54.2422, 272.276, 0),
(412, 2322.88, -1203.97, 27.9766, 271.119, 1),
(413, 2319.84, -1246.12, 27.9766, 1.56648, 0),
(414, 2322.07, -1287.75, 27.9907, 270.874, 0),
(415, 2335.67, -1336.42, 24.0645, 89.9273, 0),
(416, 2292.1, -1542.14, 26.875, 271.559, 0),
(417, 2294.48, -1634.24, 14.7489, 179.956, 0),
(418, 2268.9, -1687.9, 13.6723, 90.5933, 0),
(419, 2228.57, -1820.54, 13.5628, 182.881, 0),
(420, 2231.59, -1874.59, 14.2369, 270.629, 1),
(421, 2242.96, -1943.34, 13.548, 271.489, 0),
(422, 2288.6, -2023.56, 13.5469, 270.63, 0),
(423, 2203.06, -1986.06, 13.5469, 0.690688, 0),
(424, 2158.55, -1998.22, 13.5469, 45.3624, 0),
(425, 2228.96, -2129.27, 7.5384, 226.573, 0),
(426, 2153.86, -2164.92, 13.5469, 226.082, 0),
(427, 2136.18, -2243.59, 13.5466, 135.46, 0),
(428, 2267.85, -2351.79, 13.5469, 226.398, 0),
(429, 2196.94, -2415.95, 13.5469, 341.933, 0),
(430, 2263.49, -2525.89, 10.8806, 180.304, 0),
(431, 2271.62, -2614.96, 8.32714, 270.138, 0),
(432, 2273.4, -2673.81, 13.6163, 90.3482, 0),
(433, 2194.46, -2700.77, 13.5469, 90.839, 0),
(434, 2188.45, -2562.07, 13.5469, 0.19881, 0),
(435, 2204.47, -2452.54, 16.125, 25.9705, 0),
(436, 2058.3, -2376.89, 16.125, 181.881, 0),
(437, 2078.57, -2270.27, 15.9666, 270.662, 0),
(438, 2063.05, -2209.29, 15.9822, 90.5746, 0),
(439, 2069.72, -2085.44, 13.5469, 270.978, 0),
(440, 2056.09, -2011.33, 13.5469, 0.126669, 0),
(441, 2074.33, -1858.3, 3.98438, 271.1, 0),
(442, 2124.18, -1804.41, 13.5547, 179.654, 0),
(443, 2061.42, -1782.41, 13.5516, 180.932, 0),
(444, 2144.65, -1733.87, 17.2813, 271.38, 0),
(445, 2132.88, -1659.36, 15.0859, 314.98, 0),
(446, 2054.26, -1707.05, 13.5469, 0.826379, 1),
(447, 1986.95, -1779.78, 13.5445, 89.4365, 0),
(448, 1990.05, -1584.03, 13.5957, 315.177, 0),
(449, 2058.08, -1553.7, 13.4675, 1.25086, 0),
(450, 2172.48, -1584.96, 14.3023, 160.669, 0),
(451, 2171.93, -1511.24, 23.9129, 359.832, 0),
(452, 2173.51, -1442.19, 23.9844, 359.96, 0),
(453, 2242, -1467.68, 23.9564, 359.952, 0),
(454, 2167, -1396.1, 25.5391, 88.804, 0),
(455, 2182.26, -1338.46, 23.9844, 90.6454, 0),
(456, 2106.21, -1340.23, 23.9844, 90.4519, 0),
(457, 2288.76, -1352.83, 30.5625, 91.2404, 0),
(458, 2208.52, -1263.12, 23.8804, 270.662, 0),
(459, 2192.28, -1151.33, 33.524, 89.4517, 0),
(460, 2102.8, -1196.23, 23.8364, 270.89, 0),
(461, 2105.02, -1143.2, 25.586, 181.004, 0),
(462, 2283.21, -1120.24, 37.9766, 269.101, 0),
(463, 2228.69, -1060.36, 46.0078, 48.024, 0),
(464, 2215.09, -986.429, 62.4316, 245.661, 1),
(465, 2173.83, -1019.31, 62.8516, 181.109, 0),
(466, 2004.67, -972.62, 42.4609, 216.314, 0),
(467, 2040.45, -1015.87, 39.7422, 275.467, 1),
(468, 1904.9, -1091.23, 24.3299, 266.437, 0),
(469, 1961.86, -1159.16, 20.9408, 269.944, 0),
(470, 1983.25, -1225.16, 20.0535, 188.333, 0),
(471, 2006.49, -1300.25, 23.8736, 88.9611, 0),
(472, 2017.72, -1408.47, 16.9922, 89.9948, 0),
(473, 1902.62, -1294.06, 13.5818, 91.1697, 0),
(474, 1959.21, -1361.35, 18.5781, 181.301, 1),
(475, 1887.95, -1577.69, 13.6092, 270.785, 0),
(476, 1910.07, -1673.56, 13.3259, 180.654, 0),
(477, 1955.11, -1740.49, 15.9688, 271.031, 0),
(478, 1945.37, -1829.91, 7.07812, 76.7602, 0),
(479, 1880.17, -1888.86, 13.4803, 270.381, 0),
(480, 1873.34, -1952.71, 20.0703, 179.25, 0),
(481, 1902.34, -2009.94, 13.5469, 181.634, 0),
(482, 2056, -2048.36, 13.5469, 0.160713, 0),
(483, 1853.58, -2107.75, 13.5577, 270.45, 0),
(484, 2013.93, -2138.68, 13.5469, 0.335135, 0),
(485, 1673.35, -2076.67, 13.6173, 269.328, 0),
(486, 1856.18, -2248, 13.5469, 1.22956, 0),
(487, 1643.56, -2296.37, -1.18973, 179.966, 0),
(488, 2021.93, -2292.93, 13.5469, 271.185, 0),
(489, 1668.44, -2135.21, 13.5469, 45.128, 0),
(490, 1473.75, -2389.89, 13.5547, 89.4833, 0),
(491, 1607.02, -2694.45, 13.5469, 270.062, 0),
(492, 1845.27, -2674.87, 13.5469, 180.332, 0),
(493, 1688.24, -1955.16, 8.25, 180.578, 0),
(494, 1728.94, -1882.51, 13.5733, 0.174713, 0),
(495, 1745.15, -1780.7, 13.6848, 1.24348, 0),
(496, 1694.47, -1664.89, 20.1975, 90.4002, 0),
(497, 1833.45, -1629.18, 13.4729, 180.285, 0),
(498, 1705.19, -1564.79, 13.5469, 179.303, 0),
(499, 1711.01, -1465.63, 13.5469, 1.35451, 0),
(500, 1766.74, -1367.87, 15.7578, 180.39, 0),
(501, 1661.94, -1370.4, 17.4471, 270.276, 0),
(502, 1782.34, -1215.38, 16.9285, 179.829, 0),
(503, 1636.59, -1199.95, 19.7809, 88.7674, 0),
(504, 1656.89, -1001.99, 24.0491, 123.182, 1),
(505, 1510.67, -1262.66, 14.5625, 180.702, 0),
(506, 1525.62, -683.942, 94.75, 269.748, 0),
(507, 1522.87, -1107.25, 20.8282, 88.9763, 0),
(508, 1511.26, -1383.29, 14.0391, 91.4307, 0),
(509, 1504.35, -1483.87, 13.5489, 90.6761, 0),
(510, 1577.74, -1654, 19.8792, 179.825, 0),
(511, 1572.18, -1751.42, 4.4024, 259.228, 0),
(512, 1503.69, -1802.64, 33.4243, 89.6239, 0),
(513, 1499.91, -1851.71, 13.5469, 180, 0),
(514, 1665.08, -1915.32, 21.9609, 196.621, 0),
(515, 1599.35, -2237.61, 13.551, 90.2716, 0),
(516, 1498.66, -2285.64, 13.5537, 180.823, 0),
(517, 1369.07, -2405.54, 13.5547, 90.7443, 0),
(518, 1455.49, -2696.47, 13.5391, 90.9895, 0),
(519, 1452.38, -1910.9, 24.441, 89.4464, 0),
(520, 1426.68, -1346.61, 13.5806, 0.461401, 0),
(521, 1479.07, -1231.32, 13.9629, 89.2433, 0),
(522, 1454.31, -918.498, 37.5493, 81.5632, 0),
(523, 1456.78, -603.759, 95.7188, 89.2064, 0),
(524, 1362.82, -623.27, 109.133, 286.423, 0),
(525, 1309.18, -876.6, 39.5781, 271.872, 0),
(526, 1303.87, -1001.62, 35.2809, 0.723076, 0),
(527, 1296.25, -1092.37, 25.8803, 179.881, 0),
(528, 1424.2, -1099.14, 17.5553, 180.32, 0),
(529, 1274.98, -1464.74, 10.0469, 270.205, 0),
(530, 1407.77, -1482.95, 20.4392, 355.918, 0),
(531, 1347.48, -1689.41, 13.5995, 180.056, 0),
(532, 1338.75, -1802.04, 13.5547, 180.108, 0),
(533, 1211.06, -1881.89, 13.5525, 0.615485, 0),
(534, 1112.77, -2040.37, 74.4297, 0.048457, 0),
(535, 1218.94, -1823.22, 13.5919, 0.300014, 0),
(536, 1270.79, -1678.91, 19.7344, 180.194, 0),
(537, 1225.39, -1610.51, 13.5469, 89.7472, 0),
(538, 1283.27, -1230.82, 13.6797, 180.667, 0),
(539, 1279.21, -1179.27, 23.6347, 270.991, 1),
(540, 1247.15, -870.809, 46.6406, 96.356, 0),
(541, 1189.19, -893.151, 43.2038, 277.968, 0),
(542, 1185.88, -1232.3, 18.5547, 1.70743, 1),
(543, 1121.86, -1316.34, 13.7123, 90.9795, 0),
(544, 1125.98, -1561.34, 22.7457, 269.595, 0),
(545, 1087.26, -1614.64, 20.4587, 270.874, 0),
(546, 1123.78, -1783.73, 16.6018, 0.216705, 1),
(547, 1113.9, -1874.43, 13.5469, 89.9798, 0),
(548, 965.237, -1728.05, 13.5469, 268.963, 1),
(549, 980.195, -1614.62, 13.5469, 269.577, 1),
(550, 968.272, -1520.14, 13.5494, 91.2598, 0),
(551, 1031.72, -1442.22, 13.5546, 0.14671, 1),
(552, 1033.06, -1372.75, 13.5775, 1.42629, 0),
(553, 990.807, -1248.28, 19.4363, 270.559, 0),
(554, 1031.31, -1081.22, 23.8281, 90.8398, 0),
(555, 1015.39, -1003.87, 32.1016, 91.2079, 0),
(556, 1043.05, -927.362, 42.511, 277.659, 0),
(557, 1043.69, -820.544, 97.623, 110.703, 1),
(558, 984.632, -697.664, 121.132, 122.116, 0),
(559, 977.967, -924.507, 45.7656, 4.86293, 0),
(560, 867.258, -1050.21, 25.1016, 125.57, 0),
(561, 825.747, -1171.51, 16.9766, 268.77, 0),
(562, 900.854, -1296.79, 13.7026, 90.4533, 0),
(563, 893.443, -1365.81, 25.2025, 90.8216, 0),
(564, 829.719, -1448.21, 13.649, 176.044, 0),
(565, 852.31, -1554.1, 13.4586, 269.857, 0),
(566, 855.5, -1636.52, 13.5547, 0.549296, 0),
(567, 820.37, -2048.53, 12.8672, 178.99, 0),
(568, 870.456, -1819.11, 12.1838, 85.9822, 0),
(569, 788.82, -1731.42, 13.5469, 1.67129, 0),
(570, 791.664, -1610.66, 13.3906, 0.407824, 0),
(571, 829.455, -1367.69, 22.5321, 180.373, 0),
(572, 831.747, -994.012, 27.8214, 311.301, 0),
(573, 932.527, -921.192, 42.6016, 4.26531, 1),
(574, 907.226, -816.72, 103.126, 119.309, 0),
(575, 834.692, -762.249, 85.0677, 250.902, 0),
(576, 900.474, -645.254, 116.891, 55.9652, 0),
(577, 1028.86, -648.254, 120.151, 4.91175, 0),
(578, 784.17, -763.515, 73.5607, 197.026, 0),
(579, 741.524, -1020.36, 52.7379, 328.883, 0),
(580, 717.925, -1161.92, 17.012, 151.741, 0),
(581, 729.211, -1263.14, 13.5534, 180.634, 0),
(582, 764.137, -1384.03, 13.6952, 269.185, 0),
(583, 738.581, -1466.01, 17.6953, 179.352, 0),
(584, 655.945, -1061.87, 52.5799, 139.589, 0),
(585, 697.068, -1612.47, 14.1318, 90.7451, 1),
(586, 689.106, -1684.47, 3.24848, 270.465, 0),
(587, 676.698, -1865.88, 5.46094, 179.252, 0),
(588, 569.285, -1767.2, 5.82855, 7.07094, 0),
(589, 659.131, -1631.04, 15.018, 270.066, 0),
(590, 659.593, -1525.37, 14.8516, 89.6632, 0),
(591, 662.979, -1431.03, 14.8516, 89.7859, 0),
(592, 572.727, -1651.18, 17.5997, 90.1539, 1),
(593, 578.418, -1478.4, 14.8698, 179.374, 0),
(594, 564.627, -1355.6, 15.0362, 101.69, 0),
(595, 598.361, -1283.03, 16.0583, 100.269, 0),
(596, 536.622, -1216.73, 44.8603, 110.578, 0),
(597, 484.258, -1119.83, 82.3594, 267.646, 0),
(598, 427.617, -1135.28, 73.7169, 238.385, 0),
(599, 273.455, -1157.53, 80.9141, 43.746, 0),
(600, 290.046, -1274.53, 73.9453, 22.0417, 0),
(601, 345.536, -1301.64, 54.2242, 118.625, 0),
(602, 363.208, -1202.03, 72.287, 130.581, 0),
(603, 170.105, -1323.27, 70.3513, 359.442, 0),
(604, 458.794, -1278.68, 15.4, 311.773, 0),
(605, 396.083, -1371.56, 14.8269, 212.735, 0),
(606, 473.678, -1509.55, 20.5688, 155.844, 0),
(607, 521.848, -1758.35, 14.2521, 82.2484, 0),
(608, 479.492, -1639.91, 23.7031, 180.97, 0),
(609, 452.842, -1354.1, 24.2108, 27.9866, 0),
(610, 316.436, -1334.45, 14.4954, 299.292, 1),
(611, 353.448, -1477.29, 36.0326, 213.561, 0),
(612, 407.625, -1613.28, 34.1719, 270.434, 0),
(613, 381.703, -1763.86, 7.8925, 269.768, 0),
(614, 403.843, -1860.69, 7.83594, 179.934, 0),
(615, 395.402, -1928.12, 7.83594, 90.3284, 0),
(616, 399.478, -2064.08, 10.7507, 179.426, 0),
(617, 278.344, -1750.41, 4.51798, 91.0647, 0),
(618, 160.735, -1751.12, 6.79688, 180.846, 0),
(619, 277.929, -1648.02, 17.8593, 259.757, 0),
(620, 294.879, -1558.46, 36.0325, 78.4245, 0),
(621, 156.431, -1957.43, 3.77344, 90.065, 0),
(622, -52.4144, -1547.01, 2.61072, 47.6401, 0),
(623, -2760.59, -126.347, 7.18332, 359.491, 0),
(624, -2764.99, -19.6706, 7.1875, 90.173, 0),
(625, -2758.89, 24.2082, 7.16886, 182.421, 0),
(626, -2751.15, 196.104, 7.0868, 270.493, 0),
(627, -2661.09, 1266.73, 16.9978, 180, 0),
(628, -2651.67, 1364.81, 20.7266, 180.519, 0),
(629, -2660.65, -113.24, 4.32871, 357.031, 1),
(630, -2651.53, 787.84, 49.9766, 359.944, 0),
(631, -2724.08, 789.002, 53.0156, 359.944, 0),
(632, -2543.89, 169.283, 13.0316, 0.280463, 0),
(633, -2587.39, 830.879, 50.1605, 179.929, 1),
(634, -2546.05, 828.653, 50.0266, 0.092787, 0),
(635, -2583.05, 936.439, 64.9844, 179.557, 0),
(636, -2589.34, 984.463, 78.2734, 179.557, 0),
(637, -2516.21, 299.26, 35.1172, 344.395, 0),
(638, -2325.73, -46.5138, 35.3125, 270.239, 0),
(639, -2228.2, -104.396, 35.3203, 180, 0),
(640, -2214.8, -147.188, 35.3203, 0.686711, 0),
(641, -2216.17, 72.4586, 35.3279, 180.333, 0),
(642, -2179.02, 659.813, 49.4375, 180.145, 0),
(643, -2084.63, 867.327, 69.5625, 180.484, 0),
(644, -2042.27, -38.8085, 35.4336, 0.466881, 0),
(645, -1971.94, 1232.72, 31.7605, 89.5824, 0),
(646, -1643.07, 1207, 32.9007, 43.9632, 0),
(647, -1670.55, 1353.46, 7.17969, 314.999, 0),
(648, -1743.45, 199.308, 3.54956, 180.265, 0),
(649, -1726.69, 151.691, 3.55469, 180.518, 0),
(650, -1481.84, 130.979, 17.3281, 44.3682, 0),
(651, -1528, 85.6314, 17.3281, 45.4128, 1),
(652, -1582.47, 27.3644, 17.3281, 225.059, 0),
(653, -1450.19, 1151.65, 7.1875, 0.129721, 0),
(654, -2331.42, 2327.73, 3.5, 179.591, 0),
(655, -1946.65, 2364.88, 49.4922, 21.1703, 0),
(656, -1667.91, 2479.09, 87.2078, 89.9186, 0),
(657, -1267.95, 2729.79, 50.0625, 298.995, 0),
(658, -171.419, 2734.62, 62.5092, 270.238, 1),
(659, -141.986, 2687.07, 62.4223, 180.937, 0),
(660, 267.415, 2896.52, 10.1881, 211.749, 0),
(661, 383.865, 2434.02, 16.5, 269.112, 0),
(662, 195.302, 2435.9, 16.5959, 297.649, 0),
(663, 1063.69, 2920.85, 47.8231, 179.254, 0),
(664, 1181, 2808.6, 10.8203, 324.956, 0),
(665, 1269.97, 2852.99, 10.8203, 271.166, 0),
(666, 1417.47, 2850.49, 10.8203, 359.952, 0),
(667, 1390.07, 2654.46, 11.3926, 0.28116, 1),
(668, 1553.82, 2644.8, 10.8203, 91.1498, 0),
(669, 1525.38, 2680.87, 10.8203, 179.929, 0),
(670, -1214.43, -33.535, 14.1484, 224.84, 1),
(671, -1374.9, -685.984, 14.1484, 90.6275, 0),
(672, -1502.36, -283.8, 5.99097, 4.98232, 0),
(673, -2097.54, -115.205, 35.3203, 359.238, 0),
(674, -2650.48, 134.804, 4.33594, 182.539, 0),
(675, -2649.36, 78.024, 4.33594, 179.743, 0),
(676, -2763.32, 124.449, 7.18154, 353.644, 0),
(677, -2850.02, 898.945, 44.0547, 4.89849, 0),
(678, -2892.01, 994.133, 40.7188, 30.4876, 0),
(679, -2912.05, 1098.07, 27.0703, 0.196832, 0),
(680, -2929.7, 1182.18, 13.5312, 180.028, 0),
(681, -2487.1, -625.375, 132.608, 357.065, 0),
(682, 2575.32, 1044.67, 10.8203, 90.7082, 0),
(683, -1857.28, -377.921, 25.1797, 98.1914, 0),
(684, 2579.73, 1213.19, 10.8203, 1.56373, 0),
(685, 2476.4, 1290.01, 10.8125, 181.419, 0),
(686, -1917.75, -455.986, 25.1719, 179.659, 0),
(687, 2515.03, 1443.63, 10.9062, 270.993, 0),
(688, 2502.98, 1499.13, 10.8203, 91.7256, 0),
(689, -1917.72, -642.839, 24.5938, 179.659, 0),
(690, 2583.64, 1579.98, 10.8203, 181.707, 0),
(691, -1952.23, -326.582, 25.7299, 271.757, 0),
(692, 2676.51, 1886.25, 10.8203, 0.872452, 0),
(693, -1991.86, -306.524, 25.7109, 208.567, 0),
(694, -1922.56, -200.561, 25.7109, 172.533, 0),
(695, -1892.72, 106.489, 27.5625, 181.04, 0),
(696, 2611.5, 2467.32, 10.8203, 40.6279, 0),
(697, -2017.76, -2349.84, 30.625, 225.615, 0),
(698, 2540.05, 2601.9, 4.89791, 62.4048, 0),
(699, -2062.98, -2255.57, 31.9127, 233.263, 0),
(700, 1966.95, 2487.21, 11.1782, 180.963, 0),
(701, -2782.47, -1427.31, 136.238, 256.427, 0),
(702, 2054.14, 2409.42, 10.8203, 180.376, 0),
(703, -2842.34, -1629.52, 141.492, 18.291, 0),
(704, -2818.08, -1664.37, 141.523, 322.076, 0),
(705, -2820.97, -1704.84, 141.589, 317.864, 1),
(706, -2402.55, -2368.55, 24.5023, 184.696, 0),
(707, -2171.98, -2414.34, 34.2969, 231.174, 0),
(708, -1321.14, -1441.47, 103.664, 216.772, 0),
(709, -31.9894, -2477.37, 36.6484, 124.708, 0),
(710, 0.048953, -2518.47, 36.6484, 209.495, 0),
(711, 33.3808, -2651.79, 40.489, 184.428, 0),
(712, 30.1433, -2687.32, 40.6766, 86.2489, 0),
(713, 986.309, 2564.06, 10.7191, 151.887, 0),
(714, 1215.02, 2598.55, 10.8265, 271.072, 0),
(715, 1759.62, 2866.44, 11.3359, 104.166, 0),
(716, 1915.94, 2853.41, 10.8359, 0.568895, 0),
(717, 2570.53, 2341.92, 17.8203, 341.071, 0),
(718, -600.335, -1456.61, 11.8014, 359.12, 0),
(719, 2183.78, 2545.4, 10.8203, 195.902, 0),
(720, 2774.59, -2524.67, 16.2244, 1.32145, 0),
(721, -589.181, -1278.83, 21.8958, 165.374, 0),
(722, 1944.13, 2448.56, 11.1782, 91.6079, 0),
(723, -626.554, -1334, 19.4141, 229.422, 0),
(724, 1676.34, 2336.49, 10.8203, 181.558, 0),
(725, -548.398, -1002.36, 24.1361, 284.256, 0),
(726, 1799.2, 2279.64, 5.49667, 180.171, 0),
(727, -592.229, -1048.85, 23.3032, 359.12, 0),
(728, 2720.92, -2352.04, 17.3403, 271.482, 0),
(729, 2678.04, -2319.32, 3, 180.175, 0),
(730, 1765.89, 2109.48, 10.8431, 4.35811, 0),
(731, 1441.79, 2366.31, 10.8203, 181.244, 0),
(732, -423.107, -393.379, 16.2031, 235.015, 0),
(733, 2729.41, -2457.63, 17.5937, 180.544, 0),
(734, 2715.99, -2513.47, 13.6641, 269.448, 0),
(735, 1536.86, 2299.81, 10.8203, 91.1037, 0),
(736, -388.952, -424.902, 16.2031, 173.393, 0),
(737, 2685.24, -2556.64, 13.6323, 1.17503, 0),
(738, 1428.11, 2073.44, 11.015, 91.2996, 0),
(739, 2701.33, -2426.72, 17.5937, 1.0522, 0),
(740, -2229.61, 2466.76, 4.98438, 44.739, 0),
(741, 2666.06, -2380.08, 17.3403, 91.4289, 0),
(742, 1318.73, 1747.43, 10.8203, 0.337462, 0),
(743, 1280.92, 1349.49, 10.8203, 272.877, 0),
(744, -2635.1, 2413.72, 14.0402, 350.242, 0),
(745, 2619.59, -2341.64, 13.625, 358.895, 0),
(746, 1288.74, 1231.82, 10.8203, 1.08119, 0),
(747, 1602.92, 1165.98, 10.8125, 91.4003, 0),
(748, -2528.67, 2232.88, 4.98346, 64.9204, 0),
(749, -2290.18, 2225.43, 4.98438, 0.315279, 0),
(750, 2543.5, -2407.54, 17.8828, 226.284, 0),
(751, 1395.91, 1862.07, 10.8203, 92.3555, 0),
(752, 2549.81, -2351.88, 13.625, 315.065, 0),
(753, -2704.67, 1355.71, 7.06916, 359.944, 0),
(754, 1357.45, 1017.53, 10.8203, 0.626201, 0),
(755, 1477.54, 1107.42, 10.8203, 271.56, 0),
(756, 2465.35, -2388.02, 13.625, 315.977, 0),
(757, -2484.25, -283.119, 40.5391, 180.297, 0),
(758, 1944.68, 911.315, 10.8203, 91.392, 0),
(759, -2395.42, -247.984, 39.9715, 348.119, 0),
(760, 2434.07, -2420.24, 13.625, 44.6535, 0),
(761, 2456.84, -2531.38, 17.8996, 30.8562, 0),
(762, 2505, -2684.91, 13.656, 90.2538, 1),
(763, 2383.35, -2597.56, 13.6641, 0.227282, 0),
(764, 2724.3, -2242.84, 15.9666, 0.034264, 0),
(765, -371.373, -954.945, 54.8774, 226.44, 0),
(766, 1680.56, 1243.88, 10.7375, 0.796476, 0),
(767, -364.27, -989.755, 57.191, 211.295, 0),
(768, 1737.74, 1219.08, 10.8203, 179.727, 0),
(769, 1837.71, 1300.53, 10.8203, 180.98, 0),
(770, 1894.82, 1182.87, 10.8281, 91.5462, 0),
(771, 1924.54, 955.703, 10.8203, 1.17203, 0),
(772, 2801.92, -1975.33, 13.5478, 180.673, 0),
(773, 1793.58, 632.825, 10.8203, 167.373, 1),
(774, -1947.69, -1203.23, 34.8594, 62.9487, 0),
(775, 2799.68, -1901.4, 13.5503, 90.4712, 0),
(776, 2812.19, -1868.66, 9.92619, 357.481, 0),
(777, -2042.01, -1057.65, 32.1433, 89.0599, 0),
(778, 2803.97, -1771.68, 11.8438, 167.662, 0),
(779, 2874.75, -1588.52, 22.4005, 73.1649, 1),
(780, 2802.66, -1534.73, 11.0938, 90.4689, 1),
(781, 1544.73, 798.114, 10.8203, 271.906, 0),
(782, 1056.48, 735.441, 10.8203, 270.598, 0),
(783, -2124.01, 262.316, 35.8426, 359.914, 0),
(784, 764.104, 743.532, 28.5159, 318.444, 0),
(785, -2483.03, 155.475, 32.1328, 0.094873, 0),
(786, -2538.56, -39.2529, 25.6172, 269.565, 0),
(787, 2839.41, -1313.5, 23.1797, 281.02, 0),
(788, 2577.02, 1084.18, 10.8203, 1.3855, 0),
(789, 2601.79, 1440.39, 10.8203, 1.93361, 0),
(790, 2804.9, -1060.82, 30.7188, 88.7829, 0),
(791, 2608.73, 2136.1, 10.8203, 2.75591, 0),
(792, 2758.67, -1179.87, 69.3986, 270.045, 1),
(793, 2508.83, 2293.68, 10.8203, 92.2527, 0),
(794, 2409.16, 2280.75, 10.8203, 182.024, 0),
(795, 2806.47, -1244.96, 45.9426, 359.809, 0),
(796, 1638.98, 2629.11, 10.8203, 271.583, 0),
(797, 1149.92, 2166.18, 10.8203, 91.2417, 1),
(798, 2750, -1329.93, 49.9963, 315.542, 0),
(799, 2682.35, -1393.26, 30.7016, 129.073, 1),
(800, 1076.43, 1843.58, 10.8203, 271.073, 0),
(801, 2684.73, -1565.6, 22.1383, 0.51129, 0),
(802, 2614.37, -1610.43, 3.69948, 356.268, 0),
(803, 2590.48, -1742.54, 1.64062, 180.105, 0),
(804, 2703.38, -1960.2, 13.554, 0.983972, 0),
(805, 699.635, 1193.01, 13.3858, 359.802, 0),
(806, 2731.41, -2018.76, 13.5547, 270.414, 0),
(807, -924.601, 2044.58, 60.9205, 220.393, 0),
(808, 121.056, 1460.37, 10.6208, 347.189, 0),
(809, -648.805, 2154.07, 60.3828, 90.1728, 0),
(810, 288.238, 1344.16, 10.5859, 0.858662, 0),
(811, 171.137, 1179.09, 14.7578, 327.426, 0),
(812, 66.3959, 1004.6, 13.8146, 180.415, 0),
(813, -788.149, 2145.49, 60.3828, 162.426, 0),
(814, -348.984, 2225.39, 42.4912, 180.181, 0),
(815, -367.196, 1203.51, 19.7422, 271.205, 0),
(816, -99.9797, 1365.81, 10.2734, 11.9426, 0),
(817, -399.08, 2198.59, 42.426, 12.0242, 0),
(818, 31.2547, 1575.28, 12.75, 88.3573, 0),
(819, 95.7757, 1810.16, 17.6406, 2.30724, 0),
(820, 782.771, 2089.83, 6.71094, 179.137, 0),
(821, 791.831, 1999.45, 5.54679, 224.571, 0),
(822, 228.553, 1884.36, 17.6406, 1.4293, 0),
(823, 700.207, 1985.83, 4.9375, 179.659, 0),
(824, 672.575, 1708.99, 7.1875, 131.092, 0),
(825, 2543.64, -2182.04, 13.5441, 90.155, 0),
(826, 2481.01, -2198.95, 13.6119, 90.5229, 0),
(827, 2455.79, -2132.68, 17.2712, 89.5411, 0),
(828, 2461.31, -2066.8, 13.5469, 91.0318, 0),
(829, 220.323, 1968.35, 17.6406, 0.943361, 0),
(830, 279.719, 2004.05, 17.6406, 91.3409, 0),
(831, 336.735, 1986.3, 17.6406, 181.402, 0),
(832, 538.528, 1560.35, 1, 345.355, 0),
(833, 706.576, 1599.24, 4.01816, 273.287, 0),
(834, 1328.76, 1250.46, 14.2656, 269.853, 0),
(835, -217.866, 1147.12, 19.7422, 359.491, 0),
(836, 2449.05, -1700.31, 13.5216, 0.356632, 0),
(837, 764.472, 1871.28, 5.08675, 2.23537, 0),
(838, 2490.02, -1514.99, 23.9922, 91.1193, 0),
(839, 2538.56, -1440.54, 24, 359.937, 0),
(840, 2581.53, -1469.28, 24, 179.83, 0),
(841, 916.975, 2106.81, 10.8203, 0.276953, 0),
(842, 2542.55, -1361.2, 31.1805, 359.549, 0),
(843, -1629.43, 792.101, 7.1875, 179.322, 0),
(844, 2577.3, -1114.07, 66.2537, 113.418, 0),
(845, 2534.42, -1329.72, 38.8516, 180.108, 1),
(846, -841.105, 2750.7, 45.8516, 185.015, 0),
(847, -1818.48, 31.9282, 15.1228, 359.491, 0),
(848, -2545.31, -353.815, 37.0312, 277.316, 0),
(849, -339.656, 1546.19, 75.5625, 0.720908, 0),
(850, -393.998, 1510.78, 75.5625, 89.8364, 0),
(851, -1943.6, 2601.9, 47.7848, 274.315, 0),
(852, -2312.66, 2432.95, 4.89475, 232.665, 1),
(853, -736.518, 1648.08, 27.448, 90.6955, 0),
(854, -1372.09, 2109.21, 42.2, 48.2096, 0),
(855, -2439.5, 2252.27, 4.96527, 91.3499, 0),
(856, -1428.34, 2170.57, 50.0114, 26.2763, 0),
(857, -1388.92, 2648.29, 55.9844, 359.237, 0),
(858, -2381.43, -608.115, 132.117, 304.472, 0),
(859, -1748.54, 1540.88, 7.1875, 269.819, 0),
(860, 543.33, 2359.48, 31.0925, 98.4868, 0),
(861, -2095.34, 1436.33, 7.10156, 180, 0),
(862, 279.022, 2538.29, 16.8176, 359.731, 1),
(863, -2996.39, 486.27, 4.91406, 180.518, 0),
(864, -22.655, 2350.79, 24.1406, 92.0318, 0),
(865, -396.991, 2486.07, 41.7495, 352.289, 0),
(866, 2465.4, -1233.99, 32.2327, 359.637, 0),
(867, 2475.69, -1303.27, 29.8412, 89.6452, 0),
(868, 2533.44, -1476.49, 23.9957, 270.837, 0),
(869, 2326.11, -1693.64, 13.5119, 90.2407, 0),
(870, 2395.27, -1782.79, 13.5469, 181.599, 0),
(871, 2276.13, -1862.72, -0.140625, 264.07, 0),
(872, 2326.31, -1901.36, 13.6172, 359.288, 0),
(873, 2371.65, -2093.9, 13.5469, 90.7682, 0),
(874, 2397.57, -2229.49, 13.5469, 45.483, 0),
(875, 2367.06, -2322.17, 13.5469, 133.773, 0),
(876, 2300.16, -2291.08, 13.5469, 134.632, 1),
(877, 2246.66, -2287.66, 14.7647, 135.666, 0),
(878, 2281.33, -2205.32, 13.5469, 226.411, 0),
(879, 2263.91, -2171.8, 6.0625, 223.343, 0),
(880, 2126.01, -2279.45, 20.6719, 224.465, 0),
(881, 2152.81, -2092.99, 13.5469, 44.8508, 0),
(882, 2092.1, -1985.95, 13.5469, 269.785, 1),
(883, 2138.37, -1937.68, 13.5469, 0.213062, 0),
(884, 2158.59, -1815.49, 16.1406, 269.769, 0),
(885, 2119.66, -1555.88, 13.2999, 70.7482, 0),
(886, 1857.74, -1032.49, 23.9909, 100.411, 0),
(887, 1540.44, -1002.75, 24.0781, 84.5796, 0),
(888, 1154.61, -1160.27, 32.0275, 90.1546, 0),
(889, 1304.64, -1324.39, 47.3387, 268.542, 0),
(890, 1185.44, -1493.71, 13.5541, 358.988, 0),
(891, 1138.8, -1495.55, 22.769, 269.032, 0),
(892, 1143.78, -1424.12, 22.7763, 90.1011, 0),
(893, 559.393, -1314.29, 17.2422, 91.3805, 0),
(894, 583.944, -1553.19, 15.5997, 178.934, 0),
(895, 410.121, -1828.11, 4.8364, 179.864, 0),
(896, 161.643, -1820.52, 3.74933, 359.163, 0),
(897, -376.933, -1468.88, 25.7266, 91.4001, 0),
(898, -69.8729, -1173.27, 1.91235, 156.968, 0),
(899, 43.4953, -1013.74, 21.0595, 268.769, 0),
(900, 783.398, -1328.61, -0.507812, 138.789, 0),
(901, 2244.99, -1543.32, 10.8281, 79.3976, 0),
(902, 2281.91, -928.289, 26.4792, 87.4447, 1),
(903, 2565.01, 24.9375, 26.9937, 179.734, 0),
(904, 2565.8, -11.1172, 26.9766, 90.6355, 0),
(905, 2523.09, -44.1255, 27.8438, 359.75, 0),
(906, 2492.04, 30.9387, 27.8452, 91.0375, 0),
(907, 2530.39, 145.913, 26.4844, 91.9955, 1),
(908, 2297.55, -145.061, 27.4838, 270.804, 0),
(909, 2316.33, -62.3804, 26.4844, 181.216, 0),
(910, 2367, -15.0561, 28.0416, 0.514723, 0),
(911, 2354.78, 24.8936, 27.8327, 180.602, 0),
(912, 2328.16, 71.4327, 30.6418, 359.96, 0),
(913, 2184.79, 64.745, 27.8421, 179.515, 0),
(914, 2157.37, -100.978, 2.73584, 301.536, 0),
(915, 2239.86, -145.005, 27.4766, 270.346, 0),
(916, 2409.23, -76.2523, 26.4844, 88.9794, 0),
(917, 2453.15, -62.0664, 27.4766, 359.688, 0),
(918, 2479.58, 142.822, 26.9857, 271.38, 0),
(919, 2430.28, 107.144, 26.4785, 270.644, 0),
(920, 1929.56, 148.408, 37.2812, 70.5529, 0),
(921, 1432.64, 216.726, 19.5618, 337.037, 0),
(922, 1362.12, 180.519, 19.5547, 66.4322, 0),
(923, 1320.18, 164.482, 20.4609, 345.452, 0),
(924, 1260.21, 153.956, 19.7239, 162.174, 0),
(925, 1192.47, 143.504, 20.5442, 247.17, 0),
(926, 1249.41, 206.446, 23.0555, 336.073, 0),
(927, 1195.77, 258.837, 19.5547, 157.318, 0),
(928, 1225.03, 327.169, 19.5547, 336.338, 0),
(929, 1261.15, 371.098, 19.5614, 66.5917, 0),
(930, 1367.48, 356.467, 20.5474, 156.6, 0),
(931, 1421.7, 281.864, 19.5547, 66.3459, 0),
(932, 1257.15, 244.235, 19.5547, 335.426, 0),
(933, 1382.06, 474.595, 20.0697, 246.872, 0),
(934, 776.828, 350.877, 19.6919, 189.419, 0),
(935, 755.676, 252.175, 27.0859, 105.038, 0),
(936, 702.312, 298.103, 20.2915, 274.693, 0),
(937, 872.177, -16.1914, 63.1953, 245.975, 0),
(938, 354.363, -113.124, 1.2467, 359.722, 0),
(939, 353.329, -67.9235, 1.40991, 181.405, 0),
(940, 320.355, -29.19, 1.57812, 90.3446, 0),
(941, 249.367, -52.9103, 1.57764, 89.4675, 0),
(942, 273.379, 23.5877, 2.4306, 99.4079, 0),
(943, 214.262, 27.2329, 2.5708, 90.5716, 1),
(944, 159.917, -105.33, 1.55577, 179.598, 0),
(945, 164.49, -179.92, 1.57812, 90.5008, 0),
(946, 214.944, -234.707, 1.77862, 270.517, 0),
(947, 179.872, -321.703, 1.57812, 180.138, 0),
(948, -9.86008, 89.0406, 3.11719, 249.55, 0),
(949, -77.0746, 92.2686, 3.11719, 339.751, 0),
(950, -133.158, -100.307, 3.11808, 259.859, 0),
(951, -76.282, -213.659, 1.42969, 2.20992, 0),
(952, -143.948, -225.144, 1.42969, 179.966, 0),
(953, 17.1584, -365.258, 6.42856, 0.756146, 0),
(954, -75.1499, -390.758, 6.42856, 179.007, 0),
(955, -574.118, -468.696, 25.5234, 90.4523, 0),
(956, -612.576, -500.784, 25.5234, 270.417, 0),
(957, -555.901, -562.162, 25.5234, 269.733, 0),
(958, -477.021, -499.322, 25.5234, 269.908, 0),
(959, -1085.24, -588.792, 32.0078, 91.696, 0),
(960, -353.08, -1045.8, 59.3616, 0.601008, 0),
(961, -278.435, -2155.35, 28.5469, 205.654, 0),
(962, -1948.79, -2421.45, 30.625, 135.631, 0),
(963, -2061.07, -2536.69, 30.625, 141.89, 0),
(964, -2100.64, -2475.18, 30.625, 50.7584, 0),
(965, -2157.15, -2372.47, 30.6583, 230.969, 0),
(966, -2162.59, -2294.95, 35.9141, 231.757, 1),
(967, -2195.35, -2244.61, 30.7769, 231.655, 0),
(968, -2072.61, -2309.13, 30.625, 233.496, 0),
(969, -1825.03, -1596.02, 21.7564, 271.313, 0),
(970, -1906.35, -1512.66, 21.75, 179.886, 0),
(971, -2236.42, -1713.37, 480.887, 8.7543, 0),
(972, -1061.01, -1214.63, 129.219, 90.5925, 1),
(973, -1036.21, -1179.15, 129.219, 270.434, 1),
(974, -1187.39, -1141.48, 129.219, 359.338, 0),
(975, -1190.78, -1069.78, 129.219, 278.218, 0),
(976, -1145.32, -909.263, 129.219, 91.6262, 0),
(977, -1002.18, -1014.82, 129.219, 1.74035, 0),
(978, 1039.02, -300.225, 73.9931, 180.6, 1),
(979, 1049.34, -359.948, 73.9922, 1.86278, 0),
(980, 1091.48, -349.675, 73.9582, 182.091, 0),
(981, 1109.2, -316.446, 73.9922, 180.565, 0),
(982, 870.13, -605.2, 18.4219, 181.232, 0),
(983, 802.496, -569.957, 21.3363, 181.109, 1),
(984, 801.231, -483.443, 17.3281, 89.3126, 0),
(985, 681.186, -438.429, 16.3359, 90.9078, 0),
(986, 606.66, -569.375, 16.6219, 358.954, 0),
(987, 670.883, -581.64, 16.3359, 0.548583, 0),
(988, 638.762, -613.072, 16.3359, 268.875, 0),
(989, 700.778, -643.928, 16.3359, 90.8032, 0),
(990, 2348.48, -654.442, 128.055, 1.77685, 0),
(991, -751.094, -133.907, 65.8622, 109.651, 0),
(992, -2303.7, 1101.09, 80.0078, 180.518, 0),
(993, -1767.36, 576.936, 35.1641, 148.999, 0),
(994, -1852.42, 468.06, 35.1719, 180.147, 0),
(995, -1000.91, -1062.3, 129.219, 181.006, 0),
(996, -924.832, -991.79, 130.139, 203.462, 1),
(997, 1588.18, 616.405, 7.78125, 90.036, 0),
(998, 2371.86, 598.328, 7.78125, 90.0361, 0),
(999, 2352.91, 545.026, 1.79688, 89.8504, 0),
(1000, -1148.04, -1598.84, 76.3672, 318.015, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `car_shop`
--

CREATE TABLE `car_shop` (
  `id` int(11) NOT NULL,
  `vehicle_model` int(11) NOT NULL DEFAULT 0,
  `payday` int(11) DEFAULT 120
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `car_shop`
--

INSERT INTO `car_shop` (`id`, `vehicle_model`, `payday`) VALUES
(1, 466, 89),
(2, 410, 57),
(3, 543, 61),
(4, 419, 72),
(5, 543, 76),
(6, 600, 81),
(7, 542, 85),
(8, 500, 93),
(9, 547, 97),
(10, 401, 105),
(11, 401, 5),
(12, 545, 9),
(13, 605, 17),
(14, 585, 21),
(15, 492, 29),
(16, 526, 37),
(17, 466, 117),
(18, 516, 101),
(19, 426, 33),
(20, 535, 57),
(21, 587, 61),
(22, 566, 72),
(23, 412, 76),
(24, 579, 81),
(25, 505, 85),
(26, 489, 89),
(27, 505, 93),
(28, 400, 105),
(29, 587, 5),
(30, 589, 9),
(31, 567, 17),
(32, 602, 21),
(33, 603, 29),
(34, 421, 37),
(35, 480, 33),
(36, 560, 57),
(37, 477, 61),
(38, 560, 72),
(39, 580, 76),
(40, 508, 81),
(41, 561, 85),
(42, 402, 89),
(43, 580, 93),
(44, 560, 105),
(45, 561, 5),
(46, 561, 9),
(47, 477, 17),
(48, 559, 21),
(49, 559, 29),
(50, 559, 37),
(51, 506, 45),
(52, 508, 97),
(53, 560, 101),
(54, 508, 109),
(55, 415, 33),
(56, 451, 57),
(57, 411, 61),
(58, 541, 72),
(59, 415, 76),
(60, 415, 81),
(61, 411, 85),
(62, 429, 89),
(63, 506, 93),
(64, 451, 105),
(65, 541, 5),
(66, 541, 9),
(67, 451, 17),
(68, 451, 21),
(69, 451, 29),
(70, 541, 37),
(71, 541, 45),
(72, 451, 97),
(73, 541, 101),
(74, 411, 109),
(75, 461, 33),
(76, 463, 57),
(77, 581, 61),
(78, 468, 72),
(79, 468, 76),
(80, 471, 81),
(81, 521, 85),
(82, 581, 89),
(83, 461, 93),
(84, 521, 105),
(85, 586, 5),
(86, 521, 9),
(87, 468, 17),
(88, 586, 21),
(89, 521, 29),
(90, 461, 37),
(91, 581, 45),
(92, 521, 97),
(93, 463, 101),
(94, 461, 109),
(95, 511, 33),
(96, 593, 57),
(97, 519, 61),
(98, 553, 72),
(99, 487, 76),
(100, 519, 81),
(101, 513, 85),
(102, 511, 89),
(103, 469, 93),
(104, 512, 105),
(105, 593, 5),
(106, 519, 9),
(107, 595, 33),
(108, 454, 57),
(109, 484, 61),
(110, 595, 72),
(111, 472, 76),
(112, 595, 81),
(113, 454, 85),
(114, 453, 89),
(115, 454, 93),
(116, 452, 105),
(117, 454, 5),
(118, 454, 9),
(119, 595, 17),
(120, 484, 21);

-- --------------------------------------------------------

--
-- Структура таблицы `cctvs`
--

CREATE TABLE `cctvs` (
  `id` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `posrx` float NOT NULL,
  `posry` float NOT NULL,
  `posrz` float NOT NULL,
  `interior` int(11) NOT NULL,
  `virworld` int(11) NOT NULL,
  `break` int(2) NOT NULL,
  `info` varchar(32) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `cctvs`
--

INSERT INTO `cctvs` (`id`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`, `interior`, `virworld`, `break`, `info`) VALUES
(1, -320.702, -270.073, 9.049, 0, 0, 0, 0, 0, 0, 'RC-6'),
(2, -554.676, -468.098, 32.096, 0, 0, 0, 0, 0, 1, 'RC-7'),
(3, -550.654, -966.074, 59.637, 0, 0, 0, 0, 0, 0, 'RC-8'),
(4, -537.653, -1680.31, 19.676, 0, 0, 0, 0, 0, 0, 'RC-10'),
(5, -747.653, -2310.31, 42.554, 0, 0, 0, 0, 0, 0, 'RC-12'),
(6, -1522.72, -2664.71, 58.524, 0, 0, 0, 0, 0, 0, 'RC-14'),
(7, -2110.72, -2440.71, 22.2, 0, 0, 0, 0, 0, 0, 'RC-15'),
(8, -2391.18, -2161.18, 35.558, 0, 0, 0, 0, 0, 1, 'RC-17');

-- --------------------------------------------------------

--
-- Структура таблицы `criminalrecords`
--

CREATE TABLE `criminalrecords` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL DEFAULT 0,
  `arrest` int(2) NOT NULL DEFAULT 0,
  `charge` varchar(128) CHARACTER SET utf8 NOT NULL,
  `date` varchar(32) CHARACTER SET utf8 NOT NULL,
  `officer` varchar(24) CHARACTER SET utf8 NOT NULL,
  `faction` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `daily_reward`
--

CREATE TABLE `daily_reward` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `reward_id` int(11) NOT NULL DEFAULT 0,
  `reward_type` int(11) NOT NULL DEFAULT 0,
  `reward_idx` int(11) NOT NULL DEFAULT 0,
  `reward_idx_count` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `daily_reward`
--

INSERT INTO `daily_reward` (`id`, `user_id`, `reward_id`, `reward_type`, `reward_idx`, `reward_idx_count`, `status`) VALUES
(1, 1, 0, 1, 3, 0, 0),
(2, 1, 1, 3, 13, 0, 0),
(3, 1, 2, 1, 4, 0, 0),
(4, 1, 3, 3, 29, 0, 0),
(5, 1, 4, 4, 0, 1, 0),
(6, 1, 5, 8, 643, 1, 0),
(7, 1, 6, 4, 2, 1, 0),
(8, 2, 0, 3, 10, 1, 0),
(9, 2, 1, 3, 13, 1, 0),
(10, 2, 2, 1, 3, 1, 0),
(11, 2, 3, 6, 520, 0, 0),
(12, 2, 4, 4, 0, 1, 0),
(13, 2, 5, 6, 598, 0, 0),
(14, 2, 6, 6, 520, 1, 0),
(15, 3, 0, 1, 3, 0, 0),
(16, 3, 1, 2, 14762, 1, 0),
(17, 3, 2, 3, 13, 1, 0),
(18, 3, 3, 3, 22, 0, 0),
(19, 3, 4, 4, 0, 1, 0),
(20, 3, 5, 4, 1, 1, 0),
(21, 3, 6, 6, 599, 0, 0),
(22, 4, 0, 8, 642, 1, 0),
(23, 4, 1, 2, 10664, 0, 0),
(24, 4, 2, 1, 3, 1, 0),
(25, 4, 3, 3, 28, 0, 0),
(26, 4, 4, 4, 0, 1, 0),
(27, 4, 5, 6, 516, 1, 0),
(28, 4, 6, 8, 644, 1, 0),
(29, 5, 0, 8, 642, 1, 0),
(30, 5, 1, 1, 4, 0, 0),
(31, 5, 2, 1, 3, 0, 0),
(32, 5, 3, 2, 25018, 0, 0),
(33, 5, 4, 4, 0, 1, 0),
(34, 5, 5, 6, 480, 0, 0),
(35, 5, 6, 8, 644, 1, 0),
(36, 6, 0, 3, 9, 0, 0),
(37, 6, 1, 1, 3, 0, 0),
(38, 6, 2, 2, 21223, 0, 0),
(39, 6, 3, 6, 523, 0, 0),
(40, 6, 4, 7, 549, 0, 0),
(41, 6, 5, 4, 1, 1, 0),
(42, 6, 6, 6, 507, 0, 0),
(43, 7, 0, 2, 10689, 0, 0),
(44, 7, 1, 1, 4, 0, 0),
(45, 7, 2, 8, 642, 1, 0),
(46, 7, 3, 2, 37282, 0, 0),
(47, 7, 4, 7, 471, 0, 0),
(48, 7, 5, 6, 523, 0, 0),
(49, 7, 6, 6, 519, 0, 0),
(50, 8, 0, 8, 642, 1, 0),
(51, 8, 1, 8, 642, 1, 0),
(52, 8, 2, 8, 642, 1, 0),
(53, 8, 3, 6, 476, 0, 0),
(54, 8, 4, 4, 0, 1, 0),
(55, 8, 5, 6, 482, 0, 0),
(56, 8, 6, 6, 520, 0, 0),
(57, 9, 0, 8, 642, 1, 0),
(58, 9, 1, 8, 642, 1, 0),
(59, 9, 2, 1, 3, 0, 0),
(60, 9, 3, 2, 32013, 0, 0),
(61, 9, 4, 4, 0, 1, 0),
(62, 9, 5, 6, 521, 0, 0),
(63, 9, 6, 8, 644, 1, 0),
(64, 10, 0, 3, 10, 0, 0),
(65, 10, 1, 2, 17507, 0, 0),
(66, 10, 2, 1, 3, 0, 0),
(67, 10, 3, 2, 42936, 0, 0),
(68, 10, 4, 4, 0, 1, 0),
(69, 10, 5, 6, 519, 0, 0),
(70, 10, 6, 6, 476, 0, 0),
(71, 11, 0, 8, 642, 1, 0),
(72, 11, 1, 8, 642, 1, 0),
(73, 11, 2, 8, 642, 1, 0),
(74, 11, 3, 6, 585, 0, 0),
(75, 11, 4, 4, 0, 1, 0),
(76, 11, 5, 6, 507, 0, 0),
(77, 11, 6, 8, 644, 1, 0),
(78, 12, 0, 2, 21474, 0, 0),
(79, 12, 1, 2, 24015, 0, 0),
(80, 12, 2, 8, 642, 1, 0),
(81, 12, 3, 2, 28370, 0, 0),
(82, 12, 4, 5, 177, 0, 0),
(83, 12, 5, 4, 1, 1, 0),
(84, 12, 6, 6, 516, 0, 0),
(85, 13, 0, 2, 22687, 1, 0),
(86, 13, 1, 2, 11008, 0, 0),
(87, 13, 2, 2, 20222, 0, 0),
(88, 13, 3, 2, 25177, 0, 0),
(89, 13, 4, 4, 0, 1, 0),
(90, 13, 5, 6, 479, 1, 0),
(91, 13, 6, 6, 598, 1, 0),
(92, 14, 0, 8, 642, 1, 0),
(93, 14, 1, 2, 13195, 0, 0),
(94, 14, 2, 8, 642, 1, 0),
(95, 14, 3, 6, 482, 0, 0),
(96, 14, 4, 4, 0, 1, 0),
(97, 14, 5, 8, 643, 1, 0),
(98, 14, 6, 6, 480, 0, 0),
(99, 15, 0, 8, 642, 1, 0),
(100, 15, 1, 2, 11580, 0, 0),
(101, 15, 2, 1, 4, 1, 0),
(102, 15, 3, 3, 22, 0, 0),
(103, 15, 4, 5, 144, 1, 0),
(104, 15, 5, 8, 643, 1, 0),
(105, 15, 6, 6, 481, 1, 0),
(106, 16, 0, 8, 642, 1, 0),
(107, 16, 1, 2, 16052, 0, 0),
(108, 16, 2, 8, 642, 1, 0),
(109, 16, 3, 3, 24, 0, 0),
(110, 16, 4, 4, 0, 1, 0),
(111, 16, 5, 8, 643, 1, 0),
(112, 16, 6, 8, 644, 1, 0),
(113, 17, 0, 2, 12894, 0, 0),
(114, 17, 1, 1, 4, 0, 0),
(115, 17, 2, 8, 642, 1, 0),
(116, 17, 3, 6, 484, 0, 0),
(117, 17, 4, 4, 0, 1, 0),
(118, 17, 5, 8, 643, 1, 0),
(119, 17, 6, 8, 644, 1, 0),
(120, 18, 0, 1, 4, 0, 0),
(121, 18, 1, 1, 4, 1, 0),
(122, 18, 2, 1, 4, 0, 0),
(123, 18, 3, 6, 476, 0, 0),
(124, 18, 4, 7, 517, 1, 0),
(125, 18, 5, 6, 599, 1, 0),
(126, 18, 6, 4, 2, 1, 0),
(127, 19, 0, 8, 642, 1, 0),
(128, 19, 1, 1, 3, 0, 0),
(129, 19, 2, 2, 14331, 0, 0),
(130, 19, 3, 2, 28098, 0, 0),
(131, 19, 4, 5, 156, 0, 0),
(132, 19, 5, 6, 507, 0, 0),
(133, 19, 6, 6, 516, 0, 0),
(134, 20, 0, 1, 3, 0, 0),
(135, 20, 1, 8, 642, 1, 0),
(136, 20, 2, 3, 8, 0, 0),
(137, 20, 3, 2, 48965, 0, 0),
(138, 20, 4, 4, 0, 1, 0),
(139, 20, 5, 6, 507, 1, 0),
(140, 20, 6, 4, 2, 1, 0),
(141, 21, 0, 8, 642, 1, 0),
(142, 21, 1, 1, 4, 0, 0),
(143, 21, 2, 2, 14456, 0, 0),
(144, 21, 3, 6, 480, 0, 0),
(145, 21, 4, 4, 0, 1, 0),
(146, 21, 5, 6, 479, 0, 0),
(147, 21, 6, 4, 2, 1, 0),
(148, 22, 0, 1, 3, 0, 0),
(149, 22, 1, 8, 642, 1, 0),
(150, 22, 2, 8, 642, 1, 0),
(151, 22, 3, 2, 36680, 0, 0),
(152, 22, 4, 7, 473, 0, 0),
(153, 22, 5, 6, 520, 0, 0),
(154, 22, 6, 6, 482, 0, 0),
(155, 23, 0, 8, 642, 1, 0),
(156, 23, 1, 8, 642, 1, 0),
(157, 23, 2, 8, 642, 1, 0),
(158, 23, 3, 2, 47157, 0, 0),
(159, 23, 4, 4, 0, 1, 0),
(160, 23, 5, 6, 482, 0, 0),
(161, 23, 6, 6, 596, 0, 0),
(162, 24, 0, 2, 11516, 0, 0),
(163, 24, 1, 1, 4, 0, 0),
(164, 24, 2, 8, 642, 1, 0),
(165, 24, 3, 2, 25270, 0, 0),
(166, 24, 4, 7, 491, 0, 0),
(167, 24, 5, 6, 485, 0, 0),
(168, 24, 6, 4, 2, 1, 0),
(169, 25, 0, 2, 23686, 0, 0),
(170, 25, 1, 8, 642, 1, 0),
(171, 25, 2, 2, 10559, 0, 0),
(172, 25, 3, 2, 27642, 0, 0),
(173, 25, 4, 7, 526, 0, 0),
(174, 25, 5, 4, 1, 1, 0),
(175, 25, 6, 6, 477, 0, 0),
(176, 26, 0, 3, 10, 1, 0),
(177, 26, 1, 8, 642, 1, 0),
(178, 26, 2, 8, 642, 1, 0),
(179, 26, 3, 3, 21, 0, 0),
(180, 26, 4, 4, 0, 1, 0),
(181, 26, 5, 6, 481, 0, 0),
(182, 26, 6, 4, 2, 1, 0),
(183, 27, 0, 8, 642, 1, 0),
(184, 27, 1, 1, 3, 0, 0),
(185, 27, 2, 1, 3, 0, 0),
(186, 27, 3, 3, 26, 0, 0),
(187, 27, 4, 4, 0, 1, 0),
(188, 27, 5, 6, 534, 0, 0),
(189, 27, 6, 6, 523, 0, 0),
(190, 28, 0, 2, 23000, 0, 0),
(191, 28, 1, 1, 3, 0, 0),
(192, 28, 2, 2, 16267, 0, 0),
(193, 28, 3, 2, 41811, 0, 0),
(194, 28, 4, 4, 0, 1, 0),
(195, 28, 5, 6, 599, 0, 0),
(196, 28, 6, 6, 523, 0, 0),
(197, 29, 0, 3, 8, 0, 0),
(198, 29, 1, 1, 4, 0, 0),
(199, 29, 2, 8, 642, 1, 0),
(200, 29, 3, 6, 598, 0, 0),
(201, 29, 4, 4, 0, 1, 0),
(202, 29, 5, 6, 478, 0, 0),
(203, 29, 6, 6, 530, 0, 0),
(204, 30, 0, 2, 19814, 0, 0),
(205, 30, 1, 2, 16524, 0, 0),
(206, 30, 2, 2, 24532, 0, 0),
(207, 30, 3, 2, 49781, 0, 0),
(208, 30, 4, 4, 0, 1, 0),
(209, 30, 5, 6, 549, 0, 0),
(210, 30, 6, 6, 520, 0, 0),
(211, 31, 0, 2, 10933, 0, 0),
(212, 31, 1, 8, 642, 1, 0),
(213, 31, 2, 2, 13482, 0, 0),
(214, 31, 3, 6, 520, 0, 0),
(215, 31, 4, 4, 0, 1, 0),
(216, 31, 5, 4, 1, 1, 0),
(217, 31, 6, 4, 2, 1, 0),
(218, 32, 0, 3, 11, 0, 0),
(219, 32, 1, 8, 642, 1, 0),
(220, 32, 2, 2, 24526, 0, 0),
(221, 32, 3, 2, 32410, 0, 0),
(222, 32, 4, 4, 0, 1, 0),
(223, 32, 5, 4, 1, 1, 0),
(224, 32, 6, 6, 485, 0, 0),
(225, 33, 0, 8, 642, 1, 0),
(226, 33, 1, 3, 12, 0, 0),
(227, 33, 2, 1, 4, 0, 0),
(228, 33, 3, 2, 29956, 0, 0),
(229, 33, 4, 4, 0, 1, 0),
(230, 33, 5, 6, 537, 0, 0),
(231, 33, 6, 8, 644, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `debug`
--

CREATE TABLE `debug` (
  `id` int(11) NOT NULL,
  `text` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `donation`
--

CREATE TABLE `donation` (
  `id` int(11) NOT NULL,
  `name` varchar(32) CHARACTER SET cp1251 NOT NULL DEFAULT 'None',
  `count` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `drugs`
--

CREATE TABLE `drugs` (
  `id` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL DEFAULT 0,
  `x` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `y` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `z` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `world` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `prog` int(11) NOT NULL DEFAULT 0,
  `planted` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `edit_advertise`
--

CREATE TABLE `edit_advertise` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `day_1` int(11) NOT NULL DEFAULT 0,
  `day_2` int(11) NOT NULL DEFAULT 0,
  `day_3` int(11) NOT NULL DEFAULT 0,
  `day_4` int(11) NOT NULL DEFAULT 0,
  `day_5` int(11) NOT NULL DEFAULT 0,
  `day_6` int(11) NOT NULL DEFAULT 0,
  `day_7` int(11) NOT NULL DEFAULT 0,
  `day_clear` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `family`
--

CREATE TABLE `family` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'ID семьи',
  `name` varchar(21) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название семьи',
  `owner_id` int(11) DEFAULT 0 COMMENT 'ID создателя семьи',
  `creating_date` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Дата создания семьи',
  `color_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ID цвета чата',
  `members_count` int(10) NOT NULL DEFAULT 0 COMMENT 'Количество участников семьи',
  `house_id` int(11) NOT NULL DEFAULT -1 COMMENT 'ID дома семьи',
  `rang_0` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Новичек',
  `rang_1` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Свояк',
  `rang_2` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Прошаренный',
  `rang_3` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Бывалый',
  `rang_4` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Местный',
  `rang_5` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Брат',
  `rang_6` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Трудяга',
  `rang_7` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Смотрящик',
  `rang_8` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Заместитель',
  `rang_9` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Глава',
  `rang_vehicle_0` int(11) NOT NULL DEFAULT 1,
  `rang_vehicle_1` int(11) NOT NULL DEFAULT 1,
  `rang_vehicle_2` int(11) NOT NULL DEFAULT 1,
  `rang_vehicle_3` int(11) NOT NULL DEFAULT 1,
  `rang_vehicle_4` int(11) NOT NULL DEFAULT 1,
  `level` int(11) NOT NULL DEFAULT 1,
  `exp` int(11) NOT NULL DEFAULT 1,
  `season_exp` int(11) DEFAULT 0,
  `type_id` int(11) DEFAULT 0,
  `office` int(11) DEFAULT 0,
  `contract_progress_0` int(11) DEFAULT 0,
  `contract_progress_1` int(11) DEFAULT 0,
  `contract_progress_2` int(11) DEFAULT 0,
  `contract_progress_3` int(11) DEFAULT 0,
  `contract_progress_4` int(11) DEFAULT 0,
  `money` int(11) DEFAULT 0,
  `settings_rangs` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '10|10|10|10|10|10|10|10|10|10|10|10|10|10|10',
  `salary_rangs` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0|0|0|0|0|0|0|0|0|0',
  `skins` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `skins_rangs_man` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0|0|0|0|0|0|0|0|0',
  `skins_rangs_woman` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0|0|0|0|0|0|0|0|0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Семьи';

--
-- Дамп данных таблицы `family`
--

INSERT INTO `family` (`id`, `name`, `owner_id`, `creating_date`, `color_id`, `members_count`, `house_id`, `rang_0`, `rang_1`, `rang_2`, `rang_3`, `rang_4`, `rang_5`, `rang_6`, `rang_7`, `rang_8`, `rang_9`, `rang_vehicle_0`, `rang_vehicle_1`, `rang_vehicle_2`, `rang_vehicle_3`, `rang_vehicle_4`, `level`, `exp`, `season_exp`, `type_id`, `office`, `contract_progress_0`, `contract_progress_1`, `contract_progress_2`, `contract_progress_3`, `contract_progress_4`, `money`, `settings_rangs`, `salary_rangs`, `skins`, `skins_rangs_man`, `skins_rangs_woman`) VALUES
(410, 'JUNKI', 15, '03/03/2026', 0, 1, -1, 'Новичек', 'Свояк', 'Прошаренный', 'Бывалый', 'Местный', 'Брат', 'Трудяга', 'Смотрящик', 'Заместитель', 'Глава', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|10|10|10|10|10|10|10|10|10|10|10|10|10|10', '0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0'),
(411, 'Admins Family', 18, '03/03/2026', 9, 2, -1, 'Новичек', 'Свояк', 'Прошаренный', 'Бывалый', 'Местный', 'Брат', 'Трудяга', 'Смотрящик', 'Заместитель', 'Спец Админ', 1, 1, 1, 1, 1, 1, 49, 48, 1, 0, 0, 0, 0, 0, 0, 515000000, '10|10|10|10|10|10|10|10|10|10|10|10|10|10|10', '0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0');

-- --------------------------------------------------------

--
-- Структура таблицы `family_blacklist`
--

CREATE TABLE `family_blacklist` (
  `id` int(11) UNSIGNED DEFAULT NULL COMMENT 'ID семьи',
  `player_id` int(11) UNSIGNED DEFAULT NULL COMMENT 'MYSQL ID кто добавил',
  `target_id` int(11) UNSIGNED DEFAULT NULL COMMENT 'MYSQL ID кого добавили',
  `reason` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Причина добавления',
  `date` timestamp NULL DEFAULT current_timestamp() COMMENT 'Дата-время события лог-сообщения'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Чорный список семей' ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Структура таблицы `family_log`
--

CREATE TABLE `family_log` (
  `id` int(11) UNSIGNED DEFAULT NULL COMMENT 'ID семьи',
  `text` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Лог-сообщение',
  `date` timestamp NULL DEFAULT current_timestamp() COMMENT 'Дата-время события лог-сообщения'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логи семей';

--
-- Дамп данных таблицы `family_log`
--

INSERT INTO `family_log` (`id`, `text`, `date`) VALUES
(411, 'The_Bizzaro[0] вступил в семью по приглашению Kizaru_Bishop[2].', '2026-03-03 19:25:57'),
(411, 'Kizaru_Bishop[2] положил в бюджет 5000000$', '2026-03-03 20:16:47'),
(411, 'Kizaru_Bishop[2] положил в бюджет 500000000$', '2026-03-03 20:17:29'),
(411, 'Kizaru_Bishop[2] положил в бюджет 10000000$', '2026-03-03 20:17:50'),
(411, 'Kizaru_Bishop[2] изменил название ранга Глава на Надзиратель.', '2026-03-03 20:18:36'),
(411, 'Kizaru_Bishop[2] изменил название ранга Надзиратель на Спец Админ.', '2026-03-03 20:18:48'),
(411, 'Kizaru_Bishop[2] изменил цвет чата семьи.', '2026-03-03 20:18:59'),
(411, 'Kizaru_Bishop[2] привязал к семье дом: №40.', '2026-03-03 20:24:41'),
(411, 'Дом семьи слетел из-за не уплаты.', '2026-03-04 20:02:30');

-- --------------------------------------------------------

--
-- Структура таблицы `family_notify`
--

CREATE TABLE `family_notify` (
  `id` int(11) UNSIGNED DEFAULT NULL COMMENT 'ID семьи',
  `text` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Инфо-сообщение',
  `date` timestamp NULL DEFAULT current_timestamp() COMMENT 'Дата-время события инфо-сообщения'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Оповещения семей';

--
-- Дамп данных таблицы `family_notify`
--

INSERT INTO `family_notify` (`id`, `text`, `date`) VALUES
(411, 'Kizaru_Bishop: Привет всем наш Любимый состав Admins Family', '2026-03-03 20:19:39');

-- --------------------------------------------------------

--
-- Структура таблицы `family_zone`
--

CREATE TABLE `family_zone` (
  `id` int(11) NOT NULL,
  `zone_x` float NOT NULL,
  `zone_y` float NOT NULL,
  `zone_xM` float NOT NULL,
  `zone_yM` float NOT NULL,
  `family` int(11) NOT NULL,
  `colorid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `family_zone`
--

INSERT INTO `family_zone` (`id`, `zone_x`, `zone_y`, `zone_xM`, `zone_yM`, `family`, `colorid`) VALUES
(1, -2362, -303.834, -2212, -153.834, -1, 0),
(2, -2512, -303.834, -2362, -153.834, -1, 0),
(3, -2662, -303.834, -2512, -153.834, -1, 0),
(4, -2812, -303.834, -2662, -153.834, -1, 0),
(5, -2961, -303.834, -2811, -153.834, -1, 0),
(6, -2961, -153.834, -2811, -3.83353, -1, 0),
(7, -2812, -153.834, -2662, -3.83353, -1, 0),
(8, -2662, -153.834, -2512, -3.83353, -1, 0),
(9, -2512, -153.834, -2362, -3.83353, -1, 0),
(10, -2362, -153.834, -2212, -3.83353, -1, 0),
(11, -2362, -3.83353, -2212, 146.166, -1, 0),
(12, -2512, -3.83353, -2362, 146.166, -1, 0),
(13, -2662, -3.83353, -2512, 146.166, -1, 0),
(14, -2812, -3.83353, -2662, 146.166, -1, 0),
(15, -2961, -3.83353, -2811, 146.166, -1, 0),
(16, -2961, 146.166, -2811, 296.166, -1, 0),
(17, -2812, 146.166, -2662, 296.166, -1, 0),
(18, -2662, 146.166, -2512, 296.166, -1, 0),
(19, -2512, 146.166, -2362, 296.166, -1, 0),
(20, -2362, 146.166, -2212, 296.166, -1, 0),
(21, -2362, 296.166, -2212, 446.166, -1, 0),
(22, -2512, 296.166, -2362, 446.166, -1, 0),
(23, -2662, 296.166, -2512, 446.166, -1, 0),
(24, -2812, 296.166, -2662, 446.166, -1, 0),
(25, -2961, 296.166, -2811, 446.166, -1, 0),
(26, -2961, 446.166, -2811, 596.167, -1, 0),
(27, -2362, 446.166, -2212, 596.167, -1, 0),
(28, -2362, 596.167, -2212, 746.167, -1, 0),
(29, -2961, 596.167, -2811, 746.167, -1, 0),
(30, -2961, 746.167, -2811, 896.167, -1, 0),
(31, -2812, 746.167, -2662, 896.167, -1, 0),
(32, -2662, 746.167, -2512, 896.167, -1, 0),
(33, -2512, 746.167, -2362, 896.167, -1, 0),
(34, -2362, 746.167, -2212, 896.167, -1, 0),
(35, -2212, 746.167, -2062, 896.167, -1, 0),
(36, -2062, 746.167, -1912, 896.167, -1, 0),
(37, -1912, 746.167, -1762, 896.167, -1, 0),
(38, -1762, 746.167, -1612, 896.167, -1, 0),
(39, -1612, 746.167, -1462, 896.167, -1, 0),
(40, -1612, 896.167, -1462, 1046.17, -1, 0),
(41, -1762, 896.167, -1612, 1046.17, -1, 0),
(42, -1912, 896.167, -1762, 1046.17, -1, 0),
(43, -2062, 896.167, -1912, 1046.17, -1, 0),
(44, -2212, 896.167, -2062, 1046.17, -1, 0),
(45, -2362, 896.167, -2212, 1046.17, -1, 0),
(46, -2512, 896.167, -2362, 1046.17, -1, 0),
(47, -2662, 896.167, -2512, 1046.17, -1, 0),
(48, -2812, 896.167, -2662, 1046.17, -1, 0),
(49, -2961, 896.167, -2811, 1046.17, -1, 0),
(50, -2961, 1046.17, -2811, 1196.17, -1, 0),
(51, -2812, 1046.17, -2662, 1196.17, -1, 0),
(52, -2662, 1046.17, -2512, 1196.17, -1, 0),
(53, -2512, 1046.17, -2362, 1196.17, -1, 0),
(54, -2362, 1046.17, -2212, 1196.17, -1, 0),
(55, -2212, 1046.17, -2062, 1196.17, -1, 0),
(56, -2062, 1046.17, -1912, 1196.17, -1, 0),
(57, -1912, 1046.17, -1762, 1196.17, -1, 0),
(58, -1762, 1046.17, -1612, 1196.17, -1, 0),
(59, -1612, 1046.17, -1462, 1196.17, -1, 0),
(60, -1612, 1196.17, -1462, 1346.17, -1, 0),
(61, -1762, 1196.17, -1612, 1346.17, -1, 0),
(62, -1912, 1196.17, -1762, 1346.17, -1, 0),
(63, -2062, 1196.17, -1912, 1346.17, -1, 0),
(64, -2212, 1196.17, -2062, 1346.17, -1, 0),
(65, -2362, 1196.17, -2212, 1346.17, -1, 0),
(66, -2512, 1196.17, -2362, 1346.17, -1, 0),
(67, -2662, 1196.17, -2512, 1346.17, -1, 0),
(68, -2812, 1196.17, -2662, 1346.17, -1, 0),
(69, -2961, 1196.17, -2811, 1346.17, -1, 0),
(70, -2212, 596.167, -2062, 746.167, -1, 0),
(71, -2062, 596.167, -1912, 746.167, -1, 0),
(72, -1912, 596.167, -1762, 746.167, -1, 0),
(73, -1912, 446.166, -1762, 596.167, -1, 0),
(74, -1912, 296.166, -1762, 446.166, -1, 0),
(75, -1912, 146.166, -1762, 296.166, -1, 0),
(76, -1912, -3.83353, -1762, 146.166, -1, 0),
(77, -1912, -153.834, -1762, -3.83353, -1, 0),
(78, -1912, -303.834, -1762, -153.834, -1, 0),
(79, -1912, -453.834, -1762, -303.834, -1, 0),
(80, -2062, -453.834, -1912, -303.834, -1, 0),
(81, -2212, -453.834, -2062, -303.834, -1, 0),
(82, -2362, -453.834, -2212, -303.834, -1, 0),
(83, -2512, -453.834, -2362, -303.834, -1, 0),
(84, -2662, -453.834, -2512, -303.834, -1, 0),
(85, -2812, -453.834, -2662, -303.834, -1, 0),
(86, -2962, -453.834, -2812, -303.834, -1, 0),
(87, -2962, -603.833, -2812, -453.834, -1, 0),
(88, -2812, -603.833, -2662, -453.834, -1, 0),
(89, -2662, -603.833, -2512, -453.834, -1, 0),
(90, -2512, -603.833, -2362, -453.834, -1, 0),
(91, -2362, -603.833, -2212, -453.834, -1, 0),
(92, -2212, -603.833, -2062, -453.834, -1, 0),
(93, -2062, -603.833, -1912, -453.834, -1, 0),
(94, -1912, -603.833, -1762, -453.834, -1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `fractions_data`
--

CREATE TABLE `fractions_data` (
  `id` int(11) NOT NULL,
  `name` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT 'No name',
  `type` int(11) NOT NULL DEFAULT 0,
  `category` int(11) NOT NULL DEFAULT 0,
  `spawn_pos` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_field` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dressing_pos` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warehouse_pos` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unloading_pos` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unloading_field` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT '0|0',
  `woman_skin` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `man_skin` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pay` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rang_name` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rang_name_default` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warehouse` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `settings` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `veh_models_id` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `veh_model_max_count` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `veh_access_rank` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '1|1|1|1|1|1|1|1|1|1',
  `veh_spawn_pos` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `veh_spawn_field` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Информация о автомобилях фракции' ROW_FORMAT=DYNAMIC;

--
-- Дамп данных таблицы `fractions_data`
--

INSERT INTO `fractions_data` (`id`, `name`, `type`, `category`, `spawn_pos`, `base_field`, `dressing_pos`, `warehouse_pos`, `unloading_pos`, `unloading_field`, `woman_skin`, `man_skin`, `pay`, `rang_name`, `rang_name_default`, `warehouse`, `settings`, `veh_models_id`, `veh_model_max_count`, `veh_access_rank`, `veh_spawn_pos`, `veh_spawn_field`) VALUES
(0, 'Гражданский', 0, 0, '0.0|0.0|0.0|0.0', '0|0', '0.0|0.0|0.0', '0.0|0.0|0.0', '0.0|0.0|0.0', '0|0', '0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0', 'Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет', 'Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет', '0|0|0|0|0|0|0|0', '0|0|0', '0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '0.0|0.0|0.0', '0|0'),
(1, 'Police [LS]', 1, 1, '2605.493408|2106.722167|1048.231567|272.419586', '1|1', '2605.708007|2109.354980|1048.231567', '2595.512939|2106.110595|1048.233520', '1598.925170|-1627.911376|13.454000', '0|0', '141|306|306|306|307|307|307|307|309|309', '265|266|280|284|285|267|281|300|310|283', '3000|5000|7000|9000|11000|13000|15000|17000|19000|21000', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шефа|Шеф', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шефа|Шеф', '0|0|499975|500000|0|0|0|0', '0|0|0', '427|528|599|601|596|415|523|0|0|0', '5|4|3|2|10|3|3|0|0|0', '1|1|1|1|1|1|1|1|1|1', '1603.180053|-1619.560058|13.499699|1.494099', '0|0'),
(2, 'Police [SF]', 1, 1, '2605.493408|2106.722167|1048.231567|272.419586', '2|1', '2605.708007|2109.354980|1048.231567', '2595.512939|2106.110595|1048.233520', '-1596.577636|677.231323|-5.242199', '0|0', '141|306|306|306|307|307|307|307|309|309', '265|266|280|284|285|267|281|300|310|283', '3000|5000|7000|9000|11000|13000|15000|17000|19000|21000', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шефа|Шеф', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шефа|Шеф', '0|0|500000|500000|0|0|0|0', '0|0|0', '427|528|599|601|597|415|523|0|0|0', '5|4|3|2|10|3|3|0|0|0', '1|1|1|1|1|1|1|1|1|1', '-1606.810058|675.330993|-5.242189|357.459991', '0|0'),
(3, 'Police [LV]', 1, 1, '2605.493408|2106.722167|1048.231567|272.419586', '3|1', '2605.708007|2109.354980|1048.231567', '2595.512939|2106.110595|1048.233520', '2282.059814|2475.619384|10.820300', '0|0', '141|306|306|306|307|307|307|307|309|309', '265|266|280|284|285|267|281|300|310|283', '3000|5000|7000|9000|11000|13000|15000|17000|19000|21000', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шефа|Шеф', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шефа|Шеф', '0|0|500000|500000|0|0|0|0', '0|0|0', '427|528|599|601|598|415|523|0|0|0', '5|4|3|2|10|3|3|0|0|0', '1|1|1|1|1|1|1|1|1|1', '2290.310058|2431.350097|3.273439|2.553590', '0|0'),
(4, 'FBI', 1, 2, '-1331.503295|1792.223632|1075.089233|269.878692', '1|1', '-1325.459960|1796.081909|1075.089233', '-1329.379150|1796.211791|1075.089233', '-2460.906494|494.360900|-20.432399', '0|0', '141|306|306|306|307|307|307|307|309|309', '286|164|164|163|163|303|304|305|166|165', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Стажер|Мл. агент|Агент|Ст. агент|Спец. агент|Агент нац. безопасности|Руководящий агент|Инспектор|Зам. директора|Директор', 'Стажер|Мл. агент|Агент|Ст. агент|Спец. агент|Агент нац. безопасности|Руководящий агент|Инспектор|Зам. директора|Директор', '0|0|499715|499924|0|0|0|0', '0|0|0', '427|528|411|601|490|415|560|0|0|0', '5|4|2|2|10|3|3|0|0|0', '1|1|1|1|1|1|1|1|1|1', '-2478.540039|536.835998|-20.432399|9.499019', '0|0'),
(5, 'Национальная гвардия', 1, 6, '702.259887|-1346.044677|1102.009643|0.962800', '1|1', '706.158386|-1338.313842|1102.013549', '698.605773|-1340.843627|1102.013549', '2734.953857|-2518.715820|13.692929', '0|0', '191|191|191|191|191|191|191|191|191|191', '287|287|287|287|179|179|179|255|255|61', '2000|4000|6000|8000|10000|12000|14000|16000|18000|20000', 'Рекрут|Капрал|Ст.капрал|Сержант|Второй лейтенант|Первый лейтенант|Майор|Подполковник|Полковник|Генерал', 'Рекрут|Капрал|Ст.капрал|Сержант|Второй лейтенант|Первый лейтенант|Майор|Подполковник|Полковник|Генерал', '0|0|1000000|1000000|0|0|0|0', '0|0|0', '433|470|500|0|0|0|0|0|0|0', '10|5|7|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '2786.034668|-2427.479004|13.672928|270.445709', '0|0'),
(6, 'Радиоцентр [LS]', 3, 7, '1221.436645|2062.462402|1009.481384|268.845611', '1|1', '1222.397705|2060.625976|1009.481384', '1226.067871|2064.188964|1009.481384', '0.000000|0.000000|0.000000', '0|0', '141|141|150|150|224|224|225|225|263|263', '188|188|250|250|170|170|217|186|223|261', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Стажер|Звукооператор|Звукорежиссер|Репортер|Ведущий|Редактор|Гл.Редактор|Тех.Редактор|Программный редактор|Директор', 'Стажер|Звукооператор|Звукорежиссер|Репортер|Ведущий|Редактор|Гл.Редактор|Тех.Редактор|Программный редактор|Директор', '2750|0|500000|500000|0|0|0|0', '750|0|0', '507|582|0|0|0|0|0|0|0|0', '7|6|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '767.969970|-1334.239990|13.541000|178.427001', '0|0'),
(7, 'Russian Mafia', 2, 3, '1272.443725|1961.782348|1018.340270|270.771301', '1|1', '1227.140502|1981.733520|1024.466308', '1228.956176|1986.697265|1024.466308', '971.012695|1691.953613|8.851599', '0|0', '233|233|233|233|233|233|233|233|216|216', '112|112|272|272|111|111|126|126|46|125', '2000|4000|6000|8000|10000|12000|14000|16000|18000|20000', 'Щипач|Браток|Шнырь|Фраер|Барыга|Сторожила|Жиган|Свояк|Авторитет|Вор в законе', 'Щипач|Браток|Шнырь|Фраер|Барыга|Сторожила|Жиган|Свояк|Авторитет|Вор в законе', '23553|0|500000|500000|0|0|0|0', '0|0|0', '478|482|409|580|579|468|445|560|0|0', '5|5|5|10|10|5|10|10|0|0', '1|1|1|1|1|1|1|1|1|1', '982.351989|1733.089965|8.648440|89.831703', '0|0'),
(8, 'La Cosa Nostra', 2, 3, '1272.443725|1961.782348|1018.340270|270.771301', '2|1', '1227.140502|1981.733520|1024.466308', '1228.956176|1986.697265|1024.466308', '1449.751708|760.763916|11.023400', '0|0', '12|12|12|12|169|169|169|169|263|263', '98|98|98|127|127|124|124|223|223|113', '2000|4000|6000|8000|10000|12000|14000|16000|18000|20000', 'Новицио|Ассосиато|Сомбаттенте|Солдато|Боец|Сотто-Капо|Капо|Босс|Консильере|Дон', 'Новицио|Ассосиато|Сомбаттенте|Солдато|Боец|Сотто-Капо|Капо|Босс|Консильере|Дон', '34470|0|500000|500000|0|0|0|0', '0|0|0', '478|482|409|580|579|468|445|560|0|0', '5|5|5|10|10|5|10|10|0|0', '1|1|1|1|1|1|1|1|1|1', '1428.170043|792.786987|10.820300|176.625000', '0|0'),
(9, 'Yakuza', 2, 3, '1272.443725|1961.782348|1018.340270|270.771301', '3|1', '1227.140502|1981.733520|1024.466308', '1228.956176|1986.697265|1024.466308', '2579.919921|1898.319946|10.819999', '0|0', '40|40|40|40|40|40|40|40|93|93', '121|121|122|122|123|123|186|186|294|120', '2000|4000|6000|8000|10000|12000|14000|16000|18000|20000', 'Вакасю|Сятей|Кедай|Фуку-Комбуте|Вагакасира|Со-Хомбуте|Камбу|Cайко-Комон|Оядзи|Кумите', 'Вакасю|Сятей|Кедай|Фуку-Комбуте|Вагакасира|Со-Хомбуте|Камбу|Cайко-Комон|Оядзи|Кумите', '3483|0|500000|500000|0|0|0|0', '3483|0|0', '478|482|409|580|579|468|445|560|0|0', '5|5|5|10|10|5|10|10|0|0', '1|1|1|1|1|1|1|1|1|1', '2618.350097|1895.969970|10.820300|181.277999', '0|0'),
(10, 'The Grove Gang', 2, 4, '2224.822998|670.730407|1017.920410|0.616500', '1|1', '2225.280517|671.122070|1014.484375', '2226.588379|674.801025|1014.484436', '2451.336669|-1666.970092|13.476799', '0|0', '65|65|65|65|65|65|65|65|65|65', '105|24|19|22|21|106|107|269|271|270', '3000|4000|5000|6000|7000|8000|9000|10000|11000|12000', 'Плейя|Хастла|Килла|Юонг|Гангста|О.Г.|Мобста|Де Кинг|Легенд|Мэд Дог', 'Плейя|Хастла|Килла|Юонг|Гангста|О.Г.|Мобста|Де Кинг|Легенд|Мэд Дог', '0|6209|0|75612|0|0|0|0', '0|0|0', '478|482|466|475|580|567|492|600|566|412', '5|5|10|5|10|10|10|5|10|5', '1|1|1|1|1|1|1|1|1|1', '2472.560058|-1671.189941|13.326899|272.970001', '0|0'),
(11, 'The Ballas Gang', 2, 4, '2224.822998|670.730407|1017.920410|0.616500', '2|1', '2225.280517|671.122070|1014.484375', '2226.652832|674.692871|1014.484375', '2012.280029|-1110.660034|26.200000', '0|0', '195|195|195|195|195|195|195|195|195|195', '103|143|144|67|241|47|48|28|102|104', '3000|4000|5000|6000|7000|8000|9000|10000|11000|12000', 'Блайд|Бастер|Крекер|Гун Бро|Ап Бро|Гангстер|Федерал Блок|Фолкс|Райч Нига|Биг Вилли', 'Блайд|Бастер|Крекер|Гун Бро|Ап Бро|Гангстер|Федерал Блок|Фолкс|Райч Нига|Биг Вилли', '0|0|0|0|0|0|0|0', '0|0|0', '478|482|466|475|580|567|492|600|566|412', '5|5|10|5|10|10|10|5|10|5', '1|1|1|1|1|1|1|1|1|1', '2026.479980|-1130.040039|24.755199|180.602996', '0|0'),
(12, 'The Rifa Gang', 2, 4, '2224.822998|670.730407|1017.920410|0.616500', '3|1', '2225.280517|671.122070|1014.484375', '2226.652832|674.692871|1014.484375', '2188.468750|-1806.901733|13.372400', '0|0', '56|56|56|56|56|56|56|56|56|56', '175|3|185|176|30|184|291|273|174|173', '3000|4000|5000|6000|7000|8000|9000|10000|11000|12000', 'Раро|Эстраньо|Навато|Ординарио|Эстимадро|Латино|Амиго|Криминаль|Проксимо|Падре', 'Раро|Эстраньо|Навато|Ординарио|Эстимадро|Латино|Амиго|Криминаль|Проксимо|Падре', '13750|0|0|0|0|0|0|0', '0|0|0', '478|482|466|475|580|567|492|600|566|412', '5|5|10|5|10|10|10|5|10|5', '1|1|1|1|1|1|1|1|1|1', '2167.149902|-1793.020019|13.361100|181.708999', '0|0'),
(13, 'The Aztecas Gang', 2, 4, '2224.822998|670.730407|1017.920410|0.616500', '4|1', '2225.280517|671.122070|1014.484375', '2226.652832|674.692871|1014.484375', '1692.753540|-2105.428466|13.546899', '0|0', '193|193|193|193|193|193|193|193|193|193', '114|23|29|177|156|119|289|292|116|115', '3000|4000|5000|6000|7000|8000|9000|10000|11000|12000', 'Перро|Тирадор|Геттор|Лас Герас|Мирандо|Сабио|Инвасор|Тессореро|Нестро|Падре', 'Перро|Тирадор|Геттор|Лас Герас|Мирандо|Сабио|Инвасор|Тессореро|Нестро|Падре', '0|0|0|0|0|0|0|0', '0|0|0', '478|482|466|475|580|567|492|600|566|412', '5|5|10|5|10|10|10|5|10|5', '1|1|1|1|1|1|1|1|1|1', '1671.569946|-2114.320068|13.546899|269.654998', '0|0'),
(14, 'The Vagos Gang', 2, 4, '2224.822998|670.730407|1017.920410|0.616500', '5|1', '2225.280517|671.122070|1014.484375', '2226.652832|674.692871|1014.484375', '2248.820068|-1034.860351|55.057899', '0|0', '190|190|190|190|190|190|190|190|190|190', '108|20|6|101|242|180|290|299|109|110', '3000|4000|5000|6000|7000|8000|9000|10000|11000|12000', 'Новато|Ординарио|Локал|Вирификадо|V.E.G.|Ассесино|Бандито|Лидер V.E.G.|Проксимо|Падре', 'Новато|Ординарио|Локал|Вирификадо|V.E.G.|Ассесино|Бандито|Лидер V.E.G.|Проксимо|Падре', '0|0|0|0|0|0|0|0', '0|0|0', '478|482|466|475|580|567|492|600|566|412', '5|5|10|5|10|10|10|5|10|5', '1|1|1|1|1|1|1|1|1|1', '2267.129882|-1042.439941|51.057098|143.772003', '0|0'),
(15, 'Больница [LS]', 1, 5, '218.793106|-1683.204833|1007.463317|0.301999', '1|1', '220.248199|-1682.124877|1007.463317', '214.475997|-1680.796142|1007.463317', '1184.101440|-1315.508544|13.573300', '0|0', '148|148|148|148|148|148|148|148|308|308', '274|274|274|275|275|275|276|276|276|70', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Интерн|Фельдшер|Проктолог|Терапевт|Нарколог|Окулист|Хирург|Зав. отделением|Зам. глав. врача|Главный врач', 'Интерн|Фельдшер|Проктолог|Терапевт|Нарколог|Окулист|Хирург|Зав. отделением|Зам. глав. врача|Главный врач', '0|0|0|0|0|0|0|0', '0|0|0', '416|561|0|0|0|0|0|0|0|0', '8|4|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '1184.459960|-1338.260009|13.576899|270.210998', '0|0'),
(16, 'Больница [SF]', 1, 5, '218.793106|-1683.204833|1007.463317|0.301999', '2|1', '220.248199|-1682.124877|1007.463317', '214.475997|-1680.796142|1007.463317', '-2633.358886|628.713012|14.453100', '0|0', '148|148|148|148|148|148|148|148|308|308', '274|274|274|275|275|275|276|276|276|70', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Интерн|Фельдшер|Проктолог|Терапевт|Нарколог|Окулист|Хирург|Зав. отделением|Зам. глав. врача|Главный врач', 'Интерн|Фельдшер|Проктолог|Терапевт|Нарколог|Окулист|Хирург|Зав. отделением|Зам. глав. врача|Главный врач', '0|0|0|0|0|0|0|0', '0|0|0', '416|561|0|0|0|0|0|0|0|0', '8|4|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '-2676.189941|625.096008|14.453100|91.381698', '0|0'),
(17, 'Больница [LV]', 1, 5, '218.793106|-1683.204833|1007.463317|0.301999', '3|1', '220.248199|-1682.124877|1007.463317', '214.475997|-1680.796142|1007.463317', '1623.327270|1820.875244|10.820300', '0|0', '148|148|148|148|148|148|148|148|308|308', '274|274|274|275|275|275|276|276|276|70', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Интерн|Фельдшер|Проктолог|Терапевт|Нарколог|Окулист|Хирург|Зав. отделением|Зам. глав. врача|Главный врач', 'Интерн|Фельдшер|Проктолог|Терапевт|Нарколог|Окулист|Хирург|Зав. отделением|Зам. глав. врача|Главный врач', '0|0|0|0|0|0|0|0', '0|0|0', '416|561|0|0|0|0|0|0|0|0', '8|4|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '1612.739990|1832.750000|10.820300|177.580001', '0|0'),
(18, 'Радиоцентр [SF]', 3, 7, '1221.436645|2062.462402|1009.481384|268.845611', '2|1', '1222.397705|2060.625976|1009.481384', '1226.067871|2064.188964|1009.481384', '0.000000|0.000000|0.000000', '0|0', '141|141|150|150|224|224|225|225|263|263', '188|188|250|250|170|170|217|186|223|261', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Стажер|Звукооператор|Звукорежиссер|Репортер|Ведущий|Редактор|Гл.Редактор|Тех.Редактор|Программный редактор|Директор', 'Стажер|Звукооператор|Звукорежиссер|Репортер|Ведущий|Редактор|Гл.Редактор|Тех.Редактор|Программный редактор|Директор', '0|0|0|0|0|0|0|0', '0|0|0', '507|582|0|0|0|0|0|0|0|0', '5|6|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '-2033.930053|463.773986|35.172298|359.291992', '0|0'),
(19, 'Правительство', 1, 8, '1563.702636|1106.192871|1038.629150|226.555404', '1|1', '1569.496826|1099.451782|1038.629150', '1552.452514|1103.752075|1038.629150', '1484.420043|-1831.000000|13.550000', '0|0', '76|76|76|76|76|76|76|76|219|219', '71, 98, 187, 57, 227, 228 68, 17, 147, 295', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Охранник|Начальник охраны|Адвокат|Секретарь|Министр культуры|Министр здравоохранения|Министр обороны|Генеральный прокурор|Вице-губернатор|Губернатор', 'Охранник|Начальник охраны|Адвокат|Секретарь|Министр культуры|Министр здравоохранения|Министр обороны|Генеральный прокурор|Вице-губернатор|Губернатор', '999972565|0|0|0|0|0|0|0', '0|0|0', '409|579|445|580|0|0|0|0|0|0', '2|2|2|2|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '1404.599975|-1780.140014|13.546899|87.219596', '0|0'),
(20, 'Без названия', 0, 0, '0.0|0.0|0.0|0.0', '0|0', '0.0|0.0|0.0', '0.0|0.0|0.0', '0.0|0.0|0.0', '0|0', '1|1|1|1|1|1|1|1|1|1', '1|1|1|1|1|1|1|1|1|1', '0|0|0|0|0|0|0|0|0|0', 'Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет', 'Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет|Нет', '0|0|0|0|0|0|0|0', '0|0|0', '0|0|0|0|0|0|0|0|0|0', '0|0|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '0.0|0.0|0.0', '0|0'),
(21, 'Тюрьма', 1, 9, '36.458198|1440.416503|2072.671142|90.000000', '1|1', '37.508201|1436.408813|2072.652099', '35.557300|1442.969970|2072.652099', '2415.546386|1117.030761|10.812999', '0|0', '141|306|306|306|307|307|307|307|309|309', '265|266|266|285|267|281|280|282|288|283', '3000|5000|7000|9000|11000|13000|15000|17000|19000|21000', 'Стажер|Конвоир|Ст. конвоир|Надзиратель|Ст. надзиратель|Дежурный|Врач|Инспектор|Зам. нач. тюрьмы|Начальник тюрьмы', 'Стажер|Конвоир|Ст. конвоир|Надзиратель|Ст. надзиратель|Дежурный|Врач|Инспектор|Зам. нач. тюрьмы|Начальник тюрьмы', '0|0|0|0|0|0|0|0', '0|0|0', '426|427|598|599|0|0|0|0|0|0', '4|3|2|2|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '2416.489990|1106.050048|10.820300|262.996002', '0|0'),
(22, 'Автошкола', 1, 10, '-2095.687500|-110.968399|1055.168457|90.253997', '1|1', '-2099.900390|-112.355102|1055.151367', '-2097.018066|-107.918998|1055.168457', '0.000000|0.000000|0.000000', '0|0', '172|172|172|172|172|172|172|172|194|194', '59|59|59|171|171|171|171|171|189|240', '2000|4000|6000|8000|10000|12000|14000|16000|18000|20000', 'Стажер|Консультант|Экзаменатор|Мл.Инструктор|Инструктор|Координатор|Мл.Менеджер|Ст.Менеджер|Директор|Управляющий', 'Стажер|Консультант|Экзаменатор|Мл.Инструктор|Инструктор|Координатор|Мл.Менеджер|Ст.Менеджер|Директор|Управляющий', '1052250|0|0|0|0|0|0|0', '0|0|0', '400|426|0|0|0|0|0|0|0|0', '9|8|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '-2064.229004|-84.275871|35.164062|1.289526', '0|0'),
(23, 'Bikers', 2, 11, '697.200012|1728.576416|1024.270141|179.904205', '1|1', '696.033020|1707.745361|1024.270141', '703.162719|1707.340820|1024.270141', '-1876.333129|-151.729598|11.898400', '0|0', '131|131|198|198|198|64|64|64|246|246', '181|181|100|100|100|254|254|254|248|248', '2000|4000|6000|8000|10000|12000|14000|16000|18000|20000', 'Support|Hang around|Local|Prospect|Member|Road Captain|Sergeant-at-arms|Treasurer|Vice President|President', 'Support|Hang around|Local|Prospect|Member|Road Captain|Sergeant-at-arms|Treasurer|Vice President|President', '35235|0|0|0|0|0|0|0', '0|0|0', '463|478|482|0|0|0|0|0|0|0', '20|5|5|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '-1882.449951|-135.988006|11.898400|272.263000', '0|0'),
(24, 'Радиоцентр [LV]', 3, 7, '1221.436645|2062.462402|1009.481384|268.845611', '3|1', '1222.397705|2060.625976|1009.481384', '1226.067871|2064.188964|1009.481384', '0.000000|0.000000|0.000000', '0|0', '141|141|150|150|224|224|225|225|263|263', '188|188|250|250|170|170|217|186|223|261', '4000|6000|8000|10000|12000|14000|16000|18000|20000|22000', 'Стажер|Звукооператор|Звукорежиссер|Репортер|Ведущий|Редактор|Гл.Редактор|Тех.Редактор|Программный редактор|Директор', 'Стажер|Звукооператор|Звукорежиссер|Репортер|Ведущий|Редактор|Гл.Редактор|Тех.Редактор|Программный редактор|Директор', '0|0|0|0|0|0|0|0', '0|0|0', '507|582|0|0|0|0|0|0|0|0', '6|6|0|0|0|0|0|0|0|0', '1|1|1|1|1|1|1|1|1|1', '2668.780029|1179.800048|10.820300|89.833099', '0|0'),
(25, 'Police [RC]', 1, 1, '2605.493408|2106.722167|1048.231567|272.419586', '4|1', '2605.708007|2109.354980|1048.231567', '2595.512939|2106.110595|1048.233520', '634.260681|-578.667907|16.335899', '0|0', '141|306|306|306|307|307|307|307|309|309', '265|266|280|284|285|267|281|300|310|283', '3000|5000|7000|9000|11000|13000|15000|17000|19000|21000', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шерифа|Шериф', 'Стажер|Офицер I|Офицер II|Офицер III|Сержант|Лейтенант|Капитан|Коммандер|Заместитель Шерифа|Шериф', '0|0|0|0|0|0|0|0', '0|0|0', '402|431|596|523|427|528|599|0|0|0', '3|1|3|3|2|4|4|0|0|0', '1|1|1|1|1|1|1|1|1|1', '625.357971|-598.843994|16.844100|268.544006', '0|0');

-- --------------------------------------------------------

--
-- Структура таблицы `fraction_blacklist`
--

CREATE TABLE `fraction_blacklist` (
  `f_bl_id` int(11) NOT NULL,
  `f_bl_frac` int(11) NOT NULL DEFAULT 0,
  `f_bl_player_id` int(11) NOT NULL DEFAULT 0,
  `f_bl_target_id` int(11) NOT NULL DEFAULT 0,
  `f_bl_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `f_bl_reason` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `fraction_store`
--

CREATE TABLE `fraction_store` (
  `f_ID` int(11) UNSIGNED NOT NULL,
  `f_patron` int(11) NOT NULL,
  `f_mate` int(11) NOT NULL,
  `f_money` int(11) NOT NULL,
  `f_drugs` int(11) NOT NULL,
  `f_close` int(11) NOT NULL,
  `d_close` int(11) NOT NULL DEFAULT 1,
  `f_remp` int(11) NOT NULL DEFAULT 0,
  `f_fuel` int(11) NOT NULL DEFAULT 0,
  `f_heal` int(11) NOT NULL DEFAULT 0,
  `f_mask` int(11) NOT NULL DEFAULT 0,
  `m_drugs` int(11) NOT NULL DEFAULT 5,
  `f_premia` int(11) NOT NULL DEFAULT 0,
  `f_night` int(11) NOT NULL DEFAULT 0,
  `f_day` int(11) NOT NULL DEFAULT 0,
  `f_cs` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Фракции';

--
-- Дамп данных таблицы `fraction_store`
--

INSERT INTO `fraction_store` (`f_ID`, `f_patron`, `f_mate`, `f_money`, `f_drugs`, `f_close`, `d_close`, `f_remp`, `f_fuel`, `f_heal`, `f_mask`, `m_drugs`, `f_premia`, `f_night`, `f_day`, `f_cs`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gangzone`
--

CREATE TABLE `gangzone` (
  `id` int(11) NOT NULL,
  `zone_x` float NOT NULL,
  `zone_y` float NOT NULL,
  `zone_xM` float NOT NULL,
  `zone_yM` float NOT NULL,
  `fraction` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `gangzone`
--

INSERT INTO `gangzone` (`id`, `zone_x`, `zone_y`, `zone_xM`, `zone_yM`, `fraction`) VALUES
(1, 1770.06, -1283.66, 1890.06, -1183.66, 11),
(2, 1890.06, -1283.66, 2010.06, -1183.66, 11),
(3, 1770.06, -2183.66, 1890.06, -2083.66, 13),
(4, 1890.06, -2183.66, 2010.06, -2083.66, 13),
(5, 2010.06, -2183.66, 2130.06, -2083.66, 13),
(6, 2130.06, -2183.66, 2250.06, -2083.66, 13),
(7, 2730.06, -1383.66, 2850.06, -1283.66, 14),
(8, 2610.06, -1383.66, 2730.06, -1283.66, 14),
(9, 2490.06, -1383.66, 2610.06, -1283.66, 14),
(10, 2370.06, -1383.66, 2490.06, -1283.66, 14),
(11, 2250.06, -1383.66, 2370.06, -1283.66, 14),
(12, 2130.06, -1383.66, 2250.06, -1283.66, 11),
(13, 2010.06, -1383.66, 2130.06, -1283.66, 11),
(14, 1890.06, -1383.66, 2010.06, -1283.66, 11),
(15, 1770.06, -1383.66, 1890.06, -1283.66, 11),
(16, 2730.06, -1483.66, 2850.06, -1383.66, 14),
(17, 2610.06, -1483.66, 2730.06, -1383.66, 14),
(18, 2490.06, -1483.66, 2610.06, -1383.66, 14),
(19, 2370.06, -1483.66, 2490.06, -1383.66, 14),
(20, 2250.06, -1483.66, 2370.06, -1383.66, 14),
(21, 2130.06, -1483.66, 2250.06, -1383.66, 11),
(22, 2010.06, -1483.66, 2130.06, -1383.66, 11),
(23, 1890.06, -1483.66, 2010.06, -1383.66, 11),
(24, 1770.06, -1483.66, 1890.06, -1383.66, 11),
(25, 2730.06, -1583.66, 2850.06, -1483.66, 14),
(26, 2610.06, -1583.66, 2730.06, -1483.66, 14),
(27, 2490.06, -1583.66, 2610.06, -1483.66, 14),
(28, 2370.06, -1583.66, 2490.06, -1483.66, 14),
(29, 2250.06, -1583.66, 2370.06, -1483.66, 14),
(30, 2130.06, -1583.66, 2250.06, -1483.66, 11),
(31, 2010.06, -1583.66, 2130.06, -1483.66, 11),
(32, 1890.06, -1583.66, 2010.06, -1483.66, 11),
(33, 1770.06, -1583.66, 1890.06, -1483.66, 11),
(34, 2730.06, -1683.66, 2850.06, -1583.66, 10),
(35, 2610.06, -1683.66, 2730.06, -1583.66, 10),
(36, 2490.06, -1683.66, 2610.06, -1583.66, 10),
(37, 2370.06, -1683.66, 2490.06, -1583.66, 10),
(38, 2250.06, -1683.66, 2370.06, -1583.66, 10),
(39, 2130.06, -1683.66, 2250.06, -1583.66, 12),
(40, 2010.06, -1683.66, 2130.06, -1583.66, 12),
(41, 1890.06, -1683.66, 2010.06, -1583.66, 12),
(42, 1770.06, -1683.66, 1890.06, -1583.66, 12),
(43, 2730.06, -1783.66, 2850.06, -1683.66, 10),
(44, 2610.06, -1783.66, 2730.06, -1683.66, 10),
(45, 2490.06, -1783.66, 2610.06, -1683.66, 10),
(46, 2370.06, -1783.66, 2490.06, -1683.66, 10),
(47, 2250.06, -1783.66, 2370.06, -1683.66, 10),
(48, 2130.06, -1783.66, 2250.06, -1683.66, 12),
(49, 2010.06, -1783.66, 2130.06, -1683.66, 12),
(50, 1890.06, -1783.66, 2010.06, -1683.66, 12),
(51, 1770.06, -1783.66, 1890.06, -1683.66, 12),
(52, 2730.06, -1883.66, 2850.06, -1783.66, 10),
(53, 2610.06, -1883.66, 2730.06, -1783.66, 10),
(54, 2490.06, -1883.66, 2610.06, -1783.66, 10),
(55, 2370.06, -1883.66, 2490.06, -1783.66, 10),
(56, 2250.06, -1883.66, 2370.06, -1783.66, 10),
(57, 2130.06, -1883.66, 2250.06, -1783.66, 12),
(58, 2010.06, -1883.66, 2130.06, -1783.66, 12),
(59, 1890.06, -1883.66, 2010.06, -1783.66, 12),
(60, 1770.06, -1883.66, 1890.06, -1783.66, 12),
(61, 2730.06, -1983.66, 2850.06, -1883.66, 10),
(62, 2610.06, -1983.66, 2730.06, -1883.66, 10),
(63, 2490.06, -1983.66, 2610.06, -1883.66, 10),
(64, 2370.06, -1983.66, 2490.06, -1883.66, 10),
(65, 2250.06, -1983.66, 2370.06, -1883.66, 10),
(66, 2130.06, -1983.66, 2250.06, -1883.66, 12),
(67, 2010.06, -1983.66, 2130.06, -1883.66, 12),
(68, 1890.06, -1983.66, 2010.06, -1883.66, 12),
(69, 1770.06, -1983.66, 1890.06, -1883.66, 12),
(70, 2730.06, -2083.66, 2850.06, -1983.66, 13),
(71, 2610.06, -2083.66, 2730.06, -1983.66, 13),
(72, 2490.06, -2083.66, 2610.06, -1983.66, 13),
(73, 2370.06, -2083.66, 2490.06, -1983.66, 13),
(74, 2250.06, -2083.66, 2370.06, -1983.66, 13),
(75, 2130.06, -2083.66, 2250.06, -1983.66, 13),
(76, 2010.06, -2083.66, 2130.06, -1983.66, 13),
(77, 1890.06, -2083.66, 2010.06, -1983.66, 13),
(78, 1770.06, -2083.66, 1890.06, -1983.66, 13),
(79, 1650.06, -2083.66, 1770.06, -1983.66, 13),
(80, 2730.06, -2183.66, 2850.06, -2083.66, 13),
(81, 2610.06, -2183.66, 2730.06, -2083.66, 13),
(82, 2490.06, -2183.66, 2610.06, -2083.66, 13),
(83, 2370.06, -2183.66, 2490.06, -2083.66, 13),
(84, 2250.06, -2183.66, 2370.06, -2083.66, 13),
(85, 1650.06, -2183.66, 1770.06, -2083.66, 13),
(86, 2010.06, -1283.66, 2130.06, -1183.66, 11),
(87, 2130.06, -1283.66, 2250.06, -1183.66, 11),
(88, 2250.06, -1283.66, 2370.06, -1183.66, 14),
(89, 2370.06, -1283.66, 2490.06, -1183.66, 14),
(90, 2490.06, -1283.66, 2610.06, -1183.66, 14),
(91, 2610.06, -1283.66, 2730.06, -1183.66, 14),
(92, 2730.06, -1283.66, 2850.06, -1183.66, 14),
(93, 1770.06, -1183.66, 1890.06, -1083.66, 11),
(94, 1890.06, -1183.66, 2010.06, -1083.66, 11),
(95, 2010.06, -1183.66, 2130.06, -1083.66, 11),
(96, 2130.06, -1183.66, 2250.06, -1083.66, 11),
(97, 2250.06, -1183.66, 2370.06, -1083.66, 14),
(98, 2370.06, -1183.66, 2490.06, -1083.66, 14),
(99, 2490.06, -1183.66, 2610.06, -1083.66, 14),
(100, 2610.06, -1183.66, 2730.06, -1083.66, 14),
(101, 2730.06, -1183.66, 2850.06, -1083.66, 14),
(102, 1770.06, -1083.66, 1890.06, -983.657, 11),
(103, 1890.06, -1083.66, 2010.06, -983.657, 11),
(104, 2010.06, -1083.66, 2130.06, -983.657, 11),
(105, 2130.06, -1083.66, 2250.06, -983.657, 11),
(106, 2250.06, -1083.66, 2370.06, -983.657, 14),
(107, 2370.06, -1083.66, 2490.06, -983.657, 14),
(108, 2490.06, -1083.66, 2610.06, -983.657, 14),
(109, 2610.06, -1083.66, 2730.06, -983.657, 14),
(110, 2730.06, -1083.66, 2850.06, -983.657, 14);

-- --------------------------------------------------------

--
-- Структура таблицы `garden`
--

CREATE TABLE `garden` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `object` int(11) NOT NULL DEFAULT 0,
  `day` int(11) NOT NULL DEFAULT 0,
  `house` int(11) NOT NULL DEFAULT 0,
  `biz` int(11) NOT NULL DEFAULT 0,
  `x` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `y` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `z` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `rx` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `ry` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `rz` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `graffiti`
--

CREATE TABLE `graffiti` (
  `id` int(11) NOT NULL,
  `member` int(11) NOT NULL DEFAULT 0,
  `x` varchar(15) CHARACTER SET utf8 NOT NULL,
  `y` varchar(15) CHARACTER SET utf8 NOT NULL,
  `z` varchar(15) CHARACTER SET utf8 NOT NULL,
  `rx` varchar(15) CHARACTER SET utf8 NOT NULL,
  `ry` varchar(15) CHARACTER SET utf8 NOT NULL,
  `rz` varchar(15) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `graffiti`
--

INSERT INTO `graffiti` (`id`, `member`, `x`, `y`, `z`, `rx`, `ry`, `rz`) VALUES
(1, 12, '1670.564209', '-2134.822754', '13.946874', '0.000000', '0.000000', '134.500015'),
(2, 11, '1784.795654', '-1969.374634', '14.427193', '0.000000', '0.000000', '0.000000'),
(3, 13, '2044.400757', '-2051.402100', '14.016879', '0.000000', '0.000000', '89.700027'),
(4, 13, '2334.759766', '-2021.357666', '14.106874', '0.000000', '0.000000', '0.000000'),
(5, 11, '2459.494385', '-1965.181519', '13.964016', '0.000000', '0.000000', '0.000000'),
(6, 12, '2654.028809', '-2048.208984', '14.035238', '0.000000', '0.000000', '-179.799988'),
(7, 13, '2481.105225', '-1882.701538', '13.876882', '0.000000', '0.000000', '0.000000'),
(8, 12, '2518.559570', '-1713.200684', '13.981430', '0.000000', '0.000000', '-89.499969'),
(9, 10, '2275.636719', '-1671.633667', '15.847047', '0.000000', '0.000000', '-179.500107'),
(10, 11, '2136.942139', '-1687.848755', '15.755939', '0.000000', '0.000000', '-89.800156'),
(11, 12, '1992.771118', '-1569.101929', '14.177441', '0.000000', '0.000000', '-45.099995'),
(12, 11, '1799.126587', '-1719.609863', '14.009102', '0.000000', '0.000000', '179.899963'),
(13, 10, '1789.236694', '-1251.309204', '14.211884', '0.000000', '0.000000', '0.000000'),
(14, 11, '1966.076172', '-1272.317749', '24.520807', '0.000000', '0.000000', '-179.900085'),
(15, 11, '2093.376709', '-1345.667358', '24.474386', '0.000000', '0.000000', '-90.000000'),
(16, 13, '2204.212646', '-1336.696655', '24.464386', '0.000000', '0.000000', '-179.799973'),
(17, 11, '2313.340820', '-1286.876953', '24.485134', '0.000000', '0.000000', '0.000000'),
(18, 11, '2352.007324', '-1267.375122', '23.001984', '0.000000', '0.000000', '0.000000'),
(19, 10, '2425.214600', '-1339.552124', '24.496853', '0.000000', '0.000000', '0.000000'),
(20, 10, '2461.031006', '-1214.875610', '32.400265', '0.000000', '0.000000', '0.000000'),
(21, 11, '2561.073242', '-1199.346558', '61.425797', '0.000000', '0.000000', '179.099945'),
(22, 11, '2678.971191', '-1105.719116', '69.866096', '0.000000', '0.000000', '89.999992'),
(23, 13, '2811.351562', '-1270.094482', '46.903084', '0.000000', '0.000000', '-89.999977'),
(24, 11, '2808.080078', '-1376.398682', '21.781799', '0.000000', '0.000000', '86.199883'),
(25, 13, '2778.520020', '-1413.143066', '25.355349', '0.000000', '0.000000', '179.499924'),
(26, 14, '2808.300537', '-1587.975342', '11.753757', '0.000000', '0.000000', '-22.600010'),
(27, 14, '2794.288574', '-1647.366821', '11.487943', '0.000000', '0.000000', '90.800049'),
(28, 11, '2652.995605', '-1630.254517', '11.630191', '0.000000', '0.000000', '0.000000'),
(29, 11, '2505.281982', '-1465.062012', '24.711895', '0.000000', '0.000000', '-90.000038'),
(30, 11, '2355.071289', '-1479.654297', '24.639082', '0.000000', '0.000000', '-90.900032'),
(31, 11, '2333.451904', '-1336.055176', '24.733406', '0.000000', '0.000000', '90.700035'),
(32, 11, '2100.521484', '-1450.978516', '24.670015', '0.000000', '0.000000', '89.400078'),
(33, 11, '2135.421631', '-1729.744019', '14.181179', '0.000000', '0.000000', '-89.199951'),
(34, 10, '2131.928467', '-1786.079102', '14.301256', '0.000000', '0.000000', '91.000031'),
(35, 12, '2041.725952', '-1823.724609', '14.166887', '0.000000', '0.000000', '-0.699996'),
(36, 11, '2131.648682', '-1874.898193', '14.226884', '0.000000', '0.000000', '0.000000'),
(37, 12, '2233.279053', '-2000.397217', '14.096878', '0.000000', '0.000000', '0.000000'),
(38, 11, '2423.751465', '-2100.929199', '14.213838', '0.000000', '0.000000', '0.000000'),
(39, 10, '2702.733398', '-2065.289062', '14.191632', '0.000000', '0.000000', '-89.800011'),
(40, 12, '2725.689453', '-2019.233643', '14.184696', '0.000000', '0.000000', '-89.999855'),
(41, 12, '1822.544556', '-1450.938843', '14.318274', '0.000000', '0.000000', '90.099922'),
(42, 10, '1815.967407', '-1311.414185', '14.357536', '0.000000', '0.000000', '0.000000'),
(43, 10, '1907.502441', '-1305.704346', '14.291104', '0.000000', '0.000000', '91.800003'),
(44, 10, '1964.515381', '-1305.697510', '24.340712', '0.000000', '0.000000', '90.100037'),
(45, 11, '2153.942627', '-1031.744385', '63.084427', '0.000000', '0.000000', '-160.600204'),
(46, 13, '2038.705933', '-1007.275757', '40.592167', '0.000000', '0.000000', '95.400009'),
(47, 11, '2119.435791', '-1004.670288', '58.940002', '0.000000', '0.000000', '-106.600060'),
(48, 10, '2258.285645', '-1029.259766', '53.512318', '0.000000', '0.000000', '135.000046'),
(49, 11, '2687.559814', '-1101.028442', '70.302628', '0.000000', '0.000000', '0.000000'),
(50, 11, '2789.366699', '-1094.422729', '31.618761', '0.000000', '0.000000', '89.000076'),
(51, 11, '2756.059082', '-1322.159912', '47.527203', '0.000000', '0.000000', '-89.999992'),
(52, 10, '1833.264282', '-1248.953003', '14.412596', '0.000000', '0.000000', '179.799896'),
(53, 11, '1855.302002', '-1069.572388', '24.645624', '0.000000', '0.000000', '-90.600067'),
(54, 12, '2052.163330', '-1045.645264', '27.260344', '0.000000', '0.000000', '68.099953'),
(55, 11, '2137.517334', '-1077.463013', '28.049076', '0.000000', '0.000000', '-27.499989'),
(56, 11, '2191.190430', '-1091.161499', '31.181883', '0.000000', '0.000000', '65.800003'),
(57, 11, '2291.846924', '-1103.015015', '38.816578', '0.000000', '0.000000', '80.499962'),
(58, 11, '2654.274170', '-1327.093384', '39.864925', '0.000000', '0.000000', '92.000038'),
(59, 14, '2146.187744', '-2317.768311', '14.208887', '0.000000', '0.000000', '44.499981'),
(60, 12, '2109.964111', '-2126.058838', '14.412822', '0.000000', '0.000000', '-179.999985'),
(61, 11, '1915.702393', '-1866.744385', '14.385781', '0.000000', '0.000000', '0.000000'),
(62, 11, '2249.850586', '-1692.385742', '14.410923', '0.000000', '0.000000', '-89.999977'),
(63, 14, '2437.562256', '-1680.935791', '14.567616', '0.000000', '0.000000', '-91.200035'),
(64, 11, '2383.111816', '-1468.285645', '24.622871', '0.000000', '0.000000', '-179.500015'),
(65, 12, '2335.034424', '-1315.068359', '24.861086', '0.000000', '0.000000', '179.600006'),
(66, 12, '2474.262939', '-1331.161377', '28.230841', '0.000000', '0.000000', '179.600067'),
(67, 10, '2381.066162', '-1398.083740', '24.683767', '0.000000', '0.000000', '179.199936'),
(68, 13, '2038.001099', '-1781.888306', '14.403287', '0.000000', '0.000000', '-89.199974'),
(69, 14, '2405.172607', '-2059.239990', '14.326884', '0.000000', '0.000000', '90.100014'),
(70, 12, '1806.287476', '-1419.269775', '14.251878', '0.000000', '0.000000', '90.699997'),
(71, 10, '1938.990112', '-2039.854736', '14.166879', '0.000000', '0.000000', '90.100021'),
(72, 12, '2138.867188', '-1914.789551', '14.446877', '0.000000', '0.000000', '0.000000'),
(73, 13, '2402.303955', '-1883.427612', '14.416880', '0.000000', '0.000000', '90.700073'),
(74, 12, '2442.167725', '-1758.282349', '14.290687', '0.000000', '0.000000', '90.100029'),
(75, 10, '2483.520508', '-1354.418335', '29.498669', '0.000000', '0.000000', '87.099968'),
(76, 12, '2391.131104', '-1205.504150', '28.020361', '0.000000', '0.000000', '179.199921'),
(77, 11, '2247.331299', '-1077.984375', '42.503525', '0.000000', '0.000000', '-40.700016'),
(78, 10, '2124.563965', '-1164.894409', '24.887112', '0.000000', '0.000000', '0.000000'),
(79, 11, '2369.835205', '-1550.781738', '24.870768', '0.000000', '0.000000', '88.499985'),
(80, 13, '2566.655029', '-2125.340820', '1.425953', '0.000000', '0.000000', '89.900063'),
(81, 11, '2613.209961', '-1932.433838', '4.519377', '0.000000', '0.000000', '0.000000'),
(82, 11, '2785.266113', '-1417.693970', '16.910006', '0.000000', '0.000000', '-179.799988'),
(83, 11, '2081.804443', '-1858.651733', '4.594377', '0.000000', '0.000000', '-89.900002'),
(84, 11, '2014.052612', '-1912.534180', '8.844383', '0.000000', '0.000000', '-134.800110'),
(85, 11, '2132.328613', '-2010.881470', '8.744383', '0.000000', '0.000000', '45.000019'),
(86, 12, '2258.672119', '-2183.563232', '9.590669', '0.000000', '0.000000', '135.200150'),
(87, 11, '2221.614990', '-2122.545898', '8.679949', '0.000000', '0.000000', '-134.300079'),
(88, 11, '2264.549805', '-2144.948975', '6.839761', '0.000000', '0.000000', '44.699986'),
(89, 11, '1820.760498', '-1810.875610', '4.634378', '0.000000', '0.000000', '76.000015'),
(90, 10, '2121.693359', '-1556.139526', '13.976476', '0.000000', '0.000000', '70.000069'),
(91, 12, '2106.109863', '-1493.890259', '11.149434', '0.000000', '0.000000', '70.799957'),
(92, 10, '1863.272339', '-1293.557373', '14.223299', '0.000000', '0.000000', '91.300079'),
(93, 11, '1806.127808', '-1128.954834', '24.785952', '0.000000', '0.000000', '89.900009'),
(94, 10, '1840.127686', '-1034.801758', '25.696541', '0.000000', '0.000000', '98.599945'),
(95, 12, '2053.404297', '-1036.418335', '26.947014', '0.000000', '0.000000', '-19.799992'),
(96, 11, '2174.126465', '-1080.811768', '36.448719', '0.000000', '0.000000', '156.899841'),
(97, 11, '2259.963623', '-1090.251831', '42.431519', '0.000000', '0.000000', '52.999989'),
(98, 11, '2270.842773', '-1099.968750', '38.636555', '0.000000', '0.000000', '155.199997'),
(99, 12, '2391.114502', '-1244.946533', '25.117483', '0.000000', '0.000000', '-179.800278'),
(100, 11, '2044.110352', '-1982.319458', '14.284522', '0.000000', '0.000000', '-90.399963'),
(101, 12, '2403.796143', '-2038.039307', '14.366883', '0.000000', '0.000000', '-179.899841'),
(102, 11, '2365.856689', '-1928.983521', '14.264754', '0.000000', '0.000000', '0.000000'),
(103, 11, '1812.495972', '-2065.954590', '14.334499', '0.000000', '0.000000', '0.000000'),
(104, 10, '2422.541504', '-1372.330322', '25.242992', '0.000000', '0.000000', '-89.999878'),
(105, 11, '1997.331299', '-1353.388550', '24.524387', '0.000000', '0.000000', '-179.800247'),
(106, 10, '1986.285889', '-1248.866089', '20.886610', '0.000000', '0.000000', '-171.700073'),
(107, 11, '1797.612549', '-1705.445923', '14.137946', '0.000000', '0.000000', '-89.800110'),
(108, 10, '1966.058594', '-1325.260864', '24.655409', '0.000000', '0.000000', '0.000000'),
(109, 12, '2523.287598', '-1354.434692', '29.437838', '0.000000', '0.000000', '93.000023'),
(110, 11, '2685.885498', '-1391.071777', '31.790543', '0.000000', '0.000000', '89.900085');

-- --------------------------------------------------------

--
-- Структура таблицы `hostnames`
--

CREATE TABLE `hostnames` (
  `hostname` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `weburl` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `gamemode` varchar(64) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `hostnames`
--

INSERT INTO `hostnames` (`hostname`, `weburl`, `gamemode`) VALUES
('hostname Flin RolePlay | Server: 01', 'weburl vk.com', 'Flin RolePlay');

-- --------------------------------------------------------

--
-- Структура таблицы `hotel_rooms`
--

CREATE TABLE `hotel_rooms` (
  `hr_mysql_id` int(11) NOT NULL,
  `hr_owner` varchar(32) CHARACTER SET cp1251 NOT NULL DEFAULT 'None',
  `hr_user_id` int(11) NOT NULL DEFAULT 0,
  `hr_rent` int(11) NOT NULL DEFAULT 1,
  `hr_hotel_id` int(11) NOT NULL,
  `hr_room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `hotel_rooms`
--

INSERT INTO `hotel_rooms` (`hr_mysql_id`, `hr_owner`, `hr_user_id`, `hr_rent`, `hr_hotel_id`, `hr_room_id`) VALUES
(1, 'None', 0, 0, 63, 0),
(2, 'None', 0, 0, 63, 1),
(3, 'None', 0, 0, 63, 2),
(4, 'None', 0, 0, 63, 3),
(5, 'None', 0, 0, 63, 4),
(6, 'None', 0, 0, 63, 5),
(7, 'None', 0, 0, 63, 6),
(8, 'None', 0, 0, 63, 7),
(9, 'None', 0, 0, 63, 8),
(10, 'None', 0, 0, 63, 9),
(11, 'None', 0, 0, 63, 10),
(12, 'None', 0, 0, 63, 11),
(13, 'None', 0, 0, 64, 0),
(14, 'None', 0, 0, 64, 1),
(15, 'None', 0, 0, 64, 2),
(16, 'None', 0, 0, 64, 3),
(17, 'None', 0, 0, 64, 4),
(18, 'None', 0, 0, 64, 5),
(19, 'None', 0, 0, 64, 6),
(20, 'None', 0, 0, 64, 7),
(21, 'None', 0, 0, 64, 8),
(22, 'None', 0, 0, 64, 9),
(23, 'None', 0, 0, 64, 10),
(24, 'None', 0, 0, 64, 11),
(25, 'None', 0, 0, 65, 0),
(26, 'None', 0, 0, 65, 1),
(27, 'None', 0, 0, 65, 2),
(28, 'None', 0, 0, 65, 3),
(29, 'None', 0, 0, 65, 4),
(30, 'None', 0, 0, 65, 5),
(31, 'None', 0, 0, 65, 6),
(32, 'None', 0, 0, 65, 7),
(33, 'None', 0, 0, 65, 8),
(34, 'None', 0, 0, 65, 9),
(35, 'None', 0, 0, 65, 10),
(36, 'None', 0, 0, 65, 11),
(37, 'None', 0, 0, 66, 0),
(38, 'None', 0, 0, 66, 1),
(39, 'None', 0, 0, 66, 2),
(40, 'None', 0, 0, 66, 3),
(41, 'None', 0, 0, 66, 4),
(42, 'None', 0, 0, 66, 5),
(43, 'None', 0, 0, 66, 6),
(44, 'None', 0, 0, 66, 7),
(45, 'None', 0, 0, 66, 8),
(46, 'None', 0, 0, 66, 9),
(47, 'None', 0, 0, 66, 10),
(48, 'None', 0, 0, 66, 11),
(49, 'None', 0, 0, 67, 0),
(50, 'None', 0, 0, 67, 1),
(51, 'None', 0, 0, 67, 2),
(52, 'None', 0, 0, 67, 3),
(53, 'None', 0, 0, 67, 4),
(54, 'None', 0, 0, 67, 5),
(55, 'None', 0, 0, 67, 6),
(56, 'None', 0, 0, 67, 7),
(57, 'None', 0, 0, 67, 8),
(58, 'None', 0, 0, 67, 9),
(59, 'None', 0, 0, 67, 10),
(60, 'None', 0, 0, 67, 11);

-- --------------------------------------------------------

--
-- Структура таблицы `house`
--

CREATE TABLE `house` (
  `h_mysql_id` int(11) UNSIGNED NOT NULL,
  `h_user_id` int(11) NOT NULL DEFAULT 0,
  `h_enterx` float NOT NULL DEFAULT 0,
  `h_entery` float NOT NULL DEFAULT 0,
  `h_enterz` float NOT NULL DEFAULT 0,
  `h_entera` float NOT NULL DEFAULT 0,
  `h_exitx` float NOT NULL DEFAULT 0,
  `h_exity` float NOT NULL DEFAULT 0,
  `h_exitz` float NOT NULL DEFAULT 0,
  `h_rent` int(11) NOT NULL DEFAULT 0,
  `h_owner` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `h_value` int(11) NOT NULL DEFAULT 0,
  `h_int` int(11) NOT NULL DEFAULT 0,
  `h_lock` int(11) NOT NULL DEFAULT 0,
  `h_owned` int(11) NOT NULL DEFAULT 0,
  `h_squar` int(11) NOT NULL DEFAULT 0,
  `h_g_lock` int(11) NOT NULL DEFAULT 0,
  `h_attic_lock` int(11) NOT NULL DEFAULT 0,
  `h_underground_lock` int(11) NOT NULL DEFAULT 0,
  `h_family_id` int(11) NOT NULL DEFAULT -1,
  `h_g_count` int(11) NOT NULL DEFAULT 0,
  `h_g_enterx` float NOT NULL DEFAULT 0,
  `h_g_entery` float NOT NULL DEFAULT 0,
  `h_g_enterz` float NOT NULL DEFAULT 0,
  `h_g_enterr` float NOT NULL DEFAULT 0,
  `h_improve_0` int(11) NOT NULL DEFAULT 0,
  `h_improve_1` int(11) NOT NULL DEFAULT 0,
  `h_improve_2` int(11) NOT NULL DEFAULT 0,
  `h_improve_3` int(11) NOT NULL DEFAULT 0,
  `h_r_user_id_0` int(11) NOT NULL DEFAULT 0,
  `h_r_user_id_1` int(11) NOT NULL DEFAULT 0,
  `h_r_user_id_2` int(11) NOT NULL DEFAULT 0,
  `h_r_user_id_3` int(11) NOT NULL DEFAULT 0,
  `h_r_user_id_4` int(11) NOT NULL DEFAULT 0,
  `h_r_price_0` int(11) NOT NULL DEFAULT 0,
  `h_r_price_1` int(11) NOT NULL DEFAULT 0,
  `h_r_price_2` int(11) NOT NULL DEFAULT 0,
  `h_r_price_3` int(11) NOT NULL DEFAULT 0,
  `h_r_price_4` int(11) NOT NULL DEFAULT 0,
  `h_r_days_0` int(11) NOT NULL DEFAULT 0,
  `h_r_days_1` int(11) NOT NULL DEFAULT 0,
  `h_r_days_2` int(11) NOT NULL DEFAULT 0,
  `h_r_days_3` int(11) NOT NULL DEFAULT 0,
  `h_r_days_4` int(11) NOT NULL DEFAULT 0,
  `h_auction_bet` int(11) NOT NULL DEFAULT 0,
  `h_auction_time` int(11) NOT NULL DEFAULT 0,
  `h_auction_user_id` int(11) NOT NULL DEFAULT 0,
  `h_mapping_id` varchar(166) COLLATE utf8mb4_unicode_ci DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `h_garage_id` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT '0|0|0',
  `h_owned_at` int(11) NOT NULL DEFAULT 0,
  `h_paydays_received` int(11) NOT NULL DEFAULT 0,
  `h_delete` int(11) NOT NULL DEFAULT 0,
  `h_delete_time` int(11) NOT NULL DEFAULT 0,
  `h_garden_items` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `h_panel_items` int(11) NOT NULL DEFAULT 0,
  `h_gate_pos` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `h_air_pos` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `h_boat_status` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Дома игроков';

--
-- Дамп данных таблицы `house`
--

INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(1, 0, 2523.27, -1679.29, 15.497, 0, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 0, 2516.07, -1672.63, 13.8422, 290.961, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(2, 0, 2524.71, -1658.69, 15.824, 89.2441, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 2516.73, -1666.22, 13.9391, 279.823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(3, 0, 2513.84, -1650.37, 14.3557, 133.816, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 2504.94, -1653.19, 13.5938, 293.946, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(4, 0, 2498.53, -1642.25, 14.1131, 181.302, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 2499.24, -1650.35, 13.559, 357.577, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(5, 0, 2486.36, -1644.53, 14.0772, 181.201, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 2482.52, -1652.83, 13.4688, 13.8936, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(6, 0, 2514.43, -1691.49, 14.046, 50.7979, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2509.13, -1685.27, 13.562, 226.022, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(7, 0, 2495.53, -1691.14, 14.7656, 4.36161, 222.934, 1287.87, 1082.14, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 2, 2505.41, -1685.5, 13.5469, 175.481, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(8, 0, 2469.38, -1646.35, 13.7801, 175.146, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2463.8, -1652.76, 13.4704, 109.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(9, 0, 2452, -1641.41, 14.0662, 183.253, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 0, 2442.34, -1643.98, 13.4673, 7.65024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(10, 0, 2413.74, -1646.79, 14.0119, 186.504, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 1, -1, 1, 2424.79, -1649.81, 13.5469, 354.153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(11, 0, 2393.07, -1646.03, 13.9051, 181.06, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 2403.11, -1645.55, 13.5469, 355.093, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(12, 0, 2362.81, -1643.14, 14.3516, 183.947, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 2371.51, -1644.77, 13.5185, 0.420112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(13, 0, 2368.29, -1675.33, 14.1682, 1.24411, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2361.55, -1672.61, 13.5464, 174.635, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(14, 0, 2384.69, -1675.84, 15.2457, 1.24411, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2393.31, -1667.32, 13.4942, 175.309, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(15, 0, 2408.93, -1674.93, 14.375, 14.1242, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2412.84, -1665.76, 13.5469, 173.742, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(16, 0, 2326.88, -1681.9, 14.9297, 274.763, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 2326.35, -1677.32, 14.4219, 90.7077, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(17, 0, 2326.71, -1716.7, 14.2379, 174.579, 421.536, 2536.47, 10, 0, 'The State', 250000, 2, 1, 1, 2, 1, 0, 0, -1, 2, 2319.1, -1719.21, 13.5469, 347.307, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(18, 0, 2308.85, -1714.33, 14.9801, 174.579, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2295.85, -1718.58, 13.5545, 0.779841, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(19, 0, 2067.06, -1731.53, 14.2066, 271.791, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 1, 2072.92, -1738.41, 13.5469, 87.8877, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(20, 0, 2066.24, -1717.23, 14.1363, 274.678, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2076.81, -1721.66, 13.3906, 87.5744, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(21, 0, 2065.1, -1703.56, 14.1484, 274.678, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2057.02, -1694.57, 13.5547, 88.2011, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(22, 0, 2066.74, -1656.47, 14.1328, 274.678, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2074.53, -1658.65, 13.5469, 91.9611, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(23, 0, 2067.57, -1643.81, 14.1363, 274.678, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2054.14, -1636.27, 13.5469, 88.8277, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(24, 0, 1980.39, -1719.1, 17.0305, 274.678, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 1983.92, -1728.36, 15.9688, 82.561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(25, 0, 1980.99, -1682.86, 17.0538, 274.678, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 1984.11, -1692.06, 15.9612, 90.3945, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(26, 0, 2013.58, -1656.37, 14.1363, 93.5121, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2008.1, -1652.87, 13.5469, 263.669, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(27, 0, 2016.54, -1641.56, 14.1129, 93.5121, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2028.01, -1649.14, 13.5547, 269.31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(28, 0, 2018.04, -1629.9, 14.0426, 93.5121, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2008.61, -1629.64, 13.5469, 268.056, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|-1|14|14|-1|-1|-1|-1|20|-1|3|6|-1|-1|-1|-1|-1|1|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(29, 0, 992.709, -1817.65, 13.8942, 348.909, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 989.593, -1814.2, 14.1467, 160.895, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(30, 0, 981.041, -1814.85, 13.8887, 348.909, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 2, 979.78, -1810.38, 14.2457, 42.2483, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(31, 0, 969.689, -1812.05, 13.8837, 348.909, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 969.072, -1804.22, 14.2592, 161.695, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(32, 0, 957.998, -1809.15, 13.8815, 348.909, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 954.265, -1801.73, 14.287, 166.56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(33, 0, 933.707, -1805.21, 13.8433, 348.909, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 939.289, -1804.73, 13.8444, 179.719, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(34, 0, 921.886, -1803.88, 13.8378, 348.909, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 926.385, -1801.51, 13.6905, 174.079, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(35, 0, 910.065, -1802.67, 13.7991, 348.909, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 913.536, -1800.55, 13.7002, 172.825, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(36, 0, 797.238, -1729.52, 13.5469, 277.46, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 803.379, -1734.03, 13.5469, 84.9507, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(37, 0, 793.975, -1707.48, 14.0382, 277.46, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 803.708, -1706.63, 13.5469, 99.9908, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|-1|32|5|-1|-1|-1|-1|18|-1|10|38|-1|-1|-1|-1|-1|6|-1|-1|57|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(38, 0, 984.713, -1829.77, 13.3307, 165.952, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 1, -1, 2, 982.844, -1836.37, 12.6107, 345.137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 1772570068, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(39, 0, 961.346, -1824.02, 13.3275, 168.905, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 962.061, -1831.65, 12.6021, 333.857, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(40, 0, 315.843, -1769.43, 4.62219, 166.034, 222.934, 1287.87, 1082.14, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 1, -1, 2, 322.536, -1773.8, 4.82185, 0.902005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 1772569272, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(41, 0, 305.244, -1770.22, 4.53808, 177.679, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 305.567, -1775.84, 4.52832, 35.4182, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(42, 0, 295.308, -1764.12, 4.86834, 179.038, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 294.742, -1774.66, 4.43229, 353.456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(43, 0, 281.048, -1767.35, 4.54898, 179.038, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 281.09, -1774.9, 4.27915, 358.47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '42|-1|-1|56|5|-1|-1|-1|-1|55|-1|14|74|-1|-1|-1|-1|-1|6|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(44, 0, 264.058, -1765.58, 4.75655, 179.038, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 263.518, -1774.36, 4.18435, 355.023, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(45, 0, 250.496, -1766.03, 4.75568, 179.038, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 250.292, -1773.84, 4.17681, 355.963, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(46, 0, 230.808, -1769.55, 4.47903, 179.038, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 230.795, -1774.08, 4.18635, 0.976584, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(47, 0, 216.525, -1766.94, 4.66618, 179.038, 222.934, 1287.87, 1082.14, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 1, 216.23, -1776.64, 3.92865, 356.251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(48, 0, 206.917, -1768.88, 4.36923, 177.549, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 206.503, -1773.36, 3.92327, 355.963, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(49, 0, 192.833, -1769.4, 4.3283, 177.549, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 192.57, -1773.76, 3.84807, 353.143, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(50, 0, 168.181, -1768.4, 4.48662, 177.549, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 2, 167.832, -1774.59, 4.2132, 0.533025, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(51, 0, 2307.11, -1679.2, 14.3316, 358.752, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2308.66, -1668.41, 14.4981, 171.118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(52, 0, 2282.27, -1641.22, 15.8898, 177.279, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2270.95, -1645.35, 15.3744, 358.807, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(53, 0, 2244.38, -1637.59, 16.2379, 158.221, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2235.17, -1640.97, 15.5216, 340.947, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(54, 0, 2178.27, -1660.27, 14.9776, 216.58, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2177.34, -1664.78, 15.0859, 29.5139, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(55, 0, 2192.42, -1815.23, 13.5469, 359.046, 421.536, 2536.47, 10, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 0, 2188.43, -1809.43, 13.3749, 180.424, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(56, 0, 2144.56, -1688.91, 15.0859, 348.992, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2148.38, -1684.84, 15.0859, 180.227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(57, 0, 2157.23, -1709.22, 15.0859, 358.862, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2162.52, -1704.71, 15.0859, 176.759, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(58, 0, 2155.86, -1698.51, 15.0859, 178.548, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2160.65, -1700.1, 15.0859, 5.05024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '14|-1|-1|14|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(59, 0, 2139.32, -1697.51, 15.0784, 173.837, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2143.14, -1700.95, 15.0859, 352.203, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(60, 0, 2140.59, -1708.3, 15.0859, 0.365839, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2134.84, -1707.01, 15.0859, 172.372, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '13|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(61, 0, 1974.63, -1671.2, 15.9688, 181.921, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1972.49, -1674.5, 15.9688, 359.434, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(62, 0, 1986.72, -1604.92, 13.5321, 221.652, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 1989.36, -1597.87, 13.5667, 48.9406, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(63, 0, 2002.45, -1593.97, 13.5776, 217.814, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2013.47, -1597.18, 13.5728, 314.94, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|14|-1|14|6|-1|-1|-1|-1|-1|56|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(64, 0, 1972.79, -1560.02, 13.6394, 216.169, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 1978.1, -1559.72, 13.6399, 36.0939, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(65, 0, 1958.64, -1560.38, 13.5942, 215.973, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 1951.63, -1562.75, 13.6167, 36.4072, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(66, 0, 1909.7, -1597.49, 14.3062, 179.931, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 1909.92, -1606.3, 13.5469, 1.65007, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(67, 0, 1863.45, -1597.28, 14.3062, 181.269, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 1866.4, -1605.36, 13.5391, 358.83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(68, 0, 1853.93, -1914.26, 15.2568, 179.839, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 1846.13, -1883.76, 13.4314, 178.395, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(69, 0, 1872.1, -1911.79, 15.2568, 171.808, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 1867.67, -1882.94, 13.4525, 178.395, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(70, 0, 1891.98, -1914.4, 15.2568, 181.796, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1896.81, -1883.57, 13.4809, 178.395, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(71, 0, 1913.34, -1911.91, 15.2568, 181.796, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1910.02, -1883.9, 13.5095, 176.829, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|14|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(72, 0, 1928.64, -1915.91, 15.2568, 178.427, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 0, 1934.55, -1883.05, 13.5334, 180.589, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(73, 0, 1938.54, -1911.44, 15.2568, 91.8446, 421.536, 2536.47, 10, 0, 'The State', 250000, 2, 1, 1, 2, 1, 0, 0, -1, 1, 1939.4, -1925.97, 13.5469, 279.916, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(74, 0, 1906.24, -2040.86, 13.5469, 169.16, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1901.72, -2045.66, 13.5469, 0.443672, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(75, 0, 1873.55, -2070.76, 15.4971, 356.966, 421.536, 2536.47, 10, 0, 'The State', 250000, 2, 1, 1, 2, 1, 0, 0, -1, 2, 1876.4, -2058.05, 13.5469, 178.732, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(76, 0, 1895.56, -2068.92, 15.6689, 1.55255, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1898.11, -2057.84, 13.5469, 190.012, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(77, 0, 1421.81, -886.227, 50.6862, 352.658, 421.536, 2536.47, 10, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 3, 1431.55, -883.602, 50.7183, 173.092, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(78, 0, 1468.54, -906.184, 54.8359, 359.395, 421.536, 2536.47, 10, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 0, 1463.91, -903.929, 54.8359, 170.585, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(79, 0, 1535.92, -885.451, 57.6575, 311.963, 421.536, 2536.47, 10, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 1518.19, -875.107, 62.1776, 230.746, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(80, 0, 1540.46, -851.484, 64.3361, 81.6454, 421.536, 2536.47, 10, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 4, 1534.44, -841.965, 64.9757, 279.821, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(81, 0, 1535.03, -800.156, 72.8495, 91.9072, 421.536, 2536.47, 10, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 4, 1532.84, -813.665, 72.1126, 273.047, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(82, 0, 1527.69, -772.462, 80.5781, 135.03, 421.536, 2536.47, 10, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1512.29, -768.361, 80.6672, 303.659, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(83, 0, 1496.97, -687.894, 95.5633, 167.735, 2324.42, -1148.46, 1050.71, 0, 'Boot_Heyn', 1500000, 0, 1, 1, 4, 1, 1, 1, -1, 2, 1517.7, -693.314, 94.75, 270.227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 1772463705, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(84, 0, 1094.11, -807.111, 107.418, 6.87555, -68.3739, 1355.14, 1080.21, 294, 'The State', 1500000, 4, 1, 1, 4, 1, 1, 0, -1, 3, 1076.35, -777.22, 107.669, 182.539, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '4|6|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(85, 0, 1034.94, -813.137, 101.852, 23.5882, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 3, 1028.48, -809.586, 101.852, 200.753, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(86, 0, 1017.03, -763.359, 112.563, 356.265, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 1025.24, -777.366, 103.181, 1.79089, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(87, 0, 989.941, -828.564, 95.4686, 29.6515, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 4, 980.384, -831.647, 95.4753, 206.76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(88, 0, 937.721, -848.782, 93.5773, 29.9806, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 1, 945.047, -841.931, 94.0215, 208.326, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(89, 0, 910.402, -817.535, 103.126, 23.103, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 1, 914.69, -836.027, 92.8983, 24.0843, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(90, 0, 923.922, -853.424, 93.4565, 293.567, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 0, 928.468, -849.479, 93.5152, 202.036, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(91, 0, 859.261, -828.391, 89.5017, 29.4638, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 852.166, -829.286, 89.5017, 202.663, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(92, 0, 874.92, -877.122, 77.8093, 24.192, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 3, 1, 1, 3, 1, 0, 0, -1, 1, 870.48, -866.95, 77.4871, 204.253, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(93, 0, 827.815, -857.982, 70.3308, 195.994, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 832.242, -858.018, 69.9219, 15.0209, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(94, 0, 835.836, -894.76, 68.7689, 326.593, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 4, 833.322, -889.291, 68.7734, 144.092, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(95, 0, 731.339, -1012.88, 52.7379, 149.989, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, 727.17, -995.527, 52.7344, 239.973, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(96, 0, 673.116, -1020.16, 55.7596, 54.9312, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 685.909, -1025.22, 51.386, 68.2878, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(97, 0, 700.094, -1060.49, 49.4217, 54.9312, 421.536, 2536.47, 10, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 3, 686.633, -1072.64, 49.5357, 238.799, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '65|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(98, 0, 612.174, -1085.92, 58.8267, 38.0267, 421.536, 2536.47, 10, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 2, 619.465, -1102.52, 46.7001, 32.591, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(99, 0, 565.372, -1113.55, 62.8064, 36.0841, 421.536, 2536.47, 10, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 568.825, -1132.74, 50.6667, 28.831, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|61|-1|7|8|16|32|-1|-1|12|78|7|8|29|3|1|-1|-1|0|4|5|6|6|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(100, 0, 559.167, -1160.85, 54.4297, 33.5932, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 1, 560.484, -1152.81, 52.3832, 205.866, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(101, 0, 470.318, -1163.69, 67.217, 196.113, 222.934, 1287.87, 1082.14, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 4, 474.053, -1178.35, 63.4116, 10.9939, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(102, 0, 352.334, -1197.61, 76.5156, 38.074, 421.536, 2536.47, 10, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 3, 348.056, -1199.27, 76.5156, 214.976, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(103, 0, 300.405, -1154.61, 81.391, 136.164, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 2, 286.682, -1155.78, 80.9099, 44.231, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(104, 0, 251.553, -1220.13, 76.1024, 212.986, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 1, 260.419, -1220.71, 74.7891, 32.3476, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(105, 0, 648.385, -1058.48, 52.5799, 46.6831, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 1, 659.206, -1064.85, 48.8837, 138.148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|6|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(106, 0, 253.01, -1270.14, 74.4306, 36.4372, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, 279.548, -1252.12, 73.9023, 122.121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|20|-1|20|14|-1|-1|20|55|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(107, 0, 254.837, -1366.85, 52.6765, 299.593, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 1, 251.469, -1358.89, 53.1094, 125.408, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(108, 0, 298.285, -1338.04, 53.0282, 38.9754, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 1, 293.376, -1337.63, 53.4406, 214.083, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(109, 0, 354.949, -1280.53, 53.2713, 22.9836, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 2, 359.283, -1274.66, 53.7834, 202.489, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2|5|-1|6|8|0|0|-1|-1|3|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(110, 0, 552.805, -1200.29, 44.4026, 17.4219, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 543.042, -1201.84, 44.4038, 197.789, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(111, 0, 645.793, -1117.56, 43.7811, 46.4722, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 2, 637.433, -1122.81, 44.3623, 225.989, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '41|6|-1|7|8|0|0|-1|-1|20|20|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(112, 0, 1410.58, -920.783, 38.4219, 171.313, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 1, 1401.82, -922.197, 36.0642, 354.144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(113, 0, 1440.45, -926.104, 39.6477, 171.313, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 0, 1431.49, -927.217, 37.2796, 345.684, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(114, 0, 1886.61, -1113.68, 25.8476, 265.346, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1889.17, -1129.24, 24.2048, 355.084, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(115, 0, 1906.04, -1113.07, 26.2317, 180, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 1910.57, -1116.58, 25.6641, 359.809, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|-1|-1|9|5|-1|-1|-1|-1|91|-1|91|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(116, 0, 1921.97, -1115.14, 26.6595, 264.421, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 1919.76, -1129.33, 24.9741, 355.421, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(117, 0, 1938.7, -1114.96, 27.0181, 178.661, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 1933.63, -1122.33, 26.275, 359.205, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(118, 0, 1955.43, -1115.27, 27.4032, 272.521, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 1952.35, -1129.48, 25.7906, 353.901, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(119, 0, 1999.93, -1114.06, 27.125, 179.798, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 2002.7, -1123.28, 26.5683, 358.288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(120, 0, 973.59, -1827.31, 12.9311, 168.573, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 972.2, -1832.06, 12.6097, 340.75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|78|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(121, 0, 933.044, -1818.82, 13.3212, 168.573, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 932.509, -1823.88, 12.594, 354.85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(122, 0, 926.249, -1818.04, 13.3245, 168.573, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 924.718, -1823.73, 12.5929, 354.537, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(123, 0, 915.03, -1816.79, 13.308, 168.573, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 0, 914.415, -1821.45, 12.5683, 358.297, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(124, 0, 908.571, -1816.09, 13.3015, 168.573, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 907.439, -1821.52, 12.5759, 2.0569, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(125, 0, 903.119, -1815.49, 13.3026, 168.573, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 903.237, -1820.98, 12.573, 354.224, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(126, 0, 791.538, -1753.21, 13.4605, 183.512, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 0, 788.117, -1761.83, 13.3315, 357.371, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(127, 0, 794.928, -1692.09, 14.4633, 1.11065, 421.536, 2536.47, 10, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 3, 803.508, -1692.95, 13.5469, 88.2387, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(128, 0, 791.115, -1661.15, 13.4857, 171.687, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 787.975, -1669.01, 13.4675, 347.658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|6|-1|7|8|0|0|-1|-1|46|46|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(129, 0, 769.172, -1745.85, 12.6451, 92.3857, 421.536, 2536.47, 10, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 1, 762.327, -1746.92, 12.5887, 269.66, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(130, 0, 131.865, -1492.6, 18.7656, 331.626, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 130.806, -1487.03, 18.646, 242.737, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(131, 0, 142.402, -1470.19, 25.2109, 331.626, 421.536, 2536.47, 10, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 142.438, -1461.7, 25.9828, 224.587, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(132, 0, 153.241, -1449.38, 32.845, 52.5996, 421.536, 2536.47, 10, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 148.665, -1444.45, 32.1966, 229.6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(133, 0, 228.019, -1405.46, 51.6094, 328.586, 421.536, 2536.47, 10, 0, 'The State', 750000, 3, 1, 1, 3, 1, 0, 0, -1, 3, 229.195, -1400.93, 51.5937, 237.77, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(134, 0, 1179.89, -1261.02, 18.8984, 271.05, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 1, -1, 0, 1183.56, -1261.19, 18.8984, 105.229, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(135, 0, 1187.44, -1261, 18.8984, 100.36, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1183.56, -1261.19, 18.8984, 105.229, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(136, 0, 1187.36, -1254.72, 18.8908, 92.0724, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 1181.19, -1254.58, 18.8984, 85.1987, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(137, 0, 1179.8, -1254.56, 18.8908, 266.483, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 1180.92, -1254.56, 18.8908, 85.1987, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(138, 0, 1179.89, -1233.49, 22.1406, 266.483, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 1180.65, -1234.2, 22.1406, 120.606, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(139, 0, 1187.44, -1233.17, 22.1406, 86.4715, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 1182.49, -1233.42, 22.1406, 279.444, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(140, 0, 1179.81, -1227.06, 22.1329, 271.591, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1183.09, -1228.47, 22.1406, 62.3251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(141, 0, 1187.34, -1227.13, 22.1329, 93.8899, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1183.57, -1227.9, 22.1406, 281.324, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(142, 0, 2016.19, -1716.79, 14.125, 93.8899, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2007.98, -1715.57, 13.5469, 265.344, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(143, 0, 2015.19, -1732.42, 14.2344, 93.8899, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2014.03, -1737.23, 13.5547, 267.537, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(144, 0, 802.842, -1795.76, 13.0234, 358.675, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 806.756, -1790.08, 13.4846, 173.184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(145, 0, 794.225, -1795.76, 13.0234, 354.813, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 798.664, -1789.53, 13.3842, 176.004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(146, 0, 766.919, -1605.73, 13.8039, 86.4131, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 758.54, -1601.91, 13.4274, 269.754, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(147, 0, 761.105, -1564.64, 13.9289, 264.494, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 3, 1, 1, 3, 1, 0, 0, -1, 0, 764.84, -1556.65, 13.5469, 88.3554, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(148, 0, 432.062, -1253.96, 51.5809, 21.8542, 318.652, 1114.48, 1083.88, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 3, 418.323, -1252.15, 51.5464, 195.54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|3|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(149, 15, 1298.39, -798.682, 84.1406, 183.724, 2324.42, -1148.46, 1050.71, 302, 'Amiri_Junk', 1500000, 4, 1, 1, 4, 1, 1, 0, -1, 1, 1248.94, -803.637, 84.1406, 357.28, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|7|8', 1772447510, 3, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(150, 0, 2507.57, -2021.05, 14.2101, 356.897, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 1, -1, 2, 2506.09, -2016.08, 13.5469, 174.906, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(151, 0, 2486.29, -2021.55, 13.9988, 356.897, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 2485.44, -2016.64, 13.5469, 170.833, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(152, 0, 2508.53, -1998.39, 13.9025, 181.076, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2507.35, -2003.33, 13.5469, 3.53496, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(153, 0, 2524.24, -1998.3, 14.1131, 134.233, 421.536, 2536.47, 10, 0, 'The State', 250000, 1, 1, 1, 2, 1, 0, 0, -1, 2, 2525.66, -2008.73, 13.554, 263.267, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(154, 0, 2483.35, -1995.34, 13.8343, 178.793, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2495.27, -1993.36, 13.4984, 357.217, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(155, 0, 2465.07, -2020.79, 14.1242, 4.00228, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 2467.45, -2015.47, 13.5469, 171.193, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(156, 0, 2465.08, -1995.75, 14.0193, 180.583, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2453.81, -1994.73, 13.5469, 3.58179, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(157, 0, 2437.91, -2020.84, 13.9025, 1.35451, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2451.73, -2020.57, 13.5469, 184.377, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(158, 0, 2230.5, -1407.63, 24, 180.364, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2231.13, -1412.49, 24, 12.6919, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|6|9|3|-1|-1|-1|-1|10|3|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(159, 0, 2244.04, -1407.62, 24, 180.364, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2239.26, -1413.82, 23.8281, 314.098, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(160, 0, 2256.86, -1407.63, 24, 180.364, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2242.33, -1413.7, 23.8281, 269.098, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(161, 0, 2263.41, -1458.96, 24.0086, 355.261, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 2261.76, -1455.38, 24, 181.58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(162, 0, 2247.23, -1458.93, 24.0259, 355.261, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2260.95, -1455.47, 24, 93.846, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(163, 0, 2232.04, -1458.96, 24.021, 355.261, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2245.98, -1452.27, 23.8281, 115.153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(164, 0, 2367.39, -49.1213, 28.1535, 355.261, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2358.46, -63.7689, 27.4688, 177.82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(165, 0, 2383.98, -54.9591, 28.1536, 355.261, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2397.82, -51.257, 27.4838, 180.35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(166, 0, 2415.42, -52.2803, 28.1535, 355.261, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, 2424.52, -60.0412, 27.4766, 182.254, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(167, 0, 2438.82, -54.9618, 28.1535, 355.261, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2444.21, -51.1302, 27.4838, 182.254, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(168, 0, 2448.39, -11.0245, 27.6835, 176.15, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 2433.6, -10.6734, 26.4844, 358.349, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(169, 0, 2411.22, -5.62807, 27.6835, 89.8255, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2413.3, 1.86902, 26.4844, 271.868, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(170, 0, 2417.01, 17.9056, 27.6835, 89.8255, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 1, 2410.19, 11.2526, 26.4844, 270.011, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(171, 0, 2411.21, 21.7969, 27.6835, 89.8255, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2403.91, 14.9436, 26.4844, 257.188, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|10|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(172, 0, 2151.05, -1789.33, 13.5093, 268.639, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(173, 0, 2373.98, 21.9583, 28.4416, 268.639, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2377.08, 26.1992, 27.5819, 88.3226, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '14|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(174, 0, 2373.85, -8.7485, 28.4416, 268.639, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2377.61, -12.8833, 27.4962, 92.1059, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(175, 0, 2140.94, -1801.79, 16.1475, 268.545, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(176, 0, 2146.52, -1808.38, 16.1406, 268.545, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(177, 0, 2413.61, 61.7602, 28.4416, 176.843, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2409.47, 58.1003, 27.5131, 2.20185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|32|5|-1|-1|-1|-1|4|-1|3|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(178, 0, 2443.46, 61.7631, 28.4416, 176.843, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2448.32, 57.2715, 27.3768, 0.658491, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(179, 0, 2373.85, 42.2651, 28.4416, 270.061, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2377.95, 37.7265, 27.4423, 87.4527, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(180, 0, 2446.63, 18.9944, 27.6835, 270.061, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2443.89, 11.3073, 26.4844, 87.4761, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(181, 0, 2488.28, 11.7515, 28.4416, 179.166, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 2492.66, 7.71553, 27.4489, 356.922, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(182, 0, 2484.49, -28.4005, 28.4416, 358.566, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2480.09, -24.8882, 27.5352, 178.03, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(183, 0, 2146.48, -1813.71, 16.1406, 268.208, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(184, 0, 2158.12, -1819.7, 16.1406, 355.069, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(185, 0, 2398.42, 111.746, 28.4416, 178.202, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 2402.48, 107.214, 27.3674, 358.825, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(186, 0, 2364, 116.038, 28.4416, 93.954, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 2359.63, 120.845, 27.3986, 265.451, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(187, 0, 2364, 142.033, 28.4416, 93.954, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2360.65, 146.231, 27.5644, 270.488, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(188, 0, 2363.95, 166.173, 28.4416, 93.5898, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 2358.95, 170.806, 27.2891, 263.281, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(189, 0, 2323.85, 162.209, 28.4416, 271.005, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2328.76, 157.792, 27.3097, 91.5727, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|-1|32|5|-1|-1|-1|-1|3|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(190, 0, 2172.31, -1819.7, 16.1406, 4.05405, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(191, 0, 2323.85, 136.32, 28.4416, 267.284, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2327.51, 132.147, 27.5124, 90.946, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '5|-1|-1|4|5|-1|-1|-1|-1|91|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(192, 0, 2323.85, 116.093, 28.4416, 267.284, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2328.08, 120.057, 27.419, 83.7627, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(193, 0, 2293.78, -124.954, 28.1535, 0.60684, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2299.01, -121.866, 27.4838, 181.21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(194, 0, 2176.36, -1815.21, 13.5469, 0.60684, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(195, 0, 2168.98, -1815.23, 13.5469, 0.60684, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(196, 0, 2162.67, -1815.22, 13.5469, 0.60684, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(197, 0, 2156.06, -1815.22, 13.5469, 0.60684, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(198, 0, 2272.29, -119.132, 28.1535, 0.60684, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 2263.35, -133.374, 27.4688, 176.847, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(199, 0, 2245.44, -122.284, 28.1535, 0.60684, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2254.61, -132.469, 27.4766, 182.824, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '14|-1|-1|14|5|-1|-1|-1|-1|6|-1|6|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(200, 0, 2203.12, -89.3055, 28.1535, 269.158, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2187.72, -80.3019, 27.4688, 89.473, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(201, 0, 2197.28, -60.7622, 28.1535, 266.005, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 2200.72, -65.8998, 27.4838, 90.4364, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(202, 0, 2199.95, -37.272, 28.1535, 266.005, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2189.87, -46.398, 27.4766, 92.1789, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(203, 0, 2245.56, -1.66759, 28.1536, 176.297, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2240.07, -5.20497, 27.4838, 1.96144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(204, 0, 2270.41, -7.50764, 28.1535, 176.297, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2279.52, 7.67602, 27.4688, 355.695, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|14|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(205, 0, 2203.85, 62.2383, 28.4416, 263.941, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2207.98, 57.0781, 27.4364, 79.6688, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '33|-1|-1|4|5|-1|-1|-1|-1|6|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(206, 0, 2203.85, 106.18, 28.4416, 263.941, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 1, 2207.72, 110.48, 27.4779, 91.5756, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(207, 0, 2236.5, 168.304, 28.1535, 179.862, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2231.35, 165.345, 27.4838, 2.90151, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(208, 0, 2257.95, 168.336, 28.1536, 179.862, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2252.8, 166.244, 27.4838, 358.515, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(209, 0, 2285.94, 161.769, 28.4416, 179.862, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 2289.84, 158.309, 27.5439, 358.202, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(210, 0, 2322.34, -124.962, 28.1536, 357.93, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2327.53, -121.385, 27.4838, 182.443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(211, 0, 2323.85, 191.124, 28.4416, 271.723, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2327.26, 195.601, 27.551, 91.5757, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|10|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(212, 0, 2363.99, 187.18, 28.4416, 88.7741, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2360.78, 183.041, 27.584, 264.851, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|-1|-1|7|32|-1|-1|-1|-1|13|-1|13|6|-1|-1|-1|-1|-1|57|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(213, 0, 2509.53, 11.7625, 28.4416, 175.439, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2505, 7.82196, 27.468, 359.792, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|18|-1|55|6|-1|-1|-1|-1|-1|53|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(214, 0, 2513.31, -28.4028, 28.4416, 359.395, 421.536, 2536.47, 10, 0, 'The State', 250000, 2, 1, 1, 2, 1, 0, 0, -1, 1, 2517.73, -24.8647, 27.5331, 178.08, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(215, 0, 2385.46, -1711.66, 14.2422, 179.395, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 2390.15, -1713.16, 13.6182, 4.51514, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(216, 0, -329.087, 1860.56, 44.3828, 163.756, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 1, -323.556, 1847.43, 41.9979, 90.4228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|6|18|-1|18|3|48|6|-1|10|1|-1|-1|10|10|10|-1|-1|-1|-1|-1|-1|-1|3|0', '29|10|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(217, 0, -91.2176, -1592.55, 3.00431, 300.006, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 1772209677, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(218, 0, -102.594, -1576.15, 2.61719, 54.5462, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(219, 0, -89.1284, -1564.39, 3.00431, 234.339, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(220, 0, -68.6873, -1545.74, 3.00431, 126.864, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(221, 0, -55.9474, -1555.78, 2.61072, 52.0161, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(222, 0, -65.3439, -1573.9, 2.61072, 188.49, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(223, 0, -76.1234, -1581.14, 3.4375, 305.928, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(224, 0, -75.2898, -1598.15, 2.61719, 145.579, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(225, 0, 653.595, -1713.98, 14.7648, 88.7081, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 3, 1, 1, 3, 1, 0, 0, -1, 3, 641.204, -1713.17, 14.3606, 279.937, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(226, 0, 652.514, -1694.11, 14.5584, 88.7081, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 643.33, -1695.58, 14.9613, 253.641, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(227, 0, 657.228, -1652.63, 15.4062, 88.7081, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 652.799, -1656.79, 14.6613, 262.751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(228, 0, 653.243, -1619.85, 15, 88.7081, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 3, 646.55, -1622.31, 15.0905, 264.004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(229, 0, 771.114, -1510.74, 13.5469, 257.73, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 1, 777.31, -1515.6, 13.5547, 82.9192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|20|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(230, 0, 782.797, -1464.39, 13.5469, 257.73, -68.3739, 1355.14, 1080.21, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 4, 788.785, -1461.36, 13.5461, 76.6525, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(231, 0, 784.397, -1436.04, 13.5469, 257.73, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 789.406, -1431.06, 13.5466, 87.9326, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|6|-1|7|8|0|0|-1|-1|55|55|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(232, 0, 739.128, -1418.51, 13.5234, 11.3688, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 2, 736.069, -1412.39, 13.5289, 170.653, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(233, 0, 808.297, -759.507, 76.5314, 286.439, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 3, 813.747, -767.533, 76.774, 110.342, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(234, 0, 1332.24, -633.458, 109.135, 20.9648, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 1, -1, 1, 1352.76, -624.015, 109.133, 194.153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 1772465563, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(235, 0, 1189, -1018.01, 36.2344, 279.522, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 1190.26, -1020.05, 35.3676, 357.402, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(236, 0, 1196.48, -1017, 36.2344, 97.6306, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1194.5, -1017.49, 36.2344, 285.334, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(237, 0, 398.108, -1271.39, 50.0198, 20.5107, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 407.001, -1265.43, 50.0427, 200.734, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(238, 0, 1188.2, -1011.92, 32.5469, 273.859, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1190.99, -1010.02, 32.5469, 107.986, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(239, 0, 1234.72, -1016.03, 36.3359, 93.3381, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1232.45, -1016.47, 36.3359, 257.134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(240, 0, 1227.22, -1016.97, 36.3359, 282.1, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 1232.41, -1017.16, 36.3359, 62.889, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(241, 0, 1442.72, -628.832, 95.7186, 177.586, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 1, -1, 4, 1460.36, -630.893, 95.7186, 0.55848, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(242, 0, 1234.73, -1016.12, 32.6067, 96.4714, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1230.53, -1017.94, 32.6016, 280.031, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(243, 0, 1227.26, -1017.28, 32.6016, 277.556, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1231.51, -1016.84, 32.6016, 79.2059, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(244, 0, 1241.99, -1075.55, 31.5547, 266.993, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 1247.06, -1067.99, 29.17, 88.1075, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(245, 0, 1242.26, -1100.14, 27.9766, 266.993, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 1, 1243.79, -1108.19, 25.6053, 85.4493, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(246, 0, 1285.27, -1090.55, 28.2578, 88.4813, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 3, 1282.21, -1098.63, 25.9738, 262.798, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(247, 0, 1285.1, -1066.42, 31.6789, 88.4813, 222.934, 1287.87, 1082.14, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 1, 1283.15, -1058.53, 29.3794, 265.931, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(248, 0, 189.637, -1308.22, 70.2493, 267.216, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 3, 171.352, -1339.01, 69.869, 2.1484, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(249, 0, 416.731, -1154.25, 76.6876, 148.618, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 4, 405.456, -1155.32, 77.5236, 327.426, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(250, 0, 786.014, -828.574, 70.2896, 6.71618, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 1, 796.646, -844.818, 60.6401, 15.5074, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(251, 0, 897.886, -677.167, 116.89, 236.016, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 3, 1, 1, 4, 1, 0, 0, -1, 0, 909.363, -663.583, 116.89, 51.9923, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(252, 0, 946.344, -710.682, 122.62, 27.2555, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 2, 942.242, -711.445, 122.211, 206.13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(253, 0, 867.559, -717.604, 105.68, 335.32, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 1, 1, 1, 4, 1, 0, 0, -1, 2, 864.312, -713.812, 105.68, 145.97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(254, 0, 891.186, -783.158, 101.314, 26.3823, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 4, 885.197, -782.819, 101.264, 196.73, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '8|-1|-1|28|12|-1|13|10|14|46|-1|22|14|-1|-1|15|11|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(255, 0, 847.997, -745.517, 94.9693, 311.624, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 3, 1, 1, 4, 1, 0, 0, -1, 4, 843.973, -759.8, 85.1192, 305.435, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(256, 0, 980.55, -677.225, 121.976, 28.9556, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 1, 1007.69, -660.963, 121.147, 208.553, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(257, 0, 1045.15, -642.941, 120.117, 15.7838, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1039.37, -641.538, 120.117, 184.51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(258, 0, 1095.12, -647.918, 113.648, 7.04957, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 3, 1087.5, -640.683, 113.197, 90.8224, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(259, 0, 2402.51, -1715.09, 14.1328, 179.287, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2402.43, -1720.09, 13.6156, 359.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(260, 0, 2670.28, -1238.1, 55.7251, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '14|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(261, 0, 2670.28, -1233.52, 57.1208, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(262, 0, 2670.28, -1229.17, 58.3603, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(263, 0, 2670.28, -1224.67, 59.6364, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|7|2|-1|-1|-1|-1|0|1|3|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(264, 0, 2670.28, -1220.5, 60.9221, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(265, 0, 2670.28, -1216.35, 62.2635, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 2673.52, -1216.52, 62.3191, 275.314, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(266, 0, 2670.28, -1211.76, 63.6674, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(267, 0, 2670.28, -1207.55, 64.8048, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(268, 0, 2670.28, -1203.06, 65.7269, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(269, 0, 2670.28, -1200.04, 66.4955, 270.546, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2672.02, -1200.16, 66.5224, 80.8774, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(270, 0, 2683.44, -1200.11, 66.8064, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(271, 0, 2683.44, -1203.01, 66.0321, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|3|3|2|-1|-1|-1|-1|6|6|6|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(272, 0, 2683.44, -1207.57, 65.0977, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(273, 0, 2683.44, -1211.85, 63.9642, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(274, 0, 2683.44, -1216.34, 62.5745, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(275, 0, 2683.44, -1220.55, 61.2256, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(276, 0, 2683.44, -1224.78, 59.9323, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(277, 0, 2683.44, -1229.28, 58.6468, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(278, 0, 2683.44, -1233.56, 57.4173, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(279, 0, 2683.44, -1238.02, 56.02, 89.6728, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(280, 0, 2628.1, -1067.92, 69.7156, 273.813, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2631.14, -1068.6, 69.625, 251.685, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(281, 0, 2627.65, -1085.16, 69.7156, 273.813, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2634.32, -1084.43, 69.6187, 182.173, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(282, 0, 2625.93, -1098.7, 69.3614, 273.813, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2633.15, -1096.1, 69.613, 129.966, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(283, 0, 2625.94, -1112.57, 67.9953, 273.813, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2633.54, -1109.96, 68.2332, 204.613, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(284, 0, 2579.68, -1033.2, 69.5798, 179.538, 421.536, 2536.47, 10, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 2580.99, -1036.81, 69.5833, 2.12486, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(285, 0, 2562.11, -1034.32, 69.8692, 85.6935, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2560.63, -1037.79, 69.5662, 295.071, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(286, 0, 2549.2, -1032.26, 69.5789, 269.207, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2553.26, -1033.75, 69.5743, 159.806, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(287, 0, 2526.96, -1033.52, 69.5795, 182.178, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2524.4, -1036.61, 69.5751, 310.738, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(288, 0, 2512.74, -1027.16, 70.0859, 182.178, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2503.02, -1026.45, 70.0859, 353.665, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|-1|4|5|-1|-1|-1|-1|10|-1|10|6|-1|-1|-1|-1|-1|38|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(289, 0, -258.247, 1168.91, 20.9399, 86.571, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -262.064, 1178.29, 19.8728, 265.617, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(290, 0, -258.246, 1151.08, 20.9399, 86.571, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -254.701, 1158.83, 19.7493, 265.304, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(291, 0, -290.846, 1176.75, 20.9399, 272.003, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -291.283, 1164.36, 19.6987, 92.9689, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(292, 0, -324.321, 1165.67, 20.9399, 184.214, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -336.85, 1164.32, 19.7422, 355.185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(293, 0, -369.756, 1169.57, 20.2719, 230.667, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, -360.372, 1191.63, 19.7422, 11.1649, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(294, 0, -360.844, 1141.74, 20.9399, 269.391, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -362.366, 1131.43, 19.8709, 82.2922, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(295, 0, -369.822, 1116.19, 20.9399, 1.86425, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 1, -366.512, 1103.01, 19.7422, 88.5589, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(296, 0, -328.247, 1118.8, 20.9399, 92.7986, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -330.872, 1129.47, 19.8938, 270.271, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|77|-1|5|6|-1|-1|-1|-1|-1|42|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(297, 0, -298.307, 1115.67, 20.9399, 176.879, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, -305.943, 1119.1, 19.7493, 357.691, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(298, 0, -260.24, 1120.04, 20.9399, 88.8819, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, -257.973, 1130.57, 19.823, 270.921, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(299, 0, -29.4242, 1363.28, 9.28111, 48.0582, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(300, 0, -20.6702, 1388.25, 9.28111, 48.0582, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(301, 0, -21.293, 1348.13, 9.17188, 15.3145, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(302, 0, 4.60573, 1344.33, 9.28111, 60.1216, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(303, 0, 21.4228, 1344.15, 9.28111, 23.6571, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(304, 0, 26.736, 1361.93, 9.17188, 45.5906, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(305, 0, 4.73785, 1380.83, 9.17814, 23.0304, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(306, 0, -1.2225, 1394.74, 9.17188, 23.0304, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(307, 0, 1667.43, -2106.94, 14.0723, 180.509, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1672.21, -2109.84, 13.5469, 1.47485, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '14|-1|-1|14|5|-1|-1|-1|-1|38|-1|14|6|-1|-1|-1|-1|-1|38|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(308, 0, 1673.65, -2122.44, 14.146, 315.338, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1680.17, -2121.14, 13.5469, 134.306, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(309, 0, 1695.59, -2125.84, 13.8101, 1.66107, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 1693.9, -2120.98, 13.5469, 158.12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|10|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(310, 0, 1711.62, -2101.23, 14.021, 182.484, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1711.85, -2106.51, 13.5469, 17.7684, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(311, 0, 1715.03, -2125.45, 14.0566, 2.78509, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1714.76, -2120.99, 13.5469, 179.137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(312, 0, 1734.1, -2097.98, 14.0366, 180.697, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1747.75, -2088.78, 13.5531, 351.942, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(313, 0, 1734.72, -2130.36, 14.021, 359.119, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 1, 1725.82, -2129.56, 13.5543, 179.473, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(314, 0, 1761.26, -2125.45, 14.0566, 359.119, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 1764.01, -2120.7, 13.5543, 182.317, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(315, 0, 1762.44, -2101.98, 13.857, 179.422, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1758.98, -2106.6, 13.5469, 1.85836, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(316, 0, 1781.37, -2101.27, 14.0566, 179.422, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1773.54, -2099.06, 13.5469, 359.98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|-1|-1|4|5|-1|-1|-1|-1|55|-1|5|6|-1|-1|-1|-1|-1|5|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(317, 0, 1782.13, -2126.51, 14.0679, 357.764, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1773.1, -2125.78, 13.5469, 178.267, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(318, 0, 1804.27, -2124.9, 13.9424, 357.764, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 1793.64, -2128.03, 13.5469, 175.133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(319, 0, 1801.99, -2098.94, 14.021, 175.99, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1802.02, -2105.31, 13.5469, 354.675, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(320, 0, 2232.78, -1785.7, 13.56, 90.2143, 2324.42, -1148.46, 1050.71, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2228.39, -1785.34, 13.5632, 268.517, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(321, 0, 1112.64, -742.001, 100.133, 90.2143, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 2, 1110.95, -732.363, 100.197, 269.134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(322, 0, 1845.44, 741.161, 11.4609, 268.048, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 1847.98, 734.307, 11.1864, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(323, 0, 1843.99, 718.655, 11.4683, 268.048, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 1, 1848.98, 726.67, 11.1144, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(324, 0, 1845.44, 661.148, 11.4609, 268.048, 2324.42, -1148.46, 1050.71, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 1848.12, 654.206, 11.1845, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(325, 0, 1844.53, 690.446, 11.4531, 268.048, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 3, 1848.46, 698.536, 11.139, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(326, 0, 2373.96, -1138.92, 29.0588, 181.709, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2374.96, -1146.03, 27.625, 3.135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(327, 0, 2013.97, 775.197, 11.4609, 181.709, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 4, 2006.95, 772.436, 11.1821, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(328, 0, 1082.39, -1862.51, 13.5518, 359.819, 2324.42, -1148.46, 1050.71, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1081.98, -1860.17, 13.5469, 193.957, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(329, 0, 1094.1, -1861.91, 13.5469, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(330, 0, 1099.2, -1861.74, 13.5469, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(331, 0, 1104.24, -1861.91, 13.5469, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(332, 0, 1109.7, -1861.91, 13.5547, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(333, 0, 1114.14, -1861.81, 13.5529, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(334, 0, 1119.57, -1861.75, 13.5528, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(335, 0, 1124.53, -1861.61, 13.5526, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(336, 0, 1129.54, -1861.91, 13.5463, 359.819, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 1120.89, -1859.94, 13.5501, 266.338, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(337, 0, 1070.84, -1873.72, 13.5469, 91.6518, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1068.19, -1870.72, 13.5469, 193.957, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(338, 0, 1070.84, -1879.06, 13.5469, 91.6518, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1068.19, -1870.72, 13.5469, 193.957, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(339, 0, 691.579, -1275.84, 13.5607, 91.6518, 1260.97, -785.456, 1091.91, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 3, 687.727, -1268.48, 13.5579, 269.158, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(340, 0, 2690.54, -1238.11, 57.5101, 268.988, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(341, 0, 2380.68, -1785.79, 13.5469, 90.1126, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(342, 0, 2345.58, -1785.6, 13.5469, 90.1126, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(343, 0, 2321.98, -1796.03, 13.5469, 270.963, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(344, 0, 2307.68, -1785.72, 13.5569, 90.8725, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(345, 0, 2290.13, -1795.98, 13.5469, 266.396, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(346, 0, 2275.85, -1785.74, 13.5469, 87.4024, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(347, 0, 2247.08, -1795.96, 13.5469, 268.487, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(348, 0, -1896.05, 483.698, 35.1719, 90.1207, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 2, -1898.69, 480.488, 34.8771, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(349, 0, -1896.05, 490.55, 35.1719, 90.1207, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 4, -1898.2, 493.855, 34.8769, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(350, 0, -1946.23, 456.004, 35.1719, 2.46482, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 4, -1949.63, 458.374, 34.8773, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(351, 0, -1939.49, 456.004, 35.1719, 2.46482, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 2, 1, 1, 3, 1, 0, 0, -1, 0, -1936.15, 458.449, 34.8772, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(352, 0, -1939.49, 518.281, 35.1719, 182.923, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, -1936.13, 515.957, 34.8768, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(353, 0, -1946.24, 518.28, 35.1719, 182.923, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 4, -1949.63, 515.287, 34.877, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(354, 0, -2159.24, 753.531, 69.5148, 272.772, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, -2153.82, 748.766, 69.2664, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(355, 0, -2159.24, 786.159, 69.5147, 272.772, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2154.14, 781.446, 69.2657, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(356, 0, -2126.06, 755.625, 69.5625, 91.0606, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 3, -2132.03, 750.758, 69.2665, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(357, 0, -2126.04, 773.885, 69.5625, 91.0606, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 3, -2131.86, 769.055, 69.2673, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(358, 0, -2112.57, 823.555, 69.5625, 180.523, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 3, -2117.37, 815.831, 69.2652, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(359, 0, -2112.55, 795.742, 69.5684, 1.43053, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, -2117.34, 801.173, 69.2674, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(360, 0, -2094.19, 823.556, 69.5625, 181.677, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2098.91, 815.575, 69.2674, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(361, 0, -2094.11, 795.741, 69.5684, 3.09908, 222.934, 1287.87, 1082.14, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2098.94, 801.276, 69.2674, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(362, 0, -2099.56, 897.357, 76.7109, 3.09908, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 1, -2105.48, 900.673, 76.3528, 0.564751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(363, 0, -2075.14, 898.64, 64.1328, 3.09908, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 3, -2079.92, 901.21, 63.838, 0.564751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(364, 0, -2034.13, 901.678, 50.4466, 3.09908, 421.536, 2536.47, 10, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 2, -2047.64, 900.476, 53.1846, 0.564751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(365, 0, -2129.63, 942.492, 80, 91.0349, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2132.15, 947.527, 79.702, 0.564751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(366, 0, -2116.86, 927.829, 86.0791, 175.871, 2324.42, -1148.46, 1050.71, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 0, -2131.99, 935.008, 79.7049, 0.564751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(367, 0, 2094.76, 2189.54, 10.8203, 175.871, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(368, 0, 2089.47, 2189.54, 10.8203, 175.871, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(369, 0, 2081.42, 2189.54, 10.8203, 175.871, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(370, 0, 2073.47, 2189.46, 10.8203, 175.446, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(371, 0, 2064.23, 2186.89, 10.8203, 267.868, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2066.32, 2186.96, 10.8203, 89.0007, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(372, 0, 2064.24, 2178.84, 10.8203, 267.868, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(373, 0, 2064.23, 2170.85, 10.8203, 267.868, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(374, 0, 2064.23, 2162.92, 10.8203, 267.868, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(375, 0, 2069.5, 2153.67, 10.8203, 0.905254, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(376, 0, 2077.43, 2153.67, 10.8203, 0.905254, 421.536, 2536.47, 10, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(377, 0, 2085.51, 2153.67, 10.8203, 1.14072, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(378, 0, 2498.46, 1643.58, 11.0157, 1.14072, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(379, 0, 2503.5, 1643.58, 11.0234, 1.14072, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(380, 0, 2508.42, 1643.58, 11.0234, 1.14072, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(381, 0, 2513.5, 1643.58, 11.0234, 359.014, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(382, 0, 2516.45, 1648.46, 11.0234, 91.2798, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(383, 0, 2516.35, 1653.84, 11.0234, 91.2798, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|10|10|10|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(384, 0, 2517.04, 1659, 11.0234, 91.2798, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(385, 0, 2517.02, 1664.32, 11.0234, 91.2798, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(386, 0, 2517.04, 1669.29, 11.0234, 91.2798, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(387, 0, 2517.04, 1674.32, 11.0234, 91.2798, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(388, 0, 2516.97, 1679.3, 11.0234, 91.2798, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(389, 0, 2511.3, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '8|-1|0|1|2|-1|-1|-1|-1|0|10|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(390, 0, 2506.36, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(391, 0, 2501.36, 1682.84, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(392, 0, 2496.34, 1682.86, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|8|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|14|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(393, 0, 2491.28, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(394, 0, 2486.33, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(395, 0, 2481.35, 1682.79, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '64|-1|64|64|31|-1|-1|-1|-1|21|21|21|3|-1|-1|-1|-1|-1|14|30|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(396, 0, 2476.4, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(397, 0, 2471.35, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(398, 0, 2466.26, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(399, 0, 2435.27, 1655.44, 10.8203, 178.912, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 2435.41, 1646.79, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(400, 0, 2373.5, 1642.59, 11.0234, 4.26636, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(401, 0, 2368.46, 1642.59, 11.0234, 4.26636, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(402, 0, 2363.45, 1642.59, 11.0234, 4.26636, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(403, 0, 2358.47, 1642.59, 11.0234, 4.26636, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(404, 0, 2357.96, 1653.74, 11.0234, 265.331, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(405, 0, 2357.74, 1648.64, 11.0234, 265.331, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(406, 0, -2356.72, 580.036, 24.8906, 177.44, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 0, -2361.61, 575.649, 24.596, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(407, 0, -2338.48, 580.036, 27.7624, 172.415, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 1, -2344.23, 575.723, 26.5673, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(408, 0, -2320.13, 579.596, 31.1069, 172.415, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, -2325.9, 575.714, 29.8809, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(409, 0, -2301.79, 580.036, 34.3866, 172.415, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2307.54, 575.605, 33.1945, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|-1|4|5|-1|-1|-1|-1|34|-1|36|6|-1|-1|-1|-1|-1|18|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(410, 0, -2303.37, 656.91, 45.326, 357.506, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2309.01, 661.163, 44.0543, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(411, 0, -2321.78, 656.925, 41.9735, 357.506, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, -2327.36, 661.255, 40.6233, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(412, 0, -2340.07, 656.97, 38.3937, 357.506, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2346.24, 661.061, 36.8694, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(413, 0, -2358.46, 656.793, 35.1719, 357.506, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2354.36, 661.164, 35.2325, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(414, 0, -2625.83, -190.944, 7.20312, 269.42, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -2619.55, -191.491, 4.33594, 87.1424, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(415, 0, -2620.76, -185.895, 7.20312, 4.3372, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2616.29, -188.291, 4.33594, 272.637, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(416, 0, -2621.01, -173.238, 5, 269.553, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2615.99, -178.815, 4.33594, 273.241, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|-1|4|5|-1|-1|-1|-1|14|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(417, 0, -2622.17, -169.656, 4.34258, 269.553, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, -2616.13, -166.085, 4.33594, 271.987, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(418, 0, -2625.85, -162.381, 7.20312, 269.553, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, -2610.32, -161.111, 4.33594, 87.555, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|74|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(419, 0, -2620.63, -146.212, 7.20312, 179.06, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2615.87, -143.813, 4.33594, 274.518, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(420, 0, -2621.02, -134.702, 5, 268.517, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2615.43, -140.007, 4.33594, 268.877, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(421, 0, -2620.7, -120.212, 7.20312, 359.972, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 2, -2615.63, -122.501, 4.33594, 270.154, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(422, 0, -2622.21, -112.368, 4.34258, 270.207, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2615.82, -108.424, 4.33594, 269.841, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(423, 0, -2625.79, -105.183, 7.20312, 270.207, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, -2619.65, -104.827, 4.33594, 84.6589, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(424, 0, -2623.43, -99.3291, 7.20312, 270.207, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2616.18, -96.6449, 4.33594, 267.381, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(425, 0, -2687.9, -89.4342, 4.33594, 94.0009, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2696.99, -92.9092, 4.03516, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(426, 0, -2684.43, -96.566, 7.20312, 94.0009, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -2694.38, -95.937, 4.33594, 270.248, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(427, 0, -2689.5, -101.603, 7.20312, 174.086, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 3, -2696.83, -99.2363, 4.03375, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|14|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(428, 0, -2689.24, -114.162, 5, 87.3758, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2696.89, -108.927, 4.0371, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(429, 0, -2687.89, -118.075, 4.34258, 87.3758, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, -2697.01, -121.442, 4.03739, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(430, 0, -2684.41, -125.188, 7.20312, 87.3758, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, -2695.31, -123.657, 4.33594, 263.331, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(431, 0, -2689.49, -141.289, 7.20312, 358.657, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, -2696.99, -143.688, 4.03758, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '14|-1|-1|4|5|-1|-1|-1|-1|55|-1|55|6|-1|-1|-1|-1|-1|40|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(432, 0, -2689.23, -152.842, 5, 96.5508, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, -2696.85, -147.4, 4.03696, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|3|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(433, 0, -2689.45, -167.287, 7.20312, 178.986, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2697.06, -164.868, 4.03706, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(434, 0, -2687.89, -175.115, 4.34258, 94.7492, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, -2697.06, -178.648, 4.03706, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(435, 0, -2684.4, -182.241, 7.20312, 94.7492, -68.3739, 1355.14, 1080.21, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -2692.85, -181.304, 4.33594, 269.041, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(436, 0, -2686.82, -188.194, 7.20312, 94.7492, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2696.95, -190.865, 4.03356, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(437, 0, 1550.57, 2846.08, 10.8265, 177.341, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 2, 1543.48, 2835.61, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(438, 0, 1575.77, 2844.17, 10.8203, 181.637, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 1580.4, 2839.33, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(439, 0, 1565.47, 2793.49, 10.8203, 91.9841, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1552.07, 2786.69, 10.5473, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(440, 0, 1601.7, 2846.08, 10.8265, 175.594, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 4, 1594.5, 2829.05, 10.5441, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(441, 0, 1588.5, 2797.33, 10.8265, 359.158, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 3, 1, 1, 3, 1, 0, 0, -1, 2, 1595.55, 2814.1, 10.5473, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(442, 0, 1618.27, 2800.79, 10.8203, 359.158, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 1611.57, 2814.13, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(443, 0, 1622.69, 2846.08, 10.8265, 181.144, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 2, 1615.95, 2829.29, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(444, 0, 1637.81, 2801.48, 10.8203, 358.939, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 1630.34, 2814.24, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(445, 0, 1632.81, 2843.82, 10.8203, 177.283, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 1640.21, 2829.23, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(446, 0, 1664.67, 2846.08, 10.8265, 177.283, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 2, 1, 1, 3, 1, 0, 0, -1, 4, 1657.83, 2829.37, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(447, 0, 1654.89, 2800.81, 10.8203, 359.699, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 3, 1648.09, 2814.02, 10.5476, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '61|-1|-1|7|5|-1|-1|-1|-1|14|-1|34|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(448, 0, 1673.05, 2800.79, 10.8203, 359.699, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 3, 1666.01, 2813.97, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(449, 0, 1663.21, 2753.97, 10.8203, 177.572, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 2, 1670.29, 2740.93, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(450, 0, 1652.58, 2708.85, 10.8265, 356.425, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 2, 1659.47, 2725.92, 10.5478, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(451, 0, 1643.7, 2753.45, 10.8203, 177.941, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 3, 1651.2, 2740.73, 10.5453, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(452, 0, 1627.19, 2710.76, 10.8203, 354.639, 2324.42, -1148.46, 1050.71, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 3, 1622.59, 2714.95, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '5|6|-1|7|8|0|0|-1|-1|9|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(453, 0, 1626.69, 2754.14, 10.8203, 177.526, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 1633.64, 2740.95, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(454, 0, 1608.41, 2754.14, 10.8203, 177.526, -68.3739, 1355.14, 1080.21, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1615.56, 2740.93, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|-1|-1|4|5|-1|-1|-1|-1|13|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(455, 0, 1601.28, 2708.85, 10.8265, 357.945, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 1608.34, 2725.59, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(456, 0, 1599.46, 2757.6, 10.8265, 181.145, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 1, 1592.49, 2740.87, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(457, 0, 1580.24, 2708.85, 10.8265, 359.136, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 1587.49, 2725.82, 10.5474, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(458, 0, 1570.21, 2711.11, 10.8203, 359.136, -68.3739, 1355.14, 1080.21, 0, 'The State', 750000, 3, 1, 1, 3, 1, 0, 0, -1, 3, 1562.85, 2725.64, 10.5435, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(459, 0, 2196.21, -1404.2, 25.9488, 268.895, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2199.54, -1405.82, 25.5391, 42.8025, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|-1|51|7|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|15|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(460, 0, 2188.55, -1419.23, 26.1562, 268.895, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2193.98, -1416.1, 25.5391, 111.736, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(461, 0, 2194.35, -1442.96, 26.0738, 268.895, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2195.55, -1445.96, 25.5391, 93.2989, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(462, 0, 2191.11, -1455.86, 26, 268.895, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 2193.61, -1457.56, 25.5391, 3.29871, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(463, 0, 2190.44, -1470.36, 25.9141, 268.895, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2192.12, -1472.77, 25.5497, 3.29871, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(464, 0, 2190.64, -1487.67, 25.7746, 268.895, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2193.55, -1488.39, 25.5391, 103.253, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(465, 0, 2148.94, -1484.79, 26.6242, 92.1339, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 2134.66, -1482.65, 23.9629, 260.54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '13|-1|-1|4|5|-1|-1|-1|-1|55|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(466, 0, 2146.8, -1470.53, 26.0426, 92.1339, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2143.7, -1468.38, 25.5391, 231.384, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(467, 0, 2152.22, -1446.32, 26.1051, 92.1339, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2153.57, -1454.98, 25.5391, 272.303, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(468, 0, 2149.85, -1433.72, 26.0703, 92.1339, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2137.25, -1436.39, 23.979, 277.003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(469, 0, 2150.92, -1419.06, 25.9219, 92.1339, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2147.6, -1423.86, 25.5391, 269.483, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(470, 0, 2151.18, -1400.65, 26.1285, 92.1339, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2136.81, -1408.65, 23.9876, 267.732, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(471, 0, 1849.99, -2037.9, 13.5469, 92.1339, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(472, 0, 1849.45, -2028.59, 13.5469, 185.849, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1851.72, -2030.92, 13.5469, 74.4727, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(473, 0, 1835.86, -2005.49, 13.5469, 185.849, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1835.66, -2009.22, 13.5469, 20.2655, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(474, 0, 1817.4, -2005.49, 13.5544, 185.849, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1820.68, -2009.71, 13.5544, 20.2655, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(475, 0, 1816.89, -1977.57, 13.5469, 91.2663, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 1814.52, -1982.3, 13.5544, 349.559, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(476, 0, 1835.24, -1977.6, 13.5469, 269.381, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 1838.64, -1978.24, 13.5469, 55.3358, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(477, 0, 1849.49, -1983.11, 13.5469, 359.408, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 1846.72, -1980.02, 13.5469, 249.918, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(478, 0, 1858.97, -1982.71, 13.5469, 87.1872, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1846.72, -1980.02, 13.5469, 249.918, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(479, 0, 1877.32, -2000.96, 13.5469, 271.781, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1878.96, -1996.21, 13.5544, 170.957, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(480, 0, 1888.93, -1982.48, 13.5469, 90.1873, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1886.51, -1987.08, 13.5469, 342.352, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(481, 0, 1877.32, -1982.59, 13.5469, 272.851, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1880.89, -1979.47, 13.5469, 154.037, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(482, 0, -347.901, -1045.65, 59.8125, 177.322, 2324.42, -1148.46, 1050.71, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -347.424, -1049.72, 59.3021, 26.1955, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '42|-1|42|32|2|-1|-1|-1|-1|47|47|47|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(483, 0, -382.447, -1042.62, 58.929, 91.7423, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -369.447, -1040.22, 59.3634, 91.8676, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(484, 0, -881.407, 1562.58, 26.2186, 159.674, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -883.125, 1560.8, 25.9114, 332.615, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(485, 0, -884.094, 1553.05, 25.9141, 15.8915, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -885.784, 1555.09, 25.9141, 255.848, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(486, 0, -905.633, 1543.14, 25.9141, 6.51888, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -905.958, 1546.57, 25.9141, 168.74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(487, 0, -884.298, 1538.12, 26.0311, 181.623, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -883.178, 1535.3, 25.9114, 345.462, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(488, 0, -905.481, 1528.57, 26.078, 191.677, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -904.322, 1523.87, 25.9141, 0.791794, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(489, 0, -905.93, 1514.53, 26.3168, 269.647, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -902.004, 1516.42, 25.7912, 117.98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(490, 0, -881.744, 1531.79, 26.0624, 356.849, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -883.689, 1534.76, 25.9114, 233.601, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|32|1|2|-1|-1|-1|-1|29|29|14|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(491, 0, -886.385, 1514.29, 25.9141, 356.849, 421.536, 2536.47, 10, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, -886.178, 1517.54, 25.9141, 179.08, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(492, 0, 2751.5, -1936.48, 13.5394, 264.493, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2757.16, -1939.28, 13.5489, 42.4654, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(493, 0, 2751.49, -1962.9, 13.5469, 264.493, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2757.53, -1962.29, 13.5493, 131.453, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(494, 0, 2736.65, -1926.1, 13.5469, 85.5387, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2734.57, -1922.04, 13.5394, 190.36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(495, 0, 2786.92, -1952.65, 13.5469, 85.5387, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2775.92, -1952.98, 13.5469, 265.561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(496, 0, 2787.08, -1925.99, 13.5469, 85.5387, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2776.01, -1925.72, 13.5394, 266.188, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(497, 0, 2696.31, -1990.36, 14.2229, 189.98, 421.536, 2536.47, 10, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2695.62, -1994.94, 13.5547, 353.005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(498, 0, 2695.42, -2020.55, 14.0223, 0.742039, 421.536, 2536.47, 10, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2685.29, -2017.18, 13.5474, 184.881, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(499, 0, 2673.26, -2020.29, 14.1682, 0.742039, 421.536, 2536.47, 10, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 1, 2675.35, -2009.64, 13.5547, 175.795, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(500, 0, 2672.74, -1989.47, 14.324, 180.965, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2675.31, -1995.14, 13.5547, 51.9123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(501, 0, 2652.76, -1989.42, 13.9988, 179.101, 421.536, 2536.47, 10, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 2654.28, -1994.61, 13.5547, 21.5187, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(502, 0, 2522.71, -2019.04, 14.0744, 44.4841, 421.536, 2536.47, 10, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2525.89, -2011.89, 13.554, 269.358, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(503, 0, 2635.56, -2012.85, 14.1443, 303.472, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2639.5, -2010.48, 13.5547, 147.19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(504, 0, 2637.12, -1991.68, 14.324, 228.663, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2644.16, -1991.41, 13.5543, 184.791, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(505, 0, -607.55, -1073.89, 23.4995, 178.569, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -603.164, -1075.86, 23.5624, 87.6564, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '51|-1|51|31|49|-1|-1|-1|-1|11|40|11|41|-1|-1|-1|-1|-1|18|14|-1|37|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(506, 0, -601.169, -1065.38, 23.4032, 178.569, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -596.661, -1067.54, 23.4496, 132.656, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '23|-1|53|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(507, 0, -594.865, -1056.87, 23.3543, 178.569, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, -589.834, -1059.34, 23.3785, 88.283, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(508, 0, -588.782, -1048.73, 23.3355, 178.569, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -584.13, -1050.87, 23.5656, 66.9762, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(509, 0, -582.588, -1040.2, 23.5917, 178.569, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -581.46, -1047.61, 23.6778, 156.976, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|4|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(510, 0, -576.651, -1031.86, 23.8376, 178.569, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, -571.447, -1034.85, 24.0669, 66.9762, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(511, 0, 2335.11, -1046.01, 52.5529, 359.301, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2340.9, -1045.38, 52.7954, 179.15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(512, 0, 2457.76, -1054.64, 59.9592, 90.3527, 222.934, 1287.87, 1082.14, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 2451.28, -1057.34, 59.7422, 354.039, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|12|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(513, 0, 219.168, -1249.85, 78.3368, 213.13, 2324.42, -1148.46, 1050.71, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, 222.694, -1267.84, 65.4409, 127.81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(514, 0, 497.396, -1095.07, 82.3592, 359.709, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 4, 479.97, -1092.1, 82.3592, 172.642, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|72|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(515, 0, 745.242, -556.785, 18.0129, 359.709, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 750.594, -552.493, 17.3023, 181.94, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(516, 0, 766.602, -556.78, 18.0129, 359.709, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 771.621, -553.13, 17.3432, 181.023, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '34|-1|-1|34|10|-1|-1|-1|-1|41|-1|9|3|-1|-1|-1|-1|-1|19|-1|-1|1|-1|-1|-1|-1|-1', '22|14|72', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(517, 0, 818.21, -509.82, 18.0129, 178.64, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 827.435, -495.702, 17.3281, 1.16802, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(518, 0, 795.162, -506.15, 18.0129, 178.64, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 785.794, -496.77, 17.3359, 357.431, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(519, 0, 768.194, -503.483, 18.0129, 178.64, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 763.036, -507.994, 17.285, 358.685, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '41|-1|-1|4|5|-1|-1|-1|-1|14|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(520, 0, 743.178, -509.318, 18.0129, 178.64, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 1, 752.349, -495.203, 17.3281, 359.312, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(521, 0, 285.999, 41.1158, 2.54844, 24.5563, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(522, 0, 309.167, 44.2429, 3.08797, 196.241, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(523, 0, 317.696, 54.7084, 3.375, 49.9524, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(524, 0, 316.45, 18.0496, 4.51562, 190.969, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(525, 0, 340.05, 33.6252, 6.40803, 310.21, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(526, 0, 342.548, 62.8231, 3.8627, 128.592, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(527, 0, 253.161, -22.2783, 1.63406, 179.682, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(528, 0, 248.709, -33.1505, 1.57812, 87.9133, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(529, 0, 267.69, -54.5441, 2.77721, 179.541, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 277.952, -54.5667, 1.57812, 353.751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(530, 0, 295.083, -54.5431, 2.77721, 179.541, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 2, 287.117, -51.7232, 1.57812, 353.124, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(531, 0, 252.888, -92.3259, 3.53539, 84.8349, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 2, 248.647, -84.1378, 2.51316, 264.028, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(532, 0, 252.676, -121.296, 3.53539, 84.8349, 0, 0, 0, 0, 'The State', 250000, 1, 1, 1, 2, 1, 0, 0, -1, 2, 249.452, -125.559, 2.64183, 273.741, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(533, 0, 977.413, -771.262, 112.203, 3.56332, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 1, 956.391, -763.314, 109.246, 194.689, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(534, 0, 1300.49, 193.302, 20.5233, 210.264, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1300.65, 191.745, 20.4609, 34.148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(535, 0, 1303.62, 186.099, 20.5389, 26.9893, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(536, 0, 1295.46, 174.654, 20.9106, 64.0805, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 1288.86, 175.08, 20.4609, 333.035, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(537, 0, 1315.99, 180.128, 20.4609, 247.997, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(538, 0, 1311.83, 169.547, 20.6311, 337.157, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 1, 1316.45, 166.034, 20.4609, 161.037, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(539, 0, 1566.84, 23.2246, 24.1641, 90.7574, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 0, 1561.59, 30.382, 23.8729, 93.513, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(540, 0, -2719.35, -319.151, 7.84375, 41.1643, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, -2724.69, -314.319, 6.89099, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '6|8|8', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(541, 0, 1118.09, -1021.18, 34.9922, 181.48, 0, 0, 0, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 1108.27, -1026.94, 31.9464, 4.41552, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '28|6|-1|7|8|0|0|-1|-1|55|55|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(542, 0, 1291.83, -903.014, 46.6328, 95.4422, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(543, 0, 1284.36, -904.07, 46.6328, 278.995, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(544, 0, 1283.54, -897.897, 46.6251, 278.995, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(545, 0, 1291.04, -896.963, 46.6251, 103.225, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(546, 0, -2724.7, -58.0519, 4.34258, 268.235, 0, 0, 0, 0, 'The State', 250000, 1, 1, 1, 2, 1, 0, 0, -1, 0, -2715.42, -54.6558, 4.03747, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(547, 0, -2725.79, -36.4502, 7.19531, 268.235, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2715.72, -33.8787, 4.03705, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(548, 0, -2722.99, 4.3509, 7.20312, 175.919, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2715.62, 6.86766, 4.03734, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '13|-1|-1|72|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(549, 0, -2721.38, 14.6141, 4.33594, 266.344, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2715.6, 10.9155, 4.03771, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(550, 0, -2723.12, -17.0378, 7.20312, 351.585, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2715.5, -19.7452, 4.037, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(551, 0, 2077.5, -1056.47, 31.0044, 322.641, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(552, 0, 2083.08, -1039.9, 32.0304, 138.36, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(553, 0, 2093.83, -1047.36, 30.1081, 140.306, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(554, 0, 2092.58, -1067.22, 27.5956, 321.403, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(555, 0, 2099.8, -1051.73, 28.8145, 141.235, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(556, 0, 2102.12, -1075.38, 25.7917, 327.215, 0, 0, 0, 0, 'The State', 250000, 1, 1, 1, 2, 1, 0, 0, -1, 0, 2094.25, -1093.96, 25.1231, 335.595, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(557, 0, 2105.55, -1056.1, 27.1411, 147.948, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(558, 0, -45.0648, 1081.35, 20.9399, 3.99326, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(559, 0, 1.57964, 1076.21, 20.9399, 87.9949, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1.96195, 1084.36, 19.7493, 266.927, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(560, 0, -18.1593, 1115.67, 20.9399, 180.938, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -25.7125, 1113.86, 19.7493, 5.18119, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|3|4|-1|-1|-1|-1|10|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(561, 0, 12.7793, 1113.67, 20.9399, 180.938, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -0.690153, 1115.8, 19.7172, 6.18833, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(562, 0, 13.4475, 1219.97, 19.3395, 91.0891, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(563, 0, 13.7134, 1229.35, 19.3416, 91.0891, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(564, 0, -3.96661, 951.776, 19.7031, 0.664111, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(565, 0, 17.6585, 910.308, 23.8805, 0.664111, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|17|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(566, 0, -52.8996, 894.704, 22.3871, 0.664111, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|7|1|2|-1|-1|-1|-1|0|3|3|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(567, 0, -56.3503, 935.695, 21.2074, 0.664111, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(568, 0, -247.702, 1001.45, 20.9399, 0.664111, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -239.72, 1000.64, 19.7493, 177.161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(569, 0, -278.715, 1003.24, 20.9399, 0.664111, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -282.864, 1000.4, 20.1043, 178.728, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(570, 0, -258.623, 1043.78, 20.9399, 88.9292, 0, 0, 0, 0, 'The State', 250000, 1, 1, 1, 2, 1, 0, 0, -1, 0, -251.79, 1057.69, 19.7473, 271.475, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(571, 0, -258.922, 1083.5, 20.9399, 355.494, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -245.924, 1078.46, 19.7444, 179.017, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(572, 0, -2220.17, -2399.98, 32.5823, 230.551, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2219.08, -2406.69, 31.3955, 47.8132, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(573, 0, -2239.13, -2423.84, 32.7073, 230.551, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2232.56, -2423.33, 31.5603, 51.2599, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(574, 0, -2224.44, -2482.61, 31.8163, 323.08, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2236.7, -2478, 31.1738, 135.861, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(575, 0, 1894.29, -2133.85, 15.4663, 178.553, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1897.19, -2145.93, 13.5469, 359.724, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(576, 0, 1872.6, -2133.77, 15.482, 178.553, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 1876.14, -2146.75, 13.5469, 359.097, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(577, 0, 1851.88, -2135.03, 15.3882, 178.553, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1847.29, -2147.63, 13.5469, 1.91663, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(578, 0, 2129.63, -1361.69, 26.1363, 178.553, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2137.06, -1364.78, 25.2168, 358.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(579, 0, 2230.05, -1280.8, 25.3672, 178.553, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(580, 0, 2250.28, -1281, 25.4766, 178.553, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2255.93, -1286.64, 24.6719, 1.43981, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(581, 0, 2191.36, -1275.9, 25.1562, 178.553, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2196.85, -1279.88, 24.4994, 0.476422, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(582, 0, 2266.46, -1700.76, 13.6903, 359.129, 0, 0, 0, 0, 'The State', 250000, 1, 1, 1, 2, 1, 0, 0, -1, 0, 2260.22, -1696.46, 13.7197, 175.841, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(583, 0, 2092.22, -1166.37, 26.5859, 89.5092, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2087.38, -1170.9, 25.2886, 267.265, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|4|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(584, 0, 2036.3, -1059.52, 25.6508, 244.096, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2036.98, -1066.08, 24.7645, 337.162, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(585, 0, 2023.11, -1052.95, 25.5961, 244.096, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2023.92, -1060.44, 24.6824, 334.052, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(586, 0, 2060.97, -1075.41, 25.6014, 157.184, 0, 0, 0, 0, 'The State', 250000, 2, 1, 1, 2, 1, 0, 0, -1, 0, 2067.3, -1081.82, 24.9397, 65.8357, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(587, 0, 2051.31, -1066.13, 25.7836, 157.184, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2051.7, -1073.29, 24.8428, 345.356, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(588, 0, 2108.91, -1082.09, 25.2423, 323.503, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 0, 2099.83, -1095.94, 25.1574, 333.715, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(589, 0, -2348.53, 2423.11, 7.3371, 146.899, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2355.93, 2418.96, 6.95761, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(590, 0, -2379.21, 2444.61, 10.1694, 146.899, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2377.74, 2432.18, 8.72635, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|-1|-1|4|5|-1|-1|-1|-1|48|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(591, 0, -2386.34, 2447.36, 10.1694, 154.446, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2391.93, 2437.45, 10.1084, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(592, 0, -2421.71, 2406.58, 13.0253, 267.907, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2414.82, 2426.31, 12.1239, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(593, 0, -2479.85, 2449.9, 17.323, 176.582, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2482.65, 2438.22, 15.9606, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(594, 0, -2472.52, 2451.32, 17.323, 176.582, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2474.32, 2439.79, 15.6104, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|-1|4|5|-1|-1|-1|-1|10|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(595, 0, -2634.66, 2401.79, 11.2295, 4.21329, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2619.62, 2397.83, 11.1861, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(596, 0, -2632.42, 2375.21, 9.03806, 4.21329, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2621.48, 2373.72, 9.14761, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(597, 0, -2626.97, 2359.58, 8.96308, 268.797, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2621.59, 2354.98, 8.37179, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(598, 0, -2583.6, 2307.76, 7.00288, 268.797, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2569.61, 2305.4, 4.68966, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(599, 0, -2583.14, 2300.35, 7.00288, 268.797, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2567.17, 2297.42, 4.69334, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(600, 0, -2552, 2266.43, 5.47552, 333.561, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2556.37, 2267.02, 4.76539, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(601, 0, -2523.83, 2238.8, 5.39844, 333.561, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2529, 2249.37, 4.68561, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(602, 0, -2627.63, 2283.48, 8.31485, 272.852, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2621.56, 2279.19, 7.98619, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(603, 0, -1516.96, 2656.68, 56.275, 272.852, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, -1514.7, 2658.48, 55.8359, 136.723, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(604, 0, -1491.56, 2685.44, 55.8594, 183.389, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(605, 0, -2720.99, 924.009, 67.5938, 90.7648, 0, 0, 0, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, -2723.19, 916.151, 67.5938, 269.607, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(606, 0, -2482.34, 2406.73, 17.1094, 115.624, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2489.26, 2409.9, 16.1009, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(607, 0, -2437.4, 2354.95, 5.44307, 190.265, 0, 0, 0, 0, 'The State', 250000, 2, 1, 1, 2, 1, 0, 0, -1, 0, -2425.81, 2344.05, 4.68815, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(608, 0, -2485.58, 2272.21, 4.98438, 190.265, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2489.73, 2268.33, 4.68974, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '16|-1|-1|7|5|-1|-1|-1|-1|10|-1|18|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(609, 0, -2493.91, 2272.77, 4.9584, 190.265, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2498.33, 2269.53, 4.68971, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '42|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(610, 0, -2626.95, 2291.94, 8.30935, 266.539, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2621.6, 2287.45, 7.98603, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(611, 0, 2123.41, 775.407, 11.4453, 178.172, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 0, -1, 0, 2131.47, 772.514, 11.1432, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(612, 0, 2094.07, 774.438, 11.4531, 178.172, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2087, 772.44, 11.1739, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(613, 0, 2071.56, 776.3, 11.4605, 178.172, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2079.6, 771.175, 11.0901, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(614, 0, 2043.18, 776.094, 11.4531, 178.172, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2051.41, 772.058, 11.1352, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(615, 0, 2013.22, 730.625, 11.4531, 358.871, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2005.04, 734.538, 11.1298, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(616, 0, 2042.43, 731.478, 11.4609, 358.871, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2049.49, 733.839, 11.1857, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(617, 0, 2064.96, 730.118, 11.4683, 358.871, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2057.04, 735.319, 11.0969, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|-1|4|5|-1|-1|-1|-1|29|-1|73|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(618, 0, 2093.27, 730.648, 11.4531, 358.871, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2085.1, 734.494, 11.1313, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(619, 0, 2122.62, 731.267, 11.4609, 358.871, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2129.6, 734.043, 11.1811, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(620, 0, 2807.96, -1176.07, 25.3831, 179.134, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 1, 1, -1, 0, 2829.89, -1171.21, 24.9489, 270.551, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 1772468467, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(621, 0, 2808.01, -1190.88, 25.3427, 358.613, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 1772468444, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(622, 0, 2852.26, -1366.01, 14.1708, 263.862, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2856.92, -1355.47, 11.0701, 88.9772, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(623, 0, -1532.89, 2656.58, 56.2814, 86.9896, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, -1533.84, 2648.55, 55.8359, 348.828, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(624, 0, 2842.14, -1334.82, 14.7421, 187.939, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2853.52, -1329.22, 11.0651, 100.013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(625, 0, 2756.22, -1182.48, 69.3998, 357.783, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2751.38, -1177.72, 69.4033, 268.541, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(626, 0, 2750.39, -1205.66, 67.4844, 88.2744, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '60|-1|60|1|2|-1|-1|-1|-1|14|1|46|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(627, 0, 2750.39, -1222.28, 64.6016, 88.2744, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(628, 0, 2750.38, -1238.83, 61.5245, 88.2744, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(629, 0, 2707.31, -1224.8, 63.5875, 266.226, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(630, 0, 2707.31, -1220.52, 64.8803, 266.226, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '28|-1|14|14|2|-1|-1|-1|-1|14|38|14|3|-1|-1|-1|-1|-1|6|6|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(631, 0, 2707.31, -1216.32, 66.2298, 266.226, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(632, 0, 2707.31, -1211.71, 67.6197, 266.226, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(633, 0, 2707.31, -1207.57, 68.7521, 266.226, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|2|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(634, 0, 2707.31, -1203.04, 69.6871, 266.226, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(635, 0, 2707.37, -1199.89, 70.4733, 266.226, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(636, 0, 2707.59, -1229.39, 62.1719, 266.226, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(637, 0, 2707.31, -1233.51, 61.0727, 266.226, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(638, 0, 2707.33, -1238.15, 59.6789, 266.226, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(639, 0, 2700.2, -1238.02, 58.1826, 90.2095, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(640, 0, 2700.18, -1233.6, 59.5767, 90.2095, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(641, 0, 2700.2, -1229.24, 60.8096, 90.2095, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(642, 0, 2700.21, -1224.67, 62.0963, 90.2095, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(643, 0, 2700.19, -1220.39, 63.387, 90.2095, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(644, 0, 2700.18, -1216.34, 64.7343, 90.2095, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(645, 0, 2700.17, -1211.67, 66.1213, 90.2095, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(646, 0, 2700.21, -1207.37, 67.262, 90.2095, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(647, 0, 2700.19, -1203.15, 68.1936, 90.2095, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(648, 0, 2700.2, -1200.14, 68.9688, 90.2095, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(649, 0, 2690.85, -1200, 68.2796, 270.394, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(650, 0, 2690.66, -1203.14, 67.5477, 270.394, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(651, 0, 2690.61, -1207.52, 66.6025, 270.394, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(652, 0, 2690.54, -1211.82, 65.4547, 270.394, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(653, 0, 2690.54, -1216.38, 64.0652, 270.394, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(654, 0, 2690.56, -1220.64, 62.7193, 270.394, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(655, 0, 2690.56, -1224.82, 61.4268, 270.394, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(656, 0, 2690.55, -1229.14, 60.1379, 270.394, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(657, 0, 2690.98, -1233.43, 58.8988, 270.394, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(658, 0, 2550.22, -1197.37, 60.8329, 356.185, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2557.97, -1193.93, 61.551, 181.051, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '9|-1|-1|4|5|-1|-1|-1|-1|14|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(659, 0, 2520.7, -1197.34, 56.5552, 356.185, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2528.89, -1194.65, 56.9743, 182.064, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(660, 0, 2257.17, -1643.98, 15.8082, 179.857, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2252.65, -1650.15, 15.4768, 76.2156, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(661, 0, 2467.71, -1200.24, 36.8117, 1.70008, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2468.28, -1191.03, 37.6477, 270.525, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(662, 0, -1563.46, 2651.04, 55.9234, 270.049, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, -1562.27, 2647.74, 55.4464, 259.795, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(663, 0, -1604.2, 2689.73, 55.2856, 270.049, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -1596.38, 2688.91, 54.6717, 89.4004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(664, 0, -1511.86, 2695.42, 55.8723, 175.097, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(665, 0, 558.987, -1076.15, 72.922, 26.8614, 0, 0, 0, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 0, 566.467, -1069.73, 73.0511, 209.944, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(666, 0, 2756.07, -1302.35, 53.0938, 90.3394, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(667, 0, 2561.84, 1561.73, 10.8203, 90.3394, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 2561.7, 1549.34, 10.5292, 92.372, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(668, 0, 1326.26, -1091.87, 27.9766, 270.339, 0, 0, 0, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 0, 1331.09, -1099.54, 24.8459, 91.7742, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(669, 0, 2082.52, -1085.28, 25.595, 156.716, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(670, 0, 2229.71, -1240.81, 25.6562, 358.05, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2224.24, -1238.5, 24.9183, 178.928, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '18|-1|-1|18|5|-1|-1|-1|-1|14|-1|14|13|-1|-1|-1|-1|-1|7|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(671, 0, 2249.97, -1238.2, 25.8984, 358.05, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2245.31, -1242.59, 25.4276, 181.462, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|10|-1|10|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(672, 0, 2207.51, -1100.83, 31.5547, 212.897, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2197.65, -1106.97, 25.2007, 337.456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|14|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(673, 0, 2073.21, -965.506, 49.0105, 164.397, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2076.47, -973.631, 49.5368, 353.077, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(674, 0, 2051.23, -954.574, 48.0348, 84.9267, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2054.59, -970.544, 45.6744, 355.27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|4|5|-1|-1|-1|-1|75|-1|75|6|-1|-1|-1|-1|-1|30|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(675, 0, 2044.99, -965.95, 44.3634, 93.6609, 0, 0, 0, 0, 'The State', 250000, 2, 1, 1, 2, 1, 0, 0, -1, 0, 2030.64, -963.424, 40.8609, 283.179, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(676, 0, 2016.12, -979.142, 36.5195, 209.035, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2029.74, -957.649, 40.8586, 281.299, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '42|-1|-1|9|5|-1|-1|-1|-1|14|-1|29|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(677, 0, 948.717, -916.299, 45.2042, 275.713, 0, 0, 0, 534, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, 952.868, -911.927, 45.7656, 8.04637, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(678, 0, 993.83, -1058.44, 33.6995, 4.72833, 0, 0, 0, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 1003.97, -1053.61, 30.9783, 179.578, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(679, 0, 1051.19, -1058.86, 34.7966, 4.72833, 0, 0, 0, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 0, 1041.18, -1054.59, 31.7031, 179.529, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(680, 0, 2468.4, -1383.68, 28.8281, 180.929, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(681, 0, 2473.3, -1383.67, 28.834, 180.929, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(682, 0, 2476.34, -1383.67, 28.8348, 180.929, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(683, 0, 2476.35, -1391.38, 28.8348, 358.097, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(684, 0, 2473.25, -1391.38, 28.834, 358.097, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(685, 0, 2468.12, -1391.37, 28.8281, 358.097, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(686, 0, 2487.34, -1383.66, 28.8374, 174.012, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(687, 0, 2487.42, -1391.39, 28.8375, 354.342, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(688, 0, 2492.28, -1383.65, 28.8387, 178.846, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(689, 0, 2492.25, -1391.4, 28.8386, 358.991, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '64|-1|64|1|2|-1|-1|-1|-1|20|20|20|3|-1|-1|-1|-1|-1|14|59|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(690, 0, 2495.35, -1391.39, 28.8394, 358.991, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(691, 0, 2495.45, -1383.65, 28.8394, 179.918, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(692, 0, 2495.3, -1375.96, 28.8394, 357.988, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(693, 0, 2492.01, -1375.95, 28.8386, 357.988, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(694, 0, 2487.33, -1375.95, 28.8374, 357.988, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(695, 0, 2476.3, -1375.95, 28.8348, 357.988, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(696, 0, 2472.95, -1375.93, 28.8339, 357.988, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(697, 0, 2468.37, -1375.79, 28.8281, 357.988, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(698, 0, 2468.39, -1366.7, 28.8279, 180.483, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '42|-1|42|28|2|-1|-1|-1|-1|55|13|10|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(699, 0, 2473.2, -1366.51, 28.8281, 180.483, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(700, 0, 2476.42, -1366.49, 28.8348, 180.483, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(701, 0, 2487.39, -1366.54, 28.8375, 179.414, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(702, 0, 2492.26, -1366.54, 28.8386, 179.414, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(703, 0, 2495.32, -1366.56, 28.8394, 179.414, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(704, 0, 2487.41, -1399.1, 28.8375, 179.414, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(705, 0, 2492.25, -1399.09, 28.8386, 179.414, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(706, 0, 2495.37, -1399.18, 28.8394, 179.414, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(707, 0, 2495.47, -1410.03, 28.8394, 359.414, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(708, 0, 2492.13, -1410.02, 28.8386, 359.414, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(709, 0, 2487.37, -1410.02, 28.8375, 359.414, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(710, 0, 2476.33, -1399.1, 28.8348, 178.776, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(711, 0, 2473.27, -1399.1, 28.834, 178.776, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(712, 0, 2476.42, -1410.01, 28.8338, 358.294, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(713, 0, 2473.15, -1410.01, 28.8338, 358.294, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(714, 0, 2468.2, -1409.94, 28.8337, 358.294, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(715, 0, 2468.37, -1399.12, 28.8281, 178.713, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(716, 0, 2495.44, -1417.73, 28.8375, 178.713, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(717, 0, 2492.16, -1417.73, 28.8375, 178.713, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(718, 0, 2487.28, -1417.73, 28.8375, 178.713, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(719, 0, 2495.41, -1424.55, 29.0162, 358.545, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(720, 0, 2492.13, -1424.56, 29.0162, 358.545, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(721, 0, 2487.32, -1424.55, 29.0162, 358.545, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(722, 0, 2476.3, -1424.26, 28.8407, 358.545, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(723, 0, 2473.1, -1424.27, 28.8407, 358.545, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(724, 0, 2468.31, -1424.26, 28.8407, 358.545, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(725, 0, 2468.39, -1417.73, 28.8375, 176.026, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(726, 0, 2473.11, -1417.73, 28.8375, 176.026, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(727, 0, 2476.3, -1417.73, 28.8375, 176.026, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(728, 0, 2586.84, -1200.06, 59.2188, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(729, 0, 2586.77, -1203.03, 58.4375, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(730, 0, 2587.39, -1207.47, 57.6515, 86.2161, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(731, 0, 2587.39, -1211.89, 56.5144, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(732, 0, 2587.35, -1216.3, 55.1144, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(733, 0, 2587.38, -1220.53, 53.7654, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(734, 0, 2587.39, -1224.79, 52.4771, 86.2161, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(735, 0, 2587.39, -1229.29, 51.1906, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(736, 0, 2587.4, -1233.72, 49.9621, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(737, 0, 2587.31, -1238.06, 48.5644, 86.2161, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(738, 0, 2594.52, -1237.99, 48.5644, 266.674, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(739, 0, 2594.52, -1233.47, 49.9621, 266.674, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(740, 0, 2594.51, -1229.26, 51.1906, 266.674, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(741, 0, 2594.5, -1224.72, 52.4771, 266.674, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(742, 0, 2594.64, -1220.48, 53.7654, 266.674, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(743, 0, 2594.51, -1216.35, 55.1144, 266.674, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(744, 0, 2594.51, -1211.86, 56.5144, 266.674, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(745, 0, 2594.5, -1207.53, 57.6515, 266.674, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(746, 0, 2594.5, -1203.22, 58.576, 266.674, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(747, 0, 2594.51, -1200.18, 59.3578, 266.674, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(748, 0, 2601.03, -1200.03, 59.4967, 85.9186, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(749, 0, 2601.05, -1203.07, 58.7271, 85.9186, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(750, 0, 2601.05, -1207.63, 57.7931, 85.9186, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(751, 0, 2601.05, -1211.85, 56.6589, 85.9186, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(752, 0, 2601.05, -1216.21, 55.27, 85.9186, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(753, 0, 2601.05, -1220.5, 53.9209, 85.9186, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(754, 0, 2601.03, -1224.9, 52.6233, 85.9186, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(755, 0, 2601.05, -1229.23, 51.3421, 88.4135, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(756, 0, 2601.05, -1233.49, 50.1122, 88.4135, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(757, 0, 2601.04, -1237.95, 48.7139, 88.4135, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|29|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(758, 0, 2608.16, -1237.99, 50.2065, 266.298, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(759, 0, 2608.33, -1233.52, 51.3828, 266.298, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(760, 0, 2608.15, -1229.14, 52.8326, 266.298, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(761, 0, 2608.15, -1224.75, 54.1182, 266.298, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(762, 0, 2608.15, -1220.57, 55.4114, 266.298, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(763, 0, 2608.15, -1216.21, 56.7609, 266.298, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(764, 0, 2608.15, -1211.68, 58.1496, 266.298, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(765, 0, 2608.16, -1207.54, 59.2861, 266.298, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(766, 0, 2608.17, -1203.05, 60.2204, 266.298, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(767, 0, 2608.15, -1199.96, 60.9922, 266.298, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1|-1|0|1|2|-1|-1|-1|-1|0|10|2|3|-1|-1|-1|-1|-1|5|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(768, 0, 2615.11, -1200.02, 60.7812, 89.0677, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(769, 0, 2615.11, -1203.02, 60, 89.0677, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(770, 0, 2615.11, -1207.56, 59.0703, 89.0677, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(771, 0, 2615.11, -1212.02, 57.9375, 89.0677, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(772, 0, 2615.11, -1216.22, 56.5391, 89.0677, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(773, 0, 2615.11, -1220.44, 55.1875, 89.0677, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(774, 0, 2615.05, -1224.76, 53.8984, 89.0677, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(775, 0, 2615.11, -1229.3, 52.6094, 89.0677, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(776, 0, 2615.11, -1233.61, 51.3828, 89.0677, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(777, 0, 2615.11, -1238.11, 49.9844, 89.0677, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(778, 0, 2622.22, -1237.89, 51.2692, 268.625, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(779, 0, 2622.21, -1233.4, 52.6651, 268.625, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(780, 0, 2622.25, -1229.25, 53.902, 268.625, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(781, 0, 2622.77, -1224.61, 54.9688, 268.625, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(782, 0, 2622.27, -1220.5, 56.485, 268.625, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(783, 0, 2622.21, -1216.19, 57.823, 268.625, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(784, 0, 2622.22, -1211.77, 59.2126, 268.625, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(785, 0, 2622.22, -1207.62, 60.3478, 268.625, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|20|1|71|85|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(786, 0, 2622.28, -1203.05, 61.2933, 268.625, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(787, 0, 2622.23, -1200.1, 62.0577, 268.625, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(788, 0, 1851.96, -2070.18, 15.4812, 356.336, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1847.88, -2100.32, 13.5469, 0.362616, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|-1|6|7|-1|-1|-1|-1|18|-1|10|10|-1|-1|-1|-1|-1|18|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(789, 0, -2904.82, 1178.87, 13.6641, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2900.89, 1175.68, 12.8347, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7|-1|-1|4|5|-1|-1|-1|-1|10|-1|5|6|-1|-1|-1|-1|-1|52|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(790, 0, -2905.25, 1171.57, 13.6641, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2900.84, 1168.15, 13.0367, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '12|-1|-1|14|5|-1|-1|-1|-1|7|-1|2|6|-1|-1|-1|-1|-1|16|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(791, 0, -2905.16, 1164.87, 13.6641, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2900.84, 1161.72, 13.2282, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(792, 0, -2905.2, 1154.83, 13.6641, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2900.71, 1151.66, 13.5366, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|3|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(793, 0, -2904.16, 1101.05, 27.0703, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2900.76, 1098.03, 26.9938, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(794, 0, -2904.8, 1111.57, 27.0703, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2900.65, 1115.13, 26.3837, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(795, 0, -2904.7, 1118.78, 27.0703, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2900.98, 1122.45, 26.2103, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(796, 0, -2900.71, 1080.86, 32.1328, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2896.15, 1077.78, 31.3953, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(797, 0, -2900.72, 1073.79, 32.1328, 270.678, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2896.17, 1070.27, 31.5559, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(798, 0, -2900.69, 1067.03, 32.1328, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2896.22, 1063.88, 31.7729, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '9|-1|-1|4|5|-1|-1|-1|-1|3|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(799, 0, -2900.45, 1056.91, 32.1328, 270.678, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2896.36, 1053.81, 32.0999, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(800, 0, -2901.63, 1033.54, 36.8281, 291.554, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2898.86, 1038.42, 35.8781, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(801, 0, -2899.16, 1026.76, 36.8281, 291.554, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2896.48, 1031.44, 36.0565, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(802, 0, -2895.53, 1016.79, 36.8281, 291.554, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2890.74, 1015.34, 36.5223, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(803, 0, -2888.09, 1001.87, 40.7188, 291.554, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2882.64, 1001.33, 39.5427, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(804, 0, -2884.47, 995.613, 40.7188, 291.554, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2878.97, 994.843, 39.9945, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(805, 0, -2881.02, 989.631, 40.7188, 291.554, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2875.66, 989.317, 40.2996, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(806, 0, -2876.09, 981.071, 40.726, 291.554, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2870.64, 980.549, 40.7, 204.461, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(807, 0, 2480.47, 126.993, 27.6756, 178.204, 0, 0, 0, 0, 'The State', 750000, 0, 1, 1, 3, 1, 0, 0, -1, 0, 2491.46, 130.478, 27.0318, 1.17303, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(808, 0, 2518.32, 128.969, 27.6756, 178.204, 0, 0, 0, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, 2503.5, 134.194, 26.4766, 359.944, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '61|32|-1|7|10|32|32|-1|-1|64|12|84|77|19|75|75|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(809, 0, 2536.24, 128.877, 27.6835, 178.204, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2528.51, 129.502, 26.4844, 359.944, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(810, 0, 2551.22, 91.682, 27.6756, 84.8693, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2549.75, 81.3029, 26.4766, 272.639, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '28|-1|-1|14|70|-1|-1|-1|-1|38|-1|3|3|-1|-1|-1|-1|-1|61|-1|-1|40|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(811, 0, 2551.22, 57.3466, 27.6756, 84.8693, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 2549.5, 72.295, 26.4766, 269.216, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(812, 0, 1901.65, -2019.59, 13.5469, 267.129, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(813, 0, 1913.95, -2019.74, 13.5469, 88.9193, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(814, 0, 1913.96, -2021.56, 13.5469, 88.9193, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(815, 0, 1917.05, -2010.03, 13.5469, 357.19, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(816, 0, 1919.77, -2019.82, 13.5469, 269.17, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(817, 0, 1919.76, -2021.82, 13.5469, 269.17, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(818, 0, 1916.69, -2000.39, 13.5469, 181.827, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(819, 0, 1919.72, -1993.43, 13.5469, 265.124, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(820, 0, 1919.72, -1991.57, 13.5469, 265.124, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(821, 0, 1916.85, -1982.03, 13.5469, 356.791, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(822, 0, 1907.3, -1982.48, 13.5469, 270.192, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|0|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(823, 0, 1900.27, -1985.39, 13.5469, 185.239, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(824, 0, 1898.39, -1985.43, 13.5469, 185.239, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(825, 0, 1898.74, -1998.05, 13.5469, 356.325, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(826, 0, 1865.98, -1979.64, 13.5469, 356.325, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(827, 0, 1867.79, -1979.65, 13.5469, 356.325, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(828, 0, 1852.28, -1990.14, 13.5469, 271.657, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(829, 0, 1852.34, -1991.97, 13.5469, 271.657, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(830, 0, 1865.81, -1998.09, 13.5469, 356.587, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(831, 0, 1867.73, -1998.07, 13.5469, 356.587, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|3|-1|-1|-1|-1|0|1|2|10|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(832, 0, 1867.78, -1985.42, 13.5469, 177.516, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(833, 0, 1888.79, -2000.69, 13.5469, 88.6848, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(834, 0, 1867.65, -2003.88, 13.5469, 181.84, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(835, 0, 1865.91, -2003.88, 13.5469, 181.84, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(836, 0, 1867.8, -2010.03, 13.5469, 356.681, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(837, 0, 1858.97, -2000.95, 13.5469, 87.0789, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(838, 0, 1849.54, -2001.46, 13.5469, 174.786, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(839, 0, 1849.7, -2010.05, 13.5469, 356, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1843.9, -2008.09, 13.5469, 272.98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(840, 0, 1846.53, -2019.69, 13.5469, 91.6614, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(841, 0, 1846.53, -2021.19, 13.5469, 91.6614, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(842, 0, -2620.22, 883.12, 63.25, 268.501, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2613.93, 886.317, 62.354, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(843, 0, -2620.02, 874.796, 58.9219, 268.501, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2613.83, 871.102, 58.234, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(844, 0, -2620.67, 855.005, 53.5687, 268.501, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2613.96, 851.721, 52.8698, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(845, 0, -2619.72, 845.172, 50.6031, 268.501, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2614, 841.708, 50.1617, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(846, 0, -2618.45, 830.818, 49.9844, 268.501, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2613.86, 827.852, 49.6898, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(847, 0, -2594.88, 785.171, 46.2141, 90.0947, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2599.51, 780.003, 44.0572, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(848, 0, -2595.02, 767.957, 40.0042, 84.9913, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2599.61, 762.84, 37.8546, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(849, 0, -2594.65, 750.892, 33.7077, 84.9913, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2599.74, 745.322, 31.4118, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(850, 0, -2594.47, 733.087, 28.2725, 84.9913, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2599.62, 728.457, 28.546, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(851, 0, 2439.6, -1357.29, 24.101, 264.991, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2458.51, -1378.65, 23.9829, 268.612, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(852, 0, 2440.23, -1338.91, 24.1016, 264.991, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, 2458.4, -1383.96, 23.9834, 271.746, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(853, 0, 2434.31, -1320.73, 24.9499, 264.991, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 2458.17, -1389.38, 23.9743, 267.672, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(854, 0, 2068.03, -1629, 13.8762, 264.991, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 2071.01, -1629.39, 13.5469, 88.7341, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(855, 0, -2789.17, -52.7187, 10.0625, 84.823, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.47, -55.5954, 6.90729, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(856, 0, -2791.9, -41.8279, 10.0547, 178.448, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.46, -39.3301, 6.89696, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(857, 0, -2791.59, -35.7795, 7.85938, 87.4513, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.54, -30.7151, 6.89895, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(858, 0, -2791.83, -24.3961, 10.0547, 0.46055, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.49, -26.7725, 6.89886, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(859, 0, -2791.78, -17.685, 7.85938, 91.0547, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.38, -12.5609, 6.86133, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(860, 0, -2787.25, 0.276313, 10.0625, 91.0547, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, -2793.53, 0.50089, 7.1875, 272.835, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(861, 0, -2793.15, 10.9523, 7.42619, 91.0547, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2801.43, 17.5151, 6.90286, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(862, 0, -2793.63, 21.2479, 7.1875, 91.0547, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.73, 27.5392, 6.90481, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '14|-1|-1|4|5|-1|-1|-1|-1|3|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(863, 0, -2791.8, 77.5201, 10.0547, 179.057, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2801.4, 80.0382, 6.90286, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(864, 0, -2793.5, 85.146, 7.1875, 85.3872, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.53, 88.4395, 6.90315, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(865, 0, -2791.86, 91.9603, 7.85938, 85.3872, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2801.57, 96.9566, 6.90676, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(866, 0, -2791.91, 103.607, 10.0547, 5.95641, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.56, 101.459, 6.90496, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(867, 0, -2793.93, 111.123, 7.1875, 84.9329, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -2801.39, 117.135, 6.90609, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(868, 0, -2791.58, 130.669, 7.85938, 84.9329, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.4, 135.703, 6.90672, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(869, 0, -2791.86, 143.26, 10.0547, 185.659, 0, 0, 0, 0, 'The State', 250000, 0, 1, 1, 2, 1, 0, 0, -1, 0, -2801.32, 145.71, 6.90677, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(870, 0, -2790.76, 127.026, 7.20195, 86.6563, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, -2801.34, 123.379, 6.90667, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(871, 0, -2786.76, 119.822, 10.0625, 86.6563, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(872, 0, -2790.25, 69.7966, 7.20195, 86.6563, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);
INSERT INTO `house` (`h_mysql_id`, `h_user_id`, `h_enterx`, `h_entery`, `h_enterz`, `h_entera`, `h_exitx`, `h_exity`, `h_exitz`, `h_rent`, `h_owner`, `h_value`, `h_int`, `h_lock`, `h_owned`, `h_squar`, `h_g_lock`, `h_attic_lock`, `h_underground_lock`, `h_family_id`, `h_g_count`, `h_g_enterx`, `h_g_entery`, `h_g_enterz`, `h_g_enterr`, `h_improve_0`, `h_improve_1`, `h_improve_2`, `h_improve_3`, `h_r_user_id_0`, `h_r_user_id_1`, `h_r_user_id_2`, `h_r_user_id_3`, `h_r_user_id_4`, `h_r_price_0`, `h_r_price_1`, `h_r_price_2`, `h_r_price_3`, `h_r_price_4`, `h_r_days_0`, `h_r_days_1`, `h_r_days_2`, `h_r_days_3`, `h_r_days_4`, `h_auction_bet`, `h_auction_time`, `h_auction_user_id`, `h_mapping_id`, `h_garage_id`, `h_owned_at`, `h_paydays_received`, `h_delete`, `h_delete_time`, `h_garden_items`, `h_panel_items`, `h_gate_pos`, `h_air_pos`, `h_boat_status`) VALUES
(873, 0, -2786.77, 62.8666, 10.0625, 86.6563, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(874, 0, -2790.57, 7.36281, 7.19531, 86.6563, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(875, 0, -2660.08, 876.358, 79.7738, 0.762588, 0, 0, 0, 0, 'The State', 750000, 4, 1, 1, 3, 1, 0, 0, -1, 0, -2679.93, 869.103, 76.2313, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(876, 0, -2671.31, 927.886, 79.7031, 0.762588, 0, 0, 0, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, -2665.04, 913.126, 79.3802, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(877, 0, -2641.09, 935.492, 71.9531, 178.127, 0, 0, 0, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, -2636.12, 932.328, 71.5278, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(878, 0, -2706.48, 864.746, 70.7031, 354.395, 0, 0, 0, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, -2711.36, 869.365, 70.4082, 121.015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(879, 0, -911.089, 2686.2, 42.3703, 42.5033, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, -903.75, 2697.68, 42.0958, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(880, 0, 1128.01, -1022.49, 34.9922, 180.044, 0, 0, 0, 0, 'The State', 750000, 0, 1, 1, 3, 1, 1, 0, -1, 0, 1137.81, -1027.01, 31.9132, 358.83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|6|-1|7|8|0|0|-1|-1|12|12|7|8|10|11|12|-1|-1|0|4|5|6|7|8|9|-1|-1', '16|19|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(881, 0, 1457.62, 2773.49, 10.8203, 268.642, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1460.17, 2779.97, 10.5474, 73.4201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(882, 0, -396.318, -425.348, 16.2031, 172.33, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, -395.961, -432.702, 16.2031, 264.492, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(883, 0, 263.78, 2895.58, 10.5314, 32.5982, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(884, 0, 1419.66, 389.797, 19.2916, 332.935, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1421.5, 389.758, 19.2337, 71.9658, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(885, 0, 1447.83, 362.505, 18.9211, 332.935, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1454.67, 355.913, 18.8919, 38.7522, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(886, 0, 1469.26, 351.443, 18.9198, 111.849, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1462.32, 340.282, 18.8438, 319.599, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(887, 0, 1488.41, 360.802, 19.4099, 121.864, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1481.1, 362.609, 19.4136, 256.811, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(888, 0, 1465.98, 364.215, 19.2664, 340.013, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1461.97, 368.463, 19.2255, 231.431, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|55|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(889, 0, 1451.48, 375.31, 19.2005, 151.306, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1453.07, 365.51, 19.038, 4.91179, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(890, 0, 1428.25, 356.043, 18.875, 155.172, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1432.5, 362.72, 18.8438, 172.547, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2|-1|2|2|2|-1|-1|-1|-1|3|3|3|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(891, 0, 1434.97, 334.677, 18.9469, 246.621, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1440.23, 331.925, 18.8438, 55.359, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(892, 0, 1402.67, 333.651, 18.9062, 117.387, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 1401.06, 329.627, 18.8468, 2.40509, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(893, 0, 1415.58, 324.489, 18.8438, 140.445, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 1417.57, 322.193, 18.8438, 46.5855, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(894, 0, 1283.69, 158.599, 20.7934, 286.095, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 1285.35, 162.315, 20.4628, 150.613, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(895, 0, 1299.3, 140.912, 20.4054, 355.303, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 1297.17, 144.948, 20.4667, 203.88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(896, 0, 1294.51, 157.635, 20.578, 108.904, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|10|10|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(897, 0, 1475.24, 372.77, 19.6562, 340.357, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 1476.57, 374.868, 19.6353, 316.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(898, 0, 1461.08, 342.264, 18.9531, 199.278, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 1462.98, 340.436, 18.8438, 119.786, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(899, 0, 1409.07, 346.333, 19.052, 159.59, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(900, 0, -314.046, 1774.72, 43.6406, 126.533, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, -301.141, 1777.53, 42.3964, 90.4228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '8|-1|-1|33|12|-1|13|10|14|32|-1|16|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(901, 0, 1692.66, -1458.79, 13.6719, 94.1025, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1696.03, -1448.54, 13.274, 83.3768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '41|-1|-1|4|5|-1|-1|-1|-1|40|-1|64|6|-1|-1|-1|-1|-1|7|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(902, 0, 1685.37, -1464.57, 13.6719, 358.183, 0, 0, 0, 0, 'The State', 250000, 3, 1, 1, 2, 1, 0, 0, -1, 0, 1689.7, -1461.72, 13.2739, 83.3768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(903, 0, 1675.5, -1462.31, 13.6719, 268.255, 0, 0, 0, 0, 'The State', 250000, 4, 1, 1, 2, 1, 0, 0, -1, 0, 1678.89, -1459.02, 13.2791, 83.3768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|-1|4|5|-1|-1|-1|-1|4|-1|5|6|-1|-1|-1|-1|-1|2|-1|-1|3|-1|-1|-1|-1|-1', '15|18|11', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(904, 0, -692.33, 939.562, 13.6328, 267.029, 0, 0, 0, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, -696.024, 946.727, 11.9846, 89.9384, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(905, 0, -683.928, 939.547, 13.6328, 88.114, 0, 0, 0, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, -680.201, 946.307, 11.8417, 89.9384, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '41|-1|-1|28|12|-1|69|10|14|55|-1|31|14|-1|-1|15|40|74|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(906, 0, -311.291, 1303.51, 53.6643, 271.196, 0, 0, 0, 0, 'The State', 1500000, 4, 1, 1, 4, 1, 0, 0, -1, 0, -305.538, 1294.5, 53.0871, 89.994, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|-1|4|0|-1|20|10|14|71|-1|3|14|-1|-1|10|16|38|-1|-1|-1|-1|-1|-1|-1|57|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(907, 0, 725.673, -1451.04, 17.6953, 357.117, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 739.199, -1434.27, 13.0894, 90.0057, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|5|17|-1|-1|-1|-1|-1|-1|-1|10|0', '20|7|73', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(908, 0, -2479.01, 2510.07, 17.9748, 178.375, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(909, 0, -2478.29, 2488.93, 18.23, 92.2071, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(910, 0, -2463.72, 2490.62, 17.0025, 92.2071, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(911, 0, -2446.89, 2512.31, 15.7003, 269.348, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|38|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(912, 0, -2446.19, 2490.7, 15.543, 354.278, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(913, 0, -2422.33, 2490.7, 13.2025, 354.278, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '32|-1|32|32|28|-1|-1|-1|-1|42|42|7|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(914, 0, -1669.66, 2597.51, 81.4453, 354.278, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(915, 0, -1670.13, 2546.39, 85.2387, 179.28, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(916, 0, -1668.16, 2486.36, 87.1723, 265.508, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(917, 0, -1589.83, 2706.5, 56.1762, 183.079, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(918, 0, -1577.56, 2687.01, 55.8359, 183.079, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(919, 0, -1565.13, 2712.03, 55.8594, 268.485, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(920, 0, -1550.43, 2699.72, 56.2699, 89.9787, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(921, 0, -1529.77, 2686.22, 55.8359, 266.129, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(922, 0, -1482.53, 2702.71, 56.2543, 180.391, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(923, 0, -1465.86, 2693, 56.2699, 85.4452, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(924, 0, -1450.23, 2690.89, 56.1762, 85.4452, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(925, 0, -1445.13, 2653.2, 56.2699, 270.257, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(926, 0, -1459.67, 2653.44, 55.8359, 270.257, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(927, 0, -1446.55, 2637.26, 56.2543, 176.25, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(928, 0, -1512.45, 2646.76, 56.1762, 86.8318, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(929, 0, -1587.02, 2650.16, 55.8594, 86.2443, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(930, 0, -1476.2, 2563.3, 56.1762, 181.649, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(931, 0, -1478.58, 2547.39, 56.2543, 151.882, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|1|1|2|6|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(932, 0, -1450.08, 2562.31, 56.0233, 4.39111, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(933, 0, -1370.37, 2052.93, 52.5156, 121.085, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(934, 0, -939.483, 1425.35, 30.434, 272.074, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(935, 0, -636.374, 1446.76, 13.9965, 124.79, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(936, 0, -650.358, 1450.32, 13.6796, 84.5934, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(937, 0, -690.065, 1444.36, 17.809, 264.985, 0, 0, 0, 0, 'The State', 50000, 1, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(938, 0, -715.513, 1438.79, 18.8871, 87.2451, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(939, 0, -742.944, 1432.58, 16.1164, 183.259, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(940, 0, 709.906, 1194.71, 13.3964, 266.936, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '3|-1|1|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(941, 0, 500.841, 1116.3, 15.0356, 266.936, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(942, 0, 866.623, -1798.94, 13.8157, 353.992, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 0, 858.798, -1795.5, 13.5624, 89.9841, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(943, 0, 1439.21, 57.3522, 32.352, 223.304, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1449.21, 81.4588, 31.3301, 310.411, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1473.173217|80.756713|28.811300|37.499946', '1445.816162|90.303604|31.446689|307.443054', 1),
(944, 0, 1470.98, 34.7591, 31.0667, 34.6525, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1481.34, 51.9497, 30.9088, 127.908, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1448.552856|38.073928|29.968563|39.899906', '1461.616210|19.086053|31.239305|128.943420', 1),
(945, 0, 1390.12, 32.6318, 33.0445, 302.148, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1406.26, 46.7549, 32.4092, 223.837, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1420.335449|39.331470|30.184049|42.000057', '1389.362792|42.315319|33.043323|308.775360', 1),
(946, 0, 1419.79, 10.8612, 33.1264, 42.7291, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1401.72, -22.5169, 33.0254, 38.5108, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1394.986938|-6.784657|32.030738|41.099922', '1410.590332|-9.413962|32.733669|129.523376', 1),
(947, 0, 1335.83, -13.5605, 35.1484, 226.466, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1326.94, -27.1154, 35.5851, 314.971, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|7|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1360.499755|-13.066591|32.093086|-138.299926', '1347.013427|5.502511|34.620750|311.861419', 1),
(948, 0, 1366.72, -49.188, 34.6705, 129.476, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1349.61, -67.4656, 35.3436, 42.8507, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '33|32|13', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1344.103027|-52.122268|33.909091|42.699939', '1366.831176|-63.126502|34.838161|130.103195', 1),
(949, 0, 1310.89, -104.767, 36.9431, 33.4502, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1332.52, -149.161, 36.5763, 119.403, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1285.747436|-103.729141|36.129863|39.799980', '1354.143920|-127.134185|35.989501|130.337478', 1),
(950, 0, 1236.44, -92.2283, 40.1503, 305.983, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 1, 0, -1, 0, 1269.55, -74.3013, 37.6574, 222.13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1275.717285|-89.171051|35.395362|-140.299880', '1261.039062|-92.057098|38.085536|307.044158', 1),
(951, 0, 1277.05, 17.5145, 28.2454, 190.965, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 0, 1282.94, -3.62431, 29.6638, 107.304, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1267.221069|-1.897246|27.474981|105.999679', '1286.355957|14.084128|29.113594|191.736801', 1),
(952, 0, 1251.96, 101.787, 22.1294, 85.6377, 0, 0, 0, 0, 'The State', 1500000, 0, 1, 1, 4, 1, 0, 0, -1, 0, 1266.95, 66.5446, 23.4796, 86.5779, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '10|-1|-1|11|12|-1|13|10|14|13|-1|8|14|-1|-1|15|16|17|-1|-1|-1|-1|-1|-1|-1|10|0', '7|20|12', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '1249.424072|71.685272|21.365985|88.599754', '1261.593627|82.113212|22.659521|177.590438', 1),
(953, 0, -658.494, 1447.02, 13.7342, 264.985, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(954, 0, -1568.1, 2630.32, 55.8403, 177.609, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(955, 0, -1445.28, 2562.31, 56.0233, 4.39111, 0, 0, 0, 0, 'The State', 50000, 3, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(956, 0, -2463.3, 2485.96, 17.0025, 92.2071, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(957, 0, 710.498, 1208.05, 13.8481, 177.177, 0, 0, 0, 0, 'The State', 50000, 2, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(958, 0, 2461.25, 1682.87, 11.0234, 178.912, 421.536, 2536.47, 10, 0, 'The State', 50000, 0, 1, 1, 1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(959, 0, -795.856, 2259.56, 59.4689, 157.346, 0, 0, 0, 0, 'The State', 50000, 4, 1, 1, 1, 1, 0, 0, -1, 0, -800.055, 2257.81, 58.6157, 89.9304, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '6|-1|6|14|2|-1|-1|-1|-1|3|3|3|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0),
(960, 0, -650.759, 1445.73, 13.6796, 84.5934, 0, 0, 0, 0, 'The State', 50000, 0, 1, 1, 1, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|-1|0|1|2|-1|-1|-1|-1|0|1|2|3|-1|-1|-1|-1|-1|0|0|-1|1|-1|-1|-1|-1|-1', '0|0|0', 0, 0, 0, 0, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 0, '0.000000|0.000000|0.000000|0.000000', '0.000000|0.000000|0.000000|0.000000', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `inventory`
--

CREATE TABLE `inventory` (
  `mysql_id` int(11) NOT NULL,
  `slot_id` int(11) NOT NULL DEFAULT 0,
  `owner_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ИД КТО ВЛАДЕЕТ',
  `owner_type` int(11) NOT NULL DEFAULT 0 COMMENT 'ТИП КТО ВЛАДЕЕТ',
  `item_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ИД ВЕЩИ',
  `status_use` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'СТАТУС ИСПОЛЬЗОВАНИЯ',
  `amount` int(11) NOT NULL DEFAULT 0 COMMENT 'КОЛИЧЕСТВО',
  `market_count` int(11) NOT NULL DEFAULT 0,
  `market_price` int(11) NOT NULL DEFAULT 0,
  `acc_slot` int(11) NOT NULL DEFAULT -1,
  `acc_mt1` int(11) NOT NULL DEFAULT 0,
  `acc_mt2` int(11) NOT NULL DEFAULT 0,
  `inv_acc_premium` int(11) NOT NULL DEFAULT 0,
  `inv_skin_premium` int(11) NOT NULL DEFAULT 0,
  `acc_wear` float NOT NULL DEFAULT 100,
  `skin_wear` float NOT NULL DEFAULT 100,
  `acc_pos` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Дамп данных таблицы `inventory`
--

INSERT INTO `inventory` (`mysql_id`, `slot_id`, `owner_id`, `owner_type`, `item_id`, `status_use`, `amount`, `market_count`, `market_price`, `acc_slot`, `acc_mt1`, `acc_mt2`, `inv_acc_premium`, `inv_skin_premium`, `acc_wear`, `skin_wear`, `acc_pos`) VALUES
(1, 0, 1, 0, 200, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(2, 0, 2, 0, 212, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(3, 1, 2, 0, 137, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(4, 7, 2, 0, 186, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 99.8, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(5, 0, 3, 0, 78, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(6, 0, 4, 0, 137, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(7, 1, 3, 0, 512, 1, 1, 0, 0, 7, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(8, 2, 3, 0, 438, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(29, 2, 2, 0, 136, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(30, 3, 3, 0, 641, 0, 6, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(31, 4, 3, 0, 512, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(33, 11, 3, 0, 610, 1, 1, 0, 0, 9, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(34, 17, 3, 0, 438, 1, 1, 0, 0, 8, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(35, 9, 3, 0, 559, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(36, 7, 3, 0, 464, 1, 1, 0, 0, 6, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(39, 6, 3, 0, 674, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(43, 0, 5, 0, 79, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(44, 8, 3, 0, 723, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(47, 0, 6, 0, 230, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(48, 1, 6, 0, 96, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(53, 18, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(54, 0, 7, 0, 230, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(55, 5, 3, 0, 723, 0, 3, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(57, 13, 3, 0, 645, 0, 1787, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(58, 14, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(59, 16, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(60, 19, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(61, 20, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(62, 21, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(63, 22, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(64, 23, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(65, 24, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(66, 25, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(67, 26, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(68, 27, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(69, 28, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(70, 29, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(71, 30, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(72, 31, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(73, 32, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(74, 33, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(75, 34, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(76, 35, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(77, 36, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(78, 37, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(79, 38, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(80, 39, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(81, 40, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(82, 41, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(83, 42, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(84, 43, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(85, 44, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(86, 45, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(87, 46, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(88, 47, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(89, 48, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(90, 49, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(91, 50, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(92, 51, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(93, 52, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(94, 53, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(95, 54, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(96, 55, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(97, 56, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(98, 57, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(99, 58, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(100, 59, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(101, 60, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(102, 61, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(103, 62, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(104, 63, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(105, 64, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(106, 65, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(107, 66, 3, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(108, 67, 3, 0, 645, 0, 2458, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(109, 12, 3, 0, 645, 0, 2, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(110, 68, 3, 0, 718, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(111, 20, 4, 0, 723, 0, 2, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(112, 0, 8, 0, 230, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(113, 69, 3, 0, 678, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(114, 0, 9, 0, 9, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(115, 0, 10, 0, 212, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(116, 0, 11, 0, 79, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(117, 0, 12, 0, 78, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(118, 1, 11, 0, 15, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(119, 7, 11, 0, 720, 0, 3, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(120, 2, 11, 0, 45, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 99.8, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(121, 3, 11, 0, 312, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(122, 0, 13, 0, 137, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(124, 5, 11, 0, 705, 0, 2, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(125, 6, 11, 0, 706, 0, 3, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(126, 8, 11, 0, 644, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(127, 14, 11, 0, 642, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(128, 4, 11, 0, 702, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(129, 9, 11, 0, 721, 0, 6, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(130, 0, 14, 0, 79, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(131, 0, 15, 0, 230, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(132, 10, 11, 0, 642, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(133, 0, 16, 0, 69, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(134, 0, 17, 0, 212, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(135, 11, 11, 0, 727, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(136, 1, 15, 0, 200, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(137, 17, 15, 0, 300, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(138, 8, 15, 0, 302, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(139, 7, 15, 0, 304, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(140, 3, 15, 0, 445, 1, 1, 0, 0, 7, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(141, 4, 15, 0, 558, 1, 1, 0, 0, 2, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(142, 5, 15, 0, 587, 2, 1, 0, 0, 0, 0, 0, 0, 0, 99.8, 100, '0.121996|-0.196004|-0.050001|356.580017|-91.539993|-4.999997|0.055998|0.003000|0.096998'),
(143, 6, 15, 0, 465, 1, 1, 0, 0, 5, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(144, 35, 15, 0, 454, 1, 1, 0, 0, 6, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(145, 10, 15, 0, 464, 1, 1, 0, 0, 1, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(146, 15, 15, 0, 586, 1, 1, 0, 0, 3, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(147, 11, 15, 0, 626, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(148, 13, 15, 0, 610, 1, 1, 0, 0, 4, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(149, 9, 15, 0, 738, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(150, 2, 15, 0, 674, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(151, 16, 15, 0, 729, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(152, 12, 15, 0, 644, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(153, 18, 15, 0, 666, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(154, 14, 15, 0, 678, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(156, 38, 15, 0, 102, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 99.8, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(157, 25, 15, 0, 727, 0, 2, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(158, 0, 18, 0, 137, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(159, 0, 19, 0, 137, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(160, 1, 19, 0, 3, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(161, 19, 15, 0, 74, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(162, 1, 18, 0, 204, 0, 1, 0, 0, -1, 0, 0, 0, 1, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(163, 2, 18, 0, 586, 1, 1, 0, 0, 9, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(164, 3, 18, 0, 445, 1, 1, 0, 0, 7, 0, 0, 1, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(165, 4, 18, 0, 587, 1, 1, 0, 0, 8, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(166, 5, 18, 0, 454, 1, 1, 0, 0, 6, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(167, 6, 18, 0, 558, 1, 1, 0, 0, 4, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(168, 7, 18, 0, 438, 1, 1, 0, 0, 5, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(169, 8, 18, 0, 464, 1, 1, 0, 0, 3, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(170, 9, 18, 0, 610, 1, 1, 0, 0, 2, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(173, 12, 18, 0, 738, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(174, 13, 18, 0, 676, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(176, 21, 15, 0, 738, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(178, 22, 15, 0, 641, 0, 500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(179, 23, 15, 0, 645, 0, 500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(180, 10, 18, 0, 115, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 99.8, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(181, 11, 18, 0, 445, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(182, 10, 3, 0, 115, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(183, 14, 18, 0, 482, 1, 1, 0, 0, 6, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(189, 26, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(190, 0, 20, 0, 212, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(195, 0, 21, 0, 200, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(196, 0, 22, 0, 79, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(197, 0, 23, 0, 212, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(198, 1, 20, 0, 727, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(199, 24, 15, 0, 723, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(200, 15, 18, 0, 537, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(201, 16, 18, 0, 456, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(202, 17, 18, 0, 475, 1, 1, 0, 0, 4, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(203, 18, 18, 0, 586, 1, 1, 0, 0, 8, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(207, 22, 18, 0, 646, 0, 50, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(208, 23, 18, 0, 646, 0, 50, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(209, 24, 18, 0, 646, 0, 50, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(211, 26, 18, 0, 646, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(213, 19, 18, 0, 646, 0, 50, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(215, 25, 18, 0, 646, 0, 50, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(217, 21, 18, 0, 646, 0, 50, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(219, 12, 11, 0, 725, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(220, 13, 11, 0, 728, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(221, 0, 24, 0, 79, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 99.8, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(255, 0, 25, 0, 137, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(262, 32, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(263, 33, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(264, 34, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(265, 35, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(266, 36, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(267, 37, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(268, 38, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(269, 39, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(270, 40, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(271, 41, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(272, 42, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(273, 43, 18, 0, 629, 0, 1000, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(274, 44, 18, 0, 629, 0, 552, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(275, 0, 25, 0, 674, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(283, 30, 18, 0, 641, 0, 2258, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(284, 31, 18, 0, 641, 0, 500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(285, 45, 18, 0, 738, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(286, 46, 18, 0, 572, 1, 1, 0, 0, 1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(287, 47, 18, 0, 593, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(288, 0, 27, 0, 137, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(290, 21, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(291, 22, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(292, 23, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(293, 24, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(294, 25, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(295, 27, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(296, 28, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(297, 29, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(298, 30, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(299, 31, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(300, 32, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(301, 33, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(302, 34, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(303, 35, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(304, 36, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(305, 37, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(306, 38, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(307, 39, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(308, 40, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(309, 41, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(310, 42, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(311, 43, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(312, 44, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(313, 45, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(314, 46, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(315, 47, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(316, 48, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(317, 49, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(318, 50, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(319, 51, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(320, 52, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(321, 53, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(322, 54, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(323, 55, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(324, 56, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(325, 57, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(326, 58, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(327, 59, 4, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(328, 19, 26, 0, 115, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 99.8, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(329, 1, 26, 0, 150, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 99.8, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(330, 2, 26, 0, 438, 1, 1, 0, 0, 7, 0, 0, 0, 0, 99.6, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(331, 3, 26, 0, 454, 0, 1, 0, 0, -1, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(332, 4, 26, 0, 169, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(333, 0, 26, 0, 464, 1, 1, 0, 0, 4, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(334, 6, 26, 0, 559, 1, 1, 0, 0, 3, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(335, 7, 26, 0, 455, 1, 1, 0, 0, 2, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(336, 10, 26, 0, 445, 1, 1, 0, 0, 8, 0, 0, 0, 0, 99.6, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(337, 8, 26, 0, 587, 1, 1, 0, 0, 6, 0, 0, 0, 0, 99.6, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(338, 5, 26, 0, 626, 1, 1, 0, 0, 5, 0, 0, 0, 0, 99.6, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(341, 13, 26, 0, 681, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(343, 15, 26, 0, 681, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(344, 16, 26, 0, 610, 1, 1, 0, 0, 9, 0, 0, 0, 0, 99.6, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(345, 17, 26, 0, 645, 0, 2440, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(346, 18, 26, 0, 586, 0, 1, 0, 0, -1, 0, 0, 0, 0, 99.8, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(347, 0, 29, 0, 137, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(349, 48, 18, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(351, 0, 30, 0, 230, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(352, 20, 18, 0, 442, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(353, 27, 18, 0, 514, 1, 1, 0, 0, 0, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(354, 23, 26, 0, 723, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(355, 28, 18, 0, 641, 0, 12, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(356, 29, 18, 0, 645, 0, 2468, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(357, 15, 11, 0, 587, 1, 1, 0, 0, 3, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(358, 16, 11, 0, 445, 1, 1, 0, 0, 5, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(359, 17, 11, 0, 465, 1, 1, 0, 0, 7, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(360, 18, 11, 0, 455, 1, 1, 0, 0, 9, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(361, 19, 11, 0, 558, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(362, 21, 11, 0, 681, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(363, 20, 11, 0, 729, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(364, 22, 11, 0, 738, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(365, 49, 18, 0, 162, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(366, 56, 18, 0, 150, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(367, 20, 26, 0, 677, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(368, 50, 18, 0, 645, 0, 2500, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(369, 51, 18, 0, 645, 0, 692, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(371, 21, 26, 0, 74, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(372, 23, 11, 0, 626, 1, 1, 0, 0, 2, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(373, 24, 11, 0, 464, 1, 1, 0, 0, 1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(374, 25, 11, 0, 576, 1, 1, 0, 0, 0, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(375, 26, 11, 0, 513, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(376, 9, 26, 0, 46, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(377, 22, 26, 0, 642, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(378, 14, 26, 0, 679, 0, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(379, 0, 31, 0, 230, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(380, 0, 32, 0, 79, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0'),
(381, 0, 33, 0, 79, 1, 1, 0, 0, -1, 0, 0, 0, 0, 100, 100, '0.0|0.0|0.0|0.0|0.0|0.0|1.0|1.0|1.0');

-- --------------------------------------------------------

--
-- Структура таблицы `ip_logs_list`
--

CREATE TABLE `ip_logs_list` (
  `ip` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Целевой IP адрес',
  `info` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Информация по этому IP'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Список IP адресов для которых должно быть включено логирование того или иного типа';

-- --------------------------------------------------------

--
-- Структура таблицы `log_fraction`
--

CREATE TABLE `log_fraction` (
  `ID` int(11) NOT NULL,
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `Member` int(11) NOT NULL DEFAULT 0,
  `Rang` int(11) NOT NULL DEFAULT 0,
  `Type` int(11) NOT NULL DEFAULT 0,
  `Reason` varchar(70) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `CreateData` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Трудовая книжка';

--
-- Дамп данных таблицы `log_fraction`
--

INSERT INTO `log_fraction` (`ID`, `PlayerID`, `Member`, `Rang`, `Type`, `Reason`, `CreateData`) VALUES
(1, 11, 1, 10, 1, 'Уволил Администратор', '2026-02-26 22:20:36'),
(2, 11, 25, 10, 1, 'Уволил Администратор', '2026-02-26 22:22:12'),
(3, 11, 5, 10, 1, 'Уволил Администратор', '2026-02-27 08:33:57'),
(4, 11, 10, 10, 1, 'Уволил Администратор', '2026-03-02 14:20:43'),
(5, 11, 12, 10, 1, 'Уволил Администратор', '2026-03-02 14:34:02'),
(6, 11, 13, 10, 1, 'Уволил Администратор', '2026-03-02 14:37:25'),
(7, 18, 19, 10, 1, 'Уволил Администратор', '2026-03-02 15:39:30'),
(8, 18, 4, 10, 1, 'Уволил Администратор', '2026-03-02 16:10:07'),
(9, 18, 1, 10, 1, 'Уволил Администратор', '2026-03-02 20:16:26'),
(10, 18, 4, 10, 1, 'Уволил Администратор', '2026-03-02 20:29:48'),
(11, 18, 5, 10, 1, 'Уволил Администратор', '2026-03-02 20:32:51'),
(12, 18, 10, 10, 1, 'Уволил Администратор', '2026-03-03 13:13:30'),
(13, 26, 1, 10, 1, 'Уволил Администратор', '2026-03-03 19:58:24'),
(14, 18, 8, 10, 1, 'Уволил Администратор', '2026-03-03 19:58:26'),
(15, 26, 0, 0, 1, 'Уволил Администратор', '2026-03-03 19:59:49'),
(16, 26, 0, 0, 1, 'Уволил Администратор', '2026-03-03 20:08:32'),
(17, 18, 0, 0, 1, 'Уволил Администратор', '2026-03-03 20:08:35'),
(18, 11, 0, 0, 1, 'Уволил Администратор', '2026-03-03 20:08:37'),
(19, 26, 3, 1, 0, '0', '2026-03-04 08:28:27'),
(20, 26, 3, 1, 1, 'Ушел по С/Ж', '2026-03-04 08:36:43'),
(21, 31, 25, 10, 1, 'Уволил Администратор', '2026-03-04 13:09:35'),
(22, 18, 20, 10, 1, 'Уволил Администратор', '2026-03-04 13:10:44'),
(23, 31, 0, 0, 1, 'Уволил Администратор', '2026-03-04 13:11:14'),
(24, 18, 6, 10, 1, 'Уволил Администратор', '2026-03-04 13:57:05'),
(25, 20, 1, 10, 1, 'Уволил Администратор', '2026-03-04 14:04:47'),
(26, 22, 11, 10, 1, 'Уволил Администратор', '2026-03-04 14:20:49'),
(27, 22, 11, 10, 1, 'Уволил Администратор', '2026-03-04 14:22:02'),
(28, 20, 0, 0, 1, 'Уволил Администратор', '2026-03-04 14:26:20'),
(29, 18, 12, 10, 1, 'Уволил Администратор', '2026-03-04 14:58:24'),
(30, 31, 0, 0, 1, 'Уволил Администратор', '2026-03-04 15:18:58');

-- --------------------------------------------------------

--
-- Структура таблицы `log_name`
--

CREATE TABLE `log_name` (
  `ID` int(11) NOT NULL,
  `OWNER` int(11) NOT NULL,
  `OLD_NAME` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NEW_NAME` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DATA` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='История никнеймов';

--
-- Дамп данных таблицы `log_name`
--

INSERT INTO `log_name` (`ID`, `OWNER`, `OLD_NAME`, `NEW_NAME`, `DATA`) VALUES
(1, 4, 'xScandal_Revengen', 'Boot_Heyn', '2026-02-17 22:15:43');

-- --------------------------------------------------------

--
-- Структура таблицы `mayor`
--

CREATE TABLE `mayor` (
  `pick` int(11) NOT NULL DEFAULT 0,
  `name` varchar(256) CHARACTER SET utf8 NOT NULL DEFAULT 'None, None, None, None, None, None, None',
  `time` int(11) NOT NULL DEFAULT 0,
  `votes` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT '0, 0, 0, 0, 0, 0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `mayor`
--

INSERT INTO `mayor` (`pick`, `name`, `time`, `votes`) VALUES
(0, 'None, None, None, None, None, None, None', 1772677902, '0, 0, 0, 0, 0, 0, 0');

-- --------------------------------------------------------

--
-- Структура таблицы `network`
--

CREATE TABLE `network` (
  `id` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL DEFAULT 0,
  `name` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT 'None',
  `x` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `y` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `z` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `rx` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `ry` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `rz` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `world` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `prog` int(11) NOT NULL DEFAULT 0,
  `planted` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `other`
--

CREATE TABLE `other` (
  `newsprice` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '25, 10, 500',
  `newspricesf` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '25, 10, 500',
  `Donate` int(11) NOT NULL DEFAULT 1000,
  `Experian` int(11) NOT NULL DEFAULT 1,
  `newspricelv` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '25, 10, 500',
  `max_deposit` int(11) NOT NULL DEFAULT 50000000,
  `Salary` int(11) NOT NULL DEFAULT 1,
  `DonationMultiplier` int(11) NOT NULL DEFAULT 1,
  `Deposit` int(11) NOT NULL DEFAULT 1,
  `warehouse_materials` int(11) NOT NULL DEFAULT 0,
  `warehouse_cartridges` int(11) NOT NULL DEFAULT 0,
  `warehouse_medicines` int(11) NOT NULL DEFAULT 0,
  `farm_warehouse_tree` int(11) NOT NULL DEFAULT 0,
  `farm_warehouse_milker` int(11) NOT NULL DEFAULT 0,
  `farm_warehouse_product` int(11) NOT NULL DEFAULT 0,
  `roulette_spin` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0',
  `roulette_spin_count` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0',
  `roulette_stats_bronze` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `roulette_stats_silver` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `roulette_stats_gold` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_open` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_open_count` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_0` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_1` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_2` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_3` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_4` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_5` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_6` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_7` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_8` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_9` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_10` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_11` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_12` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_13` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_14` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_15` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_16` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_17` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_18` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `case_stats_19` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `drugden` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0',
  `change_gift_coins_warehouse` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 100, 100, 100, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10',
  `containers_money_spent` int(11) NOT NULL DEFAULT 0,
  `containers_money_received` int(11) NOT NULL DEFAULT 0,
  `curs_btc` int(11) NOT NULL DEFAULT 10000,
  `vc_warehouse` int(11) NOT NULL DEFAULT 100,
  `panel_warehouse` int(11) NOT NULL DEFAULT 100,
  `undergroundbots_warehouse` int(11) NOT NULL DEFAULT 100,
  `cotton_warehouse` int(11) NOT NULL DEFAULT 100,
  `linen_warehouse` int(11) NOT NULL DEFAULT 100,
  `battlepasstime` int(11) NOT NULL DEFAULT 0,
  `battlepassseason` int(11) NOT NULL DEFAULT 0,
  `MailerStatus` int(11) NOT NULL DEFAULT 0,
  `RegistrationMail` int(11) NOT NULL DEFAULT 0,
  `RegistrationStatus` int(11) NOT NULL DEFAULT 0,
  `BlockInvalidClient` int(11) NOT NULL DEFAULT 0,
  `RouletteSystem` int(11) NOT NULL DEFAULT 0,
  `CaseSystem` int(11) NOT NULL DEFAULT 0,
  `RealCarsStatus` int(11) NOT NULL DEFAULT 0,
  `RealSkinsStatus` int(11) NOT NULL DEFAULT 0,
  `AntiDMSystem` int(11) NOT NULL DEFAULT 0,
  `FreezeOnDM` int(11) NOT NULL DEFAULT 0,
  `TrashSystem` int(11) NOT NULL DEFAULT 0,
  `VKSecurity` int(11) NOT NULL DEFAULT 0,
  `TGSecurity` int(11) NOT NULL DEFAULT 0,
  `SecurityBotURL` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Прочее - настройки, константы и т.д.';

--
-- Дамп данных таблицы `other`
--

INSERT INTO `other` (`newsprice`, `newspricesf`, `Donate`, `Experian`, `newspricelv`, `max_deposit`, `Salary`, `DonationMultiplier`, `Deposit`, `warehouse_materials`, `warehouse_cartridges`, `warehouse_medicines`, `farm_warehouse_tree`, `farm_warehouse_milker`, `farm_warehouse_product`, `roulette_spin`, `roulette_spin_count`, `roulette_stats_bronze`, `roulette_stats_silver`, `roulette_stats_gold`, `case_open`, `case_open_count`, `case_stats_0`, `case_stats_1`, `case_stats_2`, `case_stats_3`, `case_stats_4`, `case_stats_5`, `case_stats_6`, `case_stats_7`, `case_stats_8`, `case_stats_9`, `case_stats_10`, `case_stats_11`, `case_stats_12`, `case_stats_13`, `case_stats_14`, `case_stats_15`, `case_stats_16`, `case_stats_17`, `case_stats_18`, `case_stats_19`, `drugden`, `change_gift_coins_warehouse`, `containers_money_spent`, `containers_money_received`, `curs_btc`, `vc_warehouse`, `panel_warehouse`, `undergroundbots_warehouse`, `cotton_warehouse`, `linen_warehouse`, `battlepasstime`, `battlepassseason`, `MailerStatus`, `RegistrationMail`, `RegistrationStatus`, `BlockInvalidClient`, `RouletteSystem`, `CaseSystem`, `RealCarsStatus`, `RealSkinsStatus`, `AntiDMSystem`, `FreezeOnDM`, `TrashSystem`, `VKSecurity`, `TGSecurity`, `SecurityBotURL`) VALUES
('25, 10, 500', '25, 10, 500', 1000, 1, '25, 10, 500', 50000000, 1, 2, 1, 0, 0, 0, 0, 0, 5000, '0, 0, 1', '0, 0, 1', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50', '0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 650000, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0', '12, 0, 500, 500, 500, 100000', '5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 100, 100, 100, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10', 0, 0, 10000, 90, 100, 100, 100, 100, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, '');

-- --------------------------------------------------------

--
-- Структура таблицы `panel`
--

CREATE TABLE `panel` (
  `id` int(11) NOT NULL,
  `day` int(11) NOT NULL DEFAULT 0,
  `breaking` int(11) NOT NULL DEFAULT 0,
  `breakingpayday` int(11) NOT NULL DEFAULT 0,
  `repair` int(11) NOT NULL DEFAULT 0,
  `wear` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `tax` int(11) NOT NULL DEFAULT 0,
  `house` int(11) NOT NULL DEFAULT 0,
  `x` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `y` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `z` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `rx` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `ry` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `rz` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `parkings`
--

CREATE TABLE `parkings` (
  `p_mysql_id` int(11) NOT NULL,
  `p_enterX` float NOT NULL DEFAULT 0,
  `p_enterY` float NOT NULL DEFAULT 0,
  `p_enterZ` float NOT NULL DEFAULT 0,
  `p_enterA` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `phone_contacts`
--

CREATE TABLE `phone_contacts` (
  `NickPlayer` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NickTarget` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MissedCalls` int(11) DEFAULT 0,
  `BlackList` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `phone_messages`
--

CREATE TABLE `phone_messages` (
  `NickPlayer` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NickTarget` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Text` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Read` int(11) DEFAULT 1,
  `Time` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `player_fine`
--

CREATE TABLE `player_fine` (
  `mysql_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `amount` int(11) NOT NULL DEFAULT 0,
  `date` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `player_notification`
--

CREATE TABLE `player_notification` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT 0,
  `text_notify` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Таблица offile-оповещения игроков при входе в игру.';

--
-- Дамп данных таблицы `player_notification`
--

INSERT INTO `player_notification` (`id`, `user_id`, `text_notify`, `date`) VALUES
(3, 18, '{ffffff}У Вас забрали дом {ffb94f}№234 {ffffff}из-за не оплаты аренды .\n{ffffff}Вам возвращено за дом {ffb94f}750000$.', '2026-03-03 15:02:30'),
(4, 21, '{ffffff}У Вас забрали дом {ffb94f}№620 {ffffff}из-за не оплаты аренды .\n{ffffff}Вам возвращено за дом {ffb94f}125000$.', '2026-03-03 16:02:30'),
(5, 20, '{ffffff}У Вас забрали дом {ffb94f}№621 {ffffff}из-за не оплаты аренды .\n{ffffff}Вам возвращено за дом {ffb94f}25000$.', '2026-03-03 16:02:30'),
(6, 18, '{ffffff}У Вас забрали бизнес {ffb94f}№27 {ffffff}из-за не оплаты аренды.', '2026-03-03 17:05:00'),
(7, 15, '{ffffff}У Вас забрали бизнес {ffb94f}№83 {ffffff}из-за не оплаты аренды.', '2026-03-03 17:05:00'),
(8, 15, '{ffffff}У Вас забрали бизнес {ffb94f}№99 {ffffff}из-за не оплаты аренды.', '2026-03-03 17:05:00'),
(9, 15, '{ffffff}У Вас забрали бизнес {ffb94f}№118 {ffffff}из-за не оплаты аренды.', '2026-03-03 17:05:00'),
(10, 26, '{ffffff}У Вас забрали дом {ffb94f}№38 {ffffff}из-за не оплаты аренды .\n{ffffff}Вам возвращено за дом {ffb94f}125000$.', '2026-03-04 20:02:30'),
(11, 18, '{ffffff}У Вас забрали дом {ffb94f}№40 {ffffff}из-за не оплаты аренды .\n{ffffff}Вам возвращено за дом {ffb94f}750000$.', '2026-03-04 20:02:30');

-- --------------------------------------------------------

--
-- Структура таблицы `promo`
--

CREATE TABLE `promo` (
  `name` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activate` int(11) NOT NULL DEFAULT 0,
  `block` int(11) NOT NULL DEFAULT 0,
  `nactivations` int(11) NOT NULL DEFAULT 0,
  `date` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `typepriz` int(11) NOT NULL DEFAULT 0,
  `amountpriz` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Промокоды';

-- --------------------------------------------------------

--
-- Структура таблицы `promocode`
--

CREATE TABLE `promocode` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT 'None',
  `ownerid` int(11) NOT NULL DEFAULT 0,
  `owner` varchar(32) NOT NULL DEFAULT 'None',
  `donate` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `activation` int(11) NOT NULL DEFAULT 0,
  `createtimestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `promo_activations`
--

CREATE TABLE `promo_activations` (
  `account_id` int(11) NOT NULL,
  `name_promo` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Активации промокодов игроками';

-- --------------------------------------------------------

--
-- Структура таблицы `radars`
--

CREATE TABLE `radars` (
  `rID` int(11) UNSIGNED NOT NULL,
  `rRadius` int(11) NOT NULL DEFAULT 60,
  `rSpeed` int(11) NOT NULL DEFAULT 60,
  `rX` float NOT NULL DEFAULT 0,
  `rY` float NOT NULL DEFAULT 0,
  `rZ` float NOT NULL DEFAULT 0,
  `rRZ` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Радары';

-- --------------------------------------------------------

--
-- Структура таблицы `resources_house`
--

CREATE TABLE `resources_house` (
  `id` int(11) NOT NULL,
  `house` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `object` int(11) NOT NULL DEFAULT 19473,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `rx` float NOT NULL DEFAULT 0,
  `ry` float NOT NULL DEFAULT 0,
  `rz` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `roulette`
--

CREATE TABLE `roulette` (
  `id` int(11) NOT NULL,
  `userID` int(11) NOT NULL DEFAULT 0,
  `itemID` int(11) NOT NULL DEFAULT 0,
  `extraData1` int(11) NOT NULL DEFAULT 0,
  `extraData2` int(11) NOT NULL DEFAULT 0,
  `extraData3` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `sell_block` int(11) NOT NULL DEFAULT 0,
  `activated` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `roulette`
--

INSERT INTO `roulette` (`id`, `userID`, `itemID`, `extraData1`, `extraData2`, `extraData3`, `price`, `sell_block`, `activated`) VALUES
(1, 2, 8, 186, 100000, 0, 5000, 0, 1),
(2, 3, 8, 115, 100000, 0, 3800, 0, 1),
(3, 4, 8, 169, 100000, 0, 4000, 0, 1),
(4, 4, 8, 115, 100000, 0, 3800, 0, 1),
(5, 4, 8, 150, 100000, 0, 4000, 0, 1),
(6, 4, 2, 650000, 0, 0, 0, 0, 1),
(7, 4, 11, 420, 100000, 0, 1840, 0, 1),
(8, 4, 11, 522, 100000, 0, 5000, 0, 1),
(9, 3, 8, 115, 100000, 0, 3800, 0, 1),
(10, 3, 11, 420, 100000, 0, 1840, 0, 1),
(11, 3, 11, 522, 100000, 0, 5000, 0, 1),
(12, 3, 11, 557, 100000, 0, 5000, 0, 1),
(13, 3, 7, 481, 0, 0, 0, 0, 0),
(14, 3, 7, 475, 0, 0, 0, 0, 0),
(15, 3, 7, 513, 0, 0, 0, 0, 0),
(16, 3, 6, 1, 642, 0, 0, 0, 0),
(17, 3, 7, 516, 0, 0, 0, 0, 0),
(18, 3, 7, 517, 0, 0, 0, 0, 0),
(19, 3, 7, 485, 0, 0, 0, 0, 0),
(20, 11, 6, 1, 642, 0, 0, 0, 1),
(21, 11, 6, 7, 632, 0, 0, 0, 0),
(22, 11, 6, 1, 642, 0, 0, 0, 1),
(23, 15, 8, 102, 100000, 0, 2730, 0, 1),
(24, 15, 8, 102, 100000, 0, 2730, 0, 0),
(25, 15, 8, 74, 100000, 0, 9200, 0, 1),
(26, 15, 2, 14457, 0, 0, 0, 0, 1),
(27, 18, 8, 204, 100000, 0, 3000, 0, 1),
(28, 18, 2, 8982, 0, 0, 0, 0, 0),
(29, 18, 7, 482, 0, 0, 0, 0, 1),
(30, 18, 1, 5, 0, 0, 0, 0, 0),
(31, 18, 11, 556, 100000, 0, 4550, 0, 1),
(32, 18, 11, 601, 100000, 0, 4600, 0, 0),
(33, 4, 6, 1, 642, 0, 0, 0, 0),
(34, 18, 8, 21, 0, 0, 0, 0, 0),
(35, 11, 6, 1, 642, 0, 0, 0, 0),
(36, 18, 7, 537, 0, 0, 0, 0, 1),
(37, 18, 7, 475, 0, 0, 0, 0, 1),
(38, 18, 7, 456, 0, 0, 0, 0, 1),
(39, 18, 7, 586, 0, 0, 0, 0, 1),
(40, 18, 6, 1, 642, 0, 0, 0, 0),
(41, 18, 6, 1, 642, 0, 0, 0, 0),
(42, 18, 11, 599, 100000, 0, 2730, 0, 1),
(43, 18, 11, 427, 100000, 0, 5000, 0, 1),
(44, 18, 11, 495, 100000, 0, 1840, 0, 1),
(45, 18, 6, 1, 642, 0, 0, 0, 0),
(46, 11, 6, 1, 642, 0, 0, 0, 0),
(47, 18, 6, 6, 632, 0, 0, 0, 0),
(48, 18, 6, 5, 632, 0, 0, 0, 0),
(49, 18, 1, 7, 0, 0, 0, 0, 0),
(50, 18, 6, 1, 642, 0, 0, 0, 0),
(51, 11, 7, 482, 0, 0, 0, 0, 0),
(52, 11, 7, 537, 0, 0, 0, 0, 0),
(53, 11, 7, 481, 0, 0, 0, 0, 0),
(54, 11, 7, 475, 0, 0, 0, 0, 0),
(55, 18, 8, 162, 100000, 0, 6900, 0, 1),
(56, 26, 11, 437, 100000, 0, 1900, 0, 1),
(57, 18, 8, 150, 100000, 0, 3720, 0, 1),
(58, 26, 8, 74, 100000, 0, 10000, 0, 1),
(59, 26, 1, 7, 0, 0, 0, 0, 0),
(60, 11, 8, 149, 100000, 0, 3000, 0, 0),
(61, 26, 6, 1, 642, 0, 0, 0, 1),
(62, 26, 11, 525, 100000, 0, 2000, 0, 1),
(63, 26, 11, 403, 100000, 0, 1750, 0, 1),
(64, 33, 2, 11577, 0, 0, 0, 0, 1),
(65, 33, 8, 74, 100000, 0, 9200, 0, 0),
(66, 33, 2, 12813, 0, 0, 0, 0, 0),
(67, 33, 1, 5, 0, 0, 0, 0, 0),
(68, 33, 2, 12973, 0, 0, 0, 0, 0),
(69, 33, 6, 9, 632, 0, 0, 0, 0),
(70, 33, 6, 7, 632, 0, 0, 0, 0),
(71, 33, 6, 7, 632, 0, 0, 0, 0),
(72, 33, 6, 1, 642, 0, 0, 0, 0),
(73, 33, 2, 10400, 0, 0, 0, 0, 0),
(74, 33, 6, 8, 632, 0, 0, 0, 0),
(75, 33, 2, 13162, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `setbonus`
--

CREATE TABLE `setbonus` (
  `level` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `donate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `setbonus`
--

INSERT INTO `setbonus` (`level`, `money`, `donate`) VALUES
(1, 1000, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `table_ban`
--

CREATE TABLE `table_ban` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name_Admin` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Name_Player` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Ban_Data` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Ban_Reason` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Unban_Data` int(11) DEFAULT NULL,
  `IP` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Банлист' ROW_FORMAT=DYNAMIC;

--
-- Дамп данных таблицы `table_ban`
--

INSERT INTO `table_ban` (`id`, `Name_Admin`, `Name_Player`, `Ban_Data`, `Ban_Reason`, `Unban_Data`, `IP`) VALUES
(13, 'Kizaru_Bishop', 'The_Bizzaro', '2026-03-03 22:39:38', 'Твинк', 1775158778, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `userid` int(11) NOT NULL DEFAULT 0,
  `vehicle` int(11) NOT NULL DEFAULT 0,
  `officer` varchar(24) CHARACTER SET utf8 NOT NULL DEFAULT 'None',
  `faction` int(11) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT 'None',
  `paid` int(11) NOT NULL DEFAULT 1,
  `date` varchar(20) CHARACTER SET utf8 NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `topwars`
--

CREATE TABLE `topwars` (
  `id` int(11) NOT NULL,
  `idAcc` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `topwars`
--

INSERT INTO `topwars` (`id`, `idAcc`) VALUES
(1, 14);

-- --------------------------------------------------------

--
-- Структура таблицы `trafficlights`
--

CREATE TABLE `trafficlights` (
  `tl_mysql_id` int(11) NOT NULL,
  `tl_object_pos_X` float NOT NULL DEFAULT 0,
  `tl_object_pos_Y` float NOT NULL DEFAULT 0,
  `tl_object_pos_Z` float NOT NULL DEFAULT 0,
  `tl_object_pos_RZ` float NOT NULL DEFAULT 0,
  `tl_area_pos_X1` float NOT NULL DEFAULT 0,
  `tl_area_pos_Y1` float NOT NULL DEFAULT 0,
  `tl_area_pos_X2` float NOT NULL DEFAULT 0,
  `tl_area_pos_Y2` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `underground`
--

CREATE TABLE `underground` (
  `id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `education` int(11) NOT NULL DEFAULT 1,
  `air` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `lubricant` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `satiety` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `materials` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0.0',
  `tax` int(11) NOT NULL DEFAULT 0,
  `salary` int(11) NOT NULL DEFAULT 0,
  `items` int(11) NOT NULL DEFAULT 0,
  `house` int(11) NOT NULL DEFAULT 0,
  `biz` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `unitpay_payments`
--

CREATE TABLE `unitpay_payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `unitpayId` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accountId` int(10) UNSIGNED DEFAULT NULL COMMENT 'ID аккаунта игрока',
  `sum` float DEFAULT NULL,
  `itemsCount` int(11) DEFAULT 1,
  `dateCreate` datetime NOT NULL,
  `dateComplete` datetime DEFAULT NULL,
  `dateDelivered` datetime DEFAULT NULL COMMENT 'Дата-время когда производено зачисление на аккаунт',
  `status` tinyint(4) UNSIGNED DEFAULT 0 COMMENT 'Статус успешности оплаты на стороне агрегатора',
  `delivered` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Статус успешности зачисления на аккаунта игрока',
  `ip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Платежи агрегатора Unitpay';

-- --------------------------------------------------------

--
-- Структура таблицы `vehicle`
--

CREATE TABLE `vehicle` (
  `v_mysql_id` int(11) UNSIGNED NOT NULL,
  `v_owner` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `v_owner_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `v_model` int(11) NOT NULL DEFAULT 0,
  `v_custom_id` int(11) NOT NULL DEFAULT 0,
  `v_pos_0` float NOT NULL DEFAULT 0,
  `v_pos_1` float NOT NULL DEFAULT 0,
  `v_pos_2` float NOT NULL DEFAULT 0,
  `v_pos_3` float NOT NULL DEFAULT 10,
  `v_health` float NOT NULL DEFAULT 1000,
  `v_price` int(11) NOT NULL DEFAULT 0,
  `v_voucher` int(11) NOT NULL DEFAULT 0,
  `v_premium` int(11) NOT NULL DEFAULT 0,
  `v_bonus` int(11) NOT NULL DEFAULT 0,
  `v_sell_block` int(11) NOT NULL DEFAULT 0,
  `v_twinturbo` int(11) NOT NULL DEFAULT 0,
  `v_twinturbo_data` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0|0|0|0',
  `v_lock` int(11) NOT NULL DEFAULT 0,
  `v_fuel` float NOT NULL DEFAULT 35,
  `v_color_0` int(11) NOT NULL DEFAULT 0,
  `v_color_1` int(11) NOT NULL DEFAULT 0,
  `v_family_id` int(11) NOT NULL DEFAULT -1,
  `v_family_rang` int(11) NOT NULL DEFAULT 0,
  `v_fraction_id` int(11) NOT NULL DEFAULT 0,
  `v_fraction_rang` int(11) NOT NULL DEFAULT 0,
  `v_procente` int(11) NOT NULL DEFAULT 100,
  `v_details` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '100.0|100.0|100.0|100.0|100.0',
  `v_number` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `v_insurance` int(11) NOT NULL DEFAULT 0,
  `v_insurance_time` int(11) NOT NULL DEFAULT 0,
  `v_market_price` int(11) NOT NULL DEFAULT 0,
  `v_market_time` int(11) NOT NULL DEFAULT 0,
  `v_boot_money` int(11) NOT NULL DEFAULT 0,
  `v_boot_drugs` int(11) NOT NULL DEFAULT 0,
  `v_boot_patr` int(11) NOT NULL DEFAULT 0,
  `v_boot_matr` int(11) NOT NULL DEFAULT 0,
  `v_boot_heal` int(11) NOT NULL DEFAULT 0,
  `v_boot_rem_kit` int(11) NOT NULL DEFAULT 0,
  `v_boot_canister` int(11) NOT NULL DEFAULT 0,
  `v_boot_mask` int(11) NOT NULL DEFAULT 0,
  `v_tun_0` int(11) NOT NULL DEFAULT 0,
  `v_tun_1` int(11) NOT NULL DEFAULT 0,
  `v_tun_2` int(11) NOT NULL DEFAULT 0,
  `v_tun_3` int(11) NOT NULL DEFAULT 0,
  `v_tun_4` int(11) NOT NULL DEFAULT 0,
  `v_tun_5` int(11) NOT NULL DEFAULT 0,
  `v_tun_6` int(11) NOT NULL DEFAULT 0,
  `v_tun_7` int(11) NOT NULL DEFAULT 0,
  `v_tun_8` int(11) NOT NULL DEFAULT 0,
  `v_tun_9` int(11) NOT NULL DEFAULT 0,
  `v_tun_10` int(11) NOT NULL DEFAULT 0,
  `v_tun_11` int(11) NOT NULL DEFAULT 0,
  `v_tun_12` int(11) NOT NULL DEFAULT 0,
  `v_attach_data` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-1|-1|-1|-1|-1|-1|-1|-1',
  `v_int` int(11) NOT NULL DEFAULT 0,
  `v_virt` int(11) NOT NULL DEFAULT 0,
  `v_auction_bet` int(11) NOT NULL DEFAULT 0,
  `v_auction_time` int(11) NOT NULL DEFAULT 0,
  `v_auction_user_id` int(11) NOT NULL DEFAULT 0,
  `v_wanted` int(11) NOT NULL DEFAULT 0,
  `v_impound` int(11) NOT NULL DEFAULT 0,
  `v_tc` int(11) NOT NULL DEFAULT 0,
  `v_tc_idx` int(11) NOT NULL DEFAULT 0,
  `v_wheel_width` int(11) NOT NULL DEFAULT 0,
  `v_wheel_size` float NOT NULL DEFAULT 0,
  `v_wheel_offset_x_0` int(11) NOT NULL DEFAULT 0,
  `v_wheel_offset_x_1` int(11) NOT NULL DEFAULT 0,
  `v_wheel_alignment_0` int(11) NOT NULL DEFAULT 0,
  `v_wheel_alignment_1` int(11) NOT NULL DEFAULT 0,
  `v_lights_color_0` int(11) NOT NULL DEFAULT 0,
  `v_lights_color_1` int(11) NOT NULL DEFAULT 0,
  `v_lights_color_2` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Транспортные средства';

--
-- Дамп данных таблицы `vehicle`
--

INSERT INTO `vehicle` (`v_mysql_id`, `v_owner`, `v_owner_id`, `v_model`, `v_custom_id`, `v_pos_0`, `v_pos_1`, `v_pos_2`, `v_pos_3`, `v_health`, `v_price`, `v_voucher`, `v_premium`, `v_bonus`, `v_sell_block`, `v_twinturbo`, `v_twinturbo_data`, `v_lock`, `v_fuel`, `v_color_0`, `v_color_1`, `v_family_id`, `v_family_rang`, `v_fraction_id`, `v_fraction_rang`, `v_procente`, `v_details`, `v_number`, `v_insurance`, `v_insurance_time`, `v_market_price`, `v_market_time`, `v_boot_money`, `v_boot_drugs`, `v_boot_patr`, `v_boot_matr`, `v_boot_heal`, `v_boot_rem_kit`, `v_boot_canister`, `v_boot_mask`, `v_tun_0`, `v_tun_1`, `v_tun_2`, `v_tun_3`, `v_tun_4`, `v_tun_5`, `v_tun_6`, `v_tun_7`, `v_tun_8`, `v_tun_9`, `v_tun_10`, `v_tun_11`, `v_tun_12`, `v_attach_data`, `v_int`, `v_virt`, `v_auction_bet`, `v_auction_time`, `v_auction_user_id`, `v_wanted`, `v_impound`, `v_tc`, `v_tc_idx`, `v_wheel_width`, `v_wheel_size`, `v_wheel_offset_x_0`, `v_wheel_offset_x_1`, `v_wheel_alignment_0`, `v_wheel_alignment_1`, `v_lights_color_0`, `v_lights_color_1`, `v_lights_color_2`) VALUES
(1, 'Boot_Heyn', 4, 522, 0, 2136.91, -1146.97, 24.1492, 360, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 1, 70, 3, 3, -1, 0, 0, 0, 100, '100.000000|100.000000|100.000000|100.000000|100.000000', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 'Boot_Heyn', 4, 420, 0, 2135.95, 1398.25, 10.5574, 180, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 1, 60, 5, 5, -1, 0, 0, 0, 100, '100.000000|100.000000|100.000000|100.000000|100.000000', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, NULL, 3, 420, 0, 2135.95, 1398.25, 10.5574, 180, 1000, 0, 0, 1, 0, 0, 1, '3|3|3|3', 0, 52.2398, 5, 5, -1, 0, 0, 0, 100, '100.000000|100.000000|100.000000|100.000000|100.000000', 'NULL', 1, 335, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, 1080, 0, 0, 0, 0, 0, 1019, 0, 1012, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, NULL, 3, 557, 0, 2135.95, 1398.25, 10.5574, 180, 1000, 0, 0, 1, 0, 0, 1, '3|3|3|3', 0, 66.2457, 0, 0, -1, 0, 0, 0, 100, '100.000000|100.000000|100.000000|100.000000|100.000000', 'NULL', 1, 335, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, 1080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, NULL, 3, 522, 0, 2136.91, -1146.97, 24.1492, 360, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 1, 70, 4, 4, -1, 0, 0, 0, 100, '100.000000|100.000000|100.000000|100.000000|100.000000', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, NULL, 11, 439, 0, 1649.61, -1111.61, 23.9033, 90, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 0, 0, 1, 0, -1, 0, 0, 0, 100, '99.200012|98.400024|97.751236|99.200012|99.200012', 'SA 45673 D', 1, 335, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(11, NULL, 18, 556, 0, 1334.76, -619.746, 109.471, 106.23, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 0, 56.9658, 5, 5, -1, 0, 0, 0, 100, '99.200012|99.800003|97.849182|99.900002|99.900002', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(14, NULL, 15, 4765, 0, 2135.82, 1427, 10.9, 360, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 1, 42.8998, 31, 31, -1, 0, 0, 0, 100, '99.800003|100.000000|99.645195|100.000000|100.000000', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15, NULL, 18, 599, 0, 1317.5, -643.565, 109.274, 18.2114, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 0, 68.8219, 0, 0, -1, 0, 0, 0, 100, '99.000015|99.600006|99.441307|99.800003|99.800003', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(16, NULL, 18, 427, 0, 1359.78, -611.399, 109.235, 98.9036, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 0, 82.5863, 0, 0, -1, 0, 0, 0, 100, '99.800003|99.800003|98.130028|99.900002|99.900002', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(17, NULL, 18, 495, 0, 1361.21, -615.795, 109.425, 92.0246, 1000, 0, 0, 0, 0, 0, 0, '0|0|0|0', 0, 92.6012, 1, 1, -1, 0, 0, 0, 100, '99.800003|99.600006|99.630203|99.800003|99.800003', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(19, NULL, 26, 525, 0, 2142.43, 1397.96, 10.5574, 180, 1000, 0, 0, 1, 0, 0, 0, '0|0|0|0', 0, 49.54, 3, 3, -1, 0, 0, 0, 100, '100.000000|100.000000|100.000000|100.000000|100.000000', 'NULL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-1|-1|-1|-1|-1|-1|-1|-1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `vehicle_note`
--

CREATE TABLE `vehicle_note` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL DEFAULT 0,
  `officer_id` int(11) NOT NULL DEFAULT 0,
  `text` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `videocards`
--

CREATE TABLE `videocards` (
  `id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `coolant` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `tax` int(11) NOT NULL DEFAULT 0,
  `bitcoin` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '0.0',
  `house` int(11) NOT NULL DEFAULT 0,
  `biz` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `videocards`
--

INSERT INTO `videocards` (`id`, `status`, `level`, `coolant`, `tax`, `bitcoin`, `house`, `biz`) VALUES
(1, 0, 1, '0.0', 0, '0.0', 149, 102),
(2, 0, 1, '0.0', 0, '0.0', 149, 101),
(3, 0, 1, '0.0', 0, '0.0', 149, 100),
(4, 0, 1, '0.0', 0, '0.0', 149, 101),
(5, 0, 1, '0.0', 0, '0.0', 149, 100),
(6, 0, 1, '0.0', 0, '0.0', 149, 102),
(7, 0, 1, '0.0', 0, '0.0', 149, 101),
(8, 0, 1, '0.0', 0, '0.0', 149, 100),
(9, 0, 1, '0.0', 0, '0.0', 149, 101),
(10, 0, 1, '0.0', 0, '0.0', 149, 102);

-- --------------------------------------------------------

--
-- Структура таблицы `warehouse`
--

CREATE TABLE `warehouse` (
  `idx` int(11) NOT NULL,
  `fraction` int(11) DEFAULT 0,
  `materials` int(11) DEFAULT 0,
  `cartridges` int(11) DEFAULT 0,
  `status` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `warehouse`
--

INSERT INTO `warehouse` (`idx`, `fraction`, `materials`, `cartridges`, `status`) VALUES
(2, 15, 1000, 1000, 1),
(3, 15, 2000, 2000, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `youtube`
--

CREATE TABLE `youtube` (
  `ID` int(11) NOT NULL,
  `Promo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `Activation` int(11) NOT NULL DEFAULT 0,
  `CreateTime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Список промокодов YouTube';

-- --------------------------------------------------------

--
-- Структура таблицы `youtube_active`
--

CREATE TABLE `youtube_active` (
  `ID` int(11) NOT NULL,
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `PromoCode` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `CreateTime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Активации промокодов ютуберов';

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mail` (`mail`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `gift` (`gift`);

--
-- Индексы таблицы `admin_log`
--
ALTER TABLE `admin_log`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `a_ID` (`id`),
  ADD KEY `name` (`name`);

--
-- Индексы таблицы `anticheats`
--
ALTER TABLE `anticheats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cheatname` (`cheatname`),
  ADD KEY `cheatvalue` (`cheatvalue`);

--
-- Индексы таблицы `antidm_info`
--
ALTER TABLE `antidm_info`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `apbs`
--
ALTER TABLE `apbs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `battlepass_reward`
--
ALTER TABLE `battlepass_reward`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `billboard`
--
ALTER TABLE `billboard`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `binder`
--
ALTER TABLE `binder`
  ADD PRIMARY KEY (`i`);

--
-- Индексы таблицы `bitcoin`
--
ALTER TABLE `bitcoin`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Индексы таблицы `biz`
--
ALTER TABLE `biz`
  ADD PRIMARY KEY (`b_mysql_id`),
  ADD KEY `b_mysql_id` (`b_mysql_id`),
  ADD KEY `b_user_id` (`b_user_id`),
  ADD KEY `b_rent` (`b_rent`),
  ADD KEY `b_rent_b_user_id` (`b_rent`,`b_user_id`);

--
-- Индексы таблицы `box_coords`
--
ALTER TABLE `box_coords`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `status` (`status`);

--
-- Индексы таблицы `car_shop`
--
ALTER TABLE `car_shop`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `cctvs`
--
ALTER TABLE `cctvs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `criminalrecords`
--
ALTER TABLE `criminalrecords`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `daily_reward`
--
ALTER TABLE `daily_reward`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `donation`
--
ALTER TABLE `donation`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `drugs`
--
ALTER TABLE `drugs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `family`
--
ALTER TABLE `family`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fam_id` (`id`),
  ADD KEY `fam_name` (`name`);

--
-- Индексы таблицы `family_blacklist`
--
ALTER TABLE `family_blacklist`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `target_id` (`target_id`),
  ADD KEY `date` (`date`),
  ADD KEY `family_id` (`id`) USING BTREE;

--
-- Индексы таблицы `family_log`
--
ALTER TABLE `family_log`
  ADD KEY `id` (`id`),
  ADD KEY `date` (`date`),
  ADD KEY `id_date` (`id`,`date`);

--
-- Индексы таблицы `family_zone`
--
ALTER TABLE `family_zone`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `fractions_data`
--
ALTER TABLE `fractions_data`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Индексы таблицы `fraction_blacklist`
--
ALTER TABLE `fraction_blacklist`
  ADD PRIMARY KEY (`f_bl_id`);

--
-- Индексы таблицы `fraction_store`
--
ALTER TABLE `fraction_store`
  ADD PRIMARY KEY (`f_ID`),
  ADD KEY `f_ID` (`f_ID`);

--
-- Индексы таблицы `gangzone`
--
ALTER TABLE `gangzone`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `garden`
--
ALTER TABLE `garden`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `graffiti`
--
ALTER TABLE `graffiti`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `hotel_rooms`
--
ALTER TABLE `hotel_rooms`
  ADD PRIMARY KEY (`hr_mysql_id`);

--
-- Индексы таблицы `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`h_mysql_id`),
  ADD KEY `h_mysql_id` (`h_mysql_id`),
  ADD KEY `h_r_user_id_0` (`h_r_user_id_0`),
  ADD KEY `h_r_user_id_1` (`h_r_user_id_1`),
  ADD KEY `h_r_user_id_2` (`h_r_user_id_2`),
  ADD KEY `h_r_user_id_3` (`h_r_user_id_3`),
  ADD KEY `h_r_user_id_4` (`h_r_user_id_4`),
  ADD KEY `h_user_id` (`h_user_id`),
  ADD KEY `h_rent` (`h_rent`),
  ADD KEY `h_rent_h_user_id` (`h_rent`,`h_user_id`);

--
-- Индексы таблицы `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`mysql_id`),
  ADD KEY `mysql_id` (`mysql_id`),
  ADD KEY `owner_id` (`owner_id`),
  ADD KEY `slot_id` (`slot_id`);

--
-- Индексы таблицы `ip_logs_list`
--
ALTER TABLE `ip_logs_list`
  ADD PRIMARY KEY (`ip`);

--
-- Индексы таблицы `log_fraction`
--
ALTER TABLE `log_fraction`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `log_name`
--
ALTER TABLE `log_name`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Индексы таблицы `network`
--
ALTER TABLE `network`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `panel`
--
ALTER TABLE `panel`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `parkings`
--
ALTER TABLE `parkings`
  ADD PRIMARY KEY (`p_mysql_id`),
  ADD KEY `p_mysql_id` (`p_mysql_id`);

--
-- Индексы таблицы `player_fine`
--
ALTER TABLE `player_fine`
  ADD PRIMARY KEY (`mysql_id`),
  ADD KEY `mysql_id` (`mysql_id`);

--
-- Индексы таблицы `player_notification`
--
ALTER TABLE `player_notification`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promo`
--
ALTER TABLE `promo`
  ADD KEY `name` (`name`),
  ADD KEY `activate` (`activate`),
  ADD KEY `block` (`block`),
  ADD KEY `activate_block` (`activate`,`block`);

--
-- Индексы таблицы `promocode`
--
ALTER TABLE `promocode`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promo_activations`
--
ALTER TABLE `promo_activations`
  ADD KEY `account_id` (`account_id`),
  ADD KEY `name_promo` (`name_promo`),
  ADD KEY `account_id_name_promo` (`account_id`,`name_promo`);

--
-- Индексы таблицы `radars`
--
ALTER TABLE `radars`
  ADD PRIMARY KEY (`rID`),
  ADD KEY `rID` (`rID`);

--
-- Индексы таблицы `resources_house`
--
ALTER TABLE `resources_house`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `roulette`
--
ALTER TABLE `roulette`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `setbonus`
--
ALTER TABLE `setbonus`
  ADD PRIMARY KEY (`level`);

--
-- Индексы таблицы `table_ban`
--
ALTER TABLE `table_ban`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Name_Player` (`Name_Player`),
  ADD KEY `Name_Admin` (`Name_Admin`),
  ADD KEY `ID` (`id`),
  ADD KEY `IP` (`IP`);

--
-- Индексы таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `topwars`
--
ALTER TABLE `topwars`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `trafficlights`
--
ALTER TABLE `trafficlights`
  ADD PRIMARY KEY (`tl_mysql_id`),
  ADD KEY `tl_mysql_id` (`tl_mysql_id`);

--
-- Индексы таблицы `underground`
--
ALTER TABLE `underground`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `unitpayId` (`unitpayId`(191)),
  ADD KEY `account` (`account`),
  ADD KEY `sum` (`sum`),
  ADD KEY `itemsCount` (`itemsCount`),
  ADD KEY `dateCreate` (`dateCreate`),
  ADD KEY `status` (`status`),
  ADD KEY `dateComplete` (`dateDelivered`) USING BTREE,
  ADD KEY `accountId` (`accountId`),
  ADD KEY `delivered` (`delivered`);

--
-- Индексы таблицы `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`v_mysql_id`),
  ADD KEY `v_owner` (`v_owner`),
  ADD KEY `v_mysql_id` (`v_mysql_id`),
  ADD KEY `v_owner_v_type` (`v_owner`),
  ADD KEY `v_owner_id` (`v_owner_id`),
  ADD KEY `v_owner_id_v_type` (`v_owner_id`);

--
-- Индексы таблицы `vehicle_note`
--
ALTER TABLE `vehicle_note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `officer_id` (`officer_id`);

--
-- Индексы таблицы `videocards`
--
ALTER TABLE `videocards`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `warehouse`
--
ALTER TABLE `warehouse`
  ADD PRIMARY KEY (`idx`);

--
-- Индексы таблицы `youtube`
--
ALTER TABLE `youtube`
  ADD PRIMARY KEY (`ID`);

--
-- Индексы таблицы `youtube_active`
--
ALTER TABLE `youtube_active`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT для таблицы `admin_log`
--
ALTER TABLE `admin_log`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT для таблицы `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `anticheats`
--
ALTER TABLE `anticheats`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT для таблицы `antidm_info`
--
ALTER TABLE `antidm_info`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT для таблицы `apbs`
--
ALTER TABLE `apbs`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `battlepass_reward`
--
ALTER TABLE `battlepass_reward`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `billboard`
--
ALTER TABLE `billboard`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT для таблицы `binder`
--
ALTER TABLE `binder`
  MODIFY `i` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `biz`
--
ALTER TABLE `biz`
  MODIFY `b_mysql_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT для таблицы `box_coords`
--
ALTER TABLE `box_coords`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;

--
-- AUTO_INCREMENT для таблицы `car_shop`
--
ALTER TABLE `car_shop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT для таблицы `cctvs`
--
ALTER TABLE `cctvs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `criminalrecords`
--
ALTER TABLE `criminalrecords`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `daily_reward`
--
ALTER TABLE `daily_reward`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=232;

--
-- AUTO_INCREMENT для таблицы `donation`
--
ALTER TABLE `donation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `drugs`
--
ALTER TABLE `drugs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `family`
--
ALTER TABLE `family`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID семьи', AUTO_INCREMENT=412;

--
-- AUTO_INCREMENT для таблицы `family_zone`
--
ALTER TABLE `family_zone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

--
-- AUTO_INCREMENT для таблицы `fraction_blacklist`
--
ALTER TABLE `fraction_blacklist`
  MODIFY `f_bl_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `fraction_store`
--
ALTER TABLE `fraction_store`
  MODIFY `f_ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT для таблицы `gangzone`
--
ALTER TABLE `gangzone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT для таблицы `garden`
--
ALTER TABLE `garden`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `graffiti`
--
ALTER TABLE `graffiti`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT для таблицы `hotel_rooms`
--
ALTER TABLE `hotel_rooms`
  MODIFY `hr_mysql_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT для таблицы `house`
--
ALTER TABLE `house`
  MODIFY `h_mysql_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=961;

--
-- AUTO_INCREMENT для таблицы `inventory`
--
ALTER TABLE `inventory`
  MODIFY `mysql_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=385;

--
-- AUTO_INCREMENT для таблицы `log_fraction`
--
ALTER TABLE `log_fraction`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT для таблицы `log_name`
--
ALTER TABLE `log_name`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `network`
--
ALTER TABLE `network`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `panel`
--
ALTER TABLE `panel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `parkings`
--
ALTER TABLE `parkings`
  MODIFY `p_mysql_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `player_fine`
--
ALTER TABLE `player_fine`
  MODIFY `mysql_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `player_notification`
--
ALTER TABLE `player_notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `promocode`
--
ALTER TABLE `promocode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `radars`
--
ALTER TABLE `radars`
  MODIFY `rID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `resources_house`
--
ALTER TABLE `resources_house`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `roulette`
--
ALTER TABLE `roulette`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT для таблицы `table_ban`
--
ALTER TABLE `table_ban`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `topwars`
--
ALTER TABLE `topwars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `trafficlights`
--
ALTER TABLE `trafficlights`
  MODIFY `tl_mysql_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `underground`
--
ALTER TABLE `underground`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `unitpay_payments`
--
ALTER TABLE `unitpay_payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `v_mysql_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `vehicle_note`
--
ALTER TABLE `vehicle_note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `videocards`
--
ALTER TABLE `videocards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `warehouse`
--
ALTER TABLE `warehouse`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `youtube`
--
ALTER TABLE `youtube`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `youtube_active`
--
ALTER TABLE `youtube_active`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `family_blacklist`
--
ALTER TABLE `family_blacklist`
  ADD CONSTRAINT `family_id` FOREIGN KEY (`id`) REFERENCES `family` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `family_log`
--
ALTER TABLE `family_log`
  ADD CONSTRAINT `id` FOREIGN KEY (`id`) REFERENCES `family` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
