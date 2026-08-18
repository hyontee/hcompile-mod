#include <a_samp>
#include <a_http>
#include <foreach>

#define MNAME "FLIN MOBILE 01"

new string[512];
new string1[512];
new start;
new timer;

public OnFilterScriptInit()
{
	start = gettime();
	timer = SetTimer("UpdateTimerMonitor", 5000, 1);
	return 1;
}

public OnFilterScriptExit()
{
    KillTimer(timer);
	return 1;
}

forward UpdateTimerMonitor();
public UpdateTimerMonitor()
{
    string = "";
	GetNetworkStats(string, sizeof(string));

	new loss, mlen = strlen(string);
	if(mlen)
	{
    	new count, mstart, mstop;
    	for(new i; i < mlen; i++) if(string[i] == '\n')
		{
	    	if(mstart)
			{
				mstop = i;
				break;
			}
	    	if(++count == 9) mstart = i;
		}
		string1 = "";
		if(mstart && mstop) strmid(string1, string, (mstart + 1), mstop);

		mlen = strlen(string1);
		if(mlen)
		{
			mstart = 0;
			for(new i; i < mlen; i++) if(string1[i] == ':')
			{
				mstart = (i + 2);
				break;
			}
			string = "";
			if(mstart) strmid(string, string1, mstart, (mlen - 1));

			mlen = strlen(string);
			if(mlen)
			{
			    new Float:oloss = floatstr(string);
			    if(oloss >= 0.0) loss = floatround(oloss);
			}
		}
	}
	string = "";
	format(string, sizeof(string), "online=%i&start_unix=%i&last_unix=%i&tick_rate=%i&packet_loss=%i&server="MNAME"", Iter_Count(Player), start, gettime(), GetServerTickRate(), loss);
	HTTP(0, HTTP_POST, "api3.ololosh.space/tgbot_take.php", string, "OnMonitorApiResponse");
}

forward OnMonitorApiResponse(index, code, const data[]);
public OnMonitorApiResponse(index, code, const data[])
{

}








forward LongPollResponse(index, response_code, data[]);
public LongPollResponse(index, response_code, data[]) {
    if (response == 502) {
        // Статус 502 - это таймаут соединения;
        // возможен, когда соединение ожидало слишком долго
        // и сервер (или промежуточный прокси) закрыл его
        // давайте восстановим связь
        LongPollConnect();
    }
    else if (response_code != 200) {
        // Какая-то ошибка, покажем её
        printf("LONG_POLL ERROR: %s", data);
        // Подключимся снова через секунду.

        LongPollConnect();
    }
    else {
        // Получаем данные из data
        // И снова вызовем HTTP для получения следующего сообщения
        LongPollConnect();
    }
}

LongPollConnect()
{
    HTTP(-1, HTTP_POST, "flin-rp.com/long_poll.php", "params..", "LongPollResponse");
}

api.flin-rp.com/events/subscribe?srv=1&account_id=777&listen=['donate:receive', 'auth:vk_bot']
