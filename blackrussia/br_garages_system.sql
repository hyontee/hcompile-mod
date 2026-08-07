CREATE TABLE IF NOT EXISTS `br_garages` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL DEFAULT 0,
  `owner_name` varchar(24) NOT NULL DEFAULT '',
  `rent_time` int(11) NOT NULL DEFAULT 0,
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `live` tinyint(1) NOT NULL DEFAULT 0,
  `safe` tinyint(1) NOT NULL DEFAULT 0,
  `elite` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
