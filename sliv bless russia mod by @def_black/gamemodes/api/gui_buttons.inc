new Text:gui_buttons_TD[7];

public OnGameModeInit()
{
    gui_buttons_TD[0] = TextDrawCreate(599.6667, 9.6489, "txd:transparent"); // (NEW) открыть меню машины
    TextDrawTextSize(gui_buttons_TD[0], 37.0000, 46.0000);
    TextDrawAlignment(gui_buttons_TD[0], 1);
    TextDrawColor(gui_buttons_TD[0], -1);
    TextDrawBackgroundColor(gui_buttons_TD[0], 255);
    TextDrawFont(gui_buttons_TD[0], 4);
    TextDrawSetProportional(gui_buttons_TD[0], 0);
    TextDrawSetShadow(gui_buttons_TD[0], 0);
    TextDrawSetSelectable(gui_buttons_TD[0], true);

    gui_buttons_TD[1] = TextDrawCreate(565.8889, 8.6533, "txd:transparent"); // (NEW) открыть меню доната
    TextDrawTextSize(gui_buttons_TD[1], 34.0000, 48.0000);
    TextDrawAlignment(gui_buttons_TD[1], 1);
    TextDrawColor(gui_buttons_TD[1], -1);
    TextDrawBackgroundColor(gui_buttons_TD[1], 255);
    TextDrawFont(gui_buttons_TD[1], 4);
    TextDrawSetProportional(gui_buttons_TD[1], 0);
    TextDrawSetShadow(gui_buttons_TD[1], 0);
    TextDrawSetSelectable(gui_buttons_TD[1], true);

    gui_buttons_TD[2] = TextDrawCreate(10.3329, 154.5024, "txd:transparent"); // (OLD) открыть меню машины
    TextDrawTextSize(gui_buttons_TD[2], 62.0000, 39.0000);
    TextDrawAlignment(gui_buttons_TD[2], 1);
    TextDrawColor(gui_buttons_TD[2], -1);
    TextDrawBackgroundColor(gui_buttons_TD[2], 255);
    TextDrawFont(gui_buttons_TD[2], 4);
    TextDrawSetProportional(gui_buttons_TD[2], 0);
    TextDrawSetShadow(gui_buttons_TD[2], 0);
    TextDrawSetSelectable(gui_buttons_TD[2], true);

    gui_buttons_TD[3] = TextDrawCreate(73.0000, 155.9955, "txd:transparent"); // (OLD) открыть меню доната
    TextDrawTextSize(gui_buttons_TD[3], 26.0000, 37.0000);
    TextDrawAlignment(gui_buttons_TD[3], 1);
    TextDrawColor(gui_buttons_TD[3], -1);
    TextDrawBackgroundColor(gui_buttons_TD[3], 255);
    TextDrawFont(gui_buttons_TD[3], 4);
    TextDrawSetProportional(gui_buttons_TD[3], 0);
    TextDrawSetShadow(gui_buttons_TD[3], 0);
    TextDrawSetSelectable(gui_buttons_TD[3], true);

    gui_buttons_TD[4] = TextDrawCreate(274.7779, 321.2578, "txd:transparent"); // включить аварийку
    TextDrawTextSize(gui_buttons_TD[4], 90.0000, 90.0000);
    TextDrawAlignment(gui_buttons_TD[4], 1);
    TextDrawColor(gui_buttons_TD[4], -1);
    TextDrawBackgroundColor(gui_buttons_TD[4], 255);
    TextDrawFont(gui_buttons_TD[4], 4);
    TextDrawSetProportional(gui_buttons_TD[4], 0);
    TextDrawSetShadow(gui_buttons_TD[4], 0);
    TextDrawSetSelectable(gui_buttons_TD[4], true);

    gui_buttons_TD[5] = TextDrawCreate(204.9998, 343.6578, "txd:transparent"); // левый поворотник
    TextDrawTextSize(gui_buttons_TD[5], 69.0000, 45.0000);
    TextDrawAlignment(gui_buttons_TD[5], 1);
    TextDrawColor(gui_buttons_TD[5], -1);
    TextDrawBackgroundColor(gui_buttons_TD[5], 255);
    TextDrawFont(gui_buttons_TD[5], 4);
    TextDrawSetProportional(gui_buttons_TD[5], 0);
    TextDrawSetShadow(gui_buttons_TD[5], 0);
    TextDrawSetSelectable(gui_buttons_TD[5], true);

    gui_buttons_TD[6] = TextDrawCreate(361.8889, 344.1556, "txd:transparent"); // правый поворотник
    TextDrawTextSize(gui_buttons_TD[6], 69.0000, 45.0000);
    TextDrawAlignment(gui_buttons_TD[6], 1);
    TextDrawColor(gui_buttons_TD[6], -1);
    TextDrawBackgroundColor(gui_buttons_TD[6], 255);
    TextDrawFont(gui_buttons_TD[6], 4);
    TextDrawSetProportional(gui_buttons_TD[6], 0);
    TextDrawSetShadow(gui_buttons_TD[6], 0);
    TextDrawSetSelectable(gui_buttons_TD[6], true);

    #if defined gb_OnGameModeInit
        return gb_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit gb_OnGameModeInit
#if defined gb_OnGameModeInit
    forward gb_OnGameModeInit();
#endif