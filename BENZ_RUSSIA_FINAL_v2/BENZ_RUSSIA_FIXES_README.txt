BENZ RUSSIA - fixes for the current test build

Fixed in this pass:
1. Old project branding in gamemode strings -> BENZ RUSSIA.
2. Welcome messages replaced with BENZ RUSSIA branding and the project Telegram.
3. Starter money now comes from server_settings.ini and is 150 RUB; the 700,000,000 test grant was removed.
4. dev_below receives admin level 12 and owner status without test money.
5. Scooter rental in the active rental dialog system is 50 RUB.
6. Legacy setting1=0 is migrated to Standard chat so chat is visible; SQL schema default is also 1.
7. MySQL connection now reads host, username, database, password and port correctly; database is gs110713 and port 3306 in the supplied config.
8. Russian text is preserved in CP1251.

IMPORTANT:
- The old compiled AMX was removed from this package. Compile gamemodes/black-russia.pwn with the included pawno/pawncc.exe before starting the server.
- The word ROYAL / Build 16.21.0 visible in the mobile screenshot belongs to the Android client/HUD, not the Pawn gamemode. Changing it requires the client/HUD assets, not a .pwn change.
- BENZ_RUSSIA_FIX_MIGRATION.sql is for an existing gs110713 database.

Admin login:
- /alogin opens the administrator password dialog.
- Existing admins must enter their saved 4-digit AdminPass.
- New admins without a password are prompted to create a 4-digit password.
- 3 incorrect attempts kick the player.
- The previous automatic owner/admin login bypass was removed.
- dev_below keeps admin level 12 but must authenticate with the admin password.
