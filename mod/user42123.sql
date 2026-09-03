CREATE TABLE IF NOT EXISTS `admin_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL DEFAULT 0,
  `admin_name` varchar(24) NOT NULL DEFAULT '',
  `action` varchar(512) NOT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_admin_logs_admin_id` (`admin_id`),
  KEY `idx_admin_logs_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL,
  `password` varchar(64) NOT NULL,
  `skin` int(11) NOT NULL DEFAULT 78,
  `gender` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 5000,
  `admin` int(11) NOT NULL DEFAULT 0,
  `admin_pass` int(11) NOT NULL DEFAULT 0,
  `admin_warn` int(11) NOT NULL DEFAULT 0,
  `mute_expire` int(11) NOT NULL DEFAULT 0,
  `jail_expire` int(11) NOT NULL DEFAULT 0,
  `banned` tinyint(1) NOT NULL DEFAULT 0,
  `ban_reason` varchar(128) NOT NULL DEFAULT '',
  `ban_expire` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `password`, `skin`, `gender`, `money`, `admin`, `admin_pass`, `admin_warn`, `mute_expire`, `jail_expire`, `banned`, `ban_reason`, `ban_expire`) VALUES
(1, 'Dmitry_Riven', '14888841', 135, 1, 158000, 14, 0, 0, 0, 0, 0, '', 0),
(2, 'West_Dev', '123123', 135, 1, 1008000, 0, 0, 0, 0, 0, 0, '', 0);