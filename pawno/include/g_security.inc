/*==============================================================================

                        Google Security by using TOTP plugin
                        g_security.inc v0.0.1
                        Author: #Djuga
                        Copyright (c) 2018 Dmitriy Djuga (#Djuga)
==============================================================================*/

#if defined G_SECURITY
    #endinput
#endif

#define G_SECURITY

#if __Pawn >= 0x3A && defined __PawnBuild
    #if __Pawn > 0x3A || __PawnBuild >= 2
        #define static_enum        static enum
    #endif
#endif
#if !defined static_enum
    #define static_enum        enum
#endif


#if !defined GoogleAuthenticatorCode
    native GoogleAuthenticatorCode(key[], tm);
#endif  

static 
        bool:inc_gPlayerHasProtection[MAX_PLAYERS char],
        inc_gPlayerSecretKey[MAX_PLAYERS][17],
        inc_string[193],
        inc_gLetters[32][] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y","Z","2", "3", "4", "5", "6", "7"};

static_enum
{
    INC_DLG_FIRST_STEP = 32765,
    INC_DLG_SECOND_STEP,
    INC_DLG_GOOGLE_AUTH
};

stock ShowGoogleAuth(playerid)
{
    if(false == inc_gPlayerHasProtection{playerid})
        return 0;

    ShowPlayerDialog(playerid, INC_DLG_GOOGLE_AUTH, DIALOG_STYLE_INPUT, "Google Autherization", "Введите секретный ключ из приложения", "Далее", "Отмена");

    return 1;
}

#if defined CMD
CMD:sprotection(playerid)
{
    if(true == inc_gPlayerHasProtection{playerid}){
		callcmd::oprotection(playerid);
	}

    if(false == inc_gPlayerHasProtection{playerid}) ShowPlayerDialog(playerid, INC_DLG_FIRST_STEP, DIALOG_STYLE_MSGBOX, "Google Authenticator", "Вы собираетесь подключить защиту с помощью Google Authenticator'a\nДля продолжения нажмите \"Далее\"", "Далее", "Отмена");

    return 1;
}

CMD:oprotection(playerid)
{
   	if(false == inc_gPlayerHasProtection{playerid})
        return SendClientMessage(playerid, -1, "У вас не подключена данная защита!");

    format(inc_string, sizeof inc_string, "DELETE FROM `google_protect` WHERE `gKey` = '%s'", inc_gPlayerSecretKey[playerid]);  
    
    #if defined cache_get_value_int /*r41+*/
        mysql_query(MYSQL_DEFAULT_HANDLE, inc_string, false);
    #else
        #if defined cache_get_row_int
            mysql_query(1, inc_string, false);
        #endif
    #endif

    return 1;       
}   

#else

public OnPlayerCommandText(playerid, cmdtext[])
{
    
    if(0 == strcmp(cmdtext, "/sprotection", true))
    {
        if(true == inc_gPlayerHasProtection{playerid})
            return SendClientMessage(playerid, -1, "У вас уже подключена защита! Для отключения /oprotection");

        ShowPlayerDialog(playerid, INC_DLG_FIRST_STEP, DIALOG_STYLE_MSGBOX, "Google Authenticator", "Вы собираетесь подключить защиту с помощью Google Authenticator'a\nДля продолжения нажмите \"Далее\"", "Далее", "Отмена");

        return 1;
    }

    else if(0 == strcmp(cmdtext, "/oprotection", true))
    {
        if(false == inc_gPlayerHasProtection{playerid})
            return SendClientMessage(playerid, -1, "У вас не подключена данная защита!");

        format(inc_string, sizeof inc_string, "DELETE FROM `google_protect` WHERE `gKey` = '%s'", inc_gPlayerSecretKey[playerid]);  
    
        #if defined cache_get_value_int /*r41+*/
            mysql_query(MYSQL_DEFAULT_HANDLE, inc_string, false);
        #else
            #if defined cache_get_row_int
                mysql_query(1, inc_string, false);
            #endif
        #endif

        return 1;       
    }   

    #if defined s_OnPlayerCommandText
        return s_OnPlayerCommandText(playerid, cmdtext);
    #endif  
}

#endif

#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif

#define OnPlayerCommandText s_OnPlayerCommandText

forward s_OnPlayerCommandText(playerid, cmdtext[]); 

public OnGameModeInit()
{

    #if defined s_OnGameModeInit
        s_OnGameModeInit();
    #endif      

    #if defined cache_get_value_int /*r41+*/
        mysql_query(MYSQL_DEFAULT_HANDLE, "CREATE TABLE IF NOT EXISTS google_protect ( gName varchar(24), gKey varchar(17)) ENGINE=InnoDB;", false);
    #else
        #if defined cache_get_row_int
            mysql_query(1, "CREATE TABLE IF NOT EXISTS google_protect ( gName varchar(24), gKey varchar(17)) ENGINE=InnoDB;", false);
        #endif
    #endif

    return 1;   

}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else 
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit s_OnGameModeInit

forward s_OnGameModeInit();

public OnPlayerConnect(playerid)
{

    GetPlayerName(playerid, inc_string, MAX_PLAYER_NAME);

    format(inc_string, sizeof inc_string,"SELECT * FROM `google_protect` WHERE `gName` = '%s'", inc_string);
    #if defined cache_get_value_int /*r41+*/
        mysql_tquery(MYSQL_DEFAULT_HANDLE, inc_string, "@__inc_GetPlayerData", "i", playerid);
    #else
        #if defined cache_get_row_int
            mysql_tquery(1, inc_string, "@__inc_GetPlayerData", "i", playerid);
        #endif
    #endif

    #if defined s_OnPlayerConnect
        return s_OnPlayerConnect(playerid);
    #endif  
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif


#define OnPlayerConnect s_OnPlayerConnect

forward s_OnPlayerConnect(playerid);

@__inc_GetPlayerData(playerid);
@__inc_GetPlayerData(playerid)
{
    #if defined cache_get_value_name /*r41+*/
        new
            rows;

        cache_get_row_count(rows);  

        if(0 == rows)
        {
            inc_gPlayerHasProtection{playerid} = false;

            return 1;
        }

        cache_get_value_name(0, "gKey", inc_gPlayerSecretKey[playerid], 17);
    #else
        #if defined cache_get_field_content
            new 
                rows, 
                fields;

            cache_get_data(rows, fields);

            if(0 == rows)
                return 1;

            cache_get_field_content(0, "gKey", inc_gPlayerSecretKey[playerid], 1, 17);
        #endif  
    #endif

    inc_gPlayerHasProtection{playerid} = true;  

    return 1;   

}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
        
    switch(dialogid)
    {
        case INC_DLG_FIRST_STEP:
        {
            if(0 == response)
                return 1;

            inc_gPlayerSecretKey[playerid][0] = EOS;    

            for(new i; i < 17; i++)
                strcat(inc_gPlayerSecretKey[playerid], inc_gLetters[random(sizeof inc_gLetters)]);

            format(inc_string, sizeof inc_string, "1. Для начала скачайте Google Authenticator.\n2. Затем введитье данный код в приложение: \"%s\"\n3. После ввода кода, введить 6-ти значный код, который появился у вас на экране.", inc_gPlayerSecretKey[playerid]);
        
            ShowPlayerDialog(playerid, INC_DLG_SECOND_STEP, DIALOG_STYLE_INPUT , "Google Authenticator", inc_string, "Далее", "Отмена");
        }

        case INC_DLG_SECOND_STEP:
        {
            if(0 == response)
                return 1;

            new
                google_key = GoogleAuthenticatorCode(inc_gPlayerSecretKey[playerid], gettime());

            if(google_key != strval(inputtext))
            {
                SendClientMessage(playerid, -1, "Неверный пароль с приложения!");

                ShowPlayerDialog(playerid, INC_DLG_SECOND_STEP, DIALOG_STYLE_INPUT , "Google Authenticator", "Введите 6-ти значный код из приложения", "Далее", "Отмена");

                return 1;
            }   

            GetPlayerName(playerid, inc_string, MAX_PLAYER_NAME);   

            format(inc_string, sizeof inc_string, "INSERT INTO `google_protect` (`gName`, `gKey`) VALUES ('%s', '%s')", inc_string, inc_gPlayerSecretKey[playerid]);    
    
            #if defined cache_get_value_int /*r41+*/
                mysql_query(MYSQL_DEFAULT_HANDLE, inc_string, false);
            #else
                #if defined cache_get_row_int
                    mysql_query(1, inc_string, false);
                #endif
            #endif  

            SendClientMessage(playerid, -1, "Вы успешно установили себе Google Authenticator!");
        }

        case INC_DLG_GOOGLE_AUTH:
        {
            if(0 == response)
                Kick(playerid);

            new
                google_key = GoogleAuthenticatorCode(inc_gPlayerSecretKey[playerid], gettime());

            if(google_key != strval(inputtext))
            {
                SendClientMessage(playerid, -1, "Неверный пароль с приложения!");

                Kick(playerid);

                return 1;
            }   

            SendClientMessage(playerid, -1, "Вы успешно авторизовались!");  
        }
    }   

    #if defined s_OnDialogResponse
        return s_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif        
} 

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse 
#endif

#define OnDialogResponse s_OnDialogResponse

forward s_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);