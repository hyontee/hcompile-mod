#define DIALOG_PRIZIK 5001
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_WHITE 0xFFFFFFFF

CMD:test10(playerid)
{
    if(GetPVarInt(playerid, "PrizeTaken") == 1)
        return SendClientMessage(playerid, COLOR_RED, "Вы уже получали этот приз.");
    
    SetPVarInt(playerid, "PrizeTaken", 1);
    
    GivePlayerMoneyEx(playerid, 1488);
    GivePlayerDonateRub(playerid, 67);
    
    ShowPlayerDialog(playerid, DIALOG_PRIZIK, DIALOG_STYLE_MSGBOX, 
        "TEST NESQWIKA | TEST",
        "Вы успешно получили:\n\n1488$\n67 донат-рублей\n\nTEST NESQWIKA",
        "OK", "Закрыть"
    );
    
    return 1;
}
