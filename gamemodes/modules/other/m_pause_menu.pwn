stock show_packet_menumap ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 )
	{
		show_dialog ( playerid, d_mm_request_1, DIALOG_STYLE_LIST, "{"#cBHD"}Помощь", "\
			{"#cBL"}Выберите аспект помощи:\n\
			{"#cBL"}1. {"#cWH"}Вам нужен спавн?\n\
			{"#cBL"}2. {"#cWH"}Вам нужно выдать скутер?\n\
			{"#cBL"}3. {"#cWH"}Вы перевернулись?\n\
			{"#cBL"}4. {"#cWH"}У Вас застряла машина?\n\
			{"#cBL"}5. {"#cWH"}У Вас сделка?\n \n\
			{"#cLY"}Задать вопрос администрации", "Выбрать", "Закрыть" ) ;

		toggle_controlable ( playerid, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	return 1 ;
}