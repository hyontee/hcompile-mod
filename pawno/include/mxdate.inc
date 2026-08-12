#define YEAR0           1900            /* the first n_year */
#define EPOCH_YR        1970            /* EPOCH = Jan 1 1970 00:00:00 */
#define SECS_DAY        (24 * 60 * 60)
#define LEAPYEAR(%0)    (!((%0) % 4) && (((%0) % 100) || !((%0) % 400)))
#define YEARSIZE(%0)    (LEAPYEAR(%0) ? 366 : 365)
#define TIME_MAX        cellmax

static const _ytab[2][12] = {
	{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
	{ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
};


stock date_to_timestamp
(
	n_year = 1970,	n_month  = 1,	n_day    = 1,
	n_hour =    0,	n_minute = 0,	n_second = 0
)
{
	switch ( n_month )
	{
		case  2 : n_day +=  31;	case  3 : n_day +=  59;	case  4 : n_day +=  90;
		case  5 : n_day += 120;	case  6 : n_day += 151;	case  7 : n_day += 181;
		case  8 : n_day += 212;	case  9 : n_day += 243;	case 10 : n_day += 273;
		case 11 : n_day += 304;	case 12 : n_day += 334;
	}

	return ( n_second + n_minute*60 + n_hour*3600 + (n_day - 1)*86400
		+ (n_year - 1970)*31557600 + ( n_year % 4 == 0 ? 21600 : 0 ) );
}


stock timestamp_to_date
(
	unix_timestamp = 0,

	& n_year = 1970,		& n_month  = 1,		& n_day    = 1,
	& n_hour =    0,		& n_minute = 0,		& n_second = 0
)
{
	n_year = unix_timestamp /  31557600;
	unix_timestamp -= n_year *  31557600;
	n_year += 1970;

	if ( n_year % 4 == 0 ) unix_timestamp -= 21600;

	n_day = unix_timestamp / 86400;

	switch ( n_day )
	{
		// в n_second будет временно хранится число месяца
		case    0..30 : { n_second = n_day;       n_month =  1; }
		case   31..58 : { n_second = n_day -  31; n_month =  2; }
		case   59..89 : { n_second = n_day -  59; n_month =  3; }
		case  90..119 : { n_second = n_day -  90; n_month =  4; }
		case 120..150 : { n_second = n_day - 120; n_month =  5; }
		case 151..180 : { n_second = n_day - 151; n_month =  6; }
		case 181..211 : { n_second = n_day - 181; n_month =  7; }
		case 212..242 : { n_second = n_day - 212; n_month =  8; }
		case 243..272 : { n_second = n_day - 243; n_month =  9; }
		case 273..303 : { n_second = n_day - 273; n_month = 10; }
		case 304..333 : { n_second = n_day - 304; n_month = 11; }
		case 334..366 : { n_second = n_day - 334; n_month = 12; }
	}

	unix_timestamp -= n_day * 86400;
	n_hour = unix_timestamp / 3600;

	unix_timestamp -= n_hour * 3600;
	n_minute = unix_timestamp / 60;

	unix_timestamp -= n_minute * 60;
	n_day = n_second + 1;
	n_second = unix_timestamp;
}

/*
	Заменяет в указанной строке условные обозначения времени на их значения
	в соответствии с указанным UNIX TIMESTAMP

	ПОДРОБНЕЕ
		UNIX TIMESTAMP это кол-во секунд со дня 01.01.1970, 00:00:00 до
		указанной в параметрах даты. Если он правильно указан, то в
		строке format все условные обозначения времени будут заменены
		на их значения в соответствии с указанным UNIX TIMESTAMP.

		Функция ищет:	Заменяет на:
		%yyyy			четырехзначное значение года
		%yy			двузначное значение года с ведущим нулём
		%m			значение месяца
		%mm			значение месяца с ведущим нулём
		%d			значение дня
		%dd			значение дня с ведущим нулём
		%h			значение часа
		%hh			значение часа с ведущим нулём
		%i			значение минуты
		%ii			значение минуты с ведущим нулём
		%s			значение секунды
		%ss			значение секунды с ведущим нулём

	ВЕРНЕТ
		строку с численными значениями даты вместо их псевдонимов
		размер строки = sizeOfOutput
*/
stock date ( const formatStr[] = "%dd.%mm.%yyyy, %hh:%ii:%ss", timestamp = 0 )
{
	// ------------
	const sizeOfOutput = 128; // размер возвращаемой строки

	new yyyy, mm, dd, h, m, s,
		pos, foundPos, searchStartPos, outStrLen,
		tmpNumStr[5], outStr[sizeOfOutput];

	//timestamp_to_date( timestamp+75600, yyyy,mm,dd, h,m,s ); // превратим штамп в дату
	gmtime(timestamp + 10800, yyyy, mm, dd, h, m, s);
	// ------------


	// -------------------
	// скопируем formatStr в outStr
	memcpy( outStr, formatStr, 0, (sizeOfOutput - 1)*4 );
	outStr[sizeOfOutput - 1] = 0; // правильный обрез строки в целях безопасности

	outStrLen = strlen(outStr);
	// -------------------


	// YEAR
	// -------------------
	searchStartPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%yyyy", false, searchStartPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 5, "%04d", yyyy ); // tmpNumStr = строкое значение yyyy

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 4; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		for ( pos += foundPos; pos < outStrLen; pos++ )
			outStr[pos] = outStr[pos + 1];

		outStr[pos] = 0; // правильный обрез строки
		outStrLen = strlen(outStr); // размер строки изменился
		searchStartPos = foundPos + 4; // позиция начала след. поиска += 4

		if ( searchStartPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%yyyy", false, searchStartPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// -------------------
	searchStartPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%yy", false, searchStartPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 5, "%04d", yyyy ); // tmpNumStr = строкое значение yyyy

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos + 2];

		// сдвиг назад на 1 дальнейшего контента строки
		for ( pos += foundPos; pos <= outStrLen; pos++ )
			outStr[pos] = outStr[pos + 1];

		outStr[pos] = 0; // правильный обрез строки
		outStrLen = strlen(outStr); // размер строки изменился
		searchStartPos = foundPos + 2; // позиция начала след. поиска изменилась

		if ( searchStartPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%yy", false, searchStartPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// MONTH
	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%mm", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%02d", mm ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		for ( pos += foundPos; pos <= outStrLen; pos++ )
			outStr[pos] = outStr[pos + 1];

		outStr[pos] = 0; // правильный обрез строки
		outStrLen = strlen(outStr); // размер строки изменился
		foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%mm", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%m", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%d", mm ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		if ( mm < 10 )
		{
			for ( pos += foundPos; pos <= outStrLen; pos++ )
				outStr[pos] = outStr[pos + 1];

			outStr[pos] = 0; // правильный обрез строки
			outStrLen = strlen(outStr); // размер строки изменился
			foundPos++; // позиция начала след. поиска изменилась
		}
		else
			foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%m", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// DAY
	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%dd", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%02d", dd ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		for ( pos += foundPos; pos <= outStrLen; pos++ )
			outStr[pos] = outStr[pos + 1];

		outStr[pos] = 0; // правильный обрез строки
		outStrLen = strlen(outStr); // размер строки изменился
		foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%dd", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%d", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%d", dd ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		if ( dd < 10 )
		{
			for ( pos += foundPos; pos <= outStrLen; pos++ )
				outStr[pos] = outStr[pos + 1];

			outStr[pos] = 0; // правильный обрез строки
			outStrLen = strlen(outStr); // размер строки изменился
			foundPos++; // позиция начала след. поиска изменилась
		}
		else
			foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%d", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// HOUR
	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%hh", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%02d", h ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		for ( pos += foundPos; pos <= outStrLen; pos++ )
			outStr[pos] = outStr[pos + 1];

		outStr[pos] = 0; // правильный обрез строки
		outStrLen = strlen(outStr); // размер строки изменился
		foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%hh", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%h", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%d", h ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		if ( h < 10 )
		{
			for ( pos += foundPos; pos <= outStrLen; pos++ )
				outStr[pos] = outStr[pos + 1];

			outStr[pos] = 0; // правильный обрез строки
			outStrLen = strlen(outStr); // размер строки изменился
			foundPos++; // позиция начала след. поиска изменилась
		}
		else
			foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%h", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// MINUTE
	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%ii", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%02d", m ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		for ( pos += foundPos; pos <= outStrLen; pos++ )
			outStr[pos] = outStr[pos + 1];

		outStr[pos] = 0; // правильный обрез строки
		outStrLen = strlen(outStr); // размер строки изменился
		foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%ii", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%i", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%d", m ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		if ( m < 10 )
		{
			for ( pos += foundPos; pos <= outStrLen; pos++ )
				outStr[pos] = outStr[pos + 1];

			outStr[pos] = 0; // правильный обрез строки
			outStrLen = strlen(outStr); // размер строки изменился
			foundPos++; // позиция начала след. поиска изменилась
		}
		else
			foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%i", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// SECOND
	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%ss", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%02d", s ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		for ( pos += foundPos; pos <= outStrLen; pos++ )
			outStr[pos] = outStr[pos + 1];

		outStr[pos] = 0; // правильный обрез строки
		outStrLen = strlen(outStr); // размер строки изменился
		foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%ss", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	// -------------------
	foundPos = 0; // поз начала поиска = 0
	foundPos = strfind( outStr, "%s", false, foundPos ); // ищем первую позицию

	while ( foundPos != -1 )
	{
		format( tmpNumStr, 3, "%d", s ); // tmpNumStr = строкое значение числа

		for ( pos = 0; tmpNumStr[pos] != 0 && pos < 2; pos++ ) // замена псевдонима на значение
			outStr[foundPos + pos] = tmpNumStr[pos];

		// сдвиг назад на 1 дальнейшего контента строки
		if ( s < 10 )
		{
			for ( pos += foundPos; pos <= outStrLen; pos++ )
				outStr[pos] = outStr[pos + 1];

			outStr[pos] = 0; // правильный обрез строки
			outStrLen = strlen(outStr); // размер строки изменился
			foundPos++; // позиция начала след. поиска изменилась
		}
		else
			foundPos += 2; // позиция начала след. поиска изменилась

		if ( foundPos < outStrLen ) // если поз начала поиска меньше длины строки
			foundPos = strfind( outStr, "%s", false, foundPos ); // продолжим поиск
		else break; // иначе - остановим поиск и замену
	}
	// -------------------


	return outStr;
}

stock gmtime(timestamp, &n_year = EPOCH_YR, &n_month = 1, &n_day = 1, &n_hour = 0, &n_minute = 0, &n_second = 0)
{
	static dayclock;

	n_year = EPOCH_YR;
	dayclock = timestamp % SECS_DAY;
	n_day = timestamp / SECS_DAY;

	n_second = dayclock % 60;
	n_minute = (dayclock % 3600) / 60;
	n_hour = dayclock / 3600;

	while (n_day >= YEARSIZE(n_year)) {
		n_day -= YEARSIZE(n_year);
		n_year++;
	}

	n_month = 0;

	while (n_day >= _ytab[LEAPYEAR(n_year)][n_month]) {
		n_day -= _ytab[LEAPYEAR(n_year)][n_month];
		n_month++;
	}

	n_day++;
	n_month++;
}