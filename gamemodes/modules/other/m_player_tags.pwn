//#include <custom/playertags>

new player_tag_text [ MAX_PLAYERS ] [ 32 ] ;
new player_tag_color [ MAX_PLAYERS ] [ 8 ] ;
new player_tag_color_box [ MAX_PLAYERS ] [ 8 ] ;
new player_tag_style [ MAX_PLAYERS ] ;

CMD:tags ( playerid )
{
	if ( player_tag_style [ playerid ] < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет персонального тэга!" ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 144, "{"#cWH"}Ваш персональный тэг {%s}%s{"#cWH"}.\n{"#cWH"}Цвет Вашей обводки подчёркнут на слове '{%s}обводка{"#cWH"}'.",
	player_tag_color [ playerid ], player_tag_text [ playerid ], player_tag_color_box [ playerid ] ) ;
	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тэг", global_string, "Передать", "Закрыть" ) ;
	return 1 ;
}

/*stock tags_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_tags:
		{
			if ( ! response ) return 1 ;
			
			
			return 1 ;
		}
	}
	return 0 ;
}*/

stock show_player_tags ( targetid )
{
	new colorText, colorBox, _str [ 32 ], bool: _accept = false, _style = 2 ;
	switch ( p_info [ targetid ] [ vip ] )
	{
		/*case 1:
		{
			colorText = 0xcd7f32FF ;
			colorBox = 0xcd7f32FF ;
			
			format ( _str, sizeof _str, "VIP" ) ;
			_accept = true ;
		}
		case 2:
		{
			colorText = 0xc8c8c8FF ;
			colorBox = 0xc8c8c8FF ;
			
			format ( _str, sizeof _str, "VIP" ) ;
			_accept = true ;
		}*/
		case 3:
		{
			colorText = 0xc3900aFF ;
			colorBox = 0xc3900aFF ;
			
			format ( _str, sizeof _str, "VIP" ) ;
			_accept = true ;
		}
	}
	
	if ( p_info [ targetid ] [ leader ] > 0 && p_info [ targetid ] [ rank ] > 0 )
	{
		colorText = f_info [ p_info [ targetid ] [ member ] - 1 ] [ f_radar_color ] ;
		colorBox = colorText ;
			
		format ( _str, sizeof _str, "Лидер" ) ;
		_accept = true ;
	}
	
	if ( admin_info [ targetid ] [ admin ] > 0 )
	{
		colorText = 0xAA3333FF ;
		colorBox = 0xAA3333FF ;
			
		format ( _str, sizeof _str, "Admin" ) ;
		_accept = true ;
	}
	
	if ( player_tag_style [ targetid ] > 0 )
	{
		format ( _str, sizeof _str, "0x%sFF", player_tag_color [ targetid ] ) ;
		colorText = StrToHex ( _str ) ;
		format ( _str, sizeof _str, "0x%sFF", player_tag_color_box [ targetid ] ) ;
		colorBox = StrToHex ( _str ) ;
			
		format ( _str, sizeof _str, "%s", player_tag_text [ targetid ] ) ;
		_style = player_tag_style [ targetid ] ;
		_accept = true ;
	}
	
	if ( _accept == true )
	{
		SetPlayerTag ( -1, targetid, true, _str, _style, colorText, colorBox ) ;
	}
	return 1 ;
}
