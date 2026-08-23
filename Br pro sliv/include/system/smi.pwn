/*
 @lonexsstudio @lonexsbio @felixstudio777
*/

public OnSmiGuiAccessCheck(playerid)
{
    return Smi_IsStaff(playerid);
}

public OnSmiGuiSubmit(playerid, action, const text[])
{
    if(!Smi_IsStaff(playerid)) return 0;

    new message[220];

    if(action == SMI_GUI_ACTION_NEWS)
        format(message, sizeof(message), "[\xCD\xCE\xC2\xCE\xD1\xD2\xC8 \xD1\xCC\xC8] %s[%d]: %s", Player[playerid][pName], playerid, text);
    else
        format(message, sizeof(message), "[\xD1\xCC\xC8] %s[%d]: %s", Player[playerid][pName], playerid, text);

    SendClientMessageToAll(0x3399FFFF, message);
    FactionGUI_AddTaskProgress(playerid, 3, 1);
    return 1;
}
