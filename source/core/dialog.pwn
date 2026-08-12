/*
=== White_116 ================================
			Easy Dialogs Include
				27.02.2013
================================= v1.1 =======
	Is based on Easy Dialogs by Emmet_
	http://forum.sa-mp.com/showthread.php?t=377140
==============================================

	* [22.10.2020] Edited by https://vk.com/dan_developer;

	* Use sample:
	ShowDialog(playerid, DialogID(DIALOG_ID), DIALOG_STYLE_MSGBOX, ""#CL_MAIN"Обмен валюты", "Content", "Close")

	Dialog:DIALOG_ID(playerid)
	{
		// ...
		return 1;
	}
*/

// #define DIALOG_MODULE_DEBUG             // Режим отладки

#define Dialogt:%0(%1) forward d_%0(%1, dialogid, response, listitem, const inputtext[]); public d_%0(%1, dialogid, response, listitem, const inputtext[])
#define DialogID(%0) #d_%0, %0
#define DialogUse(%0,%1,%2,%3)	d_%0(%1,%0,%2,%3,"")

#define 						MAX_PLAYER_LISTITEMS									25
#define							INVALID_DIALOG_ROWS										-1

#define							MAX_DIALOG_ROWS											20 			// Максимально кол-во строк в диалоге
#define 						PAGE_VALUE_NEXT											-1			
#define 						PAGE_VALUE_BACK											-2

new g_player_listitem[MAX_PLAYERS][MAX_PLAYER_LISTITEMS];
new g_player_action_string[MAX_PLAYERS][MAX_PLAYER_LISTITEMS][MAX_PLAYER_NAME];
new g_player_page[MAX_PLAYERS];
new g_player_rows[MAX_PLAYERS];

#define SetPlayerListitemName(%0,%1,%2)		format(g_player_action_string[%0][%1], MAX_PLAYER_NAME, "%s", %2)
#define GetPlayerListitemName(%0,%1)		g_player_action_string[%0][%1]

#define SetPlayerListitem(%0,%1,%2)			g_player_listitem[%0][%1] = %2
#define GetPlayerListitem(%0,%1)			g_player_listitem[%0][%1]

#define	SetPlayerPage(%0,%1)				g_player_page[%0] = %1
#define	GetPlayerPage(%0)					g_player_page[%0]

#define	SetPlayerRows(%0,%1)				g_player_rows[%0] = %1
#define	GetPlayerRows(%0)					g_player_rows[%0]

#define GetPlayerLastDialog(%0) 			GetPlayerTemp(%0, tLAST_DIALOG)			// Последний диалог, на который дали ответ
#define GetPlayerDialog(%0) 				GetPlayerTemp(%0, tCURRENT_DIALOG)			// Последний показанный диалог

#define MAX_MODULE_DIALOG_NAME				42
#define ClearPlayerModuleDialog(%0)			g_current_module_dialog_name[%0] = ""
#define GetPlayerModuleDialog(%0)			g_current_module_dialog_name[%0]
#define SetPlayerModuleDialog(%0,%1)		format(g_current_module_dialog_name[%0], MAX_MODULE_DIALOG_NAME, "%s", %1)
#define SetPlayerLastDialog(%0,%1) 			SetPlayerTemp(%0, tLAST_DIALOG, %1)
#define SetPlayerDialog(%0,%1) 				SetPlayerTemp(%0, tCURRENT_DIALOG, %1)
#define	is_inputtext_null()					strequal(inputtext, "null", true)

new g_current_module_dialog_name[MAX_PLAYERS][MAX_MODULE_DIALOG_NAME];

stock ClearPlayerListitem(playerid, safe_index = -1)
{
	new buffer_str[MAX_PLAYER_NAME];
	new buffer_int;

	if(safe_index != -1)
	{
		format(buffer_str, sizeof buffer_str, "%s", GetPlayerListitemName(playerid, safe_index));
		buffer_int = GetPlayerListitem(playerid, safe_index);
	}

	g_player_page[playerid] = EOS;
	g_player_rows[playerid] = INVALID_DIALOG_ROWS;

	for(new idx; idx != sizeof g_player_listitem[]; idx++) 
		g_player_listitem[playerid][idx] = -1;

	for(new idx; idx != sizeof g_player_action_string[]; idx++) 
		g_player_action_string[playerid][idx][0] = EOS;

	if(safe_index != -1)
	{
		SetPlayerListitemName(playerid, 0, buffer_str);
		SetPlayerListitem(playerid, 0, buffer_int);
	}
}

stock OnShowPlayerDialog(playerid, dialogid)
{
	SetPlayerDialog(playerid, dialogid);
	ClearPlayerModuleDialog(playerid);
	return 1;
}

stock HideDialog(playerid)
{
	ClearPlayerModuleDialog(playerid);
	return ShowPlayerDialog(playerid, -1, 0, "", "", "", "");
}

stock ShowDialog(playerid, const dialog_name[], dialog_id, dialog_style, const dialog_header[], const dialog_content[], const dialog_button_l[], const dialog_button_r[] = "")
{
	#if defined DIALOG_MODULE_DEBUG
		printf("[debug dialog]: SHOW > MODULE; dialog_name: %s; [playerid: %d; dialogid: %d];", 
			dialog_name, playerid, dialog_id
		);
	#endif

	new result =  ShowPlayerDialog(playerid, dialog_id, dialog_style, dialog_header, dialog_content, dialog_button_l, dialog_button_r);
	SetPlayerModuleDialog(playerid, dialog_name);
	return result;
}
new
	str_least[64];
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(strlen(GetPlayerModuleDialog(playerid)) >= 2)
	{
		format(str_least, sizeof str_least, "%s", GetPlayerModuleDialog(playerid));
		ClearPlayerModuleDialog(playerid);

		if(funcidx(str_least) != -1)
		{
			new input_length = strlen(inputtext);
			if(input_length > 0)
			{
				for(input_length--; input_length > -1; input_length--)
				{
					switch(inputtext[input_length])
					{
						case 0x25: inputtext[input_length] = 0x23; // Меняем '%' на '#'
						case 0x00 .. 0x1F: inputtext[input_length] = 0x3F; // Меняем 'Управляющие символы' на '?'
					}
				}
			}
			else 
			{
				// BUG: https://wiki.pro-pawn.ru/wiki/CallLocalFunction [Передача пустой строки в качестве аргумента целевой функции (спецификатор s) приводит к падению сервера]
				format(inputtext, 5, "null");
			}

			#if defined DIALOG_MODULE_DEBUG
				#warning "[custom]: DIALOG_MODULE_DEBUG enabled;"
				printf("[debug dialog]: MODULE; dialog_name: %s; [playerid: %d; dialogid: %d; response: %d; listitem: %d; inputtext: %s];", 
					str_least, playerid, dialogid, response, listitem, inputtext
				);
			#endif

			new result = CallLocalFunction(str_least, "dddds", playerid, dialogid, response, listitem, inputtext);

			if(result) printf("[debug dialog]: MODULE; dialogid: %d;", dialogid);
			else printf("[debug dialog]: MODULE (error or return false); dialogid: %d;", dialogid);

			// Log:Dialog(playerid, dialogid, GetPlayerModuleDialog(playerid), response, listitem, inputtext);

			SetPlayerLastDialog(playerid, dialogid);
			return 1;
		}
	}
	
	SetPlayerLastDialog(playerid, dialogid);
	printf("[debug dialog]: DEFAULT; dialogid: %d;", dialogid);
	return W_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
}

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse W_OnDialogResponse
forward W_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
