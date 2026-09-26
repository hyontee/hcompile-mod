```sql
CREATE TABLE IF NOT EXISTS mining_farms (
  id int(11) NOT NULL AUTO_INCREMENT,
  player_name varchar(24) NOT NULL,
  house_id int(11) DEFAULT -1,
  gpu_id int(11) DEFAULT -1,
  mining_active tinyint(1) DEFAULT 0,
  last_mining int(11) DEFAULT 0,
  total_earned int(11) DEFAULT 0,
  electricity_paid int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY player_name (`player_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;