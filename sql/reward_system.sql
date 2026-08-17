-- Таблица для /reward
CREATE TABLE IF NOT EXISTS `rewards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `award_id` int(11) NOT NULL,
  `case_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `case_id` (`case_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
