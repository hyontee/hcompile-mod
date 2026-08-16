# TOP_BR_UNIFIED.sql

One SQL import assembled from the supplied donor dumps.

- Base schema/data: `gs330563.sql`
- 21 additional table definitions merged from the other supplied SQL dumps.
- Total CREATE TABLE definitions: 98.
- Duplicate table definitions were not blindly appended.

Import this file into a fresh MariaDB/MySQL database, then set the same database name/credentials in `scriptfiles/sile_mysql_settings.ini`.
