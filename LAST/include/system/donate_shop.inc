#if defined _BR_DONATE_SHOP_INC_
    #endinput
#endif
#define _BR_DONATE_SHOP_INC_

// ƒонат-магазин (GUI 22) Ч протокол клиента (DonateActionWithJSON.java):
//   t=0 покупка, t=1 кейсы (openHeaderBoxes), t=2 подарок (openingSurprise),
//   t=3 ¬џ’ќƒ (closeDialog), t=4 сумма, t=5 токены, t=6 закрытие BC-диалога
// lc=4 Ч вкладка пополнени€ BC (GUIDonate.getDataFromJson)

stock Menu_OpenDonateTab(playerid, lc_tab)
{
    SyncPlayerBlackCoin(playerid);

    new Node:donate_json = JSON_Object();
    JSON_SetInt(donate_json, "o", 1);
    JSON_SetInt(donate_json, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(donate_json, "d", GetPlayerBlackCoin(playerid));
    JSON_SetInt(donate_json, "ds", 1);
    JSON_SetString(donate_json, "em", "");
    JSON_SetInt(donate_json, "k", 0);
    JSON_SetInt(donate_json, "lc", lc_tab);
    JSON_SetInt(donate_json, "sv", 1);
    JSON_SetInt(donate_json, "p", Player[playerid][pGiftDelay]);
    JSON_SetString(donate_json, "nm", GetPlayerNameEx(playerid));

    new Node:i_array = JSON_Array();
    JSON_SetArray(donate_json, "i", i_array);

    new Node:s_array = JSON_Array(
        JSON_Int(94), JSON_Int(65362), JSON_Int(40),
        JSON_Int(448), JSON_Int(65362), JSON_Int(29),
        JSON_Int(544), JSON_Int(65362), JSON_Int(35)
    );
    JSON_SetArray(donate_json, "s", s_array);
    OnPacketIncoming(playerid, 22, donate_json);
    JSON_Cleanup(donate_json);
    return 1;
}

stock Menu_OpenDonate(playerid)
{
    return Menu_OpenDonateTab(playerid, 0);
}
