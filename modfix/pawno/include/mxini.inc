/*
    ! file encoding: Windows-1251


   ------------------------------------------

    Самый быстрый INI ридер/райтер ( mxINI )

   ------------------


    ЧТО ЭТО
        - Это инклуд-файл для PAWN скриптов мультиплеера GTA San Andreas (SA-MP)

    КАК ИСПОЛЬЗОВАТЬ
        - Поместить этот файл в папку include, которая лежит рядом с компилятором
        - В самом верху вашего скрипта добавить #include <mxINI.inc>

    АВТОР
         MX_Master

    ВЕРСИЯ
        0.5 от 20.09.2010


    ДОСТУПНЫЕ ИНСТРУМЕНТЫ
    более подробные описания даны перед каждой функцией ниже в коде

        ini_createFile ( "путь/к/файлу.ini", "Содержимое файла по умолчанию" )

        ini_openFile ( "путь/к/файлу.ini" )

        ini_closeFile ( ИД_открытого_файла )
    --
        ini_setString ( ИД_открытого_файла, "имя ключа", "текстовое значение" )

        ini_setInteger ( ИД_открытого_файла, "имя ключа", 123456 )

        ini_setFloat ( ИД_открытого_файла, "имя ключа", 3.1416 )
    --
        ini_getString ( ИД_открытого_файла, "имя ключа", returnValue )

        ini_getInteger ( ИД_открытого_файла, "имя ключа", returnValue )

        ini_getFloat ( ИД_открытого_файла, "имя ключа", returnValue )
    --
        ini_removeKey ( ИД_открытого_файла, "имя ключа" )

        ini_getErrorInfo ( Код_ошибки )


    ПРИМЕРЫ

        new iniFile = ini_createFile ( "test4268.ini" );

        if ( iniFile < 0 )
            iniFile = ini_openFile ( "test4268.ini" );

        if ( iniFile >= 0 )
        {
            new returnString[32], returnNumber, Float: returnFloat;

            ini_setString  ( iniFile, "ключ со строкой", "текстовое значение" );
            ini_setInteger ( iniFile, "ключ с числом",   123456 );
            ini_setFloat   ( iniFile, "ключ с дробью",   3.1416 );

            ini_removeKey  ( iniFile, "ключ с числом" );

            ini_getString  ( iniFile, "ключ со строкой", returnString );
            ini_getInteger ( iniFile, "ключ с числом",   returnNumber );
            ini_getFloat   ( iniFile, "ключ с дробью",   returnFloat );


            ini_closeFile  ( iniFile );

            printf ( "\n `ключ_со_строкой` = `%s`,\n `ключ_с_числом` = `%d`,\n `ключ_с_дробью` = `%f` \n",
                returnString, returnNumber, returnFloat );
        }
        else print( "\n Не удалось открыть INI файл \n" );
*/




#define iniOpen ini_openFile
#define iniClose ini_closeFile
#define iniGet ini_getString
#define iniGetInt ini_getInteger
#define iniGetFloat ini_getFloat
#define iniSet ini_setString
#define iniSetInt ini_setInteger
#define iniSetFloat ini_setFloat
#define iniRemoveKey ini_removeKey






const




    INI_MAX_OPENED_FILES    = 2,
    INI_MAX_FILE_SIZE       = 65536,
    INI_MAX_FILENAME_SIZE   = 128,
    INI_MAX_KEYS_IN_FILE    = 2048,






    INI_INTEGER_SIZE        = 12,
    INI_FLOAT_SIZE          = 40,

    INI_STRING_DELIMITER    = '\n',
    INI_DELIMITER           = '=',





    INI_OK                  =  0,




    INI_FILE_NOT_FOUND      = -1,
    INI_FILE_ALREADY_EXIST  = -2,
    INI_TOO_LARGE_FILE      = -3,
    INI_WRONG_PATH_SIZE     = -4,
    INI_READ_ERROR          = -5,
    INI_WRITE_ERROR         = -6,
    INI_NO_FREE_SLOT        = -7,
    INI_WRONG_SLOT          = -8,
    INI_KEY_NOT_FOUND       = -9,
    INI_WRONG_RETURN_SIZE   = -10,





    cellbytes = cellbits / charbits;








#define INI_SPACE_CHAR  ' ', '\t'
#define INI_KEY_STARTS  ' ', '\t', '\r', '\n', '\0'
#define INI_STRING_ENDS '\r', '\n', '\0'
#define INI_NUMBER_ENDS ' ', '\t', '\r', '\n', '\0'





static stock



    _ini_nSlotUsed      [ INI_MAX_OPENED_FILES ],
    _ini_nFileChanged   [ INI_MAX_OPENED_FILES ],
    _ini_nFileBusy      [ INI_MAX_OPENED_FILES ],
    _ini_nFileSize      [ INI_MAX_OPENED_FILES ],
    _ini_nDelimPos      [ INI_MAX_OPENED_FILES ] [ INI_MAX_KEYS_IN_FILE ],
    _ini_nKeysCount     [ INI_MAX_OPENED_FILES ],
    _ini_szFilePath     [ INI_MAX_OPENED_FILES ] [ INI_MAX_FILENAME_SIZE ],
    _ini_szFileContent  [ INI_MAX_OPENED_FILES ] [ INI_MAX_FILE_SIZE char ];





















/*
    Создает и сразу открывает INI файл для чтения/записи.

    ПОДРОБНЕЕ
        Файл создается только в ОЗУ, и в него записывается строка szDefaultContent.
        В szDefaultContent могут быть и ключи, которые потом парсер также будет видеть.
        Только при закрытии файла, его содержимое будет записано на диск
        по указанному пути к файлу.

    ПАРАМЕТРЫ:
        szFilePath[]        путь к файлу
        szDefaultContent    контент файла по умолчанию, обычно, можно не указывать

    ВЕРНЕТ:
        код ошибки < 0 или ИД_открытого_файла
*/

stock ini_createFile ( szFilePath[], szDefaultContent[] = "" )
{





    new nFileNameSize = strlen( szFilePath );


    if ( nFileNameSize <= 0 || nFileNameSize >= INI_MAX_FILENAME_SIZE )
        return INI_WRONG_PATH_SIZE;




    if ( fexist( szFilePath ) )
        return INI_FILE_ALREADY_EXIST;

    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ )
        if
        (
                _ini_nSlotUsed[slot] != 0
            &&  strcmp( szFilePath, _ini_szFilePath[slot], false ) == 0
        )
            return INI_FILE_ALREADY_EXIST;





    new nFileSize = strlen( szDefaultContent );


    if ( nFileSize < 0 || nFileSize >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE;









    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ )
    {
        if ( _ini_nSlotUsed[slot] != 1 )
        {

            _ini_nSlotUsed[slot]        = 1;
            _ini_nFileChanged[slot]     = 0;
            _ini_nFileSize[slot]        = nFileSize;
            _ini_nKeysCount[slot]       = 0;






            for ( new i = 0;  i < nFileSize && i < INI_MAX_FILE_SIZE;  i++ )
            {
                if (
                        szDefaultContent[i] == INI_DELIMITER
                    &&  _ini_nKeysCount[slot] < INI_MAX_KEYS_IN_FILE
                ) {
                    _ini_nDelimPos[slot][ _ini_nKeysCount[slot] ] = i;
                    _ini_nKeysCount[slot]++;
                }

                _ini_szFileContent[slot]{i} = szDefaultContent[i];
            }

            _ini_szFileContent[slot]{nFileSize} = 0;





            memcpy( _ini_szFilePath[slot], szFilePath, 0, nFileNameSize * cellbytes );

            _ini_szFilePath[slot][nFileNameSize] = 0;



            return slot;
        }
    }








    return INI_NO_FREE_SLOT;

}




/*
    Открывает INI файл для чтения/записи, если он существует.

    ПОДРОБНЕЕ
        Копирует в ОЗУ с диска всё содержимое файла, если его размер не превышает
        допустимый. Если кол-во ключей в файле больше допустимого, ошибки никакой не будет,
        просто при чтении/записи значений, парсер не будет видеть лишние ключи.

    ПАРАМЕТРЫ:
        szFilePath[]    путь к файлу

    ВЕРНЕТ:
        код ошибки < 0 или ИД_открытого_файла
*/

stock ini_openFile ( szFilePath[] )
{





    new nFileNameSize = strlen( szFilePath );


    if ( nFileNameSize <= 0 || nFileNameSize >= INI_MAX_FILENAME_SIZE )
        return INI_WRONG_PATH_SIZE;



    if ( ! fexist( szFilePath ) )
        return INI_FILE_NOT_FOUND;




    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ )
        if
        (
                _ini_nSlotUsed[slot] != 0
            &&  strcmp( szFilePath, _ini_szFilePath[slot], false ) == 0
        )
            return slot;




    new File: pFile = fopen( szFilePath, io_read );

    if ( ! pFile )
        return INI_READ_ERROR;




    new nFileSize = flength( pFile );

    if ( nFileSize >= INI_MAX_FILE_SIZE )
    {
        fclose(pFile);
        return INI_TOO_LARGE_FILE;
    }










    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ )
    {
        if ( _ini_nSlotUsed[slot] != 1 )
        {

            _ini_nSlotUsed[slot]        = 1;
            _ini_nFileChanged[slot]     = 0;
            _ini_nFileSize[slot]        = nFileSize;
            _ini_nKeysCount[slot]       = 0;






            for ( new i = 0, symbol; i < nFileSize && i < INI_MAX_FILE_SIZE; i++ )
            {
                symbol = fgetchar( pFile, 0, false );

                if (
                        symbol == INI_DELIMITER
                    &&  _ini_nKeysCount[slot] < INI_MAX_KEYS_IN_FILE
                ) {
                    _ini_nDelimPos[slot][ _ini_nKeysCount[slot] ] = i;
                    _ini_nKeysCount[slot]++;
                }

                _ini_szFileContent[slot]{i} = symbol;
            }

            _ini_szFileContent[slot]{nFileSize} = 0;

            fclose(pFile);





            memcpy( _ini_szFilePath[slot], szFilePath, 0, nFileNameSize * cellbytes );

            _ini_szFilePath[slot][nFileNameSize] = 0;



            return slot;
        }
    }










    fclose(pFile);

    return INI_NO_FREE_SLOT;

}




/*
    Закрывает INI файл, если он был открыт.

    ПОДРОБНЕЕ
        Если файл не был изменен - освободит слот для хранения файла в ОЗУ.
        Если файл был изменен - полностью перезапишет файл на диске.

    ПАРАМЕТРЫ:
        nFilePointer    ИД_открытого_файла, полученный от ini_openFile / ini_createFile

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_closeFile ( nFilePointer )
{
    if
    (
            nFilePointer >= 0
        &&  nFilePointer < INI_MAX_OPENED_FILES
        &&  _ini_nSlotUsed[nFilePointer] != 0
    )
    {
        if ( _ini_nFileChanged[nFilePointer] != 0 )
        {
            new File: pFile = fopen( _ini_szFilePath[nFilePointer], io_write );

            if ( ! pFile )
                return INI_WRITE_ERROR;


            for ( new i = 0;  i < _ini_nFileSize[nFilePointer];  i++ )
                fputchar( pFile, _ini_szFileContent[nFilePointer]{i}, false );

            fclose(pFile);
        }

        _ini_nSlotUsed[nFilePointer] = 0;

        return INI_OK;
    }

    return INI_WRONG_SLOT;
}











/*
    Получает из открытого INI файла значение указанного ключа.

    ПОДРОБНЕЕ
        Парсер ищет в ОЗУ в контенте файла указанный ключ и помещает в
        szReturnValue его строковое значение. szReturnValue нужно создать заранее.

        nSizeOfReturn можно не указывать, если только не нужно точное кол-во
        возвращаемых символов в строке (в описании этого параметра ниже даны
        дополнительные указания).

        Как ключ так и значение в файле, могут быть любой длины и
        могут содержать любые символы, кроме 2 символов конца строки \r и \n.

        Парсер не видит пробелы и знаки табуляции вокруг имени ключа и
        перед значением, он считает их отступами.

    ПАРАМЕТРЫ:
        nFilePointer        ИД_открытого_файла, полученный от ini_openFile / ini_createFile
        szKeyName[]         имя ключа
        szReturnValue[]     сюда будет помещено значение ключа в виде строки
        nSizeOfReturn       макс. размер возвращаемой строки, обычно, это размер szReturnValue.
                            если ваша строка szReturnValue является частью массива, который был создан с помощью enum,
                            этот параметр нужно обязательно указывать как число

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_getString ( nFilePointer, szKeyName[], szReturnValue[], nSizeOfReturn = sizeof(szReturnValue) )
{

    if
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT;



    if ( nSizeOfReturn <= 0 )
        return INI_WRONG_RETURN_SIZE;



    new nKeyLen = strlen(szKeyName);

    if ( nKeyLen <= 0 )
        return INI_KEY_NOT_FOUND;




    for
    (
        new kPos = 0, curFilePos, found = 0;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {

        found = 0;

        for
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1;
            curFilePos >= 0;
            curFilePos--
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
            {
                case INI_SPACE_CHAR :           continue;
                case INI_STRING_DELIMITER :     break;
                default :
                {
                    found = 1;
                    break;
                }
            }
        }


        if ( found != 1 ) continue;




        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos]
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER
            )
            {
                found = 0;
                break;
            }
        }



        if ( found != 0 )
        {

            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }




            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue;
                    default :               break;
                }
            }






            for ( found = 0;  found < nSizeOfReturn;  found++, curFilePos++ )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_STRING_ENDS :
                    {
                        szReturnValue[found] = 0;
                        break;
                    }
                    default :

                        szReturnValue[found] = _ini_szFileContent[nFilePointer]{curFilePos};
                }
            }

            szReturnValue[nSizeOfReturn - 1] = 0;

            return INI_OK;

        }

    }




    return INI_KEY_NOT_FOUND;

}




/*
    Получает из открытого INI файла целочисленное значение указанного ключа.

    ПОДРОБНЕЕ
        Парсер ищет в ОЗУ в контенте файла указанный ключ и помещает в
        nReturnValue его целочисленное значение. nReturnValue нужно создать заранее.

        Имя ключа в файле может быть любой длины, а также может содержать
        любые символы, кроме 2 символов конца строки \r и \n.

        Значение может быть только фиксированной длины, которая равна INI_INTEGER_SIZE - 1.
        Парсер не видит пробелы и знаки табуляции вокруг имени ключа/значения,
        он считает их отступами.

    ПАРАМЕТРЫ:
        nFilePointer        ИД_открытого_файла, полученный от ini_openFile / ini_createFile
        szKeyName[]         имя ключа
        nReturnValue        сюда будет помещено значение ключа в виде целого числа

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_getInteger ( nFilePointer, szKeyName[], & nReturnValue )
{

    if
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT;




    new nKeyLen = strlen(szKeyName);

    if ( nKeyLen <= 0 )
        return INI_KEY_NOT_FOUND;




    for
    (
        new kPos = 0, curFilePos, found = 0;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {

        found = 0;

        for
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1;
            curFilePos >= 0;
            curFilePos--
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
            {
                case INI_SPACE_CHAR :           continue;
                case INI_STRING_DELIMITER :     break;
                default :
                {
                    found = 1;
                    break;
                }
            }
        }


        if ( found != 1 ) continue;




        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos]
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER
            )
            {
                found = 0;
                break;
            }
        }



        if ( found != 0 )
        {

            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }




            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue;
                    default :               break;
                }
            }




            new strValue[INI_INTEGER_SIZE];



            for ( found = 0;  found < INI_INTEGER_SIZE;  found++, curFilePos++ )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS :
                    {
                        strValue[found] = 0;
                        break;
                    }
                    default :

                        strValue[found] = _ini_szFileContent[nFilePointer]{curFilePos};
                }
            }

            strValue[INI_INTEGER_SIZE - 1] = 0;

            nReturnValue = strval(strValue);

            return INI_OK;

        }

    }




    return INI_KEY_NOT_FOUND;

}




/*
    Получает из открытого INI файла дробное численное значение указанного ключа.

    ПОДРОБНЕЕ
        Парсер ищет в ОЗУ в контенте файла указанный ключ и помещает в
        fReturnValue его дробное значение. fReturnValue нужно создать заранее.

        Имя ключа в файле может быть любой длины, а также может содержать
        любые символы, кроме 2 символов конца строки \r и \n.

        Значение может быть только фиксированной длины, которая равна INI_FLOAT_SIZE - 1.
        Парсер не видит пробелы и знаки табуляции вокруг имени ключа/значения,
        он считает их отступами.

    ПАРАМЕТРЫ:
        nFilePointer        ИД_открытого_файла, полученный от ini_openFile / ini_createFile
        szKeyName[]         имя ключа
        fReturnValue        сюда будет помещено значение ключа в виде дробного числа

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_getFloat ( nFilePointer, szKeyName[], & Float: fReturnValue )
{

    if
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT;




    new nKeyLen = strlen(szKeyName);

    if ( nKeyLen <= 0 )
        return INI_KEY_NOT_FOUND;




    for
    (
        new kPos = 0, curFilePos, found = 0;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {

        found = 0;

        for
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1;
            curFilePos >= 0;
            curFilePos--
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
            {
                case INI_SPACE_CHAR :           continue;
                case INI_STRING_DELIMITER :     break;
                default :
                {
                    found = 1;
                    break;
                }
            }
        }


        if ( found != 1 ) continue;




        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos]
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER
            )
            {
                found = 0;
                break;
            }
        }



        if ( found != 0 )
        {

            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }




            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue;
                    default :               break;
                }
            }




            new strValue[INI_FLOAT_SIZE];



            for ( found = 0;  found < INI_INTEGER_SIZE;  found++, curFilePos++ )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS :
                    {
                        strValue[found] = 0;
                        break;
                    }
                    default :

                        strValue[found] = _ini_szFileContent[nFilePointer]{curFilePos};
                }
            }

            strValue[INI_FLOAT_SIZE - 1] = 0;

            fReturnValue = floatstr(strValue);

            return INI_OK;

        }

    }




    return INI_KEY_NOT_FOUND;

}











/*
    Изменяет/добавляет в открытый INI файл указанный ключ и его значение.

    ПОДРОБНЕЕ
        Парсер ищет в ОЗУ в контенте файла указанный ключ и изменяет его
        строковое значение на szKeyValue.

        Форматирование файла не меняется. Если только указанное имя ключа
        не было найдено, тогда ключ и значение будут добавлены в конец файла.

        Имя ключа/значение в файле может быть любой длины, а также может содержать
        любые символы, кроме 2 символов конца строки \r и \n. Если эти символы есть
        в имени ключа или в значении, вы должны должны хорошо знать и осознавать
        последствия.

    ПАРАМЕТРЫ:
        nFilePointer        ИД_открытого_файла, полученный от ini_openFile / ini_createFile
        szKeyName[]         имя ключа
        szKeyValue[]        строка со значением ключа

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_setString ( nFilePointer, szKeyName[], szKeyValue[] )
{

    if
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT;




    new nKeyLen = strlen(szKeyName);

    if ( nKeyLen <= 0 )
        return INI_KEY_NOT_FOUND;




    for
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {

        found = 0;

        for
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1;
            curFilePos >= 0;
            curFilePos--
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
            {
                case INI_SPACE_CHAR :           continue;
                case INI_STRING_DELIMITER :     break;
                default :
                {
                    found = 1;
                    break;
                }
            }
        }


        if ( found != 1 ) continue;




        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos]
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER
            )
            {
                found = 0;
                break;
            }
        }


        if ( found != 0 )
        {

            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }




            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue;
                    default :               break;
                }
            }




            new nValueLen = strlen(szKeyValue);


            if ( ( curFilePos + nValueLen ) >= INI_MAX_FILE_SIZE )
                return INI_TOO_LARGE_FILE;




            new fileValueStartPos = curFilePos;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_STRING_ENDS :  break;
                    default :               continue;
                }
            }


            new filePosOffset = nValueLen - ( /*текущ длина значения*/ curFilePos - fileValueStartPos );



            if ( _ini_nFileBusy[nFilePointer] != 0 )
                return INI_WRITE_ERROR;



            _ini_nFileBusy[nFilePointer] = 1;

            if ( filePosOffset != 0 )
            {
                if ( filePosOffset < 0 )
                {
                    for
                    (
                        ;
                        curFilePos < _ini_nFileSize[nFilePointer];
                        curFilePos++
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }
                else if ( filePosOffset > 0 )
                {
                    new fileValueEndPos = curFilePos;

                    for
                    (
                        curFilePos = _ini_nFileSize[nFilePointer] - 1;
                        curFilePos >= fileValueEndPos;
                        curFilePos--
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }


                for ( kPos++;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                    _ini_nDelimPos[nFilePointer][kPos] += filePosOffset;

                _ini_nFileSize[nFilePointer] += filePosOffset;
                _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0;
            }

            curFilePos = fileValueStartPos;
            for
            (
                new valuePos = 0;
                valuePos < nValueLen;
                curFilePos++, valuePos++
            )
                _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[valuePos];

            _ini_nFileChanged[nFilePointer]     = 1;
            _ini_nFileBusy[nFilePointer]        = 0;

            return INI_OK;

        }
    }








    new nValueLen = strlen(szKeyValue);


    if ( ( _ini_nFileSize[nFilePointer] + 5 + nKeyLen + nValueLen ) >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE;




    if ( _ini_nFileBusy[nFilePointer] != 0 )
        return INI_WRITE_ERROR;

    _ini_nFileBusy[nFilePointer] = 1;




    if
    (
            _ini_nFileSize[nFilePointer] > 0
        &&  _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] - 1 } != INI_STRING_DELIMITER
    )
    {

        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] }        = '\r';
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] + 1 }    = INI_STRING_DELIMITER;

        _ini_nFileSize[nFilePointer] += 2;
    }

    new curFilePos, strPos;

    for
    (
        curFilePos = _ini_nFileSize[nFilePointer], strPos = 0;
        strPos < nKeyLen;
        curFilePos++, strPos++
    )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyName[strPos];

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' ';

    _ini_nDelimPos[nFilePointer][ _ini_nKeysCount[nFilePointer] ]   = curFilePos;
    _ini_nKeysCount[nFilePointer]++;

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = INI_DELIMITER;
    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' ';


    for ( strPos = 0;  strPos < nValueLen;  curFilePos++, strPos++ )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[strPos];

    _ini_szFileContent[nFilePointer]{curFilePos}    = 0;
    _ini_nFileSize[nFilePointer]                    = curFilePos;
    _ini_nFileChanged[nFilePointer]                 = 1;
    _ini_nFileBusy[nFilePointer]                    = 0;

    return INI_OK;

}




/*
    Изменяет/добавляет в открытый INI файл указанный ключ и его целочисленное значение.

    ПОДРОБНЕЕ
        Парсер ищет в ОЗУ в контенте файла указанный ключ и изменяет его
        целочисленное значение на nKeyValue.

        Форматирование файла не меняется, если только указанное имя ключа
        не было найдено, тогда ключ и значение будут добавлены в конец файла.

        Имя ключа в файле может быть любой длины, а также может содержать
        любые символы, кроме 2 символов конца строки \r и \n. Если вы в качестве
        значения указываете число больше, чем cellmax или меньше, чем cellmin,
        вы должны должны хорошо знать и осознавать последствия.

    ПАРАМЕТРЫ:
        nFilePointer        ИД_открытого_файла, полученный от ini_openFile / ini_createFile
        szKeyName[]         имя ключа
        nKeyValue           целочисленное значение ключа

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_setInteger ( nFilePointer, szKeyName[], nKeyValue )
{

    if
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT;




    new nKeyLen = strlen(szKeyName);

    if ( nKeyLen <= 0 )
        return INI_KEY_NOT_FOUND;




    for
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {

        found = 0;

        for
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1;
            curFilePos >= 0;
            curFilePos--
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
            {
                case INI_SPACE_CHAR :           continue;
                case INI_STRING_DELIMITER :     break;
                default :
                {
                    found = 1;
                    break;
                }
            }
        }


        if ( found != 1 ) continue;




        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos]
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER
            )
            {
                found = 0;
                break;
            }
        }


        if ( found != 0 )
        {

            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }




            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue;
                    default :               break;
                }
            }




            new szKeyValue[INI_INTEGER_SIZE];
            format( szKeyValue, INI_INTEGER_SIZE, "%i", nKeyValue );




            new nValueLen = strlen(szKeyValue);


            if ( ( curFilePos + nValueLen ) >= INI_MAX_FILE_SIZE )
                return INI_TOO_LARGE_FILE;




            new fileValueStartPos = curFilePos;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS :  break;
                    default :               continue;
                }
            }


            new filePosOffset = nValueLen - ( /*текущ длина значения*/ curFilePos - fileValueStartPos );



            if ( _ini_nFileBusy[nFilePointer] != 0 )
                return INI_WRITE_ERROR;



            _ini_nFileBusy[nFilePointer] = 1;

            if ( filePosOffset != 0 )
            {
                if ( filePosOffset < 0 )
                {
                    for
                    (
                        ;
                        curFilePos < _ini_nFileSize[nFilePointer];
                        curFilePos++
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }
                else if ( filePosOffset > 0 )
                {
                    new fileValueEndPos = curFilePos;

                    for
                    (
                        curFilePos = _ini_nFileSize[nFilePointer] - 1;
                        curFilePos >= fileValueEndPos;
                        curFilePos--
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }


                for ( kPos++;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                    _ini_nDelimPos[nFilePointer][kPos] += filePosOffset;

                _ini_nFileSize[nFilePointer] += filePosOffset;
                _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0;
            }

            curFilePos = fileValueStartPos;
            for
            (
                new valuePos = 0;
                valuePos < nValueLen;
                curFilePos++, valuePos++
            )
                _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[valuePos];

            _ini_nFileChanged[nFilePointer]     = 1;
            _ini_nFileBusy[nFilePointer]        = 0;

            return INI_OK;

        }
    }








    new szKeyValue[INI_INTEGER_SIZE];
    format( szKeyValue, INI_INTEGER_SIZE, "%i", nKeyValue );




    new nValueLen = strlen(szKeyValue);


    if ( ( _ini_nFileSize[nFilePointer] + 5 + nKeyLen + nValueLen ) >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE;




    if ( _ini_nFileBusy[nFilePointer] != 0 )
        return INI_WRITE_ERROR;

    _ini_nFileBusy[nFilePointer] = 1;




    if
    (
            _ini_nFileSize[nFilePointer] > 0
        &&  _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] - 1 } != INI_STRING_DELIMITER
    )
    {

        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] }        = '\r';
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] + 1 }    = INI_STRING_DELIMITER;

        _ini_nFileSize[nFilePointer] += 2;
    }

    new curFilePos, strPos;

    for
    (
        curFilePos = _ini_nFileSize[nFilePointer], strPos = 0;
        strPos < nKeyLen;
        curFilePos++, strPos++
    )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyName[strPos];

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' ';

    _ini_nDelimPos[nFilePointer][ _ini_nKeysCount[nFilePointer] ]   = curFilePos;
    _ini_nKeysCount[nFilePointer]++;

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = INI_DELIMITER;
    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' ';


    for ( strPos = 0;  strPos < nValueLen;  curFilePos++, strPos++ )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[strPos];

    _ini_szFileContent[nFilePointer]{curFilePos}    = 0;
    _ini_nFileSize[nFilePointer]                    = curFilePos;
    _ini_nFileChanged[nFilePointer]                 = 1;
    _ini_nFileBusy[nFilePointer]                    = 0;

    return INI_OK;

}




/*
    Изменяет/добавляет в открытый INI файл указанный ключ и его дробное численное значение.

    ПОДРОБНЕЕ
        Парсер ищет в ОЗУ в контенте файла указанный ключ и изменяет его
        дробное значение на fKeyValue.

        Форматирование файла не меняется, если только указанное имя ключа
        не было найдено, тогда ключ и значение будут добавлены в конец файла.

        Имя ключа в файле может быть любой длины, а также может содержать
        любые символы, кроме 2 символов конца строки \r и \n. Если вы в качестве
        значения указываете очень большое/маленькое дробное число, вы должны
        хорошо знать и осознавать последствия.

    ПАРАМЕТРЫ:
        nFilePointer        ИД_открытого_файла, полученный от ini_openFile / ini_createFile
        szKeyName[]         имя ключа
        fKeyValue           дробное численное значение ключа

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_setFloat ( nFilePointer, szKeyName[], Float: fKeyValue )
{

    if
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT;




    new nKeyLen = strlen(szKeyName);

    if ( nKeyLen <= 0 )
        return INI_KEY_NOT_FOUND;




    for
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {

        found = 0;

        for
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1;
            curFilePos >= 0;
            curFilePos--
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
            {
                case INI_SPACE_CHAR :           continue;
                case INI_STRING_DELIMITER :     break;
                default :
                {
                    found = 1;
                    break;
                }
            }
        }


        if ( found != 1 ) continue;




        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos]
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER
            )
            {
                found = 0;
                break;
            }
        }


        if ( found != 0 )
        {

            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }




            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue;
                    default :               break;
                }
            }




            new szKeyValue[INI_FLOAT_SIZE];
            format( szKeyValue, INI_FLOAT_SIZE, "%f", fKeyValue );




            new nValueLen = strlen(szKeyValue);


            if ( ( curFilePos + nValueLen ) >= INI_MAX_FILE_SIZE )
                return INI_TOO_LARGE_FILE;




            new fileValueStartPos = curFilePos;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS :  break;
                    default :               continue;
                }
            }


            new filePosOffset = nValueLen - ( /*текущ длина значения*/ curFilePos - fileValueStartPos );



            if ( _ini_nFileBusy[nFilePointer] != 0 )
                return INI_WRITE_ERROR;



            _ini_nFileBusy[nFilePointer] = 1;

            if ( filePosOffset != 0 )
            {
                if ( filePosOffset < 0 )
                {
                    for
                    (
                        ;
                        curFilePos < _ini_nFileSize[nFilePointer];
                        curFilePos++
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }
                else if ( filePosOffset > 0 )
                {
                    new fileValueEndPos = curFilePos;

                    for
                    (
                        curFilePos = _ini_nFileSize[nFilePointer] - 1;
                        curFilePos >= fileValueEndPos;
                        curFilePos--
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }


                for ( kPos++;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                    _ini_nDelimPos[nFilePointer][kPos] += filePosOffset;

                _ini_nFileSize[nFilePointer] += filePosOffset;
                _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0;
            }

            curFilePos = fileValueStartPos;
            for
            (
                new valuePos = 0;
                valuePos < nValueLen;
                curFilePos++, valuePos++
            )
                _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[valuePos];

            _ini_nFileChanged[nFilePointer]     = 1;
            _ini_nFileBusy[nFilePointer]        = 0;

            return INI_OK;

        }
    }








    new szKeyValue[INI_FLOAT_SIZE];
    format( szKeyValue, INI_FLOAT_SIZE, "%f", fKeyValue );




    new nValueLen = strlen(szKeyValue);


    if ( ( _ini_nFileSize[nFilePointer] + 5 + nKeyLen + nValueLen ) >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE;




    if ( _ini_nFileBusy[nFilePointer] != 0 )
        return INI_WRITE_ERROR;

    _ini_nFileBusy[nFilePointer] = 1;




    if
    (
            _ini_nFileSize[nFilePointer] > 0
        &&  _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] - 1 } != INI_STRING_DELIMITER
    )
    {

        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] }        = '\r';
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] + 1 }    = INI_STRING_DELIMITER;

        _ini_nFileSize[nFilePointer] += 2;
    }

    new curFilePos, strPos;

    for
    (
        curFilePos = _ini_nFileSize[nFilePointer], strPos = 0;
        strPos < nKeyLen;
        curFilePos++, strPos++
    )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyName[strPos];

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' ';

    _ini_nDelimPos[nFilePointer][ _ini_nKeysCount[nFilePointer] ]   = curFilePos;
    _ini_nKeysCount[nFilePointer]++;

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = INI_DELIMITER;
    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' ';


    for ( strPos = 0;  strPos < nValueLen;  curFilePos++, strPos++ )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[strPos];

    _ini_szFileContent[nFilePointer]{curFilePos}    = 0;
    _ini_nFileSize[nFilePointer]                    = curFilePos;
    _ini_nFileChanged[nFilePointer]                 = 1;
    _ini_nFileBusy[nFilePointer]                    = 0;

    return INI_OK;

}




/*
    Удаляет из открытого INI файла указанный ключ и его значение.

    ПОДРОБНЕЕ
        Парсер ищет в ОЗУ в контенте файла указанный ключ и удаляет найденную
        пару ключ/значение.

        Имя ключа/значение в файле может быть любой длины,
        а также может содержать любые символы, кроме 2 символов конца строки \r и \n.

        Если эти символы есть в имени ключа или в значении,
        вы должны должны хорошо знать и осознавать последствия.

    ПАРАМЕТРЫ:
        nFilePointer        ИД_открытого_файла, полученный от ini_openFile / ini_createFile
        szKeyName[]         имя ключа

    ВЕРНЕТ:
        код ошибки < 0 или 0 при успехе
*/

stock ini_removeKey ( nFilePointer, szKeyName[] )
{

    if
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT;




    new nKeyLen = strlen(szKeyName);

    if ( nKeyLen <= 0 )
        return INI_KEY_NOT_FOUND;




    for
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {

        found = 0;

        for
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1;
            curFilePos >= 0;
            curFilePos--
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
            {
                case INI_SPACE_CHAR :           continue;
                case INI_STRING_DELIMITER :     break;
                default :
                {
                    found = 1;
                    break;
                }
            }
        }


        if ( found != 1 ) continue;




        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos]
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER
            )
            {
                found = 0;
                break;
            }
        }


        if ( found != 0 )
        {

            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }



            new keyStartPos = ( curFilePos <= 0 ) ? 0 : curFilePos + 1;




            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;


            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue;
                    default :               break;
                }
            }





            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_STRING_ENDS :  break;
                    default :               continue;
                }
            }


            new filePosOffset = keyStartPos - curFilePos;



            if ( _ini_nFileBusy[nFilePointer] != 0 )
                return INI_WRITE_ERROR;



            _ini_nFileBusy[nFilePointer] = 1;


            for ( ; curFilePos <= _ini_nFileSize[nFilePointer]; curFilePos++ )
                _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                    _ini_szFileContent[nFilePointer]{curFilePos};


            for ( ;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                _ini_nDelimPos[nFilePointer][kPos] = _ini_nDelimPos[nFilePointer][kPos + 1] + filePosOffset;

            _ini_nKeysCount[nFilePointer]--;
            _ini_nFileSize[nFilePointer] += filePosOffset;
            _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0;

            _ini_nFileChanged[nFilePointer]     = 1;
            _ini_nFileBusy[nFilePointer]        = 0;

            return INI_OK;

        }
    }








    return INI_KEY_NOT_FOUND;

}




/*
    Возвращает строку с описанием указанного кода ошибки на русском языке.

    ПОДРОБНЕЕ
        Если какая-то функция вам вернула не 0 (всё в порядке), а отрицательное
        значение, значит, имела место ошибка. Если вы хотите вывести в любой лог или
        в диалог человеческое описание этой ошибки, то передайте этой функции код
        ошибки и она вам вернет описание этой ошибки на русском языке.

        Описание ошибок довольно длинные и превышают размер в 128 символов,
        поэтому выводить эти описания в чате не рекомендуется!

    ПАРАМЕТРЫ:
        nErrorCode      код ошибки, полученный от любой функции

    ВЕРНЕТ:
        строку с человеческим описанием ошибки, под указанным кодом

    ПРИМЕР:
        new ini = ini_openFile("несуществующий файл"); // пытаемся открыть несуществующий файл

        if ( ini < 0 ) print( ini_getErrorInfo(ini) );
        else
        {
            new number, result = ini_getInteger( ini, "несуществующий ключ", number ); // пробуем получить значение несуществующего ключа

            if ( result < 0 ) print( ini_getErrorInfo(result) );

            ini_closeFile(ini);
        }
*/

stock ini_getErrorInfo ( nErrorCode )
{
    new error_ms[200] = "Ошибок нет";

    if ( nErrorCode >= 0 ) return error_ms;

    switch ( nErrorCode )
    {
        case INI_FILE_NOT_FOUND :     error_ms = "INI файл, указанный в `ini_openFile`, не существует, возможно, указан неверный путь к нему";
        case INI_FILE_ALREADY_EXIST : error_ms = "INI файл, указанный в `ini_createFile`, уже существует, укажите другое имя/путь к файлу";
        case INI_TOO_LARGE_FILE :     error_ms = "Невозможно добавить новый ключ в INI файл, т.к. размер INI файла превысит допустимый лимит в " #INI_MAX_FILE_SIZE " символ(ов), или будет превышен лимит в " #INI_MAX_KEYS_IN_FILE " ключей";
        case INI_WRONG_PATH_SIZE :    error_ms = "Длина пути к INI файлу, указанного в `ini_openFile` / `ini_createFile`, превышает лимит в " #INI_MAX_FILENAME_SIZE " символ(ов)";
        case INI_READ_ERROR :         error_ms = "Ошибка при чтении INI файла с диска, возможно, файл занят другим процессом";
        case INI_WRITE_ERROR :        error_ms = "Ошибка при записи содержимого INI файла на диск, возможно, файл занят другим процессом";
        case INI_NO_FREE_SLOT :       error_ms = "Лимит в " #INI_MAX_OPENED_FILES " одновременно открытых INI файлов исчерпан, поэтому открыть/создать еще 1 файл нельзя, пока не закрыт хоть 1 из открытых файлов";
        case INI_WRONG_SLOT :         error_ms = "Указан неверный ID открытого INI файла, возможно, при открытии INI файла произошла ошибка, поэтому вместо ID файла вы получили код ошибки";
        case INI_KEY_NOT_FOUND :      error_ms = "Указанный ключ не найден в открытом INI файле";
        case INI_WRONG_RETURN_SIZE :  error_ms = "При попытке чтения строкового значения из INI файла, последний параметр `nSizeOfReturn` в `ini_getString` оказался <= 0, укажите вручную значение > 0 для него";

        default:                      error_ms = "Неизвестная ошибка";
    }

    return error_ms;
}