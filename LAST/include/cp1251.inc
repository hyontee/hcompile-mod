#if defined _BR_CP1251_INC_
    #endinput
#endif
#define _BR_CP1251_INC_

/*
    DB / mobile client: UTF-8
    SAMP mod (Pawn literals, dialogs, chat): Windows-1251
*/

stock bool:cp1251_has_utf8_cyrillic(const string[])
{
    for(new i = 0; string[i]; i++)
    {
        new c = string[i] & 0xFF;
        if((c == 0xD0 || c == 0xD1) && string[i + 1])
        {
            new c2 = string[i + 1] & 0xFF;
            if(c2 >= 0x80 && c2 <= 0xBF) return true;
        }
    }
    return false;
}

stock bool:cp1251_has_high_bytes(const string[])
{
    for(new i = 0; string[i]; i++)
    {
        if((string[i] & 0xFF) >= 0x80) return true;
    }
    return false;
}

stock utf8_to_cp1251(string[], maxlen = sizeof string)
{
    #pragma unused maxlen
    new len = strlen(string);
    for(new i = 0; i < len; i++)
    {
        new c = string[i] & 0xFF;
        if(c == 0xD0 && i + 1 < len)
        {
            new c2 = string[i + 1] & 0xFF;
            if(c2 == 0x81)
            {
                string[i] = 0xA8;
                strdel(string, i + 1, i + 2);
                len--;
            }
            else if(c2 >= 0x90 && c2 <= 0xBF)
            {
                string[i] = c2 + 0x30;
                strdel(string, i + 1, i + 2);
                len--;
            }
        }
        else if(c == 0xD1 && i + 1 < len)
        {
            new c2 = string[i + 1] & 0xFF;
            if(c2 == 0x91)
            {
                string[i] = 0xB8;
                strdel(string, i + 1, i + 2);
                len--;
            }
            else if(c2 >= 0x80 && c2 <= 0xBF)
            {
                string[i] = c2 + 0x70;
                strdel(string, i + 1, i + 2);
                len--;
            }
        }
    }
    return 1;
}

stock cp1251_to_utf8(string[], maxlen = sizeof string)
{
    new tmp[384];
    new j = 0, len = strlen(string);

    for(new i = 0; i < len && j < sizeof(tmp) - 3; i++)
    {
        new c = string[i] & 0xFF;
        if(c < 0x80)
        {
            tmp[j++] = string[i];
        }
        else if(c == 0xA8)
        {
            tmp[j++] = 0xD0;
            tmp[j++] = 0x81;
        }
        else if(c == 0xB8)
        {
            tmp[j++] = 0xD1;
            tmp[j++] = 0x91;
        }
        else if(c >= 0xC0 && c <= 0xEF)
        {
            tmp[j++] = 0xD0;
            tmp[j++] = c - 0x30;
        }
        else if(c >= 0xF0 && c <= 0xFF)
        {
            tmp[j++] = 0xD1;
            tmp[j++] = c - 0x70;
        }
        else
        {
            tmp[j++] = string[i];
        }
    }
    tmp[j] = EOS;
    format(string, maxlen, "%s", tmp);
    return 1;
}

stock cp1251_fix(string[], maxlen = sizeof string)
{
    if(!cp1251_has_utf8_cyrillic(string)) return 0;
    utf8_to_cp1251(string, maxlen);
    return 1;
}

stock bool:cp1251_is_utf8(const string[])
{
    return cp1251_has_utf8_cyrillic(string);
}

stock cp1251_from_utf8(dest[], destLen, const src[])
{
    format(dest, destLen, "%s", src);
    utf8_to_cp1251(dest, destLen);
    return 1;
}
