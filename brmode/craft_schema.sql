CREATE TABLE IF NOT EXISTS craft_jobs (
  account_id INT NOT NULL PRIMARY KEY,
  recipe_index SMALLINT NOT NULL,
  finish_time INT NOT NULL,
  success TINYINT NOT NULL,
  created_at INT NOT NULL
);

CREATE TABLE IF NOT EXISTS craft_profiles (
  account_id INT NOT NULL PRIMARY KEY,
  level TINYINT NOT NULL DEFAULT 1,
  exp INT NOT NULL DEFAULT 0
);
