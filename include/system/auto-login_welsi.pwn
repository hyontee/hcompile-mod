//Если Вам что-то не понятно смотрите пример на скринах
//Автор Welsi - t.me/welsistudio

//1. Добавьте данную строку после "SetPlayerData(playerid, P_ACCOUNT_ID, cache_get_field_content_int(0, "id"));":

//SetPlayerData(playerid, P_LAST_LOGIN_TIME, cache_get_field_content_int(0, "last_login"));

//2. Добавьте данные строки после 
        /*case LOGIN_STATE_PASSWORD:
		    {
                new time = gettime(), minute = time - GetPlayerData(playerid, P_LAST_LOGIN_TIME), ip[18];

                if(minute < 900 && !strfind(GetPlayerIpEx(playerid), GetPlayerData(playerid, P_LAST_IP))) 
                {
                    ShowPlayerDialog(playerid, -1, 0, " ", " ", " ", " "); 
                    SetPlayerData(playerid, P_ACCOUNT_STEP_STATE, LOGIN_STATE_LOAD_ACC);
                    
                    SetPlayerData(playerid, P_AUTH_TIME, -1);
                    LoadPlayerData(playerid);
                    
                    
                    return 1;
                }*/

                //Другой код (который трогать не нужно)

//3. Добавитье данные строки после 

/*public: SavePlayerAccount(playerid)
{
	new query[370];*/

	//if(!IsPlayerLogged(playerid)) return 0; 

//4. Конец (если вы это не сможете добавить - смотрите скриншоты. там выделено БЕЛЫМ ПРЯМОУГОЛЬКОМ код который нужно скопировать и вставить)


//4. Автор Welsi - t.me/welsistudio (переходник)
//5. Поддержите подпиской если Вы ещё не подписаны :)