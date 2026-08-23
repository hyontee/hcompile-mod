#define DIALOG_CALENDAR 5000

new Calendar_Month = 1;
new Calendar_Year  = 2025;

// Названия месяцев
new MonthNames[12][] = {
    "Январь","Февраль","Март","Апрель","Май","Июнь",
    "Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"
};
stock GetDaysInMonth(month, year)
{
    switch(month)
    {
        case 1: return 31;
        case 2:
        {
            if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
                return 29;
            return 28;
        }
        case 3: return 31;
        case 4: return 30;
        case 5: return 31;
        case 6: return 30;
        case 7: return 31;
        case 8: return 31;
        case 9: return 30;
        case 10: return 31;
        case 11: return 30;
        case 12: return 31;
    }
    return 30;
}
stock ShowCalendar(playerid)
{
    new text[1024];
    new days = GetDaysInMonth(Calendar_Month, Calendar_Year);

    format(text, sizeof(text),
        "{FFFFFF}%s %d\n\n",
        MonthNames[Calendar_Month - 1], Calendar_Year
    );

    // Формируем список дней
    for(new i = 1; i <= days; i++)
    {
        new line[10];
        format(line, sizeof(line), "%d\n", i);
        strcat(text, line);
    }

    ShowPlayerDialog(playerid, DIALOG_CALENDAR, DIALOG_STYLE_LIST,
        "Календарь", text,
        "Выбрать", "← →");
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_CALENDAR)
    {
        if(!response)
        {
            // Левая кнопка ← — предыдущий месяц
            Calendar_Month--;
            if(Calendar_Month < 1)
            {
                Calendar_Month = 12;
                Calendar_Year--;
            }
            ShowCalendar(playerid);
            return 1;
        }
        else
        {
            // Правая кнопка → — следующий месяц
            if(!strcmp(inputtext, ""))
            {
                Calendar_Month++;
                if(Calendar_Month > 12)
                {
                    Calendar_Month = 1;
                    Calendar_Year++;
                }
                ShowCalendar(playerid);
                return 1;
            }

            // Игрок выбрал день
            new chosen_day = strval(inputtext);

            new msg[128];
            format(msg, sizeof msg,
                "Вы выбрали дату: %d.%d.%d",
                chosen_day, Calendar_Month, Calendar_Year
            );
            SendClientMessage(playerid, -1, msg);
        }
        return 1;
    }
    return 0;
}
CMD: calendarguitest(playerid)
{
    ShowCalendar(playerid);
    return 1;
}

