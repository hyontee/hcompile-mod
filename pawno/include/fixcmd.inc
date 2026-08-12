#if defined _fixcmd_included
	#endinput
#endif	
#define _fixcmd_included

#define FIXCMD_MAJOR_VERSION 0
#define FIXCMD_MINOR_VERSION "2.1"

#if !defined sscanf
	#error sscanf must be include before fixcmd
#endif

public OnPlayerText(playerid, text[])
{
	static cmd[129], params[127];
	cmd[0] = params[0] = EOS;
	sscanf(text, "s[129]s[127]", cmd, params);
	#if defined PAWNCMD_INC_
		if(incorrectCmdAttempt(cmd))
		{
			FIXCMD(cmd);
			static cmd_params[256];
			format(cmd_params, sizeof(cmd_params), "%s %s", cmd, params);
			strdel(cmd, 0, 1);
			if(PC_CommandExists(cmd))return PC_EmulateCommand(playerid, cmd_params), 0;
		}
	#endif		
	//
	#if defined fc_OnPlayerText
		return fc_OnPlayerText(playerid, text);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerText
	#undef OnPlayerText
#else
	#define _ALS_OnPlayerText
#endif
#define OnPlayerText fc_OnPlayerText
#if defined fc_OnPlayerText
	forward fc_OnPlayerText(playerid, text[]);
#endif

stock FIXCMD(string[])
{
    new i;
	static ii;
    for (ii = 0; string[ii] != '\0'; ii++)
    {
        switch (string[ii])
        {
		case 'A'..'Z': string[ii] =  string[ii] + 32;

        case 'À', 'à': string[ii] = 'f';
        case 'Â', 'â': string[ii] = 'd';
        case 'Ã', 'ã': string[ii] = 'u';
        case 'Ä', 'ä': string[ii] = 'l';
        case 'Å', 'å': string[ii] = 't';
        case 'Ç', 'ç': string[ii] = 'p';
        case 'È', 'è': string[ii] = 'b';
        case 'É', 'é': string[ii] = 'q';
        case 'Ê', 'ê': string[ii] = 'r';
        case 'Ë', 'ë': string[ii] = 'k';
        case 'Ì', 'ì': string[ii] = 'v';
        case 'Í', 'í': string[ii] = 'y';
        case 'Î', 'î': string[ii] = 'j';
        case 'Ï', 'ï': string[ii] = 'g';
        case 'Ð', 'ð': string[ii] = 'h';
        case 'Ñ', 'ñ': string[ii] = 'c';
        case 'Ò', 'ò': string[ii] = 'n';
        case 'Ó', 'ó': string[ii] = 'e';
        case 'Ô', 'ô': string[ii] = 'a';
        case 'Ö', 'ö': string[ii] = 'w';
        case '×', '÷': string[ii] = 'x';
        case 'Ø', 'ø': string[ii] = 'i';
        case 'Ù', 'ù': string[ii] = 'o';
        case 'Ü', 'ü': string[ii] = 'm';
        case 'Û', 'û': string[ii] = 's';
        case 'ß', 'ÿ': string[ii] = 'z';
        default: printf("suka,blet");
        }
    }
    return string[i];
}

#define INCORRECT_CMD_CHARS '.', ',', '?'

stock incorrectCmdAttempt ( string[] )
{
    switch ( string[0] )
    {
        case INCORRECT_CMD_CHARS :
        {
            if(string[1] != '\0')return string[0] = '/', 1;
        }
    }
    return 0;
}

#undef INCORRECT_CMD_CHARS