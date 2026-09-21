-- BENZ RUSSIA: existing database migration
-- Select database gs110713 before running.

-- Show chat by default for legacy accounts.
UPDATE accounts SET setting1 = 1 WHERE setting1 = 0;

-- Starter money is controlled by scriptfiles/server_settings.ini (150 RUB).
-- This migration intentionally does not grant the old test balance.

-- BENZ RUSSIA owner: grant admin level 12; AdminPass is set/changed in-game.
UPDATE accounts SET admin = 12, get_adm_status = 1 WHERE LOWER(name) = 'dev_below' LIMIT 1;
