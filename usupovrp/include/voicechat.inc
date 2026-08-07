native VoiceChat_Start(port, maxOnline, ip[]); // для запуска сервера
native VoiceChat_MutePlayer(playerid);
native VoiceChat_UnMutePlayer(playerid);
native VoiceChat_Disconnect(playerid);
native VoiceChat_PushInfo(playerid, Float:posX, Float:posY, Float:posZ, vw, ispectating);	// вызывать каждые 100-200 мс для обновления позиций
native VoiceChat_StartPushInfo(); // вызвать перед VC_PushInfo
native VoiceChat_EndPushInfo(); // вызвать после пуша
native VoiceChat_ResetPushInfo(); // отмена пуша