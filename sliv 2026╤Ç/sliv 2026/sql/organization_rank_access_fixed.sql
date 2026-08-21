CREATE TABLE IF NOT EXISTS `organization_rank_access` (
    `organization_id` INT NOT NULL,
    `rank` TINYINT UNSIGNED NOT NULL,
    `car` TINYINT(1) NOT NULL DEFAULT 0,
    `cuff` TINYINT(1) NOT NULL DEFAULT 0,
    `warn` TINYINT(1) NOT NULL DEFAULT 0,
    `unwarn` TINYINT(1) NOT NULL DEFAULT 0,
    `promote` TINYINT(1) NOT NULL DEFAULT 0,
    `demote` TINYINT(1) NOT NULL DEFAULT 0,
    `fire` TINYINT(1) NOT NULL DEFAULT 0,
    `warehouse` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`organization_id`, `rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
