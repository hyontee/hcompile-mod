#define MAX_SKIN_MODELS				700

enum _skin_data
{
	SKIN_REPLACE,
	SKIN_NAME [ 42 ],
	SKIN_PRICE,
	SKIN_CLASS,
	bool: SKIN_USED
} ;
new skin_data [ MAX_SKIN_MODELS ] [ _skin_data ] ;

stock getReplacableSkinModel ( playerid )
{
	new skinId = p_info [ playerid ] [ skin ], replaceId = 0 ;
	if ( skin_data [ skinId ] [ SKIN_REPLACE ] ) replaceId = skin_data [ skinId ] [ SKIN_REPLACE ] ;
	return replaceId ;
}

stock getNewSkinModel ( playerid )
{
	new skinId = p_info [ playerid ] [ skin ] ;
	return skinId ;
}

stock getValidReplacableSkinModel ( modelId )
{
	if ( ! skin_data [ modelId ] [ SKIN_USED ] ) return 0 ;

	new replaceId = modelId ;
	return replaceId ;
}

stock get_skin_name ( modelid )
{
    new model_name [ 42 ] ;
	switch ( modelid )
	{
	    case 0: strcat ( model_name, "Carl 'CJ' Johnson" ) ;
	    case 1: strcat ( model_name, "Мужчина в Off White" ) ; // shop / treasure
	    case 2: strcat ( model_name, "Молодой парень" ) ; // shop / treasure
	    case 3: strcat ( model_name, "Мужчина в химзащите" ) ;
	    case 4: strcat ( model_name, "Парень в Off White" ) ; // shop / treasure
	    case 5: strcat ( model_name, "Barry 'Big Bear' Thorne" ) ;
	    case 6: strcat ( model_name, "Парень в толстовке" ) ; // shop / treasure
	    case 7: strcat ( model_name, "Таксист" ) ; // shop / treasure
	    case 8: strcat ( model_name, "Админ-скин" ) ;
	    case 9: strcat ( model_name, "Неформальная девушка" ) ;  // shop / treasure
	    case 10: strcat ( model_name, "Строитель гастарбайтер" ) ;
	    case 11: strcat ( model_name, "Спортсменка" ) ;  // shop / treasure
	    case 12: strcat ( model_name, "Богатая Чика" ) ; // shop
	    case 13: strcat ( model_name, "Модная" ) ; // shop
	    case 14: strcat ( model_name, "МЧС Рядовой" ) ;
	    case 15: strcat ( model_name, "Пожарный Мужской" ) ;
	    case 16: strcat ( model_name, "МЧС Офицер" ) ;
	    case 17: strcat ( model_name, "Off White Red Jordan" ) ; // shop / treasure
	    case 18: strcat ( model_name, "Парень в свитшоте" ) ; // shop / treasure
	    case 19: strcat ( model_name, "Поклонник Цоя" ) ; // shop / treasure
	    case 20: strcat ( model_name, "Бизнесмен" ) ; // free case
	    case 21: strcat ( model_name, "Off White Mona" ) ; // shop / treasure
	    case 22: strcat ( model_name, "Парень в толстовке Суприм" ) ; // shop
	    case 23: strcat ( model_name, "Мужчине в кожанке" ) ; // shop
	    case 24: strcat ( model_name, "Рок-н-Ролл" ) ; // shop
	    case 25: strcat ( model_name, "Мистер Пин" ) ;
	    case 26: strcat ( model_name, "Парень в футболке" ) ; // shop
	    case 27: strcat ( model_name, "Рок-н-Ролл Red" ) ; // shop
	    case 28: strcat ( model_name, "Мужчина в деловой одежде" ) ; // shop
	    case 29: strcat ( model_name, "White Adidas" ) ; // shop
	    case 30: strcat ( model_name, "White Adidas Sport" ) ; // shop
	    case 31: strcat ( model_name, "Стриптизерша" ) ;
	    case 32: strcat ( model_name, "Гангстер в маске" ) ;
	    case 33: strcat ( model_name, "Мужчина в костюме" ) ; // shop
	    case 34: strcat ( model_name, "Мужчина в пальто" ) ; // shop
	    case 35: strcat ( model_name, "Уличный В Сапогах" ) ; // shop
	    case 36: strcat ( model_name, "Парень в Versace" ) ; // shop
	    case 37: strcat ( model_name, "Gucci" ) ; // shop
	    case 38: strcat ( model_name, "Путин" ) ; // case major
	    case 39: strcat ( model_name, "Валя Карнавал" ) ; // case major
	    case 40: strcat ( model_name, "Девушка в ночнушке" ) ; // shop
	    case 41: strcat ( model_name, "Девушка в купальнике" ) ; // shop
	    case 42: strcat ( model_name, "Спортсмен" ) ; // shop
	    case 43: strcat ( model_name, "Парень в рубашке Gucci" ) ; // shop
	    case 44: strcat ( model_name, "Парень в худи Off White Red" ) ; // shop
	    case 45: strcat ( model_name, "Парень в футболке Astro World" ) ; // shop
	    case 46: strcat ( model_name, "Мужчина в джинсовке" ) ;
	    case 47: strcat ( model_name, "Gucci White" ) ; // shop
	    case 48: strcat ( model_name, "Парень в Stone Island" ) ; // shop
	    case 49: strcat ( model_name, "Парень в костюме Gucci" ) ; // shop
	    case 50: strcat ( model_name, "Парень в свитере Gucci" ) ; // shop
	    case 51: strcat ( model_name, "Парень в пляжной рубашке" ) ; // shop
	    case 52: strcat ( model_name, "Томми Хилфигер" ) ; // shop
	    case 53: strcat ( model_name, "Девушка в толстовке" ) ; // shop
	    case 54: strcat ( model_name, "Пожарный Женский" ) ;
	    case 55: strcat ( model_name, "Секретарша" ) ;
	    case 56: strcat ( model_name, "МЧС Женский" ) ;
	    case 57: strcat ( model_name, "Мужчина в деловом стиле" ) ; // shop
	    case 58: strcat ( model_name, "Парень весь в Gucci" ) ; // shop
	    case 59: strcat ( model_name, "Мужчина в куртке КША" ) ;
	    case 60: strcat ( model_name, "Парень в футболке АнтиСоциалКлаб" ) ;
	    case 61: strcat ( model_name, "Парень в толстовке Vlone" ) ;
	    case 62: strcat ( model_name, "Мафиози в рубашке" ) ;
	    case 63: strcat ( model_name, "Девушка в рубашке" ) ; // shop
	    case 64: strcat ( model_name, "Даня Милохин" ) ;
	    case 65: strcat ( model_name, "Детектив" ) ;
	    case 66: strcat ( model_name, "Парень в кофте" ) ;
	    case 67: strcat ( model_name, "Парень в куртке Vlone" ) ;
	    case 68: strcat ( model_name, "Парень в толстовке Bape" ) ;
	    case 69: strcat ( model_name, "Зек Женский" ) ;
	    case 70: strcat ( model_name, "Врач" ) ;
	    case 71: strcat ( model_name, "Месси" ) ;
	    case 72: strcat ( model_name, "Парень в Dolce Gabbana" ) ;
	    case 73: strcat ( model_name, "Парень в шортах" ) ;
	    case 74: strcat ( model_name, "CJ" ) ;
	    case 75: strcat ( model_name, "Блондинка в шортах" ) ; // shop
	    case 76: strcat ( model_name, "Девушка в спортивном" ) ; // shop
	    case 77: strcat ( model_name, "Бомж(samp)" ) ;
	    case 78: strcat ( model_name, "Мужчина в Gucci" ) ;
	    case 79: strcat ( model_name, "Парень в в футболке" ) ;
	    case 80: strcat ( model_name, "Водолаз" ) ;
	    case 81: strcat ( model_name, "Моргенштерн" ) ; // case lambo
	    case 82: strcat ( model_name, "Парень в бомбере Off White" ) ;
	    case 83: strcat ( model_name, "Парень в футболке Bape" ) ;
	    case 84: strcat ( model_name, "Парень в худи Off White" ) ;
	    case 85: strcat ( model_name, "Спортсменка Puma" ) ; // shop
	    case 86: strcat ( model_name, "Мужик с дредами" ) ;
	    case 87: strcat ( model_name, "Неформальная девушка" ) ; // shop
	    case 88: strcat ( model_name, "Девушка в платье" ) ; // shop
		case 89: strcat ( model_name, "Леди" ) ; // shop
		case 90: strcat ( model_name, "Школьница" ) ;
		case 91: strcat ( model_name, "ДПС Женский" ) ;
		case 92: strcat ( model_name, "Мужик в черном бомбере" ) ; // treasure
		case 93: strcat ( model_name, "Капитан полиции женский" ) ;
		case 94: strcat ( model_name, "Мафиози в кожанке" ) ; // treasure
		case 95: strcat ( model_name, "Парень в спортивном" ) ; // treasure
		case 96: strcat ( model_name, "Парень в деловом костюме" ) ;
		case 97: strcat ( model_name, "Хипстер в Lacoste" ) ;
		case 98: strcat ( model_name, "Парень в худи AntiSocialClub" ) ;
		case 99: strcat ( model_name, "Таксист" ) ;
		case 100: strcat ( model_name, "Модник в бандане" ) ;
		case 101: strcat ( model_name, "Гантеля" ) ;
		case 102: strcat ( model_name, "Парень в черном" ) ;
		case 103: strcat ( model_name, "ДПС в жёлтом жилете" ) ;
		case 104: strcat ( model_name, "Гопник" ) ;
		case 105: strcat ( model_name, "Мафиози в костюме" ) ;
		case 106: strcat ( model_name, "Мафиози в кожанке" ) ;
		case 107: strcat ( model_name, "ДПС Майор" ) ;
		case 108: strcat ( model_name, "Полицейский(муж.)" ) ;
	    case 109: strcat ( model_name, "Мужчина в камуфляже" ) ;
	    case 110: strcat ( model_name, "Парень в Supreme Hat" ) ;
	    case 111: strcat ( model_name, "Мафиози в куртке" ) ;
	    case 112: strcat ( model_name, "Мафиози авторитет" ) ;
	    case 113: strcat ( model_name, "Мужик в ветровке" ) ;
	    case 114: strcat ( model_name, "Латиноамериканец бандит" ) ;
	    case 115: strcat ( model_name, "Полиция Майор" ) ;
	    case 116: strcat ( model_name, "Генерал МВД" ) ;
	    case 117: strcat ( model_name, "Босс" ) ;
	    case 118: strcat ( model_name, "ФСБ Security" ) ;
	    case 119: strcat ( model_name, "ФСБ Работник" ) ;
	    case 120: strcat ( model_name, "Директор ФСБ" ) ;
	    case 121: strcat ( model_name, "Мафиози 1" ) ;
	    case 122: strcat ( model_name, "Мафиози 2" ) ;
	    case 123: strcat ( model_name, "Гопник в Adidas" ) ;
	    case 124: strcat ( model_name, "Мафиози Boss" ) ;
	    case 125: strcat ( model_name, "Кавказец в куртке Russia" ) ;
	    case 126: strcat ( model_name, "Кавказец в худи Russia" ) ;
	    case 127: strcat ( model_name, "Мафиози кавказец 1" ) ;
	    case 128: strcat ( model_name, "Мафиози кавказец 2" ) ;
	    case 129: strcat ( model_name, "Дед Мороз" ) ;
	    case 130: strcat ( model_name, "Женщина в деловом" ) ;
	    case 131: strcat ( model_name, "ДПС Женский" ) ;
	    case 132: strcat ( model_name, "Призрачный гонщик" ) ;
	    case 133: strcat ( model_name, "Врач Дед" ) ;
	    case 134: strcat ( model_name, "Медбрат" ) ;
	    case 135: strcat ( model_name, "Врач 2" ) ;
	    case 136: strcat ( model_name, "Капитан армии" ) ;
	    case 137: strcat ( model_name, "Военный (Лейтенант)" ) ;
	    case 138: strcat ( model_name, "Наруто" ) ;
	    case 139: strcat ( model_name, "ФСБ женский" ) ;
	    case 140: strcat ( model_name, "Женщина офисная" ) ;
	    case 141: strcat ( model_name, "Женщина офисная" ) ;
	    case 142: strcat ( model_name, "Военный Рядовой" ) ;
	    case 143: strcat ( model_name, "Офисный Работник" ) ;
	    case 144: strcat ( model_name, "Офисный работник в свитере" ) ;
	    case 145: strcat ( model_name, "Медсестра" ) ;
	    case 146: strcat ( model_name, "Brad Pitt" ) ; // containers
	    case 147: strcat ( model_name, "Уличный в бриджах" ) ;
	    case 148: strcat ( model_name, "Женщина военный (полковник)" ) ;
	    case 149: strcat ( model_name, "Big Smoke A" ) ;
	    case 150: strcat ( model_name, "Женщина военный (майор)" ) ;
	    case 151: strcat ( model_name, "Медсестра" ) ;
	    case 152: strcat ( model_name, "Красный Костюм Женский" ) ;
	    case 153: strcat ( model_name, "Некоглай" ) ; // containers
	    case 154: strcat ( model_name, "Фейс" ) ; // containers
	    case 155: strcat ( model_name, "OG Buda" ) ; // containers
	    case 156: strcat ( model_name, "Илон Маск" ) ; // containers
	    case 157: strcat ( model_name, "Черный Бомбер" ) ;
	    case 158: strcat ( model_name, "Уличный Бомбер" ) ;
	    case 159: strcat ( model_name, "Литвин" ) ; // donate
	    case 160: strcat ( model_name, "Школьница Аниме" ) ; // donate
	    case 161: strcat ( model_name, "Блондин" ) ;
	    case 162: strcat ( model_name, "Офисная Красные Каблуки" ) ;
	    case 163: strcat ( model_name, "Охранник" ) ;
	    case 164: strcat ( model_name, "Руководитель Security" ) ;
	    case 165: strcat ( model_name, "Охранник в очках" ) ;
	    case 166: strcat ( model_name, "Охранник Темный" ) ;
	    case 167: strcat ( model_name, "Элджей" ) ;
	    case 168: strcat ( model_name, "Басков" ) ;
	    case 169: strcat ( model_name, "Корейка" ) ;
	    case 170: strcat ( model_name, "Серго" ) ; // donate
	    case 171: strcat ( model_name, "Бустер" ) ; // donate
	    case 172: strcat ( model_name, "Дима Масленников" ) ; // donate
	    case 173: strcat ( model_name, "Soda Luv" ) ;
	    case 174: strcat ( model_name, "Влад А4" ) ; // donate
	    case 175: strcat ( model_name, "Инкассатор" ) ;
	    case 176: strcat ( model_name, "Уличный Кожаный Бомбер" ) ;
	    case 177: strcat ( model_name, "Эминем" ) ;
	    case 178: strcat ( model_name, "Supreme Black" ) ;
	    case 179: strcat ( model_name, "Мужчина в костюме Gucci (спорт.)" ) ;
	    case 180: strcat ( model_name, "Мужчина в костюме Gucci (летний)" ) ;
	    case 181: strcat ( model_name, "Бабник" ) ;
	    case 182: strcat ( model_name, "Мужчина в бомбере Gucci" ) ;
	    case 183: strcat ( model_name, "Мужчина в шортах Gucci" ) ;
	    case 184: strcat ( model_name, "Мужчина в костюме Louis Vuitton" ) ;
	    case 185: strcat ( model_name, "Мужчина в макинтоше" ) ;
	    case 186: strcat ( model_name, "Хасбик" ) ; // donate
	    case 187: strcat ( model_name, "Инкассатор Женский" ) ;
	    case 188: strcat ( model_name, "Ева Эльфи(купальник)" ) ; // donate
	    case 189: strcat ( model_name, "Девушка в юбке" ) ;
	    case 190: strcat ( model_name, "Спортивная девушка" ) ;
	    case 191: strcat ( model_name, "Девушка в платье декольте" ) ;
	    case 192: strcat ( model_name, "Пляжная девушка" ) ;
	    case 193: strcat ( model_name, "Девушка в пижаме" ) ;
	    case 194: strcat ( model_name, "Девушка в леопардовом платье" ) ;
	    case 195: strcat ( model_name, "Девушка в татуировках" ) ;
	    case 196: strcat ( model_name, "Девушка с каре" ) ;
	    case 197: strcat ( model_name, "Девушка в чёрном" ) ;
	    case 198: strcat ( model_name, "Полуголая девушка" ) ;
	    case 199: strcat ( model_name, "Рабочий Комбинезон" ) ;
	    case 200: strcat ( model_name, "Полиция Лейтенант" ) ;
	    case 201: strcat ( model_name, "Офисная женщина" ) ;
	    case 202: strcat ( model_name, "Полиция Полковник" ) ;
	    case 203: strcat ( model_name, "ДПС в жилете 2" ) ;
	    case 204: strcat ( model_name, "Мужчина в синем костюме" ) ;
	    case 205: strcat ( model_name, "Полиция Майор (Женский)" ) ;
	    case 206: strcat ( model_name, "ДПС Мужской Ефрейтор" ) ;
	    case 207: strcat ( model_name, "Женщина хирург" ) ;
	    case 208: strcat ( model_name, "Полиция Ефрейтор" ) ;
	    case 209: strcat ( model_name, "Деловая женщина в белом" ) ;
	    case 210: strcat ( model_name, "Братишкин" ) ;
	    case 211: strcat ( model_name, "Офисная женщина" ) ;
	    case 212: strcat ( model_name, "Security (мужской)" ) ;
	    case 213: strcat ( model_name, "Деловой мужчина" ) ;
	    case 214: strcat ( model_name, "Мафия(женский)" ) ;
	    case 215: strcat ( model_name, "Прогулочный (женский)" ) ;
	    case 216: strcat ( model_name, "СМИ Женский") ;
	    case 217: strcat ( model_name, "Доктор" ) ;
	    case 218: strcat ( model_name, "Деловая Красный Галстук" ) ;
	    case 219: strcat ( model_name, "Армия (женский)" ) ;
	    case 220: strcat ( model_name, "Министр" ) ;
	    case 221: strcat ( model_name, "Главный Врач" ) ;
	    case 222: strcat ( model_name, "Деловой (Помощник)" ) ;
	    case 223: strcat ( model_name, "ФСБ в экипировке" ) ;
	    case 224: strcat ( model_name, "ФСБ Женский (Руководитель)"  ) ;
	    case 225: strcat ( model_name, "Бабка строитель (полная)" ) ;
	    case 226: strcat ( model_name, "Молодая девушка строитель" ) ;
	    case 227: strcat ( model_name, "Гопник Оранжевый Адидас" ) ;
	    case 228: strcat ( model_name, "Военный в экипировке" ) ;
	    case 229: strcat ( model_name, "Футбольный Фанат" ) ;
	    case 230: strcat ( model_name, "Военный в экипировке" ) ;
	    case 231: strcat ( model_name, "Парень в футболке") ;
	    case 232: strcat ( model_name, "Парень в джинсах" ) ;
	    case 233: strcat ( model_name, "Форма ОМОН(женская)" ) ;
	    case 234: strcat ( model_name, "Лысый в офисном") ;
	    case 235: strcat ( model_name, "Мужчина в офисном с бородой" ) ;
	    case 236: strcat ( model_name, "Ефрейтор армии" ) ;
	    case 237: strcat ( model_name, "Рабочая в каске (женский)" ) ;
	    case 238: strcat ( model_name, "Китаец" ) ;
	    case 239: strcat ( model_name, "Деловой White" ) ;
	    case 240: strcat ( model_name, "Строитель (мужской)" ) ;
	    case 241: strcat ( model_name, "Шахтер" ) ;
	    case 242: strcat ( model_name, "Форма ОМОН(мужская)" ) ;
	    case 243: strcat ( model_name, "Парень в бежевой куртке" ) ;
	    case 244: strcat ( model_name, "Мужчина с усами" ) ;
	    case 245: strcat ( model_name, "Лысый мужчина" ) ;
	    case 246: strcat ( model_name, "Программист" ) ;
	    case 247: strcat ( model_name, "Мужчина в бежевых штанах" ) ;
	    case 248: strcat ( model_name, "Шахтёр с фонариком") ;
	    case 249: strcat ( model_name, "Молодой рабочий (завод)" ) ;
	    case 250: strcat ( model_name, "Дед рабочий (завод)" ) ;
	    case 251: strcat ( model_name, "Рабочая(шахтерка)" ) ;
	    case 252: strcat ( model_name, "Валента в черном" ) ;
	    case 253: strcat ( model_name, "Новогодний Эльф" ) ;
	    case 254: strcat ( model_name, "Прогулочный каре (женский)" ) ;
	    case 255: strcat ( model_name, "Деловая С косой" ) ;
	    case 256: strcat ( model_name, "Домашний Red в клеточку" ) ;
	    case 257: strcat ( model_name, "Рабочая женский в жилете" ) ;
	    case 258: strcat ( model_name, "Прогулочная вв сапогах" ) ;
	    case 259: strcat ( model_name, "Прогулочная джинсовая" ) ;
	    case 260: strcat ( model_name, "Уличный Свободный" ) ;
	    case 261: strcat ( model_name, "Новогодний Эльф (мужской)" ) ;
	    case 262: strcat ( model_name, "Ева Эльфи (новогодняя)" ) ;
	    case 263: strcat ( model_name, "Рабочий жилет синий (мужской)" ) ;
	    case 264: strcat ( model_name, "Прогулочный с орлом" ) ;
	    case 265: strcat ( model_name, "Сиджей Red" ) ;
	    case 266: strcat ( model_name, "Officer Eddie Pu" ) ;
	    case 267: strcat ( model_name, "Officer Jimmy Hernandez" ) ;
	    case 268: strcat ( model_name, "Dwayne" ) ;
	    case 269: strcat ( model_name, "Melvin 'Big Smoke' Harris" ) ;
	    case 270: strcat ( model_name, "Sean 'Sweet' Johnson" ) ;
	    case 271: strcat ( model_name, "Дав" ) ; // gold roulette
	    case 272: strcat ( model_name, "Данила Бодров" ) ;
	    case 273: strcat ( model_name, "Генерал МВД (женский)" ) ;
	    case 274: strcat ( model_name, "Филип Киркоров" ) ; // gold roulette
	    case 275: strcat ( model_name, "Костя (Гопник)" ) ;
	    case 276: strcat ( model_name, "S1mple" ) ;
	    case 277: strcat ( model_name, "Уличный Простой" ) ;
	    case 278: strcat ( model_name, "Космо" ) ; // donate
	    case 279: strcat ( model_name, "Папич" ) ; // promo
	    case 280: strcat ( model_name, "Росгвардеец с дубинкой" ) ;
	    case 281: strcat ( model_name, "Праздничная" ) ;
	    case 282: strcat ( model_name, "Эвелон" ) ; // silver roulette
	    case 283: strcat ( model_name, "Зек черно-белый" ) ;
	    case 284: strcat ( model_name, "Байден" ) ; // silver roulette
	    case 285: strcat ( model_name, "Зек полный" ) ;
	    case 286: strcat ( model_name, "Тимати" ) ; // craft
	    case 287: strcat ( model_name, "Домашняя в бежевом" ) ; // craft
	    case 288: strcat ( model_name, "МЧС стажер (женский)" ) ;
	    case 289: strcat ( model_name, "Иван Золо" ) ; // donate
	    case 290: strcat ( model_name, "Егор Крид" ) ; // donate
	    case 291: strcat ( model_name, "Kent Paul" ) ; // craft
	    case 292: strcat ( model_name, "Тусовщица черные джинсы" ) ;
	    case 293: strcat ( model_name, "Вован" ) ; // donate
	    case 294: strcat ( model_name, "Пчёла" ) ; // donate
	    case 295: strcat ( model_name, "Черный Адидас Гопник" ) ;
	    case 296: strcat ( model_name, "Школьник" ) ; // donate
	    case 297: strcat ( model_name, "Зек в кепке (женский)" ) ;
	    case 298: strcat ( model_name, "Заведующая" ) ;
	    case 299: strcat ( model_name, "Los Santos Police" ) ;
	    case 300: strcat ( model_name, "Los Santos Police Officer" ) ;
	    case 301: strcat ( model_name, "San Fierro Police Officer" ) ;
	    case 302: strcat ( model_name, "Las Venturas Police Officer" ) ;
	    case 303: strcat ( model_name, "Los Santos Police Officer" ) ;
	    case 304: strcat ( model_name, "Los Santos Police Officer" ) ;
	    case 305: strcat ( model_name, "Las Venturas Police Officer" ) ;
	    case 306: strcat ( model_name, "Los Santos Police Officer" ) ;
	    case 307: strcat ( model_name, "San Fierro Police Officer" ) ;
	    case 308: strcat ( model_name, "San Fierro Paramedic" ) ;
	    case 309: strcat ( model_name, "Las Venturas Police Officer" ) ;
	    case 310: strcat ( model_name, "Country Sheriff" ) ;
	    case 311: strcat ( model_name, "Desert Sheriff" ) ;
	    default:strcat ( model_name, "Unknown" ) ;
	}
	return model_name ;
}