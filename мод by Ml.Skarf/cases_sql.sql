//я сигма
ALTER TABLE `accounts`
  ADD COLUMN IF NOT EXISTS `case_daily`    INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_bomj`     INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_standart` INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_auto`     INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_special`  INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_up`       INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_dark`     INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_drive`    INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_spring`   INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_blitz`    INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_five`     INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `case_dust`     INT DEFAULT 0;
//тоже сигма
CREATE TABLE IF NOT EXISTS `rewards` (
  `id`       INT(11) NOT NULL AUTO_INCREMENT,
  `uid`      INT(11) NOT NULL COMMENT 'ID аккаунта игрока',
  `award_id` INT(11) NOT NULL COMMENT 'Индекс приза в массиве наград',
  `case_id`  INT(11) NOT NULL COMMENT 'ID кейса (1=Daily,2=Bomj,3=Standart,4=Auto,5=Special,6=Up,7=Dark,8=Drive,9=Spring,10=Blitz,11=Five)',
  PRIMARY KEY (`id`),
  KEY `uid_idx` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
