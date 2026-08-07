// ============================================================
// WorkkGUI.pwn -- приЄм вход€щих GUI-пакетов (порт из mod usupov)
// —юда добавл€ютс€ новые case по мере портировани€ остальных GUI
// ============================================================

IPacket:252(playerid, BitStream:bitstream)
{
	new header, guiid;
	BS_ReadValue(bitstream, PR_UINT8, header);
	BS_ReadValue(bitstream, PR_UINT16, guiid);

	new length;
	BS_ReadValue(bitstream, PR_UINT32, length);
	if(length <= 0 || length >= sizeof(g_gui_incoming))
		return 1;

	BS_ReadValue(bitstream, PR_STRING, g_gui_incoming, length);
	g_gui_incoming[length] = '\0';

	new Node:json = JSON_Object();
	JSON_Parse(g_gui_incoming, json);

	switch(guiid)
	{
		case GUIWoundSystem:
		{
			new action_code = -1;
			JSON_GetInt(json, "t", action_code);

			switch(action_code)
			{
				case WOUND_ACTION_NEED_HELP:
				{
					if(g_WoundNeedHelpTimer[playerid] > 0)
					{
						ShowNotification(playerid, 2, "”же запросили помощь, подождите", 5, "", "");
						return 1;
					}

					ShowNotification(playerid, 3, "—ообщение отправлено на сервер", 5, "", "");

					new fmt_msg[144];
					format(fmt_msg, sizeof(fmt_msg), "[SOS] %s[%d] нуждаетс€ в помощи!", GetPlayerNameEx(playerid), playerid);
					SendMessageInLocal(playerid, fmt_msg, 0xFF0000FF, 50.0);

					g_WoundNeedHelpTimer[playerid] = WOUND_NEED_HELP_TIME;
					SendWoundSystemPacketToClient(playerid, WOUND_ACTION_NEED_HELP);
				}
				case WOUND_ACTION_NEED_HOSPITAL:
				{
					if(!g_PlayerWounded[playerid]) return 1;

					ClearPlayerWounded(playerid);
					TeleportPlayerToHospital(playerid);
				}
				case WOUND_ACTION_NOT_DISPLAY, WOUND_ACTION_DISMISS_INTERFACE:
				{
					// клиент закрыл интерфейс, ничего не делаем
				}
			}
		}
	}

	JSON_Cleanup(json);
	return 1;
}
