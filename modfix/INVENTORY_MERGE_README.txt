INVENTORY MERGE / MARKETPLACE / PVZ

This build uses the new Inventory11 system already present in gamemodes/new.pwn.

Changes:
- Removed the unused legacy include: include/system/inventory.inc
- Kept the existing Inventory11 GUI and SQL table `inventory`
- Kept the existing inventory trade system (Inv11Trade_*)
- Kept the existing vehicle trunk system (TrunkTest_*) and GUI 34
- Reworked marketplace inventory access to use the new `inventory` table
- Reworked equipped accessory marketplace sources to use `accessories_players`
- Marketplace inventory slots are now 1..INVENTORY11_MAX_SLOTS (64)
- Marketplace can list regular inventory items as well as skins, SIM cards,
  accessories and plate items.
- Skin/accessory/SIM metadata is preserved when a marketplace item is delivered.
- Marketplace accessory lots store the actual accessory model in item_count.
- PVZ pickup system is included and initialized by the existing new.pwn
  OnGameModeInit flow.
- No death-system files were changed.

Database:
- Existing `inventory` and `inventory_plates` tables are used.
- Marketplace creates its own tables at Marketplace_OnGameModeInit.
- The old `player_inventory` SQL table is NOT dropped to avoid destructive
  migration of unrelated legacy data; the gamemode no longer uses it for
  marketplace/inventory operations.

Important:
- Compile gamemodes/new.pwn with the server's normal Pawn 3.2 compiler.
