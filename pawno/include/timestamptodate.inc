/*
-               Timestamp To Date converter	            -
-                    Made by Jochemd                    -
-          http://forum.sa-mp.com/member.php?u=580      -

native TimestampToDate(Timestamp, &year, &month, &day, &hour, &minute, &second, HourGMT, MinuteGMT = 0);
native DateToTimestamp(str[11]);
*/

#if defined _timestamp_included
  #endinput
#endif
#define _timestamp_included


//#include <a_samp>
#if !defined SSCANF
	#include <sscanf2>
#endif

#define SPLITTER .

new MonthTimes[12][4] = 
{
	{ 31, 31, 2678400, 2678400 },
	{ 28, 29, 2419200, 2505600 },
	{ 31, 31, 2678400, 2678400 },
	{ 30, 30, 2592000, 2592000 },
	{ 31, 31, 2678400, 2678400 },
	{ 30, 30, 2592000, 2592000 },
	{ 31, 31, 2678400, 2678400 },
	{ 31, 31, 2678400, 2678400 },
	{ 30, 30, 2592000, 2592000 },
	{ 31, 31, 2678400, 2678400 },
	{ 30, 30, 2592000, 2592000 },
	{ 31, 31, 2678400, 2678400 }
};

stock IsLeapYear(yearx)
{
	if(yearx % 4 == 0) return 1;
	else return 0;
}

stock TimestampToDate(Timestamp, &yearx, &monthx, &dayx, &hour_, &minute_, &second_, HourGMT, MinuteGMT = 0)
{
	new tmp = 2;
	yearx = 1970;
	monthx = 1;
	Timestamp -= 172800; // (172800-3600) Delete two days from the current timestamp. This is necessary, because the timestamp retrieved using gettime() includes two too many days. 14400 те что прибавили
	for(;;)
	{
		if(Timestamp >= 31536000)
		{
			yearx ++;
			Timestamp -= 31536000;
			tmp ++;
			if(tmp == 4)
			{
				if(Timestamp >= 31622400)
				{
					tmp = 0;
					yearx ++;
					Timestamp -= 31622400;
				}
				else break;
			}
		}
		else break;
	}		
	for(new i = 0; i < 12; i ++)
	{
		if(Timestamp >= MonthTimes[i][2 + IsLeapYear(yearx)])
		{
			monthx ++;
			Timestamp -= MonthTimes[i][2 + IsLeapYear(yearx)];
		}
		else break;
	}
	dayx = 1 + (Timestamp / 86400);
	Timestamp %= 86400;
	hour_ = HourGMT + (Timestamp / 3600);
	Timestamp %= 3600;
	minute_ = MinuteGMT + (Timestamp / 60);
	second_ = (Timestamp % 60);
	if(minute_ > 59)
	{
		minute_ = 0;
		hour_ ++;
	}
	if(hour_ > 23)
	{
		hour_ -= 24;
		dayx ++;
	}	
	if(dayx > MonthTimes[monthx-1][IsLeapYear(yearx)])
	{
		dayx = 1;
		monthx ++;
	}
	if(monthx > 12)
	{
		monthx = 1;
		yearx ++;
	}
	return 1;
}

stock DateToTimestamp(str[11])
{
	new date[3]; // date[0] = day		date[1] = month			date[2] = year
	if(!sscanf(str,"p<"#SPLITTER">ddd",date[0],date[1],date[2]))
	{
		new total = 0, tmp = 0;
		total += date[0] * 86400;
		if(date[1] == 2 && date[0] < 29) tmp = ((date[2] - 1968) / 4 - 2);
		else tmp = ((date[2] - 1968) / 4 - 1);
		total += tmp * 31622400;
		total += (date[2] - 1970 - tmp) * 31536000;
		for(new i = 1; i < date[1]; i ++) total += MonthTimes[i][0 + IsLeapYear(date[2])] * 86400;
		return total;
	}
	else return -1;
}