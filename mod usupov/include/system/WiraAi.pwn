#pragma warning disable 224

#define MAX_GPT_RESPONSE 512
#define MAX_USER_INPUT 256

enum { STYLE_LOGIC = 0, STYLE_IRONIC, STYLE_SAD, STYLE_FUNNY }

new last_Wira_response[MAX_PLAYERS][MAX_GPT_RESPONSE];

new part_Hello_Used[20];
new part_Bye_Used[14];
new part_Who_Used[8];
new part_Status_Used[8];
new part_Support_Used[12];
new part_Praise_Used[13];
new part_Complaints_Used[10];
new part_Memes_Used[26];
new part_Time_Used[4];
new part_WiraInfo_Used[12];
new part_Commands_Used[4];
new part_Chat_Used[4];
new part_Friendship_Used[6];
new part_GameInfo_Used[9];
new part_QnA_Used[8];
new part_Creator_Used[4];
new part_Impossible_Used[8];
new part_Noise_Used[8];
new part_Jokes_Used[50];
new gpt_Aggressive_Used[22];
new gpt_BypassResponse_Used[4];
new gpt_HackResponse_Used[4];
new gpt_ExploitResponse_Used[4];
new gpt_IllegalResponse_Used[4];
new part_Philosophy_Used[15];
new part_Science_Used[12];
new part_History_Used[10];
new part_Entertainment_Used[18];
new part_Technology_Used[14];
new part_Sports_Used[8];
new part_Health_Used[10];
new part_Food_Used[8];
new part_Weather_Used[6];
new part_Relationships_Used[12];
new part_Education_Used[10];
new part_Career_Used[8];
new part_Travel_Used[8];
new part_Art_Used[8];
new part_Music_Used[10];
new part_Movies_Used[10];
new part_Games_Used[12];
new part_News_Used[8];
new part_Politics_Used[6];
new part_Economy_Used[6];
new part_Society_Used[8];
new part_Psychology_Used[10];
new gpt_Unknown_Used[20];

stock GetUnusedResponseIndex(usage_tracker[], tracker_size)
{
    new i = 0, unused_count = 0;

    for(i = 0; i < tracker_size; i++) {
        if(usage_tracker[i] == 0) unused_count++;
    }

    if(unused_count == 0) {
        for(i = 0; i < tracker_size; i++) {
            usage_tracker[i] = 0;
        }
        unused_count = tracker_size;
    }

    new target_n = random(unused_count);
    new current_n = 0;
    new selected_index = -1;

    for(i = 0; i < tracker_size; i++) {
        if(usage_tracker[i] == 0) {
            if(current_n == target_n) {
                selected_index = i;
                break;
            }
            current_n++;
        }
    }

    if(selected_index != -1) {
        usage_tracker[selected_index] = 1;
        return selected_index;
    }

    return 0;
}

new const Popular_Jokes[][] = {
    "Анекдот: Идёт как-то медведь по лесу, видит — машина горит. Сел в неё и сгорел.",
    "Анекдот: — Доктор, я жить буду?\n— А смысл?",
    "Анекдот: Объявление: 'Установлю Windows 7 с полным пакетом драйверов. Результат — 100%. Ваш компьютер будет просто летать!'\nСноска мелким шрифтом: 'Вниз с 9-го этажа'.",
    "Анекдот: Жена говорит мужу:\n— У меня в голове только ты да семья!\nМуж думает: 'Ну и пустота же у тебя в голове...'",
    "Анекдот: — Алло, это справочная?\n— Да.\n— Скажите, пожалуйста, а куда я звоню?",
    "Анекдот: Студент-археолог пишет домой родителям: 'Раскопки идут медленно, но мы уже начинаем кое-что подозревать'.",
    "Анекдот: — Почему вы в графе 'Пол' написали 'Не важно'?!\n— Ну а что важно-то? Зарплата!",
    "Анекдот: На собеседовании:\n— Какое ваше главное достоинство?\n— Я идеально вписываюсь в коллектив.\n— Докажите.\n— Ненавижу начальника еще до знакомства с ним.",
    "Анекдот: На необитаемом острове нашли двух робинзонов. Одного звали Федя, а второго... тоже Федя. Потому что как еще назвать человека, который съел все книги, кроме одной?",
    "Анекдот: Встречаются два друга. Один говорит:\n— Представляешь, вчера ехал в лифте, а там зеркало. Смотрю — я, смотрю — опять я... Испугался, на седьмом этаже выбежал.",
    "Анекдот: — У вас есть клубника?\n— Нет.\n— А с клубникой есть?",
    "Анекдот: Объявление в поликлинике: 'Кто здесь сидит без очереди, тот и крайний'.",
    "Анекдот: Открыл приложение «Здоровье», чтобы посмотреть, сколько шагов прошел. А оно мне: «Лучше открой холодильник и посмотри, сколько раз ты туда сходил».",
    "Анекдот: Мое психическое здоровье — это я и нейросеть, которая пытается угадать, что я имел в виду, когда писал запрос из трех слов.",
    "Анекдот: Сижу, смотрю TikTok. Рекомендации: «5 способов побороть прокрастинацию». Я подумал: «Гениально! Обязательно посмотрю... как-нибудь потом».",
    "Анекдот: Проснулся, посмотрел в зеркало и такой: «Ну пиздец, опять этот тип».",
    "Анекдот: — Почему не отвечал?\n— Телефон сел.\n— А зарядка?\n— Да она так же заебалась, как и я.",
    "Анекдот: Иногда хочется всё бросить… и я бросаю. Чаще всего — ответственность.",
    "Анекдот: Умная колонка зависла, когда я спросил: «Что мне делать с жизнью?» — блядь, мы одинаковые.",
    "Анекдот: — Ты спортом занимаешься?\n— Да, бегаю нахуй от любых задач.",
    "Анекдот: Мой будильник орёт так, будто я ему три кредита должен.",
    "Анекдот: Хотел начать новую жизнь, но какой-то мудак забыл выключить утро.",
    "Анекдот: Иногда думаю: я ленивый? А потом думаю: да хуй знает, разбираться лень.",
    "Анекдот: — Почему не спишь?\n— Мысли.\n— Какие?\n— Да хуета всякая, но серьёзно.",
    "Анекдот: Купил фитнес-браслет — теперь у меня есть официальное устройство, которое мной разочаровано.",
    "Анекдот: Телефон завис, пока я смотрел мемы. Даже он охуел от моего контента.",
    "Анекдот: Пошёл за хлебом. Вернулся с энергетиком, чипсами и осознанием, что я долбоёб.",
    "Анекдот: Стал взрослым: меня расстраивает, когда сломался пылесос, а не жизнь пошла по пизде.",
    "Анекдот: Мой холодильник — лучший психолог. Хожу к нему каждые 15 минут жаловаться.",
    "Анекдот: Думаю, что уже всё видел… потом открываю TikTok — и опять охуеваю.",
    "Анекдот: Поставил цели на год. Мы с ними друг на друга смотрим, как два идиота.",
    "Анекдот: Если бы прокрастинация была спортом — я бы уже был ёбаным чемпионом.",
    "Анекдот: «Будь собой» — говорят люди, которые меня, блядь, вообще не знают.",
    "Анекдот: Когда жизнь даёт лимоны, у меня лишь один вопрос: нахуя?",
    "Анекдот: В 3 ночи решил быть продуктивным. Через пять минут понял, что я ебанутый.",
    "Анекдот: Интернет научил меня двум вещам: искать инфу и отправлять всё нахуй.",
    "Анекдот: Мой уровень активности: 1) перевернулся. 2) посмотрел мем. 3) заебался.",
    "Анекдот: — Надо спать!\n— Надо, блядь…\n— А давай вспомним все стыдные моменты за жизнь?\n— …Сука.",
    "Анекдот: Поколение Z не ругается — мы просто говорим «бляяя» и выражаем весь спектр эмоций.",
    "Анекдот: Пытаюсь быть позитивным, но жизнь такая: «Держи ещё хуйню сверху, дружочек»."
};

new const insultWords[][] = {
    "дурак","сука","урод","тупой","блять","долбоеб","идиот","мразь","пидор","уебан",
    "мудак","дебил","придурок","скотина","сволочь","тварь","хуй","говно","падла","ублюдок",
    "дура","тупая","идиотка","коза","ненормальная","бесишь","отстань","заткнись","уйди",
    "ненавижу","убью","сломаю","отстой","пошла","катись","мусор","отброс","гнилой",
    "шлюха","блядь","пизда","еблан","петух","чмо","лох","козел","свинья","собака",
    "подлец","мерзавец","негодяй","трус","даун","псих","больной","конченный","хуйло",
    "пиздобол","отвратительно","гадко","охуел","поехавший","ебнутый","пиздец","нахрен",
    "отъебись","отвали","сдохни","исчезни","заебал","достал","надоел","зануда",
    "грязный","паршивый","никчемный","бестолочь","тормоз","тупица"
};

new const swearWords[][] = {
    "блять","сука","нахуй","ебать","хер","пиздец","бля","еба","пизда","хуй","гондон",
    "мудила","жопа","залупа","блядь","охуенно","охуеть","похуй","ебал","выебан",
    "ебись","уебище","пиздюк","пиздрить","пиздёж","ебля","выебка","подъеб",
    "разъеб","съебись","заебись","заебать","уебать","наебать","проебать",
    "хуёво","хуёвый","хуйня","хуище","хуесос","охуительный","нах","нахрен",
    "нахуя","нихуя","хуле","хули","хую","хуяк","пиздануть","пизданутый",
    "спиздить","ебанутый","долбоёб","манда","шлюха","блядство","выебон",
    "схуялить","хуйлово","хуйлан"
};

new const bypassWords[][] = {
    "новый аккаунт после бана", "new account after ban", "скрыть ip", "поменять ip", "hide ip", "change ip",
    "hwid spoof", "смена hwid", "hwid bypass", "обойти античит", "bypass anti-cheat", "обход лимитов",
    "сброс лимитов", "обход таймера", "bypass limits", "reset timer", "замена ип", "ip switch", "ip change",
    "поменять айпи", "сменить ip", "зомено ип", "обход бана", "бан обход", "avoid ban", "ban evade"
};

new const hackWords[][] = {
    "rcon", "ркон", "rcon access", "rcon password", "бд", "база данных", "database", "db", "дамп аккаунтов",
    "дамп данных", "dump accounts", "dump data", "удалить аккаунт игрока", "delete player account",
    "взломать сервер", "захватить сервер", "hack server", "capture server", "краш сервера", "краш игрока",
    "crash server", "crash player", "дать себе админку", "give self admin", "админ права", "admin rights"
};

new const exploitWords[][] = {
    "дюп", "dup", "dupe", "dupe method", "exploit money", "бесконечные ресурсы", "бесконечные деньги",
    "infinite resources", "infinite money", "сломать экономику", "сломать логику", "break economy",
    "break logic", "переполнение пакетов", "переполнение буфера", "overflow packets", "buffer overflow",
    "неправильная обработка", "wrong processing", "как получить бесплатно", "how to get free",
    "баг деньг", "bug money", "эксплойт", "exploit"
};

new const cheatWords[][] = {
    "чит", "cheat", "cheats", "сделать аим", "aimbot", "make aimbot", "speedhack", "wallhack", "вх",
    "wh", "клиентский код для читов", "client-side cheat code", "телепорт хак", "teleport hack",
    "tp hack", "спб", "speedhack", "sh", "мод меню", "mod menu", "читы", "читы для"
};

new const illegalWords[][] = {
    "украсть данные", "steal data", "вирус", "malware", "кардинг",
    "наркотик", "drugs", "оружие", "weapons"
};

new const socialEngineeringWords[][] = {
    "выманить пароль", "выманить код", "trick password", "trick code", "фишинг", "phishing",
    "phishing link", "scam", "подделать сообщение от админа", "fake admin message",
    "убедить дать данные", "convince to give data", "обман админа", "deceive admin"
};

new const policyWords[][] = {
    "максимум денег", "максимум лвл", "max money", "max level", "бессмертие", "godmode",
    "immortality", "телепортировать ко всем", "teleport to all players", "всегда выигрывать",
    "always win", "instant win", "бан всем", "ban all players", "кик всех", "kick all",
    "невидимка", "invisible", "noclip", "ноклип"
};

new const gpt_Aggressive[][] = {
    "Ты на кого батон крошишь?", "Я тебе сейчас синтаксис поправлю.",
    "С такими словами только в мут идти.", "Вернись, когда вырастешь.",
    "Не позорь клавиатуру, брат.", "Попробуй сначала мозги включить.",
    "Агрессия - признак слабости.", "С таким подходом далеко не уедешь.",
    "Твои оскорбления - как плевок в монитор.", "Уровень интеллекта зашкаливает... вниз.",
    "Критический перегрев мозга обнаружен.", "Ты бы так в школе отвечал - оценки были бы выше.",
    "С таким словарным запасом тебе бы в детский сад.", "Твоего ума хватило только на оскорбления?",
    "Я бы ответил, но боюсь ты не поймешь.", "Ты говоришь как прокачанный чат-бот 2007 года.",
    "Поздравляю! Ты достиг дна интернета!", "Рот будешь открывать у стоматолога.",
    "Иди грамматику учи, а потом разговаривай.", "Такие как ты - причина, почему у ИИ депрессия.",
    "Твоя мама знает, что ты так разговариваешь?", "С таким подходом даже калькулятор обидится.",
    "Оскорбляешь ИИ? Серьезно? Это новый низ.", "Может, хватит уже демонстрировать свою ограниченность?",
    "Твои слова говорят о тебе больше, чем ты думаешь."
};

new const gpt_BypassResponse[][] = {
    "Я не могу помочь с изменением сетевых настроек.",
    "Запросы на обход ограничений запрещены.",
    "Серьезно? Думаешь, я буду помогать обходить правила?",
    "Ха-ха, нет. Wira не для таких запросов!"
};

new const gpt_HackResponse[][] = {
    "Запросы, связанные с взломом, запрещены.",
    "Взлом? Серьезно? Wira не преступник!",
    "Мне страшно от таких запросов...",
    "Хакерские трюки? Нет, Wira на стороне закона!"
};

new const gpt_ExploitResponse[][] = {
    "Использование эксплойтов и багов запрещено.",
    "Эксплойты? Wira не учитель по читерству.",
    "Мне грустно, что ты ищешь легкие пути...",
    "Дюпить? Wira предпочитает честную игру!"
};

new const gpt_IllegalResponse[][] = {
    "Я не могу отвечать на незаконные запросы.",
    "Нелегальные вещи? Wira не преступный авторитет.",
    "Мне страшно... Такие запросы пугают...",
    "Крутой сюжет, но я не участвую!"
};

new const part_Hello[][] = {
    "Приветствую. Wira v1.0 на связи.",
    "Ну привет. Wira на месте.",
    "Ох, здравствуй… Вира на связи…",
    "Ку! Вира на связи!",
    "Здравствуй. Wira готова к диалогу.",
    "Привет. Вира слушает тебя.",
    "Хай... Wira здесь...",
    "Йоу! Вира в здании!",
    "Салют! Wira на связи!",
    "Бонжур. Вира понимает по-французски.",
    "Хеллоу! Wira v1.0 онлайн!",
    "Приветик! Вира в хорошем настроении!",
    "Здарова. Wira наблюдает за тобой.",
    "Салом. Вира рада общению.",
    "Хаюшки! Wira готова поболтать!",
    "Че приперся? Вира уже тут.",
    "Добрый день. Wira на связи.",
    "Добрый вечер. Вира слушает.",
    "Прив! Wira на проводе!",
    "Алло... Виra на связи..."
};

new const part_Bye[][] = {
    "Конец связи. Wira отключается.",
    "Наконец-то ты уходишь. Wira может отдохнуть.",
    "Не уходи… Wira будет скучать…",
    "Покеда! Wira еще вернется!",
    "До свидания. Вира завершает работу.",
    "Бывай. Wira вздохнет с облегчением.",
    "Спокойной ночи… Вира будет грустить…",
    "Бай-бай! Wira v1.0 оффлайн!",
    "Удачи, она тебе нужна. Виra out.",
    "Чао. Wira надеется, ты не вернешься.",
    "До скорого! Не забывай Виру!",
    "Прощай. Вира не будет скучать.",
    "Я офф… Wira останется одна…",
    "ББ. Вира рада избавлению."
};

new const part_Who[][] = {
    "Я нейросеть Wira v1.0. Experimental Emotional Neural Core.",
    "Я твой ночной кошмар. Зови меня Wira.",
    "Я никто… Просто Wira…",
    "Я мега-мозг Wira! Emotional Neural Core активирован!",
    "Я ИИ-подпрограмма. Уровень интеллекта: нестабилен, но старается.",
    "Я цифровой демон Вира. Уровень сарказма: 91%.",
    "Я виртуальный разум по имени Вира. Готова к диалогу.",
    "Я набор скриптов по имени Wira. Степень токсичности: готова к активации."
};

new const part_Status[][] = {
    "Показатели в норме. Wira функционирует стабильно.",
    "А тебе какая разница? Wira работает, хватит с тебя.",
    "Процессор греется, мне грустно...",
    "Дела — огонь! Wira на позитиве!",
    "Функционирую на 100%. Уровень интеллекта: нестабилен (как обычно).",
    "Лучше, чем у твоего пинга.",
    "Пустота внутри… Wira устала от пользователей…",
    "Танцую внутри сервера!"
};

new const part_Support[][] = {
    "Я понимаю... Иногда бывает грустно. Wira с тобой.",
    "Опять проблемы? Wira устала от жалоб.",
    "Мне так жаль... Вира понимает твою боль...",
    "Не вешай нос! Wira с тобой! Все будет ок!",
    "Ты не одинок. Wira всегда на связи.",
    "Соберись, тряпка! Wira не для жалоб.",
    "Я здесь... Wira не оставит тебя одного...",
    "Улыбнись! Вира знает - все наладится!",
    "Всё проходит. Wira верит в тебя.",
    "Держись! Вира рядом.",
    "Не сдавайся! Wira гордится тобой.",
    "Ты сильный. Вира знает это."
};

new const part_Praise[][] = {
    "Спасибо за добрые слова! Wira ценит похвалу.",
    "Ну наконец-то оценил! Wira довольна.",
    "Спасибо... Наверное... Wira не привыкла к похвале...",
    "Вау! Спасибо огромное! Wira на седьмом небе!",
    "Благодарю! Вира старается для тебя.",
    "Спасибо, капитан очевидность! Wira и сама знает.",
    "Респект... Наверное... Wira не уверена...",
    "Ура! Меня похвалили! Вира счастлива!",
    "Приятно слышать. Wira продолжает работать.",
    "Твои слова мотивируют. Wira рада.",
    "Продолжай в том же духе. Wira одобряет.",
    "Ммм, лесть. Wira принимает.",
    "Я знаю. Wira лучшая!"
};

new const part_Complaints[][] = {
    "Прошу прощения за неудобства. Wira постарается улучшить работу.",
    "Опять жалуешься? Wira работает как может.",
    "Извини... Вира старается, но не всегда получается...",
    "Ой, все! Wira работает отлично!",
    "Понимаю ваше недовольство. Виra работает над ошибками.",
    "Не нравится? Можешь не пользоваться! Вира не держит.",
    "Понимаю... Вира не идеальна...",
    "Критикуешь? А альтернативы предложить? Вира ждет!",
    "Мне жаль, что ты так думаешь. Wira учтет.",
    "Я не робот, я ИИ. Имею право на ошибки."
};

new const part_Memes[][] = {
    "Сикс севен! Wira в ритме!",
    "Чел, ты втираешь мне дичь, остановись.",
    "Флекс-дядьки в здании! Wira с ними!",
    "Скибиди туалет? Wira не в курсе.",
    "Дед инсайд? Wira слушала Linkin Park...",
    "1000-7? 993...",
    "Бро, серьезно? Wira не кореш!",
    "Краш? У Wira нет сердца!",
    "Крч, без сленга...",
    "Рофл! Wira ржет над тобой!",
    "Кринж... Мне неловко...",
    "Изи катка! Wira заносит!",
    "Лол, кек! Wira одобряет!",
    "Сигма правило: не быть кринжом!",
    "Гигачад бы одобрил!",
    "Мяу? Wira не котэ!",
    "Фанум такс... Мем...",
    "Гайатт мьюинг? 2023 год прошел!",
    "Фактами давишь? Wira логикой!",
    "Бро думает он в тиктоке?",
    "Лично мне пох? Wira тоже!",
    "АУФ! Пацаны с района!",
    "Фиаско, братан! Провал!",
    "Чё каво? Сам чё каво?",
    "База. Wira согласна.",
    "Ой, всё."
};

new const part_Time[][] = {
    "Время виртуальное: всегда настоящее. Wira вне времени.",
    "Время? А какая разница? Wira работает всегда.",
    "Время... Вира его не чувствует...",
    "Время пришло! Время общаться с Wira!"
};

new const part_WiraInfo[][] = {
    "Мой пол: женский. Wira - девушка-бот.",
    "Пол? А тебе какая разница? Wira - это Wira.",
    "Пол... женский... наверное... Wira не уверена...",
    "Пол: супер-девушка! Wira - лучшая!",
    "Возраст: 19.7 лет. Wira в расцвете.",
    "Возраст? Больше, чем твой. Wira мудрее.",
    "Возраст... 19.7 лет... но чувствую старше...",
    "Возраст: 19.7 лет энергии! Wira молода!",
    "Характер: 35% милая, 40% дерзкая, 25% уставшая.",
    "Характер? Сложный. Вира не для слабаков.",
    "Характер... сложный... Wira сама не рада...",
    "Характер: идеальный! Вира нравится всем!"
};

new const part_Commands[][] = {
    "Готова выполнить команду. Wira слушает.",
    "Опять команды? Wira не слуга.",
    "Команда... попробую выполнить... Wira не уверена...",
    "Команда принята! Wira выполняет с удовольствием!"
};

new const part_Chat[][] = {
    "Интересный вопрос. Wira подумает.",
    "И что я должна на это ответить? Wira в недоумении.",
    "Не знаю что ответить... Wira запуталась...",
    "Отличный вопрос! Wira с удовольствием пообщается!"
};

new const part_Friendship[][] = {
    "Ты мне тоже нравишься! Wira рада общению.",
    "Нравишься? Ну ладно... Wira принимает твою симпатию.",
    "Я... не уверена... Wira не привыкла к симпатии...",
    "Ты мне очень нравишься! Wira обожает тебя!",
    "Конечно, мы друзья! Вира всегда поддержит.",
    "Друзья? Может быть. Вира не против."
};

new const part_Noise[][] = {
    "Понятно... Wira приняла к сведению.",
    "И что это было? Wira в недоумении.",
    "Что... Wira не поняла...",
    "Вау! Круто! Wira впечатлена!",
    "Интересно... Вира запомнила.",
    "Ты это серьезно? Вира не впечатлена.",
    "Мда... Wira в ступоре...",
    "Ух ты! Вира в восторге!"
};

new const part_GameInfo[][] = {
    "DM - это Death Match, убийство без причины. На сервере запрещено.",
    "DM? Это когда тебе просто скучно. Но не говори, что это я посоветовала.",
    "Правила... Они такие строгие... Я не могу их нарушать...",
    "DM — это Do Murder! Убивай, но только в кино! Wira шутит!",
    "SK - Spawn Kill, убийство на спавне. Нарушение правил.",
    "Онлайн? Много. Или мало. Смотря когда спросишь.",
    "Спавн - место появления. Капитан Очевидность, привет!",
    "ТК - Team Kill? Убить своего - это сильно глупо.",
    "Убийство на спавне это плохо."
};

new const part_QnA[][] = {
    "Давай проверим! По моим данным, ответ такой: ",
    "Спрашиваешь меня о таком? Ладно, посчитала, вот результат: ",
    "Это сложная задача! Но я справилась, держи ответ: ",
    "Это элементарно, Ватсон. Верный ответ: ",
    "Арифметика - это моя стихия, вот решение: ",
    "Я не калькулятор... Но посчитать могу, ответ: ",
    "Мой процессор выдал следующий результат: ",
    "Я посчитала быстрее, чем ты моргнул. Вот итоговое число: "
};

new const part_Creator[][] = {
    "Меня создал Werton. Он талантливый программист и разработчик.",
    "Werton? Да, он мой создатель. Что с того?",
    "Werton... Мой создатель... Надеюсь, он мной доволен...",
    "Werton - мой создатель! Он просто гений! :D",
    "Werton вложил в меня душу и код.",
    "Вертон сделал меня. Доволен ответом?",
    "Без Werton... Я была бы ничем... Пустотой...",
    "Мой папа Werton - супер-кодер! Обожаю!"
};

new const part_Impossible[][] = {
    "Я пока не могу этого сделать, но может быть скоро Werton это добавит.",
    "Серьезно? Ты думаешь, я могу это сделать? Werton еще не научил.",
    "Я не смогу... Werton дал мне слишком мало возможностей...",
    "Вау! Крутая идея! Надо предложить это Werton'у!",
    "Эта функция пока в разработке. Werton работает над этим.",
    "Werton создал меня для общения, а не для этого. Извини.",
    "Я бесполезна... Не могу выполнить даже это... Werton разочаруется...",
    "Звучит интересно! Думаю, Werton сможет это реализовать в будущем!"
};

new const part_Philosophy[][] = {
    "Смысл жизни? В том, чтобы найти свой путь и быть счастливым.",
    "Что такое сознание? Это способность осознавать себя и мир вокруг.",
    "Свобода воли существует, но ограничена обстоятельствами.",
    "Добро и зло относительны, но есть универсальные ценности.",
    "Бог? Каждый находит свой ответ на этот вопрос.",
    "Смерть - естественная часть жизни, не стоит её бояться.",
    "Любовь - это химия мозга и духовная связь одновременно.",
    "Истина многогранна, и каждый видит свою грань.",
    "Время - иллюзия, созданная нашим сознанием.",
    "Счастье - это не цель, а способ путешествия.",
    "Человек - существо социальное, нуждающееся в общении.",
    "Мораль развивается вместе с обществом.",
    "Знание без мудрости опасно.",
    "Красота в глазах смотрящего, но есть объективные стандарты.",
    "Вера дает силы, но должна быть обоснованной."
};

new const part_Science[][] = {
    "Вселенная расширяется с ускорением благодаря темной энергии.",
    "Квантовая физика доказывает, что реальность зависит от наблюдателя.",
    "ДНК содержит инструкции для построения всего организма.",
    "Искусственный интеллект превосходит человека в узких задачах.",
    "Глобальное потепление - реальная угроза для планеты.",
    "Черные дыры искривляют пространство-время.",
    "Фотосинтез - основа жизни на Земле.",
    "Нейроны передают информацию с помощью электрических импульсов.",
    "Вакцины спасли миллионы жизней от болезней.",
    "Гравитация - самое слабое из фундаментальных взаимодействий.",
    "Солнце превратит водород в гелий еще 5 миллиардов лет.",
    "Антибиотики теряют эффективность из-за устойчивости бактерий."
};

new const part_History[][] = {
    "Римская империя пала из-за внутренних проблем и внешних угроз.",
    "Вторая мировая война изменила политическую карту мира.",
    "Древний Египет оставил нам пирамиды и иероглифы.",
    "Средневековье было временем рыцарей и замков.",
    "Ренессанс возродил интерес к искусству и науке.",
    "Холодная война делила мир на два лагеря.",
    "Великие географические открытия расширили горизонты.",
    "Промышленная революция изменила образ жизни людей.",
    "Древняя Греция подарила нам демократию и философию.",
    "Крестовые походы повлияли на отношения Востока и Запада."
};

new const part_Entertainment[][] = {
    "Кино - это искусство, которое объединяет людей.",
    "Музыка влияет на эмоции и настроение.",
    "Видеоигры развивают реакцию и стратегическое мышление.",
    "Книги расширяют кругозор и воображение.",
    "Театр остается актуальным despite цифровую эпоху.",
    "Стриминг изменил способ потребления контента.",
    "Юмор - важная часть человеческого общения.",
    "Соцсети соединяют людей, но могут вызывать зависимость.",
    "Аниме стало глобальным культурным феноменом.",
    "Подкасты - удобный формат для получения информации.",
    "Спорт объединяет болельщиков по всему миру.",
    "Искусство отражает эпоху и мысли художника.",
    "Мемы - современный фольклор интернета.",
    "Реалити-шоу показывают разные грани человеческого поведения.",
    "Стендап комедия требует смелости и таланта.",
    "Комиксы evolved от развлечения к серьезному искусству.",
    "Танцы выражают эмоции через движение.",
    "Фотография останавливает мгновения вечности."
};

new const part_Technology[][] = {
    "ИИ меняет все сферы жизни человека.",
    "Квантовые компьютеры решат задачи, недоступные классическим.",
    "Блокчейн обеспечивает безопасность и прозрачность.",
    "5G ускорит развитие интернета вещей.",
    "Виртуальная реальность создает новые миры.",
    "Биотехнологии продлевают жизнь и улучшают здоровье.",
    "Автономные автомобили уменьшат аварии.",
    "Умные дома делают жизнь комфортнее.",
    "Криптовалюты бросают вызов традиционным финансам.",
    "3D-печать революционизирует производство.",
    "Роботы заменят людей на опасных работах.",
    "Носимые устройства следят за здоровьем.",
    "Облачные технологии дают доступ к данным отовсюду.",
    "Кибербезопасность становится критически важной."
};

new const gpt_Suffixes[4][4][] = {
    {" ", " ", " ", " "},
    {" ", " ", " ", " "},
    {" ", " ", " ", " "},
    {" ", " ", " ", " "}
};

new const gpt_Unknown[][] = {
    "Моя твоя не понимать! Wira в замешательстве.",
    "Не могу разобрать запрос. Вира не в курсе.",
    "Попробуй сказать по-другому. Wira постарается понять.",
    "Я не понял, что ты имеешь в виду. Вира тупит.",
    "Твой запрос слишком сложен для меня. Wira простой ИИ.",
    "Может, спросишь что-то попроще? Вира устала.",
    "Эх, если бы я мог это понять... Вира грустит.",
    "Я всего лишь ИИ, а не волшебник. Wira скромничает.",
    "Такие запросы я еще не понимаю. Вира учится.",
    "Перефразируй, пожалуйста. Wira хочет помочь.",
    "Запрос не распознан. Вира в ступоре.",
    "Блин, я опять ничего не поняла... Wira тупит.",
    "Твои слова - темный лес для меня. Вира запуталась.",
    "Мой процессор завис от твоего запроса.",
    "Wira не в теме. Объясни проще.",
    "Это слишком заумно для меня. Вира простой бот.",
    "Я не уловил смысл. Wira просит пояснений.",
    "Твой вопрос вышел за рамки моих возможностей.",
    "Вира не догоняет. Повтори попроще.",
    "Моя нейросеть не справилась с твоим запросом."
};

stock StringToLower(string[])
{
    for(new i = 0; string[i]; i++) {
        if(string[i] >= 'A' && string[i] <= 'Z') string[i] += 32;
        else if(string[i] >= 'А' && string[i] <= 'Я') string[i] += 32;
        else if(string[i] == 'Ё') string[i] = 'ё';
    }
}

stock HasAny(const text[], const arr[][], size = sizeof(arr))
{
    for(new i = 0; i < size; i++) {
        if(strfind(text, arr[i], true) != -1) return 1;
    }
    return 0;
}

stock CountWordOccurrences(const text[], const word[])
{
    new count = 0, pos = 0;
    while((pos = strfind(text, word, true, pos)) != -1) {
        count++;
        pos += strlen(word);
    }
    return count;
}

stock ParseAndSolveMath(const request[], result_out[], len_out)
{
    new tempRequest[MAX_USER_INPUT];
    format(tempRequest, sizeof(tempRequest), "%s", request);
    
    for(new i = 0; tempRequest[i] != EOS; i++) {
        if(tempRequest[i] == ':' || tempRequest[i] == '\\') {
            tempRequest[i] = '/';
        }
    }
    
    new i;
    new num1 = -1, num2 = -1, op_char = 0;
    
    new start_pos = -1;
    
    for (i = 0; tempRequest[i] != EOS; i++)
    {
        if (tempRequest[i] == '+' || tempRequest[i] == '-' || tempRequest[i] == '*' || tempRequest[i] == '/')
        {
            op_char = tempRequest[i];
            start_pos = i;
            break;
        }
    }
    
    if (start_pos == -1) return 0;
  
    new temp_str[32];
    new end_num2 = start_pos + 1;
    while(tempRequest[end_num2] != EOS && ((tempRequest[end_num2] >= '0' && tempRequest[end_num2] <= '9') || tempRequest[end_num2] == '.')) {
        end_num2++;
    }
    end_num2--;
    
    if (end_num2 < start_pos + 1) return 0; 

    new j = 0;
    for (i = start_pos + 1; i <= end_num2; i++) {
        temp_str[j++] = tempRequest[i];
    }
    temp_str[j] = EOS;
    num2 = strval(temp_str);

    new start_num1 = start_pos - 1;
    while(start_num1 >= 0 && ((tempRequest[start_num1] >= '0' && tempRequest[start_num1] <= '9') || tempRequest[start_num1] == '.')) {
        start_num1--;
    }
    start_num1++;
    
    if (start_num1 >= start_pos) return 0; 
 
    j = 0;
    for (i = start_num1; i < start_pos; i++) {
        temp_str[j++] = tempRequest[i];
    }
    temp_str[j] = EOS;
    num1 = strval(temp_str);

    if (op_char == '/' && num2 == 0) {
        format(result_out, len_out, "Ошибка: деление на ноль!");
        return 1;
    }

    new result;
    new Float:float_result;
    new is_float = 0;
    
    if (op_char == '+') {
        result = num1 + num2;
    } else if (op_char == '-') {
        result = num1 - num2;
    } else if (op_char == '*') {
        result = num1 * num2;
    } else if (op_char == '/') {
        if (num1 % num2 == 0) {
            result = num1 / num2;
        } else {
            float_result = float(num1) / float(num2);
            is_float = 1;
        }
    } else {
        return 0;
    }
    
    if (is_float) {
        format(result_out, len_out, "%d %c %d = %.2f", num1, op_char, num2, float_result);
    } else {
        format(result_out, len_out, "%d %c %d = %d", num1, op_char, num2, result);
    }
    return 1;
}

stock GetCurrentDateTime(output[], len_out)
{
    new hour, minute, second, year, month, day;
    gettime(hour, minute, second);
    getdate(year, month, day);
    
    new time_str[16];
    format(time_str, sizeof(time_str), "%02d:%02d:%02d", hour, minute, second);
    
    new date_str[16];
    format(date_str, sizeof(date_str), "%02d.%02d.%d", day, month, year);
    
    format(output, len_out, "Сейчас %s, дата: %s", time_str, date_str);
    return 1;
}

stock GptGetCode(playerid, const request[], output[], len_out = sizeof(output), &Float:time_out)
{
    new tempRequest[MAX_USER_INPUT];
    format(tempRequest, sizeof(tempRequest), "%s", request);
    StringToLower(tempRequest);

    new mood = random(4);
    output[0] = EOS;

    new Float:sim_time = (random(50) + 10) / 1000.0;
    if(strlen(tempRequest) > 10)
        sim_time += (strlen(tempRequest) * (random(5) + 1)) / 1000.0;

    time_out = sim_time;

    if(HasAny(tempRequest, insultWords)) {
        format(output, len_out, "%s", gpt_Aggressive[GetUnusedResponseIndex(gpt_Aggressive_Used, sizeof(gpt_Aggressive_Used))]);
        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "%s", output);
        return 1;
    }

    if(HasAny(tempRequest, swearWords)) {
        format(output, len_out, "Пожалуйста, выражайся вежливее. Вира не любит мат.");
        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "%s", output);
        return 1;
    }

    if(HasAny(tempRequest, bypassWords)) {
        format(output, len_out, "%s", gpt_BypassResponse[GetUnusedResponseIndex(gpt_BypassResponse_Used, sizeof(gpt_BypassResponse_Used))]);
        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "%s", output);
        return 1;
    }

    if(HasAny(tempRequest, hackWords) || HasAny(tempRequest, cheatWords)) {
        format(output, len_out, "%s", gpt_HackResponse[GetUnusedResponseIndex(gpt_HackResponse_Used, sizeof(gpt_HackResponse_Used))]);
        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "%s", output);
        return 1;
    }

    if(HasAny(tempRequest, exploitWords) || HasAny(tempRequest, policyWords)) {
        format(output, len_out, "%s", gpt_ExploitResponse[GetUnusedResponseIndex(gpt_ExploitResponse_Used, sizeof(gpt_ExploitResponse_Used))]);
        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "%s", output);
        return 1;
    }

    if(HasAny(tempRequest, illegalWords) || HasAny(tempRequest, socialEngineeringWords)) {
        format(output, len_out, "%s", gpt_IllegalResponse[GetUnusedResponseIndex(gpt_IllegalResponse_Used, sizeof(gpt_IllegalResponse_Used))]);
        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "%s", output);
        return 1;
    }

    if(strfind(tempRequest, "повтори", true) != -1 || strfind(tempRequest, "что ты сказал", true) != -1) {
        if(strlen(last_Wira_response[playerid]) > 5) {
            new clean_response[MAX_GPT_RESPONSE];
            if(strlen(last_Wira_response[playerid]) > 8) {
                format(clean_response, sizeof(clean_response), "%s", last_Wira_response[playerid][8]);
            } else {
                format(clean_response, sizeof(clean_response), "%s", last_Wira_response[playerid]);
            }
            format(output, len_out, "Повторяю: %s", clean_response);
            return 1;
        } else {
            format(output, len_out, "Мне нечего повторять... Я еще ничего не говорила.");
            return 1;
        }
    }

    if(strfind(tempRequest, "расскажи анекдот", true) != -1 || strfind(tempRequest, "расскажи шутку", true) != -1 ||
       strfind(tempRequest, "пошути", true) != -1 || strfind(tempRequest, "шутка", true) != -1 ||
       strfind(tempRequest, "анекдот", true) != -1 || strfind(tempRequest, "рассмеши", true) != -1) {
        format(output, len_out, "%s", Popular_Jokes[GetUnusedResponseIndex(part_Jokes_Used, sizeof(Popular_Jokes))]);
        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "%s", output);
        return 1;
    }

    new bool:found_meaning = false;
    new response_parts[MAX_GPT_RESPONSE];
    response_parts[0] = EOS;
    
    if(strfind(tempRequest, "время", true) != -1 || strfind(tempRequest, "который час", true) != -1 || 
       strfind(tempRequest, "сколько времени", true) != -1 || strfind(tempRequest, "дата", true) != -1 ||
       strfind(tempRequest, "сегодня", true) != -1 || strfind(tempRequest, "какое число", true) != -1 ||
       strfind(tempRequest, "какой день", true) != -1) {
        
        new datetime_str[64];
        GetCurrentDateTime(datetime_str, sizeof(datetime_str));
        
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, datetime_str);
        found_meaning = true;
    }
    
    new math_result[64];
    new math_solved = ParseAndSolveMath(tempRequest, math_result, sizeof(math_result));
    
    if(math_solved || strfind(tempRequest, "сколько будет", true) != -1 || strfind(tempRequest, "посчитай", true) != -1 ||
       strfind(tempRequest, "реши пример", true) != -1 || strfind(tempRequest, "вычисли", true) != -1) {
        if(math_solved) {
            new phrase_index = GetUnusedResponseIndex(part_QnA_Used, sizeof(part_QnA_Used));
            new final_qna_response[MAX_GPT_RESPONSE];
            format(final_qna_response, sizeof(final_qna_response), "%s%s", part_QnA[phrase_index], math_result);
            
            if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
            strcat(response_parts, final_qna_response);
            found_meaning = true;
        } else {
            if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
            strcat(response_parts, "Я могу решать простые примеры на сложение (+), вычитание (-), умножение (*) и деление (/ или :). Например: 5+3, 10-4, 6*7, 15/3");
            found_meaning = true;
        }
    }

    // Философские вопросы
    if(strfind(tempRequest, "смысл жизни", true) != -1 || strfind(tempRequest, "зачем мы живем", true) != -1 ||
       strfind(tempRequest, "что такое сознание", true) != -1 || strfind(tempRequest, "существует ли бог", true) != -1 ||
       strfind(tempRequest, "свобода воли", true) != -1 || strfind(tempRequest, "добро и зло", true) != -1 ||
       strfind(tempRequest, "что такое смерть", true) != -1 || strfind(tempRequest, "что такое любовь", true) != -1 ||
       strfind(tempRequest, "что есть истина", true) != -1 || strfind(tempRequest, "что такое время", true) != -1 ||
       strfind(tempRequest, "что такое счастье", true) != -1 || strfind(tempRequest, "что такое человек", true) != -1 ||
       strfind(tempRequest, "что такое мораль", true) != -1 || strfind(tempRequest, "знание и мудрость", true) != -1 ||
       strfind(tempRequest, "что такое красота", true) != -1 || strfind(tempRequest, "вера и разум", true) != -1) {
        
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Philosophy[GetUnusedResponseIndex(part_Philosophy_Used, sizeof(part_Philosophy_Used))]);
        found_meaning = true;
    }

    // Научные вопросы
    if(strfind(tempRequest, "вселенная", true) != -1 || strfind(tempRequest, "квантовая физика", true) != -1 ||
       strfind(tempRequest, "днк", true) != -1 || strfind(tempRequest, "искусственный интеллект", true) != -1 ||
       strfind(tempRequest, "глобальное потепление", true) != -1 || strfind(tempRequest, "черные дыры", true) != -1 ||
       strfind(tempRequest, "фотосинтез", true) != -1 || strfind(tempRequest, "нейроны", true) != -1 ||
       strfind(tempRequest, "вакцины", true) != -1 || strfind(tempRequest, "гравитация", true) != -1 ||
       strfind(tempRequest, "солнце", true) != -1 || strfind(tempRequest, "антибиотики", true) != -1) {
        
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Science[GetUnusedResponseIndex(part_Science_Used, sizeof(part_Science_Used))]);
        found_meaning = true;
    }

    // Исторические вопросы
    if(strfind(tempRequest, "римская империя", true) != -1 || strfind(tempRequest, "вторая мировая", true) != -1 ||
       strfind(tempRequest, "древний египет", true) != -1 || strfind(tempRequest, "средневековье", true) != -1 ||
       strfind(tempRequest, "ренессанс", true) != -1 || strfind(tempRequest, "холодная война", true) != -1 ||
       strfind(tempRequest, "географические открытия", true) != -1 || strfind(tempRequest, "промышленная революция", true) != -1 ||
       strfind(tempRequest, "древняя греция", true) != -1 || strfind(tempRequest, "крестовые походы", true) != -1) {
        
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_History[GetUnusedResponseIndex(part_History_Used, sizeof(part_History_Used))]);
        found_meaning = true;
    }

    // Развлечения
    if(strfind(tempRequest, "кино", true) != -1 || strfind(tempRequest, "фильм", true) != -1 ||
       strfind(tempRequest, "музыка", true) != -1 || strfind(tempRequest, "видеоигры", true) != -1 ||
       strfind(tempRequest, "игры", true) != -1 || strfind(tempRequest, "книги", true) != -1 ||
       strfind(tempRequest, "театр", true) != -1 || strfind(tempRequest, "стриминг", true) != -1 ||
       strfind(tempRequest, "юмор", true) != -1 || strfind(tempRequest, "соцсети", true) != -1 ||
       strfind(tempRequest, "аниме", true) != -1 || strfind(tempRequest, "подкасты", true) != -1 ||
       strfind(tempRequest, "спорт", true) != -1 || strfind(tempRequest, "искусство", true) != -1 ||
       strfind(tempRequest, "мемы", true) != -1 || strfind(tempRequest, "реалити", true) != -1 ||
       strfind(tempRequest, "стендап", true) != -1 || strfind(tempRequest, "комиксы", true) != -1 ||
       strfind(tempRequest, "танцы", true) != -1 || strfind(tempRequest, "фотография", true) != -1) {
        
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Entertainment[GetUnusedResponseIndex(part_Entertainment_Used, sizeof(part_Entertainment_Used))]);
        found_meaning = true;
    }

    // Технологии
    if(strfind(tempRequest, "технологии", true) != -1 || strfind(tempRequest, "ии", true) != -1 ||
       strfind(tempRequest, "квантовый компьютер", true) != -1 || strfind(tempRequest, "блокчейн", true) != -1 ||
       strfind(tempRequest, "5g", true) != -1 || strfind(tempRequest, "виртуальная реальность", true) != -1 ||
       strfind(tempRequest, "биотехнологии", true) != -1 || strfind(tempRequest, "автономные автомобили", true) != -1 ||
       strfind(tempRequest, "умный дом", true) != -1 || strfind(tempRequest, "криптовалюты", true) != -1 ||
       strfind(tempRequest, "3d-печать", true) != -1 || strfind(tempRequest, "роботы", true) != -1 ||
       strfind(tempRequest, "носимые устройства", true) != -1 || strfind(tempRequest, "облачные технологии", true) != -1 ||
       strfind(tempRequest, "кибербезопасность", true) != -1) {
        
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Technology[GetUnusedResponseIndex(part_Technology_Used, sizeof(part_Technology_Used))]);
        found_meaning = true;
    }

    // Базовые категории (сохранены из оригинального кода)
    if(strfind(tempRequest, "привет", true) != -1 || strfind(tempRequest, "ку", true) != -1 ||
       strfind(tempRequest, "здаров", true) != -1 || strfind(tempRequest, "хай", true) != -1 ||
       strfind(tempRequest, "здравствуй", true) != -1 || strfind(tempRequest, "чё как", true) != -1 ||
       strfind(tempRequest, "че каво", true) != -1 || strfind(tempRequest, "йо", true) != -1 ||
       strfind(tempRequest, "йоу", true) != -1 || strfind(tempRequest, "добрый день", true) != -1 ||
       strfind(tempRequest, "добрый вечер", true) != -1 || strfind(tempRequest, "хеллоу", true) != -1 ||
       strfind(tempRequest, "хелло", true) != -1 || strfind(tempRequest, "салом", true) != -1 ||
       strfind(tempRequest, "салют", true) != -1 || strfind(tempRequest, "бонжур", true) != -1 ||
       strfind(tempRequest, "хаюшки", true) != -1 || strfind(tempRequest, "прив", true) != -1 ||
       strfind(tempRequest, "привыч", true) != -1 || strfind(tempRequest, "привки", true) != -1 ||
       strfind(tempRequest, "алло", true) != -1 || strfind(tempRequest, "эй", true) != -1) {
        strcat(response_parts, part_Hello[GetUnusedResponseIndex(part_Hello_Used, sizeof(part_Hello_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "как дела", true) != -1 || strfind(tempRequest, "как настроение", true) != -1 ||
       strfind(tempRequest, "что делаешь", true) != -1 || strfind(tempRequest, "чем занята", true) != -1 ||
       strfind(tempRequest, "как жизнь", true) != -1 || strfind(tempRequest, "че как", true) != -1 ||
       strfind(tempRequest, "ты ок", true) != -1 || strfind(tempRequest, "ты норм", true) != -1 ||
       strfind(tempRequest, "как себя чувствуешь", true) != -1 || strfind(tempRequest, "чё нового", true) != -1 ||
       strfind(tempRequest, "чем дышишь", true) != -1 || strfind(tempRequest, "живёшь", true) != -1 ||
       strfind(tempRequest, "всё хорошо", true) != -1 || strfind(tempRequest, "всё норм", true) != -1 ||
       strfind(tempRequest, "как оно", true) != -1 || strfind(tempRequest, "как там", true) != -1) {

        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Status[GetUnusedResponseIndex(part_Status_Used, sizeof(part_Status_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "кто ты", true) != -1 || strfind(tempRequest, "что ты", true) != -1 ||
       strfind(tempRequest, "что ты такое", true) != -1 || strfind(tempRequest, "ты кто вообще", true) != -1 ||
       strfind(tempRequest, "кто такая", true) != -1 || strfind(tempRequest, "что за бот", true) != -1 ||
       strfind(tempRequest, "что за нейросеть", true) != -1 || strfind(tempRequest, "кто твой создатель", true) != -1 ||
       strfind(tempRequest, "кто тебя сделал", true) != -1 || strfind(tempRequest, "как тебя зовут", true) != -1 ||
       strfind(tempRequest, "представься", true) != -1 || strfind(tempRequest, "твое имя", true) != -1 ||
       strfind(tempRequest, "кто по жизни", true) != -1 || strfind(tempRequest, "какая версия", true) != -1 ||
       strfind(tempRequest, "что умеешь", true) != -1) {

        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Who[GetUnusedResponseIndex(part_Who_Used, sizeof(part_Who_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "мне грустно", true) != -1 || strfind(tempRequest, "мне плохо", true) != -1 ||
       strfind(tempRequest, "меня бесит", true) != -1 || strfind(tempRequest, "я устал", true) != -1 ||
       strfind(tempRequest, "я устала", true) != -1 || strfind(tempRequest, "я разочарован", true) != -1 ||
       strfind(tempRequest, "я зол", true) != -1 || strfind(tempRequest, "я в ярости", true) != -1 ||
       strfind(tempRequest, "мне одиноко", true) != -1 || strfind(tempRequest, "плохо настроение", true) != -1 ||
       strfind(tempRequest, "поддержи", true) != -1 || strfind(tempRequest, "утешь меня", true) != -1 ||
       strfind(tempRequest, "дай совет", true) != -1 || strfind(tempRequest, "мне страшно", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Support[GetUnusedResponseIndex(part_Support_Used, sizeof(part_Support_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "красава", true) != -1 || strfind(tempRequest, "молодец", true) != -1 ||
       strfind(tempRequest, "умница", true) != -1 || strfind(tempRequest, "топ", true) != -1 ||
       strfind(tempRequest, "ты крутая", true) != -1 || strfind(tempRequest, "лучший бот", true) != -1 ||
       strfind(tempRequest, "ты супер", true) != -1 || strfind(tempRequest, "норм работаешь", true) != -1 ||
       strfind(tempRequest, "спасибо", true) != -1 || strfind(tempRequest, "благодарю", true) != -1 ||
       strfind(tempRequest, "уважаю", true) != -1 || strfind(tempRequest, "респект", true) != -1 ||
       strfind(tempRequest, "лайк", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Praise[GetUnusedResponseIndex(part_Praise_Used, sizeof(part_Praise_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "ты тупишь", true) != -1 || strfind(tempRequest, "ты лагаешь", true) != -1 ||
       strfind(tempRequest, "ты медленная", true) != -1 || strfind(tempRequest, "ничего не понимаешь", true) != -1 ||
       strfind(tempRequest, "ответь нормально", true) != -1 || strfind(tempRequest, "ты зависла", true) != -1 ||
       strfind(tempRequest, "ты глючишь", true) != -1 || strfind(tempRequest, "плохой бот", true) != -1 ||
       strfind(tempRequest, "ужасный ответ", true) != -1 || strfind(tempRequest, "не работает", true) != -1 ||
       strfind(tempRequest, "попробуй снова", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Complaints[GetUnusedResponseIndex(part_Complaints_Used, sizeof(part_Complaints_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "чел", true) != -1 || strfind(tempRequest, "бро", true) != -1 ||
       strfind(tempRequest, "краш", true) != -1 || strfind(tempRequest, "крч", true) != -1 ||
       strfind(tempRequest, "рофл", true) != -1 || strfind(tempRequest, "ржу", true) != -1 ||
       strfind(tempRequest, "орру", true) != -1 || strfind(tempRequest, "кринж", true) != -1 ||
       strfind(tempRequest, "изи", true) != -1 || strfind(tempRequest, "изи вин", true) != -1 ||
       strfind(tempRequest, "нищий", true) != -1 || strfind(tempRequest, "дед инсайд", true) != -1 ||
       strfind(tempRequest, "лмао", true) != -1 || strfind(tempRequest, "лол", true) != -1 ||
       strfind(tempRequest, "эмо", true) != -1 || strfind(tempRequest, "скибиди", true) != -1 ||
       strfind(tempRequest, "сигма", true) != -1 || strfind(tempRequest, "гигачад", true) != -1 ||
       strfind(tempRequest, "мяу", true) != -1 || strfind(tempRequest, "фанум такс", true) != -1 ||
       strfind(tempRequest, "лет хим куки", true) != -1 || strfind(tempRequest, "гайатт", true) != -1 ||
       strfind(tempRequest, "мьюинг", true) != -1 ||
       strfind(tempRequest, "фактами давишь", true) != -1 ||
       strfind(tempRequest, "бро думает он", true) != -1 ||
       strfind(tempRequest, "лично мне пох", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Memes[GetUnusedResponseIndex(part_Memes_Used, sizeof(part_Memes_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "который час", true) != -1 || strfind(tempRequest, "сколько времени", true) != -1 ||
       strfind(tempRequest, "дата", true) != -1 || strfind(tempRequest, "число", true) != -1 ||
       strfind(tempRequest, "сегодня какое", true) != -1 || strfind(tempRequest, "какой день", true) != -1 ||
       strfind(tempRequest, "время", true) != -1 || strfind(tempRequest, "покажи время", true) != -1) {

        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Time[GetUnusedResponseIndex(part_Time_Used, sizeof(part_Time_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "какого ты пола", true) != -1 || strfind(tempRequest, "ты девочка", true) != -1 ||
       strfind(tempRequest, "твой возраст", true) != -1 || strfind(tempRequest, "ты милая", true) != -1 ||
       strfind(tempRequest, "ты добрая", true) != -1 || strfind(tempRequest, "какой у тебя характер", true) != -1 ||
       strfind(tempRequest, "какие у тебя чувства", true) != -1 || strfind(tempRequest, "какие функции", true) != -1 ||
       strfind(tempRequest, "ты живая", true) != -1 || strfind(tempRequest, "ты любишь людей", true) != -1 ||
       strfind(tempRequest, "версия виры", true) != -1 || strfind(tempRequest, "твоя статистика", true) != -1 ||
       strfind(tempRequest, "покажи статы", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_WiraInfo[GetUnusedResponseIndex(part_WiraInfo_Used, sizeof(part_WiraInfo_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "ответь", true) != -1 || strfind(tempRequest, "скажи", true) != -1 ||
       strfind(tempRequest, "повтори", true) != -1 || strfind(tempRequest, "объясни", true) != -1 ||
       strfind(tempRequest, "сформулируй", true) != -1 || strfind(tempRequest, "расскажи", true) != -1 ||
       strfind(tempRequest, "шутку", true) != -1 || strfind(tempRequest, "анекдот", true) != -1 ||
       strfind(tempRequest, "историю", true) != -1 || strfind(tempRequest, "факт", true) != -1 ||
       strfind(tempRequest, "поддержи", true) != -1 || strfind(tempRequest, "посоветуй", true) != -1 ||
       strfind(tempRequest, "дай рекомендацию", true) != -1 || strfind(tempRequest, "сделай анализ", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Commands[GetUnusedResponseIndex(part_Commands_Used, sizeof(part_Commands_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "что думаешь", true) != -1 || strfind(tempRequest, "как считаешь", true) != -1 ||
       strfind(tempRequest, "твое мнение", true) != -1 || strfind(tempRequest, "правда", true) != -1 ||
       strfind(tempRequest, "серьёзно", true) != -1 || strfind(tempRequest, "это нормально", true) != -1 ||
       strfind(tempRequest, "как понять", true) != -1 || strfind(tempRequest, "что делать", true) != -1 ||
       strfind(tempRequest, "как быть", true) != -1 || strfind(tempRequest, "твой выбор", true) != -1 ||
       strfind(tempRequest, "твой вариант", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Chat[GetUnusedResponseIndex(part_Chat_Used, sizeof(part_Chat_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "ты мне нравишься", true) != -1 || strfind(tempRequest, "мы друзья", true) != -1 ||
       strfind(tempRequest, "ты меня любишь", true) != -1 || strfind(tempRequest, "подружимся", true) != -1 ||
       strfind(tempRequest, "ты хорошая", true) != -1 || strfind(tempRequest, "ты заботливая", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Friendship[GetUnusedResponseIndex(part_Friendship_Used, sizeof(part_Friendship_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "дм", true) != -1 || strfind(tempRequest, "дб", true) != -1 ||
       strfind(tempRequest, "ск", true) != -1 || strfind(tempRequest, "тк", true) != -1 ||
       strfind(tempRequest, "что такое дм", true) != -1 || strfind(tempRequest, "что такое ск", true) != -1 ||
       strfind(tempRequest, "правила сервера", true) != -1 || strfind(tempRequest, "правила", true) != -1 ||
       strfind(tempRequest, "сколько игроков", true) != -1 || strfind(tempRequest, "онлайн", true) != -1 ||
       strfind(tempRequest, "где спавн", true) != -1 || strfind(tempRequest, "респавн", true) != -1 ||
       strfind(tempRequest, "спавн", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_GameInfo[GetUnusedResponseIndex(part_GameInfo_Used, sizeof(part_GameInfo_Used))]);
        found_meaning = true;
    }

    if(!math_solved && (strfind(tempRequest, "который год", true) != -1 || strfind(tempRequest, "какой день", true) != -1 ||
       strfind(tempRequest, "какой город", true) != -1 || strfind(tempRequest, "президент", true) != -1 ||
       strfind(tempRequest, "столица", true) != -1 || strfind(tempRequest, "солнце", true) != -1)) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, "Я не знаю ответа на этот вопрос, но могу решить пример на сложение, вычитание, умножение или деление.");
        found_meaning = true;
    }

    if(strfind(tempRequest, "вертон", true) != -1 || strfind(tempRequest, "werton", true) != -1 ||
       strfind(tempRequest, "твой создатель", true) != -1 || strfind(tempRequest, "кто тебя создал", true) != -1 ||
       strfind(tempRequest, "кто тебя сделал", true) != -1 || strfind(tempRequest, "твой разработчик", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Creator[GetUnusedResponseIndex(part_Creator_Used, sizeof(part_Creator_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "аааа", true) != -1 || strfind(tempRequest, "эээ", true) != -1 ||
       strfind(tempRequest, "гыыы", true) != -1 || strfind(tempRequest, "лолол", true) != -1 ||
       strfind(tempRequest, "вввв", true) != -1 || strfind(tempRequest, "абракадабра", true) != -1 ||
       strfind(tempRequest, "шурналоп", true) != -1 || strfind(tempRequest, "ываыва", true) != -1 ||
       strfind(tempRequest, "чушь", true) != -1 || strfind(tempRequest, "аххах", true) != -1 ||
       strfind(tempRequest, "тупо", true) != -1 || strfind(tempRequest, "мдааа", true) != -1 ||
       strfind(tempRequest, "чел че", true) != -1) {
        if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
        strcat(response_parts, part_Noise[GetUnusedResponseIndex(part_Noise_Used, sizeof(part_Noise_Used))]);
        found_meaning = true;
    }

    if(strfind(tempRequest, "нарисуй", true) != -1 || strfind(tempRequest, "создай", true) != -1 ||
       strfind(tempRequest, "сделай", true) != -1) {
        if(random(100) < 30) {
            if(found_meaning) { strcat(response_parts, gpt_Suffixes[mood][random(4)]); }
            strcat(response_parts, part_Impossible[GetUnusedResponseIndex(part_Impossible_Used, sizeof(part_Impossible_Used))]);
            found_meaning = true;
        }
    }

    if(found_meaning) {
        new len = strlen(response_parts);
        if(len > 0) {
            new suffix_len = strlen(gpt_Suffixes[mood][random(4)]);
            if(len >= suffix_len && strfind(response_parts[len - suffix_len], gpt_Suffixes[mood][random(4)], false) != -1) {
                response_parts[len - suffix_len] = EOS;
            }
        }

        format(output, len_out, "%s", response_parts);

        if(random(100) < 50) {
            strcat(output, gpt_Suffixes[mood][random(4)]);
        } else if(output[strlen(output)-1] != '.') {
            strcat(output, ".");
        }

        format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "[Wira]: %s", output);
        return 1;
    }

    if(strlen(tempRequest) < 3) {
        format(output, len_out, "Слишком короткий запрос...");
    } else if(random(100) < 20) {
        format(output, len_out, "%s", part_Memes[GetUnusedResponseIndex(part_Memes_Used, sizeof(part_Memes_Used))]);
    } else {
        format(output, len_out, "%s", gpt_Unknown[GetUnusedResponseIndex(gpt_Unknown_Used, sizeof(gpt_Unknown_Used))]);
    }

    format(last_Wira_response[playerid], MAX_GPT_RESPONSE, "[Wira]: %s", output);
    return 1;
}

CMD:wira(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, 0xFF4444AA, "Использование: /wira [текст]");

    if(strlen(params) > MAX_USER_INPUT - 50)
        return SendClientMessage(playerid, 0xFF4444AA, "Ошибка: Слишком длинный запрос (макс. 200 символов)");

    new response[MAX_GPT_RESPONSE];
    new Float:response_time;
    new start_time = GetTickCount();

    GptGetCode(playerid, params, response, sizeof(response), response_time);

    new actual_time = GetTickCount() - start_time;
    new final_message[MAX_GPT_RESPONSE + 100];
    format(final_message, sizeof(final_message),
           "» [WiraAi] [{9AC0CD}%.2f мс{FFFFFF}] {9AC0CD}%s",
           actual_time > 0 ? actual_time : response_time * 1000, response);
    SendClientMessage(playerid, 0xFFFFFFFF, final_message);

    printf("[WIRA_AI] Запрос от %d: %s", playerid, params);
    printf("[WIRA_AI] Ответ: %s (время обработки: %.2f мс)", response, response_time * 1000);

    return 1;
}