#if defined _inc_u_dialogs
    #undef _inc_u_dialogs
#endif

#if defined u_dialogs_inc_
    #endinput
#endif

#define u_dialogs_inc_

#if !defined NEW_DIALOG_ID
    #define NEW_DIALOG_ID (32767)
#endif

#if !defined MAX_FUNC_NAME
    #define MAX_FUNC_NAME (32)
#endif

#define DialogResponse:%0(%1) \
        public cdr_%0(playerid, response, listitem, inputtext[]); \
        public cdr_%0(playerid, response, listitem, inputtext[]) \
            return dlg_%0(playerid, response, listitem, inputtext); \
        dlg_%0(%1)

#define IsDialog(%0,"%1") (!strcmp(%0, "cdr_"#%1))

static dialog_func[MAX_PLAYERS][MAX_FUNC_NAME char];

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #if defined OnDialogReceived
        if (!OnDialogReceived(playerid, dialog_func[playerid], response, listitem))
        {
            return 0;
        }
    #endif
    if (inputtext[0] == '\0')
    {
        CallLocalFunction(dialog_func[playerid], !"ddds", playerid, response, listitem, !"\1");
        return 1;
    }
    CallLocalFunction(dialog_func[playerid], !"ddds", playerid, response, listitem, inputtext);
    #if defined _u_dlg_OnDialogResponse
        _u_dlg_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif
    return 1;
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#if defined _u_dlg_OnDialogResponse
forward _u_dlg_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
#define OnDialogResponse _u_dlg_OnDialogResponse

stock
    ShowPlayerDialogEx(playerid, function[], style, caption[], info[], button1[], button2[])
{
    if (!IsPlayerConnected(playerid))
        return 0;
    dialog_func[playerid] = !"cdr_";
    strcat(dialog_func[playerid], function);
    ShowPlayerDialog(playerid, NEW_DIALOG_ID, style, caption, info, button1, button2);
    return 1;
}

#if defined OnDialogReceived
forward OnDialogReceived(playerid, function[], response, listitem);
#endif 