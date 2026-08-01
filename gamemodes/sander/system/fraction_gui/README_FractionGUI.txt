Fraction GUI integration
========================

Installed into this mod:
- Server include: gamemodes/sander/system/fraction_gui/FractionGUI.inc
- SQL schema: gamemodes/sander/system/fraction_gui/fraction_gui.sql
- Android client smali reference copied from fractions.zip: client_smali/fractions/

Entry points:
- /fmenu, /frac, /fraction, /orgmenu open GUI 46.
- /fmd opens a dialog fallback if the Android GUI is not available.

Patched files:
- gamemodes/sander.pwn: include, OnGameModeInit, OnPlayerConnect, OnPlayerDisconnect, OnDialogResponse.
- gamemodes/sander/ipacket.inc: GUI packet 252 now routes guiid 46 to FractionGUI_OnPacket.

Runtime features:
- tokens and task progress stored in MySQL table fraction_gui_data;
- shop purchases logged in fraction_gui_shop_log;
- documents/test/tasks/shop/buy tokens/control list/rank/reprimand/dismiss packets use the JSON keys expected by the client smali.

Note: this archive contains the server integration and copied smali reference. It does not rebuild an Android APK.
