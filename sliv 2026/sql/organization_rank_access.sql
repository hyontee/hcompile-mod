CREATE TABLE IF NOT EXISTS `organization_rank_access` (
    `organization_id` int NOT NULL,
    `rank` int NOT NULL,
    `car` tinyint(1) NOT NULL DEFAULT 0,
    `cuff` tinyint(1) NOT NULL DEFAULT 0,
    `warn` tinyint(1) NOT NULL DEFAULT 0,
    `unwarn` tinyint(1) NOT NULL DEFAULT 0,
    `promote` tinyint(1) NOT NULL DEFAULT 0,
    `demote` tinyint(1) NOT NULL DEFAULT 0,
    `fire` tinyint(1) NOT NULL DEFAULT 0,
    `warehouse` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`organization_id`, `rank`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- Пример стартовых прав для 9 ранга. При необходимости поменяйте 0/1.
-- INSERT INTO `organization_rank_access`
-- (`organization_id`,`rank`,`car`,`cuff`,`warn`,`unwarn`,`promote`,`demote`,`fire`,`warehouse`)
-- VALUES
-- (1,9,1,1,1,1,1,1,1,1);
