 //Автор: Welsi Тг канал:t.me/welsistudio

new level_hangman[7][74] =
{
    {
       "\t\t+----+\n\
        \t\t|\t\t\t\t|\n\
        \t\t\t\t\t\t|\n\
        \t\t\t\t\t\t|\n\
        \t\t\t\t\t\t|\n\
        ========="
    },   
    {
        "\t\t+----+\n\
         \t\t|\t\t\t\t|\n\
         \t\tO\t\t\t|\n\
         \t\t\t\t\t\t|\n\
         \t\t\t\t\t\t|\n\
        ========="
    },   
    {
        "\t\t+----+\n\
         \t\t|\t\t\t\t|\n\
         \t\tO\t\t\t|\n\
         \t\t|\t\t\t\t|\n\
         \t\t\t\t\t\t|\n\
        ========="
    },   
    {
        "\t\t+----+\n\
         \t\t|\t\t\t\t|\n\
         \t\tO\t\t\t|\n\
         \t\t/|\t\t\t\t|\n\
         \t\t\t\t\t\t|\n\
        ========="
    },   
    {
        "\t\t+----+\n\
         \t\t|\t\t\t\t|\n\
         \t\tO\t\t\t|\n\
         \t\t/|\\\t\t\t|\n\
         \t\t\t\t\t\t|\n\
        ========="
    },    //Автор: Welsi Тг канал:t.me/welsistudio
    {
        "\t\t+----+\n\
         \t\t|\t\t\t\t|\n\
         \t\tO\t\t\t|\n\
         \t\t/|\\\t\t\t|\n\
         \t\t/\t\t\t\t|\n\
        ========="
    },     
    {
        "\t\t+----+\n\
         \t\t|\t\t\t\t|\n\
         \t\tO\t\t\t|\n\
         \t\t/|\\\t\t\t|\n\
         \t\t/ \\\t\t\t|\n\
        ========="
    }
};

#define MAX_LETTER_HANGMAN  15



new hangman_words[100][MAX_LETTER_HANGMAN] =
{
    "ВИСЕЛИЦА",                //0  
    "ПРОГРАММИСТ",            //1  
    "ЗЕФИР",                  //2  
    "КОВБОЙ",                 //3  
    "МАШИНА",                 //4  
    "ВЕЛОСИПЕД",              //5  
    "ЧЕЛОВЕК",                //6  
    "ЛЯГУШКА",                //7  
    "КОМПЬЮТЕР",              //8  
    "ЭЛЕКТРИЧЕСТВО",          //9  
    "ЛЕВ",                    //10  
    "ПЕРЧАТКА",               //11  
    "ДОМ",                    //12  
    "КОТ",                    //13  
    "БИБЛИОТЕКАРЬ",           //14  
    "БАНАН",                  //15  
    "АВГУСТ",                 //16  
    "ИЮЛЬ",                   //17  
    "ИЮНЬ",                   //18  
    "МАРТ",                   //19  
    "ДЕКАБРЬ",                //20  
    "СЕНТЯБРЬ",               //21  
    "ПАРАЛЛЕЛЕПИПЕД",         //22  
    "ШКОЛА",                  //23  
    "АПРЕЛЬ",                 //24  
    "ШУТКА",                  //25  
    "ГРЕЧКА",                 //26  
    "СВЕЧКА",                 //27  
    "ОВЦА",                   //28  
    "СОБАКА",                 //29  
    "ДУРАК",                  //30  
    "АЗБУКА",                 //31  
    "БРЮКИ",                  //32  
    "ВЪЕЗД",                  //33  
    "ГРОЗДЬ",                 //34  
    "ДЖИНСЫ",                 //35  
    "ЁЛКА",                   //36  
    "ЖЮРИ",                   //37  
    "ЗЫБКИЙ",                 //38  
    "ИСКЛЮЧИТЬ",              //39  
    "ЙОГУРТ",                 //40  
    "КРЮЧОК",                 //41  
    "ЛЁГКИЙ",                 //42  
    "МЁД",                    //43  
    "НЫРЯТЬ",                 //44  
    "ОПЯТА",                  //45  
    "ПАЛЬТО",                 //46  
    "РЕЗЬБА",                 //47  
    "ТЩЕТНО",                 //48  
    "ХРЮШКА",                 //49  
    "СОН",                    //50  
    "ЛИС",                    //51  
    "МИР",                    //52  
    "БОК",                    //53  
    "ДОМ",                    //54  
    "ГОД",                    //55  
    "ЁЖ",                     //56  
    "ЛУК",                    //57  
    "ЗИМА",                   //58  
    "ЛЕТО",                   //59  
    "РЕКА",                   //60  
    "САД",                    //61  
    "ТЕНЬ",                   //62  
    "ХЛЕБ",                   //63  
    "ЦВЕТ",                   //64  
    "ЧАЙ",                    //65  
    "ШАР",                    //66  
    "ЩИТ",                    //67  
    "БАНКА",                  //68  
    "ВЕТЕР",                  //69  
    "ГРОЗА",                  //70  
    "ДОЖДЬ",                  //71  
    "ЕНОТ",                   //72  
    "ЖИЗНЬ",                  //73  
    "ЗВЕЗДА",                 //74  
    "ИГЛА",                   //75  
    "ЯБЛОКО",                 //76  
    "ФОНТАН",                 //77  
    "УТЮГ",                   //78  
    "ТЕЛЕФОН",                //79  
    "СНЕГ",                   //80  
    "РЮКЗАК",                 //81  
    "ПОДЪЕЗД",                //82  
    "ОГУРЕЦ",                 //83  
    "НОЖНИЦЫ",                //84  
    "МОЛОТОК",                //85  
    "ЛАМПА",                  //86  
    "КЕНГУРУ",                //87  
    "ИНДЕЙКА",                //88  
    "ЗОНТИК",                 //89  
    "ЖЕЛЕЗО",                 //90  
    "ДИВАН",                  //91  
    "ГИТАРА",                 //92  
    "ВЕРБЛЮД",                //93  
    "БУКЕТ",                  //94  
    "АИСТ",                   //95  
    "ЮЛА",                    //96  
    "ЭКРАН",                  //97  
    "ЩЕНОК",                  //98  
    "ЯЩЕРИЦА"                 //99  
};
 //Автор: Welsi Тг канал:t.me/welsistudio
enum P_hangman
{
    PH_Word, //Автор: Welsi Тг канал:t.me/welsistudio
    PH_Count_Error,
    PH_Count_Use[33],
}

new player_hangman[MAX_PLAYERS][P_hangman];


stock IsLetterHit(playerid, letter[2] = "")
{
    if(player_hangman[playerid][PH_Word] == -1) return 0;

    new word = player_hangman[playerid][PH_Word];

    for(new i; i < MAX_LETTER_HANGMAN;i++)
    {
        if(hangman_words[word][i] = '\0') return 0;
        else if(hangman_words[word][i] != letter[0]) return 0;
    }
    return 1;
}

stock ClearHangman(playerid) for(new i; i < 33; i ++ ) player_hangman[playerid][PH_Count_Use][i] = '_';


stock WordHangman(playerid)
{
    new word = player_hangman[playerid][PH_Word], word_edit[MAX_LETTER_HANGMAN];

    for(new e; e < MAX_LETTER_HANGMAN;e++) { if(hangman_words[word][e] == '\0') break; word_edit[e] = '_'; }
 //Автор: Welsi Тг канал:t.me/welsistudio
    for(new i; i < 33;i++)
    {
        if(player_hangman[playerid][PH_Count_Use][i] == '_') continue;

        for(new e; e < MAX_LETTER_HANGMAN;e++)
        {
            if(hangman_words[word][e] == '\0') break;
            else if(hangman_words[word][e] == player_hangman[playerid][PH_Count_Use][i]) word_edit[e] = player_hangman[playerid][PH_Count_Use][i];
        }
    }

    return word_edit;
}


cmd:hangman(playerid)
{
    ShowPlayerDialog(
        playerid, 6345, DIALOG_STYLE_MSGBOX,
        "Виселица - Информация",
        "{FFFF00}\"Виселица\"{FFFFFF} — классическая словесная игра, в которой игрок должен угадать загаданное слово по\n"\
        "буквам, прежде чем будет нарисована полная виселица с человечком.\n\n"\
        "{FFFF00}Правила игры{FFFFFF}\n"\
        "Цель: Угадать слово, называя буквы, до того как {FFFF00}\"человечек\"{FFFFFF} будет повешен.\n\n"\
        "Ход игры:\n\n"\
        "Компьютер загадывает слово и показывает количество букв (например, _ _ _ _ _).\n\n"\
        "Игрок пишет буквы по одной.\n"\
        "Если буква есть в слове, она открывается (например, {FFFF00}С _ _ _ _{FFFFFF} для слова {FFFF00}\"СЛОВО\"{FFFFFF}).\n\n"\
        "Если буквы нет, к виселице добавляется часть тела (голова, туловище, руки, ноги).\n\n"\
        "{E32626}Поражение{FFFFFF}: Если человечек полностью нарисован (за 6 ошибок), игрок проигрывает.\n\n"\
        "{59C32F}Победа{FFFFFF}: Если слово угадано до завершения рисунка — победа!",
        "Играть", "Выйти"
    );

    return 1;
}

stock DialogHangman(playerid)
{
    new string[324], word_text[67] ;

    for(new i, word; i < 33; i ++) 
    {
        if(player_hangman[playerid][PH_Count_Use][i] == '_' && !i)
        {
            format(word_text, sizeof word_text, "Нет");
            break;
        } 
        else if(player_hangman[playerid][PH_Count_Use][i] == '_') break;
        else if(player_hangman[playerid][PH_Count_Use][i] != '_')
        {
            if(!i) format(word_text, sizeof word_text, "%c", player_hangman[playerid][PH_Count_Use][i]);
            else format(word_text, sizeof word_text, "%s,%c", word_text, player_hangman[playerid][PH_Count_Use][i]);
        }

       /* else if(i < 33 && player_hangman[playerid][PH_Count_Use][i] != '_' && player_hangman[playerid][PH_Count_Use][i+1] == '_')
        {
            format(word_edit, sizeof word_edit, "%s,%s", word_edit) 
        }*/
    }


    new errors = player_hangman[playerid][PH_Count_Error], style, bool:win, word = player_hangman[playerid][PH_Word], 
    word_edit[MAX_LETTER_HANGMAN*2];

    format(word_edit, sizeof word_edit,  WordHangman(playerid));

    for(new i; i < MAX_LETTER_HANGMAN;i ++)
    {
        if(word_edit[i] == '_') { win = false ; break;}
        else if(i < MAX_LETTER_HANGMAN && hangman_words[word][i+1] == '\0' && word_edit[i] != '_') { win = true ; break;}
    }

    new copy[MAX_LETTER_HANGMAN*2], end;
    format(copy, sizeof copy, word_edit);

    for(new i; i < MAX_LETTER_HANGMAN;i++) if(word_edit[i] == '\0') { end = i*2; break; }

    for(new i, e = MAX_LETTER_HANGMAN*2; i < e;i ++)
    {
        //if(i == end) break;
        if(word_edit[i] == '\0') break;

        if(!(i % 2))
        {
            word_edit[i+1] = word_edit[i];
            word_edit[i] = ' ';
            word_edit[i+2] = copy[i / 2 + 1];
        } //Автор: Welsi Тг канал:t.me/welsistudio
    }

    if(errors == 6 || win) 
    {
        new text_result[54];

        if(win) {
            format(text_result, sizeof text_result, "Вы {59C32F}победили!{FFFFFF} Вы отгадали слово");

            //По дефолту выдаётся 5000 руб и 0 донат-руб.
            new money = 5000, donate = 0; //Меняете значение на своё 
            //Если хотите чтобы выдавалось 5 донат-рублей ставьте donate = 5;
            //Если хотите чтобы выдавалось 10000 руб ставьте money = 10000;
            //Ну поняли крч. Какое значение поставите после `=` то и будет
             //Автор: Welsi Тг канал:t.me/welsistudio
            if(donate) GivePlayerDonateRub(playerid, donate, "Виселица");
            if(money) GivePlayerMoneyEx(playerid, money, "Виселица");
        }
        else format(text_result, sizeof text_result, "Вы {E32626}проиграли!{FFFFFF} Достигнут лимит ошибок");

        format
        (
            string, sizeof string, 
            "%s\n\
            %s\n\n\
            %s%s\n\
            {FFFFFF}Количество ошибок: %d\n\
            \n\
            Список предложенных букв:%s\n\
            Нажмите \"Далее\" чтобы получить новое слово",
            text_result, level_hangman[errors], win ? ("{59C32F}") : ("{E32626}"), hangman_words[word], errors,
            word_text
        );
 //Автор: Welsi Тг канал:t.me/welsistudio
        player_hangman[playerid][PH_Word] = -1;
        style = DIALOG_STYLE_MSGBOX;
    }
    else {
        format
        (
            string, sizeof string, 
            "\n\
            %s\n\n\
            %s\n\
            Количество ошибок: %d\n\
            \n\
            Список предложенных букв:%s\n\n\
            Напишите снизу предложенную букву в слове",
            level_hangman[errors], word_edit, errors,
            word_text
        );
 //Автор: Welsi Тг канал:t.me/welsistudio
        style = DIALOG_STYLE_INPUT;
    }
    ShowPlayerDialog(playerid, 6346, style, "Виселица", string, "Далее", "Закончить");
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) //Автор: Welsi Тг канал:t.me/welsistudio
{
    if(dialogid == 6345)
    {
        if(response)
        {
            ClearHangman(playerid);
            player_hangman[playerid][PH_Count_Error] = 0;
            player_hangman[playerid][PH_Word] = -1;

            new word = random(sizeof hangman_words);

            player_hangman[playerid][PH_Word] = word;

            DialogHangman(playerid);
        }
    }
    if(dialogid == 6346)
    {
        if(response)
        {
            if(player_hangman[playerid][PH_Word] == -1) { 
            ClearHangman(playerid);
            player_hangman[playerid][PH_Count_Error] = 0;
            player_hangman[playerid][PH_Word] = -1;

            new word = random(sizeof hangman_words);

            player_hangman[playerid][PH_Word] = word;

            DialogHangman(playerid);
            
            return 1; }

            new letter[2]; //Автор: Welsi Тг канал:t.me/welsistudio

            if(strlen(inputtext) > 1 ) { DialogHangman(playerid); SendClientMessage(playerid, -1, "Вы не правильно ввели букву (Например: Б)"); return 0;}

            letter[0] = inputtext[0];

            switch(letter[0]) { case 'а'..'я', 'ё': Registr(letter[0]); }

            for(new i; i < 33; i++) if(player_hangman[playerid][PH_Count_Use][i] == letter[0]) { DialogHangman(playerid); SendClientMessage(playerid, -1, "Данная буква уже была"); return 1;}


            switch(letter[0])
            {
                case 'А'..'Я', 'Ё':{
                    
                    new word = player_hangman[playerid][PH_Word], bool:error;

                    for(new e; e < 33; e++){
                        if(player_hangman[playerid][PH_Count_Use][e] == '_'){
                            player_hangman[playerid][PH_Count_Use][e] = letter[0];

                            break;
                        }
                    }

                    for(new i; i < MAX_LETTER_HANGMAN;i++)
                    {
                        if(hangman_words[word][i] == '\0') { error = true; break; }
                        else if(hangman_words[word][i] != letter[0]) continue;

                        error = false;
                        break;
                    } //Автор: Welsi Тг канал:t.me/welsistudio

                    if(error) player_hangman[playerid][PH_Count_Error]++;

                    DialogHangman(playerid);
                }
                default:{ DialogHangman(playerid); SendClientMessage(playerid, -1, "Вы не правильно ввели букву (Например: Б)");}
            }
        }
    }   
    #if defined hangman_OnDialogResponse
    return hangman_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse hangman_OnDialogResponse
#if defined hangman_OnDialogResponse
forward hangman_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock Registr(string[])
{
    new length  = strlen(string); 

    for(new i; i < length; i++) switch(string[i]) {
           
            case 'й': string[i] = 'Й';
            case 'ц': string[i] = 'Ц';
            case 'у': string[i] = 'У';
            case 'к': string[i] = 'К';
            case 'е': string[i] = 'Е';
            case 'ё': string[i] = 'Ё';
            case 'н': string[i] = 'Н';
            case 'г': string[i] = 'Г';
            case 'ш': string[i] = 'Ш';
            case 'щ': string[i] = 'Щ';
            case 'з': string[i] = 'З';
            case 'х': string[i] = 'Х';
            case 'ъ': string[i] = 'Ъ';
            case 'ф': string[i] = 'Ф';
            case 'ы': string[i] = 'Ы';
            case 'в': string[i] = 'В';
            case 'а': string[i] = 'А';
            case 'п': string[i] = 'П';
            case 'р': string[i] = 'Р';
            case 'о': string[i] = 'О';
            case 'л': string[i] = 'Л';
            case 'д': string[i] = 'Д';
            case 'ж': string[i] = 'Ж';
            case 'э': string[i] = 'Э';
            case 'я': string[i] = 'Я';
            case 'ч': string[i] = 'Ч';
            case 'с': string[i] = 'С';
            case 'м': string[i] = 'М';
            case 'и': string[i] = 'И';
            case 'т': string[i] = 'Т';
            case 'ь': string[i] = 'Ь';
            case 'б': string[i] = 'Б';
            case 'ю': string[i] = 'Ю';
    }
    return 1; 
}

 //Автор: Welsi Тг канал:t.me/welsistudio