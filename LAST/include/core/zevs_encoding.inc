#if defined _BR_DEATH_ENCODING_INC_
    #endinput
#endif
#define _BR_DEATH_ENCODING_INC_

// cp1251.inc — в death.pwn до этого файла
// Игра / Pawn-файлы: Windows-1251. MySQL/phpMyAdmin часто отдаёт UTF-8 — конвертируем при чтении.
// Запись в БД: CP1251 (SET NAMES cp1251), admprefix только через AT_SaveAdminDataToDB.

stock BR_FixUserText(text[], maxlen)
{
    return cp1251_fix(text, maxlen);
}

stock BR_CopyUserText(dest[], destLen, const src[])
{
    format(dest, destLen, "%s", src);
    cp1251_fix(dest, destLen);
    return 1;
}

stock BR_FixDialogInput(inputtext[], maxlen = sizeof inputtext)
{
    if(inputtext[0]) cp1251_fix(inputtext, maxlen);
    return 1;
}

// После cache_get_field_content: UTF-8 из MySQL -> CP1251 для SAMP
stock BR_DbToGame(text[], maxlen)
{
    if(!text[0]) return 0;
    if(cp1251_has_utf8_cyrillic(text))
        utf8_to_cp1251(text, maxlen);
    return 1;
}
