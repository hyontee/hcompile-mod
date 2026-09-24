static const page_name [ MAX_PLAYERS ] [ MAX_PLAYER_NAME ] ;

enum _logs_type
{
	logg_name [ 32 ],
	logg_type,
	logg_level
} ;

#define MAX_ADMIN_TOOLS 20
new loggs_type [ MAX_ADMIN_TOOLS ] [ _logs_type ] =
{
	{ "Кикнутые игроки", TYPE_LOG_KICK, 5 },
	{ "Заварненные игроки", TYPE_LOG_WARN, 5 },
	{ "Забаненные игроки", TYPE_LOG_BAN, 5 },
	{ "Разбаненные игроки", TYPE_LOG_UNBAN, 5 },
	{ "Разварненные игроки", TYPE_LOG_UNWARN, 5 },
	{ "Лидерство", TYPE_LOG_MKL, 5 },
	{ "Посаженные в тюрьму", TYPE_LOG_JAIL, 5 },
	{ "Замученные игроки", TYPE_LOG_MUTE, 5 },
	{ "Размученные игроки", TYPE_LOG_UNMUTE, 5 },
	{ "Выпущенные из тюрьмы", TYPE_LOG_UNJAIL, 5 },
	{ "Принятые игроки в организации", TYPE_LOG_INVITE, 5 },
	{ "Уволенные игроки", TYPE_LOG_UVAL, 5 },
	{ "Лог повышений", TYPE_LOG_AGIVERANK, 5 },
	{ "Денежные операции", -1, 6 },
	{ "Денежные операции организаций", TYPE_LOG_OBWYAK, 5 },
	{ "Операции с /lmenu", TYPE_LOG_LMENU, 5 },
	{ "Репорт по нику", -2, 5 },
	{ "Репорт", -3, 5 },
	{ "Действия по нику", -4, 5 },
	{ "Действия ГА", TYPE_LOG_ADMIN, 8 }
} ;

#include <custom/admin_tools>

stock show_admin_tools ( playerid )
{
	adminLogsShow ( playerid, "", "", "", "", "" ) ;
	adminMenuItem ( playerid ) ;
	return 1 ;
}

stock show_packet_admin ( playerid, _param1, _str [ ], _param3 )
{
	if ( _param1 == 0 )
	{
		adminLogsHide ( playerid ) ;
		toggle_controlable ( playerid, true ) ;
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	else if ( _param1 == 1 )
	{
		page_rows [ playerid ] += 100 ;
		
		new _id = loggs_type [ get_player_use_listitem ( playerid ) ] [ logg_type ] ;
		if ( _id == -1 )
		{
			new sql_string [ 139 + MAX_PLAYER_NAME ] ;
			mysql_format ( sql_connection, sql_string, sizeof sql_string, "SELECT `money`, `name`, `from_name`, `date`, `reason` FROM `money_logs` WHERE `name` = '%s' ORDER BY `money_logs`.`log_id` DESC LIMIT %d", page_name [ playerid ], page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_moneylog", "i", playerid ) ;
		}
		else if ( _id == -2 )
		{
			new sql_string [ 106 + ( MAX_PLAYER_NAME * 2 ) ] ;
			mysql_format ( sql_connection, sql_string, sizeof sql_string, "SELECT * FROM `logs_report` WHERE `u_name` = '%s' OR `a_name` = '%s' ORDER BY `logs_report`.`r_id` DESC LIMIT %d", page_name [ playerid ], page_name [ playerid ], page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_message", "i", playerid ) ;
		}
		else if ( _id == -3 )
		{
			new sql_string [ 74 + 9 ] ;
			mysql_format ( sql_connection, sql_string, sizeof sql_string, "SELECT * FROM `logs_report` ORDER BY `logs_report`.`r_id` DESC LIMIT %d", page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_messages", "i", playerid ) ;
		}
		else if ( _id == -4 )
		{
			new sql_string [ 112 + MAX_PLAYER_NAME + 9 ] ;
			format ( sql_string, sizeof sql_string, "SELECT `name`, `text_date`, `Text` FROM `logs_all` WHERE `name` = '%s' ORDER BY `logs_all`.`id` DESC LIMIT %d", page_name [ playerid ], page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_logs", "i", playerid ) ;
		}
		else
		{
			new sql_string [ 108 + ( 9 * 2 ) ] ;
			format ( sql_string, sizeof sql_string, "SELECT `name`, `text_date`, `Text` FROM `logs_all` WHERE `type` = '%d' ORDER BY `logs_all`.`id` DESC LIMIT %d", _id, page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_logs", "i", playerid ) ;
		}
	}
	else if ( _param1 == 2 )
	{
		if ( admin_info [ playerid ] [ admin ] < loggs_type [ _param3 ] [ logg_level ] ) return 1 ;
		
		page_rows [ playerid ] = 100 ;
		new _id = loggs_type [ _param3 ] [ logg_type ] ;
		if ( _id == -1 )
		{
			adminLogsShow ( playerid, "Дата", "Действие", " ", "Ник игрока", "Ник получателя" ) ;
			set_player_use_listitem ( playerid, _param3 ) ;
		}
		else if ( _id == -2 )
		{
			adminLogsShow ( playerid, "Дата", "Вопрос", "Ответ", "Ник игрока", "Ник адм." ) ;
			set_player_use_listitem ( playerid, _param3 ) ;
		}
		else if ( _id == -3 )
		{
			adminLogsShow ( playerid, "Дата", "Вопрос", "Ответ", "Ник игрока", "Ник адм." ) ;
			set_player_use_listitem ( playerid, _param3 ) ;
			
			new sql_string [ 74 + 9 ] ;
			mysql_format ( sql_connection, sql_string, sizeof sql_string, "SELECT * FROM `logs_report` ORDER BY `logs_report`.`r_id` DESC LIMIT %d", page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_messages", "i", playerid ) ;
		}
		else if ( _id == -4 )
		{
			adminLogsShow ( playerid, "Дата", "Действие", " ", "Ник игрока", " " ) ;
			set_player_use_listitem ( playerid, _param3 ) ;
		}
		else
		{
			adminLogsShow ( playerid, "Дата", "Действие", " ", "Ник игрока", " " ) ;
			set_player_use_listitem ( playerid, _param3 ) ;
		
			new sql_string [ 108 + ( 9 * 2 ) ] ;
			format ( sql_string, sizeof sql_string, "SELECT `name`, `text_date`, `Text` FROM `logs_all` WHERE `type` = '%d' ORDER BY `logs_all`.`id` DESC LIMIT %d", _id, page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_logs", "i", playerid ) ;
		}
	}
	else if ( _param1 == 3 )
	{
		new _id = loggs_type [ get_player_use_listitem ( playerid ) ] [ logg_type ] ;
		if ( _id == -1 )
		{
			new sql_string [ 139 + MAX_PLAYER_NAME ] ;
			mysql_format ( sql_connection, sql_string, sizeof sql_string, "SELECT `money`, `name`, `from_name`, `date`, `reason` FROM `money_logs` WHERE `name` = '%s' ORDER BY `money_logs`.`log_id` DESC LIMIT %d", _str, page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_moneylog", "i", playerid ) ;
			
			format ( page_name [ playerid ], MAX_PLAYER_NAME, "%s", _str ) ;
		}
		else if ( _id == -2 )
		{
			new sql_string [ 106 + ( MAX_PLAYER_NAME * 2 ) ] ;
			mysql_format ( sql_connection, sql_string, sizeof sql_string, "SELECT * FROM `logs_report` WHERE `u_name` = '%s' OR `a_name` = '%s' ORDER BY `logs_report`.`r_id` DESC LIMIT %d", _str, _str, page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_message", "i", playerid ) ;
			
			format ( page_name [ playerid ], MAX_PLAYER_NAME, "%s", _str ) ;
		}
		else if ( _id == -4 )
		{
			new sql_string [ 112 + MAX_PLAYER_NAME + 9 ] ;
			format ( sql_string, sizeof sql_string, "SELECT `name`, `text_date`, `Text` FROM `logs_all` WHERE `name` = '%s' ORDER BY `logs_all`.`id` DESC LIMIT %d", _str, page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, sql_string, "get_device_logs", "i", playerid ) ;
			
			format ( page_name [ playerid ], MAX_PLAYER_NAME, "%s", _str ) ;
		}
	}
	return 1 ;
}

callback: get_device_messages ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
		
		BS_WriteValue(bitstream, PR_INT8, 3);
		if ( rows - page_rows [ playerid ] < 1 ) BS_WriteValue(bitstream, PR_UINT8, 100 ) ;
		else BS_WriteValue(bitstream, PR_UINT8, rows - page_rows [ playerid ] ) ;
		
		new _t_name [ 32 ], _t_aname [ 32 ], _t_date [ 48 ], _t_text [ 144 ], _t_atext [ 144 ] ;
		for ( new j = page_rows [ playerid ] - 100 ; j < rows ; j ++ )
		{
			cache_get_field_content ( j, "u_name", _t_name, sql_connection, 32 ) ;
			cache_get_field_content ( j, "a_name", _t_aname, sql_connection, 32 ) ;
			cache_get_field_content ( j, "text_date", _t_date, sql_connection, 48 ) ;
			cache_get_field_content ( j, "Text", _t_text, sql_connection, 144 ) ;
			cache_get_field_content ( j, "A_Text", _t_atext, sql_connection, 144 ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_date ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_date ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_text ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_text ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_atext ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_atext ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_name ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_name ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_aname ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_aname ) ;
		}
		
		PR_SendPacket(bitstream, playerid);

		BS_Delete(bitstream);
	}

	return 1 ;
}

callback: get_device_message ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
		
		BS_WriteValue(bitstream, PR_INT8, 3);
		if ( rows - page_rows [ playerid ] < 1 ) BS_WriteValue(bitstream, PR_UINT8, 100 ) ;
		else BS_WriteValue(bitstream, PR_UINT8, rows - page_rows [ playerid ] ) ;
		
		new _t_name [ 32 ], _t_aname [ 32 ], _t_date [ 48 ], _t_text [ 144 ], _t_atext [ 144 ] ;
		for ( new j = page_rows [ playerid ] - 100 ; j < rows ; j ++ )
		{
			cache_get_field_content ( j, "u_name", _t_name, sql_connection, 32 ) ;
			cache_get_field_content ( j, "a_name", _t_aname, sql_connection, 32 ) ;
			cache_get_field_content ( j, "text_date", _t_date, sql_connection, 48 ) ;
			cache_get_field_content ( j, "Text", _t_text, sql_connection, 144 ) ;
			cache_get_field_content ( j, "A_Text", _t_atext, sql_connection, 144 ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_date ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_date ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_text ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_text ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_atext ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_atext ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_name ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_name ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_aname ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_aname ) ;
		}
		
		PR_SendPacket(bitstream, playerid);

		BS_Delete(bitstream);
	}

	return 1 ;
}

callback: get_device_moneylog ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;

	if ( rows )
	{
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
		
		BS_WriteValue(bitstream, PR_INT8, 3);
		if ( rows - page_rows [ playerid ] < 1 ) BS_WriteValue(bitstream, PR_UINT8, 100 ) ;
		else BS_WriteValue(bitstream, PR_UINT8, rows - page_rows [ playerid ] ) ;
		
		new line_string [ 32 ], log_money, log_name [ 24 ], log_from [ 24 ], log_date [ 24 ], log_reason [ 128 ] ;
		for ( new j = page_rows [ playerid ] - 100 ; j < rows ; j ++ )
		{
			log_money = cache_get_field_content_int ( j, "money", sql_connection ) ;

			cache_get_field_content ( j, "name", log_name, sql_connection, 24 ) ;
			cache_get_field_content ( j, "from_name", log_from, sql_connection, 24 ) ;
			cache_get_field_content ( j, "date", log_date, sql_connection, 24 ) ;
			
			cache_get_field_content ( j, "reason", log_reason, sql_connection, 128 ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( log_date ) ) ;
			BS_WriteValue(bitstream, PR_STRING, log_date ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( log_reason ) ) ;
			BS_WriteValue(bitstream, PR_STRING, log_reason ) ;
			
			format ( line_string, sizeof line_string, "%d", log_money ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( log_name ) ) ;
			BS_WriteValue(bitstream, PR_STRING, log_name ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( log_from ) ) ;
			BS_WriteValue(bitstream, PR_STRING, log_from ) ;
		}
		
		PR_SendPacket(bitstream, playerid);

		BS_Delete(bitstream);
	}
	return 1 ;
}

callback: get_device_logs ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_TOOLS);
		
		BS_WriteValue(bitstream, PR_INT8, 3);
		if ( rows - page_rows [ playerid ] < 1 ) BS_WriteValue(bitstream, PR_UINT8, 100 ) ;
		else BS_WriteValue(bitstream, PR_UINT8, rows - page_rows [ playerid ] ) ;
		
		new _t_date [ 48 ], _t_name [ 32 ], _t_text [ 128 ] ;
		for ( new i = page_rows [ playerid ] - 100 ; i < rows ; i ++ )
		{
			cache_get_field_content ( i, "name", _t_name, sql_connection, 32 ) ;
			cache_get_field_content ( i, "text_date", _t_date, sql_connection, 48 ) ;
			cache_get_field_content ( i, "Text", _t_text, sql_connection, 128 ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_date ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_date ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_text ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_text ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( " " ) ) ;
			BS_WriteValue(bitstream, PR_STRING, " " ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( _t_name ) ) ;
			BS_WriteValue(bitstream, PR_STRING, _t_name ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( " " ) ) ;
			BS_WriteValue(bitstream, PR_STRING, " " ) ;
		}
		
		PR_SendPacket(bitstream, playerid);

		BS_Delete(bitstream);
	}
	return 1 ;
}
